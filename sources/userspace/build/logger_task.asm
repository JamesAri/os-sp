
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
    805c:	00009cb0 			; <UNDEFINED> instruction: 0x00009cb0
    8060:	00009cc0 	andeq	r9, r0, r0, asr #25

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
    8080:	eb000086 	bl	82a0 <main>
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
    81cc:	00009cad 	andeq	r9, r0, sp, lsr #25
    81d0:	00009cad 	andeq	r9, r0, sp, lsr #25

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
    8224:	00009cad 	andeq	r9, r0, sp, lsr #25
    8228:	00009cad 	andeq	r9, r0, sp, lsr #25

0000822c <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:14
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
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:15
	write(file, string, strlen(string));
    8240:	e51b000c 	ldr	r0, [fp, #-12]
    8244:	eb0002b9 	bl	8d30 <_Z6strlenPKc>
    8248:	e1a03000 	mov	r3, r0
    824c:	e1a02003 	mov	r2, r3
    8250:	e51b100c 	ldr	r1, [fp, #-12]
    8254:	e51b0008 	ldr	r0, [fp, #-8]
    8258:	eb000100 	bl	8660 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:16
}
    825c:	e320f000 	nop	{0}
    8260:	e24bd004 	sub	sp, fp, #4
    8264:	e8bd8800 	pop	{fp, pc}

00008268 <_ZL5fgetsjPcj>:
_ZL5fgetsjPcj():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:19

static uint32_t fgets(uint32_t file, char* buffer, uint32_t size)
{
    8268:	e92d4800 	push	{fp, lr}
    826c:	e28db004 	add	fp, sp, #4
    8270:	e24dd010 	sub	sp, sp, #16
    8274:	e50b0008 	str	r0, [fp, #-8]
    8278:	e50b100c 	str	r1, [fp, #-12]
    827c:	e50b2010 	str	r2, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:20
	return read(file, buffer, size);
    8280:	e51b2010 	ldr	r2, [fp, #-16]
    8284:	e51b100c 	ldr	r1, [fp, #-12]
    8288:	e51b0008 	ldr	r0, [fp, #-8]
    828c:	eb0000df 	bl	8610 <_Z4readjPcj>
    8290:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:21
}
    8294:	e1a00003 	mov	r0, r3
    8298:	e24bd004 	sub	sp, fp, #4
    829c:	e8bd8800 	pop	{fp, pc}

000082a0 <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:24

int main(int argc, char** argv)
{
    82a0:	e92d4800 	push	{fp, lr}
    82a4:	e28db004 	add	fp, sp, #4
    82a8:	e24ddd11 	sub	sp, sp, #1088	; 0x440
    82ac:	e50b0440 	str	r0, [fp, #-1088]	; 0xfffffbc0
    82b0:	e50b1444 	str	r1, [fp, #-1092]	; 0xfffffbbc
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:25
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    82b4:	e3a01002 	mov	r1, #2
    82b8:	e59f0260 	ldr	r0, [pc, #608]	; 8520 <main+0x280>
    82bc:	eb0000c2 	bl	85cc <_Z4openPKc15NFile_Open_Mode>
    82c0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:28

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    82c4:	e59f3258 	ldr	r3, [pc, #600]	; 8524 <main+0x284>
    82c8:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:29
	params.char_length = NUART_Char_Length::Char_8;
    82cc:	e3a03001 	mov	r3, #1
    82d0:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:30
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    82d4:	e24b3020 	sub	r3, fp, #32
    82d8:	e1a02003 	mov	r2, r3
    82dc:	e3a01001 	mov	r1, #1
    82e0:	e51b000c 	ldr	r0, [fp, #-12]
    82e4:	eb0000fc 	bl	86dc <_Z5ioctlj16NIOCtl_OperationPv>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:32

	fputs(uart_file, "UART task starting!");
    82e8:	e59f1238 	ldr	r1, [pc, #568]	; 8528 <main+0x288>
    82ec:	e51b000c 	ldr	r0, [fp, #-12]
    82f0:	ebffffcd 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:36

	char buf[1000];
	char int_str_buffer[16];
	bzero(buf, 1000);
    82f4:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    82f8:	e2433004 	sub	r3, r3, #4
    82fc:	e2433004 	sub	r3, r3, #4
    8300:	e3a01ffa 	mov	r1, #1000	; 0x3e8
    8304:	e1a00003 	mov	r0, r3
    8308:	eb00029d 	bl	8d84 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:37
	bzero(int_str_buffer, 16);
    830c:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8310:	e2433004 	sub	r3, r3, #4
    8314:	e2433004 	sub	r3, r3, #4
    8318:	e3a01010 	mov	r1, #16
    831c:	e1a00003 	mov	r0, r3
    8320:	eb000297 	bl	8d84 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:39

	float cislo = 123.456f;
    8324:	e59f3200 	ldr	r3, [pc, #512]	; 852c <main+0x28c>
    8328:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:41
	char cislo_str[32];
	bzero(cislo_str, 32);
    832c:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    8330:	e2433004 	sub	r3, r3, #4
    8334:	e2433004 	sub	r3, r3, #4
    8338:	e3a01020 	mov	r1, #32
    833c:	e1a00003 	mov	r0, r3
    8340:	eb00028f 	bl	8d84 <_Z5bzeroPvi>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:42
	ftoa(cislo, cislo_str);
    8344:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    8348:	e2433004 	sub	r3, r3, #4
    834c:	e2433004 	sub	r3, r3, #4
    8350:	e1a00003 	mov	r0, r3
    8354:	ed1b0a04 	vldr	s0, [fp, #-16]
    8358:	eb000473 	bl	952c <_Z4ftoafPc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:43
	fputs(uart_file, "\r\nSENDING FLOAT!\r\n");
    835c:	e59f11cc 	ldr	r1, [pc, #460]	; 8530 <main+0x290>
    8360:	e51b000c 	ldr	r0, [fp, #-12]
    8364:	ebffffb0 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:44
	fputs(uart_file, cislo_str);
    8368:	e24b3e43 	sub	r3, fp, #1072	; 0x430
    836c:	e2433004 	sub	r3, r3, #4
    8370:	e2433004 	sub	r3, r3, #4
    8374:	e1a01003 	mov	r1, r3
    8378:	e51b000c 	ldr	r0, [fp, #-12]
    837c:	ebffffaa 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:45
	fputs(uart_file, "\r\nSENT FLOAT!\r\n");
    8380:	e59f11ac 	ldr	r1, [pc, #428]	; 8534 <main+0x294>
    8384:	e51b000c 	ldr	r0, [fp, #-12]
    8388:	ebffffa7 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:50


	while(true) 
	{
		uint32_t v = fgets(uart_file, buf, 1000);
    838c:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    8390:	e2433004 	sub	r3, r3, #4
    8394:	e2433004 	sub	r3, r3, #4
    8398:	e3a02ffa 	mov	r2, #1000	; 0x3e8
    839c:	e1a01003 	mov	r1, r3
    83a0:	e51b000c 	ldr	r0, [fp, #-12]
    83a4:	ebffffaf 	bl	8268 <_ZL5fgetsjPcj>
    83a8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:52

		if (v > 0)
    83ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83b0:	e3530000 	cmp	r3, #0
    83b4:	0a00004e 	beq	84f4 <main+0x254>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:54
		{
			buf[999] = '\0';
    83b8:	e3a03000 	mov	r3, #0
    83bc:	e54b3021 	strb	r3, [fp, #-33]	; 0xffffffdf
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:55
			if (v < 1000) buf[v] = '\0';
    83c0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83c4:	e3530ffa 	cmp	r3, #1000	; 0x3e8
    83c8:	2a000006 	bcs	83e8 <main+0x148>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:55 (discriminator 1)
    83cc:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    83d0:	e2433004 	sub	r3, r3, #4
    83d4:	e2433004 	sub	r3, r3, #4
    83d8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    83dc:	e0833002 	add	r3, r3, r2
    83e0:	e3a02000 	mov	r2, #0
    83e4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:57

			itoa(v, int_str_buffer, 10);
    83e8:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    83ec:	e2433004 	sub	r3, r3, #4
    83f0:	e2433004 	sub	r3, r3, #4
    83f4:	e3a0200a 	mov	r2, #10
    83f8:	e1a01003 	mov	r1, r3
    83fc:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    8400:	eb00016b 	bl	89b4 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:58
			fputs(uart_file, "RECEIVED DATA!\r\n");
    8404:	e59f112c 	ldr	r1, [pc, #300]	; 8538 <main+0x298>
    8408:	e51b000c 	ldr	r0, [fp, #-12]
    840c:	ebffff86 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:59
			fputs(uart_file, "[");
    8410:	e59f1124 	ldr	r1, [pc, #292]	; 853c <main+0x29c>
    8414:	e51b000c 	ldr	r0, [fp, #-12]
    8418:	ebffff83 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:60
			fputs(uart_file, int_str_buffer);
    841c:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    8420:	e2433004 	sub	r3, r3, #4
    8424:	e2433004 	sub	r3, r3, #4
    8428:	e1a01003 	mov	r1, r3
    842c:	e51b000c 	ldr	r0, [fp, #-12]
    8430:	ebffff7d 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:61
			fputs(uart_file, "]: ");
    8434:	e59f1104 	ldr	r1, [pc, #260]	; 8540 <main+0x2a0>
    8438:	e51b000c 	ldr	r0, [fp, #-12]
    843c:	ebffff7a 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:62
			fputs(uart_file, buf);
    8440:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    8444:	e2433004 	sub	r3, r3, #4
    8448:	e2433004 	sub	r3, r3, #4
    844c:	e1a01003 	mov	r1, r3
    8450:	e51b000c 	ldr	r0, [fp, #-12]
    8454:	ebffff74 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:63
			fputs(uart_file, "\r\n");
    8458:	e59f10e4 	ldr	r1, [pc, #228]	; 8544 <main+0x2a4>
    845c:	e51b000c 	ldr	r0, [fp, #-12]
    8460:	ebffff71 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:65

			for (uint32_t i = 0; i < v; i++)
    8464:	e3a03000 	mov	r3, #0
    8468:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:65 (discriminator 3)
    846c:	e51b2008 	ldr	r2, [fp, #-8]
    8470:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8474:	e1520003 	cmp	r2, r3
    8478:	2affffc3 	bcs	838c <main+0xec>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:67 (discriminator 2)
			{
				int char_val_int = buf[i];
    847c:	e24b3b01 	sub	r3, fp, #1024	; 0x400
    8480:	e2433004 	sub	r3, r3, #4
    8484:	e2433004 	sub	r3, r3, #4
    8488:	e51b2008 	ldr	r2, [fp, #-8]
    848c:	e0833002 	add	r3, r3, r2
    8490:	e5d33000 	ldrb	r3, [r3]
    8494:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:68 (discriminator 2)
				itoa(char_val_int, int_str_buffer, 16);
    8498:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    849c:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    84a0:	e2433004 	sub	r3, r3, #4
    84a4:	e2433004 	sub	r3, r3, #4
    84a8:	e3a02010 	mov	r2, #16
    84ac:	e1a01003 	mov	r1, r3
    84b0:	eb00013f 	bl	89b4 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:69 (discriminator 2)
				fputs(uart_file, "CHAR[");
    84b4:	e59f108c 	ldr	r1, [pc, #140]	; 8548 <main+0x2a8>
    84b8:	e51b000c 	ldr	r0, [fp, #-12]
    84bc:	ebffff5a 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:70 (discriminator 2)
				fputs(uart_file, int_str_buffer);
    84c0:	e24b3e41 	sub	r3, fp, #1040	; 0x410
    84c4:	e2433004 	sub	r3, r3, #4
    84c8:	e2433004 	sub	r3, r3, #4
    84cc:	e1a01003 	mov	r1, r3
    84d0:	e51b000c 	ldr	r0, [fp, #-12]
    84d4:	ebffff54 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:71 (discriminator 2)
				fputs(uart_file, "]\r\n");
    84d8:	e59f106c 	ldr	r1, [pc, #108]	; 854c <main+0x2ac>
    84dc:	e51b000c 	ldr	r0, [fp, #-12]
    84e0:	ebffff51 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:65 (discriminator 2)
			for (uint32_t i = 0; i < v; i++)
    84e4:	e51b3008 	ldr	r3, [fp, #-8]
    84e8:	e2833001 	add	r3, r3, #1
    84ec:	e50b3008 	str	r3, [fp, #-8]
    84f0:	eaffffdd 	b	846c <main+0x1cc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:74
			}
		} else {
			fputs(uart_file, "WAIT CALLED!\r\n");
    84f4:	e59f1054 	ldr	r1, [pc, #84]	; 8550 <main+0x2b0>
    84f8:	e51b000c 	ldr	r0, [fp, #-12]
    84fc:	ebffff4a 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:75
			wait(uart_file);
    8500:	e3e02001 	mvn	r2, #1
    8504:	e3a01001 	mov	r1, #1
    8508:	e51b000c 	ldr	r0, [fp, #-12]
    850c:	eb000097 	bl	8770 <_Z4waitjjj>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:76
			fputs(uart_file, "WOKE UP!\r\n");
    8510:	e59f103c 	ldr	r1, [pc, #60]	; 8554 <main+0x2b4>
    8514:	e51b000c 	ldr	r0, [fp, #-12]
    8518:	ebffff43 	bl	822c <_ZL5fputsjPKc>
/home/jamesari/git/os/sp/sources/userspace/logger_task/main.cpp:78
		}
	}
    851c:	eaffff9a 	b	838c <main+0xec>
    8520:	00009bd0 	ldrdeq	r9, [r0], -r0
    8524:	0001c200 	andeq	ip, r1, r0, lsl #4
    8528:	00009bdc 	ldrdeq	r9, [r0], -ip
    852c:	42f6e979 	rscsmi	lr, r6, #1982464	; 0x1e4000
    8530:	00009bf0 	strdeq	r9, [r0], -r0
    8534:	00009c04 	andeq	r9, r0, r4, lsl #24
    8538:	00009c14 	andeq	r9, r0, r4, lsl ip
    853c:	00009c28 	andeq	r9, r0, r8, lsr #24
    8540:	00009c2c 	andeq	r9, r0, ip, lsr #24
    8544:	00009c30 	andeq	r9, r0, r0, lsr ip
    8548:	00009c34 	andeq	r9, r0, r4, lsr ip
    854c:	00009c3c 	andeq	r9, r0, ip, lsr ip
    8550:	00009c40 	andeq	r9, r0, r0, asr #24
    8554:	00009c50 	andeq	r9, r0, r0, asr ip

00008558 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8558:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    855c:	e28db000 	add	fp, sp, #0
    8560:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8564:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8568:	e1a03000 	mov	r3, r0
    856c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8570:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    8574:	e1a00003 	mov	r0, r3
    8578:	e28bd000 	add	sp, fp, #0
    857c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8580:	e12fff1e 	bx	lr

00008584 <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8584:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8588:	e28db000 	add	fp, sp, #0
    858c:	e24dd00c 	sub	sp, sp, #12
    8590:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8594:	e51b3008 	ldr	r3, [fp, #-8]
    8598:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    859c:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    85a0:	e320f000 	nop	{0}
    85a4:	e28bd000 	add	sp, fp, #0
    85a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85ac:	e12fff1e 	bx	lr

000085b0 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    85b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b4:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    85b8:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    85bc:	e320f000 	nop	{0}
    85c0:	e28bd000 	add	sp, fp, #0
    85c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c8:	e12fff1e 	bx	lr

000085cc <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    85cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d0:	e28db000 	add	fp, sp, #0
    85d4:	e24dd014 	sub	sp, sp, #20
    85d8:	e50b0010 	str	r0, [fp, #-16]
    85dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    85e0:	e51b3010 	ldr	r3, [fp, #-16]
    85e4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    85e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85ec:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    85f0:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    85f4:	e1a03000 	mov	r3, r0
    85f8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    85fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    8600:	e1a00003 	mov	r0, r3
    8604:	e28bd000 	add	sp, fp, #0
    8608:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    860c:	e12fff1e 	bx	lr

00008610 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8610:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8614:	e28db000 	add	fp, sp, #0
    8618:	e24dd01c 	sub	sp, sp, #28
    861c:	e50b0010 	str	r0, [fp, #-16]
    8620:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8624:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8628:	e51b3010 	ldr	r3, [fp, #-16]
    862c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8630:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8634:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8638:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    863c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8640:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8644:	e1a03000 	mov	r3, r0
    8648:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    864c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    8650:	e1a00003 	mov	r0, r3
    8654:	e28bd000 	add	sp, fp, #0
    8658:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    865c:	e12fff1e 	bx	lr

00008660 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8660:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8664:	e28db000 	add	fp, sp, #0
    8668:	e24dd01c 	sub	sp, sp, #28
    866c:	e50b0010 	str	r0, [fp, #-16]
    8670:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8674:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8678:	e51b3010 	ldr	r3, [fp, #-16]
    867c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8680:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8684:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8688:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    868c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8690:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8694:	e1a03000 	mov	r3, r0
    8698:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    869c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    86a0:	e1a00003 	mov	r0, r3
    86a4:	e28bd000 	add	sp, fp, #0
    86a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86ac:	e12fff1e 	bx	lr

000086b0 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    86b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b4:	e28db000 	add	fp, sp, #0
    86b8:	e24dd00c 	sub	sp, sp, #12
    86bc:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    86c0:	e51b3008 	ldr	r3, [fp, #-8]
    86c4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    86c8:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    86cc:	e320f000 	nop	{0}
    86d0:	e28bd000 	add	sp, fp, #0
    86d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86d8:	e12fff1e 	bx	lr

000086dc <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    86dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86e0:	e28db000 	add	fp, sp, #0
    86e4:	e24dd01c 	sub	sp, sp, #28
    86e8:	e50b0010 	str	r0, [fp, #-16]
    86ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    86f0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    86f4:	e51b3010 	ldr	r3, [fp, #-16]
    86f8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    86fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8700:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8704:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8708:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    870c:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8710:	e1a03000 	mov	r3, r0
    8714:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8718:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    871c:	e1a00003 	mov	r0, r3
    8720:	e28bd000 	add	sp, fp, #0
    8724:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8728:	e12fff1e 	bx	lr

0000872c <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    872c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8730:	e28db000 	add	fp, sp, #0
    8734:	e24dd014 	sub	sp, sp, #20
    8738:	e50b0010 	str	r0, [fp, #-16]
    873c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8740:	e51b3010 	ldr	r3, [fp, #-16]
    8744:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8748:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    874c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8750:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8754:	e1a03000 	mov	r3, r0
    8758:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    875c:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    8760:	e1a00003 	mov	r0, r3
    8764:	e28bd000 	add	sp, fp, #0
    8768:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    876c:	e12fff1e 	bx	lr

00008770 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8770:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8774:	e28db000 	add	fp, sp, #0
    8778:	e24dd01c 	sub	sp, sp, #28
    877c:	e50b0010 	str	r0, [fp, #-16]
    8780:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8784:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8788:	e51b3010 	ldr	r3, [fp, #-16]
    878c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8790:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8794:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8798:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    879c:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    87a0:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    87a4:	e1a03000 	mov	r3, r0
    87a8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    87ac:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    87b0:	e1a00003 	mov	r0, r3
    87b4:	e28bd000 	add	sp, fp, #0
    87b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87bc:	e12fff1e 	bx	lr

000087c0 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    87c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    87c4:	e28db000 	add	fp, sp, #0
    87c8:	e24dd014 	sub	sp, sp, #20
    87cc:	e50b0010 	str	r0, [fp, #-16]
    87d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    87d4:	e51b3010 	ldr	r3, [fp, #-16]
    87d8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    87dc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    87e0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    87e4:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    87e8:	e1a03000 	mov	r3, r0
    87ec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    87f0:	e51b3008 	ldr	r3, [fp, #-8]
    87f4:	e3530000 	cmp	r3, #0
    87f8:	13a03001 	movne	r3, #1
    87fc:	03a03000 	moveq	r3, #0
    8800:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    8804:	e1a00003 	mov	r0, r3
    8808:	e28bd000 	add	sp, fp, #0
    880c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8810:	e12fff1e 	bx	lr

00008814 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8814:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8818:	e28db000 	add	fp, sp, #0
    881c:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8820:	e3a03000 	mov	r3, #0
    8824:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8828:	e3a03000 	mov	r3, #0
    882c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8830:	e24b300c 	sub	r3, fp, #12
    8834:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8838:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    883c:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    8840:	e1a00003 	mov	r0, r3
    8844:	e28bd000 	add	sp, fp, #0
    8848:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    884c:	e12fff1e 	bx	lr

00008850 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8850:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8854:	e28db000 	add	fp, sp, #0
    8858:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    885c:	e3a03001 	mov	r3, #1
    8860:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8864:	e3a03001 	mov	r3, #1
    8868:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    886c:	e24b300c 	sub	r3, fp, #12
    8870:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8874:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8878:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    887c:	e1a00003 	mov	r0, r3
    8880:	e28bd000 	add	sp, fp, #0
    8884:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8888:	e12fff1e 	bx	lr

0000888c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    888c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8890:	e28db000 	add	fp, sp, #0
    8894:	e24dd014 	sub	sp, sp, #20
    8898:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    889c:	e3a03000 	mov	r3, #0
    88a0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    88a4:	e3a03000 	mov	r3, #0
    88a8:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    88ac:	e24b3010 	sub	r3, fp, #16
    88b0:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    88b4:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    88b8:	e320f000 	nop	{0}
    88bc:	e28bd000 	add	sp, fp, #0
    88c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88c4:	e12fff1e 	bx	lr

000088c8 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    88c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88cc:	e28db000 	add	fp, sp, #0
    88d0:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    88d4:	e3a03001 	mov	r3, #1
    88d8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    88dc:	e3a03001 	mov	r3, #1
    88e0:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    88e4:	e24b300c 	sub	r3, fp, #12
    88e8:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    88ec:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    88f0:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    88f4:	e1a00003 	mov	r0, r3
    88f8:	e28bd000 	add	sp, fp, #0
    88fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8900:	e12fff1e 	bx	lr

00008904 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8904:	e92d4800 	push	{fp, lr}
    8908:	e28db004 	add	fp, sp, #4
    890c:	e24dd050 	sub	sp, sp, #80	; 0x50
    8910:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8914:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8918:	e24b3048 	sub	r3, fp, #72	; 0x48
    891c:	e3a0200a 	mov	r2, #10
    8920:	e59f1088 	ldr	r1, [pc, #136]	; 89b0 <_Z4pipePKcj+0xac>
    8924:	e1a00003 	mov	r0, r3
    8928:	eb0000a5 	bl	8bc4 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    892c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8930:	e283300a 	add	r3, r3, #10
    8934:	e3a02035 	mov	r2, #53	; 0x35
    8938:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    893c:	e1a00003 	mov	r0, r3
    8940:	eb00009f 	bl	8bc4 <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8944:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8948:	eb0000f8 	bl	8d30 <_Z6strlenPKc>
    894c:	e1a03000 	mov	r3, r0
    8950:	e283300a 	add	r3, r3, #10
    8954:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8958:	e51b3008 	ldr	r3, [fp, #-8]
    895c:	e2832001 	add	r2, r3, #1
    8960:	e50b2008 	str	r2, [fp, #-8]
    8964:	e24b2004 	sub	r2, fp, #4
    8968:	e0823003 	add	r3, r2, r3
    896c:	e3a02023 	mov	r2, #35	; 0x23
    8970:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8974:	e24b2048 	sub	r2, fp, #72	; 0x48
    8978:	e51b3008 	ldr	r3, [fp, #-8]
    897c:	e0823003 	add	r3, r2, r3
    8980:	e3a0200a 	mov	r2, #10
    8984:	e1a01003 	mov	r1, r3
    8988:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    898c:	eb000008 	bl	89b4 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8990:	e24b3048 	sub	r3, fp, #72	; 0x48
    8994:	e3a01002 	mov	r1, #2
    8998:	e1a00003 	mov	r0, r3
    899c:	ebffff0a 	bl	85cc <_Z4openPKc15NFile_Open_Mode>
    89a0:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    89a4:	e1a00003 	mov	r0, r3
    89a8:	e24bd004 	sub	sp, fp, #4
    89ac:	e8bd8800 	pop	{fp, pc}
    89b0:	00009c8c 	andeq	r9, r0, ip, lsl #25

000089b4 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    89b4:	e92d4800 	push	{fp, lr}
    89b8:	e28db004 	add	fp, sp, #4
    89bc:	e24dd020 	sub	sp, sp, #32
    89c0:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    89c4:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    89c8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    89cc:	e3a03000 	mov	r3, #0
    89d0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    89d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89d8:	e3530000 	cmp	r3, #0
    89dc:	0a000014 	beq	8a34 <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    89e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89e4:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    89e8:	e1a00003 	mov	r0, r3
    89ec:	eb000462 	bl	9b7c <__aeabi_uidivmod>
    89f0:	e1a03001 	mov	r3, r1
    89f4:	e1a01003 	mov	r1, r3
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8a00:	e0823003 	add	r3, r2, r3
    8a04:	e59f2118 	ldr	r2, [pc, #280]	; 8b24 <_Z4itoajPcj+0x170>
    8a08:	e7d22001 	ldrb	r2, [r2, r1]
    8a0c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8a10:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8a14:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8a18:	eb0003dc 	bl	9990 <__udivsi3>
    8a1c:	e1a03000 	mov	r3, r0
    8a20:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8a24:	e51b3008 	ldr	r3, [fp, #-8]
    8a28:	e2833001 	add	r3, r3, #1
    8a2c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8a30:	eaffffe7 	b	89d4 <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8a34:	e51b3008 	ldr	r3, [fp, #-8]
    8a38:	e3530000 	cmp	r3, #0
    8a3c:	1a000007 	bne	8a60 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8a40:	e51b3008 	ldr	r3, [fp, #-8]
    8a44:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8a48:	e0823003 	add	r3, r2, r3
    8a4c:	e3a02030 	mov	r2, #48	; 0x30
    8a50:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8a54:	e51b3008 	ldr	r3, [fp, #-8]
    8a58:	e2833001 	add	r3, r3, #1
    8a5c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8a60:	e51b3008 	ldr	r3, [fp, #-8]
    8a64:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8a68:	e0823003 	add	r3, r2, r3
    8a6c:	e3a02000 	mov	r2, #0
    8a70:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8a74:	e51b3008 	ldr	r3, [fp, #-8]
    8a78:	e2433001 	sub	r3, r3, #1
    8a7c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8a80:	e3a03000 	mov	r3, #0
    8a84:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8a88:	e51b3008 	ldr	r3, [fp, #-8]
    8a8c:	e1a02fa3 	lsr	r2, r3, #31
    8a90:	e0823003 	add	r3, r2, r3
    8a94:	e1a030c3 	asr	r3, r3, #1
    8a98:	e1a02003 	mov	r2, r3
    8a9c:	e51b300c 	ldr	r3, [fp, #-12]
    8aa0:	e1530002 	cmp	r3, r2
    8aa4:	ca00001b 	bgt	8b18 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8aa8:	e51b2008 	ldr	r2, [fp, #-8]
    8aac:	e51b300c 	ldr	r3, [fp, #-12]
    8ab0:	e0423003 	sub	r3, r2, r3
    8ab4:	e1a02003 	mov	r2, r3
    8ab8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8abc:	e0833002 	add	r3, r3, r2
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8ac8:	e51b300c 	ldr	r3, [fp, #-12]
    8acc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8ad0:	e0822003 	add	r2, r2, r3
    8ad4:	e51b1008 	ldr	r1, [fp, #-8]
    8ad8:	e51b300c 	ldr	r3, [fp, #-12]
    8adc:	e0413003 	sub	r3, r1, r3
    8ae0:	e1a01003 	mov	r1, r3
    8ae4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ae8:	e0833001 	add	r3, r3, r1
    8aec:	e5d22000 	ldrb	r2, [r2]
    8af0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8af4:	e51b300c 	ldr	r3, [fp, #-12]
    8af8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8afc:	e0823003 	add	r3, r2, r3
    8b00:	e55b200d 	ldrb	r2, [fp, #-13]
    8b04:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8b08:	e51b300c 	ldr	r3, [fp, #-12]
    8b0c:	e2833001 	add	r3, r3, #1
    8b10:	e50b300c 	str	r3, [fp, #-12]
    8b14:	eaffffdb 	b	8a88 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8b18:	e320f000 	nop	{0}
    8b1c:	e24bd004 	sub	sp, fp, #4
    8b20:	e8bd8800 	pop	{fp, pc}
    8b24:	00009c9c 	muleq	r0, ip, ip

00008b28 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8b28:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b2c:	e28db000 	add	fp, sp, #0
    8b30:	e24dd014 	sub	sp, sp, #20
    8b34:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8b38:	e3a03000 	mov	r3, #0
    8b3c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8b40:	e51b3010 	ldr	r3, [fp, #-16]
    8b44:	e5d33000 	ldrb	r3, [r3]
    8b48:	e3530000 	cmp	r3, #0
    8b4c:	0a000017 	beq	8bb0 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8b50:	e51b2008 	ldr	r2, [fp, #-8]
    8b54:	e1a03002 	mov	r3, r2
    8b58:	e1a03103 	lsl	r3, r3, #2
    8b5c:	e0833002 	add	r3, r3, r2
    8b60:	e1a03083 	lsl	r3, r3, #1
    8b64:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8b68:	e51b3010 	ldr	r3, [fp, #-16]
    8b6c:	e5d33000 	ldrb	r3, [r3]
    8b70:	e3530039 	cmp	r3, #57	; 0x39
    8b74:	8a00000d 	bhi	8bb0 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8b78:	e51b3010 	ldr	r3, [fp, #-16]
    8b7c:	e5d33000 	ldrb	r3, [r3]
    8b80:	e353002f 	cmp	r3, #47	; 0x2f
    8b84:	9a000009 	bls	8bb0 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8b88:	e51b3010 	ldr	r3, [fp, #-16]
    8b8c:	e5d33000 	ldrb	r3, [r3]
    8b90:	e2433030 	sub	r3, r3, #48	; 0x30
    8b94:	e51b2008 	ldr	r2, [fp, #-8]
    8b98:	e0823003 	add	r3, r2, r3
    8b9c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8ba0:	e51b3010 	ldr	r3, [fp, #-16]
    8ba4:	e2833001 	add	r3, r3, #1
    8ba8:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8bac:	eaffffe3 	b	8b40 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8bb0:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8bb4:	e1a00003 	mov	r0, r3
    8bb8:	e28bd000 	add	sp, fp, #0
    8bbc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bc0:	e12fff1e 	bx	lr

00008bc4 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8bc4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bc8:	e28db000 	add	fp, sp, #0
    8bcc:	e24dd01c 	sub	sp, sp, #28
    8bd0:	e50b0010 	str	r0, [fp, #-16]
    8bd4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8bd8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8bdc:	e3a03000 	mov	r3, #0
    8be0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8be4:	e51b2008 	ldr	r2, [fp, #-8]
    8be8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bec:	e1520003 	cmp	r2, r3
    8bf0:	aa000011 	bge	8c3c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8bf4:	e51b3008 	ldr	r3, [fp, #-8]
    8bf8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8bfc:	e0823003 	add	r3, r2, r3
    8c00:	e5d33000 	ldrb	r3, [r3]
    8c04:	e3530000 	cmp	r3, #0
    8c08:	0a00000b 	beq	8c3c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8c0c:	e51b3008 	ldr	r3, [fp, #-8]
    8c10:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8c14:	e0822003 	add	r2, r2, r3
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b1010 	ldr	r1, [fp, #-16]
    8c20:	e0813003 	add	r3, r1, r3
    8c24:	e5d22000 	ldrb	r2, [r2]
    8c28:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
    8c38:	eaffffe9 	b	8be4 <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8c3c:	e51b2008 	ldr	r2, [fp, #-8]
    8c40:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c44:	e1520003 	cmp	r2, r3
    8c48:	aa000008 	bge	8c70 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8c4c:	e51b3008 	ldr	r3, [fp, #-8]
    8c50:	e51b2010 	ldr	r2, [fp, #-16]
    8c54:	e0823003 	add	r3, r2, r3
    8c58:	e3a02000 	mov	r2, #0
    8c5c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8c60:	e51b3008 	ldr	r3, [fp, #-8]
    8c64:	e2833001 	add	r3, r3, #1
    8c68:	e50b3008 	str	r3, [fp, #-8]
    8c6c:	eafffff2 	b	8c3c <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8c70:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8c74:	e1a00003 	mov	r0, r3
    8c78:	e28bd000 	add	sp, fp, #0
    8c7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c80:	e12fff1e 	bx	lr

00008c84 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8c84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c88:	e28db000 	add	fp, sp, #0
    8c8c:	e24dd01c 	sub	sp, sp, #28
    8c90:	e50b0010 	str	r0, [fp, #-16]
    8c94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8c98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8c9c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ca0:	e2432001 	sub	r2, r3, #1
    8ca4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8ca8:	e3530000 	cmp	r3, #0
    8cac:	c3a03001 	movgt	r3, #1
    8cb0:	d3a03000 	movle	r3, #0
    8cb4:	e6ef3073 	uxtb	r3, r3
    8cb8:	e3530000 	cmp	r3, #0
    8cbc:	0a000016 	beq	8d1c <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8cc0:	e51b3010 	ldr	r3, [fp, #-16]
    8cc4:	e2832001 	add	r2, r3, #1
    8cc8:	e50b2010 	str	r2, [fp, #-16]
    8ccc:	e5d33000 	ldrb	r3, [r3]
    8cd0:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8cd4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8cd8:	e2832001 	add	r2, r3, #1
    8cdc:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ce0:	e5d33000 	ldrb	r3, [r3]
    8ce4:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ce8:	e55b2005 	ldrb	r2, [fp, #-5]
    8cec:	e55b3006 	ldrb	r3, [fp, #-6]
    8cf0:	e1520003 	cmp	r2, r3
    8cf4:	0a000003 	beq	8d08 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8cf8:	e55b2005 	ldrb	r2, [fp, #-5]
    8cfc:	e55b3006 	ldrb	r3, [fp, #-6]
    8d00:	e0423003 	sub	r3, r2, r3
    8d04:	ea000005 	b	8d20 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8d08:	e55b3005 	ldrb	r3, [fp, #-5]
    8d0c:	e3530000 	cmp	r3, #0
    8d10:	1affffe1 	bne	8c9c <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8d14:	e3a03000 	mov	r3, #0
    8d18:	ea000000 	b	8d20 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8d1c:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8d20:	e1a00003 	mov	r0, r3
    8d24:	e28bd000 	add	sp, fp, #0
    8d28:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d2c:	e12fff1e 	bx	lr

00008d30 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8d30:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d34:	e28db000 	add	fp, sp, #0
    8d38:	e24dd014 	sub	sp, sp, #20
    8d3c:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8d40:	e3a03000 	mov	r3, #0
    8d44:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8d48:	e51b3008 	ldr	r3, [fp, #-8]
    8d4c:	e51b2010 	ldr	r2, [fp, #-16]
    8d50:	e0823003 	add	r3, r2, r3
    8d54:	e5d33000 	ldrb	r3, [r3]
    8d58:	e3530000 	cmp	r3, #0
    8d5c:	0a000003 	beq	8d70 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8d60:	e51b3008 	ldr	r3, [fp, #-8]
    8d64:	e2833001 	add	r3, r3, #1
    8d68:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8d6c:	eafffff5 	b	8d48 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8d70:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8d74:	e1a00003 	mov	r0, r3
    8d78:	e28bd000 	add	sp, fp, #0
    8d7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d80:	e12fff1e 	bx	lr

00008d84 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8d84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d88:	e28db000 	add	fp, sp, #0
    8d8c:	e24dd014 	sub	sp, sp, #20
    8d90:	e50b0010 	str	r0, [fp, #-16]
    8d94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8d98:	e51b3010 	ldr	r3, [fp, #-16]
    8d9c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8da0:	e3a03000 	mov	r3, #0
    8da4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8da8:	e51b2008 	ldr	r2, [fp, #-8]
    8dac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8db0:	e1520003 	cmp	r2, r3
    8db4:	aa000008 	bge	8ddc <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8db8:	e51b3008 	ldr	r3, [fp, #-8]
    8dbc:	e51b200c 	ldr	r2, [fp, #-12]
    8dc0:	e0823003 	add	r3, r2, r3
    8dc4:	e3a02000 	mov	r2, #0
    8dc8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8dcc:	e51b3008 	ldr	r3, [fp, #-8]
    8dd0:	e2833001 	add	r3, r3, #1
    8dd4:	e50b3008 	str	r3, [fp, #-8]
    8dd8:	eafffff2 	b	8da8 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8ddc:	e320f000 	nop	{0}
    8de0:	e28bd000 	add	sp, fp, #0
    8de4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8de8:	e12fff1e 	bx	lr

00008dec <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8dec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8df0:	e28db000 	add	fp, sp, #0
    8df4:	e24dd024 	sub	sp, sp, #36	; 0x24
    8df8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8dfc:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8e00:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8e04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e08:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8e0c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e10:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8e14:	e3a03000 	mov	r3, #0
    8e18:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8e1c:	e51b2008 	ldr	r2, [fp, #-8]
    8e20:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e24:	e1520003 	cmp	r2, r3
    8e28:	aa00000b 	bge	8e5c <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8e2c:	e51b3008 	ldr	r3, [fp, #-8]
    8e30:	e51b200c 	ldr	r2, [fp, #-12]
    8e34:	e0822003 	add	r2, r2, r3
    8e38:	e51b3008 	ldr	r3, [fp, #-8]
    8e3c:	e51b1010 	ldr	r1, [fp, #-16]
    8e40:	e0813003 	add	r3, r1, r3
    8e44:	e5d22000 	ldrb	r2, [r2]
    8e48:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8e4c:	e51b3008 	ldr	r3, [fp, #-8]
    8e50:	e2833001 	add	r3, r3, #1
    8e54:	e50b3008 	str	r3, [fp, #-8]
    8e58:	eaffffef 	b	8e1c <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8e5c:	e320f000 	nop	{0}
    8e60:	e28bd000 	add	sp, fp, #0
    8e64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8e68:	e12fff1e 	bx	lr

00008e6c <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8e6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e70:	e28db000 	add	fp, sp, #0
    8e74:	e24dd014 	sub	sp, sp, #20
    8e78:	ed0b0a04 	vstr	s0, [fp, #-16]
    8e7c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8e80:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8e84:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8e88:	e3a03000 	mov	r3, #0
    8e8c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8e90:	e51b200c 	ldr	r2, [fp, #-12]
    8e94:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8e98:	e1520003 	cmp	r2, r3
    8e9c:	2a000007 	bcs	8ec0 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8ea0:	ed1b7a02 	vldr	s14, [fp, #-8]
    8ea4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ea8:	ee677a27 	vmul.f32	s15, s14, s15
    8eac:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8eb0:	e51b300c 	ldr	r3, [fp, #-12]
    8eb4:	e2833001 	add	r3, r3, #1
    8eb8:	e50b300c 	str	r3, [fp, #-12]
    8ebc:	eafffff3 	b	8e90 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8ec0:	e51b3008 	ldr	r3, [fp, #-8]
    8ec4:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8ec8:	eeb00a67 	vmov.f32	s0, s15
    8ecc:	e28bd000 	add	sp, fp, #0
    8ed0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ed4:	e12fff1e 	bx	lr

00008ed8 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8ed8:	e92d4800 	push	{fp, lr}
    8edc:	e28db004 	add	fp, sp, #4
    8ee0:	e24dd018 	sub	sp, sp, #24
    8ee4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8ee8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8eec:	ebffff8f 	bl	8d30 <_Z6strlenPKc>
    8ef0:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8ef4:	e3a03000 	mov	r3, #0
    8ef8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8efc:	e51b300c 	ldr	r3, [fp, #-12]
    8f00:	e1a02fa3 	lsr	r2, r3, #31
    8f04:	e0823003 	add	r3, r2, r3
    8f08:	e1a030c3 	asr	r3, r3, #1
    8f0c:	e1a02003 	mov	r2, r3
    8f10:	e51b3008 	ldr	r3, [fp, #-8]
    8f14:	e1530002 	cmp	r3, r2
    8f18:	aa00001c 	bge	8f90 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8f1c:	e51b3008 	ldr	r3, [fp, #-8]
    8f20:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f24:	e0823003 	add	r3, r2, r3
    8f28:	e5d33000 	ldrb	r3, [r3]
    8f2c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8f30:	e51b200c 	ldr	r2, [fp, #-12]
    8f34:	e51b3008 	ldr	r3, [fp, #-8]
    8f38:	e0423003 	sub	r3, r2, r3
    8f3c:	e2433001 	sub	r3, r3, #1
    8f40:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f44:	e0822003 	add	r2, r2, r3
    8f48:	e51b3008 	ldr	r3, [fp, #-8]
    8f4c:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8f50:	e0813003 	add	r3, r1, r3
    8f54:	e5d22000 	ldrb	r2, [r2]
    8f58:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8f5c:	e51b200c 	ldr	r2, [fp, #-12]
    8f60:	e51b3008 	ldr	r3, [fp, #-8]
    8f64:	e0423003 	sub	r3, r2, r3
    8f68:	e2433001 	sub	r3, r3, #1
    8f6c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8f70:	e0823003 	add	r3, r2, r3
    8f74:	e51b2010 	ldr	r2, [fp, #-16]
    8f78:	e6ef2072 	uxtb	r2, r2
    8f7c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8f80:	e51b3008 	ldr	r3, [fp, #-8]
    8f84:	e2833001 	add	r3, r3, #1
    8f88:	e50b3008 	str	r3, [fp, #-8]
    8f8c:	eaffffda 	b	8efc <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8f90:	e320f000 	nop	{0}
    8f94:	e24bd004 	sub	sp, fp, #4
    8f98:	e8bd8800 	pop	{fp, pc}

00008f9c <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8f9c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8fa0:	e28db000 	add	fp, sp, #0
    8fa4:	e24dd01c 	sub	sp, sp, #28
    8fa8:	ed0b0a04 	vstr	s0, [fp, #-16]
    8fac:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8fb0:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8fb4:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8fb8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fbc:	ed9f7af3 	vldr	s14, [pc, #972]	; 9390 <_Z11split_floatfRjS_Ri+0x3f4>
    8fc0:	eef47ac7 	vcmpe.f32	s15, s14
    8fc4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fc8:	ba000053 	blt	911c <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8fcc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fd0:	ed9f7aef 	vldr	s14, [pc, #956]	; 9394 <_Z11split_floatfRjS_Ri+0x3f8>
    8fd4:	eef47ac7 	vcmpe.f32	s15, s14
    8fd8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fdc:	ba000008 	blt	9004 <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8fe0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fe4:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9398 <_Z11split_floatfRjS_Ri+0x3fc>
    8fe8:	ee677a87 	vmul.f32	s15, s15, s14
    8fec:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ff0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ff4:	e5933000 	ldr	r3, [r3]
    8ff8:	e2832020 	add	r2, r3, #32
    8ffc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9000:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    9004:	ed5b7a04 	vldr	s15, [fp, #-16]
    9008:	ed9f7ae3 	vldr	s14, [pc, #908]	; 939c <_Z11split_floatfRjS_Ri+0x400>
    900c:	eef47ac7 	vcmpe.f32	s15, s14
    9010:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9014:	ba000008 	blt	903c <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    9018:	ed5b7a04 	vldr	s15, [fp, #-16]
    901c:	ed9f7adf 	vldr	s14, [pc, #892]	; 93a0 <_Z11split_floatfRjS_Ri+0x404>
    9020:	ee677a87 	vmul.f32	s15, s15, s14
    9024:	ed4b7a04 	vstr	s15, [fp, #-16]
    9028:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    902c:	e5933000 	ldr	r3, [r3]
    9030:	e2832010 	add	r2, r3, #16
    9034:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9038:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    903c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9040:	ed9f7ad7 	vldr	s14, [pc, #860]	; 93a4 <_Z11split_floatfRjS_Ri+0x408>
    9044:	eef47ac7 	vcmpe.f32	s15, s14
    9048:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    904c:	ba000008 	blt	9074 <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    9050:	ed5b7a04 	vldr	s15, [fp, #-16]
    9054:	ed9f7ad3 	vldr	s14, [pc, #844]	; 93a8 <_Z11split_floatfRjS_Ri+0x40c>
    9058:	ee677a87 	vmul.f32	s15, s15, s14
    905c:	ed4b7a04 	vstr	s15, [fp, #-16]
    9060:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9064:	e5933000 	ldr	r3, [r3]
    9068:	e2832008 	add	r2, r3, #8
    906c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9070:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    9074:	ed5b7a04 	vldr	s15, [fp, #-16]
    9078:	ed9f7acb 	vldr	s14, [pc, #812]	; 93ac <_Z11split_floatfRjS_Ri+0x410>
    907c:	eef47ac7 	vcmpe.f32	s15, s14
    9080:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9084:	ba000008 	blt	90ac <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    9088:	ed5b7a04 	vldr	s15, [fp, #-16]
    908c:	ed9f7ac7 	vldr	s14, [pc, #796]	; 93b0 <_Z11split_floatfRjS_Ri+0x414>
    9090:	ee677a87 	vmul.f32	s15, s15, s14
    9094:	ed4b7a04 	vstr	s15, [fp, #-16]
    9098:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    909c:	e5933000 	ldr	r3, [r3]
    90a0:	e2832004 	add	r2, r3, #4
    90a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90a8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    90ac:	ed5b7a04 	vldr	s15, [fp, #-16]
    90b0:	ed9f7abf 	vldr	s14, [pc, #764]	; 93b4 <_Z11split_floatfRjS_Ri+0x418>
    90b4:	eef47ac7 	vcmpe.f32	s15, s14
    90b8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90bc:	ba000008 	blt	90e4 <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    90c0:	ed5b7a04 	vldr	s15, [fp, #-16]
    90c4:	ed9f7abb 	vldr	s14, [pc, #748]	; 93b8 <_Z11split_floatfRjS_Ri+0x41c>
    90c8:	ee677a87 	vmul.f32	s15, s15, s14
    90cc:	ed4b7a04 	vstr	s15, [fp, #-16]
    90d0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90d4:	e5933000 	ldr	r3, [r3]
    90d8:	e2832002 	add	r2, r3, #2
    90dc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90e0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    90e4:	ed5b7a04 	vldr	s15, [fp, #-16]
    90e8:	ed9f7aa8 	vldr	s14, [pc, #672]	; 9390 <_Z11split_floatfRjS_Ri+0x3f4>
    90ec:	eef47ac7 	vcmpe.f32	s15, s14
    90f0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90f4:	ba000008 	blt	911c <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    90f8:	ed5b7a04 	vldr	s15, [fp, #-16]
    90fc:	ed9f7aae 	vldr	s14, [pc, #696]	; 93bc <_Z11split_floatfRjS_Ri+0x420>
    9100:	ee677a87 	vmul.f32	s15, s15, s14
    9104:	ed4b7a04 	vstr	s15, [fp, #-16]
    9108:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    910c:	e5933000 	ldr	r3, [r3]
    9110:	e2832001 	add	r2, r3, #1
    9114:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9118:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    911c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9120:	eef57ac0 	vcmpe.f32	s15, #0.0
    9124:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9128:	da000058 	ble	9290 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    912c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9130:	ed9f7aa2 	vldr	s14, [pc, #648]	; 93c0 <_Z11split_floatfRjS_Ri+0x424>
    9134:	eef47ac7 	vcmpe.f32	s15, s14
    9138:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    913c:	8a000053 	bhi	9290 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    9140:	ed5b7a04 	vldr	s15, [fp, #-16]
    9144:	ed9f7a9e 	vldr	s14, [pc, #632]	; 93c4 <_Z11split_floatfRjS_Ri+0x428>
    9148:	eef47ac7 	vcmpe.f32	s15, s14
    914c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9150:	5a000008 	bpl	9178 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    9154:	ed5b7a04 	vldr	s15, [fp, #-16]
    9158:	ed9f7a8d 	vldr	s14, [pc, #564]	; 9394 <_Z11split_floatfRjS_Ri+0x3f8>
    915c:	ee677a87 	vmul.f32	s15, s15, s14
    9160:	ed4b7a04 	vstr	s15, [fp, #-16]
    9164:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9168:	e5933000 	ldr	r3, [r3]
    916c:	e2432020 	sub	r2, r3, #32
    9170:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9174:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    9178:	ed5b7a04 	vldr	s15, [fp, #-16]
    917c:	ed9f7a91 	vldr	s14, [pc, #580]	; 93c8 <_Z11split_floatfRjS_Ri+0x42c>
    9180:	eef47ac7 	vcmpe.f32	s15, s14
    9184:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9188:	5a000008 	bpl	91b0 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    918c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9190:	ed9f7a81 	vldr	s14, [pc, #516]	; 939c <_Z11split_floatfRjS_Ri+0x400>
    9194:	ee677a87 	vmul.f32	s15, s15, s14
    9198:	ed4b7a04 	vstr	s15, [fp, #-16]
    919c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91a0:	e5933000 	ldr	r3, [r3]
    91a4:	e2432010 	sub	r2, r3, #16
    91a8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91ac:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    91b0:	ed5b7a04 	vldr	s15, [fp, #-16]
    91b4:	ed9f7a84 	vldr	s14, [pc, #528]	; 93cc <_Z11split_floatfRjS_Ri+0x430>
    91b8:	eef47ac7 	vcmpe.f32	s15, s14
    91bc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91c0:	5a000008 	bpl	91e8 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    91c4:	ed5b7a04 	vldr	s15, [fp, #-16]
    91c8:	ed9f7a75 	vldr	s14, [pc, #468]	; 93a4 <_Z11split_floatfRjS_Ri+0x408>
    91cc:	ee677a87 	vmul.f32	s15, s15, s14
    91d0:	ed4b7a04 	vstr	s15, [fp, #-16]
    91d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91d8:	e5933000 	ldr	r3, [r3]
    91dc:	e2432008 	sub	r2, r3, #8
    91e0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91e4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    91e8:	ed5b7a04 	vldr	s15, [fp, #-16]
    91ec:	ed9f7a77 	vldr	s14, [pc, #476]	; 93d0 <_Z11split_floatfRjS_Ri+0x434>
    91f0:	eef47ac7 	vcmpe.f32	s15, s14
    91f4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    91f8:	5a000008 	bpl	9220 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    91fc:	ed5b7a04 	vldr	s15, [fp, #-16]
    9200:	ed9f7a69 	vldr	s14, [pc, #420]	; 93ac <_Z11split_floatfRjS_Ri+0x410>
    9204:	ee677a87 	vmul.f32	s15, s15, s14
    9208:	ed4b7a04 	vstr	s15, [fp, #-16]
    920c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9210:	e5933000 	ldr	r3, [r3]
    9214:	e2432004 	sub	r2, r3, #4
    9218:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    921c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    9220:	ed5b7a04 	vldr	s15, [fp, #-16]
    9224:	ed9f7a64 	vldr	s14, [pc, #400]	; 93bc <_Z11split_floatfRjS_Ri+0x420>
    9228:	eef47ac7 	vcmpe.f32	s15, s14
    922c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9230:	5a000008 	bpl	9258 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    9234:	ed5b7a04 	vldr	s15, [fp, #-16]
    9238:	ed9f7a5d 	vldr	s14, [pc, #372]	; 93b4 <_Z11split_floatfRjS_Ri+0x418>
    923c:	ee677a87 	vmul.f32	s15, s15, s14
    9240:	ed4b7a04 	vstr	s15, [fp, #-16]
    9244:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9248:	e5933000 	ldr	r3, [r3]
    924c:	e2432002 	sub	r2, r3, #2
    9250:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9254:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    9258:	ed5b7a04 	vldr	s15, [fp, #-16]
    925c:	ed9f7a57 	vldr	s14, [pc, #348]	; 93c0 <_Z11split_floatfRjS_Ri+0x424>
    9260:	eef47ac7 	vcmpe.f32	s15, s14
    9264:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9268:	5a000008 	bpl	9290 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    926c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9270:	ed9f7a46 	vldr	s14, [pc, #280]	; 9390 <_Z11split_floatfRjS_Ri+0x3f4>
    9274:	ee677a87 	vmul.f32	s15, s15, s14
    9278:	ed4b7a04 	vstr	s15, [fp, #-16]
    927c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9280:	e5933000 	ldr	r3, [r3]
    9284:	e2432001 	sub	r2, r3, #1
    9288:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    928c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    9290:	ed5b7a04 	vldr	s15, [fp, #-16]
    9294:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9298:	ee172a90 	vmov	r2, s15
    929c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    92a0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    92a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    92a8:	e5933000 	ldr	r3, [r3]
    92ac:	ee073a90 	vmov	s15, r3
    92b0:	eef87a67 	vcvt.f32.u32	s15, s15
    92b4:	ed1b7a04 	vldr	s14, [fp, #-16]
    92b8:	ee777a67 	vsub.f32	s15, s14, s15
    92bc:	ed9f7a38 	vldr	s14, [pc, #224]	; 93a4 <_Z11split_floatfRjS_Ri+0x408>
    92c0:	ee677a87 	vmul.f32	s15, s15, s14
    92c4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    92c8:	ed5b7a02 	vldr	s15, [fp, #-8]
    92cc:	eefc7ae7 	vcvt.u32.f32	s15, s15
    92d0:	ee172a90 	vmov	r2, s15
    92d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92d8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    92dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92e0:	e5933000 	ldr	r3, [r3]
    92e4:	ee073a90 	vmov	s15, r3
    92e8:	eef87a67 	vcvt.f32.u32	s15, s15
    92ec:	ed1b7a02 	vldr	s14, [fp, #-8]
    92f0:	ee777a67 	vsub.f32	s15, s14, s15
    92f4:	ed9f7a36 	vldr	s14, [pc, #216]	; 93d4 <_Z11split_floatfRjS_Ri+0x438>
    92f8:	eef47ac7 	vcmpe.f32	s15, s14
    92fc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9300:	aa000000 	bge	9308 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    9304:	ea00001d 	b	9380 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    9308:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    930c:	e5933000 	ldr	r3, [r3]
    9310:	e2832001 	add	r2, r3, #1
    9314:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9318:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    931c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9320:	e5933000 	ldr	r3, [r3]
    9324:	e59f20ac 	ldr	r2, [pc, #172]	; 93d8 <_Z11split_floatfRjS_Ri+0x43c>
    9328:	e1530002 	cmp	r3, r2
    932c:	9a000013 	bls	9380 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    9330:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9334:	e3a02000 	mov	r2, #0
    9338:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    933c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9340:	e5933000 	ldr	r3, [r3]
    9344:	e2832001 	add	r2, r3, #1
    9348:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    934c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    9350:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9354:	e5933000 	ldr	r3, [r3]
    9358:	e3530009 	cmp	r3, #9
    935c:	9a000007 	bls	9380 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    9360:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9364:	e3a02001 	mov	r2, #1
    9368:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    936c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9370:	e5933000 	ldr	r3, [r3]
    9374:	e2832001 	add	r2, r3, #1
    9378:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    937c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    9380:	e320f000 	nop	{0}
    9384:	e28bd000 	add	sp, fp, #0
    9388:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    938c:	e12fff1e 	bx	lr
    9390:	41200000 			; <UNDEFINED> instruction: 0x41200000
    9394:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9398:	0a4fb11f 	beq	13f581c <__bss_end+0x13ebb5c>
    939c:	5a0e1bca 	bpl	3902cc <__bss_end+0x38660c>
    93a0:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    93a4:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    93a8:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    93ac:	461c4000 	ldrmi	r4, [ip], -r0
    93b0:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    93b4:	42c80000 	sbcmi	r0, r8, #0
    93b8:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    93bc:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    93c0:	3f800000 	svccc	0x00800000
    93c4:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    93c8:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    93cc:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    93d0:	3a83126f 	bcc	fe0cdd94 <__bss_end+0xfe0c40d4>
    93d4:	3f000000 	svccc	0x00000000
    93d8:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

000093dc <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    93dc:	e92d4800 	push	{fp, lr}
    93e0:	e28db004 	add	fp, sp, #4
    93e4:	e24dd018 	sub	sp, sp, #24
    93e8:	e50b0010 	str	r0, [fp, #-16]
    93ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    93f0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    93f4:	e3a03000 	mov	r3, #0
    93f8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    93fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9400:	e2432001 	sub	r2, r3, #1
    9404:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    9408:	e3530000 	cmp	r3, #0
    940c:	c3a03001 	movgt	r3, #1
    9410:	d3a03000 	movle	r3, #0
    9414:	e6ef3073 	uxtb	r3, r3
    9418:	e3530000 	cmp	r3, #0
    941c:	0a000018 	beq	9484 <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    9420:	e51b1010 	ldr	r1, [fp, #-16]
    9424:	e59f3080 	ldr	r3, [pc, #128]	; 94ac <_Z23decimal_to_string_floatjPci+0xd0>
    9428:	e0832193 	umull	r2, r3, r3, r1
    942c:	e1a021a3 	lsr	r2, r3, #3
    9430:	e1a03002 	mov	r3, r2
    9434:	e1a03103 	lsl	r3, r3, #2
    9438:	e0833002 	add	r3, r3, r2
    943c:	e1a03083 	lsl	r3, r3, #1
    9440:	e0412003 	sub	r2, r1, r3
    9444:	e6ef2072 	uxtb	r2, r2
    9448:	e51b3008 	ldr	r3, [fp, #-8]
    944c:	e2831001 	add	r1, r3, #1
    9450:	e50b1008 	str	r1, [fp, #-8]
    9454:	e1a01003 	mov	r1, r3
    9458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    945c:	e0833001 	add	r3, r3, r1
    9460:	e2822030 	add	r2, r2, #48	; 0x30
    9464:	e6ef2072 	uxtb	r2, r2
    9468:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    946c:	e51b3010 	ldr	r3, [fp, #-16]
    9470:	e59f2034 	ldr	r2, [pc, #52]	; 94ac <_Z23decimal_to_string_floatjPci+0xd0>
    9474:	e0832392 	umull	r2, r3, r2, r3
    9478:	e1a031a3 	lsr	r3, r3, #3
    947c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9480:	eaffffdd 	b	93fc <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    9484:	e51b3008 	ldr	r3, [fp, #-8]
    9488:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    948c:	e0823003 	add	r3, r2, r3
    9490:	e3a02000 	mov	r2, #0
    9494:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9498:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    949c:	ebfffe8d 	bl	8ed8 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    94a0:	e320f000 	nop	{0}
    94a4:	e24bd004 	sub	sp, fp, #4
    94a8:	e8bd8800 	pop	{fp, pc}
    94ac:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000094b0 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    94b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    94b4:	e28db000 	add	fp, sp, #0
    94b8:	e24dd00c 	sub	sp, sp, #12
    94bc:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    94c0:	ed1b7a02 	vldr	s14, [fp, #-8]
    94c4:	ed5b7a02 	vldr	s15, [fp, #-8]
    94c8:	eeb47a67 	vcmp.f32	s14, s15
    94cc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    94d0:	13a03001 	movne	r3, #1
    94d4:	03a03000 	moveq	r3, #0
    94d8:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    94dc:	e1a00003 	mov	r0, r3
    94e0:	e28bd000 	add	sp, fp, #0
    94e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    94e8:	e12fff1e 	bx	lr

000094ec <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    94ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    94f0:	e28db000 	add	fp, sp, #0
    94f4:	e24dd00c 	sub	sp, sp, #12
    94f8:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    94fc:	ed5b7a02 	vldr	s15, [fp, #-8]
    9500:	ed9f7a08 	vldr	s14, [pc, #32]	; 9528 <_Z5isinff+0x3c>
    9504:	eef47ac7 	vcmpe.f32	s15, s14
    9508:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    950c:	c3a03001 	movgt	r3, #1
    9510:	d3a03000 	movle	r3, #0
    9514:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    9518:	e1a00003 	mov	r0, r3
    951c:	e28bd000 	add	sp, fp, #0
    9520:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9524:	e12fff1e 	bx	lr
    9528:	7f7fffff 	svcvc	0x007fffff

0000952c <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    952c:	e92d4800 	push	{fp, lr}
    9530:	e28db004 	add	fp, sp, #4
    9534:	e24dd008 	sub	sp, sp, #8
    9538:	ed0b0a02 	vstr	s0, [fp, #-8]
    953c:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    9540:	e3a01008 	mov	r1, #8
    9544:	e51b000c 	ldr	r0, [fp, #-12]
    9548:	ed1b0a02 	vldr	s0, [fp, #-8]
    954c:	eb000002 	bl	955c <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    9550:	e320f000 	nop	{0}
    9554:	e24bd004 	sub	sp, fp, #4
    9558:	e8bd8800 	pop	{fp, pc}

0000955c <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    955c:	e92d4800 	push	{fp, lr}
    9560:	e28db004 	add	fp, sp, #4
    9564:	e24dd060 	sub	sp, sp, #96	; 0x60
    9568:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    956c:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    9570:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    9574:	e3a03000 	mov	r3, #0
    9578:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    957c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9580:	eef57ac0 	vcmpe.f32	s15, #0.0
    9584:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9588:	5a000009 	bpl	95b4 <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    958c:	e51b3008 	ldr	r3, [fp, #-8]
    9590:	e2832001 	add	r2, r3, #1
    9594:	e50b2008 	str	r2, [fp, #-8]
    9598:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    959c:	e0823003 	add	r3, r2, r3
    95a0:	e3a0202d 	mov	r2, #45	; 0x2d
    95a4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    95a8:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    95ac:	eef17a67 	vneg.f32	s15, s15
    95b0:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    95b4:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    95b8:	ebffffbc 	bl	94b0 <_Z5isnanf>
    95bc:	e1a03000 	mov	r3, r0
    95c0:	e3530000 	cmp	r3, #0
    95c4:	0a00001c 	beq	963c <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    95c8:	e51b3008 	ldr	r3, [fp, #-8]
    95cc:	e2832001 	add	r2, r3, #1
    95d0:	e50b2008 	str	r2, [fp, #-8]
    95d4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    95d8:	e0823003 	add	r3, r2, r3
    95dc:	e3a0204e 	mov	r2, #78	; 0x4e
    95e0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    95e4:	e51b3008 	ldr	r3, [fp, #-8]
    95e8:	e2832001 	add	r2, r3, #1
    95ec:	e50b2008 	str	r2, [fp, #-8]
    95f0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    95f4:	e0823003 	add	r3, r2, r3
    95f8:	e3a02061 	mov	r2, #97	; 0x61
    95fc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    9600:	e51b3008 	ldr	r3, [fp, #-8]
    9604:	e2832001 	add	r2, r3, #1
    9608:	e50b2008 	str	r2, [fp, #-8]
    960c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9610:	e0823003 	add	r3, r2, r3
    9614:	e3a0204e 	mov	r2, #78	; 0x4e
    9618:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    961c:	e51b3008 	ldr	r3, [fp, #-8]
    9620:	e2832001 	add	r2, r3, #1
    9624:	e50b2008 	str	r2, [fp, #-8]
    9628:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    962c:	e0823003 	add	r3, r2, r3
    9630:	e3a02000 	mov	r2, #0
    9634:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    9638:	ea00008c 	b	9870 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    963c:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9640:	ebffffa9 	bl	94ec <_Z5isinff>
    9644:	e1a03000 	mov	r3, r0
    9648:	e3530000 	cmp	r3, #0
    964c:	0a00001c 	beq	96c4 <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    9650:	e51b3008 	ldr	r3, [fp, #-8]
    9654:	e2832001 	add	r2, r3, #1
    9658:	e50b2008 	str	r2, [fp, #-8]
    965c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9660:	e0823003 	add	r3, r2, r3
    9664:	e3a02049 	mov	r2, #73	; 0x49
    9668:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    966c:	e51b3008 	ldr	r3, [fp, #-8]
    9670:	e2832001 	add	r2, r3, #1
    9674:	e50b2008 	str	r2, [fp, #-8]
    9678:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    967c:	e0823003 	add	r3, r2, r3
    9680:	e3a0206e 	mov	r2, #110	; 0x6e
    9684:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    9688:	e51b3008 	ldr	r3, [fp, #-8]
    968c:	e2832001 	add	r2, r3, #1
    9690:	e50b2008 	str	r2, [fp, #-8]
    9694:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9698:	e0823003 	add	r3, r2, r3
    969c:	e3a02066 	mov	r2, #102	; 0x66
    96a0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    96a4:	e51b3008 	ldr	r3, [fp, #-8]
    96a8:	e2832001 	add	r2, r3, #1
    96ac:	e50b2008 	str	r2, [fp, #-8]
    96b0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    96b4:	e0823003 	add	r3, r2, r3
    96b8:	e3a02000 	mov	r2, #0
    96bc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    96c0:	ea00006a 	b	9870 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    96c4:	e3a03008 	mov	r3, #8
    96c8:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    96cc:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    96d0:	e3530007 	cmp	r3, #7
    96d4:	8a000001 	bhi	96e0 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    96d8:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    96dc:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    96e0:	e51b300c 	ldr	r3, [fp, #-12]
    96e4:	e1a00003 	mov	r0, r3
    96e8:	ed9f0a62 	vldr	s0, [pc, #392]	; 9878 <_Z4ftoafPcj+0x31c>
    96ec:	ebfffdde 	bl	8e6c <_Z3powfj>
    96f0:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    96f4:	eddf6a60 	vldr	s13, [pc, #384]	; 987c <_Z4ftoafPcj+0x320>
    96f8:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    96fc:	eec67a87 	vdiv.f32	s15, s13, s14
    9700:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9704:	ee777a27 	vadd.f32	s15, s14, s15
    9708:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    970c:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9710:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9714:	ee173a90 	vmov	r3, s15
    9718:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    971c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9720:	ee073a90 	vmov	s15, r3
    9724:	eef87a67 	vcvt.f32.u32	s15, s15
    9728:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    972c:	ee377a67 	vsub.f32	s14, s14, s15
    9730:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    9734:	ee677a27 	vmul.f32	s15, s14, s15
    9738:	eefc7ae7 	vcvt.u32.f32	s15, s15
    973c:	ee173a90 	vmov	r3, s15
    9740:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    9744:	e24b3044 	sub	r3, fp, #68	; 0x44
    9748:	e3a0200a 	mov	r2, #10
    974c:	e1a01003 	mov	r1, r3
    9750:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    9754:	ebfffc96 	bl	89b4 <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    9758:	e24b3044 	sub	r3, fp, #68	; 0x44
    975c:	e1a00003 	mov	r0, r3
    9760:	ebfffd72 	bl	8d30 <_Z6strlenPKc>
    9764:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    9768:	e3a03000 	mov	r3, #0
    976c:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    9770:	e51b2010 	ldr	r2, [fp, #-16]
    9774:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9778:	e1520003 	cmp	r2, r3
    977c:	aa00000d 	bge	97b8 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    9780:	e51b3008 	ldr	r3, [fp, #-8]
    9784:	e2832001 	add	r2, r3, #1
    9788:	e50b2008 	str	r2, [fp, #-8]
    978c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9790:	e0823003 	add	r3, r2, r3
    9794:	e24b1044 	sub	r1, fp, #68	; 0x44
    9798:	e51b2010 	ldr	r2, [fp, #-16]
    979c:	e0812002 	add	r2, r1, r2
    97a0:	e5d22000 	ldrb	r2, [r2]
    97a4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    97a8:	e51b3010 	ldr	r3, [fp, #-16]
    97ac:	e2833001 	add	r3, r3, #1
    97b0:	e50b3010 	str	r3, [fp, #-16]
    97b4:	eaffffed 	b	9770 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    97b8:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    97bc:	e3530000 	cmp	r3, #0
    97c0:	0a000025 	beq	985c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    97c4:	e51b3008 	ldr	r3, [fp, #-8]
    97c8:	e2832001 	add	r2, r3, #1
    97cc:	e50b2008 	str	r2, [fp, #-8]
    97d0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    97d4:	e0823003 	add	r3, r2, r3
    97d8:	e3a0202e 	mov	r2, #46	; 0x2e
    97dc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    97e0:	e24b3050 	sub	r3, fp, #80	; 0x50
    97e4:	e51b200c 	ldr	r2, [fp, #-12]
    97e8:	e1a01003 	mov	r1, r3
    97ec:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    97f0:	ebfffef9 	bl	93dc <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    97f4:	e3a03000 	mov	r3, #0
    97f8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    97fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9800:	e3530008 	cmp	r3, #8
    9804:	ca000014 	bgt	985c <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    9808:	e24b2050 	sub	r2, fp, #80	; 0x50
    980c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9810:	e0823003 	add	r3, r2, r3
    9814:	e5d33000 	ldrb	r3, [r3]
    9818:	e3530000 	cmp	r3, #0
    981c:	0a00000d 	beq	9858 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    9820:	e51b3008 	ldr	r3, [fp, #-8]
    9824:	e2832001 	add	r2, r3, #1
    9828:	e50b2008 	str	r2, [fp, #-8]
    982c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9830:	e0823003 	add	r3, r2, r3
    9834:	e24b1050 	sub	r1, fp, #80	; 0x50
    9838:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    983c:	e0812002 	add	r2, r1, r2
    9840:	e5d22000 	ldrb	r2, [r2]
    9844:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    9848:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    984c:	e2833001 	add	r3, r3, #1
    9850:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    9854:	eaffffe8 	b	97fc <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    9858:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    985c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9860:	e51b3008 	ldr	r3, [fp, #-8]
    9864:	e0823003 	add	r3, r2, r3
    9868:	e3a02000 	mov	r2, #0
    986c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    9870:	e24bd004 	sub	sp, fp, #4
    9874:	e8bd8800 	pop	{fp, pc}
    9878:	41200000 			; <UNDEFINED> instruction: 0x41200000
    987c:	3f000000 	svccc	0x00000000

00009880 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    9880:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9884:	e28db000 	add	fp, sp, #0
    9888:	e24dd01c 	sub	sp, sp, #28
    988c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    9890:	e3a03000 	mov	r3, #0
    9894:	e50b3008 	str	r3, [fp, #-8]
    9898:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    989c:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    98a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    98a4:	e5d33000 	ldrb	r3, [r3]
    98a8:	e353002d 	cmp	r3, #45	; 0x2d
    98ac:	1a000004 	bne	98c4 <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    98b0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    98b4:	e2833001 	add	r3, r3, #1
    98b8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    98bc:	e59f30c8 	ldr	r3, [pc, #200]	; 998c <_Z4atofPKc+0x10c>
    98c0:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    98c4:	e3a03000 	mov	r3, #0
    98c8:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    98cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    98d0:	e5d33000 	ldrb	r3, [r3]
    98d4:	e3530000 	cmp	r3, #0
    98d8:	0a000023 	beq	996c <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    98dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    98e0:	e5d33000 	ldrb	r3, [r3]
    98e4:	e353002e 	cmp	r3, #46	; 0x2e
    98e8:	1a000002 	bne	98f8 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    98ec:	e3a03001 	mov	r3, #1
    98f0:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    98f4:	ea000018 	b	995c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    98f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    98fc:	e5d33000 	ldrb	r3, [r3]
    9900:	e2433030 	sub	r3, r3, #48	; 0x30
    9904:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    9908:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    990c:	e3530000 	cmp	r3, #0
    9910:	ba000011 	blt	995c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    9914:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9918:	e3530009 	cmp	r3, #9
    991c:	ca00000e 	bgt	995c <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    9920:	e51b3010 	ldr	r3, [fp, #-16]
    9924:	e3530000 	cmp	r3, #0
    9928:	0a000003 	beq	993c <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    992c:	ed1b7a03 	vldr	s14, [fp, #-12]
    9930:	eddf6a14 	vldr	s13, [pc, #80]	; 9988 <_Z4atofPKc+0x108>
    9934:	eec77a26 	vdiv.f32	s15, s14, s13
    9938:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    993c:	ed5b7a02 	vldr	s15, [fp, #-8]
    9940:	ed9f7a10 	vldr	s14, [pc, #64]	; 9988 <_Z4atofPKc+0x108>
    9944:	ee277a87 	vmul.f32	s14, s15, s14
    9948:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    994c:	ee073a90 	vmov	s15, r3
    9950:	eef87ae7 	vcvt.f32.s32	s15, s15
    9954:	ee777a27 	vadd.f32	s15, s14, s15
    9958:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    995c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9960:	e2833001 	add	r3, r3, #1
    9964:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9968:	eaffffd7 	b	98cc <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    996c:	ed1b7a02 	vldr	s14, [fp, #-8]
    9970:	ed5b7a03 	vldr	s15, [fp, #-12]
    9974:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    9978:	eeb00a67 	vmov.f32	s0, s15
    997c:	e28bd000 	add	sp, fp, #0
    9980:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9984:	e12fff1e 	bx	lr
    9988:	41200000 			; <UNDEFINED> instruction: 0x41200000
    998c:	bf800000 	svclt	0x00800000

00009990 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9990:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9994:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9998:	3a000074 	bcc	9b70 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    999c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    99a0:	9a00006b 	bls	9b54 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    99a4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    99a8:	0a00006c 	beq	9b60 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    99ac:	e16f3f10 	clz	r3, r0
    99b0:	e16f2f11 	clz	r2, r1
    99b4:	e0423003 	sub	r3, r2, r3
    99b8:	e273301f 	rsbs	r3, r3, #31
    99bc:	10833083 	addne	r3, r3, r3, lsl #1
    99c0:	e3a02000 	mov	r2, #0
    99c4:	108ff103 	addne	pc, pc, r3, lsl #2
    99c8:	e1a00000 	nop			; (mov r0, r0)
    99cc:	e1500f81 	cmp	r0, r1, lsl #31
    99d0:	e0a22002 	adc	r2, r2, r2
    99d4:	20400f81 	subcs	r0, r0, r1, lsl #31
    99d8:	e1500f01 	cmp	r0, r1, lsl #30
    99dc:	e0a22002 	adc	r2, r2, r2
    99e0:	20400f01 	subcs	r0, r0, r1, lsl #30
    99e4:	e1500e81 	cmp	r0, r1, lsl #29
    99e8:	e0a22002 	adc	r2, r2, r2
    99ec:	20400e81 	subcs	r0, r0, r1, lsl #29
    99f0:	e1500e01 	cmp	r0, r1, lsl #28
    99f4:	e0a22002 	adc	r2, r2, r2
    99f8:	20400e01 	subcs	r0, r0, r1, lsl #28
    99fc:	e1500d81 	cmp	r0, r1, lsl #27
    9a00:	e0a22002 	adc	r2, r2, r2
    9a04:	20400d81 	subcs	r0, r0, r1, lsl #27
    9a08:	e1500d01 	cmp	r0, r1, lsl #26
    9a0c:	e0a22002 	adc	r2, r2, r2
    9a10:	20400d01 	subcs	r0, r0, r1, lsl #26
    9a14:	e1500c81 	cmp	r0, r1, lsl #25
    9a18:	e0a22002 	adc	r2, r2, r2
    9a1c:	20400c81 	subcs	r0, r0, r1, lsl #25
    9a20:	e1500c01 	cmp	r0, r1, lsl #24
    9a24:	e0a22002 	adc	r2, r2, r2
    9a28:	20400c01 	subcs	r0, r0, r1, lsl #24
    9a2c:	e1500b81 	cmp	r0, r1, lsl #23
    9a30:	e0a22002 	adc	r2, r2, r2
    9a34:	20400b81 	subcs	r0, r0, r1, lsl #23
    9a38:	e1500b01 	cmp	r0, r1, lsl #22
    9a3c:	e0a22002 	adc	r2, r2, r2
    9a40:	20400b01 	subcs	r0, r0, r1, lsl #22
    9a44:	e1500a81 	cmp	r0, r1, lsl #21
    9a48:	e0a22002 	adc	r2, r2, r2
    9a4c:	20400a81 	subcs	r0, r0, r1, lsl #21
    9a50:	e1500a01 	cmp	r0, r1, lsl #20
    9a54:	e0a22002 	adc	r2, r2, r2
    9a58:	20400a01 	subcs	r0, r0, r1, lsl #20
    9a5c:	e1500981 	cmp	r0, r1, lsl #19
    9a60:	e0a22002 	adc	r2, r2, r2
    9a64:	20400981 	subcs	r0, r0, r1, lsl #19
    9a68:	e1500901 	cmp	r0, r1, lsl #18
    9a6c:	e0a22002 	adc	r2, r2, r2
    9a70:	20400901 	subcs	r0, r0, r1, lsl #18
    9a74:	e1500881 	cmp	r0, r1, lsl #17
    9a78:	e0a22002 	adc	r2, r2, r2
    9a7c:	20400881 	subcs	r0, r0, r1, lsl #17
    9a80:	e1500801 	cmp	r0, r1, lsl #16
    9a84:	e0a22002 	adc	r2, r2, r2
    9a88:	20400801 	subcs	r0, r0, r1, lsl #16
    9a8c:	e1500781 	cmp	r0, r1, lsl #15
    9a90:	e0a22002 	adc	r2, r2, r2
    9a94:	20400781 	subcs	r0, r0, r1, lsl #15
    9a98:	e1500701 	cmp	r0, r1, lsl #14
    9a9c:	e0a22002 	adc	r2, r2, r2
    9aa0:	20400701 	subcs	r0, r0, r1, lsl #14
    9aa4:	e1500681 	cmp	r0, r1, lsl #13
    9aa8:	e0a22002 	adc	r2, r2, r2
    9aac:	20400681 	subcs	r0, r0, r1, lsl #13
    9ab0:	e1500601 	cmp	r0, r1, lsl #12
    9ab4:	e0a22002 	adc	r2, r2, r2
    9ab8:	20400601 	subcs	r0, r0, r1, lsl #12
    9abc:	e1500581 	cmp	r0, r1, lsl #11
    9ac0:	e0a22002 	adc	r2, r2, r2
    9ac4:	20400581 	subcs	r0, r0, r1, lsl #11
    9ac8:	e1500501 	cmp	r0, r1, lsl #10
    9acc:	e0a22002 	adc	r2, r2, r2
    9ad0:	20400501 	subcs	r0, r0, r1, lsl #10
    9ad4:	e1500481 	cmp	r0, r1, lsl #9
    9ad8:	e0a22002 	adc	r2, r2, r2
    9adc:	20400481 	subcs	r0, r0, r1, lsl #9
    9ae0:	e1500401 	cmp	r0, r1, lsl #8
    9ae4:	e0a22002 	adc	r2, r2, r2
    9ae8:	20400401 	subcs	r0, r0, r1, lsl #8
    9aec:	e1500381 	cmp	r0, r1, lsl #7
    9af0:	e0a22002 	adc	r2, r2, r2
    9af4:	20400381 	subcs	r0, r0, r1, lsl #7
    9af8:	e1500301 	cmp	r0, r1, lsl #6
    9afc:	e0a22002 	adc	r2, r2, r2
    9b00:	20400301 	subcs	r0, r0, r1, lsl #6
    9b04:	e1500281 	cmp	r0, r1, lsl #5
    9b08:	e0a22002 	adc	r2, r2, r2
    9b0c:	20400281 	subcs	r0, r0, r1, lsl #5
    9b10:	e1500201 	cmp	r0, r1, lsl #4
    9b14:	e0a22002 	adc	r2, r2, r2
    9b18:	20400201 	subcs	r0, r0, r1, lsl #4
    9b1c:	e1500181 	cmp	r0, r1, lsl #3
    9b20:	e0a22002 	adc	r2, r2, r2
    9b24:	20400181 	subcs	r0, r0, r1, lsl #3
    9b28:	e1500101 	cmp	r0, r1, lsl #2
    9b2c:	e0a22002 	adc	r2, r2, r2
    9b30:	20400101 	subcs	r0, r0, r1, lsl #2
    9b34:	e1500081 	cmp	r0, r1, lsl #1
    9b38:	e0a22002 	adc	r2, r2, r2
    9b3c:	20400081 	subcs	r0, r0, r1, lsl #1
    9b40:	e1500001 	cmp	r0, r1
    9b44:	e0a22002 	adc	r2, r2, r2
    9b48:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    9b4c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    9b50:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    9b54:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    9b58:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    9b5c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    9b60:	e16f2f11 	clz	r2, r1
    9b64:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    9b68:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    9b6c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    9b70:	e3500000 	cmp	r0, #0
    9b74:	13e00000 	mvnne	r0, #0
    9b78:	ea000007 	b	9b9c <__aeabi_idiv0>

00009b7c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9b7c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9b80:	0afffffa 	beq	9b70 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9b84:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9b88:	ebffff80 	bl	9990 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    9b8c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9b90:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9b94:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9b98:	e12fff1e 	bx	lr

00009b9c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9b9c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009ba0 <_ZL8INFINITY>:
    9ba0:	7f7fffff 	svcvc	0x007fffff

00009ba4 <_ZL13Lock_Unlocked>:
    9ba4:	00000000 	andeq	r0, r0, r0

00009ba8 <_ZL11Lock_Locked>:
    9ba8:	00000001 	andeq	r0, r0, r1

00009bac <_ZL21MaxFSDriverNameLength>:
    9bac:	00000010 	andeq	r0, r0, r0, lsl r0

00009bb0 <_ZL17MaxFilenameLength>:
    9bb0:	00000010 	andeq	r0, r0, r0, lsl r0

00009bb4 <_ZL13MaxPathLength>:
    9bb4:	00000080 	andeq	r0, r0, r0, lsl #1

00009bb8 <_ZL18NoFilesystemDriver>:
    9bb8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bbc <_ZL9NotifyAll>:
    9bbc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bc0 <_ZL24Max_Process_Opened_Files>:
    9bc0:	00000010 	andeq	r0, r0, r0, lsl r0

00009bc4 <_ZL10Indefinite>:
    9bc4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009bc8 <_ZL18Deadline_Unchanged>:
    9bc8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009bcc <_ZL14Invalid_Handle>:
    9bcc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9bd0:	3a564544 	bcc	159b0e8 <__bss_end+0x1591428>
    9bd4:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    9bd8:	0000302f 	andeq	r3, r0, pc, lsr #32
    9bdc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    9be0:	73617420 	cmnvc	r1, #32, 8	; 0x20000000
    9be4:	7473206b 	ldrbtvc	r2, [r3], #-107	; 0xffffff95
    9be8:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
    9bec:	0021676e 	eoreq	r6, r1, lr, ror #14
    9bf0:	45530a0d 	ldrbmi	r0, [r3, #-2573]	; 0xfffff5f3
    9bf4:	4e49444e 	cdpmi	4, 4, cr4, cr9, cr14, {2}
    9bf8:	4c462047 	mcrrmi	0, 4, r2, r6, cr7
    9bfc:	2154414f 	cmpcs	r4, pc, asr #2
    9c00:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9c04:	45530a0d 	ldrbmi	r0, [r3, #-2573]	; 0xfffff5f3
    9c08:	4620544e 	strtmi	r5, [r0], -lr, asr #8
    9c0c:	54414f4c 	strbpl	r4, [r1], #-3916	; 0xfffff0b4
    9c10:	000a0d21 	andeq	r0, sl, r1, lsr #26
    9c14:	45434552 	strbmi	r4, [r3, #-1362]	; 0xfffffaae
    9c18:	44455649 	strbmi	r5, [r5], #-1609	; 0xfffff9b7
    9c1c:	54414420 	strbpl	r4, [r1], #-1056	; 0xfffffbe0
    9c20:	0a0d2141 	beq	35212c <__bss_end+0x34846c>
    9c24:	00000000 	andeq	r0, r0, r0
    9c28:	0000005b 	andeq	r0, r0, fp, asr r0
    9c2c:	00203a5d 	eoreq	r3, r0, sp, asr sl
    9c30:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9c34:	52414843 	subpl	r4, r1, #4390912	; 0x430000
    9c38:	0000005b 	andeq	r0, r0, fp, asr r0
    9c3c:	000a0d5d 	andeq	r0, sl, sp, asr sp
    9c40:	54494157 	strbpl	r4, [r9], #-343	; 0xfffffea9
    9c44:	4c414320 	mcrrmi	3, 2, r4, r1, cr0
    9c48:	2144454c 	cmpcs	r4, ip, asr #10
    9c4c:	00000a0d 	andeq	r0, r0, sp, lsl #20
    9c50:	454b4f57 	strbmi	r4, [fp, #-3927]	; 0xfffff0a9
    9c54:	21505520 	cmpcs	r0, r0, lsr #10
    9c58:	00000a0d 	andeq	r0, r0, sp, lsl #20

00009c5c <_ZL13Lock_Unlocked>:
    9c5c:	00000000 	andeq	r0, r0, r0

00009c60 <_ZL11Lock_Locked>:
    9c60:	00000001 	andeq	r0, r0, r1

00009c64 <_ZL21MaxFSDriverNameLength>:
    9c64:	00000010 	andeq	r0, r0, r0, lsl r0

00009c68 <_ZL17MaxFilenameLength>:
    9c68:	00000010 	andeq	r0, r0, r0, lsl r0

00009c6c <_ZL13MaxPathLength>:
    9c6c:	00000080 	andeq	r0, r0, r0, lsl #1

00009c70 <_ZL18NoFilesystemDriver>:
    9c70:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c74 <_ZL9NotifyAll>:
    9c74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c78 <_ZL24Max_Process_Opened_Files>:
    9c78:	00000010 	andeq	r0, r0, r0, lsl r0

00009c7c <_ZL10Indefinite>:
    9c7c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c80 <_ZL18Deadline_Unchanged>:
    9c80:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009c84 <_ZL14Invalid_Handle>:
    9c84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c88 <_ZL8INFINITY>:
    9c88:	7f7fffff 	svcvc	0x007fffff

00009c8c <_ZL16Pipe_File_Prefix>:
    9c8c:	3a535953 	bcc	14e01e0 <__bss_end+0x14d6520>
    9c90:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9c94:	0000002f 	andeq	r0, r0, pc, lsr #32

00009c98 <_ZL8INFINITY>:
    9c98:	7f7fffff 	svcvc	0x007fffff

00009c9c <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9c9c:	33323130 	teqcc	r2, #48, 2
    9ca0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9ca4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9ca8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009cb0 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683b6c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38764>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c378>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7064>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcf97c>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36c46>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff610f>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x1570d8>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb74e0>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x77514>
 1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1d0:	01058509 	tsteq	r5, r9, lsl #10
 1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
 1d8:	02cc0101 	sbceq	r0, ip, #1073741824	; 0x40000000
 1dc:	00030000 	andeq	r0, r3, r0
 1e0:	00000224 	andeq	r0, r0, r4, lsr #4
 1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 1e8:	0101000d 	tsteq	r1, sp
 1ec:	00000101 	andeq	r0, r0, r1, lsl #2
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	6f682f01 	svcvs	0x00682f01
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfaf4>
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
 244:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff1d <__bss_end+0xffff625d>
 248:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 24c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 250:	61707372 	cmnvs	r0, r2, ror r3
 254:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 258:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 25c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 260:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 264:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 268:	6f72702f 	svcvs	0x0072702f
 26c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 270:	6f682f00 	svcvs	0x00682f00
 274:	6a2f656d 	bvs	bd9830 <__bss_end+0xbcfb70>
 278:	73656d61 	cmnvc	r5, #6208	; 0x1840
 27c:	2f697261 	svccs	0x00697261
 280:	2f746967 	svccs	0x00746967
 284:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 288:	6f732f70 	svcvs	0x00732f70
 28c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 290:	73752f73 	cmnvc	r5, #460	; 0x1cc
 294:	70737265 	rsbsvc	r7, r3, r5, ror #4
 298:	2f656361 	svccs	0x00656361
 29c:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
 2a0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 2a4:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 2a8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2ac:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 2b0:	2f656d6f 	svccs	0x00656d6f
 2b4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2b8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2bc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 2c0:	2f736f2f 	svccs	0x00736f2f
 2c4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2c8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2cc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff6f <__bss_end+0xffff62af>
 2d0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2d4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2d8:	2f2e2e2f 	svccs	0x002e2e2f
 2dc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2e0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2e4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2e8:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 2ec:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 2f0:	2f656d6f 	svccs	0x00656d6f
 2f4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2f8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2fc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 300:	2f736f2f 	svccs	0x00736f2f
 304:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 308:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 30c:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffaf <__bss_end+0xffff62ef>
 310:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 314:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 318:	2f2e2e2f 	svccs	0x002e2e2f
 31c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 320:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 324:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 328:	642f6564 	strtvs	r6, [pc], #-1380	; 330 <shift+0x330>
 32c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 330:	622f7372 	eorvs	r7, pc, #-939524095	; 0xc8000001
 334:	67646972 			; <UNDEFINED> instruction: 0x67646972
 338:	2f007365 	svccs	0x00007365
 33c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 340:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 344:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 348:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 34c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 350:	2f70732f 	svccs	0x0070732f
 354:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 358:	2f736563 	svccs	0x00736563
 35c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 360:	63617073 	cmnvs	r1, #115	; 0x73
 364:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 368:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 36c:	2f6c656e 	svccs	0x006c656e
 370:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 374:	2f656475 	svccs	0x00656475
 378:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 37c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 380:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 384:	00006c61 	andeq	r6, r0, r1, ror #24
 388:	6e69616d 	powvsez	f6, f1, #5.0
 38c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 390:	00000100 	andeq	r0, r0, r0, lsl #2
 394:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 398:	00020068 	andeq	r0, r2, r8, rrx
 39c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 3a0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 3a4:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 3a8:	00000300 	andeq	r0, r0, r0, lsl #6
 3ac:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 3b0:	6b636f6c 	blvs	18dc168 <__bss_end+0x18d24a8>
 3b4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3b8:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 3bc:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 3c0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 3c4:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 3c8:	72700000 	rsbsvc	r0, r0, #0
 3cc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 3d0:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3d4:	70000002 	andvc	r0, r0, r2
 3d8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3dc:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 218 <shift+0x218>
 3e0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 3e4:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 3e8:	00000200 	andeq	r0, r0, r0, lsl #4
 3ec:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
 3f0:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
 3f4:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3f8:	69000005 	stmdbvs	r0, {r0, r2}
 3fc:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 400:	00682e66 	rsbeq	r2, r8, r6, ror #28
 404:	00000006 	andeq	r0, r0, r6
 408:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 40c:	00822c02 	addeq	r2, r2, r2, lsl #24
 410:	010d0300 	mrseq	r0, SP_mon
 414:	059f1c05 	ldreq	r1, [pc, #3077]	; 1021 <shift+0x1021>
 418:	01056607 	tsteq	r5, r7, lsl #12
 41c:	0d056983 	vstreq.16	s12, [r5, #-262]	; 0xfffffefa	; <UNPREDICTABLE>
 420:	9f0105bb 	svcls	0x000105bb
 424:	9f1b0569 	svcls	0x001b0569
 428:	05851305 	streq	r1, [r5, #773]	; 0x305
 42c:	07054b15 	smladeq	r5, r5, fp, r4
 430:	bb6aa04b 	bllt	1aa8564 <__bss_end+0x1a9e8a4>
 434:	05bc0805 	ldreq	r0, [ip, #2053]!	; 0x805
 438:	06054c07 	streq	r4, [r5], -r7, lsl #24
 43c:	bb0705bb 	bllt	1c1b30 <__bss_end+0x1b7e70>
 440:	1505bb67 	strne	fp, [r5, #-2919]	; 0xfffff499
 444:	f403056b 	vst3.16	{d0,d2,d4}, [r3 :128], fp
 448:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
 44c:	19054b04 	stmdbne	r5, {r2, r8, r9, fp, lr}
 450:	01040200 	mrseq	r0, R12_usr
 454:	d8080566 	stmdale	r8, {r1, r2, r5, r6, r8, sl}
 458:	67d70905 	ldrbvs	r0, [r7, r5, lsl #18]
 45c:	bb67bb67 	bllt	19ef200 <__bss_end+0x19e5540>
 460:	05681205 	strbeq	r1, [r8, #-517]!	; 0xfffffdfb
 464:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 468:	1d054a03 	vstrne	s8, [r5, #-12]
 46c:	02040200 	andeq	r0, r4, #0, 4
 470:	00090584 	andeq	r0, r9, r4, lsl #11
 474:	ba020402 	blt	81484 <__bss_end+0x777c4>
 478:	02040200 	andeq	r0, r4, #0, 4
 47c:	000a052f 	andeq	r0, sl, pc, lsr #10
 480:	d7020402 	strle	r0, [r2, -r2, lsl #8]
 484:	02040200 	andeq	r0, r4, #0, 4
 488:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 48c:	0405bb02 	streq	fp, [r5], #-2818	; 0xfffff4fe
 490:	02040200 	andeq	r0, r4, #0, 4
 494:	05667a03 	strbeq	r7, [r6, #-2563]!	; 0xfffff5fd
 498:	82090309 	andhi	r0, r9, #603979776	; 0x24000000
 49c:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
 4a0:	02058309 	andeq	r8, r5, #603979776	; 0x24000000
 4a4:	001e0268 	andseq	r0, lr, r8, ror #4
 4a8:	02bf0101 	adcseq	r0, pc, #1073741824	; 0x40000000
 4ac:	00030000 	andeq	r0, r3, r0
 4b0:	0000018c 	andeq	r0, r0, ip, lsl #3
 4b4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 4b8:	0101000d 	tsteq	r1, sp
 4bc:	00000101 	andeq	r0, r0, r1, lsl #2
 4c0:	00000100 	andeq	r0, r0, r0, lsl #2
 4c4:	6f682f01 	svcvs	0x00682f01
 4c8:	6a2f656d 	bvs	bd9a84 <__bss_end+0xbcfdc4>
 4cc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 4d0:	2f697261 	svccs	0x00697261
 4d4:	2f746967 	svccs	0x00746967
 4d8:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 4dc:	6f732f70 	svcvs	0x00732f70
 4e0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 4e4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 4e8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 4ec:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 4f0:	6f682f00 	svcvs	0x00682f00
 4f4:	6a2f656d 	bvs	bd9ab0 <__bss_end+0xbcfdf0>
 4f8:	73656d61 	cmnvc	r5, #6208	; 0x1840
 4fc:	2f697261 	svccs	0x00697261
 500:	2f746967 	svccs	0x00746967
 504:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 508:	6f732f70 	svcvs	0x00732f70
 50c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 510:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 514:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 518:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 51c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 520:	6f72702f 	svcvs	0x0072702f
 524:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 528:	6f682f00 	svcvs	0x00682f00
 52c:	6a2f656d 	bvs	bd9ae8 <__bss_end+0xbcfe28>
 530:	73656d61 	cmnvc	r5, #6208	; 0x1840
 534:	2f697261 	svccs	0x00697261
 538:	2f746967 	svccs	0x00746967
 53c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 540:	6f732f70 	svcvs	0x00732f70
 544:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 548:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 54c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 550:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 554:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 558:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 55c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4a8 <shift+0x4a8>
 560:	616a2f65 	cmnvs	sl, r5, ror #30
 564:	6173656d 	cmnvs	r3, sp, ror #10
 568:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 56c:	6f2f7469 	svcvs	0x002f7469
 570:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 574:	756f732f 	strbvc	r7, [pc, #-815]!	; 24d <shift+0x24d>
 578:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 57c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 580:	2f62696c 	svccs	0x0062696c
 584:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 588:	00656475 	rsbeq	r6, r5, r5, ror r4
 58c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4d8 <shift+0x4d8>
 590:	616a2f65 	cmnvs	sl, r5, ror #30
 594:	6173656d 	cmnvs	r3, sp, ror #10
 598:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 59c:	6f2f7469 	svcvs	0x002f7469
 5a0:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 5a4:	756f732f 	strbvc	r7, [pc, #-815]!	; 27d <shift+0x27d>
 5a8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 5ac:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 5b0:	2f6c656e 	svccs	0x006c656e
 5b4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 5b8:	2f656475 	svccs	0x00656475
 5bc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 5c0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 5c4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 5c8:	00006c61 	andeq	r6, r0, r1, ror #24
 5cc:	66647473 			; <UNDEFINED> instruction: 0x66647473
 5d0:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 5d4:	00707063 	rsbseq	r7, r0, r3, rrx
 5d8:	73000001 	movwvc	r0, #1
 5dc:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 5e0:	00000200 	andeq	r0, r0, r0, lsl #4
 5e4:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 5e8:	6b636f6c 	blvs	18dc3a0 <__bss_end+0x18d26e0>
 5ec:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5f0:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 5f4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 5f8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 5fc:	0300682e 	movweq	r6, #2094	; 0x82e
 600:	72700000 	rsbsvc	r0, r0, #0
 604:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 608:	00682e73 	rsbeq	r2, r8, r3, ror lr
 60c:	70000002 	andvc	r0, r0, r2
 610:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 614:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 450 <shift+0x450>
 618:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 61c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 620:	00000200 	andeq	r0, r0, r0, lsl #4
 624:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 628:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 62c:	00682e67 	rsbeq	r2, r8, r7, ror #28
 630:	69000004 	stmdbvs	r0, {r2}
 634:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 638:	00682e66 	rsbeq	r2, r8, r6, ror #28
 63c:	00000005 	andeq	r0, r0, r5
 640:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 644:	00855802 	addeq	r5, r5, r2, lsl #16
 648:	1a051600 	bne	145e50 <__bss_end+0x13c190>
 64c:	2f2c0569 	svccs	0x002c0569
 650:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 654:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 658:	1a058332 	bne	161328 <__bss_end+0x157668>
 65c:	2f01054b 	svccs	0x0001054b
 660:	4b1a0585 	blmi	681c7c <__bss_end+0x677fbc>
 664:	852f0105 	strhi	r0, [pc, #-261]!	; 567 <shift+0x567>
 668:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 66c:	1b054b2e 	blne	15332c <__bss_end+0x14966c>
 670:	2f2d054b 	svccs	0x002d054b
 674:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 678:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 67c:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 680:	4b2e054b 	blmi	b81bb4 <__bss_end+0xb77ef4>
 684:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 688:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 68c:	2f01054c 	svccs	0x0001054c
 690:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 694:	054b3005 	strbeq	r3, [fp, #-5]
 698:	1b054b2e 	blne	153358 <__bss_end+0x149698>
 69c:	2f2e054b 	svccs	0x002e054b
 6a0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6a4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6a8:	1b05832e 	blne	161368 <__bss_end+0x1576a8>
 6ac:	2f01054b 	svccs	0x0001054b
 6b0:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 6b4:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 6b8:	1b054b2f 	blne	15337c <__bss_end+0x1496bc>
 6bc:	2f30054b 	svccs	0x0030054b
 6c0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6c4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c8:	2f05a12e 	svccs	0x0005a12e
 6cc:	4b1b054b 	blmi	6c1c00 <__bss_end+0x6b7f40>
 6d0:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff7d3 <__bss_end+0xffff5b13>
 6d4:	01054c0c 	tsteq	r5, ip, lsl #24
 6d8:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 6dc:	4b2f05bd 	blmi	bc1dd8 <__bss_end+0xbb8118>
 6e0:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 6e4:	30054b1b 	andcc	r4, r5, fp, lsl fp
 6e8:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6ec:	852f0105 	strhi	r0, [pc, #-261]!	; 5ef <shift+0x5ef>
 6f0:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 6f4:	1a054b3b 	bne	1533e8 <__bss_end+0x149728>
 6f8:	2f30054b 	svccs	0x0030054b
 6fc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 700:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 704:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 708:	4b31054d 	blmi	c41c44 <__bss_end+0xc37f84>
 70c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 710:	0105300c 	tsteq	r5, ip
 714:	2005852f 	andcs	r8, r5, pc, lsr #10
 718:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 71c:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 720:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 724:	2f010530 	svccs	0x00010530
 728:	83200585 			; <UNDEFINED> instruction: 0x83200585
 72c:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 730:	1a054b3e 	bne	153430 <__bss_end+0x149770>
 734:	2f01054b 	svccs	0x0001054b
 738:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 73c:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 740:	1a054b30 	bne	153408 <__bss_end+0x149748>
 744:	300c054b 	andcc	r0, ip, fp, asr #10
 748:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 74c:	9fa00c05 	svcls	0x00a00c05
 750:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 754:	36056629 	strcc	r6, [r5], -r9, lsr #12
 758:	300f052e 	andcc	r0, pc, lr, lsr #10
 75c:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 760:	10058409 	andne	r8, r5, r9, lsl #8
 764:	9f0105d8 	svcls	0x000105d8
 768:	01000802 	tsteq	r0, r2, lsl #16
 76c:	00063e01 	andeq	r3, r6, r1, lsl #28
 770:	8f000300 	svchi	0x00000300
 774:	02000000 	andeq	r0, r0, #0
 778:	0d0efb01 	vstreq	d15, [lr, #-4]
 77c:	01010100 	mrseq	r0, (UNDEF: 17)
 780:	00000001 	andeq	r0, r0, r1
 784:	01000001 	tsteq	r0, r1
 788:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 6d4 <shift+0x6d4>
 78c:	616a2f65 	cmnvs	sl, r5, ror #30
 790:	6173656d 	cmnvs	r3, sp, ror #10
 794:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 798:	6f2f7469 	svcvs	0x002f7469
 79c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 7a0:	756f732f 	strbvc	r7, [pc, #-815]!	; 479 <shift+0x479>
 7a4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 7a8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 7ac:	2f62696c 	svccs	0x0062696c
 7b0:	00637273 	rsbeq	r7, r3, r3, ror r2
 7b4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 700 <shift+0x700>
 7b8:	616a2f65 	cmnvs	sl, r5, ror #30
 7bc:	6173656d 	cmnvs	r3, sp, ror #10
 7c0:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 7c4:	6f2f7469 	svcvs	0x002f7469
 7c8:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 7cc:	756f732f 	strbvc	r7, [pc, #-815]!	; 4a5 <shift+0x4a5>
 7d0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 7d4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 7d8:	2f62696c 	svccs	0x0062696c
 7dc:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 7e0:	00656475 	rsbeq	r6, r5, r5, ror r4
 7e4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 7e8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 7ec:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 7f0:	01007070 	tsteq	r0, r0, ror r0
 7f4:	74730000 	ldrbtvc	r0, [r3], #-0
 7f8:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 7fc:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 800:	00020068 	andeq	r0, r2, r8, rrx
 804:	01050000 	mrseq	r0, (UNDEF: 5)
 808:	b4020500 	strlt	r0, [r2], #-1280	; 0xfffffb00
 80c:	1a000089 	bne	a38 <shift+0xa38>
 810:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 814:	21054c0f 	tstcs	r5, pc, lsl #24
 818:	ba0a0568 	blt	281dc0 <__bss_end+0x278100>
 81c:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 820:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
 824:	2f09054a 	svccs	0x0009054a
 828:	059f0405 	ldreq	r0, [pc, #1029]	; c35 <shift+0xc35>
 82c:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 830:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
 834:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 838:	13054a22 	movwne	r4, #23074	; 0x5a22
 83c:	2f0a052e 	svccs	0x000a052e
 840:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
 844:	0c052e0a 	stceq	14, cr2, [r5], {10}
 848:	4b03054a 	blmi	c1d78 <__bss_end+0xb80b8>
 84c:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 850:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 854:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 858:	03040200 	movweq	r0, #16896	; 0x4200
 85c:	0015059e 	mulseq	r5, lr, r5
 860:	68020402 	stmdavs	r2, {r1, sl}
 864:	02001805 	andeq	r1, r0, #327680	; 0x50000
 868:	05820204 	streq	r0, [r2, #516]	; 0x204
 86c:	04020008 	streq	r0, [r2], #-8
 870:	1a054a02 	bne	153080 <__bss_end+0x1493c0>
 874:	02040200 	andeq	r0, r4, #0, 4
 878:	001b054b 	andseq	r0, fp, fp, asr #10
 87c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 880:	02000c05 	andeq	r0, r0, #1280	; 0x500
 884:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 888:	0402000f 	streq	r0, [r2], #-15
 88c:	1b058202 	blne	16109c <__bss_end+0x1573dc>
 890:	02040200 	andeq	r0, r4, #0, 4
 894:	0011054a 	andseq	r0, r1, sl, asr #10
 898:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 89c:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 8a0:	052f0204 	streq	r0, [pc, #-516]!	; 6a4 <shift+0x6a4>
 8a4:	0402000b 	streq	r0, [r2], #-11
 8a8:	0d052e02 	stceq	14, cr2, [r5, #-8]
 8ac:	02040200 	andeq	r0, r4, #0, 4
 8b0:	0002054a 	andeq	r0, r2, sl, asr #10
 8b4:	46020402 	strmi	r0, [r2], -r2, lsl #8
 8b8:	85880105 	strhi	r0, [r8, #261]	; 0x105
 8bc:	05830605 	streq	r0, [r3, #1541]	; 0x605
 8c0:	10054c09 	andne	r4, r5, r9, lsl #24
 8c4:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 8c8:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 8cc:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 8d0:	01040200 	mrseq	r0, R12_usr
 8d4:	0014054a 	andseq	r0, r4, sl, asr #10
 8d8:	4a010402 	bmi	418e8 <__bss_end+0x37c28>
 8dc:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 8e0:	0a054a14 	beq	153138 <__bss_end+0x149478>
 8e4:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 8e8:	78030205 	stmdavc	r3, {r0, r2, r9}
 8ec:	03090566 	movweq	r0, #38246	; 0x9566
 8f0:	01052e0b 	tsteq	r5, fp, lsl #28
 8f4:	0905852f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 8f8:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
 8fc:	4a040402 	bmi	10190c <__bss_end+0xf7c4c>
 900:	02001d05 	andeq	r1, r0, #320	; 0x140
 904:	05820204 	streq	r0, [r2, #516]	; 0x204
 908:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 90c:	16052e02 	strne	r2, [r5], -r2, lsl #28
 910:	02040200 	andeq	r0, r4, #0, 4
 914:	00110566 	andseq	r0, r1, r6, ror #10
 918:	4b030402 	blmi	c1928 <__bss_end+0xb7c68>
 91c:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 920:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 924:	04020008 	streq	r0, [r2], #-8
 928:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
 92c:	03040200 	movweq	r0, #16896	; 0x4200
 930:	0012052e 	andseq	r0, r2, lr, lsr #10
 934:	4a030402 	bmi	c1944 <__bss_end+0xb7c84>
 938:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 93c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 940:	04020002 	streq	r0, [r2], #-2
 944:	0b052d03 	bleq	14bd58 <__bss_end+0x142098>
 948:	02040200 	andeq	r0, r4, #0, 4
 94c:	00080584 	andeq	r0, r8, r4, lsl #11
 950:	83010402 	movwhi	r0, #5122	; 0x1402
 954:	02000905 	andeq	r0, r0, #81920	; 0x14000
 958:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 95c:	0402000b 	streq	r0, [r2], #-11
 960:	02054a01 	andeq	r4, r5, #4096	; 0x1000
 964:	01040200 	mrseq	r0, R12_usr
 968:	850b0549 	strhi	r0, [fp, #-1353]	; 0xfffffab7
 96c:	852f0105 	strhi	r0, [pc, #-261]!	; 86f <shift+0x86f>
 970:	05bc0e05 	ldreq	r0, [ip, #3589]!	; 0xe05
 974:	20056611 	andcs	r6, r5, r1, lsl r6
 978:	660b05bc 			; <UNDEFINED> instruction: 0x660b05bc
 97c:	054b1f05 	strbeq	r1, [fp, #-3845]	; 0xfffff0fb
 980:	0805660a 	stmdaeq	r5, {r1, r3, r9, sl, sp, lr}
 984:	8311054b 	tsthi	r1, #314572800	; 0x12c00000
 988:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
 98c:	11056708 	tstne	r5, r8, lsl #14
 990:	4d0b0567 	cfstr32mi	mvfx0, [fp, #-412]	; 0xfffffe64
 994:	852f0105 	strhi	r0, [pc, #-261]!	; 897 <shift+0x897>
 998:	05830605 	streq	r0, [r3, #1541]	; 0x605
 99c:	0c054c0b 	stceq	12, cr4, [r5], {11}
 9a0:	660e052e 	strvs	r0, [lr], -lr, lsr #10
 9a4:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
 9a8:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
 9ac:	2f010531 	svccs	0x00010531
 9b0:	9f080585 	svcls	0x00080585
 9b4:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 9b8:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 9bc:	07054a03 	streq	r4, [r5, -r3, lsl #20]
 9c0:	02040200 	andeq	r0, r4, #0, 4
 9c4:	00080583 	andeq	r0, r8, r3, lsl #11
 9c8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9cc:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 9d0:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9d4:	04020002 	streq	r0, [r2], #-2
 9d8:	01054902 	tsteq	r5, r2, lsl #18
 9dc:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
 9e0:	4b0805bb 	blmi	2020d4 <__bss_end+0x1f8414>
 9e4:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 9e8:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 9ec:	16054a03 	strne	r4, [r5], -r3, lsl #20
 9f0:	02040200 	andeq	r0, r4, #0, 4
 9f4:	00170583 	andseq	r0, r7, r3, lsl #11
 9f8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9fc:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 a00:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 a04:	0402000b 	streq	r0, [r2], #-11
 a08:	17052e02 	strne	r2, [r5, -r2, lsl #28]
 a0c:	02040200 	andeq	r0, r4, #0, 4
 a10:	000d054a 	andeq	r0, sp, sl, asr #10
 a14:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a18:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 a1c:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 a20:	05858401 	streq	r8, [r5, #1025]	; 0x401
 a24:	16059f0b 	strne	r9, [r5], -fp, lsl #30
 a28:	001c054b 	andseq	r0, ip, fp, asr #10
 a2c:	4a030402 	bmi	c1a3c <__bss_end+0xb7d7c>
 a30:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 a34:	05830204 	streq	r0, [r3, #516]	; 0x204
 a38:	04020005 	streq	r0, [r2], #-5
 a3c:	0c058102 	stfeqd	f0, [r5], {2}
 a40:	4b010585 	blmi	4205c <__bss_end+0x3839c>
 a44:	84110585 	ldrhi	r0, [r1], #-1413	; 0xfffffa7b
 a48:	05680c05 	strbeq	r0, [r8, #-3077]!	; 0xfffff3fb
 a4c:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 a50:	13054a03 	movwne	r4, #23043	; 0x5a03
 a54:	03040200 	movweq	r0, #16896	; 0x4200
 a58:	0015059e 	mulseq	r5, lr, r5
 a5c:	68020402 	stmdavs	r2, {r1, sl}
 a60:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 a64:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a68:	0402000e 	streq	r0, [r2], #-14
 a6c:	1c056602 	stcne	6, cr6, [r5], {2}
 a70:	02040200 	andeq	r0, r4, #0, 4
 a74:	0023052f 	eoreq	r0, r3, pc, lsr #10
 a78:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a7c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 a80:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 a84:	0402000f 	streq	r0, [r2], #-15
 a88:	23052e02 	movwcs	r2, #24066	; 0x5e02
 a8c:	02040200 	andeq	r0, r4, #0, 4
 a90:	0011054a 	andseq	r0, r1, sl, asr #10
 a94:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a98:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 a9c:	052f0204 	streq	r0, [pc, #-516]!	; 8a0 <shift+0x8a0>
 aa0:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 aa4:	1b056602 	blne	15a2b4 <__bss_end+0x1505f4>
 aa8:	02040200 	andeq	r0, r4, #0, 4
 aac:	00050566 	andeq	r0, r5, r6, ror #10
 ab0:	62020402 	andvs	r0, r2, #33554432	; 0x2000000
 ab4:	69880105 	stmibvs	r8, {r0, r2, r8}
 ab8:	05d70505 	ldrbeq	r0, [r7, #1285]	; 0x505
 abc:	1a059f09 	bne	1686e8 <__bss_end+0x15ea28>
 ac0:	01040200 	mrseq	r0, R12_usr
 ac4:	002e059e 	mlaeq	lr, lr, r5, r0
 ac8:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 acc:	059f0905 	ldreq	r0, [pc, #2309]	; 13d9 <shift+0x13d9>
 ad0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 ad4:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 ad8:	01040200 	mrseq	r0, R12_usr
 adc:	9f090582 	svcls	0x00090582
 ae0:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 ae4:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 ae8:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 aec:	09058201 	stmdbeq	r5, {r0, r9, pc}
 af0:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 af4:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 af8:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 afc:	05820104 	streq	r0, [r2, #260]	; 0x104
 b00:	1a059f09 	bne	16872c <__bss_end+0x15ea6c>
 b04:	01040200 	mrseq	r0, R12_usr
 b08:	002e059e 	mlaeq	lr, lr, r5, r0
 b0c:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b10:	059f0905 	ldreq	r0, [pc, #2309]	; 141d <shift+0x141d>
 b14:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b18:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b1c:	01040200 	mrseq	r0, R12_usr
 b20:	a0050582 	andge	r0, r5, r2, lsl #11
 b24:	02000f05 	andeq	r0, r0, #5, 30
 b28:	05820104 	streq	r0, [r2, #260]	; 0x104
 b2c:	1a059f09 	bne	168758 <__bss_end+0x15ea98>
 b30:	01040200 	mrseq	r0, R12_usr
 b34:	002e059e 	mlaeq	lr, lr, r5, r0
 b38:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b3c:	059f0905 	ldreq	r0, [pc, #2309]	; 1449 <shift+0x1449>
 b40:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b44:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b48:	01040200 	mrseq	r0, R12_usr
 b4c:	9f090582 	svcls	0x00090582
 b50:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b54:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b58:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b5c:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b60:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 b64:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 b68:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 b6c:	05820104 	streq	r0, [r2, #260]	; 0x104
 b70:	1a059f09 	bne	16879c <__bss_end+0x15eadc>
 b74:	01040200 	mrseq	r0, R12_usr
 b78:	002e059e 	mlaeq	lr, lr, r5, r0
 b7c:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b80:	059f0905 	ldreq	r0, [pc, #2309]	; 148d <shift+0x148d>
 b84:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b88:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b8c:	01040200 	mrseq	r0, R12_usr
 b90:	a0100582 	andsge	r0, r0, r2, lsl #11
 b94:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 b98:	19054b1a 	stmdbne	r5, {r1, r3, r4, r8, r9, fp, lr}
 b9c:	820b054a 	andhi	r0, fp, #310378496	; 0x12800000
 ba0:	05670f05 	strbeq	r0, [r7, #-3845]!	; 0xfffff0fb
 ba4:	1905660d 	stmdbne	r5, {r0, r2, r3, r9, sl, sp, lr}
 ba8:	4a12054b 	bmi	4820dc <__bss_end+0x47841c>
 bac:	054a1105 	strbeq	r1, [sl, #-261]	; 0xfffffefb
 bb0:	01054a05 	tsteq	r5, r5, lsl #20
 bb4:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 bb8:	2e760309 	cdpcs	3, 7, cr0, cr6, cr9, {0}
 bbc:	054a1005 	strbeq	r1, [sl, #-5]
 bc0:	0905670c 	stmdbeq	r5, {r2, r3, r8, r9, sl, sp, lr}
 bc4:	6715054a 	ldrvs	r0, [r5, -sl, asr #10]
 bc8:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 bcc:	10054a15 	andne	r4, r5, r5, lsl sl
 bd0:	4a0d0567 	bmi	342174 <__bss_end+0x3384b4>
 bd4:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 bd8:	19056711 	stmdbne	r5, {r0, r4, r8, r9, sl, sp, lr}
 bdc:	6a01054a 	bvs	4210c <__bss_end+0x3844c>
 be0:	05152e02 	ldreq	r2, [r5, #-3586]	; 0xfffff1fe
 be4:	1205bb06 	andne	fp, r5, #6144	; 0x1800
 be8:	6615054b 	ldrvs	r0, [r5], -fp, asr #10
 bec:	05bb2005 	ldreq	r2, [fp, #5]!
 bf0:	05200823 	streq	r0, [r0, #-2083]!	; 0xfffff7dd
 bf4:	14052e12 	strne	r2, [r5], #-3602	; 0xfffff1ee
 bf8:	4a230582 	bmi	8c2208 <__bss_end+0x8b8548>
 bfc:	054a1605 	strbeq	r1, [sl, #-1541]	; 0xfffff9fb
 c00:	05052f0b 	streq	r2, [r5, #-3851]	; 0xfffff0f5
 c04:	3206059c 	andcc	r0, r6, #156, 10	; 0x27000000
 c08:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 c0c:	08054a0d 	stmdaeq	r5, {r0, r2, r3, r9, fp, lr}
 c10:	4b01054b 	blmi	42144 <__bss_end+0x38484>
 c14:	830e0585 	movwhi	r0, #58757	; 0xe585
 c18:	85d70105 	ldrbhi	r0, [r7, #261]	; 0x105
 c1c:	05830d05 	streq	r0, [r3, #3333]	; 0xd05
 c20:	05a2d701 	streq	sp, [r2, #1793]!	; 0x701
 c24:	01059f06 	tsteq	r5, r6, lsl #30
 c28:	0f056a83 	svceq	0x00056a83
 c2c:	4b0505bb 	blmi	142320 <__bss_end+0x138660>
 c30:	05840c05 	streq	r0, [r4, #3077]	; 0xc05
 c34:	1005660e 	andne	r6, r5, lr, lsl #12
 c38:	4b05054a 	blmi	142168 <__bss_end+0x1384a8>
 c3c:	05680d05 	strbeq	r0, [r8, #-3333]!	; 0xfffff2fb
 c40:	0c056605 	stceq	6, cr6, [r5], {5}
 c44:	660e054c 	strvs	r0, [lr], -ip, asr #10
 c48:	054a1005 	strbeq	r1, [sl, #-5]
 c4c:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c50:	4a100566 	bmi	4021f0 <__bss_end+0x3f8530>
 c54:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c58:	1005660e 	andne	r6, r5, lr, lsl #12
 c5c:	4b0c054a 	blmi	30218c <__bss_end+0x2f84cc>
 c60:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c64:	03054a10 	movweq	r4, #23056	; 0x5a10
 c68:	300d054b 	andcc	r0, sp, fp, asr #10
 c6c:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 c70:	0e054c0c 	cdpeq	12, 0, cr4, cr5, cr12, {0}
 c74:	4a100566 	bmi	402214 <__bss_end+0x3f8554>
 c78:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c7c:	1005660e 	andne	r6, r5, lr, lsl #12
 c80:	4b0c054a 	blmi	3021b0 <__bss_end+0x2f84f0>
 c84:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c88:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c8c:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c90:	054a1005 	strbeq	r1, [sl, #-5]
 c94:	06054b03 	streq	r4, [r5], -r3, lsl #22
 c98:	4b020530 	blmi	82160 <__bss_end+0x784a0>
 c9c:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 ca0:	0e054c1c 	mcreq	12, 0, r4, cr5, cr12, {0}
 ca4:	6607059f 			; <UNDEFINED> instruction: 0x6607059f
 ca8:	05681805 	strbeq	r1, [r8, #-2053]!	; 0xfffff7fb
 cac:	33058334 	movwcc	r8, #21300	; 0x5334
 cb0:	4a440566 	bmi	1102250 <__bss_end+0x10f8590>
 cb4:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
 cb8:	1d056906 	vstrne.16	s12, [r5, #-12]	; <UNPREDICTABLE>
 cbc:	840b059f 	strhi	r0, [fp], #-1439	; 0xfffffa61
 cc0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 cc4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 cc8:	0402000c 	streq	r0, [r2], #-12
 ccc:	0e058402 	cdpeq	4, 0, cr8, cr5, cr2, {0}
 cd0:	02040200 	andeq	r0, r4, #0, 4
 cd4:	001e0566 	andseq	r0, lr, r6, ror #10
 cd8:	4a020402 	bmi	81ce8 <__bss_end+0x78028>
 cdc:	02001005 	andeq	r1, r0, #5
 ce0:	05820204 	streq	r0, [r2, #516]	; 0x204
 ce4:	04020002 	streq	r0, [r2], #-2
 ce8:	05872c02 	streq	r2, [r7, #3074]	; 0xc02
 cec:	0e05680c 	cdpeq	8, 0, cr6, cr5, cr12, {0}
 cf0:	4a100566 	bmi	402290 <__bss_end+0x3f85d0>
 cf4:	054c1a05 	strbeq	r1, [ip, #-2565]	; 0xfffff5fb
 cf8:	1505a00c 	strne	sl, [r5, #-12]
 cfc:	01040200 	mrseq	r0, R12_usr
 d00:	6819054a 	ldmdavs	r9, {r1, r3, r6, r8, sl}
 d04:	05820405 	streq	r0, [r2, #1029]	; 0x405
 d08:	0402000d 	streq	r0, [r2], #-13
 d0c:	0f054c02 	svceq	0x00054c02
 d10:	02040200 	andeq	r0, r4, #0, 4
 d14:	00240566 	eoreq	r0, r4, r6, ror #10
 d18:	4a020402 	bmi	81d28 <__bss_end+0x78068>
 d1c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 d20:	05820204 	streq	r0, [r2, #516]	; 0x204
 d24:	04020003 	streq	r0, [r2], #-3
 d28:	05052a02 	streq	r2, [r5, #-2562]	; 0xfffff5fe
 d2c:	000b0585 	andeq	r0, fp, r5, lsl #11
 d30:	32020402 	andcc	r0, r2, #33554432	; 0x2000000
 d34:	02000d05 	andeq	r0, r0, #320	; 0x140
 d38:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 d3c:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 d40:	12058309 	andne	r8, r5, #603979776	; 0x24000000
 d44:	4b07054a 	blmi	1c2274 <__bss_end+0x1b85b4>
 d48:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 d4c:	0a054b06 	beq	15396c <__bss_end+0x149cac>
 d50:	4c0c0567 	cfstr32mi	mvfx0, [ip], {103}	; 0x67
 d54:	02001c05 	andeq	r1, r0, #1280	; 0x500
 d58:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 d5c:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 d60:	09054a01 	stmdbeq	r5, {r0, r9, fp, lr}
 d64:	4a05054b 	bmi	142298 <__bss_end+0x1385d8>
 d68:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 d6c:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
 d70:	04020007 	streq	r0, [r2], #-7
 d74:	0d054b01 	vstreq	d4, [r5, #-4]
 d78:	4a090530 	bmi	242240 <__bss_end+0x238580>
 d7c:	054b0505 	strbeq	r0, [fp, #-1285]	; 0xfffffafb
 d80:	04020010 	streq	r0, [r2], #-16
 d84:	07056601 	streq	r6, [r5, -r1, lsl #12]
 d88:	001c0567 	andseq	r0, ip, r7, ror #10
 d8c:	66010402 	strvs	r0, [r1], -r2, lsl #8
 d90:	05831105 	streq	r1, [r3, #261]	; 0x105
 d94:	0b05661b 	bleq	15a608 <__bss_end+0x150948>
 d98:	00030566 	andeq	r0, r3, r6, ror #10
 d9c:	03020402 	movweq	r0, #9218	; 0x2402
 da0:	10054a78 	andne	r4, r5, r8, ror sl
 da4:	05820b03 	streq	r0, [r2, #2819]	; 0xb03
 da8:	0c026701 	stceq	7, cr6, [r2], {1}
 dac:	79010100 	stmdbvc	r1, {r8}
 db0:	03000000 	movweq	r0, #0
 db4:	00004600 	andeq	r4, r0, r0, lsl #12
 db8:	fb010200 	blx	415c2 <__bss_end+0x37902>
 dbc:	01000d0e 	tsteq	r0, lr, lsl #26
 dc0:	00010101 	andeq	r0, r1, r1, lsl #2
 dc4:	00010000 	andeq	r0, r1, r0
 dc8:	2e2e0100 	sufcse	f0, f6, f0
 dcc:	2f2e2e2f 	svccs	0x002e2e2f
 dd0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dd4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dd8:	2f2e2e2f 	svccs	0x002e2e2f
 ddc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 de0:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 de4:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 de8:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 dec:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 df0:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 df4:	73636e75 	cmnvc	r3, #1872	; 0x750
 df8:	0100532e 	tsteq	r0, lr, lsr #6
 dfc:	00000000 	andeq	r0, r0, r0
 e00:	99900205 	ldmibls	r0, {r0, r2, r9}
 e04:	ca030000 	bgt	c0e0c <__bss_end+0xb714c>
 e08:	2f300108 	svccs	0x00300108
 e0c:	2f2f2f2f 	svccs	0x002f2f2f
 e10:	01d00230 	bicseq	r0, r0, r0, lsr r2
 e14:	2f312f14 	svccs	0x00312f14
 e18:	2f4c302f 	svccs	0x004c302f
 e1c:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 e20:	2f2f2f2f 	svccs	0x002f2f2f
 e24:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 e28:	01010002 	tsteq	r1, r2
 e2c:	0000005c 	andeq	r0, r0, ip, asr r0
 e30:	00460003 	subeq	r0, r6, r3
 e34:	01020000 	mrseq	r0, (UNDEF: 2)
 e38:	000d0efb 	strdeq	r0, [sp], -fp
 e3c:	01010101 	tsteq	r1, r1, lsl #2
 e40:	01000000 	mrseq	r0, (UNDEF: 0)
 e44:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 e48:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e4c:	2f2e2e2f 	svccs	0x002e2e2f
 e50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e58:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 e5c:	2f636367 	svccs	0x00636367
 e60:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 e64:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 e68:	00006d72 	andeq	r6, r0, r2, ror sp
 e6c:	3162696c 	cmncc	r2, ip, ror #18
 e70:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 e74:	00532e73 	subseq	r2, r3, r3, ror lr
 e78:	00000001 	andeq	r0, r0, r1
 e7c:	9c020500 	cfstr32ls	mvfx0, [r2], {-0}
 e80:	0300009b 	movweq	r0, #155	; 0x9b
 e84:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
 e88:	01010002 	tsteq	r1, r2
 e8c:	00000103 	andeq	r0, r0, r3, lsl #2
 e90:	00fd0003 	rscseq	r0, sp, r3
 e94:	01020000 	mrseq	r0, (UNDEF: 2)
 e98:	000d0efb 	strdeq	r0, [sp], -fp
 e9c:	01010101 	tsteq	r1, r1, lsl #2
 ea0:	01000000 	mrseq	r0, (UNDEF: 0)
 ea4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 ea8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 eac:	2f2e2e2f 	svccs	0x002e2e2f
 eb0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 eb4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 eb8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 ebc:	2f636367 	svccs	0x00636367
 ec0:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
 ec4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 ec8:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
 ecc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ed0:	2f2e2e2f 	svccs	0x002e2e2f
 ed4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ed8:	2f2e2f2e 	svccs	0x002e2f2e
 edc:	00636367 	rsbeq	r6, r3, r7, ror #6
 ee0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ee4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ee8:	2f2e2e2f 	svccs	0x002e2e2f
 eec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ef0:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 ef4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ef8:	2f2e2e2f 	svccs	0x002e2e2f
 efc:	2f636367 	svccs	0x00636367
 f00:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 f04:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 f08:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 f0c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f10:	2f2e2e2f 	svccs	0x002e2e2f
 f14:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f18:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 f1c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 f20:	00636367 	rsbeq	r6, r3, r7, ror #6
 f24:	73616800 	cmnvc	r1, #0, 16
 f28:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
 f2c:	0100682e 	tsteq	r0, lr, lsr #16
 f30:	72610000 	rsbvc	r0, r1, #0
 f34:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
 f38:	00682e61 	rsbeq	r2, r8, r1, ror #28
 f3c:	61000002 	tstvs	r0, r2
 f40:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
 f44:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
 f48:	00000200 	andeq	r0, r0, r0, lsl #4
 f4c:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
 f50:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
 f54:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
 f58:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 f5c:	00000200 	andeq	r0, r0, r0, lsl #4
 f60:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 f64:	00030068 	andeq	r0, r3, r8, rrx
 f68:	62696c00 	rsbvs	r6, r9, #0, 24
 f6c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 f70:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 f74:	62670000 	rsbvs	r0, r7, #0
 f78:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 f7c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 f80:	00040068 	andeq	r0, r4, r8, rrx
 f84:	62696c00 	rsbvs	r6, r9, #0, 24
 f88:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 f8c:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
 f90:	Address 0x0000000000000f90 is out of bounds.


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
      58:	18bc0704 	ldmne	ip!, {r2, r8, r9, sl}
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
     128:	000018bc 			; <UNDEFINED> instruction: 0x000018bc
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
     174:	cb104801 	blgt	412180 <__bss_end+0x4084c0>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x364d4>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a198>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x365a4>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f67cc>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000a53 	andeq	r0, r0, r3, asr sl
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	000a5804 	andeq	r5, sl, r4, lsl #16
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00032c00 	andeq	r2, r3, r0, lsl #24
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	08fb0200 	ldmeq	fp!, {r9}^
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	a0030500 	andge	r0, r3, r0, lsl #10
     308:	0300009b 	movweq	r0, #155	; 0x9b
     30c:	16860404 	strne	r0, [r6], r4, lsl #8
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	09d30801 	ldmibeq	r3, {r0, fp}^
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0a0a0502 	beq	281734 <__bss_end+0x277a74>
     328:	04050000 	streq	r0, [r5], #-0
     32c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     330:	08010300 	stmdaeq	r1, {r8, r9}
     334:	000009ca 	andeq	r0, r0, sl, asr #19
     338:	9d070203 	sfmls	f0, 4, [r7, #-12]
     33c:	06000007 	streq	r0, [r0], -r7
     340:	00000a4f 	andeq	r0, r0, pc, asr #20
     344:	7c070909 			; <UNDEFINED> instruction: 0x7c070909
     348:	04000000 	streq	r0, [r0], #-0
     34c:	0000006b 	andeq	r0, r0, fp, rrx
     350:	bc070403 	cfstrslt	mvf0, [r7], {3}
     354:	07000018 	smladeq	r0, r8, r0, r0
     358:	00000639 	andeq	r0, r0, r9, lsr r6
     35c:	08060208 	stmdaeq	r6, {r3, r9}
     360:	000000a9 	andeq	r0, r0, r9, lsr #1
     364:	00307208 	eorseq	r7, r0, r8, lsl #4
     368:	6b0e0802 	blvs	382378 <__bss_end+0x3786b8>
     36c:	00000000 	andeq	r0, r0, r0
     370:	00317208 	eorseq	r7, r1, r8, lsl #4
     374:	6b0e0902 	blvs	382784 <__bss_end+0x378ac4>
     378:	04000000 	streq	r0, [r0], #-0
     37c:	04fc0900 	ldrbteq	r0, [ip], #2304	; 0x900
     380:	04050000 	streq	r0, [r5], #-0
     384:	00000056 	andeq	r0, r0, r6, asr r0
     388:	e00c1e02 	and	r1, ip, r2, lsl #28
     38c:	0a000000 	beq	394 <shift+0x394>
     390:	000006a0 	andeq	r0, r0, r0, lsr #13
     394:	0d720a00 	vldmdbeq	r2!, {s1-s0}
     398:	0a010000 	beq	403a0 <__bss_end+0x366e0>
     39c:	00000d3c 	andeq	r0, r0, ip, lsr sp
     3a0:	08070a02 	stmdaeq	r7, {r1, r9, fp}
     3a4:	0a030000 	beq	c03ac <__bss_end+0xb66ec>
     3a8:	00000945 	andeq	r0, r0, r5, asr #18
     3ac:	06690a04 	strbteq	r0, [r9], -r4, lsl #20
     3b0:	00050000 	andeq	r0, r5, r0
     3b4:	000cac09 	andeq	sl, ip, r9, lsl #24
     3b8:	56040500 	strpl	r0, [r4], -r0, lsl #10
     3bc:	02000000 	andeq	r0, r0, #0
     3c0:	011d0c3f 	tsteq	sp, pc, lsr ip
     3c4:	ba0a0000 	blt	2803cc <__bss_end+0x27670c>
     3c8:	00000003 	andeq	r0, r0, r3
     3cc:	0005110a 	andeq	r1, r5, sl, lsl #2
     3d0:	2e0a0100 	adfcse	f0, f2, f0
     3d4:	02000009 	andeq	r0, r0, #9
     3d8:	000d070a 	andeq	r0, sp, sl, lsl #14
     3dc:	7c0a0300 	stcvc	3, cr0, [sl], {-0}
     3e0:	0400000d 	streq	r0, [r0], #-13
     3e4:	0008e60a 	andeq	lr, r8, sl, lsl #12
     3e8:	bd0a0500 	cfstr32lt	mvfx0, [sl, #-0]
     3ec:	06000007 	streq	r0, [r0], -r7
     3f0:	0c660900 			; <UNDEFINED> instruction: 0x0c660900
     3f4:	04050000 	streq	r0, [r5], #-0
     3f8:	00000056 	andeq	r0, r0, r6, asr r0
     3fc:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
     400:	0a000001 	beq	40c <shift+0x40c>
     404:	000009a8 	andeq	r0, r0, r8, lsr #19
     408:	077f0a00 	ldrbeq	r0, [pc, -r0, lsl #20]!
     40c:	0a010000 	beq	40414 <__bss_end+0x36754>
     410:	00000a1e 	andeq	r0, r0, lr, lsl sl
     414:	07c20a02 	strbeq	r0, [r2, r2, lsl #20]
     418:	00030000 	andeq	r0, r3, r0
     41c:	0008ed02 	andeq	lr, r8, r2, lsl #26
     420:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
     424:	00000077 	andeq	r0, r0, r7, ror r0
     428:	9ba40305 	blls	fe901044 <__bss_end+0xfe8f7384>
     42c:	0a020000 	beq	80434 <__bss_end+0x76774>
     430:	04000009 	streq	r0, [r0], #-9
     434:	00771406 	rsbseq	r1, r7, r6, lsl #8
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00009ba8 	andeq	r9, r0, r8, lsr #23
     440:	0008d002 	andeq	sp, r8, r2
     444:	1a070500 	bne	1c184c <__bss_end+0x1b7b8c>
     448:	00000077 	andeq	r0, r0, r7, ror r0
     44c:	9bac0305 	blls	feb01068 <__bss_end+0xfeaf73a8>
     450:	41020000 	mrsmi	r0, (UNDEF: 2)
     454:	05000005 	streq	r0, [r0, #-5]
     458:	00771a09 	rsbseq	r1, r7, r9, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00009bb0 			; <UNDEFINED> instruction: 0x00009bb0
     464:	0009bc02 	andeq	fp, r9, r2, lsl #24
     468:	1a0b0500 	bne	2c1870 <__bss_end+0x2b7bb0>
     46c:	00000077 	andeq	r0, r0, r7, ror r0
     470:	9bb40305 	blls	fed0108c <__bss_end+0xfecf73cc>
     474:	6c020000 	stcvs	0, cr0, [r2], {-0}
     478:	05000007 	streq	r0, [r0, #-7]
     47c:	00771a0d 	rsbseq	r1, r7, sp, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00009bb8 			; <UNDEFINED> instruction: 0x00009bb8
     488:	00065202 	andeq	r5, r6, r2, lsl #4
     48c:	1a0f0500 	bne	3c1894 <__bss_end+0x3b7bd4>
     490:	00000077 	andeq	r0, r0, r7, ror r0
     494:	9bbc0305 	blls	fef010b0 <__bss_end+0xfeef73f0>
     498:	cc090000 	stcgt	0, cr0, [r9], {-0}
     49c:	0500000a 	streq	r0, [r0, #-10]
     4a0:	00005604 	andeq	r5, r0, r4, lsl #12
     4a4:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
     4a8:	000001eb 	andeq	r0, r0, fp, ror #3
     4ac:	000afa0a 	andeq	pc, sl, sl, lsl #20
     4b0:	2c0a0000 	stccs	0, cr0, [sl], {-0}
     4b4:	0100000d 	tsteq	r0, sp
     4b8:	0009290a 	andeq	r2, r9, sl, lsl #18
     4bc:	0b000200 	bleq	cc4 <shift+0xcc4>
     4c0:	000009a2 	andeq	r0, r0, r2, lsr #19
     4c4:	0009fe0c 	andeq	pc, r9, ip, lsl #28
     4c8:	63059000 	movwvs	r9, #20480	; 0x5000
     4cc:	00035e07 	andeq	r5, r3, r7, lsl #28
     4d0:	0cdb0700 	ldcleq	7, cr0, [fp], {0}
     4d4:	05240000 	streq	r0, [r4, #-0]!
     4d8:	02781067 	rsbseq	r1, r8, #103	; 0x67
     4dc:	2c0d0000 	stccs	0, cr0, [sp], {-0}
     4e0:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
     4e4:	035e1269 	cmpeq	lr, #-1879048186	; 0x90000006
     4e8:	0d000000 	stceq	0, cr0, [r0, #-0]
     4ec:	000004f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     4f0:	6e126b05 	vnmlsvs.f64	d6, d2, d5
     4f4:	10000003 	andne	r0, r0, r3
     4f8:	000aef0d 	andeq	lr, sl, sp, lsl #30
     4fc:	166d0500 	strbtne	r0, [sp], -r0, lsl #10
     500:	0000006b 	andeq	r0, r0, fp, rrx
     504:	053a0d14 	ldreq	r0, [sl, #-3348]!	; 0xfffff2ec
     508:	70050000 	andvc	r0, r5, r0
     50c:	0003751c 	andeq	r7, r3, ip, lsl r5
     510:	b30d1800 	movwlt	r1, #55296	; 0xd800
     514:	05000009 	streq	r0, [r0, #-9]
     518:	03751c72 	cmneq	r5, #29184	; 0x7200
     51c:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     520:	000004cd 	andeq	r0, r0, sp, asr #9
     524:	751c7505 	ldrvc	r7, [ip, #-1285]	; 0xfffffafb
     528:	20000003 	andcs	r0, r0, r3
     52c:	0006a80e 	andeq	sl, r6, lr, lsl #16
     530:	1c770500 	cfldr64ne	mvdx0, [r7], #-0
     534:	0000041b 	andeq	r0, r0, fp, lsl r4
     538:	00000375 	andeq	r0, r0, r5, ror r3
     53c:	0000026c 	andeq	r0, r0, ip, ror #4
     540:	0003750f 	andeq	r7, r3, pc, lsl #10
     544:	037b1000 	cmneq	fp, #0
     548:	00000000 	andeq	r0, r0, r0
     54c:	00059f07 	andeq	r9, r5, r7, lsl #30
     550:	7b051800 	blvc	146558 <__bss_end+0x13c898>
     554:	0002ad10 	andeq	sl, r2, r0, lsl sp
     558:	1c2c0d00 	stcne	13, cr0, [ip], #-0
     55c:	7e050000 	cdpvc	0, 0, cr0, cr5, cr0, {0}
     560:	00035e12 	andeq	r5, r3, r2, lsl lr
     564:	e50d0000 	str	r0, [sp, #-0]
     568:	05000004 	streq	r0, [r0, #-4]
     56c:	037b1980 	cmneq	fp, #128, 18	; 0x200000
     570:	0d100000 	ldceq	0, cr0, [r0, #-0]
     574:	00000d0d 	andeq	r0, r0, sp, lsl #26
     578:	86218205 	strthi	r8, [r1], -r5, lsl #4
     57c:	14000003 	strne	r0, [r0], #-3
     580:	02780400 	rsbseq	r0, r8, #0, 8
     584:	90110000 	andsls	r0, r1, r0
     588:	05000008 	streq	r0, [r0, #-8]
     58c:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
     590:	28110000 	ldmdacs	r1, {}	; <UNPREDICTABLE>
     594:	05000007 	streq	r0, [r0, #-7]
     598:	00771f88 	rsbseq	r1, r7, r8, lsl #31
     59c:	350d0000 	strcc	r0, [sp, #-0]
     5a0:	0500000a 	streq	r0, [r0, #-10]
     5a4:	01fd178b 	mvnseq	r1, fp, lsl #15
     5a8:	0d000000 	stceq	0, cr0, [r0, #-0]
     5ac:	0000080d 	andeq	r0, r0, sp, lsl #16
     5b0:	fd178e05 	ldc2	14, cr8, [r7, #-20]	; 0xffffffec
     5b4:	24000001 	strcs	r0, [r0], #-1
     5b8:	00073a0d 	andeq	r3, r7, sp, lsl #20
     5bc:	178f0500 	strne	r0, [pc, r0, lsl #10]
     5c0:	000001fd 	strdeq	r0, [r0], -sp
     5c4:	0d5c0d48 	ldcleq	13, cr0, [ip, #-288]	; 0xfffffee0
     5c8:	90050000 	andls	r0, r5, r0
     5cc:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
     5d0:	fe126c00 	cdp2	12, 1, cr6, cr2, cr0, {0}
     5d4:	05000009 	streq	r0, [r0, #-9]
     5d8:	058a0993 	streq	r0, [sl, #2451]	; 0x993
     5dc:	03970000 	orrseq	r0, r7, #0
     5e0:	17010000 	strne	r0, [r1, -r0]
     5e4:	1d000003 	stcne	0, cr0, [r0, #-12]
     5e8:	0f000003 	svceq	0x00000003
     5ec:	00000397 	muleq	r0, r7, r3
     5f0:	08851300 	stmeq	r5, {r8, r9, ip}
     5f4:	96050000 	strls	r0, [r5], -r0
     5f8:	0007da0e 	andeq	sp, r7, lr, lsl #20
     5fc:	03320100 	teqeq	r2, #0, 2
     600:	03380000 	teqeq	r8, #0
     604:	970f0000 	strls	r0, [pc, -r0]
     608:	00000003 	andeq	r0, r0, r3
     60c:	0003ba14 	andeq	fp, r3, r4, lsl sl
     610:	10990500 	addsne	r0, r9, r0, lsl #10
     614:	00000ab1 			; <UNDEFINED> instruction: 0x00000ab1
     618:	0000039d 	muleq	r0, sp, r3
     61c:	00034d01 	andeq	r4, r3, r1, lsl #26
     620:	03970f00 	orrseq	r0, r7, #0, 30
     624:	7b100000 	blvc	40062c <__bss_end+0x3f696c>
     628:	10000003 	andne	r0, r0, r3
     62c:	000001c6 	andeq	r0, r0, r6, asr #3
     630:	43150000 	tstmi	r5, #0
     634:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
     638:	16000003 	strne	r0, [r0], -r3
     63c:	0000007c 	andeq	r0, r0, ip, ror r0
     640:	0103000f 	tsteq	r3, pc
     644:	00081702 	andeq	r1, r8, r2, lsl #14
     648:	fd041700 	stc2	7, cr1, [r4, #-0]
     64c:	17000001 	strne	r0, [r0, -r1]
     650:	00004a04 	andeq	r4, r0, r4, lsl #20
     654:	0d190b00 	vldreq	d0, [r9, #-0]
     658:	04170000 	ldreq	r0, [r7], #-0
     65c:	00000381 	andeq	r0, r0, r1, lsl #7
     660:	0002ad15 	andeq	sl, r2, r5, lsl sp
     664:	00039700 	andeq	r9, r3, r0, lsl #14
     668:	17001800 	strne	r1, [r0, -r0, lsl #16]
     66c:	0001f004 	andeq	pc, r1, r4
     670:	eb041700 	bl	106278 <__bss_end+0xfc5b8>
     674:	19000001 	stmdbne	r0, {r0}
     678:	00000a3b 	andeq	r0, r0, fp, lsr sl
     67c:	f0149c05 			; <UNDEFINED> instruction: 0xf0149c05
     680:	02000001 	andeq	r0, r0, #1
     684:	000006e3 	andeq	r0, r0, r3, ror #13
     688:	77140406 	ldrvc	r0, [r4, -r6, lsl #8]
     68c:	05000000 	streq	r0, [r0, #-0]
     690:	009bc003 	addseq	ip, fp, r3
     694:	03af0200 			; <UNDEFINED> instruction: 0x03af0200
     698:	07060000 	streq	r0, [r6, -r0]
     69c:	00007714 	andeq	r7, r0, r4, lsl r7
     6a0:	c4030500 	strgt	r0, [r3], #-1280	; 0xfffffb00
     6a4:	0200009b 	andeq	r0, r0, #155	; 0x9b
     6a8:	00000566 	andeq	r0, r0, r6, ror #10
     6ac:	77140a06 	ldrvc	r0, [r4, -r6, lsl #20]
     6b0:	05000000 	streq	r0, [r0, #-0]
     6b4:	009bc803 	addseq	ip, fp, r3, lsl #16
     6b8:	084c0900 	stmdaeq	ip, {r8, fp}^
     6bc:	04050000 	streq	r0, [r5], #-0
     6c0:	00000056 	andeq	r0, r0, r6, asr r0
     6c4:	1c0c0d06 	stcne	13, cr0, [ip], {6}
     6c8:	1a000004 	bne	6e0 <shift+0x6e0>
     6cc:	0077654e 	rsbseq	r6, r7, lr, asr #10
     6d0:	08430a00 	stmdaeq	r3, {r9, fp}^
     6d4:	0a010000 	beq	406dc <__bss_end+0x36a1c>
     6d8:	00000a47 	andeq	r0, r0, r7, asr #20
     6dc:	08260a02 	stmdaeq	r6!, {r1, r9, fp}
     6e0:	0a030000 	beq	c06e8 <__bss_end+0xb6a28>
     6e4:	000007f9 	strdeq	r0, [r0], -r9
     6e8:	09340a04 	ldmdbeq	r4!, {r2, r9, fp}
     6ec:	00050000 	andeq	r0, r5, r0
     6f0:	00065c07 	andeq	r5, r6, r7, lsl #24
     6f4:	1b061000 	blne	1846fc <__bss_end+0x17aa3c>
     6f8:	00045b08 	andeq	r5, r4, r8, lsl #22
     6fc:	726c0800 	rsbvc	r0, ip, #0, 16
     700:	131d0600 	tstne	sp, #0, 12
     704:	0000045b 	andeq	r0, r0, fp, asr r4
     708:	70730800 	rsbsvc	r0, r3, r0, lsl #16
     70c:	131e0600 	tstne	lr, #0, 12
     710:	0000045b 	andeq	r0, r0, fp, asr r4
     714:	63700804 	cmnvs	r0, #4, 16	; 0x40000
     718:	131f0600 	tstne	pc, #0, 12
     71c:	0000045b 	andeq	r0, r0, fp, asr r4
     720:	06720d08 	ldrbteq	r0, [r2], -r8, lsl #26
     724:	20060000 	andcs	r0, r6, r0
     728:	00045b13 	andeq	r5, r4, r3, lsl fp
     72c:	03000c00 	movweq	r0, #3072	; 0xc00
     730:	18b70704 	ldmne	r7!, {r2, r8, r9, sl}
     734:	0e070000 	cdpeq	0, 0, cr0, cr7, cr0, {0}
     738:	70000004 	andvc	r0, r0, r4
     73c:	f2082806 	vadd.i8	d2, d8, d6
     740:	0d000004 	stceq	0, cr0, [r0, #-16]
     744:	00000d66 	andeq	r0, r0, r6, ror #26
     748:	1c122a06 			; <UNDEFINED> instruction: 0x1c122a06
     74c:	00000004 	andeq	r0, r0, r4
     750:	64697008 	strbtvs	r7, [r9], #-8
     754:	122b0600 	eorne	r0, fp, #0, 12
     758:	0000007c 	andeq	r0, r0, ip, ror r0
     75c:	16080d10 			; <UNDEFINED> instruction: 0x16080d10
     760:	2c060000 	stccs	0, cr0, [r6], {-0}
     764:	0003e511 	andeq	lr, r3, r1, lsl r5
     768:	610d1400 	tstvs	sp, r0, lsl #8
     76c:	06000008 	streq	r0, [r0], -r8
     770:	007c122d 	rsbseq	r1, ip, sp, lsr #4
     774:	0d180000 	ldceq	0, cr0, [r8, #-0]
     778:	0000086f 	andeq	r0, r0, pc, ror #16
     77c:	7c122e06 	ldcvc	14, cr2, [r2], {6}
     780:	1c000000 	stcne	0, cr0, [r0], {-0}
     784:	0006450d 	andeq	r4, r6, sp, lsl #10
     788:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 790 <shift+0x790>
     78c:	000004f2 	strdeq	r0, [r0], -r2
     790:	089c0d20 	ldmeq	ip, {r5, r8, sl, fp}
     794:	30060000 	andcc	r0, r6, r0
     798:	00005609 	andeq	r5, r0, r9, lsl #12
     79c:	040d6000 	streq	r6, [sp], #-0
     7a0:	0600000b 	streq	r0, [r0], -fp
     7a4:	006b0e31 	rsbeq	r0, fp, r1, lsr lr
     7a8:	0d640000 	stcleq	0, cr0, [r4, #-0]
     7ac:	000006bc 			; <UNDEFINED> instruction: 0x000006bc
     7b0:	6b0e3306 	blvs	38d3d0 <__bss_end+0x383710>
     7b4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     7b8:	0006b30d 	andeq	fp, r6, sp, lsl #6
     7bc:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     7c0:	0000006b 	andeq	r0, r0, fp, rrx
     7c4:	9d15006c 	ldcls	0, cr0, [r5, #-432]	; 0xfffffe50
     7c8:	02000003 	andeq	r0, r0, #3
     7cc:	16000005 	strne	r0, [r0], -r5
     7d0:	0000007c 	andeq	r0, r0, ip, ror r0
     7d4:	cc02000f 	stcgt	0, cr0, [r2], {15}
     7d8:	0700000c 	streq	r0, [r0, -ip]
     7dc:	0077140a 	rsbseq	r1, r7, sl, lsl #8
     7e0:	03050000 	movweq	r0, #20480	; 0x5000
     7e4:	00009bcc 	andeq	r9, r0, ip, asr #23
     7e8:	00082e09 	andeq	r2, r8, r9, lsl #28
     7ec:	56040500 	strpl	r0, [r4], -r0, lsl #10
     7f0:	07000000 	streq	r0, [r0, -r0]
     7f4:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
     7f8:	160a0000 	strne	r0, [sl], -r0
     7fc:	00000005 	andeq	r0, r0, r5
     800:	0003a40a 	andeq	sl, r3, sl, lsl #8
     804:	07000100 	streq	r0, [r0, -r0, lsl #2]
     808:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     80c:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     810:	00000568 	andeq	r0, r0, r8, ror #10
     814:	0003e00d 	andeq	lr, r3, sp
     818:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     81c:	00000568 	andeq	r0, r0, r8, ror #10
     820:	04cd0d00 	strbeq	r0, [sp], #3328	; 0xd00
     824:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     828:	00056819 	andeq	r6, r5, r9, lsl r8
     82c:	780d0400 	stmdavc	sp, {sl}
     830:	0700000b 	streq	r0, [r0, -fp]
     834:	056e131f 	strbeq	r1, [lr, #-799]!	; 0xfffffce1
     838:	00080000 	andeq	r0, r8, r0
     83c:	05330417 	ldreq	r0, [r3, #-1047]!	; 0xfffffbe9
     840:	04170000 	ldreq	r0, [r7], #-0
     844:	00000462 	andeq	r0, r0, r2, ror #8
     848:	0005790c 	andeq	r7, r5, ip, lsl #18
     84c:	22071400 	andcs	r1, r7, #0, 8
     850:	0007f607 	andeq	pc, r7, r7, lsl #12
     854:	081c0d00 	ldmdaeq	ip, {r8, sl, fp}
     858:	26070000 	strcs	r0, [r7], -r0
     85c:	00006b12 	andeq	r6, r0, r2, lsl fp
     860:	7a0d0000 	bvc	340868 <__bss_end+0x336ba8>
     864:	07000004 	streq	r0, [r0, -r4]
     868:	05681d29 	strbeq	r1, [r8, #-3369]!	; 0xfffff2d7
     86c:	0d040000 	stceq	0, cr0, [r4, #-0]
     870:	00000a9e 	muleq	r0, lr, sl
     874:	681d2c07 	ldmdavs	sp, {r0, r1, r2, sl, fp, sp}
     878:	08000005 	stmdaeq	r0, {r0, r2}
     87c:	000ca21b 	andeq	sl, ip, fp, lsl r2
     880:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     884:	00000bcd 	andeq	r0, r0, sp, asr #23
     888:	000005bc 			; <UNDEFINED> instruction: 0x000005bc
     88c:	000005c7 	andeq	r0, r0, r7, asr #11
     890:	0007fb0f 	andeq	pc, r7, pc, lsl #22
     894:	05681000 	strbeq	r1, [r8, #-0]!
     898:	1c000000 	stcne	0, cr0, [r0], {-0}
     89c:	00000b86 	andeq	r0, r0, r6, lsl #23
     8a0:	e50e3107 	str	r3, [lr, #-263]	; 0xfffffef9
     8a4:	6e000003 	cdpvs	0, 0, cr0, cr0, cr3, {0}
     8a8:	df000003 	svcle	0x00000003
     8ac:	ea000005 	b	8c8 <shift+0x8c8>
     8b0:	0f000005 	svceq	0x00000005
     8b4:	000007fb 	strdeq	r0, [r0], -fp
     8b8:	00056e10 	andeq	r6, r5, r0, lsl lr
     8bc:	03120000 	tsteq	r2, #0
     8c0:	0700000c 	streq	r0, [r0, -ip]
     8c4:	0b531d35 	bleq	14c7da0 <__bss_end+0x14be0e0>
     8c8:	05680000 	strbeq	r0, [r8, #-0]!
     8cc:	03020000 	movweq	r0, #8192	; 0x2000
     8d0:	09000006 	stmdbeq	r0, {r1, r2}
     8d4:	0f000006 	svceq	0x00000006
     8d8:	000007fb 	strdeq	r0, [r0], -fp
     8dc:	07b01200 	ldreq	r1, [r0, r0, lsl #4]!
     8e0:	37070000 	strcc	r0, [r7, -r0]
     8e4:	0009d81d 	andeq	sp, r9, sp, lsl r8
     8e8:	00056800 	andeq	r6, r5, r0, lsl #16
     8ec:	06220200 	strteq	r0, [r2], -r0, lsl #4
     8f0:	06280000 	strteq	r0, [r8], -r0
     8f4:	fb0f0000 	blx	3c08fe <__bss_end+0x3b6c3e>
     8f8:	00000007 	andeq	r0, r0, r7
     8fc:	0008b61d 	andeq	fp, r8, sp, lsl r6
     900:	31390700 	teqcc	r9, r0, lsl #14
     904:	00000814 	andeq	r0, r0, r4, lsl r8
     908:	7912020c 	ldmdbvc	r2, {r2, r3, r9}
     90c:	07000005 	streq	r0, [r0, -r5]
     910:	0d42093c 	vstreq.16	s1, [r2, #-120]	; 0xffffff88	; <UNPREDICTABLE>
     914:	07fb0000 	ldrbeq	r0, [fp, r0]!
     918:	4f010000 	svcmi	0x00010000
     91c:	55000006 	strpl	r0, [r0, #-6]
     920:	0f000006 	svceq	0x00000006
     924:	000007fb 	strdeq	r0, [r0], -fp
     928:	052b1200 	streq	r1, [fp, #-512]!	; 0xfffffe00
     92c:	3f070000 	svccc	0x00070000
     930:	000c7712 	andeq	r7, ip, r2, lsl r7
     934:	00006b00 	andeq	r6, r0, r0, lsl #22
     938:	066e0100 	strbteq	r0, [lr], -r0, lsl #2
     93c:	06830000 	streq	r0, [r3], r0
     940:	fb0f0000 	blx	3c094a <__bss_end+0x3b6c8a>
     944:	10000007 	andne	r0, r0, r7
     948:	0000081d 	andeq	r0, r0, sp, lsl r8
     94c:	00007c10 	andeq	r7, r0, r0, lsl ip
     950:	036e1000 	cmneq	lr, #0
     954:	13000000 	movwne	r0, #0
     958:	00000b95 	muleq	r0, r5, fp
     95c:	540e4207 	strpl	r4, [lr], #-519	; 0xfffffdf9
     960:	01000009 	tsteq	r0, r9
     964:	00000698 	muleq	r0, r8, r6
     968:	0000069e 	muleq	r0, lr, r6
     96c:	0007fb0f 	andeq	pc, r7, pc, lsl #22
     970:	44120000 	ldrmi	r0, [r2], #-0
     974:	07000007 	streq	r0, [r0, -r7]
     978:	04971745 	ldreq	r1, [r7], #1861	; 0x745
     97c:	056e0000 	strbeq	r0, [lr, #-0]!
     980:	b7010000 	strlt	r0, [r1, -r0]
     984:	bd000006 	stclt	0, cr0, [r0, #-24]	; 0xffffffe8
     988:	0f000006 	svceq	0x00000006
     98c:	00000823 	andeq	r0, r0, r3, lsr #16
     990:	04d21200 	ldrbeq	r1, [r2], #512	; 0x200
     994:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
     998:	000b1017 	andeq	r1, fp, r7, lsl r0
     99c:	00056e00 	andeq	r6, r5, r0, lsl #28
     9a0:	06d60100 	ldrbeq	r0, [r6], r0, lsl #2
     9a4:	06e10000 	strbteq	r0, [r1], r0
     9a8:	230f0000 	movwcs	r0, #61440	; 0xf000
     9ac:	10000008 	andne	r0, r0, r8
     9b0:	0000006b 	andeq	r0, r0, fp, rrx
     9b4:	0ce91300 	stcleq	3, cr1, [r9]
     9b8:	4b070000 	blmi	1c09c0 <__bss_end+0x1b6d00>
     9bc:	000b9e0e 	andeq	r9, fp, lr, lsl #28
     9c0:	06f60100 	ldrbteq	r0, [r6], r0, lsl #2
     9c4:	06fc0000 	ldrbteq	r0, [ip], r0
     9c8:	fb0f0000 	blx	3c09d2 <__bss_end+0x3b6d12>
     9cc:	00000007 	andeq	r0, r0, r7
     9d0:	000b8612 	andeq	r8, fp, r2, lsl r6
     9d4:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
     9d8:	00000678 	andeq	r0, r0, r8, ror r6
     9dc:	0000036e 	andeq	r0, r0, lr, ror #6
     9e0:	00071501 	andeq	r1, r7, r1, lsl #10
     9e4:	00072000 	andeq	r2, r7, r0
     9e8:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     9ec:	6b100000 	blvs	4009f4 <__bss_end+0x3f6d34>
     9f0:	00000000 	andeq	r0, r0, r0
     9f4:	00075812 	andeq	r5, r7, r2, lsl r8
     9f8:	12500700 	subsne	r0, r0, #0, 14
     9fc:	00000975 	andeq	r0, r0, r5, ror r9
     a00:	0000006b 	andeq	r0, r0, fp, rrx
     a04:	00073901 	andeq	r3, r7, r1, lsl #18
     a08:	00074400 	andeq	r4, r7, r0, lsl #8
     a0c:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     a10:	9d100000 	ldcls	0, cr0, [r0, #-0]
     a14:	00000003 	andeq	r0, r0, r3
     a18:	00044b12 	andeq	r4, r4, r2, lsl fp
     a1c:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
     a20:	000006fc 	strdeq	r0, [r0], -ip
     a24:	0000036e 	andeq	r0, r0, lr, ror #6
     a28:	00075d01 	andeq	r5, r7, r1, lsl #26
     a2c:	00076800 	andeq	r6, r7, r0, lsl #16
     a30:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     a34:	6b100000 	blvs	400a3c <__bss_end+0x3f6d7c>
     a38:	00000000 	andeq	r0, r0, r0
     a3c:	00078a13 	andeq	r8, r7, r3, lsl sl
     a40:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
     a44:	00000c0f 	andeq	r0, r0, pc, lsl #24
     a48:	00077d01 	andeq	r7, r7, r1, lsl #26
     a4c:	00079c00 	andeq	r9, r7, r0, lsl #24
     a50:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     a54:	a9100000 	ldmdbge	r0, {}	; <UNPREDICTABLE>
     a58:	10000000 	andne	r0, r0, r0
     a5c:	0000006b 	andeq	r0, r0, fp, rrx
     a60:	00006b10 	andeq	r6, r0, r0, lsl fp
     a64:	006b1000 	rsbeq	r1, fp, r0
     a68:	29100000 	ldmdbcs	r0, {}	; <UNPREDICTABLE>
     a6c:	00000008 	andeq	r0, r0, r8
     a70:	000b3d13 	andeq	r3, fp, r3, lsl sp
     a74:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
     a78:	000005ed 	andeq	r0, r0, sp, ror #11
     a7c:	0007b101 	andeq	fp, r7, r1, lsl #2
     a80:	0007d000 	andeq	sp, r7, r0
     a84:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     a88:	e0100000 	ands	r0, r0, r0
     a8c:	10000000 	andne	r0, r0, r0
     a90:	0000006b 	andeq	r0, r0, fp, rrx
     a94:	00006b10 	andeq	r6, r0, r0, lsl fp
     a98:	006b1000 	rsbeq	r1, fp, r0
     a9c:	29100000 	ldmdbcs	r0, {}	; <UNPREDICTABLE>
     aa0:	00000008 	andeq	r0, r0, r8
     aa4:	00055314 	andeq	r5, r5, r4, lsl r3
     aa8:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
     aac:	000005aa 	andeq	r0, r0, sl, lsr #11
     ab0:	0000036e 	andeq	r0, r0, lr, ror #6
     ab4:	0007e501 	andeq	lr, r7, r1, lsl #10
     ab8:	07fb0f00 	ldrbeq	r0, [fp, r0, lsl #30]!
     abc:	14100000 	ldrne	r0, [r0], #-0
     ac0:	10000005 	andne	r0, r0, r5
     ac4:	0000082f 	andeq	r0, r0, pc, lsr #16
     ac8:	74040000 	strvc	r0, [r4], #-0
     acc:	17000005 	strne	r0, [r0, -r5]
     ad0:	00057404 	andeq	r7, r5, r4, lsl #8
     ad4:	05681e00 	strbeq	r1, [r8, #-3584]!	; 0xfffff200
     ad8:	080e0000 	stmdaeq	lr, {}	; <UNPREDICTABLE>
     adc:	08140000 	ldmdaeq	r4, {}	; <UNPREDICTABLE>
     ae0:	fb0f0000 	blx	3c0aea <__bss_end+0x3b6e2a>
     ae4:	00000007 	andeq	r0, r0, r7
     ae8:	0005741f 	andeq	r7, r5, pc, lsl r4
     aec:	00080100 	andeq	r0, r8, r0, lsl #2
     af0:	5d041700 	stcpl	7, cr1, [r4, #-0]
     af4:	17000000 	strne	r0, [r0, -r0]
     af8:	0007f604 	andeq	pc, r7, r4, lsl #12
     afc:	83042000 	movwhi	r2, #16384	; 0x4000
     b00:	21000000 	mrscs	r0, (UNDEF: 0)
     b04:	08c41904 	stmiaeq	r4, {r2, r8, fp, ip}^
     b08:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
     b0c:	00057419 	andeq	r7, r5, r9, lsl r4
     b10:	03bf0900 			; <UNDEFINED> instruction: 0x03bf0900
     b14:	04050000 	streq	r0, [r5], #-0
     b18:	00000056 	andeq	r0, r0, r6, asr r0
     b1c:	5c0c0308 	stcpl	3, cr0, [ip], {8}
     b20:	0a000008 	beq	b48 <shift+0xb48>
     b24:	000006d5 	ldrdeq	r0, [r0], -r5
     b28:	06dc0a00 	ldrbeq	r0, [ip], r0, lsl #20
     b2c:	00010000 	andeq	r0, r1, r0
     b30:	0006c509 	andeq	ip, r6, r9, lsl #10
     b34:	56040500 	strpl	r0, [r4], -r0, lsl #10
     b38:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     b3c:	08a90c09 	stmiaeq	r9!, {r0, r3, sl, fp}
     b40:	c4220000 	strtgt	r0, [r2], #-0
     b44:	b000000c 	andlt	r0, r0, ip
     b48:	03d82204 	bicseq	r2, r8, #4, 4	; 0x40000000
     b4c:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
     b50:	0004c522 	andeq	ip, r4, r2, lsr #10
     b54:	2212c000 	andscs	ip, r2, #0
     b58:	00000cff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     b5c:	7d222580 	cfstr32vc	mvfx2, [r2, #-512]!	; 0xfffffe00
     b60:	0000000b 	andeq	r0, r0, fp
     b64:	0858224b 	ldmdaeq	r8, {r0, r1, r3, r6, r9, sp}^
     b68:	96000000 	strls	r0, [r0], -r0
     b6c:	00039b22 	andeq	r9, r3, r2, lsr #22
     b70:	23e10000 	mvncs	r0, #0
     b74:	000008ac 	andeq	r0, r0, ip, lsr #17
     b78:	0001c200 	andeq	ip, r1, r0, lsl #4
     b7c:	09160700 	ldmdbeq	r6, {r8, r9, sl}
     b80:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     b84:	08d10816 	ldmeq	r1, {r1, r2, r4, fp}^
     b88:	dc0d0000 	stcle	0, cr0, [sp], {-0}
     b8c:	0800000a 	stmdaeq	r0, {r1, r3}
     b90:	083d1718 	ldmdaeq	sp!, {r3, r4, r8, r9, sl, ip}
     b94:	0d000000 	stceq	0, cr0, [r0, #-0]
     b98:	0000048d 	andeq	r0, r0, sp, lsl #9
     b9c:	5c151908 			; <UNDEFINED> instruction: 0x5c151908
     ba0:	04000008 	streq	r0, [r0], #-8
     ba4:	0d372400 	cfldrseq	mvf2, [r7, #-0]
     ba8:	17010000 	strne	r0, [r1, -r0]
     bac:	00005605 	andeq	r5, r0, r5, lsl #12
     bb0:	0082a000 	addeq	sl, r2, r0
     bb4:	0002b800 	andeq	fp, r2, r0, lsl #16
     bb8:	b09c0100 	addslt	r0, ip, r0, lsl #2
     bbc:	25000009 	strcs	r0, [r0, #-9]
     bc0:	00000d14 	andeq	r0, r0, r4, lsl sp
     bc4:	560e1701 	strpl	r1, [lr], -r1, lsl #14
     bc8:	03000000 	movweq	r0, #0
     bcc:	2577bc91 	ldrbcs	fp, [r7, #-3217]!	; 0xfffff36f
     bd0:	00000c61 	andeq	r0, r0, r1, ror #24
     bd4:	b01b1701 	andslt	r1, fp, r1, lsl #14
     bd8:	03000009 	movweq	r0, #9
     bdc:	2677b891 			; <UNDEFINED> instruction: 0x2677b891
     be0:	00000a14 	andeq	r0, r0, r4, lsl sl
     be4:	6b0b1901 	blvs	2c6ff0 <__bss_end+0x2bd330>
     be8:	02000000 	andeq	r0, r0, #0
     bec:	e8267091 	stmda	r6!, {r0, r4, r7, ip, sp, lr}
     bf0:	0100000a 	tsteq	r0, sl
     bf4:	08a9151b 	stmiaeq	r9!, {r0, r1, r3, r4, r8, sl, ip}
     bf8:	91020000 	mrsls	r0, (UNDEF: 2)
     bfc:	7562275c 	strbvc	r2, [r2, #-1884]!	; 0xfffff8a4
     c00:	22010066 	andcs	r0, r1, #102	; 0x66
     c04:	0009bc07 	andeq	fp, r9, r7, lsl #24
     c08:	f4910300 			; <UNDEFINED> instruction: 0xf4910300
     c0c:	045e2677 	ldrbeq	r2, [lr], #-1655	; 0xfffff989
     c10:	23010000 	movwcs	r0, #4096	; 0x1000
     c14:	00035e07 	andeq	r5, r3, r7, lsl #28
     c18:	e4910300 	ldr	r0, [r1], #768	; 0x300
     c1c:	0a982677 	beq	fe60a600 <__bss_end+0xfe600940>
     c20:	27010000 	strcs	r0, [r1, -r0]
     c24:	00003708 	andeq	r3, r0, r8, lsl #14
     c28:	6c910200 	lfmvs	f0, 4, [r1], {0}
     c2c:	00093b26 	andeq	r3, r9, r6, lsr #22
     c30:	07280100 	streq	r0, [r8, -r0, lsl #2]!
     c34:	000009cd 	andeq	r0, r0, sp, asr #19
     c38:	77c49103 	strbvc	r9, [r4, r3, lsl #2]
     c3c:	00838c28 	addeq	r8, r3, r8, lsr #24
     c40:	00019000 	andeq	r9, r1, r0
     c44:	00762700 	rsbseq	r2, r6, r0, lsl #14
     c48:	6b0c3201 	blvs	30d454 <__bss_end+0x303794>
     c4c:	02000000 	andeq	r0, r0, #0
     c50:	64286891 	strtvs	r6, [r8], #-2193	; 0xfffff76f
     c54:	90000084 	andls	r0, r0, r4, lsl #1
     c58:	27000000 	strcs	r0, [r0, -r0]
     c5c:	41010069 	tstmi	r1, r9, rrx
     c60:	00006b12 	andeq	r6, r0, r2, lsl fp
     c64:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c68:	00847c28 	addeq	r7, r4, r8, lsr #24
     c6c:	00006800 	andeq	r6, r0, r0, lsl #16
     c70:	046d2600 	strbteq	r2, [sp], #-1536	; 0xfffffa00
     c74:	43010000 	movwmi	r0, #4096	; 0x1000
     c78:	00005609 	andeq	r5, r0, r9, lsl #12
     c7c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     c80:	00000000 	andeq	r0, r0, r0
     c84:	09b60417 	ldmibeq	r6!, {r0, r1, r2, r4, sl}
     c88:	04170000 	ldreq	r0, [r7], #-0
     c8c:	00000043 	andeq	r0, r0, r3, asr #32
     c90:	00004315 	andeq	r4, r0, r5, lsl r3
     c94:	0009cd00 	andeq	ip, r9, r0, lsl #26
     c98:	007c2900 	rsbseq	r2, ip, r0, lsl #18
     c9c:	03e70000 	mvneq	r0, #0
     ca0:	00431500 	subeq	r1, r3, r0, lsl #10
     ca4:	09dd0000 	ldmibeq	sp, {}^	; <UNPREDICTABLE>
     ca8:	7c160000 	ldcvc	0, cr0, [r6], {-0}
     cac:	1f000000 	svcne	0x00000000
     cb0:	08a62a00 	stmiaeq	r6!, {r9, fp, sp}
     cb4:	12010000 	andne	r0, r1, #0
     cb8:	00006b11 	andeq	r6, r0, r1, lsl fp
     cbc:	00826800 	addeq	r6, r2, r0, lsl #16
     cc0:	00003800 	andeq	r3, r0, r0, lsl #16
     cc4:	259c0100 	ldrcs	r0, [ip, #256]	; 0x100
     cc8:	2500000a 	strcs	r0, [r0, #-10]
     ccc:	00000a19 	andeq	r0, r0, r9, lsl sl
     cd0:	6b201201 	blvs	8054dc <__bss_end+0x7fb81c>
     cd4:	02000000 	andeq	r0, r0, #0
     cd8:	66257491 			; <UNDEFINED> instruction: 0x66257491
     cdc:	01000004 	tsteq	r0, r4
     ce0:	09b62c12 	ldmibeq	r6!, {r1, r4, sl, fp, sp}
     ce4:	91020000 	mrsls	r0, (UNDEF: 2)
     ce8:	0f7b2570 	svceq	0x007b2570
     cec:	12010000 	andne	r0, r1, #0
     cf0:	00006b3d 	andeq	r6, r0, sp, lsr fp
     cf4:	6c910200 	lfmvs	f0, 4, [r1], {0}
     cf8:	09042b00 	stmdbeq	r4, {r8, r9, fp, sp}
     cfc:	0d010000 	stceq	0, cr0, [r1, #-0]
     d00:	00822c0d 	addeq	r2, r2, sp, lsl #24
     d04:	00003c00 	andeq	r3, r0, r0, lsl #24
     d08:	259c0100 	ldrcs	r0, [ip, #256]	; 0x100
     d0c:	00000a19 	andeq	r0, r0, r9, lsl sl
     d10:	6b1c0d01 	blvs	70411c <__bss_end+0x6fa45c>
     d14:	02000000 	andeq	r0, r0, #0
     d18:	d1257491 			; <UNDEFINED> instruction: 0xd1257491
     d1c:	01000003 	tsteq	r0, r3
     d20:	037b2e0d 	cmneq	fp, #13, 28	; 0xd0
     d24:	91020000 	mrsls	r0, (UNDEF: 2)
     d28:	f5000070 			; <UNDEFINED> instruction: 0xf5000070
     d2c:	0400000c 	streq	r0, [r0], #-12
     d30:	00046d00 	andeq	r6, r4, r0, lsl #26
     d34:	73010400 	movwvc	r0, #5120	; 0x1400
     d38:	04000010 	streq	r0, [r0], #-16
     d3c:	00000e90 	muleq	r0, r0, lr
     d40:	00000f1b 	andeq	r0, r0, fp, lsl pc
     d44:	00008558 	andeq	r8, r0, r8, asr r5
     d48:	0000045c 	andeq	r0, r0, ip, asr r4
     d4c:	000004aa 	andeq	r0, r0, sl, lsr #9
     d50:	d3080102 	movwle	r0, #33026	; 0x8102
     d54:	03000009 	movweq	r0, #9
     d58:	00000025 	andeq	r0, r0, r5, lsr #32
     d5c:	0a050202 	beq	14156c <__bss_end+0x1378ac>
     d60:	0400000a 	streq	r0, [r0], #-10
     d64:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     d68:	01020074 	tsteq	r2, r4, ror r0
     d6c:	0009ca08 	andeq	ip, r9, r8, lsl #20
     d70:	07020200 	streq	r0, [r2, -r0, lsl #4]
     d74:	0000079d 	muleq	r0, sp, r7
     d78:	000a4f05 	andeq	r4, sl, r5, lsl #30
     d7c:	07090800 	streq	r0, [r9, -r0, lsl #16]
     d80:	0000005e 	andeq	r0, r0, lr, asr r0
     d84:	00004d03 	andeq	r4, r0, r3, lsl #26
     d88:	07040200 	streq	r0, [r4, -r0, lsl #4]
     d8c:	000018bc 			; <UNDEFINED> instruction: 0x000018bc
     d90:	00063906 	andeq	r3, r6, r6, lsl #18
     d94:	06020800 	streq	r0, [r2], -r0, lsl #16
     d98:	00008b08 	andeq	r8, r0, r8, lsl #22
     d9c:	30720700 	rsbscc	r0, r2, r0, lsl #14
     da0:	0e080200 	cdpeq	2, 0, cr0, cr8, cr0, {0}
     da4:	0000004d 	andeq	r0, r0, sp, asr #32
     da8:	31720700 	cmncc	r2, r0, lsl #14
     dac:	0e090200 	cdpeq	2, 0, cr0, cr9, cr0, {0}
     db0:	0000004d 	andeq	r0, r0, sp, asr #32
     db4:	b9080004 	stmdblt	r8, {r2}
     db8:	0500000f 	streq	r0, [r0, #-15]
     dbc:	00003804 	andeq	r3, r0, r4, lsl #16
     dc0:	0c0d0200 	sfmeq	f0, 4, [sp], {-0}
     dc4:	000000a9 	andeq	r0, r0, r9, lsr #1
     dc8:	004b4f09 	subeq	r4, fp, r9, lsl #30
     dcc:	0df30a00 			; <UNDEFINED> instruction: 0x0df30a00
     dd0:	00010000 	andeq	r0, r1, r0
     dd4:	0004fc08 	andeq	pc, r4, r8, lsl #24
     dd8:	38040500 	stmdacc	r4, {r8, sl}
     ddc:	02000000 	andeq	r0, r0, #0
     de0:	00e00c1e 	rsceq	r0, r0, lr, lsl ip
     de4:	a00a0000 	andge	r0, sl, r0
     de8:	00000006 	andeq	r0, r0, r6
     dec:	000d720a 	andeq	r7, sp, sl, lsl #4
     df0:	3c0a0100 	stfccs	f0, [sl], {-0}
     df4:	0200000d 	andeq	r0, r0, #13
     df8:	0008070a 	andeq	r0, r8, sl, lsl #14
     dfc:	450a0300 	strmi	r0, [sl, #-768]	; 0xfffffd00
     e00:	04000009 	streq	r0, [r0], #-9
     e04:	0006690a 	andeq	r6, r6, sl, lsl #18
     e08:	08000500 	stmdaeq	r0, {r8, sl}
     e0c:	00000cac 	andeq	r0, r0, ip, lsr #25
     e10:	00380405 	eorseq	r0, r8, r5, lsl #8
     e14:	3f020000 	svccc	0x00020000
     e18:	00011d0c 	andeq	r1, r1, ip, lsl #26
     e1c:	03ba0a00 			; <UNDEFINED> instruction: 0x03ba0a00
     e20:	0a000000 	beq	e28 <shift+0xe28>
     e24:	00000511 	andeq	r0, r0, r1, lsl r5
     e28:	092e0a01 	stmdbeq	lr!, {r0, r9, fp}
     e2c:	0a020000 	beq	80e34 <__bss_end+0x77174>
     e30:	00000d07 	andeq	r0, r0, r7, lsl #26
     e34:	0d7c0a03 	vldmdbeq	ip!, {s1-s3}
     e38:	0a040000 	beq	100e40 <__bss_end+0xf7180>
     e3c:	000008e6 	andeq	r0, r0, r6, ror #17
     e40:	07bd0a05 	ldreq	r0, [sp, r5, lsl #20]!
     e44:	00060000 	andeq	r0, r6, r0
     e48:	000c6608 	andeq	r6, ip, r8, lsl #12
     e4c:	38040500 	stmdacc	r4, {r8, sl}
     e50:	02000000 	andeq	r0, r0, #0
     e54:	01480c66 	cmpeq	r8, r6, ror #24
     e58:	a80a0000 	stmdage	sl, {}	; <UNPREDICTABLE>
     e5c:	00000009 	andeq	r0, r0, r9
     e60:	00077f0a 	andeq	r7, r7, sl, lsl #30
     e64:	1e0a0100 	adfnee	f0, f2, f0
     e68:	0200000a 	andeq	r0, r0, #10
     e6c:	0007c20a 	andeq	ip, r7, sl, lsl #4
     e70:	0b000300 	bleq	1a78 <shift+0x1a78>
     e74:	000008ed 	andeq	r0, r0, sp, ror #17
     e78:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     e7c:	05000000 	streq	r0, [r0, #-0]
     e80:	009c5c03 	addseq	r5, ip, r3, lsl #24
     e84:	090a0b00 	stmdbeq	sl, {r8, r9, fp}
     e88:	06030000 	streq	r0, [r3], -r0
     e8c:	00005914 	andeq	r5, r0, r4, lsl r9
     e90:	60030500 	andvs	r0, r3, r0, lsl #10
     e94:	0b00009c 	bleq	110c <shift+0x110c>
     e98:	000008d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     e9c:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     ea0:	05000000 	streq	r0, [r0, #-0]
     ea4:	009c6403 	addseq	r6, ip, r3, lsl #8
     ea8:	05410b00 	strbeq	r0, [r1, #-2816]	; 0xfffff500
     eac:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     eb0:	0000591a 	andeq	r5, r0, sl, lsl r9
     eb4:	68030500 	stmdavs	r3, {r8, sl}
     eb8:	0b00009c 	bleq	1130 <shift+0x1130>
     ebc:	000009bc 			; <UNDEFINED> instruction: 0x000009bc
     ec0:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     ec4:	05000000 	streq	r0, [r0, #-0]
     ec8:	009c6c03 	addseq	r6, ip, r3, lsl #24
     ecc:	076c0b00 	strbeq	r0, [ip, -r0, lsl #22]!
     ed0:	0d040000 	stceq	0, cr0, [r4, #-0]
     ed4:	0000591a 	andeq	r5, r0, sl, lsl r9
     ed8:	70030500 	andvc	r0, r3, r0, lsl #10
     edc:	0b00009c 	bleq	1154 <shift+0x1154>
     ee0:	00000652 	andeq	r0, r0, r2, asr r6
     ee4:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     ee8:	05000000 	streq	r0, [r0, #-0]
     eec:	009c7403 	addseq	r7, ip, r3, lsl #8
     ef0:	0acc0800 	beq	ff302ef8 <__bss_end+0xff2f9238>
     ef4:	04050000 	streq	r0, [r5], #-0
     ef8:	00000038 	andeq	r0, r0, r8, lsr r0
     efc:	eb0c1b04 	bl	307b14 <__bss_end+0x2fde54>
     f00:	0a000001 	beq	f0c <shift+0xf0c>
     f04:	00000afa 	strdeq	r0, [r0], -sl
     f08:	0d2c0a00 	vstmdbeq	ip!, {s0-s-1}
     f0c:	0a010000 	beq	40f14 <__bss_end+0x37254>
     f10:	00000929 	andeq	r0, r0, r9, lsr #18
     f14:	a20c0002 	andge	r0, ip, #2
     f18:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
     f1c:	000009fe 	strdeq	r0, [r0], -lr
     f20:	07630490 			; <UNDEFINED> instruction: 0x07630490
     f24:	0000035e 	andeq	r0, r0, lr, asr r3
     f28:	000cdb06 	andeq	sp, ip, r6, lsl #22
     f2c:	67042400 	strvs	r2, [r4, -r0, lsl #8]
     f30:	00027810 	andeq	r7, r2, r0, lsl r8
     f34:	1c2c0e00 	stcne	14, cr0, [ip], #-0
     f38:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
     f3c:	00035e12 	andeq	r5, r3, r2, lsl lr
     f40:	f00e0000 			; <UNDEFINED> instruction: 0xf00e0000
     f44:	04000004 	streq	r0, [r0], #-4
     f48:	036e126b 	cmneq	lr, #-1342177274	; 0xb0000006
     f4c:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     f50:	00000aef 	andeq	r0, r0, pc, ror #21
     f54:	4d166d04 	ldcmi	13, cr6, [r6, #-16]
     f58:	14000000 	strne	r0, [r0], #-0
     f5c:	00053a0e 	andeq	r3, r5, lr, lsl #20
     f60:	1c700400 	cfldrdne	mvd0, [r0], #-0
     f64:	00000375 	andeq	r0, r0, r5, ror r3
     f68:	09b30e18 	ldmibeq	r3!, {r3, r4, r9, sl, fp}
     f6c:	72040000 	andvc	r0, r4, #0
     f70:	0003751c 	andeq	r7, r3, ip, lsl r5
     f74:	cd0e1c00 	stcgt	12, cr1, [lr, #-0]
     f78:	04000004 	streq	r0, [r0], #-4
     f7c:	03751c75 	cmneq	r5, #29952	; 0x7500
     f80:	0f200000 	svceq	0x00200000
     f84:	000006a8 	andeq	r0, r0, r8, lsr #13
     f88:	1b1c7704 	blne	71eba0 <__bss_end+0x714ee0>
     f8c:	75000004 	strvc	r0, [r0, #-4]
     f90:	6c000003 	stcvs	0, cr0, [r0], {3}
     f94:	10000002 	andne	r0, r0, r2
     f98:	00000375 	andeq	r0, r0, r5, ror r3
     f9c:	00037b11 	andeq	r7, r3, r1, lsl fp
     fa0:	06000000 	streq	r0, [r0], -r0
     fa4:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
     fa8:	107b0418 	rsbsne	r0, fp, r8, lsl r4
     fac:	000002ad 	andeq	r0, r0, sp, lsr #5
     fb0:	001c2c0e 	andseq	r2, ip, lr, lsl #24
     fb4:	127e0400 	rsbsne	r0, lr, #0, 8
     fb8:	0000035e 	andeq	r0, r0, lr, asr r3
     fbc:	04e50e00 	strbteq	r0, [r5], #3584	; 0xe00
     fc0:	80040000 	andhi	r0, r4, r0
     fc4:	00037b19 	andeq	r7, r3, r9, lsl fp
     fc8:	0d0e1000 	stceq	0, cr1, [lr, #-0]
     fcc:	0400000d 	streq	r0, [r0], #-13
     fd0:	03862182 	orreq	r2, r6, #-2147483616	; 0x80000020
     fd4:	00140000 	andseq	r0, r4, r0
     fd8:	00027803 	andeq	r7, r2, r3, lsl #16
     fdc:	08901200 	ldmeq	r0, {r9, ip}
     fe0:	86040000 	strhi	r0, [r4], -r0
     fe4:	00038c21 	andeq	r8, r3, r1, lsr #24
     fe8:	07281200 	streq	r1, [r8, -r0, lsl #4]!
     fec:	88040000 	stmdahi	r4, {}	; <UNPREDICTABLE>
     ff0:	0000591f 	andeq	r5, r0, pc, lsl r9
     ff4:	0a350e00 	beq	d447fc <__bss_end+0xd3ab3c>
     ff8:	8b040000 	blhi	101000 <__bss_end+0xf7340>
     ffc:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    1000:	0d0e0000 	stceq	0, cr0, [lr, #-0]
    1004:	04000008 	streq	r0, [r0], #-8
    1008:	01fd178e 	mvnseq	r1, lr, lsl #15
    100c:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
    1010:	0000073a 	andeq	r0, r0, sl, lsr r7
    1014:	fd178f04 	ldc2	15, cr8, [r7, #-16]
    1018:	48000001 	stmdami	r0, {r0}
    101c:	000d5c0e 	andeq	r5, sp, lr, lsl #24
    1020:	17900400 	ldrne	r0, [r0, r0, lsl #8]
    1024:	000001fd 	strdeq	r0, [r0], -sp
    1028:	09fe136c 	ldmibeq	lr!, {r2, r3, r5, r6, r8, r9, ip}^
    102c:	93040000 	movwls	r0, #16384	; 0x4000
    1030:	00058a09 	andeq	r8, r5, r9, lsl #20
    1034:	00039700 	andeq	r9, r3, r0, lsl #14
    1038:	03170100 	tsteq	r7, #0, 2
    103c:	031d0000 	tsteq	sp, #0
    1040:	97100000 	ldrls	r0, [r0, -r0]
    1044:	00000003 	andeq	r0, r0, r3
    1048:	00088514 	andeq	r8, r8, r4, lsl r5
    104c:	0e960400 	cdpeq	4, 9, cr0, cr6, cr0, {0}
    1050:	000007da 	ldrdeq	r0, [r0], -sl
    1054:	00033201 	andeq	r3, r3, r1, lsl #4
    1058:	00033800 	andeq	r3, r3, r0, lsl #16
    105c:	03971000 	orrseq	r1, r7, #0
    1060:	15000000 	strne	r0, [r0, #-0]
    1064:	000003ba 			; <UNDEFINED> instruction: 0x000003ba
    1068:	b1109904 	tstlt	r0, r4, lsl #18
    106c:	9d00000a 	stcls	0, cr0, [r0, #-40]	; 0xffffffd8
    1070:	01000003 	tsteq	r0, r3
    1074:	0000034d 	andeq	r0, r0, sp, asr #6
    1078:	00039710 	andeq	r9, r3, r0, lsl r7
    107c:	037b1100 	cmneq	fp, #0, 2
    1080:	c6110000 	ldrgt	r0, [r1], -r0
    1084:	00000001 	andeq	r0, r0, r1
    1088:	00251600 	eoreq	r1, r5, r0, lsl #12
    108c:	036e0000 	cmneq	lr, #0
    1090:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1094:	0f000000 	svceq	0x00000000
    1098:	02010200 	andeq	r0, r1, #0, 4
    109c:	00000817 	andeq	r0, r0, r7, lsl r8
    10a0:	01fd0418 	mvnseq	r0, r8, lsl r4
    10a4:	04180000 	ldreq	r0, [r8], #-0
    10a8:	0000002c 	andeq	r0, r0, ip, lsr #32
    10ac:	000d190c 	andeq	r1, sp, ip, lsl #18
    10b0:	81041800 	tsthi	r4, r0, lsl #16
    10b4:	16000003 	strne	r0, [r0], -r3
    10b8:	000002ad 	andeq	r0, r0, sp, lsr #5
    10bc:	00000397 	muleq	r0, r7, r3
    10c0:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
    10c4:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    10c8:	01eb0418 	mvneq	r0, r8, lsl r4
    10cc:	3b1a0000 	blcc	6810d4 <__bss_end+0x677414>
    10d0:	0400000a 	streq	r0, [r0], #-10
    10d4:	01f0149c 			; <UNDEFINED> instruction: 0x01f0149c
    10d8:	e30b0000 	movw	r0, #45056	; 0xb000
    10dc:	05000006 	streq	r0, [r0, #-6]
    10e0:	00591404 	subseq	r1, r9, r4, lsl #8
    10e4:	03050000 	movweq	r0, #20480	; 0x5000
    10e8:	00009c78 	andeq	r9, r0, r8, ror ip
    10ec:	0003af0b 	andeq	sl, r3, fp, lsl #30
    10f0:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
    10f4:	00000059 	andeq	r0, r0, r9, asr r0
    10f8:	9c7c0305 	ldclls	3, cr0, [ip], #-20	; 0xffffffec
    10fc:	660b0000 	strvs	r0, [fp], -r0
    1100:	05000005 	streq	r0, [r0, #-5]
    1104:	0059140a 	subseq	r1, r9, sl, lsl #8
    1108:	03050000 	movweq	r0, #20480	; 0x5000
    110c:	00009c80 	andeq	r9, r0, r0, lsl #25
    1110:	00084c08 	andeq	r4, r8, r8, lsl #24
    1114:	38040500 	stmdacc	r4, {r8, sl}
    1118:	05000000 	streq	r0, [r0, #-0]
    111c:	041c0c0d 	ldreq	r0, [ip], #-3085	; 0xfffff3f3
    1120:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
    1124:	00007765 	andeq	r7, r0, r5, ror #14
    1128:	0008430a 	andeq	r4, r8, sl, lsl #6
    112c:	470a0100 	strmi	r0, [sl, -r0, lsl #2]
    1130:	0200000a 	andeq	r0, r0, #10
    1134:	0008260a 	andeq	r2, r8, sl, lsl #12
    1138:	f90a0300 			; <UNDEFINED> instruction: 0xf90a0300
    113c:	04000007 	streq	r0, [r0], #-7
    1140:	0009340a 	andeq	r3, r9, sl, lsl #8
    1144:	06000500 	streq	r0, [r0], -r0, lsl #10
    1148:	0000065c 	andeq	r0, r0, ip, asr r6
    114c:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
    1150:	0000045b 	andeq	r0, r0, fp, asr r4
    1154:	00726c07 	rsbseq	r6, r2, r7, lsl #24
    1158:	5b131d05 	blpl	4c8574 <__bss_end+0x4be8b4>
    115c:	00000004 	andeq	r0, r0, r4
    1160:	00707307 	rsbseq	r7, r0, r7, lsl #6
    1164:	5b131e05 	blpl	4c8980 <__bss_end+0x4becc0>
    1168:	04000004 	streq	r0, [r0], #-4
    116c:	00637007 	rsbeq	r7, r3, r7
    1170:	5b131f05 	blpl	4c8d8c <__bss_end+0x4bf0cc>
    1174:	08000004 	stmdaeq	r0, {r2}
    1178:	0006720e 	andeq	r7, r6, lr, lsl #4
    117c:	13200500 	nopne	{0}	; <UNPREDICTABLE>
    1180:	0000045b 	andeq	r0, r0, fp, asr r4
    1184:	0402000c 	streq	r0, [r2], #-12
    1188:	0018b707 	andseq	fp, r8, r7, lsl #14
    118c:	040e0600 	streq	r0, [lr], #-1536	; 0xfffffa00
    1190:	05700000 	ldrbeq	r0, [r0, #-0]!
    1194:	04f20828 	ldrbteq	r0, [r2], #2088	; 0x828
    1198:	660e0000 	strvs	r0, [lr], -r0
    119c:	0500000d 	streq	r0, [r0, #-13]
    11a0:	041c122a 	ldreq	r1, [ip], #-554	; 0xfffffdd6
    11a4:	07000000 	streq	r0, [r0, -r0]
    11a8:	00646970 	rsbeq	r6, r4, r0, ror r9
    11ac:	5e122b05 	vnmlspl.f64	d2, d2, d5
    11b0:	10000000 	andne	r0, r0, r0
    11b4:	0016080e 	andseq	r0, r6, lr, lsl #16
    11b8:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
    11bc:	000003e5 	andeq	r0, r0, r5, ror #7
    11c0:	08610e14 	stmdaeq	r1!, {r2, r4, r9, sl, fp}^
    11c4:	2d050000 	stccs	0, cr0, [r5, #-0]
    11c8:	00005e12 	andeq	r5, r0, r2, lsl lr
    11cc:	6f0e1800 	svcvs	0x000e1800
    11d0:	05000008 	streq	r0, [r0, #-8]
    11d4:	005e122e 	subseq	r1, lr, lr, lsr #4
    11d8:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    11dc:	00000645 	andeq	r0, r0, r5, asr #12
    11e0:	f20c2f05 	vmax.f32	d2, d12, d5
    11e4:	20000004 	andcs	r0, r0, r4
    11e8:	00089c0e 	andeq	r9, r8, lr, lsl #24
    11ec:	09300500 	ldmdbeq	r0!, {r8, sl}
    11f0:	00000038 	andeq	r0, r0, r8, lsr r0
    11f4:	0b040e60 	bleq	104b7c <__bss_end+0xfaebc>
    11f8:	31050000 	mrscc	r0, (UNDEF: 5)
    11fc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1200:	bc0e6400 	cfstrslt	mvf6, [lr], {-0}
    1204:	05000006 	streq	r0, [r0, #-6]
    1208:	004d0e33 	subeq	r0, sp, r3, lsr lr
    120c:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
    1210:	000006b3 			; <UNDEFINED> instruction: 0x000006b3
    1214:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
    1218:	6c000000 	stcvs	0, cr0, [r0], {-0}
    121c:	039d1600 	orrseq	r1, sp, #0, 12
    1220:	05020000 	streq	r0, [r2, #-0]
    1224:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1228:	0f000000 	svceq	0x00000000
    122c:	0ccc0b00 	vstmiaeq	ip, {d16-d15}
    1230:	0a060000 	beq	181238 <__bss_end+0x177578>
    1234:	00005914 	andeq	r5, r0, r4, lsl r9
    1238:	84030500 	strhi	r0, [r3], #-1280	; 0xfffffb00
    123c:	0800009c 	stmdaeq	r0, {r2, r3, r4, r7}
    1240:	0000082e 	andeq	r0, r0, lr, lsr #16
    1244:	00380405 	eorseq	r0, r8, r5, lsl #8
    1248:	0d060000 	stceq	0, cr0, [r6, #-0]
    124c:	0005330c 	andeq	r3, r5, ip, lsl #6
    1250:	05160a00 	ldreq	r0, [r6, #-2560]	; 0xfffff600
    1254:	0a000000 	beq	125c <shift+0x125c>
    1258:	000003a4 	andeq	r0, r0, r4, lsr #7
    125c:	14030001 	strne	r0, [r3], #-1
    1260:	08000005 	stmdaeq	r0, {r0, r2}
    1264:	00000ef7 	strdeq	r0, [r0], -r7
    1268:	00380405 	eorseq	r0, r8, r5, lsl #8
    126c:	14060000 	strne	r0, [r6], #-0
    1270:	0005570c 	andeq	r5, r5, ip, lsl #14
    1274:	0d880a00 	vstreq	s0, [r8]
    1278:	0a000000 	beq	1280 <shift+0x1280>
    127c:	00000f8b 	andeq	r0, r0, fp, lsl #31
    1280:	38030001 	stmdacc	r3, {r0}
    1284:	06000005 	streq	r0, [r0], -r5
    1288:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    128c:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
    1290:	00000591 	muleq	r0, r1, r5
    1294:	0003e00e 	andeq	lr, r3, lr
    1298:	191d0600 	ldmdbne	sp, {r9, sl}
    129c:	00000591 	muleq	r0, r1, r5
    12a0:	04cd0e00 	strbeq	r0, [sp], #3584	; 0xe00
    12a4:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
    12a8:	00059119 	andeq	r9, r5, r9, lsl r1
    12ac:	780e0400 	stmdavc	lr, {sl}
    12b0:	0600000b 	streq	r0, [r0], -fp
    12b4:	0597131f 	ldreq	r1, [r7, #799]	; 0x31f
    12b8:	00080000 	andeq	r0, r8, r0
    12bc:	055c0418 	ldrbeq	r0, [ip, #-1048]	; 0xfffffbe8
    12c0:	04180000 	ldreq	r0, [r8], #-0
    12c4:	00000462 	andeq	r0, r0, r2, ror #8
    12c8:	0005790d 	andeq	r7, r5, sp, lsl #18
    12cc:	22061400 	andcs	r1, r6, #0, 8
    12d0:	00081f07 	andeq	r1, r8, r7, lsl #30
    12d4:	081c0e00 	ldmdaeq	ip, {r9, sl, fp}
    12d8:	26060000 	strcs	r0, [r6], -r0
    12dc:	00004d12 	andeq	r4, r0, r2, lsl sp
    12e0:	7a0e0000 	bvc	3812e8 <__bss_end+0x377628>
    12e4:	06000004 	streq	r0, [r0], -r4
    12e8:	05911d29 	ldreq	r1, [r1, #3369]	; 0xd29
    12ec:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    12f0:	00000a9e 	muleq	r0, lr, sl
    12f4:	911d2c06 	tstls	sp, r6, lsl #24
    12f8:	08000005 	stmdaeq	r0, {r0, r2}
    12fc:	000ca21b 	andeq	sl, ip, fp, lsl r2
    1300:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
    1304:	00000bcd 	andeq	r0, r0, sp, asr #23
    1308:	000005e5 	andeq	r0, r0, r5, ror #11
    130c:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1310:	00082410 	andeq	r2, r8, r0, lsl r4
    1314:	05911100 	ldreq	r1, [r1, #256]	; 0x100
    1318:	1c000000 	stcne	0, cr0, [r0], {-0}
    131c:	00000b86 	andeq	r0, r0, r6, lsl #23
    1320:	e50e3106 	str	r3, [lr, #-262]	; 0xfffffefa
    1324:	6e000003 	cdpvs	0, 0, cr0, cr0, cr3, {0}
    1328:	08000003 	stmdaeq	r0, {r0, r1}
    132c:	13000006 	movwne	r0, #6
    1330:	10000006 	andne	r0, r0, r6
    1334:	00000824 	andeq	r0, r0, r4, lsr #16
    1338:	00059711 	andeq	r9, r5, r1, lsl r7
    133c:	03130000 	tsteq	r3, #0
    1340:	0600000c 	streq	r0, [r0], -ip
    1344:	0b531d35 	bleq	14c8820 <__bss_end+0x14beb60>
    1348:	05910000 	ldreq	r0, [r1]
    134c:	2c020000 	stccs	0, cr0, [r2], {-0}
    1350:	32000006 	andcc	r0, r0, #6
    1354:	10000006 	andne	r0, r0, r6
    1358:	00000824 	andeq	r0, r0, r4, lsr #16
    135c:	07b01300 	ldreq	r1, [r0, r0, lsl #6]!
    1360:	37060000 	strcc	r0, [r6, -r0]
    1364:	0009d81d 	andeq	sp, r9, sp, lsl r8
    1368:	00059100 	andeq	r9, r5, r0, lsl #2
    136c:	064b0200 	strbeq	r0, [fp], -r0, lsl #4
    1370:	06510000 	ldrbeq	r0, [r1], -r0
    1374:	24100000 	ldrcs	r0, [r0], #-0
    1378:	00000008 	andeq	r0, r0, r8
    137c:	0008b61d 	andeq	fp, r8, sp, lsl r6
    1380:	31390600 	teqcc	r9, r0, lsl #12
    1384:	0000083d 	andeq	r0, r0, sp, lsr r8
    1388:	7913020c 	ldmdbvc	r3, {r2, r3, r9}
    138c:	06000005 	streq	r0, [r0], -r5
    1390:	0d42093c 	vstreq.16	s1, [r2, #-120]	; 0xffffff88	; <UNPREDICTABLE>
    1394:	08240000 	stmdaeq	r4!, {}	; <UNPREDICTABLE>
    1398:	78010000 	stmdavc	r1, {}	; <UNPREDICTABLE>
    139c:	7e000006 	cdpvc	0, 0, cr0, cr0, cr6, {0}
    13a0:	10000006 	andne	r0, r0, r6
    13a4:	00000824 	andeq	r0, r0, r4, lsr #16
    13a8:	052b1300 	streq	r1, [fp, #-768]!	; 0xfffffd00
    13ac:	3f060000 	svccc	0x00060000
    13b0:	000c7712 	andeq	r7, ip, r2, lsl r7
    13b4:	00004d00 	andeq	r4, r0, r0, lsl #26
    13b8:	06970100 	ldreq	r0, [r7], r0, lsl #2
    13bc:	06ac0000 	strteq	r0, [ip], r0
    13c0:	24100000 	ldrcs	r0, [r0], #-0
    13c4:	11000008 	tstne	r0, r8
    13c8:	00000846 	andeq	r0, r0, r6, asr #16
    13cc:	00005e11 	andeq	r5, r0, r1, lsl lr
    13d0:	036e1100 	cmneq	lr, #0, 2
    13d4:	14000000 	strne	r0, [r0], #-0
    13d8:	00000b95 	muleq	r0, r5, fp
    13dc:	540e4206 	strpl	r4, [lr], #-518	; 0xfffffdfa
    13e0:	01000009 	tsteq	r0, r9
    13e4:	000006c1 	andeq	r0, r0, r1, asr #13
    13e8:	000006c7 	andeq	r0, r0, r7, asr #13
    13ec:	00082410 	andeq	r2, r8, r0, lsl r4
    13f0:	44130000 	ldrmi	r0, [r3], #-0
    13f4:	06000007 	streq	r0, [r0], -r7
    13f8:	04971745 	ldreq	r1, [r7], #1861	; 0x745
    13fc:	05970000 	ldreq	r0, [r7]
    1400:	e0010000 	and	r0, r1, r0
    1404:	e6000006 	str	r0, [r0], -r6
    1408:	10000006 	andne	r0, r0, r6
    140c:	0000084c 	andeq	r0, r0, ip, asr #16
    1410:	04d21300 	ldrbeq	r1, [r2], #768	; 0x300
    1414:	48060000 	stmdami	r6, {}	; <UNPREDICTABLE>
    1418:	000b1017 	andeq	r1, fp, r7, lsl r0
    141c:	00059700 	andeq	r9, r5, r0, lsl #14
    1420:	06ff0100 	ldrbteq	r0, [pc], r0, lsl #2
    1424:	070a0000 	streq	r0, [sl, -r0]
    1428:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    142c:	11000008 	tstne	r0, r8
    1430:	0000004d 	andeq	r0, r0, sp, asr #32
    1434:	0ce91400 	cfstrdeq	mvd1, [r9]
    1438:	4b060000 	blmi	181440 <__bss_end+0x177780>
    143c:	000b9e0e 	andeq	r9, fp, lr, lsl #28
    1440:	071f0100 	ldreq	r0, [pc, -r0, lsl #2]
    1444:	07250000 	streq	r0, [r5, -r0]!
    1448:	24100000 	ldrcs	r0, [r0], #-0
    144c:	00000008 	andeq	r0, r0, r8
    1450:	000b8613 	andeq	r8, fp, r3, lsl r6
    1454:	0e4d0600 	cdpeq	6, 4, cr0, cr13, cr0, {0}
    1458:	00000678 	andeq	r0, r0, r8, ror r6
    145c:	0000036e 	andeq	r0, r0, lr, ror #6
    1460:	00073e01 	andeq	r3, r7, r1, lsl #28
    1464:	00074900 	andeq	r4, r7, r0, lsl #18
    1468:	08241000 	stmdaeq	r4!, {ip}
    146c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1470:	00000000 	andeq	r0, r0, r0
    1474:	00075813 	andeq	r5, r7, r3, lsl r8
    1478:	12500600 	subsne	r0, r0, #0, 12
    147c:	00000975 	andeq	r0, r0, r5, ror r9
    1480:	0000004d 	andeq	r0, r0, sp, asr #32
    1484:	00076201 	andeq	r6, r7, r1, lsl #4
    1488:	00076d00 	andeq	r6, r7, r0, lsl #26
    148c:	08241000 	stmdaeq	r4!, {ip}
    1490:	9d110000 	ldcls	0, cr0, [r1, #-0]
    1494:	00000003 	andeq	r0, r0, r3
    1498:	00044b13 	andeq	r4, r4, r3, lsl fp
    149c:	0e530600 	cdpeq	6, 5, cr0, cr3, cr0, {0}
    14a0:	000006fc 	strdeq	r0, [r0], -ip
    14a4:	0000036e 	andeq	r0, r0, lr, ror #6
    14a8:	00078601 	andeq	r8, r7, r1, lsl #12
    14ac:	00079100 	andeq	r9, r7, r0, lsl #2
    14b0:	08241000 	stmdaeq	r4!, {ip}
    14b4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    14b8:	00000000 	andeq	r0, r0, r0
    14bc:	00078a14 	andeq	r8, r7, r4, lsl sl
    14c0:	0e560600 	cdpeq	6, 5, cr0, cr6, cr0, {0}
    14c4:	00000c0f 	andeq	r0, r0, pc, lsl #24
    14c8:	0007a601 	andeq	sl, r7, r1, lsl #12
    14cc:	0007c500 	andeq	ip, r7, r0, lsl #10
    14d0:	08241000 	stmdaeq	r4!, {ip}
    14d4:	a9110000 	ldmdbge	r1, {}	; <UNPREDICTABLE>
    14d8:	11000000 	mrsne	r0, (UNDEF: 0)
    14dc:	0000004d 	andeq	r0, r0, sp, asr #32
    14e0:	00004d11 	andeq	r4, r0, r1, lsl sp
    14e4:	004d1100 	subeq	r1, sp, r0, lsl #2
    14e8:	52110000 	andspl	r0, r1, #0
    14ec:	00000008 	andeq	r0, r0, r8
    14f0:	000b3d14 	andeq	r3, fp, r4, lsl sp
    14f4:	0e580600 	cdpeq	6, 5, cr0, cr8, cr0, {0}
    14f8:	000005ed 	andeq	r0, r0, sp, ror #11
    14fc:	0007da01 	andeq	sp, r7, r1, lsl #20
    1500:	0007f900 	andeq	pc, r7, r0, lsl #18
    1504:	08241000 	stmdaeq	r4!, {ip}
    1508:	e0110000 	ands	r0, r1, r0
    150c:	11000000 	mrsne	r0, (UNDEF: 0)
    1510:	0000004d 	andeq	r0, r0, sp, asr #32
    1514:	00004d11 	andeq	r4, r0, r1, lsl sp
    1518:	004d1100 	subeq	r1, sp, r0, lsl #2
    151c:	52110000 	andspl	r0, r1, #0
    1520:	00000008 	andeq	r0, r0, r8
    1524:	00055315 	andeq	r5, r5, r5, lsl r3
    1528:	0e5b0600 	cdpeq	6, 5, cr0, cr11, cr0, {0}
    152c:	000005aa 	andeq	r0, r0, sl, lsr #11
    1530:	0000036e 	andeq	r0, r0, lr, ror #6
    1534:	00080e01 	andeq	r0, r8, r1, lsl #28
    1538:	08241000 	stmdaeq	r4!, {ip}
    153c:	14110000 	ldrne	r0, [r1], #-0
    1540:	11000005 	tstne	r0, r5
    1544:	00000858 	andeq	r0, r0, r8, asr r8
    1548:	9d030000 	stcls	0, cr0, [r3, #-0]
    154c:	18000005 	stmdane	r0, {r0, r2}
    1550:	00059d04 	andeq	r9, r5, r4, lsl #26
    1554:	05911e00 	ldreq	r1, [r1, #3584]	; 0xe00
    1558:	08370000 	ldmdaeq	r7!, {}	; <UNPREDICTABLE>
    155c:	083d0000 	ldmdaeq	sp!, {}	; <UNPREDICTABLE>
    1560:	24100000 	ldrcs	r0, [r0], #-0
    1564:	00000008 	andeq	r0, r0, r8
    1568:	00059d1f 	andeq	r9, r5, pc, lsl sp
    156c:	00082a00 	andeq	r2, r8, r0, lsl #20
    1570:	3f041800 	svccc	0x00041800
    1574:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1578:	00081f04 	andeq	r1, r8, r4, lsl #30
    157c:	65042000 	strvs	r2, [r4, #-0]
    1580:	21000000 	mrscs	r0, (UNDEF: 0)
    1584:	08c41a04 	stmiaeq	r4, {r2, r9, fp, ip}^
    1588:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
    158c:	00059d19 	andeq	r9, r5, r9, lsl sp
    1590:	08fb0b00 	ldmeq	fp!, {r8, r9, fp}^
    1594:	04070000 	streq	r0, [r7], #-0
    1598:	00087f11 	andeq	r7, r8, r1, lsl pc
    159c:	88030500 	stmdahi	r3, {r8, sl}
    15a0:	0200009c 	andeq	r0, r0, #156	; 0x9c
    15a4:	16860404 	strne	r0, [r6], r4, lsl #8
    15a8:	78030000 	stmdavc	r3, {}	; <UNPREDICTABLE>
    15ac:	16000008 	strne	r0, [r0], -r8
    15b0:	0000002c 	andeq	r0, r0, ip, lsr #32
    15b4:	00000894 	muleq	r0, r4, r8
    15b8:	00005e17 	andeq	r5, r0, r7, lsl lr
    15bc:	03000900 	movweq	r0, #2304	; 0x900
    15c0:	00000884 	andeq	r0, r0, r4, lsl #17
    15c4:	000e3f22 	andeq	r3, lr, r2, lsr #30
    15c8:	0ca40100 	stfeqs	f0, [r4]
    15cc:	00000894 	muleq	r0, r4, r8
    15d0:	9c8c0305 	stcls	3, cr0, [ip], {5}
    15d4:	a1230000 			; <UNDEFINED> instruction: 0xa1230000
    15d8:	0100000d 	tsteq	r0, sp
    15dc:	0eeb0aa6 	vfmaeq.f32	s1, s23, s13
    15e0:	004d0000 	subeq	r0, sp, r0
    15e4:	89040000 	stmdbhi	r4, {}	; <UNPREDICTABLE>
    15e8:	00b00000 	adcseq	r0, r0, r0
    15ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    15f0:	00000909 	andeq	r0, r0, r9, lsl #18
    15f4:	001c2c24 	andseq	r2, ip, r4, lsr #24
    15f8:	1ba60100 	blne	fe981a00 <__bss_end+0xfe977d40>
    15fc:	0000037b 	andeq	r0, r0, fp, ror r3
    1600:	7fac9103 	svcvc	0x00ac9103
    1604:	000f7724 	andeq	r7, pc, r4, lsr #14
    1608:	2aa60100 	bcs	fe981a10 <__bss_end+0xfe977d50>
    160c:	0000004d 	andeq	r0, r0, sp, asr #32
    1610:	7fa89103 	svcvc	0x00a89103
    1614:	000ed322 	andeq	sp, lr, r2, lsr #6
    1618:	0aa80100 	beq	fea01a20 <__bss_end+0xfe9f7d60>
    161c:	00000909 	andeq	r0, r0, r9, lsl #18
    1620:	7fb49103 	svcvc	0x00b49103
    1624:	000d9c22 	andeq	r9, sp, r2, lsr #24
    1628:	09ac0100 	stmibeq	ip!, {r8}
    162c:	00000038 	andeq	r0, r0, r8, lsr r0
    1630:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1634:	00002516 	andeq	r2, r0, r6, lsl r5
    1638:	00091900 	andeq	r1, r9, r0, lsl #18
    163c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1640:	003f0000 	eorseq	r0, pc, r0
    1644:	000f5625 	andeq	r5, pc, r5, lsr #12
    1648:	0a980100 	beq	fe601a50 <__bss_end+0xfe5f7d90>
    164c:	00000f99 	muleq	r0, r9, pc	; <UNPREDICTABLE>
    1650:	0000004d 	andeq	r0, r0, sp, asr #32
    1654:	000088c8 	andeq	r8, r0, r8, asr #17
    1658:	0000003c 	andeq	r0, r0, ip, lsr r0
    165c:	09569c01 	ldmdbeq	r6, {r0, sl, fp, ip, pc}^
    1660:	72260000 	eorvc	r0, r6, #0
    1664:	01007165 	tsteq	r0, r5, ror #2
    1668:	0557209a 	ldrbeq	r2, [r7, #-154]	; 0xffffff66
    166c:	91020000 	mrsls	r0, (UNDEF: 2)
    1670:	0ee02274 	mcreq	2, 7, r2, cr0, cr4, {3}
    1674:	9b010000 	blls	4167c <__bss_end+0x379bc>
    1678:	00004d0e 	andeq	r4, r0, lr, lsl #26
    167c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1680:	0e6a2700 	cdpeq	7, 6, cr2, cr10, cr0, {0}
    1684:	8f010000 	svchi	0x00010000
    1688:	000dbd06 	andeq	fp, sp, r6, lsl #26
    168c:	00888c00 	addeq	r8, r8, r0, lsl #24
    1690:	00003c00 	andeq	r3, r0, r0, lsl #24
    1694:	8f9c0100 	svchi	0x009c0100
    1698:	24000009 	strcs	r0, [r0], #-9
    169c:	00000e2b 	andeq	r0, r0, fp, lsr #28
    16a0:	4d218f01 	stcmi	15, cr8, [r1, #-4]!
    16a4:	02000000 	andeq	r0, r0, #0
    16a8:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    16ac:	01007165 	tsteq	r0, r5, ror #2
    16b0:	05572091 	ldrbeq	r2, [r7, #-145]	; 0xffffff6f
    16b4:	91020000 	mrsls	r0, (UNDEF: 2)
    16b8:	0c250074 	stceq	0, cr0, [r5], #-464	; 0xfffffe30
    16bc:	0100000f 	tsteq	r0, pc
    16c0:	0e500a83 	vnmlseq.f32	s1, s1, s6
    16c4:	004d0000 	subeq	r0, sp, r0
    16c8:	88500000 	ldmdahi	r0, {}^	; <UNPREDICTABLE>
    16cc:	003c0000 	eorseq	r0, ip, r0
    16d0:	9c010000 	stcls	0, cr0, [r1], {-0}
    16d4:	000009cc 	andeq	r0, r0, ip, asr #19
    16d8:	71657226 	cmnvc	r5, r6, lsr #4
    16dc:	20850100 	addcs	r0, r5, r0, lsl #2
    16e0:	00000533 	andeq	r0, r0, r3, lsr r5
    16e4:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    16e8:	00000d95 	muleq	r0, r5, sp
    16ec:	4d0e8601 	stcmi	6, cr8, [lr, #-4]
    16f0:	02000000 	andeq	r0, r0, #0
    16f4:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    16f8:	0000101f 	andeq	r1, r0, pc, lsl r0
    16fc:	010a7701 	tsteq	sl, r1, lsl #14
    1700:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    1704:	14000000 	strne	r0, [r0], #-0
    1708:	3c000088 	stccc	0, cr0, [r0], {136}	; 0x88
    170c:	01000000 	mrseq	r0, (UNDEF: 0)
    1710:	000a099c 	muleq	sl, ip, r9
    1714:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1718:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    171c:	00053320 	andeq	r3, r5, r0, lsr #6
    1720:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1724:	000d9522 	andeq	r9, sp, r2, lsr #10
    1728:	0e7a0100 	rpweqe	f0, f2, f0
    172c:	0000004d 	andeq	r0, r0, sp, asr #32
    1730:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1734:	000e6425 	andeq	r6, lr, r5, lsr #8
    1738:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    173c:	00000f80 	andeq	r0, r0, r0, lsl #31
    1740:	0000036e 	andeq	r0, r0, lr, ror #6
    1744:	000087c0 	andeq	r8, r0, r0, asr #15
    1748:	00000054 	andeq	r0, r0, r4, asr r0
    174c:	0a559c01 	beq	1568758 <__bss_end+0x155ea98>
    1750:	e0240000 	eor	r0, r4, r0
    1754:	0100000e 	tsteq	r0, lr
    1758:	004d156b 	subeq	r1, sp, fp, ror #10
    175c:	91020000 	mrsls	r0, (UNDEF: 2)
    1760:	06b3246c 	ldrteq	r2, [r3], ip, ror #8
    1764:	6b010000 	blvs	4176c <__bss_end+0x37aac>
    1768:	00004d25 	andeq	r4, r0, r5, lsr #26
    176c:	68910200 	ldmvs	r1, {r9}
    1770:	00101722 	andseq	r1, r0, r2, lsr #14
    1774:	0e6d0100 	poweqe	f0, f5, f0
    1778:	0000004d 	andeq	r0, r0, sp, asr #32
    177c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1780:	000dd425 	andeq	sp, sp, r5, lsr #8
    1784:	125e0100 	subsne	r0, lr, #0, 2
    1788:	00000fd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    178c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1790:	00008770 	andeq	r8, r0, r0, ror r7
    1794:	00000050 	andeq	r0, r0, r0, asr r0
    1798:	0ab09c01 	beq	fec287a4 <__bss_end+0xfec1eae4>
    179c:	19240000 	stmdbne	r4!, {}	; <UNPREDICTABLE>
    17a0:	0100000a 	tsteq	r0, sl
    17a4:	004d205e 	subeq	r2, sp, lr, asr r0
    17a8:	91020000 	mrsls	r0, (UNDEF: 2)
    17ac:	0f15246c 	svceq	0x0015246c
    17b0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    17b4:	00004d2f 	andeq	r4, r0, pc, lsr #26
    17b8:	68910200 	ldmvs	r1, {r9}
    17bc:	0006b324 	andeq	fp, r6, r4, lsr #6
    17c0:	3f5e0100 	svccc	0x005e0100
    17c4:	0000004d 	andeq	r0, r0, sp, asr #32
    17c8:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    17cc:	00001017 	andeq	r1, r0, r7, lsl r0
    17d0:	8b166001 	blhi	5997dc <__bss_end+0x58fb1c>
    17d4:	02000000 	andeq	r0, r0, #0
    17d8:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    17dc:	00000ed9 	ldrdeq	r0, [r0], -r9
    17e0:	d90a5201 	stmdble	sl, {r0, r9, ip, lr}
    17e4:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    17e8:	2c000000 	stccs	0, cr0, [r0], {-0}
    17ec:	44000087 	strmi	r0, [r0], #-135	; 0xffffff79
    17f0:	01000000 	mrseq	r0, (UNDEF: 0)
    17f4:	000afc9c 	muleq	sl, ip, ip
    17f8:	0a192400 	beq	64a800 <__bss_end+0x640b40>
    17fc:	52010000 	andpl	r0, r1, #0
    1800:	00004d1a 	andeq	r4, r0, sl, lsl sp
    1804:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1808:	000f1524 	andeq	r1, pc, r4, lsr #10
    180c:	29520100 	ldmdbcs	r2, {r8}^
    1810:	0000004d 	andeq	r0, r0, sp, asr #32
    1814:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1818:	00000fff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    181c:	4d0e5401 	cfstrsmi	mvf5, [lr, #-4]
    1820:	02000000 	andeq	r0, r0, #0
    1824:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1828:	00000ff9 	strdeq	r0, [r0], -r9
    182c:	db0a4501 	blle	292c38 <__bss_end+0x288f78>
    1830:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    1834:	dc000000 	stcle	0, cr0, [r0], {-0}
    1838:	50000086 	andpl	r0, r0, r6, lsl #1
    183c:	01000000 	mrseq	r0, (UNDEF: 0)
    1840:	000b579c 	muleq	fp, ip, r7
    1844:	0a192400 	beq	64a84c <__bss_end+0x640b8c>
    1848:	45010000 	strmi	r0, [r1, #-0]
    184c:	00004d19 	andeq	r4, r0, r9, lsl sp
    1850:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1854:	000e7c24 	andeq	r7, lr, r4, lsr #24
    1858:	30450100 	subcc	r0, r5, r0, lsl #2
    185c:	0000011d 	andeq	r0, r0, sp, lsl r1
    1860:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1864:	00000f42 	andeq	r0, r0, r2, asr #30
    1868:	58414501 	stmdapl	r1, {r0, r8, sl, lr}^
    186c:	02000008 	andeq	r0, r0, #8
    1870:	17226491 			; <UNDEFINED> instruction: 0x17226491
    1874:	01000010 	tsteq	r0, r0, lsl r0
    1878:	004d0e47 	subeq	r0, sp, r7, asr #28
    187c:	91020000 	mrsls	r0, (UNDEF: 2)
    1880:	82270074 	eorhi	r0, r7, #116	; 0x74
    1884:	0100000d 	tsteq	r0, sp
    1888:	0e86063f 	mcreq	6, 4, r0, cr6, cr15, {1}
    188c:	86b00000 	ldrthi	r0, [r0], r0
    1890:	002c0000 	eoreq	r0, ip, r0
    1894:	9c010000 	stcls	0, cr0, [r1], {-0}
    1898:	00000b81 	andeq	r0, r0, r1, lsl #23
    189c:	000a1924 	andeq	r1, sl, r4, lsr #18
    18a0:	153f0100 	ldrne	r0, [pc, #-256]!	; 17a8 <shift+0x17a8>
    18a4:	0000004d 	andeq	r0, r0, sp, asr #32
    18a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18ac:	000f7125 	andeq	r7, pc, r5, lsr #2
    18b0:	0a320100 	beq	c81cb8 <__bss_end+0xc77ff8>
    18b4:	00000f48 	andeq	r0, r0, r8, asr #30
    18b8:	0000004d 	andeq	r0, r0, sp, asr #32
    18bc:	00008660 	andeq	r8, r0, r0, ror #12
    18c0:	00000050 	andeq	r0, r0, r0, asr r0
    18c4:	0bdc9c01 	bleq	ff7288d0 <__bss_end+0xff71ec10>
    18c8:	19240000 	stmdbne	r4!, {}	; <UNPREDICTABLE>
    18cc:	0100000a 	tsteq	r0, sl
    18d0:	004d1932 	subeq	r1, sp, r2, lsr r9
    18d4:	91020000 	mrsls	r0, (UNDEF: 2)
    18d8:	0466246c 	strbteq	r2, [r6], #-1132	; 0xfffffb94
    18dc:	32010000 	andcc	r0, r1, #0
    18e0:	00037b2b 	andeq	r7, r3, fp, lsr #22
    18e4:	68910200 	ldmvs	r1, {r9}
    18e8:	000f7b24 	andeq	r7, pc, r4, lsr #22
    18ec:	3c320100 	ldfccs	f0, [r2], #-0
    18f0:	0000004d 	andeq	r0, r0, sp, asr #32
    18f4:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    18f8:	00000fca 	andeq	r0, r0, sl, asr #31
    18fc:	4d0e3401 	cfstrsmi	mvf3, [lr, #-4]
    1900:	02000000 	andeq	r0, r0, #0
    1904:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1908:	00001041 	andeq	r1, r0, r1, asr #32
    190c:	0b0a2501 	bleq	28ad18 <__bss_end+0x281058>
    1910:	4d000010 	stcmi	0, cr0, [r0, #-64]	; 0xffffffc0
    1914:	10000000 	andne	r0, r0, r0
    1918:	50000086 	andpl	r0, r0, r6, lsl #1
    191c:	01000000 	mrseq	r0, (UNDEF: 0)
    1920:	000c379c 	muleq	ip, ip, r7
    1924:	0a192400 	beq	64a92c <__bss_end+0x640c6c>
    1928:	25010000 	strcs	r0, [r1, #-0]
    192c:	00004d18 	andeq	r4, r0, r8, lsl sp
    1930:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1934:	00046624 	andeq	r6, r4, r4, lsr #12
    1938:	2a250100 	bcs	941d40 <__bss_end+0x938080>
    193c:	00000c3d 	andeq	r0, r0, sp, lsr ip
    1940:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1944:	00000f7b 	andeq	r0, r0, fp, ror pc
    1948:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    194c:	02000000 	andeq	r0, r0, #0
    1950:	a6226491 			; <UNDEFINED> instruction: 0xa6226491
    1954:	0100000d 	tsteq	r0, sp
    1958:	004d0e27 	subeq	r0, sp, r7, lsr #28
    195c:	91020000 	mrsls	r0, (UNDEF: 2)
    1960:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1964:	00000025 	andeq	r0, r0, r5, lsr #32
    1968:	000c3703 	andeq	r3, ip, r3, lsl #14
    196c:	0ee62500 	cdpeq	5, 14, cr2, cr6, cr0, {0}
    1970:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1974:	0010570a 	andseq	r5, r0, sl, lsl #14
    1978:	00004d00 	andeq	r4, r0, r0, lsl #26
    197c:	0085cc00 	addeq	ip, r5, r0, lsl #24
    1980:	00004400 	andeq	r4, r0, r0, lsl #8
    1984:	8e9c0100 	fmlhie	f0, f4, f0
    1988:	2400000c 	strcs	r0, [r0], #-12
    198c:	00001038 	andeq	r1, r0, r8, lsr r0
    1990:	7b1b1901 	blvc	6c7d9c <__bss_end+0x6be0dc>
    1994:	02000003 	andeq	r0, r0, #3
    1998:	06246c91 			; <UNDEFINED> instruction: 0x06246c91
    199c:	01000010 	tsteq	r0, r0, lsl r0
    19a0:	01c63519 	biceq	r3, r6, r9, lsl r5
    19a4:	91020000 	mrsls	r0, (UNDEF: 2)
    19a8:	0a192268 	beq	64a350 <__bss_end+0x640690>
    19ac:	1b010000 	blne	419b4 <__bss_end+0x37cf4>
    19b0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    19b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19b8:	0e1f2800 	cdpeq	8, 1, cr2, cr15, cr0, {0}
    19bc:	14010000 	strne	r0, [r1], #-0
    19c0:	000dac06 	andeq	sl, sp, r6, lsl #24
    19c4:	0085b000 	addeq	fp, r5, r0
    19c8:	00001c00 	andeq	r1, r0, r0, lsl #24
    19cc:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    19d0:	00001046 	andeq	r1, r0, r6, asr #32
    19d4:	e5060e01 	str	r0, [r6, #-3585]	; 0xfffff1ff
    19d8:	8400000d 	strhi	r0, [r0], #-13
    19dc:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    19e0:	01000000 	mrseq	r0, (UNDEF: 0)
    19e4:	000cce9c 	muleq	ip, ip, lr
    19e8:	0df82400 	cfldrdeq	mvd2, [r8]
    19ec:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    19f0:	00003814 	andeq	r3, r0, r4, lsl r8
    19f4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19f8:	10502900 	subsne	r2, r0, r0, lsl #18
    19fc:	04010000 	streq	r0, [r1], #-0
    1a00:	000ec80a 	andeq	ip, lr, sl, lsl #16
    1a04:	00004d00 	andeq	r4, r0, r0, lsl #26
    1a08:	00855800 	addeq	r5, r5, r0, lsl #16
    1a0c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1a10:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    1a14:	00646970 	rsbeq	r6, r4, r0, ror r9
    1a18:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    1a1c:	02000000 	andeq	r0, r0, #0
    1a20:	00007491 	muleq	r0, r1, r4
    1a24:	000006f9 	strdeq	r0, [r0], -r9
    1a28:	07180004 	ldreq	r0, [r8, -r4]
    1a2c:	01040000 	mrseq	r0, (UNDEF: 4)
    1a30:	00001073 	andeq	r1, r0, r3, ror r0
    1a34:	00115604 	andseq	r5, r1, r4, lsl #12
    1a38:	000f1b00 	andeq	r1, pc, r0, lsl #22
    1a3c:	0089b400 	addeq	fp, r9, r0, lsl #8
    1a40:	000fdc00 	andeq	sp, pc, r0, lsl #24
    1a44:	00076d00 	andeq	r6, r7, r0, lsl #26
    1a48:	08fb0200 	ldmeq	fp!, {r9}^
    1a4c:	04020000 	streq	r0, [r2], #-0
    1a50:	00003e11 	andeq	r3, r0, r1, lsl lr
    1a54:	98030500 	stmdals	r3, {r8, sl}
    1a58:	0300009c 	movweq	r0, #156	; 0x9c
    1a5c:	16860404 	strne	r0, [r6], r4, lsl #8
    1a60:	37040000 	strcc	r0, [r4, -r0]
    1a64:	05000000 	streq	r0, [r0, #-0]
    1a68:	00000067 	andeq	r0, r0, r7, rrx
    1a6c:	00129606 	andseq	r9, r2, r6, lsl #12
    1a70:	10050100 	andne	r0, r5, r0, lsl #2
    1a74:	0000007f 	andeq	r0, r0, pc, ror r0
    1a78:	32313011 	eorscc	r3, r1, #17
    1a7c:	36353433 			; <UNDEFINED> instruction: 0x36353433
    1a80:	41393837 	teqmi	r9, r7, lsr r8
    1a84:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    1a88:	07000046 	streq	r0, [r0, -r6, asr #32]
    1a8c:	43010301 	movwmi	r0, #4865	; 0x1301
    1a90:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1a94:	00000097 	muleq	r0, r7, r0
    1a98:	0000007f 	andeq	r0, r0, pc, ror r0
    1a9c:	00008409 	andeq	r8, r0, r9, lsl #8
    1aa0:	04001000 	streq	r1, [r0], #-0
    1aa4:	0000006f 	andeq	r0, r0, pc, rrx
    1aa8:	bc070403 	cfstrslt	mvf0, [r7], {3}
    1aac:	04000018 	streq	r0, [r0], #-24	; 0xffffffe8
    1ab0:	00000084 	andeq	r0, r0, r4, lsl #1
    1ab4:	d3080103 	movwle	r0, #33027	; 0x8103
    1ab8:	04000009 	streq	r0, [r0], #-9
    1abc:	00000090 	muleq	r0, r0, r0
    1ac0:	0000480a 	andeq	r4, r0, sl, lsl #16
    1ac4:	128a0b00 	addne	r0, sl, #0, 22
    1ac8:	fc010000 	stc2	0, cr0, [r1], {-0}
    1acc:	00120107 	andseq	r0, r2, r7, lsl #2
    1ad0:	00003700 	andeq	r3, r0, r0, lsl #14
    1ad4:	00988000 	addseq	r8, r8, r0
    1ad8:	00011000 	andeq	r1, r1, r0
    1adc:	1d9c0100 	ldfnes	f0, [ip]
    1ae0:	0c000001 	stceq	0, cr0, [r0], {1}
    1ae4:	fc010073 	stc2	0, cr0, [r1], {115}	; 0x73
    1ae8:	00011d18 	andeq	r1, r1, r8, lsl sp
    1aec:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1af0:	7a65720d 	bvc	195e32c <__bss_end+0x195466c>
    1af4:	09fe0100 	ldmibeq	lr!, {r8}^
    1af8:	00000037 	andeq	r0, r0, r7, lsr r0
    1afc:	0e749102 	expeqs	f1, f2
    1b00:	00001324 	andeq	r1, r0, r4, lsr #6
    1b04:	3712fe01 	ldrcc	pc, [r2, -r1, lsl #28]
    1b08:	02000000 	andeq	r0, r0, #0
    1b0c:	c40f7091 	strgt	r7, [pc], #-145	; 1b14 <shift+0x1b14>
    1b10:	a8000098 	stmdage	r0, {r3, r4, r7}
    1b14:	10000000 	andne	r0, r0, r0
    1b18:	000011c8 	andeq	r1, r0, r8, asr #3
    1b1c:	0c010301 	stceq	3, cr0, [r1], {1}
    1b20:	00000123 	andeq	r0, r0, r3, lsr #2
    1b24:	0f6c9102 	svceq	0x006c9102
    1b28:	000098dc 	ldrdeq	r9, [r0], -ip
    1b2c:	00000080 	andeq	r0, r0, r0, lsl #1
    1b30:	01006411 	tsteq	r0, r1, lsl r4
    1b34:	23090108 	movwcs	r0, #37128	; 0x9108
    1b38:	02000001 	andeq	r0, r0, #1
    1b3c:	00006891 	muleq	r0, r1, r8
    1b40:	97041200 	strls	r1, [r4, -r0, lsl #4]
    1b44:	13000000 	movwne	r0, #0
    1b48:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1b4c:	a2140074 	andsge	r0, r4, #116	; 0x74
    1b50:	01000012 	tsteq	r0, r2, lsl r0
    1b54:	130c06c1 	movwne	r0, #50881	; 0xc6c1
    1b58:	955c0000 	ldrbls	r0, [ip, #-0]
    1b5c:	03240000 			; <UNDEFINED> instruction: 0x03240000
    1b60:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b64:	00000229 	andeq	r0, r0, r9, lsr #4
    1b68:	0100780c 	tsteq	r0, ip, lsl #16
    1b6c:	003711c1 	eorseq	r1, r7, r1, asr #3
    1b70:	91030000 	mrsls	r0, (UNDEF: 3)
    1b74:	620c7fa4 	andvs	r7, ip, #164, 30	; 0x290
    1b78:	01007266 	tsteq	r0, r6, ror #4
    1b7c:	02291ac1 	eoreq	r1, r9, #790528	; 0xc1000
    1b80:	91030000 	mrsls	r0, (UNDEF: 3)
    1b84:	da157fa0 	ble	561a0c <__bss_end+0x557d4c>
    1b88:	01000011 	tsteq	r0, r1, lsl r0
    1b8c:	008b32c1 	addeq	r3, fp, r1, asr #5
    1b90:	91030000 	mrsls	r0, (UNDEF: 3)
    1b94:	e50e7f9c 	str	r7, [lr, #-3996]	; 0xfffff064
    1b98:	01000012 	tsteq	r0, r2, lsl r0
    1b9c:	00840fc3 	addeq	r0, r4, r3, asr #31
    1ba0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba4:	12ce0e74 	sbcne	r0, lr, #116, 28	; 0x740
    1ba8:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
    1bac:	00012306 	andeq	r2, r1, r6, lsl #6
    1bb0:	70910200 	addsvc	r0, r1, r0, lsl #4
    1bb4:	0011e30e 	andseq	lr, r1, lr, lsl #6
    1bb8:	11dd0100 	bicsne	r0, sp, r0, lsl #2
    1bbc:	0000003e 	andeq	r0, r0, lr, lsr r0
    1bc0:	0e649102 	lgneqs	f1, f2
    1bc4:	000011a0 	andeq	r1, r0, r0, lsr #3
    1bc8:	8b18e001 	blhi	639bd4 <__bss_end+0x62ff14>
    1bcc:	02000000 	andeq	r0, r0, #0
    1bd0:	af0e6091 	svcge	0x000e6091
    1bd4:	01000011 	tsteq	r0, r1, lsl r0
    1bd8:	008b18e1 	addeq	r1, fp, r1, ror #17
    1bdc:	91020000 	mrsls	r0, (UNDEF: 2)
    1be0:	12550e5c 	subsne	r0, r5, #92, 28	; 0x5c0
    1be4:	e3010000 	movw	r0, #4096	; 0x1000
    1be8:	00022f07 	andeq	r2, r2, r7, lsl #30
    1bec:	b8910300 	ldmlt	r1, {r8, r9}
    1bf0:	11e90e7f 	mvnne	r0, pc, ror lr
    1bf4:	e5010000 	str	r0, [r1, #-0]
    1bf8:	00012306 	andeq	r2, r1, r6, lsl #6
    1bfc:	58910200 	ldmpl	r1, {r9}
    1c00:	00976816 	addseq	r6, r7, r6, lsl r8
    1c04:	00005000 	andeq	r5, r0, r0
    1c08:	0001f700 	andeq	pc, r1, r0, lsl #14
    1c0c:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1c10:	230be701 	movwcs	lr, #46849	; 0xb701
    1c14:	02000001 	andeq	r0, r0, #1
    1c18:	0f006c91 	svceq	0x00006c91
    1c1c:	000097c4 	andeq	r9, r0, r4, asr #15
    1c20:	00000098 	muleq	r0, r8, r0
    1c24:	0011d30e 	andseq	sp, r1, lr, lsl #6
    1c28:	08ef0100 	stmiaeq	pc!, {r8}^	; <UNPREDICTABLE>
    1c2c:	0000023f 	andeq	r0, r0, pc, lsr r2
    1c30:	7fac9103 	svcvc	0x00ac9103
    1c34:	0097f40f 	addseq	pc, r7, pc, lsl #8
    1c38:	00006800 	andeq	r6, r0, r0, lsl #16
    1c3c:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1c40:	230cf201 	movwcs	pc, #49665	; 0xc201	; <UNPREDICTABLE>
    1c44:	02000001 	andeq	r0, r0, #1
    1c48:	00006891 	muleq	r0, r1, r8
    1c4c:	90041200 	andls	r1, r4, r0, lsl #4
    1c50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1c54:	00000090 	muleq	r0, r0, r0
    1c58:	0000023f 	andeq	r0, r0, pc, lsr r2
    1c5c:	00008409 	andeq	r8, r0, r9, lsl #8
    1c60:	08001f00 	stmdaeq	r0, {r8, r9, sl, fp, ip}
    1c64:	00000090 	muleq	r0, r0, r0
    1c68:	0000024f 	andeq	r0, r0, pc, asr #4
    1c6c:	00008409 	andeq	r8, r0, r9, lsl #8
    1c70:	14000800 	strne	r0, [r0], #-2048	; 0xfffff800
    1c74:	000012a2 	andeq	r1, r0, r2, lsr #5
    1c78:	7106bb01 	tstvc	r6, r1, lsl #22
    1c7c:	2c000013 	stccs	0, cr0, [r0], {19}
    1c80:	30000095 	mulcc	r0, r5, r0
    1c84:	01000000 	mrseq	r0, (UNDEF: 0)
    1c88:	0002869c 	muleq	r2, ip, r6
    1c8c:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    1c90:	3711bb01 	ldrcc	fp, [r1, -r1, lsl #22]
    1c94:	02000000 	andeq	r0, r0, #0
    1c98:	620c7491 	andvs	r7, ip, #-1862270976	; 0x91000000
    1c9c:	01007266 	tsteq	r0, r6, ror #4
    1ca0:	02291abb 	eoreq	r1, r9, #765952	; 0xbb000
    1ca4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca8:	a90b0070 	stmdbge	fp, {r4, r5, r6}
    1cac:	01000011 	tsteq	r0, r1, lsl r0
    1cb0:	126006b5 	rsbne	r0, r0, #189792256	; 0xb500000
    1cb4:	02b20000 	adcseq	r0, r2, #0
    1cb8:	94ec0000 	strbtls	r0, [ip], #0
    1cbc:	00400000 	subeq	r0, r0, r0
    1cc0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cc4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    1cc8:	0100780c 	tsteq	r0, ip, lsl #16
    1ccc:	003712b5 	ldrhteq	r1, [r7], -r5
    1cd0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cd4:	01030074 	tsteq	r3, r4, ror r0
    1cd8:	00081702 	andeq	r1, r8, r2, lsl #14
    1cdc:	119a0b00 	orrsne	r0, sl, r0, lsl #22
    1ce0:	b0010000 	andlt	r0, r1, r0
    1ce4:	00121d06 	andseq	r1, r2, r6, lsl #26
    1ce8:	0002b200 	andeq	fp, r2, r0, lsl #4
    1cec:	0094b000 	addseq	fp, r4, r0
    1cf0:	00003c00 	andeq	r3, r0, r0, lsl #24
    1cf4:	e59c0100 	ldr	r0, [ip, #256]	; 0x100
    1cf8:	0c000002 	stceq	0, cr0, [r0], {2}
    1cfc:	b0010078 	andlt	r0, r1, r8, ror r0
    1d00:	00003712 	andeq	r3, r0, r2, lsl r7
    1d04:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d08:	13591400 	cmpne	r9, #0, 8
    1d0c:	a5010000 	strge	r0, [r1, #-0]
    1d10:	0012a706 	andseq	sl, r2, r6, lsl #14
    1d14:	0093dc00 	addseq	sp, r3, r0, lsl #24
    1d18:	0000d400 	andeq	sp, r0, r0, lsl #8
    1d1c:	3a9c0100 	bcc	fe702124 <__bss_end+0xfe6f8464>
    1d20:	0c000003 	stceq	0, cr0, [r0], {3}
    1d24:	a5010078 	strge	r0, [r1, #-120]	; 0xffffff88
    1d28:	0000842b 	andeq	r8, r0, fp, lsr #8
    1d2c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1d30:	7266620c 	rsbvc	r6, r6, #12, 4	; 0xc0000000
    1d34:	34a50100 	strtcc	r0, [r5], #256	; 0x100
    1d38:	00000229 	andeq	r0, r0, r9, lsr #4
    1d3c:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    1d40:	000012f3 	strdeq	r1, [r0], -r3
    1d44:	233da501 	teqcs	sp, #4194304	; 0x400000
    1d48:	02000001 	andeq	r0, r0, #1
    1d4c:	e50e6491 	str	r6, [lr, #-1169]	; 0xfffffb6f
    1d50:	01000012 	tsteq	r0, r2, lsl r0
    1d54:	012306a7 	smulwbeq	r3, r7, r6
    1d58:	91020000 	mrsls	r0, (UNDEF: 2)
    1d5c:	18170074 	ldmdane	r7, {r2, r4, r5, r6}
    1d60:	01000013 	tsteq	r0, r3, lsl r0
    1d64:	12730683 	rsbsne	r0, r3, #137363456	; 0x8300000
    1d68:	8f9c0000 	svchi	0x009c0000
    1d6c:	04400000 	strbeq	r0, [r0], #-0
    1d70:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d74:	0000039e 	muleq	r0, lr, r3
    1d78:	0100780c 	tsteq	r0, ip, lsl #16
    1d7c:	00371883 	eorseq	r1, r7, r3, lsl #17
    1d80:	91020000 	mrsls	r0, (UNDEF: 2)
    1d84:	11a0156c 	rorne	r1, ip, #10
    1d88:	83010000 	movwhi	r0, #4096	; 0x1000
    1d8c:	00039e29 	andeq	r9, r3, r9, lsr #28
    1d90:	68910200 	ldmvs	r1, {r9}
    1d94:	0011af15 	andseq	sl, r1, r5, lsl pc
    1d98:	41830100 	orrmi	r0, r3, r0, lsl #2
    1d9c:	0000039e 	muleq	r0, lr, r3
    1da0:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    1da4:	000011f8 	strdeq	r1, [r0], -r8
    1da8:	a44f8301 	strbge	r8, [pc], #-769	; 1db0 <shift+0x1db0>
    1dac:	02000003 	andeq	r0, r0, #3
    1db0:	900e6091 	mulls	lr, r1, r0
    1db4:	01000011 	tsteq	r0, r1, lsl r0
    1db8:	00370b96 	mlaseq	r7, r6, fp, r0
    1dbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc0:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1dc4:	00000084 	andeq	r0, r0, r4, lsl #1
    1dc8:	01230418 			; <UNDEFINED> instruction: 0x01230418
    1dcc:	8a140000 	bhi	501dd4 <__bss_end+0x4f8114>
    1dd0:	01000013 	tsteq	r0, r3, lsl r0
    1dd4:	12110676 	andsne	r0, r1, #123731968	; 0x7600000
    1dd8:	8ed80000 	cdphi	0, 13, cr0, cr8, cr0, {0}
    1ddc:	00c40000 	sbceq	r0, r4, r0
    1de0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1de4:	000003ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1de8:	00125015 	andseq	r5, r2, r5, lsl r0
    1dec:	13760100 	cmnne	r6, #0, 2
    1df0:	00000229 	andeq	r0, r0, r9, lsr #4
    1df4:	0d649102 	stfeqp	f1, [r4, #-8]!
    1df8:	78010069 	stmdavc	r1, {r0, r3, r5, r6}
    1dfc:	00012309 	andeq	r2, r1, r9, lsl #6
    1e00:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e04:	6e656c0d 	cdpvs	12, 6, cr6, cr5, cr13, {0}
    1e08:	0c780100 	ldfeqe	f0, [r8], #-0
    1e0c:	00000123 	andeq	r0, r0, r3, lsr #2
    1e10:	0e709102 	expeqs	f1, f2
    1e14:	00001232 	andeq	r1, r0, r2, lsr r2
    1e18:	23117801 	tstcs	r1, #65536	; 0x10000
    1e1c:	02000001 	andeq	r0, r0, #1
    1e20:	19006c91 	stmdbne	r0, {r0, r4, r7, sl, fp, sp, lr}
    1e24:	00776f70 	rsbseq	r6, r7, r0, ror pc
    1e28:	6a076d01 	bvs	1dd234 <__bss_end+0x1d3574>
    1e2c:	37000012 	smladcc	r0, r2, r0, r0
    1e30:	6c000000 	stcvs	0, cr0, [r0], {-0}
    1e34:	6c00008e 	stcvs	0, cr0, [r0], {142}	; 0x8e
    1e38:	01000000 	mrseq	r0, (UNDEF: 0)
    1e3c:	00045c9c 	muleq	r4, ip, ip
    1e40:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    1e44:	3e176d01 	cdpcc	13, 1, cr6, cr7, cr1, {0}
    1e48:	02000000 	andeq	r0, r0, #0
    1e4c:	6e0c6c91 	mcrvs	12, 0, r6, cr12, cr1, {4}
    1e50:	2d6d0100 	stfcse	f0, [sp, #-0]
    1e54:	0000008b 	andeq	r0, r0, fp, lsl #1
    1e58:	0d689102 	stfeqp	f1, [r8, #-8]!
    1e5c:	6f010072 	svcvs	0x00010072
    1e60:	0000370b 	andeq	r3, r0, fp, lsl #14
    1e64:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e68:	008e880f 	addeq	r8, lr, pc, lsl #16
    1e6c:	00003800 	andeq	r3, r0, r0, lsl #16
    1e70:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    1e74:	84167001 	ldrhi	r7, [r6], #-1
    1e78:	02000000 	andeq	r0, r0, #0
    1e7c:	00007091 	muleq	r0, r1, r0
    1e80:	0012de17 	andseq	sp, r2, r7, lsl lr
    1e84:	06640100 	strbteq	r0, [r4], -r0, lsl #2
    1e88:	00001146 	andeq	r1, r0, r6, asr #2
    1e8c:	00008dec 	andeq	r8, r0, ip, ror #27
    1e90:	00000080 	andeq	r0, r0, r0, lsl #1
    1e94:	04d99c01 	ldrbeq	r9, [r9], #3073	; 0xc01
    1e98:	730c0000 	movwvc	r0, #49152	; 0xc000
    1e9c:	01006372 	tsteq	r0, r2, ror r3
    1ea0:	04d91964 	ldrbeq	r1, [r9], #2404	; 0x964
    1ea4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ea8:	73640c64 	cmnvc	r4, #100, 24	; 0x6400
    1eac:	64010074 	strvs	r0, [r1], #-116	; 0xffffff8c
    1eb0:	0004e024 	andeq	lr, r4, r4, lsr #32
    1eb4:	60910200 	addsvs	r0, r1, r0, lsl #4
    1eb8:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    1ebc:	2d640100 	stfcse	f0, [r4, #-0]
    1ec0:	00000123 	andeq	r0, r0, r3, lsr #2
    1ec4:	0e5c9102 	logeqe	f1, f2
    1ec8:	000012c7 	andeq	r1, r0, r7, asr #5
    1ecc:	1d0e6601 	stcne	6, cr6, [lr, #-4]
    1ed0:	02000001 	andeq	r0, r0, #1
    1ed4:	8f0e7091 	svchi	0x000e7091
    1ed8:	01000012 	tsteq	r0, r2, lsl r0
    1edc:	02290867 	eoreq	r0, r9, #6750208	; 0x670000
    1ee0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ee4:	8e140f6c 	cdphi	15, 1, cr0, cr4, cr12, {3}
    1ee8:	00480000 	subeq	r0, r8, r0
    1eec:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1ef0:	0b690100 	bleq	1a422f8 <__bss_end+0x1a38638>
    1ef4:	00000123 	andeq	r0, r0, r3, lsr #2
    1ef8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1efc:	df041200 	svcle	0x00041200
    1f00:	1a000004 	bne	1f18 <shift+0x1f18>
    1f04:	d817041b 	ldmdale	r7, {r0, r1, r3, r4, sl}
    1f08:	01000012 	tsteq	r0, r2, lsl r0
    1f0c:	1237065c 	eorsne	r0, r7, #92, 12	; 0x5c00000
    1f10:	8d840000 	stchi	0, cr0, [r4]
    1f14:	00680000 	rsbeq	r0, r8, r0
    1f18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f1c:	00000541 	andeq	r0, r0, r1, asr #10
    1f20:	00137c15 	andseq	r7, r3, r5, lsl ip
    1f24:	125c0100 	subsne	r0, ip, #0, 2
    1f28:	000004e0 	andeq	r0, r0, r0, ror #9
    1f2c:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    1f30:	00000ae1 	andeq	r0, r0, r1, ror #21
    1f34:	231e5c01 	tstcs	lr, #256	; 0x100
    1f38:	02000001 	andeq	r0, r0, #1
    1f3c:	6d0d6891 	stcvs	8, cr6, [sp, #-580]	; 0xfffffdbc
    1f40:	01006d65 	tsteq	r0, r5, ror #26
    1f44:	0229085e 	eoreq	r0, r9, #6160384	; 0x5e0000
    1f48:	91020000 	mrsls	r0, (UNDEF: 2)
    1f4c:	8da00f70 	stchi	15, cr0, [r0, #448]!	; 0x1c0
    1f50:	003c0000 	eorseq	r0, ip, r0
    1f54:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    1f58:	0b600100 	bleq	1802360 <__bss_end+0x17f86a0>
    1f5c:	00000123 	andeq	r0, r0, r3, lsr #2
    1f60:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f64:	13830b00 	orrne	r0, r3, #0, 22
    1f68:	52010000 	andpl	r0, r1, #0
    1f6c:	00132905 	andseq	r2, r3, r5, lsl #18
    1f70:	00012300 	andeq	r2, r1, r0, lsl #6
    1f74:	008d3000 	addeq	r3, sp, r0
    1f78:	00005400 	andeq	r5, r0, r0, lsl #8
    1f7c:	7a9c0100 	bvc	fe702384 <__bss_end+0xfe6f86c4>
    1f80:	0c000005 	stceq	0, cr0, [r0], {5}
    1f84:	52010073 	andpl	r0, r1, #115	; 0x73
    1f88:	00011d18 	andeq	r1, r1, r8, lsl sp
    1f8c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1f90:	0100690d 	tsteq	r0, sp, lsl #18
    1f94:	01230654 			; <UNDEFINED> instruction: 0x01230654
    1f98:	91020000 	mrsls	r0, (UNDEF: 2)
    1f9c:	eb0b0074 	bl	2c2174 <__bss_end+0x2b84b4>
    1fa0:	01000012 	tsteq	r0, r2, lsl r0
    1fa4:	13360542 	teqne	r6, #276824064	; 0x10800000
    1fa8:	01230000 			; <UNDEFINED> instruction: 0x01230000
    1fac:	8c840000 	stchi	0, cr0, [r4], {0}
    1fb0:	00ac0000 	adceq	r0, ip, r0
    1fb4:	9c010000 	stcls	0, cr0, [r1], {-0}
    1fb8:	000005e0 	andeq	r0, r0, r0, ror #11
    1fbc:	0031730c 	eorseq	r7, r1, ip, lsl #6
    1fc0:	1d194201 	lfmne	f4, 4, [r9, #-4]
    1fc4:	02000001 	andeq	r0, r0, #1
    1fc8:	730c6c91 	movwvc	r6, #52369	; 0xcc91
    1fcc:	42010032 	andmi	r0, r1, #50	; 0x32
    1fd0:	00011d29 	andeq	r1, r1, r9, lsr #26
    1fd4:	68910200 	ldmvs	r1, {r9}
    1fd8:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    1fdc:	31420100 	mrscc	r0, (UNDEF: 82)
    1fe0:	00000123 	andeq	r0, r0, r3, lsr #2
    1fe4:	0d649102 	stfeqp	f1, [r4, #-8]!
    1fe8:	01003175 	tsteq	r0, r5, ror r1
    1fec:	05e01044 	strbeq	r1, [r0, #68]!	; 0x44
    1ff0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ff4:	32750d77 	rsbscc	r0, r5, #7616	; 0x1dc0
    1ff8:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    1ffc:	000005e0 	andeq	r0, r0, r0, ror #11
    2000:	00769102 	rsbseq	r9, r6, r2, lsl #2
    2004:	ca080103 	bgt	202418 <__bss_end+0x1f8758>
    2008:	0b000009 	bleq	2034 <shift+0x2034>
    200c:	00001243 	andeq	r1, r0, r3, asr #4
    2010:	48073601 	stmdami	r7, {r0, r9, sl, ip, sp}
    2014:	29000013 	stmdbcs	r0, {r0, r1, r4}
    2018:	c4000002 	strgt	r0, [r0], #-2
    201c:	c000008b 	andgt	r0, r0, fp, lsl #1
    2020:	01000000 	mrseq	r0, (UNDEF: 0)
    2024:	0006409c 	muleq	r6, ip, r0
    2028:	120c1500 	andne	r1, ip, #0, 10
    202c:	36010000 	strcc	r0, [r1], -r0
    2030:	00022915 	andeq	r2, r2, r5, lsl r9
    2034:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2038:	6372730c 	cmnvs	r2, #12, 6	; 0x30000000
    203c:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    2040:	0000011d 	andeq	r0, r0, sp, lsl r1
    2044:	0c689102 	stfeqp	f1, [r8], #-8
    2048:	006d756e 	rsbeq	r7, sp, lr, ror #10
    204c:	23303601 	teqcs	r0, #1048576	; 0x100000
    2050:	02000001 	andeq	r0, r0, #1
    2054:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    2058:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    205c:	00000123 	andeq	r0, r0, r3, lsr #2
    2060:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2064:	0011c30b 	andseq	ip, r1, fp, lsl #6
    2068:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    206c:	000012fa 	strdeq	r1, [r0], -sl
    2070:	00000123 	andeq	r0, r0, r3, lsr #2
    2074:	00008b28 	andeq	r8, r0, r8, lsr #22
    2078:	0000009c 	muleq	r0, ip, r0
    207c:	067d9c01 	ldrbteq	r9, [sp], -r1, lsl #24
    2080:	27150000 	ldrcs	r0, [r5, -r0]
    2084:	01000012 	tsteq	r0, r2, lsl r0
    2088:	011d1624 	tsteq	sp, r4, lsr #12
    208c:	91020000 	mrsls	r0, (UNDEF: 2)
    2090:	13050e6c 	movwne	r0, #24172	; 0x5e6c
    2094:	26010000 	strcs	r0, [r1], -r0
    2098:	00012306 	andeq	r2, r1, r6, lsl #6
    209c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    20a0:	124b1c00 	subne	r1, fp, #0, 24
    20a4:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    20a8:	0011b706 	andseq	fp, r1, r6, lsl #14
    20ac:	0089b400 	addeq	fp, r9, r0, lsl #8
    20b0:	00017400 	andeq	r7, r1, r0, lsl #8
    20b4:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    20b8:	00001227 	andeq	r1, r0, r7, lsr #4
    20bc:	84180801 	ldrhi	r0, [r8], #-2049	; 0xfffff7ff
    20c0:	02000000 	andeq	r0, r0, #0
    20c4:	05156491 	ldreq	r6, [r5, #-1169]	; 0xfffffb6f
    20c8:	01000013 	tsteq	r0, r3, lsl r0
    20cc:	02292508 	eoreq	r2, r9, #8, 10	; 0x2000000
    20d0:	91020000 	mrsls	r0, (UNDEF: 2)
    20d4:	122d1560 	eorne	r1, sp, #96, 10	; 0x18000000
    20d8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    20dc:	0000843a 	andeq	r8, r0, sl, lsr r4
    20e0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    20e4:	0100690d 	tsteq	r0, sp, lsl #18
    20e8:	0123060a 			; <UNDEFINED> instruction: 0x0123060a
    20ec:	91020000 	mrsls	r0, (UNDEF: 2)
    20f0:	8a800f74 	bhi	fe005ec8 <__bss_end+0xfdffc208>
    20f4:	00980000 	addseq	r0, r8, r0
    20f8:	6a0d0000 	bvs	342100 <__bss_end+0x338440>
    20fc:	0b1c0100 	bleq	702504 <__bss_end+0x6f8844>
    2100:	00000123 	andeq	r0, r0, r3, lsr #2
    2104:	0f709102 	svceq	0x00709102
    2108:	00008aa8 	andeq	r8, r0, r8, lsr #21
    210c:	00000060 	andeq	r0, r0, r0, rrx
    2110:	0100630d 	tsteq	r0, sp, lsl #6
    2114:	0090081e 	addseq	r0, r0, lr, lsl r8
    2118:	91020000 	mrsls	r0, (UNDEF: 2)
    211c:	0000006f 	andeq	r0, r0, pc, rrx
    2120:	00002200 	andeq	r2, r0, r0, lsl #4
    2124:	c2000200 	andgt	r0, r0, #0, 4
    2128:	04000008 	streq	r0, [r0], #-8
    212c:	000daf01 	andeq	sl, sp, r1, lsl #30
    2130:	00999000 	addseq	r9, r9, r0
    2134:	009b9c00 	addseq	r9, fp, r0, lsl #24
    2138:	00139100 	andseq	r9, r3, r0, lsl #2
    213c:	0013c100 	andseq	ip, r3, r0, lsl #2
    2140:	00006300 	andeq	r6, r0, r0, lsl #6
    2144:	22800100 	addcs	r0, r0, #0, 2
    2148:	02000000 	andeq	r0, r0, #0
    214c:	0008d600 	andeq	sp, r8, r0, lsl #12
    2150:	2c010400 	cfstrscs	mvf0, [r1], {-0}
    2154:	9c00000e 	stcls	0, cr0, [r0], {14}
    2158:	a000009b 	mulge	r0, fp, r0
    215c:	9100009b 	swpls	r0, fp, [r0]	; <UNPREDICTABLE>
    2160:	c1000013 	tstgt	r0, r3, lsl r0
    2164:	63000013 	movwvs	r0, #19
    2168:	01000000 	mrseq	r0, (UNDEF: 0)
    216c:	00093280 	andeq	r3, r9, r0, lsl #5
    2170:	ea000400 	b	3178 <shift+0x3178>
    2174:	04000008 	streq	r0, [r0], #-8
    2178:	00178f01 	andseq	r8, r7, r1, lsl #30
    217c:	16e60c00 	strbtne	r0, [r6], r0, lsl #24
    2180:	13c10000 	bicne	r0, r1, #0
    2184:	0e8c0000 	cdpeq	0, 8, cr0, cr12, cr0, {0}
    2188:	04020000 	streq	r0, [r2], #-0
    218c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2190:	07040300 	streq	r0, [r4, -r0, lsl #6]
    2194:	000018bc 			; <UNDEFINED> instruction: 0x000018bc
    2198:	1f050803 	svcne	0x00050803
    219c:	03000003 	movweq	r0, #3
    21a0:	1f8e0408 	svcne	0x008e0408
    21a4:	41040000 	mrsmi	r0, (UNDEF: 4)
    21a8:	01000017 	tsteq	r0, r7, lsl r0
    21ac:	0024162a 	eoreq	r1, r4, sl, lsr #12
    21b0:	b0040000 	andlt	r0, r4, r0
    21b4:	0100001b 	tsteq	r0, fp, lsl r0
    21b8:	0051152f 	subseq	r1, r1, pc, lsr #10
    21bc:	04050000 	streq	r0, [r5], #-0
    21c0:	00000057 	andeq	r0, r0, r7, asr r0
    21c4:	00003906 	andeq	r3, r0, r6, lsl #18
    21c8:	00006600 	andeq	r6, r0, r0, lsl #12
    21cc:	00660700 	rsbeq	r0, r6, r0, lsl #14
    21d0:	05000000 	streq	r0, [r0, #-0]
    21d4:	00006c04 	andeq	r6, r0, r4, lsl #24
    21d8:	e2040800 	and	r0, r4, #0, 16
    21dc:	01000022 	tsteq	r0, r2, lsr #32
    21e0:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    21e4:	04050000 	streq	r0, [r5], #-0
    21e8:	0000007f 	andeq	r0, r0, pc, ror r0
    21ec:	00001d06 	andeq	r1, r0, r6, lsl #26
    21f0:	00009300 	andeq	r9, r0, r0, lsl #6
    21f4:	00660700 	rsbeq	r0, r6, r0, lsl #14
    21f8:	66070000 	strvs	r0, [r7], -r0
    21fc:	00000000 	andeq	r0, r0, r0
    2200:	ca080103 	bgt	202614 <__bss_end+0x1f8954>
    2204:	09000009 	stmdbeq	r0, {r0, r3}
    2208:	00001de8 	andeq	r1, r0, r8, ror #27
    220c:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    2210:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2214:	00002310 	andeq	r2, r0, r0, lsl r3
    2218:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    221c:	03000000 	movweq	r0, #0
    2220:	09cc0601 	stmibeq	ip, {r0, r9, sl}^
    2224:	d00a0000 	andle	r0, sl, r0
    2228:	0700001a 	smladeq	r0, sl, r0, r0
    222c:	00009301 	andeq	r9, r0, r1, lsl #6
    2230:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    2234:	000001e6 	andeq	r0, r0, r6, ror #3
    2238:	00159f0b 	andseq	r9, r5, fp, lsl #30
    223c:	ed0b0000 	stc	0, cr0, [fp, #-0]
    2240:	01000019 	tsteq	r0, r9, lsl r0
    2244:	001eb30b 	andseq	fp, lr, fp, lsl #6
    2248:	240b0200 	strcs	r0, [fp], #-512	; 0xfffffe00
    224c:	03000022 	movweq	r0, #34	; 0x22
    2250:	001e570b 	andseq	r5, lr, fp, lsl #14
    2254:	2d0b0400 	cfstrscs	mvf0, [fp, #-0]
    2258:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    225c:	0020910b 	eoreq	r9, r0, fp, lsl #2
    2260:	c00b0600 	andgt	r0, fp, r0, lsl #12
    2264:	07000015 	smladeq	r0, r5, r0, r0
    2268:	0021420b 	eoreq	r4, r1, fp, lsl #4
    226c:	500b0800 	andpl	r0, fp, r0, lsl #16
    2270:	09000021 	stmdbeq	r0, {r0, r5}
    2274:	0022170b 	eoreq	r1, r2, fp, lsl #14
    2278:	ae0b0a00 	vmlage.f32	s0, s22, s0
    227c:	0b00001d 	bleq	22f8 <shift+0x22f8>
    2280:	0017820b 	andseq	r8, r7, fp, lsl #4
    2284:	5f0b0c00 	svcpl	0x000b0c00
    2288:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
    228c:	001b140b 	andseq	r1, fp, fp, lsl #8
    2290:	2a0b0e00 	bcs	2c5a98 <__bss_end+0x2bbdd8>
    2294:	0f00001b 	svceq	0x0000001b
    2298:	001a270b 	andseq	r2, sl, fp, lsl #14
    229c:	3b0b1000 	blcc	2c62a4 <__bss_end+0x2bc5e4>
    22a0:	1100001e 	tstne	r0, lr, lsl r0
    22a4:	001a930b 	andseq	r9, sl, fp, lsl #6
    22a8:	a90b1200 	stmdbge	fp, {r9, ip}
    22ac:	13000024 	movwne	r0, #36	; 0x24
    22b0:	0016290b 	andseq	r2, r6, fp, lsl #18
    22b4:	b70b1400 	strlt	r1, [fp, -r0, lsl #8]
    22b8:	1500001a 	strne	r0, [r0, #-26]	; 0xffffffe6
    22bc:	0015660b 	andseq	r6, r5, fp, lsl #12
    22c0:	470b1600 	strmi	r1, [fp, -r0, lsl #12]
    22c4:	17000022 	strne	r0, [r0, -r2, lsr #32]
    22c8:	0023690b 	eoreq	r6, r3, fp, lsl #18
    22cc:	dc0b1800 	stcle	8, cr1, [fp], {-0}
    22d0:	1900001a 	stmdbne	r0, {r1, r3, r4}
    22d4:	001f250b 	andseq	r2, pc, fp, lsl #10
    22d8:	550b1a00 	strpl	r1, [fp, #-2560]	; 0xfffff600
    22dc:	1b000022 	blne	236c <shift+0x236c>
    22e0:	0014950b 	andseq	r9, r4, fp, lsl #10
    22e4:	630b1c00 	movwvs	r1, #48128	; 0xbc00
    22e8:	1d000022 	stcne	0, cr0, [r0, #-136]	; 0xffffff78
    22ec:	0022710b 	eoreq	r7, r2, fp, lsl #2
    22f0:	430b1e00 	movwmi	r1, #48640	; 0xbe00
    22f4:	1f000014 	svcne	0x00000014
    22f8:	00229b0b 	eoreq	r9, r2, fp, lsl #22
    22fc:	d20b2000 	andle	r2, fp, #0
    2300:	2100001f 	tstcs	r0, pc, lsl r0
    2304:	001e0d0b 	andseq	r0, lr, fp, lsl #26
    2308:	3a0b2200 	bcc	2cab10 <__bss_end+0x2c0e50>
    230c:	23000022 	movwcs	r0, #34	; 0x22
    2310:	001d110b 	andseq	r1, sp, fp, lsl #2
    2314:	130b2400 	movwne	r2, #46080	; 0xb400
    2318:	2500001c 	strcs	r0, [r0, #-28]	; 0xffffffe4
    231c:	00192d0b 	andseq	r2, r9, fp, lsl #26
    2320:	310b2600 	tstcc	fp, r0, lsl #12
    2324:	2700001c 	smladcs	r0, ip, r0, r0
    2328:	0019c90b 	andseq	ip, r9, fp, lsl #18
    232c:	410b2800 	tstmi	fp, r0, lsl #16
    2330:	2900001c 	stmdbcs	r0, {r2, r3, r4}
    2334:	001c510b 	andseq	r5, ip, fp, lsl #2
    2338:	940b2a00 	strls	r2, [fp], #-2560	; 0xfffff600
    233c:	2b00001d 	blcs	23b8 <shift+0x23b8>
    2340:	001bba0b 	andseq	fp, fp, fp, lsl #20
    2344:	df0b2c00 	svcle	0x000b2c00
    2348:	2d00001f 	stccs	0, cr0, [r0, #-124]	; 0xffffff84
    234c:	00196e0b 	andseq	r6, r9, fp, lsl #28
    2350:	0a002e00 	beq	db58 <__bss_end+0x3e98>
    2354:	00001b4c 	andeq	r1, r0, ip, asr #22
    2358:	00930107 	addseq	r0, r3, r7, lsl #2
    235c:	17030000 	strne	r0, [r3, -r0]
    2360:	0003c706 	andeq	ip, r3, r6, lsl #14
    2364:	18810b00 	stmne	r1, {r8, r9, fp}
    2368:	0b000000 	bleq	2370 <shift+0x2370>
    236c:	000014d3 	ldrdeq	r1, [r0], -r3
    2370:	24570b01 	ldrbcs	r0, [r7], #-2817	; 0xfffff4ff
    2374:	0b020000 	bleq	8237c <__bss_end+0x786bc>
    2378:	000022ea 	andeq	r2, r0, sl, ror #5
    237c:	18a10b03 	stmiane	r1!, {r0, r1, r8, r9, fp}
    2380:	0b040000 	bleq	102388 <__bss_end+0xf86c8>
    2384:	0000158b 	andeq	r1, r0, fp, lsl #11
    2388:	194a0b05 	stmdbne	sl, {r0, r2, r8, r9, fp}^
    238c:	0b060000 	bleq	182394 <__bss_end+0x1786d4>
    2390:	00001891 	muleq	r0, r1, r8
    2394:	217e0b07 	cmncs	lr, r7, lsl #22
    2398:	0b080000 	bleq	2023a0 <__bss_end+0x1f86e0>
    239c:	000022cf 	andeq	r2, r0, pc, asr #5
    23a0:	20b50b09 	adcscs	r0, r5, r9, lsl #22
    23a4:	0b0a0000 	bleq	2823ac <__bss_end+0x2786ec>
    23a8:	000015de 	ldrdeq	r1, [r0], -lr
    23ac:	18eb0b0b 	stmiane	fp!, {r0, r1, r3, r8, r9, fp}^
    23b0:	0b0c0000 	bleq	3023b8 <__bss_end+0x2f86f8>
    23b4:	00001554 	andeq	r1, r0, r4, asr r5
    23b8:	248c0b0d 	strcs	r0, [ip], #2829	; 0xb0d
    23bc:	0b0e0000 	bleq	3823c4 <__bss_end+0x378704>
    23c0:	00001d81 	andeq	r1, r0, r1, lsl #27
    23c4:	1a5e0b0f 	bne	1785008 <__bss_end+0x177b348>
    23c8:	0b100000 	bleq	4023d0 <__bss_end+0x3f8710>
    23cc:	00001dbe 			; <UNDEFINED> instruction: 0x00001dbe
    23d0:	23ab0b11 			; <UNDEFINED> instruction: 0x23ab0b11
    23d4:	0b120000 	bleq	4823dc <__bss_end+0x47871c>
    23d8:	000016a1 	andeq	r1, r0, r1, lsr #13
    23dc:	1a710b13 	bne	1c45030 <__bss_end+0x1c3b370>
    23e0:	0b140000 	bleq	5023e8 <__bss_end+0x4f8728>
    23e4:	00001cd4 	ldrdeq	r1, [r0], -r4
    23e8:	186c0b15 	stmdane	ip!, {r0, r2, r4, r8, r9, fp}^
    23ec:	0b160000 	bleq	5823f4 <__bss_end+0x578734>
    23f0:	00001d20 	andeq	r1, r0, r0, lsr #26
    23f4:	1b360b17 	blne	d85058 <__bss_end+0xd7b398>
    23f8:	0b180000 	bleq	602400 <__bss_end+0x5f8740>
    23fc:	000015a9 	andeq	r1, r0, r9, lsr #11
    2400:	23520b19 	cmpcs	r2, #25600	; 0x6400
    2404:	0b1a0000 	bleq	68240c <__bss_end+0x67874c>
    2408:	00001ca0 	andeq	r1, r0, r0, lsr #25
    240c:	1a480b1b 	bne	1205080 <__bss_end+0x11fb3c0>
    2410:	0b1c0000 	bleq	702418 <__bss_end+0x6f8758>
    2414:	0000147e 	andeq	r1, r0, lr, ror r4
    2418:	1beb0b1d 	blne	ffac5094 <__bss_end+0xffabb3d4>
    241c:	0b1e0000 	bleq	782424 <__bss_end+0x778764>
    2420:	00001bd7 	ldrdeq	r1, [r0], -r7
    2424:	20720b1f 	rsbscs	r0, r2, pc, lsl fp
    2428:	0b200000 	bleq	802430 <__bss_end+0x7f8770>
    242c:	000020fd 	strdeq	r2, [r0], -sp
    2430:	23310b21 	teqcs	r1, #33792	; 0x8400
    2434:	0b220000 	bleq	88243c <__bss_end+0x87877c>
    2438:	0000197b 	andeq	r1, r0, fp, ror r9
    243c:	1ed50b23 	vfnmsne.f64	d16, d5, d19
    2440:	0b240000 	bleq	902448 <__bss_end+0x8f8788>
    2444:	000020ca 	andeq	r2, r0, sl, asr #1
    2448:	1fee0b25 	svcne	0x00ee0b25
    244c:	0b260000 	bleq	982454 <__bss_end+0x978794>
    2450:	00002002 	andeq	r2, r0, r2
    2454:	20160b27 	andscs	r0, r6, r7, lsr #22
    2458:	0b280000 	bleq	a02460 <__bss_end+0x9f87a0>
    245c:	0000172c 	andeq	r1, r0, ip, lsr #14
    2460:	168c0b29 	strne	r0, [ip], r9, lsr #22
    2464:	0b2a0000 	bleq	a8246c <__bss_end+0xa787ac>
    2468:	000016b4 			; <UNDEFINED> instruction: 0x000016b4
    246c:	21c70b2b 	biccs	r0, r7, fp, lsr #22
    2470:	0b2c0000 	bleq	b02478 <__bss_end+0xaf87b8>
    2474:	00001709 	andeq	r1, r0, r9, lsl #14
    2478:	21db0b2d 	bicscs	r0, fp, sp, lsr #22
    247c:	0b2e0000 	bleq	b82484 <__bss_end+0xb787c4>
    2480:	000021ef 	andeq	r2, r0, pc, ror #3
    2484:	22030b2f 	andcs	r0, r3, #48128	; 0xbc00
    2488:	0b300000 	bleq	c02490 <__bss_end+0xbf87d0>
    248c:	000018fd 	strdeq	r1, [r0], -sp
    2490:	18d70b31 	ldmne	r7, {r0, r4, r5, r8, r9, fp}^
    2494:	0b320000 	bleq	c8249c <__bss_end+0xc787dc>
    2498:	00001bff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    249c:	1dd10b33 	vldrne	d16, [r1, #204]	; 0xcc
    24a0:	0b340000 	bleq	d024a8 <__bss_end+0xcf87e8>
    24a4:	000023e0 	andeq	r2, r0, r0, ror #7
    24a8:	14260b35 	strtne	r0, [r6], #-2869	; 0xfffff4cb
    24ac:	0b360000 	bleq	d824b4 <__bss_end+0xd787f4>
    24b0:	000019fd 	strdeq	r1, [r0], -sp
    24b4:	1a120b37 	bne	485198 <__bss_end+0x47b4d8>
    24b8:	0b380000 	bleq	e024c0 <__bss_end+0xdf8800>
    24bc:	00001c61 	andeq	r1, r0, r1, ror #24
    24c0:	1c8b0b39 	fstmiaxne	fp, {d0-d27}	;@ Deprecated
    24c4:	0b3a0000 	bleq	e824cc <__bss_end+0xe7880c>
    24c8:	00002409 	andeq	r2, r0, r9, lsl #8
    24cc:	1ec00b3b 			; <UNDEFINED> instruction: 0x1ec00b3b
    24d0:	0b3c0000 	bleq	f024d8 <__bss_end+0xef8818>
    24d4:	000019a0 	andeq	r1, r0, r0, lsr #19
    24d8:	14e50b3d 	strbtne	r0, [r5], #2877	; 0xb3d
    24dc:	0b3e0000 	bleq	f824e4 <__bss_end+0xf78824>
    24e0:	000014a3 	andeq	r1, r0, r3, lsr #9
    24e4:	1e1d0b3f 	vmovne.s16	r0, d13[0]
    24e8:	0b400000 	bleq	10024f0 <__bss_end+0xff8830>
    24ec:	00001f41 	andeq	r1, r0, r1, asr #30
    24f0:	20540b41 	subscs	r0, r4, r1, asr #22
    24f4:	0b420000 	bleq	10824fc <__bss_end+0x107883c>
    24f8:	00001c76 	andeq	r1, r0, r6, ror ip
    24fc:	24420b43 	strbcs	r0, [r2], #-2883	; 0xfffff4bd
    2500:	0b440000 	bleq	1102508 <__bss_end+0x10f8848>
    2504:	00001eeb 	andeq	r1, r0, fp, ror #29
    2508:	16d00b45 	ldrbne	r0, [r0], r5, asr #22
    250c:	0b460000 	bleq	1182514 <__bss_end+0x1178854>
    2510:	00001d51 	andeq	r1, r0, r1, asr sp
    2514:	1b840b47 	blne	fe105238 <__bss_end+0xfe0fb578>
    2518:	0b480000 	bleq	1202520 <__bss_end+0x11f8860>
    251c:	00001462 	andeq	r1, r0, r2, ror #8
    2520:	15760b49 	ldrbne	r0, [r6, #-2889]!	; 0xfffff4b7
    2524:	0b4a0000 	bleq	128252c <__bss_end+0x127886c>
    2528:	000019b4 			; <UNDEFINED> instruction: 0x000019b4
    252c:	1cb20b4b 	fldmiaxne	r2!, {d0-d36}	;@ Deprecated
    2530:	004c0000 	subeq	r0, ip, r0
    2534:	9d070203 	sfmls	f0, 4, [r7, #-12]
    2538:	0c000007 	stceq	0, cr0, [r0], {7}
    253c:	000003e4 	andeq	r0, r0, r4, ror #7
    2540:	000003d9 	ldrdeq	r0, [r0], -r9
    2544:	ce0e000d 	cdpgt	0, 0, cr0, cr14, cr13, {0}
    2548:	05000003 	streq	r0, [r0, #-3]
    254c:	0003f004 	andeq	pc, r3, r4
    2550:	03de0e00 	bicseq	r0, lr, #0, 28
    2554:	01030000 	mrseq	r0, (UNDEF: 3)
    2558:	0009d308 	andeq	sp, r9, r8, lsl #6
    255c:	03e90e00 	mvneq	r0, #0, 28
    2560:	1a0f0000 	bne	3c2568 <__bss_end+0x3b88a8>
    2564:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    2568:	d91a014c 	ldmdble	sl, {r2, r3, r6, r8}
    256c:	0f000003 	svceq	0x00000003
    2570:	00001a38 	andeq	r1, r0, r8, lsr sl
    2574:	1a018204 	bne	62d8c <__bss_end+0x590cc>
    2578:	000003d9 	ldrdeq	r0, [r0], -r9
    257c:	0003e90c 	andeq	lr, r3, ip, lsl #18
    2580:	00041a00 	andeq	r1, r4, r0, lsl #20
    2584:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2588:	00001c23 	andeq	r1, r0, r3, lsr #24
    258c:	0f0d2d05 	svceq	0x000d2d05
    2590:	09000004 	stmdbeq	r0, {r2}
    2594:	000022ab 	andeq	r2, r0, fp, lsr #5
    2598:	e61c3805 	ldr	r3, [ip], -r5, lsl #16
    259c:	0a000001 	beq	25a8 <shift+0x25a8>
    25a0:	00001911 	andeq	r1, r0, r1, lsl r9
    25a4:	00930107 	addseq	r0, r3, r7, lsl #2
    25a8:	3a050000 	bcc	1425b0 <__bss_end+0x1388f0>
    25ac:	0004a50e 	andeq	sl, r4, lr, lsl #10
    25b0:	14770b00 	ldrbtne	r0, [r7], #-2816	; 0xfffff500
    25b4:	0b000000 	bleq	25bc <shift+0x25bc>
    25b8:	00001b23 	andeq	r1, r0, r3, lsr #22
    25bc:	23bd0b01 			; <UNDEFINED> instruction: 0x23bd0b01
    25c0:	0b020000 	bleq	825c8 <__bss_end+0x78908>
    25c4:	00002380 	andeq	r2, r0, r0, lsl #7
    25c8:	1e7a0b03 	vaddne.f64	d16, d10, d3
    25cc:	0b040000 	bleq	1025d4 <__bss_end+0xf8914>
    25d0:	0000213b 	andeq	r2, r0, fp, lsr r1
    25d4:	165d0b05 	ldrbne	r0, [sp], -r5, lsl #22
    25d8:	0b060000 	bleq	1825e0 <__bss_end+0x178920>
    25dc:	0000163f 	andeq	r1, r0, pc, lsr r6
    25e0:	18580b07 	ldmdane	r8, {r0, r1, r2, r8, r9, fp}^
    25e4:	0b080000 	bleq	2025ec <__bss_end+0x1f892c>
    25e8:	00001d36 	andeq	r1, r0, r6, lsr sp
    25ec:	16640b09 	strbtne	r0, [r4], -r9, lsl #22
    25f0:	0b0a0000 	bleq	2825f8 <__bss_end+0x278938>
    25f4:	00001d3d 	andeq	r1, r0, sp, lsr sp
    25f8:	16c90b0b 	strbne	r0, [r9], fp, lsl #22
    25fc:	0b0c0000 	bleq	302604 <__bss_end+0x2f8944>
    2600:	00001656 	andeq	r1, r0, r6, asr r6
    2604:	21920b0d 	orrscs	r0, r2, sp, lsl #22
    2608:	0b0e0000 	bleq	382610 <__bss_end+0x378950>
    260c:	00001f5f 	andeq	r1, r0, pc, asr pc
    2610:	8a04000f 	bhi	102654 <__bss_end+0xf8994>
    2614:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2618:	0432013f 	ldrteq	r0, [r2], #-319	; 0xfffffec1
    261c:	1e090000 	cdpne	0, 0, cr0, cr9, cr0, {0}
    2620:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2624:	04a50f41 	strteq	r0, [r5], #3905	; 0xf41
    2628:	a6090000 	strge	r0, [r9], -r0
    262c:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2630:	001d0c4a 	andseq	r0, sp, sl, asr #24
    2634:	fe090000 	cdp2	0, 0, cr0, cr9, cr0, {0}
    2638:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    263c:	001d0c4b 	andseq	r0, sp, fp, asr #24
    2640:	7f100000 	svcvc	0x00100000
    2644:	09000022 	stmdbeq	r0, {r1, r5}
    2648:	000021b7 			; <UNDEFINED> instruction: 0x000021b7
    264c:	e6144c05 	ldr	r4, [r4], -r5, lsl #24
    2650:	05000004 	streq	r0, [r0, #-4]
    2654:	0004d504 	andeq	sp, r4, r4, lsl #10
    2658:	ed091100 	stfs	f1, [r9, #-0]
    265c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2660:	04f90f4e 	ldrbteq	r0, [r9], #3918	; 0xf4e
    2664:	04050000 	streq	r0, [r5], #-0
    2668:	000004ec 	andeq	r0, r0, ip, ror #9
    266c:	0020a012 	eoreq	sl, r0, r2, lsl r0
    2670:	1e670900 	vmulne.f16	s1, s14, s0	; <UNPREDICTABLE>
    2674:	52050000 	andpl	r0, r5, #0
    2678:	0005100d 	andeq	r1, r5, sp
    267c:	ff040500 			; <UNDEFINED> instruction: 0xff040500
    2680:	13000004 	movwne	r0, #4
    2684:	00001775 	andeq	r1, r0, r5, ror r7
    2688:	01670534 	cmneq	r7, r4, lsr r5
    268c:	00054115 	andeq	r4, r5, r5, lsl r1
    2690:	1c2c1400 	cfstrsne	mvf1, [ip], #-0
    2694:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    2698:	03de0f01 	bicseq	r0, lr, #1, 30
    269c:	14000000 	strne	r0, [r0], #-0
    26a0:	00001759 	andeq	r1, r0, r9, asr r7
    26a4:	14016a05 	strne	r6, [r1], #-2565	; 0xfffff5fb
    26a8:	00000546 	andeq	r0, r0, r6, asr #10
    26ac:	160e0004 	strne	r0, [lr], -r4
    26b0:	0c000005 	stceq	0, cr0, [r0], {5}
    26b4:	000000b9 	strheq	r0, [r0], -r9
    26b8:	00000556 	andeq	r0, r0, r6, asr r5
    26bc:	00002415 	andeq	r2, r0, r5, lsl r4
    26c0:	0c002d00 	stceq	13, cr2, [r0], {-0}
    26c4:	00000541 	andeq	r0, r0, r1, asr #10
    26c8:	00000561 	andeq	r0, r0, r1, ror #10
    26cc:	560e000d 	strpl	r0, [lr], -sp
    26d0:	0f000005 	svceq	0x00000005
    26d4:	00001b5b 	andeq	r1, r0, fp, asr fp
    26d8:	03016b05 	movweq	r6, #6917	; 0x1b05
    26dc:	00000561 	andeq	r0, r0, r1, ror #10
    26e0:	001da10f 	andseq	sl, sp, pc, lsl #2
    26e4:	016e0500 	cmneq	lr, r0, lsl #10
    26e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26ec:	20de1600 	sbcscs	r1, lr, r0, lsl #12
    26f0:	01070000 	mrseq	r0, (UNDEF: 7)
    26f4:	00000093 	muleq	r0, r3, r0
    26f8:	06018105 	streq	r8, [r1], -r5, lsl #2
    26fc:	0000062a 	andeq	r0, r0, sl, lsr #12
    2700:	00150c0b 	andseq	r0, r5, fp, lsl #24
    2704:	180b0000 	stmdane	fp, {}	; <UNPREDICTABLE>
    2708:	02000015 	andeq	r0, r0, #21
    270c:	0015240b 	andseq	r2, r5, fp, lsl #8
    2710:	3d0b0300 	stccc	3, cr0, [fp, #-0]
    2714:	03000019 	movweq	r0, #25
    2718:	0015300b 	andseq	r3, r5, fp
    271c:	860b0400 	strhi	r0, [fp], -r0, lsl #8
    2720:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
    2724:	001b6c0b 	andseq	r6, fp, fp, lsl #24
    2728:	c20b0500 	andgt	r0, fp, #0, 10
    272c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2730:	0015ef0b 	andseq	lr, r5, fp, lsl #30
    2734:	3c0b0500 	cfstr32cc	mvfx0, [fp], {-0}
    2738:	06000015 			; <UNDEFINED> instruction: 0x06000015
    273c:	001cea0b 	andseq	lr, ip, fp, lsl #20
    2740:	4b0b0600 	blmi	2c3f48 <__bss_end+0x2ba288>
    2744:	06000017 			; <UNDEFINED> instruction: 0x06000017
    2748:	001cf70b 	andseq	pc, ip, fp, lsl #14
    274c:	5e0b0600 	cfmadd32pl	mvax0, mvfx0, mvfx11, mvfx0
    2750:	06000021 	streq	r0, [r0], -r1, lsr #32
    2754:	001d040b 	andseq	r0, sp, fp, lsl #8
    2758:	440b0600 	strmi	r0, [fp], #-1536	; 0xfffffa00
    275c:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    2760:	0015480b 	andseq	r4, r5, fp, lsl #16
    2764:	4a0b0700 	bmi	2c436c <__bss_end+0x2ba6ac>
    2768:	0700001e 	smladeq	r0, lr, r0, r0
    276c:	001e970b 	andseq	r9, lr, fp, lsl #14
    2770:	990b0700 	stmdbls	fp, {r8, r9, sl}
    2774:	07000021 	streq	r0, [r0, -r1, lsr #32]
    2778:	00171e0b 	andseq	r1, r7, fp, lsl #28
    277c:	180b0700 	stmdane	fp, {r8, r9, sl}
    2780:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    2784:	0014c10b 	andseq	ip, r4, fp, lsl #2
    2788:	6c0b0800 	stcvs	8, cr0, [fp], {-0}
    278c:	08000021 	stmdaeq	r0, {r0, r5}
    2790:	001f340b 	andseq	r3, pc, fp, lsl #8
    2794:	0f000800 	svceq	0x00000800
    2798:	000023d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    279c:	1f019f05 	svcne	0x00019f05
    27a0:	00000580 	andeq	r0, r0, r0, lsl #11
    27a4:	001f660f 	andseq	r6, pc, pc, lsl #12
    27a8:	01a20500 			; <UNDEFINED> instruction: 0x01a20500
    27ac:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27b0:	1b790f00 	blne	1e463b8 <__bss_end+0x1e3c6f8>
    27b4:	a5050000 	strge	r0, [r5, #-0]
    27b8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27bc:	9e0f0000 	cdpls	0, 0, cr0, cr15, cr0, {0}
    27c0:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    27c4:	1d0c01a8 	stfnes	f0, [ip, #-672]	; 0xfffffd60
    27c8:	0f000000 	svceq	0x00000000
    27cc:	0000160e 	andeq	r1, r0, lr, lsl #12
    27d0:	0c01ab05 			; <UNDEFINED> instruction: 0x0c01ab05
    27d4:	0000001d 	andeq	r0, r0, sp, lsl r0
    27d8:	001f700f 	andseq	r7, pc, pc
    27dc:	01ae0500 			; <UNDEFINED> instruction: 0x01ae0500
    27e0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27e4:	1e810f00 	cdpne	15, 8, cr0, cr1, cr0, {0}
    27e8:	b1050000 	mrslt	r0, (UNDEF: 5)
    27ec:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27f0:	8c0f0000 	stchi	0, cr0, [pc], {-0}
    27f4:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    27f8:	1d0c01b4 	stfnes	f0, [ip, #-720]	; 0xfffffd30
    27fc:	0f000000 	svceq	0x00000000
    2800:	00001f7a 	andeq	r1, r0, sl, ror pc
    2804:	0c01b705 	stceq	7, cr11, [r1], {5}
    2808:	0000001d 	andeq	r0, r0, sp, lsl r0
    280c:	001cc60f 	andseq	ip, ip, pc, lsl #12
    2810:	01ba0500 			; <UNDEFINED> instruction: 0x01ba0500
    2814:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2818:	23fd0f00 	mvnscs	r0, #0, 30
    281c:	bd050000 	stclt	0, cr0, [r5, #-0]
    2820:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2824:	840f0000 	strhi	r0, [pc], #-0	; 282c <shift+0x282c>
    2828:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    282c:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    2830:	0f000000 	svceq	0x00000000
    2834:	000024c1 	andeq	r2, r0, r1, asr #9
    2838:	0c01c305 	stceq	3, cr12, [r1], {5}
    283c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2840:	0023870f 	eoreq	r8, r3, pc, lsl #14
    2844:	01c60500 	biceq	r0, r6, r0, lsl #10
    2848:	00001d0c 	andeq	r1, r0, ip, lsl #26
    284c:	23930f00 	orrscs	r0, r3, #0, 30
    2850:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    2854:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2858:	9f0f0000 	svcls	0x000f0000
    285c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2860:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    2864:	0f000000 	svceq	0x00000000
    2868:	000023c4 	andeq	r2, r0, r4, asr #7
    286c:	0c01d005 	stceq	0, cr13, [r1], {5}
    2870:	0000001d 	andeq	r0, r0, sp, lsl r0
    2874:	0024b40f 	eoreq	fp, r4, pc, lsl #8
    2878:	01d30500 	bicseq	r0, r3, r0, lsl #10
    287c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2880:	166b0f00 	strbtne	r0, [fp], -r0, lsl #30
    2884:	d6050000 	strle	r0, [r5], -r0
    2888:	001d0c01 	andseq	r0, sp, r1, lsl #24
    288c:	520f0000 	andpl	r0, pc, #0
    2890:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    2894:	1d0c01d9 	stfnes	f0, [ip, #-868]	; 0xfffffc9c
    2898:	0f000000 	svceq	0x00000000
    289c:	0000195d 	andeq	r1, r0, sp, asr r9
    28a0:	0c01dc05 	stceq	12, cr13, [r1], {5}
    28a4:	0000001d 	andeq	r0, r0, sp, lsl r0
    28a8:	0016460f 	andseq	r4, r6, pc, lsl #12
    28ac:	01df0500 	bicseq	r0, pc, r0, lsl #10
    28b0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28b4:	1f9a0f00 	svcne	0x009a0f00
    28b8:	e2050000 	and	r0, r5, #0
    28bc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28c0:	a20f0000 	andge	r0, pc, #0
    28c4:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    28c8:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    28cc:	0f000000 	svceq	0x00000000
    28d0:	00001dfa 	strdeq	r1, [r0], -sl
    28d4:	0c01e805 	stceq	8, cr14, [r1], {5}
    28d8:	0000001d 	andeq	r0, r0, sp, lsl r0
    28dc:	0022b40f 	eoreq	fp, r2, pc, lsl #8
    28e0:	01ef0500 	mvneq	r0, r0, lsl #10
    28e4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28e8:	246c0f00 	strbtcs	r0, [ip], #-3840	; 0xfffff100
    28ec:	f2050000 	vhadd.s8	d0, d5, d0
    28f0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28f4:	7c0f0000 	stcvc	0, cr0, [pc], {-0}
    28f8:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    28fc:	1d0c01f5 	stfnes	f0, [ip, #-980]	; 0xfffffc2c
    2900:	0f000000 	svceq	0x00000000
    2904:	00001762 	andeq	r1, r0, r2, ror #14
    2908:	0c01f805 	stceq	8, cr15, [r1], {5}
    290c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2910:	0022fb0f 	eoreq	pc, r2, pc, lsl #22
    2914:	01fb0500 	mvnseq	r0, r0, lsl #10
    2918:	00001d0c 	andeq	r1, r0, ip, lsl #26
    291c:	1f000f00 	svcne	0x00000f00
    2920:	fe050000 	cdp2	0, 0, cr0, cr5, cr0, {0}
    2924:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2928:	d60f0000 	strle	r0, [pc], -r0
    292c:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2930:	1d0c0202 	sfmne	f0, 4, [ip, #-8]
    2934:	0f000000 	svceq	0x00000000
    2938:	000020f0 	strdeq	r2, [r0], -r0
    293c:	0c020a05 			; <UNDEFINED> instruction: 0x0c020a05
    2940:	0000001d 	andeq	r0, r0, sp, lsl r0
    2944:	0018c90f 	andseq	ip, r8, pc, lsl #18
    2948:	020d0500 	andeq	r0, sp, #0, 10
    294c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2950:	001d0c00 	andseq	r0, sp, r0, lsl #24
    2954:	07ef0000 	strbeq	r0, [pc, r0]!
    2958:	000d0000 	andeq	r0, sp, r0
    295c:	001aa20f 	andseq	sl, sl, pc, lsl #4
    2960:	03fb0500 	mvnseq	r0, #0, 10
    2964:	0007e40c 	andeq	lr, r7, ip, lsl #8
    2968:	04e60c00 	strbteq	r0, [r6], #3072	; 0xc00
    296c:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
    2970:	24150000 	ldrcs	r0, [r5], #-0
    2974:	0d000000 	stceq	0, cr0, [r0, #-0]
    2978:	1fbd0f00 	svcne	0x00bd0f00
    297c:	84050000 	strhi	r0, [r5], #-0
    2980:	07fc1405 	ldrbeq	r1, [ip, r5, lsl #8]!
    2984:	64160000 	ldrvs	r0, [r6], #-0
    2988:	0700001b 	smladeq	r0, fp, r0, r0
    298c:	00009301 	andeq	r9, r0, r1, lsl #6
    2990:	058b0500 	streq	r0, [fp, #1280]	; 0x500
    2994:	00085706 	andeq	r5, r8, r6, lsl #14
    2998:	191f0b00 	ldmdbne	pc, {r8, r9, fp}	; <UNPREDICTABLE>
    299c:	0b000000 	bleq	29a4 <shift+0x29a4>
    29a0:	00001d6f 	andeq	r1, r0, pc, ror #26
    29a4:	14f70b01 	ldrbtne	r0, [r7], #2817	; 0xb01
    29a8:	0b020000 	bleq	829b0 <__bss_end+0x78cf0>
    29ac:	0000242e 	andeq	r2, r0, lr, lsr #8
    29b0:	20370b03 	eorscs	r0, r7, r3, lsl #22
    29b4:	0b040000 	bleq	1029bc <__bss_end+0xf8cfc>
    29b8:	0000202a 	andeq	r2, r0, sl, lsr #32
    29bc:	15ce0b05 	strbne	r0, [lr, #2821]	; 0xb05
    29c0:	00060000 	andeq	r0, r6, r0
    29c4:	00241e0f 	eoreq	r1, r4, pc, lsl #28
    29c8:	05980500 	ldreq	r0, [r8, #1280]	; 0x500
    29cc:	00081915 	andeq	r1, r8, r5, lsl r9
    29d0:	23200f00 	nopcs	{0}	; <UNPREDICTABLE>
    29d4:	99050000 	stmdbls	r5, {}	; <UNPREDICTABLE>
    29d8:	00241107 	eoreq	r1, r4, r7, lsl #2
    29dc:	aa0f0000 	bge	3c29e4 <__bss_end+0x3b8d24>
    29e0:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    29e4:	1d0c07ae 	stcne	7, cr0, [ip, #-696]	; 0xfffffd48
    29e8:	04000000 	streq	r0, [r0], #-0
    29ec:	00002293 	muleq	r0, r3, r2
    29f0:	93167b06 	tstls	r6, #6144	; 0x1800
    29f4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    29f8:	0000087e 	andeq	r0, r0, lr, ror r8
    29fc:	0a050203 	beq	143210 <__bss_end+0x139550>
    2a00:	0300000a 	movweq	r0, #10
    2a04:	18b20708 	ldmne	r2!, {r3, r8, r9, sl}
    2a08:	04030000 	streq	r0, [r3], #-0
    2a0c:	00168604 	andseq	r8, r6, r4, lsl #12
    2a10:	03080300 	movweq	r0, #33536	; 0x8300
    2a14:	0000167e 	andeq	r1, r0, lr, ror r6
    2a18:	93040803 	movwls	r0, #18435	; 0x4803
    2a1c:	0300001f 	movweq	r0, #31
    2a20:	20450310 	subcs	r0, r5, r0, lsl r3
    2a24:	8a0c0000 	bhi	302a2c <__bss_end+0x2f8d6c>
    2a28:	c9000008 	stmdbgt	r0, {r3}
    2a2c:	15000008 	strne	r0, [r0, #-8]
    2a30:	00000024 	andeq	r0, r0, r4, lsr #32
    2a34:	b90e00ff 	stmdblt	lr, {r0, r1, r2, r3, r4, r5, r6, r7}
    2a38:	0f000008 	svceq	0x00000008
    2a3c:	00001ea4 	andeq	r1, r0, r4, lsr #29
    2a40:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2a44:	000008c9 	andeq	r0, r0, r9, asr #17
    2a48:	0016350f 	andseq	r3, r6, pc, lsl #10
    2a4c:	02020600 	andeq	r0, r2, #0, 12
    2a50:	0008c916 	andeq	ip, r8, r6, lsl r9
    2a54:	22c60400 	sbccs	r0, r6, #0, 8
    2a58:	2a070000 	bcs	1c2a60 <__bss_end+0x1b8da0>
    2a5c:	0004f910 	andeq	pc, r4, r0, lsl r9	; <UNPREDICTABLE>
    2a60:	08e80c00 	stmiaeq	r8!, {sl, fp}^
    2a64:	08ff0000 	ldmeq	pc!, {}^	; <UNPREDICTABLE>
    2a68:	000d0000 	andeq	r0, sp, r0
    2a6c:	00035709 	andeq	r5, r3, r9, lsl #14
    2a70:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    2a74:	000008f4 	strdeq	r0, [r0], -r4
    2a78:	00020c09 	andeq	r0, r2, r9, lsl #24
    2a7c:	11300700 	teqne	r0, r0, lsl #14
    2a80:	000008f4 	strdeq	r0, [r0], -r4
    2a84:	0008ff17 	andeq	pc, r8, r7, lsl pc	; <UNPREDICTABLE>
    2a88:	09330800 	ldmdbeq	r3!, {fp}
    2a8c:	ad03050a 	cfstr32ge	mvfx0, [r3, #-40]	; 0xffffffd8
    2a90:	1700009c 			; <UNDEFINED> instruction: 0x1700009c
    2a94:	0000090b 	andeq	r0, r0, fp, lsl #18
    2a98:	0a093408 	beq	24fac0 <__bss_end+0x245e00>
    2a9c:	9cad0305 	stcls	3, cr0, [sp], #20
    2aa0:	Address 0x0000000000002aa0 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376f54>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb905c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb907c>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9094>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0xf4>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79bd4>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe390b8>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f6fe8>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6434>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9c98>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4c50>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6460>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b64d4>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377050>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9150>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79c8c>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39170>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9188>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79cc0>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4cfc>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377140>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7108>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb9228>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	0b002405 	bleq	9234 <_Z11split_floatfRjS_Ri+0x298>
 21c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 220:	06000008 	streq	r0, [r0], -r8
 224:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 228:	0b3b0b3a 	bleq	ec2f18 <__bss_end+0xeb9258>
 22c:	13490b39 	movtne	r0, #39737	; 0x9b39
 230:	13070000 	movwne	r0, #28672	; 0x7000
 234:	0b0e0301 	bleq	380e40 <__bss_end+0x377180>
 238:	3b0b3a0b 	blcc	2cea6c <__bss_end+0x2c4dac>
 23c:	010b390b 	tsteq	fp, fp, lsl #18
 240:	08000013 	stmdaeq	r0, {r0, r1, r4}
 244:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 248:	0b3b0b3a 	bleq	ec2f38 <__bss_end+0xeb9278>
 24c:	13490b39 	movtne	r0, #39737	; 0x9b39
 250:	00000b38 	andeq	r0, r0, r8, lsr fp
 254:	03010409 	movweq	r0, #5129	; 0x1409
 258:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 25c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 260:	3b0b3a13 	blcc	2ceab4 <__bss_end+0x2c4df4>
 264:	010b390b 	tsteq	fp, fp, lsl #18
 268:	0a000013 	beq	2bc <shift+0x2bc>
 26c:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 270:	00000b1c 	andeq	r0, r0, ip, lsl fp
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2b9dd4>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb92b4>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x3771d8>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe79df8>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe392dc>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x377210>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb9310>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7b354>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x3772a4>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb9344>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7b388>
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
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x377290>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f86b0>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c4ee8>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb93b0>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x3772dc>
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
 3e0:	0b3a0e03 	bleq	e83bf4 <__bss_end+0xe79f34>
 3e4:	0b390b3b 	bleq	e430d8 <__bss_end+0xe39418>
 3e8:	01111349 	tsteq	r1, r9, asr #6
 3ec:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3f0:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3f4:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
 3f8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3fc:	0b3b0b3a 	bleq	ec30ec <__bss_end+0xeb942c>
 400:	13490b39 	movtne	r0, #39737	; 0x9b39
 404:	00001802 	andeq	r1, r0, r2, lsl #16
 408:	03003426 	movweq	r3, #1062	; 0x426
 40c:	3b0b3a0e 	blcc	2cec4c <__bss_end+0x2c4f8c>
 410:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 414:	00180213 	andseq	r0, r8, r3, lsl r2
 418:	00342700 	eorseq	r2, r4, r0, lsl #14
 41c:	0b3a0803 	bleq	e82430 <__bss_end+0xe78770>
 420:	0b390b3b 	bleq	e43114 <__bss_end+0xe39454>
 424:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 428:	0b280000 	bleq	a00430 <__bss_end+0x9f6770>
 42c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 430:	29000006 	stmdbcs	r0, {r1, r2}
 434:	13490021 	movtne	r0, #36897	; 0x9021
 438:	0000052f 	andeq	r0, r0, pc, lsr #10
 43c:	03012e2a 	movweq	r2, #7722	; 0x1e2a
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c4fc0>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 44c:	96184006 	ldrls	r4, [r8], -r6
 450:	13011942 	movwne	r1, #6466	; 0x1942
 454:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
 458:	3a0e0301 	bcc	381064 <__bss_end+0x3773a4>
 45c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 460:	1201110b 	andne	r1, r1, #-1073741822	; 0xc0000002
 464:	96184006 	ldrls	r4, [r8], -r6
 468:	00001942 	andeq	r1, r0, r2, asr #18
 46c:	01110100 	tsteq	r1, r0, lsl #2
 470:	0b130e25 	bleq	4c3d0c <__bss_end+0x4ba04c>
 474:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 478:	06120111 			; <UNDEFINED> instruction: 0x06120111
 47c:	00001710 	andeq	r1, r0, r0, lsl r7
 480:	0b002402 	bleq	9490 <_Z23decimal_to_string_floatjPci+0xb4>
 484:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 488:	0300000e 	movweq	r0, #14
 48c:	13490026 	movtne	r0, #36902	; 0x9026
 490:	24040000 	strcs	r0, [r4], #-0
 494:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 498:	0008030b 	andeq	r0, r8, fp, lsl #6
 49c:	00160500 	andseq	r0, r6, r0, lsl #10
 4a0:	0b3a0e03 	bleq	e83cb4 <__bss_end+0xe79ff4>
 4a4:	0b390b3b 	bleq	e43198 <__bss_end+0xe394d8>
 4a8:	00001349 	andeq	r1, r0, r9, asr #6
 4ac:	03011306 	movweq	r1, #4870	; 0x1306
 4b0:	3a0b0b0e 	bcc	2c30f0 <__bss_end+0x2b9430>
 4b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b8:	0013010b 	andseq	r0, r3, fp, lsl #2
 4bc:	000d0700 	andeq	r0, sp, r0, lsl #14
 4c0:	0b3a0803 	bleq	e824d4 <__bss_end+0xe78814>
 4c4:	0b390b3b 	bleq	e431b8 <__bss_end+0xe394f8>
 4c8:	0b381349 	bleq	e051f4 <__bss_end+0xdfb534>
 4cc:	04080000 	streq	r0, [r8], #-0
 4d0:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4d4:	0b0b3e19 	bleq	2cfd40 <__bss_end+0x2c6080>
 4d8:	3a13490b 	bcc	4d290c <__bss_end+0x4c8c4c>
 4dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e0:	0013010b 	andseq	r0, r3, fp, lsl #2
 4e4:	00280900 	eoreq	r0, r8, r0, lsl #18
 4e8:	0b1c0803 	bleq	7024fc <__bss_end+0x6f883c>
 4ec:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 4f0:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 4f4:	0b00000b 	bleq	528 <shift+0x528>
 4f8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4fc:	0b3b0b3a 	bleq	ec31ec <__bss_end+0xeb952c>
 500:	13490b39 	movtne	r0, #39737	; 0x9b39
 504:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 508:	020c0000 	andeq	r0, ip, #0
 50c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 510:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 514:	0e030102 	adfeqs	f0, f3, f2
 518:	0b3a0b0b 	bleq	e8314c <__bss_end+0xe7948c>
 51c:	0b390b3b 	bleq	e43210 <__bss_end+0xe39550>
 520:	00001301 	andeq	r1, r0, r1, lsl #6
 524:	03000d0e 	movweq	r0, #3342	; 0xd0e
 528:	3b0b3a0e 	blcc	2ced68 <__bss_end+0x2c50a8>
 52c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 530:	000b3813 	andeq	r3, fp, r3, lsl r8
 534:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 538:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 53c:	0b3b0b3a 	bleq	ec322c <__bss_end+0xeb956c>
 540:	0e6e0b39 	vmoveq.8	d14[5], r0
 544:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 548:	00001364 	andeq	r1, r0, r4, ror #6
 54c:	49000510 	stmdbmi	r0, {r4, r8, sl}
 550:	00193413 	andseq	r3, r9, r3, lsl r4
 554:	00051100 	andeq	r1, r5, r0, lsl #2
 558:	00001349 	andeq	r1, r0, r9, asr #6
 55c:	03000d12 	movweq	r0, #3346	; 0xd12
 560:	3b0b3a0e 	blcc	2ceda0 <__bss_end+0x2c50e0>
 564:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 568:	3c193f13 	ldccc	15, cr3, [r9], {19}
 56c:	13000019 	movwne	r0, #25
 570:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 574:	0b3a0e03 	bleq	e83d88 <__bss_end+0xe7a0c8>
 578:	0b390b3b 	bleq	e4326c <__bss_end+0xe395ac>
 57c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 580:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 584:	13011364 	movwne	r1, #4964	; 0x1364
 588:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 58c:	03193f01 	tsteq	r9, #1, 30
 590:	3b0b3a0e 	blcc	2cedd0 <__bss_end+0x2c5110>
 594:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 598:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 59c:	01136419 	tsteq	r3, r9, lsl r4
 5a0:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 5a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5a8:	0b3a0e03 	bleq	e83dbc <__bss_end+0xe7a0fc>
 5ac:	0b390b3b 	bleq	e432a0 <__bss_end+0xe395e0>
 5b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5b4:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5b8:	00001364 	andeq	r1, r0, r4, ror #6
 5bc:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 5c0:	00130113 	andseq	r0, r3, r3, lsl r1
 5c4:	00211700 	eoreq	r1, r1, r0, lsl #14
 5c8:	0b2f1349 	bleq	bc52f4 <__bss_end+0xbbb634>
 5cc:	0f180000 	svceq	0x00180000
 5d0:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5d4:	19000013 	stmdbne	r0, {r0, r1, r4}
 5d8:	00000021 	andeq	r0, r0, r1, lsr #32
 5dc:	0300341a 	movweq	r3, #1050	; 0x41a
 5e0:	3b0b3a0e 	blcc	2cee20 <__bss_end+0x2c5160>
 5e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5e8:	3c193f13 	ldccc	15, cr3, [r9], {19}
 5ec:	1b000019 	blne	658 <shift+0x658>
 5f0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5f4:	0b3a0e03 	bleq	e83e08 <__bss_end+0xe7a148>
 5f8:	0b390b3b 	bleq	e432ec <__bss_end+0xe3962c>
 5fc:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 600:	13011364 	movwne	r1, #4964	; 0x1364
 604:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 608:	03193f01 	tsteq	r9, #1, 30
 60c:	3b0b3a0e 	blcc	2cee4c <__bss_end+0x2c518c>
 610:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 614:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 618:	01136419 	tsteq	r3, r9, lsl r4
 61c:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 620:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 624:	0b3b0b3a 	bleq	ec3314 <__bss_end+0xeb9654>
 628:	13490b39 	movtne	r0, #39737	; 0x9b39
 62c:	0b320b38 	bleq	c83314 <__bss_end+0xc79654>
 630:	151e0000 	ldrne	r0, [lr, #-0]
 634:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 638:	00130113 	andseq	r0, r3, r3, lsl r1
 63c:	001f1f00 	andseq	r1, pc, r0, lsl #30
 640:	1349131d 	movtne	r1, #37661	; 0x931d
 644:	10200000 	eorne	r0, r0, r0
 648:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 64c:	21000013 	tstcs	r0, r3, lsl r0
 650:	0b0b000f 	bleq	2c0694 <__bss_end+0x2b69d4>
 654:	34220000 	strtcc	r0, [r2], #-0
 658:	3a0e0300 	bcc	381260 <__bss_end+0x3775a0>
 65c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 660:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 664:	23000018 	movwcs	r0, #24
 668:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 66c:	0b3a0e03 	bleq	e83e80 <__bss_end+0xe7a1c0>
 670:	0b390b3b 	bleq	e43364 <__bss_end+0xe396a4>
 674:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 678:	06120111 			; <UNDEFINED> instruction: 0x06120111
 67c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 680:	00130119 	andseq	r0, r3, r9, lsl r1
 684:	00052400 	andeq	r2, r5, r0, lsl #8
 688:	0b3a0e03 	bleq	e83e9c <__bss_end+0xe7a1dc>
 68c:	0b390b3b 	bleq	e43380 <__bss_end+0xe396c0>
 690:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 694:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 698:	03193f01 	tsteq	r9, #1, 30
 69c:	3b0b3a0e 	blcc	2ceedc <__bss_end+0x2c521c>
 6a0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6a4:	1113490e 	tstne	r3, lr, lsl #18
 6a8:	40061201 	andmi	r1, r6, r1, lsl #4
 6ac:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6b0:	00001301 	andeq	r1, r0, r1, lsl #6
 6b4:	03003426 	movweq	r3, #1062	; 0x426
 6b8:	3b0b3a08 	blcc	2ceee0 <__bss_end+0x2c5220>
 6bc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6c0:	00180213 	andseq	r0, r8, r3, lsl r2
 6c4:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 6c8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb96fc>
 6d0:	0e6e0b39 	vmoveq.8	d14[5], r0
 6d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6dc:	00130119 	andseq	r0, r3, r9, lsl r1
 6e0:	002e2800 	eoreq	r2, lr, r0, lsl #16
 6e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6e8:	0b3b0b3a 	bleq	ec33d8 <__bss_end+0xeb9718>
 6ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 6f0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6f4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6f8:	29000019 	stmdbcs	r0, {r0, r3, r4}
 6fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 700:	0b3a0e03 	bleq	e83f14 <__bss_end+0xe7a254>
 704:	0b390b3b 	bleq	e433f8 <__bss_end+0xe39738>
 708:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 70c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 710:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 714:	00000019 	andeq	r0, r0, r9, lsl r0
 718:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 71c:	030b130e 	movweq	r1, #45838	; 0xb30e
 720:	110e1b0e 	tstne	lr, lr, lsl #22
 724:	10061201 	andne	r1, r6, r1, lsl #4
 728:	02000017 	andeq	r0, r0, #23
 72c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 730:	0b3b0b3a 	bleq	ec3420 <__bss_end+0xeb9760>
 734:	13490b39 	movtne	r0, #39737	; 0x9b39
 738:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 73c:	24030000 	strcs	r0, [r3], #-0
 740:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 744:	000e030b 	andeq	r0, lr, fp, lsl #6
 748:	00260400 	eoreq	r0, r6, r0, lsl #8
 74c:	00001349 	andeq	r1, r0, r9, asr #6
 750:	01013905 	tsteq	r1, r5, lsl #18
 754:	06000013 			; <UNDEFINED> instruction: 0x06000013
 758:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 75c:	0b3b0b3a 	bleq	ec344c <__bss_end+0xeb978c>
 760:	13490b39 	movtne	r0, #39737	; 0x9b39
 764:	0a1c193c 	beq	706c5c <__bss_end+0x6fcf9c>
 768:	3a070000 	bcc	1c0770 <__bss_end+0x1b6ab0>
 76c:	3b0b3a00 	blcc	2cef74 <__bss_end+0x2c52b4>
 770:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 774:	08000013 	stmdaeq	r0, {r0, r1, r4}
 778:	13490101 	movtne	r0, #37121	; 0x9101
 77c:	00001301 	andeq	r1, r0, r1, lsl #6
 780:	49002109 	stmdbmi	r0, {r0, r3, r8, sp}
 784:	000b2f13 	andeq	r2, fp, r3, lsl pc
 788:	00340a00 	eorseq	r0, r4, r0, lsl #20
 78c:	00001347 	andeq	r1, r0, r7, asr #6
 790:	3f012e0b 	svccc	0x00012e0b
 794:	3a0e0319 	bcc	381400 <__bss_end+0x377740>
 798:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 79c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 7a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 7a4:	97184006 	ldrls	r4, [r8, -r6]
 7a8:	13011942 	movwne	r1, #6466	; 0x1942
 7ac:	050c0000 	streq	r0, [ip, #-0]
 7b0:	3a080300 	bcc	2013b8 <__bss_end+0x1f76f8>
 7b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7b8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7bc:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 7c0:	08030034 	stmdaeq	r3, {r2, r4, r5}
 7c4:	0b3b0b3a 	bleq	ec34b4 <__bss_end+0xeb97f4>
 7c8:	13490b39 	movtne	r0, #39737	; 0x9b39
 7cc:	00001802 	andeq	r1, r0, r2, lsl #16
 7d0:	0300340e 	movweq	r3, #1038	; 0x40e
 7d4:	3b0b3a0e 	blcc	2cf014 <__bss_end+0x2c5354>
 7d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7dc:	00180213 	andseq	r0, r8, r3, lsl r2
 7e0:	010b0f00 	tsteq	fp, r0, lsl #30
 7e4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7e8:	34100000 	ldrcc	r0, [r0], #-0
 7ec:	3a0e0300 	bcc	3813f4 <__bss_end+0x377734>
 7f0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 7f4:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7f8:	11000018 	tstne	r0, r8, lsl r0
 7fc:	08030034 	stmdaeq	r3, {r2, r4, r5}
 800:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 804:	13490b39 	movtne	r0, #39737	; 0x9b39
 808:	00001802 	andeq	r1, r0, r2, lsl #16
 80c:	0b000f12 	bleq	445c <shift+0x445c>
 810:	0013490b 	andseq	r4, r3, fp, lsl #18
 814:	00241300 	eoreq	r1, r4, r0, lsl #6
 818:	0b3e0b0b 	bleq	f8344c <__bss_end+0xf7978c>
 81c:	00000803 	andeq	r0, r0, r3, lsl #16
 820:	3f012e14 	svccc	0x00012e14
 824:	3a0e0319 	bcc	381490 <__bss_end+0x3777d0>
 828:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 82c:	110e6e0b 	tstne	lr, fp, lsl #28
 830:	40061201 	andmi	r1, r6, r1, lsl #4
 834:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 838:	00001301 	andeq	r1, r0, r1, lsl #6
 83c:	03000515 	movweq	r0, #1301	; 0x515
 840:	3b0b3a0e 	blcc	2cf080 <__bss_end+0x2c53c0>
 844:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 848:	00180213 	andseq	r0, r8, r3, lsl r2
 84c:	010b1600 	tsteq	fp, r0, lsl #12
 850:	06120111 			; <UNDEFINED> instruction: 0x06120111
 854:	00001301 	andeq	r1, r0, r1, lsl #6
 858:	3f012e17 	svccc	0x00012e17
 85c:	3a0e0319 	bcc	3814c8 <__bss_end+0x377808>
 860:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 864:	110e6e0b 	tstne	lr, fp, lsl #28
 868:	40061201 	andmi	r1, r6, r1, lsl #4
 86c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 870:	00001301 	andeq	r1, r0, r1, lsl #6
 874:	0b001018 	bleq	48dc <shift+0x48dc>
 878:	0013490b 	andseq	r4, r3, fp, lsl #18
 87c:	012e1900 			; <UNDEFINED> instruction: 0x012e1900
 880:	0803193f 	stmdaeq	r3, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 884:	0b3b0b3a 	bleq	ec3574 <__bss_end+0xeb98b4>
 888:	0e6e0b39 	vmoveq.8	d14[5], r0
 88c:	01111349 	tsteq	r1, r9, asr #6
 890:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 894:	01194297 			; <UNDEFINED> instruction: 0x01194297
 898:	1a000013 	bne	8ec <shift+0x8ec>
 89c:	00000026 	andeq	r0, r0, r6, lsr #32
 8a0:	0b000f1b 	bleq	4514 <shift+0x4514>
 8a4:	1c00000b 	stcne	0, cr0, [r0], {11}
 8a8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8ac:	0b3a0e03 	bleq	e840c0 <__bss_end+0xe7a400>
 8b0:	0b390b3b 	bleq	e435a4 <__bss_end+0xe398e4>
 8b4:	01110e6e 	tsteq	r1, lr, ror #28
 8b8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 8bc:	00194296 	mulseq	r9, r6, r2
 8c0:	11010000 	mrsne	r0, (UNDEF: 1)
 8c4:	11061000 	mrsne	r1, (UNDEF: 6)
 8c8:	03011201 	movweq	r1, #4609	; 0x1201
 8cc:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 8d0:	0005130e 	andeq	r1, r5, lr, lsl #6
 8d4:	11010000 	mrsne	r0, (UNDEF: 1)
 8d8:	11061000 	mrsne	r1, (UNDEF: 6)
 8dc:	03011201 	movweq	r1, #4609	; 0x1201
 8e0:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 8e4:	0005130e 	andeq	r1, r5, lr, lsl #6
 8e8:	11010000 	mrsne	r0, (UNDEF: 1)
 8ec:	130e2501 	movwne	r2, #58625	; 0xe501
 8f0:	1b0e030b 	blne	381524 <__bss_end+0x377864>
 8f4:	0017100e 	andseq	r1, r7, lr
 8f8:	00240200 	eoreq	r0, r4, r0, lsl #4
 8fc:	0b3e0b0b 	bleq	f83530 <__bss_end+0xf79870>
 900:	00000803 	andeq	r0, r0, r3, lsl #16
 904:	0b002403 	bleq	9918 <_Z4atofPKc+0x98>
 908:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 90c:	0400000e 	streq	r0, [r0], #-14
 910:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 914:	0b3b0b3a 	bleq	ec3604 <__bss_end+0xeb9944>
 918:	13490b39 	movtne	r0, #39737	; 0x9b39
 91c:	0f050000 	svceq	0x00050000
 920:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 924:	06000013 			; <UNDEFINED> instruction: 0x06000013
 928:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 92c:	13011349 	movwne	r1, #4937	; 0x1349
 930:	05070000 	streq	r0, [r7, #-0]
 934:	00134900 	andseq	r4, r3, r0, lsl #18
 938:	00260800 	eoreq	r0, r6, r0, lsl #16
 93c:	34090000 	strcc	r0, [r9], #-0
 940:	3a0e0300 	bcc	381548 <__bss_end+0x377888>
 944:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 948:	3f13490b 	svccc	0x0013490b
 94c:	00193c19 	andseq	r3, r9, r9, lsl ip
 950:	01040a00 	tsteq	r4, r0, lsl #20
 954:	0b3e0e03 	bleq	f84168 <__bss_end+0xf7a4a8>
 958:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 95c:	0b3b0b3a 	bleq	ec364c <__bss_end+0xeb998c>
 960:	13010b39 	movwne	r0, #6969	; 0x1b39
 964:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 968:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 96c:	0c00000b 	stceq	0, cr0, [r0], {11}
 970:	13490101 	movtne	r0, #37121	; 0x9101
 974:	00001301 	andeq	r1, r0, r1, lsl #6
 978:	0000210d 	andeq	r2, r0, sp, lsl #2
 97c:	00260e00 	eoreq	r0, r6, r0, lsl #28
 980:	00001349 	andeq	r1, r0, r9, asr #6
 984:	0300340f 	movweq	r3, #1039	; 0x40f
 988:	3b0b3a0e 	blcc	2cf1c8 <__bss_end+0x2c5508>
 98c:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 990:	3c193f13 	ldccc	15, cr3, [r9], {19}
 994:	10000019 	andne	r0, r0, r9, lsl r0
 998:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 99c:	0000193c 	andeq	r1, r0, ip, lsr r9
 9a0:	27001511 	smladcs	r0, r1, r5, r1
 9a4:	12000019 	andne	r0, r0, #25
 9a8:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 9ac:	0000193c 	andeq	r1, r0, ip, lsr r9
 9b0:	03011313 	movweq	r1, #4883	; 0x1313
 9b4:	3a0b0b0e 	bcc	2c35f4 <__bss_end+0x2b9934>
 9b8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 9bc:	0013010b 	andseq	r0, r3, fp, lsl #2
 9c0:	000d1400 	andeq	r1, sp, r0, lsl #8
 9c4:	0b3a0e03 	bleq	e841d8 <__bss_end+0xe7a518>
 9c8:	0b39053b 	bleq	e41ebc <__bss_end+0xe381fc>
 9cc:	0b381349 	bleq	e056f8 <__bss_end+0xdfba38>
 9d0:	21150000 	tstcs	r5, r0
 9d4:	2f134900 	svccs	0x00134900
 9d8:	1600000b 	strne	r0, [r0], -fp
 9dc:	0e030104 	adfeqs	f0, f3, f4
 9e0:	0b0b0b3e 	bleq	2c36e0 <__bss_end+0x2b9a20>
 9e4:	0b3a1349 	bleq	e85710 <__bss_end+0xe7ba50>
 9e8:	0b39053b 	bleq	e41edc <__bss_end+0xe3821c>
 9ec:	00001301 	andeq	r1, r0, r1, lsl #6
 9f0:	47003417 	smladmi	r0, r7, r4, r3
 9f4:	3b0b3a13 	blcc	2cf248 <__bss_end+0x2c5588>
 9f8:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 9fc:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	0000032c 	andeq	r0, r0, ip, lsr #6
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0d2b0002 	stceq	0, cr0, [fp, #-8]!
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008558 	andeq	r8, r0, r8, asr r5
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1a240002 	bne	9000b4 <__bss_end+0x8f63f4>
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000089b4 			; <UNDEFINED> instruction: 0x000089b4
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	21210002 			; <UNDEFINED> instruction: 0x21210002
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009990 	muleq	r0, r0, r9
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21470002 	cmpcs	r7, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009b9c 	muleq	r0, ip, fp
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	216d0002 	cmncs	sp, r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff628c>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6031>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff6033>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4d48>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff6181>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be6b8>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfc64>
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
     3a4:	6b636954 	blvs	18da8fc <__bss_end+0x18d0c3c>
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
     45c:	6e690074 	mcrvs	0, 3, r0, cr9, cr4, {3}
     460:	74735f74 	ldrbtvc	r5, [r3], #-3956	; 0xfffff08c
     464:	75625f72 	strbvc	r5, [r2, #-3954]!	; 0xfffff08e
     468:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     46c:	61686300 	cmnvs	r8, r0, lsl #6
     470:	61765f72 	cmnvs	r6, r2, ror pc
     474:	6e695f6c 	cdpvs	15, 6, cr5, cr9, cr12, {3}
     478:	506d0074 	rsbpl	r0, sp, r4, ror r0
     47c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     480:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     484:	5f747369 	svcpl	0x00747369
     488:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     48c:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
     490:	61725f64 	cmnvs	r2, r4, ror #30
     494:	5f006574 	svcpl	0x00006574
     498:	314b4e5a 	cmpcc	fp, sl, asr lr
     49c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     4a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4a4:	614d5f73 	hvcvs	54771	; 0xd5f3
     4a8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4ac:	47393172 			; <UNDEFINED> instruction: 0x47393172
     4b0:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     4b4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     4b8:	505f746e 	subspl	r7, pc, lr, ror #8
     4bc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4c0:	76457373 			; <UNDEFINED> instruction: 0x76457373
     4c4:	5f524200 	svcpl	0x00524200
     4c8:	30303834 	eorscc	r3, r0, r4, lsr r8
     4cc:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     4d0:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     4d4:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4dc:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4e0:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     4e4:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff7ec <__bss_end+0xffff5b2c>
     4e8:	6f50746e 	svcvs	0x0050746e
     4ec:	00746e69 	rsbseq	r6, r4, r9, ror #28
     4f0:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     4f4:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     4f8:	0079726f 	rsbseq	r7, r9, pc, ror #4
     4fc:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     500:	6f72505f 	svcvs	0x0072505f
     504:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     508:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     50c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     510:	61655200 	cmnvs	r5, r0, lsl #4
     514:	63410064 	movtvs	r0, #4196	; 0x1064
     518:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     51c:	6f72505f 	svcvs	0x0072505f
     520:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     524:	756f435f 	strbvc	r4, [pc, #-863]!	; 1cd <shift+0x1cd>
     528:	4300746e 	movwmi	r7, #1134	; 0x46e
     52c:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     530:	72505f65 	subsvc	r5, r0, #404	; 0x194
     534:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     538:	61700073 	cmnvs	r0, r3, ror r0
     53c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     540:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     544:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     548:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     54c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     550:	47006874 	smlsdxmi	r0, r4, r8, r6
     554:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     558:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     55c:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     560:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     564:	6544006f 	strbvs	r0, [r4, #-111]	; 0xffffff91
     568:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     56c:	555f656e 	ldrbpl	r6, [pc, #-1390]	; 6 <shift+0x6>
     570:	6168636e 	cmnvs	r8, lr, ror #6
     574:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     578:	72504300 	subsvc	r4, r0, #0, 6
     57c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     580:	614d5f73 	hvcvs	54771	; 0xd5f3
     584:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     588:	5a5f0072 	bpl	17c0758 <__bss_end+0x17b6a98>
     58c:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     590:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     594:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     598:	34436d65 	strbcc	r6, [r3], #-3429	; 0xfffff29b
     59c:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     5a0:	445f5346 	ldrbmi	r5, [pc], #-838	; 5a8 <shift+0x5a8>
     5a4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     5a8:	5a5f0072 	bpl	17c0778 <__bss_end+0x17b6ab8>
     5ac:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     5b0:	636f7250 	cmnvs	pc, #80, 4
     5b4:	5f737365 	svcpl	0x00737365
     5b8:	616e614d 	cmnvs	lr, sp, asr #2
     5bc:	31726567 	cmncc	r2, r7, ror #10
     5c0:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     5c4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     5c8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     5cc:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     5d0:	456f666e 	strbmi	r6, [pc, #-1646]!	; ffffff6a <__bss_end+0xffff62aa>
     5d4:	474e3032 	smlaldxmi	r3, lr, r2, r0
     5d8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     5dc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     5e0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     5e4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     5e8:	76506570 			; <UNDEFINED> instruction: 0x76506570
     5ec:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5f0:	50433631 	subpl	r3, r3, r1, lsr r6
     5f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5f8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 434 <shift+0x434>
     5fc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     600:	31327265 	teqcc	r2, r5, ror #4
     604:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     608:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     60c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     610:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     614:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     618:	33324549 	teqcc	r2, #306184192	; 0x12400000
     61c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     620:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     624:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     628:	5f6d6574 	svcpl	0x006d6574
     62c:	76726553 			; <UNDEFINED> instruction: 0x76726553
     630:	6a656369 	bvs	19593dc <__bss_end+0x194f71c>
     634:	31526a6a 	cmpcc	r2, sl, ror #20
     638:	57535431 	smmlarpl	r3, r1, r4, r5
     63c:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     640:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     644:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     648:	5f64656e 	svcpl	0x0064656e
     64c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     650:	6f4e0073 	svcvs	0x004e0073
     654:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     658:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     65c:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     660:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     664:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     668:	61654400 	cmnvs	r5, r0, lsl #8
     66c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     670:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     674:	00307262 	eorseq	r7, r0, r2, ror #4
     678:	314e5a5f 	cmpcc	lr, pc, asr sl
     67c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     680:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     684:	614d5f73 	hvcvs	54771	; 0xd5f3
     688:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     68c:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     690:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     694:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     698:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     69c:	006a4573 	rsbeq	r4, sl, r3, ror r5
     6a0:	5f746547 	svcpl	0x00746547
     6a4:	00444950 	subeq	r4, r4, r0, asr r9
     6a8:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
     6ac:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
     6b0:	6e00646c 	cdpvs	4, 0, cr6, cr0, cr12, {3}
     6b4:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     6b8:	5f646569 	svcpl	0x00646569
     6bc:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     6c0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     6c4:	41554e00 	cmpmi	r5, r0, lsl #28
     6c8:	425f5452 	subsmi	r5, pc, #1375731712	; 0x52000000
     6cc:	5f647561 	svcpl	0x00647561
     6d0:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     6d4:	61684300 	cmnvs	r8, r0, lsl #6
     6d8:	00375f72 	eorseq	r5, r7, r2, ror pc
     6dc:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     6e0:	4d00385f 	stcmi	8, cr3, [r0, #-380]	; 0xfffffe84
     6e4:	505f7861 	subspl	r7, pc, r1, ror #16
     6e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6ec:	4f5f7373 	svcmi	0x005f7373
     6f0:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     6f4:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     6f8:	0073656c 	rsbseq	r6, r3, ip, ror #10
     6fc:	314e5a5f 	cmpcc	lr, pc, asr sl
     700:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     704:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     708:	614d5f73 	hvcvs	54771	; 0xd5f3
     70c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     710:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
     714:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     718:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     71c:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     720:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     724:	006a4574 	rsbeq	r4, sl, r4, ror r5
     728:	5f534667 	svcpl	0x00534667
     72c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     730:	5f737265 	svcpl	0x00737265
     734:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     738:	526d0074 	rsbpl	r0, sp, #116	; 0x74
     73c:	5f746f6f 	svcpl	0x00746f6f
     740:	00737953 	rsbseq	r7, r3, r3, asr r9
     744:	5f746547 	svcpl	0x00746547
     748:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     74c:	5f746e65 	svcpl	0x00746e65
     750:	636f7250 	cmnvs	pc, #80, 4
     754:	00737365 	rsbseq	r7, r3, r5, ror #6
     758:	5f70614d 	svcpl	0x0070614d
     75c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     760:	5f6f545f 	svcpl	0x006f545f
     764:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     768:	00746e65 	rsbseq	r6, r4, r5, ror #28
     76c:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     770:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     774:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     778:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     77c:	53007265 	movwpl	r7, #613	; 0x265
     780:	505f7465 	subspl	r7, pc, r5, ror #8
     784:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     788:	61480073 	hvcvs	32771	; 0x8003
     78c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     790:	6f72505f 	svcvs	0x0072505f
     794:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     798:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     79c:	6f687300 	svcvs	0x00687300
     7a0:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     7a4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     7a8:	2064656e 	rsbcs	r6, r4, lr, ror #10
     7ac:	00746e69 	rsbseq	r6, r4, r9, ror #28
     7b0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     7b4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     7b8:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     7bc:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     7c0:	69440074 	stmdbvs	r4, {r2, r4, r5, r6}^
     7c4:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     7c8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     7cc:	5f746e65 	svcpl	0x00746e65
     7d0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     7d4:	6f697463 	svcvs	0x00697463
     7d8:	5a5f006e 	bpl	17c0998 <__bss_end+0x17b6cd8>
     7dc:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     7e0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7e4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     7e8:	30316d65 	eorscc	r6, r1, r5, ror #26
     7ec:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     7f0:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     7f4:	7645657a 			; <UNDEFINED> instruction: 0x7645657a
     7f8:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     7fc:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     800:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     804:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     808:	7065656c 	rsbvc	r6, r5, ip, ror #10
     80c:	6f526d00 	svcvs	0x00526d00
     810:	445f746f 	ldrbmi	r7, [pc], #-1135	; 818 <shift+0x818>
     814:	62007665 	andvs	r7, r0, #105906176	; 0x6500000
     818:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     81c:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     820:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     824:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     828:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     82c:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     830:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     834:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     838:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     83c:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     840:	52006570 	andpl	r6, r0, #112, 10	; 0x1c000000
     844:	616e6e75 	smcvs	59109	; 0xe6e5
     848:	00656c62 	rsbeq	r6, r5, r2, ror #24
     84c:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     850:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     854:	00657461 	rsbeq	r7, r5, r1, ror #8
     858:	335f5242 	cmpcc	pc, #536870916	; 0x20000004
     85c:	30303438 	eorscc	r3, r0, r8, lsr r4
     860:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     864:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     868:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     86c:	73007265 	movwvc	r7, #613	; 0x265
     870:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     874:	6174735f 	cmnvs	r4, pc, asr r3
     878:	5f636974 	svcpl	0x00636974
     87c:	6f697270 	svcvs	0x00697270
     880:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     884:	696e4900 	stmdbvs	lr!, {r8, fp, lr}^
     888:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     88c:	00657a69 	rsbeq	r7, r5, r9, ror #20
     890:	5f534667 	svcpl	0x00534667
     894:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     898:	00737265 	rsbseq	r7, r3, r5, ror #4
     89c:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     8a0:	646f635f 	strbtvs	r6, [pc], #-863	; 8a8 <shift+0x8a8>
     8a4:	67660065 	strbvs	r0, [r6, -r5, rrx]!
     8a8:	00737465 	rsbseq	r7, r3, r5, ror #8
     8ac:	315f5242 	cmpcc	pc, r2, asr #4
     8b0:	30323531 	eorscc	r3, r2, r1, lsr r5
     8b4:	536d0030 	cmnpl	sp, #48	; 0x30
     8b8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8bc:	5f656c75 	svcpl	0x00656c75
     8c0:	00636e46 	rsbeq	r6, r3, r6, asr #28
     8c4:	6f725073 	svcvs	0x00725073
     8c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8cc:	0072674d 	rsbseq	r6, r2, sp, asr #14
     8d0:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     8d4:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     8d8:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     8dc:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     8e0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     8e4:	6f4e0068 	svcvs	0x004e0068
     8e8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     8ec:	636f4c00 	cmnvs	pc, #0, 24
     8f0:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     8f4:	6b636f6c 	blvs	18dc6ac <__bss_end+0x18d29ec>
     8f8:	49006465 	stmdbmi	r0, {r0, r2, r5, r6, sl, sp, lr}
     8fc:	4e49464e 	cdpmi	6, 4, cr4, cr9, cr14, {2}
     900:	00595449 	subseq	r5, r9, r9, asr #8
     904:	74757066 	ldrbtvc	r7, [r5], #-102	; 0xffffff9a
     908:	6f4c0073 	svcvs	0x004c0073
     90c:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     910:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     914:	55540064 	ldrbpl	r0, [r4, #-100]	; 0xffffff9c
     918:	5f545241 	svcpl	0x00545241
     91c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     920:	61505f6c 	cmpvs	r0, ip, ror #30
     924:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     928:	61655200 	cmnvs	r5, r0, lsl #4
     92c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     930:	00657469 	rsbeq	r7, r5, r9, ror #8
     934:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     938:	63006569 	movwvs	r6, #1385	; 0x569
     93c:	6f6c7369 	svcvs	0x006c7369
     940:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
     944:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     948:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     94c:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     950:	006f666e 	rsbeq	r6, pc, lr, ror #12
     954:	314e5a5f 	cmpcc	lr, pc, asr sl
     958:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     95c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     960:	614d5f73 	hvcvs	54771	; 0xd5f3
     964:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     968:	63533872 	cmpvs	r3, #7471104	; 0x720000
     96c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     970:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     974:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     978:	50433631 	subpl	r3, r3, r1, lsr r6
     97c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     980:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 7bc <shift+0x7bc>
     984:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     988:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     98c:	5f70614d 	svcpl	0x0070614d
     990:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     994:	5f6f545f 	svcpl	0x006f545f
     998:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     99c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     9a0:	46493550 			; <UNDEFINED> instruction: 0x46493550
     9a4:	00656c69 	rsbeq	r6, r5, r9, ror #24
     9a8:	5f746547 	svcpl	0x00746547
     9ac:	61726150 	cmnvs	r2, r0, asr r1
     9b0:	6300736d 	movwvs	r7, #877	; 0x36d
     9b4:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     9b8:	006e6572 	rsbeq	r6, lr, r2, ror r5
     9bc:	5078614d 	rsbspl	r6, r8, sp, asr #2
     9c0:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     9c4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     9c8:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     9cc:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     9d0:	63206465 			; <UNDEFINED> instruction: 0x63206465
     9d4:	00726168 	rsbseq	r6, r2, r8, ror #2
     9d8:	314e5a5f 	cmpcc	lr, pc, asr sl
     9dc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     9e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9e4:	614d5f73 	hvcvs	54771	; 0xd5f3
     9e8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     9ec:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     9f0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9f4:	5f656c75 	svcpl	0x00656c75
     9f8:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     9fc:	46430076 			; <UNDEFINED> instruction: 0x46430076
     a00:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a04:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a08:	6873006d 	ldmdavs	r3!, {r0, r2, r3, r5, r6}^
     a0c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     a10:	00746e69 	rsbseq	r6, r4, r9, ror #28
     a14:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     a18:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     a1c:	6e450065 	cdpvs	0, 4, cr0, cr5, cr5, {3}
     a20:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a24:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a28:	445f746e 	ldrbmi	r7, [pc], #-1134	; a30 <shift+0xa30>
     a2c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a30:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a34:	6f526d00 	svcvs	0x00526d00
     a38:	7300746f 	movwvc	r7, #1135	; 0x46f
     a3c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a40:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a44:	52006d65 	andpl	r6, r0, #6464	; 0x1940
     a48:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     a4c:	7500676e 	strvc	r6, [r0, #-1902]	; 0xfffff892
     a50:	33746e69 	cmncc	r4, #1680	; 0x690
     a54:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     a58:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 9a4 <shift+0x9a4>
     a5c:	616a2f65 	cmnvs	sl, r5, ror #30
     a60:	6173656d 	cmnvs	r3, sp, ror #10
     a64:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     a68:	6f2f7469 	svcvs	0x002f7469
     a6c:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     a70:	756f732f 	strbvc	r7, [pc, #-815]!	; 749 <shift+0x749>
     a74:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     a78:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     a7c:	61707372 	cmnvs	r0, r2, ror r3
     a80:	6c2f6563 	cfstr32vs	mvfx6, [pc], #-396	; 8fc <shift+0x8fc>
     a84:	6567676f 	strbvs	r6, [r7, #-1903]!	; 0xfffff891
     a88:	61745f72 	cmnvs	r4, r2, ror pc
     a8c:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     a90:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     a94:	00707063 	rsbseq	r7, r0, r3, rrx
     a98:	6c736963 			; <UNDEFINED> instruction: 0x6c736963
     a9c:	436d006f 	cmnmi	sp, #111	; 0x6f
     aa0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     aa4:	545f746e 	ldrbpl	r7, [pc], #-1134	; aac <shift+0xaac>
     aa8:	5f6b7361 	svcpl	0x006b7361
     aac:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     ab0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ab4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ab8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     abc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ac0:	704f346d 	subvc	r3, pc, sp, ror #8
     ac4:	50456e65 	subpl	r6, r5, r5, ror #28
     ac8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     acc:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ad0:	704f5f65 	subvc	r5, pc, r5, ror #30
     ad4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 948 <shift+0x948>
     ad8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     adc:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     ae0:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
     ae4:	00687467 	rsbeq	r7, r8, r7, ror #8
     ae8:	61726170 	cmnvs	r2, r0, ror r1
     aec:	6400736d 	strvs	r7, [r0], #-877	; 0xfffffc93
     af0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     af4:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     af8:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     afc:	4f5f6461 	svcmi	0x005f6461
     b00:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     b04:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     b08:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b0c:	0072656d 	rsbseq	r6, r2, sp, ror #10
     b10:	4b4e5a5f 	blmi	1397494 <__bss_end+0x138d7d4>
     b14:	50433631 	subpl	r3, r3, r1, lsr r6
     b18:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b1c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 958 <shift+0x958>
     b20:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b24:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b28:	5f746547 	svcpl	0x00746547
     b2c:	636f7250 	cmnvs	pc, #80, 4
     b30:	5f737365 	svcpl	0x00737365
     b34:	505f7942 	subspl	r7, pc, r2, asr #18
     b38:	6a454449 	bvs	1151c64 <__bss_end+0x1147fa4>
     b3c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     b40:	5f656c64 	svcpl	0x00656c64
     b44:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b48:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     b4c:	535f6d65 	cmppl	pc, #6464	; 0x1940
     b50:	5f004957 	svcpl	0x00004957
     b54:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b58:	6f725043 	svcvs	0x00725043
     b5c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b60:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b64:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b68:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     b6c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b70:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     b74:	00764552 	rsbseq	r4, r6, r2, asr r5
     b78:	6b736174 	blvs	1cd9150 <__bss_end+0x1ccf490>
     b7c:	5f524200 	svcpl	0x00524200
     b80:	30323931 	eorscc	r3, r2, r1, lsr r9
     b84:	6f4e0030 	svcvs	0x004e0030
     b88:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     b8c:	6f72505f 	svcvs	0x0072505f
     b90:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b94:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     b98:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b9c:	5a5f0065 	bpl	17c0d38 <__bss_end+0x17b7078>
     ba0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     ba4:	636f7250 	cmnvs	pc, #80, 4
     ba8:	5f737365 	svcpl	0x00737365
     bac:	616e614d 	cmnvs	lr, sp, asr #2
     bb0:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     bb4:	6f6c4231 	svcvs	0x006c4231
     bb8:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     bbc:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     bc0:	505f746e 	subspl	r7, pc, lr, ror #8
     bc4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bc8:	76457373 			; <UNDEFINED> instruction: 0x76457373
     bcc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     bd0:	50433631 	subpl	r3, r3, r1, lsr r6
     bd4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bd8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a14 <shift+0xa14>
     bdc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     be0:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     be4:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     be8:	6f545f68 	svcvs	0x00545f68
     bec:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     bf0:	6f725043 	svcvs	0x00725043
     bf4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bf8:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     bfc:	6f4e5f74 	svcvs	0x004e5f74
     c00:	53006564 	movwpl	r6, #1380	; 0x564
     c04:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c08:	5f656c75 	svcpl	0x00656c75
     c0c:	5f005252 	svcpl	0x00005252
     c10:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c14:	6f725043 	svcvs	0x00725043
     c18:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c1c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c20:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c24:	61483831 	cmpvs	r8, r1, lsr r8
     c28:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c2c:	6f72505f 	svcvs	0x0072505f
     c30:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c34:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     c38:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     c3c:	5f495753 	svcpl	0x00495753
     c40:	636f7250 	cmnvs	pc, #80, 4
     c44:	5f737365 	svcpl	0x00737365
     c48:	76726553 			; <UNDEFINED> instruction: 0x76726553
     c4c:	6a656369 	bvs	19599f8 <__bss_end+0x194fd38>
     c50:	31526a6a 	cmpcc	r2, sl, ror #20
     c54:	57535431 	smmlarpl	r3, r1, r4, r5
     c58:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     c5c:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     c60:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     c64:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
     c68:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     c6c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     c70:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     c74:	5f006e6f 	svcpl	0x00006e6f
     c78:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c7c:	6f725043 	svcvs	0x00725043
     c80:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c84:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c88:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c8c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     c90:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     c94:	6f72505f 	svcvs	0x0072505f
     c98:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c9c:	6a685045 	bvs	1a14db8 <__bss_end+0x1a0b0f8>
     ca0:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     ca4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     ca8:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     cac:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     cb0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     cb4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     cb8:	5f6d6574 	svcpl	0x006d6574
     cbc:	76726553 			; <UNDEFINED> instruction: 0x76726553
     cc0:	00656369 	rsbeq	r6, r5, r9, ror #6
     cc4:	315f5242 	cmpcc	pc, r2, asr #4
     cc8:	00303032 	eorseq	r3, r0, r2, lsr r0
     ccc:	61766e49 	cmnvs	r6, r9, asr #28
     cd0:	5f64696c 	svcpl	0x0064696c
     cd4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     cd8:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     cdc:	545f5346 	ldrbpl	r5, [pc], #-838	; ce4 <shift+0xce4>
     ce0:	5f656572 	svcpl	0x00656572
     ce4:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     ce8:	6f6c4200 	svcvs	0x006c4200
     cec:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     cf0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     cf4:	505f746e 	subspl	r7, pc, lr, ror #8
     cf8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cfc:	42007373 	andmi	r7, r0, #-872415231	; 0xcc000001
     d00:	36395f52 	shsaxcc	r5, r9, r2
     d04:	43003030 	movwmi	r3, #48	; 0x30
     d08:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     d0c:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     d10:	00726576 	rsbseq	r6, r2, r6, ror r5
     d14:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     d18:	69464900 	stmdbvs	r6, {r8, fp, lr}^
     d1c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d20:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d24:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     d28:	00726576 	rsbseq	r6, r2, r6, ror r5
     d2c:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     d30:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     d34:	6d00796c 	vstrvs.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
     d38:	006e6961 	rsbeq	r6, lr, r1, ror #18
     d3c:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     d40:	5a5f0064 	bpl	17c0ed8 <__bss_end+0x17b7218>
     d44:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d48:	636f7250 	cmnvs	pc, #80, 4
     d4c:	5f737365 	svcpl	0x00737365
     d50:	616e614d 	cmnvs	lr, sp, asr #2
     d54:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     d58:	00764534 	rsbseq	r4, r6, r4, lsr r5
     d5c:	6f6f526d 	svcvs	0x006f526d
     d60:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     d64:	70630074 	rsbvc	r0, r3, r4, ror r0
     d68:	6f635f75 	svcvs	0x00635f75
     d6c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     d70:	65540074 	ldrbvs	r0, [r4, #-116]	; 0xffffff8c
     d74:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     d78:	00657461 	rsbeq	r7, r5, r1, ror #8
     d7c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     d80:	6c63006c 	stclvs	0, cr0, [r3], #-432	; 0xfffffe50
     d84:	0065736f 	rsbeq	r7, r5, pc, ror #6
     d88:	5f746553 	svcpl	0x00746553
     d8c:	616c6552 	cmnvs	ip, r2, asr r5
     d90:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     d94:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     d98:	006c6176 	rsbeq	r6, ip, r6, ror r1
     d9c:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     da0:	70697000 	rsbvc	r7, r9, r0
     da4:	64720065 	ldrbtvs	r0, [r2], #-101	; 0xffffff9b
     da8:	006d756e 	rsbeq	r7, sp, lr, ror #10
     dac:	31315a5f 	teqcc	r1, pc, asr sl
     db0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     db4:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     db8:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     dbc:	315a5f00 	cmpcc	sl, r0, lsl #30
     dc0:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     dc4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     dc8:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     dcc:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     dd0:	006a656e 	rsbeq	r6, sl, lr, ror #10
     dd4:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     dd8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     ddc:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     de0:	6a6a7966 	bvs	1a9f380 <__bss_end+0x1a956c0>
     de4:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
     de8:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
     dec:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     df0:	46006965 	strmi	r6, [r0], -r5, ror #18
     df4:	006c6961 	rsbeq	r6, ip, r1, ror #18
     df8:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     dfc:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     e00:	325a5f00 	subscc	r5, sl, #0, 30
     e04:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     e08:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     e0c:	5f657669 	svcpl	0x00657669
     e10:	636f7270 	cmnvs	pc, #112, 4
     e14:	5f737365 	svcpl	0x00737365
     e18:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e1c:	73007674 	movwvc	r7, #1652	; 0x674
     e20:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     e24:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     e28:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     e2c:	5f6b6369 	svcpl	0x006b6369
     e30:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e34:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     e38:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     e3c:	50006465 	andpl	r6, r0, r5, ror #8
     e40:	5f657069 	svcpl	0x00657069
     e44:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e48:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     e4c:	00786966 	rsbseq	r6, r8, r6, ror #18
     e50:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
     e54:	5f746567 	svcpl	0x00746567
     e58:	6b636974 	blvs	18db430 <__bss_end+0x18d1770>
     e5c:	756f635f 	strbvc	r6, [pc, #-863]!	; b05 <shift+0xb05>
     e60:	0076746e 	rsbseq	r7, r6, lr, ror #8
     e64:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     e68:	65730070 	ldrbvs	r0, [r3, #-112]!	; 0xffffff90
     e6c:	61745f74 	cmnvs	r4, r4, ror pc
     e70:	645f6b73 	ldrbvs	r6, [pc], #-2931	; e78 <shift+0xe78>
     e74:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     e78:	00656e69 	rsbeq	r6, r5, r9, ror #28
     e7c:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     e80:	6f697461 	svcvs	0x00697461
     e84:	5a5f006e 	bpl	17c1044 <__bss_end+0x17b7384>
     e88:	6f6c6335 	svcvs	0x006c6335
     e8c:	006a6573 	rsbeq	r6, sl, r3, ror r5
     e90:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ddc <shift+0xddc>
     e94:	616a2f65 	cmnvs	sl, r5, ror #30
     e98:	6173656d 	cmnvs	r3, sp, ror #10
     e9c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
     ea0:	6f2f7469 	svcvs	0x002f7469
     ea4:	70732f73 	rsbsvc	r2, r3, r3, ror pc
     ea8:	756f732f 	strbvc	r7, [pc, #-815]!	; b81 <shift+0xb81>
     eac:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     eb0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     eb4:	2f62696c 	svccs	0x0062696c
     eb8:	2f637273 	svccs	0x00637273
     ebc:	66647473 			; <UNDEFINED> instruction: 0x66647473
     ec0:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     ec4:	00707063 	rsbseq	r7, r0, r3, rrx
     ec8:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     ecc:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     ed0:	66007664 	strvs	r7, [r0], -r4, ror #12
     ed4:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     ed8:	746f6e00 	strbtvc	r6, [pc], #-3584	; ee0 <shift+0xee0>
     edc:	00796669 	rsbseq	r6, r9, r9, ror #12
     ee0:	6b636974 	blvs	18db4b8 <__bss_end+0x18d17f8>
     ee4:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     ee8:	5f006e65 	svcpl	0x00006e65
     eec:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     ef0:	4b506570 	blmi	141a4b8 <__bss_end+0x14107f8>
     ef4:	4e006a63 	vmlsmi.f32	s12, s0, s7
     ef8:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     efc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f00:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     f04:	76726573 			; <UNDEFINED> instruction: 0x76726573
     f08:	00656369 	rsbeq	r6, r5, r9, ror #6
     f0c:	5f746567 	svcpl	0x00746567
     f10:	6b636974 	blvs	18db4e8 <__bss_end+0x18d1828>
     f14:	756f635f 	strbvc	r6, [pc, #-863]!	; bbd <shift+0xbbd>
     f18:	2f00746e 	svccs	0x0000746e
     f1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     f20:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     f24:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     f28:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     f2c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     f30:	2f70732f 	svccs	0x0070732f
     f34:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     f38:	2f736563 	svccs	0x00736563
     f3c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     f40:	61700064 	cmnvs	r0, r4, rrx
     f44:	006d6172 	rsbeq	r6, sp, r2, ror r1
     f48:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
     f4c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     f50:	634b506a 	movtvs	r5, #45162	; 0xb06a
     f54:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
     f58:	61745f74 	cmnvs	r4, r4, ror pc
     f5c:	745f6b73 	ldrbvc	r6, [pc], #-2931	; f64 <shift+0xf64>
     f60:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     f64:	5f6f745f 	svcpl	0x006f745f
     f68:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     f6c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f70:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     f74:	62006574 	andvs	r6, r0, #116, 10	; 0x1d000000
     f78:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
     f7c:	00657a69 	rsbeq	r7, r5, r9, ror #20
     f80:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     f84:	7065656c 	rsbvc	r6, r5, ip, ror #10
     f88:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
     f8c:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     f90:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
     f94:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     f98:	325a5f00 	subscc	r5, sl, #0, 30
     f9c:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     fa0:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     fa4:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     fa8:	5f736b63 	svcpl	0x00736b63
     fac:	645f6f74 	ldrbvs	r6, [pc], #-3956	; fb4 <shift+0xfb4>
     fb0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     fb4:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     fb8:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     fbc:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     fc0:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     fc4:	646f435f 	strbtvs	r4, [pc], #-863	; fcc <shift+0xfcc>
     fc8:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     fcc:	006d756e 	rsbeq	r7, sp, lr, ror #10
     fd0:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     fd4:	6a746961 	bvs	1d1b560 <__bss_end+0x1d118a0>
     fd8:	5f006a6a 	svcpl	0x00006a6a
     fdc:	6f69355a 	svcvs	0x0069355a
     fe0:	6a6c7463 	bvs	1b1e174 <__bss_end+0x1b144b4>
     fe4:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     fe8:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     fec:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     ff0:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     ff4:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     ff8:	636f6900 	cmnvs	pc, #0, 18
     ffc:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1000:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    1004:	6f6d0074 	svcvs	0x006d0074
    1008:	5f006564 	svcpl	0x00006564
    100c:	6572345a 	ldrbvs	r3, [r2, #-1114]!	; 0xfffffba6
    1010:	506a6461 	rsbpl	r6, sl, r1, ror #8
    1014:	72006a63 	andvc	r6, r0, #405504	; 0x63000
    1018:	6f637465 	svcvs	0x00637465
    101c:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1020:	615f7465 	cmpvs	pc, r5, ror #8
    1024:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1028:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    102c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1030:	6f635f73 	svcvs	0x00635f73
    1034:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1038:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    103c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1040:	61657200 	cmnvs	r5, r0, lsl #4
    1044:	65740064 	ldrbvs	r0, [r4, #-100]!	; 0xffffff9c
    1048:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    104c:	00657461 	rsbeq	r7, r5, r1, ror #8
    1050:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1054:	5f006469 	svcpl	0x00006469
    1058:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    105c:	4b506e65 	blmi	141c9f8 <__bss_end+0x1412d38>
    1060:	4e353163 	rsfmisz	f3, f5, f3
    1064:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1068:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    106c:	6f4d5f6e 	svcvs	0x004d5f6e
    1070:	47006564 	strmi	r6, [r0, -r4, ror #10]
    1074:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1078:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    107c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1080:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1084:	31393130 	teqcc	r9, r0, lsr r1
    1088:	20353230 	eorscs	r3, r5, r0, lsr r2
    108c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1090:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1094:	415b2029 	cmpmi	fp, r9, lsr #32
    1098:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    109c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    10a0:	6172622d 	cmnvs	r2, sp, lsr #4
    10a4:	2068636e 	rsbcs	r6, r8, lr, ror #6
    10a8:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    10ac:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    10b0:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    10b4:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    10b8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    10bc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    10c0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    10c4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    10c8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    10cc:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    10d0:	20706676 	rsbscs	r6, r0, r6, ror r6
    10d4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    10d8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    10dc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    10e0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    10e4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    10e8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    10ec:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    10f0:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    10f4:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    10f8:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    10fc:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1100:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    1104:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1108:	616d2d20 	cmnvs	sp, r0, lsr #26
    110c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1110:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1114:	2b6b7a36 	blcs	1adf9f4 <__bss_end+0x1ad5d34>
    1118:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    111c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1120:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1124:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    1128:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    112c:	6f6e662d 	svcvs	0x006e662d
    1130:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    1134:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    1138:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    113c:	6f6e662d 	svcvs	0x006e662d
    1140:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    1144:	5a5f0069 	bpl	17c12f0 <__bss_end+0x17b7630>
    1148:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    114c:	50797063 	rsbspl	r7, r9, r3, rrx
    1150:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    1154:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    1158:	2f656d6f 	svccs	0x00656d6f
    115c:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    1160:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    1164:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    1168:	2f736f2f 	svccs	0x00736f2f
    116c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1170:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1174:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1178:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    117c:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1180:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1184:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1188:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    118c:	00707063 	rsbseq	r7, r0, r3, rrx
    1190:	616d6572 	smcvs	54866	; 0xd652
    1194:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    1198:	73690072 	cmnvc	r9, #114	; 0x72
    119c:	006e616e 	rsbeq	r6, lr, lr, ror #2
    11a0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    11a4:	6c617267 	sfmvs	f7, 2, [r1], #-412	; 0xfffffe64
    11a8:	69736900 	ldmdbvs	r3!, {r8, fp, sp, lr}^
    11ac:	6400666e 	strvs	r6, [r0], #-1646	; 0xfffff992
    11b0:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    11b4:	5f006c61 	svcpl	0x00006c61
    11b8:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    11bc:	506a616f 	rsbpl	r6, sl, pc, ror #2
    11c0:	61006a63 	tstvs	r0, r3, ror #20
    11c4:	00696f74 	rsbeq	r6, r9, r4, ror pc
    11c8:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    11cc:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    11d0:	73006e65 	movwvc	r6, #3685	; 0xe65
    11d4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    11d8:	65645f67 	strbvs	r5, [r4, #-3943]!	; 0xfffff099
    11dc:	616d6963 	cmnvs	sp, r3, ror #18
    11e0:	7000736c 	andvc	r7, r0, ip, ror #6
    11e4:	7265776f 	rsbvc	r7, r5, #29097984	; 0x1bc0000
    11e8:	72747300 	rsbsvc	r7, r4, #0, 6
    11ec:	5f676e69 	svcpl	0x00676e69
    11f0:	5f746e69 	svcpl	0x00746e69
    11f4:	006e656c 	rsbeq	r6, lr, ip, ror #10
    11f8:	6f707865 	svcvs	0x00707865
    11fc:	746e656e 	strbtvc	r6, [lr], #-1390	; 0xfffffa92
    1200:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1204:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1208:	00634b50 	rsbeq	r4, r3, r0, asr fp
    120c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1210:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1214:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    1218:	63507274 	cmpvs	r0, #116, 4	; 0x40000007
    121c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1220:	616e7369 	cmnvs	lr, r9, ror #6
    1224:	6900666e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, sp, lr}
    1228:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    122c:	73616200 	cmnvc	r1, #0, 4
    1230:	65740065 	ldrbvs	r0, [r4, #-101]!	; 0xffffff9b
    1234:	5f00706d 	svcpl	0x0000706d
    1238:	7a62355a 	bvc	188e7a8 <__bss_end+0x1884ae8>
    123c:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1240:	73006976 	movwvc	r6, #2422	; 0x976
    1244:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1248:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    124c:	00616f74 	rsbeq	r6, r1, r4, ror pc
    1250:	31727473 	cmncc	r2, r3, ror r4
    1254:	72747300 	rsbsvc	r7, r4, #0, 6
    1258:	5f676e69 	svcpl	0x00676e69
    125c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1260:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1264:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    1268:	5a5f0066 	bpl	17c1408 <__bss_end+0x17b7748>
    126c:	776f7033 			; <UNDEFINED> instruction: 0x776f7033
    1270:	5f006a66 	svcpl	0x00006a66
    1274:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    1278:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    127c:	6f6c665f 	svcvs	0x006c665f
    1280:	52667461 	rsbpl	r7, r6, #1627389952	; 0x61000000
    1284:	525f536a 	subspl	r5, pc, #-1476395007	; 0xa8000001
    1288:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    128c:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1290:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1294:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1298:	6f437261 	svcvs	0x00437261
    129c:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    12a0:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    12a4:	5f00616f 	svcpl	0x0000616f
    12a8:	6433325a 	ldrtvs	r3, [r3], #-602	; 0xfffffda6
    12ac:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    12b0:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 12b8 <shift+0x12b8>
    12b4:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    12b8:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    12bc:	6f6c665f 	svcvs	0x006c665f
    12c0:	506a7461 	rsbpl	r7, sl, r1, ror #8
    12c4:	6d006963 	vstrvs.16	s12, [r0, #-198]	; 0xffffff3a	; <UNPREDICTABLE>
    12c8:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    12cc:	72700063 	rsbsvc	r0, r0, #99	; 0x63
    12d0:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    12d4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    12d8:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    12dc:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    12e0:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    12e4:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
    12e8:	73007865 	movwvc	r7, #2149	; 0x865
    12ec:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    12f0:	6400706d 	strvs	r7, [r0], #-109	; 0xffffff93
    12f4:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    12f8:	5a5f0073 	bpl	17c14cc <__bss_end+0x17b780c>
    12fc:	6f746134 	svcvs	0x00746134
    1300:	634b5069 	movtvs	r5, #45161	; 0xb069
    1304:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1308:	00747570 	rsbseq	r7, r4, r0, ror r5
    130c:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1310:	66616f74 	uqsub16vs	r6, r1, r4
    1314:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1318:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    131c:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    1320:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1324:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    1328:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    132c:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1330:	4b506e65 	blmi	141cccc <__bss_end+0x141300c>
    1334:	5a5f0063 	bpl	17c14c8 <__bss_end+0x17b7808>
    1338:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    133c:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1340:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    1344:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1348:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    134c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1350:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    1354:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1358:	63656400 	cmnvs	r5, #0, 8
    135c:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    1360:	5f6f745f 	svcpl	0x006f745f
    1364:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1368:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    136c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1370:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1374:	616f7466 	cmnvs	pc, r6, ror #8
    1378:	00635066 	rsbeq	r5, r3, r6, rrx
    137c:	6f6d656d 	svcvs	0x006d656d
    1380:	73007972 	movwvc	r7, #2418	; 0x972
    1384:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1388:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    138c:	72747376 	rsbsvc	r7, r4, #-671088639	; 0xd8000001
    1390:	2f2e2e00 	svccs	0x002e2e00
    1394:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1398:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    139c:	2f2e2e2f 	svccs	0x002e2e2f
    13a0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 12f0 <shift+0x12f0>
    13a4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    13a8:	6f632f63 	svcvs	0x00632f63
    13ac:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    13b0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    13b4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    13b8:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    13bc:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    13c0:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    13c4:	2f646c69 	svccs	0x00646c69
    13c8:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    13cc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    13d0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    13d4:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    13d8:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    13dc:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    13e0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    13e4:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    13e8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    13ec:	61652d65 	cmnvs	r5, r5, ror #26
    13f0:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    13f4:	3130322d 	teqcc	r0, sp, lsr #4
    13f8:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    13fc:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1400:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1404:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1408:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    140c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1410:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1414:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1418:	61682f65 	cmnvs	r8, r5, ror #30
    141c:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 125c <shift+0x125c>
    1420:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1424:	41540063 	cmpmi	r4, r3, rrx
    1428:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    142c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1430:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1434:	61786574 	cmnvs	r8, r4, ror r5
    1438:	6f633731 	svcvs	0x00633731
    143c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1440:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    1444:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1448:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    144c:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1450:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1454:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1458:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    145c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1460:	41540074 	cmpmi	r4, r4, ror r0
    1464:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1468:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    146c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1470:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1474:	41003332 	tstmi	r0, r2, lsr r3
    1478:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; 72e <shift+0x72e>
    147c:	41540051 	cmpmi	r4, r1, asr r0
    1480:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1484:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1488:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    148c:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1490:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    1494:	61736900 	cmnvs	r3, r0, lsl #18
    1498:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    149c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    14a0:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    14a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    14a8:	50435f54 	subpl	r5, r3, r4, asr pc
    14ac:	6f635f55 	svcvs	0x00635f55
    14b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    14b4:	63373561 	teqvs	r7, #406847488	; 0x18400000
    14b8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    14bc:	33356178 	teqcc	r5, #120, 2
    14c0:	53414200 	movtpl	r4, #4608	; 0x1200
    14c4:	52415f45 	subpl	r5, r1, #276	; 0x114
    14c8:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    14cc:	41425f4d 	cmpmi	r2, sp, asr #30
    14d0:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    14d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    14d8:	50435f54 	subpl	r5, r3, r4, asr pc
    14dc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    14e0:	3031386d 	eorscc	r3, r1, sp, ror #16
    14e4:	52415400 	subpl	r5, r1, #0, 8
    14e8:	5f544547 	svcpl	0x00544547
    14ec:	5f555043 	svcpl	0x00555043
    14f0:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    14f4:	41003165 	tstmi	r0, r5, ror #2
    14f8:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    14fc:	415f5343 	cmpmi	pc, r3, asr #6
    1500:	53435041 	movtpl	r5, #12353	; 0x3041
    1504:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    1508:	0054584d 	subseq	r5, r4, sp, asr #16
    150c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1510:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1514:	00305f48 	eorseq	r5, r0, r8, asr #30
    1518:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    151c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1520:	00325f48 	eorseq	r5, r2, r8, asr #30
    1524:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1528:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    152c:	00335f48 	eorseq	r5, r3, r8, asr #30
    1530:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1534:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1538:	00345f48 	eorseq	r5, r4, r8, asr #30
    153c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1540:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1544:	00365f48 	eorseq	r5, r6, r8, asr #30
    1548:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    154c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1550:	00375f48 	eorseq	r5, r7, r8, asr #30
    1554:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1558:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    155c:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1560:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1564:	73690065 	cmnvc	r9, #101	; 0x65
    1568:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    156c:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1570:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1574:	41540073 	cmpmi	r4, r3, ror r0
    1578:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    157c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1580:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1584:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1588:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    158c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1590:	50435f54 	subpl	r5, r3, r4, asr pc
    1594:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1598:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    159c:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    15a0:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    15a4:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    15a8:	52415400 	subpl	r5, r1, #0, 8
    15ac:	5f544547 	svcpl	0x00544547
    15b0:	5f555043 	svcpl	0x00555043
    15b4:	316d7261 	cmncc	sp, r1, ror #4
    15b8:	6a363731 	bvs	d8f284 <__bss_end+0xd855c4>
    15bc:	0073667a 	rsbseq	r6, r3, sl, ror r6
    15c0:	5f617369 	svcpl	0x00617369
    15c4:	5f746962 	svcpl	0x00746962
    15c8:	76706676 			; <UNDEFINED> instruction: 0x76706676
    15cc:	52410032 	subpl	r0, r1, #50	; 0x32
    15d0:	43505f4d 	cmpmi	r0, #308	; 0x134
    15d4:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    15d8:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    15dc:	4154004e 	cmpmi	r4, lr, asr #32
    15e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15e8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15ec:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    15f0:	5f455341 	svcpl	0x00455341
    15f4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    15f8:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    15fc:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1600:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1604:	5f6d7366 	svcpl	0x006d7366
    1608:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    160c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1610:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1614:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1618:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    161c:	63657073 	cmnvs	r5, #115	; 0x73
    1620:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1624:	73676e69 	cmnvc	r7, #1680	; 0x690
    1628:	61736900 	cmnvs	r3, r0, lsl #18
    162c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1630:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1634:	635f5f00 	cmpvs	pc, #0, 30
    1638:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1640 <shift+0x1640>
    163c:	41006261 	tstmi	r0, r1, ror #4
    1640:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1644:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1648:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    164c:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1650:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1654:	52410065 	subpl	r0, r1, #101	; 0x65
    1658:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    165c:	4d524100 	ldfmie	f4, [r2, #-0]
    1660:	0053565f 	subseq	r5, r3, pc, asr r6
    1664:	5f4d5241 	svcpl	0x004d5241
    1668:	61004547 	tstvs	r0, r7, asr #10
    166c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1674 <shift+0x1674>
    1670:	5f656e75 	svcpl	0x00656e75
    1674:	6f727473 	svcvs	0x00727473
    1678:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    167c:	6f63006d 	svcvs	0x0063006d
    1680:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1684:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1688:	0074616f 	rsbseq	r6, r4, pc, ror #2
    168c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1690:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1694:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1698:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    169c:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    16a0:	52415400 	subpl	r5, r1, #0, 8
    16a4:	5f544547 	svcpl	0x00544547
    16a8:	5f555043 	svcpl	0x00555043
    16ac:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    16b0:	00657436 	rsbeq	r7, r5, r6, lsr r4
    16b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16bc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    16c0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    16c4:	37316178 			; <UNDEFINED> instruction: 0x37316178
    16c8:	4d524100 	ldfmie	f4, [r2, #-0]
    16cc:	0054475f 	subseq	r4, r4, pc, asr r7
    16d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16d8:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    16dc:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    16e0:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    16e4:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    16e8:	2f2e2e2f 	svccs	0x002e2e2f
    16ec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16f0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16f4:	2f2e2e2f 	svccs	0x002e2e2f
    16f8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    16fc:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1578 <shift+0x1578>
    1700:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1704:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1708:	52415400 	subpl	r5, r1, #0, 8
    170c:	5f544547 	svcpl	0x00544547
    1710:	5f555043 	svcpl	0x00555043
    1714:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1718:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    171c:	41420066 	cmpmi	r2, r6, rrx
    1720:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1724:	5f484352 	svcpl	0x00484352
    1728:	004d4537 	subeq	r4, sp, r7, lsr r5
    172c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1730:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1734:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1738:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    173c:	32316178 	eorscc	r6, r1, #120, 2
    1740:	73616800 	cmnvc	r1, #0, 16
    1744:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1748:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    174c:	5f455341 	svcpl	0x00455341
    1750:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1754:	5a4b365f 	bpl	12cf0d8 <__bss_end+0x12c5418>
    1758:	61736900 	cmnvs	r3, r0, lsl #18
    175c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1760:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1764:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1768:	615f6863 	cmpvs	pc, r3, ror #16
    176c:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1770:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1774:	6d726100 	ldfvse	f6, [r2, #-0]
    1778:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    177c:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1780:	73690063 	cmnvc	r9, #99	; 0x63
    1784:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1788:	70665f74 	rsbvc	r5, r6, r4, ror pc
    178c:	47003631 	smladxmi	r0, r1, r6, r3
    1790:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1794:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    1798:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    179c:	31303220 	teqcc	r0, r0, lsr #4
    17a0:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    17a4:	72282035 	eorvc	r2, r8, #53	; 0x35
    17a8:	61656c65 	cmnvs	r5, r5, ror #24
    17ac:	20296573 	eorcs	r6, r9, r3, ror r5
    17b0:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    17b4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    17b8:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    17bc:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    17c0:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    17c4:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    17c8:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    17cc:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    17d0:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    17d4:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    17d8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    17dc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    17e0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    17e4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    17e8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    17ec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17f0:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    17f4:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    17f8:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    17fc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1800:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1804:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1808:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    180c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1810:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1814:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1818:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    181c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1820:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1824:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1694 <shift+0x1694>
    1828:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    182c:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1830:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1834:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1838:	6f6e662d 	svcvs	0x006e662d
    183c:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1840:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1844:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1848:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    184c:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1850:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1854:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1858:	5f4d5241 	svcpl	0x004d5241
    185c:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1860:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1864:	615f7469 	cmpvs	pc, r9, ror #8
    1868:	00766964 	rsbseq	r6, r6, r4, ror #18
    186c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1870:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1874:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1878:	31316d72 	teqcc	r1, r2, ror sp
    187c:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1880:	52415400 	subpl	r5, r1, #0, 8
    1884:	5f544547 	svcpl	0x00544547
    1888:	5f555043 	svcpl	0x00555043
    188c:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1890:	52415400 	subpl	r5, r1, #0, 8
    1894:	5f544547 	svcpl	0x00544547
    1898:	5f555043 	svcpl	0x00555043
    189c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    18a0:	52415400 	subpl	r5, r1, #0, 8
    18a4:	5f544547 	svcpl	0x00544547
    18a8:	5f555043 	svcpl	0x00555043
    18ac:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    18b0:	6f6c0036 	svcvs	0x006c0036
    18b4:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    18b8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    18bc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    18c0:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    18c4:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    18c8:	6d726100 	ldfvse	f6, [r2, #-0]
    18cc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    18d0:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    18d4:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    18d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18dc:	50435f54 	subpl	r5, r3, r4, asr pc
    18e0:	6f635f55 	svcvs	0x00635f55
    18e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18e8:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    18ec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18f0:	50435f54 	subpl	r5, r3, r4, asr pc
    18f4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    18f8:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    18fc:	52415400 	subpl	r5, r1, #0, 8
    1900:	5f544547 	svcpl	0x00544547
    1904:	5f555043 	svcpl	0x00555043
    1908:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    190c:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1910:	6d726100 	ldfvse	f6, [r2, #-0]
    1914:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1918:	6f635f64 	svcvs	0x00635f64
    191c:	41006564 	tstmi	r0, r4, ror #10
    1920:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1924:	415f5343 	cmpmi	pc, r3, asr #6
    1928:	53435041 	movtpl	r5, #12353	; 0x3041
    192c:	61736900 	cmnvs	r3, r0, lsl #18
    1930:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1934:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1938:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    193c:	53414200 	movtpl	r4, #4608	; 0x1200
    1940:	52415f45 	subpl	r5, r1, #276	; 0x114
    1944:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1948:	4154004d 	cmpmi	r4, sp, asr #32
    194c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1950:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1954:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1958:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    195c:	6d726100 	ldfvse	f6, [r2, #-0]
    1960:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1964:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1968:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    196c:	73690032 	cmnvc	r9, #50	; 0x32
    1970:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1974:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1978:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    197c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1980:	50435f54 	subpl	r5, r3, r4, asr pc
    1984:	6f635f55 	svcvs	0x00635f55
    1988:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    198c:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1990:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1994:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1998:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    199c:	00796c70 	rsbseq	r6, r9, r0, ror ip
    19a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19a8:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1460 <shift+0x1460>
    19ac:	6f6e7978 	svcvs	0x006e7978
    19b0:	00316d73 	eorseq	r6, r1, r3, ror sp
    19b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19bc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19c0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19c4:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    19c8:	61736900 	cmnvs	r3, r0, lsl #18
    19cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19d0:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    19d4:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    19d8:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    19dc:	6f656e5f 	svcvs	0x00656e5f
    19e0:	6f665f6e 	svcvs	0x00665f6e
    19e4:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    19e8:	73746962 	cmnvc	r4, #1605632	; 0x188000
    19ec:	61736900 	cmnvs	r3, r0, lsl #18
    19f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19f4:	3170665f 	cmncc	r0, pc, asr r6
    19f8:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    19fc:	52415400 	subpl	r5, r1, #0, 8
    1a00:	5f544547 	svcpl	0x00544547
    1a04:	5f555043 	svcpl	0x00555043
    1a08:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a0c:	33617865 	cmncc	r1, #6619136	; 0x650000
    1a10:	41540032 	cmpmi	r4, r2, lsr r0
    1a14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a1c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a20:	61786574 	cmnvs	r8, r4, ror r5
    1a24:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1a28:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a2c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1a30:	63363170 	teqvs	r6, #112, 2
    1a34:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1a38:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1a3c:	5f766365 	svcpl	0x00766365
    1a40:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1a44:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1a48:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a4c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a50:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a54:	31316d72 	teqcc	r1, r2, ror sp
    1a58:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1a5c:	41540073 	cmpmi	r4, r3, ror r0
    1a60:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a64:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a68:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1a6c:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1a70:	52415400 	subpl	r5, r1, #0, 8
    1a74:	5f544547 	svcpl	0x00544547
    1a78:	5f555043 	svcpl	0x00555043
    1a7c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1a80:	6a653632 	bvs	194f350 <__bss_end+0x1945690>
    1a84:	41420073 	hvcmi	8195	; 0x2003
    1a88:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a8c:	5f484352 	svcpl	0x00484352
    1a90:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    1a94:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a98:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1a9c:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1aa0:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    1aa4:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    1aa8:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1aac:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    1ab0:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    1ab4:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    1ab8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1abc:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1ac0:	41420062 	cmpmi	r2, r2, rrx
    1ac4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ac8:	5f484352 	svcpl	0x00484352
    1acc:	00455435 	subeq	r5, r5, r5, lsr r4
    1ad0:	5f617369 	svcpl	0x00617369
    1ad4:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1ad8:	00657275 	rsbeq	r7, r5, r5, ror r2
    1adc:	5f617369 	svcpl	0x00617369
    1ae0:	5f746962 	svcpl	0x00746962
    1ae4:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1ae8:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1aec:	6d726100 	ldfvse	f6, [r2, #-0]
    1af0:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    1af4:	756f5f67 	strbvc	r5, [pc, #-3943]!	; b95 <shift+0xb95>
    1af8:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1afc:	6a626f5f 	bvs	189d880 <__bss_end+0x1893bc0>
    1b00:	5f746365 	svcpl	0x00746365
    1b04:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1b08:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    1b0c:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1b10:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    1b14:	5f617369 	svcpl	0x00617369
    1b18:	5f746962 	svcpl	0x00746962
    1b1c:	645f7066 	ldrbvs	r7, [pc], #-102	; 1b24 <shift+0x1b24>
    1b20:	41003233 	tstmi	r0, r3, lsr r2
    1b24:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1b28:	73690045 	cmnvc	r9, #69	; 0x45
    1b2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b30:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1b34:	41540038 	cmpmi	r4, r8, lsr r0
    1b38:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b3c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b40:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b44:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1b48:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    1b4c:	636f7270 	cmnvs	pc, #112, 4
    1b50:	6f737365 	svcvs	0x00737365
    1b54:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b58:	61006570 	tstvs	r0, r0, ror r5
    1b5c:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    1b60:	00737570 	rsbseq	r7, r3, r0, ror r5
    1b64:	5f6d7261 	svcpl	0x006d7261
    1b68:	00736370 	rsbseq	r6, r3, r0, ror r3
    1b6c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1b70:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1b74:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1b78:	6d726100 	ldfvse	f6, [r2, #-0]
    1b7c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b80:	00743468 	rsbseq	r3, r4, r8, ror #8
    1b84:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b88:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b8c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b90:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b94:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1b98:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b9c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1ba0:	72610035 	rsbvc	r0, r1, #53	; 0x35
    1ba4:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1ba8:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    1bac:	00667562 	rsbeq	r7, r6, r2, ror #10
    1bb0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1bb4:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1bb8:	73690068 	cmnvc	r9, #104	; 0x68
    1bbc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1bc0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1bc4:	5f6b7269 	svcpl	0x006b7269
    1bc8:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1bcc:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1bd0:	5f656c69 	svcpl	0x00656c69
    1bd4:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    1bd8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bdc:	50435f54 	subpl	r5, r3, r4, asr pc
    1be0:	6f635f55 	svcvs	0x00635f55
    1be4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1be8:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    1bec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bf0:	50435f54 	subpl	r5, r3, r4, asr pc
    1bf4:	6f635f55 	svcvs	0x00635f55
    1bf8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1bfc:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1c00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c04:	50435f54 	subpl	r5, r3, r4, asr pc
    1c08:	6f635f55 	svcvs	0x00635f55
    1c0c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c10:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    1c14:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c18:	615f7469 	cmpvs	pc, r9, ror #8
    1c1c:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1c20:	6100315f 	tstvs	r0, pc, asr r1
    1c24:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c28:	5f686372 	svcpl	0x00686372
    1c2c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1c30:	61736900 	cmnvs	r3, r0, lsl #18
    1c34:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c38:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c3c:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1c40:	61736900 	cmnvs	r3, r0, lsl #18
    1c44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c48:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c4c:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1c54 <shift+0x1c54>
    1c50:	61736900 	cmnvs	r3, r0, lsl #18
    1c54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c58:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c5c:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 13ee <shift+0x13ee>
    1c60:	52415400 	subpl	r5, r1, #0, 8
    1c64:	5f544547 	svcpl	0x00544547
    1c68:	5f555043 	svcpl	0x00555043
    1c6c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c70:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1c74:	41540033 	cmpmi	r4, r3, lsr r0
    1c78:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c7c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c80:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c84:	61786574 	cmnvs	r8, r4, ror r5
    1c88:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    1c8c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c90:	50435f54 	subpl	r5, r3, r4, asr pc
    1c94:	6f635f55 	svcvs	0x00635f55
    1c98:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c9c:	00373561 	eorseq	r3, r7, r1, ror #10
    1ca0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ca8:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1b70 <shift+0x1b70>
    1cac:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1cb0:	41540065 	cmpmi	r4, r5, rrx
    1cb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cbc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cc0:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    1cc4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1cc8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ccc:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    1cd0:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1cd4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cd8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cdc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ce0:	30316d72 	eorscc	r6, r1, r2, ror sp
    1ce4:	6a653632 	bvs	194f5b4 <__bss_end+0x19458f4>
    1ce8:	41420073 	hvcmi	8195	; 0x2003
    1cec:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1cf0:	5f484352 	svcpl	0x00484352
    1cf4:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    1cf8:	5f455341 	svcpl	0x00455341
    1cfc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d00:	004b365f 	subeq	r3, fp, pc, asr r6
    1d04:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d08:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d0c:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    1d10:	61736900 	cmnvs	r3, r0, lsl #18
    1d14:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d18:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1d1c:	0074786d 	rsbseq	r7, r4, sp, ror #16
    1d20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d28:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d2c:	31316d72 	teqcc	r1, r2, ror sp
    1d30:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1d34:	52410073 	subpl	r0, r1, #115	; 0x73
    1d38:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1d3c:	4d524100 	ldfmie	f4, [r2, #-0]
    1d40:	00544c5f 	subseq	r4, r4, pc, asr ip
    1d44:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d48:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d4c:	5a365f48 	bpl	d99a74 <__bss_end+0xd8fdb4>
    1d50:	52415400 	subpl	r5, r1, #0, 8
    1d54:	5f544547 	svcpl	0x00544547
    1d58:	5f555043 	svcpl	0x00555043
    1d5c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d60:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1d64:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1d68:	61786574 	cmnvs	r8, r4, ror r5
    1d6c:	41003535 	tstmi	r0, r5, lsr r5
    1d70:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1d74:	415f5343 	cmpmi	pc, r3, asr #6
    1d78:	53435041 	movtpl	r5, #12353	; 0x3041
    1d7c:	5046565f 	subpl	r5, r6, pc, asr r6
    1d80:	52415400 	subpl	r5, r1, #0, 8
    1d84:	5f544547 	svcpl	0x00544547
    1d88:	5f555043 	svcpl	0x00555043
    1d8c:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1d90:	00327478 	eorseq	r7, r2, r8, ror r4
    1d94:	5f617369 	svcpl	0x00617369
    1d98:	5f746962 	svcpl	0x00746962
    1d9c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1da0:	6d726100 	ldfvse	f6, [r2, #-0]
    1da4:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1da8:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1dac:	73690072 	cmnvc	r9, #114	; 0x72
    1db0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1db4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1db8:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1dbc:	4154006d 	cmpmi	r4, sp, rrx
    1dc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1dc8:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1dcc:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1dd0:	52415400 	subpl	r5, r1, #0, 8
    1dd4:	5f544547 	svcpl	0x00544547
    1dd8:	5f555043 	svcpl	0x00555043
    1ddc:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    1de0:	5f6c6c65 	svcpl	0x006c6c65
    1de4:	00346a70 	eorseq	r6, r4, r0, ror sl
    1de8:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1dec:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1df0:	6f705f68 	svcvs	0x00705f68
    1df4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1df8:	72610072 	rsbvc	r0, r1, #114	; 0x72
    1dfc:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1e00:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    1e04:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e08:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e0c:	61736900 	cmnvs	r3, r0, lsl #18
    1e10:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e14:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1e18:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1e1c:	52415400 	subpl	r5, r1, #0, 8
    1e20:	5f544547 	svcpl	0x00544547
    1e24:	5f555043 	svcpl	0x00555043
    1e28:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e2c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1e30:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    1e34:	61786574 	cmnvs	r8, r4, ror r5
    1e38:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    1e3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e40:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1e48 <shift+0x1e48>
    1e44:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1e48:	41420032 	cmpmi	r2, r2, lsr r0
    1e4c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e50:	5f484352 	svcpl	0x00484352
    1e54:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    1e58:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e5c:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1e64 <shift+0x1e64>
    1e60:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1e64:	6100646f 	tstvs	r0, pc, ror #8
    1e68:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1e6c:	5f363170 	svcpl	0x00363170
    1e70:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1e74:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 1e7c <shift+0x1e7c>
    1e78:	52410065 	subpl	r0, r1, #101	; 0x65
    1e7c:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1e80:	6d726100 	ldfvse	f6, [r2, #-0]
    1e84:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e88:	006b3668 	rsbeq	r3, fp, r8, ror #12
    1e8c:	5f6d7261 	svcpl	0x006d7261
    1e90:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e94:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    1e98:	5f455341 	svcpl	0x00455341
    1e9c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ea0:	0052375f 	subseq	r3, r2, pc, asr r7
    1ea4:	6f705f5f 	svcvs	0x00705f5f
    1ea8:	756f6370 	strbvc	r6, [pc, #-880]!	; 1b40 <shift+0x1b40>
    1eac:	745f746e 	ldrbvc	r7, [pc], #-1134	; 1eb4 <shift+0x1eb4>
    1eb0:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    1eb4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1eb8:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1ebc:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1ec0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ec4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ec8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ecc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ed0:	33376178 	teqcc	r7, #120, 2
    1ed4:	52415400 	subpl	r5, r1, #0, 8
    1ed8:	5f544547 	svcpl	0x00544547
    1edc:	5f555043 	svcpl	0x00555043
    1ee0:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1ee4:	76636972 			; <UNDEFINED> instruction: 0x76636972
    1ee8:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    1eec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ef0:	50435f54 	subpl	r5, r3, r4, asr pc
    1ef4:	6f635f55 	svcvs	0x00635f55
    1ef8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1efc:	00363761 	eorseq	r3, r6, r1, ror #14
    1f00:	5f6d7261 	svcpl	0x006d7261
    1f04:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f08:	5f6f6e5f 	svcpl	0x006f6e5f
    1f0c:	616c6f76 	smcvs	50934	; 0xc6f6
    1f10:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1f14:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1f18:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f1c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f20:	41385f48 	teqmi	r8, r8, asr #30
    1f24:	61736900 	cmnvs	r3, r0, lsl #18
    1f28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f2c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f30:	00743576 	rsbseq	r3, r4, r6, ror r5
    1f34:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f38:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f3c:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    1f40:	52415400 	subpl	r5, r1, #0, 8
    1f44:	5f544547 	svcpl	0x00544547
    1f48:	5f555043 	svcpl	0x00555043
    1f4c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f50:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1f54:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1f58:	61786574 	cmnvs	r8, r4, ror r5
    1f5c:	41003533 	tstmi	r0, r3, lsr r5
    1f60:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1f64:	72610056 	rsbvc	r0, r1, #86	; 0x56
    1f68:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f6c:	00346863 	eorseq	r6, r4, r3, ror #16
    1f70:	5f6d7261 	svcpl	0x006d7261
    1f74:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f78:	72610036 	rsbvc	r0, r1, #54	; 0x36
    1f7c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f80:	00376863 	eorseq	r6, r7, r3, ror #16
    1f84:	5f6d7261 	svcpl	0x006d7261
    1f88:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f8c:	6f6c0038 	svcvs	0x006c0038
    1f90:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1f94:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1f98:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1f9c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1fa0:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1fa4:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1fa8:	616d0065 	cmnvs	sp, r5, rrx
    1fac:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    1fb0:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1fb4:	745f7473 	ldrbvc	r7, [pc], #-1139	; 1fbc <shift+0x1fbc>
    1fb8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1fbc:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    1fc0:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    1fc4:	5f6c6c61 	svcpl	0x006c6c61
    1fc8:	5f616976 	svcpl	0x00616976
    1fcc:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    1fd0:	7369006c 	cmnvc	r9, #108	; 0x6c
    1fd4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fd8:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1fdc:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    1fe0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fe4:	615f7469 	cmpvs	pc, r9, ror #8
    1fe8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1fec:	4154006b 	cmpmi	r4, fp, rrx
    1ff0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ff4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ff8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ffc:	61786574 	cmnvs	r8, r4, ror r5
    2000:	41540037 	cmpmi	r4, r7, lsr r0
    2004:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2008:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    200c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2010:	61786574 	cmnvs	r8, r4, ror r5
    2014:	41540038 	cmpmi	r4, r8, lsr r0
    2018:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    201c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2020:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2024:	61786574 	cmnvs	r8, r4, ror r5
    2028:	52410039 	subpl	r0, r1, #57	; 0x39
    202c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2030:	50415f53 	subpl	r5, r1, r3, asr pc
    2034:	41005343 	tstmi	r0, r3, asr #6
    2038:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    203c:	415f5343 	cmpmi	pc, r3, asr #6
    2040:	53435054 	movtpl	r5, #12372	; 0x3054
    2044:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 204c <shift+0x204c>
    2048:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    204c:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1c34 <shift+0x1c34>
    2050:	00656c62 	rsbeq	r6, r5, r2, ror #24
    2054:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2058:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    205c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2060:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2064:	33376178 	teqcc	r7, #120, 2
    2068:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    206c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2070:	41540033 	cmpmi	r4, r3, lsr r0
    2074:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2078:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    207c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2080:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2084:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    2088:	72610073 	rsbvc	r0, r1, #115	; 0x73
    208c:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    2090:	61736900 	cmnvs	r3, r0, lsl #18
    2094:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2098:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    209c:	00656c61 	rsbeq	r6, r5, r1, ror #24
    20a0:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    20a4:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    20a8:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    20ac:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    20b0:	5f657265 	svcpl	0x00657265
    20b4:	52415400 	subpl	r5, r1, #0, 8
    20b8:	5f544547 	svcpl	0x00544547
    20bc:	5f555043 	svcpl	0x00555043
    20c0:	316d7261 	cmncc	sp, r1, ror #4
    20c4:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    20c8:	41540069 	cmpmi	r4, r9, rrx
    20cc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20d0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20d4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    20d8:	61786574 	cmnvs	r8, r4, ror r5
    20dc:	61620035 	cmnvs	r2, r5, lsr r0
    20e0:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    20e4:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    20e8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    20ec:	00657275 	rsbeq	r7, r5, r5, ror r2
    20f0:	5f6d7261 	svcpl	0x006d7261
    20f4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20f8:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    20fc:	52415400 	subpl	r5, r1, #0, 8
    2100:	5f544547 	svcpl	0x00544547
    2104:	5f555043 	svcpl	0x00555043
    2108:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    210c:	316d7865 	cmncc	sp, r5, ror #16
    2110:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2114:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2118:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    211c:	72610079 	rsbvc	r0, r1, #121	; 0x79
    2120:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    2124:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    2128:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    212c:	61736900 	cmnvs	r3, r0, lsl #18
    2130:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2134:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2138:	41003233 	tstmi	r0, r3, lsr r2
    213c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2140:	7369004c 	cmnvc	r9, #76	; 0x4c
    2144:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2148:	66765f74 	uhsub16vs	r5, r6, r4
    214c:	00337670 	eorseq	r7, r3, r0, ror r6
    2150:	5f617369 	svcpl	0x00617369
    2154:	5f746962 	svcpl	0x00746962
    2158:	76706676 			; <UNDEFINED> instruction: 0x76706676
    215c:	41420034 	cmpmi	r2, r4, lsr r0
    2160:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2164:	5f484352 	svcpl	0x00484352
    2168:	00325436 	eorseq	r5, r2, r6, lsr r4
    216c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2170:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2174:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    2178:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    217c:	4154004e 	cmpmi	r4, lr, asr #32
    2180:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2184:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2188:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    218c:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    2190:	52410069 	subpl	r0, r1, #105	; 0x69
    2194:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    2198:	53414200 	movtpl	r4, #4608	; 0x1200
    219c:	52415f45 	subpl	r5, r1, #276	; 0x114
    21a0:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    21a4:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    21a8:	61745f6d 	cmnvs	r4, sp, ror #30
    21ac:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    21b0:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    21b4:	61006c65 	tstvs	r0, r5, ror #24
    21b8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 21c0 <shift+0x21c0>
    21bc:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    21c0:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    21c4:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    21c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21cc:	50435f54 	subpl	r5, r3, r4, asr pc
    21d0:	6f635f55 	svcvs	0x00635f55
    21d4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21d8:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    21dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21e0:	50435f54 	subpl	r5, r3, r4, asr pc
    21e4:	6f635f55 	svcvs	0x00635f55
    21e8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21ec:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    21f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21f4:	50435f54 	subpl	r5, r3, r4, asr pc
    21f8:	6f635f55 	svcvs	0x00635f55
    21fc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2200:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    2204:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2208:	50435f54 	subpl	r5, r3, r4, asr pc
    220c:	6f635f55 	svcvs	0x00635f55
    2210:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2214:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2218:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    221c:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2220:	00656170 	rsbeq	r6, r5, r0, ror r1
    2224:	5f617369 	svcpl	0x00617369
    2228:	5f746962 	svcpl	0x00746962
    222c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2230:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2234:	6b36766d 	blvs	d9fbf0 <__bss_end+0xd95f30>
    2238:	7369007a 	cmnvc	r9, #122	; 0x7a
    223c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2240:	6f6e5f74 	svcvs	0x006e5f74
    2244:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2248:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    224c:	615f7469 	cmpvs	pc, r9, ror #8
    2250:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    2254:	61736900 	cmnvs	r3, r0, lsl #18
    2258:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    225c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2260:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    2264:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2268:	615f7469 	cmpvs	pc, r9, ror #8
    226c:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2270:	61736900 	cmnvs	r3, r0, lsl #18
    2274:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2278:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    227c:	5f003876 	svcpl	0x00003876
    2280:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    2284:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2288:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    228c:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2290:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    2294:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    2298:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    229c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    22a0:	615f7469 	cmpvs	pc, r9, ror #8
    22a4:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    22a8:	61006574 	tstvs	r0, r4, ror r5
    22ac:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 22b4 <shift+0x22b4>
    22b0:	00656e75 	rsbeq	r6, r5, r5, ror lr
    22b4:	5f6d7261 	svcpl	0x006d7261
    22b8:	5f707063 	svcpl	0x00707063
    22bc:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    22c0:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    22c4:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    22c8:	705f636e 	subsvc	r6, pc, lr, ror #6
    22cc:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    22d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22d4:	50435f54 	subpl	r5, r3, r4, asr pc
    22d8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    22dc:	3032396d 	eorscc	r3, r2, sp, ror #18
    22e0:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    22e4:	655f6261 	ldrbvs	r6, [pc, #-609]	; 208b <shift+0x208b>
    22e8:	41540071 	cmpmi	r4, r1, ror r0
    22ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22f4:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    22f8:	61003632 	tstvs	r0, r2, lsr r6
    22fc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2300:	5f686372 	svcpl	0x00686372
    2304:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2308:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    230c:	00766964 	rsbseq	r6, r6, r4, ror #18
    2310:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2314:	5f71655f 	svcpl	0x0071655f
    2318:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    231c:	00726574 	rsbseq	r6, r2, r4, ror r5
    2320:	5f6d7261 	svcpl	0x006d7261
    2324:	5f636970 	svcpl	0x00636970
    2328:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    232c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2330:	52415400 	subpl	r5, r1, #0, 8
    2334:	5f544547 	svcpl	0x00544547
    2338:	5f555043 	svcpl	0x00555043
    233c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2340:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2344:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2348:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    234c:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2350:	41540079 	cmpmi	r4, r9, ror r0
    2354:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2358:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    235c:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2360:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    2364:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2368:	61736900 	cmnvs	r3, r0, lsl #18
    236c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2370:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2374:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2378:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    237c:	00647264 	rsbeq	r7, r4, r4, ror #4
    2380:	5f4d5241 	svcpl	0x004d5241
    2384:	61004343 	tstvs	r0, r3, asr #6
    2388:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    238c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2390:	6100325f 	tstvs	r0, pc, asr r2
    2394:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2398:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    239c:	6100335f 	tstvs	r0, pc, asr r3
    23a0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23a4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    23a8:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    23ac:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23b0:	50435f54 	subpl	r5, r3, r4, asr pc
    23b4:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    23b8:	36323670 			; <UNDEFINED> instruction: 0x36323670
    23bc:	4d524100 	ldfmie	f4, [r2, #-0]
    23c0:	0053435f 	subseq	r4, r3, pc, asr r3
    23c4:	5f6d7261 	svcpl	0x006d7261
    23c8:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    23cc:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    23d0:	72610074 	rsbvc	r0, r1, #116	; 0x74
    23d4:	61625f6d 	cmnvs	r2, sp, ror #30
    23d8:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    23dc:	00686372 	rsbeq	r6, r8, r2, ror r3
    23e0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23e4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    23e8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    23ec:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    23f0:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    23f4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23f8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2400:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2404:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2408:	52415400 	subpl	r5, r1, #0, 8
    240c:	5f544547 	svcpl	0x00544547
    2410:	5f555043 	svcpl	0x00555043
    2414:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2418:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    241c:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2420:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    2424:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2428:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    242c:	52410074 	subpl	r0, r1, #116	; 0x74
    2430:	43505f4d 	cmpmi	r0, #308	; 0x134
    2434:	41415f53 	cmpmi	r1, r3, asr pc
    2438:	5f534350 	svcpl	0x00534350
    243c:	41434f4c 	cmpmi	r3, ip, asr #30
    2440:	4154004c 	cmpmi	r4, ip, asr #32
    2444:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2448:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    244c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2450:	61786574 	cmnvs	r8, r4, ror r5
    2454:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    2458:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    245c:	50435f54 	subpl	r5, r3, r4, asr pc
    2460:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    2464:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    2468:	006d7261 	rsbeq	r7, sp, r1, ror #4
    246c:	5f6d7261 	svcpl	0x006d7261
    2470:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2474:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2478:	0031626d 	eorseq	r6, r1, sp, ror #4
    247c:	5f6d7261 	svcpl	0x006d7261
    2480:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2484:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2488:	0032626d 	eorseq	r6, r2, sp, ror #4
    248c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2490:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2494:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2498:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    249c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    24a0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24a4:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    24a8:	61736900 	cmnvs	r3, r0, lsl #18
    24ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    24b0:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    24b4:	5f6d7261 	svcpl	0x006d7261
    24b8:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    24bc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    24c0:	6d726100 	ldfvse	f6, [r2, #-0]
    24c4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24c8:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9c70>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346b70>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9c90>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8fc0>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9cc0>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346bc0>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9ce0>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346be0>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9d00>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346c00>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9d20>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346c20>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9d40>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346c40>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9d60>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346c60>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9d80>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346c80>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9d98>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9db8>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9de8>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008268 	andeq	r8, r0, r8, ror #4
 1b4:	00000038 	andeq	r0, r0, r8, lsr r0
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1f9e08>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 1c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1c8:	00000018 	andeq	r0, r0, r8, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000082a0 	andeq	r8, r0, r0, lsr #5
 1d4:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 1d8:	8b080e42 	blhi	203ae8 <__bss_end+0x1f9e28>
 1dc:	42018e02 	andmi	r8, r1, #2, 28
 1e0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1e4:	0000000c 	andeq	r0, r0, ip
 1e8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ec:	7c020001 	stcvc	0, cr0, [r2], {1}
 1f0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001e4 	andeq	r0, r0, r4, ror #3
 1fc:	00008558 	andeq	r8, r0, r8, asr r5
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9e54>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346d54>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001e4 	andeq	r0, r0, r4, ror #3
 21c:	00008584 	andeq	r8, r0, r4, lsl #11
 220:	0000002c 	andeq	r0, r0, ip, lsr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9e74>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346d74>
 22c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001e4 	andeq	r0, r0, r4, ror #3
 23c:	000085b0 			; <UNDEFINED> instruction: 0x000085b0
 240:	0000001c 	andeq	r0, r0, ip, lsl r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9e94>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346d94>
 24c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001e4 	andeq	r0, r0, r4, ror #3
 25c:	000085cc 	andeq	r8, r0, ip, asr #11
 260:	00000044 	andeq	r0, r0, r4, asr #32
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9eb4>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346db4>
 26c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001e4 	andeq	r0, r0, r4, ror #3
 27c:	00008610 	andeq	r8, r0, r0, lsl r6
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9ed4>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346dd4>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001e4 	andeq	r0, r0, r4, ror #3
 29c:	00008660 	andeq	r8, r0, r0, ror #12
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9ef4>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346df4>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001e4 	andeq	r0, r0, r4, ror #3
 2bc:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 2c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9f14>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346e14>
 2cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001e4 	andeq	r0, r0, r4, ror #3
 2dc:	000086dc 	ldrdeq	r8, [r0], -ip
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9f34>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346e34>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001e4 	andeq	r0, r0, r4, ror #3
 2fc:	0000872c 	andeq	r8, r0, ip, lsr #14
 300:	00000044 	andeq	r0, r0, r4, asr #32
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9f54>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346e54>
 30c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001e4 	andeq	r0, r0, r4, ror #3
 31c:	00008770 	andeq	r8, r0, r0, ror r7
 320:	00000050 	andeq	r0, r0, r0, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf9f74>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346e74>
 32c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001e4 	andeq	r0, r0, r4, ror #3
 33c:	000087c0 	andeq	r8, r0, r0, asr #15
 340:	00000054 	andeq	r0, r0, r4, asr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf9f94>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346e94>
 34c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001e4 	andeq	r0, r0, r4, ror #3
 35c:	00008814 	andeq	r8, r0, r4, lsl r8
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf9fb4>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346eb4>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001e4 	andeq	r0, r0, r4, ror #3
 37c:	00008850 	andeq	r8, r0, r0, asr r8
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf9fd4>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346ed4>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001e4 	andeq	r0, r0, r4, ror #3
 39c:	0000888c 	andeq	r8, r0, ip, lsl #17
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xf9ff4>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x346ef4>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001e4 	andeq	r0, r0, r4, ror #3
 3bc:	000088c8 	andeq	r8, r0, r8, asr #17
 3c0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3c4:	8b040e42 	blhi	103cd4 <__bss_end+0xfa014>
 3c8:	0b0d4201 	bleq	350bd4 <__bss_end+0x346f14>
 3cc:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d8:	000001e4 	andeq	r0, r0, r4, ror #3
 3dc:	00008904 	andeq	r8, r0, r4, lsl #18
 3e0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3e4:	8b080e42 	blhi	203cf4 <__bss_end+0x1fa034>
 3e8:	42018e02 	andmi	r8, r1, #2, 28
 3ec:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3f0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3f4:	0000000c 	andeq	r0, r0, ip
 3f8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3fc:	7c020001 	stcvc	0, cr0, [r2], {1}
 400:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003f4 	strdeq	r0, [r0], -r4
 40c:	000089b4 			; <UNDEFINED> instruction: 0x000089b4
 410:	00000174 	andeq	r0, r0, r4, ror r1
 414:	8b080e42 	blhi	203d24 <__bss_end+0x1fa064>
 418:	42018e02 	andmi	r8, r1, #2, 28
 41c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 420:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003f4 	strdeq	r0, [r0], -r4
 42c:	00008b28 	andeq	r8, r0, r8, lsr #22
 430:	0000009c 	muleq	r0, ip, r0
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa084>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x346f84>
 43c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003f4 	strdeq	r0, [r0], -r4
 44c:	00008bc4 	andeq	r8, r0, r4, asr #23
 450:	000000c0 	andeq	r0, r0, r0, asr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa0a4>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x346fa4>
 45c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003f4 	strdeq	r0, [r0], -r4
 46c:	00008c84 	andeq	r8, r0, r4, lsl #25
 470:	000000ac 	andeq	r0, r0, ip, lsr #1
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa0c4>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x346fc4>
 47c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 480:	000ecb42 	andeq	ip, lr, r2, asr #22
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003f4 	strdeq	r0, [r0], -r4
 48c:	00008d30 	andeq	r8, r0, r0, lsr sp
 490:	00000054 	andeq	r0, r0, r4, asr r0
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa0e4>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x346fe4>
 49c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003f4 	strdeq	r0, [r0], -r4
 4ac:	00008d84 	andeq	r8, r0, r4, lsl #27
 4b0:	00000068 	andeq	r0, r0, r8, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa104>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347004>
 4bc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003f4 	strdeq	r0, [r0], -r4
 4cc:	00008dec 	andeq	r8, r0, ip, ror #27
 4d0:	00000080 	andeq	r0, r0, r0, lsl #1
 4d4:	8b040e42 	blhi	103de4 <__bss_end+0xfa124>
 4d8:	0b0d4201 	bleq	350ce4 <__bss_end+0x347024>
 4dc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	000003f4 	strdeq	r0, [r0], -r4
 4ec:	00008e6c 	andeq	r8, r0, ip, ror #28
 4f0:	0000006c 	andeq	r0, r0, ip, rrx
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa144>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x347044>
 4fc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 500:	00000ecb 	andeq	r0, r0, fp, asr #29
 504:	0000001c 	andeq	r0, r0, ip, lsl r0
 508:	000003f4 	strdeq	r0, [r0], -r4
 50c:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 510:	000000c4 	andeq	r0, r0, r4, asr #1
 514:	8b080e42 	blhi	203e24 <__bss_end+0x1fa164>
 518:	42018e02 	andmi	r8, r1, #2, 28
 51c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 520:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 524:	00000020 	andeq	r0, r0, r0, lsr #32
 528:	000003f4 	strdeq	r0, [r0], -r4
 52c:	00008f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>
 530:	00000440 	andeq	r0, r0, r0, asr #8
 534:	8b040e42 	blhi	103e44 <__bss_end+0xfa184>
 538:	0b0d4201 	bleq	350d44 <__bss_end+0x347084>
 53c:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 540:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 544:	00000000 	andeq	r0, r0, r0
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003f4 	strdeq	r0, [r0], -r4
 550:	000093dc 	ldrdeq	r9, [r0], -ip
 554:	000000d4 	ldrdeq	r0, [r0], -r4
 558:	8b080e42 	blhi	203e68 <__bss_end+0x1fa1a8>
 55c:	42018e02 	andmi	r8, r1, #2, 28
 560:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 564:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003f4 	strdeq	r0, [r0], -r4
 570:	000094b0 			; <UNDEFINED> instruction: 0x000094b0
 574:	0000003c 	andeq	r0, r0, ip, lsr r0
 578:	8b040e42 	blhi	103e88 <__bss_end+0xfa1c8>
 57c:	0b0d4201 	bleq	350d88 <__bss_end+0x3470c8>
 580:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 584:	00000ecb 	andeq	r0, r0, fp, asr #29
 588:	0000001c 	andeq	r0, r0, ip, lsl r0
 58c:	000003f4 	strdeq	r0, [r0], -r4
 590:	000094ec 	andeq	r9, r0, ip, ror #9
 594:	00000040 	andeq	r0, r0, r0, asr #32
 598:	8b040e42 	blhi	103ea8 <__bss_end+0xfa1e8>
 59c:	0b0d4201 	bleq	350da8 <__bss_end+0x3470e8>
 5a0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 5a4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5ac:	000003f4 	strdeq	r0, [r0], -r4
 5b0:	0000952c 	andeq	r9, r0, ip, lsr #10
 5b4:	00000030 	andeq	r0, r0, r0, lsr r0
 5b8:	8b080e42 	blhi	203ec8 <__bss_end+0x1fa208>
 5bc:	42018e02 	andmi	r8, r1, #2, 28
 5c0:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 5c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 5c8:	00000020 	andeq	r0, r0, r0, lsr #32
 5cc:	000003f4 	strdeq	r0, [r0], -r4
 5d0:	0000955c 	andeq	r9, r0, ip, asr r5
 5d4:	00000324 	andeq	r0, r0, r4, lsr #6
 5d8:	8b080e42 	blhi	203ee8 <__bss_end+0x1fa228>
 5dc:	42018e02 	andmi	r8, r1, #2, 28
 5e0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5e4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5e8:	00000008 	andeq	r0, r0, r8
 5ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 5f0:	000003f4 	strdeq	r0, [r0], -r4
 5f4:	00009880 	andeq	r9, r0, r0, lsl #17
 5f8:	00000110 	andeq	r0, r0, r0, lsl r1
 5fc:	8b040e42 	blhi	103f0c <__bss_end+0xfa24c>
 600:	0b0d4201 	bleq	350e0c <__bss_end+0x34714c>
 604:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 608:	000ecb42 	andeq	ip, lr, r2, asr #22
 60c:	0000000c 	andeq	r0, r0, ip
 610:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 614:	7c010001 	stcvc	0, cr0, [r1], {1}
 618:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 61c:	0000000c 	andeq	r0, r0, ip
 620:	0000060c 	andeq	r0, r0, ip, lsl #12
 624:	00009990 	muleq	r0, r0, r9
 628:	000001ec 	andeq	r0, r0, ip, ror #3
