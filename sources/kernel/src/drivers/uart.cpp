#include <drivers/uart.h>
#include <drivers/bcm_aux.h>
#include <drivers/gpio.h>

#include <stdstring.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
    : mAUX(aux), mOpened(false), mCircular_Buffer(), mWaiting_File(nullptr)
{
	spinlock_init(&mLock);
}

bool CUART::Data_Ready()
{
    return mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 0x01;
}


bool CUART::Is_UART_IRQ_Pending()
{
	return mAUX.Get_Register(hal::AUX_Reg::MU_IIR) & 0x01;
}

void CUART::Enable_IRQ()
{
	mAUX.Set_Register(hal::AUX_Reg::MU_IER, 1);
	Clear_Receive_Buffer();
}

char CUART::Read_Internal()
{
    return mAUX.Get_Register(hal::AUX_Reg::MU_IO) & 0xFF;
}


char CUART::Read() 
{
    if(mCircular_Buffer.Empty())
        return '\0';
    return mCircular_Buffer.Pop();
}

bool CUART::Empty() 
{
    return mCircular_Buffer.Empty();
}

void CUART::Clear_Receive_Buffer()
{
	mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 1);
}

void CUART::Wait_For_Receive_Event(IFile* file)
{
	spinlock_lock(&mLock);

	mWaiting_File = file;

	spinlock_unlock(&mLock);
}

void CUART::IRQ_Callback() 
{
	if(Data_Ready())
	{
		const char received_char = Read_Internal();
		mCircular_Buffer.Push(received_char);
		// TODO: Won't work well on Windows (\r\n) rn (pun intended)
		if (mWaiting_File && (received_char == '\r' || received_char == '\n'))
		{
			mWaiting_File->Notify(1);
		}
	}
	
	// pokud by Data_Ready vracelo false (coz by se stat nemelo), tak i presto 
	// premazeme receive buffer, aby se IRQ neopakovalo stale dokola
	Clear_Receive_Buffer();
}

bool CUART::Open()
{
	spinlock_lock(&mLock);

    if (mOpened)
        return false;

    // rezervujeme si TX a RX piny, exkluzivne pro nas (R i W, ackoliv je jeden jen vstupni a jeden jen vystupni)
    if (!sGPIO.Reserve_Pin(static_cast<uint32_t>(hal::Reserved_Pins::UART0_TX), true, true))
        return false;

    if (!sGPIO.Reserve_Pin(static_cast<uint32_t>(hal::Reserved_Pins::UART0_RX), true, true))
    {
        sGPIO.Free_Pin(static_cast<uint32_t>(hal::Reserved_Pins::UART0_TX), true, true);
        return false;
    }

    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled

    // nastavime GPIO 14 a 15 na jejich alt funkci 5, coz je UART kanal 1
    sGPIO.Set_GPIO_Function(static_cast<uint32_t>(hal::Reserved_Pins::UART0_TX), NGPIO_Function::Alt_5);
    sGPIO.Set_GPIO_Function(static_cast<uint32_t>(hal::Reserved_Pins::UART0_RX), NGPIO_Function::Alt_5);

    mOpened = true;

    // nastavime vychozi rychlost a velikost znaku
    Set_Char_Length(NUART_Char_Length::Char_8);
    Set_Baud_Rate(NUART_Baud_Rate::BR_9600);

	spinlock_unlock(&mLock);

    return true;
}

void CUART::Close()
{
    if (!mOpened)
        return;

    // zakazeme AUX periferii
    mAUX.Disable(hal::AUX_Peripherals::MiniUART);

    // piny 14 a 15 prepneme na Input (tak zerou nejmin proudu)
    sGPIO.Set_GPIO_Function(static_cast<uint32_t>(hal::Reserved_Pins::UART0_TX), NGPIO_Function::Input);
    sGPIO.Set_GPIO_Function(static_cast<uint32_t>(hal::Reserved_Pins::UART0_RX), NGPIO_Function::Input);

    // uvolnime piny
    sGPIO.Free_Pin(static_cast<uint32_t>(hal::Reserved_Pins::UART0_TX), true, true);
    sGPIO.Free_Pin(static_cast<uint32_t>(hal::Reserved_Pins::UART0_RX), true, true);

    mOpened = false;
}

bool CUART::Is_Opened() const
{
    return mOpened;
}

NUART_Char_Length CUART::Get_Char_Length()
{
    if (!mOpened)
        return NUART_Char_Length::Char_8;

    return static_cast<NUART_Char_Length>(mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0x1);
}

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    if (!mOpened)
        return;

    mAUX.Set_Register(hal::AUX_Reg::MU_LCR, (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
}

NUART_Baud_Rate CUART::Get_Baud_Rate()
{
    if (!mOpened)
        return NUART_Baud_Rate::BR_1200;

    return mBaud_Rate;
}

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    if (!mOpened)
        return;

    mBaud_Rate = rate;

    const unsigned int val = ((hal::Default_Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
}

void CUART::Write(char c)
{
    if (!mOpened)
        return;

    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5)))
        ;

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
}

void CUART::Write(const char* str)
{
    if (!mOpened)
        return;

    int i;

    for (i = 0; str[i] != '\0'; i++)
        Write(str[i]);
}

void CUART::Write(const char* str, unsigned int len)
{
    if (!mOpened)
        return;

    unsigned int i;

    for (i = 0; i < len; i++)
        Write(str[i]);
}

void CUART::Write(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 10);
    Write(buf);
}

void CUART::Write_Hex(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 16);
    Write(buf);
}