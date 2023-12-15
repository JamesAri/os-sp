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


int main(int argc, char** argv)
{
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
	params.char_length = NUART_Char_Length::Char_8;
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);

	fputs(uart_file, "UART task starting!\r\n");

	char receive_buffer[1000];
	char string_buffer[16];
	bzero(receive_buffer, 1000);
	bzero(string_buffer, 16);

	float cislo = 123.456f;
	char cislo_str[32];
	bzero(cislo_str, 32);
	ftoa(cislo, cislo_str);
	fputs(uart_file, "\r\nSENDING FLOAT!\r\n");
	fputs(uart_file, cislo_str);
	fputs(uart_file, "\r\nSENT FLOAT!\r\n");

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

	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);

	while(true) 
	{
		uint32_t v = fgets(uart_file, receive_buffer, 1000);

		if (v > 0)
		{
			receive_buffer[999] = '\0';
			if (v < 1000) receive_buffer[v] = '\0';

			itoa(v, string_buffer, 10);
			fputs(uart_file, "RECEIVED DATA!\r\n");
			fputs(uart_file, "[");
			fputs(uart_file, string_buffer);
			fputs(uart_file, "]: ");
			fputs(uart_file, receive_buffer);
			fputs(uart_file, "\r\n");

			for (uint32_t i = 0; i < v; i++)
			{
				int char_val_int = receive_buffer[i];
				itoa(char_val_int, string_buffer, 16);
				fputs(uart_file, "CHAR[0x");
				fputs(uart_file, string_buffer);
				fputs(uart_file, "]\r\n");
			}
		} 
		else 
		{
			fputs(uart_file, "WAIT CALLED!\r\n");
			wait(uart_file);
			fputs(uart_file, "WOKE UP!\r\n");

			float rng_num = get_random_float(trng_file, 0.0f, 100.0f);
			ftoa(rng_num, string_buffer);
			fputs(uart_file, "GOT RANDOM NUMBER: ");
			fputs(uart_file, string_buffer);
			fputs(uart_file, "\r\n");
		}
	}
    return 0;
}