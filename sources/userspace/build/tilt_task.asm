
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
    805c:	00009a48 	andeq	r9, r0, r8, asr #20
    8060:	00009a58 	andeq	r9, r0, r8, asr sl

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
    81cc:	00009a45 	andeq	r9, r0, r5, asr #20
    81d0:	00009a45 	andeq	r9, r0, r5, asr #20

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
    8224:	00009a45 	andeq	r9, r0, r5, asr #20
    8228:	00009a45 	andeq	r9, r0, r5, asr #20

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
    82f8:	000099c0 	andeq	r9, r0, r0, asr #19
    82fc:	000099cc 	andeq	r9, r0, ip, asr #19
    8300:	000099d0 	ldrdeq	r9, [r0], -r0
    8304:	000099d8 	ldrdeq	r9, [r0], -r8

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
    8760:	00009a24 	andeq	r9, r0, r4, lsr #20

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
    88d4:	00009a34 	andeq	r9, r0, r4, lsr sl

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
    9148:	0a4fb11f 	beq	13f55cc <__bss_end+0x13ebb74>
    914c:	5a0e1bca 	bpl	39007c <__bss_end+0x386624>
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
    9180:	3a83126f 	bcc	fe0cdb44 <__bss_end+0xfe0c40ec>
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

00009954 <_ZL9INT32_MAX>:
    9954:	7fffffff 	svcvc	0x00ffffff

00009958 <_ZL9INT32_MIN>:
    9958:	80000000 	andhi	r0, r0, r0

0000995c <_ZL10UINT32_MAX>:
    995c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009960 <_ZL10UINT32_MIN>:
    9960:	00000000 	andeq	r0, r0, r0

00009964 <_ZL13Lock_Unlocked>:
    9964:	00000000 	andeq	r0, r0, r0

00009968 <_ZL11Lock_Locked>:
    9968:	00000001 	andeq	r0, r0, r1

0000996c <_ZL21MaxFSDriverNameLength>:
    996c:	00000010 	andeq	r0, r0, r0, lsl r0

00009970 <_ZL17MaxFilenameLength>:
    9970:	00000010 	andeq	r0, r0, r0, lsl r0

00009974 <_ZL13MaxPathLength>:
    9974:	00000080 	andeq	r0, r0, r0, lsl #1

00009978 <_ZL18NoFilesystemDriver>:
    9978:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000997c <_ZL9NotifyAll>:
    997c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009980 <_ZL24Max_Process_Opened_Files>:
    9980:	00000010 	andeq	r0, r0, r0, lsl r0

00009984 <_ZL10Indefinite>:
    9984:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009988 <_ZL18Deadline_Unchanged>:
    9988:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000998c <_ZL14Invalid_Handle>:
    998c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009990 <_ZN3halL18Default_Clock_RateE>:
    9990:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009994 <_ZN3halL15Peripheral_BaseE>:
    9994:	20000000 	andcs	r0, r0, r0

00009998 <_ZN3halL9GPIO_BaseE>:
    9998:	20200000 	eorcs	r0, r0, r0

0000999c <_ZN3halL14GPIO_Pin_CountE>:
    999c:	00000036 	andeq	r0, r0, r6, lsr r0

000099a0 <_ZN3halL8AUX_BaseE>:
    99a0:	20215000 	eorcs	r5, r1, r0

000099a4 <_ZN3halL25Interrupt_Controller_BaseE>:
    99a4:	2000b200 	andcs	fp, r0, r0, lsl #4

000099a8 <_ZN3halL10Timer_BaseE>:
    99a8:	2000b400 	andcs	fp, r0, r0, lsl #8

000099ac <_ZN3halL9TRNG_BaseE>:
    99ac:	20104000 	andscs	r4, r0, r0

000099b0 <_ZN3halL9BSC0_BaseE>:
    99b0:	20205000 	eorcs	r5, r0, r0

000099b4 <_ZN3halL9BSC1_BaseE>:
    99b4:	20804000 	addcs	r4, r0, r0

000099b8 <_ZN3halL9BSC2_BaseE>:
    99b8:	20805000 	addcs	r5, r0, r0

000099bc <_ZL11Invalid_Pin>:
    99bc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    99c0:	3a564544 	bcc	159aed8 <__bss_end+0x1591480>
    99c4:	6f697067 	svcvs	0x00697067
    99c8:	0033322f 	eorseq	r3, r3, pc, lsr #4
    99cc:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    99d0:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    99d4:	00505520 	subseq	r5, r0, r0, lsr #10
    99d8:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    99dc:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    99e0:	0000004e 	andeq	r0, r0, lr, asr #32

000099e4 <_ZL9INT32_MAX>:
    99e4:	7fffffff 	svcvc	0x00ffffff

000099e8 <_ZL9INT32_MIN>:
    99e8:	80000000 	andhi	r0, r0, r0

000099ec <_ZL10UINT32_MAX>:
    99ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000099f0 <_ZL10UINT32_MIN>:
    99f0:	00000000 	andeq	r0, r0, r0

000099f4 <_ZL13Lock_Unlocked>:
    99f4:	00000000 	andeq	r0, r0, r0

000099f8 <_ZL11Lock_Locked>:
    99f8:	00000001 	andeq	r0, r0, r1

000099fc <_ZL21MaxFSDriverNameLength>:
    99fc:	00000010 	andeq	r0, r0, r0, lsl r0

00009a00 <_ZL17MaxFilenameLength>:
    9a00:	00000010 	andeq	r0, r0, r0, lsl r0

00009a04 <_ZL13MaxPathLength>:
    9a04:	00000080 	andeq	r0, r0, r0, lsl #1

00009a08 <_ZL18NoFilesystemDriver>:
    9a08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a0c <_ZL9NotifyAll>:
    9a0c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a10 <_ZL24Max_Process_Opened_Files>:
    9a10:	00000010 	andeq	r0, r0, r0, lsl r0

00009a14 <_ZL10Indefinite>:
    9a14:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a18 <_ZL18Deadline_Unchanged>:
    9a18:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a1c <_ZL14Invalid_Handle>:
    9a1c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a20 <_ZL8INFINITY>:
    9a20:	7f7fffff 	svcvc	0x007fffff

00009a24 <_ZL16Pipe_File_Prefix>:
    9a24:	3a535953 	bcc	14dff78 <__bss_end+0x14d6520>
    9a28:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9a2c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009a30 <_ZL8INFINITY>:
    9a30:	7f7fffff 	svcvc	0x007fffff

00009a34 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9a34:	33323130 	teqcc	r2, #48, 2
    9a38:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9a3c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9a40:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009a48 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683dd4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x389cc>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c5e0>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c72cc>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfbe4>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36eae>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff6377>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x157340>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7748>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x7777c>
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
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfd5c>
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
 248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff6493>
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
 294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff64df>
 298:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 29c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2a0:	2f2e2e2f 	svccs	0x002e2e2f
 2a4:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 2a8:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
 2ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2b0:	2f006564 	svccs	0x00006564
 2b4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2b8:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 2bc:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 2c0:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 2c4:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 2c8:	2f70732f 	svccs	0x0070732f
 2cc:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2d0:	2f736563 	svccs	0x00736563
 2d4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d8:	63617073 	cmnvs	r1, #115	; 0x73
 2dc:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2e0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2e4:	2f6c656e 	svccs	0x006c656e
 2e8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2ec:	2f656475 	svccs	0x00656475
 2f0:	636f7270 	cmnvs	pc, #112, 4
 2f4:	00737365 	rsbseq	r7, r3, r5, ror #6
 2f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 244 <shift+0x244>
 2fc:	616a2f65 	cmnvs	sl, r5, ror #30
 300:	6173656d 	cmnvs	r3, sp, ror #10
 304:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 308:	6f2f7469 	svcvs	0x002f7469
 30c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 310:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff6591>
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
 388:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 38c:	66656474 			; <UNDEFINED> instruction: 0x66656474
 390:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 394:	74730000 	ldrbtvc	r0, [r3], #-0
 398:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 39c:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 3a0:	00030068 	andeq	r0, r3, r8, rrx
 3a4:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 3a8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 3ac:	70730000 	rsbsvc	r0, r3, r0
 3b0:	6f6c6e69 	svcvs	0x006c6e69
 3b4:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3b8:	00000400 	andeq	r0, r0, r0, lsl #8
 3bc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3c0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3c4:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3c8:	00000500 	andeq	r0, r0, r0, lsl #10
 3cc:	636f7270 	cmnvs	pc, #112, 4
 3d0:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3d4:	00040068 	andeq	r0, r4, r8, rrx
 3d8:	6f727000 	svcvs	0x00727000
 3dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3e0:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3e4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3e8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 3ec:	65700000 	ldrbvs	r0, [r0, #-0]!
 3f0:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 3f4:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 3f8:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3fc:	67000002 	strvs	r0, [r0, -r2]
 400:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 404:	00060068 	andeq	r0, r6, r8, rrx
 408:	01050000 	mrseq	r0, (UNDEF: 5)
 40c:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
 410:	03000082 	movweq	r0, #130	; 0x82
 414:	0705010e 	streq	r0, [r5, -lr, lsl #2]
 418:	21054b9f 			; <UNDEFINED> instruction: 0x21054b9f
 41c:	8a09054c 	bhi	241954 <__bss_end+0x237efc>
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
 4b8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 4bc:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 4c0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 4c4:	61682f30 	cmnvs	r8, r0, lsr pc
 4c8:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 4cc:	2f656d6f 	svccs	0x00656d6f
 4d0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 4d4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 4d8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 4dc:	2f736f2f 	svccs	0x00736f2f
 4e0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 4e4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 4e8:	6b2f7365 	blvs	bdd284 <__bss_end+0xbd382c>
 4ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 4f0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 4f4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 4f8:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 4fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 500:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 504:	2f656d6f 	svccs	0x00656d6f
 508:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 50c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 510:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 514:	2f736f2f 	svccs	0x00736f2f
 518:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 51c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 520:	6b2f7365 	blvs	bdd2bc <__bss_end+0xbd3864>
 524:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 528:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 52c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 530:	73662f65 	cmnvc	r6, #404	; 0x194
 534:	6f682f00 	svcvs	0x00682f00
 538:	6a2f656d 	bvs	bd9af4 <__bss_end+0xbd009c>
 53c:	73656d61 	cmnvc	r5, #6208	; 0x1840
 540:	2f697261 	svccs	0x00697261
 544:	2f746967 	svccs	0x00746967
 548:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 54c:	6f732f70 	svcvs	0x00732f70
 550:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 554:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 558:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 55c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 560:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 564:	74730000 	ldrbtvc	r0, [r3], #-0
 568:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 56c:	70632e65 	rsbvc	r2, r3, r5, ror #28
 570:	00010070 	andeq	r0, r1, r0, ror r0
 574:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 578:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 57c:	00020068 	andeq	r0, r2, r8, rrx
 580:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 584:	0300682e 	movweq	r6, #2094	; 0x82e
 588:	70730000 	rsbsvc	r0, r3, r0
 58c:	6f6c6e69 	svcvs	0x006c6e69
 590:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 594:	00000300 	andeq	r0, r0, r0, lsl #6
 598:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 59c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 5a0:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 5a4:	00000400 	andeq	r0, r0, r0, lsl #8
 5a8:	636f7270 	cmnvs	pc, #112, 4
 5ac:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 5b0:	00030068 	andeq	r0, r3, r8, rrx
 5b4:	6f727000 	svcvs	0x00727000
 5b8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 5bc:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 5c0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 5c4:	0300682e 	movweq	r6, #2094	; 0x82e
 5c8:	74730000 	ldrbtvc	r0, [r3], #-0
 5cc:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 5d0:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
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
 604:	4b2e05a1 	blmi	b81c90 <__bss_end+0xb78238>
 608:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 60c:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 610:	2f01054c 	svccs	0x0001054c
 614:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 618:	054b3005 	strbeq	r3, [fp, #-5]
 61c:	1b054b2e 	blne	1532dc <__bss_end+0x149884>
 620:	2f2e054b 	svccs	0x002e054b
 624:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 628:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 62c:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 630:	4b2e054b 	blmi	b81b64 <__bss_end+0xb7810c>
 634:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 638:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 63c:	2f01054c 	svccs	0x0001054c
 640:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 644:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 648:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 64c:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 650:	4b2f054b 	blmi	bc1b84 <__bss_end+0xbb812c>
 654:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 658:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 65c:	2f01054c 	svccs	0x0001054c
 660:	a12e0585 	smlawbge	lr, r5, r5, r0
 664:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 668:	2f054b1b 	svccs	0x00054b1b
 66c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 670:	852f0105 	strhi	r0, [pc, #-261]!	; 573 <shift+0x573>
 674:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 678:	3b054b2f 	blcc	15333c <__bss_end+0x1498e4>
 67c:	4b1b054b 	blmi	6c1bb0 <__bss_end+0x6b8158>
 680:	052f3005 	streq	r3, [pc, #-5]!	; 683 <shift+0x683>
 684:	01054c0c 	tsteq	r5, ip, lsl #24
 688:	2f05852f 	svccs	0x0005852f
 68c:	4b3b05a1 	blmi	ec1d18 <__bss_end+0xeb82c0>
 690:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 694:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 698:	9f01054c 	svcls	0x0001054c
 69c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6a0:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 6a4:	1a054b31 	bne	153370 <__bss_end+0x149918>
 6a8:	300c054b 	andcc	r0, ip, fp, asr #10
 6ac:	852f0105 	strhi	r0, [pc, #-261]!	; 5af <shift+0x5af>
 6b0:	05672005 	strbeq	r2, [r7, #-5]!
 6b4:	31054d2d 	tstcc	r5, sp, lsr #26
 6b8:	4b1a054b 	blmi	681bec <__bss_end+0x678194>
 6bc:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6c0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c4:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 6c8:	4b3e054c 	blmi	f81c00 <__bss_end+0xf781a8>
 6cc:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 6d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6d4:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 6d8:	4b30054d 	blmi	c01c14 <__bss_end+0xbf81bc>
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
 710:	fb010200 	blx	40f1a <__bss_end+0x374c2>
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
 7b4:	0b05ba0a 	bleq	16efe4 <__bss_end+0x16558c>
 7b8:	4a27052e 	bmi	9c1c78 <__bss_end+0x9b8220>
 7bc:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 7c0:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 7c4:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 7c8:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 7cc:	11056810 	tstne	r5, r0, lsl r8
 7d0:	4a22052e 	bmi	881c90 <__bss_end+0x878238>
 7d4:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 7d8:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 7dc:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 7e0:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 7e4:	0b054b03 	bleq	1533f8 <__bss_end+0x1499a0>
 7e8:	00180568 	andseq	r0, r8, r8, ror #10
 7ec:	4a030402 	bmi	c17fc <__bss_end+0xb7da4>
 7f0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 7f4:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 7f8:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 7fc:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 800:	02040200 	andeq	r0, r4, #0, 4
 804:	00080582 	andeq	r0, r8, r2, lsl #11
 808:	4a020402 	bmi	81818 <__bss_end+0x77dc0>
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
 834:	0a052e02 	beq	14c044 <__bss_end+0x1425ec>
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
 864:	4a0305bb 	bmi	c1f58 <__bss_end+0xb8500>
 868:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 86c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 870:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 874:	0d054a01 	vstreq	s8, [r5, #-4]
 878:	4a14054d 	bmi	501db4 <__bss_end+0x4f835c>
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
 8c0:	4a030402 	bmi	c18d0 <__bss_end+0xb7e78>
 8c4:	02000905 	andeq	r0, r0, #81920	; 0x14000
 8c8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 8cc:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 8d0:	0b054a03 	bleq	1530e4 <__bss_end+0x14968c>
 8d4:	03040200 	movweq	r0, #16896	; 0x4200
 8d8:	0002052e 	andeq	r0, r2, lr, lsr #10
 8dc:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 8e0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 8e4:	05840204 	streq	r0, [r4, #516]	; 0x204
 8e8:	04020008 	streq	r0, [r2], #-8
 8ec:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 8f0:	01040200 	mrseq	r0, R12_usr
 8f4:	000b052e 	andeq	r0, fp, lr, lsr #10
 8f8:	4a010402 	bmi	41908 <__bss_end+0x37eb0>
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
 94c:	0b059f08 	bleq	168574 <__bss_end+0x15eb1c>
 950:	0014054c 	andseq	r0, r4, ip, asr #10
 954:	4a030402 	bmi	c1964 <__bss_end+0xb7f0c>
 958:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 95c:	05830204 	streq	r0, [r3, #516]	; 0x204
 960:	04020008 	streq	r0, [r2], #-8
 964:	0a052e02 	beq	14c174 <__bss_end+0x14271c>
 968:	02040200 	andeq	r0, r4, #0, 4
 96c:	0002054a 	andeq	r0, r2, sl, asr #10
 970:	49020402 	stmdbmi	r2, {r1, sl}
 974:	85840105 	strhi	r0, [r4, #261]	; 0x105
 978:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 97c:	0b054b08 	bleq	1535a4 <__bss_end+0x149b4c>
 980:	0014054c 	andseq	r0, r4, ip, asr #10
 984:	4a030402 	bmi	c1994 <__bss_end+0xb7f3c>
 988:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 98c:	05830204 	streq	r0, [r3, #516]	; 0x204
 990:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 994:	0a052e02 	beq	14c1a4 <__bss_end+0x14274c>
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
 9c8:	0b054a03 	bleq	1531dc <__bss_end+0x149784>
 9cc:	02040200 	andeq	r0, r4, #0, 4
 9d0:	00050583 	andeq	r0, r5, r3, lsl #11
 9d4:	81020402 	tsthi	r2, r2, lsl #8
 9d8:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 9dc:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 9e0:	0c058411 	cfstrseq	mvf8, [r5], {17}
 9e4:	00180568 	andseq	r0, r8, r8, ror #10
 9e8:	4a030402 	bmi	c19f8 <__bss_end+0xb7fa0>
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
 a78:	1a059f09 	bne	1686a4 <__bss_end+0x15ec4c>
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
 ae8:	1a059f09 	bne	168714 <__bss_end+0x15ecbc>
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
 b30:	4b1a0566 	blmi	6820d0 <__bss_end+0x678678>
 b34:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 b38:	0f05820b 	svceq	0x0005820b
 b3c:	660d0567 	strvs	r0, [sp], -r7, ror #10
 b40:	054b1905 	strbeq	r1, [fp, #-2309]	; 0xfffff6fb
 b44:	11054a12 	tstne	r5, r2, lsl sl
 b48:	4a05054a 	bmi	142078 <__bss_end+0x138620>
 b4c:	0b030105 	bleq	c0f68 <__bss_end+0xb7510>
 b50:	03090582 	movweq	r0, #38274	; 0x9582
 b54:	10052e76 	andne	r2, r5, r6, ror lr
 b58:	670c054a 	strvs	r0, [ip, -sl, asr #10]
 b5c:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 b60:	0d056715 	stceq	7, cr6, [r5, #-84]	; 0xffffffac
 b64:	4a150567 	bmi	542108 <__bss_end+0x5386b0>
 b68:	05671005 	strbeq	r1, [r7, #-5]!
 b6c:	1a054a0d 	bne	1533a8 <__bss_end+0x149950>
 b70:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 b74:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 b78:	2e026a01 	vmlacs.f32	s12, s4, s2
 b7c:	bb060515 	bllt	181fd8 <__bss_end+0x178580>
 b80:	054b1205 	strbeq	r1, [fp, #-517]	; 0xfffffdfb
 b84:	20056615 	andcs	r6, r5, r5, lsl r6
 b88:	082305bb 	stmdaeq	r3!, {r0, r1, r3, r4, r5, r7, r8, sl}
 b8c:	2e120520 	cfmul64cs	mvdx0, mvdx2, mvdx0
 b90:	05821405 	streq	r1, [r2, #1029]	; 0x405
 b94:	16054a23 	strne	r4, [r5], -r3, lsr #20
 b98:	2f0b054a 	svccs	0x000b054a
 b9c:	059c0505 	ldreq	r0, [ip, #1285]	; 0x505
 ba0:	0b053206 	bleq	14d3c0 <__bss_end+0x143968>
 ba4:	4a0d052e 	bmi	342064 <__bss_end+0x33860c>
 ba8:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 bac:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 bb0:	0105830e 	tsteq	r5, lr, lsl #6
 bb4:	0d0585d7 	cfstr32eq	mvfx8, [r5, #-860]	; 0xfffffca4
 bb8:	d7010583 	strle	r0, [r1, -r3, lsl #11]
 bbc:	9f0605a2 	svcls	0x000605a2
 bc0:	6a830105 	bvs	fe0c0fdc <__bss_end+0xfe0b7584>
 bc4:	05bb0f05 	ldreq	r0, [fp, #3845]!	; 0xf05
 bc8:	0c054b05 			; <UNDEFINED> instruction: 0x0c054b05
 bcc:	660e0584 	strvs	r0, [lr], -r4, lsl #11
 bd0:	054a1005 	strbeq	r1, [sl, #-5]
 bd4:	0d054b05 	vstreq	d4, [r5, #-20]	; 0xffffffec
 bd8:	66050568 	strvs	r0, [r5], -r8, ror #10
 bdc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 be0:	1005660e 	andne	r6, r5, lr, lsl #12
 be4:	4b0c054a 	blmi	302114 <__bss_end+0x2f86bc>
 be8:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 bec:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 bf0:	660e054b 	strvs	r0, [lr], -fp, asr #10
 bf4:	054a1005 	strbeq	r1, [sl, #-5]
 bf8:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 bfc:	4a100566 	bmi	40219c <__bss_end+0x3f8744>
 c00:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c04:	0505300d 	streq	r3, [r5, #-13]
 c08:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
 c0c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c10:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c14:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c18:	054a1005 	strbeq	r1, [sl, #-5]
 c1c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c20:	4a100566 	bmi	4021c0 <__bss_end+0x3f8768>
 c24:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c28:	1005660e 	andne	r6, r5, lr, lsl #12
 c2c:	4b03054a 	blmi	c215c <__bss_end+0xb8704>
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
 c8c:	1a054a10 	bne	1534d4 <__bss_end+0x149a7c>
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
 cc0:	2a020402 	bcs	81cd0 <__bss_end+0x78278>
 cc4:	05850505 	streq	r0, [r5, #1285]	; 0x505
 cc8:	0402000b 	streq	r0, [r2], #-11
 ccc:	0d053202 	sfmeq	f3, 4, [r5, #-8]
 cd0:	02040200 	andeq	r0, r4, #0, 4
 cd4:	4b010566 	blmi	42274 <__bss_end+0x3881c>
 cd8:	83090585 	movwhi	r0, #38277	; 0x9585
 cdc:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 ce0:	03054b07 	movweq	r4, #23303	; 0x5b07
 ce4:	4b06054a 	blmi	182214 <__bss_end+0x1787bc>
 ce8:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 cec:	1c054c0c 	stcne	12, cr4, [r5], {12}
 cf0:	01040200 	mrseq	r0, R12_usr
 cf4:	001d054a 	andseq	r0, sp, sl, asr #10
 cf8:	4a010402 	bmi	41d08 <__bss_end+0x382b0>
 cfc:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
 d00:	12054a05 	andne	r4, r5, #20480	; 0x5000
 d04:	01040200 	mrseq	r0, R12_usr
 d08:	0007054b 	andeq	r0, r7, fp, asr #10
 d0c:	4b010402 	blmi	41d1c <__bss_end+0x382c4>
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
 d38:	4a780302 	bmi	1e01948 <__bss_end+0x1df7ef0>
 d3c:	0b031005 	bleq	c4d58 <__bss_end+0xbb300>
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
 e1c:	0bb40300 	bleq	fed01a24 <__bss_end+0xfecf7fcc>
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
      58:	04dd0704 	ldrbeq	r0, [sp], #1796	; 0x704
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
     128:	000004dd 	ldrdeq	r0, [r0], -sp
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408728>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x3673c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a400>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x3680c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6a34>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000e88 	andeq	r0, r0, r8, lsl #29
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000cbc04 	andeq	fp, ip, r4, lsl #24
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0000dc00 	andeq	sp, r0, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	0c040200 	sfmeq	f0, 4, [r4], {-0}
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	50030500 	andpl	r0, r3, r0, lsl #10
     308:	03000099 	movweq	r0, #153	; 0x99
     30c:	1bef0404 	blne	ffbc1324 <__bss_end+0xffbb78cc>
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0d8e0801 	stceq	8, cr0, [lr, #4]
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0e020502 	cfsh32eq	mvfx0, mvfx2, #2
     328:	a7050000 	strge	r0, [r5, -r0]
     32c:	0200000e 	andeq	r0, r0, #14
     330:	00670705 	rsbeq	r0, r7, r5, lsl #14
     334:	56040000 	strpl	r0, [r4], -r0
     338:	06000000 	streq	r0, [r0], -r0
     33c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     340:	08030074 	stmdaeq	r3, {r2, r4, r5, r6}
     344:	00031f05 	andeq	r1, r3, r5, lsl #30
     348:	08010300 	stmdaeq	r1, {r8, r9}
     34c:	00000d85 	andeq	r0, r0, r5, lsl #27
     350:	b7070203 	strlt	r0, [r7, -r3, lsl #4]
     354:	05000009 	streq	r0, [r0, #-9]
     358:	00000ea6 	andeq	r0, r0, r6, lsr #29
     35c:	94070a02 	strls	r0, [r7], #-2562	; 0xfffff5fe
     360:	04000000 	streq	r0, [r0], #-0
     364:	00000083 	andeq	r0, r0, r3, lsl #1
     368:	dd070403 	cfstrsle	mvf0, [r7, #-12]
     36c:	04000004 	streq	r0, [r0], #-4
     370:	00000094 	muleq	r0, r4, r0
     374:	00009407 	andeq	r9, r0, r7, lsl #8
     378:	07080300 	streq	r0, [r8, -r0, lsl #6]
     37c:	000004d3 	ldrdeq	r0, [r0], -r3
     380:	0007e502 	andeq	lr, r7, r2, lsl #10
     384:	130d0200 	movwne	r0, #53760	; 0xd200
     388:	00000062 	andeq	r0, r0, r2, rrx
     38c:	99540305 	ldmdbls	r4, {r0, r2, r8, r9}^
     390:	a0020000 	andge	r0, r2, r0
     394:	02000008 	andeq	r0, r0, #8
     398:	0062130e 	rsbeq	r1, r2, lr, lsl #6
     39c:	03050000 	movweq	r0, #20480	; 0x5000
     3a0:	00009958 	andeq	r9, r0, r8, asr r9
     3a4:	0007e402 	andeq	lr, r7, r2, lsl #8
     3a8:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     3ac:	0000008f 	andeq	r0, r0, pc, lsl #1
     3b0:	995c0305 	ldmdbls	ip, {r0, r2, r8, r9}^
     3b4:	9f020000 	svcls	0x00020000
     3b8:	02000008 	andeq	r0, r0, #8
     3bc:	008f1411 	addeq	r1, pc, r1, lsl r4	; <UNPREDICTABLE>
     3c0:	03050000 	movweq	r0, #20480	; 0x5000
     3c4:	00009960 	andeq	r9, r0, r0, ror #18
     3c8:	00072a08 	andeq	r2, r7, r8, lsl #20
     3cc:	06040800 	streq	r0, [r4], -r0, lsl #16
     3d0:	00011a08 	andeq	r1, r1, r8, lsl #20
     3d4:	30720900 	rsbscc	r0, r2, r0, lsl #18
     3d8:	0e080400 	cfcpyseq	mvf0, mvf8
     3dc:	00000083 	andeq	r0, r0, r3, lsl #1
     3e0:	31720900 	cmncc	r2, r0, lsl #18
     3e4:	0e090400 	cfcpyseq	mvf0, mvf9
     3e8:	00000083 	andeq	r0, r0, r3, lsl #1
     3ec:	880a0004 	stmdahi	sl, {r2}
     3f0:	05000005 	streq	r0, [r0, #-5]
     3f4:	00006704 	andeq	r6, r0, r4, lsl #14
     3f8:	0c1e0400 	cfldrseq	mvf0, [lr], {-0}
     3fc:	00000151 	andeq	r0, r0, r1, asr r1
     400:	0012810b 	andseq	r8, r2, fp, lsl #2
     404:	bf0b0000 	svclt	0x000b0000
     408:	01000012 	tsteq	r0, r2, lsl r0
     40c:	0012890b 	andseq	r8, r2, fp, lsl #18
     410:	590b0200 	stmdbpl	fp, {r9}
     414:	0300000a 	movweq	r0, #10
     418:	000cad0b 	andeq	sl, ip, fp, lsl #26
     41c:	ad0b0400 	cfstrsge	mvf0, [fp, #-0]
     420:	05000007 	streq	r0, [r0, #-7]
     424:	11830a00 	orrne	r0, r3, r0, lsl #20
     428:	04050000 	streq	r0, [r5], #-0
     42c:	00000067 	andeq	r0, r0, r7, rrx
     430:	8e0c4404 	cdphi	4, 0, cr4, cr12, cr4, {0}
     434:	0b000001 	bleq	440 <shift+0x440>
     438:	0000041b 	andeq	r0, r0, fp, lsl r4
     43c:	05c40b00 	strbeq	r0, [r4, #2816]	; 0xb00
     440:	0b010000 	bleq	40448 <__bss_end+0x369f0>
     444:	00000c68 	andeq	r0, r0, r8, ror #24
     448:	12370b02 	eorsne	r0, r7, #2048	; 0x800
     44c:	0b030000 	bleq	c0454 <__bss_end+0xb69fc>
     450:	000012c9 	andeq	r1, r0, r9, asr #5
     454:	0b790b04 	bleq	1e4306c <__bss_end+0x1e39614>
     458:	0b050000 	bleq	140460 <__bss_end+0x136a08>
     45c:	000009d7 	ldrdeq	r0, [r0], -r7
     460:	3d0a0006 	stccc	0, cr0, [sl, #-24]	; 0xffffffe8
     464:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     468:	00006704 	andeq	r6, r0, r4, lsl #14
     46c:	0c6b0400 	cfstrdeq	mvd0, [fp], #-0
     470:	000001b9 			; <UNDEFINED> instruction: 0x000001b9
     474:	000d630b 	andeq	r6, sp, fp, lsl #6
     478:	990b0000 	stmdbls	fp, {}	; <UNPREDICTABLE>
     47c:	01000009 	tsteq	r0, r9
     480:	000e0c0b 	andeq	r0, lr, fp, lsl #24
     484:	dc0b0200 	sfmle	f0, 4, [fp], {-0}
     488:	03000009 	movweq	r0, #9
     48c:	06210500 	strteq	r0, [r1], -r0, lsl #10
     490:	03050000 	movweq	r0, #20480	; 0x5000
     494:	00006707 	andeq	r6, r0, r7, lsl #14
     498:	0bd10200 	bleq	ff440ca0 <__bss_end+0xff437248>
     49c:	05050000 	streq	r0, [r5, #-0]
     4a0:	00008f14 	andeq	r8, r0, r4, lsl pc
     4a4:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     4a8:	02000099 	andeq	r0, r0, #153	; 0x99
     4ac:	00000c20 	andeq	r0, r0, r0, lsr #24
     4b0:	8f140605 	svchi	0x00140605
     4b4:	05000000 	streq	r0, [r0, #-0]
     4b8:	00996803 	addseq	r6, r9, r3, lsl #16
     4bc:	0b630200 	bleq	18c0cc4 <__bss_end+0x18b726c>
     4c0:	07060000 	streq	r0, [r6, -r0]
     4c4:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4c8:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     4cc:	02000099 	andeq	r0, r0, #153	; 0x99
     4d0:	000005f3 	strdeq	r0, [r0], -r3
     4d4:	8f1a0906 	svchi	0x001a0906
     4d8:	05000000 	streq	r0, [r0, #-0]
     4dc:	00997003 	addseq	r7, r9, r3
     4e0:	0d770200 	lfmeq	f0, 2, [r7, #-0]
     4e4:	0b060000 	bleq	1804ec <__bss_end+0x176a94>
     4e8:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4ec:	74030500 	strvc	r0, [r3], #-1280	; 0xfffffb00
     4f0:	02000099 	andeq	r0, r0, #153	; 0x99
     4f4:	00000986 	andeq	r0, r0, r6, lsl #19
     4f8:	8f1a0d06 	svchi	0x001a0d06
     4fc:	05000000 	streq	r0, [r0, #-0]
     500:	00997803 	addseq	r7, r9, r3, lsl #16
     504:	07550200 	ldrbeq	r0, [r5, -r0, lsl #4]
     508:	0f060000 	svceq	0x00060000
     50c:	00008f1a 	andeq	r8, r0, sl, lsl pc
     510:	7c030500 	cfstr32vc	mvfx0, [r3], {-0}
     514:	0a000099 	beq	780 <shift+0x780>
     518:	00000f06 	andeq	r0, r0, r6, lsl #30
     51c:	00670405 	rsbeq	r0, r7, r5, lsl #8
     520:	1b060000 	blne	180528 <__bss_end+0x176ad0>
     524:	0002680c 	andeq	r6, r2, ip, lsl #16
     528:	0f720b00 	svceq	0x00720b00
     52c:	0b000000 	bleq	534 <shift+0x534>
     530:	00001276 	andeq	r1, r0, r6, ror r2
     534:	0c630b01 			; <UNDEFINED> instruction: 0x0c630b01
     538:	00020000 	andeq	r0, r2, r0
     53c:	000d480c 	andeq	r4, sp, ip, lsl #16
     540:	0de70d00 	stcleq	13, cr0, [r7]
     544:	06900000 	ldreq	r0, [r0], r0
     548:	03db0763 	bicseq	r0, fp, #25952256	; 0x18c0000
     54c:	d9080000 	stmdble	r8, {}	; <UNPREDICTABLE>
     550:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
     554:	f5106706 			; <UNDEFINED> instruction: 0xf5106706
     558:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     55c:	0000217e 	andeq	r2, r0, lr, ror r1
     560:	db126906 	blle	49a980 <__bss_end+0x490f28>
     564:	00000003 	andeq	r0, r0, r3
     568:	00057c0e 	andeq	r7, r5, lr, lsl #24
     56c:	126b0600 	rsbne	r0, fp, #0, 12
     570:	000003eb 	andeq	r0, r0, fp, ror #7
     574:	0f670e10 	svceq	0x00670e10
     578:	6d060000 	stcvs	0, cr0, [r6, #-0]
     57c:	00008316 	andeq	r8, r0, r6, lsl r3
     580:	ec0e1400 	cfstrs	mvf1, [lr], {-0}
     584:	06000005 	streq	r0, [r0], -r5
     588:	03f21c70 	mvnseq	r1, #112, 24	; 0x7000
     58c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     590:	00000d6e 	andeq	r0, r0, lr, ror #26
     594:	f21c7206 	vhsub.s16	d7, d12, d6
     598:	1c000003 	stcne	0, cr0, [r0], {3}
     59c:	0005500e 	andeq	r5, r5, lr
     5a0:	1c750600 	ldclne	6, cr0, [r5], #-0
     5a4:	000003f2 	strdeq	r0, [r0], -r2
     5a8:	07f90f20 	ldrbeq	r0, [r9, r0, lsr #30]!
     5ac:	77060000 	strvc	r0, [r6, -r0]
     5b0:	0004671c 	andeq	r6, r4, ip, lsl r7
     5b4:	0003f200 	andeq	pc, r3, r0, lsl #4
     5b8:	0002e900 	andeq	lr, r2, r0, lsl #18
     5bc:	03f21000 	mvnseq	r1, #0
     5c0:	f8110000 			; <UNDEFINED> instruction: 0xf8110000
     5c4:	00000003 	andeq	r0, r0, r3
     5c8:	06650800 	strbteq	r0, [r5], -r0, lsl #16
     5cc:	06180000 	ldreq	r0, [r8], -r0
     5d0:	032a107b 			; <UNDEFINED> instruction: 0x032a107b
     5d4:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
     5d8:	06000021 	streq	r0, [r0], -r1, lsr #32
     5dc:	03db127e 	bicseq	r1, fp, #-536870905	; 0xe0000007
     5e0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     5e4:	00000571 	andeq	r0, r0, r1, ror r5
     5e8:	f8198006 			; <UNDEFINED> instruction: 0xf8198006
     5ec:	10000003 	andne	r0, r0, r3
     5f0:	00123d0e 	andseq	r3, r2, lr, lsl #26
     5f4:	21820600 	orrcs	r0, r2, r0, lsl #12
     5f8:	00000403 	andeq	r0, r0, r3, lsl #8
     5fc:	f5040014 			; <UNDEFINED> instruction: 0xf5040014
     600:	12000002 	andne	r0, r0, #2
     604:	00000b0d 	andeq	r0, r0, sp, lsl #22
     608:	09218606 	stmdbeq	r1!, {r1, r2, r9, sl, pc}
     60c:	12000004 	andne	r0, r0, #4
     610:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
     614:	8f1f8806 	svchi	0x001f8806
     618:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     61c:	00000e4a 	andeq	r0, r0, sl, asr #28
     620:	7a178b06 	bvc	5e3240 <__bss_end+0x5d97e8>
     624:	00000002 	andeq	r0, r0, r2
     628:	000a5f0e 	andeq	r5, sl, lr, lsl #30
     62c:	178e0600 	strne	r0, [lr, r0, lsl #12]
     630:	0000027a 	andeq	r0, r0, sl, ror r2
     634:	09240e24 	stmdbeq	r4!, {r2, r5, r9, sl, fp}
     638:	8f060000 	svchi	0x00060000
     63c:	00027a17 	andeq	r7, r2, r7, lsl sl
     640:	a90e4800 	stmdbge	lr, {fp, lr}
     644:	06000012 			; <UNDEFINED> instruction: 0x06000012
     648:	027a1790 	rsbseq	r1, sl, #144, 14	; 0x2400000
     64c:	136c0000 	cmnne	ip, #0
     650:	00000de7 	andeq	r0, r0, r7, ror #27
     654:	50099306 	andpl	r9, r9, r6, lsl #6
     658:	14000006 	strne	r0, [r0], #-6
     65c:	01000004 	tsteq	r0, r4
     660:	00000394 	muleq	r0, r4, r3
     664:	0000039a 	muleq	r0, sl, r3
     668:	00041410 	andeq	r1, r4, r0, lsl r4
     66c:	02140000 	andseq	r0, r4, #0
     670:	0600000b 	streq	r0, [r0], -fp
     674:	0a150e96 	beq	5440d4 <__bss_end+0x53a67c>
     678:	af010000 	svcge	0x00010000
     67c:	b5000003 	strlt	r0, [r0, #-3]
     680:	10000003 	andne	r0, r0, r3
     684:	00000414 	andeq	r0, r0, r4, lsl r4
     688:	041b1500 	ldreq	r1, [fp], #-1280	; 0xfffffb00
     68c:	99060000 	stmdbls	r6, {}	; <UNPREDICTABLE>
     690:	000eeb10 	andeq	lr, lr, r0, lsl fp
     694:	00041a00 	andeq	r1, r4, r0, lsl #20
     698:	03ca0100 	biceq	r0, sl, #0, 2
     69c:	14100000 	ldrne	r0, [r0], #-0
     6a0:	11000004 	tstne	r0, r4
     6a4:	000003f8 	strdeq	r0, [r0], -r8
     6a8:	00024311 	andeq	r4, r2, r1, lsl r3
     6ac:	16000000 	strne	r0, [r0], -r0
     6b0:	00000043 	andeq	r0, r0, r3, asr #32
     6b4:	000003eb 	andeq	r0, r0, fp, ror #7
     6b8:	00009417 	andeq	r9, r0, r7, lsl r4
     6bc:	03000f00 	movweq	r0, #3840	; 0xf00
     6c0:	0a690201 	beq	1a40ecc <__bss_end+0x1a37474>
     6c4:	04180000 	ldreq	r0, [r8], #-0
     6c8:	0000027a 	andeq	r0, r0, sl, ror r2
     6cc:	004a0418 	subeq	r0, sl, r8, lsl r4
     6d0:	490c0000 	stmdbmi	ip, {}	; <UNPREDICTABLE>
     6d4:	18000012 	stmdane	r0, {r1, r4}
     6d8:	0003fe04 	andeq	pc, r3, r4, lsl #28
     6dc:	032a1600 			; <UNDEFINED> instruction: 0x032a1600
     6e0:	04140000 	ldreq	r0, [r4], #-0
     6e4:	00190000 	andseq	r0, r9, r0
     6e8:	026d0418 	rsbeq	r0, sp, #24, 8	; 0x18000000
     6ec:	04180000 	ldreq	r0, [r8], #-0
     6f0:	00000268 	andeq	r0, r0, r8, ror #4
     6f4:	000e501a 	andeq	r5, lr, sl, lsl r0
     6f8:	149c0600 	ldrne	r0, [ip], #1536	; 0x600
     6fc:	0000026d 	andeq	r0, r0, sp, ror #4
     700:	00085a02 	andeq	r5, r8, r2, lsl #20
     704:	14040700 	strne	r0, [r4], #-1792	; 0xfffff900
     708:	0000008f 	andeq	r0, r0, pc, lsl #1
     70c:	99800305 	stmibls	r0, {r0, r2, r8, r9}
     710:	a6020000 	strge	r0, [r2], -r0
     714:	07000003 	streq	r0, [r0, -r3]
     718:	008f1407 	addeq	r1, pc, r7, lsl #8
     71c:	03050000 	movweq	r0, #20480	; 0x5000
     720:	00009984 	andeq	r9, r0, r4, lsl #19
     724:	00062c02 	andeq	r2, r6, r2, lsl #24
     728:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
     72c:	0000008f 	andeq	r0, r0, pc, lsl #1
     730:	99880305 	stmibls	r8, {r0, r2, r8, r9}
     734:	d20a0000 	andle	r0, sl, #0
     738:	0500000a 	streq	r0, [r0, #-10]
     73c:	00006704 	andeq	r6, r0, r4, lsl #14
     740:	0c0d0700 	stceq	7, cr0, [sp], {-0}
     744:	00000499 	muleq	r0, r9, r4
     748:	77654e1b 			; <UNDEFINED> instruction: 0x77654e1b
     74c:	c90b0000 	stmdbgt	fp, {}	; <UNPREDICTABLE>
     750:	0100000a 	tsteq	r0, sl
     754:	000e620b 	andeq	r6, lr, fp, lsl #4
     758:	840b0200 	strhi	r0, [fp], #-512	; 0xfffffe00
     75c:	0300000a 	movweq	r0, #10
     760:	000a4b0b 	andeq	r4, sl, fp, lsl #22
     764:	6e0b0400 	cfcpysvs	mvf0, mvf11
     768:	0500000c 	streq	r0, [r0, #-12]
     76c:	07a00800 	streq	r0, [r0, r0, lsl #16]!
     770:	07100000 	ldreq	r0, [r0, -r0]
     774:	04d8081b 	ldrbeq	r0, [r8], #2075	; 0x81b
     778:	6c090000 	stcvs	0, cr0, [r9], {-0}
     77c:	1d070072 	stcne	0, cr0, [r7, #-456]	; 0xfffffe38
     780:	0004d813 	andeq	sp, r4, r3, lsl r8
     784:	73090000 	movwvc	r0, #36864	; 0x9000
     788:	1e070070 	mcrne	0, 0, r0, cr7, cr0, {3}
     78c:	0004d813 	andeq	sp, r4, r3, lsl r8
     790:	70090400 	andvc	r0, r9, r0, lsl #8
     794:	1f070063 	svcne	0x00070063
     798:	0004d813 	andeq	sp, r4, r3, lsl r8
     79c:	b60e0800 	strlt	r0, [lr], -r0, lsl #16
     7a0:	07000007 	streq	r0, [r0, -r7]
     7a4:	04d81320 	ldrbeq	r1, [r8], #800	; 0x320
     7a8:	000c0000 	andeq	r0, ip, r0
     7ac:	d8070403 	stmdale	r7, {r0, r1, sl}
     7b0:	04000004 	streq	r0, [r0], #-4
     7b4:	000004d8 	ldrdeq	r0, [r0], -r8
     7b8:	00045a08 	andeq	r5, r4, r8, lsl #20
     7bc:	28077000 	stmdacs	r7, {ip, sp, lr}
     7c0:	00057408 	andeq	r7, r5, r8, lsl #8
     7c4:	12b30e00 	adcsne	r0, r3, #0, 28
     7c8:	2a070000 	bcs	1c07d0 <__bss_end+0x1b6d78>
     7cc:	00049912 	andeq	r9, r4, r2, lsl r9
     7d0:	70090000 	andvc	r0, r9, r0
     7d4:	07006469 	streq	r6, [r0, -r9, ror #8]
     7d8:	0094122b 	addseq	r1, r4, fp, lsr #4
     7dc:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     7e0:	00001b71 	andeq	r1, r0, r1, ror fp
     7e4:	62112c07 	andsvs	r2, r1, #1792	; 0x700
     7e8:	14000004 	strne	r0, [r0], #-4
     7ec:	000ade0e 	andeq	sp, sl, lr, lsl #28
     7f0:	122d0700 	eorne	r0, sp, #0, 14
     7f4:	00000094 	muleq	r0, r4, r0
     7f8:	0aec0e18 	beq	ffb04060 <__bss_end+0xffafa608>
     7fc:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
     800:	00009412 	andeq	r9, r0, r2, lsl r4
     804:	430e1c00 	movwmi	r1, #60416	; 0xec00
     808:	07000007 	streq	r0, [r0, -r7]
     80c:	05740c2f 	ldrbeq	r0, [r4, #-3119]!	; 0xfffff3d1
     810:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     814:	00000b19 	andeq	r0, r0, r9, lsl fp
     818:	67093007 	strvs	r3, [r9, -r7]
     81c:	60000000 	andvs	r0, r0, r0
     820:	000f910e 	andeq	r9, pc, lr, lsl #2
     824:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
     828:	00000083 	andeq	r0, r0, r3, lsl #1
     82c:	080d0e64 	stmdaeq	sp, {r2, r5, r6, r9, sl, fp}
     830:	33070000 	movwcc	r0, #28672	; 0x7000
     834:	0000830e 	andeq	r8, r0, lr, lsl #6
     838:	040e6800 	streq	r6, [lr], #-2048	; 0xfffff800
     83c:	07000008 	streq	r0, [r0, -r8]
     840:	00830e34 	addeq	r0, r3, r4, lsr lr
     844:	006c0000 	rsbeq	r0, ip, r0
     848:	00041a16 	andeq	r1, r4, r6, lsl sl
     84c:	00058400 	andeq	r8, r5, r0, lsl #8
     850:	00941700 	addseq	r1, r4, r0, lsl #14
     854:	000f0000 	andeq	r0, pc, r0
     858:	0011ca02 	andseq	ip, r1, r2, lsl #20
     85c:	140a0800 	strne	r0, [sl], #-2048	; 0xfffff800
     860:	0000008f 	andeq	r0, r0, pc, lsl #1
     864:	998c0305 	stmibls	ip, {r0, r2, r8, r9}
     868:	8c0a0000 	stchi	0, cr0, [sl], {-0}
     86c:	0500000a 	streq	r0, [r0, #-10]
     870:	00006704 	andeq	r6, r0, r4, lsl #14
     874:	0c0d0800 	stceq	8, cr0, [sp], {-0}
     878:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
     87c:	00059d0b 	andeq	r9, r5, fp, lsl #26
     880:	9b0b0000 	blls	2c0888 <__bss_end+0x2b6e30>
     884:	01000003 	tsteq	r0, r3
     888:	10850800 	addne	r0, r5, r0, lsl #16
     88c:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
     890:	05ea081b 	strbeq	r0, [sl, #2075]!	; 0x81b
     894:	2c0e0000 	stccs	0, cr0, [lr], {-0}
     898:	08000004 	stmdaeq	r0, {r2}
     89c:	05ea191d 	strbeq	r1, [sl, #2333]!	; 0x91d
     8a0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     8a4:	00000550 	andeq	r0, r0, r0, asr r5
     8a8:	ea191e08 	b	6480d0 <__bss_end+0x63e678>
     8ac:	04000005 	streq	r0, [r0], #-5
     8b0:	0010050e 	andseq	r0, r0, lr, lsl #10
     8b4:	131f0800 	tstne	pc, #0, 16
     8b8:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     8bc:	04180008 	ldreq	r0, [r8], #-8
     8c0:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
     8c4:	04e40418 	strbteq	r0, [r4], #1048	; 0x418
     8c8:	3f0d0000 	svccc	0x000d0000
     8cc:	14000006 	strne	r0, [r0], #-6
     8d0:	78072208 	stmdavc	r7, {r3, r9, sp}
     8d4:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
     8d8:	00000a7a 	andeq	r0, r0, sl, ror sl
     8dc:	83122608 	tsthi	r2, #8, 12	; 0x800000
     8e0:	00000000 	andeq	r0, r0, r0
     8e4:	0004ea0e 	andeq	lr, r4, lr, lsl #20
     8e8:	1d290800 	stcne	8, cr0, [r9, #-0]
     8ec:	000005ea 	andeq	r0, r0, sl, ror #11
     8f0:	0ed80e04 	cdpeq	14, 13, cr0, cr8, cr4, {0}
     8f4:	2c080000 	stccs	0, cr0, [r8], {-0}
     8f8:	0005ea1d 	andeq	lr, r5, sp, lsl sl
     8fc:	791c0800 	ldmdbvc	ip, {fp}
     900:	08000011 	stmdaeq	r0, {r0, r4}
     904:	10620e2f 	rsbne	r0, r2, pc, lsr #28
     908:	063e0000 	ldrteq	r0, [lr], -r0
     90c:	06490000 	strbeq	r0, [r9], -r0
     910:	7d100000 	ldcvc	0, cr0, [r0, #-0]
     914:	11000008 	tstne	r0, r8
     918:	000005ea 	andeq	r0, r0, sl, ror #11
     91c:	101b1d00 	andsne	r1, fp, r0, lsl #26
     920:	31080000 	mrscc	r0, (UNDEF: 8)
     924:	0004310e 	andeq	r3, r4, lr, lsl #2
     928:	0003eb00 	andeq	lr, r3, r0, lsl #22
     92c:	00066100 	andeq	r6, r6, r0, lsl #2
     930:	00066c00 	andeq	r6, r6, r0, lsl #24
     934:	087d1000 	ldmdaeq	sp!, {ip}^
     938:	f0110000 			; <UNDEFINED> instruction: 0xf0110000
     93c:	00000005 	andeq	r0, r0, r5
     940:	0010c713 	andseq	ip, r0, r3, lsl r7
     944:	1d350800 	ldcne	8, cr0, [r5, #-0]
     948:	00000fe0 	andeq	r0, r0, r0, ror #31
     94c:	000005ea 	andeq	r0, r0, sl, ror #11
     950:	00068502 	andeq	r8, r6, r2, lsl #10
     954:	00068b00 	andeq	r8, r6, r0, lsl #22
     958:	087d1000 	ldmdaeq	sp!, {ip}^
     95c:	13000000 	movwne	r0, #0
     960:	000009ca 	andeq	r0, r0, sl, asr #19
     964:	c11d3708 	tstgt	sp, r8, lsl #14
     968:	ea00000d 	b	9a4 <shift+0x9a4>
     96c:	02000005 	andeq	r0, r0, #5
     970:	000006a4 	andeq	r0, r0, r4, lsr #13
     974:	000006aa 	andeq	r0, r0, sl, lsr #13
     978:	00087d10 	andeq	r7, r8, r0, lsl sp
     97c:	491e0000 	ldmdbmi	lr, {}	; <UNPREDICTABLE>
     980:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     984:	08963139 	ldmeq	r6, {r0, r3, r4, r5, r8, ip, sp}
     988:	020c0000 	andeq	r0, ip, #0
     98c:	00063f13 	andeq	r3, r6, r3, lsl pc
     990:	093c0800 	ldmdbeq	ip!, {fp}
     994:	0000128f 	andeq	r1, r0, pc, lsl #5
     998:	0000087d 	andeq	r0, r0, sp, ror r8
     99c:	0006d101 	andeq	sp, r6, r1, lsl #2
     9a0:	0006d700 	andeq	sp, r6, r0, lsl #14
     9a4:	087d1000 	ldmdaeq	sp!, {ip}^
     9a8:	13000000 	movwne	r0, #0
     9ac:	000005d7 	ldrdeq	r0, [r0], -r7
     9b0:	4e123f08 	cdpmi	15, 1, cr3, cr2, cr8, {0}
     9b4:	83000011 	movwhi	r0, #17
     9b8:	01000000 	mrseq	r0, (UNDEF: 0)
     9bc:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     9c0:	00000705 	andeq	r0, r0, r5, lsl #14
     9c4:	00087d10 	andeq	r7, r8, r0, lsl sp
     9c8:	089f1100 	ldmeq	pc, {r8, ip}	; <UNPREDICTABLE>
     9cc:	94110000 	ldrls	r0, [r1], #-0
     9d0:	11000000 	mrsne	r0, (UNDEF: 0)
     9d4:	000003eb 	andeq	r0, r0, fp, ror #7
     9d8:	102a1400 	eorne	r1, sl, r0, lsl #8
     9dc:	42080000 	andmi	r0, r8, #0
     9e0:	000cfa0e 	andeq	pc, ip, lr, lsl #20
     9e4:	071a0100 	ldreq	r0, [sl, -r0, lsl #2]
     9e8:	07200000 	streq	r0, [r0, -r0]!
     9ec:	7d100000 	ldcvc	0, cr0, [r0, #-0]
     9f0:	00000008 	andeq	r0, r0, r8
     9f4:	00092e13 	andeq	r2, r9, r3, lsl lr
     9f8:	17450800 	strbne	r0, [r5, -r0, lsl #16]
     9fc:	0000050f 	andeq	r0, r0, pc, lsl #10
     a00:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     a04:	00073901 	andeq	r3, r7, r1, lsl #18
     a08:	00073f00 	andeq	r3, r7, r0, lsl #30
     a0c:	08a51000 	stmiaeq	r5!, {ip}
     a10:	13000000 	movwne	r0, #0
     a14:	0000055e 	andeq	r0, r0, lr, asr r5
     a18:	9d174808 	ldcls	8, cr4, [r7, #-32]	; 0xffffffe0
     a1c:	f000000f 			; <UNDEFINED> instruction: 0xf000000f
     a20:	01000005 	tsteq	r0, r5
     a24:	00000758 	andeq	r0, r0, r8, asr r7
     a28:	00000763 	andeq	r0, r0, r3, ror #14
     a2c:	0008a510 	andeq	sl, r8, r0, lsl r5
     a30:	00831100 	addeq	r1, r3, r0, lsl #2
     a34:	14000000 	strne	r0, [r0], #-0
     a38:	000011e7 	andeq	r1, r0, r7, ror #3
     a3c:	330e4b08 	movwcc	r4, #60168	; 0xeb08
     a40:	01000010 	tsteq	r0, r0, lsl r0
     a44:	00000778 	andeq	r0, r0, r8, ror r7
     a48:	0000077e 	andeq	r0, r0, lr, ror r7
     a4c:	00087d10 	andeq	r7, r8, r0, lsl sp
     a50:	1b130000 	blne	4c0a58 <__bss_end+0x4b7000>
     a54:	08000010 	stmdaeq	r0, {r4}
     a58:	07bc0e4d 	ldreq	r0, [ip, sp, asr #28]!
     a5c:	03eb0000 	mvneq	r0, #0
     a60:	97010000 	strls	r0, [r1, -r0]
     a64:	a2000007 	andge	r0, r0, #7
     a68:	10000007 	andne	r0, r0, r7
     a6c:	0000087d 	andeq	r0, r0, sp, ror r8
     a70:	00008311 	andeq	r8, r0, r1, lsl r3
     a74:	42130000 	andsmi	r0, r3, #0
     a78:	08000009 	stmdaeq	r0, {r0, r3}
     a7c:	0d1b1250 	lfmeq	f1, 4, [fp, #-320]	; 0xfffffec0
     a80:	00830000 	addeq	r0, r3, r0
     a84:	bb010000 	bllt	40a8c <__bss_end+0x37034>
     a88:	c6000007 	strgt	r0, [r0], -r7
     a8c:	10000007 	andne	r0, r0, r7
     a90:	0000087d 	andeq	r0, r0, sp, ror r8
     a94:	00041a11 	andeq	r1, r4, r1, lsl sl
     a98:	97130000 	ldrls	r0, [r3, -r0]
     a9c:	08000004 	stmdaeq	r0, {r2}
     aa0:	08730e53 	ldmdaeq	r3!, {r0, r1, r4, r6, r9, sl, fp}^
     aa4:	03eb0000 	mvneq	r0, #0
     aa8:	df010000 	svcle	0x00010000
     aac:	ea000007 	b	ad0 <shift+0xad0>
     ab0:	10000007 	andne	r0, r0, r7
     ab4:	0000087d 	andeq	r0, r0, sp, ror r8
     ab8:	00008311 	andeq	r8, r0, r1, lsl r3
     abc:	a4140000 	ldrge	r0, [r4], #-0
     ac0:	08000009 	stmdaeq	r0, {r0, r3}
     ac4:	10e60e56 	rscne	r0, r6, r6, asr lr
     ac8:	ff010000 			; <UNDEFINED> instruction: 0xff010000
     acc:	1e000007 	cdpne	0, 0, cr0, cr0, cr7, {0}
     ad0:	10000008 	andne	r0, r0, r8
     ad4:	0000087d 	andeq	r0, r0, sp, ror r8
     ad8:	00011a11 	andeq	r1, r1, r1, lsl sl
     adc:	00831100 	addeq	r1, r3, r0, lsl #2
     ae0:	83110000 	tsthi	r1, #0
     ae4:	11000000 	mrsne	r0, (UNDEF: 0)
     ae8:	00000083 	andeq	r0, r0, r3, lsl #1
     aec:	0008ab11 	andeq	sl, r8, r1, lsl fp
     af0:	ca140000 	bgt	500af8 <__bss_end+0x4f70a0>
     af4:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     af8:	06de0e58 			; <UNDEFINED> instruction: 0x06de0e58
     afc:	33010000 	movwcc	r0, #4096	; 0x1000
     b00:	52000008 	andpl	r0, r0, #8
     b04:	10000008 	andne	r0, r0, r8
     b08:	0000087d 	andeq	r0, r0, sp, ror r8
     b0c:	00015111 	andeq	r5, r1, r1, lsl r1
     b10:	00831100 	addeq	r1, r3, r0, lsl #2
     b14:	83110000 	tsthi	r1, #0
     b18:	11000000 	mrsne	r0, (UNDEF: 0)
     b1c:	00000083 	andeq	r0, r0, r3, lsl #1
     b20:	0008ab11 	andeq	sl, r8, r1, lsl fp
     b24:	0e150000 	cdpeq	0, 1, cr0, cr5, cr0, {0}
     b28:	08000006 	stmdaeq	r0, {r1, r2}
     b2c:	06700e5b 			; <UNDEFINED> instruction: 0x06700e5b
     b30:	03eb0000 	mvneq	r0, #0
     b34:	67010000 	strvs	r0, [r1, -r0]
     b38:	10000008 	andne	r0, r0, r8
     b3c:	0000087d 	andeq	r0, r0, sp, ror r8
     b40:	00059611 	andeq	r9, r5, r1, lsl r6
     b44:	08b11100 	ldmeq	r1!, {r8, ip}
     b48:	00000000 	andeq	r0, r0, r0
     b4c:	0005f604 	andeq	pc, r5, r4, lsl #12
     b50:	f6041800 			; <UNDEFINED> instruction: 0xf6041800
     b54:	1f000005 	svcne	0x00000005
     b58:	000005ea 	andeq	r0, r0, sl, ror #11
     b5c:	00000890 	muleq	r0, r0, r8
     b60:	00000896 	muleq	r0, r6, r8
     b64:	00087d10 	andeq	r7, r8, r0, lsl sp
     b68:	f6200000 			; <UNDEFINED> instruction: 0xf6200000
     b6c:	83000005 	movwhi	r0, #5
     b70:	18000008 	stmdane	r0, {r3}
     b74:	00007504 	andeq	r7, r0, r4, lsl #10
     b78:	78041800 	stmdavc	r4, {fp, ip}
     b7c:	21000008 	tstcs	r0, r8
     b80:	0000f404 	andeq	pc, r0, r4, lsl #8
     b84:	1a042200 	bne	10938c <__bss_end+0xff934>
     b88:	00000b57 	andeq	r0, r0, r7, asr fp
     b8c:	f6195e08 			; <UNDEFINED> instruction: 0xf6195e08
     b90:	23000005 	movwcs	r0, #5
     b94:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b98:	790b0509 	stmdbvc	fp, {r0, r3, r8, sl}
     b9c:	24000009 	strcs	r0, [r0], #-9
     ba0:	00000b80 	andeq	r0, r0, r0, lsl #23
     ba4:	9b190709 	blls	6427d0 <__bss_end+0x638d78>
     ba8:	80000000 	andhi	r0, r0, r0
     bac:	240ee6b2 	strcs	lr, [lr], #-1714	; 0xfffff94e
     bb0:	00000e3a 	andeq	r0, r0, sl, lsr lr
     bb4:	df1a0a09 	svcle	0x001a0a09
     bb8:	00000004 	andeq	r0, r0, r4
     bbc:	24200000 	strtcs	r0, [r0], #-0
     bc0:	00000bdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     bc4:	df1a0d09 	svcle	0x001a0d09
     bc8:	00000004 	andeq	r0, r0, r4
     bcc:	25202000 	strcs	r2, [r0, #-0]!
     bd0:	00000df3 	strdeq	r0, [r0], -r3
     bd4:	8f151009 	svchi	0x00151009
     bd8:	36000000 	strcc	r0, [r0], -r0
     bdc:	00060524 	andeq	r0, r6, r4, lsr #10
     be0:	1a4b0900 	bne	12c2fe8 <__bss_end+0x12b9590>
     be4:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     be8:	20215000 	eorcs	r5, r1, r0
     bec:	00081624 	andeq	r1, r8, r4, lsr #12
     bf0:	1a7a0900 	bne	1e82ff8 <__bss_end+0x1e795a0>
     bf4:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     bf8:	2000b200 	andcs	fp, r0, r0, lsl #4
     bfc:	000ecd24 	andeq	ip, lr, r4, lsr #26
     c00:	1aad0900 	bne	feb43008 <__bss_end+0xfeb395b0>
     c04:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c08:	2000b400 	andcs	fp, r0, r0, lsl #8
     c0c:	0008aa24 	andeq	sl, r8, r4, lsr #20
     c10:	1abc0900 	bne	fef03018 <__bss_end+0xfeef95c0>
     c14:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c18:	20104000 	andscs	r4, r0, r0
     c1c:	0007ef24 	andeq	lr, r7, r4, lsr #30
     c20:	1ac70900 	bne	ff1c3028 <__bss_end+0xff1b95d0>
     c24:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c28:	20205000 	eorcs	r5, r0, r0
     c2c:	00085024 	andeq	r5, r8, r4, lsr #32
     c30:	1ac80900 	bne	ff203038 <__bss_end+0xff1f95e0>
     c34:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c38:	20804000 	addcs	r4, r0, r0
     c3c:	0004c924 	andeq	ip, r4, r4, lsr #18
     c40:	1ac90900 	bne	ff243048 <__bss_end+0xff2395f0>
     c44:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c48:	20805000 	addcs	r5, r0, r0
     c4c:	08cb2600 	stmiaeq	fp, {r9, sl, sp}^
     c50:	db260000 	blle	980c58 <__bss_end+0x977200>
     c54:	26000008 	strcs	r0, [r0], -r8
     c58:	000008eb 	andeq	r0, r0, fp, ror #17
     c5c:	0008fb26 	andeq	pc, r8, r6, lsr #22
     c60:	09082600 	stmdbeq	r8, {r9, sl, sp}
     c64:	18260000 	stmdane	r6!, {}	; <UNPREDICTABLE>
     c68:	26000009 	strcs	r0, [r0], -r9
     c6c:	00000928 	andeq	r0, r0, r8, lsr #18
     c70:	00093826 	andeq	r3, r9, r6, lsr #16
     c74:	09482600 	stmdbeq	r8, {r9, sl, sp}^
     c78:	58260000 	stmdapl	r6!, {}	; <UNPREDICTABLE>
     c7c:	26000009 	strcs	r0, [r0], -r9
     c80:	00000968 	andeq	r0, r0, r8, ror #18
     c84:	000b2302 	andeq	r2, fp, r2, lsl #6
     c88:	14080a00 	strne	r0, [r8], #-2560	; 0xfffff600
     c8c:	0000008f 	andeq	r0, r0, pc, lsl #1
     c90:	99bc0305 	ldmibls	ip!, {r0, r2, r8, r9}
     c94:	9e0a0000 	cdpls	0, 0, cr0, cr10, cr0, {0}
     c98:	0700000c 	streq	r0, [r0, -ip]
     c9c:	00009404 	andeq	r9, r0, r4, lsl #8
     ca0:	0c0b0a00 			; <UNDEFINED> instruction: 0x0c0b0a00
     ca4:	00000a0b 	andeq	r0, r0, fp, lsl #20
     ca8:	0010150b 	andseq	r1, r0, fp, lsl #10
     cac:	5c0b0000 	stcpl	0, cr0, [fp], {-0}
     cb0:	0100000c 	tsteq	r0, ip
     cb4:	000aa10b 	andeq	sl, sl, fp, lsl #2
     cb8:	260b0200 	strcs	r0, [fp], -r0, lsl #4
     cbc:	03000004 	movweq	r0, #4
     cc0:	0004150b 	andeq	r1, r4, fp, lsl #10
     cc4:	6e0b0400 	cfcpysvs	mvf0, mvf11
     cc8:	0500000a 	streq	r0, [r0, #-10]
     ccc:	000a740b 	andeq	r7, sl, fp, lsl #8
     cd0:	200b0600 	andcs	r0, fp, r0, lsl #12
     cd4:	07000004 	streq	r0, [r0, -r4]
     cd8:	00126a0b 	andseq	r6, r2, fp, lsl #20
     cdc:	0a000800 	beq	2ce4 <shift+0x2ce4>
     ce0:	000003dc 	ldrdeq	r0, [r0], -ip
     ce4:	00670405 	rsbeq	r0, r7, r5, lsl #8
     ce8:	1d0a0000 	stcne	0, cr0, [sl, #-0]
     cec:	000a360c 	andeq	r3, sl, ip, lsl #12
     cf0:	09180b00 	ldmdbeq	r8, {r8, r9, fp}
     cf4:	0b000000 	bleq	cfc <shift+0xcfc>
     cf8:	00000736 	andeq	r0, r0, r6, lsr r7
     cfc:	08b40b01 	ldmeq	r4!, {r0, r8, r9, fp}
     d00:	1b020000 	blne	80d08 <__bss_end+0x772b0>
     d04:	00776f4c 	rsbseq	r6, r7, ip, asr #30
     d08:	5c0d0003 	stcpl	0, cr0, [sp], {3}
     d0c:	1c000012 	stcne	0, cr0, [r0], {18}
     d10:	b707280a 	strlt	r2, [r7, -sl, lsl #16]
     d14:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     d18:	000005c9 	andeq	r0, r0, r9, asr #11
     d1c:	0a330a10 	beq	cc3564 <__bss_end+0xcb9b0c>
     d20:	00000a85 	andeq	r0, r0, r5, lsl #21
     d24:	000ea10e 	andeq	sl, lr, lr, lsl #2
     d28:	0b350a00 	bleq	d43530 <__bss_end+0xd39ad8>
     d2c:	0000041a 	andeq	r0, r0, sl, lsl r4
     d30:	11fd0e00 	mvnsne	r0, r0, lsl #28
     d34:	360a0000 	strcc	r0, [sl], -r0
     d38:	0000830d 	andeq	r8, r0, sp, lsl #6
     d3c:	2c0e0400 	cfstrscs	mvf0, [lr], {-0}
     d40:	0a000004 	beq	d58 <shift+0xd58>
     d44:	0dbc1337 	ldceq	3, cr1, [ip, #220]!	; 0xdc
     d48:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     d4c:	00000550 	andeq	r0, r0, r0, asr r5
     d50:	bc13380a 	ldclt	8, cr3, [r3], {10}
     d54:	0c00000d 	stceq	0, cr0, [r0], {13}
     d58:	05e60e00 	strbeq	r0, [r6, #3584]!	; 0xe00
     d5c:	2c0a0000 	stccs	0, cr0, [sl], {-0}
     d60:	000dc820 	andeq	ip, sp, r0, lsr #16
     d64:	b20e0000 	andlt	r0, lr, #0
     d68:	0a000005 	beq	d84 <shift+0xd84>
     d6c:	0dcd0c2f 	stcleq	12, cr0, [sp, #188]	; 0xbc
     d70:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     d74:	00000c2c 	andeq	r0, r0, ip, lsr #24
     d78:	cd0c310a 	stfgts	f3, [ip, #-40]	; 0xffffffd8
     d7c:	0c00000d 	stceq	0, cr0, [r0], {13}
     d80:	000f580e 	andeq	r5, pc, lr, lsl #16
     d84:	123b0a00 	eorsne	r0, fp, #0, 20
     d88:	00000dbc 			; <UNDEFINED> instruction: 0x00000dbc
     d8c:	0e5c0e14 	mrceq	14, 2, r0, cr12, cr4, {0}
     d90:	3d0a0000 	stccc	0, cr0, [sl, #-0]
     d94:	0001b90e 	andeq	fp, r1, lr, lsl #18
     d98:	44131800 	ldrmi	r1, [r3], #-2048	; 0xfffff800
     d9c:	0a00000c 	beq	dd4 <shift+0xdd4>
     da0:	09560841 	ldmdbeq	r6, {r0, r6, fp}^
     da4:	03eb0000 	mvneq	r0, #0
     da8:	df020000 	svcle	0x00020000
     dac:	f400000a 	vst4.8	{d0-d3}, [r0], sl
     db0:	1000000a 	andne	r0, r0, sl
     db4:	00000ddd 	ldrdeq	r0, [r0], -sp
     db8:	00008311 	andeq	r8, r0, r1, lsl r3
     dbc:	0de31100 	stfeqe	f1, [r3]
     dc0:	e3110000 	tst	r1, #0
     dc4:	0000000d 	andeq	r0, r0, sp
     dc8:	000c0d13 	andeq	r0, ip, r3, lsl sp
     dcc:	08430a00 	stmdaeq	r3, {r9, fp}^
     dd0:	00000ba2 	andeq	r0, r0, r2, lsr #23
     dd4:	000003eb 	andeq	r0, r0, fp, ror #7
     dd8:	000b0d02 	andeq	r0, fp, r2, lsl #26
     ddc:	000b2200 	andeq	r2, fp, r0, lsl #4
     de0:	0ddd1000 	ldcleq	0, cr1, [sp]
     de4:	83110000 	tsthi	r1, #0
     de8:	11000000 	mrsne	r0, (UNDEF: 0)
     dec:	00000de3 	andeq	r0, r0, r3, ror #27
     df0:	000de311 	andeq	lr, sp, r1, lsl r3
     df4:	16130000 	ldrne	r0, [r3], -r0
     df8:	0a00000f 	beq	e3c <shift+0xe3c>
     dfc:	119b0845 	orrsne	r0, fp, r5, asr #16
     e00:	03eb0000 	mvneq	r0, #0
     e04:	3b020000 	blcc	80e0c <__bss_end+0x773b4>
     e08:	5000000b 	andpl	r0, r0, fp
     e0c:	1000000b 	andne	r0, r0, fp
     e10:	00000ddd 	ldrdeq	r0, [r0], -sp
     e14:	00008311 	andeq	r8, r0, r1, lsl r3
     e18:	0de31100 	stfeqe	f1, [r3]
     e1c:	e3110000 	tst	r1, #0
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	0010d313 	andseq	sp, r0, r3, lsl r3
     e28:	08470a00 	stmdaeq	r7, {r9, fp}^
     e2c:	00000f29 	andeq	r0, r0, r9, lsr #30
     e30:	000003eb 	andeq	r0, r0, fp, ror #7
     e34:	000b6902 	andeq	r6, fp, r2, lsl #18
     e38:	000b7e00 	andeq	r7, fp, r0, lsl #28
     e3c:	0ddd1000 	ldcleq	0, cr1, [sp]
     e40:	83110000 	tsthi	r1, #0
     e44:	11000000 	mrsne	r0, (UNDEF: 0)
     e48:	00000de3 	andeq	r0, r0, r3, ror #27
     e4c:	000de311 	andeq	lr, sp, r1, lsl r3
     e50:	3d130000 	ldccc	0, cr0, [r3, #-0]
     e54:	0a000005 	beq	e70 <shift+0xe70>
     e58:	10980849 	addsne	r0, r8, r9, asr #16
     e5c:	03eb0000 	mvneq	r0, #0
     e60:	97020000 	strls	r0, [r2, -r0]
     e64:	ac00000b 	stcge	0, cr0, [r0], {11}
     e68:	1000000b 	andne	r0, r0, fp
     e6c:	00000ddd 	ldrdeq	r0, [r0], -sp
     e70:	00008311 	andeq	r8, r0, r1, lsl r3
     e74:	0de31100 	stfeqe	f1, [r3]
     e78:	e3110000 	tst	r1, #0
     e7c:	0000000d 	andeq	r0, r0, sp
     e80:	000be913 	andeq	lr, fp, r3, lsl r9
     e84:	084b0a00 	stmdaeq	fp, {r9, fp}^
     e88:	000008cb 	andeq	r0, r0, fp, asr #17
     e8c:	000003eb 	andeq	r0, r0, fp, ror #7
     e90:	000bc502 	andeq	ip, fp, r2, lsl #10
     e94:	000bdf00 	andeq	sp, fp, r0, lsl #30
     e98:	0ddd1000 	ldcleq	0, cr1, [sp]
     e9c:	83110000 	tsthi	r1, #0
     ea0:	11000000 	mrsne	r0, (UNDEF: 0)
     ea4:	00000a0b 	andeq	r0, r0, fp, lsl #20
     ea8:	000de311 	andeq	lr, sp, r1, lsl r3
     eac:	0de31100 	stfeqe	f1, [r3]
     eb0:	13000000 	movwne	r0, #0
     eb4:	00000a34 	andeq	r0, r0, r4, lsr sl
     eb8:	930c4f0a 	movwls	r4, #53002	; 0xcf0a
     ebc:	8300000d 	movwhi	r0, #13
     ec0:	02000000 	andeq	r0, r0, #0
     ec4:	00000bf8 	strdeq	r0, [r0], -r8
     ec8:	00000bfe 	strdeq	r0, [r0], -lr
     ecc:	000ddd10 	andeq	sp, sp, r0, lsl sp
     ed0:	7c140000 	ldcvc	0, cr0, [r4], {-0}
     ed4:	0a00000f 	beq	f18 <shift+0xf18>
     ed8:	06b30851 	ssateq	r0, #20, r1, asr #16
     edc:	13020000 	movwne	r0, #8192	; 0x2000
     ee0:	1e00000c 	cdpne	0, 0, cr0, cr0, cr12, {0}
     ee4:	1000000c 	andne	r0, r0, ip
     ee8:	00000de9 	andeq	r0, r0, r9, ror #27
     eec:	00008311 	andeq	r8, r0, r1, lsl r3
     ef0:	5c130000 	ldcpl	0, cr0, [r3], {-0}
     ef4:	0a000012 	beq	f44 <shift+0xf44>
     ef8:	0e230354 	mcreq	3, 1, r0, cr3, cr4, {2}
     efc:	0de90000 	stcleq	0, cr0, [r9]
     f00:	37010000 	strcc	r0, [r1, -r0]
     f04:	4200000c 	andmi	r0, r0, #12
     f08:	1000000c 	andne	r0, r0, ip
     f0c:	00000de9 	andeq	r0, r0, r9, ror #27
     f10:	00009411 	andeq	r9, r0, r1, lsl r4
     f14:	fd140000 	ldc2	0, cr0, [r4, #-0]
     f18:	0a000004 	beq	f30 <shift+0xf30>
     f1c:	0c750857 	ldcleq	8, cr0, [r5], #-348	; 0xfffffea4
     f20:	57010000 	strpl	r0, [r1, -r0]
     f24:	6700000c 	strvs	r0, [r0, -ip]
     f28:	1000000c 	andne	r0, r0, ip
     f2c:	00000de9 	andeq	r0, r0, r9, ror #27
     f30:	00008311 	andeq	r8, r0, r1, lsl r3
     f34:	09c21100 	stmibeq	r2, {r8, ip}^
     f38:	13000000 	movwne	r0, #0
     f3c:	00000ebb 			; <UNDEFINED> instruction: 0x00000ebb
     f40:	0e12590a 	vnmlseq.f16	s10, s4, s20	; <UNPREDICTABLE>
     f44:	c2000012 	andgt	r0, r0, #18
     f48:	01000009 	tsteq	r0, r9
     f4c:	00000c80 	andeq	r0, r0, r0, lsl #25
     f50:	00000c8b 	andeq	r0, r0, fp, lsl #25
     f54:	000ddd10 	andeq	sp, sp, r0, lsl sp
     f58:	00831100 	addeq	r1, r3, r0, lsl #2
     f5c:	14000000 	strne	r0, [r0], #-0
     f60:	00000c58 	andeq	r0, r0, r8, asr ip
     f64:	a7085c0a 	strge	r5, [r8, -sl, lsl #24]
     f68:	0100000a 	tsteq	r0, sl
     f6c:	00000ca0 	andeq	r0, r0, r0, lsr #25
     f70:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
     f74:	000de910 	andeq	lr, sp, r0, lsl r9
     f78:	00831100 	addeq	r1, r3, r0, lsl #2
     f7c:	eb110000 	bl	440f84 <__bss_end+0x43752c>
     f80:	00000003 	andeq	r0, r0, r3
     f84:	00101113 	andseq	r1, r0, r3, lsl r1
     f88:	085f0a00 	ldmdaeq	pc, {r9, fp}^	; <UNPREDICTABLE>
     f8c:	000004aa 	andeq	r0, r0, sl, lsr #9
     f90:	000003eb 	andeq	r0, r0, fp, ror #7
     f94:	000cc901 	andeq	ip, ip, r1, lsl #18
     f98:	000cd400 	andeq	sp, ip, r0, lsl #8
     f9c:	0de91000 	stcleq	0, cr1, [r9]
     fa0:	83110000 	tsthi	r1, #0
     fa4:	00000000 	andeq	r0, r0, r0
     fa8:	000eaf13 	andeq	sl, lr, r3, lsl pc
     fac:	08620a00 	stmdaeq	r2!, {r9, fp}^
     fb0:	000003f1 	strdeq	r0, [r0], -r1
     fb4:	000003eb 	andeq	r0, r0, fp, ror #7
     fb8:	000ced01 	andeq	lr, ip, r1, lsl #26
     fbc:	000d0200 	andeq	r0, sp, r0, lsl #4
     fc0:	0de91000 	stcleq	0, cr1, [r9]
     fc4:	83110000 	tsthi	r1, #0
     fc8:	11000000 	mrsne	r0, (UNDEF: 0)
     fcc:	000003eb 	andeq	r0, r0, fp, ror #7
     fd0:	0003eb11 	andeq	lr, r3, r1, lsl fp
     fd4:	05130000 	ldreq	r0, [r3, #-0]
     fd8:	0a000012 	beq	1028 <shift+0x1028>
     fdc:	08300864 	ldmdaeq	r0!, {r2, r5, r6, fp}
     fe0:	03eb0000 	mvneq	r0, #0
     fe4:	1b010000 	blne	40fec <__bss_end+0x37594>
     fe8:	3000000d 	andcc	r0, r0, sp
     fec:	1000000d 	andne	r0, r0, sp
     ff0:	00000de9 	andeq	r0, r0, r9, ror #27
     ff4:	00008311 	andeq	r8, r0, r1, lsl r3
     ff8:	03eb1100 	mvneq	r1, #0, 2
     ffc:	eb110000 	bl	441004 <__bss_end+0x4375ac>
    1000:	00000003 	andeq	r0, r0, r3
    1004:	000b2f14 	andeq	r2, fp, r4, lsl pc
    1008:	08670a00 	stmdaeq	r7!, {r9, fp}^
    100c:	000003b1 			; <UNDEFINED> instruction: 0x000003b1
    1010:	000d4501 	andeq	r4, sp, r1, lsl #10
    1014:	000d5500 	andeq	r5, sp, r0, lsl #10
    1018:	0de91000 	stcleq	0, cr1, [r9]
    101c:	83110000 	tsthi	r1, #0
    1020:	11000000 	mrsne	r0, (UNDEF: 0)
    1024:	00000a0b 	andeq	r0, r0, fp, lsl #20
    1028:	0d4e1400 	cfstrdeq	mvd1, [lr, #-0]
    102c:	690a0000 	stmdbvs	sl, {}	; <UNPREDICTABLE>
    1030:	00075f08 	andeq	r5, r7, r8, lsl #30
    1034:	0d6a0100 	stfeqe	f0, [sl, #-0]
    1038:	0d7a0000 	ldcleq	0, cr0, [sl, #-0]
    103c:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
    1040:	1100000d 	tstne	r0, sp
    1044:	00000083 	andeq	r0, r0, r3, lsl #1
    1048:	000a0b11 	andeq	r0, sl, r1, lsl fp
    104c:	cf140000 	svcgt	0x00140000
    1050:	0a000012 	beq	10a0 <shift+0x10a0>
    1054:	09f4086c 	ldmibeq	r4!, {r2, r3, r5, r6, fp}^
    1058:	8f010000 	svchi	0x00010000
    105c:	9500000d 	strls	r0, [r0, #-13]
    1060:	1000000d 	andne	r0, r0, sp
    1064:	00000de9 	andeq	r0, r0, r9, ror #27
    1068:	0b932700 	bleq	fe4cac70 <__bss_end+0xfe4c1218>
    106c:	6f0a0000 	svcvs	0x000a0000
    1070:	000e6a08 	andeq	r6, lr, r8, lsl #20
    1074:	0da60100 	stfeqs	f0, [r6]
    1078:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
    107c:	1100000d 	tstne	r0, sp
    1080:	0000041a 	andeq	r0, r0, sl, lsl r4
    1084:	00008311 	andeq	r8, r0, r1, lsl r3
    1088:	04000000 	streq	r0, [r0], #-0
    108c:	00000a36 	andeq	r0, r0, r6, lsr sl
    1090:	0a430418 	beq	10c20f8 <__bss_end+0x10b86a0>
    1094:	04180000 	ldreq	r0, [r8], #-0
    1098:	000000a0 	andeq	r0, r0, r0, lsr #1
    109c:	000dc204 	andeq	ip, sp, r4, lsl #4
    10a0:	00831600 	addeq	r1, r3, r0, lsl #12
    10a4:	0ddd0000 	ldcleq	0, cr0, [sp]
    10a8:	94170000 	ldrls	r0, [r7], #-0
    10ac:	01000000 	mrseq	r0, (UNDEF: 0)
    10b0:	b7041800 	strlt	r1, [r4, -r0, lsl #16]
    10b4:	2100000d 	tstcs	r0, sp
    10b8:	00008304 	andeq	r8, r0, r4, lsl #6
    10bc:	36041800 	strcc	r1, [r4], -r0, lsl #16
    10c0:	1a00000a 	bne	10f0 <shift+0x10f0>
    10c4:	00000b43 	andeq	r0, r0, r3, asr #22
    10c8:	3616730a 	ldrcc	r7, [r6], -sl, lsl #6
    10cc:	2800000a 	stmdacs	r0, {r1, r3}
    10d0:	00000750 	andeq	r0, r0, r0, asr r7
    10d4:	67050e01 	strvs	r0, [r5, -r1, lsl #28]
    10d8:	2c000000 	stccs	0, cr0, [r0], {-0}
    10dc:	dc000082 	stcle	0, cr0, [r0], {130}	; 0x82
    10e0:	01000000 	mrseq	r0, (UNDEF: 0)
    10e4:	000e7f9c 	muleq	lr, ip, pc	; <UNPREDICTABLE>
    10e8:	12442900 	subne	r2, r4, #0, 18
    10ec:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    10f0:	0000670e 	andeq	r6, r0, lr, lsl #14
    10f4:	5c910200 	lfmpl	f0, 4, [r1], {0}
    10f8:	00113829 	andseq	r3, r1, r9, lsr #16
    10fc:	1b0e0100 	blne	381504 <__bss_end+0x377aac>
    1100:	00000e7f 	andeq	r0, r0, pc, ror lr
    1104:	2a589102 	bcs	1625514 <__bss_end+0x161babc>
    1108:	00001b71 	andeq	r1, r0, r1, ror fp
    110c:	43071001 	movwmi	r1, #28673	; 0x7001
    1110:	02000000 	andeq	r0, r0, #0
    1114:	552a6b91 	strpl	r6, [sl, #-2961]!	; 0xfffff46f
    1118:	01000005 	tsteq	r0, r5
    111c:	00430711 	subeq	r0, r3, r1, lsl r7
    1120:	91020000 	mrsls	r0, (UNDEF: 2)
    1124:	0e962a77 			; <UNDEFINED> instruction: 0x0e962a77
    1128:	13010000 	movwne	r0, #4096	; 0x1000
    112c:	0000830b 	andeq	r8, r0, fp, lsl #6
    1130:	70910200 	addsvc	r0, r1, r0, lsl #4
    1134:	00100a2a 	andseq	r0, r0, sl, lsr #20
    1138:	17160100 	ldrne	r0, [r6, -r0, lsl #2]
    113c:	00000a0b 	andeq	r0, r0, fp, lsl #20
    1140:	2a649102 	bcs	1925550 <__bss_end+0x191baf8>
    1144:	000012da 	ldrdeq	r1, [r0], -sl
    1148:	830b1e01 	movwhi	r1, #48641	; 0xbe01
    114c:	02000000 	andeq	r0, r0, #0
    1150:	18006c91 	stmdane	r0, {r0, r4, r7, sl, fp, sp, lr}
    1154:	000e8504 	andeq	r8, lr, r4, lsl #10
    1158:	43041800 	movwmi	r1, #18432	; 0x4800
    115c:	00000000 	andeq	r0, r0, r0
    1160:	00000d5c 	andeq	r0, r0, ip, asr sp
    1164:	04660004 	strbteq	r0, [r6], #-4
    1168:	01040000 	mrseq	r0, (UNDEF: 4)
    116c:	000015d5 	ldrdeq	r1, [r0], -r5
    1170:	0013eb04 	andseq	lr, r3, r4, lsl #22
    1174:	00147600 	andseq	r7, r4, r0, lsl #12
    1178:	00830800 	addeq	r0, r3, r0, lsl #16
    117c:	00045c00 	andeq	r5, r4, r0, lsl #24
    1180:	00044400 	andeq	r4, r4, r0, lsl #8
    1184:	08010200 	stmdaeq	r1, {r9}
    1188:	00000d8e 	andeq	r0, r0, lr, lsl #27
    118c:	00002503 	andeq	r2, r0, r3, lsl #10
    1190:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1194:	00000e02 	andeq	r0, r0, r2, lsl #28
    1198:	000ea704 	andeq	sl, lr, r4, lsl #14
    119c:	07050200 	streq	r0, [r5, -r0, lsl #4]
    11a0:	00000049 	andeq	r0, r0, r9, asr #32
    11a4:	00003803 	andeq	r3, r0, r3, lsl #16
    11a8:	05040500 	streq	r0, [r4, #-1280]	; 0xfffffb00
    11ac:	00746e69 	rsbseq	r6, r4, r9, ror #28
    11b0:	1f050802 	svcne	0x00050802
    11b4:	02000003 	andeq	r0, r0, #3
    11b8:	0d850801 	stceq	8, cr0, [r5, #4]
    11bc:	02020000 	andeq	r0, r2, #0
    11c0:	0009b707 	andeq	fp, r9, r7, lsl #14
    11c4:	0ea60400 	cdpeq	4, 10, cr0, cr6, cr0, {0}
    11c8:	0a020000 	beq	811d0 <__bss_end+0x77778>
    11cc:	00007607 	andeq	r7, r0, r7, lsl #12
    11d0:	00650300 	rsbeq	r0, r5, r0, lsl #6
    11d4:	04020000 	streq	r0, [r2], #-0
    11d8:	0004dd07 	andeq	sp, r4, r7, lsl #26
    11dc:	07080200 	streq	r0, [r8, -r0, lsl #4]
    11e0:	000004d3 	ldrdeq	r0, [r0], -r3
    11e4:	0007e506 	andeq	lr, r7, r6, lsl #10
    11e8:	130d0200 	movwne	r0, #53760	; 0xd200
    11ec:	00000044 	andeq	r0, r0, r4, asr #32
    11f0:	99e40305 	stmibls	r4!, {r0, r2, r8, r9}^
    11f4:	a0060000 	andge	r0, r6, r0
    11f8:	02000008 	andeq	r0, r0, #8
    11fc:	0044130e 	subeq	r1, r4, lr, lsl #6
    1200:	03050000 	movweq	r0, #20480	; 0x5000
    1204:	000099e8 	andeq	r9, r0, r8, ror #19
    1208:	0007e406 	andeq	lr, r7, r6, lsl #8
    120c:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
    1210:	00000071 	andeq	r0, r0, r1, ror r0
    1214:	99ec0305 	stmibls	ip!, {r0, r2, r8, r9}^
    1218:	9f060000 	svcls	0x00060000
    121c:	02000008 	andeq	r0, r0, #8
    1220:	00711411 	rsbseq	r1, r1, r1, lsl r4
    1224:	03050000 	movweq	r0, #20480	; 0x5000
    1228:	000099f0 	strdeq	r9, [r0], -r0
    122c:	00072a07 	andeq	r2, r7, r7, lsl #20
    1230:	06030800 	streq	r0, [r3], -r0, lsl #16
    1234:	0000f208 	andeq	pc, r0, r8, lsl #4
    1238:	30720800 	rsbscc	r0, r2, r0, lsl #16
    123c:	0e080300 	cdpeq	3, 0, cr0, cr8, cr0, {0}
    1240:	00000065 	andeq	r0, r0, r5, rrx
    1244:	31720800 	cmncc	r2, r0, lsl #16
    1248:	0e090300 	cdpeq	3, 0, cr0, cr9, cr0, {0}
    124c:	00000065 	andeq	r0, r0, r5, rrx
    1250:	14090004 	strne	r0, [r9], #-4
    1254:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1258:	00004904 	andeq	r4, r0, r4, lsl #18
    125c:	0c0d0300 	stceq	3, cr0, [sp], {-0}
    1260:	00000110 	andeq	r0, r0, r0, lsl r1
    1264:	004b4f0a 	subeq	r4, fp, sl, lsl #30
    1268:	135a0b00 	cmpne	sl, #0, 22
    126c:	00010000 	andeq	r0, r1, r0
    1270:	00058809 	andeq	r8, r5, r9, lsl #16
    1274:	49040500 	stmdbmi	r4, {r8, sl}
    1278:	03000000 	movweq	r0, #0
    127c:	01470c1e 	cmpeq	r7, lr, lsl ip
    1280:	810b0000 	mrshi	r0, (UNDEF: 11)
    1284:	00000012 	andeq	r0, r0, r2, lsl r0
    1288:	0012bf0b 	andseq	fp, r2, fp, lsl #30
    128c:	890b0100 	stmdbhi	fp, {r8}
    1290:	02000012 	andeq	r0, r0, #18
    1294:	000a590b 	andeq	r5, sl, fp, lsl #18
    1298:	ad0b0300 	stcge	3, cr0, [fp, #-0]
    129c:	0400000c 	streq	r0, [r0], #-12
    12a0:	0007ad0b 	andeq	sl, r7, fp, lsl #26
    12a4:	09000500 	stmdbeq	r0, {r8, sl}
    12a8:	00001183 	andeq	r1, r0, r3, lsl #3
    12ac:	00490405 	subeq	r0, r9, r5, lsl #8
    12b0:	44030000 	strmi	r0, [r3], #-0
    12b4:	0001840c 	andeq	r8, r1, ip, lsl #8
    12b8:	041b0b00 	ldreq	r0, [fp], #-2816	; 0xfffff500
    12bc:	0b000000 	bleq	12c4 <shift+0x12c4>
    12c0:	000005c4 	andeq	r0, r0, r4, asr #11
    12c4:	0c680b01 			; <UNDEFINED> instruction: 0x0c680b01
    12c8:	0b020000 	bleq	812d0 <__bss_end+0x77878>
    12cc:	00001237 	andeq	r1, r0, r7, lsr r2
    12d0:	12c90b03 	sbcne	r0, r9, #3072	; 0xc00
    12d4:	0b040000 	bleq	1012dc <__bss_end+0xf7884>
    12d8:	00000b79 	andeq	r0, r0, r9, ror fp
    12dc:	09d70b05 	ldmibeq	r7, {r0, r2, r8, r9, fp}^
    12e0:	00060000 	andeq	r0, r6, r0
    12e4:	00113d09 	andseq	r3, r1, r9, lsl #26
    12e8:	49040500 	stmdbmi	r4, {r8, sl}
    12ec:	03000000 	movweq	r0, #0
    12f0:	01af0c6b 			; <UNDEFINED> instruction: 0x01af0c6b
    12f4:	630b0000 	movwvs	r0, #45056	; 0xb000
    12f8:	0000000d 	andeq	r0, r0, sp
    12fc:	0009990b 	andeq	r9, r9, fp, lsl #18
    1300:	0c0b0100 	stfeqs	f0, [fp], {-0}
    1304:	0200000e 	andeq	r0, r0, #14
    1308:	0009dc0b 	andeq	sp, r9, fp, lsl #24
    130c:	06000300 	streq	r0, [r0], -r0, lsl #6
    1310:	00000bd1 	ldrdeq	r0, [r0], -r1
    1314:	71140504 	tstvc	r4, r4, lsl #10
    1318:	05000000 	streq	r0, [r0, #-0]
    131c:	0099f403 	addseq	pc, r9, r3, lsl #8
    1320:	0c200600 	stceq	6, cr0, [r0], #-0
    1324:	06040000 	streq	r0, [r4], -r0
    1328:	00007114 	andeq	r7, r0, r4, lsl r1
    132c:	f8030500 			; <UNDEFINED> instruction: 0xf8030500
    1330:	06000099 			; <UNDEFINED> instruction: 0x06000099
    1334:	00000b63 	andeq	r0, r0, r3, ror #22
    1338:	711a0705 	tstvc	sl, r5, lsl #14
    133c:	05000000 	streq	r0, [r0, #-0]
    1340:	0099fc03 	addseq	pc, r9, r3, lsl #24
    1344:	05f30600 	ldrbeq	r0, [r3, #1536]!	; 0x600
    1348:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
    134c:	0000711a 	andeq	r7, r0, sl, lsl r1
    1350:	00030500 	andeq	r0, r3, r0, lsl #10
    1354:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
    1358:	00000d77 	andeq	r0, r0, r7, ror sp
    135c:	711a0b05 	tstvc	sl, r5, lsl #22
    1360:	05000000 	streq	r0, [r0, #-0]
    1364:	009a0403 	addseq	r0, sl, r3, lsl #8
    1368:	09860600 	stmibeq	r6, {r9, sl}
    136c:	0d050000 	stceq	0, cr0, [r5, #-0]
    1370:	0000711a 	andeq	r7, r0, sl, lsl r1
    1374:	08030500 	stmdaeq	r3, {r8, sl}
    1378:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
    137c:	00000755 	andeq	r0, r0, r5, asr r7
    1380:	711a0f05 	tstvc	sl, r5, lsl #30
    1384:	05000000 	streq	r0, [r0, #-0]
    1388:	009a0c03 	addseq	r0, sl, r3, lsl #24
    138c:	0f060900 	svceq	0x00060900
    1390:	04050000 	streq	r0, [r5], #-0
    1394:	00000049 	andeq	r0, r0, r9, asr #32
    1398:	520c1b05 	andpl	r1, ip, #5120	; 0x1400
    139c:	0b000002 	bleq	13ac <shift+0x13ac>
    13a0:	00000f72 	andeq	r0, r0, r2, ror pc
    13a4:	12760b00 	rsbsne	r0, r6, #0, 22
    13a8:	0b010000 	bleq	413b0 <__bss_end+0x37958>
    13ac:	00000c63 	andeq	r0, r0, r3, ror #24
    13b0:	480c0002 	stmdami	ip, {r1}
    13b4:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
    13b8:	00000de7 	andeq	r0, r0, r7, ror #27
    13bc:	07630590 			; <UNDEFINED> instruction: 0x07630590
    13c0:	000003c5 	andeq	r0, r0, r5, asr #7
    13c4:	0011d907 	andseq	sp, r1, r7, lsl #18
    13c8:	67052400 	strvs	r2, [r5, -r0, lsl #8]
    13cc:	0002df10 	andeq	sp, r2, r0, lsl pc
    13d0:	217e0e00 	cmncs	lr, r0, lsl #28
    13d4:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    13d8:	0003c512 	andeq	ip, r3, r2, lsl r5
    13dc:	7c0e0000 	stcvc	0, cr0, [lr], {-0}
    13e0:	05000005 	streq	r0, [r0, #-5]
    13e4:	03d5126b 	bicseq	r1, r5, #-1342177274	; 0xb0000006
    13e8:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    13ec:	00000f67 	andeq	r0, r0, r7, ror #30
    13f0:	65166d05 	ldrvs	r6, [r6, #-3333]	; 0xfffff2fb
    13f4:	14000000 	strne	r0, [r0], #-0
    13f8:	0005ec0e 	andeq	lr, r5, lr, lsl #24
    13fc:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
    1400:	000003dc 	ldrdeq	r0, [r0], -ip
    1404:	0d6e0e18 	stcleq	14, cr0, [lr, #-96]!	; 0xffffffa0
    1408:	72050000 	andvc	r0, r5, #0
    140c:	0003dc1c 	andeq	sp, r3, ip, lsl ip
    1410:	500e1c00 	andpl	r1, lr, r0, lsl #24
    1414:	05000005 	streq	r0, [r0, #-5]
    1418:	03dc1c75 	bicseq	r1, ip, #29952	; 0x7500
    141c:	0f200000 	svceq	0x00200000
    1420:	000007f9 	strdeq	r0, [r0], -r9
    1424:	671c7705 	ldrvs	r7, [ip, -r5, lsl #14]
    1428:	dc000004 	stcle	0, cr0, [r0], {4}
    142c:	d3000003 	movwle	r0, #3
    1430:	10000002 	andne	r0, r0, r2
    1434:	000003dc 	ldrdeq	r0, [r0], -ip
    1438:	0003e211 	andeq	lr, r3, r1, lsl r2
    143c:	07000000 	streq	r0, [r0, -r0]
    1440:	00000665 	andeq	r0, r0, r5, ror #12
    1444:	107b0518 	rsbsne	r0, fp, r8, lsl r5
    1448:	00000314 	andeq	r0, r0, r4, lsl r3
    144c:	00217e0e 	eoreq	r7, r1, lr, lsl #28
    1450:	127e0500 	rsbsne	r0, lr, #0, 10
    1454:	000003c5 	andeq	r0, r0, r5, asr #7
    1458:	05710e00 	ldrbeq	r0, [r1, #-3584]!	; 0xfffff200
    145c:	80050000 	andhi	r0, r5, r0
    1460:	0003e219 	andeq	lr, r3, r9, lsl r2
    1464:	3d0e1000 	stccc	0, cr1, [lr, #-0]
    1468:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    146c:	03ed2182 	mvneq	r2, #-2147483616	; 0x80000020
    1470:	00140000 	andseq	r0, r4, r0
    1474:	0002df03 	andeq	sp, r2, r3, lsl #30
    1478:	0b0d1200 	bleq	345c80 <__bss_end+0x33c228>
    147c:	86050000 	strhi	r0, [r5], -r0
    1480:	0003f321 	andeq	pc, r3, r1, lsr #6
    1484:	08b91200 	ldmeq	r9!, {r9, ip}
    1488:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
    148c:	0000711f 	andeq	r7, r0, pc, lsl r1
    1490:	0e4a0e00 	cdpeq	14, 4, cr0, cr10, cr0, {0}
    1494:	8b050000 	blhi	14149c <__bss_end+0x137a44>
    1498:	00026417 	andeq	r6, r2, r7, lsl r4
    149c:	5f0e0000 	svcpl	0x000e0000
    14a0:	0500000a 	streq	r0, [r0, #-10]
    14a4:	0264178e 	rsbeq	r1, r4, #37224448	; 0x2380000
    14a8:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
    14ac:	00000924 	andeq	r0, r0, r4, lsr #18
    14b0:	64178f05 	ldrvs	r8, [r7], #-3845	; 0xfffff0fb
    14b4:	48000002 	stmdami	r0, {r1}
    14b8:	0012a90e 	andseq	sl, r2, lr, lsl #18
    14bc:	17900500 	ldrne	r0, [r0, r0, lsl #10]
    14c0:	00000264 	andeq	r0, r0, r4, ror #4
    14c4:	0de7136c 	stcleq	3, cr1, [r7, #432]!	; 0x1b0
    14c8:	93050000 	movwls	r0, #20480	; 0x5000
    14cc:	00065009 	andeq	r5, r6, r9
    14d0:	0003fe00 	andeq	pc, r3, r0, lsl #28
    14d4:	037e0100 	cmneq	lr, #0, 2
    14d8:	03840000 	orreq	r0, r4, #0
    14dc:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
    14e0:	00000003 	andeq	r0, r0, r3
    14e4:	000b0214 	andeq	r0, fp, r4, lsl r2
    14e8:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
    14ec:	00000a15 	andeq	r0, r0, r5, lsl sl
    14f0:	00039901 	andeq	r9, r3, r1, lsl #18
    14f4:	00039f00 	andeq	r9, r3, r0, lsl #30
    14f8:	03fe1000 	mvnseq	r1, #0
    14fc:	15000000 	strne	r0, [r0, #-0]
    1500:	0000041b 	andeq	r0, r0, fp, lsl r4
    1504:	eb109905 	bl	427920 <__bss_end+0x41dec8>
    1508:	0400000e 	streq	r0, [r0], #-14
    150c:	01000004 	tsteq	r0, r4
    1510:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
    1514:	0003fe10 	andeq	pc, r3, r0, lsl lr	; <UNPREDICTABLE>
    1518:	03e21100 	mvneq	r1, #0, 2
    151c:	2d110000 	ldccs	0, cr0, [r1, #-0]
    1520:	00000002 	andeq	r0, r0, r2
    1524:	00251600 	eoreq	r1, r5, r0, lsl #12
    1528:	03d50000 	bicseq	r0, r5, #0
    152c:	76170000 	ldrvc	r0, [r7], -r0
    1530:	0f000000 	svceq	0x00000000
    1534:	02010200 	andeq	r0, r1, #0, 4
    1538:	00000a69 	andeq	r0, r0, r9, ror #20
    153c:	02640418 	rsbeq	r0, r4, #24, 8	; 0x18000000
    1540:	04180000 	ldreq	r0, [r8], #-0
    1544:	0000002c 	andeq	r0, r0, ip, lsr #32
    1548:	0012490c 	andseq	r4, r2, ip, lsl #18
    154c:	e8041800 	stmda	r4, {fp, ip}
    1550:	16000003 	strne	r0, [r0], -r3
    1554:	00000314 	andeq	r0, r0, r4, lsl r3
    1558:	000003fe 	strdeq	r0, [r0], -lr
    155c:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
    1560:	00000257 	andeq	r0, r0, r7, asr r2
    1564:	02520418 	subseq	r0, r2, #24, 8	; 0x18000000
    1568:	501a0000 	andspl	r0, sl, r0
    156c:	0500000e 	streq	r0, [r0, #-14]
    1570:	0257149c 	subseq	r1, r7, #156, 8	; 0x9c000000
    1574:	5a060000 	bpl	18157c <__bss_end+0x177b24>
    1578:	06000008 	streq	r0, [r0], -r8
    157c:	00711404 	rsbseq	r1, r1, r4, lsl #8
    1580:	03050000 	movweq	r0, #20480	; 0x5000
    1584:	00009a10 	andeq	r9, r0, r0, lsl sl
    1588:	0003a606 	andeq	sl, r3, r6, lsl #12
    158c:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
    1590:	00000071 	andeq	r0, r0, r1, ror r0
    1594:	9a140305 	bls	5021b0 <__bss_end+0x4f8758>
    1598:	2c060000 	stccs	0, cr0, [r6], {-0}
    159c:	06000006 	streq	r0, [r0], -r6
    15a0:	0071140a 	rsbseq	r1, r1, sl, lsl #8
    15a4:	03050000 	movweq	r0, #20480	; 0x5000
    15a8:	00009a18 	andeq	r9, r0, r8, lsl sl
    15ac:	000ad209 	andeq	sp, sl, r9, lsl #4
    15b0:	49040500 	stmdbmi	r4, {r8, sl}
    15b4:	06000000 	streq	r0, [r0], -r0
    15b8:	04830c0d 	streq	r0, [r3], #3085	; 0xc0d
    15bc:	4e0a0000 	cdpmi	0, 0, cr0, cr10, cr0, {0}
    15c0:	00007765 	andeq	r7, r0, r5, ror #14
    15c4:	000ac90b 	andeq	ip, sl, fp, lsl #18
    15c8:	620b0100 	andvs	r0, fp, #0, 2
    15cc:	0200000e 	andeq	r0, r0, #14
    15d0:	000a840b 	andeq	r8, sl, fp, lsl #8
    15d4:	4b0b0300 	blmi	2c21dc <__bss_end+0x2b8784>
    15d8:	0400000a 	streq	r0, [r0], #-10
    15dc:	000c6e0b 	andeq	r6, ip, fp, lsl #28
    15e0:	07000500 	streq	r0, [r0, -r0, lsl #10]
    15e4:	000007a0 	andeq	r0, r0, r0, lsr #15
    15e8:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
    15ec:	000004c2 	andeq	r0, r0, r2, asr #9
    15f0:	00726c08 	rsbseq	r6, r2, r8, lsl #24
    15f4:	c2131d06 	andsgt	r1, r3, #384	; 0x180
    15f8:	00000004 	andeq	r0, r0, r4
    15fc:	00707308 	rsbseq	r7, r0, r8, lsl #6
    1600:	c2131e06 	andsgt	r1, r3, #6, 28	; 0x60
    1604:	04000004 	streq	r0, [r0], #-4
    1608:	00637008 	rsbeq	r7, r3, r8
    160c:	c2131f06 	andsgt	r1, r3, #6, 30
    1610:	08000004 	stmdaeq	r0, {r2}
    1614:	0007b60e 	andeq	fp, r7, lr, lsl #12
    1618:	13200600 	nopne	{0}	; <UNPREDICTABLE>
    161c:	000004c2 	andeq	r0, r0, r2, asr #9
    1620:	0402000c 	streq	r0, [r2], #-12
    1624:	0004d807 	andeq	sp, r4, r7, lsl #16
    1628:	045a0700 	ldrbeq	r0, [sl], #-1792	; 0xfffff900
    162c:	06700000 	ldrbteq	r0, [r0], -r0
    1630:	05590828 	ldrbeq	r0, [r9, #-2088]	; 0xfffff7d8
    1634:	b30e0000 	movwlt	r0, #57344	; 0xe000
    1638:	06000012 			; <UNDEFINED> instruction: 0x06000012
    163c:	0483122a 	streq	r1, [r3], #554	; 0x22a
    1640:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1644:	00646970 	rsbeq	r6, r4, r0, ror r9
    1648:	76122b06 	ldrvc	r2, [r2], -r6, lsl #22
    164c:	10000000 	andne	r0, r0, r0
    1650:	001b710e 	andseq	r7, fp, lr, lsl #2
    1654:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
    1658:	0000044c 	andeq	r0, r0, ip, asr #8
    165c:	0ade0e14 	beq	ff784eb4 <__bss_end+0xff77b45c>
    1660:	2d060000 	stccs	0, cr0, [r6, #-0]
    1664:	00007612 	andeq	r7, r0, r2, lsl r6
    1668:	ec0e1800 	stc	8, cr1, [lr], {-0}
    166c:	0600000a 	streq	r0, [r0], -sl
    1670:	0076122e 	rsbseq	r1, r6, lr, lsr #4
    1674:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1678:	00000743 	andeq	r0, r0, r3, asr #14
    167c:	590c2f06 	stmdbpl	ip, {r1, r2, r8, r9, sl, fp, sp}
    1680:	20000005 	andcs	r0, r0, r5
    1684:	000b190e 	andeq	r1, fp, lr, lsl #18
    1688:	09300600 	ldmdbeq	r0!, {r9, sl}
    168c:	00000049 	andeq	r0, r0, r9, asr #32
    1690:	0f910e60 	svceq	0x00910e60
    1694:	31060000 	mrscc	r0, (UNDEF: 6)
    1698:	0000650e 	andeq	r6, r0, lr, lsl #10
    169c:	0d0e6400 	cfstrseq	mvf6, [lr, #-0]
    16a0:	06000008 	streq	r0, [r0], -r8
    16a4:	00650e33 	rsbeq	r0, r5, r3, lsr lr
    16a8:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
    16ac:	00000804 	andeq	r0, r0, r4, lsl #16
    16b0:	650e3406 	strvs	r3, [lr, #-1030]	; 0xfffffbfa
    16b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
    16b8:	04041600 	streq	r1, [r4], #-1536	; 0xfffffa00
    16bc:	05690000 	strbeq	r0, [r9, #-0]!
    16c0:	76170000 	ldrvc	r0, [r7], -r0
    16c4:	0f000000 	svceq	0x00000000
    16c8:	11ca0600 	bicne	r0, sl, r0, lsl #12
    16cc:	0a070000 	beq	1c16d4 <__bss_end+0x1b7c7c>
    16d0:	00007114 	andeq	r7, r0, r4, lsl r1
    16d4:	1c030500 	cfstr32ne	mvfx0, [r3], {-0}
    16d8:	0900009a 	stmdbeq	r0, {r1, r3, r4, r7}
    16dc:	00000a8c 	andeq	r0, r0, ip, lsl #21
    16e0:	00490405 	subeq	r0, r9, r5, lsl #8
    16e4:	0d070000 	stceq	0, cr0, [r7, #-0]
    16e8:	00059a0c 	andeq	r9, r5, ip, lsl #20
    16ec:	059d0b00 	ldreq	r0, [sp, #2816]	; 0xb00
    16f0:	0b000000 	bleq	16f8 <shift+0x16f8>
    16f4:	0000039b 	muleq	r0, fp, r3
    16f8:	7b030001 	blvc	c1704 <__bss_end+0xb7cac>
    16fc:	09000005 	stmdbeq	r0, {r0, r2}
    1700:	00001452 	andeq	r1, r0, r2, asr r4
    1704:	00490405 	subeq	r0, r9, r5, lsl #8
    1708:	14070000 	strne	r0, [r7], #-0
    170c:	0005be0c 	andeq	fp, r5, ip, lsl #28
    1710:	12e80b00 	rscne	r0, r8, #0, 22
    1714:	0b000000 	bleq	171c <shift+0x171c>
    1718:	000014e6 	andeq	r1, r0, r6, ror #9
    171c:	9f030001 	svcls	0x00030001
    1720:	07000005 	streq	r0, [r0, -r5]
    1724:	00001085 	andeq	r1, r0, r5, lsl #1
    1728:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
    172c:	000005f8 	strdeq	r0, [r0], -r8
    1730:	00042c0e 	andeq	r2, r4, lr, lsl #24
    1734:	191d0700 	ldmdbne	sp, {r8, r9, sl}
    1738:	000005f8 	strdeq	r0, [r0], -r8
    173c:	05500e00 	ldrbeq	r0, [r0, #-3584]	; 0xfffff200
    1740:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
    1744:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
    1748:	050e0400 	streq	r0, [lr, #-1024]	; 0xfffffc00
    174c:	07000010 	smladeq	r0, r0, r0, r0
    1750:	05fe131f 	ldrbeq	r1, [lr, #799]!	; 0x31f
    1754:	00080000 	andeq	r0, r8, r0
    1758:	05c30418 	strbeq	r0, [r3, #1048]	; 0x418
    175c:	04180000 	ldreq	r0, [r8], #-0
    1760:	000004c9 	andeq	r0, r0, r9, asr #9
    1764:	00063f0d 	andeq	r3, r6, sp, lsl #30
    1768:	22071400 	andcs	r1, r7, #0, 8
    176c:	00088607 	andeq	r8, r8, r7, lsl #12
    1770:	0a7a0e00 	beq	1e84f78 <__bss_end+0x1e7b520>
    1774:	26070000 	strcs	r0, [r7], -r0
    1778:	00006512 	andeq	r6, r0, r2, lsl r5
    177c:	ea0e0000 	b	381784 <__bss_end+0x377d2c>
    1780:	07000004 	streq	r0, [r0, -r4]
    1784:	05f81d29 	ldrbeq	r1, [r8, #3369]!	; 0xd29
    1788:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    178c:	00000ed8 	ldrdeq	r0, [r0], -r8
    1790:	f81d2c07 			; <UNDEFINED> instruction: 0xf81d2c07
    1794:	08000005 	stmdaeq	r0, {r0, r2}
    1798:	0011791b 	andseq	r7, r1, fp, lsl r9
    179c:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
    17a0:	00001062 	andeq	r1, r0, r2, rrx
    17a4:	0000064c 	andeq	r0, r0, ip, asr #12
    17a8:	00000657 	andeq	r0, r0, r7, asr r6
    17ac:	00088b10 	andeq	r8, r8, r0, lsl fp
    17b0:	05f81100 	ldrbeq	r1, [r8, #256]!	; 0x100
    17b4:	1c000000 	stcne	0, cr0, [r0], {-0}
    17b8:	0000101b 	andeq	r1, r0, fp, lsl r0
    17bc:	310e3107 	tstcc	lr, r7, lsl #2
    17c0:	d5000004 	strle	r0, [r0, #-4]
    17c4:	6f000003 	svcvs	0x00000003
    17c8:	7a000006 	bvc	17e8 <shift+0x17e8>
    17cc:	10000006 	andne	r0, r0, r6
    17d0:	0000088b 	andeq	r0, r0, fp, lsl #17
    17d4:	0005fe11 	andeq	pc, r5, r1, lsl lr	; <UNPREDICTABLE>
    17d8:	c7130000 	ldrgt	r0, [r3, -r0]
    17dc:	07000010 	smladeq	r0, r0, r0, r0
    17e0:	0fe01d35 	svceq	0x00e01d35
    17e4:	05f80000 	ldrbeq	r0, [r8, #0]!
    17e8:	93020000 	movwls	r0, #8192	; 0x2000
    17ec:	99000006 	stmdbls	r0, {r1, r2}
    17f0:	10000006 	andne	r0, r0, r6
    17f4:	0000088b 	andeq	r0, r0, fp, lsl #17
    17f8:	09ca1300 	stmibeq	sl, {r8, r9, ip}^
    17fc:	37070000 	strcc	r0, [r7, -r0]
    1800:	000dc11d 	andeq	ip, sp, sp, lsl r1
    1804:	0005f800 	andeq	pc, r5, r0, lsl #16
    1808:	06b20200 	ldrteq	r0, [r2], r0, lsl #4
    180c:	06b80000 	ldrteq	r0, [r8], r0
    1810:	8b100000 	blhi	401818 <__bss_end+0x3f7dc0>
    1814:	00000008 	andeq	r0, r0, r8
    1818:	000b491d 	andeq	r4, fp, sp, lsl r9
    181c:	31390700 	teqcc	r9, r0, lsl #14
    1820:	000008a4 	andeq	r0, r0, r4, lsr #17
    1824:	3f13020c 	svccc	0x0013020c
    1828:	07000006 	streq	r0, [r0, -r6]
    182c:	128f093c 	addne	r0, pc, #60, 18	; 0xf0000
    1830:	088b0000 	stmeq	fp, {}	; <UNPREDICTABLE>
    1834:	df010000 	svcle	0x00010000
    1838:	e5000006 	str	r0, [r0, #-6]
    183c:	10000006 	andne	r0, r0, r6
    1840:	0000088b 	andeq	r0, r0, fp, lsl #17
    1844:	05d71300 	ldrbeq	r1, [r7, #768]	; 0x300
    1848:	3f070000 	svccc	0x00070000
    184c:	00114e12 	andseq	r4, r1, r2, lsl lr
    1850:	00006500 	andeq	r6, r0, r0, lsl #10
    1854:	06fe0100 	ldrbteq	r0, [lr], r0, lsl #2
    1858:	07130000 	ldreq	r0, [r3, -r0]
    185c:	8b100000 	blhi	401864 <__bss_end+0x3f7e0c>
    1860:	11000008 	tstne	r0, r8
    1864:	000008ad 	andeq	r0, r0, sp, lsr #17
    1868:	00007611 	andeq	r7, r0, r1, lsl r6
    186c:	03d51100 	bicseq	r1, r5, #0, 2
    1870:	14000000 	strne	r0, [r0], #-0
    1874:	0000102a 	andeq	r1, r0, sl, lsr #32
    1878:	fa0e4207 	blx	39209c <__bss_end+0x388644>
    187c:	0100000c 	tsteq	r0, ip
    1880:	00000728 	andeq	r0, r0, r8, lsr #14
    1884:	0000072e 	andeq	r0, r0, lr, lsr #14
    1888:	00088b10 	andeq	r8, r8, r0, lsl fp
    188c:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
    1890:	07000009 	streq	r0, [r0, -r9]
    1894:	050f1745 	streq	r1, [pc, #-1861]	; 1157 <shift+0x1157>
    1898:	05fe0000 	ldrbeq	r0, [lr, #0]!
    189c:	47010000 	strmi	r0, [r1, -r0]
    18a0:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
    18a4:	10000007 	andne	r0, r0, r7
    18a8:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    18ac:	055e1300 	ldrbeq	r1, [lr, #-768]	; 0xfffffd00
    18b0:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
    18b4:	000f9d17 	andeq	r9, pc, r7, lsl sp	; <UNPREDICTABLE>
    18b8:	0005fe00 	andeq	pc, r5, r0, lsl #28
    18bc:	07660100 	strbeq	r0, [r6, -r0, lsl #2]!
    18c0:	07710000 	ldrbeq	r0, [r1, -r0]!
    18c4:	b3100000 	tstlt	r0, #0
    18c8:	11000008 	tstne	r0, r8
    18cc:	00000065 	andeq	r0, r0, r5, rrx
    18d0:	11e71400 	mvnne	r1, r0, lsl #8
    18d4:	4b070000 	blmi	1c18dc <__bss_end+0x1b7e84>
    18d8:	0010330e 	andseq	r3, r0, lr, lsl #6
    18dc:	07860100 	streq	r0, [r6, r0, lsl #2]
    18e0:	078c0000 	streq	r0, [ip, r0]
    18e4:	8b100000 	blhi	4018ec <__bss_end+0x3f7e94>
    18e8:	00000008 	andeq	r0, r0, r8
    18ec:	00101b13 	andseq	r1, r0, r3, lsl fp
    18f0:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
    18f4:	000007bc 			; <UNDEFINED> instruction: 0x000007bc
    18f8:	000003d5 	ldrdeq	r0, [r0], -r5
    18fc:	0007a501 	andeq	sl, r7, r1, lsl #10
    1900:	0007b000 	andeq	fp, r7, r0
    1904:	088b1000 	stmeq	fp, {ip}
    1908:	65110000 	ldrvs	r0, [r1, #-0]
    190c:	00000000 	andeq	r0, r0, r0
    1910:	00094213 	andeq	r4, r9, r3, lsl r2
    1914:	12500700 	subsne	r0, r0, #0, 14
    1918:	00000d1b 	andeq	r0, r0, fp, lsl sp
    191c:	00000065 	andeq	r0, r0, r5, rrx
    1920:	0007c901 	andeq	ip, r7, r1, lsl #18
    1924:	0007d400 	andeq	sp, r7, r0, lsl #8
    1928:	088b1000 	stmeq	fp, {ip}
    192c:	04110000 	ldreq	r0, [r1], #-0
    1930:	00000004 	andeq	r0, r0, r4
    1934:	00049713 	andeq	r9, r4, r3, lsl r7
    1938:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
    193c:	00000873 	andeq	r0, r0, r3, ror r8
    1940:	000003d5 	ldrdeq	r0, [r0], -r5
    1944:	0007ed01 	andeq	lr, r7, r1, lsl #26
    1948:	0007f800 	andeq	pc, r7, r0, lsl #16
    194c:	088b1000 	stmeq	fp, {ip}
    1950:	65110000 	ldrvs	r0, [r1, #-0]
    1954:	00000000 	andeq	r0, r0, r0
    1958:	0009a414 	andeq	sl, r9, r4, lsl r4
    195c:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
    1960:	000010e6 	andeq	r1, r0, r6, ror #1
    1964:	00080d01 	andeq	r0, r8, r1, lsl #26
    1968:	00082c00 	andeq	r2, r8, r0, lsl #24
    196c:	088b1000 	stmeq	fp, {ip}
    1970:	10110000 	andsne	r0, r1, r0
    1974:	11000001 	tstne	r0, r1
    1978:	00000065 	andeq	r0, r0, r5, rrx
    197c:	00006511 	andeq	r6, r0, r1, lsl r5
    1980:	00651100 	rsbeq	r1, r5, r0, lsl #2
    1984:	b9110000 	ldmdblt	r1, {}	; <UNPREDICTABLE>
    1988:	00000008 	andeq	r0, r0, r8
    198c:	000fca14 	andeq	ip, pc, r4, lsl sl	; <UNPREDICTABLE>
    1990:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
    1994:	000006de 	ldrdeq	r0, [r0], -lr
    1998:	00084101 	andeq	r4, r8, r1, lsl #2
    199c:	00086000 	andeq	r6, r8, r0
    19a0:	088b1000 	stmeq	fp, {ip}
    19a4:	47110000 	ldrmi	r0, [r1, -r0]
    19a8:	11000001 	tstne	r0, r1
    19ac:	00000065 	andeq	r0, r0, r5, rrx
    19b0:	00006511 	andeq	r6, r0, r1, lsl r5
    19b4:	00651100 	rsbeq	r1, r5, r0, lsl #2
    19b8:	b9110000 	ldmdblt	r1, {}	; <UNPREDICTABLE>
    19bc:	00000008 	andeq	r0, r0, r8
    19c0:	00060e15 	andeq	r0, r6, r5, lsl lr
    19c4:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
    19c8:	00000670 	andeq	r0, r0, r0, ror r6
    19cc:	000003d5 	ldrdeq	r0, [r0], -r5
    19d0:	00087501 	andeq	r7, r8, r1, lsl #10
    19d4:	088b1000 	stmeq	fp, {ip}
    19d8:	7b110000 	blvc	4419e0 <__bss_end+0x437f88>
    19dc:	11000005 	tstne	r0, r5
    19e0:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    19e4:	04030000 	streq	r0, [r3], #-0
    19e8:	18000006 	stmdane	r0, {r1, r2}
    19ec:	00060404 	andeq	r0, r6, r4, lsl #8
    19f0:	05f81e00 	ldrbeq	r1, [r8, #3584]!	; 0xe00
    19f4:	089e0000 	ldmeq	lr, {}	; <UNPREDICTABLE>
    19f8:	08a40000 	stmiaeq	r4!, {}	; <UNPREDICTABLE>
    19fc:	8b100000 	blhi	401a04 <__bss_end+0x3f7fac>
    1a00:	00000008 	andeq	r0, r0, r8
    1a04:	0006041f 	andeq	r0, r6, pc, lsl r4
    1a08:	00089100 	andeq	r9, r8, r0, lsl #2
    1a0c:	57041800 	strpl	r1, [r4, -r0, lsl #16]
    1a10:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1a14:	00088604 	andeq	r8, r8, r4, lsl #12
    1a18:	cc042000 	stcgt	0, cr2, [r4], {-0}
    1a1c:	21000000 	mrscs	r0, (UNDEF: 0)
    1a20:	0b571a04 	bleq	15c8238 <__bss_end+0x15be7e0>
    1a24:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
    1a28:	00060419 	andeq	r0, r6, r9, lsl r4
    1a2c:	0c040600 	stceq	6, cr0, [r4], {-0}
    1a30:	04080000 	streq	r0, [r8], #-0
    1a34:	0008e611 	andeq	lr, r8, r1, lsl r6
    1a38:	20030500 	andcs	r0, r3, r0, lsl #10
    1a3c:	0200009a 	andeq	r0, r0, #154	; 0x9a
    1a40:	1bef0404 	blne	ffbc2a58 <__bss_end+0xffbb9000>
    1a44:	df030000 	svcle	0x00030000
    1a48:	16000008 	strne	r0, [r0], -r8
    1a4c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1a50:	000008fb 	strdeq	r0, [r0], -fp
    1a54:	00007617 	andeq	r7, r0, r7, lsl r6
    1a58:	03000900 	movweq	r0, #2304	; 0x900
    1a5c:	000008eb 	andeq	r0, r0, fp, ror #17
    1a60:	00139a22 	andseq	r9, r3, r2, lsr #20
    1a64:	0ca40100 	stfeqs	f0, [r4]
    1a68:	000008fb 	strdeq	r0, [r0], -fp
    1a6c:	9a240305 	bls	902688 <__bss_end+0x8f8c30>
    1a70:	dd230000 	stcle	0, cr0, [r3, #-0]
    1a74:	01000012 	tsteq	r0, r2, lsl r0
    1a78:	14460aa6 	strbne	r0, [r6], #-2726	; 0xfffff55a
    1a7c:	00650000 	rsbeq	r0, r5, r0
    1a80:	86b40000 	ldrthi	r0, [r4], r0
    1a84:	00b00000 	adcseq	r0, r0, r0
    1a88:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a8c:	00000970 	andeq	r0, r0, r0, ror r9
    1a90:	00217e24 	eoreq	r7, r1, r4, lsr #28
    1a94:	1ba60100 	blne	fe981e9c <__bss_end+0xfe978444>
    1a98:	000003e2 	andeq	r0, r0, r2, ror #7
    1a9c:	7fac9103 	svcvc	0x00ac9103
    1aa0:	0014d224 	andseq	sp, r4, r4, lsr #4
    1aa4:	2aa60100 	bcs	fe981eac <__bss_end+0xfe978454>
    1aa8:	00000065 	andeq	r0, r0, r5, rrx
    1aac:	7fa89103 	svcvc	0x00a89103
    1ab0:	00142e22 	andseq	r2, r4, r2, lsr #28
    1ab4:	0aa80100 	beq	fea01ebc <__bss_end+0xfe9f8464>
    1ab8:	00000970 	andeq	r0, r0, r0, ror r9
    1abc:	7fb49103 	svcvc	0x00b49103
    1ac0:	0012fc22 	andseq	pc, r2, r2, lsr #24
    1ac4:	09ac0100 	stmibeq	ip!, {r8}
    1ac8:	00000049 	andeq	r0, r0, r9, asr #32
    1acc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ad0:	00002516 	andeq	r2, r0, r6, lsl r5
    1ad4:	00098000 	andeq	r8, r9, r0
    1ad8:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1adc:	003f0000 	eorseq	r0, pc, r0
    1ae0:	0014b125 	andseq	fp, r4, r5, lsr #2
    1ae4:	0a980100 	beq	fe601eec <__bss_end+0xfe5f8494>
    1ae8:	000014f4 	strdeq	r1, [r0], -r4
    1aec:	00000065 	andeq	r0, r0, r5, rrx
    1af0:	00008678 	andeq	r8, r0, r8, ror r6
    1af4:	0000003c 	andeq	r0, r0, ip, lsr r0
    1af8:	09bd9c01 	ldmibeq	sp!, {r0, sl, fp, ip, pc}
    1afc:	72260000 	eorvc	r0, r6, #0
    1b00:	01007165 	tsteq	r0, r5, ror #2
    1b04:	05be209a 	ldreq	r2, [lr, #154]!	; 0x9a
    1b08:	91020000 	mrsls	r0, (UNDEF: 2)
    1b0c:	143b2274 	ldrtne	r2, [fp], #-628	; 0xfffffd8c
    1b10:	9b010000 	blls	41b18 <__bss_end+0x380c0>
    1b14:	0000650e 	andeq	r6, r0, lr, lsl #10
    1b18:	70910200 	addsvc	r0, r1, r0, lsl #4
    1b1c:	13c52700 	bicne	r2, r5, #0, 14
    1b20:	8f010000 	svchi	0x00010000
    1b24:	00132406 	andseq	r2, r3, r6, lsl #8
    1b28:	00863c00 	addeq	r3, r6, r0, lsl #24
    1b2c:	00003c00 	andeq	r3, r0, r0, lsl #24
    1b30:	f69c0100 			; <UNDEFINED> instruction: 0xf69c0100
    1b34:	24000009 	strcs	r0, [r0], #-9
    1b38:	00001386 	andeq	r1, r0, r6, lsl #7
    1b3c:	65218f01 	strvs	r8, [r1, #-3841]!	; 0xfffff0ff
    1b40:	02000000 	andeq	r0, r0, #0
    1b44:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    1b48:	01007165 	tsteq	r0, r5, ror #2
    1b4c:	05be2091 	ldreq	r2, [lr, #145]!	; 0x91
    1b50:	91020000 	mrsls	r0, (UNDEF: 2)
    1b54:	67250074 			; <UNDEFINED> instruction: 0x67250074
    1b58:	01000014 	tsteq	r0, r4, lsl r0
    1b5c:	13ab0a83 			; <UNDEFINED> instruction: 0x13ab0a83
    1b60:	00650000 	rsbeq	r0, r5, r0
    1b64:	86000000 	strhi	r0, [r0], -r0
    1b68:	003c0000 	eorseq	r0, ip, r0
    1b6c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b70:	00000a33 	andeq	r0, r0, r3, lsr sl
    1b74:	71657226 	cmnvc	r5, r6, lsr #4
    1b78:	20850100 	addcs	r0, r5, r0, lsl #2
    1b7c:	0000059a 	muleq	r0, sl, r5
    1b80:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1b84:	000012f5 	strdeq	r1, [r0], -r5
    1b88:	650e8601 	strvs	r8, [lr, #-1537]	; 0xfffff9ff
    1b8c:	02000000 	andeq	r0, r0, #0
    1b90:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1b94:	00001581 	andeq	r1, r0, r1, lsl #11
    1b98:	680a7701 	stmdavs	sl, {r0, r8, r9, sl, ip, sp, lr}
    1b9c:	65000013 	strvs	r0, [r0, #-19]	; 0xffffffed
    1ba0:	c4000000 	strgt	r0, [r0], #-0
    1ba4:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    1ba8:	01000000 	mrseq	r0, (UNDEF: 0)
    1bac:	000a709c 	muleq	sl, ip, r0
    1bb0:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1bb4:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    1bb8:	00059a20 	andeq	r9, r5, r0, lsr #20
    1bbc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bc0:	0012f522 	andseq	pc, r2, r2, lsr #10
    1bc4:	0e7a0100 	rpweqe	f0, f2, f0
    1bc8:	00000065 	andeq	r0, r0, r5, rrx
    1bcc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1bd0:	0013bf25 	andseq	fp, r3, r5, lsr #30
    1bd4:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    1bd8:	000014db 	ldrdeq	r1, [r0], -fp
    1bdc:	000003d5 	ldrdeq	r0, [r0], -r5
    1be0:	00008570 	andeq	r8, r0, r0, ror r5
    1be4:	00000054 	andeq	r0, r0, r4, asr r0
    1be8:	0abc9c01 	beq	fef28bf4 <__bss_end+0xfef1f19c>
    1bec:	3b240000 	blcc	901bf4 <__bss_end+0x8f819c>
    1bf0:	01000014 	tsteq	r0, r4, lsl r0
    1bf4:	0065156b 	rsbeq	r1, r5, fp, ror #10
    1bf8:	91020000 	mrsls	r0, (UNDEF: 2)
    1bfc:	0804246c 	stmdaeq	r4, {r2, r3, r5, r6, sl, sp}
    1c00:	6b010000 	blvs	41c08 <__bss_end+0x381b0>
    1c04:	00006525 	andeq	r6, r0, r5, lsr #10
    1c08:	68910200 	ldmvs	r1, {r9}
    1c0c:	00157922 	andseq	r7, r5, r2, lsr #18
    1c10:	0e6d0100 	poweqe	f0, f5, f0
    1c14:	00000065 	andeq	r0, r0, r5, rrx
    1c18:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c1c:	00133b25 	andseq	r3, r3, r5, lsr #22
    1c20:	125e0100 	subsne	r0, lr, #0, 2
    1c24:	0000152b 	andeq	r1, r0, fp, lsr #10
    1c28:	000000f2 	strdeq	r0, [r0], -r2
    1c2c:	00008520 	andeq	r8, r0, r0, lsr #10
    1c30:	00000050 	andeq	r0, r0, r0, asr r0
    1c34:	0b179c01 	bleq	5e8c40 <__bss_end+0x5df1e8>
    1c38:	a1240000 			; <UNDEFINED> instruction: 0xa1240000
    1c3c:	0100000e 	tsteq	r0, lr
    1c40:	0065205e 	rsbeq	r2, r5, lr, asr r0
    1c44:	91020000 	mrsls	r0, (UNDEF: 2)
    1c48:	1470246c 	ldrbtne	r2, [r0], #-1132	; 0xfffffb94
    1c4c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c50:	0000652f 	andeq	r6, r0, pc, lsr #10
    1c54:	68910200 	ldmvs	r1, {r9}
    1c58:	00080424 	andeq	r0, r8, r4, lsr #8
    1c5c:	3f5e0100 	svccc	0x005e0100
    1c60:	00000065 	andeq	r0, r0, r5, rrx
    1c64:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1c68:	00001579 	andeq	r1, r0, r9, ror r5
    1c6c:	f2166001 	vhadd.s16	d6, d6, d1
    1c70:	02000000 	andeq	r0, r0, #0
    1c74:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c78:	00001434 	andeq	r1, r0, r4, lsr r4
    1c7c:	400a5201 	andmi	r5, sl, r1, lsl #4
    1c80:	65000013 	strvs	r0, [r0, #-19]	; 0xffffffed
    1c84:	dc000000 	stcle	0, cr0, [r0], {-0}
    1c88:	44000084 	strmi	r0, [r0], #-132	; 0xffffff7c
    1c8c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c90:	000b639c 	muleq	fp, ip, r3
    1c94:	0ea12400 	cdpeq	4, 10, cr2, cr1, cr0, {0}
    1c98:	52010000 	andpl	r0, r1, #0
    1c9c:	0000651a 	andeq	r6, r0, sl, lsl r5
    1ca0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ca4:	00147024 	andseq	r7, r4, r4, lsr #32
    1ca8:	29520100 	ldmdbcs	r2, {r8}^
    1cac:	00000065 	andeq	r0, r0, r5, rrx
    1cb0:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1cb4:	0000155a 	andeq	r1, r0, sl, asr r5
    1cb8:	650e5401 	strvs	r5, [lr, #-1025]	; 0xfffffbff
    1cbc:	02000000 	andeq	r0, r0, #0
    1cc0:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1cc4:	00001554 	andeq	r1, r0, r4, asr r5
    1cc8:	360a4501 	strcc	r4, [sl], -r1, lsl #10
    1ccc:	65000015 	strvs	r0, [r0, #-21]	; 0xffffffeb
    1cd0:	8c000000 	stchi	0, cr0, [r0], {-0}
    1cd4:	50000084 	andpl	r0, r0, r4, lsl #1
    1cd8:	01000000 	mrseq	r0, (UNDEF: 0)
    1cdc:	000bbe9c 	muleq	fp, ip, lr
    1ce0:	0ea12400 	cdpeq	4, 10, cr2, cr1, cr0, {0}
    1ce4:	45010000 	strmi	r0, [r1, #-0]
    1ce8:	00006519 	andeq	r6, r0, r9, lsl r5
    1cec:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cf0:	0013d724 	andseq	sp, r3, r4, lsr #14
    1cf4:	30450100 	subcc	r0, r5, r0, lsl #2
    1cf8:	00000184 	andeq	r0, r0, r4, lsl #3
    1cfc:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1d00:	0000149d 	muleq	r0, sp, r4
    1d04:	bf414501 	svclt	0x00414501
    1d08:	02000008 	andeq	r0, r0, #8
    1d0c:	79226491 	stmdbvc	r2!, {r0, r4, r7, sl, sp, lr}
    1d10:	01000015 	tsteq	r0, r5, lsl r0
    1d14:	00650e47 	rsbeq	r0, r5, r7, asr #28
    1d18:	91020000 	mrsls	r0, (UNDEF: 2)
    1d1c:	e2270074 	eor	r0, r7, #116	; 0x74
    1d20:	01000012 	tsteq	r0, r2, lsl r0
    1d24:	13e1063f 	mvnne	r0, #66060288	; 0x3f00000
    1d28:	84600000 	strbthi	r0, [r0], #-0
    1d2c:	002c0000 	eoreq	r0, ip, r0
    1d30:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d34:	00000be8 	andeq	r0, r0, r8, ror #23
    1d38:	000ea124 	andeq	sl, lr, r4, lsr #2
    1d3c:	153f0100 	ldrne	r0, [pc, #-256]!	; 1c44 <shift+0x1c44>
    1d40:	00000065 	andeq	r0, r0, r5, rrx
    1d44:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d48:	0014cc25 	andseq	ip, r4, r5, lsr #24
    1d4c:	0a320100 	beq	c82154 <__bss_end+0xc786fc>
    1d50:	000014a3 	andeq	r1, r0, r3, lsr #9
    1d54:	00000065 	andeq	r0, r0, r5, rrx
    1d58:	00008410 	andeq	r8, r0, r0, lsl r4
    1d5c:	00000050 	andeq	r0, r0, r0, asr r0
    1d60:	0c439c01 	mcrreq	12, 0, r9, r3, cr1
    1d64:	a1240000 			; <UNDEFINED> instruction: 0xa1240000
    1d68:	0100000e 	tsteq	r0, lr
    1d6c:	00651932 	rsbeq	r1, r5, r2, lsr r9
    1d70:	91020000 	mrsls	r0, (UNDEF: 2)
    1d74:	1566246c 	strbne	r2, [r6, #-1132]!	; 0xfffffb94
    1d78:	32010000 	andcc	r0, r1, #0
    1d7c:	0003e22b 	andeq	lr, r3, fp, lsr #4
    1d80:	68910200 	ldmvs	r1, {r9}
    1d84:	0014d624 	andseq	sp, r4, r4, lsr #12
    1d88:	3c320100 	ldfccs	f0, [r2], #-0
    1d8c:	00000065 	andeq	r0, r0, r5, rrx
    1d90:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d94:	00001525 	andeq	r1, r0, r5, lsr #10
    1d98:	650e3401 	strvs	r3, [lr, #-1025]	; 0xfffffbff
    1d9c:	02000000 	andeq	r0, r0, #0
    1da0:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1da4:	000015a3 	andeq	r1, r0, r3, lsr #11
    1da8:	6d0a2501 	cfstr32vs	mvfx2, [sl, #-4]
    1dac:	65000015 	strvs	r0, [r0, #-21]	; 0xffffffeb
    1db0:	c0000000 	andgt	r0, r0, r0
    1db4:	50000083 	andpl	r0, r0, r3, lsl #1
    1db8:	01000000 	mrseq	r0, (UNDEF: 0)
    1dbc:	000c9e9c 	muleq	ip, ip, lr
    1dc0:	0ea12400 	cdpeq	4, 10, cr2, cr1, cr0, {0}
    1dc4:	25010000 	strcs	r0, [r1, #-0]
    1dc8:	00006518 	andeq	r6, r0, r8, lsl r5
    1dcc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1dd0:	00156624 	andseq	r6, r5, r4, lsr #12
    1dd4:	2a250100 	bcs	9421dc <__bss_end+0x938784>
    1dd8:	00000ca4 	andeq	r0, r0, r4, lsr #25
    1ddc:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1de0:	000014d6 	ldrdeq	r1, [r0], -r6
    1de4:	653b2501 	ldrvs	r2, [fp, #-1281]!	; 0xfffffaff
    1de8:	02000000 	andeq	r0, r0, #0
    1dec:	0d226491 	cfstrseq	mvf6, [r2, #-580]!	; 0xfffffdbc
    1df0:	01000013 	tsteq	r0, r3, lsl r0
    1df4:	00650e27 	rsbeq	r0, r5, r7, lsr #28
    1df8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dfc:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1e00:	00000025 	andeq	r0, r0, r5, lsr #32
    1e04:	000c9e03 	andeq	r9, ip, r3, lsl #28
    1e08:	14412500 	strbne	r2, [r1], #-1280	; 0xfffffb00
    1e0c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1e10:	0015b90a 	andseq	fp, r5, sl, lsl #18
    1e14:	00006500 	andeq	r6, r0, r0, lsl #10
    1e18:	00837c00 	addeq	r7, r3, r0, lsl #24
    1e1c:	00004400 	andeq	r4, r0, r0, lsl #8
    1e20:	f59c0100 			; <UNDEFINED> instruction: 0xf59c0100
    1e24:	2400000c 	strcs	r0, [r0], #-12
    1e28:	0000159a 	muleq	r0, sl, r5
    1e2c:	e21b1901 	ands	r1, fp, #16384	; 0x4000
    1e30:	02000003 	andeq	r0, r0, #3
    1e34:	61246c91 			; <UNDEFINED> instruction: 0x61246c91
    1e38:	01000015 	tsteq	r0, r5, lsl r0
    1e3c:	022d3519 	eoreq	r3, sp, #104857600	; 0x6400000
    1e40:	91020000 	mrsls	r0, (UNDEF: 2)
    1e44:	0ea12268 	cdpeq	2, 10, cr2, cr1, cr8, {3}
    1e48:	1b010000 	blne	41e50 <__bss_end+0x383f8>
    1e4c:	0000650e 	andeq	r6, r0, lr, lsl #10
    1e50:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e54:	13012800 	movwne	r2, #6144	; 0x1800
    1e58:	14010000 	strne	r0, [r1], #-0
    1e5c:	00131306 	andseq	r1, r3, r6, lsl #6
    1e60:	00836000 	addeq	r6, r3, r0
    1e64:	00001c00 	andeq	r1, r0, r0, lsl #24
    1e68:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    1e6c:	000015a8 	andeq	r1, r0, r8, lsr #11
    1e70:	4c060e01 	stcmi	14, cr0, [r6], {1}
    1e74:	34000013 	strcc	r0, [r0], #-19	; 0xffffffed
    1e78:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1e7c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e80:	000d359c 	muleq	sp, ip, r5
    1e84:	135f2400 	cmpne	pc, #0, 8
    1e88:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1e8c:	00004914 	andeq	r4, r0, r4, lsl r9
    1e90:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e94:	15b22900 	ldrne	r2, [r2, #2304]!	; 0x900
    1e98:	04010000 	streq	r0, [r1], #-0
    1e9c:	0014230a 	andseq	r2, r4, sl, lsl #6
    1ea0:	00006500 	andeq	r6, r0, r0, lsl #10
    1ea4:	00830800 	addeq	r0, r3, r0, lsl #16
    1ea8:	00002c00 	andeq	r2, r0, r0, lsl #24
    1eac:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    1eb0:	00646970 	rsbeq	r6, r4, r0, ror r9
    1eb4:	650e0601 	strvs	r0, [lr, #-1537]	; 0xfffff9ff
    1eb8:	02000000 	andeq	r0, r0, #0
    1ebc:	00007491 	muleq	r0, r1, r4
    1ec0:	000006f9 	strdeq	r0, [r0], -r9
    1ec4:	07110004 	ldreq	r0, [r1, -r4]
    1ec8:	01040000 	mrseq	r0, (UNDEF: 4)
    1ecc:	000015d5 	ldrdeq	r1, [r0], -r5
    1ed0:	0016b804 	andseq	fp, r6, r4, lsl #16
    1ed4:	00147600 	andseq	r7, r4, r0, lsl #12
    1ed8:	00876400 	addeq	r6, r7, r0, lsl #8
    1edc:	000fdc00 	andeq	sp, pc, r0, lsl #24
    1ee0:	00070700 	andeq	r0, r7, r0, lsl #14
    1ee4:	0c040200 	sfmeq	f0, 4, [r4], {-0}
    1ee8:	04020000 	streq	r0, [r2], #-0
    1eec:	00003e11 	andeq	r3, r0, r1, lsl lr
    1ef0:	30030500 	andcc	r0, r3, r0, lsl #10
    1ef4:	0300009a 	movweq	r0, #154	; 0x9a
    1ef8:	1bef0404 	blne	ffbc2f10 <__bss_end+0xffbb94b8>
    1efc:	37040000 	strcc	r0, [r4, -r0]
    1f00:	05000000 	streq	r0, [r0, #-0]
    1f04:	00000067 	andeq	r0, r0, r7, rrx
    1f08:	0017f806 	andseq	pc, r7, r6, lsl #16
    1f0c:	10050100 	andne	r0, r5, r0, lsl #2
    1f10:	0000007f 	andeq	r0, r0, pc, ror r0
    1f14:	32313011 	eorscc	r3, r1, #17
    1f18:	36353433 			; <UNDEFINED> instruction: 0x36353433
    1f1c:	41393837 	teqmi	r9, r7, lsr r8
    1f20:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    1f24:	07000046 	streq	r0, [r0, -r6, asr #32]
    1f28:	43010301 	movwmi	r0, #4865	; 0x1301
    1f2c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1f30:	00000097 	muleq	r0, r7, r0
    1f34:	0000007f 	andeq	r0, r0, pc, ror r0
    1f38:	00008409 	andeq	r8, r0, r9, lsl #8
    1f3c:	04001000 	streq	r1, [r0], #-0
    1f40:	0000006f 	andeq	r0, r0, pc, rrx
    1f44:	dd070403 	cfstrsle	mvf0, [r7, #-12]
    1f48:	04000004 	streq	r0, [r0], #-4
    1f4c:	00000084 	andeq	r0, r0, r4, lsl #1
    1f50:	8e080103 	adfhie	f0, f0, f3
    1f54:	0400000d 	streq	r0, [r0], #-13
    1f58:	00000090 	muleq	r0, r0, r0
    1f5c:	0000480a 	andeq	r4, r0, sl, lsl #16
    1f60:	17ec0b00 	strbne	r0, [ip, r0, lsl #22]!
    1f64:	fc010000 	stc2	0, cr0, [r1], {-0}
    1f68:	00176307 	andseq	r6, r7, r7, lsl #6
    1f6c:	00003700 	andeq	r3, r0, r0, lsl #14
    1f70:	00963000 	addseq	r3, r6, r0
    1f74:	00011000 	andeq	r1, r1, r0
    1f78:	1d9c0100 	ldfnes	f0, [ip]
    1f7c:	0c000001 	stceq	0, cr0, [r0], {1}
    1f80:	fc010073 	stc2	0, cr0, [r1], {115}	; 0x73
    1f84:	00011d18 	andeq	r1, r1, r8, lsl sp
    1f88:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1f8c:	7a65720d 	bvc	195e7c8 <__bss_end+0x1954d70>
    1f90:	09fe0100 	ldmibeq	lr!, {r8}^
    1f94:	00000037 	andeq	r0, r0, r7, lsr r0
    1f98:	0e749102 	expeqs	f1, f2
    1f9c:	00001886 	andeq	r1, r0, r6, lsl #17
    1fa0:	3712fe01 	ldrcc	pc, [r2, -r1, lsl #28]
    1fa4:	02000000 	andeq	r0, r0, #0
    1fa8:	740f7091 	strvc	r7, [pc], #-145	; 1fb0 <shift+0x1fb0>
    1fac:	a8000096 	stmdage	r0, {r1, r2, r4, r7}
    1fb0:	10000000 	andne	r0, r0, r0
    1fb4:	0000172a 	andeq	r1, r0, sl, lsr #14
    1fb8:	0c010301 	stceq	3, cr0, [r1], {1}
    1fbc:	00000123 	andeq	r0, r0, r3, lsr #2
    1fc0:	0f6c9102 	svceq	0x006c9102
    1fc4:	0000968c 	andeq	r9, r0, ip, lsl #13
    1fc8:	00000080 	andeq	r0, r0, r0, lsl #1
    1fcc:	01006411 	tsteq	r0, r1, lsl r4
    1fd0:	23090108 	movwcs	r0, #37128	; 0x9108
    1fd4:	02000001 	andeq	r0, r0, #1
    1fd8:	00006891 	muleq	r0, r1, r8
    1fdc:	97041200 	strls	r1, [r4, -r0, lsl #4]
    1fe0:	13000000 	movwne	r0, #0
    1fe4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1fe8:	04140074 	ldreq	r0, [r4], #-116	; 0xffffff8c
    1fec:	01000018 	tsteq	r0, r8, lsl r0
    1ff0:	186e06c1 	stmdane	lr!, {r0, r6, r7, r9, sl}^
    1ff4:	930c0000 	movwls	r0, #49152	; 0xc000
    1ff8:	03240000 			; <UNDEFINED> instruction: 0x03240000
    1ffc:	9c010000 	stcls	0, cr0, [r1], {-0}
    2000:	00000229 	andeq	r0, r0, r9, lsr #4
    2004:	0100780c 	tsteq	r0, ip, lsl #16
    2008:	003711c1 	eorseq	r1, r7, r1, asr #3
    200c:	91030000 	mrsls	r0, (UNDEF: 3)
    2010:	620c7fa4 	andvs	r7, ip, #164, 30	; 0x290
    2014:	01007266 	tsteq	r0, r6, ror #4
    2018:	02291ac1 	eoreq	r1, r9, #790528	; 0xc1000
    201c:	91030000 	mrsls	r0, (UNDEF: 3)
    2020:	3c157fa0 	ldccc	15, cr7, [r5], {160}	; 0xa0
    2024:	01000017 	tsteq	r0, r7, lsl r0
    2028:	008b32c1 	addeq	r3, fp, r1, asr #5
    202c:	91030000 	mrsls	r0, (UNDEF: 3)
    2030:	470e7f9c 			; <UNDEFINED> instruction: 0x470e7f9c
    2034:	01000018 	tsteq	r0, r8, lsl r0
    2038:	00840fc3 	addeq	r0, r4, r3, asr #31
    203c:	91020000 	mrsls	r0, (UNDEF: 2)
    2040:	18300e74 	ldmdane	r0!, {r2, r4, r5, r6, r9, sl, fp}
    2044:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
    2048:	00012306 	andeq	r2, r1, r6, lsl #6
    204c:	70910200 	addsvc	r0, r1, r0, lsl #4
    2050:	0017450e 	andseq	r4, r7, lr, lsl #10
    2054:	11dd0100 	bicsne	r0, sp, r0, lsl #2
    2058:	0000003e 	andeq	r0, r0, lr, lsr r0
    205c:	0e649102 	lgneqs	f1, f2
    2060:	00001702 	andeq	r1, r0, r2, lsl #14
    2064:	8b18e001 	blhi	63a070 <__bss_end+0x630618>
    2068:	02000000 	andeq	r0, r0, #0
    206c:	110e6091 	swpne	r6, r1, [lr]
    2070:	01000017 	tsteq	r0, r7, lsl r0
    2074:	008b18e1 	addeq	r1, fp, r1, ror #17
    2078:	91020000 	mrsls	r0, (UNDEF: 2)
    207c:	17b70e5c 	sbfxne	r0, ip, #28, #24
    2080:	e3010000 	movw	r0, #4096	; 0x1000
    2084:	00022f07 	andeq	r2, r2, r7, lsl #30
    2088:	b8910300 	ldmlt	r1, {r8, r9}
    208c:	174b0e7f 	smlsldxne	r0, fp, pc, lr	; <UNPREDICTABLE>
    2090:	e5010000 	str	r0, [r1, #-0]
    2094:	00012306 	andeq	r2, r1, r6, lsl #6
    2098:	58910200 	ldmpl	r1, {r9}
    209c:	00951816 	addseq	r1, r5, r6, lsl r8
    20a0:	00005000 	andeq	r5, r0, r0
    20a4:	0001f700 	andeq	pc, r1, r0, lsl #14
    20a8:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    20ac:	230be701 	movwcs	lr, #46849	; 0xb701
    20b0:	02000001 	andeq	r0, r0, #1
    20b4:	0f006c91 	svceq	0x00006c91
    20b8:	00009574 	andeq	r9, r0, r4, ror r5
    20bc:	00000098 	muleq	r0, r8, r0
    20c0:	0017350e 	andseq	r3, r7, lr, lsl #10
    20c4:	08ef0100 	stmiaeq	pc!, {r8}^	; <UNPREDICTABLE>
    20c8:	0000023f 	andeq	r0, r0, pc, lsr r2
    20cc:	7fac9103 	svcvc	0x00ac9103
    20d0:	0095a40f 	addseq	sl, r5, pc, lsl #8
    20d4:	00006800 	andeq	r6, r0, r0, lsl #16
    20d8:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    20dc:	230cf201 	movwcs	pc, #49665	; 0xc201	; <UNPREDICTABLE>
    20e0:	02000001 	andeq	r0, r0, #1
    20e4:	00006891 	muleq	r0, r1, r8
    20e8:	90041200 	andls	r1, r4, r0, lsl #4
    20ec:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    20f0:	00000090 	muleq	r0, r0, r0
    20f4:	0000023f 	andeq	r0, r0, pc, lsr r2
    20f8:	00008409 	andeq	r8, r0, r9, lsl #8
    20fc:	08001f00 	stmdaeq	r0, {r8, r9, sl, fp, ip}
    2100:	00000090 	muleq	r0, r0, r0
    2104:	0000024f 	andeq	r0, r0, pc, asr #4
    2108:	00008409 	andeq	r8, r0, r9, lsl #8
    210c:	14000800 	strne	r0, [r0], #-2048	; 0xfffff800
    2110:	00001804 	andeq	r1, r0, r4, lsl #16
    2114:	d306bb01 	movwle	fp, #27393	; 0x6b01
    2118:	dc000018 	stcle	0, cr0, [r0], {24}
    211c:	30000092 	mulcc	r0, r2, r0
    2120:	01000000 	mrseq	r0, (UNDEF: 0)
    2124:	0002869c 	muleq	r2, ip, r6
    2128:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    212c:	3711bb01 	ldrcc	fp, [r1, -r1, lsl #22]
    2130:	02000000 	andeq	r0, r0, #0
    2134:	620c7491 	andvs	r7, ip, #-1862270976	; 0x91000000
    2138:	01007266 	tsteq	r0, r6, ror #4
    213c:	02291abb 	eoreq	r1, r9, #765952	; 0xbb000
    2140:	91020000 	mrsls	r0, (UNDEF: 2)
    2144:	0b0b0070 	bleq	2c230c <__bss_end+0x2b88b4>
    2148:	01000017 	tsteq	r0, r7, lsl r0
    214c:	17c206b5 			; <UNDEFINED> instruction: 0x17c206b5
    2150:	02b20000 	adcseq	r0, r2, #0
    2154:	929c0000 	addsls	r0, ip, #0
    2158:	00400000 	subeq	r0, r0, r0
    215c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2160:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    2164:	0100780c 	tsteq	r0, ip, lsl #16
    2168:	003712b5 	ldrhteq	r1, [r7], -r5
    216c:	91020000 	mrsls	r0, (UNDEF: 2)
    2170:	01030074 	tsteq	r3, r4, ror r0
    2174:	000a6902 	andeq	r6, sl, r2, lsl #18
    2178:	16fc0b00 	ldrbtne	r0, [ip], r0, lsl #22
    217c:	b0010000 	andlt	r0, r1, r0
    2180:	00177f06 	andseq	r7, r7, r6, lsl #30
    2184:	0002b200 	andeq	fp, r2, r0, lsl #4
    2188:	00926000 	addseq	r6, r2, r0
    218c:	00003c00 	andeq	r3, r0, r0, lsl #24
    2190:	e59c0100 	ldr	r0, [ip, #256]	; 0x100
    2194:	0c000002 	stceq	0, cr0, [r0], {2}
    2198:	b0010078 	andlt	r0, r1, r8, ror r0
    219c:	00003712 	andeq	r3, r0, r2, lsl r7
    21a0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    21a4:	18bb1400 	ldmne	fp!, {sl, ip}
    21a8:	a5010000 	strge	r0, [r1, #-0]
    21ac:	00180906 	andseq	r0, r8, r6, lsl #18
    21b0:	00918c00 	addseq	r8, r1, r0, lsl #24
    21b4:	0000d400 	andeq	sp, r0, r0, lsl #8
    21b8:	3a9c0100 	bcc	fe7025c0 <__bss_end+0xfe6f8b68>
    21bc:	0c000003 	stceq	0, cr0, [r0], {3}
    21c0:	a5010078 	strge	r0, [r1, #-120]	; 0xffffff88
    21c4:	0000842b 	andeq	r8, r0, fp, lsr #8
    21c8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    21cc:	7266620c 	rsbvc	r6, r6, #12, 4	; 0xc0000000
    21d0:	34a50100 	strtcc	r0, [r5], #256	; 0x100
    21d4:	00000229 	andeq	r0, r0, r9, lsr #4
    21d8:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    21dc:	00001855 	andeq	r1, r0, r5, asr r8
    21e0:	233da501 	teqcs	sp, #4194304	; 0x400000
    21e4:	02000001 	andeq	r0, r0, #1
    21e8:	470e6491 			; <UNDEFINED> instruction: 0x470e6491
    21ec:	01000018 	tsteq	r0, r8, lsl r0
    21f0:	012306a7 	smulwbeq	r3, r7, r6
    21f4:	91020000 	mrsls	r0, (UNDEF: 2)
    21f8:	7a170074 	bvc	5c23d0 <__bss_end+0x5b8978>
    21fc:	01000018 	tsteq	r0, r8, lsl r0
    2200:	17d50683 	ldrbne	r0, [r5, r3, lsl #13]
    2204:	8d4c0000 	stclhi	0, cr0, [ip, #-0]
    2208:	04400000 	strbeq	r0, [r0], #-0
    220c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2210:	0000039e 	muleq	r0, lr, r3
    2214:	0100780c 	tsteq	r0, ip, lsl #16
    2218:	00371883 	eorseq	r1, r7, r3, lsl #17
    221c:	91020000 	mrsls	r0, (UNDEF: 2)
    2220:	1702156c 	strne	r1, [r2, -ip, ror #10]
    2224:	83010000 	movwhi	r0, #4096	; 0x1000
    2228:	00039e29 	andeq	r9, r3, r9, lsr #28
    222c:	68910200 	ldmvs	r1, {r9}
    2230:	00171115 	andseq	r1, r7, r5, lsl r1
    2234:	41830100 	orrmi	r0, r3, r0, lsl #2
    2238:	0000039e 	muleq	r0, lr, r3
    223c:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    2240:	0000175a 	andeq	r1, r0, sl, asr r7
    2244:	a44f8301 	strbge	r8, [pc], #-769	; 224c <shift+0x224c>
    2248:	02000003 	andeq	r0, r0, #3
    224c:	f20e6091 	vqadd.s8	d6, d30, d1
    2250:	01000016 	tsteq	r0, r6, lsl r0
    2254:	00370b96 	mlaseq	r7, r6, fp, r0
    2258:	91020000 	mrsls	r0, (UNDEF: 2)
    225c:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    2260:	00000084 	andeq	r0, r0, r4, lsl #1
    2264:	01230418 			; <UNDEFINED> instruction: 0x01230418
    2268:	f3140000 	vhadd.u16	d0, d4, d0
    226c:	01000018 	tsteq	r0, r8, lsl r0
    2270:	17730676 			; <UNDEFINED> instruction: 0x17730676
    2274:	8c880000 	stchi	0, cr0, [r8], {0}
    2278:	00c40000 	sbceq	r0, r4, r0
    227c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2280:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2284:	0017b215 	andseq	fp, r7, r5, lsl r2
    2288:	13760100 	cmnne	r6, #0, 2
    228c:	00000229 	andeq	r0, r0, r9, lsr #4
    2290:	0d649102 	stfeqp	f1, [r4, #-8]!
    2294:	78010069 	stmdavc	r1, {r0, r3, r5, r6}
    2298:	00012309 	andeq	r2, r1, r9, lsl #6
    229c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    22a0:	6e656c0d 	cdpvs	12, 6, cr6, cr5, cr13, {0}
    22a4:	0c780100 	ldfeqe	f0, [r8], #-0
    22a8:	00000123 	andeq	r0, r0, r3, lsr #2
    22ac:	0e709102 	expeqs	f1, f2
    22b0:	00001794 	muleq	r0, r4, r7
    22b4:	23117801 	tstcs	r1, #65536	; 0x10000
    22b8:	02000001 	andeq	r0, r0, #1
    22bc:	19006c91 	stmdbne	r0, {r0, r4, r7, sl, fp, sp, lr}
    22c0:	00776f70 	rsbseq	r6, r7, r0, ror pc
    22c4:	cc076d01 	stcgt	13, cr6, [r7], {1}
    22c8:	37000017 	smladcc	r0, r7, r0, r0
    22cc:	1c000000 	stcne	0, cr0, [r0], {-0}
    22d0:	6c00008c 	stcvs	0, cr0, [r0], {140}	; 0x8c
    22d4:	01000000 	mrseq	r0, (UNDEF: 0)
    22d8:	00045c9c 	muleq	r4, ip, ip
    22dc:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    22e0:	3e176d01 	cdpcc	13, 1, cr6, cr7, cr1, {0}
    22e4:	02000000 	andeq	r0, r0, #0
    22e8:	6e0c6c91 	mcrvs	12, 0, r6, cr12, cr1, {4}
    22ec:	2d6d0100 	stfcse	f0, [sp, #-0]
    22f0:	0000008b 	andeq	r0, r0, fp, lsl #1
    22f4:	0d689102 	stfeqp	f1, [r8, #-8]!
    22f8:	6f010072 	svcvs	0x00010072
    22fc:	0000370b 	andeq	r3, r0, fp, lsl #14
    2300:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2304:	008c380f 	addeq	r3, ip, pc, lsl #16
    2308:	00003800 	andeq	r3, r0, r0, lsl #16
    230c:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2310:	84167001 	ldrhi	r7, [r6], #-1
    2314:	02000000 	andeq	r0, r0, #0
    2318:	00007091 	muleq	r0, r1, r0
    231c:	00184017 	andseq	r4, r8, r7, lsl r0
    2320:	06640100 	strbteq	r0, [r4], -r0, lsl #2
    2324:	000016a8 	andeq	r1, r0, r8, lsr #13
    2328:	00008b9c 	muleq	r0, ip, fp
    232c:	00000080 	andeq	r0, r0, r0, lsl #1
    2330:	04d99c01 	ldrbeq	r9, [r9], #3073	; 0xc01
    2334:	730c0000 	movwvc	r0, #49152	; 0xc000
    2338:	01006372 	tsteq	r0, r2, ror r3
    233c:	04d91964 	ldrbeq	r1, [r9], #2404	; 0x964
    2340:	91020000 	mrsls	r0, (UNDEF: 2)
    2344:	73640c64 	cmnvc	r4, #100, 24	; 0x6400
    2348:	64010074 	strvs	r0, [r1], #-116	; 0xffffff8c
    234c:	0004e024 	andeq	lr, r4, r4, lsr #32
    2350:	60910200 	addsvs	r0, r1, r0, lsl #4
    2354:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    2358:	2d640100 	stfcse	f0, [r4, #-0]
    235c:	00000123 	andeq	r0, r0, r3, lsr #2
    2360:	0e5c9102 	logeqe	f1, f2
    2364:	00001829 	andeq	r1, r0, r9, lsr #16
    2368:	1d0e6601 	stcne	6, cr6, [lr, #-4]
    236c:	02000001 	andeq	r0, r0, #1
    2370:	f10e7091 			; <UNDEFINED> instruction: 0xf10e7091
    2374:	01000017 	tsteq	r0, r7, lsl r0
    2378:	02290867 	eoreq	r0, r9, #6750208	; 0x670000
    237c:	91020000 	mrsls	r0, (UNDEF: 2)
    2380:	8bc40f6c 	blhi	ff106138 <__bss_end+0xff0fc6e0>
    2384:	00480000 	subeq	r0, r8, r0
    2388:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    238c:	0b690100 	bleq	1a42794 <__bss_end+0x1a38d3c>
    2390:	00000123 	andeq	r0, r0, r3, lsr #2
    2394:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2398:	df041200 	svcle	0x00041200
    239c:	1a000004 	bne	23b4 <shift+0x23b4>
    23a0:	3a17041b 	bcc	5c3414 <__bss_end+0x5b99bc>
    23a4:	01000018 	tsteq	r0, r8, lsl r0
    23a8:	1799065c 			; <UNDEFINED> instruction: 0x1799065c
    23ac:	8b340000 	blhi	d023b4 <__bss_end+0xcf895c>
    23b0:	00680000 	rsbeq	r0, r8, r0
    23b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    23b8:	00000541 	andeq	r0, r0, r1, asr #10
    23bc:	0018de15 	andseq	sp, r8, r5, lsl lr
    23c0:	125c0100 	subsne	r0, ip, #0, 2
    23c4:	000004e0 	andeq	r0, r0, r0, ror #9
    23c8:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    23cc:	000018e5 	andeq	r1, r0, r5, ror #17
    23d0:	231e5c01 	tstcs	lr, #256	; 0x100
    23d4:	02000001 	andeq	r0, r0, #1
    23d8:	6d0d6891 	stcvs	8, cr6, [sp, #-580]	; 0xfffffdbc
    23dc:	01006d65 	tsteq	r0, r5, ror #26
    23e0:	0229085e 	eoreq	r0, r9, #6160384	; 0x5e0000
    23e4:	91020000 	mrsls	r0, (UNDEF: 2)
    23e8:	8b500f70 	blhi	14061b0 <__bss_end+0x13fc758>
    23ec:	003c0000 	eorseq	r0, ip, r0
    23f0:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    23f4:	0b600100 	bleq	18027fc <__bss_end+0x17f8da4>
    23f8:	00000123 	andeq	r0, r0, r3, lsr #2
    23fc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2400:	18ec0b00 	stmiane	ip!, {r8, r9, fp}^
    2404:	52010000 	andpl	r0, r1, #0
    2408:	00188b05 	andseq	r8, r8, r5, lsl #22
    240c:	00012300 	andeq	r2, r1, r0, lsl #6
    2410:	008ae000 	addeq	lr, sl, r0
    2414:	00005400 	andeq	r5, r0, r0, lsl #8
    2418:	7a9c0100 	bvc	fe702820 <__bss_end+0xfe6f8dc8>
    241c:	0c000005 	stceq	0, cr0, [r0], {5}
    2420:	52010073 	andpl	r0, r1, #115	; 0x73
    2424:	00011d18 	andeq	r1, r1, r8, lsl sp
    2428:	6c910200 	lfmvs	f0, 4, [r1], {0}
    242c:	0100690d 	tsteq	r0, sp, lsl #18
    2430:	01230654 			; <UNDEFINED> instruction: 0x01230654
    2434:	91020000 	mrsls	r0, (UNDEF: 2)
    2438:	4d0b0074 	stcmi	0, cr0, [fp, #-464]	; 0xfffffe30
    243c:	01000018 	tsteq	r0, r8, lsl r0
    2440:	18980542 	ldmne	r8, {r1, r6, r8, sl}
    2444:	01230000 			; <UNDEFINED> instruction: 0x01230000
    2448:	8a340000 	bhi	d02450 <__bss_end+0xcf89f8>
    244c:	00ac0000 	adceq	r0, ip, r0
    2450:	9c010000 	stcls	0, cr0, [r1], {-0}
    2454:	000005e0 	andeq	r0, r0, r0, ror #11
    2458:	0031730c 	eorseq	r7, r1, ip, lsl #6
    245c:	1d194201 	lfmne	f4, 4, [r9, #-4]
    2460:	02000001 	andeq	r0, r0, #1
    2464:	730c6c91 	movwvc	r6, #52369	; 0xcc91
    2468:	42010032 	andmi	r0, r1, #50	; 0x32
    246c:	00011d29 	andeq	r1, r1, r9, lsr #26
    2470:	68910200 	ldmvs	r1, {r9}
    2474:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    2478:	31420100 	mrscc	r0, (UNDEF: 82)
    247c:	00000123 	andeq	r0, r0, r3, lsr #2
    2480:	0d649102 	stfeqp	f1, [r4, #-8]!
    2484:	01003175 	tsteq	r0, r5, ror r1
    2488:	05e01044 	strbeq	r1, [r0, #68]!	; 0x44
    248c:	91020000 	mrsls	r0, (UNDEF: 2)
    2490:	32750d77 	rsbscc	r0, r5, #7616	; 0x1dc0
    2494:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    2498:	000005e0 	andeq	r0, r0, r0, ror #11
    249c:	00769102 	rsbseq	r9, r6, r2, lsl #2
    24a0:	85080103 	strhi	r0, [r8, #-259]	; 0xfffffefd
    24a4:	0b00000d 	bleq	24e0 <shift+0x24e0>
    24a8:	000017a5 	andeq	r1, r0, r5, lsr #15
    24ac:	aa073601 	bge	1cfcb8 <__bss_end+0x1c6260>
    24b0:	29000018 	stmdbcs	r0, {r3, r4}
    24b4:	74000002 	strvc	r0, [r0], #-2
    24b8:	c0000089 	andgt	r0, r0, r9, lsl #1
    24bc:	01000000 	mrseq	r0, (UNDEF: 0)
    24c0:	0006409c 	muleq	r6, ip, r0
    24c4:	176e1500 	strbne	r1, [lr, -r0, lsl #10]!
    24c8:	36010000 	strcc	r0, [r1], -r0
    24cc:	00022915 	andeq	r2, r2, r5, lsl r9
    24d0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    24d4:	6372730c 	cmnvs	r2, #12, 6	; 0x30000000
    24d8:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    24dc:	0000011d 	andeq	r0, r0, sp, lsl r1
    24e0:	0c689102 	stfeqp	f1, [r8], #-8
    24e4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    24e8:	23303601 	teqcs	r0, #1048576	; 0x100000
    24ec:	02000001 	andeq	r0, r0, #1
    24f0:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    24f4:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    24f8:	00000123 	andeq	r0, r0, r3, lsr #2
    24fc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2500:	0017250b 	andseq	r2, r7, fp, lsl #10
    2504:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    2508:	0000185c 	andeq	r1, r0, ip, asr r8
    250c:	00000123 	andeq	r0, r0, r3, lsr #2
    2510:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    2514:	0000009c 	muleq	r0, ip, r0
    2518:	067d9c01 	ldrbteq	r9, [sp], -r1, lsl #24
    251c:	89150000 	ldmdbhi	r5, {}	; <UNPREDICTABLE>
    2520:	01000017 	tsteq	r0, r7, lsl r0
    2524:	011d1624 	tsteq	sp, r4, lsr #12
    2528:	91020000 	mrsls	r0, (UNDEF: 2)
    252c:	18670e6c 	stmdane	r7!, {r2, r3, r5, r6, r9, sl, fp}^
    2530:	26010000 	strcs	r0, [r1], -r0
    2534:	00012306 	andeq	r2, r1, r6, lsl #6
    2538:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    253c:	17ad1c00 	strne	r1, [sp, r0, lsl #24]!
    2540:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2544:	00171906 	andseq	r1, r7, r6, lsl #18
    2548:	00876400 	addeq	r6, r7, r0, lsl #8
    254c:	00017400 	andeq	r7, r1, r0, lsl #8
    2550:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    2554:	00001789 	andeq	r1, r0, r9, lsl #15
    2558:	84180801 	ldrhi	r0, [r8], #-2049	; 0xfffff7ff
    255c:	02000000 	andeq	r0, r0, #0
    2560:	67156491 			; <UNDEFINED> instruction: 0x67156491
    2564:	01000018 	tsteq	r0, r8, lsl r0
    2568:	02292508 	eoreq	r2, r9, #8, 10	; 0x2000000
    256c:	91020000 	mrsls	r0, (UNDEF: 2)
    2570:	178f1560 	strne	r1, [pc, r0, ror #10]
    2574:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2578:	0000843a 	andeq	r8, r0, sl, lsr r4
    257c:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2580:	0100690d 	tsteq	r0, sp, lsl #18
    2584:	0123060a 			; <UNDEFINED> instruction: 0x0123060a
    2588:	91020000 	mrsls	r0, (UNDEF: 2)
    258c:	88300f74 	ldmdahi	r0!, {r2, r4, r5, r6, r8, r9, sl, fp}
    2590:	00980000 	addseq	r0, r8, r0
    2594:	6a0d0000 	bvs	34259c <__bss_end+0x338b44>
    2598:	0b1c0100 	bleq	7029a0 <__bss_end+0x6f8f48>
    259c:	00000123 	andeq	r0, r0, r3, lsr #2
    25a0:	0f709102 	svceq	0x00709102
    25a4:	00008858 	andeq	r8, r0, r8, asr r8
    25a8:	00000060 	andeq	r0, r0, r0, rrx
    25ac:	0100630d 	tsteq	r0, sp, lsl #6
    25b0:	0090081e 	addseq	r0, r0, lr, lsl r8
    25b4:	91020000 	mrsls	r0, (UNDEF: 2)
    25b8:	0000006f 	andeq	r0, r0, pc, rrx
    25bc:	00002200 	andeq	r2, r0, r0, lsl #4
    25c0:	bb000200 	bllt	2dc8 <shift+0x2dc8>
    25c4:	04000008 	streq	r0, [r0], #-8
    25c8:	000d4901 	andeq	r4, sp, r1, lsl #18
    25cc:	00974000 	addseq	r4, r7, r0
    25d0:	00994c00 	addseq	r4, r9, r0, lsl #24
    25d4:	0018fa00 	andseq	pc, r8, r0, lsl #20
    25d8:	00192a00 	andseq	r2, r9, r0, lsl #20
    25dc:	00006300 	andeq	r6, r0, r0, lsl #6
    25e0:	22800100 	addcs	r0, r0, #0, 2
    25e4:	02000000 	andeq	r0, r0, #0
    25e8:	0008cf00 	andeq	ip, r8, r0, lsl #30
    25ec:	c6010400 	strgt	r0, [r1], -r0, lsl #8
    25f0:	4c00000d 	stcmi	0, cr0, [r0], {13}
    25f4:	50000099 	mulpl	r0, r9, r0
    25f8:	fa000099 	blx	2864 <shift+0x2864>
    25fc:	2a000018 	bcs	2664 <shift+0x2664>
    2600:	63000019 	movwvs	r0, #25
    2604:	01000000 	mrseq	r0, (UNDEF: 0)
    2608:	00093280 	andeq	r3, r9, r0, lsl #5
    260c:	e3000400 	movw	r0, #1024	; 0x400
    2610:	04000008 	streq	r0, [r0], #-8
    2614:	001cf801 	andseq	pc, ip, r1, lsl #16
    2618:	1c4f0c00 	mcrrne	12, 0, r0, pc, cr0
    261c:	192a0000 	stmdbne	sl!, {}	; <UNPREDICTABLE>
    2620:	0e260000 	cdpeq	0, 2, cr0, cr6, cr0, {0}
    2624:	04020000 	streq	r0, [r2], #-0
    2628:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    262c:	07040300 	streq	r0, [r4, -r0, lsl #6]
    2630:	000004dd 	ldrdeq	r0, [r0], -sp
    2634:	1f050803 	svcne	0x00050803
    2638:	03000003 	movweq	r0, #3
    263c:	24e00408 	strbtcs	r0, [r0], #1032	; 0x408
    2640:	aa040000 	bge	102648 <__bss_end+0xf8bf0>
    2644:	0100001c 	tsteq	r0, ip, lsl r0
    2648:	0024162a 	eoreq	r1, r4, sl, lsr #12
    264c:	02040000 	andeq	r0, r4, #0
    2650:	01000021 	tsteq	r0, r1, lsr #32
    2654:	0051152f 	subseq	r1, r1, pc, lsr #10
    2658:	04050000 	streq	r0, [r5], #-0
    265c:	00000057 	andeq	r0, r0, r7, asr r0
    2660:	00003906 	andeq	r3, r0, r6, lsl #18
    2664:	00006600 	andeq	r6, r0, r0, lsl #12
    2668:	00660700 	rsbeq	r0, r6, r0, lsl #14
    266c:	05000000 	streq	r0, [r0, #-0]
    2670:	00006c04 	andeq	r6, r0, r4, lsl #24
    2674:	34040800 	strcc	r0, [r4], #-2048	; 0xfffff800
    2678:	01000028 	tsteq	r0, r8, lsr #32
    267c:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    2680:	04050000 	streq	r0, [r5], #-0
    2684:	0000007f 	andeq	r0, r0, pc, ror r0
    2688:	00001d06 	andeq	r1, r0, r6, lsl #26
    268c:	00009300 	andeq	r9, r0, r0, lsl #6
    2690:	00660700 	rsbeq	r0, r6, r0, lsl #14
    2694:	66070000 	strvs	r0, [r7], -r0
    2698:	00000000 	andeq	r0, r0, r0
    269c:	85080103 	strhi	r0, [r8, #-259]	; 0xfffffefd
    26a0:	0900000d 	stmdbeq	r0, {r0, r2, r3}
    26a4:	0000233a 	andeq	r2, r0, sl, lsr r3
    26a8:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    26ac:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    26b0:	00002862 	andeq	r2, r0, r2, ror #16
    26b4:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    26b8:	03000000 	movweq	r0, #0
    26bc:	0d870601 	stceq	6, cr0, [r7, #4]
    26c0:	220a0000 	andcs	r0, sl, #0
    26c4:	07000020 	streq	r0, [r0, -r0, lsr #32]
    26c8:	00009301 	andeq	r9, r0, r1, lsl #6
    26cc:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    26d0:	000001e6 	andeq	r0, r0, r6, ror #3
    26d4:	001b080b 	andseq	r0, fp, fp, lsl #16
    26d8:	3f0b0000 	svccc	0x000b0000
    26dc:	0100001f 	tsteq	r0, pc, lsl r0
    26e0:	0024050b 	eoreq	r0, r4, fp, lsl #10
    26e4:	760b0200 	strvc	r0, [fp], -r0, lsl #4
    26e8:	03000027 	movweq	r0, #39	; 0x27
    26ec:	0023a90b 	eoreq	sl, r3, fp, lsl #18
    26f0:	7f0b0400 	svcvc	0x000b0400
    26f4:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    26f8:	0025e30b 	eoreq	lr, r5, fp, lsl #6
    26fc:	290b0600 	stmdbcs	fp, {r9, sl}
    2700:	0700001b 	smladeq	r0, fp, r0, r0
    2704:	0026940b 	eoreq	r9, r6, fp, lsl #8
    2708:	a20b0800 	andge	r0, fp, #0, 16
    270c:	09000026 	stmdbeq	r0, {r1, r2, r5}
    2710:	0027690b 	eoreq	r6, r7, fp, lsl #18
    2714:	000b0a00 	andeq	r0, fp, r0, lsl #20
    2718:	0b000023 	bleq	27ac <shift+0x27ac>
    271c:	001ceb0b 	andseq	lr, ip, fp, lsl #22
    2720:	c80b0c00 	stmdagt	fp, {sl, fp}
    2724:	0d00001d 	stceq	0, cr0, [r0, #-116]	; 0xffffff8c
    2728:	0020660b 	eoreq	r6, r0, fp, lsl #12
    272c:	7c0b0e00 	stcvc	14, cr0, [fp], {-0}
    2730:	0f000020 	svceq	0x00000020
    2734:	001f790b 	andseq	r7, pc, fp, lsl #18
    2738:	8d0b1000 	stchi	0, cr1, [fp, #-0]
    273c:	11000023 	tstne	r0, r3, lsr #32
    2740:	001fe50b 	andseq	lr, pc, fp, lsl #10
    2744:	fb0b1200 	blx	2c6f4e <__bss_end+0x2bd4f6>
    2748:	13000029 	movwne	r0, #41	; 0x29
    274c:	001b920b 	andseq	r9, fp, fp, lsl #4
    2750:	090b1400 	stmdbeq	fp, {sl, ip}
    2754:	15000020 	strne	r0, [r0, #-32]	; 0xffffffe0
    2758:	001acf0b 	andseq	ip, sl, fp, lsl #30
    275c:	990b1600 	stmdbls	fp, {r9, sl, ip}
    2760:	17000027 	strne	r0, [r0, -r7, lsr #32]
    2764:	0028bb0b 	eoreq	fp, r8, fp, lsl #22
    2768:	2e0b1800 	cdpcs	8, 0, cr1, cr11, cr0, {0}
    276c:	19000020 	stmdbne	r0, {r5}
    2770:	0024770b 	eoreq	r7, r4, fp, lsl #14
    2774:	a70b1a00 	strge	r1, [fp, -r0, lsl #20]
    2778:	1b000027 	blne	281c <shift+0x281c>
    277c:	0019fe0b 	andseq	pc, r9, fp, lsl #28
    2780:	b50b1c00 	strlt	r1, [fp, #-3072]	; 0xfffff400
    2784:	1d000027 	stcne	0, cr0, [r0, #-156]	; 0xffffff64
    2788:	0027c30b 	eoreq	ip, r7, fp, lsl #6
    278c:	ac0b1e00 	stcge	14, cr1, [fp], {-0}
    2790:	1f000019 	svcne	0x00000019
    2794:	0027ed0b 	eoreq	lr, r7, fp, lsl #26
    2798:	240b2000 	strcs	r2, [fp], #-0
    279c:	21000025 	tstcs	r0, r5, lsr #32
    27a0:	00235f0b 	eoreq	r5, r3, fp, lsl #30
    27a4:	8c0b2200 	sfmhi	f2, 4, [fp], {-0}
    27a8:	23000027 	movwcs	r0, #39	; 0x27
    27ac:	0022630b 	eoreq	r6, r2, fp, lsl #6
    27b0:	650b2400 	strvs	r2, [fp, #-1024]	; 0xfffffc00
    27b4:	25000021 	strcs	r0, [r0, #-33]	; 0xffffffdf
    27b8:	001e7f0b 	andseq	r7, lr, fp, lsl #30
    27bc:	830b2600 	movwhi	r2, #46592	; 0xb600
    27c0:	27000021 	strcs	r0, [r0, -r1, lsr #32]
    27c4:	001f1b0b 	andseq	r1, pc, fp, lsl #22
    27c8:	930b2800 	movwls	r2, #47104	; 0xb800
    27cc:	29000021 	stmdbcs	r0, {r0, r5}
    27d0:	0021a30b 	eoreq	sl, r1, fp, lsl #6
    27d4:	e60b2a00 	str	r2, [fp], -r0, lsl #20
    27d8:	2b000022 	blcs	2868 <shift+0x2868>
    27dc:	00210c0b 	eoreq	r0, r1, fp, lsl #24
    27e0:	310b2c00 	tstcc	fp, r0, lsl #24
    27e4:	2d000025 	stccs	0, cr0, [r0, #-148]	; 0xffffff6c
    27e8:	001ec00b 	andseq	ip, lr, fp
    27ec:	0a002e00 	beq	dff4 <__bss_end+0x459c>
    27f0:	0000209e 	muleq	r0, lr, r0
    27f4:	00930107 	addseq	r0, r3, r7, lsl #2
    27f8:	17030000 	strne	r0, [r3, -r0]
    27fc:	0003c706 	andeq	ip, r3, r6, lsl #14
    2800:	1dea0b00 			; <UNDEFINED> instruction: 0x1dea0b00
    2804:	0b000000 	bleq	280c <shift+0x280c>
    2808:	00001a3c 	andeq	r1, r0, ip, lsr sl
    280c:	29a90b01 	stmibcs	r9!, {r0, r8, r9, fp}
    2810:	0b020000 	bleq	82818 <__bss_end+0x78dc0>
    2814:	0000283c 	andeq	r2, r0, ip, lsr r8
    2818:	1e0a0b03 	vmlane.f64	d0, d10, d3
    281c:	0b040000 	bleq	102824 <__bss_end+0xf8dcc>
    2820:	00001af4 	strdeq	r1, [r0], -r4
    2824:	1e9c0b05 	vfnmsne.f64	d0, d12, d5
    2828:	0b060000 	bleq	182830 <__bss_end+0x178dd8>
    282c:	00001dfa 	strdeq	r1, [r0], -sl
    2830:	26d00b07 	ldrbcs	r0, [r0], r7, lsl #22
    2834:	0b080000 	bleq	20283c <__bss_end+0x1f8de4>
    2838:	00002821 	andeq	r2, r0, r1, lsr #16
    283c:	26070b09 	strcs	r0, [r7], -r9, lsl #22
    2840:	0b0a0000 	bleq	282848 <__bss_end+0x278df0>
    2844:	00001b47 	andeq	r1, r0, r7, asr #22
    2848:	1e3d0b0b 	vaddne.f64	d0, d13, d11
    284c:	0b0c0000 	bleq	302854 <__bss_end+0x2f8dfc>
    2850:	00001abd 			; <UNDEFINED> instruction: 0x00001abd
    2854:	29de0b0d 	ldmibcs	lr, {r0, r2, r3, r8, r9, fp}^
    2858:	0b0e0000 	bleq	382860 <__bss_end+0x378e08>
    285c:	000022d3 	ldrdeq	r2, [r0], -r3
    2860:	1fb00b0f 	svcne	0x00b00b0f
    2864:	0b100000 	bleq	40286c <__bss_end+0x3f8e14>
    2868:	00002310 	andeq	r2, r0, r0, lsl r3
    286c:	28fd0b11 	ldmcs	sp!, {r0, r4, r8, r9, fp}^
    2870:	0b120000 	bleq	482878 <__bss_end+0x478e20>
    2874:	00001c0a 	andeq	r1, r0, sl, lsl #24
    2878:	1fc30b13 	svcne	0x00c30b13
    287c:	0b140000 	bleq	502884 <__bss_end+0x4f8e2c>
    2880:	00002226 	andeq	r2, r0, r6, lsr #4
    2884:	1dd50b15 	vldrne	d16, [r5, #84]	; 0x54
    2888:	0b160000 	bleq	582890 <__bss_end+0x578e38>
    288c:	00002272 	andeq	r2, r0, r2, ror r2
    2890:	20880b17 	addcs	r0, r8, r7, lsl fp
    2894:	0b180000 	bleq	60289c <__bss_end+0x5f8e44>
    2898:	00001b12 	andeq	r1, r0, r2, lsl fp
    289c:	28a40b19 	stmiacs	r4!, {r0, r3, r4, r8, r9, fp}
    28a0:	0b1a0000 	bleq	6828a8 <__bss_end+0x678e50>
    28a4:	000021f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    28a8:	1f9a0b1b 	svcne	0x009a0b1b
    28ac:	0b1c0000 	bleq	7028b4 <__bss_end+0x6f8e5c>
    28b0:	000019e7 	andeq	r1, r0, r7, ror #19
    28b4:	213d0b1d 	teqcs	sp, sp, lsl fp
    28b8:	0b1e0000 	bleq	7828c0 <__bss_end+0x778e68>
    28bc:	00002129 	andeq	r2, r0, r9, lsr #2
    28c0:	25c40b1f 	strbcs	r0, [r4, #2847]	; 0xb1f
    28c4:	0b200000 	bleq	8028cc <__bss_end+0x7f8e74>
    28c8:	0000264f 	andeq	r2, r0, pc, asr #12
    28cc:	28830b21 	stmcs	r3, {r0, r5, r8, r9, fp}
    28d0:	0b220000 	bleq	8828d8 <__bss_end+0x878e80>
    28d4:	00001ecd 	andeq	r1, r0, sp, asr #29
    28d8:	24270b23 	strtcs	r0, [r7], #-2851	; 0xfffff4dd
    28dc:	0b240000 	bleq	9028e4 <__bss_end+0x8f8e8c>
    28e0:	0000261c 	andeq	r2, r0, ip, lsl r6
    28e4:	25400b25 	strbcs	r0, [r0, #-2853]	; 0xfffff4db
    28e8:	0b260000 	bleq	9828f0 <__bss_end+0x978e98>
    28ec:	00002554 	andeq	r2, r0, r4, asr r5
    28f0:	25680b27 	strbcs	r0, [r8, #-2855]!	; 0xfffff4d9
    28f4:	0b280000 	bleq	a028fc <__bss_end+0x9f8ea4>
    28f8:	00001c95 	muleq	r0, r5, ip
    28fc:	1bf50b29 	blne	ffd455a8 <__bss_end+0xffd3bb50>
    2900:	0b2a0000 	bleq	a82908 <__bss_end+0xa78eb0>
    2904:	00001c1d 	andeq	r1, r0, sp, lsl ip
    2908:	27190b2b 	ldrcs	r0, [r9, -fp, lsr #22]
    290c:	0b2c0000 	bleq	b02914 <__bss_end+0xaf8ebc>
    2910:	00001c72 	andeq	r1, r0, r2, ror ip
    2914:	272d0b2d 	strcs	r0, [sp, -sp, lsr #22]!
    2918:	0b2e0000 	bleq	b82920 <__bss_end+0xb78ec8>
    291c:	00002741 	andeq	r2, r0, r1, asr #14
    2920:	27550b2f 	ldrbcs	r0, [r5, -pc, lsr #22]
    2924:	0b300000 	bleq	c0292c <__bss_end+0xbf8ed4>
    2928:	00001e4f 	andeq	r1, r0, pc, asr #28
    292c:	1e290b31 	vmovne.16	d9[2], r0
    2930:	0b320000 	bleq	c82938 <__bss_end+0xc78ee0>
    2934:	00002151 	andeq	r2, r0, r1, asr r1
    2938:	23230b33 			; <UNDEFINED> instruction: 0x23230b33
    293c:	0b340000 	bleq	d02944 <__bss_end+0xcf8eec>
    2940:	00002932 	andeq	r2, r0, r2, lsr r9
    2944:	198f0b35 	stmibne	pc, {r0, r2, r4, r5, r8, r9, fp}	; <UNPREDICTABLE>
    2948:	0b360000 	bleq	d82950 <__bss_end+0xd78ef8>
    294c:	00001f4f 	andeq	r1, r0, pc, asr #30
    2950:	1f640b37 	svcne	0x00640b37
    2954:	0b380000 	bleq	e0295c <__bss_end+0xdf8f04>
    2958:	000021b3 			; <UNDEFINED> instruction: 0x000021b3
    295c:	21dd0b39 	bicscs	r0, sp, r9, lsr fp
    2960:	0b3a0000 	bleq	e82968 <__bss_end+0xe78f10>
    2964:	0000295b 	andeq	r2, r0, fp, asr r9
    2968:	24120b3b 	ldrcs	r0, [r2], #-2875	; 0xfffff4c5
    296c:	0b3c0000 	bleq	f02974 <__bss_end+0xef8f1c>
    2970:	00001ef2 	strdeq	r1, [r0], -r2
    2974:	1a4e0b3d 	bne	1385670 <__bss_end+0x137bc18>
    2978:	0b3e0000 	bleq	f82980 <__bss_end+0xf78f28>
    297c:	00001a0c 	andeq	r1, r0, ip, lsl #20
    2980:	236f0b3f 	cmncs	pc, #64512	; 0xfc00
    2984:	0b400000 	bleq	100298c <__bss_end+0xff8f34>
    2988:	00002493 	muleq	r0, r3, r4
    298c:	25a60b41 	strcs	r0, [r6, #2881]!	; 0xb41
    2990:	0b420000 	bleq	1082998 <__bss_end+0x1078f40>
    2994:	000021c8 	andeq	r2, r0, r8, asr #3
    2998:	29940b43 	ldmibcs	r4, {r0, r1, r6, r8, r9, fp}
    299c:	0b440000 	bleq	11029a4 <__bss_end+0x10f8f4c>
    29a0:	0000243d 	andeq	r2, r0, sp, lsr r4
    29a4:	1c390b45 			; <UNDEFINED> instruction: 0x1c390b45
    29a8:	0b460000 	bleq	11829b0 <__bss_end+0x1178f58>
    29ac:	000022a3 	andeq	r2, r0, r3, lsr #5
    29b0:	20d60b47 	sbcscs	r0, r6, r7, asr #22
    29b4:	0b480000 	bleq	12029bc <__bss_end+0x11f8f64>
    29b8:	000019cb 	andeq	r1, r0, fp, asr #19
    29bc:	1adf0b49 	bne	ff7c56e8 <__bss_end+0xff7bbc90>
    29c0:	0b4a0000 	bleq	12829c8 <__bss_end+0x1278f70>
    29c4:	00001f06 	andeq	r1, r0, r6, lsl #30
    29c8:	22040b4b 	andcs	r0, r4, #76800	; 0x12c00
    29cc:	004c0000 	subeq	r0, ip, r0
    29d0:	b7070203 	strlt	r0, [r7, -r3, lsl #4]
    29d4:	0c000009 	stceq	0, cr0, [r0], {9}
    29d8:	000003e4 	andeq	r0, r0, r4, ror #7
    29dc:	000003d9 	ldrdeq	r0, [r0], -r9
    29e0:	ce0e000d 	cdpgt	0, 0, cr0, cr14, cr13, {0}
    29e4:	05000003 	streq	r0, [r0, #-3]
    29e8:	0003f004 	andeq	pc, r3, r4
    29ec:	03de0e00 	bicseq	r0, lr, #0, 28
    29f0:	01030000 	mrseq	r0, (UNDEF: 3)
    29f4:	000d8e08 	andeq	r8, sp, r8, lsl #28
    29f8:	03e90e00 	mvneq	r0, #0, 28
    29fc:	830f0000 	movwhi	r0, #61440	; 0xf000
    2a00:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
    2a04:	d91a014c 	ldmdble	sl, {r2, r3, r6, r8}
    2a08:	0f000003 	svceq	0x00000003
    2a0c:	00001f8a 	andeq	r1, r0, sl, lsl #31
    2a10:	1a018204 	bne	63228 <__bss_end+0x597d0>
    2a14:	000003d9 	ldrdeq	r0, [r0], -r9
    2a18:	0003e90c 	andeq	lr, r3, ip, lsl #18
    2a1c:	00041a00 	andeq	r1, r4, r0, lsl #20
    2a20:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2a24:	00002175 	andeq	r2, r0, r5, ror r1
    2a28:	0f0d2d05 	svceq	0x000d2d05
    2a2c:	09000004 	stmdbeq	r0, {r2}
    2a30:	000027fd 	strdeq	r2, [r0], -sp
    2a34:	e61c3805 	ldr	r3, [ip], -r5, lsl #16
    2a38:	0a000001 	beq	2a44 <shift+0x2a44>
    2a3c:	00001e63 	andeq	r1, r0, r3, ror #28
    2a40:	00930107 	addseq	r0, r3, r7, lsl #2
    2a44:	3a050000 	bcc	142a4c <__bss_end+0x138ff4>
    2a48:	0004a50e 	andeq	sl, r4, lr, lsl #10
    2a4c:	19e00b00 	stmibne	r0!, {r8, r9, fp}^
    2a50:	0b000000 	bleq	2a58 <shift+0x2a58>
    2a54:	00002075 	andeq	r2, r0, r5, ror r0
    2a58:	290f0b01 	stmdbcs	pc, {r0, r8, r9, fp}	; <UNPREDICTABLE>
    2a5c:	0b020000 	bleq	82a64 <__bss_end+0x7900c>
    2a60:	000028d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    2a64:	23cc0b03 	biccs	r0, ip, #3072	; 0xc00
    2a68:	0b040000 	bleq	102a70 <__bss_end+0xf9018>
    2a6c:	0000268d 	andeq	r2, r0, sp, lsl #13
    2a70:	1bc60b05 	blne	ff18568c <__bss_end+0xff17bc34>
    2a74:	0b060000 	bleq	182a7c <__bss_end+0x179024>
    2a78:	00001ba8 	andeq	r1, r0, r8, lsr #23
    2a7c:	1dc10b07 	vstrne	d16, [r1, #28]
    2a80:	0b080000 	bleq	202a88 <__bss_end+0x1f9030>
    2a84:	00002288 	andeq	r2, r0, r8, lsl #5
    2a88:	1bcd0b09 	blne	ff3456b4 <__bss_end+0xff33bc5c>
    2a8c:	0b0a0000 	bleq	282a94 <__bss_end+0x27903c>
    2a90:	0000228f 	andeq	r2, r0, pc, lsl #5
    2a94:	1c320b0b 			; <UNDEFINED> instruction: 0x1c320b0b
    2a98:	0b0c0000 	bleq	302aa0 <__bss_end+0x2f9048>
    2a9c:	00001bbf 			; <UNDEFINED> instruction: 0x00001bbf
    2aa0:	26e40b0d 	strbtcs	r0, [r4], sp, lsl #22
    2aa4:	0b0e0000 	bleq	382aac <__bss_end+0x379054>
    2aa8:	000024b1 			; <UNDEFINED> instruction: 0x000024b1
    2aac:	dc04000f 	stcle	0, cr0, [r4], {15}
    2ab0:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2ab4:	0432013f 	ldrteq	r0, [r2], #-319	; 0xfffffec1
    2ab8:	70090000 	andvc	r0, r9, r0
    2abc:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    2ac0:	04a50f41 	strteq	r0, [r5], #3905	; 0xf41
    2ac4:	f8090000 			; <UNDEFINED> instruction: 0xf8090000
    2ac8:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    2acc:	001d0c4a 	andseq	r0, sp, sl, asr #24
    2ad0:	67090000 	strvs	r0, [r9, -r0]
    2ad4:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2ad8:	001d0c4b 	andseq	r0, sp, fp, asr #24
    2adc:	d1100000 	tstle	r0, r0
    2ae0:	09000027 	stmdbeq	r0, {r0, r1, r2, r5}
    2ae4:	00002709 	andeq	r2, r0, r9, lsl #14
    2ae8:	e6144c05 	ldr	r4, [r4], -r5, lsl #24
    2aec:	05000004 	streq	r0, [r0, #-4]
    2af0:	0004d504 	andeq	sp, r4, r4, lsl #10
    2af4:	3f091100 	svccc	0x00091100
    2af8:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2afc:	04f90f4e 	ldrbteq	r0, [r9], #3918	; 0xf4e
    2b00:	04050000 	streq	r0, [r5], #-0
    2b04:	000004ec 	andeq	r0, r0, ip, ror #9
    2b08:	0025f212 	eoreq	pc, r5, r2, lsl r2	; <UNPREDICTABLE>
    2b0c:	23b90900 			; <UNDEFINED> instruction: 0x23b90900
    2b10:	52050000 	andpl	r0, r5, #0
    2b14:	0005100d 	andeq	r1, r5, sp
    2b18:	ff040500 			; <UNDEFINED> instruction: 0xff040500
    2b1c:	13000004 	movwne	r0, #4
    2b20:	00001cde 	ldrdeq	r1, [r0], -lr
    2b24:	01670534 	cmneq	r7, r4, lsr r5
    2b28:	00054115 	andeq	r4, r5, r5, lsl r1
    2b2c:	217e1400 	cmncs	lr, r0, lsl #8
    2b30:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    2b34:	03de0f01 	bicseq	r0, lr, #1, 30
    2b38:	14000000 	strne	r0, [r0], #-0
    2b3c:	00001cc2 	andeq	r1, r0, r2, asr #25
    2b40:	14016a05 	strne	r6, [r1], #-2565	; 0xfffff5fb
    2b44:	00000546 	andeq	r0, r0, r6, asr #10
    2b48:	160e0004 	strne	r0, [lr], -r4
    2b4c:	0c000005 	stceq	0, cr0, [r0], {5}
    2b50:	000000b9 	strheq	r0, [r0], -r9
    2b54:	00000556 	andeq	r0, r0, r6, asr r5
    2b58:	00002415 	andeq	r2, r0, r5, lsl r4
    2b5c:	0c002d00 	stceq	13, cr2, [r0], {-0}
    2b60:	00000541 	andeq	r0, r0, r1, asr #10
    2b64:	00000561 	andeq	r0, r0, r1, ror #10
    2b68:	560e000d 	strpl	r0, [lr], -sp
    2b6c:	0f000005 	svceq	0x00000005
    2b70:	000020ad 	andeq	r2, r0, sp, lsr #1
    2b74:	03016b05 	movweq	r6, #6917	; 0x1b05
    2b78:	00000561 	andeq	r0, r0, r1, ror #10
    2b7c:	0022f30f 	eoreq	pc, r2, pc, lsl #6
    2b80:	016e0500 	cmneq	lr, r0, lsl #10
    2b84:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2b88:	26301600 	ldrtcs	r1, [r0], -r0, lsl #12
    2b8c:	01070000 	mrseq	r0, (UNDEF: 7)
    2b90:	00000093 	muleq	r0, r3, r0
    2b94:	06018105 	streq	r8, [r1], -r5, lsl #2
    2b98:	0000062a 	andeq	r0, r0, sl, lsr #12
    2b9c:	001a750b 	andseq	r7, sl, fp, lsl #10
    2ba0:	810b0000 	mrshi	r0, (UNDEF: 11)
    2ba4:	0200001a 	andeq	r0, r0, #26
    2ba8:	001a8d0b 	andseq	r8, sl, fp, lsl #26
    2bac:	8f0b0300 	svchi	0x000b0300
    2bb0:	0300001e 	movweq	r0, #30
    2bb4:	001a990b 	andseq	r9, sl, fp, lsl #18
    2bb8:	d80b0400 	stmdale	fp, {sl}
    2bbc:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    2bc0:	0020be0b 	eoreq	fp, r0, fp, lsl #28
    2bc4:	140b0500 	strne	r0, [fp], #-1280	; 0xfffffb00
    2bc8:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2bcc:	001b580b 	andseq	r5, fp, fp, lsl #16
    2bd0:	a50b0500 	strge	r0, [fp, #-1280]	; 0xfffffb00
    2bd4:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2bd8:	00223c0b 	eoreq	r3, r2, fp, lsl #24
    2bdc:	b40b0600 	strlt	r0, [fp], #-1536	; 0xfffffa00
    2be0:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    2be4:	0022490b 	eoreq	r4, r2, fp, lsl #18
    2be8:	b00b0600 	andlt	r0, fp, r0, lsl #12
    2bec:	06000026 	streq	r0, [r0], -r6, lsr #32
    2bf0:	0022560b 	eoreq	r5, r2, fp, lsl #12
    2bf4:	960b0600 	strls	r0, [fp], -r0, lsl #12
    2bf8:	06000022 	streq	r0, [r0], -r2, lsr #32
    2bfc:	001ab10b 	andseq	fp, sl, fp, lsl #2
    2c00:	9c0b0700 	stcls	7, cr0, [fp], {-0}
    2c04:	07000023 	streq	r0, [r0, -r3, lsr #32]
    2c08:	0023e90b 	eoreq	lr, r3, fp, lsl #18
    2c0c:	eb0b0700 	bl	2c4814 <__bss_end+0x2badbc>
    2c10:	07000026 	streq	r0, [r0, -r6, lsr #32]
    2c14:	001c870b 	andseq	r8, ip, fp, lsl #14
    2c18:	6a0b0700 	bvs	2c4820 <__bss_end+0x2badc8>
    2c1c:	08000024 	stmdaeq	r0, {r2, r5}
    2c20:	001a2a0b 	andseq	r2, sl, fp, lsl #20
    2c24:	be0b0800 	cdplt	8, 0, cr0, cr11, cr0, {0}
    2c28:	08000026 	stmdaeq	r0, {r1, r2, r5}
    2c2c:	0024860b 	eoreq	r8, r4, fp, lsl #12
    2c30:	0f000800 	svceq	0x00000800
    2c34:	00002924 	andeq	r2, r0, r4, lsr #18
    2c38:	1f019f05 	svcne	0x00019f05
    2c3c:	00000580 	andeq	r0, r0, r0, lsl #11
    2c40:	0024b80f 	eoreq	fp, r4, pc, lsl #16
    2c44:	01a20500 			; <UNDEFINED> instruction: 0x01a20500
    2c48:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c4c:	20cb0f00 	sbccs	r0, fp, r0, lsl #30
    2c50:	a5050000 	strge	r0, [r5, #-0]
    2c54:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c58:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    2c5c:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2c60:	1d0c01a8 	stfnes	f0, [ip, #-672]	; 0xfffffd60
    2c64:	0f000000 	svceq	0x00000000
    2c68:	00001b77 	andeq	r1, r0, r7, ror fp
    2c6c:	0c01ab05 			; <UNDEFINED> instruction: 0x0c01ab05
    2c70:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c74:	0024c20f 	eoreq	ip, r4, pc, lsl #4
    2c78:	01ae0500 			; <UNDEFINED> instruction: 0x01ae0500
    2c7c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c80:	23d30f00 	bicscs	r0, r3, #0, 30
    2c84:	b1050000 	mrslt	r0, (UNDEF: 5)
    2c88:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c8c:	de0f0000 	cdple	0, 0, cr0, cr15, cr0, {0}
    2c90:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2c94:	1d0c01b4 	stfnes	f0, [ip, #-720]	; 0xfffffd30
    2c98:	0f000000 	svceq	0x00000000
    2c9c:	000024cc 	andeq	r2, r0, ip, asr #9
    2ca0:	0c01b705 	stceq	7, cr11, [r1], {5}
    2ca4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ca8:	0022180f 	eoreq	r1, r2, pc, lsl #16
    2cac:	01ba0500 			; <UNDEFINED> instruction: 0x01ba0500
    2cb0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cb4:	294f0f00 	stmdbcs	pc, {r8, r9, sl, fp}^	; <UNPREDICTABLE>
    2cb8:	bd050000 	stclt	0, cr0, [r5, #-0]
    2cbc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cc0:	d60f0000 	strle	r0, [pc], -r0
    2cc4:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2cc8:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    2ccc:	0f000000 	svceq	0x00000000
    2cd0:	00002a13 	andeq	r2, r0, r3, lsl sl
    2cd4:	0c01c305 	stceq	3, cr12, [r1], {5}
    2cd8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cdc:	0028d90f 	eoreq	sp, r8, pc, lsl #18
    2ce0:	01c60500 	biceq	r0, r6, r0, lsl #10
    2ce4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2ce8:	28e50f00 	stmiacs	r5!, {r8, r9, sl, fp}^
    2cec:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    2cf0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cf4:	f10f0000 			; <UNDEFINED> instruction: 0xf10f0000
    2cf8:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2cfc:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    2d00:	0f000000 	svceq	0x00000000
    2d04:	00002916 	andeq	r2, r0, r6, lsl r9
    2d08:	0c01d005 	stceq	0, cr13, [r1], {5}
    2d0c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d10:	002a060f 	eoreq	r0, sl, pc, lsl #12
    2d14:	01d30500 	bicseq	r0, r3, r0, lsl #10
    2d18:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d1c:	1bd40f00 	blne	ff506924 <__bss_end+0xff4fcecc>
    2d20:	d6050000 	strle	r0, [r5], -r0
    2d24:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d28:	bb0f0000 	bllt	3c2d30 <__bss_end+0x3b92d8>
    2d2c:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2d30:	1d0c01d9 	stfnes	f0, [ip, #-868]	; 0xfffffc9c
    2d34:	0f000000 	svceq	0x00000000
    2d38:	00001eaf 	andeq	r1, r0, pc, lsr #29
    2d3c:	0c01dc05 	stceq	12, cr13, [r1], {5}
    2d40:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d44:	001baf0f 	andseq	sl, fp, pc, lsl #30
    2d48:	01df0500 	bicseq	r0, pc, r0, lsl #10
    2d4c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d50:	24ec0f00 	strbtcs	r0, [ip], #3840	; 0xf00
    2d54:	e2050000 	and	r0, r5, #0
    2d58:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d5c:	f40f0000 	vst4.8	{d0-d3}, [pc], r0
    2d60:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2d64:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    2d68:	0f000000 	svceq	0x00000000
    2d6c:	0000234c 	andeq	r2, r0, ip, asr #6
    2d70:	0c01e805 	stceq	8, cr14, [r1], {5}
    2d74:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d78:	0028060f 	eoreq	r0, r8, pc, lsl #12
    2d7c:	01ef0500 	mvneq	r0, r0, lsl #10
    2d80:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d84:	29be0f00 	ldmibcs	lr!, {r8, r9, sl, fp}
    2d88:	f2050000 	vhadd.s8	d0, d5, d0
    2d8c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d90:	ce0f0000 	cdpgt	0, 0, cr0, cr15, cr0, {0}
    2d94:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2d98:	1d0c01f5 	stfnes	f0, [ip, #-980]	; 0xfffffc2c
    2d9c:	0f000000 	svceq	0x00000000
    2da0:	00001ccb 	andeq	r1, r0, fp, asr #25
    2da4:	0c01f805 	stceq	8, cr15, [r1], {5}
    2da8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2dac:	00284d0f 	eoreq	r4, r8, pc, lsl #26
    2db0:	01fb0500 	mvnseq	r0, r0, lsl #10
    2db4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2db8:	24520f00 	ldrbcs	r0, [r2], #-3840	; 0xfffff100
    2dbc:	fe050000 	cdp2	0, 0, cr0, cr5, cr0, {0}
    2dc0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2dc4:	280f0000 	stmdacs	pc, {}	; <UNPREDICTABLE>
    2dc8:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2dcc:	1d0c0202 	sfmne	f0, 4, [ip, #-8]
    2dd0:	0f000000 	svceq	0x00000000
    2dd4:	00002642 	andeq	r2, r0, r2, asr #12
    2dd8:	0c020a05 			; <UNDEFINED> instruction: 0x0c020a05
    2ddc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2de0:	001e1b0f 	andseq	r1, lr, pc, lsl #22
    2de4:	020d0500 	andeq	r0, sp, #0, 10
    2de8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2dec:	001d0c00 	andseq	r0, sp, r0, lsl #24
    2df0:	07ef0000 	strbeq	r0, [pc, r0]!
    2df4:	000d0000 	andeq	r0, sp, r0
    2df8:	001ff40f 	andseq	pc, pc, pc, lsl #8
    2dfc:	03fb0500 	mvnseq	r0, #0, 10
    2e00:	0007e40c 	andeq	lr, r7, ip, lsl #8
    2e04:	04e60c00 	strbteq	r0, [r6], #3072	; 0xc00
    2e08:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
    2e0c:	24150000 	ldrcs	r0, [r5], #-0
    2e10:	0d000000 	stceq	0, cr0, [r0, #-0]
    2e14:	250f0f00 	strcs	r0, [pc, #-3840]	; 1f1c <shift+0x1f1c>
    2e18:	84050000 	strhi	r0, [r5], #-0
    2e1c:	07fc1405 	ldrbeq	r1, [ip, r5, lsl #8]!
    2e20:	b6160000 	ldrlt	r0, [r6], -r0
    2e24:	07000020 	streq	r0, [r0, -r0, lsr #32]
    2e28:	00009301 	andeq	r9, r0, r1, lsl #6
    2e2c:	058b0500 	streq	r0, [fp, #1280]	; 0x500
    2e30:	00085706 	andeq	r5, r8, r6, lsl #14
    2e34:	1e710b00 	vaddne.f64	d16, d1, d0
    2e38:	0b000000 	bleq	2e40 <shift+0x2e40>
    2e3c:	000022c1 	andeq	r2, r0, r1, asr #5
    2e40:	1a600b01 	bne	1805a4c <__bss_end+0x17fbff4>
    2e44:	0b020000 	bleq	82e4c <__bss_end+0x793f4>
    2e48:	00002980 	andeq	r2, r0, r0, lsl #19
    2e4c:	25890b03 	strcs	r0, [r9, #2819]	; 0xb03
    2e50:	0b040000 	bleq	102e58 <__bss_end+0xf9400>
    2e54:	0000257c 	andeq	r2, r0, ip, ror r5
    2e58:	1b370b05 	blne	dc5a74 <__bss_end+0xdbc01c>
    2e5c:	00060000 	andeq	r0, r6, r0
    2e60:	0029700f 	eoreq	r7, r9, pc
    2e64:	05980500 	ldreq	r0, [r8, #1280]	; 0x500
    2e68:	00081915 	andeq	r1, r8, r5, lsl r9
    2e6c:	28720f00 	ldmdacs	r2!, {r8, r9, sl, fp}^
    2e70:	99050000 	stmdbls	r5, {}	; <UNPREDICTABLE>
    2e74:	00241107 	eoreq	r1, r4, r7, lsl #2
    2e78:	fc0f0000 	stc2	0, cr0, [pc], {-0}
    2e7c:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2e80:	1d0c07ae 	stcne	7, cr0, [ip, #-696]	; 0xfffffd48
    2e84:	04000000 	streq	r0, [r0], #-0
    2e88:	000027e5 	andeq	r2, r0, r5, ror #15
    2e8c:	93167b06 	tstls	r6, #6144	; 0x1800
    2e90:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2e94:	0000087e 	andeq	r0, r0, lr, ror r8
    2e98:	02050203 	andeq	r0, r5, #805306368	; 0x30000000
    2e9c:	0300000e 	movweq	r0, #14
    2ea0:	04d30708 	ldrbeq	r0, [r3], #1800	; 0x708
    2ea4:	04030000 	streq	r0, [r3], #-0
    2ea8:	001bef04 	andseq	lr, fp, r4, lsl #30
    2eac:	03080300 	movweq	r0, #33536	; 0x8300
    2eb0:	00001be7 	andeq	r1, r0, r7, ror #23
    2eb4:	e5040803 	str	r0, [r4, #-2051]	; 0xfffff7fd
    2eb8:	03000024 	movweq	r0, #36	; 0x24
    2ebc:	25970310 	ldrcs	r0, [r7, #784]	; 0x310
    2ec0:	8a0c0000 	bhi	302ec8 <__bss_end+0x2f9470>
    2ec4:	c9000008 	stmdbgt	r0, {r3}
    2ec8:	15000008 	strne	r0, [r0, #-8]
    2ecc:	00000024 	andeq	r0, r0, r4, lsr #32
    2ed0:	b90e00ff 	stmdblt	lr, {r0, r1, r2, r3, r4, r5, r6, r7}
    2ed4:	0f000008 	svceq	0x00000008
    2ed8:	000023f6 	strdeq	r2, [r0], -r6
    2edc:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2ee0:	000008c9 	andeq	r0, r0, r9, asr #17
    2ee4:	001b9e0f 	andseq	r9, fp, pc, lsl #28
    2ee8:	02020600 	andeq	r0, r2, #0, 12
    2eec:	0008c916 	andeq	ip, r8, r6, lsl r9
    2ef0:	28180400 	ldmdacs	r8, {sl}
    2ef4:	2a070000 	bcs	1c2efc <__bss_end+0x1b94a4>
    2ef8:	0004f910 	andeq	pc, r4, r0, lsl r9	; <UNPREDICTABLE>
    2efc:	08e80c00 	stmiaeq	r8!, {sl, fp}^
    2f00:	08ff0000 	ldmeq	pc!, {}^	; <UNPREDICTABLE>
    2f04:	000d0000 	andeq	r0, sp, r0
    2f08:	00035709 	andeq	r5, r3, r9, lsl #14
    2f0c:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    2f10:	000008f4 	strdeq	r0, [r0], -r4
    2f14:	00020c09 	andeq	r0, r2, r9, lsl #24
    2f18:	11300700 	teqne	r0, r0, lsl #14
    2f1c:	000008f4 	strdeq	r0, [r0], -r4
    2f20:	0008ff17 	andeq	pc, r8, r7, lsl pc	; <UNPREDICTABLE>
    2f24:	09330800 	ldmdbeq	r3!, {fp}
    2f28:	4503050a 	strmi	r0, [r3, #-1290]	; 0xfffffaf6
    2f2c:	1700009a 			; <UNDEFINED> instruction: 0x1700009a
    2f30:	0000090b 	andeq	r0, r0, fp, lsl #18
    2f34:	0a093408 	beq	24ff5c <__bss_end+0x246504>
    2f38:	9a450305 	bls	1143b54 <__bss_end+0x113a0fc>
    2f3c:	Address 0x0000000000002f3c is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3771bc>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb92c4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb92e4>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb92fc>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x344>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79e3c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39320>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7250>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b669c>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9f00>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4eb8>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b66c8>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b673c>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3772b8>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb93b8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79ef4>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe393d8>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb93f0>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79f28>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4f64>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3773a8>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7370>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb9490>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	03001605 	movweq	r1, #1541	; 0x605
 21c:	3b0b3a0e 	blcc	2cea5c <__bss_end+0x2c5004>
 220:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 224:	06000013 			; <UNDEFINED> instruction: 0x06000013
 228:	0b0b0024 	bleq	2c02c0 <__bss_end+0x2b6868>
 22c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b9ff8>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb94d8>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f73fc>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7cdc4>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb9500>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b9470>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe7a054>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe39538>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb574>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c5094>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe7a08c>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe39570>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x3774f8>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe7a0bc>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe395a0>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a270>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x37752c>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b692c>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe7a10c>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe395f0>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb9608>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x377598>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a158>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe3963c>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb678>
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
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c51a4>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb967c>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c51e0>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377628>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7a1e8>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe396cc>
 434:	01111349 	tsteq	r1, r9, asr #6
 438:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 43c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 440:	29000013 	stmdbcs	r0, {r0, r1, r4}
 444:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 448:	0b3b0b3a 	bleq	ec3138 <__bss_end+0xeb96e0>
 44c:	13490b39 	movtne	r0, #39737	; 0x9b39
 450:	00001802 	andeq	r1, r0, r2, lsl #16
 454:	0300342a 	movweq	r3, #1066	; 0x42a
 458:	3b0b3a0e 	blcc	2cec98 <__bss_end+0x2c5240>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	11010000 	mrsne	r0, (UNDEF: 1)
 468:	130e2501 	movwne	r2, #58625	; 0xe501
 46c:	1b0e030b 	blne	3810a0 <__bss_end+0x377648>
 470:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 474:	00171006 	andseq	r1, r7, r6
 478:	00240200 	eoreq	r0, r4, r0, lsl #4
 47c:	0b3e0b0b 	bleq	f830b0 <__bss_end+0xf79658>
 480:	00000e03 	andeq	r0, r0, r3, lsl #28
 484:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 488:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 48c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 490:	0b3b0b3a 	bleq	ec3180 <__bss_end+0xeb9728>
 494:	13490b39 	movtne	r0, #39737	; 0x9b39
 498:	24050000 	strcs	r0, [r5], #-0
 49c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a0:	0008030b 	andeq	r0, r8, fp, lsl #6
 4a4:	00340600 	eorseq	r0, r4, r0, lsl #12
 4a8:	0b3a0e03 	bleq	e83cbc <__bss_end+0xe7a264>
 4ac:	0b390b3b 	bleq	e431a0 <__bss_end+0xe39748>
 4b0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 4b4:	00001802 	andeq	r1, r0, r2, lsl #16
 4b8:	03011307 	movweq	r1, #4871	; 0x1307
 4bc:	3a0b0b0e 	bcc	2c30fc <__bss_end+0x2b96a4>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4c8:	000d0800 	andeq	r0, sp, r0, lsl #16
 4cc:	0b3a0803 	bleq	e824e0 <__bss_end+0xe78a88>
 4d0:	0b390b3b 	bleq	e431c4 <__bss_end+0xe3976c>
 4d4:	0b381349 	bleq	e05200 <__bss_end+0xdfb7a8>
 4d8:	04090000 	streq	r0, [r9], #-0
 4dc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4e0:	0b0b3e19 	bleq	2cfd4c <__bss_end+0x2c62f4>
 4e4:	3a13490b 	bcc	4d2918 <__bss_end+0x4c8ec0>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	0013010b 	andseq	r0, r3, fp, lsl #2
 4f0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4f4:	0b1c0803 	bleq	702508 <__bss_end+0x6f8ab0>
 4f8:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 4fc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 500:	0c00000b 	stceq	0, cr0, [r0], {11}
 504:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 508:	0000193c 	andeq	r1, r0, ip, lsr r9
 50c:	0301020d 	movweq	r0, #4621	; 0x120d
 510:	3a0b0b0e 	bcc	2c3150 <__bss_end+0x2b96f8>
 514:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 518:	0013010b 	andseq	r0, r3, fp, lsl #2
 51c:	000d0e00 	andeq	r0, sp, r0, lsl #28
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe7a2dc>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe397c0>
 528:	0b381349 	bleq	e05254 <__bss_end+0xdfb7fc>
 52c:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 530:	03193f01 	tsteq	r9, #1, 30
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c531c>
 538:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 53c:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 540:	00136419 	andseq	r6, r3, r9, lsl r4
 544:	00051000 	andeq	r1, r5, r0
 548:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 54c:	05110000 	ldreq	r0, [r1, #-0]
 550:	00134900 	andseq	r4, r3, r0, lsl #18
 554:	000d1200 	andeq	r1, sp, r0, lsl #4
 558:	0b3a0e03 	bleq	e83d6c <__bss_end+0xe7a314>
 55c:	0b390b3b 	bleq	e43250 <__bss_end+0xe397f8>
 560:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 564:	0000193c 	andeq	r1, r0, ip, lsr r9
 568:	3f012e13 	svccc	0x00012e13
 56c:	3a0e0319 	bcc	3811d8 <__bss_end+0x377780>
 570:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 574:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 578:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 57c:	01136419 	tsteq	r3, r9, lsl r4
 580:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 584:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 588:	0b3a0e03 	bleq	e83d9c <__bss_end+0xe7a344>
 58c:	0b390b3b 	bleq	e43280 <__bss_end+0xe39828>
 590:	0b320e6e 	bleq	c83f50 <__bss_end+0xc7a4f8>
 594:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 598:	00001301 	andeq	r1, r0, r1, lsl #6
 59c:	3f012e15 	svccc	0x00012e15
 5a0:	3a0e0319 	bcc	38120c <__bss_end+0x3777b4>
 5a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5ac:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 5b0:	00136419 	andseq	r6, r3, r9, lsl r4
 5b4:	01011600 	tsteq	r1, r0, lsl #12
 5b8:	13011349 	movwne	r1, #4937	; 0x1349
 5bc:	21170000 	tstcs	r7, r0
 5c0:	2f134900 	svccs	0x00134900
 5c4:	1800000b 	stmdane	r0, {r0, r1, r3}
 5c8:	0b0b000f 	bleq	2c060c <__bss_end+0x2b6bb4>
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	00002119 	andeq	r2, r0, r9, lsl r1
 5d4:	00341a00 	eorseq	r1, r4, r0, lsl #20
 5d8:	0b3a0e03 	bleq	e83dec <__bss_end+0xe7a394>
 5dc:	0b390b3b 	bleq	e432d0 <__bss_end+0xe39878>
 5e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 5e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 5e8:	3f012e1b 	svccc	0x00012e1b
 5ec:	3a0e0319 	bcc	381258 <__bss_end+0x377800>
 5f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5f4:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 5f8:	01136419 	tsteq	r3, r9, lsl r4
 5fc:	1c000013 	stcne	0, cr0, [r0], {19}
 600:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 604:	0b3a0e03 	bleq	e83e18 <__bss_end+0xe7a3c0>
 608:	0b390b3b 	bleq	e432fc <__bss_end+0xe398a4>
 60c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 610:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 614:	00001301 	andeq	r1, r0, r1, lsl #6
 618:	03000d1d 	movweq	r0, #3357	; 0xd1d
 61c:	3b0b3a0e 	blcc	2cee5c <__bss_end+0x2c5404>
 620:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 624:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 628:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 62c:	13490115 	movtne	r0, #37141	; 0x9115
 630:	13011364 	movwne	r1, #4964	; 0x1364
 634:	1f1f0000 	svcne	0x001f0000
 638:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 63c:	20000013 	andcs	r0, r0, r3, lsl r0
 640:	0b0b0010 	bleq	2c0688 <__bss_end+0x2b6c30>
 644:	00001349 	andeq	r1, r0, r9, asr #6
 648:	0b000f21 	bleq	42d4 <shift+0x42d4>
 64c:	2200000b 	andcs	r0, r0, #11
 650:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 654:	0b3b0b3a 	bleq	ec3344 <__bss_end+0xeb98ec>
 658:	13490b39 	movtne	r0, #39737	; 0x9b39
 65c:	00001802 	andeq	r1, r0, r2, lsl #16
 660:	3f012e23 	svccc	0x00012e23
 664:	3a0e0319 	bcc	3812d0 <__bss_end+0x377878>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 670:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 674:	96184006 	ldrls	r4, [r8], -r6
 678:	13011942 	movwne	r1, #6466	; 0x1942
 67c:	05240000 	streq	r0, [r4, #-0]!
 680:	3a0e0300 	bcc	381288 <__bss_end+0x377830>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 68c:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 690:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7a450>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe39934>
 69c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 6a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6a8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ac:	00342600 	eorseq	r2, r4, r0, lsl #12
 6b0:	0b3a0803 	bleq	e826c4 <__bss_end+0xe78c6c>
 6b4:	0b390b3b 	bleq	e433a8 <__bss_end+0xe39950>
 6b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6bc:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 6c0:	03193f01 	tsteq	r9, #1, 30
 6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c54ac>
 6c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
 6dc:	03193f00 	tsteq	r9, #0, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c54c8>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6ec:	97184006 	ldrls	r4, [r8, -r6]
 6f0:	00001942 	andeq	r1, r0, r2, asr #18
 6f4:	3f012e29 	svccc	0x00012e29
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x37790c>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 704:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 708:	97184006 	ldrls	r4, [r8, -r6]
 70c:	00001942 	andeq	r1, r0, r2, asr #18
 710:	01110100 	tsteq	r1, r0, lsl #2
 714:	0b130e25 	bleq	4c3fb0 <__bss_end+0x4ba558>
 718:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 71c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 720:	00001710 	andeq	r1, r0, r0, lsl r7
 724:	03003402 	movweq	r3, #1026	; 0x402
 728:	3b0b3a0e 	blcc	2cef68 <__bss_end+0x2c5510>
 72c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 730:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 734:	03000018 	movweq	r0, #24
 738:	0b0b0024 	bleq	2c07d0 <__bss_end+0x2b6d78>
 73c:	0e030b3e 	vmoveq.16	d3[0], r0
 740:	26040000 	strcs	r0, [r4], -r0
 744:	00134900 	andseq	r4, r3, r0, lsl #18
 748:	01390500 	teqeq	r9, r0, lsl #10
 74c:	00001301 	andeq	r1, r0, r1, lsl #6
 750:	03003406 	movweq	r3, #1030	; 0x406
 754:	3b0b3a0e 	blcc	2cef94 <__bss_end+0x2c553c>
 758:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 75c:	1c193c13 	ldcne	12, cr3, [r9], {19}
 760:	0700000a 	streq	r0, [r0, -sl]
 764:	0b3a003a 	bleq	e80854 <__bss_end+0xe76dfc>
 768:	0b390b3b 	bleq	e4345c <__bss_end+0xe39a04>
 76c:	00001318 	andeq	r1, r0, r8, lsl r3
 770:	49010108 	stmdbmi	r1, {r3, r8}
 774:	00130113 	andseq	r0, r3, r3, lsl r1
 778:	00210900 	eoreq	r0, r1, r0, lsl #18
 77c:	0b2f1349 	bleq	bc54a8 <__bss_end+0xbbba50>
 780:	340a0000 	strcc	r0, [sl], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeb9a28>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	01111349 	tsteq	r1, r9, asr #6
 79c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7a0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 7a4:	0c000013 	stceq	0, cr0, [r0], {19}
 7a8:	08030005 	stmdaeq	r3, {r0, r2}
 7ac:	0b3b0b3a 	bleq	ec349c <__bss_end+0xeb9a44>
 7b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b4:	00001802 	andeq	r1, r0, r2, lsl #16
 7b8:	0300340d 	movweq	r3, #1037	; 0x40d
 7bc:	3b0b3a08 	blcc	2cefe4 <__bss_end+0x2c558c>
 7c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7c4:	00180213 	andseq	r0, r8, r3, lsl r2
 7c8:	00340e00 	eorseq	r0, r4, r0, lsl #28
 7cc:	0b3a0e03 	bleq	e83fe0 <__bss_end+0xe7a588>
 7d0:	0b390b3b 	bleq	e434c4 <__bss_end+0xe39a6c>
 7d4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7d8:	0b0f0000 	bleq	3c07e0 <__bss_end+0x3b6d88>
 7dc:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7e0:	10000006 	andne	r0, r0, r6
 7e4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7e8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 7ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 7f0:	00001802 	andeq	r1, r0, r2, lsl #16
 7f4:	03003411 	movweq	r3, #1041	; 0x411
 7f8:	3b0b3a08 	blcc	2cf020 <__bss_end+0x2c55c8>
 7fc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 800:	00180213 	andseq	r0, r8, r3, lsl r2
 804:	000f1200 	andeq	r1, pc, r0, lsl #4
 808:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 80c:	24130000 	ldrcs	r0, [r3], #-0
 810:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 814:	0008030b 	andeq	r0, r8, fp, lsl #6
 818:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 81c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 820:	0b3b0b3a 	bleq	ec3510 <__bss_end+0xeb9ab8>
 824:	0e6e0b39 	vmoveq.8	d14[5], r0
 828:	06120111 			; <UNDEFINED> instruction: 0x06120111
 82c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 830:	00130119 	andseq	r0, r3, r9, lsl r1
 834:	00051500 	andeq	r1, r5, r0, lsl #10
 838:	0b3a0e03 	bleq	e8404c <__bss_end+0xe7a5f4>
 83c:	0b390b3b 	bleq	e43530 <__bss_end+0xe39ad8>
 840:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 844:	0b160000 	bleq	58084c <__bss_end+0x576df4>
 848:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 84c:	00130106 	andseq	r0, r3, r6, lsl #2
 850:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 854:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 858:	0b3b0b3a 	bleq	ec3548 <__bss_end+0xeb9af0>
 85c:	0e6e0b39 	vmoveq.8	d14[5], r0
 860:	06120111 			; <UNDEFINED> instruction: 0x06120111
 864:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 868:	00130119 	andseq	r0, r3, r9, lsl r1
 86c:	00101800 	andseq	r1, r0, r0, lsl #16
 870:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 874:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 878:	03193f01 	tsteq	r9, #1, 30
 87c:	3b0b3a08 	blcc	2cf0a4 <__bss_end+0x2c564c>
 880:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 884:	1113490e 	tstne	r3, lr, lsl #18
 888:	40061201 	andmi	r1, r6, r1, lsl #4
 88c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 890:	00001301 	andeq	r1, r0, r1, lsl #6
 894:	0000261a 	andeq	r2, r0, sl, lsl r6
 898:	000f1b00 	andeq	r1, pc, r0, lsl #22
 89c:	00000b0b 	andeq	r0, r0, fp, lsl #22
 8a0:	3f012e1c 	svccc	0x00012e1c
 8a4:	3a0e0319 	bcc	381510 <__bss_end+0x377ab8>
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
 900:	0b3e0b0b 	bleq	f83534 <__bss_end+0xf79adc>
 904:	00000e03 	andeq	r0, r0, r3, lsl #28
 908:	03001604 	movweq	r1, #1540	; 0x604
 90c:	3b0b3a0e 	blcc	2cf14c <__bss_end+0x2c56f4>
 910:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 914:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 918:	0b0b000f 	bleq	2c095c <__bss_end+0x2b6f04>
 91c:	00001349 	andeq	r1, r0, r9, asr #6
 920:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 924:	01134919 	tsteq	r3, r9, lsl r9
 928:	07000013 	smladeq	r0, r3, r0, r0
 92c:	13490005 	movtne	r0, #36869	; 0x9005
 930:	26080000 	strcs	r0, [r8], -r0
 934:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 938:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 93c:	0b3b0b3a 	bleq	ec362c <__bss_end+0xeb9bd4>
 940:	13490b39 	movtne	r0, #39737	; 0x9b39
 944:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 948:	040a0000 	streq	r0, [sl], #-0
 94c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 950:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 954:	3b0b3a13 	blcc	2cf1a8 <__bss_end+0x2c5750>
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
 980:	0b3a0e03 	bleq	e84194 <__bss_end+0xe7a73c>
 984:	0b39053b 	bleq	e41e78 <__bss_end+0xe38420>
 988:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 98c:	0000193c 	andeq	r1, r0, ip, lsr r9
 990:	03001310 	movweq	r1, #784	; 0x310
 994:	00193c0e 	andseq	r3, r9, lr, lsl #24
 998:	00151100 	andseq	r1, r5, r0, lsl #2
 99c:	00001927 	andeq	r1, r0, r7, lsr #18
 9a0:	03001712 	movweq	r1, #1810	; 0x712
 9a4:	00193c0e 	andseq	r3, r9, lr, lsl #24
 9a8:	01131300 	tsteq	r3, r0, lsl #6
 9ac:	0b0b0e03 	bleq	2c41c0 <__bss_end+0x2ba768>
 9b0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9b4:	13010b39 	movwne	r0, #6969	; 0x1b39
 9b8:	0d140000 	ldceq	0, cr0, [r4, #-0]
 9bc:	3a0e0300 	bcc	3815c4 <__bss_end+0x377b6c>
 9c0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c4:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 9c8:	1500000b 	strne	r0, [r0, #-11]
 9cc:	13490021 	movtne	r0, #36897	; 0x9021
 9d0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 9d4:	03010416 	movweq	r0, #5142	; 0x1416
 9d8:	0b0b3e0e 	bleq	2d0218 <__bss_end+0x2c67c0>
 9dc:	3a13490b 	bcc	4d2e10 <__bss_end+0x4c93b8>
 9e0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9e4:	0013010b 	andseq	r0, r3, fp, lsl #2
 9e8:	00341700 	eorseq	r1, r4, r0, lsl #14
 9ec:	0b3a1347 	bleq	e85710 <__bss_end+0xe7bcb8>
 9f0:	0b39053b 	bleq	e41ee4 <__bss_end+0xe3848c>
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
  84:	11600002 	cmnne	r0, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008308 	andeq	r8, r0, r8, lsl #6
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1ec00002 	cdpne	0, 12, cr0, cr0, cr2, {0}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008764 	andeq	r8, r0, r4, ror #14
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	25bd0002 	ldrcs	r0, [sp, #2]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009740 	andeq	r9, r0, r0, asr #14
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	25e30002 	strbcs	r0, [r3, #2]!
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000994c 	andeq	r9, r0, ip, asr #18
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	26090002 	strcs	r0, [r9], -r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff64f4>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6299>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff629b>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4fb0>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff63e9>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be920>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfecc>
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
     4a8:	5a5f0074 	bpl	17c0680 <__bss_end+0x17b6c28>
     4ac:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4b0:	4f495047 	svcmi	0x00495047
     4b4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4b8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4bc:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4c0:	706e495f 	rsbvc	r4, lr, pc, asr r9
     4c4:	6a457475 	bvs	115d6a0 <__bss_end+0x1153c48>
     4c8:	43534200 	cmpmi	r3, #0, 4
     4cc:	61425f32 	cmpvs	r2, r2, lsr pc
     4d0:	6c006573 	cfstr32vs	mvfx6, [r0], {115}	; 0x73
     4d4:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     4d8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     4dc:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     4e0:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     4e4:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     4e8:	506d0074 	rsbpl	r0, sp, r4, ror r0
     4ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4f0:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     4f4:	5f747369 	svcpl	0x00747369
     4f8:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     4fc:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     500:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     504:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     508:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     50c:	5f006e6f 	svcpl	0x00006e6f
     510:	314b4e5a 	cmpcc	fp, sl, asr lr
     514:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     518:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     51c:	614d5f73 	hvcvs	54771	; 0xd5f3
     520:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     524:	47393172 			; <UNDEFINED> instruction: 0x47393172
     528:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     52c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     530:	505f746e 	subspl	r7, pc, lr, ror #8
     534:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     538:	76457373 			; <UNDEFINED> instruction: 0x76457373
     53c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     540:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     544:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     548:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     54c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     550:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     554:	646c6f00 	strbtvs	r6, [ip], #-3840	; 0xfffff100
     558:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     55c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     560:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     564:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     568:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     56c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     570:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff878 <__bss_end+0xffff5e20>
     574:	6f50746e 	svcvs	0x0050746e
     578:	00746e69 	rsbseq	r6, r4, r9, ror #28
     57c:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     580:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     584:	0079726f 	rsbseq	r7, r9, pc, ror #4
     588:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     58c:	6f72505f 	svcvs	0x0072505f
     590:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     594:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     598:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     59c:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     5a0:	5f657669 	svcpl	0x00657669
     5a4:	636f7250 	cmnvs	pc, #80, 4
     5a8:	5f737365 	svcpl	0x00737365
     5ac:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     5b0:	506d0074 	rsbpl	r0, sp, r4, ror r0
     5b4:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     5b8:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     5bc:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     5c0:	5f736e6f 	svcpl	0x00736e6f
     5c4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     5c8:	61575400 	cmpvs	r7, r0, lsl #8
     5cc:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     5d0:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     5d4:	4300656c 	movwmi	r6, #1388	; 0x56c
     5d8:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     5dc:	72505f65 	subsvc	r5, r0, #404	; 0x194
     5e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5e4:	476d0073 			; <UNDEFINED> instruction: 0x476d0073
     5e8:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     5ec:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     5f0:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     5f4:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     5f8:	616e656c 	cmnvs	lr, ip, ror #10
     5fc:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     600:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     604:	58554100 	ldmdapl	r5, {r8, lr}^
     608:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     60c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     610:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     614:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     618:	5f72656c 	svcpl	0x0072656c
     61c:	6f666e49 	svcvs	0x00666e49
     620:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     624:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     628:	00745f6b 	rsbseq	r5, r4, fp, ror #30
     62c:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     630:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     634:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     638:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     63c:	43006465 	movwmi	r6, #1125	; 0x465
     640:	636f7250 	cmnvs	pc, #80, 4
     644:	5f737365 	svcpl	0x00737365
     648:	616e614d 	cmnvs	lr, sp, asr #2
     64c:	00726567 	rsbseq	r6, r2, r7, ror #10
     650:	314e5a5f 	cmpcc	lr, pc, asr sl
     654:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     658:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     65c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     660:	76453443 	strbvc	r3, [r5], -r3, asr #8
     664:	53465400 	movtpl	r5, #25600	; 0x6400
     668:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     66c:	00726576 	rsbseq	r6, r2, r6, ror r5
     670:	314e5a5f 	cmpcc	lr, pc, asr sl
     674:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     678:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     67c:	614d5f73 	hvcvs	54771	; 0xd5f3
     680:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     684:	47383172 			; <UNDEFINED> instruction: 0x47383172
     688:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     68c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     690:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     694:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     698:	3032456f 	eorscc	r4, r2, pc, ror #10
     69c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     6a0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6a4:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     6a8:	5f6f666e 	svcpl	0x006f666e
     6ac:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     6b0:	5f007650 	svcpl	0x00007650
     6b4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6b8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     6bc:	61485f4f 	cmpvs	r8, pc, asr #30
     6c0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6c4:	43303272 	teqmi	r0, #536870919	; 0x20000007
     6c8:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     6cc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     6d0:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     6d4:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     6d8:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     6dc:	5a5f006a 	bpl	17c088c <__bss_end+0x17b6e34>
     6e0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6e4:	636f7250 	cmnvs	pc, #80, 4
     6e8:	5f737365 	svcpl	0x00737365
     6ec:	616e614d 	cmnvs	lr, sp, asr #2
     6f0:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     6f4:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     6f8:	5f656c64 	svcpl	0x00656c64
     6fc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     700:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     704:	535f6d65 	cmppl	pc, #6464	; 0x1940
     708:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     70c:	57534e33 	smmlarpl	r3, r3, lr, r4
     710:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     714:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     718:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     71c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     720:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     724:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     728:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     72c:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     730:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     734:	61460074 	hvcvs	24580	; 0x6004
     738:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     73c:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     740:	6f006567 	svcvs	0x00006567
     744:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     748:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     74c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     750:	6e69616d 	powvsez	f6, f1, #5.0
     754:	746f4e00 	strbtvc	r4, [pc], #-3584	; 75c <shift+0x75c>
     758:	41796669 	cmnmi	r9, r9, ror #12
     75c:	5f006c6c 	svcpl	0x00006c6c
     760:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     764:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     768:	61485f4f 	cmpvs	r8, pc, asr #30
     76c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     770:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
     774:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     778:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 214 <shift+0x214>
     77c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     780:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     784:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     788:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     78c:	4f495047 	svcmi	0x00495047
     790:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     794:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     798:	545f7470 	ldrbpl	r7, [pc], #-1136	; 7a0 <shift+0x7a0>
     79c:	00657079 	rsbeq	r7, r5, r9, ror r0
     7a0:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     7a4:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     7a8:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     7ac:	61654400 	cmnvs	r5, r0, lsl #8
     7b0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     7b4:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     7b8:	00307262 	eorseq	r7, r0, r2, ror #4
     7bc:	314e5a5f 	cmpcc	lr, pc, asr sl
     7c0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7c8:	614d5f73 	hvcvs	54771	; 0xd5f3
     7cc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7d0:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     7d4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     7d8:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     7dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7e0:	006a4573 	rsbeq	r4, sl, r3, ror r5
     7e4:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     7e8:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; 724 <shift+0x724>
     7ec:	42005841 	andmi	r5, r0, #4259840	; 0x410000
     7f0:	5f304353 	svcpl	0x00304353
     7f4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     7f8:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     7fc:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     800:	00646c69 	rsbeq	r6, r4, r9, ror #24
     804:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     808:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     80c:	6165645f 	cmnvs	r5, pc, asr r4
     810:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     814:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     818:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     81c:	5f747075 	svcpl	0x00747075
     820:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     824:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     828:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     82c:	00657361 	rsbeq	r7, r5, r1, ror #6
     830:	314e5a5f 	cmpcc	lr, pc, asr sl
     834:	50474333 	subpl	r4, r7, r3, lsr r3
     838:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     83c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     840:	46387265 	ldrtmi	r7, [r8], -r5, ror #4
     844:	5f656572 	svcpl	0x00656572
     848:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     84c:	0062626a 	rsbeq	r6, r2, sl, ror #4
     850:	31435342 	cmpcc	r3, r2, asr #6
     854:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     858:	614d0065 	cmpvs	sp, r5, rrx
     85c:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     860:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     864:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     868:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     86c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     870:	5f007365 	svcpl	0x00007365
     874:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     878:	6f725043 	svcvs	0x00725043
     87c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     880:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     884:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     888:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     88c:	5f70616d 	svcpl	0x0070616d
     890:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     894:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     898:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     89c:	55006a45 	strpl	r6, [r0, #-2629]	; 0xfffff5bb
     8a0:	33544e49 	cmpcc	r4, #1168	; 0x490
     8a4:	494d5f32 	stmdbmi	sp, {r1, r4, r5, r8, r9, sl, fp, ip, lr}^
     8a8:	5254004e 	subspl	r0, r4, #78	; 0x4e
     8ac:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     8b0:	00657361 	rsbeq	r7, r5, r1, ror #6
     8b4:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     8b8:	53466700 	movtpl	r6, #26368	; 0x6700
     8bc:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     8c0:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     8c4:	756f435f 	strbvc	r4, [pc, #-863]!	; 56d <shift+0x56d>
     8c8:	5f00746e 	svcpl	0x0000746e
     8cc:	314b4e5a 	cmpcc	fp, sl, asr lr
     8d0:	50474333 	subpl	r4, r7, r3, lsr r3
     8d4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     8d8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     8dc:	36327265 	ldrtcc	r7, [r2], -r5, ror #4
     8e0:	5f746547 	svcpl	0x00746547
     8e4:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     8e8:	445f5152 	ldrbmi	r5, [pc], #-338	; 8f0 <shift+0x8f0>
     8ec:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     8f0:	6f4c5f74 	svcvs	0x004c5f74
     8f4:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     8f8:	6a456e6f 	bvs	115c2bc <__bss_end+0x1152864>
     8fc:	474e3032 	smlaldxmi	r3, lr, r2, r0
     900:	5f4f4950 	svcpl	0x004f4950
     904:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     908:	70757272 	rsbsvc	r7, r5, r2, ror r2
     90c:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     910:	6a526570 	bvs	1499ed8 <__bss_end+0x1490480>
     914:	005f3153 	subseq	r3, pc, r3, asr r1	; <UNPREDICTABLE>
     918:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     91c:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 1b6 <shift+0x1b6>
     920:	00656764 	rsbeq	r6, r5, r4, ror #14
     924:	6f6f526d 	svcvs	0x006f526d
     928:	79535f74 	ldmdbvc	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     92c:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     930:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     934:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     938:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     93c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     940:	614d0073 	hvcvs	53251	; 0xd003
     944:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     948:	545f656c 	ldrbpl	r6, [pc], #-1388	; 950 <shift+0x950>
     94c:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     950:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     954:	5a5f0074 	bpl	17c0b2c <__bss_end+0x17b70d4>
     958:	33314b4e 	teqcc	r1, #79872	; 0x13800
     95c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     960:	61485f4f 	cmpvs	r8, pc, asr #30
     964:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     968:	47393172 			; <UNDEFINED> instruction: 0x47393172
     96c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     970:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     974:	6f4c5f4c 	svcvs	0x004c5f4c
     978:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     97c:	6a456e6f 	bvs	115c340 <__bss_end+0x11528e8>
     980:	30536a52 	subscc	r6, r3, r2, asr sl
     984:	6f4e005f 	svcvs	0x004e005f
     988:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     98c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     990:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     994:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     998:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     99c:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     9a0:	00736d61 	rsbseq	r6, r3, r1, ror #26
     9a4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     9a8:	505f656c 	subspl	r6, pc, ip, ror #10
     9ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     9b0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     9b4:	73004957 	movwvc	r4, #2391	; 0x957
     9b8:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     9bc:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     9c0:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     9c4:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     9c8:	63530074 	cmpvs	r3, #116	; 0x74
     9cc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     9d0:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 46c <shift+0x46c>
     9d4:	57004644 	strpl	r4, [r0, -r4, asr #12]
     9d8:	00746961 	rsbseq	r6, r4, r1, ror #18
     9dc:	61736944 	cmnvs	r3, r4, asr #18
     9e0:	5f656c62 	svcpl	0x00656c62
     9e4:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     9e8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     9ec:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     9f0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     9f4:	314e5a5f 	cmpcc	lr, pc, asr sl
     9f8:	50474333 	subpl	r4, r7, r3, lsr r3
     9fc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     a00:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a04:	30317265 	eorscc	r7, r1, r5, ror #4
     a08:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a0c:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     a10:	76455152 			; <UNDEFINED> instruction: 0x76455152
     a14:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a18:	46433131 			; <UNDEFINED> instruction: 0x46433131
     a1c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a20:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a24:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     a28:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     a2c:	7a696c61 	bvc	1a5bbb8 <__bss_end+0x1a52160>
     a30:	00764565 	rsbseq	r4, r6, r5, ror #10
     a34:	5f746547 	svcpl	0x00746547
     a38:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a3c:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     a40:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a44:	505f746e 	subspl	r7, pc, lr, ror #8
     a48:	49006e69 	stmdbmi	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
     a4c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     a50:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     a54:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a58:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
     a5c:	6d007065 	stcvs	0, cr7, [r0, #-404]	; 0xfffffe6c
     a60:	746f6f52 	strbtvc	r6, [pc], #-3922	; a68 <shift+0xa68>
     a64:	7665445f 			; <UNDEFINED> instruction: 0x7665445f
     a68:	6f6f6200 	svcvs	0x006f6200
     a6c:	6c41006c 	mcrrvs	0, 6, r0, r1, cr12
     a70:	00315f74 	eorseq	r5, r1, r4, ror pc
     a74:	5f746c41 	svcpl	0x00746c41
     a78:	4c6d0032 	stclmi	0, cr0, [sp], #-200	; 0xffffff38
     a7c:	5f747361 	svcpl	0x00747361
     a80:	00444950 	subeq	r4, r4, r0, asr r9
     a84:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     a88:	0064656b 	rsbeq	r6, r4, fp, ror #10
     a8c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     a90:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a94:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     a98:	5f6f666e 	svcpl	0x006f666e
     a9c:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     aa0:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     aa4:	5f00355f 	svcpl	0x0000355f
     aa8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     aac:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     ab0:	61485f4f 	cmpvs	r8, pc, asr #30
     ab4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ab8:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     abc:	4f5f7465 	svcmi	0x005f7465
     ac0:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     ac4:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     ac8:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     acc:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     ad0:	544e0065 	strbpl	r0, [lr], #-101	; 0xffffff9b
     ad4:	5f6b7361 	svcpl	0x006b7361
     ad8:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     adc:	63730065 	cmnvs	r3, #101	; 0x65
     ae0:	5f646568 	svcpl	0x00646568
     ae4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     ae8:	00726574 	rsbseq	r6, r2, r4, ror r5
     aec:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     af0:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     af4:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     af8:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     afc:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     b00:	6e490079 	mcrvs	0, 2, r0, cr9, cr9, {3}
     b04:	61697469 	cmnvs	r9, r9, ror #8
     b08:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     b0c:	53466700 	movtpl	r6, #26368	; 0x6700
     b10:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     b14:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     b18:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     b1c:	6f635f74 	svcvs	0x00635f74
     b20:	49006564 	stmdbmi	r0, {r2, r5, r6, r8, sl, sp, lr}
     b24:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     b28:	505f6469 	subspl	r6, pc, r9, ror #8
     b2c:	45006e69 	strmi	r6, [r0, #-3689]	; 0xfffff197
     b30:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     b34:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     b38:	5f746e65 	svcpl	0x00746e65
     b3c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     b40:	73007463 	movwvc	r7, #1123	; 0x463
     b44:	4f495047 	svcmi	0x00495047
     b48:	63536d00 	cmpvs	r3, #0, 26
     b4c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b50:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     b54:	7300636e 	movwvc	r6, #878	; 0x36e
     b58:	636f7250 	cmnvs	pc, #80, 4
     b5c:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
     b60:	4d007267 	sfmmi	f7, 4, [r0, #-412]	; 0xfffffe64
     b64:	53467861 	movtpl	r7, #26721	; 0x6861
     b68:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     b6c:	614e7265 	cmpvs	lr, r5, ror #4
     b70:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     b74:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     b78:	746f4e00 	strbtvc	r4, [pc], #-3584	; b80 <shift+0xb80>
     b7c:	00796669 	rsbseq	r6, r9, r9, ror #12
     b80:	61666544 	cmnvs	r6, r4, asr #10
     b84:	5f746c75 	svcpl	0x00746c75
     b88:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     b8c:	61525f6b 	cmpvs	r2, fp, ror #30
     b90:	57006574 	smlsdxpl	r0, r4, r5, r6
     b94:	5f746961 	svcpl	0x00746961
     b98:	5f726f46 	svcpl	0x00726f46
     b9c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     ba0:	5a5f0074 	bpl	17c0d78 <__bss_end+0x17b7320>
     ba4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     ba8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     bac:	61485f4f 	cmpvs	r8, pc, asr #30
     bb0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     bb4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     bb8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bbc:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     bc0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     bc4:	6f697461 	svcvs	0x00697461
     bc8:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     bcc:	5f30536a 	svcpl	0x0030536a
     bd0:	636f4c00 	cmnvs	pc, #0, 24
     bd4:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     bd8:	6b636f6c 	blvs	18dc990 <__bss_end+0x18d2f38>
     bdc:	47006465 	strmi	r6, [r0, -r5, ror #8]
     be0:	5f4f4950 	svcpl	0x004f4950
     be4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     be8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     bec:	5f50475f 	svcpl	0x0050475f
     bf0:	5f515249 	svcpl	0x00515249
     bf4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     bf8:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     bfc:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c00:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c04:	49464e49 	stmdbmi	r6, {r0, r3, r6, r9, sl, fp, lr}^
     c08:	5954494e 	ldmdbpl	r4, {r1, r2, r3, r6, r8, fp, lr}^
     c0c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c10:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     c14:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     c18:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c1c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c20:	6b636f4c 	blvs	18dc958 <__bss_end+0x18d2f00>
     c24:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c28:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c2c:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     c30:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c34:	61767265 	cmnvs	r6, r5, ror #4
     c38:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c3c:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     c40:	00657469 	rsbeq	r7, r5, r9, ror #8
     c44:	5f746547 	svcpl	0x00746547
     c48:	53465047 	movtpl	r5, #24647	; 0x6047
     c4c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     c50:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c54:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c58:	5f746553 	svcpl	0x00746553
     c5c:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     c60:	52007475 	andpl	r7, r0, #1962934272	; 0x75000000
     c64:	5f646165 	svcpl	0x00646165
     c68:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c6c:	6f5a0065 	svcvs	0x005a0065
     c70:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     c74:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c78:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     c7c:	5f4f4950 	svcpl	0x004f4950
     c80:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     c84:	3172656c 	cmncc	r2, ip, ror #10
     c88:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     c8c:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     c90:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     c94:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     c98:	6a456e6f 	bvs	115c65c <__bss_end+0x1152c04>
     c9c:	474e3431 	smlaldxmi	r3, lr, r1, r4
     ca0:	5f4f4950 	svcpl	0x004f4950
     ca4:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     ca8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     cac:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     cb0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     cb4:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     cb8:	006f666e 	rsbeq	r6, pc, lr, ror #12
     cbc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; c08 <shift+0xc08>
     cc0:	616a2f65 	cmnvs	sl, r5, ror #30
     cc4:	6173656d 	cmnvs	r3, sp, ror #10
     cc8:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     ccc:	6f2f7469 	svcvs	0x002f7469
     cd0:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     cd4:	756f732f 	strbvc	r7, [pc, #-815]!	; 9ad <shift+0x9ad>
     cd8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     cdc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     ce0:	61707372 	cmnvs	r0, r2, ror r3
     ce4:	742f6563 	strtvc	r6, [pc], #-1379	; cec <shift+0xcec>
     ce8:	5f746c69 	svcpl	0x00746c69
     cec:	6b736174 	blvs	1cd92c4 <__bss_end+0x1ccf86c>
     cf0:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     cf4:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     cf8:	5a5f0070 	bpl	17c0ec0 <__bss_end+0x17b7468>
     cfc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d00:	636f7250 	cmnvs	pc, #80, 4
     d04:	5f737365 	svcpl	0x00737365
     d08:	616e614d 	cmnvs	lr, sp, asr #2
     d0c:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     d10:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d14:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d18:	5f007645 	svcpl	0x00007645
     d1c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d20:	6f725043 	svcvs	0x00725043
     d24:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d28:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     d2c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d30:	614d3931 	cmpvs	sp, r1, lsr r9
     d34:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d38:	545f656c 	ldrbpl	r6, [pc], #-1388	; d40 <shift+0xd40>
     d3c:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     d40:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     d44:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     d48:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     d4c:	69440065 	stmdbvs	r4, {r0, r2, r5, r6}^
     d50:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d54:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     d58:	5f746e65 	svcpl	0x00746e65
     d5c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d60:	47007463 	strmi	r7, [r0, -r3, ror #8]
     d64:	505f7465 	subspl	r7, pc, r5, ror #8
     d68:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     d6c:	68630073 	stmdavs	r3!, {r0, r1, r4, r5, r6}^
     d70:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     d74:	4d006e65 	stcmi	14, cr6, [r0, #-404]	; 0xfffffe6c
     d78:	61507861 	cmpvs	r0, r1, ror #16
     d7c:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     d80:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     d84:	736e7500 	cmnvc	lr, #0, 10
     d88:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     d8c:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     d90:	5f007261 	svcpl	0x00007261
     d94:	314b4e5a 	cmpcc	fp, sl, asr lr
     d98:	50474333 	subpl	r4, r7, r3, lsr r3
     d9c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     da0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     da4:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     da8:	5f746547 	svcpl	0x00746547
     dac:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     db0:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     db4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     db8:	505f746e 	subspl	r7, pc, lr, ror #8
     dbc:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     dc0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dc4:	50433631 	subpl	r3, r3, r1, lsr r6
     dc8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     dcc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c08 <shift+0xc08>
     dd0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     dd4:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     dd8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ddc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     de0:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     de4:	43007645 	movwmi	r7, #1605	; 0x645
     de8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     dec:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     df0:	47006d65 	strmi	r6, [r0, -r5, ror #26]
     df4:	5f4f4950 	svcpl	0x004f4950
     df8:	5f6e6950 	svcpl	0x006e6950
     dfc:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     e00:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     e04:	2074726f 	rsbscs	r7, r4, pc, ror #4
     e08:	00746e69 	rsbseq	r6, r4, r9, ror #28
     e0c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     e10:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 8ac <shift+0x8ac>
     e14:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e18:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e1c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e20:	5f006e6f 	svcpl	0x00006e6f
     e24:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     e28:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     e2c:	61485f4f 	cmpvs	r8, pc, asr #30
     e30:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     e34:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     e38:	6550006a 	ldrbvs	r0, [r0, #-106]	; 0xffffff96
     e3c:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     e40:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     e44:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     e48:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     e4c:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     e50:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e54:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e58:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e5c:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     e60:	7552006b 	ldrbvc	r0, [r2, #-107]	; 0xffffff95
     e64:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     e68:	5a5f0067 	bpl	17c100c <__bss_end+0x17b75b4>
     e6c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     e70:	4f495047 	svcmi	0x00495047
     e74:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     e78:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     e7c:	61573431 	cmpvs	r7, r1, lsr r4
     e80:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
     e84:	455f726f 	ldrbmi	r7, [pc, #-623]	; c1d <shift+0xc1d>
     e88:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e8c:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     e90:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e94:	6974006a 	ldmdbvs	r4!, {r1, r3, r5, r6}^
     e98:	6573746c 	ldrbvs	r7, [r3, #-1132]!	; 0xfffffb94
     e9c:	726f736e 	rsbvc	r7, pc, #-1207959551	; 0xb8000001
     ea0:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     ea4:	69750065 	ldmdbvs	r5!, {r0, r2, r5, r6}^
     ea8:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     eac:	5200745f 	andpl	r7, r0, #1593835520	; 0x5f000000
     eb0:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     eb4:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     eb8:	47006e69 	strmi	r6, [r0, -r9, ror #28]
     ebc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     ec0:	5f4f4950 	svcpl	0x004f4950
     ec4:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     ec8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ecc:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     ed0:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     ed4:	00657361 	rsbeq	r7, r5, r1, ror #6
     ed8:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     edc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     ee0:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     ee4:	6f4e5f6b 	svcvs	0x004e5f6b
     ee8:	5f006564 	svcpl	0x00006564
     eec:	31314e5a 	teqcc	r1, sl, asr lr
     ef0:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     ef4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ef8:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     efc:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     f00:	634b5045 	movtvs	r5, #45125	; 0xb045
     f04:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     f08:	5f656c69 	svcpl	0x00656c69
     f0c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     f10:	646f4d5f 	strbtvs	r4, [pc], #-3423	; f18 <shift+0xf18>
     f14:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f18:	50475f74 	subpl	r5, r7, r4, ror pc
     f1c:	5f544553 	svcpl	0x00544553
     f20:	61636f4c 	cmnvs	r3, ip, asr #30
     f24:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f28:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f2c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     f30:	4f495047 	svcmi	0x00495047
     f34:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     f38:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     f3c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     f40:	50475f74 	subpl	r5, r7, r4, ror pc
     f44:	5f56454c 	svcpl	0x0056454c
     f48:	61636f4c 	cmnvs	r3, ip, asr #30
     f4c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f50:	6a526a45 	bvs	149b86c <__bss_end+0x1491e14>
     f54:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     f58:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     f5c:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     f60:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     f64:	64007365 	strvs	r7, [r0], #-869	; 0xfffffc9b
     f68:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     f6c:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     f70:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     f74:	4f5f6461 	svcmi	0x005f6461
     f78:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     f7c:	61656c43 	cmnvs	r5, r3, asr #24
     f80:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     f84:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     f88:	455f6465 	ldrbmi	r6, [pc, #-1125]	; b2b <shift+0xb2b>
     f8c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     f90:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     f94:	745f7065 	ldrbvc	r7, [pc], #-101	; f9c <shift+0xf9c>
     f98:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     f9c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fa0:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     fa4:	636f7250 	cmnvs	pc, #80, 4
     fa8:	5f737365 	svcpl	0x00737365
     fac:	616e614d 	cmnvs	lr, sp, asr #2
     fb0:	31726567 	cmncc	r2, r7, ror #10
     fb4:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     fb8:	6f72505f 	svcvs	0x0072505f
     fbc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fc0:	5f79425f 	svcpl	0x0079425f
     fc4:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     fc8:	6148006a 	cmpvs	r8, sl, rrx
     fcc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     fd0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     fd4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     fd8:	5f6d6574 	svcpl	0x006d6574
     fdc:	00495753 	subeq	r5, r9, r3, asr r7
     fe0:	314e5a5f 	cmpcc	lr, pc, asr sl
     fe4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     fe8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fec:	614d5f73 	hvcvs	54771	; 0xd5f3
     ff0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     ff4:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     ff8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ffc:	5f656c75 	svcpl	0x00656c75
    1000:	76455252 			; <UNDEFINED> instruction: 0x76455252
    1004:	73617400 	cmnvc	r1, #0, 8
    1008:	7269006b 	rsbvc	r0, r9, #107	; 0x6b
    100c:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1010:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1014:	706e495f 	rsbvc	r4, lr, pc, asr r9
    1018:	4e007475 	mcrmi	4, 0, r7, cr0, cr5, {3}
    101c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1020:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
    1024:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1028:	63530073 	cmpvs	r3, #115	; 0x73
    102c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1030:	5f00656c 	svcpl	0x0000656c
    1034:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1038:	6f725043 	svcvs	0x00725043
    103c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1040:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1044:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1048:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
    104c:	5f6b636f 	svcpl	0x006b636f
    1050:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    1054:	5f746e65 	svcpl	0x00746e65
    1058:	636f7250 	cmnvs	pc, #80, 4
    105c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    1060:	5a5f0076 	bpl	17c1240 <__bss_end+0x17b77e8>
    1064:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1068:	636f7250 	cmnvs	pc, #80, 4
    106c:	5f737365 	svcpl	0x00737365
    1070:	616e614d 	cmnvs	lr, sp, asr #2
    1074:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    1078:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    107c:	545f6863 	ldrbpl	r6, [pc], #-2147	; 1084 <shift+0x1084>
    1080:	3150456f 	cmpcc	r0, pc, ror #10
    1084:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    1088:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    108c:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1090:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    1094:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1098:	4b4e5a5f 	blmi	1397a1c <__bss_end+0x138dfc4>
    109c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    10a0:	5f4f4950 	svcpl	0x004f4950
    10a4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10a8:	3172656c 	cmncc	r2, ip, ror #10
    10ac:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    10b0:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
    10b4:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
    10b8:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    10bc:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    10c0:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    10c4:	53005f30 	movwpl	r5, #3888	; 0xf30
    10c8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10cc:	5f656c75 	svcpl	0x00656c75
    10d0:	47005252 	smlsdmi	r0, r2, r2, r5
    10d4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    10d8:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
    10dc:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    10e0:	6f697461 	svcvs	0x00697461
    10e4:	5a5f006e 	bpl	17c12a4 <__bss_end+0x17b784c>
    10e8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    10ec:	636f7250 	cmnvs	pc, #80, 4
    10f0:	5f737365 	svcpl	0x00737365
    10f4:	616e614d 	cmnvs	lr, sp, asr #2
    10f8:	31726567 	cmncc	r2, r7, ror #10
    10fc:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
    1100:	5f656c64 	svcpl	0x00656c64
    1104:	636f7250 	cmnvs	pc, #80, 4
    1108:	5f737365 	svcpl	0x00737365
    110c:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    1110:	534e3032 	movtpl	r3, #57394	; 0xe032
    1114:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
    1118:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    111c:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    1120:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1124:	6a6a6563 	bvs	1a9a6b8 <__bss_end+0x1a90c60>
    1128:	3131526a 	teqcc	r1, sl, ror #4
    112c:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    1130:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    1134:	00746c75 	rsbseq	r6, r4, r5, ror ip
    1138:	76677261 	strbtvc	r7, [r7], -r1, ror #4
    113c:	4f494e00 	svcmi	0x00494e00
    1140:	5f6c7443 	svcpl	0x006c7443
    1144:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1148:	6f697461 	svcvs	0x00697461
    114c:	5a5f006e 	bpl	17c130c <__bss_end+0x17b78b4>
    1150:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1154:	636f7250 	cmnvs	pc, #80, 4
    1158:	5f737365 	svcpl	0x00737365
    115c:	616e614d 	cmnvs	lr, sp, asr #2
    1160:	31726567 	cmncc	r2, r7, ror #10
    1164:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
    1168:	5f657461 	svcpl	0x00657461
    116c:	636f7250 	cmnvs	pc, #80, 4
    1170:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    1174:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
    1178:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
    117c:	5f686374 	svcpl	0x00686374
    1180:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
    1184:	5f495753 	svcpl	0x00495753
    1188:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    118c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1190:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1194:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1198:	5f006563 	svcpl	0x00006563
    119c:	314b4e5a 	cmpcc	fp, sl, asr lr
    11a0:	50474333 	subpl	r4, r7, r3, lsr r3
    11a4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11a8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11ac:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    11b0:	5f746547 	svcpl	0x00746547
    11b4:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
    11b8:	6f4c5f54 	svcvs	0x004c5f54
    11bc:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    11c0:	6a456e6f 	bvs	115cb84 <__bss_end+0x115312c>
    11c4:	30536a52 	subscc	r6, r3, r2, asr sl
    11c8:	6e49005f 	mcrvs	0, 2, r0, cr9, cr15, {2}
    11cc:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    11d0:	61485f64 	cmpvs	r8, r4, ror #30
    11d4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11d8:	53465400 	movtpl	r5, #25600	; 0x6400
    11dc:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    11e0:	6f4e5f65 	svcvs	0x004e5f65
    11e4:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
    11e8:	6b636f6c 	blvs	18dcfa0 <__bss_end+0x18d3548>
    11ec:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    11f0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    11f4:	6f72505f 	svcvs	0x0072505f
    11f8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    11fc:	6e697000 	cdpvs	0, 6, cr7, cr9, cr0, {0}
    1200:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
    1204:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
    1208:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    120c:	5a5f006e 	bpl	17c13cc <__bss_end+0x17b7974>
    1210:	33314b4e 	teqcc	r1, #79872	; 0x13800
    1214:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1218:	61485f4f 	cmpvs	r8, pc, asr #30
    121c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1220:	47373172 			; <UNDEFINED> instruction: 0x47373172
    1224:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1228:	5f4f4950 	svcpl	0x004f4950
    122c:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
    1230:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1234:	43006a45 	movwmi	r6, #2629	; 0xa45
    1238:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    123c:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
    1240:	00726576 	rsbseq	r6, r2, r6, ror r5
    1244:	63677261 	cmnvs	r7, #268435462	; 0x10000006
    1248:	69464900 	stmdbvs	r6, {r8, fp, lr}^
    124c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1250:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1254:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    1258:	00726576 	rsbseq	r6, r2, r6, ror r5
    125c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1260:	61485f4f 	cmpvs	r8, pc, asr #30
    1264:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1268:	6e550072 	mrcvs	0, 2, r0, cr5, cr2, {3}
    126c:	63657073 	cmnvs	r5, #115	; 0x73
    1270:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
    1274:	72570064 	subsvc	r0, r7, #100	; 0x64
    1278:	5f657469 	svcpl	0x00657469
    127c:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
    1280:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1284:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
    1288:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
    128c:	5f00646c 	svcpl	0x0000646c
    1290:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1294:	6f725043 	svcvs	0x00725043
    1298:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    129c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    12a0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    12a4:	76453443 	strbvc	r3, [r5], -r3, asr #8
    12a8:	6f526d00 	svcvs	0x00526d00
    12ac:	4d5f746f 	cfldrdmi	mvd7, [pc, #-444]	; 10f8 <shift+0x10f8>
    12b0:	6300746e 	movwvs	r7, #1134	; 0x46e
    12b4:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
    12b8:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
    12bc:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    12c0:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    12c4:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    12c8:	434f4900 	movtmi	r4, #63744	; 0xf900
    12cc:	48006c74 	stmdami	r0, {r2, r4, r5, r6, sl, fp, sp, lr}
    12d0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    12d4:	52495f65 	subpl	r5, r9, #404	; 0x194
    12d8:	6f6c0051 	svcvs	0x006c0051
    12dc:	70697067 	rsbvc	r7, r9, r7, rrx
    12e0:	6c630065 	stclvs	0, cr0, [r3], #-404	; 0xfffffe6c
    12e4:	0065736f 	rsbeq	r7, r5, pc, ror #6
    12e8:	5f746553 	svcpl	0x00746553
    12ec:	616c6552 	cmnvs	ip, r2, asr r5
    12f0:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    12f4:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    12f8:	006c6176 	rsbeq	r6, ip, r6, ror r1
    12fc:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
    1300:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    1304:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1308:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    130c:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
    1310:	5f006d75 	svcpl	0x00006d75
    1314:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    1318:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    131c:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    1320:	0076646c 	rsbseq	r6, r6, ip, ror #8
    1324:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
    1328:	5f746573 	svcpl	0x00746573
    132c:	6b736174 	blvs	1cd9904 <__bss_end+0x1ccfeac>
    1330:	6165645f 	cmnvs	r5, pc, asr r4
    1334:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1338:	77006a65 	strvc	r6, [r0, -r5, ror #20]
    133c:	00746961 	rsbseq	r6, r4, r1, ror #18
    1340:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
    1344:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1348:	006a6a79 	rsbeq	r6, sl, r9, ror sl
    134c:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
    1350:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1354:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1358:	61460069 	cmpvs	r6, r9, rrx
    135c:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
    1360:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    1364:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1368:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    136c:	5f746567 	svcpl	0x00746567
    1370:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1374:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1378:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    137c:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    1380:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1384:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
    1388:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    138c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1390:	7165725f 	cmnvc	r5, pc, asr r2
    1394:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
    1398:	69500064 	ldmdbvs	r0, {r2, r5, r6}^
    139c:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    13a0:	5f656c69 	svcpl	0x00656c69
    13a4:	66657250 			; <UNDEFINED> instruction: 0x66657250
    13a8:	5f007869 	svcpl	0x00007869
    13ac:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    13b0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 13b8 <shift+0x13b8>
    13b4:	5f6b6369 	svcpl	0x006b6369
    13b8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    13bc:	73007674 	movwvc	r7, #1652	; 0x674
    13c0:	7065656c 	rsbvc	r6, r5, ip, ror #10
    13c4:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
    13c8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    13cc:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    13d0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    13d4:	6f00656e 	svcvs	0x0000656e
    13d8:	61726570 	cmnvs	r2, r0, ror r5
    13dc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    13e0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    13e4:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    13e8:	2f006a65 	svccs	0x00006a65
    13ec:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    13f0:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    13f4:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    13f8:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    13fc:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    1400:	2f70732f 	svccs	0x0070732f
    1404:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1408:	2f736563 	svccs	0x00736563
    140c:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1410:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    1414:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1418:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    141c:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1420:	5f007070 	svcpl	0x00007070
    1424:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
    1428:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    142c:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
    1430:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1434:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1438:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    143c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1440:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1444:	5a5f006e 	bpl	17c1604 <__bss_end+0x17b7bac>
    1448:	70697034 	rsbvc	r7, r9, r4, lsr r0
    144c:	634b5065 	movtvs	r5, #45157	; 0xb065
    1450:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    1454:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1458:	5f656e69 	svcpl	0x00656e69
    145c:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1460:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1464:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1468:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1470 <shift+0x1470>
    146c:	5f6b6369 	svcpl	0x006b6369
    1470:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1474:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
    1478:	2f656d6f 	svccs	0x00656d6f
    147c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    1480:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    1484:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    1488:	2f736f2f 	svccs	0x00736f2f
    148c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1490:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1494:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    1498:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    149c:	72617000 	rsbvc	r7, r1, #0
    14a0:	5f006d61 	svcpl	0x00006d61
    14a4:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
    14a8:	6a657469 	bvs	195e654 <__bss_end+0x1954bfc>
    14ac:	6a634b50 	bvs	18d41f4 <__bss_end+0x18ca79c>
    14b0:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    14b4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    14b8:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    14bc:	5f736b63 	svcpl	0x00736b63
    14c0:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 14c8 <shift+0x14c8>
    14c4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    14c8:	00656e69 	rsbeq	r6, r5, r9, ror #28
    14cc:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    14d0:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    14d4:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    14d8:	5f00657a 	svcpl	0x0000657a
    14dc:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    14e0:	6a706565 	bvs	1c1aa7c <__bss_end+0x1c11024>
    14e4:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
    14e8:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    14ec:	6e69616d 	powvsez	f6, f1, #5.0
    14f0:	00676e69 	rsbeq	r6, r7, r9, ror #28
    14f4:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
    14f8:	5f746567 	svcpl	0x00746567
    14fc:	6b736174 	blvs	1cd9ad4 <__bss_end+0x1cd007c>
    1500:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1504:	745f736b 	ldrbvc	r7, [pc], #-875	; 150c <shift+0x150c>
    1508:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    150c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1510:	0076656e 	rsbseq	r6, r6, lr, ror #10
    1514:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    1518:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    151c:	5f746c75 	svcpl	0x00746c75
    1520:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    1524:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    1528:	5f006d75 	svcpl	0x00006d75
    152c:	6177345a 	cmnvs	r7, sl, asr r4
    1530:	6a6a7469 	bvs	1a9e6dc <__bss_end+0x1a94c84>
    1534:	5a5f006a 	bpl	17c16e4 <__bss_end+0x17b7c8c>
    1538:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    153c:	316a6c74 	smccc	42692	; 0xa6c4
    1540:	4f494e36 	svcmi	0x00494e36
    1544:	5f6c7443 	svcpl	0x006c7443
    1548:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    154c:	6f697461 	svcvs	0x00697461
    1550:	0076506e 	rsbseq	r5, r6, lr, rrx
    1554:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1558:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    155c:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    1560:	646f6d00 	strbtvs	r6, [pc], #-3328	; 1568 <shift+0x1568>
    1564:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1568:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    156c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1570:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1574:	6a63506a 	bvs	18d5724 <__bss_end+0x18cbccc>
    1578:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    157c:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1580:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1584:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    1588:	5f657669 	svcpl	0x00657669
    158c:	636f7270 	cmnvs	pc, #112, 4
    1590:	5f737365 	svcpl	0x00737365
    1594:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1598:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
    159c:	616e656c 	cmnvs	lr, ip, ror #10
    15a0:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
    15a4:	00646165 	rsbeq	r6, r4, r5, ror #2
    15a8:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    15ac:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    15b0:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    15b4:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    15b8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    15bc:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    15c0:	31634b50 	cmncc	r3, r0, asr fp
    15c4:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    15c8:	4f5f656c 	svcmi	0x005f656c
    15cc:	5f6e6570 	svcpl	0x006e6570
    15d0:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    15d4:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    15d8:	2b2b4320 	blcs	ad2260 <__bss_end+0xac8808>
    15dc:	39203431 	stmdbcc	r0!, {r0, r4, r5, sl, ip, sp}
    15e0:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    15e4:	31303220 	teqcc	r0, r0, lsr #4
    15e8:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    15ec:	72282035 	eorvc	r2, r8, #53	; 0x35
    15f0:	61656c65 	cmnvs	r5, r5, ror #24
    15f4:	20296573 	eorcs	r6, r9, r3, ror r5
    15f8:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    15fc:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1600:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    1604:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1608:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    160c:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1610:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    1614:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1618:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    161c:	6f6c666d 	svcvs	0x006c666d
    1620:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1624:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1628:	20647261 	rsbcs	r7, r4, r1, ror #4
    162c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1630:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1634:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    1638:	616f6c66 	cmnvs	pc, r6, ror #24
    163c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1640:	61683d69 	cmnvs	r8, r9, ror #26
    1644:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1648:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    164c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1650:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
    1654:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
    1658:	316d7261 	cmncc	sp, r1, ror #4
    165c:	6a363731 	bvs	d8f328 <__bss_end+0xd858d0>
    1660:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
    1664:	616d2d20 	cmnvs	sp, r0, lsr #26
    1668:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    166c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1670:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1674:	7a36766d 	bvc	d9f030 <__bss_end+0xd955d8>
    1678:	70662b6b 	rsbvc	r2, r6, fp, ror #22
    167c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1680:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1684:	4f2d2067 	svcmi	0x002d2067
    1688:	4f2d2030 	svcmi	0x002d2030
    168c:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
    1690:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
    1694:	70656378 	rsbvc	r6, r5, r8, ror r3
    1698:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    169c:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    16a0:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
    16a4:	00697474 	rsbeq	r7, r9, r4, ror r4
    16a8:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    16ac:	70636d65 	rsbvc	r6, r3, r5, ror #26
    16b0:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    16b4:	00697650 	rsbeq	r7, r9, r0, asr r6
    16b8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1604 <shift+0x1604>
    16bc:	616a2f65 	cmnvs	sl, r5, ror #30
    16c0:	6173656d 	cmnvs	r3, sp, ror #10
    16c4:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    16c8:	6f2f7469 	svcvs	0x002f7469
    16cc:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    16d0:	756f732f 	strbvc	r7, [pc, #-815]!	; 13a9 <shift+0x13a9>
    16d4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    16d8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    16dc:	2f62696c 	svccs	0x0062696c
    16e0:	2f637273 	svccs	0x00637273
    16e4:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    16e8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    16ec:	70632e67 	rsbvc	r2, r3, r7, ror #28
    16f0:	65720070 	ldrbvs	r0, [r2, #-112]!	; 0xffffff90
    16f4:	6e69616d 	powvsez	f6, f1, #5.0
    16f8:	00726564 	rsbseq	r6, r2, r4, ror #10
    16fc:	616e7369 	cmnvs	lr, r9, ror #6
    1700:	6e69006e 	cdpvs	0, 6, cr0, cr9, cr14, {3}
    1704:	72676574 	rsbvc	r6, r7, #116, 10	; 0x1d000000
    1708:	69006c61 	stmdbvs	r0, {r0, r5, r6, sl, fp, sp, lr}
    170c:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    1710:	63656400 	cmnvs	r5, #0, 8
    1714:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    1718:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    171c:	616f7469 	cmnvs	pc, r9, ror #8
    1720:	6a63506a 	bvs	18d58d0 <__bss_end+0x18cbe78>
    1724:	6f746100 	svcvs	0x00746100
    1728:	6f700069 	svcvs	0x00700069
    172c:	5f746e69 	svcpl	0x00746e69
    1730:	6e656573 	mcrvs	5, 3, r6, cr5, cr3, {3}
    1734:	72747300 	rsbsvc	r7, r4, #0, 6
    1738:	5f676e69 	svcpl	0x00676e69
    173c:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    1740:	736c616d 	cmnvc	ip, #1073741851	; 0x4000001b
    1744:	776f7000 	strbvc	r7, [pc, -r0]!
    1748:	73007265 	movwvc	r7, #613	; 0x265
    174c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1750:	6e695f67 	cdpvs	15, 6, cr5, cr9, cr7, {3}
    1754:	656c5f74 	strbvs	r5, [ip, #-3956]!	; 0xfffff08c
    1758:	7865006e 	stmdavc	r5!, {r1, r2, r3, r5, r6}^
    175c:	656e6f70 	strbvs	r6, [lr, #-3952]!	; 0xfffff090
    1760:	5f00746e 	svcpl	0x0000746e
    1764:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1768:	4b50666f 	blmi	141b12c <__bss_end+0x14116d4>
    176c:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
    1770:	5f007473 	svcpl	0x00007473
    1774:	6572365a 	ldrbvs	r3, [r2, #-1626]!	; 0xfffff9a6
    1778:	72747376 	rsbsvc	r7, r4, #-671088639	; 0xd8000001
    177c:	5f006350 	svcpl	0x00006350
    1780:	7369355a 	cmnvc	r9, #377487360	; 0x16800000
    1784:	666e616e 	strbtvs	r6, [lr], -lr, ror #2
    1788:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    178c:	62007475 	andvs	r7, r0, #1962934272	; 0x75000000
    1790:	00657361 	rsbeq	r7, r5, r1, ror #6
    1794:	706d6574 	rsbvc	r6, sp, r4, ror r5
    1798:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    179c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    17a0:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    17a4:	72747300 	rsbsvc	r7, r4, #0, 6
    17a8:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    17ac:	6f746900 	svcvs	0x00746900
    17b0:	74730061 	ldrbtvc	r0, [r3], #-97	; 0xffffff9f
    17b4:	73003172 	movwvc	r3, #370	; 0x172
    17b8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    17bc:	6e695f67 	cdpvs	15, 6, cr5, cr9, cr7, {3}
    17c0:	5a5f0074 	bpl	17c1998 <__bss_end+0x17b7f40>
    17c4:	69736935 	ldmdbvs	r3!, {r0, r2, r4, r5, r8, fp, sp, lr}^
    17c8:	0066666e 	rsbeq	r6, r6, lr, ror #12
    17cc:	70335a5f 	eorsvc	r5, r3, pc, asr sl
    17d0:	6a66776f 	bvs	199f594 <__bss_end+0x1995b3c>
    17d4:	315a5f00 	cmpcc	sl, r0, lsl #30
    17d8:	6c707331 	ldclvs	3, cr7, [r0], #-196	; 0xffffff3c
    17dc:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    17e0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    17e4:	536a5266 	cmnpl	sl, #1610612742	; 0x60000006
    17e8:	0069525f 	rsbeq	r5, r9, pc, asr r2
    17ec:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    17f0:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    17f4:	00747364 	rsbseq	r7, r4, r4, ror #6
    17f8:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    17fc:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    1800:	00727241 	rsbseq	r7, r2, r1, asr #4
    1804:	616f7466 	cmnvs	pc, r6, ror #8
    1808:	325a5f00 	subscc	r5, sl, #0, 30
    180c:	63656433 	cmnvs	r5, #855638016	; 0x33000000
    1810:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    1814:	5f6f745f 	svcpl	0x006f745f
    1818:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    181c:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    1820:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1824:	6963506a 	stmdbvs	r3!, {r1, r3, r5, r6, ip, lr}^
    1828:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    182c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1830:	63657270 	cmnvs	r5, #112, 4
    1834:	6f697369 	svcvs	0x00697369
    1838:	7a62006e 	bvc	18819f8 <__bss_end+0x1877fa0>
    183c:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1840:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1844:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    1848:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
    184c:	72747300 	rsbsvc	r7, r4, #0, 6
    1850:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1854:	67696400 	strbvs	r6, [r9, -r0, lsl #8]!
    1858:	00737469 	rsbseq	r7, r3, r9, ror #8
    185c:	61345a5f 	teqvs	r4, pc, asr sl
    1860:	50696f74 	rsbpl	r6, r9, r4, ror pc
    1864:	6f00634b 	svcvs	0x0000634b
    1868:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    186c:	5a5f0074 	bpl	17c1a44 <__bss_end+0x17b7fec>
    1870:	6f746634 	svcvs	0x00746634
    1874:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    1878:	7073006a 	rsbsvc	r0, r3, sl, rrx
    187c:	5f74696c 	svcpl	0x0074696c
    1880:	616f6c66 	cmnvs	pc, r6, ror #24
    1884:	61660074 	smcvs	24580	; 0x6004
    1888:	5f007463 	svcpl	0x00007463
    188c:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1890:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1894:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1898:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    189c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    18a0:	4b50706d 	blmi	141da5c <__bss_end+0x1414004>
    18a4:	5f305363 	svcpl	0x00305363
    18a8:	5a5f0069 	bpl	17c1a54 <__bss_end+0x17b7ffc>
    18ac:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    18b0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    18b4:	4b506350 	blmi	141a5fc <__bss_end+0x1410ba4>
    18b8:	64006963 	strvs	r6, [r0], #-2403	; 0xfffff69d
    18bc:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    18c0:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 18c8 <shift+0x18c8>
    18c4:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    18c8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    18cc:	6f6c665f 	svcvs	0x006c665f
    18d0:	5f007461 	svcpl	0x00007461
    18d4:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    18d8:	5066616f 	rsbpl	r6, r6, pc, ror #2
    18dc:	656d0063 	strbvs	r0, [sp, #-99]!	; 0xffffff9d
    18e0:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    18e4:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    18e8:	00687467 	rsbeq	r7, r8, r7, ror #8
    18ec:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    18f0:	72006e65 	andvc	r6, r0, #1616	; 0x650
    18f4:	74737665 	ldrbtvc	r7, [r3], #-1637	; 0xfffff99b
    18f8:	2e2e0072 	mcrcs	0, 1, r0, cr14, cr2, {3}
    18fc:	2f2e2e2f 	svccs	0x002e2e2f
    1900:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1904:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1908:	2f2e2e2f 	svccs	0x002e2e2f
    190c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1910:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1914:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1918:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    191c:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    1920:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1924:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1928:	622f0053 	eorvs	r0, pc, #83	; 0x53
    192c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1930:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1934:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1938:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    193c:	61652d65 	cmnvs	r5, r5, ror #26
    1940:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    1944:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    1948:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    194c:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1950:	6f6e2d6d 	svcvs	0x006e2d6d
    1954:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1958:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    195c:	30322d39 	eorscc	r2, r2, r9, lsr sp
    1960:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1964:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    1968:	2f646c69 	svccs	0x00646c69
    196c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1970:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1974:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1978:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    197c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1980:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1984:	2f647261 	svccs	0x00647261
    1988:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    198c:	54006363 	strpl	r6, [r0], #-867	; 0xfffffc9d
    1990:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1994:	50435f54 	subpl	r5, r3, r4, asr pc
    1998:	6f635f55 	svcvs	0x00635f55
    199c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    19a0:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    19a4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19a8:	00376178 	eorseq	r6, r7, r8, ror r1
    19ac:	5f617369 	svcpl	0x00617369
    19b0:	5f746962 	svcpl	0x00746962
    19b4:	645f7066 	ldrbvs	r7, [pc], #-102	; 19bc <shift+0x19bc>
    19b8:	61006c62 	tstvs	r0, r2, ror #24
    19bc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    19c0:	5f686372 	svcpl	0x00686372
    19c4:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    19c8:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    19cc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19d0:	50435f54 	subpl	r5, r3, r4, asr pc
    19d4:	6f635f55 	svcvs	0x00635f55
    19d8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    19dc:	0033326d 	eorseq	r3, r3, sp, ror #4
    19e0:	5f4d5241 	svcpl	0x004d5241
    19e4:	54005145 	strpl	r5, [r0], #-325	; 0xfffffebb
    19e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19ec:	50435f54 	subpl	r5, r3, r4, asr pc
    19f0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    19f4:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    19f8:	66327436 			; <UNDEFINED> instruction: 0x66327436
    19fc:	73690073 	cmnvc	r9, #115	; 0x73
    1a00:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a04:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a08:	00626d75 	rsbeq	r6, r2, r5, ror sp
    1a0c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a10:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a14:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1a18:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a1c:	37356178 			; <UNDEFINED> instruction: 0x37356178
    1a20:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a24:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a28:	41420033 	cmpmi	r2, r3, lsr r0
    1a2c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a30:	5f484352 	svcpl	0x00484352
    1a34:	425f4d38 	subsmi	r4, pc, #56, 26	; 0xe00
    1a38:	00455341 	subeq	r5, r5, r1, asr #6
    1a3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a44:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a48:	31386d72 	teqcc	r8, r2, ror sp
    1a4c:	41540030 	cmpmi	r4, r0, lsr r0
    1a50:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a54:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a58:	6567785f 	strbvs	r7, [r7, #-2143]!	; 0xfffff7a1
    1a5c:	0031656e 	eorseq	r6, r1, lr, ror #10
    1a60:	5f4d5241 	svcpl	0x004d5241
    1a64:	5f534350 	svcpl	0x00534350
    1a68:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1a6c:	57495f53 	smlsldpl	r5, r9, r3, pc	; <UNPREDICTABLE>
    1a70:	54584d4d 	ldrbpl	r4, [r8], #-3405	; 0xfffff2b3
    1a74:	53414200 	movtpl	r4, #4608	; 0x1200
    1a78:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a7c:	305f4843 	subscc	r4, pc, r3, asr #16
    1a80:	53414200 	movtpl	r4, #4608	; 0x1200
    1a84:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a88:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1a8c:	53414200 	movtpl	r4, #4608	; 0x1200
    1a90:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a94:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1a98:	53414200 	movtpl	r4, #4608	; 0x1200
    1a9c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1aa0:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1aa8 <shift+0x1aa8>
    1aa4:	53414200 	movtpl	r4, #4608	; 0x1200
    1aa8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1aac:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1ab0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ab4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ab8:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1abc:	52415400 	subpl	r5, r1, #0, 8
    1ac0:	5f544547 	svcpl	0x00544547
    1ac4:	5f555043 	svcpl	0x00555043
    1ac8:	61637378 	smcvs	14136	; 0x3738
    1acc:	6900656c 	stmdbvs	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
    1ad0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ad4:	705f7469 	subsvc	r7, pc, r9, ror #8
    1ad8:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    1adc:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    1ae0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ae4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ae8:	6f635f55 	svcvs	0x00635f55
    1aec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1af0:	0033336d 	eorseq	r3, r3, sp, ror #6
    1af4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1af8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1afc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b00:	74376d72 	ldrtvc	r6, [r7], #-3442	; 0xfffff28e
    1b04:	00696d64 	rsbeq	r6, r9, r4, ror #26
    1b08:	5f617369 	svcpl	0x00617369
    1b0c:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1b10:	41540074 	cmpmi	r4, r4, ror r0
    1b14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b1c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b20:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1b24:	73667a6a 	cmnvc	r6, #434176	; 0x6a000
    1b28:	61736900 	cmnvs	r3, r0, lsl #18
    1b2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b30:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1b34:	41003276 	tstmi	r0, r6, ror r2
    1b38:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1b3c:	555f5343 	ldrbpl	r5, [pc, #-835]	; 1801 <shift+0x1801>
    1b40:	4f4e4b4e 	svcmi	0x004e4b4e
    1b44:	54004e57 	strpl	r4, [r0], #-3671	; 0xfffff1a9
    1b48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b50:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b54:	0065396d 	rsbeq	r3, r5, sp, ror #18
    1b58:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1b5c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1b60:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1b64:	61004a45 	tstvs	r0, r5, asr #20
    1b68:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1b6c:	6d736663 	ldclvs	6, cr6, [r3, #-396]!	; 0xfffffe74
    1b70:	6174735f 	cmnvs	r4, pc, asr r3
    1b74:	61006574 	tstvs	r0, r4, ror r5
    1b78:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b7c:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1b80:	75006574 	strvc	r6, [r0, #-1396]	; 0xfffffa8c
    1b84:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1b88:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
    1b8c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1b90:	73690073 	cmnvc	r9, #115	; 0x73
    1b94:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b98:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1b9c:	5f5f0063 	svcpl	0x005f0063
    1ba0:	5f7a6c63 	svcpl	0x007a6c63
    1ba4:	00626174 	rsbeq	r6, r2, r4, ror r1
    1ba8:	5f4d5241 	svcpl	0x004d5241
    1bac:	61004356 	tstvs	r0, r6, asr r3
    1bb0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1bb4:	5f686372 	svcpl	0x00686372
    1bb8:	61637378 	smcvs	14136	; 0x3738
    1bbc:	4100656c 	tstmi	r0, ip, ror #10
    1bc0:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1bc4:	52410045 	subpl	r0, r1, #69	; 0x45
    1bc8:	53565f4d 	cmppl	r6, #308	; 0x134
    1bcc:	4d524100 	ldfmie	f4, [r2, #-0]
    1bd0:	0045475f 	subeq	r4, r5, pc, asr r7
    1bd4:	5f6d7261 	svcpl	0x006d7261
    1bd8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1bdc:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1be0:	61676e6f 	cmnvs	r7, pc, ror #28
    1be4:	63006d72 	movwvs	r6, #3442	; 0xd72
    1be8:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    1bec:	66207865 	strtvs	r7, [r0], -r5, ror #16
    1bf0:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1bf4:	52415400 	subpl	r5, r1, #0, 8
    1bf8:	5f544547 	svcpl	0x00544547
    1bfc:	5f555043 	svcpl	0x00555043
    1c00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c04:	31617865 	cmncc	r1, r5, ror #16
    1c08:	41540035 	cmpmi	r4, r5, lsr r0
    1c0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c14:	3761665f 			; <UNDEFINED> instruction: 0x3761665f
    1c18:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1c1c:	52415400 	subpl	r5, r1, #0, 8
    1c20:	5f544547 	svcpl	0x00544547
    1c24:	5f555043 	svcpl	0x00555043
    1c28:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c2c:	31617865 	cmncc	r1, r5, ror #16
    1c30:	52410037 	subpl	r0, r1, #55	; 0x37
    1c34:	54475f4d 	strbpl	r5, [r7], #-3917	; 0xfffff0b3
    1c38:	52415400 	subpl	r5, r1, #0, 8
    1c3c:	5f544547 	svcpl	0x00544547
    1c40:	5f555043 	svcpl	0x00555043
    1c44:	766f656e 	strbtvc	r6, [pc], -lr, ror #10
    1c48:	65737265 	ldrbvs	r7, [r3, #-613]!	; 0xfffffd9b
    1c4c:	2e00316e 	adfcssz	f3, f0, #0.5
    1c50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c54:	2f2e2e2f 	svccs	0x002e2e2f
    1c58:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c5c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c60:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c64:	2f636367 	svccs	0x00636367
    1c68:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1c6c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1c70:	41540063 	cmpmi	r4, r3, rrx
    1c74:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c78:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c7c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c80:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1c84:	42006634 	andmi	r6, r0, #52, 12	; 0x3400000
    1c88:	5f455341 	svcpl	0x00455341
    1c8c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c90:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    1c94:	52415400 	subpl	r5, r1, #0, 8
    1c98:	5f544547 	svcpl	0x00544547
    1c9c:	5f555043 	svcpl	0x00555043
    1ca0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ca4:	31617865 	cmncc	r1, r5, ror #16
    1ca8:	61680032 	cmnvs	r8, r2, lsr r0
    1cac:	61766873 	cmnvs	r6, r3, ror r8
    1cb0:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1cb4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1cb8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1cbc:	4b365f48 	blmi	d999e4 <__bss_end+0xd8ff8c>
    1cc0:	7369005a 	cmnvc	r9, #90	; 0x5a
    1cc4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cc8:	61007374 	tstvs	r0, r4, ror r3
    1ccc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1cd0:	5f686372 	svcpl	0x00686372
    1cd4:	5f6d7261 	svcpl	0x006d7261
    1cd8:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1cdc:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1ce0:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1ce4:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    1ce8:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1cec:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cf0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1cf4:	00363170 	eorseq	r3, r6, r0, ror r1
    1cf8:	20554e47 	subscs	r4, r5, r7, asr #28
    1cfc:	20373143 	eorscs	r3, r7, r3, asr #2
    1d00:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    1d04:	30322031 	eorscc	r2, r2, r1, lsr r0
    1d08:	30313931 	eorscc	r3, r1, r1, lsr r9
    1d0c:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    1d10:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1d14:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1d18:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    1d1c:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    1d20:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    1d24:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    1d28:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    1d2c:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    1d30:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1d34:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1d38:	205d3939 	subscs	r3, sp, r9, lsr r9
    1d3c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1d40:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1d44:	616f6c66 	cmnvs	pc, r6, ror #24
    1d48:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1d4c:	61683d69 	cmnvs	r8, r9, ror #26
    1d50:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1d54:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1d58:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1d5c:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1d60:	70662b65 	rsbvc	r2, r6, r5, ror #22
    1d64:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1d68:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1d6c:	4f2d2067 	svcmi	0x002d2067
    1d70:	4f2d2032 	svcmi	0x002d2032
    1d74:	4f2d2032 	svcmi	0x002d2032
    1d78:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1d7c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1d80:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1d84:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1d88:	20636367 	rsbcs	r6, r3, r7, ror #6
    1d8c:	6f6e662d 	svcvs	0x006e662d
    1d90:	6174732d 	cmnvs	r4, sp, lsr #6
    1d94:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1d98:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1d9c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1da0:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1da4:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1da8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1dac:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1db0:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    1db4:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1db8:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1dbc:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1dc0:	4d524100 	ldfmie	f4, [r2, #-0]
    1dc4:	0049485f 	subeq	r4, r9, pc, asr r8
    1dc8:	5f617369 	svcpl	0x00617369
    1dcc:	5f746962 	svcpl	0x00746962
    1dd0:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1dd4:	52415400 	subpl	r5, r1, #0, 8
    1dd8:	5f544547 	svcpl	0x00544547
    1ddc:	5f555043 	svcpl	0x00555043
    1de0:	316d7261 	cmncc	sp, r1, ror #4
    1de4:	6a363331 	bvs	d8eab0 <__bss_end+0xd85058>
    1de8:	41540073 	cmpmi	r4, r3, ror r0
    1dec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1df0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1df4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1df8:	41540038 	cmpmi	r4, r8, lsr r0
    1dfc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e04:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e08:	41540039 	cmpmi	r4, r9, lsr r0
    1e0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e14:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1e18:	61003632 	tstvs	r0, r2, lsr r6
    1e1c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e20:	5f686372 	svcpl	0x00686372
    1e24:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1e28:	52415400 	subpl	r5, r1, #0, 8
    1e2c:	5f544547 	svcpl	0x00544547
    1e30:	5f555043 	svcpl	0x00555043
    1e34:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e38:	346d7865 	strbtcc	r7, [sp], #-2149	; 0xfffff79b
    1e3c:	52415400 	subpl	r5, r1, #0, 8
    1e40:	5f544547 	svcpl	0x00544547
    1e44:	5f555043 	svcpl	0x00555043
    1e48:	316d7261 	cmncc	sp, r1, ror #4
    1e4c:	54006530 	strpl	r6, [r0], #-1328	; 0xfffffad0
    1e50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e54:	50435f54 	subpl	r5, r3, r4, asr pc
    1e58:	6f635f55 	svcvs	0x00635f55
    1e5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e60:	6100376d 	tstvs	r0, sp, ror #14
    1e64:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1e68:	5f646e6f 	svcpl	0x00646e6f
    1e6c:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1e70:	4d524100 	ldfmie	f4, [r2, #-0]
    1e74:	5343505f 	movtpl	r5, #12383	; 0x305f
    1e78:	5041415f 	subpl	r4, r1, pc, asr r1
    1e7c:	69005343 	stmdbvs	r0, {r0, r1, r6, r8, r9, ip, lr}
    1e80:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e84:	615f7469 	cmpvs	pc, r9, ror #8
    1e88:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1e8c:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1e90:	5f455341 	svcpl	0x00455341
    1e94:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e98:	004d335f 	subeq	r3, sp, pc, asr r3
    1e9c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ea0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ea4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ea8:	31376d72 	teqcc	r7, r2, ror sp
    1eac:	61007430 	tstvs	r0, r0, lsr r4
    1eb0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1eb4:	5f686372 	svcpl	0x00686372
    1eb8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1ebc:	00327478 	eorseq	r7, r2, r8, ror r4
    1ec0:	5f617369 	svcpl	0x00617369
    1ec4:	5f6d756e 	svcpl	0x006d756e
    1ec8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1ecc:	52415400 	subpl	r5, r1, #0, 8
    1ed0:	5f544547 	svcpl	0x00544547
    1ed4:	5f555043 	svcpl	0x00555043
    1ed8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1edc:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1ee0:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1ee4:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1ee8:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1eec:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1ef0:	41540079 	cmpmi	r4, r9, ror r0
    1ef4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ef8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1efc:	7978655f 	ldmdbvc	r8!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1f00:	6d736f6e 	ldclvs	15, cr6, [r3, #-440]!	; 0xfffffe48
    1f04:	41540031 	cmpmi	r4, r1, lsr r0
    1f08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f14:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1f18:	69003235 	stmdbvs	r0, {r0, r2, r4, r5, r9, ip, sp}
    1f1c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f20:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1f28 <shift+0x1f28>
    1f24:	00766964 	rsbseq	r6, r6, r4, ror #18
    1f28:	66657270 			; <UNDEFINED> instruction: 0x66657270
    1f2c:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
    1f30:	5f6e6f65 	svcpl	0x006e6f65
    1f34:	5f726f66 	svcpl	0x00726f66
    1f38:	69623436 	stmdbvs	r2!, {r1, r2, r4, r5, sl, ip, sp}^
    1f3c:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1f40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f44:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f48:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1f4c:	54006c6d 	strpl	r6, [r0], #-3181	; 0xfffff393
    1f50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f54:	50435f54 	subpl	r5, r3, r4, asr pc
    1f58:	6f635f55 	svcvs	0x00635f55
    1f5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f60:	00323361 	eorseq	r3, r2, r1, ror #6
    1f64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f6c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f70:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f74:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    1f78:	61736900 	cmnvs	r3, r0, lsl #18
    1f7c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f80:	3170665f 	cmncc	r0, pc, asr r6
    1f84:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1f88:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
    1f8c:	63657073 	cmnvs	r5, #115	; 0x73
    1f90:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
    1f94:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1f98:	41540073 	cmpmi	r4, r3, ror r0
    1f9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fa0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fa4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1fa8:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1fac:	00733274 	rsbseq	r3, r3, r4, ror r2
    1fb0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fb4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fb8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1fbc:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    1fc0:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1fc4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fc8:	50435f54 	subpl	r5, r3, r4, asr pc
    1fcc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fd0:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    1fd4:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1fd8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1fdc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1fe0:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    1fe4:	61736900 	cmnvs	r3, r0, lsl #18
    1fe8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fec:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    1ff0:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    1ff4:	5f6d7261 	svcpl	0x006d7261
    1ff8:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    1ffc:	5f6e695f 	svcpl	0x006e695f
    2000:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    2004:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    2008:	61736900 	cmnvs	r3, r0, lsl #18
    200c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2010:	0062735f 	rsbeq	r7, r2, pc, asr r3
    2014:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2018:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    201c:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    2020:	73690045 	cmnvc	r9, #69	; 0x45
    2024:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    2028:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    202c:	73690065 	cmnvc	r9, #101	; 0x65
    2030:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2034:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    2038:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    203c:	61006c75 	tstvs	r0, r5, ror ip
    2040:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2044:	5f676e61 	svcpl	0x00676e61
    2048:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    204c:	6f5f7475 	svcvs	0x005f7475
    2050:	63656a62 	cmnvs	r5, #401408	; 0x62000
    2054:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
    2058:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
    205c:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
    2060:	6f6f685f 	svcvs	0x006f685f
    2064:	7369006b 	cmnvc	r9, #107	; 0x6b
    2068:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    206c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2070:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    2074:	4d524100 	ldfmie	f4, [r2, #-0]
    2078:	00454e5f 	subeq	r4, r5, pc, asr lr
    207c:	5f617369 	svcpl	0x00617369
    2080:	5f746962 	svcpl	0x00746962
    2084:	00386562 	eorseq	r6, r8, r2, ror #10
    2088:	47524154 			; <UNDEFINED> instruction: 0x47524154
    208c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2090:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2094:	31316d72 	teqcc	r1, r2, ror sp
    2098:	7a6a3637 	bvc	1a8f97c <__bss_end+0x1a85f24>
    209c:	72700073 	rsbsvc	r0, r0, #115	; 0x73
    20a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    20a4:	5f726f73 	svcpl	0x00726f73
    20a8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    20ac:	6c6c6100 	stfvse	f6, [ip], #-0
    20b0:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    20b4:	72610073 	rsbvc	r0, r1, #115	; 0x73
    20b8:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    20bc:	41420073 	hvcmi	8195	; 0x2003
    20c0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    20c4:	5f484352 	svcpl	0x00484352
    20c8:	61005435 	tstvs	r0, r5, lsr r4
    20cc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    20d0:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    20d4:	41540074 	cmpmi	r4, r4, ror r0
    20d8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20dc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20e0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    20e4:	61786574 	cmnvs	r8, r4, ror r5
    20e8:	6f633637 	svcvs	0x00633637
    20ec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20f0:	00353561 	eorseq	r3, r5, r1, ror #10
    20f4:	5f6d7261 	svcpl	0x006d7261
    20f8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    20fc:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    2100:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    2104:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2108:	00687361 	rsbeq	r7, r8, r1, ror #6
    210c:	5f617369 	svcpl	0x00617369
    2110:	5f746962 	svcpl	0x00746962
    2114:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2118:	6f6e5f6b 	svcvs	0x006e5f6b
    211c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1fa8 <shift+0x1fa8>
    2120:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2124:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2128:	52415400 	subpl	r5, r1, #0, 8
    212c:	5f544547 	svcpl	0x00544547
    2130:	5f555043 	svcpl	0x00555043
    2134:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2138:	306d7865 	rsbcc	r7, sp, r5, ror #16
    213c:	52415400 	subpl	r5, r1, #0, 8
    2140:	5f544547 	svcpl	0x00544547
    2144:	5f555043 	svcpl	0x00555043
    2148:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    214c:	316d7865 	cmncc	sp, r5, ror #16
    2150:	52415400 	subpl	r5, r1, #0, 8
    2154:	5f544547 	svcpl	0x00544547
    2158:	5f555043 	svcpl	0x00555043
    215c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2160:	336d7865 	cmncc	sp, #6619136	; 0x650000
    2164:	61736900 	cmnvs	r3, r0, lsl #18
    2168:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    216c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2170:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    2174:	6d726100 	ldfvse	f6, [r2, #-0]
    2178:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    217c:	616e5f68 	cmnvs	lr, r8, ror #30
    2180:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    2184:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2188:	615f7469 	cmpvs	pc, r9, ror #8
    218c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2190:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    2194:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2198:	615f7469 	cmpvs	pc, r9, ror #8
    219c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21a0:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    21a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21a8:	615f7469 	cmpvs	pc, r9, ror #8
    21ac:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21b0:	5400355f 	strpl	r3, [r0], #-1375	; 0xfffffaa1
    21b4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21b8:	50435f54 	subpl	r5, r3, r4, asr pc
    21bc:	6f635f55 	svcvs	0x00635f55
    21c0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21c4:	00333561 	eorseq	r3, r3, r1, ror #10
    21c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21d8:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    21dc:	52415400 	subpl	r5, r1, #0, 8
    21e0:	5f544547 	svcpl	0x00544547
    21e4:	5f555043 	svcpl	0x00555043
    21e8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21ec:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    21f0:	41540037 	cmpmi	r4, r7, lsr r0
    21f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21fc:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2200:	0065726f 	rsbeq	r7, r5, pc, ror #4
    2204:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2208:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    220c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2210:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    2214:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    2218:	5f6d7261 	svcpl	0x006d7261
    221c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2220:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2228 <shift+0x2228>
    2224:	4154006d 	cmpmi	r4, sp, rrx
    2228:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    222c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2230:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2234:	36323031 			; <UNDEFINED> instruction: 0x36323031
    2238:	00736a65 	rsbseq	r6, r3, r5, ror #20
    223c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2240:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2244:	4a365f48 	bmi	d99f6c <__bss_end+0xd90514>
    2248:	53414200 	movtpl	r4, #4608	; 0x1200
    224c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2250:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2254:	4142004b 	cmpmi	r2, fp, asr #32
    2258:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    225c:	5f484352 	svcpl	0x00484352
    2260:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    2264:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2268:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    226c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2270:	41540074 	cmpmi	r4, r4, ror r0
    2274:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2278:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    227c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2280:	36333131 			; <UNDEFINED> instruction: 0x36333131
    2284:	0073666a 	rsbseq	r6, r3, sl, ror #12
    2288:	5f4d5241 	svcpl	0x004d5241
    228c:	4100534c 	tstmi	r0, ip, asr #6
    2290:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    2294:	41420054 	qdaddmi	r0, r4, r2
    2298:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    229c:	5f484352 	svcpl	0x00484352
    22a0:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    22a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22a8:	50435f54 	subpl	r5, r3, r4, asr pc
    22ac:	6f635f55 	svcvs	0x00635f55
    22b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22b4:	63353761 	teqvs	r5, #25427968	; 0x1840000
    22b8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22bc:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    22c0:	4d524100 	ldfmie	f4, [r2, #-0]
    22c4:	5343505f 	movtpl	r5, #12383	; 0x305f
    22c8:	5041415f 	subpl	r4, r1, pc, asr r1
    22cc:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    22d0:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    22d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22d8:	50435f54 	subpl	r5, r3, r4, asr pc
    22dc:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    22e0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    22e4:	73690032 	cmnvc	r9, #50	; 0x32
    22e8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22ec:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    22f0:	61006e6f 	tstvs	r0, pc, ror #28
    22f4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    22f8:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    22fc:	00727474 	rsbseq	r7, r2, r4, ror r4
    2300:	5f617369 	svcpl	0x00617369
    2304:	5f746962 	svcpl	0x00746962
    2308:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    230c:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2310:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2314:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2318:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    231c:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    2320:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    2324:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2328:	50435f54 	subpl	r5, r3, r4, asr pc
    232c:	616d5f55 	cmnvs	sp, r5, asr pc
    2330:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    2334:	6a705f6c 	bvs	1c1a0ec <__bss_end+0x1c10694>
    2338:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    233c:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2340:	5f687361 	svcpl	0x00687361
    2344:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2348:	00726574 	rsbseq	r6, r2, r4, ror r5
    234c:	5f6d7261 	svcpl	0x006d7261
    2350:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2354:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2358:	5f786574 	svcpl	0x00786574
    235c:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    2360:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2364:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2368:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    236c:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    2370:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2374:	50435f54 	subpl	r5, r3, r4, asr pc
    2378:	6f635f55 	svcvs	0x00635f55
    237c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2380:	63323761 	teqvs	r2, #25427968	; 0x1840000
    2384:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2388:	33356178 	teqcc	r5, #120, 2
    238c:	61736900 	cmnvs	r3, r0, lsl #18
    2390:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2394:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2398:	0032626d 	eorseq	r6, r2, sp, ror #4
    239c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    23a0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    23a4:	41375f48 	teqmi	r7, r8, asr #30
    23a8:	61736900 	cmnvs	r3, r0, lsl #18
    23ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23b0:	746f645f 	strbtvc	r6, [pc], #-1119	; 23b8 <shift+0x23b8>
    23b4:	646f7270 	strbtvs	r7, [pc], #-624	; 23bc <shift+0x23bc>
    23b8:	6d726100 	ldfvse	f6, [r2, #-0]
    23bc:	3170665f 	cmncc	r0, pc, asr r6
    23c0:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    23c4:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    23c8:	0065646f 	rsbeq	r6, r5, pc, ror #8
    23cc:	5f4d5241 	svcpl	0x004d5241
    23d0:	6100494d 	tstvs	r0, sp, asr #18
    23d4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23d8:	36686372 			; <UNDEFINED> instruction: 0x36686372
    23dc:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    23e0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    23e4:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    23e8:	53414200 	movtpl	r4, #4608	; 0x1200
    23ec:	52415f45 	subpl	r5, r1, #276	; 0x114
    23f0:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    23f4:	5f5f0052 	svcpl	0x005f0052
    23f8:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    23fc:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    2400:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2404:	61736900 	cmnvs	r3, r0, lsl #18
    2408:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    240c:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    2410:	41540065 	cmpmi	r4, r5, rrx
    2414:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2418:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    241c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2420:	61786574 	cmnvs	r8, r4, ror r5
    2424:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    2428:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    242c:	50435f54 	subpl	r5, r3, r4, asr pc
    2430:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    2434:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    2438:	61377663 	teqvs	r7, r3, ror #12
    243c:	52415400 	subpl	r5, r1, #0, 8
    2440:	5f544547 	svcpl	0x00544547
    2444:	5f555043 	svcpl	0x00555043
    2448:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    244c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2450:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2454:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2458:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    245c:	6f765f6f 	svcvs	0x00765f6f
    2460:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    2464:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2468:	41420065 	cmpmi	r2, r5, rrx
    246c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2470:	5f484352 	svcpl	0x00484352
    2474:	69004138 	stmdbvs	r0, {r3, r4, r5, r8, lr}
    2478:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    247c:	615f7469 	cmpvs	pc, r9, ror #8
    2480:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    2484:	41420074 	hvcmi	8196	; 0x2004
    2488:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    248c:	5f484352 	svcpl	0x00484352
    2490:	54005238 	strpl	r5, [r0], #-568	; 0xfffffdc8
    2494:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2498:	50435f54 	subpl	r5, r3, r4, asr pc
    249c:	6f635f55 	svcvs	0x00635f55
    24a0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24a4:	63333761 	teqvs	r3, #25427968	; 0x1840000
    24a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    24ac:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    24b0:	4d524100 	ldfmie	f4, [r2, #-0]
    24b4:	00564e5f 	subseq	r4, r6, pc, asr lr
    24b8:	5f6d7261 	svcpl	0x006d7261
    24bc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24c0:	72610034 	rsbvc	r0, r1, #52	; 0x34
    24c4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24c8:	00366863 	eorseq	r6, r6, r3, ror #16
    24cc:	5f6d7261 	svcpl	0x006d7261
    24d0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24d4:	72610037 	rsbvc	r0, r1, #55	; 0x37
    24d8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24dc:	00386863 	eorseq	r6, r8, r3, ror #16
    24e0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    24e4:	756f6420 	strbvc	r6, [pc, #-1056]!	; 20cc <shift+0x20cc>
    24e8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    24ec:	5f6d7261 	svcpl	0x006d7261
    24f0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    24f4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    24f8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    24fc:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    2500:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    2504:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    2508:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    250c:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    2510:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2514:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    2518:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    251c:	616c5f61 	cmnvs	ip, r1, ror #30
    2520:	006c6562 	rsbeq	r6, ip, r2, ror #10
    2524:	5f617369 	svcpl	0x00617369
    2528:	5f746962 	svcpl	0x00746962
    252c:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    2530:	61736900 	cmnvs	r3, r0, lsl #18
    2534:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2538:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    253c:	006b3676 	rsbeq	r3, fp, r6, ror r6
    2540:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2544:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2548:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    254c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2550:	00376178 	eorseq	r6, r7, r8, ror r1
    2554:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2558:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    255c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2560:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2564:	00386178 	eorseq	r6, r8, r8, ror r1
    2568:	47524154 			; <UNDEFINED> instruction: 0x47524154
    256c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2570:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2574:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2578:	00396178 	eorseq	r6, r9, r8, ror r1
    257c:	5f4d5241 	svcpl	0x004d5241
    2580:	5f534350 	svcpl	0x00534350
    2584:	53435041 	movtpl	r5, #12353	; 0x3041
    2588:	4d524100 	ldfmie	f4, [r2, #-0]
    258c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2590:	5054415f 	subspl	r4, r4, pc, asr r1
    2594:	63005343 	movwvs	r5, #835	; 0x343
    2598:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    259c:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    25a0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    25a4:	41540065 	cmpmi	r4, r5, rrx
    25a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25b0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25b4:	61786574 	cmnvs	r8, r4, ror r5
    25b8:	6f633337 	svcvs	0x00633337
    25bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25c0:	00333561 	eorseq	r3, r3, r1, ror #10
    25c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25cc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25d0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25d4:	70306d78 	eorsvc	r6, r0, r8, ror sp
    25d8:	0073756c 	rsbseq	r7, r3, ip, ror #10
    25dc:	5f6d7261 	svcpl	0x006d7261
    25e0:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    25e4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    25e8:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    25ec:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    25f0:	645f0065 	ldrbvs	r0, [pc], #-101	; 25f8 <shift+0x25f8>
    25f4:	5f746e6f 	svcpl	0x00746e6f
    25f8:	5f657375 	svcpl	0x00657375
    25fc:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    2600:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2604:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    2608:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    260c:	50435f54 	subpl	r5, r3, r4, asr pc
    2610:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2614:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    2618:	00696d64 	rsbeq	r6, r9, r4, ror #26
    261c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2620:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2624:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2628:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    262c:	00356178 	eorseq	r6, r5, r8, ror r1
    2630:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    2634:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2638:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    263c:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    2640:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2644:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2648:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    264c:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    2650:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2654:	50435f54 	subpl	r5, r3, r4, asr pc
    2658:	6f635f55 	svcvs	0x00635f55
    265c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2660:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    2664:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2668:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    266c:	00796c70 	rsbseq	r6, r9, r0, ror ip
    2670:	5f6d7261 	svcpl	0x006d7261
    2674:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    2678:	5f746e65 	svcpl	0x00746e65
    267c:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    2680:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2684:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2688:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    268c:	4d524100 	ldfmie	f4, [r2, #-0]
    2690:	004c505f 	subeq	r5, ip, pc, asr r0
    2694:	5f617369 	svcpl	0x00617369
    2698:	5f746962 	svcpl	0x00746962
    269c:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26a0:	73690033 	cmnvc	r9, #51	; 0x33
    26a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26a8:	66765f74 	uhsub16vs	r5, r6, r4
    26ac:	00347670 	eorseq	r7, r4, r0, ror r6
    26b0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26b4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26b8:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    26bc:	41420032 	cmpmi	r2, r2, lsr r0
    26c0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26c4:	5f484352 	svcpl	0x00484352
    26c8:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 25f0 <shift+0x25f0>
    26cc:	004e4941 	subeq	r4, lr, r1, asr #18
    26d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    26dc:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    26e0:	00696d64 	rsbeq	r6, r9, r4, ror #26
    26e4:	5f4d5241 	svcpl	0x004d5241
    26e8:	42004c41 	andmi	r4, r0, #16640	; 0x4100
    26ec:	5f455341 	svcpl	0x00455341
    26f0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    26f4:	004d375f 	subeq	r3, sp, pc, asr r7
    26f8:	5f6d7261 	svcpl	0x006d7261
    26fc:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2700:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2704:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2708:	6d726100 	ldfvse	f6, [r2, #-0]
    270c:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    2710:	5f746567 	svcpl	0x00746567
    2714:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    2718:	52415400 	subpl	r5, r1, #0, 8
    271c:	5f544547 	svcpl	0x00544547
    2720:	5f555043 	svcpl	0x00555043
    2724:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2728:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    272c:	52415400 	subpl	r5, r1, #0, 8
    2730:	5f544547 	svcpl	0x00544547
    2734:	5f555043 	svcpl	0x00555043
    2738:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    273c:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    2740:	52415400 	subpl	r5, r1, #0, 8
    2744:	5f544547 	svcpl	0x00544547
    2748:	5f555043 	svcpl	0x00555043
    274c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2750:	37727865 	ldrbcc	r7, [r2, -r5, ror #16]!
    2754:	52415400 	subpl	r5, r1, #0, 8
    2758:	5f544547 	svcpl	0x00544547
    275c:	5f555043 	svcpl	0x00555043
    2760:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2764:	38727865 	ldmdacc	r2!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2768:	61736900 	cmnvs	r3, r0, lsl #18
    276c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2770:	61706c5f 	cmnvs	r0, pc, asr ip
    2774:	73690065 	cmnvc	r9, #101	; 0x65
    2778:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    277c:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2780:	5f6b7269 	svcpl	0x006b7269
    2784:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2788:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    278c:	5f617369 	svcpl	0x00617369
    2790:	5f746962 	svcpl	0x00746962
    2794:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    2798:	61736900 	cmnvs	r3, r0, lsl #18
    279c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27a4:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    27a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27ac:	615f7469 	cmpvs	pc, r9, ror #8
    27b0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    27b4:	61736900 	cmnvs	r3, r0, lsl #18
    27b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27c0:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    27c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27c8:	615f7469 	cmpvs	pc, r9, ror #8
    27cc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    27d0:	6f645f00 	svcvs	0x00645f00
    27d4:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 236e <shift+0x236e>
    27d8:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    27dc:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    27e0:	5f657265 	svcpl	0x00657265
    27e4:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    27e8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    27ec:	61736900 	cmnvs	r3, r0, lsl #18
    27f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27f4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27f8:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    27fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2800:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2804:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2808:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    280c:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    2810:	77726574 			; <UNDEFINED> instruction: 0x77726574
    2814:	006b726f 	rsbeq	r7, fp, pc, ror #4
    2818:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    281c:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    2820:	52415400 	subpl	r5, r1, #0, 8
    2824:	5f544547 	svcpl	0x00544547
    2828:	5f555043 	svcpl	0x00555043
    282c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2830:	00743032 	rsbseq	r3, r4, r2, lsr r0
    2834:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2838:	0071655f 	rsbseq	r6, r1, pc, asr r5
    283c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2840:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2844:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2848:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    284c:	6d726100 	ldfvse	f6, [r2, #-0]
    2850:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2854:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2858:	5f626d75 	svcpl	0x00626d75
    285c:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    2860:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    2864:	655f6261 	ldrbvs	r6, [pc, #-609]	; 260b <shift+0x260b>
    2868:	6f705f71 	svcvs	0x00705f71
    286c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2870:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2874:	69705f6d 	ldmdbvs	r0!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2878:	65725f63 	ldrbvs	r5, [r2, #-3939]!	; 0xfffff09d
    287c:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    2880:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2884:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2888:	50435f54 	subpl	r5, r3, r4, asr pc
    288c:	6f635f55 	svcvs	0x00635f55
    2890:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2894:	6d73306d 	ldclvs	0, cr3, [r3, #-436]!	; 0xfffffe4c
    2898:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    289c:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    28a0:	00796c70 	rsbseq	r6, r9, r0, ror ip
    28a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    28ac:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 2774 <shift+0x2774>
    28b0:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    28b4:	766f6e65 	strbtvc	r6, [pc], -r5, ror #28
    28b8:	69007066 	stmdbvs	r0, {r1, r2, r5, r6, ip, sp, lr}
    28bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    28c0:	715f7469 	cmpvc	pc, r9, ror #8
    28c4:	6b726975 	blvs	1c9cea0 <__bss_end+0x1c93448>
    28c8:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    28cc:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    28d0:	52410064 	subpl	r0, r1, #100	; 0x64
    28d4:	43435f4d 	movtmi	r5, #16205	; 0x3f4d
    28d8:	6d726100 	ldfvse	f6, [r2, #-0]
    28dc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28e0:	325f3868 	subscc	r3, pc, #104, 16	; 0x680000
    28e4:	6d726100 	ldfvse	f6, [r2, #-0]
    28e8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28ec:	335f3868 	cmpcc	pc, #104, 16	; 0x680000
    28f0:	6d726100 	ldfvse	f6, [r2, #-0]
    28f4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28f8:	345f3868 	ldrbcc	r3, [pc], #-2152	; 2900 <shift+0x2900>
    28fc:	52415400 	subpl	r5, r1, #0, 8
    2900:	5f544547 	svcpl	0x00544547
    2904:	5f555043 	svcpl	0x00555043
    2908:	36706d66 	ldrbtcc	r6, [r0], -r6, ror #26
    290c:	41003632 	tstmi	r0, r2, lsr r6
    2910:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2914:	72610053 	rsbvc	r0, r1, #83	; 0x53
    2918:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    291c:	695f3631 	ldmdbvs	pc, {r0, r4, r5, r9, sl, ip, sp}^	; <UNPREDICTABLE>
    2920:	0074736e 	rsbseq	r7, r4, lr, ror #6
    2924:	5f6d7261 	svcpl	0x006d7261
    2928:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    292c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2930:	41540068 	cmpmi	r4, r8, rrx
    2934:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2938:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    293c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2940:	61786574 	cmnvs	r8, r4, ror r5
    2944:	6f633531 	svcvs	0x00633531
    2948:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    294c:	61003761 	tstvs	r0, r1, ror #14
    2950:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2954:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2958:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    295c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2960:	50435f54 	subpl	r5, r3, r4, asr pc
    2964:	6f635f55 	svcvs	0x00635f55
    2968:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    296c:	00323761 	eorseq	r3, r2, r1, ror #14
    2970:	5f6d7261 	svcpl	0x006d7261
    2974:	5f736370 	svcpl	0x00736370
    2978:	61666564 	cmnvs	r6, r4, ror #10
    297c:	00746c75 	rsbseq	r6, r4, r5, ror ip
    2980:	5f4d5241 	svcpl	0x004d5241
    2984:	5f534350 	svcpl	0x00534350
    2988:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    298c:	4f4c5f53 	svcmi	0x004c5f53
    2990:	004c4143 	subeq	r4, ip, r3, asr #2
    2994:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2998:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    299c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    29a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    29a4:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    29a8:	52415400 	subpl	r5, r1, #0, 8
    29ac:	5f544547 	svcpl	0x00544547
    29b0:	5f555043 	svcpl	0x00555043
    29b4:	6f727473 	svcvs	0x00727473
    29b8:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    29bc:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    29c0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29c4:	745f6863 	ldrbvc	r6, [pc], #-2147	; 29cc <shift+0x29cc>
    29c8:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    29cc:	72610031 	rsbvc	r0, r1, #49	; 0x31
    29d0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29d4:	745f6863 	ldrbvc	r6, [pc], #-2147	; 29dc <shift+0x29dc>
    29d8:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    29dc:	41540032 	cmpmi	r4, r2, lsr r0
    29e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29e8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    29ec:	0074786d 	rsbseq	r7, r4, sp, ror #16
    29f0:	5f6d7261 	svcpl	0x006d7261
    29f4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29f8:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    29fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a00:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 2864 <shift+0x2864>
    2a04:	72610070 	rsbvc	r0, r1, #112	; 0x70
    2a08:	646c5f6d 	strbtvs	r5, [ip], #-3949	; 0xfffff093
    2a0c:	6863735f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    2a10:	61006465 	tstvs	r0, r5, ror #8
    2a14:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2a18:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2a1c:	Address 0x0000000000002a1c is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9ed8>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346dd8>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9ef8>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9228>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9f28>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346e28>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9f48>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346e48>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9f68>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346e68>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9f88>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346e88>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9fa8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346ea8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9fc8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346ec8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9fe8>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346ee8>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa000>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa020>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa050>
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
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa07c>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346f7c>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008334 	andeq	r8, r0, r4, lsr r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa09c>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346f9c>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008360 	andeq	r8, r0, r0, ror #6
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa0bc>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346fbc>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	0000837c 	andeq	r8, r0, ip, ror r3
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa0dc>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346fdc>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083c0 	andeq	r8, r0, r0, asr #7
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa0fc>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346ffc>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008410 	andeq	r8, r0, r0, lsl r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa11c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x34701c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008460 	andeq	r8, r0, r0, ror #8
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa13c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x34703c>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	0000848c 	andeq	r8, r0, ip, lsl #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa15c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x34705c>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084dc 	ldrdeq	r8, [r0], -ip
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa17c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x34707c>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008520 	andeq	r8, r0, r0, lsr #10
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa19c>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x34709c>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008570 	andeq	r8, r0, r0, ror r5
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa1bc>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3470bc>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085c4 	andeq	r8, r0, r4, asr #11
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa1dc>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3470dc>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008600 	andeq	r8, r0, r0, lsl #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa1fc>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3470fc>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000863c 	andeq	r8, r0, ip, lsr r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa21c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x34711c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008678 	andeq	r8, r0, r8, ror r6
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa23c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x34713c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa25c>
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
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa28c>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa2ac>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3471ac>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008974 	andeq	r8, r0, r4, ror r9
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa2cc>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3471cc>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a34 	andeq	r8, r0, r4, lsr sl
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa2ec>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3471ec>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ae0 	andeq	r8, r0, r0, ror #21
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa30c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x34720c>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b34 	andeq	r8, r0, r4, lsr fp
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa32c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x34722c>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b9c 	muleq	r0, ip, fp
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa34c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x34724c>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008c1c 	andeq	r8, r0, ip, lsl ip
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa36c>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x34726c>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008c88 	andeq	r8, r0, r8, lsl #25
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa38c>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008d4c 	andeq	r8, r0, ip, asr #26
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa3ac>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3472ac>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	0000918c 	andeq	r9, r0, ip, lsl #3
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa3d0>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009260 	andeq	r9, r0, r0, ror #4
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa3f0>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x3472f0>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	0000929c 	muleq	r0, ip, r2
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa410>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x347310>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	000092dc 	ldrdeq	r9, [r0], -ip
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa430>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	0000930c 	andeq	r9, r0, ip, lsl #6
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa450>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	00009630 	andeq	r9, r0, r0, lsr r6
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa474>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x347374>
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
