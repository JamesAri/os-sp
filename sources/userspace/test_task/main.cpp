#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdrandom.h>
#include <stdmemory.h>

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

uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
char receive_buffer[RecvBfrSize];
char string_buffer[StringBfrSize];

void init_uart()
{
	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
	params.char_length = NUART_Char_Length::Char_8;
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
	fputs(uart_file, "TEST task starting!\r\n");
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
	float rng_num = get_random_float(trng_file, 0.0f, 100.0f);
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


int main(int argc, char** argv)
{
	bzero(receive_buffer, RecvBfrSize);
	bzero(string_buffer, StringBfrSize);
	
	init_uart();

	test_fpu();
	test_sbrk();

	while(true) 
	{
		uint32_t v = fgets(uart_file, receive_buffer, RecvBfrSize);

		if (v > 0)
		{
			if (v < RecvBfrSize) receive_buffer[v] = '\0';
			else receive_buffer[RecvBfrSize-1] = '\0';

			test_uart(v);		
			test_recv_ascii(v);
		} 
		else 
		{
			fputs(uart_file, "WAIT CALLED!\r\n");
			wait(uart_file);
			fputs(uart_file, "WOKE UP!\r\n");
			
			// lets print random float after each wait...
			test_trng();
		}
	}
    return 0;
}