#include <hal/intdef.h>

constexpr uint32_t Message_Queue_Size = 4096;

class CCircularBuffer {
    private:
        char mBuffer[Message_Queue_Size];
        uint32_t mHead;  // Index začátku bufferu
        uint32_t mTail;  // Index konce bufferu
        bool mFull;        // Indikátor, zda je buffer plný

    public:
        CCircularBuffer();

        void Push(char value);

        char Pop();

        bool Empty() const;

        bool Full() const;

		char Peek() const;
};