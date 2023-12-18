#include "model_utils.h"

#include <stdfile.h>
#include <stdstring.h>

void fputs(uint32_t fd, const char* string)
{
	write(fd, string, strlen(string));
}

void fputs(uint32_t fd, const int num, bool new_line)
{
	// TODO: edit itoa to work with signed integers
	char bfr[32];
	bzero(bfr, 32);
	itoa(num, bfr, 10);
	fputs(fd, bfr);
	if (new_line) fputs(fd, "\r\n");
}

void fputs(uint32_t fd, const uint32_t num, bool new_line)
{
	char bfr[32];
	bzero(bfr, 32);
	itoa(num, bfr, 10);
	fputs(fd, bfr);
	if (new_line) fputs(fd, "\r\n");
}

void fputs(uint32_t fd, const float num, bool new_line)
{
	char bfr[32];
	bzero(bfr, 32);
	ftoa(num, bfr);
	fputs(fd, bfr);
	if (new_line) fputs(fd, "\r\n");
}

uint32_t fgets(uint32_t fd, char* buffer, uint32_t size)
{
	return read(fd, buffer, size);
}


void print_chromosome(uint32_t fd ,TChromosome &chromosome) 
{
	fputs(fd, "Model parameters: \r\n");
	fputs(fd, "A: ");
	fputs(fd, chromosome.A);
	fputs(fd, "B: ");
	fputs(fd, chromosome.B);
	fputs(fd, "C: ");
	fputs(fd, chromosome.C);
	fputs(fd, "D: ");
	fputs(fd, chromosome.D);
	fputs(fd, "E: ");
	fputs(fd, chromosome.E);
}

void print_model_parameters(uint32_t fd, TModel_Parameters &model_parameters)
{
	fputs(fd, "Model time parameters: \r\n");
	fputs(fd, "Time delta (t_delta): ");
	fputs(fd, model_parameters.t_delta);
	fputs(fd, "Prediction window (t_pred): ");
	fputs(fd, model_parameters.t_pred);
}
