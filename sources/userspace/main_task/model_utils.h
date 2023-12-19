#pragma once

#include "model_defs.h"

#include <hal/intdef.h>

float findKthLargest(float nums[], int size, int k);

void print_chromosome(uint32_t fd ,TChromosome &chromosome);
void print_model_parameters(uint32_t fd, TModel_Parameters &model_parameters);

void fputs(uint32_t fd, const char* string);
void fputs(uint32_t fd, const int, bool new_line = true);
void fputs(uint32_t fd, const uint32_t, bool new_line = true);
void fputs(uint32_t fd, const float, bool new_line = true);
uint32_t fgets(uint32_t fd, char* buffer, uint32_t size);