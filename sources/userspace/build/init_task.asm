
./init_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/jamesari/git/os/sp/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000017 	bl	8064 <__crt0_run>

00008004 <_hang>:
_hang():
/home/jamesari/git/os/sp/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/home/jamesari/git/os/sp/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/userspace/crt0.c:11
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/home/jamesari/git/os/sp/sources/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/home/jamesari/git/os/sp/sources/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	0000993c 	andeq	r9, r0, ip, lsr r9
    8060:	0000994c 	andeq	r9, r0, ip, asr #18

00008064 <__crt0_run>:
__crt0_run():
/home/jamesari/git/os/sp/sources/userspace/crt0.c:16

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/home/jamesari/git/os/sp/sources/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/home/jamesari/git/os/sp/sources/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/home/jamesari/git/os/sp/sources/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000069 	bl	822c <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/home/jamesari/git/os/sp/sources/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/userspace/crt0.c:33
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/userspace/crt0.c:34
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	00009939 	andeq	r9, r0, r9, lsr r9
    81d0:	00009939 	andeq	r9, r0, r9, lsr r9

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	00009939 	andeq	r9, r0, r9, lsr r9
    8228:	00009939 	andeq	r9, r0, r9, lsr r9

0000822c <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000d7 	bl	85a8 <_Z17set_task_deadlinej>
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:18
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8248:	eb0000b8 	bl	8530 <_Z24get_active_process_countv>
    824c:	e1a03000 	mov	r3, r0
    8250:	e3530001 	cmp	r3, #1
    8254:	03a03001 	moveq	r3, #1
    8258:	13a03000 	movne	r3, #0
    825c:	e6ef3073 	uxtb	r3, r3
    8260:	e3530000 	cmp	r3, #0
    8264:	0a000000 	beq	826c <main+0x40>
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8268:	e320f002 	wfe
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    826c:	eb000016 	bl	82cc <_Z11sched_yieldv>
/home/jamesari/git/os/sp/sources/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8270:	eafffff4 	b	8248 <main+0x1c>

00008274 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8280:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8284:	e1a03000 	mov	r3, r0
    8288:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8290:	e1a00003 	mov	r0, r3
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
    82a8:	e24dd00c 	sub	sp, sp, #12
    82ac:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b0:	e51b3008 	ldr	r3, [fp, #-8]
    82b4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82b8:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    82bc:	e320f000 	nop	{0}
    82c0:	e28bd000 	add	sp, fp, #0
    82c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c8:	e12fff1e 	bx	lr

000082cc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d0:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82d4:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    82d8:	e320f000 	nop	{0}
    82dc:	e28bd000 	add	sp, fp, #0
    82e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e4:	e12fff1e 	bx	lr

000082e8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ec:	e28db000 	add	fp, sp, #0
    82f0:	e24dd014 	sub	sp, sp, #20
    82f4:	e50b0010 	str	r0, [fp, #-16]
    82f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    830c:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8310:	e1a03000 	mov	r3, r0
    8314:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    831c:	e1a00003 	mov	r0, r3
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
    8334:	e24dd01c 	sub	sp, sp, #28
    8338:	e50b0010 	str	r0, [fp, #-16]
    833c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8340:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8344:	e51b3010 	ldr	r3, [fp, #-16]
    8348:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    834c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8350:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8354:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8358:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    835c:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8360:	e1a03000 	mov	r3, r0
    8364:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    836c:	e1a00003 	mov	r0, r3
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd01c 	sub	sp, sp, #28
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8390:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8394:	e51b3010 	ldr	r3, [fp, #-16]
    8398:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    839c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    83a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83a8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    83ac:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
    83d8:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
    83e0:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83e4:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8428:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd014 	sub	sp, sp, #20
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    845c:	e51b3010 	ldr	r3, [fp, #-16]
    8460:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8468:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    846c:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    84bc:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8500:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
    8510:	e3530000 	cmp	r3, #0
    8514:	13a03001 	movne	r3, #1
    8518:	03a03000 	moveq	r3, #0
    851c:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    8520:	e1a00003 	mov	r0, r3
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    853c:	e3a03000 	mov	r3, #0
    8540:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8544:	e3a03000 	mov	r3, #0
    8548:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8554:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8558:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e28bd000 	add	sp, fp, #0
    8564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8568:	e12fff1e 	bx	lr

0000856c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    856c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8570:	e28db000 	add	fp, sp, #0
    8574:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8578:	e3a03001 	mov	r3, #1
    857c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8580:	e3a03001 	mov	r3, #1
    8584:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8588:	e24b300c 	sub	r3, fp, #12
    858c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8590:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8594:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85b8:	e3a03000 	mov	r3, #0
    85bc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85c8:	e24b3010 	sub	r3, fp, #16
    85cc:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85d0:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    85d4:	e320f000 	nop	{0}
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f0:	e3a03001 	mov	r3, #1
    85f4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8600:	e24b300c 	sub	r3, fp, #12
    8604:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8608:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    860c:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8620:	e92d4800 	push	{fp, lr}
    8624:	e28db004 	add	fp, sp, #4
    8628:	e24dd050 	sub	sp, sp, #80	; 0x50
    862c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8630:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8634:	e24b3048 	sub	r3, fp, #72	; 0x48
    8638:	e3a0200a 	mov	r2, #10
    863c:	e59f1088 	ldr	r1, [pc, #136]	; 86cc <_Z4pipePKcj+0xac>
    8640:	e1a00003 	mov	r0, r3
    8644:	eb0000a5 	bl	88e0 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8648:	e24b3048 	sub	r3, fp, #72	; 0x48
    864c:	e283300a 	add	r3, r3, #10
    8650:	e3a02035 	mov	r2, #53	; 0x35
    8654:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8658:	e1a00003 	mov	r0, r3
    865c:	eb00009f 	bl	88e0 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8660:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8664:	eb0000f8 	bl	8a4c <_Z6strlenPKc>
    8668:	e1a03000 	mov	r3, r0
    866c:	e283300a 	add	r3, r3, #10
    8670:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8674:	e51b3008 	ldr	r3, [fp, #-8]
    8678:	e2832001 	add	r2, r3, #1
    867c:	e50b2008 	str	r2, [fp, #-8]
    8680:	e24b2004 	sub	r2, fp, #4
    8684:	e0823003 	add	r3, r2, r3
    8688:	e3a02023 	mov	r2, #35	; 0x23
    868c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8690:	e24b2048 	sub	r2, fp, #72	; 0x48
    8694:	e51b3008 	ldr	r3, [fp, #-8]
    8698:	e0823003 	add	r3, r2, r3
    869c:	e3a0200a 	mov	r2, #10
    86a0:	e1a01003 	mov	r1, r3
    86a4:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86a8:	eb000008 	bl	86d0 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    86ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b0:	e3a01002 	mov	r1, #2
    86b4:	e1a00003 	mov	r0, r3
    86b8:	ebffff0a 	bl	82e8 <_Z4openPKc15NFile_Open_Mode>
    86bc:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    86c0:	e1a00003 	mov	r0, r3
    86c4:	e24bd004 	sub	sp, fp, #4
    86c8:	e8bd8800 	pop	{fp, pc}
    86cc:	00009918 	andeq	r9, r0, r8, lsl r9

000086d0 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    86d0:	e92d4800 	push	{fp, lr}
    86d4:	e28db004 	add	fp, sp, #4
    86d8:	e24dd020 	sub	sp, sp, #32
    86dc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86e0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86e4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    86f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86f4:	e3530000 	cmp	r3, #0
    86f8:	0a000014 	beq	8750 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    86fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8700:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8704:	e1a00003 	mov	r0, r3
    8708:	eb000462 	bl	9898 <__aeabi_uidivmod>
    870c:	e1a03001 	mov	r3, r1
    8710:	e1a01003 	mov	r1, r3
    8714:	e51b3008 	ldr	r3, [fp, #-8]
    8718:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    871c:	e0823003 	add	r3, r2, r3
    8720:	e59f2118 	ldr	r2, [pc, #280]	; 8840 <_Z4itoajPcj+0x170>
    8724:	e7d22001 	ldrb	r2, [r2, r1]
    8728:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    872c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8730:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8734:	eb0003dc 	bl	96ac <__udivsi3>
    8738:	e1a03000 	mov	r3, r0
    873c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e2833001 	add	r3, r3, #1
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    874c:	eaffffe7 	b	86f0 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e3530000 	cmp	r3, #0
    8758:	1a000007 	bne	877c <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8764:	e0823003 	add	r3, r2, r3
    8768:	e3a02030 	mov	r2, #48	; 0x30
    876c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e2833001 	add	r3, r3, #1
    8778:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8784:	e0823003 	add	r3, r2, r3
    8788:	e3a02000 	mov	r2, #0
    878c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e2433001 	sub	r3, r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    879c:	e3a03000 	mov	r3, #0
    87a0:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e1a02fa3 	lsr	r2, r3, #31
    87ac:	e0823003 	add	r3, r2, r3
    87b0:	e1a030c3 	asr	r3, r3, #1
    87b4:	e1a02003 	mov	r2, r3
    87b8:	e51b300c 	ldr	r3, [fp, #-12]
    87bc:	e1530002 	cmp	r3, r2
    87c0:	ca00001b 	bgt	8834 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    87c4:	e51b2008 	ldr	r2, [fp, #-8]
    87c8:	e51b300c 	ldr	r3, [fp, #-12]
    87cc:	e0423003 	sub	r3, r2, r3
    87d0:	e1a02003 	mov	r2, r3
    87d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87d8:	e0833002 	add	r3, r3, r2
    87dc:	e5d33000 	ldrb	r3, [r3]
    87e0:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    87e4:	e51b300c 	ldr	r3, [fp, #-12]
    87e8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87ec:	e0822003 	add	r2, r2, r3
    87f0:	e51b1008 	ldr	r1, [fp, #-8]
    87f4:	e51b300c 	ldr	r3, [fp, #-12]
    87f8:	e0413003 	sub	r3, r1, r3
    87fc:	e1a01003 	mov	r1, r3
    8800:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8804:	e0833001 	add	r3, r3, r1
    8808:	e5d22000 	ldrb	r2, [r2]
    880c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8810:	e51b300c 	ldr	r3, [fp, #-12]
    8814:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8818:	e0823003 	add	r3, r2, r3
    881c:	e55b200d 	ldrb	r2, [fp, #-13]
    8820:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8824:	e51b300c 	ldr	r3, [fp, #-12]
    8828:	e2833001 	add	r3, r3, #1
    882c:	e50b300c 	str	r3, [fp, #-12]
    8830:	eaffffdb 	b	87a4 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8834:	e320f000 	nop	{0}
    8838:	e24bd004 	sub	sp, fp, #4
    883c:	e8bd8800 	pop	{fp, pc}
    8840:	00009928 	andeq	r9, r0, r8, lsr #18

00008844 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8844:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8848:	e28db000 	add	fp, sp, #0
    884c:	e24dd014 	sub	sp, sp, #20
    8850:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8854:	e3a03000 	mov	r3, #0
    8858:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    885c:	e51b3010 	ldr	r3, [fp, #-16]
    8860:	e5d33000 	ldrb	r3, [r3]
    8864:	e3530000 	cmp	r3, #0
    8868:	0a000017 	beq	88cc <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    886c:	e51b2008 	ldr	r2, [fp, #-8]
    8870:	e1a03002 	mov	r3, r2
    8874:	e1a03103 	lsl	r3, r3, #2
    8878:	e0833002 	add	r3, r3, r2
    887c:	e1a03083 	lsl	r3, r3, #1
    8880:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8884:	e51b3010 	ldr	r3, [fp, #-16]
    8888:	e5d33000 	ldrb	r3, [r3]
    888c:	e3530039 	cmp	r3, #57	; 0x39
    8890:	8a00000d 	bhi	88cc <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8894:	e51b3010 	ldr	r3, [fp, #-16]
    8898:	e5d33000 	ldrb	r3, [r3]
    889c:	e353002f 	cmp	r3, #47	; 0x2f
    88a0:	9a000009 	bls	88cc <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    88a4:	e51b3010 	ldr	r3, [fp, #-16]
    88a8:	e5d33000 	ldrb	r3, [r3]
    88ac:	e2433030 	sub	r3, r3, #48	; 0x30
    88b0:	e51b2008 	ldr	r2, [fp, #-8]
    88b4:	e0823003 	add	r3, r2, r3
    88b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    88bc:	e51b3010 	ldr	r3, [fp, #-16]
    88c0:	e2833001 	add	r3, r3, #1
    88c4:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    88c8:	eaffffe3 	b	885c <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    88cc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    88d0:	e1a00003 	mov	r0, r3
    88d4:	e28bd000 	add	sp, fp, #0
    88d8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88dc:	e12fff1e 	bx	lr

000088e0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    88e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88e4:	e28db000 	add	fp, sp, #0
    88e8:	e24dd01c 	sub	sp, sp, #28
    88ec:	e50b0010 	str	r0, [fp, #-16]
    88f0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    88f4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    88f8:	e3a03000 	mov	r3, #0
    88fc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8900:	e51b2008 	ldr	r2, [fp, #-8]
    8904:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8908:	e1520003 	cmp	r2, r3
    890c:	aa000011 	bge	8958 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8910:	e51b3008 	ldr	r3, [fp, #-8]
    8914:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8918:	e0823003 	add	r3, r2, r3
    891c:	e5d33000 	ldrb	r3, [r3]
    8920:	e3530000 	cmp	r3, #0
    8924:	0a00000b 	beq	8958 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8928:	e51b3008 	ldr	r3, [fp, #-8]
    892c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8930:	e0822003 	add	r2, r2, r3
    8934:	e51b3008 	ldr	r3, [fp, #-8]
    8938:	e51b1010 	ldr	r1, [fp, #-16]
    893c:	e0813003 	add	r3, r1, r3
    8940:	e5d22000 	ldrb	r2, [r2]
    8944:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e2833001 	add	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
    8954:	eaffffe9 	b	8900 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8958:	e51b2008 	ldr	r2, [fp, #-8]
    895c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8960:	e1520003 	cmp	r2, r3
    8964:	aa000008 	bge	898c <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8968:	e51b3008 	ldr	r3, [fp, #-8]
    896c:	e51b2010 	ldr	r2, [fp, #-16]
    8970:	e0823003 	add	r3, r2, r3
    8974:	e3a02000 	mov	r2, #0
    8978:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    897c:	e51b3008 	ldr	r3, [fp, #-8]
    8980:	e2833001 	add	r3, r3, #1
    8984:	e50b3008 	str	r3, [fp, #-8]
    8988:	eafffff2 	b	8958 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    898c:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8990:	e1a00003 	mov	r0, r3
    8994:	e28bd000 	add	sp, fp, #0
    8998:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    899c:	e12fff1e 	bx	lr

000089a0 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    89a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a4:	e28db000 	add	fp, sp, #0
    89a8:	e24dd01c 	sub	sp, sp, #28
    89ac:	e50b0010 	str	r0, [fp, #-16]
    89b0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89b4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    89b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89bc:	e2432001 	sub	r2, r3, #1
    89c0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    89c4:	e3530000 	cmp	r3, #0
    89c8:	c3a03001 	movgt	r3, #1
    89cc:	d3a03000 	movle	r3, #0
    89d0:	e6ef3073 	uxtb	r3, r3
    89d4:	e3530000 	cmp	r3, #0
    89d8:	0a000016 	beq	8a38 <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    89dc:	e51b3010 	ldr	r3, [fp, #-16]
    89e0:	e2832001 	add	r2, r3, #1
    89e4:	e50b2010 	str	r2, [fp, #-16]
    89e8:	e5d33000 	ldrb	r3, [r3]
    89ec:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    89f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    89f4:	e2832001 	add	r2, r3, #1
    89f8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    89fc:	e5d33000 	ldrb	r3, [r3]
    8a00:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8a04:	e55b2005 	ldrb	r2, [fp, #-5]
    8a08:	e55b3006 	ldrb	r3, [fp, #-6]
    8a0c:	e1520003 	cmp	r2, r3
    8a10:	0a000003 	beq	8a24 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8a14:	e55b2005 	ldrb	r2, [fp, #-5]
    8a18:	e55b3006 	ldrb	r3, [fp, #-6]
    8a1c:	e0423003 	sub	r3, r2, r3
    8a20:	ea000005 	b	8a3c <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8a24:	e55b3005 	ldrb	r3, [fp, #-5]
    8a28:	e3530000 	cmp	r3, #0
    8a2c:	1affffe1 	bne	89b8 <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8a30:	e3a03000 	mov	r3, #0
    8a34:	ea000000 	b	8a3c <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8a38:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8a3c:	e1a00003 	mov	r0, r3
    8a40:	e28bd000 	add	sp, fp, #0
    8a44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a48:	e12fff1e 	bx	lr

00008a4c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8a4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a50:	e28db000 	add	fp, sp, #0
    8a54:	e24dd014 	sub	sp, sp, #20
    8a58:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8a5c:	e3a03000 	mov	r3, #0
    8a60:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8a64:	e51b3008 	ldr	r3, [fp, #-8]
    8a68:	e51b2010 	ldr	r2, [fp, #-16]
    8a6c:	e0823003 	add	r3, r2, r3
    8a70:	e5d33000 	ldrb	r3, [r3]
    8a74:	e3530000 	cmp	r3, #0
    8a78:	0a000003 	beq	8a8c <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8a7c:	e51b3008 	ldr	r3, [fp, #-8]
    8a80:	e2833001 	add	r3, r3, #1
    8a84:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8a88:	eafffff5 	b	8a64 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8a90:	e1a00003 	mov	r0, r3
    8a94:	e28bd000 	add	sp, fp, #0
    8a98:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a9c:	e12fff1e 	bx	lr

00008aa0 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8aa0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8aa4:	e28db000 	add	fp, sp, #0
    8aa8:	e24dd014 	sub	sp, sp, #20
    8aac:	e50b0010 	str	r0, [fp, #-16]
    8ab0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8ab4:	e51b3010 	ldr	r3, [fp, #-16]
    8ab8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8abc:	e3a03000 	mov	r3, #0
    8ac0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8ac4:	e51b2008 	ldr	r2, [fp, #-8]
    8ac8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8acc:	e1520003 	cmp	r2, r3
    8ad0:	aa000008 	bge	8af8 <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8ad4:	e51b3008 	ldr	r3, [fp, #-8]
    8ad8:	e51b200c 	ldr	r2, [fp, #-12]
    8adc:	e0823003 	add	r3, r2, r3
    8ae0:	e3a02000 	mov	r2, #0
    8ae4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8ae8:	e51b3008 	ldr	r3, [fp, #-8]
    8aec:	e2833001 	add	r3, r3, #1
    8af0:	e50b3008 	str	r3, [fp, #-8]
    8af4:	eafffff2 	b	8ac4 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8af8:	e320f000 	nop	{0}
    8afc:	e28bd000 	add	sp, fp, #0
    8b00:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b04:	e12fff1e 	bx	lr

00008b08 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8b08:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b0c:	e28db000 	add	fp, sp, #0
    8b10:	e24dd024 	sub	sp, sp, #36	; 0x24
    8b14:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b18:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8b1c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8b20:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b24:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8b28:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b2c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8b30:	e3a03000 	mov	r3, #0
    8b34:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8b38:	e51b2008 	ldr	r2, [fp, #-8]
    8b3c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b40:	e1520003 	cmp	r2, r3
    8b44:	aa00000b 	bge	8b78 <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8b48:	e51b3008 	ldr	r3, [fp, #-8]
    8b4c:	e51b200c 	ldr	r2, [fp, #-12]
    8b50:	e0822003 	add	r2, r2, r3
    8b54:	e51b3008 	ldr	r3, [fp, #-8]
    8b58:	e51b1010 	ldr	r1, [fp, #-16]
    8b5c:	e0813003 	add	r3, r1, r3
    8b60:	e5d22000 	ldrb	r2, [r2]
    8b64:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8b68:	e51b3008 	ldr	r3, [fp, #-8]
    8b6c:	e2833001 	add	r3, r3, #1
    8b70:	e50b3008 	str	r3, [fp, #-8]
    8b74:	eaffffef 	b	8b38 <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8b78:	e320f000 	nop	{0}
    8b7c:	e28bd000 	add	sp, fp, #0
    8b80:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b84:	e12fff1e 	bx	lr

00008b88 <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8b88:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b8c:	e28db000 	add	fp, sp, #0
    8b90:	e24dd014 	sub	sp, sp, #20
    8b94:	ed0b0a04 	vstr	s0, [fp, #-16]
    8b98:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8b9c:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8ba0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8ba4:	e3a03000 	mov	r3, #0
    8ba8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8bac:	e51b200c 	ldr	r2, [fp, #-12]
    8bb0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8bb4:	e1520003 	cmp	r2, r3
    8bb8:	2a000007 	bcs	8bdc <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8bbc:	ed1b7a02 	vldr	s14, [fp, #-8]
    8bc0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8bc4:	ee677a27 	vmul.f32	s15, s14, s15
    8bc8:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8bcc:	e51b300c 	ldr	r3, [fp, #-12]
    8bd0:	e2833001 	add	r3, r3, #1
    8bd4:	e50b300c 	str	r3, [fp, #-12]
    8bd8:	eafffff3 	b	8bac <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8bdc:	e51b3008 	ldr	r3, [fp, #-8]
    8be0:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8be4:	eeb00a67 	vmov.f32	s0, s15
    8be8:	e28bd000 	add	sp, fp, #0
    8bec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf0:	e12fff1e 	bx	lr

00008bf4 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8bf4:	e92d4800 	push	{fp, lr}
    8bf8:	e28db004 	add	fp, sp, #4
    8bfc:	e24dd018 	sub	sp, sp, #24
    8c00:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8c04:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8c08:	ebffff8f 	bl	8a4c <_Z6strlenPKc>
    8c0c:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8c10:	e3a03000 	mov	r3, #0
    8c14:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8c18:	e51b300c 	ldr	r3, [fp, #-12]
    8c1c:	e1a02fa3 	lsr	r2, r3, #31
    8c20:	e0823003 	add	r3, r2, r3
    8c24:	e1a030c3 	asr	r3, r3, #1
    8c28:	e1a02003 	mov	r2, r3
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e1530002 	cmp	r3, r2
    8c34:	aa00001c 	bge	8cac <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8c38:	e51b3008 	ldr	r3, [fp, #-8]
    8c3c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8c40:	e0823003 	add	r3, r2, r3
    8c44:	e5d33000 	ldrb	r3, [r3]
    8c48:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8c4c:	e51b200c 	ldr	r2, [fp, #-12]
    8c50:	e51b3008 	ldr	r3, [fp, #-8]
    8c54:	e0423003 	sub	r3, r2, r3
    8c58:	e2433001 	sub	r3, r3, #1
    8c5c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8c60:	e0822003 	add	r2, r2, r3
    8c64:	e51b3008 	ldr	r3, [fp, #-8]
    8c68:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8c6c:	e0813003 	add	r3, r1, r3
    8c70:	e5d22000 	ldrb	r2, [r2]
    8c74:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8c78:	e51b200c 	ldr	r2, [fp, #-12]
    8c7c:	e51b3008 	ldr	r3, [fp, #-8]
    8c80:	e0423003 	sub	r3, r2, r3
    8c84:	e2433001 	sub	r3, r3, #1
    8c88:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8c8c:	e0823003 	add	r3, r2, r3
    8c90:	e51b2010 	ldr	r2, [fp, #-16]
    8c94:	e6ef2072 	uxtb	r2, r2
    8c98:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8c9c:	e51b3008 	ldr	r3, [fp, #-8]
    8ca0:	e2833001 	add	r3, r3, #1
    8ca4:	e50b3008 	str	r3, [fp, #-8]
    8ca8:	eaffffda 	b	8c18 <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8cac:	e320f000 	nop	{0}
    8cb0:	e24bd004 	sub	sp, fp, #4
    8cb4:	e8bd8800 	pop	{fp, pc}

00008cb8 <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8cb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cbc:	e28db000 	add	fp, sp, #0
    8cc0:	e24dd01c 	sub	sp, sp, #28
    8cc4:	ed0b0a04 	vstr	s0, [fp, #-16]
    8cc8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8ccc:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8cd0:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8cd4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8cd8:	ed9f7af3 	vldr	s14, [pc, #972]	; 90ac <_Z11split_floatfRjS_Ri+0x3f4>
    8cdc:	eef47ac7 	vcmpe.f32	s15, s14
    8ce0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ce4:	ba000053 	blt	8e38 <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8ce8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8cec:	ed9f7aef 	vldr	s14, [pc, #956]	; 90b0 <_Z11split_floatfRjS_Ri+0x3f8>
    8cf0:	eef47ac7 	vcmpe.f32	s15, s14
    8cf4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8cf8:	ba000008 	blt	8d20 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8cfc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d00:	ed9f7aeb 	vldr	s14, [pc, #940]	; 90b4 <_Z11split_floatfRjS_Ri+0x3fc>
    8d04:	ee677a87 	vmul.f32	s15, s15, s14
    8d08:	ed4b7a04 	vstr	s15, [fp, #-16]
    8d0c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d10:	e5933000 	ldr	r3, [r3]
    8d14:	e2832020 	add	r2, r3, #32
    8d18:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d1c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    8d20:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d24:	ed9f7ae3 	vldr	s14, [pc, #908]	; 90b8 <_Z11split_floatfRjS_Ri+0x400>
    8d28:	eef47ac7 	vcmpe.f32	s15, s14
    8d2c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d30:	ba000008 	blt	8d58 <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8d34:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d38:	ed9f7adf 	vldr	s14, [pc, #892]	; 90bc <_Z11split_floatfRjS_Ri+0x404>
    8d3c:	ee677a87 	vmul.f32	s15, s15, s14
    8d40:	ed4b7a04 	vstr	s15, [fp, #-16]
    8d44:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d48:	e5933000 	ldr	r3, [r3]
    8d4c:	e2832010 	add	r2, r3, #16
    8d50:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d54:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    8d58:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d5c:	ed9f7ad7 	vldr	s14, [pc, #860]	; 90c0 <_Z11split_floatfRjS_Ri+0x408>
    8d60:	eef47ac7 	vcmpe.f32	s15, s14
    8d64:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d68:	ba000008 	blt	8d90 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    8d6c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d70:	ed9f7ad3 	vldr	s14, [pc, #844]	; 90c4 <_Z11split_floatfRjS_Ri+0x40c>
    8d74:	ee677a87 	vmul.f32	s15, s15, s14
    8d78:	ed4b7a04 	vstr	s15, [fp, #-16]
    8d7c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d80:	e5933000 	ldr	r3, [r3]
    8d84:	e2832008 	add	r2, r3, #8
    8d88:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8d8c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    8d90:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d94:	ed9f7acb 	vldr	s14, [pc, #812]	; 90c8 <_Z11split_floatfRjS_Ri+0x410>
    8d98:	eef47ac7 	vcmpe.f32	s15, s14
    8d9c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8da0:	ba000008 	blt	8dc8 <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    8da4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8da8:	ed9f7ac7 	vldr	s14, [pc, #796]	; 90cc <_Z11split_floatfRjS_Ri+0x414>
    8dac:	ee677a87 	vmul.f32	s15, s15, s14
    8db0:	ed4b7a04 	vstr	s15, [fp, #-16]
    8db4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8db8:	e5933000 	ldr	r3, [r3]
    8dbc:	e2832004 	add	r2, r3, #4
    8dc0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8dc4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    8dc8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8dcc:	ed9f7abf 	vldr	s14, [pc, #764]	; 90d0 <_Z11split_floatfRjS_Ri+0x418>
    8dd0:	eef47ac7 	vcmpe.f32	s15, s14
    8dd4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dd8:	ba000008 	blt	8e00 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    8ddc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8de0:	ed9f7abb 	vldr	s14, [pc, #748]	; 90d4 <_Z11split_floatfRjS_Ri+0x41c>
    8de4:	ee677a87 	vmul.f32	s15, s15, s14
    8de8:	ed4b7a04 	vstr	s15, [fp, #-16]
    8dec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8df0:	e5933000 	ldr	r3, [r3]
    8df4:	e2832002 	add	r2, r3, #2
    8df8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8dfc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    8e00:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e04:	ed9f7aa8 	vldr	s14, [pc, #672]	; 90ac <_Z11split_floatfRjS_Ri+0x3f4>
    8e08:	eef47ac7 	vcmpe.f32	s15, s14
    8e0c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e10:	ba000008 	blt	8e38 <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    8e14:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e18:	ed9f7aae 	vldr	s14, [pc, #696]	; 90d8 <_Z11split_floatfRjS_Ri+0x420>
    8e1c:	ee677a87 	vmul.f32	s15, s15, s14
    8e20:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e24:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e28:	e5933000 	ldr	r3, [r3]
    8e2c:	e2832001 	add	r2, r3, #1
    8e30:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e34:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    8e38:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e3c:	eef57ac0 	vcmpe.f32	s15, #0.0
    8e40:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e44:	da000058 	ble	8fac <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    8e48:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e4c:	ed9f7aa2 	vldr	s14, [pc, #648]	; 90dc <_Z11split_floatfRjS_Ri+0x424>
    8e50:	eef47ac7 	vcmpe.f32	s15, s14
    8e54:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e58:	8a000053 	bhi	8fac <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    8e5c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e60:	ed9f7a9e 	vldr	s14, [pc, #632]	; 90e0 <_Z11split_floatfRjS_Ri+0x428>
    8e64:	eef47ac7 	vcmpe.f32	s15, s14
    8e68:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e6c:	5a000008 	bpl	8e94 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    8e70:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e74:	ed9f7a8d 	vldr	s14, [pc, #564]	; 90b0 <_Z11split_floatfRjS_Ri+0x3f8>
    8e78:	ee677a87 	vmul.f32	s15, s15, s14
    8e7c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e84:	e5933000 	ldr	r3, [r3]
    8e88:	e2432020 	sub	r2, r3, #32
    8e8c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e90:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    8e94:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e98:	ed9f7a91 	vldr	s14, [pc, #580]	; 90e4 <_Z11split_floatfRjS_Ri+0x42c>
    8e9c:	eef47ac7 	vcmpe.f32	s15, s14
    8ea0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ea4:	5a000008 	bpl	8ecc <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    8ea8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8eac:	ed9f7a81 	vldr	s14, [pc, #516]	; 90b8 <_Z11split_floatfRjS_Ri+0x400>
    8eb0:	ee677a87 	vmul.f32	s15, s15, s14
    8eb4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8eb8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ebc:	e5933000 	ldr	r3, [r3]
    8ec0:	e2432010 	sub	r2, r3, #16
    8ec4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ec8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    8ecc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ed0:	ed9f7a84 	vldr	s14, [pc, #528]	; 90e8 <_Z11split_floatfRjS_Ri+0x430>
    8ed4:	eef47ac7 	vcmpe.f32	s15, s14
    8ed8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8edc:	5a000008 	bpl	8f04 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    8ee0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ee4:	ed9f7a75 	vldr	s14, [pc, #468]	; 90c0 <_Z11split_floatfRjS_Ri+0x408>
    8ee8:	ee677a87 	vmul.f32	s15, s15, s14
    8eec:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ef0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ef4:	e5933000 	ldr	r3, [r3]
    8ef8:	e2432008 	sub	r2, r3, #8
    8efc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f00:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    8f04:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f08:	ed9f7a77 	vldr	s14, [pc, #476]	; 90ec <_Z11split_floatfRjS_Ri+0x434>
    8f0c:	eef47ac7 	vcmpe.f32	s15, s14
    8f10:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f14:	5a000008 	bpl	8f3c <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    8f18:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f1c:	ed9f7a69 	vldr	s14, [pc, #420]	; 90c8 <_Z11split_floatfRjS_Ri+0x410>
    8f20:	ee677a87 	vmul.f32	s15, s15, s14
    8f24:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f28:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f2c:	e5933000 	ldr	r3, [r3]
    8f30:	e2432004 	sub	r2, r3, #4
    8f34:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f38:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    8f3c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f40:	ed9f7a64 	vldr	s14, [pc, #400]	; 90d8 <_Z11split_floatfRjS_Ri+0x420>
    8f44:	eef47ac7 	vcmpe.f32	s15, s14
    8f48:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f4c:	5a000008 	bpl	8f74 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    8f50:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f54:	ed9f7a5d 	vldr	s14, [pc, #372]	; 90d0 <_Z11split_floatfRjS_Ri+0x418>
    8f58:	ee677a87 	vmul.f32	s15, s15, s14
    8f5c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f60:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f64:	e5933000 	ldr	r3, [r3]
    8f68:	e2432002 	sub	r2, r3, #2
    8f6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f70:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    8f74:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f78:	ed9f7a57 	vldr	s14, [pc, #348]	; 90dc <_Z11split_floatfRjS_Ri+0x424>
    8f7c:	eef47ac7 	vcmpe.f32	s15, s14
    8f80:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f84:	5a000008 	bpl	8fac <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    8f88:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f8c:	ed9f7a46 	vldr	s14, [pc, #280]	; 90ac <_Z11split_floatfRjS_Ri+0x3f4>
    8f90:	ee677a87 	vmul.f32	s15, s15, s14
    8f94:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f98:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f9c:	e5933000 	ldr	r3, [r3]
    8fa0:	e2432001 	sub	r2, r3, #1
    8fa4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fa8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    8fac:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fb0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    8fb4:	ee172a90 	vmov	r2, s15
    8fb8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8fbc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    8fc0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8fc4:	e5933000 	ldr	r3, [r3]
    8fc8:	ee073a90 	vmov	s15, r3
    8fcc:	eef87a67 	vcvt.f32.u32	s15, s15
    8fd0:	ed1b7a04 	vldr	s14, [fp, #-16]
    8fd4:	ee777a67 	vsub.f32	s15, s14, s15
    8fd8:	ed9f7a38 	vldr	s14, [pc, #224]	; 90c0 <_Z11split_floatfRjS_Ri+0x408>
    8fdc:	ee677a87 	vmul.f32	s15, s15, s14
    8fe0:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    8fe4:	ed5b7a02 	vldr	s15, [fp, #-8]
    8fe8:	eefc7ae7 	vcvt.u32.f32	s15, s15
    8fec:	ee172a90 	vmov	r2, s15
    8ff0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ff4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    8ff8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ffc:	e5933000 	ldr	r3, [r3]
    9000:	ee073a90 	vmov	s15, r3
    9004:	eef87a67 	vcvt.f32.u32	s15, s15
    9008:	ed1b7a02 	vldr	s14, [fp, #-8]
    900c:	ee777a67 	vsub.f32	s15, s14, s15
    9010:	ed9f7a36 	vldr	s14, [pc, #216]	; 90f0 <_Z11split_floatfRjS_Ri+0x438>
    9014:	eef47ac7 	vcmpe.f32	s15, s14
    9018:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    901c:	aa000000 	bge	9024 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    9020:	ea00001d 	b	909c <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    9024:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9028:	e5933000 	ldr	r3, [r3]
    902c:	e2832001 	add	r2, r3, #1
    9030:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9034:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    9038:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    903c:	e5933000 	ldr	r3, [r3]
    9040:	e59f20ac 	ldr	r2, [pc, #172]	; 90f4 <_Z11split_floatfRjS_Ri+0x43c>
    9044:	e1530002 	cmp	r3, r2
    9048:	9a000013 	bls	909c <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    904c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9050:	e3a02000 	mov	r2, #0
    9054:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    9058:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    905c:	e5933000 	ldr	r3, [r3]
    9060:	e2832001 	add	r2, r3, #1
    9064:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9068:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    906c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9070:	e5933000 	ldr	r3, [r3]
    9074:	e3530009 	cmp	r3, #9
    9078:	9a000007 	bls	909c <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    907c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9080:	e3a02001 	mov	r2, #1
    9084:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    9088:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    908c:	e5933000 	ldr	r3, [r3]
    9090:	e2832001 	add	r2, r3, #1
    9094:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9098:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    909c:	e320f000 	nop	{0}
    90a0:	e28bd000 	add	sp, fp, #0
    90a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90a8:	e12fff1e 	bx	lr
    90ac:	41200000 			; <UNDEFINED> instruction: 0x41200000
    90b0:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    90b4:	0a4fb11f 	beq	13f5538 <__bss_end+0x13ebbec>
    90b8:	5a0e1bca 	bpl	38ffe8 <__bss_end+0x38669c>
    90bc:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    90c0:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    90c4:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    90c8:	461c4000 	ldrmi	r4, [ip], -r0
    90cc:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    90d0:	42c80000 	sbcmi	r0, r8, #0
    90d4:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    90d8:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    90dc:	3f800000 	svccc	0x00800000
    90e0:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    90e4:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    90e8:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    90ec:	3a83126f 	bcc	fe0cdab0 <__bss_end+0xfe0c4164>
    90f0:	3f000000 	svccc	0x00000000
    90f4:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

000090f8 <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    90f8:	e92d4800 	push	{fp, lr}
    90fc:	e28db004 	add	fp, sp, #4
    9100:	e24dd018 	sub	sp, sp, #24
    9104:	e50b0010 	str	r0, [fp, #-16]
    9108:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    910c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    9110:	e3a03000 	mov	r3, #0
    9114:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9118:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    911c:	e2432001 	sub	r2, r3, #1
    9120:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    9124:	e3530000 	cmp	r3, #0
    9128:	c3a03001 	movgt	r3, #1
    912c:	d3a03000 	movle	r3, #0
    9130:	e6ef3073 	uxtb	r3, r3
    9134:	e3530000 	cmp	r3, #0
    9138:	0a000018 	beq	91a0 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    913c:	e51b1010 	ldr	r1, [fp, #-16]
    9140:	e59f3080 	ldr	r3, [pc, #128]	; 91c8 <_Z23decimal_to_string_floatjPci+0xd0>
    9144:	e0832193 	umull	r2, r3, r3, r1
    9148:	e1a021a3 	lsr	r2, r3, #3
    914c:	e1a03002 	mov	r3, r2
    9150:	e1a03103 	lsl	r3, r3, #2
    9154:	e0833002 	add	r3, r3, r2
    9158:	e1a03083 	lsl	r3, r3, #1
    915c:	e0412003 	sub	r2, r1, r3
    9160:	e6ef2072 	uxtb	r2, r2
    9164:	e51b3008 	ldr	r3, [fp, #-8]
    9168:	e2831001 	add	r1, r3, #1
    916c:	e50b1008 	str	r1, [fp, #-8]
    9170:	e1a01003 	mov	r1, r3
    9174:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9178:	e0833001 	add	r3, r3, r1
    917c:	e2822030 	add	r2, r2, #48	; 0x30
    9180:	e6ef2072 	uxtb	r2, r2
    9184:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    9188:	e51b3010 	ldr	r3, [fp, #-16]
    918c:	e59f2034 	ldr	r2, [pc, #52]	; 91c8 <_Z23decimal_to_string_floatjPci+0xd0>
    9190:	e0832392 	umull	r2, r3, r2, r3
    9194:	e1a031a3 	lsr	r3, r3, #3
    9198:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    919c:	eaffffdd 	b	9118 <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    91a0:	e51b3008 	ldr	r3, [fp, #-8]
    91a4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    91a8:	e0823003 	add	r3, r2, r3
    91ac:	e3a02000 	mov	r2, #0
    91b0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    91b4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    91b8:	ebfffe8d 	bl	8bf4 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    91bc:	e320f000 	nop	{0}
    91c0:	e24bd004 	sub	sp, fp, #4
    91c4:	e8bd8800 	pop	{fp, pc}
    91c8:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000091cc <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    91cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91d0:	e28db000 	add	fp, sp, #0
    91d4:	e24dd00c 	sub	sp, sp, #12
    91d8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    91dc:	ed1b7a02 	vldr	s14, [fp, #-8]
    91e0:	ed5b7a02 	vldr	s15, [fp, #-8]
    91e4:	eeb47a67 	vcmp.f32	s14, s15
    91e8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91ec:	13a03001 	movne	r3, #1
    91f0:	03a03000 	moveq	r3, #0
    91f4:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    91f8:	e1a00003 	mov	r0, r3
    91fc:	e28bd000 	add	sp, fp, #0
    9200:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9204:	e12fff1e 	bx	lr

00009208 <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    9208:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    920c:	e28db000 	add	fp, sp, #0
    9210:	e24dd00c 	sub	sp, sp, #12
    9214:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    9218:	ed5b7a02 	vldr	s15, [fp, #-8]
    921c:	ed9f7a08 	vldr	s14, [pc, #32]	; 9244 <_Z5isinff+0x3c>
    9220:	eef47ac7 	vcmpe.f32	s15, s14
    9224:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9228:	c3a03001 	movgt	r3, #1
    922c:	d3a03000 	movle	r3, #0
    9230:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    9234:	e1a00003 	mov	r0, r3
    9238:	e28bd000 	add	sp, fp, #0
    923c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9240:	e12fff1e 	bx	lr
    9244:	7f7fffff 	svcvc	0x007fffff

00009248 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    9248:	e92d4800 	push	{fp, lr}
    924c:	e28db004 	add	fp, sp, #4
    9250:	e24dd008 	sub	sp, sp, #8
    9254:	ed0b0a02 	vstr	s0, [fp, #-8]
    9258:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    925c:	e3a01008 	mov	r1, #8
    9260:	e51b000c 	ldr	r0, [fp, #-12]
    9264:	ed1b0a02 	vldr	s0, [fp, #-8]
    9268:	eb000002 	bl	9278 <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    926c:	e320f000 	nop	{0}
    9270:	e24bd004 	sub	sp, fp, #4
    9274:	e8bd8800 	pop	{fp, pc}

00009278 <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    9278:	e92d4800 	push	{fp, lr}
    927c:	e28db004 	add	fp, sp, #4
    9280:	e24dd060 	sub	sp, sp, #96	; 0x60
    9284:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    9288:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    928c:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9290:	e3a03000 	mov	r3, #0
    9294:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    9298:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    929c:	eef57ac0 	vcmpe.f32	s15, #0.0
    92a0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92a4:	5a000009 	bpl	92d0 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    92a8:	e51b3008 	ldr	r3, [fp, #-8]
    92ac:	e2832001 	add	r2, r3, #1
    92b0:	e50b2008 	str	r2, [fp, #-8]
    92b4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92b8:	e0823003 	add	r3, r2, r3
    92bc:	e3a0202d 	mov	r2, #45	; 0x2d
    92c0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    92c4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    92c8:	eef17a67 	vneg.f32	s15, s15
    92cc:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    92d0:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    92d4:	ebffffbc 	bl	91cc <_Z5isnanf>
    92d8:	e1a03000 	mov	r3, r0
    92dc:	e3530000 	cmp	r3, #0
    92e0:	0a00001c 	beq	9358 <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    92e4:	e51b3008 	ldr	r3, [fp, #-8]
    92e8:	e2832001 	add	r2, r3, #1
    92ec:	e50b2008 	str	r2, [fp, #-8]
    92f0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    92f4:	e0823003 	add	r3, r2, r3
    92f8:	e3a0204e 	mov	r2, #78	; 0x4e
    92fc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    9300:	e51b3008 	ldr	r3, [fp, #-8]
    9304:	e2832001 	add	r2, r3, #1
    9308:	e50b2008 	str	r2, [fp, #-8]
    930c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9310:	e0823003 	add	r3, r2, r3
    9314:	e3a02061 	mov	r2, #97	; 0x61
    9318:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    931c:	e51b3008 	ldr	r3, [fp, #-8]
    9320:	e2832001 	add	r2, r3, #1
    9324:	e50b2008 	str	r2, [fp, #-8]
    9328:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    932c:	e0823003 	add	r3, r2, r3
    9330:	e3a0204e 	mov	r2, #78	; 0x4e
    9334:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    9338:	e51b3008 	ldr	r3, [fp, #-8]
    933c:	e2832001 	add	r2, r3, #1
    9340:	e50b2008 	str	r2, [fp, #-8]
    9344:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9348:	e0823003 	add	r3, r2, r3
    934c:	e3a02000 	mov	r2, #0
    9350:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    9354:	ea00008c 	b	958c <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    9358:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    935c:	ebffffa9 	bl	9208 <_Z5isinff>
    9360:	e1a03000 	mov	r3, r0
    9364:	e3530000 	cmp	r3, #0
    9368:	0a00001c 	beq	93e0 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    936c:	e51b3008 	ldr	r3, [fp, #-8]
    9370:	e2832001 	add	r2, r3, #1
    9374:	e50b2008 	str	r2, [fp, #-8]
    9378:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    937c:	e0823003 	add	r3, r2, r3
    9380:	e3a02049 	mov	r2, #73	; 0x49
    9384:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    9388:	e51b3008 	ldr	r3, [fp, #-8]
    938c:	e2832001 	add	r2, r3, #1
    9390:	e50b2008 	str	r2, [fp, #-8]
    9394:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9398:	e0823003 	add	r3, r2, r3
    939c:	e3a0206e 	mov	r2, #110	; 0x6e
    93a0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    93a4:	e51b3008 	ldr	r3, [fp, #-8]
    93a8:	e2832001 	add	r2, r3, #1
    93ac:	e50b2008 	str	r2, [fp, #-8]
    93b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93b4:	e0823003 	add	r3, r2, r3
    93b8:	e3a02066 	mov	r2, #102	; 0x66
    93bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    93c0:	e51b3008 	ldr	r3, [fp, #-8]
    93c4:	e2832001 	add	r2, r3, #1
    93c8:	e50b2008 	str	r2, [fp, #-8]
    93cc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93d0:	e0823003 	add	r3, r2, r3
    93d4:	e3a02000 	mov	r2, #0
    93d8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    93dc:	ea00006a 	b	958c <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    93e0:	e3a03008 	mov	r3, #8
    93e4:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    93e8:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    93ec:	e3530007 	cmp	r3, #7
    93f0:	8a000001 	bhi	93fc <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    93f4:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    93f8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    93fc:	e51b300c 	ldr	r3, [fp, #-12]
    9400:	e1a00003 	mov	r0, r3
    9404:	ed9f0a62 	vldr	s0, [pc, #392]	; 9594 <_Z4ftoafPcj+0x31c>
    9408:	ebfffdde 	bl	8b88 <_Z3powfj>
    940c:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    9410:	eddf6a60 	vldr	s13, [pc, #384]	; 9598 <_Z4ftoafPcj+0x320>
    9414:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    9418:	eec67a87 	vdiv.f32	s15, s13, s14
    941c:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9420:	ee777a27 	vadd.f32	s15, s14, s15
    9424:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    9428:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    942c:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9430:	ee173a90 	vmov	r3, s15
    9434:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    9438:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    943c:	ee073a90 	vmov	s15, r3
    9440:	eef87a67 	vcvt.f32.u32	s15, s15
    9444:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9448:	ee377a67 	vsub.f32	s14, s14, s15
    944c:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    9450:	ee677a27 	vmul.f32	s15, s14, s15
    9454:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9458:	ee173a90 	vmov	r3, s15
    945c:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    9460:	e24b3044 	sub	r3, fp, #68	; 0x44
    9464:	e3a0200a 	mov	r2, #10
    9468:	e1a01003 	mov	r1, r3
    946c:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9470:	ebfffc96 	bl	86d0 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9474:	e24b3044 	sub	r3, fp, #68	; 0x44
    9478:	e1a00003 	mov	r0, r3
    947c:	ebfffd72 	bl	8a4c <_Z6strlenPKc>
    9480:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9484:	e3a03000 	mov	r3, #0
    9488:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    948c:	e51b2010 	ldr	r2, [fp, #-16]
    9490:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9494:	e1520003 	cmp	r2, r3
    9498:	aa00000d 	bge	94d4 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    949c:	e51b3008 	ldr	r3, [fp, #-8]
    94a0:	e2832001 	add	r2, r3, #1
    94a4:	e50b2008 	str	r2, [fp, #-8]
    94a8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94ac:	e0823003 	add	r3, r2, r3
    94b0:	e24b1044 	sub	r1, fp, #68	; 0x44
    94b4:	e51b2010 	ldr	r2, [fp, #-16]
    94b8:	e0812002 	add	r2, r1, r2
    94bc:	e5d22000 	ldrb	r2, [r2]
    94c0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    94c4:	e51b3010 	ldr	r3, [fp, #-16]
    94c8:	e2833001 	add	r3, r3, #1
    94cc:	e50b3010 	str	r3, [fp, #-16]
    94d0:	eaffffed 	b	948c <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    94d4:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    94d8:	e3530000 	cmp	r3, #0
    94dc:	0a000025 	beq	9578 <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    94e0:	e51b3008 	ldr	r3, [fp, #-8]
    94e4:	e2832001 	add	r2, r3, #1
    94e8:	e50b2008 	str	r2, [fp, #-8]
    94ec:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94f0:	e0823003 	add	r3, r2, r3
    94f4:	e3a0202e 	mov	r2, #46	; 0x2e
    94f8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    94fc:	e24b3050 	sub	r3, fp, #80	; 0x50
    9500:	e51b200c 	ldr	r2, [fp, #-12]
    9504:	e1a01003 	mov	r1, r3
    9508:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    950c:	ebfffef9 	bl	90f8 <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    9510:	e3a03000 	mov	r3, #0
    9514:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    9518:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    951c:	e3530008 	cmp	r3, #8
    9520:	ca000014 	bgt	9578 <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    9524:	e24b2050 	sub	r2, fp, #80	; 0x50
    9528:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    952c:	e0823003 	add	r3, r2, r3
    9530:	e5d33000 	ldrb	r3, [r3]
    9534:	e3530000 	cmp	r3, #0
    9538:	0a00000d 	beq	9574 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    953c:	e51b3008 	ldr	r3, [fp, #-8]
    9540:	e2832001 	add	r2, r3, #1
    9544:	e50b2008 	str	r2, [fp, #-8]
    9548:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    954c:	e0823003 	add	r3, r2, r3
    9550:	e24b1050 	sub	r1, fp, #80	; 0x50
    9554:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9558:	e0812002 	add	r2, r1, r2
    955c:	e5d22000 	ldrb	r2, [r2]
    9560:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    9564:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9568:	e2833001 	add	r3, r3, #1
    956c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9570:	eaffffe8 	b	9518 <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9574:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    9578:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    957c:	e51b3008 	ldr	r3, [fp, #-8]
    9580:	e0823003 	add	r3, r2, r3
    9584:	e3a02000 	mov	r2, #0
    9588:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    958c:	e24bd004 	sub	sp, fp, #4
    9590:	e8bd8800 	pop	{fp, pc}
    9594:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9598:	3f000000 	svccc	0x00000000

0000959c <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    959c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    95a0:	e28db000 	add	fp, sp, #0
    95a4:	e24dd01c 	sub	sp, sp, #28
    95a8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    95ac:	e3a03000 	mov	r3, #0
    95b0:	e50b3008 	str	r3, [fp, #-8]
    95b4:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    95b8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    95bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95c0:	e5d33000 	ldrb	r3, [r3]
    95c4:	e353002d 	cmp	r3, #45	; 0x2d
    95c8:	1a000004 	bne	95e0 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    95cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95d0:	e2833001 	add	r3, r3, #1
    95d4:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    95d8:	e59f30c8 	ldr	r3, [pc, #200]	; 96a8 <_Z4atofPKc+0x10c>
    95dc:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    95e0:	e3a03000 	mov	r3, #0
    95e4:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    95e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95ec:	e5d33000 	ldrb	r3, [r3]
    95f0:	e3530000 	cmp	r3, #0
    95f4:	0a000023 	beq	9688 <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    95f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95fc:	e5d33000 	ldrb	r3, [r3]
    9600:	e353002e 	cmp	r3, #46	; 0x2e
    9604:	1a000002 	bne	9614 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    9608:	e3a03001 	mov	r3, #1
    960c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    9610:	ea000018 	b	9678 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    9614:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9618:	e5d33000 	ldrb	r3, [r3]
    961c:	e2433030 	sub	r3, r3, #48	; 0x30
    9620:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    9624:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9628:	e3530000 	cmp	r3, #0
    962c:	ba000011 	blt	9678 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    9630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9634:	e3530009 	cmp	r3, #9
    9638:	ca00000e 	bgt	9678 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    963c:	e51b3010 	ldr	r3, [fp, #-16]
    9640:	e3530000 	cmp	r3, #0
    9644:	0a000003 	beq	9658 <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    9648:	ed1b7a03 	vldr	s14, [fp, #-12]
    964c:	eddf6a14 	vldr	s13, [pc, #80]	; 96a4 <_Z4atofPKc+0x108>
    9650:	eec77a26 	vdiv.f32	s15, s14, s13
    9654:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    9658:	ed5b7a02 	vldr	s15, [fp, #-8]
    965c:	ed9f7a10 	vldr	s14, [pc, #64]	; 96a4 <_Z4atofPKc+0x108>
    9660:	ee277a87 	vmul.f32	s14, s15, s14
    9664:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9668:	ee073a90 	vmov	s15, r3
    966c:	eef87ae7 	vcvt.f32.s32	s15, s15
    9670:	ee777a27 	vadd.f32	s15, s14, s15
    9674:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    9678:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    967c:	e2833001 	add	r3, r3, #1
    9680:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9684:	eaffffd7 	b	95e8 <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    9688:	ed1b7a02 	vldr	s14, [fp, #-8]
    968c:	ed5b7a03 	vldr	s15, [fp, #-12]
    9690:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9694:	eeb00a67 	vmov.f32	s0, s15
    9698:	e28bd000 	add	sp, fp, #0
    969c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    96a0:	e12fff1e 	bx	lr
    96a4:	41200000 			; <UNDEFINED> instruction: 0x41200000
    96a8:	bf800000 	svclt	0x00800000

000096ac <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    96ac:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    96b0:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    96b4:	3a000074 	bcc	988c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    96b8:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    96bc:	9a00006b 	bls	9870 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    96c0:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    96c4:	0a00006c 	beq	987c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    96c8:	e16f3f10 	clz	r3, r0
    96cc:	e16f2f11 	clz	r2, r1
    96d0:	e0423003 	sub	r3, r2, r3
    96d4:	e273301f 	rsbs	r3, r3, #31
    96d8:	10833083 	addne	r3, r3, r3, lsl #1
    96dc:	e3a02000 	mov	r2, #0
    96e0:	108ff103 	addne	pc, pc, r3, lsl #2
    96e4:	e1a00000 	nop			; (mov r0, r0)
    96e8:	e1500f81 	cmp	r0, r1, lsl #31
    96ec:	e0a22002 	adc	r2, r2, r2
    96f0:	20400f81 	subcs	r0, r0, r1, lsl #31
    96f4:	e1500f01 	cmp	r0, r1, lsl #30
    96f8:	e0a22002 	adc	r2, r2, r2
    96fc:	20400f01 	subcs	r0, r0, r1, lsl #30
    9700:	e1500e81 	cmp	r0, r1, lsl #29
    9704:	e0a22002 	adc	r2, r2, r2
    9708:	20400e81 	subcs	r0, r0, r1, lsl #29
    970c:	e1500e01 	cmp	r0, r1, lsl #28
    9710:	e0a22002 	adc	r2, r2, r2
    9714:	20400e01 	subcs	r0, r0, r1, lsl #28
    9718:	e1500d81 	cmp	r0, r1, lsl #27
    971c:	e0a22002 	adc	r2, r2, r2
    9720:	20400d81 	subcs	r0, r0, r1, lsl #27
    9724:	e1500d01 	cmp	r0, r1, lsl #26
    9728:	e0a22002 	adc	r2, r2, r2
    972c:	20400d01 	subcs	r0, r0, r1, lsl #26
    9730:	e1500c81 	cmp	r0, r1, lsl #25
    9734:	e0a22002 	adc	r2, r2, r2
    9738:	20400c81 	subcs	r0, r0, r1, lsl #25
    973c:	e1500c01 	cmp	r0, r1, lsl #24
    9740:	e0a22002 	adc	r2, r2, r2
    9744:	20400c01 	subcs	r0, r0, r1, lsl #24
    9748:	e1500b81 	cmp	r0, r1, lsl #23
    974c:	e0a22002 	adc	r2, r2, r2
    9750:	20400b81 	subcs	r0, r0, r1, lsl #23
    9754:	e1500b01 	cmp	r0, r1, lsl #22
    9758:	e0a22002 	adc	r2, r2, r2
    975c:	20400b01 	subcs	r0, r0, r1, lsl #22
    9760:	e1500a81 	cmp	r0, r1, lsl #21
    9764:	e0a22002 	adc	r2, r2, r2
    9768:	20400a81 	subcs	r0, r0, r1, lsl #21
    976c:	e1500a01 	cmp	r0, r1, lsl #20
    9770:	e0a22002 	adc	r2, r2, r2
    9774:	20400a01 	subcs	r0, r0, r1, lsl #20
    9778:	e1500981 	cmp	r0, r1, lsl #19
    977c:	e0a22002 	adc	r2, r2, r2
    9780:	20400981 	subcs	r0, r0, r1, lsl #19
    9784:	e1500901 	cmp	r0, r1, lsl #18
    9788:	e0a22002 	adc	r2, r2, r2
    978c:	20400901 	subcs	r0, r0, r1, lsl #18
    9790:	e1500881 	cmp	r0, r1, lsl #17
    9794:	e0a22002 	adc	r2, r2, r2
    9798:	20400881 	subcs	r0, r0, r1, lsl #17
    979c:	e1500801 	cmp	r0, r1, lsl #16
    97a0:	e0a22002 	adc	r2, r2, r2
    97a4:	20400801 	subcs	r0, r0, r1, lsl #16
    97a8:	e1500781 	cmp	r0, r1, lsl #15
    97ac:	e0a22002 	adc	r2, r2, r2
    97b0:	20400781 	subcs	r0, r0, r1, lsl #15
    97b4:	e1500701 	cmp	r0, r1, lsl #14
    97b8:	e0a22002 	adc	r2, r2, r2
    97bc:	20400701 	subcs	r0, r0, r1, lsl #14
    97c0:	e1500681 	cmp	r0, r1, lsl #13
    97c4:	e0a22002 	adc	r2, r2, r2
    97c8:	20400681 	subcs	r0, r0, r1, lsl #13
    97cc:	e1500601 	cmp	r0, r1, lsl #12
    97d0:	e0a22002 	adc	r2, r2, r2
    97d4:	20400601 	subcs	r0, r0, r1, lsl #12
    97d8:	e1500581 	cmp	r0, r1, lsl #11
    97dc:	e0a22002 	adc	r2, r2, r2
    97e0:	20400581 	subcs	r0, r0, r1, lsl #11
    97e4:	e1500501 	cmp	r0, r1, lsl #10
    97e8:	e0a22002 	adc	r2, r2, r2
    97ec:	20400501 	subcs	r0, r0, r1, lsl #10
    97f0:	e1500481 	cmp	r0, r1, lsl #9
    97f4:	e0a22002 	adc	r2, r2, r2
    97f8:	20400481 	subcs	r0, r0, r1, lsl #9
    97fc:	e1500401 	cmp	r0, r1, lsl #8
    9800:	e0a22002 	adc	r2, r2, r2
    9804:	20400401 	subcs	r0, r0, r1, lsl #8
    9808:	e1500381 	cmp	r0, r1, lsl #7
    980c:	e0a22002 	adc	r2, r2, r2
    9810:	20400381 	subcs	r0, r0, r1, lsl #7
    9814:	e1500301 	cmp	r0, r1, lsl #6
    9818:	e0a22002 	adc	r2, r2, r2
    981c:	20400301 	subcs	r0, r0, r1, lsl #6
    9820:	e1500281 	cmp	r0, r1, lsl #5
    9824:	e0a22002 	adc	r2, r2, r2
    9828:	20400281 	subcs	r0, r0, r1, lsl #5
    982c:	e1500201 	cmp	r0, r1, lsl #4
    9830:	e0a22002 	adc	r2, r2, r2
    9834:	20400201 	subcs	r0, r0, r1, lsl #4
    9838:	e1500181 	cmp	r0, r1, lsl #3
    983c:	e0a22002 	adc	r2, r2, r2
    9840:	20400181 	subcs	r0, r0, r1, lsl #3
    9844:	e1500101 	cmp	r0, r1, lsl #2
    9848:	e0a22002 	adc	r2, r2, r2
    984c:	20400101 	subcs	r0, r0, r1, lsl #2
    9850:	e1500081 	cmp	r0, r1, lsl #1
    9854:	e0a22002 	adc	r2, r2, r2
    9858:	20400081 	subcs	r0, r0, r1, lsl #1
    985c:	e1500001 	cmp	r0, r1
    9860:	e0a22002 	adc	r2, r2, r2
    9864:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9868:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    986c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9870:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9874:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9878:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    987c:	e16f2f11 	clz	r2, r1
    9880:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9884:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9888:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    988c:	e3500000 	cmp	r0, #0
    9890:	13e00000 	mvnne	r0, #0
    9894:	ea000007 	b	98b8 <__aeabi_idiv0>

00009898 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9898:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    989c:	0afffffa 	beq	988c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    98a0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    98a4:	ebffff80 	bl	96ac <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    98a8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    98ac:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    98b0:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    98b4:	e12fff1e 	bx	lr

000098b8 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    98b8:	e12fff1e 	bx	lr

Disassembly of section .rodata:

000098bc <_ZL13Lock_Unlocked>:
    98bc:	00000000 	andeq	r0, r0, r0

000098c0 <_ZL11Lock_Locked>:
    98c0:	00000001 	andeq	r0, r0, r1

000098c4 <_ZL21MaxFSDriverNameLength>:
    98c4:	00000010 	andeq	r0, r0, r0, lsl r0

000098c8 <_ZL17MaxFilenameLength>:
    98c8:	00000010 	andeq	r0, r0, r0, lsl r0

000098cc <_ZL13MaxPathLength>:
    98cc:	00000080 	andeq	r0, r0, r0, lsl #1

000098d0 <_ZL18NoFilesystemDriver>:
    98d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098d4 <_ZL9NotifyAll>:
    98d4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098d8 <_ZL24Max_Process_Opened_Files>:
    98d8:	00000010 	andeq	r0, r0, r0, lsl r0

000098dc <_ZL10Indefinite>:
    98dc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098e0 <_ZL18Deadline_Unchanged>:
    98e0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000098e4 <_ZL14Invalid_Handle>:
    98e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098e8 <_ZL13Lock_Unlocked>:
    98e8:	00000000 	andeq	r0, r0, r0

000098ec <_ZL11Lock_Locked>:
    98ec:	00000001 	andeq	r0, r0, r1

000098f0 <_ZL21MaxFSDriverNameLength>:
    98f0:	00000010 	andeq	r0, r0, r0, lsl r0

000098f4 <_ZL17MaxFilenameLength>:
    98f4:	00000010 	andeq	r0, r0, r0, lsl r0

000098f8 <_ZL13MaxPathLength>:
    98f8:	00000080 	andeq	r0, r0, r0, lsl #1

000098fc <_ZL18NoFilesystemDriver>:
    98fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009900 <_ZL9NotifyAll>:
    9900:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009904 <_ZL24Max_Process_Opened_Files>:
    9904:	00000010 	andeq	r0, r0, r0, lsl r0

00009908 <_ZL10Indefinite>:
    9908:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000990c <_ZL18Deadline_Unchanged>:
    990c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009910 <_ZL14Invalid_Handle>:
    9910:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009914 <_ZL8INFINITY>:
    9914:	7f7fffff 	svcvc	0x007fffff

00009918 <_ZL16Pipe_File_Prefix>:
    9918:	3a535953 	bcc	14dfe6c <__bss_end+0x14d6520>
    991c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9920:	0000002f 	andeq	r0, r0, pc, lsr #32

00009924 <_ZL8INFINITY>:
    9924:	7f7fffff 	svcvc	0x007fffff

00009928 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9928:	33323130 	teqcc	r2, #48, 2
    992c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9930:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9934:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

0000993c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683ee0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38ad8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c6ec>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c73d8>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	322d393a 	eorcc	r3, sp, #950272	; 0xe8000
   c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
  10:	302d3471 	eorcc	r3, sp, r1, ror r4
  14:	6e756275 	mrcvs	2, 3, r6, cr5, cr5, {3}
  18:	29317574 	ldmdbcs	r1!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}
  1c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
  20:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  24:	31393130 	teqcc	r9, r0, lsr r1
  28:	20353230 	eorscs	r3, r5, r0, lsr r2
  2c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  30:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  34:	415b2029 	cmpmi	fp, r9, lsr #32
  38:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
  3c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
  40:	6172622d 	cmnvs	r2, sp, lsr #4
  44:	2068636e 	rsbcs	r6, r8, lr, ror #6
  48:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  4c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  50:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
  54:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0000005e 	andeq	r0, r0, lr, asr r0
   4:	00480003 	subeq	r0, r8, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
  24:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
  28:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
  2c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
  30:	2f70732f 	svccs	0x0070732f
  34:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
  38:	2f736563 	svccs	0x00736563
  3c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  40:	63617073 	cmnvs	r1, #115	; 0x73
  44:	63000065 	movwvs	r0, #101	; 0x65
  48:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  4c:	00010073 	andeq	r0, r1, r3, ror r0
  50:	05000000 	streq	r0, [r0, #-0]
  54:	00800002 	addeq	r0, r0, r2
  58:	01090300 	mrseq	r0, (UNDEF: 57)
  5c:	00020231 	andeq	r0, r2, r1, lsr r2
  60:	008d0101 	addeq	r0, sp, r1, lsl #2
  64:	00030000 	andeq	r0, r3, r0
  68:	00000048 	andeq	r0, r0, r8, asr #32
  6c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  70:	0101000d 	tsteq	r1, sp
  74:	00000101 	andeq	r0, r0, r1, lsl #2
  78:	00000100 	andeq	r0, r0, r0, lsl #2
  7c:	6f682f01 	svcvs	0x00682f01
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfcf0>
  84:	73656d61 	cmnvc	r5, #6208	; 0x1840
  88:	2f697261 	svccs	0x00697261
  8c:	2f746967 	svccs	0x00746967
  90:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
  94:	6f732f70 	svcvs	0x00732f70
  98:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
  9c:	73752f73 	cmnvc	r5, #460	; 0x1cc
  a0:	70737265 	rsbsvc	r7, r3, r5, ror #4
  a4:	00656361 	rsbeq	r6, r5, r1, ror #6
  a8:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
  ac:	00632e30 	rsbeq	r2, r3, r0, lsr lr
  b0:	00000001 	andeq	r0, r0, r1
  b4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
  b8:	00800802 	addeq	r0, r0, r2, lsl #16
  bc:	01090300 	mrseq	r0, (UNDEF: 57)
  c0:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
  c4:	0e054a05 	vmlaeq.f32	s8, s10, s10
  c8:	03040200 	movweq	r0, #16896	; 0x4200
  cc:	0041052f 	subeq	r0, r1, pc, lsr #10
  d0:	65030402 	strvs	r0, [r3, #-1026]	; 0xfffffbfe
  d4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
  d8:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
  dc:	05d98401 	ldrbeq	r8, [r9, #1025]	; 0x401
  e0:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
  e4:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
  e8:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
  ec:	06022f01 	streq	r2, [r2], -r1, lsl #30
  f0:	e3010100 	movw	r0, #4352	; 0x1100
  f4:	03000000 	movweq	r0, #0
  f8:	00005a00 	andeq	r5, r0, r0, lsl #20
  fc:	fb010200 	blx	40906 <__bss_end+0x36fba>
 100:	01000d0e 	tsteq	r0, lr, lsl #26
 104:	00010101 	andeq	r0, r1, r1, lsl #2
 108:	00010000 	andeq	r0, r1, r0
 10c:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 110:	2f656d6f 	svccs	0x00656d6f
 114:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 118:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 11c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 120:	2f736f2f 	svccs	0x00736f2f
 124:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 128:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff6483>
 130:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 134:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 138:	78630000 	stmdavc	r3!, {}^	; <UNPREDICTABLE>
 13c:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
 140:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 144:	00000100 	andeq	r0, r0, r0, lsl #2
 148:	6975623c 	ldmdbvs	r5!, {r2, r3, r4, r5, r9, sp, lr}^
 14c:	692d746c 	pushvs	{r2, r3, r5, r6, sl, ip, sp, lr}
 150:	00003e6e 	andeq	r3, r0, lr, ror #28
 154:	05000000 	streq	r0, [r0, #-0]
 158:	02050002 	andeq	r0, r5, #2
 15c:	000080a4 	andeq	r8, r0, r4, lsr #1
 160:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
 164:	0a05830b 	beq	160d98 <__bss_end+0x15744c>
 168:	8302054a 	movwhi	r0, #9546	; 0x254a
 16c:	830e0585 	movwhi	r0, #58757	; 0xe585
 170:	85670205 	strbhi	r0, [r7, #-517]!	; 0xfffffdfb
 174:	86010584 	strhi	r0, [r1], -r4, lsl #11
 178:	854c854c 	strbhi	r8, [ip, #-1356]	; 0xfffffab4
 17c:	0205854c 	andeq	r8, r5, #76, 10	; 0x13000000
 180:	01040200 	mrseq	r0, R12_usr
 184:	0301054b 	movweq	r0, #5451	; 0x154b
 188:	0d052e12 	stceq	14, cr2, [r5, #-72]	; 0xffffffb8
 18c:	0024056b 	eoreq	r0, r4, fp, ror #10
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7854>
 194:	02000405 	andeq	r0, r0, #83886080	; 0x5000000
 198:	05830204 	streq	r0, [r3, #516]	; 0x204
 19c:	0402000b 	streq	r0, [r2], #-11
 1a0:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 1a4:	02040200 	andeq	r0, r4, #0, 4
 1a8:	8509052d 	strhi	r0, [r9, #-1325]	; 0xfffffad3
 1ac:	a12f0105 			; <UNDEFINED> instruction: 0xa12f0105
 1b0:	056a0d05 	strbeq	r0, [sl, #-3333]!	; 0xfffff2fb
 1b4:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 1b8:	04054a03 	streq	r4, [r5], #-2563	; 0xfffff5fd
 1bc:	02040200 	andeq	r0, r4, #0, 4
 1c0:	000b0583 	andeq	r0, fp, r3, lsl #11
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x77888>
 1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1d0:	01058509 	tsteq	r5, r9, lsl #10
 1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
 1d8:	01a40101 			; <UNDEFINED> instruction: 0x01a40101
 1dc:	00030000 	andeq	r0, r3, r0
 1e0:	0000017a 	andeq	r0, r0, sl, ror r1
 1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 1e8:	0101000d 	tsteq	r1, sp
 1ec:	00000101 	andeq	r0, r0, r1, lsl #2
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	6f682f01 	svcvs	0x00682f01
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfe68>
 1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 200:	2f697261 	svccs	0x00697261
 204:	2f746967 	svccs	0x00746967
 208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 20c:	6f732f70 	svcvs	0x00732f70
 210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 214:	73752f73 	cmnvc	r5, #460	; 0x1cc
 218:	70737265 	rsbsvc	r7, r3, r5, ror #4
 21c:	2f656361 	svccs	0x00656361
 220:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 224:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 228:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 22c:	2f656d6f 	svccs	0x00656d6f
 230:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 234:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 238:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 23c:	2f736f2f 	svccs	0x00736f2f
 240:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 244:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff659f>
 24c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 250:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 254:	2f2e2e2f 	svccs	0x002e2e2f
 258:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 25c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 260:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 264:	702f6564 	eorvc	r6, pc, r4, ror #10
 268:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 26c:	2f007373 	svccs	0x00007373
 270:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 274:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 278:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 27c:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 280:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 284:	2f70732f 	svccs	0x0070732f
 288:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 28c:	2f736563 	svccs	0x00736563
 290:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 294:	63617073 	cmnvs	r1, #115	; 0x73
 298:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 29c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2a0:	2f6c656e 	svccs	0x006c656e
 2a4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2a8:	2f656475 	svccs	0x00656475
 2ac:	2f007366 	svccs	0x00007366
 2b0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2b4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 2b8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 2bc:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 2c0:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 2c4:	2f70732f 	svccs	0x0070732f
 2c8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2cc:	2f736563 	svccs	0x00736563
 2d0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d4:	63617073 	cmnvs	r1, #115	; 0x73
 2d8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2dc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2e0:	2f6c656e 	svccs	0x006c656e
 2e4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2e8:	2f656475 	svccs	0x00656475
 2ec:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2f0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2f4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2f8:	00006c61 	andeq	r6, r0, r1, ror #24
 2fc:	6e69616d 	powvsez	f6, f1, #5.0
 300:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 304:	00000100 	andeq	r0, r0, r0, lsl #2
 308:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 30c:	00020068 	andeq	r0, r2, r8, rrx
 310:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 314:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 318:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 31c:	66000002 	strvs	r0, [r0], -r2
 320:	73656c69 	cmnvc	r5, #26880	; 0x6900
 324:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 328:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 32c:	70000003 	andvc	r0, r0, r3
 330:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 334:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 338:	00000200 	andeq	r0, r0, r0, lsl #4
 33c:	636f7270 	cmnvs	pc, #112, 4
 340:	5f737365 	svcpl	0x00737365
 344:	616e616d 	cmnvs	lr, sp, ror #2
 348:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 34c:	00020068 	andeq	r0, r2, r8, rrx
 350:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 354:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 358:	00040068 	andeq	r0, r4, r8, rrx
 35c:	01050000 	mrseq	r0, (UNDEF: 5)
 360:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
 364:	17000082 	strne	r0, [r0, -r2, lsl #1]
 368:	05a31305 	streq	r1, [r3, #773]!	; 0x305
 36c:	2205511f 	andcs	r5, r5, #-1073741817	; 0xc0000007
 370:	8203054a 	andhi	r0, r3, #310378496	; 0x12800000
 374:	054b1705 	strbeq	r1, [fp, #-1797]	; 0xfffff8fb
 378:	0305310e 	movweq	r3, #20750	; 0x510e
 37c:	0002022a 	andeq	r0, r2, sl, lsr #4
 380:	02bf0101 	adcseq	r0, pc, #1073741824	; 0x40000000
 384:	00030000 	andeq	r0, r3, r0
 388:	0000018c 	andeq	r0, r0, ip, lsl #3
 38c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 390:	0101000d 	tsteq	r1, sp
 394:	00000101 	andeq	r0, r0, r1, lsl #2
 398:	00000100 	andeq	r0, r0, r0, lsl #2
 39c:	6f682f01 	svcvs	0x00682f01
 3a0:	6a2f656d 	bvs	bd995c <__bss_end+0xbd0010>
 3a4:	73656d61 	cmnvc	r5, #6208	; 0x1840
 3a8:	2f697261 	svccs	0x00697261
 3ac:	2f746967 	svccs	0x00746967
 3b0:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 3b4:	6f732f70 	svcvs	0x00732f70
 3b8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 3bc:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 3c0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 3c4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 3c8:	6f682f00 	svcvs	0x00682f00
 3cc:	6a2f656d 	bvs	bd9988 <__bss_end+0xbd003c>
 3d0:	73656d61 	cmnvc	r5, #6208	; 0x1840
 3d4:	2f697261 	svccs	0x00697261
 3d8:	2f746967 	svccs	0x00746967
 3dc:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 3e0:	6f732f70 	svcvs	0x00732f70
 3e4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 3e8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 3ec:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 3f0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 3f4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 3f8:	6f72702f 	svcvs	0x0072702f
 3fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 400:	6f682f00 	svcvs	0x00682f00
 404:	6a2f656d 	bvs	bd99c0 <__bss_end+0xbd0074>
 408:	73656d61 	cmnvc	r5, #6208	; 0x1840
 40c:	2f697261 	svccs	0x00697261
 410:	2f746967 	svccs	0x00746967
 414:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 418:	6f732f70 	svcvs	0x00732f70
 41c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 420:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 424:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 428:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 42c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 430:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 434:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 380 <shift+0x380>
 438:	616a2f65 	cmnvs	sl, r5, ror #30
 43c:	6173656d 	cmnvs	r3, sp, ror #10
 440:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 444:	6f2f7469 	svcvs	0x002f7469
 448:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 44c:	756f732f 	strbvc	r7, [pc, #-815]!	; 125 <shift+0x125>
 450:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 454:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 458:	2f62696c 	svccs	0x0062696c
 45c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 460:	00656475 	rsbeq	r6, r5, r5, ror r4
 464:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3b0 <shift+0x3b0>
 468:	616a2f65 	cmnvs	sl, r5, ror #30
 46c:	6173656d 	cmnvs	r3, sp, ror #10
 470:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 474:	6f2f7469 	svcvs	0x002f7469
 478:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 47c:	756f732f 	strbvc	r7, [pc, #-815]!	; 155 <shift+0x155>
 480:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 484:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 488:	2f6c656e 	svccs	0x006c656e
 48c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 490:	2f656475 	svccs	0x00656475
 494:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 498:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 49c:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 4a0:	00006c61 	andeq	r6, r0, r1, ror #24
 4a4:	66647473 			; <UNDEFINED> instruction: 0x66647473
 4a8:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 4ac:	00707063 	rsbseq	r7, r0, r3, rrx
 4b0:	73000001 	movwvc	r0, #1
 4b4:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 4b8:	00000200 	andeq	r0, r0, r0, lsl #4
 4bc:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 4c0:	6b636f6c 	blvs	18dc278 <__bss_end+0x18d292c>
 4c4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 4c8:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 4cc:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 4d0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 4d4:	0300682e 	movweq	r6, #2094	; 0x82e
 4d8:	72700000 	rsbsvc	r0, r0, #0
 4dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 4e0:	00682e73 	rsbeq	r2, r8, r3, ror lr
 4e4:	70000002 	andvc	r0, r0, r2
 4e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4ec:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 328 <shift+0x328>
 4f0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 4f4:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 4f8:	00000200 	andeq	r0, r0, r0, lsl #4
 4fc:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 500:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 504:	00682e67 	rsbeq	r2, r8, r7, ror #28
 508:	69000004 	stmdbvs	r0, {r2}
 50c:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 510:	00682e66 	rsbeq	r2, r8, r6, ror #28
 514:	00000005 	andeq	r0, r0, r5
 518:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 51c:	00827402 	addeq	r7, r2, r2, lsl #8
 520:	1a051600 	bne	145d28 <__bss_end+0x13c3dc>
 524:	2f2c0569 	svccs	0x002c0569
 528:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 52c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 530:	1a058332 	bne	161200 <__bss_end+0x1578b4>
 534:	2f01054b 	svccs	0x0001054b
 538:	4b1a0585 	blmi	681b54 <__bss_end+0x678208>
 53c:	852f0105 	strhi	r0, [pc, #-261]!	; 43f <shift+0x43f>
 540:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 544:	1b054b2e 	blne	153204 <__bss_end+0x1498b8>
 548:	2f2d054b 	svccs	0x002d054b
 54c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 550:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 554:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 558:	4b2e054b 	blmi	b81a8c <__bss_end+0xb78140>
 55c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 560:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 564:	2f01054c 	svccs	0x0001054c
 568:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 56c:	054b3005 	strbeq	r3, [fp, #-5]
 570:	1b054b2e 	blne	153230 <__bss_end+0x1498e4>
 574:	2f2e054b 	svccs	0x002e054b
 578:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 57c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 580:	1b05832e 	blne	161240 <__bss_end+0x1578f4>
 584:	2f01054b 	svccs	0x0001054b
 588:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 58c:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 590:	1b054b2f 	blne	153254 <__bss_end+0x149908>
 594:	2f30054b 	svccs	0x0030054b
 598:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 59c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5a0:	2f05a12e 	svccs	0x0005a12e
 5a4:	4b1b054b 	blmi	6c1ad8 <__bss_end+0x6b818c>
 5a8:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff6ab <__bss_end+0xffff5d5f>
 5ac:	01054c0c 	tsteq	r5, ip, lsl #24
 5b0:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 5b4:	4b2f05bd 	blmi	bc1cb0 <__bss_end+0xbb8364>
 5b8:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 5bc:	30054b1b 	andcc	r4, r5, fp, lsl fp
 5c0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5c4:	852f0105 	strhi	r0, [pc, #-261]!	; 4c7 <shift+0x4c7>
 5c8:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 5cc:	1a054b3b 	bne	1532c0 <__bss_end+0x149974>
 5d0:	2f30054b 	svccs	0x0030054b
 5d4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5d8:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 5dc:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 5e0:	4b31054d 	blmi	c41b1c <__bss_end+0xc381d0>
 5e4:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5e8:	0105300c 	tsteq	r5, ip
 5ec:	2005852f 	andcs	r8, r5, pc, lsr #10
 5f0:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 5f4:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 5f8:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 5fc:	2f010530 	svccs	0x00010530
 600:	83200585 			; <UNDEFINED> instruction: 0x83200585
 604:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 608:	1a054b3e 	bne	153308 <__bss_end+0x1499bc>
 60c:	2f01054b 	svccs	0x0001054b
 610:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 614:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 618:	1a054b30 	bne	1532e0 <__bss_end+0x149994>
 61c:	300c054b 	andcc	r0, ip, fp, asr #10
 620:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 624:	9fa00c05 	svcls	0x00a00c05
 628:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 62c:	36056629 	strcc	r6, [r5], -r9, lsr #12
 630:	300f052e 	andcc	r0, pc, lr, lsr #10
 634:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 638:	10058409 	andne	r8, r5, r9, lsl #8
 63c:	9f0105d8 	svcls	0x000105d8
 640:	01000802 	tsteq	r0, r2, lsl #16
 644:	00063e01 	andeq	r3, r6, r1, lsl #28
 648:	8f000300 	svchi	0x00000300
 64c:	02000000 	andeq	r0, r0, #0
 650:	0d0efb01 	vstreq	d15, [lr, #-4]
 654:	01010100 	mrseq	r0, (UNDEF: 17)
 658:	00000001 	andeq	r0, r0, r1
 65c:	01000001 	tsteq	r0, r1
 660:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 5ac <shift+0x5ac>
 664:	616a2f65 	cmnvs	sl, r5, ror #30
 668:	6173656d 	cmnvs	r3, sp, ror #10
 66c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 670:	6f2f7469 	svcvs	0x002f7469
 674:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 678:	756f732f 	strbvc	r7, [pc, #-815]!	; 351 <shift+0x351>
 67c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 680:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 684:	2f62696c 	svccs	0x0062696c
 688:	00637273 	rsbeq	r7, r3, r3, ror r2
 68c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 5d8 <shift+0x5d8>
 690:	616a2f65 	cmnvs	sl, r5, ror #30
 694:	6173656d 	cmnvs	r3, sp, ror #10
 698:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 69c:	6f2f7469 	svcvs	0x002f7469
 6a0:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 6a4:	756f732f 	strbvc	r7, [pc, #-815]!	; 37d <shift+0x37d>
 6a8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 6ac:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 6b0:	2f62696c 	svccs	0x0062696c
 6b4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 6b8:	00656475 	rsbeq	r6, r5, r5, ror r4
 6bc:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 6c0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 6c4:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 6c8:	01007070 	tsteq	r0, r0, ror r0
 6cc:	74730000 	ldrbtvc	r0, [r3], #-0
 6d0:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 6d4:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 6d8:	00020068 	andeq	r0, r2, r8, rrx
 6dc:	01050000 	mrseq	r0, (UNDEF: 5)
 6e0:	d0020500 	andle	r0, r2, r0, lsl #10
 6e4:	1a000086 	bne	904 <shift+0x904>
 6e8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 6ec:	21054c0f 	tstcs	r5, pc, lsl #24
 6f0:	ba0a0568 	blt	281c98 <__bss_end+0x27834c>
 6f4:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 6f8:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
 6fc:	2f09054a 	svccs	0x0009054a
 700:	059f0405 	ldreq	r0, [pc, #1029]	; b0d <shift+0xb0d>
 704:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 708:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
 70c:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 710:	13054a22 	movwne	r4, #23074	; 0x5a22
 714:	2f0a052e 	svccs	0x000a052e
 718:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
 71c:	0c052e0a 	stceq	14, cr2, [r5], {10}
 720:	4b03054a 	blmi	c1c50 <__bss_end+0xb8304>
 724:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 728:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 72c:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 730:	03040200 	movweq	r0, #16896	; 0x4200
 734:	0015059e 	mulseq	r5, lr, r5
 738:	68020402 	stmdavs	r2, {r1, sl}
 73c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 740:	05820204 	streq	r0, [r2, #516]	; 0x204
 744:	04020008 	streq	r0, [r2], #-8
 748:	1a054a02 	bne	152f58 <__bss_end+0x14960c>
 74c:	02040200 	andeq	r0, r4, #0, 4
 750:	001b054b 	andseq	r0, fp, fp, asr #10
 754:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 758:	02000c05 	andeq	r0, r0, #1280	; 0x500
 75c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 760:	0402000f 	streq	r0, [r2], #-15
 764:	1b058202 	blne	160f74 <__bss_end+0x157628>
 768:	02040200 	andeq	r0, r4, #0, 4
 76c:	0011054a 	andseq	r0, r1, sl, asr #10
 770:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 774:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 778:	052f0204 	streq	r0, [pc, #-516]!	; 57c <shift+0x57c>
 77c:	0402000b 	streq	r0, [r2], #-11
 780:	0d052e02 	stceq	14, cr2, [r5, #-8]
 784:	02040200 	andeq	r0, r4, #0, 4
 788:	0002054a 	andeq	r0, r2, sl, asr #10
 78c:	46020402 	strmi	r0, [r2], -r2, lsl #8
 790:	85880105 	strhi	r0, [r8, #261]	; 0x105
 794:	05830605 	streq	r0, [r3, #1541]	; 0x605
 798:	10054c09 	andne	r4, r5, r9, lsl #24
 79c:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 7a0:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 7a4:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 7a8:	01040200 	mrseq	r0, R12_usr
 7ac:	0014054a 	andseq	r0, r4, sl, asr #10
 7b0:	4a010402 	bmi	417c0 <__bss_end+0x37e74>
 7b4:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 7b8:	0a054a14 	beq	153010 <__bss_end+0x1496c4>
 7bc:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 7c0:	78030205 	stmdavc	r3, {r0, r2, r9}
 7c4:	03090566 	movweq	r0, #38246	; 0x9566
 7c8:	01052e0b 	tsteq	r5, fp, lsl #28
 7cc:	0905852f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 7d0:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
 7d4:	4a040402 	bmi	1017e4 <__bss_end+0xf7e98>
 7d8:	02001d05 	andeq	r1, r0, #320	; 0x140
 7dc:	05820204 	streq	r0, [r2, #516]	; 0x204
 7e0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 7e4:	16052e02 	strne	r2, [r5], -r2, lsl #28
 7e8:	02040200 	andeq	r0, r4, #0, 4
 7ec:	00110566 	andseq	r0, r1, r6, ror #10
 7f0:	4b030402 	blmi	c1800 <__bss_end+0xb7eb4>
 7f4:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 7f8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 7fc:	04020008 	streq	r0, [r2], #-8
 800:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
 804:	03040200 	movweq	r0, #16896	; 0x4200
 808:	0012052e 	andseq	r0, r2, lr, lsr #10
 80c:	4a030402 	bmi	c181c <__bss_end+0xb7ed0>
 810:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 814:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 818:	04020002 	streq	r0, [r2], #-2
 81c:	0b052d03 	bleq	14bc30 <__bss_end+0x1422e4>
 820:	02040200 	andeq	r0, r4, #0, 4
 824:	00080584 	andeq	r0, r8, r4, lsl #11
 828:	83010402 	movwhi	r0, #5122	; 0x1402
 82c:	02000905 	andeq	r0, r0, #81920	; 0x14000
 830:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 834:	0402000b 	streq	r0, [r2], #-11
 838:	02054a01 	andeq	r4, r5, #4096	; 0x1000
 83c:	01040200 	mrseq	r0, R12_usr
 840:	850b0549 	strhi	r0, [fp, #-1353]	; 0xfffffab7
 844:	852f0105 	strhi	r0, [pc, #-261]!	; 747 <shift+0x747>
 848:	05bc0e05 	ldreq	r0, [ip, #3589]!	; 0xe05
 84c:	20056611 	andcs	r6, r5, r1, lsl r6
 850:	660b05bc 			; <UNDEFINED> instruction: 0x660b05bc
 854:	054b1f05 	strbeq	r1, [fp, #-3845]	; 0xfffff0fb
 858:	0805660a 	stmdaeq	r5, {r1, r3, r9, sl, sp, lr}
 85c:	8311054b 	tsthi	r1, #314572800	; 0x12c00000
 860:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
 864:	11056708 	tstne	r5, r8, lsl #14
 868:	4d0b0567 	cfstr32mi	mvfx0, [fp, #-412]	; 0xfffffe64
 86c:	852f0105 	strhi	r0, [pc, #-261]!	; 76f <shift+0x76f>
 870:	05830605 	streq	r0, [r3, #1541]	; 0x605
 874:	0c054c0b 	stceq	12, cr4, [r5], {11}
 878:	660e052e 	strvs	r0, [lr], -lr, lsr #10
 87c:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
 880:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
 884:	2f010531 	svccs	0x00010531
 888:	9f080585 	svcls	0x00080585
 88c:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 890:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 894:	07054a03 	streq	r4, [r5, -r3, lsl #20]
 898:	02040200 	andeq	r0, r4, #0, 4
 89c:	00080583 	andeq	r0, r8, r3, lsl #11
 8a0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8a4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 8a8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8ac:	04020002 	streq	r0, [r2], #-2
 8b0:	01054902 	tsteq	r5, r2, lsl #18
 8b4:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
 8b8:	4b0805bb 	blmi	201fac <__bss_end+0x1f8660>
 8bc:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 8c0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 8c4:	16054a03 	strne	r4, [r5], -r3, lsl #20
 8c8:	02040200 	andeq	r0, r4, #0, 4
 8cc:	00170583 	andseq	r0, r7, r3, lsl #11
 8d0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8d4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 8d8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8dc:	0402000b 	streq	r0, [r2], #-11
 8e0:	17052e02 	strne	r2, [r5, -r2, lsl #28]
 8e4:	02040200 	andeq	r0, r4, #0, 4
 8e8:	000d054a 	andeq	r0, sp, sl, asr #10
 8ec:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8f0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8f4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 8f8:	05858401 	streq	r8, [r5, #1025]	; 0x401
 8fc:	16059f0b 	strne	r9, [r5], -fp, lsl #30
 900:	001c054b 	andseq	r0, ip, fp, asr #10
 904:	4a030402 	bmi	c1914 <__bss_end+0xb7fc8>
 908:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 90c:	05830204 	streq	r0, [r3, #516]	; 0x204
 910:	04020005 	streq	r0, [r2], #-5
 914:	0c058102 	stfeqd	f0, [r5], {2}
 918:	4b010585 	blmi	41f34 <__bss_end+0x385e8>
 91c:	84110585 	ldrhi	r0, [r1], #-1413	; 0xfffffa7b
 920:	05680c05 	strbeq	r0, [r8, #-3077]!	; 0xfffff3fb
 924:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 928:	13054a03 	movwne	r4, #23043	; 0x5a03
 92c:	03040200 	movweq	r0, #16896	; 0x4200
 930:	0015059e 	mulseq	r5, lr, r5
 934:	68020402 	stmdavs	r2, {r1, sl}
 938:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 93c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 940:	0402000e 	streq	r0, [r2], #-14
 944:	1c056602 	stcne	6, cr6, [r5], {2}
 948:	02040200 	andeq	r0, r4, #0, 4
 94c:	0023052f 	eoreq	r0, r3, pc, lsr #10
 950:	66020402 	strvs	r0, [r2], -r2, lsl #8
 954:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 958:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 95c:	0402000f 	streq	r0, [r2], #-15
 960:	23052e02 	movwcs	r2, #24066	; 0x5e02
 964:	02040200 	andeq	r0, r4, #0, 4
 968:	0011054a 	andseq	r0, r1, sl, asr #10
 96c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 970:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 974:	052f0204 	streq	r0, [pc, #-516]!	; 778 <shift+0x778>
 978:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 97c:	1b056602 	blne	15a18c <__bss_end+0x150840>
 980:	02040200 	andeq	r0, r4, #0, 4
 984:	00050566 	andeq	r0, r5, r6, ror #10
 988:	62020402 	andvs	r0, r2, #33554432	; 0x2000000
 98c:	69880105 	stmibvs	r8, {r0, r2, r8}
 990:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 994:	1a059f09 	bne	1685c0 <__bss_end+0x15ec74>
 998:	01040200 	mrseq	r0, R12_usr
 99c:	002e059e 	mlaeq	lr, lr, r5, r0
 9a0:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 9a4:	059f0905 	ldreq	r0, [pc, #2309]	; 12b1 <shift+0x12b1>
 9a8:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 9ac:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 9b0:	01040200 	mrseq	r0, R12_usr
 9b4:	9f090582 	svcls	0x00090582
 9b8:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 9bc:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 9c0:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 9c4:	09058201 	stmdbeq	r5, {r0, r9, pc}
 9c8:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 9cc:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 9d0:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 9d4:	05820104 	streq	r0, [r2, #260]	; 0x104
 9d8:	1a059f09 	bne	168604 <__bss_end+0x15ecb8>
 9dc:	01040200 	mrseq	r0, R12_usr
 9e0:	002e059e 	mlaeq	lr, lr, r5, r0
 9e4:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 9e8:	059f0905 	ldreq	r0, [pc, #2309]	; 12f5 <shift+0x12f5>
 9ec:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 9f0:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 9f4:	01040200 	mrseq	r0, R12_usr
 9f8:	a0050582 	andge	r0, r5, r2, lsl #11
 9fc:	02000f05 	andeq	r0, r0, #5, 30
 a00:	05820104 	streq	r0, [r2, #260]	; 0x104
 a04:	1a059f09 	bne	168630 <__bss_end+0x15ece4>
 a08:	01040200 	mrseq	r0, R12_usr
 a0c:	002e059e 	mlaeq	lr, lr, r5, r0
 a10:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 a14:	059f0905 	ldreq	r0, [pc, #2309]	; 1321 <shift+0x1321>
 a18:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 a1c:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 a20:	01040200 	mrseq	r0, R12_usr
 a24:	9f090582 	svcls	0x00090582
 a28:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 a2c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 a30:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 a34:	09058201 	stmdbeq	r5, {r0, r9, pc}
 a38:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 a3c:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 a40:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 a44:	05820104 	streq	r0, [r2, #260]	; 0x104
 a48:	1a059f09 	bne	168674 <__bss_end+0x15ed28>
 a4c:	01040200 	mrseq	r0, R12_usr
 a50:	002e059e 	mlaeq	lr, lr, r5, r0
 a54:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 a58:	059f0905 	ldreq	r0, [pc, #2309]	; 1365 <shift+0x1365>
 a5c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 a60:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 a64:	01040200 	mrseq	r0, R12_usr
 a68:	a0100582 	andsge	r0, r0, r2, lsl #11
 a6c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 a70:	19054b1a 	stmdbne	r5, {r1, r3, r4, r8, r9, fp, lr}
 a74:	820b054a 	andhi	r0, fp, #310378496	; 0x12800000
 a78:	05670f05 	strbeq	r0, [r7, #-3845]!	; 0xfffff0fb
 a7c:	1905660d 	stmdbne	r5, {r0, r2, r3, r9, sl, sp, lr}
 a80:	4a12054b 	bmi	481fb4 <__bss_end+0x478668>
 a84:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
 a88:	01054a05 	tsteq	r5, r5, lsl #20
 a8c:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 a90:	2e760309 	cdpcs	3, 7, cr0, cr6, cr9, {0}
 a94:	054a1005 	strbeq	r1, [sl, #-5]
 a98:	0905670c 	stmdbeq	r5, {r2, r3, r8, r9, sl, sp, lr}
 a9c:	6715054a 	ldrvs	r0, [r5, -sl, asr #10]
 aa0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 aa4:	10054a15 	andne	r4, r5, r5, lsl sl
 aa8:	4a0d0567 	bmi	34204c <__bss_end+0x338700>
 aac:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 ab0:	19056711 	stmdbne	r5, {r0, r4, r8, r9, sl, sp, lr}
 ab4:	6a01054a 	bvs	41fe4 <__bss_end+0x38698>
 ab8:	05152e02 	ldreq	r2, [r5, #-3586]	; 0xfffff1fe
 abc:	1205bb06 	andne	fp, r5, #6144	; 0x1800
 ac0:	6615054b 	ldrvs	r0, [r5], -fp, asr #10
 ac4:	05bb2005 	ldreq	r2, [fp, #5]!
 ac8:	05200823 	streq	r0, [r0, #-2083]!	; 0xfffff7dd
 acc:	14052e12 	strne	r2, [r5], #-3602	; 0xfffff1ee
 ad0:	4a230582 	bmi	8c20e0 <__bss_end+0x8b8794>
 ad4:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
 ad8:	05052f0b 	streq	r2, [r5, #-3851]	; 0xfffff0f5
 adc:	3206059c 	andcc	r0, r6, #156, 10	; 0x27000000
 ae0:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 ae4:	08054a0d 	stmdaeq	r5, {r0, r2, r3, r9, fp, lr}
 ae8:	4b01054b 	blmi	4201c <__bss_end+0x386d0>
 aec:	830e0585 	movwhi	r0, #58757	; 0xe585
 af0:	85d70105 	ldrbhi	r0, [r7, #261]	; 0x105
 af4:	05830d05 	streq	r0, [r3, #3333]	; 0xd05
 af8:	05a2d701 	streq	sp, [r2, #1793]!	; 0x701
 afc:	01059f06 	tsteq	r5, r6, lsl #30
 b00:	0f056a83 	svceq	0x00056a83
 b04:	4b0505bb 	blmi	1421f8 <__bss_end+0x1388ac>
 b08:	05840c05 	streq	r0, [r4, #3077]	; 0xc05
 b0c:	1005660e 	andne	r6, r5, lr, lsl #12
 b10:	4b05054a 	blmi	142040 <__bss_end+0x1386f4>
 b14:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
 b18:	0c056605 	stceq	6, cr6, [r5], {5}
 b1c:	660e054c 	strvs	r0, [lr], -ip, asr #10
 b20:	054a1005 	strbeq	r1, [sl, #-5]
 b24:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 b28:	4a100566 	bmi	4020c8 <__bss_end+0x3f877c>
 b2c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 b30:	1005660e 	andne	r6, r5, lr, lsl #12
 b34:	4b0c054a 	blmi	302064 <__bss_end+0x2f8718>
 b38:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b3c:	03054a10 	movweq	r4, #23056	; 0x5a10
 b40:	300d054b 	andcc	r0, sp, fp, asr #10
 b44:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 b48:	0e054c0c 	cdpeq	12, 0, cr4, cr5, cr12, {0}
 b4c:	4a100566 	bmi	4020ec <__bss_end+0x3f87a0>
 b50:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 b54:	1005660e 	andne	r6, r5, lr, lsl #12
 b58:	4b0c054a 	blmi	302088 <__bss_end+0x2f873c>
 b5c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b60:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 b64:	660e054b 	strvs	r0, [lr], -fp, asr #10
 b68:	054a1005 	strbeq	r1, [sl, #-5]
 b6c:	06054b03 	streq	r4, [r5], -r3, lsl #22
 b70:	4b020530 	blmi	82038 <__bss_end+0x786ec>
 b74:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 b78:	0e054c1c 	mcreq	12, 0, r4, cr5, cr12, {0}
 b7c:	6607059f 			; <UNDEFINED> instruction: 0x6607059f
 b80:	05681805 	strbeq	r1, [r8, #-2053]!	; 0xfffff7fb
 b84:	33058334 	movwcc	r8, #21300	; 0x5334
 b88:	4a440566 	bmi	1102128 <__bss_end+0x10f87dc>
 b8c:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
 b90:	1d056906 	vstrne.16	s12, [r5, #-12]	; <UNPREDICTABLE>
 b94:	840b059f 	strhi	r0, [fp], #-1439	; 0xfffffa61
 b98:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 b9c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 ba0:	0402000c 	streq	r0, [r2], #-12
 ba4:	0e058402 	cdpeq	4, 0, cr8, cr5, cr2, {0}
 ba8:	02040200 	andeq	r0, r4, #0, 4
 bac:	001e0566 	andseq	r0, lr, r6, ror #10
 bb0:	4a020402 	bmi	81bc0 <__bss_end+0x78274>
 bb4:	02001005 	andeq	r1, r0, #5
 bb8:	05820204 	streq	r0, [r2, #516]	; 0x204
 bbc:	04020002 	streq	r0, [r2], #-2
 bc0:	05872c02 	streq	r2, [r7, #3074]	; 0xc02
 bc4:	0e05680c 	cdpeq	8, 0, cr6, cr5, cr12, {0}
 bc8:	4a100566 	bmi	402168 <__bss_end+0x3f881c>
 bcc:	054c1a05 	strbeq	r1, [ip, #-2565]	; 0xfffff5fb
 bd0:	1505a00c 	strne	sl, [r5, #-12]
 bd4:	01040200 	mrseq	r0, R12_usr
 bd8:	6819054a 	ldmdavs	r9, {r1, r3, r6, r8, sl}
 bdc:	05820405 	streq	r0, [r2, #1029]	; 0x405
 be0:	0402000d 	streq	r0, [r2], #-13
 be4:	0f054c02 	svceq	0x00054c02
 be8:	02040200 	andeq	r0, r4, #0, 4
 bec:	00240566 	eoreq	r0, r4, r6, ror #10
 bf0:	4a020402 	bmi	81c00 <__bss_end+0x782b4>
 bf4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 bf8:	05820204 	streq	r0, [r2, #516]	; 0x204
 bfc:	04020003 	streq	r0, [r2], #-3
 c00:	05052a02 	streq	r2, [r5, #-2562]	; 0xfffff5fe
 c04:	000b0585 	andeq	r0, fp, r5, lsl #11
 c08:	32020402 	andcc	r0, r2, #33554432	; 0x2000000
 c0c:	02000d05 	andeq	r0, r0, #320	; 0x140
 c10:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 c14:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 c18:	12058309 	andne	r8, r5, #603979776	; 0x24000000
 c1c:	4b07054a 	blmi	1c214c <__bss_end+0x1b8800>
 c20:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 c24:	0a054b06 	beq	153844 <__bss_end+0x149ef8>
 c28:	4c0c0567 	cfstr32mi	mvfx0, [ip], {103}	; 0x67
 c2c:	02001c05 	andeq	r1, r0, #1280	; 0x500
 c30:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 c34:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 c38:	09054a01 	stmdbeq	r5, {r0, r9, fp, lr}
 c3c:	4a05054b 	bmi	142170 <__bss_end+0x138824>
 c40:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 c44:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
 c48:	04020007 	streq	r0, [r2], #-7
 c4c:	0d054b01 	vstreq	d4, [r5, #-4]
 c50:	4a090530 	bmi	242118 <__bss_end+0x2387cc>
 c54:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 c58:	04020010 	streq	r0, [r2], #-16
 c5c:	07056601 	streq	r6, [r5, -r1, lsl #12]
 c60:	001c0567 	andseq	r0, ip, r7, ror #10
 c64:	66010402 	strvs	r0, [r1], -r2, lsl #8
 c68:	05831105 	streq	r1, [r3, #261]	; 0x105
 c6c:	0b05661b 	bleq	15a4e0 <__bss_end+0x150b94>
 c70:	00030566 	andeq	r0, r3, r6, ror #10
 c74:	03020402 	movweq	r0, #9218	; 0x2402
 c78:	10054a78 	andne	r4, r5, r8, ror sl
 c7c:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 c80:	0c026701 	stceq	7, cr6, [r2], {1}
 c84:	79010100 	stmdbvc	r1, {r8}
 c88:	03000000 	movweq	r0, #0
 c8c:	00004600 	andeq	r4, r0, r0, lsl #12
 c90:	fb010200 	blx	4149a <__bss_end+0x37b4e>
 c94:	01000d0e 	tsteq	r0, lr, lsl #26
 c98:	00010101 	andeq	r0, r1, r1, lsl #2
 c9c:	00010000 	andeq	r0, r1, r0
 ca0:	2e2e0100 	sufcse	f0, f6, f0
 ca4:	2f2e2e2f 	svccs	0x002e2e2f
 ca8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 cac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 cb0:	2f2e2e2f 	svccs	0x002e2e2f
 cb4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 cb8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 cbc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 cc0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 cc4:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 cc8:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 ccc:	73636e75 	cmnvc	r3, #1872	; 0x750
 cd0:	0100532e 	tsteq	r0, lr, lsr #6
 cd4:	00000000 	andeq	r0, r0, r0
 cd8:	96ac0205 	strtls	r0, [ip], r5, lsl #4
 cdc:	ca030000 	bgt	c0ce4 <__bss_end+0xb7398>
 ce0:	2f300108 	svccs	0x00300108
 ce4:	2f2f2f2f 	svccs	0x002f2f2f
 ce8:	01d00230 	bicseq	r0, r0, r0, lsr r2
 cec:	2f312f14 	svccs	0x00312f14
 cf0:	2f4c302f 	svccs	0x004c302f
 cf4:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 cf8:	2f2f2f2f 	svccs	0x002f2f2f
 cfc:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 d00:	01010002 	tsteq	r1, r2
 d04:	0000005c 	andeq	r0, r0, ip, asr r0
 d08:	00460003 	subeq	r0, r6, r3
 d0c:	01020000 	mrseq	r0, (UNDEF: 2)
 d10:	000d0efb 	strdeq	r0, [sp], -fp
 d14:	01010101 	tsteq	r1, r1, lsl #2
 d18:	01000000 	mrseq	r0, (UNDEF: 0)
 d1c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 d20:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d24:	2f2e2e2f 	svccs	0x002e2e2f
 d28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d30:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 d34:	2f636367 	svccs	0x00636367
 d38:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 d3c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 d40:	00006d72 	andeq	r6, r0, r2, ror sp
 d44:	3162696c 	cmncc	r2, ip, ror #18
 d48:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 d4c:	00532e73 	subseq	r2, r3, r3, ror lr
 d50:	00000001 	andeq	r0, r0, r1
 d54:	b8020500 	stmdalt	r2, {r8, sl}
 d58:	03000098 	movweq	r0, #152	; 0x98
 d5c:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
 d60:	01010002 	tsteq	r1, r2
 d64:	00000103 	andeq	r0, r0, r3, lsl #2
 d68:	00fd0003 	rscseq	r0, sp, r3
 d6c:	01020000 	mrseq	r0, (UNDEF: 2)
 d70:	000d0efb 	strdeq	r0, [sp], -fp
 d74:	01010101 	tsteq	r1, r1, lsl #2
 d78:	01000000 	mrseq	r0, (UNDEF: 0)
 d7c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 d80:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d84:	2f2e2e2f 	svccs	0x002e2e2f
 d88:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d90:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 d94:	2f636367 	svccs	0x00636367
 d98:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
 d9c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 da0:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
 da4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 da8:	2f2e2e2f 	svccs	0x002e2e2f
 dac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 db0:	2f2e2f2e 	svccs	0x002e2f2e
 db4:	00636367 	rsbeq	r6, r3, r7, ror #6
 db8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dbc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dc0:	2f2e2e2f 	svccs	0x002e2e2f
 dc4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dc8:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 dcc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 dd0:	2f2e2e2f 	svccs	0x002e2e2f
 dd4:	2f636367 	svccs	0x00636367
 dd8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 ddc:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 de0:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 de4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 de8:	2f2e2e2f 	svccs	0x002e2e2f
 dec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 df0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 df4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 df8:	00636367 	rsbeq	r6, r3, r7, ror #6
 dfc:	73616800 	cmnvc	r1, #0, 16
 e00:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
 e04:	0100682e 	tsteq	r0, lr, lsr #16
 e08:	72610000 	rsbvc	r0, r1, #0
 e0c:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
 e10:	00682e61 	rsbeq	r2, r8, r1, ror #28
 e14:	61000002 	tstvs	r0, r2
 e18:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
 e1c:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
 e20:	00000200 	andeq	r0, r0, r0, lsl #4
 e24:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
 e28:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
 e2c:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
 e30:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 e34:	00000200 	andeq	r0, r0, r0, lsl #4
 e38:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 e3c:	00030068 	andeq	r0, r3, r8, rrx
 e40:	62696c00 	rsbvs	r6, r9, #0, 24
 e44:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 e48:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 e4c:	62670000 	rsbvs	r0, r7, #0
 e50:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 e54:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 e58:	00040068 	andeq	r0, r4, r8, rrx
 e5c:	62696c00 	rsbvs	r6, r9, #0, 24
 e60:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 e64:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
 e68:	Address 0x0000000000000e68 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	00000032 	andeq	r0, r0, r2, lsr r0
      20:	00000063 	andeq	r0, r0, r3, rrx
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00890104 	addeq	r0, r9, r4, lsl #2
      34:	500c0000 	andpl	r0, ip, r0
      38:	32000001 	andcc	r0, r0, #1
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	62000000 	andvs	r0, r0, #0
      48:	02000000 	andeq	r0, r0, #0
      4c:	00000144 	andeq	r0, r0, r4, asr #2
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	17df0704 	ldrbne	r0, [pc, r4, lsl #14]
      5c:	7f020000 	svcvc	0x00020000
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	82040000 	andhi	r0, r4, #0
      6c:	01000001 	tsteq	r0, r1
      70:	8064060f 	rsbhi	r0, r4, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00013d05 	andeq	r3, r1, r5, lsl #26
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	0000006f 	andeq	r0, r0, pc, rrx
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000a19c 	muleq	r0, ip, r1
      ac:	80140800 	andshi	r0, r4, r0, lsl #16
      b0:	00340000 	eorseq	r0, r4, r0
      b4:	63090000 	movwvs	r0, #36864	; 0x9000
      b8:	01007275 	tsteq	r0, r5, ror r2
      bc:	00a1180b 	adceq	r1, r1, fp, lsl #16
      c0:	91020000 	mrsls	r0, (UNDEF: 2)
      c4:	0a000074 	beq	29c <shift+0x29c>
      c8:	00003104 	andeq	r3, r0, r4, lsl #2
      cc:	02020000 	andeq	r0, r2, #0
      d0:	00040000 	andeq	r0, r4, r0
      d4:	000000b9 	strheq	r0, [r0], -r9
      d8:	021a0104 	andseq	r0, sl, #4, 2
      dc:	65040000 	strvs	r0, [r4, #-0]
      e0:	32000003 	andcc	r0, r0, #3
      e4:	a4000000 	strge	r0, [r0], #-0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	f3000001 	vhadd.u8	d0, d0, d1
      f0:	02000000 	andeq	r0, r0, #0
      f4:	0000033a 	andeq	r0, r0, sl, lsr r3
      f8:	31072f01 	tstcc	r7, r1, lsl #30
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	fc020400 	stc2	4, cr0, [r2], {-0}
     108:	01000002 	tsteq	r0, r2
     10c:	00310730 	eorseq	r0, r1, r0, lsr r7
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	000017df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
     12c:	00035708 	andeq	r5, r3, r8, lsl #14
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	0001f208 	andeq	pc, r1, r8, lsl #4
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	0000020c 	andeq	r0, r0, ip, lsl #4
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	00000305 	andeq	r0, r0, r5, lsl #6
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	000001ac 	andeq	r0, r0, ip, lsr #3
     174:	cb104801 	blgt	412180 <__bss_end+0x408834>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36848>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	2d090000 	stccs	0, cr0, [r9, #-0]
     1a8:	01000003 	tsteq	r0, r3
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	817c0000 	cmnhi	ip, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0001ba0a 	andeq	fp, r1, sl, lsl #20
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	950c0000 	strls	r0, [ip, #-0]
     1d8:	01000001 	tsteq	r0, r1
     1dc:	81701129 	cmnhi	r0, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	0001cb0c 	andeq	ip, r1, ip, lsl #22
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008158 	andeq	r8, r0, r8, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	120c9c01 	andne	r9, ip, #256	; 0x100
     1fc:	01000003 	tsteq	r0, r3
     200:	8140111f 	cmphi	r0, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	0001ff0c 	andeq	pc, r1, ip, lsl #30
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008128 	andeq	r8, r0, r8, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	c00d9c01 	andgt	r9, sp, r1, lsl #24
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	02ea0e00 	rsceq	r0, sl, #0, 28
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	0000018d 	andeq	r0, r0, sp, lsl #3
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	000001de 	ldrdeq	r0, [r0], -lr
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a50c>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x36918>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	00031f05 	andeq	r1, r3, r5, lsl #30
     278:	015b1100 	cmpeq	fp, r0, lsl #2
     27c:	81080000 	mrshi	r0, (UNDEF: 8)
     280:	00200000 	eoreq	r0, r0, r0
     284:	9c010000 	stcls	0, cr0, [r1], {-0}
     288:	000001c7 	andeq	r0, r0, r7, asr #3
     28c:	00019e12 	andeq	r9, r1, r2, lsl lr
     290:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     294:	01791100 	cmneq	r9, r0, lsl #2
     298:	80dc0000 	sbcshi	r0, ip, r0
     29c:	002c0000 	eoreq	r0, ip, r0
     2a0:	9c010000 	stcls	0, cr0, [r1], {-0}
     2a4:	000001e8 	andeq	r0, r0, r8, ror #3
     2a8:	01006713 	tsteq	r0, r3, lsl r7
     2ac:	019e300f 	orrseq	r3, lr, pc
     2b0:	91020000 	mrsls	r0, (UNDEF: 2)
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6b40>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000836 	andeq	r0, r0, r6, lsr r8
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0003b904 	andeq	fp, r3, r4, lsl #18
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000733 	andeq	r0, r0, r3, lsr r7
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	0000045b 	andeq	r0, r0, fp, asr r4
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	072a0801 	streq	r0, [sl, -r1, lsl #16]!
     318:	02020000 	andeq	r0, r2, #0
     31c:	00082f07 	andeq	r2, r8, r7, lsl #30
     320:	07730500 	ldrbeq	r0, [r3, -r0, lsl #10]!
     324:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     328:	00005e07 	andeq	r5, r0, r7, lsl #28
     32c:	004d0300 	subeq	r0, sp, r0, lsl #6
     330:	04020000 	streq	r0, [r2], #-0
     334:	0017df07 	andseq	sp, r7, r7, lsl #30
     338:	0a2b0600 	beq	ac1b40 <__bss_end+0xab81f4>
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	00000465 	andeq	r0, r0, r5, ror #8
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000c20c 	andeq	ip, r0, ip, lsl #4
     370:	04cc0900 	strbeq	r0, [ip], #2304	; 0x900
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00000b20 	andeq	r0, r0, r0, lsr #22
     37c:	03a80901 			; <UNDEFINED> instruction: 0x03a80901
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	00000694 	muleq	r0, r4, r6
     388:	0b110903 	bleq	44279c <__bss_end+0x438e50>
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	00000613 	andeq	r0, r0, r3, lsl r6
     394:	38080005 	stmdacc	r8, {r0, r2}
     398:	05000004 	streq	r0, [r0, #-4]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     3a8:	0007e409 	andeq	lr, r7, r9, lsl #8
     3ac:	6e090000 	cdpvs	0, 0, cr0, cr9, cr0, {0}
     3b0:	01000007 	tsteq	r0, r7
     3b4:	00075c09 	andeq	r5, r7, r9, lsl #24
     3b8:	d9090200 	stmdble	r9, {r9}
     3bc:	03000009 	movweq	r0, #9
     3c0:	00097b09 	andeq	r7, r9, r9, lsl #22
     3c4:	54090400 	strpl	r0, [r9], #-1024	; 0xfffffc00
     3c8:	0500000a 	streq	r0, [r0, #-10]
     3cc:	00072509 	andeq	r2, r7, r9, lsl #10
     3d0:	0a000600 	beq	1bd8 <shift+0x1bd8>
     3d4:	00000639 	andeq	r0, r0, r9, lsr r6
     3d8:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     3dc:	05000000 	streq	r0, [r0, #-0]
     3e0:	0098bc03 	addseq	fp, r8, r3, lsl #24
     3e4:	0a370a00 	beq	dc2bec <__bss_end+0xdb92a0>
     3e8:	06030000 	streq	r0, [r3], -r0
     3ec:	00005914 	andeq	r5, r0, r4, lsl r9
     3f0:	c0030500 	andgt	r0, r3, r0, lsl #10
     3f4:	0a000098 	beq	65c <shift+0x65c>
     3f8:	0000059d 	muleq	r0, sp, r5
     3fc:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     400:	05000000 	streq	r0, [r0, #-0]
     404:	0098c403 	addseq	ip, r8, r3, lsl #8
     408:	06550a00 	ldrbeq	r0, [r5], -r0, lsl #20
     40c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     410:	0000591a 	andeq	r5, r0, sl, lsl r9
     414:	c8030500 	stmdagt	r3, {r8, sl}
     418:	0a000098 	beq	680 <shift+0x680>
     41c:	000008ce 	andeq	r0, r0, lr, asr #17
     420:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     424:	05000000 	streq	r0, [r0, #-0]
     428:	0098cc03 	addseq	ip, r8, r3, lsl #24
     42c:	0a5b0a00 	beq	16c2c34 <__bss_end+0x16b92e8>
     430:	0d040000 	stceq	0, cr0, [r4, #-0]
     434:	0000591a 	andeq	r5, r0, sl, lsl r9
     438:	d0030500 	andle	r0, r3, r0, lsl #10
     43c:	0a000098 	beq	6a4 <shift+0x6a4>
     440:	00000857 	andeq	r0, r0, r7, asr r8
     444:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     448:	05000000 	streq	r0, [r0, #-0]
     44c:	0098d403 	addseq	sp, r8, r3, lsl #8
     450:	07970800 	ldreq	r0, [r7, r0, lsl #16]
     454:	04050000 	streq	r0, [r5], #-0
     458:	00000038 	andeq	r0, r0, r8, lsr r0
     45c:	a20c1b04 	andge	r1, ip, #4, 22	; 0x1000
     460:	09000001 	stmdbeq	r0, {r0}
     464:	00000869 	andeq	r0, r0, r9, ror #16
     468:	0ba80900 	bleq	fea02870 <__bss_end+0xfe9f8f24>
     46c:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     470:	00000757 	andeq	r0, r0, r7, asr r7
     474:	160b0002 	strne	r0, [fp], -r2
     478:	0c000008 	stceq	0, cr0, [r0], {8}
     47c:	00000671 	andeq	r0, r0, r1, ror r6
     480:	07630490 			; <UNDEFINED> instruction: 0x07630490
     484:	00000315 	andeq	r0, r0, r5, lsl r3
     488:	00064706 	andeq	r4, r6, r6, lsl #14
     48c:	67042400 	strvs	r2, [r4, -r0, lsl #8]
     490:	00022f10 	andeq	r2, r2, r0, lsl pc
     494:	1b4f0d00 	blne	13c389c <__bss_end+0x13b9f50>
     498:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
     49c:	00031512 	andeq	r1, r3, r2, lsl r5
     4a0:	870d0000 	strhi	r0, [sp, -r0]
     4a4:	04000005 	streq	r0, [r0], #-5
     4a8:	0325126b 			; <UNDEFINED> instruction: 0x0325126b
     4ac:	0d100000 	ldceq	0, cr0, [r0, #-0]
     4b0:	0000084c 	andeq	r0, r0, ip, asr #16
     4b4:	4d166d04 	ldcmi	13, cr6, [r6, #-16]
     4b8:	14000000 	strne	r0, [r0], #-0
     4bc:	0006320d 	andeq	r3, r6, sp, lsl #4
     4c0:	1c700400 	cfldrdne	mvd0, [r0], #-0
     4c4:	0000032c 	andeq	r0, r0, ip, lsr #6
     4c8:	067d0d18 			; <UNDEFINED> instruction: 0x067d0d18
     4cc:	72040000 	andvc	r0, r4, #0
     4d0:	00032c1c 	andeq	r2, r3, ip, lsl ip
     4d4:	b30d1c00 	movwlt	r1, #56320	; 0xdc00
     4d8:	0400000b 	streq	r0, [r0], #-11
     4dc:	032c1c75 			; <UNDEFINED> instruction: 0x032c1c75
     4e0:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     4e4:	000007bd 			; <UNDEFINED> instruction: 0x000007bd
     4e8:	6e1c7704 	cdpvs	7, 1, cr7, cr12, cr4, {0}
     4ec:	2c00000a 	stccs	0, cr0, [r0], {10}
     4f0:	23000003 	movwcs	r0, #3
     4f4:	0f000002 	svceq	0x00000002
     4f8:	0000032c 	andeq	r0, r0, ip, lsr #6
     4fc:	00033210 	andeq	r3, r3, r0, lsl r2
     500:	06000000 	streq	r0, [r0], -r0
     504:	00000738 	andeq	r0, r0, r8, lsr r7
     508:	107b0418 	rsbsne	r0, fp, r8, lsl r4
     50c:	00000264 	andeq	r0, r0, r4, ror #4
     510:	001b4f0d 	andseq	r4, fp, sp, lsl #30
     514:	127e0400 	rsbsne	r0, lr, #0, 8
     518:	00000315 	andeq	r0, r0, r5, lsl r3
     51c:	04500d00 	ldrbeq	r0, [r0], #-3328	; 0xfffff300
     520:	80040000 	andhi	r0, r4, r0
     524:	00033219 	andeq	r3, r3, r9, lsl r2
     528:	dd0d1000 	stcle	0, cr1, [sp, #-0]
     52c:	04000007 	streq	r0, [r0], #-7
     530:	033d2182 	teqeq	sp, #-2147483616	; 0x80000020
     534:	00140000 	andseq	r0, r4, r0
     538:	00022f03 	andeq	r2, r2, r3, lsl #30
     53c:	04d91100 	ldrbeq	r1, [r9], #256	; 0x100
     540:	86040000 	strhi	r0, [r4], -r0
     544:	00034321 	andeq	r4, r3, r1, lsr #6
     548:	04e51100 	strbteq	r1, [r5], #256	; 0x100
     54c:	88040000 	stmdahi	r4, {}	; <UNPREDICTABLE>
     550:	0000591f 	andeq	r5, r0, pc, lsl r9
     554:	09810d00 	stmibeq	r1, {r8, sl, fp}
     558:	8b040000 	blhi	100560 <__bss_end+0xf6c14>
     55c:	0001b417 	andeq	fp, r1, r7, lsl r4
     560:	f70d0000 			; <UNDEFINED> instruction: 0xf70d0000
     564:	04000003 	streq	r0, [r0], #-3
     568:	01b4178e 			; <UNDEFINED> instruction: 0x01b4178e
     56c:	0d240000 	stceq	0, cr0, [r4, #-0]
     570:	00000842 	andeq	r0, r0, r2, asr #16
     574:	b4178f04 	ldrlt	r8, [r7], #-3844	; 0xfffff0fc
     578:	48000001 	stmdami	r0, {r0}
     57c:	0007d30d 	andeq	sp, r7, sp, lsl #6
     580:	17900400 	ldrne	r0, [r0, r0, lsl #8]
     584:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
     588:	0671126c 	ldrbteq	r1, [r1], -ip, ror #4
     58c:	93040000 	movwls	r0, #16384	; 0x4000
     590:	000ab109 	andeq	fp, sl, r9, lsl #2
     594:	00034e00 	andeq	r4, r3, r0, lsl #28
     598:	02ce0100 	sbceq	r0, lr, #0, 2
     59c:	02d40000 	sbcseq	r0, r4, #0
     5a0:	4e0f0000 	cdpmi	0, 0, cr0, cr15, cr0, {0}
     5a4:	00000003 	andeq	r0, r0, r3
     5a8:	0004c113 	andeq	ip, r4, r3, lsl r1
     5ac:	0e960400 	cdpeq	4, 9, cr0, cr6, cr0, {0}
     5b0:	00000c14 	andeq	r0, r0, r4, lsl ip
     5b4:	0002e901 	andeq	lr, r2, r1, lsl #18
     5b8:	0002ef00 	andeq	lr, r2, r0, lsl #30
     5bc:	034e0f00 	movteq	r0, #61184	; 0xef00
     5c0:	14000000 	strne	r0, [r0], #-0
     5c4:	000007e4 	andeq	r0, r0, r4, ror #15
     5c8:	7c109904 			; <UNDEFINED> instruction: 0x7c109904
     5cc:	54000007 	strpl	r0, [r0], #-7
     5d0:	01000003 	tsteq	r0, r3
     5d4:	00000304 	andeq	r0, r0, r4, lsl #6
     5d8:	00034e0f 	andeq	r4, r3, pc, lsl #28
     5dc:	03321000 	teqeq	r2, #0
     5e0:	7d100000 	ldcvc	0, cr0, [r0, #-0]
     5e4:	00000001 	andeq	r0, r0, r1
     5e8:	00251500 	eoreq	r1, r5, r0, lsl #10
     5ec:	03250000 			; <UNDEFINED> instruction: 0x03250000
     5f0:	5e160000 	cdppl	0, 1, cr0, cr6, cr0, {0}
     5f4:	0f000000 	svceq	0x00000000
     5f8:	02010200 	andeq	r0, r1, #0, 4
     5fc:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
     600:	01b40417 			; <UNDEFINED> instruction: 0x01b40417
     604:	04170000 	ldreq	r0, [r7], #-0
     608:	0000002c 	andeq	r0, r0, ip, lsr #32
     60c:	000b2a0b 	andeq	r2, fp, fp, lsl #20
     610:	38041700 	stmdacc	r4, {r8, r9, sl, ip}
     614:	15000003 	strne	r0, [r0, #-3]
     618:	00000264 	andeq	r0, r0, r4, ror #4
     61c:	0000034e 	andeq	r0, r0, lr, asr #6
     620:	04170018 	ldreq	r0, [r7], #-24	; 0xffffffe8
     624:	000001a7 	andeq	r0, r0, r7, lsr #3
     628:	01a20417 			; <UNDEFINED> instruction: 0x01a20417
     62c:	b3190000 	tstlt	r9, #0
     630:	04000005 	streq	r0, [r0], #-5
     634:	01a7149c 			; <UNDEFINED> instruction: 0x01a7149c
     638:	a80a0000 	stmdage	sl, {}	; <UNPREDICTABLE>
     63c:	05000004 	streq	r0, [r0, #-4]
     640:	00591404 	subseq	r1, r9, r4, lsl #8
     644:	03050000 	movweq	r0, #20480	; 0x5000
     648:	000098d8 	ldrdeq	r9, [r0], -r8
     64c:	0003ae0a 	andeq	sl, r3, sl, lsl #28
     650:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     654:	00000059 	andeq	r0, r0, r9, asr r0
     658:	98dc0305 	ldmls	ip, {r0, r2, r8, r9}^
     65c:	9e0a0000 	cdpls	0, 0, cr0, cr10, cr0, {0}
     660:	0500000a 	streq	r0, [r0, #-10]
     664:	0059140a 	subseq	r1, r9, sl, lsl #8
     668:	03050000 	movweq	r0, #20480	; 0x5000
     66c:	000098e0 	andeq	r9, r0, r0, ror #17
     670:	00042c08 	andeq	r2, r4, r8, lsl #24
     674:	38040500 	stmdacc	r4, {r8, sl}
     678:	05000000 	streq	r0, [r0, #-0]
     67c:	03d30c0d 	bicseq	r0, r3, #3328	; 0xd00
     680:	4e1a0000 	cdpmi	0, 1, cr0, cr10, cr0, {0}
     684:	00007765 	andeq	r7, r0, r5, ror #14
     688:	0008c509 	andeq	ip, r8, r9, lsl #10
     68c:	09090100 	stmdbeq	r9, {r8}
     690:	0200000b 	andeq	r0, r0, #11
     694:	00086109 	andeq	r6, r8, r9, lsl #2
     698:	86090300 	strhi	r0, [r9], -r0, lsl #6
     69c:	04000006 	streq	r0, [r0], #-6
     6a0:	00071e09 	andeq	r1, r7, r9, lsl #28
     6a4:	06000500 	streq	r0, [r0], -r0, lsl #10
     6a8:	0000041f 	andeq	r0, r0, pc, lsl r4
     6ac:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
     6b0:	00000412 	andeq	r0, r0, r2, lsl r4
     6b4:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     6b8:	12131d05 	andsne	r1, r3, #320	; 0x140
     6bc:	00000004 	andeq	r0, r0, r4
     6c0:	00707307 	rsbseq	r7, r0, r7, lsl #6
     6c4:	12131e05 	andsne	r1, r3, #5, 28	; 0x50
     6c8:	04000004 	streq	r0, [r0], #-4
     6cc:	00637007 	rsbeq	r7, r3, r7
     6d0:	12131f05 	andsne	r1, r3, #5, 30
     6d4:	08000004 	stmdaeq	r0, {r2}
     6d8:	0007cd0d 	andeq	ip, r7, sp, lsl #26
     6dc:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     6e0:	00000412 	andeq	r0, r0, r2, lsl r4
     6e4:	0402000c 	streq	r0, [r2], #-12
     6e8:	0017da07 	andseq	sp, r7, r7, lsl #20
     6ec:	0c070600 	stceq	6, cr0, [r7], {-0}
     6f0:	05700000 	ldrbeq	r0, [r0, #-0]!
     6f4:	04a90828 	strteq	r0, [r9], #2088	; 0x828
     6f8:	f80d0000 			; <UNDEFINED> instruction: 0xf80d0000
     6fc:	05000005 	streq	r0, [r0, #-5]
     700:	03d3122a 	bicseq	r1, r3, #-1610612734	; 0xa0000002
     704:	07000000 	streq	r0, [r0, -r0]
     708:	00646970 	rsbeq	r6, r4, r0, ror r9
     70c:	5e122b05 	vnmlspl.f64	d2, d2, d5
     710:	10000000 	andne	r0, r0, r0
     714:	00152b0d 	andseq	r2, r5, sp, lsl #22
     718:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
     71c:	0000039c 	muleq	r0, ip, r3
     720:	0b8d0d14 	bleq	fe343b78 <__bss_end+0xfe33a22c>
     724:	2d050000 	stccs	0, cr0, [r5, #-0]
     728:	00005e12 	andeq	r5, r0, r2, lsl lr
     72c:	1c0d1800 	stcne	8, cr1, [sp], {-0}
     730:	05000006 	streq	r0, [r0, #-6]
     734:	005e122e 	subseq	r1, lr, lr, lsr #4
     738:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     73c:	0000039b 	muleq	r0, fp, r3
     740:	a90c2f05 	stmdbge	ip, {r0, r2, r8, r9, sl, fp, sp}
     744:	20000004 	andcs	r0, r0, r4
     748:	0006670d 	andeq	r6, r6, sp, lsl #14
     74c:	09300500 	ldmdbeq	r0!, {r8, sl}
     750:	00000038 	andeq	r0, r0, r8, lsr r0
     754:	04130d60 	ldreq	r0, [r3], #-3424	; 0xfffff2a0
     758:	31050000 	mrscc	r0, (UNDEF: 5)
     75c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     760:	0a0d6400 	beq	359768 <__bss_end+0x34fe1c>
     764:	05000004 	streq	r0, [r0, #-4]
     768:	004d0e33 	subeq	r0, sp, r3, lsr lr
     76c:	0d680000 	stcleq	0, cr0, [r8, #-0]
     770:	00000401 	andeq	r0, r0, r1, lsl #8
     774:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
     778:	6c000000 	stcvs	0, cr0, [r0], {-0}
     77c:	03541500 	cmpeq	r4, #0, 10
     780:	04b90000 	ldrteq	r0, [r9], #0
     784:	5e160000 	cdppl	0, 1, cr0, cr6, cr0, {0}
     788:	0f000000 	svceq	0x00000000
     78c:	056d0a00 	strbeq	r0, [sp, #-2560]!	; 0xfffff600
     790:	0a060000 	beq	180798 <__bss_end+0x176e4c>
     794:	00005914 	andeq	r5, r0, r4, lsl r9
     798:	e4030500 	str	r0, [r3], #-1280	; 0xfffffb00
     79c:	08000098 	stmdaeq	r0, {r3, r4, r7}
     7a0:	0000092c 	andeq	r0, r0, ip, lsr #18
     7a4:	00380405 	eorseq	r0, r8, r5, lsl #8
     7a8:	0d060000 	stceq	0, cr0, [r6, #-0]
     7ac:	0004ea0c 	andeq	lr, r4, ip, lsl #20
     7b0:	0b420900 	bleq	1082bb8 <__bss_end+0x107926c>
     7b4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     7b8:	0000057c 	andeq	r0, r0, ip, ror r5
     7bc:	7a060001 	bvc	1807c8 <__bss_end+0x176e7c>
     7c0:	0c00000b 	stceq	0, cr0, [r0], {11}
     7c4:	1f081b06 	svcne	0x00081b06
     7c8:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
     7cc:	00000b3d 	andeq	r0, r0, sp, lsr fp
     7d0:	1f191d06 	svcne	0x00191d06
     7d4:	00000005 	andeq	r0, r0, r5
     7d8:	000bb30d 	andeq	fp, fp, sp, lsl #6
     7dc:	191e0600 	ldmdbne	lr, {r9, sl}
     7e0:	0000051f 	andeq	r0, r0, pc, lsl r5
     7e4:	07c80d04 	strbeq	r0, [r8, r4, lsl #26]
     7e8:	1f060000 	svcne	0x00060000
     7ec:	00052513 	andeq	r2, r5, r3, lsl r5
     7f0:	17000800 	strne	r0, [r0, -r0, lsl #16]
     7f4:	0004ea04 	andeq	lr, r4, r4, lsl #20
     7f8:	19041700 	stmdbne	r4, {r8, r9, sl, ip}
     7fc:	0c000004 	stceq	0, cr0, [r0], {4}
     800:	00000a43 	andeq	r0, r0, r3, asr #20
     804:	07220614 			; <UNDEFINED> instruction: 0x07220614
     808:	000007ad 	andeq	r0, r0, sp, lsr #15
     80c:	0005c40d 	andeq	ip, r5, sp, lsl #8
     810:	12260600 	eorne	r0, r6, #0, 12
     814:	0000004d 	andeq	r0, r0, sp, asr #32
     818:	081c0d00 	ldmdaeq	ip, {r8, sl, fp}
     81c:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
     820:	00051f1d 	andeq	r1, r5, sp, lsl pc
     824:	680d0400 	stmdavs	sp, {sl}
     828:	06000009 	streq	r0, [r0], -r9
     82c:	051f1d2c 	ldreq	r1, [pc, #-3372]	; fffffb08 <__bss_end+0xffff61bc>
     830:	1b080000 	blne	200838 <__bss_end+0x1f6eec>
     834:	00000593 	muleq	r0, r3, r5
     838:	570e2f06 	strpl	r2, [lr, -r6, lsl #30]
     83c:	7300000b 	movwvc	r0, #11
     840:	7e000005 	cdpvc	0, 0, cr0, cr0, cr5, {0}
     844:	0f000005 	svceq	0x00000005
     848:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     84c:	00051f10 	andeq	r1, r5, r0, lsl pc
     850:	d31c0000 	tstle	ip, #0
     854:	06000005 	streq	r0, [r0], -r5
     858:	0bde0e31 	bleq	ff784124 <__bss_end+0xff77a7d8>
     85c:	03250000 			; <UNDEFINED> instruction: 0x03250000
     860:	05960000 	ldreq	r0, [r6]
     864:	05a10000 	streq	r0, [r1, #0]!
     868:	b20f0000 	andlt	r0, pc, #0
     86c:	10000007 	andne	r0, r0, r7
     870:	00000525 	andeq	r0, r0, r5, lsr #10
     874:	07121200 	ldreq	r1, [r2, -r0, lsl #4]
     878:	35060000 	strcc	r0, [r6, #-0]
     87c:	0008a01d 	andeq	sl, r8, sp, lsl r0
     880:	00051f00 	andeq	r1, r5, r0, lsl #30
     884:	05ba0200 	ldreq	r0, [sl, #512]!	; 0x200
     888:	05c00000 	strbeq	r0, [r0]
     88c:	b20f0000 	andlt	r0, pc, #0
     890:	00000007 	andeq	r0, r0, r7
     894:	000b9b12 	andeq	r9, fp, r2, lsl fp
     898:	1d370600 	ldcne	6, cr0, [r7, #-0]
     89c:	00000bb8 			; <UNDEFINED> instruction: 0x00000bb8
     8a0:	0000051f 	andeq	r0, r0, pc, lsl r5
     8a4:	0005d902 	andeq	sp, r5, r2, lsl #18
     8a8:	0005df00 	andeq	sp, r5, r0, lsl #30
     8ac:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     8b0:	1d000000 	stcne	0, cr0, [r0, #-0]
     8b4:	000008dc 	ldrdeq	r0, [r0], -ip
     8b8:	cb313906 	blgt	c4ecd8 <__bss_end+0xc4538c>
     8bc:	0c000007 	stceq	0, cr0, [r0], {7}
     8c0:	0a431202 	beq	10c50d0 <__bss_end+0x10bb784>
     8c4:	3c060000 	stccc	0, cr0, [r6], {-0}
     8c8:	00087309 	andeq	r7, r8, r9, lsl #6
     8cc:	0007b200 	andeq	fp, r7, r0, lsl #4
     8d0:	06060100 	streq	r0, [r6], -r0, lsl #2
     8d4:	060c0000 	streq	r0, [ip], -r0
     8d8:	b20f0000 	andlt	r0, pc, #0
     8dc:	00000007 	andeq	r0, r0, r7
     8e0:	00060412 	andeq	r0, r6, r2, lsl r4
     8e4:	123f0600 	eorsne	r0, pc, #0, 12
     8e8:	000006a3 	andeq	r0, r0, r3, lsr #13
     8ec:	0000004d 	andeq	r0, r0, sp, asr #32
     8f0:	00062501 	andeq	r2, r6, r1, lsl #10
     8f4:	00063a00 	andeq	r3, r6, r0, lsl #20
     8f8:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     8fc:	d4100000 	ldrle	r0, [r0], #-0
     900:	10000007 	andne	r0, r0, r7
     904:	0000005e 	andeq	r0, r0, lr, asr r0
     908:	00032510 	andeq	r2, r3, r0, lsl r5
     90c:	9a130000 	bls	4c0914 <__bss_end+0x4b6fc8>
     910:	06000006 	streq	r0, [r0], -r6
     914:	05240e42 	streq	r0, [r4, #-3650]!	; 0xfffff1be
     918:	4f010000 	svcmi	0x00010000
     91c:	55000006 	strpl	r0, [r0, #-6]
     920:	0f000006 	svceq	0x00000006
     924:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     928:	07431200 	strbeq	r1, [r3, -r0, lsl #4]
     92c:	45060000 	strmi	r0, [r6, #-0]
     930:	00047a17 	andeq	r7, r4, r7, lsl sl
     934:	00052500 	andeq	r2, r5, r0, lsl #10
     938:	066e0100 	strbteq	r0, [lr], -r0, lsl #2
     93c:	06740000 	ldrbteq	r0, [r4], -r0
     940:	da0f0000 	ble	3c0948 <__bss_end+0x3b6ffc>
     944:	00000007 	andeq	r0, r0, r7
     948:	00094112 	andeq	r4, r9, r2, lsl r1
     94c:	17480600 	strbne	r0, [r8, -r0, lsl #12]
     950:	000004f7 	strdeq	r0, [r0], -r7
     954:	00000525 	andeq	r0, r0, r5, lsr #10
     958:	00068d01 	andeq	r8, r6, r1, lsl #26
     95c:	00069800 	andeq	r9, r6, r0, lsl #16
     960:	07da0f00 	ldrbeq	r0, [sl, r0, lsl #30]
     964:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     968:	00000000 	andeq	r0, r0, r0
     96c:	0007a713 	andeq	sl, r7, r3, lsl r7
     970:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
     974:	000008ea 	andeq	r0, r0, sl, ror #17
     978:	0006ad01 	andeq	sl, r6, r1, lsl #26
     97c:	0006b300 	andeq	fp, r6, r0, lsl #6
     980:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     984:	12000000 	andne	r0, r0, #0
     988:	000005d3 	ldrdeq	r0, [r0], -r3
     98c:	450e4d06 	strmi	r4, [lr, #-3334]	; 0xfffff2fa
     990:	25000005 	strcs	r0, [r0, #-5]
     994:	01000003 	tsteq	r0, r3
     998:	000006cc 	andeq	r0, r0, ip, asr #13
     99c:	000006d7 	ldrdeq	r0, [r0], -r7
     9a0:	0007b20f 	andeq	fp, r7, pc, lsl #4
     9a4:	004d1000 	subeq	r1, sp, r0
     9a8:	12000000 	andne	r0, r0, #0
     9ac:	00000954 	andeq	r0, r0, r4, asr r9
     9b0:	e9125006 	ldmdb	r2, {r1, r2, ip, lr}
     9b4:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
     9b8:	01000000 	mrseq	r0, (UNDEF: 0)
     9bc:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     9c0:	000006fb 	strdeq	r0, [r0], -fp
     9c4:	0007b20f 	andeq	fp, r7, pc, lsl #4
     9c8:	03541000 	cmpeq	r4, #0
     9cc:	12000000 	andne	r0, r0, #0
     9d0:	000006ce 	andeq	r0, r0, lr, asr #13
     9d4:	e60e5306 	str	r5, [lr], -r6, lsl #6
     9d8:	25000006 	strcs	r0, [r0, #-6]
     9dc:	01000003 	tsteq	r0, r3
     9e0:	00000714 	andeq	r0, r0, r4, lsl r7
     9e4:	0000071f 	andeq	r0, r0, pc, lsl r7
     9e8:	0007b20f 	andeq	fp, r7, pc, lsl #4
     9ec:	004d1000 	subeq	r1, sp, r0
     9f0:	13000000 	movwne	r0, #0
     9f4:	00000919 	andeq	r0, r0, r9, lsl r9
     9f8:	870e5606 	strhi	r5, [lr, -r6, lsl #12]
     9fc:	01000009 	tsteq	r0, r9
     a00:	00000734 	andeq	r0, r0, r4, lsr r7
     a04:	00000753 	andeq	r0, r0, r3, asr r7
     a08:	0007b20f 	andeq	fp, r7, pc, lsl #4
     a0c:	008b1000 	addeq	r1, fp, r0
     a10:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a14:	10000000 	andne	r0, r0, r0
     a18:	0000004d 	andeq	r0, r0, sp, asr #32
     a1c:	00004d10 	andeq	r4, r0, r0, lsl sp
     a20:	07e01000 	strbeq	r1, [r0, r0]!
     a24:	13000000 	movwne	r0, #0
     a28:	000005e2 	andeq	r0, r0, r2, ror #11
     a2c:	df0e5806 	svcle	0x000e5806
     a30:	01000009 	tsteq	r0, r9
     a34:	00000768 	andeq	r0, r0, r8, ror #14
     a38:	00000787 	andeq	r0, r0, r7, lsl #15
     a3c:	0007b20f 	andeq	fp, r7, pc, lsl #4
     a40:	00c21000 	sbceq	r1, r2, r0
     a44:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a48:	10000000 	andne	r0, r0, r0
     a4c:	0000004d 	andeq	r0, r0, sp, asr #32
     a50:	00004d10 	andeq	r4, r0, r0, lsl sp
     a54:	07e01000 	strbeq	r1, [r0, r0]!
     a58:	14000000 	strne	r0, [r0], #-0
     a5c:	0000088d 	andeq	r0, r0, sp, lsl #17
     a60:	c60e5b06 	strgt	r5, [lr], -r6, lsl #22
     a64:	2500000a 	strcs	r0, [r0, #-10]
     a68:	01000003 	tsteq	r0, r3
     a6c:	0000079c 	muleq	r0, ip, r7
     a70:	0007b20f 	andeq	fp, r7, pc, lsl #4
     a74:	04cb1000 	strbeq	r1, [fp], #0
     a78:	e6100000 	ldr	r0, [r0], -r0
     a7c:	00000007 	andeq	r0, r0, r7
     a80:	052b0300 	streq	r0, [fp, #-768]!	; 0xfffffd00
     a84:	04170000 	ldreq	r0, [r7], #-0
     a88:	0000052b 	andeq	r0, r0, fp, lsr #10
     a8c:	00051f1e 	andeq	r1, r5, lr, lsl pc
     a90:	0007c500 	andeq	ip, r7, r0, lsl #10
     a94:	0007cb00 	andeq	ip, r7, r0, lsl #22
     a98:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     a9c:	1f000000 	svcne	0x00000000
     aa0:	0000052b 	andeq	r0, r0, fp, lsr #10
     aa4:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
     aa8:	003f0417 	eorseq	r0, pc, r7, lsl r4	; <UNPREDICTABLE>
     aac:	04170000 	ldreq	r0, [r7], #-0
     ab0:	000007ad 	andeq	r0, r0, sp, lsr #15
     ab4:	00650420 	rsbeq	r0, r5, r0, lsr #8
     ab8:	04210000 	strteq	r0, [r1], #-0
     abc:	00076219 	andeq	r6, r7, r9, lsl r2
     ac0:	195e0600 	ldmdbne	lr, {r9, sl}^
     ac4:	0000052b 	andeq	r0, r0, fp, lsr #10
     ac8:	0004d422 	andeq	sp, r4, r2, lsr #8
     acc:	05050100 	streq	r0, [r5, #-256]	; 0xffffff00
     ad0:	00000038 	andeq	r0, r0, r8, lsr r0
     ad4:	0000822c 	andeq	r8, r0, ip, lsr #4
     ad8:	00000048 	andeq	r0, r0, r8, asr #32
     adc:	082d9c01 	stmdaeq	sp!, {r0, sl, fp, ip, pc}
     ae0:	ce230000 	cdpgt	0, 2, cr0, cr3, cr0, {0}
     ae4:	01000005 	tsteq	r0, r5
     ae8:	00380e05 	eorseq	r0, r8, r5, lsl #28
     aec:	91020000 	mrsls	r0, (UNDEF: 2)
     af0:	06e12374 			; <UNDEFINED> instruction: 0x06e12374
     af4:	05010000 	streq	r0, [r1, #-0]
     af8:	00082d1b 	andeq	r2, r8, fp, lsl sp
     afc:	70910200 	addsvc	r0, r1, r0, lsl #4
     b00:	33041700 	movwcc	r1, #18176	; 0x4700
     b04:	17000008 	strne	r0, [r0, -r8]
     b08:	00002504 	andeq	r2, r0, r4, lsl #10
     b0c:	0cf50000 	ldcleq	0, cr0, [r5]
     b10:	00040000 	andeq	r0, r4, r0
     b14:	000003f7 	strdeq	r0, [r0], -r7
     b18:	0f8f0104 	svceq	0x008f0104
     b1c:	64040000 	strvs	r0, [r4], #-0
     b20:	ef00000d 	svc	0x0000000d
     b24:	7400000d 	strvc	r0, [r0], #-13
     b28:	5c000082 	stcpl	0, cr0, [r0], {130}	; 0x82
     b2c:	82000004 	andhi	r0, r0, #4
     b30:	02000003 	andeq	r0, r0, #3
     b34:	07330801 	ldreq	r0, [r3, -r1, lsl #16]!
     b38:	25030000 	strcs	r0, [r3, #-0]
     b3c:	02000000 	andeq	r0, r0, #0
     b40:	045b0502 	ldrbeq	r0, [fp], #-1282	; 0xfffffafe
     b44:	04040000 	streq	r0, [r4], #-0
     b48:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     b4c:	08010200 	stmdaeq	r1, {r9}
     b50:	0000072a 	andeq	r0, r0, sl, lsr #14
     b54:	2f070202 	svccs	0x00070202
     b58:	05000008 	streq	r0, [r0, #-8]
     b5c:	00000773 	andeq	r0, r0, r3, ror r7
     b60:	5e070908 	vmlapl.f16	s0, s14, s16	; <UNPREDICTABLE>
     b64:	03000000 	movweq	r0, #0
     b68:	0000004d 	andeq	r0, r0, sp, asr #32
     b6c:	df070402 	svcle	0x00070402
     b70:	06000017 			; <UNDEFINED> instruction: 0x06000017
     b74:	00000a2b 	andeq	r0, r0, fp, lsr #20
     b78:	08060208 	stmdaeq	r6, {r3, r9}
     b7c:	0000008b 	andeq	r0, r0, fp, lsl #1
     b80:	00307207 	eorseq	r7, r0, r7, lsl #4
     b84:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     b88:	00000000 	andeq	r0, r0, r0
     b8c:	00317207 	eorseq	r7, r1, r7, lsl #4
     b90:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     b94:	04000000 	streq	r0, [r0], #-0
     b98:	0ebd0800 	cdpeq	8, 11, cr0, cr13, cr0, {0}
     b9c:	04050000 	streq	r0, [r5], #-0
     ba0:	00000038 	andeq	r0, r0, r8, lsr r0
     ba4:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
     ba8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     bac:	00004b4f 	andeq	r4, r0, pc, asr #22
     bb0:	000ca40a 	andeq	sl, ip, sl, lsl #8
     bb4:	08000100 	stmdaeq	r0, {r8}
     bb8:	00000465 	andeq	r0, r0, r5, ror #8
     bbc:	00380405 	eorseq	r0, r8, r5, lsl #8
     bc0:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     bc4:	0000e00c 	andeq	lr, r0, ip
     bc8:	04cc0a00 	strbeq	r0, [ip], #2560	; 0xa00
     bcc:	0a000000 	beq	bd4 <shift+0xbd4>
     bd0:	00000b20 	andeq	r0, r0, r0, lsr #22
     bd4:	03a80a01 			; <UNDEFINED> instruction: 0x03a80a01
     bd8:	0a020000 	beq	80be0 <__bss_end+0x77294>
     bdc:	00000694 	muleq	r0, r4, r6
     be0:	0b110a03 	bleq	4433f4 <__bss_end+0x439aa8>
     be4:	0a040000 	beq	100bec <__bss_end+0xf72a0>
     be8:	00000613 	andeq	r0, r0, r3, lsl r6
     bec:	38080005 	stmdacc	r8, {r0, r2}
     bf0:	05000004 	streq	r0, [r0, #-4]
     bf4:	00003804 	andeq	r3, r0, r4, lsl #16
     bf8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; c00 <shift+0xc00>
     bfc:	0000011d 	andeq	r0, r0, sp, lsl r1
     c00:	0007e40a 	andeq	lr, r7, sl, lsl #8
     c04:	6e0a0000 	cdpvs	0, 0, cr0, cr10, cr0, {0}
     c08:	01000007 	tsteq	r0, r7
     c0c:	00075c0a 	andeq	r5, r7, sl, lsl #24
     c10:	d90a0200 	stmdble	sl, {r9}
     c14:	03000009 	movweq	r0, #9
     c18:	00097b0a 	andeq	r7, r9, sl, lsl #22
     c1c:	540a0400 	strpl	r0, [sl], #-1024	; 0xfffffc00
     c20:	0500000a 	streq	r0, [r0, #-10]
     c24:	0007250a 	andeq	r2, r7, sl, lsl #10
     c28:	08000600 	stmdaeq	r0, {r9, sl}
     c2c:	00000f22 	andeq	r0, r0, r2, lsr #30
     c30:	00380405 	eorseq	r0, r8, r5, lsl #8
     c34:	66020000 	strvs	r0, [r2], -r0
     c38:	0001480c 	andeq	r4, r1, ip, lsl #16
     c3c:	0e5d0a00 	vnmlseq.f32	s1, s26, s0
     c40:	0a000000 	beq	c48 <shift+0xc48>
     c44:	00000d01 	andeq	r0, r0, r1, lsl #26
     c48:	0e860a01 	vdiveq.f32	s0, s12, s2
     c4c:	0a020000 	beq	80c54 <__bss_end+0x77308>
     c50:	00000d26 	andeq	r0, r0, r6, lsr #26
     c54:	390b0003 	stmdbcc	fp, {r0, r1}
     c58:	03000006 	movweq	r0, #6
     c5c:	00591405 	subseq	r1, r9, r5, lsl #8
     c60:	03050000 	movweq	r0, #20480	; 0x5000
     c64:	000098e8 	andeq	r9, r0, r8, ror #17
     c68:	000a370b 	andeq	r3, sl, fp, lsl #14
     c6c:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     c70:	00000059 	andeq	r0, r0, r9, asr r0
     c74:	98ec0305 	stmials	ip!, {r0, r2, r8, r9}^
     c78:	9d0b0000 	stcls	0, cr0, [fp, #-0]
     c7c:	04000005 	streq	r0, [r0], #-5
     c80:	00591a07 	subseq	r1, r9, r7, lsl #20
     c84:	03050000 	movweq	r0, #20480	; 0x5000
     c88:	000098f0 	strdeq	r9, [r0], -r0
     c8c:	0006550b 	andeq	r5, r6, fp, lsl #10
     c90:	1a090400 	bne	241c98 <__bss_end+0x23834c>
     c94:	00000059 	andeq	r0, r0, r9, asr r0
     c98:	98f40305 	ldmls	r4!, {r0, r2, r8, r9}^
     c9c:	ce0b0000 	cdpgt	0, 0, cr0, cr11, cr0, {0}
     ca0:	04000008 	streq	r0, [r0], #-8
     ca4:	00591a0b 	subseq	r1, r9, fp, lsl #20
     ca8:	03050000 	movweq	r0, #20480	; 0x5000
     cac:	000098f8 	strdeq	r9, [r0], -r8
     cb0:	000a5b0b 	andeq	r5, sl, fp, lsl #22
     cb4:	1a0d0400 	bne	341cbc <__bss_end+0x338370>
     cb8:	00000059 	andeq	r0, r0, r9, asr r0
     cbc:	98fc0305 	ldmls	ip!, {r0, r2, r8, r9}^
     cc0:	570b0000 	strpl	r0, [fp, -r0]
     cc4:	04000008 	streq	r0, [r0], #-8
     cc8:	00591a0f 	subseq	r1, r9, pc, lsl #20
     ccc:	03050000 	movweq	r0, #20480	; 0x5000
     cd0:	00009900 	andeq	r9, r0, r0, lsl #18
     cd4:	00079708 	andeq	r9, r7, r8, lsl #14
     cd8:	38040500 	stmdacc	r4, {r8, sl}
     cdc:	04000000 	streq	r0, [r0], #-0
     ce0:	01eb0c1b 	mvneq	r0, fp, lsl ip
     ce4:	690a0000 	stmdbvs	sl, {}	; <UNPREDICTABLE>
     ce8:	00000008 	andeq	r0, r0, r8
     cec:	000ba80a 	andeq	sl, fp, sl, lsl #16
     cf0:	570a0100 	strpl	r0, [sl, -r0, lsl #2]
     cf4:	02000007 	andeq	r0, r0, #7
     cf8:	08160c00 	ldmdaeq	r6, {sl, fp}
     cfc:	710d0000 	mrsvc	r0, (UNDEF: 13)
     d00:	90000006 	andls	r0, r0, r6
     d04:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
     d08:	06000003 	streq	r0, [r0], -r3
     d0c:	00000647 	andeq	r0, r0, r7, asr #12
     d10:	10670424 	rsbne	r0, r7, r4, lsr #8
     d14:	00000278 	andeq	r0, r0, r8, ror r2
     d18:	001b4f0e 	andseq	r4, fp, lr, lsl #30
     d1c:	12690400 	rsbne	r0, r9, #0, 8
     d20:	0000035e 	andeq	r0, r0, lr, asr r3
     d24:	05870e00 	streq	r0, [r7, #3584]	; 0xe00
     d28:	6b040000 	blvs	100d30 <__bss_end+0xf73e4>
     d2c:	00036e12 	andeq	r6, r3, r2, lsl lr
     d30:	4c0e1000 	stcmi	0, cr1, [lr], {-0}
     d34:	04000008 	streq	r0, [r0], #-8
     d38:	004d166d 	subeq	r1, sp, sp, ror #12
     d3c:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     d40:	00000632 	andeq	r0, r0, r2, lsr r6
     d44:	751c7004 	ldrvc	r7, [ip, #-4]
     d48:	18000003 	stmdane	r0, {r0, r1}
     d4c:	00067d0e 	andeq	r7, r6, lr, lsl #26
     d50:	1c720400 	cfldrdne	mvd0, [r2], #-0
     d54:	00000375 	andeq	r0, r0, r5, ror r3
     d58:	0bb30e1c 	bleq	fecc45d0 <__bss_end+0xfecbac84>
     d5c:	75040000 	strvc	r0, [r4, #-0]
     d60:	0003751c 	andeq	r7, r3, ip, lsl r5
     d64:	bd0f2000 	stclt	0, cr2, [pc, #-0]	; d6c <shift+0xd6c>
     d68:	04000007 	streq	r0, [r0], #-7
     d6c:	0a6e1c77 	beq	1b87f50 <__bss_end+0x1b7e604>
     d70:	03750000 	cmneq	r5, #0
     d74:	026c0000 	rsbeq	r0, ip, #0
     d78:	75100000 	ldrvc	r0, [r0, #-0]
     d7c:	11000003 	tstne	r0, r3
     d80:	0000037b 	andeq	r0, r0, fp, ror r3
     d84:	38060000 	stmdacc	r6, {}	; <UNPREDICTABLE>
     d88:	18000007 	stmdane	r0, {r0, r1, r2}
     d8c:	ad107b04 	vldrge	d7, [r0, #-16]
     d90:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     d94:	00001b4f 	andeq	r1, r0, pc, asr #22
     d98:	5e127e04 	cdppl	14, 1, cr7, cr2, cr4, {0}
     d9c:	00000003 	andeq	r0, r0, r3
     da0:	0004500e 	andeq	r5, r4, lr
     da4:	19800400 	stmibne	r0, {sl}
     da8:	0000037b 	andeq	r0, r0, fp, ror r3
     dac:	07dd0e10 	bfieq	r0, r0, #28, #2
     db0:	82040000 	andhi	r0, r4, #0
     db4:	00038621 	andeq	r8, r3, r1, lsr #12
     db8:	03001400 	movweq	r1, #1024	; 0x400
     dbc:	00000278 	andeq	r0, r0, r8, ror r2
     dc0:	0004d912 	andeq	sp, r4, r2, lsl r9
     dc4:	21860400 	orrcs	r0, r6, r0, lsl #8
     dc8:	0000038c 	andeq	r0, r0, ip, lsl #7
     dcc:	0004e512 	andeq	lr, r4, r2, lsl r5
     dd0:	1f880400 	svcne	0x00880400
     dd4:	00000059 	andeq	r0, r0, r9, asr r0
     dd8:	0009810e 	andeq	r8, r9, lr, lsl #2
     ddc:	178b0400 	strne	r0, [fp, r0, lsl #8]
     de0:	000001fd 	strdeq	r0, [r0], -sp
     de4:	03f70e00 	mvnseq	r0, #0, 28
     de8:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
     dec:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
     df0:	420e2400 	andmi	r2, lr, #0, 8
     df4:	04000008 	streq	r0, [r0], #-8
     df8:	01fd178f 	mvnseq	r1, pc, lsl #15
     dfc:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     e00:	000007d3 	ldrdeq	r0, [r0], -r3
     e04:	fd179004 	ldc2	0, cr9, [r7, #-16]
     e08:	6c000001 	stcvs	0, cr0, [r0], {1}
     e0c:	00067113 	andeq	r7, r6, r3, lsl r1
     e10:	09930400 	ldmibeq	r3, {sl}
     e14:	00000ab1 			; <UNDEFINED> instruction: 0x00000ab1
     e18:	00000397 	muleq	r0, r7, r3
     e1c:	00031701 	andeq	r1, r3, r1, lsl #14
     e20:	00031d00 	andeq	r1, r3, r0, lsl #26
     e24:	03971000 	orrseq	r1, r7, #0
     e28:	14000000 	strne	r0, [r0], #-0
     e2c:	000004c1 	andeq	r0, r0, r1, asr #9
     e30:	140e9604 	strne	r9, [lr], #-1540	; 0xfffff9fc
     e34:	0100000c 	tsteq	r0, ip
     e38:	00000332 	andeq	r0, r0, r2, lsr r3
     e3c:	00000338 	andeq	r0, r0, r8, lsr r3
     e40:	00039710 	andeq	r9, r3, r0, lsl r7
     e44:	e4150000 	ldr	r0, [r5], #-0
     e48:	04000007 	streq	r0, [r0], #-7
     e4c:	077c1099 			; <UNDEFINED> instruction: 0x077c1099
     e50:	039d0000 	orrseq	r0, sp, #0
     e54:	4d010000 	stcmi	0, cr0, [r1, #-0]
     e58:	10000003 	andne	r0, r0, r3
     e5c:	00000397 	muleq	r0, r7, r3
     e60:	00037b11 	andeq	r7, r3, r1, lsl fp
     e64:	01c61100 	biceq	r1, r6, r0, lsl #2
     e68:	00000000 	andeq	r0, r0, r0
     e6c:	00002516 	andeq	r2, r0, r6, lsl r5
     e70:	00036e00 	andeq	r6, r3, r0, lsl #28
     e74:	005e1700 	subseq	r1, lr, r0, lsl #14
     e78:	000f0000 	andeq	r0, pc, r0
     e7c:	bf020102 	svclt	0x00020102
     e80:	18000005 	stmdane	r0, {r0, r2}
     e84:	0001fd04 	andeq	pc, r1, r4, lsl #26
     e88:	2c041800 	stccs	8, cr1, [r4], {-0}
     e8c:	0c000000 	stceq	0, cr0, [r0], {-0}
     e90:	00000b2a 	andeq	r0, r0, sl, lsr #22
     e94:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
     e98:	ad160000 	ldcge	0, cr0, [r6, #-0]
     e9c:	97000002 	strls	r0, [r0, -r2]
     ea0:	19000003 	stmdbne	r0, {r0, r1}
     ea4:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
     ea8:	18000001 	stmdane	r0, {r0}
     eac:	0001eb04 	andeq	lr, r1, r4, lsl #22
     eb0:	05b31a00 	ldreq	r1, [r3, #2560]!	; 0xa00
     eb4:	9c040000 	stcls	0, cr0, [r4], {-0}
     eb8:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
     ebc:	04a80b00 	strteq	r0, [r8], #2816	; 0xb00
     ec0:	04050000 	streq	r0, [r5], #-0
     ec4:	00005914 	andeq	r5, r0, r4, lsl r9
     ec8:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     ecc:	0b000099 	bleq	1138 <shift+0x1138>
     ed0:	000003ae 	andeq	r0, r0, lr, lsr #7
     ed4:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     ed8:	05000000 	streq	r0, [r0, #-0]
     edc:	00990803 	addseq	r0, r9, r3, lsl #16
     ee0:	0a9e0b00 	beq	fe783ae8 <__bss_end+0xfe77a19c>
     ee4:	0a050000 	beq	140eec <__bss_end+0x1375a0>
     ee8:	00005914 	andeq	r5, r0, r4, lsl r9
     eec:	0c030500 	cfstr32eq	mvfx0, [r3], {-0}
     ef0:	08000099 	stmdaeq	r0, {r0, r3, r4, r7}
     ef4:	0000042c 	andeq	r0, r0, ip, lsr #8
     ef8:	00380405 	eorseq	r0, r8, r5, lsl #8
     efc:	0d050000 	stceq	0, cr0, [r5, #-0]
     f00:	00041c0c 	andeq	r1, r4, ip, lsl #24
     f04:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     f08:	0a000077 	beq	10ec <shift+0x10ec>
     f0c:	000008c5 	andeq	r0, r0, r5, asr #17
     f10:	0b090a01 	bleq	24371c <__bss_end+0x239dd0>
     f14:	0a020000 	beq	80f1c <__bss_end+0x775d0>
     f18:	00000861 	andeq	r0, r0, r1, ror #16
     f1c:	06860a03 	streq	r0, [r6], r3, lsl #20
     f20:	0a040000 	beq	100f28 <__bss_end+0xf75dc>
     f24:	0000071e 	andeq	r0, r0, lr, lsl r7
     f28:	1f060005 	svcne	0x00060005
     f2c:	10000004 	andne	r0, r0, r4
     f30:	5b081b05 	blpl	207b4c <__bss_end+0x1fe200>
     f34:	07000004 	streq	r0, [r0, -r4]
     f38:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     f3c:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
     f40:	07000000 	streq	r0, [r0, -r0]
     f44:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     f48:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
     f4c:	07040000 	streq	r0, [r4, -r0]
     f50:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     f54:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
     f58:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     f5c:	000007cd 	andeq	r0, r0, sp, asr #15
     f60:	5b132005 	blpl	4c8f7c <__bss_end+0x4bf630>
     f64:	0c000004 	stceq	0, cr0, [r0], {4}
     f68:	07040200 	streq	r0, [r4, -r0, lsl #4]
     f6c:	000017da 	ldrdeq	r1, [r0], -sl
     f70:	000c0706 	andeq	r0, ip, r6, lsl #14
     f74:	28057000 	stmdacs	r5, {ip, sp, lr}
     f78:	0004f208 	andeq	pc, r4, r8, lsl #4
     f7c:	05f80e00 	ldrbeq	r0, [r8, #3584]!	; 0xe00
     f80:	2a050000 	bcs	140f88 <__bss_end+0x13763c>
     f84:	00041c12 	andeq	r1, r4, r2, lsl ip
     f88:	70070000 	andvc	r0, r7, r0
     f8c:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     f90:	005e122b 	subseq	r1, lr, fp, lsr #4
     f94:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     f98:	0000152b 	andeq	r1, r0, fp, lsr #10
     f9c:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
     fa0:	14000003 	strne	r0, [r0], #-3
     fa4:	000b8d0e 	andeq	r8, fp, lr, lsl #26
     fa8:	122d0500 	eorne	r0, sp, #0, 10
     fac:	0000005e 	andeq	r0, r0, lr, asr r0
     fb0:	061c0e18 			; <UNDEFINED> instruction: 0x061c0e18
     fb4:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     fb8:	00005e12 	andeq	r5, r0, r2, lsl lr
     fbc:	9b0e1c00 	blls	387fc4 <__bss_end+0x37e678>
     fc0:	05000003 	streq	r0, [r0, #-3]
     fc4:	04f20c2f 	ldrbteq	r0, [r2], #3119	; 0xc2f
     fc8:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     fcc:	00000667 	andeq	r0, r0, r7, ror #12
     fd0:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
     fd4:	60000000 	andvs	r0, r0, r0
     fd8:	0004130e 	andeq	r1, r4, lr, lsl #6
     fdc:	0e310500 	cfabs32eq	mvfx0, mvfx1
     fe0:	0000004d 	andeq	r0, r0, sp, asr #32
     fe4:	040a0e64 	streq	r0, [sl], #-3684	; 0xfffff19c
     fe8:	33050000 	movwcc	r0, #20480	; 0x5000
     fec:	00004d0e 	andeq	r4, r0, lr, lsl #26
     ff0:	010e6800 	tsteq	lr, r0, lsl #16
     ff4:	05000004 	streq	r0, [r0, #-4]
     ff8:	004d0e34 	subeq	r0, sp, r4, lsr lr
     ffc:	006c0000 	rsbeq	r0, ip, r0
    1000:	00039d16 	andeq	r9, r3, r6, lsl sp
    1004:	00050200 	andeq	r0, r5, r0, lsl #4
    1008:	005e1700 	subseq	r1, lr, r0, lsl #14
    100c:	000f0000 	andeq	r0, pc, r0
    1010:	00056d0b 	andeq	r6, r5, fp, lsl #26
    1014:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    1018:	00000059 	andeq	r0, r0, r9, asr r0
    101c:	99100305 	ldmdbls	r0, {r0, r2, r8, r9}
    1020:	2c080000 	stccs	0, cr0, [r8], {-0}
    1024:	05000009 	streq	r0, [r0, #-9]
    1028:	00003804 	andeq	r3, r0, r4, lsl #16
    102c:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1030:	00000533 	andeq	r0, r0, r3, lsr r5
    1034:	000b420a 	andeq	r4, fp, sl, lsl #4
    1038:	7c0a0000 	stcvc	0, cr0, [sl], {-0}
    103c:	01000005 	tsteq	r0, r5
    1040:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1044:	cb080000 	blgt	20104c <__bss_end+0x1f7700>
    1048:	0500000d 	streq	r0, [r0, #-13]
    104c:	00003804 	andeq	r3, r0, r4, lsl #16
    1050:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1054:	00000557 	andeq	r0, r0, r7, asr r5
    1058:	000c390a 	andeq	r3, ip, sl, lsl #18
    105c:	780a0000 	stmdavc	sl, {}	; <UNPREDICTABLE>
    1060:	0100000e 	tsteq	r0, lr
    1064:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    1068:	7a060000 	bvc	181070 <__bss_end+0x177724>
    106c:	0c00000b 	stceq	0, cr0, [r0], {11}
    1070:	91081b06 	tstls	r8, r6, lsl #22
    1074:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1078:	00000b3d 	andeq	r0, r0, sp, lsr fp
    107c:	91191d06 	tstls	r9, r6, lsl #26
    1080:	00000005 	andeq	r0, r0, r5
    1084:	000bb30e 	andeq	fp, fp, lr, lsl #6
    1088:	191e0600 	ldmdbne	lr, {r9, sl}
    108c:	00000591 	muleq	r0, r1, r5
    1090:	07c80e04 	strbeq	r0, [r8, r4, lsl #28]
    1094:	1f060000 	svcne	0x00060000
    1098:	00059713 	andeq	r9, r5, r3, lsl r7
    109c:	18000800 	stmdane	r0, {fp}
    10a0:	00055c04 	andeq	r5, r5, r4, lsl #24
    10a4:	62041800 	andvs	r1, r4, #0, 16
    10a8:	0d000004 	stceq	0, cr0, [r0, #-16]
    10ac:	00000a43 	andeq	r0, r0, r3, asr #20
    10b0:	07220614 			; <UNDEFINED> instruction: 0x07220614
    10b4:	0000081f 	andeq	r0, r0, pc, lsl r8
    10b8:	0005c40e 	andeq	ip, r5, lr, lsl #8
    10bc:	12260600 	eorne	r0, r6, #0, 12
    10c0:	0000004d 	andeq	r0, r0, sp, asr #32
    10c4:	081c0e00 	ldmdaeq	ip, {r9, sl, fp}
    10c8:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    10cc:	0005911d 	andeq	r9, r5, sp, lsl r1
    10d0:	680e0400 	stmdavs	lr, {sl}
    10d4:	06000009 	streq	r0, [r0], -r9
    10d8:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    10dc:	1b080000 	blne	2010e4 <__bss_end+0x1f7798>
    10e0:	00000593 	muleq	r0, r3, r5
    10e4:	570e2f06 	strpl	r2, [lr, -r6, lsl #30]
    10e8:	e500000b 	str	r0, [r0, #-11]
    10ec:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    10f0:	10000005 	andne	r0, r0, r5
    10f4:	00000824 	andeq	r0, r0, r4, lsr #16
    10f8:	00059111 	andeq	r9, r5, r1, lsl r1
    10fc:	d31c0000 	tstle	ip, #0
    1100:	06000005 	streq	r0, [r0], -r5
    1104:	0bde0e31 	bleq	ff7849d0 <__bss_end+0xff77b084>
    1108:	036e0000 	cmneq	lr, #0
    110c:	06080000 	streq	r0, [r8], -r0
    1110:	06130000 	ldreq	r0, [r3], -r0
    1114:	24100000 	ldrcs	r0, [r0], #-0
    1118:	11000008 	tstne	r0, r8
    111c:	00000597 	muleq	r0, r7, r5
    1120:	07121300 	ldreq	r1, [r2, -r0, lsl #6]
    1124:	35060000 	strcc	r0, [r6, #-0]
    1128:	0008a01d 	andeq	sl, r8, sp, lsl r0
    112c:	00059100 	andeq	r9, r5, r0, lsl #2
    1130:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    1134:	06320000 	ldrteq	r0, [r2], -r0
    1138:	24100000 	ldrcs	r0, [r0], #-0
    113c:	00000008 	andeq	r0, r0, r8
    1140:	000b9b13 	andeq	r9, fp, r3, lsl fp
    1144:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1148:	00000bb8 			; <UNDEFINED> instruction: 0x00000bb8
    114c:	00000591 	muleq	r0, r1, r5
    1150:	00064b02 	andeq	r4, r6, r2, lsl #22
    1154:	00065100 	andeq	r5, r6, r0, lsl #2
    1158:	08241000 	stmdaeq	r4!, {ip}
    115c:	1d000000 	stcne	0, cr0, [r0, #-0]
    1160:	000008dc 	ldrdeq	r0, [r0], -ip
    1164:	3d313906 			; <UNDEFINED> instruction: 0x3d313906
    1168:	0c000008 	stceq	0, cr0, [r0], {8}
    116c:	0a431302 	beq	10c5d7c <__bss_end+0x10bc430>
    1170:	3c060000 	stccc	0, cr0, [r6], {-0}
    1174:	00087309 	andeq	r7, r8, r9, lsl #6
    1178:	00082400 	andeq	r2, r8, r0, lsl #8
    117c:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1180:	067e0000 	ldrbteq	r0, [lr], -r0
    1184:	24100000 	ldrcs	r0, [r0], #-0
    1188:	00000008 	andeq	r0, r0, r8
    118c:	00060413 	andeq	r0, r6, r3, lsl r4
    1190:	123f0600 	eorsne	r0, pc, #0, 12
    1194:	000006a3 	andeq	r0, r0, r3, lsr #13
    1198:	0000004d 	andeq	r0, r0, sp, asr #32
    119c:	00069701 	andeq	r9, r6, r1, lsl #14
    11a0:	0006ac00 	andeq	sl, r6, r0, lsl #24
    11a4:	08241000 	stmdaeq	r4!, {ip}
    11a8:	46110000 	ldrmi	r0, [r1], -r0
    11ac:	11000008 	tstne	r0, r8
    11b0:	0000005e 	andeq	r0, r0, lr, asr r0
    11b4:	00036e11 	andeq	r6, r3, r1, lsl lr
    11b8:	9a140000 	bls	5011c0 <__bss_end+0x4f7874>
    11bc:	06000006 	streq	r0, [r0], -r6
    11c0:	05240e42 	streq	r0, [r4, #-3650]!	; 0xfffff1be
    11c4:	c1010000 	mrsgt	r0, (UNDEF: 1)
    11c8:	c7000006 	strgt	r0, [r0, -r6]
    11cc:	10000006 	andne	r0, r0, r6
    11d0:	00000824 	andeq	r0, r0, r4, lsr #16
    11d4:	07431300 	strbeq	r1, [r3, -r0, lsl #6]
    11d8:	45060000 	strmi	r0, [r6, #-0]
    11dc:	00047a17 	andeq	r7, r4, r7, lsl sl
    11e0:	00059700 	andeq	r9, r5, r0, lsl #14
    11e4:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    11e8:	06e60000 	strbteq	r0, [r6], r0
    11ec:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    11f0:	00000008 	andeq	r0, r0, r8
    11f4:	00094113 	andeq	r4, r9, r3, lsl r1
    11f8:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    11fc:	000004f7 	strdeq	r0, [r0], -r7
    1200:	00000597 	muleq	r0, r7, r5
    1204:	0006ff01 	andeq	pc, r6, r1, lsl #30
    1208:	00070a00 	andeq	r0, r7, r0, lsl #20
    120c:	084c1000 	stmdaeq	ip, {ip}^
    1210:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1214:	00000000 	andeq	r0, r0, r0
    1218:	0007a714 	andeq	sl, r7, r4, lsl r7
    121c:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1220:	000008ea 	andeq	r0, r0, sl, ror #17
    1224:	00071f01 	andeq	r1, r7, r1, lsl #30
    1228:	00072500 	andeq	r2, r7, r0, lsl #10
    122c:	08241000 	stmdaeq	r4!, {ip}
    1230:	13000000 	movwne	r0, #0
    1234:	000005d3 	ldrdeq	r0, [r0], -r3
    1238:	450e4d06 	strmi	r4, [lr, #-3334]	; 0xfffff2fa
    123c:	6e000005 	cdpvs	0, 0, cr0, cr0, cr5, {0}
    1240:	01000003 	tsteq	r0, r3
    1244:	0000073e 	andeq	r0, r0, lr, lsr r7
    1248:	00000749 	andeq	r0, r0, r9, asr #14
    124c:	00082410 	andeq	r2, r8, r0, lsl r4
    1250:	004d1100 	subeq	r1, sp, r0, lsl #2
    1254:	13000000 	movwne	r0, #0
    1258:	00000954 	andeq	r0, r0, r4, asr r9
    125c:	e9125006 	ldmdb	r2, {r1, r2, ip, lr}
    1260:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
    1264:	01000000 	mrseq	r0, (UNDEF: 0)
    1268:	00000762 	andeq	r0, r0, r2, ror #14
    126c:	0000076d 	andeq	r0, r0, sp, ror #14
    1270:	00082410 	andeq	r2, r8, r0, lsl r4
    1274:	039d1100 	orrseq	r1, sp, #0, 2
    1278:	13000000 	movwne	r0, #0
    127c:	000006ce 	andeq	r0, r0, lr, asr #13
    1280:	e60e5306 	str	r5, [lr], -r6, lsl #6
    1284:	6e000006 	cdpvs	0, 0, cr0, cr0, cr6, {0}
    1288:	01000003 	tsteq	r0, r3
    128c:	00000786 	andeq	r0, r0, r6, lsl #15
    1290:	00000791 	muleq	r0, r1, r7
    1294:	00082410 	andeq	r2, r8, r0, lsl r4
    1298:	004d1100 	subeq	r1, sp, r0, lsl #2
    129c:	14000000 	strne	r0, [r0], #-0
    12a0:	00000919 	andeq	r0, r0, r9, lsl r9
    12a4:	870e5606 	strhi	r5, [lr, -r6, lsl #12]
    12a8:	01000009 	tsteq	r0, r9
    12ac:	000007a6 	andeq	r0, r0, r6, lsr #15
    12b0:	000007c5 	andeq	r0, r0, r5, asr #15
    12b4:	00082410 	andeq	r2, r8, r0, lsl r4
    12b8:	00a91100 	adceq	r1, r9, r0, lsl #2
    12bc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12c0:	11000000 	mrsne	r0, (UNDEF: 0)
    12c4:	0000004d 	andeq	r0, r0, sp, asr #32
    12c8:	00004d11 	andeq	r4, r0, r1, lsl sp
    12cc:	08521100 	ldmdaeq	r2, {r8, ip}^
    12d0:	14000000 	strne	r0, [r0], #-0
    12d4:	000005e2 	andeq	r0, r0, r2, ror #11
    12d8:	df0e5806 	svcle	0x000e5806
    12dc:	01000009 	tsteq	r0, r9
    12e0:	000007da 	ldrdeq	r0, [r0], -sl
    12e4:	000007f9 	strdeq	r0, [r0], -r9
    12e8:	00082410 	andeq	r2, r8, r0, lsl r4
    12ec:	00e01100 	rsceq	r1, r0, r0, lsl #2
    12f0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12f4:	11000000 	mrsne	r0, (UNDEF: 0)
    12f8:	0000004d 	andeq	r0, r0, sp, asr #32
    12fc:	00004d11 	andeq	r4, r0, r1, lsl sp
    1300:	08521100 	ldmdaeq	r2, {r8, ip}^
    1304:	15000000 	strne	r0, [r0, #-0]
    1308:	0000088d 	andeq	r0, r0, sp, lsl #17
    130c:	c60e5b06 	strgt	r5, [lr], -r6, lsl #22
    1310:	6e00000a 	cdpvs	0, 0, cr0, cr0, cr10, {0}
    1314:	01000003 	tsteq	r0, r3
    1318:	0000080e 	andeq	r0, r0, lr, lsl #16
    131c:	00082410 	andeq	r2, r8, r0, lsl r4
    1320:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    1324:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    1328:	00000008 	andeq	r0, r0, r8
    132c:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    1330:	04180000 	ldreq	r0, [r8], #-0
    1334:	0000059d 	muleq	r0, sp, r5
    1338:	0005911e 	andeq	r9, r5, lr, lsl r1
    133c:	00083700 	andeq	r3, r8, r0, lsl #14
    1340:	00083d00 	andeq	r3, r8, r0, lsl #26
    1344:	08241000 	stmdaeq	r4!, {ip}
    1348:	1f000000 	svcne	0x00000000
    134c:	0000059d 	muleq	r0, sp, r5
    1350:	0000082a 	andeq	r0, r0, sl, lsr #16
    1354:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1358:	04180000 	ldreq	r0, [r8], #-0
    135c:	0000081f 	andeq	r0, r0, pc, lsl r8
    1360:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1364:	04210000 	strteq	r0, [r1], #-0
    1368:	0007621a 	andeq	r6, r7, sl, lsl r2
    136c:	195e0600 	ldmdbne	lr, {r9, sl}^
    1370:	0000059d 	muleq	r0, sp, r5
    1374:	000e450b 	andeq	r4, lr, fp, lsl #10
    1378:	11040700 	tstne	r4, r0, lsl #14
    137c:	0000087f 	andeq	r0, r0, pc, ror r8
    1380:	99140305 	ldmdbls	r4, {r0, r2, r8, r9}
    1384:	04020000 	streq	r0, [r2], #-0
    1388:	0015a904 	andseq	sl, r5, r4, lsl #18
    138c:	08780300 	ldmdaeq	r8!, {r8, r9}^
    1390:	2c160000 	ldccs	0, cr0, [r6], {-0}
    1394:	94000000 	strls	r0, [r0], #-0
    1398:	17000008 	strne	r0, [r0, -r8]
    139c:	0000005e 	andeq	r0, r0, lr, asr r0
    13a0:	84030009 	strhi	r0, [r3], #-9
    13a4:	22000008 	andcs	r0, r0, #8
    13a8:	00000cf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    13ac:	940ca401 	strls	sl, [ip], #-1025	; 0xfffffbff
    13b0:	05000008 	streq	r0, [r0, #-8]
    13b4:	00991803 	addseq	r1, r9, r3, lsl #16
    13b8:	0c522300 	mrrceq	3, 0, r2, r2, cr0	; <UNPREDICTABLE>
    13bc:	a6010000 	strge	r0, [r1], -r0
    13c0:	000dbf0a 	andeq	fp, sp, sl, lsl #30
    13c4:	00004d00 	andeq	r4, r0, r0, lsl #26
    13c8:	00862000 	addeq	r2, r6, r0
    13cc:	0000b000 	andeq	fp, r0, r0
    13d0:	099c0100 	ldmibeq	ip, {r8}
    13d4:	24000009 	strcs	r0, [r0], #-9
    13d8:	00001b4f 	andeq	r1, r0, pc, asr #22
    13dc:	7b1ba601 	blvc	6eabe8 <__bss_end+0x6e129c>
    13e0:	03000003 	movweq	r0, #3
    13e4:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 13ec <shift+0x13ec>
    13e8:	00000e54 	andeq	r0, r0, r4, asr lr
    13ec:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    13f0:	03000000 	movweq	r0, #0
    13f4:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    13f8:	00000da7 	andeq	r0, r0, r7, lsr #27
    13fc:	090aa801 	stmdbeq	sl, {r0, fp, sp, pc}
    1400:	03000009 	movweq	r0, #9
    1404:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1408:	00000c4d 	andeq	r0, r0, sp, asr #24
    140c:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    1410:	02000000 	andeq	r0, r0, #0
    1414:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1418:	00000025 	andeq	r0, r0, r5, lsr #32
    141c:	00000919 	andeq	r0, r0, r9, lsl r9
    1420:	00005e17 	andeq	r5, r0, r7, lsl lr
    1424:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1428:	00000e2a 	andeq	r0, r0, sl, lsr #28
    142c:	9d0a9801 	stcls	8, cr9, [sl, #-4]
    1430:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    1434:	e4000000 	str	r0, [r0], #-0
    1438:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    143c:	01000000 	mrseq	r0, (UNDEF: 0)
    1440:	0009569c 	muleq	r9, ip, r6
    1444:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1448:	9a010071 	bls	41614 <__bss_end+0x37cc8>
    144c:	00055720 	andeq	r5, r5, r0, lsr #14
    1450:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1454:	000db422 	andeq	fp, sp, r2, lsr #8
    1458:	0e9b0100 	fmleqe	f0, f3, f0
    145c:	0000004d 	andeq	r0, r0, sp, asr #32
    1460:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1464:	000d3e27 	andeq	r3, sp, r7, lsr #28
    1468:	068f0100 	streq	r0, [pc], r0, lsl #2
    146c:	00000c6e 	andeq	r0, r0, lr, ror #24
    1470:	000085a8 	andeq	r8, r0, r8, lsr #11
    1474:	0000003c 	andeq	r0, r0, ip, lsr r0
    1478:	098f9c01 	stmibeq	pc, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
    147c:	dc240000 	stcle	0, cr0, [r4], #-0
    1480:	0100000c 	tsteq	r0, ip
    1484:	004d218f 	subeq	r2, sp, pc, lsl #3
    1488:	91020000 	mrsls	r0, (UNDEF: 2)
    148c:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1490:	91010071 	tstls	r1, r1, ror r0
    1494:	00055720 	andeq	r5, r5, r0, lsr #14
    1498:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    149c:	0de02500 	cfstr64eq	mvdx2, [r0]
    14a0:	83010000 	movwhi	r0, #4096	; 0x1000
    14a4:	000d0c0a 	andeq	r0, sp, sl, lsl #24
    14a8:	00004d00 	andeq	r4, r0, r0, lsl #26
    14ac:	00856c00 	addeq	r6, r5, r0, lsl #24
    14b0:	00003c00 	andeq	r3, r0, r0, lsl #24
    14b4:	cc9c0100 	ldfgts	f0, [ip], {0}
    14b8:	26000009 	strcs	r0, [r0], -r9
    14bc:	00716572 	rsbseq	r6, r1, r2, ror r5
    14c0:	33208501 			; <UNDEFINED> instruction: 0x33208501
    14c4:	02000005 	andeq	r0, r0, #5
    14c8:	46227491 			; <UNDEFINED> instruction: 0x46227491
    14cc:	0100000c 	tsteq	r0, ip
    14d0:	004d0e86 	subeq	r0, sp, r6, lsl #29
    14d4:	91020000 	mrsls	r0, (UNDEF: 2)
    14d8:	3b250070 	blcc	9416a0 <__bss_end+0x937d54>
    14dc:	0100000f 	tsteq	r0, pc
    14e0:	0cb20a77 	vldmiaeq	r2!, {s0-s118}
    14e4:	004d0000 	subeq	r0, sp, r0
    14e8:	85300000 	ldrhi	r0, [r0, #-0]!
    14ec:	003c0000 	eorseq	r0, ip, r0
    14f0:	9c010000 	stcls	0, cr0, [r1], {-0}
    14f4:	00000a09 	andeq	r0, r0, r9, lsl #20
    14f8:	71657226 	cmnvc	r5, r6, lsr #4
    14fc:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1500:	00000533 	andeq	r0, r0, r3, lsr r5
    1504:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1508:	00000c46 	andeq	r0, r0, r6, asr #24
    150c:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    1510:	02000000 	andeq	r0, r0, #0
    1514:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1518:	00000d20 	andeq	r0, r0, r0, lsr #26
    151c:	68066b01 	stmdavs	r6, {r0, r8, r9, fp, sp, lr}
    1520:	6e00000e 	cdpvs	0, 0, cr0, cr0, cr14, {0}
    1524:	dc000003 	stcle	0, cr0, [r0], {3}
    1528:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
    152c:	01000000 	mrseq	r0, (UNDEF: 0)
    1530:	000a559c 	muleq	sl, ip, r5
    1534:	0db42400 	cfldrseq	mvf2, [r4]
    1538:	6b010000 	blvs	41540 <__bss_end+0x37bf4>
    153c:	00004d15 	andeq	r4, r0, r5, lsl sp
    1540:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1544:	00040124 	andeq	r0, r4, r4, lsr #2
    1548:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    154c:	0000004d 	andeq	r0, r0, sp, asr #32
    1550:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1554:	00000f33 	andeq	r0, r0, r3, lsr pc
    1558:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    155c:	02000000 	andeq	r0, r0, #0
    1560:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1564:	00000c85 	andeq	r0, r0, r5, lsl #25
    1568:	d4125e01 	ldrle	r5, [r2], #-3585	; 0xfffff1ff
    156c:	8b00000e 	blhi	15ac <shift+0x15ac>
    1570:	8c000000 	stchi	0, cr0, [r0], {-0}
    1574:	50000084 	andpl	r0, r0, r4, lsl #1
    1578:	01000000 	mrseq	r0, (UNDEF: 0)
    157c:	000ab09c 	muleq	sl, ip, r0
    1580:	0e732400 	cdpeq	4, 7, cr2, cr3, cr0, {0}
    1584:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1588:	00004d20 	andeq	r4, r0, r0, lsr #26
    158c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1590:	000de924 	andeq	lr, sp, r4, lsr #18
    1594:	2f5e0100 	svccs	0x005e0100
    1598:	0000004d 	andeq	r0, r0, sp, asr #32
    159c:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    15a0:	00000401 	andeq	r0, r0, r1, lsl #8
    15a4:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 15a8 <shift+0x15a8>
    15a8:	02000000 	andeq	r0, r0, #0
    15ac:	33226491 			; <UNDEFINED> instruction: 0x33226491
    15b0:	0100000f 	tsteq	r0, pc
    15b4:	008b1660 	addeq	r1, fp, r0, ror #12
    15b8:	91020000 	mrsls	r0, (UNDEF: 2)
    15bc:	ad250074 	stcge	0, cr0, [r5, #-464]!	; 0xfffffe30
    15c0:	0100000d 	tsteq	r0, sp
    15c4:	0c8a0a52 	vstmiaeq	sl, {s0-s81}
    15c8:	004d0000 	subeq	r0, sp, r0
    15cc:	84480000 	strbhi	r0, [r8], #-0
    15d0:	00440000 	subeq	r0, r4, r0
    15d4:	9c010000 	stcls	0, cr0, [r1], {-0}
    15d8:	00000afc 	strdeq	r0, [r0], -ip
    15dc:	000e7324 	andeq	r7, lr, r4, lsr #6
    15e0:	1a520100 	bne	14819e8 <__bss_end+0x147809c>
    15e4:	0000004d 	andeq	r0, r0, sp, asr #32
    15e8:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    15ec:	00000de9 	andeq	r0, r0, r9, ror #27
    15f0:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    15f4:	02000000 	andeq	r0, r0, #0
    15f8:	03226891 			; <UNDEFINED> instruction: 0x03226891
    15fc:	0100000f 	tsteq	r0, pc
    1600:	004d0e54 	subeq	r0, sp, r4, asr lr
    1604:	91020000 	mrsls	r0, (UNDEF: 2)
    1608:	fd250074 	stc2	0, cr0, [r5, #-464]!	; 0xfffffe30
    160c:	0100000e 	tsteq	r0, lr
    1610:	0edf0a45 	vfnmaeq.f32	s1, s30, s10
    1614:	004d0000 	subeq	r0, sp, r0
    1618:	83f80000 	mvnshi	r0, #0
    161c:	00500000 	subseq	r0, r0, r0
    1620:	9c010000 	stcls	0, cr0, [r1], {-0}
    1624:	00000b57 	andeq	r0, r0, r7, asr fp
    1628:	000e7324 	andeq	r7, lr, r4, lsr #6
    162c:	19450100 	stmdbne	r5, {r8}^
    1630:	0000004d 	andeq	r0, r0, sp, asr #32
    1634:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1638:	00000d50 	andeq	r0, r0, r0, asr sp
    163c:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1640:	02000001 	andeq	r0, r0, #1
    1644:	16246891 			; <UNDEFINED> instruction: 0x16246891
    1648:	0100000e 	tsteq	r0, lr
    164c:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1650:	91020000 	mrsls	r0, (UNDEF: 2)
    1654:	0f332264 	svceq	0x00332264
    1658:	47010000 	strmi	r0, [r1, -r0]
    165c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1660:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1664:	0c332700 	ldceq	7, cr2, [r3], #-0
    1668:	3f010000 	svccc	0x00010000
    166c:	000d5a06 	andeq	r5, sp, r6, lsl #20
    1670:	0083cc00 	addeq	ip, r3, r0, lsl #24
    1674:	00002c00 	andeq	r2, r0, r0, lsl #24
    1678:	819c0100 	orrshi	r0, ip, r0, lsl #2
    167c:	2400000b 	strcs	r0, [r0], #-11
    1680:	00000e73 	andeq	r0, r0, r3, ror lr
    1684:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1688:	02000000 	andeq	r0, r0, #0
    168c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1690:	00000e4e 	andeq	r0, r0, lr, asr #28
    1694:	1c0a3201 	sfmne	f3, 4, [sl], {1}
    1698:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    169c:	7c000000 	stcvc	0, cr0, [r0], {-0}
    16a0:	50000083 	andpl	r0, r0, r3, lsl #1
    16a4:	01000000 	mrseq	r0, (UNDEF: 0)
    16a8:	000bdc9c 	muleq	fp, ip, ip
    16ac:	0e732400 	cdpeq	4, 7, cr2, cr3, cr0, {0}
    16b0:	32010000 	andcc	r0, r1, #0
    16b4:	00004d19 	andeq	r4, r0, r9, lsl sp
    16b8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    16bc:	000f0f24 	andeq	r0, pc, r4, lsr #30
    16c0:	2b320100 	blcs	c81ac8 <__bss_end+0xc7817c>
    16c4:	0000037b 	andeq	r0, r0, fp, ror r3
    16c8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    16cc:	00000e58 	andeq	r0, r0, r8, asr lr
    16d0:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    16d4:	02000000 	andeq	r0, r0, #0
    16d8:	ce226491 	mcrgt	4, 1, r6, cr2, cr1, {4}
    16dc:	0100000e 	tsteq	r0, lr
    16e0:	004d0e34 	subeq	r0, sp, r4, lsr lr
    16e4:	91020000 	mrsls	r0, (UNDEF: 2)
    16e8:	5d250074 	stcpl	0, cr0, [r5, #-464]!	; 0xfffffe30
    16ec:	0100000f 	tsteq	r0, pc
    16f0:	0f160a25 	svceq	0x00160a25
    16f4:	004d0000 	subeq	r0, sp, r0
    16f8:	832c0000 			; <UNDEFINED> instruction: 0x832c0000
    16fc:	00500000 	subseq	r0, r0, r0
    1700:	9c010000 	stcls	0, cr0, [r1], {-0}
    1704:	00000c37 	andeq	r0, r0, r7, lsr ip
    1708:	000e7324 	andeq	r7, lr, r4, lsr #6
    170c:	18250100 	stmdane	r5!, {r8}
    1710:	0000004d 	andeq	r0, r0, sp, asr #32
    1714:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1718:	00000f0f 	andeq	r0, r0, pc, lsl #30
    171c:	3d2a2501 	cfstr32cc	mvfx2, [sl, #-4]!
    1720:	0200000c 	andeq	r0, r0, #12
    1724:	58246891 	stmdapl	r4!, {r0, r4, r7, fp, sp, lr}
    1728:	0100000e 	tsteq	r0, lr
    172c:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1730:	91020000 	mrsls	r0, (UNDEF: 2)
    1734:	0c572264 	lfmeq	f2, 2, [r7], {100}	; 0x64
    1738:	27010000 	strcs	r0, [r1, -r0]
    173c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1740:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1744:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1748:	03000000 	movweq	r0, #0
    174c:	00000c37 	andeq	r0, r0, r7, lsr ip
    1750:	000dba25 	andeq	fp, sp, r5, lsr #20
    1754:	0a190100 	beq	641b5c <__bss_end+0x638210>
    1758:	00000f73 	andeq	r0, r0, r3, ror pc
    175c:	0000004d 	andeq	r0, r0, sp, asr #32
    1760:	000082e8 	andeq	r8, r0, r8, ror #5
    1764:	00000044 	andeq	r0, r0, r4, asr #32
    1768:	0c8e9c01 	stceq	12, cr9, [lr], {1}
    176c:	54240000 	strtpl	r0, [r4], #-0
    1770:	0100000f 	tsteq	r0, pc
    1774:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1778:	91020000 	mrsls	r0, (UNDEF: 2)
    177c:	0f0a246c 	svceq	0x000a246c
    1780:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1784:	0001c635 	andeq	ip, r1, r5, lsr r6
    1788:	68910200 	ldmvs	r1, {r9}
    178c:	000e7322 	andeq	r7, lr, r2, lsr #6
    1790:	0e1b0100 	mufeqe	f0, f3, f0
    1794:	0000004d 	andeq	r0, r0, sp, asr #32
    1798:	00749102 	rsbseq	r9, r4, r2, lsl #2
    179c:	000cd028 	andeq	sp, ip, r8, lsr #32
    17a0:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    17a4:	00000c5d 	andeq	r0, r0, sp, asr ip
    17a8:	000082cc 	andeq	r8, r0, ip, asr #5
    17ac:	0000001c 	andeq	r0, r0, ip, lsl r0
    17b0:	62279c01 	eorvs	r9, r7, #256	; 0x100
    17b4:	0100000f 	tsteq	r0, pc
    17b8:	0c96060e 	ldceq	6, cr0, [r6], {14}
    17bc:	82a00000 	adchi	r0, r0, #0
    17c0:	002c0000 	eoreq	r0, ip, r0
    17c4:	9c010000 	stcls	0, cr0, [r1], {-0}
    17c8:	00000cce 	andeq	r0, r0, lr, asr #25
    17cc:	000ca924 	andeq	sl, ip, r4, lsr #18
    17d0:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    17d4:	00000038 	andeq	r0, r0, r8, lsr r0
    17d8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17dc:	000f6c29 	andeq	r6, pc, r9, lsr #24
    17e0:	0a040100 	beq	101be8 <__bss_end+0xf829c>
    17e4:	00000d9c 	muleq	r0, ip, sp
    17e8:	0000004d 	andeq	r0, r0, sp, asr #32
    17ec:	00008274 	andeq	r8, r0, r4, ror r2
    17f0:	0000002c 	andeq	r0, r0, ip, lsr #32
    17f4:	70269c01 	eorvc	r9, r6, r1, lsl #24
    17f8:	01006469 	tsteq	r0, r9, ror #8
    17fc:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1800:	91020000 	mrsls	r0, (UNDEF: 2)
    1804:	f9000074 			; <UNDEFINED> instruction: 0xf9000074
    1808:	04000006 	streq	r0, [r0], #-6
    180c:	0006a200 	andeq	sl, r6, r0, lsl #4
    1810:	8f010400 	svchi	0x00010400
    1814:	0400000f 	streq	r0, [r0], #-15
    1818:	00001072 	andeq	r1, r0, r2, ror r0
    181c:	00000def 	andeq	r0, r0, pc, ror #27
    1820:	000086d0 	ldrdeq	r8, [r0], -r0
    1824:	00000fdc 	ldrdeq	r0, [r0], -ip
    1828:	00000645 	andeq	r0, r0, r5, asr #12
    182c:	000e4502 	andeq	r4, lr, r2, lsl #10
    1830:	11040200 	mrsne	r0, R12_usr
    1834:	0000003e 	andeq	r0, r0, lr, lsr r0
    1838:	99240305 	stmdbls	r4!, {r0, r2, r8, r9}
    183c:	04030000 	streq	r0, [r3], #-0
    1840:	0015a904 	andseq	sl, r5, r4, lsl #18
    1844:	00370400 	eorseq	r0, r7, r0, lsl #8
    1848:	67050000 	strvs	r0, [r5, -r0]
    184c:	06000000 	streq	r0, [r0], -r0
    1850:	000011b2 			; <UNDEFINED> instruction: 0x000011b2
    1854:	7f100501 	svcvc	0x00100501
    1858:	11000000 	mrsne	r0, (UNDEF: 0)
    185c:	33323130 	teqcc	r2, #48, 2
    1860:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1864:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1868:	46454443 	strbmi	r4, [r5], -r3, asr #8
    186c:	01070000 	mrseq	r0, (UNDEF: 7)
    1870:	00430103 	subeq	r0, r3, r3, lsl #2
    1874:	97080000 	strls	r0, [r8, -r0]
    1878:	7f000000 	svcvc	0x00000000
    187c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1880:	00000084 	andeq	r0, r0, r4, lsl #1
    1884:	6f040010 	svcvs	0x00040010
    1888:	03000000 	movweq	r0, #0
    188c:	17df0704 	ldrbne	r0, [pc, r4, lsl #14]
    1890:	84040000 	strhi	r0, [r4], #-0
    1894:	03000000 	movweq	r0, #0
    1898:	07330801 	ldreq	r0, [r3, -r1, lsl #16]!
    189c:	90040000 	andls	r0, r4, r0
    18a0:	0a000000 	beq	18a8 <shift+0x18a8>
    18a4:	00000048 	andeq	r0, r0, r8, asr #32
    18a8:	0011a60b 	andseq	sl, r1, fp, lsl #12
    18ac:	07fc0100 	ldrbeq	r0, [ip, r0, lsl #2]!
    18b0:	0000111d 	andeq	r1, r0, sp, lsl r1
    18b4:	00000037 	andeq	r0, r0, r7, lsr r0
    18b8:	0000959c 	muleq	r0, ip, r5
    18bc:	00000110 	andeq	r0, r0, r0, lsl r1
    18c0:	011d9c01 	tsteq	sp, r1, lsl #24
    18c4:	730c0000 	movwvc	r0, #49152	; 0xc000
    18c8:	18fc0100 	ldmne	ip!, {r8}^
    18cc:	0000011d 	andeq	r0, r0, sp, lsl r1
    18d0:	0d649102 	stfeqp	f1, [r4, #-8]!
    18d4:	007a6572 	rsbseq	r6, sl, r2, ror r5
    18d8:	3709fe01 	strcc	pc, [r9, -r1, lsl #28]
    18dc:	02000000 	andeq	r0, r0, #0
    18e0:	400e7491 	mulmi	lr, r1, r4
    18e4:	01000012 	tsteq	r0, r2, lsl r0
    18e8:	003712fe 	ldrshteq	r1, [r7], -lr
    18ec:	91020000 	mrsls	r0, (UNDEF: 2)
    18f0:	95e00f70 	strbls	r0, [r0, #3952]!	; 0xf70
    18f4:	00a80000 	adceq	r0, r8, r0
    18f8:	e4100000 	ldr	r0, [r0], #-0
    18fc:	01000010 	tsteq	r0, r0, lsl r0
    1900:	230c0103 	movwcs	r0, #49411	; 0xc103
    1904:	02000001 	andeq	r0, r0, #1
    1908:	f80f6c91 			; <UNDEFINED> instruction: 0xf80f6c91
    190c:	80000095 	mulhi	r0, r5, r0
    1910:	11000000 	mrsne	r0, (UNDEF: 0)
    1914:	08010064 	stmdaeq	r1, {r2, r5, r6}
    1918:	01230901 			; <UNDEFINED> instruction: 0x01230901
    191c:	91020000 	mrsls	r0, (UNDEF: 2)
    1920:	00000068 	andeq	r0, r0, r8, rrx
    1924:	00970412 	addseq	r0, r7, r2, lsl r4
    1928:	04130000 	ldreq	r0, [r3], #-0
    192c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1930:	11be1400 			; <UNDEFINED> instruction: 0x11be1400
    1934:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1938:	00122806 	andseq	r2, r2, r6, lsl #16
    193c:	00927800 	addseq	r7, r2, r0, lsl #16
    1940:	00032400 	andeq	r2, r3, r0, lsl #8
    1944:	299c0100 	ldmibcs	ip, {r8}
    1948:	0c000002 	stceq	0, cr0, [r0], {2}
    194c:	c1010078 	tstgt	r1, r8, ror r0
    1950:	00003711 	andeq	r3, r0, r1, lsl r7
    1954:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    1958:	66620c7f 			; <UNDEFINED> instruction: 0x66620c7f
    195c:	c1010072 	tstgt	r1, r2, ror r0
    1960:	0002291a 	andeq	r2, r2, sl, lsl r9
    1964:	a0910300 	addsge	r0, r1, r0, lsl #6
    1968:	10f6157f 	rscsne	r1, r6, pc, ror r5
    196c:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1970:	00008b32 	andeq	r8, r0, r2, lsr fp
    1974:	9c910300 	ldcls	3, cr0, [r1], {0}
    1978:	12010e7f 	andne	r0, r1, #2032	; 0x7f0
    197c:	c3010000 	movwgt	r0, #4096	; 0x1000
    1980:	0000840f 	andeq	r8, r0, pc, lsl #8
    1984:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1988:	0011ea0e 	andseq	lr, r1, lr, lsl #20
    198c:	06d90100 	ldrbeq	r0, [r9], r0, lsl #2
    1990:	00000123 	andeq	r0, r0, r3, lsr #2
    1994:	0e709102 	expeqs	f1, f2
    1998:	000010ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    199c:	3e11dd01 	cdpcc	13, 1, cr13, cr1, cr1, {0}
    19a0:	02000000 	andeq	r0, r0, #0
    19a4:	bc0e6491 	cfstrslt	mvf6, [lr], {145}	; 0x91
    19a8:	01000010 	tsteq	r0, r0, lsl r0
    19ac:	008b18e0 	addeq	r1, fp, r0, ror #17
    19b0:	91020000 	mrsls	r0, (UNDEF: 2)
    19b4:	10cb0e60 	sbcne	r0, fp, r0, ror #28
    19b8:	e1010000 	mrs	r0, (UNDEF: 1)
    19bc:	00008b18 	andeq	r8, r0, r8, lsl fp
    19c0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    19c4:	0011710e 	andseq	r7, r1, lr, lsl #2
    19c8:	07e30100 	strbeq	r0, [r3, r0, lsl #2]!
    19cc:	0000022f 	andeq	r0, r0, pc, lsr #4
    19d0:	7fb89103 	svcvc	0x00b89103
    19d4:	0011050e 	andseq	r0, r1, lr, lsl #10
    19d8:	06e50100 	strbteq	r0, [r5], r0, lsl #2
    19dc:	00000123 	andeq	r0, r0, r3, lsr #2
    19e0:	16589102 	ldrbne	r9, [r8], -r2, lsl #2
    19e4:	00009484 	andeq	r9, r0, r4, lsl #9
    19e8:	00000050 	andeq	r0, r0, r0, asr r0
    19ec:	000001f7 	strdeq	r0, [r0], -r7
    19f0:	0100690d 	tsteq	r0, sp, lsl #18
    19f4:	01230be7 	smulwteq	r3, r7, fp
    19f8:	91020000 	mrsls	r0, (UNDEF: 2)
    19fc:	e00f006c 	and	r0, pc, ip, rrx
    1a00:	98000094 	stmdals	r0, {r2, r4, r7}
    1a04:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1a08:	000010ef 	andeq	r1, r0, pc, ror #1
    1a0c:	3f08ef01 	svccc	0x0008ef01
    1a10:	03000002 	movweq	r0, #2
    1a14:	0f7fac91 	svceq	0x007fac91
    1a18:	00009510 	andeq	r9, r0, r0, lsl r5
    1a1c:	00000068 	andeq	r0, r0, r8, rrx
    1a20:	0100690d 	tsteq	r0, sp, lsl #18
    1a24:	01230cf2 	strdeq	r0, [r3, -r2]!
    1a28:	91020000 	mrsls	r0, (UNDEF: 2)
    1a2c:	00000068 	andeq	r0, r0, r8, rrx
    1a30:	00900412 	addseq	r0, r0, r2, lsl r4
    1a34:	90080000 	andls	r0, r8, r0
    1a38:	3f000000 	svccc	0x00000000
    1a3c:	09000002 	stmdbeq	r0, {r1}
    1a40:	00000084 	andeq	r0, r0, r4, lsl #1
    1a44:	9008001f 	andls	r0, r8, pc, lsl r0
    1a48:	4f000000 	svcmi	0x00000000
    1a4c:	09000002 	stmdbeq	r0, {r1}
    1a50:	00000084 	andeq	r0, r0, r4, lsl #1
    1a54:	be140008 	cdplt	0, 1, cr0, cr4, cr8, {0}
    1a58:	01000011 	tsteq	r0, r1, lsl r0
    1a5c:	128d06bb 	addne	r0, sp, #196083712	; 0xbb00000
    1a60:	92480000 	subls	r0, r8, #0
    1a64:	00300000 	eorseq	r0, r0, r0
    1a68:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a6c:	00000286 	andeq	r0, r0, r6, lsl #5
    1a70:	0100780c 	tsteq	r0, ip, lsl #16
    1a74:	003711bb 	ldrhteq	r1, [r7], -fp
    1a78:	91020000 	mrsls	r0, (UNDEF: 2)
    1a7c:	66620c74 			; <UNDEFINED> instruction: 0x66620c74
    1a80:	bb010072 	bllt	41c50 <__bss_end+0x38304>
    1a84:	0002291a 	andeq	r2, r2, sl, lsl r9
    1a88:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a8c:	10c50b00 	sbcne	r0, r5, r0, lsl #22
    1a90:	b5010000 	strlt	r0, [r1, #-0]
    1a94:	00117c06 	andseq	r7, r1, r6, lsl #24
    1a98:	0002b200 	andeq	fp, r2, r0, lsl #4
    1a9c:	00920800 	addseq	r0, r2, r0, lsl #16
    1aa0:	00004000 	andeq	r4, r0, r0
    1aa4:	b29c0100 	addslt	r0, ip, #0, 2
    1aa8:	0c000002 	stceq	0, cr0, [r0], {2}
    1aac:	b5010078 	strlt	r0, [r1, #-120]	; 0xffffff88
    1ab0:	00003712 	andeq	r3, r0, r2, lsl r7
    1ab4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ab8:	02010300 	andeq	r0, r1, #0, 6
    1abc:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
    1ac0:	0010b60b 	andseq	fp, r0, fp, lsl #12
    1ac4:	06b00100 	ldrteq	r0, [r0], r0, lsl #2
    1ac8:	00001139 	andeq	r1, r0, r9, lsr r1
    1acc:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    1ad0:	000091cc 	andeq	r9, r0, ip, asr #3
    1ad4:	0000003c 	andeq	r0, r0, ip, lsr r0
    1ad8:	02e59c01 	rsceq	r9, r5, #256	; 0x100
    1adc:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    1ae0:	12b00100 	adcsne	r0, r0, #0, 2
    1ae4:	00000037 	andeq	r0, r0, r7, lsr r0
    1ae8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1aec:	00127514 	andseq	r7, r2, r4, lsl r5
    1af0:	06a50100 	strteq	r0, [r5], r0, lsl #2
    1af4:	000011c3 	andeq	r1, r0, r3, asr #3
    1af8:	000090f8 	strdeq	r9, [r0], -r8
    1afc:	000000d4 	ldrdeq	r0, [r0], -r4
    1b00:	033a9c01 	teqeq	sl, #256	; 0x100
    1b04:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    1b08:	2ba50100 	blcs	fe941f10 <__bss_end+0xfe9385c4>
    1b0c:	00000084 	andeq	r0, r0, r4, lsl #1
    1b10:	0c6c9102 	stfeqp	f1, [ip], #-8
    1b14:	00726662 	rsbseq	r6, r2, r2, ror #12
    1b18:	2934a501 	ldmdbcs	r4!, {r0, r8, sl, sp, pc}
    1b1c:	02000002 	andeq	r0, r0, #2
    1b20:	0f156891 	svceq	0x00156891
    1b24:	01000012 	tsteq	r0, r2, lsl r0
    1b28:	01233da5 			; <UNDEFINED> instruction: 0x01233da5
    1b2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1b30:	12010e64 	andne	r0, r1, #100, 28	; 0x640
    1b34:	a7010000 	strge	r0, [r1, -r0]
    1b38:	00012306 	andeq	r2, r1, r6, lsl #6
    1b3c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b40:	12341700 	eorsne	r1, r4, #0, 14
    1b44:	83010000 	movwhi	r0, #4096	; 0x1000
    1b48:	00118f06 	andseq	r8, r1, r6, lsl #30
    1b4c:	008cb800 	addeq	fp, ip, r0, lsl #16
    1b50:	00044000 	andeq	r4, r4, r0
    1b54:	9e9c0100 	fmllse	f0, f4, f0
    1b58:	0c000003 	stceq	0, cr0, [r0], {3}
    1b5c:	83010078 	movwhi	r0, #4216	; 0x1078
    1b60:	00003718 	andeq	r3, r0, r8, lsl r7
    1b64:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b68:	0010bc15 	andseq	fp, r0, r5, lsl ip
    1b6c:	29830100 	stmibcs	r3, {r8}
    1b70:	0000039e 	muleq	r0, lr, r3
    1b74:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    1b78:	000010cb 	andeq	r1, r0, fp, asr #1
    1b7c:	9e418301 	cdpls	3, 4, cr8, cr1, cr1, {0}
    1b80:	02000003 	andeq	r0, r0, #3
    1b84:	14156491 	ldrne	r6, [r5], #-1169	; 0xfffffb6f
    1b88:	01000011 	tsteq	r0, r1, lsl r0
    1b8c:	03a44f83 			; <UNDEFINED> instruction: 0x03a44f83
    1b90:	91020000 	mrsls	r0, (UNDEF: 2)
    1b94:	10ac0e60 	adcne	r0, ip, r0, ror #28
    1b98:	96010000 	strls	r0, [r1], -r0
    1b9c:	0000370b 	andeq	r3, r0, fp, lsl #14
    1ba0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ba4:	84041800 	strhi	r1, [r4], #-2048	; 0xfffff800
    1ba8:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1bac:	00012304 	andeq	r2, r1, r4, lsl #6
    1bb0:	12ad1400 	adcne	r1, sp, #0, 8
    1bb4:	76010000 	strvc	r0, [r1], -r0
    1bb8:	00112d06 	andseq	r2, r1, r6, lsl #26
    1bbc:	008bf400 	addeq	pc, fp, r0, lsl #8
    1bc0:	0000c400 	andeq	ip, r0, r0, lsl #8
    1bc4:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
    1bc8:	15000003 	strne	r0, [r0, #-3]
    1bcc:	0000116c 	andeq	r1, r0, ip, ror #2
    1bd0:	29137601 	ldmdbcs	r3, {r0, r9, sl, ip, sp, lr}
    1bd4:	02000002 	andeq	r0, r0, #2
    1bd8:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    1bdc:	09780100 	ldmdbeq	r8!, {r8}^
    1be0:	00000123 	andeq	r0, r0, r3, lsr #2
    1be4:	0d749102 	ldfeqp	f1, [r4, #-8]!
    1be8:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1bec:	230c7801 	movwcs	r7, #51201	; 0xc801
    1bf0:	02000001 	andeq	r0, r0, #1
    1bf4:	4e0e7091 	mcrmi	0, 0, r7, cr14, cr1, {4}
    1bf8:	01000011 	tsteq	r0, r1, lsl r0
    1bfc:	01231178 			; <UNDEFINED> instruction: 0x01231178
    1c00:	91020000 	mrsls	r0, (UNDEF: 2)
    1c04:	7019006c 	andsvc	r0, r9, ip, rrx
    1c08:	0100776f 	tsteq	r0, pc, ror #14
    1c0c:	1186076d 	orrne	r0, r6, sp, ror #14
    1c10:	00370000 	eorseq	r0, r7, r0
    1c14:	8b880000 	blhi	fe201c1c <__bss_end+0xfe1f82d0>
    1c18:	006c0000 	rsbeq	r0, ip, r0
    1c1c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c20:	0000045c 	andeq	r0, r0, ip, asr r4
    1c24:	0100780c 	tsteq	r0, ip, lsl #16
    1c28:	003e176d 	eorseq	r1, lr, sp, ror #14
    1c2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c30:	006e0c6c 	rsbeq	r0, lr, ip, ror #24
    1c34:	8b2d6d01 	blhi	b5d040 <__bss_end+0xb536f4>
    1c38:	02000000 	andeq	r0, r0, #0
    1c3c:	720d6891 	andvc	r6, sp, #9502720	; 0x910000
    1c40:	0b6f0100 	bleq	1bc2048 <__bss_end+0x1bb86fc>
    1c44:	00000037 	andeq	r0, r0, r7, lsr r0
    1c48:	0f749102 	svceq	0x00749102
    1c4c:	00008ba4 	andeq	r8, r0, r4, lsr #23
    1c50:	00000038 	andeq	r0, r0, r8, lsr r0
    1c54:	0100690d 	tsteq	r0, sp, lsl #18
    1c58:	00841670 	addeq	r1, r4, r0, ror r6
    1c5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c60:	17000070 	smlsdxne	r0, r0, r0, r0
    1c64:	000011fa 	strdeq	r1, [r0], -sl
    1c68:	62066401 	andvs	r6, r6, #16777216	; 0x1000000
    1c6c:	08000010 	stmdaeq	r0, {r4}
    1c70:	8000008b 	andhi	r0, r0, fp, lsl #1
    1c74:	01000000 	mrseq	r0, (UNDEF: 0)
    1c78:	0004d99c 	muleq	r4, ip, r9
    1c7c:	72730c00 	rsbsvc	r0, r3, #0, 24
    1c80:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    1c84:	0004d919 	andeq	sp, r4, r9, lsl r9
    1c88:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c8c:	7473640c 	ldrbtvc	r6, [r3], #-1036	; 0xfffffbf4
    1c90:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1c94:	000004e0 	andeq	r0, r0, r0, ror #9
    1c98:	0c609102 	stfeqp	f1, [r0], #-8
    1c9c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1ca0:	232d6401 			; <UNDEFINED> instruction: 0x232d6401
    1ca4:	02000001 	andeq	r0, r0, #1
    1ca8:	e30e5c91 	movw	r5, #60561	; 0xec91
    1cac:	01000011 	tsteq	r0, r1, lsl r0
    1cb0:	011d0e66 	tsteq	sp, r6, ror #28
    1cb4:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb8:	11ab0e70 			; <UNDEFINED> instruction: 0x11ab0e70
    1cbc:	67010000 	strvs	r0, [r1, -r0]
    1cc0:	00022908 	andeq	r2, r2, r8, lsl #18
    1cc4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cc8:	008b300f 	addeq	r3, fp, pc
    1ccc:	00004800 	andeq	r4, r0, r0, lsl #16
    1cd0:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1cd4:	230b6901 	movwcs	r6, #47361	; 0xb901
    1cd8:	02000001 	andeq	r0, r0, #1
    1cdc:	00007491 	muleq	r0, r1, r4
    1ce0:	04df0412 	ldrbeq	r0, [pc], #1042	; 1ce8 <shift+0x1ce8>
    1ce4:	1b1a0000 	blne	681cec <__bss_end+0x6783a0>
    1ce8:	11f41704 	mvnsne	r1, r4, lsl #14
    1cec:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1cf0:	00115306 	andseq	r5, r1, r6, lsl #6
    1cf4:	008aa000 	addeq	sl, sl, r0
    1cf8:	00006800 	andeq	r6, r0, r0, lsl #16
    1cfc:	419c0100 	orrsmi	r0, ip, r0, lsl #2
    1d00:	15000005 	strne	r0, [r0, #-5]
    1d04:	00001298 	muleq	r0, r8, r2
    1d08:	e0125c01 	ands	r5, r2, r1, lsl #24
    1d0c:	02000004 	andeq	r0, r0, #4
    1d10:	9f156c91 	svcls	0x00156c91
    1d14:	01000012 	tsteq	r0, r2, lsl r0
    1d18:	01231e5c 			; <UNDEFINED> instruction: 0x01231e5c
    1d1c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d20:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    1d24:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    1d28:	00022908 	andeq	r2, r2, r8, lsl #18
    1d2c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1d30:	008abc0f 	addeq	fp, sl, pc, lsl #24
    1d34:	00003c00 	andeq	r3, r0, r0, lsl #24
    1d38:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1d3c:	230b6001 	movwcs	r6, #45057	; 0xb001
    1d40:	02000001 	andeq	r0, r0, #1
    1d44:	00007491 	muleq	r0, r1, r4
    1d48:	0012a60b 	andseq	sl, r2, fp, lsl #12
    1d4c:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    1d50:	00001245 	andeq	r1, r0, r5, asr #4
    1d54:	00000123 	andeq	r0, r0, r3, lsr #2
    1d58:	00008a4c 	andeq	r8, r0, ip, asr #20
    1d5c:	00000054 	andeq	r0, r0, r4, asr r0
    1d60:	057a9c01 	ldrbeq	r9, [sl, #-3073]!	; 0xfffff3ff
    1d64:	730c0000 	movwvc	r0, #49152	; 0xc000
    1d68:	18520100 	ldmdane	r2, {r8}^
    1d6c:	0000011d 	andeq	r0, r0, sp, lsl r1
    1d70:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1d74:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    1d78:	00012306 	andeq	r2, r1, r6, lsl #6
    1d7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d80:	12070b00 	andne	r0, r7, #0, 22
    1d84:	42010000 	andmi	r0, r1, #0
    1d88:	00125205 	andseq	r5, r2, r5, lsl #4
    1d8c:	00012300 	andeq	r2, r1, r0, lsl #6
    1d90:	0089a000 	addeq	sl, r9, r0
    1d94:	0000ac00 	andeq	sl, r0, r0, lsl #24
    1d98:	e09c0100 	adds	r0, ip, r0, lsl #2
    1d9c:	0c000005 	stceq	0, cr0, [r0], {5}
    1da0:	01003173 	tsteq	r0, r3, ror r1
    1da4:	011d1942 	tsteq	sp, r2, asr #18
    1da8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dac:	32730c6c 	rsbscc	r0, r3, #108, 24	; 0x6c00
    1db0:	29420100 	stmdbcs	r2, {r8}^
    1db4:	0000011d 	andeq	r0, r0, sp, lsl r1
    1db8:	0c689102 	stfeqp	f1, [r8], #-8
    1dbc:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1dc0:	23314201 	teqcs	r1, #268435456	; 0x10000000
    1dc4:	02000001 	andeq	r0, r0, #1
    1dc8:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    1dcc:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    1dd0:	0005e010 	andeq	lr, r5, r0, lsl r0
    1dd4:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1dd8:	0032750d 	eorseq	r7, r2, sp, lsl #10
    1ddc:	e0144401 	ands	r4, r4, r1, lsl #8
    1de0:	02000005 	andeq	r0, r0, #5
    1de4:	03007691 	movweq	r7, #1681	; 0x691
    1de8:	072a0801 	streq	r0, [sl, -r1, lsl #16]!
    1dec:	5f0b0000 	svcpl	0x000b0000
    1df0:	01000011 	tsteq	r0, r1, lsl r0
    1df4:	12640736 	rsbne	r0, r4, #14155776	; 0xd80000
    1df8:	02290000 	eoreq	r0, r9, #0
    1dfc:	88e00000 	stmiahi	r0!, {}^	; <UNPREDICTABLE>
    1e00:	00c00000 	sbceq	r0, r0, r0
    1e04:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e08:	00000640 	andeq	r0, r0, r0, asr #12
    1e0c:	00112815 	andseq	r2, r1, r5, lsl r8
    1e10:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    1e14:	00000229 	andeq	r0, r0, r9, lsr #4
    1e18:	0c6c9102 	stfeqp	f1, [ip], #-8
    1e1c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1e20:	1d273601 	stcne	6, cr3, [r7, #-4]!
    1e24:	02000001 	andeq	r0, r0, #1
    1e28:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    1e2c:	01006d75 	tsteq	r0, r5, ror sp
    1e30:	01233036 			; <UNDEFINED> instruction: 0x01233036
    1e34:	91020000 	mrsls	r0, (UNDEF: 2)
    1e38:	00690d64 	rsbeq	r0, r9, r4, ror #26
    1e3c:	23063801 	movwcs	r3, #26625	; 0x6801
    1e40:	02000001 	andeq	r0, r0, #1
    1e44:	0b007491 	bleq	1f090 <__bss_end+0x15744>
    1e48:	000010df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1e4c:	16052401 	strne	r2, [r5], -r1, lsl #8
    1e50:	23000012 	movwcs	r0, #18
    1e54:	44000001 	strmi	r0, [r0], #-1
    1e58:	9c000088 	stcls	0, cr0, [r0], {136}	; 0x88
    1e5c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e60:	00067d9c 	muleq	r6, ip, sp
    1e64:	11431500 	cmpne	r3, r0, lsl #10
    1e68:	24010000 	strcs	r0, [r1], #-0
    1e6c:	00011d16 	andeq	r1, r1, r6, lsl sp
    1e70:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1e74:	0012210e 	andseq	r2, r2, lr, lsl #2
    1e78:	06260100 	strteq	r0, [r6], -r0, lsl #2
    1e7c:	00000123 	andeq	r0, r0, r3, lsr #2
    1e80:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e84:	0011671c 	andseq	r6, r1, ip, lsl r7
    1e88:	06080100 	streq	r0, [r8], -r0, lsl #2
    1e8c:	000010d3 	ldrdeq	r1, [r0], -r3
    1e90:	000086d0 	ldrdeq	r8, [r0], -r0
    1e94:	00000174 	andeq	r0, r0, r4, ror r1
    1e98:	43159c01 	tstmi	r5, #256	; 0x100
    1e9c:	01000011 	tsteq	r0, r1, lsl r0
    1ea0:	00841808 	addeq	r1, r4, r8, lsl #16
    1ea4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ea8:	12211564 	eorne	r1, r1, #100, 10	; 0x19000000
    1eac:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1eb0:	00022925 	andeq	r2, r2, r5, lsr #18
    1eb4:	60910200 	addsvs	r0, r1, r0, lsl #4
    1eb8:	00114915 	andseq	r4, r1, r5, lsl r9
    1ebc:	3a080100 	bcc	2022c4 <__bss_end+0x1f8978>
    1ec0:	00000084 	andeq	r0, r0, r4, lsl #1
    1ec4:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    1ec8:	0a010069 	beq	42074 <__bss_end+0x38728>
    1ecc:	00012306 	andeq	r2, r1, r6, lsl #6
    1ed0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ed4:	00879c0f 	addeq	r9, r7, pc, lsl #24
    1ed8:	00009800 	andeq	r9, r0, r0, lsl #16
    1edc:	006a0d00 	rsbeq	r0, sl, r0, lsl #26
    1ee0:	230b1c01 	movwcs	r1, #48129	; 0xbc01
    1ee4:	02000001 	andeq	r0, r0, #1
    1ee8:	c40f7091 	strgt	r7, [pc], #-145	; 1ef0 <shift+0x1ef0>
    1eec:	60000087 	andvs	r0, r0, r7, lsl #1
    1ef0:	0d000000 	stceq	0, cr0, [r0, #-0]
    1ef4:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    1ef8:	00009008 	andeq	r9, r0, r8
    1efc:	6f910200 	svcvs	0x00910200
    1f00:	00000000 	andeq	r0, r0, r0
    1f04:	00000022 	andeq	r0, r0, r2, lsr #32
    1f08:	084c0002 	stmdaeq	ip, {r1}^
    1f0c:	01040000 	mrseq	r0, (UNDEF: 4)
    1f10:	00000c87 	andeq	r0, r0, r7, lsl #25
    1f14:	000096ac 	andeq	r9, r0, ip, lsr #13
    1f18:	000098b8 			; <UNDEFINED> instruction: 0x000098b8
    1f1c:	000012b4 			; <UNDEFINED> instruction: 0x000012b4
    1f20:	000012e4 	andeq	r1, r0, r4, ror #5
    1f24:	00000063 	andeq	r0, r0, r3, rrx
    1f28:	00228001 	eoreq	r8, r2, r1
    1f2c:	00020000 	andeq	r0, r2, r0
    1f30:	00000860 	andeq	r0, r0, r0, ror #16
    1f34:	0d040104 	stfeqs	f0, [r4, #-16]
    1f38:	98b80000 	ldmls	r8!, {}	; <UNPREDICTABLE>
    1f3c:	98bc0000 	ldmls	ip!, {}	; <UNPREDICTABLE>
    1f40:	12b40000 	adcsne	r0, r4, #0
    1f44:	12e40000 	rscne	r0, r4, #0
    1f48:	00630000 	rsbeq	r0, r3, r0
    1f4c:	80010000 	andhi	r0, r1, r0
    1f50:	00000932 	andeq	r0, r0, r2, lsr r9
    1f54:	08740004 	ldmdaeq	r4!, {r2}^
    1f58:	01040000 	mrseq	r0, (UNDEF: 4)
    1f5c:	000016b2 			; <UNDEFINED> instruction: 0x000016b2
    1f60:	0016090c 	andseq	r0, r6, ip, lsl #18
    1f64:	0012e400 	andseq	lr, r2, r0, lsl #8
    1f68:	000d6400 	andeq	r6, sp, r0, lsl #8
    1f6c:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    1f70:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1f74:	df070403 	svcle	0x00070403
    1f78:	03000017 	movweq	r0, #23
    1f7c:	031f0508 	tsteq	pc, #8, 10	; 0x2000000
    1f80:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    1f84:	001eb104 	andseq	fp, lr, r4, lsl #2
    1f88:	16640400 	strbtne	r0, [r4], -r0, lsl #8
    1f8c:	2a010000 	bcs	41f94 <__bss_end+0x38648>
    1f90:	00002416 	andeq	r2, r0, r6, lsl r4
    1f94:	1ad30400 	bne	ff4c2f9c <__bss_end+0xff4b9650>
    1f98:	2f010000 	svccs	0x00010000
    1f9c:	00005115 	andeq	r5, r0, r5, lsl r1
    1fa0:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    1fa4:	06000000 	streq	r0, [r0], -r0
    1fa8:	00000039 	andeq	r0, r0, r9, lsr r0
    1fac:	00000066 	andeq	r0, r0, r6, rrx
    1fb0:	00006607 	andeq	r6, r0, r7, lsl #12
    1fb4:	04050000 	streq	r0, [r5], #-0
    1fb8:	0000006c 	andeq	r0, r0, ip, rrx
    1fbc:	22050408 	andcs	r0, r5, #8, 8	; 0x8000000
    1fc0:	36010000 	strcc	r0, [r1], -r0
    1fc4:	0000790f 	andeq	r7, r0, pc, lsl #18
    1fc8:	7f040500 	svcvc	0x00040500
    1fcc:	06000000 	streq	r0, [r0], -r0
    1fd0:	0000001d 	andeq	r0, r0, sp, lsl r0
    1fd4:	00000093 	muleq	r0, r3, r0
    1fd8:	00006607 	andeq	r6, r0, r7, lsl #12
    1fdc:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1fe0:	03000000 	movweq	r0, #0
    1fe4:	072a0801 	streq	r0, [sl, -r1, lsl #16]!
    1fe8:	0b090000 	bleq	241ff0 <__bss_end+0x2386a4>
    1fec:	0100001d 	tsteq	r0, sp, lsl r0
    1ff0:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    1ff4:	33090000 	movwcc	r0, #36864	; 0x9000
    1ff8:	01000022 	tsteq	r0, r2, lsr #32
    1ffc:	006d10be 	strhteq	r1, [sp], #-14
    2000:	01030000 	mrseq	r0, (UNDEF: 3)
    2004:	00072c06 	andeq	r2, r7, r6, lsl #24
    2008:	19f30a00 	ldmibne	r3!, {r9, fp}^
    200c:	01070000 	mrseq	r0, (UNDEF: 7)
    2010:	00000093 	muleq	r0, r3, r0
    2014:	e6061702 	str	r1, [r6], -r2, lsl #14
    2018:	0b000001 	bleq	2024 <shift+0x2024>
    201c:	000014c2 	andeq	r1, r0, r2, asr #9
    2020:	19100b00 	ldmdbne	r0, {r8, r9, fp}
    2024:	0b010000 	bleq	4202c <__bss_end+0x386e0>
    2028:	00001dd6 	ldrdeq	r1, [r0], -r6
    202c:	21470b02 	cmpcs	r7, r2, lsl #22
    2030:	0b030000 	bleq	c2038 <__bss_end+0xb86ec>
    2034:	00001d7a 	andeq	r1, r0, sl, ror sp
    2038:	20500b04 	subscs	r0, r0, r4, lsl #22
    203c:	0b050000 	bleq	142044 <__bss_end+0x1386f8>
    2040:	00001fb4 			; <UNDEFINED> instruction: 0x00001fb4
    2044:	14e30b06 	strbtne	r0, [r3], #2822	; 0xb06
    2048:	0b070000 	bleq	1c2050 <__bss_end+0x1b8704>
    204c:	00002065 	andeq	r2, r0, r5, rrx
    2050:	20730b08 	rsbscs	r0, r3, r8, lsl #22
    2054:	0b090000 	bleq	24205c <__bss_end+0x238710>
    2058:	0000213a 	andeq	r2, r0, sl, lsr r1
    205c:	1cd10b0a 	vldmiane	r1, {d16-d20}
    2060:	0b0b0000 	bleq	2c2068 <__bss_end+0x2b871c>
    2064:	000016a5 	andeq	r1, r0, r5, lsr #13
    2068:	17820b0c 	strne	r0, [r2, ip, lsl #22]
    206c:	0b0d0000 	bleq	342074 <__bss_end+0x338728>
    2070:	00001a37 	andeq	r1, r0, r7, lsr sl
    2074:	1a4d0b0e 	bne	1344cb4 <__bss_end+0x133b368>
    2078:	0b0f0000 	bleq	3c2080 <__bss_end+0x3b8734>
    207c:	0000194a 	andeq	r1, r0, sl, asr #18
    2080:	1d5e0b10 	vldrne	d16, [lr, #-64]	; 0xffffffc0
    2084:	0b110000 	bleq	44208c <__bss_end+0x438740>
    2088:	000019b6 			; <UNDEFINED> instruction: 0x000019b6
    208c:	23cc0b12 	biccs	r0, ip, #18432	; 0x4800
    2090:	0b130000 	bleq	4c2098 <__bss_end+0x4b874c>
    2094:	0000154c 	andeq	r1, r0, ip, asr #10
    2098:	19da0b14 	ldmibne	sl, {r2, r4, r8, r9, fp}^
    209c:	0b150000 	bleq	5420a4 <__bss_end+0x538758>
    20a0:	00001489 	andeq	r1, r0, r9, lsl #9
    20a4:	216a0b16 	cmncs	sl, r6, lsl fp
    20a8:	0b170000 	bleq	5c20b0 <__bss_end+0x5b8764>
    20ac:	0000228c 	andeq	r2, r0, ip, lsl #5
    20b0:	19ff0b18 	ldmibne	pc!, {r3, r4, r8, r9, fp}^	; <UNPREDICTABLE>
    20b4:	0b190000 	bleq	6420bc <__bss_end+0x638770>
    20b8:	00001e48 	andeq	r1, r0, r8, asr #28
    20bc:	21780b1a 	cmncs	r8, sl, lsl fp
    20c0:	0b1b0000 	bleq	6c20c8 <__bss_end+0x6b877c>
    20c4:	000013b8 			; <UNDEFINED> instruction: 0x000013b8
    20c8:	21860b1c 	orrcs	r0, r6, ip, lsl fp
    20cc:	0b1d0000 	bleq	7420d4 <__bss_end+0x738788>
    20d0:	00002194 	muleq	r0, r4, r1
    20d4:	13660b1e 	cmnne	r6, #30720	; 0x7800
    20d8:	0b1f0000 	bleq	7c20e0 <__bss_end+0x7b8794>
    20dc:	000021be 			; <UNDEFINED> instruction: 0x000021be
    20e0:	1ef50b20 			; <UNDEFINED> instruction: 0x1ef50b20
    20e4:	0b210000 	bleq	8420ec <__bss_end+0x8387a0>
    20e8:	00001d30 	andeq	r1, r0, r0, lsr sp
    20ec:	215d0b22 	cmpcs	sp, r2, lsr #22
    20f0:	0b230000 	bleq	8c20f8 <__bss_end+0x8b87ac>
    20f4:	00001c34 	andeq	r1, r0, r4, lsr ip
    20f8:	1b360b24 	blne	d84d90 <__bss_end+0xd7b444>
    20fc:	0b250000 	bleq	942104 <__bss_end+0x9387b8>
    2100:	00001850 	andeq	r1, r0, r0, asr r8
    2104:	1b540b26 	blne	1504da4 <__bss_end+0x14fb458>
    2108:	0b270000 	bleq	9c2110 <__bss_end+0x9b87c4>
    210c:	000018ec 	andeq	r1, r0, ip, ror #17
    2110:	1b640b28 	blne	1904db8 <__bss_end+0x18fb46c>
    2114:	0b290000 	bleq	a4211c <__bss_end+0xa387d0>
    2118:	00001b74 	andeq	r1, r0, r4, ror fp
    211c:	1cb70b2a 	vldmiane	r7!, {d0-d20}
    2120:	0b2b0000 	bleq	ac2128 <__bss_end+0xab87dc>
    2124:	00001add 	ldrdeq	r1, [r0], -sp
    2128:	1f020b2c 	svcne	0x00020b2c
    212c:	0b2d0000 	bleq	b42134 <__bss_end+0xb387e8>
    2130:	00001891 	muleq	r0, r1, r8
    2134:	6f0a002e 	svcvs	0x000a002e
    2138:	0700001a 	smladeq	r0, sl, r0, r0
    213c:	00009301 	andeq	r9, r0, r1, lsl #6
    2140:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    2144:	000003c7 	andeq	r0, r0, r7, asr #7
    2148:	0017a40b 	andseq	sl, r7, fp, lsl #8
    214c:	f60b0000 			; <UNDEFINED> instruction: 0xf60b0000
    2150:	01000013 	tsteq	r0, r3, lsl r0
    2154:	00237a0b 	eoreq	r7, r3, fp, lsl #20
    2158:	0d0b0200 	sfmeq	f0, 4, [fp, #-0]
    215c:	03000022 	movweq	r0, #34	; 0x22
    2160:	0017c40b 	andseq	ip, r7, fp, lsl #8
    2164:	ae0b0400 	cfcpysge	mvf0, mvf11
    2168:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    216c:	00186d0b 	andseq	r6, r8, fp, lsl #26
    2170:	b40b0600 	strlt	r0, [fp], #-1536	; 0xfffffa00
    2174:	07000017 	smladeq	r0, r7, r0, r0
    2178:	0020a10b 	eoreq	sl, r0, fp, lsl #2
    217c:	f20b0800 	vadd.i8	d0, d11, d0
    2180:	09000021 	stmdbeq	r0, {r0, r5}
    2184:	001fd80b 	andseq	sp, pc, fp, lsl #16
    2188:	010b0a00 	tsteq	fp, r0, lsl #20
    218c:	0b000015 	bleq	21e8 <shift+0x21e8>
    2190:	00180e0b 	andseq	r0, r8, fp, lsl #28
    2194:	770b0c00 	strvc	r0, [fp, -r0, lsl #24]
    2198:	0d000014 	stceq	0, cr0, [r0, #-80]	; 0xffffffb0
    219c:	0023af0b 	eoreq	sl, r3, fp, lsl #30
    21a0:	a40b0e00 	strge	r0, [fp], #-3584	; 0xfffff200
    21a4:	0f00001c 	svceq	0x0000001c
    21a8:	0019810b 	andseq	r8, r9, fp, lsl #2
    21ac:	e10b1000 	mrs	r1, (UNDEF: 11)
    21b0:	1100001c 	tstne	r0, ip, lsl r0
    21b4:	0022ce0b 	eoreq	ip, r2, fp, lsl #28
    21b8:	c40b1200 	strgt	r1, [fp], #-512	; 0xfffffe00
    21bc:	13000015 	movwne	r0, #21
    21c0:	0019940b 	andseq	r9, r9, fp, lsl #8
    21c4:	f70b1400 			; <UNDEFINED> instruction: 0xf70b1400
    21c8:	1500001b 	strne	r0, [r0, #-27]	; 0xffffffe5
    21cc:	00178f0b 	andseq	r8, r7, fp, lsl #30
    21d0:	430b1600 	movwmi	r1, #46592	; 0xb600
    21d4:	1700001c 	smladne	r0, ip, r0, r0
    21d8:	001a590b 	andseq	r5, sl, fp, lsl #18
    21dc:	cc0b1800 	stcgt	8, cr1, [fp], {-0}
    21e0:	19000014 	stmdbne	r0, {r2, r4}
    21e4:	0022750b 	eoreq	r7, r2, fp, lsl #10
    21e8:	c30b1a00 	movwgt	r1, #47616	; 0xba00
    21ec:	1b00001b 	blne	2260 <shift+0x2260>
    21f0:	00196b0b 	andseq	r6, r9, fp, lsl #22
    21f4:	a10b1c00 	tstge	fp, r0, lsl #24
    21f8:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
    21fc:	001b0e0b 	andseq	r0, fp, fp, lsl #28
    2200:	fa0b1e00 	blx	2c9a08 <__bss_end+0x2c00bc>
    2204:	1f00001a 	svcne	0x0000001a
    2208:	001f950b 	andseq	r9, pc, fp, lsl #10
    220c:	200b2000 	andcs	r2, fp, r0
    2210:	21000020 	tstcs	r0, r0, lsr #32
    2214:	0022540b 	eoreq	r5, r2, fp, lsl #8
    2218:	9e0b2200 	cdpls	2, 0, cr2, cr11, cr0, {0}
    221c:	23000018 	movwcs	r0, #24
    2220:	001df80b 	andseq	pc, sp, fp, lsl #16
    2224:	ed0b2400 	cfstrs	mvf2, [fp, #-0]
    2228:	2500001f 	strcs	r0, [r0, #-31]	; 0xffffffe1
    222c:	001f110b 	andseq	r1, pc, fp, lsl #2
    2230:	250b2600 	strcs	r2, [fp, #-1536]	; 0xfffffa00
    2234:	2700001f 	smladcs	r0, pc, r0, r0	; <UNPREDICTABLE>
    2238:	001f390b 	andseq	r3, pc, fp, lsl #18
    223c:	4f0b2800 	svcmi	0x000b2800
    2240:	29000016 	stmdbcs	r0, {r1, r2, r4}
    2244:	0015af0b 	andseq	sl, r5, fp, lsl #30
    2248:	d70b2a00 	strle	r2, [fp, -r0, lsl #20]
    224c:	2b000015 	blcs	22a8 <shift+0x22a8>
    2250:	0020ea0b 	eoreq	lr, r0, fp, lsl #20
    2254:	2c0b2c00 	stccs	12, cr2, [fp], {-0}
    2258:	2d000016 	stccs	0, cr0, [r0, #-88]	; 0xffffffa8
    225c:	0020fe0b 	eoreq	pc, r0, fp, lsl #28
    2260:	120b2e00 	andne	r2, fp, #0, 28
    2264:	2f000021 	svccs	0x00000021
    2268:	0021260b 	eoreq	r2, r1, fp, lsl #12
    226c:	200b3000 	andcs	r3, fp, r0
    2270:	31000018 	tstcc	r0, r8, lsl r0
    2274:	0017fa0b 	andseq	pc, r7, fp, lsl #20
    2278:	220b3200 	andcs	r3, fp, #0, 4
    227c:	3300001b 	movwcc	r0, #27
    2280:	001cf40b 	andseq	pc, ip, fp, lsl #8
    2284:	030b3400 	movweq	r3, #46080	; 0xb400
    2288:	35000023 	strcc	r0, [r0, #-35]	; 0xffffffdd
    228c:	0013490b 	andseq	r4, r3, fp, lsl #18
    2290:	200b3600 	andcs	r3, fp, r0, lsl #12
    2294:	37000019 	smladcc	r0, r9, r0, r0
    2298:	0019350b 	andseq	r3, r9, fp, lsl #10
    229c:	840b3800 	strhi	r3, [fp], #-2048	; 0xfffff800
    22a0:	3900001b 	stmdbcc	r0, {r0, r1, r3, r4}
    22a4:	001bae0b 	andseq	sl, fp, fp, lsl #28
    22a8:	2c0b3a00 			; <UNDEFINED> instruction: 0x2c0b3a00
    22ac:	3b000023 	blcc	2340 <shift+0x2340>
    22b0:	001de30b 	andseq	lr, sp, fp, lsl #6
    22b4:	c30b3c00 	movwgt	r3, #48128	; 0xbc00
    22b8:	3d000018 	stccc	0, cr0, [r0, #-96]	; 0xffffffa0
    22bc:	0014080b 	andseq	r0, r4, fp, lsl #16
    22c0:	c60b3e00 	strgt	r3, [fp], -r0, lsl #28
    22c4:	3f000013 	svccc	0x00000013
    22c8:	001d400b 	andseq	r4, sp, fp
    22cc:	640b4000 	strvs	r4, [fp], #-0
    22d0:	4100001e 	tstmi	r0, lr, lsl r0
    22d4:	001f770b 	andseq	r7, pc, fp, lsl #14
    22d8:	990b4200 	stmdbls	fp, {r9, lr}
    22dc:	4300001b 	movwmi	r0, #27
    22e0:	0023650b 	eoreq	r6, r3, fp, lsl #10
    22e4:	0e0b4400 	cfcpyseq	mvf4, mvf11
    22e8:	4500001e 	strmi	r0, [r0, #-30]	; 0xffffffe2
    22ec:	0015f30b 	andseq	pc, r5, fp, lsl #6
    22f0:	740b4600 	strvc	r4, [fp], #-1536	; 0xfffffa00
    22f4:	4700001c 	smladmi	r0, ip, r0, r0
    22f8:	001aa70b 	andseq	sl, sl, fp, lsl #14
    22fc:	850b4800 	strhi	r4, [fp, #-2048]	; 0xfffff800
    2300:	49000013 	stmdbmi	r0, {r0, r1, r4}
    2304:	0014990b 	andseq	r9, r4, fp, lsl #18
    2308:	d70b4a00 	strle	r4, [fp, -r0, lsl #20]
    230c:	4b000018 	blmi	2374 <shift+0x2374>
    2310:	001bd50b 	andseq	sp, fp, fp, lsl #10
    2314:	03004c00 	movweq	r4, #3072	; 0xc00
    2318:	082f0702 	stmdaeq	pc!, {r1, r8, r9, sl}	; <UNPREDICTABLE>
    231c:	e40c0000 	str	r0, [ip], #-0
    2320:	d9000003 	stmdble	r0, {r0, r1}
    2324:	0d000003 	stceq	0, cr0, [r0, #-12]
    2328:	03ce0e00 	biceq	r0, lr, #0, 28
    232c:	04050000 	streq	r0, [r5], #-0
    2330:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2334:	0003de0e 	andeq	sp, r3, lr, lsl #28
    2338:	08010300 	stmdaeq	r1, {r8, r9}
    233c:	00000733 	andeq	r0, r0, r3, lsr r7
    2340:	0003e90e 	andeq	lr, r3, lr, lsl #18
    2344:	153d0f00 	ldrne	r0, [sp, #-3840]!	; 0xfffff100
    2348:	4c040000 	stcmi	0, cr0, [r4], {-0}
    234c:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    2350:	5b0f0000 	blpl	3c2358 <__bss_end+0x3b8a0c>
    2354:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    2358:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    235c:	0c000003 	stceq	0, cr0, [r0], {3}
    2360:	000003e9 	andeq	r0, r0, r9, ror #7
    2364:	0000041a 	andeq	r0, r0, sl, lsl r4
    2368:	4609000d 	strmi	r0, [r9], -sp
    236c:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2370:	040f0d2d 	streq	r0, [pc], #-3373	; 2378 <shift+0x2378>
    2374:	ce090000 	cdpgt	0, 0, cr0, cr9, cr0, {0}
    2378:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    237c:	01e61c38 	mvneq	r1, r8, lsr ip
    2380:	340a0000 	strcc	r0, [sl], #-0
    2384:	07000018 	smladeq	r0, r8, r0, r0
    2388:	00009301 	andeq	r9, r0, r1, lsl #6
    238c:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    2390:	000004a5 	andeq	r0, r0, r5, lsr #9
    2394:	00139a0b 	andseq	r9, r3, fp, lsl #20
    2398:	460b0000 	strmi	r0, [fp], -r0
    239c:	0100001a 	tsteq	r0, sl, lsl r0
    23a0:	0022e00b 	eoreq	lr, r2, fp
    23a4:	a30b0200 	movwge	r0, #45568	; 0xb200
    23a8:	03000022 	movweq	r0, #34	; 0x22
    23ac:	001d9d0b 	andseq	r9, sp, fp, lsl #26
    23b0:	5e0b0400 	cfcpyspl	mvf0, mvf11
    23b4:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    23b8:	0015800b 	andseq	r8, r5, fp
    23bc:	620b0600 	andvs	r0, fp, #0, 12
    23c0:	07000015 	smladeq	r0, r5, r0, r0
    23c4:	00177b0b 	andseq	r7, r7, fp, lsl #22
    23c8:	590b0800 	stmdbpl	fp, {fp}
    23cc:	0900001c 	stmdbeq	r0, {r2, r3, r4}
    23d0:	0015870b 	andseq	r8, r5, fp, lsl #14
    23d4:	600b0a00 	andvs	r0, fp, r0, lsl #20
    23d8:	0b00001c 	bleq	2450 <shift+0x2450>
    23dc:	0015ec0b 	andseq	lr, r5, fp, lsl #24
    23e0:	790b0c00 	stmdbvc	fp, {sl, fp}
    23e4:	0d000015 	stceq	0, cr0, [r0, #-84]	; 0xffffffac
    23e8:	0020b50b 	eoreq	fp, r0, fp, lsl #10
    23ec:	820b0e00 	andhi	r0, fp, #0, 28
    23f0:	0f00001e 	svceq	0x0000001e
    23f4:	1fad0400 	svcne	0x00ad0400
    23f8:	3f050000 	svccc	0x00050000
    23fc:	00043201 	andeq	r3, r4, r1, lsl #4
    2400:	20410900 	subcs	r0, r1, r0, lsl #18
    2404:	41050000 	mrsmi	r0, (UNDEF: 5)
    2408:	0004a50f 	andeq	sl, r4, pc, lsl #10
    240c:	20c90900 	sbccs	r0, r9, r0, lsl #18
    2410:	4a050000 	bmi	142418 <__bss_end+0x138acc>
    2414:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2418:	15210900 	strne	r0, [r1, #-2304]!	; 0xfffff700
    241c:	4b050000 	blmi	142424 <__bss_end+0x138ad8>
    2420:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2424:	21a21000 			; <UNDEFINED> instruction: 0x21a21000
    2428:	da090000 	ble	242430 <__bss_end+0x238ae4>
    242c:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2430:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    2434:	04050000 	streq	r0, [r5], #-0
    2438:	000004d5 	ldrdeq	r0, [r0], -r5
    243c:	1a100911 	bne	404888 <__bss_end+0x3faf3c>
    2440:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    2444:	0004f90f 	andeq	pc, r4, pc, lsl #18
    2448:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    244c:	12000004 	andne	r0, r0, #4
    2450:	00001fc3 	andeq	r1, r0, r3, asr #31
    2454:	001d8a09 	andseq	r8, sp, r9, lsl #20
    2458:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    245c:	00000510 	andeq	r0, r0, r0, lsl r5
    2460:	04ff0405 	ldrbteq	r0, [pc], #1029	; 2468 <shift+0x2468>
    2464:	98130000 	ldmdals	r3, {}	; <UNPREDICTABLE>
    2468:	34000016 	strcc	r0, [r0], #-22	; 0xffffffea
    246c:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    2470:	00000541 	andeq	r0, r0, r1, asr #10
    2474:	001b4f14 	andseq	r4, fp, r4, lsl pc
    2478:	01690500 	cmneq	r9, r0, lsl #10
    247c:	0003de0f 	andeq	sp, r3, pc, lsl #28
    2480:	7c140000 	ldcvc	0, cr0, [r4], {-0}
    2484:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    2488:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    248c:	04000005 	streq	r0, [r0], #-5
    2490:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    2494:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    2498:	56000000 	strpl	r0, [r0], -r0
    249c:	15000005 	strne	r0, [r0, #-5]
    24a0:	00000024 	andeq	r0, r0, r4, lsr #32
    24a4:	410c002d 	tstmi	ip, sp, lsr #32
    24a8:	61000005 	tstvs	r0, r5
    24ac:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    24b0:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    24b4:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
    24b8:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    24bc:	6103016b 	tstvs	r3, fp, ror #2
    24c0:	0f000005 	svceq	0x00000005
    24c4:	00001cc4 	andeq	r1, r0, r4, asr #25
    24c8:	0c016e05 	stceq	14, cr6, [r1], {5}
    24cc:	0000001d 	andeq	r0, r0, sp, lsl r0
    24d0:	00200116 	eoreq	r0, r0, r6, lsl r1
    24d4:	93010700 	movwls	r0, #5888	; 0x1700
    24d8:	05000000 	streq	r0, [r0, #-0]
    24dc:	2a060181 	bcs	182ae8 <__bss_end+0x17919c>
    24e0:	0b000006 	bleq	2500 <shift+0x2500>
    24e4:	0000142f 	andeq	r1, r0, pc, lsr #8
    24e8:	143b0b00 	ldrtne	r0, [fp], #-2816	; 0xfffff500
    24ec:	0b020000 	bleq	824f4 <__bss_end+0x78ba8>
    24f0:	00001447 	andeq	r1, r0, r7, asr #8
    24f4:	18600b03 	stmdane	r0!, {r0, r1, r8, r9, fp}^
    24f8:	0b030000 	bleq	c2500 <__bss_end+0xb8bb4>
    24fc:	00001453 	andeq	r1, r0, r3, asr r4
    2500:	19a90b04 	stmibne	r9!, {r2, r8, r9, fp}
    2504:	0b040000 	bleq	10250c <__bss_end+0xf8bc0>
    2508:	00001a8f 	andeq	r1, r0, pc, lsl #21
    250c:	19e50b05 	stmibne	r5!, {r0, r2, r8, r9, fp}^
    2510:	0b050000 	bleq	142518 <__bss_end+0x138bcc>
    2514:	00001512 	andeq	r1, r0, r2, lsl r5
    2518:	145f0b05 	ldrbne	r0, [pc], #-2821	; 2520 <shift+0x2520>
    251c:	0b060000 	bleq	182524 <__bss_end+0x178bd8>
    2520:	00001c0d 	andeq	r1, r0, sp, lsl #24
    2524:	166e0b06 	strbtne	r0, [lr], -r6, lsl #22
    2528:	0b060000 	bleq	182530 <__bss_end+0x178be4>
    252c:	00001c1a 	andeq	r1, r0, sl, lsl ip
    2530:	20810b06 	addcs	r0, r1, r6, lsl #22
    2534:	0b060000 	bleq	18253c <__bss_end+0x178bf0>
    2538:	00001c27 	andeq	r1, r0, r7, lsr #24
    253c:	1c670b06 			; <UNDEFINED> instruction: 0x1c670b06
    2540:	0b060000 	bleq	182548 <__bss_end+0x178bfc>
    2544:	0000146b 	andeq	r1, r0, fp, ror #8
    2548:	1d6d0b07 	fstmdbxne	sp!, {d16-d18}	;@ Deprecated
    254c:	0b070000 	bleq	1c2554 <__bss_end+0x1b8c08>
    2550:	00001dba 			; <UNDEFINED> instruction: 0x00001dba
    2554:	20bc0b07 	adcscs	r0, ip, r7, lsl #22
    2558:	0b070000 	bleq	1c2560 <__bss_end+0x1b8c14>
    255c:	00001641 	andeq	r1, r0, r1, asr #12
    2560:	1e3b0b07 	vaddne.f64	d0, d11, d7
    2564:	0b080000 	bleq	20256c <__bss_end+0x1f8c20>
    2568:	000013e4 	andeq	r1, r0, r4, ror #7
    256c:	208f0b08 	addcs	r0, pc, r8, lsl #22
    2570:	0b080000 	bleq	202578 <__bss_end+0x1f8c2c>
    2574:	00001e57 	andeq	r1, r0, r7, asr lr
    2578:	f50f0008 			; <UNDEFINED> instruction: 0xf50f0008
    257c:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2580:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    2584:	0f000005 	svceq	0x00000005
    2588:	00001e89 	andeq	r1, r0, r9, lsl #29
    258c:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    2590:	0000001d 	andeq	r0, r0, sp, lsl r0
    2594:	001a9c0f 	andseq	r9, sl, pc, lsl #24
    2598:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    259c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    25a0:	23c10f00 	biccs	r0, r1, #0, 30
    25a4:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    25a8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    25ac:	310f0000 	mrscc	r0, CPSR
    25b0:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    25b4:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    25b8:	0f000000 	svceq	0x00000000
    25bc:	00001e93 	muleq	r0, r3, lr
    25c0:	0c01ae05 	stceq	14, cr10, [r1], {5}
    25c4:	0000001d 	andeq	r0, r0, sp, lsl r0
    25c8:	001da40f 	andseq	sl, sp, pc, lsl #8
    25cc:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    25d0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    25d4:	1daf0f00 	stcne	15, cr0, [pc]	; 25dc <shift+0x25dc>
    25d8:	b4050000 	strlt	r0, [r5], #-0
    25dc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    25e0:	9d0f0000 	stcls	0, cr0, [pc, #-0]	; 25e8 <shift+0x25e8>
    25e4:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    25e8:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    25ec:	0f000000 	svceq	0x00000000
    25f0:	00001be9 	andeq	r1, r0, r9, ror #23
    25f4:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    25f8:	0000001d 	andeq	r0, r0, sp, lsl r0
    25fc:	0023200f 	eoreq	r2, r3, pc
    2600:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    2604:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2608:	1ea70f00 	cdpne	15, 10, cr0, cr7, cr0, {0}
    260c:	c0050000 	andgt	r0, r5, r0
    2610:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2614:	e40f0000 	str	r0, [pc], #-0	; 261c <shift+0x261c>
    2618:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    261c:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    2620:	0f000000 	svceq	0x00000000
    2624:	000022aa 	andeq	r2, r0, sl, lsr #5
    2628:	0c01c605 	stceq	6, cr12, [r1], {5}
    262c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2630:	0022b60f 	eoreq	fp, r2, pc, lsl #12
    2634:	01c90500 	biceq	r0, r9, r0, lsl #10
    2638:	00001d0c 	andeq	r1, r0, ip, lsl #26
    263c:	22c20f00 	sbccs	r0, r2, #0, 30
    2640:	cc050000 	stcgt	0, cr0, [r5], {-0}
    2644:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2648:	e70f0000 	str	r0, [pc, -r0]
    264c:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2650:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    2654:	0f000000 	svceq	0x00000000
    2658:	000023d7 	ldrdeq	r2, [r0], -r7
    265c:	0c01d305 	stceq	3, cr13, [r1], {5}
    2660:	0000001d 	andeq	r0, r0, sp, lsl r0
    2664:	00158e0f 	andseq	r8, r5, pc, lsl #28
    2668:	01d60500 	bicseq	r0, r6, r0, lsl #10
    266c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2670:	13750f00 	cmnne	r5, #0, 30
    2674:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    2678:	001d0c01 	andseq	r0, sp, r1, lsl #24
    267c:	800f0000 	andhi	r0, pc, r0
    2680:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    2684:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    2688:	0f000000 	svceq	0x00000000
    268c:	00001569 	andeq	r1, r0, r9, ror #10
    2690:	0c01df05 	stceq	15, cr13, [r1], {5}
    2694:	0000001d 	andeq	r0, r0, sp, lsl r0
    2698:	001ebd0f 	andseq	fp, lr, pc, lsl #26
    269c:	01e20500 	mvneq	r0, r0, lsl #10
    26a0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26a4:	1ac50f00 	bne	ff1462ac <__bss_end+0xff13c960>
    26a8:	e5050000 	str	r0, [r5, #-0]
    26ac:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26b0:	1d0f0000 	stcne	0, cr0, [pc, #-0]	; 26b8 <shift+0x26b8>
    26b4:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    26b8:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    26bc:	0f000000 	svceq	0x00000000
    26c0:	000021d7 	ldrdeq	r2, [r0], -r7
    26c4:	0c01ef05 	stceq	15, cr14, [r1], {5}
    26c8:	0000001d 	andeq	r0, r0, sp, lsl r0
    26cc:	00238f0f 	eoreq	r8, r3, pc, lsl #30
    26d0:	01f20500 	mvnseq	r0, r0, lsl #10
    26d4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26d8:	239f0f00 	orrscs	r0, pc, #0, 30
    26dc:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    26e0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26e4:	850f0000 	strhi	r0, [pc, #-0]	; 26ec <shift+0x26ec>
    26e8:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    26ec:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    26f0:	0f000000 	svceq	0x00000000
    26f4:	0000221e 	andeq	r2, r0, lr, lsl r2
    26f8:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    26fc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2700:	001e230f 	andseq	r2, lr, pc, lsl #6
    2704:	01fe0500 	mvnseq	r0, r0, lsl #10
    2708:	00001d0c 	andeq	r1, r0, ip, lsl #26
    270c:	18f90f00 	ldmne	r9!, {r8, r9, sl, fp}^
    2710:	02050000 	andeq	r0, r5, #0
    2714:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2718:	130f0000 	movwne	r0, #61440	; 0xf000
    271c:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2720:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    2724:	0f000000 	svceq	0x00000000
    2728:	000017ec 	andeq	r1, r0, ip, ror #15
    272c:	0c020d05 	stceq	13, cr0, [r2], {5}
    2730:	0000001d 	andeq	r0, r0, sp, lsl r0
    2734:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2738:	0007ef00 	andeq	lr, r7, r0, lsl #30
    273c:	0f000d00 	svceq	0x00000d00
    2740:	000019c5 	andeq	r1, r0, r5, asr #19
    2744:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    2748:	000007e4 	andeq	r0, r0, r4, ror #15
    274c:	0004e60c 	andeq	lr, r4, ip, lsl #12
    2750:	00080c00 	andeq	r0, r8, r0, lsl #24
    2754:	00241500 	eoreq	r1, r4, r0, lsl #10
    2758:	000d0000 	andeq	r0, sp, r0
    275c:	001ee00f 	andseq	lr, lr, pc
    2760:	05840500 	streq	r0, [r4, #1280]	; 0x500
    2764:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    2768:	1a871600 	bne	fe1c7f70 <__bss_end+0xfe1be624>
    276c:	01070000 	mrseq	r0, (UNDEF: 7)
    2770:	00000093 	muleq	r0, r3, r0
    2774:	06058b05 	streq	r8, [r5], -r5, lsl #22
    2778:	00000857 	andeq	r0, r0, r7, asr r8
    277c:	0018420b 	andseq	r4, r8, fp, lsl #4
    2780:	920b0000 	andls	r0, fp, #0
    2784:	0100001c 	tsteq	r0, ip, lsl r0
    2788:	00141a0b 	andseq	r1, r4, fp, lsl #20
    278c:	510b0200 	mrspl	r0, R11_fiq
    2790:	03000023 	movweq	r0, #35	; 0x23
    2794:	001f5a0b 	andseq	r5, pc, fp, lsl #20
    2798:	4d0b0400 	cfstrsmi	mvf0, [fp, #-0]
    279c:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    27a0:	0014f10b 	andseq	pc, r4, fp, lsl #2
    27a4:	0f000600 	svceq	0x00000600
    27a8:	00002341 	andeq	r2, r0, r1, asr #6
    27ac:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    27b0:	00000819 	andeq	r0, r0, r9, lsl r8
    27b4:	0022430f 	eoreq	r4, r2, pc, lsl #6
    27b8:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    27bc:	00002411 	andeq	r2, r0, r1, lsl r4
    27c0:	1ecd0f00 	cdpne	15, 12, cr0, cr13, cr0, {0}
    27c4:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    27c8:	001d0c07 	andseq	r0, sp, r7, lsl #24
    27cc:	b6040000 	strlt	r0, [r4], -r0
    27d0:	06000021 	streq	r0, [r0], -r1, lsr #32
    27d4:	0093167b 	addseq	r1, r3, fp, ror r6
    27d8:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    27dc:	03000008 	movweq	r0, #8
    27e0:	045b0502 	ldrbeq	r0, [fp], #-1282	; 0xfffffafe
    27e4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    27e8:	0017d507 	andseq	sp, r7, r7, lsl #10
    27ec:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    27f0:	000015a9 	andeq	r1, r0, r9, lsr #11
    27f4:	a1030803 	tstge	r3, r3, lsl #16
    27f8:	03000015 	movweq	r0, #21
    27fc:	1eb60408 	cdpne	4, 11, cr0, cr6, cr8, {0}
    2800:	10030000 	andne	r0, r3, r0
    2804:	001f6803 	andseq	r6, pc, r3, lsl #16
    2808:	088a0c00 	stmeq	sl, {sl, fp}
    280c:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    2810:	24150000 	ldrcs	r0, [r5], #-0
    2814:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    2818:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    281c:	c70f0000 	strgt	r0, [pc, -r0]
    2820:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    2824:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    2828:	0f000008 	svceq	0x00000008
    282c:	00001558 	andeq	r1, r0, r8, asr r5
    2830:	16020206 	strne	r0, [r2], -r6, lsl #4
    2834:	000008c9 	andeq	r0, r0, r9, asr #17
    2838:	0021e904 	eoreq	lr, r1, r4, lsl #18
    283c:	102a0700 	eorne	r0, sl, r0, lsl #14
    2840:	000004f9 	strdeq	r0, [r0], -r9
    2844:	0008e80c 	andeq	lr, r8, ip, lsl #16
    2848:	0008ff00 	andeq	pc, r8, r0, lsl #30
    284c:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2850:	00000357 	andeq	r0, r0, r7, asr r3
    2854:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    2858:	09000008 	stmdbeq	r0, {r3}
    285c:	0000020c 	andeq	r0, r0, ip, lsl #4
    2860:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    2864:	17000008 	strne	r0, [r0, -r8]
    2868:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    286c:	0a093308 	beq	24f494 <__bss_end+0x245b48>
    2870:	99390305 	ldmdbls	r9!, {r0, r2, r8, r9}
    2874:	0b170000 	bleq	5c287c <__bss_end+0x5b8f30>
    2878:	08000009 	stmdaeq	r0, {r0, r3}
    287c:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    2880:	00993903 	addseq	r3, r9, r3, lsl #18
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3772c8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb93d0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb93f0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9408>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x3d8>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79f48>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3942c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f735c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b67a8>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4ba00c>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4fc4>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b67d4>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6848>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3773c4>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb94c4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe7a000>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe394e4>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb94fc>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe7a034>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5070>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3774b4>
 198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 19c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 1a0:	11000019 	tstne	r0, r9, lsl r0
 1a4:	1347012e 	movtne	r0, #28974	; 0x712e
 1a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1b0:	00130119 	andseq	r0, r3, r9, lsl r1
 1b4:	00051200 	andeq	r1, r5, r0, lsl #4
 1b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 1bc:	05130000 	ldreq	r0, [r3, #-0]
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f747c>
 1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 1d0:	1347012e 	movtne	r0, #28974	; 0x712e
 1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1dc:	00000019 	andeq	r0, r0, r9, lsl r0
 1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
 1e8:	110e1b0e 	tstne	lr, lr, lsl #22
 1ec:	10061201 	andne	r1, r6, r1, lsl #4
 1f0:	02000017 	andeq	r0, r0, #23
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6940>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf794f0>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c5108>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe7950c>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe395d0>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c5110>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b95fc>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7b62c>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe395f8>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe7a12c>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe39610>
 26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 270:	00001802 	andeq	r1, r0, r2, lsl #16
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2ba148>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb9628>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x37754c>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe7a16c>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe39650>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x377584>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb9684>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7b6c8>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x377618>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb96b8>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7b6fc>
 320:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 324:	01150000 	tsteq	r5, r0
 328:	01134901 	tsteq	r3, r1, lsl #18
 32c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 330:	13490021 	movtne	r0, #36897	; 0x9021
 334:	00000b2f 	andeq	r0, r0, pc, lsr #22
 338:	0b000f17 	bleq	3f9c <shift+0x3f9c>
 33c:	0013490b 	andseq	r4, r3, fp, lsl #18
 340:	00211800 	eoreq	r1, r1, r0, lsl #16
 344:	34190000 	ldrcc	r0, [r9], #-0
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x377604>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f8a24>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c525c>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb9724>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x377650>
 398:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 39c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3a0:	000b320b 	andeq	r3, fp, fp, lsl #4
 3a4:	01151e00 	tsteq	r5, r0, lsl #28
 3a8:	13641349 	cmnne	r4, #603979777	; 0x24000001
 3ac:	00001301 	andeq	r1, r0, r1, lsl #6
 3b0:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 3b4:	00134913 	andseq	r4, r3, r3, lsl r9
 3b8:	00102000 	andseq	r2, r0, r0
 3bc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 3c0:	0f210000 	svceq	0x00210000
 3c4:	000b0b00 	andeq	r0, fp, r0, lsl #22
 3c8:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 3cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeb9774>
 3d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3dc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3e0:	00130119 	andseq	r0, r3, r9, lsl r1
 3e4:	00052300 	andeq	r2, r5, r0, lsl #6
 3e8:	0b3a0e03 	bleq	e83bfc <__bss_end+0xe7a2b0>
 3ec:	0b390b3b 	bleq	e430e0 <__bss_end+0xe39794>
 3f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3f4:	01000000 	mrseq	r0, (UNDEF: 0)
 3f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 3fc:	0e030b13 	vmoveq.32	d3[0], r0
 400:	01110e1b 	tsteq	r1, fp, lsl lr
 404:	17100612 			; <UNDEFINED> instruction: 0x17100612
 408:	24020000 	strcs	r0, [r2], #-0
 40c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 410:	000e030b 	andeq	r0, lr, fp, lsl #6
 414:	00260300 	eoreq	r0, r6, r0, lsl #6
 418:	00001349 	andeq	r1, r0, r9, asr #6
 41c:	0b002404 	bleq	9434 <_Z4ftoafPcj+0x1bc>
 420:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 424:	05000008 	streq	r0, [r0, #-8]
 428:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb97d0>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	13060000 	movwne	r0, #24576	; 0x6000
 438:	0b0e0301 	bleq	381044 <__bss_end+0x3776f8>
 43c:	3b0b3a0b 	blcc	2cec70 <__bss_end+0x2c5324>
 440:	010b390b 	tsteq	fp, fp, lsl #18
 444:	07000013 	smladeq	r0, r3, r0, r0
 448:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb97f0>
 450:	13490b39 	movtne	r0, #39737	; 0x9b39
 454:	00000b38 	andeq	r0, r0, r8, lsr fp
 458:	03010408 	movweq	r0, #5128	; 0x1408
 45c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 460:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 464:	3b0b3a13 	blcc	2cecb8 <__bss_end+0x2c536c>
 468:	010b390b 	tsteq	fp, fp, lsl #18
 46c:	09000013 	stmdbeq	r0, {r0, r1, r4}
 470:	08030028 	stmdaeq	r3, {r3, r5}
 474:	00000b1c 	andeq	r0, r0, ip, lsl fp
 478:	0300280a 	movweq	r2, #2058	; 0x80a
 47c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 480:	00340b00 	eorseq	r0, r4, r0, lsl #22
 484:	0b3a0e03 	bleq	e83c98 <__bss_end+0xe7a34c>
 488:	0b390b3b 	bleq	e4317c <__bss_end+0xe39830>
 48c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 490:	00001802 	andeq	r1, r0, r2, lsl #16
 494:	0300020c 	movweq	r0, #524	; 0x20c
 498:	00193c0e 	andseq	r3, r9, lr, lsl #24
 49c:	01020d00 	tsteq	r2, r0, lsl #26
 4a0:	0b0b0e03 	bleq	2c3cb4 <__bss_end+0x2ba368>
 4a4:	0b3b0b3a 	bleq	ec3194 <__bss_end+0xeb9848>
 4a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4ac:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 4b0:	3a0e0300 	bcc	3810b8 <__bss_end+0x37776c>
 4b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4bc:	0f00000b 	svceq	0x0000000b
 4c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4c4:	0b3a0e03 	bleq	e83cd8 <__bss_end+0xe7a38c>
 4c8:	0b390b3b 	bleq	e431bc <__bss_end+0xe39870>
 4cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4d4:	05100000 	ldreq	r0, [r0, #-0]
 4d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 4dc:	11000019 	tstne	r0, r9, lsl r0
 4e0:	13490005 	movtne	r0, #36869	; 0x9005
 4e4:	0d120000 	ldceq	0, cr0, [r2, #-0]
 4e8:	3a0e0300 	bcc	3810f0 <__bss_end+0x3777a4>
 4ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	3f13490b 	svccc	0x0013490b
 4f4:	00193c19 	andseq	r3, r9, r9, lsl ip
 4f8:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 4fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 500:	0b3b0b3a 	bleq	ec31f0 <__bss_end+0xeb98a4>
 504:	0e6e0b39 	vmoveq.8	d14[5], r0
 508:	0b321349 	bleq	c85234 <__bss_end+0xc7b8e8>
 50c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 510:	00001301 	andeq	r1, r0, r1, lsl #6
 514:	3f012e14 	svccc	0x00012e14
 518:	3a0e0319 	bcc	381184 <__bss_end+0x377838>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 524:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 528:	00130113 	andseq	r0, r3, r3, lsl r1
 52c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 530:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 534:	0b3b0b3a 	bleq	ec3224 <__bss_end+0xeb98d8>
 538:	0e6e0b39 	vmoveq.8	d14[5], r0
 53c:	0b321349 	bleq	c85268 <__bss_end+0xc7b91c>
 540:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 544:	01160000 	tsteq	r6, r0
 548:	01134901 	tsteq	r3, r1, lsl #18
 54c:	17000013 	smladne	r0, r3, r0, r0
 550:	13490021 	movtne	r0, #36897	; 0x9021
 554:	00000b2f 	andeq	r0, r0, pc, lsr #22
 558:	0b000f18 	bleq	41c0 <shift+0x41c0>
 55c:	0013490b 	andseq	r4, r3, fp, lsl #18
 560:	00211900 	eoreq	r1, r1, r0, lsl #18
 564:	341a0000 	ldrcc	r0, [sl], #-0
 568:	3a0e0300 	bcc	381170 <__bss_end+0x377824>
 56c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 570:	3f13490b 	svccc	0x0013490b
 574:	00193c19 	andseq	r3, r9, r9, lsl ip
 578:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 57c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 580:	0b3b0b3a 	bleq	ec3270 <__bss_end+0xeb9924>
 584:	0e6e0b39 	vmoveq.8	d14[5], r0
 588:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 58c:	00001301 	andeq	r1, r0, r1, lsl #6
 590:	3f012e1c 	svccc	0x00012e1c
 594:	3a0e0319 	bcc	381200 <__bss_end+0x3778b4>
 598:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 59c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5a0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 5a4:	00130113 	andseq	r0, r3, r3, lsl r1
 5a8:	000d1d00 	andeq	r1, sp, r0, lsl #26
 5ac:	0b3a0e03 	bleq	e83dc0 <__bss_end+0xe7a474>
 5b0:	0b390b3b 	bleq	e432a4 <__bss_end+0xe39958>
 5b4:	0b381349 	bleq	e052e0 <__bss_end+0xdfb994>
 5b8:	00000b32 	andeq	r0, r0, r2, lsr fp
 5bc:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
 5c0:	01136413 	tsteq	r3, r3, lsl r4
 5c4:	1f000013 	svcne	0x00000013
 5c8:	131d001f 	tstne	sp, #31
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	0b001020 	bleq	4658 <shift+0x4658>
 5d4:	0013490b 	andseq	r4, r3, fp, lsl #18
 5d8:	000f2100 	andeq	r2, pc, r0, lsl #2
 5dc:	00000b0b 	andeq	r0, r0, fp, lsl #22
 5e0:	03003422 	movweq	r3, #1058	; 0x422
 5e4:	3b0b3a0e 	blcc	2cee24 <__bss_end+0x2c54d8>
 5e8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5ec:	00180213 	andseq	r0, r8, r3, lsl r2
 5f0:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f8:	0b3b0b3a 	bleq	ec32e8 <__bss_end+0xeb999c>
 5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
 600:	01111349 	tsteq	r1, r9, asr #6
 604:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 608:	01194296 			; <UNDEFINED> instruction: 0x01194296
 60c:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 610:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 614:	0b3b0b3a 	bleq	ec3304 <__bss_end+0xeb99b8>
 618:	13490b39 	movtne	r0, #39737	; 0x9b39
 61c:	00001802 	andeq	r1, r0, r2, lsl #16
 620:	3f012e25 	svccc	0x00012e25
 624:	3a0e0319 	bcc	381290 <__bss_end+0x377944>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 630:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 634:	97184006 	ldrls	r4, [r8, -r6]
 638:	13011942 	movwne	r1, #6466	; 0x1942
 63c:	34260000 	strtcc	r0, [r6], #-0
 640:	3a080300 	bcc	201248 <__bss_end+0x1f78fc>
 644:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 648:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 64c:	27000018 	smladcs	r0, r8, r0, r0
 650:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 654:	0b3a0e03 	bleq	e83e68 <__bss_end+0xe7a51c>
 658:	0b390b3b 	bleq	e4334c <__bss_end+0xe39a00>
 65c:	01110e6e 	tsteq	r1, lr, ror #28
 660:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 664:	01194297 			; <UNDEFINED> instruction: 0x01194297
 668:	28000013 	stmdacs	r0, {r0, r1, r4}
 66c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 670:	0b3a0e03 	bleq	e83e84 <__bss_end+0xe7a538>
 674:	0b390b3b 	bleq	e43368 <__bss_end+0xe39a1c>
 678:	01110e6e 	tsteq	r1, lr, ror #28
 67c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 680:	00194297 	mulseq	r9, r7, r2
 684:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 688:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 68c:	0b3b0b3a 	bleq	ec337c <__bss_end+0xeb9a30>
 690:	0e6e0b39 	vmoveq.8	d14[5], r0
 694:	01111349 	tsteq	r1, r9, asr #6
 698:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 69c:	00194297 	mulseq	r9, r7, r2
 6a0:	11010000 	mrsne	r0, (UNDEF: 1)
 6a4:	130e2501 	movwne	r2, #58625	; 0xe501
 6a8:	1b0e030b 	blne	3812dc <__bss_end+0x377990>
 6ac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6b0:	00171006 	andseq	r1, r7, r6
 6b4:	00340200 	eorseq	r0, r4, r0, lsl #4
 6b8:	0b3a0e03 	bleq	e83ecc <__bss_end+0xe7a580>
 6bc:	0b390b3b 	bleq	e433b0 <__bss_end+0xe39a64>
 6c0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 6c4:	00001802 	andeq	r1, r0, r2, lsl #16
 6c8:	0b002403 	bleq	96dc <__udivsi3+0x30>
 6cc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6d0:	0400000e 	streq	r0, [r0], #-14
 6d4:	13490026 	movtne	r0, #36902	; 0x9026
 6d8:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 6dc:	00130101 	andseq	r0, r3, r1, lsl #2
 6e0:	00340600 	eorseq	r0, r4, r0, lsl #12
 6e4:	0b3a0e03 	bleq	e83ef8 <__bss_end+0xe7a5ac>
 6e8:	0b390b3b 	bleq	e433dc <__bss_end+0xe39a90>
 6ec:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 6f0:	00000a1c 	andeq	r0, r0, ip, lsl sl
 6f4:	3a003a07 	bcc	ef18 <__bss_end+0x55cc>
 6f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6fc:	0013180b 	andseq	r1, r3, fp, lsl #16
 700:	01010800 	tsteq	r1, r0, lsl #16
 704:	13011349 	movwne	r1, #4937	; 0x1349
 708:	21090000 	mrscs	r0, (UNDEF: 9)
 70c:	2f134900 	svccs	0x00134900
 710:	0a00000b 	beq	744 <shift+0x744>
 714:	13470034 	movtne	r0, #28724	; 0x7034
 718:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
 71c:	03193f01 	tsteq	r9, #1, 30
 720:	3b0b3a0e 	blcc	2cef60 <__bss_end+0x2c5614>
 724:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 728:	1113490e 	tstne	r3, lr, lsl #18
 72c:	40061201 	andmi	r1, r6, r1, lsl #4
 730:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 734:	00001301 	andeq	r1, r0, r1, lsl #6
 738:	0300050c 	movweq	r0, #1292	; 0x50c
 73c:	3b0b3a08 	blcc	2cef64 <__bss_end+0x2c5618>
 740:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 744:	00180213 	andseq	r0, r8, r3, lsl r2
 748:	00340d00 	eorseq	r0, r4, r0, lsl #26
 74c:	0b3a0803 	bleq	e82760 <__bss_end+0xe78e14>
 750:	0b390b3b 	bleq	e43444 <__bss_end+0xe39af8>
 754:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 758:	340e0000 	strcc	r0, [lr], #-0
 75c:	3a0e0300 	bcc	381364 <__bss_end+0x377a18>
 760:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 764:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 768:	0f000018 	svceq	0x00000018
 76c:	0111010b 	tsteq	r1, fp, lsl #2
 770:	00000612 	andeq	r0, r0, r2, lsl r6
 774:	03003410 	movweq	r3, #1040	; 0x410
 778:	3b0b3a0e 	blcc	2cefb8 <__bss_end+0x2c566c>
 77c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 780:	00180213 	andseq	r0, r8, r3, lsl r2
 784:	00341100 	eorseq	r1, r4, r0, lsl #2
 788:	0b3a0803 	bleq	e8279c <__bss_end+0xe78e50>
 78c:	0b39053b 	bleq	e41c80 <__bss_end+0xe38334>
 790:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 794:	0f120000 	svceq	0x00120000
 798:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 79c:	13000013 	movwne	r0, #19
 7a0:	0b0b0024 	bleq	2c0838 <__bss_end+0x2b6eec>
 7a4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7a8:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 7ac:	03193f01 	tsteq	r9, #1, 30
 7b0:	3b0b3a0e 	blcc	2ceff0 <__bss_end+0x2c56a4>
 7b4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7b8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7bc:	96184006 	ldrls	r4, [r8], -r6
 7c0:	13011942 	movwne	r1, #6466	; 0x1942
 7c4:	05150000 	ldreq	r0, [r5, #-0]
 7c8:	3a0e0300 	bcc	3813d0 <__bss_end+0x377a84>
 7cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7d0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7d4:	16000018 			; <UNDEFINED> instruction: 0x16000018
 7d8:	0111010b 	tsteq	r1, fp, lsl #2
 7dc:	13010612 	movwne	r0, #5650	; 0x1612
 7e0:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 7e4:	03193f01 	tsteq	r9, #1, 30
 7e8:	3b0b3a0e 	blcc	2cf028 <__bss_end+0x2c56dc>
 7ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7f0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7f4:	97184006 	ldrls	r4, [r8, -r6]
 7f8:	13011942 	movwne	r1, #6466	; 0x1942
 7fc:	10180000 	andsne	r0, r8, r0
 800:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 804:	19000013 	stmdbne	r0, {r0, r1, r4}
 808:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 80c:	0b3a0803 	bleq	e82820 <__bss_end+0xe78ed4>
 810:	0b390b3b 	bleq	e43504 <__bss_end+0xe39bb8>
 814:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 818:	06120111 			; <UNDEFINED> instruction: 0x06120111
 81c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 820:	00130119 	andseq	r0, r3, r9, lsl r1
 824:	00261a00 	eoreq	r1, r6, r0, lsl #20
 828:	0f1b0000 	svceq	0x001b0000
 82c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 830:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 834:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 838:	0b3b0b3a 	bleq	ec3528 <__bss_end+0xeb9bdc>
 83c:	0e6e0b39 	vmoveq.8	d14[5], r0
 840:	06120111 			; <UNDEFINED> instruction: 0x06120111
 844:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 848:	00000019 	andeq	r0, r0, r9, lsl r0
 84c:	10001101 	andne	r1, r0, r1, lsl #2
 850:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 854:	1b0e0301 	blne	381460 <__bss_end+0x377b14>
 858:	130e250e 	movwne	r2, #58638	; 0xe50e
 85c:	00000005 	andeq	r0, r0, r5
 860:	10001101 	andne	r1, r0, r1, lsl #2
 864:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 868:	1b0e0301 	blne	381474 <__bss_end+0x377b28>
 86c:	130e250e 	movwne	r2, #58638	; 0xe50e
 870:	00000005 	andeq	r0, r0, r5
 874:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 878:	030b130e 	movweq	r1, #45838	; 0xb30e
 87c:	100e1b0e 	andne	r1, lr, lr, lsl #22
 880:	02000017 	andeq	r0, r0, #23
 884:	0b0b0024 	bleq	2c091c <__bss_end+0x2b6fd0>
 888:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 88c:	24030000 	strcs	r0, [r3], #-0
 890:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 894:	000e030b 	andeq	r0, lr, fp, lsl #6
 898:	00160400 	andseq	r0, r6, r0, lsl #8
 89c:	0b3a0e03 	bleq	e840b0 <__bss_end+0xe7a764>
 8a0:	0b390b3b 	bleq	e43594 <__bss_end+0xe39c48>
 8a4:	00001349 	andeq	r1, r0, r9, asr #6
 8a8:	0b000f05 	bleq	44c4 <shift+0x44c4>
 8ac:	0013490b 	andseq	r4, r3, fp, lsl #18
 8b0:	01150600 	tsteq	r5, r0, lsl #12
 8b4:	13491927 	movtne	r1, #39207	; 0x9927
 8b8:	00001301 	andeq	r1, r0, r1, lsl #6
 8bc:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 8c0:	08000013 	stmdaeq	r0, {r0, r1, r4}
 8c4:	00000026 	andeq	r0, r0, r6, lsr #32
 8c8:	03003409 	movweq	r3, #1033	; 0x409
 8cc:	3b0b3a0e 	blcc	2cf10c <__bss_end+0x2c57c0>
 8d0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8d4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8d8:	0a000019 	beq	944 <shift+0x944>
 8dc:	0e030104 	adfeqs	f0, f3, f4
 8e0:	0b0b0b3e 	bleq	2c35e0 <__bss_end+0x2b9c94>
 8e4:	0b3a1349 	bleq	e85610 <__bss_end+0xe7bcc4>
 8e8:	0b390b3b 	bleq	e435dc <__bss_end+0xe39c90>
 8ec:	00001301 	andeq	r1, r0, r1, lsl #6
 8f0:	0300280b 	movweq	r2, #2059	; 0x80b
 8f4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 8f8:	01010c00 	tsteq	r1, r0, lsl #24
 8fc:	13011349 	movwne	r1, #4937	; 0x1349
 900:	210d0000 	mrscs	r0, (UNDEF: 13)
 904:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 908:	13490026 	movtne	r0, #36902	; 0x9026
 90c:	340f0000 	strcc	r0, [pc], #-0	; 914 <shift+0x914>
 910:	3a0e0300 	bcc	381518 <__bss_end+0x377bcc>
 914:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 918:	3f13490b 	svccc	0x0013490b
 91c:	00193c19 	andseq	r3, r9, r9, lsl ip
 920:	00131000 	andseq	r1, r3, r0
 924:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 928:	15110000 	ldrne	r0, [r1, #-0]
 92c:	00192700 	andseq	r2, r9, r0, lsl #14
 930:	00171200 	andseq	r1, r7, r0, lsl #4
 934:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 938:	13130000 	tstne	r3, #0
 93c:	0b0e0301 	bleq	381548 <__bss_end+0x377bfc>
 940:	3b0b3a0b 	blcc	2cf174 <__bss_end+0x2c5828>
 944:	010b3905 	tsteq	fp, r5, lsl #18
 948:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 94c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 950:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 954:	13490b39 	movtne	r0, #39737	; 0x9b39
 958:	00000b38 	andeq	r0, r0, r8, lsr fp
 95c:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 960:	000b2f13 	andeq	r2, fp, r3, lsl pc
 964:	01041600 	tsteq	r4, r0, lsl #12
 968:	0b3e0e03 	bleq	f8417c <__bss_end+0xf7a830>
 96c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 970:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 974:	13010b39 	movwne	r0, #6969	; 0x1b39
 978:	34170000 	ldrcc	r0, [r7], #-0
 97c:	3a134700 	bcc	4d2584 <__bss_end+0x4c8c38>
 980:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 984:	0018020b 	andseq	r0, r8, fp, lsl #4
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	0000009c 	muleq	r0, ip, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00ce0002 	sbceq	r0, lr, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a4 	andeq	r8, r0, r4, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b0e0002 	bleq	380094 <__bss_end+0x376748>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008274 	andeq	r8, r0, r4, ror r2
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	18070002 	stmdane	r7, {r1}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086d0 	ldrdeq	r8, [r0], -r0
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1f040002 	svcne	0x00040002
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	000096ac 	andeq	r9, r0, ip, lsr #13
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1f2a0002 	svcne	0x002a0002
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	000098b8 			; <UNDEFINED> instruction: 0x000098b8
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	1f500002 	svcne	0x00500002
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6600>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff63a5>
      1c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      20:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      24:	61707372 	cmnvs	r0, r2, ror r3
      28:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      2c:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      30:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      34:	2f656d6f 	svccs	0x00656d6f
      38:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
      3c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
      40:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
      44:	2f736f2f 	svccs	0x00736f2f
      48:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
      4c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff63a7>
      54:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      58:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      5c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      60:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      64:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      68:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      6c:	5f003433 	svcpl	0x00003433
      70:	7472635f 	ldrbtvc	r6, [r2], #-863	; 0xfffffca1
      74:	6e695f30 	mcrvs	15, 3, r5, cr9, cr0, {1}
      78:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
      7c:	5f007373 	svcpl	0x00007373
      80:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
      84:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
      88:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
      8c:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
      90:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
      94:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
      98:	31393130 	teqcc	r9, r0, lsr r1
      9c:	20353230 	eorscs	r3, r5, r0, lsr r2
      a0:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
      a4:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
      a8:	415b2029 	cmpmi	fp, r9, lsr #32
      ac:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
      b0:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
      b4:	6172622d 	cmnvs	r2, sp, lsr #4
      b8:	2068636e 	rsbcs	r6, r8, lr, ror #6
      bc:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
      c0:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
      c4:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
      c8:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
      cc:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      d0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
      d4:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
      d8:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
      dc:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
      e0:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
      e4:	20706676 	rsbscs	r6, r0, r6, ror r6
      e8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
      ec:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
      f0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
      f4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
      f8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
      fc:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     100:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     104:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     108:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     10c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     110:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     114:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     118:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     11c:	616d2d20 	cmnvs	sp, r0, lsr #26
     120:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     124:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad50bc>
     12c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     130:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     134:	304f2d20 	subcc	r2, pc, r0, lsr #26
     138:	304f2d20 	subcc	r2, pc, r0, lsr #26
     13c:	73657200 	cmnvc	r5, #0, 4
     140:	00746c75 	rsbseq	r6, r4, r5, ror ip
     144:	73625f5f 	cmnvc	r2, #380	; 0x17c
     148:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
     14c:	00747261 	rsbseq	r7, r4, r1, ror #4
     150:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 9c <shift+0x9c>
     154:	616a2f65 	cmnvs	sl, r5, ror #30
     158:	6173656d 	cmnvs	r3, sp, ror #10
     15c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     160:	6f2f7469 	svcvs	0x002f7469
     164:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff64f5>
     16c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     170:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     174:	61707372 	cmnvs	r0, r2, ror r3
     178:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
     17c:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
     180:	5f5f0063 	svcpl	0x005f0063
     184:	30747263 	rsbscc	r7, r4, r3, ror #4
     188:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     18c:	675f5f00 	ldrbvs	r5, [pc, -r0, lsl #30]
     190:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     194:	615f5f00 	cmpvs	pc, r0, lsl #30
     198:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     19c:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1a0:	5f646e69 	svcpl	0x00646e69
     1a4:	5f707063 	svcpl	0x00707063
     1a8:	00317270 	eorseq	r7, r1, r0, ror r2
     1ac:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     1b0:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
     1b4:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
     1b8:	6e66006e 	cdpvs	0, 6, cr0, cr6, cr14, {3}
     1bc:	00727470 	rsbseq	r7, r2, r0, ror r4
     1c0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1c4:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     1c8:	5f003176 	svcpl	0x00003176
     1cc:	6178635f 	cmnvs	r8, pc, asr r3
     1d0:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     1d4:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     1d8:	61757472 	cmnvs	r5, r2, ror r4
     1dc:	5f5f006c 	svcpl	0x005f006c
     1e0:	5f617863 	svcpl	0x00617863
     1e4:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     1e8:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
     1ec:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     1f0:	5f5f0065 	svcpl	0x005f0065
     1f4:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     1f8:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     1fc:	5f005f5f 	svcpl	0x00005f5f
     200:	6f73645f 	svcvs	0x0073645f
     204:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     208:	00656c64 	rsbeq	r6, r5, r4, ror #24
     20c:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     210:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     214:	5f545349 	svcpl	0x00545349
     218:	4e47005f 	mcrmi	0, 2, r0, cr7, cr15, {2}
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10bea2c>
     220:	2034312b 	eorscs	r3, r4, fp, lsr #2
     224:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
     228:	30322031 	eorscc	r2, r2, r1, lsr r0
     22c:	30313931 	eorscc	r3, r1, r1, lsr r9
     230:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
     234:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     238:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     23c:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
     240:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
     244:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
     248:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
     24c:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
     250:	73697665 	cmnvc	r9, #105906176	; 0x6500000
     254:	206e6f69 	rsbcs	r6, lr, r9, ror #30
     258:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
     25c:	205d3939 	subscs	r3, sp, r9, lsr r9
     260:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     264:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     268:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     26c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     270:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     274:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     278:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     27c:	6f6c666d 	svcvs	0x006c666d
     280:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     284:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     288:	20647261 	rsbcs	r7, r4, r1, ror #4
     28c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     290:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     294:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     298:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     29c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2a0:	36373131 			; <UNDEFINED> instruction: 0x36373131
     2a4:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     2a8:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     2ac:	206d7261 	rsbcs	r7, sp, r1, ror #4
     2b0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     2b4:	613d6863 	teqvs	sp, r3, ror #16
     2b8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     2bc:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     2c0:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     2c4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     2c8:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     2cc:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     2d0:	6f6e662d 	svcvs	0x006e662d
     2d4:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     2d8:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     2dc:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     2e0:	6f6e662d 	svcvs	0x006e662d
     2e4:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     2e8:	5f5f0069 	svcpl	0x005f0069
     2ec:	5f617863 	svcpl	0x00617863
     2f0:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     2f4:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
     2f8:	0074726f 	rsbseq	r7, r4, pc, ror #4
     2fc:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     300:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     304:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 30c <shift+0x30c>
     308:	5f524f54 	svcpl	0x00524f54
     30c:	5f444e45 	svcpl	0x00444e45
     310:	5f5f005f 	svcpl	0x005f005f
     314:	5f617863 	svcpl	0x00617863
     318:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     31c:	6c007469 	cfstrsvs	mvf7, [r0], {105}	; 0x69
     320:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     324:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     328:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     32c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     330:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     334:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     338:	74630070 	strbtvc	r0, [r3], #-112	; 0xffffff90
     33c:	705f726f 	subsvc	r7, pc, pc, ror #4
     340:	5f007274 	svcpl	0x00007274
     344:	6178635f 	cmnvs	r8, pc, asr r3
     348:	6175675f 	cmnvs	r5, pc, asr r7
     34c:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     350:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     354:	5f006572 	svcpl	0x00006572
     358:	4f54435f 	svcmi	0x0054435f
     35c:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     360:	5f5f5453 	svcpl	0x005f5453
     364:	6f682f00 	svcvs	0x00682f00
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcffd8>
     36c:	73656d61 	cmnvc	r5, #6208	; 0x1840
     370:	2f697261 	svccs	0x00697261
     374:	2f746967 	svccs	0x00746967
     378:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     37c:	6f732f70 	svcvs	0x00732f70
     380:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     384:	73752f73 	cmnvc	r5, #460	; 0x1cc
     388:	70737265 	rsbsvc	r7, r3, r5, ror #4
     38c:	2f656361 	svccs	0x00656361
     390:	61787863 	cmnvs	r8, r3, ror #16
     394:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
     398:	6f007070 	svcvs	0x00007070
     39c:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     3a0:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     3a4:	0073656c 	rsbseq	r6, r3, ip, ror #10
     3a8:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     3ac:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     3b0:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     3b4:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     3b8:	6f682f00 	svcvs	0x00682f00
     3bc:	6a2f656d 	bvs	bd9978 <__bss_end+0xbd002c>
     3c0:	73656d61 	cmnvc	r5, #6208	; 0x1840
     3c4:	2f697261 	svccs	0x00697261
     3c8:	2f746967 	svccs	0x00746967
     3cc:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     3d0:	6f732f70 	svcvs	0x00732f70
     3d4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     3d8:	73752f73 	cmnvc	r5, #460	; 0x1cc
     3dc:	70737265 	rsbsvc	r7, r3, r5, ror #4
     3e0:	2f656361 	svccs	0x00656361
     3e4:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     3e8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     3ec:	616d2f6b 	cmnvs	sp, fp, ror #30
     3f0:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     3f4:	6d007070 	stcvs	0, cr7, [r0, #-448]	; 0xfffffe40
     3f8:	746f6f52 	strbtvc	r6, [pc], #-3922	; 400 <shift+0x400>
     3fc:	7665445f 			; <UNDEFINED> instruction: 0x7665445f
     400:	746f6e00 	strbtvc	r6, [pc], #-3584	; 408 <shift+0x408>
     404:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     408:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     40c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     410:	7300656e 	movwvc	r6, #1390	; 0x56e
     414:	7065656c 	rsbvc	r6, r5, ip, ror #10
     418:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     41c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
     420:	5f555043 	svcpl	0x00555043
     424:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     428:	00747865 	rsbseq	r7, r4, r5, ror #16
     42c:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     430:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     434:	00657461 	rsbeq	r7, r5, r1, ror #8
     438:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     43c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     440:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     444:	5f6d6574 	svcpl	0x006d6574
     448:	76726553 			; <UNDEFINED> instruction: 0x76726553
     44c:	00656369 	rsbeq	r6, r5, r9, ror #6
     450:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     454:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     458:	7300746e 	movwvc	r7, #1134	; 0x46e
     45c:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     460:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     464:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     468:	72505f49 	subsvc	r5, r0, #292	; 0x124
     46c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     470:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     474:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     478:	5a5f0065 	bpl	17c0614 <__bss_end+0x17b6cc8>
     47c:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     480:	6f725043 	svcvs	0x00725043
     484:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     488:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     48c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     490:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     494:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     498:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     49c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a4:	00764573 	rsbseq	r4, r6, r3, ror r5
     4a8:	5f78614d 	svcpl	0x0078614d
     4ac:	636f7250 	cmnvs	pc, #80, 4
     4b0:	5f737365 	svcpl	0x00737365
     4b4:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     4b8:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     4bc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     4c0:	696e4900 	stmdbvs	lr!, {r8, fp, lr}^
     4c4:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     4c8:	00657a69 	rsbeq	r7, r5, r9, ror #20
     4cc:	5f746547 	svcpl	0x00746547
     4d0:	00444950 	subeq	r4, r4, r0, asr r9
     4d4:	6e69616d 	powvsez	f6, f1, #5.0
     4d8:	53466700 	movtpl	r6, #26368	; 0x6700
     4dc:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     4e0:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     4e4:	53466700 	movtpl	r6, #26368	; 0x6700
     4e8:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     4ec:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     4f0:	756f435f 	strbvc	r4, [pc, #-863]!	; 199 <shift+0x199>
     4f4:	5f00746e 	svcpl	0x0000746e
     4f8:	314b4e5a 	cmpcc	fp, sl, asr lr
     4fc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     500:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     504:	614d5f73 	hvcvs	54771	; 0xd5f3
     508:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     50c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     510:	505f7465 	subspl	r7, pc, r5, ror #8
     514:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     518:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     51c:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     520:	006a4544 	rsbeq	r4, sl, r4, asr #10
     524:	314e5a5f 	cmpcc	lr, pc, asr sl
     528:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     52c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     530:	614d5f73 	hvcvs	54771	; 0xd5f3
     534:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     538:	63533872 	cmpvs	r3, #7471104	; 0x720000
     53c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     540:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     544:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     548:	50433631 	subpl	r3, r3, r1, lsr r6
     54c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     550:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 38c <shift+0x38c>
     554:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     558:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     55c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     560:	505f7966 	subspl	r7, pc, r6, ror #18
     564:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     568:	6a457373 	bvs	115d33c <__bss_end+0x11539f0>
     56c:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     570:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     574:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     578:	00656c64 	rsbeq	r6, r5, r4, ror #24
     57c:	6b636954 	blvs	18daad4 <__bss_end+0x18d1188>
     580:	756f435f 	strbvc	r4, [pc, #-863]!	; 229 <shift+0x229>
     584:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     588:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     58c:	6f746365 	svcvs	0x00746365
     590:	53007972 	movwpl	r7, #2418	; 0x972
     594:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     598:	6f545f68 	svcvs	0x00545f68
     59c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     5a0:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     5a4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     5a8:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     5ac:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     5b0:	73006874 	movwvc	r6, #2164	; 0x874
     5b4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     5b8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     5bc:	62006d65 	andvs	r6, r0, #6464	; 0x1940
     5c0:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     5c4:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     5c8:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5cc:	72610044 	rsbvc	r0, r1, #68	; 0x44
     5d0:	4e006367 	cdpmi	3, 0, cr6, cr0, cr7, {3}
     5d4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     5d8:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     5dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5e0:	61480073 	hvcvs	32771	; 0x8003
     5e4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5e8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     5ec:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     5f0:	5f6d6574 	svcpl	0x006d6574
     5f4:	00495753 	subeq	r5, r9, r3, asr r7
     5f8:	5f757063 	svcpl	0x00757063
     5fc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     600:	00747865 	rsbseq	r7, r4, r5, ror #16
     604:	61657243 	cmnvs	r5, r3, asr #4
     608:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     60c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     610:	44007373 	strmi	r7, [r0], #-883	; 0xfffffc8d
     614:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     618:	00656e69 	rsbeq	r6, r5, r9, ror #28
     61c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     620:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     624:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     628:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     62c:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     630:	61700079 	cmnvs	r0, r9, ror r0
     634:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     638:	636f4c00 	cmnvs	pc, #0, 24
     63c:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     640:	6b636f6c 	blvs	18dc3f8 <__bss_end+0x18d2aac>
     644:	54006465 	strpl	r6, [r0], #-1125	; 0xfffffb9b
     648:	545f5346 	ldrbpl	r5, [pc], #-838	; 650 <shift+0x650>
     64c:	5f656572 	svcpl	0x00656572
     650:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     654:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     658:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     65c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     660:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     664:	65006874 	strvs	r6, [r0, #-2164]	; 0xfffff78c
     668:	5f746978 	svcpl	0x00746978
     66c:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     670:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     674:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     678:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     67c:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
     680:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
     684:	6e49006e 	cdpvs	0, 4, cr0, cr9, cr14, {3}
     688:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     68c:	61747075 	cmnvs	r4, r5, ror r0
     690:	5f656c62 	svcpl	0x00656c62
     694:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
     698:	63530070 	cmpvs	r3, #112	; 0x70
     69c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     6a0:	5f00656c 	svcpl	0x0000656c
     6a4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6a8:	6f725043 	svcvs	0x00725043
     6ac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6b8:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     6bc:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     6c0:	6f72505f 	svcvs	0x0072505f
     6c4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6c8:	6a685045 	bvs	1a147e4 <__bss_end+0x1a0ae98>
     6cc:	6e550062 	cdpvs	0, 5, cr0, cr5, cr2, {3}
     6d0:	5f70616d 	svcpl	0x0070616d
     6d4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6d8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     6dc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     6e0:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     6e4:	5a5f0076 	bpl	17c08c4 <__bss_end+0x17b6f78>
     6e8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6ec:	636f7250 	cmnvs	pc, #80, 4
     6f0:	5f737365 	svcpl	0x00737365
     6f4:	616e614d 	cmnvs	lr, sp, asr #2
     6f8:	31726567 	cmncc	r2, r7, ror #10
     6fc:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     700:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     704:	5f656c69 	svcpl	0x00656c69
     708:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     70c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     710:	6353006a 	cmpvs	r3, #106	; 0x6a
     714:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     718:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     71c:	6f5a0052 	svcvs	0x005a0052
     720:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     724:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     728:	6e750074 	mrcvs	0, 3, r0, cr5, cr4, {3}
     72c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     730:	63206465 			; <UNDEFINED> instruction: 0x63206465
     734:	00726168 	rsbseq	r6, r2, r8, ror #2
     738:	5f534654 	svcpl	0x00534654
     73c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     740:	47007265 	strmi	r7, [r0, -r5, ror #4]
     744:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     748:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     74c:	505f746e 	subspl	r7, pc, lr, ror #8
     750:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     754:	52007373 	andpl	r7, r0, #-872415231	; 0xcc000001
     758:	5f646165 	svcpl	0x00646165
     75c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     760:	50730065 	rsbspl	r0, r3, r5, rrx
     764:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     768:	674d7373 	smlsldxvs	r7, sp, r3, r3
     76c:	65520072 	ldrbvs	r0, [r2, #-114]	; 0xffffff8e
     770:	75006461 	strvc	r6, [r0, #-1121]	; 0xfffffb9f
     774:	33746e69 	cmncc	r4, #1680	; 0x690
     778:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     77c:	314e5a5f 	cmpcc	lr, pc, asr sl
     780:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     784:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     788:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     78c:	65704f34 	ldrbvs	r4, [r0, #-3892]!	; 0xfffff0cc
     790:	4b50456e 	blmi	1411d50 <__bss_end+0x1408404>
     794:	4e353163 	rsfmisz	f3, f5, f3
     798:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     79c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     7a0:	6f4d5f6e 	svcvs	0x004d5f6e
     7a4:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
     7a8:	6b636f6c 	blvs	18dc560 <__bss_end+0x18d2c14>
     7ac:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     7b0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     7b4:	6f72505f 	svcvs	0x0072505f
     7b8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7bc:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     7c0:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     7c4:	00646c69 	rsbeq	r6, r4, r9, ror #24
     7c8:	6b736174 	blvs	1cd8da0 <__bss_end+0x1ccf454>
     7cc:	62747400 	rsbsvs	r7, r4, #0, 8
     7d0:	6d003072 	stcvs	0, cr3, [r0, #-456]	; 0xfffffe38
     7d4:	746f6f52 	strbtvc	r6, [pc], #-3922	; 7dc <shift+0x7dc>
     7d8:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
     7dc:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     7e0:	00726576 	rsbseq	r6, r2, r6, ror r5
     7e4:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     7e8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7ec:	50433631 	subpl	r3, r3, r1, lsr r6
     7f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7f4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 630 <shift+0x630>
     7f8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7fc:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     800:	5f70614d 	svcpl	0x0070614d
     804:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     808:	5f6f545f 	svcpl	0x006f545f
     80c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     810:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     814:	46493550 			; <UNDEFINED> instruction: 0x46493550
     818:	00656c69 	rsbeq	r6, r5, r9, ror #24
     81c:	6f72506d 	svcvs	0x0072506d
     820:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     824:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     828:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     82c:	73006461 	movwvc	r6, #1121	; 0x461
     830:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     834:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     838:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     83c:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     840:	526d0074 	rsbpl	r0, sp, #116	; 0x74
     844:	5f746f6f 	svcpl	0x00746f6f
     848:	00737953 	rsbseq	r7, r3, r3, asr r9
     84c:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     850:	695f7265 	ldmdbvs	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     854:	4e007864 	cdpmi	8, 0, cr7, cr0, cr4, {3}
     858:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     85c:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     860:	6f6c4200 	svcvs	0x006c4200
     864:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     868:	61655200 	cmnvs	r5, r0, lsl #4
     86c:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     870:	5f00796c 	svcpl	0x0000796c
     874:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     878:	6f725043 	svcvs	0x00725043
     87c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     880:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     884:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     888:	76453443 	strbvc	r3, [r5], -r3, asr #8
     88c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     890:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     894:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     898:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     89c:	006f666e 	rsbeq	r6, pc, lr, ror #12
     8a0:	314e5a5f 	cmpcc	lr, pc, asr sl
     8a4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8a8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8ac:	614d5f73 	hvcvs	54771	; 0xd5f3
     8b0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8b4:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     8b8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8bc:	5f656c75 	svcpl	0x00656c75
     8c0:	76455252 			; <UNDEFINED> instruction: 0x76455252
     8c4:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     8c8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     8cc:	614d0065 	cmpvs	sp, r5, rrx
     8d0:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     8d4:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     8d8:	00687467 	rsbeq	r7, r8, r7, ror #8
     8dc:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     8e0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     8e4:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     8e8:	5a5f0063 	bpl	17c0a7c <__bss_end+0x17b7130>
     8ec:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8f0:	636f7250 	cmnvs	pc, #80, 4
     8f4:	5f737365 	svcpl	0x00737365
     8f8:	616e614d 	cmnvs	lr, sp, asr #2
     8fc:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     900:	6f6c4231 	svcvs	0x006c4231
     904:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     908:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     90c:	505f746e 	subspl	r7, pc, lr, ror #8
     910:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     914:	76457373 			; <UNDEFINED> instruction: 0x76457373
     918:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     91c:	5f656c64 	svcpl	0x00656c64
     920:	636f7250 	cmnvs	pc, #80, 4
     924:	5f737365 	svcpl	0x00737365
     928:	00495753 	subeq	r5, r9, r3, asr r7
     92c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     930:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     934:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     938:	5f6f666e 	svcpl	0x006f666e
     93c:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     940:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     944:	6f72505f 	svcvs	0x0072505f
     948:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     94c:	5f79425f 	svcpl	0x0079425f
     950:	00444950 	subeq	r4, r4, r0, asr r9
     954:	5f70614d 	svcpl	0x0070614d
     958:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     95c:	5f6f545f 	svcpl	0x006f545f
     960:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     964:	00746e65 	rsbseq	r6, r4, r5, ror #28
     968:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     96c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     970:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     974:	6f4e5f6b 	svcvs	0x004e5f6b
     978:	49006564 	stmdbmi	r0, {r2, r5, r6, r8, sl, sp, lr}
     97c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     980:	6f526d00 	svcvs	0x00526d00
     984:	5f00746f 	svcpl	0x0000746f
     988:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     98c:	6f725043 	svcvs	0x00725043
     990:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     994:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     998:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     99c:	61483831 	cmpvs	r8, r1, lsr r8
     9a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9a4:	6f72505f 	svcvs	0x0072505f
     9a8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9ac:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     9b0:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     9b4:	5f495753 	svcpl	0x00495753
     9b8:	636f7250 	cmnvs	pc, #80, 4
     9bc:	5f737365 	svcpl	0x00737365
     9c0:	76726553 			; <UNDEFINED> instruction: 0x76726553
     9c4:	6a656369 	bvs	1959770 <__bss_end+0x194fe24>
     9c8:	31526a6a 	cmpcc	r2, sl, ror #20
     9cc:	57535431 	smmlarpl	r3, r1, r4, r5
     9d0:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     9d4:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     9d8:	6f6c4300 	svcvs	0x006c4300
     9dc:	5f006573 	svcpl	0x00006573
     9e0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9e4:	6f725043 	svcvs	0x00725043
     9e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9f4:	61483132 	cmpvs	r8, r2, lsr r1
     9f8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9fc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a00:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a04:	5f6d6574 	svcpl	0x006d6574
     a08:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     a0c:	534e3332 	movtpl	r3, #58162	; 0xe332
     a10:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     a14:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a18:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a1c:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     a20:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a24:	6a6a6a65 	bvs	1a9b3c0 <__bss_end+0x1a91a74>
     a28:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a2c:	5f495753 	svcpl	0x00495753
     a30:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a34:	4c00746c 	cfstrsmi	mvf7, [r0], {108}	; 0x6c
     a38:	5f6b636f 	svcpl	0x006b636f
     a3c:	6b636f4c 	blvs	18dc774 <__bss_end+0x18d2e28>
     a40:	43006465 	movwmi	r6, #1125	; 0x465
     a44:	636f7250 	cmnvs	pc, #80, 4
     a48:	5f737365 	svcpl	0x00737365
     a4c:	616e614d 	cmnvs	lr, sp, asr #2
     a50:	00726567 	rsbseq	r6, r2, r7, ror #10
     a54:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     a58:	4e007966 	vmlsmi.f16	s14, s0, s13	; <UNPREDICTABLE>
     a5c:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     a60:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a64:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     a68:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     a6c:	5a5f0072 	bpl	17c0c3c <__bss_end+0x17b72f0>
     a70:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     a74:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a78:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a7c:	33316d65 	teqcc	r1, #6464	; 0x1940
     a80:	5f534654 	svcpl	0x00534654
     a84:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     a88:	646f4e5f 	strbtvs	r4, [pc], #-3679	; a90 <shift+0xa90>
     a8c:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
     a90:	5f646e69 	svcpl	0x00646e69
     a94:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     a98:	4b504564 	blmi	1412030 <__bss_end+0x14086e4>
     a9c:	65440063 	strbvs	r0, [r4, #-99]	; 0xffffff9d
     aa0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     aa4:	555f656e 	ldrbpl	r6, [pc, #-1390]	; 53e <shift+0x53e>
     aa8:	6168636e 	cmnvs	r8, lr, ror #6
     aac:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     ab0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ab4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ab8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     abc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ac0:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     ac4:	5a5f0076 	bpl	17c0ca4 <__bss_end+0x17b7358>
     ac8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     acc:	636f7250 	cmnvs	pc, #80, 4
     ad0:	5f737365 	svcpl	0x00737365
     ad4:	616e614d 	cmnvs	lr, sp, asr #2
     ad8:	31726567 	cmncc	r2, r7, ror #10
     adc:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     ae0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     ae4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ae8:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     aec:	456f666e 	strbmi	r6, [pc, #-1646]!	; 486 <shift+0x486>
     af0:	474e3032 	smlaldxmi	r3, lr, r2, r0
     af4:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     af8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     afc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b00:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     b04:	76506570 			; <UNDEFINED> instruction: 0x76506570
     b08:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     b0c:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     b10:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b14:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b18:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b1c:	006f666e 	rsbeq	r6, pc, lr, ror #12
     b20:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     b24:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     b28:	46490065 	strbmi	r0, [r9], -r5, rrx
     b2c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b30:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b34:	72445f6d 	subvc	r5, r4, #436	; 0x1b4
     b38:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b3c:	65727000 	ldrbvs	r7, [r2, #-0]!
     b40:	63410076 	movtvs	r0, #4214	; 0x1076
     b44:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     b48:	6f72505f 	svcvs	0x0072505f
     b4c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b50:	756f435f 	strbvc	r4, [pc, #-863]!	; 7f9 <shift+0x7f9>
     b54:	5f00746e 	svcpl	0x0000746e
     b58:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b5c:	6f725043 	svcvs	0x00725043
     b60:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b64:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b68:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b6c:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     b70:	5f686374 	svcpl	0x00686374
     b74:	50456f54 	subpl	r6, r5, r4, asr pc
     b78:	50433831 	subpl	r3, r3, r1, lsr r8
     b7c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b80:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     b84:	5f747369 	svcpl	0x00747369
     b88:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     b8c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b90:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     b94:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b98:	53007265 	movwpl	r7, #613	; 0x265
     b9c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ba0:	5f656c75 	svcpl	0x00656c75
     ba4:	00464445 	subeq	r4, r6, r5, asr #8
     ba8:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     bac:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     bb0:	6e00796c 	vmlsvs.f16	s14, s0, s25	; <UNPREDICTABLE>
     bb4:	00747865 	rsbseq	r7, r4, r5, ror #16
     bb8:	314e5a5f 	cmpcc	lr, pc, asr sl
     bbc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bc0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bc4:	614d5f73 	hvcvs	54771	; 0xd5f3
     bc8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bcc:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     bd0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bd4:	5f656c75 	svcpl	0x00656c75
     bd8:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     bdc:	5a5f0076 	bpl	17c0dbc <__bss_end+0x17b7470>
     be0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     be4:	636f7250 	cmnvs	pc, #80, 4
     be8:	5f737365 	svcpl	0x00737365
     bec:	616e614d 	cmnvs	lr, sp, asr #2
     bf0:	31726567 	cmncc	r2, r7, ror #10
     bf4:	746f4e34 	strbtvc	r4, [pc], #-3636	; bfc <shift+0xbfc>
     bf8:	5f796669 	svcpl	0x00796669
     bfc:	636f7250 	cmnvs	pc, #80, 4
     c00:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     c04:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     c08:	6b736154 	blvs	1cd9160 <__bss_end+0x1ccf814>
     c0c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     c10:	00746375 	rsbseq	r6, r4, r5, ror r3
     c14:	314e5a5f 	cmpcc	lr, pc, asr sl
     c18:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     c1c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c20:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c24:	6e493031 	mcrvs	0, 2, r3, cr9, cr1, {1}
     c28:	61697469 	cmnvs	r9, r9, ror #8
     c2c:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     c30:	63007645 	movwvs	r7, #1605	; 0x645
     c34:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     c38:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     c3c:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     c40:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     c44:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     c48:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
     c4c:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     c50:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
     c54:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
     c58:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
     c5c:	315a5f00 	cmpcc	sl, r0, lsl #30
     c60:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
     c64:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     c68:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     c6c:	5a5f0076 	bpl	17c0e4c <__bss_end+0x17b7500>
     c70:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     c74:	61745f74 	cmnvs	r4, r4, ror pc
     c78:	645f6b73 	ldrbvs	r6, [pc], #-2931	; c80 <shift+0xc80>
     c7c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     c80:	6a656e69 	bvs	195c62c <__bss_end+0x1952ce0>
     c84:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
     c88:	5a5f0074 	bpl	17c0e60 <__bss_end+0x17b7514>
     c8c:	746f6e36 	strbtvc	r6, [pc], #-3638	; c94 <shift+0xc94>
     c90:	6a796669 	bvs	1e5a63c <__bss_end+0x1e50cf0>
     c94:	5a5f006a 	bpl	17c0e44 <__bss_end+0x17b74f8>
     c98:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     c9c:	616e696d 	cmnvs	lr, sp, ror #18
     ca0:	00696574 	rsbeq	r6, r9, r4, ror r5
     ca4:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     ca8:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     cac:	646f6374 	strbtvs	r6, [pc], #-884	; cb4 <shift+0xcb4>
     cb0:	5a5f0065 	bpl	17c0e4c <__bss_end+0x17b7500>
     cb4:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     cb8:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     cbc:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     cc0:	6f72705f 	svcvs	0x0072705f
     cc4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cc8:	756f635f 	strbvc	r6, [pc, #-863]!	; 971 <shift+0x971>
     ccc:	0076746e 	rsbseq	r7, r6, lr, ror #8
     cd0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     cd4:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     cd8:	00646c65 	rsbeq	r6, r4, r5, ror #24
     cdc:	6b636974 	blvs	18db2b4 <__bss_end+0x18d1968>
     ce0:	756f635f 	strbvc	r6, [pc, #-863]!	; 989 <shift+0x989>
     ce4:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
     ce8:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
     cec:	00646572 	rsbeq	r6, r4, r2, ror r5
     cf0:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
     cf4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     cf8:	72505f65 	subsvc	r5, r0, #404	; 0x194
     cfc:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
     d00:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     d04:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     d08:	00736d61 	rsbseq	r6, r3, r1, ror #26
     d0c:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     d10:	5f746567 	svcpl	0x00746567
     d14:	6b636974 	blvs	18db2ec <__bss_end+0x18d19a0>
     d18:	756f635f 	strbvc	r6, [pc, #-863]!	; 9c1 <shift+0x9c1>
     d1c:	0076746e 	rsbseq	r7, r6, lr, ror #8
     d20:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     d24:	69440070 	stmdbvs	r4, {r4, r5, r6}^
     d28:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d2c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     d30:	5f746e65 	svcpl	0x00746e65
     d34:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d38:	6f697463 	svcvs	0x00697463
     d3c:	6573006e 	ldrbvs	r0, [r3, #-110]!	; 0xffffff92
     d40:	61745f74 	cmnvs	r4, r4, ror pc
     d44:	645f6b73 	ldrbvs	r6, [pc], #-2931	; d4c <shift+0xd4c>
     d48:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     d4c:	00656e69 	rsbeq	r6, r5, r9, ror #28
     d50:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     d54:	6f697461 	svcvs	0x00697461
     d58:	5a5f006e 	bpl	17c0f18 <__bss_end+0x17b75cc>
     d5c:	6f6c6335 	svcvs	0x006c6335
     d60:	006a6573 	rsbeq	r6, sl, r3, ror r5
     d64:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; cb0 <shift+0xcb0>
     d68:	616a2f65 	cmnvs	sl, r5, ror #30
     d6c:	6173656d 	cmnvs	r3, sp, ror #10
     d70:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     d74:	6f2f7469 	svcvs	0x002f7469
     d78:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     d7c:	756f732f 	strbvc	r7, [pc, #-815]!	; a55 <shift+0xa55>
     d80:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     d84:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     d88:	2f62696c 	svccs	0x0062696c
     d8c:	2f637273 	svccs	0x00637273
     d90:	66647473 			; <UNDEFINED> instruction: 0x66647473
     d94:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     d98:	00707063 	rsbseq	r7, r0, r3, rrx
     d9c:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     da0:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     da4:	66007664 	strvs	r7, [r0], -r4, ror #12
     da8:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     dac:	746f6e00 	strbtvc	r6, [pc], #-3584	; db4 <shift+0xdb4>
     db0:	00796669 	rsbseq	r6, r9, r9, ror #12
     db4:	6b636974 	blvs	18db38c <__bss_end+0x18d1a40>
     db8:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     dbc:	5f006e65 	svcpl	0x00006e65
     dc0:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     dc4:	4b506570 	blmi	141a38c <__bss_end+0x1410a40>
     dc8:	4e006a63 	vmlsmi.f32	s12, s0, s7
     dcc:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     dd0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     dd4:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     dd8:	76726573 			; <UNDEFINED> instruction: 0x76726573
     ddc:	00656369 	rsbeq	r6, r5, r9, ror #6
     de0:	5f746567 	svcpl	0x00746567
     de4:	6b636974 	blvs	18db3bc <__bss_end+0x18d1a70>
     de8:	756f635f 	strbvc	r6, [pc, #-863]!	; a91 <shift+0xa91>
     dec:	2f00746e 	svccs	0x0000746e
     df0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     df4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     df8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     dfc:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     e00:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     e04:	2f70732f 	svccs	0x0070732f
     e08:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     e0c:	2f736563 	svccs	0x00736563
     e10:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     e14:	61700064 	cmnvs	r0, r4, rrx
     e18:	006d6172 	rsbeq	r6, sp, r2, ror r1
     e1c:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
     e20:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     e24:	634b506a 	movtvs	r5, #45162	; 0xb06a
     e28:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
     e2c:	61745f74 	cmnvs	r4, r4, ror pc
     e30:	745f6b73 	ldrbvc	r6, [pc], #-2931	; e38 <shift+0xe38>
     e34:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     e38:	5f6f745f 	svcpl	0x006f745f
     e3c:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     e40:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e44:	464e4900 	strbmi	r4, [lr], -r0, lsl #18
     e48:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
     e4c:	72770059 	rsbsvc	r0, r7, #89	; 0x59
     e50:	00657469 	rsbeq	r7, r5, r9, ror #8
     e54:	5f667562 	svcpl	0x00667562
     e58:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     e5c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e60:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     e64:	00736d61 	rsbseq	r6, r3, r1, ror #26
     e68:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     e6c:	7065656c 	rsbvc	r6, r5, ip, ror #10
     e70:	66006a6a 	strvs	r6, [r0], -sl, ror #20
     e74:	00656c69 	rsbeq	r6, r5, r9, ror #24
     e78:	5f746547 	svcpl	0x00746547
     e7c:	616d6552 	cmnvs	sp, r2, asr r5
     e80:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
     e84:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
     e88:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     e8c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e90:	445f746e 	ldrbmi	r7, [pc], #-1134	; e98 <shift+0xe98>
     e94:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     e98:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e9c:	325a5f00 	subscc	r5, sl, #0, 30
     ea0:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     ea4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ea8:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     eac:	5f736b63 	svcpl	0x00736b63
     eb0:	645f6f74 	ldrbvs	r6, [pc], #-3956	; eb8 <shift+0xeb8>
     eb4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     eb8:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     ebc:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     ec0:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     ec4:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     ec8:	646f435f 	strbtvs	r4, [pc], #-863	; ed0 <shift+0xed0>
     ecc:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     ed0:	006d756e 	rsbeq	r7, sp, lr, ror #10
     ed4:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     ed8:	6a746961 	bvs	1d1b464 <__bss_end+0x1d11b18>
     edc:	5f006a6a 	svcpl	0x00006a6a
     ee0:	6f69355a 	svcvs	0x0069355a
     ee4:	6a6c7463 	bvs	1b1e078 <__bss_end+0x1b1472c>
     ee8:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     eec:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     ef0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     ef4:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     ef8:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     efc:	636f6900 	cmnvs	pc, #0, 18
     f00:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     f04:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     f08:	6f6d0074 	svcvs	0x006d0074
     f0c:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
     f10:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     f14:	5a5f0072 	bpl	17c10e4 <__bss_end+0x17b7798>
     f18:	61657234 	cmnvs	r5, r4, lsr r2
     f1c:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
     f20:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
     f24:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     f28:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f2c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     f30:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
     f34:	6f637465 	svcvs	0x00637465
     f38:	67006564 	strvs	r6, [r0, -r4, ror #10]
     f3c:	615f7465 	cmpvs	pc, r5, ror #8
     f40:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     f44:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     f48:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f4c:	6f635f73 	svcvs	0x00635f73
     f50:	00746e75 	rsbseq	r6, r4, r5, ror lr
     f54:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f58:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     f5c:	61657200 	cmnvs	r5, r0, lsl #4
     f60:	65740064 	ldrbvs	r0, [r4, #-100]!	; 0xffffff9c
     f64:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     f68:	00657461 	rsbeq	r7, r5, r1, ror #8
     f6c:	70746567 	rsbsvc	r6, r4, r7, ror #10
     f70:	5f006469 	svcpl	0x00006469
     f74:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
     f78:	4b506e65 	blmi	141c914 <__bss_end+0x1412fc8>
     f7c:	4e353163 	rsfmisz	f3, f5, f3
     f80:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f84:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f88:	6f4d5f6e 	svcvs	0x004d5f6e
     f8c:	47006564 	strmi	r6, [r0, -r4, ror #10]
     f90:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     f94:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     f98:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
     f9c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     fa0:	31393130 	teqcc	r9, r0, lsr r1
     fa4:	20353230 	eorscs	r3, r5, r0, lsr r2
     fa8:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     fac:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     fb0:	415b2029 	cmpmi	fp, r9, lsr #32
     fb4:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
     fb8:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     fbc:	6172622d 	cmnvs	r2, sp, lsr #4
     fc0:	2068636e 	rsbcs	r6, r8, lr, ror #6
     fc4:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     fc8:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
     fcc:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
     fd0:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
     fd4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     fd8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     fdc:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     fe0:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     fe4:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     fe8:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     fec:	20706676 	rsbscs	r6, r0, r6, ror r6
     ff0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     ff4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     ff8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     ffc:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1000:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1004:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1008:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    100c:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    1010:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    1014:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1018:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    101c:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    1020:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1024:	616d2d20 	cmnvs	sp, r0, lsr #26
    1028:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    102c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1030:	2b6b7a36 	blcs	1adf910 <__bss_end+0x1ad5fc4>
    1034:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1038:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    103c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1040:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    1044:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    1048:	6f6e662d 	svcvs	0x006e662d
    104c:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    1050:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    1054:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    1058:	6f6e662d 	svcvs	0x006e662d
    105c:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    1060:	5a5f0069 	bpl	17c120c <__bss_end+0x17b78c0>
    1064:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    1068:	50797063 	rsbspl	r7, r9, r3, rrx
    106c:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    1070:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    1074:	2f656d6f 	svccs	0x00656d6f
    1078:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    107c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    1080:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    1084:	2f736f2f 	svccs	0x00736f2f
    1088:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    108c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1090:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1094:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1098:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    109c:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    10a0:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    10a4:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    10a8:	00707063 	rsbseq	r7, r0, r3, rrx
    10ac:	616d6572 	smcvs	54866	; 0xd652
    10b0:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    10b4:	73690072 	cmnvc	r9, #114	; 0x72
    10b8:	006e616e 	rsbeq	r6, lr, lr, ror #2
    10bc:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    10c0:	6c617267 	sfmvs	f7, 2, [r1], #-412	; 0xfffffe64
    10c4:	69736900 	ldmdbvs	r3!, {r8, fp, sp, lr}^
    10c8:	6400666e 	strvs	r6, [r0], #-1646	; 0xfffff992
    10cc:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    10d0:	5f006c61 	svcpl	0x00006c61
    10d4:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    10d8:	506a616f 	rsbpl	r6, sl, pc, ror #2
    10dc:	61006a63 	tstvs	r0, r3, ror #20
    10e0:	00696f74 	rsbeq	r6, r9, r4, ror pc
    10e4:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    10e8:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    10ec:	73006e65 	movwvc	r6, #3685	; 0xe65
    10f0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    10f4:	65645f67 	strbvs	r5, [r4, #-3943]!	; 0xfffff099
    10f8:	616d6963 	cmnvs	sp, r3, ror #18
    10fc:	7000736c 	andvc	r7, r0, ip, ror #6
    1100:	7265776f 	rsbvc	r7, r5, #29097984	; 0x1bc0000
    1104:	72747300 	rsbsvc	r7, r4, #0, 6
    1108:	5f676e69 	svcpl	0x00676e69
    110c:	5f746e69 	svcpl	0x00746e69
    1110:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1114:	6f707865 	svcvs	0x00707865
    1118:	746e656e 	strbtvc	r6, [lr], #-1390	; 0xfffffa92
    111c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1120:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1124:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1128:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    112c:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1130:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    1134:	63507274 	cmpvs	r0, #116, 4	; 0x40000007
    1138:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    113c:	616e7369 	cmnvs	lr, r9, ror #6
    1140:	6900666e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, sp, lr}
    1144:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1148:	73616200 	cmnvc	r1, #0, 4
    114c:	65740065 	ldrbvs	r0, [r4, #-101]!	; 0xffffff9b
    1150:	5f00706d 	svcpl	0x0000706d
    1154:	7a62355a 	bvc	188e6c4 <__bss_end+0x1884d78>
    1158:	506f7265 	rsbpl	r7, pc, r5, ror #4
    115c:	73006976 	movwvc	r6, #2422	; 0x976
    1160:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1164:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    1168:	00616f74 	rsbeq	r6, r1, r4, ror pc
    116c:	31727473 	cmncc	r2, r3, ror r4
    1170:	72747300 	rsbsvc	r7, r4, #0, 6
    1174:	5f676e69 	svcpl	0x00676e69
    1178:	00746e69 	rsbseq	r6, r4, r9, ror #28
    117c:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1180:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    1184:	5a5f0066 	bpl	17c1324 <__bss_end+0x17b79d8>
    1188:	776f7033 			; <UNDEFINED> instruction: 0x776f7033
    118c:	5f006a66 	svcpl	0x00006a66
    1190:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    1194:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    1198:	6f6c665f 	svcvs	0x006c665f
    119c:	52667461 	rsbpl	r7, r6, #1627389952	; 0x61000000
    11a0:	525f536a 	subspl	r5, pc, #-1476395007	; 0xa8000001
    11a4:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    11a8:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    11ac:	73646d65 	cmnvc	r4, #6464	; 0x1940
    11b0:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    11b4:	6f437261 	svcvs	0x00437261
    11b8:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    11bc:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    11c0:	5f00616f 	svcpl	0x0000616f
    11c4:	6433325a 	ldrtvs	r3, [r3], #-602	; 0xfffffda6
    11c8:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    11cc:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 11d4 <shift+0x11d4>
    11d0:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    11d4:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    11d8:	6f6c665f 	svcvs	0x006c665f
    11dc:	506a7461 	rsbpl	r7, sl, r1, ror #8
    11e0:	6d006963 	vstrvs.16	s12, [r0, #-198]	; 0xffffff3a	; <UNPREDICTABLE>
    11e4:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    11e8:	72700063 	rsbsvc	r0, r0, #99	; 0x63
    11ec:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    11f0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    11f4:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    11f8:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    11fc:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1200:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
    1204:	73007865 	movwvc	r7, #2149	; 0x865
    1208:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    120c:	6400706d 	strvs	r7, [r0], #-109	; 0xffffff93
    1210:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    1214:	5a5f0073 	bpl	17c13e8 <__bss_end+0x17b7a9c>
    1218:	6f746134 	svcvs	0x00746134
    121c:	634b5069 	movtvs	r5, #45161	; 0xb069
    1220:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1224:	00747570 	rsbseq	r7, r4, r0, ror r5
    1228:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    122c:	66616f74 	uqsub16vs	r6, r1, r4
    1230:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1234:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    1238:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    123c:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1240:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    1244:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1248:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    124c:	4b506e65 	blmi	141cbe8 <__bss_end+0x141329c>
    1250:	5a5f0063 	bpl	17c13e4 <__bss_end+0x17b7a98>
    1254:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1258:	706d636e 	rsbvc	r6, sp, lr, ror #6
    125c:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    1260:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1264:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1268:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    126c:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    1270:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1274:	63656400 	cmnvs	r5, #0, 8
    1278:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    127c:	5f6f745f 	svcpl	0x006f745f
    1280:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1284:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    1288:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    128c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1290:	616f7466 	cmnvs	pc, r6, ror #8
    1294:	00635066 	rsbeq	r5, r3, r6, rrx
    1298:	6f6d656d 	svcvs	0x006d656d
    129c:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    12a0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    12a4:	74730068 	ldrbtvc	r0, [r3], #-104	; 0xffffff98
    12a8:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    12ac:	76657200 	strbtvc	r7, [r5], -r0, lsl #4
    12b0:	00727473 	rsbseq	r7, r2, r3, ror r4
    12b4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12b8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12bc:	2f2e2e2f 	svccs	0x002e2e2f
    12c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12c4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    12c8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    12cc:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    12d0:	2f676966 	svccs	0x00676966
    12d4:	2f6d7261 	svccs	0x006d7261
    12d8:	3162696c 	cmncc	r2, ip, ror #18
    12dc:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    12e0:	00532e73 	subseq	r2, r3, r3, ror lr
    12e4:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    12e8:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    12ec:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    12f0:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    12f4:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    12f8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    12fc:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1300:	2f39546b 	svccs	0x0039546b
    1304:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1308:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    130c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1310:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1314:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1318:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    131c:	2f34712d 	svccs	0x0034712d
    1320:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1324:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1328:	6f6e2d6d 	svcvs	0x006e2d6d
    132c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1330:	2f696261 	svccs	0x00696261
    1334:	2f6d7261 	svccs	0x006d7261
    1338:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    133c:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1340:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1344:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1348:	52415400 	subpl	r5, r1, #0, 8
    134c:	5f544547 	svcpl	0x00544547
    1350:	5f555043 	svcpl	0x00555043
    1354:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1358:	31617865 	cmncc	r1, r5, ror #16
    135c:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1360:	61786574 	cmnvs	r8, r4, ror r5
    1364:	73690037 	cmnvc	r9, #55	; 0x37
    1368:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    136c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1370:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1374:	6d726100 	ldfvse	f6, [r2, #-0]
    1378:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    137c:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1380:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1384:	52415400 	subpl	r5, r1, #0, 8
    1388:	5f544547 	svcpl	0x00544547
    138c:	5f555043 	svcpl	0x00555043
    1390:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1394:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1398:	52410033 	subpl	r0, r1, #51	; 0x33
    139c:	51455f4d 	cmppl	r5, sp, asr #30
    13a0:	52415400 	subpl	r5, r1, #0, 8
    13a4:	5f544547 	svcpl	0x00544547
    13a8:	5f555043 	svcpl	0x00555043
    13ac:	316d7261 	cmncc	sp, r1, ror #4
    13b0:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    13b4:	00736632 	rsbseq	r6, r3, r2, lsr r6
    13b8:	5f617369 	svcpl	0x00617369
    13bc:	5f746962 	svcpl	0x00746962
    13c0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    13c4:	41540062 	cmpmi	r4, r2, rrx
    13c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    13d4:	61786574 	cmnvs	r8, r4, ror r5
    13d8:	6f633735 	svcvs	0x00633735
    13dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13e0:	00333561 	eorseq	r3, r3, r1, ror #10
    13e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    13e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    13ec:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    13f0:	5341425f 	movtpl	r4, #4703	; 0x125f
    13f4:	41540045 	cmpmi	r4, r5, asr #32
    13f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1400:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1404:	00303138 	eorseq	r3, r0, r8, lsr r1
    1408:	47524154 			; <UNDEFINED> instruction: 0x47524154
    140c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1410:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1414:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1418:	52410031 	subpl	r0, r1, #49	; 0x31
    141c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1420:	41415f53 	cmpmi	r1, r3, asr pc
    1424:	5f534350 	svcpl	0x00534350
    1428:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    142c:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1430:	5f455341 	svcpl	0x00455341
    1434:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1438:	4200305f 	andmi	r3, r0, #95	; 0x5f
    143c:	5f455341 	svcpl	0x00455341
    1440:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1444:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1448:	5f455341 	svcpl	0x00455341
    144c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1450:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1454:	5f455341 	svcpl	0x00455341
    1458:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    145c:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1460:	5f455341 	svcpl	0x00455341
    1464:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1468:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    146c:	5f455341 	svcpl	0x00455341
    1470:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1474:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1478:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    147c:	50435f54 	subpl	r5, r3, r4, asr pc
    1480:	73785f55 	cmnvc	r8, #340	; 0x154
    1484:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1488:	61736900 	cmnvs	r3, r0, lsl #18
    148c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1490:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1494:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1498:	52415400 	subpl	r5, r1, #0, 8
    149c:	5f544547 	svcpl	0x00544547
    14a0:	5f555043 	svcpl	0x00555043
    14a4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    14a8:	336d7865 	cmncc	sp, #6619136	; 0x650000
    14ac:	41540033 	cmpmi	r4, r3, lsr r0
    14b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14bc:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    14c0:	73690069 	cmnvc	r9, #105	; 0x69
    14c4:	6f6e5f61 	svcvs	0x006e5f61
    14c8:	00746962 	rsbseq	r6, r4, r2, ror #18
    14cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14d4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    14d8:	31316d72 	teqcc	r1, r2, ror sp
    14dc:	7a6a3637 	bvc	1a8edc0 <__bss_end+0x1a85474>
    14e0:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    14e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    14e8:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    14ec:	32767066 	rsbscc	r7, r6, #102	; 0x66
    14f0:	4d524100 	ldfmie	f4, [r2, #-0]
    14f4:	5343505f 	movtpl	r5, #12383	; 0x305f
    14f8:	4b4e555f 	blmi	1396a7c <__bss_end+0x138d130>
    14fc:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1500:	52415400 	subpl	r5, r1, #0, 8
    1504:	5f544547 	svcpl	0x00544547
    1508:	5f555043 	svcpl	0x00555043
    150c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1510:	41420065 	cmpmi	r2, r5, rrx
    1514:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1518:	5f484352 	svcpl	0x00484352
    151c:	4a455435 	bmi	11565f8 <__bss_end+0x114ccac>
    1520:	6d726100 	ldfvse	f6, [r2, #-0]
    1524:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1528:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    152c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1530:	6d726100 	ldfvse	f6, [r2, #-0]
    1534:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1538:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    153c:	736e7500 	cmnvc	lr, #0, 10
    1540:	5f636570 	svcpl	0x00636570
    1544:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1548:	0073676e 	rsbseq	r6, r3, lr, ror #14
    154c:	5f617369 	svcpl	0x00617369
    1550:	5f746962 	svcpl	0x00746962
    1554:	00636573 	rsbeq	r6, r3, r3, ror r5
    1558:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    155c:	61745f7a 	cmnvs	r4, sl, ror pc
    1560:	52410062 	subpl	r0, r1, #98	; 0x62
    1564:	43565f4d 	cmpmi	r6, #308	; 0x134
    1568:	6d726100 	ldfvse	f6, [r2, #-0]
    156c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1570:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1574:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1578:	4d524100 	ldfmie	f4, [r2, #-0]
    157c:	00454c5f 	subeq	r4, r5, pc, asr ip
    1580:	5f4d5241 	svcpl	0x004d5241
    1584:	41005356 	tstmi	r0, r6, asr r3
    1588:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    158c:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1590:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1594:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1598:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    159c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    15a0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 15a8 <shift+0x15a8>
    15a4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    15a8:	6f6c6620 	svcvs	0x006c6620
    15ac:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    15b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15b4:	50435f54 	subpl	r5, r3, r4, asr pc
    15b8:	6f635f55 	svcvs	0x00635f55
    15bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15c0:	00353161 	eorseq	r3, r5, r1, ror #2
    15c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15cc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    15d0:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    15d4:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    15d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15dc:	50435f54 	subpl	r5, r3, r4, asr pc
    15e0:	6f635f55 	svcvs	0x00635f55
    15e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15e8:	00373161 	eorseq	r3, r7, r1, ror #2
    15ec:	5f4d5241 	svcpl	0x004d5241
    15f0:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    15f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15f8:	50435f54 	subpl	r5, r3, r4, asr pc
    15fc:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1600:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1604:	316e6573 	smccc	58963	; 0xe653
    1608:	2f2e2e00 	svccs	0x002e2e00
    160c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1610:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1614:	2f2e2e2f 	svccs	0x002e2e2f
    1618:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1568 <shift+0x1568>
    161c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1620:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1624:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1628:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    162c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1630:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1634:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1638:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    163c:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1640:	53414200 	movtpl	r4, #4608	; 0x1200
    1644:	52415f45 	subpl	r5, r1, #276	; 0x114
    1648:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    164c:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1650:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1654:	50435f54 	subpl	r5, r3, r4, asr pc
    1658:	6f635f55 	svcvs	0x00635f55
    165c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1660:	00323161 	eorseq	r3, r2, r1, ror #2
    1664:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1668:	5f6c6176 	svcpl	0x006c6176
    166c:	41420074 	hvcmi	8196	; 0x2004
    1670:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1674:	5f484352 	svcpl	0x00484352
    1678:	005a4b36 	subseq	r4, sl, r6, lsr fp
    167c:	5f617369 	svcpl	0x00617369
    1680:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1684:	6d726100 	ldfvse	f6, [r2, #-0]
    1688:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    168c:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1690:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1694:	00766964 	rsbseq	r6, r6, r4, ror #18
    1698:	5f6d7261 	svcpl	0x006d7261
    169c:	5f757066 	svcpl	0x00757066
    16a0:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    16a4:	61736900 	cmnvs	r3, r0, lsl #18
    16a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16ac:	3170665f 	cmncc	r0, pc, asr r6
    16b0:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    16b4:	31432055 	qdaddcc	r2, r5, r3
    16b8:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    16bc:	20312e32 	eorscs	r2, r1, r2, lsr lr
    16c0:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    16c4:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    16c8:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    16cc:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    16d0:	5b202965 	blpl	80bc6c <__bss_end+0x802320>
    16d4:	2f4d5241 	svccs	0x004d5241
    16d8:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    16dc:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    16e0:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    16e4:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    16e8:	6f697369 	svcvs	0x00697369
    16ec:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    16f0:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    16f4:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    16f8:	206d7261 	rsbcs	r7, sp, r1, ror #4
    16fc:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1700:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1704:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1708:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    170c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1710:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1714:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1718:	2b657435 	blcs	195e7f4 <__bss_end+0x1954ea8>
    171c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1720:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1724:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1728:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    172c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1730:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1734:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1738:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    173c:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1740:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1744:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1748:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    174c:	6b636174 	blvs	18d9d24 <__bss_end+0x18d03d8>
    1750:	6f72702d 	svcvs	0x0072702d
    1754:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1758:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    175c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 15cc <shift+0x15cc>
    1760:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1764:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1768:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    176c:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1770:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1774:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1778:	41006e65 	tstmi	r0, r5, ror #28
    177c:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1780:	73690049 	cmnvc	r9, #73	; 0x49
    1784:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1788:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    178c:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1790:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1794:	50435f54 	subpl	r5, r3, r4, asr pc
    1798:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    179c:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    17a0:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    17a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    17b0:	00386d72 	eorseq	r6, r8, r2, ror sp
    17b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17bc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    17c0:	00396d72 	eorseq	r6, r9, r2, ror sp
    17c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17cc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    17d0:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    17d4:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    17d8:	6f6c2067 	svcvs	0x006c2067
    17dc:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    17e0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    17e4:	2064656e 	rsbcs	r6, r4, lr, ror #10
    17e8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    17ec:	5f6d7261 	svcpl	0x006d7261
    17f0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17f4:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    17f8:	41540065 	cmpmi	r4, r5, rrx
    17fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1800:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1804:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1808:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    180c:	41540034 	cmpmi	r4, r4, lsr r0
    1810:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1814:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1818:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    181c:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1820:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1824:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1828:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    182c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1830:	00376d78 	eorseq	r6, r7, r8, ror sp
    1834:	5f6d7261 	svcpl	0x006d7261
    1838:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    183c:	646f635f 	strbtvs	r6, [pc], #-863	; 1844 <shift+0x1844>
    1840:	52410065 	subpl	r0, r1, #101	; 0x65
    1844:	43505f4d 	cmpmi	r0, #308	; 0x134
    1848:	41415f53 	cmpmi	r1, r3, asr pc
    184c:	00534350 	subseq	r4, r3, r0, asr r3
    1850:	5f617369 	svcpl	0x00617369
    1854:	5f746962 	svcpl	0x00746962
    1858:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    185c:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1860:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1864:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1868:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    186c:	52415400 	subpl	r5, r1, #0, 8
    1870:	5f544547 	svcpl	0x00544547
    1874:	5f555043 	svcpl	0x00555043
    1878:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    187c:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1880:	5f6d7261 	svcpl	0x006d7261
    1884:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1888:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    188c:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1890:	61736900 	cmnvs	r3, r0, lsl #18
    1894:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1898:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    189c:	41540073 	cmpmi	r4, r3, ror r0
    18a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    18ac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    18b0:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    18b4:	616d7373 	smcvs	55091	; 0xd733
    18b8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    18bc:	7069746c 	rsbvc	r7, r9, ip, ror #8
    18c0:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    18c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18c8:	50435f54 	subpl	r5, r3, r4, asr pc
    18cc:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    18d0:	736f6e79 	cmnvc	pc, #1936	; 0x790
    18d4:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    18d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18dc:	50435f54 	subpl	r5, r3, r4, asr pc
    18e0:	6f635f55 	svcvs	0x00635f55
    18e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18e8:	00323572 	eorseq	r3, r2, r2, ror r5
    18ec:	5f617369 	svcpl	0x00617369
    18f0:	5f746962 	svcpl	0x00746962
    18f4:	76696474 			; <UNDEFINED> instruction: 0x76696474
    18f8:	65727000 	ldrbvs	r7, [r2, #-0]!
    18fc:	5f726566 	svcpl	0x00726566
    1900:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1904:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1908:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    190c:	00737469 	rsbseq	r7, r3, r9, ror #8
    1910:	5f617369 	svcpl	0x00617369
    1914:	5f746962 	svcpl	0x00746962
    1918:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    191c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1920:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1924:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1928:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    192c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1930:	32336178 	eorscc	r6, r3, #120, 2
    1934:	52415400 	subpl	r5, r1, #0, 8
    1938:	5f544547 	svcpl	0x00544547
    193c:	5f555043 	svcpl	0x00555043
    1940:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1944:	33617865 	cmncc	r1, #6619136	; 0x650000
    1948:	73690035 	cmnvc	r9, #53	; 0x35
    194c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1950:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1954:	6f633631 	svcvs	0x00633631
    1958:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    195c:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1960:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    1964:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1968:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    196c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1970:	50435f54 	subpl	r5, r3, r4, asr pc
    1974:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1978:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    197c:	73327436 	teqvc	r2, #905969664	; 0x36000000
    1980:	52415400 	subpl	r5, r1, #0, 8
    1984:	5f544547 	svcpl	0x00544547
    1988:	5f555043 	svcpl	0x00555043
    198c:	30366166 	eorscc	r6, r6, r6, ror #2
    1990:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1994:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1998:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    199c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19a0:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    19a4:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    19a8:	53414200 	movtpl	r4, #4608	; 0x1200
    19ac:	52415f45 	subpl	r5, r1, #276	; 0x114
    19b0:	345f4843 	ldrbcc	r4, [pc], #-2115	; 19b8 <shift+0x19b8>
    19b4:	73690054 	cmnvc	r9, #84	; 0x54
    19b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19bc:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    19c0:	6f747079 	svcvs	0x00747079
    19c4:	6d726100 	ldfvse	f6, [r2, #-0]
    19c8:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    19cc:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    19d0:	7165735f 	cmnvc	r5, pc, asr r3
    19d4:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    19d8:	73690065 	cmnvc	r9, #101	; 0x65
    19dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19e0:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    19e4:	53414200 	movtpl	r4, #4608	; 0x1200
    19e8:	52415f45 	subpl	r5, r1, #276	; 0x114
    19ec:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 11b1 <shift+0x11b1>
    19f0:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    19f4:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    19f8:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    19fc:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1a00:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a04:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1a08:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1a0c:	006c756d 	rsbeq	r7, ip, sp, ror #10
    1a10:	5f6d7261 	svcpl	0x006d7261
    1a14:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    1a18:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    1a1c:	5f747570 	svcpl	0x00747570
    1a20:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    1a24:	615f7463 	cmpvs	pc, r3, ror #8
    1a28:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    1a2c:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    1a30:	6f685f73 	svcvs	0x00685f73
    1a34:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    1a38:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a3c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1a40:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1a44:	52410032 	subpl	r0, r1, #50	; 0x32
    1a48:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    1a4c:	61736900 	cmnvs	r3, r0, lsl #18
    1a50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a54:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    1a58:	52415400 	subpl	r5, r1, #0, 8
    1a5c:	5f544547 	svcpl	0x00544547
    1a60:	5f555043 	svcpl	0x00555043
    1a64:	316d7261 	cmncc	sp, r1, ror #4
    1a68:	6a363731 	bvs	d8f734 <__bss_end+0xd85de8>
    1a6c:	7000737a 	andvc	r7, r0, sl, ror r3
    1a70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1a74:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    1a78:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1a7c:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1a80:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    1a84:	61007375 	tstvs	r0, r5, ror r3
    1a88:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1a8c:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1a90:	5f455341 	svcpl	0x00455341
    1a94:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a98:	0054355f 	subseq	r3, r4, pc, asr r5
    1a9c:	5f6d7261 	svcpl	0x006d7261
    1aa0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1aa4:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1aa8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1aac:	50435f54 	subpl	r5, r3, r4, asr pc
    1ab0:	6f635f55 	svcvs	0x00635f55
    1ab4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ab8:	63363761 	teqvs	r6, #25427968	; 0x1840000
    1abc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ac0:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1ac4:	6d726100 	ldfvse	f6, [r2, #-0]
    1ac8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1acc:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1ad0:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1ad4:	5f626174 	svcpl	0x00626174
    1ad8:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1adc:	61736900 	cmnvs	r3, r0, lsl #18
    1ae0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ae4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1ae8:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1aec:	6f765f6f 	svcvs	0x00765f6f
    1af0:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1af4:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1af8:	41540065 	cmpmi	r4, r5, rrx
    1afc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b04:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b08:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1b0c:	41540030 	cmpmi	r4, r0, lsr r0
    1b10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b18:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b1c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1b20:	41540031 	cmpmi	r4, r1, lsr r0
    1b24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b30:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1b34:	73690033 	cmnvc	r9, #51	; 0x33
    1b38:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b3c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1b40:	5f38766d 	svcpl	0x0038766d
    1b44:	72610031 	rsbvc	r0, r1, #49	; 0x31
    1b48:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1b4c:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    1b50:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1b54:	5f617369 	svcpl	0x00617369
    1b58:	5f746962 	svcpl	0x00746962
    1b5c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1b60:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1b64:	5f617369 	svcpl	0x00617369
    1b68:	5f746962 	svcpl	0x00746962
    1b6c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1b70:	00345f38 	eorseq	r5, r4, r8, lsr pc
    1b74:	5f617369 	svcpl	0x00617369
    1b78:	5f746962 	svcpl	0x00746962
    1b7c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1b80:	00355f38 	eorseq	r5, r5, r8, lsr pc
    1b84:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b88:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b8c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b90:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b94:	33356178 	teqcc	r5, #120, 2
    1b98:	52415400 	subpl	r5, r1, #0, 8
    1b9c:	5f544547 	svcpl	0x00544547
    1ba0:	5f555043 	svcpl	0x00555043
    1ba4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ba8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1bac:	41540035 	cmpmi	r4, r5, lsr r0
    1bb0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bb4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bb8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1bbc:	61786574 	cmnvs	r8, r4, ror r5
    1bc0:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    1bc4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bc8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bcc:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1bd0:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1bd4:	52415400 	subpl	r5, r1, #0, 8
    1bd8:	5f544547 	svcpl	0x00544547
    1bdc:	5f555043 	svcpl	0x00555043
    1be0:	5f6d7261 	svcpl	0x006d7261
    1be4:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1be8:	6d726100 	ldfvse	f6, [r2, #-0]
    1bec:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1bf0:	6f6e5f68 	svcvs	0x006e5f68
    1bf4:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    1bf8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bfc:	50435f54 	subpl	r5, r3, r4, asr pc
    1c00:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c04:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    1c08:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1c0c:	53414200 	movtpl	r4, #4608	; 0x1200
    1c10:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c14:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1c18:	4142004a 	cmpmi	r2, sl, asr #32
    1c1c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c20:	5f484352 	svcpl	0x00484352
    1c24:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    1c28:	5f455341 	svcpl	0x00455341
    1c2c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c30:	004d365f 	subeq	r3, sp, pc, asr r6
    1c34:	5f617369 	svcpl	0x00617369
    1c38:	5f746962 	svcpl	0x00746962
    1c3c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1c40:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    1c44:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c48:	50435f54 	subpl	r5, r3, r4, asr pc
    1c4c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c50:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1c54:	73666a36 	cmnvc	r6, #221184	; 0x36000
    1c58:	4d524100 	ldfmie	f4, [r2, #-0]
    1c5c:	00534c5f 	subseq	r4, r3, pc, asr ip
    1c60:	5f4d5241 	svcpl	0x004d5241
    1c64:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    1c68:	5f455341 	svcpl	0x00455341
    1c6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c70:	005a365f 	subseq	r3, sl, pc, asr r6
    1c74:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c78:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c7c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c80:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c84:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    1c88:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c8c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1c90:	52410035 	subpl	r0, r1, #53	; 0x35
    1c94:	43505f4d 	cmpmi	r0, #308	; 0x134
    1c98:	41415f53 	cmpmi	r1, r3, asr pc
    1c9c:	5f534350 	svcpl	0x00534350
    1ca0:	00504656 	subseq	r4, r0, r6, asr r6
    1ca4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cac:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1cb0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1cb4:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1cb8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cbc:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1cc0:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1cc4:	5f6d7261 	svcpl	0x006d7261
    1cc8:	5f757066 	svcpl	0x00757066
    1ccc:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1cd0:	61736900 	cmnvs	r3, r0, lsl #18
    1cd4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cd8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cdc:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1ce0:	52415400 	subpl	r5, r1, #0, 8
    1ce4:	5f544547 	svcpl	0x00544547
    1ce8:	5f555043 	svcpl	0x00555043
    1cec:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1cf0:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1cf4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cf8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cfc:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1bc4 <shift+0x1bc4>
    1d00:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    1d04:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    1d08:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    1d0c:	5f626174 	svcpl	0x00626174
    1d10:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1d14:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    1d18:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1d1c:	6d726100 	ldfvse	f6, [r2, #-0]
    1d20:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1d24:	6f635f65 	svcvs	0x00635f65
    1d28:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d2c:	0039615f 	eorseq	r6, r9, pc, asr r1
    1d30:	5f617369 	svcpl	0x00617369
    1d34:	5f746962 	svcpl	0x00746962
    1d38:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1d3c:	00327478 	eorseq	r7, r2, r8, ror r4
    1d40:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d44:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d48:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d4c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d50:	32376178 	eorscc	r6, r7, #120, 2
    1d54:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d58:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1d5c:	73690033 	cmnvc	r9, #51	; 0x33
    1d60:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d64:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d68:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    1d6c:	53414200 	movtpl	r4, #4608	; 0x1200
    1d70:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d74:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1d78:	73690041 	cmnvc	r9, #65	; 0x41
    1d7c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d80:	6f645f74 	svcvs	0x00645f74
    1d84:	6f727074 	svcvs	0x00727074
    1d88:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1d8c:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1d90:	745f3631 	ldrbvc	r3, [pc], #-1585	; 1d98 <shift+0x1d98>
    1d94:	5f657079 	svcpl	0x00657079
    1d98:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    1d9c:	4d524100 	ldfmie	f4, [r2, #-0]
    1da0:	00494d5f 	subeq	r4, r9, pc, asr sp
    1da4:	5f6d7261 	svcpl	0x006d7261
    1da8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1dac:	61006b36 	tstvs	r0, r6, lsr fp
    1db0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1db4:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1db8:	4142006d 	cmpmi	r2, sp, rrx
    1dbc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1dc0:	5f484352 	svcpl	0x00484352
    1dc4:	5f005237 	svcpl	0x00005237
    1dc8:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    1dcc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1dd0:	61745f74 	cmnvs	r4, r4, ror pc
    1dd4:	73690062 	cmnvc	r9, #98	; 0x62
    1dd8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ddc:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1de0:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1de4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1de8:	50435f54 	subpl	r5, r3, r4, asr pc
    1dec:	6f635f55 	svcvs	0x00635f55
    1df0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1df4:	00333761 	eorseq	r3, r3, r1, ror #14
    1df8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dfc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e00:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    1e04:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    1e08:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    1e0c:	41540061 	cmpmi	r4, r1, rrx
    1e10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e18:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e1c:	61786574 	cmnvs	r8, r4, ror r5
    1e20:	61003637 	tstvs	r0, r7, lsr r6
    1e24:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e28:	5f686372 	svcpl	0x00686372
    1e2c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1e30:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1e34:	5f656c69 	svcpl	0x00656c69
    1e38:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    1e3c:	5f455341 	svcpl	0x00455341
    1e40:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e44:	0041385f 	subeq	r3, r1, pc, asr r8
    1e48:	5f617369 	svcpl	0x00617369
    1e4c:	5f746962 	svcpl	0x00746962
    1e50:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1e54:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    1e58:	5f455341 	svcpl	0x00455341
    1e5c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e60:	0052385f 	subseq	r3, r2, pc, asr r8
    1e64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e6c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e70:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e74:	33376178 	teqcc	r7, #120, 2
    1e78:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e7c:	33617865 	cmncc	r1, #6619136	; 0x650000
    1e80:	52410035 	subpl	r0, r1, #53	; 0x35
    1e84:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    1e88:	6d726100 	ldfvse	f6, [r2, #-0]
    1e8c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e90:	61003468 	tstvs	r0, r8, ror #8
    1e94:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e98:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1e9c:	6d726100 	ldfvse	f6, [r2, #-0]
    1ea0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ea4:	61003768 	tstvs	r0, r8, ror #14
    1ea8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1eac:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1eb0:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1eb4:	6f642067 	svcvs	0x00642067
    1eb8:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1ebc:	6d726100 	ldfvse	f6, [r2, #-0]
    1ec0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1ec4:	73785f65 	cmnvc	r8, #404	; 0x194
    1ec8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1ecc:	6b616d00 	blvs	185d2d4 <__bss_end+0x1853988>
    1ed0:	5f676e69 	svcpl	0x00676e69
    1ed4:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1ed8:	61745f74 	cmnvs	r4, r4, ror pc
    1edc:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1ee0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1ee4:	61635f62 	cmnvs	r3, r2, ror #30
    1ee8:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    1eec:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    1ef0:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    1ef4:	61736900 	cmnvs	r3, r0, lsl #18
    1ef8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1efc:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    1f00:	73690035 	cmnvc	r9, #53	; 0x35
    1f04:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f08:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1f0c:	6b36766d 	blvs	d9f8c8 <__bss_end+0xd95f7c>
    1f10:	52415400 	subpl	r5, r1, #0, 8
    1f14:	5f544547 	svcpl	0x00544547
    1f18:	5f555043 	svcpl	0x00555043
    1f1c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f20:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1f24:	52415400 	subpl	r5, r1, #0, 8
    1f28:	5f544547 	svcpl	0x00544547
    1f2c:	5f555043 	svcpl	0x00555043
    1f30:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f34:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1f38:	52415400 	subpl	r5, r1, #0, 8
    1f3c:	5f544547 	svcpl	0x00544547
    1f40:	5f555043 	svcpl	0x00555043
    1f44:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f48:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1f4c:	4d524100 	ldfmie	f4, [r2, #-0]
    1f50:	5343505f 	movtpl	r5, #12383	; 0x305f
    1f54:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    1f58:	52410053 	subpl	r0, r1, #83	; 0x53
    1f5c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1f60:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    1f64:	00534350 	subseq	r4, r3, r0, asr r3
    1f68:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1f6c:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1f70:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1f74:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    1f78:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f7c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f80:	6f635f55 	svcvs	0x00635f55
    1f84:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f88:	63333761 	teqvs	r3, #25427968	; 0x1840000
    1f8c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f90:	33356178 	teqcc	r5, #120, 2
    1f94:	52415400 	subpl	r5, r1, #0, 8
    1f98:	5f544547 	svcpl	0x00544547
    1f9c:	5f555043 	svcpl	0x00555043
    1fa0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1fa4:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1fa8:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1fac:	6d726100 	ldfvse	f6, [r2, #-0]
    1fb0:	0063635f 	rsbeq	r6, r3, pc, asr r3
    1fb4:	5f617369 	svcpl	0x00617369
    1fb8:	5f746962 	svcpl	0x00746962
    1fbc:	61637378 	smcvs	14136	; 0x3738
    1fc0:	5f00656c 	svcpl	0x0000656c
    1fc4:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    1fc8:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    1fcc:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    1fd0:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    1fd4:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    1fd8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fdc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fe0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fe4:	30316d72 	eorscc	r6, r1, r2, ror sp
    1fe8:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1fec:	52415400 	subpl	r5, r1, #0, 8
    1ff0:	5f544547 	svcpl	0x00544547
    1ff4:	5f555043 	svcpl	0x00555043
    1ff8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ffc:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2000:	73616200 	cmnvc	r1, #0, 4
    2004:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2008:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    200c:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2010:	61006572 	tstvs	r0, r2, ror r5
    2014:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2018:	5f686372 	svcpl	0x00686372
    201c:	00637263 	rsbeq	r7, r3, r3, ror #4
    2020:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2024:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2028:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    202c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2030:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    2034:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2038:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    203c:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2040:	6d726100 	ldfvse	f6, [r2, #-0]
    2044:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    2048:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    204c:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2050:	5f617369 	svcpl	0x00617369
    2054:	5f746962 	svcpl	0x00746962
    2058:	33637263 	cmncc	r3, #805306374	; 0x30000006
    205c:	52410032 	subpl	r0, r1, #50	; 0x32
    2060:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2064:	61736900 	cmnvs	r3, r0, lsl #18
    2068:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    206c:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2070:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    2074:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2078:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    207c:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2080:	53414200 	movtpl	r4, #4608	; 0x1200
    2084:	52415f45 	subpl	r5, r1, #276	; 0x114
    2088:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    208c:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    2090:	5f455341 	svcpl	0x00455341
    2094:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2098:	5f4d385f 	svcpl	0x004d385f
    209c:	4e49414d 	dvfmiem	f4, f1, #5.0
    20a0:	52415400 	subpl	r5, r1, #0, 8
    20a4:	5f544547 	svcpl	0x00544547
    20a8:	5f555043 	svcpl	0x00555043
    20ac:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    20b0:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    20b4:	4d524100 	ldfmie	f4, [r2, #-0]
    20b8:	004c415f 	subeq	r4, ip, pc, asr r1
    20bc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20c0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20c4:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    20c8:	6d726100 	ldfvse	f6, [r2, #-0]
    20cc:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    20d0:	5f746567 	svcpl	0x00746567
    20d4:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    20d8:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    20dc:	61745f6d 	cmnvs	r4, sp, ror #30
    20e0:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    20e4:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    20e8:	4154006e 	cmpmi	r4, lr, rrx
    20ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20f4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    20f8:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    20fc:	41540034 	cmpmi	r4, r4, lsr r0
    2100:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2104:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2108:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    210c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2110:	41540035 	cmpmi	r4, r5, lsr r0
    2114:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2118:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    211c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2120:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2124:	41540037 	cmpmi	r4, r7, lsr r0
    2128:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    212c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2130:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2134:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2138:	73690038 	cmnvc	r9, #56	; 0x38
    213c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2140:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    2144:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    2148:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    214c:	715f7469 	cmpvc	pc, r9, ror #8
    2150:	6b726975 	blvs	1c9c72c <__bss_end+0x1c92de0>
    2154:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2158:	7a6b3676 	bvc	1acfb38 <__bss_end+0x1ac61ec>
    215c:	61736900 	cmnvs	r3, r0, lsl #18
    2160:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2164:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 216c <shift+0x216c>
    2168:	7369006d 	cmnvc	r9, #109	; 0x6d
    216c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2170:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2174:	0034766d 	eorseq	r7, r4, sp, ror #12
    2178:	5f617369 	svcpl	0x00617369
    217c:	5f746962 	svcpl	0x00746962
    2180:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2184:	73690036 	cmnvc	r9, #54	; 0x36
    2188:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    218c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2190:	0037766d 	eorseq	r7, r7, sp, ror #12
    2194:	5f617369 	svcpl	0x00617369
    2198:	5f746962 	svcpl	0x00746962
    219c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    21a0:	645f0038 	ldrbvs	r0, [pc], #-56	; 21a8 <shift+0x21a8>
    21a4:	5f746e6f 	svcpl	0x00746e6f
    21a8:	5f657375 	svcpl	0x00657375
    21ac:	5f787472 	svcpl	0x00787472
    21b0:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    21b4:	5155005f 	cmppl	r5, pc, asr r0
    21b8:	70797449 	rsbsvc	r7, r9, r9, asr #8
    21bc:	73690065 	cmnvc	r9, #101	; 0x65
    21c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21c4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    21c8:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    21cc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    21d0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    21d4:	6100656e 	tstvs	r0, lr, ror #10
    21d8:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    21dc:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    21e0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    21e4:	6b726f77 	blvs	1c9dfc8 <__bss_end+0x1c9467c>
    21e8:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    21ec:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    21f0:	41540072 	cmpmi	r4, r2, ror r0
    21f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21fc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2200:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2204:	61746800 	cmnvs	r4, r0, lsl #16
    2208:	71655f62 	cmnvc	r5, r2, ror #30
    220c:	52415400 	subpl	r5, r1, #0, 8
    2210:	5f544547 	svcpl	0x00544547
    2214:	5f555043 	svcpl	0x00555043
    2218:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    221c:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2220:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2224:	745f6863 	ldrbvc	r6, [pc], #-2147	; 222c <shift+0x222c>
    2228:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    222c:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2230:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2234:	5f626174 	svcpl	0x00626174
    2238:	705f7165 	subsvc	r7, pc, r5, ror #2
    223c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2240:	61007265 	tstvs	r0, r5, ror #4
    2244:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2248:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    224c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    2250:	00726574 	rsbseq	r6, r2, r4, ror r5
    2254:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2258:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    225c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2260:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2264:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2268:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    226c:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2270:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2274:	52415400 	subpl	r5, r1, #0, 8
    2278:	5f544547 	svcpl	0x00544547
    227c:	5f555043 	svcpl	0x00555043
    2280:	6f63706d 	svcvs	0x0063706d
    2284:	6f6e6572 	svcvs	0x006e6572
    2288:	00706676 	rsbseq	r6, r0, r6, ror r6
    228c:	5f617369 	svcpl	0x00617369
    2290:	5f746962 	svcpl	0x00746962
    2294:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2298:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    229c:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    22a0:	41006472 	tstmi	r0, r2, ror r4
    22a4:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    22a8:	72610043 	rsbvc	r0, r1, #67	; 0x43
    22ac:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    22b0:	5f386863 	svcpl	0x00386863
    22b4:	72610032 	rsbvc	r0, r1, #50	; 0x32
    22b8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    22bc:	5f386863 	svcpl	0x00386863
    22c0:	72610033 	rsbvc	r0, r1, #51	; 0x33
    22c4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    22c8:	5f386863 	svcpl	0x00386863
    22cc:	41540034 	cmpmi	r4, r4, lsr r0
    22d0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22d4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22d8:	706d665f 	rsbvc	r6, sp, pc, asr r6
    22dc:	00363236 	eorseq	r3, r6, r6, lsr r2
    22e0:	5f4d5241 	svcpl	0x004d5241
    22e4:	61005343 	tstvs	r0, r3, asr #6
    22e8:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    22ec:	5f363170 	svcpl	0x00363170
    22f0:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    22f4:	6d726100 	ldfvse	f6, [r2, #-0]
    22f8:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    22fc:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2300:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2304:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2308:	50435f54 	subpl	r5, r3, r4, asr pc
    230c:	6f635f55 	svcvs	0x00635f55
    2310:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2314:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    2318:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    231c:	00376178 	eorseq	r6, r7, r8, ror r1
    2320:	5f6d7261 	svcpl	0x006d7261
    2324:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2328:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    232c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2330:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2334:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2338:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    233c:	32376178 	eorscc	r6, r7, #120, 2
    2340:	6d726100 	ldfvse	f6, [r2, #-0]
    2344:	7363705f 	cmnvc	r3, #95	; 0x5f
    2348:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    234c:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2350:	4d524100 	ldfmie	f4, [r2, #-0]
    2354:	5343505f 	movtpl	r5, #12383	; 0x305f
    2358:	5041415f 	subpl	r4, r1, pc, asr r1
    235c:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2360:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2364:	52415400 	subpl	r5, r1, #0, 8
    2368:	5f544547 	svcpl	0x00544547
    236c:	5f555043 	svcpl	0x00555043
    2370:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2374:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2378:	41540035 	cmpmi	r4, r5, lsr r0
    237c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2380:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2384:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2388:	61676e6f 	cmnvs	r7, pc, ror #28
    238c:	61006d72 	tstvs	r0, r2, ror sp
    2390:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2394:	5f686372 	svcpl	0x00686372
    2398:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    239c:	61003162 	tstvs	r0, r2, ror #2
    23a0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23a4:	5f686372 	svcpl	0x00686372
    23a8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    23ac:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    23b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23b4:	50435f54 	subpl	r5, r3, r4, asr pc
    23b8:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    23bc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    23c0:	6d726100 	ldfvse	f6, [r2, #-0]
    23c4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23c8:	00743568 	rsbseq	r3, r4, r8, ror #10
    23cc:	5f617369 	svcpl	0x00617369
    23d0:	5f746962 	svcpl	0x00746962
    23d4:	6100706d 	tstvs	r0, sp, rrx
    23d8:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    23dc:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    23e0:	00646568 	rsbeq	r6, r4, r8, ror #10
    23e4:	5f6d7261 	svcpl	0x006d7261
    23e8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    23ec:	00315f38 	eorseq	r5, r1, r8, lsr pc

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	0000005c 	andeq	r0, r0, ip, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9fe4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346ee4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa004>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9334>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa034>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346f34>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa054>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346f54>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa074>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346f74>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa094>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346f94>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa0b4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346fb4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa0d4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346fd4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa0f4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346ff4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa10c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa12c>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa15c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008274 	andeq	r8, r0, r4, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa188>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347088>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a0 	andeq	r8, r0, r0, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa1a8>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3470a8>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082cc 	andeq	r8, r0, ip, asr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa1c8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3470c8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082e8 	andeq	r8, r0, r8, ror #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa1e8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3470e8>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	0000832c 	andeq	r8, r0, ip, lsr #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa208>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347108>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000837c 	andeq	r8, r0, ip, ror r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa228>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347128>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083cc 	andeq	r8, r0, ip, asr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa248>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347148>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa268>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347168>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008448 	andeq	r8, r0, r8, asr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa288>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347188>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000848c 	andeq	r8, r0, ip, lsl #9
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa2a8>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x3471a8>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084dc 	ldrdeq	r8, [r0], -ip
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa2c8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3471c8>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008530 	andeq	r8, r0, r0, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa2e8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3471e8>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000856c 	andeq	r8, r0, ip, ror #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa308>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347208>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085a8 	andeq	r8, r0, r8, lsr #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa328>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347228>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085e4 	andeq	r8, r0, r4, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa348>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347248>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008620 	andeq	r8, r0, r0, lsr #12
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa368>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086d0 	ldrdeq	r8, [r0], -r0
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa398>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008844 	andeq	r8, r0, r4, asr #16
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa3b8>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3472b8>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088e0 	andeq	r8, r0, r0, ror #17
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa3d8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3472d8>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	000089a0 	andeq	r8, r0, r0, lsr #19
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa3f8>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3472f8>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008a4c 	andeq	r8, r0, ip, asr #20
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa418>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347318>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008aa0 	andeq	r8, r0, r0, lsr #21
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa438>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347338>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b08 	andeq	r8, r0, r8, lsl #22
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa458>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347358>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008b88 	andeq	r8, r0, r8, lsl #23
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa478>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347378>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008bf4 	strdeq	r8, [r0], -r4
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa498>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa4b8>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3473b8>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	000090f8 	strdeq	r9, [r0], -r8
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa4dc>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	000091cc 	andeq	r9, r0, ip, asr #3
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa4fc>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x3473fc>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	00009208 	andeq	r9, r0, r8, lsl #4
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa51c>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x34741c>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	00009248 	andeq	r9, r0, r8, asr #4
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa53c>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	00009278 	andeq	r9, r0, r8, ror r2
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa55c>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	0000959c 	muleq	r0, ip, r5
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa580>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x347480>
 5c4:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 5c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 5cc:	0000000c 	andeq	r0, r0, ip
 5d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5d4:	7c010001 	stcvc	0, cr0, [r1], {1}
 5d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	000005cc 	andeq	r0, r0, ip, asr #11
 5e4:	000096ac 	andeq	r9, r0, ip, lsr #13
 5e8:	000001ec 	andeq	r0, r0, ip, ror #3
