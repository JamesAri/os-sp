
./oled_task:     file format elf32-littlearm


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
    805c:	0000a25c 	andeq	sl, r0, ip, asr r2
    8060:	0000a26c 	andeq	sl, r0, ip, ror #4

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
    81cc:	0000a248 	andeq	sl, r0, r8, asr #4
    81d0:	0000a248 	andeq	sl, r0, r8, asr #4

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
    8224:	0000a248 	andeq	sl, r0, r8, asr #4
    8228:	0000a248 	andeq	sl, r0, r8, asr #4

0000822c <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:27
	"My favourite sport is ARM wrestling",
	"Old MacDonald had a farm, EIGRP",
};

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:28
	COLED_Display disp("DEV:oled");
    8240:	e24b3014 	sub	r3, fp, #20
    8244:	e59f10d8 	ldr	r1, [pc, #216]	; 8324 <main+0xf8>
    8248:	e1a00003 	mov	r0, r3
    824c:	eb000547 	bl	9770 <_ZN13COLED_DisplayC1EPKc>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:29
	disp.Clear(false);
    8250:	e24b3014 	sub	r3, fp, #20
    8254:	e3a01000 	mov	r1, #0
    8258:	e1a00003 	mov	r0, r3
    825c:	eb00057a 	bl	984c <_ZN13COLED_Display5ClearEb>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:30
	disp.Put_String(10, 10, "KIV-RTOS init...");
    8260:	e24b0014 	sub	r0, fp, #20
    8264:	e59f30bc 	ldr	r3, [pc, #188]	; 8328 <main+0xfc>
    8268:	e3a0200a 	mov	r2, #10
    826c:	e3a0100a 	mov	r1, #10
    8270:	eb00063f 	bl	9b74 <_ZN13COLED_Display10Put_StringEttPKc>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:31
	disp.Flip();
    8274:	e24b3014 	sub	r3, fp, #20
    8278:	e1a00003 	mov	r0, r3
    827c:	eb000626 	bl	9b1c <_ZN13COLED_Display4FlipEv>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:33

	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8280:	e3a01000 	mov	r1, #0
    8284:	e59f00a0 	ldr	r0, [pc, #160]	; 832c <main+0x100>
    8288:	eb000047 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    828c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:34
	uint32_t num = 0;
    8290:	e3a03000 	mov	r3, #0
    8294:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:36

	sleep(0x800, 0x800);
    8298:	e3a01b02 	mov	r1, #2048	; 0x800
    829c:	e3a00b02 	mov	r0, #2048	; 0x800
    82a0:	eb0000be 	bl	85a0 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:41 (discriminator 1)

	while (true)
	{
		// ziskame si nahodne cislo a vybereme podle toho zpravu
		read(trng_file, reinterpret_cast<char*>(&num), sizeof(num));
    82a4:	e24b3018 	sub	r3, fp, #24
    82a8:	e3a02004 	mov	r2, #4
    82ac:	e1a01003 	mov	r1, r3
    82b0:	e51b0008 	ldr	r0, [fp, #-8]
    82b4:	eb00004d 	bl	83f0 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:42 (discriminator 1)
		const char* msg = messages[num % (sizeof(messages) / sizeof(const char*))];
    82b8:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    82bc:	e59f306c 	ldr	r3, [pc, #108]	; 8330 <main+0x104>
    82c0:	e0832193 	umull	r2, r3, r3, r1
    82c4:	e1a02123 	lsr	r2, r3, #2
    82c8:	e1a03002 	mov	r3, r2
    82cc:	e1a03103 	lsl	r3, r3, #2
    82d0:	e0833002 	add	r3, r3, r2
    82d4:	e0412003 	sub	r2, r1, r3
    82d8:	e59f3054 	ldr	r3, [pc, #84]	; 8334 <main+0x108>
    82dc:	e7933102 	ldr	r3, [r3, r2, lsl #2]
    82e0:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:44 (discriminator 1)

		disp.Clear(false);
    82e4:	e24b3014 	sub	r3, fp, #20
    82e8:	e3a01000 	mov	r1, #0
    82ec:	e1a00003 	mov	r0, r3
    82f0:	eb000555 	bl	984c <_ZN13COLED_Display5ClearEb>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:45 (discriminator 1)
		disp.Put_String(0, 0, msg);
    82f4:	e24b0014 	sub	r0, fp, #20
    82f8:	e51b300c 	ldr	r3, [fp, #-12]
    82fc:	e3a02000 	mov	r2, #0
    8300:	e3a01000 	mov	r1, #0
    8304:	eb00061a 	bl	9b74 <_ZN13COLED_Display10Put_StringEttPKc>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:46 (discriminator 1)
		disp.Flip();
    8308:	e24b3014 	sub	r3, fp, #20
    830c:	e1a00003 	mov	r0, r3
    8310:	eb000601 	bl	9b1c <_ZN13COLED_Display4FlipEv>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:48 (discriminator 1)

		sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
    8314:	e3a01b02 	mov	r1, #2048	; 0x800
    8318:	e3a00901 	mov	r0, #16384	; 0x4000
    831c:	eb00009f 	bl	85a0 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/oled_task/main.cpp:49 (discriminator 1)
	}
    8320:	eaffffdf 	b	82a4 <main+0x78>
    8324:	00009f20 	andeq	r9, r0, r0, lsr #30
    8328:	00009f2c 	andeq	r9, r0, ip, lsr #30
    832c:	00009f40 	andeq	r9, r0, r0, asr #30
    8330:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    8334:	0000a248 	andeq	sl, r0, r8, asr #4

00008338 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8338:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    833c:	e28db000 	add	fp, sp, #0
    8340:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8344:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8348:	e1a03000 	mov	r3, r0
    834c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8350:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8354:	e1a00003 	mov	r0, r3
    8358:	e28bd000 	add	sp, fp, #0
    835c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8360:	e12fff1e 	bx	lr

00008364 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8364:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8368:	e28db000 	add	fp, sp, #0
    836c:	e24dd00c 	sub	sp, sp, #12
    8370:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8374:	e51b3008 	ldr	r3, [fp, #-8]
    8378:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    837c:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    8380:	e320f000 	nop	{0}
    8384:	e28bd000 	add	sp, fp, #0
    8388:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    838c:	e12fff1e 	bx	lr

00008390 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8390:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8394:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8398:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    839c:	e320f000 	nop	{0}
    83a0:	e28bd000 	add	sp, fp, #0
    83a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83a8:	e12fff1e 	bx	lr

000083ac <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b0:	e28db000 	add	fp, sp, #0
    83b4:	e24dd014 	sub	sp, sp, #20
    83b8:	e50b0010 	str	r0, [fp, #-16]
    83bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    83c0:	e51b3010 	ldr	r3, [fp, #-16]
    83c4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83cc:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83d0:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83d4:	e1a03000 	mov	r3, r0
    83d8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    83e0:	e1a00003 	mov	r0, r3
    83e4:	e28bd000 	add	sp, fp, #0
    83e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83ec:	e12fff1e 	bx	lr

000083f0 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f4:	e28db000 	add	fp, sp, #0
    83f8:	e24dd01c 	sub	sp, sp, #28
    83fc:	e50b0010 	str	r0, [fp, #-16]
    8400:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8404:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8408:	e51b3010 	ldr	r3, [fp, #-16]
    840c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8410:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8414:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8418:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    841c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8420:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8424:	e1a03000 	mov	r3, r0
    8428:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    842c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    8430:	e1a00003 	mov	r0, r3
    8434:	e28bd000 	add	sp, fp, #0
    8438:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    843c:	e12fff1e 	bx	lr

00008440 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8440:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8444:	e28db000 	add	fp, sp, #0
    8448:	e24dd01c 	sub	sp, sp, #28
    844c:	e50b0010 	str	r0, [fp, #-16]
    8450:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8454:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8458:	e51b3010 	ldr	r3, [fp, #-16]
    845c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8460:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8464:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8468:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    846c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8470:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8474:	e1a03000 	mov	r3, r0
    8478:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    847c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    8480:	e1a00003 	mov	r0, r3
    8484:	e28bd000 	add	sp, fp, #0
    8488:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    848c:	e12fff1e 	bx	lr

00008490 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8490:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8494:	e28db000 	add	fp, sp, #0
    8498:	e24dd00c 	sub	sp, sp, #12
    849c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
    84a4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84a8:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    84ac:	e320f000 	nop	{0}
    84b0:	e28bd000 	add	sp, fp, #0
    84b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b8:	e12fff1e 	bx	lr

000084bc <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    84bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84c0:	e28db000 	add	fp, sp, #0
    84c4:	e24dd01c 	sub	sp, sp, #28
    84c8:	e50b0010 	str	r0, [fp, #-16]
    84cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84d0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84d4:	e51b3010 	ldr	r3, [fp, #-16]
    84d8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84e0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84e4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84e8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84ec:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84f0:	e1a03000 	mov	r3, r0
    84f4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    84f8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    84fc:	e1a00003 	mov	r0, r3
    8500:	e28bd000 	add	sp, fp, #0
    8504:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8508:	e12fff1e 	bx	lr

0000850c <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    850c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8510:	e28db000 	add	fp, sp, #0
    8514:	e24dd014 	sub	sp, sp, #20
    8518:	e50b0010 	str	r0, [fp, #-16]
    851c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8520:	e51b3010 	ldr	r3, [fp, #-16]
    8524:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8528:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    852c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8530:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8534:	e1a03000 	mov	r3, r0
    8538:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    853c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    8540:	e1a00003 	mov	r0, r3
    8544:	e28bd000 	add	sp, fp, #0
    8548:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    854c:	e12fff1e 	bx	lr

00008550 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8550:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8554:	e28db000 	add	fp, sp, #0
    8558:	e24dd01c 	sub	sp, sp, #28
    855c:	e50b0010 	str	r0, [fp, #-16]
    8560:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8564:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8568:	e51b3010 	ldr	r3, [fp, #-16]
    856c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8570:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8574:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8578:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    857c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8580:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8584:	e1a03000 	mov	r3, r0
    8588:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    858c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    8590:	e1a00003 	mov	r0, r3
    8594:	e28bd000 	add	sp, fp, #0
    8598:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    859c:	e12fff1e 	bx	lr

000085a0 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a4:	e28db000 	add	fp, sp, #0
    85a8:	e24dd014 	sub	sp, sp, #20
    85ac:	e50b0010 	str	r0, [fp, #-16]
    85b0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85c4:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85c8:	e1a03000 	mov	r3, r0
    85cc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85d0:	e51b3008 	ldr	r3, [fp, #-8]
    85d4:	e3530000 	cmp	r3, #0
    85d8:	13a03001 	movne	r3, #1
    85dc:	03a03000 	moveq	r3, #0
    85e0:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    85e4:	e1a00003 	mov	r0, r3
    85e8:	e28bd000 	add	sp, fp, #0
    85ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f0:	e12fff1e 	bx	lr

000085f4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f8:	e28db000 	add	fp, sp, #0
    85fc:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8600:	e3a03000 	mov	r3, #0
    8604:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8608:	e3a03000 	mov	r3, #0
    860c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8610:	e24b300c 	sub	r3, fp, #12
    8614:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8618:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    861c:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    863c:	e3a03001 	mov	r3, #1
    8640:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8644:	e3a03001 	mov	r3, #1
    8648:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    864c:	e24b300c 	sub	r3, fp, #12
    8650:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8654:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8658:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    865c:	e1a00003 	mov	r0, r3
    8660:	e28bd000 	add	sp, fp, #0
    8664:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8668:	e12fff1e 	bx	lr

0000866c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    866c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8670:	e28db000 	add	fp, sp, #0
    8674:	e24dd014 	sub	sp, sp, #20
    8678:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    867c:	e3a03000 	mov	r3, #0
    8680:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8684:	e3a03000 	mov	r3, #0
    8688:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    868c:	e24b3010 	sub	r3, fp, #16
    8690:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8694:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    8698:	e320f000 	nop	{0}
    869c:	e28bd000 	add	sp, fp, #0
    86a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86a4:	e12fff1e 	bx	lr

000086a8 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86ac:	e28db000 	add	fp, sp, #0
    86b0:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    86b4:	e3a03001 	mov	r3, #1
    86b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    86bc:	e3a03001 	mov	r3, #1
    86c0:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86c4:	e24b300c 	sub	r3, fp, #12
    86c8:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86cc:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86d0:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    86d4:	e1a00003 	mov	r0, r3
    86d8:	e28bd000 	add	sp, fp, #0
    86dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86e0:	e12fff1e 	bx	lr

000086e4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86e4:	e92d4800 	push	{fp, lr}
    86e8:	e28db004 	add	fp, sp, #4
    86ec:	e24dd050 	sub	sp, sp, #80	; 0x50
    86f0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86f4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86f8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86fc:	e3a0200a 	mov	r2, #10
    8700:	e59f1088 	ldr	r1, [pc, #136]	; 8790 <_Z4pipePKcj+0xac>
    8704:	e1a00003 	mov	r0, r3
    8708:	eb0000a5 	bl	89a4 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    870c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8710:	e283300a 	add	r3, r3, #10
    8714:	e3a02035 	mov	r2, #53	; 0x35
    8718:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    871c:	e1a00003 	mov	r0, r3
    8720:	eb00009f 	bl	89a4 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8724:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8728:	eb0000f8 	bl	8b10 <_Z6strlenPKc>
    872c:	e1a03000 	mov	r3, r0
    8730:	e283300a 	add	r3, r3, #10
    8734:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8738:	e51b3008 	ldr	r3, [fp, #-8]
    873c:	e2832001 	add	r2, r3, #1
    8740:	e50b2008 	str	r2, [fp, #-8]
    8744:	e24b2004 	sub	r2, fp, #4
    8748:	e0823003 	add	r3, r2, r3
    874c:	e3a02023 	mov	r2, #35	; 0x23
    8750:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8754:	e24b2048 	sub	r2, fp, #72	; 0x48
    8758:	e51b3008 	ldr	r3, [fp, #-8]
    875c:	e0823003 	add	r3, r2, r3
    8760:	e3a0200a 	mov	r2, #10
    8764:	e1a01003 	mov	r1, r3
    8768:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    876c:	eb000008 	bl	8794 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8770:	e24b3048 	sub	r3, fp, #72	; 0x48
    8774:	e3a01002 	mov	r1, #2
    8778:	e1a00003 	mov	r0, r3
    877c:	ebffff0a 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    8780:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    8784:	e1a00003 	mov	r0, r3
    8788:	e24bd004 	sub	sp, fp, #4
    878c:	e8bd8800 	pop	{fp, pc}
    8790:	00009f7c 	andeq	r9, r0, ip, ror pc

00008794 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8794:	e92d4800 	push	{fp, lr}
    8798:	e28db004 	add	fp, sp, #4
    879c:	e24dd020 	sub	sp, sp, #32
    87a0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87a4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87a8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    87ac:	e3a03000 	mov	r3, #0
    87b0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    87b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87b8:	e3530000 	cmp	r3, #0
    87bc:	0a000014 	beq	8814 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    87c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87c4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87c8:	e1a00003 	mov	r0, r3
    87cc:	eb00058f 	bl	9e10 <__aeabi_uidivmod>
    87d0:	e1a03001 	mov	r3, r1
    87d4:	e1a01003 	mov	r1, r3
    87d8:	e51b3008 	ldr	r3, [fp, #-8]
    87dc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87e0:	e0823003 	add	r3, r2, r3
    87e4:	e59f2118 	ldr	r2, [pc, #280]	; 8904 <_Z4itoajPcj+0x170>
    87e8:	e7d22001 	ldrb	r2, [r2, r1]
    87ec:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87f0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87f4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87f8:	eb000509 	bl	9c24 <__udivsi3>
    87fc:	e1a03000 	mov	r3, r0
    8800:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8804:	e51b3008 	ldr	r3, [fp, #-8]
    8808:	e2833001 	add	r3, r3, #1
    880c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8810:	eaffffe7 	b	87b4 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8814:	e51b3008 	ldr	r3, [fp, #-8]
    8818:	e3530000 	cmp	r3, #0
    881c:	1a000007 	bne	8840 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8828:	e0823003 	add	r3, r2, r3
    882c:	e3a02030 	mov	r2, #48	; 0x30
    8830:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8834:	e51b3008 	ldr	r3, [fp, #-8]
    8838:	e2833001 	add	r3, r3, #1
    883c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8848:	e0823003 	add	r3, r2, r3
    884c:	e3a02000 	mov	r2, #0
    8850:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8854:	e51b3008 	ldr	r3, [fp, #-8]
    8858:	e2433001 	sub	r3, r3, #1
    885c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8860:	e3a03000 	mov	r3, #0
    8864:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8868:	e51b3008 	ldr	r3, [fp, #-8]
    886c:	e1a02fa3 	lsr	r2, r3, #31
    8870:	e0823003 	add	r3, r2, r3
    8874:	e1a030c3 	asr	r3, r3, #1
    8878:	e1a02003 	mov	r2, r3
    887c:	e51b300c 	ldr	r3, [fp, #-12]
    8880:	e1530002 	cmp	r3, r2
    8884:	ca00001b 	bgt	88f8 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8888:	e51b2008 	ldr	r2, [fp, #-8]
    888c:	e51b300c 	ldr	r3, [fp, #-12]
    8890:	e0423003 	sub	r3, r2, r3
    8894:	e1a02003 	mov	r2, r3
    8898:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    889c:	e0833002 	add	r3, r3, r2
    88a0:	e5d33000 	ldrb	r3, [r3]
    88a4:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    88a8:	e51b300c 	ldr	r3, [fp, #-12]
    88ac:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b0:	e0822003 	add	r2, r2, r3
    88b4:	e51b1008 	ldr	r1, [fp, #-8]
    88b8:	e51b300c 	ldr	r3, [fp, #-12]
    88bc:	e0413003 	sub	r3, r1, r3
    88c0:	e1a01003 	mov	r1, r3
    88c4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88c8:	e0833001 	add	r3, r3, r1
    88cc:	e5d22000 	ldrb	r2, [r2]
    88d0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88d4:	e51b300c 	ldr	r3, [fp, #-12]
    88d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88dc:	e0823003 	add	r3, r2, r3
    88e0:	e55b200d 	ldrb	r2, [fp, #-13]
    88e4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88e8:	e51b300c 	ldr	r3, [fp, #-12]
    88ec:	e2833001 	add	r3, r3, #1
    88f0:	e50b300c 	str	r3, [fp, #-12]
    88f4:	eaffffdb 	b	8868 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    88f8:	e320f000 	nop	{0}
    88fc:	e24bd004 	sub	sp, fp, #4
    8900:	e8bd8800 	pop	{fp, pc}
    8904:	00009f8c 	andeq	r9, r0, ip, lsl #31

00008908 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8908:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    890c:	e28db000 	add	fp, sp, #0
    8910:	e24dd014 	sub	sp, sp, #20
    8914:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8918:	e3a03000 	mov	r3, #0
    891c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8920:	e51b3010 	ldr	r3, [fp, #-16]
    8924:	e5d33000 	ldrb	r3, [r3]
    8928:	e3530000 	cmp	r3, #0
    892c:	0a000017 	beq	8990 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8930:	e51b2008 	ldr	r2, [fp, #-8]
    8934:	e1a03002 	mov	r3, r2
    8938:	e1a03103 	lsl	r3, r3, #2
    893c:	e0833002 	add	r3, r3, r2
    8940:	e1a03083 	lsl	r3, r3, #1
    8944:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8948:	e51b3010 	ldr	r3, [fp, #-16]
    894c:	e5d33000 	ldrb	r3, [r3]
    8950:	e3530039 	cmp	r3, #57	; 0x39
    8954:	8a00000d 	bhi	8990 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8958:	e51b3010 	ldr	r3, [fp, #-16]
    895c:	e5d33000 	ldrb	r3, [r3]
    8960:	e353002f 	cmp	r3, #47	; 0x2f
    8964:	9a000009 	bls	8990 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8968:	e51b3010 	ldr	r3, [fp, #-16]
    896c:	e5d33000 	ldrb	r3, [r3]
    8970:	e2433030 	sub	r3, r3, #48	; 0x30
    8974:	e51b2008 	ldr	r2, [fp, #-8]
    8978:	e0823003 	add	r3, r2, r3
    897c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8980:	e51b3010 	ldr	r3, [fp, #-16]
    8984:	e2833001 	add	r3, r3, #1
    8988:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    898c:	eaffffe3 	b	8920 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8990:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8994:	e1a00003 	mov	r0, r3
    8998:	e28bd000 	add	sp, fp, #0
    899c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89a0:	e12fff1e 	bx	lr

000089a4 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    89a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a8:	e28db000 	add	fp, sp, #0
    89ac:	e24dd01c 	sub	sp, sp, #28
    89b0:	e50b0010 	str	r0, [fp, #-16]
    89b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89b8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    89bc:	e3a03000 	mov	r3, #0
    89c0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89c4:	e51b2008 	ldr	r2, [fp, #-8]
    89c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89cc:	e1520003 	cmp	r2, r3
    89d0:	aa000011 	bge	8a1c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89d4:	e51b3008 	ldr	r3, [fp, #-8]
    89d8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89dc:	e0823003 	add	r3, r2, r3
    89e0:	e5d33000 	ldrb	r3, [r3]
    89e4:	e3530000 	cmp	r3, #0
    89e8:	0a00000b 	beq	8a1c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89ec:	e51b3008 	ldr	r3, [fp, #-8]
    89f0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89f4:	e0822003 	add	r2, r2, r3
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e51b1010 	ldr	r1, [fp, #-16]
    8a00:	e0813003 	add	r3, r1, r3
    8a04:	e5d22000 	ldrb	r2, [r2]
    8a08:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a0c:	e51b3008 	ldr	r3, [fp, #-8]
    8a10:	e2833001 	add	r3, r3, #1
    8a14:	e50b3008 	str	r3, [fp, #-8]
    8a18:	eaffffe9 	b	89c4 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a1c:	e51b2008 	ldr	r2, [fp, #-8]
    8a20:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a24:	e1520003 	cmp	r2, r3
    8a28:	aa000008 	bge	8a50 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a2c:	e51b3008 	ldr	r3, [fp, #-8]
    8a30:	e51b2010 	ldr	r2, [fp, #-16]
    8a34:	e0823003 	add	r3, r2, r3
    8a38:	e3a02000 	mov	r2, #0
    8a3c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a40:	e51b3008 	ldr	r3, [fp, #-8]
    8a44:	e2833001 	add	r3, r3, #1
    8a48:	e50b3008 	str	r3, [fp, #-8]
    8a4c:	eafffff2 	b	8a1c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a50:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8a54:	e1a00003 	mov	r0, r3
    8a58:	e28bd000 	add	sp, fp, #0
    8a5c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a60:	e12fff1e 	bx	lr

00008a64 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a68:	e28db000 	add	fp, sp, #0
    8a6c:	e24dd01c 	sub	sp, sp, #28
    8a70:	e50b0010 	str	r0, [fp, #-16]
    8a74:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a78:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a7c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a80:	e2432001 	sub	r2, r3, #1
    8a84:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a88:	e3530000 	cmp	r3, #0
    8a8c:	c3a03001 	movgt	r3, #1
    8a90:	d3a03000 	movle	r3, #0
    8a94:	e6ef3073 	uxtb	r3, r3
    8a98:	e3530000 	cmp	r3, #0
    8a9c:	0a000016 	beq	8afc <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8aa0:	e51b3010 	ldr	r3, [fp, #-16]
    8aa4:	e2832001 	add	r2, r3, #1
    8aa8:	e50b2010 	str	r2, [fp, #-16]
    8aac:	e5d33000 	ldrb	r3, [r3]
    8ab0:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ab4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ab8:	e2832001 	add	r2, r3, #1
    8abc:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ac8:	e55b2005 	ldrb	r2, [fp, #-5]
    8acc:	e55b3006 	ldrb	r3, [fp, #-6]
    8ad0:	e1520003 	cmp	r2, r3
    8ad4:	0a000003 	beq	8ae8 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ad8:	e55b2005 	ldrb	r2, [fp, #-5]
    8adc:	e55b3006 	ldrb	r3, [fp, #-6]
    8ae0:	e0423003 	sub	r3, r2, r3
    8ae4:	ea000005 	b	8b00 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ae8:	e55b3005 	ldrb	r3, [fp, #-5]
    8aec:	e3530000 	cmp	r3, #0
    8af0:	1affffe1 	bne	8a7c <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8af4:	e3a03000 	mov	r3, #0
    8af8:	ea000000 	b	8b00 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8afc:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8b00:	e1a00003 	mov	r0, r3
    8b04:	e28bd000 	add	sp, fp, #0
    8b08:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b0c:	e12fff1e 	bx	lr

00008b10 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b10:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b14:	e28db000 	add	fp, sp, #0
    8b18:	e24dd014 	sub	sp, sp, #20
    8b1c:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8b20:	e3a03000 	mov	r3, #0
    8b24:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b28:	e51b3008 	ldr	r3, [fp, #-8]
    8b2c:	e51b2010 	ldr	r2, [fp, #-16]
    8b30:	e0823003 	add	r3, r2, r3
    8b34:	e5d33000 	ldrb	r3, [r3]
    8b38:	e3530000 	cmp	r3, #0
    8b3c:	0a000003 	beq	8b50 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b40:	e51b3008 	ldr	r3, [fp, #-8]
    8b44:	e2833001 	add	r3, r3, #1
    8b48:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b4c:	eafffff5 	b	8b28 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b50:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8b54:	e1a00003 	mov	r0, r3
    8b58:	e28bd000 	add	sp, fp, #0
    8b5c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b60:	e12fff1e 	bx	lr

00008b64 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b64:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b68:	e28db000 	add	fp, sp, #0
    8b6c:	e24dd014 	sub	sp, sp, #20
    8b70:	e50b0010 	str	r0, [fp, #-16]
    8b74:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b78:	e51b3010 	ldr	r3, [fp, #-16]
    8b7c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b80:	e3a03000 	mov	r3, #0
    8b84:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b88:	e51b2008 	ldr	r2, [fp, #-8]
    8b8c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b90:	e1520003 	cmp	r2, r3
    8b94:	aa000008 	bge	8bbc <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8b98:	e51b3008 	ldr	r3, [fp, #-8]
    8b9c:	e51b200c 	ldr	r2, [fp, #-12]
    8ba0:	e0823003 	add	r3, r2, r3
    8ba4:	e3a02000 	mov	r2, #0
    8ba8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8bac:	e51b3008 	ldr	r3, [fp, #-8]
    8bb0:	e2833001 	add	r3, r3, #1
    8bb4:	e50b3008 	str	r3, [fp, #-8]
    8bb8:	eafffff2 	b	8b88 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8bbc:	e320f000 	nop	{0}
    8bc0:	e28bd000 	add	sp, fp, #0
    8bc4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bc8:	e12fff1e 	bx	lr

00008bcc <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8bcc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bd0:	e28db000 	add	fp, sp, #0
    8bd4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8bd8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bdc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8be0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8be4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8be8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bf0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8bf4:	e3a03000 	mov	r3, #0
    8bf8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bfc:	e51b2008 	ldr	r2, [fp, #-8]
    8c00:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c04:	e1520003 	cmp	r2, r3
    8c08:	aa00000b 	bge	8c3c <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c0c:	e51b3008 	ldr	r3, [fp, #-8]
    8c10:	e51b200c 	ldr	r2, [fp, #-12]
    8c14:	e0822003 	add	r2, r2, r3
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b1010 	ldr	r1, [fp, #-16]
    8c20:	e0813003 	add	r3, r1, r3
    8c24:	e5d22000 	ldrb	r2, [r2]
    8c28:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
    8c38:	eaffffef 	b	8bfc <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8c3c:	e320f000 	nop	{0}
    8c40:	e28bd000 	add	sp, fp, #0
    8c44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c48:	e12fff1e 	bx	lr

00008c4c <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8c4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c50:	e28db000 	add	fp, sp, #0
    8c54:	e24dd014 	sub	sp, sp, #20
    8c58:	ed0b0a04 	vstr	s0, [fp, #-16]
    8c5c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8c60:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8c64:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8c68:	e3a03000 	mov	r3, #0
    8c6c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8c70:	e51b200c 	ldr	r2, [fp, #-12]
    8c74:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c78:	e1520003 	cmp	r2, r3
    8c7c:	2a000007 	bcs	8ca0 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8c80:	ed1b7a02 	vldr	s14, [fp, #-8]
    8c84:	ed5b7a04 	vldr	s15, [fp, #-16]
    8c88:	ee677a27 	vmul.f32	s15, s14, s15
    8c8c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8c90:	e51b300c 	ldr	r3, [fp, #-12]
    8c94:	e2833001 	add	r3, r3, #1
    8c98:	e50b300c 	str	r3, [fp, #-12]
    8c9c:	eafffff3 	b	8c70 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8ca8:	eeb00a67 	vmov.f32	s0, s15
    8cac:	e28bd000 	add	sp, fp, #0
    8cb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cb4:	e12fff1e 	bx	lr

00008cb8 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8cb8:	e92d4800 	push	{fp, lr}
    8cbc:	e28db004 	add	fp, sp, #4
    8cc0:	e24dd018 	sub	sp, sp, #24
    8cc4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8cc8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8ccc:	ebffff8f 	bl	8b10 <_Z6strlenPKc>
    8cd0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8cd4:	e3a03000 	mov	r3, #0
    8cd8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8cdc:	e51b300c 	ldr	r3, [fp, #-12]
    8ce0:	e1a02fa3 	lsr	r2, r3, #31
    8ce4:	e0823003 	add	r3, r2, r3
    8ce8:	e1a030c3 	asr	r3, r3, #1
    8cec:	e1a02003 	mov	r2, r3
    8cf0:	e51b3008 	ldr	r3, [fp, #-8]
    8cf4:	e1530002 	cmp	r3, r2
    8cf8:	aa00001c 	bge	8d70 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8cfc:	e51b3008 	ldr	r3, [fp, #-8]
    8d00:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8d04:	e0823003 	add	r3, r2, r3
    8d08:	e5d33000 	ldrb	r3, [r3]
    8d0c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8d10:	e51b200c 	ldr	r2, [fp, #-12]
    8d14:	e51b3008 	ldr	r3, [fp, #-8]
    8d18:	e0423003 	sub	r3, r2, r3
    8d1c:	e2433001 	sub	r3, r3, #1
    8d20:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8d24:	e0822003 	add	r2, r2, r3
    8d28:	e51b3008 	ldr	r3, [fp, #-8]
    8d2c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8d30:	e0813003 	add	r3, r1, r3
    8d34:	e5d22000 	ldrb	r2, [r2]
    8d38:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8d3c:	e51b200c 	ldr	r2, [fp, #-12]
    8d40:	e51b3008 	ldr	r3, [fp, #-8]
    8d44:	e0423003 	sub	r3, r2, r3
    8d48:	e2433001 	sub	r3, r3, #1
    8d4c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8d50:	e0823003 	add	r3, r2, r3
    8d54:	e51b2010 	ldr	r2, [fp, #-16]
    8d58:	e6ef2072 	uxtb	r2, r2
    8d5c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8d60:	e51b3008 	ldr	r3, [fp, #-8]
    8d64:	e2833001 	add	r3, r3, #1
    8d68:	e50b3008 	str	r3, [fp, #-8]
    8d6c:	eaffffda 	b	8cdc <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8d70:	e320f000 	nop	{0}
    8d74:	e24bd004 	sub	sp, fp, #4
    8d78:	e8bd8800 	pop	{fp, pc}

00008d7c <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8d7c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d80:	e28db000 	add	fp, sp, #0
    8d84:	e24dd01c 	sub	sp, sp, #28
    8d88:	ed0b0a04 	vstr	s0, [fp, #-16]
    8d8c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8d90:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8d94:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8d98:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d9c:	ed9f7af3 	vldr	s14, [pc, #972]	; 9170 <_Z11split_floatfRjS_Ri+0x3f4>
    8da0:	eef47ac7 	vcmpe.f32	s15, s14
    8da4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8da8:	ba000053 	blt	8efc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8dac:	ed5b7a04 	vldr	s15, [fp, #-16]
    8db0:	ed9f7aef 	vldr	s14, [pc, #956]	; 9174 <_Z11split_floatfRjS_Ri+0x3f8>
    8db4:	eef47ac7 	vcmpe.f32	s15, s14
    8db8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8dbc:	ba000008 	blt	8de4 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8dc0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8dc4:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9178 <_Z11split_floatfRjS_Ri+0x3fc>
    8dc8:	ee677a87 	vmul.f32	s15, s15, s14
    8dcc:	ed4b7a04 	vstr	s15, [fp, #-16]
    8dd0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8dd4:	e5933000 	ldr	r3, [r3]
    8dd8:	e2832020 	add	r2, r3, #32
    8ddc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8de0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    8de4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8de8:	ed9f7ae3 	vldr	s14, [pc, #908]	; 917c <_Z11split_floatfRjS_Ri+0x400>
    8dec:	eef47ac7 	vcmpe.f32	s15, s14
    8df0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8df4:	ba000008 	blt	8e1c <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8df8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8dfc:	ed9f7adf 	vldr	s14, [pc, #892]	; 9180 <_Z11split_floatfRjS_Ri+0x404>
    8e00:	ee677a87 	vmul.f32	s15, s15, s14
    8e04:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e08:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e0c:	e5933000 	ldr	r3, [r3]
    8e10:	e2832010 	add	r2, r3, #16
    8e14:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e18:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    8e1c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e20:	ed9f7ad7 	vldr	s14, [pc, #860]	; 9184 <_Z11split_floatfRjS_Ri+0x408>
    8e24:	eef47ac7 	vcmpe.f32	s15, s14
    8e28:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e2c:	ba000008 	blt	8e54 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    8e30:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e34:	ed9f7ad3 	vldr	s14, [pc, #844]	; 9188 <_Z11split_floatfRjS_Ri+0x40c>
    8e38:	ee677a87 	vmul.f32	s15, s15, s14
    8e3c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e40:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e44:	e5933000 	ldr	r3, [r3]
    8e48:	e2832008 	add	r2, r3, #8
    8e4c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e50:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    8e54:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e58:	ed9f7acb 	vldr	s14, [pc, #812]	; 918c <_Z11split_floatfRjS_Ri+0x410>
    8e5c:	eef47ac7 	vcmpe.f32	s15, s14
    8e60:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e64:	ba000008 	blt	8e8c <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    8e68:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e6c:	ed9f7ac7 	vldr	s14, [pc, #796]	; 9190 <_Z11split_floatfRjS_Ri+0x414>
    8e70:	ee677a87 	vmul.f32	s15, s15, s14
    8e74:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e78:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e7c:	e5933000 	ldr	r3, [r3]
    8e80:	e2832004 	add	r2, r3, #4
    8e84:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e88:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    8e8c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e90:	ed9f7abf 	vldr	s14, [pc, #764]	; 9194 <_Z11split_floatfRjS_Ri+0x418>
    8e94:	eef47ac7 	vcmpe.f32	s15, s14
    8e98:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e9c:	ba000008 	blt	8ec4 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    8ea0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ea4:	ed9f7abb 	vldr	s14, [pc, #748]	; 9198 <_Z11split_floatfRjS_Ri+0x41c>
    8ea8:	ee677a87 	vmul.f32	s15, s15, s14
    8eac:	ed4b7a04 	vstr	s15, [fp, #-16]
    8eb0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8eb4:	e5933000 	ldr	r3, [r3]
    8eb8:	e2832002 	add	r2, r3, #2
    8ebc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ec0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    8ec4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ec8:	ed9f7aa8 	vldr	s14, [pc, #672]	; 9170 <_Z11split_floatfRjS_Ri+0x3f4>
    8ecc:	eef47ac7 	vcmpe.f32	s15, s14
    8ed0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ed4:	ba000008 	blt	8efc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    8ed8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8edc:	ed9f7aae 	vldr	s14, [pc, #696]	; 919c <_Z11split_floatfRjS_Ri+0x420>
    8ee0:	ee677a87 	vmul.f32	s15, s15, s14
    8ee4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ee8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8eec:	e5933000 	ldr	r3, [r3]
    8ef0:	e2832001 	add	r2, r3, #1
    8ef4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ef8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    8efc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f00:	eef57ac0 	vcmpe.f32	s15, #0.0
    8f04:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f08:	da000058 	ble	9070 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    8f0c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f10:	ed9f7aa2 	vldr	s14, [pc, #648]	; 91a0 <_Z11split_floatfRjS_Ri+0x424>
    8f14:	eef47ac7 	vcmpe.f32	s15, s14
    8f18:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f1c:	8a000053 	bhi	9070 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    8f20:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f24:	ed9f7a9e 	vldr	s14, [pc, #632]	; 91a4 <_Z11split_floatfRjS_Ri+0x428>
    8f28:	eef47ac7 	vcmpe.f32	s15, s14
    8f2c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f30:	5a000008 	bpl	8f58 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    8f34:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f38:	ed9f7a8d 	vldr	s14, [pc, #564]	; 9174 <_Z11split_floatfRjS_Ri+0x3f8>
    8f3c:	ee677a87 	vmul.f32	s15, s15, s14
    8f40:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f44:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f48:	e5933000 	ldr	r3, [r3]
    8f4c:	e2432020 	sub	r2, r3, #32
    8f50:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f54:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    8f58:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f5c:	ed9f7a91 	vldr	s14, [pc, #580]	; 91a8 <_Z11split_floatfRjS_Ri+0x42c>
    8f60:	eef47ac7 	vcmpe.f32	s15, s14
    8f64:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f68:	5a000008 	bpl	8f90 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    8f6c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f70:	ed9f7a81 	vldr	s14, [pc, #516]	; 917c <_Z11split_floatfRjS_Ri+0x400>
    8f74:	ee677a87 	vmul.f32	s15, s15, s14
    8f78:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f7c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f80:	e5933000 	ldr	r3, [r3]
    8f84:	e2432010 	sub	r2, r3, #16
    8f88:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f8c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    8f90:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f94:	ed9f7a84 	vldr	s14, [pc, #528]	; 91ac <_Z11split_floatfRjS_Ri+0x430>
    8f98:	eef47ac7 	vcmpe.f32	s15, s14
    8f9c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fa0:	5a000008 	bpl	8fc8 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    8fa4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fa8:	ed9f7a75 	vldr	s14, [pc, #468]	; 9184 <_Z11split_floatfRjS_Ri+0x408>
    8fac:	ee677a87 	vmul.f32	s15, s15, s14
    8fb0:	ed4b7a04 	vstr	s15, [fp, #-16]
    8fb4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fb8:	e5933000 	ldr	r3, [r3]
    8fbc:	e2432008 	sub	r2, r3, #8
    8fc0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fc4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    8fc8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fcc:	ed9f7a77 	vldr	s14, [pc, #476]	; 91b0 <_Z11split_floatfRjS_Ri+0x434>
    8fd0:	eef47ac7 	vcmpe.f32	s15, s14
    8fd4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fd8:	5a000008 	bpl	9000 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    8fdc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fe0:	ed9f7a69 	vldr	s14, [pc, #420]	; 918c <_Z11split_floatfRjS_Ri+0x410>
    8fe4:	ee677a87 	vmul.f32	s15, s15, s14
    8fe8:	ed4b7a04 	vstr	s15, [fp, #-16]
    8fec:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ff0:	e5933000 	ldr	r3, [r3]
    8ff4:	e2432004 	sub	r2, r3, #4
    8ff8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ffc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    9000:	ed5b7a04 	vldr	s15, [fp, #-16]
    9004:	ed9f7a64 	vldr	s14, [pc, #400]	; 919c <_Z11split_floatfRjS_Ri+0x420>
    9008:	eef47ac7 	vcmpe.f32	s15, s14
    900c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9010:	5a000008 	bpl	9038 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    9014:	ed5b7a04 	vldr	s15, [fp, #-16]
    9018:	ed9f7a5d 	vldr	s14, [pc, #372]	; 9194 <_Z11split_floatfRjS_Ri+0x418>
    901c:	ee677a87 	vmul.f32	s15, s15, s14
    9020:	ed4b7a04 	vstr	s15, [fp, #-16]
    9024:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9028:	e5933000 	ldr	r3, [r3]
    902c:	e2432002 	sub	r2, r3, #2
    9030:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9034:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    9038:	ed5b7a04 	vldr	s15, [fp, #-16]
    903c:	ed9f7a57 	vldr	s14, [pc, #348]	; 91a0 <_Z11split_floatfRjS_Ri+0x424>
    9040:	eef47ac7 	vcmpe.f32	s15, s14
    9044:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9048:	5a000008 	bpl	9070 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    904c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9050:	ed9f7a46 	vldr	s14, [pc, #280]	; 9170 <_Z11split_floatfRjS_Ri+0x3f4>
    9054:	ee677a87 	vmul.f32	s15, s15, s14
    9058:	ed4b7a04 	vstr	s15, [fp, #-16]
    905c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9060:	e5933000 	ldr	r3, [r3]
    9064:	e2432001 	sub	r2, r3, #1
    9068:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    906c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    9070:	ed5b7a04 	vldr	s15, [fp, #-16]
    9074:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9078:	ee172a90 	vmov	r2, s15
    907c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9080:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    9084:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9088:	e5933000 	ldr	r3, [r3]
    908c:	ee073a90 	vmov	s15, r3
    9090:	eef87a67 	vcvt.f32.u32	s15, s15
    9094:	ed1b7a04 	vldr	s14, [fp, #-16]
    9098:	ee777a67 	vsub.f32	s15, s14, s15
    909c:	ed9f7a38 	vldr	s14, [pc, #224]	; 9184 <_Z11split_floatfRjS_Ri+0x408>
    90a0:	ee677a87 	vmul.f32	s15, s15, s14
    90a4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    90a8:	ed5b7a02 	vldr	s15, [fp, #-8]
    90ac:	eefc7ae7 	vcvt.u32.f32	s15, s15
    90b0:	ee172a90 	vmov	r2, s15
    90b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90b8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    90bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90c0:	e5933000 	ldr	r3, [r3]
    90c4:	ee073a90 	vmov	s15, r3
    90c8:	eef87a67 	vcvt.f32.u32	s15, s15
    90cc:	ed1b7a02 	vldr	s14, [fp, #-8]
    90d0:	ee777a67 	vsub.f32	s15, s14, s15
    90d4:	ed9f7a36 	vldr	s14, [pc, #216]	; 91b4 <_Z11split_floatfRjS_Ri+0x438>
    90d8:	eef47ac7 	vcmpe.f32	s15, s14
    90dc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90e0:	aa000000 	bge	90e8 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    90e4:	ea00001d 	b	9160 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    90e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90ec:	e5933000 	ldr	r3, [r3]
    90f0:	e2832001 	add	r2, r3, #1
    90f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90f8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    90fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9100:	e5933000 	ldr	r3, [r3]
    9104:	e59f20ac 	ldr	r2, [pc, #172]	; 91b8 <_Z11split_floatfRjS_Ri+0x43c>
    9108:	e1530002 	cmp	r3, r2
    910c:	9a000013 	bls	9160 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    9110:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9114:	e3a02000 	mov	r2, #0
    9118:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    911c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9120:	e5933000 	ldr	r3, [r3]
    9124:	e2832001 	add	r2, r3, #1
    9128:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    912c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    9130:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9134:	e5933000 	ldr	r3, [r3]
    9138:	e3530009 	cmp	r3, #9
    913c:	9a000007 	bls	9160 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    9140:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9144:	e3a02001 	mov	r2, #1
    9148:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    914c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9150:	e5933000 	ldr	r3, [r3]
    9154:	e2832001 	add	r2, r3, #1
    9158:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    915c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    9160:	e320f000 	nop	{0}
    9164:	e28bd000 	add	sp, fp, #0
    9168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    916c:	e12fff1e 	bx	lr
    9170:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9174:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9178:	0a4fb11f 	beq	13f55fc <__bss_end+0x13eb390>
    917c:	5a0e1bca 	bpl	3900ac <__bss_end+0x385e40>
    9180:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    9184:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    9188:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    918c:	461c4000 	ldrmi	r4, [ip], -r0
    9190:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    9194:	42c80000 	sbcmi	r0, r8, #0
    9198:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    919c:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    91a0:	3f800000 	svccc	0x00800000
    91a4:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    91a8:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    91ac:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    91b0:	3a83126f 	bcc	fe0cdb74 <__bss_end+0xfe0c3908>
    91b4:	3f000000 	svccc	0x00000000
    91b8:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

000091bc <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    91bc:	e92d4800 	push	{fp, lr}
    91c0:	e28db004 	add	fp, sp, #4
    91c4:	e24dd018 	sub	sp, sp, #24
    91c8:	e50b0010 	str	r0, [fp, #-16]
    91cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    91d0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    91d4:	e3a03000 	mov	r3, #0
    91d8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    91dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91e0:	e2432001 	sub	r2, r3, #1
    91e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    91e8:	e3530000 	cmp	r3, #0
    91ec:	c3a03001 	movgt	r3, #1
    91f0:	d3a03000 	movle	r3, #0
    91f4:	e6ef3073 	uxtb	r3, r3
    91f8:	e3530000 	cmp	r3, #0
    91fc:	0a000018 	beq	9264 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    9200:	e51b1010 	ldr	r1, [fp, #-16]
    9204:	e59f3080 	ldr	r3, [pc, #128]	; 928c <_Z23decimal_to_string_floatjPci+0xd0>
    9208:	e0832193 	umull	r2, r3, r3, r1
    920c:	e1a021a3 	lsr	r2, r3, #3
    9210:	e1a03002 	mov	r3, r2
    9214:	e1a03103 	lsl	r3, r3, #2
    9218:	e0833002 	add	r3, r3, r2
    921c:	e1a03083 	lsl	r3, r3, #1
    9220:	e0412003 	sub	r2, r1, r3
    9224:	e6ef2072 	uxtb	r2, r2
    9228:	e51b3008 	ldr	r3, [fp, #-8]
    922c:	e2831001 	add	r1, r3, #1
    9230:	e50b1008 	str	r1, [fp, #-8]
    9234:	e1a01003 	mov	r1, r3
    9238:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    923c:	e0833001 	add	r3, r3, r1
    9240:	e2822030 	add	r2, r2, #48	; 0x30
    9244:	e6ef2072 	uxtb	r2, r2
    9248:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    924c:	e51b3010 	ldr	r3, [fp, #-16]
    9250:	e59f2034 	ldr	r2, [pc, #52]	; 928c <_Z23decimal_to_string_floatjPci+0xd0>
    9254:	e0832392 	umull	r2, r3, r2, r3
    9258:	e1a031a3 	lsr	r3, r3, #3
    925c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9260:	eaffffdd 	b	91dc <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    9264:	e51b3008 	ldr	r3, [fp, #-8]
    9268:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    926c:	e0823003 	add	r3, r2, r3
    9270:	e3a02000 	mov	r2, #0
    9274:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9278:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    927c:	ebfffe8d 	bl	8cb8 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    9280:	e320f000 	nop	{0}
    9284:	e24bd004 	sub	sp, fp, #4
    9288:	e8bd8800 	pop	{fp, pc}
    928c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00009290 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    9290:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9294:	e28db000 	add	fp, sp, #0
    9298:	e24dd00c 	sub	sp, sp, #12
    929c:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    92a0:	ed1b7a02 	vldr	s14, [fp, #-8]
    92a4:	ed5b7a02 	vldr	s15, [fp, #-8]
    92a8:	eeb47a67 	vcmp.f32	s14, s15
    92ac:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92b0:	13a03001 	movne	r3, #1
    92b4:	03a03000 	moveq	r3, #0
    92b8:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    92bc:	e1a00003 	mov	r0, r3
    92c0:	e28bd000 	add	sp, fp, #0
    92c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92c8:	e12fff1e 	bx	lr

000092cc <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    92cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    92d0:	e28db000 	add	fp, sp, #0
    92d4:	e24dd00c 	sub	sp, sp, #12
    92d8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    92dc:	ed5b7a02 	vldr	s15, [fp, #-8]
    92e0:	ed9f7a08 	vldr	s14, [pc, #32]	; 9308 <_Z5isinff+0x3c>
    92e4:	eef47ac7 	vcmpe.f32	s15, s14
    92e8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92ec:	c3a03001 	movgt	r3, #1
    92f0:	d3a03000 	movle	r3, #0
    92f4:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    92f8:	e1a00003 	mov	r0, r3
    92fc:	e28bd000 	add	sp, fp, #0
    9300:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9304:	e12fff1e 	bx	lr
    9308:	7f7fffff 	svcvc	0x007fffff

0000930c <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    930c:	e92d4800 	push	{fp, lr}
    9310:	e28db004 	add	fp, sp, #4
    9314:	e24dd008 	sub	sp, sp, #8
    9318:	ed0b0a02 	vstr	s0, [fp, #-8]
    931c:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    9320:	e3a01008 	mov	r1, #8
    9324:	e51b000c 	ldr	r0, [fp, #-12]
    9328:	ed1b0a02 	vldr	s0, [fp, #-8]
    932c:	eb000002 	bl	933c <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    9330:	e320f000 	nop	{0}
    9334:	e24bd004 	sub	sp, fp, #4
    9338:	e8bd8800 	pop	{fp, pc}

0000933c <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    933c:	e92d4800 	push	{fp, lr}
    9340:	e28db004 	add	fp, sp, #4
    9344:	e24dd060 	sub	sp, sp, #96	; 0x60
    9348:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    934c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    9350:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9354:	e3a03000 	mov	r3, #0
    9358:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    935c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9360:	eef57ac0 	vcmpe.f32	s15, #0.0
    9364:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9368:	5a000009 	bpl	9394 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    936c:	e51b3008 	ldr	r3, [fp, #-8]
    9370:	e2832001 	add	r2, r3, #1
    9374:	e50b2008 	str	r2, [fp, #-8]
    9378:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    937c:	e0823003 	add	r3, r2, r3
    9380:	e3a0202d 	mov	r2, #45	; 0x2d
    9384:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    9388:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    938c:	eef17a67 	vneg.f32	s15, s15
    9390:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    9394:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9398:	ebffffbc 	bl	9290 <_Z5isnanf>
    939c:	e1a03000 	mov	r3, r0
    93a0:	e3530000 	cmp	r3, #0
    93a4:	0a00001c 	beq	941c <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    93a8:	e51b3008 	ldr	r3, [fp, #-8]
    93ac:	e2832001 	add	r2, r3, #1
    93b0:	e50b2008 	str	r2, [fp, #-8]
    93b4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93b8:	e0823003 	add	r3, r2, r3
    93bc:	e3a0204e 	mov	r2, #78	; 0x4e
    93c0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    93c4:	e51b3008 	ldr	r3, [fp, #-8]
    93c8:	e2832001 	add	r2, r3, #1
    93cc:	e50b2008 	str	r2, [fp, #-8]
    93d0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93d4:	e0823003 	add	r3, r2, r3
    93d8:	e3a02061 	mov	r2, #97	; 0x61
    93dc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    93e0:	e51b3008 	ldr	r3, [fp, #-8]
    93e4:	e2832001 	add	r2, r3, #1
    93e8:	e50b2008 	str	r2, [fp, #-8]
    93ec:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    93f0:	e0823003 	add	r3, r2, r3
    93f4:	e3a0204e 	mov	r2, #78	; 0x4e
    93f8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    93fc:	e51b3008 	ldr	r3, [fp, #-8]
    9400:	e2832001 	add	r2, r3, #1
    9404:	e50b2008 	str	r2, [fp, #-8]
    9408:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    940c:	e0823003 	add	r3, r2, r3
    9410:	e3a02000 	mov	r2, #0
    9414:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    9418:	ea00008c 	b	9650 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    941c:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9420:	ebffffa9 	bl	92cc <_Z5isinff>
    9424:	e1a03000 	mov	r3, r0
    9428:	e3530000 	cmp	r3, #0
    942c:	0a00001c 	beq	94a4 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    9430:	e51b3008 	ldr	r3, [fp, #-8]
    9434:	e2832001 	add	r2, r3, #1
    9438:	e50b2008 	str	r2, [fp, #-8]
    943c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9440:	e0823003 	add	r3, r2, r3
    9444:	e3a02049 	mov	r2, #73	; 0x49
    9448:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    944c:	e51b3008 	ldr	r3, [fp, #-8]
    9450:	e2832001 	add	r2, r3, #1
    9454:	e50b2008 	str	r2, [fp, #-8]
    9458:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    945c:	e0823003 	add	r3, r2, r3
    9460:	e3a0206e 	mov	r2, #110	; 0x6e
    9464:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    9468:	e51b3008 	ldr	r3, [fp, #-8]
    946c:	e2832001 	add	r2, r3, #1
    9470:	e50b2008 	str	r2, [fp, #-8]
    9474:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9478:	e0823003 	add	r3, r2, r3
    947c:	e3a02066 	mov	r2, #102	; 0x66
    9480:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    9484:	e51b3008 	ldr	r3, [fp, #-8]
    9488:	e2832001 	add	r2, r3, #1
    948c:	e50b2008 	str	r2, [fp, #-8]
    9490:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9494:	e0823003 	add	r3, r2, r3
    9498:	e3a02000 	mov	r2, #0
    949c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    94a0:	ea00006a 	b	9650 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    94a4:	e3a03008 	mov	r3, #8
    94a8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    94ac:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    94b0:	e3530007 	cmp	r3, #7
    94b4:	8a000001 	bhi	94c0 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    94b8:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    94bc:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    94c0:	e51b300c 	ldr	r3, [fp, #-12]
    94c4:	e1a00003 	mov	r0, r3
    94c8:	ed9f0a62 	vldr	s0, [pc, #392]	; 9658 <_Z4ftoafPcj+0x31c>
    94cc:	ebfffdde 	bl	8c4c <_Z3powfj>
    94d0:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    94d4:	eddf6a60 	vldr	s13, [pc, #384]	; 965c <_Z4ftoafPcj+0x320>
    94d8:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    94dc:	eec67a87 	vdiv.f32	s15, s13, s14
    94e0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    94e4:	ee777a27 	vadd.f32	s15, s14, s15
    94e8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    94ec:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    94f0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    94f4:	ee173a90 	vmov	r3, s15
    94f8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    94fc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9500:	ee073a90 	vmov	s15, r3
    9504:	eef87a67 	vcvt.f32.u32	s15, s15
    9508:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    950c:	ee377a67 	vsub.f32	s14, s14, s15
    9510:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    9514:	ee677a27 	vmul.f32	s15, s14, s15
    9518:	eefc7ae7 	vcvt.u32.f32	s15, s15
    951c:	ee173a90 	vmov	r3, s15
    9520:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    9524:	e24b3044 	sub	r3, fp, #68	; 0x44
    9528:	e3a0200a 	mov	r2, #10
    952c:	e1a01003 	mov	r1, r3
    9530:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9534:	ebfffc96 	bl	8794 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9538:	e24b3044 	sub	r3, fp, #68	; 0x44
    953c:	e1a00003 	mov	r0, r3
    9540:	ebfffd72 	bl	8b10 <_Z6strlenPKc>
    9544:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9548:	e3a03000 	mov	r3, #0
    954c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    9550:	e51b2010 	ldr	r2, [fp, #-16]
    9554:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9558:	e1520003 	cmp	r2, r3
    955c:	aa00000d 	bge	9598 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    9560:	e51b3008 	ldr	r3, [fp, #-8]
    9564:	e2832001 	add	r2, r3, #1
    9568:	e50b2008 	str	r2, [fp, #-8]
    956c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9570:	e0823003 	add	r3, r2, r3
    9574:	e24b1044 	sub	r1, fp, #68	; 0x44
    9578:	e51b2010 	ldr	r2, [fp, #-16]
    957c:	e0812002 	add	r2, r1, r2
    9580:	e5d22000 	ldrb	r2, [r2]
    9584:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    9588:	e51b3010 	ldr	r3, [fp, #-16]
    958c:	e2833001 	add	r3, r3, #1
    9590:	e50b3010 	str	r3, [fp, #-16]
    9594:	eaffffed 	b	9550 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    9598:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    959c:	e3530000 	cmp	r3, #0
    95a0:	0a000025 	beq	963c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    95a4:	e51b3008 	ldr	r3, [fp, #-8]
    95a8:	e2832001 	add	r2, r3, #1
    95ac:	e50b2008 	str	r2, [fp, #-8]
    95b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    95b4:	e0823003 	add	r3, r2, r3
    95b8:	e3a0202e 	mov	r2, #46	; 0x2e
    95bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    95c0:	e24b3050 	sub	r3, fp, #80	; 0x50
    95c4:	e51b200c 	ldr	r2, [fp, #-12]
    95c8:	e1a01003 	mov	r1, r3
    95cc:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    95d0:	ebfffef9 	bl	91bc <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    95d4:	e3a03000 	mov	r3, #0
    95d8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    95dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95e0:	e3530008 	cmp	r3, #8
    95e4:	ca000014 	bgt	963c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    95e8:	e24b2050 	sub	r2, fp, #80	; 0x50
    95ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    95f0:	e0823003 	add	r3, r2, r3
    95f4:	e5d33000 	ldrb	r3, [r3]
    95f8:	e3530000 	cmp	r3, #0
    95fc:	0a00000d 	beq	9638 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    9600:	e51b3008 	ldr	r3, [fp, #-8]
    9604:	e2832001 	add	r2, r3, #1
    9608:	e50b2008 	str	r2, [fp, #-8]
    960c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9610:	e0823003 	add	r3, r2, r3
    9614:	e24b1050 	sub	r1, fp, #80	; 0x50
    9618:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    961c:	e0812002 	add	r2, r1, r2
    9620:	e5d22000 	ldrb	r2, [r2]
    9624:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    9628:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    962c:	e2833001 	add	r3, r3, #1
    9630:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9634:	eaffffe8 	b	95dc <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9638:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    963c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9640:	e51b3008 	ldr	r3, [fp, #-8]
    9644:	e0823003 	add	r3, r2, r3
    9648:	e3a02000 	mov	r2, #0
    964c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    9650:	e24bd004 	sub	sp, fp, #4
    9654:	e8bd8800 	pop	{fp, pc}
    9658:	41200000 			; <UNDEFINED> instruction: 0x41200000
    965c:	3f000000 	svccc	0x00000000

00009660 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    9660:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9664:	e28db000 	add	fp, sp, #0
    9668:	e24dd01c 	sub	sp, sp, #28
    966c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    9670:	e3a03000 	mov	r3, #0
    9674:	e50b3008 	str	r3, [fp, #-8]
    9678:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    967c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    9680:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9684:	e5d33000 	ldrb	r3, [r3]
    9688:	e353002d 	cmp	r3, #45	; 0x2d
    968c:	1a000004 	bne	96a4 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    9690:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9694:	e2833001 	add	r3, r3, #1
    9698:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    969c:	e59f30c8 	ldr	r3, [pc, #200]	; 976c <_Z4atofPKc+0x10c>
    96a0:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    96a4:	e3a03000 	mov	r3, #0
    96a8:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    96ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    96b0:	e5d33000 	ldrb	r3, [r3]
    96b4:	e3530000 	cmp	r3, #0
    96b8:	0a000023 	beq	974c <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    96bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    96c0:	e5d33000 	ldrb	r3, [r3]
    96c4:	e353002e 	cmp	r3, #46	; 0x2e
    96c8:	1a000002 	bne	96d8 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    96cc:	e3a03001 	mov	r3, #1
    96d0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    96d4:	ea000018 	b	973c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    96d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    96dc:	e5d33000 	ldrb	r3, [r3]
    96e0:	e2433030 	sub	r3, r3, #48	; 0x30
    96e4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    96e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96ec:	e3530000 	cmp	r3, #0
    96f0:	ba000011 	blt	973c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    96f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96f8:	e3530009 	cmp	r3, #9
    96fc:	ca00000e 	bgt	973c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    9700:	e51b3010 	ldr	r3, [fp, #-16]
    9704:	e3530000 	cmp	r3, #0
    9708:	0a000003 	beq	971c <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    970c:	ed1b7a03 	vldr	s14, [fp, #-12]
    9710:	eddf6a14 	vldr	s13, [pc, #80]	; 9768 <_Z4atofPKc+0x108>
    9714:	eec77a26 	vdiv.f32	s15, s14, s13
    9718:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    971c:	ed5b7a02 	vldr	s15, [fp, #-8]
    9720:	ed9f7a10 	vldr	s14, [pc, #64]	; 9768 <_Z4atofPKc+0x108>
    9724:	ee277a87 	vmul.f32	s14, s15, s14
    9728:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    972c:	ee073a90 	vmov	s15, r3
    9730:	eef87ae7 	vcvt.f32.s32	s15, s15
    9734:	ee777a27 	vadd.f32	s15, s14, s15
    9738:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    973c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9740:	e2833001 	add	r3, r3, #1
    9744:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9748:	eaffffd7 	b	96ac <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    974c:	ed1b7a02 	vldr	s14, [fp, #-8]
    9750:	ed5b7a03 	vldr	s15, [fp, #-12]
    9754:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9758:	eeb00a67 	vmov.f32	s0, s15
    975c:	e28bd000 	add	sp, fp, #0
    9760:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9764:	e12fff1e 	bx	lr
    9768:	41200000 			; <UNDEFINED> instruction: 0x41200000
    976c:	bf800000 	svclt	0x00800000

00009770 <_ZN13COLED_DisplayC1EPKc>:
_ZN13COLED_DisplayC2EPKc():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:10
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    9770:	e92d4800 	push	{fp, lr}
    9774:	e28db004 	add	fp, sp, #4
    9778:	e24dd008 	sub	sp, sp, #8
    977c:	e50b0008 	str	r0, [fp, #-8]
    9780:	e50b100c 	str	r1, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:11
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
    9784:	e3a01001 	mov	r1, #1
    9788:	e51b000c 	ldr	r0, [fp, #-12]
    978c:	ebfffb06 	bl	83ac <_Z4openPKc15NFile_Open_Mode>
    9790:	e1a02000 	mov	r2, r0
    9794:	e51b3008 	ldr	r3, [fp, #-8]
    9798:	e5832000 	str	r2, [r3]
    979c:	e51b3008 	ldr	r3, [fp, #-8]
    97a0:	e3a02000 	mov	r2, #0
    97a4:	e5c32004 	strb	r2, [r3, #4]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:14
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
    97a8:	e51b3008 	ldr	r3, [fp, #-8]
    97ac:	e5933000 	ldr	r3, [r3]
    97b0:	e3730001 	cmn	r3, #1
    97b4:	13a03001 	movne	r3, #1
    97b8:	03a03000 	moveq	r3, #0
    97bc:	e6ef2073 	uxtb	r2, r3
    97c0:	e51b3008 	ldr	r3, [fp, #-8]
    97c4:	e5c32004 	strb	r2, [r3, #4]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:15
}
    97c8:	e51b3008 	ldr	r3, [fp, #-8]
    97cc:	e1a00003 	mov	r0, r3
    97d0:	e24bd004 	sub	sp, fp, #4
    97d4:	e8bd8800 	pop	{fp, pc}

000097d8 <_ZN13COLED_DisplayD1Ev>:
_ZN13COLED_DisplayD2Ev():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:17

COLED_Display::~COLED_Display()
    97d8:	e92d4800 	push	{fp, lr}
    97dc:	e28db004 	add	fp, sp, #4
    97e0:	e24dd008 	sub	sp, sp, #8
    97e4:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:20
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    97e8:	e51b3008 	ldr	r3, [fp, #-8]
    97ec:	e5d33004 	ldrb	r3, [r3, #4]
    97f0:	e3530000 	cmp	r3, #0
    97f4:	0a000006 	beq	9814 <_ZN13COLED_DisplayD1Ev+0x3c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:22
    {
        mOpened = false;
    97f8:	e51b3008 	ldr	r3, [fp, #-8]
    97fc:	e3a02000 	mov	r2, #0
    9800:	e5c32004 	strb	r2, [r3, #4]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:23
        close(mHandle);
    9804:	e51b3008 	ldr	r3, [fp, #-8]
    9808:	e5933000 	ldr	r3, [r3]
    980c:	e1a00003 	mov	r0, r3
    9810:	ebfffb1e 	bl	8490 <_Z5closej>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:25
    }
}
    9814:	e51b3008 	ldr	r3, [fp, #-8]
    9818:	e1a00003 	mov	r0, r3
    981c:	e24bd004 	sub	sp, fp, #4
    9820:	e8bd8800 	pop	{fp, pc}

00009824 <_ZNK13COLED_Display9Is_OpenedEv>:
_ZNK13COLED_Display9Is_OpenedEv():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:28

bool COLED_Display::Is_Opened() const
{
    9824:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9828:	e28db000 	add	fp, sp, #0
    982c:	e24dd00c 	sub	sp, sp, #12
    9830:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:29
    return mOpened;
    9834:	e51b3008 	ldr	r3, [fp, #-8]
    9838:	e5d33004 	ldrb	r3, [r3, #4]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:30
}
    983c:	e1a00003 	mov	r0, r3
    9840:	e28bd000 	add	sp, fp, #0
    9844:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9848:	e12fff1e 	bx	lr

0000984c <_ZN13COLED_Display5ClearEb>:
_ZN13COLED_Display5ClearEb():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:33

void COLED_Display::Clear(bool clearSet)
{
    984c:	e92d4800 	push	{fp, lr}
    9850:	e28db004 	add	fp, sp, #4
    9854:	e24dd010 	sub	sp, sp, #16
    9858:	e50b0010 	str	r0, [fp, #-16]
    985c:	e1a03001 	mov	r3, r1
    9860:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:34
    if (!mOpened)
    9864:	e51b3010 	ldr	r3, [fp, #-16]
    9868:	e5d33004 	ldrb	r3, [r3, #4]
    986c:	e2233001 	eor	r3, r3, #1
    9870:	e6ef3073 	uxtb	r3, r3
    9874:	e3530000 	cmp	r3, #0
    9878:	1a00000f 	bne	98bc <_ZN13COLED_Display5ClearEb+0x70>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:38
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
    987c:	e3a03002 	mov	r3, #2
    9880:	e54b3008 	strb	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:39
	pkt.clearSet = clearSet ? 1 : 0;
    9884:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    9888:	e3530000 	cmp	r3, #0
    988c:	0a000001 	beq	9898 <_ZN13COLED_Display5ClearEb+0x4c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:39 (discriminator 1)
    9890:	e3a03001 	mov	r3, #1
    9894:	ea000000 	b	989c <_ZN13COLED_Display5ClearEb+0x50>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:39 (discriminator 2)
    9898:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:39 (discriminator 4)
    989c:	e54b3007 	strb	r3, [fp, #-7]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:40 (discriminator 4)
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    98a0:	e51b3010 	ldr	r3, [fp, #-16]
    98a4:	e5933000 	ldr	r3, [r3]
    98a8:	e24b1008 	sub	r1, fp, #8
    98ac:	e3a02002 	mov	r2, #2
    98b0:	e1a00003 	mov	r0, r3
    98b4:	ebfffae1 	bl	8440 <_Z5writejPKcj>
    98b8:	ea000000 	b	98c0 <_ZN13COLED_Display5ClearEb+0x74>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:35
        return;
    98bc:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:41
}
    98c0:	e24bd004 	sub	sp, fp, #4
    98c4:	e8bd8800 	pop	{fp, pc}

000098c8 <_ZN13COLED_Display9Set_PixelEttb>:
_ZN13COLED_Display9Set_PixelEttb():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:44

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    98c8:	e92d4800 	push	{fp, lr}
    98cc:	e28db004 	add	fp, sp, #4
    98d0:	e24dd018 	sub	sp, sp, #24
    98d4:	e50b0010 	str	r0, [fp, #-16]
    98d8:	e1a00001 	mov	r0, r1
    98dc:	e1a01002 	mov	r1, r2
    98e0:	e1a02003 	mov	r2, r3
    98e4:	e1a03000 	mov	r3, r0
    98e8:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    98ec:	e1a03001 	mov	r3, r1
    98f0:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
    98f4:	e1a03002 	mov	r3, r2
    98f8:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:45
    if (!mOpened)
    98fc:	e51b3010 	ldr	r3, [fp, #-16]
    9900:	e5d33004 	ldrb	r3, [r3, #4]
    9904:	e2233001 	eor	r3, r3, #1
    9908:	e6ef3073 	uxtb	r3, r3
    990c:	e3530000 	cmp	r3, #0
    9910:	1a000024 	bne	99a8 <_ZN13COLED_Display9Set_PixelEttb+0xe0>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:50
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    9914:	e3a03003 	mov	r3, #3
    9918:	e54b300c 	strb	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:51
    pkt.count = 1;
    991c:	e3a03000 	mov	r3, #0
    9920:	e3833001 	orr	r3, r3, #1
    9924:	e54b300b 	strb	r3, [fp, #-11]
    9928:	e3a03000 	mov	r3, #0
    992c:	e54b300a 	strb	r3, [fp, #-10]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:52
    pkt.first.x = x;
    9930:	e55b3012 	ldrb	r3, [fp, #-18]	; 0xffffffee
    9934:	e3a02000 	mov	r2, #0
    9938:	e1823003 	orr	r3, r2, r3
    993c:	e54b3009 	strb	r3, [fp, #-9]
    9940:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    9944:	e3a02000 	mov	r2, #0
    9948:	e1823003 	orr	r3, r2, r3
    994c:	e54b3008 	strb	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:53
    pkt.first.y = y;
    9950:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    9954:	e3a02000 	mov	r2, #0
    9958:	e1823003 	orr	r3, r2, r3
    995c:	e54b3007 	strb	r3, [fp, #-7]
    9960:	e55b3013 	ldrb	r3, [fp, #-19]	; 0xffffffed
    9964:	e3a02000 	mov	r2, #0
    9968:	e1823003 	orr	r3, r2, r3
    996c:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:54
    pkt.first.set = set ? 1 : 0;
    9970:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9974:	e3530000 	cmp	r3, #0
    9978:	0a000001 	beq	9984 <_ZN13COLED_Display9Set_PixelEttb+0xbc>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:54 (discriminator 1)
    997c:	e3a03001 	mov	r3, #1
    9980:	ea000000 	b	9988 <_ZN13COLED_Display9Set_PixelEttb+0xc0>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:54 (discriminator 2)
    9984:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:54 (discriminator 4)
    9988:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:55 (discriminator 4)
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    998c:	e51b3010 	ldr	r3, [fp, #-16]
    9990:	e5933000 	ldr	r3, [r3]
    9994:	e24b100c 	sub	r1, fp, #12
    9998:	e3a02008 	mov	r2, #8
    999c:	e1a00003 	mov	r0, r3
    99a0:	ebfffaa6 	bl	8440 <_Z5writejPKcj>
    99a4:	ea000000 	b	99ac <_ZN13COLED_Display9Set_PixelEttb+0xe4>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:46
        return;
    99a8:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:56
}
    99ac:	e24bd004 	sub	sp, fp, #4
    99b0:	e8bd8800 	pop	{fp, pc}

000099b4 <_ZN13COLED_Display8Put_CharEttc>:
_ZN13COLED_Display8Put_CharEttc():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:59

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    99b4:	e92d4800 	push	{fp, lr}
    99b8:	e28db004 	add	fp, sp, #4
    99bc:	e24dd028 	sub	sp, sp, #40	; 0x28
    99c0:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    99c4:	e1a00001 	mov	r0, r1
    99c8:	e1a01002 	mov	r1, r2
    99cc:	e1a02003 	mov	r2, r3
    99d0:	e1a03000 	mov	r3, r0
    99d4:	e14b32b2 	strh	r3, [fp, #-34]	; 0xffffffde
    99d8:	e1a03001 	mov	r3, r1
    99dc:	e14b32b4 	strh	r3, [fp, #-36]	; 0xffffffdc
    99e0:	e1a03002 	mov	r3, r2
    99e4:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:60
    if (!mOpened)
    99e8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    99ec:	e5d33004 	ldrb	r3, [r3, #4]
    99f0:	e2233001 	eor	r3, r3, #1
    99f4:	e6ef3073 	uxtb	r3, r3
    99f8:	e3530000 	cmp	r3, #0
    99fc:	1a000040 	bne	9b04 <_ZN13COLED_Display8Put_CharEttc+0x150>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:64
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
    9a00:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    9a04:	e353001f 	cmp	r3, #31
    9a08:	9a00003f 	bls	9b0c <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:64 (discriminator 1)
    9a0c:	e15b32d5 	ldrsb	r3, [fp, #-37]	; 0xffffffdb
    9a10:	e3530000 	cmp	r3, #0
    9a14:	ba00003c 	blt	9b0c <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:69
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    9a18:	e24b301c 	sub	r3, fp, #28
    9a1c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:70
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    9a20:	e51b3008 	ldr	r3, [fp, #-8]
    9a24:	e3a02004 	mov	r2, #4
    9a28:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:71
    ptr->w = OLED_Font::Char_Width;
    9a2c:	e51b3008 	ldr	r3, [fp, #-8]
    9a30:	e3a02000 	mov	r2, #0
    9a34:	e3822006 	orr	r2, r2, #6
    9a38:	e5c32005 	strb	r2, [r3, #5]
    9a3c:	e3a02000 	mov	r2, #0
    9a40:	e5c32006 	strb	r2, [r3, #6]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:72
    ptr->h = OLED_Font::Char_Height;
    9a44:	e51b3008 	ldr	r3, [fp, #-8]
    9a48:	e3a02000 	mov	r2, #0
    9a4c:	e3822008 	orr	r2, r2, #8
    9a50:	e5c32007 	strb	r2, [r3, #7]
    9a54:	e3a02000 	mov	r2, #0
    9a58:	e5c32008 	strb	r2, [r3, #8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:73
    ptr->x1 = x;
    9a5c:	e51b3008 	ldr	r3, [fp, #-8]
    9a60:	e55b2022 	ldrb	r2, [fp, #-34]	; 0xffffffde
    9a64:	e3a01000 	mov	r1, #0
    9a68:	e1812002 	orr	r2, r1, r2
    9a6c:	e5c32001 	strb	r2, [r3, #1]
    9a70:	e55b2021 	ldrb	r2, [fp, #-33]	; 0xffffffdf
    9a74:	e3a01000 	mov	r1, #0
    9a78:	e1812002 	orr	r2, r1, r2
    9a7c:	e5c32002 	strb	r2, [r3, #2]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:74
    ptr->y1 = y;
    9a80:	e51b3008 	ldr	r3, [fp, #-8]
    9a84:	e55b2024 	ldrb	r2, [fp, #-36]	; 0xffffffdc
    9a88:	e3a01000 	mov	r1, #0
    9a8c:	e1812002 	orr	r2, r1, r2
    9a90:	e5c32003 	strb	r2, [r3, #3]
    9a94:	e55b2023 	ldrb	r2, [fp, #-35]	; 0xffffffdd
    9a98:	e3a01000 	mov	r1, #0
    9a9c:	e1812002 	orr	r2, r1, r2
    9aa0:	e5c32004 	strb	r2, [r3, #4]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:75
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    9aa4:	e51b3008 	ldr	r3, [fp, #-8]
    9aa8:	e3a02001 	mov	r2, #1
    9aac:	e5c32009 	strb	r2, [r3, #9]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:77
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);
    9ab0:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    9ab4:	e2432020 	sub	r2, r3, #32
    9ab8:	e1a03002 	mov	r3, r2
    9abc:	e1a03083 	lsl	r3, r3, #1
    9ac0:	e0833002 	add	r3, r3, r2
    9ac4:	e1a03083 	lsl	r3, r3, #1
    9ac8:	e1a02003 	mov	r2, r3
    9acc:	e59f3044 	ldr	r3, [pc, #68]	; 9b18 <_ZN13COLED_Display8Put_CharEttc+0x164>
    9ad0:	e0820003 	add	r0, r2, r3
    9ad4:	e51b3008 	ldr	r3, [fp, #-8]
    9ad8:	e283300a 	add	r3, r3, #10
    9adc:	e3a02006 	mov	r2, #6
    9ae0:	e1a01003 	mov	r1, r3
    9ae4:	ebfffc38 	bl	8bcc <_Z6memcpyPKvPvi>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:79

    write(mHandle, buf, sizeof(buf));
    9ae8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9aec:	e5933000 	ldr	r3, [r3]
    9af0:	e24b101c 	sub	r1, fp, #28
    9af4:	e3a02011 	mov	r2, #17
    9af8:	e1a00003 	mov	r0, r3
    9afc:	ebfffa4f 	bl	8440 <_Z5writejPKcj>
    9b00:	ea000002 	b	9b10 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:61
        return;
    9b04:	e320f000 	nop	{0}
    9b08:	ea000000 	b	9b10 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:65
        return;
    9b0c:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:80
}
    9b10:	e24bd004 	sub	sp, fp, #4
    9b14:	e8bd8800 	pop	{fp, pc}
    9b18:	0000a008 	andeq	sl, r0, r8

00009b1c <_ZN13COLED_Display4FlipEv>:
_ZN13COLED_Display4FlipEv():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:83

void COLED_Display::Flip()
{
    9b1c:	e92d4800 	push	{fp, lr}
    9b20:	e28db004 	add	fp, sp, #4
    9b24:	e24dd010 	sub	sp, sp, #16
    9b28:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:84
    if (!mOpened)
    9b2c:	e51b3010 	ldr	r3, [fp, #-16]
    9b30:	e5d33004 	ldrb	r3, [r3, #4]
    9b34:	e2233001 	eor	r3, r3, #1
    9b38:	e6ef3073 	uxtb	r3, r3
    9b3c:	e3530000 	cmp	r3, #0
    9b40:	1a000008 	bne	9b68 <_ZN13COLED_Display4FlipEv+0x4c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:88
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;
    9b44:	e3a03001 	mov	r3, #1
    9b48:	e54b3008 	strb	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:90

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    9b4c:	e51b3010 	ldr	r3, [fp, #-16]
    9b50:	e5933000 	ldr	r3, [r3]
    9b54:	e24b1008 	sub	r1, fp, #8
    9b58:	e3a02001 	mov	r2, #1
    9b5c:	e1a00003 	mov	r0, r3
    9b60:	ebfffa36 	bl	8440 <_Z5writejPKcj>
    9b64:	ea000000 	b	9b6c <_ZN13COLED_Display4FlipEv+0x50>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:85
        return;
    9b68:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:91
}
    9b6c:	e24bd004 	sub	sp, fp, #4
    9b70:	e8bd8800 	pop	{fp, pc}

00009b74 <_ZN13COLED_Display10Put_StringEttPKc>:
_ZN13COLED_Display10Put_StringEttPKc():
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:94

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    9b74:	e92d4800 	push	{fp, lr}
    9b78:	e28db004 	add	fp, sp, #4
    9b7c:	e24dd018 	sub	sp, sp, #24
    9b80:	e50b0010 	str	r0, [fp, #-16]
    9b84:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9b88:	e1a03001 	mov	r3, r1
    9b8c:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    9b90:	e1a03002 	mov	r3, r2
    9b94:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:95
    if (!mOpened)
    9b98:	e51b3010 	ldr	r3, [fp, #-16]
    9b9c:	e5d33004 	ldrb	r3, [r3, #4]
    9ba0:	e2233001 	eor	r3, r3, #1
    9ba4:	e6ef3073 	uxtb	r3, r3
    9ba8:	e3530000 	cmp	r3, #0
    9bac:	1a000019 	bne	9c18 <_ZN13COLED_Display10Put_StringEttPKc+0xa4>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:98
        return;

    uint16_t xi = x;
    9bb0:	e15b31b2 	ldrh	r3, [fp, #-18]	; 0xffffffee
    9bb4:	e14b30b6 	strh	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:99
    const char* ptr = str;
    9bb8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9bbc:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:101
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    9bc0:	e51b300c 	ldr	r3, [fp, #-12]
    9bc4:	e5d33000 	ldrb	r3, [r3]
    9bc8:	e3530000 	cmp	r3, #0
    9bcc:	0a000012 	beq	9c1c <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:101 (discriminator 1)
    9bd0:	e51b200c 	ldr	r2, [fp, #-12]
    9bd4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9bd8:	e0423003 	sub	r3, r2, r3
    9bdc:	e353003f 	cmp	r3, #63	; 0x3f
    9be0:	ca00000d 	bgt	9c1c <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:103
    {
        Put_Char(xi, y, *ptr);
    9be4:	e51b300c 	ldr	r3, [fp, #-12]
    9be8:	e5d33000 	ldrb	r3, [r3]
    9bec:	e15b21b4 	ldrh	r2, [fp, #-20]	; 0xffffffec
    9bf0:	e15b10b6 	ldrh	r1, [fp, #-6]
    9bf4:	e51b0010 	ldr	r0, [fp, #-16]
    9bf8:	ebffff6d 	bl	99b4 <_ZN13COLED_Display8Put_CharEttc>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:104
        xi += OLED_Font::Char_Width;
    9bfc:	e15b30b6 	ldrh	r3, [fp, #-6]
    9c00:	e2833006 	add	r3, r3, #6
    9c04:	e14b30b6 	strh	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:105
        ptr++;
    9c08:	e51b300c 	ldr	r3, [fp, #-12]
    9c0c:	e2833001 	add	r3, r3, #1
    9c10:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:101
    while (*ptr != '\0' && ptr - str < 64)
    9c14:	eaffffe9 	b	9bc0 <_ZN13COLED_Display10Put_StringEttPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:96
        return;
    9c18:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdutils/src/oled.cpp:107
    }
}
    9c1c:	e24bd004 	sub	sp, fp, #4
    9c20:	e8bd8800 	pop	{fp, pc}

00009c24 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9c24:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9c28:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9c2c:	3a000074 	bcc	9e04 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    9c30:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9c34:	9a00006b 	bls	9de8 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9c38:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9c3c:	0a00006c 	beq	9df4 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9c40:	e16f3f10 	clz	r3, r0
    9c44:	e16f2f11 	clz	r2, r1
    9c48:	e0423003 	sub	r3, r2, r3
    9c4c:	e273301f 	rsbs	r3, r3, #31
    9c50:	10833083 	addne	r3, r3, r3, lsl #1
    9c54:	e3a02000 	mov	r2, #0
    9c58:	108ff103 	addne	pc, pc, r3, lsl #2
    9c5c:	e1a00000 	nop			; (mov r0, r0)
    9c60:	e1500f81 	cmp	r0, r1, lsl #31
    9c64:	e0a22002 	adc	r2, r2, r2
    9c68:	20400f81 	subcs	r0, r0, r1, lsl #31
    9c6c:	e1500f01 	cmp	r0, r1, lsl #30
    9c70:	e0a22002 	adc	r2, r2, r2
    9c74:	20400f01 	subcs	r0, r0, r1, lsl #30
    9c78:	e1500e81 	cmp	r0, r1, lsl #29
    9c7c:	e0a22002 	adc	r2, r2, r2
    9c80:	20400e81 	subcs	r0, r0, r1, lsl #29
    9c84:	e1500e01 	cmp	r0, r1, lsl #28
    9c88:	e0a22002 	adc	r2, r2, r2
    9c8c:	20400e01 	subcs	r0, r0, r1, lsl #28
    9c90:	e1500d81 	cmp	r0, r1, lsl #27
    9c94:	e0a22002 	adc	r2, r2, r2
    9c98:	20400d81 	subcs	r0, r0, r1, lsl #27
    9c9c:	e1500d01 	cmp	r0, r1, lsl #26
    9ca0:	e0a22002 	adc	r2, r2, r2
    9ca4:	20400d01 	subcs	r0, r0, r1, lsl #26
    9ca8:	e1500c81 	cmp	r0, r1, lsl #25
    9cac:	e0a22002 	adc	r2, r2, r2
    9cb0:	20400c81 	subcs	r0, r0, r1, lsl #25
    9cb4:	e1500c01 	cmp	r0, r1, lsl #24
    9cb8:	e0a22002 	adc	r2, r2, r2
    9cbc:	20400c01 	subcs	r0, r0, r1, lsl #24
    9cc0:	e1500b81 	cmp	r0, r1, lsl #23
    9cc4:	e0a22002 	adc	r2, r2, r2
    9cc8:	20400b81 	subcs	r0, r0, r1, lsl #23
    9ccc:	e1500b01 	cmp	r0, r1, lsl #22
    9cd0:	e0a22002 	adc	r2, r2, r2
    9cd4:	20400b01 	subcs	r0, r0, r1, lsl #22
    9cd8:	e1500a81 	cmp	r0, r1, lsl #21
    9cdc:	e0a22002 	adc	r2, r2, r2
    9ce0:	20400a81 	subcs	r0, r0, r1, lsl #21
    9ce4:	e1500a01 	cmp	r0, r1, lsl #20
    9ce8:	e0a22002 	adc	r2, r2, r2
    9cec:	20400a01 	subcs	r0, r0, r1, lsl #20
    9cf0:	e1500981 	cmp	r0, r1, lsl #19
    9cf4:	e0a22002 	adc	r2, r2, r2
    9cf8:	20400981 	subcs	r0, r0, r1, lsl #19
    9cfc:	e1500901 	cmp	r0, r1, lsl #18
    9d00:	e0a22002 	adc	r2, r2, r2
    9d04:	20400901 	subcs	r0, r0, r1, lsl #18
    9d08:	e1500881 	cmp	r0, r1, lsl #17
    9d0c:	e0a22002 	adc	r2, r2, r2
    9d10:	20400881 	subcs	r0, r0, r1, lsl #17
    9d14:	e1500801 	cmp	r0, r1, lsl #16
    9d18:	e0a22002 	adc	r2, r2, r2
    9d1c:	20400801 	subcs	r0, r0, r1, lsl #16
    9d20:	e1500781 	cmp	r0, r1, lsl #15
    9d24:	e0a22002 	adc	r2, r2, r2
    9d28:	20400781 	subcs	r0, r0, r1, lsl #15
    9d2c:	e1500701 	cmp	r0, r1, lsl #14
    9d30:	e0a22002 	adc	r2, r2, r2
    9d34:	20400701 	subcs	r0, r0, r1, lsl #14
    9d38:	e1500681 	cmp	r0, r1, lsl #13
    9d3c:	e0a22002 	adc	r2, r2, r2
    9d40:	20400681 	subcs	r0, r0, r1, lsl #13
    9d44:	e1500601 	cmp	r0, r1, lsl #12
    9d48:	e0a22002 	adc	r2, r2, r2
    9d4c:	20400601 	subcs	r0, r0, r1, lsl #12
    9d50:	e1500581 	cmp	r0, r1, lsl #11
    9d54:	e0a22002 	adc	r2, r2, r2
    9d58:	20400581 	subcs	r0, r0, r1, lsl #11
    9d5c:	e1500501 	cmp	r0, r1, lsl #10
    9d60:	e0a22002 	adc	r2, r2, r2
    9d64:	20400501 	subcs	r0, r0, r1, lsl #10
    9d68:	e1500481 	cmp	r0, r1, lsl #9
    9d6c:	e0a22002 	adc	r2, r2, r2
    9d70:	20400481 	subcs	r0, r0, r1, lsl #9
    9d74:	e1500401 	cmp	r0, r1, lsl #8
    9d78:	e0a22002 	adc	r2, r2, r2
    9d7c:	20400401 	subcs	r0, r0, r1, lsl #8
    9d80:	e1500381 	cmp	r0, r1, lsl #7
    9d84:	e0a22002 	adc	r2, r2, r2
    9d88:	20400381 	subcs	r0, r0, r1, lsl #7
    9d8c:	e1500301 	cmp	r0, r1, lsl #6
    9d90:	e0a22002 	adc	r2, r2, r2
    9d94:	20400301 	subcs	r0, r0, r1, lsl #6
    9d98:	e1500281 	cmp	r0, r1, lsl #5
    9d9c:	e0a22002 	adc	r2, r2, r2
    9da0:	20400281 	subcs	r0, r0, r1, lsl #5
    9da4:	e1500201 	cmp	r0, r1, lsl #4
    9da8:	e0a22002 	adc	r2, r2, r2
    9dac:	20400201 	subcs	r0, r0, r1, lsl #4
    9db0:	e1500181 	cmp	r0, r1, lsl #3
    9db4:	e0a22002 	adc	r2, r2, r2
    9db8:	20400181 	subcs	r0, r0, r1, lsl #3
    9dbc:	e1500101 	cmp	r0, r1, lsl #2
    9dc0:	e0a22002 	adc	r2, r2, r2
    9dc4:	20400101 	subcs	r0, r0, r1, lsl #2
    9dc8:	e1500081 	cmp	r0, r1, lsl #1
    9dcc:	e0a22002 	adc	r2, r2, r2
    9dd0:	20400081 	subcs	r0, r0, r1, lsl #1
    9dd4:	e1500001 	cmp	r0, r1
    9dd8:	e0a22002 	adc	r2, r2, r2
    9ddc:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9de0:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9de4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9de8:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9dec:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9df0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    9df4:	e16f2f11 	clz	r2, r1
    9df8:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9dfc:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9e00:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9e04:	e3500000 	cmp	r0, #0
    9e08:	13e00000 	mvnne	r0, #0
    9e0c:	ea000007 	b	9e30 <__aeabi_idiv0>

00009e10 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9e10:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9e14:	0afffffa 	beq	9e04 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9e18:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9e1c:	ebffff80 	bl	9c24 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    9e20:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9e24:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9e28:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9e2c:	e12fff1e 	bx	lr

00009e30 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9e30:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009e34 <_ZL8INFINITY>:
    9e34:	7f7fffff 	svcvc	0x007fffff

00009e38 <_ZL13Lock_Unlocked>:
    9e38:	00000000 	andeq	r0, r0, r0

00009e3c <_ZL11Lock_Locked>:
    9e3c:	00000001 	andeq	r0, r0, r1

00009e40 <_ZL21MaxFSDriverNameLength>:
    9e40:	00000010 	andeq	r0, r0, r0, lsl r0

00009e44 <_ZL17MaxFilenameLength>:
    9e44:	00000010 	andeq	r0, r0, r0, lsl r0

00009e48 <_ZL13MaxPathLength>:
    9e48:	00000080 	andeq	r0, r0, r0, lsl #1

00009e4c <_ZL18NoFilesystemDriver>:
    9e4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e50 <_ZL9NotifyAll>:
    9e50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e54 <_ZL24Max_Process_Opened_Files>:
    9e54:	00000010 	andeq	r0, r0, r0, lsl r0

00009e58 <_ZL10Indefinite>:
    9e58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e5c <_ZL18Deadline_Unchanged>:
    9e5c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009e60 <_ZL14Invalid_Handle>:
    9e60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e64 <_ZN3halL18Default_Clock_RateE>:
    9e64:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009e68 <_ZN3halL15Peripheral_BaseE>:
    9e68:	20000000 	andcs	r0, r0, r0

00009e6c <_ZN3halL9GPIO_BaseE>:
    9e6c:	20200000 	eorcs	r0, r0, r0

00009e70 <_ZN3halL14GPIO_Pin_CountE>:
    9e70:	00000036 	andeq	r0, r0, r6, lsr r0

00009e74 <_ZN3halL8AUX_BaseE>:
    9e74:	20215000 	eorcs	r5, r1, r0

00009e78 <_ZN3halL25Interrupt_Controller_BaseE>:
    9e78:	2000b200 	andcs	fp, r0, r0, lsl #4

00009e7c <_ZN3halL10Timer_BaseE>:
    9e7c:	2000b400 	andcs	fp, r0, r0, lsl #8

00009e80 <_ZN3halL9TRNG_BaseE>:
    9e80:	20104000 	andscs	r4, r0, r0

00009e84 <_ZN3halL9BSC0_BaseE>:
    9e84:	20205000 	eorcs	r5, r0, r0

00009e88 <_ZN3halL9BSC1_BaseE>:
    9e88:	20804000 	addcs	r4, r0, r0

00009e8c <_ZN3halL9BSC2_BaseE>:
    9e8c:	20805000 	addcs	r5, r0, r0

00009e90 <_ZL11Invalid_Pin>:
    9e90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9e94:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    9e98:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9e9c:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9ea0:	6f666572 	svcvs	0x00666572
    9ea4:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    9ea8:	2e6d6120 	powcsep	f6, f5, f0
    9eac:	00000000 	andeq	r0, r0, r0
    9eb0:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    9eb4:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    9eb8:	70206461 	eorvc	r6, r0, r1, ror #8
    9ebc:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    9ec0:	00002e73 	andeq	r2, r0, r3, ror lr
    9ec4:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    9ec8:	20555043 	subscs	r5, r5, r3, asr #32
    9ecc:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    9ed0:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    9ed4:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    9ed8:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    9edc:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    9ee0:	756f7661 	strbvc	r7, [pc, #-1633]!	; 9887 <_ZN13COLED_Display5ClearEb+0x3b>
    9ee4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    9ee8:	6f707320 	svcvs	0x00707320
    9eec:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    9ef0:	52412073 	subpl	r2, r1, #115	; 0x73
    9ef4:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    9ef8:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    9efc:	00676e69 	rsbeq	r6, r7, r9, ror #28
    9f00:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    9f04:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    9f08:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    9f0c:	61682064 	cmnvs	r8, r4, rrx
    9f10:	20612064 	rsbcs	r2, r1, r4, rrx
    9f14:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    9f18:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    9f1c:	00505247 	subseq	r5, r0, r7, asr #4
    9f20:	3a564544 	bcc	159b438 <__bss_end+0x15911cc>
    9f24:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    9f28:	00000000 	andeq	r0, r0, r0
    9f2c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    9f30:	534f5452 	movtpl	r5, #62546	; 0xf452
    9f34:	696e6920 	stmdbvs	lr!, {r5, r8, fp, sp, lr}^
    9f38:	2e2e2e74 	mcrcs	14, 1, r2, cr14, cr4, {3}
    9f3c:	00000000 	andeq	r0, r0, r0
    9f40:	3a564544 	bcc	159b458 <__bss_end+0x15911ec>
    9f44:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    9f48:	00000000 	andeq	r0, r0, r0

00009f4c <_ZL13Lock_Unlocked>:
    9f4c:	00000000 	andeq	r0, r0, r0

00009f50 <_ZL11Lock_Locked>:
    9f50:	00000001 	andeq	r0, r0, r1

00009f54 <_ZL21MaxFSDriverNameLength>:
    9f54:	00000010 	andeq	r0, r0, r0, lsl r0

00009f58 <_ZL17MaxFilenameLength>:
    9f58:	00000010 	andeq	r0, r0, r0, lsl r0

00009f5c <_ZL13MaxPathLength>:
    9f5c:	00000080 	andeq	r0, r0, r0, lsl #1

00009f60 <_ZL18NoFilesystemDriver>:
    9f60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f64 <_ZL9NotifyAll>:
    9f64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f68 <_ZL24Max_Process_Opened_Files>:
    9f68:	00000010 	andeq	r0, r0, r0, lsl r0

00009f6c <_ZL10Indefinite>:
    9f6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f70 <_ZL18Deadline_Unchanged>:
    9f70:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009f74 <_ZL14Invalid_Handle>:
    9f74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f78 <_ZL8INFINITY>:
    9f78:	7f7fffff 	svcvc	0x007fffff

00009f7c <_ZL16Pipe_File_Prefix>:
    9f7c:	3a535953 	bcc	14e04d0 <__bss_end+0x14d6264>
    9f80:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9f84:	0000002f 	andeq	r0, r0, pc, lsr #32

00009f88 <_ZL8INFINITY>:
    9f88:	7f7fffff 	svcvc	0x007fffff

00009f8c <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9f8c:	33323130 	teqcc	r2, #48, 2
    9f90:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9f94:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9f98:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9f9c:	00000000 	andeq	r0, r0, r0

00009fa0 <_ZL13Lock_Unlocked>:
    9fa0:	00000000 	andeq	r0, r0, r0

00009fa4 <_ZL11Lock_Locked>:
    9fa4:	00000001 	andeq	r0, r0, r1

00009fa8 <_ZL21MaxFSDriverNameLength>:
    9fa8:	00000010 	andeq	r0, r0, r0, lsl r0

00009fac <_ZL17MaxFilenameLength>:
    9fac:	00000010 	andeq	r0, r0, r0, lsl r0

00009fb0 <_ZL13MaxPathLength>:
    9fb0:	00000080 	andeq	r0, r0, r0, lsl #1

00009fb4 <_ZL18NoFilesystemDriver>:
    9fb4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fb8 <_ZL9NotifyAll>:
    9fb8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fbc <_ZL24Max_Process_Opened_Files>:
    9fbc:	00000010 	andeq	r0, r0, r0, lsl r0

00009fc0 <_ZL10Indefinite>:
    9fc0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fc4 <_ZL18Deadline_Unchanged>:
    9fc4:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009fc8 <_ZL14Invalid_Handle>:
    9fc8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fcc <_ZL8INFINITY>:
    9fcc:	7f7fffff 	svcvc	0x007fffff

00009fd0 <_ZN3halL18Default_Clock_RateE>:
    9fd0:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009fd4 <_ZN3halL15Peripheral_BaseE>:
    9fd4:	20000000 	andcs	r0, r0, r0

00009fd8 <_ZN3halL9GPIO_BaseE>:
    9fd8:	20200000 	eorcs	r0, r0, r0

00009fdc <_ZN3halL14GPIO_Pin_CountE>:
    9fdc:	00000036 	andeq	r0, r0, r6, lsr r0

00009fe0 <_ZN3halL8AUX_BaseE>:
    9fe0:	20215000 	eorcs	r5, r1, r0

00009fe4 <_ZN3halL25Interrupt_Controller_BaseE>:
    9fe4:	2000b200 	andcs	fp, r0, r0, lsl #4

00009fe8 <_ZN3halL10Timer_BaseE>:
    9fe8:	2000b400 	andcs	fp, r0, r0, lsl #8

00009fec <_ZN3halL9TRNG_BaseE>:
    9fec:	20104000 	andscs	r4, r0, r0

00009ff0 <_ZN3halL9BSC0_BaseE>:
    9ff0:	20205000 	eorcs	r5, r0, r0

00009ff4 <_ZN3halL9BSC1_BaseE>:
    9ff4:	20804000 	addcs	r4, r0, r0

00009ff8 <_ZN3halL9BSC2_BaseE>:
    9ff8:	20805000 	addcs	r5, r0, r0

00009ffc <_ZN9OLED_FontL10Char_WidthE>:
    9ffc:	 	andeq	r0, r8, r6

00009ffe <_ZN9OLED_FontL11Char_HeightE>:
    9ffe:	 	eoreq	r0, r0, r8

0000a000 <_ZN9OLED_FontL10Char_BeginE>:
    a000:	 	addeq	r0, r0, r0, lsr #32

0000a002 <_ZN9OLED_FontL8Char_EndE>:
    a002:	 	andeq	r0, r1, r0, lsl #1

0000a004 <_ZN9OLED_FontL10Flip_CharsE>:
    a004:	00000001 	andeq	r0, r0, r1

0000a008 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    a010:	00002f00 	andeq	r2, r0, r0, lsl #30
    a014:	00070000 	andeq	r0, r7, r0
    a018:	14000007 	strne	r0, [r0], #-7
    a01c:	147f147f 	ldrbtne	r1, [pc], #-1151	; a024 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    a020:	7f2a2400 	svcvc	0x002a2400
    a024:	2300122a 	movwcs	r1, #554	; 0x22a
    a028:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    a02c:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    a030:	00005022 	andeq	r5, r0, r2, lsr #32
    a034:	00000305 	andeq	r0, r0, r5, lsl #6
    a038:	221c0000 	andscs	r0, ip, #0
    a03c:	00000041 	andeq	r0, r0, r1, asr #32
    a040:	001c2241 	andseq	r2, ip, r1, asr #4
    a044:	3e081400 	cfcpyscc	mvf1, mvf8
    a048:	08001408 	stmdaeq	r0, {r3, sl, ip}
    a04c:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    a050:	a0000000 	andge	r0, r0, r0
    a054:	08000060 	stmdaeq	r0, {r5, r6}
    a058:	08080808 	stmdaeq	r8, {r3, fp}
    a05c:	60600000 	rsbvs	r0, r0, r0
    a060:	20000000 	andcs	r0, r0, r0
    a064:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    a068:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    a06c:	00003e45 	andeq	r3, r0, r5, asr #28
    a070:	00407f42 	subeq	r7, r0, r2, asr #30
    a074:	51614200 	cmnpl	r1, r0, lsl #4
    a078:	21004649 	tstcs	r0, r9, asr #12
    a07c:	314b4541 	cmpcc	fp, r1, asr #10
    a080:	12141800 	andsne	r1, r4, #0, 16
    a084:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    a088:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    a08c:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    a090:	01003049 	tsteq	r0, r9, asr #32
    a094:	03050971 	movweq	r0, #22897	; 0x5971
    a098:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    a09c:	06003649 	streq	r3, [r0], -r9, asr #12
    a0a0:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    a0a4:	36360000 	ldrtcc	r0, [r6], -r0
    a0a8:	00000000 	andeq	r0, r0, r0
    a0ac:	00003656 	andeq	r3, r0, r6, asr r6
    a0b0:	22140800 	andscs	r0, r4, #0, 16
    a0b4:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    a0b8:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    a0bc:	22410000 	subcs	r0, r1, #0
    a0c0:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    a0c4:	06095101 	streq	r5, [r9], -r1, lsl #2
    a0c8:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    a0cc:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    a0d0:	7c121112 	ldfvcs	f1, [r2], {18}
    a0d4:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    a0d8:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    a0dc:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    a0e0:	41417f00 	cmpmi	r1, r0, lsl #30
    a0e4:	7f001c22 	svcvc	0x00001c22
    a0e8:	41494949 	cmpmi	r9, r9, asr #18
    a0ec:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a0f0:	3e000109 	adfccs	f0, f0, #1.0
    a0f4:	7a494941 	bvc	125c600 <__bss_end+0x1252394>
    a0f8:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    a0fc:	00007f08 	andeq	r7, r0, r8, lsl #30
    a100:	00417f41 	subeq	r7, r1, r1, asr #30
    a104:	41402000 	mrsmi	r2, (UNDEF: 64)
    a108:	7f00013f 	svcvc	0x0000013f
    a10c:	41221408 			; <UNDEFINED> instruction: 0x41221408
    a110:	40407f00 	submi	r7, r0, r0, lsl #30
    a114:	7f004040 	svcvc	0x00004040
    a118:	7f020c02 	svcvc	0x00020c02
    a11c:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    a120:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    a124:	3e414141 	dvfccsm	f4, f1, f1
    a128:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a12c:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    a130:	5e215141 	sufplsm	f5, f1, f1
    a134:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    a138:	46004629 	strmi	r4, [r0], -r9, lsr #12
    a13c:	31494949 	cmpcc	r9, r9, asr #18
    a140:	7f010100 	svcvc	0x00010100
    a144:	3f000101 	svccc	0x00000101
    a148:	3f404040 	svccc	0x00404040
    a14c:	40201f00 	eormi	r1, r0, r0, lsl #30
    a150:	3f001f20 	svccc	0x00001f20
    a154:	3f403840 	svccc	0x00403840
    a158:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    a15c:	07006314 	smladeq	r0, r4, r3, r6
    a160:	07087008 	streq	r7, [r8, -r8]
    a164:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    a168:	00004345 	andeq	r4, r0, r5, asr #6
    a16c:	0041417f 	subeq	r4, r1, pc, ror r1
    a170:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    a174:	0000552a 	andeq	r5, r0, sl, lsr #10
    a178:	007f4141 	rsbseq	r4, pc, r1, asr #2
    a17c:	01020400 	tsteq	r2, r0, lsl #8
    a180:	40000402 	andmi	r0, r0, r2, lsl #8
    a184:	40404040 	submi	r4, r0, r0, asr #32
    a188:	02010000 	andeq	r0, r1, #0
    a18c:	20000004 	andcs	r0, r0, r4
    a190:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    a194:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    a198:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    a19c:	20444444 	subcs	r4, r4, r4, asr #8
    a1a0:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    a1a4:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    a1a8:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    a1ac:	097e0800 	ldmdbeq	lr!, {fp}^
    a1b0:	18000201 	stmdane	r0, {r0, r9}
    a1b4:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    a1b8:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    a1bc:	00007804 	andeq	r7, r0, r4, lsl #16
    a1c0:	00407d44 	subeq	r7, r0, r4, asr #26
    a1c4:	84804000 	strhi	r4, [r0], #0
    a1c8:	7f00007d 	svcvc	0x0000007d
    a1cc:	00442810 	subeq	r2, r4, r0, lsl r8
    a1d0:	7f410000 	svcvc	0x00410000
    a1d4:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    a1d8:	78041804 	stmdavc	r4, {r2, fp, ip}
    a1dc:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a1e0:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    a1e4:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    a1e8:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    a1ec:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    a1f0:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    a1f4:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a1f8:	48000804 	stmdami	r0, {r2, fp}
    a1fc:	20545454 	subscs	r5, r4, r4, asr r4
    a200:	443f0400 	ldrtmi	r0, [pc], #-1024	; a208 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    a204:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    a208:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    a20c:	40201c00 	eormi	r1, r0, r0, lsl #24
    a210:	3c001c20 	stccc	12, cr1, [r0], {32}
    a214:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    a218:	10284400 	eorne	r4, r8, r0, lsl #8
    a21c:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    a220:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    a224:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    a228:	0000444c 	andeq	r4, r0, ip, asr #8
    a22c:	00007708 	andeq	r7, r0, r8, lsl #14
    a230:	7f000000 	svcvc	0x00000000
    a234:	00000000 	andeq	r0, r0, r0
    a238:	00000877 	andeq	r0, r0, r7, ror r8
    a23c:	10081000 	andne	r1, r8, r0
    a240:	00000008 	andeq	r0, r0, r8
    a244:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

0000a248 <messages>:
__DTOR_END__():
    a248:	00009e94 	muleq	r0, r4, lr
    a24c:	00009eb0 			; <UNDEFINED> instruction: 0x00009eb0
    a250:	00009ec4 	andeq	r9, r0, r4, asr #29
    a254:	00009edc 	ldrdeq	r9, [r0], -ip
    a258:	00009f00 	andeq	r9, r0, r0, lsl #30

Disassembly of section .bss:

0000a25c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16835c0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x381b8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3bdcc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c6ab8>
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
      80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcf3d0>
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
      fc:	fb010200 	blx	40906 <__bss_end+0x3669a>
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
     12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff5b63>
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
     164:	0a05830b 	beq	160d98 <__bss_end+0x156b2c>
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
     190:	4a030402 	bmi	c11a0 <__bss_end+0xb6f34>
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
     1c4:	4a020402 	bmi	811d4 <__bss_end+0x76f68>
     1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1d0:	01058509 	tsteq	r5, r9, lsl #10
     1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
     1d8:	02d10101 	sbcseq	r0, r1, #1073741824	; 0x40000000
     1dc:	00030000 	andeq	r0, r3, r0
     1e0:	0000026f 	andeq	r0, r0, pc, ror #4
     1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     1e8:	0101000d 	tsteq	r1, sp
     1ec:	00000101 	andeq	r0, r0, r1, lsl #2
     1f0:	00000100 	andeq	r0, r0, r0, lsl #2
     1f4:	6f682f01 	svcvs	0x00682f01
     1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcf548>
     1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
     200:	2f697261 	svccs	0x00697261
     204:	2f746967 	svccs	0x00746967
     208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     20c:	6f732f70 	svcvs	0x00732f70
     210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     214:	73752f73 	cmnvc	r5, #460	; 0x1cc
     218:	70737265 	rsbsvc	r7, r3, r5, ror #4
     21c:	2f656361 	svccs	0x00656361
     220:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
     224:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     228:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
     22c:	2f656d6f 	svccs	0x00656d6f
     230:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     234:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     238:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     23c:	2f736f2f 	svccs	0x00736f2f
     240:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     244:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff5c7f>
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
     294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff5ccb>
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
     310:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff5d7d>
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
     364:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     368:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
     36c:	692f736c 	stmdbvs	pc!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
     370:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     374:	2f006564 	svccs	0x00006564
     378:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     37c:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     380:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     384:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     388:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     38c:	2f70732f 	svccs	0x0070732f
     390:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     394:	2f736563 	svccs	0x00736563
     398:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     39c:	63617073 	cmnvs	r1, #115	; 0x73
     3a0:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     3a4:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     3a8:	2f6c656e 	svccs	0x006c656e
     3ac:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     3b0:	2f656475 	svccs	0x00656475
     3b4:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     3b8:	00737265 	rsbseq	r7, r3, r5, ror #4
     3bc:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     3c0:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     3c4:	00010070 	andeq	r0, r1, r0, ror r0
     3c8:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     3cc:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     3d0:	00020068 	andeq	r0, r2, r8, rrx
     3d4:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     3d8:	0300682e 	movweq	r6, #2094	; 0x82e
     3dc:	70730000 	rsbsvc	r0, r3, r0
     3e0:	6f6c6e69 	svcvs	0x006c6e69
     3e4:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     3e8:	00000300 	andeq	r0, r0, r0, lsl #6
     3ec:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     3f0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     3f4:	00682e67 	rsbeq	r2, r8, r7, ror #28
     3f8:	66000004 	strvs	r0, [r0], -r4
     3fc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     400:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     404:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     408:	70000005 	andvc	r0, r0, r5
     40c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     410:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     414:	00000300 	andeq	r0, r0, r0, lsl #6
     418:	636f7270 	cmnvs	pc, #112, 4
     41c:	5f737365 	svcpl	0x00737365
     420:	616e616d 	cmnvs	lr, sp, ror #2
     424:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     428:	00030068 	andeq	r0, r3, r8, rrx
     42c:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
     430:	00682e64 	rsbeq	r2, r8, r4, ror #28
     434:	70000006 	andvc	r0, r0, r6
     438:	70697265 	rsbvc	r7, r9, r5, ror #4
     43c:	61726568 	cmnvs	r2, r8, ror #10
     440:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
     444:	00000200 	andeq	r0, r0, r0, lsl #4
     448:	6f697067 	svcvs	0x00697067
     44c:	0700682e 	streq	r6, [r0, -lr, lsr #16]
     450:	05000000 	streq	r0, [r0, #-0]
     454:	02050001 	andeq	r0, r5, #1
     458:	0000822c 	andeq	r8, r0, ip, lsr #4
     45c:	05011a03 	streq	r1, [r1, #-2563]	; 0xfffff5fd
     460:	0c059f1f 	stceq	15, cr9, [r5], {31}
     464:	83110583 	tsthi	r1, #549453824	; 0x20c00000
     468:	059f0b05 	ldreq	r0, [pc, #2821]	; f75 <shift+0xf75>
     46c:	0b05681b 	bleq	15a4e0 <__bss_end+0x150274>
     470:	4c070583 	cfstr32mi	mvfx0, [r7], {131}	; 0x83
     474:	01040200 	mrseq	r0, R12_usr
     478:	0022056b 	eoreq	r0, r2, fp, ror #10
     47c:	9f010402 	svcls	0x00010402
     480:	02000f05 	andeq	r0, r0, #5, 30
     484:	05f20104 	ldrbeq	r0, [r2, #260]!	; 0x104
     488:	0402000d 	streq	r0, [r2], #-13
     48c:	12056801 	andne	r6, r5, #65536	; 0x10000
     490:	01040200 	mrseq	r0, R12_usr
     494:	000c0583 	andeq	r0, ip, r3, lsl #11
     498:	9f010402 	svcls	0x00010402
     49c:	02000805 	andeq	r0, r0, #327680	; 0x50000
     4a0:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
     4a4:	04020002 	streq	r0, [r2], #-2
     4a8:	0c026701 	stceq	7, cr6, [r2], {1}
     4ac:	bf010100 	svclt	0x00010100
     4b0:	03000002 	movweq	r0, #2
     4b4:	00018c00 	andeq	r8, r1, r0, lsl #24
     4b8:	fb010200 	blx	40cc2 <__bss_end+0x36a56>
     4bc:	01000d0e 	tsteq	r0, lr, lsl #26
     4c0:	00010101 	andeq	r0, r1, r1, lsl #2
     4c4:	00010000 	andeq	r0, r1, r0
     4c8:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     4cc:	2f656d6f 	svccs	0x00656d6f
     4d0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     4d4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     4d8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     4dc:	2f736f2f 	svccs	0x00736f2f
     4e0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     4e4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     4e8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     4ec:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     4f0:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
     4f4:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     4f8:	2f656d6f 	svccs	0x00656d6f
     4fc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     500:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     504:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     508:	2f736f2f 	svccs	0x00736f2f
     50c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     510:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     514:	6b2f7365 	blvs	bdd2b0 <__bss_end+0xbd3044>
     518:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     51c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     520:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     524:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     528:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     52c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     530:	2f656d6f 	svccs	0x00656d6f
     534:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     538:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     53c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     540:	2f736f2f 	svccs	0x00736f2f
     544:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     548:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     54c:	6b2f7365 	blvs	bdd2e8 <__bss_end+0xbd307c>
     550:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     554:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     558:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     55c:	73662f65 	cmnvc	r6, #404	; 0x194
     560:	6f682f00 	svcvs	0x00682f00
     564:	6a2f656d 	bvs	bd9b20 <__bss_end+0xbcf8b4>
     568:	73656d61 	cmnvc	r5, #6208	; 0x1840
     56c:	2f697261 	svccs	0x00697261
     570:	2f746967 	svccs	0x00746967
     574:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     578:	6f732f70 	svcvs	0x00732f70
     57c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     580:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     584:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     588:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     58c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     590:	6f682f00 	svcvs	0x00682f00
     594:	6a2f656d 	bvs	bd9b50 <__bss_end+0xbcf8e4>
     598:	73656d61 	cmnvc	r5, #6208	; 0x1840
     59c:	2f697261 	svccs	0x00697261
     5a0:	2f746967 	svccs	0x00746967
     5a4:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     5a8:	6f732f70 	svcvs	0x00732f70
     5ac:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     5b0:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     5b4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     5b8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     5bc:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     5c0:	616f622f 	cmnvs	pc, pc, lsr #4
     5c4:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     5c8:	2f306970 	svccs	0x00306970
     5cc:	006c6168 	rsbeq	r6, ip, r8, ror #2
     5d0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     5d4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     5d8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     5dc:	00000100 	andeq	r0, r0, r0, lsl #2
     5e0:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     5e4:	00020068 	andeq	r0, r2, r8, rrx
     5e8:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     5ec:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     5f0:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     5f4:	66000002 	strvs	r0, [r0], -r2
     5f8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     5fc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     600:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     604:	70000003 	andvc	r0, r0, r3
     608:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     60c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     610:	00000200 	andeq	r0, r0, r0, lsl #4
     614:	636f7270 	cmnvs	pc, #112, 4
     618:	5f737365 	svcpl	0x00737365
     61c:	616e616d 	cmnvs	lr, sp, ror #2
     620:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     624:	00020068 	andeq	r0, r2, r8, rrx
     628:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     62c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     630:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     634:	00000400 	andeq	r0, r0, r0, lsl #8
     638:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     63c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     640:	00000500 	andeq	r0, r0, r0, lsl #10
     644:	00010500 	andeq	r0, r1, r0, lsl #10
     648:	83380205 	teqhi	r8, #1342177280	; 0x50000000
     64c:	05160000 	ldreq	r0, [r6, #-0]
     650:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
     654:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     658:	852f0105 	strhi	r0, [pc, #-261]!	; 55b <shift+0x55b>
     65c:	05833205 	streq	r3, [r3, #517]	; 0x205
     660:	01054b1a 	tsteq	r5, sl, lsl fp
     664:	1a05852f 	bne	161b28 <__bss_end+0x1578bc>
     668:	2f01054b 	svccs	0x0001054b
     66c:	a1320585 	teqge	r2, r5, lsl #11
     670:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     674:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
     678:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     67c:	852f0105 	strhi	r0, [pc, #-261]!	; 57f <shift+0x57f>
     680:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     684:	2e054b30 	vmovcs.16	d5[0], r4
     688:	4b1b054b 	blmi	6c1bbc <__bss_end+0x6b7950>
     68c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff88f <__bss_end+0xffff5623>
     690:	01054c0c 	tsteq	r5, ip, lsl #24
     694:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     698:	4b3005bd 	blmi	c01d94 <__bss_end+0xbf7b28>
     69c:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     6a0:	2e054b1b 	vmovcs.32	d5[0], r4
     6a4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6a8:	852f0105 	strhi	r0, [pc, #-261]!	; 5ab <shift+0x5ab>
     6ac:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
     6b0:	01054b1b 	tsteq	r5, fp, lsl fp
     6b4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     6b8:	4b3305bd 	blmi	cc1db4 <__bss_end+0xcb7b48>
     6bc:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     6c0:	30054b1b 	andcc	r4, r5, fp, lsl fp
     6c4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6c8:	852f0105 	strhi	r0, [pc, #-261]!	; 5cb <shift+0x5cb>
     6cc:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
     6d0:	1b054b2f 	blne	153394 <__bss_end+0x149128>
     6d4:	2f2f054b 	svccs	0x002f054b
     6d8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     6dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     6e0:	2f05bd2e 	svccs	0x0005bd2e
     6e4:	4b3b054b 	blmi	ec1c18 <__bss_end+0xeb79ac>
     6e8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     6ec:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     6f0:	2f01054c 	svccs	0x0001054c
     6f4:	a12f0585 	smlawbge	pc, r5, r5, r0	; <UNPREDICTABLE>
     6f8:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
     6fc:	30054b1a 	andcc	r4, r5, sl, lsl fp
     700:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     704:	859f0105 	ldrhi	r0, [pc, #261]	; 811 <shift+0x811>
     708:	05672005 	strbeq	r2, [r7, #-5]!
     70c:	31054d2d 	tstcc	r5, sp, lsr #26
     710:	4b1a054b 	blmi	681c44 <__bss_end+0x6779d8>
     714:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     718:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     71c:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
     720:	4b31054d 	blmi	c41c5c <__bss_end+0xc379f0>
     724:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     728:	0105300c 	tsteq	r5, ip
     72c:	2005852f 	andcs	r8, r5, pc, lsr #10
     730:	4c2d0583 	cfstr32mi	mvfx0, [sp], #-524	; 0xfffffdf4
     734:	054b3e05 	strbeq	r3, [fp, #-3589]	; 0xfffff1fb
     738:	01054b1a 	tsteq	r5, sl, lsl fp
     73c:	2005852f 	andcs	r8, r5, pc, lsr #10
     740:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
     744:	054b3005 	strbeq	r3, [fp, #-5]
     748:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
     74c:	2f010530 	svccs	0x00010530
     750:	a00c0587 	andge	r0, ip, r7, lsl #11
     754:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
     758:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
     75c:	0f052e36 	svceq	0x00052e36
     760:	66130530 			; <UNDEFINED> instruction: 0x66130530
     764:	05840905 	streq	r0, [r4, #2309]	; 0x905
     768:	0105d810 	tsteq	r5, r0, lsl r8
     76c:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
     770:	063e0101 	ldrteq	r0, [lr], -r1, lsl #2
     774:	00030000 	andeq	r0, r3, r0
     778:	0000008f 	andeq	r0, r0, pc, lsl #1
     77c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     780:	0101000d 	tsteq	r1, sp
     784:	00000101 	andeq	r0, r0, r1, lsl #2
     788:	00000100 	andeq	r0, r0, r0, lsl #2
     78c:	6f682f01 	svcvs	0x00682f01
     790:	6a2f656d 	bvs	bd9d4c <__bss_end+0xbcfae0>
     794:	73656d61 	cmnvc	r5, #6208	; 0x1840
     798:	2f697261 	svccs	0x00697261
     79c:	2f746967 	svccs	0x00746967
     7a0:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     7a4:	6f732f70 	svcvs	0x00732f70
     7a8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     7ac:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     7b0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     7b4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     7b8:	6f682f00 	svcvs	0x00682f00
     7bc:	6a2f656d 	bvs	bd9d78 <__bss_end+0xbcfb0c>
     7c0:	73656d61 	cmnvc	r5, #6208	; 0x1840
     7c4:	2f697261 	svccs	0x00697261
     7c8:	2f746967 	svccs	0x00746967
     7cc:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     7d0:	6f732f70 	svcvs	0x00732f70
     7d4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     7d8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     7dc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     7e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     7e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     7e8:	74730000 	ldrbtvc	r0, [r3], #-0
     7ec:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
     7f0:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
     7f4:	00707063 	rsbseq	r7, r0, r3, rrx
     7f8:	73000001 	movwvc	r0, #1
     7fc:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
     800:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     804:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     808:	05000000 	streq	r0, [r0, #-0]
     80c:	02050001 	andeq	r0, r5, #1
     810:	00008794 	muleq	r0, r4, r7
     814:	bb06051a 	bllt	181c84 <__bss_end+0x177a18>
     818:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     81c:	0a056821 	beq	15a8a8 <__bss_end+0x15063c>
     820:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
     824:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
     828:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
     82c:	9f04052f 	svcls	0x0004052f
     830:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
     834:	10053505 	andne	r3, r5, r5, lsl #10
     838:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
     83c:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
     840:	0a052e13 	beq	14c094 <__bss_end+0x141e28>
     844:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
     848:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
     84c:	03054a0c 	movweq	r4, #23052	; 0x5a0c
     850:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
     854:	02001805 	andeq	r1, r0, #327680	; 0x50000
     858:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     85c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     860:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
     864:	02040200 	andeq	r0, r4, #0, 4
     868:	00180568 	andseq	r0, r8, r8, ror #10
     86c:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     870:	02000805 	andeq	r0, r0, #327680	; 0x50000
     874:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     878:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     87c:	1b054b02 	blne	15348c <__bss_end+0x149220>
     880:	02040200 	andeq	r0, r4, #0, 4
     884:	000c052e 	andeq	r0, ip, lr, lsr #10
     888:	4a020402 	bmi	81898 <__bss_end+0x7762c>
     88c:	02000f05 	andeq	r0, r0, #5, 30
     890:	05820204 	streq	r0, [r2, #516]	; 0x204
     894:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     898:	11054a02 	tstne	r5, r2, lsl #20
     89c:	02040200 	andeq	r0, r4, #0, 4
     8a0:	000a052e 	andeq	r0, sl, lr, lsr #10
     8a4:	2f020402 	svccs	0x00020402
     8a8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     8ac:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     8b0:	0402000d 	streq	r0, [r2], #-13
     8b4:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     8b8:	02040200 	andeq	r0, r4, #0, 4
     8bc:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
     8c0:	83060585 	movwhi	r0, #25989	; 0x6585
     8c4:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     8c8:	0a054a10 	beq	153110 <__bss_end+0x148ea4>
     8cc:	bb07054c 	bllt	1c1e04 <__bss_end+0x1b7b98>
     8d0:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
     8d4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     8d8:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     8dc:	01040200 	mrseq	r0, R12_usr
     8e0:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
     8e4:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
     8e8:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
     8ec:	03020568 	movweq	r0, #9576	; 0x2568
     8f0:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
     8f4:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
     8f8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     8fc:	1605bd09 	strne	fp, [r5], -r9, lsl #26
     900:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     904:	001d054a 	andseq	r0, sp, sl, asr #10
     908:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     90c:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     910:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     914:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     918:	11056602 	tstne	r5, r2, lsl #12
     91c:	03040200 	movweq	r0, #16896	; 0x4200
     920:	0012054b 	andseq	r0, r2, fp, asr #10
     924:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     928:	02000805 	andeq	r0, r0, #327680	; 0x50000
     92c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     930:	04020009 	streq	r0, [r2], #-9
     934:	12052e03 	andne	r2, r5, #3, 28	; 0x30
     938:	03040200 	movweq	r0, #16896	; 0x4200
     93c:	000b054a 	andeq	r0, fp, sl, asr #10
     940:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     944:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     948:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
     94c:	0402000b 	streq	r0, [r2], #-11
     950:	08058402 	stmdaeq	r5, {r1, sl, pc}
     954:	01040200 	mrseq	r0, R12_usr
     958:	00090583 	andeq	r0, r9, r3, lsl #11
     95c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     960:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     964:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     968:	04020002 	streq	r0, [r2], #-2
     96c:	0b054901 	bleq	152d78 <__bss_end+0x148b0c>
     970:	2f010585 	svccs	0x00010585
     974:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
     978:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
     97c:	0b05bc20 	bleq	16fa04 <__bss_end+0x165798>
     980:	4b1f0566 	blmi	7c1f20 <__bss_end+0x7b7cb4>
     984:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
     988:	11054b08 	tstne	r5, r8, lsl #22
     98c:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
     990:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
     994:	0b056711 	bleq	15a5e0 <__bss_end+0x150374>
     998:	2f01054d 	svccs	0x0001054d
     99c:	83060585 	movwhi	r0, #25989	; 0x6585
     9a0:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     9a4:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
     9a8:	4b040566 	blmi	101f48 <__bss_end+0xf7cdc>
     9ac:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
     9b0:	01053109 	tsteq	r5, r9, lsl #2
     9b4:	0805852f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
     9b8:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
     9bc:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     9c0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     9c4:	04020007 	streq	r0, [r2], #-7
     9c8:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
     9cc:	02040200 	andeq	r0, r4, #0, 4
     9d0:	000a052e 	andeq	r0, sl, lr, lsr #10
     9d4:	4a020402 	bmi	819e4 <__bss_end+0x77778>
     9d8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     9dc:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
     9e0:	05858401 	streq	r8, [r5, #1025]	; 0x401
     9e4:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
     9e8:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
     9ec:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     9f0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     9f4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     9f8:	17058302 	strne	r8, [r5, -r2, lsl #6]
     9fc:	02040200 	andeq	r0, r4, #0, 4
     a00:	000a052e 	andeq	r0, sl, lr, lsr #10
     a04:	4a020402 	bmi	81a14 <__bss_end+0x777a8>
     a08:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     a0c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a10:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     a14:	0d054a02 	vstreq	s8, [r5, #-8]
     a18:	02040200 	andeq	r0, r4, #0, 4
     a1c:	0002052e 	andeq	r0, r2, lr, lsr #10
     a20:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     a24:	85840105 	strhi	r0, [r4, #261]	; 0x105
     a28:	059f0b05 	ldreq	r0, [pc, #2821]	; 1535 <shift+0x1535>
     a2c:	1c054b16 			; <UNDEFINED> instruction: 0x1c054b16
     a30:	03040200 	movweq	r0, #16896	; 0x4200
     a34:	000b054a 	andeq	r0, fp, sl, asr #10
     a38:	83020402 	movwhi	r0, #9218	; 0x2402
     a3c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     a40:	05810204 	streq	r0, [r1, #516]	; 0x204
     a44:	0105850c 	tsteq	r5, ip, lsl #10
     a48:	1105854b 	tstne	r5, fp, asr #10
     a4c:	680c0584 	stmdavs	ip, {r2, r7, r8, sl}
     a50:	02001805 	andeq	r1, r0, #327680	; 0x50000
     a54:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a58:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     a5c:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
     a60:	02040200 	andeq	r0, r4, #0, 4
     a64:	00160568 	andseq	r0, r6, r8, ror #10
     a68:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     a6c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
     a70:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     a74:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
     a78:	23052f02 	movwcs	r2, #24322	; 0x5f02
     a7c:	02040200 	andeq	r0, r4, #0, 4
     a80:	000e0566 	andeq	r0, lr, r6, ror #10
     a84:	66020402 	strvs	r0, [r2], -r2, lsl #8
     a88:	02000f05 	andeq	r0, r0, #5, 30
     a8c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a90:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     a94:	11054a02 	tstne	r5, r2, lsl #20
     a98:	02040200 	andeq	r0, r4, #0, 4
     a9c:	0012052e 	andseq	r0, r2, lr, lsr #10
     aa0:	2f020402 	svccs	0x00020402
     aa4:	02001905 	andeq	r1, r0, #81920	; 0x14000
     aa8:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     aac:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     ab0:	05056602 	streq	r6, [r5, #-1538]	; 0xfffff9fe
     ab4:	02040200 	andeq	r0, r4, #0, 4
     ab8:	88010562 	stmdahi	r1, {r1, r5, r6, r8, sl}
     abc:	d7050569 	strle	r0, [r5, -r9, ror #10]
     ac0:	059f0905 	ldreq	r0, [pc, #2309]	; 13cd <shift+0x13cd>
     ac4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     ac8:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     acc:	01040200 	mrseq	r0, R12_usr
     ad0:	9f090582 	svcls	0x00090582
     ad4:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     ad8:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     adc:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     ae0:	09058201 	stmdbeq	r5, {r0, r9, pc}
     ae4:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     ae8:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     aec:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     af0:	05820104 	streq	r0, [r2, #260]	; 0x104
     af4:	1a059f09 	bne	168720 <__bss_end+0x15e4b4>
     af8:	01040200 	mrseq	r0, R12_usr
     afc:	002e059e 	mlaeq	lr, lr, r5, r0
     b00:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     b04:	059f0905 	ldreq	r0, [pc, #2309]	; 1411 <shift+0x1411>
     b08:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     b0c:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     b10:	01040200 	mrseq	r0, R12_usr
     b14:	9f090582 	svcls	0x00090582
     b18:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     b1c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     b20:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     b24:	05058201 	streq	r8, [r5, #-513]	; 0xfffffdff
     b28:	000f05a0 	andeq	r0, pc, r0, lsr #11
     b2c:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     b30:	059f0905 	ldreq	r0, [pc, #2309]	; 143d <shift+0x143d>
     b34:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     b38:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     b3c:	01040200 	mrseq	r0, R12_usr
     b40:	9f090582 	svcls	0x00090582
     b44:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     b48:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     b4c:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     b50:	09058201 	stmdbeq	r5, {r0, r9, pc}
     b54:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     b58:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     b5c:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     b60:	05820104 	streq	r0, [r2, #260]	; 0x104
     b64:	1a059f09 	bne	168790 <__bss_end+0x15e524>
     b68:	01040200 	mrseq	r0, R12_usr
     b6c:	002e059e 	mlaeq	lr, lr, r5, r0
     b70:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     b74:	059f0905 	ldreq	r0, [pc, #2309]	; 1481 <shift+0x1481>
     b78:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     b7c:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     b80:	01040200 	mrseq	r0, R12_usr
     b84:	9f090582 	svcls	0x00090582
     b88:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     b8c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     b90:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     b94:	10058201 	andne	r8, r5, r1, lsl #4
     b98:	660e05a0 	strvs	r0, [lr], -r0, lsr #11
     b9c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     ba0:	0b054a19 	bleq	15340c <__bss_end+0x1491a0>
     ba4:	670f0582 	strvs	r0, [pc, -r2, lsl #11]
     ba8:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
     bac:	12054b19 	andne	r4, r5, #25600	; 0x6400
     bb0:	4a11054a 	bmi	4420e0 <__bss_end+0x437e74>
     bb4:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     bb8:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
     bbc:	76030905 	strvc	r0, [r3], -r5, lsl #18
     bc0:	4a10052e 	bmi	402080 <__bss_end+0x3f7e14>
     bc4:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     bc8:	15054a09 	strne	r4, [r5, #-2569]	; 0xfffff5f7
     bcc:	670d0567 	strvs	r0, [sp, -r7, ror #10]
     bd0:	054a1505 	strbeq	r1, [sl, #-1285]	; 0xfffffafb
     bd4:	0d056710 	stceq	7, cr6, [r5, #-64]	; 0xffffffc0
     bd8:	4b1a054a 	blmi	682108 <__bss_end+0x677e9c>
     bdc:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
     be0:	01054a19 	tsteq	r5, r9, lsl sl
     be4:	152e026a 	strne	r0, [lr, #-618]!	; 0xfffffd96
     be8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
     bec:	15054b12 	strne	r4, [r5, #-2834]	; 0xfffff4ee
     bf0:	bb200566 	bllt	802190 <__bss_end+0x7f7f24>
     bf4:	20082305 	andcs	r2, r8, r5, lsl #6
     bf8:	052e1205 	streq	r1, [lr, #-517]!	; 0xfffffdfb
     bfc:	23058214 	movwcs	r8, #21012	; 0x5214
     c00:	4a16054a 	bmi	582130 <__bss_end+0x577ec4>
     c04:	052f0b05 	streq	r0, [pc, #-2821]!	; 107 <shift+0x107>
     c08:	06059c05 	streq	r9, [r5], -r5, lsl #24
     c0c:	2e0b0532 	mcrcs	5, 0, r0, cr11, cr2, {1}
     c10:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     c14:	01054b08 	tsteq	r5, r8, lsl #22
     c18:	0e05854b 	cfsh32eq	mvfx8, mvfx5, #43
     c1c:	d7010583 	strle	r0, [r1, -r3, lsl #11]
     c20:	830d0585 	movwhi	r0, #54661	; 0xd585
     c24:	a2d70105 	sbcsge	r0, r7, #1073741825	; 0x40000001
     c28:	059f0605 	ldreq	r0, [pc, #1541]	; 1235 <shift+0x1235>
     c2c:	056a8301 	strbeq	r8, [sl, #-769]!	; 0xfffffcff
     c30:	0505bb0f 	streq	fp, [r5, #-2831]	; 0xfffff4f1
     c34:	840c054b 	strhi	r0, [ip], #-1355	; 0xfffffab5
     c38:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     c3c:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
     c40:	680d054b 	stmdavs	sp, {r0, r1, r3, r6, r8, sl}
     c44:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
     c48:	0e054c0c 	cdpeq	12, 0, cr4, cr5, cr12, {0}
     c4c:	4a100566 	bmi	4021ec <__bss_end+0x3f7f80>
     c50:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     c54:	1005660e 	andne	r6, r5, lr, lsl #12
     c58:	4b0c054a 	blmi	302188 <__bss_end+0x2f7f1c>
     c5c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     c60:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     c64:	660e054b 	strvs	r0, [lr], -fp, asr #10
     c68:	054a1005 	strbeq	r1, [sl, #-5]
     c6c:	0d054b03 	vstreq	d4, [r5, #-12]
     c70:	66050530 			; <UNDEFINED> instruction: 0x66050530
     c74:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     c78:	1005660e 	andne	r6, r5, lr, lsl #12
     c7c:	4b0c054a 	blmi	3021ac <__bss_end+0x2f7f40>
     c80:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     c84:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     c88:	660e054b 	strvs	r0, [lr], -fp, asr #10
     c8c:	054a1005 	strbeq	r1, [sl, #-5]
     c90:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     c94:	4a100566 	bmi	402234 <__bss_end+0x3f7fc8>
     c98:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
     c9c:	02053006 	andeq	r3, r5, #6
     ca0:	670d054b 	strvs	r0, [sp, -fp, asr #10]
     ca4:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
     ca8:	07059f0e 	streq	r9, [r5, -lr, lsl #30]
     cac:	68180566 	ldmdavs	r8, {r1, r2, r5, r6, r8, sl}
     cb0:	05833405 	streq	r3, [r3, #1029]	; 0x405
     cb4:	44056633 	strmi	r6, [r5], #-1587	; 0xfffff9cd
     cb8:	4a18054a 	bmi	6021e8 <__bss_end+0x5f7f7c>
     cbc:	05690605 	strbeq	r0, [r9, #-1541]!	; 0xfffff9fb
     cc0:	0b059f1d 	bleq	16893c <__bss_end+0x15e6d0>
     cc4:	00140584 	andseq	r0, r4, r4, lsl #11
     cc8:	4a030402 	bmi	c1cd8 <__bss_end+0xb7a6c>
     ccc:	02000c05 	andeq	r0, r0, #1280	; 0x500
     cd0:	05840204 	streq	r0, [r4, #516]	; 0x204
     cd4:	0402000e 	streq	r0, [r2], #-14
     cd8:	1e056602 	cfmadd32ne	mvax0, mvfx6, mvfx5, mvfx2
     cdc:	02040200 	andeq	r0, r4, #0, 4
     ce0:	0010054a 	andseq	r0, r0, sl, asr #10
     ce4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     ce8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     cec:	872c0204 	strhi	r0, [ip, -r4, lsl #4]!
     cf0:	05680c05 	strbeq	r0, [r8, #-3077]!	; 0xfffff3fb
     cf4:	1005660e 	andne	r6, r5, lr, lsl #12
     cf8:	4c1a054a 	cfldr32mi	mvfx0, [sl], {74}	; 0x4a
     cfc:	05a00c05 	streq	r0, [r0, #3077]!	; 0xc05
     d00:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     d04:	19054a01 	stmdbne	r5, {r0, r9, fp, lr}
     d08:	82040568 	andhi	r0, r4, #104, 10	; 0x1a000000
     d0c:	02000d05 	andeq	r0, r0, #320	; 0x140
     d10:	054c0204 	strbeq	r0, [ip, #-516]	; 0xfffffdfc
     d14:	0402000f 	streq	r0, [r2], #-15
     d18:	24056602 	strcs	r6, [r5], #-1538	; 0xfffff9fe
     d1c:	02040200 	andeq	r0, r4, #0, 4
     d20:	0011054a 	andseq	r0, r1, sl, asr #10
     d24:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     d28:	02000305 	andeq	r0, r0, #335544320	; 0x14000000
     d2c:	052a0204 	streq	r0, [sl, #-516]!	; 0xfffffdfc
     d30:	0b058505 	bleq	16214c <__bss_end+0x157ee0>
     d34:	02040200 	andeq	r0, r4, #0, 4
     d38:	000d0532 	andeq	r0, sp, r2, lsr r5
     d3c:	66020402 	strvs	r0, [r2], -r2, lsl #8
     d40:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     d44:	05830905 	streq	r0, [r3, #2309]	; 0x905
     d48:	07054a12 	smladeq	r5, r2, sl, r4
     d4c:	4a03054b 	bmi	c2280 <__bss_end+0xb8014>
     d50:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     d54:	0c05670a 	stceq	7, cr6, [r5], {10}
     d58:	001c054c 	andseq	r0, ip, ip, asr #10
     d5c:	4a010402 	bmi	41d6c <__bss_end+0x37b00>
     d60:	02001d05 	andeq	r1, r0, #320	; 0x140
     d64:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     d68:	05054b09 	streq	r4, [r5, #-2825]	; 0xfffff4f7
     d6c:	0012054a 	andseq	r0, r2, sl, asr #10
     d70:	4b010402 	blmi	41d80 <__bss_end+0x37b14>
     d74:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     d78:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     d7c:	0905300d 	stmdbeq	r5, {r0, r2, r3, ip, sp}
     d80:	4b05054a 	blmi	1422b0 <__bss_end+0x138044>
     d84:	02001005 	andeq	r1, r0, #5
     d88:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     d8c:	1c056707 	stcne	7, cr6, [r5], {7}
     d90:	01040200 	mrseq	r0, R12_usr
     d94:	83110566 	tsthi	r1, #427819008	; 0x19800000
     d98:	05661b05 	strbeq	r1, [r6, #-2821]!	; 0xfffff4fb
     d9c:	0305660b 	movweq	r6, #22027	; 0x560b
     da0:	02040200 	andeq	r0, r4, #0, 4
     da4:	054a7803 	strbeq	r7, [sl, #-2051]	; 0xfffff7fd
     da8:	820b0310 	andhi	r0, fp, #16, 6	; 0x40000000
     dac:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
     db0:	0101000c 	tsteq	r1, ip
     db4:	0000037f 	andeq	r0, r0, pc, ror r3
     db8:	023d0003 	eorseq	r0, sp, #3
     dbc:	01020000 	mrseq	r0, (UNDEF: 2)
     dc0:	000d0efb 	strdeq	r0, [sp], -fp
     dc4:	01010101 	tsteq	r1, r1, lsl #2
     dc8:	01000000 	mrseq	r0, (UNDEF: 0)
     dcc:	2f010000 	svccs	0x00010000
     dd0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     dd4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     dd8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     ddc:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     de0:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     de4:	2f70732f 	svccs	0x0070732f
     de8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     dec:	2f736563 	svccs	0x00736563
     df0:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
     df4:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     df8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     dfc:	6f682f00 	svcvs	0x00682f00
     e00:	6a2f656d 	bvs	bda3bc <__bss_end+0xbd0150>
     e04:	73656d61 	cmnvc	r5, #6208	; 0x1840
     e08:	2f697261 	svccs	0x00697261
     e0c:	2f746967 	svccs	0x00746967
     e10:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     e14:	6f732f70 	svcvs	0x00732f70
     e18:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     e1c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     e20:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     e24:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     e28:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     e2c:	616f622f 	cmnvs	pc, pc, lsr #4
     e30:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     e34:	2f306970 	svccs	0x00306970
     e38:	006c6168 	rsbeq	r6, ip, r8, ror #2
     e3c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d88 <shift+0xd88>
     e40:	616a2f65 	cmnvs	sl, r5, ror #30
     e44:	6173656d 	cmnvs	r3, sp, ror #10
     e48:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     e4c:	6f2f7469 	svcvs	0x002f7469
     e50:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     e54:	756f732f 	strbvc	r7, [pc, #-815]!	; b2d <shift+0xb2d>
     e58:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     e5c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     e60:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
     e64:	6e692f73 	mcrvs	15, 3, r2, cr9, cr3, {3}
     e68:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     e6c:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     e70:	2f656d6f 	svccs	0x00656d6f
     e74:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     e78:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     e7c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     e80:	2f736f2f 	svccs	0x00736f2f
     e84:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     e88:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e8c:	6b2f7365 	blvs	bddc28 <__bss_end+0xbd39bc>
     e90:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     e94:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     e98:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     e9c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     ea0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ea4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     ea8:	2f656d6f 	svccs	0x00656d6f
     eac:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     eb0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     eb4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     eb8:	2f736f2f 	svccs	0x00736f2f
     ebc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     ec0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     ec4:	6b2f7365 	blvs	bddc60 <__bss_end+0xbd39f4>
     ec8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     ecc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     ed0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     ed4:	73662f65 	cmnvc	r6, #404	; 0x194
     ed8:	6f682f00 	svcvs	0x00682f00
     edc:	6a2f656d 	bvs	bda498 <__bss_end+0xbd022c>
     ee0:	73656d61 	cmnvc	r5, #6208	; 0x1840
     ee4:	2f697261 	svccs	0x00697261
     ee8:	2f746967 	svccs	0x00746967
     eec:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     ef0:	6f732f70 	svcvs	0x00732f70
     ef4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ef8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     efc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     f00:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     f04:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     f08:	6f682f00 	svcvs	0x00682f00
     f0c:	6a2f656d 	bvs	bda4c8 <__bss_end+0xbd025c>
     f10:	73656d61 	cmnvc	r5, #6208	; 0x1840
     f14:	2f697261 	svccs	0x00697261
     f18:	2f746967 	svccs	0x00746967
     f1c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     f20:	6f732f70 	svcvs	0x00732f70
     f24:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     f28:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     f2c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     f30:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     f34:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     f38:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     f3c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     f40:	6972622f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     f44:	73656764 	cmnvc	r5, #100, 14	; 0x1900000
     f48:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; f50 <shift+0xf50>
     f4c:	632e6465 			; <UNDEFINED> instruction: 0x632e6465
     f50:	01007070 	tsteq	r0, r0, ror r0
     f54:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     f58:	66656474 			; <UNDEFINED> instruction: 0x66656474
     f5c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     f60:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; f68 <shift+0xf68>
     f64:	682e6465 	stmdavs	lr!, {r0, r2, r5, r6, sl, sp, lr}
     f68:	00000300 	andeq	r0, r0, r0, lsl #6
     f6c:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     f70:	00040068 	andeq	r0, r4, r8, rrx
     f74:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     f78:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     f7c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     f80:	66000004 	strvs	r0, [r0], -r4
     f84:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f88:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     f8c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     f90:	70000005 	andvc	r0, r0, r5
     f94:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f98:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     f9c:	00000400 	andeq	r0, r0, r0, lsl #8
     fa0:	636f7270 	cmnvs	pc, #112, 4
     fa4:	5f737365 	svcpl	0x00737365
     fa8:	616e616d 	cmnvs	lr, sp, ror #2
     fac:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     fb0:	00040068 	andeq	r0, r4, r8, rrx
     fb4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     fb8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     fbc:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     fc0:	00000600 	andeq	r0, r0, r0, lsl #12
     fc4:	70736964 	rsbsvc	r6, r3, r4, ror #18
     fc8:	5f79616c 	svcpl	0x0079616c
     fcc:	746f7270 	strbtvc	r7, [pc], #-624	; fd4 <shift+0xfd4>
     fd0:	6c6f636f 	stclvs	3, cr6, [pc], #-444	; e1c <shift+0xe1c>
     fd4:	0700682e 	streq	r6, [r0, -lr, lsr #16]
     fd8:	65700000 	ldrbvs	r0, [r0, #-0]!
     fdc:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     fe0:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     fe4:	00682e73 	rsbeq	r2, r8, r3, ror lr
     fe8:	6f000002 	svcvs	0x00000002
     fec:	5f64656c 	svcpl	0x0064656c
     ff0:	746e6f66 	strbtvc	r6, [lr], #-3942	; 0xfffff09a
     ff4:	0100682e 	tsteq	r0, lr, lsr #16
     ff8:	05000000 	streq	r0, [r0, #-0]
     ffc:	02050001 	andeq	r0, r5, #1
    1000:	00009770 	andeq	r9, r0, r0, ror r7
    1004:	05010903 	streq	r0, [r1, #-2307]	; 0xfffff6fd
    1008:	48059f14 	stmdami	r5, {r2, r4, r8, r9, sl, fp, ip, pc}
    100c:	a1100582 	tstge	r0, r2, lsl #11
    1010:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
    1014:	0105820d 	tsteq	r5, sp, lsl #4
    1018:	0905844b 	stmdbeq	r5, {r0, r1, r3, r6, sl, pc}
    101c:	4a050585 	bmi	142638 <__bss_end+0x1383cc>
    1020:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
    1024:	0105670e 	tsteq	r5, lr, lsl #14
    1028:	0c058584 	cfstr32eq	mvfx8, [r5], {132}	; 0x84
    102c:	4b010583 	blmi	42640 <__bss_end+0x383d4>
    1030:	bb0a0585 	bllt	28264c <__bss_end+0x2783e0>
    1034:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1038:	11054a05 	tstne	r5, r5, lsl #20
    103c:	4b0f054e 	blmi	3c257c <__bss_end+0x3b8310>
    1040:	01040200 	mrseq	r0, R12_usr
    1044:	02006606 	andeq	r6, r0, #6291456	; 0x600000
    1048:	004a0204 	subeq	r0, sl, r4, lsl #4
    104c:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
    1050:	02000705 	andeq	r0, r0, #1310720	; 0x140000
    1054:	2f060404 	svccs	0x00060404
    1058:	05d10905 	ldrbeq	r0, [r1, #2309]	; 0x905
    105c:	054d3401 	strbeq	r3, [sp, #-1025]	; 0xfffffbff
    1060:	0591080a 	ldreq	r0, [r1, #2058]	; 0x80a
    1064:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
    1068:	4f14054a 	svcmi	0x0014054a
    106c:	054b0f05 	strbeq	r0, [fp, #-3845]	; 0xfffff0fb
    1070:	05f39f11 	ldrbeq	r9, [r3, #3857]!	; 0xf11
    1074:	0200f313 	andeq	pc, r0, #1275068416	; 0x4c000000
    1078:	66060104 	strvs	r0, [r6], -r4, lsl #2
    107c:	02040200 	andeq	r0, r4, #0, 4
    1080:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
    1084:	0a052e04 	beq	14c89c <__bss_end+0x142630>
    1088:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    108c:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    1090:	05d67703 	ldrbeq	r7, [r6, #1795]	; 0x703
    1094:	2e0a0301 	cdpcs	3, 0, cr0, cr10, cr1, {0}
    1098:	080a054d 	stmdaeq	sl, {r0, r2, r3, r6, r8, sl}
    109c:	4a090591 	bmi	2426e8 <__bss_end+0x23847c>
    10a0:	4e4a0505 	cdpmi	5, 4, cr0, cr10, cr5, {0}
    10a4:	02002805 	andeq	r2, r0, #327680	; 0x50000
    10a8:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    10ac:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
    10b0:	1e052e01 	cdpne	14, 0, cr2, cr5, cr1, {0}
    10b4:	4b15054f 	blmi	5425f8 <__bss_end+0x53838c>
    10b8:	bb670c05 	bllt	19c40d4 <__bss_end+0x19b9e68>
    10bc:	08bb0d05 	ldmeq	fp!, {r0, r2, r8, sl, fp}
    10c0:	08100521 	ldmdaeq	r0, {r0, r5, r8, sl}
    10c4:	68440521 	stmdavs	r4, {r0, r5, r8, sl}^
    10c8:	052e5105 	streq	r5, [lr, #-261]!	; 0xfffffefb
    10cc:	0c052e40 	stceq	14, cr2, [r5], {64}	; 0x40
    10d0:	4a6c059e 	bmi	1b02750 <__bss_end+0x1af84e4>
    10d4:	054a0b05 	strbeq	r0, [sl, #-2821]	; 0xfffff4fb
    10d8:	0905680a 	stmdbeq	r5, {r1, r3, fp, sp, lr}
    10dc:	4ed66e03 	cdpmi	14, 13, cr6, cr6, cr3, {0}
    10e0:	0f030105 	svceq	0x00030105
    10e4:	0a05692e 	beq	15b5a4 <__bss_end+0x151338>
    10e8:	4a090583 	bmi	2426fc <__bss_end+0x238490>
    10ec:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    10f0:	0a054e14 	beq	154948 <__bss_end+0x14a6dc>
    10f4:	d109054c 	tstle	r9, ip, asr #10
    10f8:	4d340105 	ldfmis	f0, [r4, #-20]!	; 0xffffffec
    10fc:	21080a05 	tstcs	r8, r5, lsl #20
    1100:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1104:	0e054a05 	vmlaeq.f32	s8, s10, s10
    1108:	4b11054d 	blmi	442644 <__bss_end+0x4383d8>
    110c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    1110:	20054a19 	andcs	r4, r5, r9, lsl sl
    1114:	01040200 	mrseq	r0, R12_usr
    1118:	0019054a 	andseq	r0, r9, sl, asr #10
    111c:	66010402 	strvs	r0, [r1], -r2, lsl #8
    1120:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
    1124:	0567bb0c 	strbeq	fp, [r7, #-2828]!	; 0xfffff4f4
    1128:	09056205 	stmdbeq	r5, {r0, r2, r9, sp, lr}
    112c:	03010529 	movweq	r0, #5417	; 0x1529
    1130:	04022e0b 	streq	r2, [r2], #-3595	; 0xfffff1f5
    1134:	79010100 	stmdbvc	r1, {r8}
    1138:	03000000 	movweq	r0, #0
    113c:	00004600 	andeq	r4, r0, r0, lsl #12
    1140:	fb010200 	blx	4194a <__bss_end+0x376de>
    1144:	01000d0e 	tsteq	r0, lr, lsl #26
    1148:	00010101 	andeq	r0, r1, r1, lsl #2
    114c:	00010000 	andeq	r0, r1, r0
    1150:	2e2e0100 	sufcse	f0, f6, f0
    1154:	2f2e2e2f 	svccs	0x002e2e2f
    1158:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    115c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1160:	2f2e2e2f 	svccs	0x002e2e2f
    1164:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1168:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    116c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1170:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1174:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1178:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    117c:	73636e75 	cmnvc	r3, #1872	; 0x750
    1180:	0100532e 	tsteq	r0, lr, lsr #6
    1184:	00000000 	andeq	r0, r0, r0
    1188:	9c240205 	sfmls	f0, 4, [r4], #-20	; 0xffffffec
    118c:	ca030000 	bgt	c1194 <__bss_end+0xb6f28>
    1190:	2f300108 	svccs	0x00300108
    1194:	2f2f2f2f 	svccs	0x002f2f2f
    1198:	01d00230 	bicseq	r0, r0, r0, lsr r2
    119c:	2f312f14 	svccs	0x00312f14
    11a0:	2f4c302f 	svccs	0x004c302f
    11a4:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
    11a8:	2f2f2f2f 	svccs	0x002f2f2f
    11ac:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    11b0:	01010002 	tsteq	r1, r2
    11b4:	0000005c 	andeq	r0, r0, ip, asr r0
    11b8:	00460003 	subeq	r0, r6, r3
    11bc:	01020000 	mrseq	r0, (UNDEF: 2)
    11c0:	000d0efb 	strdeq	r0, [sp], -fp
    11c4:	01010101 	tsteq	r1, r1, lsl #2
    11c8:	01000000 	mrseq	r0, (UNDEF: 0)
    11cc:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    11d0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11d4:	2f2e2e2f 	svccs	0x002e2e2f
    11d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11e0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11e4:	2f636367 	svccs	0x00636367
    11e8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    11ec:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    11f0:	00006d72 	andeq	r6, r0, r2, ror sp
    11f4:	3162696c 	cmncc	r2, ip, ror #18
    11f8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    11fc:	00532e73 	subseq	r2, r3, r3, ror lr
    1200:	00000001 	andeq	r0, r0, r1
    1204:	30020500 	andcc	r0, r2, r0, lsl #10
    1208:	0300009e 	movweq	r0, #158	; 0x9e
    120c:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
    1210:	01010002 	tsteq	r1, r2
    1214:	00000103 	andeq	r0, r0, r3, lsl #2
    1218:	00fd0003 	rscseq	r0, sp, r3
    121c:	01020000 	mrseq	r0, (UNDEF: 2)
    1220:	000d0efb 	strdeq	r0, [sp], -fp
    1224:	01010101 	tsteq	r1, r1, lsl #2
    1228:	01000000 	mrseq	r0, (UNDEF: 0)
    122c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    1230:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1234:	2f2e2e2f 	svccs	0x002e2e2f
    1238:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    123c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1240:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1244:	2f636367 	svccs	0x00636367
    1248:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
    124c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1250:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
    1254:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1258:	2f2e2e2f 	svccs	0x002e2e2f
    125c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1260:	2f2e2f2e 	svccs	0x002e2f2e
    1264:	00636367 	rsbeq	r6, r3, r7, ror #6
    1268:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    126c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1270:	2f2e2e2f 	svccs	0x002e2e2f
    1274:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1278:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    127c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1280:	2f2e2e2f 	svccs	0x002e2e2f
    1284:	2f636367 	svccs	0x00636367
    1288:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    128c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1290:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
    1294:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1298:	2f2e2e2f 	svccs	0x002e2e2f
    129c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12a4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    12a8:	00636367 	rsbeq	r6, r3, r7, ror #6
    12ac:	73616800 	cmnvc	r1, #0, 16
    12b0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    12b4:	0100682e 	tsteq	r0, lr, lsr #16
    12b8:	72610000 	rsbvc	r0, r1, #0
    12bc:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    12c0:	00682e61 	rsbeq	r2, r8, r1, ror #28
    12c4:	61000002 	tstvs	r0, r2
    12c8:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
    12cc:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
    12d0:	00000200 	andeq	r0, r0, r0, lsl #4
    12d4:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    12d8:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    12dc:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
    12e0:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    12e4:	00000200 	andeq	r0, r0, r0, lsl #4
    12e8:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    12ec:	00030068 	andeq	r0, r3, r8, rrx
    12f0:	62696c00 	rsbvs	r6, r9, #0, 24
    12f4:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    12f8:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
    12fc:	62670000 	rsbvs	r0, r7, #0
    1300:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
    1304:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
    1308:	00040068 	andeq	r0, r4, r8, rrx
    130c:	62696c00 	rsbvs	r6, r9, #0, 24
    1310:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1314:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
    1318:	Address 0x0000000000001318 is out of bounds.


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
      58:	20f70704 	rscscs	r0, r7, r4, lsl #14
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
     128:	000020f7 	strdeq	r2, [r0], -r7
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
     174:	cb104801 	blgt	412180 <__bss_end+0x407f14>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x35f28>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x479bec>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x35ff8>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6220>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000f74 	andeq	r0, r0, r4, ror pc
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000c4904 	andeq	r4, ip, r4, lsl #18
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00010c00 	andeq	r0, r1, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	13010200 	movwne	r0, #4608	; 0x1200
     2fc:	04050000 	streq	r0, [r5], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
     308:	0300009e 	movweq	r0, #158	; 0x9e
     30c:	1ec10404 	cdpne	4, 12, cr0, cr1, cr4, {0}
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	10b90801 	adcsne	r0, r9, r1, lsl #16
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0e370502 	cdpeq	5, 3, cr0, cr7, cr2, {0}
     328:	04050000 	streq	r0, [r5], #-0
     32c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     330:	08010300 	stmdaeq	r1, {r8, r9}
     334:	000010b0 	strheq	r1, [r0], -r0
     338:	000d8006 	andeq	r8, sp, r6
     33c:	07080200 	streq	r0, [r8, -r0, lsl #4]
     340:	00000070 	andeq	r0, r0, r0, ror r0
     344:	6b070203 	blvs	1c0b58 <__bss_end+0x1b68ec>
     348:	06000012 			; <UNDEFINED> instruction: 0x06000012
     34c:	000006ea 	andeq	r0, r0, sl, ror #13
     350:	88070902 	stmdahi	r7, {r1, r8, fp}
     354:	04000000 	streq	r0, [r0], #-0
     358:	00000077 	andeq	r0, r0, r7, ror r0
     35c:	f7070403 			; <UNDEFINED> instruction: 0xf7070403
     360:	04000020 	streq	r0, [r0], #-32	; 0xffffffe0
     364:	00000088 	andeq	r0, r0, r8, lsl #1
     368:	00008807 	andeq	r8, r0, r7, lsl #16
     36c:	136b0800 	cmnne	fp, #0, 16
     370:	03080000 	movweq	r0, #32768	; 0x8000
     374:	00bf0806 	adcseq	r0, pc, r6, lsl #16
     378:	72090000 	andvc	r0, r9, #0
     37c:	08030030 	stmdaeq	r3, {r4, r5}
     380:	0000770e 	andeq	r7, r0, lr, lsl #14
     384:	72090000 	andvc	r0, r9, #0
     388:	09030031 	stmdbeq	r3, {r0, r4, r5}
     38c:	0000770e 	andeq	r7, r0, lr, lsl #14
     390:	0a000400 	beq	1398 <shift+0x1398>
     394:	00000eee 	andeq	r0, r0, lr, ror #29
     398:	00560405 	subseq	r0, r6, r5, lsl #8
     39c:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
     3a0:	0000f60c 	andeq	pc, r0, ip, lsl #12
     3a4:	06e20b00 	strbteq	r0, [r2], r0, lsl #22
     3a8:	0b000000 	bleq	3b0 <shift+0x3b0>
     3ac:	00000924 	andeq	r0, r0, r4, lsr #18
     3b0:	0f100b01 	svceq	0x00100b01
     3b4:	0b020000 	bleq	803bc <__bss_end+0x76150>
     3b8:	000010cc 	andeq	r1, r0, ip, asr #1
     3bc:	09070b03 	stmdbeq	r7, {r0, r1, r8, r9, fp}
     3c0:	0b040000 	bleq	1003c8 <__bss_end+0xf615c>
     3c4:	00000e27 	andeq	r0, r0, r7, lsr #28
     3c8:	d60a0005 	strle	r0, [sl], -r5
     3cc:	0500000e 	streq	r0, [r0, #-14]
     3d0:	00005604 	andeq	r5, r0, r4, lsl #12
     3d4:	0c3f0300 	ldceq	3, cr0, [pc], #-0	; 3dc <shift+0x3dc>
     3d8:	00000133 	andeq	r0, r0, r3, lsr r1
     3dc:	00084b0b 	andeq	r4, r8, fp, lsl #22
     3e0:	0a0b0000 	beq	2c03e8 <__bss_end+0x2b617c>
     3e4:	01000010 	tsteq	r0, r0, lsl r0
     3e8:	0012fb0b 	andseq	pc, r2, fp, lsl #22
     3ec:	fe0b0200 	cdp2	2, 0, cr0, cr11, cr0, {0}
     3f0:	0300000c 	movweq	r0, #12
     3f4:	0009160b 	andeq	r1, r9, fp, lsl #12
     3f8:	3c0b0400 	cfstrscc	mvf0, [fp], {-0}
     3fc:	0500000a 	streq	r0, [r0, #-10]
     400:	0007620b 	andeq	r6, r7, fp, lsl #4
     404:	06000600 	streq	r0, [r0], -r0, lsl #12
     408:	00000dee 	andeq	r0, r0, lr, ror #27
     40c:	56070304 	strpl	r0, [r7], -r4, lsl #6
     410:	02000000 	andeq	r0, r0, #0
     414:	00000c31 	andeq	r0, r0, r1, lsr ip
     418:	83140504 	tsthi	r4, #4, 10	; 0x1000000
     41c:	05000000 	streq	r0, [r0, #-0]
     420:	009e3803 	addseq	r3, lr, r3, lsl #16
     424:	100f0200 	andne	r0, pc, r0, lsl #4
     428:	06040000 	streq	r0, [r4], -r0
     42c:	00008314 	andeq	r8, r0, r4, lsl r3
     430:	3c030500 	cfstr32cc	mvfx0, [r3], {-0}
     434:	0200009e 	andeq	r0, r0, #158	; 0x9e
     438:	00000aa7 	andeq	r0, r0, r7, lsr #21
     43c:	831a0706 	tsthi	sl, #1572864	; 0x180000
     440:	05000000 	streq	r0, [r0, #-0]
     444:	009e4003 	addseq	r4, lr, r3
     448:	0e500200 	cdpeq	2, 5, cr0, cr0, cr0, {0}
     44c:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     450:	0000831a 	andeq	r8, r0, sl, lsl r3
     454:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     458:	0200009e 	andeq	r0, r0, #158	; 0x9e
     45c:	00000a6a 	andeq	r0, r0, sl, ror #20
     460:	831a0b06 	tsthi	sl, #6144	; 0x1800
     464:	05000000 	streq	r0, [r0, #-0]
     468:	009e4803 	addseq	r4, lr, r3, lsl #16
     46c:	0ddb0200 	lfmeq	f0, 2, [fp]
     470:	0d060000 	stceq	0, cr0, [r6, #-0]
     474:	0000831a 	andeq	r8, r0, sl, lsl r3
     478:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
     47c:	0200009e 	andeq	r0, r0, #158	; 0x9e
     480:	000006c2 	andeq	r0, r0, r2, asr #13
     484:	831a0f06 	tsthi	sl, #6, 30
     488:	05000000 	streq	r0, [r0, #-0]
     48c:	009e5003 	addseq	r5, lr, r3
     490:	0ce40a00 	vstmiaeq	r4!, {s1-s0}
     494:	04050000 	streq	r0, [r5], #-0
     498:	00000056 	andeq	r0, r0, r6, asr r0
     49c:	e20c1b06 	and	r1, ip, #6144	; 0x1800
     4a0:	0b000001 	bleq	4ac <shift+0x4ac>
     4a4:	0000064e 	andeq	r0, r0, lr, asr #12
     4a8:	11380b00 	teqne	r8, r0, lsl #22
     4ac:	0b010000 	bleq	404b4 <__bss_end+0x36248>
     4b0:	000012f6 	strdeq	r1, [r0], -r6
     4b4:	190c0002 	stmdbne	ip, {r1}
     4b8:	0d000004 	stceq	0, cr0, [r0, #-16]
     4bc:	000004e1 	andeq	r0, r0, r1, ror #9
     4c0:	07630690 			; <UNDEFINED> instruction: 0x07630690
     4c4:	00000355 	andeq	r0, r0, r5, asr r3
     4c8:	00062a08 	andeq	r2, r6, r8, lsl #20
     4cc:	67062400 	strvs	r2, [r6, -r0, lsl #8]
     4d0:	00026f10 	andeq	r6, r2, r0, lsl pc
     4d4:	24670e00 	strbtcs	r0, [r7], #-3584	; 0xfffff200
     4d8:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
     4dc:	00035512 	andeq	r5, r3, r2, lsl r5
     4e0:	500e0000 	andpl	r0, lr, r0
     4e4:	06000008 	streq	r0, [r0], -r8
     4e8:	0365126b 	cmneq	r5, #-1342177274	; 0xb0000006
     4ec:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4f0:	00000643 	andeq	r0, r0, r3, asr #12
     4f4:	77166d06 	ldrvc	r6, [r6, -r6, lsl #26]
     4f8:	14000000 	strne	r0, [r0], #-0
     4fc:	000e300e 	andeq	r3, lr, lr
     500:	1c700600 	ldclne	6, cr0, [r0], #-0
     504:	0000036c 	andeq	r0, r0, ip, ror #6
     508:	12b30e18 	adcsne	r0, r3, #24, 28	; 0x180
     50c:	72060000 	andvc	r0, r6, #0
     510:	00036c1c 	andeq	r6, r3, ip, lsl ip
     514:	dc0e1c00 	stcle	12, cr1, [lr], {-0}
     518:	06000004 	streq	r0, [r0], -r4
     51c:	036c1c75 	cmneq	ip, #29952	; 0x7500
     520:	0f200000 	svceq	0x00200000
     524:	00000ec5 	andeq	r0, r0, r5, asr #29
     528:	f61c7706 			; <UNDEFINED> instruction: 0xf61c7706
     52c:	6c000011 	stcvs	0, cr0, [r0], {17}
     530:	63000003 	movwvs	r0, #3
     534:	10000002 	andne	r0, r0, r2
     538:	0000036c 	andeq	r0, r0, ip, ror #6
     53c:	00037211 	andeq	r7, r3, r1, lsl r2
     540:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     544:	000012eb 	andeq	r1, r0, fp, ror #5
     548:	107b0618 	rsbsne	r0, fp, r8, lsl r6
     54c:	000002a4 	andeq	r0, r0, r4, lsr #5
     550:	0024670e 	eoreq	r6, r4, lr, lsl #14
     554:	127e0600 	rsbsne	r0, lr, #0, 12
     558:	00000355 	andeq	r0, r0, r5, asr r3
     55c:	05360e00 	ldreq	r0, [r6, #-3584]!	; 0xfffff200
     560:	80060000 	andhi	r0, r6, r0
     564:	00037219 	andeq	r7, r3, r9, lsl r2
     568:	430e1000 	movwmi	r1, #57344	; 0xe000
     56c:	0600000a 	streq	r0, [r0], -sl
     570:	037d2182 	cmneq	sp, #-2147483616	; 0x80000020
     574:	00140000 	andseq	r0, r4, r0
     578:	00026f04 	andeq	r6, r2, r4, lsl #30
     57c:	048f1200 	streq	r1, [pc], #512	; 584 <shift+0x584>
     580:	86060000 	strhi	r0, [r6], -r0
     584:	00038321 	andeq	r8, r3, r1, lsr #6
     588:	087a1200 	ldmdaeq	sl!, {r9, ip}^
     58c:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
     590:	0000831f 	andeq	r8, r0, pc, lsl r3
     594:	0e620e00 	cdpeq	14, 6, cr0, cr2, cr0, {0}
     598:	8b060000 	blhi	1805a0 <__bss_end+0x176334>
     59c:	0001f417 	andeq	pc, r1, r7, lsl r4	; <UNPREDICTABLE>
     5a0:	b20e0000 	andlt	r0, lr, #0
     5a4:	06000007 	streq	r0, [r0], -r7
     5a8:	01f4178e 	mvnseq	r1, lr, lsl #15
     5ac:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     5b0:	00000bb5 			; <UNDEFINED> instruction: 0x00000bb5
     5b4:	f4178f06 			; <UNDEFINED> instruction: 0xf4178f06
     5b8:	48000001 	stmdami	r0, {r0}
     5bc:	00099e0e 	andeq	r9, r9, lr, lsl #28
     5c0:	17900600 	ldrne	r0, [r0, r0, lsl #12]
     5c4:	000001f4 	strdeq	r0, [r0], -r4
     5c8:	04e1136c 	strbteq	r1, [r1], #876	; 0x36c
     5cc:	93060000 	movwls	r0, #24576	; 0x6000
     5d0:	000d9e09 	andeq	r9, sp, r9, lsl #28
     5d4:	00038e00 	andeq	r8, r3, r0, lsl #28
     5d8:	030e0100 	movweq	r0, #57600	; 0xe100
     5dc:	03140000 	tsteq	r4, #0
     5e0:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     5e4:	00000003 	andeq	r0, r0, r3
     5e8:	000eba14 	andeq	fp, lr, r4, lsl sl
     5ec:	0e960600 	cdpeq	6, 9, cr0, cr6, cr0, {0}
     5f0:	00000517 	andeq	r0, r0, r7, lsl r5
     5f4:	00032901 	andeq	r2, r3, r1, lsl #18
     5f8:	00032f00 	andeq	r2, r3, r0, lsl #30
     5fc:	038e1000 	orreq	r1, lr, #0
     600:	15000000 	strne	r0, [r0, #-0]
     604:	0000084b 	andeq	r0, r0, fp, asr #16
     608:	c9109906 	ldmdbgt	r0, {r1, r2, r8, fp, ip, pc}
     60c:	9400000c 	strls	r0, [r0], #-12
     610:	01000003 	tsteq	r0, r3
     614:	00000344 	andeq	r0, r0, r4, asr #6
     618:	00038e10 	andeq	r8, r3, r0, lsl lr
     61c:	03721100 	cmneq	r2, #0, 2
     620:	bd110000 	ldclt	0, cr0, [r1, #-0]
     624:	00000001 	andeq	r0, r0, r1
     628:	00431600 	subeq	r1, r3, r0, lsl #12
     62c:	03650000 	cmneq	r5, #0
     630:	88170000 	ldmdahi	r7, {}	; <UNPREDICTABLE>
     634:	0f000000 	svceq	0x00000000
     638:	02010300 	andeq	r0, r1, #0, 6
     63c:	00000b50 	andeq	r0, r0, r0, asr fp
     640:	01f40418 	mvnseq	r0, r8, lsl r4
     644:	04180000 	ldreq	r0, [r8], #-0
     648:	0000004a 	andeq	r0, r0, sl, asr #32
     64c:	0011cb0c 	andseq	ip, r1, ip, lsl #22
     650:	78041800 	stmdavc	r4, {fp, ip}
     654:	16000003 	strne	r0, [r0], -r3
     658:	000002a4 	andeq	r0, r0, r4, lsr #5
     65c:	0000038e 	andeq	r0, r0, lr, lsl #7
     660:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     664:	000001e7 	andeq	r0, r0, r7, ror #3
     668:	01e20418 	mvneq	r0, r8, lsl r4
     66c:	ae1a0000 	cdpge	0, 1, cr0, cr10, cr0, {0}
     670:	0600000e 	streq	r0, [r0], -lr
     674:	01e7149c 			; <UNDEFINED> instruction: 0x01e7149c
     678:	58020000 	stmdapl	r2, {}	; <UNPREDICTABLE>
     67c:	07000006 	streq	r0, [r0, -r6]
     680:	00831404 	addeq	r1, r3, r4, lsl #8
     684:	03050000 	movweq	r0, #20480	; 0x5000
     688:	00009e54 	andeq	r9, r0, r4, asr lr
     68c:	000f1602 	andeq	r1, pc, r2, lsl #12
     690:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
     694:	00000083 	andeq	r0, r0, r3, lsl #1
     698:	9e580305 	cdpls	3, 5, cr0, cr8, cr5, {0}
     69c:	04020000 	streq	r0, [r2], #-0
     6a0:	07000005 	streq	r0, [r0, -r5]
     6a4:	0083140a 	addeq	r1, r3, sl, lsl #8
     6a8:	03050000 	movweq	r0, #20480	; 0x5000
     6ac:	00009e5c 	andeq	r9, r0, ip, asr lr
     6b0:	0007670a 	andeq	r6, r7, sl, lsl #14
     6b4:	56040500 	strpl	r0, [r4], -r0, lsl #10
     6b8:	07000000 	streq	r0, [r0, -r0]
     6bc:	04130c0d 	ldreq	r0, [r3], #-3085	; 0xfffff3f3
     6c0:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     6c4:	00007765 	andeq	r7, r0, r5, ror #14
     6c8:	00092e0b 	andeq	r2, r9, fp, lsl #28
     6cc:	fc0b0100 	stc2	1, cr0, [fp], {-0}
     6d0:	02000004 	andeq	r0, r0, #4
     6d4:	0007800b 	andeq	r8, r7, fp
     6d8:	be0b0300 	cdplt	3, 0, cr0, cr11, cr0, {0}
     6dc:	04000010 	streq	r0, [r0], #-16
     6e0:	0004d50b 	andeq	sp, r4, fp, lsl #10
     6e4:	08000500 	stmdaeq	r0, {r8, sl}
     6e8:	00000671 	andeq	r0, r0, r1, ror r6
     6ec:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
     6f0:	00000452 	andeq	r0, r0, r2, asr r4
     6f4:	00726c09 	rsbseq	r6, r2, r9, lsl #24
     6f8:	52131d07 	andspl	r1, r3, #448	; 0x1c0
     6fc:	00000004 	andeq	r0, r0, r4
     700:	00707309 	rsbseq	r7, r0, r9, lsl #6
     704:	52131e07 	andspl	r1, r3, #7, 28	; 0x70
     708:	04000004 	streq	r0, [r0], #-4
     70c:	00637009 	rsbeq	r7, r3, r9
     710:	52131f07 	andspl	r1, r3, #7, 30
     714:	08000004 	stmdaeq	r0, {r2}
     718:	000ed00e 	andeq	sp, lr, lr
     71c:	13200700 	nopne	{0}	; <UNPREDICTABLE>
     720:	00000452 	andeq	r0, r0, r2, asr r4
     724:	0403000c 	streq	r0, [r3], #-12
     728:	0020f207 	eoreq	pc, r0, r7, lsl #4
     72c:	04520400 	ldrbeq	r0, [r2], #-1024	; 0xfffffc00
     730:	fa080000 	blx	200738 <__bss_end+0x1f64cc>
     734:	70000008 	andvc	r0, r0, r8
     738:	ee082807 	cdp	8, 0, cr2, cr8, cr7, {0}
     73c:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     740:	000007fa 	strdeq	r0, [r0], -sl
     744:	13122a07 	tstne	r2, #28672	; 0x7000
     748:	00000004 	andeq	r0, r0, r4
     74c:	64697009 	strbtvs	r7, [r9], #-9
     750:	122b0700 	eorne	r0, fp, #0, 14
     754:	00000088 	andeq	r0, r0, r8, lsl #1
     758:	1e430e10 	mcrne	14, 2, r0, cr3, cr0, {0}
     75c:	2c070000 	stccs	0, cr0, [r7], {-0}
     760:	0003dc11 	andeq	sp, r3, r1, lsl ip
     764:	a20e1400 	andge	r1, lr, #0, 8
     768:	07000010 	smladeq	r0, r0, r0, r0
     76c:	0088122d 	addeq	r1, r8, sp, lsr #4
     770:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     774:	000003a9 	andeq	r0, r0, r9, lsr #7
     778:	88122e07 	ldmdahi	r2, {r0, r1, r2, r9, sl, fp, sp}
     77c:	1c000000 	stcne	0, cr0, [r0], {-0}
     780:	000f030e 	andeq	r0, pc, lr, lsl #6
     784:	0c2f0700 	stceq	7, cr0, [pc], #-0	; 78c <shift+0x78c>
     788:	000004ee 	andeq	r0, r0, lr, ror #9
     78c:	04850e20 	streq	r0, [r5], #3616	; 0xe20
     790:	30070000 	andcc	r0, r7, r0
     794:	00005609 	andeq	r5, r0, r9, lsl #12
     798:	0f0e6000 	svceq	0x000e6000
     79c:	0700000b 	streq	r0, [r0, -fp]
     7a0:	00770e31 	rsbseq	r0, r7, r1, lsr lr
     7a4:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     7a8:	00000d72 	andeq	r0, r0, r2, ror sp
     7ac:	770e3307 	strvc	r3, [lr, -r7, lsl #6]
     7b0:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     7b4:	000d690e 	andeq	r6, sp, lr, lsl #18
     7b8:	0e340700 	cdpeq	7, 3, cr0, cr4, cr0, {0}
     7bc:	00000077 	andeq	r0, r0, r7, ror r0
     7c0:	9416006c 	ldrls	r0, [r6], #-108	; 0xffffff94
     7c4:	fe000003 	cdp2	0, 0, cr0, cr0, cr3, {0}
     7c8:	17000004 	strne	r0, [r0, -r4]
     7cc:	00000088 	andeq	r0, r0, r8, lsl #1
     7d0:	ed02000f 	stc	0, cr0, [r2, #-60]	; 0xffffffc4
     7d4:	08000004 	stmdaeq	r0, {r2}
     7d8:	0083140a 	addeq	r1, r3, sl, lsl #8
     7dc:	03050000 	movweq	r0, #20480	; 0x5000
     7e0:	00009e60 	andeq	r9, r0, r0, ror #28
     7e4:	000afa0a 	andeq	pc, sl, sl, lsl #20
     7e8:	56040500 	strpl	r0, [r4], -r0, lsl #10
     7ec:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     7f0:	052f0c0d 	streq	r0, [pc, #-3085]!	; fffffbeb <__bss_end+0xffff597f>
     7f4:	0a0b0000 	beq	2c07fc <__bss_end+0x2b6590>
     7f8:	00000013 	andeq	r0, r0, r3, lsl r0
     7fc:	00116d0b 	andseq	r6, r1, fp, lsl #26
     800:	08000100 	stmdaeq	r0, {r8}
     804:	000007df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     808:	081b080c 	ldmdaeq	fp, {r2, r3, fp}
     80c:	00000564 	andeq	r0, r0, r4, ror #10
     810:	00058a0e 	andeq	r8, r5, lr, lsl #20
     814:	191d0800 	ldmdbne	sp, {fp}
     818:	00000564 	andeq	r0, r0, r4, ror #10
     81c:	04dc0e00 	ldrbeq	r0, [ip], #3584	; 0xe00
     820:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
     824:	00056419 	andeq	r6, r5, r9, lsl r4
     828:	2a0e0400 	bcs	381830 <__bss_end+0x3775c4>
     82c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     830:	056a131f 	strbeq	r1, [sl, #-799]!	; 0xfffffce1
     834:	00080000 	andeq	r0, r8, r0
     838:	052f0418 	streq	r0, [pc, #-1048]!	; 428 <shift+0x428>
     83c:	04180000 	ldreq	r0, [r8], #-0
     840:	0000045e 	andeq	r0, r0, lr, asr r4
     844:	000e710d 	andeq	r7, lr, sp, lsl #2
     848:	22081400 	andcs	r1, r8, #0, 8
     84c:	0007f207 	andeq	pc, r7, r7, lsl #4
     850:	0c3f0e00 	ldceq	14, cr0, [pc], #-0	; 858 <shift+0x858>
     854:	26080000 	strcs	r0, [r8], -r0
     858:	00007712 	andeq	r7, r0, r2, lsl r7
     85c:	d20e0000 	andle	r0, lr, #0
     860:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     864:	05641d29 	strbeq	r1, [r4, #-3369]!	; 0xfffff2d7
     868:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     86c:	00000788 	andeq	r0, r0, r8, lsl #15
     870:	641d2c08 	ldrvs	r2, [sp], #-3080	; 0xfffff3f8
     874:	08000005 	stmdaeq	r0, {r0, r2}
     878:	000cf41c 	andeq	pc, ip, ip, lsl r4	; <UNPREDICTABLE>
     87c:	0e2f0800 	cdpeq	8, 2, cr0, cr15, cr0, {0}
     880:	000007bc 			; <UNDEFINED> instruction: 0x000007bc
     884:	000005b8 			; <UNDEFINED> instruction: 0x000005b8
     888:	000005c3 	andeq	r0, r0, r3, asr #11
     88c:	0007f710 	andeq	pc, r7, r0, lsl r7	; <UNPREDICTABLE>
     890:	05641100 	strbeq	r1, [r4, #-256]!	; 0xffffff00
     894:	1d000000 	stcne	0, cr0, [r0, #-0]
     898:	00000937 	andeq	r0, r0, r7, lsr r9
     89c:	d10e3108 	tstle	lr, r8, lsl #2
     8a0:	65000008 	strvs	r0, [r0, #-8]
     8a4:	db000003 	blle	8b8 <shift+0x8b8>
     8a8:	e6000005 	str	r0, [r0], -r5
     8ac:	10000005 	andne	r0, r0, r5
     8b0:	000007f7 	strdeq	r0, [r0], -r7
     8b4:	00056a11 	andeq	r6, r5, r1, lsl sl
     8b8:	19130000 	ldmdbne	r3, {}	; <UNPREDICTABLE>
     8bc:	08000011 	stmdaeq	r0, {r0, r4}
     8c0:	0ad51d35 	beq	ff547d9c <__bss_end+0xff53db30>
     8c4:	05640000 	strbeq	r0, [r4, #-0]!
     8c8:	ff020000 			; <UNDEFINED> instruction: 0xff020000
     8cc:	05000005 	streq	r0, [r0, #-5]
     8d0:	10000006 	andne	r0, r0, r6
     8d4:	000007f7 	strdeq	r0, [r0], -r7
     8d8:	07731300 	ldrbeq	r1, [r3, -r0, lsl #6]!
     8dc:	37080000 	strcc	r0, [r8, -r0]
     8e0:	000d041d 	andeq	r0, sp, sp, lsl r4
     8e4:	00056400 	andeq	r6, r5, r0, lsl #8
     8e8:	061e0200 	ldreq	r0, [lr], -r0, lsl #4
     8ec:	06240000 	strteq	r0, [r4], -r0
     8f0:	f7100000 			; <UNDEFINED> instruction: 0xf7100000
     8f4:	00000007 	andeq	r0, r0, r7
     8f8:	000be51e 	andeq	lr, fp, lr, lsl r5
     8fc:	31390800 	teqcc	r9, r0, lsl #16
     900:	00000810 	andeq	r0, r0, r0, lsl r8
     904:	7113020c 	tstvc	r3, ip, lsl #4
     908:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     90c:	0946093c 	stmdbeq	r6, {r2, r3, r4, r5, r8, fp}^
     910:	07f70000 	ldrbeq	r0, [r7, r0]!
     914:	4b010000 	blmi	4091c <__bss_end+0x366b0>
     918:	51000006 	tstpl	r0, r6
     91c:	10000006 	andne	r0, r0, r6
     920:	000007f7 	strdeq	r0, [r0], -r7
     924:	080c1300 	stmdaeq	ip, {r8, r9, ip}
     928:	3f080000 	svccc	0x00080000
     92c:	00055f12 	andeq	r5, r5, r2, lsl pc
     930:	00007700 	andeq	r7, r0, r0, lsl #14
     934:	066a0100 	strbteq	r0, [sl], -r0, lsl #2
     938:	067f0000 	ldrbteq	r0, [pc], -r0
     93c:	f7100000 			; <UNDEFINED> instruction: 0xf7100000
     940:	11000007 	tstne	r0, r7
     944:	00000819 	andeq	r0, r0, r9, lsl r8
     948:	00008811 	andeq	r8, r0, r1, lsl r8
     94c:	03651100 	cmneq	r5, #0, 2
     950:	14000000 	strne	r0, [r0], #-0
     954:	00001143 	andeq	r1, r0, r3, asr #2
     958:	7e0e4208 	cdpvc	2, 0, cr4, cr14, cr8, {0}
     95c:	01000006 	tsteq	r0, r6
     960:	00000694 	muleq	r0, r4, r6
     964:	0000069a 	muleq	r0, sl, r6
     968:	0007f710 	andeq	pc, r7, r0, lsl r7	; <UNPREDICTABLE>
     96c:	41130000 	tstmi	r3, r0
     970:	08000005 	stmdaeq	r0, {r0, r2}
     974:	05fc1745 	ldrbeq	r1, [ip, #1861]!	; 0x745
     978:	056a0000 	strbeq	r0, [sl, #-0]!
     97c:	b3010000 	movwlt	r0, #4096	; 0x1000
     980:	b9000006 	stmdblt	r0, {r1, r2}
     984:	10000006 	andne	r0, r0, r6
     988:	0000081f 	andeq	r0, r0, pc, lsl r8
     98c:	0f211300 	svceq	0x00211300
     990:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
     994:	0003bf17 	andeq	fp, r3, r7, lsl pc
     998:	00056a00 	andeq	r6, r5, r0, lsl #20
     99c:	06d20100 	ldrbeq	r0, [r2], r0, lsl #2
     9a0:	06dd0000 	ldrbeq	r0, [sp], r0
     9a4:	1f100000 	svcne	0x00100000
     9a8:	11000008 	tstne	r0, r8
     9ac:	00000077 	andeq	r0, r0, r7, ror r0
     9b0:	06cc1400 	strbeq	r1, [ip], r0, lsl #8
     9b4:	4b080000 	blmi	2009bc <__bss_end+0x1f6750>
     9b8:	000bf30e 	andeq	pc, fp, lr, lsl #6
     9bc:	06f20100 	ldrbteq	r0, [r2], r0, lsl #2
     9c0:	06f80000 	ldrbteq	r0, [r8], r0
     9c4:	f7100000 			; <UNDEFINED> instruction: 0xf7100000
     9c8:	00000007 	andeq	r0, r0, r7
     9cc:	00093713 	andeq	r3, r9, r3, lsl r7
     9d0:	0e4d0800 	cdpeq	8, 4, cr0, cr13, cr0, {0}
     9d4:	00000db3 			; <UNDEFINED> instruction: 0x00000db3
     9d8:	00000365 	andeq	r0, r0, r5, ror #6
     9dc:	00071101 	andeq	r1, r7, r1, lsl #2
     9e0:	00071c00 	andeq	r1, r7, r0, lsl #24
     9e4:	07f71000 	ldrbeq	r1, [r7, r0]!
     9e8:	77110000 	ldrvc	r0, [r1, -r0]
     9ec:	00000000 	andeq	r0, r0, r0
     9f0:	0004c113 	andeq	ip, r4, r3, lsl r1
     9f4:	12500800 	subsne	r0, r0, #0, 16
     9f8:	000003ec 	andeq	r0, r0, ip, ror #7
     9fc:	00000077 	andeq	r0, r0, r7, ror r0
     a00:	00073501 	andeq	r3, r7, r1, lsl #10
     a04:	00074000 	andeq	r4, r7, r0
     a08:	07f71000 	ldrbeq	r1, [r7, r0]!
     a0c:	94110000 	ldrls	r0, [r1], #-0
     a10:	00000003 	andeq	r0, r0, r3
     a14:	00041f13 	andeq	r1, r4, r3, lsl pc
     a18:	0e530800 	cdpeq	8, 5, cr0, cr3, cr0, {0}
     a1c:	00001199 	muleq	r0, r9, r1
     a20:	00000365 	andeq	r0, r0, r5, ror #6
     a24:	00075901 	andeq	r5, r7, r1, lsl #18
     a28:	00076400 	andeq	r6, r7, r0, lsl #8
     a2c:	07f71000 	ldrbeq	r1, [r7, r0]!
     a30:	77110000 	ldrvc	r0, [r1, -r0]
     a34:	00000000 	andeq	r0, r0, r0
     a38:	00049b14 	andeq	r9, r4, r4, lsl fp
     a3c:	0e560800 	cdpeq	8, 5, cr0, cr6, cr0, {0}
     a40:	0000101b 	andeq	r1, r0, fp, lsl r0
     a44:	00077901 	andeq	r7, r7, r1, lsl #18
     a48:	00079800 	andeq	r9, r7, r0, lsl #16
     a4c:	07f71000 	ldrbeq	r1, [r7, r0]!
     a50:	bf110000 	svclt	0x00110000
     a54:	11000000 	mrsne	r0, (UNDEF: 0)
     a58:	00000077 	andeq	r0, r0, r7, ror r0
     a5c:	00007711 	andeq	r7, r0, r1, lsl r7
     a60:	00771100 	rsbseq	r1, r7, r0, lsl #2
     a64:	25110000 	ldrcs	r0, [r1, #-0]
     a68:	00000008 	andeq	r0, r0, r8
     a6c:	00122614 	andseq	r2, r2, r4, lsl r6
     a70:	0e580800 	cdpeq	8, 5, cr0, cr8, cr0, {0}
     a74:	0000131f 	andeq	r1, r0, pc, lsl r3
     a78:	0007ad01 	andeq	sl, r7, r1, lsl #26
     a7c:	0007cc00 	andeq	ip, r7, r0, lsl #24
     a80:	07f71000 	ldrbeq	r1, [r7, r0]!
     a84:	f6110000 			; <UNDEFINED> instruction: 0xf6110000
     a88:	11000000 	mrsne	r0, (UNDEF: 0)
     a8c:	00000077 	andeq	r0, r0, r7, ror r0
     a90:	00007711 	andeq	r7, r0, r1, lsl r7
     a94:	00771100 	rsbseq	r1, r7, r0, lsl #2
     a98:	25110000 	ldrcs	r0, [r1, #-0]
     a9c:	00000008 	andeq	r0, r0, r8
     aa0:	0004ae15 	andeq	sl, r4, r5, lsl lr
     aa4:	0e5b0800 	cdpeq	8, 5, cr0, cr11, cr0, {0}
     aa8:	00000b55 	andeq	r0, r0, r5, asr fp
     aac:	00000365 	andeq	r0, r0, r5, ror #6
     ab0:	0007e101 	andeq	lr, r7, r1, lsl #2
     ab4:	07f71000 	ldrbeq	r1, [r7, r0]!
     ab8:	10110000 	andsne	r0, r1, r0
     abc:	11000005 	tstne	r0, r5
     ac0:	0000082b 	andeq	r0, r0, fp, lsr #16
     ac4:	70040000 	andvc	r0, r4, r0
     ac8:	18000005 	stmdane	r0, {r0, r2}
     acc:	00057004 	andeq	r7, r5, r4
     ad0:	05641f00 	strbeq	r1, [r4, #-3840]!	; 0xfffff100
     ad4:	080a0000 	stmdaeq	sl, {}	; <UNPREDICTABLE>
     ad8:	08100000 	ldmdaeq	r0, {}	; <UNPREDICTABLE>
     adc:	f7100000 			; <UNDEFINED> instruction: 0xf7100000
     ae0:	00000007 	andeq	r0, r0, r7
     ae4:	00057020 	andeq	r7, r5, r0, lsr #32
     ae8:	0007fd00 	andeq	pc, r7, r0, lsl #26
     aec:	5d041800 	stcpl	8, cr1, [r4, #-0]
     af0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     af4:	0007f204 	andeq	pc, r7, r4, lsl #4
     af8:	99042100 	stmdbls	r4, {r8, sp}
     afc:	22000000 	andcs	r0, r0, #0
     b00:	12881a04 	addne	r1, r8, #4, 20	; 0x4000
     b04:	5e080000 	cdppl	0, 0, cr0, cr8, cr0, {0}
     b08:	00057019 	andeq	r7, r5, r9, lsl r0
     b0c:	0e420d00 	cdpeq	13, 4, cr0, cr2, cr0, {0}
     b10:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
     b14:	097d0706 	ldmdbeq	sp!, {r1, r2, r8, r9, sl}^
     b18:	1c0e0000 	stcne	0, cr0, [lr], {-0}
     b1c:	09000009 	stmdbeq	r0, {r0, r3}
     b20:	0077120a 	rsbseq	r1, r7, sl, lsl #4
     b24:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     b28:	00000d96 	muleq	r0, r6, sp
     b2c:	650e0c09 	strvs	r0, [lr, #-3081]	; 0xfffff3f7
     b30:	04000003 	streq	r0, [r0], #-3
     b34:	000e4213 	andeq	r4, lr, r3, lsl r2
     b38:	09100900 	ldmdbeq	r0, {r8, fp}
     b3c:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
     b40:	00000982 	andeq	r0, r0, r2, lsl #19
     b44:	00087901 	andeq	r7, r8, r1, lsl #18
     b48:	00088400 	andeq	r8, r8, r0, lsl #8
     b4c:	09821000 	stmibeq	r2, {ip}
     b50:	72110000 	andsvc	r0, r1, #0
     b54:	00000003 	andeq	r0, r0, r3
     b58:	000e4113 	andeq	r4, lr, r3, lsl r1
     b5c:	15120900 	ldrne	r0, [r2, #-2304]	; 0xfffff700
     b60:	00000df9 	strdeq	r0, [r0], -r9
     b64:	0000082b 	andeq	r0, r0, fp, lsr #16
     b68:	00089d01 	andeq	r9, r8, r1, lsl #26
     b6c:	0008a800 	andeq	sl, r8, r0, lsl #16
     b70:	09821000 	stmibeq	r2, {ip}
     b74:	56100000 	ldrpl	r0, [r0], -r0
     b78:	00000000 	andeq	r0, r0, r0
     b7c:	0006b813 	andeq	fp, r6, r3, lsl r8
     b80:	0e150900 	vnmlseq.f16	s0, s10, s0	; <UNPREDICTABLE>
     b84:	000009dc 	ldrdeq	r0, [r0], -ip
     b88:	00000365 	andeq	r0, r0, r5, ror #6
     b8c:	0008c101 	andeq	ip, r8, r1, lsl #2
     b90:	0008c700 	andeq	ip, r8, r0, lsl #14
     b94:	09881000 	stmibeq	r8, {ip}
     b98:	14000000 	strne	r0, [r0], #-0
     b9c:	00000fa6 	andeq	r0, r0, r6, lsr #31
     ba0:	b70e1809 	strlt	r1, [lr, -r9, lsl #16]
     ba4:	01000008 	tsteq	r0, r8
     ba8:	000008dc 	ldrdeq	r0, [r0], -ip
     bac:	000008e2 	andeq	r0, r0, r2, ror #17
     bb0:	00098210 	andeq	r8, r9, r0, lsl r2
     bb4:	d6140000 	ldrle	r0, [r4], -r0
     bb8:	09000009 	stmdbeq	r0, {r0, r3}
     bbc:	07340e1b 			; <UNDEFINED> instruction: 0x07340e1b
     bc0:	f7010000 			; <UNDEFINED> instruction: 0xf7010000
     bc4:	02000008 	andeq	r0, r0, #8
     bc8:	10000009 	andne	r0, r0, r9
     bcc:	00000982 	andeq	r0, r0, r2, lsl #19
     bd0:	00036511 	andeq	r6, r3, r1, lsl r5
     bd4:	98140000 	ldmdals	r4, {}	; <UNPREDICTABLE>
     bd8:	09000010 	stmdbeq	r0, {r4}
     bdc:	11780e1d 	cmnne	r8, sp, lsl lr
     be0:	17010000 	strne	r0, [r1, -r0]
     be4:	2c000009 	stccs	0, cr0, [r0], {9}
     be8:	10000009 	andne	r0, r0, r9
     bec:	00000982 	andeq	r0, r0, r2, lsl #19
     bf0:	00006411 	andeq	r6, r0, r1, lsl r4
     bf4:	00641100 	rsbeq	r1, r4, r0, lsl #2
     bf8:	65110000 	ldrvs	r0, [r1, #-0]
     bfc:	00000003 	andeq	r0, r0, r3
     c00:	00075914 	andeq	r5, r7, r4, lsl r9
     c04:	0e1f0900 	vnmlseq.f16	s0, s30, s0	; <UNPREDICTABLE>
     c08:	0000058f 	andeq	r0, r0, pc, lsl #11
     c0c:	00094101 	andeq	r4, r9, r1, lsl #2
     c10:	00095600 	andeq	r5, r9, r0, lsl #12
     c14:	09821000 	stmibeq	r2, {ip}
     c18:	64110000 	ldrvs	r0, [r1], #-0
     c1c:	11000000 	mrsne	r0, (UNDEF: 0)
     c20:	00000064 	andeq	r0, r0, r4, rrx
     c24:	00004311 	andeq	r4, r0, r1, lsl r3
     c28:	94230000 	strtls	r0, [r3], #-0
     c2c:	09000012 	stmdbeq	r0, {r1, r4}
     c30:	0f580e21 	svceq	0x00580e21
     c34:	67010000 	strvs	r0, [r1, -r0]
     c38:	10000009 	andne	r0, r0, r9
     c3c:	00000982 	andeq	r0, r0, r2, lsl #19
     c40:	00006411 	andeq	r6, r0, r1, lsl r4
     c44:	00641100 	rsbeq	r1, r4, r0, lsl #2
     c48:	72110000 	andsvc	r0, r1, #0
     c4c:	00000003 	andeq	r0, r0, r3
     c50:	08390400 	ldmdaeq	r9!, {sl}
     c54:	04180000 	ldreq	r0, [r8], #-0
     c58:	00000839 	andeq	r0, r0, r9, lsr r8
     c5c:	097d0418 	ldmdbeq	sp!, {r3, r4, sl}^
     c60:	68240000 	stmdavs	r4!, {}	; <UNPREDICTABLE>
     c64:	0a006c61 	beq	1bdf0 <__bss_end+0x11b84>
     c68:	0a480b05 	beq	1203884 <__bss_end+0x11f9618>
     c6c:	a2250000 	eorge	r0, r5, #0
     c70:	0a00000b 	beq	ca4 <shift+0xca4>
     c74:	008f1907 	addeq	r1, pc, r7, lsl #18
     c78:	b2800000 	addlt	r0, r0, #0
     c7c:	34250ee6 	strtcc	r0, [r5], #-3814	; 0xfffff11a
     c80:	0a00000f 	beq	cc4 <shift+0xcc4>
     c84:	04591a0a 	ldrbeq	r1, [r9], #-2570	; 0xfffff5f6
     c88:	00000000 	andeq	r0, r0, r0
     c8c:	55252000 	strpl	r2, [r5, #-0]!
     c90:	0a000005 	beq	cac <shift+0xcac>
     c94:	04591a0d 	ldrbeq	r1, [r9], #-2573	; 0xfffff5f3
     c98:	00000000 	andeq	r0, r0, r0
     c9c:	1b262020 	blne	988d24 <__bss_end+0x97eab8>
     ca0:	0a00000b 	beq	cd4 <shift+0xcd4>
     ca4:	00831510 	addeq	r1, r3, r0, lsl r5
     ca8:	25360000 	ldrcs	r0, [r6, #-0]!
     cac:	00001125 	andeq	r1, r0, r5, lsr #2
     cb0:	591a4b0a 	ldmdbpl	sl, {r1, r3, r8, r9, fp, lr}
     cb4:	00000004 	andeq	r0, r0, r4
     cb8:	25202150 	strcs	r2, [r0, #-336]!	; 0xfffffeb0
     cbc:	000012d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
     cc0:	591a7a0a 	ldmdbpl	sl, {r1, r3, r9, fp, ip, sp, lr}
     cc4:	00000004 	andeq	r0, r0, r4
     cc8:	252000b2 	strcs	r0, [r0, #-178]!	; 0xffffff4e
     ccc:	0000086f 	andeq	r0, r0, pc, ror #16
     cd0:	591aad0a 	ldmdbpl	sl, {r1, r3, r8, sl, fp, sp, pc}
     cd4:	00000004 	andeq	r0, r0, r4
     cd8:	252000b4 	strcs	r0, [r0, #-180]!	; 0xffffff4c
     cdc:	00000b98 	muleq	r0, r8, fp
     ce0:	591abc0a 	ldmdbpl	sl, {r1, r3, sl, fp, ip, sp, pc}
     ce4:	00000004 	andeq	r0, r0, r4
     ce8:	25201040 	strcs	r1, [r0, #-64]!	; 0xffffffc0
     cec:	00000d3d 	andeq	r0, r0, sp, lsr sp
     cf0:	591ac70a 	ldmdbpl	sl, {r1, r3, r8, r9, sl, lr, pc}
     cf4:	00000004 	andeq	r0, r0, r4
     cf8:	25202050 	strcs	r2, [r0, #-80]!	; 0xffffffb0
     cfc:	0000074f 	andeq	r0, r0, pc, asr #14
     d00:	591ac80a 	ldmdbpl	sl, {r1, r3, fp, lr, pc}
     d04:	00000004 	andeq	r0, r0, r4
     d08:	25208040 	strcs	r8, [r0, #-64]!	; 0xffffffc0
     d0c:	0000112e 	andeq	r1, r0, lr, lsr #2
     d10:	591ac90a 	ldmdbpl	sl, {r1, r3, r8, fp, lr, pc}
     d14:	00000004 	andeq	r0, r0, r4
     d18:	00208050 	eoreq	r8, r0, r0, asr r0
     d1c:	00099a27 	andeq	r9, r9, r7, lsr #20
     d20:	09aa2700 	stmibeq	sl!, {r8, r9, sl, sp}
     d24:	ba270000 	blt	9c0d2c <__bss_end+0x9b6ac0>
     d28:	27000009 	strcs	r0, [r0, -r9]
     d2c:	000009ca 	andeq	r0, r0, sl, asr #19
     d30:	0009d727 	andeq	sp, r9, r7, lsr #14
     d34:	09e72700 	stmibeq	r7!, {r8, r9, sl, sp}^
     d38:	f7270000 			; <UNDEFINED> instruction: 0xf7270000
     d3c:	27000009 	strcs	r0, [r0, -r9]
     d40:	00000a07 	andeq	r0, r0, r7, lsl #20
     d44:	000a1727 	andeq	r1, sl, r7, lsr #14
     d48:	0a272700 	beq	9ca950 <__bss_end+0x9c06e4>
     d4c:	37270000 	strcc	r0, [r7, -r0]!
     d50:	0200000a 	andeq	r0, r0, #10
     d54:	00000fab 	andeq	r0, r0, fp, lsr #31
     d58:	8314080b 	tsthi	r4, #720896	; 0xb0000
     d5c:	05000000 	streq	r0, [r0, #-0]
     d60:	009e9003 	addseq	r9, lr, r3
     d64:	0cb00a00 	vldmiaeq	r0!, {s0-s-1}
     d68:	04070000 	streq	r0, [r7], #-0
     d6c:	00000088 	andeq	r0, r0, r8, lsl #1
     d70:	da0c0b0b 	ble	3039a4 <__bss_end+0x2f9738>
     d74:	0b00000a 	bleq	da4 <shift+0xda4>
     d78:	00000cc3 	andeq	r0, r0, r3, asr #25
     d7c:	063c0b00 	ldrteq	r0, [ip], -r0, lsl #22
     d80:	0b010000 	bleq	40d88 <__bss_end+0x36b1c>
     d84:	000011f0 	strdeq	r1, [r0], -r0
     d88:	11ea0b02 	mvnne	r0, r2, lsl #22
     d8c:	0b030000 	bleq	c0d94 <__bss_end+0xb6b28>
     d90:	000011c5 	andeq	r1, r0, r5, asr #3
     d94:	12ad0b04 	adcne	r0, sp, #4, 22	; 0x1000
     d98:	0b050000 	bleq	140da0 <__bss_end+0x136b34>
     d9c:	000011de 	ldrdeq	r1, [r0], -lr
     da0:	11e40b06 	mvnne	r0, r6, lsl #22
     da4:	0b070000 	bleq	1c0dac <__bss_end+0x1b6b40>
     da8:	00000e82 	andeq	r0, r0, r2, lsl #29
     dac:	270a0008 	strcs	r0, [sl, -r8]
     db0:	0500000a 	streq	r0, [r0, #-10]
     db4:	00005604 	andeq	r5, r0, r4, lsl #12
     db8:	0c1d0b00 			; <UNDEFINED> instruction: 0x0c1d0b00
     dbc:	00000b05 	andeq	r0, r0, r5, lsl #22
     dc0:	000d470b 	andeq	r4, sp, fp, lsl #14
     dc4:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     dc8:	0100000d 	tsteq	r0, sp
     dcc:	000d640b 	andeq	r6, sp, fp, lsl #8
     dd0:	4c1b0200 	lfmmi	f0, 4, [fp], {-0}
     dd4:	0300776f 	movweq	r7, #1903	; 0x76f
     dd8:	129f0d00 	addsne	r0, pc, #0, 26
     ddc:	0b1c0000 	bleq	700de4 <__bss_end+0x6f6b78>
     de0:	0e860728 	cdpeq	7, 8, cr0, cr6, cr8, {1}
     de4:	9b080000 	blls	200dec <__bss_end+0x1f6b80>
     de8:	10000003 	andne	r0, r0, r3
     dec:	540a330b 	strpl	r3, [sl], #-779	; 0xfffffcf5
     df0:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
     df4:	00001390 	muleq	r0, r0, r3
     df8:	940b350b 	strls	r3, [fp], #-1291	; 0xfffffaf5
     dfc:	00000003 	andeq	r0, r0, r3
     e00:	0007f20e 	andeq	pc, r7, lr, lsl #4
     e04:	0d360b00 	vldmdbeq	r6!, {d0-d-1}
     e08:	00000077 	andeq	r0, r0, r7, ror r0
     e0c:	058a0e04 	streq	r0, [sl, #3588]	; 0xe04
     e10:	370b0000 	strcc	r0, [fp, -r0]
     e14:	000e8b13 	andeq	r8, lr, r3, lsl fp
     e18:	dc0e0800 	stcle	8, cr0, [lr], {-0}
     e1c:	0b000004 	bleq	e34 <shift+0xe34>
     e20:	0e8b1338 	mcreq	3, 4, r1, cr11, cr8, {1}
     e24:	000c0000 	andeq	r0, ip, r0
     e28:	0008060e 	andeq	r0, r8, lr, lsl #12
     e2c:	202c0b00 	eorcs	r0, ip, r0, lsl #22
     e30:	00000e97 	muleq	r0, r7, lr
     e34:	0ff80e00 	svceq	0x00f80e00
     e38:	2f0b0000 	svccs	0x000b0000
     e3c:	000e9c0c 	andeq	r9, lr, ip, lsl #24
     e40:	bd0e0400 	cfstrslt	mvf0, [lr, #-0]
     e44:	0b00000a 	bleq	e74 <shift+0xe74>
     e48:	0e9c0c31 	mrceq	12, 4, r0, cr12, cr1, {1}
     e4c:	0e0c0000 	cdpeq	0, 0, cr0, cr12, cr0, {0}
     e50:	00000c22 	andeq	r0, r0, r2, lsr #24
     e54:	8b123b0b 	blhi	48fa88 <__bss_end+0x48581c>
     e58:	1400000e 	strne	r0, [r0], #-14
     e5c:	0009980e 	andeq	r9, r9, lr, lsl #16
     e60:	0e3d0b00 	vaddeq.f64	d0, d13, d0
     e64:	00000133 	andeq	r0, r0, r3, lsr r1
     e68:	0f441318 	svceq	0x00441318
     e6c:	410b0000 	mrsmi	r0, (UNDEF: 11)
     e70:	00081b08 	andeq	r1, r8, r8, lsl #22
     e74:	00036500 	andeq	r6, r3, r0, lsl #10
     e78:	0bae0200 	bleq	feb81680 <__bss_end+0xfeb77414>
     e7c:	0bc30000 	bleq	ff0c0e84 <__bss_end+0xff0b6c18>
     e80:	ac100000 	ldcge	0, cr0, [r0], {-0}
     e84:	1100000e 	tstne	r0, lr
     e88:	00000077 	andeq	r0, r0, r7, ror r0
     e8c:	000eb211 	andeq	fp, lr, r1, lsl r2
     e90:	0eb21100 	frdeqs	f1, f2, f0
     e94:	13000000 	movwne	r0, #0
     e98:	0000085c 	andeq	r0, r0, ip, asr r8
     e9c:	3c08430b 	stccc	3, cr4, [r8], {11}
     ea0:	65000012 	strvs	r0, [r0, #-18]	; 0xffffffee
     ea4:	02000003 	andeq	r0, r0, #3
     ea8:	00000bdc 	ldrdeq	r0, [r0], -ip
     eac:	00000bf1 	strdeq	r0, [r0], -r1
     eb0:	000eac10 	andeq	sl, lr, r0, lsl ip
     eb4:	00771100 	rsbseq	r1, r7, r0, lsl #2
     eb8:	b2110000 	andslt	r0, r1, #0
     ebc:	1100000e 	tstne	r0, lr
     ec0:	00000eb2 			; <UNDEFINED> instruction: 0x00000eb2
     ec4:	0bbf1300 	bleq	fefc5acc <__bss_end+0xfefbb860>
     ec8:	450b0000 	strmi	r0, [fp, #-0]
     ecc:	00096008 	andeq	r6, r9, r8
     ed0:	00036500 	andeq	r6, r3, r0, lsl #10
     ed4:	0c0a0200 	sfmeq	f0, 4, [sl], {-0}
     ed8:	0c1f0000 	ldceq	0, cr0, [pc], {-0}
     edc:	ac100000 	ldcge	0, cr0, [r0], {-0}
     ee0:	1100000e 	tstne	r0, lr
     ee4:	00000077 	andeq	r0, r0, r7, ror r0
     ee8:	000eb211 	andeq	fp, lr, r1, lsl r2
     eec:	0eb21100 	frdeqs	f1, f2, f0
     ef0:	13000000 	movwne	r0, #0
     ef4:	00000d2a 	andeq	r0, r0, sl, lsr #26
     ef8:	3208470b 	andcc	r4, r8, #2883584	; 0x2c0000
     efc:	65000004 	strvs	r0, [r0, #-4]
     f00:	02000003 	andeq	r0, r0, #3
     f04:	00000c38 	andeq	r0, r0, r8, lsr ip
     f08:	00000c4d 	andeq	r0, r0, sp, asr #24
     f0c:	000eac10 	andeq	sl, lr, r0, lsl ip
     f10:	00771100 	rsbseq	r1, r7, r0, lsl #2
     f14:	b2110000 	andslt	r0, r1, #0
     f18:	1100000e 	tstne	r0, lr
     f1c:	00000eb2 			; <UNDEFINED> instruction: 0x00000eb2
     f20:	08921300 	ldmeq	r2, {r8, r9, ip}
     f24:	490b0000 	stmdbmi	fp, {}	; <UNPREDICTABLE>
     f28:	000a7808 	andeq	r7, sl, r8, lsl #16
     f2c:	00036500 	andeq	r6, r3, r0, lsl #10
     f30:	0c660200 	sfmeq	f0, 2, [r6], #-0
     f34:	0c7b0000 	ldcleq	0, cr0, [fp], #-0
     f38:	ac100000 	ldcge	0, cr0, [r0], {-0}
     f3c:	1100000e 	tstne	r0, lr
     f40:	00000077 	andeq	r0, r0, r7, ror r0
     f44:	000eb211 	andeq	fp, lr, r1, lsl r2
     f48:	0eb21100 	frdeqs	f1, f2, f0
     f4c:	13000000 	movwne	r0, #0
     f50:	000010d2 	ldrdeq	r1, [r0], -r2
     f54:	af084b0b 	svcge	0x00084b0b
     f58:	65000005 	strvs	r0, [r0, #-5]
     f5c:	02000003 	andeq	r0, r0, #3
     f60:	00000c94 	muleq	r0, r4, ip
     f64:	00000cae 	andeq	r0, r0, lr, lsr #25
     f68:	000eac10 	andeq	sl, lr, r0, lsl ip
     f6c:	00771100 	rsbseq	r1, r7, r0, lsl #2
     f70:	da110000 	ble	440f78 <__bss_end+0x436d0c>
     f74:	1100000a 	tstne	r0, sl
     f78:	00000eb2 			; <UNDEFINED> instruction: 0x00000eb2
     f7c:	000eb211 	andeq	fp, lr, r1, lsl r2
     f80:	10130000 	andsne	r0, r3, r0
     f84:	0b00000e 	bleq	fc4 <shift+0xfc4>
     f88:	09a80c4f 	stmibeq	r8!, {r0, r1, r2, r3, r6, sl, fp}
     f8c:	00770000 	rsbseq	r0, r7, r0
     f90:	c7020000 	strgt	r0, [r2, -r0]
     f94:	cd00000c 	stcgt	0, cr0, [r0, #-48]	; 0xffffffd0
     f98:	1000000c 	andne	r0, r0, ip
     f9c:	00000eac 	andeq	r0, r0, ip, lsr #29
     fa0:	0a4a1400 	beq	1285fa8 <__bss_end+0x127bd3c>
     fa4:	510b0000 	mrspl	r0, (UNDEF: 11)
     fa8:	00106d08 	andseq	r6, r0, r8, lsl #26
     fac:	0ce20200 	sfmeq	f0, 2, [r2]
     fb0:	0ced0000 	stcleq	0, cr0, [sp]
     fb4:	b8100000 	ldmdalt	r0, {}	; <UNPREDICTABLE>
     fb8:	1100000e 	tstne	r0, lr
     fbc:	00000077 	andeq	r0, r0, r7, ror r0
     fc0:	129f1300 	addsne	r1, pc, #0, 6
     fc4:	540b0000 	strpl	r0, [fp], #-0
     fc8:	00079b03 	andeq	r9, r7, r3, lsl #22
     fcc:	000eb800 	andeq	fp, lr, r0, lsl #16
     fd0:	0d060100 	stfeqs	f0, [r6, #-0]
     fd4:	0d110000 	ldceq	0, cr0, [r1, #-0]
     fd8:	b8100000 	ldmdalt	r0, {}	; <UNPREDICTABLE>
     fdc:	1100000e 	tstne	r0, lr
     fe0:	00000088 	andeq	r0, r0, r8, lsl #1
     fe4:	08a51400 	stmiaeq	r5!, {sl, ip}
     fe8:	570b0000 	strpl	r0, [fp, -r0]
     fec:	000c8708 	andeq	r8, ip, r8, lsl #14
     ff0:	0d260100 	stfeqs	f0, [r6, #-0]
     ff4:	0d360000 	ldceq	0, cr0, [r6, #-0]
     ff8:	b8100000 	ldmdalt	r0, {}	; <UNPREDICTABLE>
     ffc:	1100000e 	tstne	r0, lr
    1000:	00000077 	andeq	r0, r0, r7, ror r0
    1004:	000a9111 	andeq	r9, sl, r1, lsl r1
    1008:	3e130000 	cdpcc	0, 1, cr0, cr3, cr0, {0}
    100c:	0b00000b 	bleq	1040 <shift+0x1040>
    1010:	0f7d1259 	svceq	0x007d1259
    1014:	0a910000 	beq	fe44101c <__bss_end+0xfe436db0>
    1018:	4f010000 	svcmi	0x00010000
    101c:	5a00000d 	bpl	1058 <shift+0x1058>
    1020:	1000000d 	andne	r0, r0, sp
    1024:	00000eac 	andeq	r0, r0, ip, lsr #29
    1028:	00007711 	andeq	r7, r0, r1, lsl r7
    102c:	38140000 	ldmdacc	r4, {}	; <UNPREDICTABLE>
    1030:	0b000006 	bleq	1050 <shift+0x1050>
    1034:	0712085c 			; <UNDEFINED> instruction: 0x0712085c
    1038:	6f010000 	svcvs	0x00010000
    103c:	7f00000d 	svcvc	0x0000000d
    1040:	1000000d 	andne	r0, r0, sp
    1044:	00000eb8 			; <UNDEFINED> instruction: 0x00000eb8
    1048:	00007711 	andeq	r7, r0, r1, lsl r7
    104c:	03651100 	cmneq	r5, #0, 2
    1050:	13000000 	movwne	r0, #0
    1054:	00000cbf 			; <UNDEFINED> instruction: 0x00000cbf
    1058:	f3085f0b 	vpmax.f32	d5, d8, d11
    105c:	65000006 	strvs	r0, [r0, #-6]
    1060:	01000003 	tsteq	r0, r3
    1064:	00000d98 	muleq	r0, r8, sp
    1068:	00000da3 	andeq	r0, r0, r3, lsr #27
    106c:	000eb810 	andeq	fp, lr, r0, lsl r8
    1070:	00771100 	rsbseq	r1, r7, r0, lsl #2
    1074:	13000000 	movwne	r0, #0
    1078:	00000d58 	andeq	r0, r0, r8, asr sp
    107c:	6108620b 	tstvs	r8, fp, lsl #4
    1080:	65000004 	strvs	r0, [r0, #-4]
    1084:	01000003 	tsteq	r0, r3
    1088:	00000dbc 			; <UNDEFINED> instruction: 0x00000dbc
    108c:	00000dd1 	ldrdeq	r0, [r0], -r1
    1090:	000eb810 	andeq	fp, lr, r0, lsl r8
    1094:	00771100 	rsbseq	r1, r7, r0, lsl #2
    1098:	65110000 	ldrvs	r0, [r1, #-0]
    109c:	11000003 	tstne	r0, r3
    10a0:	00000365 	andeq	r0, r0, r5, ror #6
    10a4:	0e681300 	cdpeq	3, 6, cr1, cr8, cr0, {0}
    10a8:	640b0000 	strvs	r0, [fp], #-0
    10ac:	000e8e08 	andeq	r8, lr, r8, lsl #28
    10b0:	00036500 	andeq	r6, r3, r0, lsl #10
    10b4:	0dea0100 	stfeqe	f0, [sl]
    10b8:	0dff0000 	ldcleq	0, cr0, [pc]	; 10c0 <shift+0x10c0>
    10bc:	b8100000 	ldmdalt	r0, {}	; <UNPREDICTABLE>
    10c0:	1100000e 	tstne	r0, lr
    10c4:	00000077 	andeq	r0, r0, r7, ror r0
    10c8:	00036511 	andeq	r6, r3, r1, lsl r5
    10cc:	03651100 	cmneq	r5, #0, 2
    10d0:	14000000 	strne	r0, [r0], #-0
    10d4:	00001377 	andeq	r1, r0, r7, ror r3
    10d8:	fc08670b 	stc2	7, cr6, [r8], {11}
    10dc:	01000009 	tsteq	r0, r9
    10e0:	00000e14 	andeq	r0, r0, r4, lsl lr
    10e4:	00000e24 	andeq	r0, r0, r4, lsr #28
    10e8:	000eb810 	andeq	fp, lr, r0, lsl r8
    10ec:	00771100 	rsbseq	r1, r7, r0, lsl #2
    10f0:	da110000 	ble	4410f8 <__bss_end+0x436e8c>
    10f4:	0000000a 	andeq	r0, r0, sl
    10f8:	0012bc14 	andseq	fp, r2, r4, lsl ip
    10fc:	08690b00 	stmdaeq	r9!, {r8, r9, fp}^
    1100:	00000fb7 			; <UNDEFINED> instruction: 0x00000fb7
    1104:	000e3901 	andeq	r3, lr, r1, lsl #18
    1108:	000e4900 	andeq	r4, lr, r0, lsl #18
    110c:	0eb81000 	cdpeq	0, 11, cr1, cr8, cr0, {0}
    1110:	77110000 	ldrvc	r0, [r1, -r0]
    1114:	11000000 	mrsne	r0, (UNDEF: 0)
    1118:	00000ada 	ldrdeq	r0, [r0], -sl
    111c:	0a5f1400 	beq	17c6124 <__bss_end+0x17bbeb8>
    1120:	6c0b0000 	stcvs	0, cr0, [fp], {-0}
    1124:	00114c08 	andseq	r4, r1, r8, lsl #24
    1128:	0e5e0100 	rdfeqe	f0, f6, f0
    112c:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    1130:	b8100000 	ldmdalt	r0, {}	; <UNPREDICTABLE>
    1134:	0000000e 	andeq	r0, r0, lr
    1138:	000b2f23 	andeq	r2, fp, r3, lsr #30
    113c:	086f0b00 	stmdaeq	pc!, {r8, r9, fp}^	; <UNPREDICTABLE>
    1140:	000010ed 	andeq	r1, r0, sp, ror #1
    1144:	000e7501 	andeq	r7, lr, r1, lsl #10
    1148:	0eb81000 	cdpeq	0, 11, cr1, cr8, cr0, {0}
    114c:	94110000 	ldrls	r0, [r1], #-0
    1150:	11000003 	tstne	r0, r3
    1154:	00000077 	andeq	r0, r0, r7, ror r0
    1158:	05040000 	streq	r0, [r4, #-0]
    115c:	1800000b 	stmdane	r0, {r0, r1, r3}
    1160:	000b1204 	andeq	r1, fp, r4, lsl #4
    1164:	94041800 	strls	r1, [r4], #-2048	; 0xfffff800
    1168:	04000000 	streq	r0, [r0], #-0
    116c:	00000e91 	muleq	r0, r1, lr
    1170:	00007716 	andeq	r7, r0, r6, lsl r7
    1174:	000eac00 	andeq	sl, lr, r0, lsl #24
    1178:	00881700 	addeq	r1, r8, r0, lsl #14
    117c:	00010000 	andeq	r0, r1, r0
    1180:	0e860418 	mcreq	4, 4, r0, cr6, cr8, {0}
    1184:	04210000 	strteq	r0, [r1], #-0
    1188:	00000077 	andeq	r0, r0, r7, ror r0
    118c:	0b050418 	bleq	1421f4 <__bss_end+0x137f88>
    1190:	8c1a0000 	ldchi	0, cr0, [sl], {-0}
    1194:	0b000008 	bleq	11bc <shift+0x11bc>
    1198:	0b051673 	bleq	146b6c <__bss_end+0x13c900>
    119c:	72160000 	andsvc	r0, r6, #0
    11a0:	da000003 	ble	11b4 <shift+0x11b4>
    11a4:	1700000e 	strne	r0, [r0, -lr]
    11a8:	00000088 	andeq	r0, r0, r8, lsl #1
    11ac:	8f280004 	svchi	0x00280004
    11b0:	01000009 	tsteq	r0, r9
    11b4:	0eca0d12 	mcreq	13, 6, r0, cr10, cr2, {0}
    11b8:	03050000 	movweq	r0, #20480	; 0x5000
    11bc:	0000a248 	andeq	sl, r0, r8, asr #4
    11c0:	00127e29 	andseq	r7, r2, r9, lsr #28
    11c4:	051a0100 	ldreq	r0, [sl, #-256]	; 0xffffff00
    11c8:	00000056 	andeq	r0, r0, r6, asr r0
    11cc:	0000822c 	andeq	r8, r0, ip, lsr #4
    11d0:	0000010c 	andeq	r0, r0, ip, lsl #2
    11d4:	0f6b9c01 	svceq	0x006b9c01
    11d8:	532a0000 			; <UNDEFINED> instruction: 0x532a0000
    11dc:	0100000d 	tsteq	r0, sp
    11e0:	00560e1a 	subseq	r0, r6, sl, lsl lr
    11e4:	91020000 	mrsls	r0, (UNDEF: 2)
    11e8:	0d7b2a5c 	vldmdbeq	fp!, {s5-s96}
    11ec:	1a010000 	bne	411f4 <__bss_end+0x36f88>
    11f0:	000f6b1b 	andeq	r6, pc, fp, lsl fp	; <UNPREDICTABLE>
    11f4:	58910200 	ldmpl	r1, {r9}
    11f8:	0012832b 	andseq	r8, r2, fp, lsr #6
    11fc:	101c0100 	andsne	r0, ip, r0, lsl #2
    1200:	00000839 	andeq	r0, r0, r9, lsr r8
    1204:	2b689102 	blcs	1a25614 <__bss_end+0x1a1b3a8>
    1208:	0000138b 	andeq	r1, r0, fp, lsl #7
    120c:	770b2101 	strvc	r2, [fp, -r1, lsl #2]
    1210:	02000000 	andeq	r0, r0, #0
    1214:	6e2c7491 	mcrvs	4, 1, r7, cr12, cr1, {4}
    1218:	01006d75 	tsteq	r0, r5, ror sp
    121c:	00770b22 	rsbseq	r0, r7, r2, lsr #22
    1220:	91020000 	mrsls	r0, (UNDEF: 2)
    1224:	82a42d64 	adchi	r2, r4, #100, 26	; 0x1900
    1228:	007c0000 	rsbseq	r0, ip, r0
    122c:	6d2c0000 	stcvs	0, cr0, [ip, #-0]
    1230:	01006773 	tsteq	r0, r3, ror r7
    1234:	03720f2a 	cmneq	r2, #42, 30	; 0xa8
    1238:	91020000 	mrsls	r0, (UNDEF: 2)
    123c:	18000070 	stmdane	r0, {r4, r5, r6}
    1240:	000f7104 	andeq	r7, pc, r4, lsl #2
    1244:	43041800 	movwmi	r1, #18432	; 0x4800
    1248:	00000000 	andeq	r0, r0, r0
    124c:	00000cf5 	strdeq	r0, [r0], -r5
    1250:	04930004 	ldreq	r0, [r3], #4
    1254:	01040000 	mrseq	r0, (UNDEF: 4)
    1258:	000016e3 	andeq	r1, r0, r3, ror #13
    125c:	0014c604 	andseq	ip, r4, r4, lsl #12
    1260:	00155100 	andseq	r5, r5, r0, lsl #2
    1264:	00833800 	addeq	r3, r3, r0, lsl #16
    1268:	00045c00 	andeq	r5, r4, r0, lsl #24
    126c:	0004af00 	andeq	sl, r4, r0, lsl #30
    1270:	08010200 	stmdaeq	r1, {r9}
    1274:	000010b9 	strheq	r1, [r0], -r9
    1278:	00002503 	andeq	r2, r0, r3, lsl #10
    127c:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1280:	00000e37 	andeq	r0, r0, r7, lsr lr
    1284:	69050404 	stmdbvs	r5, {r2, sl}
    1288:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    128c:	10b00801 	adcsne	r0, r0, r1, lsl #16
    1290:	02020000 	andeq	r0, r2, #0
    1294:	00126b07 	andseq	r6, r2, r7, lsl #22
    1298:	06ea0500 	strbteq	r0, [sl], r0, lsl #10
    129c:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
    12a0:	00005e07 	andeq	r5, r0, r7, lsl #28
    12a4:	004d0300 	subeq	r0, sp, r0, lsl #6
    12a8:	04020000 	streq	r0, [r2], #-0
    12ac:	0020f707 	eoreq	pc, r0, r7, lsl #14
    12b0:	136b0600 	cmnne	fp, #0, 12
    12b4:	02080000 	andeq	r0, r8, #0
    12b8:	008b0806 	addeq	r0, fp, r6, lsl #16
    12bc:	72070000 	andvc	r0, r7, #0
    12c0:	08020030 	stmdaeq	r2, {r4, r5}
    12c4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12c8:	72070000 	andvc	r0, r7, #0
    12cc:	09020031 	stmdbeq	r2, {r0, r4, r5}
    12d0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12d4:	08000400 	stmdaeq	r0, {sl}
    12d8:	00001611 	andeq	r1, r0, r1, lsl r6
    12dc:	00380405 	eorseq	r0, r8, r5, lsl #8
    12e0:	0d020000 	stceq	0, cr0, [r2, #-0]
    12e4:	0000a90c 	andeq	sl, r0, ip, lsl #18
    12e8:	4b4f0900 	blmi	13c36f0 <__bss_end+0x13b9484>
    12ec:	060a0000 	streq	r0, [sl], -r0
    12f0:	01000014 	tsteq	r0, r4, lsl r0
    12f4:	0eee0800 	cdpeq	8, 14, cr0, cr14, cr0, {0}
    12f8:	04050000 	streq	r0, [r5], #-0
    12fc:	00000038 	andeq	r0, r0, r8, lsr r0
    1300:	e00c1e02 	and	r1, ip, r2, lsl #28
    1304:	0a000000 	beq	130c <shift+0x130c>
    1308:	000006e2 	andeq	r0, r0, r2, ror #13
    130c:	09240a00 	stmdbeq	r4!, {r9, fp}
    1310:	0a010000 	beq	41318 <__bss_end+0x370ac>
    1314:	00000f10 	andeq	r0, r0, r0, lsl pc
    1318:	10cc0a02 	sbcne	r0, ip, r2, lsl #20
    131c:	0a030000 	beq	c1324 <__bss_end+0xb70b8>
    1320:	00000907 	andeq	r0, r0, r7, lsl #18
    1324:	0e270a04 	vmuleq.f32	s0, s14, s8
    1328:	00050000 	andeq	r0, r5, r0
    132c:	000ed608 	andeq	sp, lr, r8, lsl #12
    1330:	38040500 	stmdacc	r4, {r8, sl}
    1334:	02000000 	andeq	r0, r0, #0
    1338:	011d0c3f 	tsteq	sp, pc, lsr ip
    133c:	4b0a0000 	blmi	281344 <__bss_end+0x2770d8>
    1340:	00000008 	andeq	r0, r0, r8
    1344:	00100a0a 	andseq	r0, r0, sl, lsl #20
    1348:	fb0a0100 	blx	281752 <__bss_end+0x2774e6>
    134c:	02000012 	andeq	r0, r0, #18
    1350:	000cfe0a 	andeq	pc, ip, sl, lsl #28
    1354:	160a0300 	strne	r0, [sl], -r0, lsl #6
    1358:	04000009 	streq	r0, [r0], #-9
    135c:	000a3c0a 	andeq	r3, sl, sl, lsl #24
    1360:	620a0500 	andvs	r0, sl, #0, 10
    1364:	06000007 	streq	r0, [r0], -r7
    1368:	16760800 	ldrbtne	r0, [r6], -r0, lsl #16
    136c:	04050000 	streq	r0, [r5], #-0
    1370:	00000038 	andeq	r0, r0, r8, lsr r0
    1374:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
    1378:	0a000001 	beq	1384 <shift+0x1384>
    137c:	000015b6 			; <UNDEFINED> instruction: 0x000015b6
    1380:	14630a00 	strbtne	r0, [r3], #-2560	; 0xfffff600
    1384:	0a010000 	beq	4138c <__bss_end+0x37120>
    1388:	000015da 	ldrdeq	r1, [r0], -sl
    138c:	14880a02 	strne	r0, [r8], #2562	; 0xa02
    1390:	00030000 	andeq	r0, r3, r0
    1394:	000c310b 	andeq	r3, ip, fp, lsl #2
    1398:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
    139c:	00000059 	andeq	r0, r0, r9, asr r0
    13a0:	9f4c0305 	svcls	0x004c0305
    13a4:	0f0b0000 	svceq	0x000b0000
    13a8:	03000010 	movweq	r0, #16
    13ac:	00591406 	subseq	r1, r9, r6, lsl #8
    13b0:	03050000 	movweq	r0, #20480	; 0x5000
    13b4:	00009f50 	andeq	r9, r0, r0, asr pc
    13b8:	000aa70b 	andeq	sl, sl, fp, lsl #14
    13bc:	1a070400 	bne	1c23c4 <__bss_end+0x1b8158>
    13c0:	00000059 	andeq	r0, r0, r9, asr r0
    13c4:	9f540305 	svcls	0x00540305
    13c8:	500b0000 	andpl	r0, fp, r0
    13cc:	0400000e 	streq	r0, [r0], #-14
    13d0:	00591a09 	subseq	r1, r9, r9, lsl #20
    13d4:	03050000 	movweq	r0, #20480	; 0x5000
    13d8:	00009f58 	andeq	r9, r0, r8, asr pc
    13dc:	000a6a0b 	andeq	r6, sl, fp, lsl #20
    13e0:	1a0b0400 	bne	2c23e8 <__bss_end+0x2b817c>
    13e4:	00000059 	andeq	r0, r0, r9, asr r0
    13e8:	9f5c0305 	svcls	0x005c0305
    13ec:	db0b0000 	blle	2c13f4 <__bss_end+0x2b7188>
    13f0:	0400000d 	streq	r0, [r0], #-13
    13f4:	00591a0d 	subseq	r1, r9, sp, lsl #20
    13f8:	03050000 	movweq	r0, #20480	; 0x5000
    13fc:	00009f60 	andeq	r9, r0, r0, ror #30
    1400:	0006c20b 	andeq	ip, r6, fp, lsl #4
    1404:	1a0f0400 	bne	3c240c <__bss_end+0x3b81a0>
    1408:	00000059 	andeq	r0, r0, r9, asr r0
    140c:	9f640305 	svcls	0x00640305
    1410:	e4080000 	str	r0, [r8], #-0
    1414:	0500000c 	streq	r0, [r0, #-12]
    1418:	00003804 	andeq	r3, r0, r4, lsl #16
    141c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
    1420:	000001eb 	andeq	r0, r0, fp, ror #3
    1424:	00064e0a 	andeq	r4, r6, sl, lsl #28
    1428:	380a0000 	stmdacc	sl, {}	; <UNPREDICTABLE>
    142c:	01000011 	tsteq	r0, r1, lsl r0
    1430:	0012f60a 	andseq	pc, r2, sl, lsl #12
    1434:	0c000200 	sfmeq	f0, 4, [r0], {-0}
    1438:	00000419 	andeq	r0, r0, r9, lsl r4
    143c:	0004e10d 	andeq	lr, r4, sp, lsl #2
    1440:	63049000 	movwvs	r9, #16384	; 0x4000
    1444:	00035e07 	andeq	r5, r3, r7, lsl #28
    1448:	062a0600 	strteq	r0, [sl], -r0, lsl #12
    144c:	04240000 	strteq	r0, [r4], #-0
    1450:	02781067 	rsbseq	r1, r8, #103	; 0x67
    1454:	670e0000 	strvs	r0, [lr, -r0]
    1458:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    145c:	035e1269 	cmpeq	lr, #-1879048186	; 0x90000006
    1460:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1464:	00000850 	andeq	r0, r0, r0, asr r8
    1468:	6e126b04 	vnmlsvs.f64	d6, d2, d4
    146c:	10000003 	andne	r0, r0, r3
    1470:	0006430e 	andeq	r4, r6, lr, lsl #6
    1474:	166d0400 	strbtne	r0, [sp], -r0, lsl #8
    1478:	0000004d 	andeq	r0, r0, sp, asr #32
    147c:	0e300e14 	mrceq	14, 1, r0, cr0, cr4, {0}
    1480:	70040000 	andvc	r0, r4, r0
    1484:	0003751c 	andeq	r7, r3, ip, lsl r5
    1488:	b30e1800 	movwlt	r1, #59392	; 0xe800
    148c:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    1490:	03751c72 	cmneq	r5, #29184	; 0x7200
    1494:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1498:	000004dc 	ldrdeq	r0, [r0], -ip
    149c:	751c7504 	ldrvc	r7, [ip, #-1284]	; 0xfffffafc
    14a0:	20000003 	andcs	r0, r0, r3
    14a4:	000ec50f 	andeq	ip, lr, pc, lsl #10
    14a8:	1c770400 	cfldrdne	mvd0, [r7], #-0
    14ac:	000011f6 	strdeq	r1, [r0], -r6
    14b0:	00000375 	andeq	r0, r0, r5, ror r3
    14b4:	0000026c 	andeq	r0, r0, ip, ror #4
    14b8:	00037510 	andeq	r7, r3, r0, lsl r5
    14bc:	037b1100 	cmneq	fp, #0, 2
    14c0:	00000000 	andeq	r0, r0, r0
    14c4:	0012eb06 	andseq	lr, r2, r6, lsl #22
    14c8:	7b041800 	blvc	1074d0 <__bss_end+0xfd264>
    14cc:	0002ad10 	andeq	sl, r2, r0, lsl sp
    14d0:	24670e00 	strbtcs	r0, [r7], #-3584	; 0xfffff200
    14d4:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
    14d8:	00035e12 	andeq	r5, r3, r2, lsl lr
    14dc:	360e0000 	strcc	r0, [lr], -r0
    14e0:	04000005 	streq	r0, [r0], #-5
    14e4:	037b1980 	cmneq	fp, #128, 18	; 0x200000
    14e8:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    14ec:	00000a43 	andeq	r0, r0, r3, asr #20
    14f0:	86218204 	strthi	r8, [r1], -r4, lsl #4
    14f4:	14000003 	strne	r0, [r0], #-3
    14f8:	02780300 	rsbseq	r0, r8, #0, 6
    14fc:	8f120000 	svchi	0x00120000
    1500:	04000004 	streq	r0, [r0], #-4
    1504:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
    1508:	7a120000 	bvc	481510 <__bss_end+0x4772a4>
    150c:	04000008 	streq	r0, [r0], #-8
    1510:	00591f88 	subseq	r1, r9, r8, lsl #31
    1514:	620e0000 	andvs	r0, lr, #0
    1518:	0400000e 	streq	r0, [r0], #-14
    151c:	01fd178b 	mvnseq	r1, fp, lsl #15
    1520:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1524:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
    1528:	fd178e04 	ldc2	14, cr8, [r7, #-16]
    152c:	24000001 	strcs	r0, [r0], #-1
    1530:	000bb50e 	andeq	fp, fp, lr, lsl #10
    1534:	178f0400 	strne	r0, [pc, r0, lsl #8]
    1538:	000001fd 	strdeq	r0, [r0], -sp
    153c:	099e0e48 	ldmibeq	lr, {r3, r6, r9, sl, fp}
    1540:	90040000 	andls	r0, r4, r0
    1544:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    1548:	e1136c00 	tst	r3, r0, lsl #24
    154c:	04000004 	streq	r0, [r0], #-4
    1550:	0d9e0993 	vldreq.16	s0, [lr, #294]	; 0x126	; <UNPREDICTABLE>
    1554:	03970000 	orrseq	r0, r7, #0
    1558:	17010000 	strne	r0, [r1, -r0]
    155c:	1d000003 	stcne	0, cr0, [r0, #-12]
    1560:	10000003 	andne	r0, r0, r3
    1564:	00000397 	muleq	r0, r7, r3
    1568:	0eba1400 	cdpeq	4, 11, cr1, cr10, cr0, {0}
    156c:	96040000 	strls	r0, [r4], -r0
    1570:	0005170e 	andeq	r1, r5, lr, lsl #14
    1574:	03320100 	teqeq	r2, #0, 2
    1578:	03380000 	teqeq	r8, #0
    157c:	97100000 	ldrls	r0, [r0, -r0]
    1580:	00000003 	andeq	r0, r0, r3
    1584:	00084b15 	andeq	r4, r8, r5, lsl fp
    1588:	10990400 	addsne	r0, r9, r0, lsl #8
    158c:	00000cc9 	andeq	r0, r0, r9, asr #25
    1590:	0000039d 	muleq	r0, sp, r3
    1594:	00034d01 	andeq	r4, r3, r1, lsl #26
    1598:	03971000 	orrseq	r1, r7, #0
    159c:	7b110000 	blvc	4415a4 <__bss_end+0x437338>
    15a0:	11000003 	tstne	r0, r3
    15a4:	000001c6 	andeq	r0, r0, r6, asr #3
    15a8:	25160000 	ldrcs	r0, [r6, #-0]
    15ac:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
    15b0:	17000003 	strne	r0, [r0, -r3]
    15b4:	0000005e 	andeq	r0, r0, lr, asr r0
    15b8:	0102000f 	tsteq	r2, pc
    15bc:	000b5002 	andeq	r5, fp, r2
    15c0:	fd041800 	stc2	8, cr1, [r4, #-0]
    15c4:	18000001 	stmdane	r0, {r0}
    15c8:	00002c04 	andeq	r2, r0, r4, lsl #24
    15cc:	11cb0c00 	bicne	r0, fp, r0, lsl #24
    15d0:	04180000 	ldreq	r0, [r8], #-0
    15d4:	00000381 	andeq	r0, r0, r1, lsl #7
    15d8:	0002ad16 	andeq	sl, r2, r6, lsl sp
    15dc:	00039700 	andeq	r9, r3, r0, lsl #14
    15e0:	18001900 	stmdane	r0, {r8, fp, ip}
    15e4:	0001f004 	andeq	pc, r1, r4
    15e8:	eb041800 	bl	1075f0 <__bss_end+0xfd384>
    15ec:	1a000001 	bne	15f8 <shift+0x15f8>
    15f0:	00000eae 	andeq	r0, r0, lr, lsr #29
    15f4:	f0149c04 			; <UNDEFINED> instruction: 0xf0149c04
    15f8:	0b000001 	bleq	1604 <shift+0x1604>
    15fc:	00000658 	andeq	r0, r0, r8, asr r6
    1600:	59140405 	ldmdbpl	r4, {r0, r2, sl}
    1604:	05000000 	streq	r0, [r0, #-0]
    1608:	009f6803 	addseq	r6, pc, r3, lsl #16
    160c:	0f160b00 	svceq	0x00160b00
    1610:	07050000 	streq	r0, [r5, -r0]
    1614:	00005914 	andeq	r5, r0, r4, lsl r9
    1618:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
    161c:	0b00009f 	bleq	18a0 <shift+0x18a0>
    1620:	00000504 	andeq	r0, r0, r4, lsl #10
    1624:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
    1628:	05000000 	streq	r0, [r0, #-0]
    162c:	009f7003 	addseq	r7, pc, r3
    1630:	07670800 	strbeq	r0, [r7, -r0, lsl #16]!
    1634:	04050000 	streq	r0, [r5], #-0
    1638:	00000038 	andeq	r0, r0, r8, lsr r0
    163c:	1c0c0d05 	stcne	13, cr0, [ip], {5}
    1640:	09000004 	stmdbeq	r0, {r2}
    1644:	0077654e 	rsbseq	r6, r7, lr, asr #10
    1648:	092e0a00 	stmdbeq	lr!, {r9, fp}
    164c:	0a010000 	beq	41654 <__bss_end+0x373e8>
    1650:	000004fc 	strdeq	r0, [r0], -ip
    1654:	07800a02 	streq	r0, [r0, r2, lsl #20]
    1658:	0a030000 	beq	c1660 <__bss_end+0xb73f4>
    165c:	000010be 	strheq	r1, [r0], -lr
    1660:	04d50a04 	ldrbeq	r0, [r5], #2564	; 0xa04
    1664:	00050000 	andeq	r0, r5, r0
    1668:	00067106 	andeq	r7, r6, r6, lsl #2
    166c:	1b051000 	blne	145674 <__bss_end+0x13b408>
    1670:	00045b08 	andeq	r5, r4, r8, lsl #22
    1674:	726c0700 	rsbvc	r0, ip, #0, 14
    1678:	131d0500 	tstne	sp, #0, 10
    167c:	0000045b 	andeq	r0, r0, fp, asr r4
    1680:	70730700 	rsbsvc	r0, r3, r0, lsl #14
    1684:	131e0500 	tstne	lr, #0, 10
    1688:	0000045b 	andeq	r0, r0, fp, asr r4
    168c:	63700704 	cmnvs	r0, #4, 14	; 0x100000
    1690:	131f0500 	tstne	pc, #0, 10
    1694:	0000045b 	andeq	r0, r0, fp, asr r4
    1698:	0ed00e08 	cdpeq	14, 13, cr0, cr0, cr8, {0}
    169c:	20050000 	andcs	r0, r5, r0
    16a0:	00045b13 	andeq	r5, r4, r3, lsl fp
    16a4:	02000c00 	andeq	r0, r0, #0, 24
    16a8:	20f20704 	rscscs	r0, r2, r4, lsl #14
    16ac:	fa060000 	blx	1816b4 <__bss_end+0x177448>
    16b0:	70000008 	andvc	r0, r0, r8
    16b4:	f2082805 	vadd.i8	d2, d8, d5
    16b8:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    16bc:	000007fa 	strdeq	r0, [r0], -sl
    16c0:	1c122a05 			; <UNDEFINED> instruction: 0x1c122a05
    16c4:	00000004 	andeq	r0, r0, r4
    16c8:	64697007 	strbtvs	r7, [r9], #-7
    16cc:	122b0500 	eorne	r0, fp, #0, 10
    16d0:	0000005e 	andeq	r0, r0, lr, asr r0
    16d4:	1e430e10 	mcrne	14, 2, r0, cr3, cr0, {0}
    16d8:	2c050000 	stccs	0, cr0, [r5], {-0}
    16dc:	0003e511 	andeq	lr, r3, r1, lsl r5
    16e0:	a20e1400 	andge	r1, lr, #0, 8
    16e4:	05000010 	streq	r0, [r0, #-16]
    16e8:	005e122d 	subseq	r1, lr, sp, lsr #4
    16ec:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    16f0:	000003a9 	andeq	r0, r0, r9, lsr #7
    16f4:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
    16f8:	1c000000 	stcne	0, cr0, [r0], {-0}
    16fc:	000f030e 	andeq	r0, pc, lr, lsl #6
    1700:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; 1708 <shift+0x1708>
    1704:	000004f2 	strdeq	r0, [r0], -r2
    1708:	04850e20 	streq	r0, [r5], #3616	; 0xe20
    170c:	30050000 	andcc	r0, r5, r0
    1710:	00003809 	andeq	r3, r0, r9, lsl #16
    1714:	0f0e6000 	svceq	0x000e6000
    1718:	0500000b 	streq	r0, [r0, #-11]
    171c:	004d0e31 	subeq	r0, sp, r1, lsr lr
    1720:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    1724:	00000d72 	andeq	r0, r0, r2, ror sp
    1728:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
    172c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    1730:	000d690e 	andeq	r6, sp, lr, lsl #18
    1734:	0e340500 	cfabs32eq	mvfx0, mvfx4
    1738:	0000004d 	andeq	r0, r0, sp, asr #32
    173c:	9d16006c 	ldcls	0, cr0, [r6, #-432]	; 0xfffffe50
    1740:	02000003 	andeq	r0, r0, #3
    1744:	17000005 	strne	r0, [r0, -r5]
    1748:	0000005e 	andeq	r0, r0, lr, asr r0
    174c:	ed0b000f 	stc	0, cr0, [fp, #-60]	; 0xffffffc4
    1750:	06000004 	streq	r0, [r0], -r4
    1754:	0059140a 	subseq	r1, r9, sl, lsl #8
    1758:	03050000 	movweq	r0, #20480	; 0x5000
    175c:	00009f74 	andeq	r9, r0, r4, ror pc
    1760:	000afa08 	andeq	pc, sl, r8, lsl #20
    1764:	38040500 	stmdacc	r4, {r8, sl}
    1768:	06000000 	streq	r0, [r0], -r0
    176c:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
    1770:	0a0a0000 	beq	281778 <__bss_end+0x27750c>
    1774:	00000013 	andeq	r0, r0, r3, lsl r0
    1778:	00116d0a 	andseq	r6, r1, sl, lsl #26
    177c:	03000100 	movweq	r0, #256	; 0x100
    1780:	00000514 	andeq	r0, r0, r4, lsl r5
    1784:	00152d08 	andseq	r2, r5, r8, lsl #26
    1788:	38040500 	stmdacc	r4, {r8, sl}
    178c:	06000000 	streq	r0, [r0], -r0
    1790:	05570c14 	ldrbeq	r0, [r7, #-3092]	; 0xfffff3ec
    1794:	9b0a0000 	blls	28179c <__bss_end+0x277530>
    1798:	00000013 	andeq	r0, r0, r3, lsl r0
    179c:	0015cc0a 	andseq	ip, r5, sl, lsl #24
    17a0:	03000100 	movweq	r0, #256	; 0x100
    17a4:	00000538 	andeq	r0, r0, r8, lsr r5
    17a8:	0007df06 	andeq	sp, r7, r6, lsl #30
    17ac:	1b060c00 	blne	1847b4 <__bss_end+0x17a548>
    17b0:	00059108 	andeq	r9, r5, r8, lsl #2
    17b4:	058a0e00 	streq	r0, [sl, #3584]	; 0xe00
    17b8:	1d060000 	stcne	0, cr0, [r6, #-0]
    17bc:	00059119 	andeq	r9, r5, r9, lsl r1
    17c0:	dc0e0000 	stcle	0, cr0, [lr], {-0}
    17c4:	06000004 	streq	r0, [r0], -r4
    17c8:	0591191e 	ldreq	r1, [r1, #2334]	; 0x91e
    17cc:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    17d0:	00000b2a 	andeq	r0, r0, sl, lsr #22
    17d4:	97131f06 	ldrls	r1, [r3, -r6, lsl #30]
    17d8:	08000005 	stmdaeq	r0, {r0, r2}
    17dc:	5c041800 	stcpl	8, cr1, [r4], {-0}
    17e0:	18000005 	stmdane	r0, {r0, r2}
    17e4:	00046204 	andeq	r6, r4, r4, lsl #4
    17e8:	0e710d00 	cdpeq	13, 7, cr0, cr1, cr0, {0}
    17ec:	06140000 	ldreq	r0, [r4], -r0
    17f0:	081f0722 	ldmdaeq	pc, {r1, r5, r8, r9, sl}	; <UNPREDICTABLE>
    17f4:	3f0e0000 	svccc	0x000e0000
    17f8:	0600000c 	streq	r0, [r0], -ip
    17fc:	004d1226 	subeq	r1, sp, r6, lsr #4
    1800:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1804:	00000bd2 	ldrdeq	r0, [r0], -r2
    1808:	911d2906 	tstls	sp, r6, lsl #18
    180c:	04000005 	streq	r0, [r0], #-5
    1810:	0007880e 	andeq	r8, r7, lr, lsl #16
    1814:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    1818:	00000591 	muleq	r0, r1, r5
    181c:	0cf41b08 	vldmiaeq	r4!, {d17-d20}
    1820:	2f060000 	svccs	0x00060000
    1824:	0007bc0e 	andeq	fp, r7, lr, lsl #24
    1828:	0005e500 	andeq	lr, r5, r0, lsl #10
    182c:	0005f000 	andeq	pc, r5, r0
    1830:	08241000 	stmdaeq	r4!, {ip}
    1834:	91110000 	tstls	r1, r0
    1838:	00000005 	andeq	r0, r0, r5
    183c:	0009371c 	andeq	r3, r9, ip, lsl r7
    1840:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    1844:	000008d1 	ldrdeq	r0, [r0], -r1
    1848:	0000036e 	andeq	r0, r0, lr, ror #6
    184c:	00000608 	andeq	r0, r0, r8, lsl #12
    1850:	00000613 	andeq	r0, r0, r3, lsl r6
    1854:	00082410 	andeq	r2, r8, r0, lsl r4
    1858:	05971100 	ldreq	r1, [r7, #256]	; 0x100
    185c:	13000000 	movwne	r0, #0
    1860:	00001119 	andeq	r1, r0, r9, lsl r1
    1864:	d51d3506 	ldrle	r3, [sp, #-1286]	; 0xfffffafa
    1868:	9100000a 	tstls	r0, sl
    186c:	02000005 	andeq	r0, r0, #5
    1870:	0000062c 	andeq	r0, r0, ip, lsr #12
    1874:	00000632 	andeq	r0, r0, r2, lsr r6
    1878:	00082410 	andeq	r2, r8, r0, lsl r4
    187c:	73130000 	tstvc	r3, #0
    1880:	06000007 	streq	r0, [r0], -r7
    1884:	0d041d37 	stceq	13, cr1, [r4, #-220]	; 0xffffff24
    1888:	05910000 	ldreq	r0, [r1]
    188c:	4b020000 	blmi	81894 <__bss_end+0x77628>
    1890:	51000006 	tstpl	r0, r6
    1894:	10000006 	andne	r0, r0, r6
    1898:	00000824 	andeq	r0, r0, r4, lsr #16
    189c:	0be51d00 	bleq	ff948ca4 <__bss_end+0xff93ea38>
    18a0:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    18a4:	00083d31 	andeq	r3, r8, r1, lsr sp
    18a8:	13020c00 	movwne	r0, #11264	; 0x2c00
    18ac:	00000e71 	andeq	r0, r0, r1, ror lr
    18b0:	46093c06 	strmi	r3, [r9], -r6, lsl #24
    18b4:	24000009 	strcs	r0, [r0], #-9
    18b8:	01000008 	tsteq	r0, r8
    18bc:	00000678 	andeq	r0, r0, r8, ror r6
    18c0:	0000067e 	andeq	r0, r0, lr, ror r6
    18c4:	00082410 	andeq	r2, r8, r0, lsl r4
    18c8:	0c130000 	ldceq	0, cr0, [r3], {-0}
    18cc:	06000008 	streq	r0, [r0], -r8
    18d0:	055f123f 	ldrbeq	r1, [pc, #-575]	; 1699 <shift+0x1699>
    18d4:	004d0000 	subeq	r0, sp, r0
    18d8:	97010000 	strls	r0, [r1, -r0]
    18dc:	ac000006 	stcge	0, cr0, [r0], {6}
    18e0:	10000006 	andne	r0, r0, r6
    18e4:	00000824 	andeq	r0, r0, r4, lsr #16
    18e8:	00084611 	andeq	r4, r8, r1, lsl r6
    18ec:	005e1100 	subseq	r1, lr, r0, lsl #2
    18f0:	6e110000 	cdpvs	0, 1, cr0, cr1, cr0, {0}
    18f4:	00000003 	andeq	r0, r0, r3
    18f8:	00114314 	andseq	r4, r1, r4, lsl r3
    18fc:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    1900:	0000067e 	andeq	r0, r0, lr, ror r6
    1904:	0006c101 	andeq	ip, r6, r1, lsl #2
    1908:	0006c700 	andeq	ip, r6, r0, lsl #14
    190c:	08241000 	stmdaeq	r4!, {ip}
    1910:	13000000 	movwne	r0, #0
    1914:	00000541 	andeq	r0, r0, r1, asr #10
    1918:	fc174506 	ldc2	5, cr4, [r7], {6}
    191c:	97000005 	strls	r0, [r0, -r5]
    1920:	01000005 	tsteq	r0, r5
    1924:	000006e0 	andeq	r0, r0, r0, ror #13
    1928:	000006e6 	andeq	r0, r0, r6, ror #13
    192c:	00084c10 	andeq	r4, r8, r0, lsl ip
    1930:	21130000 	tstcs	r3, r0
    1934:	0600000f 	streq	r0, [r0], -pc
    1938:	03bf1748 			; <UNDEFINED> instruction: 0x03bf1748
    193c:	05970000 	ldreq	r0, [r7]
    1940:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    1944:	0a000006 	beq	1964 <shift+0x1964>
    1948:	10000007 	andne	r0, r0, r7
    194c:	0000084c 	andeq	r0, r0, ip, asr #16
    1950:	00004d11 	andeq	r4, r0, r1, lsl sp
    1954:	cc140000 	ldcgt	0, cr0, [r4], {-0}
    1958:	06000006 	streq	r0, [r0], -r6
    195c:	0bf30e4b 	bleq	ffcc5290 <__bss_end+0xffcbb024>
    1960:	1f010000 	svcne	0x00010000
    1964:	25000007 	strcs	r0, [r0, #-7]
    1968:	10000007 	andne	r0, r0, r7
    196c:	00000824 	andeq	r0, r0, r4, lsr #16
    1970:	09371300 	ldmdbeq	r7!, {r8, r9, ip}
    1974:	4d060000 	stcmi	0, cr0, [r6, #-0]
    1978:	000db30e 	andeq	fp, sp, lr, lsl #6
    197c:	00036e00 	andeq	r6, r3, r0, lsl #28
    1980:	073e0100 	ldreq	r0, [lr, -r0, lsl #2]!
    1984:	07490000 	strbeq	r0, [r9, -r0]
    1988:	24100000 	ldrcs	r0, [r0], #-0
    198c:	11000008 	tstne	r0, r8
    1990:	0000004d 	andeq	r0, r0, sp, asr #32
    1994:	04c11300 	strbeq	r1, [r1], #768	; 0x300
    1998:	50060000 	andpl	r0, r6, r0
    199c:	0003ec12 	andeq	lr, r3, r2, lsl ip
    19a0:	00004d00 	andeq	r4, r0, r0, lsl #26
    19a4:	07620100 	strbeq	r0, [r2, -r0, lsl #2]!
    19a8:	076d0000 	strbeq	r0, [sp, -r0]!
    19ac:	24100000 	ldrcs	r0, [r0], #-0
    19b0:	11000008 	tstne	r0, r8
    19b4:	0000039d 	muleq	r0, sp, r3
    19b8:	041f1300 	ldreq	r1, [pc], #-768	; 19c0 <shift+0x19c0>
    19bc:	53060000 	movwpl	r0, #24576	; 0x6000
    19c0:	0011990e 	andseq	r9, r1, lr, lsl #18
    19c4:	00036e00 	andeq	r6, r3, r0, lsl #28
    19c8:	07860100 	streq	r0, [r6, r0, lsl #2]
    19cc:	07910000 	ldreq	r0, [r1, r0]
    19d0:	24100000 	ldrcs	r0, [r0], #-0
    19d4:	11000008 	tstne	r0, r8
    19d8:	0000004d 	andeq	r0, r0, sp, asr #32
    19dc:	049b1400 	ldreq	r1, [fp], #1024	; 0x400
    19e0:	56060000 	strpl	r0, [r6], -r0
    19e4:	00101b0e 	andseq	r1, r0, lr, lsl #22
    19e8:	07a60100 	streq	r0, [r6, r0, lsl #2]!
    19ec:	07c50000 	strbeq	r0, [r5, r0]
    19f0:	24100000 	ldrcs	r0, [r0], #-0
    19f4:	11000008 	tstne	r0, r8
    19f8:	000000a9 	andeq	r0, r0, r9, lsr #1
    19fc:	00004d11 	andeq	r4, r0, r1, lsl sp
    1a00:	004d1100 	subeq	r1, sp, r0, lsl #2
    1a04:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1a08:	11000000 	mrsne	r0, (UNDEF: 0)
    1a0c:	00000852 	andeq	r0, r0, r2, asr r8
    1a10:	12261400 	eorne	r1, r6, #0, 8
    1a14:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    1a18:	00131f0e 	andseq	r1, r3, lr, lsl #30
    1a1c:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    1a20:	07f90000 	ldrbeq	r0, [r9, r0]!
    1a24:	24100000 	ldrcs	r0, [r0], #-0
    1a28:	11000008 	tstne	r0, r8
    1a2c:	000000e0 	andeq	r0, r0, r0, ror #1
    1a30:	00004d11 	andeq	r4, r0, r1, lsl sp
    1a34:	004d1100 	subeq	r1, sp, r0, lsl #2
    1a38:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1a3c:	11000000 	mrsne	r0, (UNDEF: 0)
    1a40:	00000852 	andeq	r0, r0, r2, asr r8
    1a44:	04ae1500 	strteq	r1, [lr], #1280	; 0x500
    1a48:	5b060000 	blpl	181a50 <__bss_end+0x1777e4>
    1a4c:	000b550e 	andeq	r5, fp, lr, lsl #10
    1a50:	00036e00 	andeq	r6, r3, r0, lsl #28
    1a54:	080e0100 	stmdaeq	lr, {r8}
    1a58:	24100000 	ldrcs	r0, [r0], #-0
    1a5c:	11000008 	tstne	r0, r8
    1a60:	00000514 	andeq	r0, r0, r4, lsl r5
    1a64:	00085811 	andeq	r5, r8, r1, lsl r8
    1a68:	03000000 	movweq	r0, #0
    1a6c:	0000059d 	muleq	r0, sp, r5
    1a70:	059d0418 	ldreq	r0, [sp, #1048]	; 0x418
    1a74:	911e0000 	tstls	lr, r0
    1a78:	37000005 	strcc	r0, [r0, -r5]
    1a7c:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    1a80:	10000008 	andne	r0, r0, r8
    1a84:	00000824 	andeq	r0, r0, r4, lsr #16
    1a88:	059d1f00 	ldreq	r1, [sp, #3840]	; 0xf00
    1a8c:	082a0000 	stmdaeq	sl!, {}	; <UNPREDICTABLE>
    1a90:	04180000 	ldreq	r0, [r8], #-0
    1a94:	0000003f 	andeq	r0, r0, pc, lsr r0
    1a98:	081f0418 	ldmdaeq	pc, {r3, r4, sl}	; <UNPREDICTABLE>
    1a9c:	04200000 	strteq	r0, [r0], #-0
    1aa0:	00000065 	andeq	r0, r0, r5, rrx
    1aa4:	881a0421 	ldmdahi	sl, {r0, r5, sl}
    1aa8:	06000012 			; <UNDEFINED> instruction: 0x06000012
    1aac:	059d195e 	ldreq	r1, [sp, #2398]	; 0x95e
    1ab0:	010b0000 	mrseq	r0, (UNDEF: 11)
    1ab4:	07000013 	smladeq	r0, r3, r0, r0
    1ab8:	087f1104 	ldmdaeq	pc!, {r2, r8, ip}^	; <UNPREDICTABLE>
    1abc:	03050000 	movweq	r0, #20480	; 0x5000
    1ac0:	00009f78 	andeq	r9, r0, r8, ror pc
    1ac4:	c1040402 	tstgt	r4, r2, lsl #8
    1ac8:	0300001e 	movweq	r0, #30
    1acc:	00000878 	andeq	r0, r0, r8, ror r8
    1ad0:	00002c16 	andeq	r2, r0, r6, lsl ip
    1ad4:	00089400 	andeq	r9, r8, r0, lsl #8
    1ad8:	005e1700 	subseq	r1, lr, r0, lsl #14
    1adc:	00090000 	andeq	r0, r9, r0
    1ae0:	00088403 	andeq	r8, r8, r3, lsl #8
    1ae4:	14522200 	ldrbne	r2, [r2], #-512	; 0xfffffe00
    1ae8:	a4010000 	strge	r0, [r1], #-0
    1aec:	0008940c 	andeq	r9, r8, ip, lsl #8
    1af0:	7c030500 	cfstr32vc	mvfx0, [r3], {-0}
    1af4:	2300009f 	movwcs	r0, #159	; 0x9f
    1af8:	000013b4 			; <UNDEFINED> instruction: 0x000013b4
    1afc:	210aa601 	tstcs	sl, r1, lsl #12
    1b00:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1b04:	e4000000 	str	r0, [r0], #-0
    1b08:	b0000086 	andlt	r0, r0, r6, lsl #1
    1b0c:	01000000 	mrseq	r0, (UNDEF: 0)
    1b10:	0009099c 	muleq	r9, ip, r9
    1b14:	24672400 	strbtcs	r2, [r7], #-1024	; 0xfffffc00
    1b18:	a6010000 	strge	r0, [r1], -r0
    1b1c:	00037b1b 	andeq	r7, r3, fp, lsl fp
    1b20:	ac910300 	ldcge	3, cr0, [r1], {0}
    1b24:	15ad247f 	strne	r2, [sp, #1151]!	; 0x47f
    1b28:	a6010000 	strge	r0, [r1], -r0
    1b2c:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1b30:	a8910300 	ldmge	r1, {r8, r9}
    1b34:	1509227f 	strne	r2, [r9, #-639]	; 0xfffffd81
    1b38:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    1b3c:	0009090a 	andeq	r0, r9, sl, lsl #18
    1b40:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1b44:	13af227f 			; <UNDEFINED> instruction: 0x13af227f
    1b48:	ac010000 	stcge	0, cr0, [r1], {-0}
    1b4c:	00003809 	andeq	r3, r0, r9, lsl #16
    1b50:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b54:	00251600 	eoreq	r1, r5, r0, lsl #12
    1b58:	09190000 	ldmdbeq	r9, {}	; <UNPREDICTABLE>
    1b5c:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1b60:	3f000000 	svccc	0x00000000
    1b64:	158c2500 	strne	r2, [ip, #1280]	; 0x500
    1b68:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1b6c:	0015f10a 	andseq	pc, r5, sl, lsl #2
    1b70:	00004d00 	andeq	r4, r0, r0, lsl #26
    1b74:	0086a800 	addeq	sl, r6, r0, lsl #16
    1b78:	00003c00 	andeq	r3, r0, r0, lsl #24
    1b7c:	569c0100 	ldrpl	r0, [ip], r0, lsl #2
    1b80:	26000009 	strcs	r0, [r0], -r9
    1b84:	00716572 	rsbseq	r6, r1, r2, ror r5
    1b88:	57209a01 	strpl	r9, [r0, -r1, lsl #20]!
    1b8c:	02000005 	andeq	r0, r0, #5
    1b90:	16227491 			; <UNDEFINED> instruction: 0x16227491
    1b94:	01000015 	tsteq	r0, r5, lsl r0
    1b98:	004d0e9b 	umaaleq	r0, sp, fp, lr
    1b9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba0:	a0270070 	eorge	r0, r7, r0, ror r0
    1ba4:	01000014 	tsteq	r0, r4, lsl r0
    1ba8:	13d0068f 	bicsne	r0, r0, #149946368	; 0x8f00000
    1bac:	866c0000 	strbthi	r0, [ip], -r0
    1bb0:	003c0000 	eorseq	r0, ip, r0
    1bb4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bb8:	0000098f 	andeq	r0, r0, pc, lsl #19
    1bbc:	00143e24 	andseq	r3, r4, r4, lsr #28
    1bc0:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1bc4:	0000004d 	andeq	r0, r0, sp, asr #32
    1bc8:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1bcc:	00716572 	rsbseq	r6, r1, r2, ror r5
    1bd0:	57209101 	strpl	r9, [r0, -r1, lsl #2]!
    1bd4:	02000005 	andeq	r0, r0, #5
    1bd8:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1bdc:	00001542 	andeq	r1, r0, r2, asr #10
    1be0:	6e0a8301 	cdpvs	3, 0, cr8, cr10, cr1, {0}
    1be4:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1be8:	30000000 	andcc	r0, r0, r0
    1bec:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1bf0:	01000000 	mrseq	r0, (UNDEF: 0)
    1bf4:	0009cc9c 	muleq	r9, ip, ip
    1bf8:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1bfc:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1c00:	00053320 	andeq	r3, r5, r0, lsr #6
    1c04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c08:	0013a822 	andseq	sl, r3, r2, lsr #16
    1c0c:	0e860100 	rmfeqs	f0, f6, f0
    1c10:	0000004d 	andeq	r0, r0, sp, asr #32
    1c14:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1c18:	00168f25 	andseq	r8, r6, r5, lsr #30
    1c1c:	0a770100 	beq	1dc2024 <__bss_end+0x1db7db8>
    1c20:	00001414 	andeq	r1, r0, r4, lsl r4
    1c24:	0000004d 	andeq	r0, r0, sp, asr #32
    1c28:	000085f4 	strdeq	r8, [r0], -r4
    1c2c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1c30:	0a099c01 	beq	268c3c <__bss_end+0x25e9d0>
    1c34:	72260000 	eorvc	r0, r6, #0
    1c38:	01007165 	tsteq	r0, r5, ror #2
    1c3c:	05332079 	ldreq	r2, [r3, #-121]!	; 0xffffff87
    1c40:	91020000 	mrsls	r0, (UNDEF: 2)
    1c44:	13a82274 			; <UNDEFINED> instruction: 0x13a82274
    1c48:	7a010000 	bvc	41c50 <__bss_end+0x379e4>
    1c4c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c50:	70910200 	addsvc	r0, r1, r0, lsl #4
    1c54:	14822500 	strne	r2, [r2], #1280	; 0x500
    1c58:	6b010000 	blvs	41c60 <__bss_end+0x379f4>
    1c5c:	0015c106 	andseq	ip, r5, r6, lsl #2
    1c60:	00036e00 	andeq	r6, r3, r0, lsl #28
    1c64:	0085a000 	addeq	sl, r5, r0
    1c68:	00005400 	andeq	r5, r0, r0, lsl #8
    1c6c:	559c0100 	ldrpl	r0, [ip, #256]	; 0x100
    1c70:	2400000a 	strcs	r0, [r0], #-10
    1c74:	00001516 	andeq	r1, r0, r6, lsl r5
    1c78:	4d156b01 	vldrmi	d6, [r5, #-4]
    1c7c:	02000000 	andeq	r0, r0, #0
    1c80:	69246c91 	stmdbvs	r4!, {r0, r4, r7, sl, fp, sp, lr}
    1c84:	0100000d 	tsteq	r0, sp
    1c88:	004d256b 	subeq	r2, sp, fp, ror #10
    1c8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c90:	16872268 	strne	r2, [r7], r8, ror #4
    1c94:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1c98:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c9c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ca0:	13e72500 	mvnne	r2, #0, 10
    1ca4:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1ca8:	00162812 	andseq	r2, r6, r2, lsl r8
    1cac:	00008b00 	andeq	r8, r0, r0, lsl #22
    1cb0:	00855000 	addeq	r5, r5, r0
    1cb4:	00005000 	andeq	r5, r0, r0
    1cb8:	b09c0100 	addslt	r0, ip, r0, lsl #2
    1cbc:	2400000a 	strcs	r0, [r0], #-10
    1cc0:	00001390 	muleq	r0, r0, r3
    1cc4:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1cc8:	02000000 	andeq	r0, r0, #0
    1ccc:	4b246c91 	blmi	91cf18 <__bss_end+0x912cac>
    1cd0:	01000015 	tsteq	r0, r5, lsl r0
    1cd4:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1cd8:	91020000 	mrsls	r0, (UNDEF: 2)
    1cdc:	0d692468 	cfstrdeq	mvd2, [r9, #-416]!	; 0xfffffe60
    1ce0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1ce4:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1ce8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1cec:	00168722 	andseq	r8, r6, r2, lsr #14
    1cf0:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1cf4:	0000008b 	andeq	r0, r0, fp, lsl #1
    1cf8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cfc:	00150f25 	andseq	r0, r5, r5, lsr #30
    1d00:	0a520100 	beq	1482108 <__bss_end+0x1477e9c>
    1d04:	000013ec 	andeq	r1, r0, ip, ror #7
    1d08:	0000004d 	andeq	r0, r0, sp, asr #32
    1d0c:	0000850c 	andeq	r8, r0, ip, lsl #10
    1d10:	00000044 	andeq	r0, r0, r4, asr #32
    1d14:	0afc9c01 	beq	fff28d20 <__bss_end+0xfff1eab4>
    1d18:	90240000 	eorls	r0, r4, r0
    1d1c:	01000013 	tsteq	r0, r3, lsl r0
    1d20:	004d1a52 	subeq	r1, sp, r2, asr sl
    1d24:	91020000 	mrsls	r0, (UNDEF: 2)
    1d28:	154b246c 	strbne	r2, [fp, #-1132]	; 0xfffffb94
    1d2c:	52010000 	andpl	r0, r1, #0
    1d30:	00004d29 	andeq	r4, r0, r9, lsr #26
    1d34:	68910200 	ldmvs	r1, {r9}
    1d38:	00165722 	andseq	r5, r6, r2, lsr #14
    1d3c:	0e540100 	rdfeqs	f0, f4, f0
    1d40:	0000004d 	andeq	r0, r0, sp, asr #32
    1d44:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d48:	00165125 	andseq	r5, r6, r5, lsr #2
    1d4c:	0a450100 	beq	1142154 <__bss_end+0x1137ee8>
    1d50:	00001633 	andeq	r1, r0, r3, lsr r6
    1d54:	0000004d 	andeq	r0, r0, sp, asr #32
    1d58:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
    1d5c:	00000050 	andeq	r0, r0, r0, asr r0
    1d60:	0b579c01 	bleq	15e8d6c <__bss_end+0x15deb00>
    1d64:	90240000 	eorls	r0, r4, r0
    1d68:	01000013 	tsteq	r0, r3, lsl r0
    1d6c:	004d1945 	subeq	r1, sp, r5, asr #18
    1d70:	91020000 	mrsls	r0, (UNDEF: 2)
    1d74:	14b2246c 	ldrtne	r2, [r2], #1132	; 0x46c
    1d78:	45010000 	strmi	r0, [r1, #-0]
    1d7c:	00011d30 	andeq	r1, r1, r0, lsr sp
    1d80:	68910200 	ldmvs	r1, {r9}
    1d84:	00157824 	andseq	r7, r5, r4, lsr #16
    1d88:	41450100 	mrsmi	r0, (UNDEF: 85)
    1d8c:	00000858 	andeq	r0, r0, r8, asr r8
    1d90:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d94:	00001687 	andeq	r1, r0, r7, lsl #13
    1d98:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    1d9c:	02000000 	andeq	r0, r0, #0
    1da0:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1da4:	00001395 	muleq	r0, r5, r3
    1da8:	bc063f01 	stclt	15, cr3, [r6], {1}
    1dac:	90000014 	andls	r0, r0, r4, lsl r0
    1db0:	2c000084 	stccs	0, cr0, [r0], {132}	; 0x84
    1db4:	01000000 	mrseq	r0, (UNDEF: 0)
    1db8:	000b819c 	muleq	fp, ip, r1
    1dbc:	13902400 	orrsne	r2, r0, #0, 8
    1dc0:	3f010000 	svccc	0x00010000
    1dc4:	00004d15 	andeq	r4, r0, r5, lsl sp
    1dc8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1dcc:	15a72500 	strne	r2, [r7, #1280]!	; 0x500
    1dd0:	32010000 	andcc	r0, r1, #0
    1dd4:	00157e0a 	andseq	r7, r5, sl, lsl #28
    1dd8:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ddc:	00844000 	addeq	r4, r4, r0
    1de0:	00005000 	andeq	r5, r0, r0
    1de4:	dc9c0100 	ldfles	f0, [ip], {0}
    1de8:	2400000b 	strcs	r0, [r0], #-11
    1dec:	00001390 	muleq	r0, r0, r3
    1df0:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    1df4:	02000000 	andeq	r0, r0, #0
    1df8:	63246c91 			; <UNDEFINED> instruction: 0x63246c91
    1dfc:	01000016 	tsteq	r0, r6, lsl r0
    1e00:	037b2b32 	cmneq	fp, #51200	; 0xc800
    1e04:	91020000 	mrsls	r0, (UNDEF: 2)
    1e08:	15b12468 	ldrne	r2, [r1, #1128]!	; 0x468
    1e0c:	32010000 	andcc	r0, r1, #0
    1e10:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1e14:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e18:	00162222 	andseq	r2, r6, r2, lsr #4
    1e1c:	0e340100 	rsfeqs	f0, f4, f0
    1e20:	0000004d 	andeq	r0, r0, sp, asr #32
    1e24:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e28:	0016b125 	andseq	fp, r6, r5, lsr #2
    1e2c:	0a250100 	beq	942234 <__bss_end+0x937fc8>
    1e30:	0000166a 	andeq	r1, r0, sl, ror #12
    1e34:	0000004d 	andeq	r0, r0, sp, asr #32
    1e38:	000083f0 	strdeq	r8, [r0], -r0
    1e3c:	00000050 	andeq	r0, r0, r0, asr r0
    1e40:	0c379c01 	ldceq	12, cr9, [r7], #-4
    1e44:	90240000 	eorls	r0, r4, r0
    1e48:	01000013 	tsteq	r0, r3, lsl r0
    1e4c:	004d1825 	subeq	r1, sp, r5, lsr #16
    1e50:	91020000 	mrsls	r0, (UNDEF: 2)
    1e54:	1663246c 	strbtne	r2, [r3], -ip, ror #8
    1e58:	25010000 	strcs	r0, [r1, #-0]
    1e5c:	000c3d2a 	andeq	r3, ip, sl, lsr #26
    1e60:	68910200 	ldmvs	r1, {r9}
    1e64:	0015b124 	andseq	fp, r5, r4, lsr #2
    1e68:	3b250100 	blcc	942270 <__bss_end+0x938004>
    1e6c:	0000004d 	andeq	r0, r0, sp, asr #32
    1e70:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1e74:	000013b9 			; <UNDEFINED> instruction: 0x000013b9
    1e78:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1e7c:	02000000 	andeq	r0, r0, #0
    1e80:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1e84:	00002504 	andeq	r2, r0, r4, lsl #10
    1e88:	0c370300 	ldceq	3, cr0, [r7], #-0
    1e8c:	1c250000 	stcne	0, cr0, [r5], #-0
    1e90:	01000015 	tsteq	r0, r5, lsl r0
    1e94:	16c70a19 			; <UNDEFINED> instruction: 0x16c70a19
    1e98:	004d0000 	subeq	r0, sp, r0
    1e9c:	83ac0000 			; <UNDEFINED> instruction: 0x83ac0000
    1ea0:	00440000 	subeq	r0, r4, r0
    1ea4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ea8:	00000c8e 	andeq	r0, r0, lr, lsl #25
    1eac:	0016a824 	andseq	sl, r6, r4, lsr #16
    1eb0:	1b190100 	blne	6422b8 <__bss_end+0x63804c>
    1eb4:	0000037b 	andeq	r0, r0, fp, ror r3
    1eb8:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1ebc:	0000165e 	andeq	r1, r0, lr, asr r6
    1ec0:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    1ec4:	02000001 	andeq	r0, r0, #1
    1ec8:	90226891 	mlals	r2, r1, r8, r6
    1ecc:	01000013 	tsteq	r0, r3, lsl r0
    1ed0:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1ed4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ed8:	32280074 	eorcc	r0, r8, #116	; 0x74
    1edc:	01000014 	tsteq	r0, r4, lsl r0
    1ee0:	13bf0614 			; <UNDEFINED> instruction: 0x13bf0614
    1ee4:	83900000 	orrshi	r0, r0, #0
    1ee8:	001c0000 	andseq	r0, ip, r0
    1eec:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ef0:	0016b627 	andseq	fp, r6, r7, lsr #12
    1ef4:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1ef8:	000013f8 	strdeq	r1, [r0], -r8
    1efc:	00008364 	andeq	r8, r0, r4, ror #6
    1f00:	0000002c 	andeq	r0, r0, ip, lsr #32
    1f04:	0cce9c01 	stcleq	12, cr9, [lr], {1}
    1f08:	0b240000 	bleq	901f10 <__bss_end+0x8f7ca4>
    1f0c:	01000014 	tsteq	r0, r4, lsl r0
    1f10:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1f14:	91020000 	mrsls	r0, (UNDEF: 2)
    1f18:	c0290074 	eorgt	r0, r9, r4, ror r0
    1f1c:	01000016 	tsteq	r0, r6, lsl r0
    1f20:	14fe0a04 	ldrbtne	r0, [lr], #2564	; 0xa04
    1f24:	004d0000 	subeq	r0, sp, r0
    1f28:	83380000 	teqhi	r8, #0
    1f2c:	002c0000 	eoreq	r0, ip, r0
    1f30:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f34:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1f38:	0e060100 	adfeqs	f0, f6, f0
    1f3c:	0000004d 	andeq	r0, r0, sp, asr #32
    1f40:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f44:	0006f900 	andeq	pc, r6, r0, lsl #18
    1f48:	3e000400 	cfcpyscc	mvf0, mvf0
    1f4c:	04000007 	streq	r0, [r0], #-7
    1f50:	0016e301 	andseq	lr, r6, r1, lsl #6
    1f54:	17c60400 	strbne	r0, [r6, r0, lsl #8]
    1f58:	15510000 	ldrbne	r0, [r1, #-0]
    1f5c:	87940000 	ldrhi	r0, [r4, r0]
    1f60:	0fdc0000 	svceq	0x00dc0000
    1f64:	07720000 	ldrbeq	r0, [r2, -r0]!
    1f68:	01020000 	mrseq	r0, (UNDEF: 2)
    1f6c:	02000013 	andeq	r0, r0, #19
    1f70:	003e1104 	eorseq	r1, lr, r4, lsl #2
    1f74:	03050000 	movweq	r0, #20480	; 0x5000
    1f78:	00009f88 	andeq	r9, r0, r8, lsl #31
    1f7c:	c1040403 	tstgt	r4, r3, lsl #8
    1f80:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    1f84:	00000037 	andeq	r0, r0, r7, lsr r0
    1f88:	00006705 	andeq	r6, r0, r5, lsl #14
    1f8c:	19060600 	stmdbne	r6, {r9, sl}
    1f90:	05010000 	streq	r0, [r1, #-0]
    1f94:	00007f10 	andeq	r7, r0, r0, lsl pc
    1f98:	31301100 	teqcc	r0, r0, lsl #2
    1f9c:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1fa0:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1fa4:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1fa8:	00004645 	andeq	r4, r0, r5, asr #12
    1fac:	01030107 	tsteq	r3, r7, lsl #2
    1fb0:	00000043 	andeq	r0, r0, r3, asr #32
    1fb4:	00009708 	andeq	r9, r0, r8, lsl #14
    1fb8:	00007f00 	andeq	r7, r0, r0, lsl #30
    1fbc:	00840900 	addeq	r0, r4, r0, lsl #18
    1fc0:	00100000 	andseq	r0, r0, r0
    1fc4:	00006f04 	andeq	r6, r0, r4, lsl #30
    1fc8:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1fcc:	000020f7 	strdeq	r2, [r0], -r7
    1fd0:	00008404 	andeq	r8, r0, r4, lsl #8
    1fd4:	08010300 	stmdaeq	r1, {r8, r9}
    1fd8:	000010b9 	strheq	r1, [r0], -r9
    1fdc:	00009004 	andeq	r9, r0, r4
    1fe0:	00480a00 	subeq	r0, r8, r0, lsl #20
    1fe4:	fa0b0000 	blx	2c1fec <__bss_end+0x2b7d80>
    1fe8:	01000018 	tsteq	r0, r8, lsl r0
    1fec:	187107fc 	ldmdane	r1!, {r2, r3, r4, r5, r6, r7, r8, r9, sl}^
    1ff0:	00370000 	eorseq	r0, r7, r0
    1ff4:	96600000 	strbtls	r0, [r0], -r0
    1ff8:	01100000 	tsteq	r0, r0
    1ffc:	9c010000 	stcls	0, cr0, [r1], {-0}
    2000:	0000011d 	andeq	r0, r0, sp, lsl r1
    2004:	0100730c 	tsteq	r0, ip, lsl #6
    2008:	011d18fc 			; <UNDEFINED> instruction: 0x011d18fc
    200c:	91020000 	mrsls	r0, (UNDEF: 2)
    2010:	65720d64 	ldrbvs	r0, [r2, #-3428]!	; 0xfffff29c
    2014:	fe01007a 	mcr2	0, 0, r0, cr1, cr10, {3}
    2018:	00003709 	andeq	r3, r0, r9, lsl #14
    201c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2020:	0019940e 	andseq	r9, r9, lr, lsl #8
    2024:	12fe0100 	rscsne	r0, lr, #0, 2
    2028:	00000037 	andeq	r0, r0, r7, lsr r0
    202c:	0f709102 	svceq	0x00709102
    2030:	000096a4 	andeq	r9, r0, r4, lsr #13
    2034:	000000a8 	andeq	r0, r0, r8, lsr #1
    2038:	00183810 	andseq	r3, r8, r0, lsl r8
    203c:	01030100 	mrseq	r0, (UNDEF: 19)
    2040:	0001230c 	andeq	r2, r1, ip, lsl #6
    2044:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2048:	0096bc0f 	addseq	fp, r6, pc, lsl #24
    204c:	00008000 	andeq	r8, r0, r0
    2050:	00641100 	rsbeq	r1, r4, r0, lsl #2
    2054:	09010801 	stmdbeq	r1, {r0, fp}
    2058:	00000123 	andeq	r0, r0, r3, lsr #2
    205c:	00689102 	rsbeq	r9, r8, r2, lsl #2
    2060:	04120000 	ldreq	r0, [r2], #-0
    2064:	00000097 	muleq	r0, r7, r0
    2068:	69050413 	stmdbvs	r5, {r0, r1, r4, sl}
    206c:	1400746e 	strne	r7, [r0], #-1134	; 0xfffffb92
    2070:	00001912 	andeq	r1, r0, r2, lsl r9
    2074:	7c06c101 	stfvcd	f4, [r6], {1}
    2078:	3c000019 	stccc	0, cr0, [r0], {25}
    207c:	24000093 	strcs	r0, [r0], #-147	; 0xffffff6d
    2080:	01000003 	tsteq	r0, r3
    2084:	0002299c 	muleq	r2, ip, r9
    2088:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    208c:	3711c101 	ldrcc	ip, [r1, -r1, lsl #2]
    2090:	03000000 	movweq	r0, #0
    2094:	0c7fa491 	cfldrdeq	mvd10, [pc], #-580	; 1e58 <shift+0x1e58>
    2098:	00726662 	rsbseq	r6, r2, r2, ror #12
    209c:	291ac101 	ldmdbcs	sl, {r0, r8, lr, pc}
    20a0:	03000002 	movweq	r0, #2
    20a4:	157fa091 	ldrbne	sl, [pc, #-145]!	; 201b <shift+0x201b>
    20a8:	0000184a 	andeq	r1, r0, sl, asr #16
    20ac:	8b32c101 	blhi	cb24b8 <__bss_end+0xca824c>
    20b0:	03000000 	movweq	r0, #0
    20b4:	0e7f9c91 	mrceq	12, 3, r9, cr15, cr1, {4}
    20b8:	00001955 	andeq	r1, r0, r5, asr r9
    20bc:	840fc301 	strhi	ip, [pc], #-769	; 20c4 <shift+0x20c4>
    20c0:	02000000 	andeq	r0, r0, #0
    20c4:	3e0e7491 	mcrcc	4, 0, r7, cr14, cr1, {4}
    20c8:	01000019 	tsteq	r0, r9, lsl r0
    20cc:	012306d9 	ldrdeq	r0, [r3, -r9]!
    20d0:	91020000 	mrsls	r0, (UNDEF: 2)
    20d4:	18530e70 	ldmdane	r3, {r4, r5, r6, r9, sl, fp}^
    20d8:	dd010000 	stcle	0, cr0, [r1, #-0]
    20dc:	00003e11 	andeq	r3, r0, r1, lsl lr
    20e0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    20e4:	0018100e 	andseq	r1, r8, lr
    20e8:	18e00100 	stmiane	r0!, {r8}^
    20ec:	0000008b 	andeq	r0, r0, fp, lsl #1
    20f0:	0e609102 	lgneqs	f1, f2
    20f4:	0000181f 	andeq	r1, r0, pc, lsl r8
    20f8:	8b18e101 	blhi	63a504 <__bss_end+0x630298>
    20fc:	02000000 	andeq	r0, r0, #0
    2100:	c50e5c91 	strgt	r5, [lr, #-3217]	; 0xfffff36f
    2104:	01000018 	tsteq	r0, r8, lsl r0
    2108:	022f07e3 	eoreq	r0, pc, #59506688	; 0x38c0000
    210c:	91030000 	mrsls	r0, (UNDEF: 3)
    2110:	590e7fb8 	stmdbpl	lr, {r3, r4, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    2114:	01000018 	tsteq	r0, r8, lsl r0
    2118:	012306e5 	smulwteq	r3, r5, r6
    211c:	91020000 	mrsls	r0, (UNDEF: 2)
    2120:	95481658 	strbls	r1, [r8, #-1624]	; 0xfffff9a8
    2124:	00500000 	subseq	r0, r0, r0
    2128:	01f70000 	mvnseq	r0, r0
    212c:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    2130:	0be70100 	bleq	ff9c2538 <__bss_end+0xff9b82cc>
    2134:	00000123 	andeq	r0, r0, r3, lsr #2
    2138:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    213c:	0095a40f 	addseq	sl, r5, pc, lsl #8
    2140:	00009800 	andeq	r9, r0, r0, lsl #16
    2144:	18430e00 	stmdane	r3, {r9, sl, fp}^
    2148:	ef010000 	svc	0x00010000
    214c:	00023f08 	andeq	r3, r2, r8, lsl #30
    2150:	ac910300 	ldcge	3, cr0, [r1], {0}
    2154:	95d40f7f 	ldrbls	r0, [r4, #3967]	; 0xf7f
    2158:	00680000 	rsbeq	r0, r8, r0
    215c:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    2160:	0cf20100 	ldfeqe	f0, [r2]
    2164:	00000123 	andeq	r0, r0, r3, lsr #2
    2168:	00689102 	rsbeq	r9, r8, r2, lsl #2
    216c:	04120000 	ldreq	r0, [r2], #-0
    2170:	00000090 	muleq	r0, r0, r0
    2174:	00009008 	andeq	r9, r0, r8
    2178:	00023f00 	andeq	r3, r2, r0, lsl #30
    217c:	00840900 	addeq	r0, r4, r0, lsl #18
    2180:	001f0000 	andseq	r0, pc, r0
    2184:	00009008 	andeq	r9, r0, r8
    2188:	00024f00 	andeq	r4, r2, r0, lsl #30
    218c:	00840900 	addeq	r0, r4, r0, lsl #18
    2190:	00080000 	andeq	r0, r8, r0
    2194:	00191214 	andseq	r1, r9, r4, lsl r2
    2198:	06bb0100 	ldrteq	r0, [fp], r0, lsl #2
    219c:	000019e1 	andeq	r1, r0, r1, ror #19
    21a0:	0000930c 	andeq	r9, r0, ip, lsl #6
    21a4:	00000030 	andeq	r0, r0, r0, lsr r0
    21a8:	02869c01 	addeq	r9, r6, #256	; 0x100
    21ac:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    21b0:	11bb0100 			; <UNDEFINED> instruction: 0x11bb0100
    21b4:	00000037 	andeq	r0, r0, r7, lsr r0
    21b8:	0c749102 	ldfeqp	f1, [r4], #-8
    21bc:	00726662 	rsbseq	r6, r2, r2, ror #12
    21c0:	291abb01 	ldmdbcs	sl, {r0, r8, r9, fp, ip, sp, pc}
    21c4:	02000002 	andeq	r0, r0, #2
    21c8:	0b007091 	bleq	1e414 <__bss_end+0x141a8>
    21cc:	00001819 	andeq	r1, r0, r9, lsl r8
    21d0:	d006b501 	andle	fp, r6, r1, lsl #10
    21d4:	b2000018 	andlt	r0, r0, #24
    21d8:	cc000002 	stcgt	0, cr0, [r0], {2}
    21dc:	40000092 	mulmi	r0, r2, r0
    21e0:	01000000 	mrseq	r0, (UNDEF: 0)
    21e4:	0002b29c 	muleq	r2, ip, r2
    21e8:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    21ec:	3712b501 	ldrcc	fp, [r2, -r1, lsl #10]
    21f0:	02000000 	andeq	r0, r0, #0
    21f4:	03007491 	movweq	r7, #1169	; 0x491
    21f8:	0b500201 	bleq	1402a04 <__bss_end+0x13f8798>
    21fc:	0a0b0000 	beq	2c2204 <__bss_end+0x2b7f98>
    2200:	01000018 	tsteq	r0, r8, lsl r0
    2204:	188d06b0 	stmne	sp, {r4, r5, r7, r9, sl}
    2208:	02b20000 	adcseq	r0, r2, #0
    220c:	92900000 	addsls	r0, r0, #0
    2210:	003c0000 	eorseq	r0, ip, r0
    2214:	9c010000 	stcls	0, cr0, [r1], {-0}
    2218:	000002e5 	andeq	r0, r0, r5, ror #5
    221c:	0100780c 	tsteq	r0, ip, lsl #16
    2220:	003712b0 	ldrhteq	r1, [r7], -r0
    2224:	91020000 	mrsls	r0, (UNDEF: 2)
    2228:	c9140074 	ldmdbgt	r4, {r2, r4, r5, r6}
    222c:	01000019 	tsteq	r0, r9, lsl r0
    2230:	191706a5 	ldmdbne	r7, {r0, r2, r5, r7, r9, sl}
    2234:	91bc0000 			; <UNDEFINED> instruction: 0x91bc0000
    2238:	00d40000 	sbcseq	r0, r4, r0
    223c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2240:	0000033a 	andeq	r0, r0, sl, lsr r3
    2244:	0100780c 	tsteq	r0, ip, lsl #16
    2248:	00842ba5 	addeq	r2, r4, r5, lsr #23
    224c:	91020000 	mrsls	r0, (UNDEF: 2)
    2250:	66620c6c 	strbtvs	r0, [r2], -ip, ror #24
    2254:	a5010072 	strge	r0, [r1, #-114]	; 0xffffff8e
    2258:	00022934 	andeq	r2, r2, r4, lsr r9
    225c:	68910200 	ldmvs	r1, {r9}
    2260:	00196315 	andseq	r6, r9, r5, lsl r3
    2264:	3da50100 	stfccs	f0, [r5]
    2268:	00000123 	andeq	r0, r0, r3, lsr #2
    226c:	0e649102 	lgneqs	f1, f2
    2270:	00001955 	andeq	r1, r0, r5, asr r9
    2274:	2306a701 	movwcs	sl, #26369	; 0x6701
    2278:	02000001 	andeq	r0, r0, #1
    227c:	17007491 			; <UNDEFINED> instruction: 0x17007491
    2280:	00001988 	andeq	r1, r0, r8, lsl #19
    2284:	e3068301 	movw	r8, #25345	; 0x6301
    2288:	7c000018 	stcvc	0, cr0, [r0], {24}
    228c:	4000008d 	andmi	r0, r0, sp, lsl #1
    2290:	01000004 	tsteq	r0, r4
    2294:	00039e9c 	muleq	r3, ip, lr
    2298:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    229c:	37188301 	ldrcc	r8, [r8, -r1, lsl #6]
    22a0:	02000000 	andeq	r0, r0, #0
    22a4:	10156c91 	mulsne	r5, r1, ip
    22a8:	01000018 	tsteq	r0, r8, lsl r0
    22ac:	039e2983 	orrseq	r2, lr, #2146304	; 0x20c000
    22b0:	91020000 	mrsls	r0, (UNDEF: 2)
    22b4:	181f1568 	ldmdane	pc, {r3, r5, r6, r8, sl, ip}	; <UNPREDICTABLE>
    22b8:	83010000 	movwhi	r0, #4096	; 0x1000
    22bc:	00039e41 	andeq	r9, r3, r1, asr #28
    22c0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    22c4:	00186815 	andseq	r6, r8, r5, lsl r8
    22c8:	4f830100 	svcmi	0x00830100
    22cc:	000003a4 	andeq	r0, r0, r4, lsr #7
    22d0:	0e609102 	lgneqs	f1, f2
    22d4:	00001800 	andeq	r1, r0, r0, lsl #16
    22d8:	370b9601 	strcc	r9, [fp, -r1, lsl #12]
    22dc:	02000000 	andeq	r0, r0, #0
    22e0:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    22e4:	00008404 	andeq	r8, r0, r4, lsl #8
    22e8:	23041800 	movwcs	r1, #18432	; 0x4800
    22ec:	14000001 	strne	r0, [r0], #-1
    22f0:	00001a01 	andeq	r1, r0, r1, lsl #20
    22f4:	81067601 	tsthi	r6, r1, lsl #12
    22f8:	b8000018 	stmdalt	r0, {r3, r4}
    22fc:	c400008c 	strgt	r0, [r0], #-140	; 0xffffff74
    2300:	01000000 	mrseq	r0, (UNDEF: 0)
    2304:	0003ff9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
    2308:	18c01500 	stmiane	r0, {r8, sl, ip}^
    230c:	76010000 	strvc	r0, [r1], -r0
    2310:	00022913 	andeq	r2, r2, r3, lsl r9
    2314:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2318:	0100690d 	tsteq	r0, sp, lsl #18
    231c:	01230978 			; <UNDEFINED> instruction: 0x01230978
    2320:	91020000 	mrsls	r0, (UNDEF: 2)
    2324:	656c0d74 	strbvs	r0, [ip, #-3444]!	; 0xfffff28c
    2328:	7801006e 	stmdavc	r1, {r1, r2, r3, r5, r6}
    232c:	0001230c 	andeq	r2, r1, ip, lsl #6
    2330:	70910200 	addsvc	r0, r1, r0, lsl #4
    2334:	0018a20e 	andseq	sl, r8, lr, lsl #4
    2338:	11780100 	cmnne	r8, r0, lsl #2
    233c:	00000123 	andeq	r0, r0, r3, lsr #2
    2340:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    2344:	776f7019 			; <UNDEFINED> instruction: 0x776f7019
    2348:	076d0100 	strbeq	r0, [sp, -r0, lsl #2]!
    234c:	000018da 	ldrdeq	r1, [r0], -sl
    2350:	00000037 	andeq	r0, r0, r7, lsr r0
    2354:	00008c4c 	andeq	r8, r0, ip, asr #24
    2358:	0000006c 	andeq	r0, r0, ip, rrx
    235c:	045c9c01 	ldrbeq	r9, [ip], #-3073	; 0xfffff3ff
    2360:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2364:	176d0100 	strbne	r0, [sp, -r0, lsl #2]!
    2368:	0000003e 	andeq	r0, r0, lr, lsr r0
    236c:	0c6c9102 	stfeqp	f1, [ip], #-8
    2370:	6d01006e 	stcvs	0, cr0, [r1, #-440]	; 0xfffffe48
    2374:	00008b2d 	andeq	r8, r0, sp, lsr #22
    2378:	68910200 	ldmvs	r1, {r9}
    237c:	0100720d 	tsteq	r0, sp, lsl #4
    2380:	00370b6f 	eorseq	r0, r7, pc, ror #22
    2384:	91020000 	mrsls	r0, (UNDEF: 2)
    2388:	8c680f74 	stclhi	15, cr0, [r8], #-464	; 0xfffffe30
    238c:	00380000 	eorseq	r0, r8, r0
    2390:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    2394:	16700100 	ldrbtne	r0, [r0], -r0, lsl #2
    2398:	00000084 	andeq	r0, r0, r4, lsl #1
    239c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    23a0:	194e1700 	stmdbne	lr, {r8, r9, sl, ip}^
    23a4:	64010000 	strvs	r0, [r1], #-0
    23a8:	0017b606 	andseq	fp, r7, r6, lsl #12
    23ac:	008bcc00 	addeq	ip, fp, r0, lsl #24
    23b0:	00008000 	andeq	r8, r0, r0
    23b4:	d99c0100 	ldmible	ip, {r8}
    23b8:	0c000004 	stceq	0, cr0, [r0], {4}
    23bc:	00637273 	rsbeq	r7, r3, r3, ror r2
    23c0:	d9196401 	ldmdble	r9, {r0, sl, sp, lr}
    23c4:	02000004 	andeq	r0, r0, #4
    23c8:	640c6491 	strvs	r6, [ip], #-1169	; 0xfffffb6f
    23cc:	01007473 	tsteq	r0, r3, ror r4
    23d0:	04e02464 	strbteq	r2, [r0], #1124	; 0x464
    23d4:	91020000 	mrsls	r0, (UNDEF: 2)
    23d8:	756e0c60 	strbvc	r0, [lr, #-3168]!	; 0xfffff3a0
    23dc:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    23e0:	0001232d 	andeq	r2, r1, sp, lsr #6
    23e4:	5c910200 	lfmpl	f0, 4, [r1], {0}
    23e8:	0019370e 	andseq	r3, r9, lr, lsl #14
    23ec:	0e660100 	poweqs	f0, f6, f0
    23f0:	0000011d 	andeq	r0, r0, sp, lsl r1
    23f4:	0e709102 	expeqs	f1, f2
    23f8:	000018ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    23fc:	29086701 	stmdbcs	r8, {r0, r8, r9, sl, sp, lr}
    2400:	02000002 	andeq	r0, r0, #2
    2404:	f40f6c91 			; <UNDEFINED> instruction: 0xf40f6c91
    2408:	4800008b 	stmdami	r0, {r0, r1, r3, r7}
    240c:	0d000000 	stceq	0, cr0, [r0, #-0]
    2410:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    2414:	0001230b 	andeq	r2, r1, fp, lsl #6
    2418:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    241c:	04120000 	ldreq	r0, [r2], #-0
    2420:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2424:	17041b1a 	smladne	r4, sl, fp, r1
    2428:	00001948 	andeq	r1, r0, r8, asr #18
    242c:	a7065c01 	strge	r5, [r6, -r1, lsl #24]
    2430:	64000018 	strvs	r0, [r0], #-24	; 0xffffffe8
    2434:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    2438:	01000000 	mrseq	r0, (UNDEF: 0)
    243c:	0005419c 	muleq	r5, ip, r1
    2440:	19ec1500 	stmibne	ip!, {r8, sl, ip}^
    2444:	5c010000 	stcpl	0, cr0, [r1], {-0}
    2448:	0004e012 	andeq	lr, r4, r2, lsl r0
    244c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2450:	0019f315 	andseq	pc, r9, r5, lsl r3	; <UNPREDICTABLE>
    2454:	1e5c0100 	rdfnee	f0, f4, f0
    2458:	00000123 	andeq	r0, r0, r3, lsr #2
    245c:	0d689102 	stfeqp	f1, [r8, #-8]!
    2460:	006d656d 	rsbeq	r6, sp, sp, ror #10
    2464:	29085e01 	stmdbcs	r8, {r0, r9, sl, fp, ip, lr}
    2468:	02000002 	andeq	r0, r0, #2
    246c:	800f7091 	mulhi	pc, r1, r0	; <UNPREDICTABLE>
    2470:	3c00008b 	stccc	0, cr0, [r0], {139}	; 0x8b
    2474:	0d000000 	stceq	0, cr0, [r0, #-0]
    2478:	60010069 	andvs	r0, r1, r9, rrx
    247c:	0001230b 	andeq	r2, r1, fp, lsl #6
    2480:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2484:	fa0b0000 	blx	2c248c <__bss_end+0x2b8220>
    2488:	01000019 	tsteq	r0, r9, lsl r0
    248c:	19990552 	ldmibne	r9, {r1, r4, r6, r8, sl}
    2490:	01230000 			; <UNDEFINED> instruction: 0x01230000
    2494:	8b100000 	blhi	40249c <__bss_end+0x3f8230>
    2498:	00540000 	subseq	r0, r4, r0
    249c:	9c010000 	stcls	0, cr0, [r1], {-0}
    24a0:	0000057a 	andeq	r0, r0, sl, ror r5
    24a4:	0100730c 	tsteq	r0, ip, lsl #6
    24a8:	011d1852 	tsteq	sp, r2, asr r8
    24ac:	91020000 	mrsls	r0, (UNDEF: 2)
    24b0:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    24b4:	23065401 	movwcs	r5, #25601	; 0x6401
    24b8:	02000001 	andeq	r0, r0, #1
    24bc:	0b007491 	bleq	1f708 <__bss_end+0x1549c>
    24c0:	0000195b 	andeq	r1, r0, fp, asr r9
    24c4:	a6054201 	strge	r4, [r5], -r1, lsl #4
    24c8:	23000019 	movwcs	r0, #25
    24cc:	64000001 	strvs	r0, [r0], #-1
    24d0:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    24d4:	01000000 	mrseq	r0, (UNDEF: 0)
    24d8:	0005e09c 	muleq	r5, ip, r0
    24dc:	31730c00 	cmncc	r3, r0, lsl #24
    24e0:	19420100 	stmdbne	r2, {r8}^
    24e4:	0000011d 	andeq	r0, r0, sp, lsl r1
    24e8:	0c6c9102 	stfeqp	f1, [ip], #-8
    24ec:	01003273 	tsteq	r0, r3, ror r2
    24f0:	011d2942 	tsteq	sp, r2, asr #18
    24f4:	91020000 	mrsls	r0, (UNDEF: 2)
    24f8:	756e0c68 	strbvc	r0, [lr, #-3176]!	; 0xfffff398
    24fc:	4201006d 	andmi	r0, r1, #109	; 0x6d
    2500:	00012331 	andeq	r2, r1, r1, lsr r3
    2504:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2508:	0031750d 	eorseq	r7, r1, sp, lsl #10
    250c:	e0104401 	ands	r4, r0, r1, lsl #8
    2510:	02000005 	andeq	r0, r0, #5
    2514:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    2518:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    251c:	0005e014 	andeq	lr, r5, r4, lsl r0
    2520:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    2524:	08010300 	stmdaeq	r1, {r8, r9}
    2528:	000010b0 	strheq	r1, [r0], -r0
    252c:	0018b30b 	andseq	fp, r8, fp, lsl #6
    2530:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    2534:	000019b8 			; <UNDEFINED> instruction: 0x000019b8
    2538:	00000229 	andeq	r0, r0, r9, lsr #4
    253c:	000089a4 	andeq	r8, r0, r4, lsr #19
    2540:	000000c0 	andeq	r0, r0, r0, asr #1
    2544:	06409c01 	strbeq	r9, [r0], -r1, lsl #24
    2548:	7c150000 	ldcvc	0, cr0, [r5], {-0}
    254c:	01000018 	tsteq	r0, r8, lsl r0
    2550:	02291536 	eoreq	r1, r9, #226492416	; 0xd800000
    2554:	91020000 	mrsls	r0, (UNDEF: 2)
    2558:	72730c6c 	rsbsvc	r0, r3, #108, 24	; 0x6c00
    255c:	36010063 	strcc	r0, [r1], -r3, rrx
    2560:	00011d27 	andeq	r1, r1, r7, lsr #26
    2564:	68910200 	ldmvs	r1, {r9}
    2568:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    256c:	30360100 	eorscc	r0, r6, r0, lsl #2
    2570:	00000123 	andeq	r0, r0, r3, lsr #2
    2574:	0d649102 	stfeqp	f1, [r4, #-8]!
    2578:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    257c:	00012306 	andeq	r2, r1, r6, lsl #6
    2580:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2584:	18330b00 	ldmdane	r3!, {r8, r9, fp}
    2588:	24010000 	strcs	r0, [r1], #-0
    258c:	00196a05 	andseq	r6, r9, r5, lsl #20
    2590:	00012300 	andeq	r2, r1, r0, lsl #6
    2594:	00890800 	addeq	r0, r9, r0, lsl #16
    2598:	00009c00 	andeq	r9, r0, r0, lsl #24
    259c:	7d9c0100 	ldfvcs	f0, [ip]
    25a0:	15000006 	strne	r0, [r0, #-6]
    25a4:	00001897 	muleq	r0, r7, r8
    25a8:	1d162401 	cfldrsne	mvf2, [r6, #-4]
    25ac:	02000001 	andeq	r0, r0, #1
    25b0:	750e6c91 	strvc	r6, [lr, #-3217]	; 0xfffff36f
    25b4:	01000019 	tsteq	r0, r9, lsl r0
    25b8:	01230626 			; <UNDEFINED> instruction: 0x01230626
    25bc:	91020000 	mrsls	r0, (UNDEF: 2)
    25c0:	bb1c0074 	bllt	702798 <__bss_end+0x6f852c>
    25c4:	01000018 	tsteq	r0, r8, lsl r0
    25c8:	18270608 	stmdane	r7!, {r3, r9, sl}
    25cc:	87940000 	ldrhi	r0, [r4, r0]
    25d0:	01740000 	cmneq	r4, r0
    25d4:	9c010000 	stcls	0, cr0, [r1], {-0}
    25d8:	00189715 	andseq	r9, r8, r5, lsl r7
    25dc:	18080100 	stmdane	r8, {r8}
    25e0:	00000084 	andeq	r0, r0, r4, lsl #1
    25e4:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    25e8:	00001975 	andeq	r1, r0, r5, ror r9
    25ec:	29250801 	stmdbcs	r5!, {r0, fp}
    25f0:	02000002 	andeq	r0, r0, #2
    25f4:	9d156091 	ldcls	0, cr6, [r5, #-580]	; 0xfffffdbc
    25f8:	01000018 	tsteq	r0, r8, lsl r0
    25fc:	00843a08 	addeq	r3, r4, r8, lsl #20
    2600:	91020000 	mrsls	r0, (UNDEF: 2)
    2604:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    2608:	23060a01 	movwcs	r0, #27137	; 0x6a01
    260c:	02000001 	andeq	r0, r0, #1
    2610:	600f7491 	mulvs	pc, r1, r4	; <UNPREDICTABLE>
    2614:	98000088 	stmdals	r0, {r3, r7}
    2618:	0d000000 	stceq	0, cr0, [r0, #-0]
    261c:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    2620:	0001230b 	andeq	r2, r1, fp, lsl #6
    2624:	70910200 	addsvc	r0, r1, r0, lsl #4
    2628:	0088880f 	addeq	r8, r8, pc, lsl #16
    262c:	00006000 	andeq	r6, r0, r0
    2630:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    2634:	90081e01 	andls	r1, r8, r1, lsl #28
    2638:	02000000 	andeq	r0, r0, #0
    263c:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    2640:	11440000 	mrsne	r0, (UNDEF: 68)
    2644:	00040000 	andeq	r0, r4, r0
    2648:	000008e8 	andeq	r0, r0, r8, ror #17
    264c:	16e30104 	strbtne	r0, [r3], r4, lsl #2
    2650:	64040000 	strvs	r0, [r4], #-0
    2654:	5100001a 	tstpl	r0, sl, lsl r0
    2658:	70000015 	andvc	r0, r0, r5, lsl r0
    265c:	b4000097 	strlt	r0, [r0], #-151	; 0xffffff69
    2660:	b4000004 	strlt	r0, [r0], #-4
    2664:	0200000d 	andeq	r0, r0, #13
    2668:	10b90801 	adcsne	r0, r9, r1, lsl #16
    266c:	25030000 	strcs	r0, [r3, #-0]
    2670:	02000000 	andeq	r0, r0, #0
    2674:	0e370502 	cdpeq	5, 3, cr0, cr7, cr2, {0}
    2678:	04040000 	streq	r0, [r4], #-0
    267c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2680:	00380300 	eorseq	r0, r8, r0, lsl #6
    2684:	8f050000 	svchi	0x00050000
    2688:	0200001b 	andeq	r0, r0, #27
    268c:	00550707 	subseq	r0, r5, r7, lsl #14
    2690:	44030000 	strmi	r0, [r3], #-0
    2694:	02000000 	andeq	r0, r0, #0
    2698:	10b00801 	adcsne	r0, r0, r1, lsl #16
    269c:	80050000 	andhi	r0, r5, r0
    26a0:	0200000d 	andeq	r0, r0, #13
    26a4:	006d0708 	rsbeq	r0, sp, r8, lsl #14
    26a8:	5c030000 	stcpl	0, cr0, [r3], {-0}
    26ac:	02000000 	andeq	r0, r0, #0
    26b0:	126b0702 	rsbne	r0, fp, #524288	; 0x80000
    26b4:	ea050000 	b	1426bc <__bss_end+0x138450>
    26b8:	02000006 	andeq	r0, r0, #6
    26bc:	00850709 	addeq	r0, r5, r9, lsl #14
    26c0:	74030000 	strvc	r0, [r3], #-0
    26c4:	02000000 	andeq	r0, r0, #0
    26c8:	20f70704 	rscscs	r0, r7, r4, lsl #14
    26cc:	85030000 	strhi	r0, [r3, #-0]
    26d0:	06000000 	streq	r0, [r0], -r0
    26d4:	00000e42 	andeq	r0, r0, r2, asr #28
    26d8:	07060308 	streq	r0, [r6, -r8, lsl #6]
    26dc:	000001d5 	ldrdeq	r0, [r0], -r5
    26e0:	00091c07 	andeq	r1, r9, r7, lsl #24
    26e4:	120a0300 	andne	r0, sl, #0, 6
    26e8:	00000074 	andeq	r0, r0, r4, ror r0
    26ec:	0d960700 	ldceq	7, cr0, [r6]
    26f0:	0c030000 	stceq	0, cr0, [r3], {-0}
    26f4:	0001da0e 	andeq	sp, r1, lr, lsl #20
    26f8:	42080400 	andmi	r0, r8, #0, 8
    26fc:	0300000e 	movweq	r0, #14
    2700:	069f0910 			; <UNDEFINED> instruction: 0x069f0910
    2704:	01e60000 	mvneq	r0, r0
    2708:	d1010000 	mrsle	r0, (UNDEF: 1)
    270c:	dc000000 	stcle	0, cr0, [r0], {-0}
    2710:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2714:	000001e6 	andeq	r0, r0, r6, ror #3
    2718:	0001f10a 	andeq	pc, r1, sl, lsl #2
    271c:	41080000 	mrsmi	r0, (UNDEF: 8)
    2720:	0300000e 	movweq	r0, #14
    2724:	0df91512 	cfldr64eq	mvdx1, [r9, #72]!	; 0x48
    2728:	01f70000 	mvnseq	r0, r0
    272c:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    2730:	00000000 	andeq	r0, r0, r0
    2734:	09000001 	stmdbeq	r0, {r0}
    2738:	000001e6 	andeq	r0, r0, r6, ror #3
    273c:	00003809 	andeq	r3, r0, r9, lsl #16
    2740:	b8080000 	stmdalt	r8, {}	; <UNPREDICTABLE>
    2744:	03000006 	movweq	r0, #6
    2748:	09dc0e15 	ldmibeq	ip, {r0, r2, r4, r9, sl, fp}^
    274c:	01da0000 	bicseq	r0, sl, r0
    2750:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    2754:	1f000001 	svcne	0x00000001
    2758:	09000001 	stmdbeq	r0, {r0}
    275c:	000001f9 	strdeq	r0, [r0], -r9
    2760:	0fa60b00 	svceq	0x00a60b00
    2764:	18030000 	stmdane	r3, {}	; <UNPREDICTABLE>
    2768:	0008b70e 	andeq	fp, r8, lr, lsl #14
    276c:	01340100 	teqeq	r4, r0, lsl #2
    2770:	013a0000 	teqeq	sl, r0
    2774:	e6090000 	str	r0, [r9], -r0
    2778:	00000001 	andeq	r0, r0, r1
    277c:	0009d60b 	andeq	sp, r9, fp, lsl #12
    2780:	0e1b0300 	cdpeq	3, 1, cr0, cr11, cr0, {0}
    2784:	00000734 	andeq	r0, r0, r4, lsr r7
    2788:	00014f01 	andeq	r4, r1, r1, lsl #30
    278c:	00015a00 	andeq	r5, r1, r0, lsl #20
    2790:	01e60900 	mvneq	r0, r0, lsl #18
    2794:	da0a0000 	ble	28279c <__bss_end+0x278530>
    2798:	00000001 	andeq	r0, r0, r1
    279c:	0010980b 	andseq	r9, r0, fp, lsl #16
    27a0:	0e1d0300 	cdpeq	3, 1, cr0, cr13, cr0, {0}
    27a4:	00001178 	andeq	r1, r0, r8, ror r1
    27a8:	00016f01 	andeq	r6, r1, r1, lsl #30
    27ac:	00018400 	andeq	r8, r1, r0, lsl #8
    27b0:	01e60900 	mvneq	r0, r0, lsl #18
    27b4:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    27b8:	0a000000 	beq	27c0 <shift+0x27c0>
    27bc:	0000005c 	andeq	r0, r0, ip, asr r0
    27c0:	0001da0a 	andeq	sp, r1, sl, lsl #20
    27c4:	590b0000 	stmdbpl	fp, {}	; <UNPREDICTABLE>
    27c8:	03000007 	movweq	r0, #7
    27cc:	058f0e1f 	streq	r0, [pc, #3615]	; 35f3 <shift+0x35f3>
    27d0:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    27d4:	ae000001 	cdpge	0, 0, cr0, cr0, cr1, {0}
    27d8:	09000001 	stmdbeq	r0, {r0}
    27dc:	000001e6 	andeq	r0, r0, r6, ror #3
    27e0:	00005c0a 	andeq	r5, r0, sl, lsl #24
    27e4:	005c0a00 	subseq	r0, ip, r0, lsl #20
    27e8:	250a0000 	strcs	r0, [sl, #-0]
    27ec:	00000000 	andeq	r0, r0, r0
    27f0:	0012940c 	andseq	r9, r2, ip, lsl #8
    27f4:	0e210300 	cdpeq	3, 2, cr0, cr1, cr0, {0}
    27f8:	00000f58 	andeq	r0, r0, r8, asr pc
    27fc:	0001bf01 	andeq	fp, r1, r1, lsl #30
    2800:	01e60900 	mvneq	r0, r0, lsl #18
    2804:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    2808:	0a000000 	beq	2810 <shift+0x2810>
    280c:	0000005c 	andeq	r0, r0, ip, asr r0
    2810:	0001f10a 	andeq	pc, r1, sl, lsl #2
    2814:	03000000 	movweq	r0, #0
    2818:	00000091 	muleq	r0, r1, r0
    281c:	50020102 	andpl	r0, r2, r2, lsl #2
    2820:	0300000b 	movweq	r0, #11
    2824:	000001da 	ldrdeq	r0, [r0], -sl
    2828:	0091040d 	addseq	r0, r1, sp, lsl #8
    282c:	e6030000 	str	r0, [r3], -r0
    2830:	0d000001 	stceq	0, cr0, [r0, #-4]
    2834:	00002c04 	andeq	r2, r0, r4, lsl #24
    2838:	0d040e00 	stceq	14, cr0, [r4, #-0]
    283c:	0001d504 	andeq	sp, r1, r4, lsl #10
    2840:	01f90300 	mvnseq	r0, r0, lsl #6
    2844:	6b0f0000 	blvs	3c284c <__bss_end+0x3b85e0>
    2848:	08000013 	stmdaeq	r0, {r0, r1, r4}
    284c:	2a080604 	bcs	204064 <__bss_end+0x1f9df8>
    2850:	10000002 	andne	r0, r0, r2
    2854:	04003072 	streq	r3, [r0], #-114	; 0xffffff8e
    2858:	00740e08 	rsbseq	r0, r4, r8, lsl #28
    285c:	10000000 	andne	r0, r0, r0
    2860:	04003172 	streq	r3, [r0], #-370	; 0xfffffe8e
    2864:	00740e09 	rsbseq	r0, r4, r9, lsl #28
    2868:	00040000 	andeq	r0, r4, r0
    286c:	000eee11 	andeq	lr, lr, r1, lsl lr
    2870:	38040500 	stmdacc	r4, {r8, sl}
    2874:	04000000 	streq	r0, [r0], #-0
    2878:	02610c1e 	rsbeq	r0, r1, #7680	; 0x1e00
    287c:	e2120000 	ands	r0, r2, #0
    2880:	00000006 	andeq	r0, r0, r6
    2884:	00092412 	andeq	r2, r9, r2, lsl r4
    2888:	10120100 	andsne	r0, r2, r0, lsl #2
    288c:	0200000f 	andeq	r0, r0, #15
    2890:	0010cc12 	andseq	ip, r0, r2, lsl ip
    2894:	07120300 	ldreq	r0, [r2, -r0, lsl #6]
    2898:	04000009 	streq	r0, [r0], #-9
    289c:	000e2712 	andeq	r2, lr, r2, lsl r7
    28a0:	11000500 	tstne	r0, r0, lsl #10
    28a4:	00000ed6 	ldrdeq	r0, [r0], -r6
    28a8:	00380405 	eorseq	r0, r8, r5, lsl #8
    28ac:	3f040000 	svccc	0x00040000
    28b0:	00029e0c 	andeq	r9, r2, ip, lsl #28
    28b4:	084b1200 	stmdaeq	fp, {r9, ip}^
    28b8:	12000000 	andne	r0, r0, #0
    28bc:	0000100a 	andeq	r1, r0, sl
    28c0:	12fb1201 	rscsne	r1, fp, #268435456	; 0x10000000
    28c4:	12020000 	andne	r0, r2, #0
    28c8:	00000cfe 	strdeq	r0, [r0], -lr
    28cc:	09161203 	ldmdbeq	r6, {r0, r1, r9, ip}
    28d0:	12040000 	andne	r0, r4, #0
    28d4:	00000a3c 	andeq	r0, r0, ip, lsr sl
    28d8:	07621205 	strbeq	r1, [r2, -r5, lsl #4]!
    28dc:	00060000 	andeq	r0, r6, r0
    28e0:	000c3113 	andeq	r3, ip, r3, lsl r1
    28e4:	14050500 	strne	r0, [r5], #-1280	; 0xfffffb00
    28e8:	00000080 	andeq	r0, r0, r0, lsl #1
    28ec:	9fa00305 	svcls	0x00a00305
    28f0:	0f130000 	svceq	0x00130000
    28f4:	05000010 	streq	r0, [r0, #-16]
    28f8:	00801406 	addeq	r1, r0, r6, lsl #8
    28fc:	03050000 	movweq	r0, #20480	; 0x5000
    2900:	00009fa4 	andeq	r9, r0, r4, lsr #31
    2904:	000aa713 	andeq	sl, sl, r3, lsl r7
    2908:	1a070600 	bne	1c4110 <__bss_end+0x1b9ea4>
    290c:	00000080 	andeq	r0, r0, r0, lsl #1
    2910:	9fa80305 	svcls	0x00a80305
    2914:	50130000 	andspl	r0, r3, r0
    2918:	0600000e 	streq	r0, [r0], -lr
    291c:	00801a09 	addeq	r1, r0, r9, lsl #20
    2920:	03050000 	movweq	r0, #20480	; 0x5000
    2924:	00009fac 	andeq	r9, r0, ip, lsr #31
    2928:	000a6a13 	andeq	r6, sl, r3, lsl sl
    292c:	1a0b0600 	bne	2c4134 <__bss_end+0x2b9ec8>
    2930:	00000080 	andeq	r0, r0, r0, lsl #1
    2934:	9fb00305 	svcls	0x00b00305
    2938:	db130000 	blle	4c2940 <__bss_end+0x4b86d4>
    293c:	0600000d 	streq	r0, [r0], -sp
    2940:	00801a0d 	addeq	r1, r0, sp, lsl #20
    2944:	03050000 	movweq	r0, #20480	; 0x5000
    2948:	00009fb4 			; <UNDEFINED> instruction: 0x00009fb4
    294c:	0006c213 	andeq	ip, r6, r3, lsl r2
    2950:	1a0f0600 	bne	3c4158 <__bss_end+0x3b9eec>
    2954:	00000080 	andeq	r0, r0, r0, lsl #1
    2958:	9fb80305 	svcls	0x00b80305
    295c:	e4110000 	ldr	r0, [r1], #-0
    2960:	0500000c 	streq	r0, [r0, #-12]
    2964:	00003804 	andeq	r3, r0, r4, lsl #16
    2968:	0c1b0600 	ldceq	6, cr0, [fp], {-0}
    296c:	00000341 	andeq	r0, r0, r1, asr #6
    2970:	00064e12 	andeq	r4, r6, r2, lsl lr
    2974:	38120000 	ldmdacc	r2, {}	; <UNPREDICTABLE>
    2978:	01000011 	tsteq	r0, r1, lsl r0
    297c:	0012f612 	andseq	pc, r2, r2, lsl r6	; <UNPREDICTABLE>
    2980:	14000200 	strne	r0, [r0], #-512	; 0xfffffe00
    2984:	00000419 	andeq	r0, r0, r9, lsl r4
    2988:	0004e106 	andeq	lr, r4, r6, lsl #2
    298c:	63069000 	movwvs	r9, #24576	; 0x6000
    2990:	0004b407 	andeq	fp, r4, r7, lsl #8
    2994:	062a0f00 	strteq	r0, [sl], -r0, lsl #30
    2998:	06240000 	strteq	r0, [r4], -r0
    299c:	03ce1067 	biceq	r1, lr, #103	; 0x67
    29a0:	67070000 	strvs	r0, [r7, -r0]
    29a4:	06000024 	streq	r0, [r0], -r4, lsr #32
    29a8:	04b41269 	ldrteq	r1, [r4], #617	; 0x269
    29ac:	07000000 	streq	r0, [r0, -r0]
    29b0:	00000850 	andeq	r0, r0, r0, asr r8
    29b4:	da126b06 	ble	49d5d4 <__bss_end+0x493368>
    29b8:	10000001 	andne	r0, r0, r1
    29bc:	00064307 	andeq	r4, r6, r7, lsl #6
    29c0:	166d0600 	strbtne	r0, [sp], -r0, lsl #12
    29c4:	00000074 	andeq	r0, r0, r4, ror r0
    29c8:	0e300714 	mrceq	7, 1, r0, cr0, cr4, {0}
    29cc:	70060000 	andvc	r0, r6, r0
    29d0:	0004c41c 	andeq	ip, r4, ip, lsl r4
    29d4:	b3071800 	movwlt	r1, #30720	; 0x7800
    29d8:	06000012 			; <UNDEFINED> instruction: 0x06000012
    29dc:	04c41c72 	strbeq	r1, [r4], #3186	; 0xc72
    29e0:	071c0000 	ldreq	r0, [ip, -r0]
    29e4:	000004dc 	ldrdeq	r0, [r0], -ip
    29e8:	c41c7506 	ldrgt	r7, [ip], #-1286	; 0xfffffafa
    29ec:	20000004 	andcs	r0, r0, r4
    29f0:	000ec515 	andeq	ip, lr, r5, lsl r5
    29f4:	1c770600 	ldclne	6, cr0, [r7], #-0
    29f8:	000011f6 	strdeq	r1, [r0], -r6
    29fc:	000004c4 	andeq	r0, r0, r4, asr #9
    2a00:	000003c2 	andeq	r0, r0, r2, asr #7
    2a04:	0004c409 	andeq	ip, r4, r9, lsl #8
    2a08:	01f10a00 	mvnseq	r0, r0, lsl #20
    2a0c:	00000000 	andeq	r0, r0, r0
    2a10:	0012eb0f 	andseq	lr, r2, pc, lsl #22
    2a14:	7b061800 	blvc	188a1c <__bss_end+0x17e7b0>
    2a18:	00040310 	andeq	r0, r4, r0, lsl r3
    2a1c:	24670700 	strbtcs	r0, [r7], #-1792	; 0xfffff900
    2a20:	7e060000 	cdpvc	0, 0, cr0, cr6, cr0, {0}
    2a24:	0004b412 	andeq	fp, r4, r2, lsl r4
    2a28:	36070000 	strcc	r0, [r7], -r0
    2a2c:	06000005 	streq	r0, [r0], -r5
    2a30:	01f11980 	mvnseq	r1, r0, lsl #19
    2a34:	07100000 	ldreq	r0, [r0, -r0]
    2a38:	00000a43 	andeq	r0, r0, r3, asr #20
    2a3c:	cf218206 	svcgt	0x00218206
    2a40:	14000004 	strne	r0, [r0], #-4
    2a44:	03ce0300 	biceq	r0, lr, #0, 6
    2a48:	8f160000 	svchi	0x00160000
    2a4c:	06000004 	streq	r0, [r0], -r4
    2a50:	04d52186 	ldrbeq	r2, [r5], #390	; 0x186
    2a54:	7a160000 	bvc	582a5c <__bss_end+0x5787f0>
    2a58:	06000008 	streq	r0, [r0], -r8
    2a5c:	00801f88 	addeq	r1, r0, r8, lsl #31
    2a60:	62070000 	andvs	r0, r7, #0
    2a64:	0600000e 	streq	r0, [r0], -lr
    2a68:	0353178b 	cmpeq	r3, #36438016	; 0x22c0000
    2a6c:	07000000 	streq	r0, [r0, -r0]
    2a70:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
    2a74:	53178e06 	tstpl	r7, #6, 28	; 0x60
    2a78:	24000003 	strcs	r0, [r0], #-3
    2a7c:	000bb507 	andeq	fp, fp, r7, lsl #10
    2a80:	178f0600 	strne	r0, [pc, r0, lsl #12]
    2a84:	00000353 	andeq	r0, r0, r3, asr r3
    2a88:	099e0748 	ldmibeq	lr, {r3, r6, r8, r9, sl}
    2a8c:	90060000 	andls	r0, r6, r0
    2a90:	00035317 	andeq	r5, r3, r7, lsl r3
    2a94:	e1086c00 	tst	r8, r0, lsl #24
    2a98:	06000004 	streq	r0, [r0], -r4
    2a9c:	0d9e0993 	vldreq.16	s0, [lr, #294]	; 0x126	; <UNPREDICTABLE>
    2aa0:	04e00000 	strbteq	r0, [r0], #0
    2aa4:	6d010000 	stcvs	0, cr0, [r1, #-0]
    2aa8:	73000004 	movwvc	r0, #4
    2aac:	09000004 	stmdbeq	r0, {r2}
    2ab0:	000004e0 	andeq	r0, r0, r0, ror #9
    2ab4:	0eba0b00 	vmoveq.f64	d0, #160	; 0xc1000000 -8.0
    2ab8:	96060000 	strls	r0, [r6], -r0
    2abc:	0005170e 	andeq	r1, r5, lr, lsl #14
    2ac0:	04880100 	streq	r0, [r8], #256	; 0x100
    2ac4:	048e0000 	streq	r0, [lr], #0
    2ac8:	e0090000 	and	r0, r9, r0
    2acc:	00000004 	andeq	r0, r0, r4
    2ad0:	00084b17 	andeq	r4, r8, r7, lsl fp
    2ad4:	10990600 	addsne	r0, r9, r0, lsl #12
    2ad8:	00000cc9 	andeq	r0, r0, r9, asr #25
    2adc:	000004e6 	andeq	r0, r0, r6, ror #9
    2ae0:	0004a301 	andeq	sl, r4, r1, lsl #6
    2ae4:	04e00900 	strbteq	r0, [r0], #2304	; 0x900
    2ae8:	f10a0000 	cpsie	,#0
    2aec:	0a000001 	beq	2af8 <shift+0x2af8>
    2af0:	0000031c 	andeq	r0, r0, ip, lsl r3
    2af4:	25180000 	ldrcs	r0, [r8, #-0]
    2af8:	c4000000 	strgt	r0, [r0], #-0
    2afc:	19000004 	stmdbne	r0, {r2}
    2b00:	00000085 	andeq	r0, r0, r5, lsl #1
    2b04:	040d000f 	streq	r0, [sp], #-15
    2b08:	00000353 	andeq	r0, r0, r3, asr r3
    2b0c:	0011cb14 	andseq	ip, r1, r4, lsl fp
    2b10:	ca040d00 	bgt	105f18 <__bss_end+0xfbcac>
    2b14:	18000004 	stmdane	r0, {r2}
    2b18:	00000403 	andeq	r0, r0, r3, lsl #8
    2b1c:	000004e0 	andeq	r0, r0, r0, ror #9
    2b20:	040d001a 	streq	r0, [sp], #-26	; 0xffffffe6
    2b24:	00000346 	andeq	r0, r0, r6, asr #6
    2b28:	0341040d 	movteq	r0, #5133	; 0x140d
    2b2c:	ae1b0000 	cdpge	0, 1, cr0, cr11, cr0, {0}
    2b30:	0600000e 	streq	r0, [r0], -lr
    2b34:	0346149c 	movteq	r1, #25756	; 0x649c
    2b38:	58130000 	ldmdapl	r3, {}	; <UNPREDICTABLE>
    2b3c:	07000006 	streq	r0, [r0, -r6]
    2b40:	00801404 	addeq	r1, r0, r4, lsl #8
    2b44:	03050000 	movweq	r0, #20480	; 0x5000
    2b48:	00009fbc 			; <UNDEFINED> instruction: 0x00009fbc
    2b4c:	000f1613 	andeq	r1, pc, r3, lsl r6	; <UNPREDICTABLE>
    2b50:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
    2b54:	00000080 	andeq	r0, r0, r0, lsl #1
    2b58:	9fc00305 	svcls	0x00c00305
    2b5c:	04130000 	ldreq	r0, [r3], #-0
    2b60:	07000005 	streq	r0, [r0, -r5]
    2b64:	0080140a 	addeq	r1, r0, sl, lsl #8
    2b68:	03050000 	movweq	r0, #20480	; 0x5000
    2b6c:	00009fc4 	andeq	r9, r0, r4, asr #31
    2b70:	00076711 	andeq	r6, r7, r1, lsl r7
    2b74:	38040500 	stmdacc	r4, {r8, sl}
    2b78:	07000000 	streq	r0, [r0, -r0]
    2b7c:	05650c0d 	strbeq	r0, [r5, #-3085]!	; 0xfffff3f3
    2b80:	4e1c0000 	cdpmi	0, 1, cr0, cr12, cr0, {0}
    2b84:	00007765 	andeq	r7, r0, r5, ror #14
    2b88:	00092e12 	andeq	r2, r9, r2, lsl lr
    2b8c:	fc120100 	ldc2	1, cr0, [r2], {-0}
    2b90:	02000004 	andeq	r0, r0, #4
    2b94:	00078012 	andeq	r8, r7, r2, lsl r0
    2b98:	be120300 	cdplt	3, 1, cr0, cr2, cr0, {0}
    2b9c:	04000010 	streq	r0, [r0], #-16
    2ba0:	0004d512 	andeq	sp, r4, r2, lsl r5
    2ba4:	0f000500 	svceq	0x00000500
    2ba8:	00000671 	andeq	r0, r0, r1, ror r6
    2bac:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
    2bb0:	000005a4 	andeq	r0, r0, r4, lsr #11
    2bb4:	00726c10 	rsbseq	r6, r2, r0, lsl ip
    2bb8:	a4131d07 	ldrge	r1, [r3], #-3335	; 0xfffff2f9
    2bbc:	00000005 	andeq	r0, r0, r5
    2bc0:	00707310 	rsbseq	r7, r0, r0, lsl r3
    2bc4:	a4131e07 	ldrge	r1, [r3], #-3591	; 0xfffff1f9
    2bc8:	04000005 	streq	r0, [r0], #-5
    2bcc:	00637010 	rsbeq	r7, r3, r0, lsl r0
    2bd0:	a4131f07 	ldrge	r1, [r3], #-3847	; 0xfffff0f9
    2bd4:	08000005 	stmdaeq	r0, {r0, r2}
    2bd8:	000ed007 	andeq	sp, lr, r7
    2bdc:	13200700 	nopne	{0}	; <UNPREDICTABLE>
    2be0:	000005a4 	andeq	r0, r0, r4, lsr #11
    2be4:	0402000c 	streq	r0, [r2], #-12
    2be8:	0020f207 	eoreq	pc, r0, r7, lsl #4
    2bec:	05a40300 	streq	r0, [r4, #768]!	; 0x300
    2bf0:	fa0f0000 	blx	3c2bf8 <__bss_end+0x3b898c>
    2bf4:	70000008 	andvc	r0, r0, r8
    2bf8:	40082807 	andmi	r2, r8, r7, lsl #16
    2bfc:	07000006 	streq	r0, [r0, -r6]
    2c00:	000007fa 	strdeq	r0, [r0], -sl
    2c04:	65122a07 	ldrvs	r2, [r2, #-2567]	; 0xfffff5f9
    2c08:	00000005 	andeq	r0, r0, r5
    2c0c:	64697010 	strbtvs	r7, [r9], #-16
    2c10:	122b0700 	eorne	r0, fp, #0, 14
    2c14:	00000085 	andeq	r0, r0, r5, lsl #1
    2c18:	1e430710 	mcrne	7, 2, r0, cr3, cr0, {0}
    2c1c:	2c070000 	stccs	0, cr0, [r7], {-0}
    2c20:	00052e11 	andeq	r2, r5, r1, lsl lr
    2c24:	a2071400 	andge	r1, r7, #0, 8
    2c28:	07000010 	smladeq	r0, r0, r0, r0
    2c2c:	0085122d 	addeq	r1, r5, sp, lsr #4
    2c30:	07180000 	ldreq	r0, [r8, -r0]
    2c34:	000003a9 	andeq	r0, r0, r9, lsr #7
    2c38:	85122e07 	ldrhi	r2, [r2, #-3591]	; 0xfffff1f9
    2c3c:	1c000000 	stcne	0, cr0, [r0], {-0}
    2c40:	000f0307 	andeq	r0, pc, r7, lsl #6
    2c44:	0c2f0700 	stceq	7, cr0, [pc], #-0	; 2c4c <shift+0x2c4c>
    2c48:	00000640 	andeq	r0, r0, r0, asr #12
    2c4c:	04850720 	streq	r0, [r5], #1824	; 0x720
    2c50:	30070000 	andcc	r0, r7, r0
    2c54:	00003809 	andeq	r3, r0, r9, lsl #16
    2c58:	0f076000 	svceq	0x00076000
    2c5c:	0700000b 	streq	r0, [r0, -fp]
    2c60:	00740e31 	rsbseq	r0, r4, r1, lsr lr
    2c64:	07640000 	strbeq	r0, [r4, -r0]!
    2c68:	00000d72 	andeq	r0, r0, r2, ror sp
    2c6c:	740e3307 	strvc	r3, [lr], #-775	; 0xfffffcf9
    2c70:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    2c74:	000d6907 	andeq	r6, sp, r7, lsl #18
    2c78:	0e340700 	cdpeq	7, 3, cr0, cr4, cr0, {0}
    2c7c:	00000074 	andeq	r0, r0, r4, ror r0
    2c80:	e618006c 	ldr	r0, [r8], -ip, rrx
    2c84:	50000004 	andpl	r0, r0, r4
    2c88:	19000006 	stmdbne	r0, {r1, r2}
    2c8c:	00000085 	andeq	r0, r0, r5, lsl #1
    2c90:	ed13000f 	ldc	0, cr0, [r3, #-60]	; 0xffffffc4
    2c94:	08000004 	stmdaeq	r0, {r2}
    2c98:	0080140a 	addeq	r1, r0, sl, lsl #8
    2c9c:	03050000 	movweq	r0, #20480	; 0x5000
    2ca0:	00009fc8 	andeq	r9, r0, r8, asr #31
    2ca4:	000afa11 	andeq	pc, sl, r1, lsl sl	; <UNPREDICTABLE>
    2ca8:	38040500 	stmdacc	r4, {r8, sl}
    2cac:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2cb0:	06810c0d 	streq	r0, [r1], sp, lsl #24
    2cb4:	0a120000 	beq	482cbc <__bss_end+0x478a50>
    2cb8:	00000013 	andeq	r0, r0, r3, lsl r0
    2cbc:	00116d12 	andseq	r6, r1, r2, lsl sp
    2cc0:	0f000100 	svceq	0x00000100
    2cc4:	000007df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2cc8:	081b080c 	ldmdaeq	fp, {r2, r3, fp}
    2ccc:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    2cd0:	00058a07 	andeq	r8, r5, r7, lsl #20
    2cd4:	191d0800 	ldmdbne	sp, {fp}
    2cd8:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    2cdc:	04dc0700 	ldrbeq	r0, [ip], #1792	; 0x700
    2ce0:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
    2ce4:	0006b619 	andeq	fp, r6, r9, lsl r6
    2ce8:	2a070400 	bcs	1c3cf0 <__bss_end+0x1b9a84>
    2cec:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    2cf0:	06bc131f 	ssateq	r1, #29, pc, lsl #6	; <UNPREDICTABLE>
    2cf4:	00080000 	andeq	r0, r8, r0
    2cf8:	0681040d 	streq	r0, [r1], sp, lsl #8
    2cfc:	040d0000 	streq	r0, [sp], #-0
    2d00:	000005b0 			; <UNDEFINED> instruction: 0x000005b0
    2d04:	000e7106 	andeq	r7, lr, r6, lsl #2
    2d08:	22081400 	andcs	r1, r8, #0, 8
    2d0c:	00094407 	andeq	r4, r9, r7, lsl #8
    2d10:	0c3f0700 	ldceq	7, cr0, [pc], #-0	; 2d18 <shift+0x2d18>
    2d14:	26080000 	strcs	r0, [r8], -r0
    2d18:	00007412 	andeq	r7, r0, r2, lsl r4
    2d1c:	d2070000 	andle	r0, r7, #0
    2d20:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    2d24:	06b61d29 	ldrteq	r1, [r6], r9, lsr #26
    2d28:	07040000 	streq	r0, [r4, -r0]
    2d2c:	00000788 	andeq	r0, r0, r8, lsl #15
    2d30:	b61d2c08 	ldrlt	r2, [sp], -r8, lsl #24
    2d34:	08000006 	stmdaeq	r0, {r1, r2}
    2d38:	000cf41d 	andeq	pc, ip, sp, lsl r4	; <UNPREDICTABLE>
    2d3c:	0e2f0800 	cdpeq	8, 2, cr0, cr15, cr0, {0}
    2d40:	000007bc 			; <UNDEFINED> instruction: 0x000007bc
    2d44:	0000070a 	andeq	r0, r0, sl, lsl #14
    2d48:	00000715 	andeq	r0, r0, r5, lsl r7
    2d4c:	00094909 	andeq	r4, r9, r9, lsl #18
    2d50:	06b60a00 	ldrteq	r0, [r6], r0, lsl #20
    2d54:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
    2d58:	00000937 	andeq	r0, r0, r7, lsr r9
    2d5c:	d10e3108 	tstle	lr, r8, lsl #2
    2d60:	da000008 	ble	2d88 <shift+0x2d88>
    2d64:	2d000001 	stccs	0, cr0, [r0, #-4]
    2d68:	38000007 	stmdacc	r0, {r0, r1, r2}
    2d6c:	09000007 	stmdbeq	r0, {r0, r1, r2}
    2d70:	00000949 	andeq	r0, r0, r9, asr #18
    2d74:	0006bc0a 	andeq	fp, r6, sl, lsl #24
    2d78:	19080000 	stmdbne	r8, {}	; <UNPREDICTABLE>
    2d7c:	08000011 	stmdaeq	r0, {r0, r4}
    2d80:	0ad51d35 	beq	ff54a25c <__bss_end+0xff53fff0>
    2d84:	06b60000 	ldrteq	r0, [r6], r0
    2d88:	51020000 	mrspl	r0, (UNDEF: 2)
    2d8c:	57000007 	strpl	r0, [r0, -r7]
    2d90:	09000007 	stmdbeq	r0, {r0, r1, r2}
    2d94:	00000949 	andeq	r0, r0, r9, asr #18
    2d98:	07730800 	ldrbeq	r0, [r3, -r0, lsl #16]!
    2d9c:	37080000 	strcc	r0, [r8, -r0]
    2da0:	000d041d 	andeq	r0, sp, sp, lsl r4
    2da4:	0006b600 	andeq	fp, r6, r0, lsl #12
    2da8:	07700200 	ldrbeq	r0, [r0, -r0, lsl #4]!
    2dac:	07760000 	ldrbeq	r0, [r6, -r0]!
    2db0:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2db4:	00000009 	andeq	r0, r0, r9
    2db8:	000be51f 	andeq	lr, fp, pc, lsl r5
    2dbc:	31390800 	teqcc	r9, r0, lsl #16
    2dc0:	00000962 	andeq	r0, r0, r2, ror #18
    2dc4:	7108020c 	tstvc	r8, ip, lsl #4
    2dc8:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    2dcc:	0946093c 	stmdbeq	r6, {r2, r3, r4, r5, r8, fp}^
    2dd0:	09490000 	stmdbeq	r9, {}^	; <UNPREDICTABLE>
    2dd4:	9d010000 	stcls	0, cr0, [r1, #-0]
    2dd8:	a3000007 	movwge	r0, #7
    2ddc:	09000007 	stmdbeq	r0, {r0, r1, r2}
    2de0:	00000949 	andeq	r0, r0, r9, asr #18
    2de4:	080c0800 	stmdaeq	ip, {fp}
    2de8:	3f080000 	svccc	0x00080000
    2dec:	00055f12 	andeq	r5, r5, r2, lsl pc
    2df0:	00007400 	andeq	r7, r0, r0, lsl #8
    2df4:	07bc0100 	ldreq	r0, [ip, r0, lsl #2]!
    2df8:	07d10000 	ldrbeq	r0, [r1, r0]
    2dfc:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2e00:	0a000009 	beq	2e2c <shift+0x2e2c>
    2e04:	0000096b 	andeq	r0, r0, fp, ror #18
    2e08:	0000850a 	andeq	r8, r0, sl, lsl #10
    2e0c:	01da0a00 	bicseq	r0, sl, r0, lsl #20
    2e10:	0b000000 	bleq	2e18 <shift+0x2e18>
    2e14:	00001143 	andeq	r1, r0, r3, asr #2
    2e18:	7e0e4208 	cdpvc	2, 0, cr4, cr14, cr8, {0}
    2e1c:	01000006 	tsteq	r0, r6
    2e20:	000007e6 	andeq	r0, r0, r6, ror #15
    2e24:	000007ec 	andeq	r0, r0, ip, ror #15
    2e28:	00094909 	andeq	r4, r9, r9, lsl #18
    2e2c:	41080000 	mrsmi	r0, (UNDEF: 8)
    2e30:	08000005 	stmdaeq	r0, {r0, r2}
    2e34:	05fc1745 	ldrbeq	r1, [ip, #1861]!	; 0x745
    2e38:	06bc0000 	ldrteq	r0, [ip], r0
    2e3c:	05010000 	streq	r0, [r1, #-0]
    2e40:	0b000008 	bleq	2e68 <shift+0x2e68>
    2e44:	09000008 	stmdbeq	r0, {r3}
    2e48:	00000971 	andeq	r0, r0, r1, ror r9
    2e4c:	0f210800 	svceq	0x00210800
    2e50:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
    2e54:	0003bf17 	andeq	fp, r3, r7, lsl pc
    2e58:	0006bc00 	andeq	fp, r6, r0, lsl #24
    2e5c:	08240100 	stmdaeq	r4!, {r8}
    2e60:	082f0000 	stmdaeq	pc!, {}	; <UNPREDICTABLE>
    2e64:	71090000 	mrsvc	r0, (UNDEF: 9)
    2e68:	0a000009 	beq	2e94 <shift+0x2e94>
    2e6c:	00000074 	andeq	r0, r0, r4, ror r0
    2e70:	06cc0b00 	strbeq	r0, [ip], r0, lsl #22
    2e74:	4b080000 	blmi	202e7c <__bss_end+0x1f8c10>
    2e78:	000bf30e 	andeq	pc, fp, lr, lsl #6
    2e7c:	08440100 	stmdaeq	r4, {r8}^
    2e80:	084a0000 	stmdaeq	sl, {}^	; <UNPREDICTABLE>
    2e84:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2e88:	00000009 	andeq	r0, r0, r9
    2e8c:	00093708 	andeq	r3, r9, r8, lsl #14
    2e90:	0e4d0800 	cdpeq	8, 4, cr0, cr13, cr0, {0}
    2e94:	00000db3 			; <UNDEFINED> instruction: 0x00000db3
    2e98:	000001da 	ldrdeq	r0, [r0], -sl
    2e9c:	00086301 	andeq	r6, r8, r1, lsl #6
    2ea0:	00086e00 	andeq	r6, r8, r0, lsl #28
    2ea4:	09490900 	stmdbeq	r9, {r8, fp}^
    2ea8:	740a0000 	strvc	r0, [sl], #-0
    2eac:	00000000 	andeq	r0, r0, r0
    2eb0:	0004c108 	andeq	ip, r4, r8, lsl #2
    2eb4:	12500800 	subsne	r0, r0, #0, 16
    2eb8:	000003ec 	andeq	r0, r0, ip, ror #7
    2ebc:	00000074 	andeq	r0, r0, r4, ror r0
    2ec0:	00088701 	andeq	r8, r8, r1, lsl #14
    2ec4:	00089200 	andeq	r9, r8, r0, lsl #4
    2ec8:	09490900 	stmdbeq	r9, {r8, fp}^
    2ecc:	e60a0000 	str	r0, [sl], -r0
    2ed0:	00000004 	andeq	r0, r0, r4
    2ed4:	00041f08 	andeq	r1, r4, r8, lsl #30
    2ed8:	0e530800 	cdpeq	8, 5, cr0, cr3, cr0, {0}
    2edc:	00001199 	muleq	r0, r9, r1
    2ee0:	000001da 	ldrdeq	r0, [r0], -sl
    2ee4:	0008ab01 	andeq	sl, r8, r1, lsl #22
    2ee8:	0008b600 	andeq	fp, r8, r0, lsl #12
    2eec:	09490900 	stmdbeq	r9, {r8, fp}^
    2ef0:	740a0000 	strvc	r0, [sl], #-0
    2ef4:	00000000 	andeq	r0, r0, r0
    2ef8:	00049b0b 	andeq	r9, r4, fp, lsl #22
    2efc:	0e560800 	cdpeq	8, 5, cr0, cr6, cr0, {0}
    2f00:	0000101b 	andeq	r1, r0, fp, lsl r0
    2f04:	0008cb01 	andeq	ip, r8, r1, lsl #22
    2f08:	0008ea00 	andeq	lr, r8, r0, lsl #20
    2f0c:	09490900 	stmdbeq	r9, {r8, fp}^
    2f10:	2a0a0000 	bcs	282f18 <__bss_end+0x278cac>
    2f14:	0a000002 	beq	2f24 <shift+0x2f24>
    2f18:	00000074 	andeq	r0, r0, r4, ror r0
    2f1c:	0000740a 	andeq	r7, r0, sl, lsl #8
    2f20:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2f24:	770a0000 	strvc	r0, [sl, -r0]
    2f28:	00000009 	andeq	r0, r0, r9
    2f2c:	0012260b 	andseq	r2, r2, fp, lsl #12
    2f30:	0e580800 	cdpeq	8, 5, cr0, cr8, cr0, {0}
    2f34:	0000131f 	andeq	r1, r0, pc, lsl r3
    2f38:	0008ff01 	andeq	pc, r8, r1, lsl #30
    2f3c:	00091e00 	andeq	r1, r9, r0, lsl #28
    2f40:	09490900 	stmdbeq	r9, {r8, fp}^
    2f44:	610a0000 	mrsvs	r0, (UNDEF: 10)
    2f48:	0a000002 	beq	2f58 <shift+0x2f58>
    2f4c:	00000074 	andeq	r0, r0, r4, ror r0
    2f50:	0000740a 	andeq	r7, r0, sl, lsl #8
    2f54:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2f58:	770a0000 	strvc	r0, [sl, -r0]
    2f5c:	00000009 	andeq	r0, r0, r9
    2f60:	0004ae17 	andeq	sl, r4, r7, lsl lr
    2f64:	0e5b0800 	cdpeq	8, 5, cr0, cr11, cr0, {0}
    2f68:	00000b55 	andeq	r0, r0, r5, asr fp
    2f6c:	000001da 	ldrdeq	r0, [r0], -sl
    2f70:	00093301 	andeq	r3, r9, r1, lsl #6
    2f74:	09490900 	stmdbeq	r9, {r8, fp}^
    2f78:	620a0000 	andvs	r0, sl, #0
    2f7c:	0a000006 	beq	2f9c <shift+0x2f9c>
    2f80:	000001f7 	strdeq	r0, [r0], -r7
    2f84:	c2030000 	andgt	r0, r3, #0
    2f88:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
    2f8c:	0006c204 	andeq	ip, r6, r4, lsl #4
    2f90:	06b62000 	ldrteq	r2, [r6], r0
    2f94:	095c0000 	ldmdbeq	ip, {}^	; <UNPREDICTABLE>
    2f98:	09620000 	stmdbeq	r2!, {}^	; <UNPREDICTABLE>
    2f9c:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2fa0:	00000009 	andeq	r0, r0, r9
    2fa4:	0006c221 	andeq	ip, r6, r1, lsr #4
    2fa8:	00094f00 	andeq	r4, r9, r0, lsl #30
    2fac:	55040d00 	strpl	r0, [r4, #-3328]	; 0xfffff300
    2fb0:	0d000000 	stceq	0, cr0, [r0, #-0]
    2fb4:	00094404 	andeq	r4, r9, r4, lsl #8
    2fb8:	04042200 	streq	r2, [r4], #-512	; 0xfffffe00
    2fbc:	1b000002 	blne	2fcc <shift+0x2fcc>
    2fc0:	00001288 	andeq	r1, r0, r8, lsl #5
    2fc4:	c2195e08 	andsgt	r5, r9, #8, 28	; 0x80
    2fc8:	13000006 	movwne	r0, #6
    2fcc:	00001301 	andeq	r1, r0, r1, lsl #6
    2fd0:	a2110409 	andsge	r0, r1, #150994944	; 0x9000000
    2fd4:	05000009 	streq	r0, [r0, #-9]
    2fd8:	009fcc03 	addseq	ip, pc, r3, lsl #24
    2fdc:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    2fe0:	00001ec1 	andeq	r1, r0, r1, asr #29
    2fe4:	00099b03 	andeq	r9, r9, r3, lsl #22
    2fe8:	1b451100 	blne	11473f0 <__bss_end+0x113d184>
    2fec:	01070000 	mrseq	r0, (UNDEF: 7)
    2ff0:	00000044 	andeq	r0, r0, r4, asr #32
    2ff4:	d80c060a 	stmdale	ip, {r1, r3, r9, sl}
    2ff8:	1c000009 	stcne	0, cr0, [r0], {9}
    2ffc:	00706f4e 	rsbseq	r6, r0, lr, asr #30
    3000:	0fa61200 	svceq	0x00a61200
    3004:	12010000 	andne	r0, r1, #0
    3008:	000009d6 	ldrdeq	r0, [r0], -r6
    300c:	1b5c1202 	blne	170781c <__bss_end+0x16fd5b0>
    3010:	12030000 	andne	r0, r3, #0
    3014:	00001abc 			; <UNDEFINED> instruction: 0x00001abc
    3018:	d50f0004 	strle	r0, [pc, #-4]	; 301c <shift+0x301c>
    301c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    3020:	0908220a 	stmdbeq	r8, {r1, r3, r9, sp}
    3024:	1000000a 	andne	r0, r0, sl
    3028:	240a0078 	strcs	r0, [sl], #-120	; 0xffffff88
    302c:	00005c0e 	andeq	r5, r0, lr, lsl #24
    3030:	79100000 	ldmdbvc	r0, {}	; <UNPREDICTABLE>
    3034:	0e250a00 	vmuleq.f32	s0, s10, s0
    3038:	0000005c 	andeq	r0, r0, ip, asr r0
    303c:	65731002 	ldrbvs	r1, [r3, #-2]!
    3040:	260a0074 			; <UNDEFINED> instruction: 0x260a0074
    3044:	0000440d 	andeq	r4, r0, sp, lsl #8
    3048:	0f000400 	svceq	0x00000400
    304c:	00001a12 	andeq	r1, r0, r2, lsl sl
    3050:	082a0a01 	stmdaeq	sl!, {r0, r9, fp}
    3054:	00000a24 	andeq	r0, r0, r4, lsr #20
    3058:	646d6310 	strbtvs	r6, [sp], #-784	; 0xfffffcf0
    305c:	162c0a00 	strtne	r0, [ip], -r0, lsl #20
    3060:	000009a7 	andeq	r0, r0, r7, lsr #19
    3064:	290f0000 	stmdbcs	pc, {}	; <UNPREDICTABLE>
    3068:	0100001a 	tsteq	r0, sl, lsl r0
    306c:	3f08300a 	svccc	0x0008300a
    3070:	0700000a 	streq	r0, [r0, -sl]
    3074:	00001ba3 	andeq	r1, r0, r3, lsr #23
    3078:	091c320a 	ldmdbeq	ip, {r1, r3, r9, ip, sp}
    307c:	0000000a 	andeq	r0, r0, sl
    3080:	1b1a0f00 	blne	686c88 <__bss_end+0x67ca1c>
    3084:	0a020000 	beq	8308c <__bss_end+0x78e20>
    3088:	0a670836 	beq	19c5168 <__bss_end+0x19baefc>
    308c:	a3070000 	movwge	r0, #28672	; 0x7000
    3090:	0a00001b 	beq	3104 <shift+0x3104>
    3094:	0a091c38 	beq	24a17c <__bss_end+0x23ff10>
    3098:	07000000 	streq	r0, [r0, -r0]
    309c:	00001b6d 	andeq	r1, r0, sp, ror #22
    30a0:	440d390a 	strmi	r3, [sp], #-2314	; 0xfffff6f6
    30a4:	01000000 	mrseq	r0, (UNDEF: 0)
    30a8:	1a9b0f00 	bne	fe6c6cb0 <__bss_end+0xfe6bca44>
    30ac:	0a080000 	beq	2030b4 <__bss_end+0x1f8e48>
    30b0:	0a9c083d 	beq	fe7051ac <__bss_end+0xfe6faf40>
    30b4:	a3070000 	movwge	r0, #28672	; 0x7000
    30b8:	0a00001b 	beq	312c <shift+0x312c>
    30bc:	0a091c3f 	beq	24a1c0 <__bss_end+0x23ff54>
    30c0:	07000000 	streq	r0, [r0, -r0]
    30c4:	0000154b 	andeq	r1, r0, fp, asr #10
    30c8:	5c0e400a 	stcpl	0, cr4, [lr], {10}
    30cc:	01000000 	mrseq	r0, (UNDEF: 0)
    30d0:	001b5607 	andseq	r5, fp, r7, lsl #12
    30d4:	19420a00 	stmdbne	r2, {r9, fp}^
    30d8:	000009d8 	ldrdeq	r0, [r0], -r8
    30dc:	ee0f0003 	cdp	0, 0, cr0, cr15, cr3, {0}
    30e0:	0b00001a 	bleq	3150 <shift+0x3150>
    30e4:	ff08460a 			; <UNDEFINED> instruction: 0xff08460a
    30e8:	0700000a 	streq	r0, [r0, -sl]
    30ec:	00001ba3 	andeq	r1, r0, r3, lsr #23
    30f0:	091c480a 	ldmdbeq	ip, {r1, r3, fp, lr}
    30f4:	0000000a 	andeq	r0, r0, sl
    30f8:	00317810 	eorseq	r7, r1, r0, lsl r8
    30fc:	5c0e490a 			; <UNDEFINED> instruction: 0x5c0e490a
    3100:	01000000 	mrseq	r0, (UNDEF: 0)
    3104:	00317910 	eorseq	r7, r1, r0, lsl r9
    3108:	5c12490a 			; <UNDEFINED> instruction: 0x5c12490a
    310c:	03000000 	movweq	r0, #0
    3110:	0a007710 	beq	20d58 <__bss_end+0x16aec>
    3114:	005c0e4a 	subseq	r0, ip, sl, asr #28
    3118:	10050000 	andne	r0, r5, r0
    311c:	4a0a0068 	bmi	2832c4 <__bss_end+0x279058>
    3120:	00005c11 	andeq	r5, r0, r1, lsl ip
    3124:	5e070700 	cdppl	7, 0, cr0, cr7, cr0, {0}
    3128:	0a00001a 	beq	3198 <shift+0x3198>
    312c:	00440d4b 	subeq	r0, r4, fp, asr #26
    3130:	07090000 	streq	r0, [r9, -r0]
    3134:	00001b56 	andeq	r1, r0, r6, asr fp
    3138:	440d4d0a 	strmi	r4, [sp], #-3338	; 0xfffff2f6
    313c:	0a000000 	beq	3144 <shift+0x3144>
    3140:	61682300 	cmnvs	r8, r0, lsl #6
    3144:	050b006c 	streq	r0, [fp, #-108]	; 0xffffff94
    3148:	000bb90b 	andeq	fp, fp, fp, lsl #18
    314c:	0ba22400 	bleq	fe88c154 <__bss_end+0xfe881ee8>
    3150:	070b0000 	streq	r0, [fp, -r0]
    3154:	00008c19 	andeq	r8, r0, r9, lsl ip
    3158:	e6b28000 	ldrt	r8, [r2], r0
    315c:	0f34240e 	svceq	0x0034240e
    3160:	0a0b0000 	beq	2c3168 <__bss_end+0x2b8efc>
    3164:	0005ab1a 	andeq	sl, r5, sl, lsl fp
    3168:	00000000 	andeq	r0, r0, r0
    316c:	05552420 	ldrbeq	r2, [r5, #-1056]	; 0xfffffbe0
    3170:	0d0b0000 	stceq	0, cr0, [fp, #-0]
    3174:	0005ab1a 	andeq	sl, r5, sl, lsl fp
    3178:	20000000 	andcs	r0, r0, r0
    317c:	0b1b2520 	bleq	6cc604 <__bss_end+0x6c2398>
    3180:	100b0000 	andne	r0, fp, r0
    3184:	00008015 	andeq	r8, r0, r5, lsl r0
    3188:	25243600 	strcs	r3, [r4, #-1536]!	; 0xfffffa00
    318c:	0b000011 	bleq	31d8 <shift+0x31d8>
    3190:	05ab1a4b 	streq	r1, [fp, #2635]!	; 0xa4b
    3194:	50000000 	andpl	r0, r0, r0
    3198:	d1242021 			; <UNDEFINED> instruction: 0xd1242021
    319c:	0b000012 	bleq	31ec <shift+0x31ec>
    31a0:	05ab1a7a 	streq	r1, [fp, #2682]!	; 0xa7a
    31a4:	b2000000 	andlt	r0, r0, #0
    31a8:	6f242000 	svcvs	0x00242000
    31ac:	0b000008 	bleq	31d4 <shift+0x31d4>
    31b0:	05ab1aad 	streq	r1, [fp, #2733]!	; 0xaad
    31b4:	b4000000 	strlt	r0, [r0], #-0
    31b8:	98242000 	stmdals	r4!, {sp}
    31bc:	0b00000b 	bleq	31f0 <shift+0x31f0>
    31c0:	05ab1abc 	streq	r1, [fp, #2748]!	; 0xabc
    31c4:	40000000 	andmi	r0, r0, r0
    31c8:	3d242010 	stccc	0, cr2, [r4, #-64]!	; 0xffffffc0
    31cc:	0b00000d 	bleq	3208 <shift+0x3208>
    31d0:	05ab1ac7 	streq	r1, [fp, #2759]!	; 0xac7
    31d4:	50000000 	andpl	r0, r0, r0
    31d8:	4f242020 	svcmi	0x00242020
    31dc:	0b000007 	bleq	3200 <shift+0x3200>
    31e0:	05ab1ac8 	streq	r1, [fp, #2760]!	; 0xac8
    31e4:	40000000 	andmi	r0, r0, r0
    31e8:	2e242080 	cdpcs	0, 2, cr2, cr4, cr0, {4}
    31ec:	0b000011 	bleq	3238 <shift+0x3238>
    31f0:	05ab1ac9 	streq	r1, [fp, #2761]!	; 0xac9
    31f4:	50000000 	andpl	r0, r0, r0
    31f8:	26002080 	strcs	r2, [r0], -r0, lsl #1
    31fc:	00000b0b 	andeq	r0, r0, fp, lsl #22
    3200:	000b1b26 	andeq	r1, fp, r6, lsr #22
    3204:	0b2b2600 	bleq	acca0c <__bss_end+0xac27a0>
    3208:	3b260000 	blcc	983210 <__bss_end+0x978fa4>
    320c:	2600000b 	strcs	r0, [r0], -fp
    3210:	00000b48 	andeq	r0, r0, r8, asr #22
    3214:	000b5826 	andeq	r5, fp, r6, lsr #16
    3218:	0b682600 	bleq	1a0ca20 <__bss_end+0x1a027b4>
    321c:	78260000 	stmdavc	r6!, {}	; <UNPREDICTABLE>
    3220:	2600000b 	strcs	r0, [r0], -fp
    3224:	00000b88 	andeq	r0, r0, r8, lsl #23
    3228:	000b9826 	andeq	r9, fp, r6, lsr #16
    322c:	0ba82600 	bleq	fea0ca34 <__bss_end+0xfea027c8>
    3230:	3b270000 	blcc	9c3238 <__bss_end+0x9b8fcc>
    3234:	0c00001b 	stceq	0, cr0, [r0], {27}
    3238:	0e8c0b04 	vdiveq.f64	d0, d12, d4
    323c:	30250000 	eorcc	r0, r5, r0
    3240:	0c00001b 	stceq	0, cr0, [r0], {27}
    3244:	00681807 	rsbeq	r1, r8, r7, lsl #16
    3248:	25060000 	strcs	r0, [r6, #-0]
    324c:	00001b97 	muleq	r0, r7, fp
    3250:	6818090c 	ldmdavs	r8, {r2, r3, r8, fp}
    3254:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3258:	001baa25 	andseq	sl, fp, r5, lsr #20
    325c:	180c0c00 	stmdane	ip, {sl, fp}
    3260:	00000068 	andeq	r0, r0, r8, rrx
    3264:	1b062520 	blne	18c6ec <__bss_end+0x182480>
    3268:	0e0c0000 	cdpeq	0, 0, cr0, cr12, cr0, {0}
    326c:	00006818 	andeq	r6, r0, r8, lsl r8
    3270:	0f258000 	svceq	0x00258000
    3274:	0c00001b 	stceq	0, cr0, [r0], {27}
    3278:	01e11411 	mvneq	r1, r1, lsl r4
    327c:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
    3280:	00001a4c 	andeq	r1, r0, ip, asr #20
    3284:	b613140c 	ldrlt	r1, [r3], -ip, lsl #8
    3288:	4000000e 	andmi	r0, r0, lr
    328c:	00000002 	andeq	r0, r0, r2
    3290:	00000000 	andeq	r0, r0, r0
    3294:	002f0000 	eoreq	r0, pc, r0
    3298:	07000000 	streq	r0, [r0, -r0]
    329c:	00000700 	andeq	r0, r0, r0, lsl #14
    32a0:	7f147f14 	svcvc	0x00147f14
    32a4:	2a240014 	bcs	9032fc <__bss_end+0x8f9090>
    32a8:	00122a7f 	andseq	r2, r2, pc, ror sl
    32ac:	64081323 	strvs	r1, [r8], #-803	; 0xfffffcdd
    32b0:	49360062 	ldmdbmi	r6!, {r1, r5, r6}
    32b4:	00502255 	subseq	r2, r0, r5, asr r2
    32b8:	00030500 	andeq	r0, r3, r0, lsl #10
    32bc:	1c000000 	stcne	0, cr0, [r0], {-0}
    32c0:	00004122 	andeq	r4, r0, r2, lsr #2
    32c4:	1c224100 	stfnes	f4, [r2], #-0
    32c8:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    32cc:	0014083e 	andseq	r0, r4, lr, lsr r8
    32d0:	083e0808 	ldmdaeq	lr!, {r3, fp}
    32d4:	00000008 	andeq	r0, r0, r8
    32d8:	000060a0 	andeq	r6, r0, r0, lsr #1
    32dc:	08080808 	stmdaeq	r8, {r3, fp}
    32e0:	60000008 	andvs	r0, r0, r8
    32e4:	00000060 	andeq	r0, r0, r0, rrx
    32e8:	04081020 	streq	r1, [r8], #-32	; 0xffffffe0
    32ec:	513e0002 	teqpl	lr, r2
    32f0:	003e4549 	eorseq	r4, lr, r9, asr #10
    32f4:	407f4200 	rsbsmi	r4, pc, r0, lsl #4
    32f8:	61420000 	mrsvs	r0, (UNDEF: 66)
    32fc:	00464951 	subeq	r4, r6, r1, asr r9
    3300:	4b454121 	blmi	115378c <__bss_end+0x1149520>
    3304:	14180031 	ldrne	r0, [r8], #-49	; 0xffffffcf
    3308:	00107f12 	andseq	r7, r0, r2, lsl pc
    330c:	45454527 	strbmi	r4, [r5, #-1319]	; 0xfffffad9
    3310:	4a3c0039 	bmi	f033fc <__bss_end+0xef9190>
    3314:	00304949 	eorseq	r4, r0, r9, asr #18
    3318:	05097101 	streq	r7, [r9, #-257]	; 0xfffffeff
    331c:	49360003 	ldmdbmi	r6!, {r0, r1}
    3320:	00364949 	eorseq	r4, r6, r9, asr #18
    3324:	29494906 	stmdbcs	r9, {r1, r2, r8, fp, lr}^
    3328:	3600001e 			; <UNDEFINED> instruction: 0x3600001e
    332c:	00000036 	andeq	r0, r0, r6, lsr r0
    3330:	00365600 	eorseq	r5, r6, r0, lsl #12
    3334:	14080000 	strne	r0, [r8], #-0
    3338:	00004122 	andeq	r4, r0, r2, lsr #2
    333c:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    3340:	41000014 	tstmi	r0, r4, lsl r0
    3344:	00081422 	andeq	r1, r8, r2, lsr #8
    3348:	09510102 	ldmdbeq	r1, {r1, r8}^
    334c:	49320006 	ldmdbmi	r2!, {r1, r2}
    3350:	003e5159 	eorseq	r5, lr, r9, asr r1
    3354:	1211127c 	andsne	r1, r1, #124, 4	; 0xc0000007
    3358:	497f007c 	ldmdbmi	pc!, {r2, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    335c:	00364949 	eorseq	r4, r6, r9, asr #18
    3360:	4141413e 	cmpmi	r1, lr, lsr r1
    3364:	417f0022 	cmnmi	pc, r2, lsr #32
    3368:	001c2241 	andseq	r2, ip, r1, asr #4
    336c:	4949497f 	stmdbmi	r9, {r0, r1, r2, r3, r4, r5, r6, r8, fp, lr}^
    3370:	097f0041 	ldmdbeq	pc!, {r0, r6}^	; <UNPREDICTABLE>
    3374:	00010909 	andeq	r0, r1, r9, lsl #18
    3378:	4949413e 	stmdbmi	r9, {r1, r2, r3, r4, r5, r8, lr}^
    337c:	087f007a 	ldmdaeq	pc!, {r1, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    3380:	007f0808 	rsbseq	r0, pc, r8, lsl #16
    3384:	417f4100 	cmnmi	pc, r0, lsl #2
    3388:	40200000 	eormi	r0, r0, r0
    338c:	00013f41 	andeq	r3, r1, r1, asr #30
    3390:	2214087f 	andscs	r0, r4, #8323072	; 0x7f0000
    3394:	407f0041 	rsbsmi	r0, pc, r1, asr #32
    3398:	00404040 	subeq	r4, r0, r0, asr #32
    339c:	020c027f 	andeq	r0, ip, #-268435449	; 0xf0000007
    33a0:	047f007f 	ldrbteq	r0, [pc], #-127	; 33a8 <shift+0x33a8>
    33a4:	007f1008 	rsbseq	r1, pc, r8
    33a8:	4141413e 	cmpmi	r1, lr, lsr r1
    33ac:	097f003e 	ldmdbeq	pc!, {r1, r2, r3, r4, r5}^	; <UNPREDICTABLE>
    33b0:	00060909 	andeq	r0, r6, r9, lsl #18
    33b4:	2151413e 	cmpcs	r1, lr, lsr r1
    33b8:	097f005e 	ldmdbeq	pc!, {r1, r2, r3, r4, r6}^	; <UNPREDICTABLE>
    33bc:	00462919 	subeq	r2, r6, r9, lsl r9
    33c0:	49494946 	stmdbmi	r9, {r1, r2, r6, r8, fp, lr}^
    33c4:	01010031 	tsteq	r1, r1, lsr r0
    33c8:	0001017f 	andeq	r0, r1, pc, ror r1
    33cc:	4040403f 	submi	r4, r0, pc, lsr r0
    33d0:	201f003f 	andscs	r0, pc, pc, lsr r0	; <UNPREDICTABLE>
    33d4:	001f2040 	andseq	r2, pc, r0, asr #32
    33d8:	4038403f 	eorsmi	r4, r8, pc, lsr r0
    33dc:	1463003f 	strbtne	r0, [r3], #-63	; 0xffffffc1
    33e0:	00631408 	rsbeq	r1, r3, r8, lsl #8
    33e4:	08700807 	ldmdaeq	r0!, {r0, r1, r2, fp}^
    33e8:	51610007 	cmnpl	r1, r7
    33ec:	00434549 	subeq	r4, r3, r9, asr #10
    33f0:	41417f00 	cmpmi	r1, r0, lsl #30
    33f4:	2a550000 	bcs	15433fc <__bss_end+0x1539190>
    33f8:	00552a55 	subseq	r2, r5, r5, asr sl
    33fc:	7f414100 	svcvc	0x00414100
    3400:	02040000 	andeq	r0, r4, #0
    3404:	00040201 	andeq	r0, r4, r1, lsl #4
    3408:	40404040 	submi	r4, r0, r0, asr #32
    340c:	01000040 	tsteq	r0, r0, asr #32
    3410:	00000402 	andeq	r0, r0, r2, lsl #8
    3414:	54545420 	ldrbpl	r5, [r4], #-1056	; 0xfffffbe0
    3418:	487f0078 	ldmdami	pc!, {r3, r4, r5, r6}^	; <UNPREDICTABLE>
    341c:	00384444 	eorseq	r4, r8, r4, asr #8
    3420:	44444438 	strbmi	r4, [r4], #-1080	; 0xfffffbc8
    3424:	44380020 	ldrtmi	r0, [r8], #-32	; 0xffffffe0
    3428:	007f4844 	rsbseq	r4, pc, r4, asr #16
    342c:	54545438 	ldrbpl	r5, [r4], #-1080	; 0xfffffbc8
    3430:	7e080018 	mcrvc	0, 0, r0, cr8, cr8, {0}
    3434:	00020109 	andeq	r0, r2, r9, lsl #2
    3438:	a4a4a418 	strtge	sl, [r4], #1048	; 0x418
    343c:	087f007c 	ldmdaeq	pc!, {r2, r3, r4, r5, r6}^	; <UNPREDICTABLE>
    3440:	00780404 	rsbseq	r0, r8, r4, lsl #8
    3444:	407d4400 	rsbsmi	r4, sp, r0, lsl #8
    3448:	80400000 	subhi	r0, r0, r0
    344c:	00007d84 	andeq	r7, r0, r4, lsl #27
    3450:	4428107f 	strtmi	r1, [r8], #-127	; 0xffffff81
    3454:	41000000 	mrsmi	r0, (UNDEF: 0)
    3458:	0000407f 	andeq	r4, r0, pc, ror r0
    345c:	0418047c 	ldreq	r0, [r8], #-1148	; 0xfffffb84
    3460:	087c0078 	ldmdaeq	ip!, {r3, r4, r5, r6}^
    3464:	00780404 	rsbseq	r0, r8, r4, lsl #8
    3468:	44444438 	strbmi	r4, [r4], #-1080	; 0xfffffbc8
    346c:	24fc0038 	ldrbtcs	r0, [ip], #56	; 0x38
    3470:	00182424 	andseq	r2, r8, r4, lsr #8
    3474:	18242418 	stmdane	r4!, {r3, r4, sl, sp}
    3478:	087c00fc 	ldmdaeq	ip!, {r2, r3, r4, r5, r6, r7}^
    347c:	00080404 	andeq	r0, r8, r4, lsl #8
    3480:	54545448 	ldrbpl	r5, [r4], #-1096	; 0xfffffbb8
    3484:	3f040020 	svccc	0x00040020
    3488:	00204044 	eoreq	r4, r0, r4, asr #32
    348c:	2040403c 	subcs	r4, r0, ip, lsr r0
    3490:	201c007c 	andscs	r0, ip, ip, ror r0
    3494:	001c2040 	andseq	r2, ip, r0, asr #32
    3498:	4030403c 	eorsmi	r4, r0, ip, lsr r0
    349c:	2844003c 	stmdacs	r4, {r2, r3, r4, r5}^
    34a0:	00442810 	subeq	r2, r4, r0, lsl r8
    34a4:	a0a0a01c 	adcge	sl, r0, ip, lsl r0
    34a8:	6444007c 	strbvs	r0, [r4], #-124	; 0xffffff84
    34ac:	00444c54 	subeq	r4, r4, r4, asr ip
    34b0:	00770800 	rsbseq	r0, r7, r0, lsl #16
    34b4:	00000000 	andeq	r0, r0, r0
    34b8:	0000007f 	andeq	r0, r0, pc, ror r0
    34bc:	00087700 	andeq	r7, r8, r0, lsl #14
    34c0:	08100000 	ldmdaeq	r0, {}	; <UNPREDICTABLE>
    34c4:	00000810 	andeq	r0, r0, r0, lsl r8
    34c8:	00000000 	andeq	r0, r0, r0
    34cc:	fc260000 	stc2	0, cr0, [r6], #-0
    34d0:	2600000b 	strcs	r0, [r0], -fp
    34d4:	00000c09 	andeq	r0, r0, r9, lsl #24
    34d8:	000c1626 	andeq	r1, ip, r6, lsr #12
    34dc:	0c232600 	stceq	6, cr2, [r3], #-0
    34e0:	30260000 	eorcc	r0, r6, r0
    34e4:	1800000c 	stmdane	r0, {r2, r3}
    34e8:	00000050 	andeq	r0, r0, r0, asr r0
    34ec:	00000eb6 			; <UNDEFINED> instruction: 0x00000eb6
    34f0:	00008529 	andeq	r8, r0, r9, lsr #10
    34f4:	00023f00 	andeq	r3, r2, r0, lsl #30
    34f8:	000ea503 	andeq	sl, lr, r3, lsl #10
    34fc:	0c3d2600 	ldceq	6, cr2, [sp], #-0
    3500:	ae2a0000 	cdpge	0, 2, cr0, cr10, cr0, {0}
    3504:	01000001 	tsteq	r0, r1
    3508:	0eda065d 	mrceq	6, 6, r0, cr10, cr13, {2}
    350c:	9b740000 	blls	1d03514 <__bss_end+0x1cf92a8>
    3510:	00b00000 	adcseq	r0, r0, r0
    3514:	9c010000 	stcls	0, cr0, [r1], {-0}
    3518:	00000f2d 	andeq	r0, r0, sp, lsr #30
    351c:	001a472b 	andseq	r4, sl, fp, lsr #14
    3520:	0001ec00 	andeq	lr, r1, r0, lsl #24
    3524:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3528:	0100782c 	tsteq	r0, ip, lsr #16
    352c:	005c295d 	subseq	r2, ip, sp, asr r9
    3530:	91020000 	mrsls	r0, (UNDEF: 2)
    3534:	00792c6a 	rsbseq	r2, r9, sl, ror #24
    3538:	5c355d01 	ldcpl	13, cr5, [r5], #-4
    353c:	02000000 	andeq	r0, r0, #0
    3540:	732c6891 			; <UNDEFINED> instruction: 0x732c6891
    3544:	01007274 	tsteq	r0, r4, ror r2
    3548:	01f1445d 	mvnseq	r4, sp, asr r4
    354c:	91020000 	mrsls	r0, (UNDEF: 2)
    3550:	69782d64 	ldmdbvs	r8!, {r2, r5, r6, r8, sl, fp, sp}^
    3554:	0e620100 	poweqs	f0, f2, f0
    3558:	0000005c 	andeq	r0, r0, ip, asr r0
    355c:	2d769102 	ldfcsp	f1, [r6, #-8]!
    3560:	00727470 	rsbseq	r7, r2, r0, ror r4
    3564:	f1116301 			; <UNDEFINED> instruction: 0xf1116301
    3568:	02000001 	andeq	r0, r0, #1
    356c:	2a007091 	bcs	1f7b8 <__bss_end+0x1554c>
    3570:	0000011f 	andeq	r0, r0, pc, lsl r1
    3574:	47065201 	strmi	r5, [r6, -r1, lsl #4]
    3578:	1c00000f 	stcne	0, cr0, [r0], {15}
    357c:	5800009b 	stmdapl	r0, {r0, r1, r3, r4, r7}
    3580:	01000000 	mrseq	r0, (UNDEF: 0)
    3584:	000f639c 	muleq	pc, ip, r3	; <UNPREDICTABLE>
    3588:	1a472b00 	bne	11ce190 <__bss_end+0x11c3f24>
    358c:	01ec0000 	mvneq	r0, r0
    3590:	91020000 	mrsls	r0, (UNDEF: 2)
    3594:	6b702d6c 	blvs	1c0eb4c <__bss_end+0x1c048e0>
    3598:	57010074 	smlsdxpl	r1, r4, r0, r0
    359c:	000a2423 	andeq	r2, sl, r3, lsr #8
    35a0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    35a4:	01842a00 	orreq	r2, r4, r0, lsl #20
    35a8:	3a010000 	bcc	435b0 <__bss_end+0x39344>
    35ac:	000f7d06 	andeq	r7, pc, r6, lsl #26
    35b0:	0099b400 	addseq	fp, r9, r0, lsl #8
    35b4:	00016800 	andeq	r6, r1, r0, lsl #16
    35b8:	cf9c0100 	svcgt	0x009c0100
    35bc:	2b00000f 	blcs	3600 <shift+0x3600>
    35c0:	00001a47 	andeq	r1, r0, r7, asr #20
    35c4:	000001ec 	andeq	r0, r0, ip, ror #3
    35c8:	2c5c9102 	ldfcsp	f1, [ip], {2}
    35cc:	3a010078 	bcc	437b4 <__bss_end+0x39548>
    35d0:	00005c27 	andeq	r5, r0, r7, lsr #24
    35d4:	5a910200 	bpl	fe443ddc <__bss_end+0xfe439b70>
    35d8:	0100792c 	tsteq	r0, ip, lsr #18
    35dc:	005c333a 	subseq	r3, ip, sl, lsr r3
    35e0:	91020000 	mrsls	r0, (UNDEF: 2)
    35e4:	00632c58 	rsbeq	r2, r3, r8, asr ip
    35e8:	253b3a01 	ldrcs	r3, [fp, #-2561]!	; 0xfffff5ff
    35ec:	02000000 	andeq	r0, r0, #0
    35f0:	622d5791 	eorvs	r5, sp, #38010880	; 0x2440000
    35f4:	01006675 	tsteq	r0, r5, ror r6
    35f8:	0fcf0a43 	svceq	0x00cf0a43
    35fc:	91020000 	mrsls	r0, (UNDEF: 2)
    3600:	74702d60 	ldrbtvc	r2, [r0], #-3424	; 0xfffff2a0
    3604:	45010072 	strmi	r0, [r1, #-114]	; 0xffffff8e
    3608:	000fdf1e 	andeq	sp, pc, lr, lsl pc	; <UNPREDICTABLE>
    360c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3610:	00251800 	eoreq	r1, r5, r0, lsl #16
    3614:	0fdf0000 	svceq	0x00df0000
    3618:	85190000 	ldrhi	r0, [r9, #-0]
    361c:	10000000 	andne	r0, r0, r0
    3620:	9c040d00 	stcls	13, cr0, [r4], {-0}
    3624:	2a00000a 	bcs	3654 <shift+0x3654>
    3628:	0000015a 	andeq	r0, r0, sl, asr r1
    362c:	ff062b01 			; <UNDEFINED> instruction: 0xff062b01
    3630:	c800000f 	stmdagt	r0, {r0, r1, r2, r3}
    3634:	ec000098 	stc	0, cr0, [r0], {152}	; 0x98
    3638:	01000000 	mrseq	r0, (UNDEF: 0)
    363c:	0010449c 	mulseq	r0, ip, r4
    3640:	1a472b00 	bne	11ce248 <__bss_end+0x11c3fdc>
    3644:	01ec0000 	mvneq	r0, r0
    3648:	91020000 	mrsls	r0, (UNDEF: 2)
    364c:	00782c6c 	rsbseq	r2, r8, ip, ror #24
    3650:	5c282b01 			; <UNDEFINED> instruction: 0x5c282b01
    3654:	02000000 	andeq	r0, r0, #0
    3658:	792c6a91 	stmdbvc	ip!, {r0, r4, r7, r9, fp, sp, lr}
    365c:	342b0100 	strtcc	r0, [fp], #-256	; 0xffffff00
    3660:	0000005c 	andeq	r0, r0, ip, asr r0
    3664:	2c689102 	stfcsp	f1, [r8], #-8
    3668:	00746573 	rsbseq	r6, r4, r3, ror r5
    366c:	da3c2b01 	ble	f0e278 <__bss_end+0xf0400c>
    3670:	02000001 	andeq	r0, r0, #1
    3674:	702d6791 	mlavc	sp, r1, r7, r6
    3678:	0100746b 	tsteq	r0, fp, ror #8
    367c:	0a672631 	beq	19ccf48 <__bss_end+0x19c2cdc>
    3680:	91020000 	mrsls	r0, (UNDEF: 2)
    3684:	3a2a0070 	bcc	a8384c <__bss_end+0xa795e0>
    3688:	01000001 	tsteq	r0, r1
    368c:	105e0620 	subsne	r0, lr, r0, lsr #12
    3690:	984c0000 	stmdals	ip, {}^	; <UNPREDICTABLE>
    3694:	007c0000 	rsbseq	r0, ip, r0
    3698:	9c010000 	stcls	0, cr0, [r1], {-0}
    369c:	00001089 	andeq	r1, r0, r9, lsl #1
    36a0:	001a472b 	andseq	r4, sl, fp, lsr #14
    36a4:	0001ec00 	andeq	lr, r1, r0, lsl #24
    36a8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    36ac:	001b6d2e 	andseq	r6, fp, lr, lsr #26
    36b0:	20200100 	eorcs	r0, r0, r0, lsl #2
    36b4:	000001da 	ldrdeq	r0, [r0], -sl
    36b8:	2d6b9102 	stfcsp	f1, [fp, #-8]!
    36bc:	00746b70 	rsbseq	r6, r4, r0, ror fp
    36c0:	3f1b2501 	svccc	0x001b2501
    36c4:	0200000a 	andeq	r0, r0, #10
    36c8:	2f007491 	svccs	0x00007491
    36cc:	00000100 	andeq	r0, r0, r0, lsl #2
    36d0:	a3061b01 	movwge	r1, #27393	; 0x6b01
    36d4:	24000010 	strcs	r0, [r0], #-16
    36d8:	28000098 	stmdacs	r0, {r3, r4, r7}
    36dc:	01000000 	mrseq	r0, (UNDEF: 0)
    36e0:	0010b09c 	mulseq	r0, ip, r0
    36e4:	1a472b00 	bne	11ce2ec <__bss_end+0x11c4080>
    36e8:	01ff0000 	mvnseq	r0, r0
    36ec:	91020000 	mrsls	r0, (UNDEF: 2)
    36f0:	dc300074 	ldcle	0, cr0, [r0], #-464	; 0xfffffe30
    36f4:	01000000 	mrseq	r0, (UNDEF: 0)
    36f8:	10c10111 	sbcne	r0, r1, r1, lsl r1
    36fc:	d4000000 	strle	r0, [r0], #-0
    3700:	31000010 	tstcc	r0, r0, lsl r0
    3704:	00001a47 	andeq	r1, r0, r7, asr #20
    3708:	000001ec 	andeq	r0, r0, ip, ror #3
    370c:	001a0831 	andseq	r0, sl, r1, lsr r8
    3710:	00003f00 	andeq	r3, r0, r0, lsl #30
    3714:	b0320000 	eorslt	r0, r2, r0
    3718:	b5000010 	strlt	r0, [r0, #-16]
    371c:	ef00001b 	svc	0x0000001b
    3720:	d8000010 	stmdale	r0, {r4}
    3724:	4c000097 	stcmi	0, cr0, [r0], {151}	; 0x97
    3728:	01000000 	mrseq	r0, (UNDEF: 0)
    372c:	0010f89c 	mulseq	r0, ip, r8
    3730:	10c13300 	sbcne	r3, r1, r0, lsl #6
    3734:	91020000 	mrsls	r0, (UNDEF: 2)
    3738:	b8300074 	ldmdalt	r0!, {r2, r4, r5, r6}
    373c:	01000000 	mrseq	r0, (UNDEF: 0)
    3740:	1109010a 	tstne	r9, sl, lsl #2
    3744:	1f000000 	svcne	0x00000000
    3748:	31000011 	tstcc	r0, r1, lsl r0
    374c:	00001a47 	andeq	r1, r0, r7, asr #20
    3750:	000001ec 	andeq	r0, r0, ip, ror #3
    3754:	001ae934 	andseq	lr, sl, r4, lsr r9
    3758:	2a0a0100 	bcs	283b60 <__bss_end+0x2798f4>
    375c:	000001f1 	strdeq	r0, [r0], -r1
    3760:	10f83500 	rscsne	r3, r8, r0, lsl #10
    3764:	1b760000 	blne	1d8376c <__bss_end+0x1d79500>
    3768:	11360000 	teqne	r6, r0
    376c:	97700000 	ldrbls	r0, [r0, -r0]!
    3770:	00680000 	rsbeq	r0, r8, r0
    3774:	9c010000 	stcls	0, cr0, [r1], {-0}
    3778:	00110933 	andseq	r0, r1, r3, lsr r9
    377c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3780:	00111233 	andseq	r1, r1, r3, lsr r2
    3784:	70910200 	addsvc	r0, r1, r0, lsl #4
    3788:	00220000 	eoreq	r0, r2, r0
    378c:	00020000 	andeq	r0, r2, r0
    3790:	00000c28 	andeq	r0, r0, r8, lsr #24
    3794:	11370104 	teqne	r7, r4, lsl #2
    3798:	9c240000 	stcls	0, cr0, [r4], #-0
    379c:	9e300000 	cdpls	0, 3, cr0, cr0, cr0, {0}
    37a0:	1bcc0000 	blne	ff3037a8 <__bss_end+0xff2f953c>
    37a4:	1bfc0000 	blne	fff037ac <__bss_end+0xffef9540>
    37a8:	00630000 	rsbeq	r0, r3, r0
    37ac:	80010000 	andhi	r0, r1, r0
    37b0:	00000022 	andeq	r0, r0, r2, lsr #32
    37b4:	0c3c0002 	ldceq	0, cr0, [ip], #-8
    37b8:	01040000 	mrseq	r0, (UNDEF: 4)
    37bc:	000011b4 			; <UNDEFINED> instruction: 0x000011b4
    37c0:	00009e30 	andeq	r9, r0, r0, lsr lr
    37c4:	00009e34 	andeq	r9, r0, r4, lsr lr
    37c8:	00001bcc 	andeq	r1, r0, ip, asr #23
    37cc:	00001bfc 	strdeq	r1, [r0], -ip
    37d0:	00000063 	andeq	r0, r0, r3, rrx
    37d4:	09328001 	ldmdbeq	r2!, {r0, pc}
    37d8:	00040000 	andeq	r0, r4, r0
    37dc:	00000c50 	andeq	r0, r0, r0, asr ip
    37e0:	1fca0104 	svcne	0x00ca0104
    37e4:	210c0000 	mrscs	r0, (UNDEF: 12)
    37e8:	fc00001f 	stc2	0, cr0, [r0], {31}
    37ec:	1400001b 	strne	r0, [r0], #-27	; 0xffffffe5
    37f0:	02000012 	andeq	r0, r0, #18
    37f4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    37f8:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    37fc:	0020f707 	eoreq	pc, r0, r7, lsl #14
    3800:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    3804:	0000031f 	andeq	r0, r0, pc, lsl r3
    3808:	c9040803 	stmdbgt	r4, {r0, r1, fp}
    380c:	04000027 	streq	r0, [r0], #-39	; 0xffffffd9
    3810:	00001f7c 	andeq	r1, r0, ip, ror pc
    3814:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    3818:	04000000 	streq	r0, [r0], #-0
    381c:	000023eb 	andeq	r2, r0, fp, ror #7
    3820:	51152f01 	tstpl	r5, r1, lsl #30
    3824:	05000000 	streq	r0, [r0, #-0]
    3828:	00005704 	andeq	r5, r0, r4, lsl #14
    382c:	00390600 	eorseq	r0, r9, r0, lsl #12
    3830:	00660000 	rsbeq	r0, r6, r0
    3834:	66070000 	strvs	r0, [r7], -r0
    3838:	00000000 	andeq	r0, r0, r0
    383c:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    3840:	04080000 	streq	r0, [r8], #-0
    3844:	00002b1d 	andeq	r2, r0, sp, lsl fp
    3848:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    384c:	05000000 	streq	r0, [r0, #-0]
    3850:	00007f04 	andeq	r7, r0, r4, lsl #30
    3854:	001d0600 	andseq	r0, sp, r0, lsl #12
    3858:	00930000 	addseq	r0, r3, r0
    385c:	66070000 	strvs	r0, [r7], -r0
    3860:	07000000 	streq	r0, [r0, -r0]
    3864:	00000066 	andeq	r0, r0, r6, rrx
    3868:	08010300 	stmdaeq	r1, {r8, r9}
    386c:	000010b0 	strheq	r1, [r0], -r0
    3870:	00262309 	eoreq	r2, r6, r9, lsl #6
    3874:	12bb0100 	adcsne	r0, fp, #0, 2
    3878:	00000045 	andeq	r0, r0, r5, asr #32
    387c:	002b4b09 	eoreq	r4, fp, r9, lsl #22
    3880:	10be0100 	adcsne	r0, lr, r0, lsl #2
    3884:	0000006d 	andeq	r0, r0, sp, rrx
    3888:	b2060103 	andlt	r0, r6, #-1073741824	; 0xc0000000
    388c:	0a000010 	beq	38d4 <shift+0x38d4>
    3890:	0000230b 	andeq	r2, r0, fp, lsl #6
    3894:	00930107 	addseq	r0, r3, r7, lsl #2
    3898:	17020000 	strne	r0, [r2, -r0]
    389c:	0001e606 	andeq	lr, r1, r6, lsl #12
    38a0:	1dda0b00 	vldrne	d16, [sl]
    38a4:	0b000000 	bleq	38ac <shift+0x38ac>
    38a8:	00002228 	andeq	r2, r0, r8, lsr #4
    38ac:	26ee0b01 	strbtcs	r0, [lr], r1, lsl #22
    38b0:	0b020000 	bleq	838b8 <__bss_end+0x7964c>
    38b4:	00002a5f 	andeq	r2, r0, pc, asr sl
    38b8:	26920b03 	ldrcs	r0, [r2], r3, lsl #22
    38bc:	0b040000 	bleq	1038c4 <__bss_end+0xf9658>
    38c0:	00002968 	andeq	r2, r0, r8, ror #18
    38c4:	28cc0b05 	stmiacs	ip, {r0, r2, r8, r9, fp}^
    38c8:	0b060000 	bleq	1838d0 <__bss_end+0x179664>
    38cc:	00001dfb 	strdeq	r1, [r0], -fp
    38d0:	297d0b07 	ldmdbcs	sp!, {r0, r1, r2, r8, r9, fp}^
    38d4:	0b080000 	bleq	2038dc <__bss_end+0x1f9670>
    38d8:	0000298b 	andeq	r2, r0, fp, lsl #19
    38dc:	2a520b09 	bcs	1486508 <__bss_end+0x147c29c>
    38e0:	0b0a0000 	bleq	2838e8 <__bss_end+0x27967c>
    38e4:	000025e9 	andeq	r2, r0, r9, ror #11
    38e8:	1fbd0b0b 	svcne	0x00bd0b0b
    38ec:	0b0c0000 	bleq	3038f4 <__bss_end+0x2f9688>
    38f0:	0000209a 	muleq	r0, sl, r0
    38f4:	234f0b0d 	movtcs	r0, #64269	; 0xfb0d
    38f8:	0b0e0000 	bleq	383900 <__bss_end+0x379694>
    38fc:	00002365 	andeq	r2, r0, r5, ror #6
    3900:	22620b0f 	rsbcs	r0, r2, #15360	; 0x3c00
    3904:	0b100000 	bleq	40390c <__bss_end+0x3f96a0>
    3908:	00002676 	andeq	r2, r0, r6, ror r6
    390c:	22ce0b11 	sbccs	r0, lr, #17408	; 0x4400
    3910:	0b120000 	bleq	483918 <__bss_end+0x4796ac>
    3914:	00002ce4 	andeq	r2, r0, r4, ror #25
    3918:	1e640b13 	vmovne.8	d4[4], r0
    391c:	0b140000 	bleq	503924 <__bss_end+0x4f96b8>
    3920:	000022f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    3924:	1da10b15 			; <UNDEFINED> instruction: 0x1da10b15
    3928:	0b160000 	bleq	583930 <__bss_end+0x5796c4>
    392c:	00002a82 	andeq	r2, r0, r2, lsl #21
    3930:	2ba40b17 	blcs	fe906594 <__bss_end+0xfe8fc328>
    3934:	0b180000 	bleq	60393c <__bss_end+0x5f96d0>
    3938:	00002317 	andeq	r2, r0, r7, lsl r3
    393c:	27600b19 			; <UNDEFINED> instruction: 0x27600b19
    3940:	0b1a0000 	bleq	683948 <__bss_end+0x6796dc>
    3944:	00002a90 	muleq	r0, r0, sl
    3948:	1cd00b1b 	fldmiaxne	r0, {d16-d28}	;@ Deprecated
    394c:	0b1c0000 	bleq	703954 <__bss_end+0x6f96e8>
    3950:	00002a9e 	muleq	r0, lr, sl
    3954:	2aac0b1d 	bcs	feb065d0 <__bss_end+0xfeafc364>
    3958:	0b1e0000 	bleq	783960 <__bss_end+0x7796f4>
    395c:	00001c7e 	andeq	r1, r0, lr, ror ip
    3960:	2ad60b1f 	bcs	ff5865e4 <__bss_end+0xff57c378>
    3964:	0b200000 	bleq	80396c <__bss_end+0x7f9700>
    3968:	0000280d 	andeq	r2, r0, sp, lsl #16
    396c:	26480b21 	strbcs	r0, [r8], -r1, lsr #22
    3970:	0b220000 	bleq	883978 <__bss_end+0x87970c>
    3974:	00002a75 	andeq	r2, r0, r5, ror sl
    3978:	254c0b23 	strbcs	r0, [ip, #-2851]	; 0xfffff4dd
    397c:	0b240000 	bleq	903984 <__bss_end+0x8f9718>
    3980:	0000244e 	andeq	r2, r0, lr, asr #8
    3984:	21680b25 	cmncs	r8, r5, lsr #22
    3988:	0b260000 	bleq	983990 <__bss_end+0x979724>
    398c:	0000246c 	andeq	r2, r0, ip, ror #8
    3990:	22040b27 	andcs	r0, r4, #39936	; 0x9c00
    3994:	0b280000 	bleq	a0399c <__bss_end+0x9f9730>
    3998:	0000247c 	andeq	r2, r0, ip, ror r4
    399c:	248c0b29 	strcs	r0, [ip], #2857	; 0xb29
    39a0:	0b2a0000 	bleq	a839a8 <__bss_end+0xa7973c>
    39a4:	000025cf 	andeq	r2, r0, pc, asr #11
    39a8:	23f50b2b 	mvnscs	r0, #44032	; 0xac00
    39ac:	0b2c0000 	bleq	b039b4 <__bss_end+0xaf9748>
    39b0:	0000281a 	andeq	r2, r0, sl, lsl r8
    39b4:	21a90b2d 			; <UNDEFINED> instruction: 0x21a90b2d
    39b8:	002e0000 	eoreq	r0, lr, r0
    39bc:	0023870a 	eoreq	r8, r3, sl, lsl #14
    39c0:	93010700 	movwls	r0, #5888	; 0x1700
    39c4:	03000000 	movweq	r0, #0
    39c8:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    39cc:	bc0b0000 	stclt	0, cr0, [fp], {-0}
    39d0:	00000020 	andeq	r0, r0, r0, lsr #32
    39d4:	001d0e0b 	andseq	r0, sp, fp, lsl #28
    39d8:	920b0100 	andls	r0, fp, #0, 2
    39dc:	0200002c 	andeq	r0, r0, #44	; 0x2c
    39e0:	002b250b 	eoreq	r2, fp, fp, lsl #10
    39e4:	dc0b0300 	stcle	3, cr0, [fp], {-0}
    39e8:	04000020 	streq	r0, [r0], #-32	; 0xffffffe0
    39ec:	001dc60b 	andseq	ip, sp, fp, lsl #12
    39f0:	850b0500 	strhi	r0, [fp, #-1280]	; 0xfffffb00
    39f4:	06000021 	streq	r0, [r0], -r1, lsr #32
    39f8:	0020cc0b 	eoreq	ip, r0, fp, lsl #24
    39fc:	b90b0700 	stmdblt	fp, {r8, r9, sl}
    3a00:	08000029 	stmdaeq	r0, {r0, r3, r5}
    3a04:	002b0a0b 	eoreq	r0, fp, fp, lsl #20
    3a08:	f00b0900 			; <UNDEFINED> instruction: 0xf00b0900
    3a0c:	0a000028 	beq	3ab4 <shift+0x3ab4>
    3a10:	001e190b 	andseq	r1, lr, fp, lsl #18
    3a14:	260b0b00 	strcs	r0, [fp], -r0, lsl #22
    3a18:	0c000021 	stceq	0, cr0, [r0], {33}	; 0x21
    3a1c:	001d8f0b 	andseq	r8, sp, fp, lsl #30
    3a20:	c70b0d00 	strgt	r0, [fp, -r0, lsl #26]
    3a24:	0e00002c 	cdpeq	0, 0, cr0, cr0, cr12, {1}
    3a28:	0025bc0b 	eoreq	fp, r5, fp, lsl #24
    3a2c:	990b0f00 	stmdbls	fp, {r8, r9, sl, fp}
    3a30:	10000022 	andne	r0, r0, r2, lsr #32
    3a34:	0025f90b 	eoreq	pc, r5, fp, lsl #18
    3a38:	e60b1100 	str	r1, [fp], -r0, lsl #2
    3a3c:	1200002b 	andne	r0, r0, #43	; 0x2b
    3a40:	001edc0b 	andseq	sp, lr, fp, lsl #24
    3a44:	ac0b1300 	stcge	3, cr1, [fp], {-0}
    3a48:	14000022 	strne	r0, [r0], #-34	; 0xffffffde
    3a4c:	00250f0b 	eoreq	r0, r5, fp, lsl #30
    3a50:	a70b1500 	strge	r1, [fp, -r0, lsl #10]
    3a54:	16000020 	strne	r0, [r0], -r0, lsr #32
    3a58:	00255b0b 	eoreq	r5, r5, fp, lsl #22
    3a5c:	710b1700 	tstvc	fp, r0, lsl #14
    3a60:	18000023 	stmdane	r0, {r0, r1, r5}
    3a64:	001de40b 	andseq	lr, sp, fp, lsl #8
    3a68:	8d0b1900 	vstrhi.16	s2, [fp, #-0]	; <UNPREDICTABLE>
    3a6c:	1a00002b 	bne	3b20 <shift+0x3b20>
    3a70:	0024db0b 	eoreq	sp, r4, fp, lsl #22
    3a74:	830b1b00 	movwhi	r1, #47872	; 0xbb00
    3a78:	1c000022 	stcne	0, cr0, [r0], {34}	; 0x22
    3a7c:	001cb90b 	andseq	fp, ip, fp, lsl #18
    3a80:	260b1d00 	strcs	r1, [fp], -r0, lsl #26
    3a84:	1e000024 	cdpne	0, 0, cr0, cr0, cr4, {1}
    3a88:	0024120b 	eoreq	r1, r4, fp, lsl #4
    3a8c:	ad0b1f00 	stcge	15, cr1, [fp, #-0]
    3a90:	20000028 	andcs	r0, r0, r8, lsr #32
    3a94:	0029380b 	eoreq	r3, r9, fp, lsl #16
    3a98:	6c0b2100 	stfvss	f2, [fp], {-0}
    3a9c:	2200002b 	andcs	r0, r0, #43	; 0x2b
    3aa0:	0021b60b 	eoreq	fp, r1, fp, lsl #12
    3aa4:	100b2300 	andne	r2, fp, r0, lsl #6
    3aa8:	24000027 	strcs	r0, [r0], #-39	; 0xffffffd9
    3aac:	0029050b 	eoreq	r0, r9, fp, lsl #10
    3ab0:	290b2500 	stmdbcs	fp, {r8, sl, sp}
    3ab4:	26000028 	strcs	r0, [r0], -r8, lsr #32
    3ab8:	00283d0b 	eoreq	r3, r8, fp, lsl #26
    3abc:	510b2700 	tstpl	fp, r0, lsl #14
    3ac0:	28000028 	stmdacs	r0, {r3, r5}
    3ac4:	001f670b 	andseq	r6, pc, fp, lsl #14
    3ac8:	c70b2900 	strgt	r2, [fp, -r0, lsl #18]
    3acc:	2a00001e 	bcs	3b4c <shift+0x3b4c>
    3ad0:	001eef0b 	andseq	lr, lr, fp, lsl #30
    3ad4:	020b2b00 	andeq	r2, fp, #0, 22
    3ad8:	2c00002a 	stccs	0, cr0, [r0], {42}	; 0x2a
    3adc:	001f440b 	andseq	r4, pc, fp, lsl #8
    3ae0:	160b2d00 	strne	r2, [fp], -r0, lsl #26
    3ae4:	2e00002a 	cdpcs	0, 0, cr0, cr0, cr10, {1}
    3ae8:	002a2a0b 	eoreq	r2, sl, fp, lsl #20
    3aec:	3e0b2f00 	cdpcc	15, 0, cr2, cr11, cr0, {0}
    3af0:	3000002a 	andcc	r0, r0, sl, lsr #32
    3af4:	0021380b 	eoreq	r3, r1, fp, lsl #16
    3af8:	120b3100 	andne	r3, fp, #0, 2
    3afc:	32000021 	andcc	r0, r0, #33	; 0x21
    3b00:	00243a0b 	eoreq	r3, r4, fp, lsl #20
    3b04:	0c0b3300 	stceq	3, cr3, [fp], {-0}
    3b08:	34000026 	strcc	r0, [r0], #-38	; 0xffffffda
    3b0c:	002c1b0b 	eoreq	r1, ip, fp, lsl #22
    3b10:	610b3500 	tstvs	fp, r0, lsl #10
    3b14:	3600001c 			; <UNDEFINED> instruction: 0x3600001c
    3b18:	0022380b 	eoreq	r3, r2, fp, lsl #16
    3b1c:	4d0b3700 	stcmi	7, cr3, [fp, #-0]
    3b20:	38000022 	stmdacc	r0, {r1, r5}
    3b24:	00249c0b 	eoreq	r9, r4, fp, lsl #24
    3b28:	c60b3900 	strgt	r3, [fp], -r0, lsl #18
    3b2c:	3a000024 	bcc	3bc4 <shift+0x3bc4>
    3b30:	002c440b 	eoreq	r4, ip, fp, lsl #8
    3b34:	fb0b3b00 	blx	2d273e <__bss_end+0x2c84d2>
    3b38:	3c000026 	stccc	0, cr0, [r0], {38}	; 0x26
    3b3c:	0021db0b 	eoreq	sp, r1, fp, lsl #22
    3b40:	200b3d00 	andcs	r3, fp, r0, lsl #26
    3b44:	3e00001d 	mcrcc	0, 0, r0, cr0, cr13, {0}
    3b48:	001cde0b 	andseq	sp, ip, fp, lsl #28
    3b4c:	580b3f00 	stmdapl	fp, {r8, r9, sl, fp, ip, sp}
    3b50:	40000026 	andmi	r0, r0, r6, lsr #32
    3b54:	00277c0b 	eoreq	r7, r7, fp, lsl #24
    3b58:	8f0b4100 	svchi	0x000b4100
    3b5c:	42000028 	andmi	r0, r0, #40	; 0x28
    3b60:	0024b10b 	eoreq	fp, r4, fp, lsl #2
    3b64:	7d0b4300 	stcvc	3, cr4, [fp, #-0]
    3b68:	4400002c 	strmi	r0, [r0], #-44	; 0xffffffd4
    3b6c:	0027260b 	eoreq	r2, r7, fp, lsl #12
    3b70:	0b0b4500 	bleq	2d4f78 <__bss_end+0x2cad0c>
    3b74:	4600001f 			; <UNDEFINED> instruction: 0x4600001f
    3b78:	00258c0b 	eoreq	r8, r5, fp, lsl #24
    3b7c:	bf0b4700 	svclt	0x000b4700
    3b80:	48000023 	stmdami	r0, {r0, r1, r5}
    3b84:	001c9d0b 	andseq	r9, ip, fp, lsl #26
    3b88:	b10b4900 	tstlt	fp, r0, lsl #18
    3b8c:	4a00001d 	bmi	3c08 <shift+0x3c08>
    3b90:	0021ef0b 	eoreq	lr, r1, fp, lsl #30
    3b94:	ed0b4b00 	vstr	d4, [fp, #-0]
    3b98:	4c000024 	stcmi	0, cr0, [r0], {36}	; 0x24
    3b9c:	07020300 	streq	r0, [r2, -r0, lsl #6]
    3ba0:	0000126b 	andeq	r1, r0, fp, ror #4
    3ba4:	0003e40c 	andeq	lr, r3, ip, lsl #8
    3ba8:	0003d900 	andeq	sp, r3, r0, lsl #18
    3bac:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    3bb0:	000003ce 	andeq	r0, r0, lr, asr #7
    3bb4:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    3bb8:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    3bbc:	03000003 	movweq	r0, #3
    3bc0:	10b90801 	adcsne	r0, r9, r1, lsl #16
    3bc4:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    3bc8:	0f000003 	svceq	0x00000003
    3bcc:	00001e55 	andeq	r1, r0, r5, asr lr
    3bd0:	1a014c04 	bne	56be8 <__bss_end+0x4c97c>
    3bd4:	000003d9 	ldrdeq	r0, [r0], -r9
    3bd8:	0022730f 	eoreq	r7, r2, pc, lsl #6
    3bdc:	01820400 	orreq	r0, r2, r0, lsl #8
    3be0:	0003d91a 	andeq	sp, r3, sl, lsl r9
    3be4:	03e90c00 	mvneq	r0, #0, 24
    3be8:	041a0000 	ldreq	r0, [sl], #-0
    3bec:	000d0000 	andeq	r0, sp, r0
    3bf0:	00245e09 	eoreq	r5, r4, r9, lsl #28
    3bf4:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    3bf8:	0000040f 	andeq	r0, r0, pc, lsl #8
    3bfc:	002ae609 	eoreq	lr, sl, r9, lsl #12
    3c00:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    3c04:	000001e6 	andeq	r0, r0, r6, ror #3
    3c08:	00214c0a 	eoreq	r4, r1, sl, lsl #24
    3c0c:	93010700 	movwls	r0, #5888	; 0x1700
    3c10:	05000000 	streq	r0, [r0, #-0]
    3c14:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    3c18:	b20b0000 	andlt	r0, fp, #0
    3c1c:	0000001c 	andeq	r0, r0, ip, lsl r0
    3c20:	00235e0b 	eoreq	r5, r3, fp, lsl #28
    3c24:	f80b0100 			; <UNDEFINED> instruction: 0xf80b0100
    3c28:	0200002b 	andeq	r0, r0, #43	; 0x2b
    3c2c:	002bbb0b 	eoreq	fp, fp, fp, lsl #22
    3c30:	b50b0300 	strlt	r0, [fp, #-768]	; 0xfffffd00
    3c34:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    3c38:	0029760b 	eoreq	r7, r9, fp, lsl #12
    3c3c:	980b0500 	stmdals	fp, {r8, sl}
    3c40:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    3c44:	001e7a0b 	andseq	r7, lr, fp, lsl #20
    3c48:	930b0700 	movwls	r0, #46848	; 0xb700
    3c4c:	08000020 	stmdaeq	r0, {r5}
    3c50:	0025710b 	eoreq	r7, r5, fp, lsl #2
    3c54:	9f0b0900 	svcls	0x000b0900
    3c58:	0a00001e 	beq	3cd8 <shift+0x3cd8>
    3c5c:	0025780b 	eoreq	r7, r5, fp, lsl #16
    3c60:	040b0b00 	streq	r0, [fp], #-2816	; 0xfffff500
    3c64:	0c00001f 	stceq	0, cr0, [r0], {31}
    3c68:	001e910b 	andseq	r9, lr, fp, lsl #2
    3c6c:	cd0b0d00 	stcgt	13, cr0, [fp, #-0]
    3c70:	0e000029 	cdpeq	0, 0, cr0, cr0, cr9, {1}
    3c74:	00279a0b 	eoreq	r9, r7, fp, lsl #20
    3c78:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    3c7c:	000028c5 	andeq	r2, r0, r5, asr #17
    3c80:	32013f05 	andcc	r3, r1, #5, 30
    3c84:	09000004 	stmdbeq	r0, {r2}
    3c88:	00002959 	andeq	r2, r0, r9, asr r9
    3c8c:	a50f4105 	strge	r4, [pc, #-261]	; 3b8f <shift+0x3b8f>
    3c90:	09000004 	stmdbeq	r0, {r2}
    3c94:	000029e1 	andeq	r2, r0, r1, ror #19
    3c98:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    3c9c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3ca0:	00001e39 	andeq	r1, r0, r9, lsr lr
    3ca4:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    3ca8:	10000000 	andne	r0, r0, r0
    3cac:	00002aba 			; <UNDEFINED> instruction: 0x00002aba
    3cb0:	0029f209 	eoreq	pc, r9, r9, lsl #4
    3cb4:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    3cb8:	000004e6 	andeq	r0, r0, r6, ror #9
    3cbc:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    3cc0:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    3cc4:	00002328 	andeq	r2, r0, r8, lsr #6
    3cc8:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    3ccc:	05000004 	streq	r0, [r0, #-4]
    3cd0:	0004ec04 	andeq	lr, r4, r4, lsl #24
    3cd4:	28db1200 	ldmcs	fp, {r9, ip}^
    3cd8:	a2090000 	andge	r0, r9, #0
    3cdc:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    3ce0:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    3ce4:	04050000 	streq	r0, [r5], #-0
    3ce8:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3cec:	001fb013 	andseq	fp, pc, r3, lsl r0	; <UNPREDICTABLE>
    3cf0:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    3cf4:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    3cf8:	67140000 	ldrvs	r0, [r4, -r0]
    3cfc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    3d00:	de0f0169 	adfleez	f0, f7, #1.0
    3d04:	00000003 	andeq	r0, r0, r3
    3d08:	001f9414 	andseq	r9, pc, r4, lsl r4	; <UNPREDICTABLE>
    3d0c:	016a0500 	cmneq	sl, r0, lsl #10
    3d10:	00054614 	andeq	r4, r5, r4, lsl r6
    3d14:	0e000400 	cfcpyseq	mvf0, mvf0
    3d18:	00000516 	andeq	r0, r0, r6, lsl r5
    3d1c:	0000b90c 	andeq	fp, r0, ip, lsl #18
    3d20:	00055600 	andeq	r5, r5, r0, lsl #12
    3d24:	00241500 	eoreq	r1, r4, r0, lsl #10
    3d28:	002d0000 	eoreq	r0, sp, r0
    3d2c:	0005410c 	andeq	r4, r5, ip, lsl #2
    3d30:	00056100 	andeq	r6, r5, r0, lsl #2
    3d34:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    3d38:	00000556 	andeq	r0, r0, r6, asr r5
    3d3c:	0023960f 	eoreq	r9, r3, pc, lsl #12
    3d40:	016b0500 	cmneq	fp, r0, lsl #10
    3d44:	00056103 	andeq	r6, r5, r3, lsl #2
    3d48:	25dc0f00 	ldrbcs	r0, [ip, #3840]	; 0xf00
    3d4c:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    3d50:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3d54:	19160000 	ldmdbne	r6, {}	; <UNPREDICTABLE>
    3d58:	07000029 	streq	r0, [r0, -r9, lsr #32]
    3d5c:	00009301 	andeq	r9, r0, r1, lsl #6
    3d60:	01810500 	orreq	r0, r1, r0, lsl #10
    3d64:	00062a06 	andeq	r2, r6, r6, lsl #20
    3d68:	1d470b00 	vstrne	d16, [r7, #-0]
    3d6c:	0b000000 	bleq	3d74 <shift+0x3d74>
    3d70:	00001d53 	andeq	r1, r0, r3, asr sp
    3d74:	1d5f0b02 	vldrne	d16, [pc, #-8]	; 3d74 <shift+0x3d74>
    3d78:	0b030000 	bleq	c3d80 <__bss_end+0xb9b14>
    3d7c:	00002178 	andeq	r2, r0, r8, ror r1
    3d80:	1d6b0b03 	fstmdbxne	fp!, {d16}	;@ Deprecated
    3d84:	0b040000 	bleq	103d8c <__bss_end+0xf9b20>
    3d88:	000022c1 	andeq	r2, r0, r1, asr #5
    3d8c:	23a70b04 			; <UNDEFINED> instruction: 0x23a70b04
    3d90:	0b050000 	bleq	143d98 <__bss_end+0x139b2c>
    3d94:	000022fd 	strdeq	r2, [r0], -sp
    3d98:	1e2a0b05 	vmulne.f64	d0, d10, d5
    3d9c:	0b050000 	bleq	143da4 <__bss_end+0x139b38>
    3da0:	00001d77 	andeq	r1, r0, r7, ror sp
    3da4:	25250b06 	strcs	r0, [r5, #-2822]!	; 0xfffff4fa
    3da8:	0b060000 	bleq	183db0 <__bss_end+0x179b44>
    3dac:	00001f86 	andeq	r1, r0, r6, lsl #31
    3db0:	25320b06 	ldrcs	r0, [r2, #-2822]!	; 0xfffff4fa
    3db4:	0b060000 	bleq	183dbc <__bss_end+0x179b50>
    3db8:	00002999 	muleq	r0, r9, r9
    3dbc:	253f0b06 	ldrcs	r0, [pc, #-2822]!	; 32be <shift+0x32be>
    3dc0:	0b060000 	bleq	183dc8 <__bss_end+0x179b5c>
    3dc4:	0000257f 	andeq	r2, r0, pc, ror r5
    3dc8:	1d830b06 	vstrne	d0, [r3, #24]
    3dcc:	0b070000 	bleq	1c3dd4 <__bss_end+0x1b9b68>
    3dd0:	00002685 	andeq	r2, r0, r5, lsl #13
    3dd4:	26d20b07 	ldrbcs	r0, [r2], r7, lsl #22
    3dd8:	0b070000 	bleq	1c3de0 <__bss_end+0x1b9b74>
    3ddc:	000029d4 	ldrdeq	r2, [r0], -r4
    3de0:	1f590b07 	svcne	0x00590b07
    3de4:	0b070000 	bleq	1c3dec <__bss_end+0x1b9b80>
    3de8:	00002753 	andeq	r2, r0, r3, asr r7
    3dec:	1cfc0b08 	vldmiane	ip!, {d16-d19}
    3df0:	0b080000 	bleq	203df8 <__bss_end+0x1f9b8c>
    3df4:	000029a7 	andeq	r2, r0, r7, lsr #19
    3df8:	276f0b08 	strbcs	r0, [pc, -r8, lsl #22]!
    3dfc:	00080000 	andeq	r0, r8, r0
    3e00:	002c0d0f 	eoreq	r0, ip, pc, lsl #26
    3e04:	019f0500 	orrseq	r0, pc, r0, lsl #10
    3e08:	0005801f 	andeq	r8, r5, pc, lsl r0
    3e0c:	27a10f00 	strcs	r0, [r1, r0, lsl #30]!
    3e10:	a2050000 	andge	r0, r5, #0
    3e14:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3e18:	b40f0000 	strlt	r0, [pc], #-0	; 3e20 <shift+0x3e20>
    3e1c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3e20:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    3e24:	0f000000 	svceq	0x00000000
    3e28:	00002cd9 	ldrdeq	r2, [r0], -r9
    3e2c:	0c01a805 	stceq	8, cr10, [r1], {5}
    3e30:	0000001d 	andeq	r0, r0, sp, lsl r0
    3e34:	001e490f 	andseq	r4, lr, pc, lsl #18
    3e38:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    3e3c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3e40:	27ab0f00 	strcs	r0, [fp, r0, lsl #30]!
    3e44:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    3e48:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3e4c:	bc0f0000 	stclt	0, cr0, [pc], {-0}
    3e50:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    3e54:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    3e58:	0f000000 	svceq	0x00000000
    3e5c:	000026c7 	andeq	r2, r0, r7, asr #13
    3e60:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    3e64:	0000001d 	andeq	r0, r0, sp, lsl r0
    3e68:	0027b50f 	eoreq	fp, r7, pc, lsl #10
    3e6c:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    3e70:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3e74:	25010f00 	strcs	r0, [r1, #-3840]	; 0xfffff100
    3e78:	ba050000 	blt	143e80 <__bss_end+0x139c14>
    3e7c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3e80:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
    3e84:	0500002c 	streq	r0, [r0, #-44]	; 0xffffffd4
    3e88:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    3e8c:	0f000000 	svceq	0x00000000
    3e90:	000027bf 			; <UNDEFINED> instruction: 0x000027bf
    3e94:	0c01c005 	stceq	0, cr12, [r1], {5}
    3e98:	0000001d 	andeq	r0, r0, sp, lsl r0
    3e9c:	002cfc0f 	eoreq	pc, ip, pc, lsl #24
    3ea0:	01c30500 	biceq	r0, r3, r0, lsl #10
    3ea4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3ea8:	2bc20f00 	blcs	ff087ab0 <__bss_end+0xff07d844>
    3eac:	c6050000 	strgt	r0, [r5], -r0
    3eb0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3eb4:	ce0f0000 	cdpgt	0, 0, cr0, cr15, cr0, {0}
    3eb8:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    3ebc:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    3ec0:	0f000000 	svceq	0x00000000
    3ec4:	00002bda 	ldrdeq	r2, [r0], -sl
    3ec8:	0c01cc05 	stceq	12, cr12, [r1], {5}
    3ecc:	0000001d 	andeq	r0, r0, sp, lsl r0
    3ed0:	002bff0f 	eoreq	pc, fp, pc, lsl #30
    3ed4:	01d00500 	bicseq	r0, r0, r0, lsl #10
    3ed8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3edc:	2cef0f00 	stclcs	15, cr0, [pc]	; 3ee4 <shift+0x3ee4>
    3ee0:	d3050000 	movwle	r0, #20480	; 0x5000
    3ee4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3ee8:	a60f0000 	strge	r0, [pc], -r0
    3eec:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    3ef0:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    3ef4:	0f000000 	svceq	0x00000000
    3ef8:	00001c8d 	andeq	r1, r0, sp, lsl #25
    3efc:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    3f00:	0000001d 	andeq	r0, r0, sp, lsl r0
    3f04:	0021980f 	eoreq	r9, r1, pc, lsl #16
    3f08:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    3f0c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f10:	1e810f00 	cdpne	15, 8, cr0, cr1, cr0, {0}
    3f14:	df050000 	svcle	0x00050000
    3f18:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3f1c:	d50f0000 	strle	r0, [pc, #-0]	; 3f24 <shift+0x3f24>
    3f20:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3f24:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    3f28:	0f000000 	svceq	0x00000000
    3f2c:	000023dd 	ldrdeq	r2, [r0], -sp
    3f30:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    3f34:	0000001d 	andeq	r0, r0, sp, lsl r0
    3f38:	0026350f 	eoreq	r3, r6, pc, lsl #10
    3f3c:	01e80500 	mvneq	r0, r0, lsl #10
    3f40:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f44:	2aef0f00 	bcs	ffbc7b4c <__bss_end+0xffbbd8e0>
    3f48:	ef050000 	svc	0x00050000
    3f4c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3f50:	a70f0000 	strge	r0, [pc, -r0]
    3f54:	0500002c 	streq	r0, [r0, #-44]	; 0xffffffd4
    3f58:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    3f5c:	0f000000 	svceq	0x00000000
    3f60:	00002cb7 			; <UNDEFINED> instruction: 0x00002cb7
    3f64:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    3f68:	0000001d 	andeq	r0, r0, sp, lsl r0
    3f6c:	001f9d0f 	andseq	r9, pc, pc, lsl #26
    3f70:	01f80500 	mvnseq	r0, r0, lsl #10
    3f74:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f78:	2b360f00 	blcs	d87b80 <__bss_end+0xd7d914>
    3f7c:	fb050000 	blx	143f86 <__bss_end+0x139d1a>
    3f80:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3f84:	3b0f0000 	blcc	3c3f8c <__bss_end+0x3b9d20>
    3f88:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3f8c:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    3f90:	0f000000 	svceq	0x00000000
    3f94:	00002211 	andeq	r2, r0, r1, lsl r2
    3f98:	0c020205 	sfmeq	f0, 4, [r2], {5}
    3f9c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3fa0:	00292b0f 	eoreq	r2, r9, pc, lsl #22
    3fa4:	020a0500 	andeq	r0, sl, #0, 10
    3fa8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3fac:	21040f00 	tstcs	r4, r0, lsl #30
    3fb0:	0d050000 	stceq	0, cr0, [r5, #-0]
    3fb4:	001d0c02 	andseq	r0, sp, r2, lsl #24
    3fb8:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    3fbc:	ef000000 	svc	0x00000000
    3fc0:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    3fc4:	22dd0f00 	sbcscs	r0, sp, #0, 30
    3fc8:	fb050000 	blx	143fd2 <__bss_end+0x139d66>
    3fcc:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    3fd0:	e60c0000 	str	r0, [ip], -r0
    3fd4:	0c000004 	stceq	0, cr0, [r0], {4}
    3fd8:	15000008 	strne	r0, [r0, #-8]
    3fdc:	00000024 	andeq	r0, r0, r4, lsr #32
    3fe0:	f80f000d 			; <UNDEFINED> instruction: 0xf80f000d
    3fe4:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3fe8:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    3fec:	16000007 	strne	r0, [r0], -r7
    3ff0:	0000239f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
    3ff4:	00930107 	addseq	r0, r3, r7, lsl #2
    3ff8:	8b050000 	blhi	144000 <__bss_end+0x139d94>
    3ffc:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    4000:	5a0b0000 	bpl	2c4008 <__bss_end+0x2b9d9c>
    4004:	00000021 	andeq	r0, r0, r1, lsr #32
    4008:	0025aa0b 	eoreq	sl, r5, fp, lsl #20
    400c:	320b0100 	andcc	r0, fp, #0, 2
    4010:	0200001d 	andeq	r0, r0, #29
    4014:	002c690b 	eoreq	r6, ip, fp, lsl #18
    4018:	720b0300 	andvc	r0, fp, #0, 6
    401c:	04000028 	streq	r0, [r0], #-40	; 0xffffffd8
    4020:	0028650b 	eoreq	r6, r8, fp, lsl #10
    4024:	090b0500 	stmdbeq	fp, {r8, sl}
    4028:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    402c:	2c590f00 	mrrccs	15, 0, r0, r9, cr0
    4030:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    4034:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    4038:	5b0f0000 	blpl	3c4040 <__bss_end+0x3b9dd4>
    403c:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    4040:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    4044:	0f000000 	svceq	0x00000000
    4048:	000027e5 	andeq	r2, r0, r5, ror #15
    404c:	0c07ae05 	stceq	14, cr10, [r7], {5}
    4050:	0000001d 	andeq	r0, r0, sp, lsl r0
    4054:	002ace04 	eoreq	ip, sl, r4, lsl #28
    4058:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    405c:	00000093 	muleq	r0, r3, r0
    4060:	00087e0e 	andeq	r7, r8, lr, lsl #28
    4064:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    4068:	00000e37 	andeq	r0, r0, r7, lsr lr
    406c:	ed070803 	stc	8, cr0, [r7, #-12]
    4070:	03000020 	movweq	r0, #32
    4074:	1ec10404 	cdpne	4, 12, cr0, cr1, cr4, {0}
    4078:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    407c:	001eb903 	andseq	fp, lr, r3, lsl #18
    4080:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    4084:	000027ce 	andeq	r2, r0, lr, asr #15
    4088:	80031003 	andhi	r1, r3, r3
    408c:	0c000028 	stceq	0, cr0, [r0], {40}	; 0x28
    4090:	0000088a 	andeq	r0, r0, sl, lsl #17
    4094:	000008c9 	andeq	r0, r0, r9, asr #17
    4098:	00002415 	andeq	r2, r0, r5, lsl r4
    409c:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    40a0:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    40a4:	0026df0f 	eoreq	sp, r6, pc, lsl #30
    40a8:	01fc0600 	mvnseq	r0, r0, lsl #12
    40ac:	0008c916 	andeq	ip, r8, r6, lsl r9
    40b0:	1e700f00 	cdpne	15, 7, cr0, cr0, cr0, {0}
    40b4:	02060000 	andeq	r0, r6, #0
    40b8:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    40bc:	01040000 	mrseq	r0, (UNDEF: 4)
    40c0:	0700002b 	streq	r0, [r0, -fp, lsr #32]
    40c4:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    40c8:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    40cc:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    40d0:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    40d4:	03570900 	cmpeq	r7, #0, 18
    40d8:	2f070000 	svccs	0x00070000
    40dc:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    40e0:	020c0900 	andeq	r0, ip, #0, 18
    40e4:	30070000 	andcc	r0, r7, r0
    40e8:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    40ec:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    40f0:	33080000 	movwcc	r0, #32768	; 0x8000
    40f4:	03050a09 	movweq	r0, #23049	; 0x5a09
    40f8:	0000a248 	andeq	sl, r0, r8, asr #4
    40fc:	00090b17 	andeq	r0, r9, r7, lsl fp
    4100:	09340800 	ldmdbeq	r4!, {fp}
    4104:	4803050a 	stmdami	r3, {r1, r3, r8, sl}
    4108:	000000a2 	andeq	r0, r0, r2, lsr #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3769a8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb8ab0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb8ad0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb8ae8>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x314>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79628>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe38b0c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f6a3c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b5e88>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b96ec>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c46a4>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b5eb4>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b5f28>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x376aa4>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb8ba4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe796e0>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe38bc4>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb8bdc>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79714>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4750>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x376b94>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f6b5c>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb8c7c>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	0b002405 	bleq	9234 <_Z23decimal_to_string_floatjPci+0x78>
 21c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 220:	06000008 	streq	r0, [r0], -r8
 224:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 228:	0b3b0b3a 	bleq	ec2f18 <__bss_end+0xeb8cac>
 22c:	13490b39 	movtne	r0, #39737	; 0x9b39
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b97e4>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb8cc4>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f6be8>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7c5b0>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb8cec>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b8c5c>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79840>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe38d24>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfad60>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4880>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79878>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe38d5c>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x376ce4>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe798a8>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe38d8c>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc79a5c>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x376d18>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b6118>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe798f8>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe38ddc>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb8df4>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x376d84>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe79944>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe38e28>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfae64>
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
 3d0:	3f012e23 	svccc	0x00012e23
 3d4:	3a0e0319 	bcc	381040 <__bss_end+0x376dd4>
 3d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3dc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 3e0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 3e4:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e8:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 3ec:	0b3b0b3a 	bleq	ec30dc <__bss_end+0xeb8e70>
 3f0:	13010b39 	movwne	r0, #6969	; 0x1b39
 3f4:	34250000 	strtcc	r0, [r5], #-0
 3f8:	3a0e0300 	bcc	381000 <__bss_end+0x376d94>
 3fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 400:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 404:	6c061c19 	stcvs	12, cr1, [r6], {25}
 408:	26000019 			; <UNDEFINED> instruction: 0x26000019
 40c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 410:	0b3b0b3a 	bleq	ec3100 <__bss_end+0xeb8e94>
 414:	13490b39 	movtne	r0, #39737	; 0x9b39
 418:	0b1c193c 	bleq	706910 <__bss_end+0x6fc6a4>
 41c:	0000196c 	andeq	r1, r0, ip, ror #18
 420:	47003427 	strmi	r3, [r0, -r7, lsr #8]
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb8eb0>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 438:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 43c:	03193f01 	tsteq	r9, #1, 30
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c4a14>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 44c:	96184006 	ldrls	r4, [r8], -r6
 450:	13011942 	movwne	r1, #6466	; 0x1942
 454:	052a0000 	streq	r0, [sl, #-0]!
 458:	3a0e0300 	bcc	381060 <__bss_end+0x376df4>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 464:	2b000018 	blcs	4cc <shift+0x4cc>
 468:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeb8ef0>
 470:	13490b39 	movtne	r0, #39737	; 0x9b39
 474:	00001802 	andeq	r1, r0, r2, lsl #16
 478:	0300342c 	movweq	r3, #1068	; 0x42c
 47c:	3b0b3a08 	blcc	2ceca4 <__bss_end+0x2c4a38>
 480:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 484:	00180213 	andseq	r0, r8, r3, lsl r2
 488:	010b2d00 	tsteq	fp, r0, lsl #26
 48c:	06120111 			; <UNDEFINED> instruction: 0x06120111
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
 4b8:	0b002404 	bleq	94d0 <_Z4ftoafPcj+0x194>
 4bc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4c0:	05000008 	streq	r0, [r0, #-8]
 4c4:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 4c8:	0b3b0b3a 	bleq	ec31b8 <__bss_end+0xeb8f4c>
 4cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 4d0:	13060000 	movwne	r0, #24576	; 0x6000
 4d4:	0b0e0301 	bleq	3810e0 <__bss_end+0x376e74>
 4d8:	3b0b3a0b 	blcc	2ced0c <__bss_end+0x2c4aa0>
 4dc:	010b390b 	tsteq	fp, fp, lsl #18
 4e0:	07000013 	smladeq	r0, r3, r0, r0
 4e4:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 4e8:	0b3b0b3a 	bleq	ec31d8 <__bss_end+0xeb8f6c>
 4ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 4f0:	00000b38 	andeq	r0, r0, r8, lsr fp
 4f4:	03010408 	movweq	r0, #5128	; 0x1408
 4f8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 4fc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 500:	3b0b3a13 	blcc	2ced54 <__bss_end+0x2c4ae8>
 504:	010b390b 	tsteq	fp, fp, lsl #18
 508:	09000013 	stmdbeq	r0, {r0, r1, r4}
 50c:	08030028 	stmdaeq	r3, {r3, r5}
 510:	00000b1c 	andeq	r0, r0, ip, lsl fp
 514:	0300280a 	movweq	r2, #2058	; 0x80a
 518:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 51c:	00340b00 	eorseq	r0, r4, r0, lsl #22
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe79ac8>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe38fac>
 528:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 52c:	00001802 	andeq	r1, r0, r2, lsl #16
 530:	0300020c 	movweq	r0, #524	; 0x20c
 534:	00193c0e 	andseq	r3, r9, lr, lsl #24
 538:	01020d00 	tsteq	r2, r0, lsl #26
 53c:	0b0b0e03 	bleq	2c3d50 <__bss_end+0x2b9ae4>
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeb8fc4>
 544:	13010b39 	movwne	r0, #6969	; 0x1b39
 548:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 54c:	3a0e0300 	bcc	381154 <__bss_end+0x376ee8>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 558:	0f00000b 	svceq	0x0000000b
 55c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 560:	0b3a0e03 	bleq	e83d74 <__bss_end+0xe79b08>
 564:	0b390b3b 	bleq	e43258 <__bss_end+0xe38fec>
 568:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 56c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 570:	05100000 	ldreq	r0, [r0, #-0]
 574:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 578:	11000019 	tstne	r0, r9, lsl r0
 57c:	13490005 	movtne	r0, #36869	; 0x9005
 580:	0d120000 	ldceq	0, cr0, [r2, #-0]
 584:	3a0e0300 	bcc	38118c <__bss_end+0x376f20>
 588:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 58c:	3f13490b 	svccc	0x0013490b
 590:	00193c19 	andseq	r3, r9, r9, lsl ip
 594:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 598:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 59c:	0b3b0b3a 	bleq	ec328c <__bss_end+0xeb9020>
 5a0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5a4:	0b321349 	bleq	c852d0 <__bss_end+0xc7b064>
 5a8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5ac:	00001301 	andeq	r1, r0, r1, lsl #6
 5b0:	3f012e14 	svccc	0x00012e14
 5b4:	3a0e0319 	bcc	381220 <__bss_end+0x376fb4>
 5b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5bc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 5c0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb9054>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	0b321349 	bleq	c85304 <__bss_end+0xc7b098>
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
 604:	3a0e0300 	bcc	38120c <__bss_end+0x376fa0>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	3f13490b 	svccc	0x0013490b
 610:	00193c19 	andseq	r3, r9, r9, lsl ip
 614:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 618:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 61c:	0b3b0b3a 	bleq	ec330c <__bss_end+0xeb90a0>
 620:	0e6e0b39 	vmoveq.8	d14[5], r0
 624:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 628:	00001301 	andeq	r1, r0, r1, lsl #6
 62c:	3f012e1c 	svccc	0x00012e1c
 630:	3a0e0319 	bcc	38129c <__bss_end+0x377030>
 634:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 638:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 63c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 640:	00130113 	andseq	r0, r3, r3, lsl r1
 644:	000d1d00 	andeq	r1, sp, r0, lsl #26
 648:	0b3a0e03 	bleq	e83e5c <__bss_end+0xe79bf0>
 64c:	0b390b3b 	bleq	e43340 <__bss_end+0xe390d4>
 650:	0b381349 	bleq	e0537c <__bss_end+0xdfb110>
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
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c4c54>
 684:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 688:	00180213 	andseq	r0, r8, r3, lsl r2
 68c:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 690:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 694:	0b3b0b3a 	bleq	ec3384 <__bss_end+0xeb9118>
 698:	0e6e0b39 	vmoveq.8	d14[5], r0
 69c:	01111349 	tsteq	r1, r9, asr #6
 6a0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6a4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6a8:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 6ac:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb9134>
 6b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6b8:	00001802 	andeq	r1, r0, r2, lsl #16
 6bc:	3f012e25 	svccc	0x00012e25
 6c0:	3a0e0319 	bcc	38132c <__bss_end+0x3770c0>
 6c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6c8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 6cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	34260000 	strtcc	r0, [r6], #-0
 6dc:	3a080300 	bcc	2012e4 <__bss_end+0x1f7078>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6e8:	27000018 	smladcs	r0, r8, r0, r0
 6ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6f0:	0b3a0e03 	bleq	e83f04 <__bss_end+0xe79c98>
 6f4:	0b390b3b 	bleq	e433e8 <__bss_end+0xe3917c>
 6f8:	01110e6e 	tsteq	r1, lr, ror #28
 6fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 700:	01194297 			; <UNDEFINED> instruction: 0x01194297
 704:	28000013 	stmdacs	r0, {r0, r1, r4}
 708:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe79cb4>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39198>
 714:	01110e6e 	tsteq	r1, lr, ror #28
 718:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 71c:	00194297 	mulseq	r9, r7, r2
 720:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 724:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 728:	0b3b0b3a 	bleq	ec3418 <__bss_end+0xeb91ac>
 72c:	0e6e0b39 	vmoveq.8	d14[5], r0
 730:	01111349 	tsteq	r1, r9, asr #6
 734:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 738:	00194297 	mulseq	r9, r7, r2
 73c:	11010000 	mrsne	r0, (UNDEF: 1)
 740:	130e2501 	movwne	r2, #58625	; 0xe501
 744:	1b0e030b 	blne	381378 <__bss_end+0x37710c>
 748:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 74c:	00171006 	andseq	r1, r7, r6
 750:	00340200 	eorseq	r0, r4, r0, lsl #4
 754:	0b3a0e03 	bleq	e83f68 <__bss_end+0xe79cfc>
 758:	0b390b3b 	bleq	e4344c <__bss_end+0xe391e0>
 75c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 760:	00001802 	andeq	r1, r0, r2, lsl #16
 764:	0b002403 	bleq	9778 <_ZN13COLED_DisplayC1EPKc+0x8>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0400000e 	streq	r0, [r0], #-14
 770:	13490026 	movtne	r0, #36902	; 0x9026
 774:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 778:	00130101 	andseq	r0, r3, r1, lsl #2
 77c:	00340600 	eorseq	r0, r4, r0, lsl #12
 780:	0b3a0e03 	bleq	e83f94 <__bss_end+0xe79d28>
 784:	0b390b3b 	bleq	e43478 <__bss_end+0xe3920c>
 788:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 78c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 790:	3a003a07 	bcc	efb4 <__bss_end+0x4d48>
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
 7bc:	3b0b3a0e 	blcc	2ceffc <__bss_end+0x2c4d90>
 7c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7c4:	1113490e 	tstne	r3, lr, lsl #18
 7c8:	40061201 	andmi	r1, r6, r1, lsl #4
 7cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 7d0:	00001301 	andeq	r1, r0, r1, lsl #6
 7d4:	0300050c 	movweq	r0, #1292	; 0x50c
 7d8:	3b0b3a08 	blcc	2cf000 <__bss_end+0x2c4d94>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	00340d00 	eorseq	r0, r4, r0, lsl #26
 7e8:	0b3a0803 	bleq	e827fc <__bss_end+0xe78590>
 7ec:	0b390b3b 	bleq	e434e0 <__bss_end+0xe39274>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	340e0000 	strcc	r0, [lr], #-0
 7f8:	3a0e0300 	bcc	381400 <__bss_end+0x377194>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 804:	0f000018 	svceq	0x00000018
 808:	0111010b 	tsteq	r1, fp, lsl #2
 80c:	00000612 	andeq	r0, r0, r2, lsl r6
 810:	03003410 	movweq	r3, #1040	; 0x410
 814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c4de8>
 818:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 81c:	00180213 	andseq	r0, r8, r3, lsl r2
 820:	00341100 	eorseq	r1, r4, r0, lsl #2
 824:	0b3a0803 	bleq	e82838 <__bss_end+0xe785cc>
 828:	0b39053b 	bleq	e41d1c <__bss_end+0xe37ab0>
 82c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 830:	0f120000 	svceq	0x00120000
 834:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 838:	13000013 	movwne	r0, #19
 83c:	0b0b0024 	bleq	2c08d4 <__bss_end+0x2b6668>
 840:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 844:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 848:	03193f01 	tsteq	r9, #1, 30
 84c:	3b0b3a0e 	blcc	2cf08c <__bss_end+0x2c4e20>
 850:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 854:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 858:	96184006 	ldrls	r4, [r8], -r6
 85c:	13011942 	movwne	r1, #6466	; 0x1942
 860:	05150000 	ldreq	r0, [r5, #-0]
 864:	3a0e0300 	bcc	38146c <__bss_end+0x377200>
 868:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 86c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 870:	16000018 			; <UNDEFINED> instruction: 0x16000018
 874:	0111010b 	tsteq	r1, fp, lsl #2
 878:	13010612 	movwne	r0, #5650	; 0x1612
 87c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 880:	03193f01 	tsteq	r9, #1, 30
 884:	3b0b3a0e 	blcc	2cf0c4 <__bss_end+0x2c4e58>
 888:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 88c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 890:	97184006 	ldrls	r4, [r8, -r6]
 894:	13011942 	movwne	r1, #6466	; 0x1942
 898:	10180000 	andsne	r0, r8, r0
 89c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 8a0:	19000013 	stmdbne	r0, {r0, r1, r4}
 8a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8a8:	0b3a0803 	bleq	e828bc <__bss_end+0xe78650>
 8ac:	0b390b3b 	bleq	e435a0 <__bss_end+0xe39334>
 8b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 8b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 8bc:	00130119 	andseq	r0, r3, r9, lsl r1
 8c0:	00261a00 	eoreq	r1, r6, r0, lsl #20
 8c4:	0f1b0000 	svceq	0x001b0000
 8c8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 8cc:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 8d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8d4:	0b3b0b3a 	bleq	ec35c4 <__bss_end+0xeb9358>
 8d8:	0e6e0b39 	vmoveq.8	d14[5], r0
 8dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 8e4:	00000019 	andeq	r0, r0, r9, lsl r0
 8e8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 8ec:	030b130e 	movweq	r1, #45838	; 0xb30e
 8f0:	110e1b0e 	tstne	lr, lr, lsl #22
 8f4:	10061201 	andne	r1, r6, r1, lsl #4
 8f8:	02000017 	andeq	r0, r0, #23
 8fc:	0b0b0024 	bleq	2c0994 <__bss_end+0x2b6728>
 900:	0e030b3e 	vmoveq.16	d3[0], r0
 904:	26030000 	strcs	r0, [r3], -r0
 908:	00134900 	andseq	r4, r3, r0, lsl #18
 90c:	00240400 	eoreq	r0, r4, r0, lsl #8
 910:	0b3e0b0b 	bleq	f83544 <__bss_end+0xf792d8>
 914:	00000803 	andeq	r0, r0, r3, lsl #16
 918:	03001605 	movweq	r1, #1541	; 0x605
 91c:	3b0b3a0e 	blcc	2cf15c <__bss_end+0x2c4ef0>
 920:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 924:	06000013 			; <UNDEFINED> instruction: 0x06000013
 928:	0e030102 	adfeqs	f0, f3, f2
 92c:	0b3a0b0b 	bleq	e83560 <__bss_end+0xe792f4>
 930:	0b390b3b 	bleq	e43624 <__bss_end+0xe393b8>
 934:	00001301 	andeq	r1, r0, r1, lsl #6
 938:	03000d07 	movweq	r0, #3335	; 0xd07
 93c:	3b0b3a0e 	blcc	2cf17c <__bss_end+0x2c4f10>
 940:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 944:	000b3813 	andeq	r3, fp, r3, lsl r8
 948:	012e0800 			; <UNDEFINED> instruction: 0x012e0800
 94c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 950:	0b3b0b3a 	bleq	ec3640 <__bss_end+0xeb93d4>
 954:	0e6e0b39 	vmoveq.8	d14[5], r0
 958:	0b321349 	bleq	c85684 <__bss_end+0xc7b418>
 95c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 960:	00001301 	andeq	r1, r0, r1, lsl #6
 964:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
 968:	00193413 	andseq	r3, r9, r3, lsl r4
 96c:	00050a00 	andeq	r0, r5, r0, lsl #20
 970:	00001349 	andeq	r1, r0, r9, asr #6
 974:	3f012e0b 	svccc	0x00012e0b
 978:	3a0e0319 	bcc	3815e4 <__bss_end+0x377378>
 97c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 980:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 984:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 988:	00130113 	andseq	r0, r3, r3, lsl r1
 98c:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 990:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 994:	0b3b0b3a 	bleq	ec3684 <__bss_end+0xeb9418>
 998:	0e6e0b39 	vmoveq.8	d14[5], r0
 99c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 9a0:	00001364 	andeq	r1, r0, r4, ror #6
 9a4:	0b000f0d 	bleq	45e0 <shift+0x45e0>
 9a8:	0013490b 	andseq	r4, r3, fp, lsl #18
 9ac:	000f0e00 	andeq	r0, pc, r0, lsl #28
 9b0:	00000b0b 	andeq	r0, r0, fp, lsl #22
 9b4:	0301130f 	movweq	r1, #4879	; 0x130f
 9b8:	3a0b0b0e 	bcc	2c35f8 <__bss_end+0x2b938c>
 9bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 9c4:	000d1000 	andeq	r1, sp, r0
 9c8:	0b3a0803 	bleq	e829dc <__bss_end+0xe78770>
 9cc:	0b390b3b 	bleq	e436c0 <__bss_end+0xe39454>
 9d0:	0b381349 	bleq	e056fc <__bss_end+0xdfb490>
 9d4:	04110000 	ldreq	r0, [r1], #-0
 9d8:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 9dc:	0b0b3e19 	bleq	2d0248 <__bss_end+0x2c5fdc>
 9e0:	3a13490b 	bcc	4d2e14 <__bss_end+0x4c8ba8>
 9e4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9e8:	0013010b 	andseq	r0, r3, fp, lsl #2
 9ec:	00281200 	eoreq	r1, r8, r0, lsl #4
 9f0:	0b1c0e03 	bleq	704204 <__bss_end+0x6f9f98>
 9f4:	34130000 	ldrcc	r0, [r3], #-0
 9f8:	3a0e0300 	bcc	381600 <__bss_end+0x377394>
 9fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a00:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 a04:	00180219 	andseq	r0, r8, r9, lsl r2
 a08:	00021400 	andeq	r1, r2, r0, lsl #8
 a0c:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 a10:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 a14:	03193f01 	tsteq	r9, #1, 30
 a18:	3b0b3a0e 	blcc	2cf258 <__bss_end+0x2c4fec>
 a1c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a20:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 a24:	00136419 	andseq	r6, r3, r9, lsl r4
 a28:	000d1600 	andeq	r1, sp, r0, lsl #12
 a2c:	0b3a0e03 	bleq	e84240 <__bss_end+0xe79fd4>
 a30:	0b390b3b 	bleq	e43724 <__bss_end+0xe394b8>
 a34:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 a38:	0000193c 	andeq	r1, r0, ip, lsr r9
 a3c:	3f012e17 	svccc	0x00012e17
 a40:	3a0e0319 	bcc	3816ac <__bss_end+0x377440>
 a44:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a48:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 a4c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 a50:	00136419 	andseq	r6, r3, r9, lsl r4
 a54:	01011800 	tsteq	r1, r0, lsl #16
 a58:	13011349 	movwne	r1, #4937	; 0x1349
 a5c:	21190000 	tstcs	r9, r0
 a60:	2f134900 	svccs	0x00134900
 a64:	1a00000b 	bne	a98 <shift+0xa98>
 a68:	00000021 	andeq	r0, r0, r1, lsr #32
 a6c:	0300341b 	movweq	r3, #1051	; 0x41b
 a70:	3b0b3a0e 	blcc	2cf2b0 <__bss_end+0x2c5044>
 a74:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a78:	3c193f13 	ldccc	15, cr3, [r9], {19}
 a7c:	1c000019 	stcne	0, cr0, [r0], {25}
 a80:	08030028 	stmdaeq	r3, {r3, r5}
 a84:	00000b1c 	andeq	r0, r0, ip, lsl fp
 a88:	3f012e1d 	svccc	0x00012e1d
 a8c:	3a0e0319 	bcc	3816f8 <__bss_end+0x37748c>
 a90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a94:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 a98:	01136419 	tsteq	r3, r9, lsl r4
 a9c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 aa0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 aa4:	0b3a0e03 	bleq	e842b8 <__bss_end+0xe7a04c>
 aa8:	0b390b3b 	bleq	e4379c <__bss_end+0xe39530>
 aac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 ab0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 ab4:	00001301 	andeq	r1, r0, r1, lsl #6
 ab8:	03000d1f 	movweq	r0, #3359	; 0xd1f
 abc:	3b0b3a0e 	blcc	2cf2fc <__bss_end+0x2c5090>
 ac0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ac4:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 ac8:	2000000b 	andcs	r0, r0, fp
 acc:	13490115 	movtne	r0, #37141	; 0x9115
 ad0:	13011364 	movwne	r1, #4964	; 0x1364
 ad4:	1f210000 	svcne	0x00210000
 ad8:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 adc:	22000013 	andcs	r0, r0, #19
 ae0:	0b0b0010 	bleq	2c0b28 <__bss_end+0x2b68bc>
 ae4:	00001349 	andeq	r1, r0, r9, asr #6
 ae8:	03013923 	movweq	r3, #6435	; 0x1923
 aec:	3b0b3a08 	blcc	2cf314 <__bss_end+0x2c50a8>
 af0:	010b390b 	tsteq	fp, fp, lsl #18
 af4:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 af8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 afc:	0b3b0b3a 	bleq	ec37ec <__bss_end+0xeb9580>
 b00:	13490b39 	movtne	r0, #39737	; 0x9b39
 b04:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 b08:	0000196c 	andeq	r1, r0, ip, ror #18
 b0c:	03003425 	movweq	r3, #1061	; 0x425
 b10:	3b0b3a0e 	blcc	2cf350 <__bss_end+0x2c50e4>
 b14:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b18:	1c193c13 	ldcne	12, cr3, [r9], {19}
 b1c:	00196c0b 	andseq	r6, r9, fp, lsl #24
 b20:	00342600 	eorseq	r2, r4, r0, lsl #12
 b24:	00001347 	andeq	r1, r0, r7, asr #6
 b28:	03013927 	movweq	r3, #6439	; 0x1927
 b2c:	3b0b3a0e 	blcc	2cf36c <__bss_end+0x2c5100>
 b30:	010b390b 	tsteq	fp, fp, lsl #18
 b34:	28000013 	stmdacs	r0, {r0, r1, r4}
 b38:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 b3c:	0b3b0b3a 	bleq	ec382c <__bss_end+0xeb95c0>
 b40:	13490b39 	movtne	r0, #39737	; 0x9b39
 b44:	031c193c 	tsteq	ip, #60, 18	; 0xf0000
 b48:	21290000 			; <UNDEFINED> instruction: 0x21290000
 b4c:	2f134900 	svccs	0x00134900
 b50:	2a000005 	bcs	b6c <shift+0xb6c>
 b54:	1347012e 	movtne	r0, #28974	; 0x712e
 b58:	0b3b0b3a 	bleq	ec3848 <__bss_end+0xeb95dc>
 b5c:	13640b39 	cmnne	r4, #58368	; 0xe400
 b60:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b64:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 b68:	00130119 	andseq	r0, r3, r9, lsl r1
 b6c:	00052b00 	andeq	r2, r5, r0, lsl #22
 b70:	13490e03 	movtne	r0, #40451	; 0x9e03
 b74:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 b78:	052c0000 	streq	r0, [ip, #-0]!
 b7c:	3a080300 	bcc	201784 <__bss_end+0x1f7518>
 b80:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b84:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 b88:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
 b8c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 b90:	0b3b0b3a 	bleq	ec3880 <__bss_end+0xeb9614>
 b94:	13490b39 	movtne	r0, #39737	; 0x9b39
 b98:	00001802 	andeq	r1, r0, r2, lsl #16
 b9c:	0300052e 	movweq	r0, #1326	; 0x52e
 ba0:	3b0b3a0e 	blcc	2cf3e0 <__bss_end+0x2c5174>
 ba4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ba8:	00180213 	andseq	r0, r8, r3, lsl r2
 bac:	012e2f00 			; <UNDEFINED> instruction: 0x012e2f00
 bb0:	0b3a1347 	bleq	e858d4 <__bss_end+0xe7b668>
 bb4:	0b390b3b 	bleq	e438a8 <__bss_end+0xe3963c>
 bb8:	01111364 	tsteq	r1, r4, ror #6
 bbc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 bc0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 bc4:	30000013 	andcc	r0, r0, r3, lsl r0
 bc8:	1347012e 	movtne	r0, #28974	; 0x712e
 bcc:	0b3b0b3a 	bleq	ec38bc <__bss_end+0xeb9650>
 bd0:	13640b39 	cmnne	r4, #58368	; 0xe400
 bd4:	13010b20 	movwne	r0, #6944	; 0x1b20
 bd8:	05310000 	ldreq	r0, [r1, #-0]!
 bdc:	490e0300 	stmdbmi	lr, {r8, r9}
 be0:	00193413 	andseq	r3, r9, r3, lsl r4
 be4:	012e3200 			; <UNDEFINED> instruction: 0x012e3200
 be8:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 bec:	01111364 	tsteq	r1, r4, ror #6
 bf0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 bf4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 bf8:	33000013 	movwcc	r0, #19
 bfc:	13310005 	teqne	r1, #5
 c00:	00001802 	andeq	r1, r0, r2, lsl #16
 c04:	03000534 	movweq	r0, #1332	; 0x534
 c08:	3b0b3a0e 	blcc	2cf448 <__bss_end+0x2c51dc>
 c0c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 c10:	35000013 	strcc	r0, [r0, #-19]	; 0xffffffed
 c14:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
 c18:	13640e6e 	cmnne	r4, #1760	; 0x6e0
 c1c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 c20:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 c24:	00000019 	andeq	r0, r0, r9, lsl r0
 c28:	10001101 	andne	r1, r0, r1, lsl #2
 c2c:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 c30:	1b0e0301 	blne	38183c <__bss_end+0x3775d0>
 c34:	130e250e 	movwne	r2, #58638	; 0xe50e
 c38:	00000005 	andeq	r0, r0, r5
 c3c:	10001101 	andne	r1, r0, r1, lsl #2
 c40:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 c44:	1b0e0301 	blne	381850 <__bss_end+0x3775e4>
 c48:	130e250e 	movwne	r2, #58638	; 0xe50e
 c4c:	00000005 	andeq	r0, r0, r5
 c50:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 c54:	030b130e 	movweq	r1, #45838	; 0xb30e
 c58:	100e1b0e 	andne	r1, lr, lr, lsl #22
 c5c:	02000017 	andeq	r0, r0, #23
 c60:	0b0b0024 	bleq	2c0cf8 <__bss_end+0x2b6a8c>
 c64:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 c68:	24030000 	strcs	r0, [r3], #-0
 c6c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 c70:	000e030b 	andeq	r0, lr, fp, lsl #6
 c74:	00160400 	andseq	r0, r6, r0, lsl #8
 c78:	0b3a0e03 	bleq	e8448c <__bss_end+0xe7a220>
 c7c:	0b390b3b 	bleq	e43970 <__bss_end+0xe39704>
 c80:	00001349 	andeq	r1, r0, r9, asr #6
 c84:	0b000f05 	bleq	48a0 <shift+0x48a0>
 c88:	0013490b 	andseq	r4, r3, fp, lsl #18
 c8c:	01150600 	tsteq	r5, r0, lsl #12
 c90:	13491927 	movtne	r1, #39207	; 0x9927
 c94:	00001301 	andeq	r1, r0, r1, lsl #6
 c98:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 c9c:	08000013 	stmdaeq	r0, {r0, r1, r4}
 ca0:	00000026 	andeq	r0, r0, r6, lsr #32
 ca4:	03003409 	movweq	r3, #1033	; 0x409
 ca8:	3b0b3a0e 	blcc	2cf4e8 <__bss_end+0x2c527c>
 cac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 cb0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 cb4:	0a000019 	beq	d20 <shift+0xd20>
 cb8:	0e030104 	adfeqs	f0, f3, f4
 cbc:	0b0b0b3e 	bleq	2c39bc <__bss_end+0x2b9750>
 cc0:	0b3a1349 	bleq	e859ec <__bss_end+0xe7b780>
 cc4:	0b390b3b 	bleq	e439b8 <__bss_end+0xe3974c>
 cc8:	00001301 	andeq	r1, r0, r1, lsl #6
 ccc:	0300280b 	movweq	r2, #2059	; 0x80b
 cd0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 cd4:	01010c00 	tsteq	r1, r0, lsl #24
 cd8:	13011349 	movwne	r1, #4937	; 0x1349
 cdc:	210d0000 	mrscs	r0, (UNDEF: 13)
 ce0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 ce4:	13490026 	movtne	r0, #36902	; 0x9026
 ce8:	340f0000 	strcc	r0, [pc], #-0	; cf0 <shift+0xcf0>
 cec:	3a0e0300 	bcc	3818f4 <__bss_end+0x377688>
 cf0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 cf4:	3f13490b 	svccc	0x0013490b
 cf8:	00193c19 	andseq	r3, r9, r9, lsl ip
 cfc:	00131000 	andseq	r1, r3, r0
 d00:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 d04:	15110000 	ldrne	r0, [r1, #-0]
 d08:	00192700 	andseq	r2, r9, r0, lsl #14
 d0c:	00171200 	andseq	r1, r7, r0, lsl #4
 d10:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 d14:	13130000 	tstne	r3, #0
 d18:	0b0e0301 	bleq	381924 <__bss_end+0x3776b8>
 d1c:	3b0b3a0b 	blcc	2cf550 <__bss_end+0x2c52e4>
 d20:	010b3905 	tsteq	fp, r5, lsl #18
 d24:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 d28:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 d2c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 d30:	13490b39 	movtne	r0, #39737	; 0x9b39
 d34:	00000b38 	andeq	r0, r0, r8, lsr fp
 d38:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 d3c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 d40:	01041600 	tsteq	r4, r0, lsl #12
 d44:	0b3e0e03 	bleq	f84558 <__bss_end+0xf7a2ec>
 d48:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 d4c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 d50:	13010b39 	movwne	r0, #6969	; 0x1b39
 d54:	34170000 	ldrcc	r0, [r7], #-0
 d58:	3a134700 	bcc	4d2960 <__bss_end+0x4c86f4>
 d5c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 d60:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  74:	0000010c 	andeq	r0, r0, ip, lsl #2
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	124c0002 	subne	r0, ip, #2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008338 	andeq	r8, r0, r8, lsr r3
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1f450002 	svcne	0x00450002
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008794 	muleq	r0, r4, r7
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	26420002 	strbcs	r0, [r2], -r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009770 	andeq	r9, r0, r0, ror r7
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	378a0002 	strcc	r0, [sl, r2]
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009c24 	andeq	r9, r0, r4, lsr #24
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	37b00002 	ldrcc	r0, [r0, r2]!
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009e30 	andeq	r9, r0, r0, lsr lr
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	37d60002 	ldrbcc	r0, [r6, r2]
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff5ce0>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff5a85>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff5a87>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad479c>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff5bd5>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be10c>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcf6b8>
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
     430:	5a5f0074 	bpl	17c0608 <__bss_end+0x17b639c>
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
     4ec:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     4f0:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     4f4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4f8:	00656c64 	rsbeq	r6, r5, r4, ror #24
     4fc:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     500:	00676e69 	rsbeq	r6, r7, r9, ror #28
     504:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     508:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     50c:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     510:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     514:	5f006465 	svcpl	0x00006465
     518:	31314e5a 	teqcc	r1, sl, asr lr
     51c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     520:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     524:	316d6574 	smccc	54868	; 0xd654
     528:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     52c:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     530:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     534:	6f6d0076 	svcvs	0x006d0076
     538:	50746e75 	rsbspl	r6, r4, r5, ror lr
     53c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     540:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     544:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     548:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     54c:	6f72505f 	svcvs	0x0072505f
     550:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     554:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     558:	61425f4f 	cmpvs	r2, pc, asr #30
     55c:	5f006573 	svcpl	0x00006573
     560:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     564:	6f725043 	svcvs	0x00725043
     568:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     56c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     570:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     574:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     578:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     57c:	6f72505f 	svcvs	0x0072505f
     580:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     584:	6a685045 	bvs	1a146a0 <__bss_end+0x1a0a434>
     588:	72700062 	rsbsvc	r0, r0, #98	; 0x62
     58c:	5f007665 	svcpl	0x00007665
     590:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     594:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     598:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     59c:	616c7073 	smcvs	50947	; 0xc703
     5a0:	75503879 	ldrbvc	r3, [r0, #-2169]	; 0xfffff787
     5a4:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5a8:	74457261 	strbvc	r7, [r5], #-609	; 0xfffffd9f
     5ac:	5f006374 	svcpl	0x00006374
     5b0:	314b4e5a 	cmpcc	fp, sl, asr lr
     5b4:	50474333 	subpl	r4, r7, r3, lsr r3
     5b8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     5bc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     5c0:	36327265 	ldrtcc	r7, [r2], -r5, ror #4
     5c4:	5f746547 	svcpl	0x00746547
     5c8:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     5cc:	445f5152 	ldrbmi	r5, [pc], #-338	; 5d4 <shift+0x5d4>
     5d0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     5d4:	6f4c5f74 	svcvs	0x004c5f74
     5d8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     5dc:	6a456e6f 	bvs	115bfa0 <__bss_end+0x1151d34>
     5e0:	474e3032 	smlaldxmi	r3, lr, r2, r0
     5e4:	5f4f4950 	svcpl	0x004f4950
     5e8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     5ec:	70757272 	rsbsvc	r7, r5, r2, ror r2
     5f0:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5f4:	6a526570 	bvs	1499bbc <__bss_end+0x148f950>
     5f8:	005f3153 	subseq	r3, pc, r3, asr r1	; <UNPREDICTABLE>
     5fc:	4b4e5a5f 	blmi	1396f80 <__bss_end+0x138cd14>
     600:	50433631 	subpl	r3, r3, r1, lsr r6
     604:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     608:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 444 <shift+0x444>
     60c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     610:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     614:	5f746547 	svcpl	0x00746547
     618:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     61c:	5f746e65 	svcpl	0x00746e65
     620:	636f7250 	cmnvs	pc, #80, 4
     624:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     628:	46540076 			; <UNDEFINED> instruction: 0x46540076
     62c:	72545f53 	subsvc	r5, r4, #332	; 0x14c
     630:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
     634:	0065646f 	rsbeq	r6, r5, pc, ror #8
     638:	5f746553 	svcpl	0x00746553
     63c:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     640:	64007475 	strvs	r7, [r0], #-1141	; 0xfffffb8b
     644:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     648:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     64c:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     650:	4f5f6461 	svcmi	0x005f6461
     654:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     658:	5f78614d 	svcpl	0x0078614d
     65c:	636f7250 	cmnvs	pc, #80, 4
     660:	5f737365 	svcpl	0x00737365
     664:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     668:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     66c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     670:	50435400 	subpl	r5, r3, r0, lsl #8
     674:	6f435f55 	svcvs	0x00435f55
     678:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     67c:	5a5f0074 	bpl	17c0854 <__bss_end+0x17b65e8>
     680:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     684:	636f7250 	cmnvs	pc, #80, 4
     688:	5f737365 	svcpl	0x00737365
     68c:	616e614d 	cmnvs	lr, sp, asr #2
     690:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     694:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     698:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     69c:	5f007645 	svcpl	0x00007645
     6a0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6a4:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     6a8:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     6ac:	616c7073 	smcvs	50947	; 0xc703
     6b0:	45344379 	ldrmi	r4, [r4, #-889]!	; 0xfffffc87
     6b4:	00634b50 	rsbeq	r4, r3, r0, asr fp
     6b8:	4f5f7349 	svcmi	0x005f7349
     6bc:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     6c0:	6f4e0064 	svcvs	0x004e0064
     6c4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6c8:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     6cc:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     6d0:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     6d4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     6d8:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     6dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6e0:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     6e4:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     6e8:	69750044 	ldmdbvs	r5!, {r2, r6}^
     6ec:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     6f0:	5f00745f 	svcpl	0x0000745f
     6f4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6f8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     6fc:	61485f4f 	cmpvs	r8, pc, asr #30
     700:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     704:	65473972 	strbvs	r3, [r7, #-2418]	; 0xfffff68e
     708:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     70c:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     710:	5a5f006a 	bpl	17c08c0 <__bss_end+0x17b6654>
     714:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     718:	4f495047 	svcmi	0x00495047
     71c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     720:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     724:	65533031 	ldrbvs	r3, [r3, #-49]	; 0xffffffcf
     728:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff7bc <__bss_end+0xffff5550>
     72c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     730:	00626a45 	rsbeq	r6, r2, r5, asr #20
     734:	314e5a5f 	cmpcc	lr, pc, asr sl
     738:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     73c:	445f4445 	ldrbmi	r4, [pc], #-1093	; 744 <shift+0x744>
     740:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     744:	43357961 	teqmi	r5, #1589248	; 0x184000
     748:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     74c:	42006245 	andmi	r6, r0, #1342177284	; 0x50000004
     750:	5f314353 	svcpl	0x00314353
     754:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     758:	74755000 	ldrbtvc	r5, [r5], #-0
     75c:	6168435f 	cmnvs	r8, pc, asr r3
     760:	61570072 	cmpvs	r7, r2, ror r0
     764:	4e007469 	cdpmi	4, 0, cr7, cr0, cr9, {3}
     768:	6b736154 	blvs	1cd8cc0 <__bss_end+0x1ccea54>
     76c:	6174535f 	cmnvs	r4, pc, asr r3
     770:	53006574 	movwpl	r6, #1396	; 0x574
     774:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     778:	5f656c75 	svcpl	0x00656c75
     77c:	00464445 	subeq	r4, r6, r5, asr #8
     780:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     784:	0064656b 	rsbeq	r6, r4, fp, ror #10
     788:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     78c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     790:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     794:	6f4e5f6b 	svcvs	0x004e5f6b
     798:	5f006564 	svcpl	0x00006564
     79c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     7a0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     7a4:	61485f4f 	cmpvs	r8, pc, asr #30
     7a8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     7ac:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     7b0:	526d006a 	rsbpl	r0, sp, #106	; 0x6a
     7b4:	5f746f6f 	svcpl	0x00746f6f
     7b8:	00766544 	rsbseq	r6, r6, r4, asr #10
     7bc:	314e5a5f 	cmpcc	lr, pc, asr sl
     7c0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7c8:	614d5f73 	hvcvs	54771	; 0xd5f3
     7cc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7d0:	77533972 			; <UNDEFINED> instruction: 0x77533972
     7d4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     7d8:	456f545f 	strbmi	r5, [pc, #-1119]!	; 381 <shift+0x381>
     7dc:	43383150 	teqmi	r8, #80, 2
     7e0:	636f7250 	cmnvs	pc, #80, 4
     7e4:	5f737365 	svcpl	0x00737365
     7e8:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     7ec:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 7f4 <shift+0x7f4>
     7f0:	69700065 	ldmdbvs	r0!, {r0, r2, r5, r6}^
     7f4:	64695f6e 	strbtvs	r5, [r9], #-3950	; 0xfffff092
     7f8:	70630078 	rsbvc	r0, r3, r8, ror r0
     7fc:	6f635f75 	svcvs	0x00635f75
     800:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     804:	476d0074 			; <UNDEFINED> instruction: 0x476d0074
     808:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     80c:	61657243 	cmnvs	r5, r3, asr #4
     810:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     814:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     818:	5f007373 	svcpl	0x00007373
     81c:	314b4e5a 	cmpcc	fp, sl, asr lr
     820:	50474333 	subpl	r4, r7, r3, lsr r3
     824:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     828:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     82c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     830:	5f746547 	svcpl	0x00746547
     834:	53465047 	movtpl	r5, #24647	; 0x6047
     838:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     83c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     840:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     844:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     848:	4f005f30 	svcmi	0x00005f30
     84c:	006e6570 	rsbeq	r6, lr, r0, ror r5
     850:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     854:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     858:	0079726f 	rsbseq	r7, r9, pc, ror #4
     85c:	5f746547 	svcpl	0x00746547
     860:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     864:	6f4c5f52 	svcvs	0x004c5f52
     868:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     86c:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     870:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     874:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     878:	46670065 	strbtmi	r0, [r7], -r5, rrx
     87c:	72445f53 	subvc	r5, r4, #332	; 0x14c
     880:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     884:	6f435f73 	svcvs	0x00435f73
     888:	00746e75 	rsbseq	r6, r4, r5, ror lr
     88c:	49504773 	ldmdbmi	r0, {r0, r1, r4, r5, r6, r8, r9, sl, lr}^
     890:	6547004f 	strbvs	r0, [r7, #-79]	; 0xffffffb1
     894:	50475f74 	subpl	r5, r7, r4, ror pc
     898:	5f534445 	svcpl	0x00534445
     89c:	61636f4c 	cmnvs	r3, ip, asr #30
     8a0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     8a4:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     8a8:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     8ac:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     8b0:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     8b4:	5f006e6f 	svcpl	0x00006e6f
     8b8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     8bc:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     8c0:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     8c4:	616c7073 	smcvs	50947	; 0xc703
     8c8:	6c463479 	cfstrdvs	mvd3, [r6], {121}	; 0x79
     8cc:	76457069 	strbvc	r7, [r5], -r9, rrx
     8d0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8d4:	50433631 	subpl	r3, r3, r1, lsr r6
     8d8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8dc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 718 <shift+0x718>
     8e0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8e4:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     8e8:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8ec:	505f7966 	subspl	r7, pc, r6, ror #18
     8f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8f4:	50457373 	subpl	r7, r5, r3, ror r3
     8f8:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     8fc:	5f6b7361 	svcpl	0x006b7361
     900:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     904:	47007463 	strmi	r7, [r0, -r3, ror #8]
     908:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     90c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     910:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     914:	4f49006f 	svcmi	0x0049006f
     918:	006c7443 	rsbeq	r7, ip, r3, asr #8
     91c:	6e61486d 	cdpvs	8, 6, cr4, cr1, cr13, {3}
     920:	00656c64 	rsbeq	r6, r5, r4, ror #24
     924:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     928:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     92c:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     930:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     934:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     938:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     93c:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     940:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     944:	5a5f0073 	bpl	17c0b18 <__bss_end+0x17b68ac>
     948:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     94c:	636f7250 	cmnvs	pc, #80, 4
     950:	5f737365 	svcpl	0x00737365
     954:	616e614d 	cmnvs	lr, sp, asr #2
     958:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     95c:	00764534 	rsbseq	r4, r6, r4, lsr r5
     960:	4b4e5a5f 	blmi	13972e4 <__bss_end+0x138d078>
     964:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     968:	5f4f4950 	svcpl	0x004f4950
     96c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     970:	3172656c 	cmncc	r2, ip, ror #10
     974:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     978:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     97c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     980:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     984:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     988:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     98c:	6d005f30 	stcvs	15, cr5, [r0, #-192]	; 0xffffff40
     990:	61737365 	cmnvs	r3, r5, ror #6
     994:	00736567 	rsbseq	r6, r3, r7, ror #10
     998:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     99c:	526d006b 	rsbpl	r0, sp, #107	; 0x6b
     9a0:	5f746f6f 	svcpl	0x00746f6f
     9a4:	00746e4d 	rsbseq	r6, r4, sp, asr #28
     9a8:	4b4e5a5f 	blmi	139732c <__bss_end+0x138d0c0>
     9ac:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     9b0:	5f4f4950 	svcpl	0x004f4950
     9b4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     9b8:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     9bc:	74654732 	strbtvc	r4, [r5], #-1842	; 0xfffff8ce
     9c0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     9c4:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     9c8:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     9cc:	5f746e65 	svcpl	0x00746e65
     9d0:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     9d4:	6c430076 	mcrrvs	0, 7, r0, r3, cr6
     9d8:	00726165 	rsbseq	r6, r2, r5, ror #2
     9dc:	4b4e5a5f 	blmi	1397360 <__bss_end+0x138d0f4>
     9e0:	4f433331 	svcmi	0x00433331
     9e4:	5f44454c 	svcpl	0x0044454c
     9e8:	70736944 	rsbsvc	r6, r3, r4, asr #18
     9ec:	3979616c 	ldmdbcc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
     9f0:	4f5f7349 	svcmi	0x005f7349
     9f4:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     9f8:	00764564 	rsbseq	r4, r6, r4, ror #10
     9fc:	314e5a5f 	cmpcc	lr, pc, asr sl
     a00:	50474333 	subpl	r4, r7, r3, lsr r3
     a04:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     a08:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a0c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a10:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     a14:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 4b0 <shift+0x4b0>
     a18:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a1c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a20:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     a24:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     a28:	4f495047 	svcmi	0x00495047
     a2c:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     a30:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     a34:	545f7470 	ldrbpl	r7, [pc], #-1136	; a3c <shift+0xa3c>
     a38:	00657079 	rsbeq	r7, r5, r9, ror r0
     a3c:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     a40:	64007966 	strvs	r7, [r0], #-2406	; 0xfffff69a
     a44:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     a48:	6c430072 	mcrrvs	0, 7, r0, r3, cr2
     a4c:	5f726165 	svcpl	0x00726165
     a50:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a54:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     a58:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a5c:	4800746e 	stmdami	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     a60:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a64:	52495f65 	subpl	r5, r9, #404	; 0x194
     a68:	614d0051 	qdaddvs	r0, r1, sp
     a6c:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     a70:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     a74:	00687467 	rsbeq	r7, r8, r7, ror #8
     a78:	4b4e5a5f 	blmi	13973fc <__bss_end+0x138d190>
     a7c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     a80:	5f4f4950 	svcpl	0x004f4950
     a84:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a88:	3172656c 	cmncc	r2, ip, ror #10
     a8c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     a90:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     a94:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     a98:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     a9c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     aa0:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     aa4:	4d005f30 	stcmi	15, cr5, [r0, #-192]	; 0xffffff40
     aa8:	53467861 	movtpl	r7, #26721	; 0x6861
     aac:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     ab0:	614e7265 	cmpvs	lr, r5, ror #4
     ab4:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     ab8:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     abc:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     ac0:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     ac4:	76726573 			; <UNDEFINED> instruction: 0x76726573
     ac8:	6f697461 	svcvs	0x00697461
     acc:	575f736e 	ldrbpl	r7, [pc, -lr, ror #6]
     ad0:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     ad4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ad8:	50433631 	subpl	r3, r3, r1, lsr r6
     adc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ae0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 91c <shift+0x91c>
     ae4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ae8:	31317265 	teqcc	r1, r5, ror #4
     aec:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     af0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     af4:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     af8:	474e0076 	smlsldxmi	r0, lr, r6, r0
     afc:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     b00:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b04:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b08:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     b0c:	73006570 	movwvc	r6, #1392	; 0x570
     b10:	7065656c 	rsbvc	r6, r5, ip, ror #10
     b14:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     b18:	47007265 	strmi	r7, [r0, -r5, ror #4]
     b1c:	5f4f4950 	svcpl	0x004f4950
     b20:	5f6e6950 	svcpl	0x006e6950
     b24:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     b28:	61740074 	cmnvs	r4, r4, ror r0
     b2c:	57006b73 	smlsdxpl	r0, r3, fp, r6
     b30:	5f746961 	svcpl	0x00746961
     b34:	5f726f46 	svcpl	0x00726f46
     b38:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     b3c:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     b40:	50475f74 	subpl	r5, r7, r4, ror pc
     b44:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     b48:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     b4c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     b50:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 9d0 <shift+0x9d0>
     b54:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b58:	50433631 	subpl	r3, r3, r1, lsr r6
     b5c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b60:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 99c <shift+0x99c>
     b64:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b68:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b6c:	5f746547 	svcpl	0x00746547
     b70:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b74:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b78:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     b7c:	32456f66 	subcc	r6, r5, #408	; 0x198
     b80:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     b84:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b88:	5f646568 	svcpl	0x00646568
     b8c:	6f666e49 	svcvs	0x00666e49
     b90:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     b94:	00765065 	rsbseq	r5, r6, r5, rrx
     b98:	474e5254 	smlsldmi	r5, lr, r4, r2
     b9c:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ba0:	65440065 	strbvs	r0, [r4, #-101]	; 0xffffff9b
     ba4:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     ba8:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     bac:	5f6b636f 	svcpl	0x006b636f
     bb0:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     bb4:	6f526d00 	svcvs	0x00526d00
     bb8:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     bbc:	47007379 	smlsdxmi	r0, r9, r3, r7
     bc0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bc4:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     bc8:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     bcc:	6f697461 	svcvs	0x00697461
     bd0:	506d006e 	rsbpl	r0, sp, lr, rrx
     bd4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bd8:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     bdc:	5f747369 	svcpl	0x00747369
     be0:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     be4:	63536d00 	cmpvs	r3, #0, 26
     be8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     bec:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     bf0:	5f00636e 	svcpl	0x0000636e
     bf4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     bf8:	6f725043 	svcvs	0x00725043
     bfc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c00:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c04:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c08:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     c0c:	5f6b636f 	svcpl	0x006b636f
     c10:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     c14:	5f746e65 	svcpl	0x00746e65
     c18:	636f7250 	cmnvs	pc, #80, 4
     c1c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     c20:	576d0076 			; <UNDEFINED> instruction: 0x576d0076
     c24:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     c28:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     c2c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     c30:	636f4c00 	cmnvs	pc, #0, 24
     c34:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     c38:	6b636f6c 	blvs	18dc9f0 <__bss_end+0x18d2784>
     c3c:	6d006465 	cfstrsvs	mvf6, [r0, #-404]	; 0xfffffe6c
     c40:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     c44:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     c48:	6f682f00 	svcvs	0x00682f00
     c4c:	6a2f656d 	bvs	bda208 <__bss_end+0xbcff9c>
     c50:	73656d61 	cmnvc	r5, #6208	; 0x1840
     c54:	2f697261 	svccs	0x00697261
     c58:	2f746967 	svccs	0x00746967
     c5c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     c60:	6f732f70 	svcvs	0x00732f70
     c64:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     c68:	73752f73 	cmnvc	r5, #460	; 0x1cc
     c6c:	70737265 	rsbsvc	r7, r3, r5, ror #4
     c70:	2f656361 	svccs	0x00656361
     c74:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
     c78:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     c7c:	616d2f6b 	cmnvs	sp, fp, ror #30
     c80:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     c84:	5f007070 	svcpl	0x00007070
     c88:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     c8c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     c90:	61485f4f 	cmpvs	r8, pc, asr #30
     c94:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c98:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     c9c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     ca0:	5f4f4950 	svcpl	0x004f4950
     ca4:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     ca8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     cac:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     cb0:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     cb4:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     cb8:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     cbc:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     cc0:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     cc4:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     cc8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ccc:	46433131 			; <UNDEFINED> instruction: 0x46433131
     cd0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     cd4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     cd8:	704f346d 	subvc	r3, pc, sp, ror #8
     cdc:	50456e65 	subpl	r6, r5, r5, ror #28
     ce0:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     ce4:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ce8:	704f5f65 	subvc	r5, pc, r5, ror #30
     cec:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; b60 <shift+0xb60>
     cf0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     cf4:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     cf8:	545f6863 	ldrbpl	r6, [pc], #-2147	; d00 <shift+0xd00>
     cfc:	6c43006f 	mcrrvs	0, 6, r0, r3, cr15
     d00:	0065736f 	rsbeq	r7, r5, pc, ror #6
     d04:	314e5a5f 	cmpcc	lr, pc, asr sl
     d08:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d0c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d10:	614d5f73 	hvcvs	54771	; 0xd5f3
     d14:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d18:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     d1c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d20:	5f656c75 	svcpl	0x00656c75
     d24:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     d28:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     d2c:	50475f74 	subpl	r5, r7, r4, ror pc
     d30:	5f56454c 	svcpl	0x0056454c
     d34:	61636f4c 	cmnvs	r3, ip, asr #30
     d38:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d3c:	43534200 	cmpmi	r3, #0, 4
     d40:	61425f30 	cmpvs	r2, r0, lsr pc
     d44:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     d48:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     d4c:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     d50:	61006567 	tstvs	r0, r7, ror #10
     d54:	00636772 	rsbeq	r6, r3, r2, ror r7
     d58:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     d5c:	5f657672 	svcpl	0x00657672
     d60:	006e6950 	rsbeq	r6, lr, r0, asr r9
     d64:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     d68:	746f6e00 	strbtvc	r6, [pc], #-3584	; d70 <shift+0xd70>
     d6c:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     d70:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     d74:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     d78:	6100656e 	tstvs	r0, lr, ror #10
     d7c:	00766772 	rsbseq	r6, r6, r2, ror r7
     d80:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     d84:	745f3631 	ldrbvc	r3, [pc], #-1585	; d8c <shift+0xd8c>
     d88:	6c614600 	stclvs	6, cr4, [r1], #-0
     d8c:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     d90:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     d94:	4f6d0065 	svcmi	0x006d0065
     d98:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     d9c:	5a5f0064 	bpl	17c0f34 <__bss_end+0x17b6cc8>
     da0:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     da4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     da8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     dac:	34436d65 	strbcc	r6, [r3], #-3429	; 0xfffff29b
     db0:	5f007645 	svcpl	0x00007645
     db4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     db8:	6f725043 	svcvs	0x00725043
     dbc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     dc0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     dc4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     dc8:	6f4e3431 	svcvs	0x004e3431
     dcc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     dd0:	6f72505f 	svcvs	0x0072505f
     dd4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     dd8:	4e006a45 	vmlsmi.f32	s12, s0, s10
     ddc:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     de0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     de4:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     de8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     dec:	70730072 	rsbsvc	r0, r3, r2, ror r0
     df0:	6f6c6e69 	svcvs	0x006c6e69
     df4:	745f6b63 	ldrbvc	r6, [pc], #-2915	; dfc <shift+0xdfc>
     df8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dfc:	4f433331 	svcmi	0x00433331
     e00:	5f44454c 	svcpl	0x0044454c
     e04:	70736944 	rsbsvc	r6, r3, r4, asr #18
     e08:	4479616c 	ldrbtmi	r6, [r9], #-364	; 0xfffffe94
     e0c:	00764534 	rsbseq	r4, r6, r4, lsr r5
     e10:	5f746547 	svcpl	0x00746547
     e14:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     e18:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     e1c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e20:	505f746e 	subspl	r7, pc, lr, ror #8
     e24:	44006e69 	strmi	r6, [r0], #-3689	; 0xfffff197
     e28:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     e2c:	00656e69 	rsbeq	r6, r5, r9, ror #28
     e30:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     e34:	7300746e 	movwvc	r7, #1134	; 0x46e
     e38:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     e3c:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     e40:	4f437e00 	svcmi	0x00437e00
     e44:	5f44454c 	svcpl	0x0044454c
     e48:	70736944 	rsbsvc	r6, r3, r4, asr #18
     e4c:	0079616c 	rsbseq	r6, r9, ip, ror #2
     e50:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     e54:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     e58:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     e5c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     e60:	526d0068 	rsbpl	r0, sp, #104	; 0x68
     e64:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     e68:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     e6c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     e70:	72504300 	subsvc	r4, r0, #0, 6
     e74:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e78:	614d5f73 	hvcvs	54771	; 0xd5f3
     e7c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     e80:	6e550072 	mrcvs	0, 2, r0, cr5, cr2, {3}
     e84:	63657073 	cmnvs	r5, #115	; 0x73
     e88:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     e8c:	5a5f0064 	bpl	17c1024 <__bss_end+0x17b6db8>
     e90:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     e94:	4f495047 	svcmi	0x00495047
     e98:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     e9c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     ea0:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     ea4:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ea8:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     eac:	46730062 	ldrbtmi	r0, [r3], -r2, rrx
     eb0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     eb4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     eb8:	6e49006d 	cdpvs	0, 4, cr0, cr9, cr13, {3}
     ebc:	61697469 	cmnvs	r9, r9, ror #8
     ec0:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     ec4:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     ec8:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ecc:	00646c69 	rsbeq	r6, r4, r9, ror #24
     ed0:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     ed4:	534e0030 	movtpl	r0, #57392	; 0xe030
     ed8:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     edc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     ee0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ee4:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     ee8:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     eec:	534e0065 	movtpl	r0, #57445	; 0xe065
     ef0:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     ef4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ef8:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     efc:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f00:	6f006563 	svcvs	0x00006563
     f04:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     f08:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f0c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     f10:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     f14:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     f18:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     f1c:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     f20:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f24:	6f72505f 	svcvs	0x0072505f
     f28:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f2c:	5f79425f 	svcpl	0x0079425f
     f30:	00444950 	subeq	r4, r4, r0, asr r9
     f34:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     f38:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     f3c:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     f40:	00657361 	rsbeq	r7, r5, r1, ror #6
     f44:	5f746547 	svcpl	0x00746547
     f48:	53465047 	movtpl	r5, #24647	; 0x6047
     f4c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     f50:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     f54:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f58:	314e5a5f 	cmpcc	lr, pc, asr sl
     f5c:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     f60:	445f4445 	ldrbmi	r4, [pc], #-1093	; f68 <shift+0xf68>
     f64:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     f68:	30317961 	eorscc	r7, r1, r1, ror #18
     f6c:	5f747550 	svcpl	0x00747550
     f70:	69727453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, ip, sp, lr}^
     f74:	7445676e 	strbvc	r6, [r5], #-1902	; 0xfffff892
     f78:	634b5074 	movtvs	r5, #45172	; 0xb074
     f7c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f80:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     f84:	4f495047 	svcmi	0x00495047
     f88:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     f8c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     f90:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
     f94:	50475f74 	subpl	r5, r7, r4, ror pc
     f98:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     f9c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     fa0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     fa4:	6c46006a 	mcrrvs	0, 6, r0, r6, cr10
     fa8:	49007069 	stmdbmi	r0, {r0, r3, r5, r6, ip, sp, lr}
     fac:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     fb0:	505f6469 	subspl	r6, pc, r9, ror #8
     fb4:	5f006e69 	svcpl	0x00006e69
     fb8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     fbc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     fc0:	61485f4f 	cmpvs	r8, pc, asr #30
     fc4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     fc8:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
     fcc:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     fd0:	455f656c 	ldrbmi	r6, [pc, #-1388]	; a6c <shift+0xa6c>
     fd4:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     fd8:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     fdc:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
     fe0:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     fe4:	4f495047 	svcmi	0x00495047
     fe8:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     fec:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     ff0:	545f7470 	ldrbpl	r7, [pc], #-1136	; ff8 <shift+0xff8>
     ff4:	00657079 	rsbeq	r7, r5, r9, ror r0
     ff8:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     ffc:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    1000:	61767265 	cmnvs	r6, r5, ror #4
    1004:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1008:	65525f73 	ldrbvs	r5, [r2, #-3955]	; 0xfffff08d
    100c:	4c006461 	cfstrsmi	mvf6, [r0], {97}	; 0x61
    1010:	5f6b636f 	svcpl	0x006b636f
    1014:	6b636f4c 	blvs	18dcd4c <__bss_end+0x18d2ae0>
    1018:	5f006465 	svcpl	0x00006465
    101c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1020:	6f725043 	svcvs	0x00725043
    1024:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1028:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    102c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1030:	61483831 	cmpvs	r8, r1, lsr r8
    1034:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1038:	6f72505f 	svcvs	0x0072505f
    103c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1040:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1044:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    1048:	5f495753 	svcpl	0x00495753
    104c:	636f7250 	cmnvs	pc, #80, 4
    1050:	5f737365 	svcpl	0x00737365
    1054:	76726553 			; <UNDEFINED> instruction: 0x76726553
    1058:	6a656369 	bvs	1959e04 <__bss_end+0x194fb98>
    105c:	31526a6a 	cmpcc	r2, sl, ror #20
    1060:	57535431 	smmlarpl	r3, r1, r4, r5
    1064:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    1068:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    106c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1070:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1074:	5f4f4950 	svcpl	0x004f4950
    1078:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    107c:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
    1080:	656c4330 	strbvs	r4, [ip, #-816]!	; 0xfffffcd0
    1084:	445f7261 	ldrbmi	r7, [pc], #-609	; 108c <shift+0x108c>
    1088:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    108c:	5f646574 	svcpl	0x00646574
    1090:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1094:	006a4574 	rsbeq	r4, sl, r4, ror r5
    1098:	5f746553 	svcpl	0x00746553
    109c:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    10a0:	6373006c 	cmnvs	r3, #108	; 0x6c
    10a4:	5f646568 	svcpl	0x00646568
    10a8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    10ac:	00726574 	rsbseq	r6, r2, r4, ror r5
    10b0:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    10b4:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    10b8:	61686320 	cmnvs	r8, r0, lsr #6
    10bc:	6e490072 	mcrvs	0, 2, r0, cr9, cr2, {3}
    10c0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    10c4:	61747075 	cmnvs	r4, r5, ror r0
    10c8:	5f656c62 	svcpl	0x00656c62
    10cc:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
    10d0:	65470070 	strbvs	r0, [r7, #-112]	; 0xffffff90
    10d4:	50475f74 	subpl	r5, r7, r4, ror pc
    10d8:	5152495f 	cmppl	r2, pc, asr r9
    10dc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    10e0:	5f746365 	svcpl	0x00746365
    10e4:	61636f4c 	cmnvs	r3, ip, asr #30
    10e8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    10ec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10f0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    10f4:	5f4f4950 	svcpl	0x004f4950
    10f8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10fc:	3172656c 	cmncc	r2, ip, ror #10
    1100:	69615734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, lr}^
    1104:	6f465f74 	svcvs	0x00465f74
    1108:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
    110c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    1110:	46493550 			; <UNDEFINED> instruction: 0x46493550
    1114:	6a656c69 	bvs	195c2c0 <__bss_end+0x1952054>
    1118:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    111c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    1120:	52525f65 	subspl	r5, r2, #404	; 0x194
    1124:	58554100 	ldmdapl	r5, {r8, lr}^
    1128:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    112c:	53420065 	movtpl	r0, #8293	; 0x2065
    1130:	425f3243 	subsmi	r3, pc, #805306372	; 0x30000004
    1134:	00657361 	rsbeq	r7, r5, r1, ror #6
    1138:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    113c:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
    1140:	5300796c 	movwpl	r7, #2412	; 0x96c
    1144:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1148:	00656c75 	rsbeq	r6, r5, r5, ror ip
    114c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1150:	50474333 	subpl	r4, r7, r3, lsr r3
    1154:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1158:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    115c:	30317265 	eorscc	r7, r1, r5, ror #4
    1160:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1164:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1168:	76455152 			; <UNDEFINED> instruction: 0x76455152
    116c:	63695400 	cmnvs	r9, #0, 8
    1170:	6f435f6b 	svcvs	0x00435f6b
    1174:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1178:	314e5a5f 	cmpcc	lr, pc, asr sl
    117c:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
    1180:	445f4445 	ldrbmi	r4, [pc], #-1093	; 1188 <shift+0x1188>
    1184:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1188:	53397961 	teqpl	r9, #1589248	; 0x184000
    118c:	505f7465 	subspl	r7, pc, r5, ror #8
    1190:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    1194:	62747445 	rsbsvs	r7, r4, #1157627904	; 0x45000000
    1198:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    119c:	50433631 	subpl	r3, r3, r1, lsr r6
    11a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11a4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; fe0 <shift+0xfe0>
    11a8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    11ac:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    11b0:	616d6e55 	cmnvs	sp, r5, asr lr
    11b4:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    11b8:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
    11bc:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    11c0:	6a45746e 	bvs	115e380 <__bss_end+0x1154114>
    11c4:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    11c8:	4900305f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, ip, sp}
    11cc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    11d0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    11d4:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 11dc <shift+0x11dc>
    11d8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    11dc:	6c410072 	mcrrvs	0, 7, r0, r1, cr2
    11e0:	00325f74 	eorseq	r5, r2, r4, ror pc
    11e4:	5f746c41 	svcpl	0x00746c41
    11e8:	6c410033 	mcrrvs	0, 3, r0, r1, cr3
    11ec:	00345f74 	eorseq	r5, r4, r4, ror pc
    11f0:	5f746c41 	svcpl	0x00746c41
    11f4:	5a5f0035 	bpl	17c12d0 <__bss_end+0x17b7064>
    11f8:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
    11fc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1200:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1204:	33316d65 	teqcc	r1, #6464	; 0x1940
    1208:	5f534654 	svcpl	0x00534654
    120c:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
    1210:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1218 <shift+0x1218>
    1214:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
    1218:	5f646e69 	svcpl	0x00646e69
    121c:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
    1220:	4b504564 	blmi	14127b8 <__bss_end+0x140854c>
    1224:	61480063 	cmpvs	r8, r3, rrx
    1228:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    122c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1230:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1234:	5f6d6574 	svcpl	0x006d6574
    1238:	00495753 	subeq	r5, r9, r3, asr r7
    123c:	4b4e5a5f 	blmi	1397bc0 <__bss_end+0x138d954>
    1240:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1244:	5f4f4950 	svcpl	0x004f4950
    1248:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    124c:	3172656c 	cmncc	r2, ip, ror #10
    1250:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    1254:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
    1258:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
    125c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    1260:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    1264:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    1268:	73005f30 	movwvc	r5, #3888	; 0xf30
    126c:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
    1270:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1274:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1278:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    127c:	616d0074 	smcvs	53252	; 0xd004
    1280:	64006e69 	strvs	r6, [r0], #-3689	; 0xfffff197
    1284:	00707369 	rsbseq	r7, r0, r9, ror #6
    1288:	6f725073 	svcvs	0x00725073
    128c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1290:	0072674d 	rsbseq	r6, r2, sp, asr #14
    1294:	5f747550 	svcpl	0x00747550
    1298:	69727453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, ip, sp, lr}^
    129c:	4300676e 	movwmi	r6, #1902	; 0x76e
    12a0:	4f495047 	svcmi	0x00495047
    12a4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    12a8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    12ac:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    12b0:	6300315f 	movwvs	r3, #351	; 0x15f
    12b4:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
    12b8:	006e6572 	rsbeq	r6, lr, r2, ror r5
    12bc:	61736944 	cmnvs	r3, r4, asr #18
    12c0:	5f656c62 	svcpl	0x00656c62
    12c4:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    12c8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    12cc:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    12d0:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
    12d4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    12d8:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
    12dc:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    12e0:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    12e4:	61425f72 	hvcvs	9714	; 0x25f2
    12e8:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    12ec:	445f5346 	ldrbmi	r5, [pc], #-838	; 12f4 <shift+0x12f4>
    12f0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    12f4:	65520072 	ldrbvs	r0, [r2, #-114]	; 0xffffff8e
    12f8:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
    12fc:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1300:	464e4900 	strbmi	r4, [lr], -r0, lsl #18
    1304:	54494e49 	strbpl	r4, [r9], #-3657	; 0xfffff1b7
    1308:	63410059 	movtvs	r0, #4185	; 0x1059
    130c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1310:	6f72505f 	svcvs	0x0072505f
    1314:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1318:	756f435f 	strbvc	r4, [pc, #-863]!	; fc1 <shift+0xfc1>
    131c:	5f00746e 	svcpl	0x0000746e
    1320:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1324:	6f725043 	svcvs	0x00725043
    1328:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    132c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1330:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1334:	61483132 	cmpvs	r8, r2, lsr r1
    1338:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    133c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1340:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1344:	5f6d6574 	svcpl	0x006d6574
    1348:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    134c:	534e3332 	movtpl	r3, #58162	; 0xe332
    1350:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    1354:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1358:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    135c:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    1360:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1364:	6a6a6a65 	bvs	1a9bd00 <__bss_end+0x1a91a94>
    1368:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    136c:	5f495753 	svcpl	0x00495753
    1370:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1374:	4500746c 	strmi	r7, [r0, #-1132]	; 0xfffffb94
    1378:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    137c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1380:	5f746e65 	svcpl	0x00746e65
    1384:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1388:	74007463 	strvc	r7, [r0], #-1123	; 0xfffffb9d
    138c:	5f676e72 	svcpl	0x00676e72
    1390:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    1394:	6f6c6300 	svcvs	0x006c6300
    1398:	53006573 	movwpl	r6, #1395	; 0x573
    139c:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    13a0:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
    13a4:	00657669 	rsbeq	r7, r5, r9, ror #12
    13a8:	76746572 			; <UNDEFINED> instruction: 0x76746572
    13ac:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    13b0:	00727563 	rsbseq	r7, r2, r3, ror #10
    13b4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    13b8:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
    13bc:	5f006d75 	svcpl	0x00006d75
    13c0:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    13c4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    13c8:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    13cc:	0076646c 	rsbseq	r6, r6, ip, ror #8
    13d0:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
    13d4:	5f746573 	svcpl	0x00746573
    13d8:	6b736174 	blvs	1cd99b0 <__bss_end+0x1ccf744>
    13dc:	6165645f 	cmnvs	r5, pc, asr r4
    13e0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    13e4:	77006a65 	strvc	r6, [r0, -r5, ror #20]
    13e8:	00746961 	rsbseq	r6, r4, r1, ror #18
    13ec:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
    13f0:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    13f4:	006a6a79 	rsbeq	r6, sl, r9, ror sl
    13f8:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
    13fc:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1400:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1404:	61460069 	cmpvs	r6, r9, rrx
    1408:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
    140c:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    1410:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1414:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    1418:	5f746567 	svcpl	0x00746567
    141c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1420:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1424:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1428:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    142c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1430:	63730076 	cmnvs	r3, #118	; 0x76
    1434:	5f646568 	svcpl	0x00646568
    1438:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    143c:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
    1440:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1444:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1448:	7165725f 	cmnvc	r5, pc, asr r2
    144c:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
    1450:	69500064 	ldmdbvs	r0, {r2, r5, r6}^
    1454:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    1458:	5f656c69 	svcpl	0x00656c69
    145c:	66657250 			; <UNDEFINED> instruction: 0x66657250
    1460:	53007869 	movwpl	r7, #2153	; 0x869
    1464:	505f7465 	subspl	r7, pc, r5, ror #8
    1468:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    146c:	5a5f0073 	bpl	17c1640 <__bss_end+0x17b73d4>
    1470:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    1474:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1478:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    147c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1480:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
    1484:	00706565 	rsbseq	r6, r0, r5, ror #10
    1488:	61736944 	cmnvs	r3, r4, asr #18
    148c:	5f656c62 	svcpl	0x00656c62
    1490:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1494:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    1498:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    149c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    14a0:	5f746573 	svcpl	0x00746573
    14a4:	6b736174 	blvs	1cd9a7c <__bss_end+0x1ccf810>
    14a8:	6165645f 	cmnvs	r5, pc, asr r4
    14ac:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    14b0:	706f0065 	rsbvc	r0, pc, r5, rrx
    14b4:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    14b8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    14bc:	63355a5f 	teqvs	r5, #389120	; 0x5f000
    14c0:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    14c4:	682f006a 	stmdavs	pc!, {r1, r3, r5, r6}	; <UNPREDICTABLE>
    14c8:	2f656d6f 	svccs	0x00656d6f
    14cc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    14d0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    14d4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    14d8:	2f736f2f 	svccs	0x00736f2f
    14dc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    14e0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    14e4:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    14e8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    14ec:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    14f0:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    14f4:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    14f8:	70632e65 	rsbvc	r2, r3, r5, ror #28
    14fc:	5a5f0070 	bpl	17c16c4 <__bss_end+0x17b7458>
    1500:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    1504:	76646970 			; <UNDEFINED> instruction: 0x76646970
    1508:	616e6600 	cmnvs	lr, r0, lsl #12
    150c:	6e00656d 	cfsh32vs	mvfx6, mvfx0, #61
    1510:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1514:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
    1518:	00736b63 	rsbseq	r6, r3, r3, ror #22
    151c:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1520:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1524:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    1528:	6a634b50 	bvs	18d4270 <__bss_end+0x18ca004>
    152c:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
    1530:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1534:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
    1538:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
    153c:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1540:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1544:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1548:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    154c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1550:	6f682f00 	svcvs	0x00682f00
    1554:	6a2f656d 	bvs	bdab10 <__bss_end+0xbd08a4>
    1558:	73656d61 	cmnvc	r5, #6208	; 0x1840
    155c:	2f697261 	svccs	0x00697261
    1560:	2f746967 	svccs	0x00746967
    1564:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    1568:	6f732f70 	svcvs	0x00732f70
    156c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1570:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    1574:	00646c69 	rsbeq	r6, r4, r9, ror #24
    1578:	61726170 	cmnvs	r2, r0, ror r1
    157c:	5a5f006d 	bpl	17c1738 <__bss_end+0x17b74cc>
    1580:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1584:	506a6574 	rsbpl	r6, sl, r4, ror r5
    1588:	006a634b 	rsbeq	r6, sl, fp, asr #6
    158c:	5f746567 	svcpl	0x00746567
    1590:	6b736174 	blvs	1cd9b68 <__bss_end+0x1ccf8fc>
    1594:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1598:	745f736b 	ldrbvc	r7, [pc], #-875	; 15a0 <shift+0x15a0>
    159c:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    15a0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    15a4:	7700656e 	strvc	r6, [r0, -lr, ror #10]
    15a8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    15ac:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    15b0:	7a69735f 	bvc	1a5e334 <__bss_end+0x1a540c8>
    15b4:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
    15b8:	61505f74 	cmpvs	r0, r4, ror pc
    15bc:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
    15c0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    15c4:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    15c8:	006a6a70 	rsbeq	r6, sl, r0, ror sl
    15cc:	5f746547 	svcpl	0x00746547
    15d0:	616d6552 	cmnvs	sp, r2, asr r5
    15d4:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
    15d8:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
    15dc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    15e0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    15e4:	445f746e 	ldrbmi	r7, [pc], #-1134	; 15ec <shift+0x15ec>
    15e8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    15ec:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    15f0:	325a5f00 	subscc	r5, sl, #0, 30
    15f4:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    15f8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    15fc:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1600:	5f736b63 	svcpl	0x00736b63
    1604:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 160c <shift+0x160c>
    1608:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    160c:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    1610:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    1614:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    1618:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    161c:	646f435f 	strbtvs	r4, [pc], #-863	; 1624 <shift+0x1624>
    1620:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1624:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1628:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    162c:	6a746961 	bvs	1d1bbb8 <__bss_end+0x1d1194c>
    1630:	5f006a6a 	svcpl	0x00006a6a
    1634:	6f69355a 	svcvs	0x0069355a
    1638:	6a6c7463 	bvs	1b1e7cc <__bss_end+0x1b14560>
    163c:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    1640:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1644:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1648:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    164c:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    1650:	636f6900 	cmnvs	pc, #0, 18
    1654:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1658:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    165c:	6f6d0074 	svcvs	0x006d0074
    1660:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    1664:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1668:	5a5f0072 	bpl	17c1838 <__bss_end+0x17b75cc>
    166c:	61657234 	cmnvs	r5, r4, lsr r2
    1670:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1674:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    1678:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    167c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1680:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1684:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    1688:	6f637465 	svcvs	0x00637465
    168c:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1690:	615f7465 	cmpvs	pc, r5, ror #8
    1694:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1698:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    169c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    16a0:	6f635f73 	svcvs	0x00635f73
    16a4:	00746e75 	rsbseq	r6, r4, r5, ror lr
    16a8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    16ac:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    16b0:	61657200 	cmnvs	r5, r0, lsl #4
    16b4:	65740064 	ldrbvs	r0, [r4, #-100]!	; 0xffffff9c
    16b8:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    16bc:	00657461 	rsbeq	r7, r5, r1, ror #8
    16c0:	70746567 	rsbsvc	r6, r4, r7, ror #10
    16c4:	5f006469 	svcpl	0x00006469
    16c8:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    16cc:	4b506e65 	blmi	141d068 <__bss_end+0x1412dfc>
    16d0:	4e353163 	rsfmisz	f3, f5, f3
    16d4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    16d8:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    16dc:	6f4d5f6e 	svcvs	0x004d5f6e
    16e0:	47006564 	strmi	r6, [r0, -r4, ror #10]
    16e4:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    16e8:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    16ec:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    16f0:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    16f4:	31393130 	teqcc	r9, r0, lsr r1
    16f8:	20353230 	eorscs	r3, r5, r0, lsr r2
    16fc:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1700:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1704:	415b2029 	cmpmi	fp, r9, lsr #32
    1708:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    170c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1710:	6172622d 	cmnvs	r2, sp, lsr #4
    1714:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1718:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    171c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1720:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1724:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1728:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    172c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1730:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1734:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1738:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    173c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1740:	20706676 	rsbscs	r6, r0, r6, ror r6
    1744:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1748:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    174c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1750:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1754:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1758:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    175c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1760:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    1764:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    1768:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    176c:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1770:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    1774:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1778:	616d2d20 	cmnvs	sp, r0, lsr #26
    177c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1780:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1784:	2b6b7a36 	blcs	1ae0064 <__bss_end+0x1ad5df8>
    1788:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    178c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1790:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1794:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    1798:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    179c:	6f6e662d 	svcvs	0x006e662d
    17a0:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    17a4:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    17a8:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    17ac:	6f6e662d 	svcvs	0x006e662d
    17b0:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    17b4:	5a5f0069 	bpl	17c1960 <__bss_end+0x17b76f4>
    17b8:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    17bc:	50797063 	rsbspl	r7, r9, r3, rrx
    17c0:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    17c4:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    17c8:	2f656d6f 	svccs	0x00656d6f
    17cc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    17d0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    17d4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    17d8:	2f736f2f 	svccs	0x00736f2f
    17dc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    17e0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    17e4:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    17e8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    17ec:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    17f0:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    17f4:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    17f8:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    17fc:	00707063 	rsbseq	r7, r0, r3, rrx
    1800:	616d6572 	smcvs	54866	; 0xd652
    1804:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    1808:	73690072 	cmnvc	r9, #114	; 0x72
    180c:	006e616e 	rsbeq	r6, lr, lr, ror #2
    1810:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1814:	6c617267 	sfmvs	f7, 2, [r1], #-412	; 0xfffffe64
    1818:	69736900 	ldmdbvs	r3!, {r8, fp, sp, lr}^
    181c:	6400666e 	strvs	r6, [r0], #-1646	; 0xfffff992
    1820:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1824:	5f006c61 	svcpl	0x00006c61
    1828:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    182c:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1830:	61006a63 	tstvs	r0, r3, ror #20
    1834:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1838:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    183c:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1840:	73006e65 	movwvc	r6, #3685	; 0xe65
    1844:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1848:	65645f67 	strbvs	r5, [r4, #-3943]!	; 0xfffff099
    184c:	616d6963 	cmnvs	sp, r3, ror #18
    1850:	7000736c 	andvc	r7, r0, ip, ror #6
    1854:	7265776f 	rsbvc	r7, r5, #29097984	; 0x1bc0000
    1858:	72747300 	rsbsvc	r7, r4, #0, 6
    185c:	5f676e69 	svcpl	0x00676e69
    1860:	5f746e69 	svcpl	0x00746e69
    1864:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1868:	6f707865 	svcvs	0x00707865
    186c:	746e656e 	strbtvc	r6, [lr], #-1390	; 0xfffffa92
    1870:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1874:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1878:	00634b50 	rsbeq	r4, r3, r0, asr fp
    187c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1880:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1884:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    1888:	63507274 	cmpvs	r0, #116, 4	; 0x40000007
    188c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1890:	616e7369 	cmnvs	lr, r9, ror #6
    1894:	6900666e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, sp, lr}
    1898:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    189c:	73616200 	cmnvc	r1, #0, 4
    18a0:	65740065 	ldrbvs	r0, [r4, #-101]!	; 0xffffff9b
    18a4:	5f00706d 	svcpl	0x0000706d
    18a8:	7a62355a 	bvc	188ee18 <__bss_end+0x1884bac>
    18ac:	506f7265 	rsbpl	r7, pc, r5, ror #4
    18b0:	73006976 	movwvc	r6, #2422	; 0x976
    18b4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    18b8:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    18bc:	00616f74 	rsbeq	r6, r1, r4, ror pc
    18c0:	31727473 	cmncc	r2, r3, ror r4
    18c4:	72747300 	rsbsvc	r7, r4, #0, 6
    18c8:	5f676e69 	svcpl	0x00676e69
    18cc:	00746e69 	rsbseq	r6, r4, r9, ror #28
    18d0:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    18d4:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    18d8:	5a5f0066 	bpl	17c1a78 <__bss_end+0x17b780c>
    18dc:	776f7033 			; <UNDEFINED> instruction: 0x776f7033
    18e0:	5f006a66 	svcpl	0x00006a66
    18e4:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    18e8:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    18ec:	6f6c665f 	svcvs	0x006c665f
    18f0:	52667461 	rsbpl	r7, r6, #1627389952	; 0x61000000
    18f4:	525f536a 	subspl	r5, pc, #-1476395007	; 0xa8000001
    18f8:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    18fc:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1900:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1904:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1908:	6f437261 	svcvs	0x00437261
    190c:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1910:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    1914:	5f00616f 	svcpl	0x0000616f
    1918:	6433325a 	ldrtvs	r3, [r3], #-602	; 0xfffffda6
    191c:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1920:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1928 <shift+0x1928>
    1924:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    1928:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    192c:	6f6c665f 	svcvs	0x006c665f
    1930:	506a7461 	rsbpl	r7, sl, r1, ror #8
    1934:	6d006963 	vstrvs.16	s12, [r0, #-198]	; 0xffffff3a	; <UNPREDICTABLE>
    1938:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    193c:	72700063 	rsbsvc	r0, r0, #99	; 0x63
    1940:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    1944:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1948:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    194c:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1950:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1954:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
    1958:	73007865 	movwvc	r7, #2149	; 0x865
    195c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1960:	6400706d 	strvs	r7, [r0], #-109	; 0xffffff93
    1964:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    1968:	5a5f0073 	bpl	17c1b3c <__bss_end+0x17b78d0>
    196c:	6f746134 	svcvs	0x00746134
    1970:	634b5069 	movtvs	r5, #45161	; 0xb069
    1974:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1978:	00747570 	rsbseq	r7, r4, r0, ror r5
    197c:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1980:	66616f74 	uqsub16vs	r6, r1, r4
    1984:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1988:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    198c:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    1990:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1994:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    1998:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    199c:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    19a0:	4b506e65 	blmi	141d33c <__bss_end+0x14130d0>
    19a4:	5a5f0063 	bpl	17c1b38 <__bss_end+0x17b78cc>
    19a8:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    19ac:	706d636e 	rsbvc	r6, sp, lr, ror #6
    19b0:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    19b4:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    19b8:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    19bc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    19c0:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    19c4:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    19c8:	63656400 	cmnvs	r5, #0, 8
    19cc:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    19d0:	5f6f745f 	svcpl	0x006f745f
    19d4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    19d8:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    19dc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    19e0:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    19e4:	616f7466 	cmnvs	pc, r6, ror #8
    19e8:	00635066 	rsbeq	r5, r3, r6, rrx
    19ec:	6f6d656d 	svcvs	0x006d656d
    19f0:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    19f4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    19f8:	74730068 	ldrbtvc	r0, [r3], #-104	; 0xffffff98
    19fc:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1a00:	76657200 	strbtvc	r7, [r5], -r0, lsl #4
    1a04:	00727473 	rsbseq	r7, r2, r3, ror r4
    1a08:	6e695f5f 	mcrvs	15, 3, r5, cr9, cr15, {2}
    1a0c:	7268635f 	rsbvc	r6, r8, #2080374785	; 0x7c000001
    1a10:	44540067 	ldrbmi	r0, [r4], #-103	; 0xffffff99
    1a14:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1a18:	505f7961 	subspl	r7, pc, r1, ror #18
    1a1c:	656b6361 	strbvs	r6, [fp, #-865]!	; 0xfffffc9f
    1a20:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
    1a24:	72656461 	rsbvc	r6, r5, #1627389952	; 0x61000000
    1a28:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1a2c:	616c7073 	smcvs	50947	; 0xc703
    1a30:	6f4e5f79 	svcvs	0x004e5f79
    1a34:	7261506e 	rsbvc	r5, r1, #110	; 0x6e
    1a38:	74656d61 	strbtvc	r6, [r5], #-3425	; 0xfffff29f
    1a3c:	5f636972 	svcpl	0x00636972
    1a40:	6b636150 	blvs	18d9f88 <__bss_end+0x18cfd1c>
    1a44:	74007465 	strvc	r7, [r0], #-1125	; 0xfffffb9b
    1a48:	00736968 	rsbseq	r6, r3, r8, ror #18
    1a4c:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
    1a50:	6e6f465f 	mcrvs	6, 3, r4, cr15, cr15, {2}
    1a54:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    1a58:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    1a5c:	66760074 			; <UNDEFINED> instruction: 0x66760074
    1a60:	0070696c 	rsbseq	r6, r0, ip, ror #18
    1a64:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 19b0 <shift+0x19b0>
    1a68:	616a2f65 	cmnvs	sl, r5, ror #30
    1a6c:	6173656d 	cmnvs	r3, sp, ror #10
    1a70:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    1a74:	6f2f7469 	svcvs	0x002f7469
    1a78:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    1a7c:	756f732f 	strbvc	r7, [pc, #-815]!	; 1755 <shift+0x1755>
    1a80:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1a84:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1a88:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    1a8c:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
    1a90:	6c6f2f63 	stclvs	15, cr2, [pc], #-396	; 190c <shift+0x190c>
    1a94:	632e6465 			; <UNDEFINED> instruction: 0x632e6465
    1a98:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
    1a9c:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1aa0:	5f79616c 	svcpl	0x0079616c
    1aa4:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1aa8:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1aac:	415f6c65 	cmpmi	pc, r5, ror #24
    1ab0:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1ab4:	6361505f 	cmnvs	r1, #95	; 0x5f
    1ab8:	0074656b 	rsbseq	r6, r4, fp, ror #10
    1abc:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1ac0:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1ac4:	415f6c65 	cmpmi	pc, r5, ror #24
    1ac8:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1acc:	5f6f545f 	svcpl	0x006f545f
    1ad0:	74636552 	strbtvc	r6, [r3], #-1362	; 0xfffffaae
    1ad4:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1ad8:	616c7073 	smcvs	50947	; 0xc703
    1adc:	69505f79 	ldmdbvs	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ae0:	5f6c6578 	svcpl	0x006c6578
    1ae4:	63657053 	cmnvs	r5, #83	; 0x53
    1ae8:	74617000 	strbtvc	r7, [r1], #-0
    1aec:	44540068 	ldrbmi	r0, [r4], #-104	; 0xffffff98
    1af0:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1af4:	505f7961 	subspl	r7, pc, r1, ror #18
    1af8:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    1afc:	6f545f73 	svcvs	0x00545f73
    1b00:	6365525f 	cmnvs	r5, #-268435451	; 0xf0000005
    1b04:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1b08:	455f7261 	ldrbmi	r7, [pc, #-609]	; 18af <shift+0x18af>
    1b0c:	4600646e 	strmi	r6, [r0], -lr, ror #8
    1b10:	5f70696c 	svcpl	0x0070696c
    1b14:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1b18:	44540073 	ldrbmi	r0, [r4], #-115	; 0xffffff8d
    1b1c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1b20:	435f7961 	cmpmi	pc, #1589248	; 0x184000
    1b24:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    1b28:	6361505f 	cmnvs	r1, #95	; 0x5f
    1b2c:	0074656b 	rsbseq	r6, r4, fp, ror #10
    1b30:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1b34:	6469575f 	strbtvs	r5, [r9], #-1887	; 0xfffff8a1
    1b38:	4f006874 	svcmi	0x00006874
    1b3c:	5f44454c 	svcpl	0x0044454c
    1b40:	746e6f46 	strbtvc	r6, [lr], #-3910	; 0xfffff0ba
    1b44:	69444e00 	stmdbvs	r4, {r9, sl, fp, lr}^
    1b48:	616c7073 	smcvs	50947	; 0xc703
    1b4c:	6f435f79 	svcvs	0x00435f79
    1b50:	6e616d6d 	cdpvs	13, 6, cr6, cr1, cr13, {3}
    1b54:	69660064 	stmdbvs	r6!, {r2, r5, r6}^
    1b58:	00747372 	rsbseq	r7, r4, r2, ror r3
    1b5c:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1b60:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1b64:	415f6c65 	cmpmi	pc, r5, ror #24
    1b68:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1b6c:	656c6300 	strbvs	r6, [ip, #-768]!	; 0xfffffd00
    1b70:	65537261 	ldrbvs	r7, [r3, #-609]	; 0xfffffd9f
    1b74:	5a5f0074 	bpl	17c1d4c <__bss_end+0x17b7ae0>
    1b78:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1b7c:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
    1b80:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
    1b84:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1b88:	50453243 	subpl	r3, r5, r3, asr #4
    1b8c:	7500634b 	strvc	r6, [r0, #-843]	; 0xfffffcb5
    1b90:	38746e69 	ldmdacc	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1b94:	4300745f 	movwmi	r7, #1119	; 0x45f
    1b98:	5f726168 	svcpl	0x00726168
    1b9c:	67696548 	strbvs	r6, [r9, -r8, asr #10]!
    1ba0:	68007468 	stmdavs	r0, {r3, r5, r6, sl, ip, sp, lr}
    1ba4:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1ba8:	68430072 	stmdavs	r3, {r1, r4, r5, r6}^
    1bac:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
    1bb0:	6e696765 	cdpvs	7, 6, cr6, cr9, cr5, {3}
    1bb4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1bb8:	4f433331 	svcmi	0x00433331
    1bbc:	5f44454c 	svcpl	0x0044454c
    1bc0:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1bc4:	4479616c 	ldrbtmi	r6, [r9], #-364	; 0xfffffe94
    1bc8:	00764532 	rsbseq	r4, r6, r2, lsr r5
    1bcc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1bd0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1bd4:	2f2e2e2f 	svccs	0x002e2e2f
    1bd8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1bdc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1be0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1be4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1be8:	2f676966 	svccs	0x00676966
    1bec:	2f6d7261 	svccs	0x006d7261
    1bf0:	3162696c 	cmncc	r2, ip, ror #18
    1bf4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1bf8:	00532e73 	subseq	r2, r3, r3, ror lr
    1bfc:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1c00:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1c04:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1c08:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1c0c:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1c10:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1c14:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1c18:	2f39546b 	svccs	0x0039546b
    1c1c:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1c20:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1c24:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1c28:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1c2c:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1c30:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1c34:	2f34712d 	svccs	0x0034712d
    1c38:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1c3c:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1c40:	6f6e2d6d 	svcvs	0x006e2d6d
    1c44:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1c48:	2f696261 	svccs	0x00696261
    1c4c:	2f6d7261 	svccs	0x006d7261
    1c50:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1c54:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1c58:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1c5c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c60:	52415400 	subpl	r5, r1, #0, 8
    1c64:	5f544547 	svcpl	0x00544547
    1c68:	5f555043 	svcpl	0x00555043
    1c6c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c70:	31617865 	cmncc	r1, r5, ror #16
    1c74:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1c78:	61786574 	cmnvs	r8, r4, ror r5
    1c7c:	73690037 	cmnvc	r9, #55	; 0x37
    1c80:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c84:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1c88:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1c8c:	6d726100 	ldfvse	f6, [r2, #-0]
    1c90:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1c94:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1c98:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1c9c:	52415400 	subpl	r5, r1, #0, 8
    1ca0:	5f544547 	svcpl	0x00544547
    1ca4:	5f555043 	svcpl	0x00555043
    1ca8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1cac:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1cb0:	52410033 	subpl	r0, r1, #51	; 0x33
    1cb4:	51455f4d 	cmppl	r5, sp, asr #30
    1cb8:	52415400 	subpl	r5, r1, #0, 8
    1cbc:	5f544547 	svcpl	0x00544547
    1cc0:	5f555043 	svcpl	0x00555043
    1cc4:	316d7261 	cmncc	sp, r1, ror #4
    1cc8:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1ccc:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1cd0:	5f617369 	svcpl	0x00617369
    1cd4:	5f746962 	svcpl	0x00746962
    1cd8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1cdc:	41540062 	cmpmi	r4, r2, rrx
    1ce0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ce4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ce8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cec:	61786574 	cmnvs	r8, r4, ror r5
    1cf0:	6f633735 	svcvs	0x00633735
    1cf4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cf8:	00333561 	eorseq	r3, r3, r1, ror #10
    1cfc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d00:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d04:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1d08:	5341425f 	movtpl	r4, #4703	; 0x125f
    1d0c:	41540045 	cmpmi	r4, r5, asr #32
    1d10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d18:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d1c:	00303138 	eorseq	r3, r0, r8, lsr r1
    1d20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d28:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1d2c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1d30:	52410031 	subpl	r0, r1, #49	; 0x31
    1d34:	43505f4d 	cmpmi	r0, #308	; 0x134
    1d38:	41415f53 	cmpmi	r1, r3, asr pc
    1d3c:	5f534350 	svcpl	0x00534350
    1d40:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1d44:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1d48:	5f455341 	svcpl	0x00455341
    1d4c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d50:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1d54:	5f455341 	svcpl	0x00455341
    1d58:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d5c:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1d60:	5f455341 	svcpl	0x00455341
    1d64:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d68:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1d6c:	5f455341 	svcpl	0x00455341
    1d70:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d74:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1d78:	5f455341 	svcpl	0x00455341
    1d7c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d80:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1d84:	5f455341 	svcpl	0x00455341
    1d88:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d8c:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1d90:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d94:	50435f54 	subpl	r5, r3, r4, asr pc
    1d98:	73785f55 	cmnvc	r8, #340	; 0x154
    1d9c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1da0:	61736900 	cmnvs	r3, r0, lsl #18
    1da4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1da8:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1dac:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1db0:	52415400 	subpl	r5, r1, #0, 8
    1db4:	5f544547 	svcpl	0x00544547
    1db8:	5f555043 	svcpl	0x00555043
    1dbc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1dc0:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1dc4:	41540033 	cmpmi	r4, r3, lsr r0
    1dc8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dcc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1dd0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1dd4:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1dd8:	73690069 	cmnvc	r9, #105	; 0x69
    1ddc:	6f6e5f61 	svcvs	0x006e5f61
    1de0:	00746962 	rsbseq	r6, r4, r2, ror #18
    1de4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1de8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dec:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1df0:	31316d72 	teqcc	r1, r2, ror sp
    1df4:	7a6a3637 	bvc	1a8f6d8 <__bss_end+0x1a8546c>
    1df8:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1dfc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e00:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1e04:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1e08:	4d524100 	ldfmie	f4, [r2, #-0]
    1e0c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1e10:	4b4e555f 	blmi	1397394 <__bss_end+0x138d128>
    1e14:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1e18:	52415400 	subpl	r5, r1, #0, 8
    1e1c:	5f544547 	svcpl	0x00544547
    1e20:	5f555043 	svcpl	0x00555043
    1e24:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1e28:	41420065 	cmpmi	r2, r5, rrx
    1e2c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e30:	5f484352 	svcpl	0x00484352
    1e34:	4a455435 	bmi	1156f10 <__bss_end+0x114cca4>
    1e38:	6d726100 	ldfvse	f6, [r2, #-0]
    1e3c:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1e40:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1e44:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1e48:	6d726100 	ldfvse	f6, [r2, #-0]
    1e4c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e50:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1e54:	736e7500 	cmnvc	lr, #0, 10
    1e58:	5f636570 	svcpl	0x00636570
    1e5c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1e60:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1e64:	5f617369 	svcpl	0x00617369
    1e68:	5f746962 	svcpl	0x00746962
    1e6c:	00636573 	rsbeq	r6, r3, r3, ror r5
    1e70:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1e74:	61745f7a 	cmnvs	r4, sl, ror pc
    1e78:	52410062 	subpl	r0, r1, #98	; 0x62
    1e7c:	43565f4d 	cmpmi	r6, #308	; 0x134
    1e80:	6d726100 	ldfvse	f6, [r2, #-0]
    1e84:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e88:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1e8c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1e90:	4d524100 	ldfmie	f4, [r2, #-0]
    1e94:	00454c5f 	subeq	r4, r5, pc, asr ip
    1e98:	5f4d5241 	svcpl	0x004d5241
    1e9c:	41005356 	tstmi	r0, r6, asr r3
    1ea0:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1ea4:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1ea8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1eac:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1eb0:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1eb4:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1eb8:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1ec0 <shift+0x1ec0>
    1ebc:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1ec0:	6f6c6620 	svcvs	0x006c6620
    1ec4:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1ec8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ecc:	50435f54 	subpl	r5, r3, r4, asr pc
    1ed0:	6f635f55 	svcvs	0x00635f55
    1ed4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ed8:	00353161 	eorseq	r3, r5, r1, ror #2
    1edc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ee0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ee4:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1ee8:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1eec:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1ef0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ef4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ef8:	6f635f55 	svcvs	0x00635f55
    1efc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f00:	00373161 	eorseq	r3, r7, r1, ror #2
    1f04:	5f4d5241 	svcpl	0x004d5241
    1f08:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1f0c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f10:	50435f54 	subpl	r5, r3, r4, asr pc
    1f14:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1f18:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1f1c:	316e6573 	smccc	58963	; 0xe653
    1f20:	2f2e2e00 	svccs	0x002e2e00
    1f24:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f28:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f2c:	2f2e2e2f 	svccs	0x002e2e2f
    1f30:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1e80 <shift+0x1e80>
    1f34:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f38:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1f3c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1f40:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1f44:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f48:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f4c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f50:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f54:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1f58:	53414200 	movtpl	r4, #4608	; 0x1200
    1f5c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1f60:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1f64:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1f68:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f6c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f70:	6f635f55 	svcvs	0x00635f55
    1f74:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f78:	00323161 	eorseq	r3, r2, r1, ror #2
    1f7c:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1f80:	5f6c6176 	svcpl	0x006c6176
    1f84:	41420074 	hvcmi	8196	; 0x2004
    1f88:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1f8c:	5f484352 	svcpl	0x00484352
    1f90:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1f94:	5f617369 	svcpl	0x00617369
    1f98:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f9c:	6d726100 	ldfvse	f6, [r2, #-0]
    1fa0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1fa4:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1fa8:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1fac:	00766964 	rsbseq	r6, r6, r4, ror #18
    1fb0:	5f6d7261 	svcpl	0x006d7261
    1fb4:	5f757066 	svcpl	0x00757066
    1fb8:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1fbc:	61736900 	cmnvs	r3, r0, lsl #18
    1fc0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fc4:	3170665f 	cmncc	r0, pc, asr r6
    1fc8:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1fcc:	31432055 	qdaddcc	r2, r5, r3
    1fd0:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1fd4:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1fd8:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1fdc:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1fe0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1fe4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1fe8:	5b202965 	blpl	80c584 <__bss_end+0x802318>
    1fec:	2f4d5241 	svccs	0x004d5241
    1ff0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1ff4:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1ff8:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1ffc:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    2000:	6f697369 	svcvs	0x00697369
    2004:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    2008:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    200c:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    2010:	206d7261 	rsbcs	r7, sp, r1, ror #4
    2014:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    2018:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    201c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    2020:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    2024:	616d2d20 	cmnvs	sp, r0, lsr #26
    2028:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    202c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2030:	2b657435 	blcs	195f10c <__bss_end+0x1954ea0>
    2034:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    2038:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    203c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2040:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    2044:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    2048:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    204c:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    2050:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    2054:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    2058:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    205c:	662d2063 	strtvs	r2, [sp], -r3, rrx
    2060:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    2064:	6b636174 	blvs	18da63c <__bss_end+0x18d03d0>
    2068:	6f72702d 	svcvs	0x0072702d
    206c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2070:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    2074:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1ee4 <shift+0x1ee4>
    2078:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    207c:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    2080:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    2084:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    2088:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    208c:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    2090:	41006e65 	tstmi	r0, r5, ror #28
    2094:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    2098:	73690049 	cmnvc	r9, #73	; 0x49
    209c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20a0:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    20a4:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    20a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20ac:	50435f54 	subpl	r5, r3, r4, asr pc
    20b0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    20b4:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    20b8:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    20bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20c4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20c8:	00386d72 	eorseq	r6, r8, r2, ror sp
    20cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20d4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20d8:	00396d72 	eorseq	r6, r9, r2, ror sp
    20dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20e4:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    20e8:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    20ec:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    20f0:	6f6c2067 	svcvs	0x006c2067
    20f4:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    20f8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    20fc:	2064656e 	rsbcs	r6, r4, lr, ror #10
    2100:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2104:	5f6d7261 	svcpl	0x006d7261
    2108:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    210c:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    2110:	41540065 	cmpmi	r4, r5, rrx
    2114:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2118:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    211c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2120:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2124:	41540034 	cmpmi	r4, r4, lsr r0
    2128:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    212c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2130:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2134:	00653031 	rsbeq	r3, r5, r1, lsr r0
    2138:	47524154 			; <UNDEFINED> instruction: 0x47524154
    213c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2140:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2144:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2148:	00376d78 	eorseq	r6, r7, r8, ror sp
    214c:	5f6d7261 	svcpl	0x006d7261
    2150:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    2154:	646f635f 	strbtvs	r6, [pc], #-863	; 215c <shift+0x215c>
    2158:	52410065 	subpl	r0, r1, #101	; 0x65
    215c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2160:	41415f53 	cmpmi	r1, r3, asr pc
    2164:	00534350 	subseq	r4, r3, r0, asr r3
    2168:	5f617369 	svcpl	0x00617369
    216c:	5f746962 	svcpl	0x00746962
    2170:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2174:	00325f38 	eorseq	r5, r2, r8, lsr pc
    2178:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    217c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2180:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    2184:	52415400 	subpl	r5, r1, #0, 8
    2188:	5f544547 	svcpl	0x00544547
    218c:	5f555043 	svcpl	0x00555043
    2190:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2194:	00743031 	rsbseq	r3, r4, r1, lsr r0
    2198:	5f6d7261 	svcpl	0x006d7261
    219c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    21a0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    21a4:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    21a8:	61736900 	cmnvs	r3, r0, lsl #18
    21ac:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    21b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21b4:	41540073 	cmpmi	r4, r3, ror r0
    21b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21c0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    21c4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    21c8:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    21cc:	616d7373 	smcvs	55091	; 0xd733
    21d0:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    21d4:	7069746c 	rsbvc	r7, r9, ip, ror #8
    21d8:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    21dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21e0:	50435f54 	subpl	r5, r3, r4, asr pc
    21e4:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    21e8:	736f6e79 	cmnvc	pc, #1936	; 0x790
    21ec:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    21f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21f4:	50435f54 	subpl	r5, r3, r4, asr pc
    21f8:	6f635f55 	svcvs	0x00635f55
    21fc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2200:	00323572 	eorseq	r3, r2, r2, ror r5
    2204:	5f617369 	svcpl	0x00617369
    2208:	5f746962 	svcpl	0x00746962
    220c:	76696474 			; <UNDEFINED> instruction: 0x76696474
    2210:	65727000 	ldrbvs	r7, [r2, #-0]!
    2214:	5f726566 	svcpl	0x00726566
    2218:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    221c:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    2220:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    2224:	00737469 	rsbseq	r7, r3, r9, ror #8
    2228:	5f617369 	svcpl	0x00617369
    222c:	5f746962 	svcpl	0x00746962
    2230:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2234:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    2238:	47524154 			; <UNDEFINED> instruction: 0x47524154
    223c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2240:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2244:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2248:	32336178 	eorscc	r6, r3, #120, 2
    224c:	52415400 	subpl	r5, r1, #0, 8
    2250:	5f544547 	svcpl	0x00544547
    2254:	5f555043 	svcpl	0x00555043
    2258:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    225c:	33617865 	cmncc	r1, #6619136	; 0x650000
    2260:	73690035 	cmnvc	r9, #53	; 0x35
    2264:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2268:	70665f74 	rsbvc	r5, r6, r4, ror pc
    226c:	6f633631 	svcvs	0x00633631
    2270:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    2274:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    2278:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    227c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    2280:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    2284:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2288:	50435f54 	subpl	r5, r3, r4, asr pc
    228c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2290:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    2294:	73327436 	teqvc	r2, #905969664	; 0x36000000
    2298:	52415400 	subpl	r5, r1, #0, 8
    229c:	5f544547 	svcpl	0x00544547
    22a0:	5f555043 	svcpl	0x00555043
    22a4:	30366166 	eorscc	r6, r6, r6, ror #2
    22a8:	00657436 	rsbeq	r7, r5, r6, lsr r4
    22ac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22b0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22b4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    22b8:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    22bc:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    22c0:	53414200 	movtpl	r4, #4608	; 0x1200
    22c4:	52415f45 	subpl	r5, r1, #276	; 0x114
    22c8:	345f4843 	ldrbcc	r4, [pc], #-2115	; 22d0 <shift+0x22d0>
    22cc:	73690054 	cmnvc	r9, #84	; 0x54
    22d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22d4:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    22d8:	6f747079 	svcvs	0x00747079
    22dc:	6d726100 	ldfvse	f6, [r2, #-0]
    22e0:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    22e4:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    22e8:	7165735f 	cmnvc	r5, pc, asr r3
    22ec:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    22f0:	73690065 	cmnvc	r9, #101	; 0x65
    22f4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22f8:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    22fc:	53414200 	movtpl	r4, #4608	; 0x1200
    2300:	52415f45 	subpl	r5, r1, #276	; 0x114
    2304:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1ac9 <shift+0x1ac9>
    2308:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    230c:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    2310:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    2314:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    2318:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    231c:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2320:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2324:	006c756d 	rsbeq	r7, ip, sp, ror #10
    2328:	5f6d7261 	svcpl	0x006d7261
    232c:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    2330:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    2334:	5f747570 	svcpl	0x00747570
    2338:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    233c:	615f7463 	cmpvs	pc, r3, ror #8
    2340:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    2344:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    2348:	6f685f73 	svcvs	0x00685f73
    234c:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    2350:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2354:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2358:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    235c:	52410032 	subpl	r0, r1, #50	; 0x32
    2360:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    2364:	61736900 	cmnvs	r3, r0, lsl #18
    2368:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    236c:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    2370:	52415400 	subpl	r5, r1, #0, 8
    2374:	5f544547 	svcpl	0x00544547
    2378:	5f555043 	svcpl	0x00555043
    237c:	316d7261 	cmncc	sp, r1, ror #4
    2380:	6a363731 	bvs	d9004c <__bss_end+0xd85de0>
    2384:	7000737a 	andvc	r7, r0, sl, ror r3
    2388:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    238c:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    2390:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    2394:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    2398:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    239c:	61007375 	tstvs	r0, r5, ror r3
    23a0:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    23a4:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    23a8:	5f455341 	svcpl	0x00455341
    23ac:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    23b0:	0054355f 	subseq	r3, r4, pc, asr r5
    23b4:	5f6d7261 	svcpl	0x006d7261
    23b8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    23bc:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    23c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23c4:	50435f54 	subpl	r5, r3, r4, asr pc
    23c8:	6f635f55 	svcvs	0x00635f55
    23cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23d0:	63363761 	teqvs	r6, #25427968	; 0x1840000
    23d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    23d8:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    23dc:	6d726100 	ldfvse	f6, [r2, #-0]
    23e0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    23e4:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    23e8:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    23ec:	5f626174 	svcpl	0x00626174
    23f0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    23f4:	61736900 	cmnvs	r3, r0, lsl #18
    23f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23fc:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2400:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    2404:	6f765f6f 	svcvs	0x00765f6f
    2408:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    240c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2410:	41540065 	cmpmi	r4, r5, rrx
    2414:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2418:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    241c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2420:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2424:	41540030 	cmpmi	r4, r0, lsr r0
    2428:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    242c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2430:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2434:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2438:	41540031 	cmpmi	r4, r1, lsr r0
    243c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2440:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2444:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2448:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    244c:	73690033 	cmnvc	r9, #51	; 0x33
    2450:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2454:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2458:	5f38766d 	svcpl	0x0038766d
    245c:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2460:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2464:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2468:	00656d61 	rsbeq	r6, r5, r1, ror #26
    246c:	5f617369 	svcpl	0x00617369
    2470:	5f746962 	svcpl	0x00746962
    2474:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2478:	00335f38 	eorseq	r5, r3, r8, lsr pc
    247c:	5f617369 	svcpl	0x00617369
    2480:	5f746962 	svcpl	0x00746962
    2484:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2488:	00345f38 	eorseq	r5, r4, r8, lsr pc
    248c:	5f617369 	svcpl	0x00617369
    2490:	5f746962 	svcpl	0x00746962
    2494:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2498:	00355f38 	eorseq	r5, r5, r8, lsr pc
    249c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    24a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    24ac:	33356178 	teqcc	r5, #120, 2
    24b0:	52415400 	subpl	r5, r1, #0, 8
    24b4:	5f544547 	svcpl	0x00544547
    24b8:	5f555043 	svcpl	0x00555043
    24bc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24c0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    24c4:	41540035 	cmpmi	r4, r5, lsr r0
    24c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    24d4:	61786574 	cmnvs	r8, r4, ror r5
    24d8:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    24dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24e0:	50435f54 	subpl	r5, r3, r4, asr pc
    24e4:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    24e8:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    24ec:	52415400 	subpl	r5, r1, #0, 8
    24f0:	5f544547 	svcpl	0x00544547
    24f4:	5f555043 	svcpl	0x00555043
    24f8:	5f6d7261 	svcpl	0x006d7261
    24fc:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    2500:	6d726100 	ldfvse	f6, [r2, #-0]
    2504:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2508:	6f6e5f68 	svcvs	0x006e5f68
    250c:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    2510:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2514:	50435f54 	subpl	r5, r3, r4, asr pc
    2518:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    251c:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    2520:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    2524:	53414200 	movtpl	r4, #4608	; 0x1200
    2528:	52415f45 	subpl	r5, r1, #276	; 0x114
    252c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2530:	4142004a 	cmpmi	r2, sl, asr #32
    2534:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2538:	5f484352 	svcpl	0x00484352
    253c:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    2540:	5f455341 	svcpl	0x00455341
    2544:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2548:	004d365f 	subeq	r3, sp, pc, asr r6
    254c:	5f617369 	svcpl	0x00617369
    2550:	5f746962 	svcpl	0x00746962
    2554:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2558:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    255c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2560:	50435f54 	subpl	r5, r3, r4, asr pc
    2564:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2568:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    256c:	73666a36 	cmnvc	r6, #221184	; 0x36000
    2570:	4d524100 	ldfmie	f4, [r2, #-0]
    2574:	00534c5f 	subseq	r4, r3, pc, asr ip
    2578:	5f4d5241 	svcpl	0x004d5241
    257c:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    2580:	5f455341 	svcpl	0x00455341
    2584:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2588:	005a365f 	subseq	r3, sl, pc, asr r6
    258c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2590:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2594:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2598:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    259c:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    25a0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25a4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25a8:	52410035 	subpl	r0, r1, #53	; 0x35
    25ac:	43505f4d 	cmpmi	r0, #308	; 0x134
    25b0:	41415f53 	cmpmi	r1, r3, asr pc
    25b4:	5f534350 	svcpl	0x00534350
    25b8:	00504656 	subseq	r4, r0, r6, asr r6
    25bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25c4:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    25c8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    25cc:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    25d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    25d4:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    25d8:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    25dc:	5f6d7261 	svcpl	0x006d7261
    25e0:	5f757066 	svcpl	0x00757066
    25e4:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    25e8:	61736900 	cmnvs	r3, r0, lsl #18
    25ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    25f4:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    25f8:	52415400 	subpl	r5, r1, #0, 8
    25fc:	5f544547 	svcpl	0x00544547
    2600:	5f555043 	svcpl	0x00555043
    2604:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    2608:	00657436 	rsbeq	r7, r5, r6, lsr r4
    260c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2610:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2614:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 24dc <shift+0x24dc>
    2618:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    261c:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    2620:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    2624:	5f626174 	svcpl	0x00626174
    2628:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    262c:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2630:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2634:	6d726100 	ldfvse	f6, [r2, #-0]
    2638:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    263c:	6f635f65 	svcvs	0x00635f65
    2640:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2644:	0039615f 	eorseq	r6, r9, pc, asr r1
    2648:	5f617369 	svcpl	0x00617369
    264c:	5f746962 	svcpl	0x00746962
    2650:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2654:	00327478 	eorseq	r7, r2, r8, ror r4
    2658:	47524154 			; <UNDEFINED> instruction: 0x47524154
    265c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2660:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2664:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2668:	32376178 	eorscc	r6, r7, #120, 2
    266c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2670:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2674:	73690033 	cmnvc	r9, #51	; 0x33
    2678:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    267c:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2680:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2684:	53414200 	movtpl	r4, #4608	; 0x1200
    2688:	52415f45 	subpl	r5, r1, #276	; 0x114
    268c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2690:	73690041 	cmnvc	r9, #65	; 0x41
    2694:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2698:	6f645f74 	svcvs	0x00645f74
    269c:	6f727074 	svcvs	0x00727074
    26a0:	72610064 	rsbvc	r0, r1, #100	; 0x64
    26a4:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    26a8:	745f3631 	ldrbvc	r3, [pc], #-1585	; 26b0 <shift+0x26b0>
    26ac:	5f657079 	svcpl	0x00657079
    26b0:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    26b4:	4d524100 	ldfmie	f4, [r2, #-0]
    26b8:	00494d5f 	subeq	r4, r9, pc, asr sp
    26bc:	5f6d7261 	svcpl	0x006d7261
    26c0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    26c4:	61006b36 	tstvs	r0, r6, lsr fp
    26c8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    26cc:	36686372 			; <UNDEFINED> instruction: 0x36686372
    26d0:	4142006d 	cmpmi	r2, sp, rrx
    26d4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26d8:	5f484352 	svcpl	0x00484352
    26dc:	5f005237 	svcpl	0x00005237
    26e0:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    26e4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    26e8:	61745f74 	cmnvs	r4, r4, ror pc
    26ec:	73690062 	cmnvc	r9, #98	; 0x62
    26f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26f4:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    26f8:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    26fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2700:	50435f54 	subpl	r5, r3, r4, asr pc
    2704:	6f635f55 	svcvs	0x00635f55
    2708:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    270c:	00333761 	eorseq	r3, r3, r1, ror #14
    2710:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2714:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2718:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    271c:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    2720:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    2724:	41540061 	cmpmi	r4, r1, rrx
    2728:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    272c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2730:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2734:	61786574 	cmnvs	r8, r4, ror r5
    2738:	61003637 	tstvs	r0, r7, lsr r6
    273c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2740:	5f686372 	svcpl	0x00686372
    2744:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2748:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    274c:	5f656c69 	svcpl	0x00656c69
    2750:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    2754:	5f455341 	svcpl	0x00455341
    2758:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    275c:	0041385f 	subeq	r3, r1, pc, asr r8
    2760:	5f617369 	svcpl	0x00617369
    2764:	5f746962 	svcpl	0x00746962
    2768:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    276c:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    2770:	5f455341 	svcpl	0x00455341
    2774:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2778:	0052385f 	subseq	r3, r2, pc, asr r8
    277c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2780:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2784:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2788:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    278c:	33376178 	teqcc	r7, #120, 2
    2790:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2794:	33617865 	cmncc	r1, #6619136	; 0x650000
    2798:	52410035 	subpl	r0, r1, #53	; 0x35
    279c:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    27a0:	6d726100 	ldfvse	f6, [r2, #-0]
    27a4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    27a8:	61003468 	tstvs	r0, r8, ror #8
    27ac:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27b0:	36686372 			; <UNDEFINED> instruction: 0x36686372
    27b4:	6d726100 	ldfvse	f6, [r2, #-0]
    27b8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    27bc:	61003768 	tstvs	r0, r8, ror #14
    27c0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27c4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    27c8:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    27cc:	6f642067 	svcvs	0x00642067
    27d0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    27d4:	6d726100 	ldfvse	f6, [r2, #-0]
    27d8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    27dc:	73785f65 	cmnvc	r8, #404	; 0x194
    27e0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    27e4:	6b616d00 	blvs	185dbec <__bss_end+0x1853980>
    27e8:	5f676e69 	svcpl	0x00676e69
    27ec:	736e6f63 	cmnvc	lr, #396	; 0x18c
    27f0:	61745f74 	cmnvs	r4, r4, ror pc
    27f4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    27f8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    27fc:	61635f62 	cmnvs	r3, r2, ror #30
    2800:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    2804:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    2808:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    280c:	61736900 	cmnvs	r3, r0, lsl #18
    2810:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2814:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    2818:	73690035 	cmnvc	r9, #53	; 0x35
    281c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2820:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2824:	6b36766d 	blvs	da01e0 <__bss_end+0xd95f74>
    2828:	52415400 	subpl	r5, r1, #0, 8
    282c:	5f544547 	svcpl	0x00544547
    2830:	5f555043 	svcpl	0x00555043
    2834:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2838:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    283c:	52415400 	subpl	r5, r1, #0, 8
    2840:	5f544547 	svcpl	0x00544547
    2844:	5f555043 	svcpl	0x00555043
    2848:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    284c:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2850:	52415400 	subpl	r5, r1, #0, 8
    2854:	5f544547 	svcpl	0x00544547
    2858:	5f555043 	svcpl	0x00555043
    285c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2860:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2864:	4d524100 	ldfmie	f4, [r2, #-0]
    2868:	5343505f 	movtpl	r5, #12383	; 0x305f
    286c:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    2870:	52410053 	subpl	r0, r1, #83	; 0x53
    2874:	43505f4d 	cmpmi	r0, #308	; 0x134
    2878:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    287c:	00534350 	subseq	r4, r3, r0, asr r3
    2880:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    2884:	2078656c 	rsbscs	r6, r8, ip, ror #10
    2888:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    288c:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    2890:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2894:	50435f54 	subpl	r5, r3, r4, asr pc
    2898:	6f635f55 	svcvs	0x00635f55
    289c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    28a0:	63333761 	teqvs	r3, #25427968	; 0x1840000
    28a4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    28a8:	33356178 	teqcc	r5, #120, 2
    28ac:	52415400 	subpl	r5, r1, #0, 8
    28b0:	5f544547 	svcpl	0x00544547
    28b4:	5f555043 	svcpl	0x00555043
    28b8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    28bc:	306d7865 	rsbcc	r7, sp, r5, ror #16
    28c0:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    28c4:	6d726100 	ldfvse	f6, [r2, #-0]
    28c8:	0063635f 	rsbeq	r6, r3, pc, asr r3
    28cc:	5f617369 	svcpl	0x00617369
    28d0:	5f746962 	svcpl	0x00746962
    28d4:	61637378 	smcvs	14136	; 0x3738
    28d8:	5f00656c 	svcpl	0x0000656c
    28dc:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    28e0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    28e4:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    28e8:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    28ec:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    28f0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28f4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    28f8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    28fc:	30316d72 	eorscc	r6, r1, r2, ror sp
    2900:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2904:	52415400 	subpl	r5, r1, #0, 8
    2908:	5f544547 	svcpl	0x00544547
    290c:	5f555043 	svcpl	0x00555043
    2910:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2914:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2918:	73616200 	cmnvc	r1, #0, 4
    291c:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2920:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2924:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2928:	61006572 	tstvs	r0, r2, ror r5
    292c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2930:	5f686372 	svcpl	0x00686372
    2934:	00637263 	rsbeq	r7, r3, r3, ror #4
    2938:	47524154 			; <UNDEFINED> instruction: 0x47524154
    293c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2940:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2944:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2948:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    294c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2950:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2954:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2958:	6d726100 	ldfvse	f6, [r2, #-0]
    295c:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    2960:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2964:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2968:	5f617369 	svcpl	0x00617369
    296c:	5f746962 	svcpl	0x00746962
    2970:	33637263 	cmncc	r3, #805306374	; 0x30000006
    2974:	52410032 	subpl	r0, r1, #50	; 0x32
    2978:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    297c:	61736900 	cmnvs	r3, r0, lsl #18
    2980:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2984:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2988:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    298c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2990:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2994:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2998:	53414200 	movtpl	r4, #4608	; 0x1200
    299c:	52415f45 	subpl	r5, r1, #276	; 0x114
    29a0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    29a4:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    29a8:	5f455341 	svcpl	0x00455341
    29ac:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    29b0:	5f4d385f 	svcpl	0x004d385f
    29b4:	4e49414d 	dvfmiem	f4, f1, #5.0
    29b8:	52415400 	subpl	r5, r1, #0, 8
    29bc:	5f544547 	svcpl	0x00544547
    29c0:	5f555043 	svcpl	0x00555043
    29c4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    29c8:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    29cc:	4d524100 	ldfmie	f4, [r2, #-0]
    29d0:	004c415f 	subeq	r4, ip, pc, asr r1
    29d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    29d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    29dc:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    29e0:	6d726100 	ldfvse	f6, [r2, #-0]
    29e4:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    29e8:	5f746567 	svcpl	0x00746567
    29ec:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    29f0:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    29f4:	61745f6d 	cmnvs	r4, sp, ror #30
    29f8:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    29fc:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2a00:	4154006e 	cmpmi	r4, lr, rrx
    2a04:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a08:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a0c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2a10:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2a14:	41540034 	cmpmi	r4, r4, lsr r0
    2a18:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a1c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a20:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2a24:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2a28:	41540035 	cmpmi	r4, r5, lsr r0
    2a2c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a30:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a34:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2a38:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2a3c:	41540037 	cmpmi	r4, r7, lsr r0
    2a40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a48:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2a4c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2a50:	73690038 	cmnvc	r9, #56	; 0x38
    2a54:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2a58:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    2a5c:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    2a60:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a64:	715f7469 	cmpvc	pc, r9, ror #8
    2a68:	6b726975 	blvs	1c9d044 <__bss_end+0x1c92dd8>
    2a6c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2a70:	7a6b3676 	bvc	1ad0450 <__bss_end+0x1ac61e4>
    2a74:	61736900 	cmnvs	r3, r0, lsl #18
    2a78:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a7c:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2a84 <shift+0x2a84>
    2a80:	7369006d 	cmnvc	r9, #109	; 0x6d
    2a84:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2a88:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2a8c:	0034766d 	eorseq	r7, r4, sp, ror #12
    2a90:	5f617369 	svcpl	0x00617369
    2a94:	5f746962 	svcpl	0x00746962
    2a98:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2a9c:	73690036 	cmnvc	r9, #54	; 0x36
    2aa0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2aa4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2aa8:	0037766d 	eorseq	r7, r7, sp, ror #12
    2aac:	5f617369 	svcpl	0x00617369
    2ab0:	5f746962 	svcpl	0x00746962
    2ab4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2ab8:	645f0038 	ldrbvs	r0, [pc], #-56	; 2ac0 <shift+0x2ac0>
    2abc:	5f746e6f 	svcpl	0x00746e6f
    2ac0:	5f657375 	svcpl	0x00657375
    2ac4:	5f787472 	svcpl	0x00787472
    2ac8:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2acc:	5155005f 	cmppl	r5, pc, asr r0
    2ad0:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2ad4:	73690065 	cmnvc	r9, #101	; 0x65
    2ad8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2adc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2ae0:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2ae4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2ae8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2aec:	6100656e 	tstvs	r0, lr, ror #10
    2af0:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2af4:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2af8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2afc:	6b726f77 	blvs	1c9e8e0 <__bss_end+0x1c94674>
    2b00:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    2b04:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2b08:	41540072 	cmpmi	r4, r2, ror r0
    2b0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b14:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2b18:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2b1c:	61746800 	cmnvs	r4, r0, lsl #16
    2b20:	71655f62 	cmnvc	r5, r2, ror #30
    2b24:	52415400 	subpl	r5, r1, #0, 8
    2b28:	5f544547 	svcpl	0x00544547
    2b2c:	5f555043 	svcpl	0x00555043
    2b30:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2b34:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2b38:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2b3c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2b44 <shift+0x2b44>
    2b40:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2b44:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2b48:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2b4c:	5f626174 	svcpl	0x00626174
    2b50:	705f7165 	subsvc	r7, pc, r5, ror #2
    2b54:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2b58:	61007265 	tstvs	r0, r5, ror #4
    2b5c:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2b60:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    2b64:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    2b68:	00726574 	rsbseq	r6, r2, r4, ror r5
    2b6c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b70:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b74:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2b78:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2b7c:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2b80:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2b84:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2b88:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2b8c:	52415400 	subpl	r5, r1, #0, 8
    2b90:	5f544547 	svcpl	0x00544547
    2b94:	5f555043 	svcpl	0x00555043
    2b98:	6f63706d 	svcvs	0x0063706d
    2b9c:	6f6e6572 	svcvs	0x006e6572
    2ba0:	00706676 	rsbseq	r6, r0, r6, ror r6
    2ba4:	5f617369 	svcpl	0x00617369
    2ba8:	5f746962 	svcpl	0x00746962
    2bac:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2bb0:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2bb4:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    2bb8:	41006472 	tstmi	r0, r2, ror r4
    2bbc:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2bc0:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2bc4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2bc8:	5f386863 	svcpl	0x00386863
    2bcc:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2bd0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2bd4:	5f386863 	svcpl	0x00386863
    2bd8:	72610033 	rsbvc	r0, r1, #51	; 0x33
    2bdc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2be0:	5f386863 	svcpl	0x00386863
    2be4:	41540034 	cmpmi	r4, r4, lsr r0
    2be8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2bec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2bf0:	706d665f 	rsbvc	r6, sp, pc, asr r6
    2bf4:	00363236 	eorseq	r3, r6, r6, lsr r2
    2bf8:	5f4d5241 	svcpl	0x004d5241
    2bfc:	61005343 	tstvs	r0, r3, asr #6
    2c00:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2c04:	5f363170 	svcpl	0x00363170
    2c08:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2c0c:	6d726100 	ldfvse	f6, [r2, #-0]
    2c10:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2c14:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2c18:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2c1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2c20:	50435f54 	subpl	r5, r3, r4, asr pc
    2c24:	6f635f55 	svcvs	0x00635f55
    2c28:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2c2c:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    2c30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2c34:	00376178 	eorseq	r6, r7, r8, ror r1
    2c38:	5f6d7261 	svcpl	0x006d7261
    2c3c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2c40:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2c44:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2c48:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2c4c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2c50:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2c54:	32376178 	eorscc	r6, r7, #120, 2
    2c58:	6d726100 	ldfvse	f6, [r2, #-0]
    2c5c:	7363705f 	cmnvc	r3, #95	; 0x5f
    2c60:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2c64:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2c68:	4d524100 	ldfmie	f4, [r2, #-0]
    2c6c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2c70:	5041415f 	subpl	r4, r1, pc, asr r1
    2c74:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2c78:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2c7c:	52415400 	subpl	r5, r1, #0, 8
    2c80:	5f544547 	svcpl	0x00544547
    2c84:	5f555043 	svcpl	0x00555043
    2c88:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2c8c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2c90:	41540035 	cmpmi	r4, r5, lsr r0
    2c94:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2c98:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2c9c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2ca0:	61676e6f 	cmnvs	r7, pc, ror #28
    2ca4:	61006d72 	tstvs	r0, r2, ror sp
    2ca8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2cac:	5f686372 	svcpl	0x00686372
    2cb0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2cb4:	61003162 	tstvs	r0, r2, ror #2
    2cb8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2cbc:	5f686372 	svcpl	0x00686372
    2cc0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2cc4:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2cc8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ccc:	50435f54 	subpl	r5, r3, r4, asr pc
    2cd0:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2cd4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2cd8:	6d726100 	ldfvse	f6, [r2, #-0]
    2cdc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2ce0:	00743568 	rsbseq	r3, r4, r8, ror #10
    2ce4:	5f617369 	svcpl	0x00617369
    2ce8:	5f746962 	svcpl	0x00746962
    2cec:	6100706d 	tstvs	r0, sp, rrx
    2cf0:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2cf4:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2cf8:	00646568 	rsbeq	r6, r4, r8, ror #10
    2cfc:	5f6d7261 	svcpl	0x006d7261
    2d00:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2d04:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf96c4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3465c4>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f96e4>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8a14>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9714>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346614>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9734>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346634>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9754>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346654>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9774>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346674>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9794>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346694>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf97b4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3466b4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf97d4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3466d4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f97ec>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f980c>
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
 194:	0000010c 	andeq	r0, r0, ip, lsl #2
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f983c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008338 	andeq	r8, r0, r8, lsr r3
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9868>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346768>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008364 	andeq	r8, r0, r4, ror #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9888>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346788>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008390 	muleq	r0, r0, r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf98a8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3467a8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000083ac 	andeq	r8, r0, ip, lsr #7
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf98c8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3467c8>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083f0 	strdeq	r8, [r0], -r0
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf98e8>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x3467e8>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008440 	andeq	r8, r0, r0, asr #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9908>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346808>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008490 	muleq	r0, r0, r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9928>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346828>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9948>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346848>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	0000850c 	andeq	r8, r0, ip, lsl #10
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9968>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346868>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008550 	andeq	r8, r0, r0, asr r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9988>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346888>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000085a0 	andeq	r8, r0, r0, lsr #11
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf99a8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3468a8>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085f4 	strdeq	r8, [r0], -r4
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf99c8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3468c8>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008630 	andeq	r8, r0, r0, lsr r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf99e8>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3468e8>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000866c 	andeq	r8, r0, ip, ror #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf9a08>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346908>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000086a8 	andeq	r8, r0, r8, lsr #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf9a28>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346928>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086e4 	andeq	r8, r0, r4, ror #13
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1f9a48>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008794 	muleq	r0, r4, r7
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1f9a78>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008908 	andeq	r8, r0, r8, lsl #18
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xf9a98>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x346998>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000089a4 	andeq	r8, r0, r4, lsr #19
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xf9ab8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3469b8>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a64 	andeq	r8, r0, r4, ror #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xf9ad8>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3469d8>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b10 	andeq	r8, r0, r0, lsl fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xf9af8>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x3469f8>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b64 	andeq	r8, r0, r4, ror #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xf9b18>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x346a18>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008bcc 	andeq	r8, r0, ip, asr #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xf9b38>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x346a38>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008c4c 	andeq	r8, r0, ip, asr #24
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xf9b58>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x346a58>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1f9b78>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008d7c 	andeq	r8, r0, ip, ror sp
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xf9b98>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x346a98>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	000091bc 			; <UNDEFINED> instruction: 0x000091bc
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1f9bbc>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009290 	muleq	r0, r0, r2
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xf9bdc>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x346adc>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	000092cc 	andeq	r9, r0, ip, asr #5
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xf9bfc>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x346afc>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	0000930c 	andeq	r9, r0, ip, lsl #6
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1f9c1c>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	0000933c 	andeq	r9, r0, ip, lsr r3
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1f9c3c>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	00009660 	andeq	r9, r0, r0, ror #12
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xf9c60>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x346b60>
 5c4:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 5c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 5cc:	0000000c 	andeq	r0, r0, ip
 5d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5d4:	7c020001 	stcvc	0, cr0, [r2], {1}
 5d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 5e0:	000005cc 	andeq	r0, r0, ip, asr #11
 5e4:	00009770 	andeq	r9, r0, r0, ror r7
 5e8:	00000068 	andeq	r0, r0, r8, rrx
 5ec:	8b080e42 	blhi	203efc <__bss_end+0x1f9c90>
 5f0:	42018e02 	andmi	r8, r1, #2, 28
 5f4:	6e040b0c 	vmlavs.f64	d0, d4, d12
 5f8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 600:	000005cc 	andeq	r0, r0, ip, asr #11
 604:	000097d8 	ldrdeq	r9, [r0], -r8
 608:	0000004c 	andeq	r0, r0, ip, asr #32
 60c:	8b080e42 	blhi	203f1c <__bss_end+0x1f9cb0>
 610:	42018e02 	andmi	r8, r1, #2, 28
 614:	60040b0c 	andvs	r0, r4, ip, lsl #22
 618:	00080d0c 	andeq	r0, r8, ip, lsl #26
 61c:	0000001c 	andeq	r0, r0, ip, lsl r0
 620:	000005cc 	andeq	r0, r0, ip, asr #11
 624:	00009824 	andeq	r9, r0, r4, lsr #16
 628:	00000028 	andeq	r0, r0, r8, lsr #32
 62c:	8b040e42 	blhi	103f3c <__bss_end+0xf9cd0>
 630:	0b0d4201 	bleq	350e3c <__bss_end+0x346bd0>
 634:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 638:	00000ecb 	andeq	r0, r0, fp, asr #29
 63c:	0000001c 	andeq	r0, r0, ip, lsl r0
 640:	000005cc 	andeq	r0, r0, ip, asr #11
 644:	0000984c 	andeq	r9, r0, ip, asr #16
 648:	0000007c 	andeq	r0, r0, ip, ror r0
 64c:	8b080e42 	blhi	203f5c <__bss_end+0x1f9cf0>
 650:	42018e02 	andmi	r8, r1, #2, 28
 654:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 658:	00080d0c 	andeq	r0, r8, ip, lsl #26
 65c:	0000001c 	andeq	r0, r0, ip, lsl r0
 660:	000005cc 	andeq	r0, r0, ip, asr #11
 664:	000098c8 	andeq	r9, r0, r8, asr #17
 668:	000000ec 	andeq	r0, r0, ip, ror #1
 66c:	8b080e42 	blhi	203f7c <__bss_end+0x1f9d10>
 670:	42018e02 	andmi	r8, r1, #2, 28
 674:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 678:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 67c:	0000001c 	andeq	r0, r0, ip, lsl r0
 680:	000005cc 	andeq	r0, r0, ip, asr #11
 684:	000099b4 			; <UNDEFINED> instruction: 0x000099b4
 688:	00000168 	andeq	r0, r0, r8, ror #2
 68c:	8b080e42 	blhi	203f9c <__bss_end+0x1f9d30>
 690:	42018e02 	andmi	r8, r1, #2, 28
 694:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 698:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 69c:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a0:	000005cc 	andeq	r0, r0, ip, asr #11
 6a4:	00009b1c 	andeq	r9, r0, ip, lsl fp
 6a8:	00000058 	andeq	r0, r0, r8, asr r0
 6ac:	8b080e42 	blhi	203fbc <__bss_end+0x1f9d50>
 6b0:	42018e02 	andmi	r8, r1, #2, 28
 6b4:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 6b8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 6c0:	000005cc 	andeq	r0, r0, ip, asr #11
 6c4:	00009b74 	andeq	r9, r0, r4, ror fp
 6c8:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 6cc:	8b080e42 	blhi	203fdc <__bss_end+0x1f9d70>
 6d0:	42018e02 	andmi	r8, r1, #2, 28
 6d4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 6d8:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 6dc:	0000000c 	andeq	r0, r0, ip
 6e0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6e4:	7c010001 	stcvc	0, cr0, [r1], {1}
 6e8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6ec:	0000000c 	andeq	r0, r0, ip
 6f0:	000006dc 	ldrdeq	r0, [r0], -ip
 6f4:	00009c24 	andeq	r9, r0, r4, lsr #24
 6f8:	000001ec 	andeq	r0, r0, ip, ror #3
