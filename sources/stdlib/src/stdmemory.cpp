#include <stdmemory.h>

void *sbrk(uint32_t increment)
{
	void *retaddr = nullptr;

	asm volatile("mov r0, %0" : : "r" (increment));
	asm volatile("swi 6");
	asm volatile("mov %0, r0" : "=r" (retaddr));

	return retaddr;
}
