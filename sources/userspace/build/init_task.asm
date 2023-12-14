
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
    805c:	0000995c 	andeq	r9, r0, ip, asr r9
    8060:	0000996c 	andeq	r9, r0, ip, ror #18

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
    81cc:	00009959 	andeq	r9, r0, r9, asr r9
    81d0:	00009959 	andeq	r9, r0, r9, asr r9

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
    8224:	00009959 	andeq	r9, r0, r9, asr r9
    8228:	00009959 	andeq	r9, r0, r9, asr r9

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
    86cc:	00009938 	andeq	r9, r0, r8, lsr r9

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
    8840:	00009948 	andeq	r9, r0, r8, asr #18

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
    90b4:	0a4fb11f 	beq	13f5538 <__bss_end+0x13ebbcc>
    90b8:	5a0e1bca 	bpl	38ffe8 <__bss_end+0x38667c>
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
    90ec:	3a83126f 	bcc	fe0cdab0 <__bss_end+0xfe0c4144>
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

000098bc <_ZL9INT32_MAX>:
    98bc:	7fffffff 	svcvc	0x00ffffff

000098c0 <_ZL9INT32_MIN>:
    98c0:	80000000 	andhi	r0, r0, r0

000098c4 <_ZL10UINT32_MAX>:
    98c4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098c8 <_ZL10UINT32_MIN>:
    98c8:	00000000 	andeq	r0, r0, r0

000098cc <_ZL13Lock_Unlocked>:
    98cc:	00000000 	andeq	r0, r0, r0

000098d0 <_ZL11Lock_Locked>:
    98d0:	00000001 	andeq	r0, r0, r1

000098d4 <_ZL21MaxFSDriverNameLength>:
    98d4:	00000010 	andeq	r0, r0, r0, lsl r0

000098d8 <_ZL17MaxFilenameLength>:
    98d8:	00000010 	andeq	r0, r0, r0, lsl r0

000098dc <_ZL13MaxPathLength>:
    98dc:	00000080 	andeq	r0, r0, r0, lsl #1

000098e0 <_ZL18NoFilesystemDriver>:
    98e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098e4 <_ZL9NotifyAll>:
    98e4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098e8 <_ZL24Max_Process_Opened_Files>:
    98e8:	00000010 	andeq	r0, r0, r0, lsl r0

000098ec <_ZL10Indefinite>:
    98ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098f0 <_ZL18Deadline_Unchanged>:
    98f0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000098f4 <_ZL14Invalid_Handle>:
    98f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000098f8 <_ZL9INT32_MAX>:
    98f8:	7fffffff 	svcvc	0x00ffffff

000098fc <_ZL9INT32_MIN>:
    98fc:	80000000 	andhi	r0, r0, r0

00009900 <_ZL10UINT32_MAX>:
    9900:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009904 <_ZL10UINT32_MIN>:
    9904:	00000000 	andeq	r0, r0, r0

00009908 <_ZL13Lock_Unlocked>:
    9908:	00000000 	andeq	r0, r0, r0

0000990c <_ZL11Lock_Locked>:
    990c:	00000001 	andeq	r0, r0, r1

00009910 <_ZL21MaxFSDriverNameLength>:
    9910:	00000010 	andeq	r0, r0, r0, lsl r0

00009914 <_ZL17MaxFilenameLength>:
    9914:	00000010 	andeq	r0, r0, r0, lsl r0

00009918 <_ZL13MaxPathLength>:
    9918:	00000080 	andeq	r0, r0, r0, lsl #1

0000991c <_ZL18NoFilesystemDriver>:
    991c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009920 <_ZL9NotifyAll>:
    9920:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009924 <_ZL24Max_Process_Opened_Files>:
    9924:	00000010 	andeq	r0, r0, r0, lsl r0

00009928 <_ZL10Indefinite>:
    9928:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000992c <_ZL18Deadline_Unchanged>:
    992c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009930 <_ZL14Invalid_Handle>:
    9930:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009934 <_ZL8INFINITY>:
    9934:	7f7fffff 	svcvc	0x007fffff

00009938 <_ZL16Pipe_File_Prefix>:
    9938:	3a535953 	bcc	14dfe8c <__bss_end+0x14d6520>
    993c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9940:	0000002f 	andeq	r0, r0, pc, lsr #32

00009944 <_ZL8INFINITY>:
    9944:	7f7fffff 	svcvc	0x007fffff

00009948 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9948:	33323130 	teqcc	r2, #48, 2
    994c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9950:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9954:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

0000995c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683ec0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38ab8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c6cc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c73b8>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfcd0>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36f9a>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff6463>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x15742c>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7834>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x77868>
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
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfe48>
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
 248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff657f>
 24c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 250:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 254:	2f2e2e2f 	svccs	0x002e2e2f
 258:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 25c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 260:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 264:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 268:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 26c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 270:	61682f30 	cmnvs	r8, r0, lsr pc
 274:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 278:	2f656d6f 	svccs	0x00656d6f
 27c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 280:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 284:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 288:	2f736f2f 	svccs	0x00736f2f
 28c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 290:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff65cb>
 298:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 29c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2a0:	2f2e2e2f 	svccs	0x002e2e2f
 2a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2b0:	702f6564 	eorvc	r6, pc, r4, ror #10
 2b4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2b8:	2f007373 	svccs	0x00007373
 2bc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2c0:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 2c4:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 2c8:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 2cc:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 2d0:	2f70732f 	svccs	0x0070732f
 2d4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2d8:	2f736563 	svccs	0x00736563
 2dc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2e0:	63617073 	cmnvs	r1, #115	; 0x73
 2e4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2e8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2ec:	2f6c656e 	svccs	0x006c656e
 2f0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2f4:	2f656475 	svccs	0x00656475
 2f8:	00007366 	andeq	r7, r0, r6, ror #6
 2fc:	6e69616d 	powvsez	f6, f1, #5.0
 300:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 304:	00000100 	andeq	r0, r0, r0, lsl #2
 308:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 30c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 310:	00000200 	andeq	r0, r0, r0, lsl #4
 314:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 318:	00030068 	andeq	r0, r3, r8, rrx
 31c:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 320:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 324:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 328:	66000003 	strvs	r0, [r0], -r3
 32c:	73656c69 	cmnvc	r5, #26880	; 0x6900
 330:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 334:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 338:	70000004 	andvc	r0, r0, r4
 33c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 340:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 344:	00000300 	andeq	r0, r0, r0, lsl #6
 348:	636f7270 	cmnvs	pc, #112, 4
 34c:	5f737365 	svcpl	0x00737365
 350:	616e616d 	cmnvs	lr, sp, ror #2
 354:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 358:	00030068 	andeq	r0, r3, r8, rrx
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
 3a0:	6a2f656d 	bvs	bd995c <__bss_end+0xbcfff0>
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
 3cc:	6a2f656d 	bvs	bd9988 <__bss_end+0xbd001c>
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
 3f8:	616f622f 	cmnvs	pc, pc, lsr #4
 3fc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 400:	2f306970 	svccs	0x00306970
 404:	006c6168 	rsbeq	r6, ip, r8, ror #2
 408:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 354 <shift+0x354>
 40c:	616a2f65 	cmnvs	sl, r5, ror #30
 410:	6173656d 	cmnvs	r3, sp, ror #10
 414:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 418:	6f2f7469 	svcvs	0x002f7469
 41c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 420:	756f732f 	strbvc	r7, [pc, #-815]!	; f9 <shift+0xf9>
 424:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 428:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 42c:	2f6c656e 	svccs	0x006c656e
 430:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 434:	2f656475 	svccs	0x00656475
 438:	636f7270 	cmnvs	pc, #112, 4
 43c:	00737365 	rsbseq	r7, r3, r5, ror #6
 440:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 38c <shift+0x38c>
 444:	616a2f65 	cmnvs	sl, r5, ror #30
 448:	6173656d 	cmnvs	r3, sp, ror #10
 44c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 450:	6f2f7469 	svcvs	0x002f7469
 454:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 458:	756f732f 	strbvc	r7, [pc, #-815]!	; 131 <shift+0x131>
 45c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 460:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 464:	2f6c656e 	svccs	0x006c656e
 468:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 46c:	2f656475 	svccs	0x00656475
 470:	2f007366 	svccs	0x00007366
 474:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 478:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 47c:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 480:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 484:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 488:	2f70732f 	svccs	0x0070732f
 48c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 490:	2f736563 	svccs	0x00736563
 494:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 498:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
 49c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4a0:	00006564 	andeq	r6, r0, r4, ror #10
 4a4:	66647473 			; <UNDEFINED> instruction: 0x66647473
 4a8:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 4ac:	00707063 	rsbseq	r7, r0, r3, rrx
 4b0:	69000001 	stmdbvs	r0, {r0}
 4b4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 4b8:	00682e66 	rsbeq	r2, r8, r6, ror #28
 4bc:	73000002 	movwvc	r0, #2
 4c0:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 4c4:	00000300 	andeq	r0, r0, r0, lsl #6
 4c8:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 4cc:	6b636f6c 	blvs	18dc284 <__bss_end+0x18d2918>
 4d0:	0300682e 	movweq	r6, #2094	; 0x82e
 4d4:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 4d8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 4dc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 4e0:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 4e4:	72700000 	rsbsvc	r0, r0, #0
 4e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 4ec:	00682e73 	rsbeq	r2, r8, r3, ror lr
 4f0:	70000003 	andvc	r0, r0, r3
 4f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4f8:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 334 <shift+0x334>
 4fc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 500:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 504:	00000300 	andeq	r0, r0, r0, lsl #6
 508:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 50c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 510:	00682e67 	rsbeq	r2, r8, r7, ror #28
 514:	00000005 	andeq	r0, r0, r5
 518:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 51c:	00827402 	addeq	r7, r2, r2, lsl #8
 520:	1a051600 	bne	145d28 <__bss_end+0x13c3bc>
 524:	2f2c0569 	svccs	0x002c0569
 528:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 52c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 530:	1a058332 	bne	161200 <__bss_end+0x157894>
 534:	2f01054b 	svccs	0x0001054b
 538:	4b1a0585 	blmi	681b54 <__bss_end+0x6781e8>
 53c:	852f0105 	strhi	r0, [pc, #-261]!	; 43f <shift+0x43f>
 540:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 544:	1b054b2e 	blne	153204 <__bss_end+0x149898>
 548:	2f2d054b 	svccs	0x002d054b
 54c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 550:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 554:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 558:	4b2e054b 	blmi	b81a8c <__bss_end+0xb78120>
 55c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 560:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 564:	2f01054c 	svccs	0x0001054c
 568:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 56c:	054b3005 	strbeq	r3, [fp, #-5]
 570:	1b054b2e 	blne	153230 <__bss_end+0x1498c4>
 574:	2f2e054b 	svccs	0x002e054b
 578:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 57c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 580:	1b05832e 	blne	161240 <__bss_end+0x1578d4>
 584:	2f01054b 	svccs	0x0001054b
 588:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 58c:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 590:	1b054b2f 	blne	153254 <__bss_end+0x1498e8>
 594:	2f30054b 	svccs	0x0030054b
 598:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 59c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5a0:	2f05a12e 	svccs	0x0005a12e
 5a4:	4b1b054b 	blmi	6c1ad8 <__bss_end+0x6b816c>
 5a8:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff6ab <__bss_end+0xffff5d3f>
 5ac:	01054c0c 	tsteq	r5, ip, lsl #24
 5b0:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 5b4:	4b2f05bd 	blmi	bc1cb0 <__bss_end+0xbb8344>
 5b8:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 5bc:	30054b1b 	andcc	r4, r5, fp, lsl fp
 5c0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5c4:	852f0105 	strhi	r0, [pc, #-261]!	; 4c7 <shift+0x4c7>
 5c8:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 5cc:	1a054b3b 	bne	1532c0 <__bss_end+0x149954>
 5d0:	2f30054b 	svccs	0x0030054b
 5d4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5d8:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 5dc:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 5e0:	4b31054d 	blmi	c41b1c <__bss_end+0xc381b0>
 5e4:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5e8:	0105300c 	tsteq	r5, ip
 5ec:	2005852f 	andcs	r8, r5, pc, lsr #10
 5f0:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 5f4:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 5f8:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 5fc:	2f010530 	svccs	0x00010530
 600:	83200585 			; <UNDEFINED> instruction: 0x83200585
 604:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 608:	1a054b3e 	bne	153308 <__bss_end+0x14999c>
 60c:	2f01054b 	svccs	0x0001054b
 610:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 614:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 618:	1a054b30 	bne	1532e0 <__bss_end+0x149974>
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
 6f0:	ba0a0568 	blt	281c98 <__bss_end+0x27832c>
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
 720:	4b03054a 	blmi	c1c50 <__bss_end+0xb82e4>
 724:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 728:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 72c:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 730:	03040200 	movweq	r0, #16896	; 0x4200
 734:	0015059e 	mulseq	r5, lr, r5
 738:	68020402 	stmdavs	r2, {r1, sl}
 73c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 740:	05820204 	streq	r0, [r2, #516]	; 0x204
 744:	04020008 	streq	r0, [r2], #-8
 748:	1a054a02 	bne	152f58 <__bss_end+0x1495ec>
 74c:	02040200 	andeq	r0, r4, #0, 4
 750:	001b054b 	andseq	r0, fp, fp, asr #10
 754:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 758:	02000c05 	andeq	r0, r0, #1280	; 0x500
 75c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 760:	0402000f 	streq	r0, [r2], #-15
 764:	1b058202 	blne	160f74 <__bss_end+0x157608>
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
 7b0:	4a010402 	bmi	417c0 <__bss_end+0x37e54>
 7b4:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 7b8:	0a054a14 	beq	153010 <__bss_end+0x1496a4>
 7bc:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 7c0:	78030205 	stmdavc	r3, {r0, r2, r9}
 7c4:	03090566 	movweq	r0, #38246	; 0x9566
 7c8:	01052e0b 	tsteq	r5, fp, lsl #28
 7cc:	0905852f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 7d0:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
 7d4:	4a040402 	bmi	1017e4 <__bss_end+0xf7e78>
 7d8:	02001d05 	andeq	r1, r0, #320	; 0x140
 7dc:	05820204 	streq	r0, [r2, #516]	; 0x204
 7e0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 7e4:	16052e02 	strne	r2, [r5], -r2, lsl #28
 7e8:	02040200 	andeq	r0, r4, #0, 4
 7ec:	00110566 	andseq	r0, r1, r6, ror #10
 7f0:	4b030402 	blmi	c1800 <__bss_end+0xb7e94>
 7f4:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 7f8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 7fc:	04020008 	streq	r0, [r2], #-8
 800:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
 804:	03040200 	movweq	r0, #16896	; 0x4200
 808:	0012052e 	andseq	r0, r2, lr, lsr #10
 80c:	4a030402 	bmi	c181c <__bss_end+0xb7eb0>
 810:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 814:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 818:	04020002 	streq	r0, [r2], #-2
 81c:	0b052d03 	bleq	14bc30 <__bss_end+0x1422c4>
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
 8b8:	4b0805bb 	blmi	201fac <__bss_end+0x1f8640>
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
 904:	4a030402 	bmi	c1914 <__bss_end+0xb7fa8>
 908:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 90c:	05830204 	streq	r0, [r3, #516]	; 0x204
 910:	04020005 	streq	r0, [r2], #-5
 914:	0c058102 	stfeqd	f0, [r5], {2}
 918:	4b010585 	blmi	41f34 <__bss_end+0x385c8>
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
 97c:	1b056602 	blne	15a18c <__bss_end+0x150820>
 980:	02040200 	andeq	r0, r4, #0, 4
 984:	00050566 	andeq	r0, r5, r6, ror #10
 988:	62020402 	andvs	r0, r2, #33554432	; 0x2000000
 98c:	69880105 	stmibvs	r8, {r0, r2, r8}
 990:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 994:	1a059f09 	bne	1685c0 <__bss_end+0x15ec54>
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
 9d8:	1a059f09 	bne	168604 <__bss_end+0x15ec98>
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
 a04:	1a059f09 	bne	168630 <__bss_end+0x15ecc4>
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
 a48:	1a059f09 	bne	168674 <__bss_end+0x15ed08>
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
 a80:	4a12054b 	bmi	481fb4 <__bss_end+0x478648>
 a84:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
 a88:	01054a05 	tsteq	r5, r5, lsl #20
 a8c:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 a90:	2e760309 	cdpcs	3, 7, cr0, cr6, cr9, {0}
 a94:	054a1005 	strbeq	r1, [sl, #-5]
 a98:	0905670c 	stmdbeq	r5, {r2, r3, r8, r9, sl, sp, lr}
 a9c:	6715054a 	ldrvs	r0, [r5, -sl, asr #10]
 aa0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 aa4:	10054a15 	andne	r4, r5, r5, lsl sl
 aa8:	4a0d0567 	bmi	34204c <__bss_end+0x3386e0>
 aac:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 ab0:	19056711 	stmdbne	r5, {r0, r4, r8, r9, sl, sp, lr}
 ab4:	6a01054a 	bvs	41fe4 <__bss_end+0x38678>
 ab8:	05152e02 	ldreq	r2, [r5, #-3586]	; 0xfffff1fe
 abc:	1205bb06 	andne	fp, r5, #6144	; 0x1800
 ac0:	6615054b 	ldrvs	r0, [r5], -fp, asr #10
 ac4:	05bb2005 	ldreq	r2, [fp, #5]!
 ac8:	05200823 	streq	r0, [r0, #-2083]!	; 0xfffff7dd
 acc:	14052e12 	strne	r2, [r5], #-3602	; 0xfffff1ee
 ad0:	4a230582 	bmi	8c20e0 <__bss_end+0x8b8774>
 ad4:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
 ad8:	05052f0b 	streq	r2, [r5, #-3851]	; 0xfffff0f5
 adc:	3206059c 	andcc	r0, r6, #156, 10	; 0x27000000
 ae0:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 ae4:	08054a0d 	stmdaeq	r5, {r0, r2, r3, r9, fp, lr}
 ae8:	4b01054b 	blmi	4201c <__bss_end+0x386b0>
 aec:	830e0585 	movwhi	r0, #58757	; 0xe585
 af0:	85d70105 	ldrbhi	r0, [r7, #261]	; 0x105
 af4:	05830d05 	streq	r0, [r3, #3333]	; 0xd05
 af8:	05a2d701 	streq	sp, [r2, #1793]!	; 0x701
 afc:	01059f06 	tsteq	r5, r6, lsl #30
 b00:	0f056a83 	svceq	0x00056a83
 b04:	4b0505bb 	blmi	1421f8 <__bss_end+0x13888c>
 b08:	05840c05 	streq	r0, [r4, #3077]	; 0xc05
 b0c:	1005660e 	andne	r6, r5, lr, lsl #12
 b10:	4b05054a 	blmi	142040 <__bss_end+0x1386d4>
 b14:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
 b18:	0c056605 	stceq	6, cr6, [r5], {5}
 b1c:	660e054c 	strvs	r0, [lr], -ip, asr #10
 b20:	054a1005 	strbeq	r1, [sl, #-5]
 b24:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 b28:	4a100566 	bmi	4020c8 <__bss_end+0x3f875c>
 b2c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 b30:	1005660e 	andne	r6, r5, lr, lsl #12
 b34:	4b0c054a 	blmi	302064 <__bss_end+0x2f86f8>
 b38:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b3c:	03054a10 	movweq	r4, #23056	; 0x5a10
 b40:	300d054b 	andcc	r0, sp, fp, asr #10
 b44:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 b48:	0e054c0c 	cdpeq	12, 0, cr4, cr5, cr12, {0}
 b4c:	4a100566 	bmi	4020ec <__bss_end+0x3f8780>
 b50:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 b54:	1005660e 	andne	r6, r5, lr, lsl #12
 b58:	4b0c054a 	blmi	302088 <__bss_end+0x2f871c>
 b5c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b60:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 b64:	660e054b 	strvs	r0, [lr], -fp, asr #10
 b68:	054a1005 	strbeq	r1, [sl, #-5]
 b6c:	06054b03 	streq	r4, [r5], -r3, lsl #22
 b70:	4b020530 	blmi	82038 <__bss_end+0x786cc>
 b74:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 b78:	0e054c1c 	mcreq	12, 0, r4, cr5, cr12, {0}
 b7c:	6607059f 			; <UNDEFINED> instruction: 0x6607059f
 b80:	05681805 	strbeq	r1, [r8, #-2053]!	; 0xfffff7fb
 b84:	33058334 	movwcc	r8, #21300	; 0x5334
 b88:	4a440566 	bmi	1102128 <__bss_end+0x10f87bc>
 b8c:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
 b90:	1d056906 	vstrne.16	s12, [r5, #-12]	; <UNPREDICTABLE>
 b94:	840b059f 	strhi	r0, [fp], #-1439	; 0xfffffa61
 b98:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 b9c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 ba0:	0402000c 	streq	r0, [r2], #-12
 ba4:	0e058402 	cdpeq	4, 0, cr8, cr5, cr2, {0}
 ba8:	02040200 	andeq	r0, r4, #0, 4
 bac:	001e0566 	andseq	r0, lr, r6, ror #10
 bb0:	4a020402 	bmi	81bc0 <__bss_end+0x78254>
 bb4:	02001005 	andeq	r1, r0, #5
 bb8:	05820204 	streq	r0, [r2, #516]	; 0x204
 bbc:	04020002 	streq	r0, [r2], #-2
 bc0:	05872c02 	streq	r2, [r7, #3074]	; 0xc02
 bc4:	0e05680c 	cdpeq	8, 0, cr6, cr5, cr12, {0}
 bc8:	4a100566 	bmi	402168 <__bss_end+0x3f87fc>
 bcc:	054c1a05 	strbeq	r1, [ip, #-2565]	; 0xfffff5fb
 bd0:	1505a00c 	strne	sl, [r5, #-12]
 bd4:	01040200 	mrseq	r0, R12_usr
 bd8:	6819054a 	ldmdavs	r9, {r1, r3, r6, r8, sl}
 bdc:	05820405 	streq	r0, [r2, #1029]	; 0x405
 be0:	0402000d 	streq	r0, [r2], #-13
 be4:	0f054c02 	svceq	0x00054c02
 be8:	02040200 	andeq	r0, r4, #0, 4
 bec:	00240566 	eoreq	r0, r4, r6, ror #10
 bf0:	4a020402 	bmi	81c00 <__bss_end+0x78294>
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
 c1c:	4b07054a 	blmi	1c214c <__bss_end+0x1b87e0>
 c20:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 c24:	0a054b06 	beq	153844 <__bss_end+0x149ed8>
 c28:	4c0c0567 	cfstr32mi	mvfx0, [ip], {103}	; 0x67
 c2c:	02001c05 	andeq	r1, r0, #1280	; 0x500
 c30:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 c34:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 c38:	09054a01 	stmdbeq	r5, {r0, r9, fp, lr}
 c3c:	4a05054b 	bmi	142170 <__bss_end+0x138804>
 c40:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 c44:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
 c48:	04020007 	streq	r0, [r2], #-7
 c4c:	0d054b01 	vstreq	d4, [r5, #-4]
 c50:	4a090530 	bmi	242118 <__bss_end+0x2387ac>
 c54:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 c58:	04020010 	streq	r0, [r2], #-16
 c5c:	07056601 	streq	r6, [r5, -r1, lsl #12]
 c60:	001c0567 	andseq	r0, ip, r7, ror #10
 c64:	66010402 	strvs	r0, [r1], -r2, lsl #8
 c68:	05831105 	streq	r1, [r3, #261]	; 0x105
 c6c:	0b05661b 	bleq	15a4e0 <__bss_end+0x150b74>
 c70:	00030566 	andeq	r0, r3, r6, ror #10
 c74:	03020402 	movweq	r0, #9218	; 0x2402
 c78:	10054a78 	andne	r4, r5, r8, ror sl
 c7c:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 c80:	0c026701 	stceq	7, cr6, [r2], {1}
 c84:	79010100 	stmdbvc	r1, {r8}
 c88:	03000000 	movweq	r0, #0
 c8c:	00004600 	andeq	r4, r0, r0, lsl #12
 c90:	fb010200 	blx	4149a <__bss_end+0x37b2e>
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
 cdc:	ca030000 	bgt	c0ce4 <__bss_end+0xb7378>
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
      58:	07c80704 	strbeq	r0, [r8, r4, lsl #14]
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
     128:	000007c8 	andeq	r0, r0, r8, asr #15
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408814>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36828>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a4ec>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x368f8>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6b20>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	0000089d 	muleq	r0, sp, r8
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0003b904 	andeq	fp, r3, r4, lsl #18
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000781 	andeq	r0, r0, r1, lsl #15
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	0000049e 	muleq	r0, lr, r4
     30c:	0007d604 	andeq	sp, r7, r4, lsl #12
     310:	07050200 	streq	r0, [r5, -r0, lsl #4]
     314:	00000049 	andeq	r0, r0, r9, asr #32
     318:	00003803 	andeq	r3, r0, r3, lsl #16
     31c:	05040500 	streq	r0, [r4, #-1280]	; 0xfffffb00
     320:	00746e69 	rsbseq	r6, r4, r9, ror #28
     324:	1f050802 	svcne	0x00050802
     328:	02000003 	andeq	r0, r0, #3
     32c:	07780801 	ldrbeq	r0, [r8, -r1, lsl #16]!
     330:	02020000 	andeq	r0, r2, #0
     334:	00089c07 	andeq	r9, r8, r7, lsl #24
     338:	07d50400 	ldrbeq	r0, [r5, r0, lsl #8]
     33c:	0a020000 	beq	80344 <__bss_end+0x769d8>
     340:	00007607 	andeq	r7, r0, r7, lsl #12
     344:	00650300 	rsbeq	r0, r5, r0, lsl #6
     348:	04020000 	streq	r0, [r2], #-0
     34c:	0007c807 	andeq	ip, r7, r7, lsl #16
     350:	07080200 	streq	r0, [r8, -r0, lsl #4]
     354:	000007be 			; <UNDEFINED> instruction: 0x000007be
     358:	00076906 	andeq	r6, r7, r6, lsl #18
     35c:	130d0200 	movwne	r0, #53760	; 0xd200
     360:	00000044 	andeq	r0, r0, r4, asr #32
     364:	98bc0305 	ldmls	ip!, {r0, r2, r8, r9}
     368:	30060000 	andcc	r0, r6, r0
     36c:	02000008 	andeq	r0, r0, #8
     370:	0044130e 	subeq	r1, r4, lr, lsl #6
     374:	03050000 	movweq	r0, #20480	; 0x5000
     378:	000098c0 	andeq	r9, r0, r0, asr #17
     37c:	00076806 	andeq	r6, r7, r6, lsl #16
     380:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     384:	00000071 	andeq	r0, r0, r1, ror r0
     388:	98c40305 	stmials	r4, {r0, r2, r8, r9}^
     38c:	2f060000 	svccs	0x00060000
     390:	02000008 	andeq	r0, r0, #8
     394:	00711411 	rsbseq	r1, r1, r1, lsl r4
     398:	03050000 	movweq	r0, #20480	; 0x5000
     39c:	000098c8 	andeq	r9, r0, r8, asr #17
     3a0:	000a8307 	andeq	r8, sl, r7, lsl #6
     3a4:	06030800 	streq	r0, [r3], -r0, lsl #16
     3a8:	0000f208 	andeq	pc, r0, r8, lsl #4
     3ac:	30720800 	rsbscc	r0, r2, r0, lsl #16
     3b0:	0e080300 	cdpeq	3, 0, cr0, cr8, cr0, {0}
     3b4:	00000065 	andeq	r0, r0, r5, rrx
     3b8:	31720800 	cmncc	r2, r0, lsl #16
     3bc:	0e090300 	cdpeq	3, 0, cr0, cr9, cr0, {0}
     3c0:	00000065 	andeq	r0, r0, r5, rrx
     3c4:	a8090004 	stmdage	r9, {r2}
     3c8:	05000004 	streq	r0, [r0, #-4]
     3cc:	00004904 	andeq	r4, r0, r4, lsl #18
     3d0:	0c1e0300 	ldceq	3, cr0, [lr], {-0}
     3d4:	00000129 	andeq	r0, r0, r9, lsr #2
     3d8:	00050f0a 	andeq	r0, r5, sl, lsl #30
     3dc:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
     3e0:	0100000b 	tsteq	r0, fp
     3e4:	0003a80a 	andeq	sl, r3, sl, lsl #16
     3e8:	d70a0200 	strle	r0, [sl, -r0, lsl #4]
     3ec:	03000006 	movweq	r0, #6
     3f0:	000b3e0a 	andeq	r3, fp, sl, lsl #28
     3f4:	560a0400 	strpl	r0, [sl], -r0, lsl #8
     3f8:	05000006 	streq	r0, [r0, #-6]
     3fc:	04380900 	ldrteq	r0, [r8], #-2304	; 0xfffff700
     400:	04050000 	streq	r0, [r5], #-0
     404:	00000049 	andeq	r0, r0, r9, asr #32
     408:	660c4403 	strvs	r4, [ip], -r3, lsl #8
     40c:	0a000001 	beq	418 <shift+0x418>
     410:	00000851 	andeq	r0, r0, r1, asr r8
     414:	07b90a00 	ldreq	r0, [r9, r0, lsl #20]!
     418:	0a010000 	beq	40420 <__bss_end+0x36ab4>
     41c:	000007a7 	andeq	r0, r0, r7, lsr #15
     420:	0a310a02 	beq	c42c30 <__bss_end+0xc392c4>
     424:	0a030000 	beq	c042c <__bss_end+0xb6ac0>
     428:	000009d3 	ldrdeq	r0, [r0], -r3
     42c:	0ab00a04 	beq	fec02c44 <__bss_end+0xfebf92d8>
     430:	0a050000 	beq	140438 <__bss_end+0x136acc>
     434:	00000773 	andeq	r0, r0, r3, ror r7
     438:	7c060006 	stcvc	0, cr0, [r6], {6}
     43c:	04000006 	streq	r0, [r0], #-6
     440:	00711405 	rsbseq	r1, r1, r5, lsl #8
     444:	03050000 	movweq	r0, #20480	; 0x5000
     448:	000098cc 	andeq	r9, r0, ip, asr #17
     44c:	000aa406 	andeq	sl, sl, r6, lsl #8
     450:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     454:	00000071 	andeq	r0, r0, r1, ror r0
     458:	98d00305 	ldmls	r0, {r0, r2, r8, r9}^
     45c:	e0060000 	and	r0, r6, r0
     460:	05000005 	streq	r0, [r0, #-5]
     464:	00711a07 	rsbseq	r1, r1, r7, lsl #20
     468:	03050000 	movweq	r0, #20480	; 0x5000
     46c:	000098d4 	ldrdeq	r9, [r0], -r4
     470:	00069806 	andeq	r9, r6, r6, lsl #16
     474:	1a090500 	bne	24187c <__bss_end+0x237f10>
     478:	00000071 	andeq	r0, r0, r1, ror r0
     47c:	98d80305 	ldmls	r8, {r0, r2, r8, r9}^
     480:	3b060000 	blcc	180488 <__bss_end+0x176b1c>
     484:	05000009 	streq	r0, [r0, #-9]
     488:	00711a0b 	rsbseq	r1, r1, fp, lsl #20
     48c:	03050000 	movweq	r0, #20480	; 0x5000
     490:	000098dc 	ldrdeq	r9, [r0], -ip
     494:	000ab706 	andeq	fp, sl, r6, lsl #14
     498:	1a0d0500 	bne	3418a0 <__bss_end+0x337f34>
     49c:	00000071 	andeq	r0, r0, r1, ror r0
     4a0:	98e00305 	stmials	r0!, {r0, r2, r8, r9}^
     4a4:	c4060000 	strgt	r0, [r6], #-0
     4a8:	05000008 	streq	r0, [r0, #-8]
     4ac:	00711a0f 	rsbseq	r1, r1, pc, lsl #20
     4b0:	03050000 	movweq	r0, #20480	; 0x5000
     4b4:	000098e4 	andeq	r9, r0, r4, ror #17
     4b8:	0007f909 	andeq	pc, r7, r9, lsl #18
     4bc:	49040500 	stmdbmi	r4, {r8, sl}
     4c0:	05000000 	streq	r0, [r0, #-0]
     4c4:	02090c1b 	andeq	r0, r9, #6912	; 0x1b00
     4c8:	d60a0000 	strle	r0, [sl], -r0
     4cc:	00000008 	andeq	r0, r0, r8
     4d0:	000bd50a 	andeq	sp, fp, sl, lsl #10
     4d4:	a20a0100 	andge	r0, sl, #0, 2
     4d8:	02000007 	andeq	r0, r0, #7
     4dc:	08830b00 	stmeq	r3, {r8, r9, fp}
     4e0:	b40c0000 	strlt	r0, [ip], #-0
     4e4:	90000006 	andls	r0, r0, r6
     4e8:	7c076305 	stcvc	3, cr6, [r7], {5}
     4ec:	07000003 	streq	r0, [r0, -r3]
     4f0:	0000068a 	andeq	r0, r0, sl, lsl #13
     4f4:	10670524 	rsbne	r0, r7, r4, lsr #10
     4f8:	00000296 	muleq	r0, r6, r2
     4fc:	001b650d 	andseq	r6, fp, sp, lsl #10
     500:	12690500 	rsbne	r0, r9, #0, 10
     504:	0000037c 	andeq	r0, r0, ip, ror r3
     508:	05ca0d00 	strbeq	r0, [sl, #3328]	; 0xd00
     50c:	6b050000 	blvs	140514 <__bss_end+0x136ba8>
     510:	00038c12 	andeq	r8, r3, r2, lsl ip
     514:	b90d1000 	stmdblt	sp, {ip}
     518:	05000008 	streq	r0, [r0, #-8]
     51c:	0065166d 	rsbeq	r1, r5, sp, ror #12
     520:	0d140000 	ldceq	0, cr0, [r4, #-0]
     524:	00000675 	andeq	r0, r0, r5, ror r6
     528:	931c7005 	tstls	ip, #5
     52c:	18000003 	stmdane	r0, {r0, r1}
     530:	0006c00d 	andeq	ip, r6, sp
     534:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
     538:	00000393 	muleq	r0, r3, r3
     53c:	0be00d1c 	bleq	ff8039b4 <__bss_end+0xff7fa048>
     540:	75050000 	strvc	r0, [r5, #-0]
     544:	0003931c 	andeq	r9, r3, ip, lsl r3
     548:	1f0e2000 	svcne	0x000e2000
     54c:	05000008 	streq	r0, [r0, #-8]
     550:	0aca1c77 	beq	ff287734 <__bss_end+0xff27ddc8>
     554:	03930000 	orrseq	r0, r3, #0
     558:	028a0000 	addeq	r0, sl, #0
     55c:	930f0000 	movwls	r0, #61440	; 0xf000
     560:	10000003 	andne	r0, r0, r3
     564:	00000399 	muleq	r0, r9, r3
     568:	86070000 	strhi	r0, [r7], -r0
     56c:	18000007 	stmdane	r0, {r0, r1, r2}
     570:	cb107b05 	blgt	41f18c <__bss_end+0x415820>
     574:	0d000002 	stceq	0, cr0, [r0, #-8]
     578:	00001b65 	andeq	r1, r0, r5, ror #22
     57c:	7c127e05 	ldcvc	14, cr7, [r2], {5}
     580:	00000003 	andeq	r0, r0, r3
     584:	0004930d 	andeq	r9, r4, sp, lsl #6
     588:	19800500 	stmibne	r0, {r8, sl}
     58c:	00000399 	muleq	r0, r9, r3
     590:	084a0d10 	stmdaeq	sl, {r4, r8, sl, fp}^
     594:	82050000 	andhi	r0, r5, #0
     598:	0003a421 	andeq	sl, r3, r1, lsr #8
     59c:	03001400 	movweq	r1, #1024	; 0x400
     5a0:	00000296 	muleq	r0, r6, r2
     5a4:	00051c11 	andeq	r1, r5, r1, lsl ip
     5a8:	21860500 	orrcs	r0, r6, r0, lsl #10
     5ac:	000003aa 	andeq	r0, r0, sl, lsr #7
     5b0:	00052811 	andeq	r2, r5, r1, lsl r8
     5b4:	1f880500 	svcne	0x00880500
     5b8:	00000071 	andeq	r0, r0, r1, ror r0
     5bc:	0009d90d 	andeq	sp, r9, sp, lsl #18
     5c0:	178b0500 	strne	r0, [fp, r0, lsl #10]
     5c4:	0000021b 	andeq	r0, r0, fp, lsl r2
     5c8:	03f70d00 	mvnseq	r0, #0, 26
     5cc:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
     5d0:	00021b17 	andeq	r1, r2, r7, lsl fp
     5d4:	af0d2400 	svcge	0x000d2400
     5d8:	05000008 	streq	r0, [r0, #-8]
     5dc:	021b178f 	andseq	r1, fp, #37486592	; 0x23c0000
     5e0:	0d480000 	stcleq	0, cr0, [r8, #-0]
     5e4:	00000840 	andeq	r0, r0, r0, asr #16
     5e8:	1b179005 	blne	5e4604 <__bss_end+0x5dac98>
     5ec:	6c000002 	stcvs	0, cr0, [r0], {2}
     5f0:	0006b412 	andeq	fp, r6, r2, lsl r4
     5f4:	09930500 	ldmibeq	r3, {r8, sl}
     5f8:	00000b0d 	andeq	r0, r0, sp, lsl #22
     5fc:	000003b5 			; <UNDEFINED> instruction: 0x000003b5
     600:	00033501 	andeq	r3, r3, r1, lsl #10
     604:	00033b00 	andeq	r3, r3, r0, lsl #22
     608:	03b50f00 			; <UNDEFINED> instruction: 0x03b50f00
     60c:	13000000 	movwne	r0, #0
     610:	00000504 	andeq	r0, r0, r4, lsl #10
     614:	410e9605 	tstmi	lr, r5, lsl #12
     618:	0100000c 	tsteq	r0, ip
     61c:	00000350 	andeq	r0, r0, r0, asr r3
     620:	00000356 	andeq	r0, r0, r6, asr r3
     624:	0003b50f 	andeq	fp, r3, pc, lsl #10
     628:	51140000 	tstpl	r4, r0
     62c:	05000008 	streq	r0, [r0, #-8]
     630:	07de1099 	bfieq	r1, r9, #1, #30
     634:	03bb0000 			; <UNDEFINED> instruction: 0x03bb0000
     638:	6b010000 	blvs	40640 <__bss_end+0x36cd4>
     63c:	0f000003 	svceq	0x00000003
     640:	000003b5 			; <UNDEFINED> instruction: 0x000003b5
     644:	00039910 	andeq	r9, r3, r0, lsl r9
     648:	01e41000 	mvneq	r1, r0
     64c:	00000000 	andeq	r0, r0, r0
     650:	00002515 	andeq	r2, r0, r5, lsl r5
     654:	00038c00 	andeq	r8, r3, r0, lsl #24
     658:	00761600 	rsbseq	r1, r6, r0, lsl #12
     65c:	000f0000 	andeq	r0, pc, r0
     660:	02020102 	andeq	r0, r2, #-2147483648	; 0x80000000
     664:	17000006 	strne	r0, [r0, -r6]
     668:	00021b04 	andeq	r1, r2, r4, lsl #22
     66c:	2c041700 	stccs	7, cr1, [r4], {-0}
     670:	0b000000 	bleq	678 <shift+0x678>
     674:	00000b57 	andeq	r0, r0, r7, asr fp
     678:	039f0417 	orrseq	r0, pc, #385875968	; 0x17000000
     67c:	cb150000 	blgt	540684 <__bss_end+0x536d18>
     680:	b5000002 	strlt	r0, [r0, #-2]
     684:	18000003 	stmdane	r0, {r0, r1}
     688:	0e041700 	cdpeq	7, 0, cr1, cr4, cr0, {0}
     68c:	17000002 	strne	r0, [r0, -r2]
     690:	00020904 	andeq	r0, r2, r4, lsl #18
     694:	05f61900 	ldrbeq	r1, [r6, #2304]!	; 0x900
     698:	9c050000 	stcls	0, cr0, [r5], {-0}
     69c:	00020e14 	andeq	r0, r2, r4, lsl lr
     6a0:	04eb0600 	strbteq	r0, [fp], #1536	; 0x600
     6a4:	04060000 	streq	r0, [r6], #-0
     6a8:	00007114 	andeq	r7, r0, r4, lsl r1
     6ac:	e8030500 	stmda	r3, {r8, sl}
     6b0:	06000098 			; <UNDEFINED> instruction: 0x06000098
     6b4:	000003ae 	andeq	r0, r0, lr, lsr #7
     6b8:	71140706 	tstvc	r4, r6, lsl #14
     6bc:	05000000 	streq	r0, [r0, #-0]
     6c0:	0098ec03 	addseq	lr, r8, r3, lsl #24
     6c4:	0afa0600 	beq	ffe81ecc <__bss_end+0xffe78560>
     6c8:	0a060000 	beq	1806d0 <__bss_end+0x176d64>
     6cc:	00007114 	andeq	r7, r0, r4, lsl r1
     6d0:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     6d4:	09000098 	stmdbeq	r0, {r3, r4, r7}
     6d8:	0000042c 	andeq	r0, r0, ip, lsr #8
     6dc:	00490405 	subeq	r0, r9, r5, lsl #8
     6e0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6e4:	00043a0c 	andeq	r3, r4, ip, lsl #20
     6e8:	654e1a00 	strbvs	r1, [lr, #-2560]	; 0xfffff600
     6ec:	0a000077 	beq	8d0 <shift+0x8d0>
     6f0:	00000932 	andeq	r0, r0, r2, lsr r9
     6f4:	0b360a01 	bleq	d82f00 <__bss_end+0xd79594>
     6f8:	0a020000 	beq	80700 <__bss_end+0x76d94>
     6fc:	000008ce 	andeq	r0, r0, lr, asr #17
     700:	06c90a03 	strbeq	r0, [r9], r3, lsl #20
     704:	0a040000 	beq	10070c <__bss_end+0xf6da0>
     708:	00000761 	andeq	r0, r0, r1, ror #14
     70c:	1f070005 	svcne	0x00070005
     710:	10000004 	andne	r0, r0, r4
     714:	79081b06 	stmdbvc	r8, {r1, r2, r8, r9, fp, ip}
     718:	08000004 	stmdaeq	r0, {r2}
     71c:	0600726c 	streq	r7, [r0], -ip, ror #4
     720:	0479131d 	ldrbteq	r1, [r9], #-797	; 0xfffffce3
     724:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     728:	06007073 			; <UNDEFINED> instruction: 0x06007073
     72c:	0479131e 	ldrbteq	r1, [r9], #-798	; 0xfffffce2
     730:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     734:	06006370 			; <UNDEFINED> instruction: 0x06006370
     738:	0479131f 	ldrbteq	r1, [r9], #-799	; 0xfffffce1
     73c:	0d080000 	stceq	0, cr0, [r8, #-0]
     740:	0000083a 	andeq	r0, r0, sl, lsr r8
     744:	79132006 	ldmdbvc	r3, {r1, r2, sp}
     748:	0c000004 	stceq	0, cr0, [r0], {4}
     74c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     750:	000007c3 	andeq	r0, r0, r3, asr #15
     754:	000c3407 	andeq	r3, ip, r7, lsl #8
     758:	28067000 	stmdacs	r6, {ip, sp, lr}
     75c:	00051008 	andeq	r1, r5, r8
     760:	063b0d00 	ldrteq	r0, [fp], -r0, lsl #26
     764:	2a060000 	bcs	18076c <__bss_end+0x176e00>
     768:	00043a12 	andeq	r3, r4, r2, lsl sl
     76c:	70080000 	andvc	r0, r8, r0
     770:	06006469 	streq	r6, [r0], -r9, ror #8
     774:	0076122b 	rsbseq	r1, r6, fp, lsr #4
     778:	0d100000 	ldceq	0, cr0, [r0, #-0]
     77c:	00001558 	andeq	r1, r0, r8, asr r5
     780:	03112c06 	tsteq	r1, #1536	; 0x600
     784:	14000004 	strne	r0, [r0], #-4
     788:	000bba0d 	andeq	fp, fp, sp, lsl #20
     78c:	122d0600 	eorne	r0, sp, #0, 12
     790:	00000076 	andeq	r0, r0, r6, ror r0
     794:	065f0d18 			; <UNDEFINED> instruction: 0x065f0d18
     798:	2e060000 	cdpcs	0, 0, cr0, cr6, cr0, {0}
     79c:	00007612 	andeq	r7, r0, r2, lsl r6
     7a0:	9b0d1c00 	blls	3477a8 <__bss_end+0x33de3c>
     7a4:	06000003 	streq	r0, [r0], -r3
     7a8:	05100c2f 	ldreq	r0, [r0, #-3119]	; 0xfffff3d1
     7ac:	0d200000 	stceq	0, cr0, [r0, #-0]
     7b0:	000006aa 	andeq	r0, r0, sl, lsr #13
     7b4:	49093006 	stmdbmi	r9, {r1, r2, ip, sp}
     7b8:	60000000 	andvs	r0, r0, r0
     7bc:	0004130d 	andeq	r1, r4, sp, lsl #6
     7c0:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     7c4:	00000065 	andeq	r0, r0, r5, rrx
     7c8:	040a0d64 	streq	r0, [sl], #-3428	; 0xfffff29c
     7cc:	33060000 	movwcc	r0, #24576	; 0x6000
     7d0:	0000650e 	andeq	r6, r0, lr, lsl #10
     7d4:	010d6800 	tsteq	sp, r0, lsl #16
     7d8:	06000004 	streq	r0, [r0], -r4
     7dc:	00650e34 	rsbeq	r0, r5, r4, lsr lr
     7e0:	006c0000 	rsbeq	r0, ip, r0
     7e4:	0003bb15 	andeq	fp, r3, r5, lsl fp
     7e8:	00052000 	andeq	r2, r5, r0
     7ec:	00761600 	rsbseq	r1, r6, r0, lsl #12
     7f0:	000f0000 	andeq	r0, pc, r0
     7f4:	0005b006 	andeq	fp, r5, r6
     7f8:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
     7fc:	00000071 	andeq	r0, r0, r1, ror r0
     800:	98f40305 	ldmls	r4!, {r0, r2, r8, r9}^
     804:	8f090000 	svchi	0x00090000
     808:	0500000a 	streq	r0, [r0, #-10]
     80c:	00004904 	andeq	r4, r0, r4, lsl #18
     810:	0c0d0700 	stceq	7, cr0, [sp], {-0}
     814:	00000551 	andeq	r0, r0, r1, asr r5
     818:	000b6f0a 	andeq	r6, fp, sl, lsl #30
     81c:	bf0a0000 	svclt	0x000a0000
     820:	01000005 	tsteq	r0, r5
     824:	0ba70700 	bleq	fe9c242c <__bss_end+0xfe9b8ac0>
     828:	070c0000 	streq	r0, [ip, -r0]
     82c:	0586081b 	streq	r0, [r6, #2075]	; 0x81b
     830:	6a0d0000 	bvs	340838 <__bss_end+0x336ecc>
     834:	0700000b 	streq	r0, [r0, -fp]
     838:	0586191d 	streq	r1, [r6, #2333]	; 0x91d
     83c:	0d000000 	stceq	0, cr0, [r0, #-0]
     840:	00000be0 	andeq	r0, r0, r0, ror #23
     844:	86191e07 	ldrhi	r1, [r9], -r7, lsl #28
     848:	04000005 	streq	r0, [r0], #-5
     84c:	00082a0d 	andeq	r2, r8, sp, lsl #20
     850:	131f0700 	tstne	pc, #0, 14
     854:	0000058c 	andeq	r0, r0, ip, lsl #11
     858:	04170008 	ldreq	r0, [r7], #-8
     85c:	00000551 	andeq	r0, r0, r1, asr r5
     860:	04800417 	streq	r0, [r0], #1047	; 0x417
     864:	910c0000 	mrsls	r0, (UNDEF: 12)
     868:	14000007 	strne	r0, [r0], #-7
     86c:	14072207 	strne	r2, [r7], #-519	; 0xfffffdf9
     870:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
     874:	00000607 	andeq	r0, r0, r7, lsl #12
     878:	65122607 	ldrvs	r2, [r2, #-1543]	; 0xfffff9f9
     87c:	00000000 	andeq	r0, r0, r0
     880:	0008890d 	andeq	r8, r8, sp, lsl #18
     884:	1d290700 	stcne	7, cr0, [r9, #-0]
     888:	00000586 	andeq	r0, r0, r6, lsl #11
     88c:	09c00d04 	stmibeq	r0, {r2, r8, sl, fp}^
     890:	2c070000 	stccs	0, cr0, [r7], {-0}
     894:	0005861d 	andeq	r8, r5, sp, lsl r6
     898:	d61b0800 	ldrle	r0, [fp], -r0, lsl #16
     89c:	07000005 	streq	r0, [r0, -r5]
     8a0:	0b840e2f 	bleq	fe104164 <__bss_end+0xfe0fa7f8>
     8a4:	05da0000 	ldrbeq	r0, [sl]
     8a8:	05e50000 	strbeq	r0, [r5, #0]!
     8ac:	190f0000 	stmdbne	pc, {}	; <UNPREDICTABLE>
     8b0:	10000008 	andne	r0, r0, r8
     8b4:	00000586 	andeq	r0, r0, r6, lsl #11
     8b8:	06161c00 	ldreq	r1, [r6], -r0, lsl #24
     8bc:	31070000 	mrscc	r0, (UNDEF: 7)
     8c0:	000c0b0e 	andeq	r0, ip, lr, lsl #22
     8c4:	00038c00 	andeq	r8, r3, r0, lsl #24
     8c8:	0005fd00 	andeq	pc, r5, r0, lsl #26
     8cc:	00060800 	andeq	r0, r6, r0, lsl #16
     8d0:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
     8d4:	8c100000 	ldchi	0, cr0, [r0], {-0}
     8d8:	00000005 	andeq	r0, r0, r5
     8dc:	00075512 	andeq	r5, r7, r2, lsl r5
     8e0:	1d350700 	ldcne	7, cr0, [r5, #-0]
     8e4:	0000090d 	andeq	r0, r0, sp, lsl #18
     8e8:	00000586 	andeq	r0, r0, r6, lsl #11
     8ec:	00062102 	andeq	r2, r6, r2, lsl #2
     8f0:	00062700 	andeq	r2, r6, r0, lsl #14
     8f4:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
     8f8:	12000000 	andne	r0, r0, #0
     8fc:	00000bc8 	andeq	r0, r0, r8, asr #23
     900:	e51d3707 	ldr	r3, [sp, #-1799]	; 0xfffff8f9
     904:	8600000b 	strhi	r0, [r0], -fp
     908:	02000005 	andeq	r0, r0, #5
     90c:	00000640 	andeq	r0, r0, r0, asr #12
     910:	00000646 	andeq	r0, r0, r6, asr #12
     914:	0008190f 	andeq	r1, r8, pc, lsl #18
     918:	491d0000 	ldmdbmi	sp, {}	; <UNPREDICTABLE>
     91c:	07000009 	streq	r0, [r0, -r9]
     920:	08323139 	ldmdaeq	r2!, {r0, r3, r4, r5, r8, ip, sp}
     924:	020c0000 	andeq	r0, ip, #0
     928:	00079112 	andeq	r9, r7, r2, lsl r1
     92c:	093c0700 	ldmdbeq	ip!, {r8, r9, sl}
     930:	000008e0 	andeq	r0, r0, r0, ror #17
     934:	00000819 	andeq	r0, r0, r9, lsl r8
     938:	00066d01 	andeq	r6, r6, r1, lsl #26
     93c:	00067300 	andeq	r7, r6, r0, lsl #6
     940:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
     944:	12000000 	andne	r0, r0, #0
     948:	00000647 	andeq	r0, r0, r7, asr #12
     94c:	e6123f07 	ldr	r3, [r2], -r7, lsl #30
     950:	65000006 	strvs	r0, [r0, #-6]
     954:	01000000 	mrseq	r0, (UNDEF: 0)
     958:	0000068c 	andeq	r0, r0, ip, lsl #13
     95c:	000006a1 	andeq	r0, r0, r1, lsr #13
     960:	0008190f 	andeq	r1, r8, pc, lsl #18
     964:	083b1000 	ldmdaeq	fp!, {ip}
     968:	76100000 	ldrvc	r0, [r0], -r0
     96c:	10000000 	andne	r0, r0, r0
     970:	0000038c 	andeq	r0, r0, ip, lsl #7
     974:	06dd1300 	ldrbeq	r1, [sp], r0, lsl #6
     978:	42070000 	andmi	r0, r7, #0
     97c:	0005670e 	andeq	r6, r5, lr, lsl #14
     980:	06b60100 	ldrteq	r0, [r6], r0, lsl #2
     984:	06bc0000 	ldrteq	r0, [ip], r0
     988:	190f0000 	stmdbne	pc, {}	; <UNPREDICTABLE>
     98c:	00000008 	andeq	r0, r0, r8
     990:	000b2212 	andeq	r2, fp, r2, lsl r2
     994:	17450700 	strbne	r0, [r5, -r0, lsl #14]
     998:	000004bd 			; <UNDEFINED> instruction: 0x000004bd
     99c:	0000058c 	andeq	r0, r0, ip, lsl #11
     9a0:	0006d501 	andeq	sp, r6, r1, lsl #10
     9a4:	0006db00 	andeq	sp, r6, r0, lsl #22
     9a8:	08410f00 	stmdaeq	r1, {r8, r9, sl, fp}^
     9ac:	12000000 	andne	r0, r0, #0
     9b0:	00000999 	muleq	r0, r9, r9
     9b4:	3a174807 	bcc	5d29d8 <__bss_end+0x5c906c>
     9b8:	8c000005 	stchi	0, cr0, [r0], {5}
     9bc:	01000005 	tsteq	r0, r5
     9c0:	000006f4 	strdeq	r0, [r0], -r4
     9c4:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     9c8:	0008410f 	andeq	r4, r8, pc, lsl #2
     9cc:	00651000 	rsbeq	r1, r5, r0
     9d0:	13000000 	movwne	r0, #0
     9d4:	00000809 	andeq	r0, r0, r9, lsl #16
     9d8:	570e4b07 	strpl	r4, [lr, -r7, lsl #22]
     9dc:	01000009 	tsteq	r0, r9
     9e0:	00000714 	andeq	r0, r0, r4, lsl r7
     9e4:	0000071a 	andeq	r0, r0, sl, lsl r7
     9e8:	0008190f 	andeq	r1, r8, pc, lsl #18
     9ec:	16120000 	ldrne	r0, [r2], -r0
     9f0:	07000006 	streq	r0, [r0, -r6]
     9f4:	05880e4d 	streq	r0, [r8, #3661]	; 0xe4d
     9f8:	038c0000 	orreq	r0, ip, #0
     9fc:	33010000 	movwcc	r0, #4096	; 0x1000
     a00:	3e000007 	cdpcc	0, 0, cr0, cr0, cr7, {0}
     a04:	0f000007 	svceq	0x00000007
     a08:	00000819 	andeq	r0, r0, r9, lsl r8
     a0c:	00006510 	andeq	r6, r0, r0, lsl r5
     a10:	ac120000 	ldcge	0, cr0, [r2], {-0}
     a14:	07000009 	streq	r0, [r0, -r9]
     a18:	08561250 	ldmdaeq	r6, {r4, r6, r9, ip}^
     a1c:	00650000 	rsbeq	r0, r5, r0
     a20:	57010000 	strpl	r0, [r1, -r0]
     a24:	62000007 	andvs	r0, r0, #7
     a28:	0f000007 	svceq	0x00000007
     a2c:	00000819 	andeq	r0, r0, r9, lsl r8
     a30:	0003bb10 	andeq	fp, r3, r0, lsl fp
     a34:	11120000 	tstne	r2, r0
     a38:	07000007 	streq	r0, [r0, -r7]
     a3c:	07290e53 			; <UNDEFINED> instruction: 0x07290e53
     a40:	038c0000 	orreq	r0, ip, #0
     a44:	7b010000 	blvc	40a4c <__bss_end+0x370e0>
     a48:	86000007 	strhi	r0, [r0], -r7
     a4c:	0f000007 	svceq	0x00000007
     a50:	00000819 	andeq	r0, r0, r9, lsl r8
     a54:	00006510 	andeq	r6, r0, r0, lsl r5
     a58:	86130000 	ldrhi	r0, [r3], -r0
     a5c:	07000009 	streq	r0, [r0, -r9]
     a60:	09df0e56 	ldmibeq	pc, {r1, r2, r4, r6, r9, sl, fp}^	; <UNPREDICTABLE>
     a64:	9b010000 	blls	40a6c <__bss_end+0x37100>
     a68:	ba000007 	blt	a8c <shift+0xa8c>
     a6c:	0f000007 	svceq	0x00000007
     a70:	00000819 	andeq	r0, r0, r9, lsl r8
     a74:	0000f210 	andeq	pc, r0, r0, lsl r2	; <UNPREDICTABLE>
     a78:	00651000 	rsbeq	r1, r5, r0
     a7c:	65100000 	ldrvs	r0, [r0, #-0]
     a80:	10000000 	andne	r0, r0, r0
     a84:	00000065 	andeq	r0, r0, r5, rrx
     a88:	00084710 	andeq	r4, r8, r0, lsl r7
     a8c:	25130000 	ldrcs	r0, [r3, #-0]
     a90:	07000006 	streq	r0, [r0, -r6]
     a94:	0a370e58 	beq	dc43fc <__bss_end+0xdbaa90>
     a98:	cf010000 	svcgt	0x00010000
     a9c:	ee000007 	cdp	0, 0, cr0, cr0, cr7, {0}
     aa0:	0f000007 	svceq	0x00000007
     aa4:	00000819 	andeq	r0, r0, r9, lsl r8
     aa8:	00012910 	andeq	r2, r1, r0, lsl r9
     aac:	00651000 	rsbeq	r1, r5, r0
     ab0:	65100000 	ldrvs	r0, [r0, #-0]
     ab4:	10000000 	andne	r0, r0, r0
     ab8:	00000065 	andeq	r0, r0, r5, rrx
     abc:	00084710 	andeq	r4, r8, r0, lsl r7
     ac0:	fa140000 	blx	500ac8 <__bss_end+0x4f715c>
     ac4:	07000008 	streq	r0, [r0, -r8]
     ac8:	04500e5b 	ldrbeq	r0, [r0], #-3675	; 0xfffff1a5
     acc:	038c0000 	orreq	r0, ip, #0
     ad0:	03010000 	movweq	r0, #4096	; 0x1000
     ad4:	0f000008 	svceq	0x00000008
     ad8:	00000819 	andeq	r0, r0, r9, lsl r8
     adc:	00053210 	andeq	r3, r5, r0, lsl r2
     ae0:	084d1000 	stmdaeq	sp, {ip}^
     ae4:	00000000 	andeq	r0, r0, r0
     ae8:	00059203 	andeq	r9, r5, r3, lsl #4
     aec:	92041700 	andls	r1, r4, #0, 14
     af0:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
     af4:	00000586 	andeq	r0, r0, r6, lsl #11
     af8:	0000082c 	andeq	r0, r0, ip, lsr #16
     afc:	00000832 	andeq	r0, r0, r2, lsr r8
     b00:	0008190f 	andeq	r1, r8, pc, lsl #18
     b04:	921f0000 	andsls	r0, pc, #0
     b08:	1f000005 	svcne	0x00000005
     b0c:	17000008 	strne	r0, [r0, -r8]
     b10:	00005704 	andeq	r5, r0, r4, lsl #14
     b14:	14041700 	strne	r1, [r4], #-1792	; 0xfffff900
     b18:	20000008 	andcs	r0, r0, r8
     b1c:	0000cc04 	andeq	ip, r0, r4, lsl #24
     b20:	19042100 	stmdbne	r4, {r8, sp}
     b24:	000007ad 	andeq	r0, r0, sp, lsr #15
     b28:	92195e07 	andsls	r5, r9, #7, 28	; 0x70
     b2c:	22000005 	andcs	r0, r0, #5
     b30:	00000517 	andeq	r0, r0, r7, lsl r5
     b34:	49050501 	stmdbmi	r5, {r0, r8, sl}
     b38:	2c000000 	stccs	0, cr0, [r0], {-0}
     b3c:	48000082 	stmdami	r0, {r1, r7}
     b40:	01000000 	mrseq	r0, (UNDEF: 0)
     b44:	0008949c 	muleq	r8, ip, r4
     b48:	06112300 	ldreq	r2, [r1], -r0, lsl #6
     b4c:	05010000 	streq	r0, [r1, #-0]
     b50:	0000490e 	andeq	r4, r0, lr, lsl #18
     b54:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     b58:	00072423 	andeq	r2, r7, r3, lsr #8
     b5c:	1b050100 	blne	140f64 <__bss_end+0x1375f8>
     b60:	00000894 	muleq	r0, r4, r8
     b64:	00709102 	rsbseq	r9, r0, r2, lsl #2
     b68:	089a0417 	ldmeq	sl, {r0, r1, r2, r4, sl}
     b6c:	04170000 	ldreq	r0, [r7], #-0
     b70:	00000025 	andeq	r0, r0, r5, lsr #32
     b74:	000d5c00 	andeq	r5, sp, r0, lsl #24
     b78:	f7000400 			; <UNDEFINED> instruction: 0xf7000400
     b7c:	04000003 	streq	r0, [r0], #-3
     b80:	000fbc01 	andeq	fp, pc, r1, lsl #24
     b84:	0d910400 	cfldrseq	mvf0, [r1]
     b88:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     b8c:	82740000 	rsbshi	r0, r4, #0
     b90:	045c0000 	ldrbeq	r0, [ip], #-0
     b94:	03820000 	orreq	r0, r2, #0
     b98:	01020000 	mrseq	r0, (UNDEF: 2)
     b9c:	00078108 	andeq	r8, r7, r8, lsl #2
     ba0:	00250300 	eoreq	r0, r5, r0, lsl #6
     ba4:	02020000 	andeq	r0, r2, #0
     ba8:	00049e05 	andeq	r9, r4, r5, lsl #28
     bac:	07d60400 	ldrbeq	r0, [r6, r0, lsl #8]
     bb0:	05020000 	streq	r0, [r2, #-0]
     bb4:	00004907 	andeq	r4, r0, r7, lsl #18
     bb8:	00380300 	eorseq	r0, r8, r0, lsl #6
     bbc:	04050000 	streq	r0, [r5], #-0
     bc0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     bc4:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
     bc8:	0000031f 	andeq	r0, r0, pc, lsl r3
     bcc:	78080102 	stmdavc	r8, {r1, r8}
     bd0:	02000007 	andeq	r0, r0, #7
     bd4:	089c0702 	ldmeq	ip, {r1, r8, r9, sl}
     bd8:	d5040000 	strle	r0, [r4, #-0]
     bdc:	02000007 	andeq	r0, r0, #7
     be0:	0076070a 	rsbseq	r0, r6, sl, lsl #14
     be4:	65030000 	strvs	r0, [r3, #-0]
     be8:	02000000 	andeq	r0, r0, #0
     bec:	07c80704 	strbeq	r0, [r8, r4, lsl #14]
     bf0:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
     bf4:	0007be07 	andeq	fp, r7, r7, lsl #28
     bf8:	07690600 	strbeq	r0, [r9, -r0, lsl #12]!
     bfc:	0d020000 	stceq	0, cr0, [r2, #-0]
     c00:	00004413 	andeq	r4, r0, r3, lsl r4
     c04:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
     c08:	06000098 			; <UNDEFINED> instruction: 0x06000098
     c0c:	00000830 	andeq	r0, r0, r0, lsr r8
     c10:	44130e02 	ldrmi	r0, [r3], #-3586	; 0xfffff1fe
     c14:	05000000 	streq	r0, [r0, #-0]
     c18:	0098fc03 	addseq	pc, r8, r3, lsl #24
     c1c:	07680600 	strbeq	r0, [r8, -r0, lsl #12]!
     c20:	10020000 	andne	r0, r2, r0
     c24:	00007114 	andeq	r7, r0, r4, lsl r1
     c28:	00030500 	andeq	r0, r3, r0, lsl #10
     c2c:	06000099 			; <UNDEFINED> instruction: 0x06000099
     c30:	0000082f 	andeq	r0, r0, pc, lsr #16
     c34:	71141102 	tstvc	r4, r2, lsl #2
     c38:	05000000 	streq	r0, [r0, #-0]
     c3c:	00990403 	addseq	r0, r9, r3, lsl #8
     c40:	0a830700 	beq	fe0c2848 <__bss_end+0xfe0b8edc>
     c44:	03080000 	movweq	r0, #32768	; 0x8000
     c48:	00f20806 	rscseq	r0, r2, r6, lsl #16
     c4c:	72080000 	andvc	r0, r8, #0
     c50:	08030030 	stmdaeq	r3, {r4, r5}
     c54:	0000650e 	andeq	r6, r0, lr, lsl #10
     c58:	72080000 	andvc	r0, r8, #0
     c5c:	09030031 	stmdbeq	r3, {r0, r4, r5}
     c60:	0000650e 	andeq	r6, r0, lr, lsl #10
     c64:	09000400 	stmdbeq	r0, {sl}
     c68:	00000eea 	andeq	r0, r0, sl, ror #29
     c6c:	00490405 	subeq	r0, r9, r5, lsl #8
     c70:	0d030000 	stceq	0, cr0, [r3, #-0]
     c74:	0001100c 	andeq	r1, r1, ip
     c78:	4b4f0a00 	blmi	13c3480 <__bss_end+0x13b9b14>
     c7c:	dd0b0000 	stcle	0, cr0, [fp, #-0]
     c80:	0100000c 	tsteq	r0, ip
     c84:	04a80900 	strteq	r0, [r8], #2304	; 0x900
     c88:	04050000 	streq	r0, [r5], #-0
     c8c:	00000049 	andeq	r0, r0, r9, asr #32
     c90:	470c1e03 	strmi	r1, [ip, -r3, lsl #28]
     c94:	0b000001 	bleq	ca0 <shift+0xca0>
     c98:	0000050f 	andeq	r0, r0, pc, lsl #10
     c9c:	0b4d0b00 	bleq	13438a4 <__bss_end+0x1339f38>
     ca0:	0b010000 	bleq	40ca8 <__bss_end+0x3733c>
     ca4:	000003a8 	andeq	r0, r0, r8, lsr #7
     ca8:	06d70b02 	ldrbeq	r0, [r7], r2, lsl #22
     cac:	0b030000 	bleq	c0cb4 <__bss_end+0xb7348>
     cb0:	00000b3e 	andeq	r0, r0, lr, lsr fp
     cb4:	06560b04 	ldrbeq	r0, [r6], -r4, lsl #22
     cb8:	00050000 	andeq	r0, r5, r0
     cbc:	00043809 	andeq	r3, r4, r9, lsl #16
     cc0:	49040500 	stmdbmi	r4, {r8, sl}
     cc4:	03000000 	movweq	r0, #0
     cc8:	01840c44 	orreq	r0, r4, r4, asr #24
     ccc:	510b0000 	mrspl	r0, (UNDEF: 11)
     cd0:	00000008 	andeq	r0, r0, r8
     cd4:	0007b90b 	andeq	fp, r7, fp, lsl #18
     cd8:	a70b0100 	strge	r0, [fp, -r0, lsl #2]
     cdc:	02000007 	andeq	r0, r0, #7
     ce0:	000a310b 	andeq	r3, sl, fp, lsl #2
     ce4:	d30b0300 	movwle	r0, #45824	; 0xb300
     ce8:	04000009 	streq	r0, [r0], #-9
     cec:	000ab00b 	andeq	fp, sl, fp
     cf0:	730b0500 	movwvc	r0, #46336	; 0xb500
     cf4:	06000007 	streq	r0, [r0], -r7
     cf8:	0f4f0900 	svceq	0x004f0900
     cfc:	04050000 	streq	r0, [r5], #-0
     d00:	00000049 	andeq	r0, r0, r9, asr #32
     d04:	af0c6b03 	svcge	0x000c6b03
     d08:	0b000001 	bleq	d14 <shift+0xd14>
     d0c:	00000e8a 	andeq	r0, r0, sl, lsl #29
     d10:	0d2e0b00 	vstmdbeq	lr!, {d0-d-1}
     d14:	0b010000 	bleq	40d1c <__bss_end+0x373b0>
     d18:	00000eb3 			; <UNDEFINED> instruction: 0x00000eb3
     d1c:	0d530b02 	vldreq	d16, [r3, #-8]
     d20:	00030000 	andeq	r0, r3, r0
     d24:	00067c06 	andeq	r7, r6, r6, lsl #24
     d28:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
     d2c:	00000071 	andeq	r0, r0, r1, ror r0
     d30:	99080305 	stmdbls	r8, {r0, r2, r8, r9}
     d34:	a4060000 	strge	r0, [r6], #-0
     d38:	0400000a 	streq	r0, [r0], #-10
     d3c:	00711406 	rsbseq	r1, r1, r6, lsl #8
     d40:	03050000 	movweq	r0, #20480	; 0x5000
     d44:	0000990c 	andeq	r9, r0, ip, lsl #18
     d48:	0005e006 	andeq	lr, r5, r6
     d4c:	1a070500 	bne	1c2154 <__bss_end+0x1b87e8>
     d50:	00000071 	andeq	r0, r0, r1, ror r0
     d54:	99100305 	ldmdbls	r0, {r0, r2, r8, r9}
     d58:	98060000 	stmdals	r6, {}	; <UNPREDICTABLE>
     d5c:	05000006 	streq	r0, [r0, #-6]
     d60:	00711a09 	rsbseq	r1, r1, r9, lsl #20
     d64:	03050000 	movweq	r0, #20480	; 0x5000
     d68:	00009914 	andeq	r9, r0, r4, lsl r9
     d6c:	00093b06 	andeq	r3, r9, r6, lsl #22
     d70:	1a0b0500 	bne	2c2178 <__bss_end+0x2b880c>
     d74:	00000071 	andeq	r0, r0, r1, ror r0
     d78:	99180305 	ldmdbls	r8, {r0, r2, r8, r9}
     d7c:	b7060000 	strlt	r0, [r6, -r0]
     d80:	0500000a 	streq	r0, [r0, #-10]
     d84:	00711a0d 	rsbseq	r1, r1, sp, lsl #20
     d88:	03050000 	movweq	r0, #20480	; 0x5000
     d8c:	0000991c 	andeq	r9, r0, ip, lsl r9
     d90:	0008c406 	andeq	ip, r8, r6, lsl #8
     d94:	1a0f0500 	bne	3c219c <__bss_end+0x3b8830>
     d98:	00000071 	andeq	r0, r0, r1, ror r0
     d9c:	99200305 	stmdbls	r0!, {r0, r2, r8, r9}
     da0:	f9090000 			; <UNDEFINED> instruction: 0xf9090000
     da4:	05000007 	streq	r0, [r0, #-7]
     da8:	00004904 	andeq	r4, r0, r4, lsl #18
     dac:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
     db0:	00000252 	andeq	r0, r0, r2, asr r2
     db4:	0008d60b 	andeq	sp, r8, fp, lsl #12
     db8:	d50b0000 	strle	r0, [fp, #-0]
     dbc:	0100000b 	tsteq	r0, fp
     dc0:	0007a20b 	andeq	sl, r7, fp, lsl #4
     dc4:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     dc8:	00000883 	andeq	r0, r0, r3, lsl #17
     dcc:	0006b40d 	andeq	fp, r6, sp, lsl #8
     dd0:	63059000 	movwvs	r9, #20480	; 0x5000
     dd4:	0003c507 	andeq	ip, r3, r7, lsl #10
     dd8:	068a0700 	streq	r0, [sl], r0, lsl #14
     ddc:	05240000 	streq	r0, [r4, #-0]!
     de0:	02df1067 	sbcseq	r1, pc, #103	; 0x67
     de4:	650e0000 	strvs	r0, [lr, #-0]
     de8:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
     dec:	03c51269 	biceq	r1, r5, #-1879048186	; 0x90000006
     df0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     df4:	000005ca 	andeq	r0, r0, sl, asr #11
     df8:	d5126b05 	ldrle	r6, [r2, #-2821]	; 0xfffff4fb
     dfc:	10000003 	andne	r0, r0, r3
     e00:	0008b90e 	andeq	fp, r8, lr, lsl #18
     e04:	166d0500 	strbtne	r0, [sp], -r0, lsl #10
     e08:	00000065 	andeq	r0, r0, r5, rrx
     e0c:	06750e14 			; <UNDEFINED> instruction: 0x06750e14
     e10:	70050000 	andvc	r0, r5, r0
     e14:	0003dc1c 	andeq	sp, r3, ip, lsl ip
     e18:	c00e1800 	andgt	r1, lr, r0, lsl #16
     e1c:	05000006 	streq	r0, [r0, #-6]
     e20:	03dc1c72 	bicseq	r1, ip, #29184	; 0x7200
     e24:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     e28:	00000be0 	andeq	r0, r0, r0, ror #23
     e2c:	dc1c7505 	cfldr32le	mvfx7, [ip], {5}
     e30:	20000003 	andcs	r0, r0, r3
     e34:	00081f0f 	andeq	r1, r8, pc, lsl #30
     e38:	1c770500 	cfldr64ne	mvdx0, [r7], #-0
     e3c:	00000aca 	andeq	r0, r0, sl, asr #21
     e40:	000003dc 	ldrdeq	r0, [r0], -ip
     e44:	000002d3 	ldrdeq	r0, [r0], -r3
     e48:	0003dc10 	andeq	sp, r3, r0, lsl ip
     e4c:	03e21100 	mvneq	r1, #0, 2
     e50:	00000000 	andeq	r0, r0, r0
     e54:	00078607 	andeq	r8, r7, r7, lsl #12
     e58:	7b051800 	blvc	146e60 <__bss_end+0x13d4f4>
     e5c:	00031410 	andeq	r1, r3, r0, lsl r4
     e60:	1b650e00 	blne	1944668 <__bss_end+0x193acfc>
     e64:	7e050000 	cdpvc	0, 0, cr0, cr5, cr0, {0}
     e68:	0003c512 	andeq	ip, r3, r2, lsl r5
     e6c:	930e0000 	movwls	r0, #57344	; 0xe000
     e70:	05000004 	streq	r0, [r0, #-4]
     e74:	03e21980 	mvneq	r1, #128, 18	; 0x200000
     e78:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     e7c:	0000084a 	andeq	r0, r0, sl, asr #16
     e80:	ed218205 	sfm	f0, 1, [r1, #-20]!	; 0xffffffec
     e84:	14000003 	strne	r0, [r0], #-3
     e88:	02df0300 	sbcseq	r0, pc, #0, 6
     e8c:	1c120000 	ldcne	0, cr0, [r2], {-0}
     e90:	05000005 	streq	r0, [r0, #-5]
     e94:	03f32186 	mvnseq	r2, #-2147483615	; 0x80000021
     e98:	28120000 	ldmdacs	r2, {}	; <UNPREDICTABLE>
     e9c:	05000005 	streq	r0, [r0, #-5]
     ea0:	00711f88 	rsbseq	r1, r1, r8, lsl #31
     ea4:	d90e0000 	stmdble	lr, {}	; <UNPREDICTABLE>
     ea8:	05000009 	streq	r0, [r0, #-9]
     eac:	0264178b 	rsbeq	r1, r4, #36438016	; 0x22c0000
     eb0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     eb4:	000003f7 	strdeq	r0, [r0], -r7
     eb8:	64178e05 	ldrvs	r8, [r7], #-3589	; 0xfffff1fb
     ebc:	24000002 	strcs	r0, [r0], #-2
     ec0:	0008af0e 	andeq	sl, r8, lr, lsl #30
     ec4:	178f0500 	strne	r0, [pc, r0, lsl #10]
     ec8:	00000264 	andeq	r0, r0, r4, ror #4
     ecc:	08400e48 	stmdaeq	r0, {r3, r6, r9, sl, fp}^
     ed0:	90050000 	andls	r0, r5, r0
     ed4:	00026417 	andeq	r6, r2, r7, lsl r4
     ed8:	b4136c00 	ldrlt	r6, [r3], #-3072	; 0xfffff400
     edc:	05000006 	streq	r0, [r0, #-6]
     ee0:	0b0d0993 	bleq	343534 <__bss_end+0x339bc8>
     ee4:	03fe0000 	mvnseq	r0, #0
     ee8:	7e010000 	cdpvc	0, 0, cr0, cr1, cr0, {0}
     eec:	84000003 	strhi	r0, [r0], #-3
     ef0:	10000003 	andne	r0, r0, r3
     ef4:	000003fe 	strdeq	r0, [r0], -lr
     ef8:	05041400 	streq	r1, [r4, #-1024]	; 0xfffffc00
     efc:	96050000 	strls	r0, [r5], -r0
     f00:	000c410e 	andeq	r4, ip, lr, lsl #2
     f04:	03990100 	orrseq	r0, r9, #0, 2
     f08:	039f0000 	orrseq	r0, pc, #0
     f0c:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
     f10:	00000003 	andeq	r0, r0, r3
     f14:	00085115 	andeq	r5, r8, r5, lsl r1
     f18:	10990500 	addsne	r0, r9, r0, lsl #10
     f1c:	000007de 	ldrdeq	r0, [r0], -lr
     f20:	00000404 	andeq	r0, r0, r4, lsl #8
     f24:	0003b401 	andeq	fp, r3, r1, lsl #8
     f28:	03fe1000 	mvnseq	r1, #0
     f2c:	e2110000 	ands	r0, r1, #0
     f30:	11000003 	tstne	r0, r3
     f34:	0000022d 	andeq	r0, r0, sp, lsr #4
     f38:	25160000 	ldrcs	r0, [r6, #-0]
     f3c:	d5000000 	strle	r0, [r0, #-0]
     f40:	17000003 	strne	r0, [r0, -r3]
     f44:	00000076 	andeq	r0, r0, r6, ror r0
     f48:	0102000f 	tsteq	r2, pc
     f4c:	00060202 	andeq	r0, r6, r2, lsl #4
     f50:	64041800 	strvs	r1, [r4], #-2048	; 0xfffff800
     f54:	18000002 	stmdane	r0, {r1}
     f58:	00002c04 	andeq	r2, r0, r4, lsl #24
     f5c:	0b570c00 	bleq	15c3f64 <__bss_end+0x15ba5f8>
     f60:	04180000 	ldreq	r0, [r8], #-0
     f64:	000003e8 	andeq	r0, r0, r8, ror #7
     f68:	00031416 	andeq	r1, r3, r6, lsl r4
     f6c:	0003fe00 	andeq	pc, r3, r0, lsl #28
     f70:	18001900 	stmdane	r0, {r8, fp, ip}
     f74:	00025704 	andeq	r5, r2, r4, lsl #14
     f78:	52041800 	andpl	r1, r4, #0, 16
     f7c:	1a000002 	bne	f8c <shift+0xf8c>
     f80:	000005f6 	strdeq	r0, [r0], -r6
     f84:	57149c05 	ldrpl	r9, [r4, -r5, lsl #24]
     f88:	06000002 	streq	r0, [r0], -r2
     f8c:	000004eb 	andeq	r0, r0, fp, ror #9
     f90:	71140406 	tstvc	r4, r6, lsl #8
     f94:	05000000 	streq	r0, [r0, #-0]
     f98:	00992403 	addseq	r2, r9, r3, lsl #8
     f9c:	03ae0600 			; <UNDEFINED> instruction: 0x03ae0600
     fa0:	07060000 	streq	r0, [r6, -r0]
     fa4:	00007114 	andeq	r7, r0, r4, lsl r1
     fa8:	28030500 	stmdacs	r3, {r8, sl}
     fac:	06000099 			; <UNDEFINED> instruction: 0x06000099
     fb0:	00000afa 	strdeq	r0, [r0], -sl
     fb4:	71140a06 	tstvc	r4, r6, lsl #20
     fb8:	05000000 	streq	r0, [r0, #-0]
     fbc:	00992c03 	addseq	r2, r9, r3, lsl #24
     fc0:	042c0900 	strteq	r0, [ip], #-2304	; 0xfffff700
     fc4:	04050000 	streq	r0, [r5], #-0
     fc8:	00000049 	andeq	r0, r0, r9, asr #32
     fcc:	830c0d06 	movwhi	r0, #52486	; 0xcd06
     fd0:	0a000004 	beq	fe8 <shift+0xfe8>
     fd4:	0077654e 	rsbseq	r6, r7, lr, asr #10
     fd8:	09320b00 	ldmdbeq	r2!, {r8, r9, fp}
     fdc:	0b010000 	bleq	40fe4 <__bss_end+0x37678>
     fe0:	00000b36 	andeq	r0, r0, r6, lsr fp
     fe4:	08ce0b02 	stmiaeq	lr, {r1, r8, r9, fp}^
     fe8:	0b030000 	bleq	c0ff0 <__bss_end+0xb7684>
     fec:	000006c9 	andeq	r0, r0, r9, asr #13
     ff0:	07610b04 	strbeq	r0, [r1, -r4, lsl #22]!
     ff4:	00050000 	andeq	r0, r5, r0
     ff8:	00041f07 	andeq	r1, r4, r7, lsl #30
     ffc:	1b061000 	blne	185004 <__bss_end+0x17b698>
    1000:	0004c208 	andeq	ip, r4, r8, lsl #4
    1004:	726c0800 	rsbvc	r0, ip, #0, 16
    1008:	131d0600 	tstne	sp, #0, 12
    100c:	000004c2 	andeq	r0, r0, r2, asr #9
    1010:	70730800 	rsbsvc	r0, r3, r0, lsl #16
    1014:	131e0600 	tstne	lr, #0, 12
    1018:	000004c2 	andeq	r0, r0, r2, asr #9
    101c:	63700804 	cmnvs	r0, #4, 16	; 0x40000
    1020:	131f0600 	tstne	pc, #0, 12
    1024:	000004c2 	andeq	r0, r0, r2, asr #9
    1028:	083a0e08 	ldmdaeq	sl!, {r3, r9, sl, fp}
    102c:	20060000 	andcs	r0, r6, r0
    1030:	0004c213 	andeq	ip, r4, r3, lsl r2
    1034:	02000c00 	andeq	r0, r0, #0, 24
    1038:	07c30704 	strbeq	r0, [r3, r4, lsl #14]
    103c:	34070000 	strcc	r0, [r7], #-0
    1040:	7000000c 	andvc	r0, r0, ip
    1044:	59082806 	stmdbpl	r8, {r1, r2, fp, sp}
    1048:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    104c:	0000063b 	andeq	r0, r0, fp, lsr r6
    1050:	83122a06 	tsthi	r2, #24576	; 0x6000
    1054:	00000004 	andeq	r0, r0, r4
    1058:	64697008 	strbtvs	r7, [r9], #-8
    105c:	122b0600 	eorne	r0, fp, #0, 12
    1060:	00000076 	andeq	r0, r0, r6, ror r0
    1064:	15580e10 	ldrbne	r0, [r8, #-3600]	; 0xfffff1f0
    1068:	2c060000 	stccs	0, cr0, [r6], {-0}
    106c:	00044c11 	andeq	r4, r4, r1, lsl ip
    1070:	ba0e1400 	blt	386078 <__bss_end+0x37c70c>
    1074:	0600000b 	streq	r0, [r0], -fp
    1078:	0076122d 	rsbseq	r1, r6, sp, lsr #4
    107c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    1080:	0000065f 	andeq	r0, r0, pc, asr r6
    1084:	76122e06 	ldrvc	r2, [r2], -r6, lsl #28
    1088:	1c000000 	stcne	0, cr0, [r0], {-0}
    108c:	00039b0e 	andeq	r9, r3, lr, lsl #22
    1090:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 1098 <shift+0x1098>
    1094:	00000559 	andeq	r0, r0, r9, asr r5
    1098:	06aa0e20 	strteq	r0, [sl], r0, lsr #28
    109c:	30060000 	andcc	r0, r6, r0
    10a0:	00004909 	andeq	r4, r0, r9, lsl #18
    10a4:	130e6000 	movwne	r6, #57344	; 0xe000
    10a8:	06000004 	streq	r0, [r0], -r4
    10ac:	00650e31 	rsbeq	r0, r5, r1, lsr lr
    10b0:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    10b4:	0000040a 	andeq	r0, r0, sl, lsl #8
    10b8:	650e3306 	strvs	r3, [lr, #-774]	; 0xfffffcfa
    10bc:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    10c0:	0004010e 	andeq	r0, r4, lr, lsl #2
    10c4:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
    10c8:	00000065 	andeq	r0, r0, r5, rrx
    10cc:	0416006c 	ldreq	r0, [r6], #-108	; 0xffffff94
    10d0:	69000004 	stmdbvs	r0, {r2}
    10d4:	17000005 	strne	r0, [r0, -r5]
    10d8:	00000076 	andeq	r0, r0, r6, ror r0
    10dc:	b006000f 	andlt	r0, r6, pc
    10e0:	07000005 	streq	r0, [r0, -r5]
    10e4:	0071140a 	rsbseq	r1, r1, sl, lsl #8
    10e8:	03050000 	movweq	r0, #20480	; 0x5000
    10ec:	00009930 	andeq	r9, r0, r0, lsr r9
    10f0:	000a8f09 	andeq	r8, sl, r9, lsl #30
    10f4:	49040500 	stmdbmi	r4, {r8, sl}
    10f8:	07000000 	streq	r0, [r0, -r0]
    10fc:	059a0c0d 	ldreq	r0, [sl, #3085]	; 0xc0d
    1100:	6f0b0000 	svcvs	0x000b0000
    1104:	0000000b 	andeq	r0, r0, fp
    1108:	0005bf0b 	andeq	fp, r5, fp, lsl #30
    110c:	03000100 	movweq	r0, #256	; 0x100
    1110:	0000057b 	andeq	r0, r0, fp, ror r5
    1114:	000df809 	andeq	pc, sp, r9, lsl #16
    1118:	49040500 	stmdbmi	r4, {r8, sl}
    111c:	07000000 	streq	r0, [r0, -r0]
    1120:	05be0c14 	ldreq	r0, [lr, #3092]!	; 0xc14
    1124:	660b0000 	strvs	r0, [fp], -r0
    1128:	0000000c 	andeq	r0, r0, ip
    112c:	000ea50b 	andeq	sl, lr, fp, lsl #10
    1130:	03000100 	movweq	r0, #256	; 0x100
    1134:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1138:	000ba707 	andeq	sl, fp, r7, lsl #14
    113c:	1b070c00 	blne	1c4144 <__bss_end+0x1ba7d8>
    1140:	0005f808 	andeq	pc, r5, r8, lsl #16
    1144:	0b6a0e00 	bleq	1a8494c <__bss_end+0x1a7afe0>
    1148:	1d070000 	stcne	0, cr0, [r7, #-0]
    114c:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
    1150:	e00e0000 	and	r0, lr, r0
    1154:	0700000b 	streq	r0, [r0, -fp]
    1158:	05f8191e 	ldrbeq	r1, [r8, #2334]!	; 0x91e
    115c:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1160:	0000082a 	andeq	r0, r0, sl, lsr #16
    1164:	fe131f07 	cdp2	15, 1, cr1, cr3, cr7, {0}
    1168:	08000005 	stmdaeq	r0, {r0, r2}
    116c:	c3041800 	movwgt	r1, #18432	; 0x4800
    1170:	18000005 	stmdane	r0, {r0, r2}
    1174:	0004c904 	andeq	ip, r4, r4, lsl #18
    1178:	07910d00 	ldreq	r0, [r1, r0, lsl #26]
    117c:	07140000 	ldreq	r0, [r4, -r0]
    1180:	08860722 	stmeq	r6, {r1, r5, r8, r9, sl}
    1184:	070e0000 	streq	r0, [lr, -r0]
    1188:	07000006 	streq	r0, [r0, -r6]
    118c:	00651226 	rsbeq	r1, r5, r6, lsr #4
    1190:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1194:	00000889 	andeq	r0, r0, r9, lsl #17
    1198:	f81d2907 			; <UNDEFINED> instruction: 0xf81d2907
    119c:	04000005 	streq	r0, [r0], #-5
    11a0:	0009c00e 	andeq	ip, r9, lr
    11a4:	1d2c0700 	stcne	7, cr0, [ip, #-0]
    11a8:	000005f8 	strdeq	r0, [r0], -r8
    11ac:	05d61b08 	ldrbeq	r1, [r6, #2824]	; 0xb08
    11b0:	2f070000 	svccs	0x00070000
    11b4:	000b840e 	andeq	r8, fp, lr, lsl #8
    11b8:	00064c00 	andeq	r4, r6, r0, lsl #24
    11bc:	00065700 	andeq	r5, r6, r0, lsl #14
    11c0:	088b1000 	stmeq	fp, {ip}
    11c4:	f8110000 			; <UNDEFINED> instruction: 0xf8110000
    11c8:	00000005 	andeq	r0, r0, r5
    11cc:	0006161c 	andeq	r1, r6, ip, lsl r6
    11d0:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
    11d4:	00000c0b 	andeq	r0, r0, fp, lsl #24
    11d8:	000003d5 	ldrdeq	r0, [r0], -r5
    11dc:	0000066f 	andeq	r0, r0, pc, ror #12
    11e0:	0000067a 	andeq	r0, r0, sl, ror r6
    11e4:	00088b10 	andeq	r8, r8, r0, lsl fp
    11e8:	05fe1100 	ldrbeq	r1, [lr, #256]!	; 0x100
    11ec:	13000000 	movwne	r0, #0
    11f0:	00000755 	andeq	r0, r0, r5, asr r7
    11f4:	0d1d3507 	cfldr32eq	mvfx3, [sp, #-28]	; 0xffffffe4
    11f8:	f8000009 			; <UNDEFINED> instruction: 0xf8000009
    11fc:	02000005 	andeq	r0, r0, #5
    1200:	00000693 	muleq	r0, r3, r6
    1204:	00000699 	muleq	r0, r9, r6
    1208:	00088b10 	andeq	r8, r8, r0, lsl fp
    120c:	c8130000 	ldmdagt	r3, {}	; <UNPREDICTABLE>
    1210:	0700000b 	streq	r0, [r0, -fp]
    1214:	0be51d37 	bleq	ff9486f8 <__bss_end+0xff93ed8c>
    1218:	05f80000 	ldrbeq	r0, [r8, #0]!
    121c:	b2020000 	andlt	r0, r2, #0
    1220:	b8000006 	stmdalt	r0, {r1, r2}
    1224:	10000006 	andne	r0, r0, r6
    1228:	0000088b 	andeq	r0, r0, fp, lsl #17
    122c:	09491d00 	stmdbeq	r9, {r8, sl, fp, ip}^
    1230:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
    1234:	0008a431 	andeq	sl, r8, r1, lsr r4
    1238:	13020c00 	movwne	r0, #11264	; 0x2c00
    123c:	00000791 	muleq	r0, r1, r7
    1240:	e0093c07 	and	r3, r9, r7, lsl #24
    1244:	8b000008 	blhi	126c <shift+0x126c>
    1248:	01000008 	tsteq	r0, r8
    124c:	000006df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1250:	000006e5 	andeq	r0, r0, r5, ror #13
    1254:	00088b10 	andeq	r8, r8, r0, lsl fp
    1258:	47130000 	ldrmi	r0, [r3, -r0]
    125c:	07000006 	streq	r0, [r0, -r6]
    1260:	06e6123f 			; <UNDEFINED> instruction: 0x06e6123f
    1264:	00650000 	rsbeq	r0, r5, r0
    1268:	fe010000 	cdp2	0, 0, cr0, cr1, cr0, {0}
    126c:	13000006 	movwne	r0, #6
    1270:	10000007 	andne	r0, r0, r7
    1274:	0000088b 	andeq	r0, r0, fp, lsl #17
    1278:	0008ad11 	andeq	sl, r8, r1, lsl sp
    127c:	00761100 	rsbseq	r1, r6, r0, lsl #2
    1280:	d5110000 	ldrle	r0, [r1, #-0]
    1284:	00000003 	andeq	r0, r0, r3
    1288:	0006dd14 	andeq	sp, r6, r4, lsl sp
    128c:	0e420700 	cdpeq	7, 4, cr0, cr2, cr0, {0}
    1290:	00000567 	andeq	r0, r0, r7, ror #10
    1294:	00072801 	andeq	r2, r7, r1, lsl #16
    1298:	00072e00 	andeq	r2, r7, r0, lsl #28
    129c:	088b1000 	stmeq	fp, {ip}
    12a0:	13000000 	movwne	r0, #0
    12a4:	00000b22 	andeq	r0, r0, r2, lsr #22
    12a8:	bd174507 	cfldr32lt	mvfx4, [r7, #-28]	; 0xffffffe4
    12ac:	fe000004 	cdp2	0, 0, cr0, cr0, cr4, {0}
    12b0:	01000005 	tsteq	r0, r5
    12b4:	00000747 	andeq	r0, r0, r7, asr #14
    12b8:	0000074d 	andeq	r0, r0, sp, asr #14
    12bc:	0008b310 	andeq	fp, r8, r0, lsl r3
    12c0:	99130000 	ldmdbls	r3, {}	; <UNPREDICTABLE>
    12c4:	07000009 	streq	r0, [r0, -r9]
    12c8:	053a1748 	ldreq	r1, [sl, #-1864]!	; 0xfffff8b8
    12cc:	05fe0000 	ldrbeq	r0, [lr, #0]!
    12d0:	66010000 	strvs	r0, [r1], -r0
    12d4:	71000007 	tstvc	r0, r7
    12d8:	10000007 	andne	r0, r0, r7
    12dc:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    12e0:	00006511 	andeq	r6, r0, r1, lsl r5
    12e4:	09140000 	ldmdbeq	r4, {}	; <UNPREDICTABLE>
    12e8:	07000008 	streq	r0, [r0, -r8]
    12ec:	09570e4b 	ldmdbeq	r7, {r0, r1, r3, r6, r9, sl, fp}^
    12f0:	86010000 	strhi	r0, [r1], -r0
    12f4:	8c000007 	stchi	0, cr0, [r0], {7}
    12f8:	10000007 	andne	r0, r0, r7
    12fc:	0000088b 	andeq	r0, r0, fp, lsl #17
    1300:	06161300 	ldreq	r1, [r6], -r0, lsl #6
    1304:	4d070000 	stcmi	0, cr0, [r7, #-0]
    1308:	0005880e 	andeq	r8, r5, lr, lsl #16
    130c:	0003d500 	andeq	sp, r3, r0, lsl #10
    1310:	07a50100 	streq	r0, [r5, r0, lsl #2]!
    1314:	07b00000 	ldreq	r0, [r0, r0]!
    1318:	8b100000 	blhi	401320 <__bss_end+0x3f79b4>
    131c:	11000008 	tstne	r0, r8
    1320:	00000065 	andeq	r0, r0, r5, rrx
    1324:	09ac1300 	stmibeq	ip!, {r8, r9, ip}
    1328:	50070000 	andpl	r0, r7, r0
    132c:	00085612 	andeq	r5, r8, r2, lsl r6
    1330:	00006500 	andeq	r6, r0, r0, lsl #10
    1334:	07c90100 	strbeq	r0, [r9, r0, lsl #2]
    1338:	07d40000 	ldrbeq	r0, [r4, r0]
    133c:	8b100000 	blhi	401344 <__bss_end+0x3f79d8>
    1340:	11000008 	tstne	r0, r8
    1344:	00000404 	andeq	r0, r0, r4, lsl #8
    1348:	07111300 	ldreq	r1, [r1, -r0, lsl #6]
    134c:	53070000 	movwpl	r0, #28672	; 0x7000
    1350:	0007290e 	andeq	r2, r7, lr, lsl #18
    1354:	0003d500 	andeq	sp, r3, r0, lsl #10
    1358:	07ed0100 	strbeq	r0, [sp, r0, lsl #2]!
    135c:	07f80000 	ldrbeq	r0, [r8, r0]!
    1360:	8b100000 	blhi	401368 <__bss_end+0x3f79fc>
    1364:	11000008 	tstne	r0, r8
    1368:	00000065 	andeq	r0, r0, r5, rrx
    136c:	09861400 	stmibeq	r6, {sl, ip}
    1370:	56070000 	strpl	r0, [r7], -r0
    1374:	0009df0e 	andeq	sp, r9, lr, lsl #30
    1378:	080d0100 	stmdaeq	sp, {r8}
    137c:	082c0000 	stmdaeq	ip!, {}	; <UNPREDICTABLE>
    1380:	8b100000 	blhi	401388 <__bss_end+0x3f7a1c>
    1384:	11000008 	tstne	r0, r8
    1388:	00000110 	andeq	r0, r0, r0, lsl r1
    138c:	00006511 	andeq	r6, r0, r1, lsl r5
    1390:	00651100 	rsbeq	r1, r5, r0, lsl #2
    1394:	65110000 	ldrvs	r0, [r1, #-0]
    1398:	11000000 	mrsne	r0, (UNDEF: 0)
    139c:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    13a0:	06251400 	strteq	r1, [r5], -r0, lsl #8
    13a4:	58070000 	stmdapl	r7, {}	; <UNPREDICTABLE>
    13a8:	000a370e 	andeq	r3, sl, lr, lsl #14
    13ac:	08410100 	stmdaeq	r1, {r8}^
    13b0:	08600000 	stmdaeq	r0!, {}^	; <UNPREDICTABLE>
    13b4:	8b100000 	blhi	4013bc <__bss_end+0x3f7a50>
    13b8:	11000008 	tstne	r0, r8
    13bc:	00000147 	andeq	r0, r0, r7, asr #2
    13c0:	00006511 	andeq	r6, r0, r1, lsl r5
    13c4:	00651100 	rsbeq	r1, r5, r0, lsl #2
    13c8:	65110000 	ldrvs	r0, [r1, #-0]
    13cc:	11000000 	mrsne	r0, (UNDEF: 0)
    13d0:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    13d4:	08fa1500 	ldmeq	sl!, {r8, sl, ip}^
    13d8:	5b070000 	blpl	1c13e0 <__bss_end+0x1b7a74>
    13dc:	0004500e 	andeq	r5, r4, lr
    13e0:	0003d500 	andeq	sp, r3, r0, lsl #10
    13e4:	08750100 	ldmdaeq	r5!, {r8}^
    13e8:	8b100000 	blhi	4013f0 <__bss_end+0x3f7a84>
    13ec:	11000008 	tstne	r0, r8
    13f0:	0000057b 	andeq	r0, r0, fp, ror r5
    13f4:	0008bf11 	andeq	fp, r8, r1, lsl pc
    13f8:	03000000 	movweq	r0, #0
    13fc:	00000604 	andeq	r0, r0, r4, lsl #12
    1400:	06040418 			; <UNDEFINED> instruction: 0x06040418
    1404:	f81e0000 			; <UNDEFINED> instruction: 0xf81e0000
    1408:	9e000005 	cdpls	0, 0, cr0, cr0, cr5, {0}
    140c:	a4000008 	strge	r0, [r0], #-8
    1410:	10000008 	andne	r0, r0, r8
    1414:	0000088b 	andeq	r0, r0, fp, lsl #17
    1418:	06041f00 	streq	r1, [r4], -r0, lsl #30
    141c:	08910000 	ldmeq	r1, {}	; <UNPREDICTABLE>
    1420:	04180000 	ldreq	r0, [r8], #-0
    1424:	00000057 	andeq	r0, r0, r7, asr r0
    1428:	08860418 	stmeq	r6, {r3, r4, sl}
    142c:	04200000 	strteq	r0, [r0], #-0
    1430:	000000cc 	andeq	r0, r0, ip, asr #1
    1434:	ad1a0421 	cfldrsge	mvf0, [sl, #-132]	; 0xffffff7c
    1438:	07000007 	streq	r0, [r0, -r7]
    143c:	0604195e 			; <UNDEFINED> instruction: 0x0604195e
    1440:	72060000 	andvc	r0, r6, #0
    1444:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    1448:	08e61104 	stmiaeq	r6!, {r2, r8, ip}^
    144c:	03050000 	movweq	r0, #20480	; 0x5000
    1450:	00009934 	andeq	r9, r0, r4, lsr r9
    1454:	d6040402 	strle	r0, [r4], -r2, lsl #8
    1458:	03000015 	movweq	r0, #21
    145c:	000008df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1460:	00002c16 	andeq	r2, r0, r6, lsl ip
    1464:	0008fb00 	andeq	pc, r8, r0, lsl #22
    1468:	00761700 	rsbseq	r1, r6, r0, lsl #14
    146c:	00090000 	andeq	r0, r9, r0
    1470:	0008eb03 	andeq	lr, r8, r3, lsl #22
    1474:	0d1d2200 	lfmeq	f2, 4, [sp, #-0]
    1478:	a4010000 	strge	r0, [r1], #-0
    147c:	0008fb0c 	andeq	pc, r8, ip, lsl #22
    1480:	38030500 	stmdacc	r3, {r8, sl}
    1484:	23000099 	movwcs	r0, #153	; 0x99
    1488:	00000c7f 	andeq	r0, r0, pc, ror ip
    148c:	ec0aa601 	stc	6, cr10, [sl], {1}
    1490:	6500000d 	strvs	r0, [r0, #-13]
    1494:	20000000 	andcs	r0, r0, r0
    1498:	b0000086 	andlt	r0, r0, r6, lsl #1
    149c:	01000000 	mrseq	r0, (UNDEF: 0)
    14a0:	0009709c 	muleq	r9, ip, r0
    14a4:	1b652400 	blne	194a4ac <__bss_end+0x1940b40>
    14a8:	a6010000 	strge	r0, [r1], -r0
    14ac:	0003e21b 	andeq	lr, r3, fp, lsl r2
    14b0:	ac910300 	ldcge	3, cr0, [r1], {0}
    14b4:	0e81247f 	mcreq	4, 4, r2, cr1, cr15, {3}
    14b8:	a6010000 	strge	r0, [r1], -r0
    14bc:	0000652a 	andeq	r6, r0, sl, lsr #10
    14c0:	a8910300 	ldmge	r1, {r8, r9}
    14c4:	0dd4227f 	lfmeq	f2, 2, [r4, #508]	; 0x1fc
    14c8:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    14cc:	0009700a 	andeq	r7, r9, sl
    14d0:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    14d4:	0c7a227f 	lfmeq	f2, 2, [sl], #-508	; 0xfffffe04
    14d8:	ac010000 	stcge	0, cr0, [r1], {-0}
    14dc:	00004909 	andeq	r4, r0, r9, lsl #18
    14e0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14e4:	00251600 	eoreq	r1, r5, r0, lsl #12
    14e8:	09800000 	stmibeq	r0, {}	; <UNPREDICTABLE>
    14ec:	76170000 	ldrvc	r0, [r7], -r0
    14f0:	3f000000 	svccc	0x00000000
    14f4:	0e572500 	cdpeq	5, 5, cr2, cr7, cr0, {0}
    14f8:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    14fc:	000eca0a 	andeq	ip, lr, sl, lsl #20
    1500:	00006500 	andeq	r6, r0, r0, lsl #10
    1504:	0085e400 	addeq	lr, r5, r0, lsl #8
    1508:	00003c00 	andeq	r3, r0, r0, lsl #24
    150c:	bd9c0100 	ldflts	f0, [ip]
    1510:	26000009 	strcs	r0, [r0], -r9
    1514:	00716572 	rsbseq	r6, r1, r2, ror r5
    1518:	be209a01 	vmullt.f32	s18, s0, s2
    151c:	02000005 	andeq	r0, r0, #5
    1520:	e1227491 			; <UNDEFINED> instruction: 0xe1227491
    1524:	0100000d 	tsteq	r0, sp
    1528:	00650e9b 	mlseq	r5, fp, lr, r0
    152c:	91020000 	mrsls	r0, (UNDEF: 2)
    1530:	6b270070 	blvs	9c16f8 <__bss_end+0x9b7d8c>
    1534:	0100000d 	tsteq	r0, sp
    1538:	0ca7068f 	stceq	6, cr0, [r7], #572	; 0x23c
    153c:	85a80000 	strhi	r0, [r8, #0]!
    1540:	003c0000 	eorseq	r0, ip, r0
    1544:	9c010000 	stcls	0, cr0, [r1], {-0}
    1548:	000009f6 	strdeq	r0, [r0], -r6
    154c:	000d0924 	andeq	r0, sp, r4, lsr #18
    1550:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1554:	00000065 	andeq	r0, r0, r5, rrx
    1558:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    155c:	00716572 	rsbseq	r6, r1, r2, ror r5
    1560:	be209101 	abslts	f1, f1
    1564:	02000005 	andeq	r0, r0, #5
    1568:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    156c:	00000e0d 	andeq	r0, r0, sp, lsl #28
    1570:	390a8301 	stmdbcc	sl, {r0, r8, r9, pc}
    1574:	6500000d 	strvs	r0, [r0, #-13]
    1578:	6c000000 	stcvs	0, cr0, [r0], {-0}
    157c:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    1580:	01000000 	mrseq	r0, (UNDEF: 0)
    1584:	000a339c 	muleq	sl, ip, r3
    1588:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    158c:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1590:	00059a20 	andeq	r9, r5, r0, lsr #20
    1594:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1598:	000c7322 	andeq	r7, ip, r2, lsr #6
    159c:	0e860100 	rmfeqs	f0, f6, f0
    15a0:	00000065 	andeq	r0, r0, r5, rrx
    15a4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    15a8:	000f6825 	andeq	r6, pc, r5, lsr #16
    15ac:	0a770100 	beq	1dc19b4 <__bss_end+0x1db8048>
    15b0:	00000ceb 	andeq	r0, r0, fp, ror #25
    15b4:	00000065 	andeq	r0, r0, r5, rrx
    15b8:	00008530 	andeq	r8, r0, r0, lsr r5
    15bc:	0000003c 	andeq	r0, r0, ip, lsr r0
    15c0:	0a709c01 	beq	1c285cc <__bss_end+0x1c1ec60>
    15c4:	72260000 	eorvc	r0, r6, #0
    15c8:	01007165 	tsteq	r0, r5, ror #2
    15cc:	059a2079 	ldreq	r2, [sl, #121]	; 0x79
    15d0:	91020000 	mrsls	r0, (UNDEF: 2)
    15d4:	0c732274 	lfmeq	f2, 2, [r3], #-464	; 0xfffffe30
    15d8:	7a010000 	bvc	415e0 <__bss_end+0x37c74>
    15dc:	0000650e 	andeq	r6, r0, lr, lsl #10
    15e0:	70910200 	addsvc	r0, r1, r0, lsl #4
    15e4:	0d4d2500 	cfstr64eq	mvdx2, [sp, #-0]
    15e8:	6b010000 	blvs	415f0 <__bss_end+0x37c84>
    15ec:	000e9506 	andeq	r9, lr, r6, lsl #10
    15f0:	0003d500 	andeq	sp, r3, r0, lsl #10
    15f4:	0084dc00 	addeq	sp, r4, r0, lsl #24
    15f8:	00005400 	andeq	r5, r0, r0, lsl #8
    15fc:	bc9c0100 	ldflts	f0, [ip], {0}
    1600:	2400000a 	strcs	r0, [r0], #-10
    1604:	00000de1 	andeq	r0, r0, r1, ror #27
    1608:	65156b01 	ldrvs	r6, [r5, #-2817]	; 0xfffff4ff
    160c:	02000000 	andeq	r0, r0, #0
    1610:	01246c91 			; <UNDEFINED> instruction: 0x01246c91
    1614:	01000004 	tsteq	r0, r4
    1618:	0065256b 	rsbeq	r2, r5, fp, ror #10
    161c:	91020000 	mrsls	r0, (UNDEF: 2)
    1620:	0f602268 	svceq	0x00602268
    1624:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1628:	0000650e 	andeq	r6, r0, lr, lsl #10
    162c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1630:	0cbe2500 	cfldr32eq	mvfx2, [lr]
    1634:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1638:	000f0112 	andeq	r0, pc, r2, lsl r1	; <UNPREDICTABLE>
    163c:	0000f200 	andeq	pc, r0, r0, lsl #4
    1640:	00848c00 	addeq	r8, r4, r0, lsl #24
    1644:	00005000 	andeq	r5, r0, r0
    1648:	179c0100 	ldrne	r0, [ip, r0, lsl #2]
    164c:	2400000b 	strcs	r0, [r0], #-11
    1650:	00000ea0 	andeq	r0, r0, r0, lsr #29
    1654:	65205e01 	strvs	r5, [r0, #-3585]!	; 0xfffff1ff
    1658:	02000000 	andeq	r0, r0, #0
    165c:	16246c91 			; <UNDEFINED> instruction: 0x16246c91
    1660:	0100000e 	tsteq	r0, lr
    1664:	00652f5e 	rsbeq	r2, r5, lr, asr pc
    1668:	91020000 	mrsls	r0, (UNDEF: 2)
    166c:	04012468 	streq	r2, [r1], #-1128	; 0xfffffb98
    1670:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1674:	0000653f 	andeq	r6, r0, pc, lsr r5
    1678:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    167c:	000f6022 	andeq	r6, pc, r2, lsr #32
    1680:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1684:	000000f2 	strdeq	r0, [r0], -r2
    1688:	00749102 	rsbseq	r9, r4, r2, lsl #2
    168c:	000dda25 	andeq	sp, sp, r5, lsr #20
    1690:	0a520100 	beq	1481a98 <__bss_end+0x147812c>
    1694:	00000cc3 	andeq	r0, r0, r3, asr #25
    1698:	00000065 	andeq	r0, r0, r5, rrx
    169c:	00008448 	andeq	r8, r0, r8, asr #8
    16a0:	00000044 	andeq	r0, r0, r4, asr #32
    16a4:	0b639c01 	bleq	18e86b0 <__bss_end+0x18ded44>
    16a8:	a0240000 	eorge	r0, r4, r0
    16ac:	0100000e 	tsteq	r0, lr
    16b0:	00651a52 	rsbeq	r1, r5, r2, asr sl
    16b4:	91020000 	mrsls	r0, (UNDEF: 2)
    16b8:	0e16246c 	cdpeq	4, 1, cr2, cr6, cr12, {3}
    16bc:	52010000 	andpl	r0, r1, #0
    16c0:	00006529 	andeq	r6, r0, r9, lsr #10
    16c4:	68910200 	ldmvs	r1, {r9}
    16c8:	000f3022 	andeq	r3, pc, r2, lsr #32
    16cc:	0e540100 	rdfeqs	f0, f4, f0
    16d0:	00000065 	andeq	r0, r0, r5, rrx
    16d4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16d8:	000f2a25 	andeq	r2, pc, r5, lsr #20
    16dc:	0a450100 	beq	1141ae4 <__bss_end+0x1138178>
    16e0:	00000f0c 	andeq	r0, r0, ip, lsl #30
    16e4:	00000065 	andeq	r0, r0, r5, rrx
    16e8:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    16ec:	00000050 	andeq	r0, r0, r0, asr r0
    16f0:	0bbe9c01 	bleq	fefa86fc <__bss_end+0xfef9ed90>
    16f4:	a0240000 	eorge	r0, r4, r0
    16f8:	0100000e 	tsteq	r0, lr
    16fc:	00651945 	rsbeq	r1, r5, r5, asr #18
    1700:	91020000 	mrsls	r0, (UNDEF: 2)
    1704:	0d7d246c 	cfldrdeq	mvd2, [sp, #-432]!	; 0xfffffe50
    1708:	45010000 	strmi	r0, [r1, #-0]
    170c:	00018430 	andeq	r8, r1, r0, lsr r4
    1710:	68910200 	ldmvs	r1, {r9}
    1714:	000e4324 	andeq	r4, lr, r4, lsr #6
    1718:	41450100 	mrsmi	r0, (UNDEF: 85)
    171c:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    1720:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1724:	00000f60 	andeq	r0, r0, r0, ror #30
    1728:	650e4701 	strvs	r4, [lr, #-1793]	; 0xfffff8ff
    172c:	02000000 	andeq	r0, r0, #0
    1730:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1734:	00000c60 	andeq	r0, r0, r0, ror #24
    1738:	87063f01 	strhi	r3, [r6, -r1, lsl #30]
    173c:	cc00000d 	stcgt	0, cr0, [r0], {13}
    1740:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1744:	01000000 	mrseq	r0, (UNDEF: 0)
    1748:	000be89c 	muleq	fp, ip, r8
    174c:	0ea02400 	cdpeq	4, 10, cr2, cr0, cr0, {0}
    1750:	3f010000 	svccc	0x00010000
    1754:	00006515 	andeq	r6, r0, r5, lsl r5
    1758:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    175c:	0e7b2500 	cdpeq	5, 7, cr2, cr11, cr0, {0}
    1760:	32010000 	andcc	r0, r1, #0
    1764:	000e490a 	andeq	r4, lr, sl, lsl #18
    1768:	00006500 	andeq	r6, r0, r0, lsl #10
    176c:	00837c00 	addeq	r7, r3, r0, lsl #24
    1770:	00005000 	andeq	r5, r0, r0
    1774:	439c0100 	orrsmi	r0, ip, #0, 2
    1778:	2400000c 	strcs	r0, [r0], #-12
    177c:	00000ea0 	andeq	r0, r0, r0, lsr #29
    1780:	65193201 	ldrvs	r3, [r9, #-513]	; 0xfffffdff
    1784:	02000000 	andeq	r0, r0, #0
    1788:	3c246c91 	stccc	12, cr6, [r4], #-580	; 0xfffffdbc
    178c:	0100000f 	tsteq	r0, pc
    1790:	03e22b32 	mvneq	r2, #51200	; 0xc800
    1794:	91020000 	mrsls	r0, (UNDEF: 2)
    1798:	0e852468 	cdpeq	4, 8, cr2, cr5, cr8, {3}
    179c:	32010000 	andcc	r0, r1, #0
    17a0:	0000653c 	andeq	r6, r0, ip, lsr r5
    17a4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17a8:	000efb22 	andeq	pc, lr, r2, lsr #22
    17ac:	0e340100 	rsfeqs	f0, f4, f0
    17b0:	00000065 	andeq	r0, r0, r5, rrx
    17b4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17b8:	000f8a25 	andeq	r8, pc, r5, lsr #20
    17bc:	0a250100 	beq	941bc4 <__bss_end+0x938258>
    17c0:	00000f43 	andeq	r0, r0, r3, asr #30
    17c4:	00000065 	andeq	r0, r0, r5, rrx
    17c8:	0000832c 	andeq	r8, r0, ip, lsr #6
    17cc:	00000050 	andeq	r0, r0, r0, asr r0
    17d0:	0c9e9c01 	ldceq	12, cr9, [lr], {1}
    17d4:	a0240000 	eorge	r0, r4, r0
    17d8:	0100000e 	tsteq	r0, lr
    17dc:	00651825 	rsbeq	r1, r5, r5, lsr #16
    17e0:	91020000 	mrsls	r0, (UNDEF: 2)
    17e4:	0f3c246c 	svceq	0x003c246c
    17e8:	25010000 	strcs	r0, [r1, #-0]
    17ec:	000ca42a 	andeq	sl, ip, sl, lsr #8
    17f0:	68910200 	ldmvs	r1, {r9}
    17f4:	000e8524 	andeq	r8, lr, r4, lsr #10
    17f8:	3b250100 	blcc	941c00 <__bss_end+0x938294>
    17fc:	00000065 	andeq	r0, r0, r5, rrx
    1800:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1804:	00000c90 	muleq	r0, r0, ip
    1808:	650e2701 	strvs	r2, [lr, #-1793]	; 0xfffff8ff
    180c:	02000000 	andeq	r0, r0, #0
    1810:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1814:	00002504 	andeq	r2, r0, r4, lsl #10
    1818:	0c9e0300 	ldceq	3, cr0, [lr], {0}
    181c:	e7250000 	str	r0, [r5, -r0]!
    1820:	0100000d 	tsteq	r0, sp
    1824:	0fa00a19 	svceq	0x00a00a19
    1828:	00650000 	rsbeq	r0, r5, r0
    182c:	82e80000 	rschi	r0, r8, #0
    1830:	00440000 	subeq	r0, r4, r0
    1834:	9c010000 	stcls	0, cr0, [r1], {-0}
    1838:	00000cf5 	strdeq	r0, [r0], -r5
    183c:	000f8124 	andeq	r8, pc, r4, lsr #2
    1840:	1b190100 	blne	641c48 <__bss_end+0x6382dc>
    1844:	000003e2 	andeq	r0, r0, r2, ror #7
    1848:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    184c:	00000f37 	andeq	r0, r0, r7, lsr pc
    1850:	2d351901 			; <UNDEFINED> instruction: 0x2d351901
    1854:	02000002 	andeq	r0, r0, #2
    1858:	a0226891 	mlage	r2, r1, r8, r6
    185c:	0100000e 	tsteq	r0, lr
    1860:	00650e1b 	rsbeq	r0, r5, fp, lsl lr
    1864:	91020000 	mrsls	r0, (UNDEF: 2)
    1868:	84280074 	strthi	r0, [r8], #-116	; 0xffffff8c
    186c:	0100000c 	tsteq	r0, ip
    1870:	0c960614 	ldceq	6, cr0, [r6], {20}
    1874:	82cc0000 	sbchi	r0, ip, #0
    1878:	001c0000 	andseq	r0, ip, r0
    187c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1880:	000f8f27 	andeq	r8, pc, r7, lsr #30
    1884:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1888:	00000ccf 	andeq	r0, r0, pc, asr #25
    188c:	000082a0 	andeq	r8, r0, r0, lsr #5
    1890:	0000002c 	andeq	r0, r0, ip, lsr #32
    1894:	0d359c01 	ldceq	12, cr9, [r5, #-4]!
    1898:	e2240000 	eor	r0, r4, #0
    189c:	0100000c 	tsteq	r0, ip
    18a0:	0049140e 	subeq	r1, r9, lr, lsl #8
    18a4:	91020000 	mrsls	r0, (UNDEF: 2)
    18a8:	99290074 	stmdbls	r9!, {r2, r4, r5, r6}
    18ac:	0100000f 	tsteq	r0, pc
    18b0:	0dc90a04 	vstreq	s1, [r9, #16]
    18b4:	00650000 	rsbeq	r0, r5, r0
    18b8:	82740000 	rsbshi	r0, r4, #0
    18bc:	002c0000 	eoreq	r0, ip, r0
    18c0:	9c010000 	stcls	0, cr0, [r1], {-0}
    18c4:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    18c8:	0e060100 	adfeqs	f0, f6, f0
    18cc:	00000065 	andeq	r0, r0, r5, rrx
    18d0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18d4:	0006f900 	andeq	pc, r6, r0, lsl #18
    18d8:	a2000400 	andge	r0, r0, #0, 8
    18dc:	04000006 	streq	r0, [r0], #-6
    18e0:	000fbc01 	andeq	fp, pc, r1, lsl #24
    18e4:	109f0400 	addsne	r0, pc, r0, lsl #8
    18e8:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    18ec:	86d00000 	ldrbhi	r0, [r0], r0
    18f0:	0fdc0000 	svceq	0x00dc0000
    18f4:	06450000 	strbeq	r0, [r5], -r0
    18f8:	72020000 	andvc	r0, r2, #0
    18fc:	0200000e 	andeq	r0, r0, #14
    1900:	003e1104 	eorseq	r1, lr, r4, lsl #2
    1904:	03050000 	movweq	r0, #20480	; 0x5000
    1908:	00009944 	andeq	r9, r0, r4, asr #18
    190c:	d6040403 	strle	r0, [r4], -r3, lsl #8
    1910:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    1914:	00000037 	andeq	r0, r0, r7, lsr r0
    1918:	00006705 	andeq	r6, r0, r5, lsl #14
    191c:	11df0600 	bicsne	r0, pc, r0, lsl #12
    1920:	05010000 	streq	r0, [r1, #-0]
    1924:	00007f10 	andeq	r7, r0, r0, lsl pc
    1928:	31301100 	teqcc	r0, r0, lsl #2
    192c:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1930:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1934:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1938:	00004645 	andeq	r4, r0, r5, asr #12
    193c:	01030107 	tsteq	r3, r7, lsl #2
    1940:	00000043 	andeq	r0, r0, r3, asr #32
    1944:	00009708 	andeq	r9, r0, r8, lsl #14
    1948:	00007f00 	andeq	r7, r0, r0, lsl #30
    194c:	00840900 	addeq	r0, r4, r0, lsl #18
    1950:	00100000 	andseq	r0, r0, r0
    1954:	00006f04 	andeq	r6, r0, r4, lsl #30
    1958:	07040300 	streq	r0, [r4, -r0, lsl #6]
    195c:	000007c8 	andeq	r0, r0, r8, asr #15
    1960:	00008404 	andeq	r8, r0, r4, lsl #8
    1964:	08010300 	stmdaeq	r1, {r8, r9}
    1968:	00000781 	andeq	r0, r0, r1, lsl #15
    196c:	00009004 	andeq	r9, r0, r4
    1970:	00480a00 	subeq	r0, r8, r0, lsl #20
    1974:	d30b0000 	movwle	r0, #45056	; 0xb000
    1978:	01000011 	tsteq	r0, r1, lsl r0
    197c:	114a07fc 	strdne	r0, [sl, #-124]	; 0xffffff84
    1980:	00370000 	eorseq	r0, r7, r0
    1984:	959c0000 	ldrls	r0, [ip]
    1988:	01100000 	tsteq	r0, r0
    198c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1990:	0000011d 	andeq	r0, r0, sp, lsl r1
    1994:	0100730c 	tsteq	r0, ip, lsl #6
    1998:	011d18fc 			; <UNDEFINED> instruction: 0x011d18fc
    199c:	91020000 	mrsls	r0, (UNDEF: 2)
    19a0:	65720d64 	ldrbvs	r0, [r2, #-3428]!	; 0xfffff29c
    19a4:	fe01007a 	mcr2	0, 0, r0, cr1, cr10, {3}
    19a8:	00003709 	andeq	r3, r0, r9, lsl #14
    19ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19b0:	00126d0e 	andseq	r6, r2, lr, lsl #26
    19b4:	12fe0100 	rscsne	r0, lr, #0, 2
    19b8:	00000037 	andeq	r0, r0, r7, lsr r0
    19bc:	0f709102 	svceq	0x00709102
    19c0:	000095e0 	andeq	r9, r0, r0, ror #11
    19c4:	000000a8 	andeq	r0, r0, r8, lsr #1
    19c8:	00111110 	andseq	r1, r1, r0, lsl r1
    19cc:	01030100 	mrseq	r0, (UNDEF: 19)
    19d0:	0001230c 	andeq	r2, r1, ip, lsl #6
    19d4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    19d8:	0095f80f 	addseq	pc, r5, pc, lsl #16
    19dc:	00008000 	andeq	r8, r0, r0
    19e0:	00641100 	rsbeq	r1, r4, r0, lsl #2
    19e4:	09010801 	stmdbeq	r1, {r0, fp}
    19e8:	00000123 	andeq	r0, r0, r3, lsr #2
    19ec:	00689102 	rsbeq	r9, r8, r2, lsl #2
    19f0:	04120000 	ldreq	r0, [r2], #-0
    19f4:	00000097 	muleq	r0, r7, r0
    19f8:	69050413 	stmdbvs	r5, {r0, r1, r4, sl}
    19fc:	1400746e 	strne	r7, [r0], #-1134	; 0xfffffb92
    1a00:	000011eb 	andeq	r1, r0, fp, ror #3
    1a04:	5506c101 	strpl	ip, [r6, #-257]	; 0xfffffeff
    1a08:	78000012 	stmdavc	r0, {r1, r4}
    1a0c:	24000092 	strcs	r0, [r0], #-146	; 0xffffff6e
    1a10:	01000003 	tsteq	r0, r3
    1a14:	0002299c 	muleq	r2, ip, r9
    1a18:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    1a1c:	3711c101 	ldrcc	ip, [r1, -r1, lsl #2]
    1a20:	03000000 	movweq	r0, #0
    1a24:	0c7fa491 	cfldrdeq	mvd10, [pc], #-580	; 17e8 <shift+0x17e8>
    1a28:	00726662 	rsbseq	r6, r2, r2, ror #12
    1a2c:	291ac101 	ldmdbcs	sl, {r0, r8, lr, pc}
    1a30:	03000002 	movweq	r0, #2
    1a34:	157fa091 	ldrbne	sl, [pc, #-145]!	; 19ab <shift+0x19ab>
    1a38:	00001123 	andeq	r1, r0, r3, lsr #2
    1a3c:	8b32c101 	blhi	cb1e48 <__bss_end+0xca84dc>
    1a40:	03000000 	movweq	r0, #0
    1a44:	0e7f9c91 	mrceq	12, 3, r9, cr15, cr1, {4}
    1a48:	0000122e 	andeq	r1, r0, lr, lsr #4
    1a4c:	840fc301 	strhi	ip, [pc], #-769	; 1a54 <shift+0x1a54>
    1a50:	02000000 	andeq	r0, r0, #0
    1a54:	170e7491 			; <UNDEFINED> instruction: 0x170e7491
    1a58:	01000012 	tsteq	r0, r2, lsl r0
    1a5c:	012306d9 	ldrdeq	r0, [r3, -r9]!
    1a60:	91020000 	mrsls	r0, (UNDEF: 2)
    1a64:	112c0e70 			; <UNDEFINED> instruction: 0x112c0e70
    1a68:	dd010000 	stcle	0, cr0, [r1, #-0]
    1a6c:	00003e11 	andeq	r3, r0, r1, lsl lr
    1a70:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1a74:	0010e90e 	andseq	lr, r0, lr, lsl #18
    1a78:	18e00100 	stmiane	r0!, {r8}^
    1a7c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1a80:	0e609102 	lgneqs	f1, f2
    1a84:	000010f8 	strdeq	r1, [r0], -r8
    1a88:	8b18e101 	blhi	639e94 <__bss_end+0x630528>
    1a8c:	02000000 	andeq	r0, r0, #0
    1a90:	9e0e5c91 	mcrls	12, 0, r5, cr14, cr1, {4}
    1a94:	01000011 	tsteq	r0, r1, lsl r0
    1a98:	022f07e3 	eoreq	r0, pc, #59506688	; 0x38c0000
    1a9c:	91030000 	mrsls	r0, (UNDEF: 3)
    1aa0:	320e7fb8 	andcc	r7, lr, #184, 30	; 0x2e0
    1aa4:	01000011 	tsteq	r0, r1, lsl r0
    1aa8:	012306e5 	smulwteq	r3, r5, r6
    1aac:	91020000 	mrsls	r0, (UNDEF: 2)
    1ab0:	94841658 	strls	r1, [r4], #1624	; 0x658
    1ab4:	00500000 	subseq	r0, r0, r0
    1ab8:	01f70000 	mvnseq	r0, r0
    1abc:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1ac0:	0be70100 	bleq	ff9c1ec8 <__bss_end+0xff9b855c>
    1ac4:	00000123 	andeq	r0, r0, r3, lsr #2
    1ac8:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1acc:	0094e00f 	addseq	lr, r4, pc
    1ad0:	00009800 	andeq	r9, r0, r0, lsl #16
    1ad4:	111c0e00 	tstne	ip, r0, lsl #28
    1ad8:	ef010000 	svc	0x00010000
    1adc:	00023f08 	andeq	r3, r2, r8, lsl #30
    1ae0:	ac910300 	ldcge	3, cr0, [r1], {0}
    1ae4:	95100f7f 	ldrls	r0, [r0, #-3967]	; 0xfffff081
    1ae8:	00680000 	rsbeq	r0, r8, r0
    1aec:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1af0:	0cf20100 	ldfeqe	f0, [r2]
    1af4:	00000123 	andeq	r0, r0, r3, lsr #2
    1af8:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1afc:	04120000 	ldreq	r0, [r2], #-0
    1b00:	00000090 	muleq	r0, r0, r0
    1b04:	00009008 	andeq	r9, r0, r8
    1b08:	00023f00 	andeq	r3, r2, r0, lsl #30
    1b0c:	00840900 	addeq	r0, r4, r0, lsl #18
    1b10:	001f0000 	andseq	r0, pc, r0
    1b14:	00009008 	andeq	r9, r0, r8
    1b18:	00024f00 	andeq	r4, r2, r0, lsl #30
    1b1c:	00840900 	addeq	r0, r4, r0, lsl #18
    1b20:	00080000 	andeq	r0, r8, r0
    1b24:	0011eb14 	andseq	lr, r1, r4, lsl fp
    1b28:	06bb0100 	ldrteq	r0, [fp], r0, lsl #2
    1b2c:	000012ba 			; <UNDEFINED> instruction: 0x000012ba
    1b30:	00009248 	andeq	r9, r0, r8, asr #4
    1b34:	00000030 	andeq	r0, r0, r0, lsr r0
    1b38:	02869c01 	addeq	r9, r6, #256	; 0x100
    1b3c:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    1b40:	11bb0100 			; <UNDEFINED> instruction: 0x11bb0100
    1b44:	00000037 	andeq	r0, r0, r7, lsr r0
    1b48:	0c749102 	ldfeqp	f1, [r4], #-8
    1b4c:	00726662 	rsbseq	r6, r2, r2, ror #12
    1b50:	291abb01 	ldmdbcs	sl, {r0, r8, r9, fp, ip, sp, pc}
    1b54:	02000002 	andeq	r0, r0, #2
    1b58:	0b007091 	bleq	1dda4 <__bss_end+0x14438>
    1b5c:	000010f2 	strdeq	r1, [r0], -r2
    1b60:	a906b501 	stmdbge	r6, {r0, r8, sl, ip, sp, pc}
    1b64:	b2000011 	andlt	r0, r0, #17
    1b68:	08000002 	stmdaeq	r0, {r1}
    1b6c:	40000092 	mulmi	r0, r2, r0
    1b70:	01000000 	mrseq	r0, (UNDEF: 0)
    1b74:	0002b29c 	muleq	r2, ip, r2
    1b78:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    1b7c:	3712b501 	ldrcc	fp, [r2, -r1, lsl #10]
    1b80:	02000000 	andeq	r0, r0, #0
    1b84:	03007491 	movweq	r7, #1169	; 0x491
    1b88:	06020201 	streq	r0, [r2], -r1, lsl #4
    1b8c:	e30b0000 	movw	r0, #45056	; 0xb000
    1b90:	01000010 	tsteq	r0, r0, lsl r0
    1b94:	116606b0 	strhne	r0, [r6, #-96]!	; 0xffffffa0
    1b98:	02b20000 	adcseq	r0, r2, #0
    1b9c:	91cc0000 	bicls	r0, ip, r0
    1ba0:	003c0000 	eorseq	r0, ip, r0
    1ba4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ba8:	000002e5 	andeq	r0, r0, r5, ror #5
    1bac:	0100780c 	tsteq	r0, ip, lsl #16
    1bb0:	003712b0 	ldrhteq	r1, [r7], -r0
    1bb4:	91020000 	mrsls	r0, (UNDEF: 2)
    1bb8:	a2140074 	andsge	r0, r4, #116	; 0x74
    1bbc:	01000012 	tsteq	r0, r2, lsl r0
    1bc0:	11f006a5 	mvnsne	r0, r5, lsr #13
    1bc4:	90f80000 	rscsls	r0, r8, r0
    1bc8:	00d40000 	sbcseq	r0, r4, r0
    1bcc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bd0:	0000033a 	andeq	r0, r0, sl, lsr r3
    1bd4:	0100780c 	tsteq	r0, ip, lsl #16
    1bd8:	00842ba5 	addeq	r2, r4, r5, lsr #23
    1bdc:	91020000 	mrsls	r0, (UNDEF: 2)
    1be0:	66620c6c 	strbtvs	r0, [r2], -ip, ror #24
    1be4:	a5010072 	strge	r0, [r1, #-114]	; 0xffffff8e
    1be8:	00022934 	andeq	r2, r2, r4, lsr r9
    1bec:	68910200 	ldmvs	r1, {r9}
    1bf0:	00123c15 	andseq	r3, r2, r5, lsl ip
    1bf4:	3da50100 	stfccs	f0, [r5]
    1bf8:	00000123 	andeq	r0, r0, r3, lsr #2
    1bfc:	0e649102 	lgneqs	f1, f2
    1c00:	0000122e 	andeq	r1, r0, lr, lsr #4
    1c04:	2306a701 	movwcs	sl, #26369	; 0x6701
    1c08:	02000001 	andeq	r0, r0, #1
    1c0c:	17007491 			; <UNDEFINED> instruction: 0x17007491
    1c10:	00001261 	andeq	r1, r0, r1, ror #4
    1c14:	bc068301 	stclt	3, cr8, [r6], {1}
    1c18:	b8000011 	stmdalt	r0, {r0, r4}
    1c1c:	4000008c 	andmi	r0, r0, ip, lsl #1
    1c20:	01000004 	tsteq	r0, r4
    1c24:	00039e9c 	muleq	r3, ip, lr
    1c28:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    1c2c:	37188301 	ldrcc	r8, [r8, -r1, lsl #6]
    1c30:	02000000 	andeq	r0, r0, #0
    1c34:	e9156c91 	ldmdb	r5, {r0, r4, r7, sl, fp, sp, lr}
    1c38:	01000010 	tsteq	r0, r0, lsl r0
    1c3c:	039e2983 	orrseq	r2, lr, #2146304	; 0x20c000
    1c40:	91020000 	mrsls	r0, (UNDEF: 2)
    1c44:	10f81568 	rscsne	r1, r8, r8, ror #10
    1c48:	83010000 	movwhi	r0, #4096	; 0x1000
    1c4c:	00039e41 	andeq	r9, r3, r1, asr #28
    1c50:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c54:	00114115 	andseq	r4, r1, r5, lsl r1
    1c58:	4f830100 	svcmi	0x00830100
    1c5c:	000003a4 	andeq	r0, r0, r4, lsr #7
    1c60:	0e609102 	lgneqs	f1, f2
    1c64:	000010d9 	ldrdeq	r1, [r0], -r9
    1c68:	370b9601 	strcc	r9, [fp, -r1, lsl #12]
    1c6c:	02000000 	andeq	r0, r0, #0
    1c70:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1c74:	00008404 	andeq	r8, r0, r4, lsl #8
    1c78:	23041800 	movwcs	r1, #18432	; 0x4800
    1c7c:	14000001 	strne	r0, [r0], #-1
    1c80:	000012da 	ldrdeq	r1, [r0], -sl
    1c84:	5a067601 	bpl	19f490 <__bss_end+0x195b24>
    1c88:	f4000011 	vst4.8	{d0-d3}, [r0 :64], r1
    1c8c:	c400008b 	strgt	r0, [r0], #-139	; 0xffffff75
    1c90:	01000000 	mrseq	r0, (UNDEF: 0)
    1c94:	0003ff9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
    1c98:	11991500 	orrsne	r1, r9, r0, lsl #10
    1c9c:	76010000 	strvc	r0, [r1], -r0
    1ca0:	00022913 	andeq	r2, r2, r3, lsl r9
    1ca4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1ca8:	0100690d 	tsteq	r0, sp, lsl #18
    1cac:	01230978 			; <UNDEFINED> instruction: 0x01230978
    1cb0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb4:	656c0d74 	strbvs	r0, [ip, #-3444]!	; 0xfffff28c
    1cb8:	7801006e 	stmdavc	r1, {r1, r2, r3, r5, r6}
    1cbc:	0001230c 	andeq	r2, r1, ip, lsl #6
    1cc0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1cc4:	00117b0e 	andseq	r7, r1, lr, lsl #22
    1cc8:	11780100 	cmnne	r8, r0, lsl #2
    1ccc:	00000123 	andeq	r0, r0, r3, lsr #2
    1cd0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1cd4:	776f7019 			; <UNDEFINED> instruction: 0x776f7019
    1cd8:	076d0100 	strbeq	r0, [sp, -r0, lsl #2]!
    1cdc:	000011b3 			; <UNDEFINED> instruction: 0x000011b3
    1ce0:	00000037 	andeq	r0, r0, r7, lsr r0
    1ce4:	00008b88 	andeq	r8, r0, r8, lsl #23
    1ce8:	0000006c 	andeq	r0, r0, ip, rrx
    1cec:	045c9c01 	ldrbeq	r9, [ip], #-3073	; 0xfffff3ff
    1cf0:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    1cf4:	176d0100 	strbne	r0, [sp, -r0, lsl #2]!
    1cf8:	0000003e 	andeq	r0, r0, lr, lsr r0
    1cfc:	0c6c9102 	stfeqp	f1, [ip], #-8
    1d00:	6d01006e 	stcvs	0, cr0, [r1, #-440]	; 0xfffffe48
    1d04:	00008b2d 	andeq	r8, r0, sp, lsr #22
    1d08:	68910200 	ldmvs	r1, {r9}
    1d0c:	0100720d 	tsteq	r0, sp, lsl #4
    1d10:	00370b6f 	eorseq	r0, r7, pc, ror #22
    1d14:	91020000 	mrsls	r0, (UNDEF: 2)
    1d18:	8ba40f74 	blhi	fe905af0 <__bss_end+0xfe8fc184>
    1d1c:	00380000 	eorseq	r0, r8, r0
    1d20:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1d24:	16700100 	ldrbtne	r0, [r0], -r0, lsl #2
    1d28:	00000084 	andeq	r0, r0, r4, lsl #1
    1d2c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1d30:	12271700 	eorne	r1, r7, #0, 14
    1d34:	64010000 	strvs	r0, [r1], #-0
    1d38:	00108f06 	andseq	r8, r0, r6, lsl #30
    1d3c:	008b0800 	addeq	r0, fp, r0, lsl #16
    1d40:	00008000 	andeq	r8, r0, r0
    1d44:	d99c0100 	ldmible	ip, {r8}
    1d48:	0c000004 	stceq	0, cr0, [r0], {4}
    1d4c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1d50:	d9196401 	ldmdble	r9, {r0, sl, sp, lr}
    1d54:	02000004 	andeq	r0, r0, #4
    1d58:	640c6491 	strvs	r6, [ip], #-1169	; 0xfffffb6f
    1d5c:	01007473 	tsteq	r0, r3, ror r4
    1d60:	04e02464 	strbteq	r2, [r0], #1124	; 0x464
    1d64:	91020000 	mrsls	r0, (UNDEF: 2)
    1d68:	756e0c60 	strbvc	r0, [lr, #-3168]!	; 0xfffff3a0
    1d6c:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1d70:	0001232d 	andeq	r2, r1, sp, lsr #6
    1d74:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1d78:	0012100e 	andseq	r1, r2, lr
    1d7c:	0e660100 	poweqs	f0, f6, f0
    1d80:	0000011d 	andeq	r0, r0, sp, lsl r1
    1d84:	0e709102 	expeqs	f1, f2
    1d88:	000011d8 	ldrdeq	r1, [r0], -r8
    1d8c:	29086701 	stmdbcs	r8, {r0, r8, r9, sl, sp, lr}
    1d90:	02000002 	andeq	r0, r0, #2
    1d94:	300f6c91 	mulcc	pc, r1, ip	; <UNPREDICTABLE>
    1d98:	4800008b 	stmdami	r0, {r0, r1, r3, r7}
    1d9c:	0d000000 	stceq	0, cr0, [r0, #-0]
    1da0:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1da4:	0001230b 	andeq	r2, r1, fp, lsl #6
    1da8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1dac:	04120000 	ldreq	r0, [r2], #-0
    1db0:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1db4:	17041b1a 	smladne	r4, sl, fp, r1
    1db8:	00001221 	andeq	r1, r0, r1, lsr #4
    1dbc:	80065c01 	andhi	r5, r6, r1, lsl #24
    1dc0:	a0000011 	andge	r0, r0, r1, lsl r0
    1dc4:	6800008a 	stmdavs	r0, {r1, r3, r7}
    1dc8:	01000000 	mrseq	r0, (UNDEF: 0)
    1dcc:	0005419c 	muleq	r5, ip, r1
    1dd0:	12c51500 	sbcne	r1, r5, #0, 10
    1dd4:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1dd8:	0004e012 	andeq	lr, r4, r2, lsl r0
    1ddc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1de0:	0012cc15 	andseq	ip, r2, r5, lsl ip
    1de4:	1e5c0100 	rdfnee	f0, f4, f0
    1de8:	00000123 	andeq	r0, r0, r3, lsr #2
    1dec:	0d689102 	stfeqp	f1, [r8, #-8]!
    1df0:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1df4:	29085e01 	stmdbcs	r8, {r0, r9, sl, fp, ip, lr}
    1df8:	02000002 	andeq	r0, r0, #2
    1dfc:	bc0f7091 	stclt	0, cr7, [pc], {145}	; 0x91
    1e00:	3c00008a 	stccc	0, cr0, [r0], {138}	; 0x8a
    1e04:	0d000000 	stceq	0, cr0, [r0, #-0]
    1e08:	60010069 	andvs	r0, r1, r9, rrx
    1e0c:	0001230b 	andeq	r2, r1, fp, lsl #6
    1e10:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e14:	d30b0000 	movwle	r0, #45056	; 0xb000
    1e18:	01000012 	tsteq	r0, r2, lsl r0
    1e1c:	12720552 	rsbsne	r0, r2, #343932928	; 0x14800000
    1e20:	01230000 			; <UNDEFINED> instruction: 0x01230000
    1e24:	8a4c0000 	bhi	1301e2c <__bss_end+0x12f84c0>
    1e28:	00540000 	subseq	r0, r4, r0
    1e2c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e30:	0000057a 	andeq	r0, r0, sl, ror r5
    1e34:	0100730c 	tsteq	r0, ip, lsl #6
    1e38:	011d1852 	tsteq	sp, r2, asr r8
    1e3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e40:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    1e44:	23065401 	movwcs	r5, #25601	; 0x6401
    1e48:	02000001 	andeq	r0, r0, #1
    1e4c:	0b007491 	bleq	1f098 <__bss_end+0x1572c>
    1e50:	00001234 	andeq	r1, r0, r4, lsr r2
    1e54:	7f054201 	svcvc	0x00054201
    1e58:	23000012 	movwcs	r0, #18
    1e5c:	a0000001 	andge	r0, r0, r1
    1e60:	ac000089 	stcge	0, cr0, [r0], {137}	; 0x89
    1e64:	01000000 	mrseq	r0, (UNDEF: 0)
    1e68:	0005e09c 	muleq	r5, ip, r0
    1e6c:	31730c00 	cmncc	r3, r0, lsl #24
    1e70:	19420100 	stmdbne	r2, {r8}^
    1e74:	0000011d 	andeq	r0, r0, sp, lsl r1
    1e78:	0c6c9102 	stfeqp	f1, [ip], #-8
    1e7c:	01003273 	tsteq	r0, r3, ror r2
    1e80:	011d2942 	tsteq	sp, r2, asr #18
    1e84:	91020000 	mrsls	r0, (UNDEF: 2)
    1e88:	756e0c68 	strbvc	r0, [lr, #-3176]!	; 0xfffff398
    1e8c:	4201006d 	andmi	r0, r1, #109	; 0x6d
    1e90:	00012331 	andeq	r2, r1, r1, lsr r3
    1e94:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e98:	0031750d 	eorseq	r7, r1, sp, lsl #10
    1e9c:	e0104401 	ands	r4, r0, r1, lsl #8
    1ea0:	02000005 	andeq	r0, r0, #5
    1ea4:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    1ea8:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    1eac:	0005e014 	andeq	lr, r5, r4, lsl r0
    1eb0:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1eb4:	08010300 	stmdaeq	r1, {r8, r9}
    1eb8:	00000778 	andeq	r0, r0, r8, ror r7
    1ebc:	00118c0b 	andseq	r8, r1, fp, lsl #24
    1ec0:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    1ec4:	00001291 	muleq	r0, r1, r2
    1ec8:	00000229 	andeq	r0, r0, r9, lsr #4
    1ecc:	000088e0 	andeq	r8, r0, r0, ror #17
    1ed0:	000000c0 	andeq	r0, r0, r0, asr #1
    1ed4:	06409c01 	strbeq	r9, [r0], -r1, lsl #24
    1ed8:	55150000 	ldrpl	r0, [r5, #-0]
    1edc:	01000011 	tsteq	r0, r1, lsl r0
    1ee0:	02291536 	eoreq	r1, r9, #226492416	; 0xd800000
    1ee4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ee8:	72730c6c 	rsbsvc	r0, r3, #108, 24	; 0x6c00
    1eec:	36010063 	strcc	r0, [r1], -r3, rrx
    1ef0:	00011d27 	andeq	r1, r1, r7, lsr #26
    1ef4:	68910200 	ldmvs	r1, {r9}
    1ef8:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    1efc:	30360100 	eorscc	r0, r6, r0, lsl #2
    1f00:	00000123 	andeq	r0, r0, r3, lsr #2
    1f04:	0d649102 	stfeqp	f1, [r4, #-8]!
    1f08:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    1f0c:	00012306 	andeq	r2, r1, r6, lsl #6
    1f10:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f14:	110c0b00 	tstne	ip, r0, lsl #22
    1f18:	24010000 	strcs	r0, [r1], #-0
    1f1c:	00124305 	andseq	r4, r2, r5, lsl #6
    1f20:	00012300 	andeq	r2, r1, r0, lsl #6
    1f24:	00884400 	addeq	r4, r8, r0, lsl #8
    1f28:	00009c00 	andeq	r9, r0, r0, lsl #24
    1f2c:	7d9c0100 	ldfvcs	f0, [ip]
    1f30:	15000006 	strne	r0, [r0, #-6]
    1f34:	00001170 	andeq	r1, r0, r0, ror r1
    1f38:	1d162401 	cfldrsne	mvf2, [r6, #-4]
    1f3c:	02000001 	andeq	r0, r0, #1
    1f40:	4e0e6c91 	mcrmi	12, 0, r6, cr14, cr1, {4}
    1f44:	01000012 	tsteq	r0, r2, lsl r0
    1f48:	01230626 			; <UNDEFINED> instruction: 0x01230626
    1f4c:	91020000 	mrsls	r0, (UNDEF: 2)
    1f50:	941c0074 	ldrls	r0, [ip], #-116	; 0xffffff8c
    1f54:	01000011 	tsteq	r0, r1, lsl r0
    1f58:	11000608 	tstne	r0, r8, lsl #12
    1f5c:	86d00000 	ldrbhi	r0, [r0], r0
    1f60:	01740000 	cmneq	r4, r0
    1f64:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f68:	00117015 	andseq	r7, r1, r5, lsl r0
    1f6c:	18080100 	stmdane	r8, {r8}
    1f70:	00000084 	andeq	r0, r0, r4, lsl #1
    1f74:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    1f78:	0000124e 	andeq	r1, r0, lr, asr #4
    1f7c:	29250801 	stmdbcs	r5!, {r0, fp}
    1f80:	02000002 	andeq	r0, r0, #2
    1f84:	76156091 			; <UNDEFINED> instruction: 0x76156091
    1f88:	01000011 	tsteq	r0, r1, lsl r0
    1f8c:	00843a08 	addeq	r3, r4, r8, lsl #20
    1f90:	91020000 	mrsls	r0, (UNDEF: 2)
    1f94:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    1f98:	23060a01 	movwcs	r0, #27137	; 0x6a01
    1f9c:	02000001 	andeq	r0, r0, #1
    1fa0:	9c0f7491 	cfstrsls	mvf7, [pc], {145}	; 0x91
    1fa4:	98000087 	stmdals	r0, {r0, r1, r2, r7}
    1fa8:	0d000000 	stceq	0, cr0, [r0, #-0]
    1fac:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    1fb0:	0001230b 	andeq	r2, r1, fp, lsl #6
    1fb4:	70910200 	addsvc	r0, r1, r0, lsl #4
    1fb8:	0087c40f 	addeq	ip, r7, pc, lsl #8
    1fbc:	00006000 	andeq	r6, r0, r0
    1fc0:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    1fc4:	90081e01 	andls	r1, r8, r1, lsl #28
    1fc8:	02000000 	andeq	r0, r0, #0
    1fcc:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    1fd0:	00220000 	eoreq	r0, r2, r0
    1fd4:	00020000 	andeq	r0, r2, r0
    1fd8:	0000084c 	andeq	r0, r0, ip, asr #16
    1fdc:	0c870104 	stfeqs	f0, [r7], {4}
    1fe0:	96ac0000 	strtls	r0, [ip], r0
    1fe4:	98b80000 	ldmls	r8!, {}	; <UNPREDICTABLE>
    1fe8:	12e10000 	rscne	r0, r1, #0
    1fec:	13110000 	tstne	r1, #0
    1ff0:	00630000 	rsbeq	r0, r3, r0
    1ff4:	80010000 	andhi	r0, r1, r0
    1ff8:	00000022 	andeq	r0, r0, r2, lsr #32
    1ffc:	08600002 	stmdaeq	r0!, {r1}^
    2000:	01040000 	mrseq	r0, (UNDEF: 4)
    2004:	00000d04 	andeq	r0, r0, r4, lsl #26
    2008:	000098b8 			; <UNDEFINED> instruction: 0x000098b8
    200c:	000098bc 			; <UNDEFINED> instruction: 0x000098bc
    2010:	000012e1 	andeq	r1, r0, r1, ror #5
    2014:	00001311 	andeq	r1, r0, r1, lsl r3
    2018:	00000063 	andeq	r0, r0, r3, rrx
    201c:	09328001 	ldmdbeq	r2!, {r0, pc}
    2020:	00040000 	andeq	r0, r4, r0
    2024:	00000874 	andeq	r0, r0, r4, ror r8
    2028:	16df0104 	ldrbne	r0, [pc], r4, lsl #2
    202c:	360c0000 	strcc	r0, [ip], -r0
    2030:	11000016 	tstne	r0, r6, lsl r0
    2034:	64000013 	strvs	r0, [r0], #-19	; 0xffffffed
    2038:	0200000d 	andeq	r0, r0, #13
    203c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2040:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2044:	0007c807 	andeq	ip, r7, r7, lsl #16
    2048:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    204c:	0000031f 	andeq	r0, r0, pc, lsl r3
    2050:	c7040803 	strgt	r0, [r4, -r3, lsl #16]
    2054:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    2058:	00001691 	muleq	r0, r1, r6
    205c:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    2060:	04000000 	streq	r0, [r0], #-0
    2064:	00001ae9 	andeq	r1, r0, r9, ror #21
    2068:	51152f01 	tstpl	r5, r1, lsl #30
    206c:	05000000 	streq	r0, [r0, #-0]
    2070:	00005704 	andeq	r5, r0, r4, lsl #14
    2074:	00390600 	eorseq	r0, r9, r0, lsl #12
    2078:	00660000 	rsbeq	r0, r6, r0
    207c:	66070000 	strvs	r0, [r7], -r0
    2080:	00000000 	andeq	r0, r0, r0
    2084:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    2088:	04080000 	streq	r0, [r8], #-0
    208c:	0000221b 	andeq	r2, r0, fp, lsl r2
    2090:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    2094:	05000000 	streq	r0, [r0, #-0]
    2098:	00007f04 	andeq	r7, r0, r4, lsl #30
    209c:	001d0600 	andseq	r0, sp, r0, lsl #12
    20a0:	00930000 	addseq	r0, r3, r0
    20a4:	66070000 	strvs	r0, [r7], -r0
    20a8:	07000000 	streq	r0, [r0, -r0]
    20ac:	00000066 	andeq	r0, r0, r6, rrx
    20b0:	08010300 	stmdaeq	r1, {r8, r9}
    20b4:	00000778 	andeq	r0, r0, r8, ror r7
    20b8:	001d2109 	andseq	r2, sp, r9, lsl #2
    20bc:	12bb0100 	adcsne	r0, fp, #0, 2
    20c0:	00000045 	andeq	r0, r0, r5, asr #32
    20c4:	00224909 	eoreq	r4, r2, r9, lsl #18
    20c8:	10be0100 	adcsne	r0, lr, r0, lsl #2
    20cc:	0000006d 	andeq	r0, r0, sp, rrx
    20d0:	7a060103 	bvc	1824e4 <__bss_end+0x178b78>
    20d4:	0a000007 	beq	20f8 <shift+0x20f8>
    20d8:	00001a09 	andeq	r1, r0, r9, lsl #20
    20dc:	00930107 	addseq	r0, r3, r7, lsl #2
    20e0:	17020000 	strne	r0, [r2, -r0]
    20e4:	0001e606 	andeq	lr, r1, r6, lsl #12
    20e8:	14ef0b00 	strbtne	r0, [pc], #2816	; 20f0 <shift+0x20f0>
    20ec:	0b000000 	bleq	20f4 <shift+0x20f4>
    20f0:	00001926 	andeq	r1, r0, r6, lsr #18
    20f4:	1dec0b01 			; <UNDEFINED> instruction: 0x1dec0b01
    20f8:	0b020000 	bleq	82100 <__bss_end+0x78794>
    20fc:	0000215d 	andeq	r2, r0, sp, asr r1
    2100:	1d900b03 	vldrne	d0, [r0, #12]
    2104:	0b040000 	bleq	10210c <__bss_end+0xf87a0>
    2108:	00002066 	andeq	r2, r0, r6, rrx
    210c:	1fca0b05 	svcne	0x00ca0b05
    2110:	0b060000 	bleq	182118 <__bss_end+0x1787ac>
    2114:	00001510 	andeq	r1, r0, r0, lsl r5
    2118:	207b0b07 	rsbscs	r0, fp, r7, lsl #22
    211c:	0b080000 	bleq	202124 <__bss_end+0x1f87b8>
    2120:	00002089 	andeq	r2, r0, r9, lsl #1
    2124:	21500b09 	cmpcs	r0, r9, lsl #22
    2128:	0b0a0000 	bleq	282130 <__bss_end+0x2787c4>
    212c:	00001ce7 	andeq	r1, r0, r7, ror #25
    2130:	16d20b0b 	ldrbne	r0, [r2], fp, lsl #22
    2134:	0b0c0000 	bleq	30213c <__bss_end+0x2f87d0>
    2138:	000017af 	andeq	r1, r0, pc, lsr #15
    213c:	1a4d0b0d 	bne	1344d78 <__bss_end+0x133b40c>
    2140:	0b0e0000 	bleq	382148 <__bss_end+0x3787dc>
    2144:	00001a63 	andeq	r1, r0, r3, ror #20
    2148:	19600b0f 	stmdbne	r0!, {r0, r1, r2, r3, r8, r9, fp}^
    214c:	0b100000 	bleq	402154 <__bss_end+0x3f87e8>
    2150:	00001d74 	andeq	r1, r0, r4, ror sp
    2154:	19cc0b11 	stmibne	ip, {r0, r4, r8, r9, fp}^
    2158:	0b120000 	bleq	482160 <__bss_end+0x4787f4>
    215c:	000023e2 	andeq	r2, r0, r2, ror #7
    2160:	15790b13 	ldrbne	r0, [r9, #-2835]!	; 0xfffff4ed
    2164:	0b140000 	bleq	50216c <__bss_end+0x4f8800>
    2168:	000019f0 	strdeq	r1, [r0], -r0
    216c:	14b60b15 	ldrtne	r0, [r6], #2837	; 0xb15
    2170:	0b160000 	bleq	582178 <__bss_end+0x57880c>
    2174:	00002180 	andeq	r2, r0, r0, lsl #3
    2178:	22a20b17 	adccs	r0, r2, #23552	; 0x5c00
    217c:	0b180000 	bleq	602184 <__bss_end+0x5f8818>
    2180:	00001a15 	andeq	r1, r0, r5, lsl sl
    2184:	1e5e0b19 	vmovne.s8	r0, d14[0]
    2188:	0b1a0000 	bleq	682190 <__bss_end+0x678824>
    218c:	0000218e 	andeq	r2, r0, lr, lsl #3
    2190:	13e50b1b 	mvnne	r0, #27648	; 0x6c00
    2194:	0b1c0000 	bleq	70219c <__bss_end+0x6f8830>
    2198:	0000219c 	muleq	r0, ip, r1
    219c:	21aa0b1d 			; <UNDEFINED> instruction: 0x21aa0b1d
    21a0:	0b1e0000 	bleq	7821a8 <__bss_end+0x77883c>
    21a4:	00001393 	muleq	r0, r3, r3
    21a8:	21d40b1f 	bicscs	r0, r4, pc, lsl fp
    21ac:	0b200000 	bleq	8021b4 <__bss_end+0x7f8848>
    21b0:	00001f0b 	andeq	r1, r0, fp, lsl #30
    21b4:	1d460b21 	vstrne	d16, [r6, #-132]	; 0xffffff7c
    21b8:	0b220000 	bleq	8821c0 <__bss_end+0x878854>
    21bc:	00002173 	andeq	r2, r0, r3, ror r1
    21c0:	1c4a0b23 	mcrrne	11, 2, r0, sl, cr3
    21c4:	0b240000 	bleq	9021cc <__bss_end+0x8f8860>
    21c8:	00001b4c 	andeq	r1, r0, ip, asr #22
    21cc:	18660b25 	stmdane	r6!, {r0, r2, r5, r8, r9, fp}^
    21d0:	0b260000 	bleq	9821d8 <__bss_end+0x97886c>
    21d4:	00001b6a 	andeq	r1, r0, sl, ror #22
    21d8:	19020b27 	stmdbne	r2, {r0, r1, r2, r5, r8, r9, fp}
    21dc:	0b280000 	bleq	a021e4 <__bss_end+0x9f8878>
    21e0:	00001b7a 	andeq	r1, r0, sl, ror fp
    21e4:	1b8a0b29 	blne	fe284e90 <__bss_end+0xfe27b524>
    21e8:	0b2a0000 	bleq	a821f0 <__bss_end+0xa78884>
    21ec:	00001ccd 	andeq	r1, r0, sp, asr #25
    21f0:	1af30b2b 	bne	ffcc4ea4 <__bss_end+0xffcbb538>
    21f4:	0b2c0000 	bleq	b021fc <__bss_end+0xaf8890>
    21f8:	00001f18 	andeq	r1, r0, r8, lsl pc
    21fc:	18a70b2d 	stmiane	r7!, {r0, r2, r3, r5, r8, r9, fp}
    2200:	002e0000 	eoreq	r0, lr, r0
    2204:	001a850a 	andseq	r8, sl, sl, lsl #10
    2208:	93010700 	movwls	r0, #5888	; 0x1700
    220c:	03000000 	movweq	r0, #0
    2210:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    2214:	d10b0000 	mrsle	r0, (UNDEF: 11)
    2218:	00000017 	andeq	r0, r0, r7, lsl r0
    221c:	0014230b 	andseq	r2, r4, fp, lsl #6
    2220:	900b0100 	andls	r0, fp, r0, lsl #2
    2224:	02000023 	andeq	r0, r0, #35	; 0x23
    2228:	0022230b 	eoreq	r2, r2, fp, lsl #6
    222c:	f10b0300 			; <UNDEFINED> instruction: 0xf10b0300
    2230:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2234:	0014db0b 	andseq	sp, r4, fp, lsl #22
    2238:	830b0500 	movwhi	r0, #46336	; 0xb500
    223c:	06000018 			; <UNDEFINED> instruction: 0x06000018
    2240:	0017e10b 	andseq	lr, r7, fp, lsl #2
    2244:	b70b0700 	strlt	r0, [fp, -r0, lsl #14]
    2248:	08000020 	stmdaeq	r0, {r5}
    224c:	0022080b 	eoreq	r0, r2, fp, lsl #16
    2250:	ee0b0900 	vmla.f16	s0, s22, s0
    2254:	0a00001f 	beq	22d8 <shift+0x22d8>
    2258:	00152e0b 	andseq	r2, r5, fp, lsl #28
    225c:	240b0b00 	strcs	r0, [fp], #-2816	; 0xfffff500
    2260:	0c000018 	stceq	0, cr0, [r0], {24}
    2264:	0014a40b 	andseq	sl, r4, fp, lsl #8
    2268:	c50b0d00 	strgt	r0, [fp, #-3328]	; 0xfffff300
    226c:	0e000023 	cdpeq	0, 0, cr0, cr0, cr3, {1}
    2270:	001cba0b 	andseq	fp, ip, fp, lsl #20
    2274:	970b0f00 	strls	r0, [fp, -r0, lsl #30]
    2278:	10000019 	andne	r0, r0, r9, lsl r0
    227c:	001cf70b 	andseq	pc, ip, fp, lsl #14
    2280:	e40b1100 	str	r1, [fp], #-256	; 0xffffff00
    2284:	12000022 	andne	r0, r0, #34	; 0x22
    2288:	0015f10b 	andseq	pc, r5, fp, lsl #2
    228c:	aa0b1300 	bge	2c6e94 <__bss_end+0x2bd528>
    2290:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
    2294:	001c0d0b 	andseq	r0, ip, fp, lsl #26
    2298:	bc0b1500 	cfstr32lt	mvfx1, [fp], {-0}
    229c:	16000017 			; <UNDEFINED> instruction: 0x16000017
    22a0:	001c590b 	andseq	r5, ip, fp, lsl #18
    22a4:	6f0b1700 	svcvs	0x000b1700
    22a8:	1800001a 	stmdane	r0, {r1, r3, r4}
    22ac:	0014f90b 	andseq	pc, r4, fp, lsl #18
    22b0:	8b0b1900 	blhi	2c86b8 <__bss_end+0x2bed4c>
    22b4:	1a000022 	bne	2344 <shift+0x2344>
    22b8:	001bd90b 	andseq	sp, fp, fp, lsl #18
    22bc:	810b1b00 	tsthi	fp, r0, lsl #22
    22c0:	1c000019 	stcne	0, cr0, [r0], {25}
    22c4:	0013ce0b 	andseq	ip, r3, fp, lsl #28
    22c8:	240b1d00 	strcs	r1, [fp], #-3328	; 0xfffff300
    22cc:	1e00001b 	mcrne	0, 0, r0, cr0, cr11, {0}
    22d0:	001b100b 	andseq	r1, fp, fp
    22d4:	ab0b1f00 	blge	2c9edc <__bss_end+0x2c0570>
    22d8:	2000001f 	andcs	r0, r0, pc, lsl r0
    22dc:	0020360b 	eoreq	r3, r0, fp, lsl #12
    22e0:	6a0b2100 	bvs	2ca6e8 <__bss_end+0x2c0d7c>
    22e4:	22000022 	andcs	r0, r0, #34	; 0x22
    22e8:	0018b40b 	andseq	fp, r8, fp, lsl #8
    22ec:	0e0b2300 	cdpeq	3, 0, cr2, cr11, cr0, {0}
    22f0:	2400001e 	strcs	r0, [r0], #-30	; 0xffffffe2
    22f4:	0020030b 	eoreq	r0, r0, fp, lsl #6
    22f8:	270b2500 	strcs	r2, [fp, -r0, lsl #10]
    22fc:	2600001f 			; <UNDEFINED> instruction: 0x2600001f
    2300:	001f3b0b 	andseq	r3, pc, fp, lsl #22
    2304:	4f0b2700 	svcmi	0x000b2700
    2308:	2800001f 	stmdacs	r0, {r0, r1, r2, r3, r4}
    230c:	00167c0b 	andseq	r7, r6, fp, lsl #24
    2310:	dc0b2900 			; <UNDEFINED> instruction: 0xdc0b2900
    2314:	2a000015 	bcs	2370 <shift+0x2370>
    2318:	0016040b 	andseq	r0, r6, fp, lsl #8
    231c:	000b2b00 	andeq	r2, fp, r0, lsl #22
    2320:	2c000021 	stccs	0, cr0, [r0], {33}	; 0x21
    2324:	0016590b 	andseq	r5, r6, fp, lsl #18
    2328:	140b2d00 	strne	r2, [fp], #-3328	; 0xfffff300
    232c:	2e000021 	cdpcs	0, 0, cr0, cr0, cr1, {1}
    2330:	0021280b 	eoreq	r2, r1, fp, lsl #16
    2334:	3c0b2f00 	stccc	15, cr2, [fp], {-0}
    2338:	30000021 	andcc	r0, r0, r1, lsr #32
    233c:	0018360b 	andseq	r3, r8, fp, lsl #12
    2340:	100b3100 	andne	r3, fp, r0, lsl #2
    2344:	32000018 	andcc	r0, r0, #24
    2348:	001b380b 	andseq	r3, fp, fp, lsl #16
    234c:	0a0b3300 	beq	2cef54 <__bss_end+0x2c55e8>
    2350:	3400001d 	strcc	r0, [r0], #-29	; 0xffffffe3
    2354:	0023190b 	eoreq	r1, r3, fp, lsl #18
    2358:	760b3500 	strvc	r3, [fp], -r0, lsl #10
    235c:	36000013 			; <UNDEFINED> instruction: 0x36000013
    2360:	0019360b 	andseq	r3, r9, fp, lsl #12
    2364:	4b0b3700 	blmi	2cff6c <__bss_end+0x2c6600>
    2368:	38000019 	stmdacc	r0, {r0, r3, r4}
    236c:	001b9a0b 	andseq	r9, fp, fp, lsl #20
    2370:	c40b3900 	strgt	r3, [fp], #-2304	; 0xfffff700
    2374:	3a00001b 	bcc	23e8 <shift+0x23e8>
    2378:	0023420b 	eoreq	r4, r3, fp, lsl #4
    237c:	f90b3b00 			; <UNDEFINED> instruction: 0xf90b3b00
    2380:	3c00001d 	stccc	0, cr0, [r0], {29}
    2384:	0018d90b 	andseq	sp, r8, fp, lsl #18
    2388:	350b3d00 	strcc	r3, [fp, #-3328]	; 0xfffff300
    238c:	3e000014 	mcrcc	0, 0, r0, cr0, cr4, {0}
    2390:	0013f30b 	andseq	pc, r3, fp, lsl #6
    2394:	560b3f00 	strpl	r3, [fp], -r0, lsl #30
    2398:	4000001d 	andmi	r0, r0, sp, lsl r0
    239c:	001e7a0b 	andseq	r7, lr, fp, lsl #20
    23a0:	8d0b4100 	stfhis	f4, [fp, #-0]
    23a4:	4200001f 	andmi	r0, r0, #31
    23a8:	001baf0b 	andseq	sl, fp, fp, lsl #30
    23ac:	7b0b4300 	blvc	2d2fb4 <__bss_end+0x2c9648>
    23b0:	44000023 	strmi	r0, [r0], #-35	; 0xffffffdd
    23b4:	001e240b 	andseq	r2, lr, fp, lsl #8
    23b8:	200b4500 	andcs	r4, fp, r0, lsl #10
    23bc:	46000016 			; <UNDEFINED> instruction: 0x46000016
    23c0:	001c8a0b 	andseq	r8, ip, fp, lsl #20
    23c4:	bd0b4700 	stclt	7, cr4, [fp, #-0]
    23c8:	4800001a 	stmdami	r0, {r1, r3, r4}
    23cc:	0013b20b 	andseq	fp, r3, fp, lsl #4
    23d0:	c60b4900 	strgt	r4, [fp], -r0, lsl #18
    23d4:	4a000014 	bmi	242c <shift+0x242c>
    23d8:	0018ed0b 	andseq	lr, r8, fp, lsl #26
    23dc:	eb0b4b00 	bl	2d4fe4 <__bss_end+0x2cb678>
    23e0:	4c00001b 	stcmi	0, cr0, [r0], {27}
    23e4:	07020300 	streq	r0, [r2, -r0, lsl #6]
    23e8:	0000089c 	muleq	r0, ip, r8
    23ec:	0003e40c 	andeq	lr, r3, ip, lsl #8
    23f0:	0003d900 	andeq	sp, r3, r0, lsl #18
    23f4:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    23f8:	000003ce 	andeq	r0, r0, lr, asr #7
    23fc:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    2400:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    2404:	03000003 	movweq	r0, #3
    2408:	07810801 	streq	r0, [r1, r1, lsl #16]
    240c:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    2410:	0f000003 	svceq	0x00000003
    2414:	0000156a 	andeq	r1, r0, sl, ror #10
    2418:	1a014c04 	bne	55430 <__bss_end+0x4bac4>
    241c:	000003d9 	ldrdeq	r0, [r0], -r9
    2420:	0019710f 	andseq	r7, r9, pc, lsl #2
    2424:	01820400 	orreq	r0, r2, r0, lsl #8
    2428:	0003d91a 	andeq	sp, r3, sl, lsl r9
    242c:	03e90c00 	mvneq	r0, #0, 24
    2430:	041a0000 	ldreq	r0, [sl], #-0
    2434:	000d0000 	andeq	r0, sp, r0
    2438:	001b5c09 	andseq	r5, fp, r9, lsl #24
    243c:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    2440:	0000040f 	andeq	r0, r0, pc, lsl #8
    2444:	0021e409 	eoreq	lr, r1, r9, lsl #8
    2448:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    244c:	000001e6 	andeq	r0, r0, r6, ror #3
    2450:	00184a0a 	andseq	r4, r8, sl, lsl #20
    2454:	93010700 	movwls	r0, #5888	; 0x1700
    2458:	05000000 	streq	r0, [r0, #-0]
    245c:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    2460:	c70b0000 	strgt	r0, [fp, -r0]
    2464:	00000013 	andeq	r0, r0, r3, lsl r0
    2468:	001a5c0b 	andseq	r5, sl, fp, lsl #24
    246c:	f60b0100 			; <UNDEFINED> instruction: 0xf60b0100
    2470:	02000022 	andeq	r0, r0, #34	; 0x22
    2474:	0022b90b 	eoreq	fp, r2, fp, lsl #18
    2478:	b30b0300 	movwlt	r0, #45824	; 0xb300
    247c:	0400001d 	streq	r0, [r0], #-29	; 0xffffffe3
    2480:	0020740b 	eoreq	r7, r0, fp, lsl #8
    2484:	ad0b0500 	cfstr32ge	mvfx0, [fp, #-0]
    2488:	06000015 			; <UNDEFINED> instruction: 0x06000015
    248c:	00158f0b 	andseq	r8, r5, fp, lsl #30
    2490:	a80b0700 	stmdage	fp, {r8, r9, sl}
    2494:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    2498:	001c6f0b 	andseq	r6, ip, fp, lsl #30
    249c:	b40b0900 	strlt	r0, [fp], #-2304	; 0xfffff700
    24a0:	0a000015 	beq	24fc <shift+0x24fc>
    24a4:	001c760b 	andseq	r7, ip, fp, lsl #12
    24a8:	190b0b00 	stmdbne	fp, {r8, r9, fp}
    24ac:	0c000016 	stceq	0, cr0, [r0], {22}
    24b0:	0015a60b 	andseq	sl, r5, fp, lsl #12
    24b4:	cb0b0d00 	blgt	2c58bc <__bss_end+0x2bbf50>
    24b8:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    24bc:	001e980b 	andseq	r9, lr, fp, lsl #16
    24c0:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    24c4:	00001fc3 	andeq	r1, r0, r3, asr #31
    24c8:	32013f05 	andcc	r3, r1, #5, 30
    24cc:	09000004 	stmdbeq	r0, {r2}
    24d0:	00002057 	andeq	r2, r0, r7, asr r0
    24d4:	a50f4105 	strge	r4, [pc, #-261]	; 23d7 <shift+0x23d7>
    24d8:	09000004 	stmdbeq	r0, {r2}
    24dc:	000020df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    24e0:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    24e4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    24e8:	0000154e 	andeq	r1, r0, lr, asr #10
    24ec:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    24f0:	10000000 	andne	r0, r0, r0
    24f4:	000021b8 			; <UNDEFINED> instruction: 0x000021b8
    24f8:	0020f009 	eoreq	pc, r0, r9
    24fc:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    2500:	000004e6 	andeq	r0, r0, r6, ror #9
    2504:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    2508:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    250c:	00001a26 	andeq	r1, r0, r6, lsr #20
    2510:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    2514:	05000004 	streq	r0, [r0, #-4]
    2518:	0004ec04 	andeq	lr, r4, r4, lsl #24
    251c:	1fd91200 	svcne	0x00d91200
    2520:	a0090000 	andge	r0, r9, r0
    2524:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2528:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    252c:	04050000 	streq	r0, [r5], #-0
    2530:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2534:	0016c513 	andseq	ip, r6, r3, lsl r5
    2538:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    253c:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    2540:	65140000 	ldrvs	r0, [r4, #-0]
    2544:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2548:	de0f0169 	adfleez	f0, f7, #1.0
    254c:	00000003 	andeq	r0, r0, r3
    2550:	0016a914 	andseq	sl, r6, r4, lsl r9
    2554:	016a0500 	cmneq	sl, r0, lsl #10
    2558:	00054614 	andeq	r4, r5, r4, lsl r6
    255c:	0e000400 	cfcpyseq	mvf0, mvf0
    2560:	00000516 	andeq	r0, r0, r6, lsl r5
    2564:	0000b90c 	andeq	fp, r0, ip, lsl #18
    2568:	00055600 	andeq	r5, r5, r0, lsl #12
    256c:	00241500 	eoreq	r1, r4, r0, lsl #10
    2570:	002d0000 	eoreq	r0, sp, r0
    2574:	0005410c 	andeq	r4, r5, ip, lsl #2
    2578:	00056100 	andeq	r6, r5, r0, lsl #2
    257c:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2580:	00000556 	andeq	r0, r0, r6, asr r5
    2584:	001a940f 	andseq	r9, sl, pc, lsl #8
    2588:	016b0500 	cmneq	fp, r0, lsl #10
    258c:	00056103 	andeq	r6, r5, r3, lsl #2
    2590:	1cda0f00 	ldclne	15, cr0, [sl], {0}
    2594:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    2598:	001d0c01 	andseq	r0, sp, r1, lsl #24
    259c:	17160000 	ldrne	r0, [r6, -r0]
    25a0:	07000020 	streq	r0, [r0, -r0, lsr #32]
    25a4:	00009301 	andeq	r9, r0, r1, lsl #6
    25a8:	01810500 	orreq	r0, r1, r0, lsl #10
    25ac:	00062a06 	andeq	r2, r6, r6, lsl #20
    25b0:	145c0b00 	ldrbne	r0, [ip], #-2816	; 0xfffff500
    25b4:	0b000000 	bleq	25bc <shift+0x25bc>
    25b8:	00001468 	andeq	r1, r0, r8, ror #8
    25bc:	14740b02 	ldrbtne	r0, [r4], #-2818	; 0xfffff4fe
    25c0:	0b030000 	bleq	c25c8 <__bss_end+0xb8c5c>
    25c4:	00001876 	andeq	r1, r0, r6, ror r8
    25c8:	14800b03 	strne	r0, [r0], #2819	; 0xb03
    25cc:	0b040000 	bleq	1025d4 <__bss_end+0xf8c68>
    25d0:	000019bf 			; <UNDEFINED> instruction: 0x000019bf
    25d4:	1aa50b04 	bne	fe9451ec <__bss_end+0xfe93b880>
    25d8:	0b050000 	bleq	1425e0 <__bss_end+0x138c74>
    25dc:	000019fb 	strdeq	r1, [r0], -fp
    25e0:	153f0b05 	ldrne	r0, [pc, #-2821]!	; 1ae3 <shift+0x1ae3>
    25e4:	0b050000 	bleq	1425ec <__bss_end+0x138c80>
    25e8:	0000148c 	andeq	r1, r0, ip, lsl #9
    25ec:	1c230b06 			; <UNDEFINED> instruction: 0x1c230b06
    25f0:	0b060000 	bleq	1825f8 <__bss_end+0x178c8c>
    25f4:	0000169b 	muleq	r0, fp, r6
    25f8:	1c300b06 			; <UNDEFINED> instruction: 0x1c300b06
    25fc:	0b060000 	bleq	182604 <__bss_end+0x178c98>
    2600:	00002097 	muleq	r0, r7, r0
    2604:	1c3d0b06 			; <UNDEFINED> instruction: 0x1c3d0b06
    2608:	0b060000 	bleq	182610 <__bss_end+0x178ca4>
    260c:	00001c7d 	andeq	r1, r0, sp, ror ip
    2610:	14980b06 	ldrne	r0, [r8], #2822	; 0xb06
    2614:	0b070000 	bleq	1c261c <__bss_end+0x1b8cb0>
    2618:	00001d83 	andeq	r1, r0, r3, lsl #27
    261c:	1dd00b07 	vldrne	d16, [r0, #28]
    2620:	0b070000 	bleq	1c2628 <__bss_end+0x1b8cbc>
    2624:	000020d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    2628:	166e0b07 	strbtne	r0, [lr], -r7, lsl #22
    262c:	0b070000 	bleq	1c2634 <__bss_end+0x1b8cc8>
    2630:	00001e51 	andeq	r1, r0, r1, asr lr
    2634:	14110b08 	ldrne	r0, [r1], #-2824	; 0xfffff4f8
    2638:	0b080000 	bleq	202640 <__bss_end+0x1f8cd4>
    263c:	000020a5 	andeq	r2, r0, r5, lsr #1
    2640:	1e6d0b08 	vmulne.f64	d16, d13, d8
    2644:	00080000 	andeq	r0, r8, r0
    2648:	00230b0f 	eoreq	r0, r3, pc, lsl #22
    264c:	019f0500 	orrseq	r0, pc, r0, lsl #10
    2650:	0005801f 	andeq	r8, r5, pc, lsl r0
    2654:	1e9f0f00 	cdpne	15, 9, cr0, cr15, cr0, {0}
    2658:	a2050000 	andge	r0, r5, #0
    265c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2660:	b20f0000 	andlt	r0, pc, #0
    2664:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2668:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    266c:	0f000000 	svceq	0x00000000
    2670:	000023d7 	ldrdeq	r2, [r0], -r7
    2674:	0c01a805 	stceq	8, cr10, [r1], {5}
    2678:	0000001d 	andeq	r0, r0, sp, lsl r0
    267c:	00155e0f 	andseq	r5, r5, pc, lsl #28
    2680:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    2684:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2688:	1ea90f00 	cdpne	15, 10, cr0, cr9, cr0, {0}
    268c:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2690:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2694:	ba0f0000 	blt	3c269c <__bss_end+0x3b8d30>
    2698:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    269c:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    26a0:	0f000000 	svceq	0x00000000
    26a4:	00001dc5 	andeq	r1, r0, r5, asr #27
    26a8:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    26ac:	0000001d 	andeq	r0, r0, sp, lsl r0
    26b0:	001eb30f 	andseq	fp, lr, pc, lsl #6
    26b4:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    26b8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26bc:	1bff0f00 	blne	fffc62c4 <__bss_end+0xfffbc958>
    26c0:	ba050000 	blt	1426c8 <__bss_end+0x138d5c>
    26c4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26c8:	360f0000 	strcc	r0, [pc], -r0
    26cc:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    26d0:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    26d4:	0f000000 	svceq	0x00000000
    26d8:	00001ebd 			; <UNDEFINED> instruction: 0x00001ebd
    26dc:	0c01c005 	stceq	0, cr12, [r1], {5}
    26e0:	0000001d 	andeq	r0, r0, sp, lsl r0
    26e4:	0023fa0f 	eoreq	pc, r3, pc, lsl #20
    26e8:	01c30500 	biceq	r0, r3, r0, lsl #10
    26ec:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26f0:	22c00f00 	sbccs	r0, r0, #0, 30
    26f4:	c6050000 	strgt	r0, [r5], -r0
    26f8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26fc:	cc0f0000 	stcgt	0, cr0, [pc], {-0}
    2700:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2704:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    2708:	0f000000 	svceq	0x00000000
    270c:	000022d8 	ldrdeq	r2, [r0], -r8
    2710:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2714:	0000001d 	andeq	r0, r0, sp, lsl r0
    2718:	0022fd0f 	eoreq	pc, r2, pc, lsl #26
    271c:	01d00500 	bicseq	r0, r0, r0, lsl #10
    2720:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2724:	23ed0f00 	mvncs	r0, #0, 30
    2728:	d3050000 	movwle	r0, #20480	; 0x5000
    272c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2730:	bb0f0000 	bllt	3c2738 <__bss_end+0x3b8dcc>
    2734:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2738:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    273c:	0f000000 	svceq	0x00000000
    2740:	000013a2 	andeq	r1, r0, r2, lsr #7
    2744:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2748:	0000001d 	andeq	r0, r0, sp, lsl r0
    274c:	0018960f 	andseq	r9, r8, pc, lsl #12
    2750:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2754:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2758:	15960f00 	ldrne	r0, [r6, #3840]	; 0xf00
    275c:	df050000 	svcle	0x00050000
    2760:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2764:	d30f0000 	movwle	r0, #61440	; 0xf000
    2768:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    276c:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    2770:	0f000000 	svceq	0x00000000
    2774:	00001adb 	ldrdeq	r1, [r0], -fp
    2778:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    277c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2780:	001d330f 	andseq	r3, sp, pc, lsl #6
    2784:	01e80500 	mvneq	r0, r0, lsl #10
    2788:	00001d0c 	andeq	r1, r0, ip, lsl #26
    278c:	21ed0f00 	mvncs	r0, r0, lsl #30
    2790:	ef050000 	svc	0x00050000
    2794:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2798:	a50f0000 	strge	r0, [pc, #-0]	; 27a0 <shift+0x27a0>
    279c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    27a0:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    27a4:	0f000000 	svceq	0x00000000
    27a8:	000023b5 			; <UNDEFINED> instruction: 0x000023b5
    27ac:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    27b0:	0000001d 	andeq	r0, r0, sp, lsl r0
    27b4:	0016b20f 	andseq	fp, r6, pc, lsl #4
    27b8:	01f80500 	mvnseq	r0, r0, lsl #10
    27bc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27c0:	22340f00 	eorscs	r0, r4, #0, 30
    27c4:	fb050000 	blx	1427ce <__bss_end+0x138e62>
    27c8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27cc:	390f0000 	stmdbcc	pc, {}	; <UNPREDICTABLE>
    27d0:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    27d4:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    27d8:	0f000000 	svceq	0x00000000
    27dc:	0000190f 	andeq	r1, r0, pc, lsl #18
    27e0:	0c020205 	sfmeq	f0, 4, [r2], {5}
    27e4:	0000001d 	andeq	r0, r0, sp, lsl r0
    27e8:	0020290f 	eoreq	r2, r0, pc, lsl #18
    27ec:	020a0500 	andeq	r0, sl, #0, 10
    27f0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27f4:	18020f00 	stmdane	r2, {r8, r9, sl, fp}
    27f8:	0d050000 	stceq	0, cr0, [r5, #-0]
    27fc:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2800:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2804:	ef000000 	svc	0x00000000
    2808:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    280c:	19db0f00 	ldmibne	fp, {r8, r9, sl, fp}^
    2810:	fb050000 	blx	14281a <__bss_end+0x138eae>
    2814:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    2818:	e60c0000 	str	r0, [ip], -r0
    281c:	0c000004 	stceq	0, cr0, [r0], {4}
    2820:	15000008 	strne	r0, [r0, #-8]
    2824:	00000024 	andeq	r0, r0, r4, lsr #32
    2828:	f60f000d 			; <UNDEFINED> instruction: 0xf60f000d
    282c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2830:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    2834:	16000007 	strne	r0, [r0], -r7
    2838:	00001a9d 	muleq	r0, sp, sl
    283c:	00930107 	addseq	r0, r3, r7, lsl #2
    2840:	8b050000 	blhi	142848 <__bss_end+0x138edc>
    2844:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2848:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    284c:	00000018 	andeq	r0, r0, r8, lsl r0
    2850:	001ca80b 	andseq	sl, ip, fp, lsl #16
    2854:	470b0100 	strmi	r0, [fp, -r0, lsl #2]
    2858:	02000014 	andeq	r0, r0, #20
    285c:	0023670b 	eoreq	r6, r3, fp, lsl #14
    2860:	700b0300 	andvc	r0, fp, r0, lsl #6
    2864:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    2868:	001f630b 	andseq	r6, pc, fp, lsl #6
    286c:	1e0b0500 	cfsh32ne	mvfx0, mvfx11, #0
    2870:	06000015 			; <UNDEFINED> instruction: 0x06000015
    2874:	23570f00 	cmpcs	r7, #0, 30
    2878:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    287c:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    2880:	590f0000 	stmdbpl	pc, {}	; <UNPREDICTABLE>
    2884:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2888:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    288c:	0f000000 	svceq	0x00000000
    2890:	00001ee3 	andeq	r1, r0, r3, ror #29
    2894:	0c07ae05 	stceq	14, cr10, [r7], {5}
    2898:	0000001d 	andeq	r0, r0, sp, lsl r0
    289c:	0021cc04 	eoreq	ip, r1, r4, lsl #24
    28a0:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    28a4:	00000093 	muleq	r0, r3, r0
    28a8:	00087e0e 	andeq	r7, r8, lr, lsl #28
    28ac:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    28b0:	0000049e 	muleq	r0, lr, r4
    28b4:	be070803 	cdplt	8, 0, cr0, cr7, cr3, {0}
    28b8:	03000007 	movweq	r0, #7
    28bc:	15d60404 	ldrbne	r0, [r6, #1028]	; 0x404
    28c0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    28c4:	0015ce03 	andseq	ip, r5, r3, lsl #28
    28c8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    28cc:	00001ecc 	andeq	r1, r0, ip, asr #29
    28d0:	7e031003 	cdpvc	0, 0, cr1, cr3, cr3, {0}
    28d4:	0c00001f 	stceq	0, cr0, [r0], {31}
    28d8:	0000088a 	andeq	r0, r0, sl, lsl #17
    28dc:	000008c9 	andeq	r0, r0, r9, asr #17
    28e0:	00002415 	andeq	r2, r0, r5, lsl r4
    28e4:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    28e8:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    28ec:	001ddd0f 	andseq	sp, sp, pc, lsl #26
    28f0:	01fc0600 	mvnseq	r0, r0, lsl #12
    28f4:	0008c916 	andeq	ip, r8, r6, lsl r9
    28f8:	15850f00 	strne	r0, [r5, #3840]	; 0xf00
    28fc:	02060000 	andeq	r0, r6, #0
    2900:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    2904:	ff040000 			; <UNDEFINED> instruction: 0xff040000
    2908:	07000021 	streq	r0, [r0, -r1, lsr #32]
    290c:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    2910:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    2914:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    2918:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    291c:	03570900 	cmpeq	r7, #0, 18
    2920:	2f070000 	svccs	0x00070000
    2924:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2928:	020c0900 	andeq	r0, ip, #0, 18
    292c:	30070000 	andcc	r0, r7, r0
    2930:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2934:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2938:	33080000 	movwcc	r0, #32768	; 0x8000
    293c:	03050a09 	movweq	r0, #23049	; 0x5a09
    2940:	00009959 	andeq	r9, r0, r9, asr r9
    2944:	00090b17 	andeq	r0, r9, r7, lsl fp
    2948:	09340800 	ldmdbeq	r4!, {fp}
    294c:	5903050a 	stmdbpl	r3, {r1, r3, r8, sl}
    2950:	00000099 	muleq	r0, r9, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3772a8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb93b0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb93d0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb93e8>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x3d8>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79f28>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe3940c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f733c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6788>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9fec>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4fa4>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b67b4>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6828>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3773a4>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb94a4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79fe0>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe394c4>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb94dc>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe7a014>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5050>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377494>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f745c>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6920>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00160400 	andseq	r0, r6, r0, lsl #8
 208:	0b3a0e03 	bleq	e83a1c <__bss_end+0xe7a0b0>
 20c:	0b390b3b 	bleq	e42f00 <__bss_end+0xe39594>
 210:	00001349 	andeq	r1, r0, r9, asr #6
 214:	0b002405 	bleq	9230 <_Z5isinff+0x28>
 218:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 21c:	06000008 	streq	r0, [r0], -r8
 220:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 224:	0b3b0b3a 	bleq	ec2f14 <__bss_end+0xeb95a8>
 228:	13490b39 	movtne	r0, #39737	; 0x9b39
 22c:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 230:	13070000 	movwne	r0, #28672	; 0x7000
 234:	0b0e0301 	bleq	380e40 <__bss_end+0x3774d4>
 238:	3b0b3a0b 	blcc	2cea6c <__bss_end+0x2c5100>
 23c:	010b390b 	tsteq	fp, fp, lsl #18
 240:	08000013 	stmdaeq	r0, {r0, r1, r4}
 244:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 248:	0b3b0b3a 	bleq	ec2f38 <__bss_end+0xeb95cc>
 24c:	13490b39 	movtne	r0, #39737	; 0x9b39
 250:	00000b38 	andeq	r0, r0, r8, lsr fp
 254:	03010409 	movweq	r0, #5129	; 0x1409
 258:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 25c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 260:	3b0b3a13 	blcc	2ceab4 <__bss_end+0x2c5148>
 264:	010b390b 	tsteq	fp, fp, lsl #18
 268:	0a000013 	beq	2bc <shift+0x2bc>
 26c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 270:	00000b1c 	andeq	r0, r0, ip, lsl fp
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2ba128>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb9608>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x37752c>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe7a14c>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe39630>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x377564>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb9664>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7b6a8>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x3775f8>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb9698>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7b6dc>
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
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x3775e4>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f8a04>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c523c>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb9704>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x377630>
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
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeb9754>
 3d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3dc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3e0:	00130119 	andseq	r0, r3, r9, lsl r1
 3e4:	00052300 	andeq	r2, r5, r0, lsl #6
 3e8:	0b3a0e03 	bleq	e83bfc <__bss_end+0xe7a290>
 3ec:	0b390b3b 	bleq	e430e0 <__bss_end+0xe39774>
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
 41c:	03001604 	movweq	r1, #1540	; 0x604
 420:	3b0b3a0e 	blcc	2cec60 <__bss_end+0x2c52f4>
 424:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 428:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 42c:	0b0b0024 	bleq	2c04c4 <__bss_end+0x2b6b58>
 430:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 434:	34060000 	strcc	r0, [r6], #-0
 438:	3a0e0300 	bcc	381040 <__bss_end+0x3776d4>
 43c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 440:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 444:	00180219 	andseq	r0, r8, r9, lsl r2
 448:	01130700 	tsteq	r3, r0, lsl #14
 44c:	0b0b0e03 	bleq	2c3c60 <__bss_end+0x2ba2f4>
 450:	0b3b0b3a 	bleq	ec3140 <__bss_end+0xeb97d4>
 454:	13010b39 	movwne	r0, #6969	; 0x1b39
 458:	0d080000 	stceq	0, cr0, [r8, #-0]
 45c:	3a080300 	bcc	201064 <__bss_end+0x1f76f8>
 460:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 464:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 468:	0900000b 	stmdbeq	r0, {r0, r1, r3}
 46c:	0e030104 	adfeqs	f0, f3, f4
 470:	0b3e196d 	bleq	f86a2c <__bss_end+0xf7d0c0>
 474:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 478:	0b3b0b3a 	bleq	ec3168 <__bss_end+0xeb97fc>
 47c:	13010b39 	movwne	r0, #6969	; 0x1b39
 480:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 484:	1c080300 	stcne	3, cr0, [r8], {-0}
 488:	0b00000b 	bleq	4bc <shift+0x4bc>
 48c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 490:	00000b1c 	andeq	r0, r0, ip, lsl fp
 494:	0300020c 	movweq	r0, #524	; 0x20c
 498:	00193c0e 	andseq	r3, r9, lr, lsl #24
 49c:	01020d00 	tsteq	r2, r0, lsl #26
 4a0:	0b0b0e03 	bleq	2c3cb4 <__bss_end+0x2ba348>
 4a4:	0b3b0b3a 	bleq	ec3194 <__bss_end+0xeb9828>
 4a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4ac:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 4b0:	3a0e0300 	bcc	3810b8 <__bss_end+0x37774c>
 4b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4bc:	0f00000b 	svceq	0x0000000b
 4c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4c4:	0b3a0e03 	bleq	e83cd8 <__bss_end+0xe7a36c>
 4c8:	0b390b3b 	bleq	e431bc <__bss_end+0xe39850>
 4cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4d4:	05100000 	ldreq	r0, [r0, #-0]
 4d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 4dc:	11000019 	tstne	r0, r9, lsl r0
 4e0:	13490005 	movtne	r0, #36869	; 0x9005
 4e4:	0d120000 	ldceq	0, cr0, [r2, #-0]
 4e8:	3a0e0300 	bcc	3810f0 <__bss_end+0x377784>
 4ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	3f13490b 	svccc	0x0013490b
 4f4:	00193c19 	andseq	r3, r9, r9, lsl ip
 4f8:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 4fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 500:	0b3b0b3a 	bleq	ec31f0 <__bss_end+0xeb9884>
 504:	0e6e0b39 	vmoveq.8	d14[5], r0
 508:	0b321349 	bleq	c85234 <__bss_end+0xc7b8c8>
 50c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 510:	00001301 	andeq	r1, r0, r1, lsl #6
 514:	3f012e14 	svccc	0x00012e14
 518:	3a0e0319 	bcc	381184 <__bss_end+0x377818>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 524:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 528:	00130113 	andseq	r0, r3, r3, lsl r1
 52c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 530:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 534:	0b3b0b3a 	bleq	ec3224 <__bss_end+0xeb98b8>
 538:	0e6e0b39 	vmoveq.8	d14[5], r0
 53c:	0b321349 	bleq	c85268 <__bss_end+0xc7b8fc>
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
 568:	3a0e0300 	bcc	381170 <__bss_end+0x377804>
 56c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 570:	3f13490b 	svccc	0x0013490b
 574:	00193c19 	andseq	r3, r9, r9, lsl ip
 578:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 57c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 580:	0b3b0b3a 	bleq	ec3270 <__bss_end+0xeb9904>
 584:	0e6e0b39 	vmoveq.8	d14[5], r0
 588:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 58c:	00001301 	andeq	r1, r0, r1, lsl #6
 590:	3f012e1c 	svccc	0x00012e1c
 594:	3a0e0319 	bcc	381200 <__bss_end+0x377894>
 598:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 59c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5a0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 5a4:	00130113 	andseq	r0, r3, r3, lsl r1
 5a8:	000d1d00 	andeq	r1, sp, r0, lsl #26
 5ac:	0b3a0e03 	bleq	e83dc0 <__bss_end+0xe7a454>
 5b0:	0b390b3b 	bleq	e432a4 <__bss_end+0xe39938>
 5b4:	0b381349 	bleq	e052e0 <__bss_end+0xdfb974>
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
 5e4:	3b0b3a0e 	blcc	2cee24 <__bss_end+0x2c54b8>
 5e8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5ec:	00180213 	andseq	r0, r8, r3, lsl r2
 5f0:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f8:	0b3b0b3a 	bleq	ec32e8 <__bss_end+0xeb997c>
 5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
 600:	01111349 	tsteq	r1, r9, asr #6
 604:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 608:	01194296 			; <UNDEFINED> instruction: 0x01194296
 60c:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 610:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 614:	0b3b0b3a 	bleq	ec3304 <__bss_end+0xeb9998>
 618:	13490b39 	movtne	r0, #39737	; 0x9b39
 61c:	00001802 	andeq	r1, r0, r2, lsl #16
 620:	3f012e25 	svccc	0x00012e25
 624:	3a0e0319 	bcc	381290 <__bss_end+0x377924>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 630:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 634:	97184006 	ldrls	r4, [r8, -r6]
 638:	13011942 	movwne	r1, #6466	; 0x1942
 63c:	34260000 	strtcc	r0, [r6], #-0
 640:	3a080300 	bcc	201248 <__bss_end+0x1f78dc>
 644:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 648:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 64c:	27000018 	smladcs	r0, r8, r0, r0
 650:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 654:	0b3a0e03 	bleq	e83e68 <__bss_end+0xe7a4fc>
 658:	0b390b3b 	bleq	e4334c <__bss_end+0xe399e0>
 65c:	01110e6e 	tsteq	r1, lr, ror #28
 660:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 664:	01194297 			; <UNDEFINED> instruction: 0x01194297
 668:	28000013 	stmdacs	r0, {r0, r1, r4}
 66c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 670:	0b3a0e03 	bleq	e83e84 <__bss_end+0xe7a518>
 674:	0b390b3b 	bleq	e43368 <__bss_end+0xe399fc>
 678:	01110e6e 	tsteq	r1, lr, ror #28
 67c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 680:	00194297 	mulseq	r9, r7, r2
 684:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 688:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 68c:	0b3b0b3a 	bleq	ec337c <__bss_end+0xeb9a10>
 690:	0e6e0b39 	vmoveq.8	d14[5], r0
 694:	01111349 	tsteq	r1, r9, asr #6
 698:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 69c:	00194297 	mulseq	r9, r7, r2
 6a0:	11010000 	mrsne	r0, (UNDEF: 1)
 6a4:	130e2501 	movwne	r2, #58625	; 0xe501
 6a8:	1b0e030b 	blne	3812dc <__bss_end+0x377970>
 6ac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6b0:	00171006 	andseq	r1, r7, r6
 6b4:	00340200 	eorseq	r0, r4, r0, lsl #4
 6b8:	0b3a0e03 	bleq	e83ecc <__bss_end+0xe7a560>
 6bc:	0b390b3b 	bleq	e433b0 <__bss_end+0xe39a44>
 6c0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 6c4:	00001802 	andeq	r1, r0, r2, lsl #16
 6c8:	0b002403 	bleq	96dc <__udivsi3+0x30>
 6cc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 6d0:	0400000e 	streq	r0, [r0], #-14
 6d4:	13490026 	movtne	r0, #36902	; 0x9026
 6d8:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 6dc:	00130101 	andseq	r0, r3, r1, lsl #2
 6e0:	00340600 	eorseq	r0, r4, r0, lsl #12
 6e4:	0b3a0e03 	bleq	e83ef8 <__bss_end+0xe7a58c>
 6e8:	0b390b3b 	bleq	e433dc <__bss_end+0xe39a70>
 6ec:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 6f0:	00000a1c 	andeq	r0, r0, ip, lsl sl
 6f4:	3a003a07 	bcc	ef18 <__bss_end+0x55ac>
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
 720:	3b0b3a0e 	blcc	2cef60 <__bss_end+0x2c55f4>
 724:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 728:	1113490e 	tstne	r3, lr, lsl #18
 72c:	40061201 	andmi	r1, r6, r1, lsl #4
 730:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 734:	00001301 	andeq	r1, r0, r1, lsl #6
 738:	0300050c 	movweq	r0, #1292	; 0x50c
 73c:	3b0b3a08 	blcc	2cef64 <__bss_end+0x2c55f8>
 740:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 744:	00180213 	andseq	r0, r8, r3, lsl r2
 748:	00340d00 	eorseq	r0, r4, r0, lsl #26
 74c:	0b3a0803 	bleq	e82760 <__bss_end+0xe78df4>
 750:	0b390b3b 	bleq	e43444 <__bss_end+0xe39ad8>
 754:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 758:	340e0000 	strcc	r0, [lr], #-0
 75c:	3a0e0300 	bcc	381364 <__bss_end+0x3779f8>
 760:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 764:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 768:	0f000018 	svceq	0x00000018
 76c:	0111010b 	tsteq	r1, fp, lsl #2
 770:	00000612 	andeq	r0, r0, r2, lsl r6
 774:	03003410 	movweq	r3, #1040	; 0x410
 778:	3b0b3a0e 	blcc	2cefb8 <__bss_end+0x2c564c>
 77c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 780:	00180213 	andseq	r0, r8, r3, lsl r2
 784:	00341100 	eorseq	r1, r4, r0, lsl #2
 788:	0b3a0803 	bleq	e8279c <__bss_end+0xe78e30>
 78c:	0b39053b 	bleq	e41c80 <__bss_end+0xe38314>
 790:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 794:	0f120000 	svceq	0x00120000
 798:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 79c:	13000013 	movwne	r0, #19
 7a0:	0b0b0024 	bleq	2c0838 <__bss_end+0x2b6ecc>
 7a4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7a8:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 7ac:	03193f01 	tsteq	r9, #1, 30
 7b0:	3b0b3a0e 	blcc	2ceff0 <__bss_end+0x2c5684>
 7b4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7b8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7bc:	96184006 	ldrls	r4, [r8], -r6
 7c0:	13011942 	movwne	r1, #6466	; 0x1942
 7c4:	05150000 	ldreq	r0, [r5, #-0]
 7c8:	3a0e0300 	bcc	3813d0 <__bss_end+0x377a64>
 7cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7d0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7d4:	16000018 			; <UNDEFINED> instruction: 0x16000018
 7d8:	0111010b 	tsteq	r1, fp, lsl #2
 7dc:	13010612 	movwne	r0, #5650	; 0x1612
 7e0:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 7e4:	03193f01 	tsteq	r9, #1, 30
 7e8:	3b0b3a0e 	blcc	2cf028 <__bss_end+0x2c56bc>
 7ec:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7f0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7f4:	97184006 	ldrls	r4, [r8, -r6]
 7f8:	13011942 	movwne	r1, #6466	; 0x1942
 7fc:	10180000 	andsne	r0, r8, r0
 800:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 804:	19000013 	stmdbne	r0, {r0, r1, r4}
 808:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 80c:	0b3a0803 	bleq	e82820 <__bss_end+0xe78eb4>
 810:	0b390b3b 	bleq	e43504 <__bss_end+0xe39b98>
 814:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 818:	06120111 			; <UNDEFINED> instruction: 0x06120111
 81c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 820:	00130119 	andseq	r0, r3, r9, lsl r1
 824:	00261a00 	eoreq	r1, r6, r0, lsl #20
 828:	0f1b0000 	svceq	0x001b0000
 82c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 830:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 834:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 838:	0b3b0b3a 	bleq	ec3528 <__bss_end+0xeb9bbc>
 83c:	0e6e0b39 	vmoveq.8	d14[5], r0
 840:	06120111 			; <UNDEFINED> instruction: 0x06120111
 844:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 848:	00000019 	andeq	r0, r0, r9, lsl r0
 84c:	10001101 	andne	r1, r0, r1, lsl #2
 850:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 854:	1b0e0301 	blne	381460 <__bss_end+0x377af4>
 858:	130e250e 	movwne	r2, #58638	; 0xe50e
 85c:	00000005 	andeq	r0, r0, r5
 860:	10001101 	andne	r1, r0, r1, lsl #2
 864:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 868:	1b0e0301 	blne	381474 <__bss_end+0x377b08>
 86c:	130e250e 	movwne	r2, #58638	; 0xe50e
 870:	00000005 	andeq	r0, r0, r5
 874:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 878:	030b130e 	movweq	r1, #45838	; 0xb30e
 87c:	100e1b0e 	andne	r1, lr, lr, lsl #22
 880:	02000017 	andeq	r0, r0, #23
 884:	0b0b0024 	bleq	2c091c <__bss_end+0x2b6fb0>
 888:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 88c:	24030000 	strcs	r0, [r3], #-0
 890:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 894:	000e030b 	andeq	r0, lr, fp, lsl #6
 898:	00160400 	andseq	r0, r6, r0, lsl #8
 89c:	0b3a0e03 	bleq	e840b0 <__bss_end+0xe7a744>
 8a0:	0b390b3b 	bleq	e43594 <__bss_end+0xe39c28>
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
 8cc:	3b0b3a0e 	blcc	2cf10c <__bss_end+0x2c57a0>
 8d0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8d4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8d8:	0a000019 	beq	944 <shift+0x944>
 8dc:	0e030104 	adfeqs	f0, f3, f4
 8e0:	0b0b0b3e 	bleq	2c35e0 <__bss_end+0x2b9c74>
 8e4:	0b3a1349 	bleq	e85610 <__bss_end+0xe7bca4>
 8e8:	0b390b3b 	bleq	e435dc <__bss_end+0xe39c70>
 8ec:	00001301 	andeq	r1, r0, r1, lsl #6
 8f0:	0300280b 	movweq	r2, #2059	; 0x80b
 8f4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 8f8:	01010c00 	tsteq	r1, r0, lsl #24
 8fc:	13011349 	movwne	r1, #4937	; 0x1349
 900:	210d0000 	mrscs	r0, (UNDEF: 13)
 904:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 908:	13490026 	movtne	r0, #36902	; 0x9026
 90c:	340f0000 	strcc	r0, [pc], #-0	; 914 <shift+0x914>
 910:	3a0e0300 	bcc	381518 <__bss_end+0x377bac>
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
 93c:	0b0e0301 	bleq	381548 <__bss_end+0x377bdc>
 940:	3b0b3a0b 	blcc	2cf174 <__bss_end+0x2c5808>
 944:	010b3905 	tsteq	fp, r5, lsl #18
 948:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 94c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 950:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 954:	13490b39 	movtne	r0, #39737	; 0x9b39
 958:	00000b38 	andeq	r0, r0, r8, lsr fp
 95c:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 960:	000b2f13 	andeq	r2, fp, r3, lsl pc
 964:	01041600 	tsteq	r4, r0, lsl #12
 968:	0b3e0e03 	bleq	f8417c <__bss_end+0xf7a810>
 96c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 970:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 974:	13010b39 	movwne	r0, #6969	; 0x1b39
 978:	34170000 	ldrcc	r0, [r7], #-0
 97c:	3a134700 	bcc	4d2584 <__bss_end+0x4c8c18>
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
  84:	0b750002 	bleq	1d40094 <__bss_end+0x1d36728>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008274 	andeq	r8, r0, r4, ror r2
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	18d50002 	ldmne	r5, {r1}^
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086d0 	ldrdeq	r8, [r0], -r0
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1fd20002 	svcne	0x00d20002
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	000096ac 	andeq	r9, r0, ip, lsr #13
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1ff80002 	svcne	0x00f80002
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	000098b8 			; <UNDEFINED> instruction: 0x000098b8
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	201e0002 	andscs	r0, lr, r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff65e0>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6385>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff6387>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad509c>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff64d5>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10bea0c>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcffb8>
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
     3bc:	6a2f656d 	bvs	bd9978 <__bss_end+0xbd000c>
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
     450:	314e5a5f 	cmpcc	lr, pc, asr sl
     454:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     458:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     45c:	614d5f73 	hvcvs	54771	; 0xd5f3
     460:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     464:	47383172 			; <UNDEFINED> instruction: 0x47383172
     468:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     46c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     470:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     474:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     478:	3032456f 	eorscc	r4, r2, pc, ror #10
     47c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     480:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     484:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     488:	5f6f666e 	svcpl	0x006f666e
     48c:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     490:	6d007650 	stcvs	6, cr7, [r0, #-320]	; 0xfffffec0
     494:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     498:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     49c:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     4a0:	2074726f 	rsbscs	r7, r4, pc, ror #4
     4a4:	00746e69 	rsbseq	r6, r4, r9, ror #28
     4a8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     4ac:	6f72505f 	svcvs	0x0072505f
     4b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4b4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     4b8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     4bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4c0:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     4c4:	636f7250 	cmnvs	pc, #80, 4
     4c8:	5f737365 	svcpl	0x00737365
     4cc:	616e614d 	cmnvs	lr, sp, asr #2
     4d0:	31726567 	cmncc	r2, r7, ror #10
     4d4:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4d8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4dc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4e0:	6f72505f 	svcvs	0x0072505f
     4e4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4e8:	4d007645 	stcmi	6, cr7, [r0, #-276]	; 0xfffffeec
     4ec:	505f7861 	subspl	r7, pc, r1, ror #16
     4f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4f4:	4f5f7373 	svcmi	0x005f7373
     4f8:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     4fc:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     500:	0073656c 	rsbseq	r6, r3, ip, ror #10
     504:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     508:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     50c:	4700657a 	smlsdxmi	r0, sl, r5, r6
     510:	505f7465 	subspl	r7, pc, r5, ror #8
     514:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     518:	006e6961 	rsbeq	r6, lr, r1, ror #18
     51c:	5f534667 	svcpl	0x00534667
     520:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     524:	00737265 	rsbseq	r7, r3, r5, ror #4
     528:	5f534667 	svcpl	0x00534667
     52c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     530:	5f737265 	svcpl	0x00737265
     534:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     538:	5a5f0074 	bpl	17c0710 <__bss_end+0x17b6da4>
     53c:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     540:	6f725043 	svcvs	0x00725043
     544:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     548:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     54c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     550:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     554:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     558:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     55c:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     560:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     564:	5f006a45 	svcpl	0x00006a45
     568:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     56c:	6f725043 	svcvs	0x00725043
     570:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     574:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     578:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     57c:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     580:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     584:	00764565 	rsbseq	r4, r6, r5, ror #10
     588:	314e5a5f 	cmpcc	lr, pc, asr sl
     58c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     590:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     594:	614d5f73 	hvcvs	54771	; 0xd5f3
     598:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     59c:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     5a0:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     5a4:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     5a8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5ac:	006a4573 	rsbeq	r4, sl, r3, ror r5
     5b0:	61766e49 	cmnvs	r6, r9, asr #28
     5b4:	5f64696c 	svcpl	0x0064696c
     5b8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5bc:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     5c0:	5f6b6369 	svcpl	0x006b6369
     5c4:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     5c8:	73690074 	cmnvc	r9, #116	; 0x74
     5cc:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     5d0:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     5d4:	77530079 			; <UNDEFINED> instruction: 0x77530079
     5d8:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     5dc:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     5e0:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     5e4:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     5e8:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     5ec:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     5f0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     5f4:	46730068 	ldrbtmi	r0, [r3], -r8, rrx
     5f8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     5fc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     600:	6f62006d 	svcvs	0x0062006d
     604:	6d006c6f 	stcvs	12, cr6, [r0, #-444]	; 0xfffffe44
     608:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     60c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     610:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     614:	6f4e0063 	svcvs	0x004e0063
     618:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     61c:	6f72505f 	svcvs	0x0072505f
     620:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     624:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     628:	5f656c64 	svcpl	0x00656c64
     62c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     630:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     634:	535f6d65 	cmppl	pc, #6464	; 0x1940
     638:	63004957 	movwvs	r4, #2391	; 0x957
     63c:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     640:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     644:	43007478 	movwmi	r7, #1144	; 0x478
     648:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     64c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     650:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     654:	65440073 	strbvs	r0, [r4, #-115]	; 0xffffff8d
     658:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     65c:	7300656e 	movwvc	r6, #1390	; 0x56e
     660:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     664:	6174735f 	cmnvs	r4, pc, asr r3
     668:	5f636974 	svcpl	0x00636974
     66c:	6f697270 	svcvs	0x00697270
     670:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     674:	72617000 	rsbvc	r7, r1, #0
     678:	00746e65 	rsbseq	r6, r4, r5, ror #28
     67c:	6b636f4c 	blvs	18dc3b4 <__bss_end+0x18d2a48>
     680:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     684:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     688:	46540064 	ldrbmi	r0, [r4], -r4, rrx
     68c:	72545f53 	subsvc	r5, r4, #332	; 0x14c
     690:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
     694:	0065646f 	rsbeq	r6, r5, pc, ror #8
     698:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     69c:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     6a0:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     6a4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     6a8:	78650068 	stmdavc	r5!, {r3, r5, r6}^
     6ac:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     6b0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     6b4:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     6b8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     6bc:	006d6574 	rsbeq	r6, sp, r4, ror r5
     6c0:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
     6c4:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
     6c8:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     6cc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     6d0:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     6d4:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     6d8:	7065656c 	rsbvc	r6, r5, ip, ror #10
     6dc:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     6e0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     6e4:	5a5f0065 	bpl	17c0880 <__bss_end+0x17b6f14>
     6e8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6ec:	636f7250 	cmnvs	pc, #80, 4
     6f0:	5f737365 	svcpl	0x00737365
     6f4:	616e614d 	cmnvs	lr, sp, asr #2
     6f8:	31726567 	cmncc	r2, r7, ror #10
     6fc:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
     700:	5f657461 	svcpl	0x00657461
     704:	636f7250 	cmnvs	pc, #80, 4
     708:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     70c:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
     710:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     714:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     718:	5f656c69 	svcpl	0x00656c69
     71c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     720:	00746e65 	rsbseq	r6, r4, r5, ror #28
     724:	76677261 	strbtvc	r7, [r7], -r1, ror #4
     728:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     72c:	50433631 	subpl	r3, r3, r1, lsr r6
     730:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     734:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 570 <shift+0x570>
     738:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     73c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     740:	616d6e55 	cmnvs	sp, r5, asr lr
     744:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     748:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     74c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     750:	6a45746e 	bvs	115d910 <__bss_end+0x1153fa4>
     754:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     758:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     75c:	52525f65 	subspl	r5, r2, #404	; 0x194
     760:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
     764:	00656962 	rsbeq	r6, r5, r2, ror #18
     768:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     76c:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; 6a8 <shift+0x6a8>
     770:	57005841 	strpl	r5, [r0, -r1, asr #16]
     774:	00746961 	rsbseq	r6, r4, r1, ror #18
     778:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     77c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     780:	61686320 	cmnvs	r8, r0, lsr #6
     784:	46540072 			; <UNDEFINED> instruction: 0x46540072
     788:	72445f53 	subvc	r5, r4, #332	; 0x14c
     78c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     790:	72504300 	subsvc	r4, r0, #0, 6
     794:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     798:	614d5f73 	hvcvs	54771	; 0xd5f3
     79c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7a0:	65520072 	ldrbvs	r0, [r2, #-114]	; 0xffffff8e
     7a4:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
     7a8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     7ac:	72507300 	subsvc	r7, r0, #0, 6
     7b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7b4:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
     7b8:	61655200 	cmnvs	r5, r0, lsl #4
     7bc:	6f6c0064 	svcvs	0x006c0064
     7c0:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
     7c4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     7c8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     7cc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     7d0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     7d4:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     7d8:	5f323374 	svcpl	0x00323374
     7dc:	5a5f0074 	bpl	17c09b4 <__bss_end+0x17b7048>
     7e0:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     7e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7e8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     7ec:	4f346d65 	svcmi	0x00346d65
     7f0:	456e6570 	strbmi	r6, [lr, #-1392]!	; 0xfffffa90
     7f4:	31634b50 	cmncc	r3, r0, asr fp
     7f8:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     7fc:	4f5f656c 	svcmi	0x005f656c
     800:	5f6e6570 	svcpl	0x006e6570
     804:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     808:	6f6c4200 	svcvs	0x006c4200
     80c:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     810:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     814:	505f746e 	subspl	r7, pc, lr, ror #8
     818:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     81c:	46007373 			; <UNDEFINED> instruction: 0x46007373
     820:	5f646e69 	svcpl	0x00646e69
     824:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     828:	61740064 	cmnvs	r4, r4, rrx
     82c:	55006b73 	strpl	r6, [r0, #-2931]	; 0xfffff48d
     830:	33544e49 	cmpcc	r4, #1168	; 0x490
     834:	494d5f32 	stmdbmi	sp, {r1, r4, r5, r8, r9, sl, fp, ip, lr}^
     838:	7474004e 	ldrbtvc	r0, [r4], #-78	; 0xffffffb2
     83c:	00307262 	eorseq	r7, r0, r2, ror #4
     840:	6f6f526d 	svcvs	0x006f526d
     844:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     848:	72640074 	rsbvc	r0, r4, #116	; 0x74
     84c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     850:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     854:	5a5f006e 	bpl	17c0a14 <__bss_end+0x17b70a8>
     858:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     85c:	636f7250 	cmnvs	pc, #80, 4
     860:	5f737365 	svcpl	0x00737365
     864:	616e614d 	cmnvs	lr, sp, asr #2
     868:	31726567 	cmncc	r2, r7, ror #10
     86c:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     870:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     874:	6f545f65 	svcvs	0x00545f65
     878:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     87c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     880:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     884:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     888:	72506d00 	subsvc	r6, r0, #0, 26
     88c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     890:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     894:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     898:	00646165 	rsbeq	r6, r4, r5, ror #2
     89c:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     8a0:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     8a4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     8a8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     8ac:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     8b0:	746f6f52 	strbtvc	r6, [pc], #-3922	; 8b8 <shift+0x8b8>
     8b4:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     8b8:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     8bc:	5f726576 	svcpl	0x00726576
     8c0:	00786469 	rsbseq	r6, r8, r9, ror #8
     8c4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8c8:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     8cc:	6c42006c 	mcrrvs	0, 6, r0, r2, cr12
     8d0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     8d4:	65520064 	ldrbvs	r0, [r2, #-100]	; 0xffffff9c
     8d8:	4f5f6461 	svcmi	0x005f6461
     8dc:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     8e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     8e4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8e8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8ec:	614d5f73 	hvcvs	54771	; 0xd5f3
     8f0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8f4:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     8f8:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     8fc:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     900:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     904:	5f72656c 	svcpl	0x0072656c
     908:	6f666e49 	svcvs	0x00666e49
     90c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     910:	50433631 	subpl	r3, r3, r1, lsr r6
     914:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     918:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 754 <shift+0x754>
     91c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     920:	31317265 	teqcc	r1, r5, ror #4
     924:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     928:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     92c:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     930:	75520076 	ldrbvc	r0, [r2, #-118]	; 0xffffff8a
     934:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     938:	4d00656c 	cfstr32mi	mvfx6, [r0, #-432]	; 0xfffffe50
     93c:	61507861 	cmpvs	r0, r1, ror #16
     940:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     944:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     948:	63536d00 	cmpvs	r3, #0, 26
     94c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     950:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     954:	5f00636e 	svcpl	0x0000636e
     958:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     95c:	6f725043 	svcvs	0x00725043
     960:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     964:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     968:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     96c:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     970:	5f6b636f 	svcpl	0x006b636f
     974:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     978:	5f746e65 	svcpl	0x00746e65
     97c:	636f7250 	cmnvs	pc, #80, 4
     980:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     984:	61480076 	hvcvs	32774	; 0x8006
     988:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     98c:	6f72505f 	svcvs	0x0072505f
     990:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     994:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     998:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     99c:	6f72505f 	svcvs	0x0072505f
     9a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9a4:	5f79425f 	svcpl	0x0079425f
     9a8:	00444950 	subeq	r4, r4, r0, asr r9
     9ac:	5f70614d 	svcpl	0x0070614d
     9b0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     9b4:	5f6f545f 	svcpl	0x006f545f
     9b8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     9bc:	00746e65 	rsbseq	r6, r4, r5, ror #28
     9c0:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     9c4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     9c8:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     9cc:	6f4e5f6b 	svcvs	0x004e5f6b
     9d0:	49006564 	stmdbmi	r0, {r2, r5, r6, r8, sl, sp, lr}
     9d4:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     9d8:	6f526d00 	svcvs	0x00526d00
     9dc:	5f00746f 	svcpl	0x0000746f
     9e0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9e4:	6f725043 	svcvs	0x00725043
     9e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9f4:	61483831 	cmpvs	r8, r1, lsr r8
     9f8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9fc:	6f72505f 	svcvs	0x0072505f
     a00:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a04:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a08:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     a0c:	5f495753 	svcpl	0x00495753
     a10:	636f7250 	cmnvs	pc, #80, 4
     a14:	5f737365 	svcpl	0x00737365
     a18:	76726553 			; <UNDEFINED> instruction: 0x76726553
     a1c:	6a656369 	bvs	19597c8 <__bss_end+0x194fe5c>
     a20:	31526a6a 	cmpcc	r2, sl, ror #20
     a24:	57535431 	smmlarpl	r3, r1, r4, r5
     a28:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     a2c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     a30:	6f6c4300 	svcvs	0x006c4300
     a34:	5f006573 	svcpl	0x00006573
     a38:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a3c:	6f725043 	svcvs	0x00725043
     a40:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a44:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a48:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a4c:	61483132 	cmpvs	r8, r2, lsr r1
     a50:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a54:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a58:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a5c:	5f6d6574 	svcpl	0x006d6574
     a60:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     a64:	534e3332 	movtpl	r3, #58162	; 0xe332
     a68:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     a6c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a70:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a74:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     a78:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a7c:	6a6a6a65 	bvs	1a9b418 <__bss_end+0x1a91aac>
     a80:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a84:	5f495753 	svcpl	0x00495753
     a88:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a8c:	4e00746c 	cdpmi	4, 0, cr7, cr0, cr12, {3}
     a90:	5f746547 	svcpl	0x00746547
     a94:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a98:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     a9c:	545f6f66 	ldrbpl	r6, [pc], #-3942	; aa4 <shift+0xaa4>
     aa0:	00657079 	rsbeq	r7, r5, r9, ror r0
     aa4:	6b636f4c 	blvs	18dc7dc <__bss_end+0x18d2e70>
     aa8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     aac:	0064656b 	rsbeq	r6, r4, fp, ror #10
     ab0:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     ab4:	4e007966 	vmlsmi.f16	s14, s0, s13	; <UNPREDICTABLE>
     ab8:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     abc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ac0:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     ac4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     ac8:	5a5f0072 	bpl	17c0c98 <__bss_end+0x17b732c>
     acc:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     ad0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ad4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     ad8:	33316d65 	teqcc	r1, #6464	; 0x1940
     adc:	5f534654 	svcpl	0x00534654
     ae0:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     ae4:	646f4e5f 	strbtvs	r4, [pc], #-3679	; aec <shift+0xaec>
     ae8:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
     aec:	5f646e69 	svcpl	0x00646e69
     af0:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     af4:	4b504564 	blmi	141208c <__bss_end+0x1408720>
     af8:	65440063 	strbvs	r0, [r4, #-99]	; 0xffffff9d
     afc:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     b00:	555f656e 	ldrbpl	r6, [pc, #-1390]	; 59a <shift+0x59a>
     b04:	6168636e 	cmnvs	r8, lr, ror #6
     b08:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     b0c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b10:	46433131 			; <UNDEFINED> instruction: 0x46433131
     b14:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b18:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b1c:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     b20:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     b24:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     b28:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     b2c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     b30:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b34:	75520073 	ldrbvc	r0, [r2, #-115]	; 0xffffff8d
     b38:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     b3c:	65470067 	strbvs	r0, [r7, #-103]	; 0xffffff99
     b40:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b44:	5f646568 	svcpl	0x00646568
     b48:	6f666e49 	svcvs	0x00666e49
     b4c:	72655400 	rsbvc	r5, r5, #0, 8
     b50:	616e696d 	cmnvs	lr, sp, ror #18
     b54:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     b58:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b5c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     b60:	445f6d65 	ldrbmi	r6, [pc], #-3429	; b68 <shift+0xb68>
     b64:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     b68:	72700072 	rsbsvc	r0, r0, #114	; 0x72
     b6c:	41007665 	tstmi	r0, r5, ror #12
     b70:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     b74:	72505f65 	subsvc	r5, r0, #404	; 0x194
     b78:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b7c:	6f435f73 	svcvs	0x00435f73
     b80:	00746e75 	rsbseq	r6, r4, r5, ror lr
     b84:	314e5a5f 	cmpcc	lr, pc, asr sl
     b88:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b8c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b90:	614d5f73 	hvcvs	54771	; 0xd5f3
     b94:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b98:	77533972 			; <UNDEFINED> instruction: 0x77533972
     b9c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     ba0:	456f545f 	strbmi	r5, [pc, #-1119]!	; 749 <shift+0x749>
     ba4:	43383150 	teqmi	r8, #80, 2
     ba8:	636f7250 	cmnvs	pc, #80, 4
     bac:	5f737365 	svcpl	0x00737365
     bb0:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     bb4:	646f4e5f 	strbtvs	r4, [pc], #-3679	; bbc <shift+0xbbc>
     bb8:	63730065 	cmnvs	r3, #101	; 0x65
     bbc:	5f646568 	svcpl	0x00646568
     bc0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     bc4:	00726574 	rsbseq	r6, r2, r4, ror r5
     bc8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bcc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bd0:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     bd4:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     bd8:	4f5f6574 	svcmi	0x005f6574
     bdc:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     be0:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     be4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     be8:	50433631 	subpl	r3, r3, r1, lsr r6
     bec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bf0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a2c <shift+0xa2c>
     bf4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     bf8:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     bfc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     c00:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     c04:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     c08:	5f007645 	svcpl	0x00007645
     c0c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c10:	6f725043 	svcvs	0x00725043
     c14:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c18:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c1c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c20:	6f4e3431 	svcvs	0x004e3431
     c24:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     c28:	6f72505f 	svcvs	0x0072505f
     c2c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c30:	32315045 	eorscc	r5, r1, #69	; 0x45
     c34:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     c38:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     c3c:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     c40:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c44:	46433131 			; <UNDEFINED> instruction: 0x46433131
     c48:	73656c69 	cmnvc	r5, #26880	; 0x6900
     c4c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     c50:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     c54:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     c58:	7a696c61 	bvc	1a5bde4 <__bss_end+0x1a52478>
     c5c:	00764565 	rsbseq	r4, r6, r5, ror #10
     c60:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     c64:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
     c68:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c6c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     c70:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
     c74:	61767465 	cmnvs	r6, r5, ror #8
     c78:	636e006c 	cmnvs	lr, #108	; 0x6c
     c7c:	70007275 	andvc	r7, r0, r5, ror r2
     c80:	00657069 	rsbeq	r7, r5, r9, rrx
     c84:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     c88:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c8c:	00646c65 	rsbeq	r6, r4, r5, ror #24
     c90:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
     c94:	5a5f006d 	bpl	17c0e50 <__bss_end+0x17b74e4>
     c98:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
     c9c:	5f646568 	svcpl	0x00646568
     ca0:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     ca4:	5f007664 	svcpl	0x00007664
     ca8:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     cac:	745f7465 	ldrbvc	r7, [pc], #-1125	; cb4 <shift+0xcb4>
     cb0:	5f6b7361 	svcpl	0x006b7361
     cb4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     cb8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     cbc:	6177006a 	cmnvs	r7, sl, rrx
     cc0:	5f007469 	svcpl	0x00007469
     cc4:	6f6e365a 	svcvs	0x006e365a
     cc8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     ccc:	5f006a6a 	svcpl	0x00006a6a
     cd0:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
     cd4:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     cd8:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     cdc:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     ce0:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     ce4:	6f637469 	svcvs	0x00637469
     ce8:	5f006564 	svcpl	0x00006564
     cec:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     cf0:	615f7465 	cmpvs	pc, r5, ror #8
     cf4:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     cf8:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     cfc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d00:	6f635f73 	svcvs	0x00635f73
     d04:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     d08:	63697400 	cmnvs	r9, #0, 8
     d0c:	6f635f6b 	svcvs	0x00635f6b
     d10:	5f746e75 	svcpl	0x00746e75
     d14:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     d18:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     d1c:	70695000 	rsbvc	r5, r9, r0
     d20:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d24:	505f656c 	subspl	r6, pc, ip, ror #10
     d28:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     d2c:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
     d30:	61505f74 	cmpvs	r0, r4, ror pc
     d34:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     d38:	315a5f00 	cmpcc	sl, r0, lsl #30
     d3c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     d40:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     d44:	6f635f6b 	svcvs	0x00635f6b
     d48:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     d4c:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     d50:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
     d54:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     d58:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 7f4 <shift+0x7f4>
     d5c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d60:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     d64:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     d68:	73006e6f 	movwvc	r6, #3695	; 0xe6f
     d6c:	745f7465 	ldrbvc	r7, [pc], #-1125	; d74 <shift+0xd74>
     d70:	5f6b7361 	svcpl	0x006b7361
     d74:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     d78:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     d7c:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     d80:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     d84:	5f006e6f 	svcpl	0x00006e6f
     d88:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     d8c:	6a65736f 	bvs	195db50 <__bss_end+0x19541e4>
     d90:	6f682f00 	svcvs	0x00682f00
     d94:	6a2f656d 	bvs	bda350 <__bss_end+0xbd09e4>
     d98:	73656d61 	cmnvc	r5, #6208	; 0x1840
     d9c:	2f697261 	svccs	0x00697261
     da0:	2f746967 	svccs	0x00746967
     da4:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     da8:	6f732f70 	svcvs	0x00732f70
     dac:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     db0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     db4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     db8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     dbc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     dc0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     dc4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     dc8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     dcc:	70746567 	rsbsvc	r6, r4, r7, ror #10
     dd0:	00766469 	rsbseq	r6, r6, r9, ror #8
     dd4:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
     dd8:	6f6e0065 	svcvs	0x006e0065
     ddc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     de0:	63697400 	cmnvs	r9, #0, 8
     de4:	6f00736b 	svcvs	0x0000736b
     de8:	006e6570 	rsbeq	r6, lr, r0, ror r5
     dec:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     df0:	50657069 	rsbpl	r7, r5, r9, rrx
     df4:	006a634b 	rsbeq	r6, sl, fp, asr #6
     df8:	6165444e 	cmnvs	r5, lr, asr #8
     dfc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e00:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     e04:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     e08:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e0c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     e10:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     e14:	6f635f6b 	svcvs	0x00635f6b
     e18:	00746e75 	rsbseq	r6, r4, r5, ror lr
     e1c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d68 <shift+0xd68>
     e20:	616a2f65 	cmnvs	sl, r5, ror #30
     e24:	6173656d 	cmnvs	r3, sp, ror #10
     e28:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     e2c:	6f2f7469 	svcvs	0x002f7469
     e30:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     e34:	756f732f 	strbvc	r7, [pc, #-815]!	; b0d <shift+0xb0d>
     e38:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     e3c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     e40:	7000646c 	andvc	r6, r0, ip, ror #8
     e44:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     e48:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     e4c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     e50:	4b506a65 	blmi	141b7ec <__bss_end+0x1411e80>
     e54:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     e58:	745f7465 	ldrbvc	r7, [pc], #-1125	; e60 <shift+0xe60>
     e5c:	5f6b7361 	svcpl	0x006b7361
     e60:	6b636974 	blvs	18db438 <__bss_end+0x18d1acc>
     e64:	6f745f73 	svcvs	0x00745f73
     e68:	6165645f 	cmnvs	r5, pc, asr r4
     e6c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e70:	4e490065 	cdpmi	0, 4, cr0, cr9, cr5, {3}
     e74:	494e4946 	stmdbmi	lr, {r1, r2, r6, r8, fp, lr}^
     e78:	77005954 	smlsdvc	r0, r4, r9, r5
     e7c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     e80:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
     e84:	7a69735f 	bvc	1a5dc08 <__bss_end+0x1a5429c>
     e88:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     e8c:	61505f74 	cmpvs	r0, r4, ror pc
     e90:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     e94:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     e98:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     e9c:	006a6a70 	rsbeq	r6, sl, r0, ror sl
     ea0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     ea4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     ea8:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
     eac:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
     eb0:	4500676e 	strmi	r6, [r0, #-1902]	; 0xfffff892
     eb4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     eb8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     ebc:	5f746e65 	svcpl	0x00746e65
     ec0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     ec4:	6f697463 	svcvs	0x00697463
     ec8:	5a5f006e 	bpl	17c1088 <__bss_end+0x17b771c>
     ecc:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
     ed0:	61745f74 	cmnvs	r4, r4, ror pc
     ed4:	745f6b73 	ldrbvc	r6, [pc], #-2931	; edc <shift+0xedc>
     ed8:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     edc:	5f6f745f 	svcpl	0x006f745f
     ee0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     ee4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     ee8:	534e0076 	movtpl	r0, #57462	; 0xe076
     eec:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     ef0:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     ef4:	6f435f74 	svcvs	0x00435f74
     ef8:	77006564 	strvc	r6, [r0, -r4, ror #10]
     efc:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
     f00:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     f04:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     f08:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     f0c:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
     f10:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     f14:	4e36316a 	rsfmisz	f3, f6, #2.0
     f18:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     f1c:	704f5f6c 	subvc	r5, pc, ip, ror #30
     f20:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     f24:	506e6f69 	rsbpl	r6, lr, r9, ror #30
     f28:	6f690076 	svcvs	0x00690076
     f2c:	006c7463 	rsbeq	r7, ip, r3, ror #8
     f30:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     f34:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     f38:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f3c:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     f40:	5f007265 	svcpl	0x00007265
     f44:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
     f48:	506a6461 	rsbpl	r6, sl, r1, ror #8
     f4c:	4e006a63 	vmlsmi.f32	s12, s0, s7
     f50:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     f54:	704f5f6c 	subvc	r5, pc, ip, ror #30
     f58:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     f5c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f60:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     f64:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f68:	5f746567 	svcpl	0x00746567
     f6c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     f70:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     f74:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f78:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     f7c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     f80:	6c696600 	stclvs	6, cr6, [r9], #-0
     f84:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     f88:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
     f8c:	74006461 	strvc	r6, [r0], #-1121	; 0xfffffb9f
     f90:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f94:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     f98:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f9c:	00646970 	rsbeq	r6, r4, r0, ror r9
     fa0:	6f345a5f 	svcvs	0x00345a5f
     fa4:	506e6570 	rsbpl	r6, lr, r0, ror r5
     fa8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     fac:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     fb0:	704f5f65 	subvc	r5, pc, r5, ror #30
     fb4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; e28 <shift+0xe28>
     fb8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     fbc:	20554e47 	subscs	r4, r5, r7, asr #28
     fc0:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     fc4:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
     fc8:	20312e32 	eorscs	r2, r1, r2, lsr lr
     fcc:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
     fd0:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
     fd4:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     fd8:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     fdc:	5b202965 	blpl	80b578 <__bss_end+0x801c0c>
     fe0:	2f4d5241 	svccs	0x004d5241
     fe4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     fe8:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
     fec:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
     ff0:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
     ff4:	6f697369 	svcvs	0x00697369
     ff8:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
     ffc:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1000:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1004:	616f6c66 	cmnvs	pc, r6, ror #24
    1008:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    100c:	61683d69 	cmnvs	r8, r9, ror #26
    1010:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1014:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1018:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    101c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1020:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1024:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1028:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    102c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1030:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1034:	20706676 	rsbscs	r6, r0, r6, ror r6
    1038:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    103c:	613d656e 	teqvs	sp, lr, ror #10
    1040:	31316d72 	teqcc	r1, r2, ror sp
    1044:	7a6a3637 	bvc	1a8e928 <__bss_end+0x1a84fbc>
    1048:	20732d66 	rsbscs	r2, r3, r6, ror #26
    104c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1050:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1054:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1058:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    105c:	6b7a3676 	blvs	1e8ea3c <__bss_end+0x1e850d0>
    1060:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1064:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1068:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    106c:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1070:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1074:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1078:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
    107c:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    1080:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    1084:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1088:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
    108c:	5f006974 	svcpl	0x00006974
    1090:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    1094:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1098:	50764b50 	rsbspl	r4, r6, r0, asr fp
    109c:	2f006976 	svccs	0x00006976
    10a0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    10a4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    10a8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    10ac:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    10b0:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    10b4:	2f70732f 	svccs	0x0070732f
    10b8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    10bc:	2f736563 	svccs	0x00736563
    10c0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    10c4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    10c8:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    10cc:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    10d0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    10d4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    10d8:	6d657200 	sfmvs	f7, 2, [r5, #-0]
    10dc:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
    10e0:	69007265 	stmdbvs	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    10e4:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    10e8:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    10ec:	61726765 	cmnvs	r2, r5, ror #14
    10f0:	7369006c 	cmnvc	r9, #108	; 0x6c
    10f4:	00666e69 	rsbeq	r6, r6, r9, ror #28
    10f8:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    10fc:	006c616d 	rsbeq	r6, ip, sp, ror #2
    1100:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1104:	6a616f74 	bvs	185cedc <__bss_end+0x1853570>
    1108:	006a6350 	rsbeq	r6, sl, r0, asr r3
    110c:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1110:	696f7000 	stmdbvs	pc!, {ip, sp, lr}^	; <UNPREDICTABLE>
    1114:	735f746e 	cmpvc	pc, #1845493760	; 0x6e000000
    1118:	006e6565 	rsbeq	r6, lr, r5, ror #10
    111c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1120:	645f676e 	ldrbvs	r6, [pc], #-1902	; 1128 <shift+0x1128>
    1124:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1128:	00736c61 	rsbseq	r6, r3, r1, ror #24
    112c:	65776f70 	ldrbvs	r6, [r7, #-3952]!	; 0xfffff090
    1130:	74730072 	ldrbtvc	r0, [r3], #-114	; 0xffffff8e
    1134:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1138:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    113c:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
    1140:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    1144:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    1148:	5a5f0074 	bpl	17c1320 <__bss_end+0x17b79b4>
    114c:	6f746134 	svcvs	0x00746134
    1150:	634b5066 	movtvs	r5, #45158	; 0xb066
    1154:	73656400 	cmnvc	r5, #0, 8
    1158:	5a5f0074 	bpl	17c1330 <__bss_end+0x17b79c4>
    115c:	76657236 			; <UNDEFINED> instruction: 0x76657236
    1160:	50727473 	rsbspl	r7, r2, r3, ror r4
    1164:	5a5f0063 	bpl	17c12f8 <__bss_end+0x17b798c>
    1168:	6e736935 			; <UNDEFINED> instruction: 0x6e736935
    116c:	00666e61 	rsbeq	r6, r6, r1, ror #28
    1170:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    1174:	61620074 	smcvs	8196	; 0x2004
    1178:	74006573 	strvc	r6, [r0], #-1395	; 0xfffffa8d
    117c:	00706d65 	rsbseq	r6, r0, r5, ror #26
    1180:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1184:	6f72657a 	svcvs	0x0072657a
    1188:	00697650 	rsbeq	r7, r9, r0, asr r6
    118c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1190:	00797063 	rsbseq	r7, r9, r3, rrx
    1194:	616f7469 	cmnvs	pc, r9, ror #8
    1198:	72747300 	rsbsvc	r7, r4, #0, 6
    119c:	74730031 	ldrbtvc	r0, [r3], #-49	; 0xffffffcf
    11a0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    11a4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    11a8:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    11ac:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    11b0:	5f006666 	svcpl	0x00006666
    11b4:	6f70335a 	svcvs	0x0070335a
    11b8:	006a6677 	rsbeq	r6, sl, r7, ror r6
    11bc:	31315a5f 	teqcc	r1, pc, asr sl
    11c0:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    11c4:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    11c8:	6674616f 	ldrbtvs	r6, [r4], -pc, ror #2
    11cc:	5f536a52 	svcpl	0x00536a52
    11d0:	61006952 	tstvs	r0, r2, asr r9
    11d4:	00666f74 	rsbeq	r6, r6, r4, ror pc
    11d8:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    11dc:	43007473 	movwmi	r7, #1139	; 0x473
    11e0:	43726168 	cmnmi	r2, #104, 2
    11e4:	41766e6f 	cmnmi	r6, pc, ror #28
    11e8:	66007272 			; <UNDEFINED> instruction: 0x66007272
    11ec:	00616f74 	rsbeq	r6, r1, r4, ror pc
    11f0:	33325a5f 	teqcc	r2, #389120	; 0x5f000
    11f4:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    11f8:	5f6c616d 	svcpl	0x006c616d
    11fc:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    1200:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1204:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    1208:	6a74616f 	bvs	1d197cc <__bss_end+0x1d0fe60>
    120c:	00696350 	rsbeq	r6, r9, r0, asr r3
    1210:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1214:	70006372 	andvc	r6, r0, r2, ror r3
    1218:	69636572 	stmdbvs	r3!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    121c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1220:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    1224:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    1228:	70636d65 	rsbvc	r6, r3, r5, ror #26
    122c:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
    1230:	00786564 	rsbseq	r6, r8, r4, ror #10
    1234:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1238:	00706d63 	rsbseq	r6, r0, r3, ror #26
    123c:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    1240:	5f007374 	svcpl	0x00007374
    1244:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1248:	4b50696f 	blmi	141b80c <__bss_end+0x1411ea0>
    124c:	756f0063 	strbvc	r0, [pc, #-99]!	; 11f1 <shift+0x11f1>
    1250:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1254:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1258:	616f7466 	cmnvs	pc, r6, ror #8
    125c:	6a635066 	bvs	18d53fc <__bss_end+0x18cba90>
    1260:	6c707300 	ldclvs	3, cr7, [r0], #-0
    1264:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1268:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    126c:	63616600 	cmnvs	r1, #0, 12
    1270:	5a5f0074 	bpl	17c1448 <__bss_end+0x17b7adc>
    1274:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1278:	506e656c 	rsbpl	r6, lr, ip, ror #10
    127c:	5f00634b 	svcpl	0x0000634b
    1280:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1284:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1288:	634b5070 	movtvs	r5, #45168	; 0xb070
    128c:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1290:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1294:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1298:	50797063 	rsbspl	r7, r9, r3, rrx
    129c:	634b5063 	movtvs	r5, #45155	; 0xb063
    12a0:	65640069 	strbvs	r0, [r4, #-105]!	; 0xffffff97
    12a4:	616d6963 	cmnvs	sp, r3, ror #18
    12a8:	6f745f6c 	svcvs	0x00745f6c
    12ac:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    12b0:	5f676e69 	svcpl	0x00676e69
    12b4:	616f6c66 	cmnvs	pc, r6, ror #24
    12b8:	5a5f0074 	bpl	17c1490 <__bss_end+0x17b7b24>
    12bc:	6f746634 	svcvs	0x00746634
    12c0:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    12c4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    12c8:	0079726f 	rsbseq	r7, r9, pc, ror #4
    12cc:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    12d0:	73006874 	movwvc	r6, #2164	; 0x874
    12d4:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    12d8:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    12dc:	72747376 	rsbsvc	r7, r4, #-671088639	; 0xd8000001
    12e0:	2f2e2e00 	svccs	0x002e2e00
    12e4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12e8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12ec:	2f2e2e2f 	svccs	0x002e2e2f
    12f0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1240 <shift+0x1240>
    12f4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    12f8:	6f632f63 	svcvs	0x00632f63
    12fc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1300:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1304:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1308:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    130c:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1310:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1314:	2f646c69 	svccs	0x00646c69
    1318:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    131c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1320:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1324:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1328:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    132c:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    1330:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1334:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1338:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    133c:	61652d65 	cmnvs	r5, r5, ror #26
    1340:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    1344:	3130322d 	teqcc	r0, sp, lsr #4
    1348:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    134c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1350:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1354:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1358:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    135c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1360:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1364:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1368:	61682f65 	cmnvs	r8, r5, ror #30
    136c:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 11ac <shift+0x11ac>
    1370:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1374:	41540063 	cmpmi	r4, r3, rrx
    1378:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    137c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1380:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1384:	61786574 	cmnvs	r8, r4, ror r5
    1388:	6f633731 	svcvs	0x00633731
    138c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1390:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    1394:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1398:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    139c:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    13a0:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    13a4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    13a8:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    13ac:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    13b0:	41540074 	cmpmi	r4, r4, ror r0
    13b4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13b8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13bc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    13c0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    13c4:	41003332 	tstmi	r0, r2, lsr r3
    13c8:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; 67e <shift+0x67e>
    13cc:	41540051 	cmpmi	r4, r1, asr r0
    13d0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13d4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13d8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    13dc:	36353131 			; <UNDEFINED> instruction: 0x36353131
    13e0:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    13e4:	61736900 	cmnvs	r3, r0, lsl #18
    13e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    13ec:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    13f0:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    13f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13f8:	50435f54 	subpl	r5, r3, r4, asr pc
    13fc:	6f635f55 	svcvs	0x00635f55
    1400:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1404:	63373561 	teqvs	r7, #406847488	; 0x18400000
    1408:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    140c:	33356178 	teqcc	r5, #120, 2
    1410:	53414200 	movtpl	r4, #4608	; 0x1200
    1414:	52415f45 	subpl	r5, r1, #276	; 0x114
    1418:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    141c:	41425f4d 	cmpmi	r2, sp, asr #30
    1420:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    1424:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1428:	50435f54 	subpl	r5, r3, r4, asr pc
    142c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1430:	3031386d 	eorscc	r3, r1, sp, ror #16
    1434:	52415400 	subpl	r5, r1, #0, 8
    1438:	5f544547 	svcpl	0x00544547
    143c:	5f555043 	svcpl	0x00555043
    1440:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    1444:	41003165 	tstmi	r0, r5, ror #2
    1448:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    144c:	415f5343 	cmpmi	pc, r3, asr #6
    1450:	53435041 	movtpl	r5, #12353	; 0x3041
    1454:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    1458:	0054584d 	subseq	r5, r4, sp, asr #16
    145c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1460:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1464:	00305f48 	eorseq	r5, r0, r8, asr #30
    1468:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    146c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1470:	00325f48 	eorseq	r5, r2, r8, asr #30
    1474:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1478:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    147c:	00335f48 	eorseq	r5, r3, r8, asr #30
    1480:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1484:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1488:	00345f48 	eorseq	r5, r4, r8, asr #30
    148c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1490:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1494:	00365f48 	eorseq	r5, r6, r8, asr #30
    1498:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    149c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    14a0:	00375f48 	eorseq	r5, r7, r8, asr #30
    14a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14ac:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    14b0:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    14b4:	73690065 	cmnvc	r9, #101	; 0x65
    14b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    14bc:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    14c0:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    14c4:	41540073 	cmpmi	r4, r3, ror r0
    14c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    14d4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    14d8:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    14dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    14e0:	50435f54 	subpl	r5, r3, r4, asr pc
    14e4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    14e8:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    14ec:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    14f0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    14f4:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    14f8:	52415400 	subpl	r5, r1, #0, 8
    14fc:	5f544547 	svcpl	0x00544547
    1500:	5f555043 	svcpl	0x00555043
    1504:	316d7261 	cmncc	sp, r1, ror #4
    1508:	6a363731 	bvs	d8f1d4 <__bss_end+0xd85868>
    150c:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1510:	5f617369 	svcpl	0x00617369
    1514:	5f746962 	svcpl	0x00746962
    1518:	76706676 			; <UNDEFINED> instruction: 0x76706676
    151c:	52410032 	subpl	r0, r1, #50	; 0x32
    1520:	43505f4d 	cmpmi	r0, #308	; 0x134
    1524:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    1528:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    152c:	4154004e 	cmpmi	r4, lr, asr #32
    1530:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1534:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1538:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    153c:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    1540:	5f455341 	svcpl	0x00455341
    1544:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1548:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    154c:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1550:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1554:	5f6d7366 	svcpl	0x006d7366
    1558:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    155c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1560:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1564:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1568:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    156c:	63657073 	cmnvs	r5, #115	; 0x73
    1570:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1574:	73676e69 	cmnvc	r7, #1680	; 0x690
    1578:	61736900 	cmnvs	r3, r0, lsl #18
    157c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1580:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1584:	635f5f00 	cmpvs	pc, #0, 30
    1588:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1590 <shift+0x1590>
    158c:	41006261 	tstmi	r0, r1, ror #4
    1590:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1594:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1598:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    159c:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    15a0:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    15a4:	52410065 	subpl	r0, r1, #101	; 0x65
    15a8:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    15ac:	4d524100 	ldfmie	f4, [r2, #-0]
    15b0:	0053565f 	subseq	r5, r3, pc, asr r6
    15b4:	5f4d5241 	svcpl	0x004d5241
    15b8:	61004547 	tstvs	r0, r7, asr #10
    15bc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 15c4 <shift+0x15c4>
    15c0:	5f656e75 	svcpl	0x00656e75
    15c4:	6f727473 	svcvs	0x00727473
    15c8:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    15cc:	6f63006d 	svcvs	0x0063006d
    15d0:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    15d4:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    15d8:	0074616f 	rsbseq	r6, r4, pc, ror #2
    15dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15e4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    15e8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15ec:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    15f0:	52415400 	subpl	r5, r1, #0, 8
    15f4:	5f544547 	svcpl	0x00544547
    15f8:	5f555043 	svcpl	0x00555043
    15fc:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1600:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1604:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1608:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    160c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1610:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1614:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1618:	4d524100 	ldfmie	f4, [r2, #-0]
    161c:	0054475f 	subseq	r4, r4, pc, asr r7
    1620:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1624:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1628:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    162c:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    1630:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    1634:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    1638:	2f2e2e2f 	svccs	0x002e2e2f
    163c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1640:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1644:	2f2e2e2f 	svccs	0x002e2e2f
    1648:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    164c:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 14c8 <shift+0x14c8>
    1650:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1654:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1658:	52415400 	subpl	r5, r1, #0, 8
    165c:	5f544547 	svcpl	0x00544547
    1660:	5f555043 	svcpl	0x00555043
    1664:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1668:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    166c:	41420066 	cmpmi	r2, r6, rrx
    1670:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1674:	5f484352 	svcpl	0x00484352
    1678:	004d4537 	subeq	r4, sp, r7, lsr r5
    167c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1680:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1684:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1688:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    168c:	32316178 	eorscc	r6, r1, #120, 2
    1690:	73616800 	cmnvc	r1, #0, 16
    1694:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1698:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    169c:	5f455341 	svcpl	0x00455341
    16a0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    16a4:	5a4b365f 	bpl	12cf028 <__bss_end+0x12c56bc>
    16a8:	61736900 	cmnvs	r3, r0, lsl #18
    16ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16b0:	72610073 	rsbvc	r0, r1, #115	; 0x73
    16b4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    16b8:	615f6863 	cmpvs	pc, r3, ror #16
    16bc:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    16c0:	76696477 			; <UNDEFINED> instruction: 0x76696477
    16c4:	6d726100 	ldfvse	f6, [r2, #-0]
    16c8:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    16cc:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    16d0:	73690063 	cmnvc	r9, #99	; 0x63
    16d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16d8:	70665f74 	rsbvc	r5, r6, r4, ror pc
    16dc:	47003631 	smladxmi	r0, r1, r6, r3
    16e0:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    16e4:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    16e8:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    16ec:	31303220 	teqcc	r0, r0, lsr #4
    16f0:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    16f4:	72282035 	eorvc	r2, r8, #53	; 0x35
    16f8:	61656c65 	cmnvs	r5, r5, ror #24
    16fc:	20296573 	eorcs	r6, r9, r3, ror r5
    1700:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1704:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1708:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    170c:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1710:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1714:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1718:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    171c:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1720:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    1724:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1728:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    172c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1730:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1734:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1738:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    173c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1740:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1744:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1748:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    174c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1750:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1754:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1758:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    175c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1760:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1764:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1768:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    176c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1770:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1774:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 15e4 <shift+0x15e4>
    1778:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    177c:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1780:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1784:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1788:	6f6e662d 	svcvs	0x006e662d
    178c:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1790:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1794:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1798:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    179c:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    17a0:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    17a4:	006e6564 	rsbeq	r6, lr, r4, ror #10
    17a8:	5f4d5241 	svcpl	0x004d5241
    17ac:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    17b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    17b4:	615f7469 	cmpvs	pc, r9, ror #8
    17b8:	00766964 	rsbseq	r6, r6, r4, ror #18
    17bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17c4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    17c8:	31316d72 	teqcc	r1, r2, ror sp
    17cc:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    17d0:	52415400 	subpl	r5, r1, #0, 8
    17d4:	5f544547 	svcpl	0x00544547
    17d8:	5f555043 	svcpl	0x00555043
    17dc:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    17e0:	52415400 	subpl	r5, r1, #0, 8
    17e4:	5f544547 	svcpl	0x00544547
    17e8:	5f555043 	svcpl	0x00555043
    17ec:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    17f0:	52415400 	subpl	r5, r1, #0, 8
    17f4:	5f544547 	svcpl	0x00544547
    17f8:	5f555043 	svcpl	0x00555043
    17fc:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1800:	72610036 	rsbvc	r0, r1, #54	; 0x36
    1804:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1808:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    180c:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1810:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1814:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1818:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    181c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1820:	00346d78 	eorseq	r6, r4, r8, ror sp
    1824:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1828:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    182c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1830:	30316d72 	eorscc	r6, r1, r2, ror sp
    1834:	41540065 	cmpmi	r4, r5, rrx
    1838:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    183c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1840:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1844:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1848:	72610037 	rsbvc	r0, r1, #55	; 0x37
    184c:	6f635f6d 	svcvs	0x00635f6d
    1850:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
    1854:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1858:	5f4d5241 	svcpl	0x004d5241
    185c:	5f534350 	svcpl	0x00534350
    1860:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1864:	73690053 	cmnvc	r9, #83	; 0x53
    1868:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    186c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1870:	5f38766d 	svcpl	0x0038766d
    1874:	41420032 	cmpmi	r2, r2, lsr r0
    1878:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    187c:	5f484352 	svcpl	0x00484352
    1880:	54004d33 	strpl	r4, [r0], #-3379	; 0xfffff2cd
    1884:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1888:	50435f54 	subpl	r5, r3, r4, asr pc
    188c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1890:	3031376d 	eorscc	r3, r1, sp, ror #14
    1894:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1898:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    189c:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    18a0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    18a4:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    18a8:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    18ac:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    18b0:	00737469 	rsbseq	r7, r3, r9, ror #8
    18b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18bc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    18c0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18c4:	70306d78 	eorsvc	r6, r0, r8, ror sp
    18c8:	7373756c 	cmnvc	r3, #108, 10	; 0x1b000000
    18cc:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    18d0:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    18d4:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    18d8:	52415400 	subpl	r5, r1, #0, 8
    18dc:	5f544547 	svcpl	0x00544547
    18e0:	5f555043 	svcpl	0x00555043
    18e4:	6e797865 	cdpvs	8, 7, cr7, cr9, cr5, {3}
    18e8:	316d736f 	cmncc	sp, pc, ror #6
    18ec:	52415400 	subpl	r5, r1, #0, 8
    18f0:	5f544547 	svcpl	0x00544547
    18f4:	5f555043 	svcpl	0x00555043
    18f8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18fc:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    1900:	73690032 	cmnvc	r9, #50	; 0x32
    1904:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1908:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    190c:	70007669 	andvc	r7, r0, r9, ror #12
    1910:	65666572 	strbvs	r6, [r6, #-1394]!	; 0xfffffa8e
    1914:	656e5f72 	strbvs	r5, [lr, #-3954]!	; 0xfffff08e
    1918:	665f6e6f 	ldrbvs	r6, [pc], -pc, ror #28
    191c:	365f726f 	ldrbcc	r7, [pc], -pc, ror #4
    1920:	74696234 	strbtvc	r6, [r9], #-564	; 0xfffffdcc
    1924:	73690073 	cmnvc	r9, #115	; 0x73
    1928:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    192c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1930:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    1934:	4154006c 	cmpmi	r4, ip, rrx
    1938:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    193c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1940:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1944:	61786574 	cmnvs	r8, r4, ror r5
    1948:	54003233 	strpl	r3, [r0], #-563	; 0xfffffdcd
    194c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1950:	50435f54 	subpl	r5, r3, r4, asr pc
    1954:	6f635f55 	svcvs	0x00635f55
    1958:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    195c:	00353361 	eorseq	r3, r5, r1, ror #6
    1960:	5f617369 	svcpl	0x00617369
    1964:	5f746962 	svcpl	0x00746962
    1968:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    196c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1970:	736e7500 	cmnvc	lr, #0, 10
    1974:	76636570 			; <UNDEFINED> instruction: 0x76636570
    1978:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    197c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1980:	52415400 	subpl	r5, r1, #0, 8
    1984:	5f544547 	svcpl	0x00544547
    1988:	5f555043 	svcpl	0x00555043
    198c:	316d7261 	cmncc	sp, r1, ror #4
    1990:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1994:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    1998:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    199c:	50435f54 	subpl	r5, r3, r4, asr pc
    19a0:	61665f55 	cmnvs	r6, r5, asr pc
    19a4:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    19a8:	41540065 	cmpmi	r4, r5, rrx
    19ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19b8:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    19bc:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    19c0:	5f455341 	svcpl	0x00455341
    19c4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    19c8:	0054345f 	subseq	r3, r4, pc, asr r4
    19cc:	5f617369 	svcpl	0x00617369
    19d0:	5f746962 	svcpl	0x00746962
    19d4:	70797263 	rsbsvc	r7, r9, r3, ror #4
    19d8:	61006f74 	tstvs	r0, r4, ror pc
    19dc:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    19e0:	5f736765 	svcpl	0x00736765
    19e4:	735f6e69 	cmpvc	pc, #1680	; 0x690
    19e8:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    19ec:	0065636e 	rsbeq	r6, r5, lr, ror #6
    19f0:	5f617369 	svcpl	0x00617369
    19f4:	5f746962 	svcpl	0x00746962
    19f8:	42006273 	andmi	r6, r0, #805306375	; 0x30000007
    19fc:	5f455341 	svcpl	0x00455341
    1a00:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a04:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1a08:	61736900 	cmnvs	r3, r0, lsl #18
    1a0c:	6165665f 	cmnvs	r5, pc, asr r6
    1a10:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1a14:	61736900 	cmnvs	r3, r0, lsl #18
    1a18:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a1c:	616d735f 	cmnvs	sp, pc, asr r3
    1a20:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1a24:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1a28:	616c5f6d 	cmnvs	ip, sp, ror #30
    1a2c:	6f5f676e 	svcvs	0x005f676e
    1a30:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1a34:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    1a38:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    1a3c:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1a40:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    1a44:	5f736574 	svcpl	0x00736574
    1a48:	6b6f6f68 	blvs	1bdd7f0 <__bss_end+0x1bd3e84>
    1a4c:	61736900 	cmnvs	r3, r0, lsl #18
    1a50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a54:	5f70665f 	svcpl	0x0070665f
    1a58:	00323364 	eorseq	r3, r2, r4, ror #6
    1a5c:	5f4d5241 	svcpl	0x004d5241
    1a60:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    1a64:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a68:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1a6c:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    1a70:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a74:	50435f54 	subpl	r5, r3, r4, asr pc
    1a78:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a7c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1a80:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    1a84:	6f727000 	svcvs	0x00727000
    1a88:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1a8c:	745f726f 	ldrbvc	r7, [pc], #-623	; 1a94 <shift+0x1a94>
    1a90:	00657079 	rsbeq	r7, r5, r9, ror r0
    1a94:	5f6c6c61 	svcpl	0x006c6c61
    1a98:	73757066 	cmnvc	r5, #102	; 0x66
    1a9c:	6d726100 	ldfvse	f6, [r2, #-0]
    1aa0:	7363705f 	cmnvc	r3, #95	; 0x5f
    1aa4:	53414200 	movtpl	r4, #4608	; 0x1200
    1aa8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1aac:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1271 <shift+0x1271>
    1ab0:	72610054 	rsbvc	r0, r1, #84	; 0x54
    1ab4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ab8:	74346863 	ldrtvc	r6, [r4], #-2147	; 0xfffff79d
    1abc:	52415400 	subpl	r5, r1, #0, 8
    1ac0:	5f544547 	svcpl	0x00544547
    1ac4:	5f555043 	svcpl	0x00555043
    1ac8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1acc:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1ad0:	726f6336 	rsbvc	r6, pc, #-671088640	; 0xd8000000
    1ad4:	61786574 	cmnvs	r8, r4, ror r5
    1ad8:	61003535 	tstvs	r0, r5, lsr r5
    1adc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1ae4 <shift+0x1ae4>
    1ae0:	5f656e75 	svcpl	0x00656e75
    1ae4:	66756277 			; <UNDEFINED> instruction: 0x66756277
    1ae8:	61746800 	cmnvs	r4, r0, lsl #16
    1aec:	61685f62 	cmnvs	r8, r2, ror #30
    1af0:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    1af4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1af8:	715f7469 	cmpvc	pc, r9, ror #8
    1afc:	6b726975 	blvs	1c9c0d8 <__bss_end+0x1c9276c>
    1b00:	5f6f6e5f 	svcpl	0x006f6e5f
    1b04:	616c6f76 	smcvs	50934	; 0xc6f6
    1b08:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1b0c:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1b10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b18:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b1c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b20:	00306d78 	eorseq	r6, r0, r8, ror sp
    1b24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b2c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b34:	00316d78 	eorseq	r6, r1, r8, ror sp
    1b38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b40:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b44:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b48:	00336d78 	eorseq	r6, r3, r8, ror sp
    1b4c:	5f617369 	svcpl	0x00617369
    1b50:	5f746962 	svcpl	0x00746962
    1b54:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1b58:	00315f38 	eorseq	r5, r1, r8, lsr pc
    1b5c:	5f6d7261 	svcpl	0x006d7261
    1b60:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b64:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    1b68:	73690065 	cmnvc	r9, #101	; 0x65
    1b6c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b70:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1b74:	5f38766d 	svcpl	0x0038766d
    1b78:	73690033 	cmnvc	r9, #51	; 0x33
    1b7c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b80:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1b84:	5f38766d 	svcpl	0x0038766d
    1b88:	73690034 	cmnvc	r9, #52	; 0x34
    1b8c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b90:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1b94:	5f38766d 	svcpl	0x0038766d
    1b98:	41540035 	cmpmi	r4, r5, lsr r0
    1b9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ba0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ba4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ba8:	61786574 	cmnvs	r8, r4, ror r5
    1bac:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    1bb0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bb4:	50435f54 	subpl	r5, r3, r4, asr pc
    1bb8:	6f635f55 	svcvs	0x00635f55
    1bbc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1bc0:	00353561 	eorseq	r3, r5, r1, ror #10
    1bc4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bc8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bcc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bd0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bd4:	37356178 			; <UNDEFINED> instruction: 0x37356178
    1bd8:	52415400 	subpl	r5, r1, #0, 8
    1bdc:	5f544547 	svcpl	0x00544547
    1be0:	5f555043 	svcpl	0x00555043
    1be4:	6f63706d 	svcvs	0x0063706d
    1be8:	54006572 	strpl	r6, [r0], #-1394	; 0xfffffa8e
    1bec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bf0:	50435f54 	subpl	r5, r3, r4, asr pc
    1bf4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1bf8:	6f6e5f6d 	svcvs	0x006e5f6d
    1bfc:	6100656e 	tstvs	r0, lr, ror #10
    1c00:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c04:	5f686372 	svcpl	0x00686372
    1c08:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    1c0c:	52415400 	subpl	r5, r1, #0, 8
    1c10:	5f544547 	svcpl	0x00544547
    1c14:	5f555043 	svcpl	0x00555043
    1c18:	316d7261 	cmncc	sp, r1, ror #4
    1c1c:	65363230 	ldrvs	r3, [r6, #-560]!	; 0xfffffdd0
    1c20:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    1c24:	5f455341 	svcpl	0x00455341
    1c28:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c2c:	004a365f 	subeq	r3, sl, pc, asr r6
    1c30:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c34:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c38:	4b365f48 	blmi	d99960 <__bss_end+0xd8fff4>
    1c3c:	53414200 	movtpl	r4, #4608	; 0x1200
    1c40:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c44:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1c48:	7369004d 	cmnvc	r9, #77	; 0x4d
    1c4c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c50:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1c54:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1c58:	52415400 	subpl	r5, r1, #0, 8
    1c5c:	5f544547 	svcpl	0x00544547
    1c60:	5f555043 	svcpl	0x00555043
    1c64:	316d7261 	cmncc	sp, r1, ror #4
    1c68:	6a363331 	bvs	d8e934 <__bss_end+0xd84fc8>
    1c6c:	41007366 	tstmi	r0, r6, ror #6
    1c70:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1c74:	52410053 	subpl	r0, r1, #83	; 0x53
    1c78:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    1c7c:	53414200 	movtpl	r4, #4608	; 0x1200
    1c80:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c84:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1c88:	4154005a 	cmpmi	r4, sl, asr r0
    1c8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c94:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c98:	61786574 	cmnvs	r8, r4, ror r5
    1c9c:	6f633537 	svcvs	0x00633537
    1ca0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ca4:	00353561 	eorseq	r3, r5, r1, ror #10
    1ca8:	5f4d5241 	svcpl	0x004d5241
    1cac:	5f534350 	svcpl	0x00534350
    1cb0:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1cb4:	46565f53 	usaxmi	r5, r6, r3
    1cb8:	41540050 	cmpmi	r4, r0, asr r0
    1cbc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cc0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cc4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1cc8:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1ccc:	61736900 	cmnvs	r3, r0, lsl #18
    1cd0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cd4:	6f656e5f 	svcvs	0x00656e5f
    1cd8:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    1cdc:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1ce0:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    1ce4:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    1ce8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cec:	615f7469 	cmpvs	pc, r9, ror #8
    1cf0:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1cf4:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    1cf8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cfc:	50435f54 	subpl	r5, r3, r4, asr pc
    1d00:	61665f55 	cmnvs	r6, r5, asr pc
    1d04:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    1d08:	41540065 	cmpmi	r4, r5, rrx
    1d0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d14:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    1d18:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    1d1c:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    1d20:	61746800 	cmnvs	r4, r0, lsl #16
    1d24:	61685f62 	cmnvs	r8, r2, ror #30
    1d28:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    1d2c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1d30:	61007265 	tstvs	r0, r5, ror #4
    1d34:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1d3c <shift+0x1d3c>
    1d38:	5f656e75 	svcpl	0x00656e75
    1d3c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d40:	615f7865 	cmpvs	pc, r5, ror #16
    1d44:	73690039 	cmnvc	r9, #57	; 0x39
    1d48:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d4c:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1d50:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1d54:	41540032 	cmpmi	r4, r2, lsr r0
    1d58:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d5c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d60:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d64:	61786574 	cmnvs	r8, r4, ror r5
    1d68:	6f633237 	svcvs	0x00633237
    1d6c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d70:	00333561 	eorseq	r3, r3, r1, ror #10
    1d74:	5f617369 	svcpl	0x00617369
    1d78:	5f746962 	svcpl	0x00746962
    1d7c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1d80:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    1d84:	5f455341 	svcpl	0x00455341
    1d88:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d8c:	0041375f 	subeq	r3, r1, pc, asr r7
    1d90:	5f617369 	svcpl	0x00617369
    1d94:	5f746962 	svcpl	0x00746962
    1d98:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1d9c:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1da0:	5f6d7261 	svcpl	0x006d7261
    1da4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1da8:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1dac:	6f6e5f65 	svcvs	0x006e5f65
    1db0:	41006564 	tstmi	r0, r4, ror #10
    1db4:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 1c74 <shift+0x1c74>
    1db8:	72610049 	rsbvc	r0, r1, #73	; 0x49
    1dbc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1dc0:	6b366863 	blvs	d9bf54 <__bss_end+0xd925e8>
    1dc4:	6d726100 	ldfvse	f6, [r2, #-0]
    1dc8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1dcc:	006d3668 	rsbeq	r3, sp, r8, ror #12
    1dd0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1dd4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1dd8:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    1ddc:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    1de0:	6f63706f 	svcvs	0x0063706f
    1de4:	5f746e75 	svcpl	0x00746e75
    1de8:	00626174 	rsbeq	r6, r2, r4, ror r1
    1dec:	5f617369 	svcpl	0x00617369
    1df0:	5f746962 	svcpl	0x00746962
    1df4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1df8:	52415400 	subpl	r5, r1, #0, 8
    1dfc:	5f544547 	svcpl	0x00544547
    1e00:	5f555043 	svcpl	0x00555043
    1e04:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e08:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1e0c:	41540033 	cmpmi	r4, r3, lsr r0
    1e10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e18:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1e1c:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    1e20:	00613776 	rsbeq	r3, r1, r6, ror r7
    1e24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e2c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e34:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1e38:	6d726100 	ldfvse	f6, [r2, #-0]
    1e3c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e40:	6f6e5f68 	svcvs	0x006e5f68
    1e44:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1cd0 <shift+0x1cd0>
    1e48:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1e4c:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1e50:	53414200 	movtpl	r4, #4608	; 0x1200
    1e54:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e58:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1e5c:	73690041 	cmnvc	r9, #65	; 0x41
    1e60:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e64:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1e68:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1e6c:	53414200 	movtpl	r4, #4608	; 0x1200
    1e70:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e74:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1e78:	41540052 	cmpmi	r4, r2, asr r0
    1e7c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e80:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e84:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e88:	61786574 	cmnvs	r8, r4, ror r5
    1e8c:	6f633337 	svcvs	0x00633337
    1e90:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e94:	00353361 	eorseq	r3, r5, r1, ror #6
    1e98:	5f4d5241 	svcpl	0x004d5241
    1e9c:	6100564e 	tstvs	r0, lr, asr #12
    1ea0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ea4:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1ea8:	6d726100 	ldfvse	f6, [r2, #-0]
    1eac:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1eb0:	61003668 	tstvs	r0, r8, ror #12
    1eb4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1eb8:	37686372 			; <UNDEFINED> instruction: 0x37686372
    1ebc:	6d726100 	ldfvse	f6, [r2, #-0]
    1ec0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ec4:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    1ec8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1ecc:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1ed0:	6100656c 	tstvs	r0, ip, ror #10
    1ed4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1edc <shift+0x1edc>
    1ed8:	5f656e75 	svcpl	0x00656e75
    1edc:	61637378 	smcvs	14136	; 0x3738
    1ee0:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    1ee4:	6e696b61 	vnmulvs.f64	d22, d9, d17
    1ee8:	6f635f67 	svcvs	0x00635f67
    1eec:	5f74736e 	svcpl	0x0074736e
    1ef0:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    1ef4:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    1ef8:	5f626d75 	svcpl	0x00626d75
    1efc:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    1f00:	6169765f 	cmnvs	r9, pc, asr r6
    1f04:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    1f08:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    1f0c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f10:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f14:	00357670 	eorseq	r7, r5, r0, ror r6
    1f18:	5f617369 	svcpl	0x00617369
    1f1c:	5f746962 	svcpl	0x00746962
    1f20:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1f24:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    1f28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f30:	6f635f55 	svcvs	0x00635f55
    1f34:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f38:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    1f3c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f40:	50435f54 	subpl	r5, r3, r4, asr pc
    1f44:	6f635f55 	svcvs	0x00635f55
    1f48:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f4c:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    1f50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f54:	50435f54 	subpl	r5, r3, r4, asr pc
    1f58:	6f635f55 	svcvs	0x00635f55
    1f5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f60:	41003961 	tstmi	r0, r1, ror #18
    1f64:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1f68:	415f5343 	cmpmi	pc, r3, asr #6
    1f6c:	00534350 	subseq	r4, r3, r0, asr r3
    1f70:	5f4d5241 	svcpl	0x004d5241
    1f74:	5f534350 	svcpl	0x00534350
    1f78:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    1f7c:	6f630053 	svcvs	0x00630053
    1f80:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1f84:	6f642078 	svcvs	0x00642078
    1f88:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1f8c:	52415400 	subpl	r5, r1, #0, 8
    1f90:	5f544547 	svcpl	0x00544547
    1f94:	5f555043 	svcpl	0x00555043
    1f98:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f9c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1fa0:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1fa4:	61786574 	cmnvs	r8, r4, ror r5
    1fa8:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    1fac:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fb0:	50435f54 	subpl	r5, r3, r4, asr pc
    1fb4:	6f635f55 	svcvs	0x00635f55
    1fb8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1fbc:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1fc0:	61007375 	tstvs	r0, r5, ror r3
    1fc4:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1fc8:	73690063 	cmnvc	r9, #99	; 0x63
    1fcc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fd0:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1fd4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1fd8:	6f645f00 	svcvs	0x00645f00
    1fdc:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 1b76 <shift+0x1b76>
    1fe0:	745f6573 	ldrbvc	r6, [pc], #-1395	; 1fe8 <shift+0x1fe8>
    1fe4:	5f656572 	svcpl	0x00656572
    1fe8:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    1fec:	4154005f 	cmpmi	r4, pc, asr r0
    1ff0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ff4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ff8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ffc:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    2000:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    2004:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2008:	50435f54 	subpl	r5, r3, r4, asr pc
    200c:	6f635f55 	svcvs	0x00635f55
    2010:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2014:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    2018:	5f657361 	svcpl	0x00657361
    201c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2020:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    2024:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    2028:	6d726100 	ldfvse	f6, [r2, #-0]
    202c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2030:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    2034:	41540063 	cmpmi	r4, r3, rrx
    2038:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    203c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2040:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2044:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2048:	616d7331 	cmnvs	sp, r1, lsr r3
    204c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2050:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2054:	6100796c 	tstvs	r0, ip, ror #18
    2058:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    205c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    2060:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    2064:	73690063 	cmnvc	r9, #99	; 0x63
    2068:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    206c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2070:	00323363 	eorseq	r3, r2, r3, ror #6
    2074:	5f4d5241 	svcpl	0x004d5241
    2078:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    207c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2080:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2084:	33767066 	cmncc	r6, #102	; 0x66
    2088:	61736900 	cmnvs	r3, r0, lsl #18
    208c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2090:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2094:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    2098:	5f455341 	svcpl	0x00455341
    209c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    20a0:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    20a4:	53414200 	movtpl	r4, #4608	; 0x1200
    20a8:	52415f45 	subpl	r5, r1, #276	; 0x114
    20ac:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    20b0:	414d5f4d 	cmpmi	sp, sp, asr #30
    20b4:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    20b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20bc:	50435f54 	subpl	r5, r3, r4, asr pc
    20c0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    20c4:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    20c8:	4100696d 	tstmi	r0, sp, ror #18
    20cc:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    20d0:	4142004c 	cmpmi	r2, ip, asr #32
    20d4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    20d8:	5f484352 	svcpl	0x00484352
    20dc:	61004d37 	tstvs	r0, r7, lsr sp
    20e0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 20e8 <shift+0x20e8>
    20e4:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    20e8:	616c5f74 	smcvs	50676	; 0xc5f4
    20ec:	006c6562 	rsbeq	r6, ip, r2, ror #10
    20f0:	5f6d7261 	svcpl	0x006d7261
    20f4:	67726174 			; <UNDEFINED> instruction: 0x67726174
    20f8:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    20fc:	006e736e 	rsbeq	r7, lr, lr, ror #6
    2100:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2104:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2108:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    210c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2110:	00347278 	eorseq	r7, r4, r8, ror r2
    2114:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2118:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    211c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2120:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2124:	00357278 	eorseq	r7, r5, r8, ror r2
    2128:	47524154 			; <UNDEFINED> instruction: 0x47524154
    212c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2130:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2134:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2138:	00377278 	eorseq	r7, r7, r8, ror r2
    213c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2140:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2144:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2148:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    214c:	00387278 	eorseq	r7, r8, r8, ror r2
    2150:	5f617369 	svcpl	0x00617369
    2154:	5f746962 	svcpl	0x00746962
    2158:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    215c:	61736900 	cmnvs	r3, r0, lsl #18
    2160:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2164:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2168:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    216c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2170:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2174:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2178:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    217c:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2180:	5f617369 	svcpl	0x00617369
    2184:	5f746962 	svcpl	0x00746962
    2188:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    218c:	73690034 	cmnvc	r9, #52	; 0x34
    2190:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2194:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2198:	0036766d 	eorseq	r7, r6, sp, ror #12
    219c:	5f617369 	svcpl	0x00617369
    21a0:	5f746962 	svcpl	0x00746962
    21a4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    21a8:	73690037 	cmnvc	r9, #55	; 0x37
    21ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21b0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    21b4:	0038766d 	eorseq	r7, r8, sp, ror #12
    21b8:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    21bc:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    21c0:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    21c4:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    21c8:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    21cc:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    21d0:	00657079 	rsbeq	r7, r5, r9, ror r0
    21d4:	5f617369 	svcpl	0x00617369
    21d8:	5f746962 	svcpl	0x00746962
    21dc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    21e0:	00657435 	rsbeq	r7, r5, r5, lsr r4
    21e4:	5f6d7261 	svcpl	0x006d7261
    21e8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    21ec:	6d726100 	ldfvse	f6, [r2, #-0]
    21f0:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    21f4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    21f8:	6f777265 	svcvs	0x00777265
    21fc:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    2200:	5f636e75 	svcpl	0x00636e75
    2204:	00727470 	rsbseq	r7, r2, r0, ror r4
    2208:	47524154 			; <UNDEFINED> instruction: 0x47524154
    220c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2210:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2214:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2218:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    221c:	5f626174 	svcpl	0x00626174
    2220:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    2224:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2228:	50435f54 	subpl	r5, r3, r4, asr pc
    222c:	61665f55 	cmnvs	r6, r5, asr pc
    2230:	00363235 	eorseq	r3, r6, r5, lsr r2
    2234:	5f6d7261 	svcpl	0x006d7261
    2238:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    223c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2240:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2244:	76696477 			; <UNDEFINED> instruction: 0x76696477
    2248:	61746800 	cmnvs	r4, r0, lsl #16
    224c:	71655f62 	cmnvc	r5, r2, ror #30
    2250:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2254:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2258:	6d726100 	ldfvse	f6, [r2, #-0]
    225c:	6369705f 	cmnvs	r9, #95	; 0x5f
    2260:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2264:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2268:	41540072 	cmpmi	r4, r2, ror r0
    226c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2270:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2274:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2278:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    227c:	616d7330 	cmnvs	sp, r0, lsr r3
    2280:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2284:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2288:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    228c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2290:	50435f54 	subpl	r5, r3, r4, asr pc
    2294:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2298:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    229c:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    22a0:	73690070 	cmnvc	r9, #112	; 0x70
    22a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22a8:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    22ac:	5f6b7269 	svcpl	0x006b7269
    22b0:	5f336d63 	svcpl	0x00336d63
    22b4:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    22b8:	4d524100 	ldfmie	f4, [r2, #-0]
    22bc:	0043435f 	subeq	r4, r3, pc, asr r3
    22c0:	5f6d7261 	svcpl	0x006d7261
    22c4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    22c8:	00325f38 	eorseq	r5, r2, r8, lsr pc
    22cc:	5f6d7261 	svcpl	0x006d7261
    22d0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    22d4:	00335f38 	eorseq	r5, r3, r8, lsr pc
    22d8:	5f6d7261 	svcpl	0x006d7261
    22dc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    22e0:	00345f38 	eorseq	r5, r4, r8, lsr pc
    22e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22ec:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    22f0:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    22f4:	52410036 	subpl	r0, r1, #54	; 0x36
    22f8:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    22fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2300:	3170665f 	cmncc	r0, pc, asr r6
    2304:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    2308:	61007473 	tstvs	r0, r3, ror r4
    230c:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    2310:	5f657361 	svcpl	0x00657361
    2314:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2318:	52415400 	subpl	r5, r1, #0, 8
    231c:	5f544547 	svcpl	0x00544547
    2320:	5f555043 	svcpl	0x00555043
    2324:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2328:	31617865 	cmncc	r1, r5, ror #16
    232c:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    2330:	61786574 	cmnvs	r8, r4, ror r5
    2334:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2338:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    233c:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    2340:	4154006d 	cmpmi	r4, sp, rrx
    2344:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2348:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    234c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2350:	61786574 	cmnvs	r8, r4, ror r5
    2354:	61003237 	tstvs	r0, r7, lsr r2
    2358:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    235c:	645f7363 	ldrbvs	r7, [pc], #-867	; 2364 <shift+0x2364>
    2360:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    2364:	4100746c 	tstmi	r0, ip, ror #8
    2368:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    236c:	415f5343 	cmpmi	pc, r3, asr #6
    2370:	53435041 	movtpl	r5, #12353	; 0x3041
    2374:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    2378:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    237c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2380:	50435f54 	subpl	r5, r3, r4, asr pc
    2384:	6f635f55 	svcvs	0x00635f55
    2388:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    238c:	00353761 	eorseq	r3, r5, r1, ror #14
    2390:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2394:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2398:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    239c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    23a0:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    23a4:	6d726100 	ldfvse	f6, [r2, #-0]
    23a8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23ac:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    23b0:	31626d75 	smccc	9941	; 0x26d5
    23b4:	6d726100 	ldfvse	f6, [r2, #-0]
    23b8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23bc:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    23c0:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    23c4:	52415400 	subpl	r5, r1, #0, 8
    23c8:	5f544547 	svcpl	0x00544547
    23cc:	5f555043 	svcpl	0x00555043
    23d0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    23d4:	61007478 	tstvs	r0, r8, ror r4
    23d8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23dc:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    23e0:	73690074 	cmnvc	r9, #116	; 0x74
    23e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    23e8:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    23ec:	6d726100 	ldfvse	f6, [r2, #-0]
    23f0:	5f646c5f 	svcpl	0x00646c5f
    23f4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    23f8:	72610064 	rsbvc	r0, r1, #100	; 0x64
    23fc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2400:	5f386863 	svcpl	0x00386863
    2404:	Address 0x0000000000002404 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9fc4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346ec4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9fe4>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9314>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa014>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346f14>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa034>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346f34>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa054>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346f54>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa074>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346f74>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa094>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346f94>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa0b4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346fb4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa0d4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346fd4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa0ec>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa10c>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa13c>
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
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa168>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347068>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a0 	andeq	r8, r0, r0, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa188>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347088>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082cc 	andeq	r8, r0, ip, asr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa1a8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3470a8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082e8 	andeq	r8, r0, r8, ror #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa1c8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3470c8>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	0000832c 	andeq	r8, r0, ip, lsr #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa1e8>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x3470e8>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000837c 	andeq	r8, r0, ip, ror r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa208>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347108>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083cc 	andeq	r8, r0, ip, asr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa228>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347128>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa248>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347148>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008448 	andeq	r8, r0, r8, asr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa268>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347168>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000848c 	andeq	r8, r0, ip, lsl #9
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa288>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347188>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084dc 	ldrdeq	r8, [r0], -ip
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa2a8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3471a8>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008530 	andeq	r8, r0, r0, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa2c8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3471c8>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000856c 	andeq	r8, r0, ip, ror #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa2e8>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3471e8>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085a8 	andeq	r8, r0, r8, lsr #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa308>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347208>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085e4 	andeq	r8, r0, r4, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa328>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347228>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008620 	andeq	r8, r0, r0, lsr #12
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa348>
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
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa378>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008844 	andeq	r8, r0, r4, asr #16
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa398>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347298>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088e0 	andeq	r8, r0, r0, ror #17
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa3b8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3472b8>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	000089a0 	andeq	r8, r0, r0, lsr #19
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa3d8>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3472d8>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008a4c 	andeq	r8, r0, ip, asr #20
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa3f8>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x3472f8>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008aa0 	andeq	r8, r0, r0, lsr #21
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa418>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347318>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b08 	andeq	r8, r0, r8, lsl #22
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa438>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347338>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008b88 	andeq	r8, r0, r8, lsl #23
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa458>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347358>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008bf4 	strdeq	r8, [r0], -r4
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa478>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa498>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x347398>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	000090f8 	strdeq	r9, [r0], -r8
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa4bc>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	000091cc 	andeq	r9, r0, ip, asr #3
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa4dc>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x3473dc>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	00009208 	andeq	r9, r0, r8, lsl #4
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa4fc>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x3473fc>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	00009248 	andeq	r9, r0, r8, asr #4
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa51c>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	00009278 	andeq	r9, r0, r8, ror r2
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa53c>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	0000959c 	muleq	r0, ip, r5
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa560>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x347460>
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
