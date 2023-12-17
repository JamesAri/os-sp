#pragma once

enum class EChromosome_Parameters
{
	A = 0,
	B = 1,
	C = 2,
	D = 3,
	E = 4
};

struct TModel_Parameters
{
	int t_delta;
	int t_pred;
};

struct TChromosome
{
	float A;
	float B;
	float C;
	float D;
	float E;
};

struct TModel_Record
{
	TChromosome chromosome;
	float fitness;
};