
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
    805c:	0000a28c 	andeq	sl, r0, ip, lsl #5
    8060:	0000a29c 	muleq	r0, ip, r2

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
    81cc:	0000a278 	andeq	sl, r0, r8, ror r2
    81d0:	0000a278 	andeq	sl, r0, r8, ror r2

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
    8224:	0000a278 	andeq	sl, r0, r8, ror r2
    8228:	0000a278 	andeq	sl, r0, r8, ror r2

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
    8324:	00009f30 	andeq	r9, r0, r0, lsr pc
    8328:	00009f3c 	andeq	r9, r0, ip, lsr pc
    832c:	00009f50 	andeq	r9, r0, r0, asr pc
    8330:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    8334:	0000a278 	andeq	sl, r0, r8, ror r2

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
    8790:	00009f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>

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
    8904:	00009fac 	andeq	r9, r0, ip, lsr #31

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
    9178:	0a4fb11f 	beq	13f55fc <__bss_end+0x13eb360>
    917c:	5a0e1bca 	bpl	3900ac <__bss_end+0x385e10>
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
    91b0:	3a83126f 	bcc	fe0cdb74 <__bss_end+0xfe0c38d8>
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
    9b18:	0000a038 	andeq	sl, r0, r8, lsr r0

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

00009e38 <_ZL9INT32_MAX>:
    9e38:	7fffffff 	svcvc	0x00ffffff

00009e3c <_ZL9INT32_MIN>:
    9e3c:	80000000 	andhi	r0, r0, r0

00009e40 <_ZL10UINT32_MAX>:
    9e40:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e44 <_ZL10UINT32_MIN>:
    9e44:	00000000 	andeq	r0, r0, r0

00009e48 <_ZL13Lock_Unlocked>:
    9e48:	00000000 	andeq	r0, r0, r0

00009e4c <_ZL11Lock_Locked>:
    9e4c:	00000001 	andeq	r0, r0, r1

00009e50 <_ZL21MaxFSDriverNameLength>:
    9e50:	00000010 	andeq	r0, r0, r0, lsl r0

00009e54 <_ZL17MaxFilenameLength>:
    9e54:	00000010 	andeq	r0, r0, r0, lsl r0

00009e58 <_ZL13MaxPathLength>:
    9e58:	00000080 	andeq	r0, r0, r0, lsl #1

00009e5c <_ZL18NoFilesystemDriver>:
    9e5c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e60 <_ZL9NotifyAll>:
    9e60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e64 <_ZL24Max_Process_Opened_Files>:
    9e64:	00000010 	andeq	r0, r0, r0, lsl r0

00009e68 <_ZL10Indefinite>:
    9e68:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e6c <_ZL18Deadline_Unchanged>:
    9e6c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009e70 <_ZL14Invalid_Handle>:
    9e70:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e74 <_ZN3halL18Default_Clock_RateE>:
    9e74:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009e78 <_ZN3halL15Peripheral_BaseE>:
    9e78:	20000000 	andcs	r0, r0, r0

00009e7c <_ZN3halL9GPIO_BaseE>:
    9e7c:	20200000 	eorcs	r0, r0, r0

00009e80 <_ZN3halL14GPIO_Pin_CountE>:
    9e80:	00000036 	andeq	r0, r0, r6, lsr r0

00009e84 <_ZN3halL8AUX_BaseE>:
    9e84:	20215000 	eorcs	r5, r1, r0

00009e88 <_ZN3halL25Interrupt_Controller_BaseE>:
    9e88:	2000b200 	andcs	fp, r0, r0, lsl #4

00009e8c <_ZN3halL10Timer_BaseE>:
    9e8c:	2000b400 	andcs	fp, r0, r0, lsl #8

00009e90 <_ZN3halL9TRNG_BaseE>:
    9e90:	20104000 	andscs	r4, r0, r0

00009e94 <_ZN3halL9BSC0_BaseE>:
    9e94:	20205000 	eorcs	r5, r0, r0

00009e98 <_ZN3halL9BSC1_BaseE>:
    9e98:	20804000 	addcs	r4, r0, r0

00009e9c <_ZN3halL9BSC2_BaseE>:
    9e9c:	20805000 	addcs	r5, r0, r0

00009ea0 <_ZL11Invalid_Pin>:
    9ea0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9ea4:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    9ea8:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9eac:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9eb0:	6f666572 	svcvs	0x00666572
    9eb4:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    9eb8:	2e6d6120 	powcsep	f6, f5, f0
    9ebc:	00000000 	andeq	r0, r0, r0
    9ec0:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    9ec4:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    9ec8:	70206461 	eorvc	r6, r0, r1, ror #8
    9ecc:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    9ed0:	00002e73 	andeq	r2, r0, r3, ror lr
    9ed4:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    9ed8:	20555043 	subscs	r5, r5, r3, asr #32
    9edc:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    9ee0:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    9ee4:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    9ee8:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    9eec:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    9ef0:	756f7661 	strbvc	r7, [pc, #-1633]!	; 9897 <_ZN13COLED_Display5ClearEb+0x4b>
    9ef4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    9ef8:	6f707320 	svcvs	0x00707320
    9efc:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    9f00:	52412073 	subpl	r2, r1, #115	; 0x73
    9f04:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    9f08:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    9f0c:	00676e69 	rsbeq	r6, r7, r9, ror #28
    9f10:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    9f14:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    9f18:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    9f1c:	61682064 	cmnvs	r8, r4, rrx
    9f20:	20612064 	rsbcs	r2, r1, r4, rrx
    9f24:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    9f28:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    9f2c:	00505247 	subseq	r5, r0, r7, asr #4
    9f30:	3a564544 	bcc	159b448 <__bss_end+0x15911ac>
    9f34:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    9f38:	00000000 	andeq	r0, r0, r0
    9f3c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    9f40:	534f5452 	movtpl	r5, #62546	; 0xf452
    9f44:	696e6920 	stmdbvs	lr!, {r5, r8, fp, sp, lr}^
    9f48:	2e2e2e74 	mcrcs	14, 1, r2, cr14, cr4, {3}
    9f4c:	00000000 	andeq	r0, r0, r0
    9f50:	3a564544 	bcc	159b468 <__bss_end+0x15911cc>
    9f54:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    9f58:	00000000 	andeq	r0, r0, r0

00009f5c <_ZL9INT32_MAX>:
    9f5c:	7fffffff 	svcvc	0x00ffffff

00009f60 <_ZL9INT32_MIN>:
    9f60:	80000000 	andhi	r0, r0, r0

00009f64 <_ZL10UINT32_MAX>:
    9f64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f68 <_ZL10UINT32_MIN>:
    9f68:	00000000 	andeq	r0, r0, r0

00009f6c <_ZL13Lock_Unlocked>:
    9f6c:	00000000 	andeq	r0, r0, r0

00009f70 <_ZL11Lock_Locked>:
    9f70:	00000001 	andeq	r0, r0, r1

00009f74 <_ZL21MaxFSDriverNameLength>:
    9f74:	00000010 	andeq	r0, r0, r0, lsl r0

00009f78 <_ZL17MaxFilenameLength>:
    9f78:	00000010 	andeq	r0, r0, r0, lsl r0

00009f7c <_ZL13MaxPathLength>:
    9f7c:	00000080 	andeq	r0, r0, r0, lsl #1

00009f80 <_ZL18NoFilesystemDriver>:
    9f80:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f84 <_ZL9NotifyAll>:
    9f84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f88 <_ZL24Max_Process_Opened_Files>:
    9f88:	00000010 	andeq	r0, r0, r0, lsl r0

00009f8c <_ZL10Indefinite>:
    9f8c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f90 <_ZL18Deadline_Unchanged>:
    9f90:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009f94 <_ZL14Invalid_Handle>:
    9f94:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009f98 <_ZL8INFINITY>:
    9f98:	7f7fffff 	svcvc	0x007fffff

00009f9c <_ZL16Pipe_File_Prefix>:
    9f9c:	3a535953 	bcc	14e04f0 <__bss_end+0x14d6254>
    9fa0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9fa4:	0000002f 	andeq	r0, r0, pc, lsr #32

00009fa8 <_ZL8INFINITY>:
    9fa8:	7f7fffff 	svcvc	0x007fffff

00009fac <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9fac:	33323130 	teqcc	r2, #48, 2
    9fb0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9fb4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9fb8:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9fbc:	00000000 	andeq	r0, r0, r0

00009fc0 <_ZL9INT32_MAX>:
    9fc0:	7fffffff 	svcvc	0x00ffffff

00009fc4 <_ZL9INT32_MIN>:
    9fc4:	80000000 	andhi	r0, r0, r0

00009fc8 <_ZL10UINT32_MAX>:
    9fc8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fcc <_ZL10UINT32_MIN>:
    9fcc:	00000000 	andeq	r0, r0, r0

00009fd0 <_ZL13Lock_Unlocked>:
    9fd0:	00000000 	andeq	r0, r0, r0

00009fd4 <_ZL11Lock_Locked>:
    9fd4:	00000001 	andeq	r0, r0, r1

00009fd8 <_ZL21MaxFSDriverNameLength>:
    9fd8:	00000010 	andeq	r0, r0, r0, lsl r0

00009fdc <_ZL17MaxFilenameLength>:
    9fdc:	00000010 	andeq	r0, r0, r0, lsl r0

00009fe0 <_ZL13MaxPathLength>:
    9fe0:	00000080 	andeq	r0, r0, r0, lsl #1

00009fe4 <_ZL18NoFilesystemDriver>:
    9fe4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fe8 <_ZL9NotifyAll>:
    9fe8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009fec <_ZL24Max_Process_Opened_Files>:
    9fec:	00000010 	andeq	r0, r0, r0, lsl r0

00009ff0 <_ZL10Indefinite>:
    9ff0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ff4 <_ZL18Deadline_Unchanged>:
    9ff4:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009ff8 <_ZL14Invalid_Handle>:
    9ff8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ffc <_ZL8INFINITY>:
    9ffc:	7f7fffff 	svcvc	0x007fffff

0000a000 <_ZN3halL18Default_Clock_RateE>:
    a000:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000a004 <_ZN3halL15Peripheral_BaseE>:
    a004:	20000000 	andcs	r0, r0, r0

0000a008 <_ZN3halL9GPIO_BaseE>:
    a008:	20200000 	eorcs	r0, r0, r0

0000a00c <_ZN3halL14GPIO_Pin_CountE>:
    a00c:	00000036 	andeq	r0, r0, r6, lsr r0

0000a010 <_ZN3halL8AUX_BaseE>:
    a010:	20215000 	eorcs	r5, r1, r0

0000a014 <_ZN3halL25Interrupt_Controller_BaseE>:
    a014:	2000b200 	andcs	fp, r0, r0, lsl #4

0000a018 <_ZN3halL10Timer_BaseE>:
    a018:	2000b400 	andcs	fp, r0, r0, lsl #8

0000a01c <_ZN3halL9TRNG_BaseE>:
    a01c:	20104000 	andscs	r4, r0, r0

0000a020 <_ZN3halL9BSC0_BaseE>:
    a020:	20205000 	eorcs	r5, r0, r0

0000a024 <_ZN3halL9BSC1_BaseE>:
    a024:	20804000 	addcs	r4, r0, r0

0000a028 <_ZN3halL9BSC2_BaseE>:
    a028:	20805000 	addcs	r5, r0, r0

0000a02c <_ZN9OLED_FontL10Char_WidthE>:
    a02c:	 	andeq	r0, r8, r6

0000a02e <_ZN9OLED_FontL11Char_HeightE>:
    a02e:	 	eoreq	r0, r0, r8

0000a030 <_ZN9OLED_FontL10Char_BeginE>:
    a030:	 	addeq	r0, r0, r0, lsr #32

0000a032 <_ZN9OLED_FontL8Char_EndE>:
    a032:	 	andeq	r0, r1, r0, lsl #1

0000a034 <_ZN9OLED_FontL10Flip_CharsE>:
    a034:	00000001 	andeq	r0, r0, r1

0000a038 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    a040:	00002f00 	andeq	r2, r0, r0, lsl #30
    a044:	00070000 	andeq	r0, r7, r0
    a048:	14000007 	strne	r0, [r0], #-7
    a04c:	147f147f 	ldrbtne	r1, [pc], #-1151	; a054 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    a050:	7f2a2400 	svcvc	0x002a2400
    a054:	2300122a 	movwcs	r1, #554	; 0x22a
    a058:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    a05c:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    a060:	00005022 	andeq	r5, r0, r2, lsr #32
    a064:	00000305 	andeq	r0, r0, r5, lsl #6
    a068:	221c0000 	andscs	r0, ip, #0
    a06c:	00000041 	andeq	r0, r0, r1, asr #32
    a070:	001c2241 	andseq	r2, ip, r1, asr #4
    a074:	3e081400 	cfcpyscc	mvf1, mvf8
    a078:	08001408 	stmdaeq	r0, {r3, sl, ip}
    a07c:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    a080:	a0000000 	andge	r0, r0, r0
    a084:	08000060 	stmdaeq	r0, {r5, r6}
    a088:	08080808 	stmdaeq	r8, {r3, fp}
    a08c:	60600000 	rsbvs	r0, r0, r0
    a090:	20000000 	andcs	r0, r0, r0
    a094:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    a098:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    a09c:	00003e45 	andeq	r3, r0, r5, asr #28
    a0a0:	00407f42 	subeq	r7, r0, r2, asr #30
    a0a4:	51614200 	cmnpl	r1, r0, lsl #4
    a0a8:	21004649 	tstcs	r0, r9, asr #12
    a0ac:	314b4541 	cmpcc	fp, r1, asr #10
    a0b0:	12141800 	andsne	r1, r4, #0, 16
    a0b4:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    a0b8:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    a0bc:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    a0c0:	01003049 	tsteq	r0, r9, asr #32
    a0c4:	03050971 	movweq	r0, #22897	; 0x5971
    a0c8:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    a0cc:	06003649 	streq	r3, [r0], -r9, asr #12
    a0d0:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    a0d4:	36360000 	ldrtcc	r0, [r6], -r0
    a0d8:	00000000 	andeq	r0, r0, r0
    a0dc:	00003656 	andeq	r3, r0, r6, asr r6
    a0e0:	22140800 	andscs	r0, r4, #0, 16
    a0e4:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    a0e8:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    a0ec:	22410000 	subcs	r0, r1, #0
    a0f0:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    a0f4:	06095101 	streq	r5, [r9], -r1, lsl #2
    a0f8:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    a0fc:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    a100:	7c121112 	ldfvcs	f1, [r2], {18}
    a104:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    a108:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    a10c:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    a110:	41417f00 	cmpmi	r1, r0, lsl #30
    a114:	7f001c22 	svcvc	0x00001c22
    a118:	41494949 	cmpmi	r9, r9, asr #18
    a11c:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a120:	3e000109 	adfccs	f0, f0, #1.0
    a124:	7a494941 	bvc	125c630 <__bss_end+0x1252394>
    a128:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    a12c:	00007f08 	andeq	r7, r0, r8, lsl #30
    a130:	00417f41 	subeq	r7, r1, r1, asr #30
    a134:	41402000 	mrsmi	r2, (UNDEF: 64)
    a138:	7f00013f 	svcvc	0x0000013f
    a13c:	41221408 			; <UNDEFINED> instruction: 0x41221408
    a140:	40407f00 	submi	r7, r0, r0, lsl #30
    a144:	7f004040 	svcvc	0x00004040
    a148:	7f020c02 	svcvc	0x00020c02
    a14c:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    a150:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    a154:	3e414141 	dvfccsm	f4, f1, f1
    a158:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    a15c:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    a160:	5e215141 	sufplsm	f5, f1, f1
    a164:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    a168:	46004629 	strmi	r4, [r0], -r9, lsr #12
    a16c:	31494949 	cmpcc	r9, r9, asr #18
    a170:	7f010100 	svcvc	0x00010100
    a174:	3f000101 	svccc	0x00000101
    a178:	3f404040 	svccc	0x00404040
    a17c:	40201f00 	eormi	r1, r0, r0, lsl #30
    a180:	3f001f20 	svccc	0x00001f20
    a184:	3f403840 	svccc	0x00403840
    a188:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    a18c:	07006314 	smladeq	r0, r4, r3, r6
    a190:	07087008 	streq	r7, [r8, -r8]
    a194:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    a198:	00004345 	andeq	r4, r0, r5, asr #6
    a19c:	0041417f 	subeq	r4, r1, pc, ror r1
    a1a0:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    a1a4:	0000552a 	andeq	r5, r0, sl, lsr #10
    a1a8:	007f4141 	rsbseq	r4, pc, r1, asr #2
    a1ac:	01020400 	tsteq	r2, r0, lsl #8
    a1b0:	40000402 	andmi	r0, r0, r2, lsl #8
    a1b4:	40404040 	submi	r4, r0, r0, asr #32
    a1b8:	02010000 	andeq	r0, r1, #0
    a1bc:	20000004 	andcs	r0, r0, r4
    a1c0:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    a1c4:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    a1c8:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    a1cc:	20444444 	subcs	r4, r4, r4, asr #8
    a1d0:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    a1d4:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    a1d8:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    a1dc:	097e0800 	ldmdbeq	lr!, {fp}^
    a1e0:	18000201 	stmdane	r0, {r0, r9}
    a1e4:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    a1e8:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    a1ec:	00007804 	andeq	r7, r0, r4, lsl #16
    a1f0:	00407d44 	subeq	r7, r0, r4, asr #26
    a1f4:	84804000 	strhi	r4, [r0], #0
    a1f8:	7f00007d 	svcvc	0x0000007d
    a1fc:	00442810 	subeq	r2, r4, r0, lsl r8
    a200:	7f410000 	svcvc	0x00410000
    a204:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    a208:	78041804 	stmdavc	r4, {r2, fp, ip}
    a20c:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a210:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    a214:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    a218:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    a21c:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    a220:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    a224:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    a228:	48000804 	stmdami	r0, {r2, fp}
    a22c:	20545454 	subscs	r5, r4, r4, asr r4
    a230:	443f0400 	ldrtmi	r0, [pc], #-1024	; a238 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    a234:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    a238:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    a23c:	40201c00 	eormi	r1, r0, r0, lsl #24
    a240:	3c001c20 	stccc	12, cr1, [r0], {32}
    a244:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    a248:	10284400 	eorne	r4, r8, r0, lsl #8
    a24c:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    a250:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    a254:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    a258:	0000444c 	andeq	r4, r0, ip, asr #8
    a25c:	00007708 	andeq	r7, r0, r8, lsl #14
    a260:	7f000000 	svcvc	0x00000000
    a264:	00000000 	andeq	r0, r0, r0
    a268:	00000877 	andeq	r0, r0, r7, ror r8
    a26c:	10081000 	andne	r1, r8, r0
    a270:	00000008 	andeq	r0, r0, r8
    a274:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

0000a278 <messages>:
__DTOR_END__():
    a278:	00009ea4 	andeq	r9, r0, r4, lsr #29
    a27c:	00009ec0 	andeq	r9, r0, r0, asr #29
    a280:	00009ed4 	ldrdeq	r9, [r0], -r4
    a284:	00009eec 	andeq	r9, r0, ip, ror #29
    a288:	00009f10 	andeq	r9, r0, r0, lsl pc

Disassembly of section .bss:

0000a28c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683590>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38188>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3bd9c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c6a88>
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
      80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcf3a0>
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
      fc:	fb010200 	blx	40906 <__bss_end+0x3666a>
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
     12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff5b33>
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
     164:	0a05830b 	beq	160d98 <__bss_end+0x156afc>
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
     190:	4a030402 	bmi	c11a0 <__bss_end+0xb6f04>
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
     1c4:	4a020402 	bmi	811d4 <__bss_end+0x76f38>
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
     1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcf518>
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
     248:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeeb <__bss_end+0xffff5c4f>
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
     294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff5c9b>
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
     310:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffe9 <__bss_end+0xffff5d4d>
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
     3d4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     3d8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     3dc:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     3e0:	00000300 	andeq	r0, r0, r0, lsl #6
     3e4:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     3e8:	00040068 	andeq	r0, r4, r8, rrx
     3ec:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     3f0:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     3f4:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     3f8:	66000004 	strvs	r0, [r0], -r4
     3fc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     400:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     404:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     408:	70000005 	andvc	r0, r0, r5
     40c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     410:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     414:	00000400 	andeq	r0, r0, r0, lsl #8
     418:	636f7270 	cmnvs	pc, #112, 4
     41c:	5f737365 	svcpl	0x00737365
     420:	616e616d 	cmnvs	lr, sp, ror #2
     424:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     428:	00040068 	andeq	r0, r4, r8, rrx
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
     46c:	0b05681b 	bleq	15a4e0 <__bss_end+0x150244>
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
     4b8:	fb010200 	blx	40cc2 <__bss_end+0x36a26>
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
     514:	6b2f7365 	blvs	bdd2b0 <__bss_end+0xbd3014>
     518:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     51c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     520:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     524:	6f622f65 	svcvs	0x00622f65
     528:	2f647261 	svccs	0x00647261
     52c:	30697072 	rsbcc	r7, r9, r2, ror r0
     530:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     534:	6f682f00 	svcvs	0x00682f00
     538:	6a2f656d 	bvs	bd9af4 <__bss_end+0xbcf858>
     53c:	73656d61 	cmnvc	r5, #6208	; 0x1840
     540:	2f697261 	svccs	0x00697261
     544:	2f746967 	svccs	0x00746967
     548:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     54c:	6f732f70 	svcvs	0x00732f70
     550:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     554:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     558:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     55c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     560:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     564:	6f72702f 	svcvs	0x0072702f
     568:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     56c:	6f682f00 	svcvs	0x00682f00
     570:	6a2f656d 	bvs	bd9b2c <__bss_end+0xbcf890>
     574:	73656d61 	cmnvc	r5, #6208	; 0x1840
     578:	2f697261 	svccs	0x00697261
     57c:	2f746967 	svccs	0x00746967
     580:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     584:	6f732f70 	svcvs	0x00732f70
     588:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     58c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     590:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     594:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     598:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     59c:	0073662f 	rsbseq	r6, r3, pc, lsr #12
     5a0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4ec <shift+0x4ec>
     5a4:	616a2f65 	cmnvs	sl, r5, ror #30
     5a8:	6173656d 	cmnvs	r3, sp, ror #10
     5ac:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     5b0:	6f2f7469 	svcvs	0x002f7469
     5b4:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     5b8:	756f732f 	strbvc	r7, [pc, #-815]!	; 291 <shift+0x291>
     5bc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     5c0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     5c4:	2f62696c 	svccs	0x0062696c
     5c8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     5cc:	00656475 	rsbeq	r6, r5, r5, ror r4
     5d0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     5d4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     5d8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     5dc:	00000100 	andeq	r0, r0, r0, lsl #2
     5e0:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     5e4:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     5e8:	00000200 	andeq	r0, r0, r0, lsl #4
     5ec:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     5f0:	00030068 	andeq	r0, r3, r8, rrx
     5f4:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     5f8:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     5fc:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     600:	66000003 	strvs	r0, [r0], -r3
     604:	73656c69 	cmnvc	r5, #26880	; 0x6900
     608:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     60c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     610:	70000004 	andvc	r0, r0, r4
     614:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     618:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     61c:	00000300 	andeq	r0, r0, r0, lsl #6
     620:	636f7270 	cmnvs	pc, #112, 4
     624:	5f737365 	svcpl	0x00737365
     628:	616e616d 	cmnvs	lr, sp, ror #2
     62c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     630:	00030068 	andeq	r0, r3, r8, rrx
     634:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     638:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     63c:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     640:	00000500 	andeq	r0, r0, r0, lsl #10
     644:	00010500 	andeq	r0, r1, r0, lsl #10
     648:	83380205 	teqhi	r8, #1342177280	; 0x50000000
     64c:	05160000 	ldreq	r0, [r6, #-0]
     650:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
     654:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     658:	852f0105 	strhi	r0, [pc, #-261]!	; 55b <shift+0x55b>
     65c:	05833205 	streq	r3, [r3, #517]	; 0x205
     660:	01054b1a 	tsteq	r5, sl, lsl fp
     664:	1a05852f 	bne	161b28 <__bss_end+0x15788c>
     668:	2f01054b 	svccs	0x0001054b
     66c:	a1320585 	teqge	r2, r5, lsl #11
     670:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     674:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
     678:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     67c:	852f0105 	strhi	r0, [pc, #-261]!	; 57f <shift+0x57f>
     680:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     684:	2e054b30 	vmovcs.16	d5[0], r4
     688:	4b1b054b 	blmi	6c1bbc <__bss_end+0x6b7920>
     68c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff88f <__bss_end+0xffff55f3>
     690:	01054c0c 	tsteq	r5, ip, lsl #24
     694:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     698:	4b3005bd 	blmi	c01d94 <__bss_end+0xbf7af8>
     69c:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     6a0:	2e054b1b 	vmovcs.32	d5[0], r4
     6a4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6a8:	852f0105 	strhi	r0, [pc, #-261]!	; 5ab <shift+0x5ab>
     6ac:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
     6b0:	01054b1b 	tsteq	r5, fp, lsl fp
     6b4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     6b8:	4b3305bd 	blmi	cc1db4 <__bss_end+0xcb7b18>
     6bc:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     6c0:	30054b1b 	andcc	r4, r5, fp, lsl fp
     6c4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6c8:	852f0105 	strhi	r0, [pc, #-261]!	; 5cb <shift+0x5cb>
     6cc:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
     6d0:	1b054b2f 	blne	153394 <__bss_end+0x1490f8>
     6d4:	2f2f054b 	svccs	0x002f054b
     6d8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     6dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     6e0:	2f05bd2e 	svccs	0x0005bd2e
     6e4:	4b3b054b 	blmi	ec1c18 <__bss_end+0xeb797c>
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
     710:	4b1a054b 	blmi	681c44 <__bss_end+0x6779a8>
     714:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     718:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     71c:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
     720:	4b31054d 	blmi	c41c5c <__bss_end+0xc379c0>
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
     790:	6a2f656d 	bvs	bd9d4c <__bss_end+0xbcfab0>
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
     7bc:	6a2f656d 	bvs	bd9d78 <__bss_end+0xbcfadc>
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
     814:	bb06051a 	bllt	181c84 <__bss_end+0x1779e8>
     818:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     81c:	0a056821 	beq	15a8a8 <__bss_end+0x15060c>
     820:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
     824:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
     828:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
     82c:	9f04052f 	svcls	0x0004052f
     830:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
     834:	10053505 	andne	r3, r5, r5, lsl #10
     838:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
     83c:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
     840:	0a052e13 	beq	14c094 <__bss_end+0x141df8>
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
     87c:	1b054b02 	blne	15348c <__bss_end+0x1491f0>
     880:	02040200 	andeq	r0, r4, #0, 4
     884:	000c052e 	andeq	r0, ip, lr, lsr #10
     888:	4a020402 	bmi	81898 <__bss_end+0x775fc>
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
     8c8:	0a054a10 	beq	153110 <__bss_end+0x148e74>
     8cc:	bb07054c 	bllt	1c1e04 <__bss_end+0x1b7b68>
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
     96c:	0b054901 	bleq	152d78 <__bss_end+0x148adc>
     970:	2f010585 	svccs	0x00010585
     974:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
     978:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
     97c:	0b05bc20 	bleq	16fa04 <__bss_end+0x165768>
     980:	4b1f0566 	blmi	7c1f20 <__bss_end+0x7b7c84>
     984:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
     988:	11054b08 	tstne	r5, r8, lsl #22
     98c:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
     990:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
     994:	0b056711 	bleq	15a5e0 <__bss_end+0x150344>
     998:	2f01054d 	svccs	0x0001054d
     99c:	83060585 	movwhi	r0, #25989	; 0x6585
     9a0:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     9a4:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
     9a8:	4b040566 	blmi	101f48 <__bss_end+0xf7cac>
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
     9d4:	4a020402 	bmi	819e4 <__bss_end+0x77748>
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
     a04:	4a020402 	bmi	81a14 <__bss_end+0x77778>
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
     af4:	1a059f09 	bne	168720 <__bss_end+0x15e484>
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
     b64:	1a059f09 	bne	168790 <__bss_end+0x15e4f4>
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
     ba0:	0b054a19 	bleq	15340c <__bss_end+0x149170>
     ba4:	670f0582 	strvs	r0, [pc, -r2, lsl #11]
     ba8:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
     bac:	12054b19 	andne	r4, r5, #25600	; 0x6400
     bb0:	4a11054a 	bmi	4420e0 <__bss_end+0x437e44>
     bb4:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     bb8:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
     bbc:	76030905 	strvc	r0, [r3], -r5, lsl #18
     bc0:	4a10052e 	bmi	402080 <__bss_end+0x3f7de4>
     bc4:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     bc8:	15054a09 	strne	r4, [r5, #-2569]	; 0xfffff5f7
     bcc:	670d0567 	strvs	r0, [sp, -r7, ror #10]
     bd0:	054a1505 	strbeq	r1, [sl, #-1285]	; 0xfffffafb
     bd4:	0d056710 	stceq	7, cr6, [r5, #-64]	; 0xffffffc0
     bd8:	4b1a054a 	blmi	682108 <__bss_end+0x677e6c>
     bdc:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
     be0:	01054a19 	tsteq	r5, r9, lsl sl
     be4:	152e026a 	strne	r0, [lr, #-618]!	; 0xfffffd96
     be8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
     bec:	15054b12 	strne	r4, [r5, #-2834]	; 0xfffff4ee
     bf0:	bb200566 	bllt	802190 <__bss_end+0x7f7ef4>
     bf4:	20082305 	andcs	r2, r8, r5, lsl #6
     bf8:	052e1205 	streq	r1, [lr, #-517]!	; 0xfffffdfb
     bfc:	23058214 	movwcs	r8, #21012	; 0x5214
     c00:	4a16054a 	bmi	582130 <__bss_end+0x577e94>
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
     c4c:	4a100566 	bmi	4021ec <__bss_end+0x3f7f50>
     c50:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     c54:	1005660e 	andne	r6, r5, lr, lsl #12
     c58:	4b0c054a 	blmi	302188 <__bss_end+0x2f7eec>
     c5c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     c60:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     c64:	660e054b 	strvs	r0, [lr], -fp, asr #10
     c68:	054a1005 	strbeq	r1, [sl, #-5]
     c6c:	0d054b03 	vstreq	d4, [r5, #-12]
     c70:	66050530 			; <UNDEFINED> instruction: 0x66050530
     c74:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     c78:	1005660e 	andne	r6, r5, lr, lsl #12
     c7c:	4b0c054a 	blmi	3021ac <__bss_end+0x2f7f10>
     c80:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     c84:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     c88:	660e054b 	strvs	r0, [lr], -fp, asr #10
     c8c:	054a1005 	strbeq	r1, [sl, #-5]
     c90:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     c94:	4a100566 	bmi	402234 <__bss_end+0x3f7f98>
     c98:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
     c9c:	02053006 	andeq	r3, r5, #6
     ca0:	670d054b 	strvs	r0, [sp, -fp, asr #10]
     ca4:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
     ca8:	07059f0e 	streq	r9, [r5, -lr, lsl #30]
     cac:	68180566 	ldmdavs	r8, {r1, r2, r5, r6, r8, sl}
     cb0:	05833405 	streq	r3, [r3, #1029]	; 0x405
     cb4:	44056633 	strmi	r6, [r5], #-1587	; 0xfffff9cd
     cb8:	4a18054a 	bmi	6021e8 <__bss_end+0x5f7f4c>
     cbc:	05690605 	strbeq	r0, [r9, #-1541]!	; 0xfffff9fb
     cc0:	0b059f1d 	bleq	16893c <__bss_end+0x15e6a0>
     cc4:	00140584 	andseq	r0, r4, r4, lsl #11
     cc8:	4a030402 	bmi	c1cd8 <__bss_end+0xb7a3c>
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
     d30:	0b058505 	bleq	16214c <__bss_end+0x157eb0>
     d34:	02040200 	andeq	r0, r4, #0, 4
     d38:	000d0532 	andeq	r0, sp, r2, lsr r5
     d3c:	66020402 	strvs	r0, [r2], -r2, lsl #8
     d40:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     d44:	05830905 	streq	r0, [r3, #2309]	; 0x905
     d48:	07054a12 	smladeq	r5, r2, sl, r4
     d4c:	4a03054b 	bmi	c2280 <__bss_end+0xb7fe4>
     d50:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     d54:	0c05670a 	stceq	7, cr6, [r5], {10}
     d58:	001c054c 	andseq	r0, ip, ip, asr #10
     d5c:	4a010402 	bmi	41d6c <__bss_end+0x37ad0>
     d60:	02001d05 	andeq	r1, r0, #320	; 0x140
     d64:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     d68:	05054b09 	streq	r4, [r5, #-2825]	; 0xfffff4f7
     d6c:	0012054a 	andseq	r0, r2, sl, asr #10
     d70:	4b010402 	blmi	41d80 <__bss_end+0x37ae4>
     d74:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     d78:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     d7c:	0905300d 	stmdbeq	r5, {r0, r2, r3, ip, sp}
     d80:	4b05054a 	blmi	1422b0 <__bss_end+0x138014>
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
     e00:	6a2f656d 	bvs	bda3bc <__bss_end+0xbd0120>
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
     e8c:	6b2f7365 	blvs	bddc28 <__bss_end+0xbd398c>
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
     ec4:	6b2f7365 	blvs	bddc60 <__bss_end+0xbd39c4>
     ec8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     ecc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     ed0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     ed4:	73662f65 	cmnvc	r6, #404	; 0x194
     ed8:	6f682f00 	svcvs	0x00682f00
     edc:	6a2f656d 	bvs	bda498 <__bss_end+0xbd01fc>
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
     f0c:	6a2f656d 	bvs	bda4c8 <__bss_end+0xbd022c>
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
    101c:	4a050585 	bmi	142638 <__bss_end+0x13839c>
    1020:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
    1024:	0105670e 	tsteq	r5, lr, lsl #14
    1028:	0c058584 	cfstr32eq	mvfx8, [r5], {132}	; 0x84
    102c:	4b010583 	blmi	42640 <__bss_end+0x383a4>
    1030:	bb0a0585 	bllt	28264c <__bss_end+0x2783b0>
    1034:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1038:	11054a05 	tstne	r5, r5, lsl #20
    103c:	4b0f054e 	blmi	3c257c <__bss_end+0x3b82e0>
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
    1084:	0a052e04 	beq	14c89c <__bss_end+0x142600>
    1088:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
    108c:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    1090:	05d67703 	ldrbeq	r7, [r6, #1795]	; 0x703
    1094:	2e0a0301 	cdpcs	3, 0, cr0, cr10, cr1, {0}
    1098:	080a054d 	stmdaeq	sl, {r0, r2, r3, r6, r8, sl}
    109c:	4a090591 	bmi	2426e8 <__bss_end+0x23844c>
    10a0:	4e4a0505 	cdpmi	5, 4, cr0, cr10, cr5, {0}
    10a4:	02002805 	andeq	r2, r0, #327680	; 0x50000
    10a8:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    10ac:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
    10b0:	1e052e01 	cdpne	14, 0, cr2, cr5, cr1, {0}
    10b4:	4b15054f 	blmi	5425f8 <__bss_end+0x53835c>
    10b8:	bb670c05 	bllt	19c40d4 <__bss_end+0x19b9e38>
    10bc:	08bb0d05 	ldmeq	fp!, {r0, r2, r8, sl, fp}
    10c0:	08100521 	ldmdaeq	r0, {r0, r5, r8, sl}
    10c4:	68440521 	stmdavs	r4, {r0, r5, r8, sl}^
    10c8:	052e5105 	streq	r5, [lr, #-261]!	; 0xfffffefb
    10cc:	0c052e40 	stceq	14, cr2, [r5], {64}	; 0x40
    10d0:	4a6c059e 	bmi	1b02750 <__bss_end+0x1af84b4>
    10d4:	054a0b05 	strbeq	r0, [sl, #-2821]	; 0xfffff4fb
    10d8:	0905680a 	stmdbeq	r5, {r1, r3, fp, sp, lr}
    10dc:	4ed66e03 	cdpmi	14, 13, cr6, cr6, cr3, {0}
    10e0:	0f030105 	svceq	0x00030105
    10e4:	0a05692e 	beq	15b5a4 <__bss_end+0x151308>
    10e8:	4a090583 	bmi	2426fc <__bss_end+0x238460>
    10ec:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    10f0:	0a054e14 	beq	154948 <__bss_end+0x14a6ac>
    10f4:	d109054c 	tstle	r9, ip, asr #10
    10f8:	4d340105 	ldfmis	f0, [r4, #-20]!	; 0xffffffec
    10fc:	21080a05 	tstcs	r8, r5, lsl #20
    1100:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
    1104:	0e054a05 	vmlaeq.f32	s8, s10, s10
    1108:	4b11054d 	blmi	442644 <__bss_end+0x4383a8>
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
    1140:	fb010200 	blx	4194a <__bss_end+0x376ae>
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
    118c:	ca030000 	bgt	c1194 <__bss_end+0xb6ef8>
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
      58:	07a20704 	streq	r0, [r2, r4, lsl #14]!
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
     128:	000007a2 	andeq	r0, r0, r2, lsr #15
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
     174:	cb104801 	blgt	412180 <__bss_end+0x407ee4>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x35ef8>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x479bbc>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x35fc8>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f61f0>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000fdb 	ldrdeq	r0, [r0], -fp
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000c6b04 	andeq	r6, ip, r4, lsl #22
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00010c00 	andeq	r0, r1, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	132e0200 			; <UNDEFINED> instruction: 0x132e0200
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
     308:	0300009e 	movweq	r0, #158	; 0x9e
     30c:	1eee0404 	cdpne	4, 14, cr0, cr14, cr4, {0}
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	10e60801 	rscne	r0, r6, r1, lsl #16
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0e590502 	cdpeq	5, 5, cr0, cr9, cr2, {0}
     328:	10050000 	andne	r0, r5, r0
     32c:	02000007 	andeq	r0, r0, #7
     330:	00670705 	rsbeq	r0, r7, r5, lsl #14
     334:	56040000 	strpl	r0, [r4], -r0
     338:	06000000 	streq	r0, [r0], -r0
     33c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     340:	08030074 	stmdaeq	r3, {r2, r4, r5, r6}
     344:	00031f05 	andeq	r1, r3, r5, lsl #30
     348:	08010300 	stmdaeq	r1, {r8, r9}
     34c:	000010dd 	ldrdeq	r1, [r0], -sp
     350:	000da205 	andeq	sl, sp, r5, lsl #4
     354:	07090200 	streq	r0, [r9, -r0, lsl #4]
     358:	00000088 	andeq	r0, r0, r8, lsl #1
     35c:	98070203 	stmdals	r7, {r0, r1, r9}
     360:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     364:	0000070f 	andeq	r0, r0, pc, lsl #14
     368:	a0070a02 	andge	r0, r7, r2, lsl #20
     36c:	04000000 	streq	r0, [r0], #-0
     370:	0000008f 	andeq	r0, r0, pc, lsl #1
     374:	a2070403 	andge	r0, r7, #50331648	; 0x3000000
     378:	04000007 	streq	r0, [r0], #-7
     37c:	000000a0 	andeq	r0, r0, r0, lsr #1
     380:	0000a007 	andeq	sl, r0, r7
     384:	07080300 	streq	r0, [r8, -r0, lsl #6]
     388:	00000798 	muleq	r0, r8, r7
     38c:	000ef902 	andeq	pc, lr, r2, lsl #18
     390:	130d0200 	movwne	r0, #53760	; 0xd200
     394:	00000062 	andeq	r0, r0, r2, rrx
     398:	9e380305 	cdpls	3, 3, cr0, cr8, cr5, {0}
     39c:	bd020000 	stclt	0, cr0, [r2, #-0]
     3a0:	02000007 	andeq	r0, r0, #7
     3a4:	0062130e 	rsbeq	r1, r2, lr, lsl #6
     3a8:	03050000 	movweq	r0, #20480	; 0x5000
     3ac:	00009e3c 	andeq	r9, r0, ip, lsr lr
     3b0:	000ef802 	andeq	pc, lr, r2, lsl #16
     3b4:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     3b8:	0000009b 	muleq	r0, fp, r0
     3bc:	9e400305 	cdpls	3, 4, cr0, cr0, cr5, {0}
     3c0:	bc020000 	stclt	0, cr0, [r2], {-0}
     3c4:	02000007 	andeq	r0, r0, #7
     3c8:	009b1411 	addseq	r1, fp, r1, lsl r4
     3cc:	03050000 	movweq	r0, #20480	; 0x5000
     3d0:	00009e44 	andeq	r9, r0, r4, asr #28
     3d4:	00139808 	andseq	r9, r3, r8, lsl #16
     3d8:	06040800 	streq	r0, [r4], -r0, lsl #16
     3dc:	00012608 	andeq	r2, r1, r8, lsl #12
     3e0:	30720900 	rsbscc	r0, r2, r0, lsl #18
     3e4:	0e080400 	cfcpyseq	mvf0, mvf8
     3e8:	0000008f 	andeq	r0, r0, pc, lsl #1
     3ec:	31720900 	cmncc	r2, r0, lsl #18
     3f0:	0e090400 	cfcpyseq	mvf0, mvf9
     3f4:	0000008f 	andeq	r0, r0, pc, lsl #1
     3f8:	1b0a0004 	blne	280410 <__bss_end+0x276174>
     3fc:	0500000f 	streq	r0, [r0, #-15]
     400:	00006704 	andeq	r6, r0, r4, lsl #14
     404:	0c1e0400 	cfldrseq	mvf0, [lr], {-0}
     408:	0000015d 	andeq	r0, r0, sp, asr r1
     40c:	0007070b 	andeq	r0, r7, fp, lsl #14
     410:	6b0b0000 	blvs	2c0418 <__bss_end+0x2b617c>
     414:	01000009 	tsteq	r0, r9
     418:	000f3d0b 	andeq	r3, pc, fp, lsl #26
     41c:	f90b0200 			; <UNDEFINED> instruction: 0xf90b0200
     420:	03000010 	movweq	r0, #16
     424:	00094e0b 	andeq	r4, r9, fp, lsl #28
     428:	490b0400 	stmdbmi	fp, {sl}
     42c:	0500000e 	streq	r0, [r0, #-14]
     430:	0f030a00 	svceq	0x00030a00
     434:	04050000 	streq	r0, [r5], #-0
     438:	00000067 	andeq	r0, r0, r7, rrx
     43c:	9a0c4404 	bls	311454 <__bss_end+0x3071b8>
     440:	0b000001 	bleq	44c <shift+0x44c>
     444:	00000892 	muleq	r0, r2, r8
     448:	10370b00 	eorsne	r0, r7, r0, lsl #22
     44c:	0b010000 	bleq	40454 <__bss_end+0x361b8>
     450:	00001328 	andeq	r1, r0, r8, lsr #6
     454:	0d200b02 	vstmdbeq	r0!, {d0}
     458:	0b030000 	bleq	c0460 <__bss_end+0xb61c4>
     45c:	0000095d 	andeq	r0, r0, sp, asr r9
     460:	0a830b04 	beq	fe0c3078 <__bss_end+0xfe0b8ddc>
     464:	0b050000 	bleq	14046c <__bss_end+0x1361d0>
     468:	00000787 	andeq	r0, r0, r7, lsl #15
     46c:	10050006 	andne	r0, r5, r6
     470:	0500000e 	streq	r0, [r0, #-14]
     474:	00670703 	rsbeq	r0, r7, r3, lsl #14
     478:	53020000 	movwpl	r0, #8192	; 0x2000
     47c:	0500000c 	streq	r0, [r0, #-12]
     480:	009b1405 	addseq	r1, fp, r5, lsl #8
     484:	03050000 	movweq	r0, #20480	; 0x5000
     488:	00009e48 	andeq	r9, r0, r8, asr #28
     48c:	00103c02 	andseq	r3, r0, r2, lsl #24
     490:	14060500 	strne	r0, [r6], #-1280	; 0xfffffb00
     494:	0000009b 	muleq	r0, fp, r0
     498:	9e4c0305 	cdpls	3, 4, cr0, cr12, cr5, {0}
     49c:	ee020000 	cdp	0, 0, cr0, cr2, cr0, {0}
     4a0:	0600000a 	streq	r0, [r0], -sl
     4a4:	009b1a07 	addseq	r1, fp, r7, lsl #20
     4a8:	03050000 	movweq	r0, #20480	; 0x5000
     4ac:	00009e50 	andeq	r9, r0, r0, asr lr
     4b0:	000e7202 	andeq	r7, lr, r2, lsl #4
     4b4:	1a090600 	bne	241cbc <__bss_end+0x237a20>
     4b8:	0000009b 	muleq	r0, fp, r0
     4bc:	9e540305 	cdpls	3, 5, cr0, cr4, cr5, {0}
     4c0:	b1020000 	mrslt	r0, (UNDEF: 2)
     4c4:	0600000a 	streq	r0, [r0], -sl
     4c8:	009b1a0b 	addseq	r1, fp, fp, lsl #20
     4cc:	03050000 	movweq	r0, #20480	; 0x5000
     4d0:	00009e58 	andeq	r9, r0, r8, asr lr
     4d4:	000dfd02 	andeq	pc, sp, r2, lsl #26
     4d8:	1a0d0600 	bne	341ce0 <__bss_end+0x337a44>
     4dc:	0000009b 	muleq	r0, fp, r0
     4e0:	9e5c0305 	cdpls	3, 5, cr0, cr12, cr5, {0}
     4e4:	c2020000 	andgt	r0, r2, #0
     4e8:	06000006 	streq	r0, [r0], -r6
     4ec:	009b1a0f 	addseq	r1, fp, pc, lsl #20
     4f0:	03050000 	movweq	r0, #20480	; 0x5000
     4f4:	00009e60 	andeq	r9, r0, r0, ror #28
     4f8:	000d060a 	andeq	r0, sp, sl, lsl #12
     4fc:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     500:	06000000 	streq	r0, [r0], -r0
     504:	02490c1b 	subeq	r0, r9, #6912	; 0x1b00
     508:	4e0b0000 	cdpmi	0, 0, cr0, cr11, cr0, {0}
     50c:	00000006 	andeq	r0, r0, r6
     510:	0011650b 	andseq	r6, r1, fp, lsl #10
     514:	230b0100 	movwcs	r0, #45312	; 0xb100
     518:	02000013 	andeq	r0, r0, #19
     51c:	04190c00 	ldreq	r0, [r9], #-3072	; 0xfffff400
     520:	e10d0000 	mrs	r0, (UNDEF: 13)
     524:	90000004 	andls	r0, r0, r4
     528:	bc076306 	stclt	3, cr6, [r7], {6}
     52c:	08000003 	stmdaeq	r0, {r0, r1}
     530:	0000062a 	andeq	r0, r0, sl, lsr #12
     534:	10670624 	rsbne	r0, r7, r4, lsr #12
     538:	000002d6 	ldrdeq	r0, [r0], -r6
     53c:	00247d0e 	eoreq	r7, r4, lr, lsl #26
     540:	12690600 	rsbne	r0, r9, #0, 12
     544:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     548:	08970e00 	ldmeq	r7, {r9, sl, fp}
     54c:	6b060000 	blvs	180554 <__bss_end+0x1762b8>
     550:	0003cc12 	andeq	ip, r3, r2, lsl ip
     554:	430e1000 	movwmi	r1, #57344	; 0xe000
     558:	06000006 	streq	r0, [r0], -r6
     55c:	008f166d 	addeq	r1, pc, sp, ror #12
     560:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     564:	00000e52 	andeq	r0, r0, r2, asr lr
     568:	d31c7006 	tstle	ip, #6
     56c:	18000003 	stmdane	r0, {r0, r1}
     570:	0012e00e 	andseq	lr, r2, lr
     574:	1c720600 	ldclne	6, cr0, [r2], #-0
     578:	000003d3 	ldrdeq	r0, [r0], -r3
     57c:	04dc0e1c 	ldrbeq	r0, [ip], #3612	; 0xe1c
     580:	75060000 	strvc	r0, [r6, #-0]
     584:	0003d31c 	andeq	sp, r3, ip, lsl r3
     588:	e70f2000 	str	r2, [pc, -r0]
     58c:	0600000e 	streq	r0, [r0], -lr
     590:	12231c77 	eorne	r1, r3, #30464	; 0x7700
     594:	03d30000 	bicseq	r0, r3, #0
     598:	02ca0000 	sbceq	r0, sl, #0
     59c:	d3100000 	tstle	r0, #0
     5a0:	11000003 	tstne	r0, r3
     5a4:	000003d9 	ldrdeq	r0, [r0], -r9
     5a8:	18080000 	stmdane	r8, {}	; <UNPREDICTABLE>
     5ac:	18000013 	stmdane	r0, {r0, r1, r4}
     5b0:	0b107b06 	bleq	41f1d0 <__bss_end+0x414f34>
     5b4:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
     5b8:	0000247d 	andeq	r2, r0, sp, ror r4
     5bc:	bc127e06 	ldclt	14, cr7, [r2], {6}
     5c0:	00000003 	andeq	r0, r0, r3
     5c4:	0005360e 	andeq	r3, r5, lr, lsl #12
     5c8:	19800600 	stmibne	r0, {r9, sl}
     5cc:	000003d9 	ldrdeq	r0, [r0], -r9
     5d0:	0a8a0e10 	beq	fe283e18 <__bss_end+0xfe279b7c>
     5d4:	82060000 	andhi	r0, r6, #0
     5d8:	0003e421 	andeq	lr, r3, r1, lsr #8
     5dc:	04001400 	streq	r1, [r0], #-1024	; 0xfffffc00
     5e0:	000002d6 	ldrdeq	r0, [r0], -r6
     5e4:	00048f12 	andeq	r8, r4, r2, lsl pc
     5e8:	21860600 	orrcs	r0, r6, r0, lsl #12
     5ec:	000003ea 	andeq	r0, r0, sl, ror #7
     5f0:	0008c112 	andeq	ip, r8, r2, lsl r1
     5f4:	1f880600 	svcne	0x00880600
     5f8:	0000009b 	muleq	r0, fp, r0
     5fc:	000e840e 	andeq	r8, lr, lr, lsl #8
     600:	178b0600 	strne	r0, [fp, r0, lsl #12]
     604:	0000025b 	andeq	r0, r0, fp, asr r2
     608:	07f90e00 	ldrbeq	r0, [r9, r0, lsl #28]!
     60c:	8e060000 	cdphi	0, 0, cr0, cr6, cr0, {0}
     610:	00025b17 	andeq	r5, r2, r7, lsl fp
     614:	d70e2400 	strle	r2, [lr, -r0, lsl #8]
     618:	0600000b 	streq	r0, [r0], -fp
     61c:	025b178f 	subseq	r1, fp, #37486592	; 0x23c0000
     620:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     624:	000009e5 	andeq	r0, r0, r5, ror #19
     628:	5b179006 	blpl	5e4648 <__bss_end+0x5da3ac>
     62c:	6c000002 	stcvs	0, cr0, [r0], {2}
     630:	0004e113 	andeq	lr, r4, r3, lsl r1
     634:	09930600 	ldmibeq	r3, {r9, sl}
     638:	00000dc0 	andeq	r0, r0, r0, asr #27
     63c:	000003f5 	strdeq	r0, [r0], -r5
     640:	00037501 	andeq	r7, r3, r1, lsl #10
     644:	00037b00 	andeq	r7, r3, r0, lsl #22
     648:	03f51000 	mvnseq	r1, #0
     64c:	14000000 	strne	r0, [r0], #-0
     650:	00000edc 	ldrdeq	r0, [r0], -ip
     654:	170e9606 	strne	r9, [lr, -r6, lsl #12]
     658:	01000005 	tsteq	r0, r5
     65c:	00000390 	muleq	r0, r0, r3
     660:	00000396 	muleq	r0, r6, r3
     664:	0003f510 	andeq	pc, r3, r0, lsl r5	; <UNPREDICTABLE>
     668:	92150000 	andsls	r0, r5, #0
     66c:	06000008 	streq	r0, [r0], -r8
     670:	0ceb1099 	stcleq	0, cr1, [fp], #612	; 0x264
     674:	03fb0000 	mvnseq	r0, #0
     678:	ab010000 	blge	40680 <__bss_end+0x363e4>
     67c:	10000003 	andne	r0, r0, r3
     680:	000003f5 	strdeq	r0, [r0], -r5
     684:	0003d911 	andeq	sp, r3, r1, lsl r9
     688:	02241100 	eoreq	r1, r4, #0, 2
     68c:	00000000 	andeq	r0, r0, r0
     690:	00004316 	andeq	r4, r0, r6, lsl r3
     694:	0003cc00 	andeq	ip, r3, r0, lsl #24
     698:	00a01700 	adceq	r1, r0, r0, lsl #14
     69c:	000f0000 	andeq	r0, pc, r0
     6a0:	72020103 	andvc	r0, r2, #-1073741824	; 0xc0000000
     6a4:	1800000b 	stmdane	r0, {r0, r1, r3}
     6a8:	00025b04 	andeq	r5, r2, r4, lsl #22
     6ac:	4a041800 	bmi	1066b4 <__bss_end+0xfc418>
     6b0:	0c000000 	stceq	0, cr0, [r0], {-0}
     6b4:	000011f8 	strdeq	r1, [r0], -r8
     6b8:	03df0418 	bicseq	r0, pc, #24, 8	; 0x18000000
     6bc:	0b160000 	bleq	5806c4 <__bss_end+0x576428>
     6c0:	f5000003 			; <UNDEFINED> instruction: 0xf5000003
     6c4:	19000003 	stmdbne	r0, {r0, r1}
     6c8:	4e041800 	cdpmi	8, 0, cr1, cr4, cr0, {0}
     6cc:	18000002 	stmdane	r0, {r1}
     6d0:	00024904 	andeq	r4, r2, r4, lsl #18
     6d4:	0ed01a00 	vfnmseq.f32	s3, s0, s0
     6d8:	9c060000 	stcls	0, cr0, [r6], {-0}
     6dc:	00024e14 	andeq	r4, r2, r4, lsl lr
     6e0:	06580200 	ldrbeq	r0, [r8], -r0, lsl #4
     6e4:	04070000 	streq	r0, [r7], #-0
     6e8:	00009b14 	andeq	r9, r0, r4, lsl fp
     6ec:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     6f0:	0200009e 	andeq	r0, r0, #158	; 0x9e
     6f4:	00000f43 	andeq	r0, r0, r3, asr #30
     6f8:	9b140707 	blls	50231c <__bss_end+0x4f8080>
     6fc:	05000000 	streq	r0, [r0, #-0]
     700:	009e6803 	addseq	r6, lr, r3, lsl #16
     704:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     708:	0a070000 	beq	1c0710 <__bss_end+0x1b6474>
     70c:	00009b14 	andeq	r9, r0, r4, lsl fp
     710:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     714:	0a00009e 	beq	994 <shift+0x994>
     718:	0000078c 	andeq	r0, r0, ip, lsl #15
     71c:	00670405 	rsbeq	r0, r7, r5, lsl #8
     720:	0d070000 	stceq	0, cr0, [r7, #-0]
     724:	00047a0c 	andeq	r7, r4, ip, lsl #20
     728:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     72c:	0b000077 	bleq	910 <shift+0x910>
     730:	00000975 	andeq	r0, r0, r5, ror r9
     734:	04fc0b01 	ldrbteq	r0, [ip], #2817	; 0xb01
     738:	0b020000 	bleq	80740 <__bss_end+0x764a4>
     73c:	000007c7 	andeq	r0, r0, r7, asr #15
     740:	10eb0b03 	rscne	r0, fp, r3, lsl #22
     744:	0b040000 	bleq	10074c <__bss_end+0xf64b0>
     748:	000004d5 	ldrdeq	r0, [r0], -r5
     74c:	71080005 	tstvc	r8, r5
     750:	10000006 	andne	r0, r0, r6
     754:	b9081b07 	stmdblt	r8, {r0, r1, r2, r8, r9, fp, ip}
     758:	09000004 	stmdbeq	r0, {r2}
     75c:	0700726c 	streq	r7, [r0, -ip, ror #4]
     760:	04b9131d 	ldrteq	r1, [r9], #797	; 0x31d
     764:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     768:	07007073 	smlsdxeq	r0, r3, r0, r7
     76c:	04b9131e 	ldrteq	r1, [r9], #798	; 0x31e
     770:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     774:	07006370 	smlsdxeq	r0, r0, r3, r6
     778:	04b9131f 	ldrteq	r1, [r9], #799	; 0x31f
     77c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     780:	00000ef2 	strdeq	r0, [r0], -r2
     784:	b9132007 	ldmdblt	r3, {r0, r1, r2, sp}
     788:	0c000004 	stceq	0, cr0, [r0], {4}
     78c:	07040300 	streq	r0, [r4, -r0, lsl #6]
     790:	0000079d 	muleq	r0, sp, r7
     794:	0004b904 	andeq	fp, r4, r4, lsl #18
     798:	09410800 	stmdbeq	r1, {fp}^
     79c:	07700000 	ldrbeq	r0, [r0, -r0]!
     7a0:	05550828 	ldrbeq	r0, [r5, #-2088]	; 0xfffff7d8
     7a4:	410e0000 	mrsmi	r0, (UNDEF: 14)
     7a8:	07000008 	streq	r0, [r0, -r8]
     7ac:	047a122a 	ldrbteq	r1, [sl], #-554	; 0xfffffdd6
     7b0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     7b4:	00646970 	rsbeq	r6, r4, r0, ror r9
     7b8:	a0122b07 	andsge	r2, r2, r7, lsl #22
     7bc:	10000000 	andne	r0, r0, r0
     7c0:	001e700e 	andseq	r7, lr, lr
     7c4:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
     7c8:	00000443 	andeq	r0, r0, r3, asr #8
     7cc:	10cf0e14 	sbcne	r0, pc, r4, lsl lr	; <UNPREDICTABLE>
     7d0:	2d070000 	stccs	0, cr0, [r7, #-0]
     7d4:	0000a012 	andeq	sl, r0, r2, lsl r0
     7d8:	a90e1800 	stmdbge	lr, {fp, ip}
     7dc:	07000003 	streq	r0, [r0, -r3]
     7e0:	00a0122e 	adceq	r1, r0, lr, lsr #4
     7e4:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     7e8:	00000f30 	andeq	r0, r0, r0, lsr pc
     7ec:	550c2f07 	strpl	r2, [ip, #-3847]	; 0xfffff0f9
     7f0:	20000005 	andcs	r0, r0, r5
     7f4:	0004850e 	andeq	r8, r4, lr, lsl #10
     7f8:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
     7fc:	00000067 	andeq	r0, r0, r7, rrx
     800:	0b310e60 	bleq	c44188 <__bss_end+0xc39eec>
     804:	31070000 	mrscc	r0, (UNDEF: 7)
     808:	00008f0e 	andeq	r8, r0, lr, lsl #30
     80c:	940e6400 	strls	r6, [lr], #-1024	; 0xfffffc00
     810:	0700000d 	streq	r0, [r0, -sp]
     814:	008f0e33 	addeq	r0, pc, r3, lsr lr	; <UNPREDICTABLE>
     818:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     81c:	00000d8b 	andeq	r0, r0, fp, lsl #27
     820:	8f0e3407 	svchi	0x000e3407
     824:	6c000000 	stcvs	0, cr0, [r0], {-0}
     828:	03fb1600 	mvnseq	r1, #0, 12
     82c:	05650000 	strbeq	r0, [r5, #-0]!
     830:	a0170000 	andsge	r0, r7, r0
     834:	0f000000 	svceq	0x00000000
     838:	04ed0200 	strbteq	r0, [sp], #512	; 0x200
     83c:	0a080000 	beq	200844 <__bss_end+0x1f65a8>
     840:	00009b14 	andeq	r9, r0, r4, lsl fp
     844:	70030500 	andvc	r0, r3, r0, lsl #10
     848:	0a00009e 	beq	ac8 <shift+0xac8>
     84c:	00000b1c 	andeq	r0, r0, ip, lsl fp
     850:	00670405 	rsbeq	r0, r7, r5, lsl #8
     854:	0d080000 	stceq	0, cr0, [r8, #-0]
     858:	0005960c 	andeq	r9, r5, ip, lsl #12
     85c:	13370b00 	teqne	r7, #0, 22
     860:	0b000000 	bleq	868 <shift+0x868>
     864:	0000119a 	muleq	r0, sl, r1
     868:	26080001 	strcs	r0, [r8], -r1
     86c:	0c000008 	stceq	0, cr0, [r0], {8}
     870:	cb081b08 	blgt	207498 <__bss_end+0x1fd1fc>
     874:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     878:	0000058a 	andeq	r0, r0, sl, lsl #11
     87c:	cb191d08 	blgt	647ca4 <__bss_end+0x63da08>
     880:	00000005 	andeq	r0, r0, r5
     884:	0004dc0e 	andeq	sp, r4, lr, lsl #24
     888:	191e0800 	ldmdbne	lr, {fp}
     88c:	000005cb 	andeq	r0, r0, fp, asr #11
     890:	0b4c0e04 	bleq	13040a8 <__bss_end+0x12f9e0c>
     894:	1f080000 	svcne	0x00080000
     898:	0005d113 	andeq	sp, r5, r3, lsl r1
     89c:	18000800 	stmdane	r0, {fp}
     8a0:	00059604 	andeq	r9, r5, r4, lsl #12
     8a4:	c5041800 	strgt	r1, [r4, #-2048]	; 0xfffff800
     8a8:	0d000004 	stceq	0, cr0, [r0, #-16]
     8ac:	00000e93 	muleq	r0, r3, lr
     8b0:	07220814 			; <UNDEFINED> instruction: 0x07220814
     8b4:	00000859 	andeq	r0, r0, r9, asr r8
     8b8:	000c610e 	andeq	r6, ip, lr, lsl #2
     8bc:	12260800 	eorne	r0, r6, #0, 16
     8c0:	0000008f 	andeq	r0, r0, pc, lsl #1
     8c4:	0bf40e00 	bleq	ffd040cc <__bss_end+0xffcf9e30>
     8c8:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
     8cc:	0005cb1d 	andeq	ip, r5, sp, lsl fp
     8d0:	cf0e0400 	svcgt	0x000e0400
     8d4:	08000007 	stmdaeq	r0, {r0, r1, r2}
     8d8:	05cb1d2c 	strbeq	r1, [fp, #3372]	; 0xd2c
     8dc:	1c080000 	stcne	0, cr0, [r8], {-0}
     8e0:	00000d16 	andeq	r0, r0, r6, lsl sp
     8e4:	030e2f08 	movweq	r2, #61192	; 0xef08
     8e8:	1f000008 	svcne	0x00000008
     8ec:	2a000006 	bcs	90c <shift+0x90c>
     8f0:	10000006 	andne	r0, r0, r6
     8f4:	0000085e 	andeq	r0, r0, lr, asr r8
     8f8:	0005cb11 	andeq	ip, r5, r1, lsl fp
     8fc:	7e1d0000 	cdpvc	0, 1, cr0, cr13, cr0, {0}
     900:	08000009 	stmdaeq	r0, {r0, r3}
     904:	09180e31 	ldmdbeq	r8, {r0, r4, r5, r9, sl, fp}
     908:	03cc0000 	biceq	r0, ip, #0
     90c:	06420000 	strbeq	r0, [r2], -r0
     910:	064d0000 	strbeq	r0, [sp], -r0
     914:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     918:	11000008 	tstne	r0, r8
     91c:	000005d1 	ldrdeq	r0, [r0], -r1
     920:	11461300 	mrsne	r1, SPSR_und
     924:	35080000 	strcc	r0, [r8, #-0]
     928:	0006cc1d 	andeq	ip, r6, sp, lsl ip
     92c:	0005cb00 	andeq	ip, r5, r0, lsl #22
     930:	06660200 	strbteq	r0, [r6], -r0, lsl #4
     934:	066c0000 	strbteq	r0, [ip], -r0
     938:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     93c:	00000008 	andeq	r0, r0, r8
     940:	0007af13 	andeq	sl, r7, r3, lsl pc
     944:	1d370800 	ldcne	8, cr0, [r7, #-0]
     948:	00000d26 	andeq	r0, r0, r6, lsr #26
     94c:	000005cb 	andeq	r0, r0, fp, asr #11
     950:	00068502 	andeq	r8, r6, r2, lsl #10
     954:	00068b00 	andeq	r8, r6, r0, lsl #22
     958:	085e1000 	ldmdaeq	lr, {ip}^
     95c:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     960:	00000c07 	andeq	r0, r0, r7, lsl #24
     964:	77313908 	ldrvc	r3, [r1, -r8, lsl #18]!
     968:	0c000008 	stceq	0, cr0, [r0], {8}
     96c:	0e931302 	cdpeq	3, 9, cr1, cr3, cr2, {0}
     970:	3c080000 	stccc	0, cr0, [r8], {-0}
     974:	00098d09 	andeq	r8, r9, r9, lsl #26
     978:	00085e00 	andeq	r5, r8, r0, lsl #28
     97c:	06b20100 	ldrteq	r0, [r2], r0, lsl #2
     980:	06b80000 	ldrteq	r0, [r8], r0
     984:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
     988:	00000008 	andeq	r0, r0, r8
     98c:	00085313 	andeq	r5, r8, r3, lsl r3
     990:	123f0800 	eorsne	r0, pc, #0, 16
     994:	0000055f 	andeq	r0, r0, pc, asr r5
     998:	0000008f 	andeq	r0, r0, pc, lsl #1
     99c:	0006d101 	andeq	sp, r6, r1, lsl #2
     9a0:	0006e600 	andeq	lr, r6, r0, lsl #12
     9a4:	085e1000 	ldmdaeq	lr, {ip}^
     9a8:	80110000 	andshi	r0, r1, r0
     9ac:	11000008 	tstne	r0, r8
     9b0:	000000a0 	andeq	r0, r0, r0, lsr #1
     9b4:	0003cc11 	andeq	ip, r3, r1, lsl ip
     9b8:	70140000 	andsvc	r0, r4, r0
     9bc:	08000011 	stmdaeq	r0, {r0, r4}
     9c0:	067e0e42 	ldrbteq	r0, [lr], -r2, asr #28
     9c4:	fb010000 	blx	409ce <__bss_end+0x36732>
     9c8:	01000006 	tsteq	r0, r6
     9cc:	10000007 	andne	r0, r0, r7
     9d0:	0000085e 	andeq	r0, r0, lr, asr r8
     9d4:	05411300 	strbeq	r1, [r1, #-768]	; 0xfffffd00
     9d8:	45080000 	strmi	r0, [r8, #-0]
     9dc:	0005fc17 	andeq	pc, r5, r7, lsl ip	; <UNPREDICTABLE>
     9e0:	0005d100 	andeq	sp, r5, r0, lsl #2
     9e4:	071a0100 	ldreq	r0, [sl, -r0, lsl #2]
     9e8:	07200000 	streq	r0, [r0, -r0]!
     9ec:	86100000 	ldrhi	r0, [r0], -r0
     9f0:	00000008 	andeq	r0, r0, r8
     9f4:	000f4e13 	andeq	r4, pc, r3, lsl lr	; <UNPREDICTABLE>
     9f8:	17480800 	strbne	r0, [r8, -r0, lsl #16]
     9fc:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     a00:	000005d1 	ldrdeq	r0, [r0], -r1
     a04:	00073901 	andeq	r3, r7, r1, lsl #18
     a08:	00074400 	andeq	r4, r7, r0, lsl #8
     a0c:	08861000 	stmeq	r6, {ip}
     a10:	8f110000 	svchi	0x00110000
     a14:	00000000 	andeq	r0, r0, r0
     a18:	0006f114 	andeq	pc, r6, r4, lsl r1	; <UNPREDICTABLE>
     a1c:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
     a20:	00000c15 	andeq	r0, r0, r5, lsl ip
     a24:	00075901 	andeq	r5, r7, r1, lsl #18
     a28:	00075f00 	andeq	r5, r7, r0, lsl #30
     a2c:	085e1000 	ldmdaeq	lr, {ip}^
     a30:	13000000 	movwne	r0, #0
     a34:	0000097e 	andeq	r0, r0, lr, ror r9
     a38:	d50e4d08 	strle	r4, [lr, #-3336]	; 0xfffff2f8
     a3c:	cc00000d 	stcgt	0, cr0, [r0], {13}
     a40:	01000003 	tsteq	r0, r3
     a44:	00000778 	andeq	r0, r0, r8, ror r7
     a48:	00000783 	andeq	r0, r0, r3, lsl #15
     a4c:	00085e10 	andeq	r5, r8, r0, lsl lr
     a50:	008f1100 	addeq	r1, pc, r0, lsl #2
     a54:	13000000 	movwne	r0, #0
     a58:	000004c1 	andeq	r0, r0, r1, asr #9
     a5c:	ec125008 	ldc	0, cr5, [r2], {8}
     a60:	8f000003 	svchi	0x00000003
     a64:	01000000 	mrseq	r0, (UNDEF: 0)
     a68:	0000079c 	muleq	r0, ip, r7
     a6c:	000007a7 	andeq	r0, r0, r7, lsr #15
     a70:	00085e10 	andeq	r5, r8, r0, lsl lr
     a74:	03fb1100 	mvnseq	r1, #0, 2
     a78:	13000000 	movwne	r0, #0
     a7c:	0000041f 	andeq	r0, r0, pc, lsl r4
     a80:	c60e5308 	strgt	r5, [lr], -r8, lsl #6
     a84:	cc000011 	stcgt	0, cr0, [r0], {17}
     a88:	01000003 	tsteq	r0, r3
     a8c:	000007c0 	andeq	r0, r0, r0, asr #15
     a90:	000007cb 	andeq	r0, r0, fp, asr #15
     a94:	00085e10 	andeq	r5, r8, r0, lsl lr
     a98:	008f1100 	addeq	r1, pc, r0, lsl #2
     a9c:	14000000 	strne	r0, [r0], #-0
     aa0:	0000049b 	muleq	r0, fp, r4
     aa4:	480e5608 	stmdami	lr, {r3, r9, sl, ip, lr}
     aa8:	01000010 	tsteq	r0, r0, lsl r0
     aac:	000007e0 	andeq	r0, r0, r0, ror #15
     ab0:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     ab4:	00085e10 	andeq	r5, r8, r0, lsl lr
     ab8:	01261100 			; <UNDEFINED> instruction: 0x01261100
     abc:	8f110000 	svchi	0x00110000
     ac0:	11000000 	mrsne	r0, (UNDEF: 0)
     ac4:	0000008f 	andeq	r0, r0, pc, lsl #1
     ac8:	00008f11 	andeq	r8, r0, r1, lsl pc
     acc:	088c1100 	stmeq	ip, {r8, ip}
     ad0:	14000000 	strne	r0, [r0], #-0
     ad4:	00001253 	andeq	r1, r0, r3, asr r2
     ad8:	4c0e5808 	stcmi	8, cr5, [lr], {8}
     adc:	01000013 	tsteq	r0, r3, lsl r0
     ae0:	00000814 	andeq	r0, r0, r4, lsl r8
     ae4:	00000833 	andeq	r0, r0, r3, lsr r8
     ae8:	00085e10 	andeq	r5, r8, r0, lsl lr
     aec:	015d1100 	cmpeq	sp, r0, lsl #2
     af0:	8f110000 	svchi	0x00110000
     af4:	11000000 	mrsne	r0, (UNDEF: 0)
     af8:	0000008f 	andeq	r0, r0, pc, lsl #1
     afc:	00008f11 	andeq	r8, r0, r1, lsl pc
     b00:	088c1100 	stmeq	ip, {r8, ip}
     b04:	15000000 	strne	r0, [r0, #-0]
     b08:	000004ae 	andeq	r0, r0, lr, lsr #9
     b0c:	770e5b08 	strvc	r5, [lr, -r8, lsl #22]
     b10:	cc00000b 	stcgt	0, cr0, [r0], {11}
     b14:	01000003 	tsteq	r0, r3
     b18:	00000848 	andeq	r0, r0, r8, asr #16
     b1c:	00085e10 	andeq	r5, r8, r0, lsl lr
     b20:	05771100 	ldrbeq	r1, [r7, #-256]!	; 0xffffff00
     b24:	92110000 	andsls	r0, r1, #0
     b28:	00000008 	andeq	r0, r0, r8
     b2c:	05d70400 	ldrbeq	r0, [r7, #1024]	; 0x400
     b30:	04180000 	ldreq	r0, [r8], #-0
     b34:	000005d7 	ldrdeq	r0, [r0], -r7
     b38:	0005cb1f 	andeq	ip, r5, pc, lsl fp
     b3c:	00087100 	andeq	r7, r8, r0, lsl #2
     b40:	00087700 	andeq	r7, r8, r0, lsl #14
     b44:	085e1000 	ldmdaeq	lr, {ip}^
     b48:	20000000 	andcs	r0, r0, r0
     b4c:	000005d7 	ldrdeq	r0, [r0], -r7
     b50:	00000864 	andeq	r0, r0, r4, ror #16
     b54:	00750418 	rsbseq	r0, r5, r8, lsl r4
     b58:	04180000 	ldreq	r0, [r8], #-0
     b5c:	00000859 	andeq	r0, r0, r9, asr r8
     b60:	01000421 	tsteq	r0, r1, lsr #8
     b64:	04220000 	strteq	r0, [r2], #-0
     b68:	0012b51a 	andseq	fp, r2, sl, lsl r5
     b6c:	195e0800 	ldmdbne	lr, {fp}^
     b70:	000005d7 	ldrdeq	r0, [r0], -r7
     b74:	000e640d 	andeq	r6, lr, sp, lsl #8
     b78:	06090800 	streq	r0, [r9], -r0, lsl #16
     b7c:	0009e407 	andeq	lr, r9, r7, lsl #8
     b80:	09630e00 	stmdbeq	r3!, {r9, sl, fp}^
     b84:	0a090000 	beq	240b8c <__bss_end+0x2368f0>
     b88:	00008f12 	andeq	r8, r0, r2, lsl pc
     b8c:	b80e0000 	stmdalt	lr, {}	; <UNPREDICTABLE>
     b90:	0900000d 	stmdbeq	r0, {r0, r2, r3}
     b94:	03cc0e0c 	biceq	r0, ip, #12, 28	; 0xc0
     b98:	13040000 	movwne	r0, #16384	; 0x4000
     b9c:	00000e64 	andeq	r0, r0, r4, ror #28
     ba0:	9f091009 	svcls	0x00091009
     ba4:	e9000006 	stmdb	r0, {r1, r2}
     ba8:	01000009 	tsteq	r0, r9
     bac:	000008e0 	andeq	r0, r0, r0, ror #17
     bb0:	000008eb 	andeq	r0, r0, fp, ror #17
     bb4:	0009e910 	andeq	lr, r9, r0, lsl r9
     bb8:	03d91100 	bicseq	r1, r9, #0, 2
     bbc:	13000000 	movwne	r0, #0
     bc0:	00000e63 	andeq	r0, r0, r3, ror #28
     bc4:	1b151209 	blne	5453f0 <__bss_end+0x53b154>
     bc8:	9200000e 	andls	r0, r0, #14
     bcc:	01000008 	tsteq	r0, r8
     bd0:	00000904 	andeq	r0, r0, r4, lsl #18
     bd4:	0000090f 	andeq	r0, r0, pc, lsl #18
     bd8:	0009e910 	andeq	lr, r9, r0, lsl r9
     bdc:	00671000 	rsbeq	r1, r7, r0
     be0:	13000000 	movwne	r0, #0
     be4:	000006b8 			; <UNDEFINED> instruction: 0x000006b8
     be8:	230e1509 	movwcs	r1, #58633	; 0xe509
     bec:	cc00000a 	stcgt	0, cr0, [r0], {10}
     bf0:	01000003 	tsteq	r0, r3
     bf4:	00000928 	andeq	r0, r0, r8, lsr #18
     bf8:	0000092e 	andeq	r0, r0, lr, lsr #18
     bfc:	0009ef10 	andeq	lr, r9, r0, lsl pc
     c00:	d3140000 	tstle	r4, #0
     c04:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     c08:	08fe0e18 	ldmeq	lr!, {r3, r4, r9, sl, fp}^
     c0c:	43010000 	movwmi	r0, #4096	; 0x1000
     c10:	49000009 	stmdbmi	r0, {r0, r3}
     c14:	10000009 	andne	r0, r0, r9
     c18:	000009e9 	andeq	r0, r0, r9, ror #19
     c1c:	0a1d1400 	beq	745c24 <__bss_end+0x73b988>
     c20:	1b090000 	blne	240c28 <__bss_end+0x23698c>
     c24:	0007590e 	andeq	r5, r7, lr, lsl #18
     c28:	095e0100 	ldmdbeq	lr, {r8}^
     c2c:	09690000 	stmdbeq	r9!, {}^	; <UNPREDICTABLE>
     c30:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
     c34:	11000009 	tstne	r0, r9
     c38:	000003cc 	andeq	r0, r0, ip, asr #7
     c3c:	10c51400 	sbcne	r1, r5, r0, lsl #8
     c40:	1d090000 	stcne	0, cr0, [r9, #-0]
     c44:	0011a50e 	andseq	sl, r1, lr, lsl #10
     c48:	097e0100 	ldmdbeq	lr!, {r8}^
     c4c:	09930000 	ldmibeq	r3, {}	; <UNPREDICTABLE>
     c50:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
     c54:	11000009 	tstne	r0, r9
     c58:	0000007c 	andeq	r0, r0, ip, ror r0
     c5c:	00007c11 	andeq	r7, r0, r1, lsl ip
     c60:	03cc1100 	biceq	r1, ip, #0, 2
     c64:	14000000 	strne	r0, [r0], #-0
     c68:	0000077e 	andeq	r0, r0, lr, ror r7
     c6c:	8f0e1f09 	svchi	0x000e1f09
     c70:	01000005 	tsteq	r0, r5
     c74:	000009a8 	andeq	r0, r0, r8, lsr #19
     c78:	000009bd 			; <UNDEFINED> instruction: 0x000009bd
     c7c:	0009e910 	andeq	lr, r9, r0, lsl r9
     c80:	007c1100 	rsbseq	r1, ip, r0, lsl #2
     c84:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     c88:	11000000 	mrsne	r0, (UNDEF: 0)
     c8c:	00000043 	andeq	r0, r0, r3, asr #32
     c90:	12c12300 	sbcne	r2, r1, #0, 6
     c94:	21090000 	mrscs	r0, (UNDEF: 9)
     c98:	000f850e 	andeq	r8, pc, lr, lsl #10
     c9c:	09ce0100 	stmibeq	lr, {r8}^
     ca0:	e9100000 	ldmdb	r0, {}	; <UNPREDICTABLE>
     ca4:	11000009 	tstne	r0, r9
     ca8:	0000007c 	andeq	r0, r0, ip, ror r0
     cac:	00007c11 	andeq	r7, r0, r1, lsl ip
     cb0:	03d91100 	bicseq	r1, r9, #0, 2
     cb4:	00000000 	andeq	r0, r0, r0
     cb8:	0008a004 	andeq	sl, r8, r4
     cbc:	a0041800 	andge	r1, r4, r0, lsl #16
     cc0:	18000008 	stmdane	r0, {r3}
     cc4:	0009e404 	andeq	lr, r9, r4, lsl #8
     cc8:	61682400 	cmnvs	r8, r0, lsl #8
     ccc:	050a006c 	streq	r0, [sl, #-108]	; 0xffffff94
     cd0:	000aaf0b 	andeq	sl, sl, fp, lsl #30
     cd4:	0bc42500 	bleq	ff10a0dc <__bss_end+0xff0ffe40>
     cd8:	070a0000 	streq	r0, [sl, -r0]
     cdc:	0000a719 	andeq	sl, r0, r9, lsl r7
     ce0:	e6b28000 	ldrt	r8, [r2], r0
     ce4:	0f61250e 	svceq	0x0061250e
     ce8:	0a0a0000 	beq	280cf0 <__bss_end+0x276a54>
     cec:	0004c01a 	andeq	ip, r4, sl, lsl r0
     cf0:	00000000 	andeq	r0, r0, r0
     cf4:	05552520 	ldrbeq	r2, [r5, #-1312]	; 0xfffffae0
     cf8:	0d0a0000 	stceq	0, cr0, [sl, #-0]
     cfc:	0004c01a 	andeq	ip, r4, sl, lsl r0
     d00:	20000000 	andcs	r0, r0, r0
     d04:	0b3d2620 	bleq	f4a58c <__bss_end+0xf402f0>
     d08:	100a0000 	andne	r0, sl, r0
     d0c:	00009b15 	andeq	r9, r0, r5, lsl fp
     d10:	52253600 	eorpl	r3, r5, #0, 12
     d14:	0a000011 	beq	d60 <shift+0xd60>
     d18:	04c01a4b 	strbeq	r1, [r0], #2635	; 0xa4b
     d1c:	50000000 	andpl	r0, r0, r0
     d20:	fe252021 	cdp2	0, 2, cr2, cr5, cr1, {1}
     d24:	0a000012 	beq	d74 <shift+0xd74>
     d28:	04c01a7a 	strbeq	r1, [r0], #2682	; 0xa7a
     d2c:	b2000000 	andlt	r0, r0, #0
     d30:	b6252000 	strtlt	r2, [r5], -r0
     d34:	0a000008 	beq	d5c <shift+0xd5c>
     d38:	04c01aad 	strbeq	r1, [r0], #2733	; 0xaad
     d3c:	b4000000 	strlt	r0, [r0], #-0
     d40:	ba252000 	blt	948d48 <__bss_end+0x93eaac>
     d44:	0a00000b 	beq	d78 <shift+0xd78>
     d48:	04c01abc 	strbeq	r1, [r0], #2748	; 0xabc
     d4c:	40000000 	andmi	r0, r0, r0
     d50:	5f252010 	svcpl	0x00252010
     d54:	0a00000d 	beq	d90 <shift+0xd90>
     d58:	04c01ac7 	strbeq	r1, [r0], #2759	; 0xac7
     d5c:	50000000 	andpl	r0, r0, r0
     d60:	74252020 	strtvc	r2, [r5], #-32	; 0xffffffe0
     d64:	0a000007 	beq	d88 <shift+0xd88>
     d68:	04c01ac8 	strbeq	r1, [r0], #2760	; 0xac8
     d6c:	40000000 	andmi	r0, r0, r0
     d70:	5b252080 	blpl	948f78 <__bss_end+0x93ecdc>
     d74:	0a000011 	beq	dc0 <shift+0xdc0>
     d78:	04c01ac9 	strbeq	r1, [r0], #2761	; 0xac9
     d7c:	50000000 	andpl	r0, r0, r0
     d80:	27002080 	strcs	r2, [r0, -r0, lsl #1]
     d84:	00000a01 	andeq	r0, r0, r1, lsl #20
     d88:	000a1127 	andeq	r1, sl, r7, lsr #2
     d8c:	0a212700 	beq	84a994 <__bss_end+0x8406f8>
     d90:	31270000 			; <UNDEFINED> instruction: 0x31270000
     d94:	2700000a 	strcs	r0, [r0, -sl]
     d98:	00000a3e 	andeq	r0, r0, lr, lsr sl
     d9c:	000a4e27 	andeq	r4, sl, r7, lsr #28
     da0:	0a5e2700 	beq	178a9a8 <__bss_end+0x178070c>
     da4:	6e270000 	cdpvs	0, 2, cr0, cr7, cr0, {0}
     da8:	2700000a 	strcs	r0, [r0, -sl]
     dac:	00000a7e 	andeq	r0, r0, lr, ror sl
     db0:	000a8e27 	andeq	r8, sl, r7, lsr #28
     db4:	0a9e2700 	beq	fe78a9bc <__bss_end+0xfe780720>
     db8:	d8020000 	stmdale	r2, {}	; <UNPREDICTABLE>
     dbc:	0b00000f 	bleq	e00 <shift+0xe00>
     dc0:	009b1408 	addseq	r1, fp, r8, lsl #8
     dc4:	03050000 	movweq	r0, #20480	; 0x5000
     dc8:	00009ea0 	andeq	r9, r0, r0, lsr #29
     dcc:	000cd20a 	andeq	sp, ip, sl, lsl #4
     dd0:	a0040700 	andge	r0, r4, r0, lsl #14
     dd4:	0b000000 	bleq	ddc <shift+0xddc>
     dd8:	0b410c0b 	bleq	1043e0c <__bss_end+0x1039b70>
     ddc:	e50b0000 	str	r0, [fp, #-0]
     de0:	0000000c 	andeq	r0, r0, ip
     de4:	00063c0b 	andeq	r3, r6, fp, lsl #24
     de8:	1d0b0100 	stfnes	f0, [fp, #-0]
     dec:	02000012 	andeq	r0, r0, #18
     df0:	0012170b 	andseq	r1, r2, fp, lsl #14
     df4:	f20b0300 	vcgt.s8	d0, d11, d0
     df8:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
     dfc:	0012da0b 	andseq	sp, r2, fp, lsl #20
     e00:	0b0b0500 	bleq	2c2208 <__bss_end+0x2b7f6c>
     e04:	06000012 			; <UNDEFINED> instruction: 0x06000012
     e08:	0012110b 	andseq	r1, r2, fp, lsl #2
     e0c:	a40b0700 	strge	r0, [fp], #-1792	; 0xfffff900
     e10:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     e14:	0a6e0a00 	beq	1b8361c <__bss_end+0x1b79380>
     e18:	04050000 	streq	r0, [r5], #-0
     e1c:	00000067 	andeq	r0, r0, r7, rrx
     e20:	6c0c1d0b 	stcvs	13, cr1, [ip], {11}
     e24:	0b00000b 	bleq	e58 <shift+0xe58>
     e28:	00000d69 	andeq	r0, r0, r9, ror #26
     e2c:	0dab0b00 			; <UNDEFINED> instruction: 0x0dab0b00
     e30:	0b010000 	bleq	40e38 <__bss_end+0x36b9c>
     e34:	00000d86 	andeq	r0, r0, r6, lsl #27
     e38:	6f4c1b02 	svcvs	0x004c1b02
     e3c:	00030077 	andeq	r0, r3, r7, ror r0
     e40:	0012cc0d 	andseq	ip, r2, sp, lsl #24
     e44:	280b1c00 	stmdacs	fp, {sl, fp, ip}
     e48:	000eed07 	andeq	lr, lr, r7, lsl #26
     e4c:	039b0800 	orrseq	r0, fp, #0, 16
     e50:	0b100000 	bleq	400e58 <__bss_end+0x3f6bbc>
     e54:	0bbb0a33 	bleq	feec3728 <__bss_end+0xfeeb948c>
     e58:	bd0e0000 	stclt	0, cr0, [lr, #-0]
     e5c:	0b000013 	bleq	eb0 <shift+0xeb0>
     e60:	03fb0b35 	mvnseq	r0, #54272	; 0xd400
     e64:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e68:	00000839 	andeq	r0, r0, r9, lsr r8
     e6c:	8f0d360b 	svchi	0x000d360b
     e70:	04000000 	streq	r0, [r0], #-0
     e74:	00058a0e 	andeq	r8, r5, lr, lsl #20
     e78:	13370b00 	teqne	r7, #0, 22
     e7c:	00000ef2 	strdeq	r0, [r0], -r2
     e80:	04dc0e08 	ldrbeq	r0, [ip], #3592	; 0xe08
     e84:	380b0000 	stmdacc	fp, {}	; <UNPREDICTABLE>
     e88:	000ef213 	andeq	pc, lr, r3, lsl r2	; <UNPREDICTABLE>
     e8c:	0e000c00 	cdpeq	12, 0, cr0, cr0, cr0, {0}
     e90:	0000084d 	andeq	r0, r0, sp, asr #16
     e94:	fe202c0b 	cdp2	12, 2, cr2, cr0, cr11, {0}
     e98:	0000000e 	andeq	r0, r0, lr
     e9c:	0010250e 	andseq	r2, r0, lr, lsl #10
     ea0:	0c2f0b00 			; <UNDEFINED> instruction: 0x0c2f0b00
     ea4:	00000f03 	andeq	r0, r0, r3, lsl #30
     ea8:	0b040e04 	bleq	1046c0 <__bss_end+0xfa424>
     eac:	310b0000 	mrscc	r0, (UNDEF: 11)
     eb0:	000f030c 	andeq	r0, pc, ip, lsl #6
     eb4:	440e0c00 	strmi	r0, [lr], #-3072	; 0xfffff400
     eb8:	0b00000c 	bleq	ef0 <shift+0xef0>
     ebc:	0ef2123b 	mrceq	2, 7, r1, cr2, cr11, {1}
     ec0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     ec4:	000009df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     ec8:	9a0e3d0b 	bls	3902fc <__bss_end+0x386060>
     ecc:	18000001 	stmdane	r0, {r0}
     ed0:	000f7113 	andeq	r7, pc, r3, lsl r1	; <UNPREDICTABLE>
     ed4:	08410b00 	stmdaeq	r1, {r8, r9, fp}^
     ed8:	00000862 	andeq	r0, r0, r2, ror #16
     edc:	000003cc 	andeq	r0, r0, ip, asr #7
     ee0:	000c1502 	andeq	r1, ip, r2, lsl #10
     ee4:	000c2a00 	andeq	r2, ip, r0, lsl #20
     ee8:	0f131000 	svceq	0x00131000
     eec:	8f110000 	svchi	0x00110000
     ef0:	11000000 	mrsne	r0, (UNDEF: 0)
     ef4:	00000f19 	andeq	r0, r0, r9, lsl pc
     ef8:	000f1911 	andeq	r1, pc, r1, lsl r9	; <UNPREDICTABLE>
     efc:	a3130000 	tstge	r3, #0
     f00:	0b000008 	bleq	f28 <shift+0xf28>
     f04:	12690843 	rsbne	r0, r9, #4390912	; 0x430000
     f08:	03cc0000 	biceq	r0, ip, #0
     f0c:	43020000 	movwmi	r0, #8192	; 0x2000
     f10:	5800000c 	stmdapl	r0, {r2, r3}
     f14:	1000000c 	andne	r0, r0, ip
     f18:	00000f13 	andeq	r0, r0, r3, lsl pc
     f1c:	00008f11 	andeq	r8, r0, r1, lsl pc
     f20:	0f191100 	svceq	0x00191100
     f24:	19110000 	ldmdbne	r1, {}	; <UNPREDICTABLE>
     f28:	0000000f 	andeq	r0, r0, pc
     f2c:	000be113 	andeq	lr, fp, r3, lsl r1
     f30:	08450b00 	stmdaeq	r5, {r8, r9, fp}^
     f34:	000009a7 	andeq	r0, r0, r7, lsr #19
     f38:	000003cc 	andeq	r0, r0, ip, asr #7
     f3c:	000c7102 	andeq	r7, ip, r2, lsl #2
     f40:	000c8600 	andeq	r8, ip, r0, lsl #12
     f44:	0f131000 	svceq	0x00131000
     f48:	8f110000 	svchi	0x00110000
     f4c:	11000000 	mrsne	r0, (UNDEF: 0)
     f50:	00000f19 	andeq	r0, r0, r9, lsl pc
     f54:	000f1911 	andeq	r1, pc, r1, lsl r9	; <UNPREDICTABLE>
     f58:	4c130000 	ldcmi	0, cr0, [r3], {-0}
     f5c:	0b00000d 	bleq	f98 <shift+0xf98>
     f60:	04320847 	ldrteq	r0, [r2], #-2119	; 0xfffff7b9
     f64:	03cc0000 	biceq	r0, ip, #0
     f68:	9f020000 	svcls	0x00020000
     f6c:	b400000c 	strlt	r0, [r0], #-12
     f70:	1000000c 	andne	r0, r0, ip
     f74:	00000f13 	andeq	r0, r0, r3, lsl pc
     f78:	00008f11 	andeq	r8, r0, r1, lsl pc
     f7c:	0f191100 	svceq	0x00191100
     f80:	19110000 	ldmdbne	r1, {}	; <UNPREDICTABLE>
     f84:	0000000f 	andeq	r0, r0, pc
     f88:	0008d913 	andeq	sp, r8, r3, lsl r9
     f8c:	08490b00 	stmdaeq	r9, {r8, r9, fp}^
     f90:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
     f94:	000003cc 	andeq	r0, r0, ip, asr #7
     f98:	000ccd02 	andeq	ip, ip, r2, lsl #26
     f9c:	000ce200 	andeq	lr, ip, r0, lsl #4
     fa0:	0f131000 	svceq	0x00131000
     fa4:	8f110000 	svchi	0x00110000
     fa8:	11000000 	mrsne	r0, (UNDEF: 0)
     fac:	00000f19 	andeq	r0, r0, r9, lsl pc
     fb0:	000f1911 	andeq	r1, pc, r1, lsl r9	; <UNPREDICTABLE>
     fb4:	ff130000 			; <UNDEFINED> instruction: 0xff130000
     fb8:	0b000010 	bleq	1000 <shift+0x1000>
     fbc:	05af084b 	streq	r0, [pc, #2123]!	; 180f <shift+0x180f>
     fc0:	03cc0000 	biceq	r0, ip, #0
     fc4:	fb020000 	blx	80fce <__bss_end+0x76d32>
     fc8:	1500000c 	strne	r0, [r0, #-12]
     fcc:	1000000d 	andne	r0, r0, sp
     fd0:	00000f13 	andeq	r0, r0, r3, lsl pc
     fd4:	00008f11 	andeq	r8, r0, r1, lsl pc
     fd8:	0b411100 	bleq	10453e0 <__bss_end+0x103b144>
     fdc:	19110000 	ldmdbne	r1, {}	; <UNPREDICTABLE>
     fe0:	1100000f 	tstne	r0, pc
     fe4:	00000f19 	andeq	r0, r0, r9, lsl pc
     fe8:	0e321300 	cdpeq	3, 3, cr1, cr2, cr0, {0}
     fec:	4f0b0000 	svcmi	0x000b0000
     ff0:	0009ef0c 	andeq	lr, r9, ip, lsl #30
     ff4:	00008f00 	andeq	r8, r0, r0, lsl #30
     ff8:	0d2e0200 	sfmeq	f0, 4, [lr, #-0]
     ffc:	0d340000 	ldceq	0, cr0, [r4, #-0]
    1000:	13100000 	tstne	r0, #0
    1004:	0000000f 	andeq	r0, r0, pc
    1008:	000a9114 	andeq	r9, sl, r4, lsl r1
    100c:	08510b00 	ldmdaeq	r1, {r8, r9, fp}^
    1010:	0000109a 	muleq	r0, sl, r0
    1014:	000d4902 	andeq	r4, sp, r2, lsl #18
    1018:	000d5400 	andeq	r5, sp, r0, lsl #8
    101c:	0f1f1000 	svceq	0x001f1000
    1020:	8f110000 	svchi	0x00110000
    1024:	00000000 	andeq	r0, r0, r0
    1028:	0012cc13 	andseq	ip, r2, r3, lsl ip
    102c:	03540b00 	cmpeq	r4, #0, 22
    1030:	000007e2 	andeq	r0, r0, r2, ror #15
    1034:	00000f1f 	andeq	r0, r0, pc, lsl pc
    1038:	000d6d01 	andeq	r6, sp, r1, lsl #26
    103c:	000d7800 	andeq	r7, sp, r0, lsl #16
    1040:	0f1f1000 	svceq	0x001f1000
    1044:	a0110000 	andsge	r0, r1, r0
    1048:	00000000 	andeq	r0, r0, r0
    104c:	0008ec14 	andeq	lr, r8, r4, lsl ip
    1050:	08570b00 	ldmdaeq	r7, {r8, r9, fp}^
    1054:	00000ca9 	andeq	r0, r0, r9, lsr #25
    1058:	000d8d01 	andeq	r8, sp, r1, lsl #26
    105c:	000d9d00 	andeq	r9, sp, r0, lsl #26
    1060:	0f1f1000 	svceq	0x001f1000
    1064:	8f110000 	svchi	0x00110000
    1068:	11000000 	mrsne	r0, (UNDEF: 0)
    106c:	00000af8 	strdeq	r0, [r0], -r8
    1070:	0b601300 	bleq	1805c78 <__bss_end+0x17fb9dc>
    1074:	590b0000 	stmdbpl	fp, {}	; <UNPREDICTABLE>
    1078:	000faa12 	andeq	sl, pc, r2, lsl sl	; <UNPREDICTABLE>
    107c:	000af800 	andeq	pc, sl, r0, lsl #16
    1080:	0db60100 	ldfeqs	f0, [r6]
    1084:	0dc10000 	stcleq	0, cr0, [r1]
    1088:	13100000 	tstne	r0, #0
    108c:	1100000f 	tstne	r0, pc
    1090:	0000008f 	andeq	r0, r0, pc, lsl #1
    1094:	06381400 	ldrteq	r1, [r8], -r0, lsl #8
    1098:	5c0b0000 	stcpl	0, cr0, [fp], {-0}
    109c:	00073708 	andeq	r3, r7, r8, lsl #14
    10a0:	0dd60100 	ldfeqe	f0, [r6]
    10a4:	0de60000 	stcleq	0, cr0, [r6]
    10a8:	1f100000 	svcne	0x00100000
    10ac:	1100000f 	tstne	r0, pc
    10b0:	0000008f 	andeq	r0, r0, pc, lsl #1
    10b4:	0003cc11 	andeq	ip, r3, r1, lsl ip
    10b8:	e1130000 	tst	r3, r0
    10bc:	0b00000c 	bleq	10f4 <shift+0x10f4>
    10c0:	0718085f 			; <UNDEFINED> instruction: 0x0718085f
    10c4:	03cc0000 	biceq	r0, ip, #0
    10c8:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    10cc:	0a00000d 	beq	1108 <shift+0x1108>
    10d0:	1000000e 	andne	r0, r0, lr
    10d4:	00000f1f 	andeq	r0, r0, pc, lsl pc
    10d8:	00008f11 	andeq	r8, r0, r1, lsl pc
    10dc:	7a130000 	bvc	4c10e4 <__bss_end+0x4b6e48>
    10e0:	0b00000d 	bleq	111c <shift+0x111c>
    10e4:	04610862 	strbteq	r0, [r1], #-2146	; 0xfffff79e
    10e8:	03cc0000 	biceq	r0, ip, #0
    10ec:	23010000 	movwcs	r0, #4096	; 0x1000
    10f0:	3800000e 	stmdacc	r0, {r1, r2, r3}
    10f4:	1000000e 	andne	r0, r0, lr
    10f8:	00000f1f 	andeq	r0, r0, pc, lsl pc
    10fc:	00008f11 	andeq	r8, r0, r1, lsl pc
    1100:	03cc1100 	biceq	r1, ip, #0, 2
    1104:	cc110000 	ldcgt	0, cr0, [r1], {-0}
    1108:	00000003 	andeq	r0, r0, r3
    110c:	000e8a13 	andeq	r8, lr, r3, lsl sl
    1110:	08640b00 	stmdaeq	r4!, {r8, r9, fp}^
    1114:	00000eb0 			; <UNDEFINED> instruction: 0x00000eb0
    1118:	000003cc 	andeq	r0, r0, ip, asr #7
    111c:	000e5101 	andeq	r5, lr, r1, lsl #2
    1120:	000e6600 	andeq	r6, lr, r0, lsl #12
    1124:	0f1f1000 	svceq	0x001f1000
    1128:	8f110000 	svchi	0x00110000
    112c:	11000000 	mrsne	r0, (UNDEF: 0)
    1130:	000003cc 	andeq	r0, r0, ip, asr #7
    1134:	0003cc11 	andeq	ip, r3, r1, lsl ip
    1138:	a4140000 	ldrge	r0, [r4], #-0
    113c:	0b000013 	bleq	1190 <shift+0x1190>
    1140:	0a430867 	beq	10c32e4 <__bss_end+0x10b9048>
    1144:	7b010000 	blvc	4114c <__bss_end+0x36eb0>
    1148:	8b00000e 	blhi	1188 <shift+0x1188>
    114c:	1000000e 	andne	r0, r0, lr
    1150:	00000f1f 	andeq	r0, r0, pc, lsl pc
    1154:	00008f11 	andeq	r8, r0, r1, lsl pc
    1158:	0b411100 	bleq	1045560 <__bss_end+0x103b2c4>
    115c:	14000000 	strne	r0, [r0], #-0
    1160:	000012e9 	andeq	r1, r0, r9, ror #5
    1164:	e408690b 	str	r6, [r8], #-2315	; 0xfffff6f5
    1168:	0100000f 	tsteq	r0, pc
    116c:	00000ea0 	andeq	r0, r0, r0, lsr #29
    1170:	00000eb0 			; <UNDEFINED> instruction: 0x00000eb0
    1174:	000f1f10 	andeq	r1, pc, r0, lsl pc	; <UNPREDICTABLE>
    1178:	008f1100 	addeq	r1, pc, r0, lsl #2
    117c:	41110000 	tstmi	r1, r0
    1180:	0000000b 	andeq	r0, r0, fp
    1184:	000aa614 	andeq	sl, sl, r4, lsl r6
    1188:	086c0b00 	stmdaeq	ip!, {r8, r9, fp}^
    118c:	00001179 	andeq	r1, r0, r9, ror r1
    1190:	000ec501 	andeq	ip, lr, r1, lsl #10
    1194:	000ecb00 	andeq	ip, lr, r0, lsl #22
    1198:	0f1f1000 	svceq	0x001f1000
    119c:	23000000 	movwcs	r0, #0
    11a0:	00000b51 	andeq	r0, r0, r1, asr fp
    11a4:	1a086f0b 	bne	21cdd8 <__bss_end+0x212b3c>
    11a8:	01000011 	tsteq	r0, r1, lsl r0
    11ac:	00000edc 	ldrdeq	r0, [r0], -ip
    11b0:	000f1f10 	andeq	r1, pc, r0, lsl pc	; <UNPREDICTABLE>
    11b4:	03fb1100 	mvnseq	r1, #0, 2
    11b8:	8f110000 	svchi	0x00110000
    11bc:	00000000 	andeq	r0, r0, r0
    11c0:	0b6c0400 	bleq	1b021c8 <__bss_end+0x1af7f2c>
    11c4:	04180000 	ldreq	r0, [r8], #-0
    11c8:	00000b79 	andeq	r0, r0, r9, ror fp
    11cc:	00ac0418 	adceq	r0, ip, r8, lsl r4
    11d0:	f8040000 			; <UNDEFINED> instruction: 0xf8040000
    11d4:	1600000e 	strne	r0, [r0], -lr
    11d8:	0000008f 	andeq	r0, r0, pc, lsl #1
    11dc:	00000f13 	andeq	r0, r0, r3, lsl pc
    11e0:	0000a017 	andeq	sl, r0, r7, lsl r0
    11e4:	18000100 	stmdane	r0, {r8}
    11e8:	000eed04 	andeq	lr, lr, r4, lsl #26
    11ec:	8f042100 	svchi	0x00042100
    11f0:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    11f4:	000b6c04 	andeq	r6, fp, r4, lsl #24
    11f8:	08d31a00 	ldmeq	r3, {r9, fp, ip}^
    11fc:	730b0000 	movwvc	r0, #45056	; 0xb000
    1200:	000b6c16 	andeq	r6, fp, r6, lsl ip
    1204:	03d91600 	bicseq	r1, r9, #0, 12
    1208:	0f410000 	svceq	0x00410000
    120c:	a0170000 	andsge	r0, r7, r0
    1210:	04000000 	streq	r0, [r0], #-0
    1214:	09d62800 	ldmibeq	r6, {fp, sp}^
    1218:	12010000 	andne	r0, r1, #0
    121c:	000f310d 	andeq	r3, pc, sp, lsl #2
    1220:	78030500 	stmdavc	r3, {r8, sl}
    1224:	290000a2 	stmdbcs	r0, {r1, r5, r7}
    1228:	000012ab 	andeq	r1, r0, fp, lsr #5
    122c:	67051a01 	strvs	r1, [r5, -r1, lsl #20]
    1230:	2c000000 	stccs	0, cr0, [r0], {-0}
    1234:	0c000082 	stceq	0, cr0, [r0], {130}	; 0x82
    1238:	01000001 	tsteq	r0, r1
    123c:	000fd29c 	muleq	pc, ip, r2	; <UNPREDICTABLE>
    1240:	0d752a00 	vldmdbeq	r5!, {s5-s4}
    1244:	1a010000 	bne	4124c <__bss_end+0x36fb0>
    1248:	0000670e 	andeq	r6, r0, lr, lsl #14
    124c:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1250:	000d9d2a 	andeq	r9, sp, sl, lsr #26
    1254:	1b1a0100 	blne	68165c <__bss_end+0x6773c0>
    1258:	00000fd2 	ldrdeq	r0, [r0], -r2
    125c:	2b589102 	blcs	162566c <__bss_end+0x161b3d0>
    1260:	000012b0 			; <UNDEFINED> instruction: 0x000012b0
    1264:	a0101c01 	andsge	r1, r0, r1, lsl #24
    1268:	02000008 	andeq	r0, r0, #8
    126c:	b82b6891 	stmdalt	fp!, {r0, r4, r7, fp, sp, lr}
    1270:	01000013 	tsteq	r0, r3, lsl r0
    1274:	008f0b21 	addeq	r0, pc, r1, lsr #22
    1278:	91020000 	mrsls	r0, (UNDEF: 2)
    127c:	756e2c74 	strbvc	r2, [lr, #-3188]!	; 0xfffff38c
    1280:	2201006d 	andcs	r0, r1, #109	; 0x6d
    1284:	00008f0b 	andeq	r8, r0, fp, lsl #30
    1288:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    128c:	0082a42d 	addeq	sl, r2, sp, lsr #8
    1290:	00007c00 	andeq	r7, r0, r0, lsl #24
    1294:	736d2c00 	cmnvc	sp, #0, 24
    1298:	2a010067 	bcs	4143c <__bss_end+0x371a0>
    129c:	0003d90f 	andeq	sp, r3, pc, lsl #18
    12a0:	70910200 	addsvc	r0, r1, r0, lsl #4
    12a4:	04180000 	ldreq	r0, [r8], #-0
    12a8:	00000fd8 	ldrdeq	r0, [r0], -r8
    12ac:	00430418 	subeq	r0, r3, r8, lsl r4
    12b0:	5c000000 	stcpl	0, cr0, [r0], {-0}
    12b4:	0400000d 	streq	r0, [r0], #-13
    12b8:	00049300 	andeq	r9, r4, r0, lsl #6
    12bc:	10010400 	andne	r0, r1, r0, lsl #8
    12c0:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    12c4:	000014f3 	strdeq	r1, [r0], -r3
    12c8:	0000157e 	andeq	r1, r0, lr, ror r5
    12cc:	00008338 	andeq	r8, r0, r8, lsr r3
    12d0:	0000045c 	andeq	r0, r0, ip, asr r4
    12d4:	000004af 	andeq	r0, r0, pc, lsr #9
    12d8:	e6080102 	str	r0, [r8], -r2, lsl #2
    12dc:	03000010 	movweq	r0, #16
    12e0:	00000025 	andeq	r0, r0, r5, lsr #32
    12e4:	59050202 	stmdbpl	r5, {r1, r9}
    12e8:	0400000e 	streq	r0, [r0], #-14
    12ec:	00000710 	andeq	r0, r0, r0, lsl r7
    12f0:	49070502 	stmdbmi	r7, {r1, r8, sl}
    12f4:	03000000 	movweq	r0, #0
    12f8:	00000038 	andeq	r0, r0, r8, lsr r0
    12fc:	69050405 	stmdbvs	r5, {r0, r2, sl}
    1300:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    1304:	031f0508 	tsteq	pc, #8, 10	; 0x2000000
    1308:	01020000 	mrseq	r0, (UNDEF: 2)
    130c:	0010dd08 	andseq	sp, r0, r8, lsl #26
    1310:	07020200 	streq	r0, [r2, -r0, lsl #4]
    1314:	00001298 	muleq	r0, r8, r2
    1318:	00070f04 	andeq	r0, r7, r4, lsl #30
    131c:	070a0200 	streq	r0, [sl, -r0, lsl #4]
    1320:	00000076 	andeq	r0, r0, r6, ror r0
    1324:	00006503 	andeq	r6, r0, r3, lsl #10
    1328:	07040200 	streq	r0, [r4, -r0, lsl #4]
    132c:	000007a2 	andeq	r0, r0, r2, lsr #15
    1330:	98070802 	stmdals	r7, {r1, fp}
    1334:	06000007 	streq	r0, [r0], -r7
    1338:	00000ef9 	strdeq	r0, [r0], -r9
    133c:	44130d02 	ldrmi	r0, [r3], #-3330	; 0xfffff2fe
    1340:	05000000 	streq	r0, [r0, #-0]
    1344:	009f5c03 	addseq	r5, pc, r3, lsl #24
    1348:	07bd0600 	ldreq	r0, [sp, r0, lsl #12]!
    134c:	0e020000 	cdpeq	0, 0, cr0, cr2, cr0, {0}
    1350:	00004413 	andeq	r4, r0, r3, lsl r4
    1354:	60030500 	andvs	r0, r3, r0, lsl #10
    1358:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    135c:	00000ef8 	strdeq	r0, [r0], -r8
    1360:	71141002 	tstvc	r4, r2
    1364:	05000000 	streq	r0, [r0, #-0]
    1368:	009f6403 	addseq	r6, pc, r3, lsl #8
    136c:	07bc0600 	ldreq	r0, [ip, r0, lsl #12]!
    1370:	11020000 	mrsne	r0, (UNDEF: 2)
    1374:	00007114 	andeq	r7, r0, r4, lsl r1
    1378:	68030500 	stmdavs	r3, {r8, sl}
    137c:	0700009f 			; <UNDEFINED> instruction: 0x0700009f
    1380:	00001398 	muleq	r0, r8, r3
    1384:	08060308 	stmdaeq	r6, {r3, r8, r9}
    1388:	000000f2 	strdeq	r0, [r0], -r2
    138c:	00307208 	eorseq	r7, r0, r8, lsl #4
    1390:	650e0803 	strvs	r0, [lr, #-2051]	; 0xfffff7fd
    1394:	00000000 	andeq	r0, r0, r0
    1398:	00317208 	eorseq	r7, r1, r8, lsl #4
    139c:	650e0903 	strvs	r0, [lr, #-2307]	; 0xfffff6fd
    13a0:	04000000 	streq	r0, [r0], #-0
    13a4:	163e0900 	ldrtne	r0, [lr], -r0, lsl #18
    13a8:	04050000 	streq	r0, [r5], #-0
    13ac:	00000049 	andeq	r0, r0, r9, asr #32
    13b0:	100c0d03 	andne	r0, ip, r3, lsl #26
    13b4:	0a000001 	beq	13c0 <shift+0x13c0>
    13b8:	00004b4f 	andeq	r4, r0, pc, asr #22
    13bc:	00143f0b 	andseq	r3, r4, fp, lsl #30
    13c0:	09000100 	stmdbeq	r0, {r8}
    13c4:	00000f1b 	andeq	r0, r0, fp, lsl pc
    13c8:	00490405 	subeq	r0, r9, r5, lsl #8
    13cc:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
    13d0:	0001470c 	andeq	r4, r1, ip, lsl #14
    13d4:	07070b00 	streq	r0, [r7, -r0, lsl #22]
    13d8:	0b000000 	bleq	13e0 <shift+0x13e0>
    13dc:	0000096b 	andeq	r0, r0, fp, ror #18
    13e0:	0f3d0b01 	svceq	0x003d0b01
    13e4:	0b020000 	bleq	813ec <__bss_end+0x77150>
    13e8:	000010f9 	strdeq	r1, [r0], -r9
    13ec:	094e0b03 	stmdbeq	lr, {r0, r1, r8, r9, fp}^
    13f0:	0b040000 	bleq	1013f8 <__bss_end+0xf715c>
    13f4:	00000e49 	andeq	r0, r0, r9, asr #28
    13f8:	03090005 	movweq	r0, #36869	; 0x9005
    13fc:	0500000f 	streq	r0, [r0, #-15]
    1400:	00004904 	andeq	r4, r0, r4, lsl #18
    1404:	0c440300 	mcrreq	3, 0, r0, r4, cr0
    1408:	00000184 	andeq	r0, r0, r4, lsl #3
    140c:	0008920b 	andeq	r9, r8, fp, lsl #4
    1410:	370b0000 	strcc	r0, [fp, -r0]
    1414:	01000010 	tsteq	r0, r0, lsl r0
    1418:	0013280b 	andseq	r2, r3, fp, lsl #16
    141c:	200b0200 	andcs	r0, fp, r0, lsl #4
    1420:	0300000d 	movweq	r0, #13
    1424:	00095d0b 	andeq	r5, r9, fp, lsl #26
    1428:	830b0400 	movwhi	r0, #46080	; 0xb400
    142c:	0500000a 	streq	r0, [r0, #-10]
    1430:	0007870b 	andeq	r8, r7, fp, lsl #14
    1434:	09000600 	stmdbeq	r0, {r9, sl}
    1438:	000016a3 	andeq	r1, r0, r3, lsr #13
    143c:	00490405 	subeq	r0, r9, r5, lsl #8
    1440:	6b030000 	blvs	c1448 <__bss_end+0xb71ac>
    1444:	0001af0c 	andeq	sl, r1, ip, lsl #30
    1448:	15e30b00 	strbne	r0, [r3, #2816]!	; 0xb00
    144c:	0b000000 	bleq	1454 <shift+0x1454>
    1450:	00001490 	muleq	r0, r0, r4
    1454:	16070b01 	strne	r0, [r7], -r1, lsl #22
    1458:	0b020000 	bleq	81460 <__bss_end+0x771c4>
    145c:	000014b5 			; <UNDEFINED> instruction: 0x000014b5
    1460:	53060003 	movwpl	r0, #24579	; 0x6003
    1464:	0400000c 	streq	r0, [r0], #-12
    1468:	00711405 	rsbseq	r1, r1, r5, lsl #8
    146c:	03050000 	movweq	r0, #20480	; 0x5000
    1470:	00009f6c 	andeq	r9, r0, ip, ror #30
    1474:	00103c06 	andseq	r3, r0, r6, lsl #24
    1478:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
    147c:	00000071 	andeq	r0, r0, r1, ror r0
    1480:	9f700305 	svcls	0x00700305
    1484:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    1488:	0500000a 	streq	r0, [r0, #-10]
    148c:	00711a07 	rsbseq	r1, r1, r7, lsl #20
    1490:	03050000 	movweq	r0, #20480	; 0x5000
    1494:	00009f74 	andeq	r9, r0, r4, ror pc
    1498:	000e7206 	andeq	r7, lr, r6, lsl #4
    149c:	1a090500 	bne	2428a4 <__bss_end+0x238608>
    14a0:	00000071 	andeq	r0, r0, r1, ror r0
    14a4:	9f780305 	svcls	0x00780305
    14a8:	b1060000 	mrslt	r0, (UNDEF: 6)
    14ac:	0500000a 	streq	r0, [r0, #-10]
    14b0:	00711a0b 	rsbseq	r1, r1, fp, lsl #20
    14b4:	03050000 	movweq	r0, #20480	; 0x5000
    14b8:	00009f7c 	andeq	r9, r0, ip, ror pc
    14bc:	000dfd06 	andeq	pc, sp, r6, lsl #26
    14c0:	1a0d0500 	bne	3428c8 <__bss_end+0x33862c>
    14c4:	00000071 	andeq	r0, r0, r1, ror r0
    14c8:	9f800305 	svcls	0x00800305
    14cc:	c2060000 	andgt	r0, r6, #0
    14d0:	05000006 	streq	r0, [r0, #-6]
    14d4:	00711a0f 	rsbseq	r1, r1, pc, lsl #20
    14d8:	03050000 	movweq	r0, #20480	; 0x5000
    14dc:	00009f84 	andeq	r9, r0, r4, lsl #31
    14e0:	000d0609 	andeq	r0, sp, r9, lsl #12
    14e4:	49040500 	stmdbmi	r4, {r8, sl}
    14e8:	05000000 	streq	r0, [r0, #-0]
    14ec:	02520c1b 	subseq	r0, r2, #6912	; 0x1b00
    14f0:	4e0b0000 	cdpmi	0, 0, cr0, cr11, cr0, {0}
    14f4:	00000006 	andeq	r0, r0, r6
    14f8:	0011650b 	andseq	r6, r1, fp, lsl #10
    14fc:	230b0100 	movwcs	r0, #45312	; 0xb100
    1500:	02000013 	andeq	r0, r0, #19
    1504:	04190c00 	ldreq	r0, [r9], #-3072	; 0xfffff400
    1508:	e10d0000 	mrs	r0, (UNDEF: 13)
    150c:	90000004 	andls	r0, r0, r4
    1510:	c5076305 	strgt	r6, [r7, #-773]	; 0xfffffcfb
    1514:	07000003 	streq	r0, [r0, -r3]
    1518:	0000062a 	andeq	r0, r0, sl, lsr #12
    151c:	10670524 	rsbne	r0, r7, r4, lsr #10
    1520:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1524:	00247d0e 	eoreq	r7, r4, lr, lsl #26
    1528:	12690500 	rsbne	r0, r9, #0, 10
    152c:	000003c5 	andeq	r0, r0, r5, asr #7
    1530:	08970e00 	ldmeq	r7, {r9, sl, fp}
    1534:	6b050000 	blvs	14153c <__bss_end+0x1372a0>
    1538:	0003d512 	andeq	sp, r3, r2, lsl r5
    153c:	430e1000 	movwmi	r1, #57344	; 0xe000
    1540:	05000006 	streq	r0, [r0, #-6]
    1544:	0065166d 	rsbeq	r1, r5, sp, ror #12
    1548:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    154c:	00000e52 	andeq	r0, r0, r2, asr lr
    1550:	dc1c7005 	ldcle	0, cr7, [ip], {5}
    1554:	18000003 	stmdane	r0, {r0, r1}
    1558:	0012e00e 	andseq	lr, r2, lr
    155c:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
    1560:	000003dc 	ldrdeq	r0, [r0], -ip
    1564:	04dc0e1c 	ldrbeq	r0, [ip], #3612	; 0xe1c
    1568:	75050000 	strvc	r0, [r5, #-0]
    156c:	0003dc1c 	andeq	sp, r3, ip, lsl ip
    1570:	e70f2000 	str	r2, [pc, -r0]
    1574:	0500000e 	streq	r0, [r0, #-14]
    1578:	12231c77 	eorne	r1, r3, #30464	; 0x7700
    157c:	03dc0000 	bicseq	r0, ip, #0
    1580:	02d30000 	sbcseq	r0, r3, #0
    1584:	dc100000 	ldcle	0, cr0, [r0], {-0}
    1588:	11000003 	tstne	r0, r3
    158c:	000003e2 	andeq	r0, r0, r2, ror #7
    1590:	18070000 	stmdane	r7, {}	; <UNPREDICTABLE>
    1594:	18000013 	stmdane	r0, {r0, r1, r4}
    1598:	14107b05 	ldrne	r7, [r0], #-2821	; 0xfffff4fb
    159c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    15a0:	0000247d 	andeq	r2, r0, sp, ror r4
    15a4:	c5127e05 	ldrgt	r7, [r2, #-3589]	; 0xfffff1fb
    15a8:	00000003 	andeq	r0, r0, r3
    15ac:	0005360e 	andeq	r3, r5, lr, lsl #12
    15b0:	19800500 	stmibne	r0, {r8, sl}
    15b4:	000003e2 	andeq	r0, r0, r2, ror #7
    15b8:	0a8a0e10 	beq	fe284e00 <__bss_end+0xfe27ab64>
    15bc:	82050000 	andhi	r0, r5, #0
    15c0:	0003ed21 	andeq	lr, r3, r1, lsr #26
    15c4:	03001400 	movweq	r1, #1024	; 0x400
    15c8:	000002df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    15cc:	00048f12 	andeq	r8, r4, r2, lsl pc
    15d0:	21860500 	orrcs	r0, r6, r0, lsl #10
    15d4:	000003f3 	strdeq	r0, [r0], -r3
    15d8:	0008c112 	andeq	ip, r8, r2, lsl r1
    15dc:	1f880500 	svcne	0x00880500
    15e0:	00000071 	andeq	r0, r0, r1, ror r0
    15e4:	000e840e 	andeq	r8, lr, lr, lsl #8
    15e8:	178b0500 	strne	r0, [fp, r0, lsl #10]
    15ec:	00000264 	andeq	r0, r0, r4, ror #4
    15f0:	07f90e00 	ldrbeq	r0, [r9, r0, lsl #28]!
    15f4:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
    15f8:	00026417 	andeq	r6, r2, r7, lsl r4
    15fc:	d70e2400 	strle	r2, [lr, -r0, lsl #8]
    1600:	0500000b 	streq	r0, [r0, #-11]
    1604:	0264178f 	rsbeq	r1, r4, #37486592	; 0x23c0000
    1608:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    160c:	000009e5 	andeq	r0, r0, r5, ror #19
    1610:	64179005 	ldrvs	r9, [r7], #-5
    1614:	6c000002 	stcvs	0, cr0, [r0], {2}
    1618:	0004e113 	andeq	lr, r4, r3, lsl r1
    161c:	09930500 	ldmibeq	r3, {r8, sl}
    1620:	00000dc0 	andeq	r0, r0, r0, asr #27
    1624:	000003fe 	strdeq	r0, [r0], -lr
    1628:	00037e01 	andeq	r7, r3, r1, lsl #28
    162c:	00038400 	andeq	r8, r3, r0, lsl #8
    1630:	03fe1000 	mvnseq	r1, #0
    1634:	14000000 	strne	r0, [r0], #-0
    1638:	00000edc 	ldrdeq	r0, [r0], -ip
    163c:	170e9605 	strne	r9, [lr, -r5, lsl #12]
    1640:	01000005 	tsteq	r0, r5
    1644:	00000399 	muleq	r0, r9, r3
    1648:	0000039f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
    164c:	0003fe10 	andeq	pc, r3, r0, lsl lr	; <UNPREDICTABLE>
    1650:	92150000 	andsls	r0, r5, #0
    1654:	05000008 	streq	r0, [r0, #-8]
    1658:	0ceb1099 	stcleq	0, cr1, [fp], #612	; 0x264
    165c:	04040000 	streq	r0, [r4], #-0
    1660:	b4010000 	strlt	r0, [r1], #-0
    1664:	10000003 	andne	r0, r0, r3
    1668:	000003fe 	strdeq	r0, [r0], -lr
    166c:	0003e211 	andeq	lr, r3, r1, lsl r2
    1670:	022d1100 	eoreq	r1, sp, #0, 2
    1674:	00000000 	andeq	r0, r0, r0
    1678:	00002516 	andeq	r2, r0, r6, lsl r5
    167c:	0003d500 	andeq	sp, r3, r0, lsl #10
    1680:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1684:	000f0000 	andeq	r0, pc, r0
    1688:	72020102 	andvc	r0, r2, #-2147483648	; 0x80000000
    168c:	1800000b 	stmdane	r0, {r0, r1, r3}
    1690:	00026404 	andeq	r6, r2, r4, lsl #8
    1694:	2c041800 	stccs	8, cr1, [r4], {-0}
    1698:	0c000000 	stceq	0, cr0, [r0], {-0}
    169c:	000011f8 	strdeq	r1, [r0], -r8
    16a0:	03e80418 	mvneq	r0, #24, 8	; 0x18000000
    16a4:	14160000 	ldrne	r0, [r6], #-0
    16a8:	fe000003 	cdp2	0, 0, cr0, cr0, cr3, {0}
    16ac:	19000003 	stmdbne	r0, {r0, r1}
    16b0:	57041800 	strpl	r1, [r4, -r0, lsl #16]
    16b4:	18000002 	stmdane	r0, {r1}
    16b8:	00025204 	andeq	r5, r2, r4, lsl #4
    16bc:	0ed01a00 	vfnmseq.f32	s3, s0, s0
    16c0:	9c050000 	stcls	0, cr0, [r5], {-0}
    16c4:	00025714 	andeq	r5, r2, r4, lsl r7
    16c8:	06580600 	ldrbeq	r0, [r8], -r0, lsl #12
    16cc:	04060000 	streq	r0, [r6], #-0
    16d0:	00007114 	andeq	r7, r0, r4, lsl r1
    16d4:	88030500 	stmdahi	r3, {r8, sl}
    16d8:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    16dc:	00000f43 	andeq	r0, r0, r3, asr #30
    16e0:	71140706 	tstvc	r4, r6, lsl #14
    16e4:	05000000 	streq	r0, [r0, #-0]
    16e8:	009f8c03 	addseq	r8, pc, r3, lsl #24
    16ec:	05040600 	streq	r0, [r4, #-1536]	; 0xfffffa00
    16f0:	0a060000 	beq	1816f8 <__bss_end+0x17745c>
    16f4:	00007114 	andeq	r7, r0, r4, lsl r1
    16f8:	90030500 	andls	r0, r3, r0, lsl #10
    16fc:	0900009f 	stmdbeq	r0, {r0, r1, r2, r3, r4, r7}
    1700:	0000078c 	andeq	r0, r0, ip, lsl #15
    1704:	00490405 	subeq	r0, r9, r5, lsl #8
    1708:	0d060000 	stceq	0, cr0, [r6, #-0]
    170c:	0004830c 	andeq	r8, r4, ip, lsl #6
    1710:	654e0a00 	strbvs	r0, [lr, #-2560]	; 0xfffff600
    1714:	0b000077 	bleq	18f8 <shift+0x18f8>
    1718:	00000975 	andeq	r0, r0, r5, ror r9
    171c:	04fc0b01 	ldrbteq	r0, [ip], #2817	; 0xb01
    1720:	0b020000 	bleq	81728 <__bss_end+0x7748c>
    1724:	000007c7 	andeq	r0, r0, r7, asr #15
    1728:	10eb0b03 	rscne	r0, fp, r3, lsl #22
    172c:	0b040000 	bleq	101734 <__bss_end+0xf7498>
    1730:	000004d5 	ldrdeq	r0, [r0], -r5
    1734:	71070005 	tstvc	r7, r5
    1738:	10000006 	andne	r0, r0, r6
    173c:	c2081b06 	andgt	r1, r8, #6144	; 0x1800
    1740:	08000004 	stmdaeq	r0, {r2}
    1744:	0600726c 	streq	r7, [r0], -ip, ror #4
    1748:	04c2131d 	strbeq	r1, [r2], #797	; 0x31d
    174c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1750:	06007073 			; <UNDEFINED> instruction: 0x06007073
    1754:	04c2131e 	strbeq	r1, [r2], #798	; 0x31e
    1758:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    175c:	06006370 			; <UNDEFINED> instruction: 0x06006370
    1760:	04c2131f 	strbeq	r1, [r2], #799	; 0x31f
    1764:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1768:	00000ef2 	strdeq	r0, [r0], -r2
    176c:	c2132006 	andsgt	r2, r3, #6
    1770:	0c000004 	stceq	0, cr0, [r0], {4}
    1774:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1778:	0000079d 	muleq	r0, sp, r7
    177c:	00094107 	andeq	r4, r9, r7, lsl #2
    1780:	28067000 	stmdacs	r6, {ip, sp, lr}
    1784:	00055908 	andeq	r5, r5, r8, lsl #18
    1788:	08410e00 	stmdaeq	r1, {r9, sl, fp}^
    178c:	2a060000 	bcs	181794 <__bss_end+0x1774f8>
    1790:	00048312 	andeq	r8, r4, r2, lsl r3
    1794:	70080000 	andvc	r0, r8, r0
    1798:	06006469 	streq	r6, [r0], -r9, ror #8
    179c:	0076122b 	rsbseq	r1, r6, fp, lsr #4
    17a0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    17a4:	00001e70 	andeq	r1, r0, r0, ror lr
    17a8:	4c112c06 	ldcmi	12, cr2, [r1], {6}
    17ac:	14000004 	strne	r0, [r0], #-4
    17b0:	0010cf0e 	andseq	ip, r0, lr, lsl #30
    17b4:	122d0600 	eorne	r0, sp, #0, 12
    17b8:	00000076 	andeq	r0, r0, r6, ror r0
    17bc:	03a90e18 			; <UNDEFINED> instruction: 0x03a90e18
    17c0:	2e060000 	cdpcs	0, 0, cr0, cr6, cr0, {0}
    17c4:	00007612 	andeq	r7, r0, r2, lsl r6
    17c8:	300e1c00 	andcc	r1, lr, r0, lsl #24
    17cc:	0600000f 	streq	r0, [r0], -pc
    17d0:	05590c2f 	ldrbeq	r0, [r9, #-3119]	; 0xfffff3d1
    17d4:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    17d8:	00000485 	andeq	r0, r0, r5, lsl #9
    17dc:	49093006 	stmdbmi	r9, {r1, r2, ip, sp}
    17e0:	60000000 	andvs	r0, r0, r0
    17e4:	000b310e 	andeq	r3, fp, lr, lsl #2
    17e8:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    17ec:	00000065 	andeq	r0, r0, r5, rrx
    17f0:	0d940e64 	ldceq	14, cr0, [r4, #400]	; 0x190
    17f4:	33060000 	movwcc	r0, #24576	; 0x6000
    17f8:	0000650e 	andeq	r6, r0, lr, lsl #10
    17fc:	8b0e6800 	blhi	39b804 <__bss_end+0x391568>
    1800:	0600000d 	streq	r0, [r0], -sp
    1804:	00650e34 	rsbeq	r0, r5, r4, lsr lr
    1808:	006c0000 	rsbeq	r0, ip, r0
    180c:	00040416 	andeq	r0, r4, r6, lsl r4
    1810:	00056900 	andeq	r6, r5, r0, lsl #18
    1814:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1818:	000f0000 	andeq	r0, pc, r0
    181c:	0004ed06 	andeq	lr, r4, r6, lsl #26
    1820:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
    1824:	00000071 	andeq	r0, r0, r1, ror r0
    1828:	9f940305 	svcls	0x00940305
    182c:	1c090000 	stcne	0, cr0, [r9], {-0}
    1830:	0500000b 	streq	r0, [r0, #-11]
    1834:	00004904 	andeq	r4, r0, r4, lsl #18
    1838:	0c0d0700 	stceq	7, cr0, [sp], {-0}
    183c:	0000059a 	muleq	r0, sl, r5
    1840:	0013370b 	andseq	r3, r3, fp, lsl #14
    1844:	9a0b0000 	bls	2c184c <__bss_end+0x2b75b0>
    1848:	01000011 	tsteq	r0, r1, lsl r0
    184c:	057b0300 	ldrbeq	r0, [fp, #-768]!	; 0xfffffd00
    1850:	5a090000 	bpl	241858 <__bss_end+0x2375bc>
    1854:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1858:	00004904 	andeq	r4, r0, r4, lsl #18
    185c:	0c140700 	ldceq	7, cr0, [r4], {-0}
    1860:	000005be 			; <UNDEFINED> instruction: 0x000005be
    1864:	0013c80b 	andseq	ip, r3, fp, lsl #16
    1868:	f90b0000 			; <UNDEFINED> instruction: 0xf90b0000
    186c:	01000015 	tsteq	r0, r5, lsl r0
    1870:	059f0300 	ldreq	r0, [pc, #768]	; 1b78 <shift+0x1b78>
    1874:	26070000 	strcs	r0, [r7], -r0
    1878:	0c000008 	stceq	0, cr0, [r0], {8}
    187c:	f8081b07 			; <UNDEFINED> instruction: 0xf8081b07
    1880:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1884:	0000058a 	andeq	r0, r0, sl, lsl #11
    1888:	f8191d07 			; <UNDEFINED> instruction: 0xf8191d07
    188c:	00000005 	andeq	r0, r0, r5
    1890:	0004dc0e 	andeq	sp, r4, lr, lsl #24
    1894:	191e0700 	ldmdbne	lr, {r8, r9, sl}
    1898:	000005f8 	strdeq	r0, [r0], -r8
    189c:	0b4c0e04 	bleq	13050b4 <__bss_end+0x12fae18>
    18a0:	1f070000 	svcne	0x00070000
    18a4:	0005fe13 	andeq	pc, r5, r3, lsl lr	; <UNPREDICTABLE>
    18a8:	18000800 	stmdane	r0, {fp}
    18ac:	0005c304 	andeq	ip, r5, r4, lsl #6
    18b0:	c9041800 	stmdbgt	r4, {fp, ip}
    18b4:	0d000004 	stceq	0, cr0, [r0, #-16]
    18b8:	00000e93 	muleq	r0, r3, lr
    18bc:	07220714 			; <UNDEFINED> instruction: 0x07220714
    18c0:	00000886 	andeq	r0, r0, r6, lsl #17
    18c4:	000c610e 	andeq	r6, ip, lr, lsl #2
    18c8:	12260700 	eorne	r0, r6, #0, 14
    18cc:	00000065 	andeq	r0, r0, r5, rrx
    18d0:	0bf40e00 	bleq	ffd050d8 <__bss_end+0xffcfae3c>
    18d4:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
    18d8:	0005f81d 	andeq	pc, r5, sp, lsl r8	; <UNPREDICTABLE>
    18dc:	cf0e0400 	svcgt	0x000e0400
    18e0:	07000007 	streq	r0, [r0, -r7]
    18e4:	05f81d2c 	ldrbeq	r1, [r8, #3372]!	; 0xd2c
    18e8:	1b080000 	blne	2018f0 <__bss_end+0x1f7654>
    18ec:	00000d16 	andeq	r0, r0, r6, lsl sp
    18f0:	030e2f07 	movweq	r2, #61191	; 0xef07
    18f4:	4c000008 	stcmi	0, cr0, [r0], {8}
    18f8:	57000006 	strpl	r0, [r0, -r6]
    18fc:	10000006 	andne	r0, r0, r6
    1900:	0000088b 	andeq	r0, r0, fp, lsl #17
    1904:	0005f811 	andeq	pc, r5, r1, lsl r8	; <UNPREDICTABLE>
    1908:	7e1c0000 	cdpvc	0, 1, cr0, cr12, cr0, {0}
    190c:	07000009 	streq	r0, [r0, -r9]
    1910:	09180e31 	ldmdbeq	r8, {r0, r4, r5, r9, sl, fp}
    1914:	03d50000 	bicseq	r0, r5, #0
    1918:	066f0000 	strbteq	r0, [pc], -r0
    191c:	067a0000 	ldrbteq	r0, [sl], -r0
    1920:	8b100000 	blhi	401928 <__bss_end+0x3f768c>
    1924:	11000008 	tstne	r0, r8
    1928:	000005fe 	strdeq	r0, [r0], -lr
    192c:	11461300 	mrsne	r1, SPSR_und
    1930:	35070000 	strcc	r0, [r7, #-0]
    1934:	0006cc1d 	andeq	ip, r6, sp, lsl ip
    1938:	0005f800 	andeq	pc, r5, r0, lsl #16
    193c:	06930200 	ldreq	r0, [r3], r0, lsl #4
    1940:	06990000 	ldreq	r0, [r9], r0
    1944:	8b100000 	blhi	40194c <__bss_end+0x3f76b0>
    1948:	00000008 	andeq	r0, r0, r8
    194c:	0007af13 	andeq	sl, r7, r3, lsl pc
    1950:	1d370700 	ldcne	7, cr0, [r7, #-0]
    1954:	00000d26 	andeq	r0, r0, r6, lsr #26
    1958:	000005f8 	strdeq	r0, [r0], -r8
    195c:	0006b202 	andeq	fp, r6, r2, lsl #4
    1960:	0006b800 	andeq	fp, r6, r0, lsl #16
    1964:	088b1000 	stmeq	fp, {ip}
    1968:	1d000000 	stcne	0, cr0, [r0, #-0]
    196c:	00000c07 	andeq	r0, r0, r7, lsl #24
    1970:	a4313907 	ldrtge	r3, [r1], #-2311	; 0xfffff6f9
    1974:	0c000008 	stceq	0, cr0, [r0], {8}
    1978:	0e931302 	cdpeq	3, 9, cr1, cr3, cr2, {0}
    197c:	3c070000 	stccc	0, cr0, [r7], {-0}
    1980:	00098d09 	andeq	r8, r9, r9, lsl #26
    1984:	00088b00 	andeq	r8, r8, r0, lsl #22
    1988:	06df0100 	ldrbeq	r0, [pc], r0, lsl #2
    198c:	06e50000 	strbteq	r0, [r5], r0
    1990:	8b100000 	blhi	401998 <__bss_end+0x3f76fc>
    1994:	00000008 	andeq	r0, r0, r8
    1998:	00085313 	andeq	r5, r8, r3, lsl r3
    199c:	123f0700 	eorsne	r0, pc, #0, 14
    19a0:	0000055f 	andeq	r0, r0, pc, asr r5
    19a4:	00000065 	andeq	r0, r0, r5, rrx
    19a8:	0006fe01 	andeq	pc, r6, r1, lsl #28
    19ac:	00071300 	andeq	r1, r7, r0, lsl #6
    19b0:	088b1000 	stmeq	fp, {ip}
    19b4:	ad110000 	ldcge	0, cr0, [r1, #-0]
    19b8:	11000008 	tstne	r0, r8
    19bc:	00000076 	andeq	r0, r0, r6, ror r0
    19c0:	0003d511 	andeq	sp, r3, r1, lsl r5
    19c4:	70140000 	andsvc	r0, r4, r0
    19c8:	07000011 	smladeq	r0, r1, r0, r0
    19cc:	067e0e42 	ldrbteq	r0, [lr], -r2, asr #28
    19d0:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
    19d4:	2e000007 	cdpcs	0, 0, cr0, cr0, cr7, {0}
    19d8:	10000007 	andne	r0, r0, r7
    19dc:	0000088b 	andeq	r0, r0, fp, lsl #17
    19e0:	05411300 	strbeq	r1, [r1, #-768]	; 0xfffffd00
    19e4:	45070000 	strmi	r0, [r7, #-0]
    19e8:	0005fc17 	andeq	pc, r5, r7, lsl ip	; <UNPREDICTABLE>
    19ec:	0005fe00 	andeq	pc, r5, r0, lsl #28
    19f0:	07470100 	strbeq	r0, [r7, -r0, lsl #2]
    19f4:	074d0000 	strbeq	r0, [sp, -r0]
    19f8:	b3100000 	tstlt	r0, #0
    19fc:	00000008 	andeq	r0, r0, r8
    1a00:	000f4e13 	andeq	r4, pc, r3, lsl lr	; <UNPREDICTABLE>
    1a04:	17480700 	strbne	r0, [r8, -r0, lsl #14]
    1a08:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
    1a0c:	000005fe 	strdeq	r0, [r0], -lr
    1a10:	00076601 	andeq	r6, r7, r1, lsl #12
    1a14:	00077100 	andeq	r7, r7, r0, lsl #2
    1a18:	08b31000 	ldmeq	r3!, {ip}
    1a1c:	65110000 	ldrvs	r0, [r1, #-0]
    1a20:	00000000 	andeq	r0, r0, r0
    1a24:	0006f114 	andeq	pc, r6, r4, lsl r1	; <UNPREDICTABLE>
    1a28:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
    1a2c:	00000c15 	andeq	r0, r0, r5, lsl ip
    1a30:	00078601 	andeq	r8, r7, r1, lsl #12
    1a34:	00078c00 	andeq	r8, r7, r0, lsl #24
    1a38:	088b1000 	stmeq	fp, {ip}
    1a3c:	13000000 	movwne	r0, #0
    1a40:	0000097e 	andeq	r0, r0, lr, ror r9
    1a44:	d50e4d07 	strle	r4, [lr, #-3335]	; 0xfffff2f9
    1a48:	d500000d 	strle	r0, [r0, #-13]
    1a4c:	01000003 	tsteq	r0, r3
    1a50:	000007a5 	andeq	r0, r0, r5, lsr #15
    1a54:	000007b0 			; <UNDEFINED> instruction: 0x000007b0
    1a58:	00088b10 	andeq	r8, r8, r0, lsl fp
    1a5c:	00651100 	rsbeq	r1, r5, r0, lsl #2
    1a60:	13000000 	movwne	r0, #0
    1a64:	000004c1 	andeq	r0, r0, r1, asr #9
    1a68:	ec125007 	ldc	0, cr5, [r2], {7}
    1a6c:	65000003 	strvs	r0, [r0, #-3]
    1a70:	01000000 	mrseq	r0, (UNDEF: 0)
    1a74:	000007c9 	andeq	r0, r0, r9, asr #15
    1a78:	000007d4 	ldrdeq	r0, [r0], -r4
    1a7c:	00088b10 	andeq	r8, r8, r0, lsl fp
    1a80:	04041100 	streq	r1, [r4], #-256	; 0xffffff00
    1a84:	13000000 	movwne	r0, #0
    1a88:	0000041f 	andeq	r0, r0, pc, lsl r4
    1a8c:	c60e5307 	strgt	r5, [lr], -r7, lsl #6
    1a90:	d5000011 	strle	r0, [r0, #-17]	; 0xffffffef
    1a94:	01000003 	tsteq	r0, r3
    1a98:	000007ed 	andeq	r0, r0, sp, ror #15
    1a9c:	000007f8 	strdeq	r0, [r0], -r8
    1aa0:	00088b10 	andeq	r8, r8, r0, lsl fp
    1aa4:	00651100 	rsbeq	r1, r5, r0, lsl #2
    1aa8:	14000000 	strne	r0, [r0], #-0
    1aac:	0000049b 	muleq	r0, fp, r4
    1ab0:	480e5607 	stmdami	lr, {r0, r1, r2, r9, sl, ip, lr}
    1ab4:	01000010 	tsteq	r0, r0, lsl r0
    1ab8:	0000080d 	andeq	r0, r0, sp, lsl #16
    1abc:	0000082c 	andeq	r0, r0, ip, lsr #16
    1ac0:	00088b10 	andeq	r8, r8, r0, lsl fp
    1ac4:	01101100 	tsteq	r0, r0, lsl #2
    1ac8:	65110000 	ldrvs	r0, [r1, #-0]
    1acc:	11000000 	mrsne	r0, (UNDEF: 0)
    1ad0:	00000065 	andeq	r0, r0, r5, rrx
    1ad4:	00006511 	andeq	r6, r0, r1, lsl r5
    1ad8:	08b91100 	ldmeq	r9!, {r8, ip}
    1adc:	14000000 	strne	r0, [r0], #-0
    1ae0:	00001253 	andeq	r1, r0, r3, asr r2
    1ae4:	4c0e5807 	stcmi	8, cr5, [lr], {7}
    1ae8:	01000013 	tsteq	r0, r3, lsl r0
    1aec:	00000841 	andeq	r0, r0, r1, asr #16
    1af0:	00000860 	andeq	r0, r0, r0, ror #16
    1af4:	00088b10 	andeq	r8, r8, r0, lsl fp
    1af8:	01471100 	mrseq	r1, (UNDEF: 87)
    1afc:	65110000 	ldrvs	r0, [r1, #-0]
    1b00:	11000000 	mrsne	r0, (UNDEF: 0)
    1b04:	00000065 	andeq	r0, r0, r5, rrx
    1b08:	00006511 	andeq	r6, r0, r1, lsl r5
    1b0c:	08b91100 	ldmeq	r9!, {r8, ip}
    1b10:	15000000 	strne	r0, [r0, #-0]
    1b14:	000004ae 	andeq	r0, r0, lr, lsr #9
    1b18:	770e5b07 	strvc	r5, [lr, -r7, lsl #22]
    1b1c:	d500000b 	strle	r0, [r0, #-11]
    1b20:	01000003 	tsteq	r0, r3
    1b24:	00000875 	andeq	r0, r0, r5, ror r8
    1b28:	00088b10 	andeq	r8, r8, r0, lsl fp
    1b2c:	057b1100 	ldrbeq	r1, [fp, #-256]!	; 0xffffff00
    1b30:	bf110000 	svclt	0x00110000
    1b34:	00000008 	andeq	r0, r0, r8
    1b38:	06040300 	streq	r0, [r4], -r0, lsl #6
    1b3c:	04180000 	ldreq	r0, [r8], #-0
    1b40:	00000604 	andeq	r0, r0, r4, lsl #12
    1b44:	0005f81e 	andeq	pc, r5, lr, lsl r8	; <UNPREDICTABLE>
    1b48:	00089e00 	andeq	r9, r8, r0, lsl #28
    1b4c:	0008a400 	andeq	sl, r8, r0, lsl #8
    1b50:	088b1000 	stmeq	fp, {ip}
    1b54:	1f000000 	svcne	0x00000000
    1b58:	00000604 	andeq	r0, r0, r4, lsl #12
    1b5c:	00000891 	muleq	r0, r1, r8
    1b60:	00570418 	subseq	r0, r7, r8, lsl r4
    1b64:	04180000 	ldreq	r0, [r8], #-0
    1b68:	00000886 	andeq	r0, r0, r6, lsl #17
    1b6c:	00cc0420 	sbceq	r0, ip, r0, lsr #8
    1b70:	04210000 	strteq	r0, [r1], #-0
    1b74:	0012b51a 	andseq	fp, r2, sl, lsl r5
    1b78:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
    1b7c:	00000604 	andeq	r0, r0, r4, lsl #12
    1b80:	00132e06 	andseq	r2, r3, r6, lsl #28
    1b84:	11040800 	tstne	r4, r0, lsl #16
    1b88:	000008e6 	andeq	r0, r0, r6, ror #17
    1b8c:	9f980305 	svcls	0x00980305
    1b90:	04020000 	streq	r0, [r2], #-0
    1b94:	001eee04 	andseq	lr, lr, r4, lsl #28
    1b98:	08df0300 	ldmeq	pc, {r8, r9}^	; <UNPREDICTABLE>
    1b9c:	2c160000 	ldccs	0, cr0, [r6], {-0}
    1ba0:	fb000000 	blx	1baa <shift+0x1baa>
    1ba4:	17000008 	strne	r0, [r0, -r8]
    1ba8:	00000076 	andeq	r0, r0, r6, ror r0
    1bac:	eb030009 	bl	c1bd8 <__bss_end+0xb793c>
    1bb0:	22000008 	andcs	r0, r0, #8
    1bb4:	0000147f 	andeq	r1, r0, pc, ror r4
    1bb8:	fb0ca401 	blx	32abc6 <__bss_end+0x32092a>
    1bbc:	05000008 	streq	r0, [r0, #-8]
    1bc0:	009f9c03 	addseq	r9, pc, r3, lsl #24
    1bc4:	13e12300 	mvnne	r2, #0, 6
    1bc8:	a6010000 	strge	r0, [r1], -r0
    1bcc:	00154e0a 	andseq	r4, r5, sl, lsl #28
    1bd0:	00006500 	andeq	r6, r0, r0, lsl #10
    1bd4:	0086e400 	addeq	lr, r6, r0, lsl #8
    1bd8:	0000b000 	andeq	fp, r0, r0
    1bdc:	709c0100 	addsvc	r0, ip, r0, lsl #2
    1be0:	24000009 	strcs	r0, [r0], #-9
    1be4:	0000247d 	andeq	r2, r0, sp, ror r4
    1be8:	e21ba601 	ands	sl, fp, #1048576	; 0x100000
    1bec:	03000003 	movweq	r0, #3
    1bf0:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 1bf8 <shift+0x1bf8>
    1bf4:	000015da 	ldrdeq	r1, [r0], -sl
    1bf8:	652aa601 	strvs	sl, [sl, #-1537]!	; 0xfffff9ff
    1bfc:	03000000 	movweq	r0, #0
    1c00:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    1c04:	00001536 	andeq	r1, r0, r6, lsr r5
    1c08:	700aa801 	andvc	sl, sl, r1, lsl #16
    1c0c:	03000009 	movweq	r0, #9
    1c10:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1c14:	000013dc 	ldrdeq	r1, [r0], -ip
    1c18:	4909ac01 	stmdbmi	r9, {r0, sl, fp, sp, pc}
    1c1c:	02000000 	andeq	r0, r0, #0
    1c20:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1c24:	00000025 	andeq	r0, r0, r5, lsr #32
    1c28:	00000980 	andeq	r0, r0, r0, lsl #19
    1c2c:	00007617 	andeq	r7, r0, r7, lsl r6
    1c30:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1c34:	000015b9 			; <UNDEFINED> instruction: 0x000015b9
    1c38:	1e0a9801 	cdpne	8, 0, cr9, cr10, cr1, {0}
    1c3c:	65000016 	strvs	r0, [r0, #-22]	; 0xffffffea
    1c40:	a8000000 	stmdage	r0, {}	; <UNPREDICTABLE>
    1c44:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1c48:	01000000 	mrseq	r0, (UNDEF: 0)
    1c4c:	0009bd9c 	muleq	r9, ip, sp
    1c50:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1c54:	9a010071 	bls	41e20 <__bss_end+0x37b84>
    1c58:	0005be20 	andeq	fp, r5, r0, lsr #28
    1c5c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c60:	00154322 	andseq	r4, r5, r2, lsr #6
    1c64:	0e9b0100 	fmleqe	f0, f3, f0
    1c68:	00000065 	andeq	r0, r0, r5, rrx
    1c6c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1c70:	0014cd27 	andseq	ip, r4, r7, lsr #26
    1c74:	068f0100 	streq	r0, [pc], r0, lsl #2
    1c78:	00001409 	andeq	r1, r0, r9, lsl #8
    1c7c:	0000866c 	andeq	r8, r0, ip, ror #12
    1c80:	0000003c 	andeq	r0, r0, ip, lsr r0
    1c84:	09f69c01 	ldmibeq	r6!, {r0, sl, fp, ip, pc}^
    1c88:	6b240000 	blvs	901c90 <__bss_end+0x8f79f4>
    1c8c:	01000014 	tsteq	r0, r4, lsl r0
    1c90:	0065218f 	rsbeq	r2, r5, pc, lsl #3
    1c94:	91020000 	mrsls	r0, (UNDEF: 2)
    1c98:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1c9c:	91010071 	tstls	r1, r1, ror r0
    1ca0:	0005be20 	andeq	fp, r5, r0, lsr #28
    1ca4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ca8:	156f2500 	strbne	r2, [pc, #-1280]!	; 17b0 <shift+0x17b0>
    1cac:	83010000 	movwhi	r0, #4096	; 0x1000
    1cb0:	00149b0a 	andseq	r9, r4, sl, lsl #22
    1cb4:	00006500 	andeq	r6, r0, r0, lsl #10
    1cb8:	00863000 	addeq	r3, r6, r0
    1cbc:	00003c00 	andeq	r3, r0, r0, lsl #24
    1cc0:	339c0100 	orrscc	r0, ip, #0, 2
    1cc4:	2600000a 	strcs	r0, [r0], -sl
    1cc8:	00716572 	rsbseq	r6, r1, r2, ror r5
    1ccc:	9a208501 	bls	8230d8 <__bss_end+0x818e3c>
    1cd0:	02000005 	andeq	r0, r0, #5
    1cd4:	d5227491 	strle	r7, [r2, #-1169]!	; 0xfffffb6f
    1cd8:	01000013 	tsteq	r0, r3, lsl r0
    1cdc:	00650e86 	rsbeq	r0, r5, r6, lsl #29
    1ce0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce4:	bc250070 	stclt	0, cr0, [r5], #-448	; 0xfffffe40
    1ce8:	01000016 	tsteq	r0, r6, lsl r0
    1cec:	144d0a77 	strbne	r0, [sp], #-2679	; 0xfffff589
    1cf0:	00650000 	rsbeq	r0, r5, r0
    1cf4:	85f40000 	ldrbhi	r0, [r4, #0]!
    1cf8:	003c0000 	eorseq	r0, ip, r0
    1cfc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d00:	00000a70 	andeq	r0, r0, r0, ror sl
    1d04:	71657226 	cmnvc	r5, r6, lsr #4
    1d08:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1d0c:	0000059a 	muleq	r0, sl, r5
    1d10:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1d14:	000013d5 	ldrdeq	r1, [r0], -r5
    1d18:	650e7a01 	strvs	r7, [lr, #-2561]	; 0xfffff5ff
    1d1c:	02000000 	andeq	r0, r0, #0
    1d20:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1d24:	000014af 	andeq	r1, r0, pc, lsr #9
    1d28:	ee066b01 	vmla.f64	d6, d6, d1
    1d2c:	d5000015 	strle	r0, [r0, #-21]	; 0xffffffeb
    1d30:	a0000003 	andge	r0, r0, r3
    1d34:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
    1d38:	01000000 	mrseq	r0, (UNDEF: 0)
    1d3c:	000abc9c 	muleq	sl, ip, ip
    1d40:	15432400 	strbne	r2, [r3, #-1024]	; 0xfffffc00
    1d44:	6b010000 	blvs	41d4c <__bss_end+0x37ab0>
    1d48:	00006515 	andeq	r6, r0, r5, lsl r5
    1d4c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d50:	000d8b24 	andeq	r8, sp, r4, lsr #22
    1d54:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1d58:	00000065 	andeq	r0, r0, r5, rrx
    1d5c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1d60:	000016b4 			; <UNDEFINED> instruction: 0x000016b4
    1d64:	650e6d01 	strvs	r6, [lr, #-3329]	; 0xfffff2ff
    1d68:	02000000 	andeq	r0, r0, #0
    1d6c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1d70:	00001420 	andeq	r1, r0, r0, lsr #8
    1d74:	55125e01 	ldrpl	r5, [r2, #-3585]	; 0xfffff1ff
    1d78:	f2000016 	vqadd.s8	d0, d0, d6
    1d7c:	50000000 	andpl	r0, r0, r0
    1d80:	50000085 	andpl	r0, r0, r5, lsl #1
    1d84:	01000000 	mrseq	r0, (UNDEF: 0)
    1d88:	000b179c 	muleq	fp, ip, r7
    1d8c:	13bd2400 			; <UNDEFINED> instruction: 0x13bd2400
    1d90:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1d94:	00006520 	andeq	r6, r0, r0, lsr #10
    1d98:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d9c:	00157824 	andseq	r7, r5, r4, lsr #16
    1da0:	2f5e0100 	svccs	0x005e0100
    1da4:	00000065 	andeq	r0, r0, r5, rrx
    1da8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1dac:	00000d8b 	andeq	r0, r0, fp, lsl #27
    1db0:	653f5e01 	ldrvs	r5, [pc, #-3585]!	; fb7 <shift+0xfb7>
    1db4:	02000000 	andeq	r0, r0, #0
    1db8:	b4226491 	strtlt	r6, [r2], #-1169	; 0xfffffb6f
    1dbc:	01000016 	tsteq	r0, r6, lsl r0
    1dc0:	00f21660 	rscseq	r1, r2, r0, ror #12
    1dc4:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc8:	3c250074 	stccc	0, cr0, [r5], #-464	; 0xfffffe30
    1dcc:	01000015 	tsteq	r0, r5, lsl r0
    1dd0:	14250a52 	strtne	r0, [r5], #-2642	; 0xfffff5ae
    1dd4:	00650000 	rsbeq	r0, r5, r0
    1dd8:	850c0000 	strhi	r0, [ip, #-0]
    1ddc:	00440000 	subeq	r0, r4, r0
    1de0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1de4:	00000b63 	andeq	r0, r0, r3, ror #22
    1de8:	0013bd24 	andseq	fp, r3, r4, lsr #26
    1dec:	1a520100 	bne	14821f4 <__bss_end+0x1477f58>
    1df0:	00000065 	andeq	r0, r0, r5, rrx
    1df4:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1df8:	00001578 	andeq	r1, r0, r8, ror r5
    1dfc:	65295201 	strvs	r5, [r9, #-513]!	; 0xfffffdff
    1e00:	02000000 	andeq	r0, r0, #0
    1e04:	84226891 	strthi	r6, [r2], #-2193	; 0xfffff76f
    1e08:	01000016 	tsteq	r0, r6, lsl r0
    1e0c:	00650e54 	rsbeq	r0, r5, r4, asr lr
    1e10:	91020000 	mrsls	r0, (UNDEF: 2)
    1e14:	7e250074 	mcrvc	0, 1, r0, cr5, cr4, {3}
    1e18:	01000016 	tsteq	r0, r6, lsl r0
    1e1c:	16600a45 	strbtne	r0, [r0], -r5, asr #20
    1e20:	00650000 	rsbeq	r0, r5, r0
    1e24:	84bc0000 	ldrthi	r0, [ip], #0
    1e28:	00500000 	subseq	r0, r0, r0
    1e2c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e30:	00000bbe 			; <UNDEFINED> instruction: 0x00000bbe
    1e34:	0013bd24 	andseq	fp, r3, r4, lsr #26
    1e38:	19450100 	stmdbne	r5, {r8}^
    1e3c:	00000065 	andeq	r0, r0, r5, rrx
    1e40:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1e44:	000014df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1e48:	84304501 	ldrthi	r4, [r0], #-1281	; 0xfffffaff
    1e4c:	02000001 	andeq	r0, r0, #1
    1e50:	a5246891 	strge	r6, [r4, #-2193]!	; 0xfffff76f
    1e54:	01000015 	tsteq	r0, r5, lsl r0
    1e58:	08bf4145 	ldmeq	pc!, {r0, r2, r6, r8, lr}	; <UNPREDICTABLE>
    1e5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e60:	16b42264 	ldrtne	r2, [r4], r4, ror #4
    1e64:	47010000 	strmi	r0, [r1, -r0]
    1e68:	0000650e 	andeq	r6, r0, lr, lsl #10
    1e6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e70:	13c22700 	bicne	r2, r2, #0, 14
    1e74:	3f010000 	svccc	0x00010000
    1e78:	0014e906 	andseq	lr, r4, r6, lsl #18
    1e7c:	00849000 	addeq	r9, r4, r0
    1e80:	00002c00 	andeq	r2, r0, r0, lsl #24
    1e84:	e89c0100 	ldm	ip, {r8}
    1e88:	2400000b 	strcs	r0, [r0], #-11
    1e8c:	000013bd 			; <UNDEFINED> instruction: 0x000013bd
    1e90:	65153f01 	ldrvs	r3, [r5, #-3841]	; 0xfffff0ff
    1e94:	02000000 	andeq	r0, r0, #0
    1e98:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1e9c:	000015d4 	ldrdeq	r1, [r0], -r4
    1ea0:	ab0a3201 	blge	28e6ac <__bss_end+0x284410>
    1ea4:	65000015 	strvs	r0, [r0, #-21]	; 0xffffffeb
    1ea8:	40000000 	andmi	r0, r0, r0
    1eac:	50000084 	andpl	r0, r0, r4, lsl #1
    1eb0:	01000000 	mrseq	r0, (UNDEF: 0)
    1eb4:	000c439c 	muleq	ip, ip, r3
    1eb8:	13bd2400 			; <UNDEFINED> instruction: 0x13bd2400
    1ebc:	32010000 	andcc	r0, r1, #0
    1ec0:	00006519 	andeq	r6, r0, r9, lsl r5
    1ec4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ec8:	00169024 	andseq	r9, r6, r4, lsr #32
    1ecc:	2b320100 	blcs	c822d4 <__bss_end+0xc78038>
    1ed0:	000003e2 	andeq	r0, r0, r2, ror #7
    1ed4:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1ed8:	000015de 	ldrdeq	r1, [r0], -lr
    1edc:	653c3201 	ldrvs	r3, [ip, #-513]!	; 0xfffffdff
    1ee0:	02000000 	andeq	r0, r0, #0
    1ee4:	4f226491 	svcmi	0x00226491
    1ee8:	01000016 	tsteq	r0, r6, lsl r0
    1eec:	00650e34 	rsbeq	r0, r5, r4, lsr lr
    1ef0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ef4:	de250074 	mcrle	0, 1, r0, cr5, cr4, {3}
    1ef8:	01000016 	tsteq	r0, r6, lsl r0
    1efc:	16970a25 	ldrne	r0, [r7], r5, lsr #20
    1f00:	00650000 	rsbeq	r0, r5, r0
    1f04:	83f00000 	mvnshi	r0, #0
    1f08:	00500000 	subseq	r0, r0, r0
    1f0c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f10:	00000c9e 	muleq	r0, lr, ip
    1f14:	0013bd24 	andseq	fp, r3, r4, lsr #26
    1f18:	18250100 	stmdane	r5!, {r8}
    1f1c:	00000065 	andeq	r0, r0, r5, rrx
    1f20:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1f24:	00001690 	muleq	r0, r0, r6
    1f28:	a42a2501 	strtge	r2, [sl], #-1281	; 0xfffffaff
    1f2c:	0200000c 	andeq	r0, r0, #12
    1f30:	de246891 	mcrle	8, 1, r6, cr4, cr1, {4}
    1f34:	01000015 	tsteq	r0, r5, lsl r0
    1f38:	00653b25 	rsbeq	r3, r5, r5, lsr #22
    1f3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1f40:	13f22264 	mvnsne	r2, #100, 4	; 0x40000006
    1f44:	27010000 	strcs	r0, [r1, -r0]
    1f48:	0000650e 	andeq	r6, r0, lr, lsl #10
    1f4c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f50:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1f54:	03000000 	movweq	r0, #0
    1f58:	00000c9e 	muleq	r0, lr, ip
    1f5c:	00154925 	andseq	r4, r5, r5, lsr #18
    1f60:	0a190100 	beq	642368 <__bss_end+0x6380cc>
    1f64:	000016f4 	strdeq	r1, [r0], -r4
    1f68:	00000065 	andeq	r0, r0, r5, rrx
    1f6c:	000083ac 	andeq	r8, r0, ip, lsr #7
    1f70:	00000044 	andeq	r0, r0, r4, asr #32
    1f74:	0cf59c01 	ldcleq	12, cr9, [r5], #4
    1f78:	d5240000 	strle	r0, [r4, #-0]!
    1f7c:	01000016 	tsteq	r0, r6, lsl r0
    1f80:	03e21b19 	mvneq	r1, #25600	; 0x6400
    1f84:	91020000 	mrsls	r0, (UNDEF: 2)
    1f88:	168b246c 	strne	r2, [fp], ip, ror #8
    1f8c:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1f90:	00022d35 	andeq	r2, r2, r5, lsr sp
    1f94:	68910200 	ldmvs	r1, {r9}
    1f98:	0013bd22 	andseq	fp, r3, r2, lsr #26
    1f9c:	0e1b0100 	mufeqe	f0, f3, f0
    1fa0:	00000065 	andeq	r0, r0, r5, rrx
    1fa4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1fa8:	0013e628 	andseq	lr, r3, r8, lsr #12
    1fac:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1fb0:	000013f8 	strdeq	r1, [r0], -r8
    1fb4:	00008390 	muleq	r0, r0, r3
    1fb8:	0000001c 	andeq	r0, r0, ip, lsl r0
    1fbc:	e3279c01 			; <UNDEFINED> instruction: 0xe3279c01
    1fc0:	01000016 	tsteq	r0, r6, lsl r0
    1fc4:	1431060e 	ldrtne	r0, [r1], #-1550	; 0xfffff9f2
    1fc8:	83640000 	cmnhi	r4, #0
    1fcc:	002c0000 	eoreq	r0, ip, r0
    1fd0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1fd4:	00000d35 	andeq	r0, r0, r5, lsr sp
    1fd8:	00144424 	andseq	r4, r4, r4, lsr #8
    1fdc:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1fe0:	00000049 	andeq	r0, r0, r9, asr #32
    1fe4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1fe8:	0016ed29 	andseq	lr, r6, r9, lsr #26
    1fec:	0a040100 	beq	1023f4 <__bss_end+0xf8158>
    1ff0:	0000152b 	andeq	r1, r0, fp, lsr #10
    1ff4:	00000065 	andeq	r0, r0, r5, rrx
    1ff8:	00008338 	andeq	r8, r0, r8, lsr r3
    1ffc:	0000002c 	andeq	r0, r0, ip, lsr #32
    2000:	70269c01 	eorvc	r9, r6, r1, lsl #24
    2004:	01006469 	tsteq	r0, r9, ror #8
    2008:	00650e06 	rsbeq	r0, r5, r6, lsl #28
    200c:	91020000 	mrsls	r0, (UNDEF: 2)
    2010:	f9000074 			; <UNDEFINED> instruction: 0xf9000074
    2014:	04000006 	streq	r0, [r0], #-6
    2018:	00073e00 	andeq	r3, r7, r0, lsl #28
    201c:	10010400 	andne	r0, r1, r0, lsl #8
    2020:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2024:	000017f3 	strdeq	r1, [r0], -r3
    2028:	0000157e 	andeq	r1, r0, lr, ror r5
    202c:	00008794 	muleq	r0, r4, r7
    2030:	00000fdc 	ldrdeq	r0, [r0], -ip
    2034:	00000772 	andeq	r0, r0, r2, ror r7
    2038:	00132e02 	andseq	r2, r3, r2, lsl #28
    203c:	11040200 	mrsne	r0, R12_usr
    2040:	0000003e 	andeq	r0, r0, lr, lsr r0
    2044:	9fa80305 	svcls	0x00a80305
    2048:	04030000 	streq	r0, [r3], #-0
    204c:	001eee04 	andseq	lr, lr, r4, lsl #28
    2050:	00370400 	eorseq	r0, r7, r0, lsl #8
    2054:	67050000 	strvs	r0, [r5, -r0]
    2058:	06000000 	streq	r0, [r0], -r0
    205c:	00001933 	andeq	r1, r0, r3, lsr r9
    2060:	7f100501 	svcvc	0x00100501
    2064:	11000000 	mrsne	r0, (UNDEF: 0)
    2068:	33323130 	teqcc	r2, #48, 2
    206c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    2070:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    2074:	46454443 	strbmi	r4, [r5], -r3, asr #8
    2078:	01070000 	mrseq	r0, (UNDEF: 7)
    207c:	00430103 	subeq	r0, r3, r3, lsl #2
    2080:	97080000 	strls	r0, [r8, -r0]
    2084:	7f000000 	svcvc	0x00000000
    2088:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    208c:	00000084 	andeq	r0, r0, r4, lsl #1
    2090:	6f040010 	svcvs	0x00040010
    2094:	03000000 	movweq	r0, #0
    2098:	07a20704 	streq	r0, [r2, r4, lsl #14]!
    209c:	84040000 	strhi	r0, [r4], #-0
    20a0:	03000000 	movweq	r0, #0
    20a4:	10e60801 	rscne	r0, r6, r1, lsl #16
    20a8:	90040000 	andls	r0, r4, r0
    20ac:	0a000000 	beq	20b4 <shift+0x20b4>
    20b0:	00000048 	andeq	r0, r0, r8, asr #32
    20b4:	0019270b 	andseq	r2, r9, fp, lsl #14
    20b8:	07fc0100 	ldrbeq	r0, [ip, r0, lsl #2]!
    20bc:	0000189e 	muleq	r0, lr, r8
    20c0:	00000037 	andeq	r0, r0, r7, lsr r0
    20c4:	00009660 	andeq	r9, r0, r0, ror #12
    20c8:	00000110 	andeq	r0, r0, r0, lsl r1
    20cc:	011d9c01 	tsteq	sp, r1, lsl #24
    20d0:	730c0000 	movwvc	r0, #49152	; 0xc000
    20d4:	18fc0100 	ldmne	ip!, {r8}^
    20d8:	0000011d 	andeq	r0, r0, sp, lsl r1
    20dc:	0d649102 	stfeqp	f1, [r4, #-8]!
    20e0:	007a6572 	rsbseq	r6, sl, r2, ror r5
    20e4:	3709fe01 	strcc	pc, [r9, -r1, lsl #28]
    20e8:	02000000 	andeq	r0, r0, #0
    20ec:	c10e7491 			; <UNDEFINED> instruction: 0xc10e7491
    20f0:	01000019 	tsteq	r0, r9, lsl r0
    20f4:	003712fe 	ldrshteq	r1, [r7], -lr
    20f8:	91020000 	mrsls	r0, (UNDEF: 2)
    20fc:	96a40f70 			; <UNDEFINED> instruction: 0x96a40f70
    2100:	00a80000 	adceq	r0, r8, r0
    2104:	65100000 	ldrvs	r0, [r0, #-0]
    2108:	01000018 	tsteq	r0, r8, lsl r0
    210c:	230c0103 	movwcs	r0, #49411	; 0xc103
    2110:	02000001 	andeq	r0, r0, #1
    2114:	bc0f6c91 	stclt	12, cr6, [pc], {145}	; 0x91
    2118:	80000096 	mulhi	r0, r6, r0
    211c:	11000000 	mrsne	r0, (UNDEF: 0)
    2120:	08010064 	stmdaeq	r1, {r2, r5, r6}
    2124:	01230901 			; <UNDEFINED> instruction: 0x01230901
    2128:	91020000 	mrsls	r0, (UNDEF: 2)
    212c:	00000068 	andeq	r0, r0, r8, rrx
    2130:	00970412 	addseq	r0, r7, r2, lsl r4
    2134:	04130000 	ldreq	r0, [r3], #-0
    2138:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    213c:	193f1400 	ldmdbne	pc!, {sl, ip}	; <UNPREDICTABLE>
    2140:	c1010000 	mrsgt	r0, (UNDEF: 1)
    2144:	0019a906 	andseq	sl, r9, r6, lsl #18
    2148:	00933c00 	addseq	r3, r3, r0, lsl #24
    214c:	00032400 	andeq	r2, r3, r0, lsl #8
    2150:	299c0100 	ldmibcs	ip, {r8}
    2154:	0c000002 	stceq	0, cr0, [r0], {2}
    2158:	c1010078 	tstgt	r1, r8, ror r0
    215c:	00003711 	andeq	r3, r0, r1, lsl r7
    2160:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    2164:	66620c7f 			; <UNDEFINED> instruction: 0x66620c7f
    2168:	c1010072 	tstgt	r1, r2, ror r0
    216c:	0002291a 	andeq	r2, r2, sl, lsl r9
    2170:	a0910300 	addsge	r0, r1, r0, lsl #6
    2174:	1877157f 	ldmdane	r7!, {r0, r1, r2, r3, r4, r5, r6, r8, sl, ip}^
    2178:	c1010000 	mrsgt	r0, (UNDEF: 1)
    217c:	00008b32 	andeq	r8, r0, r2, lsr fp
    2180:	9c910300 	ldcls	3, cr0, [r1], {0}
    2184:	19820e7f 	stmibne	r2, {r0, r1, r2, r3, r4, r5, r6, r9, sl, fp}
    2188:	c3010000 	movwgt	r0, #4096	; 0x1000
    218c:	0000840f 	andeq	r8, r0, pc, lsl #8
    2190:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2194:	00196b0e 	andseq	r6, r9, lr, lsl #22
    2198:	06d90100 	ldrbeq	r0, [r9], r0, lsl #2
    219c:	00000123 	andeq	r0, r0, r3, lsr #2
    21a0:	0e709102 	expeqs	f1, f2
    21a4:	00001880 	andeq	r1, r0, r0, lsl #17
    21a8:	3e11dd01 	cdpcc	13, 1, cr13, cr1, cr1, {0}
    21ac:	02000000 	andeq	r0, r0, #0
    21b0:	3d0e6491 	cfstrscc	mvf6, [lr, #-580]	; 0xfffffdbc
    21b4:	01000018 	tsteq	r0, r8, lsl r0
    21b8:	008b18e0 	addeq	r1, fp, r0, ror #17
    21bc:	91020000 	mrsls	r0, (UNDEF: 2)
    21c0:	184c0e60 	stmdane	ip, {r5, r6, r9, sl, fp}^
    21c4:	e1010000 	mrs	r0, (UNDEF: 1)
    21c8:	00008b18 	andeq	r8, r0, r8, lsl fp
    21cc:	5c910200 	lfmpl	f0, 4, [r1], {0}
    21d0:	0018f20e 	andseq	pc, r8, lr, lsl #4
    21d4:	07e30100 	strbeq	r0, [r3, r0, lsl #2]!
    21d8:	0000022f 	andeq	r0, r0, pc, lsr #4
    21dc:	7fb89103 	svcvc	0x00b89103
    21e0:	0018860e 	andseq	r8, r8, lr, lsl #12
    21e4:	06e50100 	strbteq	r0, [r5], r0, lsl #2
    21e8:	00000123 	andeq	r0, r0, r3, lsr #2
    21ec:	16589102 	ldrbne	r9, [r8], -r2, lsl #2
    21f0:	00009548 	andeq	r9, r0, r8, asr #10
    21f4:	00000050 	andeq	r0, r0, r0, asr r0
    21f8:	000001f7 	strdeq	r0, [r0], -r7
    21fc:	0100690d 	tsteq	r0, sp, lsl #18
    2200:	01230be7 	smulwteq	r3, r7, fp
    2204:	91020000 	mrsls	r0, (UNDEF: 2)
    2208:	a40f006c 	strge	r0, [pc], #-108	; 2210 <shift+0x2210>
    220c:	98000095 	stmdals	r0, {r0, r2, r4, r7}
    2210:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2214:	00001870 	andeq	r1, r0, r0, ror r8
    2218:	3f08ef01 	svccc	0x0008ef01
    221c:	03000002 	movweq	r0, #2
    2220:	0f7fac91 	svceq	0x007fac91
    2224:	000095d4 	ldrdeq	r9, [r0], -r4
    2228:	00000068 	andeq	r0, r0, r8, rrx
    222c:	0100690d 	tsteq	r0, sp, lsl #18
    2230:	01230cf2 	strdeq	r0, [r3, -r2]!
    2234:	91020000 	mrsls	r0, (UNDEF: 2)
    2238:	00000068 	andeq	r0, r0, r8, rrx
    223c:	00900412 	addseq	r0, r0, r2, lsl r4
    2240:	90080000 	andls	r0, r8, r0
    2244:	3f000000 	svccc	0x00000000
    2248:	09000002 	stmdbeq	r0, {r1}
    224c:	00000084 	andeq	r0, r0, r4, lsl #1
    2250:	9008001f 	andls	r0, r8, pc, lsl r0
    2254:	4f000000 	svcmi	0x00000000
    2258:	09000002 	stmdbeq	r0, {r1}
    225c:	00000084 	andeq	r0, r0, r4, lsl #1
    2260:	3f140008 	svccc	0x00140008
    2264:	01000019 	tsteq	r0, r9, lsl r0
    2268:	1a0e06bb 	bne	383d5c <__bss_end+0x379ac0>
    226c:	930c0000 	movwls	r0, #49152	; 0xc000
    2270:	00300000 	eorseq	r0, r0, r0
    2274:	9c010000 	stcls	0, cr0, [r1], {-0}
    2278:	00000286 	andeq	r0, r0, r6, lsl #5
    227c:	0100780c 	tsteq	r0, ip, lsl #16
    2280:	003711bb 	ldrhteq	r1, [r7], -fp
    2284:	91020000 	mrsls	r0, (UNDEF: 2)
    2288:	66620c74 			; <UNDEFINED> instruction: 0x66620c74
    228c:	bb010072 	bllt	4245c <__bss_end+0x381c0>
    2290:	0002291a 	andeq	r2, r2, sl, lsl r9
    2294:	70910200 	addsvc	r0, r1, r0, lsl #4
    2298:	18460b00 	stmdane	r6, {r8, r9, fp}^
    229c:	b5010000 	strlt	r0, [r1, #-0]
    22a0:	0018fd06 	andseq	pc, r8, r6, lsl #26
    22a4:	0002b200 	andeq	fp, r2, r0, lsl #4
    22a8:	0092cc00 	addseq	ip, r2, r0, lsl #24
    22ac:	00004000 	andeq	r4, r0, r0
    22b0:	b29c0100 	addslt	r0, ip, #0, 2
    22b4:	0c000002 	stceq	0, cr0, [r0], {2}
    22b8:	b5010078 	strlt	r0, [r1, #-120]	; 0xffffff88
    22bc:	00003712 	andeq	r3, r0, r2, lsl r7
    22c0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    22c4:	02010300 	andeq	r0, r1, #0, 6
    22c8:	00000b72 	andeq	r0, r0, r2, ror fp
    22cc:	0018370b 	andseq	r3, r8, fp, lsl #14
    22d0:	06b00100 	ldrteq	r0, [r0], r0, lsl #2
    22d4:	000018ba 			; <UNDEFINED> instruction: 0x000018ba
    22d8:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    22dc:	00009290 	muleq	r0, r0, r2
    22e0:	0000003c 	andeq	r0, r0, ip, lsr r0
    22e4:	02e59c01 	rsceq	r9, r5, #256	; 0x100
    22e8:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    22ec:	12b00100 	adcsne	r0, r0, #0, 2
    22f0:	00000037 	andeq	r0, r0, r7, lsr r0
    22f4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    22f8:	0019f614 	andseq	pc, r9, r4, lsl r6	; <UNPREDICTABLE>
    22fc:	06a50100 	strteq	r0, [r5], r0, lsl #2
    2300:	00001944 	andeq	r1, r0, r4, asr #18
    2304:	000091bc 			; <UNDEFINED> instruction: 0x000091bc
    2308:	000000d4 	ldrdeq	r0, [r0], -r4
    230c:	033a9c01 	teqeq	sl, #256	; 0x100
    2310:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2314:	2ba50100 	blcs	fe94271c <__bss_end+0xfe938480>
    2318:	00000084 	andeq	r0, r0, r4, lsl #1
    231c:	0c6c9102 	stfeqp	f1, [ip], #-8
    2320:	00726662 	rsbseq	r6, r2, r2, ror #12
    2324:	2934a501 	ldmdbcs	r4!, {r0, r8, sl, sp, pc}
    2328:	02000002 	andeq	r0, r0, #2
    232c:	90156891 	mulsls	r5, r1, r8
    2330:	01000019 	tsteq	r0, r9, lsl r0
    2334:	01233da5 			; <UNDEFINED> instruction: 0x01233da5
    2338:	91020000 	mrsls	r0, (UNDEF: 2)
    233c:	19820e64 	stmibne	r2, {r2, r5, r6, r9, sl, fp}
    2340:	a7010000 	strge	r0, [r1, -r0]
    2344:	00012306 	andeq	r2, r1, r6, lsl #6
    2348:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    234c:	19b51700 	ldmibne	r5!, {r8, r9, sl, ip}
    2350:	83010000 	movwhi	r0, #4096	; 0x1000
    2354:	00191006 	andseq	r1, r9, r6
    2358:	008d7c00 	addeq	r7, sp, r0, lsl #24
    235c:	00044000 	andeq	r4, r4, r0
    2360:	9e9c0100 	fmllse	f0, f4, f0
    2364:	0c000003 	stceq	0, cr0, [r0], {3}
    2368:	83010078 	movwhi	r0, #4216	; 0x1078
    236c:	00003718 	andeq	r3, r0, r8, lsl r7
    2370:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2374:	00183d15 	andseq	r3, r8, r5, lsl sp
    2378:	29830100 	stmibcs	r3, {r8}
    237c:	0000039e 	muleq	r0, lr, r3
    2380:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    2384:	0000184c 	andeq	r1, r0, ip, asr #16
    2388:	9e418301 	cdpls	3, 4, cr8, cr1, cr1, {0}
    238c:	02000003 	andeq	r0, r0, #3
    2390:	95156491 	ldrls	r6, [r5, #-1169]	; 0xfffffb6f
    2394:	01000018 	tsteq	r0, r8, lsl r0
    2398:	03a44f83 			; <UNDEFINED> instruction: 0x03a44f83
    239c:	91020000 	mrsls	r0, (UNDEF: 2)
    23a0:	182d0e60 	stmdane	sp!, {r5, r6, r9, sl, fp}
    23a4:	96010000 	strls	r0, [r1], -r0
    23a8:	0000370b 	andeq	r3, r0, fp, lsl #14
    23ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    23b0:	84041800 	strhi	r1, [r4], #-2048	; 0xfffff800
    23b4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    23b8:	00012304 	andeq	r2, r1, r4, lsl #6
    23bc:	1a2e1400 	bne	b873c4 <__bss_end+0xb7d128>
    23c0:	76010000 	strvc	r0, [r1], -r0
    23c4:	0018ae06 	andseq	sl, r8, r6, lsl #28
    23c8:	008cb800 	addeq	fp, ip, r0, lsl #16
    23cc:	0000c400 	andeq	ip, r0, r0, lsl #8
    23d0:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
    23d4:	15000003 	strne	r0, [r0, #-3]
    23d8:	000018ed 	andeq	r1, r0, sp, ror #17
    23dc:	29137601 	ldmdbcs	r3, {r0, r9, sl, ip, sp, lr}
    23e0:	02000002 	andeq	r0, r0, #2
    23e4:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    23e8:	09780100 	ldmdbeq	r8!, {r8}^
    23ec:	00000123 	andeq	r0, r0, r3, lsr #2
    23f0:	0d749102 	ldfeqp	f1, [r4, #-8]!
    23f4:	006e656c 	rsbeq	r6, lr, ip, ror #10
    23f8:	230c7801 	movwcs	r7, #51201	; 0xc801
    23fc:	02000001 	andeq	r0, r0, #1
    2400:	cf0e7091 	svcgt	0x000e7091
    2404:	01000018 	tsteq	r0, r8, lsl r0
    2408:	01231178 			; <UNDEFINED> instruction: 0x01231178
    240c:	91020000 	mrsls	r0, (UNDEF: 2)
    2410:	7019006c 	andsvc	r0, r9, ip, rrx
    2414:	0100776f 	tsteq	r0, pc, ror #14
    2418:	1907076d 	stmdbne	r7, {r0, r2, r3, r5, r6, r8, r9, sl}
    241c:	00370000 	eorseq	r0, r7, r0
    2420:	8c4c0000 	marhi	acc0, r0, ip
    2424:	006c0000 	rsbeq	r0, ip, r0
    2428:	9c010000 	stcls	0, cr0, [r1], {-0}
    242c:	0000045c 	andeq	r0, r0, ip, asr r4
    2430:	0100780c 	tsteq	r0, ip, lsl #16
    2434:	003e176d 	eorseq	r1, lr, sp, ror #14
    2438:	91020000 	mrsls	r0, (UNDEF: 2)
    243c:	006e0c6c 	rsbeq	r0, lr, ip, ror #24
    2440:	8b2d6d01 	blhi	b5d84c <__bss_end+0xb535b0>
    2444:	02000000 	andeq	r0, r0, #0
    2448:	720d6891 	andvc	r6, sp, #9502720	; 0x910000
    244c:	0b6f0100 	bleq	1bc2854 <__bss_end+0x1bb85b8>
    2450:	00000037 	andeq	r0, r0, r7, lsr r0
    2454:	0f749102 	svceq	0x00749102
    2458:	00008c68 	andeq	r8, r0, r8, ror #24
    245c:	00000038 	andeq	r0, r0, r8, lsr r0
    2460:	0100690d 	tsteq	r0, sp, lsl #18
    2464:	00841670 	addeq	r1, r4, r0, ror r6
    2468:	91020000 	mrsls	r0, (UNDEF: 2)
    246c:	17000070 	smlsdxne	r0, r0, r0, r0
    2470:	0000197b 	andeq	r1, r0, fp, ror r9
    2474:	e3066401 	movw	r6, #25601	; 0x6401
    2478:	cc000017 	stcgt	0, cr0, [r0], {23}
    247c:	8000008b 	andhi	r0, r0, fp, lsl #1
    2480:	01000000 	mrseq	r0, (UNDEF: 0)
    2484:	0004d99c 	muleq	r4, ip, r9
    2488:	72730c00 	rsbsvc	r0, r3, #0, 24
    248c:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    2490:	0004d919 	andeq	sp, r4, r9, lsl r9
    2494:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2498:	7473640c 	ldrbtvc	r6, [r3], #-1036	; 0xfffffbf4
    249c:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    24a0:	000004e0 	andeq	r0, r0, r0, ror #9
    24a4:	0c609102 	stfeqp	f1, [r0], #-8
    24a8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    24ac:	232d6401 			; <UNDEFINED> instruction: 0x232d6401
    24b0:	02000001 	andeq	r0, r0, #1
    24b4:	640e5c91 	strvs	r5, [lr], #-3217	; 0xfffff36f
    24b8:	01000019 	tsteq	r0, r9, lsl r0
    24bc:	011d0e66 	tsteq	sp, r6, ror #28
    24c0:	91020000 	mrsls	r0, (UNDEF: 2)
    24c4:	192c0e70 	stmdbne	ip!, {r4, r5, r6, r9, sl, fp}
    24c8:	67010000 	strvs	r0, [r1, -r0]
    24cc:	00022908 	andeq	r2, r2, r8, lsl #18
    24d0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    24d4:	008bf40f 	addeq	pc, fp, pc, lsl #8
    24d8:	00004800 	andeq	r4, r0, r0, lsl #16
    24dc:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    24e0:	230b6901 	movwcs	r6, #47361	; 0xb901
    24e4:	02000001 	andeq	r0, r0, #1
    24e8:	00007491 	muleq	r0, r1, r4
    24ec:	04df0412 	ldrbeq	r0, [pc], #1042	; 24f4 <shift+0x24f4>
    24f0:	1b1a0000 	blne	6824f8 <__bss_end+0x67825c>
    24f4:	19751704 	ldmdbne	r5!, {r2, r8, r9, sl, ip}^
    24f8:	5c010000 	stcpl	0, cr0, [r1], {-0}
    24fc:	0018d406 	andseq	sp, r8, r6, lsl #8
    2500:	008b6400 	addeq	r6, fp, r0, lsl #8
    2504:	00006800 	andeq	r6, r0, r0, lsl #16
    2508:	419c0100 	orrsmi	r0, ip, r0, lsl #2
    250c:	15000005 	strne	r0, [r0, #-5]
    2510:	00001a19 	andeq	r1, r0, r9, lsl sl
    2514:	e0125c01 	ands	r5, r2, r1, lsl #24
    2518:	02000004 	andeq	r0, r0, #4
    251c:	20156c91 	mulscs	r5, r1, ip
    2520:	0100001a 	tsteq	r0, sl, lsl r0
    2524:	01231e5c 			; <UNDEFINED> instruction: 0x01231e5c
    2528:	91020000 	mrsls	r0, (UNDEF: 2)
    252c:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    2530:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    2534:	00022908 	andeq	r2, r2, r8, lsl #18
    2538:	70910200 	addsvc	r0, r1, r0, lsl #4
    253c:	008b800f 	addeq	r8, fp, pc
    2540:	00003c00 	andeq	r3, r0, r0, lsl #24
    2544:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2548:	230b6001 	movwcs	r6, #45057	; 0xb001
    254c:	02000001 	andeq	r0, r0, #1
    2550:	00007491 	muleq	r0, r1, r4
    2554:	001a270b 	andseq	r2, sl, fp, lsl #14
    2558:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    255c:	000019c6 	andeq	r1, r0, r6, asr #19
    2560:	00000123 	andeq	r0, r0, r3, lsr #2
    2564:	00008b10 	andeq	r8, r0, r0, lsl fp
    2568:	00000054 	andeq	r0, r0, r4, asr r0
    256c:	057a9c01 	ldrbeq	r9, [sl, #-3073]!	; 0xfffff3ff
    2570:	730c0000 	movwvc	r0, #49152	; 0xc000
    2574:	18520100 	ldmdane	r2, {r8}^
    2578:	0000011d 	andeq	r0, r0, sp, lsl r1
    257c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    2580:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    2584:	00012306 	andeq	r2, r1, r6, lsl #6
    2588:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    258c:	19880b00 	stmibne	r8, {r8, r9, fp}
    2590:	42010000 	andmi	r0, r1, #0
    2594:	0019d305 	andseq	sp, r9, r5, lsl #6
    2598:	00012300 	andeq	r2, r1, r0, lsl #6
    259c:	008a6400 	addeq	r6, sl, r0, lsl #8
    25a0:	0000ac00 	andeq	sl, r0, r0, lsl #24
    25a4:	e09c0100 	adds	r0, ip, r0, lsl #2
    25a8:	0c000005 	stceq	0, cr0, [r0], {5}
    25ac:	01003173 	tsteq	r0, r3, ror r1
    25b0:	011d1942 	tsteq	sp, r2, asr #18
    25b4:	91020000 	mrsls	r0, (UNDEF: 2)
    25b8:	32730c6c 	rsbscc	r0, r3, #108, 24	; 0x6c00
    25bc:	29420100 	stmdbcs	r2, {r8}^
    25c0:	0000011d 	andeq	r0, r0, sp, lsl r1
    25c4:	0c689102 	stfeqp	f1, [r8], #-8
    25c8:	006d756e 	rsbeq	r7, sp, lr, ror #10
    25cc:	23314201 	teqcs	r1, #268435456	; 0x10000000
    25d0:	02000001 	andeq	r0, r0, #1
    25d4:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    25d8:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    25dc:	0005e010 	andeq	lr, r5, r0, lsl r0
    25e0:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    25e4:	0032750d 	eorseq	r7, r2, sp, lsl #10
    25e8:	e0144401 	ands	r4, r4, r1, lsl #8
    25ec:	02000005 	andeq	r0, r0, #5
    25f0:	03007691 	movweq	r7, #1681	; 0x691
    25f4:	10dd0801 	sbcsne	r0, sp, r1, lsl #16
    25f8:	e00b0000 	and	r0, fp, r0
    25fc:	01000018 	tsteq	r0, r8, lsl r0
    2600:	19e50736 	stmibne	r5!, {r1, r2, r4, r5, r8, r9, sl}^
    2604:	02290000 	eoreq	r0, r9, #0
    2608:	89a40000 	stmibhi	r4!, {}	; <UNPREDICTABLE>
    260c:	00c00000 	sbceq	r0, r0, r0
    2610:	9c010000 	stcls	0, cr0, [r1], {-0}
    2614:	00000640 	andeq	r0, r0, r0, asr #12
    2618:	0018a915 	andseq	sl, r8, r5, lsl r9
    261c:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    2620:	00000229 	andeq	r0, r0, r9, lsr #4
    2624:	0c6c9102 	stfeqp	f1, [ip], #-8
    2628:	00637273 	rsbeq	r7, r3, r3, ror r2
    262c:	1d273601 	stcne	6, cr3, [r7, #-4]!
    2630:	02000001 	andeq	r0, r0, #1
    2634:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    2638:	01006d75 	tsteq	r0, r5, ror sp
    263c:	01233036 			; <UNDEFINED> instruction: 0x01233036
    2640:	91020000 	mrsls	r0, (UNDEF: 2)
    2644:	00690d64 	rsbeq	r0, r9, r4, ror #26
    2648:	23063801 	movwcs	r3, #26625	; 0x6801
    264c:	02000001 	andeq	r0, r0, #1
    2650:	0b007491 	bleq	1f89c <__bss_end+0x15600>
    2654:	00001860 	andeq	r1, r0, r0, ror #16
    2658:	97052401 	strls	r2, [r5, -r1, lsl #8]
    265c:	23000019 	movwcs	r0, #25
    2660:	08000001 	stmdaeq	r0, {r0}
    2664:	9c000089 	stcls	0, cr0, [r0], {137}	; 0x89
    2668:	01000000 	mrseq	r0, (UNDEF: 0)
    266c:	00067d9c 	muleq	r6, ip, sp
    2670:	18c41500 	stmiane	r4, {r8, sl, ip}^
    2674:	24010000 	strcs	r0, [r1], #-0
    2678:	00011d16 	andeq	r1, r1, r6, lsl sp
    267c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2680:	0019a20e 	andseq	sl, r9, lr, lsl #4
    2684:	06260100 	strteq	r0, [r6], -r0, lsl #2
    2688:	00000123 	andeq	r0, r0, r3, lsr #2
    268c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2690:	0018e81c 	andseq	lr, r8, ip, lsl r8
    2694:	06080100 	streq	r0, [r8], -r0, lsl #2
    2698:	00001854 	andeq	r1, r0, r4, asr r8
    269c:	00008794 	muleq	r0, r4, r7
    26a0:	00000174 	andeq	r0, r0, r4, ror r1
    26a4:	c4159c01 	ldrgt	r9, [r5], #-3073	; 0xfffff3ff
    26a8:	01000018 	tsteq	r0, r8, lsl r0
    26ac:	00841808 	addeq	r1, r4, r8, lsl #16
    26b0:	91020000 	mrsls	r0, (UNDEF: 2)
    26b4:	19a21564 	stmibne	r2!, {r2, r5, r6, r8, sl, ip}
    26b8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    26bc:	00022925 	andeq	r2, r2, r5, lsr #18
    26c0:	60910200 	addsvs	r0, r1, r0, lsl #4
    26c4:	0018ca15 	andseq	ip, r8, r5, lsl sl
    26c8:	3a080100 	bcc	202ad0 <__bss_end+0x1f8834>
    26cc:	00000084 	andeq	r0, r0, r4, lsl #1
    26d0:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    26d4:	0a010069 	beq	42880 <__bss_end+0x385e4>
    26d8:	00012306 	andeq	r2, r1, r6, lsl #6
    26dc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    26e0:	0088600f 	addeq	r6, r8, pc
    26e4:	00009800 	andeq	r9, r0, r0, lsl #16
    26e8:	006a0d00 	rsbeq	r0, sl, r0, lsl #26
    26ec:	230b1c01 	movwcs	r1, #48129	; 0xbc01
    26f0:	02000001 	andeq	r0, r0, #1
    26f4:	880f7091 	stmdahi	pc, {r0, r4, r7, ip, sp, lr}	; <UNPREDICTABLE>
    26f8:	60000088 	andvs	r0, r0, r8, lsl #1
    26fc:	0d000000 	stceq	0, cr0, [r0, #-0]
    2700:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    2704:	00009008 	andeq	r9, r0, r8
    2708:	6f910200 	svcvs	0x00910200
    270c:	00000000 	andeq	r0, r0, r0
    2710:	000011ab 	andeq	r1, r0, fp, lsr #3
    2714:	08e80004 	stmiaeq	r8!, {r2}^
    2718:	01040000 	mrseq	r0, (UNDEF: 4)
    271c:	00001710 	andeq	r1, r0, r0, lsl r7
    2720:	001a9104 	andseq	r9, sl, r4, lsl #2
    2724:	00157e00 	andseq	r7, r5, r0, lsl #28
    2728:	00977000 	addseq	r7, r7, r0
    272c:	0004b400 	andeq	fp, r4, r0, lsl #8
    2730:	000db400 	andeq	fp, sp, r0, lsl #8
    2734:	08010200 	stmdaeq	r1, {r9}
    2738:	000010e6 	andeq	r1, r0, r6, ror #1
    273c:	00002503 	andeq	r2, r0, r3, lsl #10
    2740:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    2744:	00000e59 	andeq	r0, r0, r9, asr lr
    2748:	00071004 	andeq	r1, r7, r4
    274c:	07050200 	streq	r0, [r5, -r0, lsl #4]
    2750:	00000049 	andeq	r0, r0, r9, asr #32
    2754:	00003803 	andeq	r3, r0, r3, lsl #16
    2758:	05040500 	streq	r0, [r4, #-1280]	; 0xfffffb00
    275c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2760:	00004903 	andeq	r4, r0, r3, lsl #18
    2764:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    2768:	0000031f 	andeq	r0, r0, pc, lsl r3
    276c:	001bbc04 	andseq	fp, fp, r4, lsl #24
    2770:	07080200 	streq	r0, [r8, -r0, lsl #4]
    2774:	0000006d 	andeq	r0, r0, sp, rrx
    2778:	00005c03 	andeq	r5, r0, r3, lsl #24
    277c:	08010200 	stmdaeq	r1, {r9}
    2780:	000010dd 	ldrdeq	r1, [r0], -sp
    2784:	000da204 	andeq	sl, sp, r4, lsl #4
    2788:	07090200 	streq	r0, [r9, -r0, lsl #4]
    278c:	00000085 	andeq	r0, r0, r5, lsl #1
    2790:	00007403 	andeq	r7, r0, r3, lsl #8
    2794:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2798:	00001298 	muleq	r0, r8, r2
    279c:	00070f04 	andeq	r0, r7, r4, lsl #30
    27a0:	070a0200 	streq	r0, [sl, -r0, lsl #4]
    27a4:	0000009d 	muleq	r0, sp, r0
    27a8:	00008c03 	andeq	r8, r0, r3, lsl #24
    27ac:	07040200 	streq	r0, [r4, -r0, lsl #4]
    27b0:	000007a2 	andeq	r0, r0, r2, lsr #15
    27b4:	00009d03 	andeq	r9, r0, r3, lsl #26
    27b8:	07080200 	streq	r0, [r8, -r0, lsl #4]
    27bc:	00000798 	muleq	r0, r8, r7
    27c0:	000ef906 	andeq	pc, lr, r6, lsl #18
    27c4:	130d0200 	movwne	r0, #53760	; 0xd200
    27c8:	00000044 	andeq	r0, r0, r4, asr #32
    27cc:	9fc00305 	svcls	0x00c00305
    27d0:	bd060000 	stclt	0, cr0, [r6, #-0]
    27d4:	02000007 	andeq	r0, r0, #7
    27d8:	0044130e 	subeq	r1, r4, lr, lsl #6
    27dc:	03050000 	movweq	r0, #20480	; 0x5000
    27e0:	00009fc4 	andeq	r9, r0, r4, asr #31
    27e4:	000ef806 	andeq	pc, lr, r6, lsl #16
    27e8:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
    27ec:	00000098 	muleq	r0, r8, r0
    27f0:	9fc80305 	svcls	0x00c80305
    27f4:	bc060000 	stclt	0, cr0, [r6], {-0}
    27f8:	02000007 	andeq	r0, r0, #7
    27fc:	00981411 	addseq	r1, r8, r1, lsl r4
    2800:	03050000 	movweq	r0, #20480	; 0x5000
    2804:	00009fcc 	andeq	r9, r0, ip, asr #31
    2808:	000e6407 	andeq	r6, lr, r7, lsl #8
    280c:	06030800 	streq	r0, [r3], -r0, lsl #16
    2810:	00023c07 	andeq	r3, r2, r7, lsl #24
    2814:	09630800 	stmdbeq	r3!, {fp}^
    2818:	0a030000 	beq	c2820 <__bss_end+0xb8584>
    281c:	00008c12 	andeq	r8, r0, r2, lsl ip
    2820:	b8080000 	stmdalt	r8, {}	; <UNPREDICTABLE>
    2824:	0300000d 	movweq	r0, #13
    2828:	02410e0c 	subeq	r0, r1, #12, 28	; 0xc0
    282c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    2830:	00000e64 	andeq	r0, r0, r4, ror #28
    2834:	9f091003 	svcls	0x00091003
    2838:	4d000006 	stcmi	0, cr0, [r0, #-24]	; 0xffffffe8
    283c:	01000002 	tsteq	r0, r2
    2840:	00000138 	andeq	r0, r0, r8, lsr r1
    2844:	00000143 	andeq	r0, r0, r3, asr #2
    2848:	00024d0a 	andeq	r4, r2, sl, lsl #26
    284c:	02580b00 	subseq	r0, r8, #0, 22
    2850:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2854:	00000e63 	andeq	r0, r0, r3, ror #28
    2858:	1b151203 	blne	54706c <__bss_end+0x53cdd0>
    285c:	5e00000e 	cdppl	0, 0, cr0, cr0, cr14, {0}
    2860:	01000002 	tsteq	r0, r2
    2864:	0000015c 	andeq	r0, r0, ip, asr r1
    2868:	00000167 	andeq	r0, r0, r7, ror #2
    286c:	00024d0a 	andeq	r4, r2, sl, lsl #26
    2870:	00490a00 	subeq	r0, r9, r0, lsl #20
    2874:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2878:	000006b8 			; <UNDEFINED> instruction: 0x000006b8
    287c:	230e1503 	movwcs	r1, #58627	; 0xe503
    2880:	4100000a 	tstmi	r0, sl
    2884:	01000002 	tsteq	r0, r2
    2888:	00000180 	andeq	r0, r0, r0, lsl #3
    288c:	00000186 	andeq	r0, r0, r6, lsl #3
    2890:	0002600a 	andeq	r6, r2, sl
    2894:	d30c0000 	movwle	r0, #49152	; 0xc000
    2898:	0300000f 	movweq	r0, #15
    289c:	08fe0e18 	ldmeq	lr!, {r3, r4, r9, sl, fp}^
    28a0:	9b010000 	blls	428a8 <__bss_end+0x3860c>
    28a4:	a1000001 	tstge	r0, r1
    28a8:	0a000001 	beq	28b4 <shift+0x28b4>
    28ac:	0000024d 	andeq	r0, r0, sp, asr #4
    28b0:	0a1d0c00 	beq	7458b8 <__bss_end+0x73b61c>
    28b4:	1b030000 	blne	c28bc <__bss_end+0xb8620>
    28b8:	0007590e 	andeq	r5, r7, lr, lsl #18
    28bc:	01b60100 			; <UNDEFINED> instruction: 0x01b60100
    28c0:	01c10000 	biceq	r0, r1, r0
    28c4:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    28c8:	0b000002 	bleq	28d8 <shift+0x28d8>
    28cc:	00000241 	andeq	r0, r0, r1, asr #4
    28d0:	10c50c00 	sbcne	r0, r5, r0, lsl #24
    28d4:	1d030000 	stcne	0, cr0, [r3, #-0]
    28d8:	0011a50e 	andseq	sl, r1, lr, lsl #10
    28dc:	01d60100 	bicseq	r0, r6, r0, lsl #2
    28e0:	01eb0000 	mvneq	r0, r0
    28e4:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    28e8:	0b000002 	bleq	28f8 <shift+0x28f8>
    28ec:	00000074 	andeq	r0, r0, r4, ror r0
    28f0:	0000740b 	andeq	r7, r0, fp, lsl #8
    28f4:	02410b00 	subeq	r0, r1, #0, 22
    28f8:	0c000000 	stceq	0, cr0, [r0], {-0}
    28fc:	0000077e 	andeq	r0, r0, lr, ror r7
    2900:	8f0e1f03 	svchi	0x000e1f03
    2904:	01000005 	tsteq	r0, r5
    2908:	00000200 	andeq	r0, r0, r0, lsl #4
    290c:	00000215 	andeq	r0, r0, r5, lsl r2
    2910:	00024d0a 	andeq	r4, r2, sl, lsl #26
    2914:	00740b00 	rsbseq	r0, r4, r0, lsl #22
    2918:	740b0000 	strvc	r0, [fp], #-0
    291c:	0b000000 	bleq	2924 <shift+0x2924>
    2920:	00000025 	andeq	r0, r0, r5, lsr #32
    2924:	12c10d00 	sbcne	r0, r1, #0, 26
    2928:	21030000 	mrscs	r0, (UNDEF: 3)
    292c:	000f850e 	andeq	r8, pc, lr, lsl #10
    2930:	02260100 	eoreq	r0, r6, #0, 2
    2934:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    2938:	0b000002 	bleq	2948 <shift+0x2948>
    293c:	00000074 	andeq	r0, r0, r4, ror r0
    2940:	0000740b 	andeq	r7, r0, fp, lsl #8
    2944:	02580b00 	subseq	r0, r8, #0, 22
    2948:	00000000 	andeq	r0, r0, r0
    294c:	0000f803 	andeq	pc, r0, r3, lsl #16
    2950:	02010200 	andeq	r0, r1, #0, 4
    2954:	00000b72 	andeq	r0, r0, r2, ror fp
    2958:	00024103 	andeq	r4, r2, r3, lsl #2
    295c:	f8040e00 			; <UNDEFINED> instruction: 0xf8040e00
    2960:	03000000 	movweq	r0, #0
    2964:	0000024d 	andeq	r0, r0, sp, asr #4
    2968:	002c040e 	eoreq	r0, ip, lr, lsl #8
    296c:	040f0000 	streq	r0, [pc], #-0	; 2974 <shift+0x2974>
    2970:	023c040e 	eorseq	r0, ip, #234881024	; 0xe000000
    2974:	60030000 	andvs	r0, r3, r0
    2978:	10000002 	andne	r0, r0, r2
    297c:	00001398 	muleq	r0, r8, r3
    2980:	08060408 	stmdaeq	r6, {r3, sl}
    2984:	00000291 	muleq	r0, r1, r2
    2988:	00307211 	eorseq	r7, r0, r1, lsl r2
    298c:	8c0e0804 	stchi	8, cr0, [lr], {4}
    2990:	00000000 	andeq	r0, r0, r0
    2994:	00317211 	eorseq	r7, r1, r1, lsl r2
    2998:	8c0e0904 			; <UNDEFINED> instruction: 0x8c0e0904
    299c:	04000000 	streq	r0, [r0], #-0
    29a0:	0f1b1200 	svceq	0x001b1200
    29a4:	04050000 	streq	r0, [r5], #-0
    29a8:	00000049 	andeq	r0, r0, r9, asr #32
    29ac:	c80c1e04 	stmdagt	ip, {r2, r9, sl, fp, ip}
    29b0:	13000002 	movwne	r0, #2
    29b4:	00000707 	andeq	r0, r0, r7, lsl #14
    29b8:	096b1300 	stmdbeq	fp!, {r8, r9, ip}^
    29bc:	13010000 	movwne	r0, #4096	; 0x1000
    29c0:	00000f3d 	andeq	r0, r0, sp, lsr pc
    29c4:	10f91302 	rscsne	r1, r9, r2, lsl #6
    29c8:	13030000 	movwne	r0, #12288	; 0x3000
    29cc:	0000094e 	andeq	r0, r0, lr, asr #18
    29d0:	0e491304 	cdpeq	3, 4, cr1, cr9, cr4, {0}
    29d4:	00050000 	andeq	r0, r5, r0
    29d8:	000f0312 	andeq	r0, pc, r2, lsl r3	; <UNPREDICTABLE>
    29dc:	49040500 	stmdbmi	r4, {r8, sl}
    29e0:	04000000 	streq	r0, [r0], #-0
    29e4:	03050c44 	movweq	r0, #23620	; 0x5c44
    29e8:	92130000 	andsls	r0, r3, #0
    29ec:	00000008 	andeq	r0, r0, r8
    29f0:	00103713 	andseq	r3, r0, r3, lsl r7
    29f4:	28130100 	ldmdacs	r3, {r8}
    29f8:	02000013 	andeq	r0, r0, #19
    29fc:	000d2013 	andeq	r2, sp, r3, lsl r0
    2a00:	5d130300 	ldcpl	3, cr0, [r3, #-0]
    2a04:	04000009 	streq	r0, [r0], #-9
    2a08:	000a8313 	andeq	r8, sl, r3, lsl r3
    2a0c:	87130500 	ldrhi	r0, [r3, -r0, lsl #10]
    2a10:	06000007 	streq	r0, [r0], -r7
    2a14:	0c530600 	mrrceq	6, 0, r0, r3, cr0
    2a18:	05050000 	streq	r0, [r5, #-0]
    2a1c:	00009814 	andeq	r9, r0, r4, lsl r8
    2a20:	d0030500 	andle	r0, r3, r0, lsl #10
    2a24:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    2a28:	0000103c 	andeq	r1, r0, ip, lsr r0
    2a2c:	98140605 	ldmdals	r4, {r0, r2, r9, sl}
    2a30:	05000000 	streq	r0, [r0, #-0]
    2a34:	009fd403 	addseq	sp, pc, r3, lsl #8
    2a38:	0aee0600 	beq	ffb84240 <__bss_end+0xffb79fa4>
    2a3c:	07060000 	streq	r0, [r6, -r0]
    2a40:	0000981a 	andeq	r9, r0, sl, lsl r8
    2a44:	d8030500 	stmdale	r3, {r8, sl}
    2a48:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    2a4c:	00000e72 	andeq	r0, r0, r2, ror lr
    2a50:	981a0906 	ldmdals	sl, {r1, r2, r8, fp}
    2a54:	05000000 	streq	r0, [r0, #-0]
    2a58:	009fdc03 	addseq	sp, pc, r3, lsl #24
    2a5c:	0ab10600 	beq	fec44264 <__bss_end+0xfec39fc8>
    2a60:	0b060000 	bleq	182a68 <__bss_end+0x1787cc>
    2a64:	0000981a 	andeq	r9, r0, sl, lsl r8
    2a68:	e0030500 	and	r0, r3, r0, lsl #10
    2a6c:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    2a70:	00000dfd 	strdeq	r0, [r0], -sp
    2a74:	981a0d06 	ldmdals	sl, {r1, r2, r8, sl, fp}
    2a78:	05000000 	streq	r0, [r0, #-0]
    2a7c:	009fe403 	addseq	lr, pc, r3, lsl #8
    2a80:	06c20600 	strbeq	r0, [r2], r0, lsl #12
    2a84:	0f060000 	svceq	0x00060000
    2a88:	0000981a 	andeq	r9, r0, sl, lsl r8
    2a8c:	e8030500 	stmda	r3, {r8, sl}
    2a90:	1200009f 	andne	r0, r0, #159	; 0x9f
    2a94:	00000d06 	andeq	r0, r0, r6, lsl #26
    2a98:	00490405 	subeq	r0, r9, r5, lsl #8
    2a9c:	1b060000 	blne	182aa4 <__bss_end+0x178808>
    2aa0:	0003a80c 	andeq	sl, r3, ip, lsl #16
    2aa4:	064e1300 	strbeq	r1, [lr], -r0, lsl #6
    2aa8:	13000000 	movwne	r0, #0
    2aac:	00001165 	andeq	r1, r0, r5, ror #2
    2ab0:	13231301 			; <UNDEFINED> instruction: 0x13231301
    2ab4:	00020000 	andeq	r0, r2, r0
    2ab8:	00041914 	andeq	r1, r4, r4, lsl r9
    2abc:	04e10700 	strbteq	r0, [r1], #1792	; 0x700
    2ac0:	06900000 	ldreq	r0, [r0], r0
    2ac4:	051b0763 	ldreq	r0, [fp, #-1891]	; 0xfffff89d
    2ac8:	2a100000 	bcs	402ad0 <__bss_end+0x3f8834>
    2acc:	24000006 	strcs	r0, [r0], #-6
    2ad0:	35106706 	ldrcc	r6, [r0, #-1798]	; 0xfffff8fa
    2ad4:	08000004 	stmdaeq	r0, {r2}
    2ad8:	0000247d 	andeq	r2, r0, sp, ror r4
    2adc:	1b126906 	blne	49cefc <__bss_end+0x492c60>
    2ae0:	00000005 	andeq	r0, r0, r5
    2ae4:	00089708 	andeq	r9, r8, r8, lsl #14
    2ae8:	126b0600 	rsbne	r0, fp, #0, 12
    2aec:	00000241 	andeq	r0, r0, r1, asr #4
    2af0:	06430810 			; <UNDEFINED> instruction: 0x06430810
    2af4:	6d060000 	stcvs	0, cr0, [r6, #-0]
    2af8:	00008c16 	andeq	r8, r0, r6, lsl ip
    2afc:	52081400 	andpl	r1, r8, #0, 8
    2b00:	0600000e 	streq	r0, [r0], -lr
    2b04:	052b1c70 	streq	r1, [fp, #-3184]!	; 0xfffff390
    2b08:	08180000 	ldmdaeq	r8, {}	; <UNPREDICTABLE>
    2b0c:	000012e0 	andeq	r1, r0, r0, ror #5
    2b10:	2b1c7206 	blcs	71f330 <__bss_end+0x715094>
    2b14:	1c000005 	stcne	0, cr0, [r0], {5}
    2b18:	0004dc08 	andeq	sp, r4, r8, lsl #24
    2b1c:	1c750600 	ldclne	6, cr0, [r5], #-0
    2b20:	0000052b 	andeq	r0, r0, fp, lsr #10
    2b24:	0ee71520 	cdpeq	5, 14, cr1, cr7, cr0, {1}
    2b28:	77060000 	strvc	r0, [r6, -r0]
    2b2c:	0012231c 	andseq	r2, r2, ip, lsl r3
    2b30:	00052b00 	andeq	r2, r5, r0, lsl #22
    2b34:	00042900 	andeq	r2, r4, r0, lsl #18
    2b38:	052b0a00 	streq	r0, [fp, #-2560]!	; 0xfffff600
    2b3c:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    2b40:	00000002 	andeq	r0, r0, r2
    2b44:	13181000 	tstne	r8, #0
    2b48:	06180000 	ldreq	r0, [r8], -r0
    2b4c:	046a107b 	strbteq	r1, [sl], #-123	; 0xffffff85
    2b50:	7d080000 	stcvc	0, cr0, [r8, #-0]
    2b54:	06000024 	streq	r0, [r0], -r4, lsr #32
    2b58:	051b127e 	ldreq	r1, [fp, #-638]	; 0xfffffd82
    2b5c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2b60:	00000536 	andeq	r0, r0, r6, lsr r5
    2b64:	58198006 	ldmdapl	r9, {r1, r2, pc}
    2b68:	10000002 	andne	r0, r0, r2
    2b6c:	000a8a08 	andeq	r8, sl, r8, lsl #20
    2b70:	21820600 	orrcs	r0, r2, r0, lsl #12
    2b74:	00000536 	andeq	r0, r0, r6, lsr r5
    2b78:	35030014 	strcc	r0, [r3, #-20]	; 0xffffffec
    2b7c:	16000004 	strne	r0, [r0], -r4
    2b80:	0000048f 	andeq	r0, r0, pc, lsl #9
    2b84:	3c218606 	stccc	6, cr8, [r1], #-24	; 0xffffffe8
    2b88:	16000005 	strne	r0, [r0], -r5
    2b8c:	000008c1 	andeq	r0, r0, r1, asr #17
    2b90:	981f8806 	ldmdals	pc, {r1, r2, fp, pc}	; <UNPREDICTABLE>
    2b94:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2b98:	00000e84 	andeq	r0, r0, r4, lsl #29
    2b9c:	ba178b06 	blt	5e57bc <__bss_end+0x5db520>
    2ba0:	00000003 	andeq	r0, r0, r3
    2ba4:	0007f908 	andeq	pc, r7, r8, lsl #18
    2ba8:	178e0600 	strne	r0, [lr, r0, lsl #12]
    2bac:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    2bb0:	0bd70824 	bleq	ff5c4c48 <__bss_end+0xff5ba9ac>
    2bb4:	8f060000 	svchi	0x00060000
    2bb8:	0003ba17 	andeq	fp, r3, r7, lsl sl
    2bbc:	e5084800 	str	r4, [r8, #-2048]	; 0xfffff800
    2bc0:	06000009 	streq	r0, [r0], -r9
    2bc4:	03ba1790 			; <UNDEFINED> instruction: 0x03ba1790
    2bc8:	096c0000 	stmdbeq	ip!, {}^	; <UNPREDICTABLE>
    2bcc:	000004e1 	andeq	r0, r0, r1, ror #9
    2bd0:	c0099306 	andgt	r9, r9, r6, lsl #6
    2bd4:	4700000d 	strmi	r0, [r0, -sp]
    2bd8:	01000005 	tsteq	r0, r5
    2bdc:	000004d4 	ldrdeq	r0, [r0], -r4
    2be0:	000004da 	ldrdeq	r0, [r0], -sl
    2be4:	0005470a 	andeq	r4, r5, sl, lsl #14
    2be8:	dc0c0000 	stcle	0, cr0, [ip], {-0}
    2bec:	0600000e 	streq	r0, [r0], -lr
    2bf0:	05170e96 	ldreq	r0, [r7, #-3734]	; 0xfffff16a
    2bf4:	ef010000 	svc	0x00010000
    2bf8:	f5000004 			; <UNDEFINED> instruction: 0xf5000004
    2bfc:	0a000004 	beq	2c14 <shift+0x2c14>
    2c00:	00000547 	andeq	r0, r0, r7, asr #10
    2c04:	08921700 	ldmeq	r2, {r8, r9, sl, ip}
    2c08:	99060000 	stmdbls	r6, {}	; <UNPREDICTABLE>
    2c0c:	000ceb10 	andeq	lr, ip, r0, lsl fp
    2c10:	00054d00 	andeq	r4, r5, r0, lsl #26
    2c14:	050a0100 	streq	r0, [sl, #-256]	; 0xffffff00
    2c18:	470a0000 	strmi	r0, [sl, -r0]
    2c1c:	0b000005 	bleq	2c38 <shift+0x2c38>
    2c20:	00000258 	andeq	r0, r0, r8, asr r2
    2c24:	0003830b 	andeq	r8, r3, fp, lsl #6
    2c28:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2c2c:	00000025 	andeq	r0, r0, r5, lsr #32
    2c30:	0000052b 	andeq	r0, r0, fp, lsr #10
    2c34:	00009d19 	andeq	r9, r0, r9, lsl sp
    2c38:	0e000f00 	cdpeq	15, 0, cr0, cr0, cr0, {0}
    2c3c:	0003ba04 	andeq	fp, r3, r4, lsl #20
    2c40:	11f81400 	mvnsne	r1, r0, lsl #8
    2c44:	040e0000 	streq	r0, [lr], #-0
    2c48:	00000531 	andeq	r0, r0, r1, lsr r5
    2c4c:	00046a18 	andeq	r6, r4, r8, lsl sl
    2c50:	00054700 	andeq	r4, r5, r0, lsl #14
    2c54:	0e001a00 	vmlaeq.f32	s2, s0, s0
    2c58:	0003ad04 	andeq	sl, r3, r4, lsl #26
    2c5c:	a8040e00 	stmdage	r4, {r9, sl, fp}
    2c60:	1b000003 	blne	2c74 <shift+0x2c74>
    2c64:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2c68:	ad149c06 	ldcge	12, cr9, [r4, #-24]	; 0xffffffe8
    2c6c:	06000003 	streq	r0, [r0], -r3
    2c70:	00000658 	andeq	r0, r0, r8, asr r6
    2c74:	98140407 	ldmdals	r4, {r0, r1, r2, sl}
    2c78:	05000000 	streq	r0, [r0, #-0]
    2c7c:	009fec03 	addseq	lr, pc, r3, lsl #24
    2c80:	0f430600 	svceq	0x00430600
    2c84:	07070000 	streq	r0, [r7, -r0]
    2c88:	00009814 	andeq	r9, r0, r4, lsl r8
    2c8c:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
    2c90:	0600009f 			; <UNDEFINED> instruction: 0x0600009f
    2c94:	00000504 	andeq	r0, r0, r4, lsl #10
    2c98:	98140a07 	ldmdals	r4, {r0, r1, r2, r9, fp}
    2c9c:	05000000 	streq	r0, [r0, #-0]
    2ca0:	009ff403 	addseq	pc, pc, r3, lsl #8
    2ca4:	078c1200 	streq	r1, [ip, r0, lsl #4]
    2ca8:	04050000 	streq	r0, [r5], #-0
    2cac:	00000049 	andeq	r0, r0, r9, asr #32
    2cb0:	cc0c0d07 	stcgt	13, cr0, [ip], {7}
    2cb4:	1c000005 	stcne	0, cr0, [r0], {5}
    2cb8:	0077654e 	rsbseq	r6, r7, lr, asr #10
    2cbc:	09751300 	ldmdbeq	r5!, {r8, r9, ip}^
    2cc0:	13010000 	movwne	r0, #4096	; 0x1000
    2cc4:	000004fc 	strdeq	r0, [r0], -ip
    2cc8:	07c71302 	strbeq	r1, [r7, r2, lsl #6]
    2ccc:	13030000 	movwne	r0, #12288	; 0x3000
    2cd0:	000010eb 	andeq	r1, r0, fp, ror #1
    2cd4:	04d51304 	ldrbeq	r1, [r5], #772	; 0x304
    2cd8:	00050000 	andeq	r0, r5, r0
    2cdc:	00067110 	andeq	r7, r6, r0, lsl r1
    2ce0:	1b071000 	blne	1c6ce8 <__bss_end+0x1bca4c>
    2ce4:	00060b08 	andeq	r0, r6, r8, lsl #22
    2ce8:	726c1100 	rsbvc	r1, ip, #0, 2
    2cec:	131d0700 	tstne	sp, #0, 14
    2cf0:	0000060b 	andeq	r0, r0, fp, lsl #12
    2cf4:	70731100 	rsbsvc	r1, r3, r0, lsl #2
    2cf8:	131e0700 	tstne	lr, #0, 14
    2cfc:	0000060b 	andeq	r0, r0, fp, lsl #12
    2d00:	63701104 	cmnvs	r0, #4, 2
    2d04:	131f0700 	tstne	pc, #0, 14
    2d08:	0000060b 	andeq	r0, r0, fp, lsl #12
    2d0c:	0ef20808 	cdpeq	8, 15, cr0, cr2, cr8, {0}
    2d10:	20070000 	andcs	r0, r7, r0
    2d14:	00060b13 	andeq	r0, r6, r3, lsl fp
    2d18:	02000c00 	andeq	r0, r0, #0, 24
    2d1c:	079d0704 	ldreq	r0, [sp, r4, lsl #14]
    2d20:	0b030000 	bleq	c2d28 <__bss_end+0xb8a8c>
    2d24:	10000006 	andne	r0, r0, r6
    2d28:	00000941 	andeq	r0, r0, r1, asr #18
    2d2c:	08280770 	stmdaeq	r8!, {r4, r5, r6, r8, r9, sl}
    2d30:	000006a7 	andeq	r0, r0, r7, lsr #13
    2d34:	00084108 	andeq	r4, r8, r8, lsl #2
    2d38:	122a0700 	eorne	r0, sl, #0, 14
    2d3c:	000005cc 	andeq	r0, r0, ip, asr #11
    2d40:	69701100 	ldmdbvs	r0!, {r8, ip}^
    2d44:	2b070064 	blcs	1c2edc <__bss_end+0x1b8c40>
    2d48:	00009d12 	andeq	r9, r0, r2, lsl sp
    2d4c:	70081000 	andvc	r1, r8, r0
    2d50:	0700001e 	smladeq	r0, lr, r0, r0
    2d54:	0595112c 	ldreq	r1, [r5, #300]	; 0x12c
    2d58:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    2d5c:	000010cf 	andeq	r1, r0, pc, asr #1
    2d60:	9d122d07 	ldcls	13, cr2, [r2, #-28]	; 0xffffffe4
    2d64:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2d68:	0003a908 	andeq	sl, r3, r8, lsl #18
    2d6c:	122e0700 	eorne	r0, lr, #0, 14
    2d70:	0000009d 	muleq	r0, sp, r0
    2d74:	0f30081c 	svceq	0x0030081c
    2d78:	2f070000 	svccs	0x00070000
    2d7c:	0006a70c 	andeq	sl, r6, ip, lsl #14
    2d80:	85082000 	strhi	r2, [r8, #-0]
    2d84:	07000004 	streq	r0, [r0, -r4]
    2d88:	00490930 	subeq	r0, r9, r0, lsr r9
    2d8c:	08600000 	stmdaeq	r0!, {}^	; <UNPREDICTABLE>
    2d90:	00000b31 	andeq	r0, r0, r1, lsr fp
    2d94:	8c0e3107 	stfhis	f3, [lr], {7}
    2d98:	64000000 	strvs	r0, [r0], #-0
    2d9c:	000d9408 	andeq	r9, sp, r8, lsl #8
    2da0:	0e330700 	cdpeq	7, 3, cr0, cr3, cr0, {0}
    2da4:	0000008c 	andeq	r0, r0, ip, lsl #1
    2da8:	0d8b0868 	stceq	8, cr0, [fp, #416]	; 0x1a0
    2dac:	34070000 	strcc	r0, [r7], #-0
    2db0:	00008c0e 	andeq	r8, r0, lr, lsl #24
    2db4:	18006c00 	stmdane	r0, {sl, fp, sp, lr}
    2db8:	0000054d 	andeq	r0, r0, sp, asr #10
    2dbc:	000006b7 			; <UNDEFINED> instruction: 0x000006b7
    2dc0:	00009d19 	andeq	r9, r0, r9, lsl sp
    2dc4:	06000f00 	streq	r0, [r0], -r0, lsl #30
    2dc8:	000004ed 	andeq	r0, r0, sp, ror #9
    2dcc:	98140a08 	ldmdals	r4, {r3, r9, fp}
    2dd0:	05000000 	streq	r0, [r0, #-0]
    2dd4:	009ff803 	addseq	pc, pc, r3, lsl #16
    2dd8:	0b1c1200 	bleq	7075e0 <__bss_end+0x6fd344>
    2ddc:	04050000 	streq	r0, [r5], #-0
    2de0:	00000049 	andeq	r0, r0, r9, asr #32
    2de4:	e80c0d08 	stmda	ip, {r3, r8, sl, fp}
    2de8:	13000006 	movwne	r0, #6
    2dec:	00001337 	andeq	r1, r0, r7, lsr r3
    2df0:	119a1300 	orrsne	r1, sl, r0, lsl #6
    2df4:	00010000 	andeq	r0, r1, r0
    2df8:	00082610 	andeq	r2, r8, r0, lsl r6
    2dfc:	1b080c00 	blne	205e04 <__bss_end+0x1fbb68>
    2e00:	00071d08 	andeq	r1, r7, r8, lsl #26
    2e04:	058a0800 	streq	r0, [sl, #2048]	; 0x800
    2e08:	1d080000 	stcne	0, cr0, [r8, #-0]
    2e0c:	00071d19 	andeq	r1, r7, r9, lsl sp
    2e10:	dc080000 	stcle	0, cr0, [r8], {-0}
    2e14:	08000004 	stmdaeq	r0, {r2}
    2e18:	071d191e 			; <UNDEFINED> instruction: 0x071d191e
    2e1c:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    2e20:	00000b4c 	andeq	r0, r0, ip, asr #22
    2e24:	23131f08 	tstcs	r3, #8, 30
    2e28:	08000007 	stmdaeq	r0, {r0, r1, r2}
    2e2c:	e8040e00 	stmda	r4, {r9, sl, fp}
    2e30:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
    2e34:	00061704 	andeq	r1, r6, r4, lsl #14
    2e38:	0e930700 	cdpeq	7, 9, cr0, cr3, cr0, {0}
    2e3c:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
    2e40:	09ab0722 	stmibeq	fp!, {r1, r5, r8, r9, sl}
    2e44:	61080000 	mrsvs	r0, (UNDEF: 8)
    2e48:	0800000c 	stmdaeq	r0, {r2, r3}
    2e4c:	008c1226 	addeq	r1, ip, r6, lsr #4
    2e50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2e54:	00000bf4 	strdeq	r0, [r0], -r4
    2e58:	1d1d2908 	vldrne.16	s4, [sp, #-16]	; <UNPREDICTABLE>
    2e5c:	04000007 	streq	r0, [r0], #-7
    2e60:	0007cf08 	andeq	ip, r7, r8, lsl #30
    2e64:	1d2c0800 	stcne	8, cr0, [ip, #-0]
    2e68:	0000071d 	andeq	r0, r0, sp, lsl r7
    2e6c:	0d161d08 	ldceq	13, cr1, [r6, #-32]	; 0xffffffe0
    2e70:	2f080000 	svccs	0x00080000
    2e74:	0008030e 	andeq	r0, r8, lr, lsl #6
    2e78:	00077100 	andeq	r7, r7, r0, lsl #2
    2e7c:	00077c00 	andeq	r7, r7, r0, lsl #24
    2e80:	09b00a00 	ldmibeq	r0!, {r9, fp}
    2e84:	1d0b0000 	stcne	0, cr0, [fp, #-0]
    2e88:	00000007 	andeq	r0, r0, r7
    2e8c:	00097e1e 	andeq	r7, r9, lr, lsl lr
    2e90:	0e310800 	cdpeq	8, 3, cr0, cr1, cr0, {0}
    2e94:	00000918 	andeq	r0, r0, r8, lsl r9
    2e98:	00000241 	andeq	r0, r0, r1, asr #4
    2e9c:	00000794 	muleq	r0, r4, r7
    2ea0:	0000079f 	muleq	r0, pc, r7	; <UNPREDICTABLE>
    2ea4:	0009b00a 	andeq	fp, r9, sl
    2ea8:	07230b00 	streq	r0, [r3, -r0, lsl #22]!
    2eac:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2eb0:	00001146 	andeq	r1, r0, r6, asr #2
    2eb4:	cc1d3508 	cfldr32gt	mvfx3, [sp], {8}
    2eb8:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
    2ebc:	02000007 	andeq	r0, r0, #7
    2ec0:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    2ec4:	000007be 			; <UNDEFINED> instruction: 0x000007be
    2ec8:	0009b00a 	andeq	fp, r9, sl
    2ecc:	af090000 	svcge	0x00090000
    2ed0:	08000007 	stmdaeq	r0, {r0, r1, r2}
    2ed4:	0d261d37 	stceq	13, cr1, [r6, #-220]!	; 0xffffff24
    2ed8:	071d0000 	ldreq	r0, [sp, -r0]
    2edc:	d7020000 	strle	r0, [r2, -r0]
    2ee0:	dd000007 	stcle	0, cr0, [r0, #-28]	; 0xffffffe4
    2ee4:	0a000007 	beq	2f08 <shift+0x2f08>
    2ee8:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    2eec:	0c071f00 	stceq	15, cr1, [r7], {-0}
    2ef0:	39080000 	stmdbcc	r8, {}	; <UNPREDICTABLE>
    2ef4:	0009c931 	andeq	ip, r9, r1, lsr r9
    2ef8:	09020c00 	stmdbeq	r2, {sl, fp}
    2efc:	00000e93 	muleq	r0, r3, lr
    2f00:	8d093c08 	stchi	12, cr3, [r9, #-32]	; 0xffffffe0
    2f04:	b0000009 	andlt	r0, r0, r9
    2f08:	01000009 	tsteq	r0, r9
    2f0c:	00000804 	andeq	r0, r0, r4, lsl #16
    2f10:	0000080a 	andeq	r0, r0, sl, lsl #16
    2f14:	0009b00a 	andeq	fp, r9, sl
    2f18:	53090000 	movwpl	r0, #36864	; 0x9000
    2f1c:	08000008 	stmdaeq	r0, {r3}
    2f20:	055f123f 	ldrbeq	r1, [pc, #-575]	; 2ce9 <shift+0x2ce9>
    2f24:	008c0000 	addeq	r0, ip, r0
    2f28:	23010000 	movwcs	r0, #4096	; 0x1000
    2f2c:	38000008 	stmdacc	r0, {r3}
    2f30:	0a000008 	beq	2f58 <shift+0x2f58>
    2f34:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    2f38:	0009d20b 	andeq	sp, r9, fp, lsl #4
    2f3c:	009d0b00 	addseq	r0, sp, r0, lsl #22
    2f40:	410b0000 	mrsmi	r0, (UNDEF: 11)
    2f44:	00000002 	andeq	r0, r0, r2
    2f48:	0011700c 	andseq	r7, r1, ip
    2f4c:	0e420800 	cdpeq	8, 4, cr0, cr2, cr0, {0}
    2f50:	0000067e 	andeq	r0, r0, lr, ror r6
    2f54:	00084d01 	andeq	r4, r8, r1, lsl #26
    2f58:	00085300 	andeq	r5, r8, r0, lsl #6
    2f5c:	09b00a00 	ldmibeq	r0!, {r9, fp}
    2f60:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2f64:	00000541 	andeq	r0, r0, r1, asr #10
    2f68:	fc174508 	ldc2	5, cr4, [r7], {8}
    2f6c:	23000005 	movwcs	r0, #5
    2f70:	01000007 	tsteq	r0, r7
    2f74:	0000086c 	andeq	r0, r0, ip, ror #16
    2f78:	00000872 	andeq	r0, r0, r2, ror r8
    2f7c:	0009d80a 	andeq	sp, r9, sl, lsl #16
    2f80:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
    2f84:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
    2f88:	03bf1748 			; <UNDEFINED> instruction: 0x03bf1748
    2f8c:	07230000 	streq	r0, [r3, -r0]!
    2f90:	8b010000 	blhi	42f98 <__bss_end+0x38cfc>
    2f94:	96000008 	strls	r0, [r0], -r8
    2f98:	0a000008 	beq	2fc0 <shift+0x2fc0>
    2f9c:	000009d8 	ldrdeq	r0, [r0], -r8
    2fa0:	00008c0b 	andeq	r8, r0, fp, lsl #24
    2fa4:	f10c0000 	cpsid	
    2fa8:	08000006 	stmdaeq	r0, {r1, r2}
    2fac:	0c150e4b 	ldceq	14, cr0, [r5], {75}	; 0x4b
    2fb0:	ab010000 	blge	42fb8 <__bss_end+0x38d1c>
    2fb4:	b1000008 	tstlt	r0, r8
    2fb8:	0a000008 	beq	2fe0 <shift+0x2fe0>
    2fbc:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    2fc0:	097e0900 	ldmdbeq	lr!, {r8, fp}^
    2fc4:	4d080000 	stcmi	0, cr0, [r8, #-0]
    2fc8:	000dd50e 	andeq	sp, sp, lr, lsl #10
    2fcc:	00024100 	andeq	r4, r2, r0, lsl #2
    2fd0:	08ca0100 	stmiaeq	sl, {r8}^
    2fd4:	08d50000 	ldmeq	r5, {}^	; <UNPREDICTABLE>
    2fd8:	b00a0000 	andlt	r0, sl, r0
    2fdc:	0b000009 	bleq	3008 <shift+0x3008>
    2fe0:	0000008c 	andeq	r0, r0, ip, lsl #1
    2fe4:	04c10900 	strbeq	r0, [r1], #2304	; 0x900
    2fe8:	50080000 	andpl	r0, r8, r0
    2fec:	0003ec12 	andeq	lr, r3, r2, lsl ip
    2ff0:	00008c00 	andeq	r8, r0, r0, lsl #24
    2ff4:	08ee0100 	stmiaeq	lr!, {r8}^
    2ff8:	08f90000 	ldmeq	r9!, {}^	; <UNPREDICTABLE>
    2ffc:	b00a0000 	andlt	r0, sl, r0
    3000:	0b000009 	bleq	302c <shift+0x302c>
    3004:	0000054d 	andeq	r0, r0, sp, asr #10
    3008:	041f0900 	ldreq	r0, [pc], #-2304	; 3010 <shift+0x3010>
    300c:	53080000 	movwpl	r0, #32768	; 0x8000
    3010:	0011c60e 	andseq	ip, r1, lr, lsl #12
    3014:	00024100 	andeq	r4, r2, r0, lsl #2
    3018:	09120100 	ldmdbeq	r2, {r8}
    301c:	091d0000 	ldmdbeq	sp, {}	; <UNPREDICTABLE>
    3020:	b00a0000 	andlt	r0, sl, r0
    3024:	0b000009 	bleq	3050 <shift+0x3050>
    3028:	0000008c 	andeq	r0, r0, ip, lsl #1
    302c:	049b0c00 	ldreq	r0, [fp], #3072	; 0xc00
    3030:	56080000 	strpl	r0, [r8], -r0
    3034:	0010480e 	andseq	r4, r0, lr, lsl #16
    3038:	09320100 	ldmdbeq	r2!, {r8}
    303c:	09510000 	ldmdbeq	r1, {}^	; <UNPREDICTABLE>
    3040:	b00a0000 	andlt	r0, sl, r0
    3044:	0b000009 	bleq	3070 <shift+0x3070>
    3048:	00000291 	muleq	r0, r1, r2
    304c:	00008c0b 	andeq	r8, r0, fp, lsl #24
    3050:	008c0b00 	addeq	r0, ip, r0, lsl #22
    3054:	8c0b0000 	stchi	0, cr0, [fp], {-0}
    3058:	0b000000 	bleq	3060 <shift+0x3060>
    305c:	000009de 	ldrdeq	r0, [r0], -lr
    3060:	12530c00 	subsne	r0, r3, #0, 24
    3064:	58080000 	stmdapl	r8, {}	; <UNPREDICTABLE>
    3068:	00134c0e 	andseq	r4, r3, lr, lsl #24
    306c:	09660100 	stmdbeq	r6!, {r8}^
    3070:	09850000 	stmibeq	r5, {}	; <UNPREDICTABLE>
    3074:	b00a0000 	andlt	r0, sl, r0
    3078:	0b000009 	bleq	30a4 <shift+0x30a4>
    307c:	000002c8 	andeq	r0, r0, r8, asr #5
    3080:	00008c0b 	andeq	r8, r0, fp, lsl #24
    3084:	008c0b00 	addeq	r0, ip, r0, lsl #22
    3088:	8c0b0000 	stchi	0, cr0, [fp], {-0}
    308c:	0b000000 	bleq	3094 <shift+0x3094>
    3090:	000009de 	ldrdeq	r0, [r0], -lr
    3094:	04ae1700 	strteq	r1, [lr], #1792	; 0x700
    3098:	5b080000 	blpl	2030a0 <__bss_end+0x1f8e04>
    309c:	000b770e 	andeq	r7, fp, lr, lsl #14
    30a0:	00024100 	andeq	r4, r2, r0, lsl #2
    30a4:	099a0100 	ldmibeq	sl, {r8}
    30a8:	b00a0000 	andlt	r0, sl, r0
    30ac:	0b000009 	bleq	30d8 <shift+0x30d8>
    30b0:	000006c9 	andeq	r0, r0, r9, asr #13
    30b4:	00025e0b 	andeq	r5, r2, fp, lsl #28
    30b8:	03000000 	movweq	r0, #0
    30bc:	00000729 	andeq	r0, r0, r9, lsr #14
    30c0:	0729040e 	streq	r0, [r9, -lr, lsl #8]!
    30c4:	1d200000 	stcne	0, cr0, [r0, #-0]
    30c8:	c3000007 	movwgt	r0, #7
    30cc:	c9000009 	stmdbgt	r0, {r0, r3}
    30d0:	0a000009 	beq	30fc <shift+0x30fc>
    30d4:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    30d8:	07292100 	streq	r2, [r9, -r0, lsl #2]!
    30dc:	09b60000 	ldmibeq	r6!, {}	; <UNPREDICTABLE>
    30e0:	040e0000 	streq	r0, [lr], #-0
    30e4:	0000006d 	andeq	r0, r0, sp, rrx
    30e8:	09ab040e 	stmibeq	fp!, {r1, r2, r3, sl}
    30ec:	04220000 	strteq	r0, [r2], #-0
    30f0:	0000026b 	andeq	r0, r0, fp, ror #4
    30f4:	0012b51b 	andseq	fp, r2, fp, lsl r5
    30f8:	195e0800 	ldmdbne	lr, {fp}^
    30fc:	00000729 	andeq	r0, r0, r9, lsr #14
    3100:	00132e06 	andseq	r2, r3, r6, lsl #28
    3104:	11040900 	tstne	r4, r0, lsl #18
    3108:	00000a09 	andeq	r0, r0, r9, lsl #20
    310c:	9ffc0305 	svcls	0x00fc0305
    3110:	04020000 	streq	r0, [r2], #-0
    3114:	001eee04 	andseq	lr, lr, r4, lsl #28
    3118:	0a020300 	beq	83d20 <__bss_end+0x79a84>
    311c:	72120000 	andsvc	r0, r2, #0
    3120:	0700001b 	smladeq	r0, fp, r0, r0
    3124:	00005c01 	andeq	r5, r0, r1, lsl #24
    3128:	0c060a00 			; <UNDEFINED> instruction: 0x0c060a00
    312c:	00000a3f 	andeq	r0, r0, pc, lsr sl
    3130:	706f4e1c 	rsbvc	r4, pc, ip, lsl lr	; <UNPREDICTABLE>
    3134:	d3130000 	tstle	r3, #0
    3138:	0100000f 	tsteq	r0, pc
    313c:	000a1d13 	andeq	r1, sl, r3, lsl sp
    3140:	89130200 	ldmdbhi	r3, {r9}
    3144:	0300001b 	movweq	r0, #27
    3148:	001ae913 	andseq	lr, sl, r3, lsl r9
    314c:	10000400 	andne	r0, r0, r0, lsl #8
    3150:	00001b02 	andeq	r1, r0, r2, lsl #22
    3154:	08220a05 	stmdaeq	r2!, {r0, r2, r9, fp}
    3158:	00000a70 	andeq	r0, r0, r0, ror sl
    315c:	0a007811 	beq	211a8 <__bss_end+0x16f0c>
    3160:	00740e24 	rsbseq	r0, r4, r4, lsr #28
    3164:	11000000 	mrsne	r0, (UNDEF: 0)
    3168:	250a0079 	strcs	r0, [sl, #-121]	; 0xffffff87
    316c:	0000740e 	andeq	r7, r0, lr, lsl #8
    3170:	73110200 	tstvc	r1, #0, 4
    3174:	0a007465 	beq	20310 <__bss_end+0x16074>
    3178:	005c0d26 	subseq	r0, ip, r6, lsr #26
    317c:	00040000 	andeq	r0, r4, r0
    3180:	001a3f10 	andseq	r3, sl, r0, lsl pc
    3184:	2a0a0100 	bcs	28358c <__bss_end+0x2792f0>
    3188:	000a8b08 	andeq	r8, sl, r8, lsl #22
    318c:	6d631100 	stfvse	f1, [r3, #-0]
    3190:	2c0a0064 	stccs	0, cr0, [sl], {100}	; 0x64
    3194:	000a0e16 	andeq	r0, sl, r6, lsl lr
    3198:	10000000 	andne	r0, r0, r0
    319c:	00001a56 	andeq	r1, r0, r6, asr sl
    31a0:	08300a01 	ldmdaeq	r0!, {r0, r9, fp}
    31a4:	00000aa6 	andeq	r0, r0, r6, lsr #21
    31a8:	001bd008 	andseq	sp, fp, r8
    31ac:	1c320a00 			; <UNDEFINED> instruction: 0x1c320a00
    31b0:	00000a70 	andeq	r0, r0, r0, ror sl
    31b4:	47100000 	ldrmi	r0, [r0, -r0]
    31b8:	0200001b 	andeq	r0, r0, #27
    31bc:	ce08360a 	cfmadd32gt	mvax0, mvfx3, mvfx8, mvfx10
    31c0:	0800000a 	stmdaeq	r0, {r1, r3}
    31c4:	00001bd0 	ldrdeq	r1, [r0], -r0
    31c8:	701c380a 	andsvc	r3, ip, sl, lsl #16
    31cc:	0000000a 	andeq	r0, r0, sl
    31d0:	001b9a08 	andseq	r9, fp, r8, lsl #20
    31d4:	0d390a00 	vldmdbeq	r9!, {s0-s-1}
    31d8:	0000005c 	andeq	r0, r0, ip, asr r0
    31dc:	c8100001 	ldmdagt	r0, {r0}
    31e0:	0800001a 	stmdaeq	r0, {r1, r3, r4}
    31e4:	03083d0a 	movweq	r3, #36106	; 0x8d0a
    31e8:	0800000b 	stmdaeq	r0, {r0, r1, r3}
    31ec:	00001bd0 	ldrdeq	r1, [r0], -r0
    31f0:	701c3f0a 	andsvc	r3, ip, sl, lsl #30
    31f4:	0000000a 	andeq	r0, r0, sl
    31f8:	00157808 	andseq	r7, r5, r8, lsl #16
    31fc:	0e400a00 	vmlaeq.f32	s1, s0, s0
    3200:	00000074 	andeq	r0, r0, r4, ror r0
    3204:	1b830801 	blne	fe0c5210 <__bss_end+0xfe0baf74>
    3208:	420a0000 	andmi	r0, sl, #0
    320c:	000a3f19 	andeq	r3, sl, r9, lsl pc
    3210:	10000300 	andne	r0, r0, r0, lsl #6
    3214:	00001b1b 	andeq	r1, r0, fp, lsl fp
    3218:	08460a0b 	stmdaeq	r6, {r0, r1, r3, r9, fp}^
    321c:	00000b66 	andeq	r0, r0, r6, ror #22
    3220:	001bd008 	andseq	sp, fp, r8
    3224:	1c480a00 	mcrrne	10, 0, r0, r8, cr0
    3228:	00000a70 	andeq	r0, r0, r0, ror sl
    322c:	31781100 	cmncc	r8, r0, lsl #2
    3230:	0e490a00 	vmlaeq.f32	s1, s18, s0
    3234:	00000074 	andeq	r0, r0, r4, ror r0
    3238:	31791101 	cmncc	r9, r1, lsl #2
    323c:	12490a00 	subne	r0, r9, #0, 20
    3240:	00000074 	andeq	r0, r0, r4, ror r0
    3244:	00771103 	rsbseq	r1, r7, r3, lsl #2
    3248:	740e4a0a 	strvc	r4, [lr], #-2570	; 0xfffff5f6
    324c:	05000000 	streq	r0, [r0, #-0]
    3250:	0a006811 	beq	1d29c <__bss_end+0x13000>
    3254:	0074114a 	rsbseq	r1, r4, sl, asr #2
    3258:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
    325c:	00001a8b 	andeq	r1, r0, fp, lsl #21
    3260:	5c0d4b0a 			; <UNDEFINED> instruction: 0x5c0d4b0a
    3264:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3268:	001b8308 	andseq	r8, fp, r8, lsl #6
    326c:	0d4d0a00 	vstreq	s1, [sp, #-0]
    3270:	0000005c 	andeq	r0, r0, ip, asr r0
    3274:	6823000a 	stmdavs	r3!, {r1, r3}
    3278:	0b006c61 	bleq	1e404 <__bss_end+0x14168>
    327c:	0c200b05 			; <UNDEFINED> instruction: 0x0c200b05
    3280:	c4240000 	strtgt	r0, [r4], #-0
    3284:	0b00000b 	bleq	32b8 <shift+0x32b8>
    3288:	00a41907 	adceq	r1, r4, r7, lsl #18
    328c:	b2800000 	addlt	r0, r0, #0
    3290:	61240ee6 	smulwtvs	r4, r6, lr
    3294:	0b00000f 	bleq	32d8 <shift+0x32d8>
    3298:	06121a0a 	ldreq	r1, [r2], -sl, lsl #20
    329c:	00000000 	andeq	r0, r0, r0
    32a0:	55242000 	strpl	r2, [r4, #-0]!
    32a4:	0b000005 	bleq	32c0 <shift+0x32c0>
    32a8:	06121a0d 	ldreq	r1, [r2], -sp, lsl #20
    32ac:	00000000 	andeq	r0, r0, r0
    32b0:	3d252020 	stccc	0, cr2, [r5, #-128]!	; 0xffffff80
    32b4:	0b00000b 	bleq	32e8 <shift+0x32e8>
    32b8:	00981510 	addseq	r1, r8, r0, lsl r5
    32bc:	24360000 	ldrtcs	r0, [r6], #-0
    32c0:	00001152 	andeq	r1, r0, r2, asr r1
    32c4:	121a4b0b 	andsne	r4, sl, #11264	; 0x2c00
    32c8:	00000006 	andeq	r0, r0, r6
    32cc:	24202150 	strtcs	r2, [r0], #-336	; 0xfffffeb0
    32d0:	000012fe 	strdeq	r1, [r0], -lr
    32d4:	121a7a0b 	andsne	r7, sl, #45056	; 0xb000
    32d8:	00000006 	andeq	r0, r0, r6
    32dc:	242000b2 	strtcs	r0, [r0], #-178	; 0xffffff4e
    32e0:	000008b6 			; <UNDEFINED> instruction: 0x000008b6
    32e4:	121aad0b 	andsne	sl, sl, #704	; 0x2c0
    32e8:	00000006 	andeq	r0, r0, r6
    32ec:	242000b4 	strtcs	r0, [r0], #-180	; 0xffffff4c
    32f0:	00000bba 			; <UNDEFINED> instruction: 0x00000bba
    32f4:	121abc0b 	andsne	fp, sl, #2816	; 0xb00
    32f8:	00000006 	andeq	r0, r0, r6
    32fc:	24201040 	strtcs	r1, [r0], #-64	; 0xffffffc0
    3300:	00000d5f 	andeq	r0, r0, pc, asr sp
    3304:	121ac70b 	andsne	ip, sl, #2883584	; 0x2c0000
    3308:	00000006 	andeq	r0, r0, r6
    330c:	24202050 	strtcs	r2, [r0], #-80	; 0xffffffb0
    3310:	00000774 	andeq	r0, r0, r4, ror r7
    3314:	121ac80b 	andsne	ip, sl, #720896	; 0xb0000
    3318:	00000006 	andeq	r0, r0, r6
    331c:	24208040 	strtcs	r8, [r0], #-64	; 0xffffffc0
    3320:	0000115b 	andeq	r1, r0, fp, asr r1
    3324:	121ac90b 	andsne	ip, sl, #180224	; 0x2c000
    3328:	00000006 	andeq	r0, r0, r6
    332c:	00208050 	eoreq	r8, r0, r0, asr r0
    3330:	000b7226 	andeq	r7, fp, r6, lsr #4
    3334:	0b822600 	bleq	fe08cb3c <__bss_end+0xfe0828a0>
    3338:	92260000 	eorls	r0, r6, #0
    333c:	2600000b 	strcs	r0, [r0], -fp
    3340:	00000ba2 	andeq	r0, r0, r2, lsr #23
    3344:	000baf26 	andeq	sl, fp, r6, lsr #30
    3348:	0bbf2600 	bleq	fefccb50 <__bss_end+0xfefc28b4>
    334c:	cf260000 	svcgt	0x00260000
    3350:	2600000b 	strcs	r0, [r0], -fp
    3354:	00000bdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3358:	000bef26 	andeq	lr, fp, r6, lsr #30
    335c:	0bff2600 	bleq	fffccb64 <__bss_end+0xfffc28c8>
    3360:	0f260000 	svceq	0x00260000
    3364:	2700000c 	strcs	r0, [r0, -ip]
    3368:	00001b68 	andeq	r1, r0, r8, ror #22
    336c:	f30b040c 	vshl.u8	d0, d12, d11
    3370:	2500000e 	strcs	r0, [r0, #-14]
    3374:	00001b5d 	andeq	r1, r0, sp, asr fp
    3378:	8018070c 	andshi	r0, r8, ip, lsl #14
    337c:	06000000 	streq	r0, [r0], -r0
    3380:	001bc425 	andseq	ip, fp, r5, lsr #8
    3384:	18090c00 	stmdane	r9, {sl, fp}
    3388:	00000080 	andeq	r0, r0, r0, lsl #1
    338c:	1bd72508 	blne	ff5cc7b4 <__bss_end+0xff5c2518>
    3390:	0c0c0000 	stceq	0, cr0, [ip], {-0}
    3394:	00008018 	andeq	r8, r0, r8, lsl r0
    3398:	33252000 			; <UNDEFINED> instruction: 0x33252000
    339c:	0c00001b 	stceq	0, cr0, [r0], {27}
    33a0:	0080180e 	addeq	r1, r0, lr, lsl #16
    33a4:	25800000 	strcs	r0, [r0]
    33a8:	00001b3c 	andeq	r1, r0, ip, lsr fp
    33ac:	4814110c 	ldmdami	r4, {r2, r3, r8, ip}
    33b0:	01000002 	tsteq	r0, r2
    33b4:	001a7928 	andseq	r7, sl, r8, lsr #18
    33b8:	13140c00 	tstne	r4, #0, 24
    33bc:	00000f1d 	andeq	r0, r0, sp, lsl pc
    33c0:	00000240 	andeq	r0, r0, r0, asr #4
    33c4:	00000000 	andeq	r0, r0, r0
    33c8:	2f000000 	svccs	0x00000000
    33cc:	00000000 	andeq	r0, r0, r0
    33d0:	00070007 	andeq	r0, r7, r7
    33d4:	147f1400 	ldrbtne	r1, [pc], #-1024	; 33dc <shift+0x33dc>
    33d8:	2400147f 	strcs	r1, [r0], #-1151	; 0xfffffb81
    33dc:	122a7f2a 	eorne	r7, sl, #42, 30	; 0xa8
    33e0:	08132300 	ldmdaeq	r3, {r8, r9, sp}
    33e4:	36006264 	strcc	r6, [r0], -r4, ror #4
    33e8:	50225549 	eorpl	r5, r2, r9, asr #10
    33ec:	03050000 	movweq	r0, #20480	; 0x5000
    33f0:	00000000 	andeq	r0, r0, r0
    33f4:	0041221c 	subeq	r2, r1, ip, lsl r2
    33f8:	22410000 	subcs	r0, r1, #0
    33fc:	1400001c 	strne	r0, [r0], #-28	; 0xffffffe4
    3400:	14083e08 	strne	r3, [r8], #-3592	; 0xfffff1f8
    3404:	3e080800 	cdpcc	8, 0, cr0, cr8, cr0, {0}
    3408:	00000808 	andeq	r0, r0, r8, lsl #16
    340c:	0060a000 	rsbeq	sl, r0, r0
    3410:	08080800 	stmdaeq	r8, {fp}
    3414:	00000808 	andeq	r0, r0, r8, lsl #16
    3418:	00006060 	andeq	r6, r0, r0, rrx
    341c:	08102000 	ldmdaeq	r0, {sp}
    3420:	3e000204 	cdpcc	2, 0, cr0, cr0, cr4, {0}
    3424:	3e454951 			; <UNDEFINED> instruction: 0x3e454951
    3428:	7f420000 	svcvc	0x00420000
    342c:	42000040 	andmi	r0, r0, #64	; 0x40
    3430:	46495161 	strbmi	r5, [r9], -r1, ror #2
    3434:	45412100 	strbmi	r2, [r1, #-256]	; 0xffffff00
    3438:	1800314b 	stmdane	r0, {r0, r1, r3, r6, r8, ip, sp}
    343c:	107f1214 	rsbsne	r1, pc, r4, lsl r2	; <UNPREDICTABLE>
    3440:	45452700 	strbmi	r2, [r5, #-1792]	; 0xfffff900
    3444:	3c003945 			; <UNDEFINED> instruction: 0x3c003945
    3448:	3049494a 	subcc	r4, r9, sl, asr #18
    344c:	09710100 	ldmdbeq	r1!, {r8}^
    3450:	36000305 	strcc	r0, [r0], -r5, lsl #6
    3454:	36494949 	strbcc	r4, [r9], -r9, asr #18
    3458:	49490600 	stmdbmi	r9, {r9, sl}^
    345c:	00001e29 	andeq	r1, r0, r9, lsr #28
    3460:	00003636 	andeq	r3, r0, r6, lsr r6
    3464:	36560000 	ldrbcc	r0, [r6], -r0
    3468:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    346c:	00412214 	subeq	r2, r1, r4, lsl r2
    3470:	14141400 	ldrne	r1, [r4], #-1024	; 0xfffffc00
    3474:	00001414 	andeq	r1, r0, r4, lsl r4
    3478:	08142241 	ldmdaeq	r4, {r0, r6, r9, sp}
    347c:	51010200 	mrspl	r0, R9_usr
    3480:	32000609 	andcc	r0, r0, #9437184	; 0x900000
    3484:	3e515949 	vnmlacc.f16	s11, s2, s18	; <UNPREDICTABLE>
    3488:	11127c00 	tstne	r2, r0, lsl #24
    348c:	7f007c12 	svcvc	0x00007c12
    3490:	36494949 	strbcc	r4, [r9], -r9, asr #18
    3494:	41413e00 	cmpmi	r1, r0, lsl #28
    3498:	7f002241 	svcvc	0x00002241
    349c:	1c224141 	stfnes	f4, [r2], #-260	; 0xfffffefc
    34a0:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    34a4:	7f004149 	svcvc	0x00004149
    34a8:	01090909 	tsteq	r9, r9, lsl #18
    34ac:	49413e00 	stmdbmi	r1, {r9, sl, fp, ip, sp}^
    34b0:	7f007a49 	svcvc	0x00007a49
    34b4:	7f080808 	svcvc	0x00080808
    34b8:	7f410000 	svcvc	0x00410000
    34bc:	20000041 	andcs	r0, r0, r1, asr #32
    34c0:	013f4140 	teqeq	pc, r0, asr #2
    34c4:	14087f00 	strne	r7, [r8], #-3840	; 0xfffff100
    34c8:	7f004122 	svcvc	0x00004122
    34cc:	40404040 	submi	r4, r0, r0, asr #32
    34d0:	0c027f00 	stceq	15, cr7, [r2], {-0}
    34d4:	7f007f02 	svcvc	0x00007f02
    34d8:	7f100804 	svcvc	0x00100804
    34dc:	41413e00 	cmpmi	r1, r0, lsl #28
    34e0:	7f003e41 	svcvc	0x00003e41
    34e4:	06090909 	streq	r0, [r9], -r9, lsl #18
    34e8:	51413e00 	cmppl	r1, r0, lsl #28
    34ec:	7f005e21 	svcvc	0x00005e21
    34f0:	46291909 	strtmi	r1, [r9], -r9, lsl #18
    34f4:	49494600 	stmdbmi	r9, {r9, sl, lr}^
    34f8:	01003149 	tsteq	r0, r9, asr #2
    34fc:	01017f01 	tsteq	r1, r1, lsl #30
    3500:	40403f00 	submi	r3, r0, r0, lsl #30
    3504:	1f003f40 	svcne	0x00003f40
    3508:	1f204020 	svcne	0x00204020
    350c:	38403f00 	stmdacc	r0, {r8, r9, sl, fp, ip, sp}^
    3510:	63003f40 	movwvs	r3, #3904	; 0xf40
    3514:	63140814 	tstvs	r4, #20, 16	; 0x140000
    3518:	70080700 	andvc	r0, r8, r0, lsl #14
    351c:	61000708 	tstvs	r0, r8, lsl #14
    3520:	43454951 	movtmi	r4, #22865	; 0x5951
    3524:	417f0000 	cmnmi	pc, r0
    3528:	55000041 	strpl	r0, [r0, #-65]	; 0xffffffbf
    352c:	552a552a 	strpl	r5, [sl, #-1322]!	; 0xfffffad6
    3530:	41410000 	mrsmi	r0, (UNDEF: 65)
    3534:	0400007f 	streq	r0, [r0], #-127	; 0xffffff81
    3538:	04020102 	streq	r0, [r2], #-258	; 0xfffffefe
    353c:	40404000 	submi	r4, r0, r0
    3540:	00004040 	andeq	r4, r0, r0, asr #32
    3544:	00040201 	andeq	r0, r4, r1, lsl #4
    3548:	54542000 	ldrbpl	r2, [r4], #-0
    354c:	7f007854 	svcvc	0x00007854
    3550:	38444448 	stmdacc	r4, {r3, r6, sl, lr}^
    3554:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    3558:	38002044 	stmdacc	r0, {r2, r6, sp}
    355c:	7f484444 	svcvc	0x00484444
    3560:	54543800 	ldrbpl	r3, [r4], #-2048	; 0xfffff800
    3564:	08001854 	stmdaeq	r0, {r2, r4, r6, fp, ip}
    3568:	0201097e 	andeq	r0, r1, #2064384	; 0x1f8000
    356c:	a4a41800 	strtge	r1, [r4], #2048	; 0x800
    3570:	7f007ca4 	svcvc	0x00007ca4
    3574:	78040408 	stmdavc	r4, {r3, sl}
    3578:	7d440000 	stclvc	0, cr0, [r4, #-0]
    357c:	40000040 	andmi	r0, r0, r0, asr #32
    3580:	007d8480 	rsbseq	r8, sp, r0, lsl #9
    3584:	28107f00 	ldmdacs	r0, {r8, r9, sl, fp, ip, sp, lr}
    3588:	00000044 	andeq	r0, r0, r4, asr #32
    358c:	00407f41 	subeq	r7, r0, r1, asr #30
    3590:	18047c00 	stmdane	r4, {sl, fp, ip, sp, lr}
    3594:	7c007804 	stcvc	8, cr7, [r0], {4}
    3598:	78040408 	stmdavc	r4, {r3, sl}
    359c:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    35a0:	fc003844 	stc2	8, cr3, [r0], {68}	; 0x44
    35a4:	18242424 	stmdane	r4!, {r2, r5, sl, sp}
    35a8:	24241800 	strtcs	r1, [r4], #-2048	; 0xfffff800
    35ac:	7c00fc18 	stcvc	12, cr15, [r0], {24}
    35b0:	08040408 	stmdaeq	r4, {r3, sl}
    35b4:	54544800 	ldrbpl	r4, [r4], #-2048	; 0xfffff800
    35b8:	04002054 	streq	r2, [r0], #-84	; 0xffffffac
    35bc:	2040443f 	subcs	r4, r0, pc, lsr r4
    35c0:	40403c00 	submi	r3, r0, r0, lsl #24
    35c4:	1c007c20 	stcne	12, cr7, [r0], {32}
    35c8:	1c204020 	stcne	0, cr4, [r0], #-128	; 0xffffff80
    35cc:	30403c00 	subcc	r3, r0, r0, lsl #24
    35d0:	44003c40 	strmi	r3, [r0], #-3136	; 0xfffff3c0
    35d4:	44281028 	strtmi	r1, [r8], #-40	; 0xffffffd8
    35d8:	a0a01c00 	adcge	r1, r0, r0, lsl #24
    35dc:	44007ca0 	strmi	r7, [r0], #-3232	; 0xfffff360
    35e0:	444c5464 	strbmi	r5, [ip], #-1124	; 0xfffffb9c
    35e4:	77080000 	strvc	r0, [r8, -r0]
    35e8:	00000000 	andeq	r0, r0, r0
    35ec:	00007f00 	andeq	r7, r0, r0, lsl #30
    35f0:	08770000 	ldmdaeq	r7!, {}^	; <UNPREDICTABLE>
    35f4:	10000000 	andne	r0, r0, r0
    35f8:	00081008 	andeq	r1, r8, r8
    35fc:	00000000 	andeq	r0, r0, r0
    3600:	26000000 	strcs	r0, [r0], -r0
    3604:	00000c63 	andeq	r0, r0, r3, ror #24
    3608:	000c7026 	andeq	r7, ip, r6, lsr #32
    360c:	0c7d2600 	ldcleq	6, cr2, [sp], #-0
    3610:	8a260000 	bhi	983618 <__bss_end+0x97937c>
    3614:	2600000c 	strcs	r0, [r0], -ip
    3618:	00000c97 	muleq	r0, r7, ip
    361c:	00006818 	andeq	r6, r0, r8, lsl r8
    3620:	000f1d00 	andeq	r1, pc, r0, lsl #26
    3624:	009d2900 	addseq	r2, sp, r0, lsl #18
    3628:	023f0000 	eorseq	r0, pc, #0
    362c:	0f0c0300 	svceq	0x000c0300
    3630:	a4260000 	strtge	r0, [r6], #-0
    3634:	2a00000c 	bcs	366c <shift+0x366c>
    3638:	00000215 	andeq	r0, r0, r5, lsl r2
    363c:	41065d01 	tstmi	r6, r1, lsl #26
    3640:	7400000f 	strvc	r0, [r0], #-15
    3644:	b000009b 	mullt	r0, fp, r0
    3648:	01000000 	mrseq	r0, (UNDEF: 0)
    364c:	000f949c 	muleq	pc, ip, r4	; <UNPREDICTABLE>
    3650:	1a742b00 	bne	1d0e258 <__bss_end+0x1d03fbc>
    3654:	02530000 	subseq	r0, r3, #0
    3658:	91020000 	mrsls	r0, (UNDEF: 2)
    365c:	00782c6c 	rsbseq	r2, r8, ip, ror #24
    3660:	74295d01 	strtvc	r5, [r9], #-3329	; 0xfffff2ff
    3664:	02000000 	andeq	r0, r0, #0
    3668:	792c6a91 	stmdbvc	ip!, {r0, r4, r7, r9, fp, sp, lr}
    366c:	355d0100 	ldrbcc	r0, [sp, #-256]	; 0xffffff00
    3670:	00000074 	andeq	r0, r0, r4, ror r0
    3674:	2c689102 	stfcsp	f1, [r8], #-8
    3678:	00727473 	rsbseq	r7, r2, r3, ror r4
    367c:	58445d01 	stmdapl	r4, {r0, r8, sl, fp, ip, lr}^
    3680:	02000002 	andeq	r0, r0, #2
    3684:	782d6491 	stmdavc	sp!, {r0, r4, r7, sl, sp, lr}
    3688:	62010069 	andvs	r0, r1, #105	; 0x69
    368c:	0000740e 	andeq	r7, r0, lr, lsl #8
    3690:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    3694:	7274702d 	rsbsvc	r7, r4, #45	; 0x2d
    3698:	11630100 	cmnne	r3, r0, lsl #2
    369c:	00000258 	andeq	r0, r0, r8, asr r2
    36a0:	00709102 	rsbseq	r9, r0, r2, lsl #2
    36a4:	0001862a 	andeq	r8, r1, sl, lsr #12
    36a8:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
    36ac:	00000fae 	andeq	r0, r0, lr, lsr #31
    36b0:	00009b1c 	andeq	r9, r0, ip, lsl fp
    36b4:	00000058 	andeq	r0, r0, r8, asr r0
    36b8:	0fca9c01 	svceq	0x00ca9c01
    36bc:	742b0000 	strtvc	r0, [fp], #-0
    36c0:	5300001a 	movwpl	r0, #26
    36c4:	02000002 	andeq	r0, r0, #2
    36c8:	702d6c91 	mlavc	sp, r1, ip, r6
    36cc:	0100746b 	tsteq	r0, fp, ror #8
    36d0:	0a8b2357 	beq	fe2cc434 <__bss_end+0xfe2c2198>
    36d4:	91020000 	mrsls	r0, (UNDEF: 2)
    36d8:	eb2a0074 	bl	a838b0 <__bss_end+0xa79614>
    36dc:	01000001 	tsteq	r0, r1
    36e0:	0fe4063a 	svceq	0x00e4063a
    36e4:	99b40000 	ldmibls	r4!, {}	; <UNPREDICTABLE>
    36e8:	01680000 	cmneq	r8, r0
    36ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    36f0:	00001036 	andeq	r1, r0, r6, lsr r0
    36f4:	001a742b 	andseq	r7, sl, fp, lsr #8
    36f8:	00025300 	andeq	r5, r2, r0, lsl #6
    36fc:	5c910200 	lfmpl	f0, 4, [r1], {0}
    3700:	0100782c 	tsteq	r0, ip, lsr #16
    3704:	0074273a 	rsbseq	r2, r4, sl, lsr r7
    3708:	91020000 	mrsls	r0, (UNDEF: 2)
    370c:	00792c5a 	rsbseq	r2, r9, sl, asr ip
    3710:	74333a01 	ldrtvc	r3, [r3], #-2561	; 0xfffff5ff
    3714:	02000000 	andeq	r0, r0, #0
    3718:	632c5891 			; <UNDEFINED> instruction: 0x632c5891
    371c:	3b3a0100 	blcc	e83b24 <__bss_end+0xe79888>
    3720:	00000025 	andeq	r0, r0, r5, lsr #32
    3724:	2d579102 	ldfcsp	f1, [r7, #-8]
    3728:	00667562 	rsbeq	r7, r6, r2, ror #10
    372c:	360a4301 	strcc	r4, [sl], -r1, lsl #6
    3730:	02000010 	andeq	r0, r0, #16
    3734:	702d6091 	mlavc	sp, r1, r0, r6
    3738:	01007274 	tsteq	r0, r4, ror r2
    373c:	10461e45 	subne	r1, r6, r5, asr #28
    3740:	91020000 	mrsls	r0, (UNDEF: 2)
    3744:	25180074 	ldrcs	r0, [r8, #-116]	; 0xffffff8c
    3748:	46000000 	strmi	r0, [r0], -r0
    374c:	19000010 	stmdbne	r0, {r4}
    3750:	0000009d 	muleq	r0, sp, r0
    3754:	040e0010 	streq	r0, [lr], #-16
    3758:	00000b03 	andeq	r0, r0, r3, lsl #22
    375c:	0001c12a 	andeq	ip, r1, sl, lsr #2
    3760:	062b0100 	strteq	r0, [fp], -r0, lsl #2
    3764:	00001066 	andeq	r1, r0, r6, rrx
    3768:	000098c8 	andeq	r9, r0, r8, asr #17
    376c:	000000ec 	andeq	r0, r0, ip, ror #1
    3770:	10ab9c01 	adcne	r9, fp, r1, lsl #24
    3774:	742b0000 	strtvc	r0, [fp], #-0
    3778:	5300001a 	movwpl	r0, #26
    377c:	02000002 	andeq	r0, r0, #2
    3780:	782c6c91 	stmdavc	ip!, {r0, r4, r7, sl, fp, sp, lr}
    3784:	282b0100 	stmdacs	fp!, {r8}
    3788:	00000074 	andeq	r0, r0, r4, ror r0
    378c:	2c6a9102 	stfcsp	f1, [sl], #-8
    3790:	2b010079 	blcs	4397c <__bss_end+0x396e0>
    3794:	00007434 	andeq	r7, r0, r4, lsr r4
    3798:	68910200 	ldmvs	r1, {r9}
    379c:	7465732c 	strbtvc	r7, [r5], #-812	; 0xfffffcd4
    37a0:	3c2b0100 	stfccs	f0, [fp], #-0
    37a4:	00000241 	andeq	r0, r0, r1, asr #4
    37a8:	2d679102 	stfcsp	f1, [r7, #-8]!
    37ac:	00746b70 	rsbseq	r6, r4, r0, ror fp
    37b0:	ce263101 	sufgts	f3, f6, f1
    37b4:	0200000a 	andeq	r0, r0, #10
    37b8:	2a007091 	bcs	1fa04 <__bss_end+0x15768>
    37bc:	000001a1 	andeq	r0, r0, r1, lsr #3
    37c0:	c5062001 	strgt	r2, [r6, #-1]
    37c4:	4c000010 	stcmi	0, cr0, [r0], {16}
    37c8:	7c000098 	stcvc	0, cr0, [r0], {152}	; 0x98
    37cc:	01000000 	mrseq	r0, (UNDEF: 0)
    37d0:	0010f09c 	mulseq	r0, ip, r0
    37d4:	1a742b00 	bne	1d0e3dc <__bss_end+0x1d04140>
    37d8:	02530000 	subseq	r0, r3, #0
    37dc:	91020000 	mrsls	r0, (UNDEF: 2)
    37e0:	1b9a2e6c 	blne	fe68f198 <__bss_end+0xfe684efc>
    37e4:	20010000 	andcs	r0, r1, r0
    37e8:	00024120 	andeq	r4, r2, r0, lsr #2
    37ec:	6b910200 	blvs	fe443ff4 <__bss_end+0xfe439d58>
    37f0:	746b702d 	strbtvc	r7, [fp], #-45	; 0xffffffd3
    37f4:	1b250100 	blne	943bfc <__bss_end+0x939960>
    37f8:	00000aa6 	andeq	r0, r0, r6, lsr #21
    37fc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3800:	0001672f 	andeq	r6, r1, pc, lsr #14
    3804:	061b0100 	ldreq	r0, [fp], -r0, lsl #2
    3808:	0000110a 	andeq	r1, r0, sl, lsl #2
    380c:	00009824 	andeq	r9, r0, r4, lsr #16
    3810:	00000028 	andeq	r0, r0, r8, lsr #32
    3814:	11179c01 	tstne	r7, r1, lsl #24
    3818:	742b0000 	strtvc	r0, [fp], #-0
    381c:	6600001a 			; <UNDEFINED> instruction: 0x6600001a
    3820:	02000002 	andeq	r0, r0, #2
    3824:	30007491 	mulcc	r0, r1, r4
    3828:	00000143 	andeq	r0, r0, r3, asr #2
    382c:	28011101 	stmdacs	r1, {r0, r8, ip}
    3830:	00000011 	andeq	r0, r0, r1, lsl r0
    3834:	0000113b 	andeq	r1, r0, fp, lsr r1
    3838:	001a7431 	andseq	r7, sl, r1, lsr r4
    383c:	00025300 	andeq	r5, r2, r0, lsl #6
    3840:	1a353100 	bne	d4fc48 <__bss_end+0xd459ac>
    3844:	00500000 	subseq	r0, r0, r0
    3848:	32000000 	andcc	r0, r0, #0
    384c:	00001117 	andeq	r1, r0, r7, lsl r1
    3850:	00001be2 	andeq	r1, r0, r2, ror #23
    3854:	00001156 	andeq	r1, r0, r6, asr r1
    3858:	000097d8 	ldrdeq	r9, [r0], -r8
    385c:	0000004c 	andeq	r0, r0, ip, asr #32
    3860:	115f9c01 	cmpne	pc, r1, lsl #24
    3864:	28330000 	ldmdacs	r3!, {}	; <UNPREDICTABLE>
    3868:	02000011 	andeq	r0, r0, #17
    386c:	30007491 	mulcc	r0, r1, r4
    3870:	0000011f 	andeq	r0, r0, pc, lsl r1
    3874:	70010a01 	andvc	r0, r1, r1, lsl #20
    3878:	00000011 	andeq	r0, r0, r1, lsl r0
    387c:	00001186 	andeq	r1, r0, r6, lsl #3
    3880:	001a7431 	andseq	r7, sl, r1, lsr r4
    3884:	00025300 	andeq	r5, r2, r0, lsl #6
    3888:	1b163400 	blne	590890 <__bss_end+0x5865f4>
    388c:	0a010000 	beq	43894 <__bss_end+0x395f8>
    3890:	0002582a 	andeq	r5, r2, sl, lsr #16
    3894:	5f350000 	svcpl	0x00350000
    3898:	a3000011 	movwge	r0, #17
    389c:	9d00001b 	stcls	0, cr0, [r0, #-108]	; 0xffffff94
    38a0:	70000011 	andvc	r0, r0, r1, lsl r0
    38a4:	68000097 	stmdavs	r0, {r0, r1, r2, r4, r7}
    38a8:	01000000 	mrseq	r0, (UNDEF: 0)
    38ac:	1170339c 			; <UNDEFINED> instruction: 0x1170339c
    38b0:	91020000 	mrsls	r0, (UNDEF: 2)
    38b4:	11793374 	cmnne	r9, r4, ror r3
    38b8:	91020000 	mrsls	r0, (UNDEF: 2)
    38bc:	22000070 	andcs	r0, r0, #112	; 0x70
    38c0:	02000000 	andeq	r0, r0, #0
    38c4:	000c2800 	andeq	r2, ip, r0, lsl #16
    38c8:	37010400 	strcc	r0, [r1, -r0, lsl #8]
    38cc:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    38d0:	3000009c 	mulcc	r0, ip, r0
    38d4:	f900009e 			; <UNDEFINED> instruction: 0xf900009e
    38d8:	2900001b 	stmdbcs	r0, {r0, r1, r3, r4}
    38dc:	6300001c 	movwvs	r0, #28
    38e0:	01000000 	mrseq	r0, (UNDEF: 0)
    38e4:	00002280 	andeq	r2, r0, r0, lsl #5
    38e8:	3c000200 	sfmcc	f0, 4, [r0], {-0}
    38ec:	0400000c 	streq	r0, [r0], #-12
    38f0:	0011b401 	andseq	fp, r1, r1, lsl #8
    38f4:	009e3000 	addseq	r3, lr, r0
    38f8:	009e3400 	addseq	r3, lr, r0, lsl #8
    38fc:	001bf900 	andseq	pc, fp, r0, lsl #18
    3900:	001c2900 	andseq	r2, ip, r0, lsl #18
    3904:	00006300 	andeq	r6, r0, r0, lsl #6
    3908:	32800100 	addcc	r0, r0, #0, 2
    390c:	04000009 	streq	r0, [r0], #-9
    3910:	000c5000 	andeq	r5, ip, r0
    3914:	f7010400 			; <UNDEFINED> instruction: 0xf7010400
    3918:	0c00001f 	stceq	0, cr0, [r0], {31}
    391c:	00001f4e 	andeq	r1, r0, lr, asr #30
    3920:	00001c29 	andeq	r1, r0, r9, lsr #24
    3924:	00001214 	andeq	r1, r0, r4, lsl r2
    3928:	69050402 	stmdbvs	r5, {r1, sl}
    392c:	0300746e 	movweq	r7, #1134	; 0x46e
    3930:	07a20704 	streq	r0, [r2, r4, lsl #14]!
    3934:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    3938:	00031f05 	andeq	r1, r3, r5, lsl #30
    393c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    3940:	000027df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    3944:	001fa904 	andseq	sl, pc, r4, lsl #18
    3948:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    394c:	00000024 	andeq	r0, r0, r4, lsr #32
    3950:	00240104 	eoreq	r0, r4, r4, lsl #2
    3954:	152f0100 	strne	r0, [pc, #-256]!	; 385c <shift+0x385c>
    3958:	00000051 	andeq	r0, r0, r1, asr r0
    395c:	00570405 	subseq	r0, r7, r5, lsl #8
    3960:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    3964:	66000000 	strvs	r0, [r0], -r0
    3968:	07000000 	streq	r0, [r0, -r0]
    396c:	00000066 	andeq	r0, r0, r6, rrx
    3970:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    3974:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3978:	002b3304 	eoreq	r3, fp, r4, lsl #6
    397c:	0f360100 	svceq	0x00360100
    3980:	00000079 	andeq	r0, r0, r9, ror r0
    3984:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    3988:	1d060000 	stcne	0, cr0, [r6, #-0]
    398c:	93000000 	movwls	r0, #0
    3990:	07000000 	streq	r0, [r0, -r0]
    3994:	00000066 	andeq	r0, r0, r6, rrx
    3998:	00006607 	andeq	r6, r0, r7, lsl #12
    399c:	01030000 	mrseq	r0, (UNDEF: 3)
    39a0:	0010dd08 	andseq	sp, r0, r8, lsl #26
    39a4:	26390900 	ldrtcs	r0, [r9], -r0, lsl #18
    39a8:	bb010000 	bllt	439b0 <__bss_end+0x39714>
    39ac:	00004512 	andeq	r4, r0, r2, lsl r5
    39b0:	2b610900 	blcs	1845db8 <__bss_end+0x183bb1c>
    39b4:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    39b8:	00006d10 	andeq	r6, r0, r0, lsl sp
    39bc:	06010300 	streq	r0, [r1], -r0, lsl #6
    39c0:	000010df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    39c4:	0023210a 	eoreq	r2, r3, sl, lsl #2
    39c8:	93010700 	movwls	r0, #5888	; 0x1700
    39cc:	02000000 	andeq	r0, r0, #0
    39d0:	01e60617 	mvneq	r0, r7, lsl r6
    39d4:	070b0000 	streq	r0, [fp, -r0]
    39d8:	0000001e 	andeq	r0, r0, lr, lsl r0
    39dc:	00223e0b 	eoreq	r3, r2, fp, lsl #28
    39e0:	040b0100 	streq	r0, [fp], #-256	; 0xffffff00
    39e4:	02000027 	andeq	r0, r0, #39	; 0x27
    39e8:	002a750b 	eoreq	r7, sl, fp, lsl #10
    39ec:	a80b0300 	stmdage	fp, {r8, r9}
    39f0:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    39f4:	00297e0b 	eoreq	r7, r9, fp, lsl #28
    39f8:	e20b0500 	and	r0, fp, #0, 10
    39fc:	06000028 	streq	r0, [r0], -r8, lsr #32
    3a00:	001e280b 	andseq	r2, lr, fp, lsl #16
    3a04:	930b0700 	movwls	r0, #46848	; 0xb700
    3a08:	08000029 	stmdaeq	r0, {r0, r3, r5}
    3a0c:	0029a10b 	eoreq	sl, r9, fp, lsl #2
    3a10:	680b0900 	stmdavs	fp, {r8, fp}
    3a14:	0a00002a 	beq	3ac4 <shift+0x3ac4>
    3a18:	0025ff0b 	eoreq	pc, r5, fp, lsl #30
    3a1c:	ea0b0b00 	b	2c6624 <__bss_end+0x2bc388>
    3a20:	0c00001f 	stceq	0, cr0, [r0], {31}
    3a24:	0020c70b 	eoreq	ip, r0, fp, lsl #14
    3a28:	650b0d00 	strvs	r0, [fp, #-3328]	; 0xfffff300
    3a2c:	0e000023 	cdpeq	0, 0, cr0, cr0, cr3, {1}
    3a30:	00237b0b 	eoreq	r7, r3, fp, lsl #22
    3a34:	780b0f00 	stmdavc	fp, {r8, r9, sl, fp}
    3a38:	10000022 	andne	r0, r0, r2, lsr #32
    3a3c:	00268c0b 	eoreq	r8, r6, fp, lsl #24
    3a40:	e40b1100 	str	r1, [fp], #-256	; 0xffffff00
    3a44:	12000022 	andne	r0, r0, #34	; 0x22
    3a48:	002cfa0b 	eoreq	pc, ip, fp, lsl #20
    3a4c:	910b1300 	mrsls	r1, (UNDEF: 59)
    3a50:	1400001e 	strne	r0, [r0], #-30	; 0xffffffe2
    3a54:	0023080b 	eoreq	r0, r3, fp, lsl #16
    3a58:	ce0b1500 	cfsh32gt	mvfx1, mvfx11, #0
    3a5c:	1600001d 			; <UNDEFINED> instruction: 0x1600001d
    3a60:	002a980b 	eoreq	r9, sl, fp, lsl #16
    3a64:	ba0b1700 	blt	2c966c <__bss_end+0x2bf3d0>
    3a68:	1800002b 	stmdane	r0, {r0, r1, r3, r5}
    3a6c:	00232d0b 	eoreq	r2, r3, fp, lsl #26
    3a70:	760b1900 	strvc	r1, [fp], -r0, lsl #18
    3a74:	1a000027 	bne	3b18 <shift+0x3b18>
    3a78:	002aa60b 	eoreq	sl, sl, fp, lsl #12
    3a7c:	fd0b1b00 	stc2	11, cr1, [fp, #-0]	; <UNPREDICTABLE>
    3a80:	1c00001c 	stcne	0, cr0, [r0], {28}
    3a84:	002ab40b 	eoreq	fp, sl, fp, lsl #8
    3a88:	c20b1d00 	andgt	r1, fp, #0, 26
    3a8c:	1e00002a 	cdpne	0, 0, cr0, cr0, cr10, {1}
    3a90:	001cab0b 	andseq	sl, ip, fp, lsl #22
    3a94:	ec0b1f00 	stc	15, cr1, [fp], {-0}
    3a98:	2000002a 	andcs	r0, r0, sl, lsr #32
    3a9c:	0028230b 	eoreq	r2, r8, fp, lsl #6
    3aa0:	5e0b2100 	adfple	f2, f3, f0
    3aa4:	22000026 	andcs	r0, r0, #38	; 0x26
    3aa8:	002a8b0b 	eoreq	r8, sl, fp, lsl #22
    3aac:	620b2300 	andvs	r2, fp, #0, 6
    3ab0:	24000025 	strcs	r0, [r0], #-37	; 0xffffffdb
    3ab4:	0024640b 	eoreq	r6, r4, fp, lsl #8
    3ab8:	7e0b2500 	cfsh32vc	mvfx2, mvfx11, #0
    3abc:	26000021 	strcs	r0, [r0], -r1, lsr #32
    3ac0:	0024820b 	eoreq	r8, r4, fp, lsl #4
    3ac4:	1a0b2700 	bne	2cd6cc <__bss_end+0x2c3430>
    3ac8:	28000022 	stmdacs	r0, {r1, r5}
    3acc:	0024920b 	eoreq	r9, r4, fp, lsl #4
    3ad0:	a20b2900 	andge	r2, fp, #0, 18
    3ad4:	2a000024 	bcs	3b6c <shift+0x3b6c>
    3ad8:	0025e50b 	eoreq	lr, r5, fp, lsl #10
    3adc:	0b0b2b00 	bleq	2ce6e4 <__bss_end+0x2c4448>
    3ae0:	2c000024 	stccs	0, cr0, [r0], {36}	; 0x24
    3ae4:	0028300b 	eoreq	r3, r8, fp
    3ae8:	bf0b2d00 	svclt	0x000b2d00
    3aec:	2e000021 	cdpcs	0, 0, cr0, cr0, cr1, {1}
    3af0:	239d0a00 	orrscs	r0, sp, #0, 20
    3af4:	01070000 	mrseq	r0, (UNDEF: 7)
    3af8:	00000093 	muleq	r0, r3, r0
    3afc:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    3b00:	0b000003 	bleq	3b14 <shift+0x3b14>
    3b04:	000020e9 	andeq	r2, r0, r9, ror #1
    3b08:	1d3b0b00 	vldmdbne	fp!, {d0-d-1}
    3b0c:	0b010000 	bleq	43b14 <__bss_end+0x39878>
    3b10:	00002ca8 	andeq	r2, r0, r8, lsr #25
    3b14:	2b3b0b02 	blcs	ec6724 <__bss_end+0xebc488>
    3b18:	0b030000 	bleq	c3b20 <__bss_end+0xb9884>
    3b1c:	00002109 	andeq	r2, r0, r9, lsl #2
    3b20:	1df30b04 			; <UNDEFINED> instruction: 0x1df30b04
    3b24:	0b050000 	bleq	143b2c <__bss_end+0x139890>
    3b28:	0000219b 	muleq	r0, fp, r1
    3b2c:	20f90b06 	rscscs	r0, r9, r6, lsl #22
    3b30:	0b070000 	bleq	1c3b38 <__bss_end+0x1b989c>
    3b34:	000029cf 	andeq	r2, r0, pc, asr #19
    3b38:	2b200b08 	blcs	806760 <__bss_end+0x7fc4c4>
    3b3c:	0b090000 	bleq	243b44 <__bss_end+0x2398a8>
    3b40:	00002906 	andeq	r2, r0, r6, lsl #18
    3b44:	1e460b0a 	vmlane.f64	d16, d6, d10
    3b48:	0b0b0000 	bleq	2c3b50 <__bss_end+0x2b98b4>
    3b4c:	0000213c 	andeq	r2, r0, ip, lsr r1
    3b50:	1dbc0b0c 			; <UNDEFINED> instruction: 0x1dbc0b0c
    3b54:	0b0d0000 	bleq	343b5c <__bss_end+0x3398c0>
    3b58:	00002cdd 	ldrdeq	r2, [r0], -sp
    3b5c:	25d20b0e 	ldrbcs	r0, [r2, #2830]	; 0xb0e
    3b60:	0b0f0000 	bleq	3c3b68 <__bss_end+0x3b98cc>
    3b64:	000022af 	andeq	r2, r0, pc, lsr #5
    3b68:	260f0b10 			; <UNDEFINED> instruction: 0x260f0b10
    3b6c:	0b110000 	bleq	443b74 <__bss_end+0x4398d8>
    3b70:	00002bfc 	strdeq	r2, [r0], -ip
    3b74:	1f090b12 	svcne	0x00090b12
    3b78:	0b130000 	bleq	4c3b80 <__bss_end+0x4b98e4>
    3b7c:	000022c2 	andeq	r2, r0, r2, asr #5
    3b80:	25250b14 	strcs	r0, [r5, #-2836]!	; 0xfffff4ec
    3b84:	0b150000 	bleq	543b8c <__bss_end+0x5398f0>
    3b88:	000020d4 	ldrdeq	r2, [r0], -r4
    3b8c:	25710b16 	ldrbcs	r0, [r1, #-2838]!	; 0xfffff4ea
    3b90:	0b170000 	bleq	5c3b98 <__bss_end+0x5b98fc>
    3b94:	00002387 	andeq	r2, r0, r7, lsl #7
    3b98:	1e110b18 	vmovne.32	r0, d1[0]
    3b9c:	0b190000 	bleq	643ba4 <__bss_end+0x639908>
    3ba0:	00002ba3 	andeq	r2, r0, r3, lsr #23
    3ba4:	24f10b1a 	ldrbtcs	r0, [r1], #2842	; 0xb1a
    3ba8:	0b1b0000 	bleq	6c3bb0 <__bss_end+0x6b9914>
    3bac:	00002299 	muleq	r0, r9, r2
    3bb0:	1ce60b1c 	vstmiane	r6!, {d16-d29}
    3bb4:	0b1d0000 	bleq	743bbc <__bss_end+0x739920>
    3bb8:	0000243c 	andeq	r2, r0, ip, lsr r4
    3bbc:	24280b1e 	strtcs	r0, [r8], #-2846	; 0xfffff4e2
    3bc0:	0b1f0000 	bleq	7c3bc8 <__bss_end+0x7b992c>
    3bc4:	000028c3 	andeq	r2, r0, r3, asr #17
    3bc8:	294e0b20 	stmdbcs	lr, {r5, r8, r9, fp}^
    3bcc:	0b210000 	bleq	843bd4 <__bss_end+0x839938>
    3bd0:	00002b82 	andeq	r2, r0, r2, lsl #23
    3bd4:	21cc0b22 	biccs	r0, ip, r2, lsr #22
    3bd8:	0b230000 	bleq	8c3be0 <__bss_end+0x8b9944>
    3bdc:	00002726 	andeq	r2, r0, r6, lsr #14
    3be0:	291b0b24 	ldmdbcs	fp, {r2, r5, r8, r9, fp}
    3be4:	0b250000 	bleq	943bec <__bss_end+0x939950>
    3be8:	0000283f 	andeq	r2, r0, pc, lsr r8
    3bec:	28530b26 	ldmdacs	r3, {r1, r2, r5, r8, r9, fp}^
    3bf0:	0b270000 	bleq	9c3bf8 <__bss_end+0x9b995c>
    3bf4:	00002867 	andeq	r2, r0, r7, ror #16
    3bf8:	1f940b28 	svcne	0x00940b28
    3bfc:	0b290000 	bleq	a43c04 <__bss_end+0xa39968>
    3c00:	00001ef4 	strdeq	r1, [r0], -r4
    3c04:	1f1c0b2a 	svcne	0x001c0b2a
    3c08:	0b2b0000 	bleq	ac3c10 <__bss_end+0xab9974>
    3c0c:	00002a18 	andeq	r2, r0, r8, lsl sl
    3c10:	1f710b2c 	svcne	0x00710b2c
    3c14:	0b2d0000 	bleq	b43c1c <__bss_end+0xb39980>
    3c18:	00002a2c 	andeq	r2, r0, ip, lsr #20
    3c1c:	2a400b2e 	bcs	10068dc <__bss_end+0xffc640>
    3c20:	0b2f0000 	bleq	bc3c28 <__bss_end+0xbb998c>
    3c24:	00002a54 	andeq	r2, r0, r4, asr sl
    3c28:	214e0b30 	cmpcs	lr, r0, lsr fp
    3c2c:	0b310000 	bleq	c43c34 <__bss_end+0xc39998>
    3c30:	00002128 	andeq	r2, r0, r8, lsr #2
    3c34:	24500b32 	ldrbcs	r0, [r0], #-2866	; 0xfffff4ce
    3c38:	0b330000 	bleq	cc3c40 <__bss_end+0xcb99a4>
    3c3c:	00002622 	andeq	r2, r0, r2, lsr #12
    3c40:	2c310b34 			; <UNDEFINED> instruction: 0x2c310b34
    3c44:	0b350000 	bleq	d43c4c <__bss_end+0xd399b0>
    3c48:	00001c8e 	andeq	r1, r0, lr, lsl #25
    3c4c:	224e0b36 	subcs	r0, lr, #55296	; 0xd800
    3c50:	0b370000 	bleq	dc3c58 <__bss_end+0xdb99bc>
    3c54:	00002263 	andeq	r2, r0, r3, ror #4
    3c58:	24b20b38 	ldrtcs	r0, [r2], #2872	; 0xb38
    3c5c:	0b390000 	bleq	e43c64 <__bss_end+0xe399c8>
    3c60:	000024dc 	ldrdeq	r2, [r0], -ip
    3c64:	2c5a0b3a 	vmovcs	r0, sl, d26
    3c68:	0b3b0000 	bleq	ec3c70 <__bss_end+0xeb99d4>
    3c6c:	00002711 	andeq	r2, r0, r1, lsl r7
    3c70:	21f10b3c 	mvnscs	r0, ip, lsr fp
    3c74:	0b3d0000 	bleq	f43c7c <__bss_end+0xf399e0>
    3c78:	00001d4d 	andeq	r1, r0, sp, asr #26
    3c7c:	1d0b0b3e 	vstrne	d0, [fp, #-248]	; 0xffffff08
    3c80:	0b3f0000 	bleq	fc3c88 <__bss_end+0xfb99ec>
    3c84:	0000266e 	andeq	r2, r0, lr, ror #12
    3c88:	27920b40 	ldrcs	r0, [r2, r0, asr #22]
    3c8c:	0b410000 	bleq	1043c94 <__bss_end+0x10399f8>
    3c90:	000028a5 	andeq	r2, r0, r5, lsr #17
    3c94:	24c70b42 	strbcs	r0, [r7], #2882	; 0xb42
    3c98:	0b430000 	bleq	10c3ca0 <__bss_end+0x10b9a04>
    3c9c:	00002c93 	muleq	r0, r3, ip
    3ca0:	273c0b44 	ldrcs	r0, [ip, -r4, asr #22]!
    3ca4:	0b450000 	bleq	1143cac <__bss_end+0x1139a10>
    3ca8:	00001f38 	andeq	r1, r0, r8, lsr pc
    3cac:	25a20b46 	strcs	r0, [r2, #2886]!	; 0xb46
    3cb0:	0b470000 	bleq	11c3cb8 <__bss_end+0x11b9a1c>
    3cb4:	000023d5 	ldrdeq	r2, [r0], -r5
    3cb8:	1cca0b48 	vstmiane	sl, {d16-<overflow reg d51>}
    3cbc:	0b490000 	bleq	1243cc4 <__bss_end+0x1239a28>
    3cc0:	00001dde 	ldrdeq	r1, [r0], -lr
    3cc4:	22050b4a 	andcs	r0, r5, #75776	; 0x12800
    3cc8:	0b4b0000 	bleq	12c3cd0 <__bss_end+0x12b9a34>
    3ccc:	00002503 	andeq	r2, r0, r3, lsl #10
    3cd0:	0203004c 	andeq	r0, r3, #76	; 0x4c
    3cd4:	00129807 	andseq	r9, r2, r7, lsl #16
    3cd8:	03e40c00 	mvneq	r0, #0, 24
    3cdc:	03d90000 	bicseq	r0, r9, #0
    3ce0:	000d0000 	andeq	r0, sp, r0
    3ce4:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    3ce8:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    3cec:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    3cf0:	000003de 	ldrdeq	r0, [r0], -lr
    3cf4:	e6080103 	str	r0, [r8], -r3, lsl #2
    3cf8:	0e000010 	mcreq	0, 0, r0, cr0, cr0, {0}
    3cfc:	000003e9 	andeq	r0, r0, r9, ror #7
    3d00:	001e820f 	andseq	r8, lr, pc, lsl #4
    3d04:	014c0400 	cmpeq	ip, r0, lsl #8
    3d08:	0003d91a 	andeq	sp, r3, sl, lsl r9
    3d0c:	22890f00 	addcs	r0, r9, #0, 30
    3d10:	82040000 	andhi	r0, r4, #0
    3d14:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    3d18:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    3d1c:	1a000003 	bne	3d30 <shift+0x3d30>
    3d20:	0d000004 	stceq	0, cr0, [r0, #-16]
    3d24:	24740900 	ldrbtcs	r0, [r4], #-2304	; 0xfffff700
    3d28:	2d050000 	stccs	0, cr0, [r5, #-0]
    3d2c:	00040f0d 	andeq	r0, r4, sp, lsl #30
    3d30:	2afc0900 	bcs	fff06138 <__bss_end+0xffefbe9c>
    3d34:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    3d38:	0001e61c 	andeq	lr, r1, ip, lsl r6
    3d3c:	21620a00 	cmncs	r2, r0, lsl #20
    3d40:	01070000 	mrseq	r0, (UNDEF: 7)
    3d44:	00000093 	muleq	r0, r3, r0
    3d48:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    3d4c:	0b000004 	bleq	3d64 <shift+0x3d64>
    3d50:	00001cdf 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3d54:	23740b00 	cmncs	r4, #0, 22
    3d58:	0b010000 	bleq	43d60 <__bss_end+0x39ac4>
    3d5c:	00002c0e 	andeq	r2, r0, lr, lsl #24
    3d60:	2bd10b02 	blcs	ff446970 <__bss_end+0xff43c6d4>
    3d64:	0b030000 	bleq	c3d6c <__bss_end+0xb9ad0>
    3d68:	000026cb 	andeq	r2, r0, fp, asr #13
    3d6c:	298c0b04 	stmibcs	ip, {r2, r8, r9, fp}
    3d70:	0b050000 	bleq	143d78 <__bss_end+0x139adc>
    3d74:	00001ec5 	andeq	r1, r0, r5, asr #29
    3d78:	1ea70b06 	vfmane.f64	d0, d7, d6
    3d7c:	0b070000 	bleq	1c3d84 <__bss_end+0x1b9ae8>
    3d80:	000020c0 	andeq	r2, r0, r0, asr #1
    3d84:	25870b08 	strcs	r0, [r7, #2824]	; 0xb08
    3d88:	0b090000 	bleq	243d90 <__bss_end+0x239af4>
    3d8c:	00001ecc 	andeq	r1, r0, ip, asr #29
    3d90:	258e0b0a 	strcs	r0, [lr, #2826]	; 0xb0a
    3d94:	0b0b0000 	bleq	2c3d9c <__bss_end+0x2b9b00>
    3d98:	00001f31 	andeq	r1, r0, r1, lsr pc
    3d9c:	1ebe0b0c 	vmovne.f64	d0, #236	; 0xbf600000 -0.875
    3da0:	0b0d0000 	bleq	343da8 <__bss_end+0x339b0c>
    3da4:	000029e3 	andeq	r2, r0, r3, ror #19
    3da8:	27b00b0e 	ldrcs	r0, [r0, lr, lsl #22]!
    3dac:	000f0000 	andeq	r0, pc, r0
    3db0:	0028db04 	eoreq	sp, r8, r4, lsl #22
    3db4:	013f0500 	teqeq	pc, r0, lsl #10
    3db8:	00000432 	andeq	r0, r0, r2, lsr r4
    3dbc:	00296f09 	eoreq	r6, r9, r9, lsl #30
    3dc0:	0f410500 	svceq	0x00410500
    3dc4:	000004a5 	andeq	r0, r0, r5, lsr #9
    3dc8:	0029f709 	eoreq	pc, r9, r9, lsl #14
    3dcc:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    3dd0:	0000001d 	andeq	r0, r0, sp, lsl r0
    3dd4:	001e6609 	andseq	r6, lr, r9, lsl #12
    3dd8:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    3ddc:	0000001d 	andeq	r0, r0, sp, lsl r0
    3de0:	002ad010 	eoreq	sp, sl, r0, lsl r0
    3de4:	2a080900 	bcs	2061ec <__bss_end+0x1fbf50>
    3de8:	4c050000 	stcmi	0, cr0, [r5], {-0}
    3dec:	0004e614 	andeq	lr, r4, r4, lsl r6
    3df0:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    3df4:	11000004 	tstne	r0, r4
    3df8:	00233e09 	eoreq	r3, r3, r9, lsl #28
    3dfc:	0f4e0500 	svceq	0x004e0500
    3e00:	000004f9 	strdeq	r0, [r0], -r9
    3e04:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    3e08:	f1120000 			; <UNDEFINED> instruction: 0xf1120000
    3e0c:	09000028 	stmdbeq	r0, {r3, r5}
    3e10:	000026b8 			; <UNDEFINED> instruction: 0x000026b8
    3e14:	100d5205 	andne	r5, sp, r5, lsl #4
    3e18:	05000005 	streq	r0, [r0, #-5]
    3e1c:	0004ff04 	andeq	pc, r4, r4, lsl #30
    3e20:	1fdd1300 	svcne	0x00dd1300
    3e24:	05340000 	ldreq	r0, [r4, #-0]!
    3e28:	41150167 	tstmi	r5, r7, ror #2
    3e2c:	14000005 	strne	r0, [r0], #-5
    3e30:	0000247d 	andeq	r2, r0, sp, ror r4
    3e34:	0f016905 	svceq	0x00016905
    3e38:	000003de 	ldrdeq	r0, [r0], -lr
    3e3c:	1fc11400 	svcne	0x00c11400
    3e40:	6a050000 	bvs	143e48 <__bss_end+0x139bac>
    3e44:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    3e48:	00040000 	andeq	r0, r4, r0
    3e4c:	0005160e 	andeq	r1, r5, lr, lsl #12
    3e50:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    3e54:	05560000 	ldrbeq	r0, [r6, #-0]
    3e58:	24150000 	ldrcs	r0, [r5], #-0
    3e5c:	2d000000 	stccs	0, cr0, [r0, #-0]
    3e60:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    3e64:	05610000 	strbeq	r0, [r1, #-0]!
    3e68:	000d0000 	andeq	r0, sp, r0
    3e6c:	0005560e 	andeq	r5, r5, lr, lsl #12
    3e70:	23ac0f00 			; <UNDEFINED> instruction: 0x23ac0f00
    3e74:	6b050000 	blvs	143e7c <__bss_end+0x139be0>
    3e78:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    3e7c:	f20f0000 	vhadd.s8	d0, d15, d0
    3e80:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    3e84:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    3e88:	16000000 	strne	r0, [r0], -r0
    3e8c:	0000292f 	andeq	r2, r0, pc, lsr #18
    3e90:	00930107 	addseq	r0, r3, r7, lsl #2
    3e94:	81050000 	mrshi	r0, (UNDEF: 5)
    3e98:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    3e9c:	740b0000 	strvc	r0, [fp], #-0
    3ea0:	0000001d 	andeq	r0, r0, sp, lsl r0
    3ea4:	001d800b 	andseq	r8, sp, fp
    3ea8:	8c0b0200 	sfmhi	f0, 4, [fp], {-0}
    3eac:	0300001d 	movweq	r0, #29
    3eb0:	00218e0b 	eoreq	r8, r1, fp, lsl #28
    3eb4:	980b0300 	stmdals	fp, {r8, r9}
    3eb8:	0400001d 	streq	r0, [r0], #-29	; 0xffffffe3
    3ebc:	0022d70b 	eoreq	sp, r2, fp, lsl #14
    3ec0:	bd0b0400 	cfstrslt	mvf0, [fp, #-0]
    3ec4:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3ec8:	0023130b 	eoreq	r1, r3, fp, lsl #6
    3ecc:	570b0500 	strpl	r0, [fp, -r0, lsl #10]
    3ed0:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    3ed4:	001da40b 	andseq	sl, sp, fp, lsl #8
    3ed8:	3b0b0600 	blcc	2c56e0 <__bss_end+0x2bb444>
    3edc:	06000025 	streq	r0, [r0], -r5, lsr #32
    3ee0:	001fb30b 	andseq	fp, pc, fp, lsl #6
    3ee4:	480b0600 	stmdami	fp, {r9, sl}
    3ee8:	06000025 	streq	r0, [r0], -r5, lsr #32
    3eec:	0029af0b 	eoreq	sl, r9, fp, lsl #30
    3ef0:	550b0600 	strpl	r0, [fp, #-1536]	; 0xfffffa00
    3ef4:	06000025 	streq	r0, [r0], -r5, lsr #32
    3ef8:	0025950b 	eoreq	r9, r5, fp, lsl #10
    3efc:	b00b0600 	andlt	r0, fp, r0, lsl #12
    3f00:	0700001d 	smladeq	r0, sp, r0, r0
    3f04:	00269b0b 	eoreq	r9, r6, fp, lsl #22
    3f08:	e80b0700 	stmda	fp, {r8, r9, sl}
    3f0c:	07000026 	streq	r0, [r0, -r6, lsr #32]
    3f10:	0029ea0b 	eoreq	lr, r9, fp, lsl #20
    3f14:	860b0700 	strhi	r0, [fp], -r0, lsl #14
    3f18:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    3f1c:	0027690b 	eoreq	r6, r7, fp, lsl #18
    3f20:	290b0800 	stmdbcs	fp, {fp}
    3f24:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    3f28:	0029bd0b 	eoreq	fp, r9, fp, lsl #26
    3f2c:	850b0800 	strhi	r0, [fp, #-2048]	; 0xfffff800
    3f30:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    3f34:	2c230f00 	stccs	15, cr0, [r3], #-0
    3f38:	9f050000 	svcls	0x00050000
    3f3c:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    3f40:	b70f0000 	strlt	r0, [pc, -r0]
    3f44:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3f48:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    3f4c:	0f000000 	svceq	0x00000000
    3f50:	000023ca 	andeq	r2, r0, sl, asr #7
    3f54:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    3f58:	0000001d 	andeq	r0, r0, sp, lsl r0
    3f5c:	002cef0f 	eoreq	lr, ip, pc, lsl #30
    3f60:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    3f64:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f68:	1e760f00 	cdpne	15, 7, cr0, cr6, cr0, {0}
    3f6c:	ab050000 	blge	143f74 <__bss_end+0x139cd8>
    3f70:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3f74:	c10f0000 	mrsgt	r0, CPSR
    3f78:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3f7c:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    3f80:	0f000000 	svceq	0x00000000
    3f84:	000026d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    3f88:	0c01b105 	stfeqd	f3, [r1], {5}
    3f8c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3f90:	0026dd0f 	eoreq	sp, r6, pc, lsl #26
    3f94:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    3f98:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f9c:	27cb0f00 	strbcs	r0, [fp, r0, lsl #30]
    3fa0:	b7050000 	strlt	r0, [r5, -r0]
    3fa4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3fa8:	170f0000 	strne	r0, [pc, -r0]
    3fac:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    3fb0:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    3fb4:	0f000000 	svceq	0x00000000
    3fb8:	00002c4e 	andeq	r2, r0, lr, asr #24
    3fbc:	0c01bd05 	stceq	13, cr11, [r1], {5}
    3fc0:	0000001d 	andeq	r0, r0, sp, lsl r0
    3fc4:	0027d50f 	eoreq	sp, r7, pc, lsl #10
    3fc8:	01c00500 	biceq	r0, r0, r0, lsl #10
    3fcc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3fd0:	2d120f00 	ldccs	15, cr0, [r2, #-0]
    3fd4:	c3050000 	movwgt	r0, #20480	; 0x5000
    3fd8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3fdc:	d80f0000 	stmdale	pc, {}	; <UNPREDICTABLE>
    3fe0:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    3fe4:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    3fe8:	0f000000 	svceq	0x00000000
    3fec:	00002be4 	andeq	r2, r0, r4, ror #23
    3ff0:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    3ff4:	0000001d 	andeq	r0, r0, sp, lsl r0
    3ff8:	002bf00f 	eoreq	pc, fp, pc
    3ffc:	01cc0500 	biceq	r0, ip, r0, lsl #10
    4000:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4004:	2c150f00 	ldccs	15, cr0, [r5], {-0}
    4008:	d0050000 	andle	r0, r5, r0
    400c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4010:	050f0000 	streq	r0, [pc, #-0]	; 4018 <shift+0x4018>
    4014:	0500002d 	streq	r0, [r0, #-45]	; 0xffffffd3
    4018:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    401c:	0f000000 	svceq	0x00000000
    4020:	00001ed3 	ldrdeq	r1, [r0], -r3
    4024:	0c01d605 	stceq	6, cr13, [r1], {5}
    4028:	0000001d 	andeq	r0, r0, sp, lsl r0
    402c:	001cba0f 	andseq	fp, ip, pc, lsl #20
    4030:	01d90500 	bicseq	r0, r9, r0, lsl #10
    4034:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4038:	21ae0f00 			; <UNDEFINED> instruction: 0x21ae0f00
    403c:	dc050000 	stcle	0, cr0, [r5], {-0}
    4040:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4044:	ae0f0000 	cdpge	0, 0, cr0, cr15, cr0, {0}
    4048:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    404c:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    4050:	0f000000 	svceq	0x00000000
    4054:	000027eb 	andeq	r2, r0, fp, ror #15
    4058:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    405c:	0000001d 	andeq	r0, r0, sp, lsl r0
    4060:	0023f30f 	eoreq	pc, r3, pc, lsl #6
    4064:	01e50500 	mvneq	r0, r0, lsl #10
    4068:	00001d0c 	andeq	r1, r0, ip, lsl #26
    406c:	264b0f00 	strbcs	r0, [fp], -r0, lsl #30
    4070:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    4074:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4078:	050f0000 	streq	r0, [pc, #-0]	; 4080 <shift+0x4080>
    407c:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    4080:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    4084:	0f000000 	svceq	0x00000000
    4088:	00002cbd 			; <UNDEFINED> instruction: 0x00002cbd
    408c:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    4090:	0000001d 	andeq	r0, r0, sp, lsl r0
    4094:	002ccd0f 	eoreq	ip, ip, pc, lsl #26
    4098:	01f50500 	mvnseq	r0, r0, lsl #10
    409c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    40a0:	1fca0f00 	svcne	0x00ca0f00
    40a4:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    40a8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    40ac:	4c0f0000 	stcmi	0, cr0, [pc], {-0}
    40b0:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    40b4:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    40b8:	0f000000 	svceq	0x00000000
    40bc:	00002751 	andeq	r2, r0, r1, asr r7
    40c0:	0c01fe05 	stceq	14, cr15, [r1], {5}
    40c4:	0000001d 	andeq	r0, r0, sp, lsl r0
    40c8:	0022270f 	eoreq	r2, r2, pc, lsl #14
    40cc:	02020500 	andeq	r0, r2, #0, 10
    40d0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    40d4:	29410f00 	stmdbcs	r1, {r8, r9, sl, fp}^
    40d8:	0a050000 	beq	1440e0 <__bss_end+0x139e44>
    40dc:	001d0c02 	andseq	r0, sp, r2, lsl #24
    40e0:	1a0f0000 	bne	3c40e8 <__bss_end+0x3b9e4c>
    40e4:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    40e8:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    40ec:	0c000000 	stceq	0, cr0, [r0], {-0}
    40f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    40f4:	000007ef 	andeq	r0, r0, pc, ror #15
    40f8:	f30f000d 	vhadd.u8	d0, d15, d13
    40fc:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    4100:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    4104:	0c000007 	stceq	0, cr0, [r0], {7}
    4108:	000004e6 	andeq	r0, r0, r6, ror #9
    410c:	0000080c 	andeq	r0, r0, ip, lsl #16
    4110:	00002415 	andeq	r2, r0, r5, lsl r4
    4114:	0f000d00 	svceq	0x00000d00
    4118:	0000280e 	andeq	r2, r0, lr, lsl #16
    411c:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    4120:	000007fc 	strdeq	r0, [r0], -ip
    4124:	0023b516 	eoreq	fp, r3, r6, lsl r5
    4128:	93010700 	movwls	r0, #5888	; 0x1700
    412c:	05000000 	streq	r0, [r0, #-0]
    4130:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    4134:	0b000008 	bleq	415c <shift+0x415c>
    4138:	00002170 	andeq	r2, r0, r0, ror r1
    413c:	25c00b00 	strbcs	r0, [r0, #2816]	; 0xb00
    4140:	0b010000 	bleq	44148 <__bss_end+0x39eac>
    4144:	00001d5f 	andeq	r1, r0, pc, asr sp
    4148:	2c7f0b02 			; <UNDEFINED> instruction: 0x2c7f0b02
    414c:	0b030000 	bleq	c4154 <__bss_end+0xb9eb8>
    4150:	00002888 	andeq	r2, r0, r8, lsl #17
    4154:	287b0b04 	ldmdacs	fp!, {r2, r8, r9, fp}^
    4158:	0b050000 	bleq	144160 <__bss_end+0x139ec4>
    415c:	00001e36 	andeq	r1, r0, r6, lsr lr
    4160:	6f0f0006 	svcvs	0x000f0006
    4164:	0500002c 	streq	r0, [r0, #-44]	; 0xffffffd4
    4168:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    416c:	0f000008 	svceq	0x00000008
    4170:	00002b71 	andeq	r2, r0, r1, ror fp
    4174:	11079905 	tstne	r7, r5, lsl #18
    4178:	00000024 	andeq	r0, r0, r4, lsr #32
    417c:	0027fb0f 	eoreq	pc, r7, pc, lsl #22
    4180:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    4184:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4188:	2ae40400 	bcs	ff905190 <__bss_end+0xff8faef4>
    418c:	7b060000 	blvc	184194 <__bss_end+0x179ef8>
    4190:	00009316 	andeq	r9, r0, r6, lsl r3
    4194:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    4198:	02030000 	andeq	r0, r3, #0
    419c:	000e5905 	andeq	r5, lr, r5, lsl #18
    41a0:	07080300 	streq	r0, [r8, -r0, lsl #6]
    41a4:	00000798 	muleq	r0, r8, r7
    41a8:	ee040403 	cdp	4, 0, cr0, cr4, cr3, {0}
    41ac:	0300001e 	movweq	r0, #30
    41b0:	1ee60308 	cdpne	3, 14, cr0, cr6, cr8, {0}
    41b4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    41b8:	0027e404 	eoreq	lr, r7, r4, lsl #8
    41bc:	03100300 	tsteq	r0, #0, 6
    41c0:	00002896 	muleq	r0, r6, r8
    41c4:	00088a0c 	andeq	r8, r8, ip, lsl #20
    41c8:	0008c900 	andeq	ip, r8, r0, lsl #18
    41cc:	00241500 	eoreq	r1, r4, r0, lsl #10
    41d0:	00ff0000 	rscseq	r0, pc, r0
    41d4:	0008b90e 	andeq	fp, r8, lr, lsl #18
    41d8:	26f50f00 	ldrbtcs	r0, [r5], r0, lsl #30
    41dc:	fc060000 	stc2	0, cr0, [r6], {-0}
    41e0:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    41e4:	9d0f0000 	stcls	0, cr0, [pc, #-0]	; 41ec <shift+0x41ec>
    41e8:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    41ec:	c9160202 	ldmdbgt	r6, {r1, r9}
    41f0:	04000008 	streq	r0, [r0], #-8
    41f4:	00002b17 	andeq	r2, r0, r7, lsl fp
    41f8:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    41fc:	0c000004 	stceq	0, cr0, [r0], {4}
    4200:	000008e8 	andeq	r0, r0, r8, ror #17
    4204:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    4208:	5709000d 	strpl	r0, [r9, -sp]
    420c:	07000003 	streq	r0, [r0, -r3]
    4210:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    4214:	0c090000 	stceq	0, cr0, [r9], {-0}
    4218:	07000002 	streq	r0, [r0, -r2]
    421c:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    4220:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    4224:	08000008 	stmdaeq	r0, {r3}
    4228:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    422c:	00a27803 	adceq	r7, r2, r3, lsl #16
    4230:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    4234:	34080000 	strcc	r0, [r8], #-0
    4238:	03050a09 	movweq	r0, #23049	; 0x5a09
    423c:	0000a278 	andeq	sl, r0, r8, ror r2
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376978>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb8a80>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb8aa0>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb8ab8>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x314>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe795f8>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe38adc>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f6a0c>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b5e58>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b96bc>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4674>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b5e84>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b5ef8>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x376a74>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb8b74>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe796b0>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe38b94>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb8bac>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe796e4>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4720>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x376b64>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f6b2c>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb8c4c>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	03001605 	movweq	r1, #1541	; 0x605
 21c:	3b0b3a0e 	blcc	2cea5c <__bss_end+0x2c47c0>
 220:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 224:	06000013 			; <UNDEFINED> instruction: 0x06000013
 228:	0b0b0024 	bleq	2c02c0 <__bss_end+0x2b6024>
 22c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b97b4>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb8c94>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f6bb8>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7c580>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb8cbc>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b8c2c>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79810>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe38cf4>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfad30>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4850>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79848>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe38d2c>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x376cb4>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe79878>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe38d5c>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc79a2c>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x376ce8>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b60e8>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe798c8>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe38dac>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb8dc4>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x376d54>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe79914>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe38df8>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfae34>
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
 3d4:	3a0e0319 	bcc	381040 <__bss_end+0x376da4>
 3d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3dc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 3e0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 3e4:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e8:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 3ec:	0b3b0b3a 	bleq	ec30dc <__bss_end+0xeb8e40>
 3f0:	13010b39 	movwne	r0, #6969	; 0x1b39
 3f4:	34250000 	strtcc	r0, [r5], #-0
 3f8:	3a0e0300 	bcc	381000 <__bss_end+0x376d64>
 3fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 400:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 404:	6c061c19 	stcvs	12, cr1, [r6], {25}
 408:	26000019 			; <UNDEFINED> instruction: 0x26000019
 40c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 410:	0b3b0b3a 	bleq	ec3100 <__bss_end+0xeb8e64>
 414:	13490b39 	movtne	r0, #39737	; 0x9b39
 418:	0b1c193c 	bleq	706910 <__bss_end+0x6fc674>
 41c:	0000196c 	andeq	r1, r0, ip, ror #18
 420:	47003427 	strmi	r3, [r0, -r7, lsr #8]
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb8e80>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 438:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 43c:	03193f01 	tsteq	r9, #1, 30
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c49e4>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 44c:	96184006 	ldrls	r4, [r8], -r6
 450:	13011942 	movwne	r1, #6466	; 0x1942
 454:	052a0000 	streq	r0, [sl, #-0]!
 458:	3a0e0300 	bcc	381060 <__bss_end+0x376dc4>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 464:	2b000018 	blcs	4cc <shift+0x4cc>
 468:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeb8ec0>
 470:	13490b39 	movtne	r0, #39737	; 0x9b39
 474:	00001802 	andeq	r1, r0, r2, lsl #16
 478:	0300342c 	movweq	r3, #1068	; 0x42c
 47c:	3b0b3a08 	blcc	2ceca4 <__bss_end+0x2c4a08>
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
 4b8:	03001604 	movweq	r1, #1540	; 0x604
 4bc:	3b0b3a0e 	blcc	2cecfc <__bss_end+0x2c4a60>
 4c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4c4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 4c8:	0b0b0024 	bleq	2c0560 <__bss_end+0x2b62c4>
 4cc:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 4d0:	34060000 	strcc	r0, [r6], #-0
 4d4:	3a0e0300 	bcc	3810dc <__bss_end+0x376e40>
 4d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4dc:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4e0:	00180219 	andseq	r0, r8, r9, lsl r2
 4e4:	01130700 	tsteq	r3, r0, lsl #14
 4e8:	0b0b0e03 	bleq	2c3cfc <__bss_end+0x2b9a60>
 4ec:	0b3b0b3a 	bleq	ec31dc <__bss_end+0xeb8f40>
 4f0:	13010b39 	movwne	r0, #6969	; 0x1b39
 4f4:	0d080000 	stceq	0, cr0, [r8, #-0]
 4f8:	3a080300 	bcc	201100 <__bss_end+0x1f6e64>
 4fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 500:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 504:	0900000b 	stmdbeq	r0, {r0, r1, r3}
 508:	0e030104 	adfeqs	f0, f3, f4
 50c:	0b3e196d 	bleq	f86ac8 <__bss_end+0xf7c82c>
 510:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 514:	0b3b0b3a 	bleq	ec3204 <__bss_end+0xeb8f68>
 518:	13010b39 	movwne	r0, #6969	; 0x1b39
 51c:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 520:	1c080300 	stcne	3, cr0, [r8], {-0}
 524:	0b00000b 	bleq	558 <shift+0x558>
 528:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 52c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 530:	0300020c 	movweq	r0, #524	; 0x20c
 534:	00193c0e 	andseq	r3, r9, lr, lsl #24
 538:	01020d00 	tsteq	r2, r0, lsl #26
 53c:	0b0b0e03 	bleq	2c3d50 <__bss_end+0x2b9ab4>
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeb8f94>
 544:	13010b39 	movwne	r0, #6969	; 0x1b39
 548:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 54c:	3a0e0300 	bcc	381154 <__bss_end+0x376eb8>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 558:	0f00000b 	svceq	0x0000000b
 55c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 560:	0b3a0e03 	bleq	e83d74 <__bss_end+0xe79ad8>
 564:	0b390b3b 	bleq	e43258 <__bss_end+0xe38fbc>
 568:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 56c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 570:	05100000 	ldreq	r0, [r0, #-0]
 574:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 578:	11000019 	tstne	r0, r9, lsl r0
 57c:	13490005 	movtne	r0, #36869	; 0x9005
 580:	0d120000 	ldceq	0, cr0, [r2, #-0]
 584:	3a0e0300 	bcc	38118c <__bss_end+0x376ef0>
 588:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 58c:	3f13490b 	svccc	0x0013490b
 590:	00193c19 	andseq	r3, r9, r9, lsl ip
 594:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 598:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 59c:	0b3b0b3a 	bleq	ec328c <__bss_end+0xeb8ff0>
 5a0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5a4:	0b321349 	bleq	c852d0 <__bss_end+0xc7b034>
 5a8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 5ac:	00001301 	andeq	r1, r0, r1, lsl #6
 5b0:	3f012e14 	svccc	0x00012e14
 5b4:	3a0e0319 	bcc	381220 <__bss_end+0x376f84>
 5b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5bc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 5c0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb9024>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	0b321349 	bleq	c85304 <__bss_end+0xc7b068>
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
 604:	3a0e0300 	bcc	38120c <__bss_end+0x376f70>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	3f13490b 	svccc	0x0013490b
 610:	00193c19 	andseq	r3, r9, r9, lsl ip
 614:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 618:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 61c:	0b3b0b3a 	bleq	ec330c <__bss_end+0xeb9070>
 620:	0e6e0b39 	vmoveq.8	d14[5], r0
 624:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 628:	00001301 	andeq	r1, r0, r1, lsl #6
 62c:	3f012e1c 	svccc	0x00012e1c
 630:	3a0e0319 	bcc	38129c <__bss_end+0x377000>
 634:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 638:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 63c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 640:	00130113 	andseq	r0, r3, r3, lsl r1
 644:	000d1d00 	andeq	r1, sp, r0, lsl #26
 648:	0b3a0e03 	bleq	e83e5c <__bss_end+0xe79bc0>
 64c:	0b390b3b 	bleq	e43340 <__bss_end+0xe390a4>
 650:	0b381349 	bleq	e0537c <__bss_end+0xdfb0e0>
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
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c4c24>
 684:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 688:	00180213 	andseq	r0, r8, r3, lsl r2
 68c:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 690:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 694:	0b3b0b3a 	bleq	ec3384 <__bss_end+0xeb90e8>
 698:	0e6e0b39 	vmoveq.8	d14[5], r0
 69c:	01111349 	tsteq	r1, r9, asr #6
 6a0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6a4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 6a8:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 6ac:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb9104>
 6b4:	13490b39 	movtne	r0, #39737	; 0x9b39
 6b8:	00001802 	andeq	r1, r0, r2, lsl #16
 6bc:	3f012e25 	svccc	0x00012e25
 6c0:	3a0e0319 	bcc	38132c <__bss_end+0x377090>
 6c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6c8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 6cc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	34260000 	strtcc	r0, [r6], #-0
 6dc:	3a080300 	bcc	2012e4 <__bss_end+0x1f7048>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 6e8:	27000018 	smladcs	r0, r8, r0, r0
 6ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 6f0:	0b3a0e03 	bleq	e83f04 <__bss_end+0xe79c68>
 6f4:	0b390b3b 	bleq	e433e8 <__bss_end+0xe3914c>
 6f8:	01110e6e 	tsteq	r1, lr, ror #28
 6fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 700:	01194297 			; <UNDEFINED> instruction: 0x01194297
 704:	28000013 	stmdacs	r0, {r0, r1, r4}
 708:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe79c84>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39168>
 714:	01110e6e 	tsteq	r1, lr, ror #28
 718:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 71c:	00194297 	mulseq	r9, r7, r2
 720:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 724:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 728:	0b3b0b3a 	bleq	ec3418 <__bss_end+0xeb917c>
 72c:	0e6e0b39 	vmoveq.8	d14[5], r0
 730:	01111349 	tsteq	r1, r9, asr #6
 734:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 738:	00194297 	mulseq	r9, r7, r2
 73c:	11010000 	mrsne	r0, (UNDEF: 1)
 740:	130e2501 	movwne	r2, #58625	; 0xe501
 744:	1b0e030b 	blne	381378 <__bss_end+0x3770dc>
 748:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 74c:	00171006 	andseq	r1, r7, r6
 750:	00340200 	eorseq	r0, r4, r0, lsl #4
 754:	0b3a0e03 	bleq	e83f68 <__bss_end+0xe79ccc>
 758:	0b390b3b 	bleq	e4344c <__bss_end+0xe391b0>
 75c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 760:	00001802 	andeq	r1, r0, r2, lsl #16
 764:	0b002403 	bleq	9778 <_ZN13COLED_DisplayC1EPKc+0x8>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0400000e 	streq	r0, [r0], #-14
 770:	13490026 	movtne	r0, #36902	; 0x9026
 774:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 778:	00130101 	andseq	r0, r3, r1, lsl #2
 77c:	00340600 	eorseq	r0, r4, r0, lsl #12
 780:	0b3a0e03 	bleq	e83f94 <__bss_end+0xe79cf8>
 784:	0b390b3b 	bleq	e43478 <__bss_end+0xe391dc>
 788:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 78c:	00000a1c 	andeq	r0, r0, ip, lsl sl
 790:	3a003a07 	bcc	efb4 <__bss_end+0x4d18>
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
 7bc:	3b0b3a0e 	blcc	2ceffc <__bss_end+0x2c4d60>
 7c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7c4:	1113490e 	tstne	r3, lr, lsl #18
 7c8:	40061201 	andmi	r1, r6, r1, lsl #4
 7cc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 7d0:	00001301 	andeq	r1, r0, r1, lsl #6
 7d4:	0300050c 	movweq	r0, #1292	; 0x50c
 7d8:	3b0b3a08 	blcc	2cf000 <__bss_end+0x2c4d64>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	00340d00 	eorseq	r0, r4, r0, lsl #26
 7e8:	0b3a0803 	bleq	e827fc <__bss_end+0xe78560>
 7ec:	0b390b3b 	bleq	e434e0 <__bss_end+0xe39244>
 7f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7f4:	340e0000 	strcc	r0, [lr], #-0
 7f8:	3a0e0300 	bcc	381400 <__bss_end+0x377164>
 7fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 800:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 804:	0f000018 	svceq	0x00000018
 808:	0111010b 	tsteq	r1, fp, lsl #2
 80c:	00000612 	andeq	r0, r0, r2, lsl r6
 810:	03003410 	movweq	r3, #1040	; 0x410
 814:	3b0b3a0e 	blcc	2cf054 <__bss_end+0x2c4db8>
 818:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 81c:	00180213 	andseq	r0, r8, r3, lsl r2
 820:	00341100 	eorseq	r1, r4, r0, lsl #2
 824:	0b3a0803 	bleq	e82838 <__bss_end+0xe7859c>
 828:	0b39053b 	bleq	e41d1c <__bss_end+0xe37a80>
 82c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 830:	0f120000 	svceq	0x00120000
 834:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 838:	13000013 	movwne	r0, #19
 83c:	0b0b0024 	bleq	2c08d4 <__bss_end+0x2b6638>
 840:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 844:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 848:	03193f01 	tsteq	r9, #1, 30
 84c:	3b0b3a0e 	blcc	2cf08c <__bss_end+0x2c4df0>
 850:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 854:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 858:	96184006 	ldrls	r4, [r8], -r6
 85c:	13011942 	movwne	r1, #6466	; 0x1942
 860:	05150000 	ldreq	r0, [r5, #-0]
 864:	3a0e0300 	bcc	38146c <__bss_end+0x3771d0>
 868:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 86c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 870:	16000018 			; <UNDEFINED> instruction: 0x16000018
 874:	0111010b 	tsteq	r1, fp, lsl #2
 878:	13010612 	movwne	r0, #5650	; 0x1612
 87c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 880:	03193f01 	tsteq	r9, #1, 30
 884:	3b0b3a0e 	blcc	2cf0c4 <__bss_end+0x2c4e28>
 888:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 88c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 890:	97184006 	ldrls	r4, [r8, -r6]
 894:	13011942 	movwne	r1, #6466	; 0x1942
 898:	10180000 	andsne	r0, r8, r0
 89c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 8a0:	19000013 	stmdbne	r0, {r0, r1, r4}
 8a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8a8:	0b3a0803 	bleq	e828bc <__bss_end+0xe78620>
 8ac:	0b390b3b 	bleq	e435a0 <__bss_end+0xe39304>
 8b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 8b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 8bc:	00130119 	andseq	r0, r3, r9, lsl r1
 8c0:	00261a00 	eoreq	r1, r6, r0, lsl #20
 8c4:	0f1b0000 	svceq	0x001b0000
 8c8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 8cc:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 8d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8d4:	0b3b0b3a 	bleq	ec35c4 <__bss_end+0xeb9328>
 8d8:	0e6e0b39 	vmoveq.8	d14[5], r0
 8dc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8e0:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 8e4:	00000019 	andeq	r0, r0, r9, lsl r0
 8e8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 8ec:	030b130e 	movweq	r1, #45838	; 0xb30e
 8f0:	110e1b0e 	tstne	lr, lr, lsl #22
 8f4:	10061201 	andne	r1, r6, r1, lsl #4
 8f8:	02000017 	andeq	r0, r0, #23
 8fc:	0b0b0024 	bleq	2c0994 <__bss_end+0x2b66f8>
 900:	0e030b3e 	vmoveq.16	d3[0], r0
 904:	26030000 	strcs	r0, [r3], -r0
 908:	00134900 	andseq	r4, r3, r0, lsl #18
 90c:	00160400 	andseq	r0, r6, r0, lsl #8
 910:	0b3a0e03 	bleq	e84124 <__bss_end+0xe79e88>
 914:	0b390b3b 	bleq	e43608 <__bss_end+0xe3936c>
 918:	00001349 	andeq	r1, r0, r9, asr #6
 91c:	0b002405 	bleq	9938 <_ZN13COLED_Display9Set_PixelEttb+0x70>
 920:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 924:	06000008 	streq	r0, [r0], -r8
 928:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 92c:	0b3b0b3a 	bleq	ec361c <__bss_end+0xeb9380>
 930:	13490b39 	movtne	r0, #39737	; 0x9b39
 934:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 938:	02070000 	andeq	r0, r7, #0
 93c:	0b0e0301 	bleq	381548 <__bss_end+0x3772ac>
 940:	3b0b3a0b 	blcc	2cf174 <__bss_end+0x2c4ed8>
 944:	010b390b 	tsteq	fp, fp, lsl #18
 948:	08000013 	stmdaeq	r0, {r0, r1, r4}
 94c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 950:	0b3b0b3a 	bleq	ec3640 <__bss_end+0xeb93a4>
 954:	13490b39 	movtne	r0, #39737	; 0x9b39
 958:	00000b38 	andeq	r0, r0, r8, lsr fp
 95c:	3f012e09 	svccc	0x00012e09
 960:	3a0e0319 	bcc	3815cc <__bss_end+0x377330>
 964:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 968:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 96c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 970:	01136419 	tsteq	r3, r9, lsl r4
 974:	0a000013 	beq	9c8 <shift+0x9c8>
 978:	13490005 	movtne	r0, #36869	; 0x9005
 97c:	00001934 	andeq	r1, r0, r4, lsr r9
 980:	4900050b 	stmdbmi	r0, {r0, r1, r3, r8, sl}
 984:	0c000013 	stceq	0, cr0, [r0], {19}
 988:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 98c:	0b3a0e03 	bleq	e841a0 <__bss_end+0xe79f04>
 990:	0b390b3b 	bleq	e43684 <__bss_end+0xe393e8>
 994:	0b320e6e 	bleq	c84354 <__bss_end+0xc7a0b8>
 998:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 99c:	00001301 	andeq	r1, r0, r1, lsl #6
 9a0:	3f012e0d 	svccc	0x00012e0d
 9a4:	3a0e0319 	bcc	381610 <__bss_end+0x377374>
 9a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9ac:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 9b0:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 9b4:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 9b8:	0b0b000f 	bleq	2c09fc <__bss_end+0x2b6760>
 9bc:	00001349 	andeq	r1, r0, r9, asr #6
 9c0:	0b000f0f 	bleq	4604 <shift+0x4604>
 9c4:	1000000b 	andne	r0, r0, fp
 9c8:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 9cc:	0b3a0b0b 	bleq	e83600 <__bss_end+0xe79364>
 9d0:	0b390b3b 	bleq	e436c4 <__bss_end+0xe39428>
 9d4:	00001301 	andeq	r1, r0, r1, lsl #6
 9d8:	03000d11 	movweq	r0, #3345	; 0xd11
 9dc:	3b0b3a08 	blcc	2cf204 <__bss_end+0x2c4f68>
 9e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9e4:	000b3813 	andeq	r3, fp, r3, lsl r8
 9e8:	01041200 	mrseq	r1, R12_usr
 9ec:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 9f0:	0b0b0b3e 	bleq	2c36f0 <__bss_end+0x2b9454>
 9f4:	0b3a1349 	bleq	e85720 <__bss_end+0xe7b484>
 9f8:	0b390b3b 	bleq	e436ec <__bss_end+0xe39450>
 9fc:	00001301 	andeq	r1, r0, r1, lsl #6
 a00:	03002813 	movweq	r2, #2067	; 0x813
 a04:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 a08:	00021400 	andeq	r1, r2, r0, lsl #8
 a0c:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 a10:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 a14:	03193f01 	tsteq	r9, #1, 30
 a18:	3b0b3a0e 	blcc	2cf258 <__bss_end+0x2c4fbc>
 a1c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a20:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 a24:	00136419 	andseq	r6, r3, r9, lsl r4
 a28:	000d1600 	andeq	r1, sp, r0, lsl #12
 a2c:	0b3a0e03 	bleq	e84240 <__bss_end+0xe79fa4>
 a30:	0b390b3b 	bleq	e43724 <__bss_end+0xe39488>
 a34:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 a38:	0000193c 	andeq	r1, r0, ip, lsr r9
 a3c:	3f012e17 	svccc	0x00012e17
 a40:	3a0e0319 	bcc	3816ac <__bss_end+0x377410>
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
 a70:	3b0b3a0e 	blcc	2cf2b0 <__bss_end+0x2c5014>
 a74:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a78:	3c193f13 	ldccc	15, cr3, [r9], {19}
 a7c:	1c000019 	stcne	0, cr0, [r0], {25}
 a80:	08030028 	stmdaeq	r3, {r3, r5}
 a84:	00000b1c 	andeq	r0, r0, ip, lsl fp
 a88:	3f012e1d 	svccc	0x00012e1d
 a8c:	3a0e0319 	bcc	3816f8 <__bss_end+0x37745c>
 a90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a94:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 a98:	01136419 	tsteq	r3, r9, lsl r4
 a9c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 aa0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 aa4:	0b3a0e03 	bleq	e842b8 <__bss_end+0xe7a01c>
 aa8:	0b390b3b 	bleq	e4379c <__bss_end+0xe39500>
 aac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 ab0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 ab4:	00001301 	andeq	r1, r0, r1, lsl #6
 ab8:	03000d1f 	movweq	r0, #3359	; 0xd1f
 abc:	3b0b3a0e 	blcc	2cf2fc <__bss_end+0x2c5060>
 ac0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ac4:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 ac8:	2000000b 	andcs	r0, r0, fp
 acc:	13490115 	movtne	r0, #37141	; 0x9115
 ad0:	13011364 	movwne	r1, #4964	; 0x1364
 ad4:	1f210000 	svcne	0x00210000
 ad8:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 adc:	22000013 	andcs	r0, r0, #19
 ae0:	0b0b0010 	bleq	2c0b28 <__bss_end+0x2b688c>
 ae4:	00001349 	andeq	r1, r0, r9, asr #6
 ae8:	03013923 	movweq	r3, #6435	; 0x1923
 aec:	3b0b3a08 	blcc	2cf314 <__bss_end+0x2c5078>
 af0:	010b390b 	tsteq	fp, fp, lsl #18
 af4:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 af8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 afc:	0b3b0b3a 	bleq	ec37ec <__bss_end+0xeb9550>
 b00:	13490b39 	movtne	r0, #39737	; 0x9b39
 b04:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 b08:	0000196c 	andeq	r1, r0, ip, ror #18
 b0c:	03003425 	movweq	r3, #1061	; 0x425
 b10:	3b0b3a0e 	blcc	2cf350 <__bss_end+0x2c50b4>
 b14:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 b18:	1c193c13 	ldcne	12, cr3, [r9], {19}
 b1c:	00196c0b 	andseq	r6, r9, fp, lsl #24
 b20:	00342600 	eorseq	r2, r4, r0, lsl #12
 b24:	00001347 	andeq	r1, r0, r7, asr #6
 b28:	03013927 	movweq	r3, #6439	; 0x1927
 b2c:	3b0b3a0e 	blcc	2cf36c <__bss_end+0x2c50d0>
 b30:	010b390b 	tsteq	fp, fp, lsl #18
 b34:	28000013 	stmdacs	r0, {r0, r1, r4}
 b38:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 b3c:	0b3b0b3a 	bleq	ec382c <__bss_end+0xeb9590>
 b40:	13490b39 	movtne	r0, #39737	; 0x9b39
 b44:	031c193c 	tsteq	ip, #60, 18	; 0xf0000
 b48:	21290000 			; <UNDEFINED> instruction: 0x21290000
 b4c:	2f134900 	svccs	0x00134900
 b50:	2a000005 	bcs	b6c <shift+0xb6c>
 b54:	1347012e 	movtne	r0, #28974	; 0x712e
 b58:	0b3b0b3a 	bleq	ec3848 <__bss_end+0xeb95ac>
 b5c:	13640b39 	cmnne	r4, #58368	; 0xe400
 b60:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b64:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 b68:	00130119 	andseq	r0, r3, r9, lsl r1
 b6c:	00052b00 	andeq	r2, r5, r0, lsl #22
 b70:	13490e03 	movtne	r0, #40451	; 0x9e03
 b74:	18021934 	stmdane	r2, {r2, r4, r5, r8, fp, ip}
 b78:	052c0000 	streq	r0, [ip, #-0]!
 b7c:	3a080300 	bcc	201784 <__bss_end+0x1f74e8>
 b80:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b84:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 b88:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
 b8c:	08030034 	stmdaeq	r3, {r2, r4, r5}
 b90:	0b3b0b3a 	bleq	ec3880 <__bss_end+0xeb95e4>
 b94:	13490b39 	movtne	r0, #39737	; 0x9b39
 b98:	00001802 	andeq	r1, r0, r2, lsl #16
 b9c:	0300052e 	movweq	r0, #1326	; 0x52e
 ba0:	3b0b3a0e 	blcc	2cf3e0 <__bss_end+0x2c5144>
 ba4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 ba8:	00180213 	andseq	r0, r8, r3, lsl r2
 bac:	012e2f00 			; <UNDEFINED> instruction: 0x012e2f00
 bb0:	0b3a1347 	bleq	e858d4 <__bss_end+0xe7b638>
 bb4:	0b390b3b 	bleq	e438a8 <__bss_end+0xe3960c>
 bb8:	01111364 	tsteq	r1, r4, ror #6
 bbc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 bc0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 bc4:	30000013 	andcc	r0, r0, r3, lsl r0
 bc8:	1347012e 	movtne	r0, #28974	; 0x712e
 bcc:	0b3b0b3a 	bleq	ec38bc <__bss_end+0xeb9620>
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
 c08:	3b0b3a0e 	blcc	2cf448 <__bss_end+0x2c51ac>
 c0c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 c10:	35000013 	strcc	r0, [r0, #-19]	; 0xffffffed
 c14:	1331012e 	teqne	r1, #-2147483637	; 0x8000000b
 c18:	13640e6e 	cmnne	r4, #1760	; 0x6e0
 c1c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 c20:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 c24:	00000019 	andeq	r0, r0, r9, lsl r0
 c28:	10001101 	andne	r1, r0, r1, lsl #2
 c2c:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 c30:	1b0e0301 	blne	38183c <__bss_end+0x3775a0>
 c34:	130e250e 	movwne	r2, #58638	; 0xe50e
 c38:	00000005 	andeq	r0, r0, r5
 c3c:	10001101 	andne	r1, r0, r1, lsl #2
 c40:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 c44:	1b0e0301 	blne	381850 <__bss_end+0x3775b4>
 c48:	130e250e 	movwne	r2, #58638	; 0xe50e
 c4c:	00000005 	andeq	r0, r0, r5
 c50:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 c54:	030b130e 	movweq	r1, #45838	; 0xb30e
 c58:	100e1b0e 	andne	r1, lr, lr, lsl #22
 c5c:	02000017 	andeq	r0, r0, #23
 c60:	0b0b0024 	bleq	2c0cf8 <__bss_end+0x2b6a5c>
 c64:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 c68:	24030000 	strcs	r0, [r3], #-0
 c6c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 c70:	000e030b 	andeq	r0, lr, fp, lsl #6
 c74:	00160400 	andseq	r0, r6, r0, lsl #8
 c78:	0b3a0e03 	bleq	e8448c <__bss_end+0xe7a1f0>
 c7c:	0b390b3b 	bleq	e43970 <__bss_end+0xe396d4>
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
 ca8:	3b0b3a0e 	blcc	2cf4e8 <__bss_end+0x2c524c>
 cac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 cb0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 cb4:	0a000019 	beq	d20 <shift+0xd20>
 cb8:	0e030104 	adfeqs	f0, f3, f4
 cbc:	0b0b0b3e 	bleq	2c39bc <__bss_end+0x2b9720>
 cc0:	0b3a1349 	bleq	e859ec <__bss_end+0xe7b750>
 cc4:	0b390b3b 	bleq	e439b8 <__bss_end+0xe3971c>
 cc8:	00001301 	andeq	r1, r0, r1, lsl #6
 ccc:	0300280b 	movweq	r2, #2059	; 0x80b
 cd0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 cd4:	01010c00 	tsteq	r1, r0, lsl #24
 cd8:	13011349 	movwne	r1, #4937	; 0x1349
 cdc:	210d0000 	mrscs	r0, (UNDEF: 13)
 ce0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 ce4:	13490026 	movtne	r0, #36902	; 0x9026
 ce8:	340f0000 	strcc	r0, [pc], #-0	; cf0 <shift+0xcf0>
 cec:	3a0e0300 	bcc	3818f4 <__bss_end+0x377658>
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
 d18:	0b0e0301 	bleq	381924 <__bss_end+0x377688>
 d1c:	3b0b3a0b 	blcc	2cf550 <__bss_end+0x2c52b4>
 d20:	010b3905 	tsteq	fp, r5, lsl #18
 d24:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 d28:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 d2c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 d30:	13490b39 	movtne	r0, #39737	; 0x9b39
 d34:	00000b38 	andeq	r0, r0, r8, lsr fp
 d38:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 d3c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 d40:	01041600 	tsteq	r4, r0, lsl #12
 d44:	0b3e0e03 	bleq	f84558 <__bss_end+0xf7a2bc>
 d48:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 d4c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 d50:	13010b39 	movwne	r0, #6969	; 0x1b39
 d54:	34170000 	ldrcc	r0, [r7], #-0
 d58:	3a134700 	bcc	4d2960 <__bss_end+0x4c86c4>
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
  84:	12b30002 	adcsne	r0, r3, #2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008338 	andeq	r8, r0, r8, lsr r3
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	20130002 	andscs	r0, r3, r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008794 	muleq	r0, r4, r7
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	27100002 	ldrcs	r0, [r0, -r2]
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009770 	andeq	r9, r0, r0, ror r7
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	38bf0002 	ldmcc	pc!, {r1}	; <UNPREDICTABLE>
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009c24 	andeq	r9, r0, r4, lsr #24
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	38e50002 	stmiacc	r5!, {r1}^
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009e30 	andeq	r9, r0, r0, lsr lr
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	390b0002 	stmdbcc	fp, {r1}
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff5cb0>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff5a55>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff5a57>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad476c>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff5ba5>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be0dc>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcf688>
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
     430:	5a5f0074 	bpl	17c0608 <__bss_end+0x17b636c>
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
     584:	6a685045 	bvs	1a146a0 <__bss_end+0x1a0a404>
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
     5dc:	6a456e6f 	bvs	115bfa0 <__bss_end+0x1151d04>
     5e0:	474e3032 	smlaldxmi	r3, lr, r2, r0
     5e4:	5f4f4950 	svcpl	0x004f4950
     5e8:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     5ec:	70757272 	rsbsvc	r7, r5, r2, ror r2
     5f0:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5f4:	6a526570 	bvs	1499bbc <__bss_end+0x148f920>
     5f8:	005f3153 	subseq	r3, pc, r3, asr r1	; <UNPREDICTABLE>
     5fc:	4b4e5a5f 	blmi	1396f80 <__bss_end+0x138cce4>
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
     67c:	5a5f0074 	bpl	17c0854 <__bss_end+0x17b65b8>
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
     6cc:	314e5a5f 	cmpcc	lr, pc, asr sl
     6d0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6d4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6d8:	614d5f73 	hvcvs	54771	; 0xd5f3
     6dc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6e0:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     6e4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6e8:	5f656c75 	svcpl	0x00656c75
     6ec:	76455252 			; <UNDEFINED> instruction: 0x76455252
     6f0:	6f6c4200 	svcvs	0x006c4200
     6f4:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     6f8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6fc:	505f746e 	subspl	r7, pc, lr, ror #8
     700:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     704:	47007373 	smlsdxmi	r0, r3, r3, r7
     708:	505f7465 	subspl	r7, pc, r5, ror #8
     70c:	75004449 	strvc	r4, [r0, #-1097]	; 0xfffffbb7
     710:	33746e69 	cmncc	r4, #1680	; 0x690
     714:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     718:	314e5a5f 	cmpcc	lr, pc, asr sl
     71c:	50474333 	subpl	r4, r7, r3, lsr r3
     720:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     724:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     728:	47397265 	ldrmi	r7, [r9, -r5, ror #4]!
     72c:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     730:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     734:	5f006a45 	svcpl	0x00006a45
     738:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     73c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     740:	61485f4f 	cmpvs	r8, pc, asr #30
     744:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     748:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     74c:	4f5f7465 	svcmi	0x005f7465
     750:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     754:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     758:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     75c:	4f433331 	svcmi	0x00433331
     760:	5f44454c 	svcpl	0x0044454c
     764:	70736944 	rsbsvc	r6, r3, r4, asr #18
     768:	3579616c 	ldrbcc	r6, [r9, #-364]!	; 0xfffffe94
     76c:	61656c43 	cmnvs	r5, r3, asr #24
     770:	00624572 	rsbeq	r4, r2, r2, ror r5
     774:	31435342 	cmpcc	r3, r2, asr #6
     778:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     77c:	75500065 	ldrbvc	r0, [r0, #-101]	; 0xffffff9b
     780:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     784:	57007261 	strpl	r7, [r0, -r1, ror #4]
     788:	00746961 	rsbseq	r6, r4, r1, ror #18
     78c:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     790:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     794:	00657461 	rsbeq	r7, r5, r1, ror #8
     798:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     79c:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
     7a0:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
     7a4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     7a8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     7ac:	5300746e 	movwpl	r7, #1134	; 0x46e
     7b0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7b4:	5f656c75 	svcpl	0x00656c75
     7b8:	00464445 	subeq	r4, r6, r5, asr #8
     7bc:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     7c0:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; 6fc <shift+0x6fc>
     7c4:	42004e49 	andmi	r4, r0, #1168	; 0x490
     7c8:	6b636f6c 	blvs	18dc580 <__bss_end+0x18d22e4>
     7cc:	6d006465 	cfstrsvs	mvf6, [r0, #-404]	; 0xfffffe6c
     7d0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     7d4:	5f746e65 	svcpl	0x00746e65
     7d8:	6b736154 	blvs	1cd8d30 <__bss_end+0x1ccea94>
     7dc:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 7e4 <shift+0x7e4>
     7e0:	5a5f0065 	bpl	17c097c <__bss_end+0x17b66e0>
     7e4:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     7e8:	4f495047 	svcmi	0x00495047
     7ec:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     7f0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     7f4:	6a453443 	bvs	114d908 <__bss_end+0x114366c>
     7f8:	6f526d00 	svcvs	0x00526d00
     7fc:	445f746f 	ldrbmi	r7, [pc], #-1135	; 804 <shift+0x804>
     800:	5f007665 	svcpl	0x00007665
     804:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     808:	6f725043 	svcvs	0x00725043
     80c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     810:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     814:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     818:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     81c:	5f686374 	svcpl	0x00686374
     820:	50456f54 	subpl	r6, r5, r4, asr pc
     824:	50433831 	subpl	r3, r3, r1, lsr r8
     828:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     82c:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     830:	5f747369 	svcpl	0x00747369
     834:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     838:	6e697000 	cdpvs	0, 6, cr7, cr9, cr0, {0}
     83c:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     840:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     844:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     848:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     84c:	50476d00 	subpl	r6, r7, r0, lsl #26
     850:	43004f49 	movwmi	r4, #3913	; 0xf49
     854:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     858:	72505f65 	subsvc	r5, r0, #404	; 0x194
     85c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     860:	5a5f0073 	bpl	17c0a34 <__bss_end+0x17b6798>
     864:	33314b4e 	teqcc	r1, #79872	; 0x13800
     868:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     86c:	61485f4f 	cmpvs	r8, pc, asr #30
     870:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     874:	47393172 			; <UNDEFINED> instruction: 0x47393172
     878:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     87c:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     880:	6f4c5f4c 	svcvs	0x004c5f4c
     884:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     888:	6a456e6f 	bvs	115c24c <__bss_end+0x1151fb0>
     88c:	30536a52 	subscc	r6, r3, r2, asr sl
     890:	704f005f 	subvc	r0, pc, pc, asr r0	; <UNPREDICTABLE>
     894:	69006e65 	stmdbvs	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
     898:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     89c:	6f746365 	svcvs	0x00746365
     8a0:	47007972 	smlsdxmi	r0, r2, r9, r7
     8a4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8a8:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     8ac:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     8b0:	6f697461 	svcvs	0x00697461
     8b4:	6954006e 	ldmdbvs	r4, {r1, r2, r3, r5, r6}^
     8b8:	5f72656d 	svcpl	0x0072656d
     8bc:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8c0:	53466700 	movtpl	r6, #26368	; 0x6700
     8c4:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     8c8:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     8cc:	756f435f 	strbvc	r4, [pc, #-863]!	; 575 <shift+0x575>
     8d0:	7300746e 	movwvc	r7, #1134	; 0x46e
     8d4:	4f495047 	svcmi	0x00495047
     8d8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     8dc:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     8e0:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     8e4:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     8e8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     8ec:	5f746553 	svcpl	0x00746553
     8f0:	4f495047 	svcmi	0x00495047
     8f4:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     8f8:	6f697463 	svcvs	0x00697463
     8fc:	5a5f006e 	bpl	17c0abc <__bss_end+0x17b6820>
     900:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     904:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     908:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     90c:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     910:	696c4634 	stmdbvs	ip!, {r2, r4, r5, r9, sl, lr}^
     914:	00764570 	rsbseq	r4, r6, r0, ror r5
     918:	314e5a5f 	cmpcc	lr, pc, asr sl
     91c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     920:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     924:	614d5f73 	hvcvs	54771	; 0xd5f3
     928:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     92c:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     930:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     934:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     938:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     93c:	31504573 	cmpcc	r0, r3, ror r5
     940:	61545432 	cmpvs	r4, r2, lsr r4
     944:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     948:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     94c:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     950:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     954:	5f646568 	svcpl	0x00646568
     958:	6f666e49 	svcvs	0x00666e49
     95c:	434f4900 	movtmi	r4, #63744	; 0xf900
     960:	6d006c74 	stcvs	12, cr6, [r0, #-464]	; 0xfffffe30
     964:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     968:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     96c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     970:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     974:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     978:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     97c:	6f4e0065 	svcvs	0x004e0065
     980:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     984:	6f72505f 	svcvs	0x0072505f
     988:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     98c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     990:	50433631 	subpl	r3, r3, r1, lsr r6
     994:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     998:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 7d4 <shift+0x7d4>
     99c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     9a0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     9a4:	5f007645 	svcpl	0x00007645
     9a8:	314b4e5a 	cmpcc	fp, sl, asr lr
     9ac:	50474333 	subpl	r4, r7, r3, lsr r3
     9b0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9b4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9b8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     9bc:	5f746547 	svcpl	0x00746547
     9c0:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     9c4:	6f4c5f54 	svcvs	0x004c5f54
     9c8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     9cc:	6a456e6f 	bvs	115c390 <__bss_end+0x11520f4>
     9d0:	30536a52 	subscc	r6, r3, r2, asr sl
     9d4:	656d005f 	strbvs	r0, [sp, #-95]!	; 0xffffffa1
     9d8:	67617373 			; <UNDEFINED> instruction: 0x67617373
     9dc:	6d007365 	stcvs	3, cr7, [r0, #-404]	; 0xfffffe6c
     9e0:	6b636f4c 	blvs	18dc718 <__bss_end+0x18d247c>
     9e4:	6f526d00 	svcvs	0x00526d00
     9e8:	4d5f746f 	cfldrdmi	mvd7, [pc, #-444]	; 834 <shift+0x834>
     9ec:	5f00746e 	svcpl	0x0000746e
     9f0:	314b4e5a 	cmpcc	fp, sl, asr lr
     9f4:	50474333 	subpl	r4, r7, r3, lsr r3
     9f8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9fc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a00:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     a04:	5f746547 	svcpl	0x00746547
     a08:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a0c:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     a10:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a14:	505f746e 	subspl	r7, pc, lr, ror #8
     a18:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     a1c:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     a20:	5f007261 	svcpl	0x00007261
     a24:	314b4e5a 	cmpcc	fp, sl, asr lr
     a28:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     a2c:	445f4445 	ldrbmi	r4, [pc], #-1093	; a34 <shift+0xa34>
     a30:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     a34:	49397961 	ldmdbmi	r9!, {r0, r5, r6, r8, fp, ip, sp, lr}
     a38:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     a3c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     a40:	5f007645 	svcpl	0x00007645
     a44:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     a48:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     a4c:	61485f4f 	cmpvs	r8, pc, asr #30
     a50:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a54:	45393172 	ldrmi	r3, [r9, #-370]!	; 0xfffffe8e
     a58:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     a5c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     a60:	5f746e65 	svcpl	0x00746e65
     a64:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a68:	6a457463 	bvs	115dbfc <__bss_end+0x1153960>
     a6c:	474e3032 	smlaldxmi	r3, lr, r2, r0
     a70:	5f4f4950 	svcpl	0x004f4950
     a74:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a78:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a7c:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a80:	4e006570 	cfrshl64mi	mvdx0, mvdx0, r6
     a84:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a88:	72640079 	rsbvc	r0, r4, #121	; 0x79
     a8c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     a90:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     a94:	445f7261 	ldrbmi	r7, [pc], #-609	; a9c <shift+0xa9c>
     a98:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a9c:	5f646574 	svcpl	0x00646574
     aa0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     aa4:	61480074 	hvcvs	32772	; 0x8004
     aa8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     aac:	5152495f 	cmppl	r2, pc, asr r9
     ab0:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     ab4:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     ab8:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     abc:	5f006874 	svcpl	0x00006874
     ac0:	314b4e5a 	cmpcc	fp, sl, asr lr
     ac4:	50474333 	subpl	r4, r7, r3, lsr r3
     ac8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     acc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ad0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ad4:	5f746547 	svcpl	0x00746547
     ad8:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     adc:	6f4c5f53 	svcvs	0x004c5f53
     ae0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     ae4:	6a456e6f 	bvs	115c4a8 <__bss_end+0x115220c>
     ae8:	30536a52 	subscc	r6, r3, r2, asr sl
     aec:	614d005f 	qdaddvs	r0, pc, sp	; <UNPREDICTABLE>
     af0:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     af4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     af8:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     afc:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     b00:	00687467 	rsbeq	r7, r8, r7, ror #8
     b04:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     b08:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     b0c:	61767265 	cmnvs	r6, r5, ror #4
     b10:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     b14:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     b18:	00657469 	rsbeq	r7, r5, r9, ror #8
     b1c:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     b20:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b24:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b28:	5f6f666e 	svcpl	0x006f666e
     b2c:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     b30:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     b34:	745f7065 	ldrbvc	r7, [pc], #-101	; b3c <shift+0xb3c>
     b38:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     b3c:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     b40:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     b44:	6f435f6e 	svcvs	0x00435f6e
     b48:	00746e75 	rsbseq	r6, r4, r5, ror lr
     b4c:	6b736174 	blvs	1cd9124 <__bss_end+0x1ccee88>
     b50:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     b54:	6f465f74 	svcvs	0x00465f74
     b58:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     b5c:	00746e65 	rsbseq	r6, r4, r5, ror #28
     b60:	5f746547 	svcpl	0x00746547
     b64:	4f495047 	svcmi	0x00495047
     b68:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     b6c:	6f697463 	svcvs	0x00697463
     b70:	6f62006e 	svcvs	0x0062006e
     b74:	5f006c6f 	svcpl	0x00006c6f
     b78:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b7c:	6f725043 	svcvs	0x00725043
     b80:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b84:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b88:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b8c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     b90:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b94:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b98:	5f72656c 	svcpl	0x0072656c
     b9c:	6f666e49 	svcvs	0x00666e49
     ba0:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     ba4:	5f746547 	svcpl	0x00746547
     ba8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bac:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     bb0:	545f6f66 	ldrbpl	r6, [pc], #-3942	; bb8 <shift+0xbb8>
     bb4:	50657079 	rsbpl	r7, r5, r9, ror r0
     bb8:	52540076 	subspl	r0, r4, #118	; 0x76
     bbc:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     bc0:	00657361 	rsbeq	r7, r5, r1, ror #6
     bc4:	61666544 	cmnvs	r6, r4, asr #10
     bc8:	5f746c75 	svcpl	0x00746c75
     bcc:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     bd0:	61525f6b 	cmpvs	r2, fp, ror #30
     bd4:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     bd8:	746f6f52 	strbtvc	r6, [pc], #-3922	; be0 <shift+0xbe0>
     bdc:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     be0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     be4:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     be8:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     bec:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     bf0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     bf4:	6f72506d 	svcvs	0x0072506d
     bf8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bfc:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     c00:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     c04:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     c08:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     c0c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     c10:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     c14:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c18:	50433631 	subpl	r3, r3, r1, lsr r6
     c1c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c20:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a5c <shift+0xa5c>
     c24:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c28:	31327265 	teqcc	r2, r5, ror #4
     c2c:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     c30:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     c34:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     c38:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     c3c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c40:	00764573 	rsbseq	r4, r6, r3, ror r5
     c44:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     c48:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     c4c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     c50:	4c007365 	stcmi	3, cr7, [r0], {101}	; 0x65
     c54:	5f6b636f 	svcpl	0x006b636f
     c58:	6f6c6e55 	svcvs	0x006c6e55
     c5c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     c60:	614c6d00 	cmpvs	ip, r0, lsl #26
     c64:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     c68:	2f004449 	svccs	0x00004449
     c6c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     c70:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     c74:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     c78:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     c7c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     c80:	2f70732f 	svccs	0x0070732f
     c84:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     c88:	2f736563 	svccs	0x00736563
     c8c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     c90:	63617073 	cmnvs	r1, #115	; 0x73
     c94:	6c6f2f65 	stclvs	15, cr2, [pc], #-404	; b08 <shift+0xb08>
     c98:	745f6465 	ldrbvc	r6, [pc], #-1125	; ca0 <shift+0xca0>
     c9c:	2f6b7361 	svccs	0x006b7361
     ca0:	6e69616d 	powvsez	f6, f1, #5.0
     ca4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     ca8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cac:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     cb0:	5f4f4950 	svcpl	0x004f4950
     cb4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     cb8:	3172656c 	cmncc	r2, ip, ror #10
     cbc:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     cc0:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     cc4:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     cc8:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     ccc:	6a456e6f 	bvs	115c690 <__bss_end+0x11523f4>
     cd0:	474e3431 	smlaldxmi	r3, lr, r1, r4
     cd4:	5f4f4950 	svcpl	0x004f4950
     cd8:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     cdc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ce0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     ce4:	706e495f 	rsbvc	r4, lr, pc, asr r9
     ce8:	5f007475 	svcpl	0x00007475
     cec:	31314e5a 	teqcc	r1, sl, asr lr
     cf0:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     cf4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     cf8:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     cfc:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     d00:	634b5045 	movtvs	r5, #45125	; 0xb045
     d04:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     d08:	5f656c69 	svcpl	0x00656c69
     d0c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     d10:	646f4d5f 	strbtvs	r4, [pc], #-3423	; d18 <shift+0xd18>
     d14:	77530065 	ldrbvc	r0, [r3, -r5, rrx]
     d18:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     d1c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     d20:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     d24:	5a5f0065 	bpl	17c0ec0 <__bss_end+0x17b6c24>
     d28:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d2c:	636f7250 	cmnvs	pc, #80, 4
     d30:	5f737365 	svcpl	0x00737365
     d34:	616e614d 	cmnvs	lr, sp, asr #2
     d38:	31726567 	cmncc	r2, r7, ror #10
     d3c:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     d40:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     d44:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     d48:	00764546 	rsbseq	r4, r6, r6, asr #10
     d4c:	5f746547 	svcpl	0x00746547
     d50:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     d54:	6f4c5f56 	svcvs	0x004c5f56
     d58:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     d5c:	42006e6f 	andmi	r6, r0, #1776	; 0x6f0
     d60:	5f304353 	svcpl	0x00304353
     d64:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     d68:	73695200 	cmnvc	r9, #0, 4
     d6c:	5f676e69 	svcpl	0x00676e69
     d70:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     d74:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     d78:	65520063 	ldrbvs	r0, [r2, #-99]	; 0xffffff9d
     d7c:	76726573 			; <UNDEFINED> instruction: 0x76726573
     d80:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d84:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     d88:	6e006867 	cdpvs	8, 0, cr6, cr0, cr7, {3}
     d8c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d90:	5f646569 	svcpl	0x00646569
     d94:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     d98:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     d9c:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     da0:	69750076 	ldmdbvs	r5!, {r1, r2, r4, r5, r6}^
     da4:	3631746e 	ldrtcc	r7, [r1], -lr, ror #8
     da8:	4600745f 			; <UNDEFINED> instruction: 0x4600745f
     dac:	696c6c61 	stmdbvs	ip!, {r0, r5, r6, sl, fp, sp, lr}^
     db0:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 64a <shift+0x64a>
     db4:	00656764 	rsbeq	r6, r5, r4, ror #14
     db8:	65704f6d 	ldrbvs	r4, [r0, #-3949]!	; 0xfffff093
     dbc:	0064656e 	rsbeq	r6, r4, lr, ror #10
     dc0:	314e5a5f 	cmpcc	lr, pc, asr sl
     dc4:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     dc8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     dcc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     dd0:	76453443 	strbvc	r3, [r5], -r3, asr #8
     dd4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     dd8:	50433631 	subpl	r3, r3, r1, lsr r6
     ddc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     de0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c1c <shift+0xc1c>
     de4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     de8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     dec:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     df0:	505f7966 	subspl	r7, pc, r6, ror #18
     df4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     df8:	6a457373 	bvs	115dbcc <__bss_end+0x1153930>
     dfc:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     e00:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e04:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e08:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     e0c:	00726576 	rsbseq	r6, r2, r6, ror r5
     e10:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     e14:	6b636f6c 	blvs	18dcbcc <__bss_end+0x18d2930>
     e18:	5f00745f 	svcpl	0x0000745f
     e1c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     e20:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     e24:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     e28:	616c7073 	smcvs	50947	; 0xc703
     e2c:	45344479 	ldrmi	r4, [r4, #-1145]!	; 0xfffffb87
     e30:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     e34:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     e38:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     e3c:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 9df <shift+0x9df>
     e40:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e44:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     e48:	61654400 	cmnvs	r5, r0, lsl #8
     e4c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e50:	61700065 	cmnvs	r0, r5, rrx
     e54:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     e58:	6f687300 	svcvs	0x00687300
     e5c:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     e60:	7e00746e 	cdpvc	4, 0, cr7, cr0, cr14, {3}
     e64:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     e68:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     e6c:	616c7073 	smcvs	50947	; 0xc703
     e70:	614d0079 	hvcvs	53257	; 0xd009
     e74:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     e78:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     e7c:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     e80:	00687467 	rsbeq	r7, r8, r7, ror #8
     e84:	6f6f526d 	svcvs	0x006f526d
     e88:	72460074 	subvc	r0, r6, #116	; 0x74
     e8c:	505f6565 	subspl	r6, pc, r5, ror #10
     e90:	43006e69 	movwmi	r6, #3689	; 0xe69
     e94:	636f7250 	cmnvs	pc, #80, 4
     e98:	5f737365 	svcpl	0x00737365
     e9c:	616e614d 	cmnvs	lr, sp, asr #2
     ea0:	00726567 	rsbseq	r6, r2, r7, ror #10
     ea4:	70736e55 	rsbsvc	r6, r3, r5, asr lr
     ea8:	66696365 	strbtvs	r6, [r9], -r5, ror #6
     eac:	00646569 	rsbeq	r6, r4, r9, ror #10
     eb0:	314e5a5f 	cmpcc	lr, pc, asr sl
     eb4:	50474333 	subpl	r4, r7, r3, lsr r3
     eb8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ebc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ec0:	46387265 	ldrtmi	r7, [r8], -r5, ror #4
     ec4:	5f656572 	svcpl	0x00656572
     ec8:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     ecc:	0062626a 	rsbeq	r6, r2, sl, ror #4
     ed0:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     ed4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ed8:	006d6574 	rsbeq	r6, sp, r4, ror r5
     edc:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     ee0:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     ee4:	4600657a 			; <UNDEFINED> instruction: 0x4600657a
     ee8:	5f646e69 	svcpl	0x00646e69
     eec:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     ef0:	74740064 	ldrbtvc	r0, [r4], #-100	; 0xffffff9c
     ef4:	00307262 	eorseq	r7, r0, r2, ror #4
     ef8:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     efc:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; e38 <shift+0xe38>
     f00:	4e005841 	cdpmi	8, 0, cr5, cr0, cr1, {2}
     f04:	5f495753 	svcpl	0x00495753
     f08:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f0c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     f10:	535f6d65 	cmppl	pc, #6464	; 0x1940
     f14:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f18:	4e006563 	cfsh32mi	mvfx6, mvfx0, #51
     f1c:	5f495753 	svcpl	0x00495753
     f20:	636f7250 	cmnvs	pc, #80, 4
     f24:	5f737365 	svcpl	0x00737365
     f28:	76726553 			; <UNDEFINED> instruction: 0x76726553
     f2c:	00656369 	rsbeq	r6, r5, r9, ror #6
     f30:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     f34:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     f38:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f3c:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     f40:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     f44:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     f48:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     f4c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f50:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     f54:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f58:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f5c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     f60:	72655000 	rsbvc	r5, r5, #0
     f64:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     f68:	5f6c6172 	svcpl	0x006c6172
     f6c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     f70:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f74:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     f78:	5f4c4553 	svcpl	0x004c4553
     f7c:	61636f4c 	cmnvs	r3, ip, asr #30
     f80:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f84:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f88:	4f433331 	svcmi	0x00433331
     f8c:	5f44454c 	svcpl	0x0044454c
     f90:	70736944 	rsbsvc	r6, r3, r4, asr #18
     f94:	3179616c 	cmncc	r9, ip, ror #2
     f98:	74755030 	ldrbtvc	r5, [r5], #-48	; 0xffffffd0
     f9c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     fa0:	45676e69 	strbmi	r6, [r7, #-3689]!	; 0xfffff197
     fa4:	4b507474 	blmi	141e17c <__bss_end+0x1413ee0>
     fa8:	5a5f0063 	bpl	17c113c <__bss_end+0x17b6ea0>
     fac:	33314b4e 	teqcc	r1, #79872	; 0x13800
     fb0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     fb4:	61485f4f 	cmpvs	r8, pc, asr #30
     fb8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     fbc:	47373172 			; <UNDEFINED> instruction: 0x47373172
     fc0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     fc4:	5f4f4950 	svcpl	0x004f4950
     fc8:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     fcc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fd0:	46006a45 	strmi	r6, [r0], -r5, asr #20
     fd4:	0070696c 	rsbseq	r6, r0, ip, ror #18
     fd8:	61766e49 	cmnvs	r6, r9, asr #28
     fdc:	5f64696c 	svcpl	0x0064696c
     fe0:	006e6950 	rsbeq	r6, lr, r0, asr r9
     fe4:	314e5a5f 	cmpcc	lr, pc, asr sl
     fe8:	50474333 	subpl	r4, r7, r3, lsr r3
     fec:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ff0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ff4:	30327265 	eorscc	r7, r2, r5, ror #4
     ff8:	61736944 	cmnvs	r3, r4, asr #18
     ffc:	5f656c62 	svcpl	0x00656c62
    1000:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1004:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    1008:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    100c:	30326a45 	eorscc	r6, r2, r5, asr #20
    1010:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
    1014:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
    1018:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    101c:	5f747075 	svcpl	0x00747075
    1020:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
    1024:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
    1028:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
    102c:	76726573 			; <UNDEFINED> instruction: 0x76726573
    1030:	6f697461 	svcvs	0x00697461
    1034:	525f736e 	subspl	r7, pc, #-1207959551	; 0xb8000001
    1038:	00646165 	rsbeq	r6, r4, r5, ror #2
    103c:	6b636f4c 	blvs	18dcd74 <__bss_end+0x18d2ad8>
    1040:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1044:	0064656b 	rsbeq	r6, r4, fp, ror #10
    1048:	314e5a5f 	cmpcc	lr, pc, asr sl
    104c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1050:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1054:	614d5f73 	hvcvs	54771	; 0xd5f3
    1058:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    105c:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
    1060:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1064:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1068:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    106c:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
    1070:	30324549 	eorscc	r4, r2, r9, asr #10
    1074:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    1078:	6f72505f 	svcvs	0x0072505f
    107c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1080:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1084:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1088:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    108c:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1090:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1094:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1098:	5a5f0074 	bpl	17c1270 <__bss_end+0x17b6fd4>
    109c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    10a0:	4f495047 	svcmi	0x00495047
    10a4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    10a8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    10ac:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
    10b0:	5f726165 	svcpl	0x00726165
    10b4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    10b8:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
    10bc:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    10c0:	6a45746e 	bvs	115e280 <__bss_end+0x1153fe4>
    10c4:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    10c8:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    10cc:	73006c65 	movwvc	r6, #3173	; 0xc65
    10d0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10d4:	756f635f 	strbvc	r6, [pc, #-863]!	; d7d <shift+0xd7d>
    10d8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    10dc:	736e7500 	cmnvc	lr, #0, 10
    10e0:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    10e4:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
    10e8:	49007261 	stmdbmi	r0, {r0, r5, r6, r9, ip, sp, lr}
    10ec:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    10f0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    10f4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    10f8:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
    10fc:	47007065 	strmi	r7, [r0, -r5, rrx]
    1100:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1104:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
    1108:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
    110c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1110:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1114:	6f697461 	svcvs	0x00697461
    1118:	5a5f006e 	bpl	17c12d8 <__bss_end+0x17b703c>
    111c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1120:	4f495047 	svcmi	0x00495047
    1124:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1128:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    112c:	61573431 	cmpvs	r7, r1, lsr r4
    1130:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
    1134:	455f726f 	ldrbmi	r7, [pc, #-623]	; ecd <shift+0xecd>
    1138:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    113c:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
    1140:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1144:	6353006a 	cmpvs	r3, #106	; 0x6a
    1148:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    114c:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    1150:	55410052 	strbpl	r0, [r1, #-82]	; 0xffffffae
    1154:	61425f58 	cmpvs	r2, r8, asr pc
    1158:	42006573 	andmi	r6, r0, #482344960	; 0x1cc00000
    115c:	5f324353 	svcpl	0x00324353
    1160:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    1164:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
    1168:	4f5f6574 	svcmi	0x005f6574
    116c:	00796c6e 	rsbseq	r6, r9, lr, ror #24
    1170:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1174:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    1178:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    117c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1180:	5f4f4950 	svcpl	0x004f4950
    1184:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1188:	3172656c 	cmncc	r2, ip, ror #10
    118c:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
    1190:	5f656c64 	svcpl	0x00656c64
    1194:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
    1198:	69540076 	ldmdbvs	r4, {r1, r2, r4, r5, r6}^
    119c:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    11a0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    11a4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    11a8:	4f433331 	svcmi	0x00433331
    11ac:	5f44454c 	svcpl	0x0044454c
    11b0:	70736944 	rsbsvc	r6, r3, r4, asr #18
    11b4:	3979616c 	ldmdbcc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
    11b8:	5f746553 	svcpl	0x00746553
    11bc:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    11c0:	7474456c 	ldrbtvc	r4, [r4], #-1388	; 0xfffffa94
    11c4:	5a5f0062 	bpl	17c1354 <__bss_end+0x17b70b8>
    11c8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    11cc:	636f7250 	cmnvs	pc, #80, 4
    11d0:	5f737365 	svcpl	0x00737365
    11d4:	616e614d 	cmnvs	lr, sp, asr #2
    11d8:	31726567 	cmncc	r2, r7, ror #10
    11dc:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
    11e0:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
    11e4:	5f656c69 	svcpl	0x00656c69
    11e8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    11ec:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    11f0:	6c41006a 	mcrrvs	0, 6, r0, r1, cr10
    11f4:	00305f74 	eorseq	r5, r0, r4, ror pc
    11f8:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    11fc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1200:	5f6d6574 	svcpl	0x006d6574
    1204:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    1208:	41007265 	tstmi	r0, r5, ror #4
    120c:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
    1210:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1214:	4100335f 	tstmi	r0, pc, asr r3
    1218:	345f746c 	ldrbcc	r7, [pc], #-1132	; 1220 <shift+0x1220>
    121c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1220:	5f00355f 	svcpl	0x0000355f
    1224:	31314e5a 	teqcc	r1, sl, asr lr
    1228:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
    122c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1230:	316d6574 	smccc	54868	; 0xd654
    1234:	53465433 	movtpl	r5, #25651	; 0x6433
    1238:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    123c:	6f4e5f65 	svcvs	0x004e5f65
    1240:	30316564 	eorscc	r6, r1, r4, ror #10
    1244:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
    1248:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
    124c:	5045646c 	subpl	r6, r5, ip, ror #8
    1250:	4800634b 	stmdami	r0, {r0, r1, r3, r6, r8, r9, sp, lr}
    1254:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1258:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    125c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1260:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1264:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1268:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    126c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1270:	4f495047 	svcmi	0x00495047
    1274:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1278:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    127c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1280:	50475f74 	subpl	r5, r7, r4, ror pc
    1284:	5f524c43 	svcpl	0x00524c43
    1288:	61636f4c 	cmnvs	r3, ip, asr #30
    128c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1290:	6a526a45 	bvs	149bbac <__bss_end+0x1491910>
    1294:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1298:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
    129c:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
    12a0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    12a4:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    12a8:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    12ac:	006e6961 	rsbeq	r6, lr, r1, ror #18
    12b0:	70736964 	rsbsvc	r6, r3, r4, ror #18
    12b4:	72507300 	subsvc	r7, r0, #0, 6
    12b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12bc:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    12c0:	74755000 	ldrbtvc	r5, [r5], #-0
    12c4:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
    12c8:	00676e69 	rsbeq	r6, r7, r9, ror #28
    12cc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    12d0:	61485f4f 	cmpvs	r8, pc, asr #30
    12d4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    12d8:	6c410072 	mcrrvs	0, 7, r0, r1, cr2
    12dc:	00315f74 	eorseq	r5, r1, r4, ror pc
    12e0:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
    12e4:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
    12e8:	73694400 	cmnvc	r9, #0, 8
    12ec:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    12f0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    12f4:	445f746e 	ldrbmi	r7, [pc], #-1134	; 12fc <shift+0x12fc>
    12f8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    12fc:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
    1300:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1304:	5f747075 	svcpl	0x00747075
    1308:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    130c:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    1310:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
    1314:	00657361 	rsbeq	r7, r5, r1, ror #6
    1318:	5f534654 	svcpl	0x00534654
    131c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    1320:	52007265 	andpl	r7, r0, #1342177286	; 0x50000006
    1324:	5f646165 	svcpl	0x00646165
    1328:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    132c:	4e490065 	cdpmi	0, 4, cr0, cr9, cr5, {3}
    1330:	494e4946 	stmdbmi	lr, {r1, r2, r6, r8, fp, lr}^
    1334:	41005954 	tstmi	r0, r4, asr r9
    1338:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    133c:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1340:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1344:	6f435f73 	svcvs	0x00435f73
    1348:	00746e75 	rsbseq	r6, r4, r5, ror lr
    134c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1350:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1354:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1358:	614d5f73 	hvcvs	54771	; 0xd5f3
    135c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1360:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
    1364:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1368:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    136c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1370:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1374:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1378:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
    137c:	5f495753 	svcpl	0x00495753
    1380:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1384:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1388:	535f6d65 	cmppl	pc, #6464	; 0x1940
    138c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1390:	6a6a6563 	bvs	1a9a924 <__bss_end+0x1a90688>
    1394:	3131526a 	teqcc	r1, sl, ror #4
    1398:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    139c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    13a0:	00746c75 	rsbseq	r6, r4, r5, ror ip
    13a4:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
    13a8:	455f656c 	ldrbmi	r6, [pc, #-1388]	; e44 <shift+0xe44>
    13ac:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    13b0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    13b4:	00746365 	rsbseq	r6, r4, r5, ror #6
    13b8:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    13bc:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
    13c0:	6c630065 	stclvs	0, cr0, [r3], #-404	; 0xfffffe6c
    13c4:	0065736f 	rsbeq	r7, r5, pc, ror #6
    13c8:	5f746553 	svcpl	0x00746553
    13cc:	616c6552 	cmnvs	ip, r2, asr r5
    13d0:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    13d4:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    13d8:	006c6176 	rsbeq	r6, ip, r6, ror r1
    13dc:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
    13e0:	70697000 	rsbvc	r7, r9, r0
    13e4:	63730065 	cmnvs	r3, #101	; 0x65
    13e8:	5f646568 	svcpl	0x00646568
    13ec:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    13f0:	64720064 	ldrbtvs	r0, [r2], #-100	; 0xffffff9c
    13f4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    13f8:	31315a5f 	teqcc	r1, pc, asr sl
    13fc:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1400:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1404:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
    1408:	315a5f00 	cmpcc	sl, r0, lsl #30
    140c:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    1410:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1414:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    1418:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    141c:	006a656e 	rsbeq	r6, sl, lr, ror #10
    1420:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1424:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1428:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    142c:	6a6a7966 	bvs	1a9f9cc <__bss_end+0x1a95730>
    1430:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1434:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1438:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    143c:	46006965 	strmi	r6, [r0], -r5, ror #18
    1440:	006c6961 	rsbeq	r6, ip, r1, ror #18
    1444:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    1448:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    144c:	325a5f00 	subscc	r5, sl, #0, 30
    1450:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1454:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    1458:	5f657669 	svcpl	0x00657669
    145c:	636f7270 	cmnvs	pc, #112, 4
    1460:	5f737365 	svcpl	0x00737365
    1464:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1468:	74007674 	strvc	r7, [r0], #-1652	; 0xfffff98c
    146c:	5f6b6369 	svcpl	0x006b6369
    1470:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1474:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1478:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    147c:	50006465 	andpl	r6, r0, r5, ror #8
    1480:	5f657069 	svcpl	0x00657069
    1484:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1488:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
    148c:	00786966 	rsbseq	r6, r8, r6, ror #18
    1490:	5f746553 	svcpl	0x00746553
    1494:	61726150 	cmnvs	r2, r0, asr r1
    1498:	5f00736d 	svcpl	0x0000736d
    149c:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    14a0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 14a8 <shift+0x14a8>
    14a4:	5f6b6369 	svcpl	0x006b6369
    14a8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    14ac:	73007674 	movwvc	r7, #1652	; 0x674
    14b0:	7065656c 	rsbvc	r6, r5, ip, ror #10
    14b4:	73694400 	cmnvc	r9, #0, 8
    14b8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    14bc:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    14c0:	445f746e 	ldrbmi	r7, [pc], #-1134	; 14c8 <shift+0x14c8>
    14c4:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    14c8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    14cc:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
    14d0:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    14d4:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    14d8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    14dc:	6f00656e 	svcvs	0x0000656e
    14e0:	61726570 	cmnvs	r2, r0, ror r5
    14e4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    14e8:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    14ec:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    14f0:	2f006a65 	svccs	0x00006a65
    14f4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    14f8:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    14fc:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    1500:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    1504:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    1508:	2f70732f 	svccs	0x0070732f
    150c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1510:	2f736563 	svccs	0x00736563
    1514:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1518:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    151c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1520:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1524:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1528:	5f007070 	svcpl	0x00007070
    152c:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
    1530:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    1534:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
    1538:	00656d61 	rsbeq	r6, r5, r1, ror #26
    153c:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1540:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    1544:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1548:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    154c:	5a5f006e 	bpl	17c170c <__bss_end+0x17b7470>
    1550:	70697034 	rsbvc	r7, r9, r4, lsr r0
    1554:	634b5065 	movtvs	r5, #45157	; 0xb065
    1558:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    155c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1560:	5f656e69 	svcpl	0x00656e69
    1564:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1568:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    156c:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1570:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1578 <shift+0x1578>
    1574:	5f6b6369 	svcpl	0x006b6369
    1578:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    157c:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
    1580:	2f656d6f 	svccs	0x00656d6f
    1584:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    1588:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    158c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    1590:	2f736f2f 	svccs	0x00736f2f
    1594:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1598:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    159c:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    15a0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    15a4:	72617000 	rsbvc	r7, r1, #0
    15a8:	5f006d61 	svcpl	0x00006d61
    15ac:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
    15b0:	6a657469 	bvs	195e75c <__bss_end+0x19544c0>
    15b4:	6a634b50 	bvs	18d42fc <__bss_end+0x18ca060>
    15b8:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    15bc:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    15c0:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    15c4:	5f736b63 	svcpl	0x00736b63
    15c8:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 15d0 <shift+0x15d0>
    15cc:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    15d0:	00656e69 	rsbeq	r6, r5, r9, ror #28
    15d4:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    15d8:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    15dc:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    15e0:	4700657a 	smlsdxmi	r0, sl, r5, r6
    15e4:	505f7465 	subspl	r7, pc, r5, ror #8
    15e8:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    15ec:	5a5f0073 	bpl	17c17c0 <__bss_end+0x17b7524>
    15f0:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    15f4:	6a6a7065 	bvs	1a9d790 <__bss_end+0x1a934f4>
    15f8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    15fc:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    1600:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    1604:	4500676e 	strmi	r6, [r0, #-1902]	; 0xfffff892
    1608:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    160c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1610:	5f746e65 	svcpl	0x00746e65
    1614:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1618:	6f697463 	svcvs	0x00697463
    161c:	5a5f006e 	bpl	17c17dc <__bss_end+0x17b7540>
    1620:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
    1624:	61745f74 	cmnvs	r4, r4, ror pc
    1628:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 1630 <shift+0x1630>
    162c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1630:	5f6f745f 	svcpl	0x006f745f
    1634:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1638:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    163c:	534e0076 	movtpl	r0, #57462	; 0xe076
    1640:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1644:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1648:	6f435f74 	svcvs	0x00435f74
    164c:	77006564 	strvc	r6, [r0, -r4, ror #10]
    1650:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
    1654:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1658:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    165c:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
    1660:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1664:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1668:	4e36316a 	rsfmisz	f3, f6, #2.0
    166c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1670:	704f5f6c 	subvc	r5, pc, ip, ror #30
    1674:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1678:	506e6f69 	rsbpl	r6, lr, r9, ror #30
    167c:	6f690076 	svcvs	0x00690076
    1680:	006c7463 	rsbeq	r7, ip, r3, ror #8
    1684:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1688:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    168c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1690:	66667562 	strbtvs	r7, [r6], -r2, ror #10
    1694:	5f007265 	svcpl	0x00007265
    1698:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
    169c:	506a6461 	rsbpl	r6, sl, r1, ror #8
    16a0:	4e006a63 	vmlsmi.f32	s12, s0, s7
    16a4:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    16a8:	704f5f6c 	subvc	r5, pc, ip, ror #30
    16ac:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    16b0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    16b4:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    16b8:	0065646f 	rsbeq	r6, r5, pc, ror #8
    16bc:	5f746567 	svcpl	0x00746567
    16c0:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    16c4:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    16c8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16cc:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    16d0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    16d4:	6c696600 	stclvs	6, cr6, [r9], #-0
    16d8:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
    16dc:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    16e0:	74006461 	strvc	r6, [r0], #-1121	; 0xfffffb9f
    16e4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    16e8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    16ec:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    16f0:	00646970 	rsbeq	r6, r4, r0, ror r9
    16f4:	6f345a5f 	svcvs	0x00345a5f
    16f8:	506e6570 	rsbpl	r6, lr, r0, ror r5
    16fc:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1700:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    1704:	704f5f65 	subvc	r5, pc, r5, ror #30
    1708:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 157c <shift+0x157c>
    170c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1710:	20554e47 	subscs	r4, r5, r7, asr #28
    1714:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
    1718:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
    171c:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1720:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1724:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1728:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    172c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1730:	5b202965 	blpl	80bccc <__bss_end+0x801a30>
    1734:	2f4d5241 	svccs	0x004d5241
    1738:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    173c:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1740:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1744:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1748:	6f697369 	svcvs	0x00697369
    174c:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1750:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1754:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1758:	616f6c66 	cmnvs	pc, r6, ror #24
    175c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1760:	61683d69 	cmnvs	r8, r9, ror #26
    1764:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1768:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    176c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1770:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1774:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1778:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    177c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1780:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1784:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1788:	20706676 	rsbscs	r6, r0, r6, ror r6
    178c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1790:	613d656e 	teqvs	sp, lr, ror #10
    1794:	31316d72 	teqcc	r1, r2, ror sp
    1798:	7a6a3637 	bvc	1a8f07c <__bss_end+0x1a84de0>
    179c:	20732d66 	rsbscs	r2, r3, r6, ror #26
    17a0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    17a4:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    17a8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17ac:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    17b0:	6b7a3676 	blvs	1e8f190 <__bss_end+0x1e84ef4>
    17b4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    17b8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    17bc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    17c0:	304f2d20 	subcc	r2, pc, r0, lsr #26
    17c4:	304f2d20 	subcc	r2, pc, r0, lsr #26
    17c8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    17cc:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
    17d0:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    17d4:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    17d8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    17dc:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
    17e0:	5f006974 	svcpl	0x00006974
    17e4:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    17e8:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    17ec:	50764b50 	rsbspl	r4, r6, r0, asr fp
    17f0:	2f006976 	svccs	0x00006976
    17f4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    17f8:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    17fc:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    1800:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    1804:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    1808:	2f70732f 	svccs	0x0070732f
    180c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1810:	2f736563 	svccs	0x00736563
    1814:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1818:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    181c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1820:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    1824:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1828:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    182c:	6d657200 	sfmvs	f7, 2, [r5, #-0]
    1830:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
    1834:	69007265 	stmdbvs	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    1838:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    183c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    1840:	61726765 	cmnvs	r2, r5, ror #14
    1844:	7369006c 	cmnvc	r9, #108	; 0x6c
    1848:	00666e69 	rsbeq	r6, r6, r9, ror #28
    184c:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    1850:	006c616d 	rsbeq	r6, ip, sp, ror #2
    1854:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1858:	6a616f74 	bvs	185d630 <__bss_end+0x1853394>
    185c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1860:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1864:	696f7000 	stmdbvs	pc!, {ip, sp, lr}^	; <UNPREDICTABLE>
    1868:	735f746e 	cmpvc	pc, #1845493760	; 0x6e000000
    186c:	006e6565 	rsbeq	r6, lr, r5, ror #10
    1870:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1874:	645f676e 	ldrbvs	r6, [pc], #-1902	; 187c <shift+0x187c>
    1878:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    187c:	00736c61 	rsbseq	r6, r3, r1, ror #24
    1880:	65776f70 	ldrbvs	r6, [r7, #-3952]!	; 0xfffff090
    1884:	74730072 	ldrbtvc	r0, [r3], #-114	; 0xffffff8e
    1888:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    188c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1890:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
    1894:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    1898:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    189c:	5a5f0074 	bpl	17c1a74 <__bss_end+0x17b77d8>
    18a0:	6f746134 	svcvs	0x00746134
    18a4:	634b5066 	movtvs	r5, #45158	; 0xb066
    18a8:	73656400 	cmnvc	r5, #0, 8
    18ac:	5a5f0074 	bpl	17c1a84 <__bss_end+0x17b77e8>
    18b0:	76657236 			; <UNDEFINED> instruction: 0x76657236
    18b4:	50727473 	rsbspl	r7, r2, r3, ror r4
    18b8:	5a5f0063 	bpl	17c1a4c <__bss_end+0x17b77b0>
    18bc:	6e736935 			; <UNDEFINED> instruction: 0x6e736935
    18c0:	00666e61 	rsbeq	r6, r6, r1, ror #28
    18c4:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    18c8:	61620074 	smcvs	8196	; 0x2004
    18cc:	74006573 	strvc	r6, [r0], #-1395	; 0xfffffa8d
    18d0:	00706d65 	rsbseq	r6, r0, r5, ror #26
    18d4:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    18d8:	6f72657a 	svcvs	0x0072657a
    18dc:	00697650 	rsbeq	r7, r9, r0, asr r6
    18e0:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    18e4:	00797063 	rsbseq	r7, r9, r3, rrx
    18e8:	616f7469 	cmnvs	pc, r9, ror #8
    18ec:	72747300 	rsbsvc	r7, r4, #0, 6
    18f0:	74730031 	ldrbtvc	r0, [r3], #-49	; 0xffffffcf
    18f4:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    18f8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    18fc:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1900:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    1904:	5f006666 	svcpl	0x00006666
    1908:	6f70335a 	svcvs	0x0070335a
    190c:	006a6677 	rsbeq	r6, sl, r7, ror r6
    1910:	31315a5f 	teqcc	r1, pc, asr sl
    1914:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    1918:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    191c:	6674616f 	ldrbtvs	r6, [r4], -pc, ror #2
    1920:	5f536a52 	svcpl	0x00536a52
    1924:	61006952 	tstvs	r0, r2, asr r9
    1928:	00666f74 	rsbeq	r6, r6, r4, ror pc
    192c:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    1930:	43007473 	movwmi	r7, #1139	; 0x473
    1934:	43726168 	cmnmi	r2, #104, 2
    1938:	41766e6f 	cmnmi	r6, pc, ror #28
    193c:	66007272 			; <UNDEFINED> instruction: 0x66007272
    1940:	00616f74 	rsbeq	r6, r1, r4, ror pc
    1944:	33325a5f 	teqcc	r2, #389120	; 0x5f000
    1948:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    194c:	5f6c616d 	svcpl	0x006c616d
    1950:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    1954:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1958:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    195c:	6a74616f 	bvs	1d19f20 <__bss_end+0x1d0fc84>
    1960:	00696350 	rsbeq	r6, r9, r0, asr r3
    1964:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1968:	70006372 	andvc	r6, r0, r2, ror r3
    196c:	69636572 	stmdbvs	r3!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1970:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1974:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    1978:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    197c:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1980:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
    1984:	00786564 	rsbseq	r6, r8, r4, ror #10
    1988:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    198c:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1990:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    1994:	5f007374 	svcpl	0x00007374
    1998:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    199c:	4b50696f 	blmi	141bf60 <__bss_end+0x1411cc4>
    19a0:	756f0063 	strbvc	r0, [pc, #-99]!	; 1945 <shift+0x1945>
    19a4:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    19a8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    19ac:	616f7466 	cmnvs	pc, r6, ror #8
    19b0:	6a635066 	bvs	18d5b50 <__bss_end+0x18cb8b4>
    19b4:	6c707300 	ldclvs	3, cr7, [r0], #-0
    19b8:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19bc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    19c0:	63616600 	cmnvs	r1, #0, 12
    19c4:	5a5f0074 	bpl	17c1b9c <__bss_end+0x17b7900>
    19c8:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    19cc:	506e656c 	rsbpl	r6, lr, ip, ror #10
    19d0:	5f00634b 	svcpl	0x0000634b
    19d4:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    19d8:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    19dc:	634b5070 	movtvs	r5, #45168	; 0xb070
    19e0:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    19e4:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    19e8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    19ec:	50797063 	rsbspl	r7, r9, r3, rrx
    19f0:	634b5063 	movtvs	r5, #45155	; 0xb063
    19f4:	65640069 	strbvs	r0, [r4, #-105]!	; 0xffffff97
    19f8:	616d6963 	cmnvs	sp, r3, ror #18
    19fc:	6f745f6c 	svcvs	0x00745f6c
    1a00:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1a04:	5f676e69 	svcpl	0x00676e69
    1a08:	616f6c66 	cmnvs	pc, r6, ror #24
    1a0c:	5a5f0074 	bpl	17c1be4 <__bss_end+0x17b7948>
    1a10:	6f746634 	svcvs	0x00746634
    1a14:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    1a18:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1a1c:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1a20:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    1a24:	73006874 	movwvc	r6, #2164	; 0x874
    1a28:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1a2c:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    1a30:	72747376 	rsbsvc	r7, r4, #-671088639	; 0xd8000001
    1a34:	695f5f00 	ldmdbvs	pc, {r8, r9, sl, fp, ip, lr}^	; <UNPREDICTABLE>
    1a38:	68635f6e 	stmdavs	r3!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a3c:	54006772 	strpl	r6, [r0], #-1906	; 0xfffff88e
    1a40:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1a44:	5f79616c 	svcpl	0x0079616c
    1a48:	6b636150 	blvs	18d9f90 <__bss_end+0x18cfcf4>
    1a4c:	485f7465 	ldmdami	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1a50:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1a54:	44540072 	ldrbmi	r0, [r4], #-114	; 0xffffff8e
    1a58:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1a5c:	4e5f7961 	vnmlami.f16	s15, s30, s3	; <UNPREDICTABLE>
    1a60:	61506e6f 	cmpvs	r0, pc, ror #28
    1a64:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
    1a68:	63697274 	cmnvs	r9, #116, 4	; 0x40000007
    1a6c:	6361505f 	cmnvs	r1, #95	; 0x5f
    1a70:	0074656b 	rsbseq	r6, r4, fp, ror #10
    1a74:	73696874 	cmnvc	r9, #116, 16	; 0x740000
    1a78:	454c4f00 	strbmi	r4, [ip, #-3840]	; 0xfffff100
    1a7c:	6f465f44 	svcvs	0x00465f44
    1a80:	445f746e 	ldrbmi	r7, [pc], #-1134	; 1a88 <shift+0x1a88>
    1a84:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    1a88:	7600746c 	strvc	r7, [r0], -ip, ror #8
    1a8c:	70696c66 	rsbvc	r6, r9, r6, ror #24
    1a90:	6f682f00 	svcvs	0x00682f00
    1a94:	6a2f656d 	bvs	bdb050 <__bss_end+0xbd0db4>
    1a98:	73656d61 	cmnvc	r5, #6208	; 0x1840
    1a9c:	2f697261 	svccs	0x00697261
    1aa0:	2f746967 	svccs	0x00746967
    1aa4:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    1aa8:	6f732f70 	svcvs	0x00732f70
    1aac:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1ab0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1ab4:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1ab8:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1abc:	6f2f6372 	svcvs	0x002f6372
    1ac0:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
    1ac4:	00707063 	rsbseq	r7, r0, r3, rrx
    1ac8:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1acc:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1ad0:	6172445f 	cmnvs	r2, pc, asr r4
    1ad4:	69505f77 	ldmdbvs	r0, {r0, r1, r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad8:	5f6c6578 	svcpl	0x006c6578
    1adc:	61727241 	cmnvs	r2, r1, asr #4
    1ae0:	61505f79 	cmpvs	r0, r9, ror pc
    1ae4:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    1ae8:	61724400 	cmnvs	r2, r0, lsl #8
    1aec:	69505f77 	ldmdbvs	r0, {r0, r1, r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1af0:	5f6c6578 	svcpl	0x006c6578
    1af4:	61727241 	cmnvs	r2, r1, asr #4
    1af8:	6f545f79 	svcvs	0x00545f79
    1afc:	6365525f 	cmnvs	r5, #-268435451	; 0xf0000005
    1b00:	44540074 	ldrbmi	r0, [r4], #-116	; 0xffffff8c
    1b04:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1b08:	505f7961 	subspl	r7, pc, r1, ror #18
    1b0c:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    1b10:	6570535f 	ldrbvs	r5, [r0, #-863]!	; 0xfffffca1
    1b14:	61700063 	cmnvs	r0, r3, rrx
    1b18:	54006874 	strpl	r6, [r0], #-2164	; 0xfffff78c
    1b1c:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1b20:	5f79616c 	svcpl	0x0079616c
    1b24:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    1b28:	545f736c 	ldrbpl	r7, [pc], #-876	; 1b30 <shift+0x1b30>
    1b2c:	65525f6f 	ldrbvs	r5, [r2, #-3951]	; 0xfffff091
    1b30:	43007463 	movwmi	r7, #1123	; 0x463
    1b34:	5f726168 	svcpl	0x00726168
    1b38:	00646e45 	rsbeq	r6, r4, r5, asr #28
    1b3c:	70696c46 	rsbvc	r6, r9, r6, asr #24
    1b40:	6168435f 	cmnvs	r8, pc, asr r3
    1b44:	54007372 	strpl	r7, [r0], #-882	; 0xfffffc8e
    1b48:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1b4c:	5f79616c 	svcpl	0x0079616c
    1b50:	61656c43 	cmnvs	r5, r3, asr #24
    1b54:	61505f72 	cmpvs	r0, r2, ror pc
    1b58:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    1b5c:	61684300 	cmnvs	r8, r0, lsl #6
    1b60:	69575f72 	ldmdbvs	r7, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b64:	00687464 	rsbeq	r7, r8, r4, ror #8
    1b68:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
    1b6c:	6e6f465f 	mcrvs	6, 3, r4, cr15, cr15, {2}
    1b70:	444e0074 	strbmi	r0, [lr], #-116	; 0xffffff8c
    1b74:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1b78:	435f7961 	cmpmi	pc, #1589248	; 0x184000
    1b7c:	616d6d6f 	cmnvs	sp, pc, ror #26
    1b80:	6600646e 	strvs	r6, [r0], -lr, ror #8
    1b84:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
    1b88:	61724400 	cmnvs	r2, r0, lsl #8
    1b8c:	69505f77 	ldmdbvs	r0, {r0, r1, r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b90:	5f6c6578 	svcpl	0x006c6578
    1b94:	61727241 	cmnvs	r2, r1, asr #4
    1b98:	6c630079 	stclvs	0, cr0, [r3], #-484	; 0xfffffe1c
    1b9c:	53726165 	cmnpl	r2, #1073741849	; 0x40000019
    1ba0:	5f007465 	svcpl	0x00007465
    1ba4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    1ba8:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
    1bac:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
    1bb0:	616c7073 	smcvs	50947	; 0xc703
    1bb4:	45324379 	ldrmi	r4, [r2, #-889]!	; 0xfffffc87
    1bb8:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1bbc:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
    1bc0:	00745f38 	rsbseq	r5, r4, r8, lsr pc
    1bc4:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1bc8:	6965485f 	stmdbvs	r5!, {r0, r1, r2, r3, r4, r6, fp, lr}^
    1bcc:	00746867 	rsbseq	r6, r4, r7, ror #16
    1bd0:	64616568 	strbtvs	r6, [r1], #-1384	; 0xfffffa98
    1bd4:	43007265 	movwmi	r7, #613	; 0x265
    1bd8:	5f726168 	svcpl	0x00726168
    1bdc:	69676542 	stmdbvs	r7!, {r1, r6, r8, sl, sp, lr}^
    1be0:	5a5f006e 	bpl	17c1da0 <__bss_end+0x17b7b04>
    1be4:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1be8:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
    1bec:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
    1bf0:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1bf4:	76453244 	strbvc	r3, [r5], -r4, asr #4
    1bf8:	2f2e2e00 	svccs	0x002e2e00
    1bfc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c00:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c04:	2f2e2e2f 	svccs	0x002e2e2f
    1c08:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1b58 <shift+0x1b58>
    1c0c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c10:	6f632f63 	svcvs	0x00632f63
    1c14:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1c18:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1c1c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c20:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1c24:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1c28:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1c2c:	2f646c69 	svccs	0x00646c69
    1c30:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1c34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1c38:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1c3c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1c40:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    1c44:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    1c48:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1c4c:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1c50:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1c54:	61652d65 	cmnvs	r5, r5, ror #26
    1c58:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    1c5c:	3130322d 	teqcc	r0, sp, lsr #4
    1c60:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    1c64:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1c68:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1c6c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1c70:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1c74:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1c78:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1c7c:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1c80:	61682f65 	cmnvs	r8, r5, ror #30
    1c84:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 1ac4 <shift+0x1ac4>
    1c88:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c8c:	41540063 	cmpmi	r4, r3, rrx
    1c90:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c94:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c98:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c9c:	61786574 	cmnvs	r8, r4, ror r5
    1ca0:	6f633731 	svcvs	0x00633731
    1ca4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ca8:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    1cac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cb0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1cb4:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1cb8:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1cbc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1cc0:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1cc4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1cc8:	41540074 	cmpmi	r4, r4, ror r0
    1ccc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cd0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cd4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cd8:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1cdc:	41003332 	tstmi	r0, r2, lsr r3
    1ce0:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; f96 <shift+0xf96>
    1ce4:	41540051 	cmpmi	r4, r1, asr r0
    1ce8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cf4:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1cf8:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    1cfc:	61736900 	cmnvs	r3, r0, lsl #18
    1d00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d04:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1d08:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    1d0c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d10:	50435f54 	subpl	r5, r3, r4, asr pc
    1d14:	6f635f55 	svcvs	0x00635f55
    1d18:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d1c:	63373561 	teqvs	r7, #406847488	; 0x18400000
    1d20:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d24:	33356178 	teqcc	r5, #120, 2
    1d28:	53414200 	movtpl	r4, #4608	; 0x1200
    1d2c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d30:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1d34:	41425f4d 	cmpmi	r2, sp, asr #30
    1d38:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    1d3c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d40:	50435f54 	subpl	r5, r3, r4, asr pc
    1d44:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1d48:	3031386d 	eorscc	r3, r1, sp, ror #16
    1d4c:	52415400 	subpl	r5, r1, #0, 8
    1d50:	5f544547 	svcpl	0x00544547
    1d54:	5f555043 	svcpl	0x00555043
    1d58:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    1d5c:	41003165 	tstmi	r0, r5, ror #2
    1d60:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1d64:	415f5343 	cmpmi	pc, r3, asr #6
    1d68:	53435041 	movtpl	r5, #12353	; 0x3041
    1d6c:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    1d70:	0054584d 	subseq	r5, r4, sp, asr #16
    1d74:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d78:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d7c:	00305f48 	eorseq	r5, r0, r8, asr #30
    1d80:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d84:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d88:	00325f48 	eorseq	r5, r2, r8, asr #30
    1d8c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d90:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d94:	00335f48 	eorseq	r5, r3, r8, asr #30
    1d98:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d9c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1da0:	00345f48 	eorseq	r5, r4, r8, asr #30
    1da4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1da8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1dac:	00365f48 	eorseq	r5, r6, r8, asr #30
    1db0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1db4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1db8:	00375f48 	eorseq	r5, r7, r8, asr #30
    1dbc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dc0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dc4:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1dc8:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1dcc:	73690065 	cmnvc	r9, #101	; 0x65
    1dd0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1dd4:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1dd8:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1ddc:	41540073 	cmpmi	r4, r3, ror r0
    1de0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1de4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1de8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1dec:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1df0:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    1df4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1df8:	50435f54 	subpl	r5, r3, r4, asr pc
    1dfc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e00:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    1e04:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1e08:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1e0c:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1e10:	52415400 	subpl	r5, r1, #0, 8
    1e14:	5f544547 	svcpl	0x00544547
    1e18:	5f555043 	svcpl	0x00555043
    1e1c:	316d7261 	cmncc	sp, r1, ror #4
    1e20:	6a363731 	bvs	d8faec <__bss_end+0xd85850>
    1e24:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1e28:	5f617369 	svcpl	0x00617369
    1e2c:	5f746962 	svcpl	0x00746962
    1e30:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1e34:	52410032 	subpl	r0, r1, #50	; 0x32
    1e38:	43505f4d 	cmpmi	r0, #308	; 0x134
    1e3c:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    1e40:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    1e44:	4154004e 	cmpmi	r4, lr, asr #32
    1e48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e50:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e54:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    1e58:	5f455341 	svcpl	0x00455341
    1e5c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e60:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1e64:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1e68:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1e6c:	5f6d7366 	svcpl	0x006d7366
    1e70:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1e74:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1e78:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e7c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1e80:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    1e84:	63657073 	cmnvs	r5, #115	; 0x73
    1e88:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1e8c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1e90:	61736900 	cmnvs	r3, r0, lsl #18
    1e94:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e98:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1e9c:	635f5f00 	cmpvs	pc, #0, 30
    1ea0:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1ea8 <shift+0x1ea8>
    1ea4:	41006261 	tstmi	r0, r1, ror #4
    1ea8:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1eac:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1eb0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1eb4:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1eb8:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1ebc:	52410065 	subpl	r0, r1, #101	; 0x65
    1ec0:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1ec4:	4d524100 	ldfmie	f4, [r2, #-0]
    1ec8:	0053565f 	subseq	r5, r3, pc, asr r6
    1ecc:	5f4d5241 	svcpl	0x004d5241
    1ed0:	61004547 	tstvs	r0, r7, asr #10
    1ed4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1edc <shift+0x1edc>
    1ed8:	5f656e75 	svcpl	0x00656e75
    1edc:	6f727473 	svcvs	0x00727473
    1ee0:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1ee4:	6f63006d 	svcvs	0x0063006d
    1ee8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1eec:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1ef0:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1ef4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ef8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1efc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f00:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f04:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1f08:	52415400 	subpl	r5, r1, #0, 8
    1f0c:	5f544547 	svcpl	0x00544547
    1f10:	5f555043 	svcpl	0x00555043
    1f14:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1f18:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1f1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f24:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f28:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f2c:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1f30:	4d524100 	ldfmie	f4, [r2, #-0]
    1f34:	0054475f 	subseq	r4, r4, pc, asr r7
    1f38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f40:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    1f44:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    1f48:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    1f4c:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    1f50:	2f2e2e2f 	svccs	0x002e2e2f
    1f54:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1f58:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1f5c:	2f2e2e2f 	svccs	0x002e2e2f
    1f60:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1f64:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1de0 <shift+0x1de0>
    1f68:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f6c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1f70:	52415400 	subpl	r5, r1, #0, 8
    1f74:	5f544547 	svcpl	0x00544547
    1f78:	5f555043 	svcpl	0x00555043
    1f7c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f80:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1f84:	41420066 	cmpmi	r2, r6, rrx
    1f88:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1f8c:	5f484352 	svcpl	0x00484352
    1f90:	004d4537 	subeq	r4, sp, r7, lsr r5
    1f94:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f98:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f9c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fa0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fa4:	32316178 	eorscc	r6, r1, #120, 2
    1fa8:	73616800 	cmnvc	r1, #0, 16
    1fac:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1fb0:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    1fb4:	5f455341 	svcpl	0x00455341
    1fb8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1fbc:	5a4b365f 	bpl	12cf940 <__bss_end+0x12c56a4>
    1fc0:	61736900 	cmnvs	r3, r0, lsl #18
    1fc4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fc8:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1fcc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1fd0:	615f6863 	cmpvs	pc, r3, ror #16
    1fd4:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1fd8:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1fdc:	6d726100 	ldfvse	f6, [r2, #-0]
    1fe0:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1fe4:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1fe8:	73690063 	cmnvc	r9, #99	; 0x63
    1fec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ff0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1ff4:	47003631 	smladxmi	r0, r1, r6, r3
    1ff8:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1ffc:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    2000:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    2004:	31303220 	teqcc	r0, r0, lsr #4
    2008:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    200c:	72282035 	eorvc	r2, r8, #53	; 0x35
    2010:	61656c65 	cmnvs	r5, r5, ror #24
    2014:	20296573 	eorcs	r6, r9, r3, ror r5
    2018:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    201c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    2020:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    2024:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    2028:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    202c:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    2030:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    2034:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    2038:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    203c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    2040:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    2044:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    2048:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    204c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    2050:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    2054:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2058:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    205c:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    2060:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    2064:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2068:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    206c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    2070:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    2074:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    2078:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    207c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    2080:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    2084:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    2088:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    208c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1efc <shift+0x1efc>
    2090:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    2094:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    2098:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    209c:	20726f74 	rsbscs	r6, r2, r4, ror pc
    20a0:	6f6e662d 	svcvs	0x006e662d
    20a4:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    20a8:	20656e69 	rsbcs	r6, r5, r9, ror #28
    20ac:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    20b0:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    20b4:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    20b8:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    20bc:	006e6564 	rsbeq	r6, lr, r4, ror #10
    20c0:	5f4d5241 	svcpl	0x004d5241
    20c4:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    20c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    20cc:	615f7469 	cmpvs	pc, r9, ror #8
    20d0:	00766964 	rsbseq	r6, r6, r4, ror #18
    20d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20dc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20e0:	31316d72 	teqcc	r1, r2, ror sp
    20e4:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    20e8:	52415400 	subpl	r5, r1, #0, 8
    20ec:	5f544547 	svcpl	0x00544547
    20f0:	5f555043 	svcpl	0x00555043
    20f4:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    20f8:	52415400 	subpl	r5, r1, #0, 8
    20fc:	5f544547 	svcpl	0x00544547
    2100:	5f555043 	svcpl	0x00555043
    2104:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2108:	52415400 	subpl	r5, r1, #0, 8
    210c:	5f544547 	svcpl	0x00544547
    2110:	5f555043 	svcpl	0x00555043
    2114:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    2118:	72610036 	rsbvc	r0, r1, #54	; 0x36
    211c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2120:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    2124:	0065736d 	rsbeq	r7, r5, sp, ror #6
    2128:	47524154 			; <UNDEFINED> instruction: 0x47524154
    212c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2130:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2134:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2138:	00346d78 	eorseq	r6, r4, r8, ror sp
    213c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2140:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2144:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2148:	30316d72 	eorscc	r6, r1, r2, ror sp
    214c:	41540065 	cmpmi	r4, r5, rrx
    2150:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2154:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2158:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    215c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2160:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2164:	6f635f6d 	svcvs	0x00635f6d
    2168:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
    216c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    2170:	5f4d5241 	svcpl	0x004d5241
    2174:	5f534350 	svcpl	0x00534350
    2178:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    217c:	73690053 	cmnvc	r9, #83	; 0x53
    2180:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2184:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2188:	5f38766d 	svcpl	0x0038766d
    218c:	41420032 	cmpmi	r2, r2, lsr r0
    2190:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2194:	5f484352 	svcpl	0x00484352
    2198:	54004d33 	strpl	r4, [r0], #-3379	; 0xfffff2cd
    219c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21a0:	50435f54 	subpl	r5, r3, r4, asr pc
    21a4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21a8:	3031376d 	eorscc	r3, r1, sp, ror #14
    21ac:	72610074 	rsbvc	r0, r1, #116	; 0x74
    21b0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    21b4:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    21b8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    21bc:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    21c0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    21c4:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    21c8:	00737469 	rsbseq	r7, r3, r9, ror #8
    21cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21d8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21dc:	70306d78 	eorsvc	r6, r0, r8, ror sp
    21e0:	7373756c 	cmnvc	r3, #108, 10	; 0x1b000000
    21e4:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    21e8:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    21ec:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    21f0:	52415400 	subpl	r5, r1, #0, 8
    21f4:	5f544547 	svcpl	0x00544547
    21f8:	5f555043 	svcpl	0x00555043
    21fc:	6e797865 	cdpvs	8, 7, cr7, cr9, cr5, {3}
    2200:	316d736f 	cmncc	sp, pc, ror #6
    2204:	52415400 	subpl	r5, r1, #0, 8
    2208:	5f544547 	svcpl	0x00544547
    220c:	5f555043 	svcpl	0x00555043
    2210:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2214:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    2218:	73690032 	cmnvc	r9, #50	; 0x32
    221c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2220:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    2224:	70007669 	andvc	r7, r0, r9, ror #12
    2228:	65666572 	strbvs	r6, [r6, #-1394]!	; 0xfffffa8e
    222c:	656e5f72 	strbvs	r5, [lr, #-3954]!	; 0xfffff08e
    2230:	665f6e6f 	ldrbvs	r6, [pc], -pc, ror #28
    2234:	365f726f 	ldrbcc	r7, [pc], -pc, ror #4
    2238:	74696234 	strbtvc	r6, [r9], #-564	; 0xfffffdcc
    223c:	73690073 	cmnvc	r9, #115	; 0x73
    2240:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2244:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2248:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    224c:	4154006c 	cmpmi	r4, ip, rrx
    2250:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2254:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2258:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    225c:	61786574 	cmnvs	r8, r4, ror r5
    2260:	54003233 	strpl	r3, [r0], #-563	; 0xfffffdcd
    2264:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2268:	50435f54 	subpl	r5, r3, r4, asr pc
    226c:	6f635f55 	svcvs	0x00635f55
    2270:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2274:	00353361 	eorseq	r3, r5, r1, ror #6
    2278:	5f617369 	svcpl	0x00617369
    227c:	5f746962 	svcpl	0x00746962
    2280:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2284:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    2288:	736e7500 	cmnvc	lr, #0, 10
    228c:	76636570 			; <UNDEFINED> instruction: 0x76636570
    2290:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2294:	73676e69 	cmnvc	r7, #1680	; 0x690
    2298:	52415400 	subpl	r5, r1, #0, 8
    229c:	5f544547 	svcpl	0x00544547
    22a0:	5f555043 	svcpl	0x00555043
    22a4:	316d7261 	cmncc	sp, r1, ror #4
    22a8:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    22ac:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    22b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22b4:	50435f54 	subpl	r5, r3, r4, asr pc
    22b8:	61665f55 	cmnvs	r6, r5, asr pc
    22bc:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    22c0:	41540065 	cmpmi	r4, r5, rrx
    22c4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22c8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    22d0:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    22d4:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    22d8:	5f455341 	svcpl	0x00455341
    22dc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    22e0:	0054345f 	subseq	r3, r4, pc, asr r4
    22e4:	5f617369 	svcpl	0x00617369
    22e8:	5f746962 	svcpl	0x00746962
    22ec:	70797263 	rsbsvc	r7, r9, r3, ror #4
    22f0:	61006f74 	tstvs	r0, r4, ror pc
    22f4:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    22f8:	5f736765 	svcpl	0x00736765
    22fc:	735f6e69 	cmpvc	pc, #1680	; 0x690
    2300:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    2304:	0065636e 	rsbeq	r6, r5, lr, ror #6
    2308:	5f617369 	svcpl	0x00617369
    230c:	5f746962 	svcpl	0x00746962
    2310:	42006273 	andmi	r6, r0, #805306375	; 0x30000007
    2314:	5f455341 	svcpl	0x00455341
    2318:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    231c:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    2320:	61736900 	cmnvs	r3, r0, lsl #18
    2324:	6165665f 	cmnvs	r5, pc, asr r6
    2328:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    232c:	61736900 	cmnvs	r3, r0, lsl #18
    2330:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2334:	616d735f 	cmnvs	sp, pc, asr r3
    2338:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    233c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    2340:	616c5f6d 	cmnvs	ip, sp, ror #30
    2344:	6f5f676e 	svcvs	0x005f676e
    2348:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    234c:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    2350:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    2354:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2358:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    235c:	5f736574 	svcpl	0x00736574
    2360:	6b6f6f68 	blvs	1bde108 <__bss_end+0x1bd3e6c>
    2364:	61736900 	cmnvs	r3, r0, lsl #18
    2368:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    236c:	5f70665f 	svcpl	0x0070665f
    2370:	00323364 	eorseq	r3, r2, r4, ror #6
    2374:	5f4d5241 	svcpl	0x004d5241
    2378:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    237c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2380:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    2384:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    2388:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    238c:	50435f54 	subpl	r5, r3, r4, asr pc
    2390:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2394:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    2398:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    239c:	6f727000 	svcvs	0x00727000
    23a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    23a4:	745f726f 	ldrbvc	r7, [pc], #-623	; 23ac <shift+0x23ac>
    23a8:	00657079 	rsbeq	r7, r5, r9, ror r0
    23ac:	5f6c6c61 	svcpl	0x006c6c61
    23b0:	73757066 	cmnvc	r5, #102	; 0x66
    23b4:	6d726100 	ldfvse	f6, [r2, #-0]
    23b8:	7363705f 	cmnvc	r3, #95	; 0x5f
    23bc:	53414200 	movtpl	r4, #4608	; 0x1200
    23c0:	52415f45 	subpl	r5, r1, #276	; 0x114
    23c4:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1b89 <shift+0x1b89>
    23c8:	72610054 	rsbvc	r0, r1, #84	; 0x54
    23cc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    23d0:	74346863 	ldrtvc	r6, [r4], #-2147	; 0xfffff79d
    23d4:	52415400 	subpl	r5, r1, #0, 8
    23d8:	5f544547 	svcpl	0x00544547
    23dc:	5f555043 	svcpl	0x00555043
    23e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23e8:	726f6336 	rsbvc	r6, pc, #-671088640	; 0xd8000000
    23ec:	61786574 	cmnvs	r8, r4, ror r5
    23f0:	61003535 	tstvs	r0, r5, lsr r5
    23f4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 23fc <shift+0x23fc>
    23f8:	5f656e75 	svcpl	0x00656e75
    23fc:	66756277 			; <UNDEFINED> instruction: 0x66756277
    2400:	61746800 	cmnvs	r4, r0, lsl #16
    2404:	61685f62 	cmnvs	r8, r2, ror #30
    2408:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    240c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2410:	715f7469 	cmpvc	pc, r9, ror #8
    2414:	6b726975 	blvs	1c9c9f0 <__bss_end+0x1c92754>
    2418:	5f6f6e5f 	svcpl	0x006f6e5f
    241c:	616c6f76 	smcvs	50934	; 0xc6f6
    2420:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2424:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2428:	47524154 			; <UNDEFINED> instruction: 0x47524154
    242c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2430:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2434:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2438:	00306d78 	eorseq	r6, r0, r8, ror sp
    243c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2440:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2444:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2448:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    244c:	00316d78 	eorseq	r6, r1, r8, ror sp
    2450:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2454:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2458:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    245c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2460:	00336d78 	eorseq	r6, r3, r8, ror sp
    2464:	5f617369 	svcpl	0x00617369
    2468:	5f746962 	svcpl	0x00746962
    246c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2470:	00315f38 	eorseq	r5, r1, r8, lsr pc
    2474:	5f6d7261 	svcpl	0x006d7261
    2478:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    247c:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    2480:	73690065 	cmnvc	r9, #101	; 0x65
    2484:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2488:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    248c:	5f38766d 	svcpl	0x0038766d
    2490:	73690033 	cmnvc	r9, #51	; 0x33
    2494:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2498:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    249c:	5f38766d 	svcpl	0x0038766d
    24a0:	73690034 	cmnvc	r9, #52	; 0x34
    24a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    24a8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    24ac:	5f38766d 	svcpl	0x0038766d
    24b0:	41540035 	cmpmi	r4, r5, lsr r0
    24b4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24b8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24bc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    24c0:	61786574 	cmnvs	r8, r4, ror r5
    24c4:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    24c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24cc:	50435f54 	subpl	r5, r3, r4, asr pc
    24d0:	6f635f55 	svcvs	0x00635f55
    24d4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24d8:	00353561 	eorseq	r3, r5, r1, ror #10
    24dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24e4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    24e8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    24ec:	37356178 			; <UNDEFINED> instruction: 0x37356178
    24f0:	52415400 	subpl	r5, r1, #0, 8
    24f4:	5f544547 	svcpl	0x00544547
    24f8:	5f555043 	svcpl	0x00555043
    24fc:	6f63706d 	svcvs	0x0063706d
    2500:	54006572 	strpl	r6, [r0], #-1394	; 0xfffffa8e
    2504:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2508:	50435f54 	subpl	r5, r3, r4, asr pc
    250c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2510:	6f6e5f6d 	svcvs	0x006e5f6d
    2514:	6100656e 	tstvs	r0, lr, ror #10
    2518:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    251c:	5f686372 	svcpl	0x00686372
    2520:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    2524:	52415400 	subpl	r5, r1, #0, 8
    2528:	5f544547 	svcpl	0x00544547
    252c:	5f555043 	svcpl	0x00555043
    2530:	316d7261 	cmncc	sp, r1, ror #4
    2534:	65363230 	ldrvs	r3, [r6, #-560]!	; 0xfffffdd0
    2538:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    253c:	5f455341 	svcpl	0x00455341
    2540:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2544:	004a365f 	subeq	r3, sl, pc, asr r6
    2548:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    254c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2550:	4b365f48 	blmi	d9a278 <__bss_end+0xd8ffdc>
    2554:	53414200 	movtpl	r4, #4608	; 0x1200
    2558:	52415f45 	subpl	r5, r1, #276	; 0x114
    255c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2560:	7369004d 	cmnvc	r9, #77	; 0x4d
    2564:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2568:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    256c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2570:	52415400 	subpl	r5, r1, #0, 8
    2574:	5f544547 	svcpl	0x00544547
    2578:	5f555043 	svcpl	0x00555043
    257c:	316d7261 	cmncc	sp, r1, ror #4
    2580:	6a363331 	bvs	d8f24c <__bss_end+0xd84fb0>
    2584:	41007366 	tstmi	r0, r6, ror #6
    2588:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    258c:	52410053 	subpl	r0, r1, #83	; 0x53
    2590:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    2594:	53414200 	movtpl	r4, #4608	; 0x1200
    2598:	52415f45 	subpl	r5, r1, #276	; 0x114
    259c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    25a0:	4154005a 	cmpmi	r4, sl, asr r0
    25a4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25a8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25ac:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25b0:	61786574 	cmnvs	r8, r4, ror r5
    25b4:	6f633537 	svcvs	0x00633537
    25b8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25bc:	00353561 	eorseq	r3, r5, r1, ror #10
    25c0:	5f4d5241 	svcpl	0x004d5241
    25c4:	5f534350 	svcpl	0x00534350
    25c8:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    25cc:	46565f53 	usaxmi	r5, r6, r3
    25d0:	41540050 	cmpmi	r4, r0, asr r0
    25d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25dc:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    25e0:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    25e4:	61736900 	cmnvs	r3, r0, lsl #18
    25e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25ec:	6f656e5f 	svcvs	0x00656e5f
    25f0:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    25f4:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    25f8:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    25fc:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    2600:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2604:	615f7469 	cmpvs	pc, r9, ror #8
    2608:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    260c:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2610:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2614:	50435f54 	subpl	r5, r3, r4, asr pc
    2618:	61665f55 	cmnvs	r6, r5, asr pc
    261c:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    2620:	41540065 	cmpmi	r4, r5, rrx
    2624:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2628:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    262c:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    2630:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    2634:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    2638:	61746800 	cmnvs	r4, r0, lsl #16
    263c:	61685f62 	cmnvs	r8, r2, ror #30
    2640:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    2644:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2648:	61007265 	tstvs	r0, r5, ror #4
    264c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2654 <shift+0x2654>
    2650:	5f656e75 	svcpl	0x00656e75
    2654:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2658:	615f7865 	cmpvs	pc, r5, ror #16
    265c:	73690039 	cmnvc	r9, #57	; 0x39
    2660:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2664:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2668:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    266c:	41540032 	cmpmi	r4, r2, lsr r0
    2670:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2674:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2678:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    267c:	61786574 	cmnvs	r8, r4, ror r5
    2680:	6f633237 	svcvs	0x00633237
    2684:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2688:	00333561 	eorseq	r3, r3, r1, ror #10
    268c:	5f617369 	svcpl	0x00617369
    2690:	5f746962 	svcpl	0x00746962
    2694:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2698:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    269c:	5f455341 	svcpl	0x00455341
    26a0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    26a4:	0041375f 	subeq	r3, r1, pc, asr r7
    26a8:	5f617369 	svcpl	0x00617369
    26ac:	5f746962 	svcpl	0x00746962
    26b0:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    26b4:	00646f72 	rsbeq	r6, r4, r2, ror pc
    26b8:	5f6d7261 	svcpl	0x006d7261
    26bc:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    26c0:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    26c4:	6f6e5f65 	svcvs	0x006e5f65
    26c8:	41006564 	tstmi	r0, r4, ror #10
    26cc:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 258c <shift+0x258c>
    26d0:	72610049 	rsbvc	r0, r1, #73	; 0x49
    26d4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    26d8:	6b366863 	blvs	d9c86c <__bss_end+0xd925d0>
    26dc:	6d726100 	ldfvse	f6, [r2, #-0]
    26e0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    26e4:	006d3668 	rsbeq	r3, sp, r8, ror #12
    26e8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26ec:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26f0:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    26f4:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    26f8:	6f63706f 	svcvs	0x0063706f
    26fc:	5f746e75 	svcpl	0x00746e75
    2700:	00626174 	rsbeq	r6, r2, r4, ror r1
    2704:	5f617369 	svcpl	0x00617369
    2708:	5f746962 	svcpl	0x00746962
    270c:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    2710:	52415400 	subpl	r5, r1, #0, 8
    2714:	5f544547 	svcpl	0x00544547
    2718:	5f555043 	svcpl	0x00555043
    271c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2720:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2724:	41540033 	cmpmi	r4, r3, lsr r0
    2728:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    272c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2730:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    2734:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    2738:	00613776 	rsbeq	r3, r1, r6, ror r7
    273c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2740:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2744:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2748:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    274c:	36376178 			; <UNDEFINED> instruction: 0x36376178
    2750:	6d726100 	ldfvse	f6, [r2, #-0]
    2754:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2758:	6f6e5f68 	svcvs	0x006e5f68
    275c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 25e8 <shift+0x25e8>
    2760:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2764:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2768:	53414200 	movtpl	r4, #4608	; 0x1200
    276c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2770:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2774:	73690041 	cmnvc	r9, #65	; 0x41
    2778:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    277c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2780:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2784:	53414200 	movtpl	r4, #4608	; 0x1200
    2788:	52415f45 	subpl	r5, r1, #276	; 0x114
    278c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2790:	41540052 	cmpmi	r4, r2, asr r0
    2794:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2798:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    279c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    27a0:	61786574 	cmnvs	r8, r4, ror r5
    27a4:	6f633337 	svcvs	0x00633337
    27a8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27ac:	00353361 	eorseq	r3, r5, r1, ror #6
    27b0:	5f4d5241 	svcpl	0x004d5241
    27b4:	6100564e 	tstvs	r0, lr, asr #12
    27b8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27bc:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    27c0:	6d726100 	ldfvse	f6, [r2, #-0]
    27c4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    27c8:	61003668 	tstvs	r0, r8, ror #12
    27cc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27d0:	37686372 			; <UNDEFINED> instruction: 0x37686372
    27d4:	6d726100 	ldfvse	f6, [r2, #-0]
    27d8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    27dc:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    27e0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    27e4:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    27e8:	6100656c 	tstvs	r0, ip, ror #10
    27ec:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 27f4 <shift+0x27f4>
    27f0:	5f656e75 	svcpl	0x00656e75
    27f4:	61637378 	smcvs	14136	; 0x3738
    27f8:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    27fc:	6e696b61 	vnmulvs.f64	d22, d9, d17
    2800:	6f635f67 	svcvs	0x00635f67
    2804:	5f74736e 	svcpl	0x0074736e
    2808:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    280c:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    2810:	5f626d75 	svcpl	0x00626d75
    2814:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    2818:	6169765f 	cmnvs	r9, pc, asr r6
    281c:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    2820:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    2824:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2828:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    282c:	00357670 	eorseq	r7, r5, r0, ror r6
    2830:	5f617369 	svcpl	0x00617369
    2834:	5f746962 	svcpl	0x00746962
    2838:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    283c:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    2840:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2844:	50435f54 	subpl	r5, r3, r4, asr pc
    2848:	6f635f55 	svcvs	0x00635f55
    284c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2850:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    2854:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2858:	50435f54 	subpl	r5, r3, r4, asr pc
    285c:	6f635f55 	svcvs	0x00635f55
    2860:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2864:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    2868:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    286c:	50435f54 	subpl	r5, r3, r4, asr pc
    2870:	6f635f55 	svcvs	0x00635f55
    2874:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2878:	41003961 	tstmi	r0, r1, ror #18
    287c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2880:	415f5343 	cmpmi	pc, r3, asr #6
    2884:	00534350 	subseq	r4, r3, r0, asr r3
    2888:	5f4d5241 	svcpl	0x004d5241
    288c:	5f534350 	svcpl	0x00534350
    2890:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    2894:	6f630053 	svcvs	0x00630053
    2898:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    289c:	6f642078 	svcvs	0x00642078
    28a0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    28a4:	52415400 	subpl	r5, r1, #0, 8
    28a8:	5f544547 	svcpl	0x00544547
    28ac:	5f555043 	svcpl	0x00555043
    28b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    28b4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    28b8:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    28bc:	61786574 	cmnvs	r8, r4, ror r5
    28c0:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    28c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28c8:	50435f54 	subpl	r5, r3, r4, asr pc
    28cc:	6f635f55 	svcvs	0x00635f55
    28d0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    28d4:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    28d8:	61007375 	tstvs	r0, r5, ror r3
    28dc:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    28e0:	73690063 	cmnvc	r9, #99	; 0x63
    28e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    28e8:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    28ec:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    28f0:	6f645f00 	svcvs	0x00645f00
    28f4:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 248e <shift+0x248e>
    28f8:	745f6573 	ldrbvc	r6, [pc], #-1395	; 2900 <shift+0x2900>
    28fc:	5f656572 	svcpl	0x00656572
    2900:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2904:	4154005f 	cmpmi	r4, pc, asr r0
    2908:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    290c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2910:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2914:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    2918:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    291c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2920:	50435f54 	subpl	r5, r3, r4, asr pc
    2924:	6f635f55 	svcvs	0x00635f55
    2928:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    292c:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    2930:	5f657361 	svcpl	0x00657361
    2934:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2938:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    293c:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    2940:	6d726100 	ldfvse	f6, [r2, #-0]
    2944:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2948:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    294c:	41540063 	cmpmi	r4, r3, rrx
    2950:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2954:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2958:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    295c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2960:	616d7331 	cmnvs	sp, r1, lsr r3
    2964:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2968:	7069746c 	rsbvc	r7, r9, ip, ror #8
    296c:	6100796c 	tstvs	r0, ip, ror #18
    2970:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2974:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    2978:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    297c:	73690063 	cmnvc	r9, #99	; 0x63
    2980:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2984:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2988:	00323363 	eorseq	r3, r2, r3, ror #6
    298c:	5f4d5241 	svcpl	0x004d5241
    2990:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    2994:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2998:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    299c:	33767066 	cmncc	r6, #102	; 0x66
    29a0:	61736900 	cmnvs	r3, r0, lsl #18
    29a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    29a8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    29ac:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    29b0:	5f455341 	svcpl	0x00455341
    29b4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    29b8:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    29bc:	53414200 	movtpl	r4, #4608	; 0x1200
    29c0:	52415f45 	subpl	r5, r1, #276	; 0x114
    29c4:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    29c8:	414d5f4d 	cmpmi	sp, sp, asr #30
    29cc:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    29d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    29d4:	50435f54 	subpl	r5, r3, r4, asr pc
    29d8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    29dc:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    29e0:	4100696d 	tstmi	r0, sp, ror #18
    29e4:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    29e8:	4142004c 	cmpmi	r2, ip, asr #32
    29ec:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    29f0:	5f484352 	svcpl	0x00484352
    29f4:	61004d37 	tstvs	r0, r7, lsr sp
    29f8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2a00 <shift+0x2a00>
    29fc:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2a00:	616c5f74 	smcvs	50676	; 0xc5f4
    2a04:	006c6562 	rsbeq	r6, ip, r2, ror #10
    2a08:	5f6d7261 	svcpl	0x006d7261
    2a0c:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2a10:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2a14:	006e736e 	rsbeq	r7, lr, lr, ror #6
    2a18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a20:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a24:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a28:	00347278 	eorseq	r7, r4, r8, ror r2
    2a2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a34:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a38:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a3c:	00357278 	eorseq	r7, r5, r8, ror r2
    2a40:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a44:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a48:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a4c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a50:	00377278 	eorseq	r7, r7, r8, ror r2
    2a54:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a58:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a5c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a60:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a64:	00387278 	eorseq	r7, r8, r8, ror r2
    2a68:	5f617369 	svcpl	0x00617369
    2a6c:	5f746962 	svcpl	0x00746962
    2a70:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    2a74:	61736900 	cmnvs	r3, r0, lsl #18
    2a78:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a7c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2a80:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    2a84:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2a88:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2a8c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a90:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2a94:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2a98:	5f617369 	svcpl	0x00617369
    2a9c:	5f746962 	svcpl	0x00746962
    2aa0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2aa4:	73690034 	cmnvc	r9, #52	; 0x34
    2aa8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2aac:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2ab0:	0036766d 	eorseq	r7, r6, sp, ror #12
    2ab4:	5f617369 	svcpl	0x00617369
    2ab8:	5f746962 	svcpl	0x00746962
    2abc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2ac0:	73690037 	cmnvc	r9, #55	; 0x37
    2ac4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2ac8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2acc:	0038766d 	eorseq	r7, r8, sp, ror #12
    2ad0:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    2ad4:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    2ad8:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    2adc:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    2ae0:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    2ae4:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    2ae8:	00657079 	rsbeq	r7, r5, r9, ror r0
    2aec:	5f617369 	svcpl	0x00617369
    2af0:	5f746962 	svcpl	0x00746962
    2af4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2af8:	00657435 	rsbeq	r7, r5, r5, lsr r4
    2afc:	5f6d7261 	svcpl	0x006d7261
    2b00:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    2b04:	6d726100 	ldfvse	f6, [r2, #-0]
    2b08:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    2b0c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    2b10:	6f777265 	svcvs	0x00777265
    2b14:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    2b18:	5f636e75 	svcpl	0x00636e75
    2b1c:	00727470 	rsbseq	r7, r2, r0, ror r4
    2b20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b28:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2b2c:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2b30:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    2b34:	5f626174 	svcpl	0x00626174
    2b38:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    2b3c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2b40:	50435f54 	subpl	r5, r3, r4, asr pc
    2b44:	61665f55 	cmnvs	r6, r5, asr pc
    2b48:	00363235 	eorseq	r3, r6, r5, lsr r2
    2b4c:	5f6d7261 	svcpl	0x006d7261
    2b50:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2b54:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2b58:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2b5c:	76696477 			; <UNDEFINED> instruction: 0x76696477
    2b60:	61746800 	cmnvs	r4, r0, lsl #16
    2b64:	71655f62 	cmnvc	r5, r2, ror #30
    2b68:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2b6c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2b70:	6d726100 	ldfvse	f6, [r2, #-0]
    2b74:	6369705f 	cmnvs	r9, #95	; 0x5f
    2b78:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2b7c:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2b80:	41540072 	cmpmi	r4, r2, ror r0
    2b84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b8c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2b90:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2b94:	616d7330 	cmnvs	sp, r0, lsr r3
    2b98:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2b9c:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2ba0:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2ba4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ba8:	50435f54 	subpl	r5, r3, r4, asr pc
    2bac:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2bb0:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2bb4:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    2bb8:	73690070 	cmnvc	r9, #112	; 0x70
    2bbc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2bc0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2bc4:	5f6b7269 	svcpl	0x006b7269
    2bc8:	5f336d63 	svcpl	0x00336d63
    2bcc:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2bd0:	4d524100 	ldfmie	f4, [r2, #-0]
    2bd4:	0043435f 	subeq	r4, r3, pc, asr r3
    2bd8:	5f6d7261 	svcpl	0x006d7261
    2bdc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2be0:	00325f38 	eorseq	r5, r2, r8, lsr pc
    2be4:	5f6d7261 	svcpl	0x006d7261
    2be8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2bec:	00335f38 	eorseq	r5, r3, r8, lsr pc
    2bf0:	5f6d7261 	svcpl	0x006d7261
    2bf4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2bf8:	00345f38 	eorseq	r5, r4, r8, lsr pc
    2bfc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2c00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2c04:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2c08:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    2c0c:	52410036 	subpl	r0, r1, #54	; 0x36
    2c10:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    2c14:	6d726100 	ldfvse	f6, [r2, #-0]
    2c18:	3170665f 	cmncc	r0, pc, asr r6
    2c1c:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    2c20:	61007473 	tstvs	r0, r3, ror r4
    2c24:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    2c28:	5f657361 	svcpl	0x00657361
    2c2c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2c30:	52415400 	subpl	r5, r1, #0, 8
    2c34:	5f544547 	svcpl	0x00544547
    2c38:	5f555043 	svcpl	0x00555043
    2c3c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2c40:	31617865 	cmncc	r1, r5, ror #16
    2c44:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    2c48:	61786574 	cmnvs	r8, r4, ror r5
    2c4c:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2c50:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2c54:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    2c58:	4154006d 	cmpmi	r4, sp, rrx
    2c5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2c60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2c64:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2c68:	61786574 	cmnvs	r8, r4, ror r5
    2c6c:	61003237 	tstvs	r0, r7, lsr r2
    2c70:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2c74:	645f7363 	ldrbvs	r7, [pc], #-867	; 2c7c <shift+0x2c7c>
    2c78:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    2c7c:	4100746c 	tstmi	r0, ip, ror #8
    2c80:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2c84:	415f5343 	cmpmi	pc, r3, asr #6
    2c88:	53435041 	movtpl	r5, #12353	; 0x3041
    2c8c:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    2c90:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    2c94:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2c98:	50435f54 	subpl	r5, r3, r4, asr pc
    2c9c:	6f635f55 	svcvs	0x00635f55
    2ca0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2ca4:	00353761 	eorseq	r3, r5, r1, ror #14
    2ca8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2cac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2cb0:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2cb4:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2cb8:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2cbc:	6d726100 	ldfvse	f6, [r2, #-0]
    2cc0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2cc4:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2cc8:	31626d75 	smccc	9941	; 0x26d5
    2ccc:	6d726100 	ldfvse	f6, [r2, #-0]
    2cd0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2cd4:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2cd8:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2cdc:	52415400 	subpl	r5, r1, #0, 8
    2ce0:	5f544547 	svcpl	0x00544547
    2ce4:	5f555043 	svcpl	0x00555043
    2ce8:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2cec:	61007478 	tstvs	r0, r8, ror r4
    2cf0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2cf4:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    2cf8:	73690074 	cmnvc	r9, #116	; 0x74
    2cfc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2d00:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    2d04:	6d726100 	ldfvse	f6, [r2, #-0]
    2d08:	5f646c5f 	svcpl	0x00646c5f
    2d0c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    2d10:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2d14:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2d18:	5f386863 	svcpl	0x00386863
    2d1c:	Address 0x0000000000002d1c is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9694>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346594>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f96b4>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf89e4>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf96e4>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3465e4>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9704>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346604>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9724>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346624>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9744>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346644>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9764>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346664>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9784>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346684>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf97a4>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3466a4>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f97bc>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f97dc>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f980c>
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
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9838>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346738>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008364 	andeq	r8, r0, r4, ror #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9858>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346758>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008390 	muleq	r0, r0, r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9878>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346778>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000083ac 	andeq	r8, r0, ip, lsr #7
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9898>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346798>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083f0 	strdeq	r8, [r0], -r0
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf98b8>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x3467b8>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008440 	andeq	r8, r0, r0, asr #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf98d8>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x3467d8>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008490 	muleq	r0, r0, r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf98f8>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x3467f8>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000084bc 			; <UNDEFINED> instruction: 0x000084bc
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9918>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346818>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	0000850c 	andeq	r8, r0, ip, lsl #10
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9938>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346838>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008550 	andeq	r8, r0, r0, asr r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9958>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346858>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000085a0 	andeq	r8, r0, r0, lsr #11
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9978>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346878>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085f4 	strdeq	r8, [r0], -r4
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf9998>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346898>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008630 	andeq	r8, r0, r0, lsr r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf99b8>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3468b8>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	0000866c 	andeq	r8, r0, ip, ror #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf99d8>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x3468d8>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000086a8 	andeq	r8, r0, r8, lsr #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf99f8>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x3468f8>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086e4 	andeq	r8, r0, r4, ror #13
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1f9a18>
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
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1f9a48>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008908 	andeq	r8, r0, r8, lsl #18
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xf9a68>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x346968>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000089a4 	andeq	r8, r0, r4, lsr #19
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xf9a88>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x346988>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a64 	andeq	r8, r0, r4, ror #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xf9aa8>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x3469a8>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b10 	andeq	r8, r0, r0, lsl fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xf9ac8>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x3469c8>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b64 	andeq	r8, r0, r4, ror #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xf9ae8>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x3469e8>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008bcc 	andeq	r8, r0, ip, asr #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xf9b08>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x346a08>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008c4c 	andeq	r8, r0, ip, asr #24
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xf9b28>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x346a28>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1f9b48>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008d7c 	andeq	r8, r0, ip, ror sp
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xf9b68>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x346a68>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	000091bc 			; <UNDEFINED> instruction: 0x000091bc
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1f9b8c>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009290 	muleq	r0, r0, r2
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xf9bac>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x346aac>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	000092cc 	andeq	r9, r0, ip, asr #5
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xf9bcc>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x346acc>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	0000930c 	andeq	r9, r0, ip, lsl #6
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1f9bec>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	0000933c 	andeq	r9, r0, ip, lsr r3
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1f9c0c>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	00009660 	andeq	r9, r0, r0, ror #12
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xf9c30>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x346b30>
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
 5ec:	8b080e42 	blhi	203efc <__bss_end+0x1f9c60>
 5f0:	42018e02 	andmi	r8, r1, #2, 28
 5f4:	6e040b0c 	vmlavs.f64	d0, d4, d12
 5f8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5fc:	0000001c 	andeq	r0, r0, ip, lsl r0
 600:	000005cc 	andeq	r0, r0, ip, asr #11
 604:	000097d8 	ldrdeq	r9, [r0], -r8
 608:	0000004c 	andeq	r0, r0, ip, asr #32
 60c:	8b080e42 	blhi	203f1c <__bss_end+0x1f9c80>
 610:	42018e02 	andmi	r8, r1, #2, 28
 614:	60040b0c 	andvs	r0, r4, ip, lsl #22
 618:	00080d0c 	andeq	r0, r8, ip, lsl #26
 61c:	0000001c 	andeq	r0, r0, ip, lsl r0
 620:	000005cc 	andeq	r0, r0, ip, asr #11
 624:	00009824 	andeq	r9, r0, r4, lsr #16
 628:	00000028 	andeq	r0, r0, r8, lsr #32
 62c:	8b040e42 	blhi	103f3c <__bss_end+0xf9ca0>
 630:	0b0d4201 	bleq	350e3c <__bss_end+0x346ba0>
 634:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 638:	00000ecb 	andeq	r0, r0, fp, asr #29
 63c:	0000001c 	andeq	r0, r0, ip, lsl r0
 640:	000005cc 	andeq	r0, r0, ip, asr #11
 644:	0000984c 	andeq	r9, r0, ip, asr #16
 648:	0000007c 	andeq	r0, r0, ip, ror r0
 64c:	8b080e42 	blhi	203f5c <__bss_end+0x1f9cc0>
 650:	42018e02 	andmi	r8, r1, #2, 28
 654:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 658:	00080d0c 	andeq	r0, r8, ip, lsl #26
 65c:	0000001c 	andeq	r0, r0, ip, lsl r0
 660:	000005cc 	andeq	r0, r0, ip, asr #11
 664:	000098c8 	andeq	r9, r0, r8, asr #17
 668:	000000ec 	andeq	r0, r0, ip, ror #1
 66c:	8b080e42 	blhi	203f7c <__bss_end+0x1f9ce0>
 670:	42018e02 	andmi	r8, r1, #2, 28
 674:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 678:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 67c:	0000001c 	andeq	r0, r0, ip, lsl r0
 680:	000005cc 	andeq	r0, r0, ip, asr #11
 684:	000099b4 			; <UNDEFINED> instruction: 0x000099b4
 688:	00000168 	andeq	r0, r0, r8, ror #2
 68c:	8b080e42 	blhi	203f9c <__bss_end+0x1f9d00>
 690:	42018e02 	andmi	r8, r1, #2, 28
 694:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 698:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 69c:	0000001c 	andeq	r0, r0, ip, lsl r0
 6a0:	000005cc 	andeq	r0, r0, ip, asr #11
 6a4:	00009b1c 	andeq	r9, r0, ip, lsl fp
 6a8:	00000058 	andeq	r0, r0, r8, asr r0
 6ac:	8b080e42 	blhi	203fbc <__bss_end+0x1f9d20>
 6b0:	42018e02 	andmi	r8, r1, #2, 28
 6b4:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 6b8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 6bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 6c0:	000005cc 	andeq	r0, r0, ip, asr #11
 6c4:	00009b74 	andeq	r9, r0, r4, ror fp
 6c8:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 6cc:	8b080e42 	blhi	203fdc <__bss_end+0x1f9d40>
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
