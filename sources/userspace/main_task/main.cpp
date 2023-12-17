#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdrandom.h>
#include <stdmemory.h>
#include <kth-finder.h>

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

void test_sbrk()
{
	void *ptr = sbrk(0x1000);
	itoa((uint32_t)ptr, string_buffer, 16);
	fputs(uart_file, "SBRK 0x1000: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	*(static_cast<uint32_t*>(ptr)) = 0xAAAAAAAA;
	itoa(*(static_cast<uint32_t*>(ptr)), string_buffer, 16);
	fputs(uart_file, "Stored value: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	ptr = sbrk(0x1000);
	itoa((uint32_t)ptr, string_buffer, 16);
	fputs(uart_file, "SBRK 0x1000: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	*(static_cast<uint32_t*>(ptr)) = 0xBBBBBBBB;
	itoa(*(static_cast<uint32_t*>(ptr)), string_buffer, 16);
	fputs(uart_file, "Stored value: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	ptr = sbrk(0x100000);
	itoa((uint32_t)ptr, string_buffer, 16);
	fputs(uart_file, "SBRK 0x100000: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	*(static_cast<uint32_t*>(ptr)) = 0xCCCCCCCC;
	itoa(*(static_cast<uint32_t*>(ptr)), string_buffer, 16);
	fputs(uart_file, "Stored value: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	ptr = sbrk(0x300000);
	itoa((uint32_t)ptr, string_buffer, 16);
	fputs(uart_file, "SBRK 0x300000: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	*(static_cast<uint32_t*>(ptr)) = 0xDDDDDDDD;
	itoa(*(static_cast<uint32_t*>(ptr)), string_buffer, 16);
	fputs(uart_file, "Stored value: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

// tests fpu and ftoa
void test_fpu()
{
	float cislo = 123.456f;
	ftoa(cislo, string_buffer);
	fputs(uart_file, "\r\nSENDING FLOAT!\r\n");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\nFLOAT SENT!\r\n");
}

// Tests TRNG floating point generation
void test_trng()
{
	float rng_num = get_random_float(trng_file, -0.01f, 0.01f);
	ftoa(rng_num, string_buffer);
	fputs(uart_file, "GOT RANDOM NUMBER: ");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
}

// Echo...
void test_uart(uint32_t v)
{
	itoa(v, string_buffer, 10);
	fputs(uart_file, "RECEIVED DATA!\r\n");
	fputs(uart_file, "[");
	fputs(uart_file, string_buffer);
	fputs(uart_file, "B]: ");
	fputs(uart_file, receive_buffer);
	fputs(uart_file, "\r\n");
}

// prints ascii values of received chars
void test_recv_ascii(uint32_t v)
{
	for (uint32_t i = 0; i < v; i++)
	{
		int char_val_int = receive_buffer[i];
		itoa(char_val_int, string_buffer, 16);
		fputs(uart_file, "CHAR[0x");
		fputs(uart_file, string_buffer);
		fputs(uart_file, "]\r\n");
	}
}

void test_parsing()
{
	char string_copy[RecvBfrSize];
	strncpy(string_copy, receive_buffer, RecvBfrSize);
	string_copy[strcspn(string_copy, "\r\n")] = '\0'; // remove LF, CR, CRLF, LFCR, ...
	if (strncmp(string_copy, "stop") == 0)
	{
		fputs(uart_file, "Received STOP command!\r\n");
	}
	else if (strncmp(string_copy, "parameters") == 0)
	{
		fputs(uart_file, "Received PARAMETERS command!\r\n");
	}
	else
	{
		fputs(uart_file, "Received UNKNOWN command!\r\n");
	}
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

// TICS MEASURED ON POP - 10000 and ITERATIONS - 100

// zabereme 1MiB pameti pro populaci
// do pameti se vejde 1MiB/sizeof(float) = 262144 floatu
// 1 chromosom ma 160b=20B (parametry A-E, kazdy 4B)
// do pameti se vejde 262144/20 = 13107,2 = 13107 chromosomu (0.6B nevyuzito)
// constexpr int POP_SIZE = (0x100000 / sizeof(float)) / sizeof(TChromosome);
constexpr int POP_SIZE = 10000;

// napr. 1024 zaznamu... uzivatel zatim pise rucne do konzole, takze to bude stacit
constexpr int LOOKUP_SIZE = 1024;

constexpr float MIN_INIT_RNG_F = -15.0f;
constexpr float MAX_INIT_RNG_F = 15.0f;
constexpr float MIN_MUTATION_RNG_F = -0.01f;
constexpr float MAX_MUTATION_RNG_F = 0.01f;

constexpr int ITERATIONS = 100;

// minimum time to start predicting
int T_MIN = model_parameters.t_delta + model_parameters.t_pred;

// 0min, 5min, 10min, 15min, 20min, 25min, 30min
float _lookup[LOOKUP_SIZE] = {
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

constexpr int FITNESS_VECTOR_SIZE = POP_SIZE * 2;
constexpr unsigned int FITNESS_VECTOR_SIZE_BYTES = FITNESS_VECTOR_SIZE * sizeof(float);

TChromosome *population_old;
TChromosome *population_new;
float *fitness;
float *tmp_fitness;

// fitness_new vector pointing at the start of the fitness vector
float* fitness_new;
// fitness_old vector pointing in the middle of the fitness vector
float* fitness_old;

// ======== UTILS ========

void init_buffers()
{
	population_old = static_cast<TChromosome*>(sbrk(POP_SIZE * sizeof(TChromosome)));
	population_new = static_cast<TChromosome*>(sbrk(POP_SIZE * sizeof(TChromosome)));
	fitness = static_cast<float*>(sbrk(FITNESS_VECTOR_SIZE * sizeof(float)));
	tmp_fitness = static_cast<float*>(sbrk(FITNESS_VECTOR_SIZE * sizeof(float)));

	fitness_new = fitness;
	fitness_old = fitness_new + POP_SIZE;
}

uint32_t get_random_param_index()
{
	return get_random_uint32(trng_file, 0, 5);
}

float get_random_param_value()
{
	return get_random_float(trng_file, MIN_INIT_RNG_F, MAX_INIT_RNG_F);
}

float get_random_mutation_value()
{
	return get_random_float(trng_file, MIN_MUTATION_RNG_F, MAX_MUTATION_RNG_F);
}


void sanity_check() {
	if (t_current < model_parameters.t_delta + model_parameters.t_pred)
	{
		// std::cout << "t_current < t_delta + t_pred (cannot start predicting)" << std::endl;
	}
}

int lookup(int t)
{
	return _lookup[static_cast<int>(t / model_parameters.t_delta)];
}

void print_current_chromosome() {
	fputs(uart_file, "Best chromosome: \r\n");
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

// ======== MODEL ========

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

// 3.5k tics
void calculate_fitness()
{
	for(int i = 0; i < POP_SIZE; i++)
	{   
		for(int t = T_MIN; t <= t_current; t += model_parameters.t_delta)
		{
			// spocteme predikci v case (t - model_parameters.t_pred) a porovname s lookup(t) (aktualni hodnota)
			const float pred = y(t - model_parameters.t_pred, population_new[i].A, population_new[i].B, population_new[i].C, population_new[i].D, population_new[i].E, model_parameters.t_delta);
			// MSE formula: (y-y')^2
			const float strength = pred - lookup(t);
			fitness_new[i] += strength * strength;
		}
	}
}

void copy_array(float* from, float* to, int size) {
	for(int i = 0; i < size; i++) {
		to[i] = from[i];
	}
}

// 2.4k-5k tics
void select() {
	copy_array(fitness, tmp_fitness, FITNESS_VECTOR_SIZE);
	// memcpy(fitness, tmp_fitness, FITNESS_VECTOR_SIZE_BYTES);
	
	// find fitness vector median (top 1/2 population), mutates the vector, thus the copy
	const float median = Kth_Finder::findKthLargest(tmp_fitness, FITNESS_VECTOR_SIZE, POP_SIZE);
	
	int index = 0;

	// Select the best chromosomes new population
	for (int i = 0; i < POP_SIZE; i++)
	{
		if (fitness_new[i] <= median)
		{
			fitness_new[index] = fitness_new[i];
			population_new[index] = population_new[i];
			index++;
			if(index >= POP_SIZE) break;
		}
	}

	// if full from the new population, return - shouldn't happen
	if(index >= POP_SIZE) return;

	// Select the rest of the best chromosomes from old population
	for (int i = 0; i < POP_SIZE; i++)
	{
		if (fitness_old[i] <= median)
		{
			fitness_new[index] = fitness_old[i];
			population_new[index] = population_old[i];
			index++;
			if(index >= POP_SIZE) break;
		}
	}
}

// 1.8k tics
void crossover()
{	
	// TODO: could shuffle the new population

	for(int i = 1; i < POP_SIZE; i+=2) 
	{
		TChromosome &child = population_new[i-1];
		TChromosome &parent = population_new[i];

		// randomly select number of parameters to copy from parent to child, min 2, max 3
		// int num_of_parameters = 2 + get_random_uint32(trng_file) % 2; // OFF for better performance from 3.5k tics to 1.8k tics
		for (int j = 0; j < 2; j++) 
		{
			switch(static_cast<EChromosome_Parameters>(get_random_param_index())) 
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
}

// Mutate the new_population
void mutate()
{	
	// Optimatization: generate one mutation float for the whole population (from 3.3k tics to 1.7k tics)
	float rnd_val = get_random_mutation_value();

	// iterate over the population and mutate each chromosome
	for(int i = 0; i < POP_SIZE; i++)
	{
		switch(static_cast<EChromosome_Parameters>(get_random_param_index())) 
		{
			case EChromosome_Parameters::A:
				population_new[i].A += rnd_val;
				break;
			case EChromosome_Parameters::B:
				population_new[i].B += rnd_val;
				break;
			case EChromosome_Parameters::C:
				population_new[i].C += rnd_val;
				break;
			case EChromosome_Parameters::D:
				population_new[i].D += rnd_val;
				break;
			case EChromosome_Parameters::E:
				population_new[i].E += rnd_val;
				break;	
			default:
				break;
		}
	}
}

// Copy old_population to new_population
void copy_population()
{
	for (int i = 0; i < POP_SIZE; i++)
	{
		population_old[i] = population_new[i];
	}
}

void swap_fitness_vectors() {
	float* tmp = fitness_new;
	fitness_new = fitness_old;
	fitness_old = tmp;
}


void next_generation()
{	
	// ===== PRESERVE OLD POPULATION; NEW -> OLD =====
	// Copy new popultion to old population
	copy_population(); // TODO optimize
	// print_duration(copy_population, "copy_population duration: ");

	// Swap fitness vectors - new becomes old
	swap_fitness_vectors();
	// print_duration(swap_fitness_vectors, "swap_fitness_vectors duration: ");

	// ===== CROSSOVER, MUTATION, CALCULATING FITNESS OF NEW POPULATION =====
	// crossover();
	print_duration(crossover, "crossover duration: ");
	// mutate();
	print_duration(mutate, "mutate duration: ");
	// calculate_fitness();
	print_duration(calculate_fitness, "calculate_fitness duration: ");

	// ===== SELECTING NEW POPULATION =====
	// Select the best chromosomes from old and new population
	// select();
	print_duration(select, "select duration: ");
}

// ======== INIT =========

void init_population()
{
	for (int i = 0; i < POP_SIZE; i++)
	{
		population_new[i].A = get_random_param_value();
		population_new[i].B = get_random_param_value();
		population_new[i].C = get_random_param_value();
		population_new[i].D = get_random_param_value();
		population_new[i].E = get_random_param_value();
	}
}

void init()
{
	init_population();
	calculate_fitness();
}

void print_results() {
	// find the best chromosome in fitness vector - after selection, the best
	// chromosome is in the new population
	int best_chromosome_index = 0;
	for (int i = 1; i < POP_SIZE; i++)
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
	itoa(POP_SIZE, string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "Iterations: ");
	itoa(ITERATIONS, string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");
	fputs(uart_file, "Predited glucose level that should match the last input: ");
	ftoa(y(t_current - model_parameters.t_pred, current_chromosome.A, current_chromosome.B, current_chromosome.C, current_chromosome.D, current_chromosome.E, model_parameters.t_delta), string_buffer);
	fputs(uart_file, string_buffer);
	fputs(uart_file, "\r\n");

	// Print predicted glucose level in 15 mins
	fputs(uart_file, "Predited glucose level in 15 mins (at ");
	itoa((t_current + model_parameters.t_pred), string_buffer, 10);
	fputs(uart_file, string_buffer);
	fputs(uart_file, " mins): ");
	ftoa(y(t_current, current_chromosome.A, current_chromosome.B, current_chromosome.C, current_chromosome.D, current_chromosome.E, model_parameters.t_delta), string_buffer);
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

	for(int i = 0; i < ITERATIONS; i++) 
	{
		fputs(uart_file, "iteration: ");
		itoa(i, string_buffer, 10);
		fputs(uart_file, string_buffer);
		fputs(uart_file, "\r\n");

		next_generation(); // 20
	}

	fputs(uart_file, "first iteration done!\r\n");

	t_current += model_parameters.t_delta; 

	for(int i = 0; i < ITERATIONS; i++) next_generation(); // 25

	fputs(uart_file, "second iteration done!\r\n");

	t_current += model_parameters.t_delta;

	for(int i = 0; i < ITERATIONS; i++) next_generation(); // 30

	fputs(uart_file, "third iteration done!\r\n");

	t_current += model_parameters.t_delta;

	for(int i = 0; i < ITERATIONS; i++) next_generation(); // 35

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

			test_trng();
		}
	}
    return 0;
}