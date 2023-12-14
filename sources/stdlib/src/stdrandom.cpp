#include <stdfile.h>

uint32_t get_random_uint32(uint32_t trng_file)
{	
	uint32_t rng_num = 0;
	read(trng_file, reinterpret_cast<char*>(&rng_num), sizeof(rng_num));
	return rng_num;
}

// Returns a random number between min and max, (min inclusive, max exclusive)
uint32_t get_random_uint32(uint32_t trng_file, uint32_t min, uint32_t max)
{	
	uint32_t rng_num = 0;
	read(trng_file, reinterpret_cast<char*>(&rng_num), sizeof(rng_num));
	uint32_t random_in_range = min + (rng_num % (max - min));
	return random_in_range;
}

// Returns a random float between min and max, (min inclusive, max inclusive)
float get_random_float(uint32_t trng_file, float min, float max)
{
    uint32_t random_int = get_random_uint32(trng_file);

    // Convert the random integer to a floating-point number between 0 and 1
    float random_normalized = (float)random_int / UINT32_MAX;

    // Scale the random number to the desired range
    float random_in_range = min + (max - min) * random_normalized;

	return random_in_range;
}