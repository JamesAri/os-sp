#pragma once

#define SUCCESS 0
#define FAILURE 1

constexpr unsigned int Pop_Size = 2000;
constexpr unsigned int Iterations = 200;

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


