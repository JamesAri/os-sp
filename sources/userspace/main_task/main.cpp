#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdrandom.h>
#include <stdmemory.h>
#include <kth-finder.h>

#include "defs.h"

#include <drivers/bridges/uart_defs.h> 


static void fputs(uint32_t file, const char* string)
{
	write(file, string, strlen(string));
}

static uint32_t fgets(uint32_t file, char* buffer, uint32_t size)
{
	return read(file, buffer, size);
}

constexpr uint32_t RecvBfrSize = 1000;
// for number to string conversions
constexpr uint32_t StringBfrSize = 32;

uint32_t trng_file;
uint32_t uart_file;
char receive_buffer[RecvBfrSize];
char string_buffer[StringBfrSize];

void init_uart()
{
	uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
	if (uart_file == Invalid_Handle) return;
	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
	params.char_length = NUART_Char_Length::Char_8;
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
	fputs(uart_file, "TEST task starting!\r\n");
}

void init_trng()
{
	trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
}

// =============================================================

void print_duration(void (*callback)(), const char *msg)
{
	uint32_t start, end;
	start = get_tick_count();
	callback();
	end = get_tick_count();

	fputs(uart_file, msg);
	itoa(end - start, string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

enum class EChromosome_Parameters
{
	A = 0,
	B = 1,
	C = 2,
	D = 3,
	E = 4
};

struct TChromosome
{
	float A;
	float B;
	float C;
	float D;
	float E;
};

struct TModel_Parameters
{
	int t_delta;
	int t_pred;
};

TChromosome current_chromosome = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f};

TModel_Parameters model_parameters = {5, 15};

// TICS MEASURED ON Pop_Size = 10000 and Iterations = 100

constexpr int Pop_Size = 2000;
constexpr int Iterations = 200;

// napr. 1024 zaznamu... uzivatel zatim pise rucne do konzole, takze to snad bude stacit
constexpr unsigned int Lookup_Size = 1024;
unsigned int lookup_table_index = 0;

constexpr float Min_Init_Param_Rng = -15.0f;
constexpr float Max_Init_Param_Rng = 15.0f;
constexpr float Min_Mutation_Rng = -0.1f;
constexpr float Max_Mutation_Rng = 0.1f;

// minimum time to start predicting
// unsigned int lookup_table_min_size = (model_parameters.t_pred / model_parameters.t_delta) + 1;

float lookup_table[Lookup_Size];

unsigned int T_MIN = model_parameters.t_delta + model_parameters.t_pred;
int t_current;

constexpr unsigned int Fitness_Vector_Size = Pop_Size * 2;
constexpr unsigned int Fitness_Vector_Size_Bytes = Fitness_Vector_Size * sizeof(float);

TChromosome *population_old;
TChromosome *population_new;
float *fitness;
float *tmp_fitness;

// allows us to use only one fitness vector and swap the pointers without copying the data:
// fitness_new vector pointing at the start of the fitness vector, swaps next iteration
float* fitness_new;
// fitness_old vector pointing in the middle of the fitness vector, swaps next iteration
float* fitness_old;

// float lookup_table[Lookup_Size] = {
// 	13.457f,
// 	13.800f,
// 	13.400f,
// 	13.000f,
// 	12.600f,
// 	12.200f,
// 	11.800f,
// 	11.600f,
// };


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

int lookup(int t)
{
	return lookup_table[static_cast<int>(t / model_parameters.t_delta)];
}

bool can_predict()
{
	return t_current >= model_parameters.t_delta + model_parameters.t_pred;
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

// 1.7k tics
void calculate_fitness()
{
	for(int t = T_MIN; t <= t_current; t += model_parameters.t_delta)
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
	for(int t = T_MIN; t <= t_current; t += model_parameters.t_delta)
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
	// Optimization: generate one mutation float for the whole population - [3.3k tics to 1.8k tics] :-(
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
		// could also use rnd_index = (rnd_index + i) mod 5
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
	// =========== PRESERVE OLD POPULATION: NEW --> OLD ===========

	// Copy new population to old population array:
	copy_population(); // TODO optimize
	// print_duration(copy_population, "copy_population duration: ");

	// Since new population got copied to the old one, we need to swap the fitness pointers.
	// Swap the new fitness pointer with the old fitness pointer:
	// fitness vector before: [-----fitness_old-----|-----fitness_new-----]
	// fitness vector after:  [-----fitness_new-----|-----fitness_old-----]
	// the [-----fitness_new-----] will be overwritten in the next steps.
	swap_fitness_vectors();
	// print_duration(swap_fitness_vectors, "swap_fitness_vectors duration: ");

	
	// =========== CREATING NEW POPULATION (crossover, mutation, fitness) ===========

	crossover();
	// print_duration(crossover, "crossover duration: ");
	mutate();
	// print_duration(mutate, "mutate duration: ");
	calculate_fitness_optimized();
	// print_duration(calculate_fitness_optimized, "calculate_fitness_optimized duration: ");


	// =========== SELECTING BEST POPULATION ===========

	// Select the best chromosomes from old + new population.
	select();
	// print_duration(select, "select duration: ");
}

// =========== INIT ===========

void print_current_chromosome() 
{
	fputs(uart_file, "Current parameters: \r\n");
	fputs(uart_file, "A: ");
	ftoa(current_chromosome.A, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "B: ");
	ftoa(current_chromosome.B, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "C: ");
	ftoa(current_chromosome.C, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "D: ");
	ftoa(current_chromosome.D, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "E: ");
	ftoa(current_chromosome.E, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

void print_results() 
{
	// find the best chromosome in fitness vector - after selection, the best
	// chromosome is in the new population
	int best_chromosome_index = 0;
	for (int i = 1; i < Pop_Size; i++)
	{
		if (fitness_new[i] < fitness_new[best_chromosome_index])
		{
			best_chromosome_index = i;
		}
	}
	
	current_chromosome = population_new[best_chromosome_index];

	// print the best chromosome
	print_current_chromosome();

	// print the best fitness
	fputs(uart_file, "Best fitness: ");
	ftoa(fitness_new[best_chromosome_index], string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	// print info about model and some debug info
	fputs(uart_file, "Population: ");
	itoa(Pop_Size, string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "Iterations: ");
	itoa(Iterations, string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "Predicted glucose level that should match the last input: ");
	ftoa(y(t_current - model_parameters.t_pred, current_chromosome.A, current_chromosome.B, current_chromosome.C, current_chromosome.D, current_chromosome.E, model_parameters.t_delta), string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	// Print predicted glucose level in 15 mins
	fputs(uart_file, "Predicted glucose level in 15 mins (at ");
	itoa((t_current + model_parameters.t_pred), string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, " mins): ");
	ftoa(y(t_current, current_chromosome.A, current_chromosome.B, current_chromosome.C, current_chromosome.D, current_chromosome.E, model_parameters.t_delta), string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

void print_params()
{
	if (can_predict())
	{
		print_current_chromosome();
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

			fputs(uart_file, "New input received!\r\n");
			
			char string_copy[RecvBfrSize];
			strncpy(string_copy, receive_buffer, RecvBfrSize);
			string_copy[strcspn(string_copy, "\r\n")] = '\0'; // remove LF, CR, CRLF, LFCR, ...

			if (is_float(string_copy))
			{	
				fputs(uart_file, "Received new VALUE!\r\n");
				float recv_float = atof(string_copy);
				ftoa(recv_float, string_buffer);
				fputs(uart_file, "Value: ");
				fputs(uart_file, string_buffer);
				fputs(uart_file, "\r\n");
				
				// save to lookup table
				t_current += model_parameters.t_delta;
				lookup_table[lookup_table_index++] = atof(string_copy);
				break;
			}
			else if (strncmp(string_copy, "time") == 0)
			{
				fputs(uart_file, "Received TIME command!\r\n");

				if (t_current < 0)
				{
					fputs(uart_file, "No input provided yet (waiting for value at minute 0).\r\n");
					continue;
				}

				fputs(uart_file, "Current time (we have value for this time): ");
				itoa(t_current, string_buffer, 10);
				fputs(uart_file, string_buffer);
				fputs(uart_file, " min(s)\r\n");
			}
			else if (strncmp(string_copy, "lookup") == 0)
			{
				fputs(uart_file, "Received LOOKUP command!\r\n");
				fputs(uart_file, "[ ");
				for (int i = 0; i < lookup_table_index; i++)
				{
					ftoa(lookup_table[i], string_buffer);
					fputs(uart_file, string_buffer);
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
			else if (strncmp(string_copy, "stop") == 0)
			{
				fputs(uart_file, "Received STOP command!\r\n");
			}
			else if (strncmp(string_copy, "parameters") == 0)
			{
				fputs(uart_file, "Received PARAMETERS command!\r\n");
				print_params();
			}
			else
			{
				fputs(uart_file, "Received UNKNOWN command!\r\n");
				// print the UNKNOWN command
				fputs(uart_file, "Unknown command: \"");
				fputs(uart_file, string_copy);
				fputs(uart_file, "\"\r\n");
			}
		} 
		else 
		{
			fputs(uart_file, "Waiting for new input...\r\n");
			wait(uart_file);
		}
	}
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

void init_population()
{
	for (int i = 0; i < Pop_Size; i++)
	{
		population_new[i].A = get_random_param_value();
		population_new[i].B = get_random_param_value();
		population_new[i].C = get_random_param_value();
		population_new[i].D = get_random_param_value();
		population_new[i].E = get_random_param_value();
	}
}

void init_model()
{
	t_current = -5;
	init_population();
	current_chromosome = population_new[0];
}

uint32_t init_globals()
{
	bzero(receive_buffer, RecvBfrSize);
	bzero(string_buffer, StringBfrSize);
	
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

	fputs(uart_file, "INITIALIZING BUFFERS!\r\n");
	init_buffers();
	fputs(uart_file, "BUFFERS INITIALIZED!\r\n");
	
	return SUCCESS;
}

uint32_t init()
{
	if(init_globals())
	{
		return FAILURE;
	}

	init_model();
	return SUCCESS;
}

int main()
{
	if(init() == FAILURE)
	{
		return FAILURE;
	}

	fputs(uart_file, "Initialization done! Waiting for user input!\r\n");

	while (!can_predict()) // because of the prediction formula
	{
		wait_for_new_input();
	}

	calculate_fitness_optimized();

	while(true)
	{
		for(int i = 0; i < Iterations; i++) 
		{
			next_generation();

			// print progress in percentage
			if (((i+1) * 100) % Iterations == 0)
			{
				fputs(uart_file, "Progress: ");
				itoa((i+1) * 100 / Iterations, string_buffer, 10);
				fputs(uart_file, string_buffer);
				fputs(uart_file, "%\r\n");
			}
		}

		fputs(uart_file, "Iteration done!\r\n");
		
		// print current time
		fputs(uart_file, "Current time: ");
		itoa(t_current, string_buffer, 10);
		fputs(uart_file, string_buffer);
		fputs(uart_file, "\r\n");
		
		// print results
		print_results();
		
		// wait for new input
		wait_for_new_input();
	}

	return SUCCESS;
}
