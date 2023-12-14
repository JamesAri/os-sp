
./sos_task:     file format elf32-littlearm


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
    805c:	00009b48 	andeq	r9, r0, r8, asr #22
    8060:	00009b60 	andeq	r9, r0, r0, ror #22

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
    8080:	eb000089 	bl	82ac <main>
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
    81cc:	00009b45 	andeq	r9, r0, r5, asr #22
    81d0:	00009b45 	andeq	r9, r0, r5, asr #22

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
    8224:	00009b45 	andeq	r9, r0, r5, asr #22
    8228:	00009b45 	andeq	r9, r0, r5, asr #22

0000822c <_Z5blinkb>:
_Z5blinkb():
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:23

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e1a03000 	mov	r3, r0
    823c:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:24
	write(sos_led, "1", 1);
    8240:	e59f3058 	ldr	r3, [pc, #88]	; 82a0 <_Z5blinkb+0x74>
    8244:	e5933000 	ldr	r3, [r3]
    8248:	e3a02001 	mov	r2, #1
    824c:	e59f1050 	ldr	r1, [pc, #80]	; 82a4 <_Z5blinkb+0x78>
    8250:	e1a00003 	mov	r0, r3
    8254:	eb0000b1 	bl	8520 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:25
	sleep(short_blink ? 0x800 : 0x1000);
    8258:	e55b3005 	ldrb	r3, [fp, #-5]
    825c:	e3530000 	cmp	r3, #0
    8260:	0a000001 	beq	826c <_Z5blinkb+0x40>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 1)
    8264:	e3a03b02 	mov	r3, #2048	; 0x800
    8268:	ea000000 	b	8270 <_Z5blinkb+0x44>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 2)
    826c:	e3a03a01 	mov	r3, #4096	; 0x1000
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 4)
    8270:	e3e01001 	mvn	r1, #1
    8274:	e1a00003 	mov	r0, r3
    8278:	eb000100 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:26 (discriminator 4)
	write(sos_led, "0", 1);
    827c:	e59f301c 	ldr	r3, [pc, #28]	; 82a0 <_Z5blinkb+0x74>
    8280:	e5933000 	ldr	r3, [r3]
    8284:	e3a02001 	mov	r2, #1
    8288:	e59f1018 	ldr	r1, [pc, #24]	; 82a8 <_Z5blinkb+0x7c>
    828c:	e1a00003 	mov	r0, r3
    8290:	eb0000a2 	bl	8520 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:27 (discriminator 4)
}
    8294:	e320f000 	nop	{0}
    8298:	e24bd004 	sub	sp, fp, #4
    829c:	e8bd8800 	pop	{fp, pc}
    82a0:	00009b48 	andeq	r9, r0, r8, asr #22
    82a4:	00009ac8 	andeq	r9, r0, r8, asr #21
    82a8:	00009acc 	andeq	r9, r0, ip, asr #21

000082ac <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:30

int main(int argc, char** argv)
{
    82ac:	e92d4800 	push	{fp, lr}
    82b0:	e28db004 	add	fp, sp, #4
    82b4:	e24dd010 	sub	sp, sp, #16
    82b8:	e50b0010 	str	r0, [fp, #-16]
    82bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:31
	sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    82c0:	e3a01001 	mov	r1, #1
    82c4:	e59f0134 	ldr	r0, [pc, #308]	; 8400 <main+0x154>
    82c8:	eb00006f 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82cc:	e1a03000 	mov	r3, r0
    82d0:	e59f212c 	ldr	r2, [pc, #300]	; 8404 <main+0x158>
    82d4:	e5823000 	str	r3, [r2]
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:32
	button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);
    82d8:	e3a01000 	mov	r1, #0
    82dc:	e59f0124 	ldr	r0, [pc, #292]	; 8408 <main+0x15c>
    82e0:	eb000069 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    82e4:	e1a03000 	mov	r3, r0
    82e8:	e59f211c 	ldr	r2, [pc, #284]	; 840c <main+0x160>
    82ec:	e5823000 	str	r3, [r2]
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:34

	NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    82f0:	e3a03000 	mov	r3, #0
    82f4:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:35
	ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    82f8:	e59f310c 	ldr	r3, [pc, #268]	; 840c <main+0x160>
    82fc:	e5933000 	ldr	r3, [r3]
    8300:	e24b200c 	sub	r2, fp, #12
    8304:	e3a01002 	mov	r1, #2
    8308:	e1a00003 	mov	r0, r3
    830c:	eb0000a2 	bl	859c <_Z5ioctlj16NIOCtl_OperationPv>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:37

	uint32_t logpipe = pipe("log", 32);
    8310:	e3a01020 	mov	r1, #32
    8314:	e59f00f4 	ldr	r0, [pc, #244]	; 8410 <main+0x164>
    8318:	eb000129 	bl	87c4 <_Z4pipePKcj>
    831c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:42 (discriminator 1)

	while (true)
	{
		// pockame na stisk klavesy
		wait(button, 1, 0x300);
    8320:	e59f30e4 	ldr	r3, [pc, #228]	; 840c <main+0x160>
    8324:	e5933000 	ldr	r3, [r3]
    8328:	e3a02c03 	mov	r2, #768	; 0x300
    832c:	e3a01001 	mov	r1, #1
    8330:	e1a00003 	mov	r0, r3
    8334:	eb0000bd 	bl	8630 <_Z4waitjjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:51 (discriminator 1)
		// 2) my mame deadline 0x300
		// 3) log task ma deadline 0x1000
		// 4) jiny task ma deadline 0x500
		// jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci deadline
		// TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my se mohli odblokovat co nejdrive
		write(logpipe, "SOS!", 5);
    8338:	e3a02005 	mov	r2, #5
    833c:	e59f10d0 	ldr	r1, [pc, #208]	; 8414 <main+0x168>
    8340:	e51b0008 	ldr	r0, [fp, #-8]
    8344:	eb000075 	bl	8520 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:53 (discriminator 1)

		blink(true);
    8348:	e3a00001 	mov	r0, #1
    834c:	ebffffb6 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:54 (discriminator 1)
		sleep(symbol_tick_delay);
    8350:	e3e01001 	mvn	r1, #1
    8354:	e3a00b01 	mov	r0, #1024	; 0x400
    8358:	eb0000c8 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:55 (discriminator 1)
		blink(true);
    835c:	e3a00001 	mov	r0, #1
    8360:	ebffffb1 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:56 (discriminator 1)
		sleep(symbol_tick_delay);
    8364:	e3e01001 	mvn	r1, #1
    8368:	e3a00b01 	mov	r0, #1024	; 0x400
    836c:	eb0000c3 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:57 (discriminator 1)
		blink(true);
    8370:	e3a00001 	mov	r0, #1
    8374:	ebffffac 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:59 (discriminator 1)

		sleep(char_tick_delay);
    8378:	e3e01001 	mvn	r1, #1
    837c:	e3a00a01 	mov	r0, #4096	; 0x1000
    8380:	eb0000be 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:61 (discriminator 1)

		blink(false);
    8384:	e3a00000 	mov	r0, #0
    8388:	ebffffa7 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:62 (discriminator 1)
		sleep(symbol_tick_delay);
    838c:	e3e01001 	mvn	r1, #1
    8390:	e3a00b01 	mov	r0, #1024	; 0x400
    8394:	eb0000b9 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:63 (discriminator 1)
		blink(false);
    8398:	e3a00000 	mov	r0, #0
    839c:	ebffffa2 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:64 (discriminator 1)
		sleep(symbol_tick_delay);
    83a0:	e3e01001 	mvn	r1, #1
    83a4:	e3a00b01 	mov	r0, #1024	; 0x400
    83a8:	eb0000b4 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:65 (discriminator 1)
		blink(false);
    83ac:	e3a00000 	mov	r0, #0
    83b0:	ebffff9d 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:66 (discriminator 1)
		sleep(symbol_tick_delay);
    83b4:	e3e01001 	mvn	r1, #1
    83b8:	e3a00b01 	mov	r0, #1024	; 0x400
    83bc:	eb0000af 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:68 (discriminator 1)

		sleep(char_tick_delay);
    83c0:	e3e01001 	mvn	r1, #1
    83c4:	e3a00a01 	mov	r0, #4096	; 0x1000
    83c8:	eb0000ac 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:70 (discriminator 1)

		blink(true);
    83cc:	e3a00001 	mov	r0, #1
    83d0:	ebffff95 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:71 (discriminator 1)
		sleep(symbol_tick_delay);
    83d4:	e3e01001 	mvn	r1, #1
    83d8:	e3a00b01 	mov	r0, #1024	; 0x400
    83dc:	eb0000a7 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:72 (discriminator 1)
		blink(true);
    83e0:	e3a00001 	mov	r0, #1
    83e4:	ebffff90 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:73 (discriminator 1)
		sleep(symbol_tick_delay);
    83e8:	e3e01001 	mvn	r1, #1
    83ec:	e3a00b01 	mov	r0, #1024	; 0x400
    83f0:	eb0000a2 	bl	8680 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:74 (discriminator 1)
		blink(true);
    83f4:	e3a00001 	mov	r0, #1
    83f8:	ebffff8b 	bl	822c <_Z5blinkb>
/home/jamesari/git/os/sp/sources/userspace/sos_task/main.cpp:42 (discriminator 1)
		wait(button, 1, 0x300);
    83fc:	eaffffc7 	b	8320 <main+0x74>
    8400:	00009ad0 	ldrdeq	r9, [r0], -r0
    8404:	00009b48 	andeq	r9, r0, r8, asr #22
    8408:	00009adc 	ldrdeq	r9, [r0], -ip
    840c:	00009b4c 	andeq	r9, r0, ip, asr #22
    8410:	00009ae8 	andeq	r9, r0, r8, ror #21
    8414:	00009aec 	andeq	r9, r0, ip, ror #21

00008418 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
    8420:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8424:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8428:	e1a03000 	mov	r3, r0
    842c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8430:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8434:	e1a00003 	mov	r0, r3
    8438:	e28bd000 	add	sp, fp, #0
    843c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8440:	e12fff1e 	bx	lr

00008444 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8444:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8448:	e28db000 	add	fp, sp, #0
    844c:	e24dd00c 	sub	sp, sp, #12
    8450:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8454:	e51b3008 	ldr	r3, [fp, #-8]
    8458:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    845c:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    8460:	e320f000 	nop	{0}
    8464:	e28bd000 	add	sp, fp, #0
    8468:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    846c:	e12fff1e 	bx	lr

00008470 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8470:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8474:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8478:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    847c:	e320f000 	nop	{0}
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd014 	sub	sp, sp, #20
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    84a0:	e51b3010 	ldr	r3, [fp, #-16]
    84a4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    84a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ac:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    84b0:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    84b4:	e1a03000 	mov	r3, r0
    84b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    84bc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    84c0:	e1a00003 	mov	r0, r3
    84c4:	e28bd000 	add	sp, fp, #0
    84c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84cc:	e12fff1e 	bx	lr

000084d0 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    84d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d4:	e28db000 	add	fp, sp, #0
    84d8:	e24dd01c 	sub	sp, sp, #28
    84dc:	e50b0010 	str	r0, [fp, #-16]
    84e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84e8:	e51b3010 	ldr	r3, [fp, #-16]
    84ec:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84fc:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8500:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd01c 	sub	sp, sp, #28
    852c:	e50b0010 	str	r0, [fp, #-16]
    8530:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8534:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8538:	e51b3010 	ldr	r3, [fp, #-16]
    853c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8540:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8544:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8548:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    854c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8550:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8554:	e1a03000 	mov	r3, r0
    8558:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    855c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    8560:	e1a00003 	mov	r0, r3
    8564:	e28bd000 	add	sp, fp, #0
    8568:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    856c:	e12fff1e 	bx	lr

00008570 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8570:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8574:	e28db000 	add	fp, sp, #0
    8578:	e24dd00c 	sub	sp, sp, #12
    857c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8580:	e51b3008 	ldr	r3, [fp, #-8]
    8584:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8588:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    858c:	e320f000 	nop	{0}
    8590:	e28bd000 	add	sp, fp, #0
    8594:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8598:	e12fff1e 	bx	lr

0000859c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    859c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a0:	e28db000 	add	fp, sp, #0
    85a4:	e24dd01c 	sub	sp, sp, #28
    85a8:	e50b0010 	str	r0, [fp, #-16]
    85ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    85c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85c8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    85cc:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d0:	e1a03000 	mov	r3, r0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    85dc:	e1a00003 	mov	r0, r3
    85e0:	e28bd000 	add	sp, fp, #0
    85e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e8:	e12fff1e 	bx	lr

000085ec <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f0:	e28db000 	add	fp, sp, #0
    85f4:	e24dd014 	sub	sp, sp, #20
    85f8:	e50b0010 	str	r0, [fp, #-16]
    85fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8600:	e51b3010 	ldr	r3, [fp, #-16]
    8604:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8608:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    860c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8610:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8614:	e1a03000 	mov	r3, r0
    8618:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    861c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd01c 	sub	sp, sp, #28
    863c:	e50b0010 	str	r0, [fp, #-16]
    8640:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8644:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8648:	e51b3010 	ldr	r3, [fp, #-16]
    864c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8650:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8654:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8658:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    865c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8660:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8664:	e1a03000 	mov	r3, r0
    8668:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    866c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    8670:	e1a00003 	mov	r0, r3
    8674:	e28bd000 	add	sp, fp, #0
    8678:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    867c:	e12fff1e 	bx	lr

00008680 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8680:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8684:	e28db000 	add	fp, sp, #0
    8688:	e24dd014 	sub	sp, sp, #20
    868c:	e50b0010 	str	r0, [fp, #-16]
    8690:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8694:	e51b3010 	ldr	r3, [fp, #-16]
    8698:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    869c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    86a4:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    86a8:	e1a03000 	mov	r3, r0
    86ac:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    86b0:	e51b3008 	ldr	r3, [fp, #-8]
    86b4:	e3530000 	cmp	r3, #0
    86b8:	13a03001 	movne	r3, #1
    86bc:	03a03000 	moveq	r3, #0
    86c0:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    86c4:	e1a00003 	mov	r0, r3
    86c8:	e28bd000 	add	sp, fp, #0
    86cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86d0:	e12fff1e 	bx	lr

000086d4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    86d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86d8:	e28db000 	add	fp, sp, #0
    86dc:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    86e0:	e3a03000 	mov	r3, #0
    86e4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    86f0:	e24b300c 	sub	r3, fp, #12
    86f4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86f8:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    86fc:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    8700:	e1a00003 	mov	r0, r3
    8704:	e28bd000 	add	sp, fp, #0
    8708:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    870c:	e12fff1e 	bx	lr

00008710 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8710:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8714:	e28db000 	add	fp, sp, #0
    8718:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    871c:	e3a03001 	mov	r3, #1
    8720:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8724:	e3a03001 	mov	r3, #1
    8728:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    872c:	e24b300c 	sub	r3, fp, #12
    8730:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8734:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8738:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    873c:	e1a00003 	mov	r0, r3
    8740:	e28bd000 	add	sp, fp, #0
    8744:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8748:	e12fff1e 	bx	lr

0000874c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    874c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8750:	e28db000 	add	fp, sp, #0
    8754:	e24dd014 	sub	sp, sp, #20
    8758:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    875c:	e3a03000 	mov	r3, #0
    8760:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8764:	e3a03000 	mov	r3, #0
    8768:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    876c:	e24b3010 	sub	r3, fp, #16
    8770:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8774:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    8778:	e320f000 	nop	{0}
    877c:	e28bd000 	add	sp, fp, #0
    8780:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8784:	e12fff1e 	bx	lr

00008788 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8788:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    878c:	e28db000 	add	fp, sp, #0
    8790:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8794:	e3a03001 	mov	r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    879c:	e3a03001 	mov	r3, #1
    87a0:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    87a4:	e24b300c 	sub	r3, fp, #12
    87a8:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    87ac:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    87b0:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    87b4:	e1a00003 	mov	r0, r3
    87b8:	e28bd000 	add	sp, fp, #0
    87bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87c0:	e12fff1e 	bx	lr

000087c4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    87c4:	e92d4800 	push	{fp, lr}
    87c8:	e28db004 	add	fp, sp, #4
    87cc:	e24dd050 	sub	sp, sp, #80	; 0x50
    87d0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    87d4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    87d8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87dc:	e3a0200a 	mov	r2, #10
    87e0:	e59f1088 	ldr	r1, [pc, #136]	; 8870 <_Z4pipePKcj+0xac>
    87e4:	e1a00003 	mov	r0, r3
    87e8:	eb0000a5 	bl	8a84 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87ec:	e24b3048 	sub	r3, fp, #72	; 0x48
    87f0:	e283300a 	add	r3, r3, #10
    87f4:	e3a02035 	mov	r2, #53	; 0x35
    87f8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87fc:	e1a00003 	mov	r0, r3
    8800:	eb00009f 	bl	8a84 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8804:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8808:	eb0000f8 	bl	8bf0 <_Z6strlenPKc>
    880c:	e1a03000 	mov	r3, r0
    8810:	e283300a 	add	r3, r3, #10
    8814:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8818:	e51b3008 	ldr	r3, [fp, #-8]
    881c:	e2832001 	add	r2, r3, #1
    8820:	e50b2008 	str	r2, [fp, #-8]
    8824:	e24b2004 	sub	r2, fp, #4
    8828:	e0823003 	add	r3, r2, r3
    882c:	e3a02023 	mov	r2, #35	; 0x23
    8830:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8834:	e24b2048 	sub	r2, fp, #72	; 0x48
    8838:	e51b3008 	ldr	r3, [fp, #-8]
    883c:	e0823003 	add	r3, r2, r3
    8840:	e3a0200a 	mov	r2, #10
    8844:	e1a01003 	mov	r1, r3
    8848:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    884c:	eb000008 	bl	8874 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8850:	e24b3048 	sub	r3, fp, #72	; 0x48
    8854:	e3a01002 	mov	r1, #2
    8858:	e1a00003 	mov	r0, r3
    885c:	ebffff0a 	bl	848c <_Z4openPKc15NFile_Open_Mode>
    8860:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    8864:	e1a00003 	mov	r0, r3
    8868:	e24bd004 	sub	sp, fp, #4
    886c:	e8bd8800 	pop	{fp, pc}
    8870:	00009b24 	andeq	r9, r0, r4, lsr #22

00008874 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8874:	e92d4800 	push	{fp, lr}
    8878:	e28db004 	add	fp, sp, #4
    887c:	e24dd020 	sub	sp, sp, #32
    8880:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8884:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8888:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    888c:	e3a03000 	mov	r3, #0
    8890:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8894:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8898:	e3530000 	cmp	r3, #0
    889c:	0a000014 	beq	88f4 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    88a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88a8:	e1a00003 	mov	r0, r3
    88ac:	eb000462 	bl	9a3c <__aeabi_uidivmod>
    88b0:	e1a03001 	mov	r3, r1
    88b4:	e1a01003 	mov	r1, r3
    88b8:	e51b3008 	ldr	r3, [fp, #-8]
    88bc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c0:	e0823003 	add	r3, r2, r3
    88c4:	e59f2118 	ldr	r2, [pc, #280]	; 89e4 <_Z4itoajPcj+0x170>
    88c8:	e7d22001 	ldrb	r2, [r2, r1]
    88cc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    88d0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88d4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    88d8:	eb0003dc 	bl	9850 <__udivsi3>
    88dc:	e1a03000 	mov	r3, r0
    88e0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    88e4:	e51b3008 	ldr	r3, [fp, #-8]
    88e8:	e2833001 	add	r3, r3, #1
    88ec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    88f0:	eaffffe7 	b	8894 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    88f4:	e51b3008 	ldr	r3, [fp, #-8]
    88f8:	e3530000 	cmp	r3, #0
    88fc:	1a000007 	bne	8920 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8900:	e51b3008 	ldr	r3, [fp, #-8]
    8904:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8908:	e0823003 	add	r3, r2, r3
    890c:	e3a02030 	mov	r2, #48	; 0x30
    8910:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8914:	e51b3008 	ldr	r3, [fp, #-8]
    8918:	e2833001 	add	r3, r3, #1
    891c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8920:	e51b3008 	ldr	r3, [fp, #-8]
    8924:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8928:	e0823003 	add	r3, r2, r3
    892c:	e3a02000 	mov	r2, #0
    8930:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8934:	e51b3008 	ldr	r3, [fp, #-8]
    8938:	e2433001 	sub	r3, r3, #1
    893c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8940:	e3a03000 	mov	r3, #0
    8944:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8948:	e51b3008 	ldr	r3, [fp, #-8]
    894c:	e1a02fa3 	lsr	r2, r3, #31
    8950:	e0823003 	add	r3, r2, r3
    8954:	e1a030c3 	asr	r3, r3, #1
    8958:	e1a02003 	mov	r2, r3
    895c:	e51b300c 	ldr	r3, [fp, #-12]
    8960:	e1530002 	cmp	r3, r2
    8964:	ca00001b 	bgt	89d8 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8968:	e51b2008 	ldr	r2, [fp, #-8]
    896c:	e51b300c 	ldr	r3, [fp, #-12]
    8970:	e0423003 	sub	r3, r2, r3
    8974:	e1a02003 	mov	r2, r3
    8978:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    897c:	e0833002 	add	r3, r3, r2
    8980:	e5d33000 	ldrb	r3, [r3]
    8984:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8988:	e51b300c 	ldr	r3, [fp, #-12]
    898c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8990:	e0822003 	add	r2, r2, r3
    8994:	e51b1008 	ldr	r1, [fp, #-8]
    8998:	e51b300c 	ldr	r3, [fp, #-12]
    899c:	e0413003 	sub	r3, r1, r3
    89a0:	e1a01003 	mov	r1, r3
    89a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    89a8:	e0833001 	add	r3, r3, r1
    89ac:	e5d22000 	ldrb	r2, [r2]
    89b0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    89b4:	e51b300c 	ldr	r3, [fp, #-12]
    89b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    89bc:	e0823003 	add	r3, r2, r3
    89c0:	e55b200d 	ldrb	r2, [fp, #-13]
    89c4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    89c8:	e51b300c 	ldr	r3, [fp, #-12]
    89cc:	e2833001 	add	r3, r3, #1
    89d0:	e50b300c 	str	r3, [fp, #-12]
    89d4:	eaffffdb 	b	8948 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    89d8:	e320f000 	nop	{0}
    89dc:	e24bd004 	sub	sp, fp, #4
    89e0:	e8bd8800 	pop	{fp, pc}
    89e4:	00009b34 	andeq	r9, r0, r4, lsr fp

000089e8 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    89e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ec:	e28db000 	add	fp, sp, #0
    89f0:	e24dd014 	sub	sp, sp, #20
    89f4:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    89f8:	e3a03000 	mov	r3, #0
    89fc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8a00:	e51b3010 	ldr	r3, [fp, #-16]
    8a04:	e5d33000 	ldrb	r3, [r3]
    8a08:	e3530000 	cmp	r3, #0
    8a0c:	0a000017 	beq	8a70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8a10:	e51b2008 	ldr	r2, [fp, #-8]
    8a14:	e1a03002 	mov	r3, r2
    8a18:	e1a03103 	lsl	r3, r3, #2
    8a1c:	e0833002 	add	r3, r3, r2
    8a20:	e1a03083 	lsl	r3, r3, #1
    8a24:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8a28:	e51b3010 	ldr	r3, [fp, #-16]
    8a2c:	e5d33000 	ldrb	r3, [r3]
    8a30:	e3530039 	cmp	r3, #57	; 0x39
    8a34:	8a00000d 	bhi	8a70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8a38:	e51b3010 	ldr	r3, [fp, #-16]
    8a3c:	e5d33000 	ldrb	r3, [r3]
    8a40:	e353002f 	cmp	r3, #47	; 0x2f
    8a44:	9a000009 	bls	8a70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8a48:	e51b3010 	ldr	r3, [fp, #-16]
    8a4c:	e5d33000 	ldrb	r3, [r3]
    8a50:	e2433030 	sub	r3, r3, #48	; 0x30
    8a54:	e51b2008 	ldr	r2, [fp, #-8]
    8a58:	e0823003 	add	r3, r2, r3
    8a5c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a60:	e51b3010 	ldr	r3, [fp, #-16]
    8a64:	e2833001 	add	r3, r3, #1
    8a68:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a6c:	eaffffe3 	b	8a00 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a70:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8a74:	e1a00003 	mov	r0, r3
    8a78:	e28bd000 	add	sp, fp, #0
    8a7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a80:	e12fff1e 	bx	lr

00008a84 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a88:	e28db000 	add	fp, sp, #0
    8a8c:	e24dd01c 	sub	sp, sp, #28
    8a90:	e50b0010 	str	r0, [fp, #-16]
    8a94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8a9c:	e3a03000 	mov	r3, #0
    8aa0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8aa4:	e51b2008 	ldr	r2, [fp, #-8]
    8aa8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8aac:	e1520003 	cmp	r2, r3
    8ab0:	aa000011 	bge	8afc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8ab4:	e51b3008 	ldr	r3, [fp, #-8]
    8ab8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8abc:	e0823003 	add	r3, r2, r3
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e3530000 	cmp	r3, #0
    8ac8:	0a00000b 	beq	8afc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8acc:	e51b3008 	ldr	r3, [fp, #-8]
    8ad0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ad4:	e0822003 	add	r2, r2, r3
    8ad8:	e51b3008 	ldr	r3, [fp, #-8]
    8adc:	e51b1010 	ldr	r1, [fp, #-16]
    8ae0:	e0813003 	add	r3, r1, r3
    8ae4:	e5d22000 	ldrb	r2, [r2]
    8ae8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8aec:	e51b3008 	ldr	r3, [fp, #-8]
    8af0:	e2833001 	add	r3, r3, #1
    8af4:	e50b3008 	str	r3, [fp, #-8]
    8af8:	eaffffe9 	b	8aa4 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8afc:	e51b2008 	ldr	r2, [fp, #-8]
    8b00:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b04:	e1520003 	cmp	r2, r3
    8b08:	aa000008 	bge	8b30 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8b0c:	e51b3008 	ldr	r3, [fp, #-8]
    8b10:	e51b2010 	ldr	r2, [fp, #-16]
    8b14:	e0823003 	add	r3, r2, r3
    8b18:	e3a02000 	mov	r2, #0
    8b1c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8b20:	e51b3008 	ldr	r3, [fp, #-8]
    8b24:	e2833001 	add	r3, r3, #1
    8b28:	e50b3008 	str	r3, [fp, #-8]
    8b2c:	eafffff2 	b	8afc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8b30:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8b34:	e1a00003 	mov	r0, r3
    8b38:	e28bd000 	add	sp, fp, #0
    8b3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b40:	e12fff1e 	bx	lr

00008b44 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8b44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b48:	e28db000 	add	fp, sp, #0
    8b4c:	e24dd01c 	sub	sp, sp, #28
    8b50:	e50b0010 	str	r0, [fp, #-16]
    8b54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b58:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b60:	e2432001 	sub	r2, r3, #1
    8b64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b68:	e3530000 	cmp	r3, #0
    8b6c:	c3a03001 	movgt	r3, #1
    8b70:	d3a03000 	movle	r3, #0
    8b74:	e6ef3073 	uxtb	r3, r3
    8b78:	e3530000 	cmp	r3, #0
    8b7c:	0a000016 	beq	8bdc <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b80:	e51b3010 	ldr	r3, [fp, #-16]
    8b84:	e2832001 	add	r2, r3, #1
    8b88:	e50b2010 	str	r2, [fp, #-16]
    8b8c:	e5d33000 	ldrb	r3, [r3]
    8b90:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8b94:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b98:	e2832001 	add	r2, r3, #1
    8b9c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ba0:	e5d33000 	ldrb	r3, [r3]
    8ba4:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ba8:	e55b2005 	ldrb	r2, [fp, #-5]
    8bac:	e55b3006 	ldrb	r3, [fp, #-6]
    8bb0:	e1520003 	cmp	r2, r3
    8bb4:	0a000003 	beq	8bc8 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8bb8:	e55b2005 	ldrb	r2, [fp, #-5]
    8bbc:	e55b3006 	ldrb	r3, [fp, #-6]
    8bc0:	e0423003 	sub	r3, r2, r3
    8bc4:	ea000005 	b	8be0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8bc8:	e55b3005 	ldrb	r3, [fp, #-5]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	1affffe1 	bne	8b5c <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8bd4:	e3a03000 	mov	r3, #0
    8bd8:	ea000000 	b	8be0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8bdc:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8be0:	e1a00003 	mov	r0, r3
    8be4:	e28bd000 	add	sp, fp, #0
    8be8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bec:	e12fff1e 	bx	lr

00008bf0 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8bf0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bf4:	e28db000 	add	fp, sp, #0
    8bf8:	e24dd014 	sub	sp, sp, #20
    8bfc:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8c08:	e51b3008 	ldr	r3, [fp, #-8]
    8c0c:	e51b2010 	ldr	r2, [fp, #-16]
    8c10:	e0823003 	add	r3, r2, r3
    8c14:	e5d33000 	ldrb	r3, [r3]
    8c18:	e3530000 	cmp	r3, #0
    8c1c:	0a000003 	beq	8c30 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e2833001 	add	r3, r3, #1
    8c28:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8c2c:	eafffff5 	b	8c08 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8c30:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8c34:	e1a00003 	mov	r0, r3
    8c38:	e28bd000 	add	sp, fp, #0
    8c3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c40:	e12fff1e 	bx	lr

00008c44 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8c44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c48:	e28db000 	add	fp, sp, #0
    8c4c:	e24dd014 	sub	sp, sp, #20
    8c50:	e50b0010 	str	r0, [fp, #-16]
    8c54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c58:	e51b3010 	ldr	r3, [fp, #-16]
    8c5c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c60:	e3a03000 	mov	r3, #0
    8c64:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c68:	e51b2008 	ldr	r2, [fp, #-8]
    8c6c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c70:	e1520003 	cmp	r2, r3
    8c74:	aa000008 	bge	8c9c <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c78:	e51b3008 	ldr	r3, [fp, #-8]
    8c7c:	e51b200c 	ldr	r2, [fp, #-12]
    8c80:	e0823003 	add	r3, r2, r3
    8c84:	e3a02000 	mov	r2, #0
    8c88:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c8c:	e51b3008 	ldr	r3, [fp, #-8]
    8c90:	e2833001 	add	r3, r3, #1
    8c94:	e50b3008 	str	r3, [fp, #-8]
    8c98:	eafffff2 	b	8c68 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8c9c:	e320f000 	nop	{0}
    8ca0:	e28bd000 	add	sp, fp, #0
    8ca4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ca8:	e12fff1e 	bx	lr

00008cac <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8cac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cb0:	e28db000 	add	fp, sp, #0
    8cb4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8cb8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8cbc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8cc0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8cc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cc8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8ccc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8cd0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8cd4:	e3a03000 	mov	r3, #0
    8cd8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8cdc:	e51b2008 	ldr	r2, [fp, #-8]
    8ce0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ce4:	e1520003 	cmp	r2, r3
    8ce8:	aa00000b 	bge	8d1c <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e51b200c 	ldr	r2, [fp, #-12]
    8cf4:	e0822003 	add	r2, r2, r3
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e51b1010 	ldr	r1, [fp, #-16]
    8d00:	e0813003 	add	r3, r1, r3
    8d04:	e5d22000 	ldrb	r2, [r2]
    8d08:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8d0c:	e51b3008 	ldr	r3, [fp, #-8]
    8d10:	e2833001 	add	r3, r3, #1
    8d14:	e50b3008 	str	r3, [fp, #-8]
    8d18:	eaffffef 	b	8cdc <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8d1c:	e320f000 	nop	{0}
    8d20:	e28bd000 	add	sp, fp, #0
    8d24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d28:	e12fff1e 	bx	lr

00008d2c <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8d2c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d30:	e28db000 	add	fp, sp, #0
    8d34:	e24dd014 	sub	sp, sp, #20
    8d38:	ed0b0a04 	vstr	s0, [fp, #-16]
    8d3c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8d40:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8d44:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8d48:	e3a03000 	mov	r3, #0
    8d4c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8d50:	e51b200c 	ldr	r2, [fp, #-12]
    8d54:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d58:	e1520003 	cmp	r2, r3
    8d5c:	2a000007 	bcs	8d80 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8d60:	ed1b7a02 	vldr	s14, [fp, #-8]
    8d64:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d68:	ee677a27 	vmul.f32	s15, s14, s15
    8d6c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8d70:	e51b300c 	ldr	r3, [fp, #-12]
    8d74:	e2833001 	add	r3, r3, #1
    8d78:	e50b300c 	str	r3, [fp, #-12]
    8d7c:	eafffff3 	b	8d50 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8d80:	e51b3008 	ldr	r3, [fp, #-8]
    8d84:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8d88:	eeb00a67 	vmov.f32	s0, s15
    8d8c:	e28bd000 	add	sp, fp, #0
    8d90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d94:	e12fff1e 	bx	lr

00008d98 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8d98:	e92d4800 	push	{fp, lr}
    8d9c:	e28db004 	add	fp, sp, #4
    8da0:	e24dd018 	sub	sp, sp, #24
    8da4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8da8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8dac:	ebffff8f 	bl	8bf0 <_Z6strlenPKc>
    8db0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8db4:	e3a03000 	mov	r3, #0
    8db8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8dbc:	e51b300c 	ldr	r3, [fp, #-12]
    8dc0:	e1a02fa3 	lsr	r2, r3, #31
    8dc4:	e0823003 	add	r3, r2, r3
    8dc8:	e1a030c3 	asr	r3, r3, #1
    8dcc:	e1a02003 	mov	r2, r3
    8dd0:	e51b3008 	ldr	r3, [fp, #-8]
    8dd4:	e1530002 	cmp	r3, r2
    8dd8:	aa00001c 	bge	8e50 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8ddc:	e51b3008 	ldr	r3, [fp, #-8]
    8de0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8de4:	e0823003 	add	r3, r2, r3
    8de8:	e5d33000 	ldrb	r3, [r3]
    8dec:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8df0:	e51b200c 	ldr	r2, [fp, #-12]
    8df4:	e51b3008 	ldr	r3, [fp, #-8]
    8df8:	e0423003 	sub	r3, r2, r3
    8dfc:	e2433001 	sub	r3, r3, #1
    8e00:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8e04:	e0822003 	add	r2, r2, r3
    8e08:	e51b3008 	ldr	r3, [fp, #-8]
    8e0c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8e10:	e0813003 	add	r3, r1, r3
    8e14:	e5d22000 	ldrb	r2, [r2]
    8e18:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8e1c:	e51b200c 	ldr	r2, [fp, #-12]
    8e20:	e51b3008 	ldr	r3, [fp, #-8]
    8e24:	e0423003 	sub	r3, r2, r3
    8e28:	e2433001 	sub	r3, r3, #1
    8e2c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8e30:	e0823003 	add	r3, r2, r3
    8e34:	e51b2010 	ldr	r2, [fp, #-16]
    8e38:	e6ef2072 	uxtb	r2, r2
    8e3c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8e40:	e51b3008 	ldr	r3, [fp, #-8]
    8e44:	e2833001 	add	r3, r3, #1
    8e48:	e50b3008 	str	r3, [fp, #-8]
    8e4c:	eaffffda 	b	8dbc <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8e50:	e320f000 	nop	{0}
    8e54:	e24bd004 	sub	sp, fp, #4
    8e58:	e8bd8800 	pop	{fp, pc}

00008e5c <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8e5c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e60:	e28db000 	add	fp, sp, #0
    8e64:	e24dd01c 	sub	sp, sp, #28
    8e68:	ed0b0a04 	vstr	s0, [fp, #-16]
    8e6c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8e70:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8e74:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8e78:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e7c:	ed9f7af3 	vldr	s14, [pc, #972]	; 9250 <_Z11split_floatfRjS_Ri+0x3f4>
    8e80:	eef47ac7 	vcmpe.f32	s15, s14
    8e84:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e88:	ba000053 	blt	8fdc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8e8c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e90:	ed9f7aef 	vldr	s14, [pc, #956]	; 9254 <_Z11split_floatfRjS_Ri+0x3f8>
    8e94:	eef47ac7 	vcmpe.f32	s15, s14
    8e98:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e9c:	ba000008 	blt	8ec4 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8ea0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ea4:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9258 <_Z11split_floatfRjS_Ri+0x3fc>
    8ea8:	ee677a87 	vmul.f32	s15, s15, s14
    8eac:	ed4b7a04 	vstr	s15, [fp, #-16]
    8eb0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8eb4:	e5933000 	ldr	r3, [r3]
    8eb8:	e2832020 	add	r2, r3, #32
    8ebc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ec0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    8ec4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ec8:	ed9f7ae3 	vldr	s14, [pc, #908]	; 925c <_Z11split_floatfRjS_Ri+0x400>
    8ecc:	eef47ac7 	vcmpe.f32	s15, s14
    8ed0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ed4:	ba000008 	blt	8efc <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8ed8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8edc:	ed9f7adf 	vldr	s14, [pc, #892]	; 9260 <_Z11split_floatfRjS_Ri+0x404>
    8ee0:	ee677a87 	vmul.f32	s15, s15, s14
    8ee4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ee8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8eec:	e5933000 	ldr	r3, [r3]
    8ef0:	e2832010 	add	r2, r3, #16
    8ef4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ef8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    8efc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f00:	ed9f7ad7 	vldr	s14, [pc, #860]	; 9264 <_Z11split_floatfRjS_Ri+0x408>
    8f04:	eef47ac7 	vcmpe.f32	s15, s14
    8f08:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f0c:	ba000008 	blt	8f34 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    8f10:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f14:	ed9f7ad3 	vldr	s14, [pc, #844]	; 9268 <_Z11split_floatfRjS_Ri+0x40c>
    8f18:	ee677a87 	vmul.f32	s15, s15, s14
    8f1c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f20:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f24:	e5933000 	ldr	r3, [r3]
    8f28:	e2832008 	add	r2, r3, #8
    8f2c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f30:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    8f34:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f38:	ed9f7acb 	vldr	s14, [pc, #812]	; 926c <_Z11split_floatfRjS_Ri+0x410>
    8f3c:	eef47ac7 	vcmpe.f32	s15, s14
    8f40:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f44:	ba000008 	blt	8f6c <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    8f48:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f4c:	ed9f7ac7 	vldr	s14, [pc, #796]	; 9270 <_Z11split_floatfRjS_Ri+0x414>
    8f50:	ee677a87 	vmul.f32	s15, s15, s14
    8f54:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f58:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f5c:	e5933000 	ldr	r3, [r3]
    8f60:	e2832004 	add	r2, r3, #4
    8f64:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f68:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    8f6c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f70:	ed9f7abf 	vldr	s14, [pc, #764]	; 9274 <_Z11split_floatfRjS_Ri+0x418>
    8f74:	eef47ac7 	vcmpe.f32	s15, s14
    8f78:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f7c:	ba000008 	blt	8fa4 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    8f80:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f84:	ed9f7abb 	vldr	s14, [pc, #748]	; 9278 <_Z11split_floatfRjS_Ri+0x41c>
    8f88:	ee677a87 	vmul.f32	s15, s15, s14
    8f8c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f90:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f94:	e5933000 	ldr	r3, [r3]
    8f98:	e2832002 	add	r2, r3, #2
    8f9c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fa0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    8fa4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fa8:	ed9f7aa8 	vldr	s14, [pc, #672]	; 9250 <_Z11split_floatfRjS_Ri+0x3f4>
    8fac:	eef47ac7 	vcmpe.f32	s15, s14
    8fb0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fb4:	ba000008 	blt	8fdc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    8fb8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fbc:	ed9f7aae 	vldr	s14, [pc, #696]	; 927c <_Z11split_floatfRjS_Ri+0x420>
    8fc0:	ee677a87 	vmul.f32	s15, s15, s14
    8fc4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8fc8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fcc:	e5933000 	ldr	r3, [r3]
    8fd0:	e2832001 	add	r2, r3, #1
    8fd4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fd8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    8fdc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fe0:	eef57ac0 	vcmpe.f32	s15, #0.0
    8fe4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fe8:	da000058 	ble	9150 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    8fec:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ff0:	ed9f7aa2 	vldr	s14, [pc, #648]	; 9280 <_Z11split_floatfRjS_Ri+0x424>
    8ff4:	eef47ac7 	vcmpe.f32	s15, s14
    8ff8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ffc:	8a000053 	bhi	9150 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    9000:	ed5b7a04 	vldr	s15, [fp, #-16]
    9004:	ed9f7a9e 	vldr	s14, [pc, #632]	; 9284 <_Z11split_floatfRjS_Ri+0x428>
    9008:	eef47ac7 	vcmpe.f32	s15, s14
    900c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9010:	5a000008 	bpl	9038 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    9014:	ed5b7a04 	vldr	s15, [fp, #-16]
    9018:	ed9f7a8d 	vldr	s14, [pc, #564]	; 9254 <_Z11split_floatfRjS_Ri+0x3f8>
    901c:	ee677a87 	vmul.f32	s15, s15, s14
    9020:	ed4b7a04 	vstr	s15, [fp, #-16]
    9024:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9028:	e5933000 	ldr	r3, [r3]
    902c:	e2432020 	sub	r2, r3, #32
    9030:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9034:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    9038:	ed5b7a04 	vldr	s15, [fp, #-16]
    903c:	ed9f7a91 	vldr	s14, [pc, #580]	; 9288 <_Z11split_floatfRjS_Ri+0x42c>
    9040:	eef47ac7 	vcmpe.f32	s15, s14
    9044:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9048:	5a000008 	bpl	9070 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    904c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9050:	ed9f7a81 	vldr	s14, [pc, #516]	; 925c <_Z11split_floatfRjS_Ri+0x400>
    9054:	ee677a87 	vmul.f32	s15, s15, s14
    9058:	ed4b7a04 	vstr	s15, [fp, #-16]
    905c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9060:	e5933000 	ldr	r3, [r3]
    9064:	e2432010 	sub	r2, r3, #16
    9068:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    906c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    9070:	ed5b7a04 	vldr	s15, [fp, #-16]
    9074:	ed9f7a84 	vldr	s14, [pc, #528]	; 928c <_Z11split_floatfRjS_Ri+0x430>
    9078:	eef47ac7 	vcmpe.f32	s15, s14
    907c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9080:	5a000008 	bpl	90a8 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    9084:	ed5b7a04 	vldr	s15, [fp, #-16]
    9088:	ed9f7a75 	vldr	s14, [pc, #468]	; 9264 <_Z11split_floatfRjS_Ri+0x408>
    908c:	ee677a87 	vmul.f32	s15, s15, s14
    9090:	ed4b7a04 	vstr	s15, [fp, #-16]
    9094:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9098:	e5933000 	ldr	r3, [r3]
    909c:	e2432008 	sub	r2, r3, #8
    90a0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90a4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    90a8:	ed5b7a04 	vldr	s15, [fp, #-16]
    90ac:	ed9f7a77 	vldr	s14, [pc, #476]	; 9290 <_Z11split_floatfRjS_Ri+0x434>
    90b0:	eef47ac7 	vcmpe.f32	s15, s14
    90b4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90b8:	5a000008 	bpl	90e0 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    90bc:	ed5b7a04 	vldr	s15, [fp, #-16]
    90c0:	ed9f7a69 	vldr	s14, [pc, #420]	; 926c <_Z11split_floatfRjS_Ri+0x410>
    90c4:	ee677a87 	vmul.f32	s15, s15, s14
    90c8:	ed4b7a04 	vstr	s15, [fp, #-16]
    90cc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90d0:	e5933000 	ldr	r3, [r3]
    90d4:	e2432004 	sub	r2, r3, #4
    90d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90dc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    90e0:	ed5b7a04 	vldr	s15, [fp, #-16]
    90e4:	ed9f7a64 	vldr	s14, [pc, #400]	; 927c <_Z11split_floatfRjS_Ri+0x420>
    90e8:	eef47ac7 	vcmpe.f32	s15, s14
    90ec:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90f0:	5a000008 	bpl	9118 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    90f4:	ed5b7a04 	vldr	s15, [fp, #-16]
    90f8:	ed9f7a5d 	vldr	s14, [pc, #372]	; 9274 <_Z11split_floatfRjS_Ri+0x418>
    90fc:	ee677a87 	vmul.f32	s15, s15, s14
    9100:	ed4b7a04 	vstr	s15, [fp, #-16]
    9104:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9108:	e5933000 	ldr	r3, [r3]
    910c:	e2432002 	sub	r2, r3, #2
    9110:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9114:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    9118:	ed5b7a04 	vldr	s15, [fp, #-16]
    911c:	ed9f7a57 	vldr	s14, [pc, #348]	; 9280 <_Z11split_floatfRjS_Ri+0x424>
    9120:	eef47ac7 	vcmpe.f32	s15, s14
    9124:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9128:	5a000008 	bpl	9150 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    912c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9130:	ed9f7a46 	vldr	s14, [pc, #280]	; 9250 <_Z11split_floatfRjS_Ri+0x3f4>
    9134:	ee677a87 	vmul.f32	s15, s15, s14
    9138:	ed4b7a04 	vstr	s15, [fp, #-16]
    913c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9140:	e5933000 	ldr	r3, [r3]
    9144:	e2432001 	sub	r2, r3, #1
    9148:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    914c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    9150:	ed5b7a04 	vldr	s15, [fp, #-16]
    9154:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9158:	ee172a90 	vmov	r2, s15
    915c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9160:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    9164:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9168:	e5933000 	ldr	r3, [r3]
    916c:	ee073a90 	vmov	s15, r3
    9170:	eef87a67 	vcvt.f32.u32	s15, s15
    9174:	ed1b7a04 	vldr	s14, [fp, #-16]
    9178:	ee777a67 	vsub.f32	s15, s14, s15
    917c:	ed9f7a38 	vldr	s14, [pc, #224]	; 9264 <_Z11split_floatfRjS_Ri+0x408>
    9180:	ee677a87 	vmul.f32	s15, s15, s14
    9184:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    9188:	ed5b7a02 	vldr	s15, [fp, #-8]
    918c:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9190:	ee172a90 	vmov	r2, s15
    9194:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9198:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    919c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91a0:	e5933000 	ldr	r3, [r3]
    91a4:	ee073a90 	vmov	s15, r3
    91a8:	eef87a67 	vcvt.f32.u32	s15, s15
    91ac:	ed1b7a02 	vldr	s14, [fp, #-8]
    91b0:	ee777a67 	vsub.f32	s15, s14, s15
    91b4:	ed9f7a36 	vldr	s14, [pc, #216]	; 9294 <_Z11split_floatfRjS_Ri+0x438>
    91b8:	eef47ac7 	vcmpe.f32	s15, s14
    91bc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91c0:	aa000000 	bge	91c8 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    91c4:	ea00001d 	b	9240 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    91c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91cc:	e5933000 	ldr	r3, [r3]
    91d0:	e2832001 	add	r2, r3, #1
    91d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91d8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    91dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91e0:	e5933000 	ldr	r3, [r3]
    91e4:	e59f20ac 	ldr	r2, [pc, #172]	; 9298 <_Z11split_floatfRjS_Ri+0x43c>
    91e8:	e1530002 	cmp	r3, r2
    91ec:	9a000013 	bls	9240 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    91f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91f4:	e3a02000 	mov	r2, #0
    91f8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    91fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9200:	e5933000 	ldr	r3, [r3]
    9204:	e2832001 	add	r2, r3, #1
    9208:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    920c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    9210:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9214:	e5933000 	ldr	r3, [r3]
    9218:	e3530009 	cmp	r3, #9
    921c:	9a000007 	bls	9240 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    9220:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9224:	e3a02001 	mov	r2, #1
    9228:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    922c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9230:	e5933000 	ldr	r3, [r3]
    9234:	e2832001 	add	r2, r3, #1
    9238:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    923c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    9240:	e320f000 	nop	{0}
    9244:	e28bd000 	add	sp, fp, #0
    9248:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    924c:	e12fff1e 	bx	lr
    9250:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9254:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9258:	0a4fb11f 	beq	13f56dc <__bss_end+0x13ebb7c>
    925c:	5a0e1bca 	bpl	39018c <__bss_end+0x38662c>
    9260:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    9264:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    9268:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    926c:	461c4000 	ldrmi	r4, [ip], -r0
    9270:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    9274:	42c80000 	sbcmi	r0, r8, #0
    9278:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    927c:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    9280:	3f800000 	svccc	0x00800000
    9284:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    9288:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    928c:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    9290:	3a83126f 	bcc	fe0cdc54 <__bss_end+0xfe0c40f4>
    9294:	3f000000 	svccc	0x00000000
    9298:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

0000929c <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    929c:	e92d4800 	push	{fp, lr}
    92a0:	e28db004 	add	fp, sp, #4
    92a4:	e24dd018 	sub	sp, sp, #24
    92a8:	e50b0010 	str	r0, [fp, #-16]
    92ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    92b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    92b4:	e3a03000 	mov	r3, #0
    92b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    92bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92c0:	e2432001 	sub	r2, r3, #1
    92c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    92c8:	e3530000 	cmp	r3, #0
    92cc:	c3a03001 	movgt	r3, #1
    92d0:	d3a03000 	movle	r3, #0
    92d4:	e6ef3073 	uxtb	r3, r3
    92d8:	e3530000 	cmp	r3, #0
    92dc:	0a000018 	beq	9344 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    92e0:	e51b1010 	ldr	r1, [fp, #-16]
    92e4:	e59f3080 	ldr	r3, [pc, #128]	; 936c <_Z23decimal_to_string_floatjPci+0xd0>
    92e8:	e0832193 	umull	r2, r3, r3, r1
    92ec:	e1a021a3 	lsr	r2, r3, #3
    92f0:	e1a03002 	mov	r3, r2
    92f4:	e1a03103 	lsl	r3, r3, #2
    92f8:	e0833002 	add	r3, r3, r2
    92fc:	e1a03083 	lsl	r3, r3, #1
    9300:	e0412003 	sub	r2, r1, r3
    9304:	e6ef2072 	uxtb	r2, r2
    9308:	e51b3008 	ldr	r3, [fp, #-8]
    930c:	e2831001 	add	r1, r3, #1
    9310:	e50b1008 	str	r1, [fp, #-8]
    9314:	e1a01003 	mov	r1, r3
    9318:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    931c:	e0833001 	add	r3, r3, r1
    9320:	e2822030 	add	r2, r2, #48	; 0x30
    9324:	e6ef2072 	uxtb	r2, r2
    9328:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    932c:	e51b3010 	ldr	r3, [fp, #-16]
    9330:	e59f2034 	ldr	r2, [pc, #52]	; 936c <_Z23decimal_to_string_floatjPci+0xd0>
    9334:	e0832392 	umull	r2, r3, r2, r3
    9338:	e1a031a3 	lsr	r3, r3, #3
    933c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9340:	eaffffdd 	b	92bc <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    9344:	e51b3008 	ldr	r3, [fp, #-8]
    9348:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    934c:	e0823003 	add	r3, r2, r3
    9350:	e3a02000 	mov	r2, #0
    9354:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9358:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    935c:	ebfffe8d 	bl	8d98 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    9360:	e320f000 	nop	{0}
    9364:	e24bd004 	sub	sp, fp, #4
    9368:	e8bd8800 	pop	{fp, pc}
    936c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00009370 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    9370:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9374:	e28db000 	add	fp, sp, #0
    9378:	e24dd00c 	sub	sp, sp, #12
    937c:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    9380:	ed1b7a02 	vldr	s14, [fp, #-8]
    9384:	ed5b7a02 	vldr	s15, [fp, #-8]
    9388:	eeb47a67 	vcmp.f32	s14, s15
    938c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9390:	13a03001 	movne	r3, #1
    9394:	03a03000 	moveq	r3, #0
    9398:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    939c:	e1a00003 	mov	r0, r3
    93a0:	e28bd000 	add	sp, fp, #0
    93a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    93a8:	e12fff1e 	bx	lr

000093ac <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    93ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    93b0:	e28db000 	add	fp, sp, #0
    93b4:	e24dd00c 	sub	sp, sp, #12
    93b8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    93bc:	ed5b7a02 	vldr	s15, [fp, #-8]
    93c0:	ed9f7a08 	vldr	s14, [pc, #32]	; 93e8 <_Z5isinff+0x3c>
    93c4:	eef47ac7 	vcmpe.f32	s15, s14
    93c8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    93cc:	c3a03001 	movgt	r3, #1
    93d0:	d3a03000 	movle	r3, #0
    93d4:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    93d8:	e1a00003 	mov	r0, r3
    93dc:	e28bd000 	add	sp, fp, #0
    93e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    93e4:	e12fff1e 	bx	lr
    93e8:	7f7fffff 	svcvc	0x007fffff

000093ec <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    93ec:	e92d4800 	push	{fp, lr}
    93f0:	e28db004 	add	fp, sp, #4
    93f4:	e24dd008 	sub	sp, sp, #8
    93f8:	ed0b0a02 	vstr	s0, [fp, #-8]
    93fc:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    9400:	e3a01008 	mov	r1, #8
    9404:	e51b000c 	ldr	r0, [fp, #-12]
    9408:	ed1b0a02 	vldr	s0, [fp, #-8]
    940c:	eb000002 	bl	941c <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    9410:	e320f000 	nop	{0}
    9414:	e24bd004 	sub	sp, fp, #4
    9418:	e8bd8800 	pop	{fp, pc}

0000941c <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    941c:	e92d4800 	push	{fp, lr}
    9420:	e28db004 	add	fp, sp, #4
    9424:	e24dd060 	sub	sp, sp, #96	; 0x60
    9428:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    942c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    9430:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9434:	e3a03000 	mov	r3, #0
    9438:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    943c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9440:	eef57ac0 	vcmpe.f32	s15, #0.0
    9444:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9448:	5a000009 	bpl	9474 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    944c:	e51b3008 	ldr	r3, [fp, #-8]
    9450:	e2832001 	add	r2, r3, #1
    9454:	e50b2008 	str	r2, [fp, #-8]
    9458:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    945c:	e0823003 	add	r3, r2, r3
    9460:	e3a0202d 	mov	r2, #45	; 0x2d
    9464:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    9468:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    946c:	eef17a67 	vneg.f32	s15, s15
    9470:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    9474:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9478:	ebffffbc 	bl	9370 <_Z5isnanf>
    947c:	e1a03000 	mov	r3, r0
    9480:	e3530000 	cmp	r3, #0
    9484:	0a00001c 	beq	94fc <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    9488:	e51b3008 	ldr	r3, [fp, #-8]
    948c:	e2832001 	add	r2, r3, #1
    9490:	e50b2008 	str	r2, [fp, #-8]
    9494:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9498:	e0823003 	add	r3, r2, r3
    949c:	e3a0204e 	mov	r2, #78	; 0x4e
    94a0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    94a4:	e51b3008 	ldr	r3, [fp, #-8]
    94a8:	e2832001 	add	r2, r3, #1
    94ac:	e50b2008 	str	r2, [fp, #-8]
    94b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94b4:	e0823003 	add	r3, r2, r3
    94b8:	e3a02061 	mov	r2, #97	; 0x61
    94bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    94c0:	e51b3008 	ldr	r3, [fp, #-8]
    94c4:	e2832001 	add	r2, r3, #1
    94c8:	e50b2008 	str	r2, [fp, #-8]
    94cc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94d0:	e0823003 	add	r3, r2, r3
    94d4:	e3a0204e 	mov	r2, #78	; 0x4e
    94d8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    94dc:	e51b3008 	ldr	r3, [fp, #-8]
    94e0:	e2832001 	add	r2, r3, #1
    94e4:	e50b2008 	str	r2, [fp, #-8]
    94e8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94ec:	e0823003 	add	r3, r2, r3
    94f0:	e3a02000 	mov	r2, #0
    94f4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    94f8:	ea00008c 	b	9730 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    94fc:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9500:	ebffffa9 	bl	93ac <_Z5isinff>
    9504:	e1a03000 	mov	r3, r0
    9508:	e3530000 	cmp	r3, #0
    950c:	0a00001c 	beq	9584 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    9510:	e51b3008 	ldr	r3, [fp, #-8]
    9514:	e2832001 	add	r2, r3, #1
    9518:	e50b2008 	str	r2, [fp, #-8]
    951c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9520:	e0823003 	add	r3, r2, r3
    9524:	e3a02049 	mov	r2, #73	; 0x49
    9528:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    952c:	e51b3008 	ldr	r3, [fp, #-8]
    9530:	e2832001 	add	r2, r3, #1
    9534:	e50b2008 	str	r2, [fp, #-8]
    9538:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    953c:	e0823003 	add	r3, r2, r3
    9540:	e3a0206e 	mov	r2, #110	; 0x6e
    9544:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    9548:	e51b3008 	ldr	r3, [fp, #-8]
    954c:	e2832001 	add	r2, r3, #1
    9550:	e50b2008 	str	r2, [fp, #-8]
    9554:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9558:	e0823003 	add	r3, r2, r3
    955c:	e3a02066 	mov	r2, #102	; 0x66
    9560:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    9564:	e51b3008 	ldr	r3, [fp, #-8]
    9568:	e2832001 	add	r2, r3, #1
    956c:	e50b2008 	str	r2, [fp, #-8]
    9570:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9574:	e0823003 	add	r3, r2, r3
    9578:	e3a02000 	mov	r2, #0
    957c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    9580:	ea00006a 	b	9730 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    9584:	e3a03008 	mov	r3, #8
    9588:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    958c:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9590:	e3530007 	cmp	r3, #7
    9594:	8a000001 	bhi	95a0 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    9598:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    959c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    95a0:	e51b300c 	ldr	r3, [fp, #-12]
    95a4:	e1a00003 	mov	r0, r3
    95a8:	ed9f0a62 	vldr	s0, [pc, #392]	; 9738 <_Z4ftoafPcj+0x31c>
    95ac:	ebfffdde 	bl	8d2c <_Z3powfj>
    95b0:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    95b4:	eddf6a60 	vldr	s13, [pc, #384]	; 973c <_Z4ftoafPcj+0x320>
    95b8:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    95bc:	eec67a87 	vdiv.f32	s15, s13, s14
    95c0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    95c4:	ee777a27 	vadd.f32	s15, s14, s15
    95c8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    95cc:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    95d0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    95d4:	ee173a90 	vmov	r3, s15
    95d8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    95dc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    95e0:	ee073a90 	vmov	s15, r3
    95e4:	eef87a67 	vcvt.f32.u32	s15, s15
    95e8:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    95ec:	ee377a67 	vsub.f32	s14, s14, s15
    95f0:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    95f4:	ee677a27 	vmul.f32	s15, s14, s15
    95f8:	eefc7ae7 	vcvt.u32.f32	s15, s15
    95fc:	ee173a90 	vmov	r3, s15
    9600:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    9604:	e24b3044 	sub	r3, fp, #68	; 0x44
    9608:	e3a0200a 	mov	r2, #10
    960c:	e1a01003 	mov	r1, r3
    9610:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9614:	ebfffc96 	bl	8874 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9618:	e24b3044 	sub	r3, fp, #68	; 0x44
    961c:	e1a00003 	mov	r0, r3
    9620:	ebfffd72 	bl	8bf0 <_Z6strlenPKc>
    9624:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9628:	e3a03000 	mov	r3, #0
    962c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    9630:	e51b2010 	ldr	r2, [fp, #-16]
    9634:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9638:	e1520003 	cmp	r2, r3
    963c:	aa00000d 	bge	9678 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    9640:	e51b3008 	ldr	r3, [fp, #-8]
    9644:	e2832001 	add	r2, r3, #1
    9648:	e50b2008 	str	r2, [fp, #-8]
    964c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9650:	e0823003 	add	r3, r2, r3
    9654:	e24b1044 	sub	r1, fp, #68	; 0x44
    9658:	e51b2010 	ldr	r2, [fp, #-16]
    965c:	e0812002 	add	r2, r1, r2
    9660:	e5d22000 	ldrb	r2, [r2]
    9664:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    9668:	e51b3010 	ldr	r3, [fp, #-16]
    966c:	e2833001 	add	r3, r3, #1
    9670:	e50b3010 	str	r3, [fp, #-16]
    9674:	eaffffed 	b	9630 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    9678:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    967c:	e3530000 	cmp	r3, #0
    9680:	0a000025 	beq	971c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    9684:	e51b3008 	ldr	r3, [fp, #-8]
    9688:	e2832001 	add	r2, r3, #1
    968c:	e50b2008 	str	r2, [fp, #-8]
    9690:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9694:	e0823003 	add	r3, r2, r3
    9698:	e3a0202e 	mov	r2, #46	; 0x2e
    969c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    96a0:	e24b3050 	sub	r3, fp, #80	; 0x50
    96a4:	e51b200c 	ldr	r2, [fp, #-12]
    96a8:	e1a01003 	mov	r1, r3
    96ac:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    96b0:	ebfffef9 	bl	929c <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    96b4:	e3a03000 	mov	r3, #0
    96b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    96bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96c0:	e3530008 	cmp	r3, #8
    96c4:	ca000014 	bgt	971c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    96c8:	e24b2050 	sub	r2, fp, #80	; 0x50
    96cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96d0:	e0823003 	add	r3, r2, r3
    96d4:	e5d33000 	ldrb	r3, [r3]
    96d8:	e3530000 	cmp	r3, #0
    96dc:	0a00000d 	beq	9718 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    96e0:	e51b3008 	ldr	r3, [fp, #-8]
    96e4:	e2832001 	add	r2, r3, #1
    96e8:	e50b2008 	str	r2, [fp, #-8]
    96ec:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    96f0:	e0823003 	add	r3, r2, r3
    96f4:	e24b1050 	sub	r1, fp, #80	; 0x50
    96f8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    96fc:	e0812002 	add	r2, r1, r2
    9700:	e5d22000 	ldrb	r2, [r2]
    9704:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    9708:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    970c:	e2833001 	add	r3, r3, #1
    9710:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9714:	eaffffe8 	b	96bc <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9718:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    971c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9720:	e51b3008 	ldr	r3, [fp, #-8]
    9724:	e0823003 	add	r3, r2, r3
    9728:	e3a02000 	mov	r2, #0
    972c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    9730:	e24bd004 	sub	sp, fp, #4
    9734:	e8bd8800 	pop	{fp, pc}
    9738:	41200000 			; <UNDEFINED> instruction: 0x41200000
    973c:	3f000000 	svccc	0x00000000

00009740 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    9740:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9744:	e28db000 	add	fp, sp, #0
    9748:	e24dd01c 	sub	sp, sp, #28
    974c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    9750:	e3a03000 	mov	r3, #0
    9754:	e50b3008 	str	r3, [fp, #-8]
    9758:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    975c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    9760:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9764:	e5d33000 	ldrb	r3, [r3]
    9768:	e353002d 	cmp	r3, #45	; 0x2d
    976c:	1a000004 	bne	9784 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    9770:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9774:	e2833001 	add	r3, r3, #1
    9778:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    977c:	e59f30c8 	ldr	r3, [pc, #200]	; 984c <_Z4atofPKc+0x10c>
    9780:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    9784:	e3a03000 	mov	r3, #0
    9788:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    978c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9790:	e5d33000 	ldrb	r3, [r3]
    9794:	e3530000 	cmp	r3, #0
    9798:	0a000023 	beq	982c <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    979c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97a0:	e5d33000 	ldrb	r3, [r3]
    97a4:	e353002e 	cmp	r3, #46	; 0x2e
    97a8:	1a000002 	bne	97b8 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    97ac:	e3a03001 	mov	r3, #1
    97b0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    97b4:	ea000018 	b	981c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    97b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97bc:	e5d33000 	ldrb	r3, [r3]
    97c0:	e2433030 	sub	r3, r3, #48	; 0x30
    97c4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    97c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    97cc:	e3530000 	cmp	r3, #0
    97d0:	ba000011 	blt	981c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    97d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    97d8:	e3530009 	cmp	r3, #9
    97dc:	ca00000e 	bgt	981c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    97e0:	e51b3010 	ldr	r3, [fp, #-16]
    97e4:	e3530000 	cmp	r3, #0
    97e8:	0a000003 	beq	97fc <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    97ec:	ed1b7a03 	vldr	s14, [fp, #-12]
    97f0:	eddf6a14 	vldr	s13, [pc, #80]	; 9848 <_Z4atofPKc+0x108>
    97f4:	eec77a26 	vdiv.f32	s15, s14, s13
    97f8:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    97fc:	ed5b7a02 	vldr	s15, [fp, #-8]
    9800:	ed9f7a10 	vldr	s14, [pc, #64]	; 9848 <_Z4atofPKc+0x108>
    9804:	ee277a87 	vmul.f32	s14, s15, s14
    9808:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    980c:	ee073a90 	vmov	s15, r3
    9810:	eef87ae7 	vcvt.f32.s32	s15, s15
    9814:	ee777a27 	vadd.f32	s15, s14, s15
    9818:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    981c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9820:	e2833001 	add	r3, r3, #1
    9824:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9828:	eaffffd7 	b	978c <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    982c:	ed1b7a02 	vldr	s14, [fp, #-8]
    9830:	ed5b7a03 	vldr	s15, [fp, #-12]
    9834:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9838:	eeb00a67 	vmov.f32	s0, s15
    983c:	e28bd000 	add	sp, fp, #0
    9840:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9844:	e12fff1e 	bx	lr
    9848:	41200000 			; <UNDEFINED> instruction: 0x41200000
    984c:	bf800000 	svclt	0x00800000

00009850 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9850:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9854:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9858:	3a000074 	bcc	9a30 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    985c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9860:	9a00006b 	bls	9a14 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9864:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9868:	0a00006c 	beq	9a20 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    986c:	e16f3f10 	clz	r3, r0
    9870:	e16f2f11 	clz	r2, r1
    9874:	e0423003 	sub	r3, r2, r3
    9878:	e273301f 	rsbs	r3, r3, #31
    987c:	10833083 	addne	r3, r3, r3, lsl #1
    9880:	e3a02000 	mov	r2, #0
    9884:	108ff103 	addne	pc, pc, r3, lsl #2
    9888:	e1a00000 	nop			; (mov r0, r0)
    988c:	e1500f81 	cmp	r0, r1, lsl #31
    9890:	e0a22002 	adc	r2, r2, r2
    9894:	20400f81 	subcs	r0, r0, r1, lsl #31
    9898:	e1500f01 	cmp	r0, r1, lsl #30
    989c:	e0a22002 	adc	r2, r2, r2
    98a0:	20400f01 	subcs	r0, r0, r1, lsl #30
    98a4:	e1500e81 	cmp	r0, r1, lsl #29
    98a8:	e0a22002 	adc	r2, r2, r2
    98ac:	20400e81 	subcs	r0, r0, r1, lsl #29
    98b0:	e1500e01 	cmp	r0, r1, lsl #28
    98b4:	e0a22002 	adc	r2, r2, r2
    98b8:	20400e01 	subcs	r0, r0, r1, lsl #28
    98bc:	e1500d81 	cmp	r0, r1, lsl #27
    98c0:	e0a22002 	adc	r2, r2, r2
    98c4:	20400d81 	subcs	r0, r0, r1, lsl #27
    98c8:	e1500d01 	cmp	r0, r1, lsl #26
    98cc:	e0a22002 	adc	r2, r2, r2
    98d0:	20400d01 	subcs	r0, r0, r1, lsl #26
    98d4:	e1500c81 	cmp	r0, r1, lsl #25
    98d8:	e0a22002 	adc	r2, r2, r2
    98dc:	20400c81 	subcs	r0, r0, r1, lsl #25
    98e0:	e1500c01 	cmp	r0, r1, lsl #24
    98e4:	e0a22002 	adc	r2, r2, r2
    98e8:	20400c01 	subcs	r0, r0, r1, lsl #24
    98ec:	e1500b81 	cmp	r0, r1, lsl #23
    98f0:	e0a22002 	adc	r2, r2, r2
    98f4:	20400b81 	subcs	r0, r0, r1, lsl #23
    98f8:	e1500b01 	cmp	r0, r1, lsl #22
    98fc:	e0a22002 	adc	r2, r2, r2
    9900:	20400b01 	subcs	r0, r0, r1, lsl #22
    9904:	e1500a81 	cmp	r0, r1, lsl #21
    9908:	e0a22002 	adc	r2, r2, r2
    990c:	20400a81 	subcs	r0, r0, r1, lsl #21
    9910:	e1500a01 	cmp	r0, r1, lsl #20
    9914:	e0a22002 	adc	r2, r2, r2
    9918:	20400a01 	subcs	r0, r0, r1, lsl #20
    991c:	e1500981 	cmp	r0, r1, lsl #19
    9920:	e0a22002 	adc	r2, r2, r2
    9924:	20400981 	subcs	r0, r0, r1, lsl #19
    9928:	e1500901 	cmp	r0, r1, lsl #18
    992c:	e0a22002 	adc	r2, r2, r2
    9930:	20400901 	subcs	r0, r0, r1, lsl #18
    9934:	e1500881 	cmp	r0, r1, lsl #17
    9938:	e0a22002 	adc	r2, r2, r2
    993c:	20400881 	subcs	r0, r0, r1, lsl #17
    9940:	e1500801 	cmp	r0, r1, lsl #16
    9944:	e0a22002 	adc	r2, r2, r2
    9948:	20400801 	subcs	r0, r0, r1, lsl #16
    994c:	e1500781 	cmp	r0, r1, lsl #15
    9950:	e0a22002 	adc	r2, r2, r2
    9954:	20400781 	subcs	r0, r0, r1, lsl #15
    9958:	e1500701 	cmp	r0, r1, lsl #14
    995c:	e0a22002 	adc	r2, r2, r2
    9960:	20400701 	subcs	r0, r0, r1, lsl #14
    9964:	e1500681 	cmp	r0, r1, lsl #13
    9968:	e0a22002 	adc	r2, r2, r2
    996c:	20400681 	subcs	r0, r0, r1, lsl #13
    9970:	e1500601 	cmp	r0, r1, lsl #12
    9974:	e0a22002 	adc	r2, r2, r2
    9978:	20400601 	subcs	r0, r0, r1, lsl #12
    997c:	e1500581 	cmp	r0, r1, lsl #11
    9980:	e0a22002 	adc	r2, r2, r2
    9984:	20400581 	subcs	r0, r0, r1, lsl #11
    9988:	e1500501 	cmp	r0, r1, lsl #10
    998c:	e0a22002 	adc	r2, r2, r2
    9990:	20400501 	subcs	r0, r0, r1, lsl #10
    9994:	e1500481 	cmp	r0, r1, lsl #9
    9998:	e0a22002 	adc	r2, r2, r2
    999c:	20400481 	subcs	r0, r0, r1, lsl #9
    99a0:	e1500401 	cmp	r0, r1, lsl #8
    99a4:	e0a22002 	adc	r2, r2, r2
    99a8:	20400401 	subcs	r0, r0, r1, lsl #8
    99ac:	e1500381 	cmp	r0, r1, lsl #7
    99b0:	e0a22002 	adc	r2, r2, r2
    99b4:	20400381 	subcs	r0, r0, r1, lsl #7
    99b8:	e1500301 	cmp	r0, r1, lsl #6
    99bc:	e0a22002 	adc	r2, r2, r2
    99c0:	20400301 	subcs	r0, r0, r1, lsl #6
    99c4:	e1500281 	cmp	r0, r1, lsl #5
    99c8:	e0a22002 	adc	r2, r2, r2
    99cc:	20400281 	subcs	r0, r0, r1, lsl #5
    99d0:	e1500201 	cmp	r0, r1, lsl #4
    99d4:	e0a22002 	adc	r2, r2, r2
    99d8:	20400201 	subcs	r0, r0, r1, lsl #4
    99dc:	e1500181 	cmp	r0, r1, lsl #3
    99e0:	e0a22002 	adc	r2, r2, r2
    99e4:	20400181 	subcs	r0, r0, r1, lsl #3
    99e8:	e1500101 	cmp	r0, r1, lsl #2
    99ec:	e0a22002 	adc	r2, r2, r2
    99f0:	20400101 	subcs	r0, r0, r1, lsl #2
    99f4:	e1500081 	cmp	r0, r1, lsl #1
    99f8:	e0a22002 	adc	r2, r2, r2
    99fc:	20400081 	subcs	r0, r0, r1, lsl #1
    9a00:	e1500001 	cmp	r0, r1
    9a04:	e0a22002 	adc	r2, r2, r2
    9a08:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9a0c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9a10:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9a14:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9a18:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9a1c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    9a20:	e16f2f11 	clz	r2, r1
    9a24:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9a28:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9a2c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9a30:	e3500000 	cmp	r0, #0
    9a34:	13e00000 	mvnne	r0, #0
    9a38:	ea000007 	b	9a5c <__aeabi_idiv0>

00009a3c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9a3c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9a40:	0afffffa 	beq	9a30 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9a44:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9a48:	ebffff80 	bl	9850 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    9a4c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9a50:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9a54:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9a58:	e12fff1e 	bx	lr

00009a5c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9a5c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009a60 <_ZL8INFINITY>:
    9a60:	7f7fffff 	svcvc	0x007fffff

00009a64 <_ZL13Lock_Unlocked>:
    9a64:	00000000 	andeq	r0, r0, r0

00009a68 <_ZL11Lock_Locked>:
    9a68:	00000001 	andeq	r0, r0, r1

00009a6c <_ZL21MaxFSDriverNameLength>:
    9a6c:	00000010 	andeq	r0, r0, r0, lsl r0

00009a70 <_ZL17MaxFilenameLength>:
    9a70:	00000010 	andeq	r0, r0, r0, lsl r0

00009a74 <_ZL13MaxPathLength>:
    9a74:	00000080 	andeq	r0, r0, r0, lsl #1

00009a78 <_ZL18NoFilesystemDriver>:
    9a78:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a7c <_ZL9NotifyAll>:
    9a7c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a80 <_ZL24Max_Process_Opened_Files>:
    9a80:	00000010 	andeq	r0, r0, r0, lsl r0

00009a84 <_ZL10Indefinite>:
    9a84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a88 <_ZL18Deadline_Unchanged>:
    9a88:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a8c <_ZL14Invalid_Handle>:
    9a8c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a90 <_ZN3halL18Default_Clock_RateE>:
    9a90:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009a94 <_ZN3halL15Peripheral_BaseE>:
    9a94:	20000000 	andcs	r0, r0, r0

00009a98 <_ZN3halL9GPIO_BaseE>:
    9a98:	20200000 	eorcs	r0, r0, r0

00009a9c <_ZN3halL14GPIO_Pin_CountE>:
    9a9c:	00000036 	andeq	r0, r0, r6, lsr r0

00009aa0 <_ZN3halL8AUX_BaseE>:
    9aa0:	20215000 	eorcs	r5, r1, r0

00009aa4 <_ZN3halL25Interrupt_Controller_BaseE>:
    9aa4:	2000b200 	andcs	fp, r0, r0, lsl #4

00009aa8 <_ZN3halL10Timer_BaseE>:
    9aa8:	2000b400 	andcs	fp, r0, r0, lsl #8

00009aac <_ZN3halL9TRNG_BaseE>:
    9aac:	20104000 	andscs	r4, r0, r0

00009ab0 <_ZN3halL9BSC0_BaseE>:
    9ab0:	20205000 	eorcs	r5, r0, r0

00009ab4 <_ZN3halL9BSC1_BaseE>:
    9ab4:	20804000 	addcs	r4, r0, r0

00009ab8 <_ZN3halL9BSC2_BaseE>:
    9ab8:	20805000 	addcs	r5, r0, r0

00009abc <_ZL11Invalid_Pin>:
    9abc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ac0 <_ZL17symbol_tick_delay>:
    9ac0:	00000400 	andeq	r0, r0, r0, lsl #8

00009ac4 <_ZL15char_tick_delay>:
    9ac4:	00001000 	andeq	r1, r0, r0
    9ac8:	00000031 	andeq	r0, r0, r1, lsr r0
    9acc:	00000030 	andeq	r0, r0, r0, lsr r0
    9ad0:	3a564544 	bcc	159afe8 <__bss_end+0x1591488>
    9ad4:	6f697067 	svcvs	0x00697067
    9ad8:	0038312f 	eorseq	r3, r8, pc, lsr #2
    9adc:	3a564544 	bcc	159aff4 <__bss_end+0x1591494>
    9ae0:	6f697067 	svcvs	0x00697067
    9ae4:	0036312f 	eorseq	r3, r6, pc, lsr #2
    9ae8:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    9aec:	21534f53 	cmpcs	r3, r3, asr pc
    9af0:	00000000 	andeq	r0, r0, r0

00009af4 <_ZL13Lock_Unlocked>:
    9af4:	00000000 	andeq	r0, r0, r0

00009af8 <_ZL11Lock_Locked>:
    9af8:	00000001 	andeq	r0, r0, r1

00009afc <_ZL21MaxFSDriverNameLength>:
    9afc:	00000010 	andeq	r0, r0, r0, lsl r0

00009b00 <_ZL17MaxFilenameLength>:
    9b00:	00000010 	andeq	r0, r0, r0, lsl r0

00009b04 <_ZL13MaxPathLength>:
    9b04:	00000080 	andeq	r0, r0, r0, lsl #1

00009b08 <_ZL18NoFilesystemDriver>:
    9b08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b0c <_ZL9NotifyAll>:
    9b0c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b10 <_ZL24Max_Process_Opened_Files>:
    9b10:	00000010 	andeq	r0, r0, r0, lsl r0

00009b14 <_ZL10Indefinite>:
    9b14:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b18 <_ZL18Deadline_Unchanged>:
    9b18:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009b1c <_ZL14Invalid_Handle>:
    9b1c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b20 <_ZL8INFINITY>:
    9b20:	7f7fffff 	svcvc	0x007fffff

00009b24 <_ZL16Pipe_File_Prefix>:
    9b24:	3a535953 	bcc	14e0078 <__bss_end+0x14d6518>
    9b28:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9b2c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009b30 <_ZL8INFINITY>:
    9b30:	7f7fffff 	svcvc	0x007fffff

00009b34 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9b34:	33323130 	teqcc	r2, #48, 2
    9b38:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9b3c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9b40:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009b48 <sos_led>:
__bss_start():
    9b48:	00000000 	andeq	r0, r0, r0

00009b4c <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683ccc>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x388c4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c4d8>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c71c4>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfadc>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36da6>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff626f>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x157238>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7640>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x77674>
 1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1d0:	01058509 	tsteq	r5, r9, lsl #10
 1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
 1d8:	02e60101 	rsceq	r0, r6, #1073741824	; 0x40000000
 1dc:	00030000 	andeq	r0, r3, r0
 1e0:	00000225 	andeq	r0, r0, r5, lsr #4
 1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 1e8:	0101000d 	tsteq	r1, sp
 1ec:	00000101 	andeq	r0, r0, r1, lsl #2
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	6f682f01 	svcvs	0x00682f01
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfc54>
 1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 200:	2f697261 	svccs	0x00697261
 204:	2f746967 	svccs	0x00746967
 208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 20c:	6f732f70 	svcvs	0x00732f70
 210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 214:	73752f73 	cmnvc	r5, #460	; 0x1cc
 218:	70737265 	rsbsvc	r7, r3, r5, ror #4
 21c:	2f656361 	svccs	0x00656361
 220:	5f736f73 	svcpl	0x00736f73
 224:	6b736174 	blvs	1cd87fc <__bss_end+0x1ccec9c>
 228:	6f682f00 	svcvs	0x00682f00
 22c:	6a2f656d 	bvs	bd97e8 <__bss_end+0xbcfc88>
 230:	73656d61 	cmnvc	r5, #6208	; 0x1840
 234:	2f697261 	svccs	0x00697261
 238:	2f746967 	svccs	0x00746967
 23c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 240:	6f732f70 	svcvs	0x00732f70
 244:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 248:	73752f73 	cmnvc	r5, #460	; 0x1cc
 24c:	70737265 	rsbsvc	r7, r3, r5, ror #4
 250:	2f656361 	svccs	0x00656361
 254:	6b2f2e2e 	blvs	bcbb14 <__bss_end+0xbc1fb4>
 258:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 25c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 260:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 264:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 268:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 26c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 270:	2f656d6f 	svccs	0x00656d6f
 274:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 278:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 27c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 280:	2f736f2f 	svccs	0x00736f2f
 284:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 288:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 28c:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff2f <__bss_end+0xffff63cf>
 290:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 294:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 298:	2f2e2e2f 	svccs	0x002e2e2f
 29c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2a0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2a4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2a8:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 2ac:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 2b0:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 2b4:	61682f30 	cmnvs	r8, r0, lsr pc
 2b8:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 2bc:	2f656d6f 	svccs	0x00656d6f
 2c0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2c4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2c8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 2cc:	2f736f2f 	svccs	0x00736f2f
 2d0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2d4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2d8:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7b <__bss_end+0xffff641b>
 2dc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2e0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2e4:	2f2e2e2f 	svccs	0x002e2e2f
 2e8:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 2ec:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
 2f0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2f4:	2f006564 	svccs	0x00006564
 2f8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2fc:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 300:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 304:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 308:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 30c:	2f70732f 	svccs	0x0070732f
 310:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 314:	2f736563 	svccs	0x00736563
 318:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 31c:	63617073 	cmnvs	r1, #115	; 0x73
 320:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 324:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 328:	2f6c656e 	svccs	0x006c656e
 32c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 330:	2f656475 	svccs	0x00656475
 334:	2f007366 	svccs	0x00007366
 338:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 33c:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 340:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 344:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 348:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 34c:	2f70732f 	svccs	0x0070732f
 350:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 354:	2f736563 	svccs	0x00736563
 358:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 35c:	63617073 	cmnvs	r1, #115	; 0x73
 360:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 364:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 368:	2f6c656e 	svccs	0x006c656e
 36c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 370:	2f656475 	svccs	0x00656475
 374:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 378:	00737265 	rsbseq	r7, r3, r5, ror #4
 37c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 380:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 384:	00010070 	andeq	r0, r1, r0, ror r0
 388:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 38c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 390:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 394:	66656474 			; <UNDEFINED> instruction: 0x66656474
 398:	0300682e 	movweq	r6, #2094	; 0x82e
 39c:	70730000 	rsbsvc	r0, r3, r0
 3a0:	6f6c6e69 	svcvs	0x006c6e69
 3a4:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3a8:	00000200 	andeq	r0, r0, r0, lsl #4
 3ac:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 3b0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 3b4:	00682e67 	rsbeq	r2, r8, r7, ror #28
 3b8:	66000004 	strvs	r0, [r0], -r4
 3bc:	73656c69 	cmnvc	r5, #26880	; 0x6900
 3c0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 3c4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 3c8:	70000005 	andvc	r0, r0, r5
 3cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3d0:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 3d4:	00000200 	andeq	r0, r0, r0, lsl #4
 3d8:	636f7270 	cmnvs	pc, #112, 4
 3dc:	5f737365 	svcpl	0x00737365
 3e0:	616e616d 	cmnvs	lr, sp, ror #2
 3e4:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 3e8:	00020068 	andeq	r0, r2, r8, rrx
 3ec:	72657000 	rsbvc	r7, r5, #0
 3f0:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 3f4:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 3f8:	0300682e 	movweq	r6, #2094	; 0x82e
 3fc:	70670000 	rsbvc	r0, r7, r0
 400:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 404:	00000600 	andeq	r0, r0, r0, lsl #12
 408:	00010500 	andeq	r0, r1, r0, lsl #10
 40c:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 410:	16030000 	strne	r0, [r3], -r0
 414:	9f070501 	svcls	0x00070501
 418:	040200bb 	streq	r0, [r2], #-187	; 0xffffff45
 41c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 420:	4a020402 	bmi	81430 <__bss_end+0x778d0>
 424:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 428:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 42c:	05670604 	strbeq	r0, [r7, #-1540]!	; 0xfffff9fc
 430:	04020001 	streq	r0, [r2], #-1
 434:	05bdbb04 	ldreq	fp, [sp, #2820]!	; 0xb04
 438:	0a059f10 	beq	168080 <__bss_end+0x15e520>
 43c:	4b0f0582 	blmi	3c1a4c <__bss_end+0x3b7eec>
 440:	05820905 	streq	r0, [r2, #2309]	; 0x905
 444:	07054c17 	smladeq	r5, r7, ip, r4
 448:	bc19054b 	cfldr32lt	mvfx0, [r9], {75}	; 0x4b
 44c:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 450:	05870104 	streq	r0, [r7, #260]	; 0x104
 454:	04020008 	streq	r0, [r2], #-8
 458:	ba090301 	blt	241064 <__bss_end+0x237504>
 45c:	01040200 	mrseq	r0, R12_usr
 460:	04020084 	streq	r0, [r2], #-132	; 0xffffff7c
 464:	02004b01 	andeq	r4, r0, #1024	; 0x400
 468:	00670104 	rsbeq	r0, r7, r4, lsl #2
 46c:	4b010402 	blmi	4147c <__bss_end+0x3791c>
 470:	01040200 	mrseq	r0, R12_usr
 474:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 478:	02004c01 	andeq	r4, r0, #256	; 0x100
 47c:	00680104 	rsbeq	r0, r8, r4, lsl #2
 480:	4b010402 	blmi	41490 <__bss_end+0x37930>
 484:	01040200 	mrseq	r0, R12_usr
 488:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 48c:	02004b01 	andeq	r4, r0, #1024	; 0x400
 490:	00670104 	rsbeq	r0, r7, r4, lsl #2
 494:	4b010402 	blmi	414a4 <__bss_end+0x37944>
 498:	01040200 	mrseq	r0, R12_usr
 49c:	04020068 	streq	r0, [r2], #-104	; 0xffffff98
 4a0:	02006801 	andeq	r6, r0, #65536	; 0x10000
 4a4:	004b0104 	subeq	r0, fp, r4, lsl #2
 4a8:	67010402 	strvs	r0, [r1, -r2, lsl #8]
 4ac:	01040200 	mrseq	r0, R12_usr
 4b0:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 4b4:	07056701 	streq	r6, [r5, -r1, lsl #14]
 4b8:	01040200 	mrseq	r0, R12_usr
 4bc:	024a6003 	subeq	r6, sl, #3
 4c0:	0101000e 	tsteq	r1, lr
 4c4:	000002bf 			; <UNDEFINED> instruction: 0x000002bf
 4c8:	018c0003 	orreq	r0, ip, r3
 4cc:	01020000 	mrseq	r0, (UNDEF: 2)
 4d0:	000d0efb 	strdeq	r0, [sp], -fp
 4d4:	01010101 	tsteq	r1, r1, lsl #2
 4d8:	01000000 	mrseq	r0, (UNDEF: 0)
 4dc:	2f010000 	svccs	0x00010000
 4e0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4e4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 4e8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 4ec:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 4f0:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 4f4:	2f70732f 	svccs	0x0070732f
 4f8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4fc:	2f736563 	svccs	0x00736563
 500:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 504:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 508:	2f006372 	svccs	0x00006372
 50c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 510:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 514:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 518:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 51c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 520:	2f70732f 	svccs	0x0070732f
 524:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 528:	2f736563 	svccs	0x00736563
 52c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 530:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 534:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 538:	702f6564 	eorvc	r6, pc, r4, ror #10
 53c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 540:	2f007373 	svccs	0x00007373
 544:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 548:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 54c:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 550:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 554:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 558:	2f70732f 	svccs	0x0070732f
 55c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 560:	2f736563 	svccs	0x00736563
 564:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 568:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 56c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 570:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 574:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 578:	2f656d6f 	svccs	0x00656d6f
 57c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 580:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 584:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 588:	2f736f2f 	svccs	0x00736f2f
 58c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 590:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 594:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 598:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 59c:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 5a0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5a4:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 5a8:	2f656d6f 	svccs	0x00656d6f
 5ac:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 5b0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 5b4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 5b8:	2f736f2f 	svccs	0x00736f2f
 5bc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 5c0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 5c4:	6b2f7365 	blvs	bdd360 <__bss_end+0xbd3800>
 5c8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5cc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5d0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5d4:	6f622f65 	svcvs	0x00622f65
 5d8:	2f647261 	svccs	0x00647261
 5dc:	30697072 	rsbcc	r7, r9, r2, ror r0
 5e0:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 5e4:	74730000 	ldrbtvc	r0, [r3], #-0
 5e8:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 5ec:	70632e65 	rsbvc	r2, r3, r5, ror #28
 5f0:	00010070 	andeq	r0, r1, r0, ror r0
 5f4:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 5f8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5fc:	70730000 	rsbsvc	r0, r3, r0
 600:	6f6c6e69 	svcvs	0x006c6e69
 604:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 608:	00000200 	andeq	r0, r0, r0, lsl #4
 60c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 610:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 614:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 618:	00000300 	andeq	r0, r0, r0, lsl #6
 61c:	636f7270 	cmnvs	pc, #112, 4
 620:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 624:	00020068 	andeq	r0, r2, r8, rrx
 628:	6f727000 	svcvs	0x00727000
 62c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 630:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 634:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 638:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 63c:	74730000 	ldrbtvc	r0, [r3], #-0
 640:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 644:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 648:	00040068 	andeq	r0, r4, r8, rrx
 64c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 650:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 654:	00050068 	andeq	r0, r5, r8, rrx
 658:	01050000 	mrseq	r0, (UNDEF: 5)
 65c:	18020500 	stmdane	r2, {r8, sl}
 660:	16000084 	strne	r0, [r0], -r4, lsl #1
 664:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
 668:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
 66c:	2f01054c 	svccs	0x0001054c
 670:	83320585 	teqhi	r2, #557842432	; 0x21400000
 674:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 678:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 67c:	01054b1a 	tsteq	r5, sl, lsl fp
 680:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 684:	4b2e05a1 	blmi	b81d10 <__bss_end+0xb781b0>
 688:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 68c:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 690:	2f01054c 	svccs	0x0001054c
 694:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 698:	054b3005 	strbeq	r3, [fp, #-5]
 69c:	1b054b2e 	blne	15335c <__bss_end+0x1497fc>
 6a0:	2f2e054b 	svccs	0x002e054b
 6a4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6a8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6ac:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 6b0:	4b2e054b 	blmi	b81be4 <__bss_end+0xb78084>
 6b4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6b8:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 6bc:	2f01054c 	svccs	0x0001054c
 6c0:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 6c4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6c8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6cc:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 6d0:	4b2f054b 	blmi	bc1c04 <__bss_end+0xbb80a4>
 6d4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6d8:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 6dc:	2f01054c 	svccs	0x0001054c
 6e0:	a12e0585 	smlawbge	lr, r5, r5, r0
 6e4:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6e8:	2f054b1b 	svccs	0x00054b1b
 6ec:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6f0:	852f0105 	strhi	r0, [pc, #-261]!	; 5f3 <shift+0x5f3>
 6f4:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 6f8:	3b054b2f 	blcc	1533bc <__bss_end+0x14985c>
 6fc:	4b1b054b 	blmi	6c1c30 <__bss_end+0x6b80d0>
 700:	052f3005 	streq	r3, [pc, #-5]!	; 703 <shift+0x703>
 704:	01054c0c 	tsteq	r5, ip, lsl #24
 708:	2f05852f 	svccs	0x0005852f
 70c:	4b3b05a1 	blmi	ec1d98 <__bss_end+0xeb8238>
 710:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 714:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 718:	9f01054c 	svcls	0x0001054c
 71c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 720:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 724:	1a054b31 	bne	1533f0 <__bss_end+0x149890>
 728:	300c054b 	andcc	r0, ip, fp, asr #10
 72c:	852f0105 	strhi	r0, [pc, #-261]!	; 62f <shift+0x62f>
 730:	05672005 	strbeq	r2, [r7, #-5]!
 734:	31054d2d 	tstcc	r5, sp, lsr #26
 738:	4b1a054b 	blmi	681c6c <__bss_end+0x67810c>
 73c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 740:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 744:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 748:	4b3e054c 	blmi	f81c80 <__bss_end+0xf78120>
 74c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 750:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 754:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 758:	4b30054d 	blmi	c01c94 <__bss_end+0xbf8134>
 75c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 760:	0105300c 	tsteq	r5, ip
 764:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 768:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 76c:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 770:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 774:	1305300f 	movwne	r3, #20495	; 0x500f
 778:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 77c:	05d81005 	ldrbeq	r1, [r8, #5]
 780:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 784:	3e010100 	adfccs	f0, f1, f0
 788:	03000006 	movweq	r0, #6
 78c:	00008f00 	andeq	r8, r0, r0, lsl #30
 790:	fb010200 	blx	40f9a <__bss_end+0x3743a>
 794:	01000d0e 	tsteq	r0, lr, lsl #26
 798:	00010101 	andeq	r0, r1, r1, lsl #2
 79c:	00010000 	andeq	r0, r1, r0
 7a0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 7a4:	2f656d6f 	svccs	0x00656d6f
 7a8:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 7ac:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 7b0:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 7b4:	2f736f2f 	svccs	0x00736f2f
 7b8:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 7bc:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 7c0:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 7c4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 7c8:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 7cc:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 7d0:	2f656d6f 	svccs	0x00656d6f
 7d4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 7d8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 7dc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 7e0:	2f736f2f 	svccs	0x00736f2f
 7e4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 7e8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 7ec:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 7f0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 7f4:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 7f8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 7fc:	73000065 	movwvc	r0, #101	; 0x65
 800:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 804:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 808:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 80c:	00000100 	andeq	r0, r0, r0, lsl #2
 810:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 814:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 818:	00682e67 	rsbeq	r2, r8, r7, ror #28
 81c:	00000002 	andeq	r0, r0, r2
 820:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 824:	00887402 	addeq	r7, r8, r2, lsl #8
 828:	06051a00 	streq	r1, [r5], -r0, lsl #20
 82c:	4c0f05bb 	cfstr32mi	mvfx0, [pc], {187}	; 0xbb
 830:	05682105 	strbeq	r2, [r8, #-261]!	; 0xfffffefb
 834:	0b05ba0a 	bleq	16f064 <__bss_end+0x165504>
 838:	4a27052e 	bmi	9c1cf8 <__bss_end+0x9b8198>
 83c:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 840:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 844:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 848:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 84c:	11056810 	tstne	r5, r0, lsl r8
 850:	4a22052e 	bmi	881d10 <__bss_end+0x8781b0>
 854:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 858:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 85c:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 860:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 864:	0b054b03 	bleq	153478 <__bss_end+0x149918>
 868:	00180568 	andseq	r0, r8, r8, ror #10
 86c:	4a030402 	bmi	c187c <__bss_end+0xb7d1c>
 870:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 874:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 878:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 87c:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 880:	02040200 	andeq	r0, r4, #0, 4
 884:	00080582 	andeq	r0, r8, r2, lsl #11
 888:	4a020402 	bmi	81898 <__bss_end+0x77d38>
 88c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 890:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 894:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 898:	0c052e02 	stceq	14, cr2, [r5], {2}
 89c:	02040200 	andeq	r0, r4, #0, 4
 8a0:	000f054a 	andeq	r0, pc, sl, asr #10
 8a4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 8a8:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 8ac:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8b0:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 8b4:	0a052e02 	beq	14c0c4 <__bss_end+0x142564>
 8b8:	02040200 	andeq	r0, r4, #0, 4
 8bc:	000b052f 	andeq	r0, fp, pc, lsr #10
 8c0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8c4:	02000d05 	andeq	r0, r0, #320	; 0x140
 8c8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8cc:	04020002 	streq	r0, [r2], #-2
 8d0:	01054602 	tsteq	r5, r2, lsl #12
 8d4:	06058588 	streq	r8, [r5], -r8, lsl #11
 8d8:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 8dc:	054a1005 	strbeq	r1, [sl, #-5]
 8e0:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 8e4:	4a0305bb 	bmi	c1fd8 <__bss_end+0xb8478>
 8e8:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8ec:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8f0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 8f4:	0d054a01 	vstreq	s8, [r5, #-4]
 8f8:	4a14054d 	bmi	501e34 <__bss_end+0x4f82d4>
 8fc:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 900:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 904:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 908:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 90c:	852f0105 	strhi	r0, [pc, #-261]!	; 80f <shift+0x80f>
 910:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 914:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 918:	1d054a04 	vstrne	s8, [r5, #-16]
 91c:	02040200 	andeq	r0, r4, #0, 4
 920:	001e0582 	andseq	r0, lr, r2, lsl #11
 924:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 928:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 92c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 930:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 934:	12054b03 	andne	r4, r5, #3072	; 0xc00
 938:	03040200 	movweq	r0, #16896	; 0x4200
 93c:	0008052e 	andeq	r0, r8, lr, lsr #10
 940:	4a030402 	bmi	c1950 <__bss_end+0xb7df0>
 944:	02000905 	andeq	r0, r0, #81920	; 0x14000
 948:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 94c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 950:	0b054a03 	bleq	153164 <__bss_end+0x149604>
 954:	03040200 	movweq	r0, #16896	; 0x4200
 958:	0002052e 	andeq	r0, r2, lr, lsr #10
 95c:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 960:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 964:	05840204 	streq	r0, [r4, #516]	; 0x204
 968:	04020008 	streq	r0, [r2], #-8
 96c:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 970:	01040200 	mrseq	r0, R12_usr
 974:	000b052e 	andeq	r0, fp, lr, lsr #10
 978:	4a010402 	bmi	41988 <__bss_end+0x37e28>
 97c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 980:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 984:	0105850b 	tsteq	r5, fp, lsl #10
 988:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 98c:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 990:	05bc2005 	ldreq	r2, [ip, #5]!
 994:	1f05660b 	svcne	0x0005660b
 998:	660a054b 	strvs	r0, [sl], -fp, asr #10
 99c:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 9a0:	16058311 			; <UNDEFINED> instruction: 0x16058311
 9a4:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
 9a8:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 9ac:	01054d0b 	tsteq	r5, fp, lsl #26
 9b0:	0605852f 	streq	r8, [r5], -pc, lsr #10
 9b4:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
 9b8:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
 9bc:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
 9c0:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
 9c4:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
 9c8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 9cc:	0b059f08 	bleq	1685f4 <__bss_end+0x15ea94>
 9d0:	0014054c 	andseq	r0, r4, ip, asr #10
 9d4:	4a030402 	bmi	c19e4 <__bss_end+0xb7e84>
 9d8:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 9dc:	05830204 	streq	r0, [r3, #516]	; 0x204
 9e0:	04020008 	streq	r0, [r2], #-8
 9e4:	0a052e02 	beq	14c1f4 <__bss_end+0x142694>
 9e8:	02040200 	andeq	r0, r4, #0, 4
 9ec:	0002054a 	andeq	r0, r2, sl, asr #10
 9f0:	49020402 	stmdbmi	r2, {r1, sl}
 9f4:	85840105 	strhi	r0, [r4, #261]	; 0x105
 9f8:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 9fc:	0b054b08 	bleq	153624 <__bss_end+0x149ac4>
 a00:	0014054c 	andseq	r0, r4, ip, asr #10
 a04:	4a030402 	bmi	c1a14 <__bss_end+0xb7eb4>
 a08:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 a0c:	05830204 	streq	r0, [r3, #516]	; 0x204
 a10:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 a14:	0a052e02 	beq	14c224 <__bss_end+0x1426c4>
 a18:	02040200 	andeq	r0, r4, #0, 4
 a1c:	000b054a 	andeq	r0, fp, sl, asr #10
 a20:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a24:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 a28:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 a2c:	0402000d 	streq	r0, [r2], #-13
 a30:	02052e02 	andeq	r2, r5, #2, 28
 a34:	02040200 	andeq	r0, r4, #0, 4
 a38:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 a3c:	9f0b0585 	svcls	0x000b0585
 a40:	054b1605 	strbeq	r1, [fp, #-1541]	; 0xfffff9fb
 a44:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 a48:	0b054a03 	bleq	15325c <__bss_end+0x1496fc>
 a4c:	02040200 	andeq	r0, r4, #0, 4
 a50:	00050583 	andeq	r0, r5, r3, lsl #11
 a54:	81020402 	tsthi	r2, r2, lsl #8
 a58:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 a5c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 a60:	0c058411 	cfstrseq	mvf8, [r5], {17}
 a64:	00180568 	andseq	r0, r8, r8, ror #10
 a68:	4a030402 	bmi	c1a78 <__bss_end+0xb7f18>
 a6c:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
 a70:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 a74:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 a78:	16056802 	strne	r6, [r5], -r2, lsl #16
 a7c:	02040200 	andeq	r0, r4, #0, 4
 a80:	000e052e 	andeq	r0, lr, lr, lsr #10
 a84:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a88:	02001c05 	andeq	r1, r0, #1280	; 0x500
 a8c:	052f0204 	streq	r0, [pc, #-516]!	; 890 <shift+0x890>
 a90:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
 a94:	0e056602 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx2
 a98:	02040200 	andeq	r0, r4, #0, 4
 a9c:	000f0566 	andeq	r0, pc, r6, ror #10
 aa0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 aa4:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
 aa8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 aac:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 ab0:	12052e02 	andne	r2, r5, #2, 28
 ab4:	02040200 	andeq	r0, r4, #0, 4
 ab8:	0019052f 	andseq	r0, r9, pc, lsr #10
 abc:	66020402 	strvs	r0, [r2], -r2, lsl #8
 ac0:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 ac4:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 ac8:	04020005 	streq	r0, [r2], #-5
 acc:	01056202 	tsteq	r5, r2, lsl #4
 ad0:	05056988 	streq	r6, [r5, #-2440]	; 0xfffff678
 ad4:	9f0905d7 	svcls	0x000905d7
 ad8:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 adc:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 ae0:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 ae4:	09058201 	stmdbeq	r5, {r0, r9, pc}
 ae8:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 aec:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 af0:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 af4:	05820104 	streq	r0, [r2, #260]	; 0x104
 af8:	1a059f09 	bne	168724 <__bss_end+0x15ebc4>
 afc:	01040200 	mrseq	r0, R12_usr
 b00:	002e059e 	mlaeq	lr, lr, r5, r0
 b04:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b08:	059f0905 	ldreq	r0, [pc, #2309]	; 1415 <shift+0x1415>
 b0c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b10:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b14:	01040200 	mrseq	r0, R12_usr
 b18:	9f090582 	svcls	0x00090582
 b1c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b20:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b24:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b28:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b2c:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 b30:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 b34:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 b38:	05820104 	streq	r0, [r2, #260]	; 0x104
 b3c:	0f05a005 	svceq	0x0005a005
 b40:	01040200 	mrseq	r0, R12_usr
 b44:	9f090582 	svcls	0x00090582
 b48:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b4c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b50:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b54:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b58:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 b5c:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 b60:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 b64:	05820104 	streq	r0, [r2, #260]	; 0x104
 b68:	1a059f09 	bne	168794 <__bss_end+0x15ec34>
 b6c:	01040200 	mrseq	r0, R12_usr
 b70:	002e059e 	mlaeq	lr, lr, r5, r0
 b74:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b78:	059f0905 	ldreq	r0, [pc, #2309]	; 1485 <shift+0x1485>
 b7c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b80:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b84:	01040200 	mrseq	r0, R12_usr
 b88:	9f090582 	svcls	0x00090582
 b8c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b90:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b94:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b98:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b9c:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 ba0:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 ba4:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 ba8:	05820104 	streq	r0, [r2, #260]	; 0x104
 bac:	0e05a010 	mcreq	0, 0, sl, cr5, cr0, {0}
 bb0:	4b1a0566 	blmi	682150 <__bss_end+0x6785f0>
 bb4:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 bb8:	0f05820b 	svceq	0x0005820b
 bbc:	660d0567 	strvs	r0, [sp], -r7, ror #10
 bc0:	054b1905 	strbeq	r1, [fp, #-2309]	; 0xfffff6fb
 bc4:	11054a12 	tstne	r5, r2, lsl sl
 bc8:	4a05054a 	bmi	1420f8 <__bss_end+0x138598>
 bcc:	0b030105 	bleq	c0fe8 <__bss_end+0xb7488>
 bd0:	03090582 	movweq	r0, #38274	; 0x9582
 bd4:	10052e76 	andne	r2, r5, r6, ror lr
 bd8:	670c054a 	strvs	r0, [ip, -sl, asr #10]
 bdc:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 be0:	0d056715 	stceq	7, cr6, [r5, #-84]	; 0xffffffac
 be4:	4a150567 	bmi	542188 <__bss_end+0x538628>
 be8:	05671005 	strbeq	r1, [r7, #-5]!
 bec:	1a054a0d 	bne	153428 <__bss_end+0x1498c8>
 bf0:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 bf4:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 bf8:	2e026a01 	vmlacs.f32	s12, s4, s2
 bfc:	bb060515 	bllt	182058 <__bss_end+0x1784f8>
 c00:	054b1205 	strbeq	r1, [fp, #-517]	; 0xfffffdfb
 c04:	20056615 	andcs	r6, r5, r5, lsl r6
 c08:	082305bb 	stmdaeq	r3!, {r0, r1, r3, r4, r5, r7, r8, sl}
 c0c:	2e120520 	cfmul64cs	mvdx0, mvdx2, mvdx0
 c10:	05821405 	streq	r1, [r2, #1029]	; 0x405
 c14:	16054a23 	strne	r4, [r5], -r3, lsr #20
 c18:	2f0b054a 	svccs	0x000b054a
 c1c:	059c0505 	ldreq	r0, [ip, #1285]	; 0x505
 c20:	0b053206 	bleq	14d440 <__bss_end+0x1438e0>
 c24:	4a0d052e 	bmi	3420e4 <__bss_end+0x338584>
 c28:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 c2c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 c30:	0105830e 	tsteq	r5, lr, lsl #6
 c34:	0d0585d7 	cfstr32eq	mvfx8, [r5, #-860]	; 0xfffffca4
 c38:	d7010583 	strle	r0, [r1, -r3, lsl #11]
 c3c:	9f0605a2 	svcls	0x000605a2
 c40:	6a830105 	bvs	fe0c105c <__bss_end+0xfe0b74fc>
 c44:	05bb0f05 	ldreq	r0, [fp, #3845]!	; 0xf05
 c48:	0c054b05 			; <UNDEFINED> instruction: 0x0c054b05
 c4c:	660e0584 	strvs	r0, [lr], -r4, lsl #11
 c50:	054a1005 	strbeq	r1, [sl, #-5]
 c54:	0d054b05 	vstreq	d4, [r5, #-20]	; 0xffffffec
 c58:	66050568 	strvs	r0, [r5], -r8, ror #10
 c5c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 c60:	1005660e 	andne	r6, r5, lr, lsl #12
 c64:	4b0c054a 	blmi	302194 <__bss_end+0x2f8634>
 c68:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c6c:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c70:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c74:	054a1005 	strbeq	r1, [sl, #-5]
 c78:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c7c:	4a100566 	bmi	40221c <__bss_end+0x3f86bc>
 c80:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c84:	0505300d 	streq	r3, [r5, #-13]
 c88:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
 c8c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c90:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c94:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c98:	054a1005 	strbeq	r1, [sl, #-5]
 c9c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 ca0:	4a100566 	bmi	402240 <__bss_end+0x3f86e0>
 ca4:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 ca8:	1005660e 	andne	r6, r5, lr, lsl #12
 cac:	4b03054a 	blmi	c21dc <__bss_end+0xb867c>
 cb0:	05300605 	ldreq	r0, [r0, #-1541]!	; 0xfffff9fb
 cb4:	0d054b02 	vstreq	d4, [r5, #-8]
 cb8:	4c1c0567 	cfldr32mi	mvfx0, [ip], {103}	; 0x67
 cbc:	059f0e05 	ldreq	r0, [pc, #3589]	; 1ac9 <shift+0x1ac9>
 cc0:	18056607 	stmdane	r5, {r0, r1, r2, r9, sl, sp, lr}
 cc4:	83340568 	teqhi	r4, #104, 10	; 0x1a000000
 cc8:	05663305 	strbeq	r3, [r6, #-773]!	; 0xfffffcfb
 ccc:	18054a44 	stmdane	r5, {r2, r6, r9, fp, lr}
 cd0:	6906054a 	stmdbvs	r6, {r1, r3, r6, r8, sl}
 cd4:	059f1d05 	ldreq	r1, [pc, #3333]	; 19e1 <shift+0x19e1>
 cd8:	1405840b 	strne	r8, [r5], #-1035	; 0xfffffbf5
 cdc:	03040200 	movweq	r0, #16896	; 0x4200
 ce0:	000c054a 	andeq	r0, ip, sl, asr #10
 ce4:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 ce8:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 cec:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 cf0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 cf4:	10054a02 	andne	r4, r5, r2, lsl #20
 cf8:	02040200 	andeq	r0, r4, #0, 4
 cfc:	00020582 	andeq	r0, r2, r2, lsl #11
 d00:	2c020402 	cfstrscs	mvf0, [r2], {2}
 d04:	680c0587 	stmdavs	ip, {r0, r1, r2, r7, r8, sl}
 d08:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 d0c:	1a054a10 	bne	153554 <__bss_end+0x1499f4>
 d10:	a00c054c 	andge	r0, ip, ip, asr #10
 d14:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 d18:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 d1c:	04056819 	streq	r6, [r5], #-2073	; 0xfffff7e7
 d20:	000d0582 	andeq	r0, sp, r2, lsl #11
 d24:	4c020402 	cfstrsmi	mvf0, [r2], {2}
 d28:	02000f05 	andeq	r0, r0, #5, 30
 d2c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 d30:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
 d34:	11054a02 	tstne	r5, r2, lsl #20
 d38:	02040200 	andeq	r0, r4, #0, 4
 d3c:	00030582 	andeq	r0, r3, r2, lsl #11
 d40:	2a020402 	bcs	81d50 <__bss_end+0x781f0>
 d44:	05850505 	streq	r0, [r5, #1285]	; 0x505
 d48:	0402000b 	streq	r0, [r2], #-11
 d4c:	0d053202 	sfmeq	f3, 4, [r5, #-8]
 d50:	02040200 	andeq	r0, r4, #0, 4
 d54:	4b010566 	blmi	422f4 <__bss_end+0x38794>
 d58:	83090585 	movwhi	r0, #38277	; 0x9585
 d5c:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 d60:	03054b07 	movweq	r4, #23303	; 0x5b07
 d64:	4b06054a 	blmi	182294 <__bss_end+0x178734>
 d68:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 d6c:	1c054c0c 	stcne	12, cr4, [r5], {12}
 d70:	01040200 	mrseq	r0, R12_usr
 d74:	001d054a 	andseq	r0, sp, sl, asr #10
 d78:	4a010402 	bmi	41d88 <__bss_end+0x38228>
 d7c:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
 d80:	12054a05 	andne	r4, r5, #20480	; 0x5000
 d84:	01040200 	mrseq	r0, R12_usr
 d88:	0007054b 	andeq	r0, r7, fp, asr #10
 d8c:	4b010402 	blmi	41d9c <__bss_end+0x3823c>
 d90:	05300d05 	ldreq	r0, [r0, #-3333]!	; 0xfffff2fb
 d94:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 d98:	0010054b 	andseq	r0, r0, fp, asr #10
 d9c:	66010402 	strvs	r0, [r1], -r2, lsl #8
 da0:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
 da4:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 da8:	11056601 	tstne	r5, r1, lsl #12
 dac:	661b0583 	ldrvs	r0, [fp], -r3, lsl #11
 db0:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 db4:	04020003 	streq	r0, [r2], #-3
 db8:	4a780302 	bmi	1e019c8 <__bss_end+0x1df7e68>
 dbc:	0b031005 	bleq	c4dd8 <__bss_end+0xbb278>
 dc0:	67010582 	strvs	r0, [r1, -r2, lsl #11]
 dc4:	01000c02 	tsteq	r0, r2, lsl #24
 dc8:	00007901 	andeq	r7, r0, r1, lsl #18
 dcc:	46000300 	strmi	r0, [r0], -r0, lsl #6
 dd0:	02000000 	andeq	r0, r0, #0
 dd4:	0d0efb01 	vstreq	d15, [lr, #-4]
 dd8:	01010100 	mrseq	r0, (UNDEF: 17)
 ddc:	00000001 	andeq	r0, r0, r1
 de0:	01000001 	tsteq	r0, r1
 de4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 de8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dec:	2f2e2e2f 	svccs	0x002e2e2f
 df0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 df4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 df8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 dfc:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 e00:	2f676966 	svccs	0x00676966
 e04:	006d7261 	rsbeq	r7, sp, r1, ror #4
 e08:	62696c00 	rsbvs	r6, r9, #0, 24
 e0c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 e10:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 e14:	00000100 	andeq	r0, r0, r0, lsl #2
 e18:	02050000 	andeq	r0, r5, #0
 e1c:	00009850 	andeq	r9, r0, r0, asr r8
 e20:	0108ca03 	tsteq	r8, r3, lsl #20
 e24:	2f2f2f30 	svccs	0x002f2f30
 e28:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 e2c:	2f1401d0 	svccs	0x001401d0
 e30:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 e34:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 e38:	2f2f661f 	svccs	0x002f661f
 e3c:	2f2f2f2f 	svccs	0x002f2f2f
 e40:	0002022f 	andeq	r0, r2, pc, lsr #4
 e44:	005c0101 	subseq	r0, ip, r1, lsl #2
 e48:	00030000 	andeq	r0, r3, r0
 e4c:	00000046 	andeq	r0, r0, r6, asr #32
 e50:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 e54:	0101000d 	tsteq	r1, sp
 e58:	00000101 	andeq	r0, r0, r1, lsl #2
 e5c:	00000100 	andeq	r0, r0, r0, lsl #2
 e60:	2f2e2e01 	svccs	0x002e2e01
 e64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e6c:	2f2e2e2f 	svccs	0x002e2e2f
 e70:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; dc0 <shift+0xdc0>
 e74:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e78:	6f632f63 	svcvs	0x00632f63
 e7c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e80:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e84:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e88:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 e8c:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 e90:	00010053 	andeq	r0, r1, r3, asr r0
 e94:	05000000 	streq	r0, [r0, #-0]
 e98:	009a5c02 	addseq	r5, sl, r2, lsl #24
 e9c:	0bb40300 	bleq	fed01aa4 <__bss_end+0xfecf7f44>
 ea0:	00020201 	andeq	r0, r2, r1, lsl #4
 ea4:	01030101 	tsteq	r3, r1, lsl #2
 ea8:	00030000 	andeq	r0, r3, r0
 eac:	000000fd 	strdeq	r0, [r0], -sp
 eb0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 eb4:	0101000d 	tsteq	r1, sp
 eb8:	00000101 	andeq	r0, r0, r1, lsl #2
 ebc:	00000100 	andeq	r0, r0, r0, lsl #2
 ec0:	2f2e2e01 	svccs	0x002e2e01
 ec4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ec8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ecc:	2f2e2e2f 	svccs	0x002e2e2f
 ed0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e20 <shift+0xe20>
 ed4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ed8:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 edc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 ee0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 ee4:	2f2e2e00 	svccs	0x002e2e00
 ee8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 eec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ef0:	2f2e2e2f 	svccs	0x002e2e2f
 ef4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 ef8:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 efc:	2f2e2e2f 	svccs	0x002e2e2f
 f00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f08:	2f2e2e2f 	svccs	0x002e2e2f
 f0c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 f10:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 f14:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 f18:	6f632f63 	svcvs	0x00632f63
 f1c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 f20:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 f24:	2f2e2e00 	svccs	0x002e2e00
 f28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f30:	2f2e2e2f 	svccs	0x002e2e2f
 f34:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e84 <shift+0xe84>
 f38:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 f3c:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 f40:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 f44:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 f48:	00000100 	andeq	r0, r0, r0, lsl #2
 f4c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 f50:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 f54:	00020068 	andeq	r0, r2, r8, rrx
 f58:	6d726100 	ldfvse	f6, [r2, #-0]
 f5c:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 f60:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 f64:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 f68:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 f6c:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 f70:	73746e61 	cmnvc	r4, #1552	; 0x610
 f74:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 f78:	72610000 	rsbvc	r0, r1, #0
 f7c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 f80:	6c000003 	stcvs	0, cr0, [r0], {3}
 f84:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 f88:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 f8c:	00000400 	andeq	r0, r0, r0, lsl #8
 f90:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 f94:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 f98:	00682e73 	rsbeq	r2, r8, r3, ror lr
 f9c:	6c000004 	stcvs	0, cr0, [r0], {4}
 fa0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 fa4:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 fa8:	00000400 	andeq	r0, r0, r0, lsl #8
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
      58:	1e2a0704 	cdpne	7, 2, cr0, cr10, cr4, {0}
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
     128:	00001e2a 	andeq	r1, r0, sl, lsr #28
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408620>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36634>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a2f8>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x36704>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f692c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000e62 	andeq	r0, r0, r2, ror #28
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0011c904 	andseq	ip, r1, r4, lsl #18
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0001ec00 	andeq	lr, r1, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	124b0200 	subne	r0, fp, #0, 4
     2fc:	04050000 	streq	r0, [r5], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	60030500 	andvs	r0, r3, r0, lsl #10
     308:	0300009a 	movweq	r0, #154	; 0x9a
     30c:	1bf40404 	blne	ffd01324 <__bss_end+0xffcf77c4>
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0ff70801 	svceq	0x00f70801
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0d870502 	cfstr32eq	mvfx0, [r7, #8]
     328:	04050000 	streq	r0, [r5], #-0
     32c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     330:	08010300 	stmdaeq	r1, {r8, r9}
     334:	00000fee 	andeq	r0, r0, lr, ror #31
     338:	88070203 	stmdahi	r7, {r0, r1, r9}
     33c:	06000011 			; <UNDEFINED> instruction: 0x06000011
     340:	000006c6 	andeq	r0, r0, r6, asr #13
     344:	7c070903 			; <UNDEFINED> instruction: 0x7c070903
     348:	04000000 	streq	r0, [r0], #-0
     34c:	0000006b 	andeq	r0, r0, fp, rrx
     350:	2a070403 	bcs	1c1364 <__bss_end+0x1b7804>
     354:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
     358:	0000007c 	andeq	r0, r0, ip, ror r0
     35c:	00007c07 	andeq	r7, r0, r7, lsl #24
     360:	12c70800 	sbcne	r0, r7, #0, 16
     364:	02080000 	andeq	r0, r8, #0
     368:	00b30806 	adcseq	r0, r3, r6, lsl #16
     36c:	72090000 	andvc	r0, r9, #0
     370:	08020030 	stmdaeq	r2, {r4, r5}
     374:	00006b0e 	andeq	r6, r0, lr, lsl #22
     378:	72090000 	andvc	r0, r9, #0
     37c:	09020031 	stmdbeq	r2, {r0, r4, r5}
     380:	00006b0e 	andeq	r6, r0, lr, lsl #22
     384:	0a000400 	beq	138c <shift+0x138c>
     388:	00000e3e 	andeq	r0, r0, lr, lsr lr
     38c:	00560405 	subseq	r0, r6, r5, lsl #8
     390:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     394:	0000ea0c 	andeq	lr, r0, ip, lsl #20
     398:	06be0b00 	ldrteq	r0, [lr], r0, lsl #22
     39c:	0b000000 	bleq	3a4 <shift+0x3a4>
     3a0:	000008e7 	andeq	r0, r0, r7, ror #17
     3a4:	0e600b01 	vmuleq.f64	d16, d0, d1
     3a8:	0b020000 	bleq	803b0 <__bss_end+0x76850>
     3ac:	0000100a 	andeq	r1, r0, sl
     3b0:	08d20b03 	ldmeq	r2, {r0, r1, r8, r9, fp}^
     3b4:	0b040000 	bleq	1003bc <__bss_end+0xf685c>
     3b8:	00000d5f 	andeq	r0, r0, pc, asr sp
     3bc:	1e0a0005 	cdpne	0, 0, cr0, cr10, cr5, {0}
     3c0:	0500000e 	streq	r0, [r0, #-14]
     3c4:	00005604 	andeq	r5, r0, r4, lsl #12
     3c8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3d0 <shift+0x3d0>
     3cc:	00000127 	andeq	r0, r0, r7, lsr #2
     3d0:	0008290b 	andeq	r2, r8, fp, lsl #18
     3d4:	470b0000 	strmi	r0, [fp, -r0]
     3d8:	0100000f 	tsteq	r0, pc
     3dc:	0012450b 	andseq	r4, r2, fp, lsl #10
     3e0:	5e0b0200 	cdppl	2, 0, cr0, cr11, cr0, {0}
     3e4:	0300000c 	movweq	r0, #12
     3e8:	0008e10b 	andeq	lr, r8, fp, lsl #2
     3ec:	d00b0400 	andle	r0, fp, r0, lsl #8
     3f0:	05000009 	streq	r0, [r0, #-9]
     3f4:	00072b0b 	andeq	r2, r7, fp, lsl #22
     3f8:	0a000600 	beq	1c00 <shift+0x1c00>
     3fc:	00000710 	andeq	r0, r0, r0, lsl r7
     400:	00560405 	subseq	r0, r6, r5, lsl #8
     404:	66020000 	strvs	r0, [r2], -r0
     408:	0001520c 	andeq	r5, r1, ip, lsl #4
     40c:	0fe30b00 	svceq	0x00e30b00
     410:	0b000000 	bleq	418 <shift+0x418>
     414:	00000592 	muleq	r0, r2, r5
     418:	0e840b01 	vdiveq.f64	d0, d4, d1
     41c:	0b020000 	bleq	80424 <__bss_end+0x768c4>
     420:	00000d6f 	andeq	r0, r0, pc, ror #26
     424:	3d060003 	stccc	0, cr0, [r6, #-12]
     428:	0400000d 	streq	r0, [r0], #-13
     42c:	00560703 	subseq	r0, r6, r3, lsl #14
     430:	c5020000 	strgt	r0, [r2, #-0]
     434:	0400000b 	streq	r0, [r0], #-11
     438:	00771405 	rsbseq	r1, r7, r5, lsl #8
     43c:	03050000 	movweq	r0, #20480	; 0x5000
     440:	00009a64 	andeq	r9, r0, r4, ror #20
     444:	000f4c02 	andeq	r4, pc, r2, lsl #24
     448:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     44c:	00000077 	andeq	r0, r0, r7, ror r0
     450:	9a680305 	bls	1a0106c <__bss_end+0x19f750c>
     454:	3b020000 	blcc	8045c <__bss_end+0x768fc>
     458:	0600000a 	streq	r0, [r0], -sl
     45c:	00771a07 	rsbseq	r1, r7, r7, lsl #20
     460:	03050000 	movweq	r0, #20480	; 0x5000
     464:	00009a6c 	andeq	r9, r0, ip, ror #20
     468:	000d9802 	andeq	r9, sp, r2, lsl #16
     46c:	1a090600 	bne	241c74 <__bss_end+0x238114>
     470:	00000077 	andeq	r0, r0, r7, ror r0
     474:	9a700305 	bls	1c01090 <__bss_end+0x1bf7530>
     478:	fe020000 	cdp2	0, 0, cr0, cr2, cr0, {0}
     47c:	06000009 	streq	r0, [r0], -r9
     480:	00771a0b 	rsbseq	r1, r7, fp, lsl #20
     484:	03050000 	movweq	r0, #20480	; 0x5000
     488:	00009a74 	andeq	r9, r0, r4, ror sl
     48c:	000d2a02 	andeq	r2, sp, r2, lsl #20
     490:	1a0d0600 	bne	341c98 <__bss_end+0x338138>
     494:	00000077 	andeq	r0, r0, r7, ror r0
     498:	9a780305 	bls	1e010b4 <__bss_end+0x1df7554>
     49c:	9e020000 	cdpls	0, 0, cr0, cr2, cr0, {0}
     4a0:	06000006 	streq	r0, [r0], -r6
     4a4:	00771a0f 	rsbseq	r1, r7, pc, lsl #20
     4a8:	03050000 	movweq	r0, #20480	; 0x5000
     4ac:	00009a7c 	andeq	r9, r0, ip, ror sl
     4b0:	000c440a 	andeq	r4, ip, sl, lsl #8
     4b4:	56040500 	strpl	r0, [r4], -r0, lsl #10
     4b8:	06000000 	streq	r0, [r0], -r0
     4bc:	02010c1b 	andeq	r0, r1, #6912	; 0x1b00
     4c0:	410b0000 	mrsmi	r0, (UNDEF: 11)
     4c4:	00000006 	andeq	r0, r0, r6
     4c8:	0010760b 	andseq	r7, r0, fp, lsl #12
     4cc:	400b0100 	andmi	r0, fp, r0, lsl #2
     4d0:	02000012 	andeq	r0, r0, #18
     4d4:	04190c00 	ldreq	r0, [r9], #-3072	; 0xfffff400
     4d8:	e10d0000 	mrs	r0, (UNDEF: 13)
     4dc:	90000004 	andls	r0, r0, r4
     4e0:	74076306 	strvc	r6, [r7], #-774	; 0xfffffcfa
     4e4:	08000003 	stmdaeq	r0, {r0, r1}
     4e8:	0000061d 	andeq	r0, r0, sp, lsl r6
     4ec:	10670624 	rsbne	r0, r7, r4, lsr #12
     4f0:	0000028e 	andeq	r0, r0, lr, lsl #5
     4f4:	00219a0e 	eoreq	r9, r1, lr, lsl #20
     4f8:	12690600 	rsbne	r0, r9, #0, 12
     4fc:	00000374 	andeq	r0, r0, r4, ror r3
     500:	082e0e00 	stmdaeq	lr!, {r9, sl, fp}
     504:	6b060000 	blvs	18050c <__bss_end+0x1769ac>
     508:	00038412 	andeq	r8, r3, r2, lsl r4
     50c:	360e1000 	strcc	r1, [lr], -r0
     510:	06000006 	streq	r0, [r0], -r6
     514:	006b166d 	rsbeq	r1, fp, sp, ror #12
     518:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     51c:	00000d68 	andeq	r0, r0, r8, ror #26
     520:	8b1c7006 	blhi	71c540 <__bss_end+0x7129e0>
     524:	18000003 	stmdane	r0, {r0, r1}
     528:	0011c00e 	andseq	ip, r1, lr
     52c:	1c720600 	ldclne	6, cr0, [r2], #-0
     530:	0000038b 	andeq	r0, r0, fp, lsl #7
     534:	04dc0e1c 	ldrbeq	r0, [ip], #3612	; 0xe1c
     538:	75060000 	strvc	r0, [r6, #-0]
     53c:	00038b1c 	andeq	r8, r3, ip, lsl fp
     540:	0d0f2000 	stceq	0, cr2, [pc, #-0]	; 548 <shift+0x548>
     544:	0600000e 	streq	r0, [r0], -lr
     548:	11131c77 	tstne	r3, r7, ror ip
     54c:	038b0000 	orreq	r0, fp, #0
     550:	02820000 	addeq	r0, r2, #0
     554:	8b100000 	blhi	40055c <__bss_end+0x3f69fc>
     558:	11000003 	tstne	r0, r3
     55c:	00000391 	muleq	r0, r1, r3
     560:	35080000 	strcc	r0, [r8, #-0]
     564:	18000012 	stmdane	r0, {r1, r4}
     568:	c3107b06 	tstgt	r0, #6144	; 0x1800
     56c:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     570:	0000219a 	muleq	r0, sl, r1
     574:	74127e06 	ldrvc	r7, [r2], #-3590	; 0xfffff1fa
     578:	00000003 	andeq	r0, r0, r3
     57c:	00053e0e 	andeq	r3, r5, lr, lsl #28
     580:	19800600 	stmibne	r0, {r9, sl}
     584:	00000391 	muleq	r0, r1, r3
     588:	09d70e10 	ldmibeq	r7, {r4, r9, sl, fp}^
     58c:	82060000 	andhi	r0, r6, #0
     590:	00039c21 	andeq	r9, r3, r1, lsr #24
     594:	04001400 	streq	r1, [r0], #-1024	; 0xfffffc00
     598:	0000028e 	andeq	r0, r0, lr, lsl #5
     59c:	00048f12 	andeq	r8, r4, r2, lsl pc
     5a0:	21860600 	orrcs	r0, r6, r0, lsl #12
     5a4:	000003a2 	andeq	r0, r0, r2, lsr #7
     5a8:	00085812 	andeq	r5, r8, r2, lsl r8
     5ac:	1f880600 	svcne	0x00880600
     5b0:	00000077 	andeq	r0, r0, r7, ror r0
     5b4:	000daa0e 	andeq	sl, sp, lr, lsl #20
     5b8:	178b0600 	strne	r0, [fp, r0, lsl #12]
     5bc:	00000213 	andeq	r0, r0, r3, lsl r2
     5c0:	07900e00 	ldreq	r0, [r0, r0, lsl #28]
     5c4:	8e060000 	cdphi	0, 0, cr0, cr6, cr0, {0}
     5c8:	00021317 	andeq	r1, r2, r7, lsl r3
     5cc:	490e2400 	stmdbmi	lr, {sl, sp}
     5d0:	0600000b 	streq	r0, [r0], -fp
     5d4:	0213178f 	andseq	r1, r3, #37486592	; 0x23c0000
     5d8:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5dc:	00000958 	andeq	r0, r0, r8, asr r9
     5e0:	13179006 	tstne	r7, #6
     5e4:	6c000002 	stcvs	0, cr0, [r0], {2}
     5e8:	0004e113 	andeq	lr, r4, r3, lsl r1
     5ec:	09930600 	ldmibeq	r3, {r9, sl}
     5f0:	00000ced 	andeq	r0, r0, sp, ror #25
     5f4:	000003ad 	andeq	r0, r0, sp, lsr #7
     5f8:	00032d01 	andeq	r2, r3, r1, lsl #26
     5fc:	00033300 	andeq	r3, r3, r0, lsl #6
     600:	03ad1000 			; <UNDEFINED> instruction: 0x03ad1000
     604:	14000000 	strne	r0, [r0], #-0
     608:	00000e02 	andeq	r0, r0, r2, lsl #28
     60c:	1f0e9606 	svcne	0x000e9606
     610:	01000005 	tsteq	r0, r5
     614:	00000348 	andeq	r0, r0, r8, asr #6
     618:	0000034e 	andeq	r0, r0, lr, asr #6
     61c:	0003ad10 	andeq	sl, r3, r0, lsl sp
     620:	29150000 	ldmdbcs	r5, {}	; <UNPREDICTABLE>
     624:	06000008 	streq	r0, [r0], -r8
     628:	0c291099 	stceq	0, cr1, [r9], #-612	; 0xfffffd9c
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
     658:	e4020103 	str	r0, [r2], #-259	; 0xfffffefd
     65c:	1800000a 	stmdane	r0, {r1, r3}
     660:	00021304 	andeq	r1, r2, r4, lsl #6
     664:	4a041800 	bmi	10666c <__bss_end+0xfcb0c>
     668:	0c000000 	stceq	0, cr0, [r0], {-0}
     66c:	000010e8 	andeq	r1, r0, r8, ror #1
     670:	03970418 	orrseq	r0, r7, #24, 8	; 0x18000000
     674:	c3160000 	tstgt	r6, #0
     678:	ad000002 	stcge	0, cr0, [r0, #-8]
     67c:	19000003 	stmdbne	r0, {r0, r1}
     680:	06041800 	streq	r1, [r4], -r0, lsl #16
     684:	18000002 	stmdane	r0, {r1}
     688:	00020104 	andeq	r0, r2, r4, lsl #2
     68c:	0df61a00 			; <UNDEFINED> instruction: 0x0df61a00
     690:	9c060000 	stcls	0, cr0, [r6], {-0}
     694:	00020614 	andeq	r0, r2, r4, lsl r6
     698:	06570200 	ldrbeq	r0, [r7], -r0, lsl #4
     69c:	04070000 	streq	r0, [r7], #-0
     6a0:	00007714 	andeq	r7, r0, r4, lsl r7
     6a4:	80030500 	andhi	r0, r3, r0, lsl #10
     6a8:	0200009a 	andeq	r0, r0, #154	; 0x9a
     6ac:	00000e66 	andeq	r0, r0, r6, ror #28
     6b0:	77140707 	ldrvc	r0, [r4, -r7, lsl #14]
     6b4:	05000000 	streq	r0, [r0, #-0]
     6b8:	009a8403 	addseq	r8, sl, r3, lsl #8
     6bc:	050c0200 	streq	r0, [ip, #-512]	; 0xfffffe00
     6c0:	0a070000 	beq	1c06c8 <__bss_end+0x1b6b68>
     6c4:	00007714 	andeq	r7, r0, r4, lsl r7
     6c8:	88030500 	stmdahi	r3, {r8, sl}
     6cc:	0a00009a 	beq	93c <shift+0x93c>
     6d0:	00000730 	andeq	r0, r0, r0, lsr r7
     6d4:	00560405 	subseq	r0, r6, r5, lsl #8
     6d8:	0d070000 	stceq	0, cr0, [r7, #-0]
     6dc:	0004320c 	andeq	r3, r4, ip, lsl #4
     6e0:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6e4:	0b000077 	bleq	8c8 <shift+0x8c8>
     6e8:	000008f1 	strdeq	r0, [r0], -r1
     6ec:	05040b01 	streq	r0, [r4, #-2817]	; 0xfffff4ff
     6f0:	0b020000 	bleq	806f8 <__bss_end+0x76b98>
     6f4:	0000074e 	andeq	r0, r0, lr, asr #14
     6f8:	0ffc0b03 	svceq	0x00fc0b03
     6fc:	0b040000 	bleq	100704 <__bss_end+0xf6ba4>
     700:	000004d5 	ldrdeq	r0, [r0], -r5
     704:	70080005 	andvc	r0, r8, r5
     708:	10000006 	andne	r0, r0, r6
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
     738:	00000e18 	andeq	r0, r0, r8, lsl lr
     73c:	71132007 	tstvc	r3, r7
     740:	0c000004 	stceq	0, cr0, [r0], {4}
     744:	07040300 	streq	r0, [r4, -r0, lsl #6]
     748:	00001e25 	andeq	r1, r0, r5, lsr #28
     74c:	00047104 	andeq	r7, r4, r4, lsl #2
     750:	08c50800 	stmiaeq	r5, {fp}^
     754:	07700000 	ldrbeq	r0, [r0, -r0]!
     758:	050d0828 	streq	r0, [sp, #-2088]	; 0xfffff7d8
     75c:	d80e0000 	stmdale	lr, {}	; <UNPREDICTABLE>
     760:	07000007 	streq	r0, [r0, -r7]
     764:	0432122a 	ldrteq	r1, [r2], #-554	; 0xfffffdd6
     768:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     76c:	00646970 	rsbeq	r6, r4, r0, ror r9
     770:	7c122b07 			; <UNDEFINED> instruction: 0x7c122b07
     774:	10000000 	andne	r0, r0, r0
     778:	001b760e 	andseq	r7, fp, lr, lsl #12
     77c:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
     780:	000003fb 	strdeq	r0, [r0], -fp
     784:	0fd50e14 	svceq	0x00d50e14
     788:	2d070000 	stccs	0, cr0, [r7, #-0]
     78c:	00007c12 	andeq	r7, r0, r2, lsl ip
     790:	a90e1800 	stmdbge	lr, {fp, ip}
     794:	07000003 	streq	r0, [r0, -r3]
     798:	007c122e 	rsbseq	r1, ip, lr, lsr #4
     79c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     7a0:	00000e53 	andeq	r0, r0, r3, asr lr
     7a4:	0d0c2f07 	stceq	15, cr2, [ip, #-28]	; 0xffffffe4
     7a8:	20000005 	andcs	r0, r0, r5
     7ac:	0004850e 	andeq	r8, r4, lr, lsl #10
     7b0:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
     7b4:	00000056 	andeq	r0, r0, r6, asr r0
     7b8:	0aa30e60 	beq	fe8c4140 <__bss_end+0xfe8ba5e0>
     7bc:	31070000 	mrscc	r0, (UNDEF: 7)
     7c0:	00006b0e 	andeq	r6, r0, lr, lsl #22
     7c4:	d20e6400 	andle	r6, lr, #0, 8
     7c8:	0700000c 	streq	r0, [r0, -ip]
     7cc:	006b0e33 	rsbeq	r0, fp, r3, lsr lr
     7d0:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7d4:	00000cc9 	andeq	r0, r0, r9, asr #25
     7d8:	6b0e3407 	blvs	38d7fc <__bss_end+0x383c9c>
     7dc:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7e0:	03b31600 			; <UNDEFINED> instruction: 0x03b31600
     7e4:	051d0000 	ldreq	r0, [sp, #-0]
     7e8:	7c170000 	ldcvc	0, cr0, [r7], {-0}
     7ec:	0f000000 	svceq	0x00000000
     7f0:	04f50200 	ldrbteq	r0, [r5], #512	; 0x200
     7f4:	0a080000 	beq	2007fc <__bss_end+0x1f6c9c>
     7f8:	00007714 	andeq	r7, r0, r4, lsl r7
     7fc:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
     800:	0a00009a 	beq	a70 <shift+0xa70>
     804:	00000a8e 	andeq	r0, r0, lr, lsl #21
     808:	00560405 	subseq	r0, r6, r5, lsl #8
     80c:	0d080000 	stceq	0, cr0, [r8, #-0]
     810:	00054e0c 	andeq	r4, r5, ip, lsl #28
     814:	12540b00 	subsne	r0, r4, #0, 22
     818:	0b000000 	bleq	820 <shift+0x820>
     81c:	000010ab 	andeq	r1, r0, fp, lsr #1
     820:	bd080001 	stclt	0, cr0, [r8, #-4]
     824:	0c000007 	stceq	0, cr0, [r0], {7}
     828:	83081b08 	movwhi	r1, #35592	; 0x8b08
     82c:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     830:	0000059d 	muleq	r0, sp, r5
     834:	83191d08 	tsthi	r9, #8, 26	; 0x200
     838:	00000005 	andeq	r0, r0, r5
     83c:	0004dc0e 	andeq	sp, r4, lr, lsl #24
     840:	191e0800 	ldmdbne	lr, {fp}
     844:	00000583 	andeq	r0, r0, r3, lsl #11
     848:	0abe0e04 	beq	fef84060 <__bss_end+0xfef7a500>
     84c:	1f080000 	svcne	0x00080000
     850:	00058913 	andeq	r8, r5, r3, lsl r9
     854:	18000800 	stmdane	r0, {fp}
     858:	00054e04 	andeq	r4, r5, r4, lsl #28
     85c:	7d041800 	stcvc	8, cr1, [r4, #-0]
     860:	0d000004 	stceq	0, cr0, [r0, #-16]
     864:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
     868:	07220814 			; <UNDEFINED> instruction: 0x07220814
     86c:	00000811 	andeq	r0, r0, r1, lsl r8
     870:	000bd30e 	andeq	sp, fp, lr, lsl #6
     874:	12260800 	eorne	r0, r6, #0, 16
     878:	0000006b 	andeq	r0, r0, fp, rrx
     87c:	0b660e00 	bleq	1984084 <__bss_end+0x197a524>
     880:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
     884:	0005831d 	andeq	r8, r5, sp, lsl r3
     888:	560e0400 	strpl	r0, [lr], -r0, lsl #8
     88c:	08000007 	stmdaeq	r0, {r0, r1, r2}
     890:	05831d2c 	streq	r1, [r3, #3372]	; 0xd2c
     894:	1c080000 	stcne	0, cr0, [r8], {-0}
     898:	00000c54 	andeq	r0, r0, r4, asr ip
     89c:	9a0e2f08 	bls	38c4c4 <__bss_end+0x382964>
     8a0:	d7000007 	strle	r0, [r0, -r7]
     8a4:	e2000005 	and	r0, r0, #5
     8a8:	10000005 	andne	r0, r0, r5
     8ac:	00000816 	andeq	r0, r0, r6, lsl r8
     8b0:	00058311 	andeq	r8, r5, r1, lsl r3
     8b4:	fa1d0000 	blx	7408bc <__bss_end+0x736d5c>
     8b8:	08000008 	stmdaeq	r0, {r3}
     8bc:	089c0e31 	ldmeq	ip, {r0, r4, r5, r9, sl, fp}
     8c0:	03840000 	orreq	r0, r4, #0
     8c4:	05fa0000 	ldrbeq	r0, [sl, #0]!
     8c8:	06050000 	streq	r0, [r5], -r0
     8cc:	16100000 	ldrne	r0, [r0], -r0
     8d0:	11000008 	tstne	r0, r8
     8d4:	00000589 	andeq	r0, r0, r9, lsl #11
     8d8:	10571300 	subsne	r1, r7, r0, lsl #6
     8dc:	35080000 	strcc	r0, [r8, #-0]
     8e0:	000a691d 	andeq	r6, sl, sp, lsl r9
     8e4:	00058300 	andeq	r8, r5, r0, lsl #6
     8e8:	061e0200 	ldreq	r0, [lr], -r0, lsl #4
     8ec:	06240000 	strteq	r0, [r4], -r0
     8f0:	16100000 	ldrne	r0, [r0], -r0
     8f4:	00000008 	andeq	r0, r0, r8
     8f8:	00074113 	andeq	r4, r7, r3, lsl r1
     8fc:	1d370800 	ldcne	8, cr0, [r7, #-0]
     900:	00000c64 	andeq	r0, r0, r4, ror #24
     904:	00000583 	andeq	r0, r0, r3, lsl #11
     908:	00063d02 	andeq	r3, r6, r2, lsl #26
     90c:	00064300 	andeq	r4, r6, r0, lsl #6
     910:	08161000 	ldmdaeq	r6, {ip}
     914:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     918:	00000b79 	andeq	r0, r0, r9, ror fp
     91c:	2f313908 	svccs	0x00313908
     920:	0c000008 	stceq	0, cr0, [r0], {8}
     924:	0db91302 	ldceq	3, cr1, [r9, #8]!
     928:	3c080000 	stccc	0, cr0, [r8], {-0}
     92c:	00090909 	andeq	r0, r9, r9, lsl #18
     930:	00081600 	andeq	r1, r8, r0, lsl #12
     934:	066a0100 	strbteq	r0, [sl], -r0, lsl #2
     938:	06700000 	ldrbteq	r0, [r0], -r0
     93c:	16100000 	ldrne	r0, [r0], -r0
     940:	00000008 	andeq	r0, r0, r8
     944:	0007ea13 	andeq	lr, r7, r3, lsl sl
     948:	123f0800 	eorsne	r0, pc, #0, 16
     94c:	00000567 	andeq	r0, r0, r7, ror #10
     950:	0000006b 	andeq	r0, r0, fp, rrx
     954:	00068901 	andeq	r8, r6, r1, lsl #18
     958:	00069e00 	andeq	r9, r6, r0, lsl #28
     95c:	08161000 	ldmdaeq	r6, {ip}
     960:	38110000 	ldmdacc	r1, {}	; <UNPREDICTABLE>
     964:	11000008 	tstne	r0, r8
     968:	0000007c 	andeq	r0, r0, ip, ror r0
     96c:	00038411 	andeq	r8, r3, r1, lsl r4
     970:	81140000 	tsthi	r4, r0
     974:	08000010 	stmdaeq	r0, {r4}
     978:	067d0e42 	ldrbteq	r0, [sp], -r2, asr #28
     97c:	b3010000 	movwlt	r0, #4096	; 0x1000
     980:	b9000006 	stmdblt	r0, {r1, r2}
     984:	10000006 	andne	r0, r0, r6
     988:	00000816 	andeq	r0, r0, r6, lsl r8
     98c:	05491300 	strbeq	r1, [r9, #-768]	; 0xfffffd00
     990:	45080000 	strmi	r0, [r8, #-0]
     994:	0005ef17 	andeq	lr, r5, r7, lsl pc
     998:	00058900 	andeq	r8, r5, r0, lsl #18
     99c:	06d20100 	ldrbeq	r0, [r2], r0, lsl #2
     9a0:	06d80000 	ldrbeq	r0, [r8], r0
     9a4:	3e100000 	cdpcc	0, 1, cr0, cr0, cr0, {0}
     9a8:	00000008 	andeq	r0, r0, r8
     9ac:	000e7113 	andeq	r7, lr, r3, lsl r1
     9b0:	17480800 	strbne	r0, [r8, -r0, lsl #16]
     9b4:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     9b8:	00000589 	andeq	r0, r0, r9, lsl #11
     9bc:	0006f101 	andeq	pc, r6, r1, lsl #2
     9c0:	0006fc00 	andeq	pc, r6, r0, lsl #24
     9c4:	083e1000 	ldmdaeq	lr!, {ip}
     9c8:	6b110000 	blvs	4409d0 <__bss_end+0x436e70>
     9cc:	00000000 	andeq	r0, r0, r0
     9d0:	0006a814 	andeq	sl, r6, r4, lsl r8
     9d4:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
     9d8:	00000b87 	andeq	r0, r0, r7, lsl #23
     9dc:	00071101 	andeq	r1, r7, r1, lsl #2
     9e0:	00071700 	andeq	r1, r7, r0, lsl #14
     9e4:	08161000 	ldmdaeq	r6, {ip}
     9e8:	13000000 	movwne	r0, #0
     9ec:	000008fa 	strdeq	r0, [r0], -sl
     9f0:	020e4d08 	andeq	r4, lr, #8, 26	; 0x200
     9f4:	8400000d 	strhi	r0, [r0], #-13
     9f8:	01000003 	tsteq	r0, r3
     9fc:	00000730 	andeq	r0, r0, r0, lsr r7
     a00:	0000073b 	andeq	r0, r0, fp, lsr r7
     a04:	00081610 	andeq	r1, r8, r0, lsl r6
     a08:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a0c:	13000000 	movwne	r0, #0
     a10:	000004c1 	andeq	r0, r0, r1, asr #9
     a14:	ec125008 	ldc	0, cr5, [r2], {8}
     a18:	6b000003 	blvs	a2c <shift+0xa2c>
     a1c:	01000000 	mrseq	r0, (UNDEF: 0)
     a20:	00000754 	andeq	r0, r0, r4, asr r7
     a24:	0000075f 	andeq	r0, r0, pc, asr r7
     a28:	00081610 	andeq	r1, r8, r0, lsl r6
     a2c:	03b31100 			; <UNDEFINED> instruction: 0x03b31100
     a30:	13000000 	movwne	r0, #0
     a34:	0000041f 	andeq	r0, r0, pc, lsl r4
     a38:	b60e5308 	strlt	r5, [lr], -r8, lsl #6
     a3c:	84000010 	strhi	r0, [r0], #-16
     a40:	01000003 	tsteq	r0, r3
     a44:	00000778 	andeq	r0, r0, r8, ror r7
     a48:	00000783 	andeq	r0, r0, r3, lsl #15
     a4c:	00081610 	andeq	r1, r8, r0, lsl r6
     a50:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a54:	14000000 	strne	r0, [r0], #-0
     a58:	0000049b 	muleq	r0, fp, r4
     a5c:	580e5608 	stmdapl	lr, {r3, r9, sl, ip, lr}
     a60:	0100000f 	tsteq	r0, pc
     a64:	00000798 	muleq	r0, r8, r7
     a68:	000007b7 			; <UNDEFINED> instruction: 0x000007b7
     a6c:	00081610 	andeq	r1, r8, r0, lsl r6
     a70:	00b31100 	adcseq	r1, r3, r0, lsl #2
     a74:	6b110000 	blvs	440a7c <__bss_end+0x436f1c>
     a78:	11000000 	mrsne	r0, (UNDEF: 0)
     a7c:	0000006b 	andeq	r0, r0, fp, rrx
     a80:	00006b11 	andeq	r6, r0, r1, lsl fp
     a84:	08441100 	stmdaeq	r4, {r8, ip}^
     a88:	14000000 	strne	r0, [r0], #-0
     a8c:	00001143 	andeq	r1, r0, r3, asr #2
     a90:	7b0e5808 	blvc	396ab8 <__bss_end+0x38cf58>
     a94:	01000012 	tsteq	r0, r2, lsl r0
     a98:	000007cc 	andeq	r0, r0, ip, asr #15
     a9c:	000007eb 	andeq	r0, r0, fp, ror #15
     aa0:	00081610 	andeq	r1, r8, r0, lsl r6
     aa4:	00ea1100 	rsceq	r1, sl, r0, lsl #2
     aa8:	6b110000 	blvs	440ab0 <__bss_end+0x436f50>
     aac:	11000000 	mrsne	r0, (UNDEF: 0)
     ab0:	0000006b 	andeq	r0, r0, fp, rrx
     ab4:	00006b11 	andeq	r6, r0, r1, lsl fp
     ab8:	08441100 	stmdaeq	r4, {r8, ip}^
     abc:	15000000 	strne	r0, [r0, #-0]
     ac0:	000004ae 	andeq	r0, r0, lr, lsr #9
     ac4:	e90e5b08 	stmdb	lr, {r3, r8, r9, fp, ip, lr}
     ac8:	8400000a 	strhi	r0, [r0], #-10
     acc:	01000003 	tsteq	r0, r3
     ad0:	00000800 	andeq	r0, r0, r0, lsl #16
     ad4:	00081610 	andeq	r1, r8, r0, lsl r6
     ad8:	052f1100 	streq	r1, [pc, #-256]!	; 9e0 <shift+0x9e0>
     adc:	4a110000 	bmi	440ae4 <__bss_end+0x436f84>
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
     b20:	0011a01a 	andseq	sl, r1, sl, lsl r0
     b24:	195e0800 	ldmdbne	lr, {fp}^
     b28:	0000058f 	andeq	r0, r0, pc, lsl #11
     b2c:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b30:	0b050900 	bleq	142f38 <__bss_end+0x1393d8>
     b34:	00000912 	andeq	r0, r0, r2, lsl r9
     b38:	000b3624 	andeq	r3, fp, r4, lsr #12
     b3c:	19070900 	stmdbne	r7, {r8, fp}
     b40:	00000083 	andeq	r0, r0, r3, lsl #1
     b44:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b48:	000e9b24 	andeq	r9, lr, r4, lsr #22
     b4c:	1a0a0900 	bne	282f54 <__bss_end+0x2793f4>
     b50:	00000478 	andeq	r0, r0, r8, ror r4
     b54:	20000000 	andcs	r0, r0, r0
     b58:	00055d24 	andeq	r5, r5, r4, lsr #26
     b5c:	1a0d0900 	bne	342f64 <__bss_end+0x339404>
     b60:	00000478 	andeq	r0, r0, r8, ror r4
     b64:	20200000 	eorcs	r0, r0, r0
     b68:	000aaf25 	andeq	sl, sl, r5, lsr #30
     b6c:	15100900 	ldrne	r0, [r0, #-2304]	; 0xfffff700
     b70:	00000077 	andeq	r0, r0, r7, ror r0
     b74:	10632436 	rsbne	r2, r3, r6, lsr r4
     b78:	4b090000 	blmi	240b80 <__bss_end+0x237020>
     b7c:	0004781a 	andeq	r7, r4, sl, lsl r8
     b80:	21500000 	cmpcs	r0, r0
     b84:	121b2420 	andsne	r2, fp, #32, 8	; 0x20000000
     b88:	7a090000 	bvc	240b90 <__bss_end+0x237030>
     b8c:	0004781a 	andeq	r7, r4, sl, lsl r8
     b90:	00b20000 	adcseq	r0, r2, r0
     b94:	084d2420 	stmdaeq	sp, {r5, sl, sp}^
     b98:	ad090000 	stcge	0, cr0, [r9, #-0]
     b9c:	0004781a 	andeq	r7, r4, sl, lsl r8
     ba0:	00b40000 	adcseq	r0, r4, r0
     ba4:	0b2c2420 	bleq	b09c2c <__bss_end+0xb000cc>
     ba8:	bc090000 	stclt	0, cr0, [r9], {-0}
     bac:	0004781a 	andeq	r7, r4, sl, lsl r8
     bb0:	10400000 	subne	r0, r0, r0
     bb4:	0c9d2420 	cfldrseq	mvf2, [sp], {32}
     bb8:	c7090000 	strgt	r0, [r9, -r0]
     bbc:	0004781a 	andeq	r7, r4, sl, lsl r8
     bc0:	20500000 	subscs	r0, r0, r0
     bc4:	07212420 	streq	r2, [r1, -r0, lsr #8]!
     bc8:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
     bcc:	0004781a 	andeq	r7, r4, sl, lsl r8
     bd0:	80400000 	subhi	r0, r0, r0
     bd4:	106c2420 	rsbne	r2, ip, r0, lsr #8
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
     c1c:	0ee80200 	cdpeq	2, 14, cr0, cr8, cr0, {0}
     c20:	080a0000 	stmdaeq	sl, {}	; <UNPREDICTABLE>
     c24:	00007714 	andeq	r7, r0, r4, lsl r7
     c28:	bc030500 	cfstr32lt	mvfx0, [r3], {-0}
     c2c:	0a00009a 	beq	e9c <shift+0xe9c>
     c30:	00000c06 	andeq	r0, r0, r6, lsl #24
     c34:	007c0407 	rsbseq	r0, ip, r7, lsl #8
     c38:	0b0a0000 	bleq	280c40 <__bss_end+0x2770e0>
     c3c:	0009a40c 	andeq	sl, r9, ip, lsl #8
     c40:	0c190b00 			; <UNDEFINED> instruction: 0x0c190b00
     c44:	0b000000 	bleq	c4c <shift+0xc4c>
     c48:	0000062f 	andeq	r0, r0, pc, lsr #12
     c4c:	110d0b01 	tstne	sp, r1, lsl #22
     c50:	0b020000 	bleq	80c58 <__bss_end+0x770f8>
     c54:	00001107 	andeq	r1, r0, r7, lsl #2
     c58:	10e20b03 	rscne	r0, r2, r3, lsl #22
     c5c:	0b040000 	bleq	100c64 <__bss_end+0xf7104>
     c60:	000011ba 			; <UNDEFINED> instruction: 0x000011ba
     c64:	10fb0b05 	rscsne	r0, fp, r5, lsl #22
     c68:	0b060000 	bleq	180c70 <__bss_end+0x177110>
     c6c:	00001101 	andeq	r1, r0, r1, lsl #2
     c70:	0dca0b07 	vstreq	d16, [sl, #28]
     c74:	00080000 	andeq	r0, r8, r0
     c78:	0009bb0a 	andeq	fp, r9, sl, lsl #22
     c7c:	56040500 	strpl	r0, [r4], -r0, lsl #10
     c80:	0a000000 	beq	c88 <shift+0xc88>
     c84:	09cf0c1d 	stmibeq	pc, {r0, r2, r3, r4, sl, fp}^	; <UNPREDICTABLE>
     c88:	a70b0000 	strge	r0, [fp, -r0]
     c8c:	0000000c 	andeq	r0, r0, ip
     c90:	000ce00b 	andeq	lr, ip, fp
     c94:	c40b0100 	strgt	r0, [fp], #-256	; 0xffffff00
     c98:	0200000c 	andeq	r0, r0, #12
     c9c:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     ca0:	0d000300 	stceq	3, cr0, [r0, #-0]
     ca4:	000011ac 	andeq	r1, r0, ip, lsr #3
     ca8:	07280a1c 			; <UNDEFINED> instruction: 0x07280a1c
     cac:	00000d50 	andeq	r0, r0, r0, asr sp
     cb0:	00039b08 	andeq	r9, r3, r8, lsl #22
     cb4:	330a1000 	movwcc	r1, #40960	; 0xa000
     cb8:	000a1e0a 	andeq	r1, sl, sl, lsl #28
     cbc:	073c0e00 	ldreq	r0, [ip, -r0, lsl #28]!
     cc0:	350a0000 	strcc	r0, [sl, #-0]
     cc4:	0003b30b 	andeq	fp, r3, fp, lsl #6
     cc8:	d00e0000 	andle	r0, lr, r0
     ccc:	0a000007 	beq	cf0 <shift+0xcf0>
     cd0:	006b0d36 	rsbeq	r0, fp, r6, lsr sp
     cd4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cd8:	0000059d 	muleq	r0, sp, r5
     cdc:	5513370a 	ldrpl	r3, [r3, #-1802]	; 0xfffff8f6
     ce0:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     ce4:	0004dc0e 	andeq	sp, r4, lr, lsl #24
     ce8:	13380a00 	teqne	r8, #0, 20
     cec:	00000d55 	andeq	r0, r0, r5, asr sp
     cf0:	e40e000c 	str	r0, [lr], #-12
     cf4:	0a000007 	beq	d18 <shift+0xd18>
     cf8:	0d61202c 	stcleq	0, cr2, [r1, #-176]!	; 0xffffff50
     cfc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     d00:	00000f35 	andeq	r0, r0, r5, lsr pc
     d04:	660c2f0a 	strvs	r2, [ip], -sl, lsl #30
     d08:	0400000d 	streq	r0, [r0], #-13
     d0c:	000a510e 	andeq	r5, sl, lr, lsl #2
     d10:	0c310a00 			; <UNDEFINED> instruction: 0x0c310a00
     d14:	00000d66 	andeq	r0, r0, r6, ror #26
     d18:	0bb60e0c 	bleq	fed84550 <__bss_end+0xfed7a9f0>
     d1c:	3b0a0000 	blcc	280d24 <__bss_end+0x2771c4>
     d20:	000d5512 	andeq	r5, sp, r2, lsl r5
     d24:	520e1400 	andpl	r1, lr, #0, 8
     d28:	0a000009 	beq	d54 <shift+0xd54>
     d2c:	01520e3d 	cmpeq	r2, sp, lsr lr
     d30:	13180000 	tstne	r8, #0
     d34:	00000eab 	andeq	r0, r0, fp, lsr #29
     d38:	f908410a 			; <UNDEFINED> instruction: 0xf908410a
     d3c:	84000007 	strhi	r0, [r0], #-7
     d40:	02000003 	andeq	r0, r0, #3
     d44:	00000a78 	andeq	r0, r0, r8, ror sl
     d48:	00000a8d 	andeq	r0, r0, sp, lsl #21
     d4c:	000d7610 	andeq	r7, sp, r0, lsl r6
     d50:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     d54:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     d58:	1100000d 	tstne	r0, sp
     d5c:	00000d7c 	andeq	r0, r0, ip, ror sp
     d60:	083a1300 	ldmdaeq	sl!, {r8, r9, ip}
     d64:	430a0000 	movwmi	r0, #40960	; 0xa000
     d68:	00115908 	andseq	r5, r1, r8, lsl #18
     d6c:	00038400 	andeq	r8, r3, r0, lsl #8
     d70:	0aa60200 	beq	fe981578 <__bss_end+0xfe977a18>
     d74:	0abb0000 	beq	feec0d7c <__bss_end+0xfeeb721c>
     d78:	76100000 	ldrvc	r0, [r0], -r0
     d7c:	1100000d 	tstne	r0, sp
     d80:	0000006b 	andeq	r0, r0, fp, rrx
     d84:	000d7c11 	andeq	r7, sp, r1, lsl ip
     d88:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     d8c:	13000000 	movwne	r0, #0
     d90:	00000b53 	andeq	r0, r0, r3, asr fp
     d94:	2308450a 	movwcs	r4, #34058	; 0x850a
     d98:	84000009 	strhi	r0, [r0], #-9
     d9c:	02000003 	andeq	r0, r0, #3
     da0:	00000ad4 	ldrdeq	r0, [r0], -r4
     da4:	00000ae9 	andeq	r0, r0, r9, ror #21
     da8:	000d7610 	andeq	r7, sp, r0, lsl r6
     dac:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     db0:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     db4:	1100000d 	tstne	r0, sp
     db8:	00000d7c 	andeq	r0, r0, ip, ror sp
     dbc:	0c8a1300 	stceq	3, cr1, [sl], {0}
     dc0:	470a0000 	strmi	r0, [sl, -r0]
     dc4:	00043208 	andeq	r3, r4, r8, lsl #4
     dc8:	00038400 	andeq	r8, r3, r0, lsl #8
     dcc:	0b020200 	bleq	815d4 <__bss_end+0x77a74>
     dd0:	0b170000 	bleq	5c0dd8 <__bss_end+0x5b7278>
     dd4:	76100000 	ldrvc	r0, [r0], -r0
     dd8:	1100000d 	tstne	r0, sp
     ddc:	0000006b 	andeq	r0, r0, fp, rrx
     de0:	000d7c11 	andeq	r7, sp, r1, lsl ip
     de4:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     de8:	13000000 	movwne	r0, #0
     dec:	00000870 	andeq	r0, r0, r0, ror r8
     df0:	0c08490a 			; <UNDEFINED> instruction: 0x0c08490a
     df4:	8400000a 	strhi	r0, [r0], #-10
     df8:	02000003 	andeq	r0, r0, #3
     dfc:	00000b30 	andeq	r0, r0, r0, lsr fp
     e00:	00000b45 	andeq	r0, r0, r5, asr #22
     e04:	000d7610 	andeq	r7, sp, r0, lsl r6
     e08:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     e0c:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     e10:	1100000d 	tstne	r0, sp
     e14:	00000d7c 	andeq	r0, r0, ip, ror sp
     e18:	10101300 	andsne	r1, r0, r0, lsl #6
     e1c:	4b0a0000 	blmi	280e24 <__bss_end+0x2772c4>
     e20:	0005a208 	andeq	sl, r5, r8, lsl #4
     e24:	00038400 	andeq	r8, r3, r0, lsl #8
     e28:	0b5e0200 	bleq	1781630 <__bss_end+0x1777ad0>
     e2c:	0b780000 	bleq	1e00e34 <__bss_end+0x1df72d4>
     e30:	76100000 	ldrvc	r0, [r0], -r0
     e34:	1100000d 	tstne	r0, sp
     e38:	0000006b 	andeq	r0, r0, fp, rrx
     e3c:	0009a411 	andeq	sl, r9, r1, lsl r4
     e40:	0d7c1100 	ldfeqe	f1, [ip, #-0]
     e44:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     e48:	0000000d 	andeq	r0, r0, sp
     e4c:	000d4813 	andeq	r4, sp, r3, lsl r8
     e50:	0c4f0a00 	mcrreq	10, 0, r0, pc, cr0
     e54:	00000962 	andeq	r0, r0, r2, ror #18
     e58:	0000006b 	andeq	r0, r0, fp, rrx
     e5c:	000b9102 	andeq	r9, fp, r2, lsl #2
     e60:	000b9700 	andeq	r9, fp, r0, lsl #14
     e64:	0d761000 	ldcleq	0, cr1, [r6, #-0]
     e68:	14000000 	strne	r0, [r0], #-0
     e6c:	000009de 	ldrdeq	r0, [r0], -lr
     e70:	aa08510a 	bge	2152a0 <__bss_end+0x20b740>
     e74:	0200000f 	andeq	r0, r0, #15
     e78:	00000bac 	andeq	r0, r0, ip, lsr #23
     e7c:	00000bb7 			; <UNDEFINED> instruction: 0x00000bb7
     e80:	000d8210 	andeq	r8, sp, r0, lsl r2
     e84:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     e88:	13000000 	movwne	r0, #0
     e8c:	000011ac 	andeq	r1, r0, ip, lsr #3
     e90:	6903540a 	stmdbvs	r3, {r1, r3, sl, ip, lr}
     e94:	82000007 	andhi	r0, r0, #7
     e98:	0100000d 	tsteq	r0, sp
     e9c:	00000bd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     ea0:	00000bdb 	ldrdeq	r0, [r0], -fp
     ea4:	000d8210 	andeq	r8, sp, r0, lsl r2
     ea8:	007c1100 	rsbseq	r1, ip, r0, lsl #2
     eac:	14000000 	strne	r0, [r0], #-0
     eb0:	0000088a 	andeq	r0, r0, sl, lsl #17
     eb4:	dd08570a 	stcle	7, cr5, [r8, #-40]	; 0xffffffd8
     eb8:	0100000b 	tsteq	r0, fp
     ebc:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     ec0:	00000c00 	andeq	r0, r0, r0, lsl #24
     ec4:	000d8210 	andeq	r8, sp, r0, lsl r2
     ec8:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     ecc:	5b110000 	blpl	440ed4 <__bss_end+0x437374>
     ed0:	00000009 	andeq	r0, r0, r9
     ed4:	000ad213 	andeq	sp, sl, r3, lsl r2
     ed8:	12590a00 	subsne	r0, r9, #0, 20
     edc:	00000ebf 			; <UNDEFINED> instruction: 0x00000ebf
     ee0:	0000095b 	andeq	r0, r0, fp, asr r9
     ee4:	000c1901 	andeq	r1, ip, r1, lsl #18
     ee8:	000c2400 	andeq	r2, ip, r0, lsl #8
     eec:	0d761000 	ldcleq	0, cr1, [r6, #-0]
     ef0:	6b110000 	blvs	440ef8 <__bss_end+0x437398>
     ef4:	00000000 	andeq	r0, r0, r0
     ef8:	00062b14 	andeq	r2, r6, r4, lsl fp
     efc:	085c0a00 	ldmdaeq	ip, {r9, fp}^
     f00:	000006ee 	andeq	r0, r0, lr, ror #13
     f04:	000c3901 	andeq	r3, ip, r1, lsl #18
     f08:	000c4900 	andeq	r4, ip, r0, lsl #18
     f0c:	0d821000 	stceq	0, cr1, [r2]
     f10:	6b110000 	blvs	440f18 <__bss_end+0x4373b8>
     f14:	11000000 	mrsne	r0, (UNDEF: 0)
     f18:	00000384 	andeq	r0, r0, r4, lsl #7
     f1c:	0c151300 	ldceq	3, cr1, [r5], {-0}
     f20:	5f0a0000 	svcpl	0x000a0000
     f24:	0006cf08 	andeq	ip, r6, r8, lsl #30
     f28:	00038400 	andeq	r8, r3, r0, lsl #8
     f2c:	0c620100 	stfeqe	f0, [r2], #-0
     f30:	0c6d0000 	stcleq	0, cr0, [sp], #-0
     f34:	82100000 	andshi	r0, r0, #0
     f38:	1100000d 	tstne	r0, sp
     f3c:	0000006b 	andeq	r0, r0, fp, rrx
     f40:	0cb81300 	ldceq	3, cr1, [r8]
     f44:	620a0000 	andvs	r0, sl, #0
     f48:	00046108 	andeq	r6, r4, r8, lsl #2
     f4c:	00038400 	andeq	r8, r3, r0, lsl #8
     f50:	0c860100 	stfeqs	f0, [r6], {0}
     f54:	0c9b0000 	ldceq	0, cr0, [fp], {0}
     f58:	82100000 	andshi	r0, r0, #0
     f5c:	1100000d 	tstne	r0, sp
     f60:	0000006b 	andeq	r0, r0, fp, rrx
     f64:	00038411 	andeq	r8, r3, r1, lsl r4
     f68:	03841100 	orreq	r1, r4, #0, 2
     f6c:	13000000 	movwne	r0, #0
     f70:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
     f74:	d608640a 	strle	r6, [r8], -sl, lsl #8
     f78:	8400000d 	strhi	r0, [r0], #-13
     f7c:	01000003 	tsteq	r0, r3
     f80:	00000cb4 			; <UNDEFINED> instruction: 0x00000cb4
     f84:	00000cc9 	andeq	r0, r0, r9, asr #25
     f88:	000d8210 	andeq	r8, sp, r0, lsl r2
     f8c:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     f90:	84110000 	ldrhi	r0, [r1], #-0
     f94:	11000003 	tstne	r0, r3
     f98:	00000384 	andeq	r0, r0, r4, lsl #7
     f9c:	12d31400 	sbcsne	r1, r3, #0, 8
     fa0:	670a0000 	strvs	r0, [sl, -r0]
     fa4:	00099008 	andeq	r9, r9, r8
     fa8:	0cde0100 	ldfeqe	f0, [lr], {0}
     fac:	0cee0000 	stcleq	0, cr0, [lr]
     fb0:	82100000 	andshi	r0, r0, #0
     fb4:	1100000d 	tstne	r0, sp
     fb8:	0000006b 	andeq	r0, r0, fp, rrx
     fbc:	0009a411 	andeq	sl, r9, r1, lsl r4
     fc0:	06140000 	ldreq	r0, [r4], -r0
     fc4:	0a000012 	beq	1014 <shift+0x1014>
     fc8:	0ef40869 	cdpeq	8, 15, cr0, cr4, cr9, {3}
     fcc:	03010000 	movweq	r0, #4096	; 0x1000
     fd0:	1300000d 	movwne	r0, #13
     fd4:	1000000d 	andne	r0, r0, sp
     fd8:	00000d82 	andeq	r0, r0, r2, lsl #27
     fdc:	00006b11 	andeq	r6, r0, r1, lsl fp
     fe0:	09a41100 	stmibeq	r4!, {r8, ip}
     fe4:	14000000 	strne	r0, [r0], #-0
     fe8:	000009f3 	strdeq	r0, [r0], -r3
     fec:	8a086c0a 	bhi	21c01c <__bss_end+0x2124bc>
     ff0:	01000010 	tsteq	r0, r0, lsl r0
     ff4:	00000d28 	andeq	r0, r0, r8, lsr #26
     ff8:	00000d2e 	andeq	r0, r0, lr, lsr #26
     ffc:	000d8210 	andeq	r8, sp, r0, lsl r2
    1000:	c3270000 			; <UNDEFINED> instruction: 0xc3270000
    1004:	0a00000a 	beq	1034 <shift+0x1034>
    1008:	102b086f 	eorne	r0, fp, pc, ror #16
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
    1038:	6b160000 	blvs	581040 <__bss_end+0x5774e0>
    103c:	76000000 	strvc	r0, [r0], -r0
    1040:	1700000d 	strne	r0, [r0, -sp]
    1044:	0000007c 	andeq	r0, r0, ip, ror r0
    1048:	04180001 	ldreq	r0, [r8], #-1
    104c:	00000d50 	andeq	r0, r0, r0, asr sp
    1050:	006b0421 	rsbeq	r0, fp, r1, lsr #8
    1054:	04180000 	ldreq	r0, [r8], #-0
    1058:	000009cf 	andeq	r0, r0, pc, asr #19
    105c:	00086a1a 	andeq	r6, r8, sl, lsl sl
    1060:	16730a00 	ldrbtne	r0, [r3], -r0, lsl #20
    1064:	000009cf 	andeq	r0, r0, pc, asr #19
    1068:	00126902 	andseq	r6, r2, r2, lsl #18
    106c:	14100100 	ldrne	r0, [r0], #-256	; 0xffffff00
    1070:	00000077 	andeq	r0, r0, r7, ror r0
    1074:	9ac00305 	bls	ff001c90 <__bss_end+0xfeff8130>
    1078:	80020000 	andhi	r0, r2, r0
    107c:	01000007 	tsteq	r0, r7
    1080:	00771411 	rsbseq	r1, r7, r1, lsl r4
    1084:	03050000 	movweq	r0, #20480	; 0x5000
    1088:	00009ac4 	andeq	r9, r0, r4, asr #21
    108c:	0004ed28 	andeq	lr, r4, r8, lsr #26
    1090:	0a130100 	beq	4c1498 <__bss_end+0x4b7938>
    1094:	0000006b 	andeq	r0, r0, fp, rrx
    1098:	9b480305 	blls	1201cb4 <__bss_end+0x11f8154>
    109c:	83280000 			; <UNDEFINED> instruction: 0x83280000
    10a0:	01000008 	tsteq	r0, r8
    10a4:	006b0a14 	rsbeq	r0, fp, r4, lsl sl
    10a8:	03050000 	movweq	r0, #20480	; 0x5000
    10ac:	00009b4c 	andeq	r9, r0, ip, asr #22
    10b0:	00119b29 	andseq	r9, r1, r9, lsr #22
    10b4:	051d0100 	ldreq	r0, [sp, #-256]	; 0xffffff00
    10b8:	00000056 	andeq	r0, r0, r6, asr r0
    10bc:	000082ac 	andeq	r8, r0, ip, lsr #5
    10c0:	0000016c 	andeq	r0, r0, ip, ror #2
    10c4:	0e339c01 	cdpeq	12, 3, cr9, cr3, cr1, {0}
    10c8:	b32a0000 			; <UNDEFINED> instruction: 0xb32a0000
    10cc:	0100000c 	tsteq	r0, ip
    10d0:	00560e1d 	subseq	r0, r6, sp, lsl lr
    10d4:	91020000 	mrsls	r0, (UNDEF: 2)
    10d8:	0cdb2a6c 	vldmiaeq	fp, {s5-s112}
    10dc:	1d010000 	stcne	0, cr0, [r1, #-0]
    10e0:	000e331b 	andeq	r3, lr, fp, lsl r3
    10e4:	68910200 	ldmvs	r1, {r9}
    10e8:	000d912b 	andeq	r9, sp, fp, lsr #2
    10ec:	17220100 	strne	r0, [r2, -r0, lsl #2]!
    10f0:	000009a4 	andeq	r0, r0, r4, lsr #19
    10f4:	2b709102 	blcs	1c25504 <__bss_end+0x1c1b9a4>
    10f8:	00000e36 	andeq	r0, r0, r6, lsr lr
    10fc:	6b0b2501 	blvs	2ca508 <__bss_end+0x2c09a8>
    1100:	02000000 	andeq	r0, r0, #0
    1104:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1108:	000e3904 	andeq	r3, lr, r4, lsl #18
    110c:	43041800 	movwmi	r1, #18432	; 0x4800
    1110:	2c000000 	stccs	0, cr0, [r0], {-0}
    1114:	00000651 	andeq	r0, r0, r1, asr r6
    1118:	1f061601 	svcne	0x00061601
    111c:	2c00000c 	stccs	0, cr0, [r0], {12}
    1120:	80000082 	andhi	r0, r0, r2, lsl #1
    1124:	01000000 	mrseq	r0, (UNDEF: 0)
    1128:	064b2a9c 			; <UNDEFINED> instruction: 0x064b2a9c
    112c:	16010000 	strne	r0, [r1], -r0
    1130:	00038411 	andeq	r8, r3, r1, lsl r4
    1134:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1138:	0cf50000 	ldcleq	0, cr0, [r5]
    113c:	00040000 	andeq	r0, r4, r0
    1140:	00000493 	muleq	r0, r3, r4
    1144:	15da0104 	ldrbne	r0, [sl, #260]	; 0x104
    1148:	f0040000 			; <UNDEFINED> instruction: 0xf0040000
    114c:	7b000013 	blvc	11a0 <shift+0x11a0>
    1150:	18000014 	stmdane	r0, {r2, r4}
    1154:	5c000084 	stcpl	0, cr0, [r0], {132}	; 0x84
    1158:	c4000004 	strgt	r0, [r0], #-4
    115c:	02000004 	andeq	r0, r0, #4
    1160:	0ff70801 	svceq	0x00f70801
    1164:	25030000 	strcs	r0, [r3, #-0]
    1168:	02000000 	andeq	r0, r0, #0
    116c:	0d870502 	cfstr32eq	mvfx0, [r7, #8]
    1170:	04040000 	streq	r0, [r4], #-0
    1174:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1178:	08010200 	stmdaeq	r1, {r9}
    117c:	00000fee 	andeq	r0, r0, lr, ror #31
    1180:	88070202 	stmdahi	r7, {r1, r9}
    1184:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    1188:	000006c6 	andeq	r0, r0, r6, asr #13
    118c:	5e070908 	vmlapl.f16	s0, s14, s16	; <UNPREDICTABLE>
    1190:	03000000 	movweq	r0, #0
    1194:	0000004d 	andeq	r0, r0, sp, asr #32
    1198:	2a070402 	bcs	1c21a8 <__bss_end+0x1b8648>
    119c:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    11a0:	000012c7 	andeq	r1, r0, r7, asr #5
    11a4:	08060208 	stmdaeq	r6, {r3, r9}
    11a8:	0000008b 	andeq	r0, r0, fp, lsl #1
    11ac:	00307207 	eorseq	r7, r0, r7, lsl #4
    11b0:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    11b4:	00000000 	andeq	r0, r0, r0
    11b8:	00317207 	eorseq	r7, r1, r7, lsl #4
    11bc:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    11c0:	04000000 	streq	r0, [r0], #-0
    11c4:	15190800 	ldrne	r0, [r9, #-2048]	; 0xfffff800
    11c8:	04050000 	streq	r0, [r5], #-0
    11cc:	00000038 	andeq	r0, r0, r8, lsr r0
    11d0:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    11d4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    11d8:	00004b4f 	andeq	r4, r0, pc, asr #22
    11dc:	0013530a 	andseq	r5, r3, sl, lsl #6
    11e0:	08000100 	stmdaeq	r0, {r8}
    11e4:	00000e3e 	andeq	r0, r0, lr, lsr lr
    11e8:	00380405 	eorseq	r0, r8, r5, lsl #8
    11ec:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    11f0:	0000e00c 	andeq	lr, r0, ip
    11f4:	06be0a00 	ldrteq	r0, [lr], r0, lsl #20
    11f8:	0a000000 	beq	1200 <shift+0x1200>
    11fc:	000008e7 	andeq	r0, r0, r7, ror #17
    1200:	0e600a01 	vmuleq.f32	s1, s0, s2
    1204:	0a020000 	beq	8120c <__bss_end+0x776ac>
    1208:	0000100a 	andeq	r1, r0, sl
    120c:	08d20a03 	ldmeq	r2, {r0, r1, r9, fp}^
    1210:	0a040000 	beq	101218 <__bss_end+0xf76b8>
    1214:	00000d5f 	andeq	r0, r0, pc, asr sp
    1218:	1e080005 	cdpne	0, 0, cr0, cr8, cr5, {0}
    121c:	0500000e 	streq	r0, [r0, #-14]
    1220:	00003804 	andeq	r3, r0, r4, lsl #16
    1224:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 122c <shift+0x122c>
    1228:	0000011d 	andeq	r0, r0, sp, lsl r1
    122c:	0008290a 	andeq	r2, r8, sl, lsl #18
    1230:	470a0000 	strmi	r0, [sl, -r0]
    1234:	0100000f 	tsteq	r0, pc
    1238:	0012450a 	andseq	r4, r2, sl, lsl #10
    123c:	5e0a0200 	cdppl	2, 0, cr0, cr10, cr0, {0}
    1240:	0300000c 	movweq	r0, #12
    1244:	0008e10a 	andeq	lr, r8, sl, lsl #2
    1248:	d00a0400 	andle	r0, sl, r0, lsl #8
    124c:	05000009 	streq	r0, [r0, #-9]
    1250:	00072b0a 	andeq	r2, r7, sl, lsl #22
    1254:	08000600 	stmdaeq	r0, {r9, sl}
    1258:	00000710 	andeq	r0, r0, r0, lsl r7
    125c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1260:	66020000 	strvs	r0, [r2], -r0
    1264:	0001480c 	andeq	r4, r1, ip, lsl #16
    1268:	0fe30a00 	svceq	0x00e30a00
    126c:	0a000000 	beq	1274 <shift+0x1274>
    1270:	00000592 	muleq	r0, r2, r5
    1274:	0e840a01 	vdiveq.f32	s0, s8, s2
    1278:	0a020000 	beq	81280 <__bss_end+0x77720>
    127c:	00000d6f 	andeq	r0, r0, pc, ror #26
    1280:	c50b0003 	strgt	r0, [fp, #-3]
    1284:	0300000b 	movweq	r0, #11
    1288:	00591405 	subseq	r1, r9, r5, lsl #8
    128c:	03050000 	movweq	r0, #20480	; 0x5000
    1290:	00009af4 	strdeq	r9, [r0], -r4
    1294:	000f4c0b 	andeq	r4, pc, fp, lsl #24
    1298:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    129c:	00000059 	andeq	r0, r0, r9, asr r0
    12a0:	9af80305 	bls	ffe01ebc <__bss_end+0xffdf835c>
    12a4:	3b0b0000 	blcc	2c12ac <__bss_end+0x2b774c>
    12a8:	0400000a 	streq	r0, [r0], #-10
    12ac:	00591a07 	subseq	r1, r9, r7, lsl #20
    12b0:	03050000 	movweq	r0, #20480	; 0x5000
    12b4:	00009afc 	strdeq	r9, [r0], -ip
    12b8:	000d980b 	andeq	r9, sp, fp, lsl #16
    12bc:	1a090400 	bne	2422c4 <__bss_end+0x238764>
    12c0:	00000059 	andeq	r0, r0, r9, asr r0
    12c4:	9b000305 	blls	1ee0 <shift+0x1ee0>
    12c8:	fe0b0000 	cdp2	0, 0, cr0, cr11, cr0, {0}
    12cc:	04000009 	streq	r0, [r0], #-9
    12d0:	00591a0b 	subseq	r1, r9, fp, lsl #20
    12d4:	03050000 	movweq	r0, #20480	; 0x5000
    12d8:	00009b04 	andeq	r9, r0, r4, lsl #22
    12dc:	000d2a0b 	andeq	r2, sp, fp, lsl #20
    12e0:	1a0d0400 	bne	3422e8 <__bss_end+0x338788>
    12e4:	00000059 	andeq	r0, r0, r9, asr r0
    12e8:	9b080305 	blls	201f04 <__bss_end+0x1f83a4>
    12ec:	9e0b0000 	cdpls	0, 0, cr0, cr11, cr0, {0}
    12f0:	04000006 	streq	r0, [r0], #-6
    12f4:	00591a0f 	subseq	r1, r9, pc, lsl #20
    12f8:	03050000 	movweq	r0, #20480	; 0x5000
    12fc:	00009b0c 	andeq	r9, r0, ip, lsl #22
    1300:	000c4408 	andeq	r4, ip, r8, lsl #8
    1304:	38040500 	stmdacc	r4, {r8, sl}
    1308:	04000000 	streq	r0, [r0], #-0
    130c:	01eb0c1b 	mvneq	r0, fp, lsl ip
    1310:	410a0000 	mrsmi	r0, (UNDEF: 10)
    1314:	00000006 	andeq	r0, r0, r6
    1318:	0010760a 	andseq	r7, r0, sl, lsl #12
    131c:	400a0100 	andmi	r0, sl, r0, lsl #2
    1320:	02000012 	andeq	r0, r0, #18
    1324:	04190c00 	ldreq	r0, [r9], #-3072	; 0xfffff400
    1328:	e10d0000 	mrs	r0, (UNDEF: 13)
    132c:	90000004 	andls	r0, r0, r4
    1330:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    1334:	06000003 	streq	r0, [r0], -r3
    1338:	0000061d 	andeq	r0, r0, sp, lsl r6
    133c:	10670424 	rsbne	r0, r7, r4, lsr #8
    1340:	00000278 	andeq	r0, r0, r8, ror r2
    1344:	00219a0e 	eoreq	r9, r1, lr, lsl #20
    1348:	12690400 	rsbne	r0, r9, #0, 8
    134c:	0000035e 	andeq	r0, r0, lr, asr r3
    1350:	082e0e00 	stmdaeq	lr!, {r9, sl, fp}
    1354:	6b040000 	blvs	10135c <__bss_end+0xf77fc>
    1358:	00036e12 	andeq	r6, r3, r2, lsl lr
    135c:	360e1000 	strcc	r1, [lr], -r0
    1360:	04000006 	streq	r0, [r0], #-6
    1364:	004d166d 	subeq	r1, sp, sp, ror #12
    1368:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    136c:	00000d68 	andeq	r0, r0, r8, ror #26
    1370:	751c7004 	ldrvc	r7, [ip, #-4]
    1374:	18000003 	stmdane	r0, {r0, r1}
    1378:	0011c00e 	andseq	ip, r1, lr
    137c:	1c720400 	cfldrdne	mvd0, [r2], #-0
    1380:	00000375 	andeq	r0, r0, r5, ror r3
    1384:	04dc0e1c 	ldrbeq	r0, [ip], #3612	; 0xe1c
    1388:	75040000 	strvc	r0, [r4, #-0]
    138c:	0003751c 	andeq	r7, r3, ip, lsl r5
    1390:	0d0f2000 	stceq	0, cr2, [pc, #-0]	; 1398 <shift+0x1398>
    1394:	0400000e 	streq	r0, [r0], #-14
    1398:	11131c77 	tstne	r3, r7, ror ip
    139c:	03750000 	cmneq	r5, #0
    13a0:	026c0000 	rsbeq	r0, ip, #0
    13a4:	75100000 	ldrvc	r0, [r0, #-0]
    13a8:	11000003 	tstne	r0, r3
    13ac:	0000037b 	andeq	r0, r0, fp, ror r3
    13b0:	35060000 	strcc	r0, [r6, #-0]
    13b4:	18000012 	stmdane	r0, {r1, r4}
    13b8:	ad107b04 	vldrge	d7, [r0, #-16]
    13bc:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    13c0:	0000219a 	muleq	r0, sl, r1
    13c4:	5e127e04 	cdppl	14, 1, cr7, cr2, cr4, {0}
    13c8:	00000003 	andeq	r0, r0, r3
    13cc:	00053e0e 	andeq	r3, r5, lr, lsl #28
    13d0:	19800400 	stmibne	r0, {sl}
    13d4:	0000037b 	andeq	r0, r0, fp, ror r3
    13d8:	09d70e10 	ldmibeq	r7, {r4, r9, sl, fp}^
    13dc:	82040000 	andhi	r0, r4, #0
    13e0:	00038621 	andeq	r8, r3, r1, lsr #12
    13e4:	03001400 	movweq	r1, #1024	; 0x400
    13e8:	00000278 	andeq	r0, r0, r8, ror r2
    13ec:	00048f12 	andeq	r8, r4, r2, lsl pc
    13f0:	21860400 	orrcs	r0, r6, r0, lsl #8
    13f4:	0000038c 	andeq	r0, r0, ip, lsl #7
    13f8:	00085812 	andeq	r5, r8, r2, lsl r8
    13fc:	1f880400 	svcne	0x00880400
    1400:	00000059 	andeq	r0, r0, r9, asr r0
    1404:	000daa0e 	andeq	sl, sp, lr, lsl #20
    1408:	178b0400 	strne	r0, [fp, r0, lsl #8]
    140c:	000001fd 	strdeq	r0, [r0], -sp
    1410:	07900e00 	ldreq	r0, [r0, r0, lsl #28]
    1414:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    1418:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    141c:	490e2400 	stmdbmi	lr, {sl, sp}
    1420:	0400000b 	streq	r0, [r0], #-11
    1424:	01fd178f 	mvnseq	r1, pc, lsl #15
    1428:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    142c:	00000958 	andeq	r0, r0, r8, asr r9
    1430:	fd179004 	ldc2	0, cr9, [r7, #-16]
    1434:	6c000001 	stcvs	0, cr0, [r0], {1}
    1438:	0004e113 	andeq	lr, r4, r3, lsl r1
    143c:	09930400 	ldmibeq	r3, {sl}
    1440:	00000ced 	andeq	r0, r0, sp, ror #25
    1444:	00000397 	muleq	r0, r7, r3
    1448:	00031701 	andeq	r1, r3, r1, lsl #14
    144c:	00031d00 	andeq	r1, r3, r0, lsl #26
    1450:	03971000 	orrseq	r1, r7, #0
    1454:	14000000 	strne	r0, [r0], #-0
    1458:	00000e02 	andeq	r0, r0, r2, lsl #28
    145c:	1f0e9604 	svcne	0x000e9604
    1460:	01000005 	tsteq	r0, r5
    1464:	00000332 	andeq	r0, r0, r2, lsr r3
    1468:	00000338 	andeq	r0, r0, r8, lsr r3
    146c:	00039710 	andeq	r9, r3, r0, lsl r7
    1470:	29150000 	ldmdbcs	r5, {}	; <UNPREDICTABLE>
    1474:	04000008 	streq	r0, [r0], #-8
    1478:	0c291099 	stceq	0, cr1, [r9], #-612	; 0xfffffd9c
    147c:	039d0000 	orrseq	r0, sp, #0
    1480:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1484:	10000003 	andne	r0, r0, r3
    1488:	00000397 	muleq	r0, r7, r3
    148c:	00037b11 	andeq	r7, r3, r1, lsl fp
    1490:	01c61100 	biceq	r1, r6, r0, lsl #2
    1494:	00000000 	andeq	r0, r0, r0
    1498:	00002516 	andeq	r2, r0, r6, lsl r5
    149c:	00036e00 	andeq	r6, r3, r0, lsl #28
    14a0:	005e1700 	subseq	r1, lr, r0, lsl #14
    14a4:	000f0000 	andeq	r0, pc, r0
    14a8:	e4020102 	str	r0, [r2], #-258	; 0xfffffefe
    14ac:	1800000a 	stmdane	r0, {r1, r3}
    14b0:	0001fd04 	andeq	pc, r1, r4, lsl #26
    14b4:	2c041800 	stccs	8, cr1, [r4], {-0}
    14b8:	0c000000 	stceq	0, cr0, [r0], {-0}
    14bc:	000010e8 	andeq	r1, r0, r8, ror #1
    14c0:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    14c4:	ad160000 	ldcge	0, cr0, [r6, #-0]
    14c8:	97000002 	strls	r0, [r0, -r2]
    14cc:	19000003 	stmdbne	r0, {r0, r1}
    14d0:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    14d4:	18000001 	stmdane	r0, {r0}
    14d8:	0001eb04 	andeq	lr, r1, r4, lsl #22
    14dc:	0df61a00 			; <UNDEFINED> instruction: 0x0df61a00
    14e0:	9c040000 	stcls	0, cr0, [r4], {-0}
    14e4:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    14e8:	06570b00 	ldrbeq	r0, [r7], -r0, lsl #22
    14ec:	04050000 	streq	r0, [r5], #-0
    14f0:	00005914 	andeq	r5, r0, r4, lsl r9
    14f4:	10030500 	andne	r0, r3, r0, lsl #10
    14f8:	0b00009b 	bleq	176c <shift+0x176c>
    14fc:	00000e66 	andeq	r0, r0, r6, ror #28
    1500:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    1504:	05000000 	streq	r0, [r0, #-0]
    1508:	009b1403 	addseq	r1, fp, r3, lsl #8
    150c:	050c0b00 	streq	r0, [ip, #-2816]	; 0xfffff500
    1510:	0a050000 	beq	141518 <__bss_end+0x1379b8>
    1514:	00005914 	andeq	r5, r0, r4, lsl r9
    1518:	18030500 	stmdane	r3, {r8, sl}
    151c:	0800009b 	stmdaeq	r0, {r0, r1, r3, r4, r7}
    1520:	00000730 	andeq	r0, r0, r0, lsr r7
    1524:	00380405 	eorseq	r0, r8, r5, lsl #8
    1528:	0d050000 	stceq	0, cr0, [r5, #-0]
    152c:	00041c0c 	andeq	r1, r4, ip, lsl #24
    1530:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    1534:	0a000077 	beq	1718 <shift+0x1718>
    1538:	000008f1 	strdeq	r0, [r0], -r1
    153c:	05040a01 	streq	r0, [r4, #-2561]	; 0xfffff5ff
    1540:	0a020000 	beq	81548 <__bss_end+0x779e8>
    1544:	0000074e 	andeq	r0, r0, lr, asr #14
    1548:	0ffc0a03 	svceq	0x00fc0a03
    154c:	0a040000 	beq	101554 <__bss_end+0xf79f4>
    1550:	000004d5 	ldrdeq	r0, [r0], -r5
    1554:	70060005 	andvc	r0, r6, r5
    1558:	10000006 	andne	r0, r0, r6
    155c:	5b081b05 	blpl	208178 <__bss_end+0x1fe618>
    1560:	07000004 	streq	r0, [r0, -r4]
    1564:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    1568:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    156c:	07000000 	streq	r0, [r0, -r0]
    1570:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    1574:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    1578:	07040000 	streq	r0, [r4, -r0]
    157c:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1580:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    1584:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1588:	00000e18 	andeq	r0, r0, r8, lsl lr
    158c:	5b132005 	blpl	4c95a8 <__bss_end+0x4bfa48>
    1590:	0c000004 	stceq	0, cr0, [r0], {4}
    1594:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1598:	00001e25 	andeq	r1, r0, r5, lsr #28
    159c:	0008c506 	andeq	ip, r8, r6, lsl #10
    15a0:	28057000 	stmdacs	r5, {ip, sp, lr}
    15a4:	0004f208 	andeq	pc, r4, r8, lsl #4
    15a8:	07d80e00 	ldrbeq	r0, [r8, r0, lsl #28]
    15ac:	2a050000 	bcs	1415b4 <__bss_end+0x137a54>
    15b0:	00041c12 	andeq	r1, r4, r2, lsl ip
    15b4:	70070000 	andvc	r0, r7, r0
    15b8:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    15bc:	005e122b 	subseq	r1, lr, fp, lsr #4
    15c0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    15c4:	00001b76 	andeq	r1, r0, r6, ror fp
    15c8:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    15cc:	14000003 	strne	r0, [r0], #-3
    15d0:	000fd50e 	andeq	sp, pc, lr, lsl #10
    15d4:	122d0500 	eorne	r0, sp, #0, 10
    15d8:	0000005e 	andeq	r0, r0, lr, asr r0
    15dc:	03a90e18 			; <UNDEFINED> instruction: 0x03a90e18
    15e0:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    15e4:	00005e12 	andeq	r5, r0, r2, lsl lr
    15e8:	530e1c00 	movwpl	r1, #60416	; 0xec00
    15ec:	0500000e 	streq	r0, [r0, #-14]
    15f0:	04f20c2f 	ldrbteq	r0, [r2], #3119	; 0xc2f
    15f4:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    15f8:	00000485 	andeq	r0, r0, r5, lsl #9
    15fc:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    1600:	60000000 	andvs	r0, r0, r0
    1604:	000aa30e 	andeq	sl, sl, lr, lsl #6
    1608:	0e310500 	cfabs32eq	mvfx0, mvfx1
    160c:	0000004d 	andeq	r0, r0, sp, asr #32
    1610:	0cd20e64 	ldcleq	14, cr0, [r2], {100}	; 0x64
    1614:	33050000 	movwcc	r0, #20480	; 0x5000
    1618:	00004d0e 	andeq	r4, r0, lr, lsl #26
    161c:	c90e6800 	stmdbgt	lr, {fp, sp, lr}
    1620:	0500000c 	streq	r0, [r0, #-12]
    1624:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1628:	006c0000 	rsbeq	r0, ip, r0
    162c:	00039d16 	andeq	r9, r3, r6, lsl sp
    1630:	00050200 	andeq	r0, r5, r0, lsl #4
    1634:	005e1700 	subseq	r1, lr, r0, lsl #14
    1638:	000f0000 	andeq	r0, pc, r0
    163c:	0004f50b 	andeq	pc, r4, fp, lsl #10
    1640:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    1644:	00000059 	andeq	r0, r0, r9, asr r0
    1648:	9b1c0305 	blls	702264 <__bss_end+0x6f8704>
    164c:	8e080000 	cdphi	0, 0, cr0, cr8, cr0, {0}
    1650:	0500000a 	streq	r0, [r0, #-10]
    1654:	00003804 	andeq	r3, r0, r4, lsl #16
    1658:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    165c:	00000533 	andeq	r0, r0, r3, lsr r5
    1660:	0012540a 	andseq	r5, r2, sl, lsl #8
    1664:	ab0a0000 	blge	28166c <__bss_end+0x277b0c>
    1668:	01000010 	tsteq	r0, r0, lsl r0
    166c:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1670:	57080000 	strpl	r0, [r8, -r0]
    1674:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1678:	00003804 	andeq	r3, r0, r4, lsl #16
    167c:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1680:	00000557 	andeq	r0, r0, r7, asr r5
    1684:	0012ed0a 	andseq	lr, r2, sl, lsl #26
    1688:	eb0a0000 	bl	281690 <__bss_end+0x277b30>
    168c:	01000014 	tsteq	r0, r4, lsl r0
    1690:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    1694:	bd060000 	stclt	0, cr0, [r6, #-0]
    1698:	0c000007 	stceq	0, cr0, [r0], {7}
    169c:	91081b06 	tstls	r8, r6, lsl #22
    16a0:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    16a4:	0000059d 	muleq	r0, sp, r5
    16a8:	91191d06 	tstls	r9, r6, lsl #26
    16ac:	00000005 	andeq	r0, r0, r5
    16b0:	0004dc0e 	andeq	sp, r4, lr, lsl #24
    16b4:	191e0600 	ldmdbne	lr, {r9, sl}
    16b8:	00000591 	muleq	r0, r1, r5
    16bc:	0abe0e04 	beq	fef84ed4 <__bss_end+0xfef7b374>
    16c0:	1f060000 	svcne	0x00060000
    16c4:	00059713 	andeq	r9, r5, r3, lsl r7
    16c8:	18000800 	stmdane	r0, {fp}
    16cc:	00055c04 	andeq	r5, r5, r4, lsl #24
    16d0:	62041800 	andvs	r1, r4, #0, 16
    16d4:	0d000004 	stceq	0, cr0, [r0, #-16]
    16d8:	00000db9 			; <UNDEFINED> instruction: 0x00000db9
    16dc:	07220614 			; <UNDEFINED> instruction: 0x07220614
    16e0:	0000081f 	andeq	r0, r0, pc, lsl r8
    16e4:	000bd30e 	andeq	sp, fp, lr, lsl #6
    16e8:	12260600 	eorne	r0, r6, #0, 12
    16ec:	0000004d 	andeq	r0, r0, sp, asr #32
    16f0:	0b660e00 	bleq	1984ef8 <__bss_end+0x197b398>
    16f4:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    16f8:	0005911d 	andeq	r9, r5, sp, lsl r1
    16fc:	560e0400 	strpl	r0, [lr], -r0, lsl #8
    1700:	06000007 	streq	r0, [r0], -r7
    1704:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    1708:	1b080000 	blne	201710 <__bss_end+0x1f7bb0>
    170c:	00000c54 	andeq	r0, r0, r4, asr ip
    1710:	9a0e2f06 	bls	38d330 <__bss_end+0x3837d0>
    1714:	e5000007 	str	r0, [r0, #-7]
    1718:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    171c:	10000005 	andne	r0, r0, r5
    1720:	00000824 	andeq	r0, r0, r4, lsr #16
    1724:	00059111 	andeq	r9, r5, r1, lsl r1
    1728:	fa1c0000 	blx	701730 <__bss_end+0x6f7bd0>
    172c:	06000008 	streq	r0, [r0], -r8
    1730:	089c0e31 	ldmeq	ip, {r0, r4, r5, r9, sl, fp}
    1734:	036e0000 	cmneq	lr, #0
    1738:	06080000 	streq	r0, [r8], -r0
    173c:	06130000 	ldreq	r0, [r3], -r0
    1740:	24100000 	ldrcs	r0, [r0], #-0
    1744:	11000008 	tstne	r0, r8
    1748:	00000597 	muleq	r0, r7, r5
    174c:	10571300 	subsne	r1, r7, r0, lsl #6
    1750:	35060000 	strcc	r0, [r6, #-0]
    1754:	000a691d 	andeq	r6, sl, sp, lsl r9
    1758:	00059100 	andeq	r9, r5, r0, lsl #2
    175c:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    1760:	06320000 	ldrteq	r0, [r2], -r0
    1764:	24100000 	ldrcs	r0, [r0], #-0
    1768:	00000008 	andeq	r0, r0, r8
    176c:	00074113 	andeq	r4, r7, r3, lsl r1
    1770:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1774:	00000c64 	andeq	r0, r0, r4, ror #24
    1778:	00000591 	muleq	r0, r1, r5
    177c:	00064b02 	andeq	r4, r6, r2, lsl #22
    1780:	00065100 	andeq	r5, r6, r0, lsl #2
    1784:	08241000 	stmdaeq	r4!, {ip}
    1788:	1d000000 	stcne	0, cr0, [r0, #-0]
    178c:	00000b79 	andeq	r0, r0, r9, ror fp
    1790:	3d313906 			; <UNDEFINED> instruction: 0x3d313906
    1794:	0c000008 	stceq	0, cr0, [r0], {8}
    1798:	0db91302 	ldceq	3, cr1, [r9, #8]!
    179c:	3c060000 	stccc	0, cr0, [r6], {-0}
    17a0:	00090909 	andeq	r0, r9, r9, lsl #18
    17a4:	00082400 	andeq	r2, r8, r0, lsl #8
    17a8:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    17ac:	067e0000 	ldrbteq	r0, [lr], -r0
    17b0:	24100000 	ldrcs	r0, [r0], #-0
    17b4:	00000008 	andeq	r0, r0, r8
    17b8:	0007ea13 	andeq	lr, r7, r3, lsl sl
    17bc:	123f0600 	eorsne	r0, pc, #0, 12
    17c0:	00000567 	andeq	r0, r0, r7, ror #10
    17c4:	0000004d 	andeq	r0, r0, sp, asr #32
    17c8:	00069701 	andeq	r9, r6, r1, lsl #14
    17cc:	0006ac00 	andeq	sl, r6, r0, lsl #24
    17d0:	08241000 	stmdaeq	r4!, {ip}
    17d4:	46110000 	ldrmi	r0, [r1], -r0
    17d8:	11000008 	tstne	r0, r8
    17dc:	0000005e 	andeq	r0, r0, lr, asr r0
    17e0:	00036e11 	andeq	r6, r3, r1, lsl lr
    17e4:	81140000 	tsthi	r4, r0
    17e8:	06000010 			; <UNDEFINED> instruction: 0x06000010
    17ec:	067d0e42 	ldrbteq	r0, [sp], -r2, asr #28
    17f0:	c1010000 	mrsgt	r0, (UNDEF: 1)
    17f4:	c7000006 	strgt	r0, [r0, -r6]
    17f8:	10000006 	andne	r0, r0, r6
    17fc:	00000824 	andeq	r0, r0, r4, lsr #16
    1800:	05491300 	strbeq	r1, [r9, #-768]	; 0xfffffd00
    1804:	45060000 	strmi	r0, [r6, #-0]
    1808:	0005ef17 	andeq	lr, r5, r7, lsl pc
    180c:	00059700 	andeq	r9, r5, r0, lsl #14
    1810:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    1814:	06e60000 	strbteq	r0, [r6], r0
    1818:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    181c:	00000008 	andeq	r0, r0, r8
    1820:	000e7113 	andeq	r7, lr, r3, lsl r1
    1824:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    1828:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
    182c:	00000597 	muleq	r0, r7, r5
    1830:	0006ff01 	andeq	pc, r6, r1, lsl #30
    1834:	00070a00 	andeq	r0, r7, r0, lsl #20
    1838:	084c1000 	stmdaeq	ip, {ip}^
    183c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1840:	00000000 	andeq	r0, r0, r0
    1844:	0006a814 	andeq	sl, r6, r4, lsl r8
    1848:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    184c:	00000b87 	andeq	r0, r0, r7, lsl #23
    1850:	00071f01 	andeq	r1, r7, r1, lsl #30
    1854:	00072500 	andeq	r2, r7, r0, lsl #10
    1858:	08241000 	stmdaeq	r4!, {ip}
    185c:	13000000 	movwne	r0, #0
    1860:	000008fa 	strdeq	r0, [r0], -sl
    1864:	020e4d06 	andeq	r4, lr, #384	; 0x180
    1868:	6e00000d 	cdpvs	0, 0, cr0, cr0, cr13, {0}
    186c:	01000003 	tsteq	r0, r3
    1870:	0000073e 	andeq	r0, r0, lr, lsr r7
    1874:	00000749 	andeq	r0, r0, r9, asr #14
    1878:	00082410 	andeq	r2, r8, r0, lsl r4
    187c:	004d1100 	subeq	r1, sp, r0, lsl #2
    1880:	13000000 	movwne	r0, #0
    1884:	000004c1 	andeq	r0, r0, r1, asr #9
    1888:	ec125006 	ldc	0, cr5, [r2], {6}
    188c:	4d000003 	stcmi	0, cr0, [r0, #-12]
    1890:	01000000 	mrseq	r0, (UNDEF: 0)
    1894:	00000762 	andeq	r0, r0, r2, ror #14
    1898:	0000076d 	andeq	r0, r0, sp, ror #14
    189c:	00082410 	andeq	r2, r8, r0, lsl r4
    18a0:	039d1100 	orrseq	r1, sp, #0, 2
    18a4:	13000000 	movwne	r0, #0
    18a8:	0000041f 	andeq	r0, r0, pc, lsl r4
    18ac:	b60e5306 	strlt	r5, [lr], -r6, lsl #6
    18b0:	6e000010 	mcrvs	0, 0, r0, cr0, cr0, {0}
    18b4:	01000003 	tsteq	r0, r3
    18b8:	00000786 	andeq	r0, r0, r6, lsl #15
    18bc:	00000791 	muleq	r0, r1, r7
    18c0:	00082410 	andeq	r2, r8, r0, lsl r4
    18c4:	004d1100 	subeq	r1, sp, r0, lsl #2
    18c8:	14000000 	strne	r0, [r0], #-0
    18cc:	0000049b 	muleq	r0, fp, r4
    18d0:	580e5606 	stmdapl	lr, {r1, r2, r9, sl, ip, lr}
    18d4:	0100000f 	tsteq	r0, pc
    18d8:	000007a6 	andeq	r0, r0, r6, lsr #15
    18dc:	000007c5 	andeq	r0, r0, r5, asr #15
    18e0:	00082410 	andeq	r2, r8, r0, lsl r4
    18e4:	00a91100 	adceq	r1, r9, r0, lsl #2
    18e8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18ec:	11000000 	mrsne	r0, (UNDEF: 0)
    18f0:	0000004d 	andeq	r0, r0, sp, asr #32
    18f4:	00004d11 	andeq	r4, r0, r1, lsl sp
    18f8:	08521100 	ldmdaeq	r2, {r8, ip}^
    18fc:	14000000 	strne	r0, [r0], #-0
    1900:	00001143 	andeq	r1, r0, r3, asr #2
    1904:	7b0e5806 	blvc	397924 <__bss_end+0x38ddc4>
    1908:	01000012 	tsteq	r0, r2, lsl r0
    190c:	000007da 	ldrdeq	r0, [r0], -sl
    1910:	000007f9 	strdeq	r0, [r0], -r9
    1914:	00082410 	andeq	r2, r8, r0, lsl r4
    1918:	00e01100 	rsceq	r1, r0, r0, lsl #2
    191c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1920:	11000000 	mrsne	r0, (UNDEF: 0)
    1924:	0000004d 	andeq	r0, r0, sp, asr #32
    1928:	00004d11 	andeq	r4, r0, r1, lsl sp
    192c:	08521100 	ldmdaeq	r2, {r8, ip}^
    1930:	15000000 	strne	r0, [r0, #-0]
    1934:	000004ae 	andeq	r0, r0, lr, lsr #9
    1938:	e90e5b06 	stmdb	lr, {r1, r2, r8, r9, fp, ip, lr}
    193c:	6e00000a 	cdpvs	0, 0, cr0, cr0, cr10, {0}
    1940:	01000003 	tsteq	r0, r3
    1944:	0000080e 	andeq	r0, r0, lr, lsl #16
    1948:	00082410 	andeq	r2, r8, r0, lsl r4
    194c:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    1950:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    1954:	00000008 	andeq	r0, r0, r8
    1958:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    195c:	04180000 	ldreq	r0, [r8], #-0
    1960:	0000059d 	muleq	r0, sp, r5
    1964:	0005911e 	andeq	r9, r5, lr, lsl r1
    1968:	00083700 	andeq	r3, r8, r0, lsl #14
    196c:	00083d00 	andeq	r3, r8, r0, lsl #26
    1970:	08241000 	stmdaeq	r4!, {ip}
    1974:	1f000000 	svcne	0x00000000
    1978:	0000059d 	muleq	r0, sp, r5
    197c:	0000082a 	andeq	r0, r0, sl, lsr #16
    1980:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1984:	04180000 	ldreq	r0, [r8], #-0
    1988:	0000081f 	andeq	r0, r0, pc, lsl r8
    198c:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1990:	04210000 	strteq	r0, [r1], #-0
    1994:	0011a01a 	andseq	sl, r1, sl, lsl r0
    1998:	195e0600 	ldmdbne	lr, {r9, sl}^
    199c:	0000059d 	muleq	r0, sp, r5
    19a0:	00124b0b 	andseq	r4, r2, fp, lsl #22
    19a4:	11040700 	tstne	r4, r0, lsl #14
    19a8:	0000087f 	andeq	r0, r0, pc, ror r8
    19ac:	9b200305 	blls	8025c8 <__bss_end+0x7f8a68>
    19b0:	04020000 	streq	r0, [r2], #-0
    19b4:	001bf404 	andseq	pc, fp, r4, lsl #8
    19b8:	08780300 	ldmdaeq	r8!, {r8, r9}^
    19bc:	2c160000 	ldccs	0, cr0, [r6], {-0}
    19c0:	94000000 	strls	r0, [r0], #-0
    19c4:	17000008 	strne	r0, [r0, -r8]
    19c8:	0000005e 	andeq	r0, r0, lr, asr r0
    19cc:	84030009 	strhi	r0, [r3], #-9
    19d0:	22000008 	andcs	r0, r0, #8
    19d4:	0000139f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
    19d8:	940ca401 	strls	sl, [ip], #-1025	; 0xfffffbff
    19dc:	05000008 	streq	r0, [r0, #-8]
    19e0:	009b2403 	addseq	r2, fp, r3, lsl #8
    19e4:	0e392300 	cdpeq	3, 3, cr2, cr9, cr0, {0}
    19e8:	a6010000 	strge	r0, [r1], -r0
    19ec:	00144b0a 	andseq	r4, r4, sl, lsl #22
    19f0:	00004d00 	andeq	r4, r0, r0, lsl #26
    19f4:	0087c400 	addeq	ip, r7, r0, lsl #8
    19f8:	0000b000 	andeq	fp, r0, r0
    19fc:	099c0100 	ldmibeq	ip, {r8}
    1a00:	24000009 	strcs	r0, [r0], #-9
    1a04:	0000219a 	muleq	r0, sl, r1
    1a08:	7b1ba601 	blvc	6eb214 <__bss_end+0x6e16b4>
    1a0c:	03000003 	movweq	r0, #3
    1a10:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 1a18 <shift+0x1a18>
    1a14:	000014d7 	ldrdeq	r1, [r0], -r7
    1a18:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    1a1c:	03000000 	movweq	r0, #0
    1a20:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    1a24:	00001433 	andeq	r1, r0, r3, lsr r4
    1a28:	090aa801 	stmdbeq	sl, {r0, fp, sp, pc}
    1a2c:	03000009 	movweq	r0, #9
    1a30:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1a34:	00001301 	andeq	r1, r0, r1, lsl #6
    1a38:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    1a3c:	02000000 	andeq	r0, r0, #0
    1a40:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1a44:	00000025 	andeq	r0, r0, r5, lsr #32
    1a48:	00000919 	andeq	r0, r0, r9, lsl r9
    1a4c:	00005e17 	andeq	r5, r0, r7, lsl lr
    1a50:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1a54:	000014b6 			; <UNDEFINED> instruction: 0x000014b6
    1a58:	f90a9801 			; <UNDEFINED> instruction: 0xf90a9801
    1a5c:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1a60:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
    1a64:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1a68:	01000000 	mrseq	r0, (UNDEF: 0)
    1a6c:	0009569c 	muleq	r9, ip, r6
    1a70:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1a74:	9a010071 	bls	41c40 <__bss_end+0x380e0>
    1a78:	00055720 	andeq	r5, r5, r0, lsr #14
    1a7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a80:	00144022 	andseq	r4, r4, r2, lsr #32
    1a84:	0e9b0100 	fmleqe	f0, f3, f0
    1a88:	0000004d 	andeq	r0, r0, sp, asr #32
    1a8c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1a90:	0013ca27 	andseq	ip, r3, r7, lsr #20
    1a94:	068f0100 	streq	r0, [pc], r0, lsl #2
    1a98:	0000131d 	andeq	r1, r0, sp, lsl r3
    1a9c:	0000874c 	andeq	r8, r0, ip, asr #14
    1aa0:	0000003c 	andeq	r0, r0, ip, lsr r0
    1aa4:	098f9c01 	stmibeq	pc, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
    1aa8:	8b240000 	blhi	901ab0 <__bss_end+0x8f7f50>
    1aac:	01000013 	tsteq	r0, r3, lsl r0
    1ab0:	004d218f 	subeq	r2, sp, pc, lsl #3
    1ab4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ab8:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1abc:	91010071 	tstls	r1, r1, ror r0
    1ac0:	00055720 	andeq	r5, r5, r0, lsr #14
    1ac4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ac8:	146c2500 	strbtne	r2, [ip], #-1280	; 0xfffffb00
    1acc:	83010000 	movwhi	r0, #4096	; 0x1000
    1ad0:	0013b00a 	andseq	fp, r3, sl
    1ad4:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ad8:	00871000 	addeq	r1, r7, r0
    1adc:	00003c00 	andeq	r3, r0, r0, lsl #24
    1ae0:	cc9c0100 	ldfgts	f0, [ip], {0}
    1ae4:	26000009 	strcs	r0, [r0], -r9
    1ae8:	00716572 	rsbseq	r6, r1, r2, ror r5
    1aec:	33208501 			; <UNDEFINED> instruction: 0x33208501
    1af0:	02000005 	andeq	r0, r0, #5
    1af4:	fa227491 	blx	89ed40 <__bss_end+0x8951e0>
    1af8:	01000012 	tsteq	r0, r2, lsl r0
    1afc:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1b00:	91020000 	mrsls	r0, (UNDEF: 2)
    1b04:	86250070 			; <UNDEFINED> instruction: 0x86250070
    1b08:	01000015 	tsteq	r0, r5, lsl r0
    1b0c:	13610a77 	cmnne	r1, #487424	; 0x77000
    1b10:	004d0000 	subeq	r0, sp, r0
    1b14:	86d40000 	ldrbhi	r0, [r4], r0
    1b18:	003c0000 	eorseq	r0, ip, r0
    1b1c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b20:	00000a09 	andeq	r0, r0, r9, lsl #20
    1b24:	71657226 	cmnvc	r5, r6, lsr #4
    1b28:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1b2c:	00000533 	andeq	r0, r0, r3, lsr r5
    1b30:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1b34:	000012fa 	strdeq	r1, [r0], -sl
    1b38:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    1b3c:	02000000 	andeq	r0, r0, #0
    1b40:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1b44:	000013c4 	andeq	r1, r0, r4, asr #7
    1b48:	e0066b01 	and	r6, r6, r1, lsl #22
    1b4c:	6e000014 	mcrvs	0, 0, r0, cr0, cr4, {0}
    1b50:	80000003 	andhi	r0, r0, r3
    1b54:	54000086 	strpl	r0, [r0], #-134	; 0xffffff7a
    1b58:	01000000 	mrseq	r0, (UNDEF: 0)
    1b5c:	000a559c 	muleq	sl, ip, r5
    1b60:	14402400 	strbne	r2, [r0], #-1024	; 0xfffffc00
    1b64:	6b010000 	blvs	41b6c <__bss_end+0x3800c>
    1b68:	00004d15 	andeq	r4, r0, r5, lsl sp
    1b6c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b70:	000cc924 	andeq	ip, ip, r4, lsr #18
    1b74:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1b78:	0000004d 	andeq	r0, r0, sp, asr #32
    1b7c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1b80:	0000157e 	andeq	r1, r0, lr, ror r5
    1b84:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    1b88:	02000000 	andeq	r0, r0, #0
    1b8c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b90:	00001334 	andeq	r1, r0, r4, lsr r3
    1b94:	30125e01 	andscc	r5, r2, r1, lsl #28
    1b98:	8b000015 	blhi	1bf4 <shift+0x1bf4>
    1b9c:	30000000 	andcc	r0, r0, r0
    1ba0:	50000086 	andpl	r0, r0, r6, lsl #1
    1ba4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ba8:	000ab09c 	muleq	sl, ip, r0
    1bac:	073c2400 	ldreq	r2, [ip, -r0, lsl #8]!
    1bb0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1bb4:	00004d20 	andeq	r4, r0, r0, lsr #26
    1bb8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1bbc:	00147524 	andseq	r7, r4, r4, lsr #10
    1bc0:	2f5e0100 	svccs	0x005e0100
    1bc4:	0000004d 	andeq	r0, r0, sp, asr #32
    1bc8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1bcc:	00000cc9 	andeq	r0, r0, r9, asr #25
    1bd0:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 1bd4 <shift+0x1bd4>
    1bd4:	02000000 	andeq	r0, r0, #0
    1bd8:	7e226491 	mcrvc	4, 1, r6, cr2, cr1, {4}
    1bdc:	01000015 	tsteq	r0, r5, lsl r0
    1be0:	008b1660 	addeq	r1, fp, r0, ror #12
    1be4:	91020000 	mrsls	r0, (UNDEF: 2)
    1be8:	39250074 	stmdbcc	r5!, {r2, r4, r5, r6}
    1bec:	01000014 	tsteq	r0, r4, lsl r0
    1bf0:	13390a52 	teqne	r9, #335872	; 0x52000
    1bf4:	004d0000 	subeq	r0, sp, r0
    1bf8:	85ec0000 	strbhi	r0, [ip, #0]!
    1bfc:	00440000 	subeq	r0, r4, r0
    1c00:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c04:	00000afc 	strdeq	r0, [r0], -ip
    1c08:	00073c24 	andeq	r3, r7, r4, lsr #24
    1c0c:	1a520100 	bne	1482014 <__bss_end+0x14784b4>
    1c10:	0000004d 	andeq	r0, r0, sp, asr #32
    1c14:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1c18:	00001475 	andeq	r1, r0, r5, ror r4
    1c1c:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1c20:	02000000 	andeq	r0, r0, #0
    1c24:	5f226891 	svcpl	0x00226891
    1c28:	01000015 	tsteq	r0, r5, lsl r0
    1c2c:	004d0e54 	subeq	r0, sp, r4, asr lr
    1c30:	91020000 	mrsls	r0, (UNDEF: 2)
    1c34:	59250074 	stmdbpl	r5!, {r2, r4, r5, r6}
    1c38:	01000015 	tsteq	r0, r5, lsl r0
    1c3c:	153b0a45 	ldrne	r0, [fp, #-2629]!	; 0xfffff5bb
    1c40:	004d0000 	subeq	r0, sp, r0
    1c44:	859c0000 	ldrhi	r0, [ip]
    1c48:	00500000 	subseq	r0, r0, r0
    1c4c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c50:	00000b57 	andeq	r0, r0, r7, asr fp
    1c54:	00073c24 	andeq	r3, r7, r4, lsr #24
    1c58:	19450100 	stmdbne	r5, {r8}^
    1c5c:	0000004d 	andeq	r0, r0, sp, asr #32
    1c60:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1c64:	000013dc 	ldrdeq	r1, [r0], -ip
    1c68:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1c6c:	02000001 	andeq	r0, r0, #1
    1c70:	a2246891 	eorge	r6, r4, #9502720	; 0x910000
    1c74:	01000014 	tsteq	r0, r4, lsl r0
    1c78:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1c7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c80:	157e2264 	ldrbne	r2, [lr, #-612]!	; 0xfffffd9c
    1c84:	47010000 	strmi	r0, [r1, -r0]
    1c88:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c90:	12e72700 	rscne	r2, r7, #0, 14
    1c94:	3f010000 	svccc	0x00010000
    1c98:	0013e606 	andseq	lr, r3, r6, lsl #12
    1c9c:	00857000 	addeq	r7, r5, r0
    1ca0:	00002c00 	andeq	r2, r0, r0, lsl #24
    1ca4:	819c0100 	orrshi	r0, ip, r0, lsl #2
    1ca8:	2400000b 	strcs	r0, [r0], #-11
    1cac:	0000073c 	andeq	r0, r0, ip, lsr r7
    1cb0:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1cb4:	02000000 	andeq	r0, r0, #0
    1cb8:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1cbc:	000014d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1cc0:	a80a3201 	stmdage	sl, {r0, r9, ip, sp}
    1cc4:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1cc8:	20000000 	andcs	r0, r0, r0
    1ccc:	50000085 	andpl	r0, r0, r5, lsl #1
    1cd0:	01000000 	mrseq	r0, (UNDEF: 0)
    1cd4:	000bdc9c 	muleq	fp, ip, ip
    1cd8:	073c2400 	ldreq	r2, [ip, -r0, lsl #8]!
    1cdc:	32010000 	andcc	r0, r1, #0
    1ce0:	00004d19 	andeq	r4, r0, r9, lsl sp
    1ce4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ce8:	00156b24 	andseq	r6, r5, r4, lsr #22
    1cec:	2b320100 	blcs	c820f4 <__bss_end+0xc78594>
    1cf0:	0000037b 	andeq	r0, r0, fp, ror r3
    1cf4:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1cf8:	000014db 	ldrdeq	r1, [r0], -fp
    1cfc:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1d00:	02000000 	andeq	r0, r0, #0
    1d04:	2a226491 	bcs	89af50 <__bss_end+0x8913f0>
    1d08:	01000015 	tsteq	r0, r5, lsl r0
    1d0c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1d10:	91020000 	mrsls	r0, (UNDEF: 2)
    1d14:	a8250074 	stmdage	r5!, {r2, r4, r5, r6}
    1d18:	01000015 	tsteq	r0, r5, lsl r0
    1d1c:	15720a25 	ldrbne	r0, [r2, #-2597]!	; 0xfffff5db
    1d20:	004d0000 	subeq	r0, sp, r0
    1d24:	84d00000 	ldrbhi	r0, [r0], #0
    1d28:	00500000 	subseq	r0, r0, r0
    1d2c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d30:	00000c37 	andeq	r0, r0, r7, lsr ip
    1d34:	00073c24 	andeq	r3, r7, r4, lsr #24
    1d38:	18250100 	stmdane	r5!, {r8}
    1d3c:	0000004d 	andeq	r0, r0, sp, asr #32
    1d40:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d44:	0000156b 	andeq	r1, r0, fp, ror #10
    1d48:	3d2a2501 	cfstr32cc	mvfx2, [sl, #-4]!
    1d4c:	0200000c 	andeq	r0, r0, #12
    1d50:	db246891 	blle	91bf9c <__bss_end+0x91243c>
    1d54:	01000014 	tsteq	r0, r4, lsl r0
    1d58:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1d5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d60:	13062264 	movwne	r2, #25188	; 0x6264
    1d64:	27010000 	strcs	r0, [r1, -r0]
    1d68:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d70:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1d74:	03000000 	movweq	r0, #0
    1d78:	00000c37 	andeq	r0, r0, r7, lsr ip
    1d7c:	00144625 	andseq	r4, r4, r5, lsr #12
    1d80:	0a190100 	beq	642188 <__bss_end+0x638628>
    1d84:	000015be 			; <UNDEFINED> instruction: 0x000015be
    1d88:	0000004d 	andeq	r0, r0, sp, asr #32
    1d8c:	0000848c 	andeq	r8, r0, ip, lsl #9
    1d90:	00000044 	andeq	r0, r0, r4, asr #32
    1d94:	0c8e9c01 	stceq	12, cr9, [lr], {1}
    1d98:	9f240000 	svcls	0x00240000
    1d9c:	01000015 	tsteq	r0, r5, lsl r0
    1da0:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1da4:	91020000 	mrsls	r0, (UNDEF: 2)
    1da8:	1566246c 	strbne	r2, [r6, #-1132]!	; 0xfffffb94
    1dac:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1db0:	0001c635 	andeq	ip, r1, r5, lsr r6
    1db4:	68910200 	ldmvs	r1, {r9}
    1db8:	00073c22 	andeq	r3, r7, r2, lsr #24
    1dbc:	0e1b0100 	mufeqe	f0, f3, f0
    1dc0:	0000004d 	andeq	r0, r0, sp, asr #32
    1dc4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1dc8:	00137f28 	andseq	r7, r3, r8, lsr #30
    1dcc:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1dd0:	0000130c 	andeq	r1, r0, ip, lsl #6
    1dd4:	00008470 	andeq	r8, r0, r0, ror r4
    1dd8:	0000001c 	andeq	r0, r0, ip, lsl r0
    1ddc:	ad279c01 	stcge	12, cr9, [r7, #-4]!
    1de0:	01000015 	tsteq	r0, r5, lsl r0
    1de4:	1345060e 	movtne	r0, #22030	; 0x560e
    1de8:	84440000 	strbhi	r0, [r4], #-0
    1dec:	002c0000 	eoreq	r0, ip, r0
    1df0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1df4:	00000cce 	andeq	r0, r0, lr, asr #25
    1df8:	00135824 	andseq	r5, r3, r4, lsr #16
    1dfc:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1e00:	00000038 	andeq	r0, r0, r8, lsr r0
    1e04:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e08:	0015b729 	andseq	fp, r5, r9, lsr #14
    1e0c:	0a040100 	beq	102214 <__bss_end+0xf86b4>
    1e10:	00001428 	andeq	r1, r0, r8, lsr #8
    1e14:	0000004d 	andeq	r0, r0, sp, asr #32
    1e18:	00008418 	andeq	r8, r0, r8, lsl r4
    1e1c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1e20:	70269c01 	eorvc	r9, r6, r1, lsl #24
    1e24:	01006469 	tsteq	r0, r9, ror #8
    1e28:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1e2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e30:	f9000074 			; <UNDEFINED> instruction: 0xf9000074
    1e34:	04000006 	streq	r0, [r0], #-6
    1e38:	00073e00 	andeq	r3, r7, r0, lsl #28
    1e3c:	da010400 	ble	42e44 <__bss_end+0x392e4>
    1e40:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    1e44:	000016bd 			; <UNDEFINED> instruction: 0x000016bd
    1e48:	0000147b 	andeq	r1, r0, fp, ror r4
    1e4c:	00008874 	andeq	r8, r0, r4, ror r8
    1e50:	00000fdc 	ldrdeq	r0, [r0], -ip
    1e54:	00000787 	andeq	r0, r0, r7, lsl #15
    1e58:	00124b02 	andseq	r4, r2, r2, lsl #22
    1e5c:	11040200 	mrsne	r0, R12_usr
    1e60:	0000003e 	andeq	r0, r0, lr, lsr r0
    1e64:	9b300305 	blls	c02a80 <__bss_end+0xbf8f20>
    1e68:	04030000 	streq	r0, [r3], #-0
    1e6c:	001bf404 	andseq	pc, fp, r4, lsl #8
    1e70:	00370400 	eorseq	r0, r7, r0, lsl #8
    1e74:	67050000 	strvs	r0, [r5, -r0]
    1e78:	06000000 	streq	r0, [r0], -r0
    1e7c:	000017fd 	strdeq	r1, [r0], -sp
    1e80:	7f100501 	svcvc	0x00100501
    1e84:	11000000 	mrsne	r0, (UNDEF: 0)
    1e88:	33323130 	teqcc	r2, #48, 2
    1e8c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1e90:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1e94:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1e98:	01070000 	mrseq	r0, (UNDEF: 7)
    1e9c:	00430103 	subeq	r0, r3, r3, lsl #2
    1ea0:	97080000 	strls	r0, [r8, -r0]
    1ea4:	7f000000 	svcvc	0x00000000
    1ea8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1eac:	00000084 	andeq	r0, r0, r4, lsl #1
    1eb0:	6f040010 	svcvs	0x00040010
    1eb4:	03000000 	movweq	r0, #0
    1eb8:	1e2a0704 	cdpne	7, 2, cr0, cr10, cr4, {0}
    1ebc:	84040000 	strhi	r0, [r4], #-0
    1ec0:	03000000 	movweq	r0, #0
    1ec4:	0ff70801 	svceq	0x00f70801
    1ec8:	90040000 	andls	r0, r4, r0
    1ecc:	0a000000 	beq	1ed4 <shift+0x1ed4>
    1ed0:	00000048 	andeq	r0, r0, r8, asr #32
    1ed4:	0017f10b 	andseq	pc, r7, fp, lsl #2
    1ed8:	07fc0100 	ldrbeq	r0, [ip, r0, lsl #2]!
    1edc:	00001768 	andeq	r1, r0, r8, ror #14
    1ee0:	00000037 	andeq	r0, r0, r7, lsr r0
    1ee4:	00009740 	andeq	r9, r0, r0, asr #14
    1ee8:	00000110 	andeq	r0, r0, r0, lsl r1
    1eec:	011d9c01 	tsteq	sp, r1, lsl #24
    1ef0:	730c0000 	movwvc	r0, #49152	; 0xc000
    1ef4:	18fc0100 	ldmne	ip!, {r8}^
    1ef8:	0000011d 	andeq	r0, r0, sp, lsl r1
    1efc:	0d649102 	stfeqp	f1, [r4, #-8]!
    1f00:	007a6572 	rsbseq	r6, sl, r2, ror r5
    1f04:	3709fe01 	strcc	pc, [r9, -r1, lsl #28]
    1f08:	02000000 	andeq	r0, r0, #0
    1f0c:	8b0e7491 	blhi	39f158 <__bss_end+0x3955f8>
    1f10:	01000018 	tsteq	r0, r8, lsl r0
    1f14:	003712fe 	ldrshteq	r1, [r7], -lr
    1f18:	91020000 	mrsls	r0, (UNDEF: 2)
    1f1c:	97840f70 			; <UNDEFINED> instruction: 0x97840f70
    1f20:	00a80000 	adceq	r0, r8, r0
    1f24:	2f100000 	svccs	0x00100000
    1f28:	01000017 	tsteq	r0, r7, lsl r0
    1f2c:	230c0103 	movwcs	r0, #49411	; 0xc103
    1f30:	02000001 	andeq	r0, r0, #1
    1f34:	9c0f6c91 	stcls	12, cr6, [pc], {145}	; 0x91
    1f38:	80000097 	mulhi	r0, r7, r0
    1f3c:	11000000 	mrsne	r0, (UNDEF: 0)
    1f40:	08010064 	stmdaeq	r1, {r2, r5, r6}
    1f44:	01230901 			; <UNDEFINED> instruction: 0x01230901
    1f48:	91020000 	mrsls	r0, (UNDEF: 2)
    1f4c:	00000068 	andeq	r0, r0, r8, rrx
    1f50:	00970412 	addseq	r0, r7, r2, lsl r4
    1f54:	04130000 	ldreq	r0, [r3], #-0
    1f58:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1f5c:	18091400 	stmdane	r9, {sl, ip}
    1f60:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1f64:	00187306 	andseq	r7, r8, r6, lsl #6
    1f68:	00941c00 	addseq	r1, r4, r0, lsl #24
    1f6c:	00032400 	andeq	r2, r3, r0, lsl #8
    1f70:	299c0100 	ldmibcs	ip, {r8}
    1f74:	0c000002 	stceq	0, cr0, [r0], {2}
    1f78:	c1010078 	tstgt	r1, r8, ror r0
    1f7c:	00003711 	andeq	r3, r0, r1, lsl r7
    1f80:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    1f84:	66620c7f 			; <UNDEFINED> instruction: 0x66620c7f
    1f88:	c1010072 	tstgt	r1, r2, ror r0
    1f8c:	0002291a 	andeq	r2, r2, sl, lsl r9
    1f90:	a0910300 	addsge	r0, r1, r0, lsl #6
    1f94:	1741157f 	smlsldxne	r1, r1, pc, r5	; <UNPREDICTABLE>
    1f98:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1f9c:	00008b32 	andeq	r8, r0, r2, lsr fp
    1fa0:	9c910300 	ldcls	3, cr0, [r1], {0}
    1fa4:	184c0e7f 	stmdane	ip, {r0, r1, r2, r3, r4, r5, r6, r9, sl, fp}^
    1fa8:	c3010000 	movwgt	r0, #4096	; 0x1000
    1fac:	0000840f 	andeq	r8, r0, pc, lsl #8
    1fb0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1fb4:	0018350e 	andseq	r3, r8, lr, lsl #10
    1fb8:	06d90100 	ldrbeq	r0, [r9], r0, lsl #2
    1fbc:	00000123 	andeq	r0, r0, r3, lsr #2
    1fc0:	0e709102 	expeqs	f1, f2
    1fc4:	0000174a 	andeq	r1, r0, sl, asr #14
    1fc8:	3e11dd01 	cdpcc	13, 1, cr13, cr1, cr1, {0}
    1fcc:	02000000 	andeq	r0, r0, #0
    1fd0:	070e6491 			; <UNDEFINED> instruction: 0x070e6491
    1fd4:	01000017 	tsteq	r0, r7, lsl r0
    1fd8:	008b18e0 	addeq	r1, fp, r0, ror #17
    1fdc:	91020000 	mrsls	r0, (UNDEF: 2)
    1fe0:	17160e60 	ldrne	r0, [r6, -r0, ror #28]
    1fe4:	e1010000 	mrs	r0, (UNDEF: 1)
    1fe8:	00008b18 	andeq	r8, r0, r8, lsl fp
    1fec:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1ff0:	0017bc0e 	andseq	fp, r7, lr, lsl #24
    1ff4:	07e30100 	strbeq	r0, [r3, r0, lsl #2]!
    1ff8:	0000022f 	andeq	r0, r0, pc, lsr #4
    1ffc:	7fb89103 	svcvc	0x00b89103
    2000:	0017500e 	andseq	r5, r7, lr
    2004:	06e50100 	strbteq	r0, [r5], r0, lsl #2
    2008:	00000123 	andeq	r0, r0, r3, lsr #2
    200c:	16589102 	ldrbne	r9, [r8], -r2, lsl #2
    2010:	00009628 	andeq	r9, r0, r8, lsr #12
    2014:	00000050 	andeq	r0, r0, r0, asr r0
    2018:	000001f7 	strdeq	r0, [r0], -r7
    201c:	0100690d 	tsteq	r0, sp, lsl #18
    2020:	01230be7 	smulwteq	r3, r7, fp
    2024:	91020000 	mrsls	r0, (UNDEF: 2)
    2028:	840f006c 	strhi	r0, [pc], #-108	; 2030 <shift+0x2030>
    202c:	98000096 	stmdals	r0, {r1, r2, r4, r7}
    2030:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2034:	0000173a 	andeq	r1, r0, sl, lsr r7
    2038:	3f08ef01 	svccc	0x0008ef01
    203c:	03000002 	movweq	r0, #2
    2040:	0f7fac91 	svceq	0x007fac91
    2044:	000096b4 			; <UNDEFINED> instruction: 0x000096b4
    2048:	00000068 	andeq	r0, r0, r8, rrx
    204c:	0100690d 	tsteq	r0, sp, lsl #18
    2050:	01230cf2 	strdeq	r0, [r3, -r2]!
    2054:	91020000 	mrsls	r0, (UNDEF: 2)
    2058:	00000068 	andeq	r0, r0, r8, rrx
    205c:	00900412 	addseq	r0, r0, r2, lsl r4
    2060:	90080000 	andls	r0, r8, r0
    2064:	3f000000 	svccc	0x00000000
    2068:	09000002 	stmdbeq	r0, {r1}
    206c:	00000084 	andeq	r0, r0, r4, lsl #1
    2070:	9008001f 	andls	r0, r8, pc, lsl r0
    2074:	4f000000 	svcmi	0x00000000
    2078:	09000002 	stmdbeq	r0, {r1}
    207c:	00000084 	andeq	r0, r0, r4, lsl #1
    2080:	09140008 	ldmdbeq	r4, {r3}
    2084:	01000018 	tsteq	r0, r8, lsl r0
    2088:	18d806bb 	ldmne	r8, {r0, r1, r3, r4, r5, r7, r9, sl}^
    208c:	93ec0000 	mvnls	r0, #0
    2090:	00300000 	eorseq	r0, r0, r0
    2094:	9c010000 	stcls	0, cr0, [r1], {-0}
    2098:	00000286 	andeq	r0, r0, r6, lsl #5
    209c:	0100780c 	tsteq	r0, ip, lsl #16
    20a0:	003711bb 	ldrhteq	r1, [r7], -fp
    20a4:	91020000 	mrsls	r0, (UNDEF: 2)
    20a8:	66620c74 			; <UNDEFINED> instruction: 0x66620c74
    20ac:	bb010072 	bllt	4227c <__bss_end+0x3871c>
    20b0:	0002291a 	andeq	r2, r2, sl, lsl r9
    20b4:	70910200 	addsvc	r0, r1, r0, lsl #4
    20b8:	17100b00 	ldrne	r0, [r0, -r0, lsl #22]
    20bc:	b5010000 	strlt	r0, [r1, #-0]
    20c0:	0017c706 	andseq	ip, r7, r6, lsl #14
    20c4:	0002b200 	andeq	fp, r2, r0, lsl #4
    20c8:	0093ac00 	addseq	sl, r3, r0, lsl #24
    20cc:	00004000 	andeq	r4, r0, r0
    20d0:	b29c0100 	addslt	r0, ip, #0, 2
    20d4:	0c000002 	stceq	0, cr0, [r0], {2}
    20d8:	b5010078 	strlt	r0, [r1, #-120]	; 0xffffff88
    20dc:	00003712 	andeq	r3, r0, r2, lsl r7
    20e0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    20e4:	02010300 	andeq	r0, r1, #0, 6
    20e8:	00000ae4 	andeq	r0, r0, r4, ror #21
    20ec:	0017010b 	andseq	r0, r7, fp, lsl #2
    20f0:	06b00100 	ldrteq	r0, [r0], r0, lsl #2
    20f4:	00001784 	andeq	r1, r0, r4, lsl #15
    20f8:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    20fc:	00009370 	andeq	r9, r0, r0, ror r3
    2100:	0000003c 	andeq	r0, r0, ip, lsr r0
    2104:	02e59c01 	rsceq	r9, r5, #256	; 0x100
    2108:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    210c:	12b00100 	adcsne	r0, r0, #0, 2
    2110:	00000037 	andeq	r0, r0, r7, lsr r0
    2114:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2118:	0018c014 	andseq	ip, r8, r4, lsl r0
    211c:	06a50100 	strteq	r0, [r5], r0, lsl #2
    2120:	0000180e 	andeq	r1, r0, lr, lsl #16
    2124:	0000929c 	muleq	r0, ip, r2
    2128:	000000d4 	ldrdeq	r0, [r0], -r4
    212c:	033a9c01 	teqeq	sl, #256	; 0x100
    2130:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2134:	2ba50100 	blcs	fe94253c <__bss_end+0xfe9389dc>
    2138:	00000084 	andeq	r0, r0, r4, lsl #1
    213c:	0c6c9102 	stfeqp	f1, [ip], #-8
    2140:	00726662 	rsbseq	r6, r2, r2, ror #12
    2144:	2934a501 	ldmdbcs	r4!, {r0, r8, sl, sp, pc}
    2148:	02000002 	andeq	r0, r0, #2
    214c:	5a156891 	bpl	55c398 <__bss_end+0x552838>
    2150:	01000018 	tsteq	r0, r8, lsl r0
    2154:	01233da5 			; <UNDEFINED> instruction: 0x01233da5
    2158:	91020000 	mrsls	r0, (UNDEF: 2)
    215c:	184c0e64 	stmdane	ip, {r2, r5, r6, r9, sl, fp}^
    2160:	a7010000 	strge	r0, [r1, -r0]
    2164:	00012306 	andeq	r2, r1, r6, lsl #6
    2168:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    216c:	187f1700 	ldmdane	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2170:	83010000 	movwhi	r0, #4096	; 0x1000
    2174:	0017da06 	andseq	sp, r7, r6, lsl #20
    2178:	008e5c00 	addeq	r5, lr, r0, lsl #24
    217c:	00044000 	andeq	r4, r4, r0
    2180:	9e9c0100 	fmllse	f0, f4, f0
    2184:	0c000003 	stceq	0, cr0, [r0], {3}
    2188:	83010078 	movwhi	r0, #4216	; 0x1078
    218c:	00003718 	andeq	r3, r0, r8, lsl r7
    2190:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2194:	00170715 	andseq	r0, r7, r5, lsl r7
    2198:	29830100 	stmibcs	r3, {r8}
    219c:	0000039e 	muleq	r0, lr, r3
    21a0:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    21a4:	00001716 	andeq	r1, r0, r6, lsl r7
    21a8:	9e418301 	cdpls	3, 4, cr8, cr1, cr1, {0}
    21ac:	02000003 	andeq	r0, r0, #3
    21b0:	5f156491 	svcpl	0x00156491
    21b4:	01000017 	tsteq	r0, r7, lsl r0
    21b8:	03a44f83 			; <UNDEFINED> instruction: 0x03a44f83
    21bc:	91020000 	mrsls	r0, (UNDEF: 2)
    21c0:	16f70e60 	ldrbtne	r0, [r7], r0, ror #28
    21c4:	96010000 	strls	r0, [r1], -r0
    21c8:	0000370b 	andeq	r3, r0, fp, lsl #14
    21cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    21d0:	84041800 	strhi	r1, [r4], #-2048	; 0xfffff800
    21d4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    21d8:	00012304 	andeq	r2, r1, r4, lsl #6
    21dc:	18f81400 	ldmne	r8!, {sl, ip}^
    21e0:	76010000 	strvc	r0, [r1], -r0
    21e4:	00177806 	andseq	r7, r7, r6, lsl #16
    21e8:	008d9800 	addeq	r9, sp, r0, lsl #16
    21ec:	0000c400 	andeq	ip, r0, r0, lsl #8
    21f0:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
    21f4:	15000003 	strne	r0, [r0, #-3]
    21f8:	000017b7 			; <UNDEFINED> instruction: 0x000017b7
    21fc:	29137601 	ldmdbcs	r3, {r0, r9, sl, ip, sp, lr}
    2200:	02000002 	andeq	r0, r0, #2
    2204:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    2208:	09780100 	ldmdbeq	r8!, {r8}^
    220c:	00000123 	andeq	r0, r0, r3, lsr #2
    2210:	0d749102 	ldfeqp	f1, [r4, #-8]!
    2214:	006e656c 	rsbeq	r6, lr, ip, ror #10
    2218:	230c7801 	movwcs	r7, #51201	; 0xc801
    221c:	02000001 	andeq	r0, r0, #1
    2220:	990e7091 	stmdbls	lr, {r0, r4, r7, ip, sp, lr}
    2224:	01000017 	tsteq	r0, r7, lsl r0
    2228:	01231178 			; <UNDEFINED> instruction: 0x01231178
    222c:	91020000 	mrsls	r0, (UNDEF: 2)
    2230:	7019006c 	andsvc	r0, r9, ip, rrx
    2234:	0100776f 	tsteq	r0, pc, ror #14
    2238:	17d1076d 	ldrbne	r0, [r1, sp, ror #14]
    223c:	00370000 	eorseq	r0, r7, r0
    2240:	8d2c0000 	stchi	0, cr0, [ip, #-0]
    2244:	006c0000 	rsbeq	r0, ip, r0
    2248:	9c010000 	stcls	0, cr0, [r1], {-0}
    224c:	0000045c 	andeq	r0, r0, ip, asr r4
    2250:	0100780c 	tsteq	r0, ip, lsl #16
    2254:	003e176d 	eorseq	r1, lr, sp, ror #14
    2258:	91020000 	mrsls	r0, (UNDEF: 2)
    225c:	006e0c6c 	rsbeq	r0, lr, ip, ror #24
    2260:	8b2d6d01 	blhi	b5d66c <__bss_end+0xb53b0c>
    2264:	02000000 	andeq	r0, r0, #0
    2268:	720d6891 	andvc	r6, sp, #9502720	; 0x910000
    226c:	0b6f0100 	bleq	1bc2674 <__bss_end+0x1bb8b14>
    2270:	00000037 	andeq	r0, r0, r7, lsr r0
    2274:	0f749102 	svceq	0x00749102
    2278:	00008d48 	andeq	r8, r0, r8, asr #26
    227c:	00000038 	andeq	r0, r0, r8, lsr r0
    2280:	0100690d 	tsteq	r0, sp, lsl #18
    2284:	00841670 	addeq	r1, r4, r0, ror r6
    2288:	91020000 	mrsls	r0, (UNDEF: 2)
    228c:	17000070 	smlsdxne	r0, r0, r0, r0
    2290:	00001845 	andeq	r1, r0, r5, asr #16
    2294:	ad066401 	cfstrsge	mvf6, [r6, #-4]
    2298:	ac000016 	stcge	0, cr0, [r0], {22}
    229c:	8000008c 	andhi	r0, r0, ip, lsl #1
    22a0:	01000000 	mrseq	r0, (UNDEF: 0)
    22a4:	0004d99c 	muleq	r4, ip, r9
    22a8:	72730c00 	rsbsvc	r0, r3, #0, 24
    22ac:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    22b0:	0004d919 	andeq	sp, r4, r9, lsl r9
    22b4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    22b8:	7473640c 	ldrbtvc	r6, [r3], #-1036	; 0xfffffbf4
    22bc:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    22c0:	000004e0 	andeq	r0, r0, r0, ror #9
    22c4:	0c609102 	stfeqp	f1, [r0], #-8
    22c8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    22cc:	232d6401 			; <UNDEFINED> instruction: 0x232d6401
    22d0:	02000001 	andeq	r0, r0, #1
    22d4:	2e0e5c91 	mcrcs	12, 0, r5, cr14, cr1, {4}
    22d8:	01000018 	tsteq	r0, r8, lsl r0
    22dc:	011d0e66 	tsteq	sp, r6, ror #28
    22e0:	91020000 	mrsls	r0, (UNDEF: 2)
    22e4:	17f60e70 			; <UNDEFINED> instruction: 0x17f60e70
    22e8:	67010000 	strvs	r0, [r1, -r0]
    22ec:	00022908 	andeq	r2, r2, r8, lsl #18
    22f0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    22f4:	008cd40f 	addeq	sp, ip, pc, lsl #8
    22f8:	00004800 	andeq	r4, r0, r0, lsl #16
    22fc:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2300:	230b6901 	movwcs	r6, #47361	; 0xb901
    2304:	02000001 	andeq	r0, r0, #1
    2308:	00007491 	muleq	r0, r1, r4
    230c:	04df0412 	ldrbeq	r0, [pc], #1042	; 2314 <shift+0x2314>
    2310:	1b1a0000 	blne	682318 <__bss_end+0x6787b8>
    2314:	183f1704 	ldmdane	pc!, {r2, r8, r9, sl, ip}	; <UNPREDICTABLE>
    2318:	5c010000 	stcpl	0, cr0, [r1], {-0}
    231c:	00179e06 	andseq	r9, r7, r6, lsl #28
    2320:	008c4400 	addeq	r4, ip, r0, lsl #8
    2324:	00006800 	andeq	r6, r0, r0, lsl #16
    2328:	419c0100 	orrsmi	r0, ip, r0, lsl #2
    232c:	15000005 	strne	r0, [r0, #-5]
    2330:	000018e3 	andeq	r1, r0, r3, ror #17
    2334:	e0125c01 	ands	r5, r2, r1, lsl #24
    2338:	02000004 	andeq	r0, r0, #4
    233c:	ea156c91 	b	55d588 <__bss_end+0x553a28>
    2340:	01000018 	tsteq	r0, r8, lsl r0
    2344:	01231e5c 			; <UNDEFINED> instruction: 0x01231e5c
    2348:	91020000 	mrsls	r0, (UNDEF: 2)
    234c:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    2350:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    2354:	00022908 	andeq	r2, r2, r8, lsl #18
    2358:	70910200 	addsvc	r0, r1, r0, lsl #4
    235c:	008c600f 	addeq	r6, ip, pc
    2360:	00003c00 	andeq	r3, r0, r0, lsl #24
    2364:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2368:	230b6001 	movwcs	r6, #45057	; 0xb001
    236c:	02000001 	andeq	r0, r0, #1
    2370:	00007491 	muleq	r0, r1, r4
    2374:	0018f10b 	andseq	pc, r8, fp, lsl #2
    2378:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    237c:	00001890 	muleq	r0, r0, r8
    2380:	00000123 	andeq	r0, r0, r3, lsr #2
    2384:	00008bf0 	strdeq	r8, [r0], -r0
    2388:	00000054 	andeq	r0, r0, r4, asr r0
    238c:	057a9c01 	ldrbeq	r9, [sl, #-3073]!	; 0xfffff3ff
    2390:	730c0000 	movwvc	r0, #49152	; 0xc000
    2394:	18520100 	ldmdane	r2, {r8}^
    2398:	0000011d 	andeq	r0, r0, sp, lsl r1
    239c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    23a0:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    23a4:	00012306 	andeq	r2, r1, r6, lsl #6
    23a8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    23ac:	18520b00 	ldmdane	r2, {r8, r9, fp}^
    23b0:	42010000 	andmi	r0, r1, #0
    23b4:	00189d05 	andseq	r9, r8, r5, lsl #26
    23b8:	00012300 	andeq	r2, r1, r0, lsl #6
    23bc:	008b4400 	addeq	r4, fp, r0, lsl #8
    23c0:	0000ac00 	andeq	sl, r0, r0, lsl #24
    23c4:	e09c0100 	adds	r0, ip, r0, lsl #2
    23c8:	0c000005 	stceq	0, cr0, [r0], {5}
    23cc:	01003173 	tsteq	r0, r3, ror r1
    23d0:	011d1942 	tsteq	sp, r2, asr #18
    23d4:	91020000 	mrsls	r0, (UNDEF: 2)
    23d8:	32730c6c 	rsbscc	r0, r3, #108, 24	; 0x6c00
    23dc:	29420100 	stmdbcs	r2, {r8}^
    23e0:	0000011d 	andeq	r0, r0, sp, lsl r1
    23e4:	0c689102 	stfeqp	f1, [r8], #-8
    23e8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    23ec:	23314201 	teqcs	r1, #268435456	; 0x10000000
    23f0:	02000001 	andeq	r0, r0, #1
    23f4:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    23f8:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    23fc:	0005e010 	andeq	lr, r5, r0, lsl r0
    2400:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    2404:	0032750d 	eorseq	r7, r2, sp, lsl #10
    2408:	e0144401 	ands	r4, r4, r1, lsl #8
    240c:	02000005 	andeq	r0, r0, #5
    2410:	03007691 	movweq	r7, #1681	; 0x691
    2414:	0fee0801 	svceq	0x00ee0801
    2418:	aa0b0000 	bge	2c2420 <__bss_end+0x2b88c0>
    241c:	01000017 	tsteq	r0, r7, lsl r0
    2420:	18af0736 	stmiane	pc!, {r1, r2, r4, r5, r8, r9, sl}	; <UNPREDICTABLE>
    2424:	02290000 	eoreq	r0, r9, #0
    2428:	8a840000 	bhi	fe102430 <__bss_end+0xfe0f88d0>
    242c:	00c00000 	sbceq	r0, r0, r0
    2430:	9c010000 	stcls	0, cr0, [r1], {-0}
    2434:	00000640 	andeq	r0, r0, r0, asr #12
    2438:	00177315 	andseq	r7, r7, r5, lsl r3
    243c:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    2440:	00000229 	andeq	r0, r0, r9, lsr #4
    2444:	0c6c9102 	stfeqp	f1, [ip], #-8
    2448:	00637273 	rsbeq	r7, r3, r3, ror r2
    244c:	1d273601 	stcne	6, cr3, [r7, #-4]!
    2450:	02000001 	andeq	r0, r0, #1
    2454:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    2458:	01006d75 	tsteq	r0, r5, ror sp
    245c:	01233036 			; <UNDEFINED> instruction: 0x01233036
    2460:	91020000 	mrsls	r0, (UNDEF: 2)
    2464:	00690d64 	rsbeq	r0, r9, r4, ror #26
    2468:	23063801 	movwcs	r3, #26625	; 0x6801
    246c:	02000001 	andeq	r0, r0, #1
    2470:	0b007491 	bleq	1f6bc <__bss_end+0x15b5c>
    2474:	0000172a 	andeq	r1, r0, sl, lsr #14
    2478:	61052401 	tstvs	r5, r1, lsl #8
    247c:	23000018 	movwcs	r0, #24
    2480:	e8000001 	stmda	r0, {r0}
    2484:	9c000089 	stcls	0, cr0, [r0], {137}	; 0x89
    2488:	01000000 	mrseq	r0, (UNDEF: 0)
    248c:	00067d9c 	muleq	r6, ip, sp
    2490:	178e1500 	strne	r1, [lr, r0, lsl #10]
    2494:	24010000 	strcs	r0, [r1], #-0
    2498:	00011d16 	andeq	r1, r1, r6, lsl sp
    249c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    24a0:	00186c0e 	andseq	r6, r8, lr, lsl #24
    24a4:	06260100 	strteq	r0, [r6], -r0, lsl #2
    24a8:	00000123 	andeq	r0, r0, r3, lsr #2
    24ac:	00749102 	rsbseq	r9, r4, r2, lsl #2
    24b0:	0017b21c 	andseq	fp, r7, ip, lsl r2
    24b4:	06080100 	streq	r0, [r8], -r0, lsl #2
    24b8:	0000171e 	andeq	r1, r0, lr, lsl r7
    24bc:	00008874 	andeq	r8, r0, r4, ror r8
    24c0:	00000174 	andeq	r0, r0, r4, ror r1
    24c4:	8e159c01 	cdphi	12, 1, cr9, cr5, cr1, {0}
    24c8:	01000017 	tsteq	r0, r7, lsl r0
    24cc:	00841808 	addeq	r1, r4, r8, lsl #16
    24d0:	91020000 	mrsls	r0, (UNDEF: 2)
    24d4:	186c1564 	stmdane	ip!, {r2, r5, r6, r8, sl, ip}^
    24d8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    24dc:	00022925 	andeq	r2, r2, r5, lsr #18
    24e0:	60910200 	addsvs	r0, r1, r0, lsl #4
    24e4:	00179415 	andseq	r9, r7, r5, lsl r4
    24e8:	3a080100 	bcc	2028f0 <__bss_end+0x1f8d90>
    24ec:	00000084 	andeq	r0, r0, r4, lsl #1
    24f0:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    24f4:	0a010069 	beq	426a0 <__bss_end+0x38b40>
    24f8:	00012306 	andeq	r2, r1, r6, lsl #6
    24fc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2500:	0089400f 	addeq	r4, r9, pc
    2504:	00009800 	andeq	r9, r0, r0, lsl #16
    2508:	006a0d00 	rsbeq	r0, sl, r0, lsl #26
    250c:	230b1c01 	movwcs	r1, #48129	; 0xbc01
    2510:	02000001 	andeq	r0, r0, #1
    2514:	680f7091 	stmdavs	pc, {r0, r4, r7, ip, sp, lr}	; <UNPREDICTABLE>
    2518:	60000089 	andvs	r0, r0, r9, lsl #1
    251c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2520:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    2524:	00009008 	andeq	r9, r0, r8
    2528:	6f910200 	svcvs	0x00910200
    252c:	00000000 	andeq	r0, r0, r0
    2530:	00000022 	andeq	r0, r0, r2, lsr #32
    2534:	08e80002 	stmiaeq	r8!, {r1}^
    2538:	01040000 	mrseq	r0, (UNDEF: 4)
    253c:	00000dc9 	andeq	r0, r0, r9, asr #27
    2540:	00009850 	andeq	r9, r0, r0, asr r8
    2544:	00009a5c 	andeq	r9, r0, ip, asr sl
    2548:	000018ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    254c:	0000192f 	andeq	r1, r0, pc, lsr #18
    2550:	00000063 	andeq	r0, r0, r3, rrx
    2554:	00228001 	eoreq	r8, r2, r1
    2558:	00020000 	andeq	r0, r2, r0
    255c:	000008fc 	strdeq	r0, [r0], -ip
    2560:	0e460104 	dvfeqs	f0, f6, f4
    2564:	9a5c0000 	bls	170256c <__bss_end+0x16f8a0c>
    2568:	9a600000 	bls	1802570 <__bss_end+0x17f8a10>
    256c:	18ff0000 	ldmne	pc!, {}^	; <UNPREDICTABLE>
    2570:	192f0000 	stmdbne	pc!, {}	; <UNPREDICTABLE>
    2574:	00630000 	rsbeq	r0, r3, r0
    2578:	80010000 	andhi	r0, r1, r0
    257c:	00000932 	andeq	r0, r0, r2, lsr r9
    2580:	09100004 	ldmdbeq	r0, {r2}
    2584:	01040000 	mrseq	r0, (UNDEF: 4)
    2588:	00001cfd 	strdeq	r1, [r0], -sp
    258c:	001c540c 	andseq	r5, ip, ip, lsl #8
    2590:	00192f00 	andseq	r2, r9, r0, lsl #30
    2594:	000ea600 	andeq	sl, lr, r0, lsl #12
    2598:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    259c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    25a0:	2a070403 	bcs	1c35b4 <__bss_end+0x1b9a54>
    25a4:	0300001e 	movweq	r0, #30
    25a8:	031f0508 	tsteq	pc, #8, 10	; 0x2000000
    25ac:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    25b0:	0024fc04 	eoreq	pc, r4, r4, lsl #24
    25b4:	1caf0400 	cfstrsne	mvf0, [pc]	; 25bc <shift+0x25bc>
    25b8:	2a010000 	bcs	425c0 <__bss_end+0x38a60>
    25bc:	00002416 	andeq	r2, r0, r6, lsl r4
    25c0:	211e0400 	tstcs	lr, r0, lsl #8
    25c4:	2f010000 	svccs	0x00010000
    25c8:	00005115 	andeq	r5, r0, r5, lsl r1
    25cc:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    25d0:	06000000 	streq	r0, [r0], -r0
    25d4:	00000039 	andeq	r0, r0, r9, lsr r0
    25d8:	00000066 	andeq	r0, r0, r6, rrx
    25dc:	00006607 	andeq	r6, r0, r7, lsl #12
    25e0:	04050000 	streq	r0, [r5], #-0
    25e4:	0000006c 	andeq	r0, r0, ip, rrx
    25e8:	28500408 	ldmdacs	r0, {r3, sl}^
    25ec:	36010000 	strcc	r0, [r1], -r0
    25f0:	0000790f 	andeq	r7, r0, pc, lsl #18
    25f4:	7f040500 	svcvc	0x00040500
    25f8:	06000000 	streq	r0, [r0], -r0
    25fc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2600:	00000093 	muleq	r0, r3, r0
    2604:	00006607 	andeq	r6, r0, r7, lsl #12
    2608:	00660700 	rsbeq	r0, r6, r0, lsl #14
    260c:	03000000 	movweq	r0, #0
    2610:	0fee0801 	svceq	0x00ee0801
    2614:	56090000 	strpl	r0, [r9], -r0
    2618:	01000023 	tsteq	r0, r3, lsr #32
    261c:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    2620:	7e090000 	cdpvc	0, 0, cr0, cr9, cr0, {0}
    2624:	01000028 	tsteq	r0, r8, lsr #32
    2628:	006d10be 	strhteq	r1, [sp], #-14
    262c:	01030000 	mrseq	r0, (UNDEF: 3)
    2630:	000ff006 	andeq	pc, pc, r6
    2634:	203e0a00 	eorscs	r0, lr, r0, lsl #20
    2638:	01070000 	mrseq	r0, (UNDEF: 7)
    263c:	00000093 	muleq	r0, r3, r0
    2640:	e6061702 	str	r1, [r6], -r2, lsl #14
    2644:	0b000001 	bleq	2650 <shift+0x2650>
    2648:	00001b0d 	andeq	r1, r0, sp, lsl #22
    264c:	1f5b0b00 	svcne	0x005b0b00
    2650:	0b010000 	bleq	42658 <__bss_end+0x38af8>
    2654:	00002421 	andeq	r2, r0, r1, lsr #8
    2658:	27920b02 	ldrcs	r0, [r2, r2, lsl #22]
    265c:	0b030000 	bleq	c2664 <__bss_end+0xb8b04>
    2660:	000023c5 	andeq	r2, r0, r5, asr #7
    2664:	269b0b04 	ldrcs	r0, [fp], r4, lsl #22
    2668:	0b050000 	bleq	142670 <__bss_end+0x138b10>
    266c:	000025ff 	strdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    2670:	1b2e0b06 	blne	b85290 <__bss_end+0xb7b730>
    2674:	0b070000 	bleq	1c267c <__bss_end+0x1b8b1c>
    2678:	000026b0 			; <UNDEFINED> instruction: 0x000026b0
    267c:	26be0b08 	ldrtcs	r0, [lr], r8, lsl #22
    2680:	0b090000 	bleq	242688 <__bss_end+0x238b28>
    2684:	00002785 	andeq	r2, r0, r5, lsl #15
    2688:	231c0b0a 	tstcs	ip, #10240	; 0x2800
    268c:	0b0b0000 	bleq	2c2694 <__bss_end+0x2b8b34>
    2690:	00001cf0 	strdeq	r1, [r0], -r0
    2694:	1dcd0b0c 	vstrne	d16, [sp, #48]	; 0x30
    2698:	0b0d0000 	bleq	3426a0 <__bss_end+0x338b40>
    269c:	00002082 	andeq	r2, r0, r2, lsl #1
    26a0:	20980b0e 	addscs	r0, r8, lr, lsl #22
    26a4:	0b0f0000 	bleq	3c26ac <__bss_end+0x3b8b4c>
    26a8:	00001f95 	muleq	r0, r5, pc	; <UNPREDICTABLE>
    26ac:	23a90b10 			; <UNDEFINED> instruction: 0x23a90b10
    26b0:	0b110000 	bleq	4426b8 <__bss_end+0x438b58>
    26b4:	00002001 	andeq	r2, r0, r1
    26b8:	2a170b12 	bcs	5c5308 <__bss_end+0x5bb7a8>
    26bc:	0b130000 	bleq	4c26c4 <__bss_end+0x4b8b64>
    26c0:	00001b97 	muleq	r0, r7, fp
    26c4:	20250b14 	eorcs	r0, r5, r4, lsl fp
    26c8:	0b150000 	bleq	5426d0 <__bss_end+0x538b70>
    26cc:	00001ad4 	ldrdeq	r1, [r0], -r4
    26d0:	27b50b16 			; <UNDEFINED> instruction: 0x27b50b16
    26d4:	0b170000 	bleq	5c26dc <__bss_end+0x5b8b7c>
    26d8:	000028d7 	ldrdeq	r2, [r0], -r7
    26dc:	204a0b18 	subcs	r0, sl, r8, lsl fp
    26e0:	0b190000 	bleq	6426e8 <__bss_end+0x638b88>
    26e4:	00002493 	muleq	r0, r3, r4
    26e8:	27c30b1a 	bfics	r0, sl, (invalid: 22:3)
    26ec:	0b1b0000 	bleq	6c26f4 <__bss_end+0x6b8b94>
    26f0:	00001a03 	andeq	r1, r0, r3, lsl #20
    26f4:	27d10b1c 	bfics	r0, ip, (invalid: 22:17)
    26f8:	0b1d0000 	bleq	742700 <__bss_end+0x738ba0>
    26fc:	000027df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    2700:	19b10b1e 	ldmibne	r1!, {r1, r2, r3, r4, r8, r9, fp}
    2704:	0b1f0000 	bleq	7c270c <__bss_end+0x7b8bac>
    2708:	00002809 	andeq	r2, r0, r9, lsl #16
    270c:	25400b20 	strbcs	r0, [r0, #-2848]	; 0xfffff4e0
    2710:	0b210000 	bleq	842718 <__bss_end+0x838bb8>
    2714:	0000237b 	andeq	r2, r0, fp, ror r3
    2718:	27a80b22 	strcs	r0, [r8, r2, lsr #22]!
    271c:	0b230000 	bleq	8c2724 <__bss_end+0x8b8bc4>
    2720:	0000227f 	andeq	r2, r0, pc, ror r2
    2724:	21810b24 	orrcs	r0, r1, r4, lsr #22
    2728:	0b250000 	bleq	942730 <__bss_end+0x938bd0>
    272c:	00001e9b 	muleq	r0, fp, lr
    2730:	219f0b26 	orrscs	r0, pc, r6, lsr #22
    2734:	0b270000 	bleq	9c273c <__bss_end+0x9b8bdc>
    2738:	00001f37 	andeq	r1, r0, r7, lsr pc
    273c:	21af0b28 			; <UNDEFINED> instruction: 0x21af0b28
    2740:	0b290000 	bleq	a42748 <__bss_end+0xa38be8>
    2744:	000021bf 			; <UNDEFINED> instruction: 0x000021bf
    2748:	23020b2a 	movwcs	r0, #11050	; 0x2b2a
    274c:	0b2b0000 	bleq	ac2754 <__bss_end+0xab8bf4>
    2750:	00002128 	andeq	r2, r0, r8, lsr #2
    2754:	254d0b2c 	strbcs	r0, [sp, #-2860]	; 0xfffff4d4
    2758:	0b2d0000 	bleq	b42760 <__bss_end+0xb38c00>
    275c:	00001edc 	ldrdeq	r1, [r0], -ip
    2760:	ba0a002e 	blt	282820 <__bss_end+0x278cc0>
    2764:	07000020 	streq	r0, [r0, -r0, lsr #32]
    2768:	00009301 	andeq	r9, r0, r1, lsl #6
    276c:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    2770:	000003c7 	andeq	r0, r0, r7, asr #7
    2774:	001def0b 	andseq	lr, sp, fp, lsl #30
    2778:	410b0000 	mrsmi	r0, (UNDEF: 11)
    277c:	0100001a 	tsteq	r0, sl, lsl r0
    2780:	0029c50b 	eoreq	ip, r9, fp, lsl #10
    2784:	580b0200 	stmdapl	fp, {r9}
    2788:	03000028 	movweq	r0, #40	; 0x28
    278c:	001e0f0b 	andseq	r0, lr, fp, lsl #30
    2790:	f90b0400 			; <UNDEFINED> instruction: 0xf90b0400
    2794:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2798:	001eb80b 	andseq	fp, lr, fp, lsl #16
    279c:	ff0b0600 			; <UNDEFINED> instruction: 0xff0b0600
    27a0:	0700001d 	smladeq	r0, sp, r0, r0
    27a4:	0026ec0b 	eoreq	lr, r6, fp, lsl #24
    27a8:	3d0b0800 	stccc	8, cr0, [fp, #-0]
    27ac:	09000028 	stmdbeq	r0, {r3, r5}
    27b0:	0026230b 	eoreq	r2, r6, fp, lsl #6
    27b4:	4c0b0a00 			; <UNDEFINED> instruction: 0x4c0b0a00
    27b8:	0b00001b 	bleq	282c <shift+0x282c>
    27bc:	001e590b 	andseq	r5, lr, fp, lsl #18
    27c0:	c20b0c00 	andgt	r0, fp, #0, 24
    27c4:	0d00001a 	stceq	0, cr0, [r0, #-104]	; 0xffffff98
    27c8:	0029fa0b 	eoreq	pc, r9, fp, lsl #20
    27cc:	ef0b0e00 	svc	0x000b0e00
    27d0:	0f000022 	svceq	0x00000022
    27d4:	001fcc0b 	andseq	ip, pc, fp, lsl #24
    27d8:	2c0b1000 	stccs	0, cr1, [fp], {-0}
    27dc:	11000023 	tstne	r0, r3, lsr #32
    27e0:	0029190b 	eoreq	r1, r9, fp, lsl #18
    27e4:	0f0b1200 	svceq	0x000b1200
    27e8:	1300001c 	movwne	r0, #28
    27ec:	001fdf0b 	andseq	sp, pc, fp, lsl #30
    27f0:	420b1400 	andmi	r1, fp, #0, 8
    27f4:	15000022 	strne	r0, [r0, #-34]	; 0xffffffde
    27f8:	001dda0b 	andseq	sp, sp, fp, lsl #20
    27fc:	8e0b1600 	cfmadd32hi	mvax0, mvfx1, mvfx11, mvfx0
    2800:	17000022 	strne	r0, [r0, -r2, lsr #32]
    2804:	0020a40b 	eoreq	sl, r0, fp, lsl #8
    2808:	170b1800 	strne	r1, [fp, -r0, lsl #16]
    280c:	1900001b 	stmdbne	r0, {r0, r1, r3, r4}
    2810:	0028c00b 	eoreq	ip, r8, fp
    2814:	0e0b1a00 	vmlaeq.f32	s2, s22, s0
    2818:	1b000022 	blne	28a8 <shift+0x28a8>
    281c:	001fb60b 	andseq	fp, pc, fp, lsl #12
    2820:	ec0b1c00 	stc	12, cr1, [fp], {-0}
    2824:	1d000019 	stcne	0, cr0, [r0, #-100]	; 0xffffff9c
    2828:	0021590b 	eoreq	r5, r1, fp, lsl #18
    282c:	450b1e00 	strmi	r1, [fp, #-3584]	; 0xfffff200
    2830:	1f000021 	svcne	0x00000021
    2834:	0025e00b 	eoreq	lr, r5, fp
    2838:	6b0b2000 	blvs	2ca840 <__bss_end+0x2c0ce0>
    283c:	21000026 	tstcs	r0, r6, lsr #32
    2840:	00289f0b 	eoreq	r9, r8, fp, lsl #30
    2844:	e90b2200 	stmdb	fp, {r9, sp}
    2848:	2300001e 	movwcs	r0, #30
    284c:	0024430b 	eoreq	r4, r4, fp, lsl #6
    2850:	380b2400 	stmdacc	fp, {sl, sp}
    2854:	25000026 	strcs	r0, [r0, #-38]	; 0xffffffda
    2858:	00255c0b 	eoreq	r5, r5, fp, lsl #24
    285c:	700b2600 	andvc	r2, fp, r0, lsl #12
    2860:	27000025 	strcs	r0, [r0, -r5, lsr #32]
    2864:	0025840b 	eoreq	r8, r5, fp, lsl #8
    2868:	9a0b2800 	bls	2cc870 <__bss_end+0x2c2d10>
    286c:	2900001c 	stmdbcs	r0, {r2, r3, r4}
    2870:	001bfa0b 	andseq	pc, fp, fp, lsl #20
    2874:	220b2a00 	andcs	r2, fp, #0, 20
    2878:	2b00001c 	blcs	28f0 <shift+0x28f0>
    287c:	0027350b 	eoreq	r3, r7, fp, lsl #10
    2880:	770b2c00 	strvc	r2, [fp, -r0, lsl #24]
    2884:	2d00001c 	stccs	0, cr0, [r0, #-112]	; 0xffffff90
    2888:	0027490b 	eoreq	r4, r7, fp, lsl #18
    288c:	5d0b2e00 	stcpl	14, cr2, [fp, #-0]
    2890:	2f000027 	svccs	0x00000027
    2894:	0027710b 	eoreq	r7, r7, fp, lsl #2
    2898:	6b0b3000 	blvs	2ce8a0 <__bss_end+0x2c4d40>
    289c:	3100001e 	tstcc	r0, lr, lsl r0
    28a0:	001e450b 	andseq	r4, lr, fp, lsl #10
    28a4:	6d0b3200 	sfmvs	f3, 4, [fp, #-0]
    28a8:	33000021 	movwcc	r0, #33	; 0x21
    28ac:	00233f0b 	eoreq	r3, r3, fp, lsl #30
    28b0:	4e0b3400 	cfcpysmi	mvf3, mvf11
    28b4:	35000029 	strcc	r0, [r0, #-41]	; 0xffffffd7
    28b8:	0019940b 	andseq	r9, r9, fp, lsl #8
    28bc:	6b0b3600 	blvs	2d00c4 <__bss_end+0x2c6564>
    28c0:	3700001f 	smladcc	r0, pc, r0, r0	; <UNPREDICTABLE>
    28c4:	001f800b 	andseq	r8, pc, fp
    28c8:	cf0b3800 	svcgt	0x000b3800
    28cc:	39000021 	stmdbcc	r0, {r0, r5}
    28d0:	0021f90b 	eoreq	pc, r1, fp, lsl #18
    28d4:	770b3a00 	strvc	r3, [fp, -r0, lsl #20]
    28d8:	3b000029 	blcc	2984 <shift+0x2984>
    28dc:	00242e0b 	eoreq	r2, r4, fp, lsl #28
    28e0:	0e0b3c00 	cdpeq	12, 0, cr3, cr11, cr0, {0}
    28e4:	3d00001f 	stccc	0, cr0, [r0, #-124]	; 0xffffff84
    28e8:	001a530b 	andseq	r5, sl, fp, lsl #6
    28ec:	110b3e00 	tstne	fp, r0, lsl #28
    28f0:	3f00001a 	svccc	0x0000001a
    28f4:	00238b0b 	eoreq	r8, r3, fp, lsl #22
    28f8:	af0b4000 	svcge	0x000b4000
    28fc:	41000024 	tstmi	r0, r4, lsr #32
    2900:	0025c20b 	eoreq	ip, r5, fp, lsl #4
    2904:	e40b4200 	str	r4, [fp], #-512	; 0xfffffe00
    2908:	43000021 	movwmi	r0, #33	; 0x21
    290c:	0029b00b 	eoreq	fp, r9, fp
    2910:	590b4400 	stmdbpl	fp, {sl, lr}
    2914:	45000024 	strmi	r0, [r0, #-36]	; 0xffffffdc
    2918:	001c3e0b 	andseq	r3, ip, fp, lsl #28
    291c:	bf0b4600 	svclt	0x000b4600
    2920:	47000022 	strmi	r0, [r0, -r2, lsr #32]
    2924:	0020f20b 	eoreq	pc, r0, fp, lsl #4
    2928:	d00b4800 	andle	r4, fp, r0, lsl #16
    292c:	49000019 	stmdbmi	r0, {r0, r3, r4}
    2930:	001ae40b 	andseq	lr, sl, fp, lsl #8
    2934:	220b4a00 	andcs	r4, fp, #0, 20
    2938:	4b00001f 	blmi	29bc <shift+0x29bc>
    293c:	0022200b 	eoreq	r2, r2, fp
    2940:	03004c00 	movweq	r4, #3072	; 0xc00
    2944:	11880702 	orrne	r0, r8, r2, lsl #14
    2948:	e40c0000 	str	r0, [ip], #-0
    294c:	d9000003 	stmdble	r0, {r0, r1}
    2950:	0d000003 	stceq	0, cr0, [r0, #-12]
    2954:	03ce0e00 	biceq	r0, lr, #0, 28
    2958:	04050000 	streq	r0, [r5], #-0
    295c:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2960:	0003de0e 	andeq	sp, r3, lr, lsl #28
    2964:	08010300 	stmdaeq	r1, {r8, r9}
    2968:	00000ff7 	strdeq	r0, [r0], -r7
    296c:	0003e90e 	andeq	lr, r3, lr, lsl #18
    2970:	1b880f00 	blne	fe206578 <__bss_end+0xfe1fca18>
    2974:	4c040000 	stcmi	0, cr0, [r4], {-0}
    2978:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    297c:	a60f0000 	strge	r0, [pc], -r0
    2980:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    2984:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    2988:	0c000003 	stceq	0, cr0, [r0], {3}
    298c:	000003e9 	andeq	r0, r0, r9, ror #7
    2990:	0000041a 	andeq	r0, r0, sl, lsl r4
    2994:	9109000d 	tstls	r9, sp
    2998:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    299c:	040f0d2d 	streq	r0, [pc], #-3373	; 29a4 <shift+0x29a4>
    29a0:	19090000 	stmdbne	r9, {}	; <UNPREDICTABLE>
    29a4:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    29a8:	01e61c38 	mvneq	r1, r8, lsr ip
    29ac:	7f0a0000 	svcvc	0x000a0000
    29b0:	0700001e 	smladeq	r0, lr, r0, r0
    29b4:	00009301 	andeq	r9, r0, r1, lsl #6
    29b8:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    29bc:	000004a5 	andeq	r0, r0, r5, lsr #9
    29c0:	0019e50b 	andseq	lr, r9, fp, lsl #10
    29c4:	910b0000 	mrsls	r0, (UNDEF: 11)
    29c8:	01000020 	tsteq	r0, r0, lsr #32
    29cc:	00292b0b 	eoreq	r2, r9, fp, lsl #22
    29d0:	ee0b0200 	cdp	2, 0, cr0, cr11, cr0, {0}
    29d4:	03000028 	movweq	r0, #40	; 0x28
    29d8:	0023e80b 	eoreq	lr, r3, fp, lsl #16
    29dc:	a90b0400 	stmdbge	fp, {sl}
    29e0:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    29e4:	001bcb0b 	andseq	ip, fp, fp, lsl #22
    29e8:	ad0b0600 	stcge	6, cr0, [fp, #-0]
    29ec:	0700001b 	smladeq	r0, fp, r0, r0
    29f0:	001dc60b 	andseq	ip, sp, fp, lsl #12
    29f4:	a40b0800 	strge	r0, [fp], #-2048	; 0xfffff800
    29f8:	09000022 	stmdbeq	r0, {r1, r5}
    29fc:	001bd20b 	andseq	sp, fp, fp, lsl #4
    2a00:	ab0b0a00 	blge	2c5208 <__bss_end+0x2bb6a8>
    2a04:	0b000022 	bleq	2a94 <shift+0x2a94>
    2a08:	001c370b 	andseq	r3, ip, fp, lsl #14
    2a0c:	c40b0c00 	strgt	r0, [fp], #-3072	; 0xfffff400
    2a10:	0d00001b 	stceq	0, cr0, [r0, #-108]	; 0xffffff94
    2a14:	0027000b 	eoreq	r0, r7, fp
    2a18:	cd0b0e00 	stcgt	14, cr0, [fp, #-0]
    2a1c:	0f000024 	svceq	0x00000024
    2a20:	25f80400 	ldrbcs	r0, [r8, #1024]!	; 0x400
    2a24:	3f050000 	svccc	0x00050000
    2a28:	00043201 	andeq	r3, r4, r1, lsl #4
    2a2c:	268c0900 	strcs	r0, [ip], r0, lsl #18
    2a30:	41050000 	mrsmi	r0, (UNDEF: 5)
    2a34:	0004a50f 	andeq	sl, r4, pc, lsl #10
    2a38:	27140900 	ldrcs	r0, [r4, -r0, lsl #18]
    2a3c:	4a050000 	bmi	142a44 <__bss_end+0x138ee4>
    2a40:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a44:	1b6c0900 	blne	1b04e4c <__bss_end+0x1afb2ec>
    2a48:	4b050000 	blmi	142a50 <__bss_end+0x138ef0>
    2a4c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a50:	27ed1000 	strbcs	r1, [sp, r0]!
    2a54:	25090000 	strcs	r0, [r9, #-0]
    2a58:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2a5c:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    2a60:	04050000 	streq	r0, [r5], #-0
    2a64:	000004d5 	ldrdeq	r0, [r0], -r5
    2a68:	205b0911 	subscs	r0, fp, r1, lsl r9
    2a6c:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    2a70:	0004f90f 	andeq	pc, r4, pc, lsl #18
    2a74:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    2a78:	12000004 	andne	r0, r0, #4
    2a7c:	0000260e 	andeq	r2, r0, lr, lsl #12
    2a80:	0023d509 	eoreq	sp, r3, r9, lsl #10
    2a84:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    2a88:	00000510 	andeq	r0, r0, r0, lsl r5
    2a8c:	04ff0405 	ldrbteq	r0, [pc], #1029	; 2a94 <shift+0x2a94>
    2a90:	e3130000 	tst	r3, #0
    2a94:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    2a98:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    2a9c:	00000541 	andeq	r0, r0, r1, asr #10
    2aa0:	00219a14 	eoreq	r9, r1, r4, lsl sl
    2aa4:	01690500 	cmneq	r9, r0, lsl #10
    2aa8:	0003de0f 	andeq	sp, r3, pc, lsl #28
    2aac:	c7140000 	ldrgt	r0, [r4, -r0]
    2ab0:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2ab4:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    2ab8:	04000005 	streq	r0, [r0], #-5
    2abc:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    2ac0:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    2ac4:	56000000 	strpl	r0, [r0], -r0
    2ac8:	15000005 	strne	r0, [r0, #-5]
    2acc:	00000024 	andeq	r0, r0, r4, lsr #32
    2ad0:	410c002d 	tstmi	ip, sp, lsr #32
    2ad4:	61000005 	tstvs	r0, r5
    2ad8:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    2adc:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    2ae0:	c90f0000 	stmdbgt	pc, {}	; <UNPREDICTABLE>
    2ae4:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2ae8:	6103016b 	tstvs	r3, fp, ror #2
    2aec:	0f000005 	svceq	0x00000005
    2af0:	0000230f 	andeq	r2, r0, pc, lsl #6
    2af4:	0c016e05 	stceq	14, cr6, [r1], {5}
    2af8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2afc:	00264c16 	eoreq	r4, r6, r6, lsl ip
    2b00:	93010700 	movwls	r0, #5888	; 0x1700
    2b04:	05000000 	streq	r0, [r0, #-0]
    2b08:	2a060181 	bcs	183114 <__bss_end+0x1795b4>
    2b0c:	0b000006 	bleq	2b2c <shift+0x2b2c>
    2b10:	00001a7a 	andeq	r1, r0, sl, ror sl
    2b14:	1a860b00 	bne	fe18571c <__bss_end+0xfe17bbbc>
    2b18:	0b020000 	bleq	82b20 <__bss_end+0x78fc0>
    2b1c:	00001a92 	muleq	r0, r2, sl
    2b20:	1eab0b03 	vfmane.f64	d0, d11, d3
    2b24:	0b030000 	bleq	c2b2c <__bss_end+0xb8fcc>
    2b28:	00001a9e 	muleq	r0, lr, sl
    2b2c:	1ff40b04 	svcne	0x00f40b04
    2b30:	0b040000 	bleq	102b38 <__bss_end+0xf8fd8>
    2b34:	000020da 	ldrdeq	r2, [r0], -sl
    2b38:	20300b05 	eorscs	r0, r0, r5, lsl #22
    2b3c:	0b050000 	bleq	142b44 <__bss_end+0x138fe4>
    2b40:	00001b5d 	andeq	r1, r0, sp, asr fp
    2b44:	1aaa0b05 	bne	fea85760 <__bss_end+0xfea7bc00>
    2b48:	0b060000 	bleq	182b50 <__bss_end+0x178ff0>
    2b4c:	00002258 	andeq	r2, r0, r8, asr r2
    2b50:	1cb90b06 	vldmiane	r9!, {d0-d2}
    2b54:	0b060000 	bleq	182b5c <__bss_end+0x178ffc>
    2b58:	00002265 	andeq	r2, r0, r5, ror #4
    2b5c:	26cc0b06 	strbcs	r0, [ip], r6, lsl #22
    2b60:	0b060000 	bleq	182b68 <__bss_end+0x179008>
    2b64:	00002272 	andeq	r2, r0, r2, ror r2
    2b68:	22b20b06 	adcscs	r0, r2, #6144	; 0x1800
    2b6c:	0b060000 	bleq	182b74 <__bss_end+0x179014>
    2b70:	00001ab6 			; <UNDEFINED> instruction: 0x00001ab6
    2b74:	23b80b07 			; <UNDEFINED> instruction: 0x23b80b07
    2b78:	0b070000 	bleq	1c2b80 <__bss_end+0x1b9020>
    2b7c:	00002405 	andeq	r2, r0, r5, lsl #8
    2b80:	27070b07 	strcs	r0, [r7, -r7, lsl #22]
    2b84:	0b070000 	bleq	1c2b8c <__bss_end+0x1b902c>
    2b88:	00001c8c 	andeq	r1, r0, ip, lsl #25
    2b8c:	24860b07 	strcs	r0, [r6], #2823	; 0xb07
    2b90:	0b080000 	bleq	202b98 <__bss_end+0x1f9038>
    2b94:	00001a2f 	andeq	r1, r0, pc, lsr #20
    2b98:	26da0b08 	ldrbcs	r0, [sl], r8, lsl #22
    2b9c:	0b080000 	bleq	202ba4 <__bss_end+0x1f9044>
    2ba0:	000024a2 	andeq	r2, r0, r2, lsr #9
    2ba4:	400f0008 	andmi	r0, pc, r8
    2ba8:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2bac:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    2bb0:	0f000005 	svceq	0x00000005
    2bb4:	000024d4 	ldrdeq	r2, [r0], -r4
    2bb8:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    2bbc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2bc0:	0020e70f 	eoreq	lr, r0, pc, lsl #14
    2bc4:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    2bc8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2bcc:	2a0c0f00 	bcs	3067d4 <__bss_end+0x2fcc74>
    2bd0:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    2bd4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2bd8:	7c0f0000 	stcvc	0, cr0, [pc], {-0}
    2bdc:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2be0:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    2be4:	0f000000 	svceq	0x00000000
    2be8:	000024de 	ldrdeq	r2, [r0], -lr
    2bec:	0c01ae05 	stceq	14, cr10, [r1], {5}
    2bf0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2bf4:	0023ef0f 	eoreq	lr, r3, pc, lsl #30
    2bf8:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    2bfc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c00:	23fa0f00 	mvnscs	r0, #0, 30
    2c04:	b4050000 	strlt	r0, [r5], #-0
    2c08:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c0c:	e80f0000 	stmda	pc, {}	; <UNPREDICTABLE>
    2c10:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2c14:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    2c18:	0f000000 	svceq	0x00000000
    2c1c:	00002234 	andeq	r2, r0, r4, lsr r2
    2c20:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    2c24:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c28:	00296b0f 	eoreq	r6, r9, pc, lsl #22
    2c2c:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    2c30:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c34:	24f20f00 	ldrbtcs	r0, [r2], #3840	; 0xf00
    2c38:	c0050000 	andgt	r0, r5, r0
    2c3c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c40:	2f0f0000 	svccs	0x000f0000
    2c44:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    2c48:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    2c4c:	0f000000 	svceq	0x00000000
    2c50:	000028f5 	strdeq	r2, [r0], -r5
    2c54:	0c01c605 	stceq	6, cr12, [r1], {5}
    2c58:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c5c:	0029010f 	eoreq	r0, r9, pc, lsl #2
    2c60:	01c90500 	biceq	r0, r9, r0, lsl #10
    2c64:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c68:	290d0f00 	stmdbcs	sp, {r8, r9, sl, fp}
    2c6c:	cc050000 	stcgt	0, cr0, [r5], {-0}
    2c70:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c74:	320f0000 	andcc	r0, pc, #0
    2c78:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2c7c:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    2c80:	0f000000 	svceq	0x00000000
    2c84:	00002a22 	andeq	r2, r0, r2, lsr #20
    2c88:	0c01d305 	stceq	3, cr13, [r1], {5}
    2c8c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c90:	001bd90f 	andseq	sp, fp, pc, lsl #18
    2c94:	01d60500 	bicseq	r0, r6, r0, lsl #10
    2c98:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c9c:	19c00f00 	stmibne	r0, {r8, r9, sl, fp}^
    2ca0:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    2ca4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2ca8:	cb0f0000 	blgt	3c2cb0 <__bss_end+0x3b9150>
    2cac:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2cb0:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    2cb4:	0f000000 	svceq	0x00000000
    2cb8:	00001bb4 			; <UNDEFINED> instruction: 0x00001bb4
    2cbc:	0c01df05 	stceq	15, cr13, [r1], {5}
    2cc0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cc4:	0025080f 	eoreq	r0, r5, pc, lsl #16
    2cc8:	01e20500 	mvneq	r0, r0, lsl #10
    2ccc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cd0:	21100f00 	tstcs	r0, r0, lsl #30
    2cd4:	e5050000 	str	r0, [r5, #-0]
    2cd8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cdc:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    2ce0:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2ce4:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    2ce8:	0f000000 	svceq	0x00000000
    2cec:	00002822 	andeq	r2, r0, r2, lsr #16
    2cf0:	0c01ef05 	stceq	15, cr14, [r1], {5}
    2cf4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cf8:	0029da0f 	eoreq	sp, r9, pc, lsl #20
    2cfc:	01f20500 	mvnseq	r0, r0, lsl #10
    2d00:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d04:	29ea0f00 	stmibcs	sl!, {r8, r9, sl, fp}^
    2d08:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    2d0c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d10:	d00f0000 	andle	r0, pc, r0
    2d14:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2d18:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    2d1c:	0f000000 	svceq	0x00000000
    2d20:	00002869 	andeq	r2, r0, r9, ror #16
    2d24:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    2d28:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d2c:	00246e0f 	eoreq	r6, r4, pc, lsl #28
    2d30:	01fe0500 	mvnseq	r0, r0, lsl #10
    2d34:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d38:	1f440f00 	svcne	0x00440f00
    2d3c:	02050000 	andeq	r0, r5, #0
    2d40:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2d44:	5e0f0000 	cdppl	0, 0, cr0, cr15, cr0, {0}
    2d48:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    2d4c:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    2d50:	0f000000 	svceq	0x00000000
    2d54:	00001e37 	andeq	r1, r0, r7, lsr lr
    2d58:	0c020d05 	stceq	13, cr0, [r2], {5}
    2d5c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d60:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d64:	0007ef00 	andeq	lr, r7, r0, lsl #30
    2d68:	0f000d00 	svceq	0x00000d00
    2d6c:	00002010 	andeq	r2, r0, r0, lsl r0
    2d70:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    2d74:	000007e4 	andeq	r0, r0, r4, ror #15
    2d78:	0004e60c 	andeq	lr, r4, ip, lsl #12
    2d7c:	00080c00 	andeq	r0, r8, r0, lsl #24
    2d80:	00241500 	eoreq	r1, r4, r0, lsl #10
    2d84:	000d0000 	andeq	r0, sp, r0
    2d88:	00252b0f 	eoreq	r2, r5, pc, lsl #22
    2d8c:	05840500 	streq	r0, [r4, #1280]	; 0x500
    2d90:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    2d94:	20d21600 	sbcscs	r1, r2, r0, lsl #12
    2d98:	01070000 	mrseq	r0, (UNDEF: 7)
    2d9c:	00000093 	muleq	r0, r3, r0
    2da0:	06058b05 	streq	r8, [r5], -r5, lsl #22
    2da4:	00000857 	andeq	r0, r0, r7, asr r8
    2da8:	001e8d0b 	andseq	r8, lr, fp, lsl #26
    2dac:	dd0b0000 	stcle	0, cr0, [fp, #-0]
    2db0:	01000022 	tsteq	r0, r2, lsr #32
    2db4:	001a650b 	andseq	r6, sl, fp, lsl #10
    2db8:	9c0b0200 	sfmls	f0, 4, [fp], {-0}
    2dbc:	03000029 	movweq	r0, #41	; 0x29
    2dc0:	0025a50b 	eoreq	sl, r5, fp, lsl #10
    2dc4:	980b0400 	stmdals	fp, {sl}
    2dc8:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2dcc:	001b3c0b 	andseq	r3, fp, fp, lsl #24
    2dd0:	0f000600 	svceq	0x00000600
    2dd4:	0000298c 	andeq	r2, r0, ip, lsl #19
    2dd8:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    2ddc:	00000819 	andeq	r0, r0, r9, lsl r8
    2de0:	00288e0f 	eoreq	r8, r8, pc, lsl #28
    2de4:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    2de8:	00002411 	andeq	r2, r0, r1, lsl r4
    2dec:	25180f00 	ldrcs	r0, [r8, #-3840]	; 0xfffff100
    2df0:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2df4:	001d0c07 	andseq	r0, sp, r7, lsl #24
    2df8:	01040000 	mrseq	r0, (UNDEF: 4)
    2dfc:	06000028 	streq	r0, [r0], -r8, lsr #32
    2e00:	0093167b 	addseq	r1, r3, fp, ror r6
    2e04:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    2e08:	03000008 	movweq	r0, #8
    2e0c:	0d870502 	cfstr32eq	mvfx0, [r7, #8]
    2e10:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2e14:	001e2007 	andseq	r2, lr, r7
    2e18:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    2e1c:	00001bf4 	strdeq	r1, [r0], -r4
    2e20:	ec030803 	stc	8, cr0, [r3], {3}
    2e24:	0300001b 	movweq	r0, #27
    2e28:	25010408 	strcs	r0, [r1, #-1032]	; 0xfffffbf8
    2e2c:	10030000 	andne	r0, r3, r0
    2e30:	0025b303 	eoreq	fp, r5, r3, lsl #6
    2e34:	088a0c00 	stmeq	sl, {sl, fp}
    2e38:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    2e3c:	24150000 	ldrcs	r0, [r5], #-0
    2e40:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    2e44:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    2e48:	120f0000 	andne	r0, pc, #0
    2e4c:	06000024 	streq	r0, [r0], -r4, lsr #32
    2e50:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    2e54:	0f000008 	svceq	0x00000008
    2e58:	00001ba3 	andeq	r1, r0, r3, lsr #23
    2e5c:	16020206 	strne	r0, [r2], -r6, lsl #4
    2e60:	000008c9 	andeq	r0, r0, r9, asr #17
    2e64:	00283404 	eoreq	r3, r8, r4, lsl #8
    2e68:	102a0700 	eorne	r0, sl, r0, lsl #14
    2e6c:	000004f9 	strdeq	r0, [r0], -r9
    2e70:	0008e80c 	andeq	lr, r8, ip, lsl #16
    2e74:	0008ff00 	andeq	pc, r8, r0, lsl #30
    2e78:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2e7c:	00000357 	andeq	r0, r0, r7, asr r3
    2e80:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    2e84:	09000008 	stmdbeq	r0, {r3}
    2e88:	0000020c 	andeq	r0, r0, ip, lsl #4
    2e8c:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    2e90:	17000008 	strne	r0, [r0, -r8]
    2e94:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2e98:	0a093308 	beq	24fac0 <__bss_end+0x245f60>
    2e9c:	9b450305 	blls	1143ab8 <__bss_end+0x1139f58>
    2ea0:	0b170000 	bleq	5c2ea8 <__bss_end+0x5b9348>
    2ea4:	08000009 	stmdaeq	r0, {r0, r3}
    2ea8:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    2eac:	009b4503 	addseq	r4, fp, r3, lsl #10
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3770b4>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb91bc>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb91dc>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb91f4>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x234>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79d34>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39218>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7148>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6594>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9df8>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4db0>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b65c0>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6634>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3771b0>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb92b0>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79dec>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe392d0>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb92e8>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79e20>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4e5c>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3772a0>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7268>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb9388>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	0b002405 	bleq	9234 <_Z11split_floatfRjS_Ri+0x3d8>
 21c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 220:	06000008 	streq	r0, [r0], -r8
 224:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 228:	0b3b0b3a 	bleq	ec2f18 <__bss_end+0xeb93b8>
 22c:	13490b39 	movtne	r0, #39737	; 0x9b39
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b9ef0>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb93d0>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f72f4>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7ccbc>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb93f8>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b9368>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79f4c>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe39430>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb46c>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4f8c>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79f84>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe39468>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x3773f0>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe79fb4>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe39498>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a168>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x377424>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b6824>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe7a004>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe394e8>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb9500>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x377490>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a050>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe39534>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb570>
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
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c509c>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb9574>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c50d8>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377520>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb95bc>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 438:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 43c:	03193f01 	tsteq	r9, #1, 30
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c5120>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 44c:	96184006 	ldrls	r4, [r8], -r6
 450:	13011942 	movwne	r1, #6466	; 0x1942
 454:	052a0000 	streq	r0, [sl, #-0]!
 458:	3a0e0300 	bcc	381060 <__bss_end+0x377500>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 464:	2b000018 	blcs	4cc <shift+0x4cc>
 468:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeb95fc>
 470:	13490b39 	movtne	r0, #39737	; 0x9b39
 474:	00001802 	andeq	r1, r0, r2, lsl #16
 478:	3f012e2c 	svccc	0x00012e2c
 47c:	3a0e0319 	bcc	3810e8 <__bss_end+0x377588>
 480:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 484:	110e6e0b 	tstne	lr, fp, lsl #28
 488:	40061201 	andmi	r1, r6, r1, lsl #4
 48c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 490:	01000000 	mrseq	r0, (UNDEF: 0)
 494:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 498:	0e030b13 	vmoveq.32	d3[0], r0
 49c:	01110e1b 	tsteq	r1, fp, lsl lr
 4a0:	17100612 			; <UNDEFINED> instruction: 0x17100612
 4a4:	24020000 	strcs	r0, [r2], #-0
 4a8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4ac:	000e030b 	andeq	r0, lr, fp, lsl #6
 4b0:	00260300 	eoreq	r0, r6, r0, lsl #6
 4b4:	00001349 	andeq	r1, r0, r9, asr #6
 4b8:	0b002404 	bleq	94d0 <_Z4ftoafPcj+0xb4>
 4bc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4c0:	05000008 	streq	r0, [r0, #-8]
 4c4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 4c8:	0b3b0b3a 	bleq	ec31b8 <__bss_end+0xeb9658>
 4cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 4d0:	13060000 	movwne	r0, #24576	; 0x6000
 4d4:	0b0e0301 	bleq	3810e0 <__bss_end+0x377580>
 4d8:	3b0b3a0b 	blcc	2ced0c <__bss_end+0x2c51ac>
 4dc:	010b390b 	tsteq	fp, fp, lsl #18
 4e0:	07000013 	smladeq	r0, r3, r0, r0
 4e4:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 4e8:	0b3b0b3a 	bleq	ec31d8 <__bss_end+0xeb9678>
 4ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 4f0:	00000b38 	andeq	r0, r0, r8, lsr fp
 4f4:	03010408 	movweq	r0, #5128	; 0x1408
 4f8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 4fc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 500:	3b0b3a13 	blcc	2ced54 <__bss_end+0x2c51f4>
 504:	010b390b 	tsteq	fp, fp, lsl #18
 508:	09000013 	stmdbeq	r0, {r0, r1, r4}
 50c:	08030028 	stmdaeq	r3, {r3, r5}
 510:	00000b1c 	andeq	r0, r0, ip, lsl fp
 514:	0300280a 	movweq	r2, #2058	; 0x80a
 518:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 51c:	00340b00 	eorseq	r0, r4, r0, lsl #22
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe7a1d4>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe396b8>
 528:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 52c:	00001802 	andeq	r1, r0, r2, lsl #16
 530:	0300020c 	movweq	r0, #524	; 0x20c
 534:	00193c0e 	andseq	r3, r9, lr, lsl #24
 538:	01020d00 	tsteq	r2, r0, lsl #26
 53c:	0b0b0e03 	bleq	2c3d50 <__bss_end+0x2ba1f0>
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeb96d0>
 544:	13010b39 	movwne	r0, #6969	; 0x1b39
 548:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 54c:	3a0e0300 	bcc	381154 <__bss_end+0x3775f4>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 558:	0f00000b 	svceq	0x0000000b
 55c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 560:	0b3a0e03 	bleq	e83d74 <__bss_end+0xe7a214>
 564:	0b390b3b 	bleq	e43258 <__bss_end+0xe396f8>
 568:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 56c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 570:	05100000 	ldreq	r0, [r0, #-0]
 574:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 578:	11000019 	tstne	r0, r9, lsl r0
 57c:	13490005 	movtne	r0, #36869	; 0x9005
 580:	0d120000 	ldceq	0, cr0, [r2, #-0]
 584:	3a0e0300 	bcc	38118c <__bss_end+0x37762c>
 588:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 58c:	3f13490b 	svccc	0x0013490b
 590:	00193c19 	andseq	r3, r9, r9, lsl ip
 594:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 598:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 59c:	0b3b0b3a 	bleq	ec328c <__bss_end+0xeb972c>
 5a0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5a4:	0b321349 	bleq	c852d0 <__bss_end+0xc7b770>
 5a8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5ac:	00001301 	andeq	r1, r0, r1, lsl #6
 5b0:	3f012e14 	svccc	0x00012e14
 5b4:	3a0e0319 	bcc	381220 <__bss_end+0x3776c0>
 5b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5bc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 5c0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb9760>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	0b321349 	bleq	c85304 <__bss_end+0xc7b7a4>
 5dc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5e0:	01160000 	tsteq	r6, r0
 5e4:	01134901 	tsteq	r3, r1, lsl #18
 5e8:	17000013 	smladne	r0, r3, r0, r0
 5ec:	13490021 	movtne	r0, #36897	; 0x9021
 5f0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 5f4:	0b000f18 	bleq	425c <shift+0x425c>
 5f8:	0013490b 	andseq	r4, r3, fp, lsl #18
 5fc:	00211900 	eoreq	r1, r1, r0, lsl #18
 600:	341a0000 	ldrcc	r0, [sl], #-0
 604:	3a0e0300 	bcc	38120c <__bss_end+0x3776ac>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	3f13490b 	svccc	0x0013490b
 610:	00193c19 	andseq	r3, r9, r9, lsl ip
 614:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 618:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 61c:	0b3b0b3a 	bleq	ec330c <__bss_end+0xeb97ac>
 620:	0e6e0b39 	vmoveq.8	d14[5], r0
 624:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 628:	00001301 	andeq	r1, r0, r1, lsl #6
 62c:	3f012e1c 	svccc	0x00012e1c
 630:	3a0e0319 	bcc	38129c <__bss_end+0x37773c>
 634:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 638:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 63c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 640:	00130113 	andseq	r0, r3, r3, lsl r1
 644:	000d1d00 	andeq	r1, sp, r0, lsl #26
 648:	0b3a0e03 	bleq	e83e5c <__bss_end+0xe7a2fc>
 64c:	0b390b3b 	bleq	e43340 <__bss_end+0xe397e0>
 650:	0b381349 	bleq	e0537c <__bss_end+0xdfb81c>
 654:	00000b32 	andeq	r0, r0, r2, lsr fp
 658:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
 65c:	01136413 	tsteq	r3, r3, lsl r4
 660:	1f000013 	svcne	0x00000013
 664:	131d001f 	tstne	sp, #31
 668:	00001349 	andeq	r1, r0, r9, asr #6
 66c:	0b001020 	bleq	46f4 <shift+0x46f4>
 670:	0013490b 	andseq	r4, r3, fp, lsl #18
 674:	000f2100 	andeq	r2, pc, r0, lsl #2
 678:	00000b0b 	andeq	r0, r0, fp, lsl #22
 67c:	03003422 	movweq	r3, #1058	; 0x422
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c5360>
 684:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 688:	00180213 	andseq	r0, r8, r3, lsl r2
 68c:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 690:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 694:	0b3b0b3a 	bleq	ec3384 <__bss_end+0xeb9824>
 698:	0e6e0b39 	vmoveq.8	d14[5], r0
 69c:	01111349 	tsteq	r1, r9, asr #6
 6a0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6a4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6a8:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 6ac:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb9840>
 6b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6b8:	00001802 	andeq	r1, r0, r2, lsl #16
 6bc:	3f012e25 	svccc	0x00012e25
 6c0:	3a0e0319 	bcc	38132c <__bss_end+0x3777cc>
 6c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6c8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 6cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	34260000 	strtcc	r0, [r6], #-0
 6dc:	3a080300 	bcc	2012e4 <__bss_end+0x1f7784>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6e8:	27000018 	smladcs	r0, r8, r0, r0
 6ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6f0:	0b3a0e03 	bleq	e83f04 <__bss_end+0xe7a3a4>
 6f4:	0b390b3b 	bleq	e433e8 <__bss_end+0xe39888>
 6f8:	01110e6e 	tsteq	r1, lr, ror #28
 6fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 700:	01194297 			; <UNDEFINED> instruction: 0x01194297
 704:	28000013 	stmdacs	r0, {r0, r1, r4}
 708:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7a3c0>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe398a4>
 714:	01110e6e 	tsteq	r1, lr, ror #28
 718:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 71c:	00194297 	mulseq	r9, r7, r2
 720:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 724:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 728:	0b3b0b3a 	bleq	ec3418 <__bss_end+0xeb98b8>
 72c:	0e6e0b39 	vmoveq.8	d14[5], r0
 730:	01111349 	tsteq	r1, r9, asr #6
 734:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 738:	00194297 	mulseq	r9, r7, r2
 73c:	11010000 	mrsne	r0, (UNDEF: 1)
 740:	130e2501 	movwne	r2, #58625	; 0xe501
 744:	1b0e030b 	blne	381378 <__bss_end+0x377818>
 748:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 74c:	00171006 	andseq	r1, r7, r6
 750:	00340200 	eorseq	r0, r4, r0, lsl #4
 754:	0b3a0e03 	bleq	e83f68 <__bss_end+0xe7a408>
 758:	0b390b3b 	bleq	e4344c <__bss_end+0xe398ec>
 75c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 760:	00001802 	andeq	r1, r0, r2, lsl #16
 764:	0b002403 	bleq	9778 <_Z4atofPKc+0x38>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0400000e 	streq	r0, [r0], #-14
 770:	13490026 	movtne	r0, #36902	; 0x9026
 774:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 778:	00130101 	andseq	r0, r3, r1, lsl #2
 77c:	00340600 	eorseq	r0, r4, r0, lsl #12
 780:	0b3a0e03 	bleq	e83f94 <__bss_end+0xe7a434>
 784:	0b390b3b 	bleq	e43478 <__bss_end+0xe39918>
 788:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 78c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 790:	3a003a07 	bcc	efb4 <__bss_end+0x5454>
 794:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 798:	0013180b 	andseq	r1, r3, fp, lsl #16
 79c:	01010800 	tsteq	r1, r0, lsl #16
 7a0:	13011349 	movwne	r1, #4937	; 0x1349
 7a4:	21090000 	mrscs	r0, (UNDEF: 9)
 7a8:	2f134900 	svccs	0x00134900
 7ac:	0a00000b 	beq	7e0 <shift+0x7e0>
 7b0:	13470034 	movtne	r0, #28724	; 0x7034
 7b4:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
 7b8:	03193f01 	tsteq	r9, #1, 30
 7bc:	3b0b3a0e 	blcc	2ceffc <__bss_end+0x2c549c>
 7c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7c4:	1113490e 	tstne	r3, lr, lsl #18
 7c8:	40061201 	andmi	r1, r6, r1, lsl #4
 7cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 7d0:	00001301 	andeq	r1, r0, r1, lsl #6
 7d4:	0300050c 	movweq	r0, #1292	; 0x50c
 7d8:	3b0b3a08 	blcc	2cf000 <__bss_end+0x2c54a0>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	00340d00 	eorseq	r0, r4, r0, lsl #26
 7e8:	0b3a0803 	bleq	e827fc <__bss_end+0xe78c9c>
 7ec:	0b390b3b 	bleq	e434e0 <__bss_end+0xe39980>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	340e0000 	strcc	r0, [lr], #-0
 7f8:	3a0e0300 	bcc	381400 <__bss_end+0x3778a0>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 804:	0f000018 	svceq	0x00000018
 808:	0111010b 	tsteq	r1, fp, lsl #2
 80c:	00000612 	andeq	r0, r0, r2, lsl r6
 810:	03003410 	movweq	r3, #1040	; 0x410
 814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c54f4>
 818:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 81c:	00180213 	andseq	r0, r8, r3, lsl r2
 820:	00341100 	eorseq	r1, r4, r0, lsl #2
 824:	0b3a0803 	bleq	e82838 <__bss_end+0xe78cd8>
 828:	0b39053b 	bleq	e41d1c <__bss_end+0xe381bc>
 82c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 830:	0f120000 	svceq	0x00120000
 834:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 838:	13000013 	movwne	r0, #19
 83c:	0b0b0024 	bleq	2c08d4 <__bss_end+0x2b6d74>
 840:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 844:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 848:	03193f01 	tsteq	r9, #1, 30
 84c:	3b0b3a0e 	blcc	2cf08c <__bss_end+0x2c552c>
 850:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 854:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 858:	96184006 	ldrls	r4, [r8], -r6
 85c:	13011942 	movwne	r1, #6466	; 0x1942
 860:	05150000 	ldreq	r0, [r5, #-0]
 864:	3a0e0300 	bcc	38146c <__bss_end+0x37790c>
 868:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 86c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 870:	16000018 			; <UNDEFINED> instruction: 0x16000018
 874:	0111010b 	tsteq	r1, fp, lsl #2
 878:	13010612 	movwne	r0, #5650	; 0x1612
 87c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 880:	03193f01 	tsteq	r9, #1, 30
 884:	3b0b3a0e 	blcc	2cf0c4 <__bss_end+0x2c5564>
 888:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 88c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 890:	97184006 	ldrls	r4, [r8, -r6]
 894:	13011942 	movwne	r1, #6466	; 0x1942
 898:	10180000 	andsne	r0, r8, r0
 89c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 8a0:	19000013 	stmdbne	r0, {r0, r1, r4}
 8a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8a8:	0b3a0803 	bleq	e828bc <__bss_end+0xe78d5c>
 8ac:	0b390b3b 	bleq	e435a0 <__bss_end+0xe39a40>
 8b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 8b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 8bc:	00130119 	andseq	r0, r3, r9, lsl r1
 8c0:	00261a00 	eoreq	r1, r6, r0, lsl #20
 8c4:	0f1b0000 	svceq	0x001b0000
 8c8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 8cc:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 8d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8d4:	0b3b0b3a 	bleq	ec35c4 <__bss_end+0xeb9a64>
 8d8:	0e6e0b39 	vmoveq.8	d14[5], r0
 8dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 8e4:	00000019 	andeq	r0, r0, r9, lsl r0
 8e8:	10001101 	andne	r1, r0, r1, lsl #2
 8ec:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 8f0:	1b0e0301 	blne	3814fc <__bss_end+0x37799c>
 8f4:	130e250e 	movwne	r2, #58638	; 0xe50e
 8f8:	00000005 	andeq	r0, r0, r5
 8fc:	10001101 	andne	r1, r0, r1, lsl #2
 900:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 904:	1b0e0301 	blne	381510 <__bss_end+0x3779b0>
 908:	130e250e 	movwne	r2, #58638	; 0xe50e
 90c:	00000005 	andeq	r0, r0, r5
 910:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 914:	030b130e 	movweq	r1, #45838	; 0xb30e
 918:	100e1b0e 	andne	r1, lr, lr, lsl #22
 91c:	02000017 	andeq	r0, r0, #23
 920:	0b0b0024 	bleq	2c09b8 <__bss_end+0x2b6e58>
 924:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 928:	24030000 	strcs	r0, [r3], #-0
 92c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 930:	000e030b 	andeq	r0, lr, fp, lsl #6
 934:	00160400 	andseq	r0, r6, r0, lsl #8
 938:	0b3a0e03 	bleq	e8414c <__bss_end+0xe7a5ec>
 93c:	0b390b3b 	bleq	e43630 <__bss_end+0xe39ad0>
 940:	00001349 	andeq	r1, r0, r9, asr #6
 944:	0b000f05 	bleq	4560 <shift+0x4560>
 948:	0013490b 	andseq	r4, r3, fp, lsl #18
 94c:	01150600 	tsteq	r5, r0, lsl #12
 950:	13491927 	movtne	r1, #39207	; 0x9927
 954:	00001301 	andeq	r1, r0, r1, lsl #6
 958:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 95c:	08000013 	stmdaeq	r0, {r0, r1, r4}
 960:	00000026 	andeq	r0, r0, r6, lsr #32
 964:	03003409 	movweq	r3, #1033	; 0x409
 968:	3b0b3a0e 	blcc	2cf1a8 <__bss_end+0x2c5648>
 96c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 970:	3c193f13 	ldccc	15, cr3, [r9], {19}
 974:	0a000019 	beq	9e0 <shift+0x9e0>
 978:	0e030104 	adfeqs	f0, f3, f4
 97c:	0b0b0b3e 	bleq	2c367c <__bss_end+0x2b9b1c>
 980:	0b3a1349 	bleq	e856ac <__bss_end+0xe7bb4c>
 984:	0b390b3b 	bleq	e43678 <__bss_end+0xe39b18>
 988:	00001301 	andeq	r1, r0, r1, lsl #6
 98c:	0300280b 	movweq	r2, #2059	; 0x80b
 990:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 994:	01010c00 	tsteq	r1, r0, lsl #24
 998:	13011349 	movwne	r1, #4937	; 0x1349
 99c:	210d0000 	mrscs	r0, (UNDEF: 13)
 9a0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 9a4:	13490026 	movtne	r0, #36902	; 0x9026
 9a8:	340f0000 	strcc	r0, [pc], #-0	; 9b0 <shift+0x9b0>
 9ac:	3a0e0300 	bcc	3815b4 <__bss_end+0x377a54>
 9b0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9b4:	3f13490b 	svccc	0x0013490b
 9b8:	00193c19 	andseq	r3, r9, r9, lsl ip
 9bc:	00131000 	andseq	r1, r3, r0
 9c0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 9c4:	15110000 	ldrne	r0, [r1, #-0]
 9c8:	00192700 	andseq	r2, r9, r0, lsl #14
 9cc:	00171200 	andseq	r1, r7, r0, lsl #4
 9d0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 9d4:	13130000 	tstne	r3, #0
 9d8:	0b0e0301 	bleq	3815e4 <__bss_end+0x377a84>
 9dc:	3b0b3a0b 	blcc	2cf210 <__bss_end+0x2c56b0>
 9e0:	010b3905 	tsteq	fp, r5, lsl #18
 9e4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 9e8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 9ec:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 9f4:	00000b38 	andeq	r0, r0, r8, lsr fp
 9f8:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 9fc:	000b2f13 	andeq	r2, fp, r3, lsl pc
 a00:	01041600 	tsteq	r4, r0, lsl #12
 a04:	0b3e0e03 	bleq	f84218 <__bss_end+0xf7a6b8>
 a08:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 a0c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a10:	13010b39 	movwne	r0, #6969	; 0x1b39
 a14:	34170000 	ldrcc	r0, [r7], #-0
 a18:	3a134700 	bcc	4d2620 <__bss_end+0x4c8ac0>
 a1c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a20:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  74:	000001ec 	andeq	r0, r0, ip, ror #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	113a0002 	teqne	sl, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008418 	andeq	r8, r0, r8, lsl r4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1e330002 	cdpne	0, 3, cr0, cr3, cr2, {0}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008874 	andeq	r8, r0, r4, ror r8
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	25300002 	ldrcs	r0, [r0, #-2]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009850 	andeq	r9, r0, r0, asr r8
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	25560002 	ldrbcs	r0, [r6, #-2]
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009a5c 	andeq	r9, r0, ip, asr sl
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	257c0002 	ldrbcs	r0, [ip, #-2]!
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff63ec>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6191>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff6193>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4ea8>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff62e1>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be818>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfdc4>
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
     39c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     3a0:	5f676e69 	svcpl	0x00676e69
     3a4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3a8:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     3ac:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     3b0:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     3b4:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     3b8:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     3bc:	5f007974 	svcpl	0x00007974
     3c0:	314b4e5a 	cmpcc	fp, sl, asr lr
     3c4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3c8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3cc:	614d5f73 	hvcvs	54771	; 0xd5f3
     3d0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     3d4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     3d8:	505f7465 	subspl	r7, pc, r5, ror #8
     3dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3e0:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     3e4:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     3e8:	006a4544 	rsbeq	r4, sl, r4, asr #10
     3ec:	314e5a5f 	cmpcc	lr, pc, asr sl
     3f0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3f8:	614d5f73 	hvcvs	54771	; 0xd5f3
     3fc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     400:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     404:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     408:	5f656c69 	svcpl	0x00656c69
     40c:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     410:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     414:	5045746e 	subpl	r7, r5, lr, ror #8
     418:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     41c:	5500656c 	strpl	r6, [r0, #-1388]	; 0xfffffa94
     420:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     424:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     428:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     42c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     430:	5a5f0074 	bpl	17c0608 <__bss_end+0x17b6aa8>
     434:	33314b4e 	teqcc	r1, #79872	; 0x13800
     438:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     43c:	61485f4f 	cmpvs	r8, pc, asr #30
     440:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     444:	47383172 			; <UNDEFINED> instruction: 0x47383172
     448:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     44c:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     450:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     454:	6f697461 	svcvs	0x00697461
     458:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     45c:	5f30536a 	svcpl	0x0030536a
     460:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     464:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     468:	5f4f4950 	svcpl	0x004f4950
     46c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     470:	3172656c 	cmncc	r2, ip, ror #10
     474:	73655231 	cmnvc	r5, #268435459	; 0x10000003
     478:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     47c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     480:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     484:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     488:	6f635f74 	svcvs	0x00635f74
     48c:	67006564 	strvs	r6, [r0, -r4, ror #10]
     490:	445f5346 	ldrbmi	r5, [pc], #-838	; 498 <shift+0x498>
     494:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     498:	48007372 	stmdami	r0, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
     49c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4a0:	72505f65 	subsvc	r5, r0, #404	; 0x194
     4a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a8:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     4ac:	65470049 	strbvs	r0, [r7, #-73]	; 0xffffffb7
     4b0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     4b4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     4b8:	5f72656c 	svcpl	0x0072656c
     4bc:	6f666e49 	svcvs	0x00666e49
     4c0:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     4c4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     4c8:	6f545f65 	svcvs	0x00545f65
     4cc:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4d0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4d4:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
     4d8:	00656962 	rsbeq	r6, r5, r2, ror #18
     4dc:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     4e0:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     4e4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     4e8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     4ec:	736f7300 	cmnvc	pc, #0, 6
     4f0:	64656c5f 	strbtvs	r6, [r5], #-3167	; 0xfffff3a1
     4f4:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     4f8:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     4fc:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     500:	00656c64 	rsbeq	r6, r5, r4, ror #24
     504:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     508:	00676e69 	rsbeq	r6, r7, r9, ror #28
     50c:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     510:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     514:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     518:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     51c:	5f006465 	svcpl	0x00006465
     520:	31314e5a 	teqcc	r1, sl, asr lr
     524:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     528:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     52c:	316d6574 	smccc	54868	; 0xd654
     530:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     534:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     538:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     53c:	6f6d0076 	svcvs	0x006d0076
     540:	50746e75 	rsbspl	r6, r4, r5, ror lr
     544:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     548:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     54c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     550:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     554:	6f72505f 	svcvs	0x0072505f
     558:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     55c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     560:	61425f4f 	cmpvs	r2, pc, asr #30
     564:	5f006573 	svcpl	0x00006573
     568:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     56c:	6f725043 	svcvs	0x00725043
     570:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     574:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     578:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     57c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     580:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     584:	6f72505f 	svcvs	0x0072505f
     588:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     58c:	6a685045 	bvs	1a146a8 <__bss_end+0x1a0ab48>
     590:	65530062 	ldrbvs	r0, [r3, #-98]	; 0xffffff9e
     594:	61505f74 	cmpvs	r0, r4, ror pc
     598:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     59c:	65727000 	ldrbvs	r7, [r2, #-0]!
     5a0:	5a5f0076 	bpl	17c0780 <__bss_end+0x17b6c20>
     5a4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     5a8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     5ac:	61485f4f 	cmpvs	r8, pc, asr #30
     5b0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5b4:	47363272 			; <UNDEFINED> instruction: 0x47363272
     5b8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     5bc:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     5c0:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     5c4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     5c8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     5cc:	6f697461 	svcvs	0x00697461
     5d0:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     5d4:	50474e30 	subpl	r4, r7, r0, lsr lr
     5d8:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     5dc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     5e0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     5e4:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     5e8:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     5ec:	5f005f31 	svcpl	0x00005f31
     5f0:	314b4e5a 	cmpcc	fp, sl, asr lr
     5f4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5f8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5fc:	614d5f73 	hvcvs	54771	; 0xd5f3
     600:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     604:	47393172 			; <UNDEFINED> instruction: 0x47393172
     608:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     60c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     610:	505f746e 	subspl	r7, pc, lr, ror #8
     614:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     618:	76457373 			; <UNDEFINED> instruction: 0x76457373
     61c:	53465400 	movtpl	r5, #25600	; 0x6400
     620:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
     624:	6f4e5f65 	svcvs	0x004e5f65
     628:	53006564 	movwpl	r6, #1380	; 0x564
     62c:	4f5f7465 	svcmi	0x005f7465
     630:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     634:	72640074 	rsbvc	r0, r4, #116	; 0x74
     638:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     63c:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     640:	61655200 	cmnvs	r5, r0, lsl #4
     644:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     648:	7300796c 	movwvc	r7, #2412	; 0x96c
     64c:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     650:	696c625f 	stmdbvs	ip!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
     654:	4d006b6e 	vstrmi	d6, [r0, #-440]	; 0xfffffe48
     658:	505f7861 	subspl	r7, pc, r1, ror #16
     65c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     660:	4f5f7373 	svcmi	0x005f7373
     664:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     668:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     66c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     670:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     674:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     678:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     67c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     680:	50433631 	subpl	r3, r3, r1, lsr r6
     684:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     688:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c4 <shift+0x4c4>
     68c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     690:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     694:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     698:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     69c:	6f4e0076 	svcvs	0x004e0076
     6a0:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6a4:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     6a8:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     6ac:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     6b0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     6b4:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     6b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6bc:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     6c0:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     6c4:	69750044 	ldmdbvs	r5!, {r2, r6}^
     6c8:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     6cc:	5f00745f 	svcpl	0x0000745f
     6d0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6d4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     6d8:	61485f4f 	cmpvs	r8, pc, asr #30
     6dc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6e0:	65473972 	strbvs	r3, [r7, #-2418]	; 0xfffff68e
     6e4:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     6e8:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     6ec:	5a5f006a 	bpl	17c089c <__bss_end+0x17b6d3c>
     6f0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     6f4:	4f495047 	svcmi	0x00495047
     6f8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     6fc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     700:	65533031 	ldrbvs	r3, [r3, #-49]	; 0xffffffcf
     704:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff798 <__bss_end+0xffff5c38>
     708:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     70c:	00626a45 	rsbeq	r6, r2, r5, asr #20
     710:	434f494e 	movtmi	r4, #63822	; 0xf94e
     714:	4f5f6c74 	svcmi	0x005f6c74
     718:	61726570 	cmnvs	r2, r0, ror r5
     71c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     720:	43534200 	cmpmi	r3, #0, 4
     724:	61425f31 	cmpvs	r2, r1, lsr pc
     728:	57006573 	smlsdxpl	r0, r3, r5, r6
     72c:	00746961 	rsbseq	r6, r4, r1, ror #18
     730:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     734:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     738:	00657461 	rsbeq	r7, r5, r1, ror #8
     73c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     740:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     744:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     748:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     74c:	6c420046 	mcrrvs	0, 4, r0, r2, cr6
     750:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     754:	436d0064 	cmnmi	sp, #100	; 0x64
     758:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     75c:	545f746e 	ldrbpl	r7, [pc], #-1134	; 764 <shift+0x764>
     760:	5f6b7361 	svcpl	0x006b7361
     764:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     768:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     76c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     770:	5f4f4950 	svcpl	0x004f4950
     774:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     778:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     77c:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     780:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     784:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     788:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     78c:	0079616c 	rsbseq	r6, r9, ip, ror #2
     790:	6f6f526d 	svcvs	0x006f526d
     794:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     798:	5a5f0076 	bpl	17c0978 <__bss_end+0x17b6e18>
     79c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7a0:	636f7250 	cmnvs	pc, #80, 4
     7a4:	5f737365 	svcpl	0x00737365
     7a8:	616e614d 	cmnvs	lr, sp, asr #2
     7ac:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     7b0:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     7b4:	545f6863 	ldrbpl	r6, [pc], #-2147	; 7bc <shift+0x7bc>
     7b8:	3150456f 	cmpcc	r0, pc, ror #10
     7bc:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     7c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7c4:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7c8:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     7cc:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7d0:	5f6e6970 	svcpl	0x006e6970
     7d4:	00786469 	rsbseq	r6, r8, r9, ror #8
     7d8:	5f757063 	svcpl	0x00757063
     7dc:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     7e0:	00747865 	rsbseq	r7, r4, r5, ror #16
     7e4:	4950476d 	ldmdbmi	r0, {r0, r2, r3, r5, r6, r8, r9, sl, lr}^
     7e8:	7243004f 	subvc	r0, r3, #79	; 0x4f
     7ec:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     7f0:	6f72505f 	svcvs	0x0072505f
     7f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7fc:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     800:	4f495047 	svcmi	0x00495047
     804:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     808:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     80c:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     810:	50475f74 	subpl	r5, r7, r4, ror pc
     814:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     818:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     81c:	6f697461 	svcvs	0x00697461
     820:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     824:	5f30536a 	svcpl	0x0030536a
     828:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     82c:	7369006e 	cmnvc	r9, #110	; 0x6e
     830:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     834:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     838:	65470079 	strbvs	r0, [r7, #-121]	; 0xffffff87
     83c:	50475f74 	subpl	r5, r7, r4, ror pc
     840:	5f524c43 	svcpl	0x00524c43
     844:	61636f4c 	cmnvs	r3, ip, asr #30
     848:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     84c:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     850:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     854:	00657361 	rsbeq	r7, r5, r1, ror #6
     858:	5f534667 	svcpl	0x00534667
     85c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     860:	5f737265 	svcpl	0x00737265
     864:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     868:	47730074 			; <UNDEFINED> instruction: 0x47730074
     86c:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     870:	5f746547 	svcpl	0x00746547
     874:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     878:	6f4c5f53 	svcvs	0x004c5f53
     87c:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     880:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
     884:	6f747475 	svcvs	0x00747475
     888:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     88c:	50475f74 	subpl	r5, r7, r4, ror pc
     890:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     894:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     898:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     89c:	314e5a5f 	cmpcc	lr, pc, asr sl
     8a0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8a8:	614d5f73 	hvcvs	54771	; 0xd5f3
     8ac:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8b0:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     8b4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     8b8:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     8bc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8c0:	31504573 	cmpcc	r0, r3, ror r5
     8c4:	61545432 	cmpvs	r4, r2, lsr r4
     8c8:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     8cc:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     8d0:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     8d4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     8d8:	5f646568 	svcpl	0x00646568
     8dc:	6f666e49 	svcvs	0x00666e49
     8e0:	434f4900 	movtmi	r4, #63744	; 0xf900
     8e4:	54006c74 	strpl	r6, [r0], #-3188	; 0xfffff38c
     8e8:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     8ec:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     8f0:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     8f4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     8f8:	6f4e0065 	svcvs	0x004e0065
     8fc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     900:	6f72505f 	svcvs	0x0072505f
     904:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     908:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     90c:	50433631 	subpl	r3, r3, r1, lsr r6
     910:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     914:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 750 <shift+0x750>
     918:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     91c:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     920:	5f007645 	svcpl	0x00007645
     924:	314b4e5a 	cmpcc	fp, sl, asr lr
     928:	50474333 	subpl	r4, r7, r3, lsr r3
     92c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     930:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     934:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     938:	5f746547 	svcpl	0x00746547
     93c:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     940:	6f4c5f54 	svcvs	0x004c5f54
     944:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     948:	6a456e6f 	bvs	115c30c <__bss_end+0x11527ac>
     94c:	30536a52 	subscc	r6, r3, r2, asr sl
     950:	4c6d005f 	stclmi	0, cr0, [sp], #-380	; 0xfffffe84
     954:	006b636f 	rsbeq	r6, fp, pc, ror #6
     958:	6f6f526d 	svcvs	0x006f526d
     95c:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     960:	5a5f0074 	bpl	17c0b38 <__bss_end+0x17b6fd8>
     964:	33314b4e 	teqcc	r1, #79872	; 0x13800
     968:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     96c:	61485f4f 	cmpvs	r8, pc, asr #30
     970:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     974:	47323272 			; <UNDEFINED> instruction: 0x47323272
     978:	445f7465 	ldrbmi	r7, [pc], #-1125	; 980 <shift+0x980>
     97c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     980:	5f646574 	svcpl	0x00646574
     984:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     988:	69505f74 	ldmdbvs	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     98c:	0076456e 	rsbseq	r4, r6, lr, ror #10
     990:	314e5a5f 	cmpcc	lr, pc, asr sl
     994:	50474333 	subpl	r4, r7, r3, lsr r3
     998:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     99c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9a0:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     9a4:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     9a8:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 444 <shift+0x444>
     9ac:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     9b0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     9b4:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     9b8:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     9bc:	4f495047 	svcmi	0x00495047
     9c0:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     9c4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     9c8:	545f7470 	ldrbpl	r7, [pc], #-1136	; 9d0 <shift+0x9d0>
     9cc:	00657079 	rsbeq	r7, r5, r9, ror r0
     9d0:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     9d4:	64007966 	strvs	r7, [r0], #-2406	; 0xfffff69a
     9d8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     9dc:	6c430072 	mcrrvs	0, 7, r0, r3, cr2
     9e0:	5f726165 	svcpl	0x00726165
     9e4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     9e8:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     9ec:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     9f0:	4800746e 	stmdami	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     9f4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9f8:	52495f65 	subpl	r5, r9, #404	; 0x194
     9fc:	614d0051 	qdaddvs	r0, r1, sp
     a00:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     a04:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     a08:	00687467 	rsbeq	r7, r8, r7, ror #8
     a0c:	4b4e5a5f 	blmi	1397390 <__bss_end+0x138d830>
     a10:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     a14:	5f4f4950 	svcpl	0x004f4950
     a18:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a1c:	3172656c 	cmncc	r2, ip, ror #10
     a20:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     a24:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     a28:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     a2c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     a30:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     a34:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     a38:	4d005f30 	stcmi	15, cr5, [r0, #-192]	; 0xffffff40
     a3c:	53467861 	movtpl	r7, #26721	; 0x6861
     a40:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     a44:	614e7265 	cmpvs	lr, r5, ror #4
     a48:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     a4c:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     a50:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     a54:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     a58:	76726573 			; <UNDEFINED> instruction: 0x76726573
     a5c:	6f697461 	svcvs	0x00697461
     a60:	575f736e 	ldrbpl	r7, [pc, -lr, ror #6]
     a64:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     a68:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a6c:	50433631 	subpl	r3, r3, r1, lsr r6
     a70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a74:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 8b0 <shift+0x8b0>
     a78:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a7c:	31317265 	teqcc	r1, r5, ror #4
     a80:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a84:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     a88:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     a8c:	474e0076 	smlsldxmi	r0, lr, r6, r0
     a90:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     a94:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a98:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     a9c:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa0:	73006570 	movwvc	r6, #1392	; 0x570
     aa4:	7065656c 	rsbvc	r6, r5, ip, ror #10
     aa8:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     aac:	47007265 	strmi	r7, [r0, -r5, ror #4]
     ab0:	5f4f4950 	svcpl	0x004f4950
     ab4:	5f6e6950 	svcpl	0x006e6950
     ab8:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     abc:	61740074 	cmnvs	r4, r4, ror r0
     ac0:	57006b73 	smlsdxpl	r0, r3, fp, r6
     ac4:	5f746961 	svcpl	0x00746961
     ac8:	5f726f46 	svcpl	0x00726f46
     acc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     ad0:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     ad4:	50475f74 	subpl	r5, r7, r4, ror pc
     ad8:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     adc:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     ae0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     ae4:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 964 <shift+0x964>
     ae8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     aec:	50433631 	subpl	r3, r3, r1, lsr r6
     af0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     af4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 930 <shift+0x930>
     af8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     afc:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b00:	5f746547 	svcpl	0x00746547
     b04:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b08:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b0c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     b10:	32456f66 	subcc	r6, r5, #408	; 0x198
     b14:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     b18:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b1c:	5f646568 	svcpl	0x00646568
     b20:	6f666e49 	svcvs	0x00666e49
     b24:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     b28:	00765065 	rsbseq	r5, r6, r5, rrx
     b2c:	474e5254 	smlsldmi	r5, lr, r4, r2
     b30:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     b34:	65440065 	strbvs	r0, [r4, #-101]	; 0xffffff9b
     b38:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     b3c:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     b40:	5f6b636f 	svcpl	0x006b636f
     b44:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     b48:	6f526d00 	svcvs	0x00526d00
     b4c:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     b50:	47007379 	smlsdxmi	r0, r9, r3, r7
     b54:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     b58:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     b5c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     b60:	6f697461 	svcvs	0x00697461
     b64:	506d006e 	rsbpl	r0, sp, lr, rrx
     b68:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b6c:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     b70:	5f747369 	svcpl	0x00747369
     b74:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     b78:	63536d00 	cmpvs	r3, #0, 26
     b7c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b80:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     b84:	5f00636e 	svcpl	0x0000636e
     b88:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b8c:	6f725043 	svcvs	0x00725043
     b90:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b94:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b98:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b9c:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     ba0:	5f6b636f 	svcpl	0x006b636f
     ba4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     ba8:	5f746e65 	svcpl	0x00746e65
     bac:	636f7250 	cmnvs	pc, #80, 4
     bb0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     bb4:	576d0076 			; <UNDEFINED> instruction: 0x576d0076
     bb8:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     bbc:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     bc0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     bc4:	636f4c00 	cmnvs	pc, #0, 24
     bc8:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     bcc:	6b636f6c 	blvs	18dc984 <__bss_end+0x18d2e24>
     bd0:	6d006465 	cfstrsvs	mvf6, [r0, #-404]	; 0xfffffe6c
     bd4:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     bd8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     bdc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     be0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     be4:	5f4f4950 	svcpl	0x004f4950
     be8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     bec:	3172656c 	cmncc	r2, ip, ror #10
     bf0:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     bf4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     bf8:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     bfc:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     c00:	6a456e6f 	bvs	115c5c4 <__bss_end+0x1152a64>
     c04:	474e3431 	smlaldxmi	r3, lr, r1, r4
     c08:	5f4f4950 	svcpl	0x004f4950
     c0c:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     c10:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c14:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c18:	706e495f 	rsbvc	r4, lr, pc, asr r9
     c1c:	5f007475 	svcpl	0x00007475
     c20:	6c62355a 	cfstr64vs	mvdx3, [r2], #-360	; 0xfffffe98
     c24:	626b6e69 	rsbvs	r6, fp, #1680	; 0x690
     c28:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c2c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     c30:	73656c69 	cmnvc	r5, #26880	; 0x6900
     c34:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     c38:	704f346d 	subvc	r3, pc, sp, ror #8
     c3c:	50456e65 	subpl	r6, r5, r5, ror #28
     c40:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     c44:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     c48:	704f5f65 	subvc	r5, pc, r5, ror #30
     c4c:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; ac0 <shift+0xac0>
     c50:	0065646f 	rsbeq	r6, r5, pc, ror #8
     c54:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     c58:	545f6863 	ldrbpl	r6, [pc], #-2147	; c60 <shift+0xc60>
     c5c:	6c43006f 	mcrrvs	0, 6, r0, r3, cr15
     c60:	0065736f 	rsbeq	r7, r5, pc, ror #6
     c64:	314e5a5f 	cmpcc	lr, pc, asr sl
     c68:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c6c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c70:	614d5f73 	hvcvs	54771	; 0xd5f3
     c74:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c78:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     c7c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c80:	5f656c75 	svcpl	0x00656c75
     c84:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     c88:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     c8c:	50475f74 	subpl	r5, r7, r4, ror pc
     c90:	5f56454c 	svcpl	0x0056454c
     c94:	61636f4c 	cmnvs	r3, ip, asr #30
     c98:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c9c:	43534200 	cmpmi	r3, #0, 4
     ca0:	61425f30 	cmpvs	r2, r0, lsr pc
     ca4:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     ca8:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     cac:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     cb0:	61006567 	tstvs	r0, r7, ror #10
     cb4:	00636772 	rsbeq	r6, r3, r2, ror r7
     cb8:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     cbc:	5f657672 	svcpl	0x00657672
     cc0:	006e6950 	rsbeq	r6, lr, r0, asr r9
     cc4:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     cc8:	746f6e00 	strbtvc	r6, [pc], #-3584	; cd0 <shift+0xcd0>
     ccc:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     cd0:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     cd4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     cd8:	6100656e 	tstvs	r0, lr, ror #10
     cdc:	00766772 	rsbseq	r6, r6, r2, ror r7
     ce0:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     ce4:	5f676e69 	svcpl	0x00676e69
     ce8:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     cec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cf0:	46433131 			; <UNDEFINED> instruction: 0x46433131
     cf4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     cf8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     cfc:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     d00:	5a5f0076 	bpl	17c0ee0 <__bss_end+0x17b7380>
     d04:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d08:	636f7250 	cmnvs	pc, #80, 4
     d0c:	5f737365 	svcpl	0x00737365
     d10:	616e614d 	cmnvs	lr, sp, asr #2
     d14:	31726567 	cmncc	r2, r7, ror #10
     d18:	746f4e34 	strbtvc	r4, [pc], #-3636	; d20 <shift+0xd20>
     d1c:	5f796669 	svcpl	0x00796669
     d20:	636f7250 	cmnvs	pc, #80, 4
     d24:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     d28:	6f4e006a 	svcvs	0x004e006a
     d2c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d30:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     d34:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     d38:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     d3c:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     d40:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     d44:	00745f6b 	rsbseq	r5, r4, fp, ror #30
     d48:	5f746547 	svcpl	0x00746547
     d4c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d50:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     d54:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d58:	505f746e 	subspl	r7, pc, lr, ror #8
     d5c:	44006e69 	strmi	r6, [r0], #-3689	; 0xfffff197
     d60:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     d64:	00656e69 	rsbeq	r6, r5, r9, ror #28
     d68:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     d6c:	4400746e 	strmi	r7, [r0], #-1134	; 0xfffffb92
     d70:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     d74:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 810 <shift+0x810>
     d78:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d7c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     d80:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     d84:	73006e6f 	movwvc	r6, #3695	; 0xe6f
     d88:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     d8c:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     d90:	74726900 	ldrbtvc	r6, [r2], #-2304	; 0xfffff700
     d94:	00657079 	rsbeq	r7, r5, r9, ror r0
     d98:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     d9c:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     da0:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     da4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     da8:	526d0068 	rsbpl	r0, sp, #104	; 0x68
     dac:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     db0:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     db4:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     db8:	72504300 	subsvc	r4, r0, #0, 6
     dbc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     dc0:	614d5f73 	hvcvs	54771	; 0xd5f3
     dc4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     dc8:	6e550072 	mrcvs	0, 2, r0, cr5, cr2, {3}
     dcc:	63657073 	cmnvs	r5, #115	; 0x73
     dd0:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     dd4:	5a5f0064 	bpl	17c0f6c <__bss_end+0x17b740c>
     dd8:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     ddc:	4f495047 	svcmi	0x00495047
     de0:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     de4:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     de8:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     dec:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     df0:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     df4:	46730062 	ldrbtmi	r0, [r3], -r2, rrx
     df8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     dfc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e00:	6e49006d 	cdpvs	0, 4, cr0, cr9, cr13, {3}
     e04:	61697469 	cmnvs	r9, r9, ror #8
     e08:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     e0c:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     e10:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e14:	00646c69 	rsbeq	r6, r4, r9, ror #24
     e18:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     e1c:	534e0030 	movtpl	r0, #57392	; 0xe030
     e20:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     e24:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e28:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e2c:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     e30:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     e34:	6f6c0065 	svcvs	0x006c0065
     e38:	70697067 	rsbvc	r7, r9, r7, rrx
     e3c:	534e0065 	movtpl	r0, #57445	; 0xe065
     e40:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     e44:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e48:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     e4c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     e50:	6f006563 	svcvs	0x00006563
     e54:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     e58:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e5c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     e60:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     e64:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     e68:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     e6c:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     e70:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e74:	6f72505f 	svcvs	0x0072505f
     e78:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e7c:	5f79425f 	svcpl	0x0079425f
     e80:	00444950 	subeq	r4, r4, r0, asr r9
     e84:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     e88:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 924 <shift+0x924>
     e8c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e90:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e94:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e98:	50006e6f 	andpl	r6, r0, pc, ror #28
     e9c:	70697265 	rsbvc	r7, r9, r5, ror #4
     ea0:	61726568 	cmnvs	r2, r8, ror #10
     ea4:	61425f6c 	cmpvs	r2, ip, ror #30
     ea8:	47006573 	smlsdxmi	r0, r3, r5, r6
     eac:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     eb0:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     eb4:	6f4c5f4c 	svcvs	0x004c5f4c
     eb8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     ebc:	5f006e6f 	svcpl	0x00006e6f
     ec0:	314b4e5a 	cmpcc	fp, sl, asr lr
     ec4:	50474333 	subpl	r4, r7, r3, lsr r3
     ec8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ecc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ed0:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     ed4:	5f746547 	svcpl	0x00746547
     ed8:	4f495047 	svcmi	0x00495047
     edc:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     ee0:	6f697463 	svcvs	0x00697463
     ee4:	006a456e 	rsbeq	r4, sl, lr, ror #10
     ee8:	61766e49 	cmnvs	r6, r9, asr #28
     eec:	5f64696c 	svcpl	0x0064696c
     ef0:	006e6950 	rsbeq	r6, lr, r0, asr r9
     ef4:	314e5a5f 	cmpcc	lr, pc, asr sl
     ef8:	50474333 	subpl	r4, r7, r3, lsr r3
     efc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f00:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f04:	30327265 	eorscc	r7, r2, r5, ror #4
     f08:	61736944 	cmnvs	r3, r4, asr #18
     f0c:	5f656c62 	svcpl	0x00656c62
     f10:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     f14:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     f18:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     f1c:	30326a45 	eorscc	r6, r2, r5, asr #20
     f20:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     f24:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     f28:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     f2c:	5f747075 	svcpl	0x00747075
     f30:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     f34:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     f38:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     f3c:	76726573 			; <UNDEFINED> instruction: 0x76726573
     f40:	6f697461 	svcvs	0x00697461
     f44:	525f736e 	subspl	r7, pc, #-1207959551	; 0xb8000001
     f48:	00646165 	rsbeq	r6, r4, r5, ror #2
     f4c:	6b636f4c 	blvs	18dcc84 <__bss_end+0x18d3124>
     f50:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     f54:	0064656b 	rsbeq	r6, r4, fp, ror #10
     f58:	314e5a5f 	cmpcc	lr, pc, asr sl
     f5c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     f60:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f64:	614d5f73 	hvcvs	54771	; 0xd5f3
     f68:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f6c:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
     f70:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f74:	72505f65 	subsvc	r5, r0, #404	; 0x194
     f78:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f7c:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     f80:	30324549 	eorscc	r4, r2, r9, asr #10
     f84:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     f88:	6f72505f 	svcvs	0x0072505f
     f8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f90:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     f94:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     f98:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     f9c:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     fa0:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     fa4:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     fa8:	5a5f0074 	bpl	17c1180 <__bss_end+0x17b7620>
     fac:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     fb0:	4f495047 	svcmi	0x00495047
     fb4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     fb8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     fbc:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
     fc0:	5f726165 	svcpl	0x00726165
     fc4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     fc8:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     fcc:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     fd0:	6a45746e 	bvs	115e190 <__bss_end+0x1154630>
     fd4:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     fd8:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     fdc:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     fe0:	47007265 	strmi	r7, [r0, -r5, ror #4]
     fe4:	505f7465 	subspl	r7, pc, r5, ror #8
     fe8:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     fec:	6e750073 	mrcvs	0, 3, r0, cr5, cr3, {3}
     ff0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     ff4:	63206465 			; <UNDEFINED> instruction: 0x63206465
     ff8:	00726168 	rsbseq	r6, r2, r8, ror #2
     ffc:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1000:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1004:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    1008:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
    100c:	00706565 	rsbseq	r6, r0, r5, ror #10
    1010:	5f746547 	svcpl	0x00746547
    1014:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
    1018:	445f5152 	ldrbmi	r5, [pc], #-338	; 1020 <shift+0x1020>
    101c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    1020:	6f4c5f74 	svcvs	0x004c5f74
    1024:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    1028:	5f006e6f 	svcpl	0x00006e6f
    102c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    1030:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1034:	61485f4f 	cmpvs	r8, pc, asr #30
    1038:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    103c:	57343172 			; <UNDEFINED> instruction: 0x57343172
    1040:	5f746961 	svcpl	0x00746961
    1044:	5f726f46 	svcpl	0x00726f46
    1048:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    104c:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
    1050:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    1054:	53006a65 	movwpl	r6, #2661	; 0xa65
    1058:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    105c:	5f656c75 	svcpl	0x00656c75
    1060:	41005252 	tstmi	r0, r2, asr r2
    1064:	425f5855 	subsmi	r5, pc, #5570560	; 0x550000
    1068:	00657361 	rsbeq	r7, r5, r1, ror #6
    106c:	32435342 	subcc	r5, r3, #134217729	; 0x8000001
    1070:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    1074:	72570065 	subsvc	r0, r7, #101	; 0x65
    1078:	5f657469 	svcpl	0x00657469
    107c:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
    1080:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    1084:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    1088:	5a5f0065 	bpl	17c1224 <__bss_end+0x17b76c4>
    108c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1090:	4f495047 	svcmi	0x00495047
    1094:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1098:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    109c:	61483031 	cmpvs	r8, r1, lsr r0
    10a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    10a4:	5152495f 	cmppl	r2, pc, asr r9
    10a8:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
    10ac:	5f6b6369 	svcpl	0x006b6369
    10b0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    10b4:	5a5f0074 	bpl	17c128c <__bss_end+0x17b772c>
    10b8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    10bc:	636f7250 	cmnvs	pc, #80, 4
    10c0:	5f737365 	svcpl	0x00737365
    10c4:	616e614d 	cmnvs	lr, sp, asr #2
    10c8:	31726567 	cmncc	r2, r7, ror #10
    10cc:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
    10d0:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
    10d4:	5f656c69 	svcpl	0x00656c69
    10d8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    10dc:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    10e0:	6c41006a 	mcrrvs	0, 6, r0, r1, cr10
    10e4:	00305f74 	eorseq	r5, r0, r4, ror pc
    10e8:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    10ec:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    10f0:	5f6d6574 	svcpl	0x006d6574
    10f4:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    10f8:	41007265 	tstmi	r0, r5, ror #4
    10fc:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
    1100:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1104:	4100335f 	tstmi	r0, pc, asr r3
    1108:	345f746c 	ldrbcc	r7, [pc], #-1132	; 1110 <shift+0x1110>
    110c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1110:	5f00355f 	svcpl	0x0000355f
    1114:	31314e5a 	teqcc	r1, sl, asr lr
    1118:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
    111c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1120:	316d6574 	smccc	54868	; 0xd654
    1124:	53465433 	movtpl	r5, #25651	; 0x6433
    1128:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    112c:	6f4e5f65 	svcvs	0x004e5f65
    1130:	30316564 	eorscc	r6, r1, r4, ror #10
    1134:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
    1138:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
    113c:	5045646c 	subpl	r6, r5, ip, ror #8
    1140:	4800634b 	stmdami	r0, {r0, r1, r3, r6, r8, r9, sp, lr}
    1144:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1148:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    114c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1150:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1154:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1158:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    115c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1160:	4f495047 	svcmi	0x00495047
    1164:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1168:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    116c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1170:	50475f74 	subpl	r5, r7, r4, ror pc
    1174:	5f524c43 	svcpl	0x00524c43
    1178:	61636f4c 	cmnvs	r3, ip, asr #30
    117c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1180:	6a526a45 	bvs	149ba9c <__bss_end+0x1491f3c>
    1184:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1188:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
    118c:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
    1190:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1194:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1198:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    119c:	006e6961 	rsbeq	r6, lr, r1, ror #18
    11a0:	6f725073 	svcvs	0x00725073
    11a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    11a8:	0072674d 	rsbseq	r6, r2, sp, asr #14
    11ac:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    11b0:	61485f4f 	cmpvs	r8, pc, asr #30
    11b4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11b8:	6c410072 	mcrrvs	0, 7, r0, r1, cr2
    11bc:	00315f74 	eorseq	r5, r1, r4, ror pc
    11c0:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
    11c4:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
    11c8:	6f682f00 	svcvs	0x00682f00
    11cc:	6a2f656d 	bvs	bda788 <__bss_end+0xbd0c28>
    11d0:	73656d61 	cmnvc	r5, #6208	; 0x1840
    11d4:	2f697261 	svccs	0x00697261
    11d8:	2f746967 	svccs	0x00746967
    11dc:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    11e0:	6f732f70 	svcvs	0x00732f70
    11e4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    11e8:	73752f73 	cmnvc	r5, #460	; 0x1cc
    11ec:	70737265 	rsbsvc	r7, r3, r5, ror #4
    11f0:	2f656361 	svccs	0x00656361
    11f4:	5f736f73 	svcpl	0x00736f73
    11f8:	6b736174 	blvs	1cd97d0 <__bss_end+0x1ccfc70>
    11fc:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
    1200:	70632e6e 	rsbvc	r2, r3, lr, ror #28
    1204:	69440070 	stmdbvs	r4, {r4, r5, r6}^
    1208:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    120c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1210:	5f746e65 	svcpl	0x00746e65
    1214:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1218:	49007463 	stmdbmi	r0, {r0, r1, r5, r6, sl, ip, sp, lr}
    121c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1220:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1224:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    1228:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 1060 <shift+0x1060>
    122c:	5f72656c 	svcpl	0x0072656c
    1230:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    1234:	53465400 	movtpl	r5, #25600	; 0x6400
    1238:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    123c:	00726576 	rsbseq	r6, r2, r6, ror r5
    1240:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
    1244:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
    1248:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    124c:	4e49464e 	cdpmi	6, 4, cr4, cr9, cr14, {2}
    1250:	00595449 	subseq	r5, r9, r9, asr #8
    1254:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
    1258:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    125c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1260:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
    1264:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1268:	6d797300 	ldclvs	3, cr7, [r9, #-0]
    126c:	5f6c6f62 	svcpl	0x006c6f62
    1270:	6b636974 	blvs	18db848 <__bss_end+0x18d1ce8>
    1274:	6c65645f 	cfstrdvs	mvd6, [r5], #-380	; 0xfffffe84
    1278:	5f007961 	svcpl	0x00007961
    127c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1280:	6f725043 	svcvs	0x00725043
    1284:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1288:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    128c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1290:	61483132 	cmpvs	r8, r2, lsr r1
    1294:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1298:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    129c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    12a0:	5f6d6574 	svcpl	0x006d6574
    12a4:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    12a8:	534e3332 	movtpl	r3, #58162	; 0xe332
    12ac:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    12b0:	73656c69 	cmnvc	r5, #26880	; 0x6900
    12b4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    12b8:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    12bc:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    12c0:	6a6a6a65 	bvs	1a9bc5c <__bss_end+0x1a920fc>
    12c4:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    12c8:	5f495753 	svcpl	0x00495753
    12cc:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    12d0:	4500746c 	strmi	r7, [r0, #-1132]	; 0xfffffb94
    12d4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    12d8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    12dc:	5f746e65 	svcpl	0x00746e65
    12e0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    12e4:	63007463 	movwvs	r7, #1123	; 0x463
    12e8:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    12ec:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    12f0:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
    12f4:	76697461 	strbtvc	r7, [r9], -r1, ror #8
    12f8:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    12fc:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    1300:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    1304:	64720072 	ldrbtvs	r0, [r2], #-114	; 0xffffff8e
    1308:	006d756e 	rsbeq	r7, sp, lr, ror #10
    130c:	31315a5f 	teqcc	r1, pc, asr sl
    1310:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1314:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1318:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
    131c:	315a5f00 	cmpcc	sl, r0, lsl #30
    1320:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    1324:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1328:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    132c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1330:	006a656e 	rsbeq	r6, sl, lr, ror #10
    1334:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1338:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    133c:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1340:	6a6a7966 	bvs	1a9f8e0 <__bss_end+0x1a95d80>
    1344:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1348:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    134c:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1350:	46006965 	strmi	r6, [r0], -r5, ror #18
    1354:	006c6961 	rsbeq	r6, ip, r1, ror #18
    1358:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    135c:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1360:	325a5f00 	subscc	r5, sl, #0, 30
    1364:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1368:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    136c:	5f657669 	svcpl	0x00657669
    1370:	636f7270 	cmnvs	pc, #112, 4
    1374:	5f737365 	svcpl	0x00737365
    1378:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    137c:	73007674 	movwvc	r7, #1652	; 0x674
    1380:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1384:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    1388:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
    138c:	5f6b6369 	svcpl	0x006b6369
    1390:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1394:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1398:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    139c:	50006465 	andpl	r6, r0, r5, ror #8
    13a0:	5f657069 	svcpl	0x00657069
    13a4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    13a8:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
    13ac:	00786966 	rsbseq	r6, r8, r6, ror #18
    13b0:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    13b4:	5f746567 	svcpl	0x00746567
    13b8:	6b636974 	blvs	18db990 <__bss_end+0x18d1e30>
    13bc:	756f635f 	strbvc	r6, [pc, #-863]!	; 1065 <shift+0x1065>
    13c0:	0076746e 	rsbseq	r7, r6, lr, ror #8
    13c4:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    13c8:	65730070 	ldrbvs	r0, [r3, #-112]!	; 0xffffff90
    13cc:	61745f74 	cmnvs	r4, r4, ror pc
    13d0:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 13d8 <shift+0x13d8>
    13d4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    13d8:	00656e69 	rsbeq	r6, r5, r9, ror #28
    13dc:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
    13e0:	6f697461 	svcvs	0x00697461
    13e4:	5a5f006e 	bpl	17c15a4 <__bss_end+0x17b7a44>
    13e8:	6f6c6335 	svcvs	0x006c6335
    13ec:	006a6573 	rsbeq	r6, sl, r3, ror r5
    13f0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 133c <shift+0x133c>
    13f4:	616a2f65 	cmnvs	sl, r5, ror #30
    13f8:	6173656d 	cmnvs	r3, sp, ror #10
    13fc:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    1400:	6f2f7469 	svcvs	0x002f7469
    1404:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    1408:	756f732f 	strbvc	r7, [pc, #-815]!	; 10e1 <shift+0x10e1>
    140c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1410:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1414:	2f62696c 	svccs	0x0062696c
    1418:	2f637273 	svccs	0x00637273
    141c:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1420:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    1424:	00707063 	rsbseq	r7, r0, r3, rrx
    1428:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
    142c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    1430:	66007664 	strvs	r7, [r0], -r4, ror #12
    1434:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1438:	746f6e00 	strbtvc	r6, [pc], #-3584	; 1440 <shift+0x1440>
    143c:	00796669 	rsbseq	r6, r9, r9, ror #12
    1440:	6b636974 	blvs	18dba18 <__bss_end+0x18d1eb8>
    1444:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
    1448:	5f006e65 	svcpl	0x00006e65
    144c:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
    1450:	4b506570 	blmi	141aa18 <__bss_end+0x1410eb8>
    1454:	4e006a63 	vmlsmi.f32	s12, s0, s7
    1458:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
    145c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1460:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
    1464:	76726573 			; <UNDEFINED> instruction: 0x76726573
    1468:	00656369 	rsbeq	r6, r5, r9, ror #6
    146c:	5f746567 	svcpl	0x00746567
    1470:	6b636974 	blvs	18dba48 <__bss_end+0x18d1ee8>
    1474:	756f635f 	strbvc	r6, [pc, #-863]!	; 111d <shift+0x111d>
    1478:	2f00746e 	svccs	0x0000746e
    147c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1480:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    1484:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    1488:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    148c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    1490:	2f70732f 	svccs	0x0070732f
    1494:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1498:	2f736563 	svccs	0x00736563
    149c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    14a0:	61700064 	cmnvs	r0, r4, rrx
    14a4:	006d6172 	rsbeq	r6, sp, r2, ror r1
    14a8:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
    14ac:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    14b0:	634b506a 	movtvs	r5, #45162	; 0xb06a
    14b4:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
    14b8:	61745f74 	cmnvs	r4, r4, ror pc
    14bc:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 14c4 <shift+0x14c4>
    14c0:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    14c4:	5f6f745f 	svcpl	0x006f745f
    14c8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    14cc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    14d0:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
    14d4:	62006574 	andvs	r6, r0, #116, 10	; 0x1d000000
    14d8:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    14dc:	00657a69 	rsbeq	r7, r5, r9, ror #20
    14e0:	73355a5f 	teqvc	r5, #389120	; 0x5f000
    14e4:	7065656c 	rsbvc	r6, r5, ip, ror #10
    14e8:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    14ec:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    14f0:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    14f4:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
    14f8:	325a5f00 	subscc	r5, sl, #0, 30
    14fc:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    1500:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1504:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1508:	5f736b63 	svcpl	0x00736b63
    150c:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 1514 <shift+0x1514>
    1510:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1514:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    1518:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    151c:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    1520:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    1524:	646f435f 	strbtvs	r4, [pc], #-863	; 152c <shift+0x152c>
    1528:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    152c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1530:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    1534:	6a746961 	bvs	1d1bac0 <__bss_end+0x1d11f60>
    1538:	5f006a6a 	svcpl	0x00006a6a
    153c:	6f69355a 	svcvs	0x0069355a
    1540:	6a6c7463 	bvs	1b1e6d4 <__bss_end+0x1b14b74>
    1544:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    1548:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    154c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1550:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1554:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    1558:	636f6900 	cmnvs	pc, #0, 18
    155c:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1560:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    1564:	6f6d0074 	svcvs	0x006d0074
    1568:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    156c:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1570:	5a5f0072 	bpl	17c1740 <__bss_end+0x17b7be0>
    1574:	61657234 	cmnvs	r5, r4, lsr r2
    1578:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    157c:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
    1580:	646f6374 	strbtvs	r6, [pc], #-884	; 1588 <shift+0x1588>
    1584:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1588:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    158c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1590:	6f72705f 	svcvs	0x0072705f
    1594:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1598:	756f635f 	strbvc	r6, [pc, #-863]!	; 1241 <shift+0x1241>
    159c:	6600746e 	strvs	r7, [r0], -lr, ror #8
    15a0:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    15a4:	00656d61 	rsbeq	r6, r5, r1, ror #26
    15a8:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    15ac:	72657400 	rsbvc	r7, r5, #0, 8
    15b0:	616e696d 	cmnvs	lr, sp, ror #18
    15b4:	67006574 	smlsdxvs	r0, r4, r5, r6
    15b8:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    15bc:	5a5f0064 	bpl	17c1754 <__bss_end+0x17b7bf4>
    15c0:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    15c4:	634b506e 	movtvs	r5, #45166	; 0xb06e
    15c8:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    15cc:	5f656c69 	svcpl	0x00656c69
    15d0:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    15d4:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 15dc <shift+0x15dc>
    15d8:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    15dc:	2b432055 	blcs	10c9738 <__bss_end+0x10bfbd8>
    15e0:	2034312b 	eorscs	r3, r4, fp, lsr #2
    15e4:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    15e8:	30322031 	eorscc	r2, r2, r1, lsr r0
    15ec:	30313931 	eorscc	r3, r1, r1, lsr r9
    15f0:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    15f4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    15f8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    15fc:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    1600:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    1604:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    1608:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    160c:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    1610:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    1614:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1618:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    161c:	205d3939 	subscs	r3, sp, r9, lsr r9
    1620:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1624:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1628:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    162c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1630:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1634:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1638:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    163c:	6f6c666d 	svcvs	0x006c666d
    1640:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1644:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1648:	20647261 	rsbcs	r7, r4, r1, ror #4
    164c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1650:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1654:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    1658:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    165c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1660:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1664:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    1668:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    166c:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1670:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1674:	613d6863 	teqvs	sp, r3, ror #16
    1678:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    167c:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    1680:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1684:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1688:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    168c:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1690:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1694:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1504 <shift+0x1504>
    1698:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    169c:	6f697470 	svcvs	0x00697470
    16a0:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    16a4:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1514 <shift+0x1514>
    16a8:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    16ac:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    16b0:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    16b4:	4b507970 	blmi	141fc7c <__bss_end+0x141611c>
    16b8:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    16bc:	6f682f00 	svcvs	0x00682f00
    16c0:	6a2f656d 	bvs	bdac7c <__bss_end+0xbd111c>
    16c4:	73656d61 	cmnvc	r5, #6208	; 0x1840
    16c8:	2f697261 	svccs	0x00697261
    16cc:	2f746967 	svccs	0x00746967
    16d0:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    16d4:	6f732f70 	svcvs	0x00732f70
    16d8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    16dc:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    16e0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    16e4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    16e8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    16ec:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    16f0:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    16f4:	72007070 	andvc	r7, r0, #112	; 0x70
    16f8:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    16fc:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
    1700:	6e736900 	vaddvs.f16	s13, s6, s0	; <UNPREDICTABLE>
    1704:	69006e61 	stmdbvs	r0, {r0, r5, r6, r9, sl, fp, sp, lr}
    1708:	6765746e 	strbvs	r7, [r5, -lr, ror #8]!
    170c:	006c6172 	rsbeq	r6, ip, r2, ror r1
    1710:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    1714:	65640066 	strbvs	r0, [r4, #-102]!	; 0xffffff9a
    1718:	616d6963 	cmnvs	sp, r3, ror #18
    171c:	5a5f006c 	bpl	17c18d4 <__bss_end+0x17b7d74>
    1720:	6f746934 	svcvs	0x00746934
    1724:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1728:	7461006a 	strbtvc	r0, [r1], #-106	; 0xffffff96
    172c:	7000696f 	andvc	r6, r0, pc, ror #18
    1730:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1734:	6565735f 	strbvs	r7, [r5, #-863]!	; 0xfffffca1
    1738:	7473006e 	ldrbtvc	r0, [r3], #-110	; 0xffffff92
    173c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1740:	6365645f 	cmnvs	r5, #1593835520	; 0x5f000000
    1744:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    1748:	6f700073 	svcvs	0x00700073
    174c:	00726577 	rsbseq	r6, r2, r7, ror r5
    1750:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1754:	695f676e 	ldmdbvs	pc, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^	; <UNPREDICTABLE>
    1758:	6c5f746e 	cfldrdvs	mvd7, [pc], {110}	; 0x6e
    175c:	65006e65 	strvs	r6, [r0, #-3685]	; 0xfffff19b
    1760:	6e6f7078 	mcrvs	0, 3, r7, cr15, cr8, {3}
    1764:	00746e65 	rsbseq	r6, r4, r5, ror #28
    1768:	61345a5f 	teqvs	r4, pc, asr sl
    176c:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1770:	6400634b 	strvs	r6, [r0], #-843	; 0xfffffcb5
    1774:	00747365 	rsbseq	r7, r4, r5, ror #6
    1778:	72365a5f 	eorsvc	r5, r6, #389120	; 0x5f000
    177c:	74737665 	ldrbtvc	r7, [r3], #-1637	; 0xfffff99b
    1780:	00635072 	rsbeq	r5, r3, r2, ror r0
    1784:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1788:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    178c:	6e690066 	cdpvs	0, 6, cr0, cr9, cr6, {3}
    1790:	00747570 	rsbseq	r7, r4, r0, ror r5
    1794:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    1798:	6d657400 	cfstrdvs	mvd7, [r5, #-0]
    179c:	5a5f0070 	bpl	17c1964 <__bss_end+0x17b7e04>
    17a0:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    17a4:	76506f72 	usub16vc	r6, r0, r2
    17a8:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    17ac:	70636e72 	rsbvc	r6, r3, r2, ror lr
    17b0:	74690079 	strbtvc	r0, [r9], #-121	; 0xffffff87
    17b4:	7300616f 	movwvc	r6, #367	; 0x16f
    17b8:	00317274 	eorseq	r7, r1, r4, ror r2
    17bc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    17c0:	695f676e 	ldmdbvs	pc, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^	; <UNPREDICTABLE>
    17c4:	5f00746e 	svcpl	0x0000746e
    17c8:	7369355a 	cmnvc	r9, #377487360	; 0x16800000
    17cc:	66666e69 	strbtvs	r6, [r6], -r9, ror #28
    17d0:	335a5f00 	cmpcc	sl, #0, 30
    17d4:	66776f70 	uhsub16vs	r6, r7, r0
    17d8:	5a5f006a 	bpl	17c1988 <__bss_end+0x17b7e28>
    17dc:	70733131 	rsbsvc	r3, r3, r1, lsr r1
    17e0:	5f74696c 	svcpl	0x0074696c
    17e4:	616f6c66 	cmnvs	pc, r6, ror #24
    17e8:	6a526674 	bvs	149b1c0 <__bss_end+0x1491660>
    17ec:	69525f53 	ldmdbvs	r2, {r0, r1, r4, r6, r8, r9, sl, fp, ip, lr}^
    17f0:	6f746100 	svcvs	0x00746100
    17f4:	656d0066 	strbvs	r0, [sp, #-102]!	; 0xffffff9a
    17f8:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    17fc:	61684300 	cmnvs	r8, r0, lsl #6
    1800:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    1804:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    1808:	6f746600 	svcvs	0x00746600
    180c:	5a5f0061 	bpl	17c1998 <__bss_end+0x17b7e38>
    1810:	65643332 	strbvs	r3, [r4, #-818]!	; 0xfffffcce
    1814:	616d6963 	cmnvs	sp, r3, ror #18
    1818:	6f745f6c 	svcvs	0x00745f6c
    181c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1820:	5f676e69 	svcpl	0x00676e69
    1824:	616f6c66 	cmnvs	pc, r6, ror #24
    1828:	63506a74 	cmpvs	r0, #116, 20	; 0x74000
    182c:	656d0069 	strbvs	r0, [sp, #-105]!	; 0xffffff97
    1830:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    1834:	65727000 	ldrbvs	r7, [r2, #-0]!
    1838:	69736963 	ldmdbvs	r3!, {r0, r1, r5, r6, r8, fp, sp, lr}^
    183c:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
    1840:	6f72657a 	svcvs	0x0072657a
    1844:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1848:	00797063 	rsbseq	r7, r9, r3, rrx
    184c:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    1850:	74730078 	ldrbtvc	r0, [r3], #-120	; 0xffffff88
    1854:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1858:	69640070 	stmdbvs	r4!, {r4, r5, r6}^
    185c:	73746967 	cmnvc	r4, #1687552	; 0x19c000
    1860:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1864:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1868:	00634b50 	rsbeq	r4, r3, r0, asr fp
    186c:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1870:	5f007475 	svcpl	0x00007475
    1874:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    1878:	5066616f 	rsbpl	r6, r6, pc, ror #2
    187c:	73006a63 	movwvc	r6, #2659	; 0xa63
    1880:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    1884:	6f6c665f 	svcvs	0x006c665f
    1888:	66007461 	strvs	r7, [r0], -r1, ror #8
    188c:	00746361 	rsbseq	r6, r4, r1, ror #6
    1890:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1894:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1898:	634b506e 	movtvs	r5, #45166	; 0xb06e
    189c:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    18a0:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    18a4:	50706d63 	rsbspl	r6, r0, r3, ror #26
    18a8:	3053634b 	subscc	r6, r3, fp, asr #6
    18ac:	5f00695f 	svcpl	0x0000695f
    18b0:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    18b4:	70636e72 	rsbvc	r6, r3, r2, ror lr
    18b8:	50635079 	rsbpl	r5, r3, r9, ror r0
    18bc:	0069634b 	rsbeq	r6, r9, fp, asr #6
    18c0:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    18c4:	5f6c616d 	svcpl	0x006c616d
    18c8:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    18cc:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    18d0:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    18d4:	0074616f 	rsbseq	r6, r4, pc, ror #2
    18d8:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    18dc:	66616f74 	uqsub16vs	r6, r1, r4
    18e0:	6d006350 	stcvs	3, cr6, [r0, #-320]	; 0xfffffec0
    18e4:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    18e8:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    18ec:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    18f0:	72747300 	rsbsvc	r7, r4, #0, 6
    18f4:	006e656c 	rsbeq	r6, lr, ip, ror #10
    18f8:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    18fc:	2e007274 	mcrcs	2, 0, r7, cr0, cr4, {3}
    1900:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1904:	2f2e2e2f 	svccs	0x002e2e2f
    1908:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    190c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1910:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1914:	2f636367 	svccs	0x00636367
    1918:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    191c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1920:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 1760 <shift+0x1760>
    1924:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1928:	73636e75 	cmnvc	r3, #1872	; 0x750
    192c:	2f00532e 	svccs	0x0000532e
    1930:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1934:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1938:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    193c:	6f6e2d6d 	svcvs	0x006e2d6d
    1940:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1944:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1948:	6b396c47 	blvs	e5ca6c <__bss_end+0xe52f0c>
    194c:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    1950:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1954:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1958:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    195c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1960:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    1964:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    1968:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    196c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1970:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1974:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1978:	61652d65 	cmnvs	r5, r5, ror #26
    197c:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1980:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1984:	2f657435 	svccs	0x00657435
    1988:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    198c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1990:	00636367 	rsbeq	r6, r3, r7, ror #6
    1994:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1998:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    199c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19a4:	37316178 			; <UNDEFINED> instruction: 0x37316178
    19a8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19ac:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    19b0:	61736900 	cmnvs	r3, r0, lsl #18
    19b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19b8:	5f70665f 	svcpl	0x0070665f
    19bc:	006c6264 	rsbeq	r6, ip, r4, ror #4
    19c0:	5f6d7261 	svcpl	0x006d7261
    19c4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    19c8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    19cc:	0074786d 	rsbseq	r7, r4, sp, ror #16
    19d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19d8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19dc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19e0:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    19e4:	4d524100 	ldfmie	f4, [r2, #-0]
    19e8:	0051455f 	subseq	r4, r1, pc, asr r5
    19ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19f4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19f8:	31316d72 	teqcc	r1, r2, ror sp
    19fc:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1a00:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1a04:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a08:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1a10 <shift+0x1a10>
    1a0c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1a10:	52415400 	subpl	r5, r1, #0, 8
    1a14:	5f544547 	svcpl	0x00544547
    1a18:	5f555043 	svcpl	0x00555043
    1a1c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a20:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a24:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1a28:	61786574 	cmnvs	r8, r4, ror r5
    1a2c:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    1a30:	5f455341 	svcpl	0x00455341
    1a34:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a38:	5f4d385f 	svcpl	0x004d385f
    1a3c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a40:	52415400 	subpl	r5, r1, #0, 8
    1a44:	5f544547 	svcpl	0x00544547
    1a48:	5f555043 	svcpl	0x00555043
    1a4c:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1a50:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    1a54:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a58:	50435f54 	subpl	r5, r3, r4, asr pc
    1a5c:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    1a60:	31656e65 	cmncc	r5, r5, ror #28
    1a64:	4d524100 	ldfmie	f4, [r2, #-0]
    1a68:	5343505f 	movtpl	r5, #12383	; 0x305f
    1a6c:	5041415f 	subpl	r4, r1, pc, asr r1
    1a70:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    1a74:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    1a78:	41420054 	qdaddmi	r0, r4, r2
    1a7c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a80:	5f484352 	svcpl	0x00484352
    1a84:	41420030 	cmpmi	r2, r0, lsr r0
    1a88:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a8c:	5f484352 	svcpl	0x00484352
    1a90:	41420032 	cmpmi	r2, r2, lsr r0
    1a94:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a98:	5f484352 	svcpl	0x00484352
    1a9c:	41420033 	cmpmi	r2, r3, lsr r0
    1aa0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1aa4:	5f484352 	svcpl	0x00484352
    1aa8:	41420034 	cmpmi	r2, r4, lsr r0
    1aac:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ab0:	5f484352 	svcpl	0x00484352
    1ab4:	41420036 	cmpmi	r2, r6, lsr r0
    1ab8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1abc:	5f484352 	svcpl	0x00484352
    1ac0:	41540037 	cmpmi	r4, r7, lsr r0
    1ac4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ac8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1acc:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1ad0:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1ad4:	5f617369 	svcpl	0x00617369
    1ad8:	5f746962 	svcpl	0x00746962
    1adc:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    1ae0:	00736572 	rsbseq	r6, r3, r2, ror r5
    1ae4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ae8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1aec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1af0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1af4:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1af8:	52415400 	subpl	r5, r1, #0, 8
    1afc:	5f544547 	svcpl	0x00544547
    1b00:	5f555043 	svcpl	0x00555043
    1b04:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1b08:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1b0c:	61736900 	cmnvs	r3, r0, lsl #18
    1b10:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1b14:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1b18:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b1c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b20:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b24:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1b28:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1b2c:	73690073 	cmnvc	r9, #115	; 0x73
    1b30:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b34:	66765f74 	uhsub16vs	r5, r6, r4
    1b38:	00327670 	eorseq	r7, r2, r0, ror r6
    1b3c:	5f4d5241 	svcpl	0x004d5241
    1b40:	5f534350 	svcpl	0x00534350
    1b44:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    1b48:	004e574f 	subeq	r5, lr, pc, asr #14
    1b4c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b50:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b54:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b58:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    1b5c:	53414200 	movtpl	r4, #4608	; 0x1200
    1b60:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b64:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1329 <shift+0x1329>
    1b68:	004a4554 	subeq	r4, sl, r4, asr r5
    1b6c:	5f6d7261 	svcpl	0x006d7261
    1b70:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    1b74:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    1b78:	00657461 	rsbeq	r7, r5, r1, ror #8
    1b7c:	5f6d7261 	svcpl	0x006d7261
    1b80:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b84:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1b88:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1b8c:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    1b90:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1b94:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1b98:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b9c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1ba0:	5f006365 	svcpl	0x00006365
    1ba4:	7a6c635f 	bvc	1b1a928 <__bss_end+0x1b10dc8>
    1ba8:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1bac:	4d524100 	ldfmie	f4, [r2, #-0]
    1bb0:	0043565f 	subeq	r5, r3, pc, asr r6
    1bb4:	5f6d7261 	svcpl	0x006d7261
    1bb8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1bbc:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1bc0:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1bc4:	5f4d5241 	svcpl	0x004d5241
    1bc8:	4100454c 	tstmi	r0, ip, asr #10
    1bcc:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1bd0:	52410053 	subpl	r0, r1, #83	; 0x53
    1bd4:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1bd8:	6d726100 	ldfvse	f6, [r2, #-0]
    1bdc:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1be0:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1be4:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1be8:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1bec:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1bf0:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1bf4:	616f6c66 	cmnvs	pc, r6, ror #24
    1bf8:	41540074 	cmpmi	r4, r4, ror r0
    1bfc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c04:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c08:	61786574 	cmnvs	r8, r4, ror r5
    1c0c:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    1c10:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c14:	50435f54 	subpl	r5, r3, r4, asr pc
    1c18:	61665f55 	cmnvs	r6, r5, asr pc
    1c1c:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    1c20:	41540065 	cmpmi	r4, r5, rrx
    1c24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c30:	61786574 	cmnvs	r8, r4, ror r5
    1c34:	41003731 	tstmi	r0, r1, lsr r7
    1c38:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1c3c:	41540054 	cmpmi	r4, r4, asr r0
    1c40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c48:	6f656e5f 	svcvs	0x00656e5f
    1c4c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
    1c50:	00316e65 	eorseq	r6, r1, r5, ror #28
    1c54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c58:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c5c:	2f2e2e2f 	svccs	0x002e2e2f
    1c60:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c64:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1c68:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c6c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c70:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1c74:	5400632e 	strpl	r6, [r0], #-814	; 0xfffffcd2
    1c78:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c7c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c80:	6f635f55 	svcvs	0x00635f55
    1c84:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c88:	00663472 	rsbeq	r3, r6, r2, ror r4
    1c8c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c90:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c94:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1c98:	4154004d 	cmpmi	r4, sp, asr #32
    1c9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ca0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ca4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ca8:	61786574 	cmnvs	r8, r4, ror r5
    1cac:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1cb0:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    1cb4:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1cbc <shift+0x1cbc>
    1cb8:	53414200 	movtpl	r4, #4608	; 0x1200
    1cbc:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cc0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1cc4:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1cc8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ccc:	00737469 	rsbseq	r7, r3, r9, ror #8
    1cd0:	5f6d7261 	svcpl	0x006d7261
    1cd4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1cd8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cdc:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    1ce0:	61007669 	tstvs	r0, r9, ror #12
    1ce4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1ce8:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1cf0 <shift+0x1cf0>
    1cec:	00637365 	rsbeq	r7, r3, r5, ror #6
    1cf0:	5f617369 	svcpl	0x00617369
    1cf4:	5f746962 	svcpl	0x00746962
    1cf8:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1cfc:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1d00:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    1d04:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1d08:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1d0c:	31393130 	teqcc	r9, r0, lsr r1
    1d10:	20353230 	eorscs	r3, r5, r0, lsr r2
    1d14:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1d18:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1d1c:	415b2029 	cmpmi	fp, r9, lsr #32
    1d20:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1d24:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1d28:	6172622d 	cmnvs	r2, sp, lsr #4
    1d2c:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1d30:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1d34:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1d38:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1d3c:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1d40:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d44:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1d48:	6f6c666d 	svcvs	0x006c666d
    1d4c:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1d50:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1d54:	20647261 	rsbcs	r7, r4, r1, ror #4
    1d58:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1d5c:	613d6863 	teqvs	sp, r3, ror #16
    1d60:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1d64:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1d68:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1d6c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1d70:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1d74:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d78:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d7c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d80:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1d84:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    1d88:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    1d8c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1d90:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1d94:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1d98:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1d9c:	746f7270 	strbtvc	r7, [pc], #-624	; 1da4 <shift+0x1da4>
    1da0:	6f746365 	svcvs	0x00746365
    1da4:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    1da8:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1dac:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    1db0:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1db4:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1db8:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1dbc:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    1dc0:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1dc4:	5241006e 	subpl	r0, r1, #110	; 0x6e
    1dc8:	49485f4d 	stmdbmi	r8, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1dcc:	61736900 	cmnvs	r3, r0, lsl #18
    1dd0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1dd4:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1dd8:	41540076 	cmpmi	r4, r6, ror r0
    1ddc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1de0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1de4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1de8:	36333131 			; <UNDEFINED> instruction: 0x36333131
    1dec:	5400736a 	strpl	r7, [r0], #-874	; 0xfffffc96
    1df0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1df4:	50435f54 	subpl	r5, r3, r4, asr pc
    1df8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1dfc:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1e00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e04:	50435f54 	subpl	r5, r3, r4, asr pc
    1e08:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e0c:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1e10:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e14:	50435f54 	subpl	r5, r3, r4, asr pc
    1e18:	61665f55 	cmnvs	r6, r5, asr pc
    1e1c:	00363236 	eorseq	r3, r6, r6, lsr r2
    1e20:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1e24:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1e28:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1e2c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1e30:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1e34:	6100746e 	tstvs	r0, lr, ror #8
    1e38:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e3c:	5f686372 	svcpl	0x00686372
    1e40:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1e44:	52415400 	subpl	r5, r1, #0, 8
    1e48:	5f544547 	svcpl	0x00544547
    1e4c:	5f555043 	svcpl	0x00555043
    1e50:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e54:	346d7865 	strbtcc	r7, [sp], #-2149	; 0xfffff79b
    1e58:	52415400 	subpl	r5, r1, #0, 8
    1e5c:	5f544547 	svcpl	0x00544547
    1e60:	5f555043 	svcpl	0x00555043
    1e64:	316d7261 	cmncc	sp, r1, ror #4
    1e68:	54006530 	strpl	r6, [r0], #-1328	; 0xfffffad0
    1e6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e70:	50435f54 	subpl	r5, r3, r4, asr pc
    1e74:	6f635f55 	svcvs	0x00635f55
    1e78:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e7c:	6100376d 	tstvs	r0, sp, ror #14
    1e80:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1e84:	5f646e6f 	svcpl	0x00646e6f
    1e88:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1e8c:	4d524100 	ldfmie	f4, [r2, #-0]
    1e90:	5343505f 	movtpl	r5, #12383	; 0x305f
    1e94:	5041415f 	subpl	r4, r1, pc, asr r1
    1e98:	69005343 	stmdbvs	r0, {r0, r1, r6, r8, r9, ip, lr}
    1e9c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ea0:	615f7469 	cmpvs	pc, r9, ror #8
    1ea4:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1ea8:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1eac:	5f455341 	svcpl	0x00455341
    1eb0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1eb4:	004d335f 	subeq	r3, sp, pc, asr r3
    1eb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ebc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ec0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ec4:	31376d72 	teqcc	r7, r2, ror sp
    1ec8:	61007430 	tstvs	r0, r0, lsr r4
    1ecc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1ed0:	5f686372 	svcpl	0x00686372
    1ed4:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1ed8:	00327478 	eorseq	r7, r2, r8, ror r4
    1edc:	5f617369 	svcpl	0x00617369
    1ee0:	5f6d756e 	svcpl	0x006d756e
    1ee4:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1ee8:	52415400 	subpl	r5, r1, #0, 8
    1eec:	5f544547 	svcpl	0x00544547
    1ef0:	5f555043 	svcpl	0x00555043
    1ef4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ef8:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1efc:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1f00:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1f04:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1f08:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1f0c:	41540079 	cmpmi	r4, r9, ror r0
    1f10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f18:	7978655f 	ldmdbvc	r8!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1f1c:	6d736f6e 	ldclvs	15, cr6, [r3, #-440]!	; 0xfffffe48
    1f20:	41540031 	cmpmi	r4, r1, lsr r0
    1f24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f30:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1f34:	69003235 	stmdbvs	r0, {r0, r2, r4, r5, r9, ip, sp}
    1f38:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f3c:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1f44 <shift+0x1f44>
    1f40:	00766964 	rsbseq	r6, r6, r4, ror #18
    1f44:	66657270 			; <UNDEFINED> instruction: 0x66657270
    1f48:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
    1f4c:	5f6e6f65 	svcpl	0x006e6f65
    1f50:	5f726f66 	svcpl	0x00726f66
    1f54:	69623436 	stmdbvs	r2!, {r1, r2, r4, r5, sl, ip, sp}^
    1f58:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1f5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f60:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f64:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1f68:	54006c6d 	strpl	r6, [r0], #-3181	; 0xfffff393
    1f6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f70:	50435f54 	subpl	r5, r3, r4, asr pc
    1f74:	6f635f55 	svcvs	0x00635f55
    1f78:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f7c:	00323361 	eorseq	r3, r2, r1, ror #6
    1f80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f88:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f8c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f90:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    1f94:	61736900 	cmnvs	r3, r0, lsl #18
    1f98:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f9c:	3170665f 	cmncc	r0, pc, asr r6
    1fa0:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1fa4:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
    1fa8:	63657073 	cmnvs	r5, #115	; 0x73
    1fac:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
    1fb0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1fb4:	41540073 	cmpmi	r4, r3, ror r0
    1fb8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fbc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fc0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1fc4:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1fc8:	00733274 	rsbseq	r3, r3, r4, ror r2
    1fcc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fd0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fd4:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1fd8:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    1fdc:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1fe0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fe4:	50435f54 	subpl	r5, r3, r4, asr pc
    1fe8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fec:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    1ff0:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1ff4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ff8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ffc:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    2000:	61736900 	cmnvs	r3, r0, lsl #18
    2004:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2008:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    200c:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    2010:	5f6d7261 	svcpl	0x006d7261
    2014:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    2018:	5f6e695f 	svcpl	0x006e695f
    201c:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    2020:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    2024:	61736900 	cmnvs	r3, r0, lsl #18
    2028:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    202c:	0062735f 	rsbeq	r7, r2, pc, asr r3
    2030:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2034:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2038:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    203c:	73690045 	cmnvc	r9, #69	; 0x45
    2040:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    2044:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    2048:	73690065 	cmnvc	r9, #101	; 0x65
    204c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2050:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    2054:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2058:	61006c75 	tstvs	r0, r5, ror ip
    205c:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2060:	5f676e61 	svcpl	0x00676e61
    2064:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    2068:	6f5f7475 	svcvs	0x005f7475
    206c:	63656a62 	cmnvs	r5, #401408	; 0x62000
    2070:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
    2074:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
    2078:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
    207c:	6f6f685f 	svcvs	0x006f685f
    2080:	7369006b 	cmnvc	r9, #107	; 0x6b
    2084:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2088:	70665f74 	rsbvc	r5, r6, r4, ror pc
    208c:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    2090:	4d524100 	ldfmie	f4, [r2, #-0]
    2094:	00454e5f 	subeq	r4, r5, pc, asr lr
    2098:	5f617369 	svcpl	0x00617369
    209c:	5f746962 	svcpl	0x00746962
    20a0:	00386562 	eorseq	r6, r8, r2, ror #10
    20a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20b0:	31316d72 	teqcc	r1, r2, ror sp
    20b4:	7a6a3637 	bvc	1a8f998 <__bss_end+0x1a85e38>
    20b8:	72700073 	rsbsvc	r0, r0, #115	; 0x73
    20bc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    20c0:	5f726f73 	svcpl	0x00726f73
    20c4:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    20c8:	6c6c6100 	stfvse	f6, [ip], #-0
    20cc:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    20d0:	72610073 	rsbvc	r0, r1, #115	; 0x73
    20d4:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    20d8:	41420073 	hvcmi	8195	; 0x2003
    20dc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    20e0:	5f484352 	svcpl	0x00484352
    20e4:	61005435 	tstvs	r0, r5, lsr r4
    20e8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    20ec:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    20f0:	41540074 	cmpmi	r4, r4, ror r0
    20f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20fc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2100:	61786574 	cmnvs	r8, r4, ror r5
    2104:	6f633637 	svcvs	0x00633637
    2108:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    210c:	00353561 	eorseq	r3, r5, r1, ror #10
    2110:	5f6d7261 	svcpl	0x006d7261
    2114:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2118:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    211c:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    2120:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2124:	00687361 	rsbeq	r7, r8, r1, ror #6
    2128:	5f617369 	svcpl	0x00617369
    212c:	5f746962 	svcpl	0x00746962
    2130:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2134:	6f6e5f6b 	svcvs	0x006e5f6b
    2138:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1fc4 <shift+0x1fc4>
    213c:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2140:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2144:	52415400 	subpl	r5, r1, #0, 8
    2148:	5f544547 	svcpl	0x00544547
    214c:	5f555043 	svcpl	0x00555043
    2150:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2154:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2158:	52415400 	subpl	r5, r1, #0, 8
    215c:	5f544547 	svcpl	0x00544547
    2160:	5f555043 	svcpl	0x00555043
    2164:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2168:	316d7865 	cmncc	sp, r5, ror #16
    216c:	52415400 	subpl	r5, r1, #0, 8
    2170:	5f544547 	svcpl	0x00544547
    2174:	5f555043 	svcpl	0x00555043
    2178:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    217c:	336d7865 	cmncc	sp, #6619136	; 0x650000
    2180:	61736900 	cmnvs	r3, r0, lsl #18
    2184:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2188:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    218c:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    2190:	6d726100 	ldfvse	f6, [r2, #-0]
    2194:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2198:	616e5f68 	cmnvs	lr, r8, ror #30
    219c:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    21a0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21a4:	615f7469 	cmpvs	pc, r9, ror #8
    21a8:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21ac:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    21b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21b4:	615f7469 	cmpvs	pc, r9, ror #8
    21b8:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21bc:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    21c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21c4:	615f7469 	cmpvs	pc, r9, ror #8
    21c8:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21cc:	5400355f 	strpl	r3, [r0], #-1375	; 0xfffffaa1
    21d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21d4:	50435f54 	subpl	r5, r3, r4, asr pc
    21d8:	6f635f55 	svcvs	0x00635f55
    21dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21e0:	00333561 	eorseq	r3, r3, r1, ror #10
    21e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21f4:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    21f8:	52415400 	subpl	r5, r1, #0, 8
    21fc:	5f544547 	svcpl	0x00544547
    2200:	5f555043 	svcpl	0x00555043
    2204:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2208:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    220c:	41540037 	cmpmi	r4, r7, lsr r0
    2210:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2214:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2218:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    221c:	0065726f 	rsbeq	r7, r5, pc, ror #4
    2220:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2224:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2228:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    222c:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    2230:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    2234:	5f6d7261 	svcpl	0x006d7261
    2238:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    223c:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2244 <shift+0x2244>
    2240:	4154006d 	cmpmi	r4, sp, rrx
    2244:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2248:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    224c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2250:	36323031 			; <UNDEFINED> instruction: 0x36323031
    2254:	00736a65 	rsbseq	r6, r3, r5, ror #20
    2258:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    225c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2260:	4a365f48 	bmi	d99f88 <__bss_end+0xd90428>
    2264:	53414200 	movtpl	r4, #4608	; 0x1200
    2268:	52415f45 	subpl	r5, r1, #276	; 0x114
    226c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2270:	4142004b 	cmpmi	r2, fp, asr #32
    2274:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2278:	5f484352 	svcpl	0x00484352
    227c:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    2280:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2284:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2288:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    228c:	41540074 	cmpmi	r4, r4, ror r0
    2290:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2294:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2298:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    229c:	36333131 			; <UNDEFINED> instruction: 0x36333131
    22a0:	0073666a 	rsbseq	r6, r3, sl, ror #12
    22a4:	5f4d5241 	svcpl	0x004d5241
    22a8:	4100534c 	tstmi	r0, ip, asr #6
    22ac:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    22b0:	41420054 	qdaddmi	r0, r4, r2
    22b4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    22b8:	5f484352 	svcpl	0x00484352
    22bc:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    22c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22c4:	50435f54 	subpl	r5, r3, r4, asr pc
    22c8:	6f635f55 	svcvs	0x00635f55
    22cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22d0:	63353761 	teqvs	r5, #25427968	; 0x1840000
    22d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22d8:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    22dc:	4d524100 	ldfmie	f4, [r2, #-0]
    22e0:	5343505f 	movtpl	r5, #12383	; 0x305f
    22e4:	5041415f 	subpl	r4, r1, pc, asr r1
    22e8:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    22ec:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    22f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22f4:	50435f54 	subpl	r5, r3, r4, asr pc
    22f8:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    22fc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2300:	73690032 	cmnvc	r9, #50	; 0x32
    2304:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2308:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    230c:	61006e6f 	tstvs	r0, pc, ror #28
    2310:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2314:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    2318:	00727474 	rsbseq	r7, r2, r4, ror r4
    231c:	5f617369 	svcpl	0x00617369
    2320:	5f746962 	svcpl	0x00746962
    2324:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2328:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    232c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2330:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2334:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2338:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    233c:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    2340:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2344:	50435f54 	subpl	r5, r3, r4, asr pc
    2348:	616d5f55 	cmnvs	sp, r5, asr pc
    234c:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    2350:	6a705f6c 	bvs	1c1a108 <__bss_end+0x1c105a8>
    2354:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    2358:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    235c:	5f687361 	svcpl	0x00687361
    2360:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2364:	00726574 	rsbseq	r6, r2, r4, ror r5
    2368:	5f6d7261 	svcpl	0x006d7261
    236c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2370:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2374:	5f786574 	svcpl	0x00786574
    2378:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    237c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2380:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2384:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2388:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    238c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2390:	50435f54 	subpl	r5, r3, r4, asr pc
    2394:	6f635f55 	svcvs	0x00635f55
    2398:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    239c:	63323761 	teqvs	r2, #25427968	; 0x1840000
    23a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    23a4:	33356178 	teqcc	r5, #120, 2
    23a8:	61736900 	cmnvs	r3, r0, lsl #18
    23ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23b0:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    23b4:	0032626d 	eorseq	r6, r2, sp, ror #4
    23b8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    23bc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    23c0:	41375f48 	teqmi	r7, r8, asr #30
    23c4:	61736900 	cmnvs	r3, r0, lsl #18
    23c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23cc:	746f645f 	strbtvc	r6, [pc], #-1119	; 23d4 <shift+0x23d4>
    23d0:	646f7270 	strbtvs	r7, [pc], #-624	; 23d8 <shift+0x23d8>
    23d4:	6d726100 	ldfvse	f6, [r2, #-0]
    23d8:	3170665f 	cmncc	r0, pc, asr r6
    23dc:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    23e0:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    23e4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    23e8:	5f4d5241 	svcpl	0x004d5241
    23ec:	6100494d 	tstvs	r0, sp, asr #18
    23f0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23f4:	36686372 			; <UNDEFINED> instruction: 0x36686372
    23f8:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    23fc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2400:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    2404:	53414200 	movtpl	r4, #4608	; 0x1200
    2408:	52415f45 	subpl	r5, r1, #276	; 0x114
    240c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2410:	5f5f0052 	svcpl	0x005f0052
    2414:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    2418:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    241c:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2420:	61736900 	cmnvs	r3, r0, lsl #18
    2424:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2428:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    242c:	41540065 	cmpmi	r4, r5, rrx
    2430:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2434:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2438:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    243c:	61786574 	cmnvs	r8, r4, ror r5
    2440:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    2444:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2448:	50435f54 	subpl	r5, r3, r4, asr pc
    244c:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    2450:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    2454:	61377663 	teqvs	r7, r3, ror #12
    2458:	52415400 	subpl	r5, r1, #0, 8
    245c:	5f544547 	svcpl	0x00544547
    2460:	5f555043 	svcpl	0x00555043
    2464:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2468:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    246c:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2470:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2474:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2478:	6f765f6f 	svcvs	0x00765f6f
    247c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    2480:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2484:	41420065 	cmpmi	r2, r5, rrx
    2488:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    248c:	5f484352 	svcpl	0x00484352
    2490:	69004138 	stmdbvs	r0, {r3, r4, r5, r8, lr}
    2494:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2498:	615f7469 	cmpvs	pc, r9, ror #8
    249c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    24a0:	41420074 	hvcmi	8196	; 0x2004
    24a4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24a8:	5f484352 	svcpl	0x00484352
    24ac:	54005238 	strpl	r5, [r0], #-568	; 0xfffffdc8
    24b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24b4:	50435f54 	subpl	r5, r3, r4, asr pc
    24b8:	6f635f55 	svcvs	0x00635f55
    24bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24c0:	63333761 	teqvs	r3, #25427968	; 0x1840000
    24c4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    24c8:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    24cc:	4d524100 	ldfmie	f4, [r2, #-0]
    24d0:	00564e5f 	subseq	r4, r6, pc, asr lr
    24d4:	5f6d7261 	svcpl	0x006d7261
    24d8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24dc:	72610034 	rsbvc	r0, r1, #52	; 0x34
    24e0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24e4:	00366863 	eorseq	r6, r6, r3, ror #16
    24e8:	5f6d7261 	svcpl	0x006d7261
    24ec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24f0:	72610037 	rsbvc	r0, r1, #55	; 0x37
    24f4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24f8:	00386863 	eorseq	r6, r8, r3, ror #16
    24fc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    2500:	756f6420 	strbvc	r6, [pc, #-1056]!	; 20e8 <shift+0x20e8>
    2504:	00656c62 	rsbeq	r6, r5, r2, ror #24
    2508:	5f6d7261 	svcpl	0x006d7261
    250c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2510:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    2514:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2518:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    251c:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    2520:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    2524:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2528:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    252c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2530:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    2534:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2538:	616c5f61 	cmnvs	ip, r1, ror #30
    253c:	006c6562 	rsbeq	r6, ip, r2, ror #10
    2540:	5f617369 	svcpl	0x00617369
    2544:	5f746962 	svcpl	0x00746962
    2548:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    254c:	61736900 	cmnvs	r3, r0, lsl #18
    2550:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2554:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2558:	006b3676 	rsbeq	r3, fp, r6, ror r6
    255c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2560:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2564:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2568:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    256c:	00376178 	eorseq	r6, r7, r8, ror r1
    2570:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2574:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2578:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    257c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2580:	00386178 	eorseq	r6, r8, r8, ror r1
    2584:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2588:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    258c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2590:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2594:	00396178 	eorseq	r6, r9, r8, ror r1
    2598:	5f4d5241 	svcpl	0x004d5241
    259c:	5f534350 	svcpl	0x00534350
    25a0:	53435041 	movtpl	r5, #12353	; 0x3041
    25a4:	4d524100 	ldfmie	f4, [r2, #-0]
    25a8:	5343505f 	movtpl	r5, #12383	; 0x305f
    25ac:	5054415f 	subspl	r4, r4, pc, asr r1
    25b0:	63005343 	movwvs	r5, #835	; 0x343
    25b4:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    25b8:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    25bc:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    25c0:	41540065 	cmpmi	r4, r5, rrx
    25c4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25c8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25cc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25d0:	61786574 	cmnvs	r8, r4, ror r5
    25d4:	6f633337 	svcvs	0x00633337
    25d8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25dc:	00333561 	eorseq	r3, r3, r1, ror #10
    25e0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25e4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25e8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25ec:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25f0:	70306d78 	eorsvc	r6, r0, r8, ror sp
    25f4:	0073756c 	rsbseq	r7, r3, ip, ror #10
    25f8:	5f6d7261 	svcpl	0x006d7261
    25fc:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    2600:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2604:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2608:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    260c:	645f0065 	ldrbvs	r0, [pc], #-101	; 2614 <shift+0x2614>
    2610:	5f746e6f 	svcpl	0x00746e6f
    2614:	5f657375 	svcpl	0x00657375
    2618:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    261c:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2620:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    2624:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2628:	50435f54 	subpl	r5, r3, r4, asr pc
    262c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2630:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    2634:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2638:	47524154 			; <UNDEFINED> instruction: 0x47524154
    263c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2640:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2644:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2648:	00356178 	eorseq	r6, r5, r8, ror r1
    264c:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    2650:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2654:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    2658:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    265c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2660:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2664:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    2668:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    266c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2670:	50435f54 	subpl	r5, r3, r4, asr pc
    2674:	6f635f55 	svcvs	0x00635f55
    2678:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    267c:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    2680:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2684:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    2688:	00796c70 	rsbseq	r6, r9, r0, ror ip
    268c:	5f6d7261 	svcpl	0x006d7261
    2690:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    2694:	5f746e65 	svcpl	0x00746e65
    2698:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    269c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    26a0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    26a4:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    26a8:	4d524100 	ldfmie	f4, [r2, #-0]
    26ac:	004c505f 	subeq	r5, ip, pc, asr r0
    26b0:	5f617369 	svcpl	0x00617369
    26b4:	5f746962 	svcpl	0x00746962
    26b8:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26bc:	73690033 	cmnvc	r9, #51	; 0x33
    26c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26c4:	66765f74 	uhsub16vs	r5, r6, r4
    26c8:	00347670 	eorseq	r7, r4, r0, ror r6
    26cc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26d0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26d4:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    26d8:	41420032 	cmpmi	r2, r2, lsr r0
    26dc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26e0:	5f484352 	svcpl	0x00484352
    26e4:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 260c <shift+0x260c>
    26e8:	004e4941 	subeq	r4, lr, r1, asr #18
    26ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26f4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    26f8:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    26fc:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2700:	5f4d5241 	svcpl	0x004d5241
    2704:	42004c41 	andmi	r4, r0, #16640	; 0x4100
    2708:	5f455341 	svcpl	0x00455341
    270c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2710:	004d375f 	subeq	r3, sp, pc, asr r7
    2714:	5f6d7261 	svcpl	0x006d7261
    2718:	67726174 			; <UNDEFINED> instruction: 0x67726174
    271c:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2720:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2724:	6d726100 	ldfvse	f6, [r2, #-0]
    2728:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    272c:	5f746567 	svcpl	0x00746567
    2730:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    2734:	52415400 	subpl	r5, r1, #0, 8
    2738:	5f544547 	svcpl	0x00544547
    273c:	5f555043 	svcpl	0x00555043
    2740:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2744:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    2748:	52415400 	subpl	r5, r1, #0, 8
    274c:	5f544547 	svcpl	0x00544547
    2750:	5f555043 	svcpl	0x00555043
    2754:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2758:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    275c:	52415400 	subpl	r5, r1, #0, 8
    2760:	5f544547 	svcpl	0x00544547
    2764:	5f555043 	svcpl	0x00555043
    2768:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    276c:	37727865 	ldrbcc	r7, [r2, -r5, ror #16]!
    2770:	52415400 	subpl	r5, r1, #0, 8
    2774:	5f544547 	svcpl	0x00544547
    2778:	5f555043 	svcpl	0x00555043
    277c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2780:	38727865 	ldmdacc	r2!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2784:	61736900 	cmnvs	r3, r0, lsl #18
    2788:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    278c:	61706c5f 	cmnvs	r0, pc, asr ip
    2790:	73690065 	cmnvc	r9, #101	; 0x65
    2794:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2798:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    279c:	5f6b7269 	svcpl	0x006b7269
    27a0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    27a4:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    27a8:	5f617369 	svcpl	0x00617369
    27ac:	5f746962 	svcpl	0x00746962
    27b0:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    27b4:	61736900 	cmnvs	r3, r0, lsl #18
    27b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27c0:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    27c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27c8:	615f7469 	cmpvs	pc, r9, ror #8
    27cc:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    27d0:	61736900 	cmnvs	r3, r0, lsl #18
    27d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27d8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27dc:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    27e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27e4:	615f7469 	cmpvs	pc, r9, ror #8
    27e8:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    27ec:	6f645f00 	svcvs	0x00645f00
    27f0:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 238a <shift+0x238a>
    27f4:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    27f8:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    27fc:	5f657265 	svcpl	0x00657265
    2800:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    2804:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2808:	61736900 	cmnvs	r3, r0, lsl #18
    280c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2810:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2814:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    2818:	6d726100 	ldfvse	f6, [r2, #-0]
    281c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2820:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2824:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    2828:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    282c:	77726574 			; <UNDEFINED> instruction: 0x77726574
    2830:	006b726f 	rsbeq	r7, fp, pc, ror #4
    2834:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    2838:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    283c:	52415400 	subpl	r5, r1, #0, 8
    2840:	5f544547 	svcpl	0x00544547
    2844:	5f555043 	svcpl	0x00555043
    2848:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    284c:	00743032 	rsbseq	r3, r4, r2, lsr r0
    2850:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2854:	0071655f 	rsbseq	r6, r1, pc, asr r5
    2858:	47524154 			; <UNDEFINED> instruction: 0x47524154
    285c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2860:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2864:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    2868:	6d726100 	ldfvse	f6, [r2, #-0]
    286c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2870:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2874:	5f626d75 	svcpl	0x00626d75
    2878:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    287c:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    2880:	655f6261 	ldrbvs	r6, [pc, #-609]	; 2627 <shift+0x2627>
    2884:	6f705f71 	svcvs	0x00705f71
    2888:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    288c:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2890:	69705f6d 	ldmdbvs	r0!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2894:	65725f63 	ldrbvs	r5, [r2, #-3939]!	; 0xfffff09d
    2898:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    289c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    28a0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28a4:	50435f54 	subpl	r5, r3, r4, asr pc
    28a8:	6f635f55 	svcvs	0x00635f55
    28ac:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    28b0:	6d73306d 	ldclvs	0, cr3, [r3, #-436]!	; 0xfffffe4c
    28b4:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    28b8:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    28bc:	00796c70 	rsbseq	r6, r9, r0, ror ip
    28c0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28c4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    28c8:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 2790 <shift+0x2790>
    28cc:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    28d0:	766f6e65 	strbtvc	r6, [pc], -r5, ror #28
    28d4:	69007066 	stmdbvs	r0, {r1, r2, r5, r6, ip, sp, lr}
    28d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    28dc:	715f7469 	cmpvc	pc, r9, ror #8
    28e0:	6b726975 	blvs	1c9cebc <__bss_end+0x1c9335c>
    28e4:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    28e8:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    28ec:	52410064 	subpl	r0, r1, #100	; 0x64
    28f0:	43435f4d 	movtmi	r5, #16205	; 0x3f4d
    28f4:	6d726100 	ldfvse	f6, [r2, #-0]
    28f8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28fc:	325f3868 	subscc	r3, pc, #104, 16	; 0x680000
    2900:	6d726100 	ldfvse	f6, [r2, #-0]
    2904:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2908:	335f3868 	cmpcc	pc, #104, 16	; 0x680000
    290c:	6d726100 	ldfvse	f6, [r2, #-0]
    2910:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2914:	345f3868 	ldrbcc	r3, [pc], #-2152	; 291c <shift+0x291c>
    2918:	52415400 	subpl	r5, r1, #0, 8
    291c:	5f544547 	svcpl	0x00544547
    2920:	5f555043 	svcpl	0x00555043
    2924:	36706d66 	ldrbtcc	r6, [r0], -r6, ror #26
    2928:	41003632 	tstmi	r0, r2, lsr r6
    292c:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2930:	72610053 	rsbvc	r0, r1, #83	; 0x53
    2934:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2938:	695f3631 	ldmdbvs	pc, {r0, r4, r5, r9, sl, ip, sp}^	; <UNPREDICTABLE>
    293c:	0074736e 	rsbseq	r7, r4, lr, ror #6
    2940:	5f6d7261 	svcpl	0x006d7261
    2944:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    2948:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    294c:	41540068 	cmpmi	r4, r8, rrx
    2950:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2954:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2958:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    295c:	61786574 	cmnvs	r8, r4, ror r5
    2960:	6f633531 	svcvs	0x00633531
    2964:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2968:	61003761 	tstvs	r0, r1, ror #14
    296c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2970:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2974:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2978:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    297c:	50435f54 	subpl	r5, r3, r4, asr pc
    2980:	6f635f55 	svcvs	0x00635f55
    2984:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2988:	00323761 	eorseq	r3, r2, r1, ror #14
    298c:	5f6d7261 	svcpl	0x006d7261
    2990:	5f736370 	svcpl	0x00736370
    2994:	61666564 	cmnvs	r6, r4, ror #10
    2998:	00746c75 	rsbseq	r6, r4, r5, ror ip
    299c:	5f4d5241 	svcpl	0x004d5241
    29a0:	5f534350 	svcpl	0x00534350
    29a4:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    29a8:	4f4c5f53 	svcmi	0x004c5f53
    29ac:	004c4143 	subeq	r4, ip, r3, asr #2
    29b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29b8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    29bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    29c0:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    29c4:	52415400 	subpl	r5, r1, #0, 8
    29c8:	5f544547 	svcpl	0x00544547
    29cc:	5f555043 	svcpl	0x00555043
    29d0:	6f727473 	svcvs	0x00727473
    29d4:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    29d8:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    29dc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29e0:	745f6863 	ldrbvc	r6, [pc], #-2147	; 29e8 <shift+0x29e8>
    29e4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    29e8:	72610031 	rsbvc	r0, r1, #49	; 0x31
    29ec:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29f0:	745f6863 	ldrbvc	r6, [pc], #-2147	; 29f8 <shift+0x29f8>
    29f4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    29f8:	41540032 	cmpmi	r4, r2, lsr r0
    29fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a04:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2a08:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2a0c:	5f6d7261 	svcpl	0x006d7261
    2a10:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a14:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    2a18:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a1c:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 2880 <shift+0x2880>
    2a20:	72610070 	rsbvc	r0, r1, #112	; 0x70
    2a24:	646c5f6d 	strbtvs	r5, [ip], #-3949	; 0xfffff093
    2a28:	6863735f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    2a2c:	61006465 	tstvs	r0, r5, ror #8
    2a30:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2a34:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2a38:	Address 0x0000000000002a38 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9dd0>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346cd0>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9df0>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9120>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9e20>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346d20>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9e40>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346d40>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9e60>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346d60>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9e80>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346d80>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9ea0>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346da0>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9ec0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346dc0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9ee0>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346de0>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9ef8>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9f18>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	00000080 	andeq	r0, r0, r0, lsl #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9f48>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082ac 	andeq	r8, r0, ip, lsr #5
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9f68>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008418 	andeq	r8, r0, r8, lsl r4
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9f94>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346e94>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	00008444 	andeq	r8, r0, r4, asr #8
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9fb4>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346eb4>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008470 	andeq	r8, r0, r0, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9fd4>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346ed4>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	0000848c 	andeq	r8, r0, ip, lsl #9
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9ff4>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346ef4>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084d0 	ldrdeq	r8, [r0], -r0
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa014>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346f14>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	00008520 	andeq	r8, r0, r0, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa034>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346f34>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008570 	andeq	r8, r0, r0, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa054>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346f54>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	0000859c 	muleq	r0, ip, r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa074>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346f74>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085ec 	andeq	r8, r0, ip, ror #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa094>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346f94>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	00008630 	andeq	r8, r0, r0, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa0b4>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346fb4>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008680 	andeq	r8, r0, r0, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa0d4>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346fd4>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086d4 	ldrdeq	r8, [r0], -r4
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa0f4>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346ff4>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	00008710 	andeq	r8, r0, r0, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa114>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347014>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	0000874c 	andeq	r8, r0, ip, asr #14
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa134>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347034>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008788 	andeq	r8, r0, r8, lsl #15
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfa154>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347054>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087c4 	andeq	r8, r0, r4, asr #15
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fa174>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008874 	andeq	r8, r0, r4, ror r8
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa1a4>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089e8 	andeq	r8, r0, r8, ror #19
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa1c4>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3470c4>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a84 	andeq	r8, r0, r4, lsl #21
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa1e4>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3470e4>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b44 	andeq	r8, r0, r4, asr #22
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa204>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347104>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008bf0 	strdeq	r8, [r0], -r0
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa224>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347124>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008c44 	andeq	r8, r0, r4, asr #24
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa244>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347144>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008cac 	andeq	r8, r0, ip, lsr #25
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa264>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347164>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003d4 	ldrdeq	r0, [r0], -r4
 4cc:	00008d2c 	andeq	r8, r0, ip, lsr #26
 4d0:	0000006c 	andeq	r0, r0, ip, rrx
 4d4:	8b040e42 	blhi	103de4 <__bss_end+0xfa284>
 4d8:	0b0d4201 	bleq	350ce4 <__bss_end+0x347184>
 4dc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ec:	00008d98 	muleq	r0, r8, sp
 4f0:	000000c4 	andeq	r0, r0, r4, asr #1
 4f4:	8b080e42 	blhi	203e04 <__bss_end+0x1fa2a4>
 4f8:	42018e02 	andmi	r8, r1, #2, 28
 4fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 500:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 504:	00000020 	andeq	r0, r0, r0, lsr #32
 508:	000003d4 	ldrdeq	r0, [r0], -r4
 50c:	00008e5c 	andeq	r8, r0, ip, asr lr
 510:	00000440 	andeq	r0, r0, r0, asr #8
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa2c4>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x3471c4>
 51c:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 520:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 524:	00000000 	andeq	r0, r0, r0
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003d4 	ldrdeq	r0, [r0], -r4
 530:	0000929c 	muleq	r0, ip, r2
 534:	000000d4 	ldrdeq	r0, [r0], -r4
 538:	8b080e42 	blhi	203e48 <__bss_end+0x1fa2e8>
 53c:	42018e02 	andmi	r8, r1, #2, 28
 540:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 544:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003d4 	ldrdeq	r0, [r0], -r4
 550:	00009370 	andeq	r9, r0, r0, ror r3
 554:	0000003c 	andeq	r0, r0, ip, lsr r0
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa308>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x347208>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003d4 	ldrdeq	r0, [r0], -r4
 570:	000093ac 	andeq	r9, r0, ip, lsr #7
 574:	00000040 	andeq	r0, r0, r0, asr #32
 578:	8b040e42 	blhi	103e88 <__bss_end+0xfa328>
 57c:	0b0d4201 	bleq	350d88 <__bss_end+0x347228>
 580:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 584:	00000ecb 	andeq	r0, r0, fp, asr #29
 588:	0000001c 	andeq	r0, r0, ip, lsl r0
 58c:	000003d4 	ldrdeq	r0, [r0], -r4
 590:	000093ec 	andeq	r9, r0, ip, ror #7
 594:	00000030 	andeq	r0, r0, r0, lsr r0
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa348>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 5a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5a8:	00000020 	andeq	r0, r0, r0, lsr #32
 5ac:	000003d4 	ldrdeq	r0, [r0], -r4
 5b0:	0000941c 	andeq	r9, r0, ip, lsl r4
 5b4:	00000324 	andeq	r0, r0, r4, lsr #6
 5b8:	8b080e42 	blhi	203ec8 <__bss_end+0x1fa368>
 5bc:	42018e02 	andmi	r8, r1, #2, 28
 5c0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5c4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5c8:	00000008 	andeq	r0, r0, r8
 5cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d0:	000003d4 	ldrdeq	r0, [r0], -r4
 5d4:	00009740 	andeq	r9, r0, r0, asr #14
 5d8:	00000110 	andeq	r0, r0, r0, lsl r1
 5dc:	8b040e42 	blhi	103eec <__bss_end+0xfa38c>
 5e0:	0b0d4201 	bleq	350dec <__bss_end+0x34728c>
 5e4:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 5e8:	000ecb42 	andeq	ip, lr, r2, asr #22
 5ec:	0000000c 	andeq	r0, r0, ip
 5f0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5f4:	7c010001 	stcvc	0, cr0, [r1], {1}
 5f8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5fc:	0000000c 	andeq	r0, r0, ip
 600:	000005ec 	andeq	r0, r0, ip, ror #11
 604:	00009850 	andeq	r9, r0, r0, asr r8
 608:	000001ec 	andeq	r0, r0, ip, ror #3
