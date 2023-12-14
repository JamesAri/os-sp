
./tilt_task:     file format elf32-littlearm


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
    805c:	00009a28 	andeq	r9, r0, r8, lsr #20
    8060:	00009a38 	andeq	r9, r0, r8, lsr sl

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
    81cc:	00009a25 	andeq	r9, r0, r5, lsr #20
    81d0:	00009a25 	andeq	r9, r0, r5, lsr #20

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
    8224:	00009a25 	andeq	r9, r0, r5, lsr #20
    8228:	00009a25 	andeq	r9, r0, r5, lsr #20

0000822c <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:15
 * 
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:16
	char state = '0';
    8240:	e3a03030 	mov	r3, #48	; 0x30
    8244:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:17
	char oldstate = '0';
    8248:	e3a03030 	mov	r3, #48	; 0x30
    824c:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:19

	uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f009c 	ldr	r0, [pc, #156]	; 82f8 <main+0xcc>
    8258:	eb000047 	bl	837c <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:27
	NGPIO_Interrupt_Type irtype;
	
	//irtype = NGPIO_Interrupt_Type::Rising_Edge;
	//ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

	irtype = NGPIO_Interrupt_Type::Falling_Edge;
    8260:	e3a03001 	mov	r3, #1
    8264:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:28
	ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8268:	e24b3018 	sub	r3, fp, #24
    826c:	e1a02003 	mov	r2, r3
    8270:	e3a01002 	mov	r1, #2
    8274:	e51b000c 	ldr	r0, [fp, #-12]
    8278:	eb000083 	bl	848c <_Z5ioctlj16NIOCtl_OperationPv>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:30

	uint32_t logpipe = pipe("log", 32);
    827c:	e3a01020 	mov	r1, #32
    8280:	e59f0074 	ldr	r0, [pc, #116]	; 82fc <main+0xd0>
    8284:	eb00010a 	bl	86b4 <_Z4pipePKcj>
    8288:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:34

	while (true)
	{
		wait(tiltsensor_file, 0x800);
    828c:	e3e02001 	mvn	r2, #1
    8290:	e3a01b02 	mov	r1, #2048	; 0x800
    8294:	e51b000c 	ldr	r0, [fp, #-12]
    8298:	eb0000a0 	bl	8520 <_Z4waitjjj>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:39

		// "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
		//sleep(0x100, Deadline_Unchanged);

		read(tiltsensor_file, &state, 1);
    829c:	e24b3011 	sub	r3, fp, #17
    82a0:	e3a02001 	mov	r2, #1
    82a4:	e1a01003 	mov	r1, r3
    82a8:	e51b000c 	ldr	r0, [fp, #-12]
    82ac:	eb000043 	bl	83c0 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:43

		//if (state != oldstate)
		{
			if (state == '0')
    82b0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82b4:	e3530030 	cmp	r3, #48	; 0x30
    82b8:	1a000004 	bne	82d0 <main+0xa4>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:45
			{
				write(logpipe, "Tilt UP", 7);
    82bc:	e3a02007 	mov	r2, #7
    82c0:	e59f1038 	ldr	r1, [pc, #56]	; 8300 <main+0xd4>
    82c4:	e51b0010 	ldr	r0, [fp, #-16]
    82c8:	eb000050 	bl	8410 <_Z5writejPKcj>
    82cc:	ea000003 	b	82e0 <main+0xb4>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:49
			}
			else
			{
				write(logpipe, "Tilt DOWN", 10);
    82d0:	e3a0200a 	mov	r2, #10
    82d4:	e59f1028 	ldr	r1, [pc, #40]	; 8304 <main+0xd8>
    82d8:	e51b0010 	ldr	r0, [fp, #-16]
    82dc:	eb00004b 	bl	8410 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:51
			}
			oldstate = state;
    82e0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82e4:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:54
		}

		sleep(0x1000, Indefinite/*0x100*/);
    82e8:	e3e01000 	mvn	r1, #0
    82ec:	e3a00a01 	mov	r0, #4096	; 0x1000
    82f0:	eb00009e 	bl	8570 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/tilt_task/main.cpp:34
		wait(tiltsensor_file, 0x800);
    82f4:	eaffffe4 	b	828c <main+0x60>
    82f8:	000099b0 			; <UNDEFINED> instruction: 0x000099b0
    82fc:	000099bc 			; <UNDEFINED> instruction: 0x000099bc
    8300:	000099c0 	andeq	r9, r0, r0, asr #19
    8304:	000099c8 	andeq	r9, r0, r8, asr #19

00008308 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8308:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    830c:	e28db000 	add	fp, sp, #0
    8310:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8314:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8318:	e1a03000 	mov	r3, r0
    831c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8320:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8324:	e1a00003 	mov	r0, r3
    8328:	e28bd000 	add	sp, fp, #0
    832c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8330:	e12fff1e 	bx	lr

00008334 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8334:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8338:	e28db000 	add	fp, sp, #0
    833c:	e24dd00c 	sub	sp, sp, #12
    8340:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8344:	e51b3008 	ldr	r3, [fp, #-8]
    8348:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    834c:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    8350:	e320f000 	nop	{0}
    8354:	e28bd000 	add	sp, fp, #0
    8358:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    835c:	e12fff1e 	bx	lr

00008360 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8360:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8364:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8368:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    836c:	e320f000 	nop	{0}
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd014 	sub	sp, sp, #20
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8390:	e51b3010 	ldr	r3, [fp, #-16]
    8394:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8398:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    839c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83a0:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83a4:	e1a03000 	mov	r3, r0
    83a8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    83ac:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    83b0:	e1a00003 	mov	r0, r3
    83b4:	e28bd000 	add	sp, fp, #0
    83b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83bc:	e12fff1e 	bx	lr

000083c0 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c4:	e28db000 	add	fp, sp, #0
    83c8:	e24dd01c 	sub	sp, sp, #28
    83cc:	e50b0010 	str	r0, [fp, #-16]
    83d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83d4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83d8:	e51b3010 	ldr	r3, [fp, #-16]
    83dc:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    83e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83e4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    83e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83ec:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83f0:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83f4:	e1a03000 	mov	r3, r0
    83f8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    83fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    8400:	e1a00003 	mov	r0, r3
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8410:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8414:	e28db000 	add	fp, sp, #0
    8418:	e24dd01c 	sub	sp, sp, #28
    841c:	e50b0010 	str	r0, [fp, #-16]
    8420:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8424:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8428:	e51b3010 	ldr	r3, [fp, #-16]
    842c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8430:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8434:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8438:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    843c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8440:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8444:	e1a03000 	mov	r3, r0
    8448:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    844c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    8450:	e1a00003 	mov	r0, r3
    8454:	e28bd000 	add	sp, fp, #0
    8458:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    845c:	e12fff1e 	bx	lr

00008460 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8460:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8464:	e28db000 	add	fp, sp, #0
    8468:	e24dd00c 	sub	sp, sp, #12
    846c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8470:	e51b3008 	ldr	r3, [fp, #-8]
    8474:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8478:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    847c:	e320f000 	nop	{0}
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84bc:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8500:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd01c 	sub	sp, sp, #28
    852c:	e50b0010 	str	r0, [fp, #-16]
    8530:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8534:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8548:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    854c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8550:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8554:	e1a03000 	mov	r3, r0
    8558:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    855c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    8560:	e1a00003 	mov	r0, r3
    8564:	e28bd000 	add	sp, fp, #0
    8568:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    856c:	e12fff1e 	bx	lr

00008570 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8570:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8574:	e28db000 	add	fp, sp, #0
    8578:	e24dd014 	sub	sp, sp, #20
    857c:	e50b0010 	str	r0, [fp, #-16]
    8580:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8584:	e51b3010 	ldr	r3, [fp, #-16]
    8588:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    858c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8590:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8594:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8598:	e1a03000 	mov	r3, r0
    859c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85a0:	e51b3008 	ldr	r3, [fp, #-8]
    85a4:	e3530000 	cmp	r3, #0
    85a8:	13a03001 	movne	r3, #1
    85ac:	03a03000 	moveq	r3, #0
    85b0:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    85b4:	e1a00003 	mov	r0, r3
    85b8:	e28bd000 	add	sp, fp, #0
    85bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c0:	e12fff1e 	bx	lr

000085c4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85c8:	e28db000 	add	fp, sp, #0
    85cc:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    85d0:	e3a03000 	mov	r3, #0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85d8:	e3a03000 	mov	r3, #0
    85dc:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    85e0:	e24b300c 	sub	r3, fp, #12
    85e4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    85e8:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    85ec:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    85f0:	e1a00003 	mov	r0, r3
    85f4:	e28bd000 	add	sp, fp, #0
    85f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85fc:	e12fff1e 	bx	lr

00008600 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8600:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8604:	e28db000 	add	fp, sp, #0
    8608:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    860c:	e3a03001 	mov	r3, #1
    8610:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8614:	e3a03001 	mov	r3, #1
    8618:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    861c:	e24b300c 	sub	r3, fp, #12
    8620:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8624:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8628:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    862c:	e1a00003 	mov	r0, r3
    8630:	e28bd000 	add	sp, fp, #0
    8634:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8638:	e12fff1e 	bx	lr

0000863c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    863c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8640:	e28db000 	add	fp, sp, #0
    8644:	e24dd014 	sub	sp, sp, #20
    8648:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    864c:	e3a03000 	mov	r3, #0
    8650:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8654:	e3a03000 	mov	r3, #0
    8658:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    865c:	e24b3010 	sub	r3, fp, #16
    8660:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8664:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    8668:	e320f000 	nop	{0}
    866c:	e28bd000 	add	sp, fp, #0
    8670:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8674:	e12fff1e 	bx	lr

00008678 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8678:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    867c:	e28db000 	add	fp, sp, #0
    8680:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8684:	e3a03001 	mov	r3, #1
    8688:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    868c:	e3a03001 	mov	r3, #1
    8690:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8694:	e24b300c 	sub	r3, fp, #12
    8698:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    869c:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86a0:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    86a4:	e1a00003 	mov	r0, r3
    86a8:	e28bd000 	add	sp, fp, #0
    86ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b0:	e12fff1e 	bx	lr

000086b4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86b4:	e92d4800 	push	{fp, lr}
    86b8:	e28db004 	add	fp, sp, #4
    86bc:	e24dd050 	sub	sp, sp, #80	; 0x50
    86c0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86c4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86c8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86cc:	e3a0200a 	mov	r2, #10
    86d0:	e59f1088 	ldr	r1, [pc, #136]	; 8760 <_Z4pipePKcj+0xac>
    86d4:	e1a00003 	mov	r0, r3
    86d8:	eb0000a5 	bl	8974 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86dc:	e24b3048 	sub	r3, fp, #72	; 0x48
    86e0:	e283300a 	add	r3, r3, #10
    86e4:	e3a02035 	mov	r2, #53	; 0x35
    86e8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86ec:	e1a00003 	mov	r0, r3
    86f0:	eb00009f 	bl	8974 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    86f4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    86f8:	eb0000f8 	bl	8ae0 <_Z6strlenPKc>
    86fc:	e1a03000 	mov	r3, r0
    8700:	e283300a 	add	r3, r3, #10
    8704:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8708:	e51b3008 	ldr	r3, [fp, #-8]
    870c:	e2832001 	add	r2, r3, #1
    8710:	e50b2008 	str	r2, [fp, #-8]
    8714:	e24b2004 	sub	r2, fp, #4
    8718:	e0823003 	add	r3, r2, r3
    871c:	e3a02023 	mov	r2, #35	; 0x23
    8720:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8724:	e24b2048 	sub	r2, fp, #72	; 0x48
    8728:	e51b3008 	ldr	r3, [fp, #-8]
    872c:	e0823003 	add	r3, r2, r3
    8730:	e3a0200a 	mov	r2, #10
    8734:	e1a01003 	mov	r1, r3
    8738:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    873c:	eb000008 	bl	8764 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8740:	e24b3048 	sub	r3, fp, #72	; 0x48
    8744:	e3a01002 	mov	r1, #2
    8748:	e1a00003 	mov	r0, r3
    874c:	ebffff0a 	bl	837c <_Z4openPKc15NFile_Open_Mode>
    8750:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    8754:	e1a00003 	mov	r0, r3
    8758:	e24bd004 	sub	sp, fp, #4
    875c:	e8bd8800 	pop	{fp, pc}
    8760:	00009a04 	andeq	r9, r0, r4, lsl #20

00008764 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8764:	e92d4800 	push	{fp, lr}
    8768:	e28db004 	add	fp, sp, #4
    876c:	e24dd020 	sub	sp, sp, #32
    8770:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8774:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8778:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    877c:	e3a03000 	mov	r3, #0
    8780:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8784:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8788:	e3530000 	cmp	r3, #0
    878c:	0a000014 	beq	87e4 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8790:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8794:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8798:	e1a00003 	mov	r0, r3
    879c:	eb000462 	bl	992c <__aeabi_uidivmod>
    87a0:	e1a03001 	mov	r3, r1
    87a4:	e1a01003 	mov	r1, r3
    87a8:	e51b3008 	ldr	r3, [fp, #-8]
    87ac:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87b0:	e0823003 	add	r3, r2, r3
    87b4:	e59f2118 	ldr	r2, [pc, #280]	; 88d4 <_Z4itoajPcj+0x170>
    87b8:	e7d22001 	ldrb	r2, [r2, r1]
    87bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87c0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87c4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87c8:	eb0003dc 	bl	9740 <__udivsi3>
    87cc:	e1a03000 	mov	r3, r0
    87d0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    87d4:	e51b3008 	ldr	r3, [fp, #-8]
    87d8:	e2833001 	add	r3, r3, #1
    87dc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    87e0:	eaffffe7 	b	8784 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    87e4:	e51b3008 	ldr	r3, [fp, #-8]
    87e8:	e3530000 	cmp	r3, #0
    87ec:	1a000007 	bne	8810 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    87f0:	e51b3008 	ldr	r3, [fp, #-8]
    87f4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f8:	e0823003 	add	r3, r2, r3
    87fc:	e3a02030 	mov	r2, #48	; 0x30
    8800:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8804:	e51b3008 	ldr	r3, [fp, #-8]
    8808:	e2833001 	add	r3, r3, #1
    880c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8818:	e0823003 	add	r3, r2, r3
    881c:	e3a02000 	mov	r2, #0
    8820:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8824:	e51b3008 	ldr	r3, [fp, #-8]
    8828:	e2433001 	sub	r3, r3, #1
    882c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8830:	e3a03000 	mov	r3, #0
    8834:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8838:	e51b3008 	ldr	r3, [fp, #-8]
    883c:	e1a02fa3 	lsr	r2, r3, #31
    8840:	e0823003 	add	r3, r2, r3
    8844:	e1a030c3 	asr	r3, r3, #1
    8848:	e1a02003 	mov	r2, r3
    884c:	e51b300c 	ldr	r3, [fp, #-12]
    8850:	e1530002 	cmp	r3, r2
    8854:	ca00001b 	bgt	88c8 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8858:	e51b2008 	ldr	r2, [fp, #-8]
    885c:	e51b300c 	ldr	r3, [fp, #-12]
    8860:	e0423003 	sub	r3, r2, r3
    8864:	e1a02003 	mov	r2, r3
    8868:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    886c:	e0833002 	add	r3, r3, r2
    8870:	e5d33000 	ldrb	r3, [r3]
    8874:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8878:	e51b300c 	ldr	r3, [fp, #-12]
    887c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8880:	e0822003 	add	r2, r2, r3
    8884:	e51b1008 	ldr	r1, [fp, #-8]
    8888:	e51b300c 	ldr	r3, [fp, #-12]
    888c:	e0413003 	sub	r3, r1, r3
    8890:	e1a01003 	mov	r1, r3
    8894:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8898:	e0833001 	add	r3, r3, r1
    889c:	e5d22000 	ldrb	r2, [r2]
    88a0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88a4:	e51b300c 	ldr	r3, [fp, #-12]
    88a8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88ac:	e0823003 	add	r3, r2, r3
    88b0:	e55b200d 	ldrb	r2, [fp, #-13]
    88b4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88b8:	e51b300c 	ldr	r3, [fp, #-12]
    88bc:	e2833001 	add	r3, r3, #1
    88c0:	e50b300c 	str	r3, [fp, #-12]
    88c4:	eaffffdb 	b	8838 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    88c8:	e320f000 	nop	{0}
    88cc:	e24bd004 	sub	sp, fp, #4
    88d0:	e8bd8800 	pop	{fp, pc}
    88d4:	00009a14 	andeq	r9, r0, r4, lsl sl

000088d8 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    88d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88dc:	e28db000 	add	fp, sp, #0
    88e0:	e24dd014 	sub	sp, sp, #20
    88e4:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    88e8:	e3a03000 	mov	r3, #0
    88ec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    88f0:	e51b3010 	ldr	r3, [fp, #-16]
    88f4:	e5d33000 	ldrb	r3, [r3]
    88f8:	e3530000 	cmp	r3, #0
    88fc:	0a000017 	beq	8960 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8900:	e51b2008 	ldr	r2, [fp, #-8]
    8904:	e1a03002 	mov	r3, r2
    8908:	e1a03103 	lsl	r3, r3, #2
    890c:	e0833002 	add	r3, r3, r2
    8910:	e1a03083 	lsl	r3, r3, #1
    8914:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8918:	e51b3010 	ldr	r3, [fp, #-16]
    891c:	e5d33000 	ldrb	r3, [r3]
    8920:	e3530039 	cmp	r3, #57	; 0x39
    8924:	8a00000d 	bhi	8960 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8928:	e51b3010 	ldr	r3, [fp, #-16]
    892c:	e5d33000 	ldrb	r3, [r3]
    8930:	e353002f 	cmp	r3, #47	; 0x2f
    8934:	9a000009 	bls	8960 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8938:	e51b3010 	ldr	r3, [fp, #-16]
    893c:	e5d33000 	ldrb	r3, [r3]
    8940:	e2433030 	sub	r3, r3, #48	; 0x30
    8944:	e51b2008 	ldr	r2, [fp, #-8]
    8948:	e0823003 	add	r3, r2, r3
    894c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8950:	e51b3010 	ldr	r3, [fp, #-16]
    8954:	e2833001 	add	r3, r3, #1
    8958:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    895c:	eaffffe3 	b	88f0 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8960:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8964:	e1a00003 	mov	r0, r3
    8968:	e28bd000 	add	sp, fp, #0
    896c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8970:	e12fff1e 	bx	lr

00008974 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8974:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8978:	e28db000 	add	fp, sp, #0
    897c:	e24dd01c 	sub	sp, sp, #28
    8980:	e50b0010 	str	r0, [fp, #-16]
    8984:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8988:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    898c:	e3a03000 	mov	r3, #0
    8990:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8994:	e51b2008 	ldr	r2, [fp, #-8]
    8998:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    899c:	e1520003 	cmp	r2, r3
    89a0:	aa000011 	bge	89ec <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89a4:	e51b3008 	ldr	r3, [fp, #-8]
    89a8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89ac:	e0823003 	add	r3, r2, r3
    89b0:	e5d33000 	ldrb	r3, [r3]
    89b4:	e3530000 	cmp	r3, #0
    89b8:	0a00000b 	beq	89ec <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89bc:	e51b3008 	ldr	r3, [fp, #-8]
    89c0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89c4:	e0822003 	add	r2, r2, r3
    89c8:	e51b3008 	ldr	r3, [fp, #-8]
    89cc:	e51b1010 	ldr	r1, [fp, #-16]
    89d0:	e0813003 	add	r3, r1, r3
    89d4:	e5d22000 	ldrb	r2, [r2]
    89d8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    89dc:	e51b3008 	ldr	r3, [fp, #-8]
    89e0:	e2833001 	add	r3, r3, #1
    89e4:	e50b3008 	str	r3, [fp, #-8]
    89e8:	eaffffe9 	b	8994 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    89ec:	e51b2008 	ldr	r2, [fp, #-8]
    89f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89f4:	e1520003 	cmp	r2, r3
    89f8:	aa000008 	bge	8a20 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    89fc:	e51b3008 	ldr	r3, [fp, #-8]
    8a00:	e51b2010 	ldr	r2, [fp, #-16]
    8a04:	e0823003 	add	r3, r2, r3
    8a08:	e3a02000 	mov	r2, #0
    8a0c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a10:	e51b3008 	ldr	r3, [fp, #-8]
    8a14:	e2833001 	add	r3, r3, #1
    8a18:	e50b3008 	str	r3, [fp, #-8]
    8a1c:	eafffff2 	b	89ec <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a20:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8a24:	e1a00003 	mov	r0, r3
    8a28:	e28bd000 	add	sp, fp, #0
    8a2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a30:	e12fff1e 	bx	lr

00008a34 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a38:	e28db000 	add	fp, sp, #0
    8a3c:	e24dd01c 	sub	sp, sp, #28
    8a40:	e50b0010 	str	r0, [fp, #-16]
    8a44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a48:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a4c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a50:	e2432001 	sub	r2, r3, #1
    8a54:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a58:	e3530000 	cmp	r3, #0
    8a5c:	c3a03001 	movgt	r3, #1
    8a60:	d3a03000 	movle	r3, #0
    8a64:	e6ef3073 	uxtb	r3, r3
    8a68:	e3530000 	cmp	r3, #0
    8a6c:	0a000016 	beq	8acc <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8a70:	e51b3010 	ldr	r3, [fp, #-16]
    8a74:	e2832001 	add	r2, r3, #1
    8a78:	e50b2010 	str	r2, [fp, #-16]
    8a7c:	e5d33000 	ldrb	r3, [r3]
    8a80:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8a84:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a88:	e2832001 	add	r2, r3, #1
    8a8c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8a90:	e5d33000 	ldrb	r3, [r3]
    8a94:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8a98:	e55b2005 	ldrb	r2, [fp, #-5]
    8a9c:	e55b3006 	ldrb	r3, [fp, #-6]
    8aa0:	e1520003 	cmp	r2, r3
    8aa4:	0a000003 	beq	8ab8 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8aa8:	e55b2005 	ldrb	r2, [fp, #-5]
    8aac:	e55b3006 	ldrb	r3, [fp, #-6]
    8ab0:	e0423003 	sub	r3, r2, r3
    8ab4:	ea000005 	b	8ad0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ab8:	e55b3005 	ldrb	r3, [fp, #-5]
    8abc:	e3530000 	cmp	r3, #0
    8ac0:	1affffe1 	bne	8a4c <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8ac4:	e3a03000 	mov	r3, #0
    8ac8:	ea000000 	b	8ad0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8acc:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8ad0:	e1a00003 	mov	r0, r3
    8ad4:	e28bd000 	add	sp, fp, #0
    8ad8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8adc:	e12fff1e 	bx	lr

00008ae0 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ae0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ae4:	e28db000 	add	fp, sp, #0
    8ae8:	e24dd014 	sub	sp, sp, #20
    8aec:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8af0:	e3a03000 	mov	r3, #0
    8af4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8af8:	e51b3008 	ldr	r3, [fp, #-8]
    8afc:	e51b2010 	ldr	r2, [fp, #-16]
    8b00:	e0823003 	add	r3, r2, r3
    8b04:	e5d33000 	ldrb	r3, [r3]
    8b08:	e3530000 	cmp	r3, #0
    8b0c:	0a000003 	beq	8b20 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b10:	e51b3008 	ldr	r3, [fp, #-8]
    8b14:	e2833001 	add	r3, r3, #1
    8b18:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b1c:	eafffff5 	b	8af8 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b20:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8b24:	e1a00003 	mov	r0, r3
    8b28:	e28bd000 	add	sp, fp, #0
    8b2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b30:	e12fff1e 	bx	lr

00008b34 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b38:	e28db000 	add	fp, sp, #0
    8b3c:	e24dd014 	sub	sp, sp, #20
    8b40:	e50b0010 	str	r0, [fp, #-16]
    8b44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b48:	e51b3010 	ldr	r3, [fp, #-16]
    8b4c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b50:	e3a03000 	mov	r3, #0
    8b54:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b58:	e51b2008 	ldr	r2, [fp, #-8]
    8b5c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b60:	e1520003 	cmp	r2, r3
    8b64:	aa000008 	bge	8b8c <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8b68:	e51b3008 	ldr	r3, [fp, #-8]
    8b6c:	e51b200c 	ldr	r2, [fp, #-12]
    8b70:	e0823003 	add	r3, r2, r3
    8b74:	e3a02000 	mov	r2, #0
    8b78:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8b7c:	e51b3008 	ldr	r3, [fp, #-8]
    8b80:	e2833001 	add	r3, r3, #1
    8b84:	e50b3008 	str	r3, [fp, #-8]
    8b88:	eafffff2 	b	8b58 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8b8c:	e320f000 	nop	{0}
    8b90:	e28bd000 	add	sp, fp, #0
    8b94:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b98:	e12fff1e 	bx	lr

00008b9c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8b9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ba0:	e28db000 	add	fp, sp, #0
    8ba4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8ba8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bac:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bb0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bb4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bb8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bbc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bc0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8bc4:	e3a03000 	mov	r3, #0
    8bc8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bcc:	e51b2008 	ldr	r2, [fp, #-8]
    8bd0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8bd4:	e1520003 	cmp	r2, r3
    8bd8:	aa00000b 	bge	8c0c <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8bdc:	e51b3008 	ldr	r3, [fp, #-8]
    8be0:	e51b200c 	ldr	r2, [fp, #-12]
    8be4:	e0822003 	add	r2, r2, r3
    8be8:	e51b3008 	ldr	r3, [fp, #-8]
    8bec:	e51b1010 	ldr	r1, [fp, #-16]
    8bf0:	e0813003 	add	r3, r1, r3
    8bf4:	e5d22000 	ldrb	r2, [r2]
    8bf8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8bfc:	e51b3008 	ldr	r3, [fp, #-8]
    8c00:	e2833001 	add	r3, r3, #1
    8c04:	e50b3008 	str	r3, [fp, #-8]
    8c08:	eaffffef 	b	8bcc <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8c0c:	e320f000 	nop	{0}
    8c10:	e28bd000 	add	sp, fp, #0
    8c14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c18:	e12fff1e 	bx	lr

00008c1c <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8c1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c20:	e28db000 	add	fp, sp, #0
    8c24:	e24dd014 	sub	sp, sp, #20
    8c28:	ed0b0a04 	vstr	s0, [fp, #-16]
    8c2c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8c30:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8c34:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8c38:	e3a03000 	mov	r3, #0
    8c3c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8c40:	e51b200c 	ldr	r2, [fp, #-12]
    8c44:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c48:	e1520003 	cmp	r2, r3
    8c4c:	2a000007 	bcs	8c70 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8c50:	ed1b7a02 	vldr	s14, [fp, #-8]
    8c54:	ed5b7a04 	vldr	s15, [fp, #-16]
    8c58:	ee677a27 	vmul.f32	s15, s14, s15
    8c5c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8c60:	e51b300c 	ldr	r3, [fp, #-12]
    8c64:	e2833001 	add	r3, r3, #1
    8c68:	e50b300c 	str	r3, [fp, #-12]
    8c6c:	eafffff3 	b	8c40 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8c70:	e51b3008 	ldr	r3, [fp, #-8]
    8c74:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8c78:	eeb00a67 	vmov.f32	s0, s15
    8c7c:	e28bd000 	add	sp, fp, #0
    8c80:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c84:	e12fff1e 	bx	lr

00008c88 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8c88:	e92d4800 	push	{fp, lr}
    8c8c:	e28db004 	add	fp, sp, #4
    8c90:	e24dd018 	sub	sp, sp, #24
    8c94:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8c98:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8c9c:	ebffff8f 	bl	8ae0 <_Z6strlenPKc>
    8ca0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8ca4:	e3a03000 	mov	r3, #0
    8ca8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8cac:	e51b300c 	ldr	r3, [fp, #-12]
    8cb0:	e1a02fa3 	lsr	r2, r3, #31
    8cb4:	e0823003 	add	r3, r2, r3
    8cb8:	e1a030c3 	asr	r3, r3, #1
    8cbc:	e1a02003 	mov	r2, r3
    8cc0:	e51b3008 	ldr	r3, [fp, #-8]
    8cc4:	e1530002 	cmp	r3, r2
    8cc8:	aa00001c 	bge	8d40 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8ccc:	e51b3008 	ldr	r3, [fp, #-8]
    8cd0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8cd4:	e0823003 	add	r3, r2, r3
    8cd8:	e5d33000 	ldrb	r3, [r3]
    8cdc:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8ce0:	e51b200c 	ldr	r2, [fp, #-12]
    8ce4:	e51b3008 	ldr	r3, [fp, #-8]
    8ce8:	e0423003 	sub	r3, r2, r3
    8cec:	e2433001 	sub	r3, r3, #1
    8cf0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8cf4:	e0822003 	add	r2, r2, r3
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8d00:	e0813003 	add	r3, r1, r3
    8d04:	e5d22000 	ldrb	r2, [r2]
    8d08:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8d0c:	e51b200c 	ldr	r2, [fp, #-12]
    8d10:	e51b3008 	ldr	r3, [fp, #-8]
    8d14:	e0423003 	sub	r3, r2, r3
    8d18:	e2433001 	sub	r3, r3, #1
    8d1c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8d20:	e0823003 	add	r3, r2, r3
    8d24:	e51b2010 	ldr	r2, [fp, #-16]
    8d28:	e6ef2072 	uxtb	r2, r2
    8d2c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8d30:	e51b3008 	ldr	r3, [fp, #-8]
    8d34:	e2833001 	add	r3, r3, #1
    8d38:	e50b3008 	str	r3, [fp, #-8]
    8d3c:	eaffffda 	b	8cac <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8d40:	e320f000 	nop	{0}
    8d44:	e24bd004 	sub	sp, fp, #4
    8d48:	e8bd8800 	pop	{fp, pc}

00008d4c <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8d4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d50:	e28db000 	add	fp, sp, #0
    8d54:	e24dd01c 	sub	sp, sp, #28
    8d58:	ed0b0a04 	vstr	s0, [fp, #-16]
    8d5c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8d60:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8d64:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8d68:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d6c:	ed9f7af3 	vldr	s14, [pc, #972]	; 9140 <_Z11split_floatfRjS_Ri+0x3f4>
    8d70:	eef47ac7 	vcmpe.f32	s15, s14
    8d74:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d78:	ba000053 	blt	8ecc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8d7c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d80:	ed9f7aef 	vldr	s14, [pc, #956]	; 9144 <_Z11split_floatfRjS_Ri+0x3f8>
    8d84:	eef47ac7 	vcmpe.f32	s15, s14
    8d88:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8d8c:	ba000008 	blt	8db4 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8d90:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d94:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9148 <_Z11split_floatfRjS_Ri+0x3fc>
    8d98:	ee677a87 	vmul.f32	s15, s15, s14
    8d9c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8da0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8da4:	e5933000 	ldr	r3, [r3]
    8da8:	e2832020 	add	r2, r3, #32
    8dac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8db0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    8db4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8db8:	ed9f7ae3 	vldr	s14, [pc, #908]	; 914c <_Z11split_floatfRjS_Ri+0x400>
    8dbc:	eef47ac7 	vcmpe.f32	s15, s14
    8dc0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dc4:	ba000008 	blt	8dec <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8dc8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8dcc:	ed9f7adf 	vldr	s14, [pc, #892]	; 9150 <_Z11split_floatfRjS_Ri+0x404>
    8dd0:	ee677a87 	vmul.f32	s15, s15, s14
    8dd4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8dd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ddc:	e5933000 	ldr	r3, [r3]
    8de0:	e2832010 	add	r2, r3, #16
    8de4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8de8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    8dec:	ed5b7a04 	vldr	s15, [fp, #-16]
    8df0:	ed9f7ad7 	vldr	s14, [pc, #860]	; 9154 <_Z11split_floatfRjS_Ri+0x408>
    8df4:	eef47ac7 	vcmpe.f32	s15, s14
    8df8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dfc:	ba000008 	blt	8e24 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    8e00:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e04:	ed9f7ad3 	vldr	s14, [pc, #844]	; 9158 <_Z11split_floatfRjS_Ri+0x40c>
    8e08:	ee677a87 	vmul.f32	s15, s15, s14
    8e0c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e10:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e14:	e5933000 	ldr	r3, [r3]
    8e18:	e2832008 	add	r2, r3, #8
    8e1c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e20:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    8e24:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e28:	ed9f7acb 	vldr	s14, [pc, #812]	; 915c <_Z11split_floatfRjS_Ri+0x410>
    8e2c:	eef47ac7 	vcmpe.f32	s15, s14
    8e30:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e34:	ba000008 	blt	8e5c <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    8e38:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e3c:	ed9f7ac7 	vldr	s14, [pc, #796]	; 9160 <_Z11split_floatfRjS_Ri+0x414>
    8e40:	ee677a87 	vmul.f32	s15, s15, s14
    8e44:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e48:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e4c:	e5933000 	ldr	r3, [r3]
    8e50:	e2832004 	add	r2, r3, #4
    8e54:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e58:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    8e5c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e60:	ed9f7abf 	vldr	s14, [pc, #764]	; 9164 <_Z11split_floatfRjS_Ri+0x418>
    8e64:	eef47ac7 	vcmpe.f32	s15, s14
    8e68:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e6c:	ba000008 	blt	8e94 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    8e70:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e74:	ed9f7abb 	vldr	s14, [pc, #748]	; 9168 <_Z11split_floatfRjS_Ri+0x41c>
    8e78:	ee677a87 	vmul.f32	s15, s15, s14
    8e7c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e84:	e5933000 	ldr	r3, [r3]
    8e88:	e2832002 	add	r2, r3, #2
    8e8c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e90:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    8e94:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e98:	ed9f7aa8 	vldr	s14, [pc, #672]	; 9140 <_Z11split_floatfRjS_Ri+0x3f4>
    8e9c:	eef47ac7 	vcmpe.f32	s15, s14
    8ea0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ea4:	ba000008 	blt	8ecc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    8ea8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8eac:	ed9f7aae 	vldr	s14, [pc, #696]	; 916c <_Z11split_floatfRjS_Ri+0x420>
    8eb0:	ee677a87 	vmul.f32	s15, s15, s14
    8eb4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8eb8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ebc:	e5933000 	ldr	r3, [r3]
    8ec0:	e2832001 	add	r2, r3, #1
    8ec4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ec8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    8ecc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ed0:	eef57ac0 	vcmpe.f32	s15, #0.0
    8ed4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ed8:	da000058 	ble	9040 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    8edc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ee0:	ed9f7aa2 	vldr	s14, [pc, #648]	; 9170 <_Z11split_floatfRjS_Ri+0x424>
    8ee4:	eef47ac7 	vcmpe.f32	s15, s14
    8ee8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8eec:	8a000053 	bhi	9040 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    8ef0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ef4:	ed9f7a9e 	vldr	s14, [pc, #632]	; 9174 <_Z11split_floatfRjS_Ri+0x428>
    8ef8:	eef47ac7 	vcmpe.f32	s15, s14
    8efc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f00:	5a000008 	bpl	8f28 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    8f04:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f08:	ed9f7a8d 	vldr	s14, [pc, #564]	; 9144 <_Z11split_floatfRjS_Ri+0x3f8>
    8f0c:	ee677a87 	vmul.f32	s15, s15, s14
    8f10:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f14:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f18:	e5933000 	ldr	r3, [r3]
    8f1c:	e2432020 	sub	r2, r3, #32
    8f20:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f24:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    8f28:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f2c:	ed9f7a91 	vldr	s14, [pc, #580]	; 9178 <_Z11split_floatfRjS_Ri+0x42c>
    8f30:	eef47ac7 	vcmpe.f32	s15, s14
    8f34:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f38:	5a000008 	bpl	8f60 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    8f3c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f40:	ed9f7a81 	vldr	s14, [pc, #516]	; 914c <_Z11split_floatfRjS_Ri+0x400>
    8f44:	ee677a87 	vmul.f32	s15, s15, s14
    8f48:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f4c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f50:	e5933000 	ldr	r3, [r3]
    8f54:	e2432010 	sub	r2, r3, #16
    8f58:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f5c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    8f60:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f64:	ed9f7a84 	vldr	s14, [pc, #528]	; 917c <_Z11split_floatfRjS_Ri+0x430>
    8f68:	eef47ac7 	vcmpe.f32	s15, s14
    8f6c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f70:	5a000008 	bpl	8f98 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    8f74:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f78:	ed9f7a75 	vldr	s14, [pc, #468]	; 9154 <_Z11split_floatfRjS_Ri+0x408>
    8f7c:	ee677a87 	vmul.f32	s15, s15, s14
    8f80:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f84:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f88:	e5933000 	ldr	r3, [r3]
    8f8c:	e2432008 	sub	r2, r3, #8
    8f90:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f94:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    8f98:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f9c:	ed9f7a77 	vldr	s14, [pc, #476]	; 9180 <_Z11split_floatfRjS_Ri+0x434>
    8fa0:	eef47ac7 	vcmpe.f32	s15, s14
    8fa4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fa8:	5a000008 	bpl	8fd0 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    8fac:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fb0:	ed9f7a69 	vldr	s14, [pc, #420]	; 915c <_Z11split_floatfRjS_Ri+0x410>
    8fb4:	ee677a87 	vmul.f32	s15, s15, s14
    8fb8:	ed4b7a04 	vstr	s15, [fp, #-16]
    8fbc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fc0:	e5933000 	ldr	r3, [r3]
    8fc4:	e2432004 	sub	r2, r3, #4
    8fc8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fcc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    8fd0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fd4:	ed9f7a64 	vldr	s14, [pc, #400]	; 916c <_Z11split_floatfRjS_Ri+0x420>
    8fd8:	eef47ac7 	vcmpe.f32	s15, s14
    8fdc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fe0:	5a000008 	bpl	9008 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    8fe4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fe8:	ed9f7a5d 	vldr	s14, [pc, #372]	; 9164 <_Z11split_floatfRjS_Ri+0x418>
    8fec:	ee677a87 	vmul.f32	s15, s15, s14
    8ff0:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ff4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ff8:	e5933000 	ldr	r3, [r3]
    8ffc:	e2432002 	sub	r2, r3, #2
    9000:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9004:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    9008:	ed5b7a04 	vldr	s15, [fp, #-16]
    900c:	ed9f7a57 	vldr	s14, [pc, #348]	; 9170 <_Z11split_floatfRjS_Ri+0x424>
    9010:	eef47ac7 	vcmpe.f32	s15, s14
    9014:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9018:	5a000008 	bpl	9040 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    901c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9020:	ed9f7a46 	vldr	s14, [pc, #280]	; 9140 <_Z11split_floatfRjS_Ri+0x3f4>
    9024:	ee677a87 	vmul.f32	s15, s15, s14
    9028:	ed4b7a04 	vstr	s15, [fp, #-16]
    902c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9030:	e5933000 	ldr	r3, [r3]
    9034:	e2432001 	sub	r2, r3, #1
    9038:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    903c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    9040:	ed5b7a04 	vldr	s15, [fp, #-16]
    9044:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9048:	ee172a90 	vmov	r2, s15
    904c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9050:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    9054:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9058:	e5933000 	ldr	r3, [r3]
    905c:	ee073a90 	vmov	s15, r3
    9060:	eef87a67 	vcvt.f32.u32	s15, s15
    9064:	ed1b7a04 	vldr	s14, [fp, #-16]
    9068:	ee777a67 	vsub.f32	s15, s14, s15
    906c:	ed9f7a38 	vldr	s14, [pc, #224]	; 9154 <_Z11split_floatfRjS_Ri+0x408>
    9070:	ee677a87 	vmul.f32	s15, s15, s14
    9074:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    9078:	ed5b7a02 	vldr	s15, [fp, #-8]
    907c:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9080:	ee172a90 	vmov	r2, s15
    9084:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9088:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    908c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9090:	e5933000 	ldr	r3, [r3]
    9094:	ee073a90 	vmov	s15, r3
    9098:	eef87a67 	vcvt.f32.u32	s15, s15
    909c:	ed1b7a02 	vldr	s14, [fp, #-8]
    90a0:	ee777a67 	vsub.f32	s15, s14, s15
    90a4:	ed9f7a36 	vldr	s14, [pc, #216]	; 9184 <_Z11split_floatfRjS_Ri+0x438>
    90a8:	eef47ac7 	vcmpe.f32	s15, s14
    90ac:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90b0:	aa000000 	bge	90b8 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    90b4:	ea00001d 	b	9130 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    90b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90bc:	e5933000 	ldr	r3, [r3]
    90c0:	e2832001 	add	r2, r3, #1
    90c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90c8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    90cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90d0:	e5933000 	ldr	r3, [r3]
    90d4:	e59f20ac 	ldr	r2, [pc, #172]	; 9188 <_Z11split_floatfRjS_Ri+0x43c>
    90d8:	e1530002 	cmp	r3, r2
    90dc:	9a000013 	bls	9130 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    90e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90e4:	e3a02000 	mov	r2, #0
    90e8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    90ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    90f0:	e5933000 	ldr	r3, [r3]
    90f4:	e2832001 	add	r2, r3, #1
    90f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    90fc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    9100:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9104:	e5933000 	ldr	r3, [r3]
    9108:	e3530009 	cmp	r3, #9
    910c:	9a000007 	bls	9130 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    9110:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9114:	e3a02001 	mov	r2, #1
    9118:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    911c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9120:	e5933000 	ldr	r3, [r3]
    9124:	e2832001 	add	r2, r3, #1
    9128:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    912c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    9130:	e320f000 	nop	{0}
    9134:	e28bd000 	add	sp, fp, #0
    9138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    913c:	e12fff1e 	bx	lr
    9140:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9144:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9148:	0a4fb11f 	beq	13f55cc <__bss_end+0x13ebb94>
    914c:	5a0e1bca 	bpl	39007c <__bss_end+0x386644>
    9150:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    9154:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    9158:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    915c:	461c4000 	ldrmi	r4, [ip], -r0
    9160:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    9164:	42c80000 	sbcmi	r0, r8, #0
    9168:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    916c:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    9170:	3f800000 	svccc	0x00800000
    9174:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    9178:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    917c:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    9180:	3a83126f 	bcc	fe0cdb44 <__bss_end+0xfe0c410c>
    9184:	3f000000 	svccc	0x00000000
    9188:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

0000918c <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    918c:	e92d4800 	push	{fp, lr}
    9190:	e28db004 	add	fp, sp, #4
    9194:	e24dd018 	sub	sp, sp, #24
    9198:	e50b0010 	str	r0, [fp, #-16]
    919c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    91a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    91a4:	e3a03000 	mov	r3, #0
    91a8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    91ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91b0:	e2432001 	sub	r2, r3, #1
    91b4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    91b8:	e3530000 	cmp	r3, #0
    91bc:	c3a03001 	movgt	r3, #1
    91c0:	d3a03000 	movle	r3, #0
    91c4:	e6ef3073 	uxtb	r3, r3
    91c8:	e3530000 	cmp	r3, #0
    91cc:	0a000018 	beq	9234 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    91d0:	e51b1010 	ldr	r1, [fp, #-16]
    91d4:	e59f3080 	ldr	r3, [pc, #128]	; 925c <_Z23decimal_to_string_floatjPci+0xd0>
    91d8:	e0832193 	umull	r2, r3, r3, r1
    91dc:	e1a021a3 	lsr	r2, r3, #3
    91e0:	e1a03002 	mov	r3, r2
    91e4:	e1a03103 	lsl	r3, r3, #2
    91e8:	e0833002 	add	r3, r3, r2
    91ec:	e1a03083 	lsl	r3, r3, #1
    91f0:	e0412003 	sub	r2, r1, r3
    91f4:	e6ef2072 	uxtb	r2, r2
    91f8:	e51b3008 	ldr	r3, [fp, #-8]
    91fc:	e2831001 	add	r1, r3, #1
    9200:	e50b1008 	str	r1, [fp, #-8]
    9204:	e1a01003 	mov	r1, r3
    9208:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    920c:	e0833001 	add	r3, r3, r1
    9210:	e2822030 	add	r2, r2, #48	; 0x30
    9214:	e6ef2072 	uxtb	r2, r2
    9218:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    921c:	e51b3010 	ldr	r3, [fp, #-16]
    9220:	e59f2034 	ldr	r2, [pc, #52]	; 925c <_Z23decimal_to_string_floatjPci+0xd0>
    9224:	e0832392 	umull	r2, r3, r2, r3
    9228:	e1a031a3 	lsr	r3, r3, #3
    922c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9230:	eaffffdd 	b	91ac <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    9234:	e51b3008 	ldr	r3, [fp, #-8]
    9238:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    923c:	e0823003 	add	r3, r2, r3
    9240:	e3a02000 	mov	r2, #0
    9244:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9248:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    924c:	ebfffe8d 	bl	8c88 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    9250:	e320f000 	nop	{0}
    9254:	e24bd004 	sub	sp, fp, #4
    9258:	e8bd8800 	pop	{fp, pc}
    925c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00009260 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    9260:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9264:	e28db000 	add	fp, sp, #0
    9268:	e24dd00c 	sub	sp, sp, #12
    926c:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    9270:	ed1b7a02 	vldr	s14, [fp, #-8]
    9274:	ed5b7a02 	vldr	s15, [fp, #-8]
    9278:	eeb47a67 	vcmp.f32	s14, s15
    927c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9280:	13a03001 	movne	r3, #1
    9284:	03a03000 	moveq	r3, #0
    9288:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    928c:	e1a00003 	mov	r0, r3
    9290:	e28bd000 	add	sp, fp, #0
    9294:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9298:	e12fff1e 	bx	lr

0000929c <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    929c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    92a0:	e28db000 	add	fp, sp, #0
    92a4:	e24dd00c 	sub	sp, sp, #12
    92a8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    92ac:	ed5b7a02 	vldr	s15, [fp, #-8]
    92b0:	ed9f7a08 	vldr	s14, [pc, #32]	; 92d8 <_Z5isinff+0x3c>
    92b4:	eef47ac7 	vcmpe.f32	s15, s14
    92b8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92bc:	c3a03001 	movgt	r3, #1
    92c0:	d3a03000 	movle	r3, #0
    92c4:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    92c8:	e1a00003 	mov	r0, r3
    92cc:	e28bd000 	add	sp, fp, #0
    92d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92d4:	e12fff1e 	bx	lr
    92d8:	7f7fffff 	svcvc	0x007fffff

000092dc <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    92dc:	e92d4800 	push	{fp, lr}
    92e0:	e28db004 	add	fp, sp, #4
    92e4:	e24dd008 	sub	sp, sp, #8
    92e8:	ed0b0a02 	vstr	s0, [fp, #-8]
    92ec:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    92f0:	e3a01008 	mov	r1, #8
    92f4:	e51b000c 	ldr	r0, [fp, #-12]
    92f8:	ed1b0a02 	vldr	s0, [fp, #-8]
    92fc:	eb000002 	bl	930c <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    9300:	e320f000 	nop	{0}
    9304:	e24bd004 	sub	sp, fp, #4
    9308:	e8bd8800 	pop	{fp, pc}

0000930c <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    930c:	e92d4800 	push	{fp, lr}
    9310:	e28db004 	add	fp, sp, #4
    9314:	e24dd060 	sub	sp, sp, #96	; 0x60
    9318:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    931c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    9320:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9324:	e3a03000 	mov	r3, #0
    9328:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    932c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9330:	eef57ac0 	vcmpe.f32	s15, #0.0
    9334:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9338:	5a000009 	bpl	9364 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    933c:	e51b3008 	ldr	r3, [fp, #-8]
    9340:	e2832001 	add	r2, r3, #1
    9344:	e50b2008 	str	r2, [fp, #-8]
    9348:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    934c:	e0823003 	add	r3, r2, r3
    9350:	e3a0202d 	mov	r2, #45	; 0x2d
    9354:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    9358:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    935c:	eef17a67 	vneg.f32	s15, s15
    9360:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    9364:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9368:	ebffffbc 	bl	9260 <_Z5isnanf>
    936c:	e1a03000 	mov	r3, r0
    9370:	e3530000 	cmp	r3, #0
    9374:	0a00001c 	beq	93ec <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    9378:	e51b3008 	ldr	r3, [fp, #-8]
    937c:	e2832001 	add	r2, r3, #1
    9380:	e50b2008 	str	r2, [fp, #-8]
    9384:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9388:	e0823003 	add	r3, r2, r3
    938c:	e3a0204e 	mov	r2, #78	; 0x4e
    9390:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    9394:	e51b3008 	ldr	r3, [fp, #-8]
    9398:	e2832001 	add	r2, r3, #1
    939c:	e50b2008 	str	r2, [fp, #-8]
    93a0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93a4:	e0823003 	add	r3, r2, r3
    93a8:	e3a02061 	mov	r2, #97	; 0x61
    93ac:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    93b0:	e51b3008 	ldr	r3, [fp, #-8]
    93b4:	e2832001 	add	r2, r3, #1
    93b8:	e50b2008 	str	r2, [fp, #-8]
    93bc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93c0:	e0823003 	add	r3, r2, r3
    93c4:	e3a0204e 	mov	r2, #78	; 0x4e
    93c8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    93cc:	e51b3008 	ldr	r3, [fp, #-8]
    93d0:	e2832001 	add	r2, r3, #1
    93d4:	e50b2008 	str	r2, [fp, #-8]
    93d8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93dc:	e0823003 	add	r3, r2, r3
    93e0:	e3a02000 	mov	r2, #0
    93e4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    93e8:	ea00008c 	b	9620 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    93ec:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    93f0:	ebffffa9 	bl	929c <_Z5isinff>
    93f4:	e1a03000 	mov	r3, r0
    93f8:	e3530000 	cmp	r3, #0
    93fc:	0a00001c 	beq	9474 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    9400:	e51b3008 	ldr	r3, [fp, #-8]
    9404:	e2832001 	add	r2, r3, #1
    9408:	e50b2008 	str	r2, [fp, #-8]
    940c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9410:	e0823003 	add	r3, r2, r3
    9414:	e3a02049 	mov	r2, #73	; 0x49
    9418:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    941c:	e51b3008 	ldr	r3, [fp, #-8]
    9420:	e2832001 	add	r2, r3, #1
    9424:	e50b2008 	str	r2, [fp, #-8]
    9428:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    942c:	e0823003 	add	r3, r2, r3
    9430:	e3a0206e 	mov	r2, #110	; 0x6e
    9434:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    9438:	e51b3008 	ldr	r3, [fp, #-8]
    943c:	e2832001 	add	r2, r3, #1
    9440:	e50b2008 	str	r2, [fp, #-8]
    9444:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9448:	e0823003 	add	r3, r2, r3
    944c:	e3a02066 	mov	r2, #102	; 0x66
    9450:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    9454:	e51b3008 	ldr	r3, [fp, #-8]
    9458:	e2832001 	add	r2, r3, #1
    945c:	e50b2008 	str	r2, [fp, #-8]
    9460:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9464:	e0823003 	add	r3, r2, r3
    9468:	e3a02000 	mov	r2, #0
    946c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    9470:	ea00006a 	b	9620 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    9474:	e3a03008 	mov	r3, #8
    9478:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    947c:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9480:	e3530007 	cmp	r3, #7
    9484:	8a000001 	bhi	9490 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    9488:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    948c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    9490:	e51b300c 	ldr	r3, [fp, #-12]
    9494:	e1a00003 	mov	r0, r3
    9498:	ed9f0a62 	vldr	s0, [pc, #392]	; 9628 <_Z4ftoafPcj+0x31c>
    949c:	ebfffdde 	bl	8c1c <_Z3powfj>
    94a0:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    94a4:	eddf6a60 	vldr	s13, [pc, #384]	; 962c <_Z4ftoafPcj+0x320>
    94a8:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    94ac:	eec67a87 	vdiv.f32	s15, s13, s14
    94b0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    94b4:	ee777a27 	vadd.f32	s15, s14, s15
    94b8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    94bc:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    94c0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    94c4:	ee173a90 	vmov	r3, s15
    94c8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    94cc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    94d0:	ee073a90 	vmov	s15, r3
    94d4:	eef87a67 	vcvt.f32.u32	s15, s15
    94d8:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    94dc:	ee377a67 	vsub.f32	s14, s14, s15
    94e0:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    94e4:	ee677a27 	vmul.f32	s15, s14, s15
    94e8:	eefc7ae7 	vcvt.u32.f32	s15, s15
    94ec:	ee173a90 	vmov	r3, s15
    94f0:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    94f4:	e24b3044 	sub	r3, fp, #68	; 0x44
    94f8:	e3a0200a 	mov	r2, #10
    94fc:	e1a01003 	mov	r1, r3
    9500:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9504:	ebfffc96 	bl	8764 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9508:	e24b3044 	sub	r3, fp, #68	; 0x44
    950c:	e1a00003 	mov	r0, r3
    9510:	ebfffd72 	bl	8ae0 <_Z6strlenPKc>
    9514:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9518:	e3a03000 	mov	r3, #0
    951c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    9520:	e51b2010 	ldr	r2, [fp, #-16]
    9524:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9528:	e1520003 	cmp	r2, r3
    952c:	aa00000d 	bge	9568 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    9530:	e51b3008 	ldr	r3, [fp, #-8]
    9534:	e2832001 	add	r2, r3, #1
    9538:	e50b2008 	str	r2, [fp, #-8]
    953c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9540:	e0823003 	add	r3, r2, r3
    9544:	e24b1044 	sub	r1, fp, #68	; 0x44
    9548:	e51b2010 	ldr	r2, [fp, #-16]
    954c:	e0812002 	add	r2, r1, r2
    9550:	e5d22000 	ldrb	r2, [r2]
    9554:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    9558:	e51b3010 	ldr	r3, [fp, #-16]
    955c:	e2833001 	add	r3, r3, #1
    9560:	e50b3010 	str	r3, [fp, #-16]
    9564:	eaffffed 	b	9520 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    9568:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    956c:	e3530000 	cmp	r3, #0
    9570:	0a000025 	beq	960c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    9574:	e51b3008 	ldr	r3, [fp, #-8]
    9578:	e2832001 	add	r2, r3, #1
    957c:	e50b2008 	str	r2, [fp, #-8]
    9580:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9584:	e0823003 	add	r3, r2, r3
    9588:	e3a0202e 	mov	r2, #46	; 0x2e
    958c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    9590:	e24b3050 	sub	r3, fp, #80	; 0x50
    9594:	e51b200c 	ldr	r2, [fp, #-12]
    9598:	e1a01003 	mov	r1, r3
    959c:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    95a0:	ebfffef9 	bl	918c <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    95a4:	e3a03000 	mov	r3, #0
    95a8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    95ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95b0:	e3530008 	cmp	r3, #8
    95b4:	ca000014 	bgt	960c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    95b8:	e24b2050 	sub	r2, fp, #80	; 0x50
    95bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95c0:	e0823003 	add	r3, r2, r3
    95c4:	e5d33000 	ldrb	r3, [r3]
    95c8:	e3530000 	cmp	r3, #0
    95cc:	0a00000d 	beq	9608 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    95d0:	e51b3008 	ldr	r3, [fp, #-8]
    95d4:	e2832001 	add	r2, r3, #1
    95d8:	e50b2008 	str	r2, [fp, #-8]
    95dc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    95e0:	e0823003 	add	r3, r2, r3
    95e4:	e24b1050 	sub	r1, fp, #80	; 0x50
    95e8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    95ec:	e0812002 	add	r2, r1, r2
    95f0:	e5d22000 	ldrb	r2, [r2]
    95f4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    95f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95fc:	e2833001 	add	r3, r3, #1
    9600:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9604:	eaffffe8 	b	95ac <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9608:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    960c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9610:	e51b3008 	ldr	r3, [fp, #-8]
    9614:	e0823003 	add	r3, r2, r3
    9618:	e3a02000 	mov	r2, #0
    961c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    9620:	e24bd004 	sub	sp, fp, #4
    9624:	e8bd8800 	pop	{fp, pc}
    9628:	41200000 			; <UNDEFINED> instruction: 0x41200000
    962c:	3f000000 	svccc	0x00000000

00009630 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    9630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9634:	e28db000 	add	fp, sp, #0
    9638:	e24dd01c 	sub	sp, sp, #28
    963c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    9640:	e3a03000 	mov	r3, #0
    9644:	e50b3008 	str	r3, [fp, #-8]
    9648:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    964c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    9650:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9654:	e5d33000 	ldrb	r3, [r3]
    9658:	e353002d 	cmp	r3, #45	; 0x2d
    965c:	1a000004 	bne	9674 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    9660:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9664:	e2833001 	add	r3, r3, #1
    9668:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    966c:	e59f30c8 	ldr	r3, [pc, #200]	; 973c <_Z4atofPKc+0x10c>
    9670:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    9674:	e3a03000 	mov	r3, #0
    9678:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    967c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9680:	e5d33000 	ldrb	r3, [r3]
    9684:	e3530000 	cmp	r3, #0
    9688:	0a000023 	beq	971c <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    968c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9690:	e5d33000 	ldrb	r3, [r3]
    9694:	e353002e 	cmp	r3, #46	; 0x2e
    9698:	1a000002 	bne	96a8 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    969c:	e3a03001 	mov	r3, #1
    96a0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    96a4:	ea000018 	b	970c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    96a8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    96ac:	e5d33000 	ldrb	r3, [r3]
    96b0:	e2433030 	sub	r3, r3, #48	; 0x30
    96b4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    96b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96bc:	e3530000 	cmp	r3, #0
    96c0:	ba000011 	blt	970c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    96c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96c8:	e3530009 	cmp	r3, #9
    96cc:	ca00000e 	bgt	970c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    96d0:	e51b3010 	ldr	r3, [fp, #-16]
    96d4:	e3530000 	cmp	r3, #0
    96d8:	0a000003 	beq	96ec <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    96dc:	ed1b7a03 	vldr	s14, [fp, #-12]
    96e0:	eddf6a14 	vldr	s13, [pc, #80]	; 9738 <_Z4atofPKc+0x108>
    96e4:	eec77a26 	vdiv.f32	s15, s14, s13
    96e8:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    96ec:	ed5b7a02 	vldr	s15, [fp, #-8]
    96f0:	ed9f7a10 	vldr	s14, [pc, #64]	; 9738 <_Z4atofPKc+0x108>
    96f4:	ee277a87 	vmul.f32	s14, s15, s14
    96f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96fc:	ee073a90 	vmov	s15, r3
    9700:	eef87ae7 	vcvt.f32.s32	s15, s15
    9704:	ee777a27 	vadd.f32	s15, s14, s15
    9708:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    970c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9710:	e2833001 	add	r3, r3, #1
    9714:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9718:	eaffffd7 	b	967c <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    971c:	ed1b7a02 	vldr	s14, [fp, #-8]
    9720:	ed5b7a03 	vldr	s15, [fp, #-12]
    9724:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9728:	eeb00a67 	vmov.f32	s0, s15
    972c:	e28bd000 	add	sp, fp, #0
    9730:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9734:	e12fff1e 	bx	lr
    9738:	41200000 			; <UNDEFINED> instruction: 0x41200000
    973c:	bf800000 	svclt	0x00800000

00009740 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9740:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9744:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9748:	3a000074 	bcc	9920 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    974c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9750:	9a00006b 	bls	9904 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9754:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9758:	0a00006c 	beq	9910 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    975c:	e16f3f10 	clz	r3, r0
    9760:	e16f2f11 	clz	r2, r1
    9764:	e0423003 	sub	r3, r2, r3
    9768:	e273301f 	rsbs	r3, r3, #31
    976c:	10833083 	addne	r3, r3, r3, lsl #1
    9770:	e3a02000 	mov	r2, #0
    9774:	108ff103 	addne	pc, pc, r3, lsl #2
    9778:	e1a00000 	nop			; (mov r0, r0)
    977c:	e1500f81 	cmp	r0, r1, lsl #31
    9780:	e0a22002 	adc	r2, r2, r2
    9784:	20400f81 	subcs	r0, r0, r1, lsl #31
    9788:	e1500f01 	cmp	r0, r1, lsl #30
    978c:	e0a22002 	adc	r2, r2, r2
    9790:	20400f01 	subcs	r0, r0, r1, lsl #30
    9794:	e1500e81 	cmp	r0, r1, lsl #29
    9798:	e0a22002 	adc	r2, r2, r2
    979c:	20400e81 	subcs	r0, r0, r1, lsl #29
    97a0:	e1500e01 	cmp	r0, r1, lsl #28
    97a4:	e0a22002 	adc	r2, r2, r2
    97a8:	20400e01 	subcs	r0, r0, r1, lsl #28
    97ac:	e1500d81 	cmp	r0, r1, lsl #27
    97b0:	e0a22002 	adc	r2, r2, r2
    97b4:	20400d81 	subcs	r0, r0, r1, lsl #27
    97b8:	e1500d01 	cmp	r0, r1, lsl #26
    97bc:	e0a22002 	adc	r2, r2, r2
    97c0:	20400d01 	subcs	r0, r0, r1, lsl #26
    97c4:	e1500c81 	cmp	r0, r1, lsl #25
    97c8:	e0a22002 	adc	r2, r2, r2
    97cc:	20400c81 	subcs	r0, r0, r1, lsl #25
    97d0:	e1500c01 	cmp	r0, r1, lsl #24
    97d4:	e0a22002 	adc	r2, r2, r2
    97d8:	20400c01 	subcs	r0, r0, r1, lsl #24
    97dc:	e1500b81 	cmp	r0, r1, lsl #23
    97e0:	e0a22002 	adc	r2, r2, r2
    97e4:	20400b81 	subcs	r0, r0, r1, lsl #23
    97e8:	e1500b01 	cmp	r0, r1, lsl #22
    97ec:	e0a22002 	adc	r2, r2, r2
    97f0:	20400b01 	subcs	r0, r0, r1, lsl #22
    97f4:	e1500a81 	cmp	r0, r1, lsl #21
    97f8:	e0a22002 	adc	r2, r2, r2
    97fc:	20400a81 	subcs	r0, r0, r1, lsl #21
    9800:	e1500a01 	cmp	r0, r1, lsl #20
    9804:	e0a22002 	adc	r2, r2, r2
    9808:	20400a01 	subcs	r0, r0, r1, lsl #20
    980c:	e1500981 	cmp	r0, r1, lsl #19
    9810:	e0a22002 	adc	r2, r2, r2
    9814:	20400981 	subcs	r0, r0, r1, lsl #19
    9818:	e1500901 	cmp	r0, r1, lsl #18
    981c:	e0a22002 	adc	r2, r2, r2
    9820:	20400901 	subcs	r0, r0, r1, lsl #18
    9824:	e1500881 	cmp	r0, r1, lsl #17
    9828:	e0a22002 	adc	r2, r2, r2
    982c:	20400881 	subcs	r0, r0, r1, lsl #17
    9830:	e1500801 	cmp	r0, r1, lsl #16
    9834:	e0a22002 	adc	r2, r2, r2
    9838:	20400801 	subcs	r0, r0, r1, lsl #16
    983c:	e1500781 	cmp	r0, r1, lsl #15
    9840:	e0a22002 	adc	r2, r2, r2
    9844:	20400781 	subcs	r0, r0, r1, lsl #15
    9848:	e1500701 	cmp	r0, r1, lsl #14
    984c:	e0a22002 	adc	r2, r2, r2
    9850:	20400701 	subcs	r0, r0, r1, lsl #14
    9854:	e1500681 	cmp	r0, r1, lsl #13
    9858:	e0a22002 	adc	r2, r2, r2
    985c:	20400681 	subcs	r0, r0, r1, lsl #13
    9860:	e1500601 	cmp	r0, r1, lsl #12
    9864:	e0a22002 	adc	r2, r2, r2
    9868:	20400601 	subcs	r0, r0, r1, lsl #12
    986c:	e1500581 	cmp	r0, r1, lsl #11
    9870:	e0a22002 	adc	r2, r2, r2
    9874:	20400581 	subcs	r0, r0, r1, lsl #11
    9878:	e1500501 	cmp	r0, r1, lsl #10
    987c:	e0a22002 	adc	r2, r2, r2
    9880:	20400501 	subcs	r0, r0, r1, lsl #10
    9884:	e1500481 	cmp	r0, r1, lsl #9
    9888:	e0a22002 	adc	r2, r2, r2
    988c:	20400481 	subcs	r0, r0, r1, lsl #9
    9890:	e1500401 	cmp	r0, r1, lsl #8
    9894:	e0a22002 	adc	r2, r2, r2
    9898:	20400401 	subcs	r0, r0, r1, lsl #8
    989c:	e1500381 	cmp	r0, r1, lsl #7
    98a0:	e0a22002 	adc	r2, r2, r2
    98a4:	20400381 	subcs	r0, r0, r1, lsl #7
    98a8:	e1500301 	cmp	r0, r1, lsl #6
    98ac:	e0a22002 	adc	r2, r2, r2
    98b0:	20400301 	subcs	r0, r0, r1, lsl #6
    98b4:	e1500281 	cmp	r0, r1, lsl #5
    98b8:	e0a22002 	adc	r2, r2, r2
    98bc:	20400281 	subcs	r0, r0, r1, lsl #5
    98c0:	e1500201 	cmp	r0, r1, lsl #4
    98c4:	e0a22002 	adc	r2, r2, r2
    98c8:	20400201 	subcs	r0, r0, r1, lsl #4
    98cc:	e1500181 	cmp	r0, r1, lsl #3
    98d0:	e0a22002 	adc	r2, r2, r2
    98d4:	20400181 	subcs	r0, r0, r1, lsl #3
    98d8:	e1500101 	cmp	r0, r1, lsl #2
    98dc:	e0a22002 	adc	r2, r2, r2
    98e0:	20400101 	subcs	r0, r0, r1, lsl #2
    98e4:	e1500081 	cmp	r0, r1, lsl #1
    98e8:	e0a22002 	adc	r2, r2, r2
    98ec:	20400081 	subcs	r0, r0, r1, lsl #1
    98f0:	e1500001 	cmp	r0, r1
    98f4:	e0a22002 	adc	r2, r2, r2
    98f8:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    98fc:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9900:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9904:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9908:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    990c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    9910:	e16f2f11 	clz	r2, r1
    9914:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9918:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    991c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9920:	e3500000 	cmp	r0, #0
    9924:	13e00000 	mvnne	r0, #0
    9928:	ea000007 	b	994c <__aeabi_idiv0>

0000992c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    992c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9930:	0afffffa 	beq	9920 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9934:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9938:	ebffff80 	bl	9740 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    993c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9940:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9944:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9948:	e12fff1e 	bx	lr

0000994c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    994c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009950 <_ZL8INFINITY>:
    9950:	7f7fffff 	svcvc	0x007fffff

00009954 <_ZL13Lock_Unlocked>:
    9954:	00000000 	andeq	r0, r0, r0

00009958 <_ZL11Lock_Locked>:
    9958:	00000001 	andeq	r0, r0, r1

0000995c <_ZL21MaxFSDriverNameLength>:
    995c:	00000010 	andeq	r0, r0, r0, lsl r0

00009960 <_ZL17MaxFilenameLength>:
    9960:	00000010 	andeq	r0, r0, r0, lsl r0

00009964 <_ZL13MaxPathLength>:
    9964:	00000080 	andeq	r0, r0, r0, lsl #1

00009968 <_ZL18NoFilesystemDriver>:
    9968:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000996c <_ZL9NotifyAll>:
    996c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009970 <_ZL24Max_Process_Opened_Files>:
    9970:	00000010 	andeq	r0, r0, r0, lsl r0

00009974 <_ZL10Indefinite>:
    9974:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009978 <_ZL18Deadline_Unchanged>:
    9978:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000997c <_ZL14Invalid_Handle>:
    997c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009980 <_ZN3halL18Default_Clock_RateE>:
    9980:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009984 <_ZN3halL15Peripheral_BaseE>:
    9984:	20000000 	andcs	r0, r0, r0

00009988 <_ZN3halL9GPIO_BaseE>:
    9988:	20200000 	eorcs	r0, r0, r0

0000998c <_ZN3halL14GPIO_Pin_CountE>:
    998c:	00000036 	andeq	r0, r0, r6, lsr r0

00009990 <_ZN3halL8AUX_BaseE>:
    9990:	20215000 	eorcs	r5, r1, r0

00009994 <_ZN3halL25Interrupt_Controller_BaseE>:
    9994:	2000b200 	andcs	fp, r0, r0, lsl #4

00009998 <_ZN3halL10Timer_BaseE>:
    9998:	2000b400 	andcs	fp, r0, r0, lsl #8

0000999c <_ZN3halL9TRNG_BaseE>:
    999c:	20104000 	andscs	r4, r0, r0

000099a0 <_ZN3halL9BSC0_BaseE>:
    99a0:	20205000 	eorcs	r5, r0, r0

000099a4 <_ZN3halL9BSC1_BaseE>:
    99a4:	20804000 	addcs	r4, r0, r0

000099a8 <_ZN3halL9BSC2_BaseE>:
    99a8:	20805000 	addcs	r5, r0, r0

000099ac <_ZL11Invalid_Pin>:
    99ac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    99b0:	3a564544 	bcc	159aec8 <__bss_end+0x1591490>
    99b4:	6f697067 	svcvs	0x00697067
    99b8:	0033322f 	eorseq	r3, r3, pc, lsr #4
    99bc:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    99c0:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    99c4:	00505520 	subseq	r5, r0, r0, lsr #10
    99c8:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    99cc:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    99d0:	0000004e 	andeq	r0, r0, lr, asr #32

000099d4 <_ZL13Lock_Unlocked>:
    99d4:	00000000 	andeq	r0, r0, r0

000099d8 <_ZL11Lock_Locked>:
    99d8:	00000001 	andeq	r0, r0, r1

000099dc <_ZL21MaxFSDriverNameLength>:
    99dc:	00000010 	andeq	r0, r0, r0, lsl r0

000099e0 <_ZL17MaxFilenameLength>:
    99e0:	00000010 	andeq	r0, r0, r0, lsl r0

000099e4 <_ZL13MaxPathLength>:
    99e4:	00000080 	andeq	r0, r0, r0, lsl #1

000099e8 <_ZL18NoFilesystemDriver>:
    99e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000099ec <_ZL9NotifyAll>:
    99ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000099f0 <_ZL24Max_Process_Opened_Files>:
    99f0:	00000010 	andeq	r0, r0, r0, lsl r0

000099f4 <_ZL10Indefinite>:
    99f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000099f8 <_ZL18Deadline_Unchanged>:
    99f8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000099fc <_ZL14Invalid_Handle>:
    99fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a00 <_ZL8INFINITY>:
    9a00:	7f7fffff 	svcvc	0x007fffff

00009a04 <_ZL16Pipe_File_Prefix>:
    9a04:	3a535953 	bcc	14dff58 <__bss_end+0x14d6520>
    9a08:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9a0c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009a10 <_ZL8INFINITY>:
    9a10:	7f7fffff 	svcvc	0x007fffff

00009a14 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9a14:	33323130 	teqcc	r2, #48, 2
    9a18:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9a1c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9a20:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009a28 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683df4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x389ec>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c600>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c72ec>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfc04>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36ece>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff6397>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x157360>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7768>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x7779c>
 1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1d0:	01058509 	tsteq	r5, r9, lsl #10
 1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
 1d8:	02660101 	rsbeq	r0, r6, #1073741824	; 0x40000000
 1dc:	00030000 	andeq	r0, r3, r0
 1e0:	00000226 	andeq	r0, r0, r6, lsr #4
 1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 1e8:	0101000d 	tsteq	r1, sp
 1ec:	00000101 	andeq	r0, r0, r1, lsl #2
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	6f682f01 	svcvs	0x00682f01
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfd7c>
 1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 200:	2f697261 	svccs	0x00697261
 204:	2f746967 	svccs	0x00746967
 208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 20c:	6f732f70 	svcvs	0x00732f70
 210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 214:	73752f73 	cmnvc	r5, #460	; 0x1cc
 218:	70737265 	rsbsvc	r7, r3, r5, ror #4
 21c:	2f656361 	svccs	0x00656361
 220:	746c6974 	strbtvc	r6, [ip], #-2420	; 0xfffff68c
 224:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 228:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 22c:	2f656d6f 	svccs	0x00656d6f
 230:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 234:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 238:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 23c:	2f736f2f 	svccs	0x00736f2f
 240:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 244:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff64b3>
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
 2ac:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2b0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2b4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2b8:	2f006c61 	svccs	0x00006c61
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
 2e8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 2ec:	2f62696c 	svccs	0x0062696c
 2f0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2f4:	00656475 	rsbeq	r6, r5, r5, ror r4
 2f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 244 <shift+0x244>
 2fc:	616a2f65 	cmnvs	sl, r5, ror #30
 300:	6173656d 	cmnvs	r3, sp, ror #10
 304:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 308:	6f2f7469 	svcvs	0x002f7469
 30c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 310:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff65b1>
 314:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 318:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 31c:	61707372 	cmnvs	r0, r2, ror r3
 320:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 324:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 328:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 32c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 330:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 334:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 338:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 284 <shift+0x284>
 33c:	616a2f65 	cmnvs	sl, r5, ror #30
 340:	6173656d 	cmnvs	r3, sp, ror #10
 344:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 348:	6f2f7469 	svcvs	0x002f7469
 34c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 350:	756f732f 	strbvc	r7, [pc, #-815]!	; 29 <shift+0x29>
 354:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 358:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 35c:	61707372 	cmnvs	r0, r2, ror r3
 360:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 364:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 368:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 36c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 370:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 374:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 378:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 37c:	616d0000 	cmnvs	sp, r0
 380:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 384:	01007070 	tsteq	r0, r0, ror r0
 388:	77730000 	ldrbvc	r0, [r3, -r0]!
 38c:	00682e69 	rsbeq	r2, r8, r9, ror #28
 390:	69000002 	stmdbvs	r0, {r1}
 394:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 398:	00682e66 	rsbeq	r2, r8, r6, ror #28
 39c:	73000003 	movwvc	r0, #3
 3a0:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 3a4:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 3a8:	00020068 	andeq	r0, r2, r8, rrx
 3ac:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 3b0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 3b4:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 3b8:	00000400 	andeq	r0, r0, r0, lsl #8
 3bc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3c0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3c4:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3c8:	00000500 	andeq	r0, r0, r0, lsl #10
 3cc:	636f7270 	cmnvs	pc, #112, 4
 3d0:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3d4:	00020068 	andeq	r0, r2, r8, rrx
 3d8:	6f727000 	svcvs	0x00727000
 3dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3e0:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3e4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3e8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3ec:	65700000 	ldrbvs	r0, [r0, #-0]!
 3f0:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 3f4:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 3f8:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3fc:	67000003 	strvs	r0, [r0, -r3]
 400:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 404:	00060068 	andeq	r0, r6, r8, rrx
 408:	01050000 	mrseq	r0, (UNDEF: 5)
 40c:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
 410:	03000082 	movweq	r0, #130	; 0x82
 414:	0705010e 	streq	r0, [r5, -lr, lsl #2]
 418:	21054b9f 			; <UNDEFINED> instruction: 0x21054b9f
 41c:	8a09054c 	bhi	241954 <__bss_end+0x237f1c>
 420:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
 424:	0705a019 	smladeq	r5, r9, r0, sl
 428:	0e058786 	cdpeq	7, 0, cr8, cr5, cr6, {4}
 42c:	2e0405a2 	cfsh32cs	mvfx0, mvfx4, #-46
 430:	a24c0a05 	subge	r0, ip, #20480	; 0x5000
 434:	05840d05 	streq	r0, [r4, #3333]	; 0xd05
 438:	07054d08 	streq	r4, [r5, -r8, lsl #26]
 43c:	02666c03 	rsbeq	r6, r6, #768	; 0x300
 440:	0101000a 	tsteq	r1, sl
 444:	000002bf 			; <UNDEFINED> instruction: 0x000002bf
 448:	018c0003 	orreq	r0, ip, r3
 44c:	01020000 	mrseq	r0, (UNDEF: 2)
 450:	000d0efb 	strdeq	r0, [sp], -fp
 454:	01010101 	tsteq	r1, r1, lsl #2
 458:	01000000 	mrseq	r0, (UNDEF: 0)
 45c:	2f010000 	svccs	0x00010000
 460:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 464:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 468:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 46c:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 470:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 474:	2f70732f 	svccs	0x0070732f
 478:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 47c:	2f736563 	svccs	0x00736563
 480:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 484:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 488:	2f006372 	svccs	0x00006372
 48c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 490:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 494:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 498:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 49c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 4a0:	2f70732f 	svccs	0x0070732f
 4a4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4a8:	2f736563 	svccs	0x00736563
 4ac:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 4b0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 4b4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4b8:	702f6564 	eorvc	r6, pc, r4, ror #10
 4bc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4c0:	2f007373 	svccs	0x00007373
 4c4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4c8:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 4cc:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 4d0:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 4d4:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 4d8:	2f70732f 	svccs	0x0070732f
 4dc:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4e0:	2f736563 	svccs	0x00736563
 4e4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 4e8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 4ec:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4f0:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 4f4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 4f8:	2f656d6f 	svccs	0x00656d6f
 4fc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 500:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 504:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 508:	2f736f2f 	svccs	0x00736f2f
 50c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 510:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 514:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 518:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 51c:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 520:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 524:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 528:	2f656d6f 	svccs	0x00656d6f
 52c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 530:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 534:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 538:	2f736f2f 	svccs	0x00736f2f
 53c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 540:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 544:	6b2f7365 	blvs	bdd2e0 <__bss_end+0xbd38a8>
 548:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 54c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 550:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 554:	6f622f65 	svcvs	0x00622f65
 558:	2f647261 	svccs	0x00647261
 55c:	30697072 	rsbcc	r7, r9, r2, ror r0
 560:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 564:	74730000 	ldrbtvc	r0, [r3], #-0
 568:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 56c:	70632e65 	rsbvc	r2, r3, r5, ror #28
 570:	00010070 	andeq	r0, r1, r0, ror r0
 574:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 578:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 57c:	70730000 	rsbsvc	r0, r3, r0
 580:	6f6c6e69 	svcvs	0x006c6e69
 584:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 588:	00000200 	andeq	r0, r0, r0, lsl #4
 58c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 590:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 594:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 598:	00000300 	andeq	r0, r0, r0, lsl #6
 59c:	636f7270 	cmnvs	pc, #112, 4
 5a0:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 5a4:	00020068 	andeq	r0, r2, r8, rrx
 5a8:	6f727000 	svcvs	0x00727000
 5ac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 5b0:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 5b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 5b8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5bc:	74730000 	ldrbtvc	r0, [r3], #-0
 5c0:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 5c4:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 5c8:	00040068 	andeq	r0, r4, r8, rrx
 5cc:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 5d0:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 5d4:	00050068 	andeq	r0, r5, r8, rrx
 5d8:	01050000 	mrseq	r0, (UNDEF: 5)
 5dc:	08020500 	stmdaeq	r2, {r8, sl}
 5e0:	16000083 	strne	r0, [r0], -r3, lsl #1
 5e4:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
 5e8:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
 5ec:	2f01054c 	svccs	0x0001054c
 5f0:	83320585 	teqhi	r2, #557842432	; 0x21400000
 5f4:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5f8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5fc:	01054b1a 	tsteq	r5, sl, lsl fp
 600:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 604:	4b2e05a1 	blmi	b81c90 <__bss_end+0xb78258>
 608:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 60c:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 610:	2f01054c 	svccs	0x0001054c
 614:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 618:	054b3005 	strbeq	r3, [fp, #-5]
 61c:	1b054b2e 	blne	1532dc <__bss_end+0x1498a4>
 620:	2f2e054b 	svccs	0x002e054b
 624:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 628:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 62c:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 630:	4b2e054b 	blmi	b81b64 <__bss_end+0xb7812c>
 634:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 638:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 63c:	2f01054c 	svccs	0x0001054c
 640:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 644:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 648:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 64c:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 650:	4b2f054b 	blmi	bc1b84 <__bss_end+0xbb814c>
 654:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 658:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 65c:	2f01054c 	svccs	0x0001054c
 660:	a12e0585 	smlawbge	lr, r5, r5, r0
 664:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 668:	2f054b1b 	svccs	0x00054b1b
 66c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 670:	852f0105 	strhi	r0, [pc, #-261]!	; 573 <shift+0x573>
 674:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 678:	3b054b2f 	blcc	15333c <__bss_end+0x149904>
 67c:	4b1b054b 	blmi	6c1bb0 <__bss_end+0x6b8178>
 680:	052f3005 	streq	r3, [pc, #-5]!	; 683 <shift+0x683>
 684:	01054c0c 	tsteq	r5, ip, lsl #24
 688:	2f05852f 	svccs	0x0005852f
 68c:	4b3b05a1 	blmi	ec1d18 <__bss_end+0xeb82e0>
 690:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 694:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 698:	9f01054c 	svcls	0x0001054c
 69c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6a0:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 6a4:	1a054b31 	bne	153370 <__bss_end+0x149938>
 6a8:	300c054b 	andcc	r0, ip, fp, asr #10
 6ac:	852f0105 	strhi	r0, [pc, #-261]!	; 5af <shift+0x5af>
 6b0:	05672005 	strbeq	r2, [r7, #-5]!
 6b4:	31054d2d 	tstcc	r5, sp, lsr #26
 6b8:	4b1a054b 	blmi	681bec <__bss_end+0x6781b4>
 6bc:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6c0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c4:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 6c8:	4b3e054c 	blmi	f81c00 <__bss_end+0xf781c8>
 6cc:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 6d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6d4:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 6d8:	4b30054d 	blmi	c01c14 <__bss_end+0xbf81dc>
 6dc:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 6e0:	0105300c 	tsteq	r5, ip
 6e4:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 6e8:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 6ec:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 6f0:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 6f4:	1305300f 	movwne	r3, #20495	; 0x500f
 6f8:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 6fc:	05d81005 	ldrbeq	r1, [r8, #5]
 700:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 704:	3e010100 	adfccs	f0, f1, f0
 708:	03000006 	movweq	r0, #6
 70c:	00008f00 	andeq	r8, r0, r0, lsl #30
 710:	fb010200 	blx	40f1a <__bss_end+0x374e2>
 714:	01000d0e 	tsteq	r0, lr, lsl #26
 718:	00010101 	andeq	r0, r1, r1, lsl #2
 71c:	00010000 	andeq	r0, r1, r0
 720:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 724:	2f656d6f 	svccs	0x00656d6f
 728:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 72c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 730:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 734:	2f736f2f 	svccs	0x00736f2f
 738:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 73c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 740:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 744:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 748:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 74c:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 750:	2f656d6f 	svccs	0x00656d6f
 754:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 758:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 75c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 760:	2f736f2f 	svccs	0x00736f2f
 764:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 768:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 76c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 770:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 774:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 778:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 77c:	73000065 	movwvc	r0, #101	; 0x65
 780:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 784:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 788:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 78c:	00000100 	andeq	r0, r0, r0, lsl #2
 790:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 794:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 798:	00682e67 	rsbeq	r2, r8, r7, ror #28
 79c:	00000002 	andeq	r0, r0, r2
 7a0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 7a4:	00876402 	addeq	r6, r7, r2, lsl #8
 7a8:	06051a00 	streq	r1, [r5], -r0, lsl #20
 7ac:	4c0f05bb 	cfstr32mi	mvfx0, [pc], {187}	; 0xbb
 7b0:	05682105 	strbeq	r2, [r8, #-261]!	; 0xfffffefb
 7b4:	0b05ba0a 	bleq	16efe4 <__bss_end+0x1655ac>
 7b8:	4a27052e 	bmi	9c1c78 <__bss_end+0x9b8240>
 7bc:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 7c0:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 7c4:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 7c8:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 7cc:	11056810 	tstne	r5, r0, lsl r8
 7d0:	4a22052e 	bmi	881c90 <__bss_end+0x878258>
 7d4:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 7d8:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 7dc:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 7e0:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 7e4:	0b054b03 	bleq	1533f8 <__bss_end+0x1499c0>
 7e8:	00180568 	andseq	r0, r8, r8, ror #10
 7ec:	4a030402 	bmi	c17fc <__bss_end+0xb7dc4>
 7f0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 7f4:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 7f8:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 7fc:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 800:	02040200 	andeq	r0, r4, #0, 4
 804:	00080582 	andeq	r0, r8, r2, lsl #11
 808:	4a020402 	bmi	81818 <__bss_end+0x77de0>
 80c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 810:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 814:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 818:	0c052e02 	stceq	14, cr2, [r5], {2}
 81c:	02040200 	andeq	r0, r4, #0, 4
 820:	000f054a 	andeq	r0, pc, sl, asr #10
 824:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 828:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 82c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 830:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 834:	0a052e02 	beq	14c044 <__bss_end+0x14260c>
 838:	02040200 	andeq	r0, r4, #0, 4
 83c:	000b052f 	andeq	r0, fp, pc, lsr #10
 840:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 844:	02000d05 	andeq	r0, r0, #320	; 0x140
 848:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 84c:	04020002 	streq	r0, [r2], #-2
 850:	01054602 	tsteq	r5, r2, lsl #12
 854:	06058588 	streq	r8, [r5], -r8, lsl #11
 858:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 85c:	054a1005 	strbeq	r1, [sl, #-5]
 860:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 864:	4a0305bb 	bmi	c1f58 <__bss_end+0xb8520>
 868:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 86c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 870:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 874:	0d054a01 	vstreq	s8, [r5, #-4]
 878:	4a14054d 	bmi	501db4 <__bss_end+0x4f837c>
 87c:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 880:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 884:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 888:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 88c:	852f0105 	strhi	r0, [pc, #-261]!	; 78f <shift+0x78f>
 890:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 894:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 898:	1d054a04 	vstrne	s8, [r5, #-16]
 89c:	02040200 	andeq	r0, r4, #0, 4
 8a0:	001e0582 	andseq	r0, lr, r2, lsl #11
 8a4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8a8:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 8ac:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 8b0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 8b4:	12054b03 	andne	r4, r5, #3072	; 0xc00
 8b8:	03040200 	movweq	r0, #16896	; 0x4200
 8bc:	0008052e 	andeq	r0, r8, lr, lsr #10
 8c0:	4a030402 	bmi	c18d0 <__bss_end+0xb7e98>
 8c4:	02000905 	andeq	r0, r0, #81920	; 0x14000
 8c8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 8cc:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 8d0:	0b054a03 	bleq	1530e4 <__bss_end+0x1496ac>
 8d4:	03040200 	movweq	r0, #16896	; 0x4200
 8d8:	0002052e 	andeq	r0, r2, lr, lsr #10
 8dc:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 8e0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 8e4:	05840204 	streq	r0, [r4, #516]	; 0x204
 8e8:	04020008 	streq	r0, [r2], #-8
 8ec:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 8f0:	01040200 	mrseq	r0, R12_usr
 8f4:	000b052e 	andeq	r0, fp, lr, lsr #10
 8f8:	4a010402 	bmi	41908 <__bss_end+0x37ed0>
 8fc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 900:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 904:	0105850b 	tsteq	r5, fp, lsl #10
 908:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 90c:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 910:	05bc2005 	ldreq	r2, [ip, #5]!
 914:	1f05660b 	svcne	0x0005660b
 918:	660a054b 	strvs	r0, [sl], -fp, asr #10
 91c:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 920:	16058311 			; <UNDEFINED> instruction: 0x16058311
 924:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
 928:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 92c:	01054d0b 	tsteq	r5, fp, lsl #26
 930:	0605852f 	streq	r8, [r5], -pc, lsr #10
 934:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
 938:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
 93c:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
 940:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
 944:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
 948:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 94c:	0b059f08 	bleq	168574 <__bss_end+0x15eb3c>
 950:	0014054c 	andseq	r0, r4, ip, asr #10
 954:	4a030402 	bmi	c1964 <__bss_end+0xb7f2c>
 958:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 95c:	05830204 	streq	r0, [r3, #516]	; 0x204
 960:	04020008 	streq	r0, [r2], #-8
 964:	0a052e02 	beq	14c174 <__bss_end+0x14273c>
 968:	02040200 	andeq	r0, r4, #0, 4
 96c:	0002054a 	andeq	r0, r2, sl, asr #10
 970:	49020402 	stmdbmi	r2, {r1, sl}
 974:	85840105 	strhi	r0, [r4, #261]	; 0x105
 978:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 97c:	0b054b08 	bleq	1535a4 <__bss_end+0x149b6c>
 980:	0014054c 	andseq	r0, r4, ip, asr #10
 984:	4a030402 	bmi	c1994 <__bss_end+0xb7f5c>
 988:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 98c:	05830204 	streq	r0, [r3, #516]	; 0x204
 990:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 994:	0a052e02 	beq	14c1a4 <__bss_end+0x14276c>
 998:	02040200 	andeq	r0, r4, #0, 4
 99c:	000b054a 	andeq	r0, fp, sl, asr #10
 9a0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9a4:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 9a8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9ac:	0402000d 	streq	r0, [r2], #-13
 9b0:	02052e02 	andeq	r2, r5, #2, 28
 9b4:	02040200 	andeq	r0, r4, #0, 4
 9b8:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 9bc:	9f0b0585 	svcls	0x000b0585
 9c0:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
 9c4:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 9c8:	0b054a03 	bleq	1531dc <__bss_end+0x1497a4>
 9cc:	02040200 	andeq	r0, r4, #0, 4
 9d0:	00050583 	andeq	r0, r5, r3, lsl #11
 9d4:	81020402 	tsthi	r2, r2, lsl #8
 9d8:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 9dc:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 9e0:	0c058411 	cfstrseq	mvf8, [r5], {17}
 9e4:	00180568 	andseq	r0, r8, r8, ror #10
 9e8:	4a030402 	bmi	c19f8 <__bss_end+0xb7fc0>
 9ec:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 9f0:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 9f4:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 9f8:	16056802 	strne	r6, [r5], -r2, lsl #16
 9fc:	02040200 	andeq	r0, r4, #0, 4
 a00:	000e052e 	andeq	r0, lr, lr, lsr #10
 a04:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a08:	02001c05 	andeq	r1, r0, #1280	; 0x500
 a0c:	052f0204 	streq	r0, [pc, #-516]!	; 810 <shift+0x810>
 a10:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
 a14:	0e056602 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx2
 a18:	02040200 	andeq	r0, r4, #0, 4
 a1c:	000f0566 	andeq	r0, pc, r6, ror #10
 a20:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a24:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
 a28:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 a2c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 a30:	12052e02 	andne	r2, r5, #2, 28
 a34:	02040200 	andeq	r0, r4, #0, 4
 a38:	0019052f 	andseq	r0, r9, pc, lsr #10
 a3c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a40:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 a44:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 a48:	04020005 	streq	r0, [r2], #-5
 a4c:	01056202 	tsteq	r5, r2, lsl #4
 a50:	05056988 	streq	r6, [r5, #-2440]	; 0xfffff678
 a54:	9f0905d7 	svcls	0x000905d7
 a58:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 a5c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 a60:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 a64:	09058201 	stmdbeq	r5, {r0, r9, pc}
 a68:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 a6c:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 a70:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 a74:	05820104 	streq	r0, [r2, #260]	; 0x104
 a78:	1a059f09 	bne	1686a4 <__bss_end+0x15ec6c>
 a7c:	01040200 	mrseq	r0, R12_usr
 a80:	002e059e 	mlaeq	lr, lr, r5, r0
 a84:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 a88:	059f0905 	ldreq	r0, [pc, #2309]	; 1395 <shift+0x1395>
 a8c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 a90:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 a94:	01040200 	mrseq	r0, R12_usr
 a98:	9f090582 	svcls	0x00090582
 a9c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 aa0:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 aa4:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 aa8:	09058201 	stmdbeq	r5, {r0, r9, pc}
 aac:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 ab0:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 ab4:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 ab8:	05820104 	streq	r0, [r2, #260]	; 0x104
 abc:	0f05a005 	svceq	0x0005a005
 ac0:	01040200 	mrseq	r0, R12_usr
 ac4:	9f090582 	svcls	0x00090582
 ac8:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 acc:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 ad0:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 ad4:	09058201 	stmdbeq	r5, {r0, r9, pc}
 ad8:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 adc:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 ae0:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 ae4:	05820104 	streq	r0, [r2, #260]	; 0x104
 ae8:	1a059f09 	bne	168714 <__bss_end+0x15ecdc>
 aec:	01040200 	mrseq	r0, R12_usr
 af0:	002e059e 	mlaeq	lr, lr, r5, r0
 af4:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 af8:	059f0905 	ldreq	r0, [pc, #2309]	; 1405 <shift+0x1405>
 afc:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b00:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b04:	01040200 	mrseq	r0, R12_usr
 b08:	9f090582 	svcls	0x00090582
 b0c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b10:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b14:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b18:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b1c:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 b20:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 b24:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 b28:	05820104 	streq	r0, [r2, #260]	; 0x104
 b2c:	0e05a010 	mcreq	0, 0, sl, cr5, cr0, {0}
 b30:	4b1a0566 	blmi	6820d0 <__bss_end+0x678698>
 b34:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 b38:	0f05820b 	svceq	0x0005820b
 b3c:	660d0567 	strvs	r0, [sp], -r7, ror #10
 b40:	054b1905 	strbeq	r1, [fp, #-2309]	; 0xfffff6fb
 b44:	11054a12 	tstne	r5, r2, lsl sl
 b48:	4a05054a 	bmi	142078 <__bss_end+0x138640>
 b4c:	0b030105 	bleq	c0f68 <__bss_end+0xb7530>
 b50:	03090582 	movweq	r0, #38274	; 0x9582
 b54:	10052e76 	andne	r2, r5, r6, ror lr
 b58:	670c054a 	strvs	r0, [ip, -sl, asr #10]
 b5c:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 b60:	0d056715 	stceq	7, cr6, [r5, #-84]	; 0xffffffac
 b64:	4a150567 	bmi	542108 <__bss_end+0x5386d0>
 b68:	05671005 	strbeq	r1, [r7, #-5]!
 b6c:	1a054a0d 	bne	1533a8 <__bss_end+0x149970>
 b70:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 b74:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 b78:	2e026a01 	vmlacs.f32	s12, s4, s2
 b7c:	bb060515 	bllt	181fd8 <__bss_end+0x1785a0>
 b80:	054b1205 	strbeq	r1, [fp, #-517]	; 0xfffffdfb
 b84:	20056615 	andcs	r6, r5, r5, lsl r6
 b88:	082305bb 	stmdaeq	r3!, {r0, r1, r3, r4, r5, r7, r8, sl}
 b8c:	2e120520 	cfmul64cs	mvdx0, mvdx2, mvdx0
 b90:	05821405 	streq	r1, [r2, #1029]	; 0x405
 b94:	16054a23 	strne	r4, [r5], -r3, lsr #20
 b98:	2f0b054a 	svccs	0x000b054a
 b9c:	059c0505 	ldreq	r0, [ip, #1285]	; 0x505
 ba0:	0b053206 	bleq	14d3c0 <__bss_end+0x143988>
 ba4:	4a0d052e 	bmi	342064 <__bss_end+0x33862c>
 ba8:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 bac:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 bb0:	0105830e 	tsteq	r5, lr, lsl #6
 bb4:	0d0585d7 	cfstr32eq	mvfx8, [r5, #-860]	; 0xfffffca4
 bb8:	d7010583 	strle	r0, [r1, -r3, lsl #11]
 bbc:	9f0605a2 	svcls	0x000605a2
 bc0:	6a830105 	bvs	fe0c0fdc <__bss_end+0xfe0b75a4>
 bc4:	05bb0f05 	ldreq	r0, [fp, #3845]!	; 0xf05
 bc8:	0c054b05 			; <UNDEFINED> instruction: 0x0c054b05
 bcc:	660e0584 	strvs	r0, [lr], -r4, lsl #11
 bd0:	054a1005 	strbeq	r1, [sl, #-5]
 bd4:	0d054b05 	vstreq	d4, [r5, #-20]	; 0xffffffec
 bd8:	66050568 	strvs	r0, [r5], -r8, ror #10
 bdc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 be0:	1005660e 	andne	r6, r5, lr, lsl #12
 be4:	4b0c054a 	blmi	302114 <__bss_end+0x2f86dc>
 be8:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 bec:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 bf0:	660e054b 	strvs	r0, [lr], -fp, asr #10
 bf4:	054a1005 	strbeq	r1, [sl, #-5]
 bf8:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 bfc:	4a100566 	bmi	40219c <__bss_end+0x3f8764>
 c00:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c04:	0505300d 	streq	r3, [r5, #-13]
 c08:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
 c0c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c10:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c14:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c18:	054a1005 	strbeq	r1, [sl, #-5]
 c1c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c20:	4a100566 	bmi	4021c0 <__bss_end+0x3f8788>
 c24:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c28:	1005660e 	andne	r6, r5, lr, lsl #12
 c2c:	4b03054a 	blmi	c215c <__bss_end+0xb8724>
 c30:	05300605 	ldreq	r0, [r0, #-1541]!	; 0xfffff9fb
 c34:	0d054b02 	vstreq	d4, [r5, #-8]
 c38:	4c1c0567 	cfldr32mi	mvfx0, [ip], {103}	; 0x67
 c3c:	059f0e05 	ldreq	r0, [pc, #3589]	; 1a49 <shift+0x1a49>
 c40:	18056607 	stmdane	r5, {r0, r1, r2, r9, sl, sp, lr}
 c44:	83340568 	teqhi	r4, #104, 10	; 0x1a000000
 c48:	05663305 	strbeq	r3, [r6, #-773]!	; 0xfffffcfb
 c4c:	18054a44 	stmdane	r5, {r2, r6, r9, fp, lr}
 c50:	6906054a 	stmdbvs	r6, {r1, r3, r6, r8, sl}
 c54:	059f1d05 	ldreq	r1, [pc, #3333]	; 1961 <shift+0x1961>
 c58:	1405840b 	strne	r8, [r5], #-1035	; 0xfffffbf5
 c5c:	03040200 	movweq	r0, #16896	; 0x4200
 c60:	000c054a 	andeq	r0, ip, sl, asr #10
 c64:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 c68:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 c6c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 c70:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 c74:	10054a02 	andne	r4, r5, r2, lsl #20
 c78:	02040200 	andeq	r0, r4, #0, 4
 c7c:	00020582 	andeq	r0, r2, r2, lsl #11
 c80:	2c020402 	cfstrscs	mvf0, [r2], {2}
 c84:	680c0587 	stmdavs	ip, {r0, r1, r2, r7, r8, sl}
 c88:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c8c:	1a054a10 	bne	1534d4 <__bss_end+0x149a9c>
 c90:	a00c054c 	andge	r0, ip, ip, asr #10
 c94:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 c98:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 c9c:	04056819 	streq	r6, [r5], #-2073	; 0xfffff7e7
 ca0:	000d0582 	andeq	r0, sp, r2, lsl #11
 ca4:	4c020402 	cfstrsmi	mvf0, [r2], {2}
 ca8:	02000f05 	andeq	r0, r0, #5, 30
 cac:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 cb0:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 cb4:	11054a02 	tstne	r5, r2, lsl #20
 cb8:	02040200 	andeq	r0, r4, #0, 4
 cbc:	00030582 	andeq	r0, r3, r2, lsl #11
 cc0:	2a020402 	bcs	81cd0 <__bss_end+0x78298>
 cc4:	05850505 	streq	r0, [r5, #1285]	; 0x505
 cc8:	0402000b 	streq	r0, [r2], #-11
 ccc:	0d053202 	sfmeq	f3, 4, [r5, #-8]
 cd0:	02040200 	andeq	r0, r4, #0, 4
 cd4:	4b010566 	blmi	42274 <__bss_end+0x3883c>
 cd8:	83090585 	movwhi	r0, #38277	; 0x9585
 cdc:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 ce0:	03054b07 	movweq	r4, #23303	; 0x5b07
 ce4:	4b06054a 	blmi	182214 <__bss_end+0x1787dc>
 ce8:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 cec:	1c054c0c 	stcne	12, cr4, [r5], {12}
 cf0:	01040200 	mrseq	r0, R12_usr
 cf4:	001d054a 	andseq	r0, sp, sl, asr #10
 cf8:	4a010402 	bmi	41d08 <__bss_end+0x382d0>
 cfc:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
 d00:	12054a05 	andne	r4, r5, #20480	; 0x5000
 d04:	01040200 	mrseq	r0, R12_usr
 d08:	0007054b 	andeq	r0, r7, fp, asr #10
 d0c:	4b010402 	blmi	41d1c <__bss_end+0x382e4>
 d10:	05300d05 	ldreq	r0, [r0, #-3333]!	; 0xfffff2fb
 d14:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 d18:	0010054b 	andseq	r0, r0, fp, asr #10
 d1c:	66010402 	strvs	r0, [r1], -r2, lsl #8
 d20:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
 d24:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 d28:	11056601 	tstne	r5, r1, lsl #12
 d2c:	661b0583 	ldrvs	r0, [fp], -r3, lsl #11
 d30:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 d34:	04020003 	streq	r0, [r2], #-3
 d38:	4a780302 	bmi	1e01948 <__bss_end+0x1df7f10>
 d3c:	0b031005 	bleq	c4d58 <__bss_end+0xbb320>
 d40:	67010582 	strvs	r0, [r1, -r2, lsl #11]
 d44:	01000c02 	tsteq	r0, r2, lsl #24
 d48:	00007901 	andeq	r7, r0, r1, lsl #18
 d4c:	46000300 	strmi	r0, [r0], -r0, lsl #6
 d50:	02000000 	andeq	r0, r0, #0
 d54:	0d0efb01 	vstreq	d15, [lr, #-4]
 d58:	01010100 	mrseq	r0, (UNDEF: 17)
 d5c:	00000001 	andeq	r0, r0, r1
 d60:	01000001 	tsteq	r0, r1
 d64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d6c:	2f2e2e2f 	svccs	0x002e2e2f
 d70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d74:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 d78:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 d7c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 d80:	2f676966 	svccs	0x00676966
 d84:	006d7261 	rsbeq	r7, sp, r1, ror #4
 d88:	62696c00 	rsbvs	r6, r9, #0, 24
 d8c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 d90:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 d94:	00000100 	andeq	r0, r0, r0, lsl #2
 d98:	02050000 	andeq	r0, r5, #0
 d9c:	00009740 	andeq	r9, r0, r0, asr #14
 da0:	0108ca03 	tsteq	r8, r3, lsl #20
 da4:	2f2f2f30 	svccs	0x002f2f30
 da8:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 dac:	2f1401d0 	svccs	0x001401d0
 db0:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 db4:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 db8:	2f2f661f 	svccs	0x002f661f
 dbc:	2f2f2f2f 	svccs	0x002f2f2f
 dc0:	0002022f 	andeq	r0, r2, pc, lsr #4
 dc4:	005c0101 	subseq	r0, ip, r1, lsl #2
 dc8:	00030000 	andeq	r0, r3, r0
 dcc:	00000046 	andeq	r0, r0, r6, asr #32
 dd0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 dd4:	0101000d 	tsteq	r1, sp
 dd8:	00000101 	andeq	r0, r0, r1, lsl #2
 ddc:	00000100 	andeq	r0, r0, r0, lsl #2
 de0:	2f2e2e01 	svccs	0x002e2e01
 de4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 de8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dec:	2f2e2e2f 	svccs	0x002e2e2f
 df0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d40 <shift+0xd40>
 df4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 df8:	6f632f63 	svcvs	0x00632f63
 dfc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e00:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e04:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e08:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 e0c:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 e10:	00010053 	andeq	r0, r1, r3, asr r0
 e14:	05000000 	streq	r0, [r0, #-0]
 e18:	00994c02 	addseq	r4, r9, r2, lsl #24
 e1c:	0bb40300 	bleq	fed01a24 <__bss_end+0xfecf7fec>
 e20:	00020201 	andeq	r0, r2, r1, lsl #4
 e24:	01030101 	tsteq	r3, r1, lsl #2
 e28:	00030000 	andeq	r0, r3, r0
 e2c:	000000fd 	strdeq	r0, [r0], -sp
 e30:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 e34:	0101000d 	tsteq	r1, sp
 e38:	00000101 	andeq	r0, r0, r1, lsl #2
 e3c:	00000100 	andeq	r0, r0, r0, lsl #2
 e40:	2f2e2e01 	svccs	0x002e2e01
 e44:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e48:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e4c:	2f2e2e2f 	svccs	0x002e2e2f
 e50:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; da0 <shift+0xda0>
 e54:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e58:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 e5c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 e60:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 e64:	2f2e2e00 	svccs	0x002e2e00
 e68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e70:	2f2e2e2f 	svccs	0x002e2e2f
 e74:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 e78:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 e7c:	2f2e2e2f 	svccs	0x002e2e2f
 e80:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e84:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e88:	2f2e2e2f 	svccs	0x002e2e2f
 e8c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 e90:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 e94:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 e98:	6f632f63 	svcvs	0x00632f63
 e9c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 ea0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 ea4:	2f2e2e00 	svccs	0x002e2e00
 ea8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 eac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 eb0:	2f2e2e2f 	svccs	0x002e2e2f
 eb4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e04 <shift+0xe04>
 eb8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ebc:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 ec0:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 ec4:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 ec8:	00000100 	andeq	r0, r0, r0, lsl #2
 ecc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 ed0:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 ed4:	00020068 	andeq	r0, r2, r8, rrx
 ed8:	6d726100 	ldfvse	f6, [r2, #-0]
 edc:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 ee0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ee4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 ee8:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 eec:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 ef0:	73746e61 	cmnvc	r4, #1552	; 0x610
 ef4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ef8:	72610000 	rsbvc	r0, r1, #0
 efc:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 f00:	6c000003 	stcvs	0, cr0, [r0], {3}
 f04:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 f08:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 f0c:	00000400 	andeq	r0, r0, r0, lsl #8
 f10:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 f14:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 f18:	00682e73 	rsbeq	r2, r8, r3, ror lr
 f1c:	6c000004 	stcvs	0, cr0, [r0], {4}
 f20:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 f24:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 f28:	00000400 	andeq	r0, r0, r0, lsl #8
	...

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
      58:	1df80704 	ldclne	7, cr0, [r8, #16]!
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
     128:	00001df8 	strdeq	r1, [r0], -r8
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408748>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x3675c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a420>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x3682c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6a54>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000e21 	andeq	r0, r0, r1, lsr #28
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000c9204 	andeq	r9, ip, r4, lsl #4
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0000dc00 	andeq	sp, r0, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	0bda0200 	bleq	ff680b00 <__bss_end+0xff6770c8>
     2fc:	04050000 	streq	r0, [r5], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	50030500 	andpl	r0, r3, r0, lsl #10
     308:	03000099 	movweq	r0, #153	; 0x99
     30c:	1bc20404 	blne	ff081324 <__bss_end+0xff0778ec>
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0d640801 	stcleq	8, cr0, [r4, #-4]!
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0dd80502 	cfldr64eq	mvdx0, [r8, #8]
     328:	04050000 	streq	r0, [r5], #-0
     32c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     330:	08010300 	stmdaeq	r1, {r8, r9}
     334:	00000d5b 	andeq	r0, r0, fp, asr sp
     338:	8d070203 	sfmhi	f0, 4, [r7, #-12]
     33c:	06000009 	streq	r0, [r0], -r9
     340:	00000e7c 	andeq	r0, r0, ip, ror lr
     344:	7c070903 			; <UNDEFINED> instruction: 0x7c070903
     348:	04000000 	streq	r0, [r0], #-0
     34c:	0000006b 	andeq	r0, r0, fp, rrx
     350:	f8070403 			; <UNDEFINED> instruction: 0xf8070403
     354:	0400001d 	streq	r0, [r0], #-29	; 0xffffffe3
     358:	0000007c 	andeq	r0, r0, ip, ror r0
     35c:	00007c07 	andeq	r7, r0, r7, lsl #24
     360:	07130800 	ldreq	r0, [r3, -r0, lsl #16]
     364:	02080000 	andeq	r0, r8, #0
     368:	00b30806 	adcseq	r0, r3, r6, lsl #16
     36c:	72090000 	andvc	r0, r9, #0
     370:	08020030 	stmdaeq	r2, {r4, r5}
     374:	00006b0e 	andeq	r6, r0, lr, lsl #22
     378:	72090000 	andvc	r0, r9, #0
     37c:	09020031 	stmdbeq	r2, {r0, r4, r5}
     380:	00006b0e 	andeq	r6, r0, lr, lsl #22
     384:	0a000400 	beq	138c <shift+0x138c>
     388:	00000571 	andeq	r0, r0, r1, ror r5
     38c:	00560405 	subseq	r0, r6, r5, lsl #8
     390:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     394:	0000ea0c 	andeq	lr, r0, ip, lsl #20
     398:	07c80b00 	strbeq	r0, [r8, r0, lsl #22]
     39c:	0b000000 	bleq	3a4 <shift+0x3a4>
     3a0:	00001292 	muleq	r0, r2, r2
     3a4:	125c0b01 	subsne	r0, ip, #1024	; 0x400
     3a8:	0b020000 	bleq	803b0 <__bss_end+0x76978>
     3ac:	00000a2f 	andeq	r0, r0, pc, lsr #20
     3b0:	0c830b03 	fstmiaxeq	r3, {d0}	;@ Deprecated
     3b4:	0b040000 	bleq	1003bc <__bss_end+0xf6984>
     3b8:	00000791 	muleq	r0, r1, r7
     3bc:	590a0005 	stmdbpl	sl, {r0, r2}
     3c0:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     3c4:	00005604 	andeq	r5, r0, r4, lsl #12
     3c8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3d0 <shift+0x3d0>
     3cc:	00000127 	andeq	r0, r0, r7, lsr #2
     3d0:	00041b0b 	andeq	r1, r4, fp, lsl #22
     3d4:	ad0b0000 	stcge	0, cr0, [fp, #-0]
     3d8:	01000005 	tsteq	r0, r5
     3dc:	000c3e0b 	andeq	r3, ip, fp, lsl #28
     3e0:	0d0b0200 	sfmeq	f0, 4, [fp, #-0]
     3e4:	03000012 	movweq	r0, #18
     3e8:	00129c0b 	andseq	r9, r2, fp, lsl #24
     3ec:	4f0b0400 	svcmi	0x000b0400
     3f0:	0500000b 	streq	r0, [r0, #-11]
     3f4:	0009ad0b 	andeq	sl, r9, fp, lsl #26
     3f8:	0a000600 	beq	1c00 <shift+0x1c00>
     3fc:	00001113 	andeq	r1, r0, r3, lsl r1
     400:	00560405 	subseq	r0, r6, r5, lsl #8
     404:	66020000 	strvs	r0, [r2], -r0
     408:	0001520c 	andeq	r5, r1, ip, lsl #4
     40c:	0d390b00 	vldmdbeq	r9!, {d0-d-1}
     410:	0b000000 	bleq	418 <shift+0x418>
     414:	0000096f 	andeq	r0, r0, pc, ror #18
     418:	0de20b01 			; <UNDEFINED> instruction: 0x0de20b01
     41c:	0b020000 	bleq	80424 <__bss_end+0x769ec>
     420:	000009b2 			; <UNDEFINED> instruction: 0x000009b2
     424:	0a060003 	beq	180438 <__bss_end+0x176a00>
     428:	04000006 	streq	r0, [r0], #-6
     42c:	00560703 	subseq	r0, r6, r3, lsl #14
     430:	a7020000 	strge	r0, [r2, -r0]
     434:	0400000b 	streq	r0, [r0], #-11
     438:	00771405 	rsbseq	r1, r7, r5, lsl #8
     43c:	03050000 	movweq	r0, #20480	; 0x5000
     440:	00009954 	andeq	r9, r0, r4, asr r9
     444:	000bf602 	andeq	pc, fp, r2, lsl #12
     448:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     44c:	00000077 	andeq	r0, r0, r7, ror r0
     450:	99580305 	ldmdbls	r8, {r0, r2, r8, r9}^
     454:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
     458:	0600000b 	streq	r0, [r0], -fp
     45c:	00771a07 	rsbseq	r1, r7, r7, lsl #20
     460:	03050000 	movweq	r0, #20480	; 0x5000
     464:	0000995c 	andeq	r9, r0, ip, asr r9
     468:	0005dc02 	andeq	sp, r5, r2, lsl #24
     46c:	1a090600 	bne	241c74 <__bss_end+0x23823c>
     470:	00000077 	andeq	r0, r0, r7, ror r0
     474:	99600305 	stmdbls	r0!, {r0, r2, r8, r9}^
     478:	4d020000 	stcmi	0, cr0, [r2, #-0]
     47c:	0600000d 	streq	r0, [r0], -sp
     480:	00771a0b 	rsbseq	r1, r7, fp, lsl #20
     484:	03050000 	movweq	r0, #20480	; 0x5000
     488:	00009964 	andeq	r9, r0, r4, ror #18
     48c:	00095c02 	andeq	r5, r9, r2, lsl #24
     490:	1a0d0600 	bne	341c98 <__bss_end+0x338260>
     494:	00000077 	andeq	r0, r0, r7, ror r0
     498:	99680305 	stmdbls	r8!, {r0, r2, r8, r9}^
     49c:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
     4a0:	06000007 	streq	r0, [r0], -r7
     4a4:	00771a0f 	rsbseq	r1, r7, pc, lsl #20
     4a8:	03050000 	movweq	r0, #20480	; 0x5000
     4ac:	0000996c 	andeq	r9, r0, ip, ror #18
     4b0:	000edc0a 	andeq	sp, lr, sl, lsl #24
     4b4:	56040500 	strpl	r0, [r4], -r0, lsl #10
     4b8:	06000000 	streq	r0, [r0], -r0
     4bc:	02010c1b 	andeq	r0, r1, #6912	; 0x1b00
     4c0:	480b0000 	stmdami	fp, {}	; <UNPREDICTABLE>
     4c4:	0000000f 	andeq	r0, r0, pc
     4c8:	00124c0b 	andseq	r4, r2, fp, lsl #24
     4cc:	390b0100 	stmdbcc	fp, {r8}
     4d0:	0200000c 	andeq	r0, r0, #12
     4d4:	0d1e0c00 	ldceq	12, cr0, [lr, #-0]
     4d8:	bd0d0000 	stclt	0, cr0, [sp, #-0]
     4dc:	9000000d 	andls	r0, r0, sp
     4e0:	74076306 	strvc	r6, [r7], #-774	; 0xfffffcfa
     4e4:	08000003 	stmdaeq	r0, {r0, r1}
     4e8:	000011af 	andeq	r1, r0, pc, lsr #3
     4ec:	10670624 	rsbne	r0, r7, r4, lsr #12
     4f0:	0000028e 	andeq	r0, r0, lr, lsl #5
     4f4:	0021680e 	eoreq	r6, r1, lr, lsl #16
     4f8:	12690600 	rsbne	r0, r9, #0, 12
     4fc:	00000374 	andeq	r0, r0, r4, ror r3
     500:	05650e00 	strbeq	r0, [r5, #-3584]!	; 0xfffff200
     504:	6b060000 	blvs	18050c <__bss_end+0x176ad4>
     508:	00038412 	andeq	r8, r3, r2, lsl r4
     50c:	3d0e1000 	stccc	0, cr1, [lr, #-0]
     510:	0600000f 	streq	r0, [r0], -pc
     514:	006b166d 	rsbeq	r1, fp, sp, ror #12
     518:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     51c:	000005d5 	ldrdeq	r0, [r0], -r5
     520:	8b1c7006 	blhi	71c540 <__bss_end+0x712b08>
     524:	18000003 	stmdane	r0, {r0, r1}
     528:	000d440e 	andeq	r4, sp, lr, lsl #8
     52c:	1c720600 	ldclne	6, cr0, [r2], #-0
     530:	0000038b 	andeq	r0, r0, fp, lsl #7
     534:	05390e1c 	ldreq	r0, [r9, #-3612]!	; 0xfffff1e4
     538:	75060000 	strvc	r0, [r6, #-0]
     53c:	00038b1c 	andeq	r8, r3, ip, lsl fp
     540:	da0f2000 	ble	3c8548 <__bss_end+0x3beb10>
     544:	06000007 	streq	r0, [r0], -r7
     548:	04671c77 	strbteq	r1, [r7], #-3191	; 0xfffff389
     54c:	038b0000 	orreq	r0, fp, #0
     550:	02820000 	addeq	r0, r2, #0
     554:	8b100000 	blhi	40055c <__bss_end+0x3f6b24>
     558:	11000003 	tstne	r0, r3
     55c:	00000391 	muleq	r0, r1, r3
     560:	4e080000 	cdpmi	0, 0, cr0, cr8, cr0, {0}
     564:	18000006 	stmdane	r0, {r1, r2}
     568:	c3107b06 	tstgt	r0, #6144	; 0x1800
     56c:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     570:	00002168 	andeq	r2, r0, r8, ror #2
     574:	74127e06 	ldrvc	r7, [r2], #-3590	; 0xfffff1fa
     578:	00000003 	andeq	r0, r0, r3
     57c:	00055a0e 	andeq	r5, r5, lr, lsl #20
     580:	19800600 	stmibne	r0, {r9, sl}
     584:	00000391 	muleq	r0, r1, r3
     588:	12130e10 	andsne	r0, r3, #16, 28	; 0x100
     58c:	82060000 	andhi	r0, r6, #0
     590:	00039c21 	andeq	r9, r3, r1, lsr #24
     594:	04001400 	streq	r1, [r0], #-1024	; 0xfffffc00
     598:	0000028e 	andeq	r0, r0, lr, lsl #5
     59c:	000ae312 	andeq	lr, sl, r2, lsl r3
     5a0:	21860600 	orrcs	r0, r6, r0, lsl #12
     5a4:	000003a2 	andeq	r0, r0, r2, lsr #7
     5a8:	00088f12 	andeq	r8, r8, r2, lsl pc
     5ac:	1f880600 	svcne	0x00880600
     5b0:	00000077 	andeq	r0, r0, r7, ror r0
     5b4:	000e200e 	andeq	r2, lr, lr
     5b8:	178b0600 	strne	r0, [fp, r0, lsl #12]
     5bc:	00000213 	andeq	r0, r0, r3, lsl r2
     5c0:	0a350e00 	beq	d43dc8 <__bss_end+0xd3a390>
     5c4:	8e060000 	cdphi	0, 0, cr0, cr6, cr0, {0}
     5c8:	00021317 	andeq	r1, r2, r7, lsl r3
     5cc:	fa0e2400 	blx	3895d4 <__bss_end+0x37fb9c>
     5d0:	06000008 	streq	r0, [r0], -r8
     5d4:	0213178f 	andseq	r1, r3, #37486592	; 0x23c0000
     5d8:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5dc:	0000127c 	andeq	r1, r0, ip, ror r2
     5e0:	13179006 	tstne	r7, #6
     5e4:	6c000002 	stcvs	0, cr0, [r0], {2}
     5e8:	000dbd13 	andeq	fp, sp, r3, lsl sp
     5ec:	09930600 	ldmibeq	r3, {r9, sl}
     5f0:	00000639 	andeq	r0, r0, r9, lsr r6
     5f4:	000003ad 	andeq	r0, r0, sp, lsr #7
     5f8:	00032d01 	andeq	r2, r3, r1, lsl #26
     5fc:	00033300 	andeq	r3, r3, r0, lsl #6
     600:	03ad1000 			; <UNDEFINED> instruction: 0x03ad1000
     604:	14000000 	strne	r0, [r0], #-0
     608:	00000ad8 	ldrdeq	r0, [r0], -r8
     60c:	eb0e9606 	bl	3a5e2c <__bss_end+0x39c3f4>
     610:	01000009 	tsteq	r0, r9
     614:	00000348 	andeq	r0, r0, r8, asr #6
     618:	0000034e 	andeq	r0, r0, lr, asr #6
     61c:	0003ad10 	andeq	sl, r3, r0, lsl sp
     620:	1b150000 	blne	540628 <__bss_end+0x536bf0>
     624:	06000004 	streq	r0, [r0], -r4
     628:	0ec11099 	mcreq	0, 6, r1, cr1, cr9, {4}
     62c:	03b30000 			; <UNDEFINED> instruction: 0x03b30000
     630:	63010000 	movwvs	r0, #4096	; 0x1000
     634:	10000003 	andne	r0, r0, r3
     638:	000003ad 	andeq	r0, r0, sp, lsr #7
     63c:	00039111 	andeq	r9, r3, r1, lsl r1
     640:	01dc1100 	bicseq	r1, ip, r0, lsl #2
     644:	00000000 	andeq	r0, r0, r0
     648:	00004316 	andeq	r4, r0, r6, lsl r3
     64c:	00038400 	andeq	r8, r3, r0, lsl #8
     650:	007c1700 	rsbseq	r1, ip, r0, lsl #14
     654:	000f0000 	andeq	r0, pc, r0
     658:	3f020103 	svccc	0x00020103
     65c:	1800000a 	stmdane	r0, {r1, r3}
     660:	00021304 	andeq	r1, r2, r4, lsl #6
     664:	4a041800 	bmi	10666c <__bss_end+0xfcc34>
     668:	0c000000 	stceq	0, cr0, [r0], {-0}
     66c:	0000121f 	andeq	r1, r0, pc, lsl r2
     670:	03970418 	orrseq	r0, r7, #24, 8	; 0x18000000
     674:	c3160000 	tstgt	r6, #0
     678:	ad000002 	stcge	0, cr0, [r0, #-8]
     67c:	19000003 	stmdbne	r0, {r0, r1}
     680:	06041800 	streq	r1, [r4], -r0, lsl #16
     684:	18000002 	stmdane	r0, {r1}
     688:	00020104 	andeq	r0, r2, r4, lsl #2
     68c:	0e261a00 	vmuleq.f32	s2, s12, s0
     690:	9c060000 	stcls	0, cr0, [r6], {-0}
     694:	00020614 	andeq	r0, r2, r4, lsl r6
     698:	083b0200 	ldmdaeq	fp!, {r9}
     69c:	04070000 	streq	r0, [r7], #-0
     6a0:	00007714 	andeq	r7, r0, r4, lsl r7
     6a4:	70030500 	andvc	r0, r3, r0, lsl #10
     6a8:	02000099 	andeq	r0, r0, #153	; 0x99
     6ac:	000003a6 	andeq	r0, r0, r6, lsr #7
     6b0:	77140707 	ldrvc	r0, [r4, -r7, lsl #14]
     6b4:	05000000 	streq	r0, [r0, #-0]
     6b8:	00997403 	addseq	r7, r9, r3, lsl #8
     6bc:	06150200 	ldreq	r0, [r5], -r0, lsl #4
     6c0:	0a070000 	beq	1c06c8 <__bss_end+0x1b6c90>
     6c4:	00007714 	andeq	r7, r0, r4, lsl r7
     6c8:	78030500 	stmdavc	r3, {r8, sl}
     6cc:	0a000099 	beq	938 <shift+0x938>
     6d0:	00000aa8 	andeq	r0, r0, r8, lsr #21
     6d4:	00560405 	subseq	r0, r6, r5, lsl #8
     6d8:	0d070000 	stceq	0, cr0, [r7, #-0]
     6dc:	0004320c 	andeq	r3, r4, ip, lsl #4
     6e0:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6e4:	0b000077 	bleq	8c8 <shift+0x8c8>
     6e8:	00000a9f 	muleq	r0, pc, sl	; <UNPREDICTABLE>
     6ec:	0e380b01 	vaddeq.f64	d0, d8, d1
     6f0:	0b020000 	bleq	806f8 <__bss_end+0x76cc0>
     6f4:	00000a5a 	andeq	r0, r0, sl, asr sl
     6f8:	0a210b03 	beq	84330c <__bss_end+0x8398d4>
     6fc:	0b040000 	bleq	100704 <__bss_end+0xf6ccc>
     700:	00000c44 	andeq	r0, r0, r4, asr #24
     704:	84080005 	strhi	r0, [r8], #-5
     708:	10000007 	andne	r0, r0, r7
     70c:	71081b07 	tstvc	r8, r7, lsl #22
     710:	09000004 	stmdbeq	r0, {r2}
     714:	0700726c 	streq	r7, [r0, -ip, ror #4]
     718:	0471131d 	ldrbteq	r1, [r1], #-797	; 0xfffffce3
     71c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     720:	07007073 	smlsdxeq	r0, r3, r0, r7
     724:	0471131e 	ldrbteq	r1, [r1], #-798	; 0xfffffce2
     728:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     72c:	07006370 	smlsdxeq	r0, r0, r3, r6
     730:	0471131f 	ldrbteq	r1, [r1], #-799	; 0xfffffce1
     734:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     738:	0000079a 	muleq	r0, sl, r7
     73c:	71132007 	tstvc	r3, r7
     740:	0c000004 	stceq	0, cr0, [r0], {4}
     744:	07040300 	streq	r0, [r4, -r0, lsl #6]
     748:	00001df3 	strdeq	r1, [r0], -r3
     74c:	00047104 	andeq	r7, r4, r4, lsl #2
     750:	045a0800 	ldrbeq	r0, [sl], #-2048	; 0xfffff800
     754:	07700000 	ldrbeq	r0, [r0, -r0]!
     758:	050d0828 	streq	r0, [sp, #-2088]	; 0xfffff7d8
     75c:	860e0000 	strhi	r0, [lr], -r0
     760:	07000012 	smladeq	r0, r2, r0, r0
     764:	0432122a 	ldrteq	r1, [r2], #-554	; 0xfffffdd6
     768:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     76c:	00646970 	rsbeq	r6, r4, r0, ror r9
     770:	7c122b07 			; <UNDEFINED> instruction: 0x7c122b07
     774:	10000000 	andne	r0, r0, r0
     778:	001b440e 	andseq	r4, fp, lr, lsl #8
     77c:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
     780:	000003fb 	strdeq	r0, [r0], -fp
     784:	0ab40e14 	beq	fed03fdc <__bss_end+0xfecfa5a4>
     788:	2d070000 	stccs	0, cr0, [r7, #-0]
     78c:	00007c12 	andeq	r7, r0, r2, lsl ip
     790:	c20e1800 	andgt	r1, lr, #0, 16
     794:	0700000a 	streq	r0, [r0, -sl]
     798:	007c122e 	rsbseq	r1, ip, lr, lsr #4
     79c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     7a0:	0000072c 	andeq	r0, r0, ip, lsr #14
     7a4:	0d0c2f07 	stceq	15, cr2, [ip, #-28]	; 0xffffffe4
     7a8:	20000005 	andcs	r0, r0, r5
     7ac:	000aef0e 	andeq	lr, sl, lr, lsl #30
     7b0:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
     7b4:	00000056 	andeq	r0, r0, r6, asr r0
     7b8:	0f670e60 	svceq	0x00670e60
     7bc:	31070000 	mrscc	r0, (UNDEF: 7)
     7c0:	00006b0e 	andeq	r6, r0, lr, lsl #22
     7c4:	ee0e6400 	cfcpys	mvf6, mvf14
     7c8:	07000007 	streq	r0, [r0, -r7]
     7cc:	006b0e33 	rsbeq	r0, fp, r3, lsr lr
     7d0:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7d4:	000007e5 	andeq	r0, r0, r5, ror #15
     7d8:	6b0e3407 	blvs	38d7fc <__bss_end+0x383dc4>
     7dc:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7e0:	03b31600 			; <UNDEFINED> instruction: 0x03b31600
     7e4:	051d0000 	ldreq	r0, [sp, #-0]
     7e8:	7c170000 	ldcvc	0, cr0, [r7], {-0}
     7ec:	0f000000 	svceq	0x00000000
     7f0:	11a00200 	lslne	r0, r0, #4
     7f4:	0a080000 	beq	2007fc <__bss_end+0x1f6dc4>
     7f8:	00007714 	andeq	r7, r0, r4, lsl r7
     7fc:	7c030500 	cfstr32vc	mvfx0, [r3], {-0}
     800:	0a000099 	beq	a6c <shift+0xa6c>
     804:	00000a62 	andeq	r0, r0, r2, ror #20
     808:	00560405 	subseq	r0, r6, r5, lsl #8
     80c:	0d080000 	stceq	0, cr0, [r8, #-0]
     810:	00054e0c 	andeq	r4, r5, ip, lsl #28
     814:	05860b00 	streq	r0, [r6, #2816]	; 0xb00
     818:	0b000000 	bleq	820 <shift+0x820>
     81c:	0000039b 	muleq	r0, fp, r3
     820:	5b080001 	blpl	20082c <__bss_end+0x1f6df4>
     824:	0c000010 	stceq	0, cr0, [r0], {16}
     828:	83081b08 	movwhi	r1, #35592	; 0x8b08
     82c:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     830:	0000042c 	andeq	r0, r0, ip, lsr #8
     834:	83191d08 	tsthi	r9, #8, 26	; 0x200
     838:	00000005 	andeq	r0, r0, r5
     83c:	0005390e 	andeq	r3, r5, lr, lsl #18
     840:	191e0800 	ldmdbne	lr, {fp}
     844:	00000583 	andeq	r0, r0, r3, lsl #11
     848:	0fdb0e04 	svceq	0x00db0e04
     84c:	1f080000 	svcne	0x00080000
     850:	00058913 	andeq	r8, r5, r3, lsl r9
     854:	18000800 	stmdane	r0, {fp}
     858:	00054e04 	andeq	r4, r5, r4, lsl #28
     85c:	7d041800 	stcvc	8, cr1, [r4, #-0]
     860:	0d000004 	stceq	0, cr0, [r0, #-16]
     864:	00000628 	andeq	r0, r0, r8, lsr #12
     868:	07220814 			; <UNDEFINED> instruction: 0x07220814
     86c:	00000811 	andeq	r0, r0, r1, lsl r8
     870:	000a500e 	andeq	r5, sl, lr
     874:	12260800 	eorne	r0, r6, #0, 16
     878:	0000006b 	andeq	r0, r0, fp, rrx
     87c:	04d30e00 	ldrbeq	r0, [r3], #3584	; 0xe00
     880:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
     884:	0005831d 	andeq	r8, r5, sp, lsl r3
     888:	ae0e0400 	cfcpysge	mvf0, mvf14
     88c:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     890:	05831d2c 	streq	r1, [r3, #3372]	; 0xd2c
     894:	1c080000 	stcne	0, cr0, [r8], {-0}
     898:	0000114f 	andeq	r1, r0, pc, asr #2
     89c:	380e2f08 	stmdacc	lr, {r3, r8, r9, sl, fp, sp}
     8a0:	d7000010 	smladle	r0, r0, r0, r0
     8a4:	e2000005 	and	r0, r0, #5
     8a8:	10000005 	andne	r0, r0, r5
     8ac:	00000816 	andeq	r0, r0, r6, lsl r8
     8b0:	00058311 	andeq	r8, r5, r1, lsl r3
     8b4:	f11d0000 			; <UNDEFINED> instruction: 0xf11d0000
     8b8:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     8bc:	04310e31 	ldrteq	r0, [r1], #-3633	; 0xfffff1cf
     8c0:	03840000 	orreq	r0, r4, #0
     8c4:	05fa0000 	ldrbeq	r0, [sl, #0]!
     8c8:	06050000 	streq	r0, [r5], -r0
     8cc:	16100000 	ldrne	r0, [r0], -r0
     8d0:	11000008 	tstne	r0, r8
     8d4:	00000589 	andeq	r0, r0, r9, lsl #11
     8d8:	109d1300 	addsne	r1, sp, r0, lsl #6
     8dc:	35080000 	strcc	r0, [r8, #-0]
     8e0:	000fb61d 	andeq	fp, pc, sp, lsl r6	; <UNPREDICTABLE>
     8e4:	00058300 	andeq	r8, r5, r0, lsl #6
     8e8:	061e0200 	ldreq	r0, [lr], -r0, lsl #4
     8ec:	06240000 	strteq	r0, [r4], -r0
     8f0:	16100000 	ldrne	r0, [r0], -r0
     8f4:	00000008 	andeq	r0, r0, r8
     8f8:	0009a013 	andeq	sl, r9, r3, lsl r0
     8fc:	1d370800 	ldcne	8, cr0, [r7, #-0]
     900:	00000d97 	muleq	r0, r7, sp
     904:	00000583 	andeq	r0, r0, r3, lsl #11
     908:	00063d02 	andeq	r3, r6, r2, lsl #26
     90c:	00064300 	andeq	r4, r6, r0, lsl #6
     910:	08161000 	ldmdaeq	r6, {ip}
     914:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     918:	00000b1f 	andeq	r0, r0, pc, lsl fp
     91c:	2f313908 	svccs	0x00313908
     920:	0c000008 	stceq	0, cr0, [r0], {8}
     924:	06281302 	strteq	r1, [r8], -r2, lsl #6
     928:	3c080000 	stccc	0, cr0, [r8], {-0}
     92c:	00126209 	andseq	r6, r2, r9, lsl #4
     930:	00081600 	andeq	r1, r8, r0, lsl #12
     934:	066a0100 	strbteq	r0, [sl], -r0, lsl #2
     938:	06700000 	ldrbteq	r0, [r0], -r0
     93c:	16100000 	ldrne	r0, [r0], -r0
     940:	00000008 	andeq	r0, r0, r8
     944:	0005c013 	andeq	ip, r5, r3, lsl r0
     948:	123f0800 	eorsne	r0, pc, #0, 16
     94c:	00001124 	andeq	r1, r0, r4, lsr #2
     950:	0000006b 	andeq	r0, r0, fp, rrx
     954:	00068901 	andeq	r8, r6, r1, lsl #18
     958:	00069e00 	andeq	r9, r6, r0, lsl #28
     95c:	08161000 	ldmdaeq	r6, {ip}
     960:	38110000 	ldmdacc	r1, {}	; <UNPREDICTABLE>
     964:	11000008 	tstne	r0, r8
     968:	0000007c 	andeq	r0, r0, ip, ror r0
     96c:	00038411 	andeq	r8, r3, r1, lsl r4
     970:	00140000 	andseq	r0, r4, r0
     974:	08000010 	stmdaeq	r0, {r4}
     978:	0cd00e42 	ldcleq	14, cr0, [r0], {66}	; 0x42
     97c:	b3010000 	movwlt	r0, #4096	; 0x1000
     980:	b9000006 	stmdblt	r0, {r1, r2}
     984:	10000006 	andne	r0, r0, r6
     988:	00000816 	andeq	r0, r0, r6, lsl r8
     98c:	09041300 	stmdbeq	r4, {r8, r9, ip}
     990:	45080000 	strmi	r0, [r8, #-0]
     994:	0004f817 	andeq	pc, r4, r7, lsl r8	; <UNPREDICTABLE>
     998:	00058900 	andeq	r8, r5, r0, lsl #18
     99c:	06d20100 	ldrbeq	r0, [r2], r0, lsl #2
     9a0:	06d80000 	ldrbeq	r0, [r8], r0
     9a4:	3e100000 	cdpcc	0, 1, cr0, cr0, cr0, {0}
     9a8:	00000008 	andeq	r0, r0, r8
     9ac:	00054713 	andeq	r4, r5, r3, lsl r7
     9b0:	17480800 	strbne	r0, [r8, -r0, lsl #16]
     9b4:	00000f73 	andeq	r0, r0, r3, ror pc
     9b8:	00000589 	andeq	r0, r0, r9, lsl #11
     9bc:	0006f101 	andeq	pc, r6, r1, lsl #2
     9c0:	0006fc00 	andeq	pc, r6, r0, lsl #24
     9c4:	083e1000 	ldmdaeq	lr!, {ip}
     9c8:	6b110000 	blvs	4409d0 <__bss_end+0x436f98>
     9cc:	00000000 	andeq	r0, r0, r0
     9d0:	0011bd14 	andseq	fp, r1, r4, lsl sp
     9d4:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
     9d8:	00001009 	andeq	r1, r0, r9
     9dc:	00071101 	andeq	r1, r7, r1, lsl #2
     9e0:	00071700 	andeq	r1, r7, r0, lsl #14
     9e4:	08161000 	ldmdaeq	r6, {ip}
     9e8:	13000000 	movwne	r0, #0
     9ec:	00000ff1 	strdeq	r0, [r0], -r1
     9f0:	a00e4d08 	andge	r4, lr, r8, lsl #26
     9f4:	84000007 	strhi	r0, [r0], #-7
     9f8:	01000003 	tsteq	r0, r3
     9fc:	00000730 	andeq	r0, r0, r0, lsr r7
     a00:	0000073b 	andeq	r0, r0, fp, lsr r7
     a04:	00081610 	andeq	r1, r8, r0, lsl r6
     a08:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a0c:	13000000 	movwne	r0, #0
     a10:	00000918 	andeq	r0, r0, r8, lsl r9
     a14:	f1125008 			; <UNDEFINED> instruction: 0xf1125008
     a18:	6b00000c 	blvs	a50 <shift+0xa50>
     a1c:	01000000 	mrseq	r0, (UNDEF: 0)
     a20:	00000754 	andeq	r0, r0, r4, asr r7
     a24:	0000075f 	andeq	r0, r0, pc, asr r7
     a28:	00081610 	andeq	r1, r8, r0, lsl r6
     a2c:	03b31100 			; <UNDEFINED> instruction: 0x03b31100
     a30:	13000000 	movwne	r0, #0
     a34:	00000497 	muleq	r0, r7, r4
     a38:	540e5308 	strpl	r5, [lr], #-776	; 0xfffffcf8
     a3c:	84000008 	strhi	r0, [r0], #-8
     a40:	01000003 	tsteq	r0, r3
     a44:	00000778 	andeq	r0, r0, r8, ror r7
     a48:	00000783 	andeq	r0, r0, r3, lsl #15
     a4c:	00081610 	andeq	r1, r8, r0, lsl r6
     a50:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a54:	14000000 	strne	r0, [r0], #-0
     a58:	0000097a 	andeq	r0, r0, sl, ror r9
     a5c:	bc0e5608 	stclt	6, cr5, [lr], {8}
     a60:	01000010 	tsteq	r0, r0, lsl r0
     a64:	00000798 	muleq	r0, r8, r7
     a68:	000007b7 			; <UNDEFINED> instruction: 0x000007b7
     a6c:	00081610 	andeq	r1, r8, r0, lsl r6
     a70:	00b31100 	adcseq	r1, r3, r0, lsl #2
     a74:	6b110000 	blvs	440a7c <__bss_end+0x437044>
     a78:	11000000 	mrsne	r0, (UNDEF: 0)
     a7c:	0000006b 	andeq	r0, r0, fp, rrx
     a80:	00006b11 	andeq	r6, r0, r1, lsl fp
     a84:	08441100 	stmdaeq	r4, {r8, ip}^
     a88:	14000000 	strne	r0, [r0], #-0
     a8c:	00000fa0 	andeq	r0, r0, r0, lsr #31
     a90:	c70e5808 	strgt	r5, [lr, -r8, lsl #16]
     a94:	01000006 	tsteq	r0, r6
     a98:	000007cc 	andeq	r0, r0, ip, asr #15
     a9c:	000007eb 	andeq	r0, r0, fp, ror #15
     aa0:	00081610 	andeq	r1, r8, r0, lsl r6
     aa4:	00ea1100 	rsceq	r1, sl, r0, lsl #2
     aa8:	6b110000 	blvs	440ab0 <__bss_end+0x437078>
     aac:	11000000 	mrsne	r0, (UNDEF: 0)
     ab0:	0000006b 	andeq	r0, r0, fp, rrx
     ab4:	00006b11 	andeq	r6, r0, r1, lsl fp
     ab8:	08441100 	stmdaeq	r4, {r8, ip}^
     abc:	15000000 	strne	r0, [r0, #-0]
     ac0:	000005f7 	strdeq	r0, [r0], -r7
     ac4:	590e5b08 	stmdbpl	lr, {r3, r8, r9, fp, ip, lr}
     ac8:	84000006 	strhi	r0, [r0], #-6
     acc:	01000003 	tsteq	r0, r3
     ad0:	00000800 	andeq	r0, r0, r0, lsl #16
     ad4:	00081610 	andeq	r1, r8, r0, lsl r6
     ad8:	052f1100 	streq	r1, [pc, #-256]!	; 9e0 <shift+0x9e0>
     adc:	4a110000 	bmi	440ae4 <__bss_end+0x4370ac>
     ae0:	00000008 	andeq	r0, r0, r8
     ae4:	058f0400 	streq	r0, [pc, #1024]	; eec <shift+0xeec>
     ae8:	04180000 	ldreq	r0, [r8], #-0
     aec:	0000058f 	andeq	r0, r0, pc, lsl #11
     af0:	0005831f 	andeq	r8, r5, pc, lsl r3
     af4:	00082900 	andeq	r2, r8, r0, lsl #18
     af8:	00082f00 	andeq	r2, r8, r0, lsl #30
     afc:	08161000 	ldmdaeq	r6, {ip}
     b00:	20000000 	andcs	r0, r0, r0
     b04:	0000058f 	andeq	r0, r0, pc, lsl #11
     b08:	0000081c 	andeq	r0, r0, ip, lsl r8
     b0c:	005d0418 	subseq	r0, sp, r8, lsl r4
     b10:	04180000 	ldreq	r0, [r8], #-0
     b14:	00000811 	andeq	r0, r0, r1, lsl r8
     b18:	008d0421 	addeq	r0, sp, r1, lsr #8
     b1c:	04220000 	strteq	r0, [r2], #-0
     b20:	000b2d1a 	andeq	r2, fp, sl, lsl sp
     b24:	195e0800 	ldmdbne	lr, {fp}^
     b28:	0000058f 	andeq	r0, r0, pc, lsl #11
     b2c:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b30:	0b050900 	bleq	142f38 <__bss_end+0x139500>
     b34:	00000912 	andeq	r0, r0, r2, lsl r9
     b38:	000b5624 	andeq	r5, fp, r4, lsr #12
     b3c:	19070900 	stmdbne	r7, {r8, fp}
     b40:	00000083 	andeq	r0, r0, r3, lsl #1
     b44:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b48:	000e1024 	andeq	r1, lr, r4, lsr #32
     b4c:	1a0a0900 	bne	282f54 <__bss_end+0x27951c>
     b50:	00000478 	andeq	r0, r0, r8, ror r4
     b54:	20000000 	andcs	r0, r0, r0
     b58:	000bb524 	andeq	fp, fp, r4, lsr #10
     b5c:	1a0d0900 	bne	342f64 <__bss_end+0x33952c>
     b60:	00000478 	andeq	r0, r0, r8, ror r4
     b64:	20200000 	eorcs	r0, r0, r0
     b68:	000dc925 	andeq	ip, sp, r5, lsr #18
     b6c:	15100900 	ldrne	r0, [r0, #-2304]	; 0xfffff700
     b70:	00000077 	andeq	r0, r0, r7, ror r0
     b74:	05ee2436 	strbeq	r2, [lr, #1078]!	; 0x436
     b78:	4b090000 	blmi	240b80 <__bss_end+0x237148>
     b7c:	0004781a 	andeq	r7, r4, sl, lsl r8
     b80:	21500000 	cmpcs	r0, r0
     b84:	07f72420 	ldrbeq	r2, [r7, r0, lsr #8]!
     b88:	7a090000 	bvc	240b90 <__bss_end+0x237158>
     b8c:	0004781a 	andeq	r7, r4, sl, lsl r8
     b90:	00b20000 	adcseq	r0, r2, r0
     b94:	0ea32420 	cdpeq	4, 10, cr2, cr3, cr0, {1}
     b98:	ad090000 	stcge	0, cr0, [r9, #-0]
     b9c:	0004781a 	andeq	r7, r4, sl, lsl r8
     ba0:	00b40000 	adcseq	r0, r4, r0
     ba4:	08802420 	stmeq	r0, {r5, sl, sp}
     ba8:	bc090000 	stclt	0, cr0, [r9], {-0}
     bac:	0004781a 	andeq	r7, r4, sl, lsl r8
     bb0:	10400000 	subne	r0, r0, r0
     bb4:	07d02420 	ldrbeq	r2, [r0, r0, lsr #8]
     bb8:	c7090000 	strgt	r0, [r9, -r0]
     bbc:	0004781a 	andeq	r7, r4, sl, lsl r8
     bc0:	20500000 	subscs	r0, r0, r0
     bc4:	08312420 	ldmdaeq	r1!, {r5, sl, sp}
     bc8:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
     bcc:	0004781a 	andeq	r7, r4, sl, lsl r8
     bd0:	80400000 	subhi	r0, r0, r0
     bd4:	04c92420 	strbeq	r2, [r9], #1056	; 0x420
     bd8:	c9090000 	stmdbgt	r9, {}	; <UNPREDICTABLE>
     bdc:	0004781a 	andeq	r7, r4, sl, lsl r8
     be0:	80500000 	subshi	r0, r0, r0
     be4:	64260020 	strtvs	r0, [r6], #-32	; 0xffffffe0
     be8:	26000008 	strcs	r0, [r0], -r8
     bec:	00000874 	andeq	r0, r0, r4, ror r8
     bf0:	00088426 	andeq	r8, r8, r6, lsr #8
     bf4:	08942600 	ldmeq	r4, {r9, sl, sp}
     bf8:	a1260000 			; <UNDEFINED> instruction: 0xa1260000
     bfc:	26000008 	strcs	r0, [r0], -r8
     c00:	000008b1 			; <UNDEFINED> instruction: 0x000008b1
     c04:	0008c126 	andeq	ip, r8, r6, lsr #2
     c08:	08d12600 	ldmeq	r1, {r9, sl, sp}^
     c0c:	e1260000 			; <UNDEFINED> instruction: 0xe1260000
     c10:	26000008 	strcs	r0, [r0], -r8
     c14:	000008f1 	strdeq	r0, [r0], -r1
     c18:	00090126 	andeq	r0, r9, r6, lsr #2
     c1c:	0af90200 	beq	ffe41424 <__bss_end+0xffe379ec>
     c20:	080a0000 	stmdaeq	sl, {}	; <UNPREDICTABLE>
     c24:	00007714 	andeq	r7, r0, r4, lsl r7
     c28:	ac030500 	cfstr32ge	mvfx0, [r3], {-0}
     c2c:	0a000099 	beq	e98 <shift+0xe98>
     c30:	00000c74 	andeq	r0, r0, r4, ror ip
     c34:	007c0407 	rsbseq	r0, ip, r7, lsl #8
     c38:	0b0a0000 	bleq	280c40 <__bss_end+0x277208>
     c3c:	0009a40c 	andeq	sl, r9, ip, lsl #8
     c40:	0feb0b00 	svceq	0x00eb0b00
     c44:	0b000000 	bleq	c4c <shift+0xc4c>
     c48:	00000c32 	andeq	r0, r0, r2, lsr ip
     c4c:	0a770b01 	beq	1dc3858 <__bss_end+0x1db9e20>
     c50:	0b020000 	bleq	80c58 <__bss_end+0x77220>
     c54:	00000426 	andeq	r0, r0, r6, lsr #8
     c58:	04150b03 	ldreq	r0, [r5], #-2819	; 0xfffff4fd
     c5c:	0b040000 	bleq	100c64 <__bss_end+0xf722c>
     c60:	00000a44 	andeq	r0, r0, r4, asr #20
     c64:	0a4a0b05 	beq	1283880 <__bss_end+0x1279e48>
     c68:	0b060000 	bleq	180c70 <__bss_end+0x177238>
     c6c:	00000420 	andeq	r0, r0, r0, lsr #8
     c70:	12400b07 	subne	r0, r0, #7168	; 0x1c00
     c74:	00080000 	andeq	r0, r8, r0
     c78:	0003dc0a 	andeq	sp, r3, sl, lsl #24
     c7c:	56040500 	strpl	r0, [r4], -r0, lsl #10
     c80:	0a000000 	beq	c88 <shift+0xc88>
     c84:	09cf0c1d 	stmibeq	pc, {r0, r2, r3, r4, sl, fp}^	; <UNPREDICTABLE>
     c88:	ee0b0000 	cdp	0, 0, cr0, cr11, cr0, {0}
     c8c:	00000008 	andeq	r0, r0, r8
     c90:	00071f0b 	andeq	r1, r7, fp, lsl #30
     c94:	8a0b0100 	bhi	2c109c <__bss_end+0x2b7664>
     c98:	02000008 	andeq	r0, r0, #8
     c9c:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     ca0:	0d000300 	stceq	3, cr0, [r0, #-0]
     ca4:	00001232 	andeq	r1, r0, r2, lsr r2
     ca8:	07280a1c 			; <UNDEFINED> instruction: 0x07280a1c
     cac:	00000d50 	andeq	r0, r0, r0, asr sp
     cb0:	0005b208 	andeq	fp, r5, r8, lsl #4
     cb4:	330a1000 	movwcc	r1, #40960	; 0xa000
     cb8:	000a1e0a 	andeq	r1, sl, sl, lsl #28
     cbc:	0e770e00 	cdpeq	14, 7, cr0, cr7, cr0, {0}
     cc0:	350a0000 	strcc	r0, [sl, #-0]
     cc4:	0003b30b 	andeq	fp, r3, fp, lsl #6
     cc8:	d30e0000 	movwle	r0, #57344	; 0xe000
     ccc:	0a000011 	beq	d18 <shift+0xd18>
     cd0:	006b0d36 	rsbeq	r0, fp, r6, lsr sp
     cd4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cd8:	0000042c 	andeq	r0, r0, ip, lsr #8
     cdc:	5513370a 	ldrpl	r3, [r3, #-1802]	; 0xfffff8f6
     ce0:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     ce4:	0005390e 	andeq	r3, r5, lr, lsl #18
     ce8:	13380a00 	teqne	r8, #0, 20
     cec:	00000d55 	andeq	r0, r0, r5, asr sp
     cf0:	cf0e000c 	svcgt	0x000e000c
     cf4:	0a000005 	beq	d10 <shift+0xd10>
     cf8:	0d61202c 	stcleq	0, cr2, [r1, #-176]!	; 0xffffff50
     cfc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     d00:	0000059b 	muleq	r0, fp, r5
     d04:	660c2f0a 	strvs	r2, [ip], -sl, lsl #30
     d08:	0400000d 	streq	r0, [r0], #-13
     d0c:	000c020e 	andeq	r0, ip, lr, lsl #4
     d10:	0c310a00 			; <UNDEFINED> instruction: 0x0c310a00
     d14:	00000d66 	andeq	r0, r0, r6, ror #26
     d18:	0f2e0e0c 	svceq	0x002e0e0c
     d1c:	3b0a0000 	blcc	280d24 <__bss_end+0x2772ec>
     d20:	000d5512 	andeq	r5, sp, r2, lsl r5
     d24:	320e1400 	andcc	r1, lr, #0, 8
     d28:	0a00000e 	beq	d68 <shift+0xd68>
     d2c:	01520e3d 	cmpeq	r2, sp, lsr lr
     d30:	13180000 	tstne	r8, #0
     d34:	00000c1a 	andeq	r0, r0, sl, lsl ip
     d38:	2c08410a 	stfcss	f4, [r8], {10}
     d3c:	84000009 	strhi	r0, [r0], #-9
     d40:	02000003 	andeq	r0, r0, #3
     d44:	00000a78 	andeq	r0, r0, r8, ror sl
     d48:	00000a8d 	andeq	r0, r0, sp, lsl #21
     d4c:	000d7610 	andeq	r7, sp, r0, lsl r6
     d50:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     d54:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     d58:	1100000d 	tstne	r0, sp
     d5c:	00000d7c 	andeq	r0, r0, ip, ror sp
     d60:	0be31300 	bleq	ff8c5968 <__bss_end+0xff8bbf30>
     d64:	430a0000 	movwmi	r0, #40960	; 0xa000
     d68:	000b7808 	andeq	r7, fp, r8, lsl #16
     d6c:	00038400 	andeq	r8, r3, r0, lsl #8
     d70:	0aa60200 	beq	fe981578 <__bss_end+0xfe977b40>
     d74:	0abb0000 	beq	feec0d7c <__bss_end+0xfeeb7344>
     d78:	76100000 	ldrvc	r0, [r0], -r0
     d7c:	1100000d 	tstne	r0, sp
     d80:	0000006b 	andeq	r0, r0, fp, rrx
     d84:	000d7c11 	andeq	r7, sp, r1, lsl ip
     d88:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     d8c:	13000000 	movwne	r0, #0
     d90:	00000eec 	andeq	r0, r0, ip, ror #29
     d94:	7108450a 	tstvc	r8, sl, lsl #10
     d98:	84000011 	strhi	r0, [r0], #-17	; 0xffffffef
     d9c:	02000003 	andeq	r0, r0, #3
     da0:	00000ad4 	ldrdeq	r0, [r0], -r4
     da4:	00000ae9 	andeq	r0, r0, r9, ror #21
     da8:	000d7610 	andeq	r7, sp, r0, lsl r6
     dac:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     db0:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     db4:	1100000d 	tstne	r0, sp
     db8:	00000d7c 	andeq	r0, r0, ip, ror sp
     dbc:	10a91300 	adcne	r1, r9, r0, lsl #6
     dc0:	470a0000 	strmi	r0, [sl, -r0]
     dc4:	000eff08 	andeq	pc, lr, r8, lsl #30
     dc8:	00038400 	andeq	r8, r3, r0, lsl #8
     dcc:	0b020200 	bleq	815d4 <__bss_end+0x77b9c>
     dd0:	0b170000 	bleq	5c0dd8 <__bss_end+0x5b73a0>
     dd4:	76100000 	ldrvc	r0, [r0], -r0
     dd8:	1100000d 	tstne	r0, sp
     ddc:	0000006b 	andeq	r0, r0, fp, rrx
     de0:	000d7c11 	andeq	r7, sp, r1, lsl ip
     de4:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     de8:	13000000 	movwne	r0, #0
     dec:	00000526 	andeq	r0, r0, r6, lsr #10
     df0:	6e08490a 	vmlavs.f16	s8, s16, s20	; <UNPREDICTABLE>
     df4:	84000010 	strhi	r0, [r0], #-16
     df8:	02000003 	andeq	r0, r0, #3
     dfc:	00000b30 	andeq	r0, r0, r0, lsr fp
     e00:	00000b45 	andeq	r0, r0, r5, asr #22
     e04:	000d7610 	andeq	r7, sp, r0, lsl r6
     e08:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     e0c:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     e10:	1100000d 	tstne	r0, sp
     e14:	00000d7c 	andeq	r0, r0, ip, ror sp
     e18:	0bbf1300 	bleq	fefc5a20 <__bss_end+0xfefbbfe8>
     e1c:	4b0a0000 	blmi	280e24 <__bss_end+0x2773ec>
     e20:	0008a108 	andeq	sl, r8, r8, lsl #2
     e24:	00038400 	andeq	r8, r3, r0, lsl #8
     e28:	0b5e0200 	bleq	1781630 <__bss_end+0x1777bf8>
     e2c:	0b780000 	bleq	1e00e34 <__bss_end+0x1df73fc>
     e30:	76100000 	ldrvc	r0, [r0], -r0
     e34:	1100000d 	tstne	r0, sp
     e38:	0000006b 	andeq	r0, r0, fp, rrx
     e3c:	0009a411 	andeq	sl, r9, r1, lsl r4
     e40:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     e44:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     e48:	0000000d 	andeq	r0, r0, sp
     e4c:	000a0a13 	andeq	r0, sl, r3, lsl sl
     e50:	0c4f0a00 	mcrreq	10, 0, r0, pc, cr0
     e54:	00000d69 	andeq	r0, r0, r9, ror #26
     e58:	0000006b 	andeq	r0, r0, fp, rrx
     e5c:	000b9102 	andeq	r9, fp, r2, lsl #2
     e60:	000b9700 	andeq	r9, fp, r0, lsl #14
     e64:	0d761000 	ldcleq	0, cr1, [r6, #-0]
     e68:	14000000 	strne	r0, [r0], #-0
     e6c:	00000f52 	andeq	r0, r0, r2, asr pc
     e70:	9c08510a 	stflss	f5, [r8], {10}
     e74:	02000006 	andeq	r0, r0, #6
     e78:	00000bac 	andeq	r0, r0, ip, lsr #23
     e7c:	00000bb7 			; <UNDEFINED> instruction: 0x00000bb7
     e80:	000d8210 	andeq	r8, sp, r0, lsl r2
     e84:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     e88:	13000000 	movwne	r0, #0
     e8c:	00001232 	andeq	r1, r0, r2, lsr r2
     e90:	f903540a 			; <UNDEFINED> instruction: 0xf903540a
     e94:	8200000d 	andhi	r0, r0, #13
     e98:	0100000d 	tsteq	r0, sp
     e9c:	00000bd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     ea0:	00000bdb 	ldrdeq	r0, [r0], -fp
     ea4:	000d8210 	andeq	r8, sp, r0, lsl r2
     ea8:	007c1100 	rsbseq	r1, ip, r0, lsl #2
     eac:	14000000 	strne	r0, [r0], #-0
     eb0:	000004e6 	andeq	r0, r0, r6, ror #9
     eb4:	4b08570a 	blmi	216ae4 <__bss_end+0x20d0ac>
     eb8:	0100000c 	tsteq	r0, ip
     ebc:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     ec0:	00000c00 	andeq	r0, r0, r0, lsl #24
     ec4:	000d8210 	andeq	r8, sp, r0, lsl r2
     ec8:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     ecc:	5b110000 	blpl	440ed4 <__bss_end+0x43749c>
     ed0:	00000009 	andeq	r0, r0, r9
     ed4:	000e9113 	andeq	r9, lr, r3, lsl r1
     ed8:	12590a00 	subsne	r0, r9, #0, 20
     edc:	000011e4 	andeq	r1, r0, r4, ror #3
     ee0:	0000095b 	andeq	r0, r0, fp, asr r9
     ee4:	000c1901 	andeq	r1, ip, r1, lsl #18
     ee8:	000c2400 	andeq	r2, ip, r0, lsl #8
     eec:	0d761000 	ldcleq	0, cr1, [r6, #-0]
     ef0:	6b110000 	blvs	440ef8 <__bss_end+0x4374c0>
     ef4:	00000000 	andeq	r0, r0, r0
     ef8:	000c2e14 	andeq	r2, ip, r4, lsl lr
     efc:	085c0a00 	ldmdaeq	ip, {r9, fp}^
     f00:	00000a7d 	andeq	r0, r0, sp, ror sl
     f04:	000c3901 	andeq	r3, ip, r1, lsl #18
     f08:	000c4900 	andeq	r4, ip, r0, lsl #18
     f0c:	0d821000 	stceq	0, cr1, [r2]
     f10:	6b110000 	blvs	440f18 <__bss_end+0x4374e0>
     f14:	11000000 	mrsne	r0, (UNDEF: 0)
     f18:	00000384 	andeq	r0, r0, r4, lsl #7
     f1c:	0fe71300 	svceq	0x00e71300
     f20:	5f0a0000 	svcpl	0x000a0000
     f24:	0004aa08 	andeq	sl, r4, r8, lsl #20
     f28:	00038400 	andeq	r8, r3, r0, lsl #8
     f2c:	0c620100 	stfeqe	f0, [r2], #-0
     f30:	0c6d0000 	stcleq	0, cr0, [sp], #-0
     f34:	82100000 	andshi	r0, r0, #0
     f38:	1100000d 	tstne	r0, sp
     f3c:	0000006b 	andeq	r0, r0, fp, rrx
     f40:	0e851300 	cdpeq	3, 8, cr1, cr5, cr0, {0}
     f44:	620a0000 	andvs	r0, sl, #0
     f48:	0003f108 	andeq	pc, r3, r8, lsl #2
     f4c:	00038400 	andeq	r8, r3, r0, lsl #8
     f50:	0c860100 	stfeqs	f0, [r6], {0}
     f54:	0c9b0000 	ldceq	0, cr0, [fp], {0}
     f58:	82100000 	andshi	r0, r0, #0
     f5c:	1100000d 	tstne	r0, sp
     f60:	0000006b 	andeq	r0, r0, fp, rrx
     f64:	00038411 	andeq	r8, r3, r1, lsl r4
     f68:	03841100 	orreq	r1, r4, #0, 2
     f6c:	13000000 	movwne	r0, #0
     f70:	000011db 	ldrdeq	r1, [r0], -fp
     f74:	1108640a 	tstne	r8, sl, lsl #8
     f78:	84000008 	strhi	r0, [r0], #-8
     f7c:	01000003 	tsteq	r0, r3
     f80:	00000cb4 			; <UNDEFINED> instruction: 0x00000cb4
     f84:	00000cc9 	andeq	r0, r0, r9, asr #25
     f88:	000d8210 	andeq	r8, sp, r0, lsl r2
     f8c:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     f90:	84110000 	ldrhi	r0, [r1], #-0
     f94:	11000003 	tstne	r0, r3
     f98:	00000384 	andeq	r0, r0, r4, lsl #7
     f9c:	0b051400 	bleq	145fa4 <__bss_end+0x13c56c>
     fa0:	670a0000 	strvs	r0, [sl, -r0]
     fa4:	0003b108 	andeq	fp, r3, r8, lsl #2
     fa8:	0cde0100 	ldfeqe	f0, [lr], {0}
     fac:	0cee0000 	stcleq	0, cr0, [lr]
     fb0:	82100000 	andshi	r0, r0, #0
     fb4:	1100000d 	tstne	r0, sp
     fb8:	0000006b 	andeq	r0, r0, fp, rrx
     fbc:	0009a411 	andeq	sl, r9, r1, lsl r4
     fc0:	24140000 	ldrcs	r0, [r4], #-0
     fc4:	0a00000d 	beq	1000 <shift+0x1000>
     fc8:	07430869 	strbeq	r0, [r3, -r9, ror #16]
     fcc:	03010000 	movweq	r0, #4096	; 0x1000
     fd0:	1300000d 	movwne	r0, #13
     fd4:	1000000d 	andne	r0, r0, sp
     fd8:	00000d82 	andeq	r0, r0, r2, lsl #27
     fdc:	00006b11 	andeq	r6, r0, r1, lsl fp
     fe0:	09a41100 	stmibeq	r4!, {r8, ip}
     fe4:	14000000 	strne	r0, [r0], #-0
     fe8:	000012a2 	andeq	r1, r0, r2, lsr #5
     fec:	ca086c0a 	bgt	21c01c <__bss_end+0x2125e4>
     ff0:	01000009 	tsteq	r0, r9
     ff4:	00000d28 	andeq	r0, r0, r8, lsr #26
     ff8:	00000d2e 	andeq	r0, r0, lr, lsr #26
     ffc:	000d8210 	andeq	r8, sp, r0, lsl r2
    1000:	69270000 	stmdbvs	r7!, {}	; <UNPREDICTABLE>
    1004:	0a00000b 	beq	1038 <shift+0x1038>
    1008:	0e40086f 	cdpeq	8, 4, cr0, cr0, cr15, {3}
    100c:	3f010000 	svccc	0x00010000
    1010:	1000000d 	andne	r0, r0, sp
    1014:	00000d82 	andeq	r0, r0, r2, lsl #27
    1018:	0003b311 	andeq	fp, r3, r1, lsl r3
    101c:	006b1100 	rsbeq	r1, fp, r0, lsl #2
    1020:	00000000 	andeq	r0, r0, r0
    1024:	0009cf04 	andeq	ip, r9, r4, lsl #30
    1028:	dc041800 	stcle	8, cr1, [r4], {-0}
    102c:	18000009 	stmdane	r0, {r0, r3}
    1030:	00008804 	andeq	r8, r0, r4, lsl #16
    1034:	0d5b0400 	cfldrdeq	mvd0, [fp, #-0]
    1038:	6b160000 	blvs	581040 <__bss_end+0x577608>
    103c:	76000000 	strvc	r0, [r0], -r0
    1040:	1700000d 	strne	r0, [r0, -sp]
    1044:	0000007c 	andeq	r0, r0, ip, ror r0
    1048:	04180001 	ldreq	r0, [r8], #-1
    104c:	00000d50 	andeq	r0, r0, r0, asr sp
    1050:	006b0421 	rsbeq	r0, fp, r1, lsr #8
    1054:	04180000 	ldreq	r0, [r8], #-0
    1058:	000009cf 	andeq	r0, r0, pc, asr #19
    105c:	000b191a 	andeq	r1, fp, sl, lsl r9
    1060:	16730a00 	ldrbtne	r0, [r3], -r0, lsl #20
    1064:	000009cf 	andeq	r0, r0, pc, asr #19
    1068:	00125728 	andseq	r5, r2, r8, lsr #14
    106c:	050e0100 	streq	r0, [lr, #-256]	; 0xffffff00
    1070:	00000056 	andeq	r0, r0, r6, asr r0
    1074:	0000822c 	andeq	r8, r0, ip, lsr #4
    1078:	000000dc 	ldrdeq	r0, [r0], -ip
    107c:	0e189c01 	cdpeq	12, 1, cr9, cr8, cr1, {0}
    1080:	1a290000 	bne	a41088 <__bss_end+0xa37650>
    1084:	01000012 	tsteq	r0, r2, lsl r0
    1088:	00560e0e 	subseq	r0, r6, lr, lsl #28
    108c:	91020000 	mrsls	r0, (UNDEF: 2)
    1090:	110e295c 	tstne	lr, ip, asr r9
    1094:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1098:	000e181b 	andeq	r1, lr, fp, lsl r8
    109c:	58910200 	ldmpl	r1, {r9}
    10a0:	001b442a 	andseq	r4, fp, sl, lsr #8
    10a4:	07100100 	ldreq	r0, [r0, -r0, lsl #2]
    10a8:	00000043 	andeq	r0, r0, r3, asr #32
    10ac:	2a6b9102 	bcs	1ae54bc <__bss_end+0x1adba84>
    10b0:	0000053e 	andeq	r0, r0, lr, lsr r5
    10b4:	43071101 	movwmi	r1, #28929	; 0x7101
    10b8:	02000000 	andeq	r0, r0, #0
    10bc:	6c2a7791 	stcvs	7, cr7, [sl], #-580	; 0xfffffdbc
    10c0:	0100000e 	tsteq	r0, lr
    10c4:	006b0b13 	rsbeq	r0, fp, r3, lsl fp
    10c8:	91020000 	mrsls	r0, (UNDEF: 2)
    10cc:	0fe02a70 	svceq	0x00e02a70
    10d0:	16010000 	strne	r0, [r1], -r0
    10d4:	0009a417 	andeq	sl, r9, r7, lsl r4
    10d8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    10dc:	0012ad2a 	andseq	sl, r2, sl, lsr #26
    10e0:	0b1e0100 	bleq	7814e8 <__bss_end+0x777ab0>
    10e4:	0000006b 	andeq	r0, r0, fp, rrx
    10e8:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    10ec:	0e1e0418 	cfmvrdleq	r0, mvd14
    10f0:	04180000 	ldreq	r0, [r8], #-0
    10f4:	00000043 	andeq	r0, r0, r3, asr #32
    10f8:	000cf500 	andeq	pc, ip, r0, lsl #10
    10fc:	66000400 	strvs	r0, [r0], -r0, lsl #8
    1100:	04000004 	streq	r0, [r0], #-4
    1104:	0015a801 	andseq	sl, r5, r1, lsl #16
    1108:	13be0400 			; <UNDEFINED> instruction: 0x13be0400
    110c:	14490000 	strbne	r0, [r9], #-0
    1110:	83080000 	movwhi	r0, #32768	; 0x8000
    1114:	045c0000 	ldrbeq	r0, [ip], #-0
    1118:	04440000 	strbeq	r0, [r4], #-0
    111c:	01020000 	mrseq	r0, (UNDEF: 2)
    1120:	000d6408 	andeq	r6, sp, r8, lsl #8
    1124:	00250300 	eoreq	r0, r5, r0, lsl #6
    1128:	02020000 	andeq	r0, r2, #0
    112c:	000dd805 	andeq	sp, sp, r5, lsl #16
    1130:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    1134:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1138:	5b080102 	blpl	201548 <__bss_end+0x1f7b10>
    113c:	0200000d 	andeq	r0, r0, #13
    1140:	098d0702 	stmibeq	sp, {r1, r8, r9, sl}
    1144:	7c050000 	stcvc	0, cr0, [r5], {-0}
    1148:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    114c:	005e0709 	subseq	r0, lr, r9, lsl #14
    1150:	4d030000 	stcmi	0, cr0, [r3, #-0]
    1154:	02000000 	andeq	r0, r0, #0
    1158:	1df80704 	ldclne	7, cr0, [r8, #16]!
    115c:	13060000 	movwne	r0, #24576	; 0x6000
    1160:	08000007 	stmdaeq	r0, {r0, r1, r2}
    1164:	8b080602 	blhi	202974 <__bss_end+0x1f8f3c>
    1168:	07000000 	streq	r0, [r0, -r0]
    116c:	02003072 	andeq	r3, r0, #114	; 0x72
    1170:	004d0e08 	subeq	r0, sp, r8, lsl #28
    1174:	07000000 	streq	r0, [r0, -r0]
    1178:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
    117c:	004d0e09 	subeq	r0, sp, r9, lsl #28
    1180:	00040000 	andeq	r0, r4, r0
    1184:	0014e708 	andseq	lr, r4, r8, lsl #14
    1188:	38040500 	stmdacc	r4, {r8, sl}
    118c:	02000000 	andeq	r0, r0, #0
    1190:	00a90c0d 	adceq	r0, r9, sp, lsl #24
    1194:	4f090000 	svcmi	0x00090000
    1198:	0a00004b 	beq	12cc <shift+0x12cc>
    119c:	00001321 	andeq	r1, r0, r1, lsr #6
    11a0:	71080001 	tstvc	r8, r1
    11a4:	05000005 	streq	r0, [r0, #-5]
    11a8:	00003804 	andeq	r3, r0, r4, lsl #16
    11ac:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
    11b0:	000000e0 	andeq	r0, r0, r0, ror #1
    11b4:	0007c80a 	andeq	ip, r7, sl, lsl #16
    11b8:	920a0000 	andls	r0, sl, #0
    11bc:	01000012 	tsteq	r0, r2, lsl r0
    11c0:	00125c0a 	andseq	r5, r2, sl, lsl #24
    11c4:	2f0a0200 	svccs	0x000a0200
    11c8:	0300000a 	movweq	r0, #10
    11cc:	000c830a 	andeq	r8, ip, sl, lsl #6
    11d0:	910a0400 	tstls	sl, r0, lsl #8
    11d4:	05000007 	streq	r0, [r0, #-7]
    11d8:	11590800 	cmpne	r9, r0, lsl #16
    11dc:	04050000 	streq	r0, [r5], #-0
    11e0:	00000038 	andeq	r0, r0, r8, lsr r0
    11e4:	1d0c3f02 	stcne	15, cr3, [ip, #-8]
    11e8:	0a000001 	beq	11f4 <shift+0x11f4>
    11ec:	0000041b 	andeq	r0, r0, fp, lsl r4
    11f0:	05ad0a00 	streq	r0, [sp, #2560]!	; 0xa00
    11f4:	0a010000 	beq	411fc <__bss_end+0x377c4>
    11f8:	00000c3e 	andeq	r0, r0, lr, lsr ip
    11fc:	120d0a02 	andne	r0, sp, #8192	; 0x2000
    1200:	0a030000 	beq	c1208 <__bss_end+0xb77d0>
    1204:	0000129c 	muleq	r0, ip, r2
    1208:	0b4f0a04 	bleq	13c3a20 <__bss_end+0x13b9fe8>
    120c:	0a050000 	beq	141214 <__bss_end+0x1377dc>
    1210:	000009ad 	andeq	r0, r0, sp, lsr #19
    1214:	13080006 	movwne	r0, #32774	; 0x8006
    1218:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    121c:	00003804 	andeq	r3, r0, r4, lsl #16
    1220:	0c660200 	sfmeq	f0, 2, [r6], #-0
    1224:	00000148 	andeq	r0, r0, r8, asr #2
    1228:	000d390a 	andeq	r3, sp, sl, lsl #18
    122c:	6f0a0000 	svcvs	0x000a0000
    1230:	01000009 	tsteq	r0, r9
    1234:	000de20a 	andeq	lr, sp, sl, lsl #4
    1238:	b20a0200 	andlt	r0, sl, #0, 4
    123c:	03000009 	movweq	r0, #9
    1240:	0ba70b00 	bleq	fe9c3e48 <__bss_end+0xfe9ba410>
    1244:	05030000 	streq	r0, [r3, #-0]
    1248:	00005914 	andeq	r5, r0, r4, lsl r9
    124c:	d4030500 	strle	r0, [r3], #-1280	; 0xfffffb00
    1250:	0b000099 	bleq	14bc <shift+0x14bc>
    1254:	00000bf6 	strdeq	r0, [r0], -r6
    1258:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
    125c:	05000000 	streq	r0, [r0, #-0]
    1260:	0099d803 	addseq	sp, r9, r3, lsl #16
    1264:	0b390b00 	bleq	e43e6c <__bss_end+0xe3a434>
    1268:	07040000 	streq	r0, [r4, -r0]
    126c:	0000591a 	andeq	r5, r0, sl, lsl r9
    1270:	dc030500 	cfstr32le	mvfx0, [r3], {-0}
    1274:	0b000099 	bleq	14e0 <shift+0x14e0>
    1278:	000005dc 	ldrdeq	r0, [r0], -ip
    127c:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
    1280:	05000000 	streq	r0, [r0, #-0]
    1284:	0099e003 	addseq	lr, r9, r3
    1288:	0d4d0b00 	vstreq	d16, [sp, #-0]
    128c:	0b040000 	bleq	101294 <__bss_end+0xf785c>
    1290:	0000591a 	andeq	r5, r0, sl, lsl r9
    1294:	e4030500 	str	r0, [r3], #-1280	; 0xfffffb00
    1298:	0b000099 	bleq	1504 <shift+0x1504>
    129c:	0000095c 	andeq	r0, r0, ip, asr r9
    12a0:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
    12a4:	05000000 	streq	r0, [r0, #-0]
    12a8:	0099e803 	addseq	lr, r9, r3, lsl #16
    12ac:	07390b00 	ldreq	r0, [r9, -r0, lsl #22]!
    12b0:	0f040000 	svceq	0x00040000
    12b4:	0000591a 	andeq	r5, r0, sl, lsl r9
    12b8:	ec030500 	cfstr32	mvfx0, [r3], {-0}
    12bc:	08000099 	stmdaeq	r0, {r0, r3, r4, r7}
    12c0:	00000edc 	ldrdeq	r0, [r0], -ip
    12c4:	00380405 	eorseq	r0, r8, r5, lsl #8
    12c8:	1b040000 	blne	1012d0 <__bss_end+0xf7898>
    12cc:	0001eb0c 	andeq	lr, r1, ip, lsl #22
    12d0:	0f480a00 	svceq	0x00480a00
    12d4:	0a000000 	beq	12dc <shift+0x12dc>
    12d8:	0000124c 	andeq	r1, r0, ip, asr #4
    12dc:	0c390a01 			; <UNDEFINED> instruction: 0x0c390a01
    12e0:	00020000 	andeq	r0, r2, r0
    12e4:	000d1e0c 	andeq	r1, sp, ip, lsl #28
    12e8:	0dbd0d00 	ldceq	13, cr0, [sp]
    12ec:	04900000 	ldreq	r0, [r0], #0
    12f0:	035e0763 	cmpeq	lr, #25952256	; 0x18c0000
    12f4:	af060000 	svcge	0x00060000
    12f8:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    12fc:	78106704 	ldmdavc	r0, {r2, r8, r9, sl, sp, lr}
    1300:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1304:	00002168 	andeq	r2, r0, r8, ror #2
    1308:	5e126904 	vnmlspl.f16	s12, s4, s8	; <UNPREDICTABLE>
    130c:	00000003 	andeq	r0, r0, r3
    1310:	0005650e 	andeq	r6, r5, lr, lsl #10
    1314:	126b0400 	rsbne	r0, fp, #0, 8
    1318:	0000036e 	andeq	r0, r0, lr, ror #6
    131c:	0f3d0e10 	svceq	0x003d0e10
    1320:	6d040000 	stcvs	0, cr0, [r4, #-0]
    1324:	00004d16 	andeq	r4, r0, r6, lsl sp
    1328:	d50e1400 	strle	r1, [lr, #-1024]	; 0xfffffc00
    132c:	04000005 	streq	r0, [r0], #-5
    1330:	03751c70 	cmneq	r5, #112, 24	; 0x7000
    1334:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    1338:	00000d44 	andeq	r0, r0, r4, asr #26
    133c:	751c7204 	ldrvc	r7, [ip, #-516]	; 0xfffffdfc
    1340:	1c000003 	stcne	0, cr0, [r0], {3}
    1344:	0005390e 	andeq	r3, r5, lr, lsl #18
    1348:	1c750400 	cfldrdne	mvd0, [r5], #-0
    134c:	00000375 	andeq	r0, r0, r5, ror r3
    1350:	07da0f20 	ldrbeq	r0, [sl, r0, lsr #30]
    1354:	77040000 	strvc	r0, [r4, -r0]
    1358:	0004671c 	andeq	r6, r4, ip, lsl r7
    135c:	00037500 	andeq	r7, r3, r0, lsl #10
    1360:	00026c00 	andeq	r6, r2, r0, lsl #24
    1364:	03751000 	cmneq	r5, #0
    1368:	7b110000 	blvc	441370 <__bss_end+0x437938>
    136c:	00000003 	andeq	r0, r0, r3
    1370:	064e0600 	strbeq	r0, [lr], -r0, lsl #12
    1374:	04180000 	ldreq	r0, [r8], #-0
    1378:	02ad107b 	adceq	r1, sp, #123	; 0x7b
    137c:	680e0000 	stmdavs	lr, {}	; <UNPREDICTABLE>
    1380:	04000021 	streq	r0, [r0], #-33	; 0xffffffdf
    1384:	035e127e 	cmpeq	lr, #-536870905	; 0xe0000007
    1388:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    138c:	0000055a 	andeq	r0, r0, sl, asr r5
    1390:	7b198004 	blvc	6613a8 <__bss_end+0x657970>
    1394:	10000003 	andne	r0, r0, r3
    1398:	0012130e 	andseq	r1, r2, lr, lsl #6
    139c:	21820400 	orrcs	r0, r2, r0, lsl #8
    13a0:	00000386 	andeq	r0, r0, r6, lsl #7
    13a4:	78030014 	stmdavc	r3, {r2, r4}
    13a8:	12000002 	andne	r0, r0, #2
    13ac:	00000ae3 	andeq	r0, r0, r3, ror #21
    13b0:	8c218604 	stchi	6, cr8, [r1], #-16
    13b4:	12000003 	andne	r0, r0, #3
    13b8:	0000088f 	andeq	r0, r0, pc, lsl #17
    13bc:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
    13c0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    13c4:	00000e20 	andeq	r0, r0, r0, lsr #28
    13c8:	fd178b04 	ldc2	11, cr8, [r7, #-16]	; <UNPREDICTABLE>
    13cc:	00000001 	andeq	r0, r0, r1
    13d0:	000a350e 	andeq	r3, sl, lr, lsl #10
    13d4:	178e0400 	strne	r0, [lr, r0, lsl #8]
    13d8:	000001fd 	strdeq	r0, [r0], -sp
    13dc:	08fa0e24 	ldmeq	sl!, {r2, r5, r9, sl, fp}^
    13e0:	8f040000 	svchi	0x00040000
    13e4:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13e8:	7c0e4800 	stcvc	8, cr4, [lr], {-0}
    13ec:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    13f0:	01fd1790 			; <UNDEFINED> instruction: 0x01fd1790
    13f4:	136c0000 	cmnne	ip, #0
    13f8:	00000dbd 			; <UNDEFINED> instruction: 0x00000dbd
    13fc:	39099304 	stmdbcc	r9, {r2, r8, r9, ip, pc}
    1400:	97000006 	strls	r0, [r0, -r6]
    1404:	01000003 	tsteq	r0, r3
    1408:	00000317 	andeq	r0, r0, r7, lsl r3
    140c:	0000031d 	andeq	r0, r0, sp, lsl r3
    1410:	00039710 	andeq	r9, r3, r0, lsl r7
    1414:	d8140000 	ldmdale	r4, {}	; <UNPREDICTABLE>
    1418:	0400000a 	streq	r0, [r0], #-10
    141c:	09eb0e96 	stmibeq	fp!, {r1, r2, r4, r7, r9, sl, fp}^
    1420:	32010000 	andcc	r0, r1, #0
    1424:	38000003 	stmdacc	r0, {r0, r1}
    1428:	10000003 	andne	r0, r0, r3
    142c:	00000397 	muleq	r0, r7, r3
    1430:	041b1500 	ldreq	r1, [fp], #-1280	; 0xfffffb00
    1434:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
    1438:	000ec110 	andeq	ip, lr, r0, lsl r1
    143c:	00039d00 	andeq	r9, r3, r0, lsl #26
    1440:	034d0100 	movteq	r0, #53504	; 0xd100
    1444:	97100000 	ldrls	r0, [r0, -r0]
    1448:	11000003 	tstne	r0, r3
    144c:	0000037b 	andeq	r0, r0, fp, ror r3
    1450:	0001c611 	andeq	ip, r1, r1, lsl r6
    1454:	16000000 	strne	r0, [r0], -r0
    1458:	00000025 	andeq	r0, r0, r5, lsr #32
    145c:	0000036e 	andeq	r0, r0, lr, ror #6
    1460:	00005e17 	andeq	r5, r0, r7, lsl lr
    1464:	02000f00 	andeq	r0, r0, #0, 30
    1468:	0a3f0201 	beq	fc1c74 <__bss_end+0xfb823c>
    146c:	04180000 	ldreq	r0, [r8], #-0
    1470:	000001fd 	strdeq	r0, [r0], -sp
    1474:	002c0418 	eoreq	r0, ip, r8, lsl r4
    1478:	1f0c0000 	svcne	0x000c0000
    147c:	18000012 	stmdane	r0, {r1, r4}
    1480:	00038104 	andeq	r8, r3, r4, lsl #2
    1484:	02ad1600 	adceq	r1, sp, #0, 12
    1488:	03970000 	orrseq	r0, r7, #0
    148c:	00190000 	andseq	r0, r9, r0
    1490:	01f00418 	mvnseq	r0, r8, lsl r4
    1494:	04180000 	ldreq	r0, [r8], #-0
    1498:	000001eb 	andeq	r0, r0, fp, ror #3
    149c:	000e261a 	andeq	r2, lr, sl, lsl r6
    14a0:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
    14a4:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    14a8:	00083b0b 	andeq	r3, r8, fp, lsl #22
    14ac:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
    14b0:	00000059 	andeq	r0, r0, r9, asr r0
    14b4:	99f00305 	ldmibls	r0!, {r0, r2, r8, r9}^
    14b8:	a60b0000 	strge	r0, [fp], -r0
    14bc:	05000003 	streq	r0, [r0, #-3]
    14c0:	00591407 	subseq	r1, r9, r7, lsl #8
    14c4:	03050000 	movweq	r0, #20480	; 0x5000
    14c8:	000099f4 	strdeq	r9, [r0], -r4
    14cc:	0006150b 	andeq	r1, r6, fp, lsl #10
    14d0:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
    14d4:	00000059 	andeq	r0, r0, r9, asr r0
    14d8:	99f80305 	ldmibls	r8!, {r0, r2, r8, r9}^
    14dc:	a8080000 	stmdage	r8, {}	; <UNPREDICTABLE>
    14e0:	0500000a 	streq	r0, [r0, #-10]
    14e4:	00003804 	andeq	r3, r0, r4, lsl #16
    14e8:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
    14ec:	0000041c 	andeq	r0, r0, ip, lsl r4
    14f0:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
    14f4:	9f0a0000 	svcls	0x000a0000
    14f8:	0100000a 	tsteq	r0, sl
    14fc:	000e380a 	andeq	r3, lr, sl, lsl #16
    1500:	5a0a0200 	bpl	281d08 <__bss_end+0x2782d0>
    1504:	0300000a 	movweq	r0, #10
    1508:	000a210a 	andeq	r2, sl, sl, lsl #2
    150c:	440a0400 	strmi	r0, [sl], #-1024	; 0xfffffc00
    1510:	0500000c 	streq	r0, [r0, #-12]
    1514:	07840600 	streq	r0, [r4, r0, lsl #12]
    1518:	05100000 	ldreq	r0, [r0, #-0]
    151c:	045b081b 	ldrbeq	r0, [fp], #-2075	; 0xfffff7e5
    1520:	6c070000 	stcvs	0, cr0, [r7], {-0}
    1524:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
    1528:	00045b13 	andeq	r5, r4, r3, lsl fp
    152c:	73070000 	movwvc	r0, #28672	; 0x7000
    1530:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
    1534:	00045b13 	andeq	r5, r4, r3, lsl fp
    1538:	70070400 	andvc	r0, r7, r0, lsl #8
    153c:	1f050063 	svcne	0x00050063
    1540:	00045b13 	andeq	r5, r4, r3, lsl fp
    1544:	9a0e0800 	bls	38354c <__bss_end+0x379b14>
    1548:	05000007 	streq	r0, [r0, #-7]
    154c:	045b1320 	ldrbeq	r1, [fp], #-800	; 0xfffffce0
    1550:	000c0000 	andeq	r0, ip, r0
    1554:	f3070402 	vshl.u8	d0, d2, d7
    1558:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    155c:	0000045a 	andeq	r0, r0, sl, asr r4
    1560:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
    1564:	000004f2 	strdeq	r0, [r0], -r2
    1568:	0012860e 	andseq	r8, r2, lr, lsl #12
    156c:	122a0500 	eorne	r0, sl, #0, 10
    1570:	0000041c 	andeq	r0, r0, ip, lsl r4
    1574:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
    1578:	2b050064 	blcs	141710 <__bss_end+0x137cd8>
    157c:	00005e12 	andeq	r5, r0, r2, lsl lr
    1580:	440e1000 	strmi	r1, [lr], #-0
    1584:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    1588:	03e5112c 	mvneq	r1, #44, 2
    158c:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1590:	00000ab4 			; <UNDEFINED> instruction: 0x00000ab4
    1594:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
    1598:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    159c:	000ac20e 	andeq	ip, sl, lr, lsl #4
    15a0:	122e0500 	eorne	r0, lr, #0, 10
    15a4:	0000005e 	andeq	r0, r0, lr, asr r0
    15a8:	072c0e1c 			; <UNDEFINED> instruction: 0x072c0e1c
    15ac:	2f050000 	svccs	0x00050000
    15b0:	0004f20c 	andeq	pc, r4, ip, lsl #4
    15b4:	ef0e2000 	svc	0x000e2000
    15b8:	0500000a 	streq	r0, [r0, #-10]
    15bc:	00380930 	eorseq	r0, r8, r0, lsr r9
    15c0:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
    15c4:	00000f67 	andeq	r0, r0, r7, ror #30
    15c8:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
    15cc:	64000000 	strvs	r0, [r0], #-0
    15d0:	0007ee0e 	andeq	lr, r7, lr, lsl #28
    15d4:	0e330500 	cfabs32eq	mvfx0, mvfx3
    15d8:	0000004d 	andeq	r0, r0, sp, asr #32
    15dc:	07e50e68 	strbeq	r0, [r5, r8, ror #28]!
    15e0:	34050000 	strcc	r0, [r5], #-0
    15e4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15e8:	16006c00 	strne	r6, [r0], -r0, lsl #24
    15ec:	0000039d 	muleq	r0, sp, r3
    15f0:	00000502 	andeq	r0, r0, r2, lsl #10
    15f4:	00005e17 	andeq	r5, r0, r7, lsl lr
    15f8:	0b000f00 	bleq	5200 <shift+0x5200>
    15fc:	000011a0 	andeq	r1, r0, r0, lsr #3
    1600:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    1604:	05000000 	streq	r0, [r0, #-0]
    1608:	0099fc03 	addseq	pc, r9, r3, lsl #24
    160c:	0a620800 	beq	1883614 <__bss_end+0x1879bdc>
    1610:	04050000 	streq	r0, [r5], #-0
    1614:	00000038 	andeq	r0, r0, r8, lsr r0
    1618:	330c0d06 	movwcc	r0, #52486	; 0xcd06
    161c:	0a000005 	beq	1638 <shift+0x1638>
    1620:	00000586 	andeq	r0, r0, r6, lsl #11
    1624:	039b0a00 	orrseq	r0, fp, #0, 20
    1628:	00010000 	andeq	r0, r1, r0
    162c:	00051403 	andeq	r1, r5, r3, lsl #8
    1630:	14250800 	strtne	r0, [r5], #-2048	; 0xfffff800
    1634:	04050000 	streq	r0, [r5], #-0
    1638:	00000038 	andeq	r0, r0, r8, lsr r0
    163c:	570c1406 	strpl	r1, [ip, -r6, lsl #8]
    1640:	0a000005 	beq	165c <shift+0x165c>
    1644:	000012bb 			; <UNDEFINED> instruction: 0x000012bb
    1648:	14b90a00 	ldrtne	r0, [r9], #2560	; 0xa00
    164c:	00010000 	andeq	r0, r1, r0
    1650:	00053803 	andeq	r3, r5, r3, lsl #16
    1654:	105b0600 	subsne	r0, fp, r0, lsl #12
    1658:	060c0000 	streq	r0, [ip], -r0
    165c:	0591081b 	ldreq	r0, [r1, #2075]	; 0x81b
    1660:	2c0e0000 	stccs	0, cr0, [lr], {-0}
    1664:	06000004 	streq	r0, [r0], -r4
    1668:	0591191d 	ldreq	r1, [r1, #2333]	; 0x91d
    166c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1670:	00000539 	andeq	r0, r0, r9, lsr r5
    1674:	91191e06 	tstls	r9, r6, lsl #28
    1678:	04000005 	streq	r0, [r0], #-5
    167c:	000fdb0e 	andeq	sp, pc, lr, lsl #22
    1680:	131f0600 	tstne	pc, #0, 12
    1684:	00000597 	muleq	r0, r7, r5
    1688:	04180008 	ldreq	r0, [r8], #-8
    168c:	0000055c 	andeq	r0, r0, ip, asr r5
    1690:	04620418 	strbteq	r0, [r2], #-1048	; 0xfffffbe8
    1694:	280d0000 	stmdacs	sp, {}	; <UNPREDICTABLE>
    1698:	14000006 	strne	r0, [r0], #-6
    169c:	1f072206 	svcne	0x00072206
    16a0:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
    16a4:	00000a50 	andeq	r0, r0, r0, asr sl
    16a8:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    16ac:	00000000 	andeq	r0, r0, r0
    16b0:	0004d30e 	andeq	sp, r4, lr, lsl #6
    16b4:	1d290600 	stcne	6, cr0, [r9, #-0]
    16b8:	00000591 	muleq	r0, r1, r5
    16bc:	0eae0e04 	cdpeq	14, 10, cr0, cr14, cr4, {0}
    16c0:	2c060000 	stccs	0, cr0, [r6], {-0}
    16c4:	0005911d 	andeq	r9, r5, sp, lsl r1
    16c8:	4f1b0800 	svcmi	0x001b0800
    16cc:	06000011 			; <UNDEFINED> instruction: 0x06000011
    16d0:	10380e2f 	eorsne	r0, r8, pc, lsr #28
    16d4:	05e50000 	strbeq	r0, [r5, #0]!
    16d8:	05f00000 	ldrbeq	r0, [r0, #0]!
    16dc:	24100000 	ldrcs	r0, [r0], #-0
    16e0:	11000008 	tstne	r0, r8
    16e4:	00000591 	muleq	r0, r1, r5
    16e8:	0ff11c00 	svceq	0x00f11c00
    16ec:	31060000 	mrscc	r0, (UNDEF: 6)
    16f0:	0004310e 	andeq	r3, r4, lr, lsl #2
    16f4:	00036e00 	andeq	r6, r3, r0, lsl #28
    16f8:	00060800 	andeq	r0, r6, r0, lsl #16
    16fc:	00061300 	andeq	r1, r6, r0, lsl #6
    1700:	08241000 	stmdaeq	r4!, {ip}
    1704:	97110000 	ldrls	r0, [r1, -r0]
    1708:	00000005 	andeq	r0, r0, r5
    170c:	00109d13 	andseq	r9, r0, r3, lsl sp
    1710:	1d350600 	ldcne	6, cr0, [r5, #-0]
    1714:	00000fb6 			; <UNDEFINED> instruction: 0x00000fb6
    1718:	00000591 	muleq	r0, r1, r5
    171c:	00062c02 	andeq	r2, r6, r2, lsl #24
    1720:	00063200 	andeq	r3, r6, r0, lsl #4
    1724:	08241000 	stmdaeq	r4!, {ip}
    1728:	13000000 	movwne	r0, #0
    172c:	000009a0 	andeq	r0, r0, r0, lsr #19
    1730:	971d3706 	ldrls	r3, [sp, -r6, lsl #14]
    1734:	9100000d 	tstls	r0, sp
    1738:	02000005 	andeq	r0, r0, #5
    173c:	0000064b 	andeq	r0, r0, fp, asr #12
    1740:	00000651 	andeq	r0, r0, r1, asr r6
    1744:	00082410 	andeq	r2, r8, r0, lsl r4
    1748:	1f1d0000 	svcne	0x001d0000
    174c:	0600000b 	streq	r0, [r0], -fp
    1750:	083d3139 	ldmdaeq	sp!, {r0, r3, r4, r5, r8, ip, sp}
    1754:	020c0000 	andeq	r0, ip, #0
    1758:	00062813 	andeq	r2, r6, r3, lsl r8
    175c:	093c0600 	ldmdbeq	ip!, {r9, sl}
    1760:	00001262 	andeq	r1, r0, r2, ror #4
    1764:	00000824 	andeq	r0, r0, r4, lsr #16
    1768:	00067801 	andeq	r7, r6, r1, lsl #16
    176c:	00067e00 	andeq	r7, r6, r0, lsl #28
    1770:	08241000 	stmdaeq	r4!, {ip}
    1774:	13000000 	movwne	r0, #0
    1778:	000005c0 	andeq	r0, r0, r0, asr #11
    177c:	24123f06 	ldrcs	r3, [r2], #-3846	; 0xfffff0fa
    1780:	4d000011 	stcmi	0, cr0, [r0, #-68]	; 0xffffffbc
    1784:	01000000 	mrseq	r0, (UNDEF: 0)
    1788:	00000697 	muleq	r0, r7, r6
    178c:	000006ac 	andeq	r0, r0, ip, lsr #13
    1790:	00082410 	andeq	r2, r8, r0, lsl r4
    1794:	08461100 	stmdaeq	r6, {r8, ip}^
    1798:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    179c:	11000000 	mrsne	r0, (UNDEF: 0)
    17a0:	0000036e 	andeq	r0, r0, lr, ror #6
    17a4:	10001400 	andne	r1, r0, r0, lsl #8
    17a8:	42060000 	andmi	r0, r6, #0
    17ac:	000cd00e 	andeq	sp, ip, lr
    17b0:	06c10100 	strbeq	r0, [r1], r0, lsl #2
    17b4:	06c70000 	strbeq	r0, [r7], r0
    17b8:	24100000 	ldrcs	r0, [r0], #-0
    17bc:	00000008 	andeq	r0, r0, r8
    17c0:	00090413 	andeq	r0, r9, r3, lsl r4
    17c4:	17450600 	strbne	r0, [r5, -r0, lsl #12]
    17c8:	000004f8 	strdeq	r0, [r0], -r8
    17cc:	00000597 	muleq	r0, r7, r5
    17d0:	0006e001 	andeq	lr, r6, r1
    17d4:	0006e600 	andeq	lr, r6, r0, lsl #12
    17d8:	084c1000 	stmdaeq	ip, {ip}^
    17dc:	13000000 	movwne	r0, #0
    17e0:	00000547 	andeq	r0, r0, r7, asr #10
    17e4:	73174806 	tstvc	r7, #393216	; 0x60000
    17e8:	9700000f 	strls	r0, [r0, -pc]
    17ec:	01000005 	tsteq	r0, r5
    17f0:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    17f4:	0000070a 	andeq	r0, r0, sl, lsl #14
    17f8:	00084c10 	andeq	r4, r8, r0, lsl ip
    17fc:	004d1100 	subeq	r1, sp, r0, lsl #2
    1800:	14000000 	strne	r0, [r0], #-0
    1804:	000011bd 			; <UNDEFINED> instruction: 0x000011bd
    1808:	090e4b06 	stmdbeq	lr, {r1, r2, r8, r9, fp, lr}
    180c:	01000010 	tsteq	r0, r0, lsl r0
    1810:	0000071f 	andeq	r0, r0, pc, lsl r7
    1814:	00000725 	andeq	r0, r0, r5, lsr #14
    1818:	00082410 	andeq	r2, r8, r0, lsl r4
    181c:	f1130000 			; <UNDEFINED> instruction: 0xf1130000
    1820:	0600000f 	streq	r0, [r0], -pc
    1824:	07a00e4d 	streq	r0, [r0, sp, asr #28]!
    1828:	036e0000 	cmneq	lr, #0
    182c:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    1830:	49000007 	stmdbmi	r0, {r0, r1, r2}
    1834:	10000007 	andne	r0, r0, r7
    1838:	00000824 	andeq	r0, r0, r4, lsr #16
    183c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1840:	18130000 	ldmdane	r3, {}	; <UNPREDICTABLE>
    1844:	06000009 	streq	r0, [r0], -r9
    1848:	0cf11250 	lfmeq	f1, 2, [r1], #320	; 0x140
    184c:	004d0000 	subeq	r0, sp, r0
    1850:	62010000 	andvs	r0, r1, #0
    1854:	6d000007 	stcvs	0, cr0, [r0, #-28]	; 0xffffffe4
    1858:	10000007 	andne	r0, r0, r7
    185c:	00000824 	andeq	r0, r0, r4, lsr #16
    1860:	00039d11 	andeq	r9, r3, r1, lsl sp
    1864:	97130000 	ldrls	r0, [r3, -r0]
    1868:	06000004 	streq	r0, [r0], -r4
    186c:	08540e53 	ldmdaeq	r4, {r0, r1, r4, r6, r9, sl, fp}^
    1870:	036e0000 	cmneq	lr, #0
    1874:	86010000 	strhi	r0, [r1], -r0
    1878:	91000007 	tstls	r0, r7
    187c:	10000007 	andne	r0, r0, r7
    1880:	00000824 	andeq	r0, r0, r4, lsr #16
    1884:	00004d11 	andeq	r4, r0, r1, lsl sp
    1888:	7a140000 	bvc	501890 <__bss_end+0x4f7e58>
    188c:	06000009 	streq	r0, [r0], -r9
    1890:	10bc0e56 	adcsne	r0, ip, r6, asr lr
    1894:	a6010000 	strge	r0, [r1], -r0
    1898:	c5000007 	strgt	r0, [r0, #-7]
    189c:	10000007 	andne	r0, r0, r7
    18a0:	00000824 	andeq	r0, r0, r4, lsr #16
    18a4:	0000a911 	andeq	sl, r0, r1, lsl r9
    18a8:	004d1100 	subeq	r1, sp, r0, lsl #2
    18ac:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18b0:	11000000 	mrsne	r0, (UNDEF: 0)
    18b4:	0000004d 	andeq	r0, r0, sp, asr #32
    18b8:	00085211 	andeq	r5, r8, r1, lsl r2
    18bc:	a0140000 	andsge	r0, r4, r0
    18c0:	0600000f 	streq	r0, [r0], -pc
    18c4:	06c70e58 			; <UNDEFINED> instruction: 0x06c70e58
    18c8:	da010000 	ble	418d0 <__bss_end+0x37e98>
    18cc:	f9000007 			; <UNDEFINED> instruction: 0xf9000007
    18d0:	10000007 	andne	r0, r0, r7
    18d4:	00000824 	andeq	r0, r0, r4, lsr #16
    18d8:	0000e011 	andeq	lr, r0, r1, lsl r0
    18dc:	004d1100 	subeq	r1, sp, r0, lsl #2
    18e0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18e4:	11000000 	mrsne	r0, (UNDEF: 0)
    18e8:	0000004d 	andeq	r0, r0, sp, asr #32
    18ec:	00085211 	andeq	r5, r8, r1, lsl r2
    18f0:	f7150000 			; <UNDEFINED> instruction: 0xf7150000
    18f4:	06000005 	streq	r0, [r0], -r5
    18f8:	06590e5b 			; <UNDEFINED> instruction: 0x06590e5b
    18fc:	036e0000 	cmneq	lr, #0
    1900:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1904:	10000008 	andne	r0, r0, r8
    1908:	00000824 	andeq	r0, r0, r4, lsr #16
    190c:	00051411 	andeq	r1, r5, r1, lsl r4
    1910:	08581100 	ldmdaeq	r8, {r8, ip}^
    1914:	00000000 	andeq	r0, r0, r0
    1918:	00059d03 	andeq	r9, r5, r3, lsl #26
    191c:	9d041800 	stcls	8, cr1, [r4, #-0]
    1920:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    1924:	00000591 	muleq	r0, r1, r5
    1928:	00000837 	andeq	r0, r0, r7, lsr r8
    192c:	0000083d 	andeq	r0, r0, sp, lsr r8
    1930:	00082410 	andeq	r2, r8, r0, lsl r4
    1934:	9d1f0000 	ldcls	0, cr0, [pc, #-0]	; 193c <shift+0x193c>
    1938:	2a000005 	bcs	1954 <shift+0x1954>
    193c:	18000008 	stmdane	r0, {r3}
    1940:	00003f04 	andeq	r3, r0, r4, lsl #30
    1944:	1f041800 	svcne	0x00041800
    1948:	20000008 	andcs	r0, r0, r8
    194c:	00006504 	andeq	r6, r0, r4, lsl #10
    1950:	1a042100 	bne	109d58 <__bss_end+0x100320>
    1954:	00000b2d 	andeq	r0, r0, sp, lsr #22
    1958:	9d195e06 	ldcls	14, cr5, [r9, #-24]	; 0xffffffe8
    195c:	0b000005 	bleq	1978 <shift+0x1978>
    1960:	00000bda 	ldrdeq	r0, [r0], -sl
    1964:	7f110407 	svcvc	0x00110407
    1968:	05000008 	streq	r0, [r0, #-8]
    196c:	009a0003 	addseq	r0, sl, r3
    1970:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    1974:	00001bc2 	andeq	r1, r0, r2, asr #23
    1978:	00087803 	andeq	r7, r8, r3, lsl #16
    197c:	002c1600 	eoreq	r1, ip, r0, lsl #12
    1980:	08940000 	ldmeq	r4, {}	; <UNPREDICTABLE>
    1984:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1988:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    198c:	08840300 	stmeq	r4, {r8, r9}
    1990:	6d220000 	stcvs	0, cr0, [r2, #-0]
    1994:	01000013 	tsteq	r0, r3, lsl r0
    1998:	08940ca4 	ldmeq	r4, {r2, r5, r7, sl, fp}
    199c:	03050000 	movweq	r0, #20480	; 0x5000
    19a0:	00009a04 	andeq	r9, r0, r4, lsl #20
    19a4:	0012b023 	andseq	fp, r2, r3, lsr #32
    19a8:	0aa60100 	beq	fe981db0 <__bss_end+0xfe978378>
    19ac:	00001419 	andeq	r1, r0, r9, lsl r4
    19b0:	0000004d 	andeq	r0, r0, sp, asr #32
    19b4:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
    19b8:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
    19bc:	09099c01 	stmdbeq	r9, {r0, sl, fp, ip, pc}
    19c0:	68240000 	stmdavs	r4!, {}	; <UNPREDICTABLE>
    19c4:	01000021 	tsteq	r0, r1, lsr #32
    19c8:	037b1ba6 	cmneq	fp, #169984	; 0x29800
    19cc:	91030000 	mrsls	r0, (UNDEF: 3)
    19d0:	a5247fac 	strge	r7, [r4, #-4012]!	; 0xfffff054
    19d4:	01000014 	tsteq	r0, r4, lsl r0
    19d8:	004d2aa6 	subeq	r2, sp, r6, lsr #21
    19dc:	91030000 	mrsls	r0, (UNDEF: 3)
    19e0:	01227fa8 			; <UNDEFINED> instruction: 0x01227fa8
    19e4:	01000014 	tsteq	r0, r4, lsl r0
    19e8:	09090aa8 	stmdbeq	r9, {r3, r5, r7, r9, fp}
    19ec:	91030000 	mrsls	r0, (UNDEF: 3)
    19f0:	cf227fb4 	svcgt	0x00227fb4
    19f4:	01000012 	tsteq	r0, r2, lsl r0
    19f8:	003809ac 	eorseq	r0, r8, ip, lsr #19
    19fc:	91020000 	mrsls	r0, (UNDEF: 2)
    1a00:	25160074 	ldrcs	r0, [r6, #-116]	; 0xffffff8c
    1a04:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
    1a08:	17000009 	strne	r0, [r0, -r9]
    1a0c:	0000005e 	andeq	r0, r0, lr, asr r0
    1a10:	8425003f 	strthi	r0, [r5], #-63	; 0xffffffc1
    1a14:	01000014 	tsteq	r0, r4, lsl r0
    1a18:	14c70a98 	strbne	r0, [r7], #2712	; 0xa98
    1a1c:	004d0000 	subeq	r0, sp, r0
    1a20:	86780000 	ldrbthi	r0, [r8], -r0
    1a24:	003c0000 	eorseq	r0, ip, r0
    1a28:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a2c:	00000956 	andeq	r0, r0, r6, asr r9
    1a30:	71657226 	cmnvc	r5, r6, lsr #4
    1a34:	209a0100 	addscs	r0, sl, r0, lsl #2
    1a38:	00000557 	andeq	r0, r0, r7, asr r5
    1a3c:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1a40:	0000140e 	andeq	r1, r0, lr, lsl #8
    1a44:	4d0e9b01 	vstrmi	d9, [lr, #-4]
    1a48:	02000000 	andeq	r0, r0, #0
    1a4c:	27007091 			; <UNDEFINED> instruction: 0x27007091
    1a50:	00001398 	muleq	r0, r8, r3
    1a54:	eb068f01 	bl	1a5660 <__bss_end+0x19bc28>
    1a58:	3c000012 	stccc	0, cr0, [r0], {18}
    1a5c:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1a60:	01000000 	mrseq	r0, (UNDEF: 0)
    1a64:	00098f9c 	muleq	r9, ip, pc	; <UNPREDICTABLE>
    1a68:	13592400 	cmpne	r9, #0, 8
    1a6c:	8f010000 	svchi	0x00010000
    1a70:	00004d21 	andeq	r4, r0, r1, lsr #26
    1a74:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a78:	71657226 	cmnvc	r5, r6, lsr #4
    1a7c:	20910100 	addscs	r0, r1, r0, lsl #2
    1a80:	00000557 	andeq	r0, r0, r7, asr r5
    1a84:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1a88:	00143a25 	andseq	r3, r4, r5, lsr #20
    1a8c:	0a830100 	beq	fe0c1e94 <__bss_end+0xfe0b845c>
    1a90:	0000137e 	andeq	r1, r0, lr, ror r3
    1a94:	0000004d 	andeq	r0, r0, sp, asr #32
    1a98:	00008600 	andeq	r8, r0, r0, lsl #12
    1a9c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1aa0:	09cc9c01 	stmibeq	ip, {r0, sl, fp, ip, pc}^
    1aa4:	72260000 	eorvc	r0, r6, #0
    1aa8:	01007165 	tsteq	r0, r5, ror #2
    1aac:	05332085 	ldreq	r2, [r3, #-133]!	; 0xffffff7b
    1ab0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ab4:	12c82274 	sbcne	r2, r8, #116, 4	; 0x40000007
    1ab8:	86010000 	strhi	r0, [r1], -r0
    1abc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1ac0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1ac4:	15542500 	ldrbne	r2, [r4, #-1280]	; 0xfffffb00
    1ac8:	77010000 	strvc	r0, [r1, -r0]
    1acc:	00132f0a 	andseq	r2, r3, sl, lsl #30
    1ad0:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ad4:	0085c400 	addeq	ip, r5, r0, lsl #8
    1ad8:	00003c00 	andeq	r3, r0, r0, lsl #24
    1adc:	099c0100 	ldmibeq	ip, {r8}
    1ae0:	2600000a 	strcs	r0, [r0], -sl
    1ae4:	00716572 	rsbseq	r6, r1, r2, ror r5
    1ae8:	33207901 			; <UNDEFINED> instruction: 0x33207901
    1aec:	02000005 	andeq	r0, r0, #5
    1af0:	c8227491 	stmdagt	r2!, {r0, r4, r7, sl, ip, sp, lr}
    1af4:	01000012 	tsteq	r0, r2, lsl r0
    1af8:	004d0e7a 	subeq	r0, sp, sl, ror lr
    1afc:	91020000 	mrsls	r0, (UNDEF: 2)
    1b00:	92250070 	eorls	r0, r5, #112	; 0x70
    1b04:	01000013 	tsteq	r0, r3, lsl r0
    1b08:	14ae066b 	strtne	r0, [lr], #1643	; 0x66b
    1b0c:	036e0000 	cmneq	lr, #0
    1b10:	85700000 	ldrbhi	r0, [r0, #-0]!
    1b14:	00540000 	subseq	r0, r4, r0
    1b18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b1c:	00000a55 	andeq	r0, r0, r5, asr sl
    1b20:	00140e24 	andseq	r0, r4, r4, lsr #28
    1b24:	156b0100 	strbne	r0, [fp, #-256]!	; 0xffffff00
    1b28:	0000004d 	andeq	r0, r0, sp, asr #32
    1b2c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1b30:	000007e5 	andeq	r0, r0, r5, ror #15
    1b34:	4d256b01 	fstmdbxmi	r5!, {d6-d5}	;@ Deprecated
    1b38:	02000000 	andeq	r0, r0, #0
    1b3c:	4c226891 	stcmi	8, cr6, [r2], #-580	; 0xfffffdbc
    1b40:	01000015 	tsteq	r0, r5, lsl r0
    1b44:	004d0e6d 	subeq	r0, sp, sp, ror #28
    1b48:	91020000 	mrsls	r0, (UNDEF: 2)
    1b4c:	02250074 	eoreq	r0, r5, #116	; 0x74
    1b50:	01000013 	tsteq	r0, r3, lsl r0
    1b54:	14fe125e 	ldrbtne	r1, [lr], #606	; 0x25e
    1b58:	008b0000 	addeq	r0, fp, r0
    1b5c:	85200000 	strhi	r0, [r0, #-0]!
    1b60:	00500000 	subseq	r0, r0, r0
    1b64:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b68:	00000ab0 			; <UNDEFINED> instruction: 0x00000ab0
    1b6c:	000e7724 	andeq	r7, lr, r4, lsr #14
    1b70:	205e0100 	subscs	r0, lr, r0, lsl #2
    1b74:	0000004d 	andeq	r0, r0, sp, asr #32
    1b78:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1b7c:	00001443 	andeq	r1, r0, r3, asr #8
    1b80:	4d2f5e01 	stcmi	14, cr5, [pc, #-4]!	; 1b84 <shift+0x1b84>
    1b84:	02000000 	andeq	r0, r0, #0
    1b88:	e5246891 	str	r6, [r4, #-2193]!	; 0xfffff76f
    1b8c:	01000007 	tsteq	r0, r7
    1b90:	004d3f5e 	subeq	r3, sp, lr, asr pc
    1b94:	91020000 	mrsls	r0, (UNDEF: 2)
    1b98:	154c2264 	strbne	r2, [ip, #-612]	; 0xfffffd9c
    1b9c:	60010000 	andvs	r0, r1, r0
    1ba0:	00008b16 	andeq	r8, r0, r6, lsl fp
    1ba4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ba8:	14072500 	strne	r2, [r7], #-1280	; 0xfffffb00
    1bac:	52010000 	andpl	r0, r1, #0
    1bb0:	0013070a 	andseq	r0, r3, sl, lsl #14
    1bb4:	00004d00 	andeq	r4, r0, r0, lsl #26
    1bb8:	0084dc00 	addeq	sp, r4, r0, lsl #24
    1bbc:	00004400 	andeq	r4, r0, r0, lsl #8
    1bc0:	fc9c0100 	ldc2	1, cr0, [ip], {0}
    1bc4:	2400000a 	strcs	r0, [r0], #-10
    1bc8:	00000e77 	andeq	r0, r0, r7, ror lr
    1bcc:	4d1a5201 	lfmmi	f5, 4, [sl, #-4]
    1bd0:	02000000 	andeq	r0, r0, #0
    1bd4:	43246c91 			; <UNDEFINED> instruction: 0x43246c91
    1bd8:	01000014 	tsteq	r0, r4, lsl r0
    1bdc:	004d2952 	subeq	r2, sp, r2, asr r9
    1be0:	91020000 	mrsls	r0, (UNDEF: 2)
    1be4:	152d2268 	strne	r2, [sp, #-616]!	; 0xfffffd98
    1be8:	54010000 	strpl	r0, [r1], #-0
    1bec:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1bf0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bf4:	15272500 	strne	r2, [r7, #-1280]!	; 0xfffffb00
    1bf8:	45010000 	strmi	r0, [r1, #-0]
    1bfc:	0015090a 	andseq	r0, r5, sl, lsl #18
    1c00:	00004d00 	andeq	r4, r0, r0, lsl #26
    1c04:	00848c00 	addeq	r8, r4, r0, lsl #24
    1c08:	00005000 	andeq	r5, r0, r0
    1c0c:	579c0100 	ldrpl	r0, [ip, r0, lsl #2]
    1c10:	2400000b 	strcs	r0, [r0], #-11
    1c14:	00000e77 	andeq	r0, r0, r7, ror lr
    1c18:	4d194501 	cfldr32mi	mvfx4, [r9, #-4]
    1c1c:	02000000 	andeq	r0, r0, #0
    1c20:	aa246c91 	bge	91ce6c <__bss_end+0x913434>
    1c24:	01000013 	tsteq	r0, r3, lsl r0
    1c28:	011d3045 	tsteq	sp, r5, asr #32
    1c2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c30:	14702468 	ldrbtne	r2, [r0], #-1128	; 0xfffffb98
    1c34:	45010000 	strmi	r0, [r1, #-0]
    1c38:	00085841 	andeq	r5, r8, r1, asr #16
    1c3c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c40:	00154c22 	andseq	r4, r5, r2, lsr #24
    1c44:	0e470100 	dvfeqs	f0, f7, f0
    1c48:	0000004d 	andeq	r0, r0, sp, asr #32
    1c4c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c50:	0012b527 	andseq	fp, r2, r7, lsr #10
    1c54:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
    1c58:	000013b4 			; <UNDEFINED> instruction: 0x000013b4
    1c5c:	00008460 	andeq	r8, r0, r0, ror #8
    1c60:	0000002c 	andeq	r0, r0, ip, lsr #32
    1c64:	0b819c01 	bleq	fe068c70 <__bss_end+0xfe05f238>
    1c68:	77240000 	strvc	r0, [r4, -r0]!
    1c6c:	0100000e 	tsteq	r0, lr
    1c70:	004d153f 	subeq	r1, sp, pc, lsr r5
    1c74:	91020000 	mrsls	r0, (UNDEF: 2)
    1c78:	9f250074 	svcls	0x00250074
    1c7c:	01000014 	tsteq	r0, r4, lsl r0
    1c80:	14760a32 	ldrbtne	r0, [r6], #-2610	; 0xfffff5ce
    1c84:	004d0000 	subeq	r0, sp, r0
    1c88:	84100000 	ldrhi	r0, [r0], #-0
    1c8c:	00500000 	subseq	r0, r0, r0
    1c90:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c94:	00000bdc 	ldrdeq	r0, [r0], -ip
    1c98:	000e7724 	andeq	r7, lr, r4, lsr #14
    1c9c:	19320100 	ldmdbne	r2!, {r8}
    1ca0:	0000004d 	andeq	r0, r0, sp, asr #32
    1ca4:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1ca8:	00001539 	andeq	r1, r0, r9, lsr r5
    1cac:	7b2b3201 	blvc	ace4b8 <__bss_end+0xac4a80>
    1cb0:	02000003 	andeq	r0, r0, #3
    1cb4:	a9246891 	stmdbge	r4!, {r0, r4, r7, fp, sp, lr}
    1cb8:	01000014 	tsteq	r0, r4, lsl r0
    1cbc:	004d3c32 	subeq	r3, sp, r2, lsr ip
    1cc0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cc4:	14f82264 	ldrbtne	r2, [r8], #612	; 0x264
    1cc8:	34010000 	strcc	r0, [r1], #-0
    1ccc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1cd0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1cd4:	15762500 	ldrbne	r2, [r6, #-1280]!	; 0xfffffb00
    1cd8:	25010000 	strcs	r0, [r1, #-0]
    1cdc:	0015400a 	andseq	r4, r5, sl
    1ce0:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ce4:	0083c000 	addeq	ip, r3, r0
    1ce8:	00005000 	andeq	r5, r0, r0
    1cec:	379c0100 	ldrcc	r0, [ip, r0, lsl #2]
    1cf0:	2400000c 	strcs	r0, [r0], #-12
    1cf4:	00000e77 	andeq	r0, r0, r7, ror lr
    1cf8:	4d182501 	cfldr32mi	mvfx2, [r8, #-4]
    1cfc:	02000000 	andeq	r0, r0, #0
    1d00:	39246c91 	stmdbcc	r4!, {r0, r4, r7, sl, fp, sp, lr}
    1d04:	01000015 	tsteq	r0, r5, lsl r0
    1d08:	0c3d2a25 			; <UNDEFINED> instruction: 0x0c3d2a25
    1d0c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d10:	14a92468 	strtne	r2, [r9], #1128	; 0x468
    1d14:	25010000 	strcs	r0, [r1, #-0]
    1d18:	00004d3b 	andeq	r4, r0, fp, lsr sp
    1d1c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1d20:	0012d422 	andseq	sp, r2, r2, lsr #8
    1d24:	0e270100 	sufeqs	f0, f7, f0
    1d28:	0000004d 	andeq	r0, r0, sp, asr #32
    1d2c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d30:	00250418 	eoreq	r0, r5, r8, lsl r4
    1d34:	37030000 	strcc	r0, [r3, -r0]
    1d38:	2500000c 	strcs	r0, [r0, #-12]
    1d3c:	00001414 	andeq	r1, r0, r4, lsl r4
    1d40:	8c0a1901 			; <UNDEFINED> instruction: 0x8c0a1901
    1d44:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1d48:	7c000000 	stcvc	0, cr0, [r0], {-0}
    1d4c:	44000083 	strmi	r0, [r0], #-131	; 0xffffff7d
    1d50:	01000000 	mrseq	r0, (UNDEF: 0)
    1d54:	000c8e9c 	muleq	ip, ip, lr
    1d58:	156d2400 	strbne	r2, [sp, #-1024]!	; 0xfffffc00
    1d5c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1d60:	00037b1b 	andeq	r7, r3, fp, lsl fp
    1d64:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d68:	00153424 	andseq	r3, r5, r4, lsr #8
    1d6c:	35190100 	ldrcc	r0, [r9, #-256]	; 0xffffff00
    1d70:	000001c6 	andeq	r0, r0, r6, asr #3
    1d74:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1d78:	00000e77 	andeq	r0, r0, r7, ror lr
    1d7c:	4d0e1b01 	vstrmi	d1, [lr, #-4]
    1d80:	02000000 	andeq	r0, r0, #0
    1d84:	28007491 	stmdacs	r0, {r0, r4, r7, sl, ip, sp, lr}
    1d88:	0000134d 	andeq	r1, r0, sp, asr #6
    1d8c:	da061401 	ble	186d98 <__bss_end+0x17d360>
    1d90:	60000012 	andvs	r0, r0, r2, lsl r0
    1d94:	1c000083 	stcne	0, cr0, [r0], {131}	; 0x83
    1d98:	01000000 	mrseq	r0, (UNDEF: 0)
    1d9c:	157b279c 	ldrbne	r2, [fp, #-1948]!	; 0xfffff864
    1da0:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1da4:	00131306 	andseq	r1, r3, r6, lsl #6
    1da8:	00833400 	addeq	r3, r3, r0, lsl #8
    1dac:	00002c00 	andeq	r2, r0, r0, lsl #24
    1db0:	ce9c0100 	fmlgte	f0, f4, f0
    1db4:	2400000c 	strcs	r0, [r0], #-12
    1db8:	00001326 	andeq	r1, r0, r6, lsr #6
    1dbc:	38140e01 	ldmdacc	r4, {r0, r9, sl, fp}
    1dc0:	02000000 	andeq	r0, r0, #0
    1dc4:	29007491 	stmdbcs	r0, {r0, r4, r7, sl, ip, sp, lr}
    1dc8:	00001585 	andeq	r1, r0, r5, lsl #11
    1dcc:	f60a0401 			; <UNDEFINED> instruction: 0xf60a0401
    1dd0:	4d000013 	stcmi	0, cr0, [r0, #-76]	; 0xffffffb4
    1dd4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1dd8:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1ddc:	01000000 	mrseq	r0, (UNDEF: 0)
    1de0:	6970269c 	ldmdbvs	r0!, {r2, r3, r4, r7, r9, sl, sp}^
    1de4:	06010064 	streq	r0, [r1], -r4, rrx
    1de8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1dec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1df0:	06f90000 	ldrbteq	r0, [r9], r0
    1df4:	00040000 	andeq	r0, r4, r0
    1df8:	00000711 	andeq	r0, r0, r1, lsl r7
    1dfc:	15a80104 	strne	r0, [r8, #260]!	; 0x104
    1e00:	8b040000 	blhi	101e08 <__bss_end+0xf83d0>
    1e04:	49000016 	stmdbmi	r0, {r1, r2, r4}
    1e08:	64000014 	strvs	r0, [r0], #-20	; 0xffffffec
    1e0c:	dc000087 	stcle	0, cr0, [r0], {135}	; 0x87
    1e10:	0700000f 	streq	r0, [r0, -pc]
    1e14:	02000007 	andeq	r0, r0, #7
    1e18:	00000bda 	ldrdeq	r0, [r0], -sl
    1e1c:	3e110402 	cfmulscc	mvf0, mvf1, mvf2
    1e20:	05000000 	streq	r0, [r0, #-0]
    1e24:	009a1003 	addseq	r1, sl, r3
    1e28:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    1e2c:	00001bc2 	andeq	r1, r0, r2, asr #23
    1e30:	00003704 	andeq	r3, r0, r4, lsl #14
    1e34:	00670500 	rsbeq	r0, r7, r0, lsl #10
    1e38:	cb060000 	blgt	181e40 <__bss_end+0x178408>
    1e3c:	01000017 	tsteq	r0, r7, lsl r0
    1e40:	007f1005 	rsbseq	r1, pc, r5
    1e44:	30110000 	andscc	r0, r1, r0
    1e48:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1e4c:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    1e50:	43424139 	movtmi	r4, #8505	; 0x2139
    1e54:	00464544 	subeq	r4, r6, r4, asr #10
    1e58:	03010700 	movweq	r0, #5888	; 0x1700
    1e5c:	00004301 	andeq	r4, r0, r1, lsl #6
    1e60:	00970800 	addseq	r0, r7, r0, lsl #16
    1e64:	007f0000 	rsbseq	r0, pc, r0
    1e68:	84090000 	strhi	r0, [r9], #-0
    1e6c:	10000000 	andne	r0, r0, r0
    1e70:	006f0400 	rsbeq	r0, pc, r0, lsl #8
    1e74:	04030000 	streq	r0, [r3], #-0
    1e78:	001df807 	andseq	pc, sp, r7, lsl #16
    1e7c:	00840400 	addeq	r0, r4, r0, lsl #8
    1e80:	01030000 	mrseq	r0, (UNDEF: 3)
    1e84:	000d6408 	andeq	r6, sp, r8, lsl #8
    1e88:	00900400 	addseq	r0, r0, r0, lsl #8
    1e8c:	480a0000 	stmdami	sl, {}	; <UNPREDICTABLE>
    1e90:	0b000000 	bleq	1e98 <shift+0x1e98>
    1e94:	000017bf 			; <UNDEFINED> instruction: 0x000017bf
    1e98:	3607fc01 	strcc	pc, [r7], -r1, lsl #24
    1e9c:	37000017 	smladcc	r0, r7, r0, r0
    1ea0:	30000000 	andcc	r0, r0, r0
    1ea4:	10000096 	mulne	r0, r6, r0
    1ea8:	01000001 	tsteq	r0, r1
    1eac:	00011d9c 	muleq	r1, ip, sp
    1eb0:	00730c00 	rsbseq	r0, r3, r0, lsl #24
    1eb4:	1d18fc01 	ldcne	12, cr15, [r8, #-4]
    1eb8:	02000001 	andeq	r0, r0, #1
    1ebc:	720d6491 	andvc	r6, sp, #-1862270976	; 0x91000000
    1ec0:	01007a65 	tsteq	r0, r5, ror #20
    1ec4:	003709fe 	ldrshteq	r0, [r7], -lr
    1ec8:	91020000 	mrsls	r0, (UNDEF: 2)
    1ecc:	18590e74 	ldmdane	r9, {r2, r4, r5, r6, r9, sl, fp}^
    1ed0:	fe010000 	cdp2	0, 0, cr0, cr1, cr0, {0}
    1ed4:	00003712 	andeq	r3, r0, r2, lsl r7
    1ed8:	70910200 	addsvc	r0, r1, r0, lsl #4
    1edc:	0096740f 	addseq	r7, r6, pc, lsl #8
    1ee0:	0000a800 	andeq	sl, r0, r0, lsl #16
    1ee4:	16fd1000 	ldrbtne	r1, [sp], r0
    1ee8:	03010000 	movweq	r0, #4096	; 0x1000
    1eec:	01230c01 			; <UNDEFINED> instruction: 0x01230c01
    1ef0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ef4:	968c0f6c 	strls	r0, [ip], ip, ror #30
    1ef8:	00800000 	addeq	r0, r0, r0
    1efc:	64110000 	ldrvs	r0, [r1], #-0
    1f00:	01080100 	mrseq	r0, (UNDEF: 24)
    1f04:	00012309 	andeq	r2, r1, r9, lsl #6
    1f08:	68910200 	ldmvs	r1, {r9}
    1f0c:	12000000 	andne	r0, r0, #0
    1f10:	00009704 	andeq	r9, r0, r4, lsl #14
    1f14:	05041300 	streq	r1, [r4, #-768]	; 0xfffffd00
    1f18:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1f1c:	0017d714 	andseq	sp, r7, r4, lsl r7
    1f20:	06c10100 	strbeq	r0, [r1], r0, lsl #2
    1f24:	00001841 	andeq	r1, r0, r1, asr #16
    1f28:	0000930c 	andeq	r9, r0, ip, lsl #6
    1f2c:	00000324 	andeq	r0, r0, r4, lsr #6
    1f30:	02299c01 	eoreq	r9, r9, #256	; 0x100
    1f34:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    1f38:	11c10100 	bicne	r0, r1, r0, lsl #2
    1f3c:	00000037 	andeq	r0, r0, r7, lsr r0
    1f40:	7fa49103 	svcvc	0x00a49103
    1f44:	7266620c 	rsbvc	r6, r6, #12, 4	; 0xc0000000
    1f48:	1ac10100 	bne	ff042350 <__bss_end+0xff038918>
    1f4c:	00000229 	andeq	r0, r0, r9, lsr #4
    1f50:	7fa09103 	svcvc	0x00a09103
    1f54:	00170f15 	andseq	r0, r7, r5, lsl pc
    1f58:	32c10100 	sbccc	r0, r1, #0, 2
    1f5c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1f60:	7f9c9103 	svcvc	0x009c9103
    1f64:	00181a0e 	andseq	r1, r8, lr, lsl #20
    1f68:	0fc30100 	svceq	0x00c30100
    1f6c:	00000084 	andeq	r0, r0, r4, lsl #1
    1f70:	0e749102 	expeqs	f1, f2
    1f74:	00001803 	andeq	r1, r0, r3, lsl #16
    1f78:	2306d901 	movwcs	sp, #26881	; 0x6901
    1f7c:	02000001 	andeq	r0, r0, #1
    1f80:	180e7091 	stmdane	lr, {r0, r4, r7, ip, sp, lr}
    1f84:	01000017 	tsteq	r0, r7, lsl r0
    1f88:	003e11dd 	ldrsbteq	r1, [lr], -sp
    1f8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1f90:	16d50e64 	ldrbne	r0, [r5], r4, ror #28
    1f94:	e0010000 	and	r0, r1, r0
    1f98:	00008b18 	andeq	r8, r0, r8, lsl fp
    1f9c:	60910200 	addsvs	r0, r1, r0, lsl #4
    1fa0:	0016e40e 	andseq	lr, r6, lr, lsl #8
    1fa4:	18e10100 	stmiane	r1!, {r8}^
    1fa8:	0000008b 	andeq	r0, r0, fp, lsl #1
    1fac:	0e5c9102 	logeqe	f1, f2
    1fb0:	0000178a 	andeq	r1, r0, sl, lsl #15
    1fb4:	2f07e301 	svccs	0x0007e301
    1fb8:	03000002 	movweq	r0, #2
    1fbc:	0e7fb891 	mrceq	8, 3, fp, cr15, cr1, {4}
    1fc0:	0000171e 	andeq	r1, r0, lr, lsl r7
    1fc4:	2306e501 	movwcs	lr, #25857	; 0x6501
    1fc8:	02000001 	andeq	r0, r0, #1
    1fcc:	18165891 	ldmdane	r6, {r0, r4, r7, fp, ip, lr}
    1fd0:	50000095 	mulpl	r0, r5, r0
    1fd4:	f7000000 			; <UNDEFINED> instruction: 0xf7000000
    1fd8:	0d000001 	stceq	0, cr0, [r0, #-4]
    1fdc:	e7010069 	str	r0, [r1, -r9, rrx]
    1fe0:	0001230b 	andeq	r2, r1, fp, lsl #6
    1fe4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1fe8:	95740f00 	ldrbls	r0, [r4, #-3840]!	; 0xfffff100
    1fec:	00980000 	addseq	r0, r8, r0
    1ff0:	080e0000 	stmdaeq	lr, {}	; <UNPREDICTABLE>
    1ff4:	01000017 	tsteq	r0, r7, lsl r0
    1ff8:	023f08ef 	eorseq	r0, pc, #15663104	; 0xef0000
    1ffc:	91030000 	mrsls	r0, (UNDEF: 3)
    2000:	a40f7fac 	strge	r7, [pc], #-4012	; 2008 <shift+0x2008>
    2004:	68000095 	stmdavs	r0, {r0, r2, r4, r7}
    2008:	0d000000 	stceq	0, cr0, [r0, #-0]
    200c:	f2010069 	vhadd.s8	q0, <illegal reg q0.5>, <illegal reg q12.5>
    2010:	0001230c 	andeq	r2, r1, ip, lsl #6
    2014:	68910200 	ldmvs	r1, {r9}
    2018:	12000000 	andne	r0, r0, #0
    201c:	00009004 	andeq	r9, r0, r4
    2020:	00900800 	addseq	r0, r0, r0, lsl #16
    2024:	023f0000 	eorseq	r0, pc, #0
    2028:	84090000 	strhi	r0, [r9], #-0
    202c:	1f000000 	svcne	0x00000000
    2030:	00900800 	addseq	r0, r0, r0, lsl #16
    2034:	024f0000 	subeq	r0, pc, #0
    2038:	84090000 	strhi	r0, [r9], #-0
    203c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2040:	17d71400 	ldrbne	r1, [r7, r0, lsl #8]
    2044:	bb010000 	bllt	4204c <__bss_end+0x38614>
    2048:	0018a606 	andseq	sl, r8, r6, lsl #12
    204c:	0092dc00 	addseq	sp, r2, r0, lsl #24
    2050:	00003000 	andeq	r3, r0, r0
    2054:	869c0100 	ldrhi	r0, [ip], r0, lsl #2
    2058:	0c000002 	stceq	0, cr0, [r0], {2}
    205c:	bb010078 	bllt	42244 <__bss_end+0x3880c>
    2060:	00003711 	andeq	r3, r0, r1, lsl r7
    2064:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2068:	7266620c 	rsbvc	r6, r6, #12, 4	; 0xc0000000
    206c:	1abb0100 	bne	feec2474 <__bss_end+0xfeeb8a3c>
    2070:	00000229 	andeq	r0, r0, r9, lsr #4
    2074:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2078:	0016de0b 	andseq	sp, r6, fp, lsl #28
    207c:	06b50100 	ldrteq	r0, [r5], r0, lsl #2
    2080:	00001795 	muleq	r0, r5, r7
    2084:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    2088:	0000929c 	muleq	r0, ip, r2
    208c:	00000040 	andeq	r0, r0, r0, asr #32
    2090:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    2094:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2098:	12b50100 	adcsne	r0, r5, #0, 2
    209c:	00000037 	andeq	r0, r0, r7, lsr r0
    20a0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    20a4:	3f020103 	svccc	0x00020103
    20a8:	0b00000a 	bleq	20d8 <shift+0x20d8>
    20ac:	000016cf 	andeq	r1, r0, pc, asr #13
    20b0:	5206b001 	andpl	fp, r6, #1
    20b4:	b2000017 	andlt	r0, r0, #23
    20b8:	60000002 	andvs	r0, r0, r2
    20bc:	3c000092 	stccc	0, cr0, [r0], {146}	; 0x92
    20c0:	01000000 	mrseq	r0, (UNDEF: 0)
    20c4:	0002e59c 	muleq	r2, ip, r5
    20c8:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    20cc:	3712b001 	ldrcc	fp, [r2, -r1]
    20d0:	02000000 	andeq	r0, r0, #0
    20d4:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    20d8:	0000188e 	andeq	r1, r0, lr, lsl #17
    20dc:	dc06a501 	cfstr32le	mvfx10, [r6], {1}
    20e0:	8c000017 	stchi	0, cr0, [r0], {23}
    20e4:	d4000091 	strle	r0, [r0], #-145	; 0xffffff6f
    20e8:	01000000 	mrseq	r0, (UNDEF: 0)
    20ec:	00033a9c 	muleq	r3, ip, sl
    20f0:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    20f4:	842ba501 	strthi	sl, [fp], #-1281	; 0xfffffaff
    20f8:	02000000 	andeq	r0, r0, #0
    20fc:	620c6c91 	andvs	r6, ip, #37120	; 0x9100
    2100:	01007266 	tsteq	r0, r6, ror #4
    2104:	022934a5 	eoreq	r3, r9, #-1526726656	; 0xa5000000
    2108:	91020000 	mrsls	r0, (UNDEF: 2)
    210c:	18281568 	stmdane	r8!, {r3, r5, r6, r8, sl, ip}
    2110:	a5010000 	strge	r0, [r1, #-0]
    2114:	0001233d 	andeq	r2, r1, sp, lsr r3
    2118:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    211c:	00181a0e 	andseq	r1, r8, lr, lsl #20
    2120:	06a70100 	strteq	r0, [r7], r0, lsl #2
    2124:	00000123 	andeq	r0, r0, r3, lsr #2
    2128:	00749102 	rsbseq	r9, r4, r2, lsl #2
    212c:	00184d17 	andseq	r4, r8, r7, lsl sp
    2130:	06830100 	streq	r0, [r3], r0, lsl #2
    2134:	000017a8 	andeq	r1, r0, r8, lsr #15
    2138:	00008d4c 	andeq	r8, r0, ip, asr #26
    213c:	00000440 	andeq	r0, r0, r0, asr #8
    2140:	039e9c01 	orrseq	r9, lr, #256	; 0x100
    2144:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2148:	18830100 	stmne	r3, {r8}
    214c:	00000037 	andeq	r0, r0, r7, lsr r0
    2150:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    2154:	000016d5 	ldrdeq	r1, [r0], -r5
    2158:	9e298301 	cdpls	3, 2, cr8, cr9, cr1, {0}
    215c:	02000003 	andeq	r0, r0, #3
    2160:	e4156891 	ldr	r6, [r5], #-2193	; 0xfffff76f
    2164:	01000016 	tsteq	r0, r6, lsl r0
    2168:	039e4183 	orrseq	r4, lr, #-1073741792	; 0xc0000020
    216c:	91020000 	mrsls	r0, (UNDEF: 2)
    2170:	172d1564 	strne	r1, [sp, -r4, ror #10]!
    2174:	83010000 	movwhi	r0, #4096	; 0x1000
    2178:	0003a44f 	andeq	sl, r3, pc, asr #8
    217c:	60910200 	addsvs	r0, r1, r0, lsl #4
    2180:	0016c50e 	andseq	ip, r6, lr, lsl #10
    2184:	0b960100 	bleq	fe58258c <__bss_end+0xfe578b54>
    2188:	00000037 	andeq	r0, r0, r7, lsr r0
    218c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2190:	00840418 	addeq	r0, r4, r8, lsl r4
    2194:	04180000 	ldreq	r0, [r8], #-0
    2198:	00000123 	andeq	r0, r0, r3, lsr #2
    219c:	0018c614 	andseq	ip, r8, r4, lsl r6
    21a0:	06760100 	ldrbteq	r0, [r6], -r0, lsl #2
    21a4:	00001746 	andeq	r1, r0, r6, asr #14
    21a8:	00008c88 	andeq	r8, r0, r8, lsl #25
    21ac:	000000c4 	andeq	r0, r0, r4, asr #1
    21b0:	03ff9c01 	mvnseq	r9, #256	; 0x100
    21b4:	85150000 	ldrhi	r0, [r5, #-0]
    21b8:	01000017 	tsteq	r0, r7, lsl r0
    21bc:	02291376 	eoreq	r1, r9, #-671088639	; 0xd8000001
    21c0:	91020000 	mrsls	r0, (UNDEF: 2)
    21c4:	00690d64 	rsbeq	r0, r9, r4, ror #26
    21c8:	23097801 	movwcs	r7, #38913	; 0x9801
    21cc:	02000001 	andeq	r0, r0, #1
    21d0:	6c0d7491 	cfstrsvs	mvf7, [sp], {145}	; 0x91
    21d4:	01006e65 	tsteq	r0, r5, ror #28
    21d8:	01230c78 			; <UNDEFINED> instruction: 0x01230c78
    21dc:	91020000 	mrsls	r0, (UNDEF: 2)
    21e0:	17670e70 			; <UNDEFINED> instruction: 0x17670e70
    21e4:	78010000 	stmdavc	r1, {}	; <UNPREDICTABLE>
    21e8:	00012311 	andeq	r2, r1, r1, lsl r3
    21ec:	6c910200 	lfmvs	f0, 4, [r1], {0}
    21f0:	6f701900 	svcvs	0x00701900
    21f4:	6d010077 	stcvs	0, cr0, [r1, #-476]	; 0xfffffe24
    21f8:	00179f07 	andseq	r9, r7, r7, lsl #30
    21fc:	00003700 	andeq	r3, r0, r0, lsl #14
    2200:	008c1c00 	addeq	r1, ip, r0, lsl #24
    2204:	00006c00 	andeq	r6, r0, r0, lsl #24
    2208:	5c9c0100 	ldfpls	f0, [ip], {0}
    220c:	0c000004 	stceq	0, cr0, [r0], {4}
    2210:	6d010078 	stcvs	0, cr0, [r1, #-480]	; 0xfffffe20
    2214:	00003e17 	andeq	r3, r0, r7, lsl lr
    2218:	6c910200 	lfmvs	f0, 4, [r1], {0}
    221c:	01006e0c 	tsteq	r0, ip, lsl #28
    2220:	008b2d6d 	addeq	r2, fp, sp, ror #26
    2224:	91020000 	mrsls	r0, (UNDEF: 2)
    2228:	00720d68 	rsbseq	r0, r2, r8, ror #26
    222c:	370b6f01 	strcc	r6, [fp, -r1, lsl #30]
    2230:	02000000 	andeq	r0, r0, #0
    2234:	380f7491 	stmdacc	pc, {r0, r4, r7, sl, ip, sp, lr}	; <UNPREDICTABLE>
    2238:	3800008c 	stmdacc	r0, {r2, r3, r7}
    223c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2240:	70010069 	andvc	r0, r1, r9, rrx
    2244:	00008416 	andeq	r8, r0, r6, lsl r4
    2248:	70910200 	addsvc	r0, r1, r0, lsl #4
    224c:	13170000 	tstne	r7, #0
    2250:	01000018 	tsteq	r0, r8, lsl r0
    2254:	167b0664 	ldrbtne	r0, [fp], -r4, ror #12
    2258:	8b9c0000 	blhi	fe702260 <__bss_end+0xfe6f8828>
    225c:	00800000 	addeq	r0, r0, r0
    2260:	9c010000 	stcls	0, cr0, [r1], {-0}
    2264:	000004d9 	ldrdeq	r0, [r0], -r9
    2268:	6372730c 	cmnvs	r2, #12, 6	; 0x30000000
    226c:	19640100 	stmdbne	r4!, {r8}^
    2270:	000004d9 	ldrdeq	r0, [r0], -r9
    2274:	0c649102 	stfeqp	f1, [r4], #-8
    2278:	00747364 	rsbseq	r7, r4, r4, ror #6
    227c:	e0246401 	eor	r6, r4, r1, lsl #8
    2280:	02000004 	andeq	r0, r0, #4
    2284:	6e0c6091 	mcrvs	0, 0, r6, cr12, cr1, {4}
    2288:	01006d75 	tsteq	r0, r5, ror sp
    228c:	01232d64 			; <UNDEFINED> instruction: 0x01232d64
    2290:	91020000 	mrsls	r0, (UNDEF: 2)
    2294:	17fc0e5c 	ubfxne	r0, ip, #28, #29
    2298:	66010000 	strvs	r0, [r1], -r0
    229c:	00011d0e 	andeq	r1, r1, lr, lsl #26
    22a0:	70910200 	addsvc	r0, r1, r0, lsl #4
    22a4:	0017c40e 	andseq	ip, r7, lr, lsl #8
    22a8:	08670100 	stmdaeq	r7!, {r8}^
    22ac:	00000229 	andeq	r0, r0, r9, lsr #4
    22b0:	0f6c9102 	svceq	0x006c9102
    22b4:	00008bc4 	andeq	r8, r0, r4, asr #23
    22b8:	00000048 	andeq	r0, r0, r8, asr #32
    22bc:	0100690d 	tsteq	r0, sp, lsl #18
    22c0:	01230b69 			; <UNDEFINED> instruction: 0x01230b69
    22c4:	91020000 	mrsls	r0, (UNDEF: 2)
    22c8:	12000074 	andne	r0, r0, #116	; 0x74
    22cc:	0004df04 	andeq	sp, r4, r4, lsl #30
    22d0:	041b1a00 	ldreq	r1, [fp], #-2560	; 0xfffff600
    22d4:	00180d17 	andseq	r0, r8, r7, lsl sp
    22d8:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    22dc:	0000176c 	andeq	r1, r0, ip, ror #14
    22e0:	00008b34 	andeq	r8, r0, r4, lsr fp
    22e4:	00000068 	andeq	r0, r0, r8, rrx
    22e8:	05419c01 	strbeq	r9, [r1, #-3073]	; 0xfffff3ff
    22ec:	b1150000 	tstlt	r5, r0
    22f0:	01000018 	tsteq	r0, r8, lsl r0
    22f4:	04e0125c 	strbteq	r1, [r0], #604	; 0x25c
    22f8:	91020000 	mrsls	r0, (UNDEF: 2)
    22fc:	18b8156c 	ldmne	r8!, {r2, r3, r5, r6, r8, sl, ip}
    2300:	5c010000 	stcpl	0, cr0, [r1], {-0}
    2304:	0001231e 	andeq	r2, r1, lr, lsl r3
    2308:	68910200 	ldmvs	r1, {r9}
    230c:	6d656d0d 	stclvs	13, cr6, [r5, #-52]!	; 0xffffffcc
    2310:	085e0100 	ldmdaeq	lr, {r8}^
    2314:	00000229 	andeq	r0, r0, r9, lsr #4
    2318:	0f709102 	svceq	0x00709102
    231c:	00008b50 	andeq	r8, r0, r0, asr fp
    2320:	0000003c 	andeq	r0, r0, ip, lsr r0
    2324:	0100690d 	tsteq	r0, sp, lsl #18
    2328:	01230b60 			; <UNDEFINED> instruction: 0x01230b60
    232c:	91020000 	mrsls	r0, (UNDEF: 2)
    2330:	0b000074 	bleq	2508 <shift+0x2508>
    2334:	000018bf 			; <UNDEFINED> instruction: 0x000018bf
    2338:	5e055201 	cdppl	2, 0, cr5, cr5, cr1, {0}
    233c:	23000018 	movwcs	r0, #24
    2340:	e0000001 	and	r0, r0, r1
    2344:	5400008a 	strpl	r0, [r0], #-138	; 0xffffff76
    2348:	01000000 	mrseq	r0, (UNDEF: 0)
    234c:	00057a9c 	muleq	r5, ip, sl
    2350:	00730c00 	rsbseq	r0, r3, r0, lsl #24
    2354:	1d185201 	lfmne	f5, 4, [r8, #-4]
    2358:	02000001 	andeq	r0, r0, #1
    235c:	690d6c91 	stmdbvs	sp, {r0, r4, r7, sl, fp, sp, lr}
    2360:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    2364:	00000123 	andeq	r0, r0, r3, lsr #2
    2368:	00749102 	rsbseq	r9, r4, r2, lsl #2
    236c:	0018200b 	andseq	r2, r8, fp
    2370:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    2374:	0000186b 	andeq	r1, r0, fp, ror #16
    2378:	00000123 	andeq	r0, r0, r3, lsr #2
    237c:	00008a34 	andeq	r8, r0, r4, lsr sl
    2380:	000000ac 	andeq	r0, r0, ip, lsr #1
    2384:	05e09c01 	strbeq	r9, [r0, #3073]!	; 0xc01
    2388:	730c0000 	movwvc	r0, #49152	; 0xc000
    238c:	42010031 	andmi	r0, r1, #49	; 0x31
    2390:	00011d19 	andeq	r1, r1, r9, lsl sp
    2394:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2398:	0032730c 	eorseq	r7, r2, ip, lsl #6
    239c:	1d294201 	sfmne	f4, 4, [r9, #-4]!
    23a0:	02000001 	andeq	r0, r0, #1
    23a4:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    23a8:	01006d75 	tsteq	r0, r5, ror sp
    23ac:	01233142 			; <UNDEFINED> instruction: 0x01233142
    23b0:	91020000 	mrsls	r0, (UNDEF: 2)
    23b4:	31750d64 	cmncc	r5, r4, ror #26
    23b8:	10440100 	subne	r0, r4, r0, lsl #2
    23bc:	000005e0 	andeq	r0, r0, r0, ror #11
    23c0:	0d779102 	ldfeqp	f1, [r7, #-8]!
    23c4:	01003275 	tsteq	r0, r5, ror r2
    23c8:	05e01444 	strbeq	r1, [r0, #1092]!	; 0x444
    23cc:	91020000 	mrsls	r0, (UNDEF: 2)
    23d0:	01030076 	tsteq	r3, r6, ror r0
    23d4:	000d5b08 	andeq	r5, sp, r8, lsl #22
    23d8:	17780b00 	ldrbne	r0, [r8, -r0, lsl #22]!
    23dc:	36010000 	strcc	r0, [r1], -r0
    23e0:	00187d07 	andseq	r7, r8, r7, lsl #26
    23e4:	00022900 	andeq	r2, r2, r0, lsl #18
    23e8:	00897400 	addeq	r7, r9, r0, lsl #8
    23ec:	0000c000 	andeq	ip, r0, r0
    23f0:	409c0100 	addsmi	r0, ip, r0, lsl #2
    23f4:	15000006 	strne	r0, [r0, #-6]
    23f8:	00001741 	andeq	r1, r0, r1, asr #14
    23fc:	29153601 	ldmdbcs	r5, {r0, r9, sl, ip, sp}
    2400:	02000002 	andeq	r0, r0, #2
    2404:	730c6c91 	movwvc	r6, #52369	; 0xcc91
    2408:	01006372 	tsteq	r0, r2, ror r3
    240c:	011d2736 	tsteq	sp, r6, lsr r7
    2410:	91020000 	mrsls	r0, (UNDEF: 2)
    2414:	756e0c68 	strbvc	r0, [lr, #-3176]!	; 0xfffff398
    2418:	3601006d 	strcc	r0, [r1], -sp, rrx
    241c:	00012330 	andeq	r2, r1, r0, lsr r3
    2420:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2424:	0100690d 	tsteq	r0, sp, lsl #18
    2428:	01230638 			; <UNDEFINED> instruction: 0x01230638
    242c:	91020000 	mrsls	r0, (UNDEF: 2)
    2430:	f80b0074 			; <UNDEFINED> instruction: 0xf80b0074
    2434:	01000016 	tsteq	r0, r6, lsl r0
    2438:	182f0524 	stmdane	pc!, {r2, r5, r8, sl}	; <UNPREDICTABLE>
    243c:	01230000 			; <UNDEFINED> instruction: 0x01230000
    2440:	88d80000 	ldmhi	r8, {}^	; <UNPREDICTABLE>
    2444:	009c0000 	addseq	r0, ip, r0
    2448:	9c010000 	stcls	0, cr0, [r1], {-0}
    244c:	0000067d 	andeq	r0, r0, sp, ror r6
    2450:	00175c15 	andseq	r5, r7, r5, lsl ip
    2454:	16240100 	strtne	r0, [r4], -r0, lsl #2
    2458:	0000011d 	andeq	r0, r0, sp, lsl r1
    245c:	0e6c9102 	lgneqe	f1, f2
    2460:	0000183a 	andeq	r1, r0, sl, lsr r8
    2464:	23062601 	movwcs	r2, #26113	; 0x6601
    2468:	02000001 	andeq	r0, r0, #1
    246c:	1c007491 	cfstrsne	mvf7, [r0], {145}	; 0x91
    2470:	00001780 	andeq	r1, r0, r0, lsl #15
    2474:	ec060801 	stc	8, cr0, [r6], {1}
    2478:	64000016 	strvs	r0, [r0], #-22	; 0xffffffea
    247c:	74000087 	strvc	r0, [r0], #-135	; 0xffffff79
    2480:	01000001 	tsteq	r0, r1
    2484:	175c159c 			; <UNDEFINED> instruction: 0x175c159c
    2488:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    248c:	00008418 	andeq	r8, r0, r8, lsl r4
    2490:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2494:	00183a15 	andseq	r3, r8, r5, lsl sl
    2498:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    249c:	00000229 	andeq	r0, r0, r9, lsr #4
    24a0:	15609102 	strbne	r9, [r0, #-258]!	; 0xfffffefe
    24a4:	00001762 	andeq	r1, r0, r2, ror #14
    24a8:	843a0801 	ldrthi	r0, [sl], #-2049	; 0xfffff7ff
    24ac:	02000000 	andeq	r0, r0, #0
    24b0:	690d5c91 	stmdbvs	sp, {r0, r4, r7, sl, fp, ip, lr}
    24b4:	060a0100 	streq	r0, [sl], -r0, lsl #2
    24b8:	00000123 	andeq	r0, r0, r3, lsr #2
    24bc:	0f749102 	svceq	0x00749102
    24c0:	00008830 	andeq	r8, r0, r0, lsr r8
    24c4:	00000098 	muleq	r0, r8, r0
    24c8:	01006a0d 	tsteq	r0, sp, lsl #20
    24cc:	01230b1c 			; <UNDEFINED> instruction: 0x01230b1c
    24d0:	91020000 	mrsls	r0, (UNDEF: 2)
    24d4:	88580f70 	ldmdahi	r8, {r4, r5, r6, r8, r9, sl, fp}^
    24d8:	00600000 	rsbeq	r0, r0, r0
    24dc:	630d0000 	movwvs	r0, #53248	; 0xd000
    24e0:	081e0100 	ldmdaeq	lr, {r8}
    24e4:	00000090 	muleq	r0, r0, r0
    24e8:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    24ec:	22000000 	andcs	r0, r0, #0
    24f0:	02000000 	andeq	r0, r0, #0
    24f4:	0008bb00 	andeq	fp, r8, r0, lsl #22
    24f8:	49010400 	stmdbmi	r1, {sl}
    24fc:	4000000d 	andmi	r0, r0, sp
    2500:	4c000097 	stcmi	0, cr0, [r0], {151}	; 0x97
    2504:	cd000099 	stcgt	0, cr0, [r0, #-612]	; 0xfffffd9c
    2508:	fd000018 	stc2	0, cr0, [r0, #-96]	; 0xffffffa0
    250c:	63000018 	movwvs	r0, #24
    2510:	01000000 	mrseq	r0, (UNDEF: 0)
    2514:	00002280 	andeq	r2, r0, r0, lsl #5
    2518:	cf000200 	svcgt	0x00000200
    251c:	04000008 	streq	r0, [r0], #-8
    2520:	000dc601 	andeq	ip, sp, r1, lsl #12
    2524:	00994c00 	addseq	r4, r9, r0, lsl #24
    2528:	00995000 	addseq	r5, r9, r0
    252c:	0018cd00 	andseq	ip, r8, r0, lsl #26
    2530:	0018fd00 	andseq	pc, r8, r0, lsl #26
    2534:	00006300 	andeq	r6, r0, r0, lsl #6
    2538:	32800100 	addcc	r0, r0, #0, 2
    253c:	04000009 	streq	r0, [r0], #-9
    2540:	0008e300 	andeq	lr, r8, r0, lsl #6
    2544:	cb010400 	blgt	4354c <__bss_end+0x39b14>
    2548:	0c00001c 	stceq	0, cr0, [r0], {28}
    254c:	00001c22 	andeq	r1, r0, r2, lsr #24
    2550:	000018fd 	strdeq	r1, [r0], -sp
    2554:	00000e26 	andeq	r0, r0, r6, lsr #28
    2558:	69050402 	stmdbvs	r5, {r1, sl}
    255c:	0300746e 	movweq	r7, #1134	; 0x46e
    2560:	1df80704 	ldclne	7, cr0, [r8, #16]!
    2564:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2568:	00031f05 	andeq	r1, r3, r5, lsl #30
    256c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2570:	000024ca 	andeq	r2, r0, sl, asr #9
    2574:	001c7d04 	andseq	r7, ip, r4, lsl #26
    2578:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    257c:	00000024 	andeq	r0, r0, r4, lsr #32
    2580:	0020ec04 	eoreq	lr, r0, r4, lsl #24
    2584:	152f0100 	strne	r0, [pc, #-256]!	; 248c <shift+0x248c>
    2588:	00000051 	andeq	r0, r0, r1, asr r0
    258c:	00570405 	subseq	r0, r7, r5, lsl #8
    2590:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    2594:	66000000 	strvs	r0, [r0], -r0
    2598:	07000000 	streq	r0, [r0, -r0]
    259c:	00000066 	andeq	r0, r0, r6, rrx
    25a0:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    25a4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    25a8:	00281e04 	eoreq	r1, r8, r4, lsl #28
    25ac:	0f360100 	svceq	0x00360100
    25b0:	00000079 	andeq	r0, r0, r9, ror r0
    25b4:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    25b8:	1d060000 	stcne	0, cr0, [r6, #-0]
    25bc:	93000000 	movwls	r0, #0
    25c0:	07000000 	streq	r0, [r0, -r0]
    25c4:	00000066 	andeq	r0, r0, r6, rrx
    25c8:	00006607 	andeq	r6, r0, r7, lsl #12
    25cc:	01030000 	mrseq	r0, (UNDEF: 3)
    25d0:	000d5b08 	andeq	r5, sp, r8, lsl #22
    25d4:	23240900 			; <UNDEFINED> instruction: 0x23240900
    25d8:	bb010000 	bllt	425e0 <__bss_end+0x38ba8>
    25dc:	00004512 	andeq	r4, r0, r2, lsl r5
    25e0:	284c0900 	stmdacs	ip, {r8, fp}^
    25e4:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    25e8:	00006d10 	andeq	r6, r0, r0, lsl sp
    25ec:	06010300 	streq	r0, [r1], -r0, lsl #6
    25f0:	00000d5d 	andeq	r0, r0, sp, asr sp
    25f4:	00200c0a 	eoreq	r0, r0, sl, lsl #24
    25f8:	93010700 	movwls	r0, #5888	; 0x1700
    25fc:	02000000 	andeq	r0, r0, #0
    2600:	01e60617 	mvneq	r0, r7, lsl r6
    2604:	db0b0000 	blle	2c260c <__bss_end+0x2b8bd4>
    2608:	0000001a 	andeq	r0, r0, sl, lsl r0
    260c:	001f290b 	andseq	r2, pc, fp, lsl #18
    2610:	ef0b0100 	svc	0x000b0100
    2614:	02000023 	andeq	r0, r0, #35	; 0x23
    2618:	0027600b 	eoreq	r6, r7, fp
    261c:	930b0300 	movwls	r0, #45824	; 0xb300
    2620:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2624:	0026690b 	eoreq	r6, r6, fp, lsl #18
    2628:	cd0b0500 	cfstr32gt	mvfx0, [fp, #-0]
    262c:	06000025 	streq	r0, [r0], -r5, lsr #32
    2630:	001afc0b 	andseq	pc, sl, fp, lsl #24
    2634:	7e0b0700 	cdpvc	7, 0, cr0, cr11, cr0, {0}
    2638:	08000026 	stmdaeq	r0, {r1, r2, r5}
    263c:	00268c0b 	eoreq	r8, r6, fp, lsl #24
    2640:	530b0900 	movwpl	r0, #47360	; 0xb900
    2644:	0a000027 	beq	26e8 <shift+0x26e8>
    2648:	0022ea0b 	eoreq	lr, r2, fp, lsl #20
    264c:	be0b0b00 	vmlalt.f64	d0, d11, d0
    2650:	0c00001c 	stceq	0, cr0, [r0], {28}
    2654:	001d9b0b 	andseq	r9, sp, fp, lsl #22
    2658:	500b0d00 	andpl	r0, fp, r0, lsl #26
    265c:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    2660:	0020660b 	eoreq	r6, r0, fp, lsl #12
    2664:	630b0f00 	movwvs	r0, #48896	; 0xbf00
    2668:	1000001f 	andne	r0, r0, pc, lsl r0
    266c:	0023770b 	eoreq	r7, r3, fp, lsl #14
    2670:	cf0b1100 	svcgt	0x000b1100
    2674:	1200001f 	andne	r0, r0, #31
    2678:	0029e50b 	eoreq	lr, r9, fp, lsl #10
    267c:	650b1300 	strvs	r1, [fp, #-768]	; 0xfffffd00
    2680:	1400001b 	strne	r0, [r0], #-27	; 0xffffffe5
    2684:	001ff30b 	andseq	pc, pc, fp, lsl #6
    2688:	a20b1500 	andge	r1, fp, #0, 10
    268c:	1600001a 			; <UNDEFINED> instruction: 0x1600001a
    2690:	0027830b 	eoreq	r8, r7, fp, lsl #6
    2694:	a50b1700 	strge	r1, [fp, #-1792]	; 0xfffff900
    2698:	18000028 	stmdane	r0, {r3, r5}
    269c:	0020180b 	eoreq	r1, r0, fp, lsl #16
    26a0:	610b1900 	tstvs	fp, r0, lsl #18
    26a4:	1a000024 	bne	273c <shift+0x273c>
    26a8:	0027910b 	eoreq	r9, r7, fp, lsl #2
    26ac:	d10b1b00 	tstle	fp, r0, lsl #22
    26b0:	1c000019 	stcne	0, cr0, [r0], {25}
    26b4:	00279f0b 	eoreq	r9, r7, fp, lsl #30
    26b8:	ad0b1d00 	stcge	13, cr1, [fp, #-0]
    26bc:	1e000027 	cdpne	0, 0, cr0, cr0, cr7, {1}
    26c0:	00197f0b 	andseq	r7, r9, fp, lsl #30
    26c4:	d70b1f00 	strle	r1, [fp, -r0, lsl #30]
    26c8:	20000027 	andcs	r0, r0, r7, lsr #32
    26cc:	00250e0b 	eoreq	r0, r5, fp, lsl #28
    26d0:	490b2100 	stmdbmi	fp, {r8, sp}
    26d4:	22000023 	andcs	r0, r0, #35	; 0x23
    26d8:	0027760b 	eoreq	r7, r7, fp, lsl #12
    26dc:	4d0b2300 	stcmi	3, cr2, [fp, #-0]
    26e0:	24000022 	strcs	r0, [r0], #-34	; 0xffffffde
    26e4:	00214f0b 	eoreq	r4, r1, fp, lsl #30
    26e8:	690b2500 	stmdbvs	fp, {r8, sl, sp}
    26ec:	2600001e 			; <UNDEFINED> instruction: 0x2600001e
    26f0:	00216d0b 	eoreq	r6, r1, fp, lsl #26
    26f4:	050b2700 	streq	r2, [fp, #-1792]	; 0xfffff900
    26f8:	2800001f 	stmdacs	r0, {r0, r1, r2, r3, r4}
    26fc:	00217d0b 	eoreq	r7, r1, fp, lsl #26
    2700:	8d0b2900 	vstrhi.16	s4, [fp, #-0]	; <UNPREDICTABLE>
    2704:	2a000021 	bcs	2790 <shift+0x2790>
    2708:	0022d00b 	eoreq	sp, r2, fp
    270c:	f60b2b00 			; <UNDEFINED> instruction: 0xf60b2b00
    2710:	2c000020 	stccs	0, cr0, [r0], {32}
    2714:	00251b0b 	eoreq	r1, r5, fp, lsl #22
    2718:	aa0b2d00 	bge	2cdb20 <__bss_end+0x2c40e8>
    271c:	2e00001e 	mcrcs	0, 0, r0, cr0, cr14, {0}
    2720:	20880a00 	addcs	r0, r8, r0, lsl #20
    2724:	01070000 	mrseq	r0, (UNDEF: 7)
    2728:	00000093 	muleq	r0, r3, r0
    272c:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    2730:	0b000003 	bleq	2744 <shift+0x2744>
    2734:	00001dbd 			; <UNDEFINED> instruction: 0x00001dbd
    2738:	1a0f0b00 	bne	3c5340 <__bss_end+0x3bb908>
    273c:	0b010000 	bleq	42744 <__bss_end+0x38d0c>
    2740:	00002993 	muleq	r0, r3, r9
    2744:	28260b02 	stmdacs	r6!, {r1, r8, r9, fp}
    2748:	0b030000 	bleq	c2750 <__bss_end+0xb8d18>
    274c:	00001ddd 	ldrdeq	r1, [r0], -sp
    2750:	1ac70b04 	bne	ff1c5368 <__bss_end+0xff1bb930>
    2754:	0b050000 	bleq	14275c <__bss_end+0x138d24>
    2758:	00001e86 	andeq	r1, r0, r6, lsl #29
    275c:	1dcd0b06 	vstrne	d16, [sp, #24]
    2760:	0b070000 	bleq	1c2768 <__bss_end+0x1b8d30>
    2764:	000026ba 			; <UNDEFINED> instruction: 0x000026ba
    2768:	280b0b08 	stmdacs	fp, {r3, r8, r9, fp}
    276c:	0b090000 	bleq	242774 <__bss_end+0x238d3c>
    2770:	000025f1 	strdeq	r2, [r0], -r1
    2774:	1b1a0b0a 	blne	6853a4 <__bss_end+0x67b96c>
    2778:	0b0b0000 	bleq	2c2780 <__bss_end+0x2b8d48>
    277c:	00001e27 	andeq	r1, r0, r7, lsr #28
    2780:	1a900b0c 	bne	fe4053b8 <__bss_end+0xfe3fb980>
    2784:	0b0d0000 	bleq	34278c <__bss_end+0x338d54>
    2788:	000029c8 	andeq	r2, r0, r8, asr #19
    278c:	22bd0b0e 	adcscs	r0, sp, #14336	; 0x3800
    2790:	0b0f0000 	bleq	3c2798 <__bss_end+0x3b8d60>
    2794:	00001f9a 	muleq	r0, sl, pc	; <UNPREDICTABLE>
    2798:	22fa0b10 	rscscs	r0, sl, #16, 22	; 0x4000
    279c:	0b110000 	bleq	4427a4 <__bss_end+0x438d6c>
    27a0:	000028e7 	andeq	r2, r0, r7, ror #17
    27a4:	1bdd0b12 	blne	ff7453f4 <__bss_end+0xff73b9bc>
    27a8:	0b130000 	bleq	4c27b0 <__bss_end+0x4b8d78>
    27ac:	00001fad 	andeq	r1, r0, sp, lsr #31
    27b0:	22100b14 	andscs	r0, r0, #20, 22	; 0x5000
    27b4:	0b150000 	bleq	5427bc <__bss_end+0x538d84>
    27b8:	00001da8 	andeq	r1, r0, r8, lsr #27
    27bc:	225c0b16 	subscs	r0, ip, #22528	; 0x5800
    27c0:	0b170000 	bleq	5c27c8 <__bss_end+0x5b8d90>
    27c4:	00002072 	andeq	r2, r0, r2, ror r0
    27c8:	1ae50b18 	bne	ff945430 <__bss_end+0xff93b9f8>
    27cc:	0b190000 	bleq	6427d4 <__bss_end+0x638d9c>
    27d0:	0000288e 	andeq	r2, r0, lr, lsl #17
    27d4:	21dc0b1a 	bicscs	r0, ip, sl, lsl fp
    27d8:	0b1b0000 	bleq	6c27e0 <__bss_end+0x6b8da8>
    27dc:	00001f84 	andeq	r1, r0, r4, lsl #31
    27e0:	19ba0b1c 	ldmibne	sl!, {r2, r3, r4, r8, r9, fp}
    27e4:	0b1d0000 	bleq	7427ec <__bss_end+0x738db4>
    27e8:	00002127 	andeq	r2, r0, r7, lsr #2
    27ec:	21130b1e 	tstcs	r3, lr, lsl fp
    27f0:	0b1f0000 	bleq	7c27f8 <__bss_end+0x7b8dc0>
    27f4:	000025ae 	andeq	r2, r0, lr, lsr #11
    27f8:	26390b20 	ldrtcs	r0, [r9], -r0, lsr #22
    27fc:	0b210000 	bleq	842804 <__bss_end+0x838dcc>
    2800:	0000286d 	andeq	r2, r0, sp, ror #16
    2804:	1eb70b22 			; <UNDEFINED> instruction: 0x1eb70b22
    2808:	0b230000 	bleq	8c2810 <__bss_end+0x8b8dd8>
    280c:	00002411 	andeq	r2, r0, r1, lsl r4
    2810:	26060b24 	strcs	r0, [r6], -r4, lsr #22
    2814:	0b250000 	bleq	94281c <__bss_end+0x938de4>
    2818:	0000252a 	andeq	r2, r0, sl, lsr #10
    281c:	253e0b26 	ldrcs	r0, [lr, #-2854]!	; 0xfffff4da
    2820:	0b270000 	bleq	9c2828 <__bss_end+0x9b8df0>
    2824:	00002552 	andeq	r2, r0, r2, asr r5
    2828:	1c680b28 			; <UNDEFINED> instruction: 0x1c680b28
    282c:	0b290000 	bleq	a42834 <__bss_end+0xa38dfc>
    2830:	00001bc8 	andeq	r1, r0, r8, asr #23
    2834:	1bf00b2a 	blne	ffc054e4 <__bss_end+0xffbfbaac>
    2838:	0b2b0000 	bleq	ac2840 <__bss_end+0xab8e08>
    283c:	00002703 	andeq	r2, r0, r3, lsl #14
    2840:	1c450b2c 	mcrrne	11, 2, r0, r5, cr12
    2844:	0b2d0000 	bleq	b4284c <__bss_end+0xb38e14>
    2848:	00002717 	andeq	r2, r0, r7, lsl r7
    284c:	272b0b2e 	strcs	r0, [fp, -lr, lsr #22]!
    2850:	0b2f0000 	bleq	bc2858 <__bss_end+0xbb8e20>
    2854:	0000273f 	andeq	r2, r0, pc, lsr r7
    2858:	1e390b30 	vmovne.s16	r0, d9[2]
    285c:	0b310000 	bleq	c42864 <__bss_end+0xc38e2c>
    2860:	00001e13 	andeq	r1, r0, r3, lsl lr
    2864:	213b0b32 	teqcs	fp, r2, lsr fp
    2868:	0b330000 	bleq	cc2870 <__bss_end+0xcb8e38>
    286c:	0000230d 	andeq	r2, r0, sp, lsl #6
    2870:	291c0b34 	ldmdbcs	ip, {r2, r4, r5, r8, r9, fp}
    2874:	0b350000 	bleq	d4287c <__bss_end+0xd38e44>
    2878:	00001962 	andeq	r1, r0, r2, ror #18
    287c:	1f390b36 	svcne	0x00390b36
    2880:	0b370000 	bleq	dc2888 <__bss_end+0xdb8e50>
    2884:	00001f4e 	andeq	r1, r0, lr, asr #30
    2888:	219d0b38 	orrscs	r0, sp, r8, lsr fp
    288c:	0b390000 	bleq	e42894 <__bss_end+0xe38e5c>
    2890:	000021c7 	andeq	r2, r0, r7, asr #3
    2894:	29450b3a 	stmdbcs	r5, {r1, r3, r4, r5, r8, r9, fp}^
    2898:	0b3b0000 	bleq	ec28a0 <__bss_end+0xeb8e68>
    289c:	000023fc 	strdeq	r2, [r0], -ip
    28a0:	1edc0b3c 	vmovne.u8	r0, d12[1]
    28a4:	0b3d0000 	bleq	f428ac <__bss_end+0xf38e74>
    28a8:	00001a21 	andeq	r1, r0, r1, lsr #20
    28ac:	19df0b3e 	ldmibne	pc, {r1, r2, r3, r4, r5, r8, r9, fp}^	; <UNPREDICTABLE>
    28b0:	0b3f0000 	bleq	fc28b8 <__bss_end+0xfb8e80>
    28b4:	00002359 	andeq	r2, r0, r9, asr r3
    28b8:	247d0b40 	ldrbtcs	r0, [sp], #-2880	; 0xfffff4c0
    28bc:	0b410000 	bleq	10428c4 <__bss_end+0x1038e8c>
    28c0:	00002590 	muleq	r0, r0, r5
    28c4:	21b20b42 			; <UNDEFINED> instruction: 0x21b20b42
    28c8:	0b430000 	bleq	10c28d0 <__bss_end+0x10b8e98>
    28cc:	0000297e 	andeq	r2, r0, lr, ror r9
    28d0:	24270b44 	strtcs	r0, [r7], #-2884	; 0xfffff4bc
    28d4:	0b450000 	bleq	11428dc <__bss_end+0x1138ea4>
    28d8:	00001c0c 	andeq	r1, r0, ip, lsl #24
    28dc:	228d0b46 	addcs	r0, sp, #71680	; 0x11800
    28e0:	0b470000 	bleq	11c28e8 <__bss_end+0x11b8eb0>
    28e4:	000020c0 	andeq	r2, r0, r0, asr #1
    28e8:	199e0b48 	ldmibne	lr, {r3, r6, r8, r9, fp}
    28ec:	0b490000 	bleq	12428f4 <__bss_end+0x1238ebc>
    28f0:	00001ab2 			; <UNDEFINED> instruction: 0x00001ab2
    28f4:	1ef00b4a 	vmovne.f64	d16, d10
    28f8:	0b4b0000 	bleq	12c2900 <__bss_end+0x12b8ec8>
    28fc:	000021ee 	andeq	r2, r0, lr, ror #3
    2900:	0203004c 	andeq	r0, r3, #76	; 0x4c
    2904:	00098d07 	andeq	r8, r9, r7, lsl #26
    2908:	03e40c00 	mvneq	r0, #0, 24
    290c:	03d90000 	bicseq	r0, r9, #0
    2910:	000d0000 	andeq	r0, sp, r0
    2914:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    2918:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    291c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    2920:	000003de 	ldrdeq	r0, [r0], -lr
    2924:	64080103 	strvs	r0, [r8], #-259	; 0xfffffefd
    2928:	0e00000d 	cdpeq	0, 0, cr0, cr0, cr13, {0}
    292c:	000003e9 	andeq	r0, r0, r9, ror #7
    2930:	001b560f 	andseq	r5, fp, pc, lsl #12
    2934:	014c0400 	cmpeq	ip, r0, lsl #8
    2938:	0003d91a 	andeq	sp, r3, sl, lsl r9
    293c:	1f740f00 	svcne	0x00740f00
    2940:	82040000 	andhi	r0, r4, #0
    2944:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    2948:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    294c:	1a000003 	bne	2960 <shift+0x2960>
    2950:	0d000004 	stceq	0, cr0, [r0, #-16]
    2954:	215f0900 	cmpcs	pc, r0, lsl #18
    2958:	2d050000 	stccs	0, cr0, [r5, #-0]
    295c:	00040f0d 	andeq	r0, r4, sp, lsl #30
    2960:	27e70900 	strbcs	r0, [r7, r0, lsl #18]!
    2964:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    2968:	0001e61c 	andeq	lr, r1, ip, lsl r6
    296c:	1e4d0a00 	vmlane.f32	s1, s26, s0
    2970:	01070000 	mrseq	r0, (UNDEF: 7)
    2974:	00000093 	muleq	r0, r3, r0
    2978:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    297c:	0b000004 	bleq	2994 <shift+0x2994>
    2980:	000019b3 			; <UNDEFINED> instruction: 0x000019b3
    2984:	205f0b00 	subscs	r0, pc, r0, lsl #22
    2988:	0b010000 	bleq	42990 <__bss_end+0x38f58>
    298c:	000028f9 	strdeq	r2, [r0], -r9
    2990:	28bc0b02 	ldmcs	ip!, {r1, r8, r9, fp}
    2994:	0b030000 	bleq	c299c <__bss_end+0xb8f64>
    2998:	000023b6 			; <UNDEFINED> instruction: 0x000023b6
    299c:	26770b04 	ldrbtcs	r0, [r7], -r4, lsl #22
    29a0:	0b050000 	bleq	1429a8 <__bss_end+0x138f70>
    29a4:	00001b99 	muleq	r0, r9, fp
    29a8:	1b7b0b06 	blne	1ec55c8 <__bss_end+0x1ebbb90>
    29ac:	0b070000 	bleq	1c29b4 <__bss_end+0x1b8f7c>
    29b0:	00001d94 	muleq	r0, r4, sp
    29b4:	22720b08 	rsbscs	r0, r2, #8, 22	; 0x2000
    29b8:	0b090000 	bleq	2429c0 <__bss_end+0x238f88>
    29bc:	00001ba0 	andeq	r1, r0, r0, lsr #23
    29c0:	22790b0a 	rsbscs	r0, r9, #10240	; 0x2800
    29c4:	0b0b0000 	bleq	2c29cc <__bss_end+0x2b8f94>
    29c8:	00001c05 	andeq	r1, r0, r5, lsl #24
    29cc:	1b920b0c 	blne	fe485604 <__bss_end+0xfe47bbcc>
    29d0:	0b0d0000 	bleq	3429d8 <__bss_end+0x338fa0>
    29d4:	000026ce 	andeq	r2, r0, lr, asr #13
    29d8:	249b0b0e 	ldrcs	r0, [fp], #2830	; 0xb0e
    29dc:	000f0000 	andeq	r0, pc, r0
    29e0:	0025c604 	eoreq	ip, r5, r4, lsl #12
    29e4:	013f0500 	teqeq	pc, r0, lsl #10
    29e8:	00000432 	andeq	r0, r0, r2, lsr r4
    29ec:	00265a09 	eoreq	r5, r6, r9, lsl #20
    29f0:	0f410500 	svceq	0x00410500
    29f4:	000004a5 	andeq	r0, r0, r5, lsr #9
    29f8:	0026e209 	eoreq	lr, r6, r9, lsl #4
    29fc:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    2a00:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a04:	001b3a09 	andseq	r3, fp, r9, lsl #20
    2a08:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    2a0c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a10:	0027bb10 	eoreq	fp, r7, r0, lsl fp
    2a14:	26f30900 	ldrbtcs	r0, [r3], r0, lsl #18
    2a18:	4c050000 	stcmi	0, cr0, [r5], {-0}
    2a1c:	0004e614 	andeq	lr, r4, r4, lsl r6
    2a20:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    2a24:	11000004 	tstne	r0, r4
    2a28:	00202909 	eoreq	r2, r0, r9, lsl #18
    2a2c:	0f4e0500 	svceq	0x004e0500
    2a30:	000004f9 	strdeq	r0, [r0], -r9
    2a34:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    2a38:	dc120000 	ldcle	0, cr0, [r2], {-0}
    2a3c:	09000025 	stmdbeq	r0, {r0, r2, r5}
    2a40:	000023a3 	andeq	r2, r0, r3, lsr #7
    2a44:	100d5205 	andne	r5, sp, r5, lsl #4
    2a48:	05000005 	streq	r0, [r0, #-5]
    2a4c:	0004ff04 	andeq	pc, r4, r4, lsl #30
    2a50:	1cb11300 	ldcne	3, cr1, [r1]
    2a54:	05340000 	ldreq	r0, [r4, #-0]!
    2a58:	41150167 	tstmi	r5, r7, ror #2
    2a5c:	14000005 	strne	r0, [r0], #-5
    2a60:	00002168 	andeq	r2, r0, r8, ror #2
    2a64:	0f016905 	svceq	0x00016905
    2a68:	000003de 	ldrdeq	r0, [r0], -lr
    2a6c:	1c951400 	cfldrsne	mvf1, [r5], {0}
    2a70:	6a050000 	bvs	142a78 <__bss_end+0x139040>
    2a74:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    2a78:	00040000 	andeq	r0, r4, r0
    2a7c:	0005160e 	andeq	r1, r5, lr, lsl #12
    2a80:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    2a84:	05560000 	ldrbeq	r0, [r6, #-0]
    2a88:	24150000 	ldrcs	r0, [r5], #-0
    2a8c:	2d000000 	stccs	0, cr0, [r0, #-0]
    2a90:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    2a94:	05610000 	strbeq	r0, [r1, #-0]!
    2a98:	000d0000 	andeq	r0, sp, r0
    2a9c:	0005560e 	andeq	r5, r5, lr, lsl #12
    2aa0:	20970f00 	addscs	r0, r7, r0, lsl #30
    2aa4:	6b050000 	blvs	142aac <__bss_end+0x139074>
    2aa8:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    2aac:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 2ab4 <shift+0x2ab4>
    2ab0:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2ab4:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    2ab8:	16000000 	strne	r0, [r0], -r0
    2abc:	0000261a 	andeq	r2, r0, sl, lsl r6
    2ac0:	00930107 	addseq	r0, r3, r7, lsl #2
    2ac4:	81050000 	mrshi	r0, (UNDEF: 5)
    2ac8:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    2acc:	480b0000 	stmdami	fp, {}	; <UNPREDICTABLE>
    2ad0:	0000001a 	andeq	r0, r0, sl, lsl r0
    2ad4:	001a540b 	andseq	r5, sl, fp, lsl #8
    2ad8:	600b0200 	andvs	r0, fp, r0, lsl #4
    2adc:	0300001a 	movweq	r0, #26
    2ae0:	001e790b 	andseq	r7, lr, fp, lsl #18
    2ae4:	6c0b0300 	stcvs	3, cr0, [fp], {-0}
    2ae8:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
    2aec:	001fc20b 	andseq	ip, pc, fp, lsl #4
    2af0:	a80b0400 	stmdage	fp, {sl}
    2af4:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2af8:	001ffe0b 	andseq	pc, pc, fp, lsl #28
    2afc:	2b0b0500 	blcs	2c3f04 <__bss_end+0x2ba4cc>
    2b00:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2b04:	001a780b 	andseq	r7, sl, fp, lsl #16
    2b08:	260b0600 	strcs	r0, [fp], -r0, lsl #12
    2b0c:	06000022 	streq	r0, [r0], -r2, lsr #32
    2b10:	001c870b 	andseq	r8, ip, fp, lsl #14
    2b14:	330b0600 	movwcc	r0, #46592	; 0xb600
    2b18:	06000022 	streq	r0, [r0], -r2, lsr #32
    2b1c:	00269a0b 	eoreq	r9, r6, fp, lsl #20
    2b20:	400b0600 	andmi	r0, fp, r0, lsl #12
    2b24:	06000022 	streq	r0, [r0], -r2, lsr #32
    2b28:	0022800b 	eoreq	r8, r2, fp
    2b2c:	840b0600 	strhi	r0, [fp], #-1536	; 0xfffffa00
    2b30:	0700001a 	smladeq	r0, sl, r0, r0
    2b34:	0023860b 	eoreq	r8, r3, fp, lsl #12
    2b38:	d30b0700 	movwle	r0, #46848	; 0xb700
    2b3c:	07000023 	streq	r0, [r0, -r3, lsr #32]
    2b40:	0026d50b 	eoreq	sp, r6, fp, lsl #10
    2b44:	5a0b0700 	bpl	2c474c <__bss_end+0x2bad14>
    2b48:	0700001c 	smladeq	r0, ip, r0, r0
    2b4c:	0024540b 	eoreq	r5, r4, fp, lsl #8
    2b50:	fd0b0800 	stc2	8, cr0, [fp, #-0]
    2b54:	08000019 	stmdaeq	r0, {r0, r3, r4}
    2b58:	0026a80b 	eoreq	sl, r6, fp, lsl #16
    2b5c:	700b0800 	andvc	r0, fp, r0, lsl #16
    2b60:	08000024 	stmdaeq	r0, {r2, r5}
    2b64:	290e0f00 	stmdbcs	lr, {r8, r9, sl, fp}
    2b68:	9f050000 	svcls	0x00050000
    2b6c:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    2b70:	a20f0000 	andge	r0, pc, #0
    2b74:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2b78:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    2b7c:	0f000000 	svceq	0x00000000
    2b80:	000020b5 	strheq	r2, [r0], -r5
    2b84:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    2b88:	0000001d 	andeq	r0, r0, sp, lsl r0
    2b8c:	0029da0f 	eoreq	sp, r9, pc, lsl #20
    2b90:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    2b94:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2b98:	1b4a0f00 	blne	12867a0 <__bss_end+0x127cd68>
    2b9c:	ab050000 	blge	142ba4 <__bss_end+0x13916c>
    2ba0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2ba4:	ac0f0000 	stcge	0, cr0, [pc], {-0}
    2ba8:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2bac:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    2bb0:	0f000000 	svceq	0x00000000
    2bb4:	000023bd 			; <UNDEFINED> instruction: 0x000023bd
    2bb8:	0c01b105 	stfeqd	f3, [r1], {5}
    2bbc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2bc0:	0023c80f 	eoreq	ip, r3, pc, lsl #16
    2bc4:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    2bc8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2bcc:	24b60f00 	ldrtcs	r0, [r6], #3840	; 0xf00
    2bd0:	b7050000 	strlt	r0, [r5, -r0]
    2bd4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2bd8:	020f0000 	andeq	r0, pc, #0
    2bdc:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2be0:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    2be4:	0f000000 	svceq	0x00000000
    2be8:	00002939 	andeq	r2, r0, r9, lsr r9
    2bec:	0c01bd05 	stceq	13, cr11, [r1], {5}
    2bf0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2bf4:	0024c00f 	eoreq	ip, r4, pc
    2bf8:	01c00500 	biceq	r0, r0, r0, lsl #10
    2bfc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c00:	29fd0f00 	ldmibcs	sp!, {r8, r9, sl, fp}^
    2c04:	c3050000 	movwgt	r0, #20480	; 0x5000
    2c08:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c0c:	c30f0000 	movwgt	r0, #61440	; 0xf000
    2c10:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2c14:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    2c18:	0f000000 	svceq	0x00000000
    2c1c:	000028cf 	andeq	r2, r0, pc, asr #17
    2c20:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    2c24:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c28:	0028db0f 	eoreq	sp, r8, pc, lsl #22
    2c2c:	01cc0500 	biceq	r0, ip, r0, lsl #10
    2c30:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c34:	29000f00 	stmdbcs	r0, {r8, r9, sl, fp}
    2c38:	d0050000 	andle	r0, r5, r0
    2c3c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c40:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    2c44:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2c48:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    2c4c:	0f000000 	svceq	0x00000000
    2c50:	00001ba7 	andeq	r1, r0, r7, lsr #23
    2c54:	0c01d605 	stceq	6, cr13, [r1], {5}
    2c58:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c5c:	00198e0f 	andseq	r8, r9, pc, lsl #28
    2c60:	01d90500 	bicseq	r0, r9, r0, lsl #10
    2c64:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c68:	1e990f00 	cdpne	15, 9, cr0, cr9, cr0, {0}
    2c6c:	dc050000 	stcle	0, cr0, [r5], {-0}
    2c70:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c74:	820f0000 	andhi	r0, pc, #0
    2c78:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2c7c:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    2c80:	0f000000 	svceq	0x00000000
    2c84:	000024d6 	ldrdeq	r2, [r0], -r6
    2c88:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    2c8c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c90:	0020de0f 	eoreq	sp, r0, pc, lsl #28
    2c94:	01e50500 	mvneq	r0, r0, lsl #10
    2c98:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c9c:	23360f00 	teqcs	r6, #0, 30
    2ca0:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    2ca4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2ca8:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    2cac:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2cb0:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    2cb4:	0f000000 	svceq	0x00000000
    2cb8:	000029a8 	andeq	r2, r0, r8, lsr #19
    2cbc:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    2cc0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cc4:	0029b80f 	eoreq	fp, r9, pc, lsl #16
    2cc8:	01f50500 	mvnseq	r0, r0, lsl #10
    2ccc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cd0:	1c9e0f00 	ldcne	15, cr0, [lr], {0}
    2cd4:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    2cd8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cdc:	370f0000 	strcc	r0, [pc, -r0]
    2ce0:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2ce4:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    2ce8:	0f000000 	svceq	0x00000000
    2cec:	0000243c 	andeq	r2, r0, ip, lsr r4
    2cf0:	0c01fe05 	stceq	14, cr15, [r1], {5}
    2cf4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cf8:	001f120f 	andseq	r1, pc, pc, lsl #4
    2cfc:	02020500 	andeq	r0, r2, #0, 10
    2d00:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d04:	262c0f00 	strtcs	r0, [ip], -r0, lsl #30
    2d08:	0a050000 	beq	142d10 <__bss_end+0x1392d8>
    2d0c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2d10:	050f0000 	streq	r0, [pc, #-0]	; 2d18 <shift+0x2d18>
    2d14:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2d18:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    2d1c:	0c000000 	stceq	0, cr0, [r0], {-0}
    2d20:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d24:	000007ef 	andeq	r0, r0, pc, ror #15
    2d28:	de0f000d 	cdple	0, 0, cr0, cr15, cr13, {0}
    2d2c:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2d30:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    2d34:	0c000007 	stceq	0, cr0, [r0], {7}
    2d38:	000004e6 	andeq	r0, r0, r6, ror #9
    2d3c:	0000080c 	andeq	r0, r0, ip, lsl #16
    2d40:	00002415 	andeq	r2, r0, r5, lsl r4
    2d44:	0f000d00 	svceq	0x00000d00
    2d48:	000024f9 	strdeq	r2, [r0], -r9
    2d4c:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    2d50:	000007fc 	strdeq	r0, [r0], -ip
    2d54:	0020a016 	eoreq	sl, r0, r6, lsl r0
    2d58:	93010700 	movwls	r0, #5888	; 0x1700
    2d5c:	05000000 	streq	r0, [r0, #-0]
    2d60:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    2d64:	0b000008 	bleq	2d8c <shift+0x2d8c>
    2d68:	00001e5b 	andeq	r1, r0, fp, asr lr
    2d6c:	22ab0b00 	adccs	r0, fp, #0, 22
    2d70:	0b010000 	bleq	42d78 <__bss_end+0x39340>
    2d74:	00001a33 	andeq	r1, r0, r3, lsr sl
    2d78:	296a0b02 	stmdbcs	sl!, {r1, r8, r9, fp}^
    2d7c:	0b030000 	bleq	c2d84 <__bss_end+0xb934c>
    2d80:	00002573 	andeq	r2, r0, r3, ror r5
    2d84:	25660b04 	strbcs	r0, [r6, #-2820]!	; 0xfffff4fc
    2d88:	0b050000 	bleq	142d90 <__bss_end+0x139358>
    2d8c:	00001b0a 	andeq	r1, r0, sl, lsl #22
    2d90:	5a0f0006 	bpl	3c2db0 <__bss_end+0x3b9378>
    2d94:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2d98:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    2d9c:	0f000008 	svceq	0x00000008
    2da0:	0000285c 	andeq	r2, r0, ip, asr r8
    2da4:	11079905 	tstne	r7, r5, lsl #18
    2da8:	00000024 	andeq	r0, r0, r4, lsr #32
    2dac:	0024e60f 	eoreq	lr, r4, pc, lsl #12
    2db0:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    2db4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2db8:	27cf0400 	strbcs	r0, [pc, r0, lsl #8]
    2dbc:	7b060000 	blvc	182dc4 <__bss_end+0x17938c>
    2dc0:	00009316 	andeq	r9, r0, r6, lsl r3
    2dc4:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    2dc8:	02030000 	andeq	r0, r3, #0
    2dcc:	000dd805 	andeq	sp, sp, r5, lsl #16
    2dd0:	07080300 	streq	r0, [r8, -r0, lsl #6]
    2dd4:	00001dee 	andeq	r1, r0, lr, ror #27
    2dd8:	c2040403 	andgt	r0, r4, #50331648	; 0x3000000
    2ddc:	0300001b 	movweq	r0, #27
    2de0:	1bba0308 	blne	fee83a08 <__bss_end+0xfee79fd0>
    2de4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2de8:	0024cf04 	eoreq	ip, r4, r4, lsl #30
    2dec:	03100300 	tsteq	r0, #0, 6
    2df0:	00002581 	andeq	r2, r0, r1, lsl #11
    2df4:	00088a0c 	andeq	r8, r8, ip, lsl #20
    2df8:	0008c900 	andeq	ip, r8, r0, lsl #18
    2dfc:	00241500 	eoreq	r1, r4, r0, lsl #10
    2e00:	00ff0000 	rscseq	r0, pc, r0
    2e04:	0008b90e 	andeq	fp, r8, lr, lsl #18
    2e08:	23e00f00 	mvncs	r0, #0, 30
    2e0c:	fc060000 	stc2	0, cr0, [r6], {-0}
    2e10:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    2e14:	710f0000 	mrsvc	r0, CPSR
    2e18:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2e1c:	c9160202 	ldmdbgt	r6, {r1, r9}
    2e20:	04000008 	streq	r0, [r0], #-8
    2e24:	00002802 	andeq	r2, r0, r2, lsl #16
    2e28:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    2e2c:	0c000004 	stceq	0, cr0, [r0], {4}
    2e30:	000008e8 	andeq	r0, r0, r8, ror #17
    2e34:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2e38:	5709000d 	strpl	r0, [r9, -sp]
    2e3c:	07000003 	streq	r0, [r0, -r3]
    2e40:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    2e44:	0c090000 	stceq	0, cr0, [r9], {-0}
    2e48:	07000002 	streq	r0, [r0, -r2]
    2e4c:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    2e50:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    2e54:	08000008 	stmdaeq	r0, {r3}
    2e58:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    2e5c:	009a2503 	addseq	r2, sl, r3, lsl #10
    2e60:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    2e64:	34080000 	strcc	r0, [r8], #-0
    2e68:	03050a09 	movweq	r0, #23049	; 0x5a09
    2e6c:	00009a25 	andeq	r9, r0, r5, lsr #20
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3771dc>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb92e4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9304>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb931c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x344>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79e5c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39340>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7270>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b66bc>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9f20>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4ed8>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b66e8>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b675c>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3772d8>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb93d8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79f14>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe393f8>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9410>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79f48>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4f84>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3773c8>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7390>
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
 1f4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb94b0>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	0b002405 	bleq	9234 <_Z23decimal_to_string_floatjPci+0xa8>
 21c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 220:	06000008 	streq	r0, [r0], -r8
 224:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 228:	0b3b0b3a 	bleq	ec2f18 <__bss_end+0xeb94e0>
 22c:	13490b39 	movtne	r0, #39737	; 0x9b39
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2ba018>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb94f8>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f741c>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7cde4>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb9520>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b9490>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe7a074>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe39558>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb594>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c50b4>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe7a0ac>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe39590>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x377518>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe7a0dc>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe395c0>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a290>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x37754c>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b694c>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe7a12c>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe39610>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb9628>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x3775b8>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a178>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe3965c>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb698>
 3a8:	00000b32 	andeq	r0, r0, r2, lsr fp
 3ac:	4901151f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r8, sl, ip}
 3b0:	01136413 	tsteq	r3, r3, lsl r4
 3b4:	20000013 	andcs	r0, r0, r3, lsl r0
 3b8:	131d001f 	tstne	sp, #31
 3bc:	00001349 	andeq	r1, r0, r9, asr #6
 3c0:	0b001021 	bleq	444c <shift+0x444c>
 3c4:	0013490b 	andseq	r4, r3, fp, lsl #18
 3c8:	000f2200 	andeq	r2, pc, r0, lsl #4
 3cc:	00000b0b 	andeq	r0, r0, fp, lsl #22
 3d0:	03013923 	movweq	r3, #6435	; 0x1923
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c51c4>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb969c>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c5200>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377648>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7a208>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe396ec>
 434:	01111349 	tsteq	r1, r9, asr #6
 438:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 43c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 440:	29000013 	stmdbcs	r0, {r0, r1, r4}
 444:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 448:	0b3b0b3a 	bleq	ec3138 <__bss_end+0xeb9700>
 44c:	13490b39 	movtne	r0, #39737	; 0x9b39
 450:	00001802 	andeq	r1, r0, r2, lsl #16
 454:	0300342a 	movweq	r3, #1066	; 0x42a
 458:	3b0b3a0e 	blcc	2cec98 <__bss_end+0x2c5260>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	11010000 	mrsne	r0, (UNDEF: 1)
 468:	130e2501 	movwne	r2, #58625	; 0xe501
 46c:	1b0e030b 	blne	3810a0 <__bss_end+0x377668>
 470:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 474:	00171006 	andseq	r1, r7, r6
 478:	00240200 	eoreq	r0, r4, r0, lsl #4
 47c:	0b3e0b0b 	bleq	f830b0 <__bss_end+0xf79678>
 480:	00000e03 	andeq	r0, r0, r3, lsl #28
 484:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 488:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 48c:	0b0b0024 	bleq	2c0524 <__bss_end+0x2b6aec>
 490:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 494:	16050000 	strne	r0, [r5], -r0
 498:	3a0e0300 	bcc	3810a0 <__bss_end+0x377668>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4a4:	01130600 	tsteq	r3, r0, lsl #12
 4a8:	0b0b0e03 	bleq	2c3cbc <__bss_end+0x2ba284>
 4ac:	0b3b0b3a 	bleq	ec319c <__bss_end+0xeb9764>
 4b0:	13010b39 	movwne	r0, #6969	; 0x1b39
 4b4:	0d070000 	stceq	0, cr0, [r7, #-0]
 4b8:	3a080300 	bcc	2010c0 <__bss_end+0x1f7688>
 4bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4c4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 4c8:	0e030104 	adfeqs	f0, f3, f4
 4cc:	0b3e196d 	bleq	f86a88 <__bss_end+0xf7d050>
 4d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeb978c>
 4d8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4dc:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 4e0:	1c080300 	stcne	3, cr0, [r8], {-0}
 4e4:	0a00000b 	beq	518 <shift+0x518>
 4e8:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 4ec:	00000b1c 	andeq	r0, r0, ip, lsl fp
 4f0:	0300340b 	movweq	r3, #1035	; 0x40b
 4f4:	3b0b3a0e 	blcc	2ced34 <__bss_end+0x2c52fc>
 4f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4fc:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 500:	0c000018 	stceq	0, cr0, [r0], {24}
 504:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 508:	0000193c 	andeq	r1, r0, ip, lsr r9
 50c:	0301020d 	movweq	r0, #4621	; 0x120d
 510:	3a0b0b0e 	bcc	2c3150 <__bss_end+0x2b9718>
 514:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 518:	0013010b 	andseq	r0, r3, fp, lsl #2
 51c:	000d0e00 	andeq	r0, sp, r0, lsl #28
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe7a2fc>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe397e0>
 528:	0b381349 	bleq	e05254 <__bss_end+0xdfb81c>
 52c:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 530:	03193f01 	tsteq	r9, #1, 30
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c533c>
 538:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 53c:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 540:	00136419 	andseq	r6, r3, r9, lsl r4
 544:	00051000 	andeq	r1, r5, r0
 548:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 54c:	05110000 	ldreq	r0, [r1, #-0]
 550:	00134900 	andseq	r4, r3, r0, lsl #18
 554:	000d1200 	andeq	r1, sp, r0, lsl #4
 558:	0b3a0e03 	bleq	e83d6c <__bss_end+0xe7a334>
 55c:	0b390b3b 	bleq	e43250 <__bss_end+0xe39818>
 560:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 564:	0000193c 	andeq	r1, r0, ip, lsr r9
 568:	3f012e13 	svccc	0x00012e13
 56c:	3a0e0319 	bcc	3811d8 <__bss_end+0x3777a0>
 570:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 574:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 578:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 57c:	01136419 	tsteq	r3, r9, lsl r4
 580:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 584:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 588:	0b3a0e03 	bleq	e83d9c <__bss_end+0xe7a364>
 58c:	0b390b3b 	bleq	e43280 <__bss_end+0xe39848>
 590:	0b320e6e 	bleq	c83f50 <__bss_end+0xc7a518>
 594:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 598:	00001301 	andeq	r1, r0, r1, lsl #6
 59c:	3f012e15 	svccc	0x00012e15
 5a0:	3a0e0319 	bcc	38120c <__bss_end+0x3777d4>
 5a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5ac:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 5b0:	00136419 	andseq	r6, r3, r9, lsl r4
 5b4:	01011600 	tsteq	r1, r0, lsl #12
 5b8:	13011349 	movwne	r1, #4937	; 0x1349
 5bc:	21170000 	tstcs	r7, r0
 5c0:	2f134900 	svccs	0x00134900
 5c4:	1800000b 	stmdane	r0, {r0, r1, r3}
 5c8:	0b0b000f 	bleq	2c060c <__bss_end+0x2b6bd4>
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	00002119 	andeq	r2, r0, r9, lsl r1
 5d4:	00341a00 	eorseq	r1, r4, r0, lsl #20
 5d8:	0b3a0e03 	bleq	e83dec <__bss_end+0xe7a3b4>
 5dc:	0b390b3b 	bleq	e432d0 <__bss_end+0xe39898>
 5e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 5e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 5e8:	3f012e1b 	svccc	0x00012e1b
 5ec:	3a0e0319 	bcc	381258 <__bss_end+0x377820>
 5f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5f4:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 5f8:	01136419 	tsteq	r3, r9, lsl r4
 5fc:	1c000013 	stcne	0, cr0, [r0], {19}
 600:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 604:	0b3a0e03 	bleq	e83e18 <__bss_end+0xe7a3e0>
 608:	0b390b3b 	bleq	e432fc <__bss_end+0xe398c4>
 60c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 610:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 614:	00001301 	andeq	r1, r0, r1, lsl #6
 618:	03000d1d 	movweq	r0, #3357	; 0xd1d
 61c:	3b0b3a0e 	blcc	2cee5c <__bss_end+0x2c5424>
 620:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 624:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 628:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 62c:	13490115 	movtne	r0, #37141	; 0x9115
 630:	13011364 	movwne	r1, #4964	; 0x1364
 634:	1f1f0000 	svcne	0x001f0000
 638:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 63c:	20000013 	andcs	r0, r0, r3, lsl r0
 640:	0b0b0010 	bleq	2c0688 <__bss_end+0x2b6c50>
 644:	00001349 	andeq	r1, r0, r9, asr #6
 648:	0b000f21 	bleq	42d4 <shift+0x42d4>
 64c:	2200000b 	andcs	r0, r0, #11
 650:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 654:	0b3b0b3a 	bleq	ec3344 <__bss_end+0xeb990c>
 658:	13490b39 	movtne	r0, #39737	; 0x9b39
 65c:	00001802 	andeq	r1, r0, r2, lsl #16
 660:	3f012e23 	svccc	0x00012e23
 664:	3a0e0319 	bcc	3812d0 <__bss_end+0x377898>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 670:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 674:	96184006 	ldrls	r4, [r8], -r6
 678:	13011942 	movwne	r1, #6466	; 0x1942
 67c:	05240000 	streq	r0, [r4, #-0]!
 680:	3a0e0300 	bcc	381288 <__bss_end+0x377850>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 68c:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 690:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7a470>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe39954>
 69c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 6a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6a8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ac:	00342600 	eorseq	r2, r4, r0, lsl #12
 6b0:	0b3a0803 	bleq	e826c4 <__bss_end+0xe78c8c>
 6b4:	0b390b3b 	bleq	e433a8 <__bss_end+0xe39970>
 6b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6bc:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 6c0:	03193f01 	tsteq	r9, #1, 30
 6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c54cc>
 6c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
 6dc:	03193f00 	tsteq	r9, #0, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c54e8>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6ec:	97184006 	ldrls	r4, [r8, -r6]
 6f0:	00001942 	andeq	r1, r0, r2, asr #18
 6f4:	3f012e29 	svccc	0x00012e29
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x37792c>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 704:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 708:	97184006 	ldrls	r4, [r8, -r6]
 70c:	00001942 	andeq	r1, r0, r2, asr #18
 710:	01110100 	tsteq	r1, r0, lsl #2
 714:	0b130e25 	bleq	4c3fb0 <__bss_end+0x4ba578>
 718:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 71c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 720:	00001710 	andeq	r1, r0, r0, lsl r7
 724:	03003402 	movweq	r3, #1026	; 0x402
 728:	3b0b3a0e 	blcc	2cef68 <__bss_end+0x2c5530>
 72c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 730:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 734:	03000018 	movweq	r0, #24
 738:	0b0b0024 	bleq	2c07d0 <__bss_end+0x2b6d98>
 73c:	0e030b3e 	vmoveq.16	d3[0], r0
 740:	26040000 	strcs	r0, [r4], -r0
 744:	00134900 	andseq	r4, r3, r0, lsl #18
 748:	01390500 	teqeq	r9, r0, lsl #10
 74c:	00001301 	andeq	r1, r0, r1, lsl #6
 750:	03003406 	movweq	r3, #1030	; 0x406
 754:	3b0b3a0e 	blcc	2cef94 <__bss_end+0x2c555c>
 758:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 75c:	1c193c13 	ldcne	12, cr3, [r9], {19}
 760:	0700000a 	streq	r0, [r0, -sl]
 764:	0b3a003a 	bleq	e80854 <__bss_end+0xe76e1c>
 768:	0b390b3b 	bleq	e4345c <__bss_end+0xe39a24>
 76c:	00001318 	andeq	r1, r0, r8, lsl r3
 770:	49010108 	stmdbmi	r1, {r3, r8}
 774:	00130113 	andseq	r0, r3, r3, lsl r1
 778:	00210900 	eoreq	r0, r1, r0, lsl #18
 77c:	0b2f1349 	bleq	bc54a8 <__bss_end+0xbbba70>
 780:	340a0000 	strcc	r0, [sl], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeb9a48>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	01111349 	tsteq	r1, r9, asr #6
 79c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7a0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 7a4:	0c000013 	stceq	0, cr0, [r0], {19}
 7a8:	08030005 	stmdaeq	r3, {r0, r2}
 7ac:	0b3b0b3a 	bleq	ec349c <__bss_end+0xeb9a64>
 7b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b4:	00001802 	andeq	r1, r0, r2, lsl #16
 7b8:	0300340d 	movweq	r3, #1037	; 0x40d
 7bc:	3b0b3a08 	blcc	2cefe4 <__bss_end+0x2c55ac>
 7c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7c4:	00180213 	andseq	r0, r8, r3, lsl r2
 7c8:	00340e00 	eorseq	r0, r4, r0, lsl #28
 7cc:	0b3a0e03 	bleq	e83fe0 <__bss_end+0xe7a5a8>
 7d0:	0b390b3b 	bleq	e434c4 <__bss_end+0xe39a8c>
 7d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7d8:	0b0f0000 	bleq	3c07e0 <__bss_end+0x3b6da8>
 7dc:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7e0:	10000006 	andne	r0, r0, r6
 7e4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7e8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 7ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 7f0:	00001802 	andeq	r1, r0, r2, lsl #16
 7f4:	03003411 	movweq	r3, #1041	; 0x411
 7f8:	3b0b3a08 	blcc	2cf020 <__bss_end+0x2c55e8>
 7fc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 800:	00180213 	andseq	r0, r8, r3, lsl r2
 804:	000f1200 	andeq	r1, pc, r0, lsl #4
 808:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 80c:	24130000 	ldrcs	r0, [r3], #-0
 810:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 814:	0008030b 	andeq	r0, r8, fp, lsl #6
 818:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 81c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 820:	0b3b0b3a 	bleq	ec3510 <__bss_end+0xeb9ad8>
 824:	0e6e0b39 	vmoveq.8	d14[5], r0
 828:	06120111 			; <UNDEFINED> instruction: 0x06120111
 82c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 830:	00130119 	andseq	r0, r3, r9, lsl r1
 834:	00051500 	andeq	r1, r5, r0, lsl #10
 838:	0b3a0e03 	bleq	e8404c <__bss_end+0xe7a614>
 83c:	0b390b3b 	bleq	e43530 <__bss_end+0xe39af8>
 840:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 844:	0b160000 	bleq	58084c <__bss_end+0x576e14>
 848:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 84c:	00130106 	andseq	r0, r3, r6, lsl #2
 850:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 854:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 858:	0b3b0b3a 	bleq	ec3548 <__bss_end+0xeb9b10>
 85c:	0e6e0b39 	vmoveq.8	d14[5], r0
 860:	06120111 			; <UNDEFINED> instruction: 0x06120111
 864:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 868:	00130119 	andseq	r0, r3, r9, lsl r1
 86c:	00101800 	andseq	r1, r0, r0, lsl #16
 870:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 874:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 878:	03193f01 	tsteq	r9, #1, 30
 87c:	3b0b3a08 	blcc	2cf0a4 <__bss_end+0x2c566c>
 880:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 884:	1113490e 	tstne	r3, lr, lsl #18
 888:	40061201 	andmi	r1, r6, r1, lsl #4
 88c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 890:	00001301 	andeq	r1, r0, r1, lsl #6
 894:	0000261a 	andeq	r2, r0, sl, lsl r6
 898:	000f1b00 	andeq	r1, pc, r0, lsl #22
 89c:	00000b0b 	andeq	r0, r0, fp, lsl #22
 8a0:	3f012e1c 	svccc	0x00012e1c
 8a4:	3a0e0319 	bcc	381510 <__bss_end+0x377ad8>
 8a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8ac:	110e6e0b 	tstne	lr, fp, lsl #28
 8b0:	40061201 	andmi	r1, r6, r1, lsl #4
 8b4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 8b8:	01000000 	mrseq	r0, (UNDEF: 0)
 8bc:	06100011 			; <UNDEFINED> instruction: 0x06100011
 8c0:	01120111 	tsteq	r2, r1, lsl r1
 8c4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 8c8:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 8cc:	01000000 	mrseq	r0, (UNDEF: 0)
 8d0:	06100011 			; <UNDEFINED> instruction: 0x06100011
 8d4:	01120111 	tsteq	r2, r1, lsl r1
 8d8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 8dc:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 8e0:	01000000 	mrseq	r0, (UNDEF: 0)
 8e4:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 8e8:	0e030b13 	vmoveq.32	d3[0], r0
 8ec:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 8f0:	24020000 	strcs	r0, [r2], #-0
 8f4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 8f8:	0008030b 	andeq	r0, r8, fp, lsl #6
 8fc:	00240300 	eoreq	r0, r4, r0, lsl #6
 900:	0b3e0b0b 	bleq	f83534 <__bss_end+0xf79afc>
 904:	00000e03 	andeq	r0, r0, r3, lsl #28
 908:	03001604 	movweq	r1, #1540	; 0x604
 90c:	3b0b3a0e 	blcc	2cf14c <__bss_end+0x2c5714>
 910:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 914:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 918:	0b0b000f 	bleq	2c095c <__bss_end+0x2b6f24>
 91c:	00001349 	andeq	r1, r0, r9, asr #6
 920:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 924:	01134919 	tsteq	r3, r9, lsl r9
 928:	07000013 	smladeq	r0, r3, r0, r0
 92c:	13490005 	movtne	r0, #36869	; 0x9005
 930:	26080000 	strcs	r0, [r8], -r0
 934:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 938:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 93c:	0b3b0b3a 	bleq	ec362c <__bss_end+0xeb9bf4>
 940:	13490b39 	movtne	r0, #39737	; 0x9b39
 944:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 948:	040a0000 	streq	r0, [sl], #-0
 94c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 950:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 954:	3b0b3a13 	blcc	2cf1a8 <__bss_end+0x2c5770>
 958:	010b390b 	tsteq	fp, fp, lsl #18
 95c:	0b000013 	bleq	9b0 <shift+0x9b0>
 960:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 964:	00000b1c 	andeq	r0, r0, ip, lsl fp
 968:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 96c:	00130113 	andseq	r0, r3, r3, lsl r1
 970:	00210d00 	eoreq	r0, r1, r0, lsl #26
 974:	260e0000 	strcs	r0, [lr], -r0
 978:	00134900 	andseq	r4, r3, r0, lsl #18
 97c:	00340f00 	eorseq	r0, r4, r0, lsl #30
 980:	0b3a0e03 	bleq	e84194 <__bss_end+0xe7a75c>
 984:	0b39053b 	bleq	e41e78 <__bss_end+0xe38440>
 988:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 98c:	0000193c 	andeq	r1, r0, ip, lsr r9
 990:	03001310 	movweq	r1, #784	; 0x310
 994:	00193c0e 	andseq	r3, r9, lr, lsl #24
 998:	00151100 	andseq	r1, r5, r0, lsl #2
 99c:	00001927 	andeq	r1, r0, r7, lsr #18
 9a0:	03001712 	movweq	r1, #1810	; 0x712
 9a4:	00193c0e 	andseq	r3, r9, lr, lsl #24
 9a8:	01131300 	tsteq	r3, r0, lsl #6
 9ac:	0b0b0e03 	bleq	2c41c0 <__bss_end+0x2ba788>
 9b0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9b4:	13010b39 	movwne	r0, #6969	; 0x1b39
 9b8:	0d140000 	ldceq	0, cr0, [r4, #-0]
 9bc:	3a0e0300 	bcc	3815c4 <__bss_end+0x377b8c>
 9c0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 9c8:	1500000b 	strne	r0, [r0, #-11]
 9cc:	13490021 	movtne	r0, #36897	; 0x9021
 9d0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 9d4:	03010416 	movweq	r0, #5142	; 0x1416
 9d8:	0b0b3e0e 	bleq	2d0218 <__bss_end+0x2c67e0>
 9dc:	3a13490b 	bcc	4d2e10 <__bss_end+0x4c93d8>
 9e0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9e4:	0013010b 	andseq	r0, r3, fp, lsl #2
 9e8:	00341700 	eorseq	r1, r4, r0, lsl #14
 9ec:	0b3a1347 	bleq	e85710 <__bss_end+0xe7bcd8>
 9f0:	0b39053b 	bleq	e41ee4 <__bss_end+0xe384ac>
 9f4:	00001802 	andeq	r1, r0, r2, lsl #16
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
  74:	000000dc 	ldrdeq	r0, [r0], -ip
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	10f90002 	rscsne	r0, r9, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008308 	andeq	r8, r0, r8, lsl #6
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1df20002 	ldclne	0, cr0, [r2, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008764 	andeq	r8, r0, r4, ror #14
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	24ef0002 	strbtcs	r0, [pc], #2	; cc <shift+0xcc>
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009740 	andeq	r9, r0, r0, asr #14
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	25150002 	ldrcs	r0, [r5, #-2]
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000994c 	andeq	r9, r0, ip, asr #18
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	253b0002 	ldrcs	r0, [fp, #-2]!
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6514>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff62b9>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff62bb>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4fd0>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff6409>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be940>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfeec>
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
     398:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
     39c:	5f6b6369 	svcpl	0x006b6369
     3a0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     3a4:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
     3a8:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     3ac:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     3b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3b4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     3b8:	5f4f4950 	svcpl	0x004f4950
     3bc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     3c0:	3172656c 	cmncc	r2, ip, ror #10
     3c4:	616e4539 	cmnvs	lr, r9, lsr r5
     3c8:	5f656c62 	svcpl	0x00656c62
     3cc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     3d0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     3d4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     3d8:	30326a45 	eorscc	r6, r2, r5, asr #20
     3dc:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     3e0:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     3e4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     3e8:	5f747075 	svcpl	0x00747075
     3ec:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     3f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3f4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     3f8:	5f4f4950 	svcpl	0x004f4950
     3fc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     400:	3172656c 	cmncc	r2, ip, ror #10
     404:	73655231 	cmnvc	r5, #268435459	; 0x10000003
     408:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     40c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     410:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     414:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     418:	4f00305f 	svcmi	0x0000305f
     41c:	006e6570 	rsbeq	r6, lr, r0, ror r5
     420:	5f746c41 	svcpl	0x00746c41
     424:	6c410033 	mcrrvs	0, 3, r0, r1, cr3
     428:	00345f74 	eorseq	r5, r4, r4, ror pc
     42c:	76657270 			; <UNDEFINED> instruction: 0x76657270
     430:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     434:	50433631 	subpl	r3, r3, r1, lsr r6
     438:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     43c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 278 <shift+0x278>
     440:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     444:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     448:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     44c:	505f7966 	subspl	r7, pc, r6, ror #18
     450:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     454:	50457373 	subpl	r7, r5, r3, ror r3
     458:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     45c:	5f6b7361 	svcpl	0x006b7361
     460:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     464:	5f007463 	svcpl	0x00007463
     468:	31314e5a 	teqcc	r1, sl, asr lr
     46c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     470:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     474:	316d6574 	smccc	54868	; 0xd654
     478:	53465433 	movtpl	r5, #25651	; 0x6433
     47c:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
     480:	6f4e5f65 	svcvs	0x004e5f65
     484:	30316564 	eorscc	r6, r1, r4, ror #10
     488:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
     48c:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
     490:	5045646c 	subpl	r6, r5, ip, ror #8
     494:	5500634b 	strpl	r6, [r0, #-843]	; 0xfffffcb5
     498:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     49c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     4a0:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     4a4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     4a8:	5a5f0074 	bpl	17c0680 <__bss_end+0x17b6c48>
     4ac:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4b0:	4f495047 	svcmi	0x00495047
     4b4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4b8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4bc:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4c0:	706e495f 	rsbvc	r4, lr, pc, asr r9
     4c4:	6a457475 	bvs	115d6a0 <__bss_end+0x1153c68>
     4c8:	43534200 	cmpmi	r3, #0, 4
     4cc:	61425f32 	cmpvs	r2, r2, lsr pc
     4d0:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
     4d4:	636f7250 	cmnvs	pc, #80, 4
     4d8:	5f737365 	svcpl	0x00737365
     4dc:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     4e0:	6165485f 	cmnvs	r5, pc, asr r8
     4e4:	65530064 	ldrbvs	r0, [r3, #-100]	; 0xffffff9c
     4e8:	50475f74 	subpl	r5, r7, r4, ror pc
     4ec:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     4f0:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     4f4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     4f8:	4b4e5a5f 	blmi	1396e7c <__bss_end+0x138d444>
     4fc:	50433631 	subpl	r3, r3, r1, lsr r6
     500:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     504:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 340 <shift+0x340>
     508:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     50c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     510:	5f746547 	svcpl	0x00746547
     514:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     518:	5f746e65 	svcpl	0x00746e65
     51c:	636f7250 	cmnvs	pc, #80, 4
     520:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     524:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     528:	50475f74 	subpl	r5, r7, r4, ror pc
     52c:	5f534445 	svcpl	0x00534445
     530:	61636f4c 	cmnvs	r3, ip, asr #30
     534:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     538:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     53c:	6c6f0074 	stclvs	0, cr0, [pc], #-464	; 374 <shift+0x374>
     540:	61747364 	cmnvs	r4, r4, ror #6
     544:	47006574 	smlsdxmi	r0, r4, r5, r6
     548:	505f7465 	subspl	r7, pc, r5, ror #8
     54c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     550:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     554:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     558:	6f6d0044 	svcvs	0x006d0044
     55c:	50746e75 	rsbspl	r6, r4, r5, ror lr
     560:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     564:	44736900 	ldrbtmi	r6, [r3], #-2304	; 0xfffff700
     568:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
     56c:	79726f74 	ldmdbvc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     570:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     574:	72505f49 	subsvc	r5, r0, #292	; 0x124
     578:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     57c:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     580:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     584:	63410065 	movtvs	r0, #4197	; 0x1065
     588:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     58c:	6f72505f 	svcvs	0x0072505f
     590:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     594:	756f435f 	strbvc	r4, [pc, #-863]!	; 23d <shift+0x23d>
     598:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     59c:	5f6e6950 	svcpl	0x006e6950
     5a0:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     5a4:	74617672 	strbtvc	r7, [r1], #-1650	; 0xfffff98e
     5a8:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     5ac:	6165525f 	cmnvs	r5, pc, asr r2
     5b0:	57540064 	ldrbpl	r0, [r4, -r4, rrx]
     5b4:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     5b8:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     5bc:	00656c69 	rsbeq	r6, r5, r9, ror #24
     5c0:	61657243 	cmnvs	r5, r3, asr #4
     5c4:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     5c8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5cc:	6d007373 	stcvs	3, cr7, [r0, #-460]	; 0xfffffe34
     5d0:	4f495047 	svcmi	0x00495047
     5d4:	72617000 	rsbvc	r7, r1, #0
     5d8:	00746e65 	rsbseq	r6, r4, r5, ror #28
     5dc:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     5e0:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     5e4:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     5e8:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     5ec:	55410068 	strbpl	r0, [r1, #-104]	; 0xffffff98
     5f0:	61425f58 	cmpvs	r2, r8, asr pc
     5f4:	47006573 	smlsdxmi	r0, r3, r5, r6
     5f8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     5fc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     600:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     604:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     608:	7073006f 	rsbsvc	r0, r3, pc, rrx
     60c:	6f6c6e69 	svcvs	0x006c6e69
     610:	745f6b63 	ldrbvc	r6, [pc], #-2915	; 618 <shift+0x618>
     614:	61654400 	cmnvs	r5, r0, lsl #8
     618:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     61c:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     620:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     624:	00646567 	rsbeq	r6, r4, r7, ror #10
     628:	6f725043 	svcvs	0x00725043
     62c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     630:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     634:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     638:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     63c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     640:	73656c69 	cmnvc	r5, #26880	; 0x6900
     644:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     648:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     64c:	46540076 			; <UNDEFINED> instruction: 0x46540076
     650:	72445f53 	subvc	r5, r4, #332	; 0x14c
     654:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     658:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     65c:	50433631 	subpl	r3, r3, r1, lsr r6
     660:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     664:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4a0 <shift+0x4a0>
     668:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     66c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     670:	5f746547 	svcpl	0x00746547
     674:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     678:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     67c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     680:	32456f66 	subcc	r6, r5, #408	; 0x198
     684:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     688:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     68c:	5f646568 	svcpl	0x00646568
     690:	6f666e49 	svcvs	0x00666e49
     694:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     698:	00765065 	rsbseq	r5, r6, r5, rrx
     69c:	314e5a5f 	cmpcc	lr, pc, asr sl
     6a0:	50474333 	subpl	r4, r7, r3, lsr r3
     6a4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     6a8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6ac:	30327265 	eorscc	r7, r2, r5, ror #4
     6b0:	61656c43 	cmnvs	r5, r3, asr #24
     6b4:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     6b8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     6bc:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 25f <shift+0x25f>
     6c0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     6c4:	5f006a45 	svcpl	0x00006a45
     6c8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6cc:	6f725043 	svcvs	0x00725043
     6d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6d4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6dc:	61483132 	cmpvs	r8, r2, lsr r1
     6e0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6e4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6e8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     6ec:	5f6d6574 	svcpl	0x006d6574
     6f0:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     6f4:	534e3332 	movtpl	r3, #58162	; 0xe332
     6f8:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     6fc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     700:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     704:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     708:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     70c:	6a6a6a65 	bvs	1a9b0a8 <__bss_end+0x1a91670>
     710:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     714:	5f495753 	svcpl	0x00495753
     718:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     71c:	4600746c 	strmi	r7, [r0], -ip, ror #8
     720:	696c6c61 	stmdbvs	ip!, {r0, r5, r6, sl, fp, sp, lr}^
     724:	455f676e 	ldrbmi	r6, [pc, #-1902]	; ffffffbe <__bss_end+0xffff6586>
     728:	00656764 	rsbeq	r6, r5, r4, ror #14
     72c:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     730:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     734:	73656c69 	cmnvc	r5, #26880	; 0x6900
     738:	746f4e00 	strbtvc	r4, [pc], #-3584	; 740 <shift+0x740>
     73c:	41796669 	cmnmi	r9, r9, ror #12
     740:	5f006c6c 	svcpl	0x00006c6c
     744:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     748:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     74c:	61485f4f 	cmpvs	r8, pc, asr #30
     750:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     754:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
     758:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     75c:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 1f8 <shift+0x1f8>
     760:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     764:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     768:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     76c:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     770:	4f495047 	svcmi	0x00495047
     774:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     778:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     77c:	545f7470 	ldrbpl	r7, [pc], #-1136	; 784 <shift+0x784>
     780:	00657079 	rsbeq	r7, r5, r9, ror r0
     784:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     788:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     78c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     790:	61654400 	cmnvs	r5, r0, lsl #8
     794:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     798:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     79c:	00307262 	eorseq	r7, r0, r2, ror #4
     7a0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7a4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7a8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7ac:	614d5f73 	hvcvs	54771	; 0xd5f3
     7b0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7b4:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     7b8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     7bc:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     7c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7c4:	006a4573 	rsbeq	r4, sl, r3, ror r5
     7c8:	5f746547 	svcpl	0x00746547
     7cc:	00444950 	subeq	r4, r4, r0, asr r9
     7d0:	30435342 	subcc	r5, r3, r2, asr #6
     7d4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     7d8:	69460065 	stmdbvs	r6, {r0, r2, r5, r6}^
     7dc:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     7e0:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     7e4:	746f6e00 	strbtvc	r6, [pc], #-3584	; 7ec <shift+0x7ec>
     7e8:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     7ec:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     7f0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     7f4:	4900656e 	stmdbmi	r0, {r1, r2, r3, r5, r6, r8, sl, sp, lr}
     7f8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     7fc:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     800:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     804:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 63c <shift+0x63c>
     808:	5f72656c 	svcpl	0x0072656c
     80c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     810:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     814:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     818:	5f4f4950 	svcpl	0x004f4950
     81c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     820:	3872656c 	ldmdacc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     824:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     828:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     82c:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     830:	43534200 	cmpmi	r3, #0, 4
     834:	61425f31 	cmpvs	r2, r1, lsr pc
     838:	4d006573 	cfstr32mi	mvfx6, [r0, #-460]	; 0xfffffe34
     83c:	505f7861 	subspl	r7, pc, r1, ror #16
     840:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     844:	4f5f7373 	svcmi	0x005f7373
     848:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     84c:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     850:	0073656c 	rsbseq	r6, r3, ip, ror #10
     854:	314e5a5f 	cmpcc	lr, pc, asr sl
     858:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     85c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     860:	614d5f73 	hvcvs	54771	; 0xd5f3
     864:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     868:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
     86c:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     870:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     874:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     878:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     87c:	006a4574 	rsbeq	r4, sl, r4, ror r5
     880:	474e5254 	smlsldmi	r5, lr, r4, r2
     884:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     888:	69480065 	stmdbvs	r8, {r0, r2, r5, r6}^
     88c:	67006867 	strvs	r6, [r0, -r7, ror #16]
     890:	445f5346 	ldrbmi	r5, [pc], #-838	; 898 <shift+0x898>
     894:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     898:	435f7372 	cmpmi	pc, #-939524095	; 0xc8000001
     89c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     8a0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8a4:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     8a8:	4f495047 	svcmi	0x00495047
     8ac:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     8b0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     8b4:	65473632 	strbvs	r3, [r7, #-1586]	; 0xfffff9ce
     8b8:	50475f74 	subpl	r5, r7, r4, ror pc
     8bc:	5152495f 	cmppl	r2, pc, asr r9
     8c0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     8c4:	5f746365 	svcpl	0x00746365
     8c8:	61636f4c 	cmnvs	r3, ip, asr #30
     8cc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     8d0:	30326a45 	eorscc	r6, r2, r5, asr #20
     8d4:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     8d8:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     8dc:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     8e0:	5f747075 	svcpl	0x00747075
     8e4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     8e8:	31536a52 	cmpcc	r3, r2, asr sl
     8ec:	6952005f 	ldmdbvs	r2, {r0, r1, r2, r3, r4, r6}^
     8f0:	676e6973 			; <UNDEFINED> instruction: 0x676e6973
     8f4:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     8f8:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     8fc:	5f746f6f 	svcpl	0x00746f6f
     900:	00737953 	rsbseq	r7, r3, r3, asr r9
     904:	5f746547 	svcpl	0x00746547
     908:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     90c:	5f746e65 	svcpl	0x00746e65
     910:	636f7250 	cmnvs	pc, #80, 4
     914:	00737365 	rsbseq	r7, r3, r5, ror #6
     918:	5f70614d 	svcpl	0x0070614d
     91c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     920:	5f6f545f 	svcpl	0x006f545f
     924:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     928:	00746e65 	rsbseq	r6, r4, r5, ror #28
     92c:	4b4e5a5f 	blmi	13972b0 <__bss_end+0x138d878>
     930:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     934:	5f4f4950 	svcpl	0x004f4950
     938:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     93c:	3172656c 	cmncc	r2, ip, ror #10
     940:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     944:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     948:	5f4c4553 	svcpl	0x004c4553
     94c:	61636f4c 	cmnvs	r3, ip, asr #30
     950:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     954:	6a526a45 	bvs	149b270 <__bss_end+0x1491838>
     958:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     95c:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     960:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     964:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     968:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     96c:	53007265 	movwpl	r7, #613	; 0x265
     970:	505f7465 	subspl	r7, pc, r5, ror #8
     974:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     978:	61480073 	hvcvs	32771	; 0x8003
     97c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     980:	6f72505f 	svcvs	0x0072505f
     984:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     988:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     98c:	6f687300 	svcvs	0x00687300
     990:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     994:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     998:	2064656e 	rsbcs	r6, r4, lr, ror #10
     99c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     9a0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     9a4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     9a8:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     9ac:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     9b0:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     9b4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     9b8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     9bc:	5f746e65 	svcpl	0x00746e65
     9c0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     9c4:	6f697463 	svcvs	0x00697463
     9c8:	5a5f006e 	bpl	17c0b88 <__bss_end+0x17b7150>
     9cc:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     9d0:	4f495047 	svcmi	0x00495047
     9d4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     9d8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     9dc:	61483031 	cmpvs	r8, r1, lsr r0
     9e0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9e4:	5152495f 	cmppl	r2, pc, asr r9
     9e8:	5f007645 	svcpl	0x00007645
     9ec:	31314e5a 	teqcc	r1, sl, asr lr
     9f0:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     9f4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9f8:	316d6574 	smccc	54868	; 0xd654
     9fc:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     a00:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     a04:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     a08:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     a0c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a10:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     a14:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 5b7 <shift+0x5b7>
     a18:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a1c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     a20:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     a24:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     a28:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     a2c:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     a30:	7065656c 	rsbvc	r6, r5, ip, ror #10
     a34:	6f526d00 	svcvs	0x00526d00
     a38:	445f746f 	ldrbmi	r7, [pc], #-1135	; a40 <shift+0xa40>
     a3c:	62007665 	andvs	r7, r0, #105906176	; 0x6500000
     a40:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     a44:	5f746c41 	svcpl	0x00746c41
     a48:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     a4c:	00325f74 	eorseq	r5, r2, r4, ror pc
     a50:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     a54:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a58:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     a5c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     a60:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     a64:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     a68:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a6c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     a70:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     a74:	41006570 	tstmi	r0, r0, ror r5
     a78:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 614 <shift+0x614>
     a7c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a80:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     a84:	5f4f4950 	svcpl	0x004f4950
     a88:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a8c:	3172656c 	cmncc	r2, ip, ror #10
     a90:	74655330 	strbtvc	r5, [r5], #-816	; 0xfffffcd0
     a94:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     a98:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     a9c:	5200626a 	andpl	r6, r0, #-1610612730	; 0xa0000006
     aa0:	616e6e75 	smcvs	59109	; 0xe6e5
     aa4:	00656c62 	rsbeq	r6, r5, r2, ror #24
     aa8:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     aac:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     ab0:	00657461 	rsbeq	r7, r5, r1, ror #8
     ab4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     ab8:	6f635f64 	svcvs	0x00635f64
     abc:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     ac0:	63730072 	cmnvs	r3, #114	; 0x72
     ac4:	5f646568 	svcpl	0x00646568
     ac8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     acc:	705f6369 	subsvc	r6, pc, r9, ror #6
     ad0:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     ad4:	00797469 	rsbseq	r7, r9, r9, ror #8
     ad8:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     adc:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     ae0:	6700657a 	smlsdxvs	r0, sl, r5, r6
     ae4:	445f5346 	ldrbmi	r5, [pc], #-838	; aec <shift+0xaec>
     ae8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     aec:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     af0:	5f746978 	svcpl	0x00746978
     af4:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     af8:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     afc:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     b00:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     b04:	616e4500 	cmnvs	lr, r0, lsl #10
     b08:	5f656c62 	svcpl	0x00656c62
     b0c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     b10:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     b14:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     b18:	50477300 	subpl	r7, r7, r0, lsl #6
     b1c:	6d004f49 	stcvs	15, cr4, [r0, #-292]	; 0xfffffedc
     b20:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b24:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b28:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     b2c:	72507300 	subsvc	r7, r0, #0, 6
     b30:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b34:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
     b38:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     b3c:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     b40:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b44:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     b48:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     b4c:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     b50:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     b54:	65440079 	strbvs	r0, [r4, #-121]	; 0xffffff87
     b58:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     b5c:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     b60:	5f6b636f 	svcpl	0x006b636f
     b64:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     b68:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     b6c:	6f465f74 	svcvs	0x00465f74
     b70:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     b74:	00746e65 	rsbseq	r6, r4, r5, ror #28
     b78:	4b4e5a5f 	blmi	13974fc <__bss_end+0x138dac4>
     b7c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     b80:	5f4f4950 	svcpl	0x004f4950
     b84:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     b88:	3172656c 	cmncc	r2, ip, ror #10
     b8c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     b90:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     b94:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     b98:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     b9c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     ba0:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     ba4:	4c005f30 	stcmi	15, cr5, [r0], {48}	; 0x30
     ba8:	5f6b636f 	svcpl	0x006b636f
     bac:	6f6c6e55 	svcvs	0x006c6e55
     bb0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     bb4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     bb8:	61425f4f 	cmpvs	r2, pc, asr #30
     bbc:	47006573 	smlsdxmi	r0, r3, r5, r6
     bc0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bc4:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     bc8:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     bcc:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     bd0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     bd4:	6f697461 	svcvs	0x00697461
     bd8:	4e49006e 	cdpmi	0, 4, cr0, cr9, cr14, {3}
     bdc:	494e4946 	stmdbmi	lr, {r1, r2, r6, r8, fp, lr}^
     be0:	47005954 	smlsdmi	r0, r4, r9, r5
     be4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     be8:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     bec:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     bf0:	6f697461 	svcvs	0x00697461
     bf4:	6f4c006e 	svcvs	0x004c006e
     bf8:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     bfc:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     c00:	506d0064 	rsbpl	r0, sp, r4, rrx
     c04:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     c08:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     c0c:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     c10:	5f736e6f 	svcpl	0x00736e6f
     c14:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c18:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c1c:	50475f74 	subpl	r5, r7, r4, ror pc
     c20:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     c24:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c28:	6f697461 	svcvs	0x00697461
     c2c:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     c30:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffcc4 <__bss_end+0xffff628c>
     c34:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     c38:	61655200 	cmnvs	r5, r0, lsl #4
     c3c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     c40:	00657469 	rsbeq	r7, r5, r9, ror #8
     c44:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     c48:	5f006569 	svcpl	0x00006569
     c4c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     c50:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     c54:	61485f4f 	cmpvs	r8, pc, asr #30
     c58:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c5c:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     c60:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     c64:	5f4f4950 	svcpl	0x004f4950
     c68:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     c6c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c70:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     c74:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     c78:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     c7c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     c80:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     c84:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     c88:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c8c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     c90:	682f006f 	stmdavs	pc!, {r0, r1, r2, r3, r5, r6}	; <UNPREDICTABLE>
     c94:	2f656d6f 	svccs	0x00656d6f
     c98:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     c9c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     ca0:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     ca4:	2f736f2f 	svccs	0x00736f2f
     ca8:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     cac:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     cb0:	752f7365 	strvc	r7, [pc, #-869]!	; 953 <shift+0x953>
     cb4:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     cb8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     cbc:	6c69742f 	cfstrdvs	mvd7, [r9], #-188	; 0xffffff44
     cc0:	61745f74 	cmnvs	r4, r4, ror pc
     cc4:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     cc8:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     ccc:	00707063 	rsbseq	r7, r0, r3, rrx
     cd0:	314e5a5f 	cmpcc	lr, pc, asr sl
     cd4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     cd8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     cdc:	614d5f73 	hvcvs	54771	; 0xd5f3
     ce0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     ce4:	63533872 	cmpvs	r3, #7471104	; 0x720000
     ce8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     cec:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     cf0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cf4:	50433631 	subpl	r3, r3, r1, lsr r6
     cf8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cfc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b38 <shift+0xb38>
     d00:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d04:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     d08:	5f70614d 	svcpl	0x0070614d
     d0c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d10:	5f6f545f 	svcpl	0x006f545f
     d14:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     d18:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     d1c:	46493550 			; <UNDEFINED> instruction: 0x46493550
     d20:	00656c69 	rsbeq	r6, r5, r9, ror #24
     d24:	61736944 	cmnvs	r3, r4, asr #18
     d28:	5f656c62 	svcpl	0x00656c62
     d2c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     d30:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d34:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d38:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     d3c:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     d40:	00736d61 	rsbseq	r6, r3, r1, ror #26
     d44:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
     d48:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
     d4c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     d50:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     d54:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     d58:	75006874 	strvc	r6, [r0, #-2164]	; 0xfffff78c
     d5c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     d60:	2064656e 	rsbcs	r6, r4, lr, ror #10
     d64:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     d68:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d6c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     d70:	4f495047 	svcmi	0x00495047
     d74:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     d78:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     d7c:	65473232 	strbvs	r3, [r7, #-562]	; 0xfffffdce
     d80:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d84:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d88:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 92b <shift+0x92b>
     d8c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d90:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     d94:	5f007645 	svcpl	0x00007645
     d98:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d9c:	6f725043 	svcvs	0x00725043
     da0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     da4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     da8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     dac:	63533231 	cmpvs	r3, #268435459	; 0x10000003
     db0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     db4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 850 <shift+0x850>
     db8:	76454644 	strbvc	r4, [r5], -r4, asr #12
     dbc:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     dc0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     dc4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     dc8:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     dcc:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     dd0:	6f435f6e 	svcvs	0x00435f6e
     dd4:	00746e75 	rsbseq	r6, r4, r5, ror lr
     dd8:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     ddc:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     de0:	6e450074 	mcrvs	0, 2, r0, cr5, cr4, {3}
     de4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     de8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     dec:	445f746e 	ldrbmi	r7, [pc], #-1134	; df4 <shift+0xdf4>
     df0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     df4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     df8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dfc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     e00:	5f4f4950 	svcpl	0x004f4950
     e04:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     e08:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     e0c:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     e10:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     e14:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     e18:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     e1c:	00657361 	rsbeq	r7, r5, r1, ror #6
     e20:	6f6f526d 	svcvs	0x006f526d
     e24:	46730074 			; <UNDEFINED> instruction: 0x46730074
     e28:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e2c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e30:	4c6d006d 	stclmi	0, cr0, [sp], #-436	; 0xfffffe4c
     e34:	006b636f 	rsbeq	r6, fp, pc, ror #6
     e38:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     e3c:	00676e69 	rsbeq	r6, r7, r9, ror #28
     e40:	314e5a5f 	cmpcc	lr, pc, asr sl
     e44:	50474333 	subpl	r4, r7, r3, lsr r3
     e48:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e4c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e50:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     e54:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     e58:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     e5c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e60:	5045746e 	subpl	r7, r5, lr, ror #8
     e64:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     e68:	006a656c 	rsbeq	r6, sl, ip, ror #10
     e6c:	746c6974 	strbtvc	r6, [ip], #-2420	; 0xfffff68c
     e70:	736e6573 	cmnvc	lr, #482344960	; 0x1cc00000
     e74:	665f726f 	ldrbvs	r7, [pc], -pc, ror #4
     e78:	00656c69 	rsbeq	r6, r5, r9, ror #24
     e7c:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     e80:	745f3233 	ldrbvc	r3, [pc], #-563	; e88 <shift+0xe88>
     e84:	73655200 	cmnvc	r5, #0, 4
     e88:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     e8c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     e90:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e94:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     e98:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     e9c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     ea0:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     ea4:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ea8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     eac:	436d0065 	cmnmi	sp, #101	; 0x65
     eb0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     eb4:	545f746e 	ldrbpl	r7, [pc], #-1134	; ebc <shift+0xebc>
     eb8:	5f6b7361 	svcpl	0x006b7361
     ebc:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     ec0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ec4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ec8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     ecc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ed0:	704f346d 	subvc	r3, pc, sp, ror #8
     ed4:	50456e65 	subpl	r6, r5, r5, ror #28
     ed8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     edc:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ee0:	704f5f65 	subvc	r5, pc, r5, ror #30
     ee4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; d58 <shift+0xd58>
     ee8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     eec:	5f746547 	svcpl	0x00746547
     ef0:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     ef4:	6f4c5f54 	svcvs	0x004c5f54
     ef8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     efc:	5f006e6f 	svcpl	0x00006e6f
     f00:	314b4e5a 	cmpcc	fp, sl, asr lr
     f04:	50474333 	subpl	r4, r7, r3, lsr r3
     f08:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f0c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f10:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f14:	5f746547 	svcpl	0x00746547
     f18:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     f1c:	6f4c5f56 	svcvs	0x004c5f56
     f20:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     f24:	6a456e6f 	bvs	115c8e8 <__bss_end+0x1152eb0>
     f28:	30536a52 	subscc	r6, r3, r2, asr sl
     f2c:	576d005f 			; <UNDEFINED> instruction: 0x576d005f
     f30:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     f34:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     f38:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f3c:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     f40:	5f726576 	svcpl	0x00726576
     f44:	00786469 	rsbseq	r6, r8, r9, ror #8
     f48:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f4c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     f50:	6c430079 	mcrrvs	0, 7, r0, r3, cr9
     f54:	5f726165 	svcpl	0x00726165
     f58:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     f5c:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     f60:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     f64:	7300746e 	movwvc	r7, #1134	; 0x46e
     f68:	7065656c 	rsbvc	r6, r5, ip, ror #10
     f6c:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     f70:	5f007265 	svcpl	0x00007265
     f74:	314b4e5a 	cmpcc	fp, sl, asr lr
     f78:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     f7c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f80:	614d5f73 	hvcvs	54771	; 0xd5f3
     f84:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f88:	47383172 			; <UNDEFINED> instruction: 0x47383172
     f8c:	505f7465 	subspl	r7, pc, r5, ror #8
     f90:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f94:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     f98:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f9c:	006a4544 	rsbeq	r4, sl, r4, asr #10
     fa0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     fa4:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     fa8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     fac:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     fb0:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     fb4:	5a5f0049 	bpl	17c10e0 <__bss_end+0x17b76a8>
     fb8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fbc:	636f7250 	cmnvs	pc, #80, 4
     fc0:	5f737365 	svcpl	0x00737365
     fc4:	616e614d 	cmnvs	lr, sp, asr #2
     fc8:	31726567 	cmncc	r2, r7, ror #10
     fcc:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     fd0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     fd4:	52525f65 	subspl	r5, r2, #404	; 0x194
     fd8:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
     fdc:	006b7361 	rsbeq	r7, fp, r1, ror #6
     fe0:	79747269 	ldmdbvc	r4!, {r0, r3, r5, r6, r9, ip, sp, lr}^
     fe4:	47006570 	smlsdxmi	r0, r0, r5, r6
     fe8:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     fec:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     ff0:	746f4e00 	strbtvc	r4, [pc], #-3584	; ff8 <shift+0xff8>
     ff4:	5f796669 	svcpl	0x00796669
     ff8:	636f7250 	cmnvs	pc, #80, 4
     ffc:	00737365 	rsbseq	r7, r3, r5, ror #6
    1000:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1004:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    1008:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    100c:	50433631 	subpl	r3, r3, r1, lsr r6
    1010:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1014:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e50 <shift+0xe50>
    1018:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    101c:	31327265 	teqcc	r2, r5, ror #4
    1020:	636f6c42 	cmnvs	pc, #16896	; 0x4200
    1024:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
    1028:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    102c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
    1030:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1034:	00764573 	rsbseq	r4, r6, r3, ror r5
    1038:	314e5a5f 	cmpcc	lr, pc, asr sl
    103c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1040:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1044:	614d5f73 	hvcvs	54771	; 0xd5f3
    1048:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    104c:	77533972 			; <UNDEFINED> instruction: 0x77533972
    1050:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1054:	456f545f 	strbmi	r5, [pc, #-1119]!	; bfd <shift+0xbfd>
    1058:	43383150 	teqmi	r8, #80, 2
    105c:	636f7250 	cmnvs	pc, #80, 4
    1060:	5f737365 	svcpl	0x00737365
    1064:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
    1068:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1070 <shift+0x1070>
    106c:	5a5f0065 	bpl	17c1208 <__bss_end+0x17b77d0>
    1070:	33314b4e 	teqcc	r1, #79872	; 0x13800
    1074:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1078:	61485f4f 	cmpvs	r8, pc, asr #30
    107c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1080:	47383172 			; <UNDEFINED> instruction: 0x47383172
    1084:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1088:	53444550 	movtpl	r4, #17744	; 0x4550
    108c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1090:	6f697461 	svcvs	0x00697461
    1094:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
    1098:	5f30536a 	svcpl	0x0030536a
    109c:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    10a0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    10a4:	52525f65 	subspl	r5, r2, #404	; 0x194
    10a8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    10ac:	4c50475f 	mrrcmi	7, 5, r4, r0, cr15
    10b0:	4c5f5645 	mrrcmi	6, 4, r5, pc, cr5	; <UNPREDICTABLE>
    10b4:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    10b8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    10bc:	314e5a5f 	cmpcc	lr, pc, asr sl
    10c0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    10c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10c8:	614d5f73 	hvcvs	54771	; 0xd5f3
    10cc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    10d0:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
    10d4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    10d8:	72505f65 	subsvc	r5, r0, #404	; 0x194
    10dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10e0:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
    10e4:	30324549 	eorscc	r4, r2, r9, asr #10
    10e8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    10ec:	6f72505f 	svcvs	0x0072505f
    10f0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10f4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    10f8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    10fc:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    1100:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1104:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1108:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    110c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1110:	4e007667 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx7
    1114:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1118:	704f5f6c 	subvc	r5, pc, ip, ror #30
    111c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1120:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1124:	314e5a5f 	cmpcc	lr, pc, asr sl
    1128:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    112c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1130:	614d5f73 	hvcvs	54771	; 0xd5f3
    1134:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1138:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
    113c:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    1140:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1144:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1148:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
    114c:	5300626a 	movwpl	r6, #618	; 0x26a
    1150:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1154:	6f545f68 	svcvs	0x00545f68
    1158:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    115c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    1160:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1164:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1168:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    116c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1170:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1174:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1178:	4f495047 	svcmi	0x00495047
    117c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1180:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1184:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1188:	50475f74 	subpl	r5, r7, r4, ror pc
    118c:	5f544553 	svcpl	0x00544553
    1190:	61636f4c 	cmnvs	r3, ip, asr #30
    1194:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1198:	6a526a45 	bvs	149bab4 <__bss_end+0x149207c>
    119c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    11a0:	61766e49 	cmnvs	r6, r9, asr #28
    11a4:	5f64696c 	svcpl	0x0064696c
    11a8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11ac:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    11b0:	545f5346 	ldrbpl	r5, [pc], #-838	; 11b8 <shift+0x11b8>
    11b4:	5f656572 	svcpl	0x00656572
    11b8:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    11bc:	6f6c4200 	svcvs	0x006c4200
    11c0:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    11c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    11c8:	505f746e 	subspl	r7, pc, lr, ror #8
    11cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11d0:	70007373 	andvc	r7, r0, r3, ror r3
    11d4:	695f6e69 	ldmdbvs	pc, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    11d8:	46007864 	strmi	r7, [r0], -r4, ror #16
    11dc:	5f656572 	svcpl	0x00656572
    11e0:	006e6950 	rsbeq	r6, lr, r0, asr r9
    11e4:	4b4e5a5f 	blmi	1397b68 <__bss_end+0x138e130>
    11e8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    11ec:	5f4f4950 	svcpl	0x004f4950
    11f0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11f4:	3172656c 	cmncc	r2, ip, ror #10
    11f8:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
    11fc:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
    1200:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
    1204:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1208:	6a456e6f 	bvs	115cbcc <__bss_end+0x1153194>
    120c:	6f6c4300 	svcvs	0x006c4300
    1210:	64006573 	strvs	r6, [r0], #-1395	; 0xfffffa8d
    1214:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1218:	72610072 	rsbvc	r0, r1, #114	; 0x72
    121c:	49006367 	stmdbmi	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
    1220:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1224:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1228:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 1230 <shift+0x1230>
    122c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1230:	47430072 	smlsldxmi	r0, r3, r2, r0
    1234:	5f4f4950 	svcpl	0x004f4950
    1238:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    123c:	0072656c 	rsbseq	r6, r2, ip, ror #10
    1240:	70736e55 	rsbsvc	r6, r3, r5, asr lr
    1244:	66696365 	strbtvs	r6, [r9], -r5, ror #6
    1248:	00646569 	rsbeq	r6, r4, r9, ror #10
    124c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    1250:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
    1254:	6d00796c 	vstrvs.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
    1258:	006e6961 	rsbeq	r6, lr, r1, ror #18
    125c:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
    1260:	5a5f0064 	bpl	17c13f8 <__bss_end+0x17b79c0>
    1264:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1268:	636f7250 	cmnvs	pc, #80, 4
    126c:	5f737365 	svcpl	0x00737365
    1270:	616e614d 	cmnvs	lr, sp, asr #2
    1274:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1278:	00764534 	rsbseq	r4, r6, r4, lsr r5
    127c:	6f6f526d 	svcvs	0x006f526d
    1280:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
    1284:	70630074 	rsbvc	r0, r3, r4, ror r0
    1288:	6f635f75 	svcvs	0x00635f75
    128c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1290:	65540074 	ldrbvs	r0, [r4, #-116]	; 0xffffff8c
    1294:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1298:	00657461 	rsbeq	r7, r5, r1, ror #8
    129c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    12a0:	6148006c 	cmpvs	r8, ip, rrx
    12a4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    12a8:	5152495f 	cmppl	r2, pc, asr r9
    12ac:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
    12b0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    12b4:	6f6c6300 	svcvs	0x006c6300
    12b8:	53006573 	movwpl	r6, #1395	; 0x573
    12bc:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    12c0:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
    12c4:	00657669 	rsbeq	r7, r5, r9, ror #12
    12c8:	76746572 			; <UNDEFINED> instruction: 0x76746572
    12cc:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    12d0:	00727563 	rsbseq	r7, r2, r3, ror #10
    12d4:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    12d8:	5a5f006d 	bpl	17c1494 <__bss_end+0x17b7a5c>
    12dc:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    12e0:	5f646568 	svcpl	0x00646568
    12e4:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    12e8:	5f007664 	svcpl	0x00007664
    12ec:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    12f0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 12f8 <shift+0x12f8>
    12f4:	5f6b7361 	svcpl	0x006b7361
    12f8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    12fc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1300:	6177006a 	cmnvs	r7, sl, rrx
    1304:	5f007469 	svcpl	0x00007469
    1308:	6f6e365a 	svcvs	0x006e365a
    130c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1310:	5f006a6a 	svcpl	0x00006a6a
    1314:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    1318:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    131c:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    1320:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
    1324:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
    1328:	6f637469 	svcvs	0x00637469
    132c:	5f006564 	svcpl	0x00006564
    1330:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    1334:	615f7465 	cmpvs	pc, r5, ror #8
    1338:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    133c:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    1340:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1344:	6f635f73 	svcvs	0x00635f73
    1348:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    134c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    1350:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1354:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1358:	63697400 	cmnvs	r9, #0, 8
    135c:	6f635f6b 	svcvs	0x00635f6b
    1360:	5f746e75 	svcpl	0x00746e75
    1364:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    1368:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    136c:	70695000 	rsbvc	r5, r9, r0
    1370:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1374:	505f656c 	subspl	r6, pc, ip, ror #10
    1378:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    137c:	5a5f0078 	bpl	17c1564 <__bss_end+0x17b7b2c>
    1380:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    1384:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1388:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    138c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1390:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
    1394:	00706565 	rsbseq	r6, r0, r5, ror #10
    1398:	5f746573 	svcpl	0x00746573
    139c:	6b736174 	blvs	1cd9974 <__bss_end+0x1ccff3c>
    13a0:	6165645f 	cmnvs	r5, pc, asr r4
    13a4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    13a8:	706f0065 	rsbvc	r0, pc, r5, rrx
    13ac:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    13b0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    13b4:	63355a5f 	teqvs	r5, #389120	; 0x5f000
    13b8:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    13bc:	682f006a 	stmdavs	pc!, {r1, r3, r5, r6}	; <UNPREDICTABLE>
    13c0:	2f656d6f 	svccs	0x00656d6f
    13c4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    13c8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    13cc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    13d0:	2f736f2f 	svccs	0x00736f2f
    13d4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    13d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    13dc:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    13e0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    13e4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    13e8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    13ec:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    13f0:	70632e65 	rsbvc	r2, r3, r5, ror #28
    13f4:	5a5f0070 	bpl	17c15bc <__bss_end+0x17b7b84>
    13f8:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    13fc:	76646970 			; <UNDEFINED> instruction: 0x76646970
    1400:	616e6600 	cmnvs	lr, r0, lsl #12
    1404:	6e00656d 	cfsh32vs	mvfx6, mvfx0, #61
    1408:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    140c:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
    1410:	00736b63 	rsbseq	r6, r3, r3, ror #22
    1414:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1418:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    141c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    1420:	6a634b50 	bvs	18d4168 <__bss_end+0x18ca730>
    1424:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
    1428:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    142c:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
    1430:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
    1434:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1438:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    143c:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1440:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1444:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1448:	6f682f00 	svcvs	0x00682f00
    144c:	6a2f656d 	bvs	bdaa08 <__bss_end+0xbd0fd0>
    1450:	73656d61 	cmnvc	r5, #6208	; 0x1840
    1454:	2f697261 	svccs	0x00697261
    1458:	2f746967 	svccs	0x00746967
    145c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    1460:	6f732f70 	svcvs	0x00732f70
    1464:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1468:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    146c:	00646c69 	rsbeq	r6, r4, r9, ror #24
    1470:	61726170 	cmnvs	r2, r0, ror r1
    1474:	5a5f006d 	bpl	17c1630 <__bss_end+0x17b7bf8>
    1478:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    147c:	506a6574 	rsbpl	r6, sl, r4, ror r5
    1480:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1484:	5f746567 	svcpl	0x00746567
    1488:	6b736174 	blvs	1cd9a60 <__bss_end+0x1cd0028>
    148c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1490:	745f736b 	ldrbvc	r7, [pc], #-875	; 1498 <shift+0x1498>
    1494:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    1498:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    149c:	7700656e 	strvc	r6, [r0, -lr, ror #10]
    14a0:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    14a4:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    14a8:	7a69735f 	bvc	1a5e22c <__bss_end+0x1a547f4>
    14ac:	5a5f0065 	bpl	17c1648 <__bss_end+0x17b7c10>
    14b0:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    14b4:	6a6a7065 	bvs	1a9d650 <__bss_end+0x1a93c18>
    14b8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    14bc:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    14c0:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    14c4:	5f00676e 	svcpl	0x0000676e
    14c8:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    14cc:	745f7465 	ldrbvc	r7, [pc], #-1125	; 14d4 <shift+0x14d4>
    14d0:	5f6b7361 	svcpl	0x006b7361
    14d4:	6b636974 	blvs	18dbaac <__bss_end+0x18d2074>
    14d8:	6f745f73 	svcvs	0x00745f73
    14dc:	6165645f 	cmnvs	r5, pc, asr r4
    14e0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    14e4:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    14e8:	5f495753 	svcpl	0x00495753
    14ec:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    14f0:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    14f4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    14f8:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    14fc:	5a5f006d 	bpl	17c16b8 <__bss_end+0x17b7c80>
    1500:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1504:	6a6a6a74 	bvs	1a9bedc <__bss_end+0x1a924a4>
    1508:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    150c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1510:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1514:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1518:	4f5f6c74 	svcmi	0x005f6c74
    151c:	61726570 	cmnvs	r2, r0, ror r5
    1520:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1524:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1528:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    152c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1530:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1534:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    1538:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    153c:	00726566 	rsbseq	r6, r2, r6, ror #10
    1540:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
    1544:	6a646165 	bvs	1919ae0 <__bss_end+0x19100a8>
    1548:	006a6350 	rsbeq	r6, sl, r0, asr r3
    154c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1550:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1554:	5f746567 	svcpl	0x00746567
    1558:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    155c:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1560:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1564:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    1568:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    156c:	6c696600 	stclvs	6, cr6, [r9], #-0
    1570:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
    1574:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    1578:	74006461 	strvc	r6, [r0], #-1121	; 0xfffffb9f
    157c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1580:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1584:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1588:	00646970 	rsbeq	r6, r4, r0, ror r9
    158c:	6f345a5f 	svcvs	0x00345a5f
    1590:	506e6570 	rsbpl	r6, lr, r0, ror r5
    1594:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1598:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    159c:	704f5f65 	subvc	r5, pc, r5, ror #30
    15a0:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1414 <shift+0x1414>
    15a4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    15a8:	20554e47 	subscs	r4, r5, r7, asr #28
    15ac:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
    15b0:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
    15b4:	20312e32 	eorscs	r2, r1, r2, lsr lr
    15b8:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    15bc:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    15c0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    15c4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    15c8:	5b202965 	blpl	80bb64 <__bss_end+0x80212c>
    15cc:	2f4d5241 	svccs	0x004d5241
    15d0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    15d4:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    15d8:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    15dc:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    15e0:	6f697369 	svcvs	0x00697369
    15e4:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    15e8:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    15ec:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    15f0:	616f6c66 	cmnvs	pc, r6, ror #24
    15f4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    15f8:	61683d69 	cmnvs	r8, r9, ror #26
    15fc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1600:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1604:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1608:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    160c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1610:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1614:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1618:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    161c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1620:	20706676 	rsbscs	r6, r0, r6, ror r6
    1624:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1628:	613d656e 	teqvs	sp, lr, ror #10
    162c:	31316d72 	teqcc	r1, r2, ror sp
    1630:	7a6a3637 	bvc	1a8ef14 <__bss_end+0x1a854dc>
    1634:	20732d66 	rsbscs	r2, r3, r6, ror #26
    1638:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    163c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1640:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1644:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1648:	6b7a3676 	blvs	1e8f028 <__bss_end+0x1e855f0>
    164c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1650:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1654:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1658:	304f2d20 	subcc	r2, pc, r0, lsr #26
    165c:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1660:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1664:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
    1668:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    166c:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    1670:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1674:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
    1678:	5f006974 	svcpl	0x00006974
    167c:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    1680:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1684:	50764b50 	rsbspl	r4, r6, r0, asr fp
    1688:	2f006976 	svccs	0x00006976
    168c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1690:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    1694:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    1698:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    169c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    16a0:	2f70732f 	svccs	0x0070732f
    16a4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    16a8:	2f736563 	svccs	0x00736563
    16ac:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    16b0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    16b4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    16b8:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    16bc:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    16c0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    16c4:	6d657200 	sfmvs	f7, 2, [r5, #-0]
    16c8:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
    16cc:	69007265 	stmdbvs	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    16d0:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    16d4:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    16d8:	61726765 	cmnvs	r2, r5, ror #14
    16dc:	7369006c 	cmnvc	r9, #108	; 0x6c
    16e0:	00666e69 	rsbeq	r6, r6, r9, ror #28
    16e4:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    16e8:	006c616d 	rsbeq	r6, ip, sp, ror #2
    16ec:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    16f0:	6a616f74 	bvs	185d4c8 <__bss_end+0x1853a90>
    16f4:	006a6350 	rsbeq	r6, sl, r0, asr r3
    16f8:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    16fc:	696f7000 	stmdbvs	pc!, {ip, sp, lr}^	; <UNPREDICTABLE>
    1700:	735f746e 	cmpvc	pc, #1845493760	; 0x6e000000
    1704:	006e6565 	rsbeq	r6, lr, r5, ror #10
    1708:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    170c:	645f676e 	ldrbvs	r6, [pc], #-1902	; 1714 <shift+0x1714>
    1710:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1714:	00736c61 	rsbseq	r6, r3, r1, ror #24
    1718:	65776f70 	ldrbvs	r6, [r7, #-3952]!	; 0xfffff090
    171c:	74730072 	ldrbtvc	r0, [r3], #-114	; 0xffffff8e
    1720:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1724:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1728:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
    172c:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    1730:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    1734:	5a5f0074 	bpl	17c190c <__bss_end+0x17b7ed4>
    1738:	6f746134 	svcvs	0x00746134
    173c:	634b5066 	movtvs	r5, #45158	; 0xb066
    1740:	73656400 	cmnvc	r5, #0, 8
    1744:	5a5f0074 	bpl	17c191c <__bss_end+0x17b7ee4>
    1748:	76657236 			; <UNDEFINED> instruction: 0x76657236
    174c:	50727473 	rsbspl	r7, r2, r3, ror r4
    1750:	5a5f0063 	bpl	17c18e4 <__bss_end+0x17b7eac>
    1754:	6e736935 			; <UNDEFINED> instruction: 0x6e736935
    1758:	00666e61 	rsbeq	r6, r6, r1, ror #28
    175c:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    1760:	61620074 	smcvs	8196	; 0x2004
    1764:	74006573 	strvc	r6, [r0], #-1395	; 0xfffffa8d
    1768:	00706d65 	rsbseq	r6, r0, r5, ror #26
    176c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1770:	6f72657a 	svcvs	0x0072657a
    1774:	00697650 	rsbeq	r7, r9, r0, asr r6
    1778:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    177c:	00797063 	rsbseq	r7, r9, r3, rrx
    1780:	616f7469 	cmnvs	pc, r9, ror #8
    1784:	72747300 	rsbsvc	r7, r4, #0, 6
    1788:	74730031 	ldrbtvc	r0, [r3], #-49	; 0xffffffcf
    178c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1790:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1794:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1798:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    179c:	5f006666 	svcpl	0x00006666
    17a0:	6f70335a 	svcvs	0x0070335a
    17a4:	006a6677 	rsbeq	r6, sl, r7, ror r6
    17a8:	31315a5f 	teqcc	r1, pc, asr sl
    17ac:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    17b0:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    17b4:	6674616f 	ldrbtvs	r6, [r4], -pc, ror #2
    17b8:	5f536a52 	svcpl	0x00536a52
    17bc:	61006952 	tstvs	r0, r2, asr r9
    17c0:	00666f74 	rsbeq	r6, r6, r4, ror pc
    17c4:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    17c8:	43007473 	movwmi	r7, #1139	; 0x473
    17cc:	43726168 	cmnmi	r2, #104, 2
    17d0:	41766e6f 	cmnmi	r6, pc, ror #28
    17d4:	66007272 			; <UNDEFINED> instruction: 0x66007272
    17d8:	00616f74 	rsbeq	r6, r1, r4, ror pc
    17dc:	33325a5f 	teqcc	r2, #389120	; 0x5f000
    17e0:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    17e4:	5f6c616d 	svcpl	0x006c616d
    17e8:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    17ec:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    17f0:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    17f4:	6a74616f 	bvs	1d19db8 <__bss_end+0x1d10380>
    17f8:	00696350 	rsbeq	r6, r9, r0, asr r3
    17fc:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1800:	70006372 	andvc	r6, r0, r2, ror r3
    1804:	69636572 	stmdbvs	r3!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1808:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    180c:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    1810:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    1814:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1818:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
    181c:	00786564 	rsbseq	r6, r8, r4, ror #10
    1820:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1824:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1828:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    182c:	5f007374 	svcpl	0x00007374
    1830:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1834:	4b50696f 	blmi	141bdf8 <__bss_end+0x14123c0>
    1838:	756f0063 	strbvc	r0, [pc, #-99]!	; 17dd <shift+0x17dd>
    183c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1840:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1844:	616f7466 	cmnvs	pc, r6, ror #8
    1848:	6a635066 	bvs	18d59e8 <__bss_end+0x18cbfb0>
    184c:	6c707300 	ldclvs	3, cr7, [r0], #-0
    1850:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1854:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1858:	63616600 	cmnvs	r1, #0, 12
    185c:	5a5f0074 	bpl	17c1a34 <__bss_end+0x17b7ffc>
    1860:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1864:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1868:	5f00634b 	svcpl	0x0000634b
    186c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1870:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1874:	634b5070 	movtvs	r5, #45168	; 0xb070
    1878:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    187c:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1880:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1884:	50797063 	rsbspl	r7, r9, r3, rrx
    1888:	634b5063 	movtvs	r5, #45155	; 0xb063
    188c:	65640069 	strbvs	r0, [r4, #-105]!	; 0xffffff97
    1890:	616d6963 	cmnvs	sp, r3, ror #18
    1894:	6f745f6c 	svcvs	0x00745f6c
    1898:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    189c:	5f676e69 	svcpl	0x00676e69
    18a0:	616f6c66 	cmnvs	pc, r6, ror #24
    18a4:	5a5f0074 	bpl	17c1a7c <__bss_end+0x17b8044>
    18a8:	6f746634 	svcvs	0x00746634
    18ac:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    18b0:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    18b4:	0079726f 	rsbseq	r7, r9, pc, ror #4
    18b8:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    18bc:	73006874 	movwvc	r6, #2164	; 0x874
    18c0:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    18c4:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    18c8:	72747376 	rsbsvc	r7, r4, #-671088639	; 0xd8000001
    18cc:	2f2e2e00 	svccs	0x002e2e00
    18d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    18d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18d8:	2f2e2e2f 	svccs	0x002e2e2f
    18dc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 182c <shift+0x182c>
    18e0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    18e4:	6f632f63 	svcvs	0x00632f63
    18e8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    18ec:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    18f0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    18f4:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    18f8:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    18fc:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1900:	2f646c69 	svccs	0x00646c69
    1904:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1908:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    190c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1910:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1914:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    1918:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    191c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1920:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1924:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1928:	61652d65 	cmnvs	r5, r5, ror #26
    192c:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    1930:	3130322d 	teqcc	r0, sp, lsr #4
    1934:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    1938:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    193c:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1940:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1944:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1948:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    194c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1950:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1954:	61682f65 	cmnvs	r8, r5, ror #30
    1958:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 1798 <shift+0x1798>
    195c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1960:	41540063 	cmpmi	r4, r3, rrx
    1964:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1968:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    196c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1970:	61786574 	cmnvs	r8, r4, ror r5
    1974:	6f633731 	svcvs	0x00633731
    1978:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    197c:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    1980:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1984:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1988:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    198c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1990:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1994:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1998:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    199c:	41540074 	cmpmi	r4, r4, ror r0
    19a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    19ac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    19b0:	41003332 	tstmi	r0, r2, lsr r3
    19b4:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; c6a <shift+0xc6a>
    19b8:	41540051 	cmpmi	r4, r1, asr r0
    19bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19c8:	36353131 			; <UNDEFINED> instruction: 0x36353131
    19cc:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    19d0:	61736900 	cmnvs	r3, r0, lsl #18
    19d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19d8:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    19dc:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    19e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19e4:	50435f54 	subpl	r5, r3, r4, asr pc
    19e8:	6f635f55 	svcvs	0x00635f55
    19ec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    19f0:	63373561 	teqvs	r7, #406847488	; 0x18400000
    19f4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19f8:	33356178 	teqcc	r5, #120, 2
    19fc:	53414200 	movtpl	r4, #4608	; 0x1200
    1a00:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a04:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1a08:	41425f4d 	cmpmi	r2, sp, asr #30
    1a0c:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    1a10:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a14:	50435f54 	subpl	r5, r3, r4, asr pc
    1a18:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a1c:	3031386d 	eorscc	r3, r1, sp, ror #16
    1a20:	52415400 	subpl	r5, r1, #0, 8
    1a24:	5f544547 	svcpl	0x00544547
    1a28:	5f555043 	svcpl	0x00555043
    1a2c:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    1a30:	41003165 	tstmi	r0, r5, ror #2
    1a34:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1a38:	415f5343 	cmpmi	pc, r3, asr #6
    1a3c:	53435041 	movtpl	r5, #12353	; 0x3041
    1a40:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    1a44:	0054584d 	subseq	r5, r4, sp, asr #16
    1a48:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a4c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a50:	00305f48 	eorseq	r5, r0, r8, asr #30
    1a54:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a58:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a5c:	00325f48 	eorseq	r5, r2, r8, asr #30
    1a60:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a64:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a68:	00335f48 	eorseq	r5, r3, r8, asr #30
    1a6c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a70:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a74:	00345f48 	eorseq	r5, r4, r8, asr #30
    1a78:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a7c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a80:	00365f48 	eorseq	r5, r6, r8, asr #30
    1a84:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a88:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a8c:	00375f48 	eorseq	r5, r7, r8, asr #30
    1a90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a98:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1a9c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1aa0:	73690065 	cmnvc	r9, #101	; 0x65
    1aa4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1aa8:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1aac:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1ab0:	41540073 	cmpmi	r4, r3, ror r0
    1ab4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ab8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1abc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ac0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1ac4:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    1ac8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1acc:	50435f54 	subpl	r5, r3, r4, asr pc
    1ad0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1ad4:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    1ad8:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1adc:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1ae0:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1ae4:	52415400 	subpl	r5, r1, #0, 8
    1ae8:	5f544547 	svcpl	0x00544547
    1aec:	5f555043 	svcpl	0x00555043
    1af0:	316d7261 	cmncc	sp, r1, ror #4
    1af4:	6a363731 	bvs	d8f7c0 <__bss_end+0xd85d88>
    1af8:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1afc:	5f617369 	svcpl	0x00617369
    1b00:	5f746962 	svcpl	0x00746962
    1b04:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1b08:	52410032 	subpl	r0, r1, #50	; 0x32
    1b0c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1b10:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    1b14:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    1b18:	4154004e 	cmpmi	r4, lr, asr #32
    1b1c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b20:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b24:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b28:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    1b2c:	5f455341 	svcpl	0x00455341
    1b30:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b34:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1b38:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1b3c:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1b40:	5f6d7366 	svcpl	0x006d7366
    1b44:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1b48:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1b4c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1b50:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1b54:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    1b58:	63657073 	cmnvs	r5, #115	; 0x73
    1b5c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1b60:	73676e69 	cmnvc	r7, #1680	; 0x690
    1b64:	61736900 	cmnvs	r3, r0, lsl #18
    1b68:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b6c:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1b70:	635f5f00 	cmpvs	pc, #0, 30
    1b74:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1b7c <shift+0x1b7c>
    1b78:	41006261 	tstmi	r0, r1, ror #4
    1b7c:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1b80:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1b84:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1b88:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1b8c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1b90:	52410065 	subpl	r0, r1, #101	; 0x65
    1b94:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1b98:	4d524100 	ldfmie	f4, [r2, #-0]
    1b9c:	0053565f 	subseq	r5, r3, pc, asr r6
    1ba0:	5f4d5241 	svcpl	0x004d5241
    1ba4:	61004547 	tstvs	r0, r7, asr #10
    1ba8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1bb0 <shift+0x1bb0>
    1bac:	5f656e75 	svcpl	0x00656e75
    1bb0:	6f727473 	svcvs	0x00727473
    1bb4:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1bb8:	6f63006d 	svcvs	0x0063006d
    1bbc:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1bc0:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1bc4:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1bc8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bcc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bd0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bd4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bd8:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1bdc:	52415400 	subpl	r5, r1, #0, 8
    1be0:	5f544547 	svcpl	0x00544547
    1be4:	5f555043 	svcpl	0x00555043
    1be8:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1bec:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1bf0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bf4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bf8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bfc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c00:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1c04:	4d524100 	ldfmie	f4, [r2, #-0]
    1c08:	0054475f 	subseq	r4, r4, pc, asr r7
    1c0c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c10:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c14:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    1c18:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    1c1c:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    1c20:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    1c24:	2f2e2e2f 	svccs	0x002e2e2f
    1c28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c30:	2f2e2e2f 	svccs	0x002e2e2f
    1c34:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1c38:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1ab4 <shift+0x1ab4>
    1c3c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c40:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1c44:	52415400 	subpl	r5, r1, #0, 8
    1c48:	5f544547 	svcpl	0x00544547
    1c4c:	5f555043 	svcpl	0x00555043
    1c50:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c54:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1c58:	41420066 	cmpmi	r2, r6, rrx
    1c5c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c60:	5f484352 	svcpl	0x00484352
    1c64:	004d4537 	subeq	r4, sp, r7, lsr r5
    1c68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c70:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c74:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c78:	32316178 	eorscc	r6, r1, #120, 2
    1c7c:	73616800 	cmnvc	r1, #0, 16
    1c80:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1c84:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    1c88:	5f455341 	svcpl	0x00455341
    1c8c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c90:	5a4b365f 	bpl	12cf614 <__bss_end+0x12c5bdc>
    1c94:	61736900 	cmnvs	r3, r0, lsl #18
    1c98:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c9c:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1ca0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ca4:	615f6863 	cmpvs	pc, r3, ror #16
    1ca8:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1cac:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1cb0:	6d726100 	ldfvse	f6, [r2, #-0]
    1cb4:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1cb8:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1cbc:	73690063 	cmnvc	r9, #99	; 0x63
    1cc0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cc4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1cc8:	47003631 	smladxmi	r0, r1, r6, r3
    1ccc:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1cd0:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    1cd4:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    1cd8:	31303220 	teqcc	r0, r0, lsr #4
    1cdc:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    1ce0:	72282035 	eorvc	r2, r8, #53	; 0x35
    1ce4:	61656c65 	cmnvs	r5, r5, ror #24
    1ce8:	20296573 	eorcs	r6, r9, r3, ror r5
    1cec:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1cf0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1cf4:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    1cf8:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1cfc:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1d00:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1d04:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    1d08:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1d0c:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    1d10:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1d14:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1d18:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1d1c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1d20:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1d24:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1d28:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d2c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1d30:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1d34:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1d38:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1d3c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1d40:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d44:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d48:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d4c:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1d50:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1d54:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1d58:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1d5c:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1d60:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1bd0 <shift+0x1bd0>
    1d64:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1d68:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1d6c:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1d70:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1d74:	6f6e662d 	svcvs	0x006e662d
    1d78:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1d7c:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1d80:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1d84:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1d88:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1d8c:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1d90:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1d94:	5f4d5241 	svcpl	0x004d5241
    1d98:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1d9c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1da0:	615f7469 	cmpvs	pc, r9, ror #8
    1da4:	00766964 	rsbseq	r6, r6, r4, ror #18
    1da8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1db0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1db4:	31316d72 	teqcc	r1, r2, ror sp
    1db8:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1dbc:	52415400 	subpl	r5, r1, #0, 8
    1dc0:	5f544547 	svcpl	0x00544547
    1dc4:	5f555043 	svcpl	0x00555043
    1dc8:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1dcc:	52415400 	subpl	r5, r1, #0, 8
    1dd0:	5f544547 	svcpl	0x00544547
    1dd4:	5f555043 	svcpl	0x00555043
    1dd8:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1ddc:	52415400 	subpl	r5, r1, #0, 8
    1de0:	5f544547 	svcpl	0x00544547
    1de4:	5f555043 	svcpl	0x00555043
    1de8:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1dec:	6f6c0036 	svcvs	0x006c0036
    1df0:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    1df4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1df8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1dfc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1e00:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    1e04:	6d726100 	ldfvse	f6, [r2, #-0]
    1e08:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e0c:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    1e10:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1e14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e18:	50435f54 	subpl	r5, r3, r4, asr pc
    1e1c:	6f635f55 	svcvs	0x00635f55
    1e20:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e24:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1e28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e30:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e34:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1e38:	52415400 	subpl	r5, r1, #0, 8
    1e3c:	5f544547 	svcpl	0x00544547
    1e40:	5f555043 	svcpl	0x00555043
    1e44:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e48:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1e4c:	6d726100 	ldfvse	f6, [r2, #-0]
    1e50:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1e54:	6f635f64 	svcvs	0x00635f64
    1e58:	41006564 	tstmi	r0, r4, ror #10
    1e5c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1e60:	415f5343 	cmpmi	pc, r3, asr #6
    1e64:	53435041 	movtpl	r5, #12353	; 0x3041
    1e68:	61736900 	cmnvs	r3, r0, lsl #18
    1e6c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e70:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e74:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1e78:	53414200 	movtpl	r4, #4608	; 0x1200
    1e7c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e80:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1e84:	4154004d 	cmpmi	r4, sp, asr #32
    1e88:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e8c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e90:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e94:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1e98:	6d726100 	ldfvse	f6, [r2, #-0]
    1e9c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ea0:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1ea4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ea8:	73690032 	cmnvc	r9, #50	; 0x32
    1eac:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1eb0:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1eb4:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1eb8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ebc:	50435f54 	subpl	r5, r3, r4, asr pc
    1ec0:	6f635f55 	svcvs	0x00635f55
    1ec4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ec8:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1ecc:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1ed0:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1ed4:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1ed8:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1edc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ee0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ee4:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 199c <shift+0x199c>
    1ee8:	6f6e7978 	svcvs	0x006e7978
    1eec:	00316d73 	eorseq	r6, r1, r3, ror sp
    1ef0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ef4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ef8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1efc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f00:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    1f04:	61736900 	cmnvs	r3, r0, lsl #18
    1f08:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f0c:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1f10:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1f14:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1f18:	6f656e5f 	svcvs	0x00656e5f
    1f1c:	6f665f6e 	svcvs	0x00665f6e
    1f20:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    1f24:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f28:	61736900 	cmnvs	r3, r0, lsl #18
    1f2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f30:	3170665f 	cmncc	r0, pc, asr r6
    1f34:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1f38:	52415400 	subpl	r5, r1, #0, 8
    1f3c:	5f544547 	svcpl	0x00544547
    1f40:	5f555043 	svcpl	0x00555043
    1f44:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f48:	33617865 	cmncc	r1, #6619136	; 0x650000
    1f4c:	41540032 	cmpmi	r4, r2, lsr r0
    1f50:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f54:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f58:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f5c:	61786574 	cmnvs	r8, r4, ror r5
    1f60:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1f64:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f68:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f6c:	63363170 	teqvs	r6, #112, 2
    1f70:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1f74:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1f78:	5f766365 	svcpl	0x00766365
    1f7c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1f80:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1f84:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f88:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f8c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f90:	31316d72 	teqcc	r1, r2, ror sp
    1f94:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1f98:	41540073 	cmpmi	r4, r3, ror r0
    1f9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fa0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fa4:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1fa8:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1fac:	52415400 	subpl	r5, r1, #0, 8
    1fb0:	5f544547 	svcpl	0x00544547
    1fb4:	5f555043 	svcpl	0x00555043
    1fb8:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1fbc:	6a653632 	bvs	194f88c <__bss_end+0x1945e54>
    1fc0:	41420073 	hvcmi	8195	; 0x2003
    1fc4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1fc8:	5f484352 	svcpl	0x00484352
    1fcc:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    1fd0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fd4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1fd8:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1fdc:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    1fe0:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    1fe4:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1fe8:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    1fec:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    1ff0:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    1ff4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ff8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1ffc:	41420062 	cmpmi	r2, r2, rrx
    2000:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2004:	5f484352 	svcpl	0x00484352
    2008:	00455435 	subeq	r5, r5, r5, lsr r4
    200c:	5f617369 	svcpl	0x00617369
    2010:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    2014:	00657275 	rsbeq	r7, r5, r5, ror r2
    2018:	5f617369 	svcpl	0x00617369
    201c:	5f746962 	svcpl	0x00746962
    2020:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2024:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2028:	6d726100 	ldfvse	f6, [r2, #-0]
    202c:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    2030:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 10d1 <shift+0x10d1>
    2034:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    2038:	6a626f5f 	bvs	189ddbc <__bss_end+0x1894384>
    203c:	5f746365 	svcpl	0x00746365
    2040:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    2044:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    2048:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    204c:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    2050:	5f617369 	svcpl	0x00617369
    2054:	5f746962 	svcpl	0x00746962
    2058:	645f7066 	ldrbvs	r7, [pc], #-102	; 2060 <shift+0x2060>
    205c:	41003233 	tstmi	r0, r3, lsr r2
    2060:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    2064:	73690045 	cmnvc	r9, #69	; 0x45
    2068:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    206c:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    2070:	41540038 	cmpmi	r4, r8, lsr r0
    2074:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2078:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    207c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2080:	36373131 			; <UNDEFINED> instruction: 0x36373131
    2084:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    2088:	636f7270 	cmnvs	pc, #112, 4
    208c:	6f737365 	svcvs	0x00737365
    2090:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2094:	61006570 	tstvs	r0, r0, ror r5
    2098:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    209c:	00737570 	rsbseq	r7, r3, r0, ror r5
    20a0:	5f6d7261 	svcpl	0x006d7261
    20a4:	00736370 	rsbseq	r6, r3, r0, ror r3
    20a8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20ac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20b0:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    20b4:	6d726100 	ldfvse	f6, [r2, #-0]
    20b8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20bc:	00743468 	rsbseq	r3, r4, r8, ror #8
    20c0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20c4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20c8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20cc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20d0:	36376178 			; <UNDEFINED> instruction: 0x36376178
    20d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    20d8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    20dc:	72610035 	rsbvc	r0, r1, #53	; 0x35
    20e0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    20e4:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    20e8:	00667562 	rsbeq	r7, r6, r2, ror #10
    20ec:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    20f0:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    20f4:	73690068 	cmnvc	r9, #104	; 0x68
    20f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20fc:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2100:	5f6b7269 	svcpl	0x006b7269
    2104:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2108:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    210c:	5f656c69 	svcpl	0x00656c69
    2110:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    2114:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2118:	50435f54 	subpl	r5, r3, r4, asr pc
    211c:	6f635f55 	svcvs	0x00635f55
    2120:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2124:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    2128:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    212c:	50435f54 	subpl	r5, r3, r4, asr pc
    2130:	6f635f55 	svcvs	0x00635f55
    2134:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2138:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    213c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2140:	50435f54 	subpl	r5, r3, r4, asr pc
    2144:	6f635f55 	svcvs	0x00635f55
    2148:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    214c:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    2150:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2154:	615f7469 	cmpvs	pc, r9, ror #8
    2158:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    215c:	6100315f 	tstvs	r0, pc, asr r1
    2160:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2164:	5f686372 	svcpl	0x00686372
    2168:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    216c:	61736900 	cmnvs	r3, r0, lsl #18
    2170:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2174:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2178:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    217c:	61736900 	cmnvs	r3, r0, lsl #18
    2180:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2184:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2188:	345f3876 	ldrbcc	r3, [pc], #-2166	; 2190 <shift+0x2190>
    218c:	61736900 	cmnvs	r3, r0, lsl #18
    2190:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2194:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2198:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 192a <shift+0x192a>
    219c:	52415400 	subpl	r5, r1, #0, 8
    21a0:	5f544547 	svcpl	0x00544547
    21a4:	5f555043 	svcpl	0x00555043
    21a8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21ac:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    21b0:	41540033 	cmpmi	r4, r3, lsr r0
    21b4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21b8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21bc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    21c0:	61786574 	cmnvs	r8, r4, ror r5
    21c4:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    21c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21cc:	50435f54 	subpl	r5, r3, r4, asr pc
    21d0:	6f635f55 	svcvs	0x00635f55
    21d4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21d8:	00373561 	eorseq	r3, r7, r1, ror #10
    21dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21e4:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20ac <shift+0x20ac>
    21e8:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    21ec:	41540065 	cmpmi	r4, r5, rrx
    21f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21f8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21fc:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    2200:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2204:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2208:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    220c:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2210:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2214:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2218:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    221c:	30316d72 	eorscc	r6, r1, r2, ror sp
    2220:	6a653632 	bvs	194faf0 <__bss_end+0x19460b8>
    2224:	41420073 	hvcmi	8195	; 0x2003
    2228:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    222c:	5f484352 	svcpl	0x00484352
    2230:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    2234:	5f455341 	svcpl	0x00455341
    2238:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    223c:	004b365f 	subeq	r3, fp, pc, asr r6
    2240:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2244:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2248:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    224c:	61736900 	cmnvs	r3, r0, lsl #18
    2250:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2254:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2258:	0074786d 	rsbseq	r7, r4, sp, ror #16
    225c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2260:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2264:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2268:	31316d72 	teqcc	r1, r2, ror sp
    226c:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    2270:	52410073 	subpl	r0, r1, #115	; 0x73
    2274:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    2278:	4d524100 	ldfmie	f4, [r2, #-0]
    227c:	00544c5f 	subseq	r4, r4, pc, asr ip
    2280:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2284:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2288:	5a365f48 	bpl	d99fb0 <__bss_end+0xd90578>
    228c:	52415400 	subpl	r5, r1, #0, 8
    2290:	5f544547 	svcpl	0x00544547
    2294:	5f555043 	svcpl	0x00555043
    2298:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    229c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22a0:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    22a4:	61786574 	cmnvs	r8, r4, ror r5
    22a8:	41003535 	tstmi	r0, r5, lsr r5
    22ac:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    22b0:	415f5343 	cmpmi	pc, r3, asr #6
    22b4:	53435041 	movtpl	r5, #12353	; 0x3041
    22b8:	5046565f 	subpl	r5, r6, pc, asr r6
    22bc:	52415400 	subpl	r5, r1, #0, 8
    22c0:	5f544547 	svcpl	0x00544547
    22c4:	5f555043 	svcpl	0x00555043
    22c8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    22cc:	00327478 	eorseq	r7, r2, r8, ror r4
    22d0:	5f617369 	svcpl	0x00617369
    22d4:	5f746962 	svcpl	0x00746962
    22d8:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    22dc:	6d726100 	ldfvse	f6, [r2, #-0]
    22e0:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    22e4:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    22e8:	73690072 	cmnvc	r9, #114	; 0x72
    22ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22f0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    22f4:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    22f8:	4154006d 	cmpmi	r4, sp, rrx
    22fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2300:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2304:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    2308:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    230c:	52415400 	subpl	r5, r1, #0, 8
    2310:	5f544547 	svcpl	0x00544547
    2314:	5f555043 	svcpl	0x00555043
    2318:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    231c:	5f6c6c65 	svcpl	0x006c6c65
    2320:	00346a70 	eorseq	r6, r4, r0, ror sl
    2324:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2328:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    232c:	6f705f68 	svcvs	0x00705f68
    2330:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2334:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2338:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    233c:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    2340:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2344:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2348:	61736900 	cmnvs	r3, r0, lsl #18
    234c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2350:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2354:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2358:	52415400 	subpl	r5, r1, #0, 8
    235c:	5f544547 	svcpl	0x00544547
    2360:	5f555043 	svcpl	0x00555043
    2364:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2368:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    236c:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    2370:	61786574 	cmnvs	r8, r4, ror r5
    2374:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    2378:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    237c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 2384 <shift+0x2384>
    2380:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2384:	41420032 	cmpmi	r2, r2, lsr r0
    2388:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    238c:	5f484352 	svcpl	0x00484352
    2390:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    2394:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2398:	645f7469 	ldrbvs	r7, [pc], #-1129	; 23a0 <shift+0x23a0>
    239c:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    23a0:	6100646f 	tstvs	r0, pc, ror #8
    23a4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    23a8:	5f363170 	svcpl	0x00363170
    23ac:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23b0:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 23b8 <shift+0x23b8>
    23b4:	52410065 	subpl	r0, r1, #101	; 0x65
    23b8:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    23bc:	6d726100 	ldfvse	f6, [r2, #-0]
    23c0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23c4:	006b3668 	rsbeq	r3, fp, r8, ror #12
    23c8:	5f6d7261 	svcpl	0x006d7261
    23cc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    23d0:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    23d4:	5f455341 	svcpl	0x00455341
    23d8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    23dc:	0052375f 	subseq	r3, r2, pc, asr r7
    23e0:	6f705f5f 	svcvs	0x00705f5f
    23e4:	756f6370 	strbvc	r6, [pc, #-880]!	; 207c <shift+0x207c>
    23e8:	745f746e 	ldrbvc	r7, [pc], #-1134	; 23f0 <shift+0x23f0>
    23ec:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    23f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23f4:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    23f8:	0065736d 	rsbeq	r7, r5, sp, ror #6
    23fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2400:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2404:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2408:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    240c:	33376178 	teqcc	r7, #120, 2
    2410:	52415400 	subpl	r5, r1, #0, 8
    2414:	5f544547 	svcpl	0x00544547
    2418:	5f555043 	svcpl	0x00555043
    241c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    2420:	76636972 			; <UNDEFINED> instruction: 0x76636972
    2424:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    2428:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    242c:	50435f54 	subpl	r5, r3, r4, asr pc
    2430:	6f635f55 	svcvs	0x00635f55
    2434:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2438:	00363761 	eorseq	r3, r6, r1, ror #14
    243c:	5f6d7261 	svcpl	0x006d7261
    2440:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2444:	5f6f6e5f 	svcpl	0x006f6e5f
    2448:	616c6f76 	smcvs	50934	; 0xc6f6
    244c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2450:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2454:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2458:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    245c:	41385f48 	teqmi	r8, r8, asr #30
    2460:	61736900 	cmnvs	r3, r0, lsl #18
    2464:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2468:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    246c:	00743576 	rsbseq	r3, r4, r6, ror r5
    2470:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2474:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2478:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    247c:	52415400 	subpl	r5, r1, #0, 8
    2480:	5f544547 	svcpl	0x00544547
    2484:	5f555043 	svcpl	0x00555043
    2488:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    248c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2490:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    2494:	61786574 	cmnvs	r8, r4, ror r5
    2498:	41003533 	tstmi	r0, r3, lsr r5
    249c:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    24a0:	72610056 	rsbvc	r0, r1, #86	; 0x56
    24a4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24a8:	00346863 	eorseq	r6, r4, r3, ror #16
    24ac:	5f6d7261 	svcpl	0x006d7261
    24b0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24b4:	72610036 	rsbvc	r0, r1, #54	; 0x36
    24b8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24bc:	00376863 	eorseq	r6, r7, r3, ror #16
    24c0:	5f6d7261 	svcpl	0x006d7261
    24c4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24c8:	6f6c0038 	svcvs	0x006c0038
    24cc:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    24d0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    24d4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    24d8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    24dc:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    24e0:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    24e4:	616d0065 	cmnvs	sp, r5, rrx
    24e8:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    24ec:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    24f0:	745f7473 	ldrbvc	r7, [pc], #-1139	; 24f8 <shift+0x24f8>
    24f4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    24f8:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    24fc:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    2500:	5f6c6c61 	svcpl	0x006c6c61
    2504:	5f616976 	svcpl	0x00616976
    2508:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    250c:	7369006c 	cmnvc	r9, #108	; 0x6c
    2510:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2514:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2518:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    251c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2520:	615f7469 	cmpvs	pc, r9, ror #8
    2524:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2528:	4154006b 	cmpmi	r4, fp, rrx
    252c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2530:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2534:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2538:	61786574 	cmnvs	r8, r4, ror r5
    253c:	41540037 	cmpmi	r4, r7, lsr r0
    2540:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2544:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2548:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    254c:	61786574 	cmnvs	r8, r4, ror r5
    2550:	41540038 	cmpmi	r4, r8, lsr r0
    2554:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2558:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    255c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2560:	61786574 	cmnvs	r8, r4, ror r5
    2564:	52410039 	subpl	r0, r1, #57	; 0x39
    2568:	43505f4d 	cmpmi	r0, #308	; 0x134
    256c:	50415f53 	subpl	r5, r1, r3, asr pc
    2570:	41005343 	tstmi	r0, r3, asr #6
    2574:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2578:	415f5343 	cmpmi	pc, r3, asr #6
    257c:	53435054 	movtpl	r5, #12372	; 0x3054
    2580:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 2588 <shift+0x2588>
    2584:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    2588:	756f6420 	strbvc	r6, [pc, #-1056]!	; 2170 <shift+0x2170>
    258c:	00656c62 	rsbeq	r6, r5, r2, ror #24
    2590:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2594:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2598:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    259c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25a0:	33376178 	teqcc	r7, #120, 2
    25a4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25a8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25ac:	41540033 	cmpmi	r4, r3, lsr r0
    25b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25b8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25bc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    25c0:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    25c4:	72610073 	rsbvc	r0, r1, #115	; 0x73
    25c8:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    25cc:	61736900 	cmnvs	r3, r0, lsl #18
    25d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25d4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    25d8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    25dc:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    25e0:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    25e4:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    25e8:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    25ec:	5f657265 	svcpl	0x00657265
    25f0:	52415400 	subpl	r5, r1, #0, 8
    25f4:	5f544547 	svcpl	0x00544547
    25f8:	5f555043 	svcpl	0x00555043
    25fc:	316d7261 	cmncc	sp, r1, ror #4
    2600:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    2604:	41540069 	cmpmi	r4, r9, rrx
    2608:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    260c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2610:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2614:	61786574 	cmnvs	r8, r4, ror r5
    2618:	61620035 	cmnvs	r2, r5, lsr r0
    261c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2620:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2624:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2628:	00657275 	rsbeq	r7, r5, r5, ror r2
    262c:	5f6d7261 	svcpl	0x006d7261
    2630:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2634:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2638:	52415400 	subpl	r5, r1, #0, 8
    263c:	5f544547 	svcpl	0x00544547
    2640:	5f555043 	svcpl	0x00555043
    2644:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2648:	316d7865 	cmncc	sp, r5, ror #16
    264c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2650:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2654:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2658:	72610079 	rsbvc	r0, r1, #121	; 0x79
    265c:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    2660:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    2664:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    2668:	61736900 	cmnvs	r3, r0, lsl #18
    266c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2670:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2674:	41003233 	tstmi	r0, r3, lsr r2
    2678:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    267c:	7369004c 	cmnvc	r9, #76	; 0x4c
    2680:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2684:	66765f74 	uhsub16vs	r5, r6, r4
    2688:	00337670 	eorseq	r7, r3, r0, ror r6
    268c:	5f617369 	svcpl	0x00617369
    2690:	5f746962 	svcpl	0x00746962
    2694:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2698:	41420034 	cmpmi	r2, r4, lsr r0
    269c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26a0:	5f484352 	svcpl	0x00484352
    26a4:	00325436 	eorseq	r5, r2, r6, lsr r4
    26a8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26ac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26b0:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    26b4:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    26b8:	4154004e 	cmpmi	r4, lr, asr #32
    26bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    26c8:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    26cc:	52410069 	subpl	r0, r1, #105	; 0x69
    26d0:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    26d4:	53414200 	movtpl	r4, #4608	; 0x1200
    26d8:	52415f45 	subpl	r5, r1, #276	; 0x114
    26dc:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    26e0:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    26e4:	61745f6d 	cmnvs	r4, sp, ror #30
    26e8:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    26ec:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    26f0:	61006c65 	tstvs	r0, r5, ror #24
    26f4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 26fc <shift+0x26fc>
    26f8:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    26fc:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    2700:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    2704:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2708:	50435f54 	subpl	r5, r3, r4, asr pc
    270c:	6f635f55 	svcvs	0x00635f55
    2710:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2714:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    2718:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    271c:	50435f54 	subpl	r5, r3, r4, asr pc
    2720:	6f635f55 	svcvs	0x00635f55
    2724:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2728:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    272c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2730:	50435f54 	subpl	r5, r3, r4, asr pc
    2734:	6f635f55 	svcvs	0x00635f55
    2738:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    273c:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    2740:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2744:	50435f54 	subpl	r5, r3, r4, asr pc
    2748:	6f635f55 	svcvs	0x00635f55
    274c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2750:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2754:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2758:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    275c:	00656170 	rsbeq	r6, r5, r0, ror r1
    2760:	5f617369 	svcpl	0x00617369
    2764:	5f746962 	svcpl	0x00746962
    2768:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    276c:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2770:	6b36766d 	blvs	da012c <__bss_end+0xd966f4>
    2774:	7369007a 	cmnvc	r9, #122	; 0x7a
    2778:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    277c:	6f6e5f74 	svcvs	0x006e5f74
    2780:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2784:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2788:	615f7469 	cmpvs	pc, r9, ror #8
    278c:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    2790:	61736900 	cmnvs	r3, r0, lsl #18
    2794:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2798:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    279c:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    27a0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27a4:	615f7469 	cmpvs	pc, r9, ror #8
    27a8:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    27ac:	61736900 	cmnvs	r3, r0, lsl #18
    27b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27b8:	5f003876 	svcpl	0x00003876
    27bc:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    27c0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    27c4:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    27c8:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    27cc:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    27d0:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    27d4:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    27d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27dc:	615f7469 	cmpvs	pc, r9, ror #8
    27e0:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    27e4:	61006574 	tstvs	r0, r4, ror r5
    27e8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 27f0 <shift+0x27f0>
    27ec:	00656e75 	rsbeq	r6, r5, r5, ror lr
    27f0:	5f6d7261 	svcpl	0x006d7261
    27f4:	5f707063 	svcpl	0x00707063
    27f8:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    27fc:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    2800:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    2804:	705f636e 	subsvc	r6, pc, lr, ror #6
    2808:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    280c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2810:	50435f54 	subpl	r5, r3, r4, asr pc
    2814:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2818:	3032396d 	eorscc	r3, r2, sp, ror #18
    281c:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    2820:	655f6261 	ldrbvs	r6, [pc, #-609]	; 25c7 <shift+0x25c7>
    2824:	41540071 	cmpmi	r4, r1, ror r0
    2828:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    282c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2830:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    2834:	61003632 	tstvs	r0, r2, lsr r6
    2838:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    283c:	5f686372 	svcpl	0x00686372
    2840:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2844:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2848:	00766964 	rsbseq	r6, r6, r4, ror #18
    284c:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2850:	5f71655f 	svcpl	0x0071655f
    2854:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2858:	00726574 	rsbseq	r6, r2, r4, ror r5
    285c:	5f6d7261 	svcpl	0x006d7261
    2860:	5f636970 	svcpl	0x00636970
    2864:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2868:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    286c:	52415400 	subpl	r5, r1, #0, 8
    2870:	5f544547 	svcpl	0x00544547
    2874:	5f555043 	svcpl	0x00555043
    2878:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    287c:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2880:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2884:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2888:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    288c:	41540079 	cmpmi	r4, r9, ror r0
    2890:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2894:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2898:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    289c:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    28a0:	7066766f 	rsbvc	r7, r6, pc, ror #12
    28a4:	61736900 	cmnvs	r3, r0, lsl #18
    28a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    28ac:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    28b0:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    28b4:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    28b8:	00647264 	rsbeq	r7, r4, r4, ror #4
    28bc:	5f4d5241 	svcpl	0x004d5241
    28c0:	61004343 	tstvs	r0, r3, asr #6
    28c4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    28c8:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    28cc:	6100325f 	tstvs	r0, pc, asr r2
    28d0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    28d4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    28d8:	6100335f 	tstvs	r0, pc, asr r3
    28dc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    28e0:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    28e4:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    28e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28ec:	50435f54 	subpl	r5, r3, r4, asr pc
    28f0:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    28f4:	36323670 			; <UNDEFINED> instruction: 0x36323670
    28f8:	4d524100 	ldfmie	f4, [r2, #-0]
    28fc:	0053435f 	subseq	r4, r3, pc, asr r3
    2900:	5f6d7261 	svcpl	0x006d7261
    2904:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2908:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    290c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2910:	61625f6d 	cmnvs	r2, sp, ror #30
    2914:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2918:	00686372 	rsbeq	r6, r8, r2, ror r3
    291c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2920:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2924:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2928:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    292c:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    2930:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2934:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2938:	6d726100 	ldfvse	f6, [r2, #-0]
    293c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2940:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2944:	52415400 	subpl	r5, r1, #0, 8
    2948:	5f544547 	svcpl	0x00544547
    294c:	5f555043 	svcpl	0x00555043
    2950:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2954:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2958:	72610032 	rsbvc	r0, r1, #50	; 0x32
    295c:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    2960:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2964:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    2968:	52410074 	subpl	r0, r1, #116	; 0x74
    296c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2970:	41415f53 	cmpmi	r1, r3, asr pc
    2974:	5f534350 	svcpl	0x00534350
    2978:	41434f4c 	cmpmi	r3, ip, asr #30
    297c:	4154004c 	cmpmi	r4, ip, asr #32
    2980:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2984:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2988:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    298c:	61786574 	cmnvs	r8, r4, ror r5
    2990:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    2994:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2998:	50435f54 	subpl	r5, r3, r4, asr pc
    299c:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    29a0:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    29a4:	006d7261 	rsbeq	r7, sp, r1, ror #4
    29a8:	5f6d7261 	svcpl	0x006d7261
    29ac:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29b0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29b4:	0031626d 	eorseq	r6, r1, sp, ror #4
    29b8:	5f6d7261 	svcpl	0x006d7261
    29bc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29c0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29c4:	0032626d 	eorseq	r6, r2, sp, ror #4
    29c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29d0:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    29d4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    29d8:	72610074 	rsbvc	r0, r1, #116	; 0x74
    29dc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29e0:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    29e4:	61736900 	cmnvs	r3, r0, lsl #18
    29e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    29ec:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    29f0:	5f6d7261 	svcpl	0x006d7261
    29f4:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    29f8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    29fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2a00:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2a04:	315f3868 	cmpcc	pc, r8, ror #16
	...

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9ef8>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346df8>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9f18>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9248>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9f48>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346e48>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9f68>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346e68>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9f88>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346e88>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9fa8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346ea8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9fc8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346ec8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9fe8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346ee8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa008>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346f08>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa020>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa040>
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
 194:	000000dc 	ldrdeq	r0, [r0], -ip
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa070>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008308 	andeq	r8, r0, r8, lsl #6
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa09c>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346f9c>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008334 	andeq	r8, r0, r4, lsr r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa0bc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346fbc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008360 	andeq	r8, r0, r0, ror #6
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa0dc>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346fdc>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	0000837c 	andeq	r8, r0, ip, ror r3
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa0fc>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346ffc>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083c0 	andeq	r8, r0, r0, asr #7
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa11c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x34701c>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008410 	andeq	r8, r0, r0, lsl r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa13c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x34703c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008460 	andeq	r8, r0, r0, ror #8
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa15c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x34705c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	0000848c 	andeq	r8, r0, ip, lsl #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa17c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x34707c>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084dc 	ldrdeq	r8, [r0], -ip
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa19c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x34709c>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008520 	andeq	r8, r0, r0, lsr #10
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa1bc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x3470bc>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008570 	andeq	r8, r0, r0, ror r5
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa1dc>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3470dc>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085c4 	andeq	r8, r0, r4, asr #11
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa1fc>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3470fc>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008600 	andeq	r8, r0, r0, lsl #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa21c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x34711c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000863c 	andeq	r8, r0, ip, lsr r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa23c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x34713c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008678 	andeq	r8, r0, r8, ror r6
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa25c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x34715c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa27c>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008764 	andeq	r8, r0, r4, ror #14
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa2ac>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa2cc>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3471cc>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008974 	andeq	r8, r0, r4, ror r9
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa2ec>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3471ec>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a34 	andeq	r8, r0, r4, lsr sl
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa30c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x34720c>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ae0 	andeq	r8, r0, r0, ror #21
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa32c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x34722c>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b34 	andeq	r8, r0, r4, lsr fp
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa34c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x34724c>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b9c 	muleq	r0, ip, fp
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa36c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x34726c>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008c1c 	andeq	r8, r0, ip, lsl ip
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa38c>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x34728c>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008c88 	andeq	r8, r0, r8, lsl #25
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa3ac>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008d4c 	andeq	r8, r0, ip, asr #26
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa3cc>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3472cc>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	0000918c 	andeq	r9, r0, ip, lsl #3
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa3f0>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009260 	andeq	r9, r0, r0, ror #4
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa410>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x347310>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	0000929c 	muleq	r0, ip, r2
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa430>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x347330>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	000092dc 	ldrdeq	r9, [r0], -ip
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa450>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	0000930c 	andeq	r9, r0, ip, lsl #6
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa470>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	00009630 	andeq	r9, r0, r0, lsr r6
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa494>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x347394>
 5c4:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 5c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 5cc:	0000000c 	andeq	r0, r0, ip
 5d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5d4:	7c010001 	stcvc	0, cr0, [r1], {1}
 5d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	000005cc 	andeq	r0, r0, ip, asr #11
 5e4:	00009740 	andeq	r9, r0, r0, asr #14
 5e8:	000001ec 	andeq	r0, r0, ip, ror #3
