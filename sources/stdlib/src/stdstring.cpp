#include <stdstring.h>

namespace
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
	int i = 0;

	while (input > 0)
	{
		output[i] = CharConvArr[input % base];
		input /= base;
		i++;
	}

    if (i == 0)
    {
        output[i] = CharConvArr[0];
        i++;
    }

	output[i] = '\0';
	i--;

	for (int j = 0; j <= i/2; j++)
	{
		char c = output[i - j];
		output[i - j] = output[j];
		output[j] = c;
	}
}

int atoi(const char* input)
{
	int output = 0;

	while (*input != '\0')
	{
		output *= 10;
		if (*input > '9' || *input < '0')
			break;

		output += *input - '0';

		input++;
	}

	return output;
}

char* strncpy(char* dest, const char *src, int num)
{
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
		dest[i] = src[i];
	for (; i < num; i++)
		dest[i] = '\0';

   return dest;
}

int strncmp(const char *s1, const char *s2, int num)
{
	unsigned char u1, u2;
  	while (num-- > 0)
    {
      	u1 = (unsigned char) *s1++;
     	u2 = (unsigned char) *s2++;
      	if (u1 != u2)
        	return u1 - u2; // ?
      	if (u1 == '\0') // u1 == u2
        	return 0;
    }

  	return 0;
}

int strlen(const char* s)
{
	int i = 0;

	while (s[i] != '\0')
		i++;

	return i;
}

unsigned int strcspn(const char* str1, const char* str2)
{
	unsigned int i = 0;
	unsigned int j = 0;

	while (str1[i] != '\0')
	{
		while (str2[j] != '\0')
		{
			if (str1[i] == str2[j])
				return i;
			j++;
		}
		j = 0;
		i++;
	}

	return i;
}

int strncmp(const char *s1, const char *s2)
{	
	unsigned int str_len1 = strlen(s1);
	unsigned int str_len2 = strlen(s2);
	if (str_len1 != str_len2)
	{
		return str_len1 - str_len2;
	}
	return strncmp(s1, s2, str_len1);
}

void bzero(void* memory, int length)
{
	char* mem = reinterpret_cast<char*>(memory);

	for (int i = 0; i < length; i++)
		mem[i] = 0;
}

void memcpy(const void* src, void* dst, int num)
{
	const char* memsrc = reinterpret_cast<const char*>(src);
	char* memdst = reinterpret_cast<char*>(dst);

	for (int i = 0; i < num; i++)
		memdst[i] = memsrc[i];
}

float pow(const float x, const unsigned int n) 
{
    float r = 1.0f;
    for(unsigned int i=0; i<n; i++) {
        r *= x;
    }
    return r;
}

void revstr(char *str1)  
{  
    int i, len, temp;  
    len = strlen(str1);
      
    for (i = 0; i < len/2; i++)  
    {  
        temp = str1[i];  
        str1[i] = str1[len - i - 1];  
        str1[len - i - 1] = temp;  
    }  
}  

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    if(x>=10.0f) { // convert to base 10
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    }
    if(x>0.0f && x<=1.0f) {
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    }
    integral = (unsigned int)x;
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    decimal = (unsigned int)remainder;
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
        decimal++;
        if(decimal>=100000000u) { // decimal overflow
            decimal = 0;
            integral++;
            if(integral>=10u) { // decimal overflow causes integral overflow
                integral = 1;
                exponent++;
            }
        }
    }
}

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
	int index = 0;
    while((digits--)>0) {
        bfr[index++] = (char)(x%10+48);
        x /= 10;
    }
	bfr[index] = '\0';
	revstr(bfr);
}

bool isnan(float x) 
{
	return x != x;
}

bool isinf(float x) 
{
	return x > INFINITY;
}

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
	ftoa(x, bfr, 8);
}

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
	unsigned int index = 0;
    if (x<0.0f) 
	{ 
		bfr[index++] = '-';
		x = -x;
	}
    if(isnan(x)) 
	{
		bfr[index++] = 'N';
		bfr[index++] = 'a';
		bfr[index++] = 'N';
		bfr[index++] = '\0';
		return;
	}
    if(isinf(x)) 
	{
		bfr[index++] = 'I';
		bfr[index++] = 'n';
		bfr[index++] = 'f';
		bfr[index++] = '\0';
		return;
	}
	int precision = 8;
	if (decimals < 8 && decimals >= 0)
		precision = decimals;

    const float power = pow(10.0f, precision);
    x += 0.5f/power; // rounding
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);

	char string_int[32];
	itoa(integral, string_int, 10);
	int string_int_len = strlen(string_int);

	for (int i = 0; i < string_int_len; i++)
	{
		bfr[index++] = string_int[i];
	}

	if (decimals != 0) 
	{
		bfr[index++] = '.';
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);

		for (int i = 0; i < 9; i++)
		{
			if (string_decimals[i] == '\0')
				break;
			bfr[index++] = string_decimals[i];
		}
	}
	bfr[index] = '\0';
}

float atof(const char* s) 
{
  float rez = 0, fact = 1;
  if (*s == '-'){
    s++;
    fact = -1;
  }
  for (int point_seen = 0; *s; s++){
    if (*s == '.'){
      point_seen = 1; 
      continue;
    }
    int d = *s - '0';
    if (d >= 0 && d <= 9){
      if (point_seen) fact /= 10.0f;
      rez = rez * 10.0f + (float)d;
    }
  }
  return rez * fact;
};

bool is_float(char *str)
{
	if (str[0] == '\0') return false;
	
	int i = 0;
	int dot_count = 0;
	while(str[i] != '\0')
	{
		if (str[i] == '.')
		{
			dot_count++;
			if (dot_count > 1) return false;
		}
		else if (str[i] < '0' || str[i] > '9') return false;
		i++;
	}
	return true;

};

bool is_int(char *str)
{
	if (str[0] == '\0') return false;
	
	int i = 0;
	while(str[i] != '\0')
	{
		if (str[i] < '0' || str[i] > '9') return false;
		i++;
	}
	return true;
};