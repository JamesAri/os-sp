#pragma once

#define SUCCESS 0
#define FAILURE 1

constexpr unsigned int Pop_Size = 2000;
constexpr unsigned int Iterations = 200;

constexpr unsigned int Fitness_Vector_Size = Pop_Size * 2;

// napr. 1024 zaznamu... uzivatel zatim pise rucne do konzole, takze to snad bude stacit
constexpr unsigned int Lookup_Size = 1024;

// Model trng settings
constexpr float Min_Init_Param_Rng = -15.0f;
constexpr float Max_Init_Param_Rng = 15.0f;
constexpr float Min_Mutation_Rng = -0.1f;
constexpr float Max_Mutation_Rng = 0.1f;

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


