#pragma once

#include <hal/peripherals.h>
#include <drivers/bcm_aux.h>
#include <drivers/bridges/uart_defs.h>
#include <utils/circural_buffer.h>
#include <process/spinlock.h>
#include <fs/filesystem.h>

class CUART
{
    private:
        // odkaz na AUX driver
        CAUX& mAUX;

        // byl UART kanal otevreny?
        bool mOpened;

		IFile *mWaiting_File;

        // nastavena baud rate, ukladame ji proto, ze do registru se uklada (potencialne ztratovy) prepocet
        NUART_Baud_Rate mBaud_Rate;

		CCircularBuffer mCircular_Buffer;

		spinlock_t mLock;

		char Read_Internal();

		void Clear_Receive_Buffer();

		bool Data_Ready();
	public:
        CUART(CAUX& aux);

		// otevre UART kanal, exkluzivne
        bool Open();
        // uzavre UART kanal, uvolni ho pro ostatni
        void Close();
        // je UART kanal momentalne otevreny?
        bool Is_Opened() const;

        NUART_Char_Length Get_Char_Length();
        void Set_Char_Length(NUART_Char_Length len);

        NUART_Baud_Rate Get_Baud_Rate();
        void Set_Baud_Rate(NUART_Baud_Rate rate);

        // miniUART na RPi0 nepodporuje nic moc jineho uzitecneho, napr. paritni bity, vice stop-bitu nez 1, atd.

        void Write(char c);
        void Write(const char* str);
        void Write(const char* str, unsigned int len);
        void Write(unsigned int num);
        void Write_Hex(unsigned int num);

        // TODO: read (budeme to pak nejspis propojovat s prerusenim)
		char Read();

		bool Empty();

		void IRQ_Callback();

		bool Is_UART_IRQ_Pending();

		void Enable_IRQ();

		// TODO: allow multiple files to wait for receive event
		void Wait_For_Receive_Event(IFile *file);
};

extern CUART sUART0;
