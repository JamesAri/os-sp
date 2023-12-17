#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdrandom.h>
#include <stdmemory.h>

#include <drivers/bridges/uart_defs.h>

#include "model_defs.h"
#include "model_utils.h"

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
	fputs(uart_file, "MAIN task starting!\r\n");
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

TModel_Record best_record = {{1.0f, 1.0f, 1.0f, 1.0f, 1.0f}, 1.0f};

TModel_Parameters model_parameters = {5, 15};

// TICS MEASURED ON Pop_Size = 10000 and Iterations = 100

constexpr int Pop_Size = 1000;
constexpr int Iterations = 100;

// napr. 1024 zaznamu... uzivatel zatim pise rucne do konzole, takze to snad bude stacit
constexpr int Lookup_Size = 1024;

constexpr float Min_Init_Param_Rng = -15.0f;
constexpr float Max_Init_Param_Rng = 15.0f;
constexpr float Min_Mutation_Rng = -0.01f;
constexpr float Max_Mutation_Rng = 0.01f;

// minimum time to start predicting
int T_MIN = model_parameters.t_delta + model_parameters.t_pred;

// 0min, 5min, 10min, 15min, 20min, 25min, 30min
float lookup_table[Lookup_Size] = {
	13.457f,
	13.800f,
	13.400f,
	13.000f,
	12.600f,
	12.200f,
	11.800f,
	11.600f,
};

int t_current = T_MIN;

constexpr int Fitness_Vector_Size = Pop_Size * 2;
constexpr unsigned int FITNESS_VECTOR_SIZE_BYTES = Fitness_Vector_Size * sizeof(float);

// TChromosome *population_old;
// TChromosome *population_new;
// float *fitness;
// float *tmp_fitness;

// fitness_new vector pointing at the start of the fitness vector
// fitness_old vector pointing in the middle of the fitness vector
// allows us to use only one fitness vector and swap the pointers without copying the data
// float* fitness_new;
// float* fitness_old;

constexpr uint32_t Pop_Size_Total = Pop_Size * 2;
TModel_Record *population;
TModel_Record *__population_old;
TModel_Record *__population_new;


// =========== UTILS ===========

void init_buffers()
{
	population = static_cast<TModel_Record*>(sbrk(Pop_Size_Total * sizeof(TModel_Record)));
	__population_old = population;
	__population_new = population + Pop_Size;
	fputs(uart_file, "WAIT CALLED!\r\n");
	wait(uart_file);
	fputs(uart_file, "WOKE UP!\r\n");

	// population_old = static_cast<TChromosome*>(sbrk(Pop_Size * sizeof(TChromosome)));
	// population_new = static_cast<TChromosome*>(sbrk(Pop_Size * sizeof(TChromosome)));
	// fitness = static_cast<float*>(sbrk(Fitness_Vector_Size * sizeof(float)));
	// tmp_fitness = static_cast<float*>(sbrk(Fitness_Vector_Size * sizeof(float)));

	// fitness_new = fitness;
	// fitness_old = fitness_new + Pop_Size;
}

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

void sanity_check() 
{
	if (t_current < model_parameters.t_delta + model_parameters.t_pred)
	{
		// std::cout << "t_current < t_delta + t_pred (cannot start predicting)" << std::endl;
	}
}

int lookup(int t)
{
	return lookup_table[static_cast<int>(t / model_parameters.t_delta)];
}

// Copies old_population to new_population
// void copy_population()
// {
// 	for (int i = 0; i < Pop_Size; i++)
// 	{
// 		population_old[i] = population_new[i];
// 	}
// }

// void swap_fitness_vectors() 
// {
// 	float* tmp = fitness_new;
// 	fitness_new = fitness_old;
// 	fitness_old = tmp;
// }

// void copy_array(float* from, float* to, int size) 
// {
// 	for(int i = 0; i < size; i++) 
// 	{
// 		to[i] = from[i];
// 	}
// }

void print_current_chromosome() 
{
	fputs(uart_file, "Best chromosome: \r\n");
	fputs(uart_file, "A: ");
	ftoa(best_record.chromosome.A, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "B: ");
	ftoa(best_record.chromosome.B, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "C: ");
	ftoa(best_record.chromosome.C, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "D: ");
	ftoa(best_record.chromosome.D, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "E: ");
	ftoa(best_record.chromosome.E, string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
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
			const float pred = y(t - model_parameters.t_pred, __population_new[i].chromosome.A, __population_new[i].chromosome.B, __population_new[i].chromosome.C, __population_new[i].chromosome.D, __population_new[i].chromosome.E, model_parameters.t_delta);
			// Optimization: Use ABS instead of MSE formula: (y-y')^2 - [3.5k tics to 1.7k tics]
			const float strength = pred - lookup(t);
			__population_new[i].fitness += (strength >= 0.0f) ? strength : -strength;
		}
	}
}

// 580 tics
void calculate_fitness_optimized() // Removed fn calls - [1.7k tics to 1k tics].
{
	for(int t = T_MIN; t <= t_current; t += model_parameters.t_delta)
	{   
		// Extracted t-values here - [1k tics to 580 tics]
		const float val_t = lookup_table[static_cast<int>(t / model_parameters.t_delta)];
		const float val_t_minus_delta = lookup_table[static_cast<int>((t-model_parameters.t_delta) / model_parameters.t_delta)];
		const float val_t_diff = val_t - val_t_minus_delta;
		
		for(int i = 0; i < Pop_Size; i++)
		{
			// spocteme predikci v case (t - t_pred) a porovname s opravdovou hodnotou v case t.
			// b()
			const float b_t = (__population_new[i].chromosome.D / __population_new[i].chromosome.E) * ((val_t_diff) / model_parameters.t_delta) + (1.0f / __population_new[i].chromosome.E) * val_t;
			// y()
			const float pred = __population_new[i].chromosome.A * b_t + __population_new[i].chromosome.B * b_t * (b_t - val_t) + __population_new[i].chromosome.C;
			
			// Optimization: Use ABS instead of MSE formula: (y-y')^2 - [3.5k tics to 1.7k tics]
			const float strength = pred - val_t;
			__population_new[i].fitness += (strength >= 0.0f) ? strength : -strength;
		}
	}
}

// 1k-5k tics (converges towards 5k tics)
void select() 
{
	// copy_array(fitness, tmp_fitness, Fitness_Vector_Size);
	// memcpy(fitness, tmp_fitness, FITNESS_VECTOR_SIZE_BYTES);
	
	// find fitness vector median (top 1/2 population), mutates the vector, thus the copy
	Model_Utils::split_model(population, Pop_Size_Total, Pop_Size_Total);
	
	// int index = 0;

	// // Select the best chromosomes from both old and new population
	// for (int i = 0; i < Pop_Size; i++)
	// {
	// 	if (fitness_new[i] <= median)
	// 	{
	// 		fitness_new[index] = fitness_new[i];
	// 		population_new[index] = population_new[i];
	// 		index++;
	// 		if(index >= Pop_Size) break;
	// 	}
	// 	if (fitness_old[i] <= median)
	// 	{
	// 		fitness_new[index] = fitness_old[i];
	// 		population_new[index] = population_old[i];
	// 		index++;
	// 		if(index >= Pop_Size) break;
	// 	}
	// }
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
		// first copy the old chromosomes to the new population, which will then be modified by the crossover
		__population_new[i-1].chromosome = __population_old[i-1].chromosome;
		__population_new[i].chromosome = __population_old[i].chromosome;

		TChromosome &child = __population_new[i-1].chromosome;
		TChromosome &parent = __population_new[i].chromosome;

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
	float rnd_val = get_random_mutation_value();
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
				__population_new[i].chromosome.A += rnd_val;
				break;
			case EChromosome_Parameters::B:
				__population_new[i].chromosome.B += rnd_val;
				break;
			case EChromosome_Parameters::C:
				__population_new[i].chromosome.C += rnd_val;
				break;
			case EChromosome_Parameters::D:
				__population_new[i].chromosome.D += rnd_val;
				break;
			case EChromosome_Parameters::E:
				__population_new[i].chromosome.E += rnd_val;
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
	// copy_population(); // TODO optimize
	// print_duration(copy_population, "copy_population duration: ");

	// Since new population got copied to the old one, we need to swap the fitness pointers.
	// Swap the new fitness pointer with the old fitness pointer:
	// fitness vector before: [-----fitness_old-----|-----fitness_new-----]
	// fitness vector after:  [-----fitness_new-----|-----fitness_old-----]
	// the [-----fitness_new-----] will be overwritten in the next steps (by the new population).
	// swap_fitness_vectors();
	// print_duration(swap_fitness_vectors, "swap_fitness_vectors duration: ");

	
	// =========== CREATING NEW POPULATION (crossover, mutation, fitness) ===========

	// crossover();
	print_duration(crossover, "crossover duration: ");
	// mutate();
	print_duration(mutate, "mutate duration: ");
	// calculate_fitness_optimized();
	print_duration(calculate_fitness_optimized, "calculate_fitness_optimized duration: ");


	// =========== SELECTING BEST POPULATION ===========

	// Select the best chromosomes from old + new population.
	// select();
	print_duration(select, "select duration: ");
}

// =========== INIT ===========

void init_population()
{
	for (int i = 0; i < Pop_Size; i++)
	{
		__population_new[i].chromosome.A = get_random_param_value();
		__population_new[i].chromosome.B = get_random_param_value();
		__population_new[i].chromosome.C = get_random_param_value();
		__population_new[i].chromosome.D = get_random_param_value();
		__population_new[i].chromosome.E = get_random_param_value();
	}
}

void init()
{
	init_population();
	calculate_fitness_optimized();
	Model_Utils::copy_population(__population_old, __population_new, Pop_Size);
	init_population();
	calculate_fitness_optimized();
}

void print_results() 
{
	// find the best record - after selection, the best
	// chromosome is in the old population, but let's iterate the whole
	// population just to be sure.
	unsigned int best_record_index = 0;
	for (int i = 1; i < Pop_Size; i++)
	{
		if (__population_old[i].fitness < __population_old[best_record_index].fitness)
		{
			best_record_index = i;
		}
	}
	
	best_record = __population_old[best_record_index];

	// print the best chromosome
	print_current_chromosome();

	// print the best fitness
	fputs(uart_file, "Best fitness: ");
	ftoa(best_record.fitness, string_buffer);
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
	ftoa(y(t_current - model_parameters.t_pred, best_record.chromosome.A, best_record.chromosome.B, best_record.chromosome.C, best_record.chromosome.D, best_record.chromosome.E, model_parameters.t_delta), string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	// Print predicted glucose level in 15 mins
	fputs(uart_file, "Predicted glucose level in 15 mins (at ");
	itoa((t_current + model_parameters.t_pred), string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, " mins): ");
	ftoa(y(t_current, best_record.chromosome.A, best_record.chromosome.B, best_record.chromosome.C, best_record.chromosome.D, best_record.chromosome.E, model_parameters.t_delta), string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

int main()
{
	bzero(receive_buffer, RecvBfrSize);
	bzero(string_buffer, StringBfrSize);
	
	init_uart();
	if (uart_file == Invalid_Handle) return 1;
	init_trng();
	if (trng_file == Invalid_Handle) return 1;

	// ======================

	fputs(uart_file, "INITIALIZING BUFFERS!\r\n");
	init_buffers();
	fputs(uart_file, "BUFFERS INITIALIZED!\r\n");

	t_current = T_MIN;
	init();

	fputs(uart_file, "init done! starting training!\r\n");

	for(int i = 0; i < Iterations; i++) 
	{
		fputs(uart_file, "iteration: ");
		itoa(i, string_buffer, 10);
		fputs(uart_file, string_buffer);
		fputs(uart_file, "\r\n");

		next_generation(); // 20
	}

	fputs(uart_file, "first iteration done!\r\n");

	t_current += model_parameters.t_delta; 

	for(int i = 0; i < Iterations; i++) next_generation(); // 25

	fputs(uart_file, "second iteration done!\r\n");

	t_current += model_parameters.t_delta;

	for(int i = 0; i < Iterations; i++) next_generation(); // 30

	fputs(uart_file, "third iteration done!\r\n");

	t_current += model_parameters.t_delta;

	for(int i = 0; i < Iterations; i++) next_generation(); // 35

	fputs(uart_file, "fourth iteration done!\r\n");

	print_results();

	return 0;
}


int main_off()
{
	bzero(receive_buffer, RecvBfrSize);
	bzero(string_buffer, StringBfrSize);
	
	init_uart();
	if (uart_file == Invalid_Handle) return 1;
	init_trng();
	if (trng_file == Invalid_Handle) return 1;

	while(true) 
	{
		uint32_t v = fgets(uart_file, receive_buffer, RecvBfrSize);

		if (v > 0)
		{
			if (v < RecvBfrSize) receive_buffer[v] = '\0';
			else receive_buffer[RecvBfrSize-1] = '\0';

		} 
		else 
		{
			fputs(uart_file, "WAIT CALLED!\r\n");
			wait(uart_file);
			fputs(uart_file, "WOKE UP!\r\n");
		}
	}
    return 0;
}