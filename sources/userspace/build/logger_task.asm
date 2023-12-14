
./logger_task:     file format elf32-littlearm


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
    805c:	00009ef0 	strdeq	r9, [r0], -r0
    8060:	00009f00 	andeq	r9, r0, r0, lsl #30

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
    8080:	eb000097 	bl	82e4 <main>
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
    81cc:	00009eed 	andeq	r9, r0, sp, ror #29
    81d0:	00009eed 	andeq	r9, r0, sp, ror #29

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
    8224:	00009eed 	andeq	r9, r0, sp, ror #29
    8228:	00009eed 	andeq	r9, r0, sp, ror #29

0000822c <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:16
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

static void fputs(uint32_t file, const char* string)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:17
	write(file, string, strlen(string));
    8240:	e51b000c 	ldr	r0, [fp, #-12]
    8244:	eb000329 	bl	8ef0 <_Z6strlenPKc>
    8248:	e1a03000 	mov	r3, r0
    824c:	e1a02003 	mov	r2, r3
    8250:	e51b100c 	ldr	r1, [fp, #-12]
    8254:	e51b0008 	ldr	r0, [fp, #-8]
    8258:	eb000128 	bl	8700 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:18
}
    825c:	e320f000 	nop	{0}
    8260:	e24bd004 	sub	sp, fp, #4
    8264:	e8bd8800 	pop	{fp, pc}

00008268 <_ZL5fgetsjPcj>:
_ZL5fgetsjPcj():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:21

static uint32_t fgets(uint32_t file, char* buffer, uint32_t size)
{
    8268:	e92d4800 	push	{fp, lr}
    826c:	e28db004 	add	fp, sp, #4
    8270:	e24dd010 	sub	sp, sp, #16
    8274:	e50b0008 	str	r0, [fp, #-8]
    8278:	e50b100c 	str	r1, [fp, #-12]
    827c:	e50b2010 	str	r2, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:22
	return read(file, buffer, size);
    8280:	e51b2010 	ldr	r2, [fp, #-16]
    8284:	e51b100c 	ldr	r1, [fp, #-12]
    8288:	e51b0008 	ldr	r0, [fp, #-8]
    828c:	eb000107 	bl	86b0 <_Z4readjPcj>
    8290:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:23
}
    8294:	e1a00003 	mov	r0, r3
    8298:	e24bd004 	sub	sp, fp, #4
    829c:	e8bd8800 	pop	{fp, pc}

000082a0 <_ZL9init_uartj>:
_ZL9init_uartj():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:26

static void init_uart(uint32_t uart_fd)
{
    82a0:	e92d4800 	push	{fp, lr}
    82a4:	e28db004 	add	fp, sp, #4
    82a8:	e24dd010 	sub	sp, sp, #16
    82ac:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:28
	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    82b0:	e59f3028 	ldr	r3, [pc, #40]	; 82e0 <_ZL9init_uartj+0x40>
    82b4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:29
	params.char_length = NUART_Char_Length::Char_8;
    82b8:	e3a03001 	mov	r3, #1
    82bc:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:30
	ioctl(uart_fd, NIOCtl_Operation::Set_Params, &params);
    82c0:	e24b300c 	sub	r3, fp, #12
    82c4:	e1a02003 	mov	r2, r3
    82c8:	e3a01001 	mov	r1, #1
    82cc:	e51b0010 	ldr	r0, [fp, #-16]
    82d0:	eb000129 	bl	877c <_Z5ioctlj16NIOCtl_OperationPv>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:31
}
    82d4:	e320f000 	nop	{0}
    82d8:	e24bd004 	sub	sp, fp, #4
    82dc:	e8bd8800 	pop	{fp, pc}
    82e0:	0001c200 	andeq	ip, r1, r0, lsl #4

000082e4 <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:34

int main(int argc, char** argv)
{
    82e4:	e92d4800 	push	{fp, lr}
    82e8:	e28db004 	add	fp, sp, #4
    82ec:	e24ddd11 	sub	sp, sp, #1088	; 0x440
    82f0:	e50b0440 	str	r0, [fp, #-1088]	; 0xfffffbc0
    82f4:	e50b1444 	str	r1, [fp, #-1092]	; 0xfffffbbc
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:35
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    82f8:	e3a01002 	mov	r1, #2
    82fc:	e59f02b8 	ldr	r0, [pc, #696]	; 85bc <main+0x2d8>
    8300:	eb0000d9 	bl	866c <_Z4openPKc15NFile_Open_Mode>
    8304:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:36
	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8308:	e3a01000 	mov	r1, #0
    830c:	e59f02ac 	ldr	r0, [pc, #684]	; 85c0 <main+0x2dc>
    8310:	eb0000d5 	bl	866c <_Z4openPKc15NFile_Open_Mode>
    8314:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:38

	init_uart(uart_file);
    8318:	e51b000c 	ldr	r0, [fp, #-12]
    831c:	ebffffdf 	bl	82a0 <_ZL9init_uartj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:39
	fputs(uart_file, "UART task starting!\r\n");
    8320:	e59f129c 	ldr	r1, [pc, #668]	; 85c4 <main+0x2e0>
    8324:	e51b000c 	ldr	r0, [fp, #-12]
    8328:	ebffffbf 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:43

	char receive_buffer[1000];
	char string_buffer[16];
	bzero(receive_buffer, 1000);
    832c:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    8330:	e2433004 	sub	r3, r3, #4
    8334:	e2433004 	sub	r3, r3, #4
    8338:	e3a01ffa 	mov	r1, #1000	; 0x3e8
    833c:	e1a00003 	mov	r0, r3
    8340:	eb0002ff 	bl	8f44 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:44
	bzero(string_buffer, 16);
    8344:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8348:	e2433004 	sub	r3, r3, #4
    834c:	e2433004 	sub	r3, r3, #4
    8350:	e3a01010 	mov	r1, #16
    8354:	e1a00003 	mov	r0, r3
    8358:	eb0002f9 	bl	8f44 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:46

	float cislo = 123.456f;
    835c:	e59f3264 	ldr	r3, [pc, #612]	; 85c8 <main+0x2e4>
    8360:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:48
	char cislo_str[32];
	bzero(cislo_str, 32);
    8364:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    8368:	e2433004 	sub	r3, r3, #4
    836c:	e2433004 	sub	r3, r3, #4
    8370:	e3a01020 	mov	r1, #32
    8374:	e1a00003 	mov	r0, r3
    8378:	eb0002f1 	bl	8f44 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:49
	ftoa(cislo, cislo_str);
    837c:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    8380:	e2433004 	sub	r3, r3, #4
    8384:	e2433004 	sub	r3, r3, #4
    8388:	e1a00003 	mov	r0, r3
    838c:	ed1b0a05 	vldr	s0, [fp, #-20]	; 0xffffffec
    8390:	eb0004d5 	bl	96ec <_Z4ftoafPc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:50
	fputs(uart_file, "\r\nSENDING FLOAT!\r\n");
    8394:	e59f1230 	ldr	r1, [pc, #560]	; 85cc <main+0x2e8>
    8398:	e51b000c 	ldr	r0, [fp, #-12]
    839c:	ebffffa2 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:51
	fputs(uart_file, cislo_str);
    83a0:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    83a4:	e2433004 	sub	r3, r3, #4
    83a8:	e2433004 	sub	r3, r3, #4
    83ac:	e1a01003 	mov	r1, r3
    83b0:	e51b000c 	ldr	r0, [fp, #-12]
    83b4:	ebffff9c 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:52
	fputs(uart_file, "\r\nSENT FLOAT!\r\n");
    83b8:	e59f1210 	ldr	r1, [pc, #528]	; 85d0 <main+0x2ec>
    83bc:	e51b000c 	ldr	r0, [fp, #-12]
    83c0:	ebffff99 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:62
	// fputs(uart_file, string_buffer);
	// fputs(uart_file, "\r\n");

	while(true) 
	{
		uint32_t v = fgets(uart_file, receive_buffer, 1000);
    83c4:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    83c8:	e2433004 	sub	r3, r3, #4
    83cc:	e2433004 	sub	r3, r3, #4
    83d0:	e3a02ffa 	mov	r2, #1000	; 0x3e8
    83d4:	e1a01003 	mov	r1, r3
    83d8:	e51b000c 	ldr	r0, [fp, #-12]
    83dc:	ebffffa1 	bl	8268 <_ZL5fgetsjPcj>
    83e0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:64

		if (v > 0)
    83e4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83e8:	e3530000 	cmp	r3, #0
    83ec:	0a00004e 	beq	852c <main+0x248>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:66
		{
			receive_buffer[999] = '\0';
    83f0:	e3a03000 	mov	r3, #0
    83f4:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:67
			if (v < 1000) receive_buffer[v] = '\0';
    83f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83fc:	e3530ffa 	cmp	r3, #1000	; 0x3e8
    8400:	2a000006 	bcs	8420 <main+0x13c>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:67 (discriminator 1)
    8404:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    8408:	e2433004 	sub	r3, r3, #4
    840c:	e2433004 	sub	r3, r3, #4
    8410:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8414:	e0833002 	add	r3, r3, r2
    8418:	e3a02000 	mov	r2, #0
    841c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:69

			itoa(v, string_buffer, 10);
    8420:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8424:	e2433004 	sub	r3, r3, #4
    8428:	e2433004 	sub	r3, r3, #4
    842c:	e3a0200a 	mov	r2, #10
    8430:	e1a01003 	mov	r1, r3
    8434:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8438:	eb0001cd 	bl	8b74 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:70
			fputs(uart_file, "RECEIVED DATA!\r\n");
    843c:	e59f1190 	ldr	r1, [pc, #400]	; 85d4 <main+0x2f0>
    8440:	e51b000c 	ldr	r0, [fp, #-12]
    8444:	ebffff78 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:71
			fputs(uart_file, "[");
    8448:	e59f1188 	ldr	r1, [pc, #392]	; 85d8 <main+0x2f4>
    844c:	e51b000c 	ldr	r0, [fp, #-12]
    8450:	ebffff75 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:72
			fputs(uart_file, string_buffer);
    8454:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8458:	e2433004 	sub	r3, r3, #4
    845c:	e2433004 	sub	r3, r3, #4
    8460:	e1a01003 	mov	r1, r3
    8464:	e51b000c 	ldr	r0, [fp, #-12]
    8468:	ebffff6f 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:73
			fputs(uart_file, "]: ");
    846c:	e59f1168 	ldr	r1, [pc, #360]	; 85dc <main+0x2f8>
    8470:	e51b000c 	ldr	r0, [fp, #-12]
    8474:	ebffff6c 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:74
			fputs(uart_file, receive_buffer);
    8478:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    847c:	e2433004 	sub	r3, r3, #4
    8480:	e2433004 	sub	r3, r3, #4
    8484:	e1a01003 	mov	r1, r3
    8488:	e51b000c 	ldr	r0, [fp, #-12]
    848c:	ebffff66 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:75
			fputs(uart_file, "\r\n");
    8490:	e59f1148 	ldr	r1, [pc, #328]	; 85e0 <main+0x2fc>
    8494:	e51b000c 	ldr	r0, [fp, #-12]
    8498:	ebffff63 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:77

			for (uint32_t i = 0; i < v; i++)
    849c:	e3a03000 	mov	r3, #0
    84a0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:77 (discriminator 3)
    84a4:	e51b2008 	ldr	r2, [fp, #-8]
    84a8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84ac:	e1520003 	cmp	r2, r3
    84b0:	2affffc3 	bcs	83c4 <main+0xe0>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:79 (discriminator 2)
			{
				int char_val_int = receive_buffer[i];
    84b4:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    84b8:	e2433004 	sub	r3, r3, #4
    84bc:	e2433004 	sub	r3, r3, #4
    84c0:	e51b2008 	ldr	r2, [fp, #-8]
    84c4:	e0833002 	add	r3, r3, r2
    84c8:	e5d33000 	ldrb	r3, [r3]
    84cc:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:80 (discriminator 2)
				itoa(char_val_int, string_buffer, 16);
    84d0:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    84d4:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    84d8:	e2433004 	sub	r3, r3, #4
    84dc:	e2433004 	sub	r3, r3, #4
    84e0:	e3a02010 	mov	r2, #16
    84e4:	e1a01003 	mov	r1, r3
    84e8:	eb0001a1 	bl	8b74 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:81 (discriminator 2)
				fputs(uart_file, "CHAR[0x");
    84ec:	e59f10f0 	ldr	r1, [pc, #240]	; 85e4 <main+0x300>
    84f0:	e51b000c 	ldr	r0, [fp, #-12]
    84f4:	ebffff4c 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:82 (discriminator 2)
				fputs(uart_file, string_buffer);
    84f8:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    84fc:	e2433004 	sub	r3, r3, #4
    8500:	e2433004 	sub	r3, r3, #4
    8504:	e1a01003 	mov	r1, r3
    8508:	e51b000c 	ldr	r0, [fp, #-12]
    850c:	ebffff46 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:83 (discriminator 2)
				fputs(uart_file, "]\r\n");
    8510:	e59f10d0 	ldr	r1, [pc, #208]	; 85e8 <main+0x304>
    8514:	e51b000c 	ldr	r0, [fp, #-12]
    8518:	ebffff43 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:77 (discriminator 2)
			for (uint32_t i = 0; i < v; i++)
    851c:	e51b3008 	ldr	r3, [fp, #-8]
    8520:	e2833001 	add	r3, r3, #1
    8524:	e50b3008 	str	r3, [fp, #-8]
    8528:	eaffffdd 	b	84a4 <main+0x1c0>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:88
			}
		} 
		else 
		{
			float rng_num = get_random_float(trng_file, 0.0f, 100.0f);
    852c:	eddf0a20 	vldr	s1, [pc, #128]	; 85b4 <main+0x2d0>
    8530:	ed9f0a20 	vldr	s0, [pc, #128]	; 85b8 <main+0x2d4>
    8534:	e51b0010 	ldr	r0, [fp, #-16]
    8538:	eb000170 	bl	8b00 <_Z16get_random_floatjff>
    853c:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:89
			ftoa(rng_num, string_buffer);
    8540:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8544:	e2433004 	sub	r3, r3, #4
    8548:	e2433004 	sub	r3, r3, #4
    854c:	e1a00003 	mov	r0, r3
    8550:	ed1b0a07 	vldr	s0, [fp, #-28]	; 0xffffffe4
    8554:	eb000464 	bl	96ec <_Z4ftoafPc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:90
			fputs(uart_file, "GOT RANDOM NUMBER: ");
    8558:	e59f108c 	ldr	r1, [pc, #140]	; 85ec <main+0x308>
    855c:	e51b000c 	ldr	r0, [fp, #-12]
    8560:	ebffff31 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:91
			fputs(uart_file, string_buffer);
    8564:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8568:	e2433004 	sub	r3, r3, #4
    856c:	e2433004 	sub	r3, r3, #4
    8570:	e1a01003 	mov	r1, r3
    8574:	e51b000c 	ldr	r0, [fp, #-12]
    8578:	ebffff2b 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:92
			fputs(uart_file, "\r\n");
    857c:	e59f105c 	ldr	r1, [pc, #92]	; 85e0 <main+0x2fc>
    8580:	e51b000c 	ldr	r0, [fp, #-12]
    8584:	ebffff28 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:94

			fputs(uart_file, "WAIT CALLED!\r\n");
    8588:	e59f1060 	ldr	r1, [pc, #96]	; 85f0 <main+0x30c>
    858c:	e51b000c 	ldr	r0, [fp, #-12]
    8590:	ebffff25 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:95
			wait(uart_file);
    8594:	e3e02001 	mvn	r2, #1
    8598:	e3a01001 	mov	r1, #1
    859c:	e51b000c 	ldr	r0, [fp, #-12]
    85a0:	eb00009a 	bl	8810 <_Z4waitjjj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:96
			fputs(uart_file, "WOKE UP!\r\n");
    85a4:	e59f1048 	ldr	r1, [pc, #72]	; 85f4 <main+0x310>
    85a8:	e51b000c 	ldr	r0, [fp, #-12]
    85ac:	ebffff1e 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:98
		}
	}
    85b0:	eaffff83 	b	83c4 <main+0xe0>
    85b4:	42c80000 	sbcmi	r0, r8, #0
    85b8:	00000000 	andeq	r0, r0, r0
    85bc:	00009da0 	andeq	r9, r0, r0, lsr #27
    85c0:	00009dac 	andeq	r9, r0, ip, lsr #27
    85c4:	00009db8 			; <UNDEFINED> instruction: 0x00009db8
    85c8:	42f6e979 	rscsmi	lr, r6, #1982464	; 0x1e4000
    85cc:	00009dd0 	ldrdeq	r9, [r0], -r0
    85d0:	00009de4 	andeq	r9, r0, r4, ror #27
    85d4:	00009df4 	strdeq	r9, [r0], -r4
    85d8:	00009e08 	andeq	r9, r0, r8, lsl #28
    85dc:	00009e0c 	andeq	r9, r0, ip, lsl #28
    85e0:	00009e10 	andeq	r9, r0, r0, lsl lr
    85e4:	00009e14 	andeq	r9, r0, r4, lsl lr
    85e8:	00009e1c 	andeq	r9, r0, ip, lsl lr
    85ec:	00009e20 	andeq	r9, r0, r0, lsr #28
    85f0:	00009e34 	andeq	r9, r0, r4, lsr lr
    85f4:	00009e44 	andeq	r9, r0, r4, asr #28

000085f8 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    85f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85fc:	e28db000 	add	fp, sp, #0
    8600:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8604:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8608:	e1a03000 	mov	r3, r0
    860c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8610:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8614:	e1a00003 	mov	r0, r3
    8618:	e28bd000 	add	sp, fp, #0
    861c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8620:	e12fff1e 	bx	lr

00008624 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8624:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8628:	e28db000 	add	fp, sp, #0
    862c:	e24dd00c 	sub	sp, sp, #12
    8630:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8634:	e51b3008 	ldr	r3, [fp, #-8]
    8638:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    863c:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    8640:	e320f000 	nop	{0}
    8644:	e28bd000 	add	sp, fp, #0
    8648:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    864c:	e12fff1e 	bx	lr

00008650 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8650:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8654:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8658:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    865c:	e320f000 	nop	{0}
    8660:	e28bd000 	add	sp, fp, #0
    8664:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8668:	e12fff1e 	bx	lr

0000866c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    866c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8670:	e28db000 	add	fp, sp, #0
    8674:	e24dd014 	sub	sp, sp, #20
    8678:	e50b0010 	str	r0, [fp, #-16]
    867c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8680:	e51b3010 	ldr	r3, [fp, #-16]
    8684:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8688:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    868c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8690:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8694:	e1a03000 	mov	r3, r0
    8698:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    869c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    86a0:	e1a00003 	mov	r0, r3
    86a4:	e28bd000 	add	sp, fp, #0
    86a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86ac:	e12fff1e 	bx	lr

000086b0 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    86b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b4:	e28db000 	add	fp, sp, #0
    86b8:	e24dd01c 	sub	sp, sp, #28
    86bc:	e50b0010 	str	r0, [fp, #-16]
    86c0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    86c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    86c8:	e51b3010 	ldr	r3, [fp, #-16]
    86cc:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    86d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86d4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    86d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86dc:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    86e0:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    86e4:	e1a03000 	mov	r3, r0
    86e8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    86ec:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    86f0:	e1a00003 	mov	r0, r3
    86f4:	e28bd000 	add	sp, fp, #0
    86f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86fc:	e12fff1e 	bx	lr

00008700 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8700:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8704:	e28db000 	add	fp, sp, #0
    8708:	e24dd01c 	sub	sp, sp, #28
    870c:	e50b0010 	str	r0, [fp, #-16]
    8710:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8714:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8718:	e51b3010 	ldr	r3, [fp, #-16]
    871c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8720:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8724:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8728:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    872c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8730:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8734:	e1a03000 	mov	r3, r0
    8738:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    873c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    8740:	e1a00003 	mov	r0, r3
    8744:	e28bd000 	add	sp, fp, #0
    8748:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    874c:	e12fff1e 	bx	lr

00008750 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8750:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8754:	e28db000 	add	fp, sp, #0
    8758:	e24dd00c 	sub	sp, sp, #12
    875c:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8760:	e51b3008 	ldr	r3, [fp, #-8]
    8764:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8768:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    876c:	e320f000 	nop	{0}
    8770:	e28bd000 	add	sp, fp, #0
    8774:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8778:	e12fff1e 	bx	lr

0000877c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    877c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8780:	e28db000 	add	fp, sp, #0
    8784:	e24dd01c 	sub	sp, sp, #28
    8788:	e50b0010 	str	r0, [fp, #-16]
    878c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8790:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8794:	e51b3010 	ldr	r3, [fp, #-16]
    8798:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    879c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87a0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    87a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87a8:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    87ac:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    87b0:	e1a03000 	mov	r3, r0
    87b4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    87b8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    87bc:	e1a00003 	mov	r0, r3
    87c0:	e28bd000 	add	sp, fp, #0
    87c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87c8:	e12fff1e 	bx	lr

000087cc <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    87cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    87d0:	e28db000 	add	fp, sp, #0
    87d4:	e24dd014 	sub	sp, sp, #20
    87d8:	e50b0010 	str	r0, [fp, #-16]
    87dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    87e0:	e51b3010 	ldr	r3, [fp, #-16]
    87e4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    87e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87ec:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    87f0:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    87f4:	e1a03000 	mov	r3, r0
    87f8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    87fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    8800:	e1a00003 	mov	r0, r3
    8804:	e28bd000 	add	sp, fp, #0
    8808:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    880c:	e12fff1e 	bx	lr

00008810 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8810:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8814:	e28db000 	add	fp, sp, #0
    8818:	e24dd01c 	sub	sp, sp, #28
    881c:	e50b0010 	str	r0, [fp, #-16]
    8820:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8824:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8828:	e51b3010 	ldr	r3, [fp, #-16]
    882c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8830:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8834:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8838:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    883c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8840:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8844:	e1a03000 	mov	r3, r0
    8848:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    884c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    8850:	e1a00003 	mov	r0, r3
    8854:	e28bd000 	add	sp, fp, #0
    8858:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    885c:	e12fff1e 	bx	lr

00008860 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8860:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8864:	e28db000 	add	fp, sp, #0
    8868:	e24dd014 	sub	sp, sp, #20
    886c:	e50b0010 	str	r0, [fp, #-16]
    8870:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8874:	e51b3010 	ldr	r3, [fp, #-16]
    8878:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    887c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8880:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8884:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8888:	e1a03000 	mov	r3, r0
    888c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8890:	e51b3008 	ldr	r3, [fp, #-8]
    8894:	e3530000 	cmp	r3, #0
    8898:	13a03001 	movne	r3, #1
    889c:	03a03000 	moveq	r3, #0
    88a0:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    88a4:	e1a00003 	mov	r0, r3
    88a8:	e28bd000 	add	sp, fp, #0
    88ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88b0:	e12fff1e 	bx	lr

000088b4 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    88b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88b8:	e28db000 	add	fp, sp, #0
    88bc:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    88c0:	e3a03000 	mov	r3, #0
    88c4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    88c8:	e3a03000 	mov	r3, #0
    88cc:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    88d0:	e24b300c 	sub	r3, fp, #12
    88d4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    88d8:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    88dc:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    88e0:	e1a00003 	mov	r0, r3
    88e4:	e28bd000 	add	sp, fp, #0
    88e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88ec:	e12fff1e 	bx	lr

000088f0 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    88f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88f4:	e28db000 	add	fp, sp, #0
    88f8:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    88fc:	e3a03001 	mov	r3, #1
    8900:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8904:	e3a03001 	mov	r3, #1
    8908:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    890c:	e24b300c 	sub	r3, fp, #12
    8910:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8914:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8918:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    891c:	e1a00003 	mov	r0, r3
    8920:	e28bd000 	add	sp, fp, #0
    8924:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8928:	e12fff1e 	bx	lr

0000892c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    892c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8930:	e28db000 	add	fp, sp, #0
    8934:	e24dd014 	sub	sp, sp, #20
    8938:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    893c:	e3a03000 	mov	r3, #0
    8940:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8944:	e3a03000 	mov	r3, #0
    8948:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    894c:	e24b3010 	sub	r3, fp, #16
    8950:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8954:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    8958:	e320f000 	nop	{0}
    895c:	e28bd000 	add	sp, fp, #0
    8960:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8964:	e12fff1e 	bx	lr

00008968 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8968:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    896c:	e28db000 	add	fp, sp, #0
    8970:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8974:	e3a03001 	mov	r3, #1
    8978:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    897c:	e3a03001 	mov	r3, #1
    8980:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8984:	e24b300c 	sub	r3, fp, #12
    8988:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    898c:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8990:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    8994:	e1a00003 	mov	r0, r3
    8998:	e28bd000 	add	sp, fp, #0
    899c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89a0:	e12fff1e 	bx	lr

000089a4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    89a4:	e92d4800 	push	{fp, lr}
    89a8:	e28db004 	add	fp, sp, #4
    89ac:	e24dd050 	sub	sp, sp, #80	; 0x50
    89b0:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    89b4:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    89b8:	e24b3048 	sub	r3, fp, #72	; 0x48
    89bc:	e3a0200a 	mov	r2, #10
    89c0:	e59f1088 	ldr	r1, [pc, #136]	; 8a50 <_Z4pipePKcj+0xac>
    89c4:	e1a00003 	mov	r0, r3
    89c8:	eb0000ed 	bl	8d84 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    89cc:	e24b3048 	sub	r3, fp, #72	; 0x48
    89d0:	e283300a 	add	r3, r3, #10
    89d4:	e3a02035 	mov	r2, #53	; 0x35
    89d8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    89dc:	e1a00003 	mov	r0, r3
    89e0:	eb0000e7 	bl	8d84 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    89e4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    89e8:	eb000140 	bl	8ef0 <_Z6strlenPKc>
    89ec:	e1a03000 	mov	r3, r0
    89f0:	e283300a 	add	r3, r3, #10
    89f4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e2832001 	add	r2, r3, #1
    8a00:	e50b2008 	str	r2, [fp, #-8]
    8a04:	e24b2004 	sub	r2, fp, #4
    8a08:	e0823003 	add	r3, r2, r3
    8a0c:	e3a02023 	mov	r2, #35	; 0x23
    8a10:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8a14:	e24b2048 	sub	r2, fp, #72	; 0x48
    8a18:	e51b3008 	ldr	r3, [fp, #-8]
    8a1c:	e0823003 	add	r3, r2, r3
    8a20:	e3a0200a 	mov	r2, #10
    8a24:	e1a01003 	mov	r1, r3
    8a28:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8a2c:	eb000050 	bl	8b74 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8a30:	e24b3048 	sub	r3, fp, #72	; 0x48
    8a34:	e3a01002 	mov	r1, #2
    8a38:	e1a00003 	mov	r0, r3
    8a3c:	ebffff0a 	bl	866c <_Z4openPKc15NFile_Open_Mode>
    8a40:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    8a44:	e1a00003 	mov	r0, r3
    8a48:	e24bd004 	sub	sp, fp, #4
    8a4c:	e8bd8800 	pop	{fp, pc}
    8a50:	00009e90 	muleq	r0, r0, lr

00008a54 <_Z17get_random_uint32j>:
_Z17get_random_uint32j():
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:4
#include <stdfile.h>

uint32_t get_random_uint32(uint32_t trng_file)
{	
    8a54:	e92d4800 	push	{fp, lr}
    8a58:	e28db004 	add	fp, sp, #4
    8a5c:	e24dd010 	sub	sp, sp, #16
    8a60:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:5
	uint32_t rng_num = 0;
    8a64:	e3a03000 	mov	r3, #0
    8a68:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:6
	read(trng_file, reinterpret_cast<char*>(&rng_num), sizeof(rng_num));
    8a6c:	e24b3008 	sub	r3, fp, #8
    8a70:	e3a02004 	mov	r2, #4
    8a74:	e1a01003 	mov	r1, r3
    8a78:	e51b0010 	ldr	r0, [fp, #-16]
    8a7c:	ebffff0b 	bl	86b0 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:7
	return rng_num;
    8a80:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:8
}
    8a84:	e1a00003 	mov	r0, r3
    8a88:	e24bd004 	sub	sp, fp, #4
    8a8c:	e8bd8800 	pop	{fp, pc}

00008a90 <_Z17get_random_uint32jjj>:
_Z17get_random_uint32jjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:12

// Returns a random number between min and max, (min inclusive, max exclusive)
uint32_t get_random_uint32(uint32_t trng_file, uint32_t min, uint32_t max)
{	
    8a90:	e92d4800 	push	{fp, lr}
    8a94:	e28db004 	add	fp, sp, #4
    8a98:	e24dd018 	sub	sp, sp, #24
    8a9c:	e50b0010 	str	r0, [fp, #-16]
    8aa0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8aa4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:13
	uint32_t rng_num = 0;
    8aa8:	e3a03000 	mov	r3, #0
    8aac:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:14
	read(trng_file, reinterpret_cast<char*>(&rng_num), sizeof(rng_num));
    8ab0:	e24b300c 	sub	r3, fp, #12
    8ab4:	e3a02004 	mov	r2, #4
    8ab8:	e1a01003 	mov	r1, r3
    8abc:	e51b0010 	ldr	r0, [fp, #-16]
    8ac0:	ebfffefa 	bl	86b0 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:15
	uint32_t random_in_range = min + (rng_num % (max - min));
    8ac4:	e51b000c 	ldr	r0, [fp, #-12]
    8ac8:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8acc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ad0:	e0423003 	sub	r3, r2, r3
    8ad4:	e1a01003 	mov	r1, r3
    8ad8:	eb000497 	bl	9d3c <__aeabi_uidivmod>
    8adc:	e1a03001 	mov	r3, r1
    8ae0:	e1a02003 	mov	r2, r3
    8ae4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ae8:	e0833002 	add	r3, r3, r2
    8aec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:16
	return random_in_range;
    8af0:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:17
}
    8af4:	e1a00003 	mov	r0, r3
    8af8:	e24bd004 	sub	sp, fp, #4
    8afc:	e8bd8800 	pop	{fp, pc}

00008b00 <_Z16get_random_floatjff>:
_Z16get_random_floatjff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:21

// Returns a random float between min and max, (min inclusive, max inclusive)
float get_random_float(uint32_t trng_file, float min, float max)
{
    8b00:	e92d4800 	push	{fp, lr}
    8b04:	e28db004 	add	fp, sp, #4
    8b08:	e24dd020 	sub	sp, sp, #32
    8b0c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b10:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
    8b14:	ed4b0a08 	vstr	s1, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:22
    uint32_t random_int = get_random_uint32(trng_file);
    8b18:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8b1c:	ebffffcc 	bl	8a54 <_Z17get_random_uint32j>
    8b20:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:25

    // Convert the random integer to a floating-point number between 0 and 1
    float random_normalized = (float)random_int / UINT32_MAX;
    8b24:	e51b3008 	ldr	r3, [fp, #-8]
    8b28:	ee073a90 	vmov	s15, r3
    8b2c:	eeb87a67 	vcvt.f32.u32	s14, s15
    8b30:	eddf6a0e 	vldr	s13, [pc, #56]	; 8b70 <_Z16get_random_floatjff+0x70>
    8b34:	eec77a26 	vdiv.f32	s15, s14, s13
    8b38:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:28

    // Scale the random number to the desired range
    float random_in_range = min + (max - min) * random_normalized;
    8b3c:	ed1b7a08 	vldr	s14, [fp, #-32]	; 0xffffffe0
    8b40:	ed5b7a07 	vldr	s15, [fp, #-28]	; 0xffffffe4
    8b44:	ee377a67 	vsub.f32	s14, s14, s15
    8b48:	ed5b7a03 	vldr	s15, [fp, #-12]
    8b4c:	ee677a27 	vmul.f32	s15, s14, s15
    8b50:	ed1b7a07 	vldr	s14, [fp, #-28]	; 0xffffffe4
    8b54:	ee777a27 	vadd.f32	s15, s14, s15
    8b58:	ed4b7a04 	vstr	s15, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:30

	return random_in_range;
    8b5c:	e51b3010 	ldr	r3, [fp, #-16]
    8b60:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdrandom.cpp:31
    8b64:	eeb00a67 	vmov.f32	s0, s15
    8b68:	e24bd004 	sub	sp, fp, #4
    8b6c:	e8bd8800 	pop	{fp, pc}
    8b70:	4f800000 	svcmi	0x00800000

00008b74 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8b74:	e92d4800 	push	{fp, lr}
    8b78:	e28db004 	add	fp, sp, #4
    8b7c:	e24dd020 	sub	sp, sp, #32
    8b80:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b84:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8b88:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8b8c:	e3a03000 	mov	r3, #0
    8b90:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8b94:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b98:	e3530000 	cmp	r3, #0
    8b9c:	0a000014 	beq	8bf4 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8ba0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ba4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8ba8:	e1a00003 	mov	r0, r3
    8bac:	eb000462 	bl	9d3c <__aeabi_uidivmod>
    8bb0:	e1a03001 	mov	r3, r1
    8bb4:	e1a01003 	mov	r1, r3
    8bb8:	e51b3008 	ldr	r3, [fp, #-8]
    8bbc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8bc0:	e0823003 	add	r3, r2, r3
    8bc4:	e59f2118 	ldr	r2, [pc, #280]	; 8ce4 <_Z4itoajPcj+0x170>
    8bc8:	e7d22001 	ldrb	r2, [r2, r1]
    8bcc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8bd0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8bd4:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8bd8:	eb0003dc 	bl	9b50 <__udivsi3>
    8bdc:	e1a03000 	mov	r3, r0
    8be0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
    8be8:	e2833001 	add	r3, r3, #1
    8bec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8bf0:	eaffffe7 	b	8b94 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8bf4:	e51b3008 	ldr	r3, [fp, #-8]
    8bf8:	e3530000 	cmp	r3, #0
    8bfc:	1a000007 	bne	8c20 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8c00:	e51b3008 	ldr	r3, [fp, #-8]
    8c04:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8c08:	e0823003 	add	r3, r2, r3
    8c0c:	e3a02030 	mov	r2, #48	; 0x30
    8c10:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8c14:	e51b3008 	ldr	r3, [fp, #-8]
    8c18:	e2833001 	add	r3, r3, #1
    8c1c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8c28:	e0823003 	add	r3, r2, r3
    8c2c:	e3a02000 	mov	r2, #0
    8c30:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8c34:	e51b3008 	ldr	r3, [fp, #-8]
    8c38:	e2433001 	sub	r3, r3, #1
    8c3c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8c40:	e3a03000 	mov	r3, #0
    8c44:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8c48:	e51b3008 	ldr	r3, [fp, #-8]
    8c4c:	e1a02fa3 	lsr	r2, r3, #31
    8c50:	e0823003 	add	r3, r2, r3
    8c54:	e1a030c3 	asr	r3, r3, #1
    8c58:	e1a02003 	mov	r2, r3
    8c5c:	e51b300c 	ldr	r3, [fp, #-12]
    8c60:	e1530002 	cmp	r3, r2
    8c64:	ca00001b 	bgt	8cd8 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8c68:	e51b2008 	ldr	r2, [fp, #-8]
    8c6c:	e51b300c 	ldr	r3, [fp, #-12]
    8c70:	e0423003 	sub	r3, r2, r3
    8c74:	e1a02003 	mov	r2, r3
    8c78:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c7c:	e0833002 	add	r3, r3, r2
    8c80:	e5d33000 	ldrb	r3, [r3]
    8c84:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8c88:	e51b300c 	ldr	r3, [fp, #-12]
    8c8c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8c90:	e0822003 	add	r2, r2, r3
    8c94:	e51b1008 	ldr	r1, [fp, #-8]
    8c98:	e51b300c 	ldr	r3, [fp, #-12]
    8c9c:	e0413003 	sub	r3, r1, r3
    8ca0:	e1a01003 	mov	r1, r3
    8ca4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ca8:	e0833001 	add	r3, r3, r1
    8cac:	e5d22000 	ldrb	r2, [r2]
    8cb0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8cb4:	e51b300c 	ldr	r3, [fp, #-12]
    8cb8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8cbc:	e0823003 	add	r3, r2, r3
    8cc0:	e55b200d 	ldrb	r2, [fp, #-13]
    8cc4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8cc8:	e51b300c 	ldr	r3, [fp, #-12]
    8ccc:	e2833001 	add	r3, r3, #1
    8cd0:	e50b300c 	str	r3, [fp, #-12]
    8cd4:	eaffffdb 	b	8c48 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8cd8:	e320f000 	nop	{0}
    8cdc:	e24bd004 	sub	sp, fp, #4
    8ce0:	e8bd8800 	pop	{fp, pc}
    8ce4:	00009edc 	ldrdeq	r9, [r0], -ip

00008ce8 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8ce8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cec:	e28db000 	add	fp, sp, #0
    8cf0:	e24dd014 	sub	sp, sp, #20
    8cf4:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8cf8:	e3a03000 	mov	r3, #0
    8cfc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8d00:	e51b3010 	ldr	r3, [fp, #-16]
    8d04:	e5d33000 	ldrb	r3, [r3]
    8d08:	e3530000 	cmp	r3, #0
    8d0c:	0a000017 	beq	8d70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8d10:	e51b2008 	ldr	r2, [fp, #-8]
    8d14:	e1a03002 	mov	r3, r2
    8d18:	e1a03103 	lsl	r3, r3, #2
    8d1c:	e0833002 	add	r3, r3, r2
    8d20:	e1a03083 	lsl	r3, r3, #1
    8d24:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8d28:	e51b3010 	ldr	r3, [fp, #-16]
    8d2c:	e5d33000 	ldrb	r3, [r3]
    8d30:	e3530039 	cmp	r3, #57	; 0x39
    8d34:	8a00000d 	bhi	8d70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8d38:	e51b3010 	ldr	r3, [fp, #-16]
    8d3c:	e5d33000 	ldrb	r3, [r3]
    8d40:	e353002f 	cmp	r3, #47	; 0x2f
    8d44:	9a000009 	bls	8d70 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8d48:	e51b3010 	ldr	r3, [fp, #-16]
    8d4c:	e5d33000 	ldrb	r3, [r3]
    8d50:	e2433030 	sub	r3, r3, #48	; 0x30
    8d54:	e51b2008 	ldr	r2, [fp, #-8]
    8d58:	e0823003 	add	r3, r2, r3
    8d5c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8d60:	e51b3010 	ldr	r3, [fp, #-16]
    8d64:	e2833001 	add	r3, r3, #1
    8d68:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8d6c:	eaffffe3 	b	8d00 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8d70:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8d74:	e1a00003 	mov	r0, r3
    8d78:	e28bd000 	add	sp, fp, #0
    8d7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d80:	e12fff1e 	bx	lr

00008d84 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8d84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d88:	e28db000 	add	fp, sp, #0
    8d8c:	e24dd01c 	sub	sp, sp, #28
    8d90:	e50b0010 	str	r0, [fp, #-16]
    8d94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8d98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8d9c:	e3a03000 	mov	r3, #0
    8da0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8da4:	e51b2008 	ldr	r2, [fp, #-8]
    8da8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8dac:	e1520003 	cmp	r2, r3
    8db0:	aa000011 	bge	8dfc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8db4:	e51b3008 	ldr	r3, [fp, #-8]
    8db8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8dbc:	e0823003 	add	r3, r2, r3
    8dc0:	e5d33000 	ldrb	r3, [r3]
    8dc4:	e3530000 	cmp	r3, #0
    8dc8:	0a00000b 	beq	8dfc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8dcc:	e51b3008 	ldr	r3, [fp, #-8]
    8dd0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8dd4:	e0822003 	add	r2, r2, r3
    8dd8:	e51b3008 	ldr	r3, [fp, #-8]
    8ddc:	e51b1010 	ldr	r1, [fp, #-16]
    8de0:	e0813003 	add	r3, r1, r3
    8de4:	e5d22000 	ldrb	r2, [r2]
    8de8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8dec:	e51b3008 	ldr	r3, [fp, #-8]
    8df0:	e2833001 	add	r3, r3, #1
    8df4:	e50b3008 	str	r3, [fp, #-8]
    8df8:	eaffffe9 	b	8da4 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8dfc:	e51b2008 	ldr	r2, [fp, #-8]
    8e00:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e04:	e1520003 	cmp	r2, r3
    8e08:	aa000008 	bge	8e30 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8e0c:	e51b3008 	ldr	r3, [fp, #-8]
    8e10:	e51b2010 	ldr	r2, [fp, #-16]
    8e14:	e0823003 	add	r3, r2, r3
    8e18:	e3a02000 	mov	r2, #0
    8e1c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8e20:	e51b3008 	ldr	r3, [fp, #-8]
    8e24:	e2833001 	add	r3, r3, #1
    8e28:	e50b3008 	str	r3, [fp, #-8]
    8e2c:	eafffff2 	b	8dfc <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8e30:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8e34:	e1a00003 	mov	r0, r3
    8e38:	e28bd000 	add	sp, fp, #0
    8e3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e40:	e12fff1e 	bx	lr

00008e44 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8e44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e48:	e28db000 	add	fp, sp, #0
    8e4c:	e24dd01c 	sub	sp, sp, #28
    8e50:	e50b0010 	str	r0, [fp, #-16]
    8e54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8e58:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8e5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e60:	e2432001 	sub	r2, r3, #1
    8e64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8e68:	e3530000 	cmp	r3, #0
    8e6c:	c3a03001 	movgt	r3, #1
    8e70:	d3a03000 	movle	r3, #0
    8e74:	e6ef3073 	uxtb	r3, r3
    8e78:	e3530000 	cmp	r3, #0
    8e7c:	0a000016 	beq	8edc <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8e80:	e51b3010 	ldr	r3, [fp, #-16]
    8e84:	e2832001 	add	r2, r3, #1
    8e88:	e50b2010 	str	r2, [fp, #-16]
    8e8c:	e5d33000 	ldrb	r3, [r3]
    8e90:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8e94:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e98:	e2832001 	add	r2, r3, #1
    8e9c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ea0:	e5d33000 	ldrb	r3, [r3]
    8ea4:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ea8:	e55b2005 	ldrb	r2, [fp, #-5]
    8eac:	e55b3006 	ldrb	r3, [fp, #-6]
    8eb0:	e1520003 	cmp	r2, r3
    8eb4:	0a000003 	beq	8ec8 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8eb8:	e55b2005 	ldrb	r2, [fp, #-5]
    8ebc:	e55b3006 	ldrb	r3, [fp, #-6]
    8ec0:	e0423003 	sub	r3, r2, r3
    8ec4:	ea000005 	b	8ee0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ec8:	e55b3005 	ldrb	r3, [fp, #-5]
    8ecc:	e3530000 	cmp	r3, #0
    8ed0:	1affffe1 	bne	8e5c <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8ed4:	e3a03000 	mov	r3, #0
    8ed8:	ea000000 	b	8ee0 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8edc:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8ee0:	e1a00003 	mov	r0, r3
    8ee4:	e28bd000 	add	sp, fp, #0
    8ee8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8eec:	e12fff1e 	bx	lr

00008ef0 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ef0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ef4:	e28db000 	add	fp, sp, #0
    8ef8:	e24dd014 	sub	sp, sp, #20
    8efc:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8f00:	e3a03000 	mov	r3, #0
    8f04:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8f08:	e51b3008 	ldr	r3, [fp, #-8]
    8f0c:	e51b2010 	ldr	r2, [fp, #-16]
    8f10:	e0823003 	add	r3, r2, r3
    8f14:	e5d33000 	ldrb	r3, [r3]
    8f18:	e3530000 	cmp	r3, #0
    8f1c:	0a000003 	beq	8f30 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8f20:	e51b3008 	ldr	r3, [fp, #-8]
    8f24:	e2833001 	add	r3, r3, #1
    8f28:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8f2c:	eafffff5 	b	8f08 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8f30:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8f34:	e1a00003 	mov	r0, r3
    8f38:	e28bd000 	add	sp, fp, #0
    8f3c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f40:	e12fff1e 	bx	lr

00008f44 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8f44:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f48:	e28db000 	add	fp, sp, #0
    8f4c:	e24dd014 	sub	sp, sp, #20
    8f50:	e50b0010 	str	r0, [fp, #-16]
    8f54:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8f58:	e51b3010 	ldr	r3, [fp, #-16]
    8f5c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8f60:	e3a03000 	mov	r3, #0
    8f64:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8f68:	e51b2008 	ldr	r2, [fp, #-8]
    8f6c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8f70:	e1520003 	cmp	r2, r3
    8f74:	aa000008 	bge	8f9c <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8f78:	e51b3008 	ldr	r3, [fp, #-8]
    8f7c:	e51b200c 	ldr	r2, [fp, #-12]
    8f80:	e0823003 	add	r3, r2, r3
    8f84:	e3a02000 	mov	r2, #0
    8f88:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8f8c:	e51b3008 	ldr	r3, [fp, #-8]
    8f90:	e2833001 	add	r3, r3, #1
    8f94:	e50b3008 	str	r3, [fp, #-8]
    8f98:	eafffff2 	b	8f68 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8f9c:	e320f000 	nop	{0}
    8fa0:	e28bd000 	add	sp, fp, #0
    8fa4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8fa8:	e12fff1e 	bx	lr

00008fac <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8fac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8fb0:	e28db000 	add	fp, sp, #0
    8fb4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8fb8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8fbc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8fc0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8fc4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fc8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8fcc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fd0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8fd4:	e3a03000 	mov	r3, #0
    8fd8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8fdc:	e51b2008 	ldr	r2, [fp, #-8]
    8fe0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fe4:	e1520003 	cmp	r2, r3
    8fe8:	aa00000b 	bge	901c <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8fec:	e51b3008 	ldr	r3, [fp, #-8]
    8ff0:	e51b200c 	ldr	r2, [fp, #-12]
    8ff4:	e0822003 	add	r2, r2, r3
    8ff8:	e51b3008 	ldr	r3, [fp, #-8]
    8ffc:	e51b1010 	ldr	r1, [fp, #-16]
    9000:	e0813003 	add	r3, r1, r3
    9004:	e5d22000 	ldrb	r2, [r2]
    9008:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    900c:	e51b3008 	ldr	r3, [fp, #-8]
    9010:	e2833001 	add	r3, r3, #1
    9014:	e50b3008 	str	r3, [fp, #-8]
    9018:	eaffffef 	b	8fdc <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    901c:	e320f000 	nop	{0}
    9020:	e28bd000 	add	sp, fp, #0
    9024:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9028:	e12fff1e 	bx	lr

0000902c <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    902c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9030:	e28db000 	add	fp, sp, #0
    9034:	e24dd014 	sub	sp, sp, #20
    9038:	ed0b0a04 	vstr	s0, [fp, #-16]
    903c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    9040:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    9044:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    9048:	e3a03000 	mov	r3, #0
    904c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    9050:	e51b200c 	ldr	r2, [fp, #-12]
    9054:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9058:	e1520003 	cmp	r2, r3
    905c:	2a000007 	bcs	9080 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    9060:	ed1b7a02 	vldr	s14, [fp, #-8]
    9064:	ed5b7a04 	vldr	s15, [fp, #-16]
    9068:	ee677a27 	vmul.f32	s15, s14, s15
    906c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    9070:	e51b300c 	ldr	r3, [fp, #-12]
    9074:	e2833001 	add	r3, r3, #1
    9078:	e50b300c 	str	r3, [fp, #-12]
    907c:	eafffff3 	b	9050 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    9080:	e51b3008 	ldr	r3, [fp, #-8]
    9084:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    9088:	eeb00a67 	vmov.f32	s0, s15
    908c:	e28bd000 	add	sp, fp, #0
    9090:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9094:	e12fff1e 	bx	lr

00009098 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    9098:	e92d4800 	push	{fp, lr}
    909c:	e28db004 	add	fp, sp, #4
    90a0:	e24dd018 	sub	sp, sp, #24
    90a4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    90a8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    90ac:	ebffff8f 	bl	8ef0 <_Z6strlenPKc>
    90b0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    90b4:	e3a03000 	mov	r3, #0
    90b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    90bc:	e51b300c 	ldr	r3, [fp, #-12]
    90c0:	e1a02fa3 	lsr	r2, r3, #31
    90c4:	e0823003 	add	r3, r2, r3
    90c8:	e1a030c3 	asr	r3, r3, #1
    90cc:	e1a02003 	mov	r2, r3
    90d0:	e51b3008 	ldr	r3, [fp, #-8]
    90d4:	e1530002 	cmp	r3, r2
    90d8:	aa00001c 	bge	9150 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    90dc:	e51b3008 	ldr	r3, [fp, #-8]
    90e0:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    90e4:	e0823003 	add	r3, r2, r3
    90e8:	e5d33000 	ldrb	r3, [r3]
    90ec:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    90f0:	e51b200c 	ldr	r2, [fp, #-12]
    90f4:	e51b3008 	ldr	r3, [fp, #-8]
    90f8:	e0423003 	sub	r3, r2, r3
    90fc:	e2433001 	sub	r3, r3, #1
    9100:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9104:	e0822003 	add	r2, r2, r3
    9108:	e51b3008 	ldr	r3, [fp, #-8]
    910c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    9110:	e0813003 	add	r3, r1, r3
    9114:	e5d22000 	ldrb	r2, [r2]
    9118:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    911c:	e51b200c 	ldr	r2, [fp, #-12]
    9120:	e51b3008 	ldr	r3, [fp, #-8]
    9124:	e0423003 	sub	r3, r2, r3
    9128:	e2433001 	sub	r3, r3, #1
    912c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9130:	e0823003 	add	r3, r2, r3
    9134:	e51b2010 	ldr	r2, [fp, #-16]
    9138:	e6ef2072 	uxtb	r2, r2
    913c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    9140:	e51b3008 	ldr	r3, [fp, #-8]
    9144:	e2833001 	add	r3, r3, #1
    9148:	e50b3008 	str	r3, [fp, #-8]
    914c:	eaffffda 	b	90bc <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    9150:	e320f000 	nop	{0}
    9154:	e24bd004 	sub	sp, fp, #4
    9158:	e8bd8800 	pop	{fp, pc}

0000915c <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    915c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9160:	e28db000 	add	fp, sp, #0
    9164:	e24dd01c 	sub	sp, sp, #28
    9168:	ed0b0a04 	vstr	s0, [fp, #-16]
    916c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    9170:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    9174:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    9178:	ed5b7a04 	vldr	s15, [fp, #-16]
    917c:	ed9f7af3 	vldr	s14, [pc, #972]	; 9550 <_Z11split_floatfRjS_Ri+0x3f4>
    9180:	eef47ac7 	vcmpe.f32	s15, s14
    9184:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9188:	ba000053 	blt	92dc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    918c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9190:	ed9f7aef 	vldr	s14, [pc, #956]	; 9554 <_Z11split_floatfRjS_Ri+0x3f8>
    9194:	eef47ac7 	vcmpe.f32	s15, s14
    9198:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    919c:	ba000008 	blt	91c4 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    91a0:	ed5b7a04 	vldr	s15, [fp, #-16]
    91a4:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9558 <_Z11split_floatfRjS_Ri+0x3fc>
    91a8:	ee677a87 	vmul.f32	s15, s15, s14
    91ac:	ed4b7a04 	vstr	s15, [fp, #-16]
    91b0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91b4:	e5933000 	ldr	r3, [r3]
    91b8:	e2832020 	add	r2, r3, #32
    91bc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91c0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    91c4:	ed5b7a04 	vldr	s15, [fp, #-16]
    91c8:	ed9f7ae3 	vldr	s14, [pc, #908]	; 955c <_Z11split_floatfRjS_Ri+0x400>
    91cc:	eef47ac7 	vcmpe.f32	s15, s14
    91d0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91d4:	ba000008 	blt	91fc <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    91d8:	ed5b7a04 	vldr	s15, [fp, #-16]
    91dc:	ed9f7adf 	vldr	s14, [pc, #892]	; 9560 <_Z11split_floatfRjS_Ri+0x404>
    91e0:	ee677a87 	vmul.f32	s15, s15, s14
    91e4:	ed4b7a04 	vstr	s15, [fp, #-16]
    91e8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91ec:	e5933000 	ldr	r3, [r3]
    91f0:	e2832010 	add	r2, r3, #16
    91f4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91f8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    91fc:	ed5b7a04 	vldr	s15, [fp, #-16]
    9200:	ed9f7ad7 	vldr	s14, [pc, #860]	; 9564 <_Z11split_floatfRjS_Ri+0x408>
    9204:	eef47ac7 	vcmpe.f32	s15, s14
    9208:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    920c:	ba000008 	blt	9234 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    9210:	ed5b7a04 	vldr	s15, [fp, #-16]
    9214:	ed9f7ad3 	vldr	s14, [pc, #844]	; 9568 <_Z11split_floatfRjS_Ri+0x40c>
    9218:	ee677a87 	vmul.f32	s15, s15, s14
    921c:	ed4b7a04 	vstr	s15, [fp, #-16]
    9220:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9224:	e5933000 	ldr	r3, [r3]
    9228:	e2832008 	add	r2, r3, #8
    922c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9230:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    9234:	ed5b7a04 	vldr	s15, [fp, #-16]
    9238:	ed9f7acb 	vldr	s14, [pc, #812]	; 956c <_Z11split_floatfRjS_Ri+0x410>
    923c:	eef47ac7 	vcmpe.f32	s15, s14
    9240:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9244:	ba000008 	blt	926c <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    9248:	ed5b7a04 	vldr	s15, [fp, #-16]
    924c:	ed9f7ac7 	vldr	s14, [pc, #796]	; 9570 <_Z11split_floatfRjS_Ri+0x414>
    9250:	ee677a87 	vmul.f32	s15, s15, s14
    9254:	ed4b7a04 	vstr	s15, [fp, #-16]
    9258:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    925c:	e5933000 	ldr	r3, [r3]
    9260:	e2832004 	add	r2, r3, #4
    9264:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9268:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    926c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9270:	ed9f7abf 	vldr	s14, [pc, #764]	; 9574 <_Z11split_floatfRjS_Ri+0x418>
    9274:	eef47ac7 	vcmpe.f32	s15, s14
    9278:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    927c:	ba000008 	blt	92a4 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    9280:	ed5b7a04 	vldr	s15, [fp, #-16]
    9284:	ed9f7abb 	vldr	s14, [pc, #748]	; 9578 <_Z11split_floatfRjS_Ri+0x41c>
    9288:	ee677a87 	vmul.f32	s15, s15, s14
    928c:	ed4b7a04 	vstr	s15, [fp, #-16]
    9290:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9294:	e5933000 	ldr	r3, [r3]
    9298:	e2832002 	add	r2, r3, #2
    929c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92a0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    92a4:	ed5b7a04 	vldr	s15, [fp, #-16]
    92a8:	ed9f7aa8 	vldr	s14, [pc, #672]	; 9550 <_Z11split_floatfRjS_Ri+0x3f4>
    92ac:	eef47ac7 	vcmpe.f32	s15, s14
    92b0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92b4:	ba000008 	blt	92dc <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    92b8:	ed5b7a04 	vldr	s15, [fp, #-16]
    92bc:	ed9f7aae 	vldr	s14, [pc, #696]	; 957c <_Z11split_floatfRjS_Ri+0x420>
    92c0:	ee677a87 	vmul.f32	s15, s15, s14
    92c4:	ed4b7a04 	vstr	s15, [fp, #-16]
    92c8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92cc:	e5933000 	ldr	r3, [r3]
    92d0:	e2832001 	add	r2, r3, #1
    92d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    92d8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    92dc:	ed5b7a04 	vldr	s15, [fp, #-16]
    92e0:	eef57ac0 	vcmpe.f32	s15, #0.0
    92e4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92e8:	da000058 	ble	9450 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    92ec:	ed5b7a04 	vldr	s15, [fp, #-16]
    92f0:	ed9f7aa2 	vldr	s14, [pc, #648]	; 9580 <_Z11split_floatfRjS_Ri+0x424>
    92f4:	eef47ac7 	vcmpe.f32	s15, s14
    92f8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92fc:	8a000053 	bhi	9450 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    9300:	ed5b7a04 	vldr	s15, [fp, #-16]
    9304:	ed9f7a9e 	vldr	s14, [pc, #632]	; 9584 <_Z11split_floatfRjS_Ri+0x428>
    9308:	eef47ac7 	vcmpe.f32	s15, s14
    930c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9310:	5a000008 	bpl	9338 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    9314:	ed5b7a04 	vldr	s15, [fp, #-16]
    9318:	ed9f7a8d 	vldr	s14, [pc, #564]	; 9554 <_Z11split_floatfRjS_Ri+0x3f8>
    931c:	ee677a87 	vmul.f32	s15, s15, s14
    9320:	ed4b7a04 	vstr	s15, [fp, #-16]
    9324:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9328:	e5933000 	ldr	r3, [r3]
    932c:	e2432020 	sub	r2, r3, #32
    9330:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9334:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    9338:	ed5b7a04 	vldr	s15, [fp, #-16]
    933c:	ed9f7a91 	vldr	s14, [pc, #580]	; 9588 <_Z11split_floatfRjS_Ri+0x42c>
    9340:	eef47ac7 	vcmpe.f32	s15, s14
    9344:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9348:	5a000008 	bpl	9370 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    934c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9350:	ed9f7a81 	vldr	s14, [pc, #516]	; 955c <_Z11split_floatfRjS_Ri+0x400>
    9354:	ee677a87 	vmul.f32	s15, s15, s14
    9358:	ed4b7a04 	vstr	s15, [fp, #-16]
    935c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9360:	e5933000 	ldr	r3, [r3]
    9364:	e2432010 	sub	r2, r3, #16
    9368:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    936c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    9370:	ed5b7a04 	vldr	s15, [fp, #-16]
    9374:	ed9f7a84 	vldr	s14, [pc, #528]	; 958c <_Z11split_floatfRjS_Ri+0x430>
    9378:	eef47ac7 	vcmpe.f32	s15, s14
    937c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9380:	5a000008 	bpl	93a8 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    9384:	ed5b7a04 	vldr	s15, [fp, #-16]
    9388:	ed9f7a75 	vldr	s14, [pc, #468]	; 9564 <_Z11split_floatfRjS_Ri+0x408>
    938c:	ee677a87 	vmul.f32	s15, s15, s14
    9390:	ed4b7a04 	vstr	s15, [fp, #-16]
    9394:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9398:	e5933000 	ldr	r3, [r3]
    939c:	e2432008 	sub	r2, r3, #8
    93a0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    93a4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    93a8:	ed5b7a04 	vldr	s15, [fp, #-16]
    93ac:	ed9f7a77 	vldr	s14, [pc, #476]	; 9590 <_Z11split_floatfRjS_Ri+0x434>
    93b0:	eef47ac7 	vcmpe.f32	s15, s14
    93b4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    93b8:	5a000008 	bpl	93e0 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    93bc:	ed5b7a04 	vldr	s15, [fp, #-16]
    93c0:	ed9f7a69 	vldr	s14, [pc, #420]	; 956c <_Z11split_floatfRjS_Ri+0x410>
    93c4:	ee677a87 	vmul.f32	s15, s15, s14
    93c8:	ed4b7a04 	vstr	s15, [fp, #-16]
    93cc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    93d0:	e5933000 	ldr	r3, [r3]
    93d4:	e2432004 	sub	r2, r3, #4
    93d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    93dc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    93e0:	ed5b7a04 	vldr	s15, [fp, #-16]
    93e4:	ed9f7a64 	vldr	s14, [pc, #400]	; 957c <_Z11split_floatfRjS_Ri+0x420>
    93e8:	eef47ac7 	vcmpe.f32	s15, s14
    93ec:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    93f0:	5a000008 	bpl	9418 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    93f4:	ed5b7a04 	vldr	s15, [fp, #-16]
    93f8:	ed9f7a5d 	vldr	s14, [pc, #372]	; 9574 <_Z11split_floatfRjS_Ri+0x418>
    93fc:	ee677a87 	vmul.f32	s15, s15, s14
    9400:	ed4b7a04 	vstr	s15, [fp, #-16]
    9404:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9408:	e5933000 	ldr	r3, [r3]
    940c:	e2432002 	sub	r2, r3, #2
    9410:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9414:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    9418:	ed5b7a04 	vldr	s15, [fp, #-16]
    941c:	ed9f7a57 	vldr	s14, [pc, #348]	; 9580 <_Z11split_floatfRjS_Ri+0x424>
    9420:	eef47ac7 	vcmpe.f32	s15, s14
    9424:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9428:	5a000008 	bpl	9450 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    942c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9430:	ed9f7a46 	vldr	s14, [pc, #280]	; 9550 <_Z11split_floatfRjS_Ri+0x3f4>
    9434:	ee677a87 	vmul.f32	s15, s15, s14
    9438:	ed4b7a04 	vstr	s15, [fp, #-16]
    943c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9440:	e5933000 	ldr	r3, [r3]
    9444:	e2432001 	sub	r2, r3, #1
    9448:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    944c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    9450:	ed5b7a04 	vldr	s15, [fp, #-16]
    9454:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9458:	ee172a90 	vmov	r2, s15
    945c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9460:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    9464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9468:	e5933000 	ldr	r3, [r3]
    946c:	ee073a90 	vmov	s15, r3
    9470:	eef87a67 	vcvt.f32.u32	s15, s15
    9474:	ed1b7a04 	vldr	s14, [fp, #-16]
    9478:	ee777a67 	vsub.f32	s15, s14, s15
    947c:	ed9f7a38 	vldr	s14, [pc, #224]	; 9564 <_Z11split_floatfRjS_Ri+0x408>
    9480:	ee677a87 	vmul.f32	s15, s15, s14
    9484:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    9488:	ed5b7a02 	vldr	s15, [fp, #-8]
    948c:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9490:	ee172a90 	vmov	r2, s15
    9494:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9498:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    949c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94a0:	e5933000 	ldr	r3, [r3]
    94a4:	ee073a90 	vmov	s15, r3
    94a8:	eef87a67 	vcvt.f32.u32	s15, s15
    94ac:	ed1b7a02 	vldr	s14, [fp, #-8]
    94b0:	ee777a67 	vsub.f32	s15, s14, s15
    94b4:	ed9f7a36 	vldr	s14, [pc, #216]	; 9594 <_Z11split_floatfRjS_Ri+0x438>
    94b8:	eef47ac7 	vcmpe.f32	s15, s14
    94bc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    94c0:	aa000000 	bge	94c8 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    94c4:	ea00001d 	b	9540 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    94c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94cc:	e5933000 	ldr	r3, [r3]
    94d0:	e2832001 	add	r2, r3, #1
    94d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94d8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    94dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94e0:	e5933000 	ldr	r3, [r3]
    94e4:	e59f20ac 	ldr	r2, [pc, #172]	; 9598 <_Z11split_floatfRjS_Ri+0x43c>
    94e8:	e1530002 	cmp	r3, r2
    94ec:	9a000013 	bls	9540 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    94f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94f4:	e3a02000 	mov	r2, #0
    94f8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    94fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9500:	e5933000 	ldr	r3, [r3]
    9504:	e2832001 	add	r2, r3, #1
    9508:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    950c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    9510:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9514:	e5933000 	ldr	r3, [r3]
    9518:	e3530009 	cmp	r3, #9
    951c:	9a000007 	bls	9540 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    9520:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9524:	e3a02001 	mov	r2, #1
    9528:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    952c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9530:	e5933000 	ldr	r3, [r3]
    9534:	e2832001 	add	r2, r3, #1
    9538:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    953c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    9540:	e320f000 	nop	{0}
    9544:	e28bd000 	add	sp, fp, #0
    9548:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    954c:	e12fff1e 	bx	lr
    9550:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9554:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9558:	0a4fb11f 	beq	13f59dc <__bss_end+0x13ebadc>
    955c:	5a0e1bca 	bpl	39048c <__bss_end+0x38658c>
    9560:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    9564:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    9568:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    956c:	461c4000 	ldrmi	r4, [ip], -r0
    9570:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    9574:	42c80000 	sbcmi	r0, r8, #0
    9578:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    957c:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    9580:	3f800000 	svccc	0x00800000
    9584:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    9588:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    958c:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    9590:	3a83126f 	bcc	fe0cdf54 <__bss_end+0xfe0c4054>
    9594:	3f000000 	svccc	0x00000000
    9598:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

0000959c <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    959c:	e92d4800 	push	{fp, lr}
    95a0:	e28db004 	add	fp, sp, #4
    95a4:	e24dd018 	sub	sp, sp, #24
    95a8:	e50b0010 	str	r0, [fp, #-16]
    95ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    95b0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    95b4:	e3a03000 	mov	r3, #0
    95b8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    95bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    95c0:	e2432001 	sub	r2, r3, #1
    95c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    95c8:	e3530000 	cmp	r3, #0
    95cc:	c3a03001 	movgt	r3, #1
    95d0:	d3a03000 	movle	r3, #0
    95d4:	e6ef3073 	uxtb	r3, r3
    95d8:	e3530000 	cmp	r3, #0
    95dc:	0a000018 	beq	9644 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    95e0:	e51b1010 	ldr	r1, [fp, #-16]
    95e4:	e59f3080 	ldr	r3, [pc, #128]	; 966c <_Z23decimal_to_string_floatjPci+0xd0>
    95e8:	e0832193 	umull	r2, r3, r3, r1
    95ec:	e1a021a3 	lsr	r2, r3, #3
    95f0:	e1a03002 	mov	r3, r2
    95f4:	e1a03103 	lsl	r3, r3, #2
    95f8:	e0833002 	add	r3, r3, r2
    95fc:	e1a03083 	lsl	r3, r3, #1
    9600:	e0412003 	sub	r2, r1, r3
    9604:	e6ef2072 	uxtb	r2, r2
    9608:	e51b3008 	ldr	r3, [fp, #-8]
    960c:	e2831001 	add	r1, r3, #1
    9610:	e50b1008 	str	r1, [fp, #-8]
    9614:	e1a01003 	mov	r1, r3
    9618:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    961c:	e0833001 	add	r3, r3, r1
    9620:	e2822030 	add	r2, r2, #48	; 0x30
    9624:	e6ef2072 	uxtb	r2, r2
    9628:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    962c:	e51b3010 	ldr	r3, [fp, #-16]
    9630:	e59f2034 	ldr	r2, [pc, #52]	; 966c <_Z23decimal_to_string_floatjPci+0xd0>
    9634:	e0832392 	umull	r2, r3, r2, r3
    9638:	e1a031a3 	lsr	r3, r3, #3
    963c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9640:	eaffffdd 	b	95bc <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    9644:	e51b3008 	ldr	r3, [fp, #-8]
    9648:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    964c:	e0823003 	add	r3, r2, r3
    9650:	e3a02000 	mov	r2, #0
    9654:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9658:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    965c:	ebfffe8d 	bl	9098 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    9660:	e320f000 	nop	{0}
    9664:	e24bd004 	sub	sp, fp, #4
    9668:	e8bd8800 	pop	{fp, pc}
    966c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00009670 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    9670:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9674:	e28db000 	add	fp, sp, #0
    9678:	e24dd00c 	sub	sp, sp, #12
    967c:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    9680:	ed1b7a02 	vldr	s14, [fp, #-8]
    9684:	ed5b7a02 	vldr	s15, [fp, #-8]
    9688:	eeb47a67 	vcmp.f32	s14, s15
    968c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9690:	13a03001 	movne	r3, #1
    9694:	03a03000 	moveq	r3, #0
    9698:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    969c:	e1a00003 	mov	r0, r3
    96a0:	e28bd000 	add	sp, fp, #0
    96a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    96a8:	e12fff1e 	bx	lr

000096ac <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    96ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    96b0:	e28db000 	add	fp, sp, #0
    96b4:	e24dd00c 	sub	sp, sp, #12
    96b8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    96bc:	ed5b7a02 	vldr	s15, [fp, #-8]
    96c0:	ed9f7a08 	vldr	s14, [pc, #32]	; 96e8 <_Z5isinff+0x3c>
    96c4:	eef47ac7 	vcmpe.f32	s15, s14
    96c8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    96cc:	c3a03001 	movgt	r3, #1
    96d0:	d3a03000 	movle	r3, #0
    96d4:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    96d8:	e1a00003 	mov	r0, r3
    96dc:	e28bd000 	add	sp, fp, #0
    96e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    96e4:	e12fff1e 	bx	lr
    96e8:	7f7fffff 	svcvc	0x007fffff

000096ec <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    96ec:	e92d4800 	push	{fp, lr}
    96f0:	e28db004 	add	fp, sp, #4
    96f4:	e24dd008 	sub	sp, sp, #8
    96f8:	ed0b0a02 	vstr	s0, [fp, #-8]
    96fc:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    9700:	e3a01008 	mov	r1, #8
    9704:	e51b000c 	ldr	r0, [fp, #-12]
    9708:	ed1b0a02 	vldr	s0, [fp, #-8]
    970c:	eb000002 	bl	971c <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    9710:	e320f000 	nop	{0}
    9714:	e24bd004 	sub	sp, fp, #4
    9718:	e8bd8800 	pop	{fp, pc}

0000971c <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    971c:	e92d4800 	push	{fp, lr}
    9720:	e28db004 	add	fp, sp, #4
    9724:	e24dd060 	sub	sp, sp, #96	; 0x60
    9728:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    972c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    9730:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9734:	e3a03000 	mov	r3, #0
    9738:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    973c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9740:	eef57ac0 	vcmpe.f32	s15, #0.0
    9744:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9748:	5a000009 	bpl	9774 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    974c:	e51b3008 	ldr	r3, [fp, #-8]
    9750:	e2832001 	add	r2, r3, #1
    9754:	e50b2008 	str	r2, [fp, #-8]
    9758:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    975c:	e0823003 	add	r3, r2, r3
    9760:	e3a0202d 	mov	r2, #45	; 0x2d
    9764:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    9768:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    976c:	eef17a67 	vneg.f32	s15, s15
    9770:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    9774:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9778:	ebffffbc 	bl	9670 <_Z5isnanf>
    977c:	e1a03000 	mov	r3, r0
    9780:	e3530000 	cmp	r3, #0
    9784:	0a00001c 	beq	97fc <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    9788:	e51b3008 	ldr	r3, [fp, #-8]
    978c:	e2832001 	add	r2, r3, #1
    9790:	e50b2008 	str	r2, [fp, #-8]
    9794:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9798:	e0823003 	add	r3, r2, r3
    979c:	e3a0204e 	mov	r2, #78	; 0x4e
    97a0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    97a4:	e51b3008 	ldr	r3, [fp, #-8]
    97a8:	e2832001 	add	r2, r3, #1
    97ac:	e50b2008 	str	r2, [fp, #-8]
    97b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    97b4:	e0823003 	add	r3, r2, r3
    97b8:	e3a02061 	mov	r2, #97	; 0x61
    97bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    97c0:	e51b3008 	ldr	r3, [fp, #-8]
    97c4:	e2832001 	add	r2, r3, #1
    97c8:	e50b2008 	str	r2, [fp, #-8]
    97cc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    97d0:	e0823003 	add	r3, r2, r3
    97d4:	e3a0204e 	mov	r2, #78	; 0x4e
    97d8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    97dc:	e51b3008 	ldr	r3, [fp, #-8]
    97e0:	e2832001 	add	r2, r3, #1
    97e4:	e50b2008 	str	r2, [fp, #-8]
    97e8:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    97ec:	e0823003 	add	r3, r2, r3
    97f0:	e3a02000 	mov	r2, #0
    97f4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    97f8:	ea00008c 	b	9a30 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    97fc:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9800:	ebffffa9 	bl	96ac <_Z5isinff>
    9804:	e1a03000 	mov	r3, r0
    9808:	e3530000 	cmp	r3, #0
    980c:	0a00001c 	beq	9884 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    9810:	e51b3008 	ldr	r3, [fp, #-8]
    9814:	e2832001 	add	r2, r3, #1
    9818:	e50b2008 	str	r2, [fp, #-8]
    981c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9820:	e0823003 	add	r3, r2, r3
    9824:	e3a02049 	mov	r2, #73	; 0x49
    9828:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    982c:	e51b3008 	ldr	r3, [fp, #-8]
    9830:	e2832001 	add	r2, r3, #1
    9834:	e50b2008 	str	r2, [fp, #-8]
    9838:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    983c:	e0823003 	add	r3, r2, r3
    9840:	e3a0206e 	mov	r2, #110	; 0x6e
    9844:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    9848:	e51b3008 	ldr	r3, [fp, #-8]
    984c:	e2832001 	add	r2, r3, #1
    9850:	e50b2008 	str	r2, [fp, #-8]
    9854:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9858:	e0823003 	add	r3, r2, r3
    985c:	e3a02066 	mov	r2, #102	; 0x66
    9860:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    9864:	e51b3008 	ldr	r3, [fp, #-8]
    9868:	e2832001 	add	r2, r3, #1
    986c:	e50b2008 	str	r2, [fp, #-8]
    9870:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9874:	e0823003 	add	r3, r2, r3
    9878:	e3a02000 	mov	r2, #0
    987c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    9880:	ea00006a 	b	9a30 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    9884:	e3a03008 	mov	r3, #8
    9888:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    988c:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9890:	e3530007 	cmp	r3, #7
    9894:	8a000001 	bhi	98a0 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    9898:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    989c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    98a0:	e51b300c 	ldr	r3, [fp, #-12]
    98a4:	e1a00003 	mov	r0, r3
    98a8:	ed9f0a62 	vldr	s0, [pc, #392]	; 9a38 <_Z4ftoafPcj+0x31c>
    98ac:	ebfffdde 	bl	902c <_Z3powfj>
    98b0:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    98b4:	eddf6a60 	vldr	s13, [pc, #384]	; 9a3c <_Z4ftoafPcj+0x320>
    98b8:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    98bc:	eec67a87 	vdiv.f32	s15, s13, s14
    98c0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    98c4:	ee777a27 	vadd.f32	s15, s14, s15
    98c8:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    98cc:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    98d0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    98d4:	ee173a90 	vmov	r3, s15
    98d8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    98dc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    98e0:	ee073a90 	vmov	s15, r3
    98e4:	eef87a67 	vcvt.f32.u32	s15, s15
    98e8:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    98ec:	ee377a67 	vsub.f32	s14, s14, s15
    98f0:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    98f4:	ee677a27 	vmul.f32	s15, s14, s15
    98f8:	eefc7ae7 	vcvt.u32.f32	s15, s15
    98fc:	ee173a90 	vmov	r3, s15
    9900:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    9904:	e24b3044 	sub	r3, fp, #68	; 0x44
    9908:	e3a0200a 	mov	r2, #10
    990c:	e1a01003 	mov	r1, r3
    9910:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9914:	ebfffc96 	bl	8b74 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9918:	e24b3044 	sub	r3, fp, #68	; 0x44
    991c:	e1a00003 	mov	r0, r3
    9920:	ebfffd72 	bl	8ef0 <_Z6strlenPKc>
    9924:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9928:	e3a03000 	mov	r3, #0
    992c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    9930:	e51b2010 	ldr	r2, [fp, #-16]
    9934:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9938:	e1520003 	cmp	r2, r3
    993c:	aa00000d 	bge	9978 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    9940:	e51b3008 	ldr	r3, [fp, #-8]
    9944:	e2832001 	add	r2, r3, #1
    9948:	e50b2008 	str	r2, [fp, #-8]
    994c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9950:	e0823003 	add	r3, r2, r3
    9954:	e24b1044 	sub	r1, fp, #68	; 0x44
    9958:	e51b2010 	ldr	r2, [fp, #-16]
    995c:	e0812002 	add	r2, r1, r2
    9960:	e5d22000 	ldrb	r2, [r2]
    9964:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    9968:	e51b3010 	ldr	r3, [fp, #-16]
    996c:	e2833001 	add	r3, r3, #1
    9970:	e50b3010 	str	r3, [fp, #-16]
    9974:	eaffffed 	b	9930 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    9978:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    997c:	e3530000 	cmp	r3, #0
    9980:	0a000025 	beq	9a1c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    9984:	e51b3008 	ldr	r3, [fp, #-8]
    9988:	e2832001 	add	r2, r3, #1
    998c:	e50b2008 	str	r2, [fp, #-8]
    9990:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9994:	e0823003 	add	r3, r2, r3
    9998:	e3a0202e 	mov	r2, #46	; 0x2e
    999c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    99a0:	e24b3050 	sub	r3, fp, #80	; 0x50
    99a4:	e51b200c 	ldr	r2, [fp, #-12]
    99a8:	e1a01003 	mov	r1, r3
    99ac:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    99b0:	ebfffef9 	bl	959c <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    99b4:	e3a03000 	mov	r3, #0
    99b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    99bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    99c0:	e3530008 	cmp	r3, #8
    99c4:	ca000014 	bgt	9a1c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    99c8:	e24b2050 	sub	r2, fp, #80	; 0x50
    99cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    99d0:	e0823003 	add	r3, r2, r3
    99d4:	e5d33000 	ldrb	r3, [r3]
    99d8:	e3530000 	cmp	r3, #0
    99dc:	0a00000d 	beq	9a18 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    99e0:	e51b3008 	ldr	r3, [fp, #-8]
    99e4:	e2832001 	add	r2, r3, #1
    99e8:	e50b2008 	str	r2, [fp, #-8]
    99ec:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    99f0:	e0823003 	add	r3, r2, r3
    99f4:	e24b1050 	sub	r1, fp, #80	; 0x50
    99f8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    99fc:	e0812002 	add	r2, r1, r2
    9a00:	e5d22000 	ldrb	r2, [r2]
    9a04:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    9a08:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9a0c:	e2833001 	add	r3, r3, #1
    9a10:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9a14:	eaffffe8 	b	99bc <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9a18:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    9a1c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9a20:	e51b3008 	ldr	r3, [fp, #-8]
    9a24:	e0823003 	add	r3, r2, r3
    9a28:	e3a02000 	mov	r2, #0
    9a2c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    9a30:	e24bd004 	sub	sp, fp, #4
    9a34:	e8bd8800 	pop	{fp, pc}
    9a38:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9a3c:	3f000000 	svccc	0x00000000

00009a40 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    9a40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9a44:	e28db000 	add	fp, sp, #0
    9a48:	e24dd01c 	sub	sp, sp, #28
    9a4c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    9a50:	e3a03000 	mov	r3, #0
    9a54:	e50b3008 	str	r3, [fp, #-8]
    9a58:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    9a5c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    9a60:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a64:	e5d33000 	ldrb	r3, [r3]
    9a68:	e353002d 	cmp	r3, #45	; 0x2d
    9a6c:	1a000004 	bne	9a84 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    9a70:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a74:	e2833001 	add	r3, r3, #1
    9a78:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    9a7c:	e59f30c8 	ldr	r3, [pc, #200]	; 9b4c <_Z4atofPKc+0x10c>
    9a80:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    9a84:	e3a03000 	mov	r3, #0
    9a88:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    9a8c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9a90:	e5d33000 	ldrb	r3, [r3]
    9a94:	e3530000 	cmp	r3, #0
    9a98:	0a000023 	beq	9b2c <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    9a9c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9aa0:	e5d33000 	ldrb	r3, [r3]
    9aa4:	e353002e 	cmp	r3, #46	; 0x2e
    9aa8:	1a000002 	bne	9ab8 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    9aac:	e3a03001 	mov	r3, #1
    9ab0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    9ab4:	ea000018 	b	9b1c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    9ab8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9abc:	e5d33000 	ldrb	r3, [r3]
    9ac0:	e2433030 	sub	r3, r3, #48	; 0x30
    9ac4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    9ac8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9acc:	e3530000 	cmp	r3, #0
    9ad0:	ba000011 	blt	9b1c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    9ad4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9ad8:	e3530009 	cmp	r3, #9
    9adc:	ca00000e 	bgt	9b1c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    9ae0:	e51b3010 	ldr	r3, [fp, #-16]
    9ae4:	e3530000 	cmp	r3, #0
    9ae8:	0a000003 	beq	9afc <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    9aec:	ed1b7a03 	vldr	s14, [fp, #-12]
    9af0:	eddf6a14 	vldr	s13, [pc, #80]	; 9b48 <_Z4atofPKc+0x108>
    9af4:	eec77a26 	vdiv.f32	s15, s14, s13
    9af8:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    9afc:	ed5b7a02 	vldr	s15, [fp, #-8]
    9b00:	ed9f7a10 	vldr	s14, [pc, #64]	; 9b48 <_Z4atofPKc+0x108>
    9b04:	ee277a87 	vmul.f32	s14, s15, s14
    9b08:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9b0c:	ee073a90 	vmov	s15, r3
    9b10:	eef87ae7 	vcvt.f32.s32	s15, s15
    9b14:	ee777a27 	vadd.f32	s15, s14, s15
    9b18:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    9b1c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9b20:	e2833001 	add	r3, r3, #1
    9b24:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9b28:	eaffffd7 	b	9a8c <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    9b2c:	ed1b7a02 	vldr	s14, [fp, #-8]
    9b30:	ed5b7a03 	vldr	s15, [fp, #-12]
    9b34:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9b38:	eeb00a67 	vmov.f32	s0, s15
    9b3c:	e28bd000 	add	sp, fp, #0
    9b40:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b44:	e12fff1e 	bx	lr
    9b48:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9b4c:	bf800000 	svclt	0x00800000

00009b50 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9b50:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9b54:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9b58:	3a000074 	bcc	9d30 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    9b5c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9b60:	9a00006b 	bls	9d14 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9b64:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9b68:	0a00006c 	beq	9d20 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9b6c:	e16f3f10 	clz	r3, r0
    9b70:	e16f2f11 	clz	r2, r1
    9b74:	e0423003 	sub	r3, r2, r3
    9b78:	e273301f 	rsbs	r3, r3, #31
    9b7c:	10833083 	addne	r3, r3, r3, lsl #1
    9b80:	e3a02000 	mov	r2, #0
    9b84:	108ff103 	addne	pc, pc, r3, lsl #2
    9b88:	e1a00000 	nop			; (mov r0, r0)
    9b8c:	e1500f81 	cmp	r0, r1, lsl #31
    9b90:	e0a22002 	adc	r2, r2, r2
    9b94:	20400f81 	subcs	r0, r0, r1, lsl #31
    9b98:	e1500f01 	cmp	r0, r1, lsl #30
    9b9c:	e0a22002 	adc	r2, r2, r2
    9ba0:	20400f01 	subcs	r0, r0, r1, lsl #30
    9ba4:	e1500e81 	cmp	r0, r1, lsl #29
    9ba8:	e0a22002 	adc	r2, r2, r2
    9bac:	20400e81 	subcs	r0, r0, r1, lsl #29
    9bb0:	e1500e01 	cmp	r0, r1, lsl #28
    9bb4:	e0a22002 	adc	r2, r2, r2
    9bb8:	20400e01 	subcs	r0, r0, r1, lsl #28
    9bbc:	e1500d81 	cmp	r0, r1, lsl #27
    9bc0:	e0a22002 	adc	r2, r2, r2
    9bc4:	20400d81 	subcs	r0, r0, r1, lsl #27
    9bc8:	e1500d01 	cmp	r0, r1, lsl #26
    9bcc:	e0a22002 	adc	r2, r2, r2
    9bd0:	20400d01 	subcs	r0, r0, r1, lsl #26
    9bd4:	e1500c81 	cmp	r0, r1, lsl #25
    9bd8:	e0a22002 	adc	r2, r2, r2
    9bdc:	20400c81 	subcs	r0, r0, r1, lsl #25
    9be0:	e1500c01 	cmp	r0, r1, lsl #24
    9be4:	e0a22002 	adc	r2, r2, r2
    9be8:	20400c01 	subcs	r0, r0, r1, lsl #24
    9bec:	e1500b81 	cmp	r0, r1, lsl #23
    9bf0:	e0a22002 	adc	r2, r2, r2
    9bf4:	20400b81 	subcs	r0, r0, r1, lsl #23
    9bf8:	e1500b01 	cmp	r0, r1, lsl #22
    9bfc:	e0a22002 	adc	r2, r2, r2
    9c00:	20400b01 	subcs	r0, r0, r1, lsl #22
    9c04:	e1500a81 	cmp	r0, r1, lsl #21
    9c08:	e0a22002 	adc	r2, r2, r2
    9c0c:	20400a81 	subcs	r0, r0, r1, lsl #21
    9c10:	e1500a01 	cmp	r0, r1, lsl #20
    9c14:	e0a22002 	adc	r2, r2, r2
    9c18:	20400a01 	subcs	r0, r0, r1, lsl #20
    9c1c:	e1500981 	cmp	r0, r1, lsl #19
    9c20:	e0a22002 	adc	r2, r2, r2
    9c24:	20400981 	subcs	r0, r0, r1, lsl #19
    9c28:	e1500901 	cmp	r0, r1, lsl #18
    9c2c:	e0a22002 	adc	r2, r2, r2
    9c30:	20400901 	subcs	r0, r0, r1, lsl #18
    9c34:	e1500881 	cmp	r0, r1, lsl #17
    9c38:	e0a22002 	adc	r2, r2, r2
    9c3c:	20400881 	subcs	r0, r0, r1, lsl #17
    9c40:	e1500801 	cmp	r0, r1, lsl #16
    9c44:	e0a22002 	adc	r2, r2, r2
    9c48:	20400801 	subcs	r0, r0, r1, lsl #16
    9c4c:	e1500781 	cmp	r0, r1, lsl #15
    9c50:	e0a22002 	adc	r2, r2, r2
    9c54:	20400781 	subcs	r0, r0, r1, lsl #15
    9c58:	e1500701 	cmp	r0, r1, lsl #14
    9c5c:	e0a22002 	adc	r2, r2, r2
    9c60:	20400701 	subcs	r0, r0, r1, lsl #14
    9c64:	e1500681 	cmp	r0, r1, lsl #13
    9c68:	e0a22002 	adc	r2, r2, r2
    9c6c:	20400681 	subcs	r0, r0, r1, lsl #13
    9c70:	e1500601 	cmp	r0, r1, lsl #12
    9c74:	e0a22002 	adc	r2, r2, r2
    9c78:	20400601 	subcs	r0, r0, r1, lsl #12
    9c7c:	e1500581 	cmp	r0, r1, lsl #11
    9c80:	e0a22002 	adc	r2, r2, r2
    9c84:	20400581 	subcs	r0, r0, r1, lsl #11
    9c88:	e1500501 	cmp	r0, r1, lsl #10
    9c8c:	e0a22002 	adc	r2, r2, r2
    9c90:	20400501 	subcs	r0, r0, r1, lsl #10
    9c94:	e1500481 	cmp	r0, r1, lsl #9
    9c98:	e0a22002 	adc	r2, r2, r2
    9c9c:	20400481 	subcs	r0, r0, r1, lsl #9
    9ca0:	e1500401 	cmp	r0, r1, lsl #8
    9ca4:	e0a22002 	adc	r2, r2, r2
    9ca8:	20400401 	subcs	r0, r0, r1, lsl #8
    9cac:	e1500381 	cmp	r0, r1, lsl #7
    9cb0:	e0a22002 	adc	r2, r2, r2
    9cb4:	20400381 	subcs	r0, r0, r1, lsl #7
    9cb8:	e1500301 	cmp	r0, r1, lsl #6
    9cbc:	e0a22002 	adc	r2, r2, r2
    9cc0:	20400301 	subcs	r0, r0, r1, lsl #6
    9cc4:	e1500281 	cmp	r0, r1, lsl #5
    9cc8:	e0a22002 	adc	r2, r2, r2
    9ccc:	20400281 	subcs	r0, r0, r1, lsl #5
    9cd0:	e1500201 	cmp	r0, r1, lsl #4
    9cd4:	e0a22002 	adc	r2, r2, r2
    9cd8:	20400201 	subcs	r0, r0, r1, lsl #4
    9cdc:	e1500181 	cmp	r0, r1, lsl #3
    9ce0:	e0a22002 	adc	r2, r2, r2
    9ce4:	20400181 	subcs	r0, r0, r1, lsl #3
    9ce8:	e1500101 	cmp	r0, r1, lsl #2
    9cec:	e0a22002 	adc	r2, r2, r2
    9cf0:	20400101 	subcs	r0, r0, r1, lsl #2
    9cf4:	e1500081 	cmp	r0, r1, lsl #1
    9cf8:	e0a22002 	adc	r2, r2, r2
    9cfc:	20400081 	subcs	r0, r0, r1, lsl #1
    9d00:	e1500001 	cmp	r0, r1
    9d04:	e0a22002 	adc	r2, r2, r2
    9d08:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9d0c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9d10:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9d14:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9d18:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9d1c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    9d20:	e16f2f11 	clz	r2, r1
    9d24:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9d28:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9d2c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9d30:	e3500000 	cmp	r0, #0
    9d34:	13e00000 	mvnne	r0, #0
    9d38:	ea000007 	b	9d5c <__aeabi_idiv0>

00009d3c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9d3c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9d40:	0afffffa 	beq	9d30 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9d44:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9d48:	ebffff80 	bl	9b50 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    9d4c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9d50:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9d54:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9d58:	e12fff1e 	bx	lr

00009d5c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9d5c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009d60 <_ZL8INFINITY>:
    9d60:	7f7fffff 	svcvc	0x007fffff

00009d64 <_ZL9INT32_MAX>:
    9d64:	7fffffff 	svcvc	0x00ffffff

00009d68 <_ZL9INT32_MIN>:
    9d68:	80000000 	andhi	r0, r0, r0

00009d6c <_ZL10UINT32_MAX>:
    9d6c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009d70 <_ZL10UINT32_MIN>:
    9d70:	00000000 	andeq	r0, r0, r0

00009d74 <_ZL13Lock_Unlocked>:
    9d74:	00000000 	andeq	r0, r0, r0

00009d78 <_ZL11Lock_Locked>:
    9d78:	00000001 	andeq	r0, r0, r1

00009d7c <_ZL21MaxFSDriverNameLength>:
    9d7c:	00000010 	andeq	r0, r0, r0, lsl r0

00009d80 <_ZL17MaxFilenameLength>:
    9d80:	00000010 	andeq	r0, r0, r0, lsl r0

00009d84 <_ZL13MaxPathLength>:
    9d84:	00000080 	andeq	r0, r0, r0, lsl #1

00009d88 <_ZL18NoFilesystemDriver>:
    9d88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009d8c <_ZL9NotifyAll>:
    9d8c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009d90 <_ZL24Max_Process_Opened_Files>:
    9d90:	00000010 	andeq	r0, r0, r0, lsl r0

00009d94 <_ZL10Indefinite>:
    9d94:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009d98 <_ZL18Deadline_Unchanged>:
    9d98:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009d9c <_ZL14Invalid_Handle>:
    9d9c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9da0:	3a564544 	bcc	159b2b8 <__bss_end+0x15913b8>
    9da4:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    9da8:	0000302f 	andeq	r3, r0, pc, lsr #32
    9dac:	3a564544 	bcc	159b2c4 <__bss_end+0x15913c4>
    9db0:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    9db4:	00000000 	andeq	r0, r0, r0
    9db8:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    9dbc:	73617420 	cmnvc	r1, #32, 8	; 0x20000000
    9dc0:	7473206b 	ldrbtvc	r2, [r3], #-107	; 0xffffff95
    9dc4:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
    9dc8:	0d21676e 	stceq	7, cr6, [r1, #-440]!	; 0xfffffe48
    9dcc:	0000000a 	andeq	r0, r0, sl
    9dd0:	45530a0d 	ldrbmi	r0, [r3, #-2573]	; 0xfffff5f3
    9dd4:	4e49444e 	cdpmi	4, 4, cr4, cr9, cr14, {2}
    9dd8:	4c462047 	mcrrmi	0, 4, r2, r6, cr7
    9ddc:	2154414f 	cmpcs	r4, pc, asr #2
    9de0:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9de4:	45530a0d 	ldrbmi	r0, [r3, #-2573]	; 0xfffff5f3
    9de8:	4620544e 	strtmi	r5, [r0], -lr, asr #8
    9dec:	54414f4c 	strbpl	r4, [r1], #-3916	; 0xfffff0b4
    9df0:	000a0d21 	andeq	r0, sl, r1, lsr #26
    9df4:	45434552 	strbmi	r4, [r3, #-1362]	; 0xfffffaae
    9df8:	44455649 	strbmi	r5, [r5], #-1609	; 0xfffff9b7
    9dfc:	54414420 	strbpl	r4, [r1], #-1056	; 0xfffffbe0
    9e00:	0a0d2141 	beq	35230c <__bss_end+0x34840c>
    9e04:	00000000 	andeq	r0, r0, r0
    9e08:	0000005b 	andeq	r0, r0, fp, asr r0
    9e0c:	00203a5d 	eoreq	r3, r0, sp, asr sl
    9e10:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9e14:	52414843 	subpl	r4, r1, #4390912	; 0x430000
    9e18:	0078305b 	rsbseq	r3, r8, fp, asr r0
    9e1c:	000a0d5d 	andeq	r0, sl, sp, asr sp
    9e20:	20544f47 	subscs	r4, r4, r7, asr #30
    9e24:	444e4152 	strbmi	r4, [lr], #-338	; 0xfffffeae
    9e28:	4e204d4f 	cdpmi	13, 2, cr4, cr0, cr15, {2}
    9e2c:	45424d55 	strbmi	r4, [r2, #-3413]	; 0xfffff2ab
    9e30:	00203a52 	eoreq	r3, r0, r2, asr sl
    9e34:	54494157 	strbpl	r4, [r9], #-343	; 0xfffffea9
    9e38:	4c414320 	mcrrmi	3, 2, r4, r1, cr0
    9e3c:	2144454c 	cmpcs	r4, ip, asr #10
    9e40:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9e44:	454b4f57 	strbmi	r4, [fp, #-3927]	; 0xfffff0a9
    9e48:	21505520 	cmpcs	r0, r0, lsr #10
    9e4c:	00000a0d 	andeq	r0, r0, sp, lsl #20

00009e50 <_ZL9INT32_MAX>:
    9e50:	7fffffff 	svcvc	0x00ffffff

00009e54 <_ZL9INT32_MIN>:
    9e54:	80000000 	andhi	r0, r0, r0

00009e58 <_ZL10UINT32_MAX>:
    9e58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e5c <_ZL10UINT32_MIN>:
    9e5c:	00000000 	andeq	r0, r0, r0

00009e60 <_ZL13Lock_Unlocked>:
    9e60:	00000000 	andeq	r0, r0, r0

00009e64 <_ZL11Lock_Locked>:
    9e64:	00000001 	andeq	r0, r0, r1

00009e68 <_ZL21MaxFSDriverNameLength>:
    9e68:	00000010 	andeq	r0, r0, r0, lsl r0

00009e6c <_ZL17MaxFilenameLength>:
    9e6c:	00000010 	andeq	r0, r0, r0, lsl r0

00009e70 <_ZL13MaxPathLength>:
    9e70:	00000080 	andeq	r0, r0, r0, lsl #1

00009e74 <_ZL18NoFilesystemDriver>:
    9e74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e78 <_ZL9NotifyAll>:
    9e78:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e7c <_ZL24Max_Process_Opened_Files>:
    9e7c:	00000010 	andeq	r0, r0, r0, lsl r0

00009e80 <_ZL10Indefinite>:
    9e80:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e84 <_ZL18Deadline_Unchanged>:
    9e84:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009e88 <_ZL14Invalid_Handle>:
    9e88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009e8c <_ZL8INFINITY>:
    9e8c:	7f7fffff 	svcvc	0x007fffff

00009e90 <_ZL16Pipe_File_Prefix>:
    9e90:	3a535953 	bcc	14e03e4 <__bss_end+0x14d64e4>
    9e94:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9e98:	0000002f 	andeq	r0, r0, pc, lsr #32

00009e9c <_ZL9INT32_MAX>:
    9e9c:	7fffffff 	svcvc	0x00ffffff

00009ea0 <_ZL9INT32_MIN>:
    9ea0:	80000000 	andhi	r0, r0, r0

00009ea4 <_ZL10UINT32_MAX>:
    9ea4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ea8 <_ZL10UINT32_MIN>:
    9ea8:	00000000 	andeq	r0, r0, r0

00009eac <_ZL13Lock_Unlocked>:
    9eac:	00000000 	andeq	r0, r0, r0

00009eb0 <_ZL11Lock_Locked>:
    9eb0:	00000001 	andeq	r0, r0, r1

00009eb4 <_ZL21MaxFSDriverNameLength>:
    9eb4:	00000010 	andeq	r0, r0, r0, lsl r0

00009eb8 <_ZL17MaxFilenameLength>:
    9eb8:	00000010 	andeq	r0, r0, r0, lsl r0

00009ebc <_ZL13MaxPathLength>:
    9ebc:	00000080 	andeq	r0, r0, r0, lsl #1

00009ec0 <_ZL18NoFilesystemDriver>:
    9ec0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ec4 <_ZL9NotifyAll>:
    9ec4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ec8 <_ZL24Max_Process_Opened_Files>:
    9ec8:	00000010 	andeq	r0, r0, r0, lsl r0

00009ecc <_ZL10Indefinite>:
    9ecc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ed0 <_ZL18Deadline_Unchanged>:
    9ed0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009ed4 <_ZL14Invalid_Handle>:
    9ed4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ed8 <_ZL8INFINITY>:
    9ed8:	7f7fffff 	svcvc	0x007fffff

00009edc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9edc:	33323130 	teqcc	r2, #48, 2
    9ee0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9ee4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9ee8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009ef0 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x168392c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38524>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c138>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c6e24>
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
      80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcf73c>
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
      fc:	fb010200 	blx	40906 <__bss_end+0x36a06>
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
     12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff5ecf>
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
     164:	0a05830b 	beq	160d98 <__bss_end+0x156e98>
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
     190:	4a030402 	bmi	c11a0 <__bss_end+0xb72a0>
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
     1c4:	4a020402 	bmi	811d4 <__bss_end+0x772d4>
     1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
     1d0:	01058509 	tsteq	r5, r9, lsl #10
     1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
     1d8:	02e10101 	rsceq	r0, r1, #1073741824	; 0x40000000
     1dc:	00030000 	andeq	r0, r3, r0
     1e0:	00000224 	andeq	r0, r0, r4, lsr #4
     1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     1e8:	0101000d 	tsteq	r1, sp
     1ec:	00000101 	andeq	r0, r0, r1, lsl #2
     1f0:	00000100 	andeq	r0, r0, r0, lsl #2
     1f4:	6f682f01 	svcvs	0x00682f01
     1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcf8b4>
     1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
     200:	2f697261 	svccs	0x00697261
     204:	2f746967 	svccs	0x00746967
     208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     20c:	6f732f70 	svcvs	0x00732f70
     210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     214:	73752f73 	cmnvc	r5, #460	; 0x1cc
     218:	70737265 	rsbsvc	r7, r3, r5, ror #4
     21c:	2f656361 	svccs	0x00656361
     220:	67676f6c 	strbvs	r6, [r7, -ip, ror #30]!
     224:	745f7265 	ldrbvc	r7, [pc], #-613	; 22c <shift+0x22c>
     228:	006b7361 	rsbeq	r7, fp, r1, ror #6
     22c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 178 <shift+0x178>
     230:	616a2f65 	cmnvs	sl, r5, ror #30
     234:	6173656d 	cmnvs	r3, sp, ror #10
     238:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     23c:	6f2f7469 	svcvs	0x002f7469
     240:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     244:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff1d <__bss_end+0xffff601d>
     248:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     24c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     250:	61707372 	cmnvs	r0, r2, ror r3
     254:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     258:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     25c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     260:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     264:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     268:	616f622f 	cmnvs	pc, pc, lsr #4
     26c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     270:	2f306970 	svccs	0x00306970
     274:	006c6168 	rsbeq	r6, ip, r8, ror #2
     278:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1c4 <shift+0x1c4>
     27c:	616a2f65 	cmnvs	sl, r5, ror #30
     280:	6173656d 	cmnvs	r3, sp, ror #10
     284:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     288:	6f2f7469 	svcvs	0x002f7469
     28c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     290:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff69 <__bss_end+0xffff6069>
     294:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     298:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     29c:	61707372 	cmnvs	r0, r2, ror r3
     2a0:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     2a4:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     2a8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     2ac:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     2b0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     2b4:	6f682f00 	svcvs	0x00682f00
     2b8:	6a2f656d 	bvs	bd9874 <__bss_end+0xbcf974>
     2bc:	73656d61 	cmnvc	r5, #6208	; 0x1840
     2c0:	2f697261 	svccs	0x00697261
     2c4:	2f746967 	svccs	0x00746967
     2c8:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     2cc:	6f732f70 	svcvs	0x00732f70
     2d0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     2d4:	73752f73 	cmnvc	r5, #460	; 0x1cc
     2d8:	70737265 	rsbsvc	r7, r3, r5, ror #4
     2dc:	2f656361 	svccs	0x00656361
     2e0:	6b2f2e2e 	blvs	bcbba0 <__bss_end+0xbc1ca0>
     2e4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     2e8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     2ec:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2f0:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     2f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     2f8:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     2fc:	2f656d6f 	svccs	0x00656d6f
     300:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     304:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     308:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     30c:	2f736f2f 	svccs	0x00736f2f
     310:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     314:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     318:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffbb <__bss_end+0xffff60bb>
     31c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     320:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     324:	2f2e2e2f 	svccs	0x002e2e2f
     328:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     32c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     330:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     334:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     338:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     33c:	2f656d6f 	svccs	0x00656d6f
     340:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     344:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     348:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     34c:	2f736f2f 	svccs	0x00736f2f
     350:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     354:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     358:	752f7365 	strvc	r7, [pc, #-869]!	; fffffffb <__bss_end+0xffff60fb>
     35c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     360:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     364:	2f2e2e2f 	svccs	0x002e2e2f
     368:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     36c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     370:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     374:	642f6564 	strtvs	r6, [pc], #-1380	; 37c <shift+0x37c>
     378:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     37c:	622f7372 	eorvs	r7, pc, #-939524095	; 0xc8000001
     380:	67646972 			; <UNDEFINED> instruction: 0x67646972
     384:	00007365 	andeq	r7, r0, r5, ror #6
     388:	6e69616d 	powvsez	f6, f1, #5.0
     38c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     390:	00000100 	andeq	r0, r0, r0, lsl #2
     394:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     398:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     39c:	00000200 	andeq	r0, r0, r0, lsl #4
     3a0:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     3a4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     3a8:	00682e67 	rsbeq	r2, r8, r7, ror #28
     3ac:	73000003 	movwvc	r0, #3
     3b0:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
     3b4:	00000400 	andeq	r0, r0, r0, lsl #8
     3b8:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     3bc:	6b636f6c 	blvs	18dc174 <__bss_end+0x18d2274>
     3c0:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     3c4:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     3c8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     3cc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     3d0:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
     3d4:	72700000 	rsbsvc	r0, r0, #0
     3d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3dc:	00682e73 	rsbeq	r2, r8, r3, ror lr
     3e0:	70000004 	andvc	r0, r0, r4
     3e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3e8:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 224 <shift+0x224>
     3ec:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     3f0:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     3f4:	00000400 	andeq	r0, r0, r0, lsl #8
     3f8:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     3fc:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
     400:	00682e73 	rsbeq	r2, r8, r3, ror lr
     404:	00000006 	andeq	r0, r0, r6
     408:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     40c:	00822c02 	addeq	r2, r2, r2, lsl #24
     410:	010f0300 	mrseq	r0, SP_hyp
     414:	059f1c05 	ldreq	r1, [pc, #3077]	; 1021 <shift+0x1021>
     418:	01056607 	tsteq	r5, r7, lsl #12
     41c:	0d056983 	vstreq.16	s12, [r5, #-262]	; 0xfffffefa	; <UNPREDICTABLE>
     420:	9f0105bb 	svcls	0x000105bb
     424:	84130569 	ldrhi	r0, [r3], #-1385	; 0xfffffa97
     428:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
     42c:	01054b07 	tsteq	r5, r7, lsl #22
     430:	1b05859f 	blne	161ab4 <__bss_end+0x157bb4>
     434:	0b05839f 	bleq	1612b8 <__bss_end+0x1573b8>
     438:	4b070584 	blmi	1c1a50 <__bss_end+0x1b7b50>
     43c:	0805bb6a 	stmdaeq	r5, {r1, r3, r5, r6, r8, r9, fp, ip, sp, pc}
     440:	4c0705bc 	cfstr32mi	mvfx0, [r7], {188}	; 0xbc
     444:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
     448:	bb67bb07 	bllt	19ef06c <__bss_end+0x19e516c>
     44c:	0a031505 	beq	c5868 <__bss_end+0xbb968>
     450:	f4030566 	vst3.16	{d0,d2,d4}, [r3 :128], r6
     454:	05681805 	strbeq	r1, [r8, #-2053]!	; 0xfffff7fb
     458:	24054b04 	strcs	r4, [r5], #-2820	; 0xfffff4fc
     45c:	01040200 	mrseq	r0, R12_usr
     460:	d8080566 	stmdale	r8, {r1, r2, r5, r6, r8, sl}
     464:	67d70905 	ldrbvs	r0, [r7, r5, lsl #18]
     468:	bb67bb67 	bllt	19ef20c <__bss_end+0x19e530c>
     46c:	05681205 	strbeq	r1, [r8, #-517]!	; 0xfffffdfb
     470:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     474:	28054a03 	stmdacs	r5, {r0, r1, r9, fp, lr}
     478:	02040200 	andeq	r0, r4, #0, 4
     47c:	00090584 	andeq	r0, r9, r4, lsl #11
     480:	ba020402 	blt	81490 <__bss_end+0x77590>
     484:	02040200 	andeq	r0, r4, #0, 4
     488:	000a052f 	andeq	r0, sl, pc, lsr #10
     48c:	d7020402 	strle	r0, [r2, -r2, lsl #8]
     490:	02040200 	andeq	r0, r4, #0, 4
     494:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
     498:	0405bb02 	streq	fp, [r5], #-2818	; 0xfffff4fe
     49c:	02040200 	andeq	r0, r4, #0, 4
     4a0:	05667a03 	strbeq	r7, [r6, #-2563]!	; 0xfffff5fd
     4a4:	820b0324 	andhi	r0, fp, #36, 6	; 0x90000000
     4a8:	059f0805 	ldreq	r0, [pc, #2053]	; cb5 <shift+0xcb5>
     4ac:	bb67bb09 	bllt	19ef0d8 <__bss_end+0x19e51d8>
     4b0:	67080568 	strvs	r0, [r8, -r8, ror #10]
     4b4:	05830905 	streq	r0, [r3, #2309]	; 0x905
     4b8:	24026802 	strcs	r6, [r2], #-2050	; 0xfffff7fe
     4bc:	bf010100 	svclt	0x00010100
     4c0:	03000002 	movweq	r0, #2
     4c4:	00018c00 	andeq	r8, r1, r0, lsl #24
     4c8:	fb010200 	blx	40cd2 <__bss_end+0x36dd2>
     4cc:	01000d0e 	tsteq	r0, lr, lsl #26
     4d0:	00010101 	andeq	r0, r1, r1, lsl #2
     4d4:	00010000 	andeq	r0, r1, r0
     4d8:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     4dc:	2f656d6f 	svccs	0x00656d6f
     4e0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     4e4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     4e8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     4ec:	2f736f2f 	svccs	0x00736f2f
     4f0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     4f4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     4f8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     4fc:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     500:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
     504:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
     508:	2f656d6f 	svccs	0x00656d6f
     50c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     510:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     514:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     518:	2f736f2f 	svccs	0x00736f2f
     51c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     520:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     524:	6b2f7365 	blvs	bdd2c0 <__bss_end+0xbd33c0>
     528:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     52c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     530:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     534:	6f622f65 	svcvs	0x00622f65
     538:	2f647261 	svccs	0x00647261
     53c:	30697072 	rsbcc	r7, r9, r2, ror r0
     540:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
     544:	6f682f00 	svcvs	0x00682f00
     548:	6a2f656d 	bvs	bd9b04 <__bss_end+0xbcfc04>
     54c:	73656d61 	cmnvc	r5, #6208	; 0x1840
     550:	2f697261 	svccs	0x00697261
     554:	2f746967 	svccs	0x00746967
     558:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     55c:	6f732f70 	svcvs	0x00732f70
     560:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     564:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     568:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     56c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     570:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     574:	6f72702f 	svcvs	0x0072702f
     578:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     57c:	6f682f00 	svcvs	0x00682f00
     580:	6a2f656d 	bvs	bd9b3c <__bss_end+0xbcfc3c>
     584:	73656d61 	cmnvc	r5, #6208	; 0x1840
     588:	2f697261 	svccs	0x00697261
     58c:	2f746967 	svccs	0x00746967
     590:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     594:	6f732f70 	svcvs	0x00732f70
     598:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     59c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     5a0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     5a4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     5a8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     5ac:	0073662f 	rsbseq	r6, r3, pc, lsr #12
     5b0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4fc <shift+0x4fc>
     5b4:	616a2f65 	cmnvs	sl, r5, ror #30
     5b8:	6173656d 	cmnvs	r3, sp, ror #10
     5bc:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     5c0:	6f2f7469 	svcvs	0x002f7469
     5c4:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     5c8:	756f732f 	strbvc	r7, [pc, #-815]!	; 2a1 <shift+0x2a1>
     5cc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     5d0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     5d4:	2f62696c 	svccs	0x0062696c
     5d8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     5dc:	00656475 	rsbeq	r6, r5, r5, ror r4
     5e0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     5e4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     5e8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     5ec:	00000100 	andeq	r0, r0, r0, lsl #2
     5f0:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     5f4:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     5f8:	00000200 	andeq	r0, r0, r0, lsl #4
     5fc:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     600:	00030068 	andeq	r0, r3, r8, rrx
     604:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     608:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     60c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     610:	66000003 	strvs	r0, [r0], -r3
     614:	73656c69 	cmnvc	r5, #26880	; 0x6900
     618:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     61c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     620:	70000004 	andvc	r0, r0, r4
     624:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     628:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     62c:	00000300 	andeq	r0, r0, r0, lsl #6
     630:	636f7270 	cmnvs	pc, #112, 4
     634:	5f737365 	svcpl	0x00737365
     638:	616e616d 	cmnvs	lr, sp, ror #2
     63c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     640:	00030068 	andeq	r0, r3, r8, rrx
     644:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     648:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     64c:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     650:	00000500 	andeq	r0, r0, r0, lsl #10
     654:	00010500 	andeq	r0, r1, r0, lsl #10
     658:	85f80205 	ldrbhi	r0, [r8, #517]!	; 0x205
     65c:	05160000 	ldreq	r0, [r6, #-0]
     660:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
     664:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     668:	852f0105 	strhi	r0, [pc, #-261]!	; 56b <shift+0x56b>
     66c:	05833205 	streq	r3, [r3, #517]	; 0x205
     670:	01054b1a 	tsteq	r5, sl, lsl fp
     674:	1a05852f 	bne	161b38 <__bss_end+0x157c38>
     678:	2f01054b 	svccs	0x0001054b
     67c:	a1320585 	teqge	r2, r5, lsl #11
     680:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     684:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
     688:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     68c:	852f0105 	strhi	r0, [pc, #-261]!	; 58f <shift+0x58f>
     690:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     694:	2e054b30 	vmovcs.16	d5[0], r4
     698:	4b1b054b 	blmi	6c1bcc <__bss_end+0x6b7ccc>
     69c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff89f <__bss_end+0xffff599f>
     6a0:	01054c0c 	tsteq	r5, ip, lsl #24
     6a4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     6a8:	4b3005bd 	blmi	c01da4 <__bss_end+0xbf7ea4>
     6ac:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     6b0:	2e054b1b 	vmovcs.32	d5[0], r4
     6b4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6b8:	852f0105 	strhi	r0, [pc, #-261]!	; 5bb <shift+0x5bb>
     6bc:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
     6c0:	01054b1b 	tsteq	r5, fp, lsl fp
     6c4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     6c8:	4b3305bd 	blmi	cc1dc4 <__bss_end+0xcb7ec4>
     6cc:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     6d0:	30054b1b 	andcc	r4, r5, fp, lsl fp
     6d4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     6d8:	852f0105 	strhi	r0, [pc, #-261]!	; 5db <shift+0x5db>
     6dc:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
     6e0:	1b054b2f 	blne	1533a4 <__bss_end+0x1494a4>
     6e4:	2f2f054b 	svccs	0x002f054b
     6e8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     6ec:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     6f0:	2f05bd2e 	svccs	0x0005bd2e
     6f4:	4b3b054b 	blmi	ec1c28 <__bss_end+0xeb7d28>
     6f8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     6fc:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     700:	2f01054c 	svccs	0x0001054c
     704:	a12f0585 	smlawbge	pc, r5, r5, r0	; <UNPREDICTABLE>
     708:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
     70c:	30054b1a 	andcc	r4, r5, sl, lsl fp
     710:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     714:	859f0105 	ldrhi	r0, [pc, #261]	; 821 <shift+0x821>
     718:	05672005 	strbeq	r2, [r7, #-5]!
     71c:	31054d2d 	tstcc	r5, sp, lsr #26
     720:	4b1a054b 	blmi	681c54 <__bss_end+0x677d54>
     724:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     728:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     72c:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
     730:	4b31054d 	blmi	c41c6c <__bss_end+0xc37d6c>
     734:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     738:	0105300c 	tsteq	r5, ip
     73c:	2005852f 	andcs	r8, r5, pc, lsr #10
     740:	4c2d0583 	cfstr32mi	mvfx0, [sp], #-524	; 0xfffffdf4
     744:	054b3e05 	strbeq	r3, [fp, #-3589]	; 0xfffff1fb
     748:	01054b1a 	tsteq	r5, sl, lsl fp
     74c:	2005852f 	andcs	r8, r5, pc, lsr #10
     750:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
     754:	054b3005 	strbeq	r3, [fp, #-5]
     758:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
     75c:	2f010530 	svccs	0x00010530
     760:	a00c0587 	andge	r0, ip, r7, lsl #11
     764:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
     768:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
     76c:	0f052e36 	svceq	0x00052e36
     770:	66130530 			; <UNDEFINED> instruction: 0x66130530
     774:	05840905 	streq	r0, [r4, #2309]	; 0x905
     778:	0105d810 	tsteq	r5, r0, lsl r8
     77c:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
     780:	01a20101 			; <UNDEFINED> instruction: 0x01a20101
     784:	00030000 	andeq	r0, r3, r0
     788:	0000014f 	andeq	r0, r0, pc, asr #2
     78c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     790:	0101000d 	tsteq	r1, sp
     794:	00000101 	andeq	r0, r0, r1, lsl #2
     798:	00000100 	andeq	r0, r0, r0, lsl #2
     79c:	6f682f01 	svcvs	0x00682f01
     7a0:	6a2f656d 	bvs	bd9d5c <__bss_end+0xbcfe5c>
     7a4:	73656d61 	cmnvc	r5, #6208	; 0x1840
     7a8:	2f697261 	svccs	0x00697261
     7ac:	2f746967 	svccs	0x00746967
     7b0:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     7b4:	6f732f70 	svcvs	0x00732f70
     7b8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     7bc:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     7c0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     7c4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     7c8:	6f682f00 	svcvs	0x00682f00
     7cc:	6a2f656d 	bvs	bd9d88 <__bss_end+0xbcfe88>
     7d0:	73656d61 	cmnvc	r5, #6208	; 0x1840
     7d4:	2f697261 	svccs	0x00697261
     7d8:	2f746967 	svccs	0x00746967
     7dc:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
     7e0:	6f732f70 	svcvs	0x00732f70
     7e4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     7e8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     7ec:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     7f0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     7f4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     7f8:	616f622f 	cmnvs	pc, pc, lsr #4
     7fc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     800:	2f306970 	svccs	0x00306970
     804:	006c6168 	rsbeq	r6, ip, r8, ror #2
     808:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 754 <shift+0x754>
     80c:	616a2f65 	cmnvs	sl, r5, ror #30
     810:	6173656d 	cmnvs	r3, sp, ror #10
     814:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     818:	6f2f7469 	svcvs	0x002f7469
     81c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     820:	756f732f 	strbvc	r7, [pc, #-815]!	; 4f9 <shift+0x4f9>
     824:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     828:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     82c:	2f6c656e 	svccs	0x006c656e
     830:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     834:	2f656475 	svccs	0x00656475
     838:	636f7270 	cmnvs	pc, #112, 4
     83c:	00737365 	rsbseq	r7, r3, r5, ror #6
     840:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 78c <shift+0x78c>
     844:	616a2f65 	cmnvs	sl, r5, ror #30
     848:	6173656d 	cmnvs	r3, sp, ror #10
     84c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     850:	6f2f7469 	svcvs	0x002f7469
     854:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     858:	756f732f 	strbvc	r7, [pc, #-815]!	; 531 <shift+0x531>
     85c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     860:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     864:	2f6c656e 	svccs	0x006c656e
     868:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     86c:	2f656475 	svccs	0x00656475
     870:	00007366 	andeq	r7, r0, r6, ror #6
     874:	72647473 	rsbvc	r7, r4, #1929379840	; 0x73000000
     878:	6f646e61 	svcvs	0x00646e61
     87c:	70632e6d 	rsbvc	r2, r3, sp, ror #28
     880:	00010070 	andeq	r0, r1, r0, ror r0
     884:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     888:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     88c:	00020068 	andeq	r0, r2, r8, rrx
     890:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     894:	0300682e 	movweq	r6, #2094	; 0x82e
     898:	70730000 	rsbsvc	r0, r3, r0
     89c:	6f6c6e69 	svcvs	0x006c6e69
     8a0:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     8a4:	00000300 	andeq	r0, r0, r0, lsl #6
     8a8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     8ac:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     8b0:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     8b4:	00000400 	andeq	r0, r0, r0, lsl #8
     8b8:	636f7270 	cmnvs	pc, #112, 4
     8bc:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     8c0:	00030068 	andeq	r0, r3, r8, rrx
     8c4:	6f727000 	svcvs	0x00727000
     8c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8cc:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     8d0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8d4:	0300682e 	movweq	r6, #2094	; 0x82e
     8d8:	05000000 	streq	r0, [r0, #-0]
     8dc:	02050001 	andeq	r0, r5, #1
     8e0:	00008a54 	andeq	r8, r0, r4, asr sl
     8e4:	830b0515 	movwhi	r0, #46357	; 0xb515
     8e8:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     8ec:	01059f09 	tsteq	r5, r9, lsl #30
     8f0:	0b056a2f 	bleq	15b1b4 <__bss_end+0x1512b4>
     8f4:	4b0605bb 	blmi	181fe8 <__bss_end+0x1780e8>
     8f8:	059f2c05 	ldreq	r2, [pc, #3077]	; 1505 <shift+0x1505>
     8fc:	2c052e33 	stccs	14, cr2, [r5], {51}	; 0x33
     900:	820b0566 	andhi	r0, fp, #427819008	; 0x19800000
     904:	05670905 	strbeq	r0, [r7, #-2309]!	; 0xfffff6fb
     908:	056a2f01 	strbeq	r2, [sl, #-3841]!	; 0xfffff0ff
     90c:	1f05bb2c 	svcne	0x0005bb2c
     910:	660b0569 	strvs	r0, [fp], -r9, ror #10
     914:	05692805 	strbeq	r2, [r9, #-2053]!	; 0xfffff7fb
     918:	0b05662f 	bleq	15a1dc <__bss_end+0x1502dc>
     91c:	6809054a 	stmdavs	r9, {r1, r3, r6, r8, sl}
     920:	024b0105 	subeq	r0, fp, #1073741825	; 0x40000001
     924:	01010008 	tsteq	r1, r8
     928:	0000063e 	andeq	r0, r0, lr, lsr r6
     92c:	008f0003 	addeq	r0, pc, r3
     930:	01020000 	mrseq	r0, (UNDEF: 2)
     934:	000d0efb 	strdeq	r0, [sp], -fp
     938:	01010101 	tsteq	r1, r1, lsl #2
     93c:	01000000 	mrseq	r0, (UNDEF: 0)
     940:	2f010000 	svccs	0x00010000
     944:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     948:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     94c:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     950:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     954:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     958:	2f70732f 	svccs	0x0070732f
     95c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     960:	2f736563 	svccs	0x00736563
     964:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     968:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     96c:	2f006372 	svccs	0x00006372
     970:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     974:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     978:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     97c:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     980:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     984:	2f70732f 	svccs	0x0070732f
     988:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     98c:	2f736563 	svccs	0x00736563
     990:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     994:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
     998:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     99c:	00006564 	andeq	r6, r0, r4, ror #10
     9a0:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
     9a4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     9a8:	70632e67 	rsbvc	r2, r3, r7, ror #28
     9ac:	00010070 	andeq	r0, r1, r0, ror r0
     9b0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     9b4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     9b8:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     9bc:	00000200 	andeq	r0, r0, r0, lsl #4
     9c0:	00010500 	andeq	r0, r1, r0, lsl #10
     9c4:	8b740205 	blhi	1d011e0 <__bss_end+0x1cf72e0>
     9c8:	051a0000 	ldreq	r0, [sl, #-0]
     9cc:	0f05bb06 	svceq	0x0005bb06
     9d0:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
     9d4:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
     9d8:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
     9dc:	4a0d054a 	bmi	341f0c <__bss_end+0x33800c>
     9e0:	052f0905 	streq	r0, [pc, #-2309]!	; e3 <shift+0xe3>
     9e4:	02059f04 	andeq	r9, r5, #4, 30
     9e8:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
     9ec:	05681005 	strbeq	r1, [r8, #-5]!
     9f0:	22052e11 	andcs	r2, r5, #272	; 0x110
     9f4:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
     9f8:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffffb <__bss_end+0xffff60fb>
     9fc:	0a056909 	beq	15ae28 <__bss_end+0x150f28>
     a00:	4a0c052e 	bmi	301ec0 <__bss_end+0x2f7fc0>
     a04:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
     a08:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
     a0c:	03040200 	movweq	r0, #16896	; 0x4200
     a10:	0014054a 	andseq	r0, r4, sl, asr #10
     a14:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
     a18:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     a1c:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     a20:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     a24:	08058202 	stmdaeq	r5, {r1, r9, pc}
     a28:	02040200 	andeq	r0, r4, #0, 4
     a2c:	001a054a 	andseq	r0, sl, sl, asr #10
     a30:	4b020402 	blmi	81a40 <__bss_end+0x77b40>
     a34:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     a38:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a3c:	0402000c 	streq	r0, [r2], #-12
     a40:	0f054a02 	svceq	0x00054a02
     a44:	02040200 	andeq	r0, r4, #0, 4
     a48:	001b0582 	andseq	r0, fp, r2, lsl #11
     a4c:	4a020402 	bmi	81a5c <__bss_end+0x77b5c>
     a50:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     a54:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     a58:	0402000a 	streq	r0, [r2], #-10
     a5c:	0b052f02 	bleq	14c66c <__bss_end+0x14276c>
     a60:	02040200 	andeq	r0, r4, #0, 4
     a64:	000d052e 	andeq	r0, sp, lr, lsr #10
     a68:	4a020402 	bmi	81a78 <__bss_end+0x77b78>
     a6c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     a70:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
     a74:	05858801 	streq	r8, [r5, #2049]	; 0x801
     a78:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
     a7c:	4a10054c 	bmi	401fb4 <__bss_end+0x3f80b4>
     a80:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
     a84:	0305bb07 	movweq	fp, #23303	; 0x5b07
     a88:	0017054a 	andseq	r0, r7, sl, asr #10
     a8c:	4a010402 	bmi	41a9c <__bss_end+0x37b9c>
     a90:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     a94:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     a98:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
     a9c:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
     aa0:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
     aa4:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
     aa8:	0b030905 	bleq	c2ec4 <__bss_end+0xb8fc4>
     aac:	2f01052e 	svccs	0x0001052e
     ab0:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
     ab4:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     ab8:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
     abc:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
     ac0:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
     ac4:	02040200 	andeq	r0, r4, #0, 4
     ac8:	0016052e 	andseq	r0, r6, lr, lsr #10
     acc:	66020402 	strvs	r0, [r2], -r2, lsl #8
     ad0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     ad4:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
     ad8:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     adc:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
     ae0:	03040200 	movweq	r0, #16896	; 0x4200
     ae4:	0009054a 	andeq	r0, r9, sl, asr #10
     ae8:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     aec:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     af0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     af4:	0402000b 	streq	r0, [r2], #-11
     af8:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
     afc:	03040200 	movweq	r0, #16896	; 0x4200
     b00:	000b052d 	andeq	r0, fp, sp, lsr #10
     b04:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
     b08:	02000805 	andeq	r0, r0, #327680	; 0x50000
     b0c:	05830104 	streq	r0, [r3, #260]	; 0x104
     b10:	04020009 	streq	r0, [r2], #-9
     b14:	0b052e01 	bleq	14c320 <__bss_end+0x142420>
     b18:	01040200 	mrseq	r0, R12_usr
     b1c:	0002054a 	andeq	r0, r2, sl, asr #10
     b20:	49010402 	stmdbmi	r1, {r1, sl}
     b24:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
     b28:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     b2c:	1105bc0e 	tstne	r5, lr, lsl #24
     b30:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
     b34:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
     b38:	0a054b1f 	beq	1537bc <__bss_end+0x1498bc>
     b3c:	4b080566 	blmi	2020dc <__bss_end+0x1f81dc>
     b40:	05831105 	streq	r1, [r3, #261]	; 0x105
     b44:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
     b48:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
     b4c:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
     b50:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     b54:	0b058306 	bleq	161774 <__bss_end+0x157874>
     b58:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
     b5c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     b60:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
     b64:	31090565 	tstcc	r9, r5, ror #10
     b68:	852f0105 	strhi	r0, [pc, #-261]!	; a6b <shift+0xa6b>
     b6c:	059f0805 	ldreq	r0, [pc, #2053]	; 1379 <shift+0x1379>
     b70:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
     b74:	03040200 	movweq	r0, #16896	; 0x4200
     b78:	0007054a 	andeq	r0, r7, sl, asr #10
     b7c:	83020402 	movwhi	r0, #9218	; 0x2402
     b80:	02000805 	andeq	r0, r0, #327680	; 0x50000
     b84:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     b88:	0402000a 	streq	r0, [r2], #-10
     b8c:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     b90:	02040200 	andeq	r0, r4, #0, 4
     b94:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
     b98:	bb0e0585 	bllt	3821b4 <__bss_end+0x3782b4>
     b9c:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
     ba0:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
     ba4:	03040200 	movweq	r0, #16896	; 0x4200
     ba8:	0016054a 	andseq	r0, r6, sl, asr #10
     bac:	83020402 	movwhi	r0, #9218	; 0x2402
     bb0:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     bb4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     bb8:	0402000a 	streq	r0, [r2], #-10
     bbc:	0b054a02 	bleq	1533cc <__bss_end+0x1494cc>
     bc0:	02040200 	andeq	r0, r4, #0, 4
     bc4:	0017052e 	andseq	r0, r7, lr, lsr #10
     bc8:	4a020402 	bmi	81bd8 <__bss_end+0x77cd8>
     bcc:	02000d05 	andeq	r0, r0, #320	; 0x140
     bd0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     bd4:	04020002 	streq	r0, [r2], #-2
     bd8:	01052d02 	tsteq	r5, r2, lsl #26
     bdc:	0b058584 	bleq	1621f4 <__bss_end+0x1582f4>
     be0:	4b16059f 	blmi	582264 <__bss_end+0x578364>
     be4:	02001c05 	andeq	r1, r0, #1280	; 0x500
     be8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     bec:	0402000b 	streq	r0, [r2], #-11
     bf0:	05058302 	streq	r8, [r5, #-770]	; 0xfffffcfe
     bf4:	02040200 	andeq	r0, r4, #0, 4
     bf8:	850c0581 	strhi	r0, [ip, #-1409]	; 0xfffffa7f
     bfc:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     c00:	05841105 	streq	r1, [r4, #261]	; 0x105
     c04:	1805680c 	stmdane	r5, {r2, r3, fp, sp, lr}
     c08:	03040200 	movweq	r0, #16896	; 0x4200
     c0c:	0013054a 	andseq	r0, r3, sl, asr #10
     c10:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
     c14:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     c18:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     c1c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     c20:	0e052e02 	cdpeq	14, 0, cr2, cr5, cr2, {0}
     c24:	02040200 	andeq	r0, r4, #0, 4
     c28:	001c0566 	andseq	r0, ip, r6, ror #10
     c2c:	2f020402 	svccs	0x00020402
     c30:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     c34:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     c38:	0402000e 	streq	r0, [r2], #-14
     c3c:	0f056602 	svceq	0x00056602
     c40:	02040200 	andeq	r0, r4, #0, 4
     c44:	0023052e 	eoreq	r0, r3, lr, lsr #10
     c48:	4a020402 	bmi	81c58 <__bss_end+0x77d58>
     c4c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     c50:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     c54:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     c58:	19052f02 	stmdbne	r5, {r1, r8, r9, sl, fp, sp}
     c5c:	02040200 	andeq	r0, r4, #0, 4
     c60:	001b0566 	andseq	r0, fp, r6, ror #10
     c64:	66020402 	strvs	r0, [r2], -r2, lsl #8
     c68:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     c6c:	05620204 	strbeq	r0, [r2, #-516]!	; 0xfffffdfc
     c70:	05698801 	strbeq	r8, [r9, #-2049]!	; 0xfffff7ff
     c74:	0905d705 	stmdbeq	r5, {r0, r2, r8, r9, sl, ip, lr, pc}
     c78:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     c7c:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     c80:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     c84:	05820104 	streq	r0, [r2, #260]	; 0x104
     c88:	1a059f09 	bne	1688b4 <__bss_end+0x15e9b4>
     c8c:	01040200 	mrseq	r0, R12_usr
     c90:	002e059e 	mlaeq	lr, lr, r5, r0
     c94:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     c98:	059f0905 	ldreq	r0, [pc, #2309]	; 15a5 <shift+0x15a5>
     c9c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     ca0:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     ca4:	01040200 	mrseq	r0, R12_usr
     ca8:	9f090582 	svcls	0x00090582
     cac:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     cb0:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     cb4:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     cb8:	09058201 	stmdbeq	r5, {r0, r9, pc}
     cbc:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     cc0:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     cc4:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     cc8:	05820104 	streq	r0, [r2, #260]	; 0x104
     ccc:	1a059f09 	bne	1688f8 <__bss_end+0x15e9f8>
     cd0:	01040200 	mrseq	r0, R12_usr
     cd4:	002e059e 	mlaeq	lr, lr, r5, r0
     cd8:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     cdc:	05a00505 	streq	r0, [r0, #1285]!	; 0x505
     ce0:	0402000f 	streq	r0, [r2], #-15
     ce4:	09058201 	stmdbeq	r5, {r0, r9, pc}
     ce8:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     cec:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     cf0:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     cf4:	05820104 	streq	r0, [r2, #260]	; 0x104
     cf8:	1a059f09 	bne	168924 <__bss_end+0x15ea24>
     cfc:	01040200 	mrseq	r0, R12_usr
     d00:	002e059e 	mlaeq	lr, lr, r5, r0
     d04:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     d08:	059f0905 	ldreq	r0, [pc, #2309]	; 1615 <shift+0x1615>
     d0c:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     d10:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
     d14:	01040200 	mrseq	r0, R12_usr
     d18:	9f090582 	svcls	0x00090582
     d1c:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     d20:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     d24:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
     d28:	09058201 	stmdbeq	r5, {r0, r9, pc}
     d2c:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
     d30:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
     d34:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
     d38:	05820104 	streq	r0, [r2, #260]	; 0x104
     d3c:	1a059f09 	bne	168968 <__bss_end+0x15ea68>
     d40:	01040200 	mrseq	r0, R12_usr
     d44:	002e059e 	mlaeq	lr, lr, r5, r0
     d48:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     d4c:	05a01005 	streq	r1, [r0, #5]!
     d50:	1a05660e 	bne	15a590 <__bss_end+0x150690>
     d54:	4a19054b 	bmi	642288 <__bss_end+0x638388>
     d58:	05820b05 	streq	r0, [r2, #2821]	; 0xb05
     d5c:	0d05670f 	stceq	7, cr6, [r5, #-60]	; 0xffffffc4
     d60:	4b190566 	blmi	642300 <__bss_end+0x638400>
     d64:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     d68:	05054a11 	streq	r4, [r5, #-2577]	; 0xfffff5ef
     d6c:	0301054a 	movweq	r0, #5450	; 0x154a
     d70:	0905820b 	stmdbeq	r5, {r0, r1, r3, r9, pc}
     d74:	052e7603 	streq	r7, [lr, #-1539]!	; 0xfffff9fd
     d78:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     d7c:	4a090567 	bmi	242320 <__bss_end+0x238420>
     d80:	05671505 	strbeq	r1, [r7, #-1285]!	; 0xfffffafb
     d84:	1505670d 	strne	r6, [r5, #-1805]	; 0xfffff8f3
     d88:	6710054a 	ldrvs	r0, [r0, -sl, asr #10]
     d8c:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
     d90:	11054b1a 	tstne	r5, sl, lsl fp
     d94:	4a190567 	bmi	642338 <__bss_end+0x638438>
     d98:	026a0105 	rsbeq	r0, sl, #1073741825	; 0x40000001
     d9c:	0605152e 	streq	r1, [r5], -lr, lsr #10
     da0:	4b1205bb 	blmi	482494 <__bss_end+0x478594>
     da4:	05661505 	strbeq	r1, [r6, #-1285]!	; 0xfffffafb
     da8:	2305bb20 	movwcs	fp, #23328	; 0x5b20
     dac:	12052008 	andne	r2, r5, #8
     db0:	8214052e 	andshi	r0, r4, #192937984	; 0xb800000
     db4:	054a2305 	strbeq	r2, [sl, #-773]	; 0xfffffcfb
     db8:	0b054a16 	bleq	153618 <__bss_end+0x149718>
     dbc:	9c05052f 	cfstr32ls	mvfx0, [r5], {47}	; 0x2f
     dc0:	05320605 	ldreq	r0, [r2, #-1541]!	; 0xfffff9fb
     dc4:	0d052e0b 	stceq	14, cr2, [r5, #-44]	; 0xffffffd4
     dc8:	4b08054a 	blmi	2022f8 <__bss_end+0x1f83f8>
     dcc:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     dd0:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
     dd4:	0585d701 	streq	sp, [r5, #1793]	; 0x701
     dd8:	0105830d 	tsteq	r5, sp, lsl #6
     ddc:	0605a2d7 			; <UNDEFINED> instruction: 0x0605a2d7
     de0:	8301059f 	movwhi	r0, #5535	; 0x159f
     de4:	bb0f056a 	bllt	3c2394 <__bss_end+0x3b8494>
     de8:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
     dec:	0e05840c 	cdpeq	4, 0, cr8, cr5, cr12, {0}
     df0:	4a100566 	bmi	402390 <__bss_end+0x3f8490>
     df4:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
     df8:	0505680d 	streq	r6, [r5, #-2061]	; 0xfffff7f3
     dfc:	4c0c0566 	cfstr32mi	mvfx0, [ip], {102}	; 0x66
     e00:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     e04:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
     e08:	660e054b 	strvs	r0, [lr], -fp, asr #10
     e0c:	054a1005 	strbeq	r1, [sl, #-5]
     e10:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     e14:	4a100566 	bmi	4023b4 <__bss_end+0x3f84b4>
     e18:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     e1c:	1005660e 	andne	r6, r5, lr, lsl #12
     e20:	4b03054a 	blmi	c2350 <__bss_end+0xb8450>
     e24:	05300d05 	ldreq	r0, [r0, #-3333]!	; 0xfffff2fb
     e28:	0c056605 	stceq	6, cr6, [r5], {5}
     e2c:	660e054c 	strvs	r0, [lr], -ip, asr #10
     e30:	054a1005 	strbeq	r1, [sl, #-5]
     e34:	0e054b0c 	vmlaeq.f64	d4, d5, d12
     e38:	4a100566 	bmi	4023d8 <__bss_end+0x3f84d8>
     e3c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     e40:	1005660e 	andne	r6, r5, lr, lsl #12
     e44:	4b0c054a 	blmi	302374 <__bss_end+0x2f8474>
     e48:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
     e4c:	03054a10 	movweq	r4, #23056	; 0x5a10
     e50:	3006054b 	andcc	r0, r6, fp, asr #10
     e54:	054b0205 	strbeq	r0, [fp, #-517]	; 0xfffffdfb
     e58:	1c05670d 	stcne	7, cr6, [r5], {13}
     e5c:	9f0e054c 	svcls	0x000e054c
     e60:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
     e64:	34056818 	strcc	r6, [r5], #-2072	; 0xfffff7e8
     e68:	66330583 	ldrtvs	r0, [r3], -r3, lsl #11
     e6c:	054a4405 	strbeq	r4, [sl, #-1029]	; 0xfffffbfb
     e70:	06054a18 			; <UNDEFINED> instruction: 0x06054a18
     e74:	9f1d0569 	svcls	0x001d0569
     e78:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
     e7c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     e80:	0c054a03 			; <UNDEFINED> instruction: 0x0c054a03
     e84:	02040200 	andeq	r0, r4, #0, 4
     e88:	000e0584 	andeq	r0, lr, r4, lsl #11
     e8c:	66020402 	strvs	r0, [r2], -r2, lsl #8
     e90:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     e94:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     e98:	04020010 	streq	r0, [r2], #-16
     e9c:	02058202 	andeq	r8, r5, #536870912	; 0x20000000
     ea0:	02040200 	andeq	r0, r4, #0, 4
     ea4:	0c05872c 	stceq	7, cr8, [r5], {44}	; 0x2c
     ea8:	660e0568 	strvs	r0, [lr], -r8, ror #10
     eac:	054a1005 	strbeq	r1, [sl, #-5]
     eb0:	0c054c1a 	stceq	12, cr4, [r5], {26}
     eb4:	001505a0 	andseq	r0, r5, r0, lsr #11
     eb8:	4a010402 	bmi	41ec8 <__bss_end+0x37fc8>
     ebc:	05681905 	strbeq	r1, [r8, #-2309]!	; 0xfffff6fb
     ec0:	0d058204 	sfmeq	f0, 1, [r5, #-16]
     ec4:	02040200 	andeq	r0, r4, #0, 4
     ec8:	000f054c 	andeq	r0, pc, ip, asr #10
     ecc:	66020402 	strvs	r0, [r2], -r2, lsl #8
     ed0:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     ed4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     ed8:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     edc:	03058202 	movweq	r8, #20994	; 0x5202
     ee0:	02040200 	andeq	r0, r4, #0, 4
     ee4:	8505052a 	strhi	r0, [r5, #-1322]	; 0xfffffad6
     ee8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     eec:	05320204 	ldreq	r0, [r2, #-516]!	; 0xfffffdfc
     ef0:	0402000d 	streq	r0, [r2], #-13
     ef4:	01056602 	tsteq	r5, r2, lsl #12
     ef8:	0905854b 	stmdbeq	r5, {r0, r1, r3, r6, r8, sl, pc}
     efc:	4a120583 	bmi	482510 <__bss_end+0x478610>
     f00:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     f04:	06054a03 	streq	r4, [r5], -r3, lsl #20
     f08:	670a054b 	strvs	r0, [sl, -fp, asr #10]
     f0c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     f10:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
     f14:	1d054a01 	vstrne	s8, [r5, #-4]
     f18:	01040200 	mrseq	r0, R12_usr
     f1c:	4b09054a 	blmi	24244c <__bss_end+0x23854c>
     f20:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     f24:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     f28:	07054b01 	streq	r4, [r5, -r1, lsl #22]
     f2c:	01040200 	mrseq	r0, R12_usr
     f30:	300d054b 	andcc	r0, sp, fp, asr #10
     f34:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     f38:	10054b05 	andne	r4, r5, r5, lsl #22
     f3c:	01040200 	mrseq	r0, R12_usr
     f40:	67070566 	strvs	r0, [r7, -r6, ror #10]
     f44:	02001c05 	andeq	r1, r0, #1280	; 0x500
     f48:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     f4c:	1b058311 	blne	161b98 <__bss_end+0x157c98>
     f50:	660b0566 	strvs	r0, [fp], -r6, ror #10
     f54:	02000305 	andeq	r0, r0, #335544320	; 0x14000000
     f58:	78030204 	stmdavc	r3, {r2, r9}
     f5c:	0310054a 	tsteq	r0, #310378496	; 0x12800000
     f60:	0105820b 	tsteq	r5, fp, lsl #4
     f64:	000c0267 	andeq	r0, ip, r7, ror #4
     f68:	00790101 	rsbseq	r0, r9, r1, lsl #2
     f6c:	00030000 	andeq	r0, r3, r0
     f70:	00000046 	andeq	r0, r0, r6, asr #32
     f74:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     f78:	0101000d 	tsteq	r1, sp
     f7c:	00000101 	andeq	r0, r0, r1, lsl #2
     f80:	00000100 	andeq	r0, r0, r0, lsl #2
     f84:	2f2e2e01 	svccs	0x002e2e01
     f88:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f90:	2f2e2e2f 	svccs	0x002e2e2f
     f94:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; ee4 <shift+0xee4>
     f98:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f9c:	6f632f63 	svcvs	0x00632f63
     fa0:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     fa4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     fa8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     fac:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
     fb0:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
     fb4:	00010053 	andeq	r0, r1, r3, asr r0
     fb8:	05000000 	streq	r0, [r0, #-0]
     fbc:	009b5002 	addseq	r5, fp, r2
     fc0:	08ca0300 	stmiaeq	sl, {r8, r9}^
     fc4:	2f2f3001 	svccs	0x002f3001
     fc8:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
     fcc:	1401d002 	strne	sp, [r1], #-2
     fd0:	2f2f312f 	svccs	0x002f312f
     fd4:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
     fd8:	2f661f03 	svccs	0x00661f03
     fdc:	2f2f2f2f 	svccs	0x002f2f2f
     fe0:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
     fe4:	5c010100 	stfpls	f0, [r1], {-0}
     fe8:	03000000 	movweq	r0, #0
     fec:	00004600 	andeq	r4, r0, r0, lsl #12
     ff0:	fb010200 	blx	417fa <__bss_end+0x378fa>
     ff4:	01000d0e 	tsteq	r0, lr, lsl #26
     ff8:	00010101 	andeq	r0, r1, r1, lsl #2
     ffc:	00010000 	andeq	r0, r1, r0
    1000:	2e2e0100 	sufcse	f0, f6, f0
    1004:	2f2e2e2f 	svccs	0x002e2e2f
    1008:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    100c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1010:	2f2e2e2f 	svccs	0x002e2e2f
    1014:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1018:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    101c:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1020:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1024:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1028:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    102c:	73636e75 	cmnvc	r3, #1872	; 0x750
    1030:	0100532e 	tsteq	r0, lr, lsr #6
    1034:	00000000 	andeq	r0, r0, r0
    1038:	9d5c0205 	lfmls	f0, 2, [ip, #-20]	; 0xffffffec
    103c:	b4030000 	strlt	r0, [r3], #-0
    1040:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
    1044:	03010100 	movweq	r0, #4352	; 0x1100
    1048:	03000001 	movweq	r0, #1
    104c:	0000fd00 	andeq	pc, r0, r0, lsl #26
    1050:	fb010200 	blx	4185a <__bss_end+0x3795a>
    1054:	01000d0e 	tsteq	r0, lr, lsl #26
    1058:	00010101 	andeq	r0, r1, r1, lsl #2
    105c:	00010000 	andeq	r0, r1, r0
    1060:	2e2e0100 	sufcse	f0, f6, f0
    1064:	2f2e2e2f 	svccs	0x002e2e2f
    1068:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    106c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1070:	2f2e2e2f 	svccs	0x002e2e2f
    1074:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1078:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    107c:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
    1080:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1084:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    1088:	2f2e2e2f 	svccs	0x002e2e2f
    108c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1090:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1094:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    1098:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    109c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10a0:	2f2e2e2f 	svccs	0x002e2e2f
    10a4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10a8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10ac:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    10b0:	2f636367 	svccs	0x00636367
    10b4:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
    10b8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    10bc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    10c0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    10c4:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
    10c8:	2f2e2e2f 	svccs	0x002e2e2f
    10cc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    10d0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    10d4:	2f2e2e2f 	svccs	0x002e2e2f
    10d8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10dc:	00006363 	andeq	r6, r0, r3, ror #6
    10e0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    10e4:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
    10e8:	00010068 	andeq	r0, r1, r8, rrx
    10ec:	6d726100 	ldfvse	f6, [r2, #-0]
    10f0:	6173692d 	cmnvs	r3, sp, lsr #18
    10f4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    10f8:	72610000 	rsbvc	r0, r1, #0
    10fc:	70632d6d 	rsbvc	r2, r3, sp, ror #26
    1100:	00682e75 	rsbeq	r2, r8, r5, ror lr
    1104:	69000002 	stmdbvs	r0, {r1}
    1108:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
    110c:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1110:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
    1114:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1118:	61000002 	tstvs	r0, r2
    111c:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1120:	00000300 	andeq	r0, r0, r0, lsl #6
    1124:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1128:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    112c:	00040068 	andeq	r0, r4, r8, rrx
    1130:	6c626700 	stclvs	7, cr6, [r2], #-0
    1134:	6f74632d 	svcvs	0x0074632d
    1138:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
    113c:	00000400 	andeq	r0, r0, r0, lsl #8
    1140:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1144:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1148:	00040063 	andeq	r0, r4, r3, rrx
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
      58:	04750704 	ldrbteq	r0, [r5], #-1796	; 0xfffff8fc
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
     128:	00000475 	andeq	r0, r0, r5, ror r4
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408280>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36294>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x479f58>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x36364>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f658c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000b0c 	andeq	r0, r0, ip, lsl #22
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000aaa04 	andeq	sl, sl, r4, lsl #20
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	0003cc00 	andeq	ip, r3, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	092e0200 	stmdbeq	lr!, {r9}
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	60030500 	andvs	r0, r3, r0, lsl #10
     308:	0300009d 	movweq	r0, #157	; 0x9d
     30c:	17b70404 	ldrne	r0, [r7, r4, lsl #8]!
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0a1d0801 	beq	742324 <__bss_end+0x738424>
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0a540502 	beq	1501734 <__bss_end+0x14f7834>
     328:	a2050000 	andge	r0, r5, #0
     32c:	0200000a 	andeq	r0, r0, #10
     330:	00670705 	rsbeq	r0, r7, r5, lsl #14
     334:	56040000 	strpl	r0, [r4], -r0
     338:	06000000 	streq	r0, [r0], -r0
     33c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     340:	08030074 	stmdaeq	r3, {r2, r4, r5, r6}
     344:	00031f05 	andeq	r1, r3, r5, lsl #30
     348:	08010300 	stmdaeq	r1, {r8, r9}
     34c:	00000a14 	andeq	r0, r0, r4, lsl sl
     350:	c2070203 	andgt	r0, r7, #805306368	; 0x30000000
     354:	05000007 	streq	r0, [r0, #-7]
     358:	00000aa1 	andeq	r0, r0, r1, lsr #21
     35c:	94070a02 	strls	r0, [r7], #-2562	; 0xfffff5fe
     360:	04000000 	streq	r0, [r0], #-0
     364:	00000083 	andeq	r0, r0, r3, lsl #1
     368:	75070403 	strvc	r0, [r7, #-1027]	; 0xfffffbfd
     36c:	03000004 	movweq	r0, #4
     370:	046b0708 	strbteq	r0, [fp], #-1800	; 0xfffff8f8
     374:	b8020000 	stmdalt	r2, {}	; <UNPREDICTABLE>
     378:	02000006 	andeq	r0, r0, #6
     37c:	0062130d 	rsbeq	r1, r2, sp, lsl #6
     380:	03050000 	movweq	r0, #20480	; 0x5000
     384:	00009d64 	andeq	r9, r0, r4, ror #26
     388:	00074302 	andeq	r4, r7, r2, lsl #6
     38c:	130e0200 	movwne	r0, #57856	; 0xe200
     390:	00000062 	andeq	r0, r0, r2, rrx
     394:	9d680305 	stclls	3, cr0, [r8, #-20]!	; 0xffffffec
     398:	b7020000 	strlt	r0, [r2, -r0]
     39c:	02000006 	andeq	r0, r0, #6
     3a0:	008f1410 	addeq	r1, pc, r0, lsl r4	; <UNPREDICTABLE>
     3a4:	03050000 	movweq	r0, #20480	; 0x5000
     3a8:	00009d6c 	andeq	r9, r0, ip, ror #26
     3ac:	00074202 	andeq	r4, r7, r2, lsl #4
     3b0:	14110200 	ldrne	r0, [r1], #-512	; 0xfffffe00
     3b4:	0000008f 	andeq	r0, r0, pc, lsl #1
     3b8:	9d700305 	ldclls	3, cr0, [r0, #-20]!	; 0xffffffec
     3bc:	4b070000 	blmi	1c03c4 <__bss_end+0x1b64c4>
     3c0:	08000006 	stmdaeq	r0, {r1, r2}
     3c4:	10080604 	andne	r0, r8, r4, lsl #12
     3c8:	08000001 	stmdaeq	r0, {r0}
     3cc:	04003072 	streq	r3, [r0], #-114	; 0xffffff8e
     3d0:	00830e08 	addeq	r0, r3, r8, lsl #28
     3d4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     3d8:	04003172 	streq	r3, [r0], #-370	; 0xfffffe8e
     3dc:	00830e09 	addeq	r0, r3, r9, lsl #28
     3e0:	00040000 	andeq	r0, r4, r0
     3e4:	00050409 	andeq	r0, r5, r9, lsl #8
     3e8:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     3ec:	04000000 	streq	r0, [r0], #-0
     3f0:	01470c1e 	cmpeq	r7, lr, lsl ip
     3f4:	930a0000 	movwls	r0, #40960	; 0xa000
     3f8:	0000000d 	andeq	r0, r0, sp
     3fc:	000dd10a 	andeq	sp, sp, sl, lsl #2
     400:	9b0a0100 	blls	280808 <__bss_end+0x276908>
     404:	0200000d 	andeq	r0, r0, #13
     408:	00082c0a 	andeq	r2, r8, sl, lsl #24
     40c:	8f0a0300 	svchi	0x000a0300
     410:	04000009 	streq	r0, [r0], #-9
     414:	0006800a 	andeq	r8, r6, sl
     418:	09000500 	stmdbeq	r0, {r8, sl}
     41c:	00000d08 	andeq	r0, r0, r8, lsl #26
     420:	00670405 	rsbeq	r0, r7, r5, lsl #8
     424:	44040000 	strmi	r0, [r4], #-0
     428:	0001840c 	andeq	r8, r1, ip, lsl #8
     42c:	03ba0a00 			; <UNDEFINED> instruction: 0x03ba0a00
     430:	0a000000 	beq	438 <shift+0x438>
     434:	00000519 	andeq	r0, r0, r9, lsl r5
     438:	09690a01 	stmdbeq	r9!, {r0, r9, fp}^
     43c:	0a020000 	beq	80444 <__bss_end+0x76544>
     440:	00000d63 	andeq	r0, r0, r3, ror #26
     444:	0ddb0a03 	vldreq	s1, [fp, #12]
     448:	0a040000 	beq	100450 <__bss_end+0xf6550>
     44c:	00000919 	andeq	r0, r0, r9, lsl r9
     450:	07e20a05 	strbeq	r0, [r2, r5, lsl #20]!
     454:	00060000 	andeq	r0, r6, r0
     458:	000cc209 	andeq	ip, ip, r9, lsl #4
     45c:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     460:	04000000 	streq	r0, [r0], #-0
     464:	01af0c6b 			; <UNDEFINED> instruction: 0x01af0c6b
     468:	f20a0000 	vhadd.s8	d0, d10, d0
     46c:	00000009 	andeq	r0, r0, r9
     470:	0007a40a 	andeq	sl, r7, sl, lsl #8
     474:	700a0100 	andvc	r0, sl, r0, lsl #2
     478:	0200000a 	andeq	r0, r0, #10
     47c:	0007e70a 	andeq	lr, r7, sl, lsl #14
     480:	02000300 	andeq	r0, r0, #0, 6
     484:	00000920 	andeq	r0, r0, r0, lsr #18
     488:	8f140505 	svchi	0x00140505
     48c:	05000000 	streq	r0, [r0, #-0]
     490:	009d7403 	addseq	r7, sp, r3, lsl #8
     494:	09450200 	stmdbeq	r5, {r9}^
     498:	06050000 	streq	r0, [r5], -r0
     49c:	00008f14 	andeq	r8, r0, r4, lsl pc
     4a0:	78030500 	stmdavc	r3, {r8, sl}
     4a4:	0200009d 	andeq	r0, r0, #157	; 0x9d
     4a8:	00000903 	andeq	r0, r0, r3, lsl #18
     4ac:	8f1a0706 	svchi	0x001a0706
     4b0:	05000000 	streq	r0, [r0, #-0]
     4b4:	009d7c03 	addseq	r7, sp, r3, lsl #24
     4b8:	05490200 	strbeq	r0, [r9, #-512]	; 0xfffffe00
     4bc:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     4c0:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4c4:	80030500 	andhi	r0, r3, r0, lsl #10
     4c8:	0200009d 	andeq	r0, r0, #157	; 0x9d
     4cc:	00000a06 	andeq	r0, r0, r6, lsl #20
     4d0:	8f1a0b06 	svchi	0x001a0b06
     4d4:	05000000 	streq	r0, [r0, #-0]
     4d8:	009d8403 	addseq	r8, sp, r3, lsl #8
     4dc:	07910200 	ldreq	r0, [r1, r0, lsl #4]
     4e0:	0d060000 	stceq	0, cr0, [r6, #-0]
     4e4:	00008f1a 	andeq	r8, r0, sl, lsl pc
     4e8:	88030500 	stmdahi	r3, {r8, sl}
     4ec:	0200009d 	andeq	r0, r0, #157	; 0x9d
     4f0:	00000669 	andeq	r0, r0, r9, ror #12
     4f4:	8f1a0f06 	svchi	0x001a0f06
     4f8:	05000000 	streq	r0, [r0, #-0]
     4fc:	009d8c03 	addseq	r8, sp, r3, lsl #24
     500:	0b1e0900 	bleq	782908 <__bss_end+0x778a08>
     504:	04050000 	streq	r0, [r5], #-0
     508:	00000067 	andeq	r0, r0, r7, rrx
     50c:	520c1b06 	andpl	r1, ip, #6144	; 0x1800
     510:	0a000002 	beq	520 <shift+0x520>
     514:	00000b4c 	andeq	r0, r0, ip, asr #22
     518:	0d880a00 	vstreq	s0, [r8]
     51c:	0a010000 	beq	40524 <__bss_end+0x36624>
     520:	00000964 	andeq	r0, r0, r4, ror #18
     524:	ec0b0002 	stc	0, cr0, [fp], {2}
     528:	0c000009 	stceq	0, cr0, [r0], {9}
     52c:	00000a48 	andeq	r0, r0, r8, asr #20
     530:	07630690 			; <UNDEFINED> instruction: 0x07630690
     534:	000003c5 	andeq	r0, r0, r5, asr #7
     538:	000d3707 	andeq	r3, sp, r7, lsl #14
     53c:	67062400 	strvs	r2, [r6, -r0, lsl #8]
     540:	0002df10 	andeq	sp, r2, r0, lsl pc
     544:	1d460d00 	stclne	13, cr0, [r6, #-0]
     548:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
     54c:	0003c512 	andeq	ip, r3, r2, lsl r5
     550:	f80d0000 			; <UNDEFINED> instruction: 0xf80d0000
     554:	06000004 	streq	r0, [r0], -r4
     558:	03d5126b 	bicseq	r1, r5, #-1342177274	; 0xb0000006
     55c:	0d100000 	ldceq	0, cr0, [r0, #-0]
     560:	00000b41 	andeq	r0, r0, r1, asr #22
     564:	83166d06 	tsthi	r6, #384	; 0x180
     568:	14000000 	strne	r0, [r0], #-0
     56c:	0005420d 	andeq	r4, r5, sp, lsl #4
     570:	1c700600 	ldclne	6, cr0, [r0], #-0
     574:	000003dc 	ldrdeq	r0, [r0], -ip
     578:	09fd0d18 	ldmibeq	sp!, {r3, r4, r8, sl, fp}^
     57c:	72060000 	andvc	r0, r6, #0
     580:	0003dc1c 	andeq	sp, r3, ip, lsl ip
     584:	d50d1c00 	strle	r1, [sp, #-3072]	; 0xfffff400
     588:	06000004 	streq	r0, [r0], -r4
     58c:	03dc1c75 	bicseq	r1, ip, #29952	; 0x7500
     590:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     594:	000006c2 	andeq	r0, r0, r2, asr #13
     598:	1b1c7706 	blne	71e1b8 <__bss_end+0x7142b8>
     59c:	dc000004 	stcle	0, cr0, [r0], {4}
     5a0:	d3000003 	movwle	r0, #3
     5a4:	0f000002 	svceq	0x00000002
     5a8:	000003dc 	ldrdeq	r0, [r0], -ip
     5ac:	0003e210 	andeq	lr, r3, r0, lsl r2
     5b0:	07000000 	streq	r0, [r0, -r0]
     5b4:	000005a7 	andeq	r0, r0, r7, lsr #11
     5b8:	107b0618 	rsbsne	r0, fp, r8, lsl r6
     5bc:	00000314 	andeq	r0, r0, r4, lsl r3
     5c0:	001d460d 	andseq	r4, sp, sp, lsl #12
     5c4:	127e0600 	rsbsne	r0, lr, #0, 12
     5c8:	000003c5 	andeq	r0, r0, r5, asr #7
     5cc:	04ed0d00 	strbteq	r0, [sp], #3328	; 0xd00
     5d0:	80060000 	andhi	r0, r6, r0
     5d4:	0003e219 	andeq	lr, r3, r9, lsl r2
     5d8:	690d1000 	stmdbvs	sp, {ip}
     5dc:	0600000d 	streq	r0, [r0], -sp
     5e0:	03ed2182 	mvneq	r2, #-2147483616	; 0x80000020
     5e4:	00140000 	andseq	r0, r4, r0
     5e8:	0002df04 	andeq	sp, r2, r4, lsl #30
     5ec:	08c31100 	stmiaeq	r3, {r8, ip}^
     5f0:	86060000 	strhi	r0, [r6], -r0
     5f4:	0003f321 	andeq	pc, r3, r1, lsr #6
     5f8:	074d1100 	strbeq	r1, [sp, -r0, lsl #2]
     5fc:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
     600:	00008f1f 	andeq	r8, r0, pc, lsl pc
     604:	0a870d00 	beq	fe1c3a0c <__bss_end+0xfe1b9b0c>
     608:	8b060000 	blhi	180610 <__bss_end+0x176710>
     60c:	00026417 	andeq	r6, r2, r7, lsl r4
     610:	320d0000 	andcc	r0, sp, #0
     614:	06000008 	streq	r0, [r0], -r8
     618:	0264178e 	rsbeq	r1, r4, #37224448	; 0x2380000
     61c:	0d240000 	stceq	0, cr0, [r4, #-0]
     620:	0000075f 	andeq	r0, r0, pc, asr r7
     624:	64178f06 	ldrvs	r8, [r7], #-3846	; 0xfffff0fa
     628:	48000002 	stmdami	r0, {r1}
     62c:	000dbb0d 	andeq	fp, sp, sp, lsl #22
     630:	17900600 	ldrne	r0, [r0, r0, lsl #12]
     634:	00000264 	andeq	r0, r0, r4, ror #4
     638:	0a48126c 	beq	1204ff0 <__bss_end+0x11fb0f0>
     63c:	93060000 	movwls	r0, #24576	; 0x6000
     640:	00059209 	andeq	r9, r5, r9, lsl #4
     644:	0003fe00 	andeq	pc, r3, r0, lsl #28
     648:	037e0100 	cmneq	lr, #0, 2
     64c:	03840000 	orreq	r0, r4, #0
     650:	fe0f0000 	cdp2	0, 0, cr0, cr15, cr0, {0}
     654:	00000003 	andeq	r0, r0, r3
     658:	0008b813 	andeq	fp, r8, r3, lsl r8
     65c:	0e960600 	cdpeq	6, 9, cr0, cr6, cr0, {0}
     660:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     664:	00039901 	andeq	r9, r3, r1, lsl #18
     668:	00039f00 	andeq	r9, r3, r0, lsl #30
     66c:	03fe0f00 	mvnseq	r0, #0, 30
     670:	14000000 	strne	r0, [r0], #-0
     674:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
     678:	03109906 	tsteq	r0, #98304	; 0x18000
     67c:	0400000b 	streq	r0, [r0], #-11
     680:	01000004 	tsteq	r0, r4
     684:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
     688:	0003fe0f 	andeq	pc, r3, pc, lsl #28
     68c:	03e21000 	mvneq	r1, #0
     690:	2d100000 	ldccs	0, cr0, [r0, #-0]
     694:	00000002 	andeq	r0, r0, r2
     698:	00431500 	subeq	r1, r3, r0, lsl #10
     69c:	03d50000 	bicseq	r0, r5, #0
     6a0:	94160000 	ldrls	r0, [r6], #-0
     6a4:	0f000000 	svceq	0x00000000
     6a8:	02010300 	andeq	r0, r1, #0, 6
     6ac:	0000083c 	andeq	r0, r0, ip, lsr r8
     6b0:	02640417 	rsbeq	r0, r4, #385875968	; 0x17000000
     6b4:	04170000 	ldreq	r0, [r7], #-0
     6b8:	0000004a 	andeq	r0, r0, sl, asr #32
     6bc:	000d750b 	andeq	r7, sp, fp, lsl #10
     6c0:	e8041700 	stmda	r4, {r8, r9, sl, ip}
     6c4:	15000003 	strne	r0, [r0, #-3]
     6c8:	00000314 	andeq	r0, r0, r4, lsl r3
     6cc:	000003fe 	strdeq	r0, [r0], -lr
     6d0:	04170018 	ldreq	r0, [r7], #-24	; 0xffffffe8
     6d4:	00000257 	andeq	r0, r0, r7, asr r2
     6d8:	02520417 	subseq	r0, r2, #385875968	; 0x17000000
     6dc:	8d190000 	ldchi	0, cr0, [r9, #-0]
     6e0:	0600000a 	streq	r0, [r0], -sl
     6e4:	0257149c 	subseq	r1, r7, #156, 8	; 0x9c000000
     6e8:	fd020000 	stc2	0, cr0, [r2, #-0]
     6ec:	07000006 	streq	r0, [r0, -r6]
     6f0:	008f1404 	addeq	r1, pc, r4, lsl #8
     6f4:	03050000 	movweq	r0, #20480	; 0x5000
     6f8:	00009d90 	muleq	r0, r0, sp
     6fc:	0003af02 	andeq	sl, r3, r2, lsl #30
     700:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
     704:	0000008f 	andeq	r0, r0, pc, lsl #1
     708:	9d940305 	ldcls	3, cr0, [r4, #20]
     70c:	6e020000 	cdpvs	0, 0, cr0, cr2, cr0, {0}
     710:	07000005 	streq	r0, [r0, -r5]
     714:	008f140a 	addeq	r1, pc, sl, lsl #8
     718:	03050000 	movweq	r0, #20480	; 0x5000
     71c:	00009d98 	muleq	r0, r8, sp
     720:	00087f09 	andeq	r7, r8, r9, lsl #30
     724:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     728:	07000000 	streq	r0, [r0, -r0]
     72c:	04830c0d 	streq	r0, [r3], #3085	; 0xc0d
     730:	4e1a0000 	cdpmi	0, 1, cr0, cr10, cr0, {0}
     734:	00007765 	andeq	r7, r0, r5, ror #14
     738:	0008760a 	andeq	r7, r8, sl, lsl #12
     73c:	990a0100 	stmdbls	sl, {r8}
     740:	0200000a 	andeq	r0, r0, #10
     744:	00084b0a 	andeq	r4, r8, sl, lsl #22
     748:	1e0a0300 	cdpne	3, 0, cr0, cr10, cr0, {0}
     74c:	04000008 	streq	r0, [r0], #-8
     750:	00096f0a 	andeq	r6, r9, sl, lsl #30
     754:	07000500 	streq	r0, [r0, -r0, lsl #10]
     758:	00000673 	andeq	r0, r0, r3, ror r6
     75c:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
     760:	000004c2 	andeq	r0, r0, r2, asr #9
     764:	00726c08 	rsbseq	r6, r2, r8, lsl #24
     768:	c2131d07 	andsgt	r1, r3, #448	; 0x1c0
     76c:	00000004 	andeq	r0, r0, r4
     770:	00707308 	rsbseq	r7, r0, r8, lsl #6
     774:	c2131e07 	andsgt	r1, r3, #7, 28	; 0x70
     778:	04000004 	streq	r0, [r0], #-4
     77c:	00637008 	rsbeq	r7, r3, r8
     780:	c2131f07 	andsgt	r1, r3, #7, 30
     784:	08000004 	stmdaeq	r0, {r2}
     788:	0006890d 	andeq	r8, r6, sp, lsl #18
     78c:	13200700 	nopne	{0}	; <UNPREDICTABLE>
     790:	000004c2 	andeq	r0, r0, r2, asr #9
     794:	0403000c 	streq	r0, [r3], #-12
     798:	00047007 	andeq	r7, r4, r7
     79c:	040e0700 	streq	r0, [lr], #-1792	; 0xfffff900
     7a0:	07700000 	ldrbeq	r0, [r0, -r0]!
     7a4:	05590828 	ldrbeq	r0, [r9, #-2088]	; 0xfffff7d8
     7a8:	c50d0000 	strgt	r0, [sp, #-0]
     7ac:	0700000d 	streq	r0, [r0, -sp]
     7b0:	0483122a 	streq	r1, [r3], #554	; 0x22a
     7b4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     7b8:	00646970 	rsbeq	r6, r4, r0, ror r9
     7bc:	94122b07 	ldrls	r2, [r2], #-2823	; 0xfffff4f9
     7c0:	10000000 	andne	r0, r0, r0
     7c4:	0017390d 	andseq	r3, r7, sp, lsl #18
     7c8:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
     7cc:	0000044c 	andeq	r0, r0, ip, asr #8
     7d0:	08940d14 	ldmeq	r4, {r2, r4, r8, sl, fp}
     7d4:	2d070000 	stccs	0, cr0, [r7, #-0]
     7d8:	00009412 	andeq	r9, r0, r2, lsl r4
     7dc:	a20d1800 	andge	r1, sp, #0, 16
     7e0:	07000008 	streq	r0, [r0, -r8]
     7e4:	0094122e 	addseq	r1, r4, lr, lsr #4
     7e8:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     7ec:	00000657 	andeq	r0, r0, r7, asr r6
     7f0:	590c2f07 	stmdbpl	ip, {r0, r1, r2, r8, r9, sl, fp, sp}
     7f4:	20000005 	andcs	r0, r0, r5
     7f8:	0008cf0d 	andeq	ip, r8, sp, lsl #30
     7fc:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
     800:	00000067 	andeq	r0, r0, r7, rrx
     804:	0b560d60 	bleq	1583d8c <__bss_end+0x1579e8c>
     808:	31070000 	mrscc	r0, (UNDEF: 7)
     80c:	0000830e 	andeq	r8, r0, lr, lsl #6
     810:	d60d6400 	strle	r6, [sp], -r0, lsl #8
     814:	07000006 	streq	r0, [r0, -r6]
     818:	00830e33 	addeq	r0, r3, r3, lsr lr
     81c:	0d680000 	stcleq	0, cr0, [r8, #-0]
     820:	000006cd 	andeq	r0, r0, sp, asr #13
     824:	830e3407 	movwhi	r3, #58375	; 0xe407
     828:	6c000000 	stcvs	0, cr0, [r0], {-0}
     82c:	04041500 	streq	r1, [r4], #-1280	; 0xfffffb00
     830:	05690000 	strbeq	r0, [r9, #-0]!
     834:	94160000 	ldrls	r0, [r6], #-0
     838:	0f000000 	svceq	0x00000000
     83c:	0d280200 	sfmeq	f0, 4, [r8, #-0]
     840:	0a080000 	beq	200848 <__bss_end+0x1f6948>
     844:	00008f14 	andeq	r8, r0, r4, lsl pc
     848:	9c030500 	cfstr32ls	mvfx0, [r3], {-0}
     84c:	0900009d 	stmdbeq	r0, {r0, r2, r3, r4, r7}
     850:	00000853 	andeq	r0, r0, r3, asr r8
     854:	00670405 	rsbeq	r0, r7, r5, lsl #8
     858:	0d080000 	stceq	0, cr0, [r8, #-0]
     85c:	00059a0c 	andeq	r9, r5, ip, lsl #20
     860:	051e0a00 	ldreq	r0, [lr, #-2560]	; 0xfffff600
     864:	0a000000 	beq	86c <shift+0x86c>
     868:	000003a4 	andeq	r0, r0, r4, lsr #7
     86c:	4c070001 	stcmi	0, cr0, [r7], {1}
     870:	0c00000c 	stceq	0, cr0, [r0], {12}
     874:	cf081b08 	svcgt	0x00081b08
     878:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
     87c:	000003e0 	andeq	r0, r0, r0, ror #7
     880:	cf191d08 	svcgt	0x00191d08
     884:	00000005 	andeq	r0, r0, r5
     888:	0004d50d 	andeq	sp, r4, sp, lsl #10
     88c:	191e0800 	ldmdbne	lr, {fp}
     890:	000005cf 	andeq	r0, r0, pc, asr #11
     894:	0bca0d04 	bleq	ff283cac <__bss_end+0xff279dac>
     898:	1f080000 	svcne	0x00080000
     89c:	0005d513 	andeq	sp, r5, r3, lsl r5
     8a0:	17000800 	strne	r0, [r0, -r0, lsl #16]
     8a4:	00059a04 	andeq	r9, r5, r4, lsl #20
     8a8:	c9041700 	stmdbgt	r4, {r8, r9, sl, ip}
     8ac:	0c000004 	stceq	0, cr0, [r0], {4}
     8b0:	00000581 	andeq	r0, r0, r1, lsl #11
     8b4:	07220814 			; <UNDEFINED> instruction: 0x07220814
     8b8:	0000085d 	andeq	r0, r0, sp, asr r8
     8bc:	0008410d 	andeq	r4, r8, sp, lsl #2
     8c0:	12260800 	eorne	r0, r6, #0, 16
     8c4:	00000083 	andeq	r0, r0, r3, lsl #1
     8c8:	04820d00 	streq	r0, [r2], #3328	; 0xd00
     8cc:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
     8d0:	0005cf1d 	andeq	ip, r5, sp, lsl pc
     8d4:	f00d0400 			; <UNDEFINED> instruction: 0xf00d0400
     8d8:	0800000a 	stmdaeq	r0, {r1, r3}
     8dc:	05cf1d2c 	strbeq	r1, [pc, #3372]	; 1610 <shift+0x1610>
     8e0:	1b080000 	blne	2008e8 <__bss_end+0x1f69e8>
     8e4:	00000cfe 	strdeq	r0, [r0], -lr
     8e8:	290e2f08 	stmdbcs	lr, {r3, r8, r9, sl, fp, sp}
     8ec:	2300000c 	movwcs	r0, #12
     8f0:	2e000006 	cdpcs	0, 0, cr0, cr0, cr6, {0}
     8f4:	0f000006 	svceq	0x00000006
     8f8:	00000862 	andeq	r0, r0, r2, ror #16
     8fc:	0005cf10 	andeq	ip, r5, r0, lsl pc
     900:	e21c0000 	ands	r0, ip, #0
     904:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     908:	03e50e31 	mvneq	r0, #784	; 0x310
     90c:	03d50000 	bicseq	r0, r5, #0
     910:	06460000 	strbeq	r0, [r6], -r0
     914:	06510000 	ldrbeq	r0, [r1], -r0
     918:	620f0000 	andvs	r0, pc, #0
     91c:	10000008 	andne	r0, r0, r8
     920:	000005d5 	ldrdeq	r0, [r0], -r5
     924:	0c5f1200 	lfmeq	f1, 2, [pc], {-0}
     928:	35080000 	strcc	r0, [r8, #-0]
     92c:	000ba51d 	andeq	sl, fp, sp, lsl r5
     930:	0005cf00 	andeq	ip, r5, r0, lsl #30
     934:	066a0200 	strbteq	r0, [sl], -r0, lsl #4
     938:	06700000 	ldrbteq	r0, [r0], -r0
     93c:	620f0000 	andvs	r0, pc, #0
     940:	00000008 	andeq	r0, r0, r8
     944:	0007d512 	andeq	sp, r7, r2, lsl r5
     948:	1d370800 	ldcne	8, cr0, [r7, #-0]
     94c:	00000a22 	andeq	r0, r0, r2, lsr #20
     950:	000005cf 	andeq	r0, r0, pc, asr #11
     954:	00068902 	andeq	r8, r6, r2, lsl #18
     958:	00068f00 	andeq	r8, r6, r0, lsl #30
     95c:	08620f00 	stmdaeq	r2!, {r8, r9, sl, fp}^
     960:	1d000000 	stcne	0, cr0, [r0, #-0]
     964:	000008e9 	andeq	r0, r0, r9, ror #17
     968:	7b313908 	blvc	c4ed90 <__bss_end+0xc44e90>
     96c:	0c000008 	stceq	0, cr0, [r0], {8}
     970:	05811202 	streq	r1, [r1, #514]	; 0x202
     974:	3c080000 	stccc	0, cr0, [r8], {-0}
     978:	000da109 	andeq	sl, sp, r9, lsl #2
     97c:	00086200 	andeq	r6, r8, r0, lsl #4
     980:	06b60100 	ldrteq	r0, [r6], r0, lsl #2
     984:	06bc0000 	ldrteq	r0, [ip], r0
     988:	620f0000 	andvs	r0, pc, #0
     98c:	00000008 	andeq	r0, r0, r8
     990:	00053312 	andeq	r3, r5, r2, lsl r3
     994:	123f0800 	eorsne	r0, pc, #0, 16
     998:	00000cd3 	ldrdeq	r0, [r0], -r3
     99c:	00000083 	andeq	r0, r0, r3, lsl #1
     9a0:	0006d501 	andeq	sp, r6, r1, lsl #10
     9a4:	0006ea00 	andeq	lr, r6, r0, lsl #20
     9a8:	08620f00 	stmdaeq	r2!, {r8, r9, sl, fp}^
     9ac:	84100000 	ldrhi	r0, [r0], #-0
     9b0:	10000008 	andne	r0, r0, r8
     9b4:	00000094 	muleq	r0, r4, r0
     9b8:	0003d510 	andeq	sp, r3, r0, lsl r5
     9bc:	f1130000 			; <UNDEFINED> instruction: 0xf1130000
     9c0:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     9c4:	099e0e42 	ldmibeq	lr, {r1, r6, r9, sl, fp}
     9c8:	ff010000 			; <UNDEFINED> instruction: 0xff010000
     9cc:	05000006 	streq	r0, [r0, #-6]
     9d0:	0f000007 	svceq	0x00000007
     9d4:	00000862 	andeq	r0, r0, r2, ror #16
     9d8:	07691200 	strbeq	r1, [r9, -r0, lsl #4]!
     9dc:	45080000 	strmi	r0, [r8, #-0]
     9e0:	00049f17 	andeq	r9, r4, r7, lsl pc
     9e4:	0005d500 	andeq	sp, r5, r0, lsl #10
     9e8:	071e0100 	ldreq	r0, [lr, -r0, lsl #2]
     9ec:	07240000 	streq	r0, [r4, -r0]!
     9f0:	8a0f0000 	bhi	3c09f8 <__bss_end+0x3b6af8>
     9f4:	00000008 	andeq	r0, r0, r8
     9f8:	0004da12 	andeq	sp, r4, r2, lsl sl
     9fc:	17480800 	strbne	r0, [r8, -r0, lsl #16]
     a00:	00000b62 	andeq	r0, r0, r2, ror #22
     a04:	000005d5 	ldrdeq	r0, [r0], -r5
     a08:	00073d01 	andeq	r3, r7, r1, lsl #26
     a0c:	00074800 	andeq	r4, r7, r0, lsl #16
     a10:	088a0f00 	stmeq	sl, {r8, r9, sl, fp}
     a14:	83100000 	tsthi	r0, #0
     a18:	00000000 	andeq	r0, r0, r0
     a1c:	000d4513 	andeq	r4, sp, r3, lsl r5
     a20:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
     a24:	00000bfa 	strdeq	r0, [r0], -sl
     a28:	00075d01 	andeq	r5, r7, r1, lsl #26
     a2c:	00076300 	andeq	r6, r7, r0, lsl #6
     a30:	08620f00 	stmdaeq	r2!, {r8, r9, sl, fp}^
     a34:	12000000 	andne	r0, r0, #0
     a38:	00000be2 	andeq	r0, r0, r2, ror #23
     a3c:	8f0e4d08 	svchi	0x000e4d08
     a40:	d5000006 	strle	r0, [r0, #-6]
     a44:	01000003 	tsteq	r0, r3
     a48:	0000077c 	andeq	r0, r0, ip, ror r7
     a4c:	00000787 	andeq	r0, r0, r7, lsl #15
     a50:	0008620f 	andeq	r6, r8, pc, lsl #4
     a54:	00831000 	addeq	r1, r3, r0
     a58:	12000000 	andne	r0, r0, #0
     a5c:	0000077d 	andeq	r0, r0, sp, ror r7
     a60:	bf125008 	svclt	0x00125008
     a64:	83000009 	movwhi	r0, #9
     a68:	01000000 	mrseq	r0, (UNDEF: 0)
     a6c:	000007a0 	andeq	r0, r0, r0, lsr #15
     a70:	000007ab 	andeq	r0, r0, fp, lsr #15
     a74:	0008620f 	andeq	r6, r8, pc, lsl #4
     a78:	04041000 	streq	r1, [r4], #-0
     a7c:	12000000 	andne	r0, r0, #0
     a80:	0000044b 	andeq	r0, r0, fp, asr #8
     a84:	160e5308 	strne	r5, [lr], -r8, lsl #6
     a88:	d5000007 	strle	r0, [r0, #-7]
     a8c:	01000003 	tsteq	r0, r3
     a90:	000007c4 	andeq	r0, r0, r4, asr #15
     a94:	000007cf 	andeq	r0, r0, pc, asr #15
     a98:	0008620f 	andeq	r6, r8, pc, lsl #4
     a9c:	00831000 	addeq	r1, r3, r0
     aa0:	13000000 	movwne	r0, #0
     aa4:	000007af 	andeq	r0, r0, pc, lsr #15
     aa8:	6b0e5608 	blvs	3962d0 <__bss_end+0x38c3d0>
     aac:	0100000c 	tsteq	r0, ip
     ab0:	000007e4 	andeq	r0, r0, r4, ror #15
     ab4:	00000803 	andeq	r0, r0, r3, lsl #16
     ab8:	0008620f 	andeq	r6, r8, pc, lsl #4
     abc:	01101000 	tsteq	r0, r0
     ac0:	83100000 	tsthi	r0, #0
     ac4:	10000000 	andne	r0, r0, r0
     ac8:	00000083 	andeq	r0, r0, r3, lsl #1
     acc:	00008310 	andeq	r8, r0, r0, lsl r3
     ad0:	08901000 	ldmeq	r0, {ip}
     ad4:	13000000 	movwne	r0, #0
     ad8:	00000b8f 	andeq	r0, r0, pc, lsl #23
     adc:	ff0e5808 			; <UNDEFINED> instruction: 0xff0e5808
     ae0:	01000005 	tsteq	r0, r5
     ae4:	00000818 	andeq	r0, r0, r8, lsl r8
     ae8:	00000837 	andeq	r0, r0, r7, lsr r8
     aec:	0008620f 	andeq	r6, r8, pc, lsl #4
     af0:	01471000 	mrseq	r1, (UNDEF: 71)
     af4:	83100000 	tsthi	r0, #0
     af8:	10000000 	andne	r0, r0, r0
     afc:	00000083 	andeq	r0, r0, r3, lsl #1
     b00:	00008310 	andeq	r8, r0, r0, lsl r3
     b04:	08901000 	ldmeq	r0, {ip}
     b08:	14000000 	strne	r0, [r0], #-0
     b0c:	0000055b 	andeq	r0, r0, fp, asr r5
     b10:	bc0e5b08 			; <UNDEFINED> instruction: 0xbc0e5b08
     b14:	d5000005 	strle	r0, [r0, #-5]
     b18:	01000003 	tsteq	r0, r3
     b1c:	0000084c 	andeq	r0, r0, ip, asr #16
     b20:	0008620f 	andeq	r6, r8, pc, lsl #4
     b24:	057b1000 	ldrbeq	r1, [fp, #-0]!
     b28:	96100000 	ldrls	r0, [r0], -r0
     b2c:	00000008 	andeq	r0, r0, r8
     b30:	05db0400 	ldrbeq	r0, [fp, #1024]	; 0x400
     b34:	04170000 	ldreq	r0, [r7], #-0
     b38:	000005db 	ldrdeq	r0, [r0], -fp
     b3c:	0005cf1e 	andeq	ip, r5, lr, lsl pc
     b40:	00087500 	andeq	r7, r8, r0, lsl #10
     b44:	00087b00 	andeq	r7, r8, r0, lsl #22
     b48:	08620f00 	stmdaeq	r2!, {r8, r9, sl, fp}^
     b4c:	1f000000 	svcne	0x00000000
     b50:	000005db 	ldrdeq	r0, [r0], -fp
     b54:	00000868 	andeq	r0, r0, r8, ror #16
     b58:	00750417 	rsbseq	r0, r5, r7, lsl r4
     b5c:	04170000 	ldreq	r0, [r7], #-0
     b60:	0000085d 	andeq	r0, r0, sp, asr r8
     b64:	00ea0420 	rsceq	r0, sl, r0, lsr #8
     b68:	04210000 	strteq	r0, [r1], #-0
     b6c:	0008f719 	andeq	pc, r8, r9, lsl r7	; <UNPREDICTABLE>
     b70:	195e0800 	ldmdbne	lr, {fp}^
     b74:	000005db 	ldrdeq	r0, [r0], -fp
     b78:	0003bf09 	andeq	fp, r3, r9, lsl #30
     b7c:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     b80:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     b84:	08c30c03 	stmiaeq	r3, {r0, r1, sl, fp}^
     b88:	ef0a0000 	svc	0x000a0000
     b8c:	00000006 	andeq	r0, r0, r6
     b90:	0006f60a 	andeq	pc, r6, sl, lsl #12
     b94:	09000100 	stmdbeq	r0, {r8}
     b98:	000006df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     b9c:	00670405 	rsbeq	r0, r7, r5, lsl #8
     ba0:	09090000 	stmdbeq	r9, {}	; <UNPREDICTABLE>
     ba4:	0009100c 	andeq	r1, r9, ip
     ba8:	0d202200 	sfmeq	f2, 4, [r0, #-0]
     bac:	04b00000 	ldrteq	r0, [r0], #0
     bb0:	0003d822 	andeq	sp, r3, r2, lsr #16
     bb4:	22096000 	andcs	r6, r9, #0
     bb8:	000004cd 	andeq	r0, r0, sp, asr #9
     bbc:	5b2212c0 	blpl	8856c4 <__bss_end+0x87b7c4>
     bc0:	8000000d 	andhi	r0, r0, sp
     bc4:	0bcf2225 	bleq	ff3c9460 <__bss_end+0xff3bf560>
     bc8:	4b000000 	blmi	bd0 <shift+0xbd0>
     bcc:	00088b22 	andeq	r8, r8, r2, lsr #22
     bd0:	22960000 	addscs	r0, r6, #0
     bd4:	0000039b 	muleq	r0, fp, r3
     bd8:	df23e100 	svcle	0x0023e100
     bdc:	00000008 	andeq	r0, r0, r8
     be0:	000001c2 	andeq	r0, r0, r2, asr #3
     be4:	00095107 	andeq	r5, r9, r7, lsl #2
     be8:	16090800 	strne	r0, [r9], -r0, lsl #16
     bec:	00093808 	andeq	r3, r9, r8, lsl #16
     bf0:	0b2e0d00 	bleq	b83ff8 <__bss_end+0xb7a0f8>
     bf4:	18090000 	stmdane	r9, {}	; <UNPREDICTABLE>
     bf8:	0008a417 	andeq	sl, r8, r7, lsl r4
     bfc:	950d0000 	strls	r0, [sp, #-0]
     c00:	09000004 	stmdbeq	r0, {r2}
     c04:	08c31519 	stmiaeq	r3, {r0, r3, r4, r8, sl, ip}^
     c08:	00040000 	andeq	r0, r4, r0
     c0c:	00066424 	andeq	r6, r6, r4, lsr #8
     c10:	05210100 	streq	r0, [r1, #-256]!	; 0xffffff00
     c14:	00000067 	andeq	r0, r0, r7, rrx
     c18:	000082e4 	andeq	r8, r0, r4, ror #5
     c1c:	00000314 	andeq	r0, r0, r4, lsl r3
     c20:	0a349c01 	beq	d27c2c <__bss_end+0xd1dd2c>
     c24:	70250000 	eorvc	r0, r5, r0
     c28:	0100000d 	tsteq	r0, sp
     c2c:	00670e21 	rsbeq	r0, r7, r1, lsr #28
     c30:	91030000 	mrsls	r0, (UNDEF: 3)
     c34:	bd2577bc 	stclt	7, cr7, [r5, #-752]!	; 0xfffffd10
     c38:	0100000c 	tsteq	r0, ip
     c3c:	0a341b21 	beq	d078c8 <__bss_end+0xcfd9c8>
     c40:	91030000 	mrsls	r0, (UNDEF: 3)
     c44:	5e2677b8 	mcrpl	7, 1, r7, cr6, cr8, {5}
     c48:	0100000a 	tsteq	r0, sl
     c4c:	00830b23 	addeq	r0, r3, r3, lsr #22
     c50:	91020000 	mrsls	r0, (UNDEF: 2)
     c54:	0bd82670 	bleq	ff60a61c <__bss_end+0xff60071c>
     c58:	24010000 	strcs	r0, [r1], #-0
     c5c:	0000830b 	andeq	r8, r0, fp, lsl #6
     c60:	6c910200 	lfmvs	f0, 4, [r1], {0}
     c64:	00098026 	andeq	r8, r9, r6, lsr #32
     c68:	07290100 	streq	r0, [r9, -r0, lsl #2]!
     c6c:	00000a40 	andeq	r0, r0, r0, asr #20
     c70:	77f49103 	ldrbvc	r9, [r4, r3, lsl #2]!
     c74:	00086826 	andeq	r6, r8, r6, lsr #16
     c78:	072a0100 	streq	r0, [sl, -r0, lsl #2]!
     c7c:	000003c5 	andeq	r0, r0, r5, asr #7
     c80:	77e49103 	strbvc	r9, [r4, r3, lsl #2]!
     c84:	000aea26 	andeq	lr, sl, r6, lsr #20
     c88:	082e0100 	stmdaeq	lr!, {r8}
     c8c:	00000037 	andeq	r0, r0, r7, lsr r0
     c90:	26689102 	strbtcs	r9, [r8], -r2, lsl #2
     c94:	00000976 	andeq	r0, r0, r6, ror r9
     c98:	51072f01 	tstpl	r7, r1, lsl #30
     c9c:	0300000a 	movweq	r0, #10
     ca0:	2777c491 			; <UNDEFINED> instruction: 0x2777c491
     ca4:	000083c4 	andeq	r8, r0, r4, asr #7
     ca8:	000001ec 	andeq	r0, r0, ip, ror #3
     cac:	01007628 	tsteq	r0, r8, lsr #12
     cb0:	00830c3e 	addeq	r0, r3, lr, lsr ip
     cb4:	91020000 	mrsls	r0, (UNDEF: 2)
     cb8:	849c2964 	ldrhi	r2, [ip], #2404	; 0x964
     cbc:	00900000 	addseq	r0, r0, r0
     cc0:	0a190000 	beq	640cc8 <__bss_end+0x636dc8>
     cc4:	69280000 	stmdbvs	r8!, {}	; <UNPREDICTABLE>
     cc8:	124d0100 	subne	r0, sp, #0, 2
     ccc:	00000083 	andeq	r0, r0, r3, lsl #1
     cd0:	27749102 	ldrbcs	r9, [r4, -r2, lsl #2]!
     cd4:	000084b4 			; <UNDEFINED> instruction: 0x000084b4
     cd8:	00000068 	andeq	r0, r0, r8, rrx
     cdc:	00045e26 	andeq	r5, r4, r6, lsr #28
     ce0:	094f0100 	stmdbeq	pc, {r8}^	; <UNPREDICTABLE>
     ce4:	00000067 	andeq	r0, r0, r7, rrx
     ce8:	005c9102 	subseq	r9, ip, r2, lsl #2
     cec:	852c2700 	strhi	r2, [ip, #-1792]!	; 0xfffff900
     cf0:	00840000 	addeq	r0, r4, r0
     cf4:	37260000 	strcc	r0, [r6, -r0]!
     cf8:	01000009 	tsteq	r0, r9
     cfc:	00370a58 	eorseq	r0, r7, r8, asr sl
     d00:	91020000 	mrsls	r0, (UNDEF: 2)
     d04:	00000060 	andeq	r0, r0, r0, rrx
     d08:	0a3a0417 	beq	e81d6c <__bss_end+0xe77e6c>
     d0c:	04170000 	ldreq	r0, [r7], #-0
     d10:	00000043 	andeq	r0, r0, r3, asr #32
     d14:	00004315 	andeq	r4, r0, r5, lsl r3
     d18:	000a5100 	andeq	r5, sl, r0, lsl #2
     d1c:	00942a00 	addseq	r2, r4, r0, lsl #20
     d20:	03e70000 	mvneq	r0, #0
     d24:	00431500 	subeq	r1, r3, r0, lsl #10
     d28:	0a610000 	beq	1840d30 <__bss_end+0x1836e30>
     d2c:	94160000 	ldrls	r0, [r6], #-0
     d30:	1f000000 	svcne	0x00000000
     d34:	05b22b00 	ldreq	r2, [r2, #2816]!	; 0xb00
     d38:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     d3c:	0082a00d 	addeq	sl, r2, sp
     d40:	00004400 	andeq	r4, r0, r0, lsl #8
     d44:	969c0100 	ldrls	r0, [ip], r0, lsl #2
     d48:	2500000a 	strcs	r0, [r0, #-10]
     d4c:	00000a68 	andeq	r0, r0, r8, ror #20
     d50:	83201901 			; <UNDEFINED> instruction: 0x83201901
     d54:	02000000 	andeq	r0, r0, #0
     d58:	3a266c91 	bcc	99bfa4 <__bss_end+0x9920a4>
     d5c:	0100000b 	tsteq	r0, fp
     d60:	0910151b 	ldmdbeq	r0, {r0, r1, r3, r4, r8, sl, ip}
     d64:	91020000 	mrsls	r0, (UNDEF: 2)
     d68:	d92c0070 	stmdble	ip!, {r4, r5, r6}
     d6c:	01000008 	tsteq	r0, r8
     d70:	00831114 	addeq	r1, r3, r4, lsl r1
     d74:	82680000 	rsbhi	r0, r8, #0
     d78:	00380000 	eorseq	r0, r8, r0
     d7c:	9c010000 	stcls	0, cr0, [r1], {-0}
     d80:	00000ade 	ldrdeq	r0, [r0], -lr
     d84:	000bdd25 	andeq	sp, fp, r5, lsr #26
     d88:	20140100 	andscs	r0, r4, r0, lsl #2
     d8c:	00000083 	andeq	r0, r0, r3, lsl #1
     d90:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
     d94:	00000988 	andeq	r0, r0, r8, lsl #19
     d98:	3a2c1401 	bcc	b05da4 <__bss_end+0xafbea4>
     d9c:	0200000a 	andeq	r0, r0, #10
     da0:	da257091 	ble	95cfec <__bss_end+0x9530ec>
     da4:	0100000f 	tsteq	r0, pc
     da8:	00833d14 	addeq	r3, r3, r4, lsl sp
     dac:	91020000 	mrsls	r0, (UNDEF: 2)
     db0:	3f2d006c 	svccc	0x002d006c
     db4:	01000009 	tsteq	r0, r9
     db8:	822c0d0f 	eorhi	r0, ip, #960	; 0x3c0
     dbc:	003c0000 	eorseq	r0, ip, r0
     dc0:	9c010000 	stcls	0, cr0, [r1], {-0}
     dc4:	000bdd25 	andeq	sp, fp, r5, lsr #26
     dc8:	1c0f0100 	stfnes	f0, [pc], {-0}
     dcc:	00000083 	andeq	r0, r0, r3, lsl #1
     dd0:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
     dd4:	000003d1 	ldrdeq	r0, [r0], -r1
     dd8:	e22e0f01 	eor	r0, lr, #1, 30
     ddc:	02000003 	andeq	r0, r0, #3
     de0:	00007091 	muleq	r0, r1, r0
     de4:	00000d5c 	andeq	r0, r0, ip, asr sp
     de8:	04900004 	ldreq	r0, [r0], #4
     dec:	01040000 	mrseq	r0, (UNDEF: 4)
     df0:	000010d2 	ldrdeq	r1, [r0], -r2
     df4:	000eef04 	andeq	lr, lr, r4, lsl #30
     df8:	000f7a00 	andeq	r7, pc, r0, lsl #20
     dfc:	0085f800 	addeq	pc, r5, r0, lsl #16
     e00:	00045c00 	andeq	r5, r4, r0, lsl #24
     e04:	0004bf00 	andeq	fp, r4, r0, lsl #30
     e08:	08010200 	stmdaeq	r1, {r9}
     e0c:	00000a1d 	andeq	r0, r0, sp, lsl sl
     e10:	00002503 	andeq	r2, r0, r3, lsl #10
     e14:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     e18:	00000a54 	andeq	r0, r0, r4, asr sl
     e1c:	000aa204 	andeq	sl, sl, r4, lsl #4
     e20:	07050200 	streq	r0, [r5, -r0, lsl #4]
     e24:	00000049 	andeq	r0, r0, r9, asr #32
     e28:	00003803 	andeq	r3, r0, r3, lsl #16
     e2c:	05040500 	streq	r0, [r4, #-1280]	; 0xfffffb00
     e30:	00746e69 	rsbseq	r6, r4, r9, ror #28
     e34:	1f050802 	svcne	0x00050802
     e38:	02000003 	andeq	r0, r0, #3
     e3c:	0a140801 	beq	502e48 <__bss_end+0x4f8f48>
     e40:	02020000 	andeq	r0, r2, #0
     e44:	0007c207 	andeq	ip, r7, r7, lsl #4
     e48:	0aa10400 	beq	fe841e50 <__bss_end+0xfe837f50>
     e4c:	0a020000 	beq	80e54 <__bss_end+0x76f54>
     e50:	00007607 	andeq	r7, r0, r7, lsl #12
     e54:	00650300 	rsbeq	r0, r5, r0, lsl #6
     e58:	04020000 	streq	r0, [r2], #-0
     e5c:	00047507 	andeq	r7, r4, r7, lsl #10
     e60:	07080200 	streq	r0, [r8, -r0, lsl #4]
     e64:	0000046b 	andeq	r0, r0, fp, ror #8
     e68:	0006b806 	andeq	fp, r6, r6, lsl #16
     e6c:	130d0200 	movwne	r0, #53760	; 0xd200
     e70:	00000044 	andeq	r0, r0, r4, asr #32
     e74:	9e500305 	cdpls	3, 5, cr0, cr0, cr5, {0}
     e78:	43060000 	movwmi	r0, #24576	; 0x6000
     e7c:	02000007 	andeq	r0, r0, #7
     e80:	0044130e 	subeq	r1, r4, lr, lsl #6
     e84:	03050000 	movweq	r0, #20480	; 0x5000
     e88:	00009e54 	andeq	r9, r0, r4, asr lr
     e8c:	0006b706 	andeq	fp, r6, r6, lsl #14
     e90:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     e94:	00000071 	andeq	r0, r0, r1, ror r0
     e98:	9e580305 	cdpls	3, 5, cr0, cr8, cr5, {0}
     e9c:	42060000 	andmi	r0, r6, #0
     ea0:	02000007 	andeq	r0, r0, #7
     ea4:	00711411 	rsbseq	r1, r1, r1, lsl r4
     ea8:	03050000 	movweq	r0, #20480	; 0x5000
     eac:	00009e5c 	andeq	r9, r0, ip, asr lr
     eb0:	00064b07 	andeq	r4, r6, r7, lsl #22
     eb4:	06030800 	streq	r0, [r3], -r0, lsl #16
     eb8:	0000f208 	andeq	pc, r0, r8, lsl #4
     ebc:	30720800 	rsbscc	r0, r2, r0, lsl #16
     ec0:	0e080300 	cdpeq	3, 0, cr0, cr8, cr0, {0}
     ec4:	00000065 	andeq	r0, r0, r5, rrx
     ec8:	31720800 	cmncc	r2, r0, lsl #16
     ecc:	0e090300 	cdpeq	3, 0, cr0, cr9, cr0, {0}
     ed0:	00000065 	andeq	r0, r0, r5, rrx
     ed4:	18090004 	stmdane	r9, {r2}
     ed8:	05000010 	streq	r0, [r0, #-16]
     edc:	00004904 	andeq	r4, r0, r4, lsl #18
     ee0:	0c0d0300 	stceq	3, cr0, [sp], {-0}
     ee4:	00000110 	andeq	r0, r0, r0, lsl r1
     ee8:	004b4f0a 	subeq	r4, fp, sl, lsl #30
     eec:	0e5e0b00 	vnmlseq.f64	d16, d14, d0
     ef0:	00010000 	andeq	r0, r1, r0
     ef4:	00050409 	andeq	r0, r5, r9, lsl #8
     ef8:	49040500 	stmdbmi	r4, {r8, sl}
     efc:	03000000 	movweq	r0, #0
     f00:	01470c1e 	cmpeq	r7, lr, lsl ip
     f04:	930b0000 	movwls	r0, #45056	; 0xb000
     f08:	0000000d 	andeq	r0, r0, sp
     f0c:	000dd10b 	andeq	sp, sp, fp, lsl #2
     f10:	9b0b0100 	blls	2c1318 <__bss_end+0x2b7418>
     f14:	0200000d 	andeq	r0, r0, #13
     f18:	00082c0b 	andeq	r2, r8, fp, lsl #24
     f1c:	8f0b0300 	svchi	0x000b0300
     f20:	04000009 	streq	r0, [r0], #-9
     f24:	0006800b 	andeq	r8, r6, fp
     f28:	09000500 	stmdbeq	r0, {r8, sl}
     f2c:	00000d08 	andeq	r0, r0, r8, lsl #26
     f30:	00490405 	subeq	r0, r9, r5, lsl #8
     f34:	44030000 	strmi	r0, [r3], #-0
     f38:	0001840c 	andeq	r8, r1, ip, lsl #8
     f3c:	03ba0b00 			; <UNDEFINED> instruction: 0x03ba0b00
     f40:	0b000000 	bleq	f48 <shift+0xf48>
     f44:	00000519 	andeq	r0, r0, r9, lsl r5
     f48:	09690b01 	stmdbeq	r9!, {r0, r8, r9, fp}^
     f4c:	0b020000 	bleq	80f54 <__bss_end+0x77054>
     f50:	00000d63 	andeq	r0, r0, r3, ror #26
     f54:	0ddb0b03 	vldreq	d16, [fp, #12]
     f58:	0b040000 	bleq	100f60 <__bss_end+0xf7060>
     f5c:	00000919 	andeq	r0, r0, r9, lsl r9
     f60:	07e20b05 	strbeq	r0, [r2, r5, lsl #22]!
     f64:	00060000 	andeq	r0, r6, r0
     f68:	000cc209 	andeq	ip, ip, r9, lsl #4
     f6c:	49040500 	stmdbmi	r4, {r8, sl}
     f70:	03000000 	movweq	r0, #0
     f74:	01af0c6b 			; <UNDEFINED> instruction: 0x01af0c6b
     f78:	f20b0000 	vhadd.s8	d0, d11, d0
     f7c:	00000009 	andeq	r0, r0, r9
     f80:	0007a40b 	andeq	sl, r7, fp, lsl #8
     f84:	700b0100 	andvc	r0, fp, r0, lsl #2
     f88:	0200000a 	andeq	r0, r0, #10
     f8c:	0007e70b 	andeq	lr, r7, fp, lsl #14
     f90:	06000300 	streq	r0, [r0], -r0, lsl #6
     f94:	00000920 	andeq	r0, r0, r0, lsr #18
     f98:	71140504 	tstvc	r4, r4, lsl #10
     f9c:	05000000 	streq	r0, [r0, #-0]
     fa0:	009e6003 	addseq	r6, lr, r3
     fa4:	09450600 	stmdbeq	r5, {r9, sl}^
     fa8:	06040000 	streq	r0, [r4], -r0
     fac:	00007114 	andeq	r7, r0, r4, lsl r1
     fb0:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     fb4:	0600009e 			; <UNDEFINED> instruction: 0x0600009e
     fb8:	00000903 	andeq	r0, r0, r3, lsl #18
     fbc:	711a0705 	tstvc	sl, r5, lsl #14
     fc0:	05000000 	streq	r0, [r0, #-0]
     fc4:	009e6803 	addseq	r6, lr, r3, lsl #16
     fc8:	05490600 	strbeq	r0, [r9, #-1536]	; 0xfffffa00
     fcc:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     fd0:	0000711a 	andeq	r7, r0, sl, lsl r1
     fd4:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     fd8:	0600009e 			; <UNDEFINED> instruction: 0x0600009e
     fdc:	00000a06 	andeq	r0, r0, r6, lsl #20
     fe0:	711a0b05 	tstvc	sl, r5, lsl #22
     fe4:	05000000 	streq	r0, [r0, #-0]
     fe8:	009e7003 	addseq	r7, lr, r3
     fec:	07910600 	ldreq	r0, [r1, r0, lsl #12]
     ff0:	0d050000 	stceq	0, cr0, [r5, #-0]
     ff4:	0000711a 	andeq	r7, r0, sl, lsl r1
     ff8:	74030500 	strvc	r0, [r3], #-1280	; 0xfffffb00
     ffc:	0600009e 			; <UNDEFINED> instruction: 0x0600009e
    1000:	00000669 	andeq	r0, r0, r9, ror #12
    1004:	711a0f05 	tstvc	sl, r5, lsl #30
    1008:	05000000 	streq	r0, [r0, #-0]
    100c:	009e7803 	addseq	r7, lr, r3, lsl #16
    1010:	0b1e0900 	bleq	783418 <__bss_end+0x779518>
    1014:	04050000 	streq	r0, [r5], #-0
    1018:	00000049 	andeq	r0, r0, r9, asr #32
    101c:	520c1b05 	andpl	r1, ip, #5120	; 0x1400
    1020:	0b000002 	bleq	1030 <shift+0x1030>
    1024:	00000b4c 	andeq	r0, r0, ip, asr #22
    1028:	0d880b00 	vstreq	d0, [r8]
    102c:	0b010000 	bleq	41034 <__bss_end+0x37134>
    1030:	00000964 	andeq	r0, r0, r4, ror #18
    1034:	ec0c0002 	stc	0, cr0, [ip], {2}
    1038:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    103c:	00000a48 	andeq	r0, r0, r8, asr #20
    1040:	07630590 			; <UNDEFINED> instruction: 0x07630590
    1044:	000003c5 	andeq	r0, r0, r5, asr #7
    1048:	000d3707 	andeq	r3, sp, r7, lsl #14
    104c:	67052400 	strvs	r2, [r5, -r0, lsl #8]
    1050:	0002df10 	andeq	sp, r2, r0, lsl pc
    1054:	1d460e00 	stclne	14, cr0, [r6, #-0]
    1058:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    105c:	0003c512 	andeq	ip, r3, r2, lsl r5
    1060:	f80e0000 			; <UNDEFINED> instruction: 0xf80e0000
    1064:	05000004 	streq	r0, [r0, #-4]
    1068:	03d5126b 	bicseq	r1, r5, #-1342177274	; 0xb0000006
    106c:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1070:	00000b41 	andeq	r0, r0, r1, asr #22
    1074:	65166d05 	ldrvs	r6, [r6, #-3333]	; 0xfffff2fb
    1078:	14000000 	strne	r0, [r0], #-0
    107c:	0005420e 	andeq	r4, r5, lr, lsl #4
    1080:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
    1084:	000003dc 	ldrdeq	r0, [r0], -ip
    1088:	09fd0e18 	ldmibeq	sp!, {r3, r4, r9, sl, fp}^
    108c:	72050000 	andvc	r0, r5, #0
    1090:	0003dc1c 	andeq	sp, r3, ip, lsl ip
    1094:	d50e1c00 	strle	r1, [lr, #-3072]	; 0xfffff400
    1098:	05000004 	streq	r0, [r0, #-4]
    109c:	03dc1c75 	bicseq	r1, ip, #29952	; 0x7500
    10a0:	0f200000 	svceq	0x00200000
    10a4:	000006c2 	andeq	r0, r0, r2, asr #13
    10a8:	1b1c7705 	blne	71ecc4 <__bss_end+0x714dc4>
    10ac:	dc000004 	stcle	0, cr0, [r0], {4}
    10b0:	d3000003 	movwle	r0, #3
    10b4:	10000002 	andne	r0, r0, r2
    10b8:	000003dc 	ldrdeq	r0, [r0], -ip
    10bc:	0003e211 	andeq	lr, r3, r1, lsl r2
    10c0:	07000000 	streq	r0, [r0, -r0]
    10c4:	000005a7 	andeq	r0, r0, r7, lsr #11
    10c8:	107b0518 	rsbsne	r0, fp, r8, lsl r5
    10cc:	00000314 	andeq	r0, r0, r4, lsl r3
    10d0:	001d460e 	andseq	r4, sp, lr, lsl #12
    10d4:	127e0500 	rsbsne	r0, lr, #0, 10
    10d8:	000003c5 	andeq	r0, r0, r5, asr #7
    10dc:	04ed0e00 	strbteq	r0, [sp], #3584	; 0xe00
    10e0:	80050000 	andhi	r0, r5, r0
    10e4:	0003e219 	andeq	lr, r3, r9, lsl r2
    10e8:	690e1000 	stmdbvs	lr, {ip}
    10ec:	0500000d 	streq	r0, [r0, #-13]
    10f0:	03ed2182 	mvneq	r2, #-2147483616	; 0x80000020
    10f4:	00140000 	andseq	r0, r4, r0
    10f8:	0002df03 	andeq	sp, r2, r3, lsl #30
    10fc:	08c31200 	stmiaeq	r3, {r9, ip}^
    1100:	86050000 	strhi	r0, [r5], -r0
    1104:	0003f321 	andeq	pc, r3, r1, lsr #6
    1108:	074d1200 	strbeq	r1, [sp, -r0, lsl #4]
    110c:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
    1110:	0000711f 	andeq	r7, r0, pc, lsl r1
    1114:	0a870e00 	beq	fe1c491c <__bss_end+0xfe1baa1c>
    1118:	8b050000 	blhi	141120 <__bss_end+0x137220>
    111c:	00026417 	andeq	r6, r2, r7, lsl r4
    1120:	320e0000 	andcc	r0, lr, #0
    1124:	05000008 	streq	r0, [r0, #-8]
    1128:	0264178e 	rsbeq	r1, r4, #37224448	; 0x2380000
    112c:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
    1130:	0000075f 	andeq	r0, r0, pc, asr r7
    1134:	64178f05 	ldrvs	r8, [r7], #-3845	; 0xfffff0fb
    1138:	48000002 	stmdami	r0, {r1}
    113c:	000dbb0e 	andeq	fp, sp, lr, lsl #22
    1140:	17900500 	ldrne	r0, [r0, r0, lsl #10]
    1144:	00000264 	andeq	r0, r0, r4, ror #4
    1148:	0a48136c 	beq	1205f00 <__bss_end+0x11fc000>
    114c:	93050000 	movwls	r0, #20480	; 0x5000
    1150:	00059209 	andeq	r9, r5, r9, lsl #4
    1154:	0003fe00 	andeq	pc, r3, r0, lsl #28
    1158:	037e0100 	cmneq	lr, #0, 2
    115c:	03840000 	orreq	r0, r4, #0
    1160:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
    1164:	00000003 	andeq	r0, r0, r3
    1168:	0008b814 	andeq	fp, r8, r4, lsl r8
    116c:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
    1170:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1174:	00039901 	andeq	r9, r3, r1, lsl #18
    1178:	00039f00 	andeq	r9, r3, r0, lsl #30
    117c:	03fe1000 	mvnseq	r1, #0
    1180:	15000000 	strne	r0, [r0, #-0]
    1184:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    1188:	03109905 	tsteq	r0, #81920	; 0x14000
    118c:	0400000b 	streq	r0, [r0], #-11
    1190:	01000004 	tsteq	r0, r4
    1194:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
    1198:	0003fe10 	andeq	pc, r3, r0, lsl lr	; <UNPREDICTABLE>
    119c:	03e21100 	mvneq	r1, #0, 2
    11a0:	2d110000 	ldccs	0, cr0, [r1, #-0]
    11a4:	00000002 	andeq	r0, r0, r2
    11a8:	00251600 	eoreq	r1, r5, r0, lsl #12
    11ac:	03d50000 	bicseq	r0, r5, #0
    11b0:	76170000 	ldrvc	r0, [r7], -r0
    11b4:	0f000000 	svceq	0x00000000
    11b8:	02010200 	andeq	r0, r1, #0, 4
    11bc:	0000083c 	andeq	r0, r0, ip, lsr r8
    11c0:	02640418 	rsbeq	r0, r4, #24, 8	; 0x18000000
    11c4:	04180000 	ldreq	r0, [r8], #-0
    11c8:	0000002c 	andeq	r0, r0, ip, lsr #32
    11cc:	000d750c 	andeq	r7, sp, ip, lsl #10
    11d0:	e8041800 	stmda	r4, {fp, ip}
    11d4:	16000003 	strne	r0, [r0], -r3
    11d8:	00000314 	andeq	r0, r0, r4, lsl r3
    11dc:	000003fe 	strdeq	r0, [r0], -lr
    11e0:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
    11e4:	00000257 	andeq	r0, r0, r7, asr r2
    11e8:	02520418 	subseq	r0, r2, #24, 8	; 0x18000000
    11ec:	8d1a0000 	ldchi	0, cr0, [sl, #-0]
    11f0:	0500000a 	streq	r0, [r0, #-10]
    11f4:	0257149c 	subseq	r1, r7, #156, 8	; 0x9c000000
    11f8:	fd060000 	stc2	0, cr0, [r6, #-0]
    11fc:	06000006 	streq	r0, [r0], -r6
    1200:	00711404 	rsbseq	r1, r1, r4, lsl #8
    1204:	03050000 	movweq	r0, #20480	; 0x5000
    1208:	00009e7c 	andeq	r9, r0, ip, ror lr
    120c:	0003af06 	andeq	sl, r3, r6, lsl #30
    1210:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
    1214:	00000071 	andeq	r0, r0, r1, ror r0
    1218:	9e800305 	cdpls	3, 8, cr0, cr0, cr5, {0}
    121c:	6e060000 	cdpvs	0, 0, cr0, cr6, cr0, {0}
    1220:	06000005 	streq	r0, [r0], -r5
    1224:	0071140a 	rsbseq	r1, r1, sl, lsl #8
    1228:	03050000 	movweq	r0, #20480	; 0x5000
    122c:	00009e84 	andeq	r9, r0, r4, lsl #29
    1230:	00087f09 	andeq	r7, r8, r9, lsl #30
    1234:	49040500 	stmdbmi	r4, {r8, sl}
    1238:	06000000 	streq	r0, [r0], -r0
    123c:	04830c0d 	streq	r0, [r3], #3085	; 0xc0d
    1240:	4e0a0000 	cdpmi	0, 0, cr0, cr10, cr0, {0}
    1244:	00007765 	andeq	r7, r0, r5, ror #14
    1248:	0008760b 	andeq	r7, r8, fp, lsl #12
    124c:	990b0100 	stmdbls	fp, {r8}
    1250:	0200000a 	andeq	r0, r0, #10
    1254:	00084b0b 	andeq	r4, r8, fp, lsl #22
    1258:	1e0b0300 	cdpne	3, 0, cr0, cr11, cr0, {0}
    125c:	04000008 	streq	r0, [r0], #-8
    1260:	00096f0b 	andeq	r6, r9, fp, lsl #30
    1264:	07000500 	streq	r0, [r0, -r0, lsl #10]
    1268:	00000673 	andeq	r0, r0, r3, ror r6
    126c:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
    1270:	000004c2 	andeq	r0, r0, r2, asr #9
    1274:	00726c08 	rsbseq	r6, r2, r8, lsl #24
    1278:	c2131d06 	andsgt	r1, r3, #384	; 0x180
    127c:	00000004 	andeq	r0, r0, r4
    1280:	00707308 	rsbseq	r7, r0, r8, lsl #6
    1284:	c2131e06 	andsgt	r1, r3, #6, 28	; 0x60
    1288:	04000004 	streq	r0, [r0], #-4
    128c:	00637008 	rsbeq	r7, r3, r8
    1290:	c2131f06 	andsgt	r1, r3, #6, 30
    1294:	08000004 	stmdaeq	r0, {r2}
    1298:	0006890e 	andeq	r8, r6, lr, lsl #18
    129c:	13200600 	nopne	{0}	; <UNPREDICTABLE>
    12a0:	000004c2 	andeq	r0, r0, r2, asr #9
    12a4:	0402000c 	streq	r0, [r2], #-12
    12a8:	00047007 	andeq	r7, r4, r7
    12ac:	040e0700 	streq	r0, [lr], #-1792	; 0xfffff900
    12b0:	06700000 	ldrbteq	r0, [r0], -r0
    12b4:	05590828 	ldrbeq	r0, [r9, #-2088]	; 0xfffff7d8
    12b8:	c50e0000 	strgt	r0, [lr, #-0]
    12bc:	0600000d 	streq	r0, [r0], -sp
    12c0:	0483122a 	streq	r1, [r3], #554	; 0x22a
    12c4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    12c8:	00646970 	rsbeq	r6, r4, r0, ror r9
    12cc:	76122b06 	ldrvc	r2, [r2], -r6, lsl #22
    12d0:	10000000 	andne	r0, r0, r0
    12d4:	0017390e 	andseq	r3, r7, lr, lsl #18
    12d8:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
    12dc:	0000044c 	andeq	r0, r0, ip, asr #8
    12e0:	08940e14 	ldmeq	r4, {r2, r4, r9, sl, fp}
    12e4:	2d060000 	stccs	0, cr0, [r6, #-0]
    12e8:	00007612 	andeq	r7, r0, r2, lsl r6
    12ec:	a20e1800 	andge	r1, lr, #0, 16
    12f0:	06000008 	streq	r0, [r0], -r8
    12f4:	0076122e 	rsbseq	r1, r6, lr, lsr #4
    12f8:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    12fc:	00000657 	andeq	r0, r0, r7, asr r6
    1300:	590c2f06 	stmdbpl	ip, {r1, r2, r8, r9, sl, fp, sp}
    1304:	20000005 	andcs	r0, r0, r5
    1308:	0008cf0e 	andeq	ip, r8, lr, lsl #30
    130c:	09300600 	ldmdbeq	r0!, {r9, sl}
    1310:	00000049 	andeq	r0, r0, r9, asr #32
    1314:	0b560e60 	bleq	1584c9c <__bss_end+0x157ad9c>
    1318:	31060000 	mrscc	r0, (UNDEF: 6)
    131c:	0000650e 	andeq	r6, r0, lr, lsl #10
    1320:	d60e6400 	strle	r6, [lr], -r0, lsl #8
    1324:	06000006 	streq	r0, [r0], -r6
    1328:	00650e33 	rsbeq	r0, r5, r3, lsr lr
    132c:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
    1330:	000006cd 	andeq	r0, r0, sp, asr #13
    1334:	650e3406 	strvs	r3, [lr, #-1030]	; 0xfffffbfa
    1338:	6c000000 	stcvs	0, cr0, [r0], {-0}
    133c:	04041600 	streq	r1, [r4], #-1536	; 0xfffffa00
    1340:	05690000 	strbeq	r0, [r9, #-0]!
    1344:	76170000 	ldrvc	r0, [r7], -r0
    1348:	0f000000 	svceq	0x00000000
    134c:	0d280600 	stceq	6, cr0, [r8, #-0]
    1350:	0a070000 	beq	1c1358 <__bss_end+0x1b7458>
    1354:	00007114 	andeq	r7, r0, r4, lsl r1
    1358:	88030500 	stmdahi	r3, {r8, sl}
    135c:	0900009e 	stmdbeq	r0, {r1, r2, r3, r4, r7}
    1360:	00000853 	andeq	r0, r0, r3, asr r8
    1364:	00490405 	subeq	r0, r9, r5, lsl #8
    1368:	0d070000 	stceq	0, cr0, [r7, #-0]
    136c:	00059a0c 	andeq	r9, r5, ip, lsl #20
    1370:	051e0b00 	ldreq	r0, [lr, #-2816]	; 0xfffff500
    1374:	0b000000 	bleq	137c <shift+0x137c>
    1378:	000003a4 	andeq	r0, r0, r4, lsr #7
    137c:	7b030001 	blvc	c1388 <__bss_end+0xb7488>
    1380:	09000005 	stmdbeq	r0, {r0, r2}
    1384:	00000f56 	andeq	r0, r0, r6, asr pc
    1388:	00490405 	subeq	r0, r9, r5, lsl #8
    138c:	14070000 	strne	r0, [r7], #-0
    1390:	0005be0c 	andeq	fp, r5, ip, lsl #28
    1394:	0de70b00 			; <UNDEFINED> instruction: 0x0de70b00
    1398:	0b000000 	bleq	13a0 <shift+0x13a0>
    139c:	00000fea 	andeq	r0, r0, sl, ror #31
    13a0:	9f030001 	svcls	0x00030001
    13a4:	07000005 	streq	r0, [r0, -r5]
    13a8:	00000c4c 	andeq	r0, r0, ip, asr #24
    13ac:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
    13b0:	000005f8 	strdeq	r0, [r0], -r8
    13b4:	0003e00e 	andeq	lr, r3, lr
    13b8:	191d0700 	ldmdbne	sp, {r8, r9, sl}
    13bc:	000005f8 	strdeq	r0, [r0], -r8
    13c0:	04d50e00 	ldrbeq	r0, [r5], #3584	; 0xe00
    13c4:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
    13c8:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
    13cc:	ca0e0400 	bgt	3823d4 <__bss_end+0x3784d4>
    13d0:	0700000b 	streq	r0, [r0, -fp]
    13d4:	05fe131f 	ldrbeq	r1, [lr, #799]!	; 0x31f
    13d8:	00080000 	andeq	r0, r8, r0
    13dc:	05c30418 	strbeq	r0, [r3, #1048]	; 0x418
    13e0:	04180000 	ldreq	r0, [r8], #-0
    13e4:	000004c9 	andeq	r0, r0, r9, asr #9
    13e8:	0005810d 	andeq	r8, r5, sp, lsl #2
    13ec:	22071400 	andcs	r1, r7, #0, 8
    13f0:	00088607 	andeq	r8, r8, r7, lsl #12
    13f4:	08410e00 	stmdaeq	r1, {r9, sl, fp}^
    13f8:	26070000 	strcs	r0, [r7], -r0
    13fc:	00006512 	andeq	r6, r0, r2, lsl r5
    1400:	820e0000 	andhi	r0, lr, #0
    1404:	07000004 	streq	r0, [r0, -r4]
    1408:	05f81d29 	ldrbeq	r1, [r8, #3369]!	; 0xd29
    140c:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1410:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1414:	f81d2c07 			; <UNDEFINED> instruction: 0xf81d2c07
    1418:	08000005 	stmdaeq	r0, {r0, r2}
    141c:	000cfe1b 	andeq	pc, ip, fp, lsl lr	; <UNPREDICTABLE>
    1420:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
    1424:	00000c29 	andeq	r0, r0, r9, lsr #24
    1428:	0000064c 	andeq	r0, r0, ip, asr #12
    142c:	00000657 	andeq	r0, r0, r7, asr r6
    1430:	00088b10 	andeq	r8, r8, r0, lsl fp
    1434:	05f81100 	ldrbeq	r1, [r8, #256]!	; 0x100
    1438:	1c000000 	stcne	0, cr0, [r0], {-0}
    143c:	00000be2 	andeq	r0, r0, r2, ror #23
    1440:	e50e3107 	str	r3, [lr, #-263]	; 0xfffffef9
    1444:	d5000003 	strle	r0, [r0, #-3]
    1448:	6f000003 	svcvs	0x00000003
    144c:	7a000006 	bvc	146c <shift+0x146c>
    1450:	10000006 	andne	r0, r0, r6
    1454:	0000088b 	andeq	r0, r0, fp, lsl #17
    1458:	0005fe11 	andeq	pc, r5, r1, lsl lr	; <UNPREDICTABLE>
    145c:	5f130000 	svcpl	0x00130000
    1460:	0700000c 	streq	r0, [r0, -ip]
    1464:	0ba51d35 	bleq	fe948940 <__bss_end+0xfe93ea40>
    1468:	05f80000 	ldrbeq	r0, [r8, #0]!
    146c:	93020000 	movwls	r0, #8192	; 0x2000
    1470:	99000006 	stmdbls	r0, {r1, r2}
    1474:	10000006 	andne	r0, r0, r6
    1478:	0000088b 	andeq	r0, r0, fp, lsl #17
    147c:	07d51300 	ldrbeq	r1, [r5, r0, lsl #6]
    1480:	37070000 	strcc	r0, [r7, -r0]
    1484:	000a221d 	andeq	r2, sl, sp, lsl r2
    1488:	0005f800 	andeq	pc, r5, r0, lsl #16
    148c:	06b20200 	ldrteq	r0, [r2], r0, lsl #4
    1490:	06b80000 	ldrteq	r0, [r8], r0
    1494:	8b100000 	blhi	40149c <__bss_end+0x3f759c>
    1498:	00000008 	andeq	r0, r0, r8
    149c:	0008e91d 	andeq	lr, r8, sp, lsl r9
    14a0:	31390700 	teqcc	r9, r0, lsl #14
    14a4:	000008a4 	andeq	r0, r0, r4, lsr #17
    14a8:	8113020c 	tsthi	r3, ip, lsl #4
    14ac:	07000005 	streq	r0, [r0, -r5]
    14b0:	0da1093c 			; <UNDEFINED> instruction: 0x0da1093c
    14b4:	088b0000 	stmeq	fp, {}	; <UNPREDICTABLE>
    14b8:	df010000 	svcle	0x00010000
    14bc:	e5000006 	str	r0, [r0, #-6]
    14c0:	10000006 	andne	r0, r0, r6
    14c4:	0000088b 	andeq	r0, r0, fp, lsl #17
    14c8:	05331300 	ldreq	r1, [r3, #-768]!	; 0xfffffd00
    14cc:	3f070000 	svccc	0x00070000
    14d0:	000cd312 	andeq	sp, ip, r2, lsl r3
    14d4:	00006500 	andeq	r6, r0, r0, lsl #10
    14d8:	06fe0100 	ldrbteq	r0, [lr], r0, lsl #2
    14dc:	07130000 	ldreq	r0, [r3, -r0]
    14e0:	8b100000 	blhi	4014e8 <__bss_end+0x3f75e8>
    14e4:	11000008 	tstne	r0, r8
    14e8:	000008ad 	andeq	r0, r0, sp, lsr #17
    14ec:	00007611 	andeq	r7, r0, r1, lsl r6
    14f0:	03d51100 	bicseq	r1, r5, #0, 2
    14f4:	14000000 	strne	r0, [r0], #-0
    14f8:	00000bf1 	strdeq	r0, [r0], -r1
    14fc:	9e0e4207 	cdpls	2, 0, cr4, cr14, cr7, {0}
    1500:	01000009 	tsteq	r0, r9
    1504:	00000728 	andeq	r0, r0, r8, lsr #14
    1508:	0000072e 	andeq	r0, r0, lr, lsr #14
    150c:	00088b10 	andeq	r8, r8, r0, lsl fp
    1510:	69130000 	ldmdbvs	r3, {}	; <UNPREDICTABLE>
    1514:	07000007 	streq	r0, [r0, -r7]
    1518:	049f1745 	ldreq	r1, [pc], #1861	; 1520 <shift+0x1520>
    151c:	05fe0000 	ldrbeq	r0, [lr, #0]!
    1520:	47010000 	strmi	r0, [r1, -r0]
    1524:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
    1528:	10000007 	andne	r0, r0, r7
    152c:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    1530:	04da1300 	ldrbeq	r1, [sl], #768	; 0x300
    1534:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
    1538:	000b6217 	andeq	r6, fp, r7, lsl r2
    153c:	0005fe00 	andeq	pc, r5, r0, lsl #28
    1540:	07660100 	strbeq	r0, [r6, -r0, lsl #2]!
    1544:	07710000 	ldrbeq	r0, [r1, -r0]!
    1548:	b3100000 	tstlt	r0, #0
    154c:	11000008 	tstne	r0, r8
    1550:	00000065 	andeq	r0, r0, r5, rrx
    1554:	0d451400 	cfstrdeq	mvd1, [r5, #-0]
    1558:	4b070000 	blmi	1c1560 <__bss_end+0x1b7660>
    155c:	000bfa0e 	andeq	pc, fp, lr, lsl #20
    1560:	07860100 	streq	r0, [r6, r0, lsl #2]
    1564:	078c0000 	streq	r0, [ip, r0]
    1568:	8b100000 	blhi	401570 <__bss_end+0x3f7670>
    156c:	00000008 	andeq	r0, r0, r8
    1570:	000be213 	andeq	lr, fp, r3, lsl r2
    1574:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
    1578:	0000068f 	andeq	r0, r0, pc, lsl #13
    157c:	000003d5 	ldrdeq	r0, [r0], -r5
    1580:	0007a501 	andeq	sl, r7, r1, lsl #10
    1584:	0007b000 	andeq	fp, r7, r0
    1588:	088b1000 	stmeq	fp, {ip}
    158c:	65110000 	ldrvs	r0, [r1, #-0]
    1590:	00000000 	andeq	r0, r0, r0
    1594:	00077d13 	andeq	r7, r7, r3, lsl sp
    1598:	12500700 	subsne	r0, r0, #0, 14
    159c:	000009bf 			; <UNDEFINED> instruction: 0x000009bf
    15a0:	00000065 	andeq	r0, r0, r5, rrx
    15a4:	0007c901 	andeq	ip, r7, r1, lsl #18
    15a8:	0007d400 	andeq	sp, r7, r0, lsl #8
    15ac:	088b1000 	stmeq	fp, {ip}
    15b0:	04110000 	ldreq	r0, [r1], #-0
    15b4:	00000004 	andeq	r0, r0, r4
    15b8:	00044b13 	andeq	r4, r4, r3, lsl fp
    15bc:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
    15c0:	00000716 	andeq	r0, r0, r6, lsl r7
    15c4:	000003d5 	ldrdeq	r0, [r0], -r5
    15c8:	0007ed01 	andeq	lr, r7, r1, lsl #26
    15cc:	0007f800 	andeq	pc, r7, r0, lsl #16
    15d0:	088b1000 	stmeq	fp, {ip}
    15d4:	65110000 	ldrvs	r0, [r1, #-0]
    15d8:	00000000 	andeq	r0, r0, r0
    15dc:	0007af14 	andeq	sl, r7, r4, lsl pc
    15e0:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
    15e4:	00000c6b 	andeq	r0, r0, fp, ror #24
    15e8:	00080d01 	andeq	r0, r8, r1, lsl #26
    15ec:	00082c00 	andeq	r2, r8, r0, lsl #24
    15f0:	088b1000 	stmeq	fp, {ip}
    15f4:	10110000 	andsne	r0, r1, r0
    15f8:	11000001 	tstne	r0, r1
    15fc:	00000065 	andeq	r0, r0, r5, rrx
    1600:	00006511 	andeq	r6, r0, r1, lsl r5
    1604:	00651100 	rsbeq	r1, r5, r0, lsl #2
    1608:	b9110000 	ldmdblt	r1, {}	; <UNPREDICTABLE>
    160c:	00000008 	andeq	r0, r0, r8
    1610:	000b8f14 	andeq	r8, fp, r4, lsl pc
    1614:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
    1618:	000005ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    161c:	00084101 	andeq	r4, r8, r1, lsl #2
    1620:	00086000 	andeq	r6, r8, r0
    1624:	088b1000 	stmeq	fp, {ip}
    1628:	47110000 	ldrmi	r0, [r1, -r0]
    162c:	11000001 	tstne	r0, r1
    1630:	00000065 	andeq	r0, r0, r5, rrx
    1634:	00006511 	andeq	r6, r0, r1, lsl r5
    1638:	00651100 	rsbeq	r1, r5, r0, lsl #2
    163c:	b9110000 	ldmdblt	r1, {}	; <UNPREDICTABLE>
    1640:	00000008 	andeq	r0, r0, r8
    1644:	00055b15 	andeq	r5, r5, r5, lsl fp
    1648:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
    164c:	000005bc 			; <UNDEFINED> instruction: 0x000005bc
    1650:	000003d5 	ldrdeq	r0, [r0], -r5
    1654:	00087501 	andeq	r7, r8, r1, lsl #10
    1658:	088b1000 	stmeq	fp, {ip}
    165c:	7b110000 	blvc	441664 <__bss_end+0x437764>
    1660:	11000005 	tstne	r0, r5
    1664:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    1668:	04030000 	streq	r0, [r3], #-0
    166c:	18000006 	stmdane	r0, {r1, r2}
    1670:	00060404 	andeq	r0, r6, r4, lsl #8
    1674:	05f81e00 	ldrbeq	r1, [r8, #3584]!	; 0xe00
    1678:	089e0000 	ldmeq	lr, {}	; <UNPREDICTABLE>
    167c:	08a40000 	stmiaeq	r4!, {}	; <UNPREDICTABLE>
    1680:	8b100000 	blhi	401688 <__bss_end+0x3f7788>
    1684:	00000008 	andeq	r0, r0, r8
    1688:	0006041f 	andeq	r0, r6, pc, lsl r4
    168c:	00089100 	andeq	r9, r8, r0, lsl #2
    1690:	57041800 	strpl	r1, [r4, -r0, lsl #16]
    1694:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1698:	00088604 	andeq	r8, r8, r4, lsl #12
    169c:	cc042000 	stcgt	0, cr2, [r4], {-0}
    16a0:	21000000 	mrscs	r0, (UNDEF: 0)
    16a4:	08f71a04 	ldmeq	r7!, {r2, r9, fp, ip}^
    16a8:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
    16ac:	00060419 	andeq	r0, r6, r9, lsl r4
    16b0:	092e0600 	stmdbeq	lr!, {r9, sl}
    16b4:	04080000 	streq	r0, [r8], #-0
    16b8:	0008e611 	andeq	lr, r8, r1, lsl r6
    16bc:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
    16c0:	0200009e 	andeq	r0, r0, #158	; 0x9e
    16c4:	17b70404 	ldrne	r0, [r7, r4, lsl #8]!
    16c8:	df030000 	svcle	0x00030000
    16cc:	16000008 	strne	r0, [r0], -r8
    16d0:	0000002c 	andeq	r0, r0, ip, lsr #32
    16d4:	000008fb 	strdeq	r0, [r0], -fp
    16d8:	00007617 	andeq	r7, r0, r7, lsl r6
    16dc:	03000900 	movweq	r0, #2304	; 0x900
    16e0:	000008eb 	andeq	r0, r0, fp, ror #17
    16e4:	000e9e22 	andeq	r9, lr, r2, lsr #28
    16e8:	0ca40100 	stfeqs	f0, [r4]
    16ec:	000008fb 	strdeq	r0, [r0], -fp
    16f0:	9e900305 	cdpls	3, 9, cr0, cr0, cr5, {0}
    16f4:	00230000 	eoreq	r0, r3, r0
    16f8:	0100000e 	tsteq	r0, lr
    16fc:	0f4a0aa6 	svceq	0x004a0aa6
    1700:	00650000 	rsbeq	r0, r5, r0
    1704:	89a40000 	stmibhi	r4!, {}	; <UNPREDICTABLE>
    1708:	00b00000 	adcseq	r0, r0, r0
    170c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1710:	00000970 	andeq	r0, r0, r0, ror r9
    1714:	001d4624 	andseq	r4, sp, r4, lsr #12
    1718:	1ba60100 	blne	fe981b20 <__bss_end+0xfe977c20>
    171c:	000003e2 	andeq	r0, r0, r2, ror #7
    1720:	7fac9103 	svcvc	0x00ac9103
    1724:	000fd624 	andeq	sp, pc, r4, lsr #12
    1728:	2aa60100 	bcs	fe981b30 <__bss_end+0xfe977c30>
    172c:	00000065 	andeq	r0, r0, r5, rrx
    1730:	7fa89103 	svcvc	0x00a89103
    1734:	000f3222 	andeq	r3, pc, r2, lsr #4
    1738:	0aa80100 	beq	fea01b40 <__bss_end+0xfe9f7c40>
    173c:	00000970 	andeq	r0, r0, r0, ror r9
    1740:	7fb49103 	svcvc	0x00b49103
    1744:	000dfb22 	andeq	pc, sp, r2, lsr #22
    1748:	09ac0100 	stmibeq	ip!, {r8}
    174c:	00000049 	andeq	r0, r0, r9, asr #32
    1750:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1754:	00002516 	andeq	r2, r0, r6, lsl r5
    1758:	00098000 	andeq	r8, r9, r0
    175c:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1760:	003f0000 	eorseq	r0, pc, r0
    1764:	000fb525 	andeq	fp, pc, r5, lsr #10
    1768:	0a980100 	beq	fe601b70 <__bss_end+0xfe5f7c70>
    176c:	00000ff8 	strdeq	r0, [r0], -r8
    1770:	00000065 	andeq	r0, r0, r5, rrx
    1774:	00008968 	andeq	r8, r0, r8, ror #18
    1778:	0000003c 	andeq	r0, r0, ip, lsr r0
    177c:	09bd9c01 	ldmibeq	sp!, {r0, sl, fp, ip, pc}
    1780:	72260000 	eorvc	r0, r6, #0
    1784:	01007165 	tsteq	r0, r5, ror #2
    1788:	05be209a 	ldreq	r2, [lr, #154]!	; 0x9a
    178c:	91020000 	mrsls	r0, (UNDEF: 2)
    1790:	0f3f2274 	svceq	0x003f2274
    1794:	9b010000 	blls	4179c <__bss_end+0x3789c>
    1798:	0000650e 	andeq	r6, r0, lr, lsl #10
    179c:	70910200 	addsvc	r0, r1, r0, lsl #4
    17a0:	0ec92700 	cdpeq	7, 12, cr2, cr9, cr0, {0}
    17a4:	8f010000 	svchi	0x00010000
    17a8:	000e2806 	andeq	r2, lr, r6, lsl #16
    17ac:	00892c00 	addeq	r2, r9, r0, lsl #24
    17b0:	00003c00 	andeq	r3, r0, r0, lsl #24
    17b4:	f69c0100 			; <UNDEFINED> instruction: 0xf69c0100
    17b8:	24000009 	strcs	r0, [r0], #-9
    17bc:	00000e8a 	andeq	r0, r0, sl, lsl #29
    17c0:	65218f01 	strvs	r8, [r1, #-3841]!	; 0xfffff0ff
    17c4:	02000000 	andeq	r0, r0, #0
    17c8:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    17cc:	01007165 	tsteq	r0, r5, ror #2
    17d0:	05be2091 	ldreq	r2, [lr, #145]!	; 0x91
    17d4:	91020000 	mrsls	r0, (UNDEF: 2)
    17d8:	6b250074 	blvs	9419b0 <__bss_end+0x937ab0>
    17dc:	0100000f 	tsteq	r0, pc
    17e0:	0eaf0a83 	vfmaeq.f32	s0, s31, s6
    17e4:	00650000 	rsbeq	r0, r5, r0
    17e8:	88f00000 	ldmhi	r0!, {}^	; <UNPREDICTABLE>
    17ec:	003c0000 	eorseq	r0, ip, r0
    17f0:	9c010000 	stcls	0, cr0, [r1], {-0}
    17f4:	00000a33 	andeq	r0, r0, r3, lsr sl
    17f8:	71657226 	cmnvc	r5, r6, lsr #4
    17fc:	20850100 	addcs	r0, r5, r0, lsl #2
    1800:	0000059a 	muleq	r0, sl, r5
    1804:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1808:	00000df4 	strdeq	r0, [r0], -r4
    180c:	650e8601 	strvs	r8, [lr, #-1537]	; 0xfffff9ff
    1810:	02000000 	andeq	r0, r0, #0
    1814:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1818:	0000107e 	andeq	r1, r0, lr, ror r0
    181c:	6c0a7701 	stcvs	7, cr7, [sl], {1}
    1820:	6500000e 	strvs	r0, [r0, #-14]
    1824:	b4000000 	strlt	r0, [r0], #-0
    1828:	3c000088 	stccc	0, cr0, [r0], {136}	; 0x88
    182c:	01000000 	mrseq	r0, (UNDEF: 0)
    1830:	000a709c 	muleq	sl, ip, r0
    1834:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1838:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    183c:	00059a20 	andeq	r9, r5, r0, lsr #20
    1840:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1844:	000df422 	andeq	pc, sp, r2, lsr #8
    1848:	0e7a0100 	rpweqe	f0, f2, f0
    184c:	00000065 	andeq	r0, r0, r5, rrx
    1850:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1854:	000ec325 	andeq	ip, lr, r5, lsr #6
    1858:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    185c:	00000fdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1860:	000003d5 	ldrdeq	r0, [r0], -r5
    1864:	00008860 	andeq	r8, r0, r0, ror #16
    1868:	00000054 	andeq	r0, r0, r4, asr r0
    186c:	0abc9c01 	beq	fef28878 <__bss_end+0xfef1e978>
    1870:	3f240000 	svccc	0x00240000
    1874:	0100000f 	tsteq	r0, pc
    1878:	0065156b 	rsbeq	r1, r5, fp, ror #10
    187c:	91020000 	mrsls	r0, (UNDEF: 2)
    1880:	06cd246c 	strbeq	r2, [sp], ip, ror #8
    1884:	6b010000 	blvs	4188c <__bss_end+0x3798c>
    1888:	00006525 	andeq	r6, r0, r5, lsr #10
    188c:	68910200 	ldmvs	r1, {r9}
    1890:	00107622 	andseq	r7, r0, r2, lsr #12
    1894:	0e6d0100 	poweqe	f0, f5, f0
    1898:	00000065 	andeq	r0, r0, r5, rrx
    189c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18a0:	000e3f25 	andeq	r3, lr, r5, lsr #30
    18a4:	125e0100 	subsne	r0, lr, #0, 2
    18a8:	0000102f 	andeq	r1, r0, pc, lsr #32
    18ac:	000000f2 	strdeq	r0, [r0], -r2
    18b0:	00008810 	andeq	r8, r0, r0, lsl r8
    18b4:	00000050 	andeq	r0, r0, r0, asr r0
    18b8:	0b179c01 	bleq	5e88c4 <__bss_end+0x5de9c4>
    18bc:	dd240000 	stcle	0, cr0, [r4, #-0]
    18c0:	0100000b 	tsteq	r0, fp
    18c4:	0065205e 	rsbeq	r2, r5, lr, asr r0
    18c8:	91020000 	mrsls	r0, (UNDEF: 2)
    18cc:	0f74246c 	svceq	0x0074246c
    18d0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    18d4:	0000652f 	andeq	r6, r0, pc, lsr #10
    18d8:	68910200 	ldmvs	r1, {r9}
    18dc:	0006cd24 	andeq	ip, r6, r4, lsr #26
    18e0:	3f5e0100 	svccc	0x005e0100
    18e4:	00000065 	andeq	r0, r0, r5, rrx
    18e8:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    18ec:	00001076 	andeq	r1, r0, r6, ror r0
    18f0:	f2166001 	vhadd.s16	d6, d6, d1
    18f4:	02000000 	andeq	r0, r0, #0
    18f8:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    18fc:	00000f38 	andeq	r0, r0, r8, lsr pc
    1900:	440a5201 	strmi	r5, [sl], #-513	; 0xfffffdff
    1904:	6500000e 	strvs	r0, [r0, #-14]
    1908:	cc000000 	stcgt	0, cr0, [r0], {-0}
    190c:	44000087 	strmi	r0, [r0], #-135	; 0xffffff79
    1910:	01000000 	mrseq	r0, (UNDEF: 0)
    1914:	000b639c 	muleq	fp, ip, r3
    1918:	0bdd2400 	bleq	ff74a920 <__bss_end+0xff740a20>
    191c:	52010000 	andpl	r0, r1, #0
    1920:	0000651a 	andeq	r6, r0, sl, lsl r5
    1924:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1928:	000f7424 	andeq	r7, pc, r4, lsr #8
    192c:	29520100 	ldmdbcs	r2, {r8}^
    1930:	00000065 	andeq	r0, r0, r5, rrx
    1934:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1938:	0000105e 	andeq	r1, r0, lr, asr r0
    193c:	650e5401 	strvs	r5, [lr, #-1025]	; 0xfffffbff
    1940:	02000000 	andeq	r0, r0, #0
    1944:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1948:	00001058 	andeq	r1, r0, r8, asr r0
    194c:	3a0a4501 	bcc	292d58 <__bss_end+0x288e58>
    1950:	65000010 	strvs	r0, [r0, #-16]
    1954:	7c000000 	stcvc	0, cr0, [r0], {-0}
    1958:	50000087 	andpl	r0, r0, r7, lsl #1
    195c:	01000000 	mrseq	r0, (UNDEF: 0)
    1960:	000bbe9c 	muleq	fp, ip, lr
    1964:	0bdd2400 	bleq	ff74a96c <__bss_end+0xff740a6c>
    1968:	45010000 	strmi	r0, [r1, #-0]
    196c:	00006519 	andeq	r6, r0, r9, lsl r5
    1970:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1974:	000edb24 	andeq	sp, lr, r4, lsr #22
    1978:	30450100 	subcc	r0, r5, r0, lsl #2
    197c:	00000184 	andeq	r0, r0, r4, lsl #3
    1980:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1984:	00000fa1 	andeq	r0, r0, r1, lsr #31
    1988:	bf414501 	svclt	0x00414501
    198c:	02000008 	andeq	r0, r0, #8
    1990:	76226491 			; <UNDEFINED> instruction: 0x76226491
    1994:	01000010 	tsteq	r0, r0, lsl r0
    1998:	00650e47 	rsbeq	r0, r5, r7, asr #28
    199c:	91020000 	mrsls	r0, (UNDEF: 2)
    19a0:	e1270074 	bkpt	0x7004
    19a4:	0100000d 	tsteq	r0, sp
    19a8:	0ee5063f 	mcreq	6, 7, r0, cr5, cr15, {1}
    19ac:	87500000 	ldrbhi	r0, [r0, -r0]
    19b0:	002c0000 	eoreq	r0, ip, r0
    19b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    19b8:	00000be8 	andeq	r0, r0, r8, ror #23
    19bc:	000bdd24 	andeq	sp, fp, r4, lsr #26
    19c0:	153f0100 	ldrne	r0, [pc, #-256]!	; 18c8 <shift+0x18c8>
    19c4:	00000065 	andeq	r0, r0, r5, rrx
    19c8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    19cc:	000fd025 	andeq	sp, pc, r5, lsr #32
    19d0:	0a320100 	beq	c81dd8 <__bss_end+0xc77ed8>
    19d4:	00000fa7 	andeq	r0, r0, r7, lsr #31
    19d8:	00000065 	andeq	r0, r0, r5, rrx
    19dc:	00008700 	andeq	r8, r0, r0, lsl #14
    19e0:	00000050 	andeq	r0, r0, r0, asr r0
    19e4:	0c439c01 	mcrreq	12, 0, r9, r3, cr1
    19e8:	dd240000 	stcle	0, cr0, [r4, #-0]
    19ec:	0100000b 	tsteq	r0, fp
    19f0:	00651932 	rsbeq	r1, r5, r2, lsr r9
    19f4:	91020000 	mrsls	r0, (UNDEF: 2)
    19f8:	0988246c 	stmibeq	r8, {r2, r3, r5, r6, sl, sp}
    19fc:	32010000 	andcc	r0, r1, #0
    1a00:	0003e22b 	andeq	lr, r3, fp, lsr #4
    1a04:	68910200 	ldmvs	r1, {r9}
    1a08:	000fda24 	andeq	sp, pc, r4, lsr #20
    1a0c:	3c320100 	ldfccs	f0, [r2], #-0
    1a10:	00000065 	andeq	r0, r0, r5, rrx
    1a14:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1a18:	00001029 	andeq	r1, r0, r9, lsr #32
    1a1c:	650e3401 	strvs	r3, [lr, #-1025]	; 0xfffffbff
    1a20:	02000000 	andeq	r0, r0, #0
    1a24:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1a28:	000010a0 	andeq	r1, r0, r0, lsr #1
    1a2c:	6a0a2501 	bvs	28ae38 <__bss_end+0x280f38>
    1a30:	65000010 	strvs	r0, [r0, #-16]
    1a34:	b0000000 	andlt	r0, r0, r0
    1a38:	50000086 	andpl	r0, r0, r6, lsl #1
    1a3c:	01000000 	mrseq	r0, (UNDEF: 0)
    1a40:	000c9e9c 	muleq	ip, ip, lr
    1a44:	0bdd2400 	bleq	ff74aa4c <__bss_end+0xff740b4c>
    1a48:	25010000 	strcs	r0, [r1, #-0]
    1a4c:	00006518 	andeq	r6, r0, r8, lsl r5
    1a50:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a54:	00098824 	andeq	r8, r9, r4, lsr #16
    1a58:	2a250100 	bcs	941e60 <__bss_end+0x937f60>
    1a5c:	00000ca4 	andeq	r0, r0, r4, lsr #25
    1a60:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1a64:	00000fda 	ldrdeq	r0, [r0], -sl
    1a68:	653b2501 	ldrvs	r2, [fp, #-1281]!	; 0xfffffaff
    1a6c:	02000000 	andeq	r0, r0, #0
    1a70:	11226491 			; <UNDEFINED> instruction: 0x11226491
    1a74:	0100000e 	tsteq	r0, lr
    1a78:	00650e27 	rsbeq	r0, r5, r7, lsr #28
    1a7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a80:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1a84:	00000025 	andeq	r0, r0, r5, lsr #32
    1a88:	000c9e03 	andeq	r9, ip, r3, lsl #28
    1a8c:	0f452500 	svceq	0x00452500
    1a90:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1a94:	0010b60a 	andseq	fp, r0, sl, lsl #12
    1a98:	00006500 	andeq	r6, r0, r0, lsl #10
    1a9c:	00866c00 	addeq	r6, r6, r0, lsl #24
    1aa0:	00004400 	andeq	r4, r0, r0, lsl #8
    1aa4:	f59c0100 			; <UNDEFINED> instruction: 0xf59c0100
    1aa8:	2400000c 	strcs	r0, [r0], #-12
    1aac:	00001097 	muleq	r0, r7, r0
    1ab0:	e21b1901 	ands	r1, fp, #16384	; 0x4000
    1ab4:	02000003 	andeq	r0, r0, #3
    1ab8:	65246c91 	strvs	r6, [r4, #-3217]!	; 0xfffff36f
    1abc:	01000010 	tsteq	r0, r0, lsl r0
    1ac0:	022d3519 	eoreq	r3, sp, #104857600	; 0x6400000
    1ac4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ac8:	0bdd2268 	bleq	ff74a470 <__bss_end+0xff740570>
    1acc:	1b010000 	blne	41ad4 <__bss_end+0x37bd4>
    1ad0:	0000650e 	andeq	r6, r0, lr, lsl #10
    1ad4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ad8:	0e052800 	cdpeq	8, 0, cr2, cr5, cr0, {0}
    1adc:	14010000 	strne	r0, [r1], #-0
    1ae0:	000e1706 	andeq	r1, lr, r6, lsl #14
    1ae4:	00865000 	addeq	r5, r6, r0
    1ae8:	00001c00 	andeq	r1, r0, r0, lsl #24
    1aec:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    1af0:	000010a5 	andeq	r1, r0, r5, lsr #1
    1af4:	50060e01 	andpl	r0, r6, r1, lsl #28
    1af8:	2400000e 	strcs	r0, [r0], #-14
    1afc:	2c000086 	stccs	0, cr0, [r0], {134}	; 0x86
    1b00:	01000000 	mrseq	r0, (UNDEF: 0)
    1b04:	000d359c 	muleq	sp, ip, r5
    1b08:	0e632400 	cdpeq	4, 6, cr2, cr3, cr0, {0}
    1b0c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1b10:	00004914 	andeq	r4, r0, r4, lsl r9
    1b14:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b18:	10af2900 	adcne	r2, pc, r0, lsl #18
    1b1c:	04010000 	streq	r0, [r1], #-0
    1b20:	000f270a 	andeq	r2, pc, sl, lsl #14
    1b24:	00006500 	andeq	r6, r0, r0, lsl #10
    1b28:	0085f800 	addeq	pc, r5, r0, lsl #16
    1b2c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1b30:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    1b34:	00646970 	rsbeq	r6, r4, r0, ror r9
    1b38:	650e0601 	strvs	r0, [lr, #-1537]	; 0xfffff9ff
    1b3c:	02000000 	andeq	r0, r0, #0
    1b40:	00007491 	muleq	r0, r1, r4
    1b44:	0000097b 	andeq	r0, r0, fp, ror r9
    1b48:	073b0004 	ldreq	r0, [fp, -r4]!
    1b4c:	01040000 	mrseq	r0, (UNDEF: 4)
    1b50:	000010d2 	ldrdeq	r1, [r0], -r2
    1b54:	00121404 	andseq	r1, r2, r4, lsl #8
    1b58:	000f7a00 	andeq	r7, pc, r0, lsl #20
    1b5c:	008a5400 	addeq	r5, sl, r0, lsl #8
    1b60:	00012000 	andeq	r2, r1, r0
    1b64:	00078200 	andeq	r8, r7, r0, lsl #4
    1b68:	08010200 	stmdaeq	r1, {r9}
    1b6c:	00000a1d 	andeq	r0, r0, sp, lsl sl
    1b70:	00002503 	andeq	r2, r0, r3, lsl #10
    1b74:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1b78:	00000a54 	andeq	r0, r0, r4, asr sl
    1b7c:	000aa204 	andeq	sl, sl, r4, lsl #4
    1b80:	07050200 	streq	r0, [r5, -r0, lsl #4]
    1b84:	00000049 	andeq	r0, r0, r9, asr #32
    1b88:	00003803 	andeq	r3, r0, r3, lsl #16
    1b8c:	05040500 	streq	r0, [r4, #-1280]	; 0xfffffb00
    1b90:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1b94:	1f050802 	svcne	0x00050802
    1b98:	02000003 	andeq	r0, r0, #3
    1b9c:	0a140801 	beq	503ba8 <__bss_end+0x4f9ca8>
    1ba0:	02020000 	andeq	r0, r2, #0
    1ba4:	0007c207 	andeq	ip, r7, r7, lsl #4
    1ba8:	0aa10400 	beq	fe842bb0 <__bss_end+0xfe838cb0>
    1bac:	0a020000 	beq	81bb4 <__bss_end+0x77cb4>
    1bb0:	00007607 	andeq	r7, r0, r7, lsl #12
    1bb4:	00650300 	rsbeq	r0, r5, r0, lsl #6
    1bb8:	04020000 	streq	r0, [r2], #-0
    1bbc:	00047507 	andeq	r7, r4, r7, lsl #10
    1bc0:	07080200 	streq	r0, [r8, -r0, lsl #4]
    1bc4:	0000046b 	andeq	r0, r0, fp, ror #8
    1bc8:	0006b806 	andeq	fp, r6, r6, lsl #16
    1bcc:	130d0200 	movwne	r0, #53760	; 0xd200
    1bd0:	00000044 	andeq	r0, r0, r4, asr #32
    1bd4:	9e9c0305 	cdpls	3, 9, cr0, cr12, cr5, {0}
    1bd8:	43060000 	movwmi	r0, #24576	; 0x6000
    1bdc:	02000007 	andeq	r0, r0, #7
    1be0:	0044130e 	subeq	r1, r4, lr, lsl #6
    1be4:	03050000 	movweq	r0, #20480	; 0x5000
    1be8:	00009ea0 	andeq	r9, r0, r0, lsr #29
    1bec:	0006b706 	andeq	fp, r6, r6, lsl #14
    1bf0:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
    1bf4:	00000071 	andeq	r0, r0, r1, ror r0
    1bf8:	9ea40305 	cdpls	3, 10, cr0, cr4, cr5, {0}
    1bfc:	42060000 	andmi	r0, r6, #0
    1c00:	02000007 	andeq	r0, r0, #7
    1c04:	00711411 	rsbseq	r1, r1, r1, lsl r4
    1c08:	03050000 	movweq	r0, #20480	; 0x5000
    1c0c:	00009ea8 	andeq	r9, r0, r8, lsr #29
    1c10:	00064b07 	andeq	r4, r6, r7, lsl #22
    1c14:	06030800 	streq	r0, [r3], -r0, lsl #16
    1c18:	0000f208 	andeq	pc, r0, r8, lsl #4
    1c1c:	30720800 	rsbscc	r0, r2, r0, lsl #16
    1c20:	0e080300 	cdpeq	3, 0, cr0, cr8, cr0, {0}
    1c24:	00000065 	andeq	r0, r0, r5, rrx
    1c28:	31720800 	cmncc	r2, r0, lsl #16
    1c2c:	0e090300 	cdpeq	3, 0, cr0, cr9, cr0, {0}
    1c30:	00000065 	andeq	r0, r0, r5, rrx
    1c34:	04090004 	streq	r0, [r9], #-4
    1c38:	05000005 	streq	r0, [r0, #-5]
    1c3c:	00004904 	andeq	r4, r0, r4, lsl #18
    1c40:	0c1e0300 	ldceq	3, cr0, [lr], {-0}
    1c44:	00000129 	andeq	r0, r0, r9, lsr #2
    1c48:	000d930a 	andeq	r9, sp, sl, lsl #6
    1c4c:	d10a0000 	mrsle	r0, (UNDEF: 10)
    1c50:	0100000d 	tsteq	r0, sp
    1c54:	000d9b0a 	andeq	r9, sp, sl, lsl #22
    1c58:	2c0a0200 	sfmcs	f0, 4, [sl], {-0}
    1c5c:	03000008 	movweq	r0, #8
    1c60:	00098f0a 	andeq	r8, r9, sl, lsl #30
    1c64:	800a0400 	andhi	r0, sl, r0, lsl #8
    1c68:	05000006 	streq	r0, [r0, #-6]
    1c6c:	0d080900 	vstreq.16	s0, [r8, #-0]	; <UNPREDICTABLE>
    1c70:	04050000 	streq	r0, [r5], #-0
    1c74:	00000049 	andeq	r0, r0, r9, asr #32
    1c78:	660c4403 	strvs	r4, [ip], -r3, lsl #8
    1c7c:	0a000001 	beq	1c88 <shift+0x1c88>
    1c80:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    1c84:	05190a00 	ldreq	r0, [r9, #-2560]	; 0xfffff600
    1c88:	0a010000 	beq	41c90 <__bss_end+0x37d90>
    1c8c:	00000969 	andeq	r0, r0, r9, ror #18
    1c90:	0d630a02 	vstmdbeq	r3!, {s1-s2}
    1c94:	0a030000 	beq	c1c9c <__bss_end+0xb7d9c>
    1c98:	00000ddb 	ldrdeq	r0, [r0], -fp
    1c9c:	09190a04 	ldmdbeq	r9, {r2, r9, fp}
    1ca0:	0a050000 	beq	141ca8 <__bss_end+0x137da8>
    1ca4:	000007e2 	andeq	r0, r0, r2, ror #15
    1ca8:	20060006 	andcs	r0, r6, r6
    1cac:	04000009 	streq	r0, [r0], #-9
    1cb0:	00711405 	rsbseq	r1, r1, r5, lsl #8
    1cb4:	03050000 	movweq	r0, #20480	; 0x5000
    1cb8:	00009eac 	andeq	r9, r0, ip, lsr #29
    1cbc:	00094506 	andeq	r4, r9, r6, lsl #10
    1cc0:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
    1cc4:	00000071 	andeq	r0, r0, r1, ror r0
    1cc8:	9eb00305 	cdpls	3, 11, cr0, cr0, cr5, {0}
    1ccc:	03060000 	movweq	r0, #24576	; 0x6000
    1cd0:	05000009 	streq	r0, [r0, #-9]
    1cd4:	00711a07 	rsbseq	r1, r1, r7, lsl #20
    1cd8:	03050000 	movweq	r0, #20480	; 0x5000
    1cdc:	00009eb4 			; <UNDEFINED> instruction: 0x00009eb4
    1ce0:	00054906 	andeq	r4, r5, r6, lsl #18
    1ce4:	1a090500 	bne	2430ec <__bss_end+0x2391ec>
    1ce8:	00000071 	andeq	r0, r0, r1, ror r0
    1cec:	9eb80305 	cdpls	3, 11, cr0, cr8, cr5, {0}
    1cf0:	06060000 	streq	r0, [r6], -r0
    1cf4:	0500000a 	streq	r0, [r0, #-10]
    1cf8:	00711a0b 	rsbseq	r1, r1, fp, lsl #20
    1cfc:	03050000 	movweq	r0, #20480	; 0x5000
    1d00:	00009ebc 			; <UNDEFINED> instruction: 0x00009ebc
    1d04:	00079106 	andeq	r9, r7, r6, lsl #2
    1d08:	1a0d0500 	bne	343110 <__bss_end+0x339210>
    1d0c:	00000071 	andeq	r0, r0, r1, ror r0
    1d10:	9ec00305 	cdpls	3, 12, cr0, cr0, cr5, {0}
    1d14:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
    1d18:	05000006 	streq	r0, [r0, #-6]
    1d1c:	00711a0f 	rsbseq	r1, r1, pc, lsl #20
    1d20:	03050000 	movweq	r0, #20480	; 0x5000
    1d24:	00009ec4 	andeq	r9, r0, r4, asr #29
    1d28:	000b1e09 	andeq	r1, fp, r9, lsl #28
    1d2c:	49040500 	stmdbmi	r4, {r8, sl}
    1d30:	05000000 	streq	r0, [r0, #-0]
    1d34:	02090c1b 	andeq	r0, r9, #6912	; 0x1b00
    1d38:	4c0a0000 	stcmi	0, cr0, [sl], {-0}
    1d3c:	0000000b 	andeq	r0, r0, fp
    1d40:	000d880a 	andeq	r8, sp, sl, lsl #16
    1d44:	640a0100 	strvs	r0, [sl], #-256	; 0xffffff00
    1d48:	02000009 	andeq	r0, r0, #9
    1d4c:	09ec0b00 	stmibeq	ip!, {r8, r9, fp}^
    1d50:	480c0000 	stmdami	ip, {}	; <UNPREDICTABLE>
    1d54:	9000000a 	andls	r0, r0, sl
    1d58:	7c076305 	stcvc	3, cr6, [r7], {5}
    1d5c:	07000003 	streq	r0, [r0, -r3]
    1d60:	00000d37 	andeq	r0, r0, r7, lsr sp
    1d64:	10670524 	rsbne	r0, r7, r4, lsr #10
    1d68:	00000296 	muleq	r0, r6, r2
    1d6c:	001d460d 	andseq	r4, sp, sp, lsl #12
    1d70:	12690500 	rsbne	r0, r9, #0, 10
    1d74:	0000037c 	andeq	r0, r0, ip, ror r3
    1d78:	04f80d00 	ldrbteq	r0, [r8], #3328	; 0xd00
    1d7c:	6b050000 	blvs	141d84 <__bss_end+0x137e84>
    1d80:	00038c12 	andeq	r8, r3, r2, lsl ip
    1d84:	410d1000 	mrsmi	r1, (UNDEF: 13)
    1d88:	0500000b 	streq	r0, [r0, #-11]
    1d8c:	0065166d 	rsbeq	r1, r5, sp, ror #12
    1d90:	0d140000 	ldceq	0, cr0, [r4, #-0]
    1d94:	00000542 	andeq	r0, r0, r2, asr #10
    1d98:	931c7005 	tstls	ip, #5
    1d9c:	18000003 	stmdane	r0, {r0, r1}
    1da0:	0009fd0d 	andeq	pc, r9, sp, lsl #26
    1da4:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
    1da8:	00000393 	muleq	r0, r3, r3
    1dac:	04d50d1c 	ldrbeq	r0, [r5], #3356	; 0xd1c
    1db0:	75050000 	strvc	r0, [r5, #-0]
    1db4:	0003931c 	andeq	r9, r3, ip, lsl r3
    1db8:	c20e2000 	andgt	r2, lr, #0
    1dbc:	05000006 	streq	r0, [r0, #-6]
    1dc0:	041b1c77 	ldreq	r1, [fp], #-3191	; 0xfffff389
    1dc4:	03930000 	orrseq	r0, r3, #0
    1dc8:	028a0000 	addeq	r0, sl, #0
    1dcc:	930f0000 	movwls	r0, #61440	; 0xf000
    1dd0:	10000003 	andne	r0, r0, r3
    1dd4:	00000399 	muleq	r0, r9, r3
    1dd8:	a7070000 	strge	r0, [r7, -r0]
    1ddc:	18000005 	stmdane	r0, {r0, r2}
    1de0:	cb107b05 	blgt	4209fc <__bss_end+0x416afc>
    1de4:	0d000002 	stceq	0, cr0, [r0, #-8]
    1de8:	00001d46 	andeq	r1, r0, r6, asr #26
    1dec:	7c127e05 	ldcvc	14, cr7, [r2], {5}
    1df0:	00000003 	andeq	r0, r0, r3
    1df4:	0004ed0d 	andeq	lr, r4, sp, lsl #26
    1df8:	19800500 	stmibne	r0, {r8, sl}
    1dfc:	00000399 	muleq	r0, r9, r3
    1e00:	0d690d10 	stcleq	13, cr0, [r9, #-64]!	; 0xffffffc0
    1e04:	82050000 	andhi	r0, r5, #0
    1e08:	0003a421 	andeq	sl, r3, r1, lsr #8
    1e0c:	03001400 	movweq	r1, #1024	; 0x400
    1e10:	00000296 	muleq	r0, r6, r2
    1e14:	0008c311 	andeq	ip, r8, r1, lsl r3
    1e18:	21860500 	orrcs	r0, r6, r0, lsl #10
    1e1c:	000003aa 	andeq	r0, r0, sl, lsr #7
    1e20:	00074d11 	andeq	r4, r7, r1, lsl sp
    1e24:	1f880500 	svcne	0x00880500
    1e28:	00000071 	andeq	r0, r0, r1, ror r0
    1e2c:	000a870d 	andeq	r8, sl, sp, lsl #14
    1e30:	178b0500 	strne	r0, [fp, r0, lsl #10]
    1e34:	0000021b 	andeq	r0, r0, fp, lsl r2
    1e38:	08320d00 	ldmdaeq	r2!, {r8, sl, fp}
    1e3c:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
    1e40:	00021b17 	andeq	r1, r2, r7, lsl fp
    1e44:	5f0d2400 	svcpl	0x000d2400
    1e48:	05000007 	streq	r0, [r0, #-7]
    1e4c:	021b178f 	andseq	r1, fp, #37486592	; 0x23c0000
    1e50:	0d480000 	stcleq	0, cr0, [r8, #-0]
    1e54:	00000dbb 			; <UNDEFINED> instruction: 0x00000dbb
    1e58:	1b179005 	blne	5e5e74 <__bss_end+0x5dbf74>
    1e5c:	6c000002 	stcvs	0, cr0, [r0], {2}
    1e60:	000a4812 	andeq	r4, sl, r2, lsl r8
    1e64:	09930500 	ldmibeq	r3, {r8, sl}
    1e68:	00000592 	muleq	r0, r2, r5
    1e6c:	000003b5 			; <UNDEFINED> instruction: 0x000003b5
    1e70:	00033501 	andeq	r3, r3, r1, lsl #10
    1e74:	00033b00 	andeq	r3, r3, r0, lsl #22
    1e78:	03b50f00 			; <UNDEFINED> instruction: 0x03b50f00
    1e7c:	13000000 	movwne	r0, #0
    1e80:	000008b8 			; <UNDEFINED> instruction: 0x000008b8
    1e84:	ff0e9605 			; <UNDEFINED> instruction: 0xff0e9605
    1e88:	01000007 	tsteq	r0, r7
    1e8c:	00000350 	andeq	r0, r0, r0, asr r3
    1e90:	00000356 	andeq	r0, r0, r6, asr r3
    1e94:	0003b50f 	andeq	fp, r3, pc, lsl #10
    1e98:	ba140000 	blt	501ea0 <__bss_end+0x4f7fa0>
    1e9c:	05000003 	streq	r0, [r0, #-3]
    1ea0:	0b031099 	bleq	c610c <__bss_end+0xbc20c>
    1ea4:	03bb0000 			; <UNDEFINED> instruction: 0x03bb0000
    1ea8:	6b010000 	blvs	41eb0 <__bss_end+0x37fb0>
    1eac:	0f000003 	svceq	0x00000003
    1eb0:	000003b5 			; <UNDEFINED> instruction: 0x000003b5
    1eb4:	00039910 	andeq	r9, r3, r0, lsl r9
    1eb8:	01e41000 	mvneq	r1, r0
    1ebc:	00000000 	andeq	r0, r0, r0
    1ec0:	00002515 	andeq	r2, r0, r5, lsl r5
    1ec4:	00038c00 	andeq	r8, r3, r0, lsl #24
    1ec8:	00761600 	rsbseq	r1, r6, r0, lsl #12
    1ecc:	000f0000 	andeq	r0, pc, r0
    1ed0:	3c020102 	stfccs	f0, [r2], {2}
    1ed4:	17000008 	strne	r0, [r0, -r8]
    1ed8:	00021b04 	andeq	r1, r2, r4, lsl #22
    1edc:	2c041700 	stccs	7, cr1, [r4], {-0}
    1ee0:	0b000000 	bleq	1ee8 <shift+0x1ee8>
    1ee4:	00000d75 	andeq	r0, r0, r5, ror sp
    1ee8:	039f0417 	orrseq	r0, pc, #385875968	; 0x17000000
    1eec:	cb150000 	blgt	541ef4 <__bss_end+0x537ff4>
    1ef0:	b5000002 	strlt	r0, [r0, #-2]
    1ef4:	18000003 	stmdane	r0, {r0, r1}
    1ef8:	0e041700 	cdpeq	7, 0, cr1, cr4, cr0, {0}
    1efc:	17000002 	strne	r0, [r0, -r2]
    1f00:	00020904 	andeq	r0, r2, r4, lsl #18
    1f04:	0a8d1900 	beq	fe34830c <__bss_end+0xfe33e40c>
    1f08:	9c050000 	stcls	0, cr0, [r5], {-0}
    1f0c:	00020e14 	andeq	r0, r2, r4, lsl lr
    1f10:	06fd0600 	ldrbteq	r0, [sp], r0, lsl #12
    1f14:	04060000 	streq	r0, [r6], #-0
    1f18:	00007114 	andeq	r7, r0, r4, lsl r1
    1f1c:	c8030500 	stmdagt	r3, {r8, sl}
    1f20:	0600009e 			; <UNDEFINED> instruction: 0x0600009e
    1f24:	000003af 	andeq	r0, r0, pc, lsr #7
    1f28:	71140706 	tstvc	r4, r6, lsl #14
    1f2c:	05000000 	streq	r0, [r0, #-0]
    1f30:	009ecc03 	addseq	ip, lr, r3, lsl #24
    1f34:	056e0600 	strbeq	r0, [lr, #-1536]!	; 0xfffffa00
    1f38:	0a060000 	beq	181f40 <__bss_end+0x178040>
    1f3c:	00007114 	andeq	r7, r0, r4, lsl r1
    1f40:	d0030500 	andle	r0, r3, r0, lsl #10
    1f44:	0900009e 	stmdbeq	r0, {r1, r2, r3, r4, r7}
    1f48:	0000087f 	andeq	r0, r0, pc, ror r8
    1f4c:	00490405 	subeq	r0, r9, r5, lsl #8
    1f50:	0d060000 	stceq	0, cr0, [r6, #-0]
    1f54:	00043a0c 	andeq	r3, r4, ip, lsl #20
    1f58:	654e1a00 	strbvs	r1, [lr, #-2560]	; 0xfffff600
    1f5c:	0a000077 	beq	2140 <shift+0x2140>
    1f60:	00000876 	andeq	r0, r0, r6, ror r8
    1f64:	0a990a01 	beq	fe644770 <__bss_end+0xfe63a870>
    1f68:	0a020000 	beq	81f70 <__bss_end+0x78070>
    1f6c:	0000084b 	andeq	r0, r0, fp, asr #16
    1f70:	081e0a03 	ldmdaeq	lr, {r0, r1, r9, fp}
    1f74:	0a040000 	beq	101f7c <__bss_end+0xf807c>
    1f78:	0000096f 	andeq	r0, r0, pc, ror #18
    1f7c:	73070005 	movwvc	r0, #28677	; 0x7005
    1f80:	10000006 	andne	r0, r0, r6
    1f84:	79081b06 	stmdbvc	r8, {r1, r2, r8, r9, fp, ip}
    1f88:	08000004 	stmdaeq	r0, {r2}
    1f8c:	0600726c 	streq	r7, [r0], -ip, ror #4
    1f90:	0479131d 	ldrbteq	r1, [r9], #-797	; 0xfffffce3
    1f94:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1f98:	06007073 			; <UNDEFINED> instruction: 0x06007073
    1f9c:	0479131e 	ldrbteq	r1, [r9], #-798	; 0xfffffce2
    1fa0:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
    1fa4:	06006370 			; <UNDEFINED> instruction: 0x06006370
    1fa8:	0479131f 	ldrbteq	r1, [r9], #-799	; 0xfffffce1
    1fac:	0d080000 	stceq	0, cr0, [r8, #-0]
    1fb0:	00000689 	andeq	r0, r0, r9, lsl #13
    1fb4:	79132006 	ldmdbvc	r3, {r1, r2, sp}
    1fb8:	0c000004 	stceq	0, cr0, [r0], {4}
    1fbc:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1fc0:	00000470 	andeq	r0, r0, r0, ror r4
    1fc4:	00040e07 	andeq	r0, r4, r7, lsl #28
    1fc8:	28067000 	stmdacs	r6, {ip, sp, lr}
    1fcc:	00051008 	andeq	r1, r5, r8
    1fd0:	0dc50d00 	stcleq	13, cr0, [r5]
    1fd4:	2a060000 	bcs	181fdc <__bss_end+0x1780dc>
    1fd8:	00043a12 	andeq	r3, r4, r2, lsl sl
    1fdc:	70080000 	andvc	r0, r8, r0
    1fe0:	06006469 	streq	r6, [r0], -r9, ror #8
    1fe4:	0076122b 	rsbseq	r1, r6, fp, lsr #4
    1fe8:	0d100000 	ldceq	0, cr0, [r0, #-0]
    1fec:	00001739 	andeq	r1, r0, r9, lsr r7
    1ff0:	03112c06 	tsteq	r1, #1536	; 0x600
    1ff4:	14000004 	strne	r0, [r0], #-4
    1ff8:	0008940d 	andeq	r9, r8, sp, lsl #8
    1ffc:	122d0600 	eorne	r0, sp, #0, 12
    2000:	00000076 	andeq	r0, r0, r6, ror r0
    2004:	08a20d18 	stmiaeq	r2!, {r3, r4, r8, sl, fp}
    2008:	2e060000 	cdpcs	0, 0, cr0, cr6, cr0, {0}
    200c:	00007612 	andeq	r7, r0, r2, lsl r6
    2010:	570d1c00 	strpl	r1, [sp, -r0, lsl #24]
    2014:	06000006 	streq	r0, [r0], -r6
    2018:	05100c2f 	ldreq	r0, [r0, #-3119]	; 0xfffff3d1
    201c:	0d200000 	stceq	0, cr0, [r0, #-0]
    2020:	000008cf 	andeq	r0, r0, pc, asr #17
    2024:	49093006 	stmdbmi	r9, {r1, r2, ip, sp}
    2028:	60000000 	andvs	r0, r0, r0
    202c:	000b560d 	andeq	r5, fp, sp, lsl #12
    2030:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    2034:	00000065 	andeq	r0, r0, r5, rrx
    2038:	06d60d64 	ldrbeq	r0, [r6], r4, ror #26
    203c:	33060000 	movwcc	r0, #24576	; 0x6000
    2040:	0000650e 	andeq	r6, r0, lr, lsl #10
    2044:	cd0d6800 	stcgt	8, cr6, [sp, #-0]
    2048:	06000006 	streq	r0, [r0], -r6
    204c:	00650e34 	rsbeq	r0, r5, r4, lsr lr
    2050:	006c0000 	rsbeq	r0, ip, r0
    2054:	0003bb15 	andeq	fp, r3, r5, lsl fp
    2058:	00052000 	andeq	r2, r5, r0
    205c:	00761600 	rsbseq	r1, r6, r0, lsl #12
    2060:	000f0000 	andeq	r0, pc, r0
    2064:	000d2806 	andeq	r2, sp, r6, lsl #16
    2068:	140a0700 	strne	r0, [sl], #-1792	; 0xfffff900
    206c:	00000071 	andeq	r0, r0, r1, ror r0
    2070:	9ed40305 	cdpls	3, 13, cr0, cr4, cr5, {0}
    2074:	53090000 	movwpl	r0, #36864	; 0x9000
    2078:	05000008 	streq	r0, [r0, #-8]
    207c:	00004904 	andeq	r4, r0, r4, lsl #18
    2080:	0c0d0700 	stceq	7, cr0, [sp], {-0}
    2084:	00000551 	andeq	r0, r0, r1, asr r5
    2088:	00051e0a 	andeq	r1, r5, sl, lsl #28
    208c:	a40a0000 	strge	r0, [sl], #-0
    2090:	01000003 	tsteq	r0, r3
    2094:	0c4c0700 	mcrreq	7, 0, r0, ip, cr0
    2098:	070c0000 	streq	r0, [ip, -r0]
    209c:	0586081b 	streq	r0, [r6, #2075]	; 0x81b
    20a0:	e00d0000 	and	r0, sp, r0
    20a4:	07000003 	streq	r0, [r0, -r3]
    20a8:	0586191d 	streq	r1, [r6, #2333]	; 0x91d
    20ac:	0d000000 	stceq	0, cr0, [r0, #-0]
    20b0:	000004d5 	ldrdeq	r0, [r0], -r5
    20b4:	86191e07 	ldrhi	r1, [r9], -r7, lsl #28
    20b8:	04000005 	streq	r0, [r0], #-5
    20bc:	000bca0d 	andeq	ip, fp, sp, lsl #20
    20c0:	131f0700 	tstne	pc, #0, 14
    20c4:	0000058c 	andeq	r0, r0, ip, lsl #11
    20c8:	04170008 	ldreq	r0, [r7], #-8
    20cc:	00000551 	andeq	r0, r0, r1, asr r5
    20d0:	04800417 	streq	r0, [r0], #1047	; 0x417
    20d4:	810c0000 	mrshi	r0, (UNDEF: 12)
    20d8:	14000005 	strne	r0, [r0], #-5
    20dc:	14072207 	strne	r2, [r7], #-519	; 0xfffffdf9
    20e0:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    20e4:	00000841 	andeq	r0, r0, r1, asr #16
    20e8:	65122607 	ldrvs	r2, [r2, #-1543]	; 0xfffff9f9
    20ec:	00000000 	andeq	r0, r0, r0
    20f0:	0004820d 	andeq	r8, r4, sp, lsl #4
    20f4:	1d290700 	stcne	7, cr0, [r9, #-0]
    20f8:	00000586 	andeq	r0, r0, r6, lsl #11
    20fc:	0af00d04 	beq	ffc05514 <__bss_end+0xffbfb614>
    2100:	2c070000 	stccs	0, cr0, [r7], {-0}
    2104:	0005861d 	andeq	r8, r5, sp, lsl r6
    2108:	fe1b0800 	vcmla.f16	d0, d11, d0[0], #90
    210c:	0700000c 	streq	r0, [r0, -ip]
    2110:	0c290e2f 	stceq	14, cr0, [r9], #-188	; 0xffffff44
    2114:	05da0000 	ldrbeq	r0, [sl]
    2118:	05e50000 	strbeq	r0, [r5, #0]!
    211c:	190f0000 	stmdbne	pc, {}	; <UNPREDICTABLE>
    2120:	10000008 	andne	r0, r0, r8
    2124:	00000586 	andeq	r0, r0, r6, lsl #11
    2128:	0be21c00 	bleq	ff889130 <__bss_end+0xff87f230>
    212c:	31070000 	mrscc	r0, (UNDEF: 7)
    2130:	0003e50e 	andeq	lr, r3, lr, lsl #10
    2134:	00038c00 	andeq	r8, r3, r0, lsl #24
    2138:	0005fd00 	andeq	pc, r5, r0, lsl #26
    213c:	00060800 	andeq	r0, r6, r0, lsl #16
    2140:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
    2144:	8c100000 	ldchi	0, cr0, [r0], {-0}
    2148:	00000005 	andeq	r0, r0, r5
    214c:	000c5f12 	andeq	r5, ip, r2, lsl pc
    2150:	1d350700 	ldcne	7, cr0, [r5, #-0]
    2154:	00000ba5 	andeq	r0, r0, r5, lsr #23
    2158:	00000586 	andeq	r0, r0, r6, lsl #11
    215c:	00062102 	andeq	r2, r6, r2, lsl #2
    2160:	00062700 	andeq	r2, r6, r0, lsl #14
    2164:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
    2168:	12000000 	andne	r0, r0, #0
    216c:	000007d5 	ldrdeq	r0, [r0], -r5
    2170:	221d3707 	andscs	r3, sp, #1835008	; 0x1c0000
    2174:	8600000a 	strhi	r0, [r0], -sl
    2178:	02000005 	andeq	r0, r0, #5
    217c:	00000640 	andeq	r0, r0, r0, asr #12
    2180:	00000646 	andeq	r0, r0, r6, asr #12
    2184:	0008190f 	andeq	r1, r8, pc, lsl #18
    2188:	e91d0000 	ldmdb	sp, {}	; <UNPREDICTABLE>
    218c:	07000008 	streq	r0, [r0, -r8]
    2190:	08323139 	ldmdaeq	r2!, {r0, r3, r4, r5, r8, ip, sp}
    2194:	020c0000 	andeq	r0, ip, #0
    2198:	00058112 	andeq	r8, r5, r2, lsl r1
    219c:	093c0700 	ldmdbeq	ip!, {r8, r9, sl}
    21a0:	00000da1 	andeq	r0, r0, r1, lsr #27
    21a4:	00000819 	andeq	r0, r0, r9, lsl r8
    21a8:	00066d01 	andeq	r6, r6, r1, lsl #26
    21ac:	00067300 	andeq	r7, r6, r0, lsl #6
    21b0:	08190f00 	ldmdaeq	r9, {r8, r9, sl, fp}
    21b4:	12000000 	andne	r0, r0, #0
    21b8:	00000533 	andeq	r0, r0, r3, lsr r5
    21bc:	d3123f07 	tstle	r2, #7, 30
    21c0:	6500000c 	strvs	r0, [r0, #-12]
    21c4:	01000000 	mrseq	r0, (UNDEF: 0)
    21c8:	0000068c 	andeq	r0, r0, ip, lsl #13
    21cc:	000006a1 	andeq	r0, r0, r1, lsr #13
    21d0:	0008190f 	andeq	r1, r8, pc, lsl #18
    21d4:	083b1000 	ldmdaeq	fp!, {ip}
    21d8:	76100000 	ldrvc	r0, [r0], -r0
    21dc:	10000000 	andne	r0, r0, r0
    21e0:	0000038c 	andeq	r0, r0, ip, lsl #7
    21e4:	0bf11300 	bleq	ffc46dec <__bss_end+0xffc3ceec>
    21e8:	42070000 	andmi	r0, r7, #0
    21ec:	00099e0e 	andeq	r9, r9, lr, lsl #28
    21f0:	06b60100 	ldrteq	r0, [r6], r0, lsl #2
    21f4:	06bc0000 	ldrteq	r0, [ip], r0
    21f8:	190f0000 	stmdbne	pc, {}	; <UNPREDICTABLE>
    21fc:	00000008 	andeq	r0, r0, r8
    2200:	00076912 	andeq	r6, r7, r2, lsl r9
    2204:	17450700 	strbne	r0, [r5, -r0, lsl #14]
    2208:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
    220c:	0000058c 	andeq	r0, r0, ip, lsl #11
    2210:	0006d501 	andeq	sp, r6, r1, lsl #10
    2214:	0006db00 	andeq	sp, r6, r0, lsl #22
    2218:	08410f00 	stmdaeq	r1, {r8, r9, sl, fp}^
    221c:	12000000 	andne	r0, r0, #0
    2220:	000004da 	ldrdeq	r0, [r0], -sl
    2224:	62174807 	andsvs	r4, r7, #458752	; 0x70000
    2228:	8c00000b 	stchi	0, cr0, [r0], {11}
    222c:	01000005 	tsteq	r0, r5
    2230:	000006f4 	strdeq	r0, [r0], -r4
    2234:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2238:	0008410f 	andeq	r4, r8, pc, lsl #2
    223c:	00651000 	rsbeq	r1, r5, r0
    2240:	13000000 	movwne	r0, #0
    2244:	00000d45 	andeq	r0, r0, r5, asr #26
    2248:	fa0e4b07 	blx	394e6c <__bss_end+0x38af6c>
    224c:	0100000b 	tsteq	r0, fp
    2250:	00000714 	andeq	r0, r0, r4, lsl r7
    2254:	0000071a 	andeq	r0, r0, sl, lsl r7
    2258:	0008190f 	andeq	r1, r8, pc, lsl #18
    225c:	e2120000 	ands	r0, r2, #0
    2260:	0700000b 	streq	r0, [r0, -fp]
    2264:	068f0e4d 	streq	r0, [pc], sp, asr #28
    2268:	038c0000 	orreq	r0, ip, #0
    226c:	33010000 	movwcc	r0, #4096	; 0x1000
    2270:	3e000007 	cdpcc	0, 0, cr0, cr0, cr7, {0}
    2274:	0f000007 	svceq	0x00000007
    2278:	00000819 	andeq	r0, r0, r9, lsl r8
    227c:	00006510 	andeq	r6, r0, r0, lsl r5
    2280:	7d120000 	ldcvc	0, cr0, [r2, #-0]
    2284:	07000007 	streq	r0, [r0, -r7]
    2288:	09bf1250 	ldmibeq	pc!, {r4, r6, r9, ip}	; <UNPREDICTABLE>
    228c:	00650000 	rsbeq	r0, r5, r0
    2290:	57010000 	strpl	r0, [r1, -r0]
    2294:	62000007 	andvs	r0, r0, #7
    2298:	0f000007 	svceq	0x00000007
    229c:	00000819 	andeq	r0, r0, r9, lsl r8
    22a0:	0003bb10 	andeq	fp, r3, r0, lsl fp
    22a4:	4b120000 	blmi	4822ac <__bss_end+0x4783ac>
    22a8:	07000004 	streq	r0, [r0, -r4]
    22ac:	07160e53 			; <UNDEFINED> instruction: 0x07160e53
    22b0:	038c0000 	orreq	r0, ip, #0
    22b4:	7b010000 	blvc	422bc <__bss_end+0x383bc>
    22b8:	86000007 	strhi	r0, [r0], -r7
    22bc:	0f000007 	svceq	0x00000007
    22c0:	00000819 	andeq	r0, r0, r9, lsl r8
    22c4:	00006510 	andeq	r6, r0, r0, lsl r5
    22c8:	af130000 	svcge	0x00130000
    22cc:	07000007 	streq	r0, [r0, -r7]
    22d0:	0c6b0e56 	stcleq	14, cr0, [fp], #-344	; 0xfffffea8
    22d4:	9b010000 	blls	422dc <__bss_end+0x383dc>
    22d8:	ba000007 	blt	22fc <shift+0x22fc>
    22dc:	0f000007 	svceq	0x00000007
    22e0:	00000819 	andeq	r0, r0, r9, lsl r8
    22e4:	0000f210 	andeq	pc, r0, r0, lsl r2	; <UNPREDICTABLE>
    22e8:	00651000 	rsbeq	r1, r5, r0
    22ec:	65100000 	ldrvs	r0, [r0, #-0]
    22f0:	10000000 	andne	r0, r0, r0
    22f4:	00000065 	andeq	r0, r0, r5, rrx
    22f8:	00084710 	andeq	r4, r8, r0, lsl r7
    22fc:	8f130000 	svchi	0x00130000
    2300:	0700000b 	streq	r0, [r0, -fp]
    2304:	05ff0e58 	ldrbeq	r0, [pc, #3672]!	; 3164 <shift+0x3164>
    2308:	cf010000 	svcgt	0x00010000
    230c:	ee000007 	cdp	0, 0, cr0, cr0, cr7, {0}
    2310:	0f000007 	svceq	0x00000007
    2314:	00000819 	andeq	r0, r0, r9, lsl r8
    2318:	00012910 	andeq	r2, r1, r0, lsl r9
    231c:	00651000 	rsbeq	r1, r5, r0
    2320:	65100000 	ldrvs	r0, [r0, #-0]
    2324:	10000000 	andne	r0, r0, r0
    2328:	00000065 	andeq	r0, r0, r5, rrx
    232c:	00084710 	andeq	r4, r8, r0, lsl r7
    2330:	5b140000 	blpl	502338 <__bss_end+0x4f8438>
    2334:	07000005 	streq	r0, [r0, -r5]
    2338:	05bc0e5b 	ldreq	r0, [ip, #3675]!	; 0xe5b
    233c:	038c0000 	orreq	r0, ip, #0
    2340:	03010000 	movweq	r0, #4096	; 0x1000
    2344:	0f000008 	svceq	0x00000008
    2348:	00000819 	andeq	r0, r0, r9, lsl r8
    234c:	00053210 	andeq	r3, r5, r0, lsl r2
    2350:	084d1000 	stmdaeq	sp, {ip}^
    2354:	00000000 	andeq	r0, r0, r0
    2358:	00059203 	andeq	r9, r5, r3, lsl #4
    235c:	92041700 	andls	r1, r4, #0, 14
    2360:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    2364:	00000586 	andeq	r0, r0, r6, lsl #11
    2368:	0000082c 	andeq	r0, r0, ip, lsr #16
    236c:	00000832 	andeq	r0, r0, r2, lsr r8
    2370:	0008190f 	andeq	r1, r8, pc, lsl #18
    2374:	921f0000 	andsls	r0, pc, #0
    2378:	1f000005 	svcne	0x00000005
    237c:	17000008 	strne	r0, [r0, -r8]
    2380:	00005704 	andeq	r5, r0, r4, lsl #14
    2384:	14041700 	strne	r1, [r4], #-1792	; 0xfffff900
    2388:	20000008 	andcs	r0, r0, r8
    238c:	0000cc04 	andeq	ip, r0, r4, lsl #24
    2390:	19042100 	stmdbne	r4, {r8, sp}
    2394:	000008f7 	strdeq	r0, [r0], -r7
    2398:	92195e07 	andsls	r5, r9, #7, 28	; 0x70
    239c:	22000005 	andcs	r0, r0, #5
    23a0:	000011e1 	andeq	r1, r0, r1, ror #3
    23a4:	a5071401 	strge	r1, [r7, #-1025]	; 0xfffffbff
    23a8:	d4000011 	strle	r0, [r0], #-17	; 0xffffffef
    23ac:	00000008 	andeq	r0, r0, r8
    23b0:	7400008b 	strvc	r0, [r0], #-139	; 0xffffff75
    23b4:	01000000 	mrseq	r0, (UNDEF: 0)
    23b8:	0008d49c 	muleq	r8, ip, r4
    23bc:	0bd82300 	bleq	ff60afc4 <__bss_end+0xff6010c4>
    23c0:	14010000 	strne	r0, [r1], #-0
    23c4:	00006521 	andeq	r6, r0, r1, lsr #10
    23c8:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    23cc:	6e696d24 	cdpvs	13, 6, cr6, cr9, cr4, {1}
    23d0:	32140100 	andscc	r0, r4, #0, 2
    23d4:	000008d4 	ldrdeq	r0, [r0], -r4
    23d8:	24609102 	strbtcs	r9, [r0], #-258	; 0xfffffefe
    23dc:	0078616d 	rsbseq	r6, r8, sp, ror #2
    23e0:	d43d1401 	ldrtle	r1, [sp], #-1025	; 0xfffffbff
    23e4:	02000008 	andeq	r0, r0, #8
    23e8:	09255c91 	stmdbeq	r5!, {r0, r4, r7, sl, fp, ip, lr}
    23ec:	01000012 	tsteq	r0, r2, lsl r0
    23f0:	00650e16 	rsbeq	r0, r5, r6, lsl lr
    23f4:	91020000 	mrsls	r0, (UNDEF: 2)
    23f8:	11cf2574 	bicne	r2, pc, r4, ror r5	; <UNPREDICTABLE>
    23fc:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    2400:	0008d40b 	andeq	sp, r8, fp, lsl #8
    2404:	70910200 	addsvc	r0, r1, r0, lsl #4
    2408:	00124e25 	andseq	r4, r2, r5, lsr #28
    240c:	0b1c0100 	bleq	702814 <__bss_end+0x6f8914>
    2410:	000008d4 	ldrdeq	r0, [r0], -r4
    2414:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    2418:	b7040402 	strlt	r0, [r4, -r2, lsl #8]
    241c:	22000017 	andcs	r0, r0, #23
    2420:	000011bd 			; <UNDEFINED> instruction: 0x000011bd
    2424:	5e0a0b01 	vmlapl.f64	d0, d10, d1
    2428:	65000012 	strvs	r0, [r0, #-18]	; 0xffffffee
    242c:	90000000 	andls	r0, r0, r0
    2430:	7000008a 	andvc	r0, r0, sl, lsl #1
    2434:	01000000 	mrseq	r0, (UNDEF: 0)
    2438:	0009459c 	muleq	r9, ip, r5
    243c:	0bd82300 	bleq	ff60b044 <__bss_end+0xff601144>
    2440:	0b010000 	bleq	42448 <__bss_end+0x38548>
    2444:	00006525 	andeq	r6, r0, r5, lsr #10
    2448:	6c910200 	lfmvs	f0, 4, [r1], {0}
    244c:	6e696d24 	cdpvs	13, 6, cr6, cr9, cr4, {1}
    2450:	390b0100 	stmdbcc	fp, {r8}
    2454:	00000065 	andeq	r0, r0, r5, rrx
    2458:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    245c:	0078616d 	rsbseq	r6, r8, sp, ror #2
    2460:	65470b01 	strbvs	r0, [r7, #-2817]	; 0xfffff4ff
    2464:	02000000 	andeq	r0, r0, #0
    2468:	37256491 			; <UNDEFINED> instruction: 0x37256491
    246c:	01000009 	tsteq	r0, r9
    2470:	00650b0d 	rsbeq	r0, r5, sp, lsl #22
    2474:	91020000 	mrsls	r0, (UNDEF: 2)
    2478:	124e2570 	subne	r2, lr, #112, 10	; 0x1c000000
    247c:	0f010000 	svceq	0x00010000
    2480:	0000650b 	andeq	r6, r0, fp, lsl #10
    2484:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2488:	11bd2600 			; <UNDEFINED> instruction: 0x11bd2600
    248c:	03010000 	movweq	r0, #4096	; 0x1000
    2490:	0011f20a 	andseq	pc, r1, sl, lsl #4
    2494:	00006500 	andeq	r6, r0, r0, lsl #10
    2498:	008a5400 	addeq	r5, sl, r0, lsl #8
    249c:	00003c00 	andeq	r3, r0, r0, lsl #24
    24a0:	239c0100 	orrscs	r0, ip, #0, 2
    24a4:	00000bd8 	ldrdeq	r0, [r0], -r8
    24a8:	65250301 	strvs	r0, [r5, #-769]!	; 0xfffffcff
    24ac:	02000000 	andeq	r0, r0, #0
    24b0:	37256c91 			; <UNDEFINED> instruction: 0x37256c91
    24b4:	01000009 	tsteq	r0, r9
    24b8:	00650b05 	rsbeq	r0, r5, r5, lsl #22
    24bc:	91020000 	mrsls	r0, (UNDEF: 2)
    24c0:	f9000074 			; <UNDEFINED> instruction: 0xf9000074
    24c4:	04000006 	streq	r0, [r0], #-6
    24c8:	00099200 	andeq	r9, r9, r0, lsl #4
    24cc:	d2010400 	andle	r0, r1, #0, 8
    24d0:	04000010 	streq	r0, [r0], #-16
    24d4:	00001287 	andeq	r1, r0, r7, lsl #5
    24d8:	00000f7a 	andeq	r0, r0, sl, ror pc
    24dc:	00008b74 	andeq	r8, r0, r4, ror fp
    24e0:	00000fdc 	ldrdeq	r0, [r0], -ip
    24e4:	00000928 	andeq	r0, r0, r8, lsr #18
    24e8:	00092e02 	andeq	r2, r9, r2, lsl #28
    24ec:	11040200 	mrsne	r0, R12_usr
    24f0:	0000003e 	andeq	r0, r0, lr, lsr r0
    24f4:	9ed80305 	cdpls	3, 13, cr0, cr8, cr5, {0}
    24f8:	04030000 	streq	r0, [r3], #-0
    24fc:	0017b704 	andseq	fp, r7, r4, lsl #14
    2500:	00370400 	eorseq	r0, r7, r0, lsl #8
    2504:	67050000 	strvs	r0, [r5, -r0]
    2508:	06000000 	streq	r0, [r0], -r0
    250c:	000013c7 	andeq	r1, r0, r7, asr #7
    2510:	7f100501 	svcvc	0x00100501
    2514:	11000000 	mrsne	r0, (UNDEF: 0)
    2518:	33323130 	teqcc	r2, #48, 2
    251c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    2520:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    2524:	46454443 	strbmi	r4, [r5], -r3, asr #8
    2528:	01070000 	mrseq	r0, (UNDEF: 7)
    252c:	00430103 	subeq	r0, r3, r3, lsl #2
    2530:	97080000 	strls	r0, [r8, -r0]
    2534:	7f000000 	svcvc	0x00000000
    2538:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    253c:	00000084 	andeq	r0, r0, r4, lsl #1
    2540:	6f040010 	svcvs	0x00040010
    2544:	03000000 	movweq	r0, #0
    2548:	04750704 	ldrbteq	r0, [r5], #-1796	; 0xfffff8fc
    254c:	84040000 	strhi	r0, [r4], #-0
    2550:	03000000 	movweq	r0, #0
    2554:	0a1d0801 	beq	744560 <__bss_end+0x73a660>
    2558:	90040000 	andls	r0, r4, r0
    255c:	0a000000 	beq	2564 <shift+0x2564>
    2560:	00000048 	andeq	r0, r0, r8, asr #32
    2564:	0013bb0b 	andseq	fp, r3, fp, lsl #22
    2568:	07fc0100 	ldrbeq	r0, [ip, r0, lsl #2]!
    256c:	00001332 	andeq	r1, r0, r2, lsr r3
    2570:	00000037 	andeq	r0, r0, r7, lsr r0
    2574:	00009a40 	andeq	r9, r0, r0, asr #20
    2578:	00000110 	andeq	r0, r0, r0, lsl r1
    257c:	011d9c01 	tsteq	sp, r1, lsl #24
    2580:	730c0000 	movwvc	r0, #49152	; 0xc000
    2584:	18fc0100 	ldmne	ip!, {r8}^
    2588:	0000011d 	andeq	r0, r0, sp, lsl r1
    258c:	0d649102 	stfeqp	f1, [r4, #-8]!
    2590:	007a6572 	rsbseq	r6, sl, r2, ror r5
    2594:	3709fe01 	strcc	pc, [r9, -r1, lsl #28]
    2598:	02000000 	andeq	r0, r0, #0
    259c:	550e7491 	strpl	r7, [lr, #-1169]	; 0xfffffb6f
    25a0:	01000014 	tsteq	r0, r4, lsl r0
    25a4:	003712fe 	ldrshteq	r1, [r7], -lr
    25a8:	91020000 	mrsls	r0, (UNDEF: 2)
    25ac:	9a840f70 	bls	fe106374 <__bss_end+0xfe0fc474>
    25b0:	00a80000 	adceq	r0, r8, r0
    25b4:	f9100000 			; <UNDEFINED> instruction: 0xf9100000
    25b8:	01000012 	tsteq	r0, r2, lsl r0
    25bc:	230c0103 	movwcs	r0, #49411	; 0xc103
    25c0:	02000001 	andeq	r0, r0, #1
    25c4:	9c0f6c91 	stcls	12, cr6, [pc], {145}	; 0x91
    25c8:	8000009a 	mulhi	r0, sl, r0
    25cc:	11000000 	mrsne	r0, (UNDEF: 0)
    25d0:	08010064 	stmdaeq	r1, {r2, r5, r6}
    25d4:	01230901 			; <UNDEFINED> instruction: 0x01230901
    25d8:	91020000 	mrsls	r0, (UNDEF: 2)
    25dc:	00000068 	andeq	r0, r0, r8, rrx
    25e0:	00970412 	addseq	r0, r7, r2, lsl r4
    25e4:	04130000 	ldreq	r0, [r3], #-0
    25e8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    25ec:	13d31400 	bicsne	r1, r3, #0, 8
    25f0:	c1010000 	mrsgt	r0, (UNDEF: 1)
    25f4:	00143d06 	andseq	r3, r4, r6, lsl #26
    25f8:	00971c00 	addseq	r1, r7, r0, lsl #24
    25fc:	00032400 	andeq	r2, r3, r0, lsl #8
    2600:	299c0100 	ldmibcs	ip, {r8}
    2604:	0c000002 	stceq	0, cr0, [r0], {2}
    2608:	c1010078 	tstgt	r1, r8, ror r0
    260c:	00003711 	andeq	r3, r0, r1, lsl r7
    2610:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    2614:	66620c7f 			; <UNDEFINED> instruction: 0x66620c7f
    2618:	c1010072 	tstgt	r1, r2, ror r0
    261c:	0002291a 	andeq	r2, r2, sl, lsl r9
    2620:	a0910300 	addsge	r0, r1, r0, lsl #6
    2624:	130b157f 	movwne	r1, #46463	; 0xb57f
    2628:	c1010000 	mrsgt	r0, (UNDEF: 1)
    262c:	00008b32 	andeq	r8, r0, r2, lsr fp
    2630:	9c910300 	ldcls	3, cr0, [r1], {0}
    2634:	14160e7f 	ldrne	r0, [r6], #-3711	; 0xfffff181
    2638:	c3010000 	movwgt	r0, #4096	; 0x1000
    263c:	0000840f 	andeq	r8, r0, pc, lsl #8
    2640:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2644:	0013ff0e 	andseq	pc, r3, lr, lsl #30
    2648:	06d90100 	ldrbeq	r0, [r9], r0, lsl #2
    264c:	00000123 	andeq	r0, r0, r3, lsr #2
    2650:	0e709102 	expeqs	f1, f2
    2654:	00001314 	andeq	r1, r0, r4, lsl r3
    2658:	3e11dd01 	cdpcc	13, 1, cr13, cr1, cr1, {0}
    265c:	02000000 	andeq	r0, r0, #0
    2660:	d10e6491 			; <UNDEFINED> instruction: 0xd10e6491
    2664:	01000012 	tsteq	r0, r2, lsl r0
    2668:	008b18e0 	addeq	r1, fp, r0, ror #17
    266c:	91020000 	mrsls	r0, (UNDEF: 2)
    2670:	12e00e60 	rscne	r0, r0, #96, 28	; 0x600
    2674:	e1010000 	mrs	r0, (UNDEF: 1)
    2678:	00008b18 	andeq	r8, r0, r8, lsl fp
    267c:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2680:	0013860e 	andseq	r8, r3, lr, lsl #12
    2684:	07e30100 	strbeq	r0, [r3, r0, lsl #2]!
    2688:	0000022f 	andeq	r0, r0, pc, lsr #4
    268c:	7fb89103 	svcvc	0x00b89103
    2690:	00131a0e 	andseq	r1, r3, lr, lsl #20
    2694:	06e50100 	strbteq	r0, [r5], r0, lsl #2
    2698:	00000123 	andeq	r0, r0, r3, lsr #2
    269c:	16589102 	ldrbne	r9, [r8], -r2, lsl #2
    26a0:	00009928 	andeq	r9, r0, r8, lsr #18
    26a4:	00000050 	andeq	r0, r0, r0, asr r0
    26a8:	000001f7 	strdeq	r0, [r0], -r7
    26ac:	0100690d 	tsteq	r0, sp, lsl #18
    26b0:	01230be7 	smulwteq	r3, r7, fp
    26b4:	91020000 	mrsls	r0, (UNDEF: 2)
    26b8:	840f006c 	strhi	r0, [pc], #-108	; 26c0 <shift+0x26c0>
    26bc:	98000099 	stmdals	r0, {r0, r3, r4, r7}
    26c0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    26c4:	00001304 	andeq	r1, r0, r4, lsl #6
    26c8:	3f08ef01 	svccc	0x0008ef01
    26cc:	03000002 	movweq	r0, #2
    26d0:	0f7fac91 	svceq	0x007fac91
    26d4:	000099b4 			; <UNDEFINED> instruction: 0x000099b4
    26d8:	00000068 	andeq	r0, r0, r8, rrx
    26dc:	0100690d 	tsteq	r0, sp, lsl #18
    26e0:	01230cf2 	strdeq	r0, [r3, -r2]!
    26e4:	91020000 	mrsls	r0, (UNDEF: 2)
    26e8:	00000068 	andeq	r0, r0, r8, rrx
    26ec:	00900412 	addseq	r0, r0, r2, lsl r4
    26f0:	90080000 	andls	r0, r8, r0
    26f4:	3f000000 	svccc	0x00000000
    26f8:	09000002 	stmdbeq	r0, {r1}
    26fc:	00000084 	andeq	r0, r0, r4, lsl #1
    2700:	9008001f 	andls	r0, r8, pc, lsl r0
    2704:	4f000000 	svcmi	0x00000000
    2708:	09000002 	stmdbeq	r0, {r1}
    270c:	00000084 	andeq	r0, r0, r4, lsl #1
    2710:	d3140008 	tstle	r4, #8
    2714:	01000013 	tsteq	r0, r3, lsl r0
    2718:	14a206bb 	strtne	r0, [r2], #1723	; 0x6bb
    271c:	96ec0000 	strbtls	r0, [ip], r0
    2720:	00300000 	eorseq	r0, r0, r0
    2724:	9c010000 	stcls	0, cr0, [r1], {-0}
    2728:	00000286 	andeq	r0, r0, r6, lsl #5
    272c:	0100780c 	tsteq	r0, ip, lsl #16
    2730:	003711bb 	ldrhteq	r1, [r7], -fp
    2734:	91020000 	mrsls	r0, (UNDEF: 2)
    2738:	66620c74 			; <UNDEFINED> instruction: 0x66620c74
    273c:	bb010072 	bllt	4290c <__bss_end+0x38a0c>
    2740:	0002291a 	andeq	r2, r2, sl, lsl r9
    2744:	70910200 	addsvc	r0, r1, r0, lsl #4
    2748:	12da0b00 	sbcsne	r0, sl, #0, 22
    274c:	b5010000 	strlt	r0, [r1, #-0]
    2750:	00139106 	andseq	r9, r3, r6, lsl #2
    2754:	0002b200 	andeq	fp, r2, r0, lsl #4
    2758:	0096ac00 	addseq	sl, r6, r0, lsl #24
    275c:	00004000 	andeq	r4, r0, r0
    2760:	b29c0100 	addslt	r0, ip, #0, 2
    2764:	0c000002 	stceq	0, cr0, [r0], {2}
    2768:	b5010078 	strlt	r0, [r1, #-120]	; 0xffffff88
    276c:	00003712 	andeq	r3, r0, r2, lsl r7
    2770:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2774:	02010300 	andeq	r0, r1, #0, 6
    2778:	0000083c 	andeq	r0, r0, ip, lsr r8
    277c:	0012cb0b 	andseq	ip, r2, fp, lsl #22
    2780:	06b00100 	ldrteq	r0, [r0], r0, lsl #2
    2784:	0000134e 	andeq	r1, r0, lr, asr #6
    2788:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    278c:	00009670 	andeq	r9, r0, r0, ror r6
    2790:	0000003c 	andeq	r0, r0, ip, lsr r0
    2794:	02e59c01 	rsceq	r9, r5, #256	; 0x100
    2798:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    279c:	12b00100 	adcsne	r0, r0, #0, 2
    27a0:	00000037 	andeq	r0, r0, r7, lsr r0
    27a4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    27a8:	00148a14 	andseq	r8, r4, r4, lsl sl
    27ac:	06a50100 	strteq	r0, [r5], r0, lsl #2
    27b0:	000013d8 	ldrdeq	r1, [r0], -r8
    27b4:	0000959c 	muleq	r0, ip, r5
    27b8:	000000d4 	ldrdeq	r0, [r0], -r4
    27bc:	033a9c01 	teqeq	sl, #256	; 0x100
    27c0:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    27c4:	2ba50100 	blcs	fe942bcc <__bss_end+0xfe938ccc>
    27c8:	00000084 	andeq	r0, r0, r4, lsl #1
    27cc:	0c6c9102 	stfeqp	f1, [ip], #-8
    27d0:	00726662 	rsbseq	r6, r2, r2, ror #12
    27d4:	2934a501 	ldmdbcs	r4!, {r0, r8, sl, sp, pc}
    27d8:	02000002 	andeq	r0, r0, #2
    27dc:	24156891 	ldrcs	r6, [r5], #-2193	; 0xfffff76f
    27e0:	01000014 	tsteq	r0, r4, lsl r0
    27e4:	01233da5 			; <UNDEFINED> instruction: 0x01233da5
    27e8:	91020000 	mrsls	r0, (UNDEF: 2)
    27ec:	14160e64 	ldrne	r0, [r6], #-3684	; 0xfffff19c
    27f0:	a7010000 	strge	r0, [r1, -r0]
    27f4:	00012306 	andeq	r2, r1, r6, lsl #6
    27f8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    27fc:	14491700 	strbne	r1, [r9], #-1792	; 0xfffff900
    2800:	83010000 	movwhi	r0, #4096	; 0x1000
    2804:	0013a406 	andseq	sl, r3, r6, lsl #8
    2808:	00915c00 	addseq	r5, r1, r0, lsl #24
    280c:	00044000 	andeq	r4, r4, r0
    2810:	9e9c0100 	fmllse	f0, f4, f0
    2814:	0c000003 	stceq	0, cr0, [r0], {3}
    2818:	83010078 	movwhi	r0, #4216	; 0x1078
    281c:	00003718 	andeq	r3, r0, r8, lsl r7
    2820:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2824:	0012d115 	andseq	sp, r2, r5, lsl r1
    2828:	29830100 	stmibcs	r3, {r8}
    282c:	0000039e 	muleq	r0, lr, r3
    2830:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    2834:	000012e0 	andeq	r1, r0, r0, ror #5
    2838:	9e418301 	cdpls	3, 4, cr8, cr1, cr1, {0}
    283c:	02000003 	andeq	r0, r0, #3
    2840:	29156491 	ldmdbcs	r5, {r0, r4, r7, sl, sp, lr}
    2844:	01000013 	tsteq	r0, r3, lsl r0
    2848:	03a44f83 			; <UNDEFINED> instruction: 0x03a44f83
    284c:	91020000 	mrsls	r0, (UNDEF: 2)
    2850:	12c10e60 	sbcne	r0, r1, #96, 28	; 0x600
    2854:	96010000 	strls	r0, [r1], -r0
    2858:	0000370b 	andeq	r3, r0, fp, lsl #14
    285c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2860:	84041800 	strhi	r1, [r4], #-2048	; 0xfffff800
    2864:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2868:	00012304 	andeq	r2, r1, r4, lsl #6
    286c:	14bb1400 	ldrtne	r1, [fp], #1024	; 0x400
    2870:	76010000 	strvc	r0, [r1], -r0
    2874:	00134206 	andseq	r4, r3, r6, lsl #4
    2878:	00909800 	addseq	r9, r0, r0, lsl #16
    287c:	0000c400 	andeq	ip, r0, r0, lsl #8
    2880:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
    2884:	15000003 	strne	r0, [r0, #-3]
    2888:	00001381 	andeq	r1, r0, r1, lsl #7
    288c:	29137601 	ldmdbcs	r3, {r0, r9, sl, ip, sp, lr}
    2890:	02000002 	andeq	r0, r0, #2
    2894:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    2898:	09780100 	ldmdbeq	r8!, {r8}^
    289c:	00000123 	andeq	r0, r0, r3, lsr #2
    28a0:	0d749102 	ldfeqp	f1, [r4, #-8]!
    28a4:	006e656c 	rsbeq	r6, lr, ip, ror #10
    28a8:	230c7801 	movwcs	r7, #51201	; 0xc801
    28ac:	02000001 	andeq	r0, r0, #1
    28b0:	630e7091 	movwvs	r7, #57489	; 0xe091
    28b4:	01000013 	tsteq	r0, r3, lsl r0
    28b8:	01231178 			; <UNDEFINED> instruction: 0x01231178
    28bc:	91020000 	mrsls	r0, (UNDEF: 2)
    28c0:	7019006c 	andsvc	r0, r9, ip, rrx
    28c4:	0100776f 	tsteq	r0, pc, ror #14
    28c8:	139b076d 	orrsne	r0, fp, #28573696	; 0x1b40000
    28cc:	00370000 	eorseq	r0, r7, r0
    28d0:	902c0000 	eorls	r0, ip, r0
    28d4:	006c0000 	rsbeq	r0, ip, r0
    28d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    28dc:	0000045c 	andeq	r0, r0, ip, asr r4
    28e0:	0100780c 	tsteq	r0, ip, lsl #16
    28e4:	003e176d 	eorseq	r1, lr, sp, ror #14
    28e8:	91020000 	mrsls	r0, (UNDEF: 2)
    28ec:	006e0c6c 	rsbeq	r0, lr, ip, ror #24
    28f0:	8b2d6d01 	blhi	b5dcfc <__bss_end+0xb53dfc>
    28f4:	02000000 	andeq	r0, r0, #0
    28f8:	720d6891 	andvc	r6, sp, #9502720	; 0x910000
    28fc:	0b6f0100 	bleq	1bc2d04 <__bss_end+0x1bb8e04>
    2900:	00000037 	andeq	r0, r0, r7, lsr r0
    2904:	0f749102 	svceq	0x00749102
    2908:	00009048 	andeq	r9, r0, r8, asr #32
    290c:	00000038 	andeq	r0, r0, r8, lsr r0
    2910:	0100690d 	tsteq	r0, sp, lsl #18
    2914:	00841670 	addeq	r1, r4, r0, ror r6
    2918:	91020000 	mrsls	r0, (UNDEF: 2)
    291c:	17000070 	smlsdxne	r0, r0, r0, r0
    2920:	0000140f 	andeq	r1, r0, pc, lsl #8
    2924:	77066401 	strvc	r6, [r6, -r1, lsl #8]
    2928:	ac000012 	stcge	0, cr0, [r0], {18}
    292c:	8000008f 	andhi	r0, r0, pc, lsl #1
    2930:	01000000 	mrseq	r0, (UNDEF: 0)
    2934:	0004d99c 	muleq	r4, ip, r9
    2938:	72730c00 	rsbsvc	r0, r3, #0, 24
    293c:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    2940:	0004d919 	andeq	sp, r4, r9, lsl r9
    2944:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2948:	7473640c 	ldrbtvc	r6, [r3], #-1036	; 0xfffffbf4
    294c:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    2950:	000004e0 	andeq	r0, r0, r0, ror #9
    2954:	0c609102 	stfeqp	f1, [r0], #-8
    2958:	006d756e 	rsbeq	r7, sp, lr, ror #10
    295c:	232d6401 			; <UNDEFINED> instruction: 0x232d6401
    2960:	02000001 	andeq	r0, r0, #1
    2964:	f80e5c91 			; <UNDEFINED> instruction: 0xf80e5c91
    2968:	01000013 	tsteq	r0, r3, lsl r0
    296c:	011d0e66 	tsteq	sp, r6, ror #28
    2970:	91020000 	mrsls	r0, (UNDEF: 2)
    2974:	13c00e70 	bicne	r0, r0, #112, 28	; 0x700
    2978:	67010000 	strvs	r0, [r1, -r0]
    297c:	00022908 	andeq	r2, r2, r8, lsl #18
    2980:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2984:	008fd40f 	addeq	sp, pc, pc, lsl #8
    2988:	00004800 	andeq	r4, r0, r0, lsl #16
    298c:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2990:	230b6901 	movwcs	r6, #47361	; 0xb901
    2994:	02000001 	andeq	r0, r0, #1
    2998:	00007491 	muleq	r0, r1, r4
    299c:	04df0412 	ldrbeq	r0, [pc], #1042	; 29a4 <shift+0x29a4>
    29a0:	1b1a0000 	blne	6829a8 <__bss_end+0x678aa8>
    29a4:	14091704 	strne	r1, [r9], #-1796	; 0xfffff8fc
    29a8:	5c010000 	stcpl	0, cr0, [r1], {-0}
    29ac:	00136806 	andseq	r6, r3, r6, lsl #16
    29b0:	008f4400 	addeq	r4, pc, r0, lsl #8
    29b4:	00006800 	andeq	r6, r0, r0, lsl #16
    29b8:	419c0100 	orrsmi	r0, ip, r0, lsl #2
    29bc:	15000005 	strne	r0, [r0, #-5]
    29c0:	000014ad 	andeq	r1, r0, sp, lsr #9
    29c4:	e0125c01 	ands	r5, r2, r1, lsl #24
    29c8:	02000004 	andeq	r0, r0, #4
    29cc:	33156c91 	tstcc	r5, #37120	; 0x9100
    29d0:	0100000b 	tsteq	r0, fp
    29d4:	01231e5c 			; <UNDEFINED> instruction: 0x01231e5c
    29d8:	91020000 	mrsls	r0, (UNDEF: 2)
    29dc:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    29e0:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    29e4:	00022908 	andeq	r2, r2, r8, lsl #18
    29e8:	70910200 	addsvc	r0, r1, r0, lsl #4
    29ec:	008f600f 	addeq	r6, pc, pc
    29f0:	00003c00 	andeq	r3, r0, r0, lsl #24
    29f4:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    29f8:	230b6001 	movwcs	r6, #45057	; 0xb001
    29fc:	02000001 	andeq	r0, r0, #1
    2a00:	00007491 	muleq	r0, r1, r4
    2a04:	0014b40b 	andseq	fp, r4, fp, lsl #8
    2a08:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    2a0c:	0000145a 	andeq	r1, r0, sl, asr r4
    2a10:	00000123 	andeq	r0, r0, r3, lsr #2
    2a14:	00008ef0 	strdeq	r8, [r0], -r0
    2a18:	00000054 	andeq	r0, r0, r4, asr r0
    2a1c:	057a9c01 	ldrbeq	r9, [sl, #-3073]!	; 0xfffff3ff
    2a20:	730c0000 	movwvc	r0, #49152	; 0xc000
    2a24:	18520100 	ldmdane	r2, {r8}^
    2a28:	0000011d 	andeq	r0, r0, sp, lsl r1
    2a2c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    2a30:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    2a34:	00012306 	andeq	r2, r1, r6, lsl #6
    2a38:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2a3c:	141c0b00 	ldrne	r0, [ip], #-2816	; 0xfffff500
    2a40:	42010000 	andmi	r0, r1, #0
    2a44:	00146705 	andseq	r6, r4, r5, lsl #14
    2a48:	00012300 	andeq	r2, r1, r0, lsl #6
    2a4c:	008e4400 	addeq	r4, lr, r0, lsl #8
    2a50:	0000ac00 	andeq	sl, r0, r0, lsl #24
    2a54:	e09c0100 	adds	r0, ip, r0, lsl #2
    2a58:	0c000005 	stceq	0, cr0, [r0], {5}
    2a5c:	01003173 	tsteq	r0, r3, ror r1
    2a60:	011d1942 	tsteq	sp, r2, asr #18
    2a64:	91020000 	mrsls	r0, (UNDEF: 2)
    2a68:	32730c6c 	rsbscc	r0, r3, #108, 24	; 0x6c00
    2a6c:	29420100 	stmdbcs	r2, {r8}^
    2a70:	0000011d 	andeq	r0, r0, sp, lsl r1
    2a74:	0c689102 	stfeqp	f1, [r8], #-8
    2a78:	006d756e 	rsbeq	r7, sp, lr, ror #10
    2a7c:	23314201 	teqcs	r1, #268435456	; 0x10000000
    2a80:	02000001 	andeq	r0, r0, #1
    2a84:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    2a88:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    2a8c:	0005e010 	andeq	lr, r5, r0, lsl r0
    2a90:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    2a94:	0032750d 	eorseq	r7, r2, sp, lsl #10
    2a98:	e0144401 	ands	r4, r4, r1, lsl #8
    2a9c:	02000005 	andeq	r0, r0, #5
    2aa0:	03007691 	movweq	r7, #1681	; 0x691
    2aa4:	0a140801 	beq	504ab0 <__bss_end+0x4fabb0>
    2aa8:	740b0000 	strvc	r0, [fp], #-0
    2aac:	01000013 	tsteq	r0, r3, lsl r0
    2ab0:	14790736 	ldrbtne	r0, [r9], #-1846	; 0xfffff8ca
    2ab4:	02290000 	eoreq	r0, r9, #0
    2ab8:	8d840000 	stchi	0, cr0, [r4]
    2abc:	00c00000 	sbceq	r0, r0, r0
    2ac0:	9c010000 	stcls	0, cr0, [r1], {-0}
    2ac4:	00000640 	andeq	r0, r0, r0, asr #12
    2ac8:	00133d15 	andseq	r3, r3, r5, lsl sp
    2acc:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    2ad0:	00000229 	andeq	r0, r0, r9, lsr #4
    2ad4:	0c6c9102 	stfeqp	f1, [ip], #-8
    2ad8:	00637273 	rsbeq	r7, r3, r3, ror r2
    2adc:	1d273601 	stcne	6, cr3, [r7, #-4]!
    2ae0:	02000001 	andeq	r0, r0, #1
    2ae4:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    2ae8:	01006d75 	tsteq	r0, r5, ror sp
    2aec:	01233036 			; <UNDEFINED> instruction: 0x01233036
    2af0:	91020000 	mrsls	r0, (UNDEF: 2)
    2af4:	00690d64 	rsbeq	r0, r9, r4, ror #26
    2af8:	23063801 	movwcs	r3, #26625	; 0x6801
    2afc:	02000001 	andeq	r0, r0, #1
    2b00:	0b007491 	bleq	1fd4c <__bss_end+0x15e4c>
    2b04:	000012f4 	strdeq	r1, [r0], -r4
    2b08:	2b052401 	blcs	14bb14 <__bss_end+0x141c14>
    2b0c:	23000014 	movwcs	r0, #20
    2b10:	e8000001 	stmda	r0, {r0}
    2b14:	9c00008c 	stcls	0, cr0, [r0], {140}	; 0x8c
    2b18:	01000000 	mrseq	r0, (UNDEF: 0)
    2b1c:	00067d9c 	muleq	r6, ip, sp
    2b20:	13581500 	cmpne	r8, #0, 10
    2b24:	24010000 	strcs	r0, [r1], #-0
    2b28:	00011d16 	andeq	r1, r1, r6, lsl sp
    2b2c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2b30:	0014360e 	andseq	r3, r4, lr, lsl #12
    2b34:	06260100 	strteq	r0, [r6], -r0, lsl #2
    2b38:	00000123 	andeq	r0, r0, r3, lsr #2
    2b3c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2b40:	00137c1c 	andseq	r7, r3, ip, lsl ip
    2b44:	06080100 	streq	r0, [r8], -r0, lsl #2
    2b48:	000012e8 	andeq	r1, r0, r8, ror #5
    2b4c:	00008b74 	andeq	r8, r0, r4, ror fp
    2b50:	00000174 	andeq	r0, r0, r4, ror r1
    2b54:	58159c01 	ldmdapl	r5, {r0, sl, fp, ip, pc}
    2b58:	01000013 	tsteq	r0, r3, lsl r0
    2b5c:	00841808 	addeq	r1, r4, r8, lsl #16
    2b60:	91020000 	mrsls	r0, (UNDEF: 2)
    2b64:	14361564 	ldrtne	r1, [r6], #-1380	; 0xfffffa9c
    2b68:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2b6c:	00022925 	andeq	r2, r2, r5, lsr #18
    2b70:	60910200 	addsvs	r0, r1, r0, lsl #4
    2b74:	00135e15 	andseq	r5, r3, r5, lsl lr
    2b78:	3a080100 	bcc	202f80 <__bss_end+0x1f9080>
    2b7c:	00000084 	andeq	r0, r0, r4, lsl #1
    2b80:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    2b84:	0a010069 	beq	42d30 <__bss_end+0x38e30>
    2b88:	00012306 	andeq	r2, r1, r6, lsl #6
    2b8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2b90:	008c400f 	addeq	r4, ip, pc
    2b94:	00009800 	andeq	r9, r0, r0, lsl #16
    2b98:	006a0d00 	rsbeq	r0, sl, r0, lsl #26
    2b9c:	230b1c01 	movwcs	r1, #48129	; 0xbc01
    2ba0:	02000001 	andeq	r0, r0, #1
    2ba4:	680f7091 	stmdavs	pc, {r0, r4, r7, ip, sp, lr}	; <UNPREDICTABLE>
    2ba8:	6000008c 	andvs	r0, r0, ip, lsl #1
    2bac:	0d000000 	stceq	0, cr0, [r0, #-0]
    2bb0:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    2bb4:	00009008 	andeq	r9, r0, r8
    2bb8:	6f910200 	svcvs	0x00910200
    2bbc:	00000000 	andeq	r0, r0, r0
    2bc0:	00000022 	andeq	r0, r0, r2, lsr #32
    2bc4:	0b3c0002 	bleq	f02bd4 <__bss_end+0xef8cd4>
    2bc8:	01040000 	mrseq	r0, (UNDEF: 4)
    2bcc:	00000f6a 	andeq	r0, r0, sl, ror #30
    2bd0:	00009b50 	andeq	r9, r0, r0, asr fp
    2bd4:	00009d5c 	andeq	r9, r0, ip, asr sp
    2bd8:	000014c2 	andeq	r1, r0, r2, asr #9
    2bdc:	000014f2 	strdeq	r1, [r0], -r2
    2be0:	00000063 	andeq	r0, r0, r3, rrx
    2be4:	00228001 	eoreq	r8, r2, r1
    2be8:	00020000 	andeq	r0, r2, r0
    2bec:	00000b50 	andeq	r0, r0, r0, asr fp
    2bf0:	0fe70104 	svceq	0x00e70104
    2bf4:	9d5c0000 	ldclls	0, cr0, [ip, #-0]
    2bf8:	9d600000 	stclls	0, cr0, [r0, #-0]
    2bfc:	14c20000 	strbne	r0, [r2], #0
    2c00:	14f20000 	ldrbtne	r0, [r2], #0
    2c04:	00630000 	rsbeq	r0, r3, r0
    2c08:	80010000 	andhi	r0, r1, r0
    2c0c:	00000932 	andeq	r0, r0, r2, lsr r9
    2c10:	0b640004 	bleq	1902c28 <__bss_end+0x18f8d28>
    2c14:	01040000 	mrseq	r0, (UNDEF: 4)
    2c18:	000018c0 	andeq	r1, r0, r0, asr #17
    2c1c:	0018170c 	andseq	r1, r8, ip, lsl #14
    2c20:	0014f200 	andseq	pc, r4, r0, lsl #4
    2c24:	00104700 	andseq	r4, r0, r0, lsl #14
    2c28:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    2c2c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2c30:	75070403 	strvc	r0, [r7, #-1027]	; 0xfffffbfd
    2c34:	03000004 	movweq	r0, #4
    2c38:	031f0508 	tsteq	pc, #8, 10	; 0x2000000
    2c3c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2c40:	0020a804 	eoreq	sl, r0, r4, lsl #16
    2c44:	18720400 	ldmdane	r2!, {sl}^
    2c48:	2a010000 	bcs	42c50 <__bss_end+0x38d50>
    2c4c:	00002416 	andeq	r2, r0, r6, lsl r4
    2c50:	1cca0400 	cfstrdne	mvd0, [sl], {0}
    2c54:	2f010000 	svccs	0x00010000
    2c58:	00005115 	andeq	r5, r0, r5, lsl r1
    2c5c:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    2c60:	06000000 	streq	r0, [r0], -r0
    2c64:	00000039 	andeq	r0, r0, r9, lsr r0
    2c68:	00000066 	andeq	r0, r0, r6, rrx
    2c6c:	00006607 	andeq	r6, r0, r7, lsl #12
    2c70:	04050000 	streq	r0, [r5], #-0
    2c74:	0000006c 	andeq	r0, r0, ip, rrx
    2c78:	23fc0408 	mvnscs	r0, #8, 8	; 0x8000000
    2c7c:	36010000 	strcc	r0, [r1], -r0
    2c80:	0000790f 	andeq	r7, r0, pc, lsl #18
    2c84:	7f040500 	svcvc	0x00040500
    2c88:	06000000 	streq	r0, [r0], -r0
    2c8c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c90:	00000093 	muleq	r0, r3, r0
    2c94:	00006607 	andeq	r6, r0, r7, lsl #12
    2c98:	00660700 	rsbeq	r0, r6, r0, lsl #14
    2c9c:	03000000 	movweq	r0, #0
    2ca0:	0a140801 	beq	504cac <__bss_end+0x4fadac>
    2ca4:	02090000 	andeq	r0, r9, #0
    2ca8:	0100001f 	tsteq	r0, pc, lsl r0
    2cac:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    2cb0:	2a090000 	bcs	242cb8 <__bss_end+0x238db8>
    2cb4:	01000024 	tsteq	r0, r4, lsr #32
    2cb8:	006d10be 	strhteq	r1, [sp], #-14
    2cbc:	01030000 	mrseq	r0, (UNDEF: 3)
    2cc0:	000a1606 	andeq	r1, sl, r6, lsl #12
    2cc4:	1bea0a00 	blne	ffa854cc <__bss_end+0xffa7b5cc>
    2cc8:	01070000 	mrseq	r0, (UNDEF: 7)
    2ccc:	00000093 	muleq	r0, r3, r0
    2cd0:	e6061702 	str	r1, [r6], -r2, lsl #14
    2cd4:	0b000001 	bleq	2ce0 <shift+0x2ce0>
    2cd8:	000016d0 	ldrdeq	r1, [r0], -r0
    2cdc:	1b070b00 	blne	1c58e4 <__bss_end+0x1bb9e4>
    2ce0:	0b010000 	bleq	42ce8 <__bss_end+0x38de8>
    2ce4:	00001fcd 	andeq	r1, r0, sp, asr #31
    2ce8:	233e0b02 	teqcs	lr, #2048	; 0x800
    2cec:	0b030000 	bleq	c2cf4 <__bss_end+0xb8df4>
    2cf0:	00001f71 	andeq	r1, r0, r1, ror pc
    2cf4:	22470b04 	subcs	r0, r7, #4, 22	; 0x1000
    2cf8:	0b050000 	bleq	142d00 <__bss_end+0x138e00>
    2cfc:	000021ab 	andeq	r2, r0, fp, lsr #3
    2d00:	16f10b06 	ldrbtne	r0, [r1], r6, lsl #22
    2d04:	0b070000 	bleq	1c2d0c <__bss_end+0x1b8e0c>
    2d08:	0000225c 	andeq	r2, r0, ip, asr r2
    2d0c:	226a0b08 	rsbcs	r0, sl, #8, 22	; 0x2000
    2d10:	0b090000 	bleq	242d18 <__bss_end+0x238e18>
    2d14:	00002331 	andeq	r2, r0, r1, lsr r3
    2d18:	1ec80b0a 	vdivne.f64	d16, d8, d10
    2d1c:	0b0b0000 	bleq	2c2d24 <__bss_end+0x2b8e24>
    2d20:	000018b3 			; <UNDEFINED> instruction: 0x000018b3
    2d24:	19900b0c 	ldmibne	r0, {r2, r3, r8, r9, fp}
    2d28:	0b0d0000 	bleq	342d30 <__bss_end+0x338e30>
    2d2c:	00001c2e 	andeq	r1, r0, lr, lsr #24
    2d30:	1c440b0e 	mcrrne	11, 0, r0, r4, cr14
    2d34:	0b0f0000 	bleq	3c2d3c <__bss_end+0x3b8e3c>
    2d38:	00001b41 	andeq	r1, r0, r1, asr #22
    2d3c:	1f550b10 	svcne	0x00550b10
    2d40:	0b110000 	bleq	442d48 <__bss_end+0x438e48>
    2d44:	00001bad 	andeq	r1, r0, sp, lsr #23
    2d48:	25c30b12 	strbcs	r0, [r3, #2834]	; 0xb12
    2d4c:	0b130000 	bleq	4c2d54 <__bss_end+0x4b8e54>
    2d50:	0000175a 	andeq	r1, r0, sl, asr r7
    2d54:	1bd10b14 	blne	ff4459ac <__bss_end+0xff43baac>
    2d58:	0b150000 	bleq	542d60 <__bss_end+0x538e60>
    2d5c:	00001697 	muleq	r0, r7, r6
    2d60:	23610b16 	cmncs	r1, #22528	; 0x5800
    2d64:	0b170000 	bleq	5c2d6c <__bss_end+0x5b8e6c>
    2d68:	00002483 	andeq	r2, r0, r3, lsl #9
    2d6c:	1bf60b18 	blne	ffd859d4 <__bss_end+0xffd7bad4>
    2d70:	0b190000 	bleq	642d78 <__bss_end+0x638e78>
    2d74:	0000203f 	andeq	r2, r0, pc, lsr r0
    2d78:	236f0b1a 	cmncs	pc, #26624	; 0x6800
    2d7c:	0b1b0000 	bleq	6c2d84 <__bss_end+0x6b8e84>
    2d80:	000015c6 	andeq	r1, r0, r6, asr #11
    2d84:	237d0b1c 	cmncs	sp, #28, 22	; 0x7000
    2d88:	0b1d0000 	bleq	742d90 <__bss_end+0x738e90>
    2d8c:	0000238b 	andeq	r2, r0, fp, lsl #7
    2d90:	15740b1e 	ldrbne	r0, [r4, #-2846]!	; 0xfffff4e2
    2d94:	0b1f0000 	bleq	7c2d9c <__bss_end+0x7b8e9c>
    2d98:	000023b5 			; <UNDEFINED> instruction: 0x000023b5
    2d9c:	20ec0b20 	rsccs	r0, ip, r0, lsr #22
    2da0:	0b210000 	bleq	842da8 <__bss_end+0x838ea8>
    2da4:	00001f27 	andeq	r1, r0, r7, lsr #30
    2da8:	23540b22 	cmpcs	r4, #34816	; 0x8800
    2dac:	0b230000 	bleq	8c2db4 <__bss_end+0x8b8eb4>
    2db0:	00001e2b 	andeq	r1, r0, fp, lsr #28
    2db4:	1d2d0b24 	vpushne	{d0-d17}
    2db8:	0b250000 	bleq	942dc0 <__bss_end+0x938ec0>
    2dbc:	00001a47 	andeq	r1, r0, r7, asr #20
    2dc0:	1d4b0b26 	vstrne	d16, [fp, #-152]	; 0xffffff68
    2dc4:	0b270000 	bleq	9c2dcc <__bss_end+0x9b8ecc>
    2dc8:	00001ae3 	andeq	r1, r0, r3, ror #21
    2dcc:	1d5b0b28 	vldrne	d16, [fp, #-160]	; 0xffffff60
    2dd0:	0b290000 	bleq	a42dd8 <__bss_end+0xa38ed8>
    2dd4:	00001d6b 	andeq	r1, r0, fp, ror #26
    2dd8:	1eae0b2a 	vfmane.f64	d0, d14, d26
    2ddc:	0b2b0000 	bleq	ac2de4 <__bss_end+0xab8ee4>
    2de0:	00001cd4 	ldrdeq	r1, [r0], -r4
    2de4:	20f90b2c 	rscscs	r0, r9, ip, lsr #22
    2de8:	0b2d0000 	bleq	b42df0 <__bss_end+0xb38ef0>
    2dec:	00001a88 	andeq	r1, r0, r8, lsl #21
    2df0:	660a002e 	strvs	r0, [sl], -lr, lsr #32
    2df4:	0700001c 	smladeq	r0, ip, r0, r0
    2df8:	00009301 	andeq	r9, r0, r1, lsl #6
    2dfc:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    2e00:	000003c7 	andeq	r0, r0, r7, asr #7
    2e04:	0019b20b 	andseq	fp, r9, fp, lsl #4
    2e08:	040b0000 	streq	r0, [fp], #-0
    2e0c:	01000016 	tsteq	r0, r6, lsl r0
    2e10:	0025710b 	eoreq	r7, r5, fp, lsl #2
    2e14:	040b0200 	streq	r0, [fp], #-512	; 0xfffffe00
    2e18:	03000024 	movweq	r0, #36	; 0x24
    2e1c:	0019d20b 	andseq	sp, r9, fp, lsl #4
    2e20:	bc0b0400 	cfstrslt	mvf0, [fp], {-0}
    2e24:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    2e28:	001a640b 	andseq	r6, sl, fp, lsl #8
    2e2c:	c20b0600 	andgt	r0, fp, #0, 12
    2e30:	07000019 	smladeq	r0, r9, r0, r0
    2e34:	0022980b 	eoreq	r9, r2, fp, lsl #16
    2e38:	e90b0800 	stmdb	fp, {fp}
    2e3c:	09000023 	stmdbeq	r0, {r0, r1, r5}
    2e40:	0021cf0b 	eoreq	ip, r1, fp, lsl #30
    2e44:	0f0b0a00 	svceq	0x000b0a00
    2e48:	0b000017 	bleq	2eac <shift+0x2eac>
    2e4c:	001a050b 	andseq	r0, sl, fp, lsl #10
    2e50:	850b0c00 	strhi	r0, [fp, #-3072]	; 0xfffff400
    2e54:	0d000016 	stceq	0, cr0, [r0, #-88]	; 0xffffffa8
    2e58:	0025a60b 	eoreq	sl, r5, fp, lsl #12
    2e5c:	9b0b0e00 	blls	2c6664 <__bss_end+0x2bc764>
    2e60:	0f00001e 	svceq	0x0000001e
    2e64:	001b780b 	andseq	r7, fp, fp, lsl #16
    2e68:	d80b1000 	stmdale	fp, {ip}
    2e6c:	1100001e 	tstne	r0, lr, lsl r0
    2e70:	0024c50b 	eoreq	ip, r4, fp, lsl #10
    2e74:	d20b1200 	andle	r1, fp, #0, 4
    2e78:	13000017 	movwne	r0, #23
    2e7c:	001b8b0b 	andseq	r8, fp, fp, lsl #22
    2e80:	ee0b1400 	cfcpys	mvf1, mvf11
    2e84:	1500001d 	strne	r0, [r0, #-29]	; 0xffffffe3
    2e88:	00199d0b 	andseq	r9, r9, fp, lsl #26
    2e8c:	3a0b1600 	bcc	2c8694 <__bss_end+0x2be794>
    2e90:	1700001e 	smladne	r0, lr, r0, r0
    2e94:	001c500b 	andseq	r5, ip, fp
    2e98:	da0b1800 	ble	2c8ea0 <__bss_end+0x2befa0>
    2e9c:	19000016 	stmdbne	r0, {r1, r2, r4}
    2ea0:	00246c0b 	eoreq	r6, r4, fp, lsl #24
    2ea4:	ba0b1a00 	blt	2c96ac <__bss_end+0x2bf7ac>
    2ea8:	1b00001d 	blne	2f24 <shift+0x2f24>
    2eac:	001b620b 	andseq	r6, fp, fp, lsl #4
    2eb0:	af0b1c00 	svcge	0x000b1c00
    2eb4:	1d000015 	stcne	0, cr0, [r0, #-84]	; 0xffffffac
    2eb8:	001d050b 	andseq	r0, sp, fp, lsl #10
    2ebc:	f10b1e00 			; <UNDEFINED> instruction: 0xf10b1e00
    2ec0:	1f00001c 	svcne	0x0000001c
    2ec4:	00218c0b 	eoreq	r8, r1, fp, lsl #24
    2ec8:	170b2000 	strne	r2, [fp, -r0]
    2ecc:	21000022 	tstcs	r0, r2, lsr #32
    2ed0:	00244b0b 	eoreq	r4, r4, fp, lsl #22
    2ed4:	950b2200 	strls	r2, [fp, #-512]	; 0xfffffe00
    2ed8:	2300001a 	movwcs	r0, #26
    2edc:	001fef0b 	andseq	lr, pc, fp, lsl #30
    2ee0:	e40b2400 	str	r2, [fp], #-1024	; 0xfffffc00
    2ee4:	25000021 	strcs	r0, [r0, #-33]	; 0xffffffdf
    2ee8:	0021080b 	eoreq	r0, r1, fp, lsl #16
    2eec:	1c0b2600 	stcne	6, cr2, [fp], {-0}
    2ef0:	27000021 	strcs	r0, [r0, -r1, lsr #32]
    2ef4:	0021300b 	eoreq	r3, r1, fp
    2ef8:	5d0b2800 	stcpl	8, cr2, [fp, #-0]
    2efc:	29000018 	stmdbcs	r0, {r3, r4}
    2f00:	0017bd0b 	andseq	fp, r7, fp, lsl #26
    2f04:	e50b2a00 	str	r2, [fp, #-2560]	; 0xfffff600
    2f08:	2b000017 	blcs	2f6c <shift+0x2f6c>
    2f0c:	0022e10b 	eoreq	lr, r2, fp, lsl #2
    2f10:	3a0b2c00 	bcc	2cdf18 <__bss_end+0x2c4018>
    2f14:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
    2f18:	0022f50b 	eoreq	pc, r2, fp, lsl #10
    2f1c:	090b2e00 	stmdbeq	fp, {r9, sl, fp, sp}
    2f20:	2f000023 	svccs	0x00000023
    2f24:	00231d0b 	eoreq	r1, r3, fp, lsl #26
    2f28:	170b3000 	strne	r3, [fp, -r0]
    2f2c:	3100001a 	tstcc	r0, sl, lsl r0
    2f30:	0019f10b 	andseq	pc, r9, fp, lsl #2
    2f34:	190b3200 	stmdbne	fp, {r9, ip, sp}
    2f38:	3300001d 	movwcc	r0, #29
    2f3c:	001eeb0b 	andseq	lr, lr, fp, lsl #22
    2f40:	fa0b3400 	blx	2cff48 <__bss_end+0x2c6048>
    2f44:	35000024 	strcc	r0, [r0, #-36]	; 0xffffffdc
    2f48:	0015570b 	andseq	r5, r5, fp, lsl #14
    2f4c:	170b3600 	strne	r3, [fp, -r0, lsl #12]
    2f50:	3700001b 	smladcc	r0, fp, r0, r0
    2f54:	001b2c0b 	andseq	r2, fp, fp, lsl #24
    2f58:	7b0b3800 	blvc	2d0f60 <__bss_end+0x2c7060>
    2f5c:	3900001d 	stmdbcc	r0, {r0, r2, r3, r4}
    2f60:	001da50b 	andseq	sl, sp, fp, lsl #10
    2f64:	230b3a00 	movwcs	r3, #47616	; 0xba00
    2f68:	3b000025 	blcc	3004 <shift+0x3004>
    2f6c:	001fda0b 	andseq	sp, pc, fp, lsl #20
    2f70:	ba0b3c00 	blt	2d1f78 <__bss_end+0x2c8078>
    2f74:	3d00001a 	stccc	0, cr0, [r0, #-104]	; 0xffffff98
    2f78:	0016160b 	andseq	r1, r6, fp, lsl #12
    2f7c:	d40b3e00 	strle	r3, [fp], #-3584	; 0xfffff200
    2f80:	3f000015 	svccc	0x00000015
    2f84:	001f370b 	andseq	r3, pc, fp, lsl #14
    2f88:	5b0b4000 	blpl	2d2f90 <__bss_end+0x2c9090>
    2f8c:	41000020 	tstmi	r0, r0, lsr #32
    2f90:	00216e0b 	eoreq	r6, r1, fp, lsl #28
    2f94:	900b4200 	andls	r4, fp, r0, lsl #4
    2f98:	4300001d 	movwmi	r0, #29
    2f9c:	00255c0b 	eoreq	r5, r5, fp, lsl #24
    2fa0:	050b4400 	streq	r4, [fp, #-1024]	; 0xfffffc00
    2fa4:	45000020 	strmi	r0, [r0, #-32]	; 0xffffffe0
    2fa8:	0018010b 	andseq	r0, r8, fp, lsl #2
    2fac:	6b0b4600 	blvs	2d47b4 <__bss_end+0x2ca8b4>
    2fb0:	4700001e 	smladmi	r0, lr, r0, r0
    2fb4:	001c9e0b 	andseq	r9, ip, fp, lsl #28
    2fb8:	930b4800 	movwls	r4, #47104	; 0xb800
    2fbc:	49000015 	stmdbmi	r0, {r0, r2, r4}
    2fc0:	0016a70b 	andseq	sl, r6, fp, lsl #14
    2fc4:	ce0b4a00 	vmlagt.f32	s8, s22, s0
    2fc8:	4b00001a 	blmi	3038 <shift+0x3038>
    2fcc:	001dcc0b 	andseq	ip, sp, fp, lsl #24
    2fd0:	03004c00 	movweq	r4, #3072	; 0xc00
    2fd4:	07c20702 	strbeq	r0, [r2, r2, lsl #14]
    2fd8:	e40c0000 	str	r0, [ip], #-0
    2fdc:	d9000003 	stmdble	r0, {r0, r1}
    2fe0:	0d000003 	stceq	0, cr0, [r0, #-12]
    2fe4:	03ce0e00 	biceq	r0, lr, #0, 28
    2fe8:	04050000 	streq	r0, [r5], #-0
    2fec:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2ff0:	0003de0e 	andeq	sp, r3, lr, lsl #28
    2ff4:	08010300 	stmdaeq	r1, {r8, r9}
    2ff8:	00000a1d 	andeq	r0, r0, sp, lsl sl
    2ffc:	0003e90e 	andeq	lr, r3, lr, lsl #18
    3000:	174b0f00 	strbne	r0, [fp, -r0, lsl #30]
    3004:	4c040000 	stcmi	0, cr0, [r4], {-0}
    3008:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    300c:	520f0000 	andpl	r0, pc, #0
    3010:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
    3014:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    3018:	0c000003 	stceq	0, cr0, [r0], {3}
    301c:	000003e9 	andeq	r0, r0, r9, ror #7
    3020:	0000041a 	andeq	r0, r0, sl, lsl r4
    3024:	3d09000d 	stccc	0, cr0, [r9, #-52]	; 0xffffffcc
    3028:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    302c:	040f0d2d 	streq	r0, [pc], #-3373	; 3034 <shift+0x3034>
    3030:	c5090000 	strgt	r0, [r9, #-0]
    3034:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3038:	01e61c38 	mvneq	r1, r8, lsr ip
    303c:	2b0a0000 	blcs	283044 <__bss_end+0x279144>
    3040:	0700001a 	smladeq	r0, sl, r0, r0
    3044:	00009301 	andeq	r9, r0, r1, lsl #6
    3048:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    304c:	000004a5 	andeq	r0, r0, r5, lsr #9
    3050:	0015a80b 	andseq	sl, r5, fp, lsl #16
    3054:	3d0b0000 	stccc	0, cr0, [fp, #-0]
    3058:	0100001c 	tsteq	r0, ip, lsl r0
    305c:	0024d70b 	eoreq	sp, r4, fp, lsl #14
    3060:	9a0b0200 	bls	2c3868 <__bss_end+0x2b9968>
    3064:	03000024 	movweq	r0, #36	; 0x24
    3068:	001f940b 	andseq	r9, pc, fp, lsl #8
    306c:	550b0400 	strpl	r0, [fp, #-1024]	; 0xfffffc00
    3070:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    3074:	00178e0b 	andseq	r8, r7, fp, lsl #28
    3078:	700b0600 	andvc	r0, fp, r0, lsl #12
    307c:	07000017 	smladeq	r0, r7, r0, r0
    3080:	0019890b 	andseq	r8, r9, fp, lsl #18
    3084:	500b0800 	andpl	r0, fp, r0, lsl #16
    3088:	0900001e 	stmdbeq	r0, {r1, r2, r3, r4}
    308c:	0017950b 	andseq	r9, r7, fp, lsl #10
    3090:	570b0a00 	strpl	r0, [fp, -r0, lsl #20]
    3094:	0b00001e 	bleq	3114 <shift+0x3114>
    3098:	0017fa0b 	andseq	pc, r7, fp, lsl #20
    309c:	870b0c00 	strhi	r0, [fp, -r0, lsl #24]
    30a0:	0d000017 	stceq	0, cr0, [r0, #-92]	; 0xffffffa4
    30a4:	0022ac0b 	eoreq	sl, r2, fp, lsl #24
    30a8:	790b0e00 	stmdbvc	fp, {r9, sl, fp}
    30ac:	0f000020 	svceq	0x00000020
    30b0:	21a40400 			; <UNDEFINED> instruction: 0x21a40400
    30b4:	3f050000 	svccc	0x00050000
    30b8:	00043201 	andeq	r3, r4, r1, lsl #4
    30bc:	22380900 	eorscs	r0, r8, #0, 18
    30c0:	41050000 	mrsmi	r0, (UNDEF: 5)
    30c4:	0004a50f 	andeq	sl, r4, pc, lsl #10
    30c8:	22c00900 	sbccs	r0, r0, #0, 18
    30cc:	4a050000 	bmi	1430d4 <__bss_end+0x1391d4>
    30d0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    30d4:	172f0900 	strne	r0, [pc, -r0, lsl #18]!
    30d8:	4b050000 	blmi	1430e0 <__bss_end+0x1391e0>
    30dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    30e0:	23991000 	orrscs	r1, r9, #0
    30e4:	d1090000 	mrsle	r0, (UNDEF: 9)
    30e8:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    30ec:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    30f0:	04050000 	streq	r0, [r5], #-0
    30f4:	000004d5 	ldrdeq	r0, [r0], -r5
    30f8:	1c070911 			; <UNDEFINED> instruction: 0x1c070911
    30fc:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    3100:	0004f90f 	andeq	pc, r4, pc, lsl #18
    3104:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    3108:	12000004 	andne	r0, r0, #4
    310c:	000021ba 			; <UNDEFINED> instruction: 0x000021ba
    3110:	001f8109 	andseq	r8, pc, r9, lsl #2
    3114:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    3118:	00000510 	andeq	r0, r0, r0, lsl r5
    311c:	04ff0405 	ldrbteq	r0, [pc], #1029	; 3124 <shift+0x3124>
    3120:	a6130000 	ldrge	r0, [r3], -r0
    3124:	34000018 	strcc	r0, [r0], #-24	; 0xffffffe8
    3128:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    312c:	00000541 	andeq	r0, r0, r1, asr #10
    3130:	001d4614 	andseq	r4, sp, r4, lsl r6
    3134:	01690500 	cmneq	r9, r0, lsl #10
    3138:	0003de0f 	andeq	sp, r3, pc, lsl #28
    313c:	8a140000 	bhi	503144 <__bss_end+0x4f9244>
    3140:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    3144:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    3148:	04000005 	streq	r0, [r0], #-5
    314c:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    3150:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    3154:	56000000 	strpl	r0, [r0], -r0
    3158:	15000005 	strne	r0, [r0, #-5]
    315c:	00000024 	andeq	r0, r0, r4, lsr #32
    3160:	410c002d 	tstmi	ip, sp, lsr #32
    3164:	61000005 	tstvs	r0, r5
    3168:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    316c:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    3170:	750f0000 	strvc	r0, [pc, #-0]	; 3178 <shift+0x3178>
    3174:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    3178:	6103016b 	tstvs	r3, fp, ror #2
    317c:	0f000005 	svceq	0x00000005
    3180:	00001ebb 			; <UNDEFINED> instruction: 0x00001ebb
    3184:	0c016e05 	stceq	14, cr6, [r1], {5}
    3188:	0000001d 	andeq	r0, r0, sp, lsl r0
    318c:	0021f816 	eoreq	pc, r1, r6, lsl r8	; <UNPREDICTABLE>
    3190:	93010700 	movwls	r0, #5888	; 0x1700
    3194:	05000000 	streq	r0, [r0, #-0]
    3198:	2a060181 	bcs	1837a4 <__bss_end+0x1798a4>
    319c:	0b000006 	bleq	31bc <shift+0x31bc>
    31a0:	0000163d 	andeq	r1, r0, sp, lsr r6
    31a4:	16490b00 	strbne	r0, [r9], -r0, lsl #22
    31a8:	0b020000 	bleq	831b0 <__bss_end+0x792b0>
    31ac:	00001655 	andeq	r1, r0, r5, asr r6
    31b0:	1a570b03 	bne	15c5dc4 <__bss_end+0x15bbec4>
    31b4:	0b030000 	bleq	c31bc <__bss_end+0xb92bc>
    31b8:	00001661 	andeq	r1, r0, r1, ror #12
    31bc:	1ba00b04 	blne	fe805dd4 <__bss_end+0xfe7fbed4>
    31c0:	0b040000 	bleq	1031c8 <__bss_end+0xf92c8>
    31c4:	00001c86 	andeq	r1, r0, r6, lsl #25
    31c8:	1bdc0b05 	blne	ff705de4 <__bss_end+0xff6fbee4>
    31cc:	0b050000 	bleq	1431d4 <__bss_end+0x1392d4>
    31d0:	00001720 	andeq	r1, r0, r0, lsr #14
    31d4:	166d0b05 	strbtne	r0, [sp], -r5, lsl #22
    31d8:	0b060000 	bleq	1831e0 <__bss_end+0x1792e0>
    31dc:	00001e04 	andeq	r1, r0, r4, lsl #28
    31e0:	187c0b06 	ldmdane	ip!, {r1, r2, r8, r9, fp}^
    31e4:	0b060000 	bleq	1831ec <__bss_end+0x1792ec>
    31e8:	00001e11 	andeq	r1, r0, r1, lsl lr
    31ec:	22780b06 	rsbscs	r0, r8, #6144	; 0x1800
    31f0:	0b060000 	bleq	1831f8 <__bss_end+0x1792f8>
    31f4:	00001e1e 	andeq	r1, r0, lr, lsl lr
    31f8:	1e5e0b06 	vnmlsne.f64	d16, d14, d6
    31fc:	0b060000 	bleq	183204 <__bss_end+0x179304>
    3200:	00001679 	andeq	r1, r0, r9, ror r6
    3204:	1f640b07 	svcne	0x00640b07
    3208:	0b070000 	bleq	1c3210 <__bss_end+0x1b9310>
    320c:	00001fb1 			; <UNDEFINED> instruction: 0x00001fb1
    3210:	22b30b07 	adcscs	r0, r3, #7168	; 0x1c00
    3214:	0b070000 	bleq	1c321c <__bss_end+0x1b931c>
    3218:	0000184f 	andeq	r1, r0, pc, asr #16
    321c:	20320b07 	eorscs	r0, r2, r7, lsl #22
    3220:	0b080000 	bleq	203228 <__bss_end+0x1f9328>
    3224:	000015f2 	strdeq	r1, [r0], -r2
    3228:	22860b08 	addcs	r0, r6, #8, 22	; 0x2000
    322c:	0b080000 	bleq	203234 <__bss_end+0x1f9334>
    3230:	0000204e 	andeq	r2, r0, lr, asr #32
    3234:	ec0f0008 	stc	0, cr0, [pc], {8}
    3238:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    323c:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    3240:	0f000005 	svceq	0x00000005
    3244:	00002080 	andeq	r2, r0, r0, lsl #1
    3248:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    324c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3250:	001c930f 	andseq	r9, ip, pc, lsl #6
    3254:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    3258:	00001d0c 	andeq	r1, r0, ip, lsl #26
    325c:	25b80f00 	ldrcs	r0, [r8, #3840]!	; 0xf00
    3260:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    3264:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3268:	3f0f0000 	svccc	0x000f0000
    326c:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    3270:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    3274:	0f000000 	svceq	0x00000000
    3278:	0000208a 	andeq	r2, r0, sl, lsl #1
    327c:	0c01ae05 	stceq	14, cr10, [r1], {5}
    3280:	0000001d 	andeq	r0, r0, sp, lsl r0
    3284:	001f9b0f 	andseq	r9, pc, pc, lsl #22
    3288:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    328c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3290:	1fa60f00 	svcne	0x00a60f00
    3294:	b4050000 	strlt	r0, [r5], #-0
    3298:	001d0c01 	andseq	r0, sp, r1, lsl #24
    329c:	940f0000 	strls	r0, [pc], #-0	; 32a4 <shift+0x32a4>
    32a0:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    32a4:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    32a8:	0f000000 	svceq	0x00000000
    32ac:	00001de0 	andeq	r1, r0, r0, ror #27
    32b0:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    32b4:	0000001d 	andeq	r0, r0, sp, lsl r0
    32b8:	0025170f 	eoreq	r1, r5, pc, lsl #14
    32bc:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    32c0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    32c4:	209e0f00 	addscs	r0, lr, r0, lsl #30
    32c8:	c0050000 	andgt	r0, r5, r0
    32cc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    32d0:	db0f0000 	blle	3c32d8 <__bss_end+0x3b93d8>
    32d4:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    32d8:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    32dc:	0f000000 	svceq	0x00000000
    32e0:	000024a1 	andeq	r2, r0, r1, lsr #9
    32e4:	0c01c605 	stceq	6, cr12, [r1], {5}
    32e8:	0000001d 	andeq	r0, r0, sp, lsl r0
    32ec:	0024ad0f 	eoreq	sl, r4, pc, lsl #26
    32f0:	01c90500 	biceq	r0, r9, r0, lsl #10
    32f4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    32f8:	24b90f00 	ldrtcs	r0, [r9], #3840	; 0xf00
    32fc:	cc050000 	stcgt	0, cr0, [r5], {-0}
    3300:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3304:	de0f0000 	cdple	0, 0, cr0, cr15, cr0, {0}
    3308:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    330c:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    3310:	0f000000 	svceq	0x00000000
    3314:	000025ce 	andeq	r2, r0, lr, asr #11
    3318:	0c01d305 	stceq	3, cr13, [r1], {5}
    331c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3320:	00179c0f 	andseq	r9, r7, pc, lsl #24
    3324:	01d60500 	bicseq	r0, r6, r0, lsl #10
    3328:	00001d0c 	andeq	r1, r0, ip, lsl #26
    332c:	15830f00 	strne	r0, [r3, #3840]	; 0xf00
    3330:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    3334:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3338:	770f0000 	strvc	r0, [pc, -r0]
    333c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    3340:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    3344:	0f000000 	svceq	0x00000000
    3348:	00001777 	andeq	r1, r0, r7, ror r7
    334c:	0c01df05 	stceq	15, cr13, [r1], {5}
    3350:	0000001d 	andeq	r0, r0, sp, lsl r0
    3354:	0020b40f 	eoreq	fp, r0, pc, lsl #8
    3358:	01e20500 	mvneq	r0, r0, lsl #10
    335c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3360:	1cbc0f00 	ldcne	15, cr0, [ip]
    3364:	e5050000 	str	r0, [r5, #-0]
    3368:	001d0c01 	andseq	r0, sp, r1, lsl #24
    336c:	140f0000 	strne	r0, [pc], #-0	; 3374 <shift+0x3374>
    3370:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    3374:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    3378:	0f000000 	svceq	0x00000000
    337c:	000023ce 	andeq	r2, r0, lr, asr #7
    3380:	0c01ef05 	stceq	15, cr14, [r1], {5}
    3384:	0000001d 	andeq	r0, r0, sp, lsl r0
    3388:	0025860f 	eoreq	r8, r5, pc, lsl #12
    338c:	01f20500 	mvnseq	r0, r0, lsl #10
    3390:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3394:	25960f00 	ldrcs	r0, [r6, #3840]	; 0xf00
    3398:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    339c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    33a0:	930f0000 	movwls	r0, #61440	; 0xf000
    33a4:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    33a8:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    33ac:	0f000000 	svceq	0x00000000
    33b0:	00002415 	andeq	r2, r0, r5, lsl r4
    33b4:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    33b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    33bc:	00201a0f 	eoreq	r1, r0, pc, lsl #20
    33c0:	01fe0500 	mvnseq	r0, r0, lsl #10
    33c4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    33c8:	1af00f00 	bne	ffc06fd0 <__bss_end+0xffbfd0d0>
    33cc:	02050000 	andeq	r0, r5, #0
    33d0:	001d0c02 	andseq	r0, sp, r2, lsl #24
    33d4:	0a0f0000 	beq	3c33dc <__bss_end+0x3b94dc>
    33d8:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    33dc:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    33e0:	0f000000 	svceq	0x00000000
    33e4:	000019e3 	andeq	r1, r0, r3, ror #19
    33e8:	0c020d05 	stceq	13, cr0, [r2], {5}
    33ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    33f0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    33f4:	0007ef00 	andeq	lr, r7, r0, lsl #30
    33f8:	0f000d00 	svceq	0x00000d00
    33fc:	00001bbc 			; <UNDEFINED> instruction: 0x00001bbc
    3400:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    3404:	000007e4 	andeq	r0, r0, r4, ror #15
    3408:	0004e60c 	andeq	lr, r4, ip, lsl #12
    340c:	00080c00 	andeq	r0, r8, r0, lsl #24
    3410:	00241500 	eoreq	r1, r4, r0, lsl #10
    3414:	000d0000 	andeq	r0, sp, r0
    3418:	0020d70f 	eoreq	sp, r0, pc, lsl #14
    341c:	05840500 	streq	r0, [r4, #1280]	; 0x500
    3420:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    3424:	1c7e1600 	ldclne	6, cr1, [lr], #-0
    3428:	01070000 	mrseq	r0, (UNDEF: 7)
    342c:	00000093 	muleq	r0, r3, r0
    3430:	06058b05 	streq	r8, [r5], -r5, lsl #22
    3434:	00000857 	andeq	r0, r0, r7, asr r8
    3438:	001a390b 	andseq	r3, sl, fp, lsl #18
    343c:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
    3440:	0100001e 	tsteq	r0, lr, lsl r0
    3444:	0016280b 	andseq	r2, r6, fp, lsl #16
    3448:	480b0200 	stmdami	fp, {r9}
    344c:	03000025 	movweq	r0, #37	; 0x25
    3450:	0021510b 	eoreq	r5, r1, fp, lsl #2
    3454:	440b0400 	strmi	r0, [fp], #-1024	; 0xfffffc00
    3458:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    345c:	0016ff0b 	andseq	pc, r6, fp, lsl #30
    3460:	0f000600 	svceq	0x00000600
    3464:	00002538 	andeq	r2, r0, r8, lsr r5
    3468:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    346c:	00000819 	andeq	r0, r0, r9, lsl r8
    3470:	00243a0f 	eoreq	r3, r4, pc, lsl #20
    3474:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    3478:	00002411 	andeq	r2, r0, r1, lsl r4
    347c:	20c40f00 	sbccs	r0, r4, r0, lsl #30
    3480:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    3484:	001d0c07 	andseq	r0, sp, r7, lsl #24
    3488:	ad040000 	stcge	0, cr0, [r4, #-0]
    348c:	06000023 	streq	r0, [r0], -r3, lsr #32
    3490:	0093167b 	addseq	r1, r3, fp, ror r6
    3494:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    3498:	03000008 	movweq	r0, #8
    349c:	0a540502 	beq	15048ac <__bss_end+0x14fa9ac>
    34a0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    34a4:	00046b07 	andeq	r6, r4, r7, lsl #22
    34a8:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    34ac:	000017b7 			; <UNDEFINED> instruction: 0x000017b7
    34b0:	af030803 	svcge	0x00030803
    34b4:	03000017 	movweq	r0, #23
    34b8:	20ad0408 	adccs	r0, sp, r8, lsl #8
    34bc:	10030000 	andne	r0, r3, r0
    34c0:	00215f03 	eoreq	r5, r1, r3, lsl #30
    34c4:	088a0c00 	stmeq	sl, {sl, fp}
    34c8:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    34cc:	24150000 	ldrcs	r0, [r5], #-0
    34d0:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    34d4:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    34d8:	be0f0000 	cdplt	0, 0, cr0, cr15, cr0, {0}
    34dc:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    34e0:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    34e4:	0f000008 	svceq	0x00000008
    34e8:	00001766 	andeq	r1, r0, r6, ror #14
    34ec:	16020206 	strne	r0, [r2], -r6, lsl #4
    34f0:	000008c9 	andeq	r0, r0, r9, asr #17
    34f4:	0023e004 	eoreq	lr, r3, r4
    34f8:	102a0700 	eorne	r0, sl, r0, lsl #14
    34fc:	000004f9 	strdeq	r0, [r0], -r9
    3500:	0008e80c 	andeq	lr, r8, ip, lsl #16
    3504:	0008ff00 	andeq	pc, r8, r0, lsl #30
    3508:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    350c:	00000357 	andeq	r0, r0, r7, asr r3
    3510:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    3514:	09000008 	stmdbeq	r0, {r3}
    3518:	0000020c 	andeq	r0, r0, ip, lsl #4
    351c:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    3520:	17000008 	strne	r0, [r0, -r8]
    3524:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3528:	0a093308 	beq	250150 <__bss_end+0x246250>
    352c:	9eed0305 	cdpls	3, 14, cr0, cr13, cr5, {0}
    3530:	0b170000 	bleq	5c3538 <__bss_end+0x5b9638>
    3534:	08000009 	stmdaeq	r0, {r0, r3}
    3538:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    353c:	009eed03 	addseq	lr, lr, r3, lsl #26
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376d14>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb8e1c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb8e3c>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb8e54>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z3powfj+0x64>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79994>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe38e78>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f6da8>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b61f4>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9a58>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4a10>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6220>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6294>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x376e10>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb8f10>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79a4c>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe38f30>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb8f48>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79a80>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4abc>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x376f00>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f6ec8>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb8fe8>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	03001605 	movweq	r1, #1541	; 0x605
 21c:	3b0b3a0e 	blcc	2cea5c <__bss_end+0x2c4b5c>
 220:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 224:	06000013 			; <UNDEFINED> instruction: 0x06000013
 228:	0b0b0024 	bleq	2c02c0 <__bss_end+0x2b63c0>
 22c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 230:	13070000 	movwne	r0, #28672	; 0x7000
 234:	0b0e0301 	bleq	380e40 <__bss_end+0x376f40>
 238:	3b0b3a0b 	blcc	2cea6c <__bss_end+0x2c4b6c>
 23c:	010b390b 	tsteq	fp, fp, lsl #18
 240:	08000013 	stmdaeq	r0, {r0, r1, r4}
 244:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 248:	0b3b0b3a 	bleq	ec2f38 <__bss_end+0xeb9038>
 24c:	13490b39 	movtne	r0, #39737	; 0x9b39
 250:	00000b38 	andeq	r0, r0, r8, lsr fp
 254:	03010409 	movweq	r0, #5129	; 0x1409
 258:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 25c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 260:	3b0b3a13 	blcc	2ceab4 <__bss_end+0x2c4bb4>
 264:	010b390b 	tsteq	fp, fp, lsl #18
 268:	0a000013 	beq	2bc <shift+0x2bc>
 26c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 270:	00000b1c 	andeq	r0, r0, ip, lsl fp
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2b9b94>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb9074>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x376f98>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe79bb8>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe3909c>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x376fd0>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb90d0>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7b114>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x377064>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb9104>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7b148>
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
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x377050>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f8470>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c4ca8>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb9170>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x37709c>
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
 3c8:	00282200 	eoreq	r2, r8, r0, lsl #4
 3cc:	051c0e03 	ldreq	r0, [ip, #-3587]	; 0xfffff1fd
 3d0:	28230000 	stmdacs	r3!, {}	; <UNPREDICTABLE>
 3d4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 3d8:	24000006 	strcs	r0, [r0], #-6
 3dc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3e0:	0b3a0e03 	bleq	e83bf4 <__bss_end+0xe79cf4>
 3e4:	0b390b3b 	bleq	e430d8 <__bss_end+0xe391d8>
 3e8:	01111349 	tsteq	r1, r9, asr #6
 3ec:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3f0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3f4:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
 3f8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3fc:	0b3b0b3a 	bleq	ec30ec <__bss_end+0xeb91ec>
 400:	13490b39 	movtne	r0, #39737	; 0x9b39
 404:	00001802 	andeq	r1, r0, r2, lsl #16
 408:	03003426 	movweq	r3, #1062	; 0x426
 40c:	3b0b3a0e 	blcc	2cec4c <__bss_end+0x2c4d4c>
 410:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 414:	00180213 	andseq	r0, r8, r3, lsl r2
 418:	010b2700 	tsteq	fp, r0, lsl #14
 41c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 420:	34280000 	strtcc	r0, [r8], #-0
 424:	3a080300 	bcc	20102c <__bss_end+0x1f712c>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 430:	29000018 	stmdbcs	r0, {r3, r4}
 434:	0111010b 	tsteq	r1, fp, lsl #2
 438:	13010612 	movwne	r0, #5650	; 0x1612
 43c:	212a0000 			; <UNDEFINED> instruction: 0x212a0000
 440:	2f134900 	svccs	0x00134900
 444:	2b000005 	blcs	460 <shift+0x460>
 448:	0e03012e 	adfeqsp	f0, f3, #0.5
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb923c>
 450:	01110b39 	tsteq	r1, r9, lsr fp
 454:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 458:	01194296 			; <UNDEFINED> instruction: 0x01194296
 45c:	2c000013 	stccs	0, cr0, [r0], {19}
 460:	0e03012e 	adfeqsp	f0, f3, #0.5
 464:	0b3b0b3a 	bleq	ec3154 <__bss_end+0xeb9254>
 468:	13490b39 	movtne	r0, #39737	; 0x9b39
 46c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 470:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 474:	00130119 	andseq	r0, r3, r9, lsl r1
 478:	012e2d00 			; <UNDEFINED> instruction: 0x012e2d00
 47c:	0b3a0e03 	bleq	e83c90 <__bss_end+0xe79d90>
 480:	0b390b3b 	bleq	e43174 <__bss_end+0xe39274>
 484:	06120111 			; <UNDEFINED> instruction: 0x06120111
 488:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 48c:	00000019 	andeq	r0, r0, r9, lsl r0
 490:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 494:	030b130e 	movweq	r1, #45838	; 0xb30e
 498:	110e1b0e 	tstne	lr, lr, lsl #22
 49c:	10061201 	andne	r1, r6, r1, lsl #4
 4a0:	02000017 	andeq	r0, r0, #23
 4a4:	0b0b0024 	bleq	2c053c <__bss_end+0x2b663c>
 4a8:	0e030b3e 	vmoveq.16	d3[0], r0
 4ac:	26030000 	strcs	r0, [r3], -r0
 4b0:	00134900 	andseq	r4, r3, r0, lsl #18
 4b4:	00160400 	andseq	r0, r6, r0, lsl #8
 4b8:	0b3a0e03 	bleq	e83ccc <__bss_end+0xe79dcc>
 4bc:	0b390b3b 	bleq	e431b0 <__bss_end+0xe392b0>
 4c0:	00001349 	andeq	r1, r0, r9, asr #6
 4c4:	0b002405 	bleq	94e0 <_Z11split_floatfRjS_Ri+0x384>
 4c8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4cc:	06000008 	streq	r0, [r0], -r8
 4d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeb92c4>
 4d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 4dc:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 4e0:	13070000 	movwne	r0, #28672	; 0x7000
 4e4:	0b0e0301 	bleq	3810f0 <__bss_end+0x3771f0>
 4e8:	3b0b3a0b 	blcc	2ced1c <__bss_end+0x2c4e1c>
 4ec:	010b390b 	tsteq	fp, fp, lsl #18
 4f0:	08000013 	stmdaeq	r0, {r0, r1, r4}
 4f4:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 4f8:	0b3b0b3a 	bleq	ec31e8 <__bss_end+0xeb92e8>
 4fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 500:	00000b38 	andeq	r0, r0, r8, lsr fp
 504:	03010409 	movweq	r0, #5129	; 0x1409
 508:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 50c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 510:	3b0b3a13 	blcc	2ced64 <__bss_end+0x2c4e64>
 514:	010b390b 	tsteq	fp, fp, lsl #18
 518:	0a000013 	beq	56c <shift+0x56c>
 51c:	08030028 	stmdaeq	r3, {r3, r5}
 520:	00000b1c 	andeq	r0, r0, ip, lsl fp
 524:	0300280b 	movweq	r2, #2059	; 0x80b
 528:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 52c:	00020c00 	andeq	r0, r2, r0, lsl #24
 530:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 534:	020d0000 	andeq	r0, sp, #0
 538:	0b0e0301 	bleq	381144 <__bss_end+0x377244>
 53c:	3b0b3a0b 	blcc	2ced70 <__bss_end+0x2c4e70>
 540:	010b390b 	tsteq	fp, fp, lsl #18
 544:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 548:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 54c:	0b3b0b3a 	bleq	ec323c <__bss_end+0xeb933c>
 550:	13490b39 	movtne	r0, #39737	; 0x9b39
 554:	00000b38 	andeq	r0, r0, r8, lsr fp
 558:	3f012e0f 	svccc	0x00012e0f
 55c:	3a0e0319 	bcc	3811c8 <__bss_end+0x3772c8>
 560:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 564:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 568:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 56c:	10000013 	andne	r0, r0, r3, lsl r0
 570:	13490005 	movtne	r0, #36869	; 0x9005
 574:	00001934 	andeq	r1, r0, r4, lsr r9
 578:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 57c:	12000013 	andne	r0, r0, #19
 580:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 584:	0b3b0b3a 	bleq	ec3274 <__bss_end+0xeb9374>
 588:	13490b39 	movtne	r0, #39737	; 0x9b39
 58c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 590:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 594:	03193f01 	tsteq	r9, #1, 30
 598:	3b0b3a0e 	blcc	2cedd8 <__bss_end+0x2c4ed8>
 59c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a0:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5a4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5a8:	00130113 	andseq	r0, r3, r3, lsl r1
 5ac:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 5b0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5b4:	0b3b0b3a 	bleq	ec32a4 <__bss_end+0xeb93a4>
 5b8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5bc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5c0:	13011364 	movwne	r1, #4964	; 0x1364
 5c4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 5c8:	03193f01 	tsteq	r9, #1, 30
 5cc:	3b0b3a0e 	blcc	2cee0c <__bss_end+0x2c4f0c>
 5d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5dc:	16000013 			; <UNDEFINED> instruction: 0x16000013
 5e0:	13490101 	movtne	r0, #37121	; 0x9101
 5e4:	00001301 	andeq	r1, r0, r1, lsl #6
 5e8:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 5ec:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5f0:	000f1800 	andeq	r1, pc, r0, lsl #16
 5f4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5f8:	21190000 	tstcs	r9, r0
 5fc:	1a000000 	bne	604 <shift+0x604>
 600:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 604:	0b3b0b3a 	bleq	ec32f4 <__bss_end+0xeb93f4>
 608:	13490b39 	movtne	r0, #39737	; 0x9b39
 60c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 610:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 614:	03193f01 	tsteq	r9, #1, 30
 618:	3b0b3a0e 	blcc	2cee58 <__bss_end+0x2c4f58>
 61c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 620:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 624:	00130113 	andseq	r0, r3, r3, lsl r1
 628:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 62c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeb9420>
 634:	0e6e0b39 	vmoveq.8	d14[5], r0
 638:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 63c:	13011364 	movwne	r1, #4964	; 0x1364
 640:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 644:	3a0e0300 	bcc	38124c <__bss_end+0x37734c>
 648:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 64c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 650:	000b320b 	andeq	r3, fp, fp, lsl #4
 654:	01151e00 	tsteq	r5, r0, lsl #28
 658:	13641349 	cmnne	r4, #603979777	; 0x24000001
 65c:	00001301 	andeq	r1, r0, r1, lsl #6
 660:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 664:	00134913 	andseq	r4, r3, r3, lsl r9
 668:	00102000 	andseq	r2, r0, r0
 66c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 670:	0f210000 	svceq	0x00210000
 674:	000b0b00 	andeq	r0, fp, r0, lsl #22
 678:	00342200 	eorseq	r2, r4, r0, lsl #4
 67c:	0b3a0e03 	bleq	e83e90 <__bss_end+0xe79f90>
 680:	0b390b3b 	bleq	e43374 <__bss_end+0xe39474>
 684:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 688:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 68c:	03193f01 	tsteq	r9, #1, 30
 690:	3b0b3a0e 	blcc	2ceed0 <__bss_end+0x2c4fd0>
 694:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 698:	1113490e 	tstne	r3, lr, lsl #18
 69c:	40061201 	andmi	r1, r6, r1, lsl #4
 6a0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 6a4:	00001301 	andeq	r1, r0, r1, lsl #6
 6a8:	03000524 	movweq	r0, #1316	; 0x524
 6ac:	3b0b3a0e 	blcc	2ceeec <__bss_end+0x2c4fec>
 6b0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6b4:	00180213 	andseq	r0, r8, r3, lsl r2
 6b8:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 6bc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6c0:	0b3b0b3a 	bleq	ec33b0 <__bss_end+0xeb94b0>
 6c4:	0e6e0b39 	vmoveq.8	d14[5], r0
 6c8:	01111349 	tsteq	r1, r9, asr #6
 6cc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6d0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 6d4:	26000013 			; <UNDEFINED> instruction: 0x26000013
 6d8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 6dc:	0b3b0b3a 	bleq	ec33cc <__bss_end+0xeb94cc>
 6e0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6e4:	00001802 	andeq	r1, r0, r2, lsl #16
 6e8:	3f012e27 	svccc	0x00012e27
 6ec:	3a0e0319 	bcc	381358 <__bss_end+0x377458>
 6f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6f4:	110e6e0b 	tstne	lr, fp, lsl #28
 6f8:	40061201 	andmi	r1, r6, r1, lsl #4
 6fc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 700:	00001301 	andeq	r1, r0, r1, lsl #6
 704:	3f002e28 	svccc	0x00002e28
 708:	3a0e0319 	bcc	381374 <__bss_end+0x377474>
 70c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 710:	110e6e0b 	tstne	lr, fp, lsl #28
 714:	40061201 	andmi	r1, r6, r1, lsl #4
 718:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 71c:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 720:	03193f01 	tsteq	r9, #1, 30
 724:	3b0b3a0e 	blcc	2cef64 <__bss_end+0x2c5064>
 728:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 72c:	1113490e 	tstne	r3, lr, lsl #18
 730:	40061201 	andmi	r1, r6, r1, lsl #4
 734:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 738:	01000000 	mrseq	r0, (UNDEF: 0)
 73c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 740:	0e030b13 	vmoveq.32	d3[0], r0
 744:	01110e1b 	tsteq	r1, fp, lsl lr
 748:	17100612 			; <UNDEFINED> instruction: 0x17100612
 74c:	24020000 	strcs	r0, [r2], #-0
 750:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 754:	000e030b 	andeq	r0, lr, fp, lsl #6
 758:	00260300 	eoreq	r0, r6, r0, lsl #6
 75c:	00001349 	andeq	r1, r0, r9, asr #6
 760:	03001604 	movweq	r1, #1540	; 0x604
 764:	3b0b3a0e 	blcc	2cefa4 <__bss_end+0x2c50a4>
 768:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 76c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 770:	0b0b0024 	bleq	2c0808 <__bss_end+0x2b6908>
 774:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 778:	34060000 	strcc	r0, [r6], #-0
 77c:	3a0e0300 	bcc	381384 <__bss_end+0x377484>
 780:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 784:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 788:	00180219 	andseq	r0, r8, r9, lsl r2
 78c:	01130700 	tsteq	r3, r0, lsl #14
 790:	0b0b0e03 	bleq	2c3fa4 <__bss_end+0x2ba0a4>
 794:	0b3b0b3a 	bleq	ec3484 <__bss_end+0xeb9584>
 798:	13010b39 	movwne	r0, #6969	; 0x1b39
 79c:	0d080000 	stceq	0, cr0, [r8, #-0]
 7a0:	3a080300 	bcc	2013a8 <__bss_end+0x1f74a8>
 7a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7a8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 7ac:	0900000b 	stmdbeq	r0, {r0, r1, r3}
 7b0:	0e030104 	adfeqs	f0, f3, f4
 7b4:	0b3e196d 	bleq	f86d70 <__bss_end+0xf7ce70>
 7b8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7bc:	0b3b0b3a 	bleq	ec34ac <__bss_end+0xeb95ac>
 7c0:	13010b39 	movwne	r0, #6969	; 0x1b39
 7c4:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 7c8:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 7cc:	0b00000b 	bleq	800 <shift+0x800>
 7d0:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 7d4:	0000193c 	andeq	r1, r0, ip, lsr r9
 7d8:	0301020c 	movweq	r0, #4620	; 0x120c
 7dc:	3a0b0b0e 	bcc	2c341c <__bss_end+0x2b951c>
 7e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7e4:	0013010b 	andseq	r0, r3, fp, lsl #2
 7e8:	000d0d00 	andeq	r0, sp, r0, lsl #26
 7ec:	0b3a0e03 	bleq	e84000 <__bss_end+0xe7a100>
 7f0:	0b390b3b 	bleq	e434e4 <__bss_end+0xe395e4>
 7f4:	0b381349 	bleq	e05520 <__bss_end+0xdfb620>
 7f8:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 7fc:	03193f01 	tsteq	r9, #1, 30
 800:	3b0b3a0e 	blcc	2cf040 <__bss_end+0x2c5140>
 804:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 808:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 80c:	00136419 	andseq	r6, r3, r9, lsl r4
 810:	00050f00 	andeq	r0, r5, r0, lsl #30
 814:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 818:	05100000 	ldreq	r0, [r0, #-0]
 81c:	00134900 	andseq	r4, r3, r0, lsl #18
 820:	000d1100 	andeq	r1, sp, r0, lsl #2
 824:	0b3a0e03 	bleq	e84038 <__bss_end+0xe7a138>
 828:	0b390b3b 	bleq	e4351c <__bss_end+0xe3961c>
 82c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 830:	0000193c 	andeq	r1, r0, ip, lsr r9
 834:	3f012e12 	svccc	0x00012e12
 838:	3a0e0319 	bcc	3814a4 <__bss_end+0x3775a4>
 83c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 840:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 844:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 848:	01136419 	tsteq	r3, r9, lsl r4
 84c:	13000013 	movwne	r0, #19
 850:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 854:	0b3a0e03 	bleq	e84068 <__bss_end+0xe7a168>
 858:	0b390b3b 	bleq	e4354c <__bss_end+0xe3964c>
 85c:	0b320e6e 	bleq	c8421c <__bss_end+0xc7a31c>
 860:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 864:	00001301 	andeq	r1, r0, r1, lsl #6
 868:	3f012e14 	svccc	0x00012e14
 86c:	3a0e0319 	bcc	3814d8 <__bss_end+0x3775d8>
 870:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 874:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 878:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 87c:	00136419 	andseq	r6, r3, r9, lsl r4
 880:	01011500 	tsteq	r1, r0, lsl #10
 884:	13011349 	movwne	r1, #4937	; 0x1349
 888:	21160000 	tstcs	r6, r0
 88c:	2f134900 	svccs	0x00134900
 890:	1700000b 	strne	r0, [r0, -fp]
 894:	0b0b000f 	bleq	2c08d8 <__bss_end+0x2b69d8>
 898:	00001349 	andeq	r1, r0, r9, asr #6
 89c:	00002118 	andeq	r2, r0, r8, lsl r1
 8a0:	00341900 	eorseq	r1, r4, r0, lsl #18
 8a4:	0b3a0e03 	bleq	e840b8 <__bss_end+0xe7a1b8>
 8a8:	0b390b3b 	bleq	e4359c <__bss_end+0xe3969c>
 8ac:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 8b0:	0000193c 	andeq	r1, r0, ip, lsr r9
 8b4:	0300281a 	movweq	r2, #2074	; 0x81a
 8b8:	000b1c08 	andeq	r1, fp, r8, lsl #24
 8bc:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 8c0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8c4:	0b3b0b3a 	bleq	ec35b4 <__bss_end+0xeb96b4>
 8c8:	0e6e0b39 	vmoveq.8	d14[5], r0
 8cc:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 8d0:	00001301 	andeq	r1, r0, r1, lsl #6
 8d4:	3f012e1c 	svccc	0x00012e1c
 8d8:	3a0e0319 	bcc	381544 <__bss_end+0x377644>
 8dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8e0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 8e4:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 8e8:	00130113 	andseq	r0, r3, r3, lsl r1
 8ec:	000d1d00 	andeq	r1, sp, r0, lsl #26
 8f0:	0b3a0e03 	bleq	e84104 <__bss_end+0xe7a204>
 8f4:	0b390b3b 	bleq	e435e8 <__bss_end+0xe396e8>
 8f8:	0b381349 	bleq	e05624 <__bss_end+0xdfb724>
 8fc:	00000b32 	andeq	r0, r0, r2, lsr fp
 900:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
 904:	01136413 	tsteq	r3, r3, lsl r4
 908:	1f000013 	svcne	0x00000013
 90c:	131d001f 	tstne	sp, #31
 910:	00001349 	andeq	r1, r0, r9, asr #6
 914:	0b001020 	bleq	499c <shift+0x499c>
 918:	0013490b 	andseq	r4, r3, fp, lsl #18
 91c:	000f2100 	andeq	r2, pc, r0, lsl #2
 920:	00000b0b 	andeq	r0, r0, fp, lsl #22
 924:	3f012e22 	svccc	0x00012e22
 928:	3a0e0319 	bcc	381594 <__bss_end+0x377694>
 92c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 930:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 934:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 938:	96184006 	ldrls	r4, [r8], -r6
 93c:	13011942 	movwne	r1, #6466	; 0x1942
 940:	05230000 	streq	r0, [r3, #-0]!
 944:	3a0e0300 	bcc	38154c <__bss_end+0x37764c>
 948:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 94c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 950:	24000018 	strcs	r0, [r0], #-24	; 0xffffffe8
 954:	08030005 	stmdaeq	r3, {r0, r2}
 958:	0b3b0b3a 	bleq	ec3648 <__bss_end+0xeb9748>
 95c:	13490b39 	movtne	r0, #39737	; 0x9b39
 960:	00001802 	andeq	r1, r0, r2, lsl #16
 964:	03003425 	movweq	r3, #1061	; 0x425
 968:	3b0b3a0e 	blcc	2cf1a8 <__bss_end+0x2c52a8>
 96c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 970:	00180213 	andseq	r0, r8, r3, lsl r2
 974:	012e2600 			; <UNDEFINED> instruction: 0x012e2600
 978:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 97c:	0b3b0b3a 	bleq	ec366c <__bss_end+0xeb976c>
 980:	0e6e0b39 	vmoveq.8	d14[5], r0
 984:	01111349 	tsteq	r1, r9, asr #6
 988:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 98c:	00194296 	mulseq	r9, r6, r2
 990:	11010000 	mrsne	r0, (UNDEF: 1)
 994:	130e2501 	movwne	r2, #58625	; 0xe501
 998:	1b0e030b 	blne	3815cc <__bss_end+0x3776cc>
 99c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 9a0:	00171006 	andseq	r1, r7, r6
 9a4:	00340200 	eorseq	r0, r4, r0, lsl #4
 9a8:	0b3a0e03 	bleq	e841bc <__bss_end+0xe7a2bc>
 9ac:	0b390b3b 	bleq	e436a0 <__bss_end+0xe397a0>
 9b0:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 9b4:	00001802 	andeq	r1, r0, r2, lsl #16
 9b8:	0b002403 	bleq	99cc <_Z4ftoafPcj+0x2b0>
 9bc:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 9c0:	0400000e 	streq	r0, [r0], #-14
 9c4:	13490026 	movtne	r0, #36902	; 0x9026
 9c8:	39050000 	stmdbcc	r5, {}	; <UNPREDICTABLE>
 9cc:	00130101 	andseq	r0, r3, r1, lsl #2
 9d0:	00340600 	eorseq	r0, r4, r0, lsl #12
 9d4:	0b3a0e03 	bleq	e841e8 <__bss_end+0xe7a2e8>
 9d8:	0b390b3b 	bleq	e436cc <__bss_end+0xe397cc>
 9dc:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 9e0:	00000a1c 	andeq	r0, r0, ip, lsl sl
 9e4:	3a003a07 	bcc	f208 <__bss_end+0x5308>
 9e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9ec:	0013180b 	andseq	r1, r3, fp, lsl #16
 9f0:	01010800 	tsteq	r1, r0, lsl #16
 9f4:	13011349 	movwne	r1, #4937	; 0x1349
 9f8:	21090000 	mrscs	r0, (UNDEF: 9)
 9fc:	2f134900 	svccs	0x00134900
 a00:	0a00000b 	beq	a34 <shift+0xa34>
 a04:	13470034 	movtne	r0, #28724	; 0x7034
 a08:	2e0b0000 	cdpcs	0, 0, cr0, cr11, cr0, {0}
 a0c:	03193f01 	tsteq	r9, #1, 30
 a10:	3b0b3a0e 	blcc	2cf250 <__bss_end+0x2c5350>
 a14:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a18:	1113490e 	tstne	r3, lr, lsl #18
 a1c:	40061201 	andmi	r1, r6, r1, lsl #4
 a20:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 a24:	00001301 	andeq	r1, r0, r1, lsl #6
 a28:	0300050c 	movweq	r0, #1292	; 0x50c
 a2c:	3b0b3a08 	blcc	2cf254 <__bss_end+0x2c5354>
 a30:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 a34:	00180213 	andseq	r0, r8, r3, lsl r2
 a38:	00340d00 	eorseq	r0, r4, r0, lsl #26
 a3c:	0b3a0803 	bleq	e82a50 <__bss_end+0xe78b50>
 a40:	0b390b3b 	bleq	e43734 <__bss_end+0xe39834>
 a44:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 a48:	340e0000 	strcc	r0, [lr], #-0
 a4c:	3a0e0300 	bcc	381654 <__bss_end+0x377754>
 a50:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a54:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 a58:	0f000018 	svceq	0x00000018
 a5c:	0111010b 	tsteq	r1, fp, lsl #2
 a60:	00000612 	andeq	r0, r0, r2, lsl r6
 a64:	03003410 	movweq	r3, #1040	; 0x410
 a68:	3b0b3a0e 	blcc	2cf2a8 <__bss_end+0x2c53a8>
 a6c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 a70:	00180213 	andseq	r0, r8, r3, lsl r2
 a74:	00341100 	eorseq	r1, r4, r0, lsl #2
 a78:	0b3a0803 	bleq	e82a8c <__bss_end+0xe78b8c>
 a7c:	0b39053b 	bleq	e41f70 <__bss_end+0xe38070>
 a80:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 a84:	0f120000 	svceq	0x00120000
 a88:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 a8c:	13000013 	movwne	r0, #19
 a90:	0b0b0024 	bleq	2c0b28 <__bss_end+0x2b6c28>
 a94:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 a98:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 a9c:	03193f01 	tsteq	r9, #1, 30
 aa0:	3b0b3a0e 	blcc	2cf2e0 <__bss_end+0x2c53e0>
 aa4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 aa8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 aac:	96184006 	ldrls	r4, [r8], -r6
 ab0:	13011942 	movwne	r1, #6466	; 0x1942
 ab4:	05150000 	ldreq	r0, [r5, #-0]
 ab8:	3a0e0300 	bcc	3816c0 <__bss_end+0x3777c0>
 abc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ac0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 ac4:	16000018 			; <UNDEFINED> instruction: 0x16000018
 ac8:	0111010b 	tsteq	r1, fp, lsl #2
 acc:	13010612 	movwne	r0, #5650	; 0x1612
 ad0:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 ad4:	03193f01 	tsteq	r9, #1, 30
 ad8:	3b0b3a0e 	blcc	2cf318 <__bss_end+0x2c5418>
 adc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 ae0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 ae4:	97184006 	ldrls	r4, [r8, -r6]
 ae8:	13011942 	movwne	r1, #6466	; 0x1942
 aec:	10180000 	andsne	r0, r8, r0
 af0:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 af4:	19000013 	stmdbne	r0, {r0, r1, r4}
 af8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 afc:	0b3a0803 	bleq	e82b10 <__bss_end+0xe78c10>
 b00:	0b390b3b 	bleq	e437f4 <__bss_end+0xe398f4>
 b04:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 b08:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b0c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 b10:	00130119 	andseq	r0, r3, r9, lsl r1
 b14:	00261a00 	eoreq	r1, r6, r0, lsl #20
 b18:	0f1b0000 	svceq	0x001b0000
 b1c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 b20:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 b24:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 b28:	0b3b0b3a 	bleq	ec3818 <__bss_end+0xeb9918>
 b2c:	0e6e0b39 	vmoveq.8	d14[5], r0
 b30:	06120111 			; <UNDEFINED> instruction: 0x06120111
 b34:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 b38:	00000019 	andeq	r0, r0, r9, lsl r0
 b3c:	10001101 	andne	r1, r0, r1, lsl #2
 b40:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 b44:	1b0e0301 	blne	381750 <__bss_end+0x377850>
 b48:	130e250e 	movwne	r2, #58638	; 0xe50e
 b4c:	00000005 	andeq	r0, r0, r5
 b50:	10001101 	andne	r1, r0, r1, lsl #2
 b54:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 b58:	1b0e0301 	blne	381764 <__bss_end+0x377864>
 b5c:	130e250e 	movwne	r2, #58638	; 0xe50e
 b60:	00000005 	andeq	r0, r0, r5
 b64:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 b68:	030b130e 	movweq	r1, #45838	; 0xb30e
 b6c:	100e1b0e 	andne	r1, lr, lr, lsl #22
 b70:	02000017 	andeq	r0, r0, #23
 b74:	0b0b0024 	bleq	2c0c0c <__bss_end+0x2b6d0c>
 b78:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 b7c:	24030000 	strcs	r0, [r3], #-0
 b80:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 b84:	000e030b 	andeq	r0, lr, fp, lsl #6
 b88:	00160400 	andseq	r0, r6, r0, lsl #8
 b8c:	0b3a0e03 	bleq	e843a0 <__bss_end+0xe7a4a0>
 b90:	0b390b3b 	bleq	e43884 <__bss_end+0xe39984>
 b94:	00001349 	andeq	r1, r0, r9, asr #6
 b98:	0b000f05 	bleq	47b4 <shift+0x47b4>
 b9c:	0013490b 	andseq	r4, r3, fp, lsl #18
 ba0:	01150600 	tsteq	r5, r0, lsl #12
 ba4:	13491927 	movtne	r1, #39207	; 0x9927
 ba8:	00001301 	andeq	r1, r0, r1, lsl #6
 bac:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 bb0:	08000013 	stmdaeq	r0, {r0, r1, r4}
 bb4:	00000026 	andeq	r0, r0, r6, lsr #32
 bb8:	03003409 	movweq	r3, #1033	; 0x409
 bbc:	3b0b3a0e 	blcc	2cf3fc <__bss_end+0x2c54fc>
 bc0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 bc4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 bc8:	0a000019 	beq	c34 <shift+0xc34>
 bcc:	0e030104 	adfeqs	f0, f3, f4
 bd0:	0b0b0b3e 	bleq	2c38d0 <__bss_end+0x2b99d0>
 bd4:	0b3a1349 	bleq	e85900 <__bss_end+0xe7ba00>
 bd8:	0b390b3b 	bleq	e438cc <__bss_end+0xe399cc>
 bdc:	00001301 	andeq	r1, r0, r1, lsl #6
 be0:	0300280b 	movweq	r2, #2059	; 0x80b
 be4:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 be8:	01010c00 	tsteq	r1, r0, lsl #24
 bec:	13011349 	movwne	r1, #4937	; 0x1349
 bf0:	210d0000 	mrscs	r0, (UNDEF: 13)
 bf4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 bf8:	13490026 	movtne	r0, #36902	; 0x9026
 bfc:	340f0000 	strcc	r0, [pc], #-0	; c04 <shift+0xc04>
 c00:	3a0e0300 	bcc	381808 <__bss_end+0x377908>
 c04:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c08:	3f13490b 	svccc	0x0013490b
 c0c:	00193c19 	andseq	r3, r9, r9, lsl ip
 c10:	00131000 	andseq	r1, r3, r0
 c14:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 c18:	15110000 	ldrne	r0, [r1, #-0]
 c1c:	00192700 	andseq	r2, r9, r0, lsl #14
 c20:	00171200 	andseq	r1, r7, r0, lsl #4
 c24:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 c28:	13130000 	tstne	r3, #0
 c2c:	0b0e0301 	bleq	381838 <__bss_end+0x377938>
 c30:	3b0b3a0b 	blcc	2cf464 <__bss_end+0x2c5564>
 c34:	010b3905 	tsteq	fp, r5, lsl #18
 c38:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 c3c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 c40:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c44:	13490b39 	movtne	r0, #39737	; 0x9b39
 c48:	00000b38 	andeq	r0, r0, r8, lsr fp
 c4c:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 c50:	000b2f13 	andeq	r2, fp, r3, lsl pc
 c54:	01041600 	tsteq	r4, r0, lsl #12
 c58:	0b3e0e03 	bleq	f8446c <__bss_end+0xf7a56c>
 c5c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c60:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c64:	13010b39 	movwne	r0, #6969	; 0x1b39
 c68:	34170000 	ldrcc	r0, [r7], #-0
 c6c:	3a134700 	bcc	4d2874 <__bss_end+0x4c8974>
 c70:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c74:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  74:	000003cc 	andeq	r0, r0, ip, asr #7
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0de40002 	stcleq	0, cr0, [r4, #8]!
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000085f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1b440002 	blne	11000b4 <__bss_end+0x10f61b4>
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008a54 	andeq	r8, r0, r4, asr sl
  b4:	00000120 	andeq	r0, r0, r0, lsr #2
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	24c30002 	strbcs	r0, [r3], #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008b74 	andeq	r8, r0, r4, ror fp
  d4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	2bc00002 	blcs	ff0000f4 <__bss_end+0xfeff61f4>
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009b50 	andeq	r9, r0, r0, asr fp
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	2be60002 	blcs	ff980114 <__bss_end+0xff976214>
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009d5c 	andeq	r9, r0, ip, asr sp
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	2c0c0002 	stccs	0, cr0, [ip], {2}
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff604c>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff5df1>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff5df3>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4b08>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff5f41>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be478>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfa24>
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
     398:	42007070 	andmi	r7, r0, #112	; 0x70
     39c:	37355f52 			; <UNDEFINED> instruction: 0x37355f52
     3a0:	00303036 	eorseq	r3, r0, r6, lsr r0
     3a4:	6b636954 	blvs	18da8fc <__bss_end+0x18d09fc>
     3a8:	756f435f 	strbvc	r4, [pc, #-863]!	; 51 <shift+0x51>
     3ac:	4900746e 	stmdbmi	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     3b0:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     3b4:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     3b8:	704f0065 	subvc	r0, pc, r5, rrx
     3bc:	4e006e65 	cdpmi	14, 0, cr6, cr0, cr5, {3}
     3c0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     3c4:	6168435f 	cmnvs	r8, pc, asr r3
     3c8:	654c5f72 	strbvs	r5, [ip, #-3954]	; 0xfffff08e
     3cc:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     3d0:	72747300 	rsbsvc	r7, r4, #0, 6
     3d4:	00676e69 	rsbeq	r6, r7, r9, ror #28
     3d8:	325f5242 	subscc	r5, pc, #536870916	; 0x20000004
     3dc:	00303034 	eorseq	r3, r0, r4, lsr r0
     3e0:	76657270 			; <UNDEFINED> instruction: 0x76657270
     3e4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3e8:	50433631 	subpl	r3, r3, r1, lsr r6
     3ec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3f0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 22c <shift+0x22c>
     3f4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     3f8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     3fc:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     400:	505f7966 	subspl	r7, pc, r6, ror #18
     404:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     408:	50457373 	subpl	r7, r5, r3, ror r3
     40c:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     410:	5f6b7361 	svcpl	0x006b7361
     414:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     418:	5f007463 	svcpl	0x00007463
     41c:	31314e5a 	teqcc	r1, sl, asr lr
     420:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     424:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     428:	316d6574 	smccc	54868	; 0xd654
     42c:	53465433 	movtpl	r5, #25651	; 0x6433
     430:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
     434:	6f4e5f65 	svcvs	0x004e5f65
     438:	30316564 	eorscc	r6, r1, r4, ror #10
     43c:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
     440:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
     444:	5045646c 	subpl	r6, r5, ip, ror #8
     448:	5500634b 	strpl	r6, [r0, #-843]	; 0xfffffcb5
     44c:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     450:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     454:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     458:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     45c:	68630074 	stmdavs	r3!, {r2, r4, r5, r6}^
     460:	765f7261 	ldrbvc	r7, [pc], -r1, ror #4
     464:	695f6c61 	ldmdbvs	pc, {r0, r5, r6, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     468:	6c00746e 	cfstrsvs	mvf7, [r0], {110}	; 0x6e
     46c:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     470:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     474:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     478:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     47c:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     480:	506d0074 	rsbpl	r0, sp, r4, ror r0
     484:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     488:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     48c:	5f747369 	svcpl	0x00747369
     490:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     494:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
     498:	61725f64 	cmnvs	r2, r4, ror #30
     49c:	5f006574 	svcpl	0x00006574
     4a0:	314b4e5a 	cmpcc	fp, sl, asr lr
     4a4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     4a8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4ac:	614d5f73 	hvcvs	54771	; 0xd5f3
     4b0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4b4:	47393172 			; <UNDEFINED> instruction: 0x47393172
     4b8:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     4bc:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     4c0:	505f746e 	subspl	r7, pc, lr, ror #8
     4c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4c8:	76457373 			; <UNDEFINED> instruction: 0x76457373
     4cc:	5f524200 	svcpl	0x00524200
     4d0:	30303834 	eorscc	r3, r0, r4, lsr r8
     4d4:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     4d8:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     4dc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4e4:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4e8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     4ec:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff7f4 <__bss_end+0xffff58f4>
     4f0:	6f50746e 	svcvs	0x0050746e
     4f4:	00746e69 	rsbseq	r6, r4, r9, ror #28
     4f8:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     4fc:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     500:	0079726f 	rsbseq	r7, r9, pc, ror #4
     504:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     508:	6f72505f 	svcvs	0x0072505f
     50c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     510:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     514:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     518:	61655200 	cmnvs	r5, r0, lsl #4
     51c:	63410064 	movtvs	r0, #4196	; 0x1064
     520:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     524:	6f72505f 	svcvs	0x0072505f
     528:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     52c:	756f435f 	strbvc	r4, [pc, #-863]!	; 1d5 <shift+0x1d5>
     530:	4300746e 	movwmi	r7, #1134	; 0x46e
     534:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     538:	72505f65 	subsvc	r5, r0, #404	; 0x194
     53c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     540:	61700073 	cmnvs	r0, r3, ror r0
     544:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     548:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     54c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     550:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     554:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     558:	47006874 	smlsdxmi	r0, r4, r8, r6
     55c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     560:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     564:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     568:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     56c:	6544006f 	strbvs	r0, [r4, #-111]	; 0xffffff91
     570:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     574:	555f656e 	ldrbpl	r6, [pc, #-1390]	; e <shift+0xe>
     578:	6168636e 	cmnvs	r8, lr, ror #6
     57c:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     580:	72504300 	subsvc	r4, r0, #0, 6
     584:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     588:	614d5f73 	hvcvs	54771	; 0xd5f3
     58c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     590:	5a5f0072 	bpl	17c0760 <__bss_end+0x17b6860>
     594:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     598:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     59c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     5a0:	34436d65 	strbcc	r6, [r3], #-3429	; 0xfffff29b
     5a4:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     5a8:	445f5346 	ldrbmi	r5, [pc], #-838	; 5b0 <shift+0x5b0>
     5ac:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     5b0:	6e690072 	mcrvs	0, 3, r0, cr9, cr2, {3}
     5b4:	755f7469 	ldrbvc	r7, [pc, #-1129]	; 153 <shift+0x153>
     5b8:	00747261 	rsbseq	r7, r4, r1, ror #4
     5bc:	314e5a5f 	cmpcc	lr, pc, asr sl
     5c0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c8:	614d5f73 	hvcvs	54771	; 0xd5f3
     5cc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5d0:	47383172 			; <UNDEFINED> instruction: 0x47383172
     5d4:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     5d8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     5dc:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     5e0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     5e4:	3032456f 	eorscc	r4, r2, pc, ror #10
     5e8:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     5ec:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     5f0:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     5f4:	5f6f666e 	svcpl	0x006f666e
     5f8:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     5fc:	5f007650 	svcpl	0x00007650
     600:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     604:	6f725043 	svcvs	0x00725043
     608:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     60c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     610:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     614:	61483132 	cmpvs	r8, r2, lsr r1
     618:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     61c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     620:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     624:	5f6d6574 	svcpl	0x006d6574
     628:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     62c:	534e3332 	movtpl	r3, #58162	; 0xe332
     630:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     634:	73656c69 	cmnvc	r5, #26880	; 0x6900
     638:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     63c:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     640:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     644:	6a6a6a65 	bvs	1a9afe0 <__bss_end+0x1a910e0>
     648:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     64c:	5f495753 	svcpl	0x00495753
     650:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     654:	6f00746c 	svcvs	0x0000746c
     658:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     65c:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     660:	0073656c 	rsbseq	r6, r3, ip, ror #10
     664:	6e69616d 	powvsez	f6, f1, #5.0
     668:	746f4e00 	strbtvc	r4, [pc], #-3584	; 670 <shift+0x670>
     66c:	41796669 	cmnmi	r9, r9, ror #12
     670:	54006c6c 	strpl	r6, [r0], #-3180	; 0xfffff394
     674:	5f555043 	svcpl	0x00555043
     678:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     67c:	00747865 	rsbseq	r7, r4, r5, ror #16
     680:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     684:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     688:	62747400 	rsbsvs	r7, r4, #0, 8
     68c:	5f003072 	svcpl	0x00003072
     690:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     694:	6f725043 	svcvs	0x00725043
     698:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     69c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6a0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6a4:	6f4e3431 	svcvs	0x004e3431
     6a8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6ac:	6f72505f 	svcvs	0x0072505f
     6b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b4:	55006a45 	strpl	r6, [r0, #-2629]	; 0xfffff5bb
     6b8:	33544e49 	cmpcc	r4, #1168	; 0x490
     6bc:	414d5f32 	cmpmi	sp, r2, lsr pc
     6c0:	69460058 	stmdbvs	r6, {r3, r4, r6}^
     6c4:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     6c8:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     6cc:	746f6e00 	strbtvc	r6, [pc], #-3584	; 6d4 <shift+0x6d4>
     6d0:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     6d4:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     6d8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     6dc:	4e00656e 	cfsh32mi	mvfx6, mvfx0, #62
     6e0:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     6e4:	7561425f 	strbvc	r4, [r1, #-607]!	; 0xfffffda1
     6e8:	61525f64 	cmpvs	r2, r4, ror #30
     6ec:	43006574 	movwmi	r6, #1396	; 0x574
     6f0:	5f726168 	svcpl	0x00726168
     6f4:	68430037 	stmdavs	r3, {r0, r1, r2, r4, r5}^
     6f8:	385f7261 	ldmdacc	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     6fc:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     700:	6f72505f 	svcvs	0x0072505f
     704:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     708:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     70c:	5f64656e 	svcpl	0x0064656e
     710:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     714:	5a5f0073 	bpl	17c08e8 <__bss_end+0x17b69e8>
     718:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     71c:	636f7250 	cmnvs	pc, #80, 4
     720:	5f737365 	svcpl	0x00737365
     724:	616e614d 	cmnvs	lr, sp, asr #2
     728:	31726567 	cmncc	r2, r7, ror #10
     72c:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     730:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     734:	5f656c69 	svcpl	0x00656c69
     738:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     73c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     740:	4955006a 	ldmdbmi	r5, {r1, r3, r5, r6}^
     744:	3233544e 	eorscc	r5, r3, #1308622848	; 0x4e000000
     748:	4e494d5f 	mcrmi	13, 2, r4, cr9, cr15, {2}
     74c:	53466700 	movtpl	r6, #26368	; 0x6700
     750:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     754:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     758:	756f435f 	strbvc	r4, [pc, #-863]!	; 401 <shift+0x401>
     75c:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     760:	746f6f52 	strbtvc	r6, [pc], #-3922	; 768 <shift+0x768>
     764:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     768:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     76c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     770:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     774:	6f72505f 	svcvs	0x0072505f
     778:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     77c:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     780:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     784:	6f545f65 	svcvs	0x00545f65
     788:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     78c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     790:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     794:	73656c69 	cmnvc	r5, #26880	; 0x6900
     798:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     79c:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     7a0:	00726576 	rsbseq	r6, r2, r6, ror r5
     7a4:	5f746553 	svcpl	0x00746553
     7a8:	61726150 	cmnvs	r2, r0, asr r1
     7ac:	4800736d 	stmdami	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp, lr}
     7b0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7b4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     7b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7bc:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     7c0:	68730049 	ldmdavs	r3!, {r0, r3, r6}^
     7c4:	2074726f 	rsbscs	r7, r4, pc, ror #4
     7c8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     7cc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     7d0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     7d4:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     7d8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     7dc:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     7e0:	61570046 	cmpvs	r7, r6, asr #32
     7e4:	44007469 	strmi	r7, [r0], #-1129	; 0xfffffb97
     7e8:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     7ec:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 288 <shift+0x288>
     7f0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     7f4:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     7f8:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     7fc:	5f006e6f 	svcpl	0x00006e6f
     800:	31314e5a 	teqcc	r1, sl, asr lr
     804:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     808:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     80c:	316d6574 	smccc	54868	; 0xd654
     810:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     814:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     818:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     81c:	6e490076 	mcrvs	0, 2, r0, cr9, cr6, {3}
     820:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     824:	61747075 	cmnvs	r4, r5, ror r0
     828:	5f656c62 	svcpl	0x00656c62
     82c:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
     830:	526d0070 	rsbpl	r0, sp, #112	; 0x70
     834:	5f746f6f 	svcpl	0x00746f6f
     838:	00766544 	rsbseq	r6, r6, r4, asr #10
     83c:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 6bc <shift+0x6bc>
     840:	614c6d00 	cmpvs	ip, r0, lsl #26
     844:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     848:	42004449 	andmi	r4, r0, #1224736768	; 0x49000000
     84c:	6b636f6c 	blvs	18dc604 <__bss_end+0x18d2704>
     850:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     854:	5f746547 	svcpl	0x00746547
     858:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     85c:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     860:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 868 <shift+0x868>
     864:	00657079 	rsbeq	r7, r5, r9, ror r0
     868:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     86c:	625f676e 	subsvs	r6, pc, #28835840	; 0x1b80000
     870:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     874:	75520072 	ldrbvc	r0, [r2, #-114]	; 0xffffff8e
     878:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     87c:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     880:	6b736154 	blvs	1cd8dd8 <__bss_end+0x1cceed8>
     884:	6174535f 	cmnvs	r4, pc, asr r3
     888:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     88c:	38335f52 	ldmdacc	r3!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     890:	00303034 	eorseq	r3, r0, r4, lsr r0
     894:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     898:	6f635f64 	svcvs	0x00635f64
     89c:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     8a0:	63730072 	cmnvs	r3, #114	; 0x72
     8a4:	5f646568 	svcpl	0x00646568
     8a8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     8ac:	705f6369 	subsvc	r6, pc, r9, ror #6
     8b0:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     8b4:	00797469 	rsbseq	r7, r9, r9, ror #8
     8b8:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     8bc:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     8c0:	6700657a 	smlsdxvs	r0, sl, r5, r6
     8c4:	445f5346 	ldrbmi	r5, [pc], #-838	; 8cc <shift+0x8cc>
     8c8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     8cc:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     8d0:	5f746978 	svcpl	0x00746978
     8d4:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     8d8:	65676600 	strbvs	r6, [r7, #-1536]!	; 0xfffffa00
     8dc:	42007374 	andmi	r7, r0, #116, 6	; 0xd0000001
     8e0:	31315f52 	teqcc	r1, r2, asr pc
     8e4:	30303235 	eorscc	r3, r0, r5, lsr r2
     8e8:	63536d00 	cmpvs	r3, #0, 26
     8ec:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     8f0:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     8f4:	7300636e 	movwvc	r6, #878	; 0x36e
     8f8:	636f7250 	cmnvs	pc, #80, 4
     8fc:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
     900:	4d007267 	sfmmi	f7, 4, [r0, #-412]	; 0xfffffe64
     904:	53467861 	movtpl	r7, #26721	; 0x6861
     908:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     90c:	614e7265 	cmpvs	lr, r5, ror #4
     910:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     914:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     918:	746f4e00 	strbtvc	r4, [pc], #-3584	; 920 <shift+0x920>
     91c:	00796669 	rsbseq	r6, r9, r9, ror #12
     920:	6b636f4c 	blvs	18dc658 <__bss_end+0x18d2758>
     924:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     928:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     92c:	4e490064 	cdpmi	0, 4, cr0, cr9, cr4, {3}
     930:	494e4946 	stmdbmi	lr, {r1, r2, r6, r8, fp, lr}^
     934:	72005954 	andvc	r5, r0, #84, 18	; 0x150000
     938:	6e5f676e 	cdpvs	7, 5, cr6, cr15, cr14, {3}
     93c:	66006d75 			; <UNDEFINED> instruction: 0x66006d75
     940:	73747570 	cmnvc	r4, #112, 10	; 0x1c000000
     944:	636f4c00 	cmnvs	pc, #0, 24
     948:	6f4c5f6b 	svcvs	0x004c5f6b
     94c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     950:	41555400 	cmpmi	r5, r0, lsl #8
     954:	495f5452 	ldmdbmi	pc, {r1, r4, r6, sl, ip, lr}^	; <UNPREDICTABLE>
     958:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     95c:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     960:	00736d61 	rsbseq	r6, r3, r1, ror #26
     964:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     968:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     96c:	5a006574 	bpl	19f44 <__bss_end+0x10044>
     970:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     974:	69630065 	stmdbvs	r3!, {r0, r2, r5, r6}^
     978:	5f6f6c73 	svcpl	0x006f6c73
     97c:	00727473 	rsbseq	r7, r2, r3, ror r4
     980:	65636572 	strbvs	r6, [r3, #-1394]!	; 0xfffffa8e
     984:	5f657669 	svcpl	0x00657669
     988:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     98c:	47007265 	strmi	r7, [r0, -r5, ror #4]
     990:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     994:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     998:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     99c:	5a5f006f 	bpl	17c0b60 <__bss_end+0x17b6c60>
     9a0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     9a4:	636f7250 	cmnvs	pc, #80, 4
     9a8:	5f737365 	svcpl	0x00737365
     9ac:	616e614d 	cmnvs	lr, sp, asr #2
     9b0:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     9b4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     9b8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     9bc:	5f007645 	svcpl	0x00007645
     9c0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9c4:	6f725043 	svcvs	0x00725043
     9c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9cc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9d0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9d4:	614d3931 	cmpvs	sp, r1, lsr r9
     9d8:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9dc:	545f656c 	ldrbpl	r6, [pc], #-1388	; 9e4 <shift+0x9e4>
     9e0:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     9e4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9e8:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     9ec:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     9f0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     9f4:	61505f74 	cmpvs	r0, r4, ror pc
     9f8:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     9fc:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
     a00:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
     a04:	614d006e 	cmpvs	sp, lr, rrx
     a08:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     a0c:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     a10:	00687467 	rsbeq	r7, r8, r7, ror #8
     a14:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     a18:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     a1c:	61686320 	cmnvs	r8, r0, lsr #6
     a20:	5a5f0072 	bpl	17c0bf0 <__bss_end+0x17b6cf0>
     a24:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     a28:	636f7250 	cmnvs	pc, #80, 4
     a2c:	5f737365 	svcpl	0x00737365
     a30:	616e614d 	cmnvs	lr, sp, asr #2
     a34:	31726567 	cmncc	r2, r7, ror #10
     a38:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     a3c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     a40:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     a44:	00764546 	rsbseq	r4, r6, r6, asr #10
     a48:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     a4c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a50:	006d6574 	rsbeq	r6, sp, r4, ror r5
     a54:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     a58:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     a5c:	61750074 	cmnvs	r5, r4, ror r0
     a60:	665f7472 			; <UNDEFINED> instruction: 0x665f7472
     a64:	00656c69 	rsbeq	r6, r5, r9, ror #24
     a68:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     a6c:	0064665f 	rsbeq	r6, r4, pc, asr r6
     a70:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     a74:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 510 <shift+0x510>
     a78:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a7c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a80:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     a84:	6d006e6f 	stcvs	14, cr6, [r0, #-444]	; 0xfffffe44
     a88:	746f6f52 	strbtvc	r6, [pc], #-3922	; a90 <shift+0xa90>
     a8c:	69467300 	stmdbvs	r6, {r8, r9, ip, sp, lr}^
     a90:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a94:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a98:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     a9c:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     aa0:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     aa4:	5f323374 	svcpl	0x00323374
     aa8:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
     aac:	2f656d6f 	svccs	0x00656d6f
     ab0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     ab4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     ab8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     abc:	2f736f2f 	svccs	0x00736f2f
     ac0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     ac4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     ac8:	752f7365 	strvc	r7, [pc, #-869]!	; 76b <shift+0x76b>
     acc:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     ad0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     ad4:	676f6c2f 	strbvs	r6, [pc, -pc, lsr #24]!
     ad8:	5f726567 	svcpl	0x00726567
     adc:	6b736174 	blvs	1cd90b4 <__bss_end+0x1ccf1b4>
     ae0:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     ae4:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     ae8:	69630070 	stmdbvs	r3!, {r4, r5, r6}^
     aec:	006f6c73 	rsbeq	r6, pc, r3, ror ip	; <UNPREDICTABLE>
     af0:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     af4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     af8:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     afc:	6f4e5f6b 	svcvs	0x004e5f6b
     b00:	5f006564 	svcpl	0x00006564
     b04:	31314e5a 	teqcc	r1, sl, asr lr
     b08:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     b0c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     b10:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     b14:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     b18:	634b5045 	movtvs	r5, #45125	; 0xb045
     b1c:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     b20:	5f656c69 	svcpl	0x00656c69
     b24:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     b28:	646f4d5f 	strbtvs	r4, [pc], #-3423	; b30 <shift+0xb30>
     b2c:	68630065 	stmdavs	r3!, {r0, r2, r5, r6}^
     b30:	6c5f7261 	lfmvs	f7, 2, [pc], {97}	; 0x61
     b34:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     b38:	61700068 	cmnvs	r0, r8, rrx
     b3c:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     b40:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     b44:	5f726576 	svcpl	0x00726576
     b48:	00786469 	rsbseq	r6, r8, r9, ror #8
     b4c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     b50:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     b54:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     b58:	5f706565 	svcpl	0x00706565
     b5c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     b60:	5a5f0072 	bpl	17c0d30 <__bss_end+0x17b6e30>
     b64:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     b68:	6f725043 	svcvs	0x00725043
     b6c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b70:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b74:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b78:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     b7c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     b80:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b84:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b88:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     b8c:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     b90:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b94:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     b98:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     b9c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     ba0:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     ba4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ba8:	50433631 	subpl	r3, r3, r1, lsr r6
     bac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bb0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9ec <shift+0x9ec>
     bb4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     bb8:	31317265 	teqcc	r1, r5, ror #4
     bbc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bc0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bc4:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     bc8:	61740076 	cmnvs	r4, r6, ror r0
     bcc:	42006b73 	andmi	r6, r0, #117760	; 0x1cc00
     bd0:	39315f52 	ldmdbcc	r1!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     bd4:	00303032 	eorseq	r3, r0, r2, lsr r0
     bd8:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
     bdc:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     be0:	6f4e0065 	svcvs	0x004e0065
     be4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     be8:	6f72505f 	svcvs	0x0072505f
     bec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bf0:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     bf4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     bf8:	5a5f0065 	bpl	17c0d94 <__bss_end+0x17b6e94>
     bfc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c00:	636f7250 	cmnvs	pc, #80, 4
     c04:	5f737365 	svcpl	0x00737365
     c08:	616e614d 	cmnvs	lr, sp, asr #2
     c0c:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     c10:	6f6c4231 	svcvs	0x006c4231
     c14:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     c18:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     c1c:	505f746e 	subspl	r7, pc, lr, ror #8
     c20:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c24:	76457373 			; <UNDEFINED> instruction: 0x76457373
     c28:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c2c:	50433631 	subpl	r3, r3, r1, lsr r6
     c30:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c34:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a70 <shift+0xa70>
     c38:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c3c:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     c40:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     c44:	6f545f68 	svcvs	0x00545f68
     c48:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     c4c:	6f725043 	svcvs	0x00725043
     c50:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c54:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     c58:	6f4e5f74 	svcvs	0x004e5f74
     c5c:	53006564 	movwpl	r6, #1380	; 0x564
     c60:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c64:	5f656c75 	svcpl	0x00656c75
     c68:	5f005252 	svcpl	0x00005252
     c6c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c70:	6f725043 	svcvs	0x00725043
     c74:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c78:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c7c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c80:	61483831 	cmpvs	r8, r1, lsr r8
     c84:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c88:	6f72505f 	svcvs	0x0072505f
     c8c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c90:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     c94:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     c98:	5f495753 	svcpl	0x00495753
     c9c:	636f7250 	cmnvs	pc, #80, 4
     ca0:	5f737365 	svcpl	0x00737365
     ca4:	76726553 			; <UNDEFINED> instruction: 0x76726553
     ca8:	6a656369 	bvs	1959a54 <__bss_end+0x194fb54>
     cac:	31526a6a 	cmpcc	r2, sl, ror #20
     cb0:	57535431 	smmlarpl	r3, r1, r4, r5
     cb4:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     cb8:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     cbc:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     cc0:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
     cc4:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     cc8:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     ccc:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     cd0:	5f006e6f 	svcpl	0x00006e6f
     cd4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     cd8:	6f725043 	svcvs	0x00725043
     cdc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ce0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     ce4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     ce8:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     cec:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     cf0:	6f72505f 	svcvs	0x0072505f
     cf4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cf8:	6a685045 	bvs	1a14e14 <__bss_end+0x1a0af14>
     cfc:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     d00:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     d04:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     d08:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     d0c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     d10:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     d14:	5f6d6574 	svcpl	0x006d6574
     d18:	76726553 			; <UNDEFINED> instruction: 0x76726553
     d1c:	00656369 	rsbeq	r6, r5, r9, ror #6
     d20:	315f5242 	cmpcc	pc, r2, asr #4
     d24:	00303032 	eorseq	r3, r0, r2, lsr r0
     d28:	61766e49 	cmnvs	r6, r9, asr #28
     d2c:	5f64696c 	svcpl	0x0064696c
     d30:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     d34:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     d38:	545f5346 	ldrbpl	r5, [pc], #-838	; d40 <shift+0xd40>
     d3c:	5f656572 	svcpl	0x00656572
     d40:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     d44:	6f6c4200 	svcvs	0x006c4200
     d48:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     d4c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     d50:	505f746e 	subspl	r7, pc, lr, ror #8
     d54:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d58:	42007373 	andmi	r7, r0, #-872415231	; 0xcc000001
     d5c:	36395f52 	shsaxcc	r5, r9, r2
     d60:	43003030 	movwmi	r3, #48	; 0x30
     d64:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     d68:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     d6c:	00726576 	rsbseq	r6, r2, r6, ror r5
     d70:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     d74:	69464900 	stmdbvs	r6, {r8, fp, lr}^
     d78:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d7c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d80:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     d84:	00726576 	rsbseq	r6, r2, r6, ror r5
     d88:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     d8c:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     d90:	4700796c 	strmi	r7, [r0, -ip, ror #18]
     d94:	505f7465 	subspl	r7, pc, r5, ror #8
     d98:	59004449 	stmdbpl	r0, {r0, r3, r6, sl, lr}
     d9c:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     da0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     da4:	50433631 	subpl	r3, r3, r1, lsr r6
     da8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     dac:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; be8 <shift+0xbe8>
     db0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     db4:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     db8:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     dbc:	746f6f52 	strbtvc	r6, [pc], #-3922	; dc4 <shift+0xdc4>
     dc0:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
     dc4:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     dc8:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     dcc:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     dd0:	72655400 	rsbvc	r5, r5, #0, 8
     dd4:	616e696d 	cmnvs	lr, sp, ror #18
     dd8:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     ddc:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     de0:	6f6c6300 	svcvs	0x006c6300
     de4:	53006573 	movwpl	r6, #1395	; 0x573
     de8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     dec:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     df0:	00657669 	rsbeq	r7, r5, r9, ror #12
     df4:	76746572 			; <UNDEFINED> instruction: 0x76746572
     df8:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
     dfc:	00727563 	rsbseq	r7, r2, r3, ror #10
     e00:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     e04:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     e08:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     e0c:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     e10:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     e14:	5f006d75 	svcpl	0x00006d75
     e18:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     e1c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     e20:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     e24:	0076646c 	rsbseq	r6, r6, ip, ror #8
     e28:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     e2c:	5f746573 	svcpl	0x00746573
     e30:	6b736174 	blvs	1cd9408 <__bss_end+0x1ccf508>
     e34:	6165645f 	cmnvs	r5, pc, asr r4
     e38:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     e3c:	77006a65 	strvc	r6, [r0, -r5, ror #20]
     e40:	00746961 	rsbseq	r6, r4, r1, ror #18
     e44:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     e48:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     e4c:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     e50:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     e54:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     e58:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     e5c:	61460069 	cmpvs	r6, r9, rrx
     e60:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
     e64:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
     e68:	0065646f 	rsbeq	r6, r5, pc, ror #8
     e6c:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
     e70:	5f746567 	svcpl	0x00746567
     e74:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
     e78:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     e7c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e80:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
     e84:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     e88:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
     e8c:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     e90:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     e94:	7165725f 	cmnvc	r5, pc, asr r2
     e98:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     e9c:	69500064 	ldmdbvs	r0, {r2, r5, r6}^
     ea0:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
     ea4:	5f656c69 	svcpl	0x00656c69
     ea8:	66657250 			; <UNDEFINED> instruction: 0x66657250
     eac:	5f007869 	svcpl	0x00007869
     eb0:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     eb4:	745f7465 	ldrbvc	r7, [pc], #-1125	; ebc <shift+0xebc>
     eb8:	5f6b6369 	svcpl	0x006b6369
     ebc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     ec0:	73007674 	movwvc	r7, #1652	; 0x674
     ec4:	7065656c 	rsbvc	r6, r5, ip, ror #10
     ec8:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     ecc:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     ed0:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     ed4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     ed8:	6f00656e 	svcvs	0x0000656e
     edc:	61726570 	cmnvs	r2, r0, ror r5
     ee0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ee4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     ee8:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     eec:	2f006a65 	svccs	0x00006a65
     ef0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     ef4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     ef8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     efc:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     f00:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     f04:	2f70732f 	svccs	0x0070732f
     f08:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     f0c:	2f736563 	svccs	0x00736563
     f10:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     f14:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     f18:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     f1c:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     f20:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     f24:	5f007070 	svcpl	0x00007070
     f28:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     f2c:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     f30:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     f34:	00656d61 	rsbeq	r6, r5, r1, ror #26
     f38:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     f3c:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
     f40:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     f44:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     f48:	5a5f006e 	bpl	17c1108 <__bss_end+0x17b7208>
     f4c:	70697034 	rsbvc	r7, r9, r4, lsr r0
     f50:	634b5065 	movtvs	r5, #45157	; 0xb065
     f54:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
     f58:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     f5c:	5f656e69 	svcpl	0x00656e69
     f60:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
     f64:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f68:	67006563 	strvs	r6, [r0, -r3, ror #10]
     f6c:	745f7465 	ldrbvc	r7, [pc], #-1125	; f74 <shift+0xf74>
     f70:	5f6b6369 	svcpl	0x006b6369
     f74:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     f78:	682f0074 	stmdavs	pc!, {r2, r4, r5, r6}	; <UNPREDICTABLE>
     f7c:	2f656d6f 	svccs	0x00656d6f
     f80:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     f84:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     f88:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     f8c:	2f736f2f 	svccs	0x00736f2f
     f90:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     f94:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     f98:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     f9c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     fa0:	72617000 	rsbvc	r7, r1, #0
     fa4:	5f006d61 	svcpl	0x00006d61
     fa8:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     fac:	6a657469 	bvs	195e158 <__bss_end+0x1954258>
     fb0:	6a634b50 	bvs	18d3cf8 <__bss_end+0x18c9df8>
     fb4:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     fb8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     fbc:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     fc0:	5f736b63 	svcpl	0x00736b63
     fc4:	645f6f74 	ldrbvs	r6, [pc], #-3956	; fcc <shift+0xfcc>
     fc8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     fcc:	00656e69 	rsbeq	r6, r5, r9, ror #28
     fd0:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     fd4:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     fd8:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     fdc:	5f00657a 	svcpl	0x0000657a
     fe0:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     fe4:	6a706565 	bvs	1c1a580 <__bss_end+0x1c10680>
     fe8:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     fec:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     ff0:	6e69616d 	powvsez	f6, f1, #5.0
     ff4:	00676e69 	rsbeq	r6, r7, r9, ror #28
     ff8:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
     ffc:	5f746567 	svcpl	0x00746567
    1000:	6b736174 	blvs	1cd95d8 <__bss_end+0x1ccf6d8>
    1004:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1008:	745f736b 	ldrbvc	r7, [pc], #-875	; 1010 <shift+0x1010>
    100c:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    1010:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1014:	0076656e 	rsbseq	r6, r6, lr, ror #10
    1018:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    101c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    1020:	5f746c75 	svcpl	0x00746c75
    1024:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    1028:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    102c:	5f006d75 	svcpl	0x00006d75
    1030:	6177345a 	cmnvs	r7, sl, asr r4
    1034:	6a6a7469 	bvs	1a9e1e0 <__bss_end+0x1a942e0>
    1038:	5a5f006a 	bpl	17c11e8 <__bss_end+0x17b72e8>
    103c:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    1040:	316a6c74 	smccc	42692	; 0xa6c4
    1044:	4f494e36 	svcmi	0x00494e36
    1048:	5f6c7443 	svcpl	0x006c7443
    104c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1050:	6f697461 	svcvs	0x00697461
    1054:	0076506e 	rsbseq	r5, r6, lr, rrx
    1058:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    105c:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    1060:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    1064:	646f6d00 	strbtvs	r6, [pc], #-3328	; 106c <shift+0x106c>
    1068:	5a5f0065 	bpl	17c1204 <__bss_end+0x17b7304>
    106c:	61657234 	cmnvs	r5, r4, lsr r2
    1070:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1074:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
    1078:	646f6374 	strbtvs	r6, [pc], #-884	; 1080 <shift+0x1080>
    107c:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1080:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1084:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1088:	6f72705f 	svcvs	0x0072705f
    108c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1090:	756f635f 	strbvc	r6, [pc, #-863]!	; d39 <shift+0xd39>
    1094:	6600746e 	strvs	r7, [r0], -lr, ror #8
    1098:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    109c:	00656d61 	rsbeq	r6, r5, r1, ror #26
    10a0:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    10a4:	72657400 	rsbvc	r7, r5, #0, 8
    10a8:	616e696d 	cmnvs	lr, sp, ror #18
    10ac:	67006574 	smlsdxvs	r0, r4, r5, r6
    10b0:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    10b4:	5a5f0064 	bpl	17c124c <__bss_end+0x17b734c>
    10b8:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    10bc:	634b506e 	movtvs	r5, #45166	; 0xb06e
    10c0:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    10c4:	5f656c69 	svcpl	0x00656c69
    10c8:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    10cc:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 10d4 <shift+0x10d4>
    10d0:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    10d4:	2b432055 	blcs	10c9230 <__bss_end+0x10bf330>
    10d8:	2034312b 	eorscs	r3, r4, fp, lsr #2
    10dc:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    10e0:	30322031 	eorscc	r2, r2, r1, lsr r0
    10e4:	30313931 	eorscc	r3, r1, r1, lsr r9
    10e8:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    10ec:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    10f0:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    10f4:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    10f8:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    10fc:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    1100:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    1104:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    1108:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    110c:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1110:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1114:	205d3939 	subscs	r3, sp, r9, lsr r9
    1118:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    111c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1120:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1124:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1128:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    112c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1130:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1134:	6f6c666d 	svcvs	0x006c666d
    1138:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    113c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1140:	20647261 	rsbcs	r7, r4, r1, ror #4
    1144:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1148:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    114c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    1150:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1154:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1158:	36373131 			; <UNDEFINED> instruction: 0x36373131
    115c:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    1160:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    1164:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1168:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    116c:	613d6863 	teqvs	sp, r3, ror #16
    1170:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1174:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    1178:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    117c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1180:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1184:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1188:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    118c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; ffc <shift+0xffc>
    1190:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    1194:	6f697470 	svcvs	0x00697470
    1198:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    119c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 100c <shift+0x100c>
    11a0:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    11a4:	315a5f00 	cmpcc	sl, r0, lsl #30
    11a8:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    11ac:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
    11b0:	5f6d6f64 	svcpl	0x006d6f64
    11b4:	616f6c66 	cmnvs	pc, r6, ror #24
    11b8:	66666a74 			; <UNDEFINED> instruction: 0x66666a74
    11bc:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    11c0:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
    11c4:	5f6d6f64 	svcpl	0x006d6f64
    11c8:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
    11cc:	72003233 	andvc	r3, r0, #805306371	; 0x30000003
    11d0:	6f646e61 	svcvs	0x00646e61
    11d4:	6f6e5f6d 	svcvs	0x006e5f6d
    11d8:	6c616d72 	stclvs	13, cr6, [r1], #-456	; 0xfffffe38
    11dc:	64657a69 	strbtvs	r7, [r5], #-2665	; 0xfffff597
    11e0:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    11e4:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
    11e8:	5f6d6f64 	svcpl	0x006d6f64
    11ec:	616f6c66 	cmnvs	pc, r6, ror #24
    11f0:	5a5f0074 	bpl	17c13c8 <__bss_end+0x17b74c8>
    11f4:	65673731 	strbvs	r3, [r7, #-1841]!	; 0xfffff8cf
    11f8:	61725f74 	cmnvs	r2, r4, ror pc
    11fc:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 104c <shift+0x104c>
    1200:	6e69755f 	mcrvs	5, 3, r7, cr9, cr15, {2}
    1204:	6a323374 	bvs	c8dfdc <__bss_end+0xc840dc>
    1208:	6e617200 	cdpvs	2, 6, cr7, cr1, cr0, {0}
    120c:	5f6d6f64 	svcpl	0x006d6f64
    1210:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1214:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1160 <shift+0x1160>
    1218:	616a2f65 	cmnvs	sl, r5, ror #30
    121c:	6173656d 	cmnvs	r3, sp, ror #10
    1220:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    1224:	6f2f7469 	svcvs	0x002f7469
    1228:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    122c:	756f732f 	strbvc	r7, [pc, #-815]!	; f05 <shift+0xf05>
    1230:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1234:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1238:	2f62696c 	svccs	0x0062696c
    123c:	2f637273 	svccs	0x00637273
    1240:	72647473 	rsbvc	r7, r4, #1929379840	; 0x73000000
    1244:	6f646e61 	svcvs	0x00646e61
    1248:	70632e6d 	rsbvc	r2, r3, sp, ror #28
    124c:	61720070 	cmnvs	r2, r0, ror r0
    1250:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 10a0 <shift+0x10a0>
    1254:	5f6e695f 	svcpl	0x006e695f
    1258:	676e6172 			; <UNDEFINED> instruction: 0x676e6172
    125c:	5a5f0065 	bpl	17c13f8 <__bss_end+0x17b74f8>
    1260:	65673731 	strbvs	r3, [r7, #-1841]!	; 0xfffff8cf
    1264:	61725f74 	cmnvs	r2, r4, ror pc
    1268:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 10b8 <shift+0x10b8>
    126c:	6e69755f 	mcrvs	5, 3, r7, cr9, cr15, {2}
    1270:	6a323374 	bvs	c8e048 <__bss_end+0xc84148>
    1274:	5f006a6a 	svcpl	0x00006a6a
    1278:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    127c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1280:	50764b50 	rsbspl	r4, r6, r0, asr fp
    1284:	2f006976 	svccs	0x00006976
    1288:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    128c:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
    1290:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
    1294:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
    1298:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
    129c:	2f70732f 	svccs	0x0070732f
    12a0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    12a4:	2f736563 	svccs	0x00736563
    12a8:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    12ac:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    12b0:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    12b4:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    12b8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    12bc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    12c0:	6d657200 	sfmvs	f7, 2, [r5, #-0]
    12c4:	646e6961 	strbtvs	r6, [lr], #-2401	; 0xfffff69f
    12c8:	69007265 	stmdbvs	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
    12cc:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    12d0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    12d4:	61726765 	cmnvs	r2, r5, ror #14
    12d8:	7369006c 	cmnvc	r9, #108	; 0x6c
    12dc:	00666e69 	rsbeq	r6, r6, r9, ror #28
    12e0:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    12e4:	006c616d 	rsbeq	r6, ip, sp, ror #2
    12e8:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    12ec:	6a616f74 	bvs	185d0c4 <__bss_end+0x18531c4>
    12f0:	006a6350 	rsbeq	r6, sl, r0, asr r3
    12f4:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    12f8:	696f7000 	stmdbvs	pc!, {ip, sp, lr}^	; <UNPREDICTABLE>
    12fc:	735f746e 	cmpvc	pc, #1845493760	; 0x6e000000
    1300:	006e6565 	rsbeq	r6, lr, r5, ror #10
    1304:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1308:	645f676e 	ldrbvs	r6, [pc], #-1902	; 1310 <shift+0x1310>
    130c:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1310:	00736c61 	rsbseq	r6, r3, r1, ror #24
    1314:	65776f70 	ldrbvs	r6, [r7, #-3952]!	; 0xfffff090
    1318:	74730072 	ldrbtvc	r0, [r3], #-114	; 0xffffff8e
    131c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1320:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1324:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
    1328:	70786500 	rsbsvc	r6, r8, r0, lsl #10
    132c:	6e656e6f 	cdpvs	14, 6, cr6, cr5, cr15, {3}
    1330:	5a5f0074 	bpl	17c1508 <__bss_end+0x17b7608>
    1334:	6f746134 	svcvs	0x00746134
    1338:	634b5066 	movtvs	r5, #45158	; 0xb066
    133c:	73656400 	cmnvc	r5, #0, 8
    1340:	5a5f0074 	bpl	17c1518 <__bss_end+0x17b7618>
    1344:	76657236 			; <UNDEFINED> instruction: 0x76657236
    1348:	50727473 	rsbspl	r7, r2, r3, ror r4
    134c:	5a5f0063 	bpl	17c14e0 <__bss_end+0x17b75e0>
    1350:	6e736935 			; <UNDEFINED> instruction: 0x6e736935
    1354:	00666e61 	rsbeq	r6, r6, r1, ror #28
    1358:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    135c:	61620074 	smcvs	8196	; 0x2004
    1360:	74006573 	strvc	r6, [r0], #-1395	; 0xfffffa8d
    1364:	00706d65 	rsbseq	r6, r0, r5, ror #26
    1368:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    136c:	6f72657a 	svcvs	0x0072657a
    1370:	00697650 	rsbeq	r7, r9, r0, asr r6
    1374:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1378:	00797063 	rsbseq	r7, r9, r3, rrx
    137c:	616f7469 	cmnvs	pc, r9, ror #8
    1380:	72747300 	rsbsvc	r7, r4, #0, 6
    1384:	74730031 	ldrbtvc	r0, [r3], #-49	; 0xffffffcf
    1388:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    138c:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    1390:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1394:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    1398:	5f006666 	svcpl	0x00006666
    139c:	6f70335a 	svcvs	0x0070335a
    13a0:	006a6677 	rsbeq	r6, sl, r7, ror r6
    13a4:	31315a5f 	teqcc	r1, pc, asr sl
    13a8:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    13ac:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    13b0:	6674616f 	ldrbtvs	r6, [r4], -pc, ror #2
    13b4:	5f536a52 	svcpl	0x00536a52
    13b8:	61006952 	tstvs	r0, r2, asr r9
    13bc:	00666f74 	rsbeq	r6, r6, r4, ror pc
    13c0:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    13c4:	43007473 	movwmi	r7, #1139	; 0x473
    13c8:	43726168 	cmnmi	r2, #104, 2
    13cc:	41766e6f 	cmnmi	r6, pc, ror #28
    13d0:	66007272 			; <UNDEFINED> instruction: 0x66007272
    13d4:	00616f74 	rsbeq	r6, r1, r4, ror pc
    13d8:	33325a5f 	teqcc	r2, #389120	; 0x5f000
    13dc:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    13e0:	5f6c616d 	svcpl	0x006c616d
    13e4:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    13e8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    13ec:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    13f0:	6a74616f 	bvs	1d199b4 <__bss_end+0x1d0fab4>
    13f4:	00696350 	rsbeq	r6, r9, r0, asr r3
    13f8:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    13fc:	70006372 	andvc	r6, r0, r2, ror r3
    1400:	69636572 	stmdbvs	r3!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1404:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1408:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    140c:	6d006f72 	stcvs	15, cr6, [r0, #-456]	; 0xfffffe38
    1410:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1414:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
    1418:	00786564 	rsbseq	r6, r8, r4, ror #10
    141c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1420:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1424:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    1428:	5f007374 	svcpl	0x00007374
    142c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1430:	4b50696f 	blmi	141b9f4 <__bss_end+0x1411af4>
    1434:	756f0063 	strbvc	r0, [pc, #-99]!	; 13d9 <shift+0x13d9>
    1438:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    143c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1440:	616f7466 	cmnvs	pc, r6, ror #8
    1444:	6a635066 	bvs	18d55e4 <__bss_end+0x18cb6e4>
    1448:	6c707300 	ldclvs	3, cr7, [r0], #-0
    144c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1450:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1454:	63616600 	cmnvs	r1, #0, 12
    1458:	5a5f0074 	bpl	17c1630 <__bss_end+0x17b7730>
    145c:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1460:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1464:	5f00634b 	svcpl	0x0000634b
    1468:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    146c:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1470:	634b5070 	movtvs	r5, #45168	; 0xb070
    1474:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    1478:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    147c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1480:	50797063 	rsbspl	r7, r9, r3, rrx
    1484:	634b5063 	movtvs	r5, #45155	; 0xb063
    1488:	65640069 	strbvs	r0, [r4, #-105]!	; 0xffffff97
    148c:	616d6963 	cmnvs	sp, r3, ror #18
    1490:	6f745f6c 	svcvs	0x00745f6c
    1494:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1498:	5f676e69 	svcpl	0x00676e69
    149c:	616f6c66 	cmnvs	pc, r6, ror #24
    14a0:	5a5f0074 	bpl	17c1678 <__bss_end+0x17b7778>
    14a4:	6f746634 	svcvs	0x00746634
    14a8:	63506661 	cmpvs	r0, #101711872	; 0x6100000
    14ac:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    14b0:	0079726f 	rsbseq	r7, r9, pc, ror #4
    14b4:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    14b8:	72006e65 	andvc	r6, r0, #1616	; 0x650
    14bc:	74737665 	ldrbtvc	r7, [r3], #-1637	; 0xfffff99b
    14c0:	2e2e0072 	mcrcs	0, 1, r0, cr14, cr2, {3}
    14c4:	2f2e2e2f 	svccs	0x002e2e2f
    14c8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    14cc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    14d0:	2f2e2e2f 	svccs	0x002e2e2f
    14d4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    14d8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    14dc:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    14e0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    14e4:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    14e8:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    14ec:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    14f0:	622f0053 	eorvs	r0, pc, #83	; 0x53
    14f4:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    14f8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    14fc:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1500:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1504:	61652d65 	cmnvs	r5, r5, ror #26
    1508:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    150c:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    1510:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    1514:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1518:	6f6e2d6d 	svcvs	0x006e2d6d
    151c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1520:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1524:	30322d39 	eorscc	r2, r2, r9, lsr sp
    1528:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    152c:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    1530:	2f646c69 	svccs	0x00646c69
    1534:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1538:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    153c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1540:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1544:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1548:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    154c:	2f647261 	svccs	0x00647261
    1550:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1554:	54006363 	strpl	r6, [r0], #-867	; 0xfffffc9d
    1558:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    155c:	50435f54 	subpl	r5, r3, r4, asr pc
    1560:	6f635f55 	svcvs	0x00635f55
    1564:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1568:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    156c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1570:	00376178 	eorseq	r6, r7, r8, ror r1
    1574:	5f617369 	svcpl	0x00617369
    1578:	5f746962 	svcpl	0x00746962
    157c:	645f7066 	ldrbvs	r7, [pc], #-102	; 1584 <shift+0x1584>
    1580:	61006c62 	tstvs	r0, r2, ror #24
    1584:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1588:	5f686372 	svcpl	0x00686372
    158c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1590:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    1594:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1598:	50435f54 	subpl	r5, r3, r4, asr pc
    159c:	6f635f55 	svcvs	0x00635f55
    15a0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15a4:	0033326d 	eorseq	r3, r3, sp, ror #4
    15a8:	5f4d5241 	svcpl	0x004d5241
    15ac:	54005145 	strpl	r5, [r0], #-325	; 0xfffffebb
    15b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15b4:	50435f54 	subpl	r5, r3, r4, asr pc
    15b8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    15bc:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    15c0:	66327436 			; <UNDEFINED> instruction: 0x66327436
    15c4:	73690073 	cmnvc	r9, #115	; 0x73
    15c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    15cc:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15d0:	00626d75 	rsbeq	r6, r2, r5, ror sp
    15d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15dc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    15e0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15e4:	37356178 			; <UNDEFINED> instruction: 0x37356178
    15e8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    15ec:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    15f0:	41420033 	cmpmi	r2, r3, lsr r0
    15f4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    15f8:	5f484352 	svcpl	0x00484352
    15fc:	425f4d38 	subsmi	r4, pc, #56, 26	; 0xe00
    1600:	00455341 	subeq	r5, r5, r1, asr #6
    1604:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1608:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    160c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1610:	31386d72 	teqcc	r8, r2, ror sp
    1614:	41540030 	cmpmi	r4, r0, lsr r0
    1618:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    161c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1620:	6567785f 	strbvs	r7, [r7, #-2143]!	; 0xfffff7a1
    1624:	0031656e 	eorseq	r6, r1, lr, ror #10
    1628:	5f4d5241 	svcpl	0x004d5241
    162c:	5f534350 	svcpl	0x00534350
    1630:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1634:	57495f53 	smlsldpl	r5, r9, r3, pc	; <UNPREDICTABLE>
    1638:	54584d4d 	ldrbpl	r4, [r8], #-3405	; 0xfffff2b3
    163c:	53414200 	movtpl	r4, #4608	; 0x1200
    1640:	52415f45 	subpl	r5, r1, #276	; 0x114
    1644:	305f4843 	subscc	r4, pc, r3, asr #16
    1648:	53414200 	movtpl	r4, #4608	; 0x1200
    164c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1650:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1654:	53414200 	movtpl	r4, #4608	; 0x1200
    1658:	52415f45 	subpl	r5, r1, #276	; 0x114
    165c:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1660:	53414200 	movtpl	r4, #4608	; 0x1200
    1664:	52415f45 	subpl	r5, r1, #276	; 0x114
    1668:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1670 <shift+0x1670>
    166c:	53414200 	movtpl	r4, #4608	; 0x1200
    1670:	52415f45 	subpl	r5, r1, #276	; 0x114
    1674:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1678:	53414200 	movtpl	r4, #4608	; 0x1200
    167c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1680:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1684:	52415400 	subpl	r5, r1, #0, 8
    1688:	5f544547 	svcpl	0x00544547
    168c:	5f555043 	svcpl	0x00555043
    1690:	61637378 	smcvs	14136	; 0x3738
    1694:	6900656c 	stmdbvs	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
    1698:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    169c:	705f7469 	subsvc	r7, pc, r9, ror #8
    16a0:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    16a4:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    16a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    16ac:	50435f54 	subpl	r5, r3, r4, asr pc
    16b0:	6f635f55 	svcvs	0x00635f55
    16b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    16b8:	0033336d 	eorseq	r3, r3, sp, ror #6
    16bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16c4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16c8:	74376d72 	ldrtvc	r6, [r7], #-3442	; 0xfffff28e
    16cc:	00696d64 	rsbeq	r6, r9, r4, ror #26
    16d0:	5f617369 	svcpl	0x00617369
    16d4:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    16d8:	41540074 	cmpmi	r4, r4, ror r0
    16dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    16e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    16e4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16e8:	36373131 			; <UNDEFINED> instruction: 0x36373131
    16ec:	73667a6a 	cmnvc	r6, #434176	; 0x6a000
    16f0:	61736900 	cmnvs	r3, r0, lsl #18
    16f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    16f8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    16fc:	41003276 	tstmi	r0, r6, ror r2
    1700:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1704:	555f5343 	ldrbpl	r5, [pc, #-835]	; 13c9 <shift+0x13c9>
    1708:	4f4e4b4e 	svcmi	0x004e4b4e
    170c:	54004e57 	strpl	r4, [r0], #-3671	; 0xfffff1a9
    1710:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1714:	50435f54 	subpl	r5, r3, r4, asr pc
    1718:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    171c:	0065396d 	rsbeq	r3, r5, sp, ror #18
    1720:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1724:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1728:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    172c:	61004a45 	tstvs	r0, r5, asr #20
    1730:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1734:	6d736663 	ldclvs	6, cr6, [r3, #-396]!	; 0xfffffe74
    1738:	6174735f 	cmnvs	r4, pc, asr r3
    173c:	61006574 	tstvs	r0, r4, ror r5
    1740:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1744:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1748:	75006574 	strvc	r6, [r0, #-1396]	; 0xfffffa8c
    174c:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1750:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
    1754:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1758:	73690073 	cmnvc	r9, #115	; 0x73
    175c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1760:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1764:	5f5f0063 	svcpl	0x005f0063
    1768:	5f7a6c63 	svcpl	0x007a6c63
    176c:	00626174 	rsbeq	r6, r2, r4, ror r1
    1770:	5f4d5241 	svcpl	0x004d5241
    1774:	61004356 	tstvs	r0, r6, asr r3
    1778:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    177c:	5f686372 	svcpl	0x00686372
    1780:	61637378 	smcvs	14136	; 0x3738
    1784:	4100656c 	tstmi	r0, ip, ror #10
    1788:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    178c:	52410045 	subpl	r0, r1, #69	; 0x45
    1790:	53565f4d 	cmppl	r6, #308	; 0x134
    1794:	4d524100 	ldfmie	f4, [r2, #-0]
    1798:	0045475f 	subeq	r4, r5, pc, asr r7
    179c:	5f6d7261 	svcpl	0x006d7261
    17a0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    17a4:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    17a8:	61676e6f 	cmnvs	r7, pc, ror #28
    17ac:	63006d72 	movwvs	r6, #3442	; 0xd72
    17b0:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    17b4:	66207865 	strtvs	r7, [r0], -r5, ror #16
    17b8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    17bc:	52415400 	subpl	r5, r1, #0, 8
    17c0:	5f544547 	svcpl	0x00544547
    17c4:	5f555043 	svcpl	0x00555043
    17c8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    17cc:	31617865 	cmncc	r1, r5, ror #16
    17d0:	41540035 	cmpmi	r4, r5, lsr r0
    17d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17dc:	3761665f 			; <UNDEFINED> instruction: 0x3761665f
    17e0:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    17e4:	52415400 	subpl	r5, r1, #0, 8
    17e8:	5f544547 	svcpl	0x00544547
    17ec:	5f555043 	svcpl	0x00555043
    17f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    17f4:	31617865 	cmncc	r1, r5, ror #16
    17f8:	52410037 	subpl	r0, r1, #55	; 0x37
    17fc:	54475f4d 	strbpl	r5, [r7], #-3917	; 0xfffff0b3
    1800:	52415400 	subpl	r5, r1, #0, 8
    1804:	5f544547 	svcpl	0x00544547
    1808:	5f555043 	svcpl	0x00555043
    180c:	766f656e 	strbtvc	r6, [pc], -lr, ror #10
    1810:	65737265 	ldrbvs	r7, [r3, #-613]!	; 0xfffffd9b
    1814:	2e00316e 	adfcssz	f3, f0, #0.5
    1818:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    181c:	2f2e2e2f 	svccs	0x002e2e2f
    1820:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1824:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1828:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    182c:	2f636367 	svccs	0x00636367
    1830:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1834:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1838:	41540063 	cmpmi	r4, r3, rrx
    183c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1840:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1844:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1848:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    184c:	42006634 	andmi	r6, r0, #52, 12	; 0x3400000
    1850:	5f455341 	svcpl	0x00455341
    1854:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1858:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    185c:	52415400 	subpl	r5, r1, #0, 8
    1860:	5f544547 	svcpl	0x00544547
    1864:	5f555043 	svcpl	0x00555043
    1868:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    186c:	31617865 	cmncc	r1, r5, ror #16
    1870:	61680032 	cmnvs	r8, r2, lsr r0
    1874:	61766873 	cmnvs	r6, r3, ror r8
    1878:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    187c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1880:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1884:	4b365f48 	blmi	d995ac <__bss_end+0xd8f6ac>
    1888:	7369005a 	cmnvc	r9, #90	; 0x5a
    188c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1890:	61007374 	tstvs	r0, r4, ror r3
    1894:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1898:	5f686372 	svcpl	0x00686372
    189c:	5f6d7261 	svcpl	0x006d7261
    18a0:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    18a4:	72610076 	rsbvc	r0, r1, #118	; 0x76
    18a8:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    18ac:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    18b0:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    18b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    18b8:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    18bc:	00363170 	eorseq	r3, r6, r0, ror r1
    18c0:	20554e47 	subscs	r4, r5, r7, asr #28
    18c4:	20373143 	eorscs	r3, r7, r3, asr #2
    18c8:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    18cc:	30322031 	eorscc	r2, r2, r1, lsr r0
    18d0:	30313931 	eorscc	r3, r1, r1, lsr r9
    18d4:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    18d8:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    18dc:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    18e0:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    18e4:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    18e8:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    18ec:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    18f0:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    18f4:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    18f8:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    18fc:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1900:	205d3939 	subscs	r3, sp, r9, lsr r9
    1904:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1908:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    190c:	616f6c66 	cmnvs	pc, r6, ror #24
    1910:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1914:	61683d69 	cmnvs	r8, r9, ror #26
    1918:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    191c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1920:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1924:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1928:	70662b65 	rsbvc	r2, r6, r5, ror #22
    192c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1930:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1934:	4f2d2067 	svcmi	0x002d2067
    1938:	4f2d2032 	svcmi	0x002d2032
    193c:	4f2d2032 	svcmi	0x002d2032
    1940:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1944:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1948:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    194c:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1950:	20636367 	rsbcs	r6, r3, r7, ror #6
    1954:	6f6e662d 	svcvs	0x006e662d
    1958:	6174732d 	cmnvs	r4, sp, lsr #6
    195c:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1960:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1964:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1968:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    196c:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1970:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1974:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1978:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    197c:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1980:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1984:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1988:	4d524100 	ldfmie	f4, [r2, #-0]
    198c:	0049485f 	subeq	r4, r9, pc, asr r8
    1990:	5f617369 	svcpl	0x00617369
    1994:	5f746962 	svcpl	0x00746962
    1998:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    199c:	52415400 	subpl	r5, r1, #0, 8
    19a0:	5f544547 	svcpl	0x00544547
    19a4:	5f555043 	svcpl	0x00555043
    19a8:	316d7261 	cmncc	sp, r1, ror #4
    19ac:	6a363331 	bvs	d8e678 <__bss_end+0xd84778>
    19b0:	41540073 	cmpmi	r4, r3, ror r0
    19b4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19b8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19c0:	41540038 	cmpmi	r4, r8, lsr r0
    19c4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19c8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19d0:	41540039 	cmpmi	r4, r9, lsr r0
    19d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19dc:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    19e0:	61003632 	tstvs	r0, r2, lsr r6
    19e4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    19e8:	5f686372 	svcpl	0x00686372
    19ec:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    19f0:	52415400 	subpl	r5, r1, #0, 8
    19f4:	5f544547 	svcpl	0x00544547
    19f8:	5f555043 	svcpl	0x00555043
    19fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a00:	346d7865 	strbtcc	r7, [sp], #-2149	; 0xfffff79b
    1a04:	52415400 	subpl	r5, r1, #0, 8
    1a08:	5f544547 	svcpl	0x00544547
    1a0c:	5f555043 	svcpl	0x00555043
    1a10:	316d7261 	cmncc	sp, r1, ror #4
    1a14:	54006530 	strpl	r6, [r0], #-1328	; 0xfffffad0
    1a18:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a1c:	50435f54 	subpl	r5, r3, r4, asr pc
    1a20:	6f635f55 	svcvs	0x00635f55
    1a24:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a28:	6100376d 	tstvs	r0, sp, ror #14
    1a2c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    1a30:	5f646e6f 	svcpl	0x00646e6f
    1a34:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1a38:	4d524100 	ldfmie	f4, [r2, #-0]
    1a3c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1a40:	5041415f 	subpl	r4, r1, pc, asr r1
    1a44:	69005343 	stmdbvs	r0, {r0, r1, r6, r8, r9, ip, lr}
    1a48:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a4c:	615f7469 	cmpvs	pc, r9, ror #8
    1a50:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1a54:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1a58:	5f455341 	svcpl	0x00455341
    1a5c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a60:	004d335f 	subeq	r3, sp, pc, asr r3
    1a64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a6c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a70:	31376d72 	teqcc	r7, r2, ror sp
    1a74:	61007430 	tstvs	r0, r0, lsr r4
    1a78:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1a7c:	5f686372 	svcpl	0x00686372
    1a80:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1a84:	00327478 	eorseq	r7, r2, r8, ror r4
    1a88:	5f617369 	svcpl	0x00617369
    1a8c:	5f6d756e 	svcpl	0x006d756e
    1a90:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1a94:	52415400 	subpl	r5, r1, #0, 8
    1a98:	5f544547 	svcpl	0x00544547
    1a9c:	5f555043 	svcpl	0x00555043
    1aa0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1aa4:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1aa8:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1aac:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1ab0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1ab4:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    1ab8:	41540079 	cmpmi	r4, r9, ror r0
    1abc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ac0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ac4:	7978655f 	ldmdbvc	r8!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1ac8:	6d736f6e 	ldclvs	15, cr6, [r3, #-440]!	; 0xfffffe48
    1acc:	41540031 	cmpmi	r4, r1, lsr r0
    1ad0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ad4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ad8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1adc:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1ae0:	69003235 	stmdbvs	r0, {r0, r2, r4, r5, r9, ip, sp}
    1ae4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ae8:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1af0 <shift+0x1af0>
    1aec:	00766964 	rsbseq	r6, r6, r4, ror #18
    1af0:	66657270 			; <UNDEFINED> instruction: 0x66657270
    1af4:	6e5f7265 	cdpvs	2, 5, cr7, cr15, cr5, {3}
    1af8:	5f6e6f65 	svcpl	0x006e6f65
    1afc:	5f726f66 	svcpl	0x00726f66
    1b00:	69623436 	stmdbvs	r2!, {r1, r2, r4, r5, sl, ip, sp}^
    1b04:	69007374 	stmdbvs	r0, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1b08:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b0c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1b10:	66363170 			; <UNDEFINED> instruction: 0x66363170
    1b14:	54006c6d 	strpl	r6, [r0], #-3181	; 0xfffff393
    1b18:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b1c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b20:	6f635f55 	svcvs	0x00635f55
    1b24:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b28:	00323361 	eorseq	r3, r2, r1, ror #6
    1b2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b34:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b38:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b3c:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    1b40:	61736900 	cmnvs	r3, r0, lsl #18
    1b44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b48:	3170665f 	cmncc	r0, pc, asr r6
    1b4c:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1b50:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
    1b54:	63657073 	cmnvs	r5, #115	; 0x73
    1b58:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
    1b5c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1b60:	41540073 	cmpmi	r4, r3, ror r0
    1b64:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b68:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b6c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b70:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1b74:	00733274 	rsbseq	r3, r3, r4, ror r2
    1b78:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b7c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b80:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1b84:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    1b88:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1b8c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b90:	50435f54 	subpl	r5, r3, r4, asr pc
    1b94:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b98:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    1b9c:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1ba0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ba4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ba8:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    1bac:	61736900 	cmnvs	r3, r0, lsl #18
    1bb0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bb4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    1bb8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    1bbc:	5f6d7261 	svcpl	0x006d7261
    1bc0:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    1bc4:	5f6e695f 	svcpl	0x006e695f
    1bc8:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    1bcc:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    1bd0:	61736900 	cmnvs	r3, r0, lsl #18
    1bd4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bd8:	0062735f 	rsbeq	r7, r2, pc, asr r3
    1bdc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1be0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1be4:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1be8:	73690045 	cmnvc	r9, #69	; 0x45
    1bec:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    1bf0:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    1bf4:	73690065 	cmnvc	r9, #101	; 0x65
    1bf8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1bfc:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1c00:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1c04:	61006c75 	tstvs	r0, r5, ror ip
    1c08:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    1c0c:	5f676e61 	svcpl	0x00676e61
    1c10:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1c14:	6f5f7475 	svcvs	0x005f7475
    1c18:	63656a62 	cmnvs	r5, #401408	; 0x62000
    1c1c:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
    1c20:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
    1c24:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
    1c28:	6f6f685f 	svcvs	0x006f685f
    1c2c:	7369006b 	cmnvc	r9, #107	; 0x6b
    1c30:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c34:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1c38:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    1c3c:	4d524100 	ldfmie	f4, [r2, #-0]
    1c40:	00454e5f 	subeq	r4, r5, pc, asr lr
    1c44:	5f617369 	svcpl	0x00617369
    1c48:	5f746962 	svcpl	0x00746962
    1c4c:	00386562 	eorseq	r6, r8, r2, ror #10
    1c50:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c54:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c58:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c5c:	31316d72 	teqcc	r1, r2, ror sp
    1c60:	7a6a3637 	bvc	1a8f544 <__bss_end+0x1a85644>
    1c64:	72700073 	rsbsvc	r0, r0, #115	; 0x73
    1c68:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1c6c:	5f726f73 	svcpl	0x00726f73
    1c70:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1c74:	6c6c6100 	stfvse	f6, [ip], #-0
    1c78:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1c7c:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1c80:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    1c84:	41420073 	hvcmi	8195	; 0x2003
    1c88:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c8c:	5f484352 	svcpl	0x00484352
    1c90:	61005435 	tstvs	r0, r5, lsr r4
    1c94:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c98:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1c9c:	41540074 	cmpmi	r4, r4, ror r0
    1ca0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ca4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ca8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cac:	61786574 	cmnvs	r8, r4, ror r5
    1cb0:	6f633637 	svcvs	0x00633637
    1cb4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cb8:	00353561 	eorseq	r3, r5, r1, ror #10
    1cbc:	5f6d7261 	svcpl	0x006d7261
    1cc0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1cc4:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    1cc8:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    1ccc:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1cd0:	00687361 	rsbeq	r7, r8, r1, ror #6
    1cd4:	5f617369 	svcpl	0x00617369
    1cd8:	5f746962 	svcpl	0x00746962
    1cdc:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1ce0:	6f6e5f6b 	svcvs	0x006e5f6b
    1ce4:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1b70 <shift+0x1b70>
    1ce8:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1cec:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1cf0:	52415400 	subpl	r5, r1, #0, 8
    1cf4:	5f544547 	svcpl	0x00544547
    1cf8:	5f555043 	svcpl	0x00555043
    1cfc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d00:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1d04:	52415400 	subpl	r5, r1, #0, 8
    1d08:	5f544547 	svcpl	0x00544547
    1d0c:	5f555043 	svcpl	0x00555043
    1d10:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d14:	316d7865 	cmncc	sp, r5, ror #16
    1d18:	52415400 	subpl	r5, r1, #0, 8
    1d1c:	5f544547 	svcpl	0x00544547
    1d20:	5f555043 	svcpl	0x00555043
    1d24:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d28:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1d2c:	61736900 	cmnvs	r3, r0, lsl #18
    1d30:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d34:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d38:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1d3c:	6d726100 	ldfvse	f6, [r2, #-0]
    1d40:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1d44:	616e5f68 	cmnvs	lr, r8, ror #30
    1d48:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    1d4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d50:	615f7469 	cmpvs	pc, r9, ror #8
    1d54:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1d58:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    1d5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d60:	615f7469 	cmpvs	pc, r9, ror #8
    1d64:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1d68:	6900345f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, sl, ip, sp}
    1d6c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d70:	615f7469 	cmpvs	pc, r9, ror #8
    1d74:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1d78:	5400355f 	strpl	r3, [r0], #-1375	; 0xfffffaa1
    1d7c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d80:	50435f54 	subpl	r5, r3, r4, asr pc
    1d84:	6f635f55 	svcvs	0x00635f55
    1d88:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d8c:	00333561 	eorseq	r3, r3, r1, ror #10
    1d90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d98:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d9c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1da0:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1da4:	52415400 	subpl	r5, r1, #0, 8
    1da8:	5f544547 	svcpl	0x00544547
    1dac:	5f555043 	svcpl	0x00555043
    1db0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1db4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1db8:	41540037 	cmpmi	r4, r7, lsr r0
    1dbc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dc0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1dc4:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    1dc8:	0065726f 	rsbeq	r7, r5, pc, ror #4
    1dcc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dd0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dd4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1dd8:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    1ddc:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    1de0:	5f6d7261 	svcpl	0x006d7261
    1de4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1de8:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1df0 <shift+0x1df0>
    1dec:	4154006d 	cmpmi	r4, sp, rrx
    1df0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1df4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1df8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1dfc:	36323031 			; <UNDEFINED> instruction: 0x36323031
    1e00:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1e04:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e08:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e0c:	4a365f48 	bmi	d99b34 <__bss_end+0xd8fc34>
    1e10:	53414200 	movtpl	r4, #4608	; 0x1200
    1e14:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e18:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1e1c:	4142004b 	cmpmi	r2, fp, asr #32
    1e20:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e24:	5f484352 	svcpl	0x00484352
    1e28:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    1e2c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e30:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1e34:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1e38:	41540074 	cmpmi	r4, r4, ror r0
    1e3c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e40:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e44:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e48:	36333131 			; <UNDEFINED> instruction: 0x36333131
    1e4c:	0073666a 	rsbseq	r6, r3, sl, ror #12
    1e50:	5f4d5241 	svcpl	0x004d5241
    1e54:	4100534c 	tstmi	r0, ip, asr #6
    1e58:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1e5c:	41420054 	qdaddmi	r0, r4, r2
    1e60:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e64:	5f484352 	svcpl	0x00484352
    1e68:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    1e6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e70:	50435f54 	subpl	r5, r3, r4, asr pc
    1e74:	6f635f55 	svcvs	0x00635f55
    1e78:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e7c:	63353761 	teqvs	r5, #25427968	; 0x1840000
    1e80:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e84:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1e88:	4d524100 	ldfmie	f4, [r2, #-0]
    1e8c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1e90:	5041415f 	subpl	r4, r1, pc, asr r1
    1e94:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    1e98:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    1e9c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ea0:	50435f54 	subpl	r5, r3, r4, asr pc
    1ea4:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    1ea8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1eac:	73690032 	cmnvc	r9, #50	; 0x32
    1eb0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1eb4:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    1eb8:	61006e6f 	tstvs	r0, pc, ror #28
    1ebc:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1ec0:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    1ec4:	00727474 	rsbseq	r7, r2, r4, ror r4
    1ec8:	5f617369 	svcpl	0x00617369
    1ecc:	5f746962 	svcpl	0x00746962
    1ed0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1ed4:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    1ed8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1edc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ee0:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1ee4:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1ee8:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1eec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ef0:	50435f54 	subpl	r5, r3, r4, asr pc
    1ef4:	616d5f55 	cmnvs	sp, r5, asr pc
    1ef8:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    1efc:	6a705f6c 	bvs	1c19cb4 <__bss_end+0x1c0fdb4>
    1f00:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    1f04:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1f08:	5f687361 	svcpl	0x00687361
    1f0c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1f10:	00726574 	rsbseq	r6, r2, r4, ror r5
    1f14:	5f6d7261 	svcpl	0x006d7261
    1f18:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1f1c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f20:	5f786574 	svcpl	0x00786574
    1f24:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    1f28:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f2c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1f30:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1f34:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    1f38:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f3c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f40:	6f635f55 	svcvs	0x00635f55
    1f44:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f48:	63323761 	teqvs	r2, #25427968	; 0x1840000
    1f4c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f50:	33356178 	teqcc	r5, #120, 2
    1f54:	61736900 	cmnvs	r3, r0, lsl #18
    1f58:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f5c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1f60:	0032626d 	eorseq	r6, r2, sp, ror #4
    1f64:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f68:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f6c:	41375f48 	teqmi	r7, r8, asr #30
    1f70:	61736900 	cmnvs	r3, r0, lsl #18
    1f74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f78:	746f645f 	strbtvc	r6, [pc], #-1119	; 1f80 <shift+0x1f80>
    1f7c:	646f7270 	strbtvs	r7, [pc], #-624	; 1f84 <shift+0x1f84>
    1f80:	6d726100 	ldfvse	f6, [r2, #-0]
    1f84:	3170665f 	cmncc	r0, pc, asr r6
    1f88:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    1f8c:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    1f90:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1f94:	5f4d5241 	svcpl	0x004d5241
    1f98:	6100494d 	tstvs	r0, sp, asr #18
    1f9c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1fa0:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1fa4:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    1fa8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1fac:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    1fb0:	53414200 	movtpl	r4, #4608	; 0x1200
    1fb4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1fb8:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1fbc:	5f5f0052 	svcpl	0x005f0052
    1fc0:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    1fc4:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1fc8:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1fcc:	61736900 	cmnvs	r3, r0, lsl #18
    1fd0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fd4:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1fd8:	41540065 	cmpmi	r4, r5, rrx
    1fdc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fe0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fe4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fe8:	61786574 	cmnvs	r8, r4, ror r5
    1fec:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    1ff0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ff4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ff8:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    1ffc:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    2000:	61377663 	teqvs	r7, r3, ror #12
    2004:	52415400 	subpl	r5, r1, #0, 8
    2008:	5f544547 	svcpl	0x00544547
    200c:	5f555043 	svcpl	0x00555043
    2010:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2014:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2018:	72610036 	rsbvc	r0, r1, #54	; 0x36
    201c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2020:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2024:	6f765f6f 	svcvs	0x00765f6f
    2028:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    202c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2030:	41420065 	cmpmi	r2, r5, rrx
    2034:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2038:	5f484352 	svcpl	0x00484352
    203c:	69004138 	stmdbvs	r0, {r3, r4, r5, r8, lr}
    2040:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2044:	615f7469 	cmpvs	pc, r9, ror #8
    2048:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    204c:	41420074 	hvcmi	8196	; 0x2004
    2050:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2054:	5f484352 	svcpl	0x00484352
    2058:	54005238 	strpl	r5, [r0], #-568	; 0xfffffdc8
    205c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2060:	50435f54 	subpl	r5, r3, r4, asr pc
    2064:	6f635f55 	svcvs	0x00635f55
    2068:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    206c:	63333761 	teqvs	r3, #25427968	; 0x1840000
    2070:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2074:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    2078:	4d524100 	ldfmie	f4, [r2, #-0]
    207c:	00564e5f 	subseq	r4, r6, pc, asr lr
    2080:	5f6d7261 	svcpl	0x006d7261
    2084:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2088:	72610034 	rsbvc	r0, r1, #52	; 0x34
    208c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2090:	00366863 	eorseq	r6, r6, r3, ror #16
    2094:	5f6d7261 	svcpl	0x006d7261
    2098:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    209c:	72610037 	rsbvc	r0, r1, #55	; 0x37
    20a0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    20a4:	00386863 	eorseq	r6, r8, r3, ror #16
    20a8:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    20ac:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1c94 <shift+0x1c94>
    20b0:	00656c62 	rsbeq	r6, r5, r2, ror #24
    20b4:	5f6d7261 	svcpl	0x006d7261
    20b8:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    20bc:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    20c0:	00656c61 	rsbeq	r6, r5, r1, ror #24
    20c4:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    20c8:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    20cc:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    20d0:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    20d4:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    20d8:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    20dc:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    20e0:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    20e4:	616c5f61 	cmnvs	ip, r1, ror #30
    20e8:	006c6562 	rsbeq	r6, ip, r2, ror #10
    20ec:	5f617369 	svcpl	0x00617369
    20f0:	5f746962 	svcpl	0x00746962
    20f4:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    20f8:	61736900 	cmnvs	r3, r0, lsl #18
    20fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2100:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2104:	006b3676 	rsbeq	r3, fp, r6, ror r6
    2108:	47524154 			; <UNDEFINED> instruction: 0x47524154
    210c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2110:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2114:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2118:	00376178 	eorseq	r6, r7, r8, ror r1
    211c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2120:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2124:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2128:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    212c:	00386178 	eorseq	r6, r8, r8, ror r1
    2130:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2134:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2138:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    213c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2140:	00396178 	eorseq	r6, r9, r8, ror r1
    2144:	5f4d5241 	svcpl	0x004d5241
    2148:	5f534350 	svcpl	0x00534350
    214c:	53435041 	movtpl	r5, #12353	; 0x3041
    2150:	4d524100 	ldfmie	f4, [r2, #-0]
    2154:	5343505f 	movtpl	r5, #12383	; 0x305f
    2158:	5054415f 	subspl	r4, r4, pc, asr r1
    215c:	63005343 	movwvs	r5, #835	; 0x343
    2160:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    2164:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    2168:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    216c:	41540065 	cmpmi	r4, r5, rrx
    2170:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2174:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2178:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    217c:	61786574 	cmnvs	r8, r4, ror r5
    2180:	6f633337 	svcvs	0x00633337
    2184:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2188:	00333561 	eorseq	r3, r3, r1, ror #10
    218c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2190:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2194:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2198:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    219c:	70306d78 	eorsvc	r6, r0, r8, ror sp
    21a0:	0073756c 	rsbseq	r7, r3, ip, ror #10
    21a4:	5f6d7261 	svcpl	0x006d7261
    21a8:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    21ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21b0:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    21b4:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    21b8:	645f0065 	ldrbvs	r0, [pc], #-101	; 21c0 <shift+0x21c0>
    21bc:	5f746e6f 	svcpl	0x00746e6f
    21c0:	5f657375 	svcpl	0x00657375
    21c4:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    21c8:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    21cc:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    21d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21d4:	50435f54 	subpl	r5, r3, r4, asr pc
    21d8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21dc:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    21e0:	00696d64 	rsbeq	r6, r9, r4, ror #26
    21e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21f4:	00356178 	eorseq	r6, r5, r8, ror r1
    21f8:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    21fc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2200:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    2204:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    2208:	72610065 	rsbvc	r0, r1, #101	; 0x65
    220c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2210:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    2214:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    2218:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    221c:	50435f54 	subpl	r5, r3, r4, asr pc
    2220:	6f635f55 	svcvs	0x00635f55
    2224:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2228:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    222c:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2230:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    2234:	00796c70 	rsbseq	r6, r9, r0, ror ip
    2238:	5f6d7261 	svcpl	0x006d7261
    223c:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    2240:	5f746e65 	svcpl	0x00746e65
    2244:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    2248:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    224c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2250:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    2254:	4d524100 	ldfmie	f4, [r2, #-0]
    2258:	004c505f 	subeq	r5, ip, pc, asr r0
    225c:	5f617369 	svcpl	0x00617369
    2260:	5f746962 	svcpl	0x00746962
    2264:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2268:	73690033 	cmnvc	r9, #51	; 0x33
    226c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2270:	66765f74 	uhsub16vs	r5, r6, r4
    2274:	00347670 	eorseq	r7, r4, r0, ror r6
    2278:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    227c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2280:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    2284:	41420032 	cmpmi	r2, r2, lsr r0
    2288:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    228c:	5f484352 	svcpl	0x00484352
    2290:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 21b8 <shift+0x21b8>
    2294:	004e4941 	subeq	r4, lr, r1, asr #18
    2298:	47524154 			; <UNDEFINED> instruction: 0x47524154
    229c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22a0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    22a4:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    22a8:	00696d64 	rsbeq	r6, r9, r4, ror #26
    22ac:	5f4d5241 	svcpl	0x004d5241
    22b0:	42004c41 	andmi	r4, r0, #16640	; 0x4100
    22b4:	5f455341 	svcpl	0x00455341
    22b8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    22bc:	004d375f 	subeq	r3, sp, pc, asr r7
    22c0:	5f6d7261 	svcpl	0x006d7261
    22c4:	67726174 			; <UNDEFINED> instruction: 0x67726174
    22c8:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    22cc:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    22d0:	6d726100 	ldfvse	f6, [r2, #-0]
    22d4:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    22d8:	5f746567 	svcpl	0x00746567
    22dc:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    22e0:	52415400 	subpl	r5, r1, #0, 8
    22e4:	5f544547 	svcpl	0x00544547
    22e8:	5f555043 	svcpl	0x00555043
    22ec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22f0:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    22f4:	52415400 	subpl	r5, r1, #0, 8
    22f8:	5f544547 	svcpl	0x00544547
    22fc:	5f555043 	svcpl	0x00555043
    2300:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2304:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    2308:	52415400 	subpl	r5, r1, #0, 8
    230c:	5f544547 	svcpl	0x00544547
    2310:	5f555043 	svcpl	0x00555043
    2314:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2318:	37727865 	ldrbcc	r7, [r2, -r5, ror #16]!
    231c:	52415400 	subpl	r5, r1, #0, 8
    2320:	5f544547 	svcpl	0x00544547
    2324:	5f555043 	svcpl	0x00555043
    2328:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    232c:	38727865 	ldmdacc	r2!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2330:	61736900 	cmnvs	r3, r0, lsl #18
    2334:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2338:	61706c5f 	cmnvs	r0, pc, asr ip
    233c:	73690065 	cmnvc	r9, #101	; 0x65
    2340:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2344:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2348:	5f6b7269 	svcpl	0x006b7269
    234c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2350:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    2354:	5f617369 	svcpl	0x00617369
    2358:	5f746962 	svcpl	0x00746962
    235c:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    2360:	61736900 	cmnvs	r3, r0, lsl #18
    2364:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2368:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    236c:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    2370:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2374:	615f7469 	cmpvs	pc, r9, ror #8
    2378:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    237c:	61736900 	cmnvs	r3, r0, lsl #18
    2380:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2384:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2388:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    238c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2390:	615f7469 	cmpvs	pc, r9, ror #8
    2394:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2398:	6f645f00 	svcvs	0x00645f00
    239c:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 1f36 <shift+0x1f36>
    23a0:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    23a4:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    23a8:	5f657265 	svcpl	0x00657265
    23ac:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    23b0:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23b4:	61736900 	cmnvs	r3, r0, lsl #18
    23b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23bc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    23c0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    23c4:	6d726100 	ldfvse	f6, [r2, #-0]
    23c8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    23cc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    23d0:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    23d4:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    23d8:	77726574 			; <UNDEFINED> instruction: 0x77726574
    23dc:	006b726f 	rsbeq	r7, fp, pc, ror #4
    23e0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    23e4:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    23e8:	52415400 	subpl	r5, r1, #0, 8
    23ec:	5f544547 	svcpl	0x00544547
    23f0:	5f555043 	svcpl	0x00555043
    23f4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    23f8:	00743032 	rsbseq	r3, r4, r2, lsr r0
    23fc:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2400:	0071655f 	rsbseq	r6, r1, pc, asr r5
    2404:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2408:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    240c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2410:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    2414:	6d726100 	ldfvse	f6, [r2, #-0]
    2418:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    241c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2420:	5f626d75 	svcpl	0x00626d75
    2424:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    2428:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    242c:	655f6261 	ldrbvs	r6, [pc, #-609]	; 21d3 <shift+0x21d3>
    2430:	6f705f71 	svcvs	0x00705f71
    2434:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2438:	72610072 	rsbvc	r0, r1, #114	; 0x72
    243c:	69705f6d 	ldmdbvs	r0!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2440:	65725f63 	ldrbvs	r5, [r2, #-3939]!	; 0xfffff09d
    2444:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    2448:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    244c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2450:	50435f54 	subpl	r5, r3, r4, asr pc
    2454:	6f635f55 	svcvs	0x00635f55
    2458:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    245c:	6d73306d 	ldclvs	0, cr3, [r3, #-436]!	; 0xfffffe4c
    2460:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2464:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    2468:	00796c70 	rsbseq	r6, r9, r0, ror ip
    246c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2470:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2474:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 233c <shift+0x233c>
    2478:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    247c:	766f6e65 	strbtvc	r6, [pc], -r5, ror #28
    2480:	69007066 	stmdbvs	r0, {r1, r2, r5, r6, ip, sp, lr}
    2484:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2488:	715f7469 	cmpvc	pc, r9, ror #8
    248c:	6b726975 	blvs	1c9ca68 <__bss_end+0x1c92b68>
    2490:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    2494:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    2498:	52410064 	subpl	r0, r1, #100	; 0x64
    249c:	43435f4d 	movtmi	r5, #16205	; 0x3f4d
    24a0:	6d726100 	ldfvse	f6, [r2, #-0]
    24a4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24a8:	325f3868 	subscc	r3, pc, #104, 16	; 0x680000
    24ac:	6d726100 	ldfvse	f6, [r2, #-0]
    24b0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24b4:	335f3868 	cmpcc	pc, #104, 16	; 0x680000
    24b8:	6d726100 	ldfvse	f6, [r2, #-0]
    24bc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24c0:	345f3868 	ldrbcc	r3, [pc], #-2152	; 24c8 <shift+0x24c8>
    24c4:	52415400 	subpl	r5, r1, #0, 8
    24c8:	5f544547 	svcpl	0x00544547
    24cc:	5f555043 	svcpl	0x00555043
    24d0:	36706d66 	ldrbtcc	r6, [r0], -r6, ror #26
    24d4:	41003632 	tstmi	r0, r2, lsr r6
    24d8:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    24dc:	72610053 	rsbvc	r0, r1, #83	; 0x53
    24e0:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    24e4:	695f3631 	ldmdbvs	pc, {r0, r4, r5, r9, sl, ip, sp}^	; <UNPREDICTABLE>
    24e8:	0074736e 	rsbseq	r7, r4, lr, ror #6
    24ec:	5f6d7261 	svcpl	0x006d7261
    24f0:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    24f4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24f8:	41540068 	cmpmi	r4, r8, rrx
    24fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2500:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2504:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2508:	61786574 	cmnvs	r8, r4, ror r5
    250c:	6f633531 	svcvs	0x00633531
    2510:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2514:	61003761 	tstvs	r0, r1, ror #14
    2518:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    251c:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2520:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2524:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2528:	50435f54 	subpl	r5, r3, r4, asr pc
    252c:	6f635f55 	svcvs	0x00635f55
    2530:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2534:	00323761 	eorseq	r3, r2, r1, ror #14
    2538:	5f6d7261 	svcpl	0x006d7261
    253c:	5f736370 	svcpl	0x00736370
    2540:	61666564 	cmnvs	r6, r4, ror #10
    2544:	00746c75 	rsbseq	r6, r4, r5, ror ip
    2548:	5f4d5241 	svcpl	0x004d5241
    254c:	5f534350 	svcpl	0x00534350
    2550:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2554:	4f4c5f53 	svcmi	0x004c5f53
    2558:	004c4143 	subeq	r4, ip, r3, asr #2
    255c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2560:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2564:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2568:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    256c:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2570:	52415400 	subpl	r5, r1, #0, 8
    2574:	5f544547 	svcpl	0x00544547
    2578:	5f555043 	svcpl	0x00555043
    257c:	6f727473 	svcvs	0x00727473
    2580:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2584:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2588:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    258c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2594 <shift+0x2594>
    2590:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2594:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2598:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    259c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 25a4 <shift+0x25a4>
    25a0:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    25a4:	41540032 	cmpmi	r4, r2, lsr r0
    25a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25b0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    25b4:	0074786d 	rsbseq	r7, r4, sp, ror #16
    25b8:	5f6d7261 	svcpl	0x006d7261
    25bc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    25c0:	69007435 	stmdbvs	r0, {r0, r2, r4, r5, sl, ip, sp, lr}
    25c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    25c8:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 242c <shift+0x242c>
    25cc:	72610070 	rsbvc	r0, r1, #112	; 0x70
    25d0:	646c5f6d 	strbtvs	r5, [ip], #-3949	; 0xfffff093
    25d4:	6863735f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp, lr}^
    25d8:	61006465 	tstvs	r0, r5, ror #8
    25dc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25e0:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    25e4:	Address 0x00000000000025e4 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9a30>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346930>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9a50>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8d80>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9a80>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346980>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9aa0>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3469a0>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9ac0>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3469c0>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9ae0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3469e0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9b00>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346a00>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9b20>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346a20>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9b40>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346a40>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9b58>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9b78>
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
 194:	0000003c 	andeq	r0, r0, ip, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9ba8>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008268 	andeq	r8, r0, r8, ror #4
 1b4:	00000038 	andeq	r0, r0, r8, lsr r0
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9bc8>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 1c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000082a0 	andeq	r8, r0, r0, lsr #5
 1d4:	00000044 	andeq	r0, r0, r4, asr #32
 1d8:	8b080e42 	blhi	203ae8 <__bss_end+0x1f9be8>
 1dc:	42018e02 	andmi	r8, r1, #2, 28
 1e0:	5a040b0c 	bpl	102e18 <__bss_end+0xf8f18>
 1e4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1e8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	000082e4 	andeq	r8, r0, r4, ror #5
 1f4:	00000314 	andeq	r0, r0, r4, lsl r3
 1f8:	8b080e42 	blhi	203b08 <__bss_end+0x1f9c08>
 1fc:	42018e02 	andmi	r8, r1, #2, 28
 200:	00040b0c 	andeq	r0, r4, ip, lsl #22
 204:	0000000c 	andeq	r0, r0, ip
 208:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 20c:	7c020001 	stcvc	0, cr0, [r2], {1}
 210:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	00000204 	andeq	r0, r0, r4, lsl #4
 21c:	000085f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 220:	0000002c 	andeq	r0, r0, ip, lsr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9c34>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346b34>
 22c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	00000204 	andeq	r0, r0, r4, lsl #4
 23c:	00008624 	andeq	r8, r0, r4, lsr #12
 240:	0000002c 	andeq	r0, r0, ip, lsr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9c54>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346b54>
 24c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	00000204 	andeq	r0, r0, r4, lsl #4
 25c:	00008650 	andeq	r8, r0, r0, asr r6
 260:	0000001c 	andeq	r0, r0, ip, lsl r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9c74>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346b74>
 26c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	00000204 	andeq	r0, r0, r4, lsl #4
 27c:	0000866c 	andeq	r8, r0, ip, ror #12
 280:	00000044 	andeq	r0, r0, r4, asr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9c94>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346b94>
 28c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	00000204 	andeq	r0, r0, r4, lsl #4
 29c:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9cb4>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346bb4>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	00000204 	andeq	r0, r0, r4, lsl #4
 2bc:	00008700 	andeq	r8, r0, r0, lsl #14
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9cd4>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346bd4>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	00000204 	andeq	r0, r0, r4, lsl #4
 2dc:	00008750 	andeq	r8, r0, r0, asr r7
 2e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9cf4>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346bf4>
 2ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	00000204 	andeq	r0, r0, r4, lsl #4
 2fc:	0000877c 	andeq	r8, r0, ip, ror r7
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9d14>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346c14>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	00000204 	andeq	r0, r0, r4, lsl #4
 31c:	000087cc 	andeq	r8, r0, ip, asr #15
 320:	00000044 	andeq	r0, r0, r4, asr #32
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf9d34>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346c34>
 32c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	00000204 	andeq	r0, r0, r4, lsl #4
 33c:	00008810 	andeq	r8, r0, r0, lsl r8
 340:	00000050 	andeq	r0, r0, r0, asr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf9d54>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346c54>
 34c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	00000204 	andeq	r0, r0, r4, lsl #4
 35c:	00008860 	andeq	r8, r0, r0, ror #16
 360:	00000054 	andeq	r0, r0, r4, asr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf9d74>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346c74>
 36c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	00000204 	andeq	r0, r0, r4, lsl #4
 37c:	000088b4 			; <UNDEFINED> instruction: 0x000088b4
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf9d94>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346c94>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	00000204 	andeq	r0, r0, r4, lsl #4
 39c:	000088f0 	strdeq	r8, [r0], -r0
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xf9db4>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x346cb4>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	00000204 	andeq	r0, r0, r4, lsl #4
 3bc:	0000892c 	andeq	r8, r0, ip, lsr #18
 3c0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3c4:	8b040e42 	blhi	103cd4 <__bss_end+0xf9dd4>
 3c8:	0b0d4201 	bleq	350bd4 <__bss_end+0x346cd4>
 3cc:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d8:	00000204 	andeq	r0, r0, r4, lsl #4
 3dc:	00008968 	andeq	r8, r0, r8, ror #18
 3e0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3e4:	8b040e42 	blhi	103cf4 <__bss_end+0xf9df4>
 3e8:	0b0d4201 	bleq	350bf4 <__bss_end+0x346cf4>
 3ec:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f8:	00000204 	andeq	r0, r0, r4, lsl #4
 3fc:	000089a4 	andeq	r8, r0, r4, lsr #19
 400:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 404:	8b080e42 	blhi	203d14 <__bss_end+0x1f9e14>
 408:	42018e02 	andmi	r8, r1, #2, 28
 40c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 410:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 414:	0000000c 	andeq	r0, r0, ip
 418:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 41c:	7c020001 	stcvc	0, cr0, [r2], {1}
 420:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	00000414 	andeq	r0, r0, r4, lsl r4
 42c:	00008a54 	andeq	r8, r0, r4, asr sl
 430:	0000003c 	andeq	r0, r0, ip, lsr r0
 434:	8b080e42 	blhi	203d44 <__bss_end+0x1f9e44>
 438:	42018e02 	andmi	r8, r1, #2, 28
 43c:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 440:	00080d0c 	andeq	r0, r8, ip, lsl #26
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	00000414 	andeq	r0, r0, r4, lsl r4
 44c:	00008a90 	muleq	r0, r0, sl
 450:	00000070 	andeq	r0, r0, r0, ror r0
 454:	8b080e42 	blhi	203d64 <__bss_end+0x1f9e64>
 458:	42018e02 	andmi	r8, r1, #2, 28
 45c:	72040b0c 	andvc	r0, r4, #12, 22	; 0x3000
 460:	00080d0c 	andeq	r0, r8, ip, lsl #26
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	00000414 	andeq	r0, r0, r4, lsl r4
 46c:	00008b00 	andeq	r8, r0, r0, lsl #22
 470:	00000074 	andeq	r0, r0, r4, ror r0
 474:	8b080e42 	blhi	203d84 <__bss_end+0x1f9e84>
 478:	42018e02 	andmi	r8, r1, #2, 28
 47c:	72040b0c 	andvc	r0, r4, #12, 22	; 0x3000
 480:	00080d0c 	andeq	r0, r8, ip, lsl #26
 484:	0000000c 	andeq	r0, r0, ip
 488:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 48c:	7c020001 	stcvc	0, cr0, [r2], {1}
 490:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 494:	0000001c 	andeq	r0, r0, ip, lsl r0
 498:	00000484 	andeq	r0, r0, r4, lsl #9
 49c:	00008b74 	andeq	r8, r0, r4, ror fp
 4a0:	00000174 	andeq	r0, r0, r4, ror r1
 4a4:	8b080e42 	blhi	203db4 <__bss_end+0x1f9eb4>
 4a8:	42018e02 	andmi	r8, r1, #2, 28
 4ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4b0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 4b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b8:	00000484 	andeq	r0, r0, r4, lsl #9
 4bc:	00008ce8 	andeq	r8, r0, r8, ror #25
 4c0:	0000009c 	muleq	r0, ip, r0
 4c4:	8b040e42 	blhi	103dd4 <__bss_end+0xf9ed4>
 4c8:	0b0d4201 	bleq	350cd4 <__bss_end+0x346dd4>
 4cc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 4d0:	000ecb42 	andeq	ip, lr, r2, asr #22
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	00000484 	andeq	r0, r0, r4, lsl #9
 4dc:	00008d84 	andeq	r8, r0, r4, lsl #27
 4e0:	000000c0 	andeq	r0, r0, r0, asr #1
 4e4:	8b040e42 	blhi	103df4 <__bss_end+0xf9ef4>
 4e8:	0b0d4201 	bleq	350cf4 <__bss_end+0x346df4>
 4ec:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 4f0:	000ecb42 	andeq	ip, lr, r2, asr #22
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	00000484 	andeq	r0, r0, r4, lsl #9
 4fc:	00008e44 	andeq	r8, r0, r4, asr #28
 500:	000000ac 	andeq	r0, r0, ip, lsr #1
 504:	8b040e42 	blhi	103e14 <__bss_end+0xf9f14>
 508:	0b0d4201 	bleq	350d14 <__bss_end+0x346e14>
 50c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 510:	000ecb42 	andeq	ip, lr, r2, asr #22
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	00000484 	andeq	r0, r0, r4, lsl #9
 51c:	00008ef0 	strdeq	r8, [r0], -r0
 520:	00000054 	andeq	r0, r0, r4, asr r0
 524:	8b040e42 	blhi	103e34 <__bss_end+0xf9f34>
 528:	0b0d4201 	bleq	350d34 <__bss_end+0x346e34>
 52c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 530:	00000ecb 	andeq	r0, r0, fp, asr #29
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	00000484 	andeq	r0, r0, r4, lsl #9
 53c:	00008f44 	andeq	r8, r0, r4, asr #30
 540:	00000068 	andeq	r0, r0, r8, rrx
 544:	8b040e42 	blhi	103e54 <__bss_end+0xf9f54>
 548:	0b0d4201 	bleq	350d54 <__bss_end+0x346e54>
 54c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 550:	00000ecb 	andeq	r0, r0, fp, asr #29
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	00000484 	andeq	r0, r0, r4, lsl #9
 55c:	00008fac 	andeq	r8, r0, ip, lsr #31
 560:	00000080 	andeq	r0, r0, r0, lsl #1
 564:	8b040e42 	blhi	103e74 <__bss_end+0xf9f74>
 568:	0b0d4201 	bleq	350d74 <__bss_end+0x346e74>
 56c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 570:	00000ecb 	andeq	r0, r0, fp, asr #29
 574:	0000001c 	andeq	r0, r0, ip, lsl r0
 578:	00000484 	andeq	r0, r0, r4, lsl #9
 57c:	0000902c 	andeq	r9, r0, ip, lsr #32
 580:	0000006c 	andeq	r0, r0, ip, rrx
 584:	8b040e42 	blhi	103e94 <__bss_end+0xf9f94>
 588:	0b0d4201 	bleq	350d94 <__bss_end+0x346e94>
 58c:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 590:	00000ecb 	andeq	r0, r0, fp, asr #29
 594:	0000001c 	andeq	r0, r0, ip, lsl r0
 598:	00000484 	andeq	r0, r0, r4, lsl #9
 59c:	00009098 	muleq	r0, r8, r0
 5a0:	000000c4 	andeq	r0, r0, r4, asr #1
 5a4:	8b080e42 	blhi	203eb4 <__bss_end+0x1f9fb4>
 5a8:	42018e02 	andmi	r8, r1, #2, 28
 5ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 5b4:	00000020 	andeq	r0, r0, r0, lsr #32
 5b8:	00000484 	andeq	r0, r0, r4, lsl #9
 5bc:	0000915c 	andeq	r9, r0, ip, asr r1
 5c0:	00000440 	andeq	r0, r0, r0, asr #8
 5c4:	8b040e42 	blhi	103ed4 <__bss_end+0xf9fd4>
 5c8:	0b0d4201 	bleq	350dd4 <__bss_end+0x346ed4>
 5cc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 5d0:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 5d4:	00000000 	andeq	r0, r0, r0
 5d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5dc:	00000484 	andeq	r0, r0, r4, lsl #9
 5e0:	0000959c 	muleq	r0, ip, r5
 5e4:	000000d4 	ldrdeq	r0, [r0], -r4
 5e8:	8b080e42 	blhi	203ef8 <__bss_end+0x1f9ff8>
 5ec:	42018e02 	andmi	r8, r1, #2, 28
 5f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5f4:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 5f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5fc:	00000484 	andeq	r0, r0, r4, lsl #9
 600:	00009670 	andeq	r9, r0, r0, ror r6
 604:	0000003c 	andeq	r0, r0, ip, lsr r0
 608:	8b040e42 	blhi	103f18 <__bss_end+0xfa018>
 60c:	0b0d4201 	bleq	350e18 <__bss_end+0x346f18>
 610:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 614:	00000ecb 	andeq	r0, r0, fp, asr #29
 618:	0000001c 	andeq	r0, r0, ip, lsl r0
 61c:	00000484 	andeq	r0, r0, r4, lsl #9
 620:	000096ac 	andeq	r9, r0, ip, lsr #13
 624:	00000040 	andeq	r0, r0, r0, asr #32
 628:	8b040e42 	blhi	103f38 <__bss_end+0xfa038>
 62c:	0b0d4201 	bleq	350e38 <__bss_end+0x346f38>
 630:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 634:	00000ecb 	andeq	r0, r0, fp, asr #29
 638:	0000001c 	andeq	r0, r0, ip, lsl r0
 63c:	00000484 	andeq	r0, r0, r4, lsl #9
 640:	000096ec 	andeq	r9, r0, ip, ror #13
 644:	00000030 	andeq	r0, r0, r0, lsr r0
 648:	8b080e42 	blhi	203f58 <__bss_end+0x1fa058>
 64c:	42018e02 	andmi	r8, r1, #2, 28
 650:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 654:	00080d0c 	andeq	r0, r8, ip, lsl #26
 658:	00000020 	andeq	r0, r0, r0, lsr #32
 65c:	00000484 	andeq	r0, r0, r4, lsl #9
 660:	0000971c 	andeq	r9, r0, ip, lsl r7
 664:	00000324 	andeq	r0, r0, r4, lsr #6
 668:	8b080e42 	blhi	203f78 <__bss_end+0x1fa078>
 66c:	42018e02 	andmi	r8, r1, #2, 28
 670:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 674:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 678:	00000008 	andeq	r0, r0, r8
 67c:	0000001c 	andeq	r0, r0, ip, lsl r0
 680:	00000484 	andeq	r0, r0, r4, lsl #9
 684:	00009a40 	andeq	r9, r0, r0, asr #20
 688:	00000110 	andeq	r0, r0, r0, lsl r1
 68c:	8b040e42 	blhi	103f9c <__bss_end+0xfa09c>
 690:	0b0d4201 	bleq	350e9c <__bss_end+0x346f9c>
 694:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 698:	000ecb42 	andeq	ip, lr, r2, asr #22
 69c:	0000000c 	andeq	r0, r0, ip
 6a0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6a4:	7c010001 	stcvc	0, cr0, [r1], {1}
 6a8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6ac:	0000000c 	andeq	r0, r0, ip
 6b0:	0000069c 	muleq	r0, ip, r6
 6b4:	00009b50 	andeq	r9, r0, r0, asr fp
 6b8:	000001ec 	andeq	r0, r0, ip, ror #3
