#pragma once

#include <hal/intdef.h>

uint32_t get_random_uint32(uint32_t trng_file); 
uint32_t get_random_uint32(uint32_t trng_file, uint32_t min, uint32_t max); 
float get_random_float(uint32_t trng_file, float min, float max);