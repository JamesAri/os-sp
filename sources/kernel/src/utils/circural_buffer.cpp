#include <utils/circural_buffer.h>

CCircularBuffer::CCircularBuffer() 
    : mHead(0), mTail(0), mFull(false) 
{
    for (int i = 0; i < Message_Queue_Size; i++)
		mBuffer[i] = 0;
}

void CCircularBuffer::Push(char value) 
{
    mBuffer[mTail] = value;
    if (mFull) 
	{
        mHead = (mHead + 1) % Message_Queue_Size;  // Přesunout začátek, pokud je buffer plný
    }
    mTail = (mTail + 1) % Message_Queue_Size;
    mFull = (mHead == mTail);  // Nastavit indikátor, zda je buffer plný
}

char CCircularBuffer::Pop() 
{
    if (Empty()) 
	{
        return '\0';
    }

    char value = mBuffer[mHead];
    mHead = (mHead + 1) % Message_Queue_Size;
    mFull = false;  // Po vyjmutí prvku už není buffer plný
    return value;
}

bool CCircularBuffer::Empty() const 
{
    return !mFull && (mHead == mTail);
}

bool CCircularBuffer::Full() const 
{
    return mFull;
}

char CCircularBuffer::Peek() const 
{
    if (Empty()) 
	{
        return '\0';
    }

	return mBuffer[mHead];
}