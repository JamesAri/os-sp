#pragma once

// the maximum positive value that can be represented by a float
constexpr float INFINITY = 3.402823466e+38f;

void itoa(unsigned int input, char* output, unsigned int base);
int atoi(const char* input);
char* strncpy(char* dest, const char *src, int num);
int strncmp(const char *s1, const char *s2, int num);
int strlen(const char* s);
void bzero(void* memory, int length);
void memcpy(const void* src, void* dst, int num);
// added by me
float atof(const char* s);
void ftoa(float x, char *bfr);
void ftoa(float x, char *bfr, const unsigned int decimals);
unsigned int strcspn(const char* str1, const char* str2);
int strncmp(const char *s1, const char *s2);