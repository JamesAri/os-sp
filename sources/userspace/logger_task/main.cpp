#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>

#include <drivers/bridges/uart_defs.h>

/**
 * Logger task
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

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

	fputs(uart_file, "UART task starting!");

	char buf[1000];
	char int_str_buffer[16];
	bzero(buf, 1000);
	bzero(int_str_buffer, 16);

	float cislo = 123.456f;
	char cislo_str[32];
	bzero(cislo_str, 32);
	ftoa(cislo, cislo_str);
	fputs(uart_file, "\r\nSENDING FLOAT!\r\n");
	fputs(uart_file, cislo_str);
	fputs(uart_file, "\r\nSENT FLOAT!\r\n");


	while(true) 
	{
		uint32_t v = fgets(uart_file, buf, 1000);

		if (v > 0)
		{
			buf[999] = '\0';
			if (v < 1000) buf[v] = '\0';

			itoa(v, int_str_buffer, 10);
			fputs(uart_file, "RECEIVED DATA!\r\n");
			fputs(uart_file, "[");
			fputs(uart_file, int_str_buffer);
			fputs(uart_file, "]: ");
			fputs(uart_file, buf);
			fputs(uart_file, "\r\n");

			for (uint32_t i = 0; i < v; i++)
			{
				int char_val_int = buf[i];
				itoa(char_val_int, int_str_buffer, 16);
				fputs(uart_file, "CHAR[");
				fputs(uart_file, int_str_buffer);
				fputs(uart_file, "]\r\n");
			}
		} else {
			fputs(uart_file, "WAIT CALLED!\r\n");
			wait(uart_file);
			fputs(uart_file, "WOKE UP!\r\n");
		}
	}

	// uint32_t logpipe = pipe("log", 32);

	// while (true)
	// {
	// 	wait(logpipe, 1, 0x1000);

	// 	uint32_t v = read(logpipe, buf, 15);
	// 	if (v > 0)
	// 	{
	// 		buf[v] = '\0';
	// 		fputs(uart_file, "\r\n[ ");
	// 		uint32_t tick = get_tick_count();
	// 		itoa(tick, tickbuf, 16);
	// 		fputs(uart_file, tickbuf);
	// 		fputs(uart_file, "]: ");
	// 		fputs(uart_file, buf);
	// 	}
	// }

	// while (true)
	// {
	// 	fputs(uart_file, "\r\n[ ");
	// 	uint32_t tick = get_tick_count();
	// 	itoa(tick, tickbuf, 16);
	// 	fputs(uart_file, tickbuf);
	// 	fputs(uart_file, "]: ");
	// 	sleep(1000);
	// }

    return 0;
}
