
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
    805c:	00009b68 	andeq	r9, r0, r8, ror #22
    8060:	00009b80 	andeq	r9, r0, r0, lsl #23

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
    81cc:	00009b65 	andeq	r9, r0, r5, ror #22
    81d0:	00009b65 	andeq	r9, r0, r5, ror #22

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
    8224:	00009b65 	andeq	r9, r0, r5, ror #22
    8228:	00009b65 	andeq	r9, r0, r5, ror #22

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
    82a0:	00009b68 	andeq	r9, r0, r8, ror #22
    82a4:	00009ad8 	ldrdeq	r9, [r0], -r8
    82a8:	00009adc 	ldrdeq	r9, [r0], -ip

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
    8400:	00009ae0 	andeq	r9, r0, r0, ror #21
    8404:	00009b68 	andeq	r9, r0, r8, ror #22
    8408:	00009aec 	andeq	r9, r0, ip, ror #21
    840c:	00009b6c 	andeq	r9, r0, ip, ror #22
    8410:	00009af8 	strdeq	r9, [r0], -r8
    8414:	00009afc 	strdeq	r9, [r0], -ip

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
    8870:	00009b44 	andeq	r9, r0, r4, asr #22

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
    89e4:	00009b54 	andeq	r9, r0, r4, asr fp

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
    9258:	0a4fb11f 	beq	13f56dc <__bss_end+0x13ebb5c>
    925c:	5a0e1bca 	bpl	39018c <__bss_end+0x38660c>
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
    9290:	3a83126f 	bcc	fe0cdc54 <__bss_end+0xfe0c40d4>
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

00009a64 <_ZL9INT32_MAX>:
    9a64:	7fffffff 	svcvc	0x00ffffff

00009a68 <_ZL9INT32_MIN>:
    9a68:	80000000 	andhi	r0, r0, r0

00009a6c <_ZL10UINT32_MAX>:
    9a6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a70 <_ZL10UINT32_MIN>:
    9a70:	00000000 	andeq	r0, r0, r0

00009a74 <_ZL13Lock_Unlocked>:
    9a74:	00000000 	andeq	r0, r0, r0

00009a78 <_ZL11Lock_Locked>:
    9a78:	00000001 	andeq	r0, r0, r1

00009a7c <_ZL21MaxFSDriverNameLength>:
    9a7c:	00000010 	andeq	r0, r0, r0, lsl r0

00009a80 <_ZL17MaxFilenameLength>:
    9a80:	00000010 	andeq	r0, r0, r0, lsl r0

00009a84 <_ZL13MaxPathLength>:
    9a84:	00000080 	andeq	r0, r0, r0, lsl #1

00009a88 <_ZL18NoFilesystemDriver>:
    9a88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a8c <_ZL9NotifyAll>:
    9a8c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a90 <_ZL24Max_Process_Opened_Files>:
    9a90:	00000010 	andeq	r0, r0, r0, lsl r0

00009a94 <_ZL10Indefinite>:
    9a94:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a98 <_ZL18Deadline_Unchanged>:
    9a98:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a9c <_ZL14Invalid_Handle>:
    9a9c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009aa0 <_ZN3halL18Default_Clock_RateE>:
    9aa0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009aa4 <_ZN3halL15Peripheral_BaseE>:
    9aa4:	20000000 	andcs	r0, r0, r0

00009aa8 <_ZN3halL9GPIO_BaseE>:
    9aa8:	20200000 	eorcs	r0, r0, r0

00009aac <_ZN3halL14GPIO_Pin_CountE>:
    9aac:	00000036 	andeq	r0, r0, r6, lsr r0

00009ab0 <_ZN3halL8AUX_BaseE>:
    9ab0:	20215000 	eorcs	r5, r1, r0

00009ab4 <_ZN3halL25Interrupt_Controller_BaseE>:
    9ab4:	2000b200 	andcs	fp, r0, r0, lsl #4

00009ab8 <_ZN3halL10Timer_BaseE>:
    9ab8:	2000b400 	andcs	fp, r0, r0, lsl #8

00009abc <_ZN3halL9TRNG_BaseE>:
    9abc:	20104000 	andscs	r4, r0, r0

00009ac0 <_ZN3halL9BSC0_BaseE>:
    9ac0:	20205000 	eorcs	r5, r0, r0

00009ac4 <_ZN3halL9BSC1_BaseE>:
    9ac4:	20804000 	addcs	r4, r0, r0

00009ac8 <_ZN3halL9BSC2_BaseE>:
    9ac8:	20805000 	addcs	r5, r0, r0

00009acc <_ZL11Invalid_Pin>:
    9acc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ad0 <_ZL17symbol_tick_delay>:
    9ad0:	00000400 	andeq	r0, r0, r0, lsl #8

00009ad4 <_ZL15char_tick_delay>:
    9ad4:	00001000 	andeq	r1, r0, r0
    9ad8:	00000031 	andeq	r0, r0, r1, lsr r0
    9adc:	00000030 	andeq	r0, r0, r0, lsr r0
    9ae0:	3a564544 	bcc	159aff8 <__bss_end+0x1591478>
    9ae4:	6f697067 	svcvs	0x00697067
    9ae8:	0038312f 	eorseq	r3, r8, pc, lsr #2
    9aec:	3a564544 	bcc	159b004 <__bss_end+0x1591484>
    9af0:	6f697067 	svcvs	0x00697067
    9af4:	0036312f 	eorseq	r3, r6, pc, lsr #2
    9af8:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    9afc:	21534f53 	cmpcs	r3, r3, asr pc
    9b00:	00000000 	andeq	r0, r0, r0

00009b04 <_ZL9INT32_MAX>:
    9b04:	7fffffff 	svcvc	0x00ffffff

00009b08 <_ZL9INT32_MIN>:
    9b08:	80000000 	andhi	r0, r0, r0

00009b0c <_ZL10UINT32_MAX>:
    9b0c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b10 <_ZL10UINT32_MIN>:
    9b10:	00000000 	andeq	r0, r0, r0

00009b14 <_ZL13Lock_Unlocked>:
    9b14:	00000000 	andeq	r0, r0, r0

00009b18 <_ZL11Lock_Locked>:
    9b18:	00000001 	andeq	r0, r0, r1

00009b1c <_ZL21MaxFSDriverNameLength>:
    9b1c:	00000010 	andeq	r0, r0, r0, lsl r0

00009b20 <_ZL17MaxFilenameLength>:
    9b20:	00000010 	andeq	r0, r0, r0, lsl r0

00009b24 <_ZL13MaxPathLength>:
    9b24:	00000080 	andeq	r0, r0, r0, lsl #1

00009b28 <_ZL18NoFilesystemDriver>:
    9b28:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b2c <_ZL9NotifyAll>:
    9b2c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b30 <_ZL24Max_Process_Opened_Files>:
    9b30:	00000010 	andeq	r0, r0, r0, lsl r0

00009b34 <_ZL10Indefinite>:
    9b34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b38 <_ZL18Deadline_Unchanged>:
    9b38:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009b3c <_ZL14Invalid_Handle>:
    9b3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009b40 <_ZL8INFINITY>:
    9b40:	7f7fffff 	svcvc	0x007fffff

00009b44 <_ZL16Pipe_File_Prefix>:
    9b44:	3a535953 	bcc	14e0098 <__bss_end+0x14d6518>
    9b48:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9b4c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009b50 <_ZL8INFINITY>:
    9b50:	7f7fffff 	svcvc	0x007fffff

00009b54 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9b54:	33323130 	teqcc	r2, #48, 2
    9b58:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9b5c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9b60:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009b68 <sos_led>:
__bss_start():
    9b68:	00000000 	andeq	r0, r0, r0

00009b6c <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683cac>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x388a4>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c4b8>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c71a4>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfabc>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36d86>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff624f>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x157218>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7620>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x77654>
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
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfc34>
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
 224:	6b736174 	blvs	1cd87fc <__bss_end+0x1ccec7c>
 228:	6f682f00 	svcvs	0x00682f00
 22c:	6a2f656d 	bvs	bd97e8 <__bss_end+0xbcfc68>
 230:	73656d61 	cmnvc	r5, #6208	; 0x1840
 234:	2f697261 	svccs	0x00697261
 238:	2f746967 	svccs	0x00746967
 23c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 240:	6f732f70 	svcvs	0x00732f70
 244:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 248:	73752f73 	cmnvc	r5, #460	; 0x1cc
 24c:	70737265 	rsbsvc	r7, r3, r5, ror #4
 250:	2f656361 	svccs	0x00656361
 254:	6b2f2e2e 	blvs	bcbb14 <__bss_end+0xbc1f94>
 258:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 25c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 260:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 264:	6f622f65 	svcvs	0x00622f65
 268:	2f647261 	svccs	0x00647261
 26c:	30697072 	rsbcc	r7, r9, r2, ror r0
 270:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 274:	6f682f00 	svcvs	0x00682f00
 278:	6a2f656d 	bvs	bd9834 <__bss_end+0xbcfcb4>
 27c:	73656d61 	cmnvc	r5, #6208	; 0x1840
 280:	2f697261 	svccs	0x00697261
 284:	2f746967 	svccs	0x00746967
 288:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 28c:	6f732f70 	svcvs	0x00732f70
 290:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 294:	73752f73 	cmnvc	r5, #460	; 0x1cc
 298:	70737265 	rsbsvc	r7, r3, r5, ror #4
 29c:	2f656361 	svccs	0x00656361
 2a0:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
 2a4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 2a8:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 2ac:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2b0:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 2b4:	2f656d6f 	svccs	0x00656d6f
 2b8:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2bc:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2c0:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 2c4:	2f736f2f 	svccs	0x00736f2f
 2c8:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2cc:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2d0:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff73 <__bss_end+0xffff63f3>
 2d4:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2d8:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2dc:	2f2e2e2f 	svccs	0x002e2e2f
 2e0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2e4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2e8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2ec:	702f6564 	eorvc	r6, pc, r4, ror #10
 2f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2f4:	2f007373 	svccs	0x00007373
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
 388:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 38c:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 390:	00020068 	andeq	r0, r2, r8, rrx
 394:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 398:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 39c:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 3a0:	00000300 	andeq	r0, r0, r0, lsl #6
 3a4:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 3a8:	00040068 	andeq	r0, r4, r8, rrx
 3ac:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 3b0:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 3b4:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 3b8:	66000004 	strvs	r0, [r0], -r4
 3bc:	73656c69 	cmnvc	r5, #26880	; 0x6900
 3c0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 3c4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 3c8:	70000005 	andvc	r0, r0, r5
 3cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3d0:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 3d4:	00000400 	andeq	r0, r0, r0, lsl #8
 3d8:	636f7270 	cmnvs	pc, #112, 4
 3dc:	5f737365 	svcpl	0x00737365
 3e0:	616e616d 	cmnvs	lr, sp, ror #2
 3e4:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 3e8:	00040068 	andeq	r0, r4, r8, rrx
 3ec:	72657000 	rsbvc	r7, r5, #0
 3f0:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 3f4:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 3f8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3fc:	70670000 	rsbvc	r0, r7, r0
 400:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 404:	00000600 	andeq	r0, r0, r0, lsl #12
 408:	00010500 	andeq	r0, r1, r0, lsl #10
 40c:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 410:	16030000 	strne	r0, [r3], -r0
 414:	9f070501 	svcls	0x00070501
 418:	040200bb 	streq	r0, [r2], #-187	; 0xffffff45
 41c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 420:	4a020402 	bmi	81430 <__bss_end+0x778b0>
 424:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 428:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 42c:	05670604 	strbeq	r0, [r7, #-1540]!	; 0xfffff9fc
 430:	04020001 	streq	r0, [r2], #-1
 434:	05bdbb04 	ldreq	fp, [sp, #2820]!	; 0xb04
 438:	0a059f10 	beq	168080 <__bss_end+0x15e500>
 43c:	4b0f0582 	blmi	3c1a4c <__bss_end+0x3b7ecc>
 440:	05820905 	streq	r0, [r2, #2309]	; 0x905
 444:	07054c17 	smladeq	r5, r7, ip, r4
 448:	bc19054b 	cfldr32lt	mvfx0, [r9], {75}	; 0x4b
 44c:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 450:	05870104 	streq	r0, [r7, #260]	; 0x104
 454:	04020008 	streq	r0, [r2], #-8
 458:	ba090301 	blt	241064 <__bss_end+0x2374e4>
 45c:	01040200 	mrseq	r0, R12_usr
 460:	04020084 	streq	r0, [r2], #-132	; 0xffffff7c
 464:	02004b01 	andeq	r4, r0, #1024	; 0x400
 468:	00670104 	rsbeq	r0, r7, r4, lsl #2
 46c:	4b010402 	blmi	4147c <__bss_end+0x378fc>
 470:	01040200 	mrseq	r0, R12_usr
 474:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 478:	02004c01 	andeq	r4, r0, #256	; 0x100
 47c:	00680104 	rsbeq	r0, r8, r4, lsl #2
 480:	4b010402 	blmi	41490 <__bss_end+0x37910>
 484:	01040200 	mrseq	r0, R12_usr
 488:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 48c:	02004b01 	andeq	r4, r0, #1024	; 0x400
 490:	00670104 	rsbeq	r0, r7, r4, lsl #2
 494:	4b010402 	blmi	414a4 <__bss_end+0x37924>
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
 538:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 53c:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 540:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 544:	61682f30 	cmnvs	r8, r0, lsr pc
 548:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 54c:	2f656d6f 	svccs	0x00656d6f
 550:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 554:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 558:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 55c:	2f736f2f 	svccs	0x00736f2f
 560:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 564:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 568:	6b2f7365 	blvs	bdd304 <__bss_end+0xbd3784>
 56c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 570:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 574:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 578:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 57c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 580:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 584:	2f656d6f 	svccs	0x00656d6f
 588:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 58c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 590:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 594:	2f736f2f 	svccs	0x00736f2f
 598:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 59c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 5a0:	6b2f7365 	blvs	bdd33c <__bss_end+0xbd37bc>
 5a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5a8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5ac:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5b0:	73662f65 	cmnvc	r6, #404	; 0x194
 5b4:	6f682f00 	svcvs	0x00682f00
 5b8:	6a2f656d 	bvs	bd9b74 <__bss_end+0xbcfff4>
 5bc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 5c0:	2f697261 	svccs	0x00697261
 5c4:	2f746967 	svccs	0x00746967
 5c8:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 5cc:	6f732f70 	svcvs	0x00732f70
 5d0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 5d4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 5d8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 5dc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 5e0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 5e4:	74730000 	ldrbtvc	r0, [r3], #-0
 5e8:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 5ec:	70632e65 	rsbvc	r2, r3, r5, ror #28
 5f0:	00010070 	andeq	r0, r1, r0, ror r0
 5f4:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 5f8:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 5fc:	00020068 	andeq	r0, r2, r8, rrx
 600:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 604:	0300682e 	movweq	r6, #2094	; 0x82e
 608:	70730000 	rsbsvc	r0, r3, r0
 60c:	6f6c6e69 	svcvs	0x006c6e69
 610:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 614:	00000300 	andeq	r0, r0, r0, lsl #6
 618:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 61c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 620:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 624:	00000400 	andeq	r0, r0, r0, lsl #8
 628:	636f7270 	cmnvs	pc, #112, 4
 62c:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 630:	00030068 	andeq	r0, r3, r8, rrx
 634:	6f727000 	svcvs	0x00727000
 638:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 63c:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 640:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 644:	0300682e 	movweq	r6, #2094	; 0x82e
 648:	74730000 	ldrbtvc	r0, [r3], #-0
 64c:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 650:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
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
 684:	4b2e05a1 	blmi	b81d10 <__bss_end+0xb78190>
 688:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 68c:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 690:	2f01054c 	svccs	0x0001054c
 694:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 698:	054b3005 	strbeq	r3, [fp, #-5]
 69c:	1b054b2e 	blne	15335c <__bss_end+0x1497dc>
 6a0:	2f2e054b 	svccs	0x002e054b
 6a4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6a8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6ac:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 6b0:	4b2e054b 	blmi	b81be4 <__bss_end+0xb78064>
 6b4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6b8:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 6bc:	2f01054c 	svccs	0x0001054c
 6c0:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 6c4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6c8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6cc:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 6d0:	4b2f054b 	blmi	bc1c04 <__bss_end+0xbb8084>
 6d4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6d8:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 6dc:	2f01054c 	svccs	0x0001054c
 6e0:	a12e0585 	smlawbge	lr, r5, r5, r0
 6e4:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6e8:	2f054b1b 	svccs	0x00054b1b
 6ec:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6f0:	852f0105 	strhi	r0, [pc, #-261]!	; 5f3 <shift+0x5f3>
 6f4:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 6f8:	3b054b2f 	blcc	1533bc <__bss_end+0x14983c>
 6fc:	4b1b054b 	blmi	6c1c30 <__bss_end+0x6b80b0>
 700:	052f3005 	streq	r3, [pc, #-5]!	; 703 <shift+0x703>
 704:	01054c0c 	tsteq	r5, ip, lsl #24
 708:	2f05852f 	svccs	0x0005852f
 70c:	4b3b05a1 	blmi	ec1d98 <__bss_end+0xeb8218>
 710:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 714:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 718:	9f01054c 	svcls	0x0001054c
 71c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 720:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 724:	1a054b31 	bne	1533f0 <__bss_end+0x149870>
 728:	300c054b 	andcc	r0, ip, fp, asr #10
 72c:	852f0105 	strhi	r0, [pc, #-261]!	; 62f <shift+0x62f>
 730:	05672005 	strbeq	r2, [r7, #-5]!
 734:	31054d2d 	tstcc	r5, sp, lsr #26
 738:	4b1a054b 	blmi	681c6c <__bss_end+0x6780ec>
 73c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 740:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 744:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 748:	4b3e054c 	blmi	f81c80 <__bss_end+0xf78100>
 74c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 750:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 754:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 758:	4b30054d 	blmi	c01c94 <__bss_end+0xbf8114>
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
 790:	fb010200 	blx	40f9a <__bss_end+0x3741a>
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
 834:	0b05ba0a 	bleq	16f064 <__bss_end+0x1654e4>
 838:	4a27052e 	bmi	9c1cf8 <__bss_end+0x9b8178>
 83c:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 840:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 844:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 848:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 84c:	11056810 	tstne	r5, r0, lsl r8
 850:	4a22052e 	bmi	881d10 <__bss_end+0x878190>
 854:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 858:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 85c:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 860:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 864:	0b054b03 	bleq	153478 <__bss_end+0x1498f8>
 868:	00180568 	andseq	r0, r8, r8, ror #10
 86c:	4a030402 	bmi	c187c <__bss_end+0xb7cfc>
 870:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 874:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 878:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 87c:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 880:	02040200 	andeq	r0, r4, #0, 4
 884:	00080582 	andeq	r0, r8, r2, lsl #11
 888:	4a020402 	bmi	81898 <__bss_end+0x77d18>
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
 8b4:	0a052e02 	beq	14c0c4 <__bss_end+0x142544>
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
 8e4:	4a0305bb 	bmi	c1fd8 <__bss_end+0xb8458>
 8e8:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8ec:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8f0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 8f4:	0d054a01 	vstreq	s8, [r5, #-4]
 8f8:	4a14054d 	bmi	501e34 <__bss_end+0x4f82b4>
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
 940:	4a030402 	bmi	c1950 <__bss_end+0xb7dd0>
 944:	02000905 	andeq	r0, r0, #81920	; 0x14000
 948:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 94c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 950:	0b054a03 	bleq	153164 <__bss_end+0x1495e4>
 954:	03040200 	movweq	r0, #16896	; 0x4200
 958:	0002052e 	andeq	r0, r2, lr, lsr #10
 95c:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 960:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 964:	05840204 	streq	r0, [r4, #516]	; 0x204
 968:	04020008 	streq	r0, [r2], #-8
 96c:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 970:	01040200 	mrseq	r0, R12_usr
 974:	000b052e 	andeq	r0, fp, lr, lsr #10
 978:	4a010402 	bmi	41988 <__bss_end+0x37e08>
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
 9cc:	0b059f08 	bleq	1685f4 <__bss_end+0x15ea74>
 9d0:	0014054c 	andseq	r0, r4, ip, asr #10
 9d4:	4a030402 	bmi	c19e4 <__bss_end+0xb7e64>
 9d8:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 9dc:	05830204 	streq	r0, [r3, #516]	; 0x204
 9e0:	04020008 	streq	r0, [r2], #-8
 9e4:	0a052e02 	beq	14c1f4 <__bss_end+0x142674>
 9e8:	02040200 	andeq	r0, r4, #0, 4
 9ec:	0002054a 	andeq	r0, r2, sl, asr #10
 9f0:	49020402 	stmdbmi	r2, {r1, sl}
 9f4:	85840105 	strhi	r0, [r4, #261]	; 0x105
 9f8:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 9fc:	0b054b08 	bleq	153624 <__bss_end+0x149aa4>
 a00:	0014054c 	andseq	r0, r4, ip, asr #10
 a04:	4a030402 	bmi	c1a14 <__bss_end+0xb7e94>
 a08:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 a0c:	05830204 	streq	r0, [r3, #516]	; 0x204
 a10:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 a14:	0a052e02 	beq	14c224 <__bss_end+0x1426a4>
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
 a48:	0b054a03 	bleq	15325c <__bss_end+0x1496dc>
 a4c:	02040200 	andeq	r0, r4, #0, 4
 a50:	00050583 	andeq	r0, r5, r3, lsl #11
 a54:	81020402 	tsthi	r2, r2, lsl #8
 a58:	05850c05 	streq	r0, [r5, #3077]	; 0xc05
 a5c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 a60:	0c058411 	cfstrseq	mvf8, [r5], {17}
 a64:	00180568 	andseq	r0, r8, r8, ror #10
 a68:	4a030402 	bmi	c1a78 <__bss_end+0xb7ef8>
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
 af8:	1a059f09 	bne	168724 <__bss_end+0x15eba4>
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
 b68:	1a059f09 	bne	168794 <__bss_end+0x15ec14>
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
 bb0:	4b1a0566 	blmi	682150 <__bss_end+0x6785d0>
 bb4:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 bb8:	0f05820b 	svceq	0x0005820b
 bbc:	660d0567 	strvs	r0, [sp], -r7, ror #10
 bc0:	054b1905 	strbeq	r1, [fp, #-2309]	; 0xfffff6fb
 bc4:	11054a12 	tstne	r5, r2, lsl sl
 bc8:	4a05054a 	bmi	1420f8 <__bss_end+0x138578>
 bcc:	0b030105 	bleq	c0fe8 <__bss_end+0xb7468>
 bd0:	03090582 	movweq	r0, #38274	; 0x9582
 bd4:	10052e76 	andne	r2, r5, r6, ror lr
 bd8:	670c054a 	strvs	r0, [ip, -sl, asr #10]
 bdc:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 be0:	0d056715 	stceq	7, cr6, [r5, #-84]	; 0xffffffac
 be4:	4a150567 	bmi	542188 <__bss_end+0x538608>
 be8:	05671005 	strbeq	r1, [r7, #-5]!
 bec:	1a054a0d 	bne	153428 <__bss_end+0x1498a8>
 bf0:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 bf4:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 bf8:	2e026a01 	vmlacs.f32	s12, s4, s2
 bfc:	bb060515 	bllt	182058 <__bss_end+0x1784d8>
 c00:	054b1205 	strbeq	r1, [fp, #-517]	; 0xfffffdfb
 c04:	20056615 	andcs	r6, r5, r5, lsl r6
 c08:	082305bb 	stmdaeq	r3!, {r0, r1, r3, r4, r5, r7, r8, sl}
 c0c:	2e120520 	cfmul64cs	mvdx0, mvdx2, mvdx0
 c10:	05821405 	streq	r1, [r2, #1029]	; 0x405
 c14:	16054a23 	strne	r4, [r5], -r3, lsr #20
 c18:	2f0b054a 	svccs	0x000b054a
 c1c:	059c0505 	ldreq	r0, [ip, #1285]	; 0x505
 c20:	0b053206 	bleq	14d440 <__bss_end+0x1438c0>
 c24:	4a0d052e 	bmi	3420e4 <__bss_end+0x338564>
 c28:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 c2c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 c30:	0105830e 	tsteq	r5, lr, lsl #6
 c34:	0d0585d7 	cfstr32eq	mvfx8, [r5, #-860]	; 0xfffffca4
 c38:	d7010583 	strle	r0, [r1, -r3, lsl #11]
 c3c:	9f0605a2 	svcls	0x000605a2
 c40:	6a830105 	bvs	fe0c105c <__bss_end+0xfe0b74dc>
 c44:	05bb0f05 	ldreq	r0, [fp, #3845]!	; 0xf05
 c48:	0c054b05 			; <UNDEFINED> instruction: 0x0c054b05
 c4c:	660e0584 	strvs	r0, [lr], -r4, lsl #11
 c50:	054a1005 	strbeq	r1, [sl, #-5]
 c54:	0d054b05 	vstreq	d4, [r5, #-20]	; 0xffffffec
 c58:	66050568 	strvs	r0, [r5], -r8, ror #10
 c5c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 c60:	1005660e 	andne	r6, r5, lr, lsl #12
 c64:	4b0c054a 	blmi	302194 <__bss_end+0x2f8614>
 c68:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c6c:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c70:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c74:	054a1005 	strbeq	r1, [sl, #-5]
 c78:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c7c:	4a100566 	bmi	40221c <__bss_end+0x3f869c>
 c80:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c84:	0505300d 	streq	r3, [r5, #-13]
 c88:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
 c8c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c90:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c94:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c98:	054a1005 	strbeq	r1, [sl, #-5]
 c9c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 ca0:	4a100566 	bmi	402240 <__bss_end+0x3f86c0>
 ca4:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 ca8:	1005660e 	andne	r6, r5, lr, lsl #12
 cac:	4b03054a 	blmi	c21dc <__bss_end+0xb865c>
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
 d0c:	1a054a10 	bne	153554 <__bss_end+0x1499d4>
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
 d40:	2a020402 	bcs	81d50 <__bss_end+0x781d0>
 d44:	05850505 	streq	r0, [r5, #1285]	; 0x505
 d48:	0402000b 	streq	r0, [r2], #-11
 d4c:	0d053202 	sfmeq	f3, 4, [r5, #-8]
 d50:	02040200 	andeq	r0, r4, #0, 4
 d54:	4b010566 	blmi	422f4 <__bss_end+0x38774>
 d58:	83090585 	movwhi	r0, #38277	; 0x9585
 d5c:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 d60:	03054b07 	movweq	r4, #23303	; 0x5b07
 d64:	4b06054a 	blmi	182294 <__bss_end+0x178714>
 d68:	05670a05 	strbeq	r0, [r7, #-2565]!	; 0xfffff5fb
 d6c:	1c054c0c 	stcne	12, cr4, [r5], {12}
 d70:	01040200 	mrseq	r0, R12_usr
 d74:	001d054a 	andseq	r0, sp, sl, asr #10
 d78:	4a010402 	bmi	41d88 <__bss_end+0x38208>
 d7c:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
 d80:	12054a05 	andne	r4, r5, #20480	; 0x5000
 d84:	01040200 	mrseq	r0, R12_usr
 d88:	0007054b 	andeq	r0, r7, fp, asr #10
 d8c:	4b010402 	blmi	41d9c <__bss_end+0x3821c>
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
 db8:	4a780302 	bmi	1e019c8 <__bss_end+0x1df7e48>
 dbc:	0b031005 	bleq	c4dd8 <__bss_end+0xbb258>
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
 e9c:	0bb40300 	bleq	fed01aa4 <__bss_end+0xfecf7f24>
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
      58:	076b0704 	strbeq	r0, [fp, -r4, lsl #14]!
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
     128:	0000076b 	andeq	r0, r0, fp, ror #14
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408600>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36614>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a2d8>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x366e4>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f690c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000ec9 	andeq	r0, r0, r9, asr #29
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0011f604 	andseq	pc, r1, r4, lsl #12
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0001ec00 	andeq	lr, r1, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	12780200 	rsbsne	r0, r8, #0, 4
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	60030500 	andvs	r0, r3, r0, lsl #10
     308:	0300009a 	movweq	r0, #154	; 0x9a
     30c:	1c210404 	cfstrsne	mvf0, [r1], #-16
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	10240801 	eorne	r0, r4, r1, lsl #16
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0da90502 	cfstr32eq	mvfx0, [r9, #8]!
     328:	ec050000 	stc	0, cr0, [r5], {-0}
     32c:	02000006 	andeq	r0, r0, #6
     330:	00670705 	rsbeq	r0, r7, r5, lsl #14
     334:	56040000 	strpl	r0, [r4], -r0
     338:	06000000 	streq	r0, [r0], -r0
     33c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     340:	08030074 	stmdaeq	r3, {r2, r4, r5, r6}
     344:	00031f05 	andeq	r1, r3, r5, lsl #30
     348:	08010300 	stmdaeq	r1, {r8, r9}
     34c:	0000101b 	andeq	r1, r0, fp, lsl r0
     350:	b5070203 	strlt	r0, [r7, #-515]	; 0xfffffdfd
     354:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     358:	000006eb 	andeq	r0, r0, fp, ror #13
     35c:	94070a02 	strls	r0, [r7], #-2562	; 0xfffff5fe
     360:	04000000 	streq	r0, [r0], #-0
     364:	00000083 	andeq	r0, r0, r3, lsl #1
     368:	6b070403 	blvs	1c137c <__bss_end+0x1b77fc>
     36c:	04000007 	streq	r0, [r0], #-7
     370:	00000094 	muleq	r0, r4, r0
     374:	00009407 	andeq	r9, r0, r7, lsl #8
     378:	07080300 	streq	r0, [r8, -r0, lsl #6]
     37c:	00000761 	andeq	r0, r0, r1, ror #14
     380:	000e4102 	andeq	r4, lr, r2, lsl #2
     384:	130d0200 	movwne	r0, #53760	; 0xd200
     388:	00000062 	andeq	r0, r0, r2, rrx
     38c:	9a640305 	bls	1900fa8 <__bss_end+0x18f7428>
     390:	8b020000 	blhi	80398 <__bss_end+0x76818>
     394:	02000007 	andeq	r0, r0, #7
     398:	0062130e 	rsbeq	r1, r2, lr, lsl #6
     39c:	03050000 	movweq	r0, #20480	; 0x5000
     3a0:	00009a68 	andeq	r9, r0, r8, ror #20
     3a4:	000e4002 	andeq	r4, lr, r2
     3a8:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     3ac:	0000008f 	andeq	r0, r0, pc, lsl #1
     3b0:	9a6c0305 	bls	1b00fcc <__bss_end+0x1af744c>
     3b4:	8a020000 	bhi	803bc <__bss_end+0x7683c>
     3b8:	02000007 	andeq	r0, r0, #7
     3bc:	008f1411 	addeq	r1, pc, r1, lsl r4	; <UNPREDICTABLE>
     3c0:	03050000 	movweq	r0, #20480	; 0x5000
     3c4:	00009a70 	andeq	r9, r0, r0, ror sl
     3c8:	0012f408 	andseq	pc, r2, r8, lsl #8
     3cc:	06040800 	streq	r0, [r4], -r0, lsl #16
     3d0:	00011a08 	andeq	r1, r1, r8, lsl #20
     3d4:	30720900 	rsbscc	r0, r2, r0, lsl #18
     3d8:	0e080400 	cfcpyseq	mvf0, mvf8
     3dc:	00000083 	andeq	r0, r0, r3, lsl #1
     3e0:	31720900 	cmncc	r2, r0, lsl #18
     3e4:	0e090400 	cfcpyseq	mvf0, mvf9
     3e8:	00000083 	andeq	r0, r0, r3, lsl #1
     3ec:	6b0a0004 	blvs	280404 <__bss_end+0x276884>
     3f0:	0500000e 	streq	r0, [r0, #-14]
     3f4:	00006704 	andeq	r6, r0, r4, lsl #14
     3f8:	0c1e0400 	cfldrseq	mvf0, [lr], {-0}
     3fc:	00000151 	andeq	r0, r0, r1, asr r1
     400:	0006e30b 	andeq	lr, r6, fp, lsl #6
     404:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
     408:	01000009 	tsteq	r0, r9
     40c:	000e8d0b 	andeq	r8, lr, fp, lsl #26
     410:	370b0200 	strcc	r0, [fp, -r0, lsl #4]
     414:	03000010 	movweq	r0, #16
     418:	0009190b 	andeq	r1, r9, fp, lsl #18
     41c:	810b0400 	tsthi	fp, r0, lsl #8
     420:	0500000d 	streq	r0, [r0, #-13]
     424:	0e4b0a00 	vmlaeq.f32	s1, s22, s0
     428:	04050000 	streq	r0, [r5], #-0
     42c:	00000067 	andeq	r0, r0, r7, rrx
     430:	8e0c4404 	cdphi	4, 0, cr4, cr12, cr4, {0}
     434:	0b000001 	bleq	440 <shift+0x440>
     438:	00000870 	andeq	r0, r0, r0, ror r8
     43c:	0f740b00 	svceq	0x00740b00
     440:	0b010000 	bleq	40448 <__bss_end+0x368c8>
     444:	00001272 	andeq	r1, r0, r2, ror r2
     448:	0c800b02 	vstmiaeq	r0, {d0}
     44c:	0b030000 	bleq	c0454 <__bss_end+0xb68d4>
     450:	00000928 	andeq	r0, r0, r8, lsr #18
     454:	0a170b04 	beq	5c306c <__bss_end+0x5b94ec>
     458:	0b050000 	bleq	140460 <__bss_end+0x1368e0>
     45c:	00000750 	andeq	r0, r0, r0, asr r7
     460:	350a0006 	strcc	r0, [sl, #-6]
     464:	05000007 	streq	r0, [r0, #-7]
     468:	00006704 	andeq	r6, r0, r4, lsl #14
     46c:	0c6b0400 	cfstrdeq	mvd0, [fp], #-0
     470:	000001b9 			; <UNDEFINED> instruction: 0x000001b9
     474:	0010100b 	andseq	r1, r0, fp
     478:	920b0000 	andls	r0, fp, #0
     47c:	01000005 	tsteq	r0, r5
     480:	000eb10b 	andeq	fp, lr, fp, lsl #2
     484:	910b0200 	mrsls	r0, R11_fiq
     488:	0300000d 	movweq	r0, #13
     48c:	0d5f0500 	cfldr64eq	mvdx0, [pc, #-0]	; 494 <shift+0x494>
     490:	03050000 	movweq	r0, #20480	; 0x5000
     494:	00006707 	andeq	r6, r0, r7, lsl #14
     498:	0be70200 	bleq	ff9c0ca0 <__bss_end+0xff9b7120>
     49c:	05050000 	streq	r0, [r5, #-0]
     4a0:	00008f14 	andeq	r8, r0, r4, lsl pc
     4a4:	74030500 	strvc	r0, [r3], #-1280	; 0xfffffb00
     4a8:	0200009a 	andeq	r0, r0, #154	; 0x9a
     4ac:	00000f79 	andeq	r0, r0, r9, ror pc
     4b0:	8f140605 	svchi	0x00140605
     4b4:	05000000 	streq	r0, [r0, #-0]
     4b8:	009a7803 	addseq	r7, sl, r3, lsl #16
     4bc:	0a820200 	beq	fe080cc4 <__bss_end+0xfe077144>
     4c0:	07060000 	streq	r0, [r6, -r0]
     4c4:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4c8:	7c030500 	cfstr32vc	mvfx0, [r3], {-0}
     4cc:	0200009a 	andeq	r0, r0, #154	; 0x9a
     4d0:	00000dba 			; <UNDEFINED> instruction: 0x00000dba
     4d4:	8f1a0906 	svchi	0x001a0906
     4d8:	05000000 	streq	r0, [r0, #-0]
     4dc:	009a8003 	addseq	r8, sl, r3
     4e0:	0a450200 	beq	1140ce8 <__bss_end+0x1137168>
     4e4:	0b060000 	bleq	1804ec <__bss_end+0x17696c>
     4e8:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4ec:	84030500 	strhi	r0, [r3], #-1280	; 0xfffffb00
     4f0:	0200009a 	andeq	r0, r0, #154	; 0x9a
     4f4:	00000d4c 	andeq	r0, r0, ip, asr #26
     4f8:	8f1a0d06 	svchi	0x001a0d06
     4fc:	05000000 	streq	r0, [r0, #-0]
     500:	009a8803 	addseq	r8, sl, r3, lsl #16
     504:	069e0200 	ldreq	r0, [lr], r0, lsl #4
     508:	0f060000 	svceq	0x00060000
     50c:	00008f1a 	andeq	r8, r0, sl, lsl pc
     510:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
     514:	0a00009a 	beq	784 <shift+0x784>
     518:	00000c66 	andeq	r0, r0, r6, ror #24
     51c:	00670405 	rsbeq	r0, r7, r5, lsl #8
     520:	1b060000 	blne	180528 <__bss_end+0x1769a8>
     524:	0002680c 	andeq	r6, r2, ip, lsl #16
     528:	06410b00 	strbeq	r0, [r1], -r0, lsl #22
     52c:	0b000000 	bleq	534 <shift+0x534>
     530:	000010a3 	andeq	r1, r0, r3, lsr #1
     534:	126d0b01 	rsbne	r0, sp, #1024	; 0x400
     538:	00020000 	andeq	r0, r2, r0
     53c:	0004190c 	andeq	r1, r4, ip, lsl #18
     540:	04e10d00 	strbteq	r0, [r1], #3328	; 0xd00
     544:	06900000 	ldreq	r0, [r0], r0
     548:	03db0763 	bicseq	r0, fp, #25952256	; 0x18c0000
     54c:	1d080000 	stcne	0, cr0, [r8, #-0]
     550:	24000006 	strcs	r0, [r0], #-6
     554:	f5106706 			; <UNDEFINED> instruction: 0xf5106706
     558:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     55c:	000021b0 			; <UNDEFINED> instruction: 0x000021b0
     560:	db126906 	blle	49a980 <__bss_end+0x490e00>
     564:	00000003 	andeq	r0, r0, r3
     568:	0008750e 	andeq	r7, r8, lr, lsl #10
     56c:	126b0600 	rsbne	r0, fp, #0, 12
     570:	000003eb 	andeq	r0, r0, fp, ror #7
     574:	06360e10 			; <UNDEFINED> instruction: 0x06360e10
     578:	6d060000 	stcvs	0, cr0, [r6, #-0]
     57c:	00008316 	andeq	r8, r0, r6, lsl r3
     580:	8a0e1400 	bhi	385588 <__bss_end+0x37ba08>
     584:	0600000d 	streq	r0, [r0], -sp
     588:	03f21c70 	mvnseq	r1, #112, 24	; 0x7000
     58c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     590:	000011ed 	andeq	r1, r0, sp, ror #3
     594:	f21c7206 	vhsub.s16	d7, d12, d6
     598:	1c000003 	stcne	0, cr0, [r0], {3}
     59c:	0004dc0e 	andeq	sp, r4, lr, lsl #24
     5a0:	1c750600 	ldclne	6, cr0, [r5], #-0
     5a4:	000003f2 	strdeq	r0, [r0], -r2
     5a8:	0e2f0f20 	cdpeq	15, 2, cr0, cr15, cr0, {1}
     5ac:	77060000 	strvc	r0, [r6, -r0]
     5b0:	0011401c 	andseq	r4, r1, ip, lsl r0
     5b4:	0003f200 	andeq	pc, r3, r0, lsl #4
     5b8:	0002e900 	andeq	lr, r2, r0, lsl #18
     5bc:	03f21000 	mvnseq	r1, #0
     5c0:	f8110000 			; <UNDEFINED> instruction: 0xf8110000
     5c4:	00000003 	andeq	r0, r0, r3
     5c8:	12620800 	rsbne	r0, r2, #0, 16
     5cc:	06180000 	ldreq	r0, [r8], -r0
     5d0:	032a107b 			; <UNDEFINED> instruction: 0x032a107b
     5d4:	b00e0000 	andlt	r0, lr, r0
     5d8:	06000021 	streq	r0, [r0], -r1, lsr #32
     5dc:	03db127e 	bicseq	r1, fp, #-536870905	; 0xe0000007
     5e0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     5e4:	0000053e 	andeq	r0, r0, lr, lsr r5
     5e8:	f8198006 			; <UNDEFINED> instruction: 0xf8198006
     5ec:	10000003 	andne	r0, r0, r3
     5f0:	000a1e0e 	andeq	r1, sl, lr, lsl #28
     5f4:	21820600 	orrcs	r0, r2, r0, lsl #12
     5f8:	00000403 	andeq	r0, r0, r3, lsl #8
     5fc:	f5040014 			; <UNDEFINED> instruction: 0xf5040014
     600:	12000002 	andne	r0, r0, #2
     604:	0000048f 	andeq	r0, r0, pc, lsl #9
     608:	09218606 	stmdbeq	r1!, {r1, r2, r9, sl, pc}
     60c:	12000004 	andne	r0, r0, #4
     610:	0000089f 	muleq	r0, pc, r8	; <UNPREDICTABLE>
     614:	8f1f8806 	svchi	0x001f8806
     618:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     61c:	00000dcc 	andeq	r0, r0, ip, asr #27
     620:	7a178b06 	bvc	5e3240 <__bss_end+0x5d96c0>
     624:	00000002 	andeq	r0, r0, r2
     628:	0007d70e 	andeq	sp, r7, lr, lsl #14
     62c:	178e0600 	strne	r0, [lr, r0, lsl #12]
     630:	0000027a 	andeq	r0, r0, sl, ror r2
     634:	0b6b0e24 	bleq	1ac3ecc <__bss_end+0x1aba34c>
     638:	8f060000 	svchi	0x00060000
     63c:	00027a17 	andeq	r7, r2, r7, lsl sl
     640:	9f0e4800 	svcls	0x000e4800
     644:	06000009 	streq	r0, [r0], -r9
     648:	027a1790 	rsbseq	r1, sl, #144, 14	; 0x2400000
     64c:	136c0000 	cmnne	ip, #0
     650:	000004e1 	andeq	r0, r0, r1, ror #9
     654:	0f099306 	svceq	0x00099306
     658:	1400000d 	strne	r0, [r0], #-13
     65c:	01000004 	tsteq	r0, r4
     660:	00000394 	muleq	r0, r4, r3
     664:	0000039a 	muleq	r0, sl, r3
     668:	00041410 	andeq	r1, r4, r0, lsl r4
     66c:	24140000 	ldrcs	r0, [r4], #-0
     670:	0600000e 	streq	r0, [r0], -lr
     674:	051f0e96 	ldreq	r0, [pc, #-3734]	; fffff7e6 <__bss_end+0xffff5c66>
     678:	af010000 	svcge	0x00010000
     67c:	b5000003 	strlt	r0, [r0, #-3]
     680:	10000003 	andne	r0, r0, r3
     684:	00000414 	andeq	r0, r0, r4, lsl r4
     688:	08701500 	ldmdaeq	r0!, {r8, sl, ip}^
     68c:	99060000 	stmdbls	r6, {}	; <UNPREDICTABLE>
     690:	000c4b10 	andeq	r4, ip, r0, lsl fp
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
     6c0:	0b060201 	bleq	180ecc <__bss_end+0x17734c>
     6c4:	04180000 	ldreq	r0, [r8], #-0
     6c8:	0000027a 	andeq	r0, r0, sl, ror r2
     6cc:	004a0418 	subeq	r0, sl, r8, lsl r4
     6d0:	150c0000 	strne	r0, [ip, #-0]
     6d4:	18000011 	stmdane	r0, {r0, r4}
     6d8:	0003fe04 	andeq	pc, r3, r4, lsl #28
     6dc:	032a1600 			; <UNDEFINED> instruction: 0x032a1600
     6e0:	04140000 	ldreq	r0, [r4], #-0
     6e4:	00190000 	andseq	r0, r9, r0
     6e8:	026d0418 	rsbeq	r0, sp, #24, 8	; 0x18000000
     6ec:	04180000 	ldreq	r0, [r8], #-0
     6f0:	00000268 	andeq	r0, r0, r8, ror #4
     6f4:	000e181a 	andeq	r1, lr, sl, lsl r8
     6f8:	149c0600 	ldrne	r0, [ip], #1536	; 0x600
     6fc:	0000026d 	andeq	r0, r0, sp, ror #4
     700:	00065702 	andeq	r5, r6, r2, lsl #14
     704:	14040700 	strne	r0, [r4], #-1792	; 0xfffff900
     708:	0000008f 	andeq	r0, r0, pc, lsl #1
     70c:	9a900305 	bls	fe401328 <__bss_end+0xfe3f77a8>
     710:	93020000 	movwls	r0, #8192	; 0x2000
     714:	0700000e 	streq	r0, [r0, -lr]
     718:	008f1407 	addeq	r1, pc, r7, lsl #8
     71c:	03050000 	movweq	r0, #20480	; 0x5000
     720:	00009a94 	muleq	r0, r4, sl
     724:	00050c02 	andeq	r0, r5, r2, lsl #24
     728:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
     72c:	0000008f 	andeq	r0, r0, pc, lsl #1
     730:	9a980305 	bls	fe60134c <__bss_end+0xfe5f77cc>
     734:	550a0000 	strpl	r0, [sl, #-0]
     738:	05000007 	streq	r0, [r0, #-7]
     73c:	00006704 	andeq	r6, r0, r4, lsl #14
     740:	0c0d0700 	stceq	7, cr0, [sp], {-0}
     744:	00000499 	muleq	r0, r9, r4
     748:	77654e1b 			; <UNDEFINED> instruction: 0x77654e1b
     74c:	380b0000 	stmdacc	fp, {}	; <UNPREDICTABLE>
     750:	01000009 	tsteq	r0, r9
     754:	0005040b 	andeq	r0, r5, fp, lsl #8
     758:	950b0200 	strls	r0, [fp, #-512]	; 0xfffffe00
     75c:	03000007 	movweq	r0, #7
     760:	0010290b 	andseq	r2, r0, fp, lsl #18
     764:	d50b0400 	strle	r0, [fp, #-1024]	; 0xfffffc00
     768:	05000004 	streq	r0, [r0, #-4]
     76c:	06700800 	ldrbteq	r0, [r0], -r0, lsl #16
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
     79c:	3a0e0800 	bcc	3827a4 <__bss_end+0x378c24>
     7a0:	0700000e 	streq	r0, [r0, -lr]
     7a4:	04d81320 	ldrbeq	r1, [r8], #800	; 0x320
     7a8:	000c0000 	andeq	r0, ip, r0
     7ac:	66070403 	strvs	r0, [r7], -r3, lsl #8
     7b0:	04000007 	streq	r0, [r0], #-7
     7b4:	000004d8 	ldrdeq	r0, [r0], -r8
     7b8:	00090c08 	andeq	r0, r9, r8, lsl #24
     7bc:	28077000 	stmdacs	r7, {ip, sp, lr}
     7c0:	00057408 	andeq	r7, r5, r8, lsl #8
     7c4:	081f0e00 	ldmdaeq	pc, {r9, sl, fp}	; <UNPREDICTABLE>
     7c8:	2a070000 	bcs	1c07d0 <__bss_end+0x1b6c50>
     7cc:	00049912 	andeq	r9, r4, r2, lsl r9
     7d0:	70090000 	andvc	r0, r9, r0
     7d4:	07006469 	streq	r6, [r0, -r9, ror #8]
     7d8:	0094122b 	addseq	r1, r4, fp, lsr #4
     7dc:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     7e0:	00001ba3 	andeq	r1, r0, r3, lsr #23
     7e4:	62112c07 	andsvs	r2, r1, #1792	; 0x700
     7e8:	14000004 	strne	r0, [r0], #-4
     7ec:	0010020e 	andseq	r0, r0, lr, lsl #4
     7f0:	122d0700 	eorne	r0, sp, #0, 14
     7f4:	00000094 	muleq	r0, r4, r0
     7f8:	03a90e18 			; <UNDEFINED> instruction: 0x03a90e18
     7fc:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
     800:	00009412 	andeq	r9, r0, r2, lsl r4
     804:	800e1c00 	andhi	r1, lr, r0, lsl #24
     808:	0700000e 	streq	r0, [r0, -lr]
     80c:	05740c2f 	ldrbeq	r0, [r4, #-3119]!	; 0xfffff3d1
     810:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     814:	00000485 	andeq	r0, r0, r5, lsl #9
     818:	67093007 	strvs	r3, [r9, -r7]
     81c:	60000000 	andvs	r0, r0, r0
     820:	000ac50e 	andeq	ip, sl, lr, lsl #10
     824:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
     828:	00000083 	andeq	r0, r0, r3, lsl #1
     82c:	0cf40e64 	ldcleq	14, cr0, [r4], #400	; 0x190
     830:	33070000 	movwcc	r0, #28672	; 0x7000
     834:	0000830e 	andeq	r8, r0, lr, lsl #6
     838:	eb0e6800 	bl	39a840 <__bss_end+0x390cc0>
     83c:	0700000c 	streq	r0, [r0, -ip]
     840:	00830e34 	addeq	r0, r3, r4, lsr lr
     844:	006c0000 	rsbeq	r0, ip, r0
     848:	00041a16 	andeq	r1, r4, r6, lsl sl
     84c:	00058400 	andeq	r8, r5, r0, lsl #8
     850:	00941700 	addseq	r1, r4, r0, lsl #14
     854:	000f0000 	andeq	r0, pc, r0
     858:	0004f502 	andeq	pc, r4, r2, lsl #10
     85c:	140a0800 	strne	r0, [sl], #-2048	; 0xfffff800
     860:	0000008f 	andeq	r0, r0, pc, lsl #1
     864:	9a9c0305 	bls	fe701480 <__bss_end+0xfe6f7900>
     868:	b00a0000 	andlt	r0, sl, r0
     86c:	0500000a 	streq	r0, [r0, #-10]
     870:	00006704 	andeq	r6, r0, r4, lsl #14
     874:	0c0d0800 	stceq	8, cr0, [sp], {-0}
     878:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
     87c:	0012810b 	andseq	r8, r2, fp, lsl #2
     880:	d80b0000 	stmdale	fp, {}	; <UNPREDICTABLE>
     884:	01000010 	tsteq	r0, r0, lsl r0
     888:	08040800 	stmdaeq	r4, {fp}
     88c:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
     890:	05ea081b 	strbeq	r0, [sl, #2075]!	; 0x81b
     894:	9d0e0000 	stcls	0, cr0, [lr, #-0]
     898:	08000005 	stmdaeq	r0, {r0, r2}
     89c:	05ea191d 	strbeq	r1, [sl, #2333]!	; 0x91d
     8a0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     8a4:	000004dc 	ldrdeq	r0, [r0], -ip
     8a8:	ea191e08 	b	6480d0 <__bss_end+0x63e550>
     8ac:	04000005 	streq	r0, [r0], #-5
     8b0:	000ae00e 	andeq	lr, sl, lr
     8b4:	131f0800 	tstne	pc, #0, 16
     8b8:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     8bc:	04180008 	ldreq	r0, [r8], #-8
     8c0:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
     8c4:	04e40418 	strbteq	r0, [r4], #1048	; 0x418
     8c8:	db0d0000 	blle	3408d0 <__bss_end+0x336d50>
     8cc:	1400000d 	strne	r0, [r0], #-13
     8d0:	78072208 	stmdavc	r7, {r3, r9, sp}
     8d4:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
     8d8:	00000bf5 	strdeq	r0, [r0], -r5
     8dc:	83122608 	tsthi	r2, #8, 12	; 0x800000
     8e0:	00000000 	andeq	r0, r0, r0
     8e4:	000b880e 	andeq	r8, fp, lr, lsl #16
     8e8:	1d290800 	stcne	8, cr0, [r9, #-0]
     8ec:	000005ea 	andeq	r0, r0, sl, ror #11
     8f0:	079d0e04 	ldreq	r0, [sp, r4, lsl #28]
     8f4:	2c080000 	stccs	0, cr0, [r8], {-0}
     8f8:	0005ea1d 	andeq	lr, r5, sp, lsl sl
     8fc:	761c0800 	ldrvc	r0, [ip], -r0, lsl #16
     900:	0800000c 	stmdaeq	r0, {r2, r3}
     904:	07e10e2f 	strbeq	r0, [r1, pc, lsr #28]!
     908:	063e0000 	ldrteq	r0, [lr], -r0
     90c:	06490000 	strbeq	r0, [r9], -r0
     910:	7d100000 	ldcvc	0, cr0, [r0, #-0]
     914:	11000008 	tstne	r0, r8
     918:	000005ea 	andeq	r0, r0, sl, ror #11
     91c:	09411d00 	stmdbeq	r1, {r8, sl, fp, ip}^
     920:	31080000 	mrscc	r0, (UNDEF: 8)
     924:	0008e30e 	andeq	lr, r8, lr, lsl #6
     928:	0003eb00 	andeq	lr, r3, r0, lsl #22
     92c:	00066100 	andeq	r6, r6, r0, lsl #2
     930:	00066c00 	andeq	r6, r6, r0, lsl #24
     934:	087d1000 	ldmdaeq	sp!, {ip}^
     938:	f0110000 			; <UNDEFINED> instruction: 0xf0110000
     93c:	00000005 	andeq	r0, r0, r5
     940:	00108413 	andseq	r8, r0, r3, lsl r4
     944:	1d350800 	ldcne	8, cr0, [r5, #-0]
     948:	000006a8 	andeq	r0, r0, r8, lsr #13
     94c:	000005ea 	andeq	r0, r0, sl, ror #11
     950:	00068502 	andeq	r8, r6, r2, lsl #10
     954:	00068b00 	andeq	r8, r6, r0, lsl #22
     958:	087d1000 	ldmdaeq	sp!, {ip}^
     95c:	13000000 	movwne	r0, #0
     960:	0000077d 	andeq	r0, r0, sp, ror r7
     964:	861d3708 	ldrhi	r3, [sp], -r8, lsl #14
     968:	ea00000c 	b	9a0 <shift+0x9a0>
     96c:	02000005 	andeq	r0, r0, #5
     970:	000006a4 	andeq	r0, r0, r4, lsr #13
     974:	000006aa 	andeq	r0, r0, sl, lsr #13
     978:	00087d10 	andeq	r7, r8, r0, lsl sp
     97c:	9b1e0000 	blls	780984 <__bss_end+0x776e04>
     980:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     984:	08963139 	ldmeq	r6, {r0, r3, r4, r5, r8, ip, sp}
     988:	020c0000 	andeq	r0, ip, #0
     98c:	000ddb13 	andeq	sp, sp, r3, lsl fp
     990:	093c0800 	ldmdbeq	ip!, {fp}
     994:	00000950 	andeq	r0, r0, r0, asr r9
     998:	0000087d 	andeq	r0, r0, sp, ror r8
     99c:	0006d101 	andeq	sp, r6, r1, lsl #2
     9a0:	0006d700 	andeq	sp, r6, r0, lsl #14
     9a4:	087d1000 	ldmdaeq	sp!, {ip}^
     9a8:	13000000 	movwne	r0, #0
     9ac:	00000831 	andeq	r0, r0, r1, lsr r8
     9b0:	67123f08 	ldrvs	r3, [r2, -r8, lsl #30]
     9b4:	83000005 	movwhi	r0, #5
     9b8:	01000000 	mrseq	r0, (UNDEF: 0)
     9bc:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     9c0:	00000705 	andeq	r0, r0, r5, lsl #14
     9c4:	00087d10 	andeq	r7, r8, r0, lsl sp
     9c8:	089f1100 	ldmeq	pc, {r8, ip}	; <UNPREDICTABLE>
     9cc:	94110000 	ldrls	r0, [r1], #-0
     9d0:	11000000 	mrsne	r0, (UNDEF: 0)
     9d4:	000003eb 	andeq	r0, r0, fp, ror #7
     9d8:	10ae1400 	adcne	r1, lr, r0, lsl #8
     9dc:	42080000 	andmi	r0, r8, #0
     9e0:	00067d0e 	andeq	r7, r6, lr, lsl #26
     9e4:	071a0100 	ldreq	r0, [sl, -r0, lsl #2]
     9e8:	07200000 	streq	r0, [r0, -r0]!
     9ec:	7d100000 	ldcvc	0, cr0, [r0, #-0]
     9f0:	00000008 	andeq	r0, r0, r8
     9f4:	00054913 	andeq	r4, r5, r3, lsl r9
     9f8:	17450800 	strbne	r0, [r5, -r0, lsl #16]
     9fc:	000005ef 	andeq	r0, r0, pc, ror #11
     a00:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     a04:	00073901 	andeq	r3, r7, r1, lsl #18
     a08:	00073f00 	andeq	r3, r7, r0, lsl #30
     a0c:	08a51000 	stmiaeq	r5!, {ip}
     a10:	13000000 	movwne	r0, #0
     a14:	00000e9e 	muleq	r0, lr, lr
     a18:	bf174808 	svclt	0x00174808
     a1c:	f0000003 			; <UNDEFINED> instruction: 0xf0000003
     a20:	01000005 	tsteq	r0, r5
     a24:	00000758 	andeq	r0, r0, r8, asr r7
     a28:	00000763 	andeq	r0, r0, r3, ror #14
     a2c:	0008a510 	andeq	sl, r8, r0, lsl r5
     a30:	00831100 	addeq	r1, r3, r0, lsl #2
     a34:	14000000 	strne	r0, [r0], #-0
     a38:	000006cd 	andeq	r0, r0, sp, asr #13
     a3c:	a90e4b08 	stmdbge	lr, {r3, r8, r9, fp, lr}
     a40:	0100000b 	tsteq	r0, fp
     a44:	00000778 	andeq	r0, r0, r8, ror r7
     a48:	0000077e 	andeq	r0, r0, lr, ror r7
     a4c:	00087d10 	andeq	r7, r8, r0, lsl sp
     a50:	41130000 	tstmi	r3, r0
     a54:	08000009 	stmdaeq	r0, {r0, r3}
     a58:	0d240e4d 	stceq	14, cr0, [r4, #-308]!	; 0xfffffecc
     a5c:	03eb0000 	mvneq	r0, #0
     a60:	97010000 	strls	r0, [r1, -r0]
     a64:	a2000007 	andge	r0, r0, #7
     a68:	10000007 	andne	r0, r0, r7
     a6c:	0000087d 	andeq	r0, r0, sp, ror r8
     a70:	00008311 	andeq	r8, r0, r1, lsl r3
     a74:	c1130000 	tstgt	r3, r0
     a78:	08000004 	stmdaeq	r0, {r2}
     a7c:	03ec1250 	mvneq	r1, #80, 4
     a80:	00830000 	addeq	r0, r3, r0
     a84:	bb010000 	bllt	40a8c <__bss_end+0x36f0c>
     a88:	c6000007 	strgt	r0, [r0], -r7
     a8c:	10000007 	andne	r0, r0, r7
     a90:	0000087d 	andeq	r0, r0, sp, ror r8
     a94:	00041a11 	andeq	r1, r4, r1, lsl sl
     a98:	1f130000 	svcne	0x00130000
     a9c:	08000004 	stmdaeq	r0, {r2}
     aa0:	10e30e53 	rscne	r0, r3, r3, asr lr
     aa4:	03eb0000 	mvneq	r0, #0
     aa8:	df010000 	svcle	0x00010000
     aac:	ea000007 	b	ad0 <shift+0xad0>
     ab0:	10000007 	andne	r0, r0, r7
     ab4:	0000087d 	andeq	r0, r0, sp, ror r8
     ab8:	00008311 	andeq	r8, r0, r1, lsl r3
     abc:	9b140000 	blls	500ac4 <__bss_end+0x4f6f44>
     ac0:	08000004 	stmdaeq	r0, {r2}
     ac4:	0f850e56 	svceq	0x00850e56
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
     af0:	70140000 	andsvc	r0, r4, r0
     af4:	08000011 	stmdaeq	r0, {r0, r4}
     af8:	12a80e58 	adcne	r0, r8, #88, 28	; 0x580
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
     b24:	ae150000 	cdpge	0, 1, cr0, cr5, cr0, {0}
     b28:	08000004 	stmdaeq	r0, {r2}
     b2c:	0b0b0e5b 	bleq	2c44a0 <__bss_end+0x2ba920>
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
     b84:	1a042200 	bne	10938c <__bss_end+0xff80c>
     b88:	000011cd 	andeq	r1, r0, sp, asr #3
     b8c:	f6195e08 			; <UNDEFINED> instruction: 0xf6195e08
     b90:	23000005 	movwcs	r0, #5
     b94:	006c6168 	rsbeq	r6, ip, r8, ror #2
     b98:	790b0509 	stmdbvc	fp, {r0, r3, r8, sl}
     b9c:	24000009 	strcs	r0, [r0], #-9
     ba0:	00000b58 	andeq	r0, r0, r8, asr fp
     ba4:	9b190709 	blls	6427d0 <__bss_end+0x638c50>
     ba8:	80000000 	andhi	r0, r0, r0
     bac:	240ee6b2 	strcs	lr, [lr], #-1714	; 0xfffff94e
     bb0:	00000ec8 	andeq	r0, r0, r8, asr #29
     bb4:	df1a0a09 	svcle	0x001a0a09
     bb8:	00000004 	andeq	r0, r0, r4
     bbc:	24200000 	strtcs	r0, [r0], #-0
     bc0:	0000055d 	andeq	r0, r0, sp, asr r5
     bc4:	df1a0d09 	svcle	0x001a0d09
     bc8:	00000004 	andeq	r0, r0, r4
     bcc:	25202000 	strcs	r2, [r0, #-0]!
     bd0:	00000ad1 	ldrdeq	r0, [r0], -r1
     bd4:	8f151009 	svchi	0x00151009
     bd8:	36000000 	strcc	r0, [r0], -r0
     bdc:	00109024 	andseq	r9, r0, r4, lsr #32
     be0:	1a4b0900 	bne	12c2fe8 <__bss_end+0x12b9468>
     be4:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     be8:	20215000 	eorcs	r5, r1, r0
     bec:	00124824 	andseq	r4, r2, r4, lsr #16
     bf0:	1a7a0900 	bne	1e82ff8 <__bss_end+0x1e79478>
     bf4:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     bf8:	2000b200 	andcs	fp, r0, r0, lsl #4
     bfc:	00089424 	andeq	r9, r8, r4, lsr #8
     c00:	1aad0900 	bne	feb43008 <__bss_end+0xfeb39488>
     c04:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c08:	2000b400 	andcs	fp, r0, r0, lsl #8
     c0c:	000b4e24 	andeq	r4, fp, r4, lsr #28
     c10:	1abc0900 	bne	fef03018 <__bss_end+0xfeef9498>
     c14:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c18:	20104000 	andscs	r4, r0, r0
     c1c:	000cbf24 	andeq	fp, ip, r4, lsr #30
     c20:	1ac70900 	bne	ff1c3028 <__bss_end+0xff1b94a8>
     c24:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c28:	20205000 	eorcs	r5, r0, r0
     c2c:	00074624 	andeq	r4, r7, r4, lsr #12
     c30:	1ac80900 	bne	ff203038 <__bss_end+0xff1f94b8>
     c34:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c38:	20804000 	addcs	r4, r0, r0
     c3c:	00109924 	andseq	r9, r0, r4, lsr #18
     c40:	1ac90900 	bne	ff243048 <__bss_end+0xff2394c8>
     c44:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     c48:	20805000 	addcs	r5, r0, r0
     c4c:	08cb2600 	stmiaeq	fp, {r9, sl, sp}^
     c50:	db260000 	blle	980c58 <__bss_end+0x9770d8>
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
     c84:	000f1502 	andeq	r1, pc, r2, lsl #10
     c88:	14080a00 	strne	r0, [r8], #-2560	; 0xfffff600
     c8c:	0000008f 	andeq	r0, r0, pc, lsl #1
     c90:	9acc0305 	bls	ff3018ac <__bss_end+0xff2f7d2c>
     c94:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
     c98:	0700000c 	streq	r0, [r0, -ip]
     c9c:	00009404 	andeq	r9, r0, r4, lsl #8
     ca0:	0c0b0a00 			; <UNDEFINED> instruction: 0x0c0b0a00
     ca4:	00000a0b 	andeq	r0, r0, fp, lsl #20
     ca8:	000c3b0b 	andeq	r3, ip, fp, lsl #22
     cac:	2f0b0000 	svccs	0x000b0000
     cb0:	01000006 	tsteq	r0, r6
     cb4:	00113a0b 	andseq	r3, r1, fp, lsl #20
     cb8:	340b0200 	strcc	r0, [fp], #-512	; 0xfffffe00
     cbc:	03000011 	movweq	r0, #17
     cc0:	00110f0b 	andseq	r0, r1, fp, lsl #30
     cc4:	e70b0400 	str	r0, [fp, -r0, lsl #8]
     cc8:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     ccc:	0011280b 	andseq	r2, r1, fp, lsl #16
     cd0:	2e0b0600 	cfmadd32cs	mvax0, mvfx0, mvfx11, mvfx0
     cd4:	07000011 	smladeq	r0, r1, r0, r0
     cd8:	000dec0b 	andeq	lr, sp, fp, lsl #24
     cdc:	0a000800 	beq	2ce4 <shift+0x2ce4>
     ce0:	00000a02 	andeq	r0, r0, r2, lsl #20
     ce4:	00670405 	rsbeq	r0, r7, r5, lsl #8
     ce8:	1d0a0000 	stcne	0, cr0, [sl, #-0]
     cec:	000a360c 	andeq	r3, sl, ip, lsl #12
     cf0:	0cc90b00 	vstmiaeq	r9, {d16-d15}
     cf4:	0b000000 	bleq	cfc <shift+0xcfc>
     cf8:	00000d02 	andeq	r0, r0, r2, lsl #26
     cfc:	0ce60b01 	fstmiaxeq	r6!, {d16-d15}	;@ Deprecated
     d00:	1b020000 	blne	80d08 <__bss_end+0x77188>
     d04:	00776f4c 	rsbseq	r6, r7, ip, asr #30
     d08:	d90d0003 	stmdble	sp, {r0, r1}
     d0c:	1c000011 	stcne	0, cr0, [r0], {17}
     d10:	b707280a 	strlt	r2, [r7, -sl, lsl #16]
     d14:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     d18:	0000039b 	muleq	r0, fp, r3
     d1c:	0a330a10 	beq	cc3564 <__bss_end+0xcb99e4>
     d20:	00000a85 	andeq	r0, r0, r5, lsl #21
     d24:	0007780e 	andeq	r7, r7, lr, lsl #16
     d28:	0b350a00 	bleq	d43530 <__bss_end+0xd399b0>
     d2c:	0000041a 	andeq	r0, r0, sl, lsl r4
     d30:	08170e00 	ldmdaeq	r7, {r9, sl, fp}
     d34:	360a0000 	strcc	r0, [sl], -r0
     d38:	0000830d 	andeq	r8, r0, sp, lsl #6
     d3c:	9d0e0400 	cfstrsls	mvf0, [lr, #-0]
     d40:	0a000005 	beq	d5c <shift+0xd5c>
     d44:	0dbc1337 	ldceq	3, cr1, [ip, #220]!	; 0xdc
     d48:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     d4c:	000004dc 	ldrdeq	r0, [r0], -ip
     d50:	bc13380a 	ldclt	8, cr3, [r3], {10}
     d54:	0c00000d 	stceq	0, cr0, [r0], {13}
     d58:	082b0e00 	stmdaeq	fp!, {r9, sl, fp}
     d5c:	2c0a0000 	stccs	0, cr0, [sl], {-0}
     d60:	000dc820 	andeq	ip, sp, r0, lsr #16
     d64:	620e0000 	andvs	r0, lr, #0
     d68:	0a00000f 	beq	dac <shift+0xdac>
     d6c:	0dcd0c2f 	stcleq	12, cr0, [sp, #188]	; 0xbc
     d70:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     d74:	00000a98 	muleq	r0, r8, sl
     d78:	cd0c310a 	stfgts	f3, [ip, #-40]	; 0xffffffd8
     d7c:	0c00000d 	stceq	0, cr0, [r0], {13}
     d80:	000bd80e 	andeq	sp, fp, lr, lsl #16
     d84:	123b0a00 	eorsne	r0, fp, #0, 20
     d88:	00000dbc 			; <UNDEFINED> instruction: 0x00000dbc
     d8c:	09990e14 	ldmibeq	r9, {r2, r4, r9, sl, fp}
     d90:	3d0a0000 	stccc	0, cr0, [sl, #-0]
     d94:	0001b90e 	andeq	fp, r1, lr, lsl #18
     d98:	d8131800 	ldmdale	r3, {fp, ip}
     d9c:	0a00000e 	beq	ddc <shift+0xddc>
     da0:	08400841 	stmdaeq	r0, {r0, r6, fp}^
     da4:	03eb0000 	mvneq	r0, #0
     da8:	df020000 	svcle	0x00020000
     dac:	f400000a 	vst4.8	{d0-d3}, [r0], sl
     db0:	1000000a 	andne	r0, r0, sl
     db4:	00000ddd 	ldrdeq	r0, [r0], -sp
     db8:	00008311 	andeq	r8, r0, r1, lsl r3
     dbc:	0de31100 	stfeqe	f1, [r3]
     dc0:	e3110000 	tst	r1, #0
     dc4:	0000000d 	andeq	r0, r0, sp
     dc8:	00088113 	andeq	r8, r8, r3, lsl r1
     dcc:	08430a00 	stmdaeq	r3, {r9, fp}^
     dd0:	00001186 	andeq	r1, r0, r6, lsl #3
     dd4:	000003eb 	andeq	r0, r0, fp, ror #7
     dd8:	000b0d02 	andeq	r0, fp, r2, lsl #26
     ddc:	000b2200 	andeq	r2, fp, r0, lsl #4
     de0:	0ddd1000 	ldcleq	0, cr1, [sp]
     de4:	83110000 	tsthi	r1, #0
     de8:	11000000 	mrsne	r0, (UNDEF: 0)
     dec:	00000de3 	andeq	r0, r0, r3, ror #27
     df0:	000de311 	andeq	lr, sp, r1, lsl r3
     df4:	75130000 	ldrvc	r0, [r3, #-0]
     df8:	0a00000b 	beq	e2c <shift+0xe2c>
     dfc:	096a0845 	stmdbeq	sl!, {r0, r2, r6, fp}^
     e00:	03eb0000 	mvneq	r0, #0
     e04:	3b020000 	blcc	80e0c <__bss_end+0x7728c>
     e08:	5000000b 	andpl	r0, r0, fp
     e0c:	1000000b 	andne	r0, r0, fp
     e10:	00000ddd 	ldrdeq	r0, [r0], -sp
     e14:	00008311 	andeq	r8, r0, r1, lsl r3
     e18:	0de31100 	stfeqe	f1, [r3]
     e1c:	e3110000 	tst	r1, #0
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	000cac13 	andeq	sl, ip, r3, lsl ip
     e28:	08470a00 	stmdaeq	r7, {r9, fp}^
     e2c:	00000432 	andeq	r0, r0, r2, lsr r4
     e30:	000003eb 	andeq	r0, r0, fp, ror #7
     e34:	000b6902 	andeq	r6, fp, r2, lsl #18
     e38:	000b7e00 	andeq	r7, fp, r0, lsl #28
     e3c:	0ddd1000 	ldcleq	0, cr1, [sp]
     e40:	83110000 	tsthi	r1, #0
     e44:	11000000 	mrsne	r0, (UNDEF: 0)
     e48:	00000de3 	andeq	r0, r0, r3, ror #27
     e4c:	000de311 	andeq	lr, sp, r1, lsl r3
     e50:	b7130000 	ldrlt	r0, [r3, -r0]
     e54:	0a000008 	beq	e7c <shift+0xe7c>
     e58:	0a530849 	beq	14c2f84 <__bss_end+0x14b9404>
     e5c:	03eb0000 	mvneq	r0, #0
     e60:	97020000 	strls	r0, [r2, -r0]
     e64:	ac00000b 	stcge	0, cr0, [r0], {11}
     e68:	1000000b 	andne	r0, r0, fp
     e6c:	00000ddd 	ldrdeq	r0, [r0], -sp
     e70:	00008311 	andeq	r8, r0, r1, lsl r3
     e74:	0de31100 	stfeqe	f1, [r3]
     e78:	e3110000 	tst	r1, #0
     e7c:	0000000d 	andeq	r0, r0, sp
     e80:	00103d13 	andseq	r3, r0, r3, lsl sp
     e84:	084b0a00 	stmdaeq	fp, {r9, fp}^
     e88:	000005a2 	andeq	r0, r0, r2, lsr #11
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
     eb4:	00000d6a 	andeq	r0, r0, sl, ror #26
     eb8:	a90c4f0a 	stmdbge	ip, {r1, r3, r8, r9, sl, fp, lr}
     ebc:	83000009 	movwhi	r0, #9
     ec0:	02000000 	andeq	r0, r0, #0
     ec4:	00000bf8 	strdeq	r0, [r0], -r8
     ec8:	00000bfe 	strdeq	r0, [r0], -lr
     ecc:	000ddd10 	andeq	sp, sp, r0, lsl sp
     ed0:	25140000 	ldrcs	r0, [r4, #-0]
     ed4:	0a00000a 	beq	f04 <shift+0xf04>
     ed8:	0fd70851 	svceq	0x00d70851
     edc:	13020000 	movwne	r0, #8192	; 0x2000
     ee0:	1e00000c 	cdpne	0, 0, cr0, cr0, cr12, {0}
     ee4:	1000000c 	andne	r0, r0, ip
     ee8:	00000de9 	andeq	r0, r0, r9, ror #27
     eec:	00008311 	andeq	r8, r0, r1, lsl r3
     ef0:	d9130000 	ldmdble	r3, {}	; <UNPREDICTABLE>
     ef4:	0a000011 	beq	f40 <shift+0xf40>
     ef8:	07b00354 	sbfxeq	r0, r4, #6, #17
     efc:	0de90000 	stcleq	0, cr0, [r9]
     f00:	37010000 	strcc	r0, [r1, -r0]
     f04:	4200000c 	andmi	r0, r0, #12
     f08:	1000000c 	andne	r0, r0, ip
     f0c:	00000de9 	andeq	r0, r0, r9, ror #27
     f10:	00009411 	andeq	r9, r0, r1, lsl r4
     f14:	d1140000 	tstle	r4, r0
     f18:	0a000008 	beq	f40 <shift+0xf40>
     f1c:	0bff0857 	bleq	fffc3080 <__bss_end+0xfffb9500>
     f20:	57010000 	strpl	r0, [r1, -r0]
     f24:	6700000c 	strvs	r0, [r0, -ip]
     f28:	1000000c 	andne	r0, r0, ip
     f2c:	00000de9 	andeq	r0, r0, r9, ror #27
     f30:	00008311 	andeq	r8, r0, r1, lsl r3
     f34:	09c21100 	stmibeq	r2, {r8, ip}^
     f38:	13000000 	movwne	r0, #0
     f3c:	00000af4 	strdeq	r0, [r0], -r4
     f40:	ec12590a 			; <UNDEFINED> instruction: 0xec12590a
     f44:	c200000e 	andgt	r0, r0, #14
     f48:	01000009 	tsteq	r0, r9
     f4c:	00000c80 	andeq	r0, r0, r0, lsl #25
     f50:	00000c8b 	andeq	r0, r0, fp, lsl #25
     f54:	000ddd10 	andeq	sp, sp, r0, lsl sp
     f58:	00831100 	addeq	r1, r3, r0, lsl #2
     f5c:	14000000 	strne	r0, [r0], #-0
     f60:	0000062b 	andeq	r0, r0, fp, lsr #12
     f64:	13085c0a 	movwne	r5, #35850	; 0x8c0a
     f68:	01000007 	tsteq	r0, r7
     f6c:	00000ca0 	andeq	r0, r0, r0, lsr #25
     f70:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
     f74:	000de910 	andeq	lr, sp, r0, lsl r9
     f78:	00831100 	addeq	r1, r3, r0, lsl #2
     f7c:	eb110000 	bl	440f84 <__bss_end+0x437404>
     f80:	00000003 	andeq	r0, r0, r3
     f84:	000c3713 	andeq	r3, ip, r3, lsl r7
     f88:	085f0a00 	ldmdaeq	pc, {r9, fp}^	; <UNPREDICTABLE>
     f8c:	000006f4 	strdeq	r0, [r0], -r4
     f90:	000003eb 	andeq	r0, r0, fp, ror #7
     f94:	000cc901 	andeq	ip, ip, r1, lsl #18
     f98:	000cd400 	andeq	sp, ip, r0, lsl #8
     f9c:	0de91000 	stcleq	0, cr1, [r9]
     fa0:	83110000 	tsthi	r1, #0
     fa4:	00000000 	andeq	r0, r0, r0
     fa8:	000cda13 	andeq	sp, ip, r3, lsl sl
     fac:	08620a00 	stmdaeq	r2!, {r9, fp}^
     fb0:	00000461 	andeq	r0, r0, r1, ror #8
     fb4:	000003eb 	andeq	r0, r0, fp, ror #7
     fb8:	000ced01 	andeq	lr, ip, r1, lsl #26
     fbc:	000d0200 	andeq	r0, sp, r0, lsl #4
     fc0:	0de91000 	stcleq	0, cr1, [r9]
     fc4:	83110000 	tsthi	r1, #0
     fc8:	11000000 	mrsne	r0, (UNDEF: 0)
     fcc:	000003eb 	andeq	r0, r0, fp, ror #7
     fd0:	0003eb11 	andeq	lr, r3, r1, lsl fp
     fd4:	d2130000 	andsle	r0, r3, #0
     fd8:	0a00000d 	beq	1014 <shift+0x1014>
     fdc:	0df80864 	ldcleq	8, cr0, [r8, #400]!	; 0x190
     fe0:	03eb0000 	mvneq	r0, #0
     fe4:	1b010000 	blne	40fec <__bss_end+0x3746c>
     fe8:	3000000d 	andcc	r0, r0, sp
     fec:	1000000d 	andne	r0, r0, sp
     ff0:	00000de9 	andeq	r0, r0, r9, ror #27
     ff4:	00008311 	andeq	r8, r0, r1, lsl r3
     ff8:	03eb1100 	mvneq	r1, #0, 2
     ffc:	eb110000 	bl	441004 <__bss_end+0x437484>
    1000:	00000003 	andeq	r0, r0, r3
    1004:	00130014 	andseq	r0, r3, r4, lsl r0
    1008:	08670a00 	stmdaeq	r7!, {r9, fp}^
    100c:	000009d7 	ldrdeq	r0, [r0], -r7
    1010:	000d4501 	andeq	r4, sp, r1, lsl #10
    1014:	000d5500 	andeq	r5, sp, r0, lsl #10
    1018:	0de91000 	stcleq	0, cr1, [r9]
    101c:	83110000 	tsthi	r1, #0
    1020:	11000000 	mrsne	r0, (UNDEF: 0)
    1024:	00000a0b 	andeq	r0, r0, fp, lsl #20
    1028:	12331400 	eorsne	r1, r3, #0, 8
    102c:	690a0000 	stmdbvs	sl, {}	; <UNPREDICTABLE>
    1030:	000f2108 	andeq	r2, pc, r8, lsl #2
    1034:	0d6a0100 	stfeqe	f0, [sl, #-0]
    1038:	0d7a0000 	ldcleq	0, cr0, [sl, #-0]
    103c:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
    1040:	1100000d 	tstne	r0, sp
    1044:	00000083 	andeq	r0, r0, r3, lsl #1
    1048:	000a0b11 	andeq	r0, sl, r1, lsl fp
    104c:	3a140000 	bcc	501054 <__bss_end+0x4f74d4>
    1050:	0a00000a 	beq	1080 <shift+0x1080>
    1054:	10b7086c 	adcsne	r0, r7, ip, ror #16
    1058:	8f010000 	svchi	0x00010000
    105c:	9500000d 	strls	r0, [r0, #-13]
    1060:	1000000d 	andne	r0, r0, sp
    1064:	00000de9 	andeq	r0, r0, r9, ror #27
    1068:	0ae52700 	beq	ff94ac70 <__bss_end+0xff9410f0>
    106c:	6f0a0000 	svcvs	0x000a0000
    1070:	00105808 	andseq	r5, r0, r8, lsl #16
    1074:	0da60100 	stfeqs	f0, [r6]
    1078:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
    107c:	1100000d 	tstne	r0, sp
    1080:	0000041a 	andeq	r0, r0, sl, lsl r4
    1084:	00008311 	andeq	r8, r0, r1, lsl r3
    1088:	04000000 	streq	r0, [r0], #-0
    108c:	00000a36 	andeq	r0, r0, r6, lsr sl
    1090:	0a430418 	beq	10c20f8 <__bss_end+0x10b8578>
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
    10c4:	000008b1 			; <UNDEFINED> instruction: 0x000008b1
    10c8:	3616730a 	ldrcc	r7, [r6], -sl, lsl #6
    10cc:	0200000a 	andeq	r0, r0, #10
    10d0:	00001296 	muleq	r0, r6, r2
    10d4:	8f141001 	svchi	0x00141001
    10d8:	05000000 	streq	r0, [r0, #-0]
    10dc:	009ad003 	addseq	sp, sl, r3
    10e0:	07c70200 	strbeq	r0, [r7, r0, lsl #4]
    10e4:	11010000 	mrsne	r0, (UNDEF: 1)
    10e8:	00008f14 	andeq	r8, r0, r4, lsl pc
    10ec:	d4030500 	strle	r0, [r3], #-1280	; 0xfffffb00
    10f0:	2800009a 	stmdacs	r0, {r1, r3, r4, r7}
    10f4:	000004ed 	andeq	r0, r0, sp, ror #9
    10f8:	830a1301 	movwhi	r1, #41729	; 0xa301
    10fc:	05000000 	streq	r0, [r0, #-0]
    1100:	009b6803 	addseq	r6, fp, r3, lsl #16
    1104:	08ca2800 	stmiaeq	sl, {fp, sp}^
    1108:	14010000 	strne	r0, [r1], #-0
    110c:	0000830a 	andeq	r8, r0, sl, lsl #6
    1110:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
    1114:	2900009b 	stmdbcs	r0, {r0, r1, r3, r4, r7}
    1118:	000011c8 	andeq	r1, r0, r8, asr #3
    111c:	67051d01 	strvs	r1, [r5, -r1, lsl #26]
    1120:	ac000000 	stcge	0, cr0, [r0], {-0}
    1124:	6c000082 	stcvs	0, cr0, [r0], {130}	; 0x82
    1128:	01000001 	tsteq	r0, r1
    112c:	000e9a9c 	muleq	lr, ip, sl
    1130:	0cd52a00 	vldmiaeq	r5, {s5-s4}
    1134:	1d010000 	stcne	0, cr0, [r1, #-0]
    1138:	0000670e 	andeq	r6, r0, lr, lsl #14
    113c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1140:	000cfd2a 	andeq	pc, ip, sl, lsr #26
    1144:	1b1d0100 	blne	74154c <__bss_end+0x7379cc>
    1148:	00000e9a 	muleq	r0, sl, lr
    114c:	2b689102 	blcs	1a2555c <__bss_end+0x1a1b9dc>
    1150:	00000db3 			; <UNDEFINED> instruction: 0x00000db3
    1154:	0b172201 	bleq	5c9960 <__bss_end+0x5bfde0>
    1158:	0200000a 	andeq	r0, r0, #10
    115c:	632b7091 			; <UNDEFINED> instruction: 0x632b7091
    1160:	0100000e 	tsteq	r0, lr
    1164:	00830b25 	addeq	r0, r3, r5, lsr #22
    1168:	91020000 	mrsls	r0, (UNDEF: 2)
    116c:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1170:	00000ea0 	andeq	r0, r0, r0, lsr #29
    1174:	00430418 	subeq	r0, r3, r8, lsl r4
    1178:	512c0000 			; <UNDEFINED> instruction: 0x512c0000
    117c:	01000006 	tsteq	r0, r6
    1180:	0c410616 	mcrreq	6, 1, r0, r1, cr6
    1184:	822c0000 	eorhi	r0, ip, #0
    1188:	00800000 	addeq	r0, r0, r0
    118c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1190:	00064b2a 	andeq	r4, r6, sl, lsr #22
    1194:	11160100 	tstne	r6, r0, lsl #2
    1198:	000003eb 	andeq	r0, r0, fp, ror #7
    119c:	00779102 	rsbseq	r9, r7, r2, lsl #2
    11a0:	000d5c00 	andeq	r5, sp, r0, lsl #24
    11a4:	93000400 	movwls	r0, #1024	; 0x400
    11a8:	04000004 	streq	r0, [r0], #-4
    11ac:	00160701 	andseq	r0, r6, r1, lsl #14
    11b0:	141d0400 	ldrne	r0, [sp], #-1024	; 0xfffffc00
    11b4:	14a80000 	strtne	r0, [r8], #0
    11b8:	84180000 	ldrhi	r0, [r8], #-0
    11bc:	045c0000 	ldrbeq	r0, [ip], #-0
    11c0:	04c40000 	strbeq	r0, [r4], #0
    11c4:	01020000 	mrseq	r0, (UNDEF: 2)
    11c8:	00102408 	andseq	r2, r0, r8, lsl #8
    11cc:	00250300 	eoreq	r0, r5, r0, lsl #6
    11d0:	02020000 	andeq	r0, r2, #0
    11d4:	000da905 	andeq	sl, sp, r5, lsl #18
    11d8:	06ec0400 	strbteq	r0, [ip], r0, lsl #8
    11dc:	05020000 	streq	r0, [r2, #-0]
    11e0:	00004907 	andeq	r4, r0, r7, lsl #18
    11e4:	00380300 	eorseq	r0, r8, r0, lsl #6
    11e8:	04050000 	streq	r0, [r5], #-0
    11ec:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    11f0:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    11f4:	0000031f 	andeq	r0, r0, pc, lsl r3
    11f8:	1b080102 	blne	201608 <__bss_end+0x1f7a88>
    11fc:	02000010 	andeq	r0, r0, #16
    1200:	11b50702 			; <UNDEFINED> instruction: 0x11b50702
    1204:	eb040000 	bl	10120c <__bss_end+0xf768c>
    1208:	02000006 	andeq	r0, r0, #6
    120c:	0076070a 	rsbseq	r0, r6, sl, lsl #14
    1210:	65030000 	strvs	r0, [r3, #-0]
    1214:	02000000 	andeq	r0, r0, #0
    1218:	076b0704 	strbeq	r0, [fp, -r4, lsl #14]!
    121c:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    1220:	00076107 	andeq	r6, r7, r7, lsl #2
    1224:	0e410600 	cdpeq	6, 4, cr0, cr1, cr0, {0}
    1228:	0d020000 	stceq	0, cr0, [r2, #-0]
    122c:	00004413 	andeq	r4, r0, r3, lsl r4
    1230:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
    1234:	0600009b 			; <UNDEFINED> instruction: 0x0600009b
    1238:	0000078b 	andeq	r0, r0, fp, lsl #15
    123c:	44130e02 	ldrmi	r0, [r3], #-3586	; 0xfffff1fe
    1240:	05000000 	streq	r0, [r0, #-0]
    1244:	009b0803 	addseq	r0, fp, r3, lsl #16
    1248:	0e400600 	cdpeq	6, 4, cr0, cr0, cr0, {0}
    124c:	10020000 	andne	r0, r2, r0
    1250:	00007114 	andeq	r7, r0, r4, lsl r1
    1254:	0c030500 	cfstr32eq	mvfx0, [r3], {-0}
    1258:	0600009b 			; <UNDEFINED> instruction: 0x0600009b
    125c:	0000078a 	andeq	r0, r0, sl, lsl #15
    1260:	71141102 	tstvc	r4, r2, lsl #2
    1264:	05000000 	streq	r0, [r0, #-0]
    1268:	009b1003 	addseq	r1, fp, r3
    126c:	12f40700 	rscsne	r0, r4, #0, 14
    1270:	03080000 	movweq	r0, #32768	; 0x8000
    1274:	00f20806 	rscseq	r0, r2, r6, lsl #16
    1278:	72080000 	andvc	r0, r8, #0
    127c:	08030030 	stmdaeq	r3, {r4, r5}
    1280:	0000650e 	andeq	r6, r0, lr, lsl #10
    1284:	72080000 	andvc	r0, r8, #0
    1288:	09030031 	stmdbeq	r3, {r0, r4, r5}
    128c:	0000650e 	andeq	r6, r0, lr, lsl #10
    1290:	09000400 	stmdbeq	r0, {sl}
    1294:	00001546 	andeq	r1, r0, r6, asr #10
    1298:	00490405 	subeq	r0, r9, r5, lsl #8
    129c:	0d030000 	stceq	0, cr0, [r3, #-0]
    12a0:	0001100c 	andeq	r1, r1, ip
    12a4:	4b4f0a00 	blmi	13c3aac <__bss_end+0x13b9f2c>
    12a8:	8c0b0000 	stchi	0, cr0, [fp], {-0}
    12ac:	01000013 	tsteq	r0, r3, lsl r0
    12b0:	0e6b0900 	vmuleq.f16	s1, s22, s0	; <UNPREDICTABLE>
    12b4:	04050000 	streq	r0, [r5], #-0
    12b8:	00000049 	andeq	r0, r0, r9, asr #32
    12bc:	470c1e03 	strmi	r1, [ip, -r3, lsl #28]
    12c0:	0b000001 	bleq	12cc <shift+0x12cc>
    12c4:	000006e3 	andeq	r0, r0, r3, ror #13
    12c8:	092e0b00 	stmdbeq	lr!, {r8, r9, fp}
    12cc:	0b010000 	bleq	412d4 <__bss_end+0x37754>
    12d0:	00000e8d 	andeq	r0, r0, sp, lsl #29
    12d4:	10370b02 	eorsne	r0, r7, r2, lsl #22
    12d8:	0b030000 	bleq	c12e0 <__bss_end+0xb7760>
    12dc:	00000919 	andeq	r0, r0, r9, lsl r9
    12e0:	0d810b04 	vstreq	d0, [r1, #16]
    12e4:	00050000 	andeq	r0, r5, r0
    12e8:	000e4b09 	andeq	r4, lr, r9, lsl #22
    12ec:	49040500 	stmdbmi	r4, {r8, sl}
    12f0:	03000000 	movweq	r0, #0
    12f4:	01840c44 	orreq	r0, r4, r4, asr #24
    12f8:	700b0000 	andvc	r0, fp, r0
    12fc:	00000008 	andeq	r0, r0, r8
    1300:	000f740b 	andeq	r7, pc, fp, lsl #8
    1304:	720b0100 	andvc	r0, fp, #0, 2
    1308:	02000012 	andeq	r0, r0, #18
    130c:	000c800b 	andeq	r8, ip, fp
    1310:	280b0300 	stmdacs	fp, {r8, r9}
    1314:	04000009 	streq	r0, [r0], #-9
    1318:	000a170b 	andeq	r1, sl, fp, lsl #14
    131c:	500b0500 	andpl	r0, fp, r0, lsl #10
    1320:	06000007 	streq	r0, [r0], -r7
    1324:	07350900 	ldreq	r0, [r5, -r0, lsl #18]!
    1328:	04050000 	streq	r0, [r5], #-0
    132c:	00000049 	andeq	r0, r0, r9, asr #32
    1330:	af0c6b03 	svcge	0x000c6b03
    1334:	0b000001 	bleq	1340 <shift+0x1340>
    1338:	00001010 	andeq	r1, r0, r0, lsl r0
    133c:	05920b00 	ldreq	r0, [r2, #2816]	; 0xb00
    1340:	0b010000 	bleq	41348 <__bss_end+0x377c8>
    1344:	00000eb1 			; <UNDEFINED> instruction: 0x00000eb1
    1348:	0d910b02 	vldreq	d0, [r1, #8]
    134c:	00030000 	andeq	r0, r3, r0
    1350:	000be706 	andeq	lr, fp, r6, lsl #14
    1354:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
    1358:	00000071 	andeq	r0, r0, r1, ror r0
    135c:	9b140305 	blls	501f78 <__bss_end+0x4f83f8>
    1360:	79060000 	stmdbvc	r6, {}	; <UNPREDICTABLE>
    1364:	0400000f 	streq	r0, [r0], #-15
    1368:	00711406 	rsbseq	r1, r1, r6, lsl #8
    136c:	03050000 	movweq	r0, #20480	; 0x5000
    1370:	00009b18 	andeq	r9, r0, r8, lsl fp
    1374:	000a8206 	andeq	r8, sl, r6, lsl #4
    1378:	1a070500 	bne	1c2780 <__bss_end+0x1b8c00>
    137c:	00000071 	andeq	r0, r0, r1, ror r0
    1380:	9b1c0305 	blls	701f9c <__bss_end+0x6f841c>
    1384:	ba060000 	blt	18138c <__bss_end+0x17780c>
    1388:	0500000d 	streq	r0, [r0, #-13]
    138c:	00711a09 	rsbseq	r1, r1, r9, lsl #20
    1390:	03050000 	movweq	r0, #20480	; 0x5000
    1394:	00009b20 	andeq	r9, r0, r0, lsr #22
    1398:	000a4506 	andeq	r4, sl, r6, lsl #10
    139c:	1a0b0500 	bne	2c27a4 <__bss_end+0x2b8c24>
    13a0:	00000071 	andeq	r0, r0, r1, ror r0
    13a4:	9b240305 	blls	901fc0 <__bss_end+0x8f8440>
    13a8:	4c060000 	stcmi	0, cr0, [r6], {-0}
    13ac:	0500000d 	streq	r0, [r0, #-13]
    13b0:	00711a0d 	rsbseq	r1, r1, sp, lsl #20
    13b4:	03050000 	movweq	r0, #20480	; 0x5000
    13b8:	00009b28 	andeq	r9, r0, r8, lsr #22
    13bc:	00069e06 	andeq	r9, r6, r6, lsl #28
    13c0:	1a0f0500 	bne	3c27c8 <__bss_end+0x3b8c48>
    13c4:	00000071 	andeq	r0, r0, r1, ror r0
    13c8:	9b2c0305 	blls	b01fe4 <__bss_end+0xaf8464>
    13cc:	66090000 	strvs	r0, [r9], -r0
    13d0:	0500000c 	streq	r0, [r0, #-12]
    13d4:	00004904 	andeq	r4, r0, r4, lsl #18
    13d8:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
    13dc:	00000252 	andeq	r0, r0, r2, asr r2
    13e0:	0006410b 	andeq	r4, r6, fp, lsl #2
    13e4:	a30b0000 	movwge	r0, #45056	; 0xb000
    13e8:	01000010 	tsteq	r0, r0, lsl r0
    13ec:	00126d0b 	andseq	r6, r2, fp, lsl #26
    13f0:	0c000200 	sfmeq	f0, 4, [r0], {-0}
    13f4:	00000419 	andeq	r0, r0, r9, lsl r4
    13f8:	0004e10d 	andeq	lr, r4, sp, lsl #2
    13fc:	63059000 	movwvs	r9, #20480	; 0x5000
    1400:	0003c507 	andeq	ip, r3, r7, lsl #10
    1404:	061d0700 	ldreq	r0, [sp], -r0, lsl #14
    1408:	05240000 	streq	r0, [r4, #-0]!
    140c:	02df1067 	sbcseq	r1, pc, #103	; 0x67
    1410:	b00e0000 	andlt	r0, lr, r0
    1414:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    1418:	03c51269 	biceq	r1, r5, #-1879048186	; 0x90000006
    141c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1420:	00000875 	andeq	r0, r0, r5, ror r8
    1424:	d5126b05 	ldrle	r6, [r2, #-2821]	; 0xfffff4fb
    1428:	10000003 	andne	r0, r0, r3
    142c:	0006360e 	andeq	r3, r6, lr, lsl #12
    1430:	166d0500 	strbtne	r0, [sp], -r0, lsl #10
    1434:	00000065 	andeq	r0, r0, r5, rrx
    1438:	0d8a0e14 	stceq	14, cr0, [sl, #80]	; 0x50
    143c:	70050000 	andvc	r0, r5, r0
    1440:	0003dc1c 	andeq	sp, r3, ip, lsl ip
    1444:	ed0e1800 	stc	8, cr1, [lr, #-0]
    1448:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    144c:	03dc1c72 	bicseq	r1, ip, #29184	; 0x7200
    1450:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1454:	000004dc 	ldrdeq	r0, [r0], -ip
    1458:	dc1c7505 	cfldr32le	mvfx7, [ip], {5}
    145c:	20000003 	andcs	r0, r0, r3
    1460:	000e2f0f 	andeq	r2, lr, pc, lsl #30
    1464:	1c770500 	cfldr64ne	mvdx0, [r7], #-0
    1468:	00001140 	andeq	r1, r0, r0, asr #2
    146c:	000003dc 	ldrdeq	r0, [r0], -ip
    1470:	000002d3 	ldrdeq	r0, [r0], -r3
    1474:	0003dc10 	andeq	sp, r3, r0, lsl ip
    1478:	03e21100 	mvneq	r1, #0, 2
    147c:	00000000 	andeq	r0, r0, r0
    1480:	00126207 	andseq	r6, r2, r7, lsl #4
    1484:	7b051800 	blvc	14748c <__bss_end+0x13d90c>
    1488:	00031410 	andeq	r1, r3, r0, lsl r4
    148c:	21b00e00 	lslscs	r0, r0, #28
    1490:	7e050000 	cdpvc	0, 0, cr0, cr5, cr0, {0}
    1494:	0003c512 	andeq	ip, r3, r2, lsl r5
    1498:	3e0e0000 	cdpcc	0, 0, cr0, cr14, cr0, {0}
    149c:	05000005 	streq	r0, [r0, #-5]
    14a0:	03e21980 	mvneq	r1, #128, 18	; 0x200000
    14a4:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    14a8:	00000a1e 	andeq	r0, r0, lr, lsl sl
    14ac:	ed218205 	sfm	f0, 1, [r1, #-20]!	; 0xffffffec
    14b0:	14000003 	strne	r0, [r0], #-3
    14b4:	02df0300 	sbcseq	r0, pc, #0, 6
    14b8:	8f120000 	svchi	0x00120000
    14bc:	05000004 	streq	r0, [r0, #-4]
    14c0:	03f32186 	mvnseq	r2, #-2147483615	; 0x80000021
    14c4:	9f120000 	svcls	0x00120000
    14c8:	05000008 	streq	r0, [r0, #-8]
    14cc:	00711f88 	rsbseq	r1, r1, r8, lsl #31
    14d0:	cc0e0000 	stcgt	0, cr0, [lr], {-0}
    14d4:	0500000d 	streq	r0, [r0, #-13]
    14d8:	0264178b 	rsbeq	r1, r4, #36438016	; 0x22c0000
    14dc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    14e0:	000007d7 	ldrdeq	r0, [r0], -r7
    14e4:	64178e05 	ldrvs	r8, [r7], #-3589	; 0xfffff1fb
    14e8:	24000002 	strcs	r0, [r0], #-2
    14ec:	000b6b0e 	andeq	r6, fp, lr, lsl #22
    14f0:	178f0500 	strne	r0, [pc, r0, lsl #10]
    14f4:	00000264 	andeq	r0, r0, r4, ror #4
    14f8:	099f0e48 	ldmibeq	pc, {r3, r6, r9, sl, fp}	; <UNPREDICTABLE>
    14fc:	90050000 	andls	r0, r5, r0
    1500:	00026417 	andeq	r6, r2, r7, lsl r4
    1504:	e1136c00 	tst	r3, r0, lsl #24
    1508:	05000004 	streq	r0, [r0, #-4]
    150c:	0d0f0993 	vstreq.16	s0, [pc, #-294]	; 13ee <shift+0x13ee>	; <UNPREDICTABLE>
    1510:	03fe0000 	mvnseq	r0, #0
    1514:	7e010000 	cdpvc	0, 0, cr0, cr1, cr0, {0}
    1518:	84000003 	strhi	r0, [r0], #-3
    151c:	10000003 	andne	r0, r0, r3
    1520:	000003fe 	strdeq	r0, [r0], -lr
    1524:	0e241400 	cdpeq	4, 2, cr1, cr4, cr0, {0}
    1528:	96050000 	strls	r0, [r5], -r0
    152c:	00051f0e 	andeq	r1, r5, lr, lsl #30
    1530:	03990100 	orrseq	r0, r9, #0, 2
    1534:	039f0000 	orrseq	r0, pc, #0
    1538:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
    153c:	00000003 	andeq	r0, r0, r3
    1540:	00087015 	andeq	r7, r8, r5, lsl r0
    1544:	10990500 	addsne	r0, r9, r0, lsl #10
    1548:	00000c4b 	andeq	r0, r0, fp, asr #24
    154c:	00000404 	andeq	r0, r0, r4, lsl #8
    1550:	0003b401 	andeq	fp, r3, r1, lsl #8
    1554:	03fe1000 	mvnseq	r1, #0
    1558:	e2110000 	ands	r0, r1, #0
    155c:	11000003 	tstne	r0, r3
    1560:	0000022d 	andeq	r0, r0, sp, lsr #4
    1564:	25160000 	ldrcs	r0, [r6, #-0]
    1568:	d5000000 	strle	r0, [r0, #-0]
    156c:	17000003 	strne	r0, [r0, -r3]
    1570:	00000076 	andeq	r0, r0, r6, ror r0
    1574:	0102000f 	tsteq	r2, pc
    1578:	000b0602 	andeq	r0, fp, r2, lsl #12
    157c:	64041800 	strvs	r1, [r4], #-2048	; 0xfffff800
    1580:	18000002 	stmdane	r0, {r1}
    1584:	00002c04 	andeq	r2, r0, r4, lsl #24
    1588:	11150c00 	tstne	r5, r0, lsl #24
    158c:	04180000 	ldreq	r0, [r8], #-0
    1590:	000003e8 	andeq	r0, r0, r8, ror #7
    1594:	00031416 	andeq	r1, r3, r6, lsl r4
    1598:	0003fe00 	andeq	pc, r3, r0, lsl #28
    159c:	18001900 	stmdane	r0, {r8, fp, ip}
    15a0:	00025704 	andeq	r5, r2, r4, lsl #14
    15a4:	52041800 	andpl	r1, r4, #0, 16
    15a8:	1a000002 	bne	15b8 <shift+0x15b8>
    15ac:	00000e18 	andeq	r0, r0, r8, lsl lr
    15b0:	57149c05 	ldrpl	r9, [r4, -r5, lsl #24]
    15b4:	06000002 	streq	r0, [r0], -r2
    15b8:	00000657 	andeq	r0, r0, r7, asr r6
    15bc:	71140406 	tstvc	r4, r6, lsl #8
    15c0:	05000000 	streq	r0, [r0, #-0]
    15c4:	009b3003 	addseq	r3, fp, r3
    15c8:	0e930600 	cdpeq	6, 9, cr0, cr3, cr0, {0}
    15cc:	07060000 	streq	r0, [r6, -r0]
    15d0:	00007114 	andeq	r7, r0, r4, lsl r1
    15d4:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
    15d8:	0600009b 			; <UNDEFINED> instruction: 0x0600009b
    15dc:	0000050c 	andeq	r0, r0, ip, lsl #10
    15e0:	71140a06 	tstvc	r4, r6, lsl #20
    15e4:	05000000 	streq	r0, [r0, #-0]
    15e8:	009b3803 	addseq	r3, fp, r3, lsl #16
    15ec:	07550900 	ldrbeq	r0, [r5, -r0, lsl #18]
    15f0:	04050000 	streq	r0, [r5], #-0
    15f4:	00000049 	andeq	r0, r0, r9, asr #32
    15f8:	830c0d06 	movwhi	r0, #52486	; 0xcd06
    15fc:	0a000004 	beq	1614 <shift+0x1614>
    1600:	0077654e 	rsbseq	r6, r7, lr, asr #10
    1604:	09380b00 	ldmdbeq	r8!, {r8, r9, fp}
    1608:	0b010000 	bleq	41610 <__bss_end+0x37a90>
    160c:	00000504 	andeq	r0, r0, r4, lsl #10
    1610:	07950b02 	ldreq	r0, [r5, r2, lsl #22]
    1614:	0b030000 	bleq	c161c <__bss_end+0xb7a9c>
    1618:	00001029 	andeq	r1, r0, r9, lsr #32
    161c:	04d50b04 	ldrbeq	r0, [r5], #2820	; 0xb04
    1620:	00050000 	andeq	r0, r5, r0
    1624:	00067007 	andeq	r7, r6, r7
    1628:	1b061000 	blne	185630 <__bss_end+0x17bab0>
    162c:	0004c208 	andeq	ip, r4, r8, lsl #4
    1630:	726c0800 	rsbvc	r0, ip, #0, 16
    1634:	131d0600 	tstne	sp, #0, 12
    1638:	000004c2 	andeq	r0, r0, r2, asr #9
    163c:	70730800 	rsbsvc	r0, r3, r0, lsl #16
    1640:	131e0600 	tstne	lr, #0, 12
    1644:	000004c2 	andeq	r0, r0, r2, asr #9
    1648:	63700804 	cmnvs	r0, #4, 16	; 0x40000
    164c:	131f0600 	tstne	pc, #0, 12
    1650:	000004c2 	andeq	r0, r0, r2, asr #9
    1654:	0e3a0e08 	cdpeq	14, 3, cr0, cr10, cr8, {0}
    1658:	20060000 	andcs	r0, r6, r0
    165c:	0004c213 	andeq	ip, r4, r3, lsl r2
    1660:	02000c00 	andeq	r0, r0, #0, 24
    1664:	07660704 	strbeq	r0, [r6, -r4, lsl #14]!
    1668:	0c070000 	stceq	0, cr0, [r7], {-0}
    166c:	70000009 	andvc	r0, r0, r9
    1670:	59082806 	stmdbpl	r8, {r1, r2, fp, sp}
    1674:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1678:	0000081f 	andeq	r0, r0, pc, lsl r8
    167c:	83122a06 	tsthi	r2, #24576	; 0x6000
    1680:	00000004 	andeq	r0, r0, r4
    1684:	64697008 	strbtvs	r7, [r9], #-8
    1688:	122b0600 	eorne	r0, fp, #0, 12
    168c:	00000076 	andeq	r0, r0, r6, ror r0
    1690:	1ba30e10 	blne	fe8c4ed8 <__bss_end+0xfe8bb358>
    1694:	2c060000 	stccs	0, cr0, [r6], {-0}
    1698:	00044c11 	andeq	r4, r4, r1, lsl ip
    169c:	020e1400 	andeq	r1, lr, #0, 8
    16a0:	06000010 			; <UNDEFINED> instruction: 0x06000010
    16a4:	0076122d 	rsbseq	r1, r6, sp, lsr #4
    16a8:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    16ac:	000003a9 	andeq	r0, r0, r9, lsr #7
    16b0:	76122e06 	ldrvc	r2, [r2], -r6, lsl #28
    16b4:	1c000000 	stcne	0, cr0, [r0], {-0}
    16b8:	000e800e 	andeq	r8, lr, lr
    16bc:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 16c4 <shift+0x16c4>
    16c0:	00000559 	andeq	r0, r0, r9, asr r5
    16c4:	04850e20 	streq	r0, [r5], #3616	; 0xe20
    16c8:	30060000 	andcc	r0, r6, r0
    16cc:	00004909 	andeq	r4, r0, r9, lsl #18
    16d0:	c50e6000 	strgt	r6, [lr, #-0]
    16d4:	0600000a 	streq	r0, [r0], -sl
    16d8:	00650e31 	rsbeq	r0, r5, r1, lsr lr
    16dc:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    16e0:	00000cf4 	strdeq	r0, [r0], -r4
    16e4:	650e3306 	strvs	r3, [lr, #-774]	; 0xfffffcfa
    16e8:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    16ec:	000ceb0e 	andeq	lr, ip, lr, lsl #22
    16f0:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
    16f4:	00000065 	andeq	r0, r0, r5, rrx
    16f8:	0416006c 	ldreq	r0, [r6], #-108	; 0xffffff94
    16fc:	69000004 	stmdbvs	r0, {r2}
    1700:	17000005 	strne	r0, [r0, -r5]
    1704:	00000076 	andeq	r0, r0, r6, ror r0
    1708:	f506000f 			; <UNDEFINED> instruction: 0xf506000f
    170c:	07000004 	streq	r0, [r0, -r4]
    1710:	0071140a 	rsbseq	r1, r1, sl, lsl #8
    1714:	03050000 	movweq	r0, #20480	; 0x5000
    1718:	00009b3c 	andeq	r9, r0, ip, lsr fp
    171c:	000ab009 	andeq	fp, sl, r9
    1720:	49040500 	stmdbmi	r4, {r8, sl}
    1724:	07000000 	streq	r0, [r0, -r0]
    1728:	059a0c0d 	ldreq	r0, [sl, #3085]	; 0xc0d
    172c:	810b0000 	mrshi	r0, (UNDEF: 11)
    1730:	00000012 	andeq	r0, r0, r2, lsl r0
    1734:	0010d80b 	andseq	sp, r0, fp, lsl #16
    1738:	03000100 	movweq	r0, #256	; 0x100
    173c:	0000057b 	andeq	r0, r0, fp, ror r5
    1740:	00148409 	andseq	r8, r4, r9, lsl #8
    1744:	49040500 	stmdbmi	r4, {r8, sl}
    1748:	07000000 	streq	r0, [r0, -r0]
    174c:	05be0c14 	ldreq	r0, [lr, #3092]!	; 0xc14
    1750:	1a0b0000 	bne	2c1758 <__bss_end+0x2b7bd8>
    1754:	00000013 	andeq	r0, r0, r3, lsl r0
    1758:	0015180b 	andseq	r1, r5, fp, lsl #16
    175c:	03000100 	movweq	r0, #256	; 0x100
    1760:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1764:	00080407 	andeq	r0, r8, r7, lsl #8
    1768:	1b070c00 	blne	1c4770 <__bss_end+0x1babf0>
    176c:	0005f808 	andeq	pc, r5, r8, lsl #16
    1770:	059d0e00 	ldreq	r0, [sp, #3584]	; 0xe00
    1774:	1d070000 	stcne	0, cr0, [r7, #-0]
    1778:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
    177c:	dc0e0000 	stcle	0, cr0, [lr], {-0}
    1780:	07000004 	streq	r0, [r0, -r4]
    1784:	05f8191e 	ldrbeq	r1, [r8, #2334]!	; 0x91e
    1788:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    178c:	00000ae0 	andeq	r0, r0, r0, ror #21
    1790:	fe131f07 	cdp2	15, 1, cr1, cr3, cr7, {0}
    1794:	08000005 	stmdaeq	r0, {r0, r2}
    1798:	c3041800 	movwgt	r1, #18432	; 0x4800
    179c:	18000005 	stmdane	r0, {r0, r2}
    17a0:	0004c904 	andeq	ip, r4, r4, lsl #18
    17a4:	0ddb0d00 	ldcleq	13, cr0, [fp]
    17a8:	07140000 	ldreq	r0, [r4, -r0]
    17ac:	08860722 	stmeq	r6, {r1, r5, r8, r9, sl}
    17b0:	f50e0000 			; <UNDEFINED> instruction: 0xf50e0000
    17b4:	0700000b 	streq	r0, [r0, -fp]
    17b8:	00651226 	rsbeq	r1, r5, r6, lsr #4
    17bc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    17c0:	00000b88 	andeq	r0, r0, r8, lsl #23
    17c4:	f81d2907 			; <UNDEFINED> instruction: 0xf81d2907
    17c8:	04000005 	streq	r0, [r0], #-5
    17cc:	00079d0e 	andeq	r9, r7, lr, lsl #26
    17d0:	1d2c0700 	stcne	7, cr0, [ip, #-0]
    17d4:	000005f8 	strdeq	r0, [r0], -r8
    17d8:	0c761b08 			; <UNDEFINED> instruction: 0x0c761b08
    17dc:	2f070000 	svccs	0x00070000
    17e0:	0007e10e 	andeq	lr, r7, lr, lsl #2
    17e4:	00064c00 	andeq	r4, r6, r0, lsl #24
    17e8:	00065700 	andeq	r5, r6, r0, lsl #14
    17ec:	088b1000 	stmeq	fp, {ip}
    17f0:	f8110000 			; <UNDEFINED> instruction: 0xf8110000
    17f4:	00000005 	andeq	r0, r0, r5
    17f8:	0009411c 	andeq	r4, r9, ip, lsl r1
    17fc:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
    1800:	000008e3 	andeq	r0, r0, r3, ror #17
    1804:	000003d5 	ldrdeq	r0, [r0], -r5
    1808:	0000066f 	andeq	r0, r0, pc, ror #12
    180c:	0000067a 	andeq	r0, r0, sl, ror r6
    1810:	00088b10 	andeq	r8, r8, r0, lsl fp
    1814:	05fe1100 	ldrbeq	r1, [lr, #256]!	; 0x100
    1818:	13000000 	movwne	r0, #0
    181c:	00001084 	andeq	r1, r0, r4, lsl #1
    1820:	a81d3507 	ldmdage	sp, {r0, r1, r2, r8, sl, ip, sp}
    1824:	f8000006 			; <UNDEFINED> instruction: 0xf8000006
    1828:	02000005 	andeq	r0, r0, #5
    182c:	00000693 	muleq	r0, r3, r6
    1830:	00000699 	muleq	r0, r9, r6
    1834:	00088b10 	andeq	r8, r8, r0, lsl fp
    1838:	7d130000 	ldcvc	0, cr0, [r3, #-0]
    183c:	07000007 	streq	r0, [r0, -r7]
    1840:	0c861d37 	stceq	13, cr1, [r6], {55}	; 0x37
    1844:	05f80000 	ldrbeq	r0, [r8, #0]!
    1848:	b2020000 	andlt	r0, r2, #0
    184c:	b8000006 	stmdalt	r0, {r1, r2}
    1850:	10000006 	andne	r0, r0, r6
    1854:	0000088b 	andeq	r0, r0, fp, lsl #17
    1858:	0b9b1d00 	bleq	fe6c8c60 <__bss_end+0xfe6bf0e0>
    185c:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
    1860:	0008a431 	andeq	sl, r8, r1, lsr r4
    1864:	13020c00 	movwne	r0, #11264	; 0x2c00
    1868:	00000ddb 	ldrdeq	r0, [r0], -fp
    186c:	50093c07 	andpl	r3, r9, r7, lsl #24
    1870:	8b000009 	blhi	189c <shift+0x189c>
    1874:	01000008 	tsteq	r0, r8
    1878:	000006df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    187c:	000006e5 	andeq	r0, r0, r5, ror #13
    1880:	00088b10 	andeq	r8, r8, r0, lsl fp
    1884:	31130000 	tstcc	r3, r0
    1888:	07000008 	streq	r0, [r0, -r8]
    188c:	0567123f 	strbeq	r1, [r7, #-575]!	; 0xfffffdc1
    1890:	00650000 	rsbeq	r0, r5, r0
    1894:	fe010000 	cdp2	0, 0, cr0, cr1, cr0, {0}
    1898:	13000006 	movwne	r0, #6
    189c:	10000007 	andne	r0, r0, r7
    18a0:	0000088b 	andeq	r0, r0, fp, lsl #17
    18a4:	0008ad11 	andeq	sl, r8, r1, lsl sp
    18a8:	00761100 	rsbseq	r1, r6, r0, lsl #2
    18ac:	d5110000 	ldrle	r0, [r1, #-0]
    18b0:	00000003 	andeq	r0, r0, r3
    18b4:	0010ae14 	andseq	sl, r0, r4, lsl lr
    18b8:	0e420700 	cdpeq	7, 4, cr0, cr2, cr0, {0}
    18bc:	0000067d 	andeq	r0, r0, sp, ror r6
    18c0:	00072801 	andeq	r2, r7, r1, lsl #16
    18c4:	00072e00 	andeq	r2, r7, r0, lsl #28
    18c8:	088b1000 	stmeq	fp, {ip}
    18cc:	13000000 	movwne	r0, #0
    18d0:	00000549 	andeq	r0, r0, r9, asr #10
    18d4:	ef174507 	svc	0x00174507
    18d8:	fe000005 	cdp2	0, 0, cr0, cr0, cr5, {0}
    18dc:	01000005 	tsteq	r0, r5
    18e0:	00000747 	andeq	r0, r0, r7, asr #14
    18e4:	0000074d 	andeq	r0, r0, sp, asr #14
    18e8:	0008b310 	andeq	fp, r8, r0, lsl r3
    18ec:	9e130000 	cdpls	0, 1, cr0, cr3, cr0, {0}
    18f0:	0700000e 	streq	r0, [r0, -lr]
    18f4:	03bf1748 			; <UNDEFINED> instruction: 0x03bf1748
    18f8:	05fe0000 	ldrbeq	r0, [lr, #0]!
    18fc:	66010000 	strvs	r0, [r1], -r0
    1900:	71000007 	tstvc	r0, r7
    1904:	10000007 	andne	r0, r0, r7
    1908:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    190c:	00006511 	andeq	r6, r0, r1, lsl r5
    1910:	cd140000 	ldcgt	0, cr0, [r4, #-0]
    1914:	07000006 	streq	r0, [r0, -r6]
    1918:	0ba90e4b 	bleq	fea4524c <__bss_end+0xfea3b6cc>
    191c:	86010000 	strhi	r0, [r1], -r0
    1920:	8c000007 	stchi	0, cr0, [r0], {7}
    1924:	10000007 	andne	r0, r0, r7
    1928:	0000088b 	andeq	r0, r0, fp, lsl #17
    192c:	09411300 	stmdbeq	r1, {r8, r9, ip}^
    1930:	4d070000 	stcmi	0, cr0, [r7, #-0]
    1934:	000d240e 	andeq	r2, sp, lr, lsl #8
    1938:	0003d500 	andeq	sp, r3, r0, lsl #10
    193c:	07a50100 	streq	r0, [r5, r0, lsl #2]!
    1940:	07b00000 	ldreq	r0, [r0, r0]!
    1944:	8b100000 	blhi	40194c <__bss_end+0x3f7dcc>
    1948:	11000008 	tstne	r0, r8
    194c:	00000065 	andeq	r0, r0, r5, rrx
    1950:	04c11300 	strbeq	r1, [r1], #768	; 0x300
    1954:	50070000 	andpl	r0, r7, r0
    1958:	0003ec12 	andeq	lr, r3, r2, lsl ip
    195c:	00006500 	andeq	r6, r0, r0, lsl #10
    1960:	07c90100 	strbeq	r0, [r9, r0, lsl #2]
    1964:	07d40000 	ldrbeq	r0, [r4, r0]
    1968:	8b100000 	blhi	401970 <__bss_end+0x3f7df0>
    196c:	11000008 	tstne	r0, r8
    1970:	00000404 	andeq	r0, r0, r4, lsl #8
    1974:	041f1300 	ldreq	r1, [pc], #-768	; 197c <shift+0x197c>
    1978:	53070000 	movwpl	r0, #28672	; 0x7000
    197c:	0010e30e 	andseq	lr, r0, lr, lsl #6
    1980:	0003d500 	andeq	sp, r3, r0, lsl #10
    1984:	07ed0100 	strbeq	r0, [sp, r0, lsl #2]!
    1988:	07f80000 	ldrbeq	r0, [r8, r0]!
    198c:	8b100000 	blhi	401994 <__bss_end+0x3f7e14>
    1990:	11000008 	tstne	r0, r8
    1994:	00000065 	andeq	r0, r0, r5, rrx
    1998:	049b1400 	ldreq	r1, [fp], #1024	; 0x400
    199c:	56070000 	strpl	r0, [r7], -r0
    19a0:	000f850e 	andeq	r8, pc, lr, lsl #10
    19a4:	080d0100 	stmdaeq	sp, {r8}
    19a8:	082c0000 	stmdaeq	ip!, {}	; <UNPREDICTABLE>
    19ac:	8b100000 	blhi	4019b4 <__bss_end+0x3f7e34>
    19b0:	11000008 	tstne	r0, r8
    19b4:	00000110 	andeq	r0, r0, r0, lsl r1
    19b8:	00006511 	andeq	r6, r0, r1, lsl r5
    19bc:	00651100 	rsbeq	r1, r5, r0, lsl #2
    19c0:	65110000 	ldrvs	r0, [r1, #-0]
    19c4:	11000000 	mrsne	r0, (UNDEF: 0)
    19c8:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    19cc:	11701400 	cmnne	r0, r0, lsl #8
    19d0:	58070000 	stmdapl	r7, {}	; <UNPREDICTABLE>
    19d4:	0012a80e 	andseq	sl, r2, lr, lsl #16
    19d8:	08410100 	stmdaeq	r1, {r8}^
    19dc:	08600000 	stmdaeq	r0!, {}^	; <UNPREDICTABLE>
    19e0:	8b100000 	blhi	4019e8 <__bss_end+0x3f7e68>
    19e4:	11000008 	tstne	r0, r8
    19e8:	00000147 	andeq	r0, r0, r7, asr #2
    19ec:	00006511 	andeq	r6, r0, r1, lsl r5
    19f0:	00651100 	rsbeq	r1, r5, r0, lsl #2
    19f4:	65110000 	ldrvs	r0, [r1, #-0]
    19f8:	11000000 	mrsne	r0, (UNDEF: 0)
    19fc:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    1a00:	04ae1500 	strteq	r1, [lr], #1280	; 0x500
    1a04:	5b070000 	blpl	1c1a0c <__bss_end+0x1b7e8c>
    1a08:	000b0b0e 	andeq	r0, fp, lr, lsl #22
    1a0c:	0003d500 	andeq	sp, r3, r0, lsl #10
    1a10:	08750100 	ldmdaeq	r5!, {r8}^
    1a14:	8b100000 	blhi	401a1c <__bss_end+0x3f7e9c>
    1a18:	11000008 	tstne	r0, r8
    1a1c:	0000057b 	andeq	r0, r0, fp, ror r5
    1a20:	0008bf11 	andeq	fp, r8, r1, lsl pc
    1a24:	03000000 	movweq	r0, #0
    1a28:	00000604 	andeq	r0, r0, r4, lsl #12
    1a2c:	06040418 			; <UNDEFINED> instruction: 0x06040418
    1a30:	f81e0000 			; <UNDEFINED> instruction: 0xf81e0000
    1a34:	9e000005 	cdpls	0, 0, cr0, cr0, cr5, {0}
    1a38:	a4000008 	strge	r0, [r0], #-8
    1a3c:	10000008 	andne	r0, r0, r8
    1a40:	0000088b 	andeq	r0, r0, fp, lsl #17
    1a44:	06041f00 	streq	r1, [r4], -r0, lsl #30
    1a48:	08910000 	ldmeq	r1, {}	; <UNPREDICTABLE>
    1a4c:	04180000 	ldreq	r0, [r8], #-0
    1a50:	00000057 	andeq	r0, r0, r7, asr r0
    1a54:	08860418 	stmeq	r6, {r3, r4, sl}
    1a58:	04200000 	strteq	r0, [r0], #-0
    1a5c:	000000cc 	andeq	r0, r0, ip, asr #1
    1a60:	cd1a0421 	cfldrsgt	mvf0, [sl, #-132]	; 0xffffff7c
    1a64:	07000011 	smladeq	r0, r1, r0, r0
    1a68:	0604195e 			; <UNDEFINED> instruction: 0x0604195e
    1a6c:	78060000 	stmdavc	r6, {}	; <UNPREDICTABLE>
    1a70:	08000012 	stmdaeq	r0, {r1, r4}
    1a74:	08e61104 	stmiaeq	r6!, {r2, r8, ip}^
    1a78:	03050000 	movweq	r0, #20480	; 0x5000
    1a7c:	00009b40 	andeq	r9, r0, r0, asr #22
    1a80:	21040402 	tstcs	r4, r2, lsl #8
    1a84:	0300001c 	movweq	r0, #28
    1a88:	000008df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1a8c:	00002c16 	andeq	r2, r0, r6, lsl ip
    1a90:	0008fb00 	andeq	pc, r8, r0, lsl #22
    1a94:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1a98:	00090000 	andeq	r0, r9, r0
    1a9c:	0008eb03 	andeq	lr, r8, r3, lsl #22
    1aa0:	13cc2200 	bicne	r2, ip, #0, 4
    1aa4:	a4010000 	strge	r0, [r1], #-0
    1aa8:	0008fb0c 	andeq	pc, r8, ip, lsl #22
    1aac:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
    1ab0:	2300009b 	movwcs	r0, #155	; 0x9b
    1ab4:	00000e66 	andeq	r0, r0, r6, ror #28
    1ab8:	780aa601 	stmdavc	sl, {r0, r9, sl, sp, pc}
    1abc:	65000014 	strvs	r0, [r0, #-20]	; 0xffffffec
    1ac0:	c4000000 	strgt	r0, [r0], #-0
    1ac4:	b0000087 	andlt	r0, r0, r7, lsl #1
    1ac8:	01000000 	mrseq	r0, (UNDEF: 0)
    1acc:	0009709c 	muleq	r9, ip, r0
    1ad0:	21b02400 	lslscs	r2, r0, #8
    1ad4:	a6010000 	strge	r0, [r1], -r0
    1ad8:	0003e21b 	andeq	lr, r3, fp, lsl r2
    1adc:	ac910300 	ldcge	3, cr0, [r1], {0}
    1ae0:	1504247f 	strne	r2, [r4, #-1151]	; 0xfffffb81
    1ae4:	a6010000 	strge	r0, [r1], -r0
    1ae8:	0000652a 	andeq	r6, r0, sl, lsr #10
    1aec:	a8910300 	ldmge	r1, {r8, r9}
    1af0:	1460227f 	strbtne	r2, [r0], #-639	; 0xfffffd81
    1af4:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    1af8:	0009700a 	andeq	r7, r9, sl
    1afc:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1b00:	132e227f 			; <UNDEFINED> instruction: 0x132e227f
    1b04:	ac010000 	stcge	0, cr0, [r1], {-0}
    1b08:	00004909 	andeq	r4, r0, r9, lsl #18
    1b0c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b10:	00251600 	eoreq	r1, r5, r0, lsl #12
    1b14:	09800000 	stmibeq	r0, {}	; <UNPREDICTABLE>
    1b18:	76170000 	ldrvc	r0, [r7], -r0
    1b1c:	3f000000 	svccc	0x00000000
    1b20:	14e32500 	strbtne	r2, [r3], #1280	; 0x500
    1b24:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1b28:	0015260a 	andseq	r2, r5, sl, lsl #12
    1b2c:	00006500 	andeq	r6, r0, r0, lsl #10
    1b30:	00878800 	addeq	r8, r7, r0, lsl #16
    1b34:	00003c00 	andeq	r3, r0, r0, lsl #24
    1b38:	bd9c0100 	ldflts	f0, [ip]
    1b3c:	26000009 	strcs	r0, [r0], -r9
    1b40:	00716572 	rsbseq	r6, r1, r2, ror r5
    1b44:	be209a01 	vmullt.f32	s18, s0, s2
    1b48:	02000005 	andeq	r0, r0, #5
    1b4c:	6d227491 	cfstrsvs	mvf7, [r2, #-580]!	; 0xfffffdbc
    1b50:	01000014 	tsteq	r0, r4, lsl r0
    1b54:	00650e9b 	mlseq	r5, fp, lr, r0
    1b58:	91020000 	mrsls	r0, (UNDEF: 2)
    1b5c:	f7270070 			; <UNDEFINED> instruction: 0xf7270070
    1b60:	01000013 	tsteq	r0, r3, lsl r0
    1b64:	1356068f 	cmpne	r6, #149946368	; 0x8f00000
    1b68:	874c0000 	strbhi	r0, [ip, -r0]
    1b6c:	003c0000 	eorseq	r0, ip, r0
    1b70:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b74:	000009f6 	strdeq	r0, [r0], -r6
    1b78:	0013b824 	andseq	fp, r3, r4, lsr #16
    1b7c:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1b80:	00000065 	andeq	r0, r0, r5, rrx
    1b84:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1b88:	00716572 	rsbseq	r6, r1, r2, ror r5
    1b8c:	be209101 	abslts	f1, f1
    1b90:	02000005 	andeq	r0, r0, #5
    1b94:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b98:	00001499 	muleq	r0, r9, r4
    1b9c:	dd0a8301 	stcle	3, cr8, [sl, #-4]
    1ba0:	65000013 	strvs	r0, [r0, #-19]	; 0xffffffed
    1ba4:	10000000 	andne	r0, r0, r0
    1ba8:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1bac:	01000000 	mrseq	r0, (UNDEF: 0)
    1bb0:	000a339c 	muleq	sl, ip, r3
    1bb4:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1bb8:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1bbc:	00059a20 	andeq	r9, r5, r0, lsr #20
    1bc0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bc4:	00132722 	andseq	r2, r3, r2, lsr #14
    1bc8:	0e860100 	rmfeqs	f0, f6, f0
    1bcc:	00000065 	andeq	r0, r0, r5, rrx
    1bd0:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1bd4:	0015b325 	andseq	fp, r5, r5, lsr #6
    1bd8:	0a770100 	beq	1dc1fe0 <__bss_end+0x1db8460>
    1bdc:	0000139a 	muleq	r0, sl, r3
    1be0:	00000065 	andeq	r0, r0, r5, rrx
    1be4:	000086d4 	ldrdeq	r8, [r0], -r4
    1be8:	0000003c 	andeq	r0, r0, ip, lsr r0
    1bec:	0a709c01 	beq	1c28bf8 <__bss_end+0x1c1f078>
    1bf0:	72260000 	eorvc	r0, r6, #0
    1bf4:	01007165 	tsteq	r0, r5, ror #2
    1bf8:	059a2079 	ldreq	r2, [sl, #121]	; 0x79
    1bfc:	91020000 	mrsls	r0, (UNDEF: 2)
    1c00:	13272274 			; <UNDEFINED> instruction: 0x13272274
    1c04:	7a010000 	bvc	41c0c <__bss_end+0x3808c>
    1c08:	0000650e 	andeq	r6, r0, lr, lsl #10
    1c0c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1c10:	13f12500 	mvnsne	r2, #0, 10
    1c14:	6b010000 	blvs	41c1c <__bss_end+0x3809c>
    1c18:	00150d06 	andseq	r0, r5, r6, lsl #26
    1c1c:	0003d500 	andeq	sp, r3, r0, lsl #10
    1c20:	00868000 	addeq	r8, r6, r0
    1c24:	00005400 	andeq	r5, r0, r0, lsl #8
    1c28:	bc9c0100 	ldflts	f0, [ip], {0}
    1c2c:	2400000a 	strcs	r0, [r0], #-10
    1c30:	0000146d 	andeq	r1, r0, sp, ror #8
    1c34:	65156b01 	ldrvs	r6, [r5, #-2817]	; 0xfffff4ff
    1c38:	02000000 	andeq	r0, r0, #0
    1c3c:	eb246c91 	bl	91ce88 <__bss_end+0x913308>
    1c40:	0100000c 	tsteq	r0, ip
    1c44:	0065256b 	rsbeq	r2, r5, fp, ror #10
    1c48:	91020000 	mrsls	r0, (UNDEF: 2)
    1c4c:	15ab2268 	strne	r2, [fp, #616]!	; 0x268
    1c50:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1c54:	0000650e 	andeq	r6, r0, lr, lsl #10
    1c58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c5c:	136d2500 	cmnne	sp, #0, 10
    1c60:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c64:	00155d12 	andseq	r5, r5, r2, lsl sp
    1c68:	0000f200 	andeq	pc, r0, r0, lsl #4
    1c6c:	00863000 	addeq	r3, r6, r0
    1c70:	00005000 	andeq	r5, r0, r0
    1c74:	179c0100 	ldrne	r0, [ip, r0, lsl #2]
    1c78:	2400000b 	strcs	r0, [r0], #-11
    1c7c:	00000778 	andeq	r0, r0, r8, ror r7
    1c80:	65205e01 	strvs	r5, [r0, #-3585]!	; 0xfffff1ff
    1c84:	02000000 	andeq	r0, r0, #0
    1c88:	a2246c91 	eorge	r6, r4, #37120	; 0x9100
    1c8c:	01000014 	tsteq	r0, r4, lsl r0
    1c90:	00652f5e 	rsbeq	r2, r5, lr, asr pc
    1c94:	91020000 	mrsls	r0, (UNDEF: 2)
    1c98:	0ceb2468 	cfstrdeq	mvd2, [fp], #416	; 0x1a0
    1c9c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1ca0:	0000653f 	andeq	r6, r0, pc, lsr r5
    1ca4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1ca8:	0015ab22 	andseq	sl, r5, r2, lsr #22
    1cac:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1cb0:	000000f2 	strdeq	r0, [r0], -r2
    1cb4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cb8:	00146625 	andseq	r6, r4, r5, lsr #12
    1cbc:	0a520100 	beq	14820c4 <__bss_end+0x1478544>
    1cc0:	00001372 	andeq	r1, r0, r2, ror r3
    1cc4:	00000065 	andeq	r0, r0, r5, rrx
    1cc8:	000085ec 	andeq	r8, r0, ip, ror #11
    1ccc:	00000044 	andeq	r0, r0, r4, asr #32
    1cd0:	0b639c01 	bleq	18e8cdc <__bss_end+0x18df15c>
    1cd4:	78240000 	stmdavc	r4!, {}	; <UNPREDICTABLE>
    1cd8:	01000007 	tsteq	r0, r7
    1cdc:	00651a52 	rsbeq	r1, r5, r2, asr sl
    1ce0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce4:	14a2246c 	strtne	r2, [r2], #1132	; 0x46c
    1ce8:	52010000 	andpl	r0, r1, #0
    1cec:	00006529 	andeq	r6, r0, r9, lsr #10
    1cf0:	68910200 	ldmvs	r1, {r9}
    1cf4:	00158c22 	andseq	r8, r5, r2, lsr #24
    1cf8:	0e540100 	rdfeqs	f0, f4, f0
    1cfc:	00000065 	andeq	r0, r0, r5, rrx
    1d00:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d04:	00158625 	andseq	r8, r5, r5, lsr #12
    1d08:	0a450100 	beq	1142110 <__bss_end+0x1138590>
    1d0c:	00001568 	andeq	r1, r0, r8, ror #10
    1d10:	00000065 	andeq	r0, r0, r5, rrx
    1d14:	0000859c 	muleq	r0, ip, r5
    1d18:	00000050 	andeq	r0, r0, r0, asr r0
    1d1c:	0bbe9c01 	bleq	fefa8d28 <__bss_end+0xfef9f1a8>
    1d20:	78240000 	stmdavc	r4!, {}	; <UNPREDICTABLE>
    1d24:	01000007 	tsteq	r0, r7
    1d28:	00651945 	rsbeq	r1, r5, r5, asr #18
    1d2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d30:	1409246c 	strne	r2, [r9], #-1132	; 0xfffffb94
    1d34:	45010000 	strmi	r0, [r1, #-0]
    1d38:	00018430 	andeq	r8, r1, r0, lsr r4
    1d3c:	68910200 	ldmvs	r1, {r9}
    1d40:	0014cf24 	andseq	ip, r4, r4, lsr #30
    1d44:	41450100 	mrsmi	r0, (UNDEF: 85)
    1d48:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    1d4c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d50:	000015ab 	andeq	r1, r0, fp, lsr #11
    1d54:	650e4701 	strvs	r4, [lr, #-1793]	; 0xfffff8ff
    1d58:	02000000 	andeq	r0, r0, #0
    1d5c:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1d60:	00001314 	andeq	r1, r0, r4, lsl r3
    1d64:	13063f01 	movwne	r3, #28417	; 0x6f01
    1d68:	70000014 	andvc	r0, r0, r4, lsl r0
    1d6c:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1d70:	01000000 	mrseq	r0, (UNDEF: 0)
    1d74:	000be89c 	muleq	fp, ip, r8
    1d78:	07782400 	ldrbeq	r2, [r8, -r0, lsl #8]!
    1d7c:	3f010000 	svccc	0x00010000
    1d80:	00006515 	andeq	r6, r0, r5, lsl r5
    1d84:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d88:	14fe2500 	ldrbtne	r2, [lr], #1280	; 0x500
    1d8c:	32010000 	andcc	r0, r1, #0
    1d90:	0014d50a 	andseq	sp, r4, sl, lsl #10
    1d94:	00006500 	andeq	r6, r0, r0, lsl #10
    1d98:	00852000 	addeq	r2, r5, r0
    1d9c:	00005000 	andeq	r5, r0, r0
    1da0:	439c0100 	orrsmi	r0, ip, #0, 2
    1da4:	2400000c 	strcs	r0, [r0], #-12
    1da8:	00000778 	andeq	r0, r0, r8, ror r7
    1dac:	65193201 	ldrvs	r3, [r9, #-513]	; 0xfffffdff
    1db0:	02000000 	andeq	r0, r0, #0
    1db4:	98246c91 	stmdals	r4!, {r0, r4, r7, sl, fp, sp, lr}
    1db8:	01000015 	tsteq	r0, r5, lsl r0
    1dbc:	03e22b32 	mvneq	r2, #51200	; 0xc800
    1dc0:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc4:	15082468 	strne	r2, [r8, #-1128]	; 0xfffffb98
    1dc8:	32010000 	andcc	r0, r1, #0
    1dcc:	0000653c 	andeq	r6, r0, ip, lsr r5
    1dd0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1dd4:	00155722 	andseq	r5, r5, r2, lsr #14
    1dd8:	0e340100 	rsfeqs	f0, f4, f0
    1ddc:	00000065 	andeq	r0, r0, r5, rrx
    1de0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1de4:	0015d525 	andseq	sp, r5, r5, lsr #10
    1de8:	0a250100 	beq	9421f0 <__bss_end+0x938670>
    1dec:	0000159f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1df0:	00000065 	andeq	r0, r0, r5, rrx
    1df4:	000084d0 	ldrdeq	r8, [r0], -r0
    1df8:	00000050 	andeq	r0, r0, r0, asr r0
    1dfc:	0c9e9c01 	ldceq	12, cr9, [lr], {1}
    1e00:	78240000 	stmdavc	r4!, {}	; <UNPREDICTABLE>
    1e04:	01000007 	tsteq	r0, r7
    1e08:	00651825 	rsbeq	r1, r5, r5, lsr #16
    1e0c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e10:	1598246c 	ldrne	r2, [r8, #1132]	; 0x46c
    1e14:	25010000 	strcs	r0, [r1, #-0]
    1e18:	000ca42a 	andeq	sl, ip, sl, lsr #8
    1e1c:	68910200 	ldmvs	r1, {r9}
    1e20:	00150824 	andseq	r0, r5, r4, lsr #16
    1e24:	3b250100 	blcc	94222c <__bss_end+0x9386ac>
    1e28:	00000065 	andeq	r0, r0, r5, rrx
    1e2c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1e30:	0000133f 	andeq	r1, r0, pc, lsr r3
    1e34:	650e2701 	strvs	r2, [lr, #-1793]	; 0xfffff8ff
    1e38:	02000000 	andeq	r0, r0, #0
    1e3c:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1e40:	00002504 	andeq	r2, r0, r4, lsl #10
    1e44:	0c9e0300 	ldceq	3, cr0, [lr], {0}
    1e48:	73250000 			; <UNDEFINED> instruction: 0x73250000
    1e4c:	01000014 	tsteq	r0, r4, lsl r0
    1e50:	15eb0a19 	strbne	r0, [fp, #2585]!	; 0xa19
    1e54:	00650000 	rsbeq	r0, r5, r0
    1e58:	848c0000 	strhi	r0, [ip], #0
    1e5c:	00440000 	subeq	r0, r4, r0
    1e60:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e64:	00000cf5 	strdeq	r0, [r0], -r5
    1e68:	0015cc24 	andseq	ip, r5, r4, lsr #24
    1e6c:	1b190100 	blne	642274 <__bss_end+0x6386f4>
    1e70:	000003e2 	andeq	r0, r0, r2, ror #7
    1e74:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1e78:	00001593 	muleq	r0, r3, r5
    1e7c:	2d351901 			; <UNDEFINED> instruction: 0x2d351901
    1e80:	02000002 	andeq	r0, r0, #2
    1e84:	78226891 	stmdavc	r2!, {r0, r4, r7, fp, sp, lr}
    1e88:	01000007 	tsteq	r0, r7
    1e8c:	00650e1b 	rsbeq	r0, r5, fp, lsl lr
    1e90:	91020000 	mrsls	r0, (UNDEF: 2)
    1e94:	33280074 			; <UNDEFINED> instruction: 0x33280074
    1e98:	01000013 	tsteq	r0, r3, lsl r0
    1e9c:	13450614 	movtne	r0, #22036	; 0x5614
    1ea0:	84700000 	ldrbthi	r0, [r0], #-0
    1ea4:	001c0000 	andseq	r0, ip, r0
    1ea8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1eac:	0015da27 	andseq	sp, r5, r7, lsr #20
    1eb0:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1eb4:	0000137e 	andeq	r1, r0, lr, ror r3
    1eb8:	00008444 	andeq	r8, r0, r4, asr #8
    1ebc:	0000002c 	andeq	r0, r0, ip, lsr #32
    1ec0:	0d359c01 	ldceq	12, cr9, [r5, #-4]!
    1ec4:	91240000 			; <UNDEFINED> instruction: 0x91240000
    1ec8:	01000013 	tsteq	r0, r3, lsl r0
    1ecc:	0049140e 	subeq	r1, r9, lr, lsl #8
    1ed0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ed4:	e4290074 	strt	r0, [r9], #-116	; 0xffffff8c
    1ed8:	01000015 	tsteq	r0, r5, lsl r0
    1edc:	14550a04 	ldrbne	r0, [r5], #-2564	; 0xfffff5fc
    1ee0:	00650000 	rsbeq	r0, r5, r0
    1ee4:	84180000 	ldrhi	r0, [r8], #-0
    1ee8:	002c0000 	eoreq	r0, ip, r0
    1eec:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ef0:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1ef4:	0e060100 	adfeqs	f0, f6, f0
    1ef8:	00000065 	andeq	r0, r0, r5, rrx
    1efc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f00:	0006f900 	andeq	pc, r6, r0, lsl #18
    1f04:	3e000400 	cfcpyscc	mvf0, mvf0
    1f08:	04000007 	streq	r0, [r0], #-7
    1f0c:	00160701 	andseq	r0, r6, r1, lsl #14
    1f10:	16ea0400 	strbtne	r0, [sl], r0, lsl #8
    1f14:	14a80000 	strtne	r0, [r8], #0
    1f18:	88740000 	ldmdahi	r4!, {}^	; <UNPREDICTABLE>
    1f1c:	0fdc0000 	svceq	0x00dc0000
    1f20:	07870000 	streq	r0, [r7, r0]
    1f24:	78020000 	stmdavc	r2, {}	; <UNPREDICTABLE>
    1f28:	02000012 	andeq	r0, r0, #18
    1f2c:	003e1104 	eorseq	r1, lr, r4, lsl #2
    1f30:	03050000 	movweq	r0, #20480	; 0x5000
    1f34:	00009b50 	andeq	r9, r0, r0, asr fp
    1f38:	21040403 	tstcs	r4, r3, lsl #8
    1f3c:	0400001c 	streq	r0, [r0], #-28	; 0xffffffe4
    1f40:	00000037 	andeq	r0, r0, r7, lsr r0
    1f44:	00006705 	andeq	r6, r0, r5, lsl #14
    1f48:	182a0600 	stmdane	sl!, {r9, sl}
    1f4c:	05010000 	streq	r0, [r1, #-0]
    1f50:	00007f10 	andeq	r7, r0, r0, lsl pc
    1f54:	31301100 	teqcc	r0, r0, lsl #2
    1f58:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1f5c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1f60:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1f64:	00004645 	andeq	r4, r0, r5, asr #12
    1f68:	01030107 	tsteq	r3, r7, lsl #2
    1f6c:	00000043 	andeq	r0, r0, r3, asr #32
    1f70:	00009708 	andeq	r9, r0, r8, lsl #14
    1f74:	00007f00 	andeq	r7, r0, r0, lsl #30
    1f78:	00840900 	addeq	r0, r4, r0, lsl #18
    1f7c:	00100000 	andseq	r0, r0, r0
    1f80:	00006f04 	andeq	r6, r0, r4, lsl #30
    1f84:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1f88:	0000076b 	andeq	r0, r0, fp, ror #14
    1f8c:	00008404 	andeq	r8, r0, r4, lsl #8
    1f90:	08010300 	stmdaeq	r1, {r8, r9}
    1f94:	00001024 	andeq	r1, r0, r4, lsr #32
    1f98:	00009004 	andeq	r9, r0, r4
    1f9c:	00480a00 	subeq	r0, r8, r0, lsl #20
    1fa0:	1e0b0000 	cdpne	0, 0, cr0, cr11, cr0, {0}
    1fa4:	01000018 	tsteq	r0, r8, lsl r0
    1fa8:	179507fc 			; <UNDEFINED> instruction: 0x179507fc
    1fac:	00370000 	eorseq	r0, r7, r0
    1fb0:	97400000 	strbls	r0, [r0, -r0]
    1fb4:	01100000 	tsteq	r0, r0
    1fb8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1fbc:	0000011d 	andeq	r0, r0, sp, lsl r1
    1fc0:	0100730c 	tsteq	r0, ip, lsl #6
    1fc4:	011d18fc 			; <UNDEFINED> instruction: 0x011d18fc
    1fc8:	91020000 	mrsls	r0, (UNDEF: 2)
    1fcc:	65720d64 	ldrbvs	r0, [r2, #-3428]!	; 0xfffff29c
    1fd0:	fe01007a 	mcr2	0, 0, r0, cr1, cr10, {3}
    1fd4:	00003709 	andeq	r3, r0, r9, lsl #14
    1fd8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1fdc:	0018b80e 	andseq	fp, r8, lr, lsl #16
    1fe0:	12fe0100 	rscsne	r0, lr, #0, 2
    1fe4:	00000037 	andeq	r0, r0, r7, lsr r0
    1fe8:	0f709102 	svceq	0x00709102
    1fec:	00009784 	andeq	r9, r0, r4, lsl #15
    1ff0:	000000a8 	andeq	r0, r0, r8, lsr #1
    1ff4:	00175c10 	andseq	r5, r7, r0, lsl ip
    1ff8:	01030100 	mrseq	r0, (UNDEF: 19)
    1ffc:	0001230c 	andeq	r2, r1, ip, lsl #6
    2000:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2004:	00979c0f 	addseq	r9, r7, pc, lsl #24
    2008:	00008000 	andeq	r8, r0, r0
    200c:	00641100 	rsbeq	r1, r4, r0, lsl #2
    2010:	09010801 	stmdbeq	r1, {r0, fp}
    2014:	00000123 	andeq	r0, r0, r3, lsr #2
    2018:	00689102 	rsbeq	r9, r8, r2, lsl #2
    201c:	04120000 	ldreq	r0, [r2], #-0
    2020:	00000097 	muleq	r0, r7, r0
    2024:	69050413 	stmdbvs	r5, {r0, r1, r4, sl}
    2028:	1400746e 	strne	r7, [r0], #-1134	; 0xfffffb92
    202c:	00001836 	andeq	r1, r0, r6, lsr r8
    2030:	a006c101 	andge	ip, r6, r1, lsl #2
    2034:	1c000018 	stcne	0, cr0, [r0], {24}
    2038:	24000094 	strcs	r0, [r0], #-148	; 0xffffff6c
    203c:	01000003 	tsteq	r0, r3
    2040:	0002299c 	muleq	r2, ip, r9
    2044:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    2048:	3711c101 	ldrcc	ip, [r1, -r1, lsl #2]
    204c:	03000000 	movweq	r0, #0
    2050:	0c7fa491 	cfldrdeq	mvd10, [pc], #-580	; 1e14 <shift+0x1e14>
    2054:	00726662 	rsbseq	r6, r2, r2, ror #12
    2058:	291ac101 	ldmdbcs	sl, {r0, r8, lr, pc}
    205c:	03000002 	movweq	r0, #2
    2060:	157fa091 	ldrbne	sl, [pc, #-145]!	; 1fd7 <shift+0x1fd7>
    2064:	0000176e 	andeq	r1, r0, lr, ror #14
    2068:	8b32c101 	blhi	cb2474 <__bss_end+0xca88f4>
    206c:	03000000 	movweq	r0, #0
    2070:	0e7f9c91 	mrceq	12, 3, r9, cr15, cr1, {4}
    2074:	00001879 	andeq	r1, r0, r9, ror r8
    2078:	840fc301 	strhi	ip, [pc], #-769	; 2080 <shift+0x2080>
    207c:	02000000 	andeq	r0, r0, #0
    2080:	620e7491 	andvs	r7, lr, #-1862270976	; 0x91000000
    2084:	01000018 	tsteq	r0, r8, lsl r0
    2088:	012306d9 	ldrdeq	r0, [r3, -r9]!
    208c:	91020000 	mrsls	r0, (UNDEF: 2)
    2090:	17770e70 			; <UNDEFINED> instruction: 0x17770e70
    2094:	dd010000 	stcle	0, cr0, [r1, #-0]
    2098:	00003e11 	andeq	r3, r0, r1, lsl lr
    209c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    20a0:	0017340e 	andseq	r3, r7, lr, lsl #8
    20a4:	18e00100 	stmiane	r0!, {r8}^
    20a8:	0000008b 	andeq	r0, r0, fp, lsl #1
    20ac:	0e609102 	lgneqs	f1, f2
    20b0:	00001743 	andeq	r1, r0, r3, asr #14
    20b4:	8b18e101 	blhi	63a4c0 <__bss_end+0x630940>
    20b8:	02000000 	andeq	r0, r0, #0
    20bc:	e90e5c91 	stmdb	lr, {r0, r4, r7, sl, fp, ip, lr}
    20c0:	01000017 	tsteq	r0, r7, lsl r0
    20c4:	022f07e3 	eoreq	r0, pc, #59506688	; 0x38c0000
    20c8:	91030000 	mrsls	r0, (UNDEF: 3)
    20cc:	7d0e7fb8 	stcvc	15, cr7, [lr, #-736]	; 0xfffffd20
    20d0:	01000017 	tsteq	r0, r7, lsl r0
    20d4:	012306e5 	smulwteq	r3, r5, r6
    20d8:	91020000 	mrsls	r0, (UNDEF: 2)
    20dc:	96281658 			; <UNDEFINED> instruction: 0x96281658
    20e0:	00500000 	subseq	r0, r0, r0
    20e4:	01f70000 	mvnseq	r0, r0
    20e8:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    20ec:	0be70100 	bleq	ff9c24f4 <__bss_end+0xff9b8974>
    20f0:	00000123 	andeq	r0, r0, r3, lsr #2
    20f4:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    20f8:	0096840f 	addseq	r8, r6, pc, lsl #8
    20fc:	00009800 	andeq	r9, r0, r0, lsl #16
    2100:	17670e00 	strbne	r0, [r7, -r0, lsl #28]!
    2104:	ef010000 	svc	0x00010000
    2108:	00023f08 	andeq	r3, r2, r8, lsl #30
    210c:	ac910300 	ldcge	3, cr0, [r1], {0}
    2110:	96b40f7f 			; <UNDEFINED> instruction: 0x96b40f7f
    2114:	00680000 	rsbeq	r0, r8, r0
    2118:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    211c:	0cf20100 	ldfeqe	f0, [r2]
    2120:	00000123 	andeq	r0, r0, r3, lsr #2
    2124:	00689102 	rsbeq	r9, r8, r2, lsl #2
    2128:	04120000 	ldreq	r0, [r2], #-0
    212c:	00000090 	muleq	r0, r0, r0
    2130:	00009008 	andeq	r9, r0, r8
    2134:	00023f00 	andeq	r3, r2, r0, lsl #30
    2138:	00840900 	addeq	r0, r4, r0, lsl #18
    213c:	001f0000 	andseq	r0, pc, r0
    2140:	00009008 	andeq	r9, r0, r8
    2144:	00024f00 	andeq	r4, r2, r0, lsl #30
    2148:	00840900 	addeq	r0, r4, r0, lsl #18
    214c:	00080000 	andeq	r0, r8, r0
    2150:	00183614 	andseq	r3, r8, r4, lsl r6
    2154:	06bb0100 	ldrteq	r0, [fp], r0, lsl #2
    2158:	00001905 	andeq	r1, r0, r5, lsl #18
    215c:	000093ec 	andeq	r9, r0, ip, ror #7
    2160:	00000030 	andeq	r0, r0, r0, lsr r0
    2164:	02869c01 	addeq	r9, r6, #256	; 0x100
    2168:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    216c:	11bb0100 			; <UNDEFINED> instruction: 0x11bb0100
    2170:	00000037 	andeq	r0, r0, r7, lsr r0
    2174:	0c749102 	ldfeqp	f1, [r4], #-8
    2178:	00726662 	rsbseq	r6, r2, r2, ror #12
    217c:	291abb01 	ldmdbcs	sl, {r0, r8, r9, fp, ip, sp, pc}
    2180:	02000002 	andeq	r0, r0, #2
    2184:	0b007091 	bleq	1e3d0 <__bss_end+0x14850>
    2188:	0000173d 	andeq	r1, r0, sp, lsr r7
    218c:	f406b501 	vst3.8	{d11,d13,d15}, [r6], r1
    2190:	b2000017 	andlt	r0, r0, #23
    2194:	ac000002 	stcge	0, cr0, [r0], {2}
    2198:	40000093 	mulmi	r0, r3, r0
    219c:	01000000 	mrseq	r0, (UNDEF: 0)
    21a0:	0002b29c 	muleq	r2, ip, r2
    21a4:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    21a8:	3712b501 	ldrcc	fp, [r2, -r1, lsl #10]
    21ac:	02000000 	andeq	r0, r0, #0
    21b0:	03007491 	movweq	r7, #1169	; 0x491
    21b4:	0b060201 	bleq	1829c0 <__bss_end+0x178e40>
    21b8:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
    21bc:	01000017 	tsteq	r0, r7, lsl r0
    21c0:	17b106b0 			; <UNDEFINED> instruction: 0x17b106b0
    21c4:	02b20000 	adcseq	r0, r2, #0
    21c8:	93700000 	cmnls	r0, #0
    21cc:	003c0000 	eorseq	r0, ip, r0
    21d0:	9c010000 	stcls	0, cr0, [r1], {-0}
    21d4:	000002e5 	andeq	r0, r0, r5, ror #5
    21d8:	0100780c 	tsteq	r0, ip, lsl #16
    21dc:	003712b0 	ldrhteq	r1, [r7], -r0
    21e0:	91020000 	mrsls	r0, (UNDEF: 2)
    21e4:	ed140074 	ldc	0, cr0, [r4, #-464]	; 0xfffffe30
    21e8:	01000018 	tsteq	r0, r8, lsl r0
    21ec:	183b06a5 	ldmdane	fp!, {r0, r2, r5, r7, r9, sl}
    21f0:	929c0000 	addsls	r0, ip, #0
    21f4:	00d40000 	sbcseq	r0, r4, r0
    21f8:	9c010000 	stcls	0, cr0, [r1], {-0}
    21fc:	0000033a 	andeq	r0, r0, sl, lsr r3
    2200:	0100780c 	tsteq	r0, ip, lsl #16
    2204:	00842ba5 	addeq	r2, r4, r5, lsr #23
    2208:	91020000 	mrsls	r0, (UNDEF: 2)
    220c:	66620c6c 	strbtvs	r0, [r2], -ip, ror #24
    2210:	a5010072 	strge	r0, [r1, #-114]	; 0xffffff8e
    2214:	00022934 	andeq	r2, r2, r4, lsr r9
    2218:	68910200 	ldmvs	r1, {r9}
    221c:	00188715 	andseq	r8, r8, r5, lsl r7
    2220:	3da50100 	stfccs	f0, [r5]
    2224:	00000123 	andeq	r0, r0, r3, lsr #2
    2228:	0e649102 	lgneqs	f1, f2
    222c:	00001879 	andeq	r1, r0, r9, ror r8
    2230:	2306a701 	movwcs	sl, #26369	; 0x6701
    2234:	02000001 	andeq	r0, r0, #1
    2238:	17007491 			; <UNDEFINED> instruction: 0x17007491
    223c:	000018ac 	andeq	r1, r0, ip, lsr #17
    2240:	07068301 	streq	r8, [r6, -r1, lsl #6]
    2244:	5c000018 	stcpl	0, cr0, [r0], {24}
    2248:	4000008e 	andmi	r0, r0, lr, lsl #1
    224c:	01000004 	tsteq	r0, r4
    2250:	00039e9c 	muleq	r3, ip, lr
    2254:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    2258:	37188301 	ldrcc	r8, [r8, -r1, lsl #6]
    225c:	02000000 	andeq	r0, r0, #0
    2260:	34156c91 	ldrcc	r6, [r5], #-3217	; 0xfffff36f
    2264:	01000017 	tsteq	r0, r7, lsl r0
    2268:	039e2983 	orrseq	r2, lr, #2146304	; 0x20c000
    226c:	91020000 	mrsls	r0, (UNDEF: 2)
    2270:	17431568 	strbne	r1, [r3, -r8, ror #10]
    2274:	83010000 	movwhi	r0, #4096	; 0x1000
    2278:	00039e41 	andeq	r9, r3, r1, asr #28
    227c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2280:	00178c15 	andseq	r8, r7, r5, lsl ip
    2284:	4f830100 	svcmi	0x00830100
    2288:	000003a4 	andeq	r0, r0, r4, lsr #7
    228c:	0e609102 	lgneqs	f1, f2
    2290:	00001724 	andeq	r1, r0, r4, lsr #14
    2294:	370b9601 	strcc	r9, [fp, -r1, lsl #12]
    2298:	02000000 	andeq	r0, r0, #0
    229c:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    22a0:	00008404 	andeq	r8, r0, r4, lsl #8
    22a4:	23041800 	movwcs	r1, #18432	; 0x4800
    22a8:	14000001 	strne	r0, [r0], #-1
    22ac:	00001925 	andeq	r1, r0, r5, lsr #18
    22b0:	a5067601 	strge	r7, [r6, #-1537]	; 0xfffff9ff
    22b4:	98000017 	stmdals	r0, {r0, r1, r2, r4}
    22b8:	c400008d 	strgt	r0, [r0], #-141	; 0xffffff73
    22bc:	01000000 	mrseq	r0, (UNDEF: 0)
    22c0:	0003ff9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
    22c4:	17e41500 	strbne	r1, [r4, r0, lsl #10]!
    22c8:	76010000 	strvc	r0, [r1], -r0
    22cc:	00022913 	andeq	r2, r2, r3, lsl r9
    22d0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    22d4:	0100690d 	tsteq	r0, sp, lsl #18
    22d8:	01230978 			; <UNDEFINED> instruction: 0x01230978
    22dc:	91020000 	mrsls	r0, (UNDEF: 2)
    22e0:	656c0d74 	strbvs	r0, [ip, #-3444]!	; 0xfffff28c
    22e4:	7801006e 	stmdavc	r1, {r1, r2, r3, r5, r6}
    22e8:	0001230c 	andeq	r2, r1, ip, lsl #6
    22ec:	70910200 	addsvc	r0, r1, r0, lsl #4
    22f0:	0017c60e 	andseq	ip, r7, lr, lsl #12
    22f4:	11780100 	cmnne	r8, r0, lsl #2
    22f8:	00000123 	andeq	r0, r0, r3, lsr #2
    22fc:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    2300:	776f7019 			; <UNDEFINED> instruction: 0x776f7019
    2304:	076d0100 	strbeq	r0, [sp, -r0, lsl #2]!
    2308:	000017fe 	strdeq	r1, [r0], -lr
    230c:	00000037 	andeq	r0, r0, r7, lsr r0
    2310:	00008d2c 	andeq	r8, r0, ip, lsr #26
    2314:	0000006c 	andeq	r0, r0, ip, rrx
    2318:	045c9c01 	ldrbeq	r9, [ip], #-3073	; 0xfffff3ff
    231c:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2320:	176d0100 	strbne	r0, [sp, -r0, lsl #2]!
    2324:	0000003e 	andeq	r0, r0, lr, lsr r0
    2328:	0c6c9102 	stfeqp	f1, [ip], #-8
    232c:	6d01006e 	stcvs	0, cr0, [r1, #-440]	; 0xfffffe48
    2330:	00008b2d 	andeq	r8, r0, sp, lsr #22
    2334:	68910200 	ldmvs	r1, {r9}
    2338:	0100720d 	tsteq	r0, sp, lsl #4
    233c:	00370b6f 	eorseq	r0, r7, pc, ror #22
    2340:	91020000 	mrsls	r0, (UNDEF: 2)
    2344:	8d480f74 	stclhi	15, cr0, [r8, #-464]	; 0xfffffe30
    2348:	00380000 	eorseq	r0, r8, r0
    234c:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    2350:	16700100 	ldrbtne	r0, [r0], -r0, lsl #2
    2354:	00000084 	andeq	r0, r0, r4, lsl #1
    2358:	00709102 	rsbseq	r9, r0, r2, lsl #2
    235c:	18721700 	ldmdane	r2!, {r8, r9, sl, ip}^
    2360:	64010000 	strvs	r0, [r1], #-0
    2364:	0016da06 	andseq	sp, r6, r6, lsl #20
    2368:	008cac00 	addeq	sl, ip, r0, lsl #24
    236c:	00008000 	andeq	r8, r0, r0
    2370:	d99c0100 	ldmible	ip, {r8}
    2374:	0c000004 	stceq	0, cr0, [r0], {4}
    2378:	00637273 	rsbeq	r7, r3, r3, ror r2
    237c:	d9196401 	ldmdble	r9, {r0, sl, sp, lr}
    2380:	02000004 	andeq	r0, r0, #4
    2384:	640c6491 	strvs	r6, [ip], #-1169	; 0xfffffb6f
    2388:	01007473 	tsteq	r0, r3, ror r4
    238c:	04e02464 	strbteq	r2, [r0], #1124	; 0x464
    2390:	91020000 	mrsls	r0, (UNDEF: 2)
    2394:	756e0c60 	strbvc	r0, [lr, #-3168]!	; 0xfffff3a0
    2398:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    239c:	0001232d 	andeq	r2, r1, sp, lsr #6
    23a0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    23a4:	00185b0e 	andseq	r5, r8, lr, lsl #22
    23a8:	0e660100 	poweqs	f0, f6, f0
    23ac:	0000011d 	andeq	r0, r0, sp, lsl r1
    23b0:	0e709102 	expeqs	f1, f2
    23b4:	00001823 	andeq	r1, r0, r3, lsr #16
    23b8:	29086701 	stmdbcs	r8, {r0, r8, r9, sl, sp, lr}
    23bc:	02000002 	andeq	r0, r0, #2
    23c0:	d40f6c91 	strle	r6, [pc], #-3217	; 23c8 <shift+0x23c8>
    23c4:	4800008c 	stmdami	r0, {r2, r3, r7}
    23c8:	0d000000 	stceq	0, cr0, [r0, #-0]
    23cc:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    23d0:	0001230b 	andeq	r2, r1, fp, lsl #6
    23d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    23d8:	04120000 	ldreq	r0, [r2], #-0
    23dc:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    23e0:	17041b1a 	smladne	r4, sl, fp, r1
    23e4:	0000186c 	andeq	r1, r0, ip, ror #16
    23e8:	cb065c01 	blgt	1993f4 <__bss_end+0x18f874>
    23ec:	44000017 	strmi	r0, [r0], #-23	; 0xffffffe9
    23f0:	6800008c 	stmdavs	r0, {r2, r3, r7}
    23f4:	01000000 	mrseq	r0, (UNDEF: 0)
    23f8:	0005419c 	muleq	r5, ip, r1
    23fc:	19101500 	ldmdbne	r0, {r8, sl, ip}
    2400:	5c010000 	stcpl	0, cr0, [r1], {-0}
    2404:	0004e012 	andeq	lr, r4, r2, lsl r0
    2408:	6c910200 	lfmvs	f0, 4, [r1], {0}
    240c:	00191715 	andseq	r1, r9, r5, lsl r7
    2410:	1e5c0100 	rdfnee	f0, f4, f0
    2414:	00000123 	andeq	r0, r0, r3, lsr #2
    2418:	0d689102 	stfeqp	f1, [r8, #-8]!
    241c:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2420:	29085e01 	stmdbcs	r8, {r0, r9, sl, fp, ip, lr}
    2424:	02000002 	andeq	r0, r0, #2
    2428:	600f7091 	mulvs	pc, r1, r0	; <UNPREDICTABLE>
    242c:	3c00008c 	stccc	0, cr0, [r0], {140}	; 0x8c
    2430:	0d000000 	stceq	0, cr0, [r0, #-0]
    2434:	60010069 	andvs	r0, r1, r9, rrx
    2438:	0001230b 	andeq	r2, r1, fp, lsl #6
    243c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2440:	1e0b0000 	cdpne	0, 0, cr0, cr11, cr0, {0}
    2444:	01000019 	tsteq	r0, r9, lsl r0
    2448:	18bd0552 	popne	{r1, r4, r6, r8, sl}
    244c:	01230000 			; <UNDEFINED> instruction: 0x01230000
    2450:	8bf00000 	blhi	ffc02458 <__bss_end+0xffbf88d8>
    2454:	00540000 	subseq	r0, r4, r0
    2458:	9c010000 	stcls	0, cr0, [r1], {-0}
    245c:	0000057a 	andeq	r0, r0, sl, ror r5
    2460:	0100730c 	tsteq	r0, ip, lsl #6
    2464:	011d1852 	tsteq	sp, r2, asr r8
    2468:	91020000 	mrsls	r0, (UNDEF: 2)
    246c:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    2470:	23065401 	movwcs	r5, #25601	; 0x6401
    2474:	02000001 	andeq	r0, r0, #1
    2478:	0b007491 	bleq	1f6c4 <__bss_end+0x15b44>
    247c:	0000187f 	andeq	r1, r0, pc, ror r8
    2480:	ca054201 	bgt	152c8c <__bss_end+0x14910c>
    2484:	23000018 	movwcs	r0, #24
    2488:	44000001 	strmi	r0, [r0], #-1
    248c:	ac00008b 	stcge	0, cr0, [r0], {139}	; 0x8b
    2490:	01000000 	mrseq	r0, (UNDEF: 0)
    2494:	0005e09c 	muleq	r5, ip, r0
    2498:	31730c00 	cmncc	r3, r0, lsl #24
    249c:	19420100 	stmdbne	r2, {r8}^
    24a0:	0000011d 	andeq	r0, r0, sp, lsl r1
    24a4:	0c6c9102 	stfeqp	f1, [ip], #-8
    24a8:	01003273 	tsteq	r0, r3, ror r2
    24ac:	011d2942 	tsteq	sp, r2, asr #18
    24b0:	91020000 	mrsls	r0, (UNDEF: 2)
    24b4:	756e0c68 	strbvc	r0, [lr, #-3176]!	; 0xfffff398
    24b8:	4201006d 	andmi	r0, r1, #109	; 0x6d
    24bc:	00012331 	andeq	r2, r1, r1, lsr r3
    24c0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    24c4:	0031750d 	eorseq	r7, r1, sp, lsl #10
    24c8:	e0104401 	ands	r4, r0, r1, lsl #8
    24cc:	02000005 	andeq	r0, r0, #5
    24d0:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    24d4:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    24d8:	0005e014 	andeq	lr, r5, r4, lsl r0
    24dc:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    24e0:	08010300 	stmdaeq	r1, {r8, r9}
    24e4:	0000101b 	andeq	r1, r0, fp, lsl r0
    24e8:	0017d70b 	andseq	sp, r7, fp, lsl #14
    24ec:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    24f0:	000018dc 	ldrdeq	r1, [r0], -ip
    24f4:	00000229 	andeq	r0, r0, r9, lsr #4
    24f8:	00008a84 	andeq	r8, r0, r4, lsl #21
    24fc:	000000c0 	andeq	r0, r0, r0, asr #1
    2500:	06409c01 	strbeq	r9, [r0], -r1, lsl #24
    2504:	a0150000 	andsge	r0, r5, r0
    2508:	01000017 	tsteq	r0, r7, lsl r0
    250c:	02291536 	eoreq	r1, r9, #226492416	; 0xd800000
    2510:	91020000 	mrsls	r0, (UNDEF: 2)
    2514:	72730c6c 	rsbsvc	r0, r3, #108, 24	; 0x6c00
    2518:	36010063 	strcc	r0, [r1], -r3, rrx
    251c:	00011d27 	andeq	r1, r1, r7, lsr #26
    2520:	68910200 	ldmvs	r1, {r9}
    2524:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    2528:	30360100 	eorscc	r0, r6, r0, lsl #2
    252c:	00000123 	andeq	r0, r0, r3, lsr #2
    2530:	0d649102 	stfeqp	f1, [r4, #-8]!
    2534:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    2538:	00012306 	andeq	r2, r1, r6, lsl #6
    253c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2540:	17570b00 	ldrbne	r0, [r7, -r0, lsl #22]
    2544:	24010000 	strcs	r0, [r1], #-0
    2548:	00188e05 	andseq	r8, r8, r5, lsl #28
    254c:	00012300 	andeq	r2, r1, r0, lsl #6
    2550:	0089e800 	addeq	lr, r9, r0, lsl #16
    2554:	00009c00 	andeq	r9, r0, r0, lsl #24
    2558:	7d9c0100 	ldfvcs	f0, [ip]
    255c:	15000006 	strne	r0, [r0, #-6]
    2560:	000017bb 			; <UNDEFINED> instruction: 0x000017bb
    2564:	1d162401 	cfldrsne	mvf2, [r6, #-4]
    2568:	02000001 	andeq	r0, r0, #1
    256c:	990e6c91 	stmdbls	lr, {r0, r4, r7, sl, fp, sp, lr}
    2570:	01000018 	tsteq	r0, r8, lsl r0
    2574:	01230626 			; <UNDEFINED> instruction: 0x01230626
    2578:	91020000 	mrsls	r0, (UNDEF: 2)
    257c:	df1c0074 	svcle	0x001c0074
    2580:	01000017 	tsteq	r0, r7, lsl r0
    2584:	174b0608 	strbne	r0, [fp, -r8, lsl #12]
    2588:	88740000 	ldmdahi	r4!, {}^	; <UNPREDICTABLE>
    258c:	01740000 	cmneq	r4, r0
    2590:	9c010000 	stcls	0, cr0, [r1], {-0}
    2594:	0017bb15 	andseq	fp, r7, r5, lsl fp
    2598:	18080100 	stmdane	r8, {r8}
    259c:	00000084 	andeq	r0, r0, r4, lsl #1
    25a0:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    25a4:	00001899 	muleq	r0, r9, r8
    25a8:	29250801 	stmdbcs	r5!, {r0, fp}
    25ac:	02000002 	andeq	r0, r0, #2
    25b0:	c1156091 			; <UNDEFINED> instruction: 0xc1156091
    25b4:	01000017 	tsteq	r0, r7, lsl r0
    25b8:	00843a08 	addeq	r3, r4, r8, lsl #20
    25bc:	91020000 	mrsls	r0, (UNDEF: 2)
    25c0:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    25c4:	23060a01 	movwcs	r0, #27137	; 0x6a01
    25c8:	02000001 	andeq	r0, r0, #1
    25cc:	400f7491 	mulmi	pc, r1, r4	; <UNPREDICTABLE>
    25d0:	98000089 	stmdals	r0, {r0, r3, r7}
    25d4:	0d000000 	stceq	0, cr0, [r0, #-0]
    25d8:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    25dc:	0001230b 	andeq	r2, r1, fp, lsl #6
    25e0:	70910200 	addsvc	r0, r1, r0, lsl #4
    25e4:	0089680f 	addeq	r6, r9, pc, lsl #16
    25e8:	00006000 	andeq	r6, r0, r0
    25ec:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    25f0:	90081e01 	andls	r1, r8, r1, lsl #28
    25f4:	02000000 	andeq	r0, r0, #0
    25f8:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    25fc:	00220000 	eoreq	r0, r2, r0
    2600:	00020000 	andeq	r0, r2, r0
    2604:	000008e8 	andeq	r0, r0, r8, ror #17
    2608:	0dc90104 	stfeqe	f0, [r9, #16]
    260c:	98500000 	ldmdals	r0, {}^	; <UNPREDICTABLE>
    2610:	9a5c0000 	bls	1702618 <__bss_end+0x16f8a98>
    2614:	192c0000 	stmdbne	ip!, {}	; <UNPREDICTABLE>
    2618:	195c0000 	ldmdbne	ip, {}^	; <UNPREDICTABLE>
    261c:	00630000 	rsbeq	r0, r3, r0
    2620:	80010000 	andhi	r0, r1, r0
    2624:	00000022 	andeq	r0, r0, r2, lsr #32
    2628:	08fc0002 	ldmeq	ip!, {r1}^
    262c:	01040000 	mrseq	r0, (UNDEF: 4)
    2630:	00000e46 	andeq	r0, r0, r6, asr #28
    2634:	00009a5c 	andeq	r9, r0, ip, asr sl
    2638:	00009a60 	andeq	r9, r0, r0, ror #20
    263c:	0000192c 	andeq	r1, r0, ip, lsr #18
    2640:	0000195c 	andeq	r1, r0, ip, asr r9
    2644:	00000063 	andeq	r0, r0, r3, rrx
    2648:	09328001 	ldmdbeq	r2!, {r0, pc}
    264c:	00040000 	andeq	r0, r4, r0
    2650:	00000910 	andeq	r0, r0, r0, lsl r9
    2654:	1d2a0104 	stfnes	f0, [sl, #-16]!
    2658:	810c0000 	mrshi	r0, (UNDEF: 12)
    265c:	5c00001c 	stcpl	0, cr0, [r0], {28}
    2660:	a6000019 			; <UNDEFINED> instruction: 0xa6000019
    2664:	0200000e 	andeq	r0, r0, #14
    2668:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    266c:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2670:	00076b07 	andeq	r6, r7, r7, lsl #22
    2674:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    2678:	0000031f 	andeq	r0, r0, pc, lsl r3
    267c:	12040803 	andne	r0, r4, #196608	; 0x30000
    2680:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    2684:	00001cdc 	ldrdeq	r1, [r0], -ip
    2688:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    268c:	04000000 	streq	r0, [r0], #-0
    2690:	00002134 	andeq	r2, r0, r4, lsr r1
    2694:	51152f01 	tstpl	r5, r1, lsl #30
    2698:	05000000 	streq	r0, [r0, #-0]
    269c:	00005704 	andeq	r5, r0, r4, lsl #14
    26a0:	00390600 	eorseq	r0, r9, r0, lsl #12
    26a4:	00660000 	rsbeq	r0, r6, r0
    26a8:	66070000 	strvs	r0, [r7], -r0
    26ac:	00000000 	andeq	r0, r0, r0
    26b0:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    26b4:	04080000 	streq	r0, [r8], #-0
    26b8:	00002866 	andeq	r2, r0, r6, ror #16
    26bc:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    26c0:	05000000 	streq	r0, [r0, #-0]
    26c4:	00007f04 	andeq	r7, r0, r4, lsl #30
    26c8:	001d0600 	andseq	r0, sp, r0, lsl #12
    26cc:	00930000 	addseq	r0, r3, r0
    26d0:	66070000 	strvs	r0, [r7], -r0
    26d4:	07000000 	streq	r0, [r0, -r0]
    26d8:	00000066 	andeq	r0, r0, r6, rrx
    26dc:	08010300 	stmdaeq	r1, {r8, r9}
    26e0:	0000101b 	andeq	r1, r0, fp, lsl r0
    26e4:	00236c09 	eoreq	r6, r3, r9, lsl #24
    26e8:	12bb0100 	adcsne	r0, fp, #0, 2
    26ec:	00000045 	andeq	r0, r0, r5, asr #32
    26f0:	00289409 	eoreq	r9, r8, r9, lsl #8
    26f4:	10be0100 	adcsne	r0, lr, r0, lsl #2
    26f8:	0000006d 	andeq	r0, r0, sp, rrx
    26fc:	1d060103 	stfnes	f0, [r6, #-12]
    2700:	0a000010 	beq	2748 <shift+0x2748>
    2704:	00002054 	andeq	r2, r0, r4, asr r0
    2708:	00930107 	addseq	r0, r3, r7, lsl #2
    270c:	17020000 	strne	r0, [r2, -r0]
    2710:	0001e606 	andeq	lr, r1, r6, lsl #12
    2714:	1b3a0b00 	blne	e8531c <__bss_end+0xe7b79c>
    2718:	0b000000 	bleq	2720 <shift+0x2720>
    271c:	00001f71 	andeq	r1, r0, r1, ror pc
    2720:	24370b01 	ldrtcs	r0, [r7], #-2817	; 0xfffff4ff
    2724:	0b020000 	bleq	8272c <__bss_end+0x78bac>
    2728:	000027a8 	andeq	r2, r0, r8, lsr #15
    272c:	23db0b03 	bicscs	r0, fp, #3072	; 0xc00
    2730:	0b040000 	bleq	102738 <__bss_end+0xf8bb8>
    2734:	000026b1 			; <UNDEFINED> instruction: 0x000026b1
    2738:	26150b05 	ldrcs	r0, [r5], -r5, lsl #22
    273c:	0b060000 	bleq	182744 <__bss_end+0x178bc4>
    2740:	00001b5b 	andeq	r1, r0, fp, asr fp
    2744:	26c60b07 	strbcs	r0, [r6], r7, lsl #22
    2748:	0b080000 	bleq	202750 <__bss_end+0x1f8bd0>
    274c:	000026d4 	ldrdeq	r2, [r0], -r4
    2750:	279b0b09 	ldrcs	r0, [fp, r9, lsl #22]
    2754:	0b0a0000 	bleq	28275c <__bss_end+0x278bdc>
    2758:	00002332 	andeq	r2, r0, r2, lsr r3
    275c:	1d1d0b0b 	vldrne	d0, [sp, #-44]	; 0xffffffd4
    2760:	0b0c0000 	bleq	302768 <__bss_end+0x2f8be8>
    2764:	00001dfa 	strdeq	r1, [r0], -sl
    2768:	20980b0d 	addscs	r0, r8, sp, lsl #22
    276c:	0b0e0000 	bleq	382774 <__bss_end+0x378bf4>
    2770:	000020ae 	andeq	r2, r0, lr, lsr #1
    2774:	1fab0b0f 	svcne	0x00ab0b0f
    2778:	0b100000 	bleq	402780 <__bss_end+0x3f8c00>
    277c:	000023bf 			; <UNDEFINED> instruction: 0x000023bf
    2780:	20170b11 	andscs	r0, r7, r1, lsl fp
    2784:	0b120000 	bleq	48278c <__bss_end+0x478c0c>
    2788:	00002a2d 	andeq	r2, r0, sp, lsr #20
    278c:	1bc40b13 	blne	ff1053e0 <__bss_end+0xff0fb860>
    2790:	0b140000 	bleq	502798 <__bss_end+0x4f8c18>
    2794:	0000203b 	andeq	r2, r0, fp, lsr r0
    2798:	1b010b15 	blne	453f4 <__bss_end+0x3b874>
    279c:	0b160000 	bleq	5827a4 <__bss_end+0x578c24>
    27a0:	000027cb 	andeq	r2, r0, fp, asr #15
    27a4:	28ed0b17 	stmiacs	sp!, {r0, r1, r2, r4, r8, r9, fp}^
    27a8:	0b180000 	bleq	6027b0 <__bss_end+0x5f8c30>
    27ac:	00002060 	andeq	r2, r0, r0, rrx
    27b0:	24a90b19 	strtcs	r0, [r9], #2841	; 0xb19
    27b4:	0b1a0000 	bleq	6827bc <__bss_end+0x678c3c>
    27b8:	000027d9 	ldrdeq	r2, [r0], -r9
    27bc:	1a300b1b 	bne	c05430 <__bss_end+0xbfb8b0>
    27c0:	0b1c0000 	bleq	7027c8 <__bss_end+0x6f8c48>
    27c4:	000027e7 	andeq	r2, r0, r7, ror #15
    27c8:	27f50b1d 			; <UNDEFINED> instruction: 0x27f50b1d
    27cc:	0b1e0000 	bleq	7827d4 <__bss_end+0x778c54>
    27d0:	000019de 	ldrdeq	r1, [r0], -lr
    27d4:	281f0b1f 	ldmdacs	pc, {r0, r1, r2, r3, r4, r8, r9, fp}	; <UNPREDICTABLE>
    27d8:	0b200000 	bleq	8027e0 <__bss_end+0x7f8c60>
    27dc:	00002556 	andeq	r2, r0, r6, asr r5
    27e0:	23910b21 	orrscs	r0, r1, #33792	; 0x8400
    27e4:	0b220000 	bleq	8827ec <__bss_end+0x878c6c>
    27e8:	000027be 			; <UNDEFINED> instruction: 0x000027be
    27ec:	22950b23 	addscs	r0, r5, #35840	; 0x8c00
    27f0:	0b240000 	bleq	9027f8 <__bss_end+0x8f8c78>
    27f4:	00002197 	muleq	r0, r7, r1
    27f8:	1eb10b25 			; <UNDEFINED> instruction: 0x1eb10b25
    27fc:	0b260000 	bleq	982804 <__bss_end+0x978c84>
    2800:	000021b5 			; <UNDEFINED> instruction: 0x000021b5
    2804:	1f4d0b27 	svcne	0x004d0b27
    2808:	0b280000 	bleq	a02810 <__bss_end+0x9f8c90>
    280c:	000021c5 	andeq	r2, r0, r5, asr #3
    2810:	21d50b29 	bicscs	r0, r5, r9, lsr #22
    2814:	0b2a0000 	bleq	a8281c <__bss_end+0xa78c9c>
    2818:	00002318 	andeq	r2, r0, r8, lsl r3
    281c:	213e0b2b 	teqcs	lr, fp, lsr #22
    2820:	0b2c0000 	bleq	b02828 <__bss_end+0xaf8ca8>
    2824:	00002563 	andeq	r2, r0, r3, ror #10
    2828:	1ef20b2d 			; <UNDEFINED> instruction: 0x1ef20b2d
    282c:	002e0000 	eoreq	r0, lr, r0
    2830:	0020d00a 	eoreq	sp, r0, sl
    2834:	93010700 	movwls	r0, #5888	; 0x1700
    2838:	03000000 	movweq	r0, #0
    283c:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    2840:	1c0b0000 	stcne	0, cr0, [fp], {-0}
    2844:	0000001e 	andeq	r0, r0, lr, lsl r0
    2848:	001a6e0b 	andseq	r6, sl, fp, lsl #28
    284c:	db0b0100 	blle	2c2c54 <__bss_end+0x2b90d4>
    2850:	02000029 	andeq	r0, r0, #41	; 0x29
    2854:	00286e0b 	eoreq	r6, r8, fp, lsl #28
    2858:	3c0b0300 	stccc	3, cr0, [fp], {-0}
    285c:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    2860:	001b260b 	andseq	r2, fp, fp, lsl #12
    2864:	ce0b0500 	cfsh32gt	mvfx0, mvfx11, #0
    2868:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    286c:	001e2c0b 	andseq	r2, lr, fp, lsl #24
    2870:	020b0700 	andeq	r0, fp, #0, 14
    2874:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    2878:	0028530b 	eoreq	r5, r8, fp, lsl #6
    287c:	390b0900 	stmdbcc	fp, {r8, fp}
    2880:	0a000026 	beq	2920 <shift+0x2920>
    2884:	001b790b 	andseq	r7, fp, fp, lsl #18
    2888:	6f0b0b00 	svcvs	0x000b0b00
    288c:	0c00001e 	stceq	0, cr0, [r0], {30}
    2890:	001aef0b 	andseq	lr, sl, fp, lsl #30
    2894:	100b0d00 	andne	r0, fp, r0, lsl #26
    2898:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    289c:	0023050b 	eoreq	r0, r3, fp, lsl #10
    28a0:	e20b0f00 	and	r0, fp, #0, 30
    28a4:	1000001f 	andne	r0, r0, pc, lsl r0
    28a8:	0023420b 	eoreq	r4, r3, fp, lsl #4
    28ac:	2f0b1100 	svccs	0x000b1100
    28b0:	12000029 	andne	r0, r0, #41	; 0x29
    28b4:	001c3c0b 	andseq	r3, ip, fp, lsl #24
    28b8:	f50b1300 			; <UNDEFINED> instruction: 0xf50b1300
    28bc:	1400001f 	strne	r0, [r0], #-31	; 0xffffffe1
    28c0:	0022580b 	eoreq	r5, r2, fp, lsl #16
    28c4:	070b1500 	streq	r1, [fp, -r0, lsl #10]
    28c8:	1600001e 			; <UNDEFINED> instruction: 0x1600001e
    28cc:	0022a40b 	eoreq	sl, r2, fp, lsl #8
    28d0:	ba0b1700 	blt	2c84d8 <__bss_end+0x2be958>
    28d4:	18000020 	stmdane	r0, {r5}
    28d8:	001b440b 	andseq	r4, fp, fp, lsl #8
    28dc:	d60b1900 	strle	r1, [fp], -r0, lsl #18
    28e0:	1a000028 	bne	2988 <shift+0x2988>
    28e4:	0022240b 	eoreq	r2, r2, fp, lsl #8
    28e8:	cc0b1b00 			; <UNDEFINED> instruction: 0xcc0b1b00
    28ec:	1c00001f 	stcne	0, cr0, [r0], {31}
    28f0:	001a190b 	andseq	r1, sl, fp, lsl #18
    28f4:	6f0b1d00 	svcvs	0x000b1d00
    28f8:	1e000021 	cdpne	0, 0, cr0, cr0, cr1, {1}
    28fc:	00215b0b 	eoreq	r5, r1, fp, lsl #22
    2900:	f60b1f00 			; <UNDEFINED> instruction: 0xf60b1f00
    2904:	20000025 	andcs	r0, r0, r5, lsr #32
    2908:	0026810b 	eoreq	r8, r6, fp, lsl #2
    290c:	b50b2100 	strlt	r2, [fp, #-256]	; 0xffffff00
    2910:	22000028 	andcs	r0, r0, #40	; 0x28
    2914:	001eff0b 	andseq	pc, lr, fp, lsl #30
    2918:	590b2300 	stmdbpl	fp, {r8, r9, sp}
    291c:	24000024 	strcs	r0, [r0], #-36	; 0xffffffdc
    2920:	00264e0b 	eoreq	r4, r6, fp, lsl #28
    2924:	720b2500 	andvc	r2, fp, #0, 10
    2928:	26000025 	strcs	r0, [r0], -r5, lsr #32
    292c:	0025860b 	eoreq	r8, r5, fp, lsl #12
    2930:	9a0b2700 	bls	2cc538 <__bss_end+0x2c29b8>
    2934:	28000025 	stmdacs	r0, {r0, r2, r5}
    2938:	001cc70b 	andseq	ip, ip, fp, lsl #14
    293c:	270b2900 	strcs	r2, [fp, -r0, lsl #18]
    2940:	2a00001c 	bcs	29b8 <shift+0x29b8>
    2944:	001c4f0b 	andseq	r4, ip, fp, lsl #30
    2948:	4b0b2b00 	blmi	2cd550 <__bss_end+0x2c39d0>
    294c:	2c000027 	stccs	0, cr0, [r0], {39}	; 0x27
    2950:	001ca40b 	andseq	sl, ip, fp, lsl #8
    2954:	5f0b2d00 	svcpl	0x000b2d00
    2958:	2e000027 	cdpcs	0, 0, cr0, cr0, cr7, {1}
    295c:	0027730b 	eoreq	r7, r7, fp, lsl #6
    2960:	870b2f00 	strhi	r2, [fp, -r0, lsl #30]
    2964:	30000027 	andcc	r0, r0, r7, lsr #32
    2968:	001e810b 	andseq	r8, lr, fp, lsl #2
    296c:	5b0b3100 	blpl	2ced74 <__bss_end+0x2c51f4>
    2970:	3200001e 	andcc	r0, r0, #30
    2974:	0021830b 	eoreq	r8, r1, fp, lsl #6
    2978:	550b3300 	strpl	r3, [fp, #-768]	; 0xfffffd00
    297c:	34000023 	strcc	r0, [r0], #-35	; 0xffffffdd
    2980:	0029640b 	eoreq	r6, r9, fp, lsl #8
    2984:	c10b3500 	tstgt	fp, r0, lsl #10
    2988:	36000019 			; <UNDEFINED> instruction: 0x36000019
    298c:	001f810b 	andseq	r8, pc, fp, lsl #2
    2990:	960b3700 	strls	r3, [fp], -r0, lsl #14
    2994:	3800001f 	stmdacc	r0, {r0, r1, r2, r3, r4}
    2998:	0021e50b 	eoreq	lr, r1, fp, lsl #10
    299c:	0f0b3900 	svceq	0x000b3900
    29a0:	3a000022 	bcc	2a30 <shift+0x2a30>
    29a4:	00298d0b 	eoreq	r8, r9, fp, lsl #26
    29a8:	440b3b00 	strmi	r3, [fp], #-2816	; 0xfffff500
    29ac:	3c000024 	stccc	0, cr0, [r0], {36}	; 0x24
    29b0:	001f240b 	andseq	r2, pc, fp, lsl #8
    29b4:	800b3d00 	andhi	r3, fp, r0, lsl #26
    29b8:	3e00001a 	mcrcc	0, 0, r0, cr0, cr10, {0}
    29bc:	001a3e0b 	andseq	r3, sl, fp, lsl #28
    29c0:	a10b3f00 	tstge	fp, r0, lsl #30
    29c4:	40000023 	andmi	r0, r0, r3, lsr #32
    29c8:	0024c50b 	eoreq	ip, r4, fp, lsl #10
    29cc:	d80b4100 	stmdale	fp, {r8, lr}
    29d0:	42000025 	andmi	r0, r0, #37	; 0x25
    29d4:	0021fa0b 	eoreq	pc, r1, fp, lsl #20
    29d8:	c60b4300 	strgt	r4, [fp], -r0, lsl #6
    29dc:	44000029 	strmi	r0, [r0], #-41	; 0xffffffd7
    29e0:	00246f0b 	eoreq	r6, r4, fp, lsl #30
    29e4:	6b0b4500 	blvs	2d3dec <__bss_end+0x2ca26c>
    29e8:	4600001c 			; <UNDEFINED> instruction: 0x4600001c
    29ec:	0022d50b 	eoreq	sp, r2, fp, lsl #10
    29f0:	080b4700 	stmdaeq	fp, {r8, r9, sl, lr}
    29f4:	48000021 	stmdami	r0, {r0, r5}
    29f8:	0019fd0b 	andseq	pc, r9, fp, lsl #26
    29fc:	110b4900 	tstne	fp, r0, lsl #18
    2a00:	4a00001b 	bmi	2a74 <shift+0x2a74>
    2a04:	001f380b 	andseq	r3, pc, fp, lsl #16
    2a08:	360b4b00 	strcc	r4, [fp], -r0, lsl #22
    2a0c:	4c000022 	stcmi	0, cr0, [r0], {34}	; 0x22
    2a10:	07020300 	streq	r0, [r2, -r0, lsl #6]
    2a14:	000011b5 			; <UNDEFINED> instruction: 0x000011b5
    2a18:	0003e40c 	andeq	lr, r3, ip, lsl #8
    2a1c:	0003d900 	andeq	sp, r3, r0, lsl #18
    2a20:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2a24:	000003ce 	andeq	r0, r0, lr, asr #7
    2a28:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    2a2c:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    2a30:	03000003 	movweq	r0, #3
    2a34:	10240801 	eorne	r0, r4, r1, lsl #16
    2a38:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    2a3c:	0f000003 	svceq	0x00000003
    2a40:	00001bb5 			; <UNDEFINED> instruction: 0x00001bb5
    2a44:	1a014c04 	bne	55a5c <__bss_end+0x4bedc>
    2a48:	000003d9 	ldrdeq	r0, [r0], -r9
    2a4c:	001fbc0f 	andseq	fp, pc, pc, lsl #24
    2a50:	01820400 	orreq	r0, r2, r0, lsl #8
    2a54:	0003d91a 	andeq	sp, r3, sl, lsl r9
    2a58:	03e90c00 	mvneq	r0, #0, 24
    2a5c:	041a0000 	ldreq	r0, [sl], #-0
    2a60:	000d0000 	andeq	r0, sp, r0
    2a64:	0021a709 	eoreq	sl, r1, r9, lsl #14
    2a68:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    2a6c:	0000040f 	andeq	r0, r0, pc, lsl #8
    2a70:	00282f09 	eoreq	r2, r8, r9, lsl #30
    2a74:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    2a78:	000001e6 	andeq	r0, r0, r6, ror #3
    2a7c:	001e950a 	andseq	r9, lr, sl, lsl #10
    2a80:	93010700 	movwls	r0, #5888	; 0x1700
    2a84:	05000000 	streq	r0, [r0, #-0]
    2a88:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    2a8c:	120b0000 	andne	r0, fp, #0
    2a90:	0000001a 	andeq	r0, r0, sl, lsl r0
    2a94:	0020a70b 	eoreq	sl, r0, fp, lsl #14
    2a98:	410b0100 	mrsmi	r0, (UNDEF: 27)
    2a9c:	02000029 	andeq	r0, r0, #41	; 0x29
    2aa0:	0029040b 	eoreq	r0, r9, fp, lsl #8
    2aa4:	fe0b0300 	cdp2	3, 0, cr0, cr11, cr0, {0}
    2aa8:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2aac:	0026bf0b 	eoreq	fp, r6, fp, lsl #30
    2ab0:	f80b0500 			; <UNDEFINED> instruction: 0xf80b0500
    2ab4:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2ab8:	001bda0b 	andseq	sp, fp, fp, lsl #20
    2abc:	f30b0700 	vabd.u8	d0, d11, d0
    2ac0:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    2ac4:	0022ba0b 	eoreq	fp, r2, fp, lsl #20
    2ac8:	ff0b0900 			; <UNDEFINED> instruction: 0xff0b0900
    2acc:	0a00001b 	beq	2b40 <shift+0x2b40>
    2ad0:	0022c10b 	eoreq	ip, r2, fp, lsl #2
    2ad4:	640b0b00 	strvs	r0, [fp], #-2816	; 0xfffff500
    2ad8:	0c00001c 	stceq	0, cr0, [r0], {28}
    2adc:	001bf10b 	andseq	pc, fp, fp, lsl #2
    2ae0:	160b0d00 	strne	r0, [fp], -r0, lsl #26
    2ae4:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    2ae8:	0024e30b 	eoreq	lr, r4, fp, lsl #6
    2aec:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    2af0:	0000260e 	andeq	r2, r0, lr, lsl #12
    2af4:	32013f05 	andcc	r3, r1, #5, 30
    2af8:	09000004 	stmdbeq	r0, {r2}
    2afc:	000026a2 	andeq	r2, r0, r2, lsr #13
    2b00:	a50f4105 	strge	r4, [pc, #-261]	; 2a03 <shift+0x2a03>
    2b04:	09000004 	stmdbeq	r0, {r2}
    2b08:	0000272a 	andeq	r2, r0, sl, lsr #14
    2b0c:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    2b10:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2b14:	00001b99 	muleq	r0, r9, fp
    2b18:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    2b1c:	10000000 	andne	r0, r0, r0
    2b20:	00002803 	andeq	r2, r0, r3, lsl #16
    2b24:	00273b09 	eoreq	r3, r7, r9, lsl #22
    2b28:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    2b2c:	000004e6 	andeq	r0, r0, r6, ror #9
    2b30:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    2b34:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2b38:	00002071 	andeq	r2, r0, r1, ror r0
    2b3c:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    2b40:	05000004 	streq	r0, [r0, #-4]
    2b44:	0004ec04 	andeq	lr, r4, r4, lsl #24
    2b48:	26241200 	strtcs	r1, [r4], -r0, lsl #4
    2b4c:	eb090000 	bl	242b54 <__bss_end+0x238fd4>
    2b50:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2b54:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    2b58:	04050000 	streq	r0, [r5], #-0
    2b5c:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2b60:	001d1013 	andseq	r1, sp, r3, lsl r0
    2b64:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    2b68:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    2b6c:	b0140000 	andslt	r0, r4, r0
    2b70:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2b74:	de0f0169 	adfleez	f0, f7, #1.0
    2b78:	00000003 	andeq	r0, r0, r3
    2b7c:	001cf414 	andseq	pc, ip, r4, lsl r4	; <UNPREDICTABLE>
    2b80:	016a0500 	cmneq	sl, r0, lsl #10
    2b84:	00054614 	andeq	r4, r5, r4, lsl r6
    2b88:	0e000400 	cfcpyseq	mvf0, mvf0
    2b8c:	00000516 	andeq	r0, r0, r6, lsl r5
    2b90:	0000b90c 	andeq	fp, r0, ip, lsl #18
    2b94:	00055600 	andeq	r5, r5, r0, lsl #12
    2b98:	00241500 	eoreq	r1, r4, r0, lsl #10
    2b9c:	002d0000 	eoreq	r0, sp, r0
    2ba0:	0005410c 	andeq	r4, r5, ip, lsl #2
    2ba4:	00056100 	andeq	r6, r5, r0, lsl #2
    2ba8:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2bac:	00000556 	andeq	r0, r0, r6, asr r5
    2bb0:	0020df0f 	eoreq	sp, r0, pc, lsl #30
    2bb4:	016b0500 	cmneq	fp, r0, lsl #10
    2bb8:	00056103 	andeq	r6, r5, r3, lsl #2
    2bbc:	23250f00 			; <UNDEFINED> instruction: 0x23250f00
    2bc0:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    2bc4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2bc8:	62160000 	andsvs	r0, r6, #0
    2bcc:	07000026 	streq	r0, [r0, -r6, lsr #32]
    2bd0:	00009301 	andeq	r9, r0, r1, lsl #6
    2bd4:	01810500 	orreq	r0, r1, r0, lsl #10
    2bd8:	00062a06 	andeq	r2, r6, r6, lsl #20
    2bdc:	1aa70b00 	bne	fe9c57e4 <__bss_end+0xfe9bbc64>
    2be0:	0b000000 	bleq	2be8 <shift+0x2be8>
    2be4:	00001ab3 			; <UNDEFINED> instruction: 0x00001ab3
    2be8:	1abf0b02 	bne	fefc57f8 <__bss_end+0xfefbbc78>
    2bec:	0b030000 	bleq	c2bf4 <__bss_end+0xb9074>
    2bf0:	00001ec1 	andeq	r1, r0, r1, asr #29
    2bf4:	1acb0b03 	bne	ff2c5808 <__bss_end+0xff2bbc88>
    2bf8:	0b040000 	bleq	102c00 <__bss_end+0xf9080>
    2bfc:	0000200a 	andeq	r2, r0, sl
    2c00:	20f00b04 	rscscs	r0, r0, r4, lsl #22
    2c04:	0b050000 	bleq	142c0c <__bss_end+0x13908c>
    2c08:	00002046 	andeq	r2, r0, r6, asr #32
    2c0c:	1b8a0b05 	blne	fe285828 <__bss_end+0xfe27bca8>
    2c10:	0b050000 	bleq	142c18 <__bss_end+0x139098>
    2c14:	00001ad7 	ldrdeq	r1, [r0], -r7
    2c18:	226e0b06 	rsbcs	r0, lr, #6144	; 0x1800
    2c1c:	0b060000 	bleq	182c24 <__bss_end+0x1790a4>
    2c20:	00001ce6 	andeq	r1, r0, r6, ror #25
    2c24:	227b0b06 	rsbscs	r0, fp, #6144	; 0x1800
    2c28:	0b060000 	bleq	182c30 <__bss_end+0x1790b0>
    2c2c:	000026e2 	andeq	r2, r0, r2, ror #13
    2c30:	22880b06 	addcs	r0, r8, #6144	; 0x1800
    2c34:	0b060000 	bleq	182c3c <__bss_end+0x1790bc>
    2c38:	000022c8 	andeq	r2, r0, r8, asr #5
    2c3c:	1ae30b06 	bne	ff8c585c <__bss_end+0xff8bbcdc>
    2c40:	0b070000 	bleq	1c2c48 <__bss_end+0x1b90c8>
    2c44:	000023ce 	andeq	r2, r0, lr, asr #7
    2c48:	241b0b07 	ldrcs	r0, [fp], #-2823	; 0xfffff4f9
    2c4c:	0b070000 	bleq	1c2c54 <__bss_end+0x1b90d4>
    2c50:	0000271d 	andeq	r2, r0, sp, lsl r7
    2c54:	1cb90b07 	fldmiaxne	r9!, {d0-d2}	;@ Deprecated
    2c58:	0b070000 	bleq	1c2c60 <__bss_end+0x1b90e0>
    2c5c:	0000249c 	muleq	r0, ip, r4
    2c60:	1a5c0b08 	bne	1705888 <__bss_end+0x16fbd08>
    2c64:	0b080000 	bleq	202c6c <__bss_end+0x1f90ec>
    2c68:	000026f0 	strdeq	r2, [r0], -r0
    2c6c:	24b80b08 	ldrtcs	r0, [r8], #2824	; 0xb08
    2c70:	00080000 	andeq	r0, r8, r0
    2c74:	0029560f 	eoreq	r5, r9, pc, lsl #12
    2c78:	019f0500 	orrseq	r0, pc, r0, lsl #10
    2c7c:	0005801f 	andeq	r8, r5, pc, lsl r0
    2c80:	24ea0f00 	strbtcs	r0, [sl], #3840	; 0xf00
    2c84:	a2050000 	andge	r0, r5, #0
    2c88:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c8c:	fd0f0000 	stc2	0, cr0, [pc, #-0]	; 2c94 <shift+0x2c94>
    2c90:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2c94:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    2c98:	0f000000 	svceq	0x00000000
    2c9c:	00002a22 	andeq	r2, r0, r2, lsr #20
    2ca0:	0c01a805 	stceq	8, cr10, [r1], {5}
    2ca4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ca8:	001ba90f 	andseq	sl, fp, pc, lsl #18
    2cac:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    2cb0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cb4:	24f40f00 	ldrbtcs	r0, [r4], #3840	; 0xf00
    2cb8:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2cbc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cc0:	050f0000 	streq	r0, [pc, #-0]	; 2cc8 <shift+0x2cc8>
    2cc4:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2cc8:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    2ccc:	0f000000 	svceq	0x00000000
    2cd0:	00002410 	andeq	r2, r0, r0, lsl r4
    2cd4:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    2cd8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cdc:	0024fe0f 	eoreq	pc, r4, pc, lsl #28
    2ce0:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    2ce4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2ce8:	224a0f00 	subcs	r0, sl, #0, 30
    2cec:	ba050000 	blt	142cf4 <__bss_end+0x139174>
    2cf0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cf4:	810f0000 	mrshi	r0, CPSR
    2cf8:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2cfc:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    2d00:	0f000000 	svceq	0x00000000
    2d04:	00002508 	andeq	r2, r0, r8, lsl #10
    2d08:	0c01c005 	stceq	0, cr12, [r1], {5}
    2d0c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d10:	002a450f 	eoreq	r4, sl, pc, lsl #10
    2d14:	01c30500 	biceq	r0, r3, r0, lsl #10
    2d18:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d1c:	290b0f00 	stmdbcs	fp, {r8, r9, sl, fp}
    2d20:	c6050000 	strgt	r0, [r5], -r0
    2d24:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d28:	170f0000 	strne	r0, [pc, -r0]
    2d2c:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2d30:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    2d34:	0f000000 	svceq	0x00000000
    2d38:	00002923 	andeq	r2, r0, r3, lsr #18
    2d3c:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2d40:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d44:	0029480f 	eoreq	r4, r9, pc, lsl #16
    2d48:	01d00500 	bicseq	r0, r0, r0, lsl #10
    2d4c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d50:	2a380f00 	bcs	e06958 <__bss_end+0xdfcdd8>
    2d54:	d3050000 	movwle	r0, #20480	; 0x5000
    2d58:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d5c:	060f0000 	streq	r0, [pc], -r0
    2d60:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2d64:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    2d68:	0f000000 	svceq	0x00000000
    2d6c:	000019ed 	andeq	r1, r0, sp, ror #19
    2d70:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2d74:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d78:	001ee10f 	andseq	lr, lr, pc, lsl #2
    2d7c:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2d80:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d84:	1be10f00 	blne	ff84698c <__bss_end+0xff83ce0c>
    2d88:	df050000 	svcle	0x00050000
    2d8c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d90:	1e0f0000 	cdpne	0, 0, cr0, cr15, cr0, {0}
    2d94:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2d98:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    2d9c:	0f000000 	svceq	0x00000000
    2da0:	00002126 	andeq	r2, r0, r6, lsr #2
    2da4:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    2da8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2dac:	00237e0f 	eoreq	r7, r3, pc, lsl #28
    2db0:	01e80500 	mvneq	r0, r0, lsl #10
    2db4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2db8:	28380f00 	ldmdacs	r8!, {r8, r9, sl, fp}
    2dbc:	ef050000 	svc	0x00050000
    2dc0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2dc4:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    2dc8:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2dcc:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    2dd0:	0f000000 	svceq	0x00000000
    2dd4:	00002a00 	andeq	r2, r0, r0, lsl #20
    2dd8:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    2ddc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2de0:	001cfd0f 	andseq	pc, ip, pc, lsl #26
    2de4:	01f80500 	mvnseq	r0, r0, lsl #10
    2de8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2dec:	287f0f00 	ldmdacs	pc!, {r8, r9, sl, fp}^	; <UNPREDICTABLE>
    2df0:	fb050000 	blx	142dfa <__bss_end+0x13927a>
    2df4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2df8:	840f0000 	strhi	r0, [pc], #-0	; 2e00 <shift+0x2e00>
    2dfc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2e00:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    2e04:	0f000000 	svceq	0x00000000
    2e08:	00001f5a 	andeq	r1, r0, sl, asr pc
    2e0c:	0c020205 	sfmeq	f0, 4, [r2], {5}
    2e10:	0000001d 	andeq	r0, r0, sp, lsl r0
    2e14:	0026740f 	eoreq	r7, r6, pc, lsl #8
    2e18:	020a0500 	andeq	r0, sl, #0, 10
    2e1c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2e20:	1e4d0f00 	cdpne	15, 4, cr0, cr13, cr0, {0}
    2e24:	0d050000 	stceq	0, cr0, [r5, #-0]
    2e28:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2e2c:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2e30:	ef000000 	svc	0x00000000
    2e34:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    2e38:	20260f00 	eorcs	r0, r6, r0, lsl #30
    2e3c:	fb050000 	blx	142e46 <__bss_end+0x1392c6>
    2e40:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    2e44:	e60c0000 	str	r0, [ip], -r0
    2e48:	0c000004 	stceq	0, cr0, [r0], {4}
    2e4c:	15000008 	strne	r0, [r0, #-8]
    2e50:	00000024 	andeq	r0, r0, r4, lsr #32
    2e54:	410f000d 	tstmi	pc, sp
    2e58:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2e5c:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    2e60:	16000007 	strne	r0, [r0], -r7
    2e64:	000020e8 	andeq	r2, r0, r8, ror #1
    2e68:	00930107 	addseq	r0, r3, r7, lsl #2
    2e6c:	8b050000 	blhi	142e74 <__bss_end+0x1392f4>
    2e70:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2e74:	a30b0000 	movwge	r0, #45056	; 0xb000
    2e78:	0000001e 	andeq	r0, r0, lr, lsl r0
    2e7c:	0022f30b 	eoreq	pc, r2, fp, lsl #6
    2e80:	920b0100 	andls	r0, fp, #0, 2
    2e84:	0200001a 	andeq	r0, r0, #26
    2e88:	0029b20b 	eoreq	fp, r9, fp, lsl #4
    2e8c:	bb0b0300 	bllt	2c3a94 <__bss_end+0x2b9f14>
    2e90:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    2e94:	0025ae0b 	eoreq	sl, r5, fp, lsl #28
    2e98:	690b0500 	stmdbvs	fp, {r8, sl}
    2e9c:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2ea0:	29a20f00 	stmibcs	r2!, {r8, r9, sl, fp}
    2ea4:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    2ea8:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    2eac:	a40f0000 	strge	r0, [pc], #-0	; 2eb4 <shift+0x2eb4>
    2eb0:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2eb4:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    2eb8:	0f000000 	svceq	0x00000000
    2ebc:	0000252e 	andeq	r2, r0, lr, lsr #10
    2ec0:	0c07ae05 	stceq	14, cr10, [r7], {5}
    2ec4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ec8:	00281704 	eoreq	r1, r8, r4, lsl #14
    2ecc:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    2ed0:	00000093 	muleq	r0, r3, r0
    2ed4:	00087e0e 	andeq	r7, r8, lr, lsl #28
    2ed8:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    2edc:	00000da9 	andeq	r0, r0, r9, lsr #27
    2ee0:	61070803 	tstvs	r7, r3, lsl #16
    2ee4:	03000007 	movweq	r0, #7
    2ee8:	1c210404 	cfstrsne	mvf0, [r1], #-16
    2eec:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2ef0:	001c1903 	andseq	r1, ip, r3, lsl #18
    2ef4:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2ef8:	00002517 	andeq	r2, r0, r7, lsl r5
    2efc:	c9031003 	stmdbgt	r3, {r0, r1, ip}
    2f00:	0c000025 	stceq	0, cr0, [r0], {37}	; 0x25
    2f04:	0000088a 	andeq	r0, r0, sl, lsl #17
    2f08:	000008c9 	andeq	r0, r0, r9, asr #17
    2f0c:	00002415 	andeq	r2, r0, r5, lsl r4
    2f10:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    2f14:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    2f18:	0024280f 	eoreq	r2, r4, pc, lsl #16
    2f1c:	01fc0600 	mvnseq	r0, r0, lsl #12
    2f20:	0008c916 	andeq	ip, r8, r6, lsl r9
    2f24:	1bd00f00 	blne	ff406b2c <__bss_end+0xff3fcfac>
    2f28:	02060000 	andeq	r0, r6, #0
    2f2c:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    2f30:	4a040000 	bmi	102f38 <__bss_end+0xf93b8>
    2f34:	07000028 	streq	r0, [r0, -r8, lsr #32]
    2f38:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    2f3c:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    2f40:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    2f44:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    2f48:	03570900 	cmpeq	r7, #0, 18
    2f4c:	2f070000 	svccs	0x00070000
    2f50:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2f54:	020c0900 	andeq	r0, ip, #0, 18
    2f58:	30070000 	andcc	r0, r7, r0
    2f5c:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2f60:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2f64:	33080000 	movwcc	r0, #32768	; 0x8000
    2f68:	03050a09 	movweq	r0, #23049	; 0x5a09
    2f6c:	00009b65 	andeq	r9, r0, r5, ror #22
    2f70:	00090b17 	andeq	r0, r9, r7, lsl fp
    2f74:	09340800 	ldmdbeq	r4!, {fp}
    2f78:	6503050a 	strvs	r0, [r3, #-1290]	; 0xfffffaf6
    2f7c:	0000009b 	muleq	r0, fp, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377094>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb919c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb91bc>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb91d4>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x234>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79d14>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe391f8>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7128>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6574>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9dd8>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4d90>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b65a0>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6614>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377190>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9290>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79dcc>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe392b0>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb92c8>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79e00>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4e3c>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377280>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7248>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb9368>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	03001605 	movweq	r1, #1541	; 0x605
 21c:	3b0b3a0e 	blcc	2cea5c <__bss_end+0x2c4edc>
 220:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 224:	06000013 			; <UNDEFINED> instruction: 0x06000013
 228:	0b0b0024 	bleq	2c02c0 <__bss_end+0x2b6740>
 22c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b9ed0>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb93b0>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f72d4>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7cc9c>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb93d8>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b9348>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79f2c>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe39410>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb44c>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4f6c>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79f64>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe39448>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x3773d0>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe79f94>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe39478>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a148>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x377404>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b6804>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe79fe4>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe394c8>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb94e0>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x377470>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a030>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe39514>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb550>
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
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c507c>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb9554>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c50b8>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377500>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb959c>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 438:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 43c:	03193f01 	tsteq	r9, #1, 30
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c5100>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 44c:	96184006 	ldrls	r4, [r8], -r6
 450:	13011942 	movwne	r1, #6466	; 0x1942
 454:	052a0000 	streq	r0, [sl, #-0]!
 458:	3a0e0300 	bcc	381060 <__bss_end+0x3774e0>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 464:	2b000018 	blcs	4cc <shift+0x4cc>
 468:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeb95dc>
 470:	13490b39 	movtne	r0, #39737	; 0x9b39
 474:	00001802 	andeq	r1, r0, r2, lsl #16
 478:	3f012e2c 	svccc	0x00012e2c
 47c:	3a0e0319 	bcc	3810e8 <__bss_end+0x377568>
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
 4b8:	03001604 	movweq	r1, #1540	; 0x604
 4bc:	3b0b3a0e 	blcc	2cecfc <__bss_end+0x2c517c>
 4c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4c4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 4c8:	0b0b0024 	bleq	2c0560 <__bss_end+0x2b69e0>
 4cc:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 4d0:	34060000 	strcc	r0, [r6], #-0
 4d4:	3a0e0300 	bcc	3810dc <__bss_end+0x37755c>
 4d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4dc:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4e0:	00180219 	andseq	r0, r8, r9, lsl r2
 4e4:	01130700 	tsteq	r3, r0, lsl #14
 4e8:	0b0b0e03 	bleq	2c3cfc <__bss_end+0x2ba17c>
 4ec:	0b3b0b3a 	bleq	ec31dc <__bss_end+0xeb965c>
 4f0:	13010b39 	movwne	r0, #6969	; 0x1b39
 4f4:	0d080000 	stceq	0, cr0, [r8, #-0]
 4f8:	3a080300 	bcc	201100 <__bss_end+0x1f7580>
 4fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 500:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 504:	0900000b 	stmdbeq	r0, {r0, r1, r3}
 508:	0e030104 	adfeqs	f0, f3, f4
 50c:	0b3e196d 	bleq	f86ac8 <__bss_end+0xf7cf48>
 510:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 514:	0b3b0b3a 	bleq	ec3204 <__bss_end+0xeb9684>
 518:	13010b39 	movwne	r0, #6969	; 0x1b39
 51c:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 520:	1c080300 	stcne	3, cr0, [r8], {-0}
 524:	0b00000b 	bleq	558 <shift+0x558>
 528:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 52c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 530:	0300020c 	movweq	r0, #524	; 0x20c
 534:	00193c0e 	andseq	r3, r9, lr, lsl #24
 538:	01020d00 	tsteq	r2, r0, lsl #26
 53c:	0b0b0e03 	bleq	2c3d50 <__bss_end+0x2ba1d0>
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeb96b0>
 544:	13010b39 	movwne	r0, #6969	; 0x1b39
 548:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 54c:	3a0e0300 	bcc	381154 <__bss_end+0x3775d4>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 558:	0f00000b 	svceq	0x0000000b
 55c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 560:	0b3a0e03 	bleq	e83d74 <__bss_end+0xe7a1f4>
 564:	0b390b3b 	bleq	e43258 <__bss_end+0xe396d8>
 568:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 56c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 570:	05100000 	ldreq	r0, [r0, #-0]
 574:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 578:	11000019 	tstne	r0, r9, lsl r0
 57c:	13490005 	movtne	r0, #36869	; 0x9005
 580:	0d120000 	ldceq	0, cr0, [r2, #-0]
 584:	3a0e0300 	bcc	38118c <__bss_end+0x37760c>
 588:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 58c:	3f13490b 	svccc	0x0013490b
 590:	00193c19 	andseq	r3, r9, r9, lsl ip
 594:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 598:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 59c:	0b3b0b3a 	bleq	ec328c <__bss_end+0xeb970c>
 5a0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5a4:	0b321349 	bleq	c852d0 <__bss_end+0xc7b750>
 5a8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5ac:	00001301 	andeq	r1, r0, r1, lsl #6
 5b0:	3f012e14 	svccc	0x00012e14
 5b4:	3a0e0319 	bcc	381220 <__bss_end+0x3776a0>
 5b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5bc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 5c0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb9740>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	0b321349 	bleq	c85304 <__bss_end+0xc7b784>
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
 604:	3a0e0300 	bcc	38120c <__bss_end+0x37768c>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	3f13490b 	svccc	0x0013490b
 610:	00193c19 	andseq	r3, r9, r9, lsl ip
 614:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 618:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 61c:	0b3b0b3a 	bleq	ec330c <__bss_end+0xeb978c>
 620:	0e6e0b39 	vmoveq.8	d14[5], r0
 624:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 628:	00001301 	andeq	r1, r0, r1, lsl #6
 62c:	3f012e1c 	svccc	0x00012e1c
 630:	3a0e0319 	bcc	38129c <__bss_end+0x37771c>
 634:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 638:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 63c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 640:	00130113 	andseq	r0, r3, r3, lsl r1
 644:	000d1d00 	andeq	r1, sp, r0, lsl #26
 648:	0b3a0e03 	bleq	e83e5c <__bss_end+0xe7a2dc>
 64c:	0b390b3b 	bleq	e43340 <__bss_end+0xe397c0>
 650:	0b381349 	bleq	e0537c <__bss_end+0xdfb7fc>
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
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c5340>
 684:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 688:	00180213 	andseq	r0, r8, r3, lsl r2
 68c:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 690:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 694:	0b3b0b3a 	bleq	ec3384 <__bss_end+0xeb9804>
 698:	0e6e0b39 	vmoveq.8	d14[5], r0
 69c:	01111349 	tsteq	r1, r9, asr #6
 6a0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6a4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6a8:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 6ac:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb9820>
 6b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6b8:	00001802 	andeq	r1, r0, r2, lsl #16
 6bc:	3f012e25 	svccc	0x00012e25
 6c0:	3a0e0319 	bcc	38132c <__bss_end+0x3777ac>
 6c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6c8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 6cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	34260000 	strtcc	r0, [r6], #-0
 6dc:	3a080300 	bcc	2012e4 <__bss_end+0x1f7764>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6e8:	27000018 	smladcs	r0, r8, r0, r0
 6ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6f0:	0b3a0e03 	bleq	e83f04 <__bss_end+0xe7a384>
 6f4:	0b390b3b 	bleq	e433e8 <__bss_end+0xe39868>
 6f8:	01110e6e 	tsteq	r1, lr, ror #28
 6fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 700:	01194297 			; <UNDEFINED> instruction: 0x01194297
 704:	28000013 	stmdacs	r0, {r0, r1, r4}
 708:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7a3a0>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39884>
 714:	01110e6e 	tsteq	r1, lr, ror #28
 718:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 71c:	00194297 	mulseq	r9, r7, r2
 720:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 724:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 728:	0b3b0b3a 	bleq	ec3418 <__bss_end+0xeb9898>
 72c:	0e6e0b39 	vmoveq.8	d14[5], r0
 730:	01111349 	tsteq	r1, r9, asr #6
 734:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 738:	00194297 	mulseq	r9, r7, r2
 73c:	11010000 	mrsne	r0, (UNDEF: 1)
 740:	130e2501 	movwne	r2, #58625	; 0xe501
 744:	1b0e030b 	blne	381378 <__bss_end+0x3777f8>
 748:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 74c:	00171006 	andseq	r1, r7, r6
 750:	00340200 	eorseq	r0, r4, r0, lsl #4
 754:	0b3a0e03 	bleq	e83f68 <__bss_end+0xe7a3e8>
 758:	0b390b3b 	bleq	e4344c <__bss_end+0xe398cc>
 75c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 760:	00001802 	andeq	r1, r0, r2, lsl #16
 764:	0b002403 	bleq	9778 <_Z4atofPKc+0x38>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0400000e 	streq	r0, [r0], #-14
 770:	13490026 	movtne	r0, #36902	; 0x9026
 774:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 778:	00130101 	andseq	r0, r3, r1, lsl #2
 77c:	00340600 	eorseq	r0, r4, r0, lsl #12
 780:	0b3a0e03 	bleq	e83f94 <__bss_end+0xe7a414>
 784:	0b390b3b 	bleq	e43478 <__bss_end+0xe398f8>
 788:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 78c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 790:	3a003a07 	bcc	efb4 <__bss_end+0x5434>
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
 7bc:	3b0b3a0e 	blcc	2ceffc <__bss_end+0x2c547c>
 7c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7c4:	1113490e 	tstne	r3, lr, lsl #18
 7c8:	40061201 	andmi	r1, r6, r1, lsl #4
 7cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 7d0:	00001301 	andeq	r1, r0, r1, lsl #6
 7d4:	0300050c 	movweq	r0, #1292	; 0x50c
 7d8:	3b0b3a08 	blcc	2cf000 <__bss_end+0x2c5480>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	00340d00 	eorseq	r0, r4, r0, lsl #26
 7e8:	0b3a0803 	bleq	e827fc <__bss_end+0xe78c7c>
 7ec:	0b390b3b 	bleq	e434e0 <__bss_end+0xe39960>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	340e0000 	strcc	r0, [lr], #-0
 7f8:	3a0e0300 	bcc	381400 <__bss_end+0x377880>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 804:	0f000018 	svceq	0x00000018
 808:	0111010b 	tsteq	r1, fp, lsl #2
 80c:	00000612 	andeq	r0, r0, r2, lsl r6
 810:	03003410 	movweq	r3, #1040	; 0x410
 814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c54d4>
 818:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 81c:	00180213 	andseq	r0, r8, r3, lsl r2
 820:	00341100 	eorseq	r1, r4, r0, lsl #2
 824:	0b3a0803 	bleq	e82838 <__bss_end+0xe78cb8>
 828:	0b39053b 	bleq	e41d1c <__bss_end+0xe3819c>
 82c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 830:	0f120000 	svceq	0x00120000
 834:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 838:	13000013 	movwne	r0, #19
 83c:	0b0b0024 	bleq	2c08d4 <__bss_end+0x2b6d54>
 840:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 844:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 848:	03193f01 	tsteq	r9, #1, 30
 84c:	3b0b3a0e 	blcc	2cf08c <__bss_end+0x2c550c>
 850:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 854:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 858:	96184006 	ldrls	r4, [r8], -r6
 85c:	13011942 	movwne	r1, #6466	; 0x1942
 860:	05150000 	ldreq	r0, [r5, #-0]
 864:	3a0e0300 	bcc	38146c <__bss_end+0x3778ec>
 868:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 86c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 870:	16000018 			; <UNDEFINED> instruction: 0x16000018
 874:	0111010b 	tsteq	r1, fp, lsl #2
 878:	13010612 	movwne	r0, #5650	; 0x1612
 87c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 880:	03193f01 	tsteq	r9, #1, 30
 884:	3b0b3a0e 	blcc	2cf0c4 <__bss_end+0x2c5544>
 888:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 88c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 890:	97184006 	ldrls	r4, [r8, -r6]
 894:	13011942 	movwne	r1, #6466	; 0x1942
 898:	10180000 	andsne	r0, r8, r0
 89c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 8a0:	19000013 	stmdbne	r0, {r0, r1, r4}
 8a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8a8:	0b3a0803 	bleq	e828bc <__bss_end+0xe78d3c>
 8ac:	0b390b3b 	bleq	e435a0 <__bss_end+0xe39a20>
 8b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 8b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 8bc:	00130119 	andseq	r0, r3, r9, lsl r1
 8c0:	00261a00 	eoreq	r1, r6, r0, lsl #20
 8c4:	0f1b0000 	svceq	0x001b0000
 8c8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 8cc:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 8d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8d4:	0b3b0b3a 	bleq	ec35c4 <__bss_end+0xeb9a44>
 8d8:	0e6e0b39 	vmoveq.8	d14[5], r0
 8dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 8e4:	00000019 	andeq	r0, r0, r9, lsl r0
 8e8:	10001101 	andne	r1, r0, r1, lsl #2
 8ec:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 8f0:	1b0e0301 	blne	3814fc <__bss_end+0x37797c>
 8f4:	130e250e 	movwne	r2, #58638	; 0xe50e
 8f8:	00000005 	andeq	r0, r0, r5
 8fc:	10001101 	andne	r1, r0, r1, lsl #2
 900:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 904:	1b0e0301 	blne	381510 <__bss_end+0x377990>
 908:	130e250e 	movwne	r2, #58638	; 0xe50e
 90c:	00000005 	andeq	r0, r0, r5
 910:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 914:	030b130e 	movweq	r1, #45838	; 0xb30e
 918:	100e1b0e 	andne	r1, lr, lr, lsl #22
 91c:	02000017 	andeq	r0, r0, #23
 920:	0b0b0024 	bleq	2c09b8 <__bss_end+0x2b6e38>
 924:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 928:	24030000 	strcs	r0, [r3], #-0
 92c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 930:	000e030b 	andeq	r0, lr, fp, lsl #6
 934:	00160400 	andseq	r0, r6, r0, lsl #8
 938:	0b3a0e03 	bleq	e8414c <__bss_end+0xe7a5cc>
 93c:	0b390b3b 	bleq	e43630 <__bss_end+0xe39ab0>
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
 968:	3b0b3a0e 	blcc	2cf1a8 <__bss_end+0x2c5628>
 96c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 970:	3c193f13 	ldccc	15, cr3, [r9], {19}
 974:	0a000019 	beq	9e0 <shift+0x9e0>
 978:	0e030104 	adfeqs	f0, f3, f4
 97c:	0b0b0b3e 	bleq	2c367c <__bss_end+0x2b9afc>
 980:	0b3a1349 	bleq	e856ac <__bss_end+0xe7bb2c>
 984:	0b390b3b 	bleq	e43678 <__bss_end+0xe39af8>
 988:	00001301 	andeq	r1, r0, r1, lsl #6
 98c:	0300280b 	movweq	r2, #2059	; 0x80b
 990:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 994:	01010c00 	tsteq	r1, r0, lsl #24
 998:	13011349 	movwne	r1, #4937	; 0x1349
 99c:	210d0000 	mrscs	r0, (UNDEF: 13)
 9a0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 9a4:	13490026 	movtne	r0, #36902	; 0x9026
 9a8:	340f0000 	strcc	r0, [pc], #-0	; 9b0 <shift+0x9b0>
 9ac:	3a0e0300 	bcc	3815b4 <__bss_end+0x377a34>
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
 9d8:	0b0e0301 	bleq	3815e4 <__bss_end+0x377a64>
 9dc:	3b0b3a0b 	blcc	2cf210 <__bss_end+0x2c5690>
 9e0:	010b3905 	tsteq	fp, r5, lsl #18
 9e4:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 9e8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 9ec:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 9f4:	00000b38 	andeq	r0, r0, r8, lsr fp
 9f8:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 9fc:	000b2f13 	andeq	r2, fp, r3, lsl pc
 a00:	01041600 	tsteq	r4, r0, lsl #12
 a04:	0b3e0e03 	bleq	f84218 <__bss_end+0xf7a698>
 a08:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 a0c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a10:	13010b39 	movwne	r0, #6969	; 0x1b39
 a14:	34170000 	ldrcc	r0, [r7], #-0
 a18:	3a134700 	bcc	4d2620 <__bss_end+0x4c8aa0>
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
  84:	11a10002 			; <UNDEFINED> instruction: 0x11a10002
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008418 	andeq	r8, r0, r8, lsl r4
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1f010002 	svcne	0x00010002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008874 	andeq	r8, r0, r4, ror r8
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	25fe0002 	ldrbcs	r0, [lr, #2]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009850 	andeq	r9, r0, r0, asr r8
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	26240002 	strtcs	r0, [r4], -r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009a5c 	andeq	r9, r0, ip, asr sl
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	264a0002 	strbcs	r0, [sl], -r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff63cc>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6171>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff6173>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4e88>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff62c1>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be7f8>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfda4>
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
     430:	5a5f0074 	bpl	17c0608 <__bss_end+0x17b6a88>
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
     58c:	6a685045 	bvs	1a146a8 <__bss_end+0x1a0ab28>
     590:	65530062 	ldrbvs	r0, [r3, #-98]	; 0xffffff9e
     594:	61505f74 	cmpvs	r0, r4, ror pc
     598:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     59c:	65727000 	ldrbvs	r7, [r2, #-0]!
     5a0:	5a5f0076 	bpl	17c0780 <__bss_end+0x17b6c00>
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
     6a8:	314e5a5f 	cmpcc	lr, pc, asr sl
     6ac:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6b4:	614d5f73 	hvcvs	54771	; 0xd5f3
     6b8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6bc:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     6c0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6c4:	5f656c75 	svcpl	0x00656c75
     6c8:	76455252 			; <UNDEFINED> instruction: 0x76455252
     6cc:	6f6c4200 	svcvs	0x006c4200
     6d0:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     6d4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6d8:	505f746e 	subspl	r7, pc, lr, ror #8
     6dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6e0:	47007373 	smlsdxmi	r0, r3, r3, r7
     6e4:	505f7465 	subspl	r7, pc, r5, ror #8
     6e8:	75004449 	strvc	r4, [r0, #-1097]	; 0xfffffbb7
     6ec:	33746e69 	cmncc	r4, #1680	; 0x690
     6f0:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     6f4:	314e5a5f 	cmpcc	lr, pc, asr sl
     6f8:	50474333 	subpl	r4, r7, r3, lsr r3
     6fc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     700:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     704:	47397265 	ldrmi	r7, [r9, -r5, ror #4]!
     708:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     70c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     710:	5f006a45 	svcpl	0x00006a45
     714:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     718:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     71c:	61485f4f 	cmpvs	r8, pc, asr #30
     720:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     724:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     728:	4f5f7465 	svcmi	0x005f7465
     72c:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     730:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     734:	4f494e00 	svcmi	0x00494e00
     738:	5f6c7443 	svcpl	0x006c7443
     73c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     740:	6f697461 	svcvs	0x00697461
     744:	5342006e 	movtpl	r0, #8302	; 0x206e
     748:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     74c:	00657361 	rsbeq	r7, r5, r1, ror #6
     750:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     754:	61544e00 	cmpvs	r4, r0, lsl #28
     758:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     75c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     760:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     764:	6f6c2067 	svcvs	0x006c2067
     768:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
     76c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     770:	2064656e 	rsbcs	r6, r4, lr, ror #10
     774:	00746e69 	rsbseq	r6, r4, r9, ror #28
     778:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     77c:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     780:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     784:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     788:	49550046 	ldmdbmi	r5, {r1, r2, r6}^
     78c:	3233544e 	eorscc	r5, r3, #1308622848	; 0x4e000000
     790:	4e494d5f 	mcrmi	13, 2, r4, cr9, cr15, {2}
     794:	6f6c4200 	svcvs	0x006c4200
     798:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     79c:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     7a0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     7a4:	61545f74 	cmpvs	r4, r4, ror pc
     7a8:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     7ac:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7b0:	314e5a5f 	cmpcc	lr, pc, asr sl
     7b4:	50474333 	subpl	r4, r7, r3, lsr r3
     7b8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7bc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7c0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     7c4:	63006a45 	movwvs	r6, #2629	; 0xa45
     7c8:	5f726168 	svcpl	0x00726168
     7cc:	6b636974 	blvs	18dada4 <__bss_end+0x18d1224>
     7d0:	6c65645f 	cfstrdvs	mvd6, [r5], #-380	; 0xfffffe84
     7d4:	6d007961 	vstrvs.16	s14, [r0, #-194]	; 0xffffff3e	; <UNPREDICTABLE>
     7d8:	746f6f52 	strbtvc	r6, [pc], #-3922	; 7e0 <shift+0x7e0>
     7dc:	7665445f 			; <UNDEFINED> instruction: 0x7665445f
     7e0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7e4:	50433631 	subpl	r3, r3, r1, lsr r6
     7e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7ec:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 628 <shift+0x628>
     7f0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7f4:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     7f8:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     7fc:	6f545f68 	svcvs	0x00545f68
     800:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     804:	6f725043 	svcvs	0x00725043
     808:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     80c:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     810:	6f4e5f74 	svcvs	0x004e5f74
     814:	70006564 	andvc	r6, r0, r4, ror #10
     818:	695f6e69 	ldmdbvs	pc, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     81c:	63007864 	movwvs	r7, #2148	; 0x864
     820:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     824:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     828:	6d007478 	cfstrsvs	mvf7, [r0, #-480]	; 0xfffffe20
     82c:	4f495047 	svcmi	0x00495047
     830:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
     834:	5f657461 	svcpl	0x00657461
     838:	636f7250 	cmnvs	pc, #80, 4
     83c:	00737365 	rsbseq	r7, r3, r5, ror #6
     840:	4b4e5a5f 	blmi	13971c4 <__bss_end+0x138d644>
     844:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     848:	5f4f4950 	svcpl	0x004f4950
     84c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     850:	3172656c 	cmncc	r2, ip, ror #10
     854:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     858:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     85c:	5f4c4553 	svcpl	0x004c4553
     860:	61636f4c 	cmnvs	r3, ip, asr #30
     864:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     868:	6a526a45 	bvs	149b184 <__bss_end+0x1491604>
     86c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     870:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     874:	44736900 	ldrbtmi	r6, [r3], #-2304	; 0xfffff700
     878:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
     87c:	79726f74 	ldmdbvc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     880:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     884:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     888:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     88c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     890:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     894:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     898:	61425f72 	hvcvs	9714	; 0x25f2
     89c:	67006573 	smlsdxvs	r0, r3, r5, r6
     8a0:	445f5346 	ldrbmi	r5, [pc], #-838	; 8a8 <shift+0x8a8>
     8a4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     8a8:	435f7372 	cmpmi	pc, #-939524095	; 0xc8000001
     8ac:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     8b0:	50477300 	subpl	r7, r7, r0, lsl #6
     8b4:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     8b8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8bc:	53444550 	movtpl	r4, #17744	; 0x4550
     8c0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     8c4:	6f697461 	svcvs	0x00697461
     8c8:	7562006e 	strbvc	r0, [r2, #-110]!	; 0xffffff92
     8cc:	6e6f7474 	mcrvs	4, 3, r7, cr15, cr4, {3}
     8d0:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     8d4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     8d8:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     8dc:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     8e0:	5f006e6f 	svcpl	0x00006e6f
     8e4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     8e8:	6f725043 	svcvs	0x00725043
     8ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8f0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     8f4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8f8:	6f4e3431 	svcvs	0x004e3431
     8fc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     900:	6f72505f 	svcvs	0x0072505f
     904:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     908:	32315045 	eorscc	r5, r1, #69	; 0x45
     90c:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     910:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     914:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     918:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     91c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     920:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     924:	006f666e 	rsbeq	r6, pc, lr, ror #12
     928:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     92c:	6554006c 	ldrbvs	r0, [r4, #-108]	; 0xffffff94
     930:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     934:	00657461 	rsbeq	r7, r5, r1, ror #8
     938:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     93c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     940:	746f4e00 	strbtvc	r4, [pc], #-3584	; 948 <shift+0x948>
     944:	5f796669 	svcpl	0x00796669
     948:	636f7250 	cmnvs	pc, #80, 4
     94c:	00737365 	rsbseq	r7, r3, r5, ror #6
     950:	314e5a5f 	cmpcc	lr, pc, asr sl
     954:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     958:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     95c:	614d5f73 	hvcvs	54771	; 0xd5f3
     960:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     964:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     968:	5a5f0076 	bpl	17c0b48 <__bss_end+0x17b6fc8>
     96c:	33314b4e 	teqcc	r1, #79872	; 0x13800
     970:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     974:	61485f4f 	cmpvs	r8, pc, asr #30
     978:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     97c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     980:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     984:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     988:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     98c:	6f697461 	svcvs	0x00697461
     990:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     994:	5f30536a 	svcpl	0x0030536a
     998:	6f4c6d00 	svcvs	0x004c6d00
     99c:	6d006b63 	vstrvs	d6, [r0, #-396]	; 0xfffffe74
     9a0:	746f6f52 	strbtvc	r6, [pc], #-3922	; 9a8 <shift+0x9a8>
     9a4:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
     9a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9ac:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     9b0:	4f495047 	svcmi	0x00495047
     9b4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     9b8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     9bc:	65473232 	strbvs	r3, [r7, #-562]	; 0xfffffdce
     9c0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     9c4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     9c8:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 56b <shift+0x56b>
     9cc:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     9d0:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     9d4:	5f007645 	svcpl	0x00007645
     9d8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     9dc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     9e0:	61485f4f 	cmpvs	r8, pc, asr #30
     9e4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9e8:	45393172 	ldrmi	r3, [r9, #-370]!	; 0xfffffe8e
     9ec:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     9f0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     9f4:	5f746e65 	svcpl	0x00746e65
     9f8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     9fc:	6a457463 	bvs	115db90 <__bss_end+0x1154010>
     a00:	474e3032 	smlaldxmi	r3, lr, r2, r0
     a04:	5f4f4950 	svcpl	0x004f4950
     a08:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a0c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a10:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a14:	4e006570 	cfrshl64mi	mvdx0, mvdx0, r6
     a18:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a1c:	72640079 	rsbvc	r0, r4, #121	; 0x79
     a20:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     a24:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     a28:	445f7261 	ldrbmi	r7, [pc], #-609	; a30 <shift+0xa30>
     a2c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a30:	5f646574 	svcpl	0x00646574
     a34:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     a38:	61480074 	hvcvs	32772	; 0x8004
     a3c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a40:	5152495f 	cmppl	r2, pc, asr r9
     a44:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     a48:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     a4c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     a50:	5f006874 	svcpl	0x00006874
     a54:	314b4e5a 	cmpcc	fp, sl, asr lr
     a58:	50474333 	subpl	r4, r7, r3, lsr r3
     a5c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     a60:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a64:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a68:	5f746547 	svcpl	0x00746547
     a6c:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     a70:	6f4c5f53 	svcvs	0x004c5f53
     a74:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     a78:	6a456e6f 	bvs	115c43c <__bss_end+0x11528bc>
     a7c:	30536a52 	subscc	r6, r3, r2, asr sl
     a80:	614d005f 	qdaddvs	r0, pc, sp	; <UNPREDICTABLE>
     a84:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     a88:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     a8c:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     a90:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     a94:	00687467 	rsbeq	r7, r8, r7, ror #8
     a98:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     a9c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     aa0:	61767265 	cmnvs	r6, r5, ror #4
     aa4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     aa8:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     aac:	00657469 	rsbeq	r7, r5, r9, ror #8
     ab0:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     ab4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     ab8:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     abc:	5f6f666e 	svcpl	0x006f666e
     ac0:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     ac4:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     ac8:	745f7065 	ldrbvc	r7, [pc], #-101	; ad0 <shift+0xad0>
     acc:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ad0:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     ad4:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     ad8:	6f435f6e 	svcvs	0x00435f6e
     adc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     ae0:	6b736174 	blvs	1cd90b8 <__bss_end+0x1ccf538>
     ae4:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     ae8:	6f465f74 	svcvs	0x00465f74
     aec:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     af0:	00746e65 	rsbseq	r6, r4, r5, ror #28
     af4:	5f746547 	svcpl	0x00746547
     af8:	4f495047 	svcmi	0x00495047
     afc:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     b00:	6f697463 	svcvs	0x00697463
     b04:	6f62006e 	svcvs	0x0062006e
     b08:	5f006c6f 	svcpl	0x00006c6f
     b0c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b10:	6f725043 	svcvs	0x00725043
     b14:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b18:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b1c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b20:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     b24:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b28:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b2c:	5f72656c 	svcpl	0x0072656c
     b30:	6f666e49 	svcvs	0x00666e49
     b34:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     b38:	5f746547 	svcpl	0x00746547
     b3c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b40:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     b44:	545f6f66 	ldrbpl	r6, [pc], #-3942	; b4c <shift+0xb4c>
     b48:	50657079 	rsbpl	r7, r5, r9, ror r0
     b4c:	52540076 	subspl	r0, r4, #118	; 0x76
     b50:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     b54:	00657361 	rsbeq	r7, r5, r1, ror #6
     b58:	61666544 	cmnvs	r6, r4, asr #10
     b5c:	5f746c75 	svcpl	0x00746c75
     b60:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     b64:	61525f6b 	cmpvs	r2, fp, ror #30
     b68:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     b6c:	746f6f52 	strbtvc	r6, [pc], #-3922	; b74 <shift+0xb74>
     b70:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     b74:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b78:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     b7c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     b80:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     b84:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     b88:	6f72506d 	svcvs	0x0072506d
     b8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b90:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     b94:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     b98:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     b9c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ba0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     ba4:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     ba8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bac:	50433631 	subpl	r3, r3, r1, lsr r6
     bb0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bb4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9f0 <shift+0x9f0>
     bb8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     bbc:	31327265 	teqcc	r2, r5, ror #4
     bc0:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     bc4:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     bc8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     bcc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     bd0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bd4:	00764573 	rsbseq	r4, r6, r3, ror r5
     bd8:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     bdc:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     be0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     be4:	4c007365 	stcmi	3, cr7, [r0], {101}	; 0x65
     be8:	5f6b636f 	svcpl	0x006b636f
     bec:	6f6c6e55 	svcvs	0x006c6e55
     bf0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     bf4:	614c6d00 	cmpvs	ip, r0, lsl #26
     bf8:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     bfc:	5f004449 	svcpl	0x00004449
     c00:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     c04:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     c08:	61485f4f 	cmpvs	r8, pc, asr #30
     c0c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c10:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     c14:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     c18:	5f4f4950 	svcpl	0x004f4950
     c1c:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     c20:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c24:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     c28:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     c2c:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     c30:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     c34:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     c38:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     c3c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     c40:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     c44:	6e696c62 	cdpvs	12, 6, cr6, cr9, cr2, {3}
     c48:	5f00626b 	svcpl	0x0000626b
     c4c:	31314e5a 	teqcc	r1, sl, asr lr
     c50:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     c54:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     c58:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     c5c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c60:	634b5045 	movtvs	r5, #45125	; 0xb045
     c64:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     c68:	5f656c69 	svcpl	0x00656c69
     c6c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c70:	646f4d5f 	strbtvs	r4, [pc], #-3423	; c78 <shift+0xc78>
     c74:	77530065 	ldrbvc	r0, [r3, -r5, rrx]
     c78:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     c7c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     c80:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     c84:	5a5f0065 	bpl	17c0e20 <__bss_end+0x17b72a0>
     c88:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c8c:	636f7250 	cmnvs	pc, #80, 4
     c90:	5f737365 	svcpl	0x00737365
     c94:	616e614d 	cmnvs	lr, sp, asr #2
     c98:	31726567 	cmncc	r2, r7, ror #10
     c9c:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     ca0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ca4:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     ca8:	00764546 	rsbseq	r4, r6, r6, asr #10
     cac:	5f746547 	svcpl	0x00746547
     cb0:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     cb4:	6f4c5f56 	svcvs	0x004c5f56
     cb8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     cbc:	42006e6f 	andmi	r6, r0, #1776	; 0x6f0
     cc0:	5f304353 	svcpl	0x00304353
     cc4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     cc8:	73695200 	cmnvc	r9, #0, 4
     ccc:	5f676e69 	svcpl	0x00676e69
     cd0:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     cd4:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     cd8:	65520063 	ldrbvs	r0, [r2, #-99]	; 0xffffff9d
     cdc:	76726573 			; <UNDEFINED> instruction: 0x76726573
     ce0:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ce4:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     ce8:	6e006867 	cdpvs	8, 0, cr6, cr0, cr7, {3}
     cec:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     cf0:	5f646569 	svcpl	0x00646569
     cf4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     cf8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     cfc:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     d00:	61460076 	hvcvs	24582	; 0x6006
     d04:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     d08:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     d0c:	5f006567 	svcpl	0x00006567
     d10:	31314e5a 	teqcc	r1, sl, asr lr
     d14:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     d18:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     d1c:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     d20:	00764534 	rsbseq	r4, r6, r4, lsr r5
     d24:	314e5a5f 	cmpcc	lr, pc, asr sl
     d28:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d2c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d30:	614d5f73 	hvcvs	54771	; 0xd5f3
     d34:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d38:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     d3c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d40:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     d44:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d48:	006a4573 	rsbeq	r4, sl, r3, ror r5
     d4c:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     d50:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d54:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d58:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     d5c:	73007265 	movwvc	r7, #613	; 0x265
     d60:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     d64:	5f6b636f 	svcpl	0x006b636f
     d68:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     d6c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d70:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d74:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 917 <shift+0x917>
     d78:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d7c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     d80:	61654400 	cmnvs	r5, r0, lsl #8
     d84:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     d88:	61700065 	cmnvs	r0, r5, rrx
     d8c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     d90:	73694400 	cmnvc	r9, #0, 8
     d94:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d98:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d9c:	445f746e 	ldrbmi	r7, [pc], #-1134	; da4 <shift+0xda4>
     da0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     da4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     da8:	6f687300 	svcvs	0x00687300
     dac:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     db0:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     db4:	70797472 	rsbsvc	r7, r9, r2, ror r4
     db8:	614d0065 	cmpvs	sp, r5, rrx
     dbc:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     dc0:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     dc4:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     dc8:	00687467 	rsbeq	r7, r8, r7, ror #8
     dcc:	6f6f526d 	svcvs	0x006f526d
     dd0:	72460074 	subvc	r0, r6, #116	; 0x74
     dd4:	505f6565 	subspl	r6, pc, r5, ror #10
     dd8:	43006e69 	movwmi	r6, #3689	; 0xe69
     ddc:	636f7250 	cmnvs	pc, #80, 4
     de0:	5f737365 	svcpl	0x00737365
     de4:	616e614d 	cmnvs	lr, sp, asr #2
     de8:	00726567 	rsbseq	r6, r2, r7, ror #10
     dec:	70736e55 	rsbsvc	r6, r3, r5, asr lr
     df0:	66696365 	strbtvs	r6, [r9], -r5, ror #6
     df4:	00646569 	rsbeq	r6, r4, r9, ror #10
     df8:	314e5a5f 	cmpcc	lr, pc, asr sl
     dfc:	50474333 	subpl	r4, r7, r3, lsr r3
     e00:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e04:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e08:	46387265 	ldrtmi	r7, [r8], -r5, ror #4
     e0c:	5f656572 	svcpl	0x00656572
     e10:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     e14:	0062626a 	rsbeq	r6, r2, sl, ror #4
     e18:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e1c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e20:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e24:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     e28:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     e2c:	4600657a 			; <UNDEFINED> instruction: 0x4600657a
     e30:	5f646e69 	svcpl	0x00646e69
     e34:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     e38:	74740064 	ldrbtvc	r0, [r4], #-100	; 0xffffff9c
     e3c:	00307262 	eorseq	r7, r0, r2, ror #4
     e40:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     e44:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; d80 <shift+0xd80>
     e48:	4e005841 	cdpmi	8, 0, cr5, cr0, cr1, {2}
     e4c:	5f495753 	svcpl	0x00495753
     e50:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e54:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     e58:	535f6d65 	cmppl	pc, #6464	; 0x1940
     e5c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     e60:	6c006563 	cfstr32vs	mvfx6, [r0], {99}	; 0x63
     e64:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     e68:	4e006570 	cfrshl64mi	mvdx0, mvdx0, r6
     e6c:	5f495753 	svcpl	0x00495753
     e70:	636f7250 	cmnvs	pc, #80, 4
     e74:	5f737365 	svcpl	0x00737365
     e78:	76726553 			; <UNDEFINED> instruction: 0x76726553
     e7c:	00656369 	rsbeq	r6, r5, r9, ror #6
     e80:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     e84:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     e88:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e8c:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     e90:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     e94:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     e98:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     e9c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     ea0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     ea4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ea8:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     eac:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     eb0:	616e4500 	cmnvs	lr, r0, lsl #10
     eb4:	5f656c62 	svcpl	0x00656c62
     eb8:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     ebc:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     ec0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     ec4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     ec8:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     ecc:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     ed0:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     ed4:	00657361 	rsbeq	r7, r5, r1, ror #6
     ed8:	5f746547 	svcpl	0x00746547
     edc:	53465047 	movtpl	r5, #24647	; 0x6047
     ee0:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     ee4:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     ee8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     eec:	4b4e5a5f 	blmi	1397870 <__bss_end+0x138dcf0>
     ef0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     ef4:	5f4f4950 	svcpl	0x004f4950
     ef8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     efc:	3172656c 	cmncc	r2, ip, ror #10
     f00:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
     f04:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     f08:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     f0c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     f10:	6a456e6f 	bvs	115c8d4 <__bss_end+0x1152d54>
     f14:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     f18:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     f1c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     f20:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f24:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     f28:	5f4f4950 	svcpl	0x004f4950
     f2c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     f30:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     f34:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     f38:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     f3c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     f40:	445f746e 	ldrbmi	r7, [pc], #-1134	; f48 <shift+0xf48>
     f44:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     f48:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     f4c:	50474e30 	subpl	r4, r7, r0, lsr lr
     f50:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f54:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     f58:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     f5c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     f60:	506d0065 	rsbpl	r0, sp, r5, rrx
     f64:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     f68:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     f6c:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     f70:	5f736e6f 	svcpl	0x00736e6f
     f74:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f78:	636f4c00 	cmnvs	pc, #0, 24
     f7c:	6f4c5f6b 	svcvs	0x004c5f6b
     f80:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     f84:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f88:	50433631 	subpl	r3, r3, r1, lsr r6
     f8c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f90:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; dcc <shift+0xdcc>
     f94:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     f98:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f9c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     fa0:	505f656c 	subspl	r6, pc, ip, ror #10
     fa4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fa8:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     fac:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     fb0:	57534e30 	smmlarpl	r3, r0, lr, r4
     fb4:	72505f49 	subsvc	r5, r0, #292	; 0x124
     fb8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fbc:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     fc0:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     fc4:	6a6a6a65 	bvs	1a9b960 <__bss_end+0x1a91de0>
     fc8:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     fcc:	5f495753 	svcpl	0x00495753
     fd0:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     fd4:	5f00746c 	svcpl	0x0000746c
     fd8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     fdc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     fe0:	61485f4f 	cmpvs	r8, pc, asr #30
     fe4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     fe8:	43303272 	teqmi	r0, #536870919	; 0x20000007
     fec:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     ff0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     ff4:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     ff8:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     ffc:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    1000:	6373006a 	cmnvs	r3, #106	; 0x6a
    1004:	5f646568 	svcpl	0x00646568
    1008:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    100c:	00726574 	rsbseq	r6, r2, r4, ror r5
    1010:	5f746547 	svcpl	0x00746547
    1014:	61726150 	cmnvs	r2, r0, asr r1
    1018:	7500736d 	strvc	r7, [r0, #-877]	; 0xfffffc93
    101c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1020:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1024:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
    1028:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
    102c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1030:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
    1034:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
    1038:	7065656c 	rsbvc	r6, r5, ip, ror #10
    103c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1040:	5f50475f 	svcpl	0x0050475f
    1044:	5f515249 	svcpl	0x00515249
    1048:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    104c:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
    1050:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    1054:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1058:	314e5a5f 	cmpcc	lr, pc, asr sl
    105c:	50474333 	subpl	r4, r7, r3, lsr r3
    1060:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1064:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1068:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
    106c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
    1070:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
    1074:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    1078:	5045746e 	subpl	r7, r5, lr, ror #8
    107c:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
    1080:	006a656c 	rsbeq	r6, sl, ip, ror #10
    1084:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1088:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    108c:	0052525f 	subseq	r5, r2, pc, asr r2
    1090:	5f585541 	svcpl	0x00585541
    1094:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    1098:	43534200 	cmpmi	r3, #0, 4
    109c:	61425f32 	cmpvs	r2, r2, lsr pc
    10a0:	57006573 	smlsdxpl	r0, r3, r5, r6
    10a4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    10a8:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    10ac:	63530079 	cmpvs	r3, #121	; 0x79
    10b0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    10b4:	5f00656c 	svcpl	0x0000656c
    10b8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    10bc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    10c0:	61485f4f 	cmpvs	r8, pc, asr #30
    10c4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    10c8:	48303172 	ldmdami	r0!, {r1, r4, r5, r6, r8, ip, sp}
    10cc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    10d0:	52495f65 	subpl	r5, r9, #404	; 0x194
    10d4:	00764551 	rsbseq	r4, r6, r1, asr r5
    10d8:	6b636954 	blvs	18db630 <__bss_end+0x18d1ab0>
    10dc:	756f435f 	strbvc	r4, [pc, #-863]!	; d85 <shift+0xd85>
    10e0:	5f00746e 	svcpl	0x0000746e
    10e4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10e8:	6f725043 	svcvs	0x00725043
    10ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10f0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10f4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10f8:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
    10fc:	5f70616d 	svcpl	0x0070616d
    1100:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1104:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1108:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    110c:	41006a45 	tstmi	r0, r5, asr #20
    1110:	305f746c 	subscc	r7, pc, ip, ror #8
    1114:	69464900 	stmdbvs	r6, {r8, fp, lr}^
    1118:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    111c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1120:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    1124:	00726576 	rsbseq	r6, r2, r6, ror r5
    1128:	5f746c41 	svcpl	0x00746c41
    112c:	6c410032 	mcrrvs	0, 3, r0, r1, cr2
    1130:	00335f74 	eorseq	r5, r3, r4, ror pc
    1134:	5f746c41 	svcpl	0x00746c41
    1138:	6c410034 	mcrrvs	0, 3, r0, r1, cr4
    113c:	00355f74 	eorseq	r5, r5, r4, ror pc
    1140:	314e5a5f 	cmpcc	lr, pc, asr sl
    1144:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
    1148:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    114c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1150:	46543331 			; <UNDEFINED> instruction: 0x46543331
    1154:	72545f53 	subsvc	r5, r4, #332	; 0x14c
    1158:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
    115c:	3165646f 	cmncc	r5, pc, ror #8
    1160:	6e694630 	mcrvs	6, 3, r4, cr9, cr0, {1}
    1164:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1168:	45646c69 	strbmi	r6, [r4, #-3177]!	; 0xfffff397
    116c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1170:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1174:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
    1178:	73656c69 	cmnvc	r5, #26880	; 0x6900
    117c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1180:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
    1184:	5a5f0049 	bpl	17c12b0 <__bss_end+0x17b7730>
    1188:	33314b4e 	teqcc	r1, #79872	; 0x13800
    118c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1190:	61485f4f 	cmpvs	r8, pc, asr #30
    1194:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1198:	47383172 			; <UNDEFINED> instruction: 0x47383172
    119c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    11a0:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
    11a4:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    11a8:	6f697461 	svcvs	0x00697461
    11ac:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
    11b0:	5f30536a 	svcpl	0x0030536a
    11b4:	6f687300 	svcvs	0x00687300
    11b8:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
    11bc:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    11c0:	2064656e 	rsbcs	r6, r4, lr, ror #10
    11c4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    11c8:	6e69616d 	powvsez	f6, f1, #5.0
    11cc:	72507300 	subsvc	r7, r0, #0, 6
    11d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    11d4:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    11d8:	50474300 	subpl	r4, r7, r0, lsl #6
    11dc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11e0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11e4:	41007265 	tstmi	r0, r5, ror #4
    11e8:	315f746c 	cmpcc	pc, ip, ror #8
    11ec:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
    11f0:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
    11f4:	682f006e 	stmdavs	pc!, {r1, r2, r3, r5, r6}	; <UNPREDICTABLE>
    11f8:	2f656d6f 	svccs	0x00656d6f
    11fc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    1200:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    1204:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    1208:	2f736f2f 	svccs	0x00736f2f
    120c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1210:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1214:	752f7365 	strvc	r7, [pc, #-869]!	; eb7 <shift+0xeb7>
    1218:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
    121c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
    1220:	736f732f 	cmnvc	pc, #-1140850688	; 0xbc000000
    1224:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1228:	616d2f6b 	cmnvs	sp, fp, ror #30
    122c:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
    1230:	44007070 	strmi	r7, [r0], #-112	; 0xffffff90
    1234:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    1238:	455f656c 	ldrbmi	r6, [pc, #-1388]	; cd4 <shift+0xcd4>
    123c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1240:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1244:	00746365 	rsbseq	r6, r4, r5, ror #6
    1248:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    124c:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1250:	6f435f74 	svcvs	0x00435f74
    1254:	6f72746e 	svcvs	0x0072746e
    1258:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    125c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    1260:	46540065 	ldrbmi	r0, [r4], -r5, rrx
    1264:	72445f53 	subvc	r5, r4, #332	; 0x14c
    1268:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    126c:	61655200 	cmnvs	r5, r0, lsl #4
    1270:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
    1274:	00657469 	rsbeq	r7, r5, r9, ror #8
    1278:	49464e49 	stmdbmi	r6, {r0, r3, r6, r9, sl, fp, lr}^
    127c:	5954494e 	ldmdbpl	r4, {r1, r2, r3, r6, r8, fp, lr}^
    1280:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
    1284:	5f657669 	svcpl	0x00657669
    1288:	636f7250 	cmnvs	pc, #80, 4
    128c:	5f737365 	svcpl	0x00737365
    1290:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    1294:	79730074 	ldmdbvc	r3!, {r2, r4, r5, r6}^
    1298:	6c6f626d 	sfmvs	f6, 2, [pc], #-436	; 10ec <shift+0x10ec>
    129c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    12a0:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    12a4:	0079616c 	rsbseq	r6, r9, ip, ror #2
    12a8:	314e5a5f 	cmpcc	lr, pc, asr sl
    12ac:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    12b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12b4:	614d5f73 	hvcvs	54771	; 0xd5f3
    12b8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    12bc:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
    12c0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    12c4:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    12c8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    12cc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    12d0:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    12d4:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
    12d8:	5f495753 	svcpl	0x00495753
    12dc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    12e0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    12e4:	535f6d65 	cmppl	pc, #6464	; 0x1940
    12e8:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    12ec:	6a6a6563 	bvs	1a9a880 <__bss_end+0x1a90d00>
    12f0:	3131526a 	teqcc	r1, sl, ror #4
    12f4:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    12f8:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    12fc:	00746c75 	rsbseq	r6, r4, r5, ror ip
    1300:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
    1304:	455f656c 	ldrbmi	r6, [pc, #-1388]	; da0 <shift+0xda0>
    1308:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    130c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1310:	00746365 	rsbseq	r6, r4, r5, ror #6
    1314:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1318:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    131c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    1320:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1324:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
    1328:	61767465 	cmnvs	r6, r5, ror #8
    132c:	636e006c 	cmnvs	lr, #108	; 0x6c
    1330:	73007275 	movwvc	r7, #629	; 0x275
    1334:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1338:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    133c:	7200646c 	andvc	r6, r0, #108, 8	; 0x6c000000
    1340:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
    1344:	315a5f00 	cmpcc	sl, r0, lsl #30
    1348:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
    134c:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1350:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1354:	5a5f0076 	bpl	17c1534 <__bss_end+0x17b79b4>
    1358:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
    135c:	61745f74 	cmnvs	r4, r4, ror pc
    1360:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 1368 <shift+0x1368>
    1364:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1368:	6a656e69 	bvs	195cd14 <__bss_end+0x1953194>
    136c:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
    1370:	5a5f0074 	bpl	17c1548 <__bss_end+0x17b79c8>
    1374:	746f6e36 	strbtvc	r6, [pc], #-3638	; 137c <shift+0x137c>
    1378:	6a796669 	bvs	1e5ad24 <__bss_end+0x1e511a4>
    137c:	5a5f006a 	bpl	17c152c <__bss_end+0x17b79ac>
    1380:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
    1384:	616e696d 	cmnvs	lr, sp, ror #18
    1388:	00696574 	rsbeq	r6, r9, r4, ror r5
    138c:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    1390:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
    1394:	646f6374 	strbtvs	r6, [pc], #-884	; 139c <shift+0x139c>
    1398:	5a5f0065 	bpl	17c1534 <__bss_end+0x17b79b4>
    139c:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
    13a0:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    13a4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    13a8:	6f72705f 	svcvs	0x0072705f
    13ac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    13b0:	756f635f 	strbvc	r6, [pc, #-863]!	; 1059 <shift+0x1059>
    13b4:	0076746e 	rsbseq	r7, r6, lr, ror #8
    13b8:	6b636974 	blvs	18db990 <__bss_end+0x18d1e10>
    13bc:	756f635f 	strbvc	r6, [pc, #-863]!	; 1065 <shift+0x1065>
    13c0:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
    13c4:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
    13c8:	00646572 	rsbeq	r6, r4, r2, ror r5
    13cc:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
    13d0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    13d4:	72505f65 	subsvc	r5, r0, #404	; 0x194
    13d8:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
    13dc:	315a5f00 	cmpcc	sl, r0, lsl #30
    13e0:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    13e4:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    13e8:	6f635f6b 	svcvs	0x00635f6b
    13ec:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    13f0:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
    13f4:	73007065 	movwvc	r7, #101	; 0x65
    13f8:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1400 <shift+0x1400>
    13fc:	5f6b7361 	svcpl	0x006b7361
    1400:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1404:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1408:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    140c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1410:	5f006e6f 	svcpl	0x00006e6f
    1414:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1418:	6a65736f 	bvs	195e1dc <__bss_end+0x195465c>
    141c:	6f682f00 	svcvs	0x00682f00
    1420:	6a2f656d 	bvs	bda9dc <__bss_end+0xbd0e5c>
    1424:	73656d61 	cmnvc	r5, #6208	; 0x1840
    1428:	2f697261 	svccs	0x00697261
    142c:	2f746967 	svccs	0x00746967
    1430:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    1434:	6f732f70 	svcvs	0x00732f70
    1438:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    143c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1440:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1444:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1448:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    144c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    1450:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1454:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1458:	70746567 	rsbsvc	r6, r4, r7, ror #10
    145c:	00766469 	rsbseq	r6, r6, r9, ror #8
    1460:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    1464:	6f6e0065 	svcvs	0x006e0065
    1468:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    146c:	63697400 	cmnvs	r9, #0, 8
    1470:	6f00736b 	svcvs	0x0000736b
    1474:	006e6570 	rsbeq	r6, lr, r0, ror r5
    1478:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    147c:	50657069 	rsbpl	r7, r5, r9, rrx
    1480:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1484:	6165444e 	cmnvs	r5, lr, asr #8
    1488:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    148c:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    1490:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    1494:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1498:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    149c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    14a0:	6f635f6b 	svcvs	0x00635f6b
    14a4:	00746e75 	rsbseq	r6, r4, r5, ror lr
    14a8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 13f4 <shift+0x13f4>
    14ac:	616a2f65 	cmnvs	sl, r5, ror #30
    14b0:	6173656d 	cmnvs	r3, sp, ror #10
    14b4:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    14b8:	6f2f7469 	svcvs	0x002f7469
    14bc:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    14c0:	756f732f 	strbvc	r7, [pc, #-815]!	; 1199 <shift+0x1199>
    14c4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    14c8:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    14cc:	7000646c 	andvc	r6, r0, ip, ror #8
    14d0:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    14d4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    14d8:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    14dc:	4b506a65 	blmi	141be78 <__bss_end+0x14122f8>
    14e0:	67006a63 	strvs	r6, [r0, -r3, ror #20]
    14e4:	745f7465 	ldrbvc	r7, [pc], #-1125	; 14ec <shift+0x14ec>
    14e8:	5f6b7361 	svcpl	0x006b7361
    14ec:	6b636974 	blvs	18dbac4 <__bss_end+0x18d1f44>
    14f0:	6f745f73 	svcvs	0x00745f73
    14f4:	6165645f 	cmnvs	r5, pc, asr r4
    14f8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    14fc:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1500:	00657469 	rsbeq	r7, r5, r9, ror #8
    1504:	5f667562 	svcpl	0x00667562
    1508:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
    150c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1510:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    1514:	006a6a70 	rsbeq	r6, sl, r0, ror sl
    1518:	5f746547 	svcpl	0x00746547
    151c:	616d6552 	cmnvs	sp, r2, asr r5
    1520:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
    1524:	5a5f0067 	bpl	17c16c8 <__bss_end+0x17b7b48>
    1528:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
    152c:	61745f74 	cmnvs	r4, r4, ror pc
    1530:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 1538 <shift+0x1538>
    1534:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1538:	5f6f745f 	svcpl	0x006f745f
    153c:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1540:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1544:	534e0076 	movtpl	r0, #57462	; 0xe076
    1548:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    154c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1550:	6f435f74 	svcvs	0x00435f74
    1554:	77006564 	strvc	r6, [r0, -r4, ror #10]
    1558:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
    155c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1560:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1564:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
    1568:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    156c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1570:	4e36316a 	rsfmisz	f3, f6, #2.0
    1574:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1578:	704f5f6c 	subvc	r5, pc, ip, ror #30
    157c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1580:	506e6f69 	rsbpl	r6, lr, r9, ror #30
    1584:	6f690076 	svcvs	0x00690076
    1588:	006c7463 	rsbeq	r7, ip, r3, ror #8
    158c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1590:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    1594:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1598:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    159c:	5f007265 	svcpl	0x00007265
    15a0:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
    15a4:	506a6461 	rsbpl	r6, sl, r1, ror #8
    15a8:	72006a63 	andvc	r6, r0, #405504	; 0x63000
    15ac:	6f637465 	svcvs	0x00637465
    15b0:	67006564 	strvs	r6, [r0, -r4, ror #10]
    15b4:	615f7465 	cmpvs	pc, r5, ror #8
    15b8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    15bc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    15c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    15c4:	6f635f73 	svcvs	0x00635f73
    15c8:	00746e75 	rsbseq	r6, r4, r5, ror lr
    15cc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    15d0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    15d4:	61657200 	cmnvs	r5, r0, lsl #4
    15d8:	65740064 	ldrbvs	r0, [r4, #-100]!	; 0xffffff9c
    15dc:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    15e0:	00657461 	rsbeq	r7, r5, r1, ror #8
    15e4:	70746567 	rsbsvc	r6, r4, r7, ror #10
    15e8:	5f006469 	svcpl	0x00006469
    15ec:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    15f0:	4b506e65 	blmi	141cf8c <__bss_end+0x141340c>
    15f4:	4e353163 	rsfmisz	f3, f5, f3
    15f8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    15fc:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1600:	6f4d5f6e 	svcvs	0x004d5f6e
    1604:	47006564 	strmi	r6, [r0, -r4, ror #10]
    1608:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    160c:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    1610:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1614:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1618:	31393130 	teqcc	r9, r0, lsr r1
    161c:	20353230 	eorscs	r3, r5, r0, lsr r2
    1620:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1624:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1628:	415b2029 	cmpmi	fp, r9, lsr #32
    162c:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1630:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1634:	6172622d 	cmnvs	r2, sp, lsr #4
    1638:	2068636e 	rsbcs	r6, r8, lr, ror #6
    163c:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1640:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1644:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1648:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    164c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1650:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1654:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1658:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    165c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1660:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1664:	20706676 	rsbscs	r6, r0, r6, ror r6
    1668:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    166c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1670:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1674:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1678:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    167c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1680:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1684:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    1688:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    168c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1690:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1694:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    1698:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    169c:	616d2d20 	cmnvs	sp, r0, lsr #26
    16a0:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    16a4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    16a8:	2b6b7a36 	blcs	1adff88 <__bss_end+0x1ad6408>
    16ac:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    16b0:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    16b4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    16b8:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    16bc:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    16c0:	6f6e662d 	svcvs	0x006e662d
    16c4:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    16c8:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    16cc:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    16d0:	6f6e662d 	svcvs	0x006e662d
    16d4:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    16d8:	5a5f0069 	bpl	17c1884 <__bss_end+0x17b7d04>
    16dc:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    16e0:	50797063 	rsbspl	r7, r9, r3, rrx
    16e4:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    16e8:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    16ec:	2f656d6f 	svccs	0x00656d6f
    16f0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    16f4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    16f8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    16fc:	2f736f2f 	svccs	0x00736f2f
    1700:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1704:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1708:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    170c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1710:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1714:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1718:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    171c:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1720:	00707063 	rsbseq	r7, r0, r3, rrx
    1724:	616d6572 	smcvs	54866	; 0xd652
    1728:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    172c:	73690072 	cmnvc	r9, #114	; 0x72
    1730:	006e616e 	rsbeq	r6, lr, lr, ror #2
    1734:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1738:	6c617267 	sfmvs	f7, 2, [r1], #-412	; 0xfffffe64
    173c:	69736900 	ldmdbvs	r3!, {r8, fp, sp, lr}^
    1740:	6400666e 	strvs	r6, [r0], #-1646	; 0xfffff992
    1744:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1748:	5f006c61 	svcpl	0x00006c61
    174c:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1750:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1754:	61006a63 	tstvs	r0, r3, ror #20
    1758:	00696f74 	rsbeq	r6, r9, r4, ror pc
    175c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1760:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1764:	73006e65 	movwvc	r6, #3685	; 0xe65
    1768:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    176c:	65645f67 	strbvs	r5, [r4, #-3943]!	; 0xfffff099
    1770:	616d6963 	cmnvs	sp, r3, ror #18
    1774:	7000736c 	andvc	r7, r0, ip, ror #6
    1778:	7265776f 	rsbvc	r7, r5, #29097984	; 0x1bc0000
    177c:	72747300 	rsbsvc	r7, r4, #0, 6
    1780:	5f676e69 	svcpl	0x00676e69
    1784:	5f746e69 	svcpl	0x00746e69
    1788:	006e656c 	rsbeq	r6, lr, ip, ror #10
    178c:	6f707865 	svcvs	0x00707865
    1790:	746e656e 	strbtvc	r6, [lr], #-1390	; 0xfffffa92
    1794:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1798:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    179c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    17a0:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    17a4:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    17a8:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    17ac:	63507274 	cmpvs	r0, #116, 4	; 0x40000007
    17b0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    17b4:	616e7369 	cmnvs	lr, r9, ror #6
    17b8:	6900666e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, sp, lr}
    17bc:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    17c0:	73616200 	cmnvc	r1, #0, 4
    17c4:	65740065 	ldrbvs	r0, [r4, #-101]!	; 0xffffff9b
    17c8:	5f00706d 	svcpl	0x0000706d
    17cc:	7a62355a 	bvc	188ed3c <__bss_end+0x18851bc>
    17d0:	506f7265 	rsbpl	r7, pc, r5, ror #4
    17d4:	73006976 	movwvc	r6, #2422	; 0x976
    17d8:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17dc:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    17e0:	00616f74 	rsbeq	r6, r1, r4, ror pc
    17e4:	31727473 	cmncc	r2, r3, ror r4
    17e8:	72747300 	rsbsvc	r7, r4, #0, 6
    17ec:	5f676e69 	svcpl	0x00676e69
    17f0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    17f4:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    17f8:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    17fc:	5a5f0066 	bpl	17c199c <__bss_end+0x17b7e1c>
    1800:	776f7033 			; <UNDEFINED> instruction: 0x776f7033
    1804:	5f006a66 	svcpl	0x00006a66
    1808:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    180c:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    1810:	6f6c665f 	svcvs	0x006c665f
    1814:	52667461 	rsbpl	r7, r6, #1627389952	; 0x61000000
    1818:	525f536a 	subspl	r5, pc, #-1476395007	; 0xa8000001
    181c:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    1820:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1824:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1828:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    182c:	6f437261 	svcvs	0x00437261
    1830:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1834:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    1838:	5f00616f 	svcpl	0x0000616f
    183c:	6433325a 	ldrtvs	r3, [r3], #-602	; 0xfffffda6
    1840:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1844:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 184c <shift+0x184c>
    1848:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    184c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1850:	6f6c665f 	svcvs	0x006c665f
    1854:	506a7461 	rsbpl	r7, sl, r1, ror #8
    1858:	6d006963 	vstrvs.16	s12, [r0, #-198]	; 0xffffff3a	; <UNPREDICTABLE>
    185c:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    1860:	72700063 	rsbsvc	r0, r0, #99	; 0x63
    1864:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    1868:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    186c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1870:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1874:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1878:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
    187c:	73007865 	movwvc	r7, #2149	; 0x865
    1880:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1884:	6400706d 	strvs	r7, [r0], #-109	; 0xffffff93
    1888:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    188c:	5a5f0073 	bpl	17c1a60 <__bss_end+0x17b7ee0>
    1890:	6f746134 	svcvs	0x00746134
    1894:	634b5069 	movtvs	r5, #45161	; 0xb069
    1898:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    189c:	00747570 	rsbseq	r7, r4, r0, ror r5
    18a0:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    18a4:	66616f74 	uqsub16vs	r6, r1, r4
    18a8:	006a6350 	rsbeq	r6, sl, r0, asr r3
    18ac:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    18b0:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    18b4:	0074616f 	rsbseq	r6, r4, pc, ror #2
    18b8:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    18bc:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    18c0:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    18c4:	4b506e65 	blmi	141d260 <__bss_end+0x14136e0>
    18c8:	5a5f0063 	bpl	17c1a5c <__bss_end+0x17b7edc>
    18cc:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    18d0:	706d636e 	rsbvc	r6, sp, lr, ror #6
    18d4:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    18d8:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    18dc:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    18e0:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    18e4:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    18e8:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    18ec:	63656400 	cmnvs	r5, #0, 8
    18f0:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    18f4:	5f6f745f 	svcpl	0x006f745f
    18f8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    18fc:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    1900:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1904:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1908:	616f7466 	cmnvs	pc, r6, ror #8
    190c:	00635066 	rsbeq	r5, r3, r6, rrx
    1910:	6f6d656d 	svcvs	0x006d656d
    1914:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    1918:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    191c:	74730068 	ldrbtvc	r0, [r3], #-104	; 0xffffff98
    1920:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1924:	76657200 	strbtvc	r7, [r5], -r0, lsl #4
    1928:	00727473 	rsbseq	r7, r2, r3, ror r4
    192c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1930:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1934:	2f2e2e2f 	svccs	0x002e2e2f
    1938:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    193c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1940:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1944:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1948:	2f676966 	svccs	0x00676966
    194c:	2f6d7261 	svccs	0x006d7261
    1950:	3162696c 	cmncc	r2, ip, ror #18
    1954:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1958:	00532e73 	subseq	r2, r3, r3, ror lr
    195c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1960:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1964:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1968:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    196c:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1970:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1974:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1978:	2f39546b 	svccs	0x0039546b
    197c:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1980:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1984:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1988:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    198c:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1990:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1994:	2f34712d 	svccs	0x0034712d
    1998:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    199c:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    19a0:	6f6e2d6d 	svcvs	0x006e2d6d
    19a4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    19a8:	2f696261 	svccs	0x00696261
    19ac:	2f6d7261 	svccs	0x006d7261
    19b0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    19b4:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    19b8:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    19bc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    19c0:	52415400 	subpl	r5, r1, #0, 8
    19c4:	5f544547 	svcpl	0x00544547
    19c8:	5f555043 	svcpl	0x00555043
    19cc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19d0:	31617865 	cmncc	r1, r5, ror #16
    19d4:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    19d8:	61786574 	cmnvs	r8, r4, ror r5
    19dc:	73690037 	cmnvc	r9, #55	; 0x37
    19e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19e4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    19e8:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    19ec:	6d726100 	ldfvse	f6, [r2, #-0]
    19f0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    19f4:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    19f8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    19fc:	52415400 	subpl	r5, r1, #0, 8
    1a00:	5f544547 	svcpl	0x00544547
    1a04:	5f555043 	svcpl	0x00555043
    1a08:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a0c:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1a10:	52410033 	subpl	r0, r1, #51	; 0x33
    1a14:	51455f4d 	cmppl	r5, sp, asr #30
    1a18:	52415400 	subpl	r5, r1, #0, 8
    1a1c:	5f544547 	svcpl	0x00544547
    1a20:	5f555043 	svcpl	0x00555043
    1a24:	316d7261 	cmncc	sp, r1, ror #4
    1a28:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1a2c:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1a30:	5f617369 	svcpl	0x00617369
    1a34:	5f746962 	svcpl	0x00746962
    1a38:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1a3c:	41540062 	cmpmi	r4, r2, rrx
    1a40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a48:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a4c:	61786574 	cmnvs	r8, r4, ror r5
    1a50:	6f633735 	svcvs	0x00633735
    1a54:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a58:	00333561 	eorseq	r3, r3, r1, ror #10
    1a5c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a60:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a64:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1a68:	5341425f 	movtpl	r4, #4703	; 0x125f
    1a6c:	41540045 	cmpmi	r4, r5, asr #32
    1a70:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a74:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a78:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a7c:	00303138 	eorseq	r3, r0, r8, lsr r1
    1a80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a88:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1a8c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1a90:	52410031 	subpl	r0, r1, #49	; 0x31
    1a94:	43505f4d 	cmpmi	r0, #308	; 0x134
    1a98:	41415f53 	cmpmi	r1, r3, asr pc
    1a9c:	5f534350 	svcpl	0x00534350
    1aa0:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1aa4:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1aa8:	5f455341 	svcpl	0x00455341
    1aac:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ab0:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1ab4:	5f455341 	svcpl	0x00455341
    1ab8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1abc:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1ac0:	5f455341 	svcpl	0x00455341
    1ac4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ac8:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1acc:	5f455341 	svcpl	0x00455341
    1ad0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ad4:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1ad8:	5f455341 	svcpl	0x00455341
    1adc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ae0:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1ae4:	5f455341 	svcpl	0x00455341
    1ae8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1aec:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1af0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1af4:	50435f54 	subpl	r5, r3, r4, asr pc
    1af8:	73785f55 	cmnvc	r8, #340	; 0x154
    1afc:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1b00:	61736900 	cmnvs	r3, r0, lsl #18
    1b04:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b08:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1b0c:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1b10:	52415400 	subpl	r5, r1, #0, 8
    1b14:	5f544547 	svcpl	0x00544547
    1b18:	5f555043 	svcpl	0x00555043
    1b1c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b20:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1b24:	41540033 	cmpmi	r4, r3, lsr r0
    1b28:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b2c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b30:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b34:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1b38:	73690069 	cmnvc	r9, #105	; 0x69
    1b3c:	6f6e5f61 	svcvs	0x006e5f61
    1b40:	00746962 	rsbseq	r6, r4, r2, ror #18
    1b44:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b48:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b4c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b50:	31316d72 	teqcc	r1, r2, ror sp
    1b54:	7a6a3637 	bvc	1a8f438 <__bss_end+0x1a858b8>
    1b58:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1b5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b60:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1b64:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1b68:	4d524100 	ldfmie	f4, [r2, #-0]
    1b6c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1b70:	4b4e555f 	blmi	13970f4 <__bss_end+0x138d574>
    1b74:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1b78:	52415400 	subpl	r5, r1, #0, 8
    1b7c:	5f544547 	svcpl	0x00544547
    1b80:	5f555043 	svcpl	0x00555043
    1b84:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1b88:	41420065 	cmpmi	r2, r5, rrx
    1b8c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b90:	5f484352 	svcpl	0x00484352
    1b94:	4a455435 	bmi	1156c70 <__bss_end+0x114d0f0>
    1b98:	6d726100 	ldfvse	f6, [r2, #-0]
    1b9c:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1ba0:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1ba4:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1ba8:	6d726100 	ldfvse	f6, [r2, #-0]
    1bac:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1bb0:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1bb4:	736e7500 	cmnvc	lr, #0, 10
    1bb8:	5f636570 	svcpl	0x00636570
    1bbc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1bc0:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1bc4:	5f617369 	svcpl	0x00617369
    1bc8:	5f746962 	svcpl	0x00746962
    1bcc:	00636573 	rsbeq	r6, r3, r3, ror r5
    1bd0:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1bd4:	61745f7a 	cmnvs	r4, sl, ror pc
    1bd8:	52410062 	subpl	r0, r1, #98	; 0x62
    1bdc:	43565f4d 	cmpmi	r6, #308	; 0x134
    1be0:	6d726100 	ldfvse	f6, [r2, #-0]
    1be4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1be8:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1bec:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1bf0:	4d524100 	ldfmie	f4, [r2, #-0]
    1bf4:	00454c5f 	subeq	r4, r5, pc, asr ip
    1bf8:	5f4d5241 	svcpl	0x004d5241
    1bfc:	41005356 	tstmi	r0, r6, asr r3
    1c00:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1c04:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1c08:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1c0c:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1c10:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1c14:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1c18:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1c20 <shift+0x1c20>
    1c1c:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1c20:	6f6c6620 	svcvs	0x006c6620
    1c24:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1c28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c30:	6f635f55 	svcvs	0x00635f55
    1c34:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c38:	00353161 	eorseq	r3, r5, r1, ror #2
    1c3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c44:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1c48:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1c4c:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1c50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c54:	50435f54 	subpl	r5, r3, r4, asr pc
    1c58:	6f635f55 	svcvs	0x00635f55
    1c5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c60:	00373161 	eorseq	r3, r7, r1, ror #2
    1c64:	5f4d5241 	svcpl	0x004d5241
    1c68:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1c6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c70:	50435f54 	subpl	r5, r3, r4, asr pc
    1c74:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1c78:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1c7c:	316e6573 	smccc	58963	; 0xe653
    1c80:	2f2e2e00 	svccs	0x002e2e00
    1c84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c88:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c8c:	2f2e2e2f 	svccs	0x002e2e2f
    1c90:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1be0 <shift+0x1be0>
    1c94:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c98:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1c9c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1ca0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1ca4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1cb0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1cb4:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1cb8:	53414200 	movtpl	r4, #4608	; 0x1200
    1cbc:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cc0:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1cc4:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1cc8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ccc:	50435f54 	subpl	r5, r3, r4, asr pc
    1cd0:	6f635f55 	svcvs	0x00635f55
    1cd4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cd8:	00323161 	eorseq	r3, r2, r1, ror #2
    1cdc:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1ce0:	5f6c6176 	svcpl	0x006c6176
    1ce4:	41420074 	hvcmi	8196	; 0x2004
    1ce8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1cec:	5f484352 	svcpl	0x00484352
    1cf0:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1cf4:	5f617369 	svcpl	0x00617369
    1cf8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1cfc:	6d726100 	ldfvse	f6, [r2, #-0]
    1d00:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1d04:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1d08:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1d0c:	00766964 	rsbseq	r6, r6, r4, ror #18
    1d10:	5f6d7261 	svcpl	0x006d7261
    1d14:	5f757066 	svcpl	0x00757066
    1d18:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1d1c:	61736900 	cmnvs	r3, r0, lsl #18
    1d20:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d24:	3170665f 	cmncc	r0, pc, asr r6
    1d28:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1d2c:	31432055 	qdaddcc	r2, r5, r3
    1d30:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1d34:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1d38:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1d3c:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1d40:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1d44:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1d48:	5b202965 	blpl	80c2e4 <__bss_end+0x802764>
    1d4c:	2f4d5241 	svccs	0x004d5241
    1d50:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1d54:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1d58:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1d5c:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1d60:	6f697369 	svcvs	0x00697369
    1d64:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1d68:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1d6c:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1d70:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1d74:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1d78:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1d7c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1d80:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1d84:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d88:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1d8c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d90:	2b657435 	blcs	195ee6c <__bss_end+0x19552ec>
    1d94:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1d98:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1d9c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1da0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1da4:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1da8:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1dac:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1db0:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1db4:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1db8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1dbc:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1dc0:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1dc4:	6b636174 	blvs	18da39c <__bss_end+0x18d081c>
    1dc8:	6f72702d 	svcvs	0x0072702d
    1dcc:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1dd0:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1dd4:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1c44 <shift+0x1c44>
    1dd8:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1ddc:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1de0:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1de4:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1de8:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1dec:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1df0:	41006e65 	tstmi	r0, r5, ror #28
    1df4:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1df8:	73690049 	cmnvc	r9, #73	; 0x49
    1dfc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e00:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1e04:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1e08:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e0c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e10:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e14:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1e18:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1e1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e24:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e28:	00386d72 	eorseq	r6, r8, r2, ror sp
    1e2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e34:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e38:	00396d72 	eorseq	r6, r9, r2, ror sp
    1e3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e44:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1e48:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1e4c:	6d726100 	ldfvse	f6, [r2, #-0]
    1e50:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e54:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    1e58:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1e5c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e60:	50435f54 	subpl	r5, r3, r4, asr pc
    1e64:	6f635f55 	svcvs	0x00635f55
    1e68:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e6c:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1e70:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e74:	50435f54 	subpl	r5, r3, r4, asr pc
    1e78:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e7c:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1e80:	52415400 	subpl	r5, r1, #0, 8
    1e84:	5f544547 	svcpl	0x00544547
    1e88:	5f555043 	svcpl	0x00555043
    1e8c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e90:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1e94:	6d726100 	ldfvse	f6, [r2, #-0]
    1e98:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1e9c:	6f635f64 	svcvs	0x00635f64
    1ea0:	41006564 	tstmi	r0, r4, ror #10
    1ea4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1ea8:	415f5343 	cmpmi	pc, r3, asr #6
    1eac:	53435041 	movtpl	r5, #12353	; 0x3041
    1eb0:	61736900 	cmnvs	r3, r0, lsl #18
    1eb4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1eb8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ebc:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1ec0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ec4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ec8:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1ecc:	4154004d 	cmpmi	r4, sp, asr #32
    1ed0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ed4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ed8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1edc:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1ee0:	6d726100 	ldfvse	f6, [r2, #-0]
    1ee4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ee8:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1eec:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ef0:	73690032 	cmnvc	r9, #50	; 0x32
    1ef4:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1ef8:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1efc:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1f00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f04:	50435f54 	subpl	r5, r3, r4, asr pc
    1f08:	6f635f55 	svcvs	0x00635f55
    1f0c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f10:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1f14:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1f18:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1f1c:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1f20:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1f24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f2c:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 19e4 <shift+0x19e4>
    1f30:	6f6e7978 	svcvs	0x006e7978
    1f34:	00316d73 	eorseq	r6, r1, r3, ror sp
    1f38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f40:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f44:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f48:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    1f4c:	61736900 	cmnvs	r3, r0, lsl #18
    1f50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f54:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1f58:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1f5c:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1f60:	6f656e5f 	svcvs	0x00656e5f
    1f64:	6f665f6e 	svcvs	0x00665f6e
    1f68:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    1f6c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f70:	61736900 	cmnvs	r3, r0, lsl #18
    1f74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f78:	3170665f 	cmncc	r0, pc, asr r6
    1f7c:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1f80:	52415400 	subpl	r5, r1, #0, 8
    1f84:	5f544547 	svcpl	0x00544547
    1f88:	5f555043 	svcpl	0x00555043
    1f8c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f90:	33617865 	cmncc	r1, #6619136	; 0x650000
    1f94:	41540032 	cmpmi	r4, r2, lsr r0
    1f98:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f9c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fa0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fa4:	61786574 	cmnvs	r8, r4, ror r5
    1fa8:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1fac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fb0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1fb4:	63363170 	teqvs	r6, #112, 2
    1fb8:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1fbc:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1fc0:	5f766365 	svcpl	0x00766365
    1fc4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1fc8:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1fcc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fd0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fd4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fd8:	31316d72 	teqcc	r1, r2, ror sp
    1fdc:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1fe0:	41540073 	cmpmi	r4, r3, ror r0
    1fe4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fe8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fec:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1ff0:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1ff4:	52415400 	subpl	r5, r1, #0, 8
    1ff8:	5f544547 	svcpl	0x00544547
    1ffc:	5f555043 	svcpl	0x00555043
    2000:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2004:	6a653632 	bvs	194f8d4 <__bss_end+0x1945d54>
    2008:	41420073 	hvcmi	8195	; 0x2003
    200c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2010:	5f484352 	svcpl	0x00484352
    2014:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    2018:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    201c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2020:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    2024:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    2028:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    202c:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2030:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    2034:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    2038:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    203c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2040:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2044:	41420062 	cmpmi	r2, r2, rrx
    2048:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    204c:	5f484352 	svcpl	0x00484352
    2050:	00455435 	subeq	r5, r5, r5, lsr r4
    2054:	5f617369 	svcpl	0x00617369
    2058:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    205c:	00657275 	rsbeq	r7, r5, r5, ror r2
    2060:	5f617369 	svcpl	0x00617369
    2064:	5f746962 	svcpl	0x00746962
    2068:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    206c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2070:	6d726100 	ldfvse	f6, [r2, #-0]
    2074:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    2078:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 1119 <shift+0x1119>
    207c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    2080:	6a626f5f 	bvs	189de04 <__bss_end+0x1894284>
    2084:	5f746365 	svcpl	0x00746365
    2088:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    208c:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    2090:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2094:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    2098:	5f617369 	svcpl	0x00617369
    209c:	5f746962 	svcpl	0x00746962
    20a0:	645f7066 	ldrbvs	r7, [pc], #-102	; 20a8 <shift+0x20a8>
    20a4:	41003233 	tstmi	r0, r3, lsr r2
    20a8:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    20ac:	73690045 	cmnvc	r9, #69	; 0x45
    20b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20b4:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    20b8:	41540038 	cmpmi	r4, r8, lsr r0
    20bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20c8:	36373131 			; <UNDEFINED> instruction: 0x36373131
    20cc:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    20d0:	636f7270 	cmnvs	pc, #112, 4
    20d4:	6f737365 	svcvs	0x00737365
    20d8:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    20dc:	61006570 	tstvs	r0, r0, ror r5
    20e0:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    20e4:	00737570 	rsbseq	r7, r3, r0, ror r5
    20e8:	5f6d7261 	svcpl	0x006d7261
    20ec:	00736370 	rsbseq	r6, r3, r0, ror r3
    20f0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20f4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20f8:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    20fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2100:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2104:	00743468 	rsbseq	r3, r4, r8, ror #8
    2108:	47524154 			; <UNDEFINED> instruction: 0x47524154
    210c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2110:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2114:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2118:	36376178 			; <UNDEFINED> instruction: 0x36376178
    211c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2120:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2124:	72610035 	rsbvc	r0, r1, #53	; 0x35
    2128:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    212c:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    2130:	00667562 	rsbeq	r7, r6, r2, ror #10
    2134:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2138:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    213c:	73690068 	cmnvc	r9, #104	; 0x68
    2140:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2144:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2148:	5f6b7269 	svcpl	0x006b7269
    214c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2150:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2154:	5f656c69 	svcpl	0x00656c69
    2158:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    215c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2160:	50435f54 	subpl	r5, r3, r4, asr pc
    2164:	6f635f55 	svcvs	0x00635f55
    2168:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    216c:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    2170:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2174:	50435f54 	subpl	r5, r3, r4, asr pc
    2178:	6f635f55 	svcvs	0x00635f55
    217c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2180:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    2184:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2188:	50435f54 	subpl	r5, r3, r4, asr pc
    218c:	6f635f55 	svcvs	0x00635f55
    2190:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2194:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    2198:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    219c:	615f7469 	cmpvs	pc, r9, ror #8
    21a0:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    21a4:	6100315f 	tstvs	r0, pc, asr r1
    21a8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    21ac:	5f686372 	svcpl	0x00686372
    21b0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    21b4:	61736900 	cmnvs	r3, r0, lsl #18
    21b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21c0:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    21c4:	61736900 	cmnvs	r3, r0, lsl #18
    21c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21d0:	345f3876 	ldrbcc	r3, [pc], #-2166	; 21d8 <shift+0x21d8>
    21d4:	61736900 	cmnvs	r3, r0, lsl #18
    21d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21e0:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 1972 <shift+0x1972>
    21e4:	52415400 	subpl	r5, r1, #0, 8
    21e8:	5f544547 	svcpl	0x00544547
    21ec:	5f555043 	svcpl	0x00555043
    21f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21f4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    21f8:	41540033 	cmpmi	r4, r3, lsr r0
    21fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2200:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2204:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2208:	61786574 	cmnvs	r8, r4, ror r5
    220c:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    2210:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2214:	50435f54 	subpl	r5, r3, r4, asr pc
    2218:	6f635f55 	svcvs	0x00635f55
    221c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2220:	00373561 	eorseq	r3, r7, r1, ror #10
    2224:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2228:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    222c:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20f4 <shift+0x20f4>
    2230:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2234:	41540065 	cmpmi	r4, r5, rrx
    2238:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    223c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2240:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2244:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    2248:	72610065 	rsbvc	r0, r1, #101	; 0x65
    224c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2250:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2254:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2258:	47524154 			; <UNDEFINED> instruction: 0x47524154
    225c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2260:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2264:	30316d72 	eorscc	r6, r1, r2, ror sp
    2268:	6a653632 	bvs	194fb38 <__bss_end+0x1945fb8>
    226c:	41420073 	hvcmi	8195	; 0x2003
    2270:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2274:	5f484352 	svcpl	0x00484352
    2278:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    227c:	5f455341 	svcpl	0x00455341
    2280:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2284:	004b365f 	subeq	r3, fp, pc, asr r6
    2288:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    228c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2290:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    2294:	61736900 	cmnvs	r3, r0, lsl #18
    2298:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    229c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    22a0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    22a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    22b0:	31316d72 	teqcc	r1, r2, ror sp
    22b4:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    22b8:	52410073 	subpl	r0, r1, #115	; 0x73
    22bc:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    22c0:	4d524100 	ldfmie	f4, [r2, #-0]
    22c4:	00544c5f 	subseq	r4, r4, pc, asr ip
    22c8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    22cc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    22d0:	5a365f48 	bpl	d99ff8 <__bss_end+0xd90478>
    22d4:	52415400 	subpl	r5, r1, #0, 8
    22d8:	5f544547 	svcpl	0x00544547
    22dc:	5f555043 	svcpl	0x00555043
    22e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22e8:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    22ec:	61786574 	cmnvs	r8, r4, ror r5
    22f0:	41003535 	tstmi	r0, r5, lsr r5
    22f4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    22f8:	415f5343 	cmpmi	pc, r3, asr #6
    22fc:	53435041 	movtpl	r5, #12353	; 0x3041
    2300:	5046565f 	subpl	r5, r6, pc, asr r6
    2304:	52415400 	subpl	r5, r1, #0, 8
    2308:	5f544547 	svcpl	0x00544547
    230c:	5f555043 	svcpl	0x00555043
    2310:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2314:	00327478 	eorseq	r7, r2, r8, ror r4
    2318:	5f617369 	svcpl	0x00617369
    231c:	5f746962 	svcpl	0x00746962
    2320:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    2324:	6d726100 	ldfvse	f6, [r2, #-0]
    2328:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    232c:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2330:	73690072 	cmnvc	r9, #114	; 0x72
    2334:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2338:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    233c:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    2340:	4154006d 	cmpmi	r4, sp, rrx
    2344:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2348:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    234c:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    2350:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    2354:	52415400 	subpl	r5, r1, #0, 8
    2358:	5f544547 	svcpl	0x00544547
    235c:	5f555043 	svcpl	0x00555043
    2360:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    2364:	5f6c6c65 	svcpl	0x006c6c65
    2368:	00346a70 	eorseq	r6, r4, r0, ror sl
    236c:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2370:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    2374:	6f705f68 	svcvs	0x00705f68
    2378:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    237c:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2380:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2384:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    2388:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    238c:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2390:	61736900 	cmnvs	r3, r0, lsl #18
    2394:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2398:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    239c:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    23a0:	52415400 	subpl	r5, r1, #0, 8
    23a4:	5f544547 	svcpl	0x00544547
    23a8:	5f555043 	svcpl	0x00555043
    23ac:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23b0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23b4:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    23b8:	61786574 	cmnvs	r8, r4, ror r5
    23bc:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    23c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23c4:	745f7469 	ldrbvc	r7, [pc], #-1129	; 23cc <shift+0x23cc>
    23c8:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    23cc:	41420032 	cmpmi	r2, r2, lsr r0
    23d0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    23d4:	5f484352 	svcpl	0x00484352
    23d8:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    23dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23e0:	645f7469 	ldrbvs	r7, [pc], #-1129	; 23e8 <shift+0x23e8>
    23e4:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    23e8:	6100646f 	tstvs	r0, pc, ror #8
    23ec:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    23f0:	5f363170 	svcpl	0x00363170
    23f4:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23f8:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 2400 <shift+0x2400>
    23fc:	52410065 	subpl	r0, r1, #101	; 0x65
    2400:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    2404:	6d726100 	ldfvse	f6, [r2, #-0]
    2408:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    240c:	006b3668 	rsbeq	r3, fp, r8, ror #12
    2410:	5f6d7261 	svcpl	0x006d7261
    2414:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2418:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    241c:	5f455341 	svcpl	0x00455341
    2420:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2424:	0052375f 	subseq	r3, r2, pc, asr r7
    2428:	6f705f5f 	svcvs	0x00705f5f
    242c:	756f6370 	strbvc	r6, [pc, #-880]!	; 20c4 <shift+0x20c4>
    2430:	745f746e 	ldrbvc	r7, [pc], #-1134	; 2438 <shift+0x2438>
    2434:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    2438:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    243c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2440:	0065736d 	rsbeq	r7, r5, sp, ror #6
    2444:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2448:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    244c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2450:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2454:	33376178 	teqcc	r7, #120, 2
    2458:	52415400 	subpl	r5, r1, #0, 8
    245c:	5f544547 	svcpl	0x00544547
    2460:	5f555043 	svcpl	0x00555043
    2464:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    2468:	76636972 			; <UNDEFINED> instruction: 0x76636972
    246c:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    2470:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2474:	50435f54 	subpl	r5, r3, r4, asr pc
    2478:	6f635f55 	svcvs	0x00635f55
    247c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2480:	00363761 	eorseq	r3, r6, r1, ror #14
    2484:	5f6d7261 	svcpl	0x006d7261
    2488:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    248c:	5f6f6e5f 	svcpl	0x006f6e5f
    2490:	616c6f76 	smcvs	50934	; 0xc6f6
    2494:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2498:	0065635f 	rsbeq	r6, r5, pc, asr r3
    249c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    24a0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    24a4:	41385f48 	teqmi	r8, r8, asr #30
    24a8:	61736900 	cmnvs	r3, r0, lsl #18
    24ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    24b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24b4:	00743576 	rsbseq	r3, r4, r6, ror r5
    24b8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    24bc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    24c0:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    24c4:	52415400 	subpl	r5, r1, #0, 8
    24c8:	5f544547 	svcpl	0x00544547
    24cc:	5f555043 	svcpl	0x00555043
    24d0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24d4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    24d8:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    24dc:	61786574 	cmnvs	r8, r4, ror r5
    24e0:	41003533 	tstmi	r0, r3, lsr r5
    24e4:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    24e8:	72610056 	rsbvc	r0, r1, #86	; 0x56
    24ec:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24f0:	00346863 	eorseq	r6, r4, r3, ror #16
    24f4:	5f6d7261 	svcpl	0x006d7261
    24f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24fc:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2500:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2504:	00376863 	eorseq	r6, r7, r3, ror #16
    2508:	5f6d7261 	svcpl	0x006d7261
    250c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2510:	6f6c0038 	svcvs	0x006c0038
    2514:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    2518:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    251c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2520:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2524:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    2528:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    252c:	616d0065 	cmnvs	sp, r5, rrx
    2530:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    2534:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    2538:	745f7473 	ldrbvc	r7, [pc], #-1139	; 2540 <shift+0x2540>
    253c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    2540:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    2544:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    2548:	5f6c6c61 	svcpl	0x006c6c61
    254c:	5f616976 	svcpl	0x00616976
    2550:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    2554:	7369006c 	cmnvc	r9, #108	; 0x6c
    2558:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    255c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2560:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2564:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2568:	615f7469 	cmpvs	pc, r9, ror #8
    256c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2570:	4154006b 	cmpmi	r4, fp, rrx
    2574:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2578:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    257c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2580:	61786574 	cmnvs	r8, r4, ror r5
    2584:	41540037 	cmpmi	r4, r7, lsr r0
    2588:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    258c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2590:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2594:	61786574 	cmnvs	r8, r4, ror r5
    2598:	41540038 	cmpmi	r4, r8, lsr r0
    259c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25a0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25a4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25a8:	61786574 	cmnvs	r8, r4, ror r5
    25ac:	52410039 	subpl	r0, r1, #57	; 0x39
    25b0:	43505f4d 	cmpmi	r0, #308	; 0x134
    25b4:	50415f53 	subpl	r5, r1, r3, asr pc
    25b8:	41005343 	tstmi	r0, r3, asr #6
    25bc:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    25c0:	415f5343 	cmpmi	pc, r3, asr #6
    25c4:	53435054 	movtpl	r5, #12372	; 0x3054
    25c8:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 25d0 <shift+0x25d0>
    25cc:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    25d0:	756f6420 	strbvc	r6, [pc, #-1056]!	; 21b8 <shift+0x21b8>
    25d4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    25d8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25dc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25e0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25e4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25e8:	33376178 	teqcc	r7, #120, 2
    25ec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25f0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25f4:	41540033 	cmpmi	r4, r3, lsr r0
    25f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2600:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2604:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2608:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    260c:	72610073 	rsbvc	r0, r1, #115	; 0x73
    2610:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    2614:	61736900 	cmnvs	r3, r0, lsl #18
    2618:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    261c:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    2620:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2624:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    2628:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    262c:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    2630:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    2634:	5f657265 	svcpl	0x00657265
    2638:	52415400 	subpl	r5, r1, #0, 8
    263c:	5f544547 	svcpl	0x00544547
    2640:	5f555043 	svcpl	0x00555043
    2644:	316d7261 	cmncc	sp, r1, ror #4
    2648:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    264c:	41540069 	cmpmi	r4, r9, rrx
    2650:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2654:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2658:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    265c:	61786574 	cmnvs	r8, r4, ror r5
    2660:	61620035 	cmnvs	r2, r5, lsr r0
    2664:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2668:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    266c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2670:	00657275 	rsbeq	r7, r5, r5, ror r2
    2674:	5f6d7261 	svcpl	0x006d7261
    2678:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    267c:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2680:	52415400 	subpl	r5, r1, #0, 8
    2684:	5f544547 	svcpl	0x00544547
    2688:	5f555043 	svcpl	0x00555043
    268c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2690:	316d7865 	cmncc	sp, r5, ror #16
    2694:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2698:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    269c:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    26a0:	72610079 	rsbvc	r0, r1, #121	; 0x79
    26a4:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    26a8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    26ac:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    26b0:	61736900 	cmnvs	r3, r0, lsl #18
    26b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26b8:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    26bc:	41003233 	tstmi	r0, r3, lsr r2
    26c0:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    26c4:	7369004c 	cmnvc	r9, #76	; 0x4c
    26c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26cc:	66765f74 	uhsub16vs	r5, r6, r4
    26d0:	00337670 	eorseq	r7, r3, r0, ror r6
    26d4:	5f617369 	svcpl	0x00617369
    26d8:	5f746962 	svcpl	0x00746962
    26dc:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26e0:	41420034 	cmpmi	r2, r4, lsr r0
    26e4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26e8:	5f484352 	svcpl	0x00484352
    26ec:	00325436 	eorseq	r5, r2, r6, lsr r4
    26f0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26f4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26f8:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    26fc:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    2700:	4154004e 	cmpmi	r4, lr, asr #32
    2704:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2708:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    270c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2710:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    2714:	52410069 	subpl	r0, r1, #105	; 0x69
    2718:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    271c:	53414200 	movtpl	r4, #4608	; 0x1200
    2720:	52415f45 	subpl	r5, r1, #276	; 0x114
    2724:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2728:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    272c:	61745f6d 	cmnvs	r4, sp, ror #30
    2730:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    2734:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    2738:	61006c65 	tstvs	r0, r5, ror #24
    273c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2744 <shift+0x2744>
    2740:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2744:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    2748:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    274c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2750:	50435f54 	subpl	r5, r3, r4, asr pc
    2754:	6f635f55 	svcvs	0x00635f55
    2758:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    275c:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    2760:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2764:	50435f54 	subpl	r5, r3, r4, asr pc
    2768:	6f635f55 	svcvs	0x00635f55
    276c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2770:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    2774:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2778:	50435f54 	subpl	r5, r3, r4, asr pc
    277c:	6f635f55 	svcvs	0x00635f55
    2780:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2784:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    2788:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    278c:	50435f54 	subpl	r5, r3, r4, asr pc
    2790:	6f635f55 	svcvs	0x00635f55
    2794:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2798:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    279c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27a0:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    27a4:	00656170 	rsbeq	r6, r5, r0, ror r1
    27a8:	5f617369 	svcpl	0x00617369
    27ac:	5f746962 	svcpl	0x00746962
    27b0:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    27b4:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    27b8:	6b36766d 	blvs	da0174 <__bss_end+0xd965f4>
    27bc:	7369007a 	cmnvc	r9, #122	; 0x7a
    27c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    27c4:	6f6e5f74 	svcvs	0x006e5f74
    27c8:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    27cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27d0:	615f7469 	cmpvs	pc, r9, ror #8
    27d4:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    27d8:	61736900 	cmnvs	r3, r0, lsl #18
    27dc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27e0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27e4:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    27e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27ec:	615f7469 	cmpvs	pc, r9, ror #8
    27f0:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    27f4:	61736900 	cmnvs	r3, r0, lsl #18
    27f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27fc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2800:	5f003876 	svcpl	0x00003876
    2804:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    2808:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    280c:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    2810:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2814:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    2818:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    281c:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    2820:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2824:	615f7469 	cmpvs	pc, r9, ror #8
    2828:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    282c:	61006574 	tstvs	r0, r4, ror r5
    2830:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2838 <shift+0x2838>
    2834:	00656e75 	rsbeq	r6, r5, r5, ror lr
    2838:	5f6d7261 	svcpl	0x006d7261
    283c:	5f707063 	svcpl	0x00707063
    2840:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2844:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    2848:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    284c:	705f636e 	subsvc	r6, pc, lr, ror #6
    2850:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    2854:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2858:	50435f54 	subpl	r5, r3, r4, asr pc
    285c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2860:	3032396d 	eorscc	r3, r2, sp, ror #18
    2864:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    2868:	655f6261 	ldrbvs	r6, [pc, #-609]	; 260f <shift+0x260f>
    286c:	41540071 	cmpmi	r4, r1, ror r0
    2870:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2874:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2878:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    287c:	61003632 	tstvs	r0, r2, lsr r6
    2880:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2884:	5f686372 	svcpl	0x00686372
    2888:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    288c:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2890:	00766964 	rsbseq	r6, r6, r4, ror #18
    2894:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2898:	5f71655f 	svcpl	0x0071655f
    289c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    28a0:	00726574 	rsbseq	r6, r2, r4, ror r5
    28a4:	5f6d7261 	svcpl	0x006d7261
    28a8:	5f636970 	svcpl	0x00636970
    28ac:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    28b0:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    28b4:	52415400 	subpl	r5, r1, #0, 8
    28b8:	5f544547 	svcpl	0x00544547
    28bc:	5f555043 	svcpl	0x00555043
    28c0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    28c4:	306d7865 	rsbcc	r7, sp, r5, ror #16
    28c8:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    28cc:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    28d0:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    28d4:	41540079 	cmpmi	r4, r9, ror r0
    28d8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28dc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28e0:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    28e4:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    28e8:	7066766f 	rsbvc	r7, r6, pc, ror #12
    28ec:	61736900 	cmnvs	r3, r0, lsl #18
    28f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    28f4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    28f8:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    28fc:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2900:	00647264 	rsbeq	r7, r4, r4, ror #4
    2904:	5f4d5241 	svcpl	0x004d5241
    2908:	61004343 	tstvs	r0, r3, asr #6
    290c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2910:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2914:	6100325f 	tstvs	r0, pc, asr r2
    2918:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    291c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2920:	6100335f 	tstvs	r0, pc, asr r3
    2924:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2928:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    292c:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    2930:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2934:	50435f54 	subpl	r5, r3, r4, asr pc
    2938:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    293c:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2940:	4d524100 	ldfmie	f4, [r2, #-0]
    2944:	0053435f 	subseq	r4, r3, pc, asr r3
    2948:	5f6d7261 	svcpl	0x006d7261
    294c:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2950:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2954:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2958:	61625f6d 	cmnvs	r2, sp, ror #30
    295c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2960:	00686372 	rsbeq	r6, r8, r2, ror r3
    2964:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2968:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    296c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2970:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2974:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    2978:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    297c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2980:	6d726100 	ldfvse	f6, [r2, #-0]
    2984:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2988:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    298c:	52415400 	subpl	r5, r1, #0, 8
    2990:	5f544547 	svcpl	0x00544547
    2994:	5f555043 	svcpl	0x00555043
    2998:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    299c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    29a0:	72610032 	rsbvc	r0, r1, #50	; 0x32
    29a4:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    29a8:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    29ac:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    29b0:	52410074 	subpl	r0, r1, #116	; 0x74
    29b4:	43505f4d 	cmpmi	r0, #308	; 0x134
    29b8:	41415f53 	cmpmi	r1, r3, asr pc
    29bc:	5f534350 	svcpl	0x00534350
    29c0:	41434f4c 	cmpmi	r3, ip, asr #30
    29c4:	4154004c 	cmpmi	r4, ip, asr #32
    29c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    29d4:	61786574 	cmnvs	r8, r4, ror r5
    29d8:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    29dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    29e0:	50435f54 	subpl	r5, r3, r4, asr pc
    29e4:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    29e8:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    29ec:	006d7261 	rsbeq	r7, sp, r1, ror #4
    29f0:	5f6d7261 	svcpl	0x006d7261
    29f4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29f8:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29fc:	0031626d 	eorseq	r6, r1, sp, ror #4
    2a00:	5f6d7261 	svcpl	0x006d7261
    2a04:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a08:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2a0c:	0032626d 	eorseq	r6, r2, sp, ror #4
    2a10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a18:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2a1c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2a20:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2a24:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a28:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    2a2c:	61736900 	cmnvs	r3, r0, lsl #18
    2a30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a34:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2a38:	5f6d7261 	svcpl	0x006d7261
    2a3c:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2a40:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    2a44:	6d726100 	ldfvse	f6, [r2, #-0]
    2a48:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2a4c:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9db0>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346cb0>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9dd0>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9100>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9e00>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346d00>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9e20>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346d20>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9e40>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346d40>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9e60>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346d60>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9e80>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346d80>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9ea0>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346da0>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9ec0>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346dc0>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9ed8>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9ef8>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9f28>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082ac 	andeq	r8, r0, ip, lsr #5
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9f48>
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
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9f74>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346e74>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	00008444 	andeq	r8, r0, r4, asr #8
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9f94>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346e94>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008470 	andeq	r8, r0, r0, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9fb4>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346eb4>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	0000848c 	andeq	r8, r0, ip, lsl #9
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9fd4>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346ed4>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084d0 	ldrdeq	r8, [r0], -r0
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9ff4>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346ef4>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	00008520 	andeq	r8, r0, r0, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa014>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346f14>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008570 	andeq	r8, r0, r0, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa034>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346f34>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	0000859c 	muleq	r0, ip, r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa054>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346f54>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085ec 	andeq	r8, r0, ip, ror #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa074>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346f74>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	00008630 	andeq	r8, r0, r0, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa094>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346f94>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008680 	andeq	r8, r0, r0, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa0b4>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346fb4>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086d4 	ldrdeq	r8, [r0], -r4
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa0d4>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346fd4>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	00008710 	andeq	r8, r0, r0, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa0f4>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346ff4>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	0000874c 	andeq	r8, r0, ip, asr #14
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa114>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347014>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008788 	andeq	r8, r0, r8, lsl #15
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfa134>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347034>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087c4 	andeq	r8, r0, r4, asr #15
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fa154>
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
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fa184>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089e8 	andeq	r8, r0, r8, ror #19
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa1a4>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3470a4>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a84 	andeq	r8, r0, r4, lsl #21
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa1c4>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3470c4>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b44 	andeq	r8, r0, r4, asr #22
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa1e4>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x3470e4>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008bf0 	strdeq	r8, [r0], -r0
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa204>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347104>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008c44 	andeq	r8, r0, r4, asr #24
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa224>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347124>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008cac 	andeq	r8, r0, ip, lsr #25
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa244>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347144>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003d4 	ldrdeq	r0, [r0], -r4
 4cc:	00008d2c 	andeq	r8, r0, ip, lsr #26
 4d0:	0000006c 	andeq	r0, r0, ip, rrx
 4d4:	8b040e42 	blhi	103de4 <__bss_end+0xfa264>
 4d8:	0b0d4201 	bleq	350ce4 <__bss_end+0x347164>
 4dc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ec:	00008d98 	muleq	r0, r8, sp
 4f0:	000000c4 	andeq	r0, r0, r4, asr #1
 4f4:	8b080e42 	blhi	203e04 <__bss_end+0x1fa284>
 4f8:	42018e02 	andmi	r8, r1, #2, 28
 4fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 500:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 504:	00000020 	andeq	r0, r0, r0, lsr #32
 508:	000003d4 	ldrdeq	r0, [r0], -r4
 50c:	00008e5c 	andeq	r8, r0, ip, asr lr
 510:	00000440 	andeq	r0, r0, r0, asr #8
 514:	8b040e42 	blhi	103e24 <__bss_end+0xfa2a4>
 518:	0b0d4201 	bleq	350d24 <__bss_end+0x3471a4>
 51c:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 520:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 524:	00000000 	andeq	r0, r0, r0
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003d4 	ldrdeq	r0, [r0], -r4
 530:	0000929c 	muleq	r0, ip, r2
 534:	000000d4 	ldrdeq	r0, [r0], -r4
 538:	8b080e42 	blhi	203e48 <__bss_end+0x1fa2c8>
 53c:	42018e02 	andmi	r8, r1, #2, 28
 540:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 544:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003d4 	ldrdeq	r0, [r0], -r4
 550:	00009370 	andeq	r9, r0, r0, ror r3
 554:	0000003c 	andeq	r0, r0, ip, lsr r0
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa2e8>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x3471e8>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003d4 	ldrdeq	r0, [r0], -r4
 570:	000093ac 	andeq	r9, r0, ip, lsr #7
 574:	00000040 	andeq	r0, r0, r0, asr #32
 578:	8b040e42 	blhi	103e88 <__bss_end+0xfa308>
 57c:	0b0d4201 	bleq	350d88 <__bss_end+0x347208>
 580:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 584:	00000ecb 	andeq	r0, r0, fp, asr #29
 588:	0000001c 	andeq	r0, r0, ip, lsl r0
 58c:	000003d4 	ldrdeq	r0, [r0], -r4
 590:	000093ec 	andeq	r9, r0, ip, ror #7
 594:	00000030 	andeq	r0, r0, r0, lsr r0
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa328>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 5a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5a8:	00000020 	andeq	r0, r0, r0, lsr #32
 5ac:	000003d4 	ldrdeq	r0, [r0], -r4
 5b0:	0000941c 	andeq	r9, r0, ip, lsl r4
 5b4:	00000324 	andeq	r0, r0, r4, lsr #6
 5b8:	8b080e42 	blhi	203ec8 <__bss_end+0x1fa348>
 5bc:	42018e02 	andmi	r8, r1, #2, 28
 5c0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5c4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5c8:	00000008 	andeq	r0, r0, r8
 5cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d0:	000003d4 	ldrdeq	r0, [r0], -r4
 5d4:	00009740 	andeq	r9, r0, r0, asr #14
 5d8:	00000110 	andeq	r0, r0, r0, lsl r1
 5dc:	8b040e42 	blhi	103eec <__bss_end+0xfa36c>
 5e0:	0b0d4201 	bleq	350dec <__bss_end+0x34726c>
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
