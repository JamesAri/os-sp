#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdrandom.h>
#include <stdmemory.h>
#include <kth-finder.h>

#include "model_defs.h"
#include "model_utils.h"

#include <drivers/bridges/uart_defs.h> 

uint32_t trng_file;
uint32_t uart_file;

// Tics in comments measured on Pop_Size = 10000 and Iterations = 100
// used for optimizing - measures duration (tics) of the callback fn 
void print_duration(void (*callback)(), const char *msg)
{
	char string_buffer[32];
	bzero(string_buffer, 32);
	
	uint32_t start, end;
	start = get_tick_count();
	callback();
	end = get_tick_count();

	fputs(uart_file, msg);
	fputs(uart_file, end - start);
}

constexpr uint32_t RecvBfrSize = 1000;
char receive_buffer[RecvBfrSize];

constexpr float Min_Init_Param_Rng = -15.0f;
constexpr float Max_Init_Param_Rng = 15.0f;
constexpr float Min_Mutation_Rng = -0.1f;
constexpr float Max_Mutation_Rng = 0.1f;

// napr. 1024 zaznamu... uzivatel zatim pise rucne do konzole, takze to snad bude stacit
constexpr unsigned int Lookup_Size = 1024;
unsigned int lookup_table_index = 0;
float lookup_table[Lookup_Size];

constexpr unsigned int Fitness_Vector_Size = Pop_Size * 2;
constexpr unsigned int Fitness_Vector_Size_Bytes = Fitness_Vector_Size * sizeof(float);

TChromosome current_chromosome;
TModel_Parameters model_parameters = {0, 0};

TChromosome *population_old;
TChromosome *population_new;
float *fitness;
float *tmp_fitness;

// allows us to use only one fitness vector and swap the pointers without copying the data:
// fitness_new vector pointing at the start of the fitness vector, swaps next iteration
float* fitness_new;
// fitness_old vector pointing in the middle of the fitness vector, swaps next iteration
float* fitness_old;

// minumum time so we can start training & predicting
unsigned int t_min;
// current time (last value in the lookup table corresponds to this time)
int t_current;

// =========== UTILS ===========

uint32_t get_random_param_index()
{
	return get_random_uint32(trng_file, 0, 5);
}

float get_random_param_value()
{
	return get_random_float(trng_file, Min_Init_Param_Rng, Max_Init_Param_Rng);
}

float get_random_mutation_value()
{
	return get_random_float(trng_file, Min_Mutation_Rng, Max_Mutation_Rng);
}

bool can_predict()
{
	bool has_enough_data = t_current >= model_parameters.t_delta + model_parameters.t_pred;
	bool has_model_params = model_parameters.t_delta > 0 && model_parameters.t_pred > 0;
	return has_enough_data && has_model_params;
}

// Copies new population to old population
void copy_population()
{
	for (int i = 0; i < Pop_Size; i++)
	{
		population_old[i] = population_new[i];
	}
}

void swap_fitness_vectors() 
{
	float* tmp = fitness_new;
	fitness_new = fitness_old;
	fitness_old = tmp;
}

void copy_array(float* from, float* to, int size) 
{
	for(int i = 0; i < size; i++) 
	{
		to[i] = from[i];
	}
}

// =========== MODEL ===========

int lookup(int t)
{
	return lookup_table[static_cast<int>(t / model_parameters.t_delta)];
}

float b(int t, float D, float E, int t_delta)
{
	const float diff = (lookup(t) - lookup(t - t_delta));
	return (D / E) * (diff / t_delta) + (1.0f / E) * lookup(t);
}

float y(int t, float A, float B, float C, float D, float E, int t_delta)
{
	const float b_t = b(t, D, E, t_delta);

	// TODO: extract b_t => reduce multiplication
	return A * b_t + B * b_t * (b_t - lookup(t)) + C;
}

float y(int t, TChromosome &chromosome, int t_delta)
{
	return y(t, chromosome.A, chromosome.B, chromosome.C, chromosome.D, chromosome.E, t_delta);
}

// 1.7k tics
void calculate_fitness()
{
	for(int t = t_min; t <= t_current; t += model_parameters.t_delta)
	{   
		// TODO: extract t-values here and pass them to y,b functions
		for(int i = 0; i < Pop_Size; i++)
		{
			// spocteme predikci v case (t - model_parameters.t_pred) a porovname s lookup(t) (aktualni hodnota)
			const float pred = y(t - model_parameters.t_pred, population_new[i].A, population_new[i].B, population_new[i].C, population_new[i].D, population_new[i].E, model_parameters.t_delta);
			// Optimization: Use ABS instead of MSE formula: (y-y')^2 - [3.5k tics to 1.7k tics]
			const float strength = pred - lookup(t);
			fitness_new[i] += (strength >= 0.0f) ? strength : -strength;
		}
	}
}

// 580 tics
void calculate_fitness_optimized() // Removed fn calls - [1.7k tics to 1k tics].
{
	for (int i = 0; i < Pop_Size; i++)
	{
		fitness_new[i] = 0.0f;
	}

	for(int t = t_min; t <= t_current; t += model_parameters.t_delta)
	{   
		// Extracted t-values here - [1k tics to 580 tics]

		// previous time: (t - prediction window)
		const float t_prev = t - model_parameters.t_pred;

		// current glucose level in time t
		const float val_t = lookup_table[static_cast<int>(t / model_parameters.t_delta)];

		// index of previous time in lookup table
		const unsigned int index = static_cast<int>(t_prev / model_parameters.t_delta);

		// glucose level in previous time
		const float val_t_prev = lookup_table[index];

		// same as: lookup_table[static_cast<int>((t_prev-model_parameters.t_delta) / model_parameters.t_delta)];
		const float val_t_prev_minus_delta = lookup_table[index - 1];

		// difference between time <t> and previous glucose level
		const float val_t_prev_diff = val_t_prev - val_t_prev_minus_delta;
		
		for(int i = 0; i < Pop_Size; i++)
		{
			// spocteme predikci v case (t - t_pred) a porovname s opravdovou hodnotou v case t.
			// b()
			const float b_t = (population_new[i].D / population_new[i].E) * (val_t_prev_diff / model_parameters.t_delta) + (1.0f / population_new[i].E) * val_t_prev;
			// y()
			const float pred = population_new[i].A * b_t + population_new[i].B * b_t * (b_t - val_t_prev) + population_new[i].C;
			
			// Optimization: Use ABS instead of MSE formula: (y-y')^2 - [3.5k tics to 1.7k tics]
			const float strength = pred - val_t;
			fitness_new[i] += (strength >= 0.0f) ? strength : -strength;
		}
	}
}

// 1k-5k tics (better performance when fitness vector partially sorted)
void select() 
{
	copy_array(fitness, tmp_fitness, Fitness_Vector_Size);
	// memcpy(fitness, tmp_fitness, Fitness_Vector_Size_Bytes);
	
	// find fitness vector median (top 1/2 population), mutates the vector, thus the copy
	const float median = Kth_Finder::findKthLargest(tmp_fitness, Fitness_Vector_Size, Pop_Size);
	
	int index = 0;

	// Select the best chromosomes from both old and new population
	for (int i = 0; i < Pop_Size; i++)
	{
		if (fitness_new[i] <= median)
		{
			fitness_new[index] = fitness_new[i];
			population_new[index] = population_new[i];
			index++;
			if(index >= Pop_Size) break;
		}
		if (fitness_old[i] <= median)
		{
			fitness_new[index] = fitness_old[i];
			population_new[index] = population_old[i];
			index++;
			if(index >= Pop_Size) break;
		}
	}
}

// 170 tics
void crossover()
{	
	// TODO: could shuffle the new population

	// Optimization: generate one random parameter index for the whole population and use the
	// for-loop index as an offset - [900 tics to 170 tics]
	const unsigned int rnd_index = get_random_param_index();

	for(int i = 1; i < Pop_Size; i+=2) 
	{
		TChromosome &child = population_new[i-1];
		TChromosome &parent = population_new[i];

		// randomly select number of parameters to copy from parent to child, min 2, max 3
		// OFF for better performance (always crossover only 2 parameters) - [3.5k tics to 1.8k tics]
		// int num_of_parameters = 2 + get_random_uint32(trng_file) % 2;
		
		const unsigned int index = (rnd_index + i) % 5;

		switch(static_cast<EChromosome_Parameters>(index)) 
		{
			case EChromosome_Parameters::A:
				child.A = parent.A;
				break;
			case EChromosome_Parameters::B:
				child.B = parent.B;
				break;
			case EChromosome_Parameters::C:
				child.C = parent.C;
				break;
			case EChromosome_Parameters::D:
				child.D = parent.D;
				break;
			case EChromosome_Parameters::E:
				child.E = parent.E;
				break;	
			default:
				break;
		}
		// removed for-loop (which generated random indexes) for better performance 
		// and added hardcoded offset for the second parameter - [1.8k tics to 900 tics]
		switch(static_cast<EChromosome_Parameters>((index + 3) % 5)) 
		{
			case EChromosome_Parameters::A:
				child.A = parent.A;
				break;
			case EChromosome_Parameters::B:
				child.B = parent.B;
				break;
			case EChromosome_Parameters::C:
				child.C = parent.C;
				break;
			case EChromosome_Parameters::D:
				child.D = parent.D;
				break;
			case EChromosome_Parameters::E:
				child.E = parent.E;
				break;	
			default:
				break;
		}
	}
}

// 200 tics
void mutate()
{	
	// Optimization: generate one mutation float for each param (not optimal :/) - [3.3k tics to 1.8k tics]
	float rnd_val_A = get_random_mutation_value();
	float rnd_val_B = get_random_mutation_value();
	float rnd_val_C = get_random_mutation_value();
	float rnd_val_D = get_random_mutation_value();
	float rnd_val_E = get_random_mutation_value();

	uint32_t rnd_index = get_random_param_index();

	// iterate over the population and mutate each chromosome
	for(int i = 0; i < Pop_Size; i++)
	{
		// Optimization: instead of generating new random parameter index for each chromosome, generate one and use the 
		// for-loop index as an offset - [1.8k tics to 200 tics]
		// could also use rnd_index = (rnd_index + i) mod 5, but there would be some indexes in disadvantage
		switch(static_cast<EChromosome_Parameters>((rnd_index + i) % 5)) 
		{
			case EChromosome_Parameters::A:
				population_new[i].A += rnd_val_A;
				break;
			case EChromosome_Parameters::B:
				population_new[i].B += rnd_val_B;
				break;
			case EChromosome_Parameters::C:
				population_new[i].C += rnd_val_C;
				break;
			case EChromosome_Parameters::D:
				population_new[i].D += rnd_val_D;
				break;
			case EChromosome_Parameters::E:
				population_new[i].E += rnd_val_E;
				break;	
			default:
				break;
		}
	}
}

void next_generation()
{	
	// Copy new population to old population array:
	copy_population(); 
	// print_duration(copy_population, "copy_population duration: ");

	// Since new population got copied to the old one, we need to swap the fitness pointers.
	// Swap the new fitness pointer with the old fitness pointer:
	// fitness vector before: [-----fitness_old-----|-----fitness_new-----]
	// fitness vector after:  [-----fitness_new-----|-----fitness_old-----]
	// the [-----fitness_new-----] will be overwritten in next steps.
	swap_fitness_vectors();
	// print_duration(swap_fitness_vectors, "swap_fitness_vectors duration: ");

	// Crossover the new population
	crossover();
	// print_duration(crossover, "crossover duration: ");

	// Mutate the new population
	mutate();
	// print_duration(mutate, "mutate duration: ");

	// Calculate fitness for the new population
	calculate_fitness_optimized();
	// print_duration(calculate_fitness_optimized, "calculate_fitness_optimized duration: ");

	// Select the best chromosomes from old + new population
	select();
	// print_duration(select, "select duration: ");
}

// =========== INIT ===========

// finds and sets the best chromosome from the fitness vector
// after selection, the best chromosome is in the new population (new fitness vector)
uint32_t find_best_chromosome()
{	
	// since we take the best from old and new, we need to update the
	// old chromosomes which have now old fitness values
	calculate_fitness_optimized();

	int best_chromosome_index = 0;
	for (int i = 1; i < Pop_Size; i++)
	{
		if (fitness_new[i] < fitness_new[best_chromosome_index])
		{
			best_chromosome_index = i;
		}
	}
	current_chromosome = population_new[best_chromosome_index];

	return best_chromosome_index;
}

void print_results() 
{
	const uint32_t best_chromosome_index = find_best_chromosome();

	// print the best chromosome
	print_chromosome(uart_file, current_chromosome);

	// print the best chromosome's fitness
	fputs(uart_file, "Best fitness: ");
	fputs(uart_file, fitness_new[best_chromosome_index]);

	// print predicted glucose level in x mins
	fputs(uart_file, "Predicted glucose level in ");
	fputs(uart_file, model_parameters.t_pred, false);
	fputs(uart_file, " mins (at ");
	fputs(uart_file, static_cast<uint32_t>(t_current + model_parameters.t_pred), false);
	fputs(uart_file, " mins): ");
	const float pred = y(t_current, current_chromosome, model_parameters.t_delta);
	fputs(uart_file, pred);
}

// pozn. tady mozna bude lepsi vytvorit nejakou kernel podporu pro cteni celych radek...
// returns true if should stop
// false otherwise
bool check_for_stop_command()
{	
	uint32_t v = fgets(uart_file, receive_buffer, RecvBfrSize);
	receive_buffer[strcspn(receive_buffer, "\r\n")] = '\0'; // remove LF, CR, CRLF, LFCR, ...

	static char temp_bfr[6];
	static unsigned int temp_bfr_index = 0;

	if (v > 0)
	{
		if (v < RecvBfrSize) receive_buffer[v] = '\0';
		else receive_buffer[RecvBfrSize-1] = '\0';

		for (int i = 0; i < v; i++)
		{
			temp_bfr[temp_bfr_index++] = receive_buffer[i];
			
			if(temp_bfr_index == 5)
			{
				temp_bfr_index = 0;

				// null-terminating character must be at index 5 ( strlen("stop")+1) )
				if (temp_bfr[5] == '\0')
				{
					if (strncmp(temp_bfr, "stop") == 0)
					{
						fputs(uart_file, "Received STOP command!\r\n");
						fputs(uart_file, "Stopping training phase!\r\n");
						return true;
					}
				}

				fputs(uart_file, "Only \"stop\" command allowed during training.\r\n");
				fputs(uart_file, "Training will resume shortly...\"");
				sleep(20000);
				return false;
			}
		}
	}

	return false;
}

void reset_model()
{
	for (int i = 0; i < Pop_Size; i++)
	{
		population_new[i].A = get_random_param_value();
		population_new[i].B = get_random_param_value();
		population_new[i].C = get_random_param_value();
		population_new[i].D = get_random_param_value();
		population_new[i].E = get_random_param_value();
	}

	calculate_fitness_optimized();
	current_chromosome = population_new[0];
}

// will print the difference (absolute value) between predicted and actual value for each time in the lookup table
void compare_in_time()
{
	for(int t = t_min; t <= t_current; t += model_parameters.t_delta)
	{
		const float pred = y(t - model_parameters.t_pred, current_chromosome, model_parameters.t_delta);
		const float actual = lookup(t);
		float diff = pred - actual;
		diff = (diff >= 0.0f) ? diff : -diff;

		fputs(uart_file, "Time: ");
		fputs(uart_file, t, false);
		fputs(uart_file, " min(s)\r\n");
		fputs(uart_file, "Predicted: ");
		fputs(uart_file, pred);
		fputs(uart_file, "Actual: ");
		fputs(uart_file, actual);
		fputs(uart_file, "Difference: ");
		fputs(uart_file, diff);
	}
}

void wait_for_new_input()
{
	while(true) 
	{
		uint32_t v = fgets(uart_file, receive_buffer, RecvBfrSize);

		if (v > 0)
		{
			if (v < RecvBfrSize) receive_buffer[v] = '\0';
			else receive_buffer[RecvBfrSize-1] = '\0';

			receive_buffer[strcspn(receive_buffer, "\r\n")] = '\0'; // remove LF, CR, CRLF, LFCR, ...

			if (is_float(receive_buffer))
			{	
				if (model_parameters.t_delta <= 0 && is_int(receive_buffer))
				{	
					int recv_val = atoi(receive_buffer);
					if (recv_val <= 0)
					{
						fputs(uart_file, "Time delta must be greater than 0!\r\n");
						continue;
					}
					model_parameters.t_delta = recv_val;
					fputs(uart_file, "Received new time delta!\r\n");
					fputs(uart_file, "Time delta: ");
					fputs(uart_file, model_parameters.t_delta, false);
					fputs(uart_file, " min(s)\r\n");
					fputs(uart_file, "Now input prediction window!\r\n");
					continue;
				}
				else if (model_parameters.t_pred <= 0 && is_int(receive_buffer))
				{
					int recv_val = atoi(receive_buffer);
					if (recv_val <= 0)
					{
						fputs(uart_file, "Prediction window must be greater than 0!\r\n");
						continue;
					}
					else if (recv_val < model_parameters.t_delta)
					{
						fputs(uart_file, "Prediction window must be greater than time delta!\r\n");
						continue;
					}
					else if (recv_val % model_parameters.t_delta != 0)
					{
						fputs(uart_file, "Prediction window must be divisible by time delta!\r\n");
						continue;
					}

					model_parameters.t_pred = recv_val;
					fputs(uart_file, "Received new prediction window!\r\n");
					fputs(uart_file, "Prediction window: ");
					fputs(uart_file, model_parameters.t_pred, false);
					fputs(uart_file, " min(s)\r\n");

					t_min = static_cast<int>(model_parameters.t_delta + model_parameters.t_pred);
					const int needed_values_cnt = static_cast<int>(t_min / model_parameters.t_delta) + 1;
					t_current = -model_parameters.t_delta;

					fputs(uart_file, "Now input glucose values!\r\n");
					fputs(uart_file, "Need ");
					fputs(uart_file, needed_values_cnt, false);
					fputs(uart_file, " more glucose values before the model can begin training and prediction.\r\n");

					continue;
				}
				else if (model_parameters.t_pred <= 0 || model_parameters.t_delta <= 0)
				{

					fputs(uart_file, "First input time delta and then prediction window.\r\n");
					continue;
				}

				fputs(uart_file, "Received new glucose VALUE!\r\n");

				float recv_float = atof(receive_buffer);
				fputs(uart_file, "Received value: ");
				fputs(uart_file, recv_float);
				
				// save to lookup table
				t_current += model_parameters.t_delta;
				lookup_table[lookup_table_index++] = atof(receive_buffer);
				break;
			}
			else if (strncmp(receive_buffer, "help") == 0)
			{
				fputs(uart_file, "Received HELP command!\r\n\r\n");

				fputs(uart_file, "Available commands: \"time\", \"lookup\", \"stop\", \"parameters\", \"reset\", \"retrain\", \"debug\" \r\n\r\n");
				
				fputs(uart_file, "lookup - prints current lookup table (saved values)\r\n");
				fputs(uart_file, "time - prints current time (the last value in the lookup table corresponds to this time)\r\n");
				fputs(uart_file, "stop - stops training phase\r\n");
				fputs(uart_file, "parameters - prints current model parameters (A, B, C, D, E)\r\n");
				fputs(uart_file, "reset - resets the model (keeps lookup table, current time, prediction window, time delta)\r\n");
				fputs(uart_file, "retrain - retrain the model with current data and population\r\n");
				
				fputs(uart_file, "debug - prints debug commands\r\n");
				
				fputs(uart_file, "\r\n");
			}
			else if (strncmp(receive_buffer, "time") == 0)
			{
				fputs(uart_file, "Received TIME command!\r\n");

				if (t_current < 0)
				{
					fputs(uart_file, "No input provided yet (waiting for value at minute 0).\r\n");
					continue;
				}

				fputs(uart_file, "Current time (we have value for this time): ");
				fputs(uart_file, t_current, false);
				fputs(uart_file, " min(s)\r\n");
			}
			else if (strncmp(receive_buffer, "lookup") == 0)
			{
				fputs(uart_file, "Received LOOKUP command!\r\n");
				fputs(uart_file, "[ ");
				for (int i = 0; i < lookup_table_index; i++)
				{
					fputs(uart_file, lookup_table[i], false);
					if (i < lookup_table_index - 1)
					{
						fputs(uart_file, ", ");
					}
					else 
					{
						fputs(uart_file, " ");						
					}
				}
				fputs(uart_file, "]\r\n");

			}
			else if (strncmp(receive_buffer, "stop") == 0)
			{
				fputs(uart_file, "Received STOP command!\r\n");
				fputs(uart_file, "Stop command allowed only during model training, which is not running now.\r\n");

			}
			else if (strncmp(receive_buffer, "parameters") == 0)
			{
				fputs(uart_file, "Received PARAMETERS command!\r\n");
				if (can_predict())
				{
					print_model_parameters(uart_file, model_parameters);
					print_chromosome(uart_file ,current_chromosome);
				}
				else
				{
					fputs(uart_file, "Model not trained yet, provide some input.\r\n");
				}
			}
			else if (strncmp(receive_buffer, "reset") == 0)
			{
				fputs(uart_file, "Received RESET command!\r\n");

				reset_model();

				fputs(uart_file, "Model reset! (Data kept: lookup table, current time, prediction window, time delta)\r\n");
			}
			else if (strncmp(receive_buffer, "retrain") == 0)
			{
				fputs(uart_file, "Received RETRAIN command!\r\n");
				if (can_predict())
				{
					fputs(uart_file, "Model will use current data and population to retrain.\r\n");
					fputs(uart_file, "If you think the model is stuck at some local minimum, try to use the \"reset\" command and then retrain.\r\n");
					sleep(20000);
					break;
				}
				fputs(uart_file, "Model cannot be trained yet, provide some input please.\r\n");
			}
			else if (strncmp(receive_buffer, "debug") == 0)
			{
				fputs(uart_file, "Received DEBUG command!\r\n\r\n");

				fputs(uart_file, "Available commands for debugging: \"compare\", \"settings\" \r\n\r\n");

				fputs(uart_file, "compare - prints the difference (absolute value) between predicted and actual value for each time in the lookup table\r\n");
				fputs(uart_file, "settings - prints current model settings\r\n");

				fputs(uart_file, "\r\n");
			}
			else if (strncmp(receive_buffer, "compare") == 0)
			{
				fputs(uart_file, "Received COMPARE command!\r\n");

				if (can_predict())
				{
					compare_in_time();
				}
				else
				{
					fputs(uart_file, "Model not trained yet, user has to provide some input.\r\n");
				}
			}
			else if (strncmp(receive_buffer, "settings") == 0)
			{
				fputs(uart_file, "Received SETTINGS command!\r\n");

				fputs(uart_file, "Population: ");
				fputs(uart_file, Pop_Size);

				fputs(uart_file, "Iterations: ");
				fputs(uart_file, Iterations);
			}
			else
			{
				fputs(uart_file, "Received UNKNOWN command!\r\n");
				fputs(uart_file, "Unknown command: \"");
				fputs(uart_file, receive_buffer);
				fputs(uart_file, "\"\r\n");
				fputs(uart_file, "For list of commands type: \"help\"\r\n");
			}
		}
		else
		{
			wait(uart_file);
		}
	}
}

void init_uart()
{
	uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
	if (uart_file == Invalid_Handle) return;
	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
	params.char_length = NUART_Char_Length::Char_8;
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
	fputs(uart_file, "Task starting!\r\n");
}

void init_trng()
{
	trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
}

void init_buffers()
{
	population_old = static_cast<TChromosome*>(sbrk(Pop_Size * sizeof(TChromosome)));
	population_new = static_cast<TChromosome*>(sbrk(Pop_Size * sizeof(TChromosome)));
	fitness = static_cast<float*>(sbrk(Fitness_Vector_Size * sizeof(float)));
	tmp_fitness = static_cast<float*>(sbrk(Fitness_Vector_Size * sizeof(float)));

	fitness_new = fitness;
	fitness_old = fitness_new + Pop_Size;
}

uint32_t init_globals()
{	
	bzero(receive_buffer, RecvBfrSize);
	
	init_uart();
	if (uart_file == Invalid_Handle)
	{
		return FAILURE;
	} 	

	init_trng();
	if (trng_file == Invalid_Handle)
	{
		close(uart_file);
		return FAILURE;
	} 

	fputs(uart_file, "Initializing buffer!\r\n");
	init_buffers();
	fputs(uart_file, "Buffers Initialized!\r\n");
	
	return SUCCESS;
}

int main()
{
	if(init_globals() == FAILURE)
	{
		return FAILURE;
	}

	fputs(uart_file, "Single-Task job, KIV-RTOS skeleton\r\n");
	fputs(uart_file, "Author: Slechta Jakub (A23N0026P)\r\n");
	fputs(uart_file, "First input time delta (t_delta) and then prediction window (t_pred).\r\n");
	fputs(uart_file, "For list of commands type: \"help\"\r\n");

	fputs(uart_file, "Initialization done! Waiting for user input!\r\n");

	while (!can_predict()) // because of the prediction formula
	{
		wait_for_new_input();
	}

	reset_model();

	while(true)
	{
		for(int i = 0; i < Iterations; i++) 
		{
			next_generation();

			// print progress in percentage
			if (((i+1) * 100) % Iterations == 0)
			{
				fputs(uart_file, "Progress: ");
				fputs(uart_file, static_cast<uint32_t>((i+1) * 100 / Iterations), false);
				fputs(uart_file, "%\r\n");
			}
			if(check_for_stop_command())
			{	
				// rn. there will be a bug when user retrains (by "retrain" command) - he will be allowed to 
				// "remove" values from lookup table one by one by abusing the stop command.
				// but since it doesn't break anything, I will leave it for now.
				lookup_table_index--;
				wait_for_new_input();
				continue;
			}
		}

		fputs(uart_file, "Training phase done!\r\n");
		
		// print results
		print_results();
		
		// wait for new input
		wait_for_new_input();
	}

	return SUCCESS;
}
