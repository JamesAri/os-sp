
./counter_task:     file format elf32-littlearm


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
    805c:	00009b00 	andeq	r9, r0, r0, lsl #22
    8060:	00009b10 	andeq	r9, r0, r0, lsl fp

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
    81cc:	00009afd 	strdeq	r9, [r0], -sp
    81d0:	00009afd 	strdeq	r9, [r0], -sp

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
    8224:	00009afd 	strdeq	r9, [r0], -sp
    8228:	00009afd 	strdeq	r9, [r0], -sp

0000822c <main>:
main():
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:17
 *  - vzestupne pokud je prepinac 1 v poloze "zapnuto", jinak sestupne
 *  - rychle pokud je prepinac 2 v poloze "zapnuto", jinak pomalu
 **/

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd020 	sub	sp, sp, #32
    8238:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    823c:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:18
	uint32_t display_file = open("DEV:segd", NFile_Open_Mode::Write_Only);
    8240:	e3a01001 	mov	r1, #1
    8244:	e59f0164 	ldr	r0, [pc, #356]	; 83b0 <main+0x184>
    8248:	eb000079 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    824c:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:19
	uint32_t switch1_file = open("DEV:gpio/4", NFile_Open_Mode::Read_Only);
    8250:	e3a01000 	mov	r1, #0
    8254:	e59f0158 	ldr	r0, [pc, #344]	; 83b4 <main+0x188>
    8258:	eb000075 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    825c:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:20
	uint32_t switch2_file = open("DEV:gpio/17", NFile_Open_Mode::Read_Only);
    8260:	e3a01000 	mov	r1, #0
    8264:	e59f014c 	ldr	r0, [pc, #332]	; 83b8 <main+0x18c>
    8268:	eb000071 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    826c:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:22

	unsigned int counter = 0;
    8270:	e3a03000 	mov	r3, #0
    8274:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:23
	bool fast = false;
    8278:	e3a03000 	mov	r3, #0
    827c:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:24
	bool ascending = true;
    8280:	e3a03001 	mov	r3, #1
    8284:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:26

	set_task_deadline(fast ? 0x1000 : 0x2800);
    8288:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    828c:	e3530000 	cmp	r3, #0
    8290:	0a000001 	beq	829c <main+0x70>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 1)
    8294:	e3a03a01 	mov	r3, #4096	; 0x1000
    8298:	ea000000 	b	82a0 <main+0x74>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 2)
    829c:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 4)
    82a0:	e1a00003 	mov	r0, r3
    82a4:	eb000112 	bl	86f4 <_Z17set_task_deadlinej>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:30

	while (true)
	{
		char tmp = '0';
    82a8:	e3a03030 	mov	r3, #48	; 0x30
    82ac:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:32

		read(switch1_file, &tmp, 1);
    82b0:	e24b3017 	sub	r3, fp, #23
    82b4:	e3a02001 	mov	r2, #1
    82b8:	e1a01003 	mov	r1, r3
    82bc:	e51b0010 	ldr	r0, [fp, #-16]
    82c0:	eb00006c 	bl	8478 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:33
		ascending = (tmp == '1');
    82c4:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82c8:	e3530031 	cmp	r3, #49	; 0x31
    82cc:	03a03001 	moveq	r3, #1
    82d0:	13a03000 	movne	r3, #0
    82d4:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:35

		read(switch2_file, &tmp, 1);
    82d8:	e24b3017 	sub	r3, fp, #23
    82dc:	e3a02001 	mov	r2, #1
    82e0:	e1a01003 	mov	r1, r3
    82e4:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    82e8:	eb000062 	bl	8478 <_Z4readjPcj>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:36
		fast = (tmp == '1');
    82ec:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82f0:	e3530031 	cmp	r3, #49	; 0x31
    82f4:	03a03001 	moveq	r3, #1
    82f8:	13a03000 	movne	r3, #0
    82fc:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:38

		if (ascending)
    8300:	e55b3016 	ldrb	r3, [fp, #-22]	; 0xffffffea
    8304:	e3530000 	cmp	r3, #0
    8308:	0a000003 	beq	831c <main+0xf0>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:39
			counter++;
    830c:	e51b3008 	ldr	r3, [fp, #-8]
    8310:	e2833001 	add	r3, r3, #1
    8314:	e50b3008 	str	r3, [fp, #-8]
    8318:	ea000002 	b	8328 <main+0xfc>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:41
		else
			counter--;
    831c:	e51b3008 	ldr	r3, [fp, #-8]
    8320:	e2433001 	sub	r3, r3, #1
    8324:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:43

		tmp = '0' + (counter % 10);
    8328:	e51b1008 	ldr	r1, [fp, #-8]
    832c:	e59f3088 	ldr	r3, [pc, #136]	; 83bc <main+0x190>
    8330:	e0832193 	umull	r2, r3, r3, r1
    8334:	e1a021a3 	lsr	r2, r3, #3
    8338:	e1a03002 	mov	r3, r2
    833c:	e1a03103 	lsl	r3, r3, #2
    8340:	e0833002 	add	r3, r3, r2
    8344:	e1a03083 	lsl	r3, r3, #1
    8348:	e0412003 	sub	r2, r1, r3
    834c:	e6ef3072 	uxtb	r3, r2
    8350:	e2833030 	add	r3, r3, #48	; 0x30
    8354:	e6ef3073 	uxtb	r3, r3
    8358:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:44
		write(display_file, &tmp, 1);
    835c:	e24b3017 	sub	r3, fp, #23
    8360:	e3a02001 	mov	r2, #1
    8364:	e1a01003 	mov	r1, r3
    8368:	e51b000c 	ldr	r0, [fp, #-12]
    836c:	eb000055 	bl	84c8 <_Z5writejPKcj>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46

		sleep(fast ? 0x400 : 0x600, fast ? 0x1000 : 0x2800);
    8370:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8374:	e3530000 	cmp	r3, #0
    8378:	0a000001 	beq	8384 <main+0x158>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 1)
    837c:	e3a02b01 	mov	r2, #1024	; 0x400
    8380:	ea000000 	b	8388 <main+0x15c>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 2)
    8384:	e3a02c06 	mov	r2, #1536	; 0x600
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 4)
    8388:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    838c:	e3530000 	cmp	r3, #0
    8390:	0a000001 	beq	839c <main+0x170>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 5)
    8394:	e3a03a01 	mov	r3, #4096	; 0x1000
    8398:	ea000000 	b	83a0 <main+0x174>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 6)
    839c:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 8)
    83a0:	e1a01003 	mov	r1, r3
    83a4:	e1a00002 	mov	r0, r2
    83a8:	eb00009e 	bl	8628 <_Z5sleepjj>
/home/jamesari/git/os/sp/sources/userspace/counter_task/main.cpp:47 (discriminator 8)
	}
    83ac:	eaffffbd 	b	82a8 <main+0x7c>
    83b0:	00009a78 	andeq	r9, r0, r8, ror sl
    83b4:	00009a84 	andeq	r9, r0, r4, lsl #21
    83b8:	00009a90 	muleq	r0, r0, sl
    83bc:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000083c0 <_Z6getpidv>:
_Z6getpidv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c4:	e28db000 	add	fp, sp, #0
    83c8:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83cc:	ef000000 	svc	0x00000000
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83d0:	e1a03000 	mov	r3, r0
    83d4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:12
}
    83dc:	e1a00003 	mov	r0, r3
    83e0:	e28bd000 	add	sp, fp, #0
    83e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83e8:	e12fff1e 	bx	lr

000083ec <_Z9terminatei>:
_Z9terminatei():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f0:	e28db000 	add	fp, sp, #0
    83f4:	e24dd00c 	sub	sp, sp, #12
    83f8:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    83fc:	e51b3008 	ldr	r3, [fp, #-8]
    8400:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8404:	ef000001 	svc	0x00000001
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:18
}
    8408:	e320f000 	nop	{0}
    840c:	e28bd000 	add	sp, fp, #0
    8410:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8414:	e12fff1e 	bx	lr

00008418 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8420:	ef000002 	svc	0x00000002
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:23
}
    8424:	e320f000 	nop	{0}
    8428:	e28bd000 	add	sp, fp, #0
    842c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8430:	e12fff1e 	bx	lr

00008434 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8434:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8438:	e28db000 	add	fp, sp, #0
    843c:	e24dd014 	sub	sp, sp, #20
    8440:	e50b0010 	str	r0, [fp, #-16]
    8444:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8448:	e51b3010 	ldr	r3, [fp, #-16]
    844c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8450:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8454:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8458:	ef000040 	svc	0x00000040
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    845c:	e1a03000 	mov	r3, r0
    8460:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    8464:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:35
}
    8468:	e1a00003 	mov	r0, r3
    846c:	e28bd000 	add	sp, fp, #0
    8470:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8474:	e12fff1e 	bx	lr

00008478 <_Z4readjPcj>:
_Z4readjPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8478:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    847c:	e28db000 	add	fp, sp, #0
    8480:	e24dd01c 	sub	sp, sp, #28
    8484:	e50b0010 	str	r0, [fp, #-16]
    8488:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    848c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8490:	e51b3010 	ldr	r3, [fp, #-16]
    8494:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8498:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    849c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84a4:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84a8:	ef000041 	svc	0x00000041
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    84ac:	e1a03000 	mov	r3, r0
    84b0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84b4:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:48
}
    84b8:	e1a00003 	mov	r0, r3
    84bc:	e28bd000 	add	sp, fp, #0
    84c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c4:	e12fff1e 	bx	lr

000084c8 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84cc:	e28db000 	add	fp, sp, #0
    84d0:	e24dd01c 	sub	sp, sp, #28
    84d4:	e50b0010 	str	r0, [fp, #-16]
    84d8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84dc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84e0:	e51b3010 	ldr	r3, [fp, #-16]
    84e4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    84e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ec:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    84f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84f4:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    84f8:	ef000042 	svc	0x00000042
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    84fc:	e1a03000 	mov	r3, r0
    8500:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8504:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:61
}
    8508:	e1a00003 	mov	r0, r3
    850c:	e28bd000 	add	sp, fp, #0
    8510:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8514:	e12fff1e 	bx	lr

00008518 <_Z5closej>:
_Z5closej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8518:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    851c:	e28db000 	add	fp, sp, #0
    8520:	e24dd00c 	sub	sp, sp, #12
    8524:	e50b0008 	str	r0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8528:	e51b3008 	ldr	r3, [fp, #-8]
    852c:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8530:	ef000043 	svc	0x00000043
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:67
}
    8534:	e320f000 	nop	{0}
    8538:	e28bd000 	add	sp, fp, #0
    853c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8540:	e12fff1e 	bx	lr

00008544 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8544:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8548:	e28db000 	add	fp, sp, #0
    854c:	e24dd01c 	sub	sp, sp, #28
    8550:	e50b0010 	str	r0, [fp, #-16]
    8554:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8558:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    855c:	e51b3010 	ldr	r3, [fp, #-16]
    8560:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8564:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8568:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    856c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8570:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8574:	ef000044 	svc	0x00000044
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8578:	e1a03000 	mov	r3, r0
    857c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8580:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:80
}
    8584:	e1a00003 	mov	r0, r3
    8588:	e28bd000 	add	sp, fp, #0
    858c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8590:	e12fff1e 	bx	lr

00008594 <_Z6notifyjj>:
_Z6notifyjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8594:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8598:	e28db000 	add	fp, sp, #0
    859c:	e24dd014 	sub	sp, sp, #20
    85a0:	e50b0010 	str	r0, [fp, #-16]
    85a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    85a8:	e51b3010 	ldr	r3, [fp, #-16]
    85ac:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    85b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85b4:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    85b8:	ef000045 	svc	0x00000045
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85bc:	e1a03000 	mov	r3, r0
    85c0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    85c4:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:92
}
    85c8:	e1a00003 	mov	r0, r3
    85cc:	e28bd000 	add	sp, fp, #0
    85d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85d4:	e12fff1e 	bx	lr

000085d8 <_Z4waitjjj>:
_Z4waitjjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85dc:	e28db000 	add	fp, sp, #0
    85e0:	e24dd01c 	sub	sp, sp, #28
    85e4:	e50b0010 	str	r0, [fp, #-16]
    85e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85ec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85f0:	e51b3010 	ldr	r3, [fp, #-16]
    85f4:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    85f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85fc:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8600:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8604:	e1a02003 	mov	r2, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8608:	ef000046 	svc	0x00000046
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    860c:	e1a03000 	mov	r3, r0
    8610:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8614:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:105
}
    8618:	e1a00003 	mov	r0, r3
    861c:	e28bd000 	add	sp, fp, #0
    8620:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8624:	e12fff1e 	bx	lr

00008628 <_Z5sleepjj>:
_Z5sleepjj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8628:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    862c:	e28db000 	add	fp, sp, #0
    8630:	e24dd014 	sub	sp, sp, #20
    8634:	e50b0010 	str	r0, [fp, #-16]
    8638:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    863c:	e51b3010 	ldr	r3, [fp, #-16]
    8640:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8644:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8648:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    864c:	ef000003 	svc	0x00000003
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8650:	e1a03000 	mov	r3, r0
    8654:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8658:	e51b3008 	ldr	r3, [fp, #-8]
    865c:	e3530000 	cmp	r3, #0
    8660:	13a03001 	movne	r3, #1
    8664:	03a03000 	moveq	r3, #0
    8668:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:117
}
    866c:	e1a00003 	mov	r0, r3
    8670:	e28bd000 	add	sp, fp, #0
    8674:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8678:	e12fff1e 	bx	lr

0000867c <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    867c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8680:	e28db000 	add	fp, sp, #0
    8684:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8688:	e3a03000 	mov	r3, #0
    868c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8690:	e3a03000 	mov	r3, #0
    8694:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8698:	e24b300c 	sub	r3, fp, #12
    869c:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86a0:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    86a4:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:129
}
    86a8:	e1a00003 	mov	r0, r3
    86ac:	e28bd000 	add	sp, fp, #0
    86b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b4:	e12fff1e 	bx	lr

000086b8 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    86b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86bc:	e28db000 	add	fp, sp, #0
    86c0:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86c4:	e3a03001 	mov	r3, #1
    86c8:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86cc:	e3a03001 	mov	r3, #1
    86d0:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    86d4:	e24b300c 	sub	r3, fp, #12
    86d8:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86dc:	ef000004 	svc	0x00000004
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    86e0:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:141
}
    86e4:	e1a00003 	mov	r0, r3
    86e8:	e28bd000 	add	sp, fp, #0
    86ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86f0:	e12fff1e 	bx	lr

000086f4 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    86f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86f8:	e28db000 	add	fp, sp, #0
    86fc:	e24dd014 	sub	sp, sp, #20
    8700:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8704:	e3a03000 	mov	r3, #0
    8708:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    870c:	e3a03000 	mov	r3, #0
    8710:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8714:	e24b3010 	sub	r3, fp, #16
    8718:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    871c:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:150
}
    8720:	e320f000 	nop	{0}
    8724:	e28bd000 	add	sp, fp, #0
    8728:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    872c:	e12fff1e 	bx	lr

00008730 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8730:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8734:	e28db000 	add	fp, sp, #0
    8738:	e24dd00c 	sub	sp, sp, #12
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    873c:	e3a03001 	mov	r3, #1
    8740:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8744:	e3a03001 	mov	r3, #1
    8748:	e1a00003 	mov	r0, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    874c:	e24b300c 	sub	r3, fp, #12
    8750:	e1a01003 	mov	r1, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8754:	ef000005 	svc	0x00000005
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8758:	e51b300c 	ldr	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:162
}
    875c:	e1a00003 	mov	r0, r3
    8760:	e28bd000 	add	sp, fp, #0
    8764:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8768:	e12fff1e 	bx	lr

0000876c <_Z4pipePKcj>:
_Z4pipePKcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    876c:	e92d4800 	push	{fp, lr}
    8770:	e28db004 	add	fp, sp, #4
    8774:	e24dd050 	sub	sp, sp, #80	; 0x50
    8778:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    877c:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8780:	e24b3048 	sub	r3, fp, #72	; 0x48
    8784:	e3a0200a 	mov	r2, #10
    8788:	e59f1088 	ldr	r1, [pc, #136]	; 8818 <_Z4pipePKcj+0xac>
    878c:	e1a00003 	mov	r0, r3
    8790:	eb0000a5 	bl	8a2c <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8794:	e24b3048 	sub	r3, fp, #72	; 0x48
    8798:	e283300a 	add	r3, r3, #10
    879c:	e3a02035 	mov	r2, #53	; 0x35
    87a0:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87a4:	e1a00003 	mov	r0, r3
    87a8:	eb00009f 	bl	8a2c <_Z7strncpyPcPKci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87ac:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87b0:	eb0000f8 	bl	8b98 <_Z6strlenPKc>
    87b4:	e1a03000 	mov	r3, r0
    87b8:	e283300a 	add	r3, r3, #10
    87bc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    87c0:	e51b3008 	ldr	r3, [fp, #-8]
    87c4:	e2832001 	add	r2, r3, #1
    87c8:	e50b2008 	str	r2, [fp, #-8]
    87cc:	e24b2004 	sub	r2, fp, #4
    87d0:	e0823003 	add	r3, r2, r3
    87d4:	e3a02023 	mov	r2, #35	; 0x23
    87d8:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87dc:	e24b2048 	sub	r2, fp, #72	; 0x48
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e0823003 	add	r3, r2, r3
    87e8:	e3a0200a 	mov	r2, #10
    87ec:	e1a01003 	mov	r1, r3
    87f0:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87f4:	eb000008 	bl	881c <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    87f8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87fc:	e3a01002 	mov	r1, #2
    8800:	e1a00003 	mov	r0, r3
    8804:	ebffff0a 	bl	8434 <_Z4openPKc15NFile_Open_Mode>
    8808:	e1a03000 	mov	r3, r0
/home/jamesari/git/os/sp/sources/stdlib/src/stdfile.cpp:179
}
    880c:	e1a00003 	mov	r0, r3
    8810:	e24bd004 	sub	sp, fp, #4
    8814:	e8bd8800 	pop	{fp, pc}
    8818:	00009adc 	ldrdeq	r9, [r0], -ip

0000881c <_Z4itoajPcj>:
_Z4itoajPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    881c:	e92d4800 	push	{fp, lr}
    8820:	e28db004 	add	fp, sp, #4
    8824:	e24dd020 	sub	sp, sp, #32
    8828:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    882c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8830:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8834:	e3a03000 	mov	r3, #0
    8838:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    883c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8840:	e3530000 	cmp	r3, #0
    8844:	0a000014 	beq	889c <_Z4itoajPcj+0x80>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8848:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    884c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8850:	e1a00003 	mov	r0, r3
    8854:	eb000462 	bl	99e4 <__aeabi_uidivmod>
    8858:	e1a03001 	mov	r3, r1
    885c:	e1a01003 	mov	r1, r3
    8860:	e51b3008 	ldr	r3, [fp, #-8]
    8864:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8868:	e0823003 	add	r3, r2, r3
    886c:	e59f2118 	ldr	r2, [pc, #280]	; 898c <_Z4itoajPcj+0x170>
    8870:	e7d22001 	ldrb	r2, [r2, r1]
    8874:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8878:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    887c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8880:	eb0003dc 	bl	97f8 <__udivsi3>
    8884:	e1a03000 	mov	r3, r0
    8888:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    888c:	e51b3008 	ldr	r3, [fp, #-8]
    8890:	e2833001 	add	r3, r3, #1
    8894:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8898:	eaffffe7 	b	883c <_Z4itoajPcj+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    889c:	e51b3008 	ldr	r3, [fp, #-8]
    88a0:	e3530000 	cmp	r3, #0
    88a4:	1a000007 	bne	88c8 <_Z4itoajPcj+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    88a8:	e51b3008 	ldr	r3, [fp, #-8]
    88ac:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b0:	e0823003 	add	r3, r2, r3
    88b4:	e3a02030 	mov	r2, #48	; 0x30
    88b8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    88bc:	e51b3008 	ldr	r3, [fp, #-8]
    88c0:	e2833001 	add	r3, r3, #1
    88c4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    88c8:	e51b3008 	ldr	r3, [fp, #-8]
    88cc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88d0:	e0823003 	add	r3, r2, r3
    88d4:	e3a02000 	mov	r2, #0
    88d8:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    88dc:	e51b3008 	ldr	r3, [fp, #-8]
    88e0:	e2433001 	sub	r3, r3, #1
    88e4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    88e8:	e3a03000 	mov	r3, #0
    88ec:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88f0:	e51b3008 	ldr	r3, [fp, #-8]
    88f4:	e1a02fa3 	lsr	r2, r3, #31
    88f8:	e0823003 	add	r3, r2, r3
    88fc:	e1a030c3 	asr	r3, r3, #1
    8900:	e1a02003 	mov	r2, r3
    8904:	e51b300c 	ldr	r3, [fp, #-12]
    8908:	e1530002 	cmp	r3, r2
    890c:	ca00001b 	bgt	8980 <_Z4itoajPcj+0x164>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8910:	e51b2008 	ldr	r2, [fp, #-8]
    8914:	e51b300c 	ldr	r3, [fp, #-12]
    8918:	e0423003 	sub	r3, r2, r3
    891c:	e1a02003 	mov	r2, r3
    8920:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8924:	e0833002 	add	r3, r3, r2
    8928:	e5d33000 	ldrb	r3, [r3]
    892c:	e54b300d 	strb	r3, [fp, #-13]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8930:	e51b300c 	ldr	r3, [fp, #-12]
    8934:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8938:	e0822003 	add	r2, r2, r3
    893c:	e51b1008 	ldr	r1, [fp, #-8]
    8940:	e51b300c 	ldr	r3, [fp, #-12]
    8944:	e0413003 	sub	r3, r1, r3
    8948:	e1a01003 	mov	r1, r3
    894c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8950:	e0833001 	add	r3, r3, r1
    8954:	e5d22000 	ldrb	r2, [r2]
    8958:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    895c:	e51b300c 	ldr	r3, [fp, #-12]
    8960:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8964:	e0823003 	add	r3, r2, r3
    8968:	e55b200d 	ldrb	r2, [fp, #-13]
    896c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8970:	e51b300c 	ldr	r3, [fp, #-12]
    8974:	e2833001 	add	r3, r3, #1
    8978:	e50b300c 	str	r3, [fp, #-12]
    897c:	eaffffdb 	b	88f0 <_Z4itoajPcj+0xd4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8980:	e320f000 	nop	{0}
    8984:	e24bd004 	sub	sp, fp, #4
    8988:	e8bd8800 	pop	{fp, pc}
    898c:	00009aec 	andeq	r9, r0, ip, ror #21

00008990 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8990:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8994:	e28db000 	add	fp, sp, #0
    8998:	e24dd014 	sub	sp, sp, #20
    899c:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    89a0:	e3a03000 	mov	r3, #0
    89a4:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    89a8:	e51b3010 	ldr	r3, [fp, #-16]
    89ac:	e5d33000 	ldrb	r3, [r3]
    89b0:	e3530000 	cmp	r3, #0
    89b4:	0a000017 	beq	8a18 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    89b8:	e51b2008 	ldr	r2, [fp, #-8]
    89bc:	e1a03002 	mov	r3, r2
    89c0:	e1a03103 	lsl	r3, r3, #2
    89c4:	e0833002 	add	r3, r3, r2
    89c8:	e1a03083 	lsl	r3, r3, #1
    89cc:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    89d0:	e51b3010 	ldr	r3, [fp, #-16]
    89d4:	e5d33000 	ldrb	r3, [r3]
    89d8:	e3530039 	cmp	r3, #57	; 0x39
    89dc:	8a00000d 	bhi	8a18 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89e0:	e51b3010 	ldr	r3, [fp, #-16]
    89e4:	e5d33000 	ldrb	r3, [r3]
    89e8:	e353002f 	cmp	r3, #47	; 0x2f
    89ec:	9a000009 	bls	8a18 <_Z4atoiPKc+0x88>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    89f0:	e51b3010 	ldr	r3, [fp, #-16]
    89f4:	e5d33000 	ldrb	r3, [r3]
    89f8:	e2433030 	sub	r3, r3, #48	; 0x30
    89fc:	e51b2008 	ldr	r2, [fp, #-8]
    8a00:	e0823003 	add	r3, r2, r3
    8a04:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a08:	e51b3010 	ldr	r3, [fp, #-16]
    8a0c:	e2833001 	add	r3, r3, #1
    8a10:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a14:	eaffffe3 	b	89a8 <_Z4atoiPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a18:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:52
}
    8a1c:	e1a00003 	mov	r0, r3
    8a20:	e28bd000 	add	sp, fp, #0
    8a24:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a28:	e12fff1e 	bx	lr

00008a2c <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a2c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a30:	e28db000 	add	fp, sp, #0
    8a34:	e24dd01c 	sub	sp, sp, #28
    8a38:	e50b0010 	str	r0, [fp, #-16]
    8a3c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a40:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8a44:	e3a03000 	mov	r3, #0
    8a48:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a4c:	e51b2008 	ldr	r2, [fp, #-8]
    8a50:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a54:	e1520003 	cmp	r2, r3
    8a58:	aa000011 	bge	8aa4 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a5c:	e51b3008 	ldr	r3, [fp, #-8]
    8a60:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a64:	e0823003 	add	r3, r2, r3
    8a68:	e5d33000 	ldrb	r3, [r3]
    8a6c:	e3530000 	cmp	r3, #0
    8a70:	0a00000b 	beq	8aa4 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8a74:	e51b3008 	ldr	r3, [fp, #-8]
    8a78:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a7c:	e0822003 	add	r2, r2, r3
    8a80:	e51b3008 	ldr	r3, [fp, #-8]
    8a84:	e51b1010 	ldr	r1, [fp, #-16]
    8a88:	e0813003 	add	r3, r1, r3
    8a8c:	e5d22000 	ldrb	r2, [r2]
    8a90:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a94:	e51b3008 	ldr	r3, [fp, #-8]
    8a98:	e2833001 	add	r3, r3, #1
    8a9c:	e50b3008 	str	r3, [fp, #-8]
    8aa0:	eaffffe9 	b	8a4c <_Z7strncpyPcPKci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8aa4:	e51b2008 	ldr	r2, [fp, #-8]
    8aa8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8aac:	e1520003 	cmp	r2, r3
    8ab0:	aa000008 	bge	8ad8 <_Z7strncpyPcPKci+0xac>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8ab4:	e51b3008 	ldr	r3, [fp, #-8]
    8ab8:	e51b2010 	ldr	r2, [fp, #-16]
    8abc:	e0823003 	add	r3, r2, r3
    8ac0:	e3a02000 	mov	r2, #0
    8ac4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8ac8:	e51b3008 	ldr	r3, [fp, #-8]
    8acc:	e2833001 	add	r3, r3, #1
    8ad0:	e50b3008 	str	r3, [fp, #-8]
    8ad4:	eafffff2 	b	8aa4 <_Z7strncpyPcPKci+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8ad8:	e51b3010 	ldr	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:64
}
    8adc:	e1a00003 	mov	r0, r3
    8ae0:	e28bd000 	add	sp, fp, #0
    8ae4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ae8:	e12fff1e 	bx	lr

00008aec <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8aec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8af0:	e28db000 	add	fp, sp, #0
    8af4:	e24dd01c 	sub	sp, sp, #28
    8af8:	e50b0010 	str	r0, [fp, #-16]
    8afc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b00:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b04:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b08:	e2432001 	sub	r2, r3, #1
    8b0c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b10:	e3530000 	cmp	r3, #0
    8b14:	c3a03001 	movgt	r3, #1
    8b18:	d3a03000 	movle	r3, #0
    8b1c:	e6ef3073 	uxtb	r3, r3
    8b20:	e3530000 	cmp	r3, #0
    8b24:	0a000016 	beq	8b84 <_Z7strncmpPKcS0_i+0x98>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b28:	e51b3010 	ldr	r3, [fp, #-16]
    8b2c:	e2832001 	add	r2, r3, #1
    8b30:	e50b2010 	str	r2, [fp, #-16]
    8b34:	e5d33000 	ldrb	r3, [r3]
    8b38:	e54b3005 	strb	r3, [fp, #-5]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8b3c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b40:	e2832001 	add	r2, r3, #1
    8b44:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b48:	e5d33000 	ldrb	r3, [r3]
    8b4c:	e54b3006 	strb	r3, [fp, #-6]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8b50:	e55b2005 	ldrb	r2, [fp, #-5]
    8b54:	e55b3006 	ldrb	r3, [fp, #-6]
    8b58:	e1520003 	cmp	r2, r3
    8b5c:	0a000003 	beq	8b70 <_Z7strncmpPKcS0_i+0x84>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8b60:	e55b2005 	ldrb	r2, [fp, #-5]
    8b64:	e55b3006 	ldrb	r3, [fp, #-6]
    8b68:	e0423003 	sub	r3, r2, r3
    8b6c:	ea000005 	b	8b88 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8b70:	e55b3005 	ldrb	r3, [fp, #-5]
    8b74:	e3530000 	cmp	r3, #0
    8b78:	1affffe1 	bne	8b04 <_Z7strncmpPKcS0_i+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b7c:	e3a03000 	mov	r3, #0
    8b80:	ea000000 	b	8b88 <_Z7strncmpPKcS0_i+0x9c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b84:	e3a03000 	mov	r3, #0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:80
}
    8b88:	e1a00003 	mov	r0, r3
    8b8c:	e28bd000 	add	sp, fp, #0
    8b90:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b94:	e12fff1e 	bx	lr

00008b98 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b98:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b9c:	e28db000 	add	fp, sp, #0
    8ba0:	e24dd014 	sub	sp, sp, #20
    8ba4:	e50b0010 	str	r0, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8ba8:	e3a03000 	mov	r3, #0
    8bac:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8bb0:	e51b3008 	ldr	r3, [fp, #-8]
    8bb4:	e51b2010 	ldr	r2, [fp, #-16]
    8bb8:	e0823003 	add	r3, r2, r3
    8bbc:	e5d33000 	ldrb	r3, [r3]
    8bc0:	e3530000 	cmp	r3, #0
    8bc4:	0a000003 	beq	8bd8 <_Z6strlenPKc+0x40>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8bc8:	e51b3008 	ldr	r3, [fp, #-8]
    8bcc:	e2833001 	add	r3, r3, #1
    8bd0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8bd4:	eafffff5 	b	8bb0 <_Z6strlenPKc+0x18>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8bd8:	e51b3008 	ldr	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:90
}
    8bdc:	e1a00003 	mov	r0, r3
    8be0:	e28bd000 	add	sp, fp, #0
    8be4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8be8:	e12fff1e 	bx	lr

00008bec <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8bec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bf0:	e28db000 	add	fp, sp, #0
    8bf4:	e24dd014 	sub	sp, sp, #20
    8bf8:	e50b0010 	str	r0, [fp, #-16]
    8bfc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c00:	e51b3010 	ldr	r3, [fp, #-16]
    8c04:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c08:	e3a03000 	mov	r3, #0
    8c0c:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c10:	e51b2008 	ldr	r2, [fp, #-8]
    8c14:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c18:	e1520003 	cmp	r2, r3
    8c1c:	aa000008 	bge	8c44 <_Z5bzeroPvi+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e51b200c 	ldr	r2, [fp, #-12]
    8c28:	e0823003 	add	r3, r2, r3
    8c2c:	e3a02000 	mov	r2, #0
    8c30:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c34:	e51b3008 	ldr	r3, [fp, #-8]
    8c38:	e2833001 	add	r3, r3, #1
    8c3c:	e50b3008 	str	r3, [fp, #-8]
    8c40:	eafffff2 	b	8c10 <_Z5bzeroPvi+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:98
}
    8c44:	e320f000 	nop	{0}
    8c48:	e28bd000 	add	sp, fp, #0
    8c4c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c50:	e12fff1e 	bx	lr

00008c54 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c54:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c58:	e28db000 	add	fp, sp, #0
    8c5c:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c60:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c64:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c68:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8c6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c70:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8c74:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c78:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c7c:	e3a03000 	mov	r3, #0
    8c80:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c84:	e51b2008 	ldr	r2, [fp, #-8]
    8c88:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c8c:	e1520003 	cmp	r2, r3
    8c90:	aa00000b 	bge	8cc4 <_Z6memcpyPKvPvi+0x70>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c94:	e51b3008 	ldr	r3, [fp, #-8]
    8c98:	e51b200c 	ldr	r2, [fp, #-12]
    8c9c:	e0822003 	add	r2, r2, r3
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	e51b1010 	ldr	r1, [fp, #-16]
    8ca8:	e0813003 	add	r3, r1, r3
    8cac:	e5d22000 	ldrb	r2, [r2]
    8cb0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8cb4:	e51b3008 	ldr	r3, [fp, #-8]
    8cb8:	e2833001 	add	r3, r3, #1
    8cbc:	e50b3008 	str	r3, [fp, #-8]
    8cc0:	eaffffef 	b	8c84 <_Z6memcpyPKvPvi+0x30>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:107
}
    8cc4:	e320f000 	nop	{0}
    8cc8:	e28bd000 	add	sp, fp, #0
    8ccc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cd0:	e12fff1e 	bx	lr

00008cd4 <_Z3powfj>:
_Z3powfj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:110

float pow(const float x, const unsigned int n) 
{
    8cd4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cd8:	e28db000 	add	fp, sp, #0
    8cdc:	e24dd014 	sub	sp, sp, #20
    8ce0:	ed0b0a04 	vstr	s0, [fp, #-16]
    8ce4:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:111
    float r = 1.0f;
    8ce8:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    8cec:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112
    for(unsigned int i=0; i<n; i++) {
    8cf0:	e3a03000 	mov	r3, #0
    8cf4:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 3)
    8cf8:	e51b200c 	ldr	r2, [fp, #-12]
    8cfc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d00:	e1520003 	cmp	r2, r3
    8d04:	2a000007 	bcs	8d28 <_Z3powfj+0x54>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:113 (discriminator 2)
        r *= x;
    8d08:	ed1b7a02 	vldr	s14, [fp, #-8]
    8d0c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8d10:	ee677a27 	vmul.f32	s15, s14, s15
    8d14:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:112 (discriminator 2)
    for(unsigned int i=0; i<n; i++) {
    8d18:	e51b300c 	ldr	r3, [fp, #-12]
    8d1c:	e2833001 	add	r3, r3, #1
    8d20:	e50b300c 	str	r3, [fp, #-12]
    8d24:	eafffff3 	b	8cf8 <_Z3powfj+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:115
    }
    return r;
    8d28:	e51b3008 	ldr	r3, [fp, #-8]
    8d2c:	ee073a90 	vmov	s15, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:116
}
    8d30:	eeb00a67 	vmov.f32	s0, s15
    8d34:	e28bd000 	add	sp, fp, #0
    8d38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d3c:	e12fff1e 	bx	lr

00008d40 <_Z6revstrPc>:
_Z6revstrPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:119

void revstr(char *str1)  
{  
    8d40:	e92d4800 	push	{fp, lr}
    8d44:	e28db004 	add	fp, sp, #4
    8d48:	e24dd018 	sub	sp, sp, #24
    8d4c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:121
    int i, len, temp;  
    len = strlen(str1);
    8d50:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8d54:	ebffff8f 	bl	8b98 <_Z6strlenPKc>
    8d58:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123
      
    for (i = 0; i < len/2; i++)  
    8d5c:	e3a03000 	mov	r3, #0
    8d60:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8d64:	e51b300c 	ldr	r3, [fp, #-12]
    8d68:	e1a02fa3 	lsr	r2, r3, #31
    8d6c:	e0823003 	add	r3, r2, r3
    8d70:	e1a030c3 	asr	r3, r3, #1
    8d74:	e1a02003 	mov	r2, r3
    8d78:	e51b3008 	ldr	r3, [fp, #-8]
    8d7c:	e1530002 	cmp	r3, r2
    8d80:	aa00001c 	bge	8df8 <_Z6revstrPc+0xb8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
    {  
        temp = str1[i];  
    8d84:	e51b3008 	ldr	r3, [fp, #-8]
    8d88:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8d8c:	e0823003 	add	r3, r2, r3
    8d90:	e5d33000 	ldrb	r3, [r3]
    8d94:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        str1[i] = str1[len - i - 1];  
    8d98:	e51b200c 	ldr	r2, [fp, #-12]
    8d9c:	e51b3008 	ldr	r3, [fp, #-8]
    8da0:	e0423003 	sub	r3, r2, r3
    8da4:	e2433001 	sub	r3, r3, #1
    8da8:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8dac:	e0822003 	add	r2, r2, r3
    8db0:	e51b3008 	ldr	r3, [fp, #-8]
    8db4:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    8db8:	e0813003 	add	r3, r1, r3
    8dbc:	e5d22000 	ldrb	r2, [r2]
    8dc0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:127 (discriminator 2)
        str1[len - i - 1] = temp;  
    8dc4:	e51b200c 	ldr	r2, [fp, #-12]
    8dc8:	e51b3008 	ldr	r3, [fp, #-8]
    8dcc:	e0423003 	sub	r3, r2, r3
    8dd0:	e2433001 	sub	r3, r3, #1
    8dd4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8dd8:	e0823003 	add	r3, r2, r3
    8ddc:	e51b2010 	ldr	r2, [fp, #-16]
    8de0:	e6ef2072 	uxtb	r2, r2
    8de4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (i = 0; i < len/2; i++)  
    8de8:	e51b3008 	ldr	r3, [fp, #-8]
    8dec:	e2833001 	add	r3, r3, #1
    8df0:	e50b3008 	str	r3, [fp, #-8]
    8df4:	eaffffda 	b	8d64 <_Z6revstrPc+0x24>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:129
    }  
}  
    8df8:	e320f000 	nop	{0}
    8dfc:	e24bd004 	sub	sp, fp, #4
    8e00:	e8bd8800 	pop	{fp, pc}

00008e04 <_Z11split_floatfRjS_Ri>:
_Z11split_floatfRjS_Ri():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:132

void split_float(float x, unsigned int& integral, unsigned int& decimal, int& exponent) 
{
    8e04:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e08:	e28db000 	add	fp, sp, #0
    8e0c:	e24dd01c 	sub	sp, sp, #28
    8e10:	ed0b0a04 	vstr	s0, [fp, #-16]
    8e14:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
    8e18:	e50b1018 	str	r1, [fp, #-24]	; 0xffffffe8
    8e1c:	e50b201c 	str	r2, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:133
    if(x>=10.0f) { // convert to base 10
    8e20:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e24:	ed9f7af3 	vldr	s14, [pc, #972]	; 91f8 <_Z11split_floatfRjS_Ri+0x3f4>
    8e28:	eef47ac7 	vcmpe.f32	s15, s14
    8e2c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e30:	ba000053 	blt	8f84 <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134
        if(x>=1E32f) { x *= 1E-32f; exponent += 32; }
    8e34:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e38:	ed9f7aef 	vldr	s14, [pc, #956]	; 91fc <_Z11split_floatfRjS_Ri+0x3f8>
    8e3c:	eef47ac7 	vcmpe.f32	s15, s14
    8e40:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e44:	ba000008 	blt	8e6c <_Z11split_floatfRjS_Ri+0x68>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:134 (discriminator 1)
    8e48:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e4c:	ed9f7aeb 	vldr	s14, [pc, #940]	; 9200 <_Z11split_floatfRjS_Ri+0x3fc>
    8e50:	ee677a87 	vmul.f32	s15, s15, s14
    8e54:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e58:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e5c:	e5933000 	ldr	r3, [r3]
    8e60:	e2832020 	add	r2, r3, #32
    8e64:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e68:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135
        if(x>=1E16f) { x *= 1E-16f; exponent += 16; }
    8e6c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e70:	ed9f7ae3 	vldr	s14, [pc, #908]	; 9204 <_Z11split_floatfRjS_Ri+0x400>
    8e74:	eef47ac7 	vcmpe.f32	s15, s14
    8e78:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8e7c:	ba000008 	blt	8ea4 <_Z11split_floatfRjS_Ri+0xa0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8e80:	ed5b7a04 	vldr	s15, [fp, #-16]
    8e84:	ed9f7adf 	vldr	s14, [pc, #892]	; 9208 <_Z11split_floatfRjS_Ri+0x404>
    8e88:	ee677a87 	vmul.f32	s15, s15, s14
    8e8c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8e90:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e94:	e5933000 	ldr	r3, [r3]
    8e98:	e2832010 	add	r2, r3, #16
    8e9c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ea0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136
        if(x>= 1E8f) { x *=  1E-8f; exponent +=  8; }
    8ea4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ea8:	ed9f7ad7 	vldr	s14, [pc, #860]	; 920c <_Z11split_floatfRjS_Ri+0x408>
    8eac:	eef47ac7 	vcmpe.f32	s15, s14
    8eb0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8eb4:	ba000008 	blt	8edc <_Z11split_floatfRjS_Ri+0xd8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:136 (discriminator 1)
    8eb8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ebc:	ed9f7ad3 	vldr	s14, [pc, #844]	; 9210 <_Z11split_floatfRjS_Ri+0x40c>
    8ec0:	ee677a87 	vmul.f32	s15, s15, s14
    8ec4:	ed4b7a04 	vstr	s15, [fp, #-16]
    8ec8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ecc:	e5933000 	ldr	r3, [r3]
    8ed0:	e2832008 	add	r2, r3, #8
    8ed4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8ed8:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137
        if(x>= 1E4f) { x *=  1E-4f; exponent +=  4; }
    8edc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ee0:	ed9f7acb 	vldr	s14, [pc, #812]	; 9214 <_Z11split_floatfRjS_Ri+0x410>
    8ee4:	eef47ac7 	vcmpe.f32	s15, s14
    8ee8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8eec:	ba000008 	blt	8f14 <_Z11split_floatfRjS_Ri+0x110>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:137 (discriminator 1)
    8ef0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ef4:	ed9f7ac7 	vldr	s14, [pc, #796]	; 9218 <_Z11split_floatfRjS_Ri+0x414>
    8ef8:	ee677a87 	vmul.f32	s15, s15, s14
    8efc:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f00:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f04:	e5933000 	ldr	r3, [r3]
    8f08:	e2832004 	add	r2, r3, #4
    8f0c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f10:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138
        if(x>= 1E2f) { x *=  1E-2f; exponent +=  2; }
    8f14:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f18:	ed9f7abf 	vldr	s14, [pc, #764]	; 921c <_Z11split_floatfRjS_Ri+0x418>
    8f1c:	eef47ac7 	vcmpe.f32	s15, s14
    8f20:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f24:	ba000008 	blt	8f4c <_Z11split_floatfRjS_Ri+0x148>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:138 (discriminator 1)
    8f28:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f2c:	ed9f7abb 	vldr	s14, [pc, #748]	; 9220 <_Z11split_floatfRjS_Ri+0x41c>
    8f30:	ee677a87 	vmul.f32	s15, s15, s14
    8f34:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f38:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f3c:	e5933000 	ldr	r3, [r3]
    8f40:	e2832002 	add	r2, r3, #2
    8f44:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f48:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139
        if(x>= 1E1f) { x *=  1E-1f; exponent +=  1; }
    8f4c:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f50:	ed9f7aa8 	vldr	s14, [pc, #672]	; 91f8 <_Z11split_floatfRjS_Ri+0x3f4>
    8f54:	eef47ac7 	vcmpe.f32	s15, s14
    8f58:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f5c:	ba000008 	blt	8f84 <_Z11split_floatfRjS_Ri+0x180>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:139 (discriminator 1)
    8f60:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f64:	ed9f7aae 	vldr	s14, [pc, #696]	; 9224 <_Z11split_floatfRjS_Ri+0x420>
    8f68:	ee677a87 	vmul.f32	s15, s15, s14
    8f6c:	ed4b7a04 	vstr	s15, [fp, #-16]
    8f70:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f74:	e5933000 	ldr	r3, [r3]
    8f78:	e2832001 	add	r2, r3, #1
    8f7c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8f80:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141
    }
    if(x>0.0f && x<=1.0f) {
    8f84:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f88:	eef57ac0 	vcmpe.f32	s15, #0.0
    8f8c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8f90:	da000058 	ble	90f8 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:141 (discriminator 1)
    8f94:	ed5b7a04 	vldr	s15, [fp, #-16]
    8f98:	ed9f7aa2 	vldr	s14, [pc, #648]	; 9228 <_Z11split_floatfRjS_Ri+0x424>
    8f9c:	eef47ac7 	vcmpe.f32	s15, s14
    8fa0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fa4:	8a000053 	bhi	90f8 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142
        if(x<1E-31f) { x *=  1E32f; exponent -= 32; }
    8fa8:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fac:	ed9f7a9e 	vldr	s14, [pc, #632]	; 922c <_Z11split_floatfRjS_Ri+0x428>
    8fb0:	eef47ac7 	vcmpe.f32	s15, s14
    8fb4:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8fb8:	5a000008 	bpl	8fe0 <_Z11split_floatfRjS_Ri+0x1dc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:142 (discriminator 1)
    8fbc:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fc0:	ed9f7a8d 	vldr	s14, [pc, #564]	; 91fc <_Z11split_floatfRjS_Ri+0x3f8>
    8fc4:	ee677a87 	vmul.f32	s15, s15, s14
    8fc8:	ed4b7a04 	vstr	s15, [fp, #-16]
    8fcc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fd0:	e5933000 	ldr	r3, [r3]
    8fd4:	e2432020 	sub	r2, r3, #32
    8fd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8fdc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143
        if(x<1E-15f) { x *=  1E16f; exponent -= 16; }
    8fe0:	ed5b7a04 	vldr	s15, [fp, #-16]
    8fe4:	ed9f7a91 	vldr	s14, [pc, #580]	; 9230 <_Z11split_floatfRjS_Ri+0x42c>
    8fe8:	eef47ac7 	vcmpe.f32	s15, s14
    8fec:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8ff0:	5a000008 	bpl	9018 <_Z11split_floatfRjS_Ri+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:143 (discriminator 1)
    8ff4:	ed5b7a04 	vldr	s15, [fp, #-16]
    8ff8:	ed9f7a81 	vldr	s14, [pc, #516]	; 9204 <_Z11split_floatfRjS_Ri+0x400>
    8ffc:	ee677a87 	vmul.f32	s15, s15, s14
    9000:	ed4b7a04 	vstr	s15, [fp, #-16]
    9004:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9008:	e5933000 	ldr	r3, [r3]
    900c:	e2432010 	sub	r2, r3, #16
    9010:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9014:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144
        if(x< 1E-7f) { x *=   1E8f; exponent -=  8; }
    9018:	ed5b7a04 	vldr	s15, [fp, #-16]
    901c:	ed9f7a84 	vldr	s14, [pc, #528]	; 9234 <_Z11split_floatfRjS_Ri+0x430>
    9020:	eef47ac7 	vcmpe.f32	s15, s14
    9024:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9028:	5a000008 	bpl	9050 <_Z11split_floatfRjS_Ri+0x24c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:144 (discriminator 1)
    902c:	ed5b7a04 	vldr	s15, [fp, #-16]
    9030:	ed9f7a75 	vldr	s14, [pc, #468]	; 920c <_Z11split_floatfRjS_Ri+0x408>
    9034:	ee677a87 	vmul.f32	s15, s15, s14
    9038:	ed4b7a04 	vstr	s15, [fp, #-16]
    903c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9040:	e5933000 	ldr	r3, [r3]
    9044:	e2432008 	sub	r2, r3, #8
    9048:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    904c:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145
        if(x< 1E-3f) { x *=   1E4f; exponent -=  4; }
    9050:	ed5b7a04 	vldr	s15, [fp, #-16]
    9054:	ed9f7a77 	vldr	s14, [pc, #476]	; 9238 <_Z11split_floatfRjS_Ri+0x434>
    9058:	eef47ac7 	vcmpe.f32	s15, s14
    905c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9060:	5a000008 	bpl	9088 <_Z11split_floatfRjS_Ri+0x284>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:145 (discriminator 1)
    9064:	ed5b7a04 	vldr	s15, [fp, #-16]
    9068:	ed9f7a69 	vldr	s14, [pc, #420]	; 9214 <_Z11split_floatfRjS_Ri+0x410>
    906c:	ee677a87 	vmul.f32	s15, s15, s14
    9070:	ed4b7a04 	vstr	s15, [fp, #-16]
    9074:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9078:	e5933000 	ldr	r3, [r3]
    907c:	e2432004 	sub	r2, r3, #4
    9080:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9084:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146
        if(x< 1E-1f) { x *=   1E2f; exponent -=  2; }
    9088:	ed5b7a04 	vldr	s15, [fp, #-16]
    908c:	ed9f7a64 	vldr	s14, [pc, #400]	; 9224 <_Z11split_floatfRjS_Ri+0x420>
    9090:	eef47ac7 	vcmpe.f32	s15, s14
    9094:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9098:	5a000008 	bpl	90c0 <_Z11split_floatfRjS_Ri+0x2bc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    909c:	ed5b7a04 	vldr	s15, [fp, #-16]
    90a0:	ed9f7a5d 	vldr	s14, [pc, #372]	; 921c <_Z11split_floatfRjS_Ri+0x418>
    90a4:	ee677a87 	vmul.f32	s15, s15, s14
    90a8:	ed4b7a04 	vstr	s15, [fp, #-16]
    90ac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90b0:	e5933000 	ldr	r3, [r3]
    90b4:	e2432002 	sub	r2, r3, #2
    90b8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90bc:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147
        if(x<  1E0f) { x *=   1E1f; exponent -=  1; }
    90c0:	ed5b7a04 	vldr	s15, [fp, #-16]
    90c4:	ed9f7a57 	vldr	s14, [pc, #348]	; 9228 <_Z11split_floatfRjS_Ri+0x424>
    90c8:	eef47ac7 	vcmpe.f32	s15, s14
    90cc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    90d0:	5a000008 	bpl	90f8 <_Z11split_floatfRjS_Ri+0x2f4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:147 (discriminator 1)
    90d4:	ed5b7a04 	vldr	s15, [fp, #-16]
    90d8:	ed9f7a46 	vldr	s14, [pc, #280]	; 91f8 <_Z11split_floatfRjS_Ri+0x3f4>
    90dc:	ee677a87 	vmul.f32	s15, s15, s14
    90e0:	ed4b7a04 	vstr	s15, [fp, #-16]
    90e4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90e8:	e5933000 	ldr	r3, [r3]
    90ec:	e2432001 	sub	r2, r3, #1
    90f0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    90f4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:149
    }
    integral = (unsigned int)x;
    90f8:	ed5b7a04 	vldr	s15, [fp, #-16]
    90fc:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9100:	ee172a90 	vmov	r2, s15
    9104:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9108:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:150
    float remainder = (x-integral)*1E8f; // 8 decimal digits
    910c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9110:	e5933000 	ldr	r3, [r3]
    9114:	ee073a90 	vmov	s15, r3
    9118:	eef87a67 	vcvt.f32.u32	s15, s15
    911c:	ed1b7a04 	vldr	s14, [fp, #-16]
    9120:	ee777a67 	vsub.f32	s15, s14, s15
    9124:	ed9f7a38 	vldr	s14, [pc, #224]	; 920c <_Z11split_floatfRjS_Ri+0x408>
    9128:	ee677a87 	vmul.f32	s15, s15, s14
    912c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:151
    decimal = (unsigned int)remainder;
    9130:	ed5b7a02 	vldr	s15, [fp, #-8]
    9134:	eefc7ae7 	vcvt.u32.f32	s15, s15
    9138:	ee172a90 	vmov	r2, s15
    913c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9140:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:152
    if(remainder-(float)decimal>=0.5f) { // correct rounding of last decimal digit
    9144:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9148:	e5933000 	ldr	r3, [r3]
    914c:	ee073a90 	vmov	s15, r3
    9150:	eef87a67 	vcvt.f32.u32	s15, s15
    9154:	ed1b7a02 	vldr	s14, [fp, #-8]
    9158:	ee777a67 	vsub.f32	s15, s14, s15
    915c:	ed9f7a36 	vldr	s14, [pc, #216]	; 923c <_Z11split_floatfRjS_Ri+0x438>
    9160:	eef47ac7 	vcmpe.f32	s15, s14
    9164:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9168:	aa000000 	bge	9170 <_Z11split_floatfRjS_Ri+0x36c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
                integral = 1;
                exponent++;
            }
        }
    }
}
    916c:	ea00001d 	b	91e8 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:153
        decimal++;
    9170:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9174:	e5933000 	ldr	r3, [r3]
    9178:	e2832001 	add	r2, r3, #1
    917c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9180:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:154
        if(decimal>=100000000u) { // decimal overflow
    9184:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9188:	e5933000 	ldr	r3, [r3]
    918c:	e59f20ac 	ldr	r2, [pc, #172]	; 9240 <_Z11split_floatfRjS_Ri+0x43c>
    9190:	e1530002 	cmp	r3, r2
    9194:	9a000013 	bls	91e8 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:155
            decimal = 0;
    9198:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    919c:	e3a02000 	mov	r2, #0
    91a0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:156
            integral++;
    91a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91a8:	e5933000 	ldr	r3, [r3]
    91ac:	e2832001 	add	r2, r3, #1
    91b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91b4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:157
            if(integral>=10u) { // decimal overflow causes integral overflow
    91b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91bc:	e5933000 	ldr	r3, [r3]
    91c0:	e3530009 	cmp	r3, #9
    91c4:	9a000007 	bls	91e8 <_Z11split_floatfRjS_Ri+0x3e4>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:158
                integral = 1;
    91c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91cc:	e3a02001 	mov	r2, #1
    91d0:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:159
                exponent++;
    91d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91d8:	e5933000 	ldr	r3, [r3]
    91dc:	e2832001 	add	r2, r3, #1
    91e0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91e4:	e5832000 	str	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:163
}
    91e8:	e320f000 	nop	{0}
    91ec:	e28bd000 	add	sp, fp, #0
    91f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91f4:	e12fff1e 	bx	lr
    91f8:	41200000 			; <UNDEFINED> instruction: 0x41200000
    91fc:	749dc5ae 	ldrvc	ip, [sp], #1454	; 0x5ae
    9200:	0a4fb11f 	beq	13f5684 <__bss_end+0x13ebb74>
    9204:	5a0e1bca 	bpl	390134 <__bss_end+0x386624>
    9208:	24e69595 	strbtcs	r9, [r6], #1429	; 0x595
    920c:	4cbebc20 	ldcmi	12, cr11, [lr], #128	; 0x80
    9210:	322bcc77 	eorcc	ip, fp, #30464	; 0x7700
    9214:	461c4000 	ldrmi	r4, [ip], -r0
    9218:	38d1b717 	ldmcc	r1, {r0, r1, r2, r4, r8, r9, sl, ip, sp, pc}^
    921c:	42c80000 	sbcmi	r0, r8, #0
    9220:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
    9224:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
    9228:	3f800000 	svccc	0x00800000
    922c:	0c01ceb3 	stceq	14, cr12, [r1], {179}	; 0xb3
    9230:	26901d7d 			; <UNDEFINED> instruction: 0x26901d7d
    9234:	33d6bf95 	bicscc	fp, r6, #596	; 0x254
    9238:	3a83126f 	bcc	fe0cdbfc <__bss_end+0xfe0c40ec>
    923c:	3f000000 	svccc	0x00000000
    9240:	05f5e0ff 	ldrbeq	lr, [r5, #255]!	; 0xff

00009244 <_Z23decimal_to_string_floatjPci>:
_Z23decimal_to_string_floatjPci():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:166

void decimal_to_string_float(unsigned int x, char *bfr, int digits) 
{
    9244:	e92d4800 	push	{fp, lr}
    9248:	e28db004 	add	fp, sp, #4
    924c:	e24dd018 	sub	sp, sp, #24
    9250:	e50b0010 	str	r0, [fp, #-16]
    9254:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9258:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:167
	int index = 0;
    925c:	e3a03000 	mov	r3, #0
    9260:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    9264:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9268:	e2432001 	sub	r2, r3, #1
    926c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    9270:	e3530000 	cmp	r3, #0
    9274:	c3a03001 	movgt	r3, #1
    9278:	d3a03000 	movle	r3, #0
    927c:	e6ef3073 	uxtb	r3, r3
    9280:	e3530000 	cmp	r3, #0
    9284:	0a000018 	beq	92ec <_Z23decimal_to_string_floatjPci+0xa8>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:169
        bfr[index++] = (char)(x%10+48);
    9288:	e51b1010 	ldr	r1, [fp, #-16]
    928c:	e59f3080 	ldr	r3, [pc, #128]	; 9314 <_Z23decimal_to_string_floatjPci+0xd0>
    9290:	e0832193 	umull	r2, r3, r3, r1
    9294:	e1a021a3 	lsr	r2, r3, #3
    9298:	e1a03002 	mov	r3, r2
    929c:	e1a03103 	lsl	r3, r3, #2
    92a0:	e0833002 	add	r3, r3, r2
    92a4:	e1a03083 	lsl	r3, r3, #1
    92a8:	e0412003 	sub	r2, r1, r3
    92ac:	e6ef2072 	uxtb	r2, r2
    92b0:	e51b3008 	ldr	r3, [fp, #-8]
    92b4:	e2831001 	add	r1, r3, #1
    92b8:	e50b1008 	str	r1, [fp, #-8]
    92bc:	e1a01003 	mov	r1, r3
    92c0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    92c4:	e0833001 	add	r3, r3, r1
    92c8:	e2822030 	add	r2, r2, #48	; 0x30
    92cc:	e6ef2072 	uxtb	r2, r2
    92d0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:170
        x /= 10;
    92d4:	e51b3010 	ldr	r3, [fp, #-16]
    92d8:	e59f2034 	ldr	r2, [pc, #52]	; 9314 <_Z23decimal_to_string_floatjPci+0xd0>
    92dc:	e0832392 	umull	r2, r3, r2, r3
    92e0:	e1a031a3 	lsr	r3, r3, #3
    92e4:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:168
    while((digits--)>0) {
    92e8:	eaffffdd 	b	9264 <_Z23decimal_to_string_floatjPci+0x20>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:172
    }
	bfr[index] = '\0';
    92ec:	e51b3008 	ldr	r3, [fp, #-8]
    92f0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    92f4:	e0823003 	add	r3, r2, r3
    92f8:	e3a02000 	mov	r2, #0
    92fc:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:173
	revstr(bfr);
    9300:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    9304:	ebfffe8d 	bl	8d40 <_Z6revstrPc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:174
}
    9308:	e320f000 	nop	{0}
    930c:	e24bd004 	sub	sp, fp, #4
    9310:	e8bd8800 	pop	{fp, pc}
    9314:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

00009318 <_Z5isnanf>:
_Z5isnanf():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:177

bool isnan(float x) 
{
    9318:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    931c:	e28db000 	add	fp, sp, #0
    9320:	e24dd00c 	sub	sp, sp, #12
    9324:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:178
	return x != x;
    9328:	ed1b7a02 	vldr	s14, [fp, #-8]
    932c:	ed5b7a02 	vldr	s15, [fp, #-8]
    9330:	eeb47a67 	vcmp.f32	s14, s15
    9334:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9338:	13a03001 	movne	r3, #1
    933c:	03a03000 	moveq	r3, #0
    9340:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:179
}
    9344:	e1a00003 	mov	r0, r3
    9348:	e28bd000 	add	sp, fp, #0
    934c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9350:	e12fff1e 	bx	lr

00009354 <_Z5isinff>:
_Z5isinff():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:182

bool isinf(float x) 
{
    9354:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9358:	e28db000 	add	fp, sp, #0
    935c:	e24dd00c 	sub	sp, sp, #12
    9360:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:183
	return x > INFINITY;
    9364:	ed5b7a02 	vldr	s15, [fp, #-8]
    9368:	ed9f7a08 	vldr	s14, [pc, #32]	; 9390 <_Z5isinff+0x3c>
    936c:	eef47ac7 	vcmpe.f32	s15, s14
    9370:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9374:	c3a03001 	movgt	r3, #1
    9378:	d3a03000 	movle	r3, #0
    937c:	e6ef3073 	uxtb	r3, r3
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:184
}
    9380:	e1a00003 	mov	r0, r3
    9384:	e28bd000 	add	sp, fp, #0
    9388:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    938c:	e12fff1e 	bx	lr
    9390:	7f7fffff 	svcvc	0x007fffff

00009394 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:188

// convert float to string with full precision
void ftoa(float x, char *bfr) 
{
    9394:	e92d4800 	push	{fp, lr}
    9398:	e28db004 	add	fp, sp, #4
    939c:	e24dd008 	sub	sp, sp, #8
    93a0:	ed0b0a02 	vstr	s0, [fp, #-8]
    93a4:	e50b000c 	str	r0, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:189
	ftoa(x, bfr, 8);
    93a8:	e3a01008 	mov	r1, #8
    93ac:	e51b000c 	ldr	r0, [fp, #-12]
    93b0:	ed1b0a02 	vldr	s0, [fp, #-8]
    93b4:	eb000002 	bl	93c4 <_Z4ftoafPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:190
}
    93b8:	e320f000 	nop	{0}
    93bc:	e24bd004 	sub	sp, fp, #4
    93c0:	e8bd8800 	pop	{fp, pc}

000093c4 <_Z4ftoafPcj>:
_Z4ftoafPcj():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:194

// convert float to string with specified number of decimals
void ftoa(float x, char *bfr, const unsigned int decimals)
{ 
    93c4:	e92d4800 	push	{fp, lr}
    93c8:	e28db004 	add	fp, sp, #4
    93cc:	e24dd060 	sub	sp, sp, #96	; 0x60
    93d0:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    93d4:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
    93d8:	e50b1060 	str	r1, [fp, #-96]	; 0xffffffa0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:195
	unsigned int index = 0;
    93dc:	e3a03000 	mov	r3, #0
    93e0:	e50b3008 	str	r3, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:196
    if (x<0.0f) 
    93e4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    93e8:	eef57ac0 	vcmpe.f32	s15, #0.0
    93ec:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    93f0:	5a000009 	bpl	941c <_Z4ftoafPcj+0x58>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:198
	{ 
		bfr[index++] = '-';
    93f4:	e51b3008 	ldr	r3, [fp, #-8]
    93f8:	e2832001 	add	r2, r3, #1
    93fc:	e50b2008 	str	r2, [fp, #-8]
    9400:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9404:	e0823003 	add	r3, r2, r3
    9408:	e3a0202d 	mov	r2, #45	; 0x2d
    940c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:199
		x = -x;
    9410:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9414:	eef17a67 	vneg.f32	s15, s15
    9418:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:201
	}
    if(isnan(x)) 
    941c:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    9420:	ebffffbc 	bl	9318 <_Z5isnanf>
    9424:	e1a03000 	mov	r3, r0
    9428:	e3530000 	cmp	r3, #0
    942c:	0a00001c 	beq	94a4 <_Z4ftoafPcj+0xe0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:203
	{
		bfr[index++] = 'N';
    9430:	e51b3008 	ldr	r3, [fp, #-8]
    9434:	e2832001 	add	r2, r3, #1
    9438:	e50b2008 	str	r2, [fp, #-8]
    943c:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9440:	e0823003 	add	r3, r2, r3
    9444:	e3a0204e 	mov	r2, #78	; 0x4e
    9448:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:204
		bfr[index++] = 'a';
    944c:	e51b3008 	ldr	r3, [fp, #-8]
    9450:	e2832001 	add	r2, r3, #1
    9454:	e50b2008 	str	r2, [fp, #-8]
    9458:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    945c:	e0823003 	add	r3, r2, r3
    9460:	e3a02061 	mov	r2, #97	; 0x61
    9464:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:205
		bfr[index++] = 'N';
    9468:	e51b3008 	ldr	r3, [fp, #-8]
    946c:	e2832001 	add	r2, r3, #1
    9470:	e50b2008 	str	r2, [fp, #-8]
    9474:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9478:	e0823003 	add	r3, r2, r3
    947c:	e3a0204e 	mov	r2, #78	; 0x4e
    9480:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:206
		bfr[index++] = '\0';
    9484:	e51b3008 	ldr	r3, [fp, #-8]
    9488:	e2832001 	add	r2, r3, #1
    948c:	e50b2008 	str	r2, [fp, #-8]
    9490:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9494:	e0823003 	add	r3, r2, r3
    9498:	e3a02000 	mov	r2, #0
    949c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:207
		return;
    94a0:	ea00008c 	b	96d8 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:209
	}
    if(isinf(x)) 
    94a4:	ed1b0a16 	vldr	s0, [fp, #-88]	; 0xffffffa8
    94a8:	ebffffa9 	bl	9354 <_Z5isinff>
    94ac:	e1a03000 	mov	r3, r0
    94b0:	e3530000 	cmp	r3, #0
    94b4:	0a00001c 	beq	952c <_Z4ftoafPcj+0x168>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:211
	{
		bfr[index++] = 'I';
    94b8:	e51b3008 	ldr	r3, [fp, #-8]
    94bc:	e2832001 	add	r2, r3, #1
    94c0:	e50b2008 	str	r2, [fp, #-8]
    94c4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94c8:	e0823003 	add	r3, r2, r3
    94cc:	e3a02049 	mov	r2, #73	; 0x49
    94d0:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:212
		bfr[index++] = 'n';
    94d4:	e51b3008 	ldr	r3, [fp, #-8]
    94d8:	e2832001 	add	r2, r3, #1
    94dc:	e50b2008 	str	r2, [fp, #-8]
    94e0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    94e4:	e0823003 	add	r3, r2, r3
    94e8:	e3a0206e 	mov	r2, #110	; 0x6e
    94ec:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:213
		bfr[index++] = 'f';
    94f0:	e51b3008 	ldr	r3, [fp, #-8]
    94f4:	e2832001 	add	r2, r3, #1
    94f8:	e50b2008 	str	r2, [fp, #-8]
    94fc:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9500:	e0823003 	add	r3, r2, r3
    9504:	e3a02066 	mov	r2, #102	; 0x66
    9508:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:214
		bfr[index++] = '\0';
    950c:	e51b3008 	ldr	r3, [fp, #-8]
    9510:	e2832001 	add	r2, r3, #1
    9514:	e50b2008 	str	r2, [fp, #-8]
    9518:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    951c:	e0823003 	add	r3, r2, r3
    9520:	e3a02000 	mov	r2, #0
    9524:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:215
		return;
    9528:	ea00006a 	b	96d8 <_Z4ftoafPcj+0x314>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:217
	}
	int precision = 8;
    952c:	e3a03008 	mov	r3, #8
    9530:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:218
	if (decimals < 8 && decimals >= 0)
    9534:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9538:	e3530007 	cmp	r3, #7
    953c:	8a000001 	bhi	9548 <_Z4ftoafPcj+0x184>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:219
		precision = decimals;
    9540:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9544:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:221

    const float power = pow(10.0f, precision);
    9548:	e51b300c 	ldr	r3, [fp, #-12]
    954c:	e1a00003 	mov	r0, r3
    9550:	ed9f0a62 	vldr	s0, [pc, #392]	; 96e0 <_Z4ftoafPcj+0x31c>
    9554:	ebfffdde 	bl	8cd4 <_Z3powfj>
    9558:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:222
    x += 0.5f/power; // rounding
    955c:	eddf6a60 	vldr	s13, [pc, #384]	; 96e4 <_Z4ftoafPcj+0x320>
    9560:	ed1b7a06 	vldr	s14, [fp, #-24]	; 0xffffffe8
    9564:	eec67a87 	vdiv.f32	s15, s13, s14
    9568:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    956c:	ee777a27 	vadd.f32	s15, s14, s15
    9570:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:224
	// unsigned long long ?
    const unsigned int integral = (unsigned int)x;
    9574:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    9578:	eefc7ae7 	vcvt.u32.f32	s15, s15
    957c:	ee173a90 	vmov	r3, s15
    9580:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:225
    const unsigned int decimal = (unsigned int)((x-(float)integral)*power);
    9584:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9588:	ee073a90 	vmov	s15, r3
    958c:	eef87a67 	vcvt.f32.u32	s15, s15
    9590:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    9594:	ee377a67 	vsub.f32	s14, s14, s15
    9598:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    959c:	ee677a27 	vmul.f32	s15, s14, s15
    95a0:	eefc7ae7 	vcvt.u32.f32	s15, s15
    95a4:	ee173a90 	vmov	r3, s15
    95a8:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:228

	char string_int[32];
	itoa(integral, string_int, 10);
    95ac:	e24b3044 	sub	r3, fp, #68	; 0x44
    95b0:	e3a0200a 	mov	r2, #10
    95b4:	e1a01003 	mov	r1, r3
    95b8:	e51b001c 	ldr	r0, [fp, #-28]	; 0xffffffe4
    95bc:	ebfffc96 	bl	881c <_Z4itoajPcj>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:229
	int string_int_len = strlen(string_int);
    95c0:	e24b3044 	sub	r3, fp, #68	; 0x44
    95c4:	e1a00003 	mov	r0, r3
    95c8:	ebfffd72 	bl	8b98 <_Z6strlenPKc>
    95cc:	e50b0024 	str	r0, [fp, #-36]	; 0xffffffdc
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231

	for (int i = 0; i < string_int_len; i++)
    95d0:	e3a03000 	mov	r3, #0
    95d4:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 3)
    95d8:	e51b2010 	ldr	r2, [fp, #-16]
    95dc:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    95e0:	e1520003 	cmp	r2, r3
    95e4:	aa00000d 	bge	9620 <_Z4ftoafPcj+0x25c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:233 (discriminator 2)
	{
		bfr[index++] = string_int[i];
    95e8:	e51b3008 	ldr	r3, [fp, #-8]
    95ec:	e2832001 	add	r2, r3, #1
    95f0:	e50b2008 	str	r2, [fp, #-8]
    95f4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    95f8:	e0823003 	add	r3, r2, r3
    95fc:	e24b1044 	sub	r1, fp, #68	; 0x44
    9600:	e51b2010 	ldr	r2, [fp, #-16]
    9604:	e0812002 	add	r2, r1, r2
    9608:	e5d22000 	ldrb	r2, [r2]
    960c:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:231 (discriminator 2)
	for (int i = 0; i < string_int_len; i++)
    9610:	e51b3010 	ldr	r3, [fp, #-16]
    9614:	e2833001 	add	r3, r3, #1
    9618:	e50b3010 	str	r3, [fp, #-16]
    961c:	eaffffed 	b	95d8 <_Z4ftoafPcj+0x214>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:236
	}

	if (decimals != 0) 
    9620:	e51b3060 	ldr	r3, [fp, #-96]	; 0xffffffa0
    9624:	e3530000 	cmp	r3, #0
    9628:	0a000025 	beq	96c4 <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:238
	{
		bfr[index++] = '.';
    962c:	e51b3008 	ldr	r3, [fp, #-8]
    9630:	e2832001 	add	r2, r3, #1
    9634:	e50b2008 	str	r2, [fp, #-8]
    9638:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    963c:	e0823003 	add	r3, r2, r3
    9640:	e3a0202e 	mov	r2, #46	; 0x2e
    9644:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:240
		char string_decimals[9];
		decimal_to_string_float(decimal, string_decimals, precision);
    9648:	e24b3050 	sub	r3, fp, #80	; 0x50
    964c:	e51b200c 	ldr	r2, [fp, #-12]
    9650:	e1a01003 	mov	r1, r3
    9654:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    9658:	ebfffef9 	bl	9244 <_Z23decimal_to_string_floatjPci>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242

		for (int i = 0; i < 9; i++)
    965c:	e3a03000 	mov	r3, #0
    9660:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 1)
    9664:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9668:	e3530008 	cmp	r3, #8
    966c:	ca000014 	bgt	96c4 <_Z4ftoafPcj+0x300>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:244
		{
			if (string_decimals[i] == '\0')
    9670:	e24b2050 	sub	r2, fp, #80	; 0x50
    9674:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9678:	e0823003 	add	r3, r2, r3
    967c:	e5d33000 	ldrb	r3, [r3]
    9680:	e3530000 	cmp	r3, #0
    9684:	0a00000d 	beq	96c0 <_Z4ftoafPcj+0x2fc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:246 (discriminator 2)
				break;
			bfr[index++] = string_decimals[i];
    9688:	e51b3008 	ldr	r3, [fp, #-8]
    968c:	e2832001 	add	r2, r3, #1
    9690:	e50b2008 	str	r2, [fp, #-8]
    9694:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    9698:	e0823003 	add	r3, r2, r3
    969c:	e24b1050 	sub	r1, fp, #80	; 0x50
    96a0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    96a4:	e0812002 	add	r2, r1, r2
    96a8:	e5d22000 	ldrb	r2, [r2]
    96ac:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:242 (discriminator 2)
		for (int i = 0; i < 9; i++)
    96b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    96b4:	e2833001 	add	r3, r3, #1
    96b8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
    96bc:	eaffffe8 	b	9664 <_Z4ftoafPcj+0x2a0>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:245
				break;
    96c0:	e320f000 	nop	{0}
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:249 (discriminator 2)
		}
	}
	bfr[index] = '\0';
    96c4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    96c8:	e51b3008 	ldr	r3, [fp, #-8]
    96cc:	e0823003 	add	r3, r2, r3
    96d0:	e3a02000 	mov	r2, #0
    96d4:	e5c32000 	strb	r2, [r3]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:250
}
    96d8:	e24bd004 	sub	sp, fp, #4
    96dc:	e8bd8800 	pop	{fp, pc}
    96e0:	41200000 			; <UNDEFINED> instruction: 0x41200000
    96e4:	3f000000 	svccc	0x00000000

000096e8 <_Z4atofPKc>:
_Z4atofPKc():
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:253

float atof(const char* s) 
{
    96e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    96ec:	e28db000 	add	fp, sp, #0
    96f0:	e24dd01c 	sub	sp, sp, #28
    96f4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:254
  float rez = 0, fact = 1;
    96f8:	e3a03000 	mov	r3, #0
    96fc:	e50b3008 	str	r3, [fp, #-8]
    9700:	e3a035fe 	mov	r3, #1065353216	; 0x3f800000
    9704:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:255
  if (*s == '-'){
    9708:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    970c:	e5d33000 	ldrb	r3, [r3]
    9710:	e353002d 	cmp	r3, #45	; 0x2d
    9714:	1a000004 	bne	972c <_Z4atofPKc+0x44>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:256
    s++;
    9718:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    971c:	e2833001 	add	r3, r3, #1
    9720:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:257
    fact = -1;
    9724:	e59f30c8 	ldr	r3, [pc, #200]	; 97f4 <_Z4atofPKc+0x10c>
    9728:	e50b300c 	str	r3, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259
  };
  for (int point_seen = 0; *s; s++){
    972c:	e3a03000 	mov	r3, #0
    9730:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 1)
    9734:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9738:	e5d33000 	ldrb	r3, [r3]
    973c:	e3530000 	cmp	r3, #0
    9740:	0a000023 	beq	97d4 <_Z4atofPKc+0xec>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:260
    if (*s == '.'){
    9744:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9748:	e5d33000 	ldrb	r3, [r3]
    974c:	e353002e 	cmp	r3, #46	; 0x2e
    9750:	1a000002 	bne	9760 <_Z4atofPKc+0x78>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:261 (discriminator 1)
      point_seen = 1; 
    9754:	e3a03001 	mov	r3, #1
    9758:	e50b3010 	str	r3, [fp, #-16]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:262 (discriminator 1)
      continue;
    975c:	ea000018 	b	97c4 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:264
    };
    int d = *s - '0';
    9760:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9764:	e5d33000 	ldrb	r3, [r3]
    9768:	e2433030 	sub	r3, r3, #48	; 0x30
    976c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265
    if (d >= 0 && d <= 9){
    9770:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9774:	e3530000 	cmp	r3, #0
    9778:	ba000011 	blt	97c4 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:265 (discriminator 1)
    977c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9780:	e3530009 	cmp	r3, #9
    9784:	ca00000e 	bgt	97c4 <_Z4atofPKc+0xdc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266
      if (point_seen) fact /= 10.0f;
    9788:	e51b3010 	ldr	r3, [fp, #-16]
    978c:	e3530000 	cmp	r3, #0
    9790:	0a000003 	beq	97a4 <_Z4atofPKc+0xbc>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:266 (discriminator 1)
    9794:	ed1b7a03 	vldr	s14, [fp, #-12]
    9798:	eddf6a14 	vldr	s13, [pc, #80]	; 97f0 <_Z4atofPKc+0x108>
    979c:	eec77a26 	vdiv.f32	s15, s14, s13
    97a0:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:267
      rez = rez * 10.0f + (float)d;
    97a4:	ed5b7a02 	vldr	s15, [fp, #-8]
    97a8:	ed9f7a10 	vldr	s14, [pc, #64]	; 97f0 <_Z4atofPKc+0x108>
    97ac:	ee277a87 	vmul.f32	s14, s15, s14
    97b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    97b4:	ee073a90 	vmov	s15, r3
    97b8:	eef87ae7 	vcvt.f32.s32	s15, s15
    97bc:	ee777a27 	vadd.f32	s15, s14, s15
    97c0:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:259 (discriminator 2)
  for (int point_seen = 0; *s; s++){
    97c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    97c8:	e2833001 	add	r3, r3, #1
    97cc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    97d0:	eaffffd7 	b	9734 <_Z4atofPKc+0x4c>
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:270
    };
  };
  return rez * fact;
    97d4:	ed1b7a02 	vldr	s14, [fp, #-8]
    97d8:	ed5b7a03 	vldr	s15, [fp, #-12]
    97dc:	ee677a27 	vmul.f32	s15, s14, s15
/home/jamesari/git/os/sp/sources/stdlib/src/stdstring.cpp:271
    97e0:	eeb00a67 	vmov.f32	s0, s15
    97e4:	e28bd000 	add	sp, fp, #0
    97e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    97ec:	e12fff1e 	bx	lr
    97f0:	41200000 			; <UNDEFINED> instruction: 0x41200000
    97f4:	bf800000 	svclt	0x00800000

000097f8 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    97f8:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    97fc:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9800:	3a000074 	bcc	99d8 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    9804:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9808:	9a00006b 	bls	99bc <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    980c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9810:	0a00006c 	beq	99c8 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9814:	e16f3f10 	clz	r3, r0
    9818:	e16f2f11 	clz	r2, r1
    981c:	e0423003 	sub	r3, r2, r3
    9820:	e273301f 	rsbs	r3, r3, #31
    9824:	10833083 	addne	r3, r3, r3, lsl #1
    9828:	e3a02000 	mov	r2, #0
    982c:	108ff103 	addne	pc, pc, r3, lsl #2
    9830:	e1a00000 	nop			; (mov r0, r0)
    9834:	e1500f81 	cmp	r0, r1, lsl #31
    9838:	e0a22002 	adc	r2, r2, r2
    983c:	20400f81 	subcs	r0, r0, r1, lsl #31
    9840:	e1500f01 	cmp	r0, r1, lsl #30
    9844:	e0a22002 	adc	r2, r2, r2
    9848:	20400f01 	subcs	r0, r0, r1, lsl #30
    984c:	e1500e81 	cmp	r0, r1, lsl #29
    9850:	e0a22002 	adc	r2, r2, r2
    9854:	20400e81 	subcs	r0, r0, r1, lsl #29
    9858:	e1500e01 	cmp	r0, r1, lsl #28
    985c:	e0a22002 	adc	r2, r2, r2
    9860:	20400e01 	subcs	r0, r0, r1, lsl #28
    9864:	e1500d81 	cmp	r0, r1, lsl #27
    9868:	e0a22002 	adc	r2, r2, r2
    986c:	20400d81 	subcs	r0, r0, r1, lsl #27
    9870:	e1500d01 	cmp	r0, r1, lsl #26
    9874:	e0a22002 	adc	r2, r2, r2
    9878:	20400d01 	subcs	r0, r0, r1, lsl #26
    987c:	e1500c81 	cmp	r0, r1, lsl #25
    9880:	e0a22002 	adc	r2, r2, r2
    9884:	20400c81 	subcs	r0, r0, r1, lsl #25
    9888:	e1500c01 	cmp	r0, r1, lsl #24
    988c:	e0a22002 	adc	r2, r2, r2
    9890:	20400c01 	subcs	r0, r0, r1, lsl #24
    9894:	e1500b81 	cmp	r0, r1, lsl #23
    9898:	e0a22002 	adc	r2, r2, r2
    989c:	20400b81 	subcs	r0, r0, r1, lsl #23
    98a0:	e1500b01 	cmp	r0, r1, lsl #22
    98a4:	e0a22002 	adc	r2, r2, r2
    98a8:	20400b01 	subcs	r0, r0, r1, lsl #22
    98ac:	e1500a81 	cmp	r0, r1, lsl #21
    98b0:	e0a22002 	adc	r2, r2, r2
    98b4:	20400a81 	subcs	r0, r0, r1, lsl #21
    98b8:	e1500a01 	cmp	r0, r1, lsl #20
    98bc:	e0a22002 	adc	r2, r2, r2
    98c0:	20400a01 	subcs	r0, r0, r1, lsl #20
    98c4:	e1500981 	cmp	r0, r1, lsl #19
    98c8:	e0a22002 	adc	r2, r2, r2
    98cc:	20400981 	subcs	r0, r0, r1, lsl #19
    98d0:	e1500901 	cmp	r0, r1, lsl #18
    98d4:	e0a22002 	adc	r2, r2, r2
    98d8:	20400901 	subcs	r0, r0, r1, lsl #18
    98dc:	e1500881 	cmp	r0, r1, lsl #17
    98e0:	e0a22002 	adc	r2, r2, r2
    98e4:	20400881 	subcs	r0, r0, r1, lsl #17
    98e8:	e1500801 	cmp	r0, r1, lsl #16
    98ec:	e0a22002 	adc	r2, r2, r2
    98f0:	20400801 	subcs	r0, r0, r1, lsl #16
    98f4:	e1500781 	cmp	r0, r1, lsl #15
    98f8:	e0a22002 	adc	r2, r2, r2
    98fc:	20400781 	subcs	r0, r0, r1, lsl #15
    9900:	e1500701 	cmp	r0, r1, lsl #14
    9904:	e0a22002 	adc	r2, r2, r2
    9908:	20400701 	subcs	r0, r0, r1, lsl #14
    990c:	e1500681 	cmp	r0, r1, lsl #13
    9910:	e0a22002 	adc	r2, r2, r2
    9914:	20400681 	subcs	r0, r0, r1, lsl #13
    9918:	e1500601 	cmp	r0, r1, lsl #12
    991c:	e0a22002 	adc	r2, r2, r2
    9920:	20400601 	subcs	r0, r0, r1, lsl #12
    9924:	e1500581 	cmp	r0, r1, lsl #11
    9928:	e0a22002 	adc	r2, r2, r2
    992c:	20400581 	subcs	r0, r0, r1, lsl #11
    9930:	e1500501 	cmp	r0, r1, lsl #10
    9934:	e0a22002 	adc	r2, r2, r2
    9938:	20400501 	subcs	r0, r0, r1, lsl #10
    993c:	e1500481 	cmp	r0, r1, lsl #9
    9940:	e0a22002 	adc	r2, r2, r2
    9944:	20400481 	subcs	r0, r0, r1, lsl #9
    9948:	e1500401 	cmp	r0, r1, lsl #8
    994c:	e0a22002 	adc	r2, r2, r2
    9950:	20400401 	subcs	r0, r0, r1, lsl #8
    9954:	e1500381 	cmp	r0, r1, lsl #7
    9958:	e0a22002 	adc	r2, r2, r2
    995c:	20400381 	subcs	r0, r0, r1, lsl #7
    9960:	e1500301 	cmp	r0, r1, lsl #6
    9964:	e0a22002 	adc	r2, r2, r2
    9968:	20400301 	subcs	r0, r0, r1, lsl #6
    996c:	e1500281 	cmp	r0, r1, lsl #5
    9970:	e0a22002 	adc	r2, r2, r2
    9974:	20400281 	subcs	r0, r0, r1, lsl #5
    9978:	e1500201 	cmp	r0, r1, lsl #4
    997c:	e0a22002 	adc	r2, r2, r2
    9980:	20400201 	subcs	r0, r0, r1, lsl #4
    9984:	e1500181 	cmp	r0, r1, lsl #3
    9988:	e0a22002 	adc	r2, r2, r2
    998c:	20400181 	subcs	r0, r0, r1, lsl #3
    9990:	e1500101 	cmp	r0, r1, lsl #2
    9994:	e0a22002 	adc	r2, r2, r2
    9998:	20400101 	subcs	r0, r0, r1, lsl #2
    999c:	e1500081 	cmp	r0, r1, lsl #1
    99a0:	e0a22002 	adc	r2, r2, r2
    99a4:	20400081 	subcs	r0, r0, r1, lsl #1
    99a8:	e1500001 	cmp	r0, r1
    99ac:	e0a22002 	adc	r2, r2, r2
    99b0:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    99b4:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    99b8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    99bc:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    99c0:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    99c4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    99c8:	e16f2f11 	clz	r2, r1
    99cc:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    99d0:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    99d4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    99d8:	e3500000 	cmp	r0, #0
    99dc:	13e00000 	mvnne	r0, #0
    99e0:	ea000007 	b	9a04 <__aeabi_idiv0>

000099e4 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    99e4:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    99e8:	0afffffa 	beq	99d8 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    99ec:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    99f0:	ebffff80 	bl	97f8 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    99f4:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    99f8:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    99fc:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9a00:	e12fff1e 	bx	lr

00009a04 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9a04:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009a08 <_ZL8INFINITY>:
    9a08:	7f7fffff 	svcvc	0x007fffff

00009a0c <_ZL9INT32_MAX>:
    9a0c:	7fffffff 	svcvc	0x00ffffff

00009a10 <_ZL9INT32_MIN>:
    9a10:	80000000 	andhi	r0, r0, r0

00009a14 <_ZL10UINT32_MAX>:
    9a14:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a18 <_ZL10UINT32_MIN>:
    9a18:	00000000 	andeq	r0, r0, r0

00009a1c <_ZL13Lock_Unlocked>:
    9a1c:	00000000 	andeq	r0, r0, r0

00009a20 <_ZL11Lock_Locked>:
    9a20:	00000001 	andeq	r0, r0, r1

00009a24 <_ZL21MaxFSDriverNameLength>:
    9a24:	00000010 	andeq	r0, r0, r0, lsl r0

00009a28 <_ZL17MaxFilenameLength>:
    9a28:	00000010 	andeq	r0, r0, r0, lsl r0

00009a2c <_ZL13MaxPathLength>:
    9a2c:	00000080 	andeq	r0, r0, r0, lsl #1

00009a30 <_ZL18NoFilesystemDriver>:
    9a30:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a34 <_ZL9NotifyAll>:
    9a34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a38 <_ZL24Max_Process_Opened_Files>:
    9a38:	00000010 	andeq	r0, r0, r0, lsl r0

00009a3c <_ZL10Indefinite>:
    9a3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a40 <_ZL18Deadline_Unchanged>:
    9a40:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a44 <_ZL14Invalid_Handle>:
    9a44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a48 <_ZN3halL18Default_Clock_RateE>:
    9a48:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009a4c <_ZN3halL15Peripheral_BaseE>:
    9a4c:	20000000 	andcs	r0, r0, r0

00009a50 <_ZN3halL9GPIO_BaseE>:
    9a50:	20200000 	eorcs	r0, r0, r0

00009a54 <_ZN3halL14GPIO_Pin_CountE>:
    9a54:	00000036 	andeq	r0, r0, r6, lsr r0

00009a58 <_ZN3halL8AUX_BaseE>:
    9a58:	20215000 	eorcs	r5, r1, r0

00009a5c <_ZN3halL25Interrupt_Controller_BaseE>:
    9a5c:	2000b200 	andcs	fp, r0, r0, lsl #4

00009a60 <_ZN3halL10Timer_BaseE>:
    9a60:	2000b400 	andcs	fp, r0, r0, lsl #8

00009a64 <_ZN3halL9TRNG_BaseE>:
    9a64:	20104000 	andscs	r4, r0, r0

00009a68 <_ZN3halL9BSC0_BaseE>:
    9a68:	20205000 	eorcs	r5, r0, r0

00009a6c <_ZN3halL9BSC1_BaseE>:
    9a6c:	20804000 	addcs	r4, r0, r0

00009a70 <_ZN3halL9BSC2_BaseE>:
    9a70:	20805000 	addcs	r5, r0, r0

00009a74 <_ZL11Invalid_Pin>:
    9a74:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9a78:	3a564544 	bcc	159af90 <__bss_end+0x1591480>
    9a7c:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    9a80:	00000000 	andeq	r0, r0, r0
    9a84:	3a564544 	bcc	159af9c <__bss_end+0x159148c>
    9a88:	6f697067 	svcvs	0x00697067
    9a8c:	0000342f 	andeq	r3, r0, pc, lsr #8
    9a90:	3a564544 	bcc	159afa8 <__bss_end+0x1591498>
    9a94:	6f697067 	svcvs	0x00697067
    9a98:	0037312f 	eorseq	r3, r7, pc, lsr #2

00009a9c <_ZL9INT32_MAX>:
    9a9c:	7fffffff 	svcvc	0x00ffffff

00009aa0 <_ZL9INT32_MIN>:
    9aa0:	80000000 	andhi	r0, r0, r0

00009aa4 <_ZL10UINT32_MAX>:
    9aa4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009aa8 <_ZL10UINT32_MIN>:
    9aa8:	00000000 	andeq	r0, r0, r0

00009aac <_ZL13Lock_Unlocked>:
    9aac:	00000000 	andeq	r0, r0, r0

00009ab0 <_ZL11Lock_Locked>:
    9ab0:	00000001 	andeq	r0, r0, r1

00009ab4 <_ZL21MaxFSDriverNameLength>:
    9ab4:	00000010 	andeq	r0, r0, r0, lsl r0

00009ab8 <_ZL17MaxFilenameLength>:
    9ab8:	00000010 	andeq	r0, r0, r0, lsl r0

00009abc <_ZL13MaxPathLength>:
    9abc:	00000080 	andeq	r0, r0, r0, lsl #1

00009ac0 <_ZL18NoFilesystemDriver>:
    9ac0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ac4 <_ZL9NotifyAll>:
    9ac4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ac8 <_ZL24Max_Process_Opened_Files>:
    9ac8:	00000010 	andeq	r0, r0, r0, lsl r0

00009acc <_ZL10Indefinite>:
    9acc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ad0 <_ZL18Deadline_Unchanged>:
    9ad0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009ad4 <_ZL14Invalid_Handle>:
    9ad4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ad8 <_ZL8INFINITY>:
    9ad8:	7f7fffff 	svcvc	0x007fffff

00009adc <_ZL16Pipe_File_Prefix>:
    9adc:	3a535953 	bcc	14e0030 <__bss_end+0x14d6520>
    9ae0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9ae4:	0000002f 	andeq	r0, r0, pc, lsr #32

00009ae8 <_ZL8INFINITY>:
    9ae8:	7f7fffff 	svcvc	0x007fffff

00009aec <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9aec:	33323130 	teqcc	r2, #48, 2
    9af0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9af4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9af8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009b00 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683d1c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38914>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c528>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7214>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfb2c>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36df6>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff62bf>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x157288>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb7690>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x776c4>
 1c8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 1cc:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 1d0:	01058509 	tsteq	r5, r9, lsl #10
 1d4:	000a022f 	andeq	r0, sl, pc, lsr #4
 1d8:	02b10101 	adcseq	r0, r1, #1073741824	; 0x40000000
 1dc:	00030000 	andeq	r0, r3, r0
 1e0:	00000229 	andeq	r0, r0, r9, lsr #4
 1e4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 1e8:	0101000d 	tsteq	r1, sp
 1ec:	00000101 	andeq	r0, r0, r1, lsl #2
 1f0:	00000100 	andeq	r0, r0, r0, lsl #2
 1f4:	6f682f01 	svcvs	0x00682f01
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfca4>
 1fc:	73656d61 	cmnvc	r5, #6208	; 0x1840
 200:	2f697261 	svccs	0x00697261
 204:	2f746967 	svccs	0x00746967
 208:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 20c:	6f732f70 	svcvs	0x00732f70
 210:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 214:	73752f73 	cmnvc	r5, #460	; 0x1cc
 218:	70737265 	rsbsvc	r7, r3, r5, ror #4
 21c:	2f656361 	svccs	0x00656361
 220:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
 224:	5f726574 	svcpl	0x00726574
 228:	6b736174 	blvs	1cd8800 <__bss_end+0x1ccecf0>
 22c:	6f682f00 	svcvs	0x00682f00
 230:	6a2f656d 	bvs	bd97ec <__bss_end+0xbcfcdc>
 234:	73656d61 	cmnvc	r5, #6208	; 0x1840
 238:	2f697261 	svccs	0x00697261
 23c:	2f746967 	svccs	0x00746967
 240:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 244:	6f732f70 	svcvs	0x00732f70
 248:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 24c:	73752f73 	cmnvc	r5, #460	; 0x1cc
 250:	70737265 	rsbsvc	r7, r3, r5, ror #4
 254:	2f656361 	svccs	0x00656361
 258:	6b2f2e2e 	blvs	bcbb18 <__bss_end+0xbc2008>
 25c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 260:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 264:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 268:	6f622f65 	svcvs	0x00622f65
 26c:	2f647261 	svccs	0x00647261
 270:	30697072 	rsbcc	r7, r9, r2, ror r0
 274:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 278:	6f682f00 	svcvs	0x00682f00
 27c:	6a2f656d 	bvs	bd9838 <__bss_end+0xbcfd28>
 280:	73656d61 	cmnvc	r5, #6208	; 0x1840
 284:	2f697261 	svccs	0x00697261
 288:	2f746967 	svccs	0x00746967
 28c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 290:	6f732f70 	svcvs	0x00732f70
 294:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 298:	73752f73 	cmnvc	r5, #460	; 0x1cc
 29c:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2a0:	2f656361 	svccs	0x00656361
 2a4:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
 2a8:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 2ac:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
 2b0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2b4:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 2b8:	2f656d6f 	svccs	0x00656d6f
 2bc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2c0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2c4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 2c8:	2f736f2f 	svccs	0x00736f2f
 2cc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2d0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2d4:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff77 <__bss_end+0xffff6467>
 2d8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2dc:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2e0:	2f2e2e2f 	svccs	0x002e2e2f
 2e4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2e8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2ec:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2f0:	702f6564 	eorvc	r6, pc, r4, ror #10
 2f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2f8:	2f007373 	svccs	0x00007373
 2fc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 300:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
 304:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
 308:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
 30c:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
 310:	2f70732f 	svccs	0x0070732f
 314:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 318:	2f736563 	svccs	0x00736563
 31c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 320:	63617073 	cmnvs	r1, #115	; 0x73
 324:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 328:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 32c:	2f6c656e 	svccs	0x006c656e
 330:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 334:	2f656475 	svccs	0x00656475
 338:	2f007366 	svccs	0x00007366
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
 378:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 37c:	00737265 	rsbseq	r7, r3, r5, ror #4
 380:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 384:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 388:	00010070 	andeq	r0, r1, r0, ror r0
 38c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 390:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 394:	00020068 	andeq	r0, r2, r8, rrx
 398:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 39c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 3a0:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 3a4:	00000300 	andeq	r0, r0, r0, lsl #6
 3a8:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 3ac:	00040068 	andeq	r0, r4, r8, rrx
 3b0:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 3b4:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 3b8:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 3bc:	66000004 	strvs	r0, [r0], -r4
 3c0:	73656c69 	cmnvc	r5, #26880	; 0x6900
 3c4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 3c8:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 3cc:	70000005 	andvc	r0, r0, r5
 3d0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3d4:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 3d8:	00000400 	andeq	r0, r0, r0, lsl #8
 3dc:	636f7270 	cmnvs	pc, #112, 4
 3e0:	5f737365 	svcpl	0x00737365
 3e4:	616e616d 	cmnvs	lr, sp, ror #2
 3e8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 3ec:	00040068 	andeq	r0, r4, r8, rrx
 3f0:	72657000 	rsbvc	r7, r5, #0
 3f4:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 3f8:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 3fc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 400:	70670000 	rsbvc	r0, r7, r0
 404:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 408:	00000600 	andeq	r0, r0, r0, lsl #12
 40c:	00010500 	andeq	r0, r1, r0, lsl #10
 410:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 414:	10030000 	andne	r0, r3, r0
 418:	9f1e0501 	svcls	0x001e0501
 41c:	0f058383 	svceq	0x00058383
 420:	4b070584 	blmi	1c1a38 <__bss_end+0x1b7f28>
 424:	4c13054b 	cfldr32mi	mvfx0, [r3], {75}	; 0x4b
 428:	01040200 	mrseq	r0, R12_usr
 42c:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 430:	004a0204 	subeq	r0, sl, r4, lsl #4
 434:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 438:	4e060805 	cdpmi	8, 0, cr0, cr6, cr5, {0}
 43c:	054c0705 	strbeq	r0, [ip, #-1797]	; 0xfffff8fb
 440:	0d059f14 	stceq	15, cr9, [r5, #-80]	; 0xffffffb0
 444:	8407052e 	strhi	r0, [r7], #-1326	; 0xfffffad2
 448:	059f0f05 	ldreq	r0, [pc, #3845]	; 1355 <shift+0x1355>
 44c:	03052e08 	movweq	r2, #24072	; 0x5e08
 450:	670b0584 	strvs	r0, [fp, -r4, lsl #11]
 454:	68180584 	ldmdavs	r8, {r2, r7, r8, sl}
 458:	20080d05 	andcs	r0, r8, r5, lsl #26
 45c:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
 460:	00a02f08 	adceq	r2, r0, r8, lsl #30
 464:	06010402 	streq	r0, [r1], -r2, lsl #8
 468:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 46c:	02004a02 	andeq	r4, r0, #8192	; 0x2000
 470:	002e0404 	eoreq	r0, lr, r4, lsl #8
 474:	66050402 	strvs	r0, [r5], -r2, lsl #8
 478:	06040200 	streq	r0, [r4], -r0, lsl #4
 47c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 480:	02052e08 	andeq	r2, r5, #8, 28	; 0x80
 484:	08040200 	stmdaeq	r4, {r9}
 488:	0a026706 	beq	9a0a8 <__bss_end+0x90598>
 48c:	bf010100 	svclt	0x00010100
 490:	03000002 	movweq	r0, #2
 494:	00018c00 	andeq	r8, r1, r0, lsl #24
 498:	fb010200 	blx	40ca2 <__bss_end+0x37192>
 49c:	01000d0e 	tsteq	r0, lr, lsl #26
 4a0:	00010101 	andeq	r0, r1, r1, lsl #2
 4a4:	00010000 	andeq	r0, r1, r0
 4a8:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 4ac:	2f656d6f 	svccs	0x00656d6f
 4b0:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 4b4:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 4b8:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 4bc:	2f736f2f 	svccs	0x00736f2f
 4c0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 4c4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 4c8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 4cc:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 4d0:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 4d4:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 4d8:	2f656d6f 	svccs	0x00656d6f
 4dc:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 4e0:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 4e4:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 4e8:	2f736f2f 	svccs	0x00736f2f
 4ec:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 4f0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 4f4:	6b2f7365 	blvs	bdd290 <__bss_end+0xbd3780>
 4f8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 4fc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 500:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 504:	6f622f65 	svcvs	0x00622f65
 508:	2f647261 	svccs	0x00647261
 50c:	30697072 	rsbcc	r7, r9, r2, ror r0
 510:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 514:	6f682f00 	svcvs	0x00682f00
 518:	6a2f656d 	bvs	bd9ad4 <__bss_end+0xbcffc4>
 51c:	73656d61 	cmnvc	r5, #6208	; 0x1840
 520:	2f697261 	svccs	0x00697261
 524:	2f746967 	svccs	0x00746967
 528:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 52c:	6f732f70 	svcvs	0x00732f70
 530:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 534:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 538:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 53c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 540:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 544:	6f72702f 	svcvs	0x0072702f
 548:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 54c:	6f682f00 	svcvs	0x00682f00
 550:	6a2f656d 	bvs	bd9b0c <__bss_end+0xbcfffc>
 554:	73656d61 	cmnvc	r5, #6208	; 0x1840
 558:	2f697261 	svccs	0x00697261
 55c:	2f746967 	svccs	0x00746967
 560:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 564:	6f732f70 	svcvs	0x00732f70
 568:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 56c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 570:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 574:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 578:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 57c:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 580:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4cc <shift+0x4cc>
 584:	616a2f65 	cmnvs	sl, r5, ror #30
 588:	6173656d 	cmnvs	r3, sp, ror #10
 58c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
 590:	6f2f7469 	svcvs	0x002f7469
 594:	70732f73 	rsbsvc	r2, r3, r3, ror pc
 598:	756f732f 	strbvc	r7, [pc, #-815]!	; 271 <shift+0x271>
 59c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 5a0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 5a4:	2f62696c 	svccs	0x0062696c
 5a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 5ac:	00656475 	rsbeq	r6, r5, r5, ror r4
 5b0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 5b4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 5bc:	00000100 	andeq	r0, r0, r0, lsl #2
 5c0:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 5c4:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 5c8:	00000200 	andeq	r0, r0, r0, lsl #4
 5cc:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 5d0:	00030068 	andeq	r0, r3, r8, rrx
 5d4:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 5d8:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 5dc:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 5e0:	66000003 	strvs	r0, [r0], -r3
 5e4:	73656c69 	cmnvc	r5, #26880	; 0x6900
 5e8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 5ec:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 5f0:	70000004 	andvc	r0, r0, r4
 5f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 5f8:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 5fc:	00000300 	andeq	r0, r0, r0, lsl #6
 600:	636f7270 	cmnvs	pc, #112, 4
 604:	5f737365 	svcpl	0x00737365
 608:	616e616d 	cmnvs	lr, sp, ror #2
 60c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 610:	00030068 	andeq	r0, r3, r8, rrx
 614:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 618:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 61c:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 620:	00000500 	andeq	r0, r0, r0, lsl #10
 624:	00010500 	andeq	r0, r1, r0, lsl #10
 628:	83c00205 	bichi	r0, r0, #1342177280	; 0x50000000
 62c:	05160000 	ldreq	r0, [r6, #-0]
 630:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
 634:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 638:	852f0105 	strhi	r0, [pc, #-261]!	; 53b <shift+0x53b>
 63c:	05833205 	streq	r3, [r3, #517]	; 0x205
 640:	01054b1a 	tsteq	r5, sl, lsl fp
 644:	1a05852f 	bne	161b08 <__bss_end+0x157ff8>
 648:	2f01054b 	svccs	0x0001054b
 64c:	a1320585 	teqge	r2, r5, lsl #11
 650:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 654:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
 658:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 65c:	852f0105 	strhi	r0, [pc, #-261]!	; 55f <shift+0x55f>
 660:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 664:	2e054b30 	vmovcs.16	d5[0], r4
 668:	4b1b054b 	blmi	6c1b9c <__bss_end+0x6b808c>
 66c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff86f <__bss_end+0xffff5d5f>
 670:	01054c0c 	tsteq	r5, ip, lsl #24
 674:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 678:	4b3005bd 	blmi	c01d74 <__bss_end+0xbf8264>
 67c:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 680:	2e054b1b 	vmovcs.32	d5[0], r4
 684:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 688:	852f0105 	strhi	r0, [pc, #-261]!	; 58b <shift+0x58b>
 68c:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
 690:	01054b1b 	tsteq	r5, fp, lsl fp
 694:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 698:	4b3305bd 	blmi	cc1d94 <__bss_end+0xcb8284>
 69c:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6a0:	30054b1b 	andcc	r4, r5, fp, lsl fp
 6a4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6a8:	852f0105 	strhi	r0, [pc, #-261]!	; 5ab <shift+0x5ab>
 6ac:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
 6b0:	1b054b2f 	blne	153374 <__bss_end+0x149864>
 6b4:	2f2f054b 	svccs	0x002f054b
 6b8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6bc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c0:	2f05bd2e 	svccs	0x0005bd2e
 6c4:	4b3b054b 	blmi	ec1bf8 <__bss_end+0xeb80e8>
 6c8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6cc:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 6d0:	2f01054c 	svccs	0x0001054c
 6d4:	a12f0585 	smlawbge	pc, r5, r5, r0	; <UNPREDICTABLE>
 6d8:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 6dc:	30054b1a 	andcc	r4, r5, sl, lsl fp
 6e0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6e4:	859f0105 	ldrhi	r0, [pc, #261]	; 7f1 <shift+0x7f1>
 6e8:	05672005 	strbeq	r2, [r7, #-5]!
 6ec:	31054d2d 	tstcc	r5, sp, lsr #26
 6f0:	4b1a054b 	blmi	681c24 <__bss_end+0x678114>
 6f4:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6f8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6fc:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 700:	4b31054d 	blmi	c41c3c <__bss_end+0xc3812c>
 704:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 708:	0105300c 	tsteq	r5, ip
 70c:	2005852f 	andcs	r8, r5, pc, lsr #10
 710:	4c2d0583 	cfstr32mi	mvfx0, [sp], #-524	; 0xfffffdf4
 714:	054b3e05 	strbeq	r3, [fp, #-3589]	; 0xfffff1fb
 718:	01054b1a 	tsteq	r5, sl, lsl fp
 71c:	2005852f 	andcs	r8, r5, pc, lsr #10
 720:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 724:	054b3005 	strbeq	r3, [fp, #-5]
 728:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 72c:	2f010530 	svccs	0x00010530
 730:	a00c0587 	andge	r0, ip, r7, lsl #11
 734:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
 738:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
 73c:	0f052e36 	svceq	0x00052e36
 740:	66130530 			; <UNDEFINED> instruction: 0x66130530
 744:	05840905 	streq	r0, [r4, #2309]	; 0x905
 748:	0105d810 	tsteq	r5, r0, lsl r8
 74c:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
 750:	063e0101 	ldrteq	r0, [lr], -r1, lsl #2
 754:	00030000 	andeq	r0, r3, r0
 758:	0000008f 	andeq	r0, r0, pc, lsl #1
 75c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 760:	0101000d 	tsteq	r1, sp
 764:	00000101 	andeq	r0, r0, r1, lsl #2
 768:	00000100 	andeq	r0, r0, r0, lsl #2
 76c:	6f682f01 	svcvs	0x00682f01
 770:	6a2f656d 	bvs	bd9d2c <__bss_end+0xbd021c>
 774:	73656d61 	cmnvc	r5, #6208	; 0x1840
 778:	2f697261 	svccs	0x00697261
 77c:	2f746967 	svccs	0x00746967
 780:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 784:	6f732f70 	svcvs	0x00732f70
 788:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 78c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 790:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 794:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 798:	6f682f00 	svcvs	0x00682f00
 79c:	6a2f656d 	bvs	bd9d58 <__bss_end+0xbd0248>
 7a0:	73656d61 	cmnvc	r5, #6208	; 0x1840
 7a4:	2f697261 	svccs	0x00697261
 7a8:	2f746967 	svccs	0x00746967
 7ac:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 7b0:	6f732f70 	svcvs	0x00732f70
 7b4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 7b8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 7bc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 7c0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 7c4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 7c8:	74730000 	ldrbtvc	r0, [r3], #-0
 7cc:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 7d0:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 7d4:	00707063 	rsbseq	r7, r0, r3, rrx
 7d8:	73000001 	movwvc	r0, #1
 7dc:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 7e0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 7e4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 7e8:	05000000 	streq	r0, [r0, #-0]
 7ec:	02050001 	andeq	r0, r5, #1
 7f0:	0000881c 	andeq	r8, r0, ip, lsl r8
 7f4:	bb06051a 	bllt	181c64 <__bss_end+0x178154>
 7f8:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
 7fc:	0a056821 	beq	15a888 <__bss_end+0x150d78>
 800:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
 804:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
 808:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 80c:	9f04052f 	svcls	0x0004052f
 810:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 814:	10053505 	andne	r3, r5, r5, lsl #10
 818:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 81c:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 820:	0a052e13 	beq	14c074 <__bss_end+0x142564>
 824:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
 828:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 82c:	03054a0c 	movweq	r4, #23052	; 0x5a0c
 830:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
 834:	02001805 	andeq	r1, r0, #327680	; 0x50000
 838:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 83c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 840:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 844:	02040200 	andeq	r0, r4, #0, 4
 848:	00180568 	andseq	r0, r8, r8, ror #10
 84c:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 850:	02000805 	andeq	r0, r0, #327680	; 0x50000
 854:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 858:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 85c:	1b054b02 	blne	15346c <__bss_end+0x14995c>
 860:	02040200 	andeq	r0, r4, #0, 4
 864:	000c052e 	andeq	r0, ip, lr, lsr #10
 868:	4a020402 	bmi	81878 <__bss_end+0x77d68>
 86c:	02000f05 	andeq	r0, r0, #5, 30
 870:	05820204 	streq	r0, [r2, #516]	; 0x204
 874:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 878:	11054a02 	tstne	r5, r2, lsl #20
 87c:	02040200 	andeq	r0, r4, #0, 4
 880:	000a052e 	andeq	r0, sl, lr, lsr #10
 884:	2f020402 	svccs	0x00020402
 888:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 88c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 890:	0402000d 	streq	r0, [r2], #-13
 894:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 898:	02040200 	andeq	r0, r4, #0, 4
 89c:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 8a0:	83060585 	movwhi	r0, #25989	; 0x6585
 8a4:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
 8a8:	0a054a10 	beq	1530f0 <__bss_end+0x1495e0>
 8ac:	bb07054c 	bllt	1c1de4 <__bss_end+0x1b82d4>
 8b0:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 8b4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8b8:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 8bc:	01040200 	mrseq	r0, R12_usr
 8c0:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
 8c4:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
 8c8:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
 8cc:	03020568 	movweq	r0, #9576	; 0x2568
 8d0:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
 8d4:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
 8d8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8dc:	1605bd09 	strne	fp, [r5], -r9, lsl #26
 8e0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 8e4:	001d054a 	andseq	r0, sp, sl, asr #10
 8e8:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 8ec:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
 8f0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 8f4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 8f8:	11056602 	tstne	r5, r2, lsl #12
 8fc:	03040200 	movweq	r0, #16896	; 0x4200
 900:	0012054b 	andseq	r0, r2, fp, asr #10
 904:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 908:	02000805 	andeq	r0, r0, #327680	; 0x50000
 90c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 910:	04020009 	streq	r0, [r2], #-9
 914:	12052e03 	andne	r2, r5, #3, 28	; 0x30
 918:	03040200 	movweq	r0, #16896	; 0x4200
 91c:	000b054a 	andeq	r0, fp, sl, asr #10
 920:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 924:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 928:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 92c:	0402000b 	streq	r0, [r2], #-11
 930:	08058402 	stmdaeq	r5, {r1, sl, pc}
 934:	01040200 	mrseq	r0, R12_usr
 938:	00090583 	andeq	r0, r9, r3, lsl #11
 93c:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
 940:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 944:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 948:	04020002 	streq	r0, [r2], #-2
 94c:	0b054901 	bleq	152d58 <__bss_end+0x149248>
 950:	2f010585 	svccs	0x00010585
 954:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
 958:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 95c:	0b05bc20 	bleq	16f9e4 <__bss_end+0x165ed4>
 960:	4b1f0566 	blmi	7c1f00 <__bss_end+0x7b83f0>
 964:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
 968:	11054b08 	tstne	r5, r8, lsl #22
 96c:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
 970:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
 974:	0b056711 	bleq	15a5c0 <__bss_end+0x150ab0>
 978:	2f01054d 	svccs	0x0001054d
 97c:	83060585 	movwhi	r0, #25989	; 0x6585
 980:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 984:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
 988:	4b040566 	blmi	101f28 <__bss_end+0xf8418>
 98c:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
 990:	01053109 	tsteq	r5, r9, lsl #2
 994:	0805852f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 998:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
 99c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 9a0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 9a4:	04020007 	streq	r0, [r2], #-7
 9a8:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
 9ac:	02040200 	andeq	r0, r4, #0, 4
 9b0:	000a052e 	andeq	r0, sl, lr, lsr #10
 9b4:	4a020402 	bmi	819c4 <__bss_end+0x77eb4>
 9b8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 9bc:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 9c0:	05858401 	streq	r8, [r5, #1025]	; 0x401
 9c4:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
 9c8:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
 9cc:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 9d0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 9d4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 9d8:	17058302 	strne	r8, [r5, -r2, lsl #6]
 9dc:	02040200 	andeq	r0, r4, #0, 4
 9e0:	000a052e 	andeq	r0, sl, lr, lsr #10
 9e4:	4a020402 	bmi	819f4 <__bss_end+0x77ee4>
 9e8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 9ec:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 9f0:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 9f4:	0d054a02 	vstreq	s8, [r5, #-8]
 9f8:	02040200 	andeq	r0, r4, #0, 4
 9fc:	0002052e 	andeq	r0, r2, lr, lsr #10
 a00:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 a04:	85840105 	strhi	r0, [r4, #261]	; 0x105
 a08:	059f0b05 	ldreq	r0, [pc, #2821]	; 1515 <shift+0x1515>
 a0c:	1c054b16 			; <UNDEFINED> instruction: 0x1c054b16
 a10:	03040200 	movweq	r0, #16896	; 0x4200
 a14:	000b054a 	andeq	r0, fp, sl, asr #10
 a18:	83020402 	movwhi	r0, #9218	; 0x2402
 a1c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 a20:	05810204 	streq	r0, [r1, #516]	; 0x204
 a24:	0105850c 	tsteq	r5, ip, lsl #10
 a28:	1105854b 	tstne	r5, fp, asr #10
 a2c:	680c0584 	stmdavs	ip, {r2, r7, r8, sl}
 a30:	02001805 	andeq	r1, r0, #327680	; 0x50000
 a34:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 a38:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
 a3c:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 a40:	02040200 	andeq	r0, r4, #0, 4
 a44:	00160568 	andseq	r0, r6, r8, ror #10
 a48:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 a4c:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
 a50:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 a54:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 a58:	23052f02 	movwcs	r2, #24322	; 0x5f02
 a5c:	02040200 	andeq	r0, r4, #0, 4
 a60:	000e0566 	andeq	r0, lr, r6, ror #10
 a64:	66020402 	strvs	r0, [r2], -r2, lsl #8
 a68:	02000f05 	andeq	r0, r0, #5, 30
 a6c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a70:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
 a74:	11054a02 	tstne	r5, r2, lsl #20
 a78:	02040200 	andeq	r0, r4, #0, 4
 a7c:	0012052e 	andseq	r0, r2, lr, lsr #10
 a80:	2f020402 	svccs	0x00020402
 a84:	02001905 	andeq	r1, r0, #81920	; 0x14000
 a88:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 a8c:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 a90:	05056602 	streq	r6, [r5, #-1538]	; 0xfffff9fe
 a94:	02040200 	andeq	r0, r4, #0, 4
 a98:	88010562 	stmdahi	r1, {r1, r5, r6, r8, sl}
 a9c:	d7050569 	strle	r0, [r5, -r9, ror #10]
 aa0:	059f0905 	ldreq	r0, [pc, #2309]	; 13ad <shift+0x13ad>
 aa4:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 aa8:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 aac:	01040200 	mrseq	r0, R12_usr
 ab0:	9f090582 	svcls	0x00090582
 ab4:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 ab8:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 abc:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 ac0:	09058201 	stmdbeq	r5, {r0, r9, pc}
 ac4:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 ac8:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 acc:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 ad0:	05820104 	streq	r0, [r2, #260]	; 0x104
 ad4:	1a059f09 	bne	168700 <__bss_end+0x15ebf0>
 ad8:	01040200 	mrseq	r0, R12_usr
 adc:	002e059e 	mlaeq	lr, lr, r5, r0
 ae0:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 ae4:	059f0905 	ldreq	r0, [pc, #2309]	; 13f1 <shift+0x13f1>
 ae8:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 aec:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 af0:	01040200 	mrseq	r0, R12_usr
 af4:	9f090582 	svcls	0x00090582
 af8:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 afc:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b00:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b04:	05058201 	streq	r8, [r5, #-513]	; 0xfffffdff
 b08:	000f05a0 	andeq	r0, pc, r0, lsr #11
 b0c:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b10:	059f0905 	ldreq	r0, [pc, #2309]	; 141d <shift+0x141d>
 b14:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b18:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b1c:	01040200 	mrseq	r0, R12_usr
 b20:	9f090582 	svcls	0x00090582
 b24:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b28:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b2c:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b30:	09058201 	stmdbeq	r5, {r0, r9, pc}
 b34:	001a059f 	mulseq	sl, pc, r5	; <UNPREDICTABLE>
 b38:	9e010402 	cdpls	4, 0, cr0, cr1, cr2, {0}
 b3c:	02002e05 	andeq	r2, r0, #5, 28	; 0x50
 b40:	05820104 	streq	r0, [r2, #260]	; 0x104
 b44:	1a059f09 	bne	168770 <__bss_end+0x15ec60>
 b48:	01040200 	mrseq	r0, R12_usr
 b4c:	002e059e 	mlaeq	lr, lr, r5, r0
 b50:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 b54:	059f0905 	ldreq	r0, [pc, #2309]	; 1461 <shift+0x1461>
 b58:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 b5c:	2e059e01 	cdpcs	14, 0, cr9, cr5, cr1, {0}
 b60:	01040200 	mrseq	r0, R12_usr
 b64:	9f090582 	svcls	0x00090582
 b68:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 b6c:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
 b70:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 b74:	10058201 	andne	r8, r5, r1, lsl #4
 b78:	660e05a0 	strvs	r0, [lr], -r0, lsr #11
 b7c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 b80:	0b054a19 	bleq	1533ec <__bss_end+0x1498dc>
 b84:	670f0582 	strvs	r0, [pc, -r2, lsl #11]
 b88:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 b8c:	12054b19 	andne	r4, r5, #25600	; 0x6400
 b90:	4a11054a 	bmi	4420c0 <__bss_end+0x4385b0>
 b94:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 b98:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
 b9c:	76030905 	strvc	r0, [r3], -r5, lsl #18
 ba0:	4a10052e 	bmi	402060 <__bss_end+0x3f8550>
 ba4:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
 ba8:	15054a09 	strne	r4, [r5, #-2569]	; 0xfffff5f7
 bac:	670d0567 	strvs	r0, [sp, -r7, ror #10]
 bb0:	054a1505 	strbeq	r1, [sl, #-1285]	; 0xfffffafb
 bb4:	0d056710 	stceq	7, cr6, [r5, #-64]	; 0xffffffc0
 bb8:	4b1a054a 	blmi	6820e8 <__bss_end+0x6785d8>
 bbc:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 bc0:	01054a19 	tsteq	r5, r9, lsl sl
 bc4:	152e026a 	strne	r0, [lr, #-618]!	; 0xfffffd96
 bc8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 bcc:	15054b12 	strne	r4, [r5, #-2834]	; 0xfffff4ee
 bd0:	bb200566 	bllt	802170 <__bss_end+0x7f8660>
 bd4:	20082305 	andcs	r2, r8, r5, lsl #6
 bd8:	052e1205 	streq	r1, [lr, #-517]!	; 0xfffffdfb
 bdc:	23058214 	movwcs	r8, #21012	; 0x5214
 be0:	4a16054a 	bmi	582110 <__bss_end+0x578600>
 be4:	052f0b05 	streq	r0, [pc, #-2821]!	; e7 <shift+0xe7>
 be8:	06059c05 	streq	r9, [r5], -r5, lsl #24
 bec:	2e0b0532 	mcrcs	5, 0, r0, cr11, cr2, {1}
 bf0:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 bf4:	01054b08 	tsteq	r5, r8, lsl #22
 bf8:	0e05854b 	cfsh32eq	mvfx8, mvfx5, #43
 bfc:	d7010583 	strle	r0, [r1, -r3, lsl #11]
 c00:	830d0585 	movwhi	r0, #54661	; 0xd585
 c04:	a2d70105 	sbcsge	r0, r7, #1073741825	; 0x40000001
 c08:	059f0605 	ldreq	r0, [pc, #1541]	; 1215 <shift+0x1215>
 c0c:	056a8301 	strbeq	r8, [sl, #-769]!	; 0xfffffcff
 c10:	0505bb0f 	streq	fp, [r5, #-2831]	; 0xfffff4f1
 c14:	840c054b 	strhi	r0, [ip], #-1355	; 0xfffffab5
 c18:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c1c:	05054a10 	streq	r4, [r5, #-2576]	; 0xfffff5f0
 c20:	680d054b 	stmdavs	sp, {r0, r1, r3, r6, r8, sl}
 c24:	05660505 	strbeq	r0, [r6, #-1285]!	; 0xfffffafb
 c28:	0e054c0c 	cdpeq	12, 0, cr4, cr5, cr12, {0}
 c2c:	4a100566 	bmi	4021cc <__bss_end+0x3f86bc>
 c30:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c34:	1005660e 	andne	r6, r5, lr, lsl #12
 c38:	4b0c054a 	blmi	302168 <__bss_end+0x2f8658>
 c3c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c40:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c44:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c48:	054a1005 	strbeq	r1, [sl, #-5]
 c4c:	0d054b03 	vstreq	d4, [r5, #-12]
 c50:	66050530 			; <UNDEFINED> instruction: 0x66050530
 c54:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 c58:	1005660e 	andne	r6, r5, lr, lsl #12
 c5c:	4b0c054a 	blmi	30218c <__bss_end+0x2f867c>
 c60:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c64:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c68:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c6c:	054a1005 	strbeq	r1, [sl, #-5]
 c70:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c74:	4a100566 	bmi	402214 <__bss_end+0x3f8704>
 c78:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c7c:	02053006 	andeq	r3, r5, #6
 c80:	670d054b 	strvs	r0, [sp, -fp, asr #10]
 c84:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
 c88:	07059f0e 	streq	r9, [r5, -lr, lsl #30]
 c8c:	68180566 	ldmdavs	r8, {r1, r2, r5, r6, r8, sl}
 c90:	05833405 	streq	r3, [r3, #1029]	; 0x405
 c94:	44056633 	strmi	r6, [r5], #-1587	; 0xfffff9cd
 c98:	4a18054a 	bmi	6021c8 <__bss_end+0x5f86b8>
 c9c:	05690605 	strbeq	r0, [r9, #-1541]!	; 0xfffff9fb
 ca0:	0b059f1d 	bleq	16891c <__bss_end+0x15ee0c>
 ca4:	00140584 	andseq	r0, r4, r4, lsl #11
 ca8:	4a030402 	bmi	c1cb8 <__bss_end+0xb81a8>
 cac:	02000c05 	andeq	r0, r0, #1280	; 0x500
 cb0:	05840204 	streq	r0, [r4, #516]	; 0x204
 cb4:	0402000e 	streq	r0, [r2], #-14
 cb8:	1e056602 	cfmadd32ne	mvax0, mvfx6, mvfx5, mvfx2
 cbc:	02040200 	andeq	r0, r4, #0, 4
 cc0:	0010054a 	andseq	r0, r0, sl, asr #10
 cc4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 cc8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 ccc:	872c0204 	strhi	r0, [ip, -r4, lsl #4]!
 cd0:	05680c05 	strbeq	r0, [r8, #-3077]!	; 0xfffff3fb
 cd4:	1005660e 	andne	r6, r5, lr, lsl #12
 cd8:	4c1a054a 	cfldr32mi	mvfx0, [sl], {74}	; 0x4a
 cdc:	05a00c05 	streq	r0, [r0, #3077]!	; 0xc05
 ce0:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 ce4:	19054a01 	stmdbne	r5, {r0, r9, fp, lr}
 ce8:	82040568 	andhi	r0, r4, #104, 10	; 0x1a000000
 cec:	02000d05 	andeq	r0, r0, #320	; 0x140
 cf0:	054c0204 	strbeq	r0, [ip, #-516]	; 0xfffffdfc
 cf4:	0402000f 	streq	r0, [r2], #-15
 cf8:	24056602 	strcs	r6, [r5], #-1538	; 0xfffff9fe
 cfc:	02040200 	andeq	r0, r4, #0, 4
 d00:	0011054a 	andseq	r0, r1, sl, asr #10
 d04:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 d08:	02000305 	andeq	r0, r0, #335544320	; 0x14000000
 d0c:	052a0204 	streq	r0, [sl, #-516]!	; 0xfffffdfc
 d10:	0b058505 	bleq	16212c <__bss_end+0x15861c>
 d14:	02040200 	andeq	r0, r4, #0, 4
 d18:	000d0532 	andeq	r0, sp, r2, lsr r5
 d1c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 d20:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
 d24:	05830905 	streq	r0, [r3, #2309]	; 0x905
 d28:	07054a12 	smladeq	r5, r2, sl, r4
 d2c:	4a03054b 	bmi	c2260 <__bss_end+0xb8750>
 d30:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
 d34:	0c05670a 	stceq	7, cr6, [r5], {10}
 d38:	001c054c 	andseq	r0, ip, ip, asr #10
 d3c:	4a010402 	bmi	41d4c <__bss_end+0x3823c>
 d40:	02001d05 	andeq	r1, r0, #320	; 0x140
 d44:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 d48:	05054b09 	streq	r4, [r5, #-2825]	; 0xfffff4f7
 d4c:	0012054a 	andseq	r0, r2, sl, asr #10
 d50:	4b010402 	blmi	41d60 <__bss_end+0x38250>
 d54:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 d58:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
 d5c:	0905300d 	stmdbeq	r5, {r0, r2, r3, ip, sp}
 d60:	4b05054a 	blmi	142290 <__bss_end+0x138780>
 d64:	02001005 	andeq	r1, r0, #5
 d68:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 d6c:	1c056707 	stcne	7, cr6, [r5], {7}
 d70:	01040200 	mrseq	r0, R12_usr
 d74:	83110566 	tsthi	r1, #427819008	; 0x19800000
 d78:	05661b05 	strbeq	r1, [r6, #-2821]!	; 0xfffff4fb
 d7c:	0305660b 	movweq	r6, #22027	; 0x560b
 d80:	02040200 	andeq	r0, r4, #0, 4
 d84:	054a7803 	strbeq	r7, [sl, #-2051]	; 0xfffff7fd
 d88:	820b0310 	andhi	r0, fp, #16, 6	; 0x40000000
 d8c:	02670105 	rsbeq	r0, r7, #1073741825	; 0x40000001
 d90:	0101000c 	tsteq	r1, ip
 d94:	00000079 	andeq	r0, r0, r9, ror r0
 d98:	00460003 	subeq	r0, r6, r3
 d9c:	01020000 	mrseq	r0, (UNDEF: 2)
 da0:	000d0efb 	strdeq	r0, [sp], -fp
 da4:	01010101 	tsteq	r1, r1, lsl #2
 da8:	01000000 	mrseq	r0, (UNDEF: 0)
 dac:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 db0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 db4:	2f2e2e2f 	svccs	0x002e2e2f
 db8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dbc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dc0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 dc4:	2f636367 	svccs	0x00636367
 dc8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 dcc:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 dd0:	00006d72 	andeq	r6, r0, r2, ror sp
 dd4:	3162696c 	cmncc	r2, ip, ror #18
 dd8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 ddc:	00532e73 	subseq	r2, r3, r3, ror lr
 de0:	00000001 	andeq	r0, r0, r1
 de4:	f8020500 			; <UNDEFINED> instruction: 0xf8020500
 de8:	03000097 	movweq	r0, #151	; 0x97
 dec:	300108ca 	andcc	r0, r1, sl, asr #17
 df0:	2f2f2f2f 	svccs	0x002f2f2f
 df4:	d002302f 	andle	r3, r2, pc, lsr #32
 df8:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 dfc:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 e00:	1f03322f 	svcne	0x0003322f
 e04:	2f2f2f66 	svccs	0x002f2f66
 e08:	2f2f2f2f 	svccs	0x002f2f2f
 e0c:	01000202 	tsteq	r0, r2, lsl #4
 e10:	00005c01 	andeq	r5, r0, r1, lsl #24
 e14:	46000300 	strmi	r0, [r0], -r0, lsl #6
 e18:	02000000 	andeq	r0, r0, #0
 e1c:	0d0efb01 	vstreq	d15, [lr, #-4]
 e20:	01010100 	mrseq	r0, (UNDEF: 17)
 e24:	00000001 	andeq	r0, r0, r1
 e28:	01000001 	tsteq	r0, r1
 e2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e34:	2f2e2e2f 	svccs	0x002e2e2f
 e38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e3c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 e40:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 e44:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 e48:	2f676966 	svccs	0x00676966
 e4c:	006d7261 	rsbeq	r7, sp, r1, ror #4
 e50:	62696c00 	rsbvs	r6, r9, #0, 24
 e54:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 e58:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 e5c:	00000100 	andeq	r0, r0, r0, lsl #2
 e60:	02050000 	andeq	r0, r5, #0
 e64:	00009a04 	andeq	r9, r0, r4, lsl #20
 e68:	010bb403 	tsteq	fp, r3, lsl #8
 e6c:	01000202 	tsteq	r0, r2, lsl #4
 e70:	00010301 	andeq	r0, r1, r1, lsl #6
 e74:	fd000300 	stc2	3, cr0, [r0, #-0]
 e78:	02000000 	andeq	r0, r0, #0
 e7c:	0d0efb01 	vstreq	d15, [lr, #-4]
 e80:	01010100 	mrseq	r0, (UNDEF: 17)
 e84:	00000001 	andeq	r0, r0, r1
 e88:	01000001 	tsteq	r0, r1
 e8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e94:	2f2e2e2f 	svccs	0x002e2e2f
 e98:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e9c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 ea0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ea4:	2f2e2e2f 	svccs	0x002e2e2f
 ea8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 eac:	00656475 	rsbeq	r6, r5, r5, ror r4
 eb0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 eb4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 eb8:	2f2e2e2f 	svccs	0x002e2e2f
 ebc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ec0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 ec4:	2f2e2e00 	svccs	0x002e2e00
 ec8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ecc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ed0:	2f2e2e2f 	svccs	0x002e2e2f
 ed4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e24 <shift+0xe24>
 ed8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 edc:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 ee0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 ee4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 ee8:	2f676966 	svccs	0x00676966
 eec:	006d7261 	rsbeq	r7, sp, r1, ror #4
 ef0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ef4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ef8:	2f2e2e2f 	svccs	0x002e2e2f
 efc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 f00:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 f04:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 f08:	61680000 	cmnvs	r8, r0
 f0c:	61746873 	cmnvs	r4, r3, ror r8
 f10:	00682e62 	rsbeq	r2, r8, r2, ror #28
 f14:	61000001 	tstvs	r0, r1
 f18:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 f1c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 f20:	00000200 	andeq	r0, r0, r0, lsl #4
 f24:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 f28:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 f2c:	00020068 	andeq	r0, r2, r8, rrx
 f30:	736e6900 	cmnvc	lr, #0, 18
 f34:	6f632d6e 	svcvs	0x00632d6e
 f38:	6174736e 	cmnvs	r4, lr, ror #6
 f3c:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 f40:	00020068 	andeq	r0, r2, r8, rrx
 f44:	6d726100 	ldfvse	f6, [r2, #-0]
 f48:	0300682e 	movweq	r6, #2094	; 0x82e
 f4c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 f50:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 f54:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 f58:	67000004 	strvs	r0, [r0, -r4]
 f5c:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 f60:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 f64:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 f68:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 f6c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 f70:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 f74:	00000004 	andeq	r0, r0, r4

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
      58:	04e10704 	strbteq	r0, [r1], #1796	; 0x704
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
     128:	000004e1 	andeq	r0, r0, r1, ror #9
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408670>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36684>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a348>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x36754>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f697c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000e85 	andeq	r0, r0, r5, lsl #29
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0007fe04 	andeq	pc, r7, r4, lsl #28
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00019400 	andeq	r9, r1, r0, lsl #8
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	0c240200 	sfmeq	f0, 4, [r4], #-0
     2fc:	04030000 	streq	r0, [r3], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	08030500 	stmdaeq	r3, {r8, sl}
     308:	0300009a 	movweq	r0, #154	; 0x9a
     30c:	1c050404 	cfstrsne	mvf0, [r5], {4}
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0d780801 	ldcleq	8, cr0, [r8, #-4]!
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0dec0502 	cfstr64eq	mvdx0, [ip, #8]!
     328:	75050000 	strvc	r0, [r5, #-0]
     32c:	0200000e 	andeq	r0, r0, #14
     330:	00670705 	rsbeq	r0, r7, r5, lsl #14
     334:	56040000 	strpl	r0, [r4], -r0
     338:	06000000 	streq	r0, [r0], -r0
     33c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     340:	08030074 	stmdaeq	r3, {r2, r4, r5, r6}
     344:	00031f05 	andeq	r1, r3, r5, lsl #30
     348:	08010300 	stmdaeq	r1, {r8, r9}
     34c:	00000d6f 	andeq	r0, r0, pc, ror #26
     350:	e2070203 	and	r0, r7, #805306368	; 0x30000000
     354:	05000009 	streq	r0, [r0, #-9]
     358:	00000e74 	andeq	r0, r0, r4, ror lr
     35c:	94070a02 	strls	r0, [r7], #-2562	; 0xfffff5fe
     360:	04000000 	streq	r0, [r0], #-0
     364:	00000083 	andeq	r0, r0, r3, lsl #1
     368:	e1070403 	tst	r7, r3, lsl #8
     36c:	04000004 	streq	r0, [r0], #-4
     370:	00000094 	muleq	r0, r4, r0
     374:	00009407 	andeq	r9, r0, r7, lsl #8
     378:	07080300 	streq	r0, [r8, -r0, lsl #6]
     37c:	000004d7 	ldrdeq	r0, [r0], -r7
     380:	0007df02 	andeq	sp, r7, r2, lsl #30
     384:	130d0200 	movwne	r0, #53760	; 0xd200
     388:	00000062 	andeq	r0, r0, r2, rrx
     38c:	9a0c0305 	bls	300fa8 <__bss_end+0x2f7498>
     390:	c9020000 	stmdbgt	r2, {}	; <UNPREDICTABLE>
     394:	02000008 	andeq	r0, r0, #8
     398:	0062130e 	rsbeq	r1, r2, lr, lsl #6
     39c:	03050000 	movweq	r0, #20480	; 0x5000
     3a0:	00009a10 	andeq	r9, r0, r0, lsl sl
     3a4:	0007de02 	andeq	sp, r7, r2, lsl #28
     3a8:	14100200 	ldrne	r0, [r0], #-512	; 0xfffffe00
     3ac:	0000008f 	andeq	r0, r0, pc, lsl #1
     3b0:	9a140305 	bls	500fcc <__bss_end+0x4f74bc>
     3b4:	c8020000 	stmdagt	r2, {}	; <UNPREDICTABLE>
     3b8:	02000008 	andeq	r0, r0, #8
     3bc:	008f1411 	addeq	r1, pc, r1, lsl r4	; <UNPREDICTABLE>
     3c0:	03050000 	movweq	r0, #20480	; 0x5000
     3c4:	00009a18 	andeq	r9, r0, r8, lsl sl
     3c8:	00072408 	andeq	r2, r7, r8, lsl #8
     3cc:	06040800 	streq	r0, [r4], -r0, lsl #16
     3d0:	00011a08 	andeq	r1, r1, r8, lsl #20
     3d4:	30720900 	rsbscc	r0, r2, r0, lsl #18
     3d8:	0e080400 	cfcpyseq	mvf0, mvf8
     3dc:	00000083 	andeq	r0, r0, r3, lsl #1
     3e0:	31720900 	cmncc	r2, r0, lsl #18
     3e4:	0e090400 	cfcpyseq	mvf0, mvf9
     3e8:	00000083 	andeq	r0, r0, r3, lsl #1
     3ec:	830a0004 	movwhi	r0, #40964	; 0xa004
     3f0:	05000005 	streq	r0, [r0, #-5]
     3f4:	00006704 	andeq	r6, r0, r4, lsl #14
     3f8:	0c1e0400 	cfldrseq	mvf0, [lr], {-0}
     3fc:	00000151 	andeq	r0, r0, r1, asr r1
     400:	0012440b 	andseq	r4, r2, fp, lsl #8
     404:	820b0000 	andhi	r0, fp, #0
     408:	01000012 	tsteq	r0, r2, lsl r0
     40c:	00124c0b 	andseq	r4, r2, fp, lsl #24
     410:	6c0b0200 	sfmvs	f0, 4, [fp], {-0}
     414:	0300000a 	movweq	r0, #10
     418:	000ce00b 	andeq	lr, ip, fp
     41c:	a70b0400 	strge	r0, [fp, -r0, lsl #8]
     420:	05000007 	streq	r0, [r0, #-7]
     424:	11390a00 	teqne	r9, r0, lsl #20
     428:	04050000 	streq	r0, [r5], #-0
     42c:	00000067 	andeq	r0, r0, r7, rrx
     430:	8e0c4404 	cdphi	4, 0, cr4, cr12, cr4, {0}
     434:	0b000001 	bleq	440 <shift+0x440>
     438:	0000041b 	andeq	r0, r0, fp, lsl r4
     43c:	05bf0b00 	ldreq	r0, [pc, #2816]!	; f44 <shift+0xf44>
     440:	0b010000 	bleq	40448 <__bss_end+0x36938>
     444:	00000c88 	andeq	r0, r0, r8, lsl #25
     448:	11ed0b02 	mvnne	r0, r2, lsl #22
     44c:	0b030000 	bleq	c0454 <__bss_end+0xb6944>
     450:	0000128c 	andeq	r1, r0, ip, lsl #5
     454:	0b990b04 	bleq	fe64306c <__bss_end+0xfe63955c>
     458:	0b050000 	bleq	140460 <__bss_end+0x136950>
     45c:	00000a02 	andeq	r0, r0, r2, lsl #20
     460:	1c050006 	stcne	0, cr0, [r5], {6}
     464:	05000006 	streq	r0, [r0, #-6]
     468:	00670703 	rsbeq	r0, r7, r3, lsl #14
     46c:	f1020000 	cps	#0
     470:	0500000b 	streq	r0, [r0, #-11]
     474:	008f1405 	addeq	r1, pc, r5, lsl #8
     478:	03050000 	movweq	r0, #20480	; 0x5000
     47c:	00009a1c 	andeq	r9, r0, ip, lsl sl
     480:	000c4002 	andeq	r4, ip, r2
     484:	14060500 	strne	r0, [r6], #-1280	; 0xfffffb00
     488:	0000008f 	andeq	r0, r0, pc, lsl #1
     48c:	9a200305 	bls	8010a8 <__bss_end+0x7f7598>
     490:	83020000 	movwhi	r0, #8192	; 0x2000
     494:	0600000b 	streq	r0, [r0], -fp
     498:	008f1a07 	addeq	r1, pc, r7, lsl #20
     49c:	03050000 	movweq	r0, #20480	; 0x5000
     4a0:	00009a24 	andeq	r9, r0, r4, lsr #20
     4a4:	0005ee02 	andeq	lr, r5, r2, lsl #28
     4a8:	1a090600 	bne	241cb0 <__bss_end+0x2381a0>
     4ac:	0000008f 	andeq	r0, r0, pc, lsl #1
     4b0:	9a280305 	bls	a010cc <__bss_end+0x9f75bc>
     4b4:	61020000 	mrsvs	r0, (UNDEF: 2)
     4b8:	0600000d 	streq	r0, [r0], -sp
     4bc:	008f1a0b 	addeq	r1, pc, fp, lsl #20
     4c0:	03050000 	movweq	r0, #20480	; 0x5000
     4c4:	00009a2c 	andeq	r9, r0, ip, lsr #20
     4c8:	0009bc02 	andeq	fp, r9, r2, lsl #24
     4cc:	1a0d0600 	bne	341cd4 <__bss_end+0x3381c4>
     4d0:	0000008f 	andeq	r0, r0, pc, lsl #1
     4d4:	9a300305 	bls	c010f0 <__bss_end+0xbf75e0>
     4d8:	4f020000 	svcmi	0x00020000
     4dc:	06000007 	streq	r0, [r0], -r7
     4e0:	008f1a0f 	addeq	r1, pc, pc, lsl #20
     4e4:	03050000 	movweq	r0, #20480	; 0x5000
     4e8:	00009a34 	andeq	r9, r0, r4, lsr sl
     4ec:	000ed40a 	andeq	sp, lr, sl, lsl #8
     4f0:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     4f4:	06000000 	streq	r0, [r0], -r0
     4f8:	023d0c1b 	eorseq	r0, sp, #6912	; 0x1b00
     4fc:	400b0000 	andmi	r0, fp, r0
     500:	0000000f 	andeq	r0, r0, pc
     504:	0012390b 	andseq	r3, r2, fp, lsl #18
     508:	830b0100 	movwhi	r0, #45312	; 0xb100
     50c:	0200000c 	andeq	r0, r0, #12
     510:	0d3d0c00 	ldceq	12, cr0, [sp, #-0]
     514:	d10d0000 	mrsle	r0, (UNDEF: 13)
     518:	9000000d 	andls	r0, r0, sp
     51c:	b0076306 	andlt	r6, r7, r6, lsl #6
     520:	08000003 	stmdaeq	r0, {r0, r1}
     524:	0000118f 	andeq	r1, r0, pc, lsl #3
     528:	10670624 	rsbne	r0, r7, r4, lsr #12
     52c:	000002ca 	andeq	r0, r0, sl, asr #5
     530:	0021940e 	eoreq	r9, r1, lr, lsl #8
     534:	12690600 	rsbne	r0, r9, #0, 12
     538:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
     53c:	05770e00 	ldrbeq	r0, [r7, #-3584]!	; 0xfffff200
     540:	6b060000 	blvs	180548 <__bss_end+0x176a38>
     544:	0003c012 	andeq	ip, r3, r2, lsl r0
     548:	350e1000 	strcc	r1, [lr, #-0]
     54c:	0600000f 	streq	r0, [r0], -pc
     550:	0083166d 	addeq	r1, r3, sp, ror #12
     554:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     558:	000005e7 	andeq	r0, r0, r7, ror #11
     55c:	c71c7006 	ldrgt	r7, [ip, -r6]
     560:	18000003 	stmdane	r0, {r0, r1}
     564:	000d580e 	andeq	r5, sp, lr, lsl #16
     568:	1c720600 	ldclne	6, cr0, [r2], #-0
     56c:	000003c7 	andeq	r0, r0, r7, asr #7
     570:	05540e1c 	ldrbeq	r0, [r4, #-3612]	; 0xfffff1e4
     574:	75060000 	strvc	r0, [r6, #-0]
     578:	0003c71c 	andeq	ip, r3, ip, lsl r7
     57c:	f30f2000 	vhadd.u8	d2, d15, d0
     580:	06000007 	streq	r0, [r0], -r7
     584:	04671c77 	strbteq	r1, [r7], #-3191	; 0xfffff389
     588:	03c70000 	biceq	r0, r7, #0
     58c:	02be0000 	adcseq	r0, lr, #0
     590:	c7100000 	ldrgt	r0, [r0, -r0]
     594:	11000003 	tstne	r0, r3
     598:	000003cd 	andeq	r0, r0, sp, asr #7
     59c:	f6080000 			; <UNDEFINED> instruction: 0xf6080000
     5a0:	1800000d 	stmdane	r0, {r0, r2, r3}
     5a4:	ff107b06 			; <UNDEFINED> instruction: 0xff107b06
     5a8:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     5ac:	00002194 	muleq	r0, r4, r1
     5b0:	b0127e06 	andslt	r7, r2, r6, lsl #28
     5b4:	00000003 	andeq	r0, r0, r3
     5b8:	00056c0e 	andeq	r6, r5, lr, lsl #24
     5bc:	19800600 	stmibne	r0, {r9, sl}
     5c0:	000003cd 	andeq	r0, r0, sp, asr #7
     5c4:	11f30e10 	mvnsne	r0, r0, lsl lr
     5c8:	82060000 	andhi	r0, r6, #0
     5cc:	0003d821 	andeq	sp, r3, r1, lsr #16
     5d0:	04001400 	streq	r1, [r0], #-1024	; 0xfffffc00
     5d4:	000002ca 	andeq	r0, r0, sl, asr #5
     5d8:	000b2d12 	andeq	r2, fp, r2, lsl sp
     5dc:	21860600 	orrcs	r0, r6, r0, lsl #12
     5e0:	000003de 	ldrdeq	r0, [r0], -lr
     5e4:	0008e212 	andeq	lr, r8, r2, lsl r2
     5e8:	1f880600 	svcne	0x00880600
     5ec:	0000008f 	andeq	r0, r0, pc, lsl #1
     5f0:	000e280e 	andeq	r2, lr, lr, lsl #16
     5f4:	178b0600 	strne	r0, [fp, r0, lsl #12]
     5f8:	0000024f 	andeq	r0, r0, pc, asr #4
     5fc:	0a720e00 	beq	1c83e04 <__bss_end+0x1c7a2f4>
     600:	8e060000 	cdphi	0, 0, cr0, cr6, cr0, {0}
     604:	00024f17 	andeq	r4, r2, r7, lsl pc
     608:	4d0e2400 	cfstrsmi	mvf2, [lr, #-0]
     60c:	06000009 	streq	r0, [r0], -r9
     610:	024f178f 	subeq	r1, pc, #37486592	; 0x23c0000
     614:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     618:	0000126c 	andeq	r1, r0, ip, ror #4
     61c:	4f179006 	svcmi	0x00179006
     620:	6c000002 	stcvs	0, cr0, [r0], {2}
     624:	000dd113 	andeq	sp, sp, r3, lsl r1
     628:	09930600 	ldmibeq	r3, {r9, sl}
     62c:	00000655 	andeq	r0, r0, r5, asr r6
     630:	000003e9 	andeq	r0, r0, r9, ror #7
     634:	00036901 	andeq	r6, r3, r1, lsl #18
     638:	00036f00 	andeq	r6, r3, r0, lsl #30
     63c:	03e91000 	mvneq	r1, #0
     640:	14000000 	strne	r0, [r0], #-0
     644:	00000b22 	andeq	r0, r0, r2, lsr #22
     648:	280e9606 	stmdacs	lr, {r1, r2, r9, sl, ip, pc}
     64c:	0100000a 	tsteq	r0, sl
     650:	00000384 	andeq	r0, r0, r4, lsl #7
     654:	0000038a 	andeq	r0, r0, sl, lsl #7
     658:	0003e910 	andeq	lr, r3, r0, lsl r9
     65c:	1b150000 	blne	540664 <__bss_end+0x536b54>
     660:	06000004 	streq	r0, [r0], -r4
     664:	0eb91099 	mrceq	0, 5, r1, cr9, cr9, {4}
     668:	03ef0000 	mvneq	r0, #0
     66c:	9f010000 	svcls	0x00010000
     670:	10000003 	andne	r0, r0, r3
     674:	000003e9 	andeq	r0, r0, r9, ror #7
     678:	0003cd11 	andeq	ip, r3, r1, lsl sp
     67c:	02181100 	andseq	r1, r8, #0, 2
     680:	00000000 	andeq	r0, r0, r0
     684:	00004316 	andeq	r4, r0, r6, lsl r3
     688:	0003c000 	andeq	ip, r3, r0
     68c:	00941700 	addseq	r1, r4, r0, lsl #14
     690:	000f0000 	andeq	r0, pc, r0
     694:	89020103 	stmdbhi	r2, {r0, r1, r8}
     698:	1800000a 	stmdane	r0, {r1, r3}
     69c:	00024f04 	andeq	r4, r2, r4, lsl #30
     6a0:	4a041800 	bmi	1066a8 <__bss_end+0xfcb98>
     6a4:	0c000000 	stceq	0, cr0, [r0], {-0}
     6a8:	000011ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
     6ac:	03d30418 	bicseq	r0, r3, #24, 8	; 0x18000000
     6b0:	ff160000 			; <UNDEFINED> instruction: 0xff160000
     6b4:	e9000002 	stmdb	r0, {r1}
     6b8:	19000003 	stmdbne	r0, {r0, r1}
     6bc:	42041800 	andmi	r1, r4, #0, 16
     6c0:	18000002 	stmdane	r0, {r1}
     6c4:	00023d04 	andeq	r3, r2, r4, lsl #26
     6c8:	0e2e1a00 	vmuleq.f32	s2, s28, s0
     6cc:	9c060000 	stcls	0, cr0, [r6], {-0}
     6d0:	00024214 	andeq	r4, r2, r4, lsl r2
     6d4:	08830200 	stmeq	r3, {r9}
     6d8:	04070000 	streq	r0, [r7], #-0
     6dc:	00008f14 	andeq	r8, r0, r4, lsl pc
     6e0:	38030500 	stmdacc	r3, {r8, sl}
     6e4:	0200009a 	andeq	r0, r0, #154	; 0x9a
     6e8:	000003a6 	andeq	r0, r0, r6, lsr #7
     6ec:	8f140707 	svchi	0x00140707
     6f0:	05000000 	streq	r0, [r0, #-0]
     6f4:	009a3c03 	addseq	r3, sl, r3, lsl #24
     6f8:	06310200 	ldrteq	r0, [r1], -r0, lsl #4
     6fc:	0a070000 	beq	1c0704 <__bss_end+0x1b6bf4>
     700:	00008f14 	andeq	r8, r0, r4, lsl pc
     704:	40030500 	andmi	r0, r3, r0, lsl #10
     708:	0a00009a 	beq	978 <shift+0x978>
     70c:	00000af2 	strdeq	r0, [r0], -r2
     710:	00670405 	rsbeq	r0, r7, r5, lsl #8
     714:	0d070000 	stceq	0, cr0, [r7, #-0]
     718:	00046e0c 	andeq	r6, r4, ip, lsl #28
     71c:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     720:	0b000077 	bleq	904 <shift+0x904>
     724:	00000ae9 	andeq	r0, r0, r9, ror #21
     728:	0e400b01 	vmlaeq.f64	d16, d0, d1
     72c:	0b020000 	bleq	80734 <__bss_end+0x76c24>
     730:	00000aa4 	andeq	r0, r0, r4, lsr #21
     734:	0a5e0b03 	beq	1783348 <__bss_end+0x1779838>
     738:	0b040000 	bleq	100740 <__bss_end+0xf6c30>
     73c:	00000c8e 	andeq	r0, r0, lr, lsl #25
     740:	9a080005 	bls	20075c <__bss_end+0x1f6c4c>
     744:	10000007 	andne	r0, r0, r7
     748:	ad081b07 	vstrge	d1, [r8, #-28]	; 0xffffffe4
     74c:	09000004 	stmdbeq	r0, {r2}
     750:	0700726c 	streq	r7, [r0, -ip, ror #4]
     754:	04ad131d 	strteq	r1, [sp], #797	; 0x31d
     758:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     75c:	07007073 	smlsdxeq	r0, r3, r0, r7
     760:	04ad131e 	strteq	r1, [sp], #798	; 0x31e
     764:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     768:	07006370 	smlsdxeq	r0, r0, r3, r6
     76c:	04ad131f 	strteq	r1, [sp], #799	; 0x31f
     770:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     774:	000007b0 			; <UNDEFINED> instruction: 0x000007b0
     778:	ad132007 	ldcge	0, cr2, [r3, #-28]	; 0xffffffe4
     77c:	0c000004 	stceq	0, cr0, [r0], {4}
     780:	07040300 	streq	r0, [r4, -r0, lsl #6]
     784:	000004dc 	ldrdeq	r0, [r0], -ip
     788:	0004ad04 	andeq	sl, r4, r4, lsl #26
     78c:	045a0800 	ldrbeq	r0, [sl], #-2048	; 0xfffff800
     790:	07700000 	ldrbeq	r0, [r0, -r0]!
     794:	05490828 	strbeq	r0, [r9, #-2088]	; 0xfffff7d8
     798:	760e0000 	strvc	r0, [lr], -r0
     79c:	07000012 	smladeq	r0, r2, r0, r0
     7a0:	046e122a 	strbteq	r1, [lr], #-554	; 0xfffffdd6
     7a4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     7a8:	00646970 	rsbeq	r6, r4, r0, ror r9
     7ac:	94122b07 	ldrls	r2, [r2], #-2823	; 0xfffff4f9
     7b0:	10000000 	andne	r0, r0, r0
     7b4:	001b870e 	andseq	r8, fp, lr, lsl #14
     7b8:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
     7bc:	00000437 	andeq	r0, r0, r7, lsr r4
     7c0:	0afe0e14 	beq	fff84018 <__bss_end+0xfff7a508>
     7c4:	2d070000 	stccs	0, cr0, [r7, #-0]
     7c8:	00009412 	andeq	r9, r0, r2, lsl r4
     7cc:	0c0e1800 	stceq	8, cr1, [lr], {-0}
     7d0:	0700000b 	streq	r0, [r0, -fp]
     7d4:	0094122e 	addseq	r1, r4, lr, lsr #4
     7d8:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     7dc:	0000073d 	andeq	r0, r0, sp, lsr r7
     7e0:	490c2f07 	stmdbmi	ip, {r0, r1, r2, r8, r9, sl, fp, sp}
     7e4:	20000005 	andcs	r0, r0, r5
     7e8:	000b390e 	andeq	r3, fp, lr, lsl #18
     7ec:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
     7f0:	00000067 	andeq	r0, r0, r7, rrx
     7f4:	0f5f0e60 	svceq	0x005f0e60
     7f8:	31070000 	mrscc	r0, (UNDEF: 7)
     7fc:	0000830e 	andeq	r8, r0, lr, lsl #6
     800:	a50e6400 	strge	r6, [lr, #-1024]	; 0xfffffc00
     804:	07000004 	streq	r0, [r0, -r4]
     808:	00830e33 	addeq	r0, r3, r3, lsr lr
     80c:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     810:	0000049c 	muleq	r0, ip, r4
     814:	830e3407 	movwhi	r3, #58375	; 0xe407
     818:	6c000000 	stcvs	0, cr0, [r0], {-0}
     81c:	03ef1600 	mvneq	r1, #0, 12
     820:	05590000 	ldrbeq	r0, [r9, #-0]
     824:	94170000 	ldrls	r0, [r7], #-0
     828:	0f000000 	svceq	0x00000000
     82c:	11800200 	orrne	r0, r0, r0, lsl #4
     830:	0a080000 	beq	200838 <__bss_end+0x1f6d28>
     834:	00008f14 	andeq	r8, r0, r4, lsl pc
     838:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
     83c:	0a00009a 	beq	aac <shift+0xaac>
     840:	00000aac 	andeq	r0, r0, ip, lsr #21
     844:	00670405 	rsbeq	r0, r7, r5, lsl #8
     848:	0d080000 	stceq	0, cr0, [r8, #-0]
     84c:	00058a0c 	andeq	r8, r5, ip, lsl #20
     850:	05980b00 	ldreq	r0, [r8, #2816]	; 0xb00
     854:	0b000000 	bleq	85c <shift+0x85c>
     858:	0000039b 	muleq	r0, fp, r3
     85c:	4c080001 	stcmi	0, cr0, [r8], {1}
     860:	0c000010 	stceq	0, cr0, [r0], {16}
     864:	bf081b08 	svclt	0x00081b08
     868:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     86c:	0000042c 	andeq	r0, r0, ip, lsr #8
     870:	bf191d08 	svclt	0x00191d08
     874:	00000005 	andeq	r0, r0, r5
     878:	0005540e 	andeq	r5, r5, lr, lsl #8
     87c:	191e0800 	ldmdbne	lr, {fp}
     880:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
     884:	0fd30e04 	svceq	0x00d30e04
     888:	1f080000 	svcne	0x00080000
     88c:	0005c513 	andeq	ip, r5, r3, lsl r5
     890:	18000800 	stmdane	r0, {fp}
     894:	00058a04 	andeq	r8, r5, r4, lsl #20
     898:	b9041800 	stmdblt	r4, {fp, ip}
     89c:	0d000004 	stceq	0, cr0, [r0, #-16]
     8a0:	00000644 	andeq	r0, r0, r4, asr #12
     8a4:	07220814 			; <UNDEFINED> instruction: 0x07220814
     8a8:	0000084d 	andeq	r0, r0, sp, asr #16
     8ac:	000a9a0e 	andeq	r9, sl, lr, lsl #20
     8b0:	12260800 	eorne	r0, r6, #0, 16
     8b4:	00000083 	andeq	r0, r0, r3, lsl #1
     8b8:	04ee0e00 	strbteq	r0, [lr], #3584	; 0xe00
     8bc:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
     8c0:	0005bf1d 	andeq	fp, r5, sp, lsl pc
     8c4:	a60e0400 	strge	r0, [lr], -r0, lsl #8
     8c8:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     8cc:	05bf1d2c 	ldreq	r1, [pc, #3372]!	; 1600 <shift+0x1600>
     8d0:	1c080000 	stcne	0, cr0, [r8], {-0}
     8d4:	0000112f 	andeq	r1, r0, pc, lsr #2
     8d8:	290e2f08 	stmdbcs	lr, {r3, r8, r9, sl, fp, sp}
     8dc:	13000010 	movwne	r0, #16
     8e0:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
     8e4:	10000006 	andne	r0, r0, r6
     8e8:	00000852 	andeq	r0, r0, r2, asr r8
     8ec:	0005bf11 	andeq	fp, r5, r1, lsl pc
     8f0:	e21d0000 	ands	r0, sp, #0
     8f4:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     8f8:	04310e31 	ldrteq	r0, [r1], #-3633	; 0xfffff1cf
     8fc:	03c00000 	biceq	r0, r0, #0
     900:	06360000 	ldrteq	r0, [r6], -r0
     904:	06410000 	strbeq	r0, [r1], -r0
     908:	52100000 	andspl	r0, r0, #0
     90c:	11000008 	tstne	r0, r8
     910:	000005c5 	andeq	r0, r0, r5, asr #11
     914:	108e1300 	addne	r1, lr, r0, lsl #6
     918:	35080000 	strcc	r0, [r8, #-0]
     91c:	000fae1d 	andeq	sl, pc, sp, lsl lr	; <UNPREDICTABLE>
     920:	0005bf00 	andeq	fp, r5, r0, lsl #30
     924:	065a0200 	ldrbeq	r0, [sl], -r0, lsl #4
     928:	06600000 	strbteq	r0, [r0], -r0
     92c:	52100000 	andspl	r0, r0, #0
     930:	00000008 	andeq	r0, r0, r8
     934:	0009f513 	andeq	pc, r9, r3, lsl r5	; <UNPREDICTABLE>
     938:	1d370800 	ldcne	8, cr0, [r7, #-0]
     93c:	00000dab 	andeq	r0, r0, fp, lsr #27
     940:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
     944:	00067902 	andeq	r7, r6, r2, lsl #18
     948:	00067f00 	andeq	r7, r6, r0, lsl #30
     94c:	08521000 	ldmdaeq	r2, {ip}^
     950:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     954:	00000b69 	andeq	r0, r0, r9, ror #22
     958:	6b313908 	blvs	c4ed80 <__bss_end+0xc45270>
     95c:	0c000008 	stceq	0, cr0, [r0], {8}
     960:	06441302 	strbeq	r1, [r4], -r2, lsl #6
     964:	3c080000 	stccc	0, cr0, [r8], {-0}
     968:	00125209 	andseq	r5, r2, r9, lsl #4
     96c:	00085200 	andeq	r5, r8, r0, lsl #4
     970:	06a60100 	strteq	r0, [r6], r0, lsl #2
     974:	06ac0000 	strteq	r0, [ip], r0
     978:	52100000 	andspl	r0, r0, #0
     97c:	00000008 	andeq	r0, r0, r8
     980:	0005d213 	andeq	sp, r5, r3, lsl r2
     984:	123f0800 	eorsne	r0, pc, #0, 16
     988:	00001104 	andeq	r1, r0, r4, lsl #2
     98c:	00000083 	andeq	r0, r0, r3, lsl #1
     990:	0006c501 	andeq	ip, r6, r1, lsl #10
     994:	0006da00 	andeq	sp, r6, r0, lsl #20
     998:	08521000 	ldmdaeq	r2, {ip}^
     99c:	74110000 	ldrvc	r0, [r1], #-0
     9a0:	11000008 	tstne	r0, r8
     9a4:	00000094 	muleq	r0, r4, r0
     9a8:	0003c011 	andeq	ip, r3, r1, lsl r0
     9ac:	f1140000 			; <UNDEFINED> instruction: 0xf1140000
     9b0:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     9b4:	0cef0e42 	stcleq	14, cr0, [pc], #264	; ac4 <shift+0xac4>
     9b8:	ef010000 	svc	0x00010000
     9bc:	f5000006 			; <UNDEFINED> instruction: 0xf5000006
     9c0:	10000006 	andne	r0, r0, r6
     9c4:	00000852 	andeq	r0, r0, r2, asr r8
     9c8:	09571300 	ldmdbeq	r7, {r8, r9, ip}^
     9cc:	45080000 	strmi	r0, [r8, #-0]
     9d0:	00051317 	andeq	r1, r5, r7, lsl r3
     9d4:	0005c500 	andeq	ip, r5, r0, lsl #10
     9d8:	070e0100 	streq	r0, [lr, -r0, lsl #2]
     9dc:	07140000 	ldreq	r0, [r4, -r0]
     9e0:	7a100000 	bvc	4009e8 <__bss_end+0x3f6ed8>
     9e4:	00000008 	andeq	r0, r0, r8
     9e8:	00055913 	andeq	r5, r5, r3, lsl r9
     9ec:	17480800 	strbne	r0, [r8, -r0, lsl #16]
     9f0:	00000f6b 	andeq	r0, r0, fp, ror #30
     9f4:	000005c5 	andeq	r0, r0, r5, asr #11
     9f8:	00072d01 	andeq	r2, r7, r1, lsl #26
     9fc:	00073800 	andeq	r3, r7, r0, lsl #16
     a00:	087a1000 	ldmdaeq	sl!, {ip}^
     a04:	83110000 	tsthi	r1, #0
     a08:	00000000 	andeq	r0, r0, r0
     a0c:	00119d14 	andseq	r9, r1, r4, lsl sp
     a10:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
     a14:	00000ffa 	strdeq	r0, [r0], -sl
     a18:	00074d01 	andeq	r4, r7, r1, lsl #26
     a1c:	00075300 	andeq	r5, r7, r0, lsl #6
     a20:	08521000 	ldmdaeq	r2, {ip}^
     a24:	13000000 	movwne	r0, #0
     a28:	00000fe2 	andeq	r0, r0, r2, ror #31
     a2c:	b60e4d08 	strlt	r4, [lr], -r8, lsl #26
     a30:	c0000007 	andgt	r0, r0, r7
     a34:	01000003 	tsteq	r0, r3
     a38:	0000076c 	andeq	r0, r0, ip, ror #14
     a3c:	00000777 	andeq	r0, r0, r7, ror r7
     a40:	00085210 	andeq	r5, r8, r0, lsl r2
     a44:	00831100 	addeq	r1, r3, r0, lsl #2
     a48:	13000000 	movwne	r0, #0
     a4c:	0000096b 	andeq	r0, r0, fp, ror #18
     a50:	10125008 	andsne	r5, r2, r8
     a54:	8300000d 	movwhi	r0, #13
     a58:	01000000 	mrseq	r0, (UNDEF: 0)
     a5c:	00000790 	muleq	r0, r0, r7
     a60:	0000079b 	muleq	r0, fp, r7
     a64:	00085210 	andeq	r5, r8, r0, lsl r2
     a68:	03ef1100 	mvneq	r1, #0, 2
     a6c:	13000000 	movwne	r0, #0
     a70:	00000ba0 	andeq	r0, r0, r0, lsr #23
     a74:	9c0e5308 	stcls	3, cr5, [lr], {8}
     a78:	c0000008 	andgt	r0, r0, r8
     a7c:	01000003 	tsteq	r0, r3
     a80:	000007b4 			; <UNDEFINED> instruction: 0x000007b4
     a84:	000007bf 			; <UNDEFINED> instruction: 0x000007bf
     a88:	00085210 	andeq	r5, r8, r0, lsl r2
     a8c:	00831100 	addeq	r1, r3, r0, lsl #2
     a90:	14000000 	strne	r0, [r0], #-0
     a94:	000009cf 	andeq	r0, r0, pc, asr #19
     a98:	ad0e5608 	stcge	6, cr5, [lr, #-32]	; 0xffffffe0
     a9c:	01000010 	tsteq	r0, r0, lsl r0
     aa0:	000007d4 	ldrdeq	r0, [r0], -r4
     aa4:	000007f3 	strdeq	r0, [r0], -r3
     aa8:	00085210 	andeq	r5, r8, r0, lsl r2
     aac:	011a1100 	tsteq	sl, r0, lsl #2
     ab0:	83110000 	tsthi	r1, #0
     ab4:	11000000 	mrsne	r0, (UNDEF: 0)
     ab8:	00000083 	andeq	r0, r0, r3, lsl #1
     abc:	00008311 	andeq	r8, r0, r1, lsl r3
     ac0:	08801100 	stmeq	r0, {r8, ip}
     ac4:	14000000 	strne	r0, [r0], #-0
     ac8:	00000f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
     acc:	d80e5808 	stmdale	lr, {r3, fp, ip, lr}
     ad0:	01000006 	tsteq	r0, r6
     ad4:	00000808 	andeq	r0, r0, r8, lsl #16
     ad8:	00000827 	andeq	r0, r0, r7, lsr #16
     adc:	00085210 	andeq	r5, r8, r0, lsl r2
     ae0:	01511100 	cmpeq	r1, r0, lsl #2
     ae4:	83110000 	tsthi	r1, #0
     ae8:	11000000 	mrsne	r0, (UNDEF: 0)
     aec:	00000083 	andeq	r0, r0, r3, lsl #1
     af0:	00008311 	andeq	r8, r0, r1, lsl r3
     af4:	08801100 	stmeq	r0, {r8, ip}
     af8:	15000000 	strne	r0, [r0, #-0]
     afc:	00000609 	andeq	r0, r0, r9, lsl #12
     b00:	6a0e5b08 	bvs	397728 <__bss_end+0x38dc18>
     b04:	c0000006 	andgt	r0, r0, r6
     b08:	01000003 	tsteq	r0, r3
     b0c:	0000083c 	andeq	r0, r0, ip, lsr r8
     b10:	00085210 	andeq	r5, r8, r0, lsl r2
     b14:	056b1100 	strbeq	r1, [fp, #-256]!	; 0xffffff00
     b18:	86110000 	ldrhi	r0, [r1], -r0
     b1c:	00000008 	andeq	r0, r0, r8
     b20:	05cb0400 	strbeq	r0, [fp, #1024]	; 0x400
     b24:	04180000 	ldreq	r0, [r8], #-0
     b28:	000005cb 	andeq	r0, r0, fp, asr #11
     b2c:	0005bf1f 	andeq	fp, r5, pc, lsl pc
     b30:	00086500 	andeq	r6, r8, r0, lsl #10
     b34:	00086b00 	andeq	r6, r8, r0, lsl #22
     b38:	08521000 	ldmdaeq	r2, {ip}^
     b3c:	20000000 	andcs	r0, r0, r0
     b40:	000005cb 	andeq	r0, r0, fp, asr #11
     b44:	00000858 	andeq	r0, r0, r8, asr r8
     b48:	00750418 	rsbseq	r0, r5, r8, lsl r4
     b4c:	04180000 	ldreq	r0, [r8], #-0
     b50:	0000084d 	andeq	r0, r0, sp, asr #16
     b54:	00f40421 	rscseq	r0, r4, r1, lsr #8
     b58:	04220000 	strteq	r0, [r2], #-0
     b5c:	000b771a 	andeq	r7, fp, sl, lsl r7
     b60:	195e0800 	ldmdbne	lr, {fp}^
     b64:	000005cb 	andeq	r0, r0, fp, asr #11
     b68:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b6c:	0b050900 	bleq	142f74 <__bss_end+0x139464>
     b70:	0000094e 	andeq	r0, r0, lr, asr #18
     b74:	000c9524 	andeq	r9, ip, r4, lsr #10
     b78:	19070900 	stmdbne	r7, {r8, fp}
     b7c:	0000009b 	muleq	r0, fp, r0
     b80:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b84:	000e1824 	andeq	r1, lr, r4, lsr #16
     b88:	1a0a0900 	bne	282f90 <__bss_end+0x279480>
     b8c:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     b90:	20000000 	andcs	r0, r0, r0
     b94:	000bff24 	andeq	pc, fp, r4, lsr #30
     b98:	1a0d0900 	bne	342fa0 <__bss_end+0x339490>
     b9c:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     ba0:	20200000 	eorcs	r0, r0, r0
     ba4:	000ddd25 	andeq	sp, sp, r5, lsr #26
     ba8:	15100900 	ldrne	r0, [r0, #-2304]	; 0xfffff700
     bac:	0000008f 	andeq	r0, r0, pc, lsl #1
     bb0:	06002436 			; <UNDEFINED> instruction: 0x06002436
     bb4:	4b090000 	blmi	240bbc <__bss_end+0x2370ac>
     bb8:	0004b41a 	andeq	fp, r4, sl, lsl r4
     bbc:	21500000 	cmpcs	r0, r0
     bc0:	083f2420 	ldmdaeq	pc!, {r5, sl, sp}	; <UNPREDICTABLE>
     bc4:	7a090000 	bvc	240bcc <__bss_end+0x2370bc>
     bc8:	0004b41a 	andeq	fp, r4, sl, lsl r4
     bcc:	00b20000 	adcseq	r0, r2, r0
     bd0:	0e9b2420 	cdpeq	4, 9, cr2, cr11, cr0, {1}
     bd4:	ad090000 	stcge	0, cr0, [r9, #-0]
     bd8:	0004b41a 	andeq	fp, r4, sl, lsl r4
     bdc:	00b40000 	adcseq	r0, r4, r0
     be0:	08d32420 	ldmeq	r3, {r5, sl, sp}^
     be4:	bc090000 	stclt	0, cr0, [r9], {-0}
     be8:	0004b41a 	andeq	fp, r4, sl, lsl r4
     bec:	10400000 	subne	r0, r0, r0
     bf0:	07e92420 	strbeq	r2, [r9, r0, lsr #8]!
     bf4:	c7090000 	strgt	r0, [r9, -r0]
     bf8:	0004b41a 	andeq	fp, r4, sl, lsl r4
     bfc:	20500000 	subscs	r0, r0, r0
     c00:	08792420 	ldmdaeq	r9!, {r5, sl, sp}^
     c04:	c8090000 	stmdagt	r9, {}	; <UNPREDICTABLE>
     c08:	0004b41a 	andeq	fp, r4, sl, lsl r4
     c0c:	80400000 	subhi	r0, r0, r0
     c10:	04cd2420 	strbeq	r2, [sp], #1056	; 0x420
     c14:	c9090000 	stmdbgt	r9, {}	; <UNPREDICTABLE>
     c18:	0004b41a 	andeq	fp, r4, sl, lsl r4
     c1c:	80500000 	subshi	r0, r0, r0
     c20:	a0260020 	eorge	r0, r6, r0, lsr #32
     c24:	26000008 	strcs	r0, [r0], -r8
     c28:	000008b0 			; <UNDEFINED> instruction: 0x000008b0
     c2c:	0008c026 	andeq	ip, r8, r6, lsr #32
     c30:	08d02600 	ldmeq	r0, {r9, sl, sp}^
     c34:	dd260000 	stcle	0, cr0, [r6, #-0]
     c38:	26000008 	strcs	r0, [r0], -r8
     c3c:	000008ed 	andeq	r0, r0, sp, ror #17
     c40:	0008fd26 	andeq	pc, r8, r6, lsr #26
     c44:	090d2600 	stmdbeq	sp, {r9, sl, sp}
     c48:	1d260000 	stcne	0, cr0, [r6, #-0]
     c4c:	26000009 	strcs	r0, [r0], -r9
     c50:	0000092d 	andeq	r0, r0, sp, lsr #18
     c54:	00093d26 	andeq	r3, r9, r6, lsr #26
     c58:	0b430200 	bleq	10c1460 <__bss_end+0x10b7950>
     c5c:	080a0000 	stmdaeq	sl, {}	; <UNPREDICTABLE>
     c60:	00008f14 	andeq	r8, r0, r4, lsl pc
     c64:	74030500 	strvc	r0, [r3], #-1280	; 0xfffffb00
     c68:	0a00009a 	beq	ed8 <shift+0xed8>
     c6c:	00000cd1 	ldrdeq	r0, [r0], -r1
     c70:	00940407 	addseq	r0, r4, r7, lsl #8
     c74:	0b0a0000 	bleq	280c7c <__bss_end+0x27716c>
     c78:	0009e00c 	andeq	lr, r9, ip
     c7c:	0fdc0b00 	svceq	0x00dc0b00
     c80:	0b000000 	bleq	c88 <shift+0xc88>
     c84:	00000c7c 	andeq	r0, r0, ip, ror ip
     c88:	0ac10b01 	beq	ff043894 <__bss_end+0xff039d84>
     c8c:	0b020000 	bleq	80c94 <__bss_end+0x77184>
     c90:	00000426 	andeq	r0, r0, r6, lsr #8
     c94:	04150b03 	ldreq	r0, [r5], #-2819	; 0xfffff4fd
     c98:	0b040000 	bleq	100ca0 <__bss_end+0xf7190>
     c9c:	00000a8e 	andeq	r0, r0, lr, lsl #21
     ca0:	0a940b05 	beq	fe5038bc <__bss_end+0xfe4f9dac>
     ca4:	0b060000 	bleq	180cac <__bss_end+0x17719c>
     ca8:	00000420 	andeq	r0, r0, r0, lsr #8
     cac:	122d0b07 	eorne	r0, sp, #7168	; 0x1c00
     cb0:	00080000 	andeq	r0, r8, r0
     cb4:	0003dc0a 	andeq	sp, r3, sl, lsl #24
     cb8:	67040500 	strvs	r0, [r4, -r0, lsl #10]
     cbc:	0a000000 	beq	cc4 <shift+0xcc4>
     cc0:	0a0b0c1d 	beq	2c3d3c <__bss_end+0x2ba22c>
     cc4:	410b0000 	mrsmi	r0, (UNDEF: 11)
     cc8:	00000009 	andeq	r0, r0, r9
     ccc:	0007300b 	andeq	r3, r7, fp
     cd0:	dd0b0100 	stfles	f0, [fp, #-0]
     cd4:	02000008 	andeq	r0, r0, #8
     cd8:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     cdc:	0d000300 	stceq	3, cr0, [r0, #-0]
     ce0:	0000121f 	andeq	r1, r0, pc, lsl r2
     ce4:	07280a1c 			; <UNDEFINED> instruction: 0x07280a1c
     ce8:	00000d8c 	andeq	r0, r0, ip, lsl #27
     cec:	0005c408 	andeq	ip, r5, r8, lsl #8
     cf0:	330a1000 	movwcc	r1, #40960	; 0xa000
     cf4:	000a5a0a 	andeq	r5, sl, sl, lsl #20
     cf8:	121a0e00 	andsne	r0, sl, #0, 28
     cfc:	350a0000 	strcc	r0, [sl, #-0]
     d00:	0003ef0b 	andeq	lr, r3, fp, lsl #30
     d04:	b30e0000 	movwlt	r0, #57344	; 0xe000
     d08:	0a000011 	beq	d54 <shift+0xd54>
     d0c:	00830d36 	addeq	r0, r3, r6, lsr sp
     d10:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     d14:	0000042c 	andeq	r0, r0, ip, lsr #8
     d18:	9113370a 	tstls	r3, sl, lsl #14
     d1c:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     d20:	0005540e 	andeq	r5, r5, lr, lsl #8
     d24:	13380a00 	teqne	r8, #0, 20
     d28:	00000d91 	muleq	r0, r1, sp
     d2c:	e10e000c 	tst	lr, ip
     d30:	0a000005 	beq	d4c <shift+0xd4c>
     d34:	0d9d202c 	ldceq	0, cr2, [sp, #176]	; 0xb0
     d38:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     d3c:	000005ad 	andeq	r0, r0, sp, lsr #11
     d40:	a20c2f0a 	andge	r2, ip, #10, 30	; 0x28
     d44:	0400000d 	streq	r0, [r0], #-13
     d48:	000c4c0e 	andeq	r4, ip, lr, lsl #24
     d4c:	0c310a00 			; <UNDEFINED> instruction: 0x0c310a00
     d50:	00000da2 	andeq	r0, r0, r2, lsr #27
     d54:	0f260e0c 	svceq	0x00260e0c
     d58:	3b0a0000 	blcc	280d60 <__bss_end+0x277250>
     d5c:	000d9112 	andeq	r9, sp, r2, lsl r1
     d60:	3a0e1400 	bcc	385d68 <__bss_end+0x37c258>
     d64:	0a00000e 	beq	da4 <shift+0xda4>
     d68:	018e0e3d 	orreq	r0, lr, sp, lsr lr
     d6c:	13180000 	tstne	r8, #0
     d70:	00000c64 	andeq	r0, r0, r4, ror #24
     d74:	7f08410a 	svcvc	0x0008410a
     d78:	c0000009 	andgt	r0, r0, r9
     d7c:	02000003 	andeq	r0, r0, #3
     d80:	00000ab4 			; <UNDEFINED> instruction: 0x00000ab4
     d84:	00000ac9 	andeq	r0, r0, r9, asr #21
     d88:	000db210 	andeq	fp, sp, r0, lsl r2
     d8c:	00831100 	addeq	r1, r3, r0, lsl #2
     d90:	b8110000 	ldmdalt	r1, {}	; <UNPREDICTABLE>
     d94:	1100000d 	tstne	r0, sp
     d98:	00000db8 			; <UNDEFINED> instruction: 0x00000db8
     d9c:	0c2d1300 	stceq	3, cr1, [sp], #-0
     da0:	430a0000 	movwmi	r0, #40960	; 0xa000
     da4:	000bc208 	andeq	ip, fp, r8, lsl #4
     da8:	0003c000 	andeq	ip, r3, r0
     dac:	0ae20200 	beq	ff8815b4 <__bss_end+0xff877aa4>
     db0:	0af70000 	beq	ffdc0db8 <__bss_end+0xffdb72a8>
     db4:	b2100000 	andslt	r0, r0, #0
     db8:	1100000d 	tstne	r0, sp
     dbc:	00000083 	andeq	r0, r0, r3, lsl #1
     dc0:	000db811 	andeq	fp, sp, r1, lsl r8
     dc4:	0db81100 	ldfeqs	f1, [r8]
     dc8:	13000000 	movwne	r0, #0
     dcc:	00000ee4 	andeq	r0, r0, r4, ror #29
     dd0:	5108450a 	tstpl	r8, sl, lsl #10
     dd4:	c0000011 	andgt	r0, r0, r1, lsl r0
     dd8:	02000003 	andeq	r0, r0, #3
     ddc:	00000b10 	andeq	r0, r0, r0, lsl fp
     de0:	00000b25 	andeq	r0, r0, r5, lsr #22
     de4:	000db210 	andeq	fp, sp, r0, lsl r2
     de8:	00831100 	addeq	r1, r3, r0, lsl #2
     dec:	b8110000 	ldmdalt	r1, {}	; <UNPREDICTABLE>
     df0:	1100000d 	tstne	r0, sp
     df4:	00000db8 			; <UNDEFINED> instruction: 0x00000db8
     df8:	109a1300 	addsne	r1, sl, r0, lsl #6
     dfc:	470a0000 	strmi	r0, [sl, -r0]
     e00:	000ef708 	andeq	pc, lr, r8, lsl #14
     e04:	0003c000 	andeq	ip, r3, r0
     e08:	0b3e0200 	bleq	f81610 <__bss_end+0xf77b00>
     e0c:	0b530000 	bleq	14c0e14 <__bss_end+0x14b7304>
     e10:	b2100000 	andslt	r0, r0, #0
     e14:	1100000d 	tstne	r0, sp
     e18:	00000083 	andeq	r0, r0, r3, lsl #1
     e1c:	000db811 	andeq	fp, sp, r1, lsl r8
     e20:	0db81100 	ldfeqs	f1, [r8]
     e24:	13000000 	movwne	r0, #0
     e28:	00000541 	andeq	r0, r0, r1, asr #10
     e2c:	5f08490a 	svcpl	0x0008490a
     e30:	c0000010 	andgt	r0, r0, r0, lsl r0
     e34:	02000003 	andeq	r0, r0, #3
     e38:	00000b6c 	andeq	r0, r0, ip, ror #22
     e3c:	00000b81 	andeq	r0, r0, r1, lsl #23
     e40:	000db210 	andeq	fp, sp, r0, lsl r2
     e44:	00831100 	addeq	r1, r3, r0, lsl #2
     e48:	b8110000 	ldmdalt	r1, {}	; <UNPREDICTABLE>
     e4c:	1100000d 	tstne	r0, sp
     e50:	00000db8 			; <UNDEFINED> instruction: 0x00000db8
     e54:	0c091300 	stceq	3, cr1, [r9], {-0}
     e58:	4b0a0000 	blmi	280e60 <__bss_end+0x277350>
     e5c:	0008f408 	andeq	pc, r8, r8, lsl #8
     e60:	0003c000 	andeq	ip, r3, r0
     e64:	0b9a0200 	bleq	fe68166c <__bss_end+0xfe677b5c>
     e68:	0bb40000 	bleq	fed00e70 <__bss_end+0xfecf7360>
     e6c:	b2100000 	andslt	r0, r0, #0
     e70:	1100000d 	tstne	r0, sp
     e74:	00000083 	andeq	r0, r0, r3, lsl #1
     e78:	0009e011 	andeq	lr, r9, r1, lsl r0
     e7c:	0db81100 	ldfeqs	f1, [r8]
     e80:	b8110000 	ldmdalt	r1, {}	; <UNPREDICTABLE>
     e84:	0000000d 	andeq	r0, r0, sp
     e88:	000a4713 	andeq	r4, sl, r3, lsl r7
     e8c:	0c4f0a00 	mcrreq	10, 0, r0, pc, cr0
     e90:	00000d7d 	andeq	r0, r0, sp, ror sp
     e94:	00000083 	andeq	r0, r0, r3, lsl #1
     e98:	000bcd02 	andeq	ip, fp, r2, lsl #26
     e9c:	000bd300 	andeq	sp, fp, r0, lsl #6
     ea0:	0db21000 	ldceq	0, cr1, [r2]
     ea4:	14000000 	strne	r0, [r0], #-0
     ea8:	00000f4a 	andeq	r0, r0, sl, asr #30
     eac:	ad08510a 	stfges	f5, [r8, #-40]	; 0xffffffd8
     eb0:	02000006 	andeq	r0, r0, #6
     eb4:	00000be8 	andeq	r0, r0, r8, ror #23
     eb8:	00000bf3 	strdeq	r0, [r0], -r3
     ebc:	000dbe10 	andeq	fp, sp, r0, lsl lr
     ec0:	00831100 	addeq	r1, r3, r0, lsl #2
     ec4:	13000000 	movwne	r0, #0
     ec8:	0000121f 	andeq	r1, r0, pc, lsl r2
     ecc:	0103540a 	tsteq	r3, sl, lsl #8
     ed0:	be00000e 	cdplt	0, 0, cr0, cr0, cr14, {0}
     ed4:	0100000d 	tsteq	r0, sp
     ed8:	00000c0c 	andeq	r0, r0, ip, lsl #24
     edc:	00000c17 	andeq	r0, r0, r7, lsl ip
     ee0:	000dbe10 	andeq	fp, sp, r0, lsl lr
     ee4:	00941100 	addseq	r1, r4, r0, lsl #2
     ee8:	14000000 	strne	r0, [r0], #-0
     eec:	00000501 	andeq	r0, r0, r1, lsl #10
     ef0:	a808570a 	stmdage	r8, {r1, r3, r8, r9, sl, ip, lr}
     ef4:	0100000c 	tsteq	r0, ip
     ef8:	00000c2c 	andeq	r0, r0, ip, lsr #24
     efc:	00000c3c 	andeq	r0, r0, ip, lsr ip
     f00:	000dbe10 	andeq	fp, sp, r0, lsl lr
     f04:	00831100 	addeq	r1, r3, r0, lsl #2
     f08:	97110000 	ldrls	r0, [r1, -r0]
     f0c:	00000009 	andeq	r0, r0, r9
     f10:	000e8913 	andeq	r8, lr, r3, lsl r9
     f14:	12590a00 	subsne	r0, r9, #0, 20
     f18:	000011c4 	andeq	r1, r0, r4, asr #3
     f1c:	00000997 	muleq	r0, r7, r9
     f20:	000c5501 	andeq	r5, ip, r1, lsl #10
     f24:	000c6000 	andeq	r6, ip, r0
     f28:	0db21000 	ldceq	0, cr1, [r2]
     f2c:	83110000 	tsthi	r1, #0
     f30:	00000000 	andeq	r0, r0, r0
     f34:	000c7814 	andeq	r7, ip, r4, lsl r8
     f38:	085c0a00 	ldmdaeq	ip, {r9, fp}^
     f3c:	00000ac7 	andeq	r0, r0, r7, asr #21
     f40:	000c7501 	andeq	r7, ip, r1, lsl #10
     f44:	000c8500 	andeq	r8, ip, r0, lsl #10
     f48:	0dbe1000 	ldceq	0, cr1, [lr]
     f4c:	83110000 	tsthi	r1, #0
     f50:	11000000 	mrsne	r0, (UNDEF: 0)
     f54:	000003c0 	andeq	r0, r0, r0, asr #7
     f58:	0fd81300 	svceq	0x00d81300
     f5c:	5f0a0000 	svcpl	0x000a0000
     f60:	0004ae08 	andeq	sl, r4, r8, lsl #28
     f64:	0003c000 	andeq	ip, r3, r0
     f68:	0c9e0100 	ldfeqs	f0, [lr], {0}
     f6c:	0ca90000 	stceq	0, cr0, [r9]
     f70:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
     f74:	1100000d 	tstne	r0, sp
     f78:	00000083 	andeq	r0, r0, r3, lsl #1
     f7c:	0e7d1300 	cdpeq	3, 7, cr1, cr13, cr0, {0}
     f80:	620a0000 	andvs	r0, sl, #0
     f84:	0003f108 	andeq	pc, r3, r8, lsl #2
     f88:	0003c000 	andeq	ip, r3, r0
     f8c:	0cc20100 	stfeqe	f0, [r2], {0}
     f90:	0cd70000 	ldcleq	0, cr0, [r7], {0}
     f94:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
     f98:	1100000d 	tstne	r0, sp
     f9c:	00000083 	andeq	r0, r0, r3, lsl #1
     fa0:	0003c011 	andeq	ip, r3, r1, lsl r0
     fa4:	03c01100 	biceq	r1, r0, #0, 2
     fa8:	13000000 	movwne	r0, #0
     fac:	000011bb 			; <UNDEFINED> instruction: 0x000011bb
     fb0:	5908640a 	stmdbpl	r8, {r1, r3, sl, sp, lr}
     fb4:	c0000008 	andgt	r0, r0, r8
     fb8:	01000003 	tsteq	r0, r3
     fbc:	00000cf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     fc0:	00000d05 	andeq	r0, r0, r5, lsl #26
     fc4:	000dbe10 	andeq	fp, sp, r0, lsl lr
     fc8:	00831100 	addeq	r1, r3, r0, lsl #2
     fcc:	c0110000 	andsgt	r0, r1, r0
     fd0:	11000003 	tstne	r0, r3
     fd4:	000003c0 	andeq	r0, r0, r0, asr #7
     fd8:	0b4f1400 	bleq	13c5fe0 <__bss_end+0x13bc4d0>
     fdc:	670a0000 	strvs	r0, [sl, -r0]
     fe0:	0003b108 	andeq	fp, r3, r8, lsl #2
     fe4:	0d1a0100 	ldfeqs	f0, [sl, #-0]
     fe8:	0d2a0000 	stceq	0, cr0, [sl, #-0]
     fec:	be100000 	cdplt	0, 1, cr0, cr0, cr0, {0}
     ff0:	1100000d 	tstne	r0, sp
     ff4:	00000083 	andeq	r0, r0, r3, lsl #1
     ff8:	0009e011 	andeq	lr, r9, r1, lsl r0
     ffc:	43140000 	tstmi	r4, #0
    1000:	0a00000d 	beq	103c <shift+0x103c>
    1004:	07590869 	ldrbeq	r0, [r9, -r9, ror #16]
    1008:	3f010000 	svccc	0x00010000
    100c:	4f00000d 	svcmi	0x0000000d
    1010:	1000000d 	andne	r0, r0, sp
    1014:	00000dbe 			; <UNDEFINED> instruction: 0x00000dbe
    1018:	00008311 	andeq	r8, r0, r1, lsl r3
    101c:	09e01100 	stmibeq	r0!, {r8, ip}^
    1020:	14000000 	strne	r0, [r0], #-0
    1024:	00001292 	muleq	r0, r2, r2
    1028:	07086c0a 	streq	r6, [r8, -sl, lsl #24]
    102c:	0100000a 	tsteq	r0, sl
    1030:	00000d64 	andeq	r0, r0, r4, ror #26
    1034:	00000d6a 	andeq	r0, r0, sl, ror #26
    1038:	000dbe10 	andeq	fp, sp, r0, lsl lr
    103c:	b3270000 			; <UNDEFINED> instruction: 0xb3270000
    1040:	0a00000b 	beq	1074 <shift+0x1074>
    1044:	0e48086f 	cdpeq	8, 4, cr0, cr8, cr15, {3}
    1048:	7b010000 	blvc	41050 <__bss_end+0x37540>
    104c:	1000000d 	andne	r0, r0, sp
    1050:	00000dbe 			; <UNDEFINED> instruction: 0x00000dbe
    1054:	0003ef11 	andeq	lr, r3, r1, lsl pc
    1058:	00831100 	addeq	r1, r3, r0, lsl #2
    105c:	00000000 	andeq	r0, r0, r0
    1060:	000a0b04 	andeq	r0, sl, r4, lsl #22
    1064:	18041800 	stmdane	r4, {fp, ip}
    1068:	1800000a 	stmdane	r0, {r1, r3}
    106c:	0000a004 	andeq	sl, r0, r4
    1070:	0d970400 	cfldrseq	mvf0, [r7]
    1074:	83160000 	tsthi	r6, #0
    1078:	b2000000 	andlt	r0, r0, #0
    107c:	1700000d 	strne	r0, [r0, -sp]
    1080:	00000094 	muleq	r0, r4, r0
    1084:	04180001 	ldreq	r0, [r8], #-1
    1088:	00000d8c 	andeq	r0, r0, ip, lsl #27
    108c:	00830421 	addeq	r0, r3, r1, lsr #8
    1090:	04180000 	ldreq	r0, [r8], #-0
    1094:	00000a0b 	andeq	r0, r0, fp, lsl #20
    1098:	000b631a 	andeq	r6, fp, sl, lsl r3
    109c:	16730a00 	ldrbtne	r0, [r3], -r0, lsl #20
    10a0:	00000a0b 	andeq	r0, r0, fp, lsl #20
    10a4:	00074a28 	andeq	r4, r7, r8, lsr #20
    10a8:	05100100 	ldreq	r0, [r0, #-256]	; 0xffffff00
    10ac:	00000067 	andeq	r0, r0, r7, rrx
    10b0:	0000822c 	andeq	r8, r0, ip, lsr #4
    10b4:	00000194 	muleq	r0, r4, r1
    10b8:	0e7c9c01 	cdpeq	12, 7, cr9, cr12, cr1, {0}
    10bc:	fa290000 	blx	a410c4 <__bss_end+0xa375b4>
    10c0:	01000011 	tsteq	r0, r1, lsl r0
    10c4:	00670e10 	rsbeq	r0, r7, r0, lsl lr
    10c8:	91020000 	mrsls	r0, (UNDEF: 2)
    10cc:	10ff295c 	rscsne	r2, pc, ip, asr r9	; <UNPREDICTABLE>
    10d0:	10010000 	andne	r0, r1, r0
    10d4:	000e7c1b 	andeq	r7, lr, fp, lsl ip
    10d8:	58910200 	ldmpl	r1, {r9}
    10dc:	000a7c2a 	andeq	r7, sl, sl, lsr #24
    10e0:	0b120100 	bleq	4814e8 <__bss_end+0x4779d8>
    10e4:	00000083 	andeq	r0, r0, r3, lsl #1
    10e8:	2a709102 	bcs	1c254f8 <__bss_end+0x1c1b9e8>
    10ec:	00001212 	andeq	r1, r0, r2, lsl r2
    10f0:	830b1301 	movwhi	r1, #45825	; 0xb301
    10f4:	02000000 	andeq	r0, r0, #0
    10f8:	af2a6c91 	svcge	0x002a6c91
    10fc:	01000009 	tsteq	r0, r9
    1100:	00830b14 	addeq	r0, r3, r4, lsl fp
    1104:	91020000 	mrsls	r0, (UNDEF: 2)
    1108:	0b042a68 	bleq	10bab0 <__bss_end+0x101fa0>
    110c:	16010000 	strne	r0, [r1], -r0
    1110:	0000940f 	andeq	r9, r0, pc, lsl #8
    1114:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1118:	0004972a 	andeq	r9, r4, sl, lsr #14
    111c:	07170100 	ldreq	r0, [r7, -r0, lsl #2]
    1120:	000003c0 	andeq	r0, r0, r0, asr #7
    1124:	2a679102 	bcs	19e5534 <__bss_end+0x19dba24>
    1128:	00000627 	andeq	r0, r0, r7, lsr #12
    112c:	c0071801 	andgt	r1, r7, r1, lsl #16
    1130:	02000003 	andeq	r0, r0, #3
    1134:	a82b6691 	stmdage	fp!, {r0, r4, r7, r9, sl, sp, lr}
    1138:	04000082 	streq	r0, [r0], #-130	; 0xffffff7e
    113c:	2c000001 	stccs	0, cr0, [r0], {1}
    1140:	00706d74 	rsbseq	r6, r0, r4, ror sp
    1144:	43081e01 	movwmi	r1, #36353	; 0x8e01
    1148:	02000000 	andeq	r0, r0, #0
    114c:	00006591 	muleq	r0, r1, r5
    1150:	0e820418 	mcreq	4, 4, r0, cr2, cr8, {0}
    1154:	04180000 	ldreq	r0, [r8], #-0
    1158:	00000043 	andeq	r0, r0, r3, asr #32
    115c:	000d5c00 	andeq	r5, sp, r0, lsl #24
    1160:	80000400 	andhi	r0, r0, r0, lsl #8
    1164:	04000004 	streq	r0, [r0], #-4
    1168:	0015eb01 	andseq	lr, r5, r1, lsl #22
    116c:	13ce0400 	bicne	r0, lr, #0, 8
    1170:	14590000 	ldrbne	r0, [r9], #-0
    1174:	83c00000 	bichi	r0, r0, #0
    1178:	045c0000 	ldrbeq	r0, [ip], #-0
    117c:	048f0000 	streq	r0, [pc], #0	; 1184 <shift+0x1184>
    1180:	01020000 	mrseq	r0, (UNDEF: 2)
    1184:	000d7808 	andeq	r7, sp, r8, lsl #16
    1188:	00250300 	eoreq	r0, r5, r0, lsl #6
    118c:	02020000 	andeq	r0, r2, #0
    1190:	000dec05 	andeq	lr, sp, r5, lsl #24
    1194:	0e750400 	cdpeq	4, 7, cr0, cr5, cr0, {0}
    1198:	05020000 	streq	r0, [r2, #-0]
    119c:	00004907 	andeq	r4, r0, r7, lsl #18
    11a0:	00380300 	eorseq	r0, r8, r0, lsl #6
    11a4:	04050000 	streq	r0, [r5], #-0
    11a8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    11ac:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    11b0:	0000031f 	andeq	r0, r0, pc, lsl r3
    11b4:	6f080102 	svcvs	0x00080102
    11b8:	0200000d 	andeq	r0, r0, #13
    11bc:	09e20702 	stmibeq	r2!, {r1, r8, r9, sl}^
    11c0:	74040000 	strvc	r0, [r4], #-0
    11c4:	0200000e 	andeq	r0, r0, #14
    11c8:	0076070a 	rsbseq	r0, r6, sl, lsl #14
    11cc:	65030000 	strvs	r0, [r3, #-0]
    11d0:	02000000 	andeq	r0, r0, #0
    11d4:	04e10704 	strbteq	r0, [r1], #1796	; 0x704
    11d8:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    11dc:	0004d707 	andeq	sp, r4, r7, lsl #14
    11e0:	07df0600 	ldrbeq	r0, [pc, r0, lsl #12]
    11e4:	0d020000 	stceq	0, cr0, [r2, #-0]
    11e8:	00004413 	andeq	r4, r0, r3, lsl r4
    11ec:	9c030500 	cfstr32ls	mvfx0, [r3], {-0}
    11f0:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
    11f4:	000008c9 	andeq	r0, r0, r9, asr #17
    11f8:	44130e02 	ldrmi	r0, [r3], #-3586	; 0xfffff1fe
    11fc:	05000000 	streq	r0, [r0, #-0]
    1200:	009aa003 	addseq	sl, sl, r3
    1204:	07de0600 	ldrbeq	r0, [lr, r0, lsl #12]
    1208:	10020000 	andne	r0, r2, r0
    120c:	00007114 	andeq	r7, r0, r4, lsl r1
    1210:	a4030500 	strge	r0, [r3], #-1280	; 0xfffffb00
    1214:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
    1218:	000008c8 	andeq	r0, r0, r8, asr #17
    121c:	71141102 	tstvc	r4, r2, lsl #2
    1220:	05000000 	streq	r0, [r0, #-0]
    1224:	009aa803 	addseq	sl, sl, r3, lsl #16
    1228:	07240700 	streq	r0, [r4, -r0, lsl #14]!
    122c:	03080000 	movweq	r0, #32768	; 0x8000
    1230:	00f20806 	rscseq	r0, r2, r6, lsl #16
    1234:	72080000 	andvc	r0, r8, #0
    1238:	08030030 	stmdaeq	r3, {r4, r5}
    123c:	0000650e 	andeq	r6, r0, lr, lsl #10
    1240:	72080000 	andvc	r0, r8, #0
    1244:	09030031 	stmdbeq	r3, {r0, r4, r5}
    1248:	0000650e 	andeq	r6, r0, lr, lsl #10
    124c:	09000400 	stmdbeq	r0, {sl}
    1250:	00001519 	andeq	r1, r0, r9, lsl r5
    1254:	00490405 	subeq	r0, r9, r5, lsl #8
    1258:	0d030000 	stceq	0, cr0, [r3, #-0]
    125c:	0001100c 	andeq	r1, r1, ip
    1260:	4b4f0a00 	blmi	13c3a68 <__bss_end+0x13b9f58>
    1264:	1a0b0000 	bne	2c126c <__bss_end+0x2b775c>
    1268:	01000013 	tsteq	r0, r3, lsl r0
    126c:	05830900 	streq	r0, [r3, #2304]	; 0x900
    1270:	04050000 	streq	r0, [r5], #-0
    1274:	00000049 	andeq	r0, r0, r9, asr #32
    1278:	470c1e03 	strmi	r1, [ip, -r3, lsl #28]
    127c:	0b000001 	bleq	1288 <shift+0x1288>
    1280:	00001244 	andeq	r1, r0, r4, asr #4
    1284:	12820b00 	addne	r0, r2, #0, 22
    1288:	0b010000 	bleq	41290 <__bss_end+0x37780>
    128c:	0000124c 	andeq	r1, r0, ip, asr #4
    1290:	0a6c0b02 	beq	1b03ea0 <__bss_end+0x1afa390>
    1294:	0b030000 	bleq	c129c <__bss_end+0xb778c>
    1298:	00000ce0 	andeq	r0, r0, r0, ror #25
    129c:	07a70b04 	streq	r0, [r7, r4, lsl #22]!
    12a0:	00050000 	andeq	r0, r5, r0
    12a4:	00113909 	andseq	r3, r1, r9, lsl #18
    12a8:	49040500 	stmdbmi	r4, {r8, sl}
    12ac:	03000000 	movweq	r0, #0
    12b0:	01840c44 	orreq	r0, r4, r4, asr #24
    12b4:	1b0b0000 	blne	2c12bc <__bss_end+0x2b77ac>
    12b8:	00000004 	andeq	r0, r0, r4
    12bc:	0005bf0b 	andeq	fp, r5, fp, lsl #30
    12c0:	880b0100 	stmdahi	fp, {r8}
    12c4:	0200000c 	andeq	r0, r0, #12
    12c8:	0011ed0b 	andseq	lr, r1, fp, lsl #26
    12cc:	8c0b0300 	stchi	3, cr0, [fp], {-0}
    12d0:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    12d4:	000b990b 	andeq	r9, fp, fp, lsl #18
    12d8:	020b0500 	andeq	r0, fp, #0, 10
    12dc:	0600000a 	streq	r0, [r0], -sl
    12e0:	157e0900 	ldrbne	r0, [lr, #-2304]!	; 0xfffff700
    12e4:	04050000 	streq	r0, [r5], #-0
    12e8:	00000049 	andeq	r0, r0, r9, asr #32
    12ec:	af0c6b03 	svcge	0x000c6b03
    12f0:	0b000001 	bleq	12fc <shift+0x12fc>
    12f4:	000014be 			; <UNDEFINED> instruction: 0x000014be
    12f8:	136b0b00 	cmnne	fp, #0, 22
    12fc:	0b010000 	bleq	41304 <__bss_end+0x377f4>
    1300:	000014e2 	andeq	r1, r0, r2, ror #9
    1304:	13900b02 	orrsne	r0, r0, #2048	; 0x800
    1308:	00030000 	andeq	r0, r3, r0
    130c:	000bf106 	andeq	pc, fp, r6, lsl #2
    1310:	14050400 	strne	r0, [r5], #-1024	; 0xfffffc00
    1314:	00000071 	andeq	r0, r0, r1, ror r0
    1318:	9aac0305 	bls	feb01f34 <__bss_end+0xfeaf8424>
    131c:	40060000 	andmi	r0, r6, r0
    1320:	0400000c 	streq	r0, [r0], #-12
    1324:	00711406 	rsbseq	r1, r1, r6, lsl #8
    1328:	03050000 	movweq	r0, #20480	; 0x5000
    132c:	00009ab0 			; <UNDEFINED> instruction: 0x00009ab0
    1330:	000b8306 	andeq	r8, fp, r6, lsl #6
    1334:	1a070500 	bne	1c273c <__bss_end+0x1b8c2c>
    1338:	00000071 	andeq	r0, r0, r1, ror r0
    133c:	9ab40305 	bls	fed01f58 <__bss_end+0xfecf8448>
    1340:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    1344:	05000005 	streq	r0, [r0, #-5]
    1348:	00711a09 	rsbseq	r1, r1, r9, lsl #20
    134c:	03050000 	movweq	r0, #20480	; 0x5000
    1350:	00009ab8 			; <UNDEFINED> instruction: 0x00009ab8
    1354:	000d6106 	andeq	r6, sp, r6, lsl #2
    1358:	1a0b0500 	bne	2c2760 <__bss_end+0x2b8c50>
    135c:	00000071 	andeq	r0, r0, r1, ror r0
    1360:	9abc0305 	bls	fef01f7c <__bss_end+0xfeef846c>
    1364:	bc060000 	stclt	0, cr0, [r6], {-0}
    1368:	05000009 	streq	r0, [r0, #-9]
    136c:	00711a0d 	rsbseq	r1, r1, sp, lsl #20
    1370:	03050000 	movweq	r0, #20480	; 0x5000
    1374:	00009ac0 	andeq	r9, r0, r0, asr #21
    1378:	00074f06 	andeq	r4, r7, r6, lsl #30
    137c:	1a0f0500 	bne	3c2784 <__bss_end+0x3b8c74>
    1380:	00000071 	andeq	r0, r0, r1, ror r0
    1384:	9ac40305 	bls	ff101fa0 <__bss_end+0xff0f8490>
    1388:	d4090000 	strle	r0, [r9], #-0
    138c:	0500000e 	streq	r0, [r0, #-14]
    1390:	00004904 	andeq	r4, r0, r4, lsl #18
    1394:	0c1b0500 	cfldr32eq	mvfx0, [fp], {-0}
    1398:	00000252 	andeq	r0, r0, r2, asr r2
    139c:	000f400b 	andeq	r4, pc, fp
    13a0:	390b0000 	stmdbcc	fp, {}	; <UNPREDICTABLE>
    13a4:	01000012 	tsteq	r0, r2, lsl r0
    13a8:	000c830b 	andeq	r8, ip, fp, lsl #6
    13ac:	0c000200 	sfmeq	f0, 4, [r0], {-0}
    13b0:	00000d3d 	andeq	r0, r0, sp, lsr sp
    13b4:	000dd10d 	andeq	sp, sp, sp, lsl #2
    13b8:	63059000 	movwvs	r9, #20480	; 0x5000
    13bc:	0003c507 	andeq	ip, r3, r7, lsl #10
    13c0:	118f0700 	orrne	r0, pc, r0, lsl #14
    13c4:	05240000 	streq	r0, [r4, #-0]!
    13c8:	02df1067 	sbcseq	r1, pc, #103	; 0x67
    13cc:	940e0000 	strls	r0, [lr], #-0
    13d0:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    13d4:	03c51269 	biceq	r1, r5, #-1879048186	; 0x90000006
    13d8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    13dc:	00000577 	andeq	r0, r0, r7, ror r5
    13e0:	d5126b05 	ldrle	r6, [r2, #-2821]	; 0xfffff4fb
    13e4:	10000003 	andne	r0, r0, r3
    13e8:	000f350e 	andeq	r3, pc, lr, lsl #10
    13ec:	166d0500 	strbtne	r0, [sp], -r0, lsl #10
    13f0:	00000065 	andeq	r0, r0, r5, rrx
    13f4:	05e70e14 	strbeq	r0, [r7, #3604]!	; 0xe14
    13f8:	70050000 	andvc	r0, r5, r0
    13fc:	0003dc1c 	andeq	sp, r3, ip, lsl ip
    1400:	580e1800 	stmdapl	lr, {fp, ip}
    1404:	0500000d 	streq	r0, [r0, #-13]
    1408:	03dc1c72 	bicseq	r1, ip, #29184	; 0x7200
    140c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1410:	00000554 	andeq	r0, r0, r4, asr r5
    1414:	dc1c7505 	cfldr32le	mvfx7, [ip], {5}
    1418:	20000003 	andcs	r0, r0, r3
    141c:	0007f30f 	andeq	pc, r7, pc, lsl #6
    1420:	1c770500 	cfldr64ne	mvdx0, [r7], #-0
    1424:	00000467 	andeq	r0, r0, r7, ror #8
    1428:	000003dc 	ldrdeq	r0, [r0], -ip
    142c:	000002d3 	ldrdeq	r0, [r0], -r3
    1430:	0003dc10 	andeq	sp, r3, r0, lsl ip
    1434:	03e21100 	mvneq	r1, #0, 2
    1438:	00000000 	andeq	r0, r0, r0
    143c:	000df607 	andeq	pc, sp, r7, lsl #12
    1440:	7b051800 	blvc	147448 <__bss_end+0x13d938>
    1444:	00031410 	andeq	r1, r3, r0, lsl r4
    1448:	21940e00 	orrscs	r0, r4, r0, lsl #28
    144c:	7e050000 	cdpvc	0, 0, cr0, cr5, cr0, {0}
    1450:	0003c512 	andeq	ip, r3, r2, lsl r5
    1454:	6c0e0000 	stcvs	0, cr0, [lr], {-0}
    1458:	05000005 	streq	r0, [r0, #-5]
    145c:	03e21980 	mvneq	r1, #128, 18	; 0x200000
    1460:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1464:	000011f3 	strdeq	r1, [r0], -r3
    1468:	ed218205 	sfm	f0, 1, [r1, #-20]!	; 0xffffffec
    146c:	14000003 	strne	r0, [r0], #-3
    1470:	02df0300 	sbcseq	r0, pc, #0, 6
    1474:	2d120000 	ldccs	0, cr0, [r2, #-0]
    1478:	0500000b 	streq	r0, [r0, #-11]
    147c:	03f32186 	mvnseq	r2, #-2147483615	; 0x80000021
    1480:	e2120000 	ands	r0, r2, #0
    1484:	05000008 	streq	r0, [r0, #-8]
    1488:	00711f88 	rsbseq	r1, r1, r8, lsl #31
    148c:	280e0000 	stmdacs	lr, {}	; <UNPREDICTABLE>
    1490:	0500000e 	streq	r0, [r0, #-14]
    1494:	0264178b 	rsbeq	r1, r4, #36438016	; 0x22c0000
    1498:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    149c:	00000a72 	andeq	r0, r0, r2, ror sl
    14a0:	64178e05 	ldrvs	r8, [r7], #-3589	; 0xfffff1fb
    14a4:	24000002 	strcs	r0, [r0], #-2
    14a8:	00094d0e 	andeq	r4, r9, lr, lsl #26
    14ac:	178f0500 	strne	r0, [pc, r0, lsl #10]
    14b0:	00000264 	andeq	r0, r0, r4, ror #4
    14b4:	126c0e48 	rsbne	r0, ip, #72, 28	; 0x480
    14b8:	90050000 	andls	r0, r5, r0
    14bc:	00026417 	andeq	r6, r2, r7, lsl r4
    14c0:	d1136c00 	tstle	r3, r0, lsl #24
    14c4:	0500000d 	streq	r0, [r0, #-13]
    14c8:	06550993 			; <UNDEFINED> instruction: 0x06550993
    14cc:	03fe0000 	mvnseq	r0, #0
    14d0:	7e010000 	cdpvc	0, 0, cr0, cr1, cr0, {0}
    14d4:	84000003 	strhi	r0, [r0], #-3
    14d8:	10000003 	andne	r0, r0, r3
    14dc:	000003fe 	strdeq	r0, [r0], -lr
    14e0:	0b221400 	bleq	8864e8 <__bss_end+0x87c9d8>
    14e4:	96050000 	strls	r0, [r5], -r0
    14e8:	000a280e 	andeq	r2, sl, lr, lsl #16
    14ec:	03990100 	orrseq	r0, r9, #0, 2
    14f0:	039f0000 	orrseq	r0, pc, #0
    14f4:	fe100000 	cdp2	0, 1, cr0, cr0, cr0, {0}
    14f8:	00000003 	andeq	r0, r0, r3
    14fc:	00041b15 	andeq	r1, r4, r5, lsl fp
    1500:	10990500 	addsne	r0, r9, r0, lsl #10
    1504:	00000eb9 			; <UNDEFINED> instruction: 0x00000eb9
    1508:	00000404 	andeq	r0, r0, r4, lsl #8
    150c:	0003b401 	andeq	fp, r3, r1, lsl #8
    1510:	03fe1000 	mvnseq	r1, #0
    1514:	e2110000 	ands	r0, r1, #0
    1518:	11000003 	tstne	r0, r3
    151c:	0000022d 	andeq	r0, r0, sp, lsr #4
    1520:	25160000 	ldrcs	r0, [r6, #-0]
    1524:	d5000000 	strle	r0, [r0, #-0]
    1528:	17000003 	strne	r0, [r0, -r3]
    152c:	00000076 	andeq	r0, r0, r6, ror r0
    1530:	0102000f 	tsteq	r2, pc
    1534:	000a8902 	andeq	r8, sl, r2, lsl #18
    1538:	64041800 	strvs	r1, [r4], #-2048	; 0xfffff800
    153c:	18000002 	stmdane	r0, {r1}
    1540:	00002c04 	andeq	r2, r0, r4, lsl #24
    1544:	11ff0c00 	mvnsne	r0, r0, lsl #24
    1548:	04180000 	ldreq	r0, [r8], #-0
    154c:	000003e8 	andeq	r0, r0, r8, ror #7
    1550:	00031416 	andeq	r1, r3, r6, lsl r4
    1554:	0003fe00 	andeq	pc, r3, r0, lsl #28
    1558:	18001900 	stmdane	r0, {r8, fp, ip}
    155c:	00025704 	andeq	r5, r2, r4, lsl #14
    1560:	52041800 	andpl	r1, r4, #0, 16
    1564:	1a000002 	bne	1574 <shift+0x1574>
    1568:	00000e2e 	andeq	r0, r0, lr, lsr #28
    156c:	57149c05 	ldrpl	r9, [r4, -r5, lsl #24]
    1570:	06000002 	streq	r0, [r0], -r2
    1574:	00000883 	andeq	r0, r0, r3, lsl #17
    1578:	71140406 	tstvc	r4, r6, lsl #8
    157c:	05000000 	streq	r0, [r0, #-0]
    1580:	009ac803 	addseq	ip, sl, r3, lsl #16
    1584:	03a60600 			; <UNDEFINED> instruction: 0x03a60600
    1588:	07060000 	streq	r0, [r6, -r0]
    158c:	00007114 	andeq	r7, r0, r4, lsl r1
    1590:	cc030500 	cfstr32gt	mvfx0, [r3], {-0}
    1594:	0600009a 			; <UNDEFINED> instruction: 0x0600009a
    1598:	00000631 	andeq	r0, r0, r1, lsr r6
    159c:	71140a06 	tstvc	r4, r6, lsl #20
    15a0:	05000000 	streq	r0, [r0, #-0]
    15a4:	009ad003 	addseq	sp, sl, r3
    15a8:	0af20900 	beq	ffc839b0 <__bss_end+0xffc79ea0>
    15ac:	04050000 	streq	r0, [r5], #-0
    15b0:	00000049 	andeq	r0, r0, r9, asr #32
    15b4:	830c0d06 	movwhi	r0, #52486	; 0xcd06
    15b8:	0a000004 	beq	15d0 <shift+0x15d0>
    15bc:	0077654e 	rsbseq	r6, r7, lr, asr #10
    15c0:	0ae90b00 	beq	ffa441c8 <__bss_end+0xffa3a6b8>
    15c4:	0b010000 	bleq	415cc <__bss_end+0x37abc>
    15c8:	00000e40 	andeq	r0, r0, r0, asr #28
    15cc:	0aa40b02 	beq	fe9041dc <__bss_end+0xfe8fa6cc>
    15d0:	0b030000 	bleq	c15d8 <__bss_end+0xb7ac8>
    15d4:	00000a5e 	andeq	r0, r0, lr, asr sl
    15d8:	0c8e0b04 	vstmiaeq	lr, {d0-d1}
    15dc:	00050000 	andeq	r0, r5, r0
    15e0:	00079a07 	andeq	r9, r7, r7, lsl #20
    15e4:	1b061000 	blne	1855ec <__bss_end+0x17badc>
    15e8:	0004c208 	andeq	ip, r4, r8, lsl #4
    15ec:	726c0800 	rsbvc	r0, ip, #0, 16
    15f0:	131d0600 	tstne	sp, #0, 12
    15f4:	000004c2 	andeq	r0, r0, r2, asr #9
    15f8:	70730800 	rsbsvc	r0, r3, r0, lsl #16
    15fc:	131e0600 	tstne	lr, #0, 12
    1600:	000004c2 	andeq	r0, r0, r2, asr #9
    1604:	63700804 	cmnvs	r0, #4, 16	; 0x40000
    1608:	131f0600 	tstne	pc, #0, 12
    160c:	000004c2 	andeq	r0, r0, r2, asr #9
    1610:	07b00e08 	ldreq	r0, [r0, r8, lsl #28]!
    1614:	20060000 	andcs	r0, r6, r0
    1618:	0004c213 	andeq	ip, r4, r3, lsl r2
    161c:	02000c00 	andeq	r0, r0, #0, 24
    1620:	04dc0704 	ldrbeq	r0, [ip], #1796	; 0x704
    1624:	5a070000 	bpl	1c162c <__bss_end+0x1b7b1c>
    1628:	70000004 	andvc	r0, r0, r4
    162c:	59082806 	stmdbpl	r8, {r1, r2, fp, sp}
    1630:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1634:	00001276 	andeq	r1, r0, r6, ror r2
    1638:	83122a06 	tsthi	r2, #24576	; 0x6000
    163c:	00000004 	andeq	r0, r0, r4
    1640:	64697008 	strbtvs	r7, [r9], #-8
    1644:	122b0600 	eorne	r0, fp, #0, 12
    1648:	00000076 	andeq	r0, r0, r6, ror r0
    164c:	1b870e10 	blne	fe1c4e94 <__bss_end+0xfe1bb384>
    1650:	2c060000 	stccs	0, cr0, [r6], {-0}
    1654:	00044c11 	andeq	r4, r4, r1, lsl ip
    1658:	fe0e1400 	cdp2	4, 0, cr1, cr14, cr0, {0}
    165c:	0600000a 	streq	r0, [r0], -sl
    1660:	0076122d 	rsbseq	r1, r6, sp, lsr #4
    1664:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    1668:	00000b0c 	andeq	r0, r0, ip, lsl #22
    166c:	76122e06 	ldrvc	r2, [r2], -r6, lsl #28
    1670:	1c000000 	stcne	0, cr0, [r0], {-0}
    1674:	00073d0e 	andeq	r3, r7, lr, lsl #26
    1678:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 1680 <shift+0x1680>
    167c:	00000559 	andeq	r0, r0, r9, asr r5
    1680:	0b390e20 	bleq	e44f08 <__bss_end+0xe3b3f8>
    1684:	30060000 	andcc	r0, r6, r0
    1688:	00004909 	andeq	r4, r0, r9, lsl #18
    168c:	5f0e6000 	svcpl	0x000e6000
    1690:	0600000f 	streq	r0, [r0], -pc
    1694:	00650e31 	rsbeq	r0, r5, r1, lsr lr
    1698:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    169c:	000004a5 	andeq	r0, r0, r5, lsr #9
    16a0:	650e3306 	strvs	r3, [lr, #-774]	; 0xfffffcfa
    16a4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    16a8:	00049c0e 	andeq	r9, r4, lr, lsl #24
    16ac:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
    16b0:	00000065 	andeq	r0, r0, r5, rrx
    16b4:	0416006c 	ldreq	r0, [r6], #-108	; 0xffffff94
    16b8:	69000004 	stmdbvs	r0, {r2}
    16bc:	17000005 	strne	r0, [r0, -r5]
    16c0:	00000076 	andeq	r0, r0, r6, ror r0
    16c4:	8006000f 	andhi	r0, r6, pc
    16c8:	07000011 	smladeq	r0, r1, r0, r0
    16cc:	0071140a 	rsbseq	r1, r1, sl, lsl #8
    16d0:	03050000 	movweq	r0, #20480	; 0x5000
    16d4:	00009ad4 	ldrdeq	r9, [r0], -r4
    16d8:	000aac09 	andeq	sl, sl, r9, lsl #24
    16dc:	49040500 	stmdbmi	r4, {r8, sl}
    16e0:	07000000 	streq	r0, [r0, -r0]
    16e4:	059a0c0d 	ldreq	r0, [sl, #3085]	; 0xc0d
    16e8:	980b0000 	stmdals	fp, {}	; <UNPREDICTABLE>
    16ec:	00000005 	andeq	r0, r0, r5
    16f0:	00039b0b 	andeq	r9, r3, fp, lsl #22
    16f4:	03000100 	movweq	r0, #256	; 0x100
    16f8:	0000057b 	andeq	r0, r0, fp, ror r5
    16fc:	00143509 	andseq	r3, r4, r9, lsl #10
    1700:	49040500 	stmdbmi	r4, {r8, sl}
    1704:	07000000 	streq	r0, [r0, -r0]
    1708:	05be0c14 	ldreq	r0, [lr, #3092]!	; 0xc14
    170c:	a30b0000 	movwge	r0, #45056	; 0xb000
    1710:	00000012 	andeq	r0, r0, r2, lsl r0
    1714:	0014d40b 	andseq	sp, r4, fp, lsl #8
    1718:	03000100 	movweq	r0, #256	; 0x100
    171c:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1720:	00104c07 	andseq	r4, r0, r7, lsl #24
    1724:	1b070c00 	blne	1c472c <__bss_end+0x1bac1c>
    1728:	0005f808 	andeq	pc, r5, r8, lsl #16
    172c:	042c0e00 	strteq	r0, [ip], #-3584	; 0xfffff200
    1730:	1d070000 	stcne	0, cr0, [r7, #-0]
    1734:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
    1738:	540e0000 	strpl	r0, [lr], #-0
    173c:	07000005 	streq	r0, [r0, -r5]
    1740:	05f8191e 	ldrbeq	r1, [r8, #2334]!	; 0x91e
    1744:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1748:	00000fd3 	ldrdeq	r0, [r0], -r3
    174c:	fe131f07 	cdp2	15, 1, cr1, cr3, cr7, {0}
    1750:	08000005 	stmdaeq	r0, {r0, r2}
    1754:	c3041800 	movwgt	r1, #18432	; 0x4800
    1758:	18000005 	stmdane	r0, {r0, r2}
    175c:	0004c904 	andeq	ip, r4, r4, lsl #18
    1760:	06440d00 	strbeq	r0, [r4], -r0, lsl #26
    1764:	07140000 	ldreq	r0, [r4, -r0]
    1768:	08860722 	stmeq	r6, {r1, r5, r8, r9, sl}
    176c:	9a0e0000 	bls	381774 <__bss_end+0x377c64>
    1770:	0700000a 	streq	r0, [r0, -sl]
    1774:	00651226 	rsbeq	r1, r5, r6, lsr #4
    1778:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    177c:	000004ee 	andeq	r0, r0, lr, ror #9
    1780:	f81d2907 			; <UNDEFINED> instruction: 0xf81d2907
    1784:	04000005 	streq	r0, [r0], #-5
    1788:	000ea60e 	andeq	sl, lr, lr, lsl #12
    178c:	1d2c0700 	stcne	7, cr0, [ip, #-0]
    1790:	000005f8 	strdeq	r0, [r0], -r8
    1794:	112f1b08 			; <UNDEFINED> instruction: 0x112f1b08
    1798:	2f070000 	svccs	0x00070000
    179c:	0010290e 	andseq	r2, r0, lr, lsl #18
    17a0:	00064c00 	andeq	r4, r6, r0, lsl #24
    17a4:	00065700 	andeq	r5, r6, r0, lsl #14
    17a8:	088b1000 	stmeq	fp, {ip}
    17ac:	f8110000 			; <UNDEFINED> instruction: 0xf8110000
    17b0:	00000005 	andeq	r0, r0, r5
    17b4:	000fe21c 	andeq	lr, pc, ip, lsl r2	; <UNPREDICTABLE>
    17b8:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
    17bc:	00000431 	andeq	r0, r0, r1, lsr r4
    17c0:	000003d5 	ldrdeq	r0, [r0], -r5
    17c4:	0000066f 	andeq	r0, r0, pc, ror #12
    17c8:	0000067a 	andeq	r0, r0, sl, ror r6
    17cc:	00088b10 	andeq	r8, r8, r0, lsl fp
    17d0:	05fe1100 	ldrbeq	r1, [lr, #256]!	; 0x100
    17d4:	13000000 	movwne	r0, #0
    17d8:	0000108e 	andeq	r1, r0, lr, lsl #1
    17dc:	ae1d3507 	cfmul32ge	mvfx3, mvfx13, mvfx7
    17e0:	f800000f 			; <UNDEFINED> instruction: 0xf800000f
    17e4:	02000005 	andeq	r0, r0, #5
    17e8:	00000693 	muleq	r0, r3, r6
    17ec:	00000699 	muleq	r0, r9, r6
    17f0:	00088b10 	andeq	r8, r8, r0, lsl fp
    17f4:	f5130000 			; <UNDEFINED> instruction: 0xf5130000
    17f8:	07000009 	streq	r0, [r0, -r9]
    17fc:	0dab1d37 	stceq	13, cr1, [fp, #220]!	; 0xdc
    1800:	05f80000 	ldrbeq	r0, [r8, #0]!
    1804:	b2020000 	andlt	r0, r2, #0
    1808:	b8000006 	stmdalt	r0, {r1, r2}
    180c:	10000006 	andne	r0, r0, r6
    1810:	0000088b 	andeq	r0, r0, fp, lsl #17
    1814:	0b691d00 	bleq	1a48c1c <__bss_end+0x1a3f10c>
    1818:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
    181c:	0008a431 	andeq	sl, r8, r1, lsr r4
    1820:	13020c00 	movwne	r0, #11264	; 0x2c00
    1824:	00000644 	andeq	r0, r0, r4, asr #12
    1828:	52093c07 	andpl	r3, r9, #1792	; 0x700
    182c:	8b000012 	blhi	187c <shift+0x187c>
    1830:	01000008 	tsteq	r0, r8
    1834:	000006df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1838:	000006e5 	andeq	r0, r0, r5, ror #13
    183c:	00088b10 	andeq	r8, r8, r0, lsl fp
    1840:	d2130000 	andsle	r0, r3, #0
    1844:	07000005 	streq	r0, [r0, -r5]
    1848:	1104123f 	tstne	r4, pc, lsr r2
    184c:	00650000 	rsbeq	r0, r5, r0
    1850:	fe010000 	cdp2	0, 0, cr0, cr1, cr0, {0}
    1854:	13000006 	movwne	r0, #6
    1858:	10000007 	andne	r0, r0, r7
    185c:	0000088b 	andeq	r0, r0, fp, lsl #17
    1860:	0008ad11 	andeq	sl, r8, r1, lsl sp
    1864:	00761100 	rsbseq	r1, r6, r0, lsl #2
    1868:	d5110000 	ldrle	r0, [r1, #-0]
    186c:	00000003 	andeq	r0, r0, r3
    1870:	000ff114 	andeq	pc, pc, r4, lsl r1	; <UNPREDICTABLE>
    1874:	0e420700 	cdpeq	7, 4, cr0, cr2, cr0, {0}
    1878:	00000cef 	andeq	r0, r0, pc, ror #25
    187c:	00072801 	andeq	r2, r7, r1, lsl #16
    1880:	00072e00 	andeq	r2, r7, r0, lsl #28
    1884:	088b1000 	stmeq	fp, {ip}
    1888:	13000000 	movwne	r0, #0
    188c:	00000957 	andeq	r0, r0, r7, asr r9
    1890:	13174507 	tstne	r7, #29360128	; 0x1c00000
    1894:	fe000005 	cdp2	0, 0, cr0, cr0, cr5, {0}
    1898:	01000005 	tsteq	r0, r5
    189c:	00000747 	andeq	r0, r0, r7, asr #14
    18a0:	0000074d 	andeq	r0, r0, sp, asr #14
    18a4:	0008b310 	andeq	fp, r8, r0, lsl r3
    18a8:	59130000 	ldmdbpl	r3, {}	; <UNPREDICTABLE>
    18ac:	07000005 	streq	r0, [r0, -r5]
    18b0:	0f6b1748 	svceq	0x006b1748
    18b4:	05fe0000 	ldrbeq	r0, [lr, #0]!
    18b8:	66010000 	strvs	r0, [r1], -r0
    18bc:	71000007 	tstvc	r0, r7
    18c0:	10000007 	andne	r0, r0, r7
    18c4:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    18c8:	00006511 	andeq	r6, r0, r1, lsl r5
    18cc:	9d140000 	ldcls	0, cr0, [r4, #-0]
    18d0:	07000011 	smladeq	r0, r1, r0, r0
    18d4:	0ffa0e4b 	svceq	0x00fa0e4b
    18d8:	86010000 	strhi	r0, [r1], -r0
    18dc:	8c000007 	stchi	0, cr0, [r0], {7}
    18e0:	10000007 	andne	r0, r0, r7
    18e4:	0000088b 	andeq	r0, r0, fp, lsl #17
    18e8:	0fe21300 	svceq	0x00e21300
    18ec:	4d070000 	stcmi	0, cr0, [r7, #-0]
    18f0:	0007b60e 	andeq	fp, r7, lr, lsl #12
    18f4:	0003d500 	andeq	sp, r3, r0, lsl #10
    18f8:	07a50100 	streq	r0, [r5, r0, lsl #2]!
    18fc:	07b00000 	ldreq	r0, [r0, r0]!
    1900:	8b100000 	blhi	401908 <__bss_end+0x3f7df8>
    1904:	11000008 	tstne	r0, r8
    1908:	00000065 	andeq	r0, r0, r5, rrx
    190c:	096b1300 	stmdbeq	fp!, {r8, r9, ip}^
    1910:	50070000 	andpl	r0, r7, r0
    1914:	000d1012 	andeq	r1, sp, r2, lsl r0
    1918:	00006500 	andeq	r6, r0, r0, lsl #10
    191c:	07c90100 	strbeq	r0, [r9, r0, lsl #2]
    1920:	07d40000 	ldrbeq	r0, [r4, r0]
    1924:	8b100000 	blhi	40192c <__bss_end+0x3f7e1c>
    1928:	11000008 	tstne	r0, r8
    192c:	00000404 	andeq	r0, r0, r4, lsl #8
    1930:	0ba01300 	bleq	fe806538 <__bss_end+0xfe7fca28>
    1934:	53070000 	movwpl	r0, #28672	; 0x7000
    1938:	00089c0e 	andeq	r9, r8, lr, lsl #24
    193c:	0003d500 	andeq	sp, r3, r0, lsl #10
    1940:	07ed0100 	strbeq	r0, [sp, r0, lsl #2]!
    1944:	07f80000 	ldrbeq	r0, [r8, r0]!
    1948:	8b100000 	blhi	401950 <__bss_end+0x3f7e40>
    194c:	11000008 	tstne	r0, r8
    1950:	00000065 	andeq	r0, r0, r5, rrx
    1954:	09cf1400 	stmibeq	pc, {sl, ip}^	; <UNPREDICTABLE>
    1958:	56070000 	strpl	r0, [r7], -r0
    195c:	0010ad0e 	andseq	sl, r0, lr, lsl #26
    1960:	080d0100 	stmdaeq	sp, {r8}
    1964:	082c0000 	stmdaeq	ip!, {}	; <UNPREDICTABLE>
    1968:	8b100000 	blhi	401970 <__bss_end+0x3f7e60>
    196c:	11000008 	tstne	r0, r8
    1970:	00000110 	andeq	r0, r0, r0, lsl r1
    1974:	00006511 	andeq	r6, r0, r1, lsl r5
    1978:	00651100 	rsbeq	r1, r5, r0, lsl #2
    197c:	65110000 	ldrvs	r0, [r1, #-0]
    1980:	11000000 	mrsne	r0, (UNDEF: 0)
    1984:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    1988:	0f981400 	svceq	0x00981400
    198c:	58070000 	stmdapl	r7, {}	; <UNPREDICTABLE>
    1990:	0006d80e 	andeq	sp, r6, lr, lsl #16
    1994:	08410100 	stmdaeq	r1, {r8}^
    1998:	08600000 	stmdaeq	r0!, {}^	; <UNPREDICTABLE>
    199c:	8b100000 	blhi	4019a4 <__bss_end+0x3f7e94>
    19a0:	11000008 	tstne	r0, r8
    19a4:	00000147 	andeq	r0, r0, r7, asr #2
    19a8:	00006511 	andeq	r6, r0, r1, lsl r5
    19ac:	00651100 	rsbeq	r1, r5, r0, lsl #2
    19b0:	65110000 	ldrvs	r0, [r1, #-0]
    19b4:	11000000 	mrsne	r0, (UNDEF: 0)
    19b8:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    19bc:	06091500 	streq	r1, [r9], -r0, lsl #10
    19c0:	5b070000 	blpl	1c19c8 <__bss_end+0x1b7eb8>
    19c4:	00066a0e 	andeq	r6, r6, lr, lsl #20
    19c8:	0003d500 	andeq	sp, r3, r0, lsl #10
    19cc:	08750100 	ldmdaeq	r5!, {r8}^
    19d0:	8b100000 	blhi	4019d8 <__bss_end+0x3f7ec8>
    19d4:	11000008 	tstne	r0, r8
    19d8:	0000057b 	andeq	r0, r0, fp, ror r5
    19dc:	0008bf11 	andeq	fp, r8, r1, lsl pc
    19e0:	03000000 	movweq	r0, #0
    19e4:	00000604 	andeq	r0, r0, r4, lsl #12
    19e8:	06040418 			; <UNDEFINED> instruction: 0x06040418
    19ec:	f81e0000 			; <UNDEFINED> instruction: 0xf81e0000
    19f0:	9e000005 	cdpls	0, 0, cr0, cr0, cr5, {0}
    19f4:	a4000008 	strge	r0, [r0], #-8
    19f8:	10000008 	andne	r0, r0, r8
    19fc:	0000088b 	andeq	r0, r0, fp, lsl #17
    1a00:	06041f00 	streq	r1, [r4], -r0, lsl #30
    1a04:	08910000 	ldmeq	r1, {}	; <UNPREDICTABLE>
    1a08:	04180000 	ldreq	r0, [r8], #-0
    1a0c:	00000057 	andeq	r0, r0, r7, asr r0
    1a10:	08860418 	stmeq	r6, {r3, r4, sl}
    1a14:	04200000 	strteq	r0, [r0], #-0
    1a18:	000000cc 	andeq	r0, r0, ip, asr #1
    1a1c:	771a0421 	ldrvc	r0, [sl, -r1, lsr #8]
    1a20:	0700000b 	streq	r0, [r0, -fp]
    1a24:	0604195e 			; <UNDEFINED> instruction: 0x0604195e
    1a28:	24060000 	strcs	r0, [r6], #-0
    1a2c:	0800000c 	stmdaeq	r0, {r2, r3}
    1a30:	08e61104 	stmiaeq	r6!, {r2, r8, ip}^
    1a34:	03050000 	movweq	r0, #20480	; 0x5000
    1a38:	00009ad8 	ldrdeq	r9, [r0], -r8
    1a3c:	05040402 	streq	r0, [r4, #-1026]	; 0xfffffbfe
    1a40:	0300001c 	movweq	r0, #28
    1a44:	000008df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1a48:	00002c16 	andeq	r2, r0, r6, lsl ip
    1a4c:	0008fb00 	andeq	pc, r8, r0, lsl #22
    1a50:	00761700 	rsbseq	r1, r6, r0, lsl #14
    1a54:	00090000 	andeq	r0, r9, r0
    1a58:	0008eb03 	andeq	lr, r8, r3, lsl #22
    1a5c:	135a2200 	cmpne	sl, #0, 4
    1a60:	a4010000 	strge	r0, [r1], #-0
    1a64:	0008fb0c 	andeq	pc, r8, ip, lsl #22
    1a68:	dc030500 	cfstr32le	mvfx0, [r3], {-0}
    1a6c:	2300009a 	movwcs	r0, #154	; 0x9a
    1a70:	000012bc 			; <UNDEFINED> instruction: 0x000012bc
    1a74:	290aa601 	stmdbcs	sl, {r0, r9, sl, sp, pc}
    1a78:	65000014 	strvs	r0, [r0, #-20]	; 0xffffffec
    1a7c:	6c000000 	stcvs	0, cr0, [r0], {-0}
    1a80:	b0000087 	andlt	r0, r0, r7, lsl #1
    1a84:	01000000 	mrseq	r0, (UNDEF: 0)
    1a88:	0009709c 	muleq	r9, ip, r0
    1a8c:	21942400 	orrscs	r2, r4, r0, lsl #8
    1a90:	a6010000 	strge	r0, [r1], -r0
    1a94:	0003e21b 	andeq	lr, r3, fp, lsl r2
    1a98:	ac910300 	ldcge	3, cr0, [r1], {0}
    1a9c:	14b5247f 	ldrtne	r2, [r5], #1151	; 0x47f
    1aa0:	a6010000 	strge	r0, [r1], -r0
    1aa4:	0000652a 	andeq	r6, r0, sl, lsr #10
    1aa8:	a8910300 	ldmge	r1, {r8, r9}
    1aac:	1411227f 	ldrne	r2, [r1], #-639	; 0xfffffd81
    1ab0:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    1ab4:	0009700a 	andeq	r7, r9, sl
    1ab8:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    1abc:	12b7227f 	adcsne	r2, r7, #-268435449	; 0xf0000007
    1ac0:	ac010000 	stcge	0, cr0, [r1], {-0}
    1ac4:	00004909 	andeq	r4, r0, r9, lsl #18
    1ac8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1acc:	00251600 	eoreq	r1, r5, r0, lsl #12
    1ad0:	09800000 	stmibeq	r0, {}	; <UNPREDICTABLE>
    1ad4:	76170000 	ldrvc	r0, [r7], -r0
    1ad8:	3f000000 	svccc	0x00000000
    1adc:	14942500 	ldrne	r2, [r4], #1280	; 0x500
    1ae0:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1ae4:	0014f90a 	andseq	pc, r4, sl, lsl #18
    1ae8:	00006500 	andeq	r6, r0, r0, lsl #10
    1aec:	00873000 	addeq	r3, r7, r0
    1af0:	00003c00 	andeq	r3, r0, r0, lsl #24
    1af4:	bd9c0100 	ldflts	f0, [ip]
    1af8:	26000009 	strcs	r0, [r0], -r9
    1afc:	00716572 	rsbseq	r6, r1, r2, ror r5
    1b00:	be209a01 	vmullt.f32	s18, s0, s2
    1b04:	02000005 	andeq	r0, r0, #5
    1b08:	1e227491 	mcrne	4, 1, r7, cr2, cr1, {4}
    1b0c:	01000014 	tsteq	r0, r4, lsl r0
    1b10:	00650e9b 	mlseq	r5, fp, lr, r0
    1b14:	91020000 	mrsls	r0, (UNDEF: 2)
    1b18:	a8270070 	stmdage	r7!, {r4, r5, r6}
    1b1c:	01000013 	tsteq	r0, r3, lsl r0
    1b20:	12e4068f 	rscne	r0, r4, #149946368	; 0x8f00000
    1b24:	86f40000 	ldrbthi	r0, [r4], r0
    1b28:	003c0000 	eorseq	r0, ip, r0
    1b2c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b30:	000009f6 	strdeq	r0, [r0], -r6
    1b34:	00134624 	andseq	r4, r3, r4, lsr #12
    1b38:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1b3c:	00000065 	andeq	r0, r0, r5, rrx
    1b40:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1b44:	00716572 	rsbseq	r6, r1, r2, ror r5
    1b48:	be209101 	abslts	f1, f1
    1b4c:	02000005 	andeq	r0, r0, #5
    1b50:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b54:	0000144a 	andeq	r1, r0, sl, asr #8
    1b58:	760a8301 	strvc	r8, [sl], -r1, lsl #6
    1b5c:	65000013 	strvs	r0, [r0, #-19]	; 0xffffffed
    1b60:	b8000000 	stmdalt	r0, {}	; <UNPREDICTABLE>
    1b64:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1b68:	01000000 	mrseq	r0, (UNDEF: 0)
    1b6c:	000a339c 	muleq	sl, ip, r3
    1b70:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1b74:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1b78:	00059a20 	andeq	r9, r5, r0, lsr #20
    1b7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b80:	0012b022 	andseq	fp, r2, r2, lsr #32
    1b84:	0e860100 	rmfeqs	f0, f6, f0
    1b88:	00000065 	andeq	r0, r0, r5, rrx
    1b8c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1b90:	00159725 	andseq	r9, r5, r5, lsr #14
    1b94:	0a770100 	beq	1dc1f9c <__bss_end+0x1db848c>
    1b98:	00001328 	andeq	r1, r0, r8, lsr #6
    1b9c:	00000065 	andeq	r0, r0, r5, rrx
    1ba0:	0000867c 	andeq	r8, r0, ip, ror r6
    1ba4:	0000003c 	andeq	r0, r0, ip, lsr r0
    1ba8:	0a709c01 	beq	1c28bb4 <__bss_end+0x1c1f0a4>
    1bac:	72260000 	eorvc	r0, r6, #0
    1bb0:	01007165 	tsteq	r0, r5, ror #2
    1bb4:	059a2079 	ldreq	r2, [sl, #121]	; 0x79
    1bb8:	91020000 	mrsls	r0, (UNDEF: 2)
    1bbc:	12b02274 	adcsne	r2, r0, #116, 4	; 0x40000007
    1bc0:	7a010000 	bvc	41bc8 <__bss_end+0x380b8>
    1bc4:	0000650e 	andeq	r6, r0, lr, lsl #10
    1bc8:	70910200 	addsvc	r0, r1, r0, lsl #4
    1bcc:	138a2500 	orrne	r2, sl, #0, 10
    1bd0:	6b010000 	blvs	41bd8 <__bss_end+0x380c8>
    1bd4:	0014c906 	andseq	ip, r4, r6, lsl #18
    1bd8:	0003d500 	andeq	sp, r3, r0, lsl #10
    1bdc:	00862800 	addeq	r2, r6, r0, lsl #16
    1be0:	00005400 	andeq	r5, r0, r0, lsl #8
    1be4:	bc9c0100 	ldflts	f0, [ip], {0}
    1be8:	2400000a 	strcs	r0, [r0], #-10
    1bec:	0000141e 	andeq	r1, r0, lr, lsl r4
    1bf0:	65156b01 	ldrvs	r6, [r5, #-2817]	; 0xfffff4ff
    1bf4:	02000000 	andeq	r0, r0, #0
    1bf8:	9c246c91 	stcls	12, cr6, [r4], #-580	; 0xfffffdbc
    1bfc:	01000004 	tsteq	r0, r4
    1c00:	0065256b 	rsbeq	r2, r5, fp, ror #10
    1c04:	91020000 	mrsls	r0, (UNDEF: 2)
    1c08:	158f2268 	strne	r2, [pc, #616]	; 1e78 <shift+0x1e78>
    1c0c:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1c10:	0000650e 	andeq	r6, r0, lr, lsl #10
    1c14:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c18:	12fb2500 	rscsne	r2, fp, #0, 10
    1c1c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c20:	00153012 	andseq	r3, r5, r2, lsl r0
    1c24:	0000f200 	andeq	pc, r0, r0, lsl #4
    1c28:	0085d800 	addeq	sp, r5, r0, lsl #16
    1c2c:	00005000 	andeq	r5, r0, r0
    1c30:	179c0100 	ldrne	r0, [ip, r0, lsl #2]
    1c34:	2400000b 	strcs	r0, [r0], #-11
    1c38:	0000121a 	andeq	r1, r0, sl, lsl r2
    1c3c:	65205e01 	strvs	r5, [r0, #-3585]!	; 0xfffff1ff
    1c40:	02000000 	andeq	r0, r0, #0
    1c44:	53246c91 			; <UNDEFINED> instruction: 0x53246c91
    1c48:	01000014 	tsteq	r0, r4, lsl r0
    1c4c:	00652f5e 	rsbeq	r2, r5, lr, asr pc
    1c50:	91020000 	mrsls	r0, (UNDEF: 2)
    1c54:	049c2468 	ldreq	r2, [ip], #1128	; 0x468
    1c58:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c5c:	0000653f 	andeq	r6, r0, pc, lsr r5
    1c60:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c64:	00158f22 	andseq	r8, r5, r2, lsr #30
    1c68:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1c6c:	000000f2 	strdeq	r0, [r0], -r2
    1c70:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c74:	00141725 	andseq	r1, r4, r5, lsr #14
    1c78:	0a520100 	beq	1482080 <__bss_end+0x1478570>
    1c7c:	00001300 	andeq	r1, r0, r0, lsl #6
    1c80:	00000065 	andeq	r0, r0, r5, rrx
    1c84:	00008594 	muleq	r0, r4, r5
    1c88:	00000044 	andeq	r0, r0, r4, asr #32
    1c8c:	0b639c01 	bleq	18e8c98 <__bss_end+0x18df188>
    1c90:	1a240000 	bne	901c98 <__bss_end+0x8f8188>
    1c94:	01000012 	tsteq	r0, r2, lsl r0
    1c98:	00651a52 	rsbeq	r1, r5, r2, asr sl
    1c9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca0:	1453246c 	ldrbne	r2, [r3], #-1132	; 0xfffffb94
    1ca4:	52010000 	andpl	r0, r1, #0
    1ca8:	00006529 	andeq	r6, r0, r9, lsr #10
    1cac:	68910200 	ldmvs	r1, {r9}
    1cb0:	00155f22 	andseq	r5, r5, r2, lsr #30
    1cb4:	0e540100 	rdfeqs	f0, f4, f0
    1cb8:	00000065 	andeq	r0, r0, r5, rrx
    1cbc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cc0:	00155925 	andseq	r5, r5, r5, lsr #18
    1cc4:	0a450100 	beq	11420cc <__bss_end+0x11385bc>
    1cc8:	0000153b 	andeq	r1, r0, fp, lsr r5
    1ccc:	00000065 	andeq	r0, r0, r5, rrx
    1cd0:	00008544 	andeq	r8, r0, r4, asr #10
    1cd4:	00000050 	andeq	r0, r0, r0, asr r0
    1cd8:	0bbe9c01 	bleq	fefa8ce4 <__bss_end+0xfef9f1d4>
    1cdc:	1a240000 	bne	901ce4 <__bss_end+0x8f81d4>
    1ce0:	01000012 	tsteq	r0, r2, lsl r0
    1ce4:	00651945 	rsbeq	r1, r5, r5, asr #18
    1ce8:	91020000 	mrsls	r0, (UNDEF: 2)
    1cec:	13ba246c 			; <UNDEFINED> instruction: 0x13ba246c
    1cf0:	45010000 	strmi	r0, [r1, #-0]
    1cf4:	00018430 	andeq	r8, r1, r0, lsr r4
    1cf8:	68910200 	ldmvs	r1, {r9}
    1cfc:	00148024 	andseq	r8, r4, r4, lsr #32
    1d00:	41450100 	mrsmi	r0, (UNDEF: 85)
    1d04:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
    1d08:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d0c:	0000158f 	andeq	r1, r0, pc, lsl #11
    1d10:	650e4701 	strvs	r4, [lr, #-1793]	; 0xfffff8ff
    1d14:	02000000 	andeq	r0, r0, #0
    1d18:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1d1c:	0000129d 	muleq	r0, sp, r2
    1d20:	c4063f01 	strgt	r3, [r6], #-3841	; 0xfffff0ff
    1d24:	18000013 	stmdane	r0, {r0, r1, r4}
    1d28:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1d2c:	01000000 	mrseq	r0, (UNDEF: 0)
    1d30:	000be89c 	muleq	fp, ip, r8
    1d34:	121a2400 	andsne	r2, sl, #0, 8
    1d38:	3f010000 	svccc	0x00010000
    1d3c:	00006515 	andeq	r6, r0, r5, lsl r5
    1d40:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d44:	14af2500 	strtne	r2, [pc], #1280	; 1d4c <shift+0x1d4c>
    1d48:	32010000 	andcc	r0, r1, #0
    1d4c:	0014860a 	andseq	r8, r4, sl, lsl #12
    1d50:	00006500 	andeq	r6, r0, r0, lsl #10
    1d54:	0084c800 	addeq	ip, r4, r0, lsl #16
    1d58:	00005000 	andeq	r5, r0, r0
    1d5c:	439c0100 	orrsmi	r0, ip, #0, 2
    1d60:	2400000c 	strcs	r0, [r0], #-12
    1d64:	0000121a 	andeq	r1, r0, sl, lsl r2
    1d68:	65193201 	ldrvs	r3, [r9, #-513]	; 0xfffffdff
    1d6c:	02000000 	andeq	r0, r0, #0
    1d70:	6b246c91 	blvs	91cfbc <__bss_end+0x9134ac>
    1d74:	01000015 	tsteq	r0, r5, lsl r0
    1d78:	03e22b32 	mvneq	r2, #51200	; 0xc800
    1d7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d80:	14b92468 	ldrtne	r2, [r9], #1128	; 0x468
    1d84:	32010000 	andcc	r0, r1, #0
    1d88:	0000653c 	andeq	r6, r0, ip, lsr r5
    1d8c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1d90:	00152a22 	andseq	r2, r5, r2, lsr #20
    1d94:	0e340100 	rsfeqs	f0, f4, f0
    1d98:	00000065 	andeq	r0, r0, r5, rrx
    1d9c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1da0:	0015b925 	andseq	fp, r5, r5, lsr #18
    1da4:	0a250100 	beq	9421ac <__bss_end+0x93869c>
    1da8:	00001572 	andeq	r1, r0, r2, ror r5
    1dac:	00000065 	andeq	r0, r0, r5, rrx
    1db0:	00008478 	andeq	r8, r0, r8, ror r4
    1db4:	00000050 	andeq	r0, r0, r0, asr r0
    1db8:	0c9e9c01 	ldceq	12, cr9, [lr], {1}
    1dbc:	1a240000 	bne	901dc4 <__bss_end+0x8f82b4>
    1dc0:	01000012 	tsteq	r0, r2, lsl r0
    1dc4:	00651825 	rsbeq	r1, r5, r5, lsr #16
    1dc8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dcc:	156b246c 	strbne	r2, [fp, #-1132]!	; 0xfffffb94
    1dd0:	25010000 	strcs	r0, [r1, #-0]
    1dd4:	000ca42a 	andeq	sl, ip, sl, lsr #8
    1dd8:	68910200 	ldmvs	r1, {r9}
    1ddc:	0014b924 	andseq	fp, r4, r4, lsr #18
    1de0:	3b250100 	blcc	9421e8 <__bss_end+0x9386d8>
    1de4:	00000065 	andeq	r0, r0, r5, rrx
    1de8:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1dec:	000012cd 	andeq	r1, r0, sp, asr #5
    1df0:	650e2701 	strvs	r2, [lr, #-1793]	; 0xfffff8ff
    1df4:	02000000 	andeq	r0, r0, #0
    1df8:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1dfc:	00002504 	andeq	r2, r0, r4, lsl #10
    1e00:	0c9e0300 	ldceq	3, cr0, [lr], {0}
    1e04:	24250000 	strtcs	r0, [r5], #-0
    1e08:	01000014 	tsteq	r0, r4, lsl r0
    1e0c:	15cf0a19 	strbne	r0, [pc, #2585]	; 282d <shift+0x282d>
    1e10:	00650000 	rsbeq	r0, r5, r0
    1e14:	84340000 	ldrthi	r0, [r4], #-0
    1e18:	00440000 	subeq	r0, r4, r0
    1e1c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e20:	00000cf5 	strdeq	r0, [r0], -r5
    1e24:	0015b024 	andseq	fp, r5, r4, lsr #32
    1e28:	1b190100 	blne	642230 <__bss_end+0x638720>
    1e2c:	000003e2 	andeq	r0, r0, r2, ror #7
    1e30:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1e34:	00001566 	andeq	r1, r0, r6, ror #10
    1e38:	2d351901 			; <UNDEFINED> instruction: 0x2d351901
    1e3c:	02000002 	andeq	r0, r0, #2
    1e40:	1a226891 	bne	89c08c <__bss_end+0x89257c>
    1e44:	01000012 	tsteq	r0, r2, lsl r0
    1e48:	00650e1b 	rsbeq	r0, r5, fp, lsl lr
    1e4c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e50:	c1280074 			; <UNDEFINED> instruction: 0xc1280074
    1e54:	01000012 	tsteq	r0, r2, lsl r0
    1e58:	12d30614 	sbcsne	r0, r3, #20, 12	; 0x1400000
    1e5c:	84180000 	ldrhi	r0, [r8], #-0
    1e60:	001c0000 	andseq	r0, ip, r0
    1e64:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e68:	0015be27 	andseq	fp, r5, r7, lsr #28
    1e6c:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1e70:	0000130c 	andeq	r1, r0, ip, lsl #6
    1e74:	000083ec 	andeq	r8, r0, ip, ror #7
    1e78:	0000002c 	andeq	r0, r0, ip, lsr #32
    1e7c:	0d359c01 	ldceq	12, cr9, [r5, #-4]!
    1e80:	1f240000 	svcne	0x00240000
    1e84:	01000013 	tsteq	r0, r3, lsl r0
    1e88:	0049140e 	subeq	r1, r9, lr, lsl #8
    1e8c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e90:	c8290074 	stmdagt	r9!, {r2, r4, r5, r6}
    1e94:	01000015 	tsteq	r0, r5, lsl r0
    1e98:	14060a04 	strne	r0, [r6], #-2564	; 0xfffff5fc
    1e9c:	00650000 	rsbeq	r0, r5, r0
    1ea0:	83c00000 	bichi	r0, r0, #0
    1ea4:	002c0000 	eoreq	r0, ip, r0
    1ea8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1eac:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1eb0:	0e060100 	adfeqs	f0, f6, f0
    1eb4:	00000065 	andeq	r0, r0, r5, rrx
    1eb8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ebc:	0006f900 	andeq	pc, r6, r0, lsl #18
    1ec0:	2b000400 	blcs	2ec8 <shift+0x2ec8>
    1ec4:	04000007 	streq	r0, [r0], #-7
    1ec8:	0015eb01 	andseq	lr, r5, r1, lsl #22
    1ecc:	16ce0400 	strbne	r0, [lr], r0, lsl #8
    1ed0:	14590000 	ldrbne	r0, [r9], #-0
    1ed4:	881c0000 	ldmdahi	ip, {}	; <UNPREDICTABLE>
    1ed8:	0fdc0000 	svceq	0x00dc0000
    1edc:	07520000 	ldrbeq	r0, [r2, -r0]
    1ee0:	24020000 	strcs	r0, [r2], #-0
    1ee4:	0200000c 	andeq	r0, r0, #12
    1ee8:	003e1104 	eorseq	r1, lr, r4, lsl #2
    1eec:	03050000 	movweq	r0, #20480	; 0x5000
    1ef0:	00009ae8 	andeq	r9, r0, r8, ror #21
    1ef4:	05040403 	streq	r0, [r4, #-1027]	; 0xfffffbfd
    1ef8:	0400001c 	streq	r0, [r0], #-28	; 0xffffffe4
    1efc:	00000037 	andeq	r0, r0, r7, lsr r0
    1f00:	00006705 	andeq	r6, r0, r5, lsl #14
    1f04:	180e0600 	stmdane	lr, {r9, sl}
    1f08:	05010000 	streq	r0, [r1, #-0]
    1f0c:	00007f10 	andeq	r7, r0, r0, lsl pc
    1f10:	31301100 	teqcc	r0, r0, lsl #2
    1f14:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1f18:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1f1c:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1f20:	00004645 	andeq	r4, r0, r5, asr #12
    1f24:	01030107 	tsteq	r3, r7, lsl #2
    1f28:	00000043 	andeq	r0, r0, r3, asr #32
    1f2c:	00009708 	andeq	r9, r0, r8, lsl #14
    1f30:	00007f00 	andeq	r7, r0, r0, lsl #30
    1f34:	00840900 	addeq	r0, r4, r0, lsl #18
    1f38:	00100000 	andseq	r0, r0, r0
    1f3c:	00006f04 	andeq	r6, r0, r4, lsl #30
    1f40:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1f44:	000004e1 	andeq	r0, r0, r1, ror #9
    1f48:	00008404 	andeq	r8, r0, r4, lsl #8
    1f4c:	08010300 	stmdaeq	r1, {r8, r9}
    1f50:	00000d78 	andeq	r0, r0, r8, ror sp
    1f54:	00009004 	andeq	r9, r0, r4
    1f58:	00480a00 	subeq	r0, r8, r0, lsl #20
    1f5c:	020b0000 	andeq	r0, fp, #0
    1f60:	01000018 	tsteq	r0, r8, lsl r0
    1f64:	177907fc 			; <UNDEFINED> instruction: 0x177907fc
    1f68:	00370000 	eorseq	r0, r7, r0
    1f6c:	96e80000 	strbtls	r0, [r8], r0
    1f70:	01100000 	tsteq	r0, r0
    1f74:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f78:	0000011d 	andeq	r0, r0, sp, lsl r1
    1f7c:	0100730c 	tsteq	r0, ip, lsl #6
    1f80:	011d18fc 			; <UNDEFINED> instruction: 0x011d18fc
    1f84:	91020000 	mrsls	r0, (UNDEF: 2)
    1f88:	65720d64 	ldrbvs	r0, [r2, #-3428]!	; 0xfffff29c
    1f8c:	fe01007a 	mcr2	0, 0, r0, cr1, cr10, {3}
    1f90:	00003709 	andeq	r3, r0, r9, lsl #14
    1f94:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f98:	00189c0e 	andseq	r9, r8, lr, lsl #24
    1f9c:	12fe0100 	rscsne	r0, lr, #0, 2
    1fa0:	00000037 	andeq	r0, r0, r7, lsr r0
    1fa4:	0f709102 	svceq	0x00709102
    1fa8:	0000972c 	andeq	r9, r0, ip, lsr #14
    1fac:	000000a8 	andeq	r0, r0, r8, lsr #1
    1fb0:	00174010 	andseq	r4, r7, r0, lsl r0
    1fb4:	01030100 	mrseq	r0, (UNDEF: 19)
    1fb8:	0001230c 	andeq	r2, r1, ip, lsl #6
    1fbc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1fc0:	0097440f 	addseq	r4, r7, pc, lsl #8
    1fc4:	00008000 	andeq	r8, r0, r0
    1fc8:	00641100 	rsbeq	r1, r4, r0, lsl #2
    1fcc:	09010801 	stmdbeq	r1, {r0, fp}
    1fd0:	00000123 	andeq	r0, r0, r3, lsr #2
    1fd4:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1fd8:	04120000 	ldreq	r0, [r2], #-0
    1fdc:	00000097 	muleq	r0, r7, r0
    1fe0:	69050413 	stmdbvs	r5, {r0, r1, r4, sl}
    1fe4:	1400746e 	strne	r7, [r0], #-1134	; 0xfffffb92
    1fe8:	0000181a 	andeq	r1, r0, sl, lsl r8
    1fec:	8406c101 	strhi	ip, [r6], #-257	; 0xfffffeff
    1ff0:	c4000018 	strgt	r0, [r0], #-24	; 0xffffffe8
    1ff4:	24000093 	strcs	r0, [r0], #-147	; 0xffffff6d
    1ff8:	01000003 	tsteq	r0, r3
    1ffc:	0002299c 	muleq	r2, ip, r9
    2000:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    2004:	3711c101 	ldrcc	ip, [r1, -r1, lsl #2]
    2008:	03000000 	movweq	r0, #0
    200c:	0c7fa491 	cfldrdeq	mvd10, [pc], #-580	; 1dd0 <shift+0x1dd0>
    2010:	00726662 	rsbseq	r6, r2, r2, ror #12
    2014:	291ac101 	ldmdbcs	sl, {r0, r8, lr, pc}
    2018:	03000002 	movweq	r0, #2
    201c:	157fa091 	ldrbne	sl, [pc, #-145]!	; 1f93 <shift+0x1f93>
    2020:	00001752 	andeq	r1, r0, r2, asr r7
    2024:	8b32c101 	blhi	cb2430 <__bss_end+0xca8920>
    2028:	03000000 	movweq	r0, #0
    202c:	0e7f9c91 	mrceq	12, 3, r9, cr15, cr1, {4}
    2030:	0000185d 	andeq	r1, r0, sp, asr r8
    2034:	840fc301 	strhi	ip, [pc], #-769	; 203c <shift+0x203c>
    2038:	02000000 	andeq	r0, r0, #0
    203c:	460e7491 			; <UNDEFINED> instruction: 0x460e7491
    2040:	01000018 	tsteq	r0, r8, lsl r0
    2044:	012306d9 	ldrdeq	r0, [r3, -r9]!
    2048:	91020000 	mrsls	r0, (UNDEF: 2)
    204c:	175b0e70 			; <UNDEFINED> instruction: 0x175b0e70
    2050:	dd010000 	stcle	0, cr0, [r1, #-0]
    2054:	00003e11 	andeq	r3, r0, r1, lsl lr
    2058:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    205c:	0017180e 	andseq	r1, r7, lr, lsl #16
    2060:	18e00100 	stmiane	r0!, {r8}^
    2064:	0000008b 	andeq	r0, r0, fp, lsl #1
    2068:	0e609102 	lgneqs	f1, f2
    206c:	00001727 	andeq	r1, r0, r7, lsr #14
    2070:	8b18e101 	blhi	63a47c <__bss_end+0x63096c>
    2074:	02000000 	andeq	r0, r0, #0
    2078:	cd0e5c91 	stcgt	12, cr5, [lr, #-580]	; 0xfffffdbc
    207c:	01000017 	tsteq	r0, r7, lsl r0
    2080:	022f07e3 	eoreq	r0, pc, #59506688	; 0x38c0000
    2084:	91030000 	mrsls	r0, (UNDEF: 3)
    2088:	610e7fb8 			; <UNDEFINED> instruction: 0x610e7fb8
    208c:	01000017 	tsteq	r0, r7, lsl r0
    2090:	012306e5 	smulwteq	r3, r5, r6
    2094:	91020000 	mrsls	r0, (UNDEF: 2)
    2098:	95d01658 	ldrbls	r1, [r0, #1624]	; 0x658
    209c:	00500000 	subseq	r0, r0, r0
    20a0:	01f70000 	mvnseq	r0, r0
    20a4:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    20a8:	0be70100 	bleq	ff9c24b0 <__bss_end+0xff9b89a0>
    20ac:	00000123 	andeq	r0, r0, r3, lsr #2
    20b0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    20b4:	00962c0f 	addseq	r2, r6, pc, lsl #24
    20b8:	00009800 	andeq	r9, r0, r0, lsl #16
    20bc:	174b0e00 	strbne	r0, [fp, -r0, lsl #28]
    20c0:	ef010000 	svc	0x00010000
    20c4:	00023f08 	andeq	r3, r2, r8, lsl #30
    20c8:	ac910300 	ldcge	3, cr0, [r1], {0}
    20cc:	965c0f7f 	usub16ls	r0, ip, pc	; <UNPREDICTABLE>
    20d0:	00680000 	rsbeq	r0, r8, r0
    20d4:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    20d8:	0cf20100 	ldfeqe	f0, [r2]
    20dc:	00000123 	andeq	r0, r0, r3, lsr #2
    20e0:	00689102 	rsbeq	r9, r8, r2, lsl #2
    20e4:	04120000 	ldreq	r0, [r2], #-0
    20e8:	00000090 	muleq	r0, r0, r0
    20ec:	00009008 	andeq	r9, r0, r8
    20f0:	00023f00 	andeq	r3, r2, r0, lsl #30
    20f4:	00840900 	addeq	r0, r4, r0, lsl #18
    20f8:	001f0000 	andseq	r0, pc, r0
    20fc:	00009008 	andeq	r9, r0, r8
    2100:	00024f00 	andeq	r4, r2, r0, lsl #30
    2104:	00840900 	addeq	r0, r4, r0, lsl #18
    2108:	00080000 	andeq	r0, r8, r0
    210c:	00181a14 	andseq	r1, r8, r4, lsl sl
    2110:	06bb0100 	ldrteq	r0, [fp], r0, lsl #2
    2114:	000018e9 	andeq	r1, r0, r9, ror #17
    2118:	00009394 	muleq	r0, r4, r3
    211c:	00000030 	andeq	r0, r0, r0, lsr r0
    2120:	02869c01 	addeq	r9, r6, #256	; 0x100
    2124:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    2128:	11bb0100 			; <UNDEFINED> instruction: 0x11bb0100
    212c:	00000037 	andeq	r0, r0, r7, lsr r0
    2130:	0c749102 	ldfeqp	f1, [r4], #-8
    2134:	00726662 	rsbseq	r6, r2, r2, ror #12
    2138:	291abb01 	ldmdbcs	sl, {r0, r8, r9, fp, ip, sp, pc}
    213c:	02000002 	andeq	r0, r0, #2
    2140:	0b007091 	bleq	1e38c <__bss_end+0x1487c>
    2144:	00001721 	andeq	r1, r0, r1, lsr #14
    2148:	d806b501 	stmdale	r6, {r0, r8, sl, ip, sp, pc}
    214c:	b2000017 	andlt	r0, r0, #23
    2150:	54000002 	strpl	r0, [r0], #-2
    2154:	40000093 	mulmi	r0, r3, r0
    2158:	01000000 	mrseq	r0, (UNDEF: 0)
    215c:	0002b29c 	muleq	r2, ip, r2
    2160:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    2164:	3712b501 	ldrcc	fp, [r2, -r1, lsl #10]
    2168:	02000000 	andeq	r0, r0, #0
    216c:	03007491 	movweq	r7, #1169	; 0x491
    2170:	0a890201 	beq	fe24297c <__bss_end+0xfe238e6c>
    2174:	120b0000 	andne	r0, fp, #0
    2178:	01000017 	tsteq	r0, r7, lsl r0
    217c:	179506b0 			; <UNDEFINED> instruction: 0x179506b0
    2180:	02b20000 	adcseq	r0, r2, #0
    2184:	93180000 	tstls	r8, #0
    2188:	003c0000 	eorseq	r0, ip, r0
    218c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2190:	000002e5 	andeq	r0, r0, r5, ror #5
    2194:	0100780c 	tsteq	r0, ip, lsl #16
    2198:	003712b0 	ldrhteq	r1, [r7], -r0
    219c:	91020000 	mrsls	r0, (UNDEF: 2)
    21a0:	d1140074 	tstle	r4, r4, ror r0
    21a4:	01000018 	tsteq	r0, r8, lsl r0
    21a8:	181f06a5 	ldmdane	pc, {r0, r2, r5, r7, r9, sl}	; <UNPREDICTABLE>
    21ac:	92440000 	subls	r0, r4, #0
    21b0:	00d40000 	sbcseq	r0, r4, r0
    21b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    21b8:	0000033a 	andeq	r0, r0, sl, lsr r3
    21bc:	0100780c 	tsteq	r0, ip, lsl #16
    21c0:	00842ba5 	addeq	r2, r4, r5, lsr #23
    21c4:	91020000 	mrsls	r0, (UNDEF: 2)
    21c8:	66620c6c 	strbtvs	r0, [r2], -ip, ror #24
    21cc:	a5010072 	strge	r0, [r1, #-114]	; 0xffffff8e
    21d0:	00022934 	andeq	r2, r2, r4, lsr r9
    21d4:	68910200 	ldmvs	r1, {r9}
    21d8:	00186b15 	andseq	r6, r8, r5, lsl fp
    21dc:	3da50100 	stfccs	f0, [r5]
    21e0:	00000123 	andeq	r0, r0, r3, lsr #2
    21e4:	0e649102 	lgneqs	f1, f2
    21e8:	0000185d 	andeq	r1, r0, sp, asr r8
    21ec:	2306a701 	movwcs	sl, #26369	; 0x6701
    21f0:	02000001 	andeq	r0, r0, #1
    21f4:	17007491 			; <UNDEFINED> instruction: 0x17007491
    21f8:	00001890 	muleq	r0, r0, r8
    21fc:	eb068301 	bl	1a2e08 <__bss_end+0x1992f8>
    2200:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    2204:	4000008e 	andmi	r0, r0, lr, lsl #1
    2208:	01000004 	tsteq	r0, r4
    220c:	00039e9c 	muleq	r3, ip, lr
    2210:	00780c00 	rsbseq	r0, r8, r0, lsl #24
    2214:	37188301 	ldrcc	r8, [r8, -r1, lsl #6]
    2218:	02000000 	andeq	r0, r0, #0
    221c:	18156c91 	ldmdane	r5, {r0, r4, r7, sl, fp, sp, lr}
    2220:	01000017 	tsteq	r0, r7, lsl r0
    2224:	039e2983 	orrseq	r2, lr, #2146304	; 0x20c000
    2228:	91020000 	mrsls	r0, (UNDEF: 2)
    222c:	17271568 	strne	r1, [r7, -r8, ror #10]!
    2230:	83010000 	movwhi	r0, #4096	; 0x1000
    2234:	00039e41 	andeq	r9, r3, r1, asr #28
    2238:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    223c:	00177015 	andseq	r7, r7, r5, lsl r0
    2240:	4f830100 	svcmi	0x00830100
    2244:	000003a4 	andeq	r0, r0, r4, lsr #7
    2248:	0e609102 	lgneqs	f1, f2
    224c:	00001708 	andeq	r1, r0, r8, lsl #14
    2250:	370b9601 	strcc	r9, [fp, -r1, lsl #12]
    2254:	02000000 	andeq	r0, r0, #0
    2258:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    225c:	00008404 	andeq	r8, r0, r4, lsl #8
    2260:	23041800 	movwcs	r1, #18432	; 0x4800
    2264:	14000001 	strne	r0, [r0], #-1
    2268:	00001909 	andeq	r1, r0, r9, lsl #18
    226c:	89067601 	stmdbhi	r6, {r0, r9, sl, ip, sp, lr}
    2270:	40000017 	andmi	r0, r0, r7, lsl r0
    2274:	c400008d 	strgt	r0, [r0], #-141	; 0xffffff73
    2278:	01000000 	mrseq	r0, (UNDEF: 0)
    227c:	0003ff9c 	muleq	r3, ip, pc	; <UNPREDICTABLE>
    2280:	17c81500 	strbne	r1, [r8, r0, lsl #10]
    2284:	76010000 	strvc	r0, [r1], -r0
    2288:	00022913 	andeq	r2, r2, r3, lsl r9
    228c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2290:	0100690d 	tsteq	r0, sp, lsl #18
    2294:	01230978 			; <UNDEFINED> instruction: 0x01230978
    2298:	91020000 	mrsls	r0, (UNDEF: 2)
    229c:	656c0d74 	strbvs	r0, [ip, #-3444]!	; 0xfffff28c
    22a0:	7801006e 	stmdavc	r1, {r1, r2, r3, r5, r6}
    22a4:	0001230c 	andeq	r2, r1, ip, lsl #6
    22a8:	70910200 	addsvc	r0, r1, r0, lsl #4
    22ac:	0017aa0e 	andseq	sl, r7, lr, lsl #20
    22b0:	11780100 	cmnne	r8, r0, lsl #2
    22b4:	00000123 	andeq	r0, r0, r3, lsr #2
    22b8:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    22bc:	776f7019 			; <UNDEFINED> instruction: 0x776f7019
    22c0:	076d0100 	strbeq	r0, [sp, -r0, lsl #2]!
    22c4:	000017e2 	andeq	r1, r0, r2, ror #15
    22c8:	00000037 	andeq	r0, r0, r7, lsr r0
    22cc:	00008cd4 	ldrdeq	r8, [r0], -r4
    22d0:	0000006c 	andeq	r0, r0, ip, rrx
    22d4:	045c9c01 	ldrbeq	r9, [ip], #-3073	; 0xfffff3ff
    22d8:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    22dc:	176d0100 	strbne	r0, [sp, -r0, lsl #2]!
    22e0:	0000003e 	andeq	r0, r0, lr, lsr r0
    22e4:	0c6c9102 	stfeqp	f1, [ip], #-8
    22e8:	6d01006e 	stcvs	0, cr0, [r1, #-440]	; 0xfffffe48
    22ec:	00008b2d 	andeq	r8, r0, sp, lsr #22
    22f0:	68910200 	ldmvs	r1, {r9}
    22f4:	0100720d 	tsteq	r0, sp, lsl #4
    22f8:	00370b6f 	eorseq	r0, r7, pc, ror #22
    22fc:	91020000 	mrsls	r0, (UNDEF: 2)
    2300:	8cf00f74 	ldclhi	15, cr0, [r0], #464	; 0x1d0
    2304:	00380000 	eorseq	r0, r8, r0
    2308:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
    230c:	16700100 	ldrbtne	r0, [r0], -r0, lsl #2
    2310:	00000084 	andeq	r0, r0, r4, lsl #1
    2314:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2318:	18561700 	ldmdane	r6, {r8, r9, sl, ip}^
    231c:	64010000 	strvs	r0, [r1], #-0
    2320:	0016be06 	andseq	fp, r6, r6, lsl #28
    2324:	008c5400 	addeq	r5, ip, r0, lsl #8
    2328:	00008000 	andeq	r8, r0, r0
    232c:	d99c0100 	ldmible	ip, {r8}
    2330:	0c000004 	stceq	0, cr0, [r0], {4}
    2334:	00637273 	rsbeq	r7, r3, r3, ror r2
    2338:	d9196401 	ldmdble	r9, {r0, sl, sp, lr}
    233c:	02000004 	andeq	r0, r0, #4
    2340:	640c6491 	strvs	r6, [ip], #-1169	; 0xfffffb6f
    2344:	01007473 	tsteq	r0, r3, ror r4
    2348:	04e02464 	strbteq	r2, [r0], #1124	; 0x464
    234c:	91020000 	mrsls	r0, (UNDEF: 2)
    2350:	756e0c60 	strbvc	r0, [lr, #-3168]!	; 0xfffff3a0
    2354:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    2358:	0001232d 	andeq	r2, r1, sp, lsr #6
    235c:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2360:	00183f0e 	andseq	r3, r8, lr, lsl #30
    2364:	0e660100 	poweqs	f0, f6, f0
    2368:	0000011d 	andeq	r0, r0, sp, lsl r1
    236c:	0e709102 	expeqs	f1, f2
    2370:	00001807 	andeq	r1, r0, r7, lsl #16
    2374:	29086701 	stmdbcs	r8, {r0, r8, r9, sl, sp, lr}
    2378:	02000002 	andeq	r0, r0, #2
    237c:	7c0f6c91 	stcvc	12, cr6, [pc], {145}	; 0x91
    2380:	4800008c 	stmdami	r0, {r2, r3, r7}
    2384:	0d000000 	stceq	0, cr0, [r0, #-0]
    2388:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    238c:	0001230b 	andeq	r2, r1, fp, lsl #6
    2390:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2394:	04120000 	ldreq	r0, [r2], #-0
    2398:	000004df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    239c:	17041b1a 	smladne	r4, sl, fp, r1
    23a0:	00001850 	andeq	r1, r0, r0, asr r8
    23a4:	af065c01 	svcge	0x00065c01
    23a8:	ec000017 	stc	0, cr0, [r0], {23}
    23ac:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    23b0:	01000000 	mrseq	r0, (UNDEF: 0)
    23b4:	0005419c 	muleq	r5, ip, r1
    23b8:	18f41500 	ldmne	r4!, {r8, sl, ip}^
    23bc:	5c010000 	stcpl	0, cr0, [r1], {-0}
    23c0:	0004e012 	andeq	lr, r4, r2, lsl r0
    23c4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    23c8:	0018fb15 	andseq	pc, r8, r5, lsl fp	; <UNPREDICTABLE>
    23cc:	1e5c0100 	rdfnee	f0, f4, f0
    23d0:	00000123 	andeq	r0, r0, r3, lsr #2
    23d4:	0d689102 	stfeqp	f1, [r8, #-8]!
    23d8:	006d656d 	rsbeq	r6, sp, sp, ror #10
    23dc:	29085e01 	stmdbcs	r8, {r0, r9, sl, fp, ip, lr}
    23e0:	02000002 	andeq	r0, r0, #2
    23e4:	080f7091 	stmdaeq	pc, {r0, r4, r7, ip, sp, lr}	; <UNPREDICTABLE>
    23e8:	3c00008c 	stccc	0, cr0, [r0], {140}	; 0x8c
    23ec:	0d000000 	stceq	0, cr0, [r0, #-0]
    23f0:	60010069 	andvs	r0, r1, r9, rrx
    23f4:	0001230b 	andeq	r2, r1, fp, lsl #6
    23f8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    23fc:	020b0000 	andeq	r0, fp, #0
    2400:	01000019 	tsteq	r0, r9, lsl r0
    2404:	18a10552 	stmiane	r1!, {r1, r4, r6, r8, sl}
    2408:	01230000 			; <UNDEFINED> instruction: 0x01230000
    240c:	8b980000 	blhi	fe602414 <__bss_end+0xfe5f8904>
    2410:	00540000 	subseq	r0, r4, r0
    2414:	9c010000 	stcls	0, cr0, [r1], {-0}
    2418:	0000057a 	andeq	r0, r0, sl, ror r5
    241c:	0100730c 	tsteq	r0, ip, lsl #6
    2420:	011d1852 	tsteq	sp, r2, asr r8
    2424:	91020000 	mrsls	r0, (UNDEF: 2)
    2428:	00690d6c 	rsbeq	r0, r9, ip, ror #26
    242c:	23065401 	movwcs	r5, #25601	; 0x6401
    2430:	02000001 	andeq	r0, r0, #1
    2434:	0b007491 	bleq	1f680 <__bss_end+0x15b70>
    2438:	00001863 	andeq	r1, r0, r3, ror #16
    243c:	ae054201 	cdpge	2, 0, cr4, cr5, cr1, {0}
    2440:	23000018 	movwcs	r0, #24
    2444:	ec000001 	stc	0, cr0, [r0], {1}
    2448:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    244c:	01000000 	mrseq	r0, (UNDEF: 0)
    2450:	0005e09c 	muleq	r5, ip, r0
    2454:	31730c00 	cmncc	r3, r0, lsl #24
    2458:	19420100 	stmdbne	r2, {r8}^
    245c:	0000011d 	andeq	r0, r0, sp, lsl r1
    2460:	0c6c9102 	stfeqp	f1, [ip], #-8
    2464:	01003273 	tsteq	r0, r3, ror r2
    2468:	011d2942 	tsteq	sp, r2, asr #18
    246c:	91020000 	mrsls	r0, (UNDEF: 2)
    2470:	756e0c68 	strbvc	r0, [lr, #-3176]!	; 0xfffff398
    2474:	4201006d 	andmi	r0, r1, #109	; 0x6d
    2478:	00012331 	andeq	r2, r1, r1, lsr r3
    247c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2480:	0031750d 	eorseq	r7, r1, sp, lsl #10
    2484:	e0104401 	ands	r4, r0, r1, lsl #8
    2488:	02000005 	andeq	r0, r0, #5
    248c:	750d7791 	strvc	r7, [sp, #-1937]	; 0xfffff86f
    2490:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    2494:	0005e014 	andeq	lr, r5, r4, lsl r0
    2498:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    249c:	08010300 	stmdaeq	r1, {r8, r9}
    24a0:	00000d6f 	andeq	r0, r0, pc, ror #26
    24a4:	0017bb0b 	andseq	fp, r7, fp, lsl #22
    24a8:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    24ac:	000018c0 	andeq	r1, r0, r0, asr #17
    24b0:	00000229 	andeq	r0, r0, r9, lsr #4
    24b4:	00008a2c 	andeq	r8, r0, ip, lsr #20
    24b8:	000000c0 	andeq	r0, r0, r0, asr #1
    24bc:	06409c01 	strbeq	r9, [r0], -r1, lsl #24
    24c0:	84150000 	ldrhi	r0, [r5], #-0
    24c4:	01000017 	tsteq	r0, r7, lsl r0
    24c8:	02291536 	eoreq	r1, r9, #226492416	; 0xd800000
    24cc:	91020000 	mrsls	r0, (UNDEF: 2)
    24d0:	72730c6c 	rsbsvc	r0, r3, #108, 24	; 0x6c00
    24d4:	36010063 	strcc	r0, [r1], -r3, rrx
    24d8:	00011d27 	andeq	r1, r1, r7, lsr #26
    24dc:	68910200 	ldmvs	r1, {r9}
    24e0:	6d756e0c 	ldclvs	14, cr6, [r5, #-48]!	; 0xffffffd0
    24e4:	30360100 	eorscc	r0, r6, r0, lsl #2
    24e8:	00000123 	andeq	r0, r0, r3, lsr #2
    24ec:	0d649102 	stfeqp	f1, [r4, #-8]!
    24f0:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    24f4:	00012306 	andeq	r2, r1, r6, lsl #6
    24f8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    24fc:	173b0b00 	ldrne	r0, [fp, -r0, lsl #22]!
    2500:	24010000 	strcs	r0, [r1], #-0
    2504:	00187205 	andseq	r7, r8, r5, lsl #4
    2508:	00012300 	andeq	r2, r1, r0, lsl #6
    250c:	00899000 	addeq	r9, r9, r0
    2510:	00009c00 	andeq	r9, r0, r0, lsl #24
    2514:	7d9c0100 	ldfvcs	f0, [ip]
    2518:	15000006 	strne	r0, [r0, #-6]
    251c:	0000179f 	muleq	r0, pc, r7	; <UNPREDICTABLE>
    2520:	1d162401 	cfldrsne	mvf2, [r6, #-4]
    2524:	02000001 	andeq	r0, r0, #1
    2528:	7d0e6c91 	stcvc	12, cr6, [lr, #-580]	; 0xfffffdbc
    252c:	01000018 	tsteq	r0, r8, lsl r0
    2530:	01230626 			; <UNDEFINED> instruction: 0x01230626
    2534:	91020000 	mrsls	r0, (UNDEF: 2)
    2538:	c31c0074 	tstgt	ip, #116	; 0x74
    253c:	01000017 	tsteq	r0, r7, lsl r0
    2540:	172f0608 	strne	r0, [pc, -r8, lsl #12]!
    2544:	881c0000 	ldmdahi	ip, {}	; <UNPREDICTABLE>
    2548:	01740000 	cmneq	r4, r0
    254c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2550:	00179f15 	andseq	r9, r7, r5, lsl pc
    2554:	18080100 	stmdane	r8, {r8}
    2558:	00000084 	andeq	r0, r0, r4, lsl #1
    255c:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    2560:	0000187d 	andeq	r1, r0, sp, ror r8
    2564:	29250801 	stmdbcs	r5!, {r0, fp}
    2568:	02000002 	andeq	r0, r0, #2
    256c:	a5156091 	ldrge	r6, [r5, #-145]	; 0xffffff6f
    2570:	01000017 	tsteq	r0, r7, lsl r0
    2574:	00843a08 	addeq	r3, r4, r8, lsl #20
    2578:	91020000 	mrsls	r0, (UNDEF: 2)
    257c:	00690d5c 	rsbeq	r0, r9, ip, asr sp
    2580:	23060a01 	movwcs	r0, #27137	; 0x6a01
    2584:	02000001 	andeq	r0, r0, #1
    2588:	e80f7491 	stmda	pc, {r0, r4, r7, sl, ip, sp, lr}	; <UNPREDICTABLE>
    258c:	98000088 	stmdals	r0, {r3, r7}
    2590:	0d000000 	stceq	0, cr0, [r0, #-0]
    2594:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    2598:	0001230b 	andeq	r2, r1, fp, lsl #6
    259c:	70910200 	addsvc	r0, r1, r0, lsl #4
    25a0:	0089100f 	addeq	r1, r9, pc
    25a4:	00006000 	andeq	r6, r0, r0
    25a8:	00630d00 	rsbeq	r0, r3, r0, lsl #26
    25ac:	90081e01 	andls	r1, r8, r1, lsl #28
    25b0:	02000000 	andeq	r0, r0, #0
    25b4:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    25b8:	00220000 	eoreq	r0, r2, r0
    25bc:	00020000 	andeq	r0, r2, r0
    25c0:	000008d5 	ldrdeq	r0, [r0], -r5
    25c4:	0d940104 	ldfeqs	f0, [r4, #16]
    25c8:	97f80000 	ldrbls	r0, [r8, r0]!
    25cc:	9a040000 	bls	1025d4 <__bss_end+0xf8ac4>
    25d0:	19100000 	ldmdbne	r0, {}	; <UNPREDICTABLE>
    25d4:	19400000 	stmdbne	r0, {}^	; <UNPREDICTABLE>
    25d8:	00630000 	rsbeq	r0, r3, r0
    25dc:	80010000 	andhi	r0, r1, r0
    25e0:	00000022 	andeq	r0, r0, r2, lsr #32
    25e4:	08e90002 	stmiaeq	r9!, {r1}^
    25e8:	01040000 	mrseq	r0, (UNDEF: 4)
    25ec:	00000e11 	andeq	r0, r0, r1, lsl lr
    25f0:	00009a04 	andeq	r9, r0, r4, lsl #20
    25f4:	00009a08 	andeq	r9, r0, r8, lsl #20
    25f8:	00001910 	andeq	r1, r0, r0, lsl r9
    25fc:	00001940 	andeq	r1, r0, r0, asr #18
    2600:	00000063 	andeq	r0, r0, r3, rrx
    2604:	09328001 	ldmdbeq	r2!, {r0, pc}
    2608:	00040000 	andeq	r0, r4, r0
    260c:	000008fd 	strdeq	r0, [r0], -sp
    2610:	1d0e0104 	stfnes	f0, [lr, #-16]
    2614:	650c0000 	strvs	r0, [ip, #-0]
    2618:	4000001c 	andmi	r0, r0, ip, lsl r0
    261c:	71000019 	tstvc	r0, r9, lsl r0
    2620:	0200000e 	andeq	r0, r0, #14
    2624:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2628:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    262c:	0004e107 	andeq	lr, r4, r7, lsl #2
    2630:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    2634:	0000031f 	andeq	r0, r0, pc, lsl r3
    2638:	f6040803 			; <UNDEFINED> instruction: 0xf6040803
    263c:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    2640:	00001cc0 	andeq	r1, r0, r0, asr #25
    2644:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    2648:	04000000 	streq	r0, [r0], #-0
    264c:	00002118 	andeq	r2, r0, r8, lsl r1
    2650:	51152f01 	tstpl	r5, r1, lsl #30
    2654:	05000000 	streq	r0, [r0, #-0]
    2658:	00005704 	andeq	r5, r0, r4, lsl #14
    265c:	00390600 	eorseq	r0, r9, r0, lsl #12
    2660:	00660000 	rsbeq	r0, r6, r0
    2664:	66070000 	strvs	r0, [r7], -r0
    2668:	00000000 	andeq	r0, r0, r0
    266c:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    2670:	04080000 	streq	r0, [r8], #-0
    2674:	0000284a 	andeq	r2, r0, sl, asr #16
    2678:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    267c:	05000000 	streq	r0, [r0, #-0]
    2680:	00007f04 	andeq	r7, r0, r4, lsl #30
    2684:	001d0600 	andseq	r0, sp, r0, lsl #12
    2688:	00930000 	addseq	r0, r3, r0
    268c:	66070000 	strvs	r0, [r7], -r0
    2690:	07000000 	streq	r0, [r0, -r0]
    2694:	00000066 	andeq	r0, r0, r6, rrx
    2698:	08010300 	stmdaeq	r1, {r8, r9}
    269c:	00000d6f 	andeq	r0, r0, pc, ror #26
    26a0:	00235009 	eoreq	r5, r3, r9
    26a4:	12bb0100 	adcsne	r0, fp, #0, 2
    26a8:	00000045 	andeq	r0, r0, r5, asr #32
    26ac:	00287809 	eoreq	r7, r8, r9, lsl #16
    26b0:	10be0100 	adcsne	r0, lr, r0, lsl #2
    26b4:	0000006d 	andeq	r0, r0, sp, rrx
    26b8:	71060103 	tstvc	r6, r3, lsl #2
    26bc:	0a00000d 	beq	26f8 <shift+0x26f8>
    26c0:	00002038 	andeq	r2, r0, r8, lsr r0
    26c4:	00930107 	addseq	r0, r3, r7, lsl #2
    26c8:	17020000 	strne	r0, [r2, -r0]
    26cc:	0001e606 	andeq	lr, r1, r6, lsl #12
    26d0:	1b1e0b00 	blne	7852d8 <__bss_end+0x77b7c8>
    26d4:	0b000000 	bleq	26dc <shift+0x26dc>
    26d8:	00001f55 	andeq	r1, r0, r5, asr pc
    26dc:	241b0b01 	ldrcs	r0, [fp], #-2817	; 0xfffff4ff
    26e0:	0b020000 	bleq	826e8 <__bss_end+0x78bd8>
    26e4:	0000278c 	andeq	r2, r0, ip, lsl #15
    26e8:	23bf0b03 			; <UNDEFINED> instruction: 0x23bf0b03
    26ec:	0b040000 	bleq	1026f4 <__bss_end+0xf8be4>
    26f0:	00002695 	muleq	r0, r5, r6
    26f4:	25f90b05 	ldrbcs	r0, [r9, #2821]!	; 0xb05
    26f8:	0b060000 	bleq	182700 <__bss_end+0x178bf0>
    26fc:	00001b3f 	andeq	r1, r0, pc, lsr fp
    2700:	26aa0b07 	strtcs	r0, [sl], r7, lsl #22
    2704:	0b080000 	bleq	20270c <__bss_end+0x1f8bfc>
    2708:	000026b8 			; <UNDEFINED> instruction: 0x000026b8
    270c:	277f0b09 	ldrbcs	r0, [pc, -r9, lsl #22]!
    2710:	0b0a0000 	bleq	282718 <__bss_end+0x278c08>
    2714:	00002316 	andeq	r2, r0, r6, lsl r3
    2718:	1d010b0b 	vstrne	d0, [r1, #-44]	; 0xffffffd4
    271c:	0b0c0000 	bleq	302724 <__bss_end+0x2f8c14>
    2720:	00001dde 	ldrdeq	r1, [r0], -lr
    2724:	207c0b0d 	rsbscs	r0, ip, sp, lsl #22
    2728:	0b0e0000 	bleq	382730 <__bss_end+0x378c20>
    272c:	00002092 	muleq	r0, r2, r0
    2730:	1f8f0b0f 	svcne	0x008f0b0f
    2734:	0b100000 	bleq	40273c <__bss_end+0x3f8c2c>
    2738:	000023a3 	andeq	r2, r0, r3, lsr #7
    273c:	1ffb0b11 	svcne	0x00fb0b11
    2740:	0b120000 	bleq	482748 <__bss_end+0x478c38>
    2744:	00002a11 	andeq	r2, r0, r1, lsl sl
    2748:	1ba80b13 	blne	fea0539c <__bss_end+0xfe9fb88c>
    274c:	0b140000 	bleq	502754 <__bss_end+0x4f8c44>
    2750:	0000201f 	andeq	r2, r0, pc, lsl r0
    2754:	1ae50b15 	bne	ff9453b0 <__bss_end+0xff93b8a0>
    2758:	0b160000 	bleq	582760 <__bss_end+0x578c50>
    275c:	000027af 	andeq	r2, r0, pc, lsr #15
    2760:	28d10b17 	ldmcs	r1, {r0, r1, r2, r4, r8, r9, fp}^
    2764:	0b180000 	bleq	60276c <__bss_end+0x5f8c5c>
    2768:	00002044 	andeq	r2, r0, r4, asr #32
    276c:	248d0b19 	strcs	r0, [sp], #2841	; 0xb19
    2770:	0b1a0000 	bleq	682778 <__bss_end+0x678c68>
    2774:	000027bd 			; <UNDEFINED> instruction: 0x000027bd
    2778:	1a140b1b 	bne	5053ec <__bss_end+0x4fb8dc>
    277c:	0b1c0000 	bleq	702784 <__bss_end+0x6f8c74>
    2780:	000027cb 	andeq	r2, r0, fp, asr #15
    2784:	27d90b1d 	bfics	r0, sp, #22, #4
    2788:	0b1e0000 	bleq	782790 <__bss_end+0x778c80>
    278c:	000019c2 	andeq	r1, r0, r2, asr #19
    2790:	28030b1f 	stmdacs	r3, {r0, r1, r2, r3, r4, r8, r9, fp}
    2794:	0b200000 	bleq	80279c <__bss_end+0x7f8c8c>
    2798:	0000253a 	andeq	r2, r0, sl, lsr r5
    279c:	23750b21 	cmncs	r5, #33792	; 0x8400
    27a0:	0b220000 	bleq	8827a8 <__bss_end+0x878c98>
    27a4:	000027a2 	andeq	r2, r0, r2, lsr #15
    27a8:	22790b23 	rsbscs	r0, r9, #35840	; 0x8c00
    27ac:	0b240000 	bleq	9027b4 <__bss_end+0x8f8ca4>
    27b0:	0000217b 	andeq	r2, r0, fp, ror r1
    27b4:	1e950b25 	vfnmsne.f64	d0, d5, d21
    27b8:	0b260000 	bleq	9827c0 <__bss_end+0x978cb0>
    27bc:	00002199 	muleq	r0, r9, r1
    27c0:	1f310b27 	svcne	0x00310b27
    27c4:	0b280000 	bleq	a027cc <__bss_end+0x9f8cbc>
    27c8:	000021a9 	andeq	r2, r0, r9, lsr #3
    27cc:	21b90b29 			; <UNDEFINED> instruction: 0x21b90b29
    27d0:	0b2a0000 	bleq	a827d8 <__bss_end+0xa78cc8>
    27d4:	000022fc 	strdeq	r2, [r0], -ip
    27d8:	21220b2b 			; <UNDEFINED> instruction: 0x21220b2b
    27dc:	0b2c0000 	bleq	b027e4 <__bss_end+0xaf8cd4>
    27e0:	00002547 	andeq	r2, r0, r7, asr #10
    27e4:	1ed60b2d 	vfnmsne.f64	d16, d6, d29
    27e8:	002e0000 	eoreq	r0, lr, r0
    27ec:	0020b40a 	eoreq	fp, r0, sl, lsl #8
    27f0:	93010700 	movwls	r0, #5888	; 0x1700
    27f4:	03000000 	movweq	r0, #0
    27f8:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    27fc:	000b0000 	andeq	r0, fp, r0
    2800:	0000001e 	andeq	r0, r0, lr, lsl r0
    2804:	001a520b 	andseq	r5, sl, fp, lsl #4
    2808:	bf0b0100 	svclt	0x000b0100
    280c:	02000029 	andeq	r0, r0, #41	; 0x29
    2810:	0028520b 	eoreq	r5, r8, fp, lsl #4
    2814:	200b0300 	andcs	r0, fp, r0, lsl #6
    2818:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    281c:	001b0a0b 	andseq	r0, fp, fp, lsl #20
    2820:	b20b0500 	andlt	r0, fp, #0, 10
    2824:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    2828:	001e100b 	andseq	r1, lr, fp
    282c:	e60b0700 	str	r0, [fp], -r0, lsl #14
    2830:	08000026 	stmdaeq	r0, {r1, r2, r5}
    2834:	0028370b 	eoreq	r3, r8, fp, lsl #14
    2838:	1d0b0900 	vstrne.16	s0, [fp, #-0]	; <UNPREDICTABLE>
    283c:	0a000026 	beq	28dc <shift+0x28dc>
    2840:	001b5d0b 	andseq	r5, fp, fp, lsl #26
    2844:	530b0b00 	movwpl	r0, #47872	; 0xbb00
    2848:	0c00001e 	stceq	0, cr0, [r0], {30}
    284c:	001ad30b 	andseq	sp, sl, fp, lsl #6
    2850:	f40b0d00 			; <UNDEFINED> instruction: 0xf40b0d00
    2854:	0e000029 	cdpeq	0, 0, cr0, cr0, cr9, {1}
    2858:	0022e90b 	eoreq	lr, r2, fp, lsl #18
    285c:	c60b0f00 	strgt	r0, [fp], -r0, lsl #30
    2860:	1000001f 	andne	r0, r0, pc, lsl r0
    2864:	0023260b 	eoreq	r2, r3, fp, lsl #12
    2868:	130b1100 	movwne	r1, #45312	; 0xb100
    286c:	12000029 	andne	r0, r0, #41	; 0x29
    2870:	001c200b 	andseq	r2, ip, fp
    2874:	d90b1300 	stmdble	fp, {r8, r9, ip}
    2878:	1400001f 	strne	r0, [r0], #-31	; 0xffffffe1
    287c:	00223c0b 	eoreq	r3, r2, fp, lsl #24
    2880:	eb0b1500 	bl	2c7c88 <__bss_end+0x2be178>
    2884:	1600001d 			; <UNDEFINED> instruction: 0x1600001d
    2888:	0022880b 	eoreq	r8, r2, fp, lsl #16
    288c:	9e0b1700 	cdpls	7, 0, cr1, cr11, cr0, {0}
    2890:	18000020 	stmdane	r0, {r5}
    2894:	001b280b 	andseq	r2, fp, fp, lsl #16
    2898:	ba0b1900 	blt	2c8ca0 <__bss_end+0x2bf190>
    289c:	1a000028 	bne	2944 <shift+0x2944>
    28a0:	0022080b 	eoreq	r0, r2, fp, lsl #16
    28a4:	b00b1b00 	andlt	r1, fp, r0, lsl #22
    28a8:	1c00001f 	stcne	0, cr0, [r0], {31}
    28ac:	0019fd0b 	andseq	pc, r9, fp, lsl #26
    28b0:	530b1d00 	movwpl	r1, #48384	; 0xbd00
    28b4:	1e000021 	cdpne	0, 0, cr0, cr0, cr1, {1}
    28b8:	00213f0b 	eoreq	r3, r1, fp, lsl #30
    28bc:	da0b1f00 	ble	2ca4c4 <__bss_end+0x2c09b4>
    28c0:	20000025 	andcs	r0, r0, r5, lsr #32
    28c4:	0026650b 	eoreq	r6, r6, fp, lsl #10
    28c8:	990b2100 	stmdbls	fp, {r8, sp}
    28cc:	22000028 	andcs	r0, r0, #40	; 0x28
    28d0:	001ee30b 	andseq	lr, lr, fp, lsl #6
    28d4:	3d0b2300 	stccc	3, cr2, [fp, #-0]
    28d8:	24000024 	strcs	r0, [r0], #-36	; 0xffffffdc
    28dc:	0026320b 	eoreq	r3, r6, fp, lsl #4
    28e0:	560b2500 	strpl	r2, [fp], -r0, lsl #10
    28e4:	26000025 	strcs	r0, [r0], -r5, lsr #32
    28e8:	00256a0b 	eoreq	r6, r5, fp, lsl #20
    28ec:	7e0b2700 	cdpvc	7, 0, cr2, cr11, cr0, {0}
    28f0:	28000025 	stmdacs	r0, {r0, r2, r5}
    28f4:	001cab0b 	andseq	sl, ip, fp, lsl #22
    28f8:	0b0b2900 	bleq	2ccd00 <__bss_end+0x2c31f0>
    28fc:	2a00001c 	bcs	2974 <shift+0x2974>
    2900:	001c330b 	andseq	r3, ip, fp, lsl #6
    2904:	2f0b2b00 	svccs	0x000b2b00
    2908:	2c000027 	stccs	0, cr0, [r0], {39}	; 0x27
    290c:	001c880b 	andseq	r8, ip, fp, lsl #16
    2910:	430b2d00 	movwmi	r2, #48384	; 0xbd00
    2914:	2e000027 	cdpcs	0, 0, cr0, cr0, cr7, {1}
    2918:	0027570b 	eoreq	r5, r7, fp, lsl #14
    291c:	6b0b2f00 	blvs	2ce524 <__bss_end+0x2c4a14>
    2920:	30000027 	andcc	r0, r0, r7, lsr #32
    2924:	001e650b 	andseq	r6, lr, fp, lsl #10
    2928:	3f0b3100 	svccc	0x000b3100
    292c:	3200001e 	andcc	r0, r0, #30
    2930:	0021670b 	eoreq	r6, r1, fp, lsl #14
    2934:	390b3300 	stmdbcc	fp, {r8, r9, ip, sp}
    2938:	34000023 	strcc	r0, [r0], #-35	; 0xffffffdd
    293c:	0029480b 	eoreq	r4, r9, fp, lsl #16
    2940:	a50b3500 	strge	r3, [fp, #-1280]	; 0xfffffb00
    2944:	36000019 			; <UNDEFINED> instruction: 0x36000019
    2948:	001f650b 	andseq	r6, pc, fp, lsl #10
    294c:	7a0b3700 	bvc	2d0554 <__bss_end+0x2c6a44>
    2950:	3800001f 	stmdacc	r0, {r0, r1, r2, r3, r4}
    2954:	0021c90b 	eoreq	ip, r1, fp, lsl #18
    2958:	f30b3900 	vmls.i8	d3, d11, d0
    295c:	3a000021 	bcc	29e8 <shift+0x29e8>
    2960:	0029710b 	eoreq	r7, r9, fp, lsl #2
    2964:	280b3b00 	stmdacs	fp, {r8, r9, fp, ip, sp}
    2968:	3c000024 	stccc	0, cr0, [r0], {36}	; 0x24
    296c:	001f080b 	andseq	r0, pc, fp, lsl #16
    2970:	640b3d00 	strvs	r3, [fp], #-3328	; 0xfffff300
    2974:	3e00001a 	mcrcc	0, 0, r0, cr0, cr10, {0}
    2978:	001a220b 	andseq	r2, sl, fp, lsl #4
    297c:	850b3f00 	strhi	r3, [fp, #-3840]	; 0xfffff100
    2980:	40000023 	andmi	r0, r0, r3, lsr #32
    2984:	0024a90b 	eoreq	sl, r4, fp, lsl #18
    2988:	bc0b4100 	stflts	f4, [fp], {-0}
    298c:	42000025 	andmi	r0, r0, #37	; 0x25
    2990:	0021de0b 	eoreq	sp, r1, fp, lsl #28
    2994:	aa0b4300 	bge	2d359c <__bss_end+0x2c9a8c>
    2998:	44000029 	strmi	r0, [r0], #-41	; 0xffffffd7
    299c:	0024530b 	eoreq	r5, r4, fp, lsl #6
    29a0:	4f0b4500 	svcmi	0x000b4500
    29a4:	4600001c 			; <UNDEFINED> instruction: 0x4600001c
    29a8:	0022b90b 	eoreq	fp, r2, fp, lsl #18
    29ac:	ec0b4700 	stc	7, cr4, [fp], {-0}
    29b0:	48000020 	stmdami	r0, {r5}
    29b4:	0019e10b 	andseq	lr, r9, fp, lsl #2
    29b8:	f50b4900 			; <UNDEFINED> instruction: 0xf50b4900
    29bc:	4a00001a 	bmi	2a2c <shift+0x2a2c>
    29c0:	001f1c0b 	andseq	r1, pc, fp, lsl #24
    29c4:	1a0b4b00 	bne	2d55cc <__bss_end+0x2cbabc>
    29c8:	4c000022 	stcmi	0, cr0, [r0], {34}	; 0x22
    29cc:	07020300 	streq	r0, [r2, -r0, lsl #6]
    29d0:	000009e2 	andeq	r0, r0, r2, ror #19
    29d4:	0003e40c 	andeq	lr, r3, ip, lsl #8
    29d8:	0003d900 	andeq	sp, r3, r0, lsl #18
    29dc:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    29e0:	000003ce 	andeq	r0, r0, lr, asr #7
    29e4:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    29e8:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    29ec:	03000003 	movweq	r0, #3
    29f0:	0d780801 	ldcleq	8, cr0, [r8, #-4]!
    29f4:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    29f8:	0f000003 	svceq	0x00000003
    29fc:	00001b99 	muleq	r0, r9, fp
    2a00:	1a014c04 	bne	55a18 <__bss_end+0x4bf08>
    2a04:	000003d9 	ldrdeq	r0, [r0], -r9
    2a08:	001fa00f 	andseq	sl, pc, pc
    2a0c:	01820400 	orreq	r0, r2, r0, lsl #8
    2a10:	0003d91a 	andeq	sp, r3, sl, lsl r9
    2a14:	03e90c00 	mvneq	r0, #0, 24
    2a18:	041a0000 	ldreq	r0, [sl], #-0
    2a1c:	000d0000 	andeq	r0, sp, r0
    2a20:	00218b09 	eoreq	r8, r1, r9, lsl #22
    2a24:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    2a28:	0000040f 	andeq	r0, r0, pc, lsl #8
    2a2c:	00281309 	eoreq	r1, r8, r9, lsl #6
    2a30:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    2a34:	000001e6 	andeq	r0, r0, r6, ror #3
    2a38:	001e790a 	andseq	r7, lr, sl, lsl #18
    2a3c:	93010700 	movwls	r0, #5888	; 0x1700
    2a40:	05000000 	streq	r0, [r0, #-0]
    2a44:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    2a48:	f60b0000 			; <UNDEFINED> instruction: 0xf60b0000
    2a4c:	00000019 	andeq	r0, r0, r9, lsl r0
    2a50:	00208b0b 	eoreq	r8, r0, fp, lsl #22
    2a54:	250b0100 	strcs	r0, [fp, #-256]	; 0xffffff00
    2a58:	02000029 	andeq	r0, r0, #41	; 0x29
    2a5c:	0028e80b 	eoreq	lr, r8, fp, lsl #16
    2a60:	e20b0300 	and	r0, fp, #0, 6
    2a64:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2a68:	0026a30b 	eoreq	sl, r6, fp, lsl #6
    2a6c:	dc0b0500 	cfstr32le	mvfx0, [fp], {-0}
    2a70:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2a74:	001bbe0b 	andseq	fp, fp, fp, lsl #28
    2a78:	d70b0700 	strle	r0, [fp, -r0, lsl #14]
    2a7c:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    2a80:	00229e0b 	eoreq	r9, r2, fp, lsl #28
    2a84:	e30b0900 	movw	r0, #47360	; 0xb900
    2a88:	0a00001b 	beq	2afc <shift+0x2afc>
    2a8c:	0022a50b 	eoreq	sl, r2, fp, lsl #10
    2a90:	480b0b00 	stmdami	fp, {r8, r9, fp}
    2a94:	0c00001c 	stceq	0, cr0, [r0], {28}
    2a98:	001bd50b 	andseq	sp, fp, fp, lsl #10
    2a9c:	fa0b0d00 	blx	2c5ea4 <__bss_end+0x2bc394>
    2aa0:	0e000026 	cdpeq	0, 0, cr0, cr0, cr6, {1}
    2aa4:	0024c70b 	eoreq	ip, r4, fp, lsl #14
    2aa8:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    2aac:	000025f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    2ab0:	32013f05 	andcc	r3, r1, #5, 30
    2ab4:	09000004 	stmdbeq	r0, {r2}
    2ab8:	00002686 	andeq	r2, r0, r6, lsl #13
    2abc:	a50f4105 	strge	r4, [pc, #-261]	; 29bf <shift+0x29bf>
    2ac0:	09000004 	stmdbeq	r0, {r2}
    2ac4:	0000270e 	andeq	r2, r0, lr, lsl #14
    2ac8:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    2acc:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2ad0:	00001b7d 	andeq	r1, r0, sp, ror fp
    2ad4:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    2ad8:	10000000 	andne	r0, r0, r0
    2adc:	000027e7 	andeq	r2, r0, r7, ror #15
    2ae0:	00271f09 	eoreq	r1, r7, r9, lsl #30
    2ae4:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    2ae8:	000004e6 	andeq	r0, r0, r6, ror #9
    2aec:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    2af0:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2af4:	00002055 	andeq	r2, r0, r5, asr r0
    2af8:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    2afc:	05000004 	streq	r0, [r0, #-4]
    2b00:	0004ec04 	andeq	lr, r4, r4, lsl #24
    2b04:	26081200 	strcs	r1, [r8], -r0, lsl #4
    2b08:	cf090000 	svcgt	0x00090000
    2b0c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2b10:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    2b14:	04050000 	streq	r0, [r5], #-0
    2b18:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2b1c:	001cf413 	andseq	pc, ip, r3, lsl r4	; <UNPREDICTABLE>
    2b20:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    2b24:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    2b28:	94140000 	ldrls	r0, [r4], #-0
    2b2c:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2b30:	de0f0169 	adfleez	f0, f7, #1.0
    2b34:	00000003 	andeq	r0, r0, r3
    2b38:	001cd814 	andseq	sp, ip, r4, lsl r8
    2b3c:	016a0500 	cmneq	sl, r0, lsl #10
    2b40:	00054614 	andeq	r4, r5, r4, lsl r6
    2b44:	0e000400 	cfcpyseq	mvf0, mvf0
    2b48:	00000516 	andeq	r0, r0, r6, lsl r5
    2b4c:	0000b90c 	andeq	fp, r0, ip, lsl #18
    2b50:	00055600 	andeq	r5, r5, r0, lsl #12
    2b54:	00241500 	eoreq	r1, r4, r0, lsl #10
    2b58:	002d0000 	eoreq	r0, sp, r0
    2b5c:	0005410c 	andeq	r4, r5, ip, lsl #2
    2b60:	00056100 	andeq	r6, r5, r0, lsl #2
    2b64:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2b68:	00000556 	andeq	r0, r0, r6, asr r5
    2b6c:	0020c30f 	eoreq	ip, r0, pc, lsl #6
    2b70:	016b0500 	cmneq	fp, r0, lsl #10
    2b74:	00056103 	andeq	r6, r5, r3, lsl #2
    2b78:	23090f00 	movwcs	r0, #40704	; 0x9f00
    2b7c:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    2b80:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2b84:	46160000 	ldrmi	r0, [r6], -r0
    2b88:	07000026 	streq	r0, [r0, -r6, lsr #32]
    2b8c:	00009301 	andeq	r9, r0, r1, lsl #6
    2b90:	01810500 	orreq	r0, r1, r0, lsl #10
    2b94:	00062a06 	andeq	r2, r6, r6, lsl #20
    2b98:	1a8b0b00 	bne	fe2c57a0 <__bss_end+0xfe2bbc90>
    2b9c:	0b000000 	bleq	2ba4 <shift+0x2ba4>
    2ba0:	00001a97 	muleq	r0, r7, sl
    2ba4:	1aa30b02 	bne	fe8c57b4 <__bss_end+0xfe8bbca4>
    2ba8:	0b030000 	bleq	c2bb0 <__bss_end+0xb90a0>
    2bac:	00001ea5 	andeq	r1, r0, r5, lsr #29
    2bb0:	1aaf0b03 	bne	febc57c4 <__bss_end+0xfebbbcb4>
    2bb4:	0b040000 	bleq	102bbc <__bss_end+0xf90ac>
    2bb8:	00001fee 	andeq	r1, r0, lr, ror #31
    2bbc:	20d40b04 	sbcscs	r0, r4, r4, lsl #22
    2bc0:	0b050000 	bleq	142bc8 <__bss_end+0x1390b8>
    2bc4:	0000202a 	andeq	r2, r0, sl, lsr #32
    2bc8:	1b6e0b05 	blne	1b857e4 <__bss_end+0x1b7bcd4>
    2bcc:	0b050000 	bleq	142bd4 <__bss_end+0x1390c4>
    2bd0:	00001abb 			; <UNDEFINED> instruction: 0x00001abb
    2bd4:	22520b06 	subscs	r0, r2, #6144	; 0x1800
    2bd8:	0b060000 	bleq	182be0 <__bss_end+0x1790d0>
    2bdc:	00001cca 	andeq	r1, r0, sl, asr #25
    2be0:	225f0b06 	subscs	r0, pc, #6144	; 0x1800
    2be4:	0b060000 	bleq	182bec <__bss_end+0x1790dc>
    2be8:	000026c6 	andeq	r2, r0, r6, asr #13
    2bec:	226c0b06 	rsbcs	r0, ip, #6144	; 0x1800
    2bf0:	0b060000 	bleq	182bf8 <__bss_end+0x1790e8>
    2bf4:	000022ac 	andeq	r2, r0, ip, lsr #5
    2bf8:	1ac70b06 	bne	ff1c5818 <__bss_end+0xff1bbd08>
    2bfc:	0b070000 	bleq	1c2c04 <__bss_end+0x1b90f4>
    2c00:	000023b2 			; <UNDEFINED> instruction: 0x000023b2
    2c04:	23ff0b07 	mvnscs	r0, #7168	; 0x1c00
    2c08:	0b070000 	bleq	1c2c10 <__bss_end+0x1b9100>
    2c0c:	00002701 	andeq	r2, r0, r1, lsl #14
    2c10:	1c9d0b07 	fldmiaxne	sp, {d0-d2}	;@ Deprecated
    2c14:	0b070000 	bleq	1c2c1c <__bss_end+0x1b910c>
    2c18:	00002480 	andeq	r2, r0, r0, lsl #9
    2c1c:	1a400b08 	bne	1005844 <__bss_end+0xffbd34>
    2c20:	0b080000 	bleq	202c28 <__bss_end+0x1f9118>
    2c24:	000026d4 	ldrdeq	r2, [r0], -r4
    2c28:	249c0b08 	ldrcs	r0, [ip], #2824	; 0xb08
    2c2c:	00080000 	andeq	r0, r8, r0
    2c30:	00293a0f 	eoreq	r3, r9, pc, lsl #20
    2c34:	019f0500 	orrseq	r0, pc, r0, lsl #10
    2c38:	0005801f 	andeq	r8, r5, pc, lsl r0
    2c3c:	24ce0f00 	strbcs	r0, [lr], #3840	; 0xf00
    2c40:	a2050000 	andge	r0, r5, #0
    2c44:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c48:	e10f0000 	mrs	r0, CPSR
    2c4c:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2c50:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    2c54:	0f000000 	svceq	0x00000000
    2c58:	00002a06 	andeq	r2, r0, r6, lsl #20
    2c5c:	0c01a805 	stceq	8, cr10, [r1], {5}
    2c60:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c64:	001b8d0f 	andseq	r8, fp, pc, lsl #26
    2c68:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    2c6c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c70:	24d80f00 	ldrbcs	r0, [r8], #3840	; 0xf00
    2c74:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2c78:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c7c:	e90f0000 	stmdb	pc, {}	; <UNPREDICTABLE>
    2c80:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2c84:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    2c88:	0f000000 	svceq	0x00000000
    2c8c:	000023f4 	strdeq	r2, [r0], -r4
    2c90:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    2c94:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c98:	0024e20f 	eoreq	lr, r4, pc, lsl #4
    2c9c:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    2ca0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2ca4:	222e0f00 	eorcs	r0, lr, #0, 30
    2ca8:	ba050000 	blt	142cb0 <__bss_end+0x1391a0>
    2cac:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2cb0:	650f0000 	strvs	r0, [pc, #-0]	; 2cb8 <shift+0x2cb8>
    2cb4:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2cb8:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    2cbc:	0f000000 	svceq	0x00000000
    2cc0:	000024ec 	andeq	r2, r0, ip, ror #9
    2cc4:	0c01c005 	stceq	0, cr12, [r1], {5}
    2cc8:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ccc:	002a290f 	eoreq	r2, sl, pc, lsl #18
    2cd0:	01c30500 	biceq	r0, r3, r0, lsl #10
    2cd4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cd8:	28ef0f00 	stmiacs	pc!, {r8, r9, sl, fp}^	; <UNPREDICTABLE>
    2cdc:	c6050000 	strgt	r0, [r5], -r0
    2ce0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2ce4:	fb0f0000 	blx	3c2cee <__bss_end+0x3b91de>
    2ce8:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2cec:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    2cf0:	0f000000 	svceq	0x00000000
    2cf4:	00002907 	andeq	r2, r0, r7, lsl #18
    2cf8:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2cfc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d00:	00292c0f 	eoreq	r2, r9, pc, lsl #24
    2d04:	01d00500 	bicseq	r0, r0, r0, lsl #10
    2d08:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d0c:	2a1c0f00 	bcs	706914 <__bss_end+0x6fce04>
    2d10:	d3050000 	movwle	r0, #20480	; 0x5000
    2d14:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d18:	ea0f0000 	b	3c2d20 <__bss_end+0x3b9210>
    2d1c:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2d20:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    2d24:	0f000000 	svceq	0x00000000
    2d28:	000019d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    2d2c:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2d30:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d34:	001ec50f 	andseq	ip, lr, pc, lsl #10
    2d38:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2d3c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d40:	1bc50f00 	blne	ff146948 <__bss_end+0xff13ce38>
    2d44:	df050000 	svcle	0x00050000
    2d48:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d4c:	020f0000 	andeq	r0, pc, #0
    2d50:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2d54:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    2d58:	0f000000 	svceq	0x00000000
    2d5c:	0000210a 	andeq	r2, r0, sl, lsl #2
    2d60:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    2d64:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d68:	0023620f 	eoreq	r6, r3, pc, lsl #4
    2d6c:	01e80500 	mvneq	r0, r0, lsl #10
    2d70:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d74:	281c0f00 	ldmdacs	ip, {r8, r9, sl, fp}
    2d78:	ef050000 	svc	0x00050000
    2d7c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2d80:	d40f0000 	strle	r0, [pc], #-0	; 2d88 <shift+0x2d88>
    2d84:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2d88:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    2d8c:	0f000000 	svceq	0x00000000
    2d90:	000029e4 	andeq	r2, r0, r4, ror #19
    2d94:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    2d98:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d9c:	001ce10f 	andseq	lr, ip, pc, lsl #2
    2da0:	01f80500 	mvnseq	r0, r0, lsl #10
    2da4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2da8:	28630f00 	stmdacs	r3!, {r8, r9, sl, fp}^
    2dac:	fb050000 	blx	142db6 <__bss_end+0x1392a6>
    2db0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2db4:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    2db8:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2dbc:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    2dc0:	0f000000 	svceq	0x00000000
    2dc4:	00001f3e 	andeq	r1, r0, lr, lsr pc
    2dc8:	0c020205 	sfmeq	f0, 4, [r2], {5}
    2dcc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2dd0:	0026580f 	eoreq	r5, r6, pc, lsl #16
    2dd4:	020a0500 	andeq	r0, sl, #0, 10
    2dd8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2ddc:	1e310f00 	cdpne	15, 3, cr0, cr1, cr0, {0}
    2de0:	0d050000 	stceq	0, cr0, [r5, #-0]
    2de4:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2de8:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2dec:	ef000000 	svc	0x00000000
    2df0:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    2df4:	200a0f00 	andcs	r0, sl, r0, lsl #30
    2df8:	fb050000 	blx	142e02 <__bss_end+0x1392f2>
    2dfc:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    2e00:	e60c0000 	str	r0, [ip], -r0
    2e04:	0c000004 	stceq	0, cr0, [r0], {4}
    2e08:	15000008 	strne	r0, [r0, #-8]
    2e0c:	00000024 	andeq	r0, r0, r4, lsr #32
    2e10:	250f000d 	strcs	r0, [pc, #-13]	; 2e0b <shift+0x2e0b>
    2e14:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2e18:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    2e1c:	16000007 	strne	r0, [r0], -r7
    2e20:	000020cc 	andeq	r2, r0, ip, asr #1
    2e24:	00930107 	addseq	r0, r3, r7, lsl #2
    2e28:	8b050000 	blhi	142e30 <__bss_end+0x139320>
    2e2c:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2e30:	870b0000 	strhi	r0, [fp, -r0]
    2e34:	0000001e 	andeq	r0, r0, lr, lsl r0
    2e38:	0022d70b 	eoreq	sp, r2, fp, lsl #14
    2e3c:	760b0100 	strvc	r0, [fp], -r0, lsl #2
    2e40:	0200001a 	andeq	r0, r0, #26
    2e44:	0029960b 	eoreq	r9, r9, fp, lsl #12
    2e48:	9f0b0300 	svcls	0x000b0300
    2e4c:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    2e50:	0025920b 	eoreq	r9, r5, fp, lsl #4
    2e54:	4d0b0500 	cfstr32mi	mvfx0, [fp, #-0]
    2e58:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2e5c:	29860f00 	stmibcs	r6, {r8, r9, sl, fp}
    2e60:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    2e64:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    2e68:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    2e6c:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2e70:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    2e74:	0f000000 	svceq	0x00000000
    2e78:	00002512 	andeq	r2, r0, r2, lsl r5
    2e7c:	0c07ae05 	stceq	14, cr10, [r7], {5}
    2e80:	0000001d 	andeq	r0, r0, sp, lsl r0
    2e84:	0027fb04 	eoreq	pc, r7, r4, lsl #22
    2e88:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    2e8c:	00000093 	muleq	r0, r3, r0
    2e90:	00087e0e 	andeq	r7, r8, lr, lsl #28
    2e94:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    2e98:	00000dec 	andeq	r0, r0, ip, ror #27
    2e9c:	d7070803 	strle	r0, [r7, -r3, lsl #16]
    2ea0:	03000004 	movweq	r0, #4
    2ea4:	1c050404 	cfstrsne	mvf0, [r5], {4}
    2ea8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2eac:	001bfd03 	andseq	pc, fp, r3, lsl #26
    2eb0:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2eb4:	000024fb 	strdeq	r2, [r0], -fp
    2eb8:	ad031003 	stcge	0, cr1, [r3, #-12]
    2ebc:	0c000025 	stceq	0, cr0, [r0], {37}	; 0x25
    2ec0:	0000088a 	andeq	r0, r0, sl, lsl #17
    2ec4:	000008c9 	andeq	r0, r0, r9, asr #17
    2ec8:	00002415 	andeq	r2, r0, r5, lsl r4
    2ecc:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    2ed0:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    2ed4:	00240c0f 	eoreq	r0, r4, pc, lsl #24
    2ed8:	01fc0600 	mvnseq	r0, r0, lsl #12
    2edc:	0008c916 	andeq	ip, r8, r6, lsl r9
    2ee0:	1bb40f00 	blne	fed06ae8 <__bss_end+0xfecfcfd8>
    2ee4:	02060000 	andeq	r0, r6, #0
    2ee8:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    2eec:	2e040000 	cdpcs	0, 0, cr0, cr4, cr0, {0}
    2ef0:	07000028 	streq	r0, [r0, -r8, lsr #32]
    2ef4:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    2ef8:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    2efc:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    2f00:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    2f04:	03570900 	cmpeq	r7, #0, 18
    2f08:	2f070000 	svccs	0x00070000
    2f0c:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2f10:	020c0900 	andeq	r0, ip, #0, 18
    2f14:	30070000 	andcc	r0, r7, r0
    2f18:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2f1c:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2f20:	33080000 	movwcc	r0, #32768	; 0x8000
    2f24:	03050a09 	movweq	r0, #23049	; 0x5a09
    2f28:	00009afd 	strdeq	r9, [r0], -sp
    2f2c:	00090b17 	andeq	r0, r9, r7, lsl fp
    2f30:	09340800 	ldmdbeq	r4!, {fp}
    2f34:	fd03050a 	stc2	5, cr0, [r3, #-40]	; 0xffffffd8
    2f38:	0000009a 	muleq	r0, sl, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377104>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb920c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb922c>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9244>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x28c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79d84>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39268>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7198>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b65e4>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9e48>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4e00>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6610>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6684>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377200>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9300>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79e3c>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39320>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9338>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79e70>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4eac>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3772f0>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f72b8>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb93d8>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	03001605 	movweq	r1, #1541	; 0x605
 21c:	3b0b3a0e 	blcc	2cea5c <__bss_end+0x2c4f4c>
 220:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 224:	06000013 			; <UNDEFINED> instruction: 0x06000013
 228:	0b0b0024 	bleq	2c02c0 <__bss_end+0x2b67b0>
 22c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b9f40>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb9420>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f7344>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7cd0c>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb9448>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b93b8>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79f9c>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe39480>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb4bc>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4fdc>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79fd4>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe394b8>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x377440>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe7a004>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe394e8>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a1b8>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x377474>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b6874>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe7a054>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe39538>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb9550>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x3774e0>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a0a0>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe39584>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb5c0>
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
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c50ec>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb95c4>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c5128>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377570>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7a130>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe39614>
 434:	01111349 	tsteq	r1, r9, asr #6
 438:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 43c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 440:	29000013 	stmdbcs	r0, {r0, r1, r4}
 444:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 448:	0b3b0b3a 	bleq	ec3138 <__bss_end+0xeb9628>
 44c:	13490b39 	movtne	r0, #39737	; 0x9b39
 450:	00001802 	andeq	r1, r0, r2, lsl #16
 454:	0300342a 	movweq	r3, #1066	; 0x42a
 458:	3b0b3a0e 	blcc	2cec98 <__bss_end+0x2c5188>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	010b2b00 	tsteq	fp, r0, lsl #22
 468:	06120111 			; <UNDEFINED> instruction: 0x06120111
 46c:	342c0000 	strtcc	r0, [ip], #-0
 470:	3a080300 	bcc	201078 <__bss_end+0x1f7568>
 474:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 478:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 47c:	00000018 	andeq	r0, r0, r8, lsl r0
 480:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 484:	030b130e 	movweq	r1, #45838	; 0xb30e
 488:	110e1b0e 	tstne	lr, lr, lsl #22
 48c:	10061201 	andne	r1, r6, r1, lsl #4
 490:	02000017 	andeq	r0, r0, #23
 494:	0b0b0024 	bleq	2c052c <__bss_end+0x2b6a1c>
 498:	0e030b3e 	vmoveq.16	d3[0], r0
 49c:	26030000 	strcs	r0, [r3], -r0
 4a0:	00134900 	andseq	r4, r3, r0, lsl #18
 4a4:	00160400 	andseq	r0, r6, r0, lsl #8
 4a8:	0b3a0e03 	bleq	e83cbc <__bss_end+0xe7a1ac>
 4ac:	0b390b3b 	bleq	e431a0 <__bss_end+0xe39690>
 4b0:	00001349 	andeq	r1, r0, r9, asr #6
 4b4:	0b002405 	bleq	94d0 <_Z4ftoafPcj+0x10c>
 4b8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 4bc:	06000008 	streq	r0, [r0], -r8
 4c0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 4c4:	0b3b0b3a 	bleq	ec31b4 <__bss_end+0xeb96a4>
 4c8:	13490b39 	movtne	r0, #39737	; 0x9b39
 4cc:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 4d0:	13070000 	movwne	r0, #28672	; 0x7000
 4d4:	0b0e0301 	bleq	3810e0 <__bss_end+0x3775d0>
 4d8:	3b0b3a0b 	blcc	2ced0c <__bss_end+0x2c51fc>
 4dc:	010b390b 	tsteq	fp, fp, lsl #18
 4e0:	08000013 	stmdaeq	r0, {r0, r1, r4}
 4e4:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 4e8:	0b3b0b3a 	bleq	ec31d8 <__bss_end+0xeb96c8>
 4ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 4f0:	00000b38 	andeq	r0, r0, r8, lsr fp
 4f4:	03010409 	movweq	r0, #5129	; 0x1409
 4f8:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 4fc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 500:	3b0b3a13 	blcc	2ced54 <__bss_end+0x2c5244>
 504:	010b390b 	tsteq	fp, fp, lsl #18
 508:	0a000013 	beq	55c <shift+0x55c>
 50c:	08030028 	stmdaeq	r3, {r3, r5}
 510:	00000b1c 	andeq	r0, r0, ip, lsl fp
 514:	0300280b 	movweq	r2, #2059	; 0x80b
 518:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 51c:	00020c00 	andeq	r0, r2, r0, lsl #24
 520:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 524:	020d0000 	andeq	r0, sp, #0
 528:	0b0e0301 	bleq	381134 <__bss_end+0x377624>
 52c:	3b0b3a0b 	blcc	2ced60 <__bss_end+0x2c5250>
 530:	010b390b 	tsteq	fp, fp, lsl #18
 534:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 538:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 53c:	0b3b0b3a 	bleq	ec322c <__bss_end+0xeb971c>
 540:	13490b39 	movtne	r0, #39737	; 0x9b39
 544:	00000b38 	andeq	r0, r0, r8, lsr fp
 548:	3f012e0f 	svccc	0x00012e0f
 54c:	3a0e0319 	bcc	3811b8 <__bss_end+0x3776a8>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 558:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 55c:	10000013 	andne	r0, r0, r3, lsl r0
 560:	13490005 	movtne	r0, #36869	; 0x9005
 564:	00001934 	andeq	r1, r0, r4, lsr r9
 568:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 56c:	12000013 	andne	r0, r0, #19
 570:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 574:	0b3b0b3a 	bleq	ec3264 <__bss_end+0xeb9754>
 578:	13490b39 	movtne	r0, #39737	; 0x9b39
 57c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 580:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 584:	03193f01 	tsteq	r9, #1, 30
 588:	3b0b3a0e 	blcc	2cedc8 <__bss_end+0x2c52b8>
 58c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 590:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 594:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 598:	00130113 	andseq	r0, r3, r3, lsl r1
 59c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 5a0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeb9784>
 5a8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5ac:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5b0:	13011364 	movwne	r1, #4964	; 0x1364
 5b4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 5b8:	03193f01 	tsteq	r9, #1, 30
 5bc:	3b0b3a0e 	blcc	2cedfc <__bss_end+0x2c52ec>
 5c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5c4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 5c8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 5cc:	16000013 			; <UNDEFINED> instruction: 0x16000013
 5d0:	13490101 	movtne	r0, #37121	; 0x9101
 5d4:	00001301 	andeq	r1, r0, r1, lsl #6
 5d8:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 5dc:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5e0:	000f1800 	andeq	r1, pc, r0, lsl #16
 5e4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5e8:	21190000 	tstcs	r9, r0
 5ec:	1a000000 	bne	5f4 <shift+0x5f4>
 5f0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5f4:	0b3b0b3a 	bleq	ec32e4 <__bss_end+0xeb97d4>
 5f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5fc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 600:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 604:	03193f01 	tsteq	r9, #1, 30
 608:	3b0b3a0e 	blcc	2cee48 <__bss_end+0x2c5338>
 60c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 610:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 614:	00130113 	andseq	r0, r3, r3, lsl r1
 618:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 61c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 620:	0b3b0b3a 	bleq	ec3310 <__bss_end+0xeb9800>
 624:	0e6e0b39 	vmoveq.8	d14[5], r0
 628:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 62c:	13011364 	movwne	r1, #4964	; 0x1364
 630:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 634:	3a0e0300 	bcc	38123c <__bss_end+0x37772c>
 638:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 63c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 640:	000b320b 	andeq	r3, fp, fp, lsl #4
 644:	01151e00 	tsteq	r5, r0, lsl #28
 648:	13641349 	cmnne	r4, #603979777	; 0x24000001
 64c:	00001301 	andeq	r1, r0, r1, lsl #6
 650:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 654:	00134913 	andseq	r4, r3, r3, lsl r9
 658:	00102000 	andseq	r2, r0, r0
 65c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 660:	0f210000 	svceq	0x00210000
 664:	000b0b00 	andeq	r0, fp, r0, lsl #22
 668:	00342200 	eorseq	r2, r4, r0, lsl #4
 66c:	0b3a0e03 	bleq	e83e80 <__bss_end+0xe7a370>
 670:	0b390b3b 	bleq	e43364 <__bss_end+0xe39854>
 674:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 678:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 67c:	03193f01 	tsteq	r9, #1, 30
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c53b0>
 684:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 688:	1113490e 	tstne	r3, lr, lsl #18
 68c:	40061201 	andmi	r1, r6, r1, lsl #4
 690:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 694:	00001301 	andeq	r1, r0, r1, lsl #6
 698:	03000524 	movweq	r0, #1316	; 0x524
 69c:	3b0b3a0e 	blcc	2ceedc <__bss_end+0x2c53cc>
 6a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6a4:	00180213 	andseq	r0, r8, r3, lsl r2
 6a8:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 6ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb9890>
 6b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 6b8:	01111349 	tsteq	r1, r9, asr #6
 6bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6c0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 6c4:	26000013 			; <UNDEFINED> instruction: 0x26000013
 6c8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb98ac>
 6d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6d4:	00001802 	andeq	r1, r0, r2, lsl #16
 6d8:	3f012e27 	svccc	0x00012e27
 6dc:	3a0e0319 	bcc	381348 <__bss_end+0x377838>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	110e6e0b 	tstne	lr, fp, lsl #28
 6e8:	40061201 	andmi	r1, r6, r1, lsl #4
 6ec:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6f0:	00001301 	andeq	r1, r0, r1, lsl #6
 6f4:	3f002e28 	svccc	0x00002e28
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x377854>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	110e6e0b 	tstne	lr, fp, lsl #28
 704:	40061201 	andmi	r1, r6, r1, lsl #4
 708:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 70c:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 710:	03193f01 	tsteq	r9, #1, 30
 714:	3b0b3a0e 	blcc	2cef54 <__bss_end+0x2c5444>
 718:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 71c:	1113490e 	tstne	r3, lr, lsl #18
 720:	40061201 	andmi	r1, r6, r1, lsl #4
 724:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 728:	01000000 	mrseq	r0, (UNDEF: 0)
 72c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 730:	0e030b13 	vmoveq.32	d3[0], r0
 734:	01110e1b 	tsteq	r1, fp, lsl lr
 738:	17100612 			; <UNDEFINED> instruction: 0x17100612
 73c:	34020000 	strcc	r0, [r2], #-0
 740:	3a0e0300 	bcc	381348 <__bss_end+0x377838>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 74c:	00180219 	andseq	r0, r8, r9, lsl r2
 750:	00240300 	eoreq	r0, r4, r0, lsl #6
 754:	0b3e0b0b 	bleq	f83388 <__bss_end+0xf79878>
 758:	00000e03 	andeq	r0, r0, r3, lsl #28
 75c:	49002604 	stmdbmi	r0, {r2, r9, sl, sp}
 760:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 764:	13010139 	movwne	r0, #4409	; 0x1139
 768:	34060000 	strcc	r0, [r6], #-0
 76c:	3a0e0300 	bcc	381374 <__bss_end+0x377864>
 770:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 774:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 778:	000a1c19 	andeq	r1, sl, r9, lsl ip
 77c:	003a0700 	eorseq	r0, sl, r0, lsl #14
 780:	0b3b0b3a 	bleq	ec3470 <__bss_end+0xeb9960>
 784:	13180b39 	tstne	r8, #58368	; 0xe400
 788:	01080000 	mrseq	r0, (UNDEF: 8)
 78c:	01134901 	tsteq	r3, r1, lsl #18
 790:	09000013 	stmdbeq	r0, {r0, r1, r4}
 794:	13490021 	movtne	r0, #36897	; 0x9021
 798:	00000b2f 	andeq	r0, r0, pc, lsr #22
 79c:	4700340a 	strmi	r3, [r0, -sl, lsl #8]
 7a0:	0b000013 	bleq	7f4 <shift+0x7f4>
 7a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7a8:	0b3a0e03 	bleq	e83fbc <__bss_end+0xe7a4ac>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe39990>
 7b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 7b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7bc:	00130119 	andseq	r0, r3, r9, lsl r1
 7c0:	00050c00 	andeq	r0, r5, r0, lsl #24
 7c4:	0b3a0803 	bleq	e827d8 <__bss_end+0xe78cc8>
 7c8:	0b390b3b 	bleq	e434bc <__bss_end+0xe399ac>
 7cc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7d0:	340d0000 	strcc	r0, [sp], #-0
 7d4:	3a080300 	bcc	2013dc <__bss_end+0x1f78cc>
 7d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7dc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7e0:	0e000018 	mcreq	0, 0, r0, cr0, cr8, {0}
 7e4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7e8:	0b3b0b3a 	bleq	ec34d8 <__bss_end+0xeb99c8>
 7ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 7f0:	00001802 	andeq	r1, r0, r2, lsl #16
 7f4:	11010b0f 	tstne	r1, pc, lsl #22
 7f8:	00061201 	andeq	r1, r6, r1, lsl #4
 7fc:	00341000 	eorseq	r1, r4, r0
 800:	0b3a0e03 	bleq	e84014 <__bss_end+0xe7a504>
 804:	0b39053b 	bleq	e41cf8 <__bss_end+0xe381e8>
 808:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 80c:	34110000 	ldrcc	r0, [r1], #-0
 810:	3a080300 	bcc	201418 <__bss_end+0x1f7908>
 814:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 818:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 81c:	12000018 	andne	r0, r0, #24
 820:	0b0b000f 	bleq	2c0864 <__bss_end+0x2b6d54>
 824:	00001349 	andeq	r1, r0, r9, asr #6
 828:	0b002413 	bleq	987c <__udivsi3+0x84>
 82c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 830:	14000008 	strne	r0, [r0], #-8
 834:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 838:	0b3a0e03 	bleq	e8404c <__bss_end+0xe7a53c>
 83c:	0b390b3b 	bleq	e43530 <__bss_end+0xe39a20>
 840:	01110e6e 	tsteq	r1, lr, ror #28
 844:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 848:	01194296 			; <UNDEFINED> instruction: 0x01194296
 84c:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 850:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 854:	0b3b0b3a 	bleq	ec3544 <__bss_end+0xeb9a34>
 858:	13490b39 	movtne	r0, #39737	; 0x9b39
 85c:	00001802 	andeq	r1, r0, r2, lsl #16
 860:	11010b16 	tstne	r1, r6, lsl fp
 864:	01061201 	tsteq	r6, r1, lsl #4
 868:	17000013 	smladne	r0, r3, r0, r0
 86c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 870:	0b3a0e03 	bleq	e84084 <__bss_end+0xe7a574>
 874:	0b390b3b 	bleq	e43568 <__bss_end+0xe39a58>
 878:	01110e6e 	tsteq	r1, lr, ror #28
 87c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 880:	01194297 			; <UNDEFINED> instruction: 0x01194297
 884:	18000013 	stmdane	r0, {r0, r1, r4}
 888:	0b0b0010 	bleq	2c08d0 <__bss_end+0x2b6dc0>
 88c:	00001349 	andeq	r1, r0, r9, asr #6
 890:	3f012e19 	svccc	0x00012e19
 894:	3a080319 	bcc	201500 <__bss_end+0x1f79f0>
 898:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 89c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 8a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 8a4:	97184006 	ldrls	r4, [r8, -r6]
 8a8:	13011942 	movwne	r1, #6466	; 0x1942
 8ac:	261a0000 	ldrcs	r0, [sl], -r0
 8b0:	1b000000 	blne	8b8 <shift+0x8b8>
 8b4:	0b0b000f 	bleq	2c08f8 <__bss_end+0x2b6de8>
 8b8:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 8bc:	03193f01 	tsteq	r9, #1, 30
 8c0:	3b0b3a0e 	blcc	2cf100 <__bss_end+0x2c55f0>
 8c4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 8c8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 8cc:	96184006 	ldrls	r4, [r8], -r6
 8d0:	00001942 	andeq	r1, r0, r2, asr #18
 8d4:	00110100 	andseq	r0, r1, r0, lsl #2
 8d8:	01110610 	tsteq	r1, r0, lsl r6
 8dc:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 8e0:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 8e4:	00000513 	andeq	r0, r0, r3, lsl r5
 8e8:	00110100 	andseq	r0, r1, r0, lsl #2
 8ec:	01110610 	tsteq	r1, r0, lsl r6
 8f0:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 8f4:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 8f8:	00000513 	andeq	r0, r0, r3, lsl r5
 8fc:	01110100 	tsteq	r1, r0, lsl #2
 900:	0b130e25 	bleq	4c419c <__bss_end+0x4ba68c>
 904:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 908:	00001710 	andeq	r1, r0, r0, lsl r7
 90c:	0b002402 	bleq	991c <__udivsi3+0x124>
 910:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 914:	03000008 	movweq	r0, #8
 918:	0b0b0024 	bleq	2c09b0 <__bss_end+0x2b6ea0>
 91c:	0e030b3e 	vmoveq.16	d3[0], r0
 920:	16040000 	strne	r0, [r4], -r0
 924:	3a0e0300 	bcc	38152c <__bss_end+0x377a1c>
 928:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 92c:	0013490b 	andseq	r4, r3, fp, lsl #18
 930:	000f0500 	andeq	r0, pc, r0, lsl #10
 934:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 938:	15060000 	strne	r0, [r6, #-0]
 93c:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
 940:	00130113 	andseq	r0, r3, r3, lsl r1
 944:	00050700 	andeq	r0, r5, r0, lsl #14
 948:	00001349 	andeq	r1, r0, r9, asr #6
 94c:	00002608 	andeq	r2, r0, r8, lsl #12
 950:	00340900 	eorseq	r0, r4, r0, lsl #18
 954:	0b3a0e03 	bleq	e84168 <__bss_end+0xe7a658>
 958:	0b390b3b 	bleq	e4364c <__bss_end+0xe39b3c>
 95c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 960:	0000193c 	andeq	r1, r0, ip, lsr r9
 964:	0301040a 	movweq	r0, #5130	; 0x140a
 968:	0b0b3e0e 	bleq	2d01a8 <__bss_end+0x2c6698>
 96c:	3a13490b 	bcc	4d2da0 <__bss_end+0x4c9290>
 970:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 974:	0013010b 	andseq	r0, r3, fp, lsl #2
 978:	00280b00 	eoreq	r0, r8, r0, lsl #22
 97c:	0b1c0e03 	bleq	704190 <__bss_end+0x6fa680>
 980:	010c0000 	mrseq	r0, (UNDEF: 12)
 984:	01134901 	tsteq	r3, r1, lsl #18
 988:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 98c:	00000021 	andeq	r0, r0, r1, lsr #32
 990:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
 994:	0f000013 	svceq	0x00000013
 998:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 99c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 9a0:	13490b39 	movtne	r0, #39737	; 0x9b39
 9a4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 9a8:	13100000 	tstne	r0, #0
 9ac:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 9b0:	11000019 	tstne	r0, r9, lsl r0
 9b4:	19270015 	stmdbne	r7!, {r0, r2, r4}
 9b8:	17120000 	ldrne	r0, [r2, -r0]
 9bc:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 9c0:	13000019 	movwne	r0, #25
 9c4:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 9c8:	0b3a0b0b 	bleq	e835fc <__bss_end+0xe79aec>
 9cc:	0b39053b 	bleq	e41ec0 <__bss_end+0xe383b0>
 9d0:	00001301 	andeq	r1, r0, r1, lsl #6
 9d4:	03000d14 	movweq	r0, #3348	; 0xd14
 9d8:	3b0b3a0e 	blcc	2cf218 <__bss_end+0x2c5708>
 9dc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9e0:	000b3813 	andeq	r3, fp, r3, lsl r8
 9e4:	00211500 	eoreq	r1, r1, r0, lsl #10
 9e8:	0b2f1349 	bleq	bc5714 <__bss_end+0xbbbc04>
 9ec:	04160000 	ldreq	r0, [r6], #-0
 9f0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 9f4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 9f8:	3b0b3a13 	blcc	2cf24c <__bss_end+0x2c573c>
 9fc:	010b3905 	tsteq	fp, r5, lsl #18
 a00:	17000013 	smladne	r0, r3, r0, r0
 a04:	13470034 	movtne	r0, #28724	; 0x7034
 a08:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a0c:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 a10:	Address 0x0000000000000a10 is out of bounds.


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
  74:	00000194 	muleq	r0, r4, r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	115d0002 	cmpne	sp, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083c0 	andeq	r8, r0, r0, asr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1ebd0002 	cdpne	0, 11, cr0, cr13, cr2, {0}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	0000881c 	andeq	r8, r0, ip, lsl r8
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	25ba0002 	ldrcs	r0, [sl, #2]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	000097f8 	strdeq	r9, [r0], -r8
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	25e00002 	strbcs	r0, [r0, #2]!
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009a04 	andeq	r9, r0, r4, lsl #20
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	26060002 	strcs	r0, [r6], -r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff643c>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff61e1>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff61e3>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4ef8>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff6331>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be868>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfe14>
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
     494:	6600634b 	strvs	r6, [r0], -fp, asr #6
     498:	00747361 	rsbseq	r7, r4, r1, ror #6
     49c:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     4a0:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     4a4:	6165645f 	cmnvs	r5, pc, asr r4
     4a8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     4ac:	5a5f0065 	bpl	17c0648 <__bss_end+0x17b6b38>
     4b0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4b4:	4f495047 	svcmi	0x00495047
     4b8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4bc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4c0:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4c4:	706e495f 	rsbvc	r4, lr, pc, asr r9
     4c8:	6a457475 	bvs	115d6a4 <__bss_end+0x1153b94>
     4cc:	43534200 	cmpmi	r3, #0, 4
     4d0:	61425f32 	cmpvs	r2, r2, lsr pc
     4d4:	6c006573 	cfstr32vs	mvfx6, [r0], {115}	; 0x73
     4d8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     4dc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     4e0:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
     4e4:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     4e8:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
     4ec:	506d0074 	rsbpl	r0, sp, r4, ror r0
     4f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4f4:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     4f8:	5f747369 	svcpl	0x00747369
     4fc:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     500:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     504:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     508:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     50c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     510:	5f006e6f 	svcpl	0x00006e6f
     514:	314b4e5a 	cmpcc	fp, sl, asr lr
     518:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     51c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     520:	614d5f73 	hvcvs	54771	; 0xd5f3
     524:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     528:	47393172 			; <UNDEFINED> instruction: 0x47393172
     52c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     530:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     534:	505f746e 	subspl	r7, pc, lr, ror #8
     538:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     53c:	76457373 			; <UNDEFINED> instruction: 0x76457373
     540:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     544:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     548:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     54c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     550:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     554:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     558:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     55c:	6f72505f 	svcvs	0x0072505f
     560:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     564:	5f79425f 	svcpl	0x0079425f
     568:	00444950 	subeq	r4, r4, r0, asr r9
     56c:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     570:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     574:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     578:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     57c:	6f746365 	svcvs	0x00746365
     580:	4e007972 			; <UNDEFINED> instruction: 0x4e007972
     584:	5f495753 	svcpl	0x00495753
     588:	636f7250 	cmnvs	pc, #80, 4
     58c:	5f737365 	svcpl	0x00737365
     590:	76726553 			; <UNDEFINED> instruction: 0x76726553
     594:	00656369 	rsbeq	r6, r5, r9, ror #6
     598:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
     59c:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     5a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5a4:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
     5a8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     5ac:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     5b0:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     5b4:	76726573 			; <UNDEFINED> instruction: 0x76726573
     5b8:	6f697461 	svcvs	0x00697461
     5bc:	525f736e 	subspl	r7, pc, #-1207959551	; 0xb8000001
     5c0:	00646165 	rsbeq	r6, r4, r5, ror #2
     5c4:	69615754 	stmdbvs	r1!, {r2, r4, r6, r8, r9, sl, ip, lr}^
     5c8:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     5cc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     5d0:	72430065 	subvc	r0, r3, #101	; 0x65
     5d4:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     5d8:	6f72505f 	svcvs	0x0072505f
     5dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5e0:	50476d00 	subpl	r6, r7, r0, lsl #26
     5e4:	70004f49 	andvc	r4, r0, r9, asr #30
     5e8:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     5ec:	614d0074 	hvcvs	53252	; 0xd004
     5f0:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     5f4:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     5f8:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     5fc:	00687467 	rsbeq	r7, r8, r7, ror #8
     600:	5f585541 	svcpl	0x00585541
     604:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     608:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     60c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     610:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     614:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     618:	006f666e 	rsbeq	r6, pc, lr, ror #12
     61c:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     620:	6b636f6c 	blvs	18dc3d8 <__bss_end+0x18d28c8>
     624:	6100745f 	tstvs	r0, pc, asr r4
     628:	6e656373 	mcrvs	3, 3, r6, cr5, cr3, {3}
     62c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     630:	61654400 	cmnvs	r5, r0, lsl #8
     634:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     638:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     63c:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     640:	00646567 	rsbeq	r6, r4, r7, ror #10
     644:	6f725043 	svcvs	0x00725043
     648:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     64c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     650:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     654:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     658:	46433131 			; <UNDEFINED> instruction: 0x46433131
     65c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     660:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     664:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     668:	5a5f0076 	bpl	17c0848 <__bss_end+0x17b6d38>
     66c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     670:	636f7250 	cmnvs	pc, #80, 4
     674:	5f737365 	svcpl	0x00737365
     678:	616e614d 	cmnvs	lr, sp, asr #2
     67c:	31726567 	cmncc	r2, r7, ror #10
     680:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     684:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     688:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     68c:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     690:	456f666e 	strbmi	r6, [pc, #-1646]!	; 2a <shift+0x2a>
     694:	474e3032 	smlaldxmi	r3, lr, r2, r0
     698:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     69c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6a0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     6a4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     6a8:	76506570 			; <UNDEFINED> instruction: 0x76506570
     6ac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6b0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     6b4:	5f4f4950 	svcpl	0x004f4950
     6b8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     6bc:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     6c0:	656c4330 	strbvs	r4, [ip, #-816]!	; 0xfffffcd0
     6c4:	445f7261 	ldrbmi	r7, [pc], #-609	; 6cc <shift+0x6cc>
     6c8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     6cc:	5f646574 	svcpl	0x00646574
     6d0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     6d4:	006a4574 	rsbeq	r4, sl, r4, ror r5
     6d8:	314e5a5f 	cmpcc	lr, pc, asr sl
     6dc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6e4:	614d5f73 	hvcvs	54771	; 0xd5f3
     6e8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6ec:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     6f0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6f4:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     6f8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     6fc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     700:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     704:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     708:	5f495753 	svcpl	0x00495753
     70c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     710:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     714:	535f6d65 	cmppl	pc, #6464	; 0x1940
     718:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     71c:	6a6a6563 	bvs	1a99cb0 <__bss_end+0x1a901a0>
     720:	3131526a 	teqcc	r1, sl, ror #4
     724:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     728:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     72c:	00746c75 	rsbseq	r6, r4, r5, ror ip
     730:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     734:	5f676e69 	svcpl	0x00676e69
     738:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     73c:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     740:	5f64656e 	svcpl	0x0064656e
     744:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     748:	616d0073 	smcvs	53251	; 0xd003
     74c:	4e006e69 	cdpmi	14, 0, cr6, cr0, cr9, {3}
     750:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     754:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     758:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     75c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     760:	5f4f4950 	svcpl	0x004f4950
     764:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     768:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     76c:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     770:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     774:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     778:	445f746e 	ldrbmi	r7, [pc], #-1134	; 780 <shift+0x780>
     77c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     780:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     784:	50474e30 	subpl	r4, r7, r0, lsr lr
     788:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     78c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     790:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     794:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     798:	43540065 	cmpmi	r4, #101	; 0x65
     79c:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     7a0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     7a4:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     7a8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     7ac:	00656e69 	rsbeq	r6, r5, r9, ror #28
     7b0:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     7b4:	5a5f0030 	bpl	17c087c <__bss_end+0x17b6d6c>
     7b8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7bc:	636f7250 	cmnvs	pc, #80, 4
     7c0:	5f737365 	svcpl	0x00737365
     7c4:	616e614d 	cmnvs	lr, sp, asr #2
     7c8:	31726567 	cmncc	r2, r7, ror #10
     7cc:	746f4e34 	strbtvc	r4, [pc], #-3636	; 7d4 <shift+0x7d4>
     7d0:	5f796669 	svcpl	0x00796669
     7d4:	636f7250 	cmnvs	pc, #80, 4
     7d8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     7dc:	4955006a 	ldmdbmi	r5, {r1, r3, r5, r6}^
     7e0:	3233544e 	eorscc	r5, r3, #1308622848	; 0x4e000000
     7e4:	58414d5f 	stmdapl	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
     7e8:	43534200 	cmpmi	r3, #0, 4
     7ec:	61425f30 	cmpvs	r2, r0, lsr pc
     7f0:	46006573 			; <UNDEFINED> instruction: 0x46006573
     7f4:	5f646e69 	svcpl	0x00646e69
     7f8:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     7fc:	682f0064 	stmdavs	pc!, {r2, r5, r6}	; <UNPREDICTABLE>
     800:	2f656d6f 	svccs	0x00656d6f
     804:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
     808:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
     80c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
     810:	2f736f2f 	svccs	0x00736f2f
     814:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     818:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     81c:	752f7365 	strvc	r7, [pc, #-869]!	; 4bf <shift+0x4bf>
     820:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     824:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     828:	756f632f 	strbvc	r6, [pc, #-815]!	; 501 <shift+0x501>
     82c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     830:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     834:	616d2f6b 	cmnvs	sp, fp, ror #30
     838:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
     83c:	49007070 	stmdbmi	r0, {r4, r5, r6, ip, sp, lr}
     840:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     844:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     848:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     84c:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 684 <shift+0x684>
     850:	5f72656c 	svcpl	0x0072656c
     854:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     858:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     85c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     860:	5f4f4950 	svcpl	0x004f4950
     864:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     868:	3872656c 	ldmdacc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     86c:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     870:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     874:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     878:	43534200 	cmpmi	r3, #0, 4
     87c:	61425f31 	cmpvs	r2, r1, lsr pc
     880:	4d006573 	cfstr32mi	mvfx6, [r0, #-460]	; 0xfffffe34
     884:	505f7861 	subspl	r7, pc, r1, ror #16
     888:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     88c:	4f5f7373 	svcmi	0x005f7373
     890:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     894:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     898:	0073656c 	rsbseq	r6, r3, ip, ror #10
     89c:	314e5a5f 	cmpcc	lr, pc, asr sl
     8a0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8a8:	614d5f73 	hvcvs	54771	; 0xd5f3
     8ac:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8b0:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
     8b4:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     8b8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     8bc:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     8c0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     8c4:	006a4574 	rsbeq	r4, sl, r4, ror r5
     8c8:	544e4955 	strbpl	r4, [lr], #-2389	; 0xfffff6ab
     8cc:	4d5f3233 	lfmmi	f3, 2, [pc, #-204]	; 808 <shift+0x808>
     8d0:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
     8d4:	5f474e52 	svcpl	0x00474e52
     8d8:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8dc:	67694800 	strbvs	r4, [r9, -r0, lsl #16]!
     8e0:	46670068 	strbtmi	r0, [r7], -r8, rrx
     8e4:	72445f53 	subvc	r5, r4, #332	; 0x14c
     8e8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     8ec:	6f435f73 	svcvs	0x00435f73
     8f0:	00746e75 	rsbseq	r6, r4, r5, ror lr
     8f4:	4b4e5a5f 	blmi	1397278 <__bss_end+0x138d768>
     8f8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     8fc:	5f4f4950 	svcpl	0x004f4950
     900:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     904:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     908:	74654736 	strbtvc	r4, [r5], #-1846	; 0xfffff8ca
     90c:	5f50475f 	svcpl	0x0050475f
     910:	5f515249 	svcpl	0x00515249
     914:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     918:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     91c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     920:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     924:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     928:	4f495047 	svcmi	0x00495047
     92c:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     930:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     934:	545f7470 	ldrbpl	r7, [pc], #-1136	; 93c <shift+0x93c>
     938:	52657079 	rsbpl	r7, r5, #121	; 0x79
     93c:	5f31536a 	svcpl	0x0031536a
     940:	73695200 	cmnvc	r9, #0, 4
     944:	5f676e69 	svcpl	0x00676e69
     948:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     94c:	6f526d00 	svcvs	0x00526d00
     950:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     954:	47007379 	smlsdxmi	r0, r9, r3, r7
     958:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     95c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     960:	505f746e 	subspl	r7, pc, lr, ror #8
     964:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     968:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     96c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     970:	5f656c69 	svcpl	0x00656c69
     974:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     978:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     97c:	5f00746e 	svcpl	0x0000746e
     980:	314b4e5a 	cmpcc	fp, sl, asr lr
     984:	50474333 	subpl	r4, r7, r3, lsr r3
     988:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     98c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     990:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     994:	5f746547 	svcpl	0x00746547
     998:	53465047 	movtpl	r5, #24647	; 0x6047
     99c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     9a0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     9a4:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     9a8:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     9ac:	73005f30 	movwvc	r5, #3888	; 0xf30
     9b0:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     9b4:	665f3268 	ldrbvs	r3, [pc], -r8, ror #4
     9b8:	00656c69 	rsbeq	r6, r5, r9, ror #24
     9bc:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     9c0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     9c4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     9c8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     9cc:	48007265 	stmdami	r0, {r0, r2, r5, r6, r9, ip, sp, lr}
     9d0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9d4:	72505f65 	subsvc	r5, r0, #404	; 0x194
     9d8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9dc:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     9e0:	68730049 	ldmdavs	r3!, {r0, r3, r6}^
     9e4:	2074726f 	rsbscs	r7, r4, pc, ror #4
     9e8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     9ec:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     9f0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     9f4:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     9f8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     9fc:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     a00:	61570046 	cmpvs	r7, r6, asr #32
     a04:	5f007469 	svcpl	0x00007469
     a08:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     a0c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     a10:	61485f4f 	cmpvs	r8, pc, asr #30
     a14:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a18:	48303172 	ldmdami	r0!, {r1, r4, r5, r6, r8, ip, sp}
     a1c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     a20:	52495f65 	subpl	r5, r9, #404	; 0x194
     a24:	00764551 	rsbseq	r4, r6, r1, asr r5
     a28:	314e5a5f 	cmpcc	lr, pc, asr sl
     a2c:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     a30:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a34:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a38:	6e493031 	mcrvs	0, 2, r3, cr9, cr1, {1}
     a3c:	61697469 	cmnvs	r9, r9, ror #8
     a40:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     a44:	47007645 	strmi	r7, [r0, -r5, asr #12]
     a48:	445f7465 	ldrbmi	r7, [pc], #-1125	; a50 <shift+0xa50>
     a4c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a50:	5f646574 	svcpl	0x00646574
     a54:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     a58:	69505f74 	ldmdbvs	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a5c:	6e49006e 	cdpvs	0, 4, cr0, cr9, cr14, {3}
     a60:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     a64:	61747075 	cmnvs	r4, r5, ror r0
     a68:	5f656c62 	svcpl	0x00656c62
     a6c:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
     a70:	526d0070 	rsbpl	r0, sp, #112	; 0x70
     a74:	5f746f6f 	svcpl	0x00746f6f
     a78:	00766544 	rsbseq	r6, r6, r4, asr #10
     a7c:	70736964 	rsbsvc	r6, r3, r4, ror #18
     a80:	5f79616c 	svcpl	0x0079616c
     a84:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     a88:	6f6f6200 	svcvs	0x006f6200
     a8c:	6c41006c 	mcrrvs	0, 6, r0, r1, cr12
     a90:	00315f74 	eorseq	r5, r1, r4, ror pc
     a94:	5f746c41 	svcpl	0x00746c41
     a98:	4c6d0032 	stclmi	0, cr0, [sp], #-200	; 0xffffff38
     a9c:	5f747361 	svcpl	0x00747361
     aa0:	00444950 	subeq	r4, r4, r0, asr r9
     aa4:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     aa8:	0064656b 	rsbeq	r6, r4, fp, ror #10
     aac:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     ab0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     ab4:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     ab8:	5f6f666e 	svcpl	0x006f666e
     abc:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     ac0:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     ac4:	5f00355f 	svcpl	0x0000355f
     ac8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     acc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     ad0:	61485f4f 	cmpvs	r8, pc, asr #30
     ad4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ad8:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     adc:	4f5f7465 	svcmi	0x005f7465
     ae0:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     ae4:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     ae8:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     aec:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     af0:	544e0065 	strbpl	r0, [lr], #-101	; 0xffffff9b
     af4:	5f6b7361 	svcpl	0x006b7361
     af8:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     afc:	63730065 	cmnvs	r3, #101	; 0x65
     b00:	5f646568 	svcpl	0x00646568
     b04:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     b08:	00726574 	rsbseq	r6, r2, r4, ror r5
     b0c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     b10:	74735f64 	ldrbtvc	r5, [r3], #-3940	; 0xfffff09c
     b14:	63697461 	cmnvs	r9, #1627389952	; 0x61000000
     b18:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     b1c:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     b20:	6e490079 	mcrvs	0, 2, r0, cr9, cr9, {3}
     b24:	61697469 	cmnvs	r9, r9, ror #8
     b28:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     b2c:	53466700 	movtpl	r6, #26368	; 0x6700
     b30:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     b34:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     b38:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     b3c:	6f635f74 	svcvs	0x00635f74
     b40:	49006564 	stmdbmi	r0, {r2, r5, r6, r8, sl, sp, lr}
     b44:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     b48:	505f6469 	subspl	r6, pc, r9, ror #8
     b4c:	45006e69 	strmi	r6, [r0, #-3689]	; 0xfffff197
     b50:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     b54:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     b58:	5f746e65 	svcpl	0x00746e65
     b5c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     b60:	73007463 	movwvc	r7, #1123	; 0x463
     b64:	4f495047 	svcmi	0x00495047
     b68:	63536d00 	cmpvs	r3, #0, 26
     b6c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b70:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     b74:	7300636e 	movwvc	r6, #878	; 0x36e
     b78:	636f7250 	cmnvs	pc, #80, 4
     b7c:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
     b80:	4d007267 	sfmmi	f7, 4, [r0, #-412]	; 0xfffffe64
     b84:	53467861 	movtpl	r7, #26721	; 0x6861
     b88:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     b8c:	614e7265 	cmpvs	lr, r5, ror #4
     b90:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     b94:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     b98:	746f4e00 	strbtvc	r4, [pc], #-3584	; ba0 <shift+0xba0>
     b9c:	00796669 	rsbseq	r6, r9, r9, ror #12
     ba0:	616d6e55 	cmnvs	sp, r5, asr lr
     ba4:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ba8:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     bac:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     bb0:	5700746e 	strpl	r7, [r0, -lr, ror #8]
     bb4:	5f746961 	svcpl	0x00746961
     bb8:	5f726f46 	svcpl	0x00726f46
     bbc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     bc0:	5a5f0074 	bpl	17c0d98 <__bss_end+0x17b7288>
     bc4:	33314b4e 	teqcc	r1, #79872	; 0x13800
     bc8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     bcc:	61485f4f 	cmpvs	r8, pc, asr #30
     bd0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     bd4:	47383172 			; <UNDEFINED> instruction: 0x47383172
     bd8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bdc:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     be0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     be4:	6f697461 	svcvs	0x00697461
     be8:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     bec:	5f30536a 	svcpl	0x0030536a
     bf0:	636f4c00 	cmnvs	pc, #0, 24
     bf4:	6e555f6b 	cdpvs	15, 5, cr5, cr5, cr11, {3}
     bf8:	6b636f6c 	blvs	18dc9b0 <__bss_end+0x18d2ea0>
     bfc:	47006465 	strmi	r6, [r0, -r5, ror #8]
     c00:	5f4f4950 	svcpl	0x004f4950
     c04:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     c08:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c0c:	5f50475f 	svcpl	0x0050475f
     c10:	5f515249 	svcpl	0x00515249
     c14:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     c18:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     c1c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c20:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c24:	49464e49 	stmdbmi	r6, {r0, r3, r6, r9, sl, fp, lr}^
     c28:	5954494e 	ldmdbpl	r4, {r1, r2, r3, r6, r8, fp, lr}^
     c2c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c30:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     c34:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     c38:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c3c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c40:	6b636f4c 	blvs	18dc978 <__bss_end+0x18d2e68>
     c44:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c48:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c4c:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     c50:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c54:	61767265 	cmnvs	r6, r5, ror #4
     c58:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c5c:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     c60:	00657469 	rsbeq	r7, r5, r9, ror #8
     c64:	5f746547 	svcpl	0x00746547
     c68:	53465047 	movtpl	r5, #24647	; 0x6047
     c6c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     c70:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c74:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c78:	5f746553 	svcpl	0x00746553
     c7c:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     c80:	52007475 	andpl	r7, r0, #1962934272	; 0x75000000
     c84:	5f646165 	svcpl	0x00646165
     c88:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c8c:	6f5a0065 	svcvs	0x005a0065
     c90:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     c94:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     c98:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     c9c:	6f6c435f 	svcvs	0x006c435f
     ca0:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     ca4:	00657461 	rsbeq	r7, r5, r1, ror #8
     ca8:	314e5a5f 	cmpcc	lr, pc, asr sl
     cac:	50474333 	subpl	r4, r7, r3, lsr r3
     cb0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     cb4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     cb8:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     cbc:	5f746553 	svcpl	0x00746553
     cc0:	4f495047 	svcmi	0x00495047
     cc4:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     cc8:	6f697463 	svcvs	0x00697463
     ccc:	316a456e 	cmncc	sl, lr, ror #10
     cd0:	50474e34 	subpl	r4, r7, r4, lsr lr
     cd4:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     cd8:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     cdc:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     ce0:	5f746547 	svcpl	0x00746547
     ce4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ce8:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     cec:	5f006f66 	svcpl	0x00006f66
     cf0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     cf4:	6f725043 	svcvs	0x00725043
     cf8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     cfc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     d00:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d04:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     d08:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     d0c:	00764565 	rsbseq	r4, r6, r5, ror #10
     d10:	314e5a5f 	cmpcc	lr, pc, asr sl
     d14:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d18:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d1c:	614d5f73 	hvcvs	54771	; 0xd5f3
     d20:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d24:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     d28:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     d2c:	5f656c69 	svcpl	0x00656c69
     d30:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     d34:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     d38:	5045746e 	subpl	r7, r5, lr, ror #8
     d3c:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     d40:	4400656c 	strmi	r6, [r0], #-1388	; 0xfffffa94
     d44:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     d48:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 7e4 <shift+0x7e4>
     d4c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d50:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     d54:	00746365 	rsbseq	r6, r4, r5, ror #6
     d58:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
     d5c:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
     d60:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     d64:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     d68:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     d6c:	75006874 	strvc	r6, [r0, #-2164]	; 0xfffff78c
     d70:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     d74:	2064656e 	rsbcs	r6, r4, lr, ror #10
     d78:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     d7c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d80:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     d84:	4f495047 	svcmi	0x00495047
     d88:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     d8c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     d90:	65473232 	strbvs	r3, [r7, #-562]	; 0xfffffdce
     d94:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d98:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d9c:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 93f <shift+0x93f>
     da0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     da4:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     da8:	5f007645 	svcpl	0x00007645
     dac:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     db0:	6f725043 	svcvs	0x00725043
     db4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     db8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     dbc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     dc0:	63533231 	cmpvs	r3, #268435459	; 0x10000003
     dc4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     dc8:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 864 <shift+0x864>
     dcc:	76454644 	strbvc	r4, [r5], -r4, asr #12
     dd0:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     dd4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     dd8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     ddc:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     de0:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     de4:	6f435f6e 	svcvs	0x00435f6e
     de8:	00746e75 	rsbseq	r6, r4, r5, ror lr
     dec:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     df0:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     df4:	46540074 			; <UNDEFINED> instruction: 0x46540074
     df8:	72445f53 	subvc	r5, r4, #332	; 0x14c
     dfc:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     e00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e04:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     e08:	5f4f4950 	svcpl	0x004f4950
     e0c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     e10:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     e14:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     e18:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     e1c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     e20:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     e24:	00657361 	rsbeq	r7, r5, r1, ror #6
     e28:	6f6f526d 	svcvs	0x006f526d
     e2c:	46730074 			; <UNDEFINED> instruction: 0x46730074
     e30:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e34:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e38:	4c6d006d 	stclmi	0, cr0, [sp], #-436	; 0xfffffe4c
     e3c:	006b636f 	rsbeq	r6, fp, pc, ror #6
     e40:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     e44:	00676e69 	rsbeq	r6, r7, r9, ror #28
     e48:	314e5a5f 	cmpcc	lr, pc, asr sl
     e4c:	50474333 	subpl	r4, r7, r3, lsr r3
     e50:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e54:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e58:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     e5c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     e60:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     e64:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e68:	5045746e 	subpl	r7, r5, lr, ror #8
     e6c:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     e70:	006a656c 	rsbeq	r6, sl, ip, ror #10
     e74:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     e78:	745f3233 	ldrbvc	r3, [pc], #-563	; e80 <shift+0xe80>
     e7c:	73655200 	cmnvc	r5, #0, 4
     e80:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     e84:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     e88:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e8c:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     e90:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     e94:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     e98:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     e9c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ea0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ea4:	436d0065 	cmnmi	sp, #101	; 0x65
     ea8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     eac:	545f746e 	ldrbpl	r7, [pc], #-1134	; eb4 <shift+0xeb4>
     eb0:	5f6b7361 	svcpl	0x006b7361
     eb4:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     eb8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ebc:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ec0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     ec4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ec8:	704f346d 	subvc	r3, pc, sp, ror #8
     ecc:	50456e65 	subpl	r6, r5, r5, ror #28
     ed0:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     ed4:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ed8:	704f5f65 	subvc	r5, pc, r5, ror #30
     edc:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; d50 <shift+0xd50>
     ee0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     ee4:	5f746547 	svcpl	0x00746547
     ee8:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     eec:	6f4c5f54 	svcvs	0x004c5f54
     ef0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     ef4:	5f006e6f 	svcpl	0x00006e6f
     ef8:	314b4e5a 	cmpcc	fp, sl, asr lr
     efc:	50474333 	subpl	r4, r7, r3, lsr r3
     f00:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f04:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f08:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f0c:	5f746547 	svcpl	0x00746547
     f10:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     f14:	6f4c5f56 	svcvs	0x004c5f56
     f18:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     f1c:	6a456e6f 	bvs	115c8e0 <__bss_end+0x1152dd0>
     f20:	30536a52 	subscc	r6, r3, r2, asr sl
     f24:	576d005f 			; <UNDEFINED> instruction: 0x576d005f
     f28:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     f2c:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     f30:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f34:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     f38:	5f726576 	svcpl	0x00726576
     f3c:	00786469 	rsbseq	r6, r8, r9, ror #8
     f40:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f44:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     f48:	6c430079 	mcrrvs	0, 7, r0, r3, cr9
     f4c:	5f726165 	svcpl	0x00726165
     f50:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     f54:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     f58:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     f5c:	7300746e 	movwvc	r7, #1134	; 0x46e
     f60:	7065656c 	rsbvc	r6, r5, ip, ror #10
     f64:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     f68:	5f007265 	svcpl	0x00007265
     f6c:	314b4e5a 	cmpcc	fp, sl, asr lr
     f70:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     f74:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f78:	614d5f73 	hvcvs	54771	; 0xd5f3
     f7c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f80:	47383172 			; <UNDEFINED> instruction: 0x47383172
     f84:	505f7465 	subspl	r7, pc, r5, ror #8
     f88:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f8c:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     f90:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f94:	006a4544 	rsbeq	r4, sl, r4, asr #10
     f98:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     f9c:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     fa0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     fa4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     fa8:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     fac:	5a5f0049 	bpl	17c10d8 <__bss_end+0x17b75c8>
     fb0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fb4:	636f7250 	cmnvs	pc, #80, 4
     fb8:	5f737365 	svcpl	0x00737365
     fbc:	616e614d 	cmnvs	lr, sp, asr #2
     fc0:	31726567 	cmncc	r2, r7, ror #10
     fc4:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     fc8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     fcc:	52525f65 	subspl	r5, r2, #404	; 0x194
     fd0:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
     fd4:	006b7361 	rsbeq	r7, fp, r1, ror #6
     fd8:	5f746547 	svcpl	0x00746547
     fdc:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     fe0:	6f4e0074 	svcvs	0x004e0074
     fe4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     fe8:	6f72505f 	svcvs	0x0072505f
     fec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ff0:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     ff4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ff8:	5a5f0065 	bpl	17c1194 <__bss_end+0x17b7684>
     ffc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1000:	636f7250 	cmnvs	pc, #80, 4
    1004:	5f737365 	svcpl	0x00737365
    1008:	616e614d 	cmnvs	lr, sp, asr #2
    100c:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
    1010:	6f6c4231 	svcvs	0x006c4231
    1014:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    1018:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    101c:	505f746e 	subspl	r7, pc, lr, ror #8
    1020:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1024:	76457373 			; <UNDEFINED> instruction: 0x76457373
    1028:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    102c:	50433631 	subpl	r3, r3, r1, lsr r6
    1030:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1034:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e70 <shift+0xe70>
    1038:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    103c:	53397265 	teqpl	r9, #1342177286	; 0x50000006
    1040:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1044:	6f545f68 	svcvs	0x00545f68
    1048:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
    104c:	6f725043 	svcvs	0x00725043
    1050:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1054:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    1058:	6f4e5f74 	svcvs	0x004e5f74
    105c:	5f006564 	svcpl	0x00006564
    1060:	314b4e5a 	cmpcc	fp, sl, asr lr
    1064:	50474333 	subpl	r4, r7, r3, lsr r3
    1068:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    106c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1070:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1074:	5f746547 	svcpl	0x00746547
    1078:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
    107c:	6f4c5f53 	svcvs	0x004c5f53
    1080:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    1084:	6a456e6f 	bvs	115ca48 <__bss_end+0x1152f38>
    1088:	30536a52 	subscc	r6, r3, r2, asr sl
    108c:	6353005f 	cmpvs	r3, #95	; 0x5f
    1090:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1094:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    1098:	65470052 	strbvs	r0, [r7, #-82]	; 0xffffffae
    109c:	50475f74 	subpl	r5, r7, r4, ror pc
    10a0:	5f56454c 	svcpl	0x0056454c
    10a4:	61636f4c 	cmnvs	r3, ip, asr #30
    10a8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    10ac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10b0:	50433631 	subpl	r3, r3, r1, lsr r6
    10b4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10b8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ef4 <shift+0xef4>
    10bc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    10c0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    10c4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10c8:	505f656c 	subspl	r6, pc, ip, ror #10
    10cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10d0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    10d4:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    10d8:	57534e30 	smmlarpl	r3, r0, lr, r4
    10dc:	72505f49 	subsvc	r5, r0, #292	; 0x124
    10e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10e4:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
    10e8:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    10ec:	6a6a6a65 	bvs	1a9ba88 <__bss_end+0x1a91f78>
    10f0:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    10f4:	5f495753 	svcpl	0x00495753
    10f8:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    10fc:	6100746c 	tstvs	r0, ip, ror #8
    1100:	00766772 	rsbseq	r6, r6, r2, ror r7
    1104:	314e5a5f 	cmpcc	lr, pc, asr sl
    1108:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    110c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1110:	614d5f73 	hvcvs	54771	; 0xd5f3
    1114:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1118:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
    111c:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    1120:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1124:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1128:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
    112c:	5300626a 	movwpl	r6, #618	; 0x26a
    1130:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1134:	6f545f68 	svcvs	0x00545f68
    1138:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    113c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    1140:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1144:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1148:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    114c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1150:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1154:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1158:	4f495047 	svcmi	0x00495047
    115c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1160:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1164:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1168:	50475f74 	subpl	r5, r7, r4, ror pc
    116c:	5f544553 	svcpl	0x00544553
    1170:	61636f4c 	cmnvs	r3, ip, asr #30
    1174:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1178:	6a526a45 	bvs	149ba94 <__bss_end+0x1491f84>
    117c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1180:	61766e49 	cmnvs	r6, r9, asr #28
    1184:	5f64696c 	svcpl	0x0064696c
    1188:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    118c:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    1190:	545f5346 	ldrbpl	r5, [pc], #-838	; 1198 <shift+0x1198>
    1194:	5f656572 	svcpl	0x00656572
    1198:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    119c:	6f6c4200 	svcvs	0x006c4200
    11a0:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    11a4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    11a8:	505f746e 	subspl	r7, pc, lr, ror #8
    11ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11b0:	70007373 	andvc	r7, r0, r3, ror r3
    11b4:	695f6e69 	ldmdbvs	pc, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    11b8:	46007864 	strmi	r7, [r0], -r4, ror #16
    11bc:	5f656572 	svcpl	0x00656572
    11c0:	006e6950 	rsbeq	r6, lr, r0, asr r9
    11c4:	4b4e5a5f 	blmi	1397b48 <__bss_end+0x138e038>
    11c8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    11cc:	5f4f4950 	svcpl	0x004f4950
    11d0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11d4:	3172656c 	cmncc	r2, ip, ror #10
    11d8:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
    11dc:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
    11e0:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
    11e4:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    11e8:	6a456e6f 	bvs	115cbac <__bss_end+0x115309c>
    11ec:	6f6c4300 	svcvs	0x006c4300
    11f0:	64006573 	strvs	r6, [r0], #-1395	; 0xfffffa8d
    11f4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    11f8:	72610072 	rsbvc	r0, r1, #114	; 0x72
    11fc:	49006367 	stmdbmi	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
    1200:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1204:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1208:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 1210 <shift+0x1210>
    120c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1210:	77730072 			; <UNDEFINED> instruction: 0x77730072
    1214:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1218:	69665f31 	stmdbvs	r6!, {r0, r4, r5, r8, r9, sl, fp, ip, lr}^
    121c:	4300656c 	movwmi	r6, #1388	; 0x56c
    1220:	4f495047 	svcmi	0x00495047
    1224:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1228:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    122c:	736e5500 	cmnvc	lr, #0, 10
    1230:	69636570 	stmdbvs	r3!, {r4, r5, r6, r8, sl, sp, lr}^
    1234:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
    1238:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
    123c:	4f5f6574 	svcmi	0x005f6574
    1240:	00796c6e 	rsbseq	r6, r9, lr, ror #24
    1244:	5f746547 	svcpl	0x00746547
    1248:	00444950 	subeq	r4, r4, r0, asr r9
    124c:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
    1250:	5a5f0064 	bpl	17c13e8 <__bss_end+0x17b78d8>
    1254:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1258:	636f7250 	cmnvs	pc, #80, 4
    125c:	5f737365 	svcpl	0x00737365
    1260:	616e614d 	cmnvs	lr, sp, asr #2
    1264:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1268:	00764534 	rsbseq	r4, r6, r4, lsr r5
    126c:	6f6f526d 	svcvs	0x006f526d
    1270:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
    1274:	70630074 	rsbvc	r0, r3, r4, ror r0
    1278:	6f635f75 	svcvs	0x00635f75
    127c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1280:	65540074 	ldrbvs	r0, [r4, #-116]	; 0xffffff8c
    1284:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1288:	00657461 	rsbeq	r7, r5, r1, ror #8
    128c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1290:	6148006c 	cmpvs	r8, ip, rrx
    1294:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1298:	5152495f 	cmppl	r2, pc, asr r9
    129c:	6f6c6300 	svcvs	0x006c6300
    12a0:	53006573 	movwpl	r6, #1395	; 0x573
    12a4:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    12a8:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
    12ac:	00657669 	rsbeq	r7, r5, r9, ror #12
    12b0:	76746572 			; <UNDEFINED> instruction: 0x76746572
    12b4:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    12b8:	00727563 	rsbseq	r7, r2, r3, ror #10
    12bc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    12c0:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    12c4:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    12c8:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    12cc:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
    12d0:	5f006d75 	svcpl	0x00006d75
    12d4:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    12d8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    12dc:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    12e0:	0076646c 	rsbseq	r6, r6, ip, ror #8
    12e4:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
    12e8:	5f746573 	svcpl	0x00746573
    12ec:	6b736174 	blvs	1cd98c4 <__bss_end+0x1ccfdb4>
    12f0:	6165645f 	cmnvs	r5, pc, asr r4
    12f4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    12f8:	77006a65 	strvc	r6, [r0, -r5, ror #20]
    12fc:	00746961 	rsbseq	r6, r4, r1, ror #18
    1300:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
    1304:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    1308:	006a6a79 	rsbeq	r6, sl, r9, ror sl
    130c:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
    1310:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1314:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1318:	61460069 	cmpvs	r6, r9, rrx
    131c:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
    1320:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    1324:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1328:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    132c:	5f746567 	svcpl	0x00746567
    1330:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1334:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1338:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    133c:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    1340:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1344:	69740076 	ldmdbvs	r4!, {r1, r2, r4, r5, r6}^
    1348:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    134c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1350:	7165725f 	cmnvc	r5, pc, asr r2
    1354:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
    1358:	69500064 	ldmdbvs	r0, {r2, r5, r6}^
    135c:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    1360:	5f656c69 	svcpl	0x00656c69
    1364:	66657250 			; <UNDEFINED> instruction: 0x66657250
    1368:	53007869 	movwpl	r7, #2153	; 0x869
    136c:	505f7465 	subspl	r7, pc, r5, ror #8
    1370:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    1374:	5a5f0073 	bpl	17c1548 <__bss_end+0x17b7a38>
    1378:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    137c:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1380:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1384:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1388:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
    138c:	00706565 	rsbseq	r6, r0, r5, ror #10
    1390:	61736944 	cmnvs	r3, r4, asr #18
    1394:	5f656c62 	svcpl	0x00656c62
    1398:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    139c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    13a0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    13a4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    13a8:	5f746573 	svcpl	0x00746573
    13ac:	6b736174 	blvs	1cd9984 <__bss_end+0x1ccfe74>
    13b0:	6165645f 	cmnvs	r5, pc, asr r4
    13b4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    13b8:	706f0065 	rsbvc	r0, pc, r5, rrx
    13bc:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    13c0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    13c4:	63355a5f 	teqvs	r5, #389120	; 0x5f000
    13c8:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    13cc:	682f006a 	stmdavs	pc!, {r1, r3, r5, r6}	; <UNPREDICTABLE>
    13d0:	2f656d6f 	svccs	0x00656d6f
    13d4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    13d8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    13dc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    13e0:	2f736f2f 	svccs	0x00736f2f
    13e4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    13e8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    13ec:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    13f0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    13f4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    13f8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    13fc:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    1400:	70632e65 	rsbvc	r2, r3, r5, ror #28
    1404:	5a5f0070 	bpl	17c15cc <__bss_end+0x17b7abc>
    1408:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    140c:	76646970 			; <UNDEFINED> instruction: 0x76646970
    1410:	616e6600 	cmnvs	lr, r0, lsl #12
    1414:	6e00656d 	cfsh32vs	mvfx6, mvfx0, #61
    1418:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    141c:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
    1420:	00736b63 	rsbseq	r6, r3, r3, ror #22
    1424:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1428:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    142c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    1430:	6a634b50 	bvs	18d4178 <__bss_end+0x18ca668>
    1434:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
    1438:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    143c:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
    1440:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
    1444:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1448:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    144c:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1450:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1454:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1458:	6f682f00 	svcvs	0x00682f00
    145c:	6a2f656d 	bvs	bdaa18 <__bss_end+0xbd0f08>
    1460:	73656d61 	cmnvc	r5, #6208	; 0x1840
    1464:	2f697261 	svccs	0x00697261
    1468:	2f746967 	svccs	0x00746967
    146c:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    1470:	6f732f70 	svcvs	0x00732f70
    1474:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1478:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    147c:	00646c69 	rsbeq	r6, r4, r9, ror #24
    1480:	61726170 	cmnvs	r2, r0, ror r1
    1484:	5a5f006d 	bpl	17c1640 <__bss_end+0x17b7b30>
    1488:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    148c:	506a6574 	rsbpl	r6, sl, r4, ror r5
    1490:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1494:	5f746567 	svcpl	0x00746567
    1498:	6b736174 	blvs	1cd9a70 <__bss_end+0x1ccff60>
    149c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    14a0:	745f736b 	ldrbvc	r7, [pc], #-875	; 14a8 <shift+0x14a8>
    14a4:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    14a8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    14ac:	7700656e 	strvc	r6, [r0, -lr, ror #10]
    14b0:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    14b4:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    14b8:	7a69735f 	bvc	1a5e23c <__bss_end+0x1a5472c>
    14bc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
    14c0:	61505f74 	cmpvs	r0, r4, ror pc
    14c4:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
    14c8:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    14cc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    14d0:	006a6a70 	rsbeq	r6, sl, r0, ror sl
    14d4:	5f746547 	svcpl	0x00746547
    14d8:	616d6552 	cmnvs	sp, r2, asr r5
    14dc:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
    14e0:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
    14e4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    14e8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    14ec:	445f746e 	ldrbmi	r7, [pc], #-1134	; 14f4 <shift+0x14f4>
    14f0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    14f4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
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
    1534:	6a746961 	bvs	1d1bac0 <__bss_end+0x1d11fb0>
    1538:	5f006a6a 	svcpl	0x00006a6a
    153c:	6f69355a 	svcvs	0x0069355a
    1540:	6a6c7463 	bvs	1b1e6d4 <__bss_end+0x1b14bc4>
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
    1570:	5a5f0072 	bpl	17c1740 <__bss_end+0x17b7c30>
    1574:	61657234 	cmnvs	r5, r4, lsr r2
    1578:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    157c:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    1580:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1584:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1588:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    158c:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    1590:	6f637465 	svcvs	0x00637465
    1594:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1598:	615f7465 	cmpvs	pc, r5, ror #8
    159c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    15a0:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    15a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    15a8:	6f635f73 	svcvs	0x00635f73
    15ac:	00746e75 	rsbseq	r6, r4, r5, ror lr
    15b0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    15b4:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    15b8:	61657200 	cmnvs	r5, r0, lsl #4
    15bc:	65740064 	ldrbvs	r0, [r4, #-100]!	; 0xffffff9c
    15c0:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    15c4:	00657461 	rsbeq	r7, r5, r1, ror #8
    15c8:	70746567 	rsbsvc	r6, r4, r7, ror #10
    15cc:	5f006469 	svcpl	0x00006469
    15d0:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    15d4:	4b506e65 	blmi	141cf70 <__bss_end+0x1413460>
    15d8:	4e353163 	rsfmisz	f3, f5, f3
    15dc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    15e0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    15e4:	6f4d5f6e 	svcvs	0x004d5f6e
    15e8:	47006564 	strmi	r6, [r0, -r4, ror #10]
    15ec:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    15f0:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    15f4:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    15f8:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    15fc:	31393130 	teqcc	r9, r0, lsr r1
    1600:	20353230 	eorscs	r3, r5, r0, lsr r2
    1604:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1608:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    160c:	415b2029 	cmpmi	fp, r9, lsr #32
    1610:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1614:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1618:	6172622d 	cmnvs	r2, sp, lsr #4
    161c:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1620:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1624:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1628:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    162c:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1630:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1634:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1638:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    163c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1640:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1644:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1648:	20706676 	rsbscs	r6, r0, r6, ror r6
    164c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1650:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1654:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1658:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    165c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1660:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1664:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1668:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    166c:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    1670:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1674:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1678:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    167c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1680:	616d2d20 	cmnvs	sp, r0, lsr #26
    1684:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1688:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    168c:	2b6b7a36 	blcs	1adff6c <__bss_end+0x1ad645c>
    1690:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1694:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1698:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    169c:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    16a0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    16a4:	6f6e662d 	svcvs	0x006e662d
    16a8:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    16ac:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    16b0:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    16b4:	6f6e662d 	svcvs	0x006e662d
    16b8:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    16bc:	5a5f0069 	bpl	17c1868 <__bss_end+0x17b7d58>
    16c0:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    16c4:	50797063 	rsbspl	r7, r9, r3, rrx
    16c8:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    16cc:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    16d0:	2f656d6f 	svccs	0x00656d6f
    16d4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
    16d8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
    16dc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
    16e0:	2f736f2f 	svccs	0x00736f2f
    16e4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    16e8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    16ec:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    16f0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    16f4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    16f8:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    16fc:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1700:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1704:	00707063 	rsbseq	r7, r0, r3, rrx
    1708:	616d6572 	smcvs	54866	; 0xd652
    170c:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    1710:	73690072 	cmnvc	r9, #114	; 0x72
    1714:	006e616e 	rsbeq	r6, lr, lr, ror #2
    1718:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    171c:	6c617267 	sfmvs	f7, 2, [r1], #-412	; 0xfffffe64
    1720:	69736900 	ldmdbvs	r3!, {r8, fp, sp, lr}^
    1724:	6400666e 	strvs	r6, [r0], #-1646	; 0xfffff992
    1728:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    172c:	5f006c61 	svcpl	0x00006c61
    1730:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1734:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1738:	61006a63 	tstvs	r0, r3, ror #20
    173c:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1740:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1744:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1748:	73006e65 	movwvc	r6, #3685	; 0xe65
    174c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1750:	65645f67 	strbvs	r5, [r4, #-3943]!	; 0xfffff099
    1754:	616d6963 	cmnvs	sp, r3, ror #18
    1758:	7000736c 	andvc	r7, r0, ip, ror #6
    175c:	7265776f 	rsbvc	r7, r5, #29097984	; 0x1bc0000
    1760:	72747300 	rsbsvc	r7, r4, #0, 6
    1764:	5f676e69 	svcpl	0x00676e69
    1768:	5f746e69 	svcpl	0x00746e69
    176c:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1770:	6f707865 	svcvs	0x00707865
    1774:	746e656e 	strbtvc	r6, [lr], #-1390	; 0xfffffa92
    1778:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    177c:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    1780:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1784:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1788:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    178c:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    1790:	63507274 	cmpvs	r0, #116, 4	; 0x40000007
    1794:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1798:	616e7369 	cmnvs	lr, r9, ror #6
    179c:	6900666e 	stmdbvs	r0, {r1, r2, r3, r5, r6, r9, sl, sp, lr}
    17a0:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    17a4:	73616200 	cmnvc	r1, #0, 4
    17a8:	65740065 	ldrbvs	r0, [r4, #-101]!	; 0xffffff9b
    17ac:	5f00706d 	svcpl	0x0000706d
    17b0:	7a62355a 	bvc	188ed20 <__bss_end+0x1885210>
    17b4:	506f7265 	rsbpl	r7, pc, r5, ror #4
    17b8:	73006976 	movwvc	r6, #2422	; 0x976
    17bc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17c0:	69007970 	stmdbvs	r0, {r4, r5, r6, r8, fp, ip, sp, lr}
    17c4:	00616f74 	rsbeq	r6, r1, r4, ror pc
    17c8:	31727473 	cmncc	r2, r3, ror r4
    17cc:	72747300 	rsbsvc	r7, r4, #0, 6
    17d0:	5f676e69 	svcpl	0x00676e69
    17d4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    17d8:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    17dc:	666e6973 			; <UNDEFINED> instruction: 0x666e6973
    17e0:	5a5f0066 	bpl	17c1980 <__bss_end+0x17b7e70>
    17e4:	776f7033 			; <UNDEFINED> instruction: 0x776f7033
    17e8:	5f006a66 	svcpl	0x00006a66
    17ec:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    17f0:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    17f4:	6f6c665f 	svcvs	0x006c665f
    17f8:	52667461 	rsbpl	r7, r6, #1627389952	; 0x61000000
    17fc:	525f536a 	subspl	r5, pc, #-1476395007	; 0xa8000001
    1800:	74610069 	strbtvc	r0, [r1], #-105	; 0xffffff97
    1804:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1808:	73646d65 	cmnvc	r4, #6464	; 0x1940
    180c:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1810:	6f437261 	svcvs	0x00437261
    1814:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1818:	74660072 	strbtvc	r0, [r6], #-114	; 0xffffff8e
    181c:	5f00616f 	svcpl	0x0000616f
    1820:	6433325a 	ldrtvs	r3, [r3], #-602	; 0xfffffda6
    1824:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1828:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1830 <shift+0x1830>
    182c:	74735f6f 	ldrbtvc	r5, [r3], #-3951	; 0xfffff091
    1830:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1834:	6f6c665f 	svcvs	0x006c665f
    1838:	506a7461 	rsbpl	r7, sl, r1, ror #8
    183c:	6d006963 	vstrvs.16	s12, [r0, #-198]	; 0xffffff3a	; <UNPREDICTABLE>
    1840:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    1844:	72700063 	rsbsvc	r0, r0, #99	; 0x63
    1848:	73696365 	cmnvc	r9, #-1811939327	; 0x94000001
    184c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1850:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1854:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    1858:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    185c:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
    1860:	73007865 	movwvc	r7, #2149	; 0x865
    1864:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1868:	6400706d 	strvs	r7, [r0], #-109	; 0xffffff93
    186c:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    1870:	5a5f0073 	bpl	17c1a44 <__bss_end+0x17b7f34>
    1874:	6f746134 	svcvs	0x00746134
    1878:	634b5069 	movtvs	r5, #45161	; 0xb069
    187c:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1880:	00747570 	rsbseq	r7, r4, r0, ror r5
    1884:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1888:	66616f74 	uqsub16vs	r6, r1, r4
    188c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1890:	696c7073 	stmdbvs	ip!, {r0, r1, r4, r5, r6, ip, sp, lr}^
    1894:	6c665f74 	stclvs	15, cr5, [r6], #-464	; 0xfffffe30
    1898:	0074616f 	rsbseq	r6, r4, pc, ror #2
    189c:	74636166 	strbtvc	r6, [r3], #-358	; 0xfffffe9a
    18a0:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    18a4:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    18a8:	4b506e65 	blmi	141d244 <__bss_end+0x1413734>
    18ac:	5a5f0063 	bpl	17c1a40 <__bss_end+0x17b7f30>
    18b0:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    18b4:	706d636e 	rsbvc	r6, sp, lr, ror #6
    18b8:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    18bc:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    18c0:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    18c4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    18c8:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    18cc:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    18d0:	63656400 	cmnvs	r5, #0, 8
    18d4:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    18d8:	5f6f745f 	svcpl	0x006f745f
    18dc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    18e0:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    18e4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    18e8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    18ec:	616f7466 	cmnvs	pc, r6, ror #8
    18f0:	00635066 	rsbeq	r5, r3, r6, rrx
    18f4:	6f6d656d 	svcvs	0x006d656d
    18f8:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    18fc:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    1900:	74730068 	ldrbtvc	r0, [r3], #-104	; 0xffffff98
    1904:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1908:	76657200 	strbtvc	r7, [r5], -r0, lsl #4
    190c:	00727473 	rsbseq	r7, r2, r3, ror r4
    1910:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1914:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1918:	2f2e2e2f 	svccs	0x002e2e2f
    191c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1920:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1924:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1928:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    192c:	2f676966 	svccs	0x00676966
    1930:	2f6d7261 	svccs	0x006d7261
    1934:	3162696c 	cmncc	r2, ip, ror #18
    1938:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    193c:	00532e73 	subseq	r2, r3, r3, ror lr
    1940:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1944:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1948:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    194c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1950:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1954:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1958:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    195c:	2f39546b 	svccs	0x0039546b
    1960:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1964:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1968:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    196c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1970:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1974:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1978:	2f34712d 	svccs	0x0034712d
    197c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1980:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1984:	6f6e2d6d 	svcvs	0x006e2d6d
    1988:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    198c:	2f696261 	svccs	0x00696261
    1990:	2f6d7261 	svccs	0x006d7261
    1994:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1998:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    199c:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    19a0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    19a4:	52415400 	subpl	r5, r1, #0, 8
    19a8:	5f544547 	svcpl	0x00544547
    19ac:	5f555043 	svcpl	0x00555043
    19b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19b4:	31617865 	cmncc	r1, r5, ror #16
    19b8:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    19bc:	61786574 	cmnvs	r8, r4, ror r5
    19c0:	73690037 	cmnvc	r9, #55	; 0x37
    19c4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19c8:	70665f74 	rsbvc	r5, r6, r4, ror pc
    19cc:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    19d0:	6d726100 	ldfvse	f6, [r2, #-0]
    19d4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    19d8:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    19dc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    19e0:	52415400 	subpl	r5, r1, #0, 8
    19e4:	5f544547 	svcpl	0x00544547
    19e8:	5f555043 	svcpl	0x00555043
    19ec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19f0:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    19f4:	52410033 	subpl	r0, r1, #51	; 0x33
    19f8:	51455f4d 	cmppl	r5, sp, asr #30
    19fc:	52415400 	subpl	r5, r1, #0, 8
    1a00:	5f544547 	svcpl	0x00544547
    1a04:	5f555043 	svcpl	0x00555043
    1a08:	316d7261 	cmncc	sp, r1, ror #4
    1a0c:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1a10:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1a14:	5f617369 	svcpl	0x00617369
    1a18:	5f746962 	svcpl	0x00746962
    1a1c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1a20:	41540062 	cmpmi	r4, r2, rrx
    1a24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a30:	61786574 	cmnvs	r8, r4, ror r5
    1a34:	6f633735 	svcvs	0x00633735
    1a38:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a3c:	00333561 	eorseq	r3, r3, r1, ror #10
    1a40:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a44:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a48:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1a4c:	5341425f 	movtpl	r4, #4703	; 0x125f
    1a50:	41540045 	cmpmi	r4, r5, asr #32
    1a54:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a58:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a5c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a60:	00303138 	eorseq	r3, r0, r8, lsr r1
    1a64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a6c:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1a70:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1a74:	52410031 	subpl	r0, r1, #49	; 0x31
    1a78:	43505f4d 	cmpmi	r0, #308	; 0x134
    1a7c:	41415f53 	cmpmi	r1, r3, asr pc
    1a80:	5f534350 	svcpl	0x00534350
    1a84:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1a88:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1a8c:	5f455341 	svcpl	0x00455341
    1a90:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a94:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1a98:	5f455341 	svcpl	0x00455341
    1a9c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1aa0:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1aa4:	5f455341 	svcpl	0x00455341
    1aa8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1aac:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1ab0:	5f455341 	svcpl	0x00455341
    1ab4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ab8:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1abc:	5f455341 	svcpl	0x00455341
    1ac0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ac4:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1ac8:	5f455341 	svcpl	0x00455341
    1acc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ad0:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1ad4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ad8:	50435f54 	subpl	r5, r3, r4, asr pc
    1adc:	73785f55 	cmnvc	r8, #340	; 0x154
    1ae0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1ae4:	61736900 	cmnvs	r3, r0, lsl #18
    1ae8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1aec:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1af0:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1af4:	52415400 	subpl	r5, r1, #0, 8
    1af8:	5f544547 	svcpl	0x00544547
    1afc:	5f555043 	svcpl	0x00555043
    1b00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b04:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1b08:	41540033 	cmpmi	r4, r3, lsr r0
    1b0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b14:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b18:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1b1c:	73690069 	cmnvc	r9, #105	; 0x69
    1b20:	6f6e5f61 	svcvs	0x006e5f61
    1b24:	00746962 	rsbseq	r6, r4, r2, ror #18
    1b28:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b2c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b30:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b34:	31316d72 	teqcc	r1, r2, ror sp
    1b38:	7a6a3637 	bvc	1a8f41c <__bss_end+0x1a8590c>
    1b3c:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1b40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b44:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1b48:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1b4c:	4d524100 	ldfmie	f4, [r2, #-0]
    1b50:	5343505f 	movtpl	r5, #12383	; 0x305f
    1b54:	4b4e555f 	blmi	13970d8 <__bss_end+0x138d5c8>
    1b58:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1b5c:	52415400 	subpl	r5, r1, #0, 8
    1b60:	5f544547 	svcpl	0x00544547
    1b64:	5f555043 	svcpl	0x00555043
    1b68:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1b6c:	41420065 	cmpmi	r2, r5, rrx
    1b70:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b74:	5f484352 	svcpl	0x00484352
    1b78:	4a455435 	bmi	1156c54 <__bss_end+0x114d144>
    1b7c:	6d726100 	ldfvse	f6, [r2, #-0]
    1b80:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1b84:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1b88:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1b8c:	6d726100 	ldfvse	f6, [r2, #-0]
    1b90:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b94:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1b98:	736e7500 	cmnvc	lr, #0, 10
    1b9c:	5f636570 	svcpl	0x00636570
    1ba0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1ba4:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1ba8:	5f617369 	svcpl	0x00617369
    1bac:	5f746962 	svcpl	0x00746962
    1bb0:	00636573 	rsbeq	r6, r3, r3, ror r5
    1bb4:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1bb8:	61745f7a 	cmnvs	r4, sl, ror pc
    1bbc:	52410062 	subpl	r0, r1, #98	; 0x62
    1bc0:	43565f4d 	cmpmi	r6, #308	; 0x134
    1bc4:	6d726100 	ldfvse	f6, [r2, #-0]
    1bc8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1bcc:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1bd0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1bd4:	4d524100 	ldfmie	f4, [r2, #-0]
    1bd8:	00454c5f 	subeq	r4, r5, pc, asr ip
    1bdc:	5f4d5241 	svcpl	0x004d5241
    1be0:	41005356 	tstmi	r0, r6, asr r3
    1be4:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1be8:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1bec:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1bf0:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1bf4:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1bf8:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1bfc:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1c04 <shift+0x1c04>
    1c00:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1c04:	6f6c6620 	svcvs	0x006c6620
    1c08:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1c0c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c10:	50435f54 	subpl	r5, r3, r4, asr pc
    1c14:	6f635f55 	svcvs	0x00635f55
    1c18:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c1c:	00353161 	eorseq	r3, r5, r1, ror #2
    1c20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c28:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1c2c:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1c30:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1c34:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c38:	50435f54 	subpl	r5, r3, r4, asr pc
    1c3c:	6f635f55 	svcvs	0x00635f55
    1c40:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c44:	00373161 	eorseq	r3, r7, r1, ror #2
    1c48:	5f4d5241 	svcpl	0x004d5241
    1c4c:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1c50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c54:	50435f54 	subpl	r5, r3, r4, asr pc
    1c58:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1c5c:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1c60:	316e6573 	smccc	58963	; 0xe653
    1c64:	2f2e2e00 	svccs	0x002e2e00
    1c68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c70:	2f2e2e2f 	svccs	0x002e2e2f
    1c74:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1bc4 <shift+0x1bc4>
    1c78:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c7c:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1c80:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c84:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1c88:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c90:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c94:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c98:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1c9c:	53414200 	movtpl	r4, #4608	; 0x1200
    1ca0:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ca4:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1ca8:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1cac:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cb0:	50435f54 	subpl	r5, r3, r4, asr pc
    1cb4:	6f635f55 	svcvs	0x00635f55
    1cb8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cbc:	00323161 	eorseq	r3, r2, r1, ror #2
    1cc0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1cc4:	5f6c6176 	svcpl	0x006c6176
    1cc8:	41420074 	hvcmi	8196	; 0x2004
    1ccc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1cd0:	5f484352 	svcpl	0x00484352
    1cd4:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1cd8:	5f617369 	svcpl	0x00617369
    1cdc:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1ce0:	6d726100 	ldfvse	f6, [r2, #-0]
    1ce4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ce8:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1cec:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1cf0:	00766964 	rsbseq	r6, r6, r4, ror #18
    1cf4:	5f6d7261 	svcpl	0x006d7261
    1cf8:	5f757066 	svcpl	0x00757066
    1cfc:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1d00:	61736900 	cmnvs	r3, r0, lsl #18
    1d04:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d08:	3170665f 	cmncc	r0, pc, asr r6
    1d0c:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1d10:	31432055 	qdaddcc	r2, r5, r3
    1d14:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1d18:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1d1c:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1d20:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1d24:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1d28:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1d2c:	5b202965 	blpl	80c2c8 <__bss_end+0x8027b8>
    1d30:	2f4d5241 	svccs	0x004d5241
    1d34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1d38:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1d3c:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1d40:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1d44:	6f697369 	svcvs	0x00697369
    1d48:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1d4c:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1d50:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1d54:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1d58:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1d5c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1d60:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1d64:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1d68:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d6c:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1d70:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d74:	2b657435 	blcs	195ee50 <__bss_end+0x1955340>
    1d78:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1d7c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1d80:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1d84:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1d88:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1d8c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1d90:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1d94:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1d98:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1d9c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1da0:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1da4:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1da8:	6b636174 	blvs	18da380 <__bss_end+0x18d0870>
    1dac:	6f72702d 	svcvs	0x0072702d
    1db0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1db4:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1db8:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1c28 <shift+0x1c28>
    1dbc:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1dc0:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1dc4:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1dc8:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1dcc:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1dd0:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1dd4:	41006e65 	tstmi	r0, r5, ror #28
    1dd8:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1ddc:	73690049 	cmnvc	r9, #73	; 0x49
    1de0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1de4:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1de8:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1dec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1df0:	50435f54 	subpl	r5, r3, r4, asr pc
    1df4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1df8:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1dfc:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1e00:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e04:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e08:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e0c:	00386d72 	eorseq	r6, r8, r2, ror sp
    1e10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e18:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e1c:	00396d72 	eorseq	r6, r9, r2, ror sp
    1e20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e28:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1e2c:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1e30:	6d726100 	ldfvse	f6, [r2, #-0]
    1e34:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e38:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    1e3c:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1e40:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e44:	50435f54 	subpl	r5, r3, r4, asr pc
    1e48:	6f635f55 	svcvs	0x00635f55
    1e4c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e50:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1e54:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e58:	50435f54 	subpl	r5, r3, r4, asr pc
    1e5c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e60:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1e64:	52415400 	subpl	r5, r1, #0, 8
    1e68:	5f544547 	svcpl	0x00544547
    1e6c:	5f555043 	svcpl	0x00555043
    1e70:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e74:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1e78:	6d726100 	ldfvse	f6, [r2, #-0]
    1e7c:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1e80:	6f635f64 	svcvs	0x00635f64
    1e84:	41006564 	tstmi	r0, r4, ror #10
    1e88:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1e8c:	415f5343 	cmpmi	pc, r3, asr #6
    1e90:	53435041 	movtpl	r5, #12353	; 0x3041
    1e94:	61736900 	cmnvs	r3, r0, lsl #18
    1e98:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e9c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ea0:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1ea4:	53414200 	movtpl	r4, #4608	; 0x1200
    1ea8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1eac:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1eb0:	4154004d 	cmpmi	r4, sp, asr #32
    1eb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1eb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ebc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ec0:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1ec4:	6d726100 	ldfvse	f6, [r2, #-0]
    1ec8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ecc:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1ed0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ed4:	73690032 	cmnvc	r9, #50	; 0x32
    1ed8:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1edc:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ee0:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1ee4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ee8:	50435f54 	subpl	r5, r3, r4, asr pc
    1eec:	6f635f55 	svcvs	0x00635f55
    1ef0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ef4:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1ef8:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1efc:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1f00:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1f04:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1f08:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f0c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f10:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 19c8 <shift+0x19c8>
    1f14:	6f6e7978 	svcvs	0x006e7978
    1f18:	00316d73 	eorseq	r6, r1, r3, ror sp
    1f1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f24:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f28:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f2c:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    1f30:	61736900 	cmnvs	r3, r0, lsl #18
    1f34:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f38:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1f3c:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1f40:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1f44:	6f656e5f 	svcvs	0x00656e5f
    1f48:	6f665f6e 	svcvs	0x00665f6e
    1f4c:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    1f50:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f54:	61736900 	cmnvs	r3, r0, lsl #18
    1f58:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f5c:	3170665f 	cmncc	r0, pc, asr r6
    1f60:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1f64:	52415400 	subpl	r5, r1, #0, 8
    1f68:	5f544547 	svcpl	0x00544547
    1f6c:	5f555043 	svcpl	0x00555043
    1f70:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f74:	33617865 	cmncc	r1, #6619136	; 0x650000
    1f78:	41540032 	cmpmi	r4, r2, lsr r0
    1f7c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f80:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f84:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f88:	61786574 	cmnvs	r8, r4, ror r5
    1f8c:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1f90:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f94:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f98:	63363170 	teqvs	r6, #112, 2
    1f9c:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1fa0:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1fa4:	5f766365 	svcpl	0x00766365
    1fa8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1fac:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1fb0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fb4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fb8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fbc:	31316d72 	teqcc	r1, r2, ror sp
    1fc0:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1fc4:	41540073 	cmpmi	r4, r3, ror r0
    1fc8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fcc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fd0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1fd4:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1fd8:	52415400 	subpl	r5, r1, #0, 8
    1fdc:	5f544547 	svcpl	0x00544547
    1fe0:	5f555043 	svcpl	0x00555043
    1fe4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1fe8:	6a653632 	bvs	194f8b8 <__bss_end+0x1945da8>
    1fec:	41420073 	hvcmi	8195	; 0x2003
    1ff0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1ff4:	5f484352 	svcpl	0x00484352
    1ff8:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    1ffc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2000:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2004:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    2008:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    200c:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    2010:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2014:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    2018:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    201c:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    2020:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2024:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2028:	41420062 	cmpmi	r2, r2, rrx
    202c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2030:	5f484352 	svcpl	0x00484352
    2034:	00455435 	subeq	r5, r5, r5, lsr r4
    2038:	5f617369 	svcpl	0x00617369
    203c:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    2040:	00657275 	rsbeq	r7, r5, r5, ror r2
    2044:	5f617369 	svcpl	0x00617369
    2048:	5f746962 	svcpl	0x00746962
    204c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2050:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2054:	6d726100 	ldfvse	f6, [r2, #-0]
    2058:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    205c:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 10fd <shift+0x10fd>
    2060:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    2064:	6a626f5f 	bvs	189dde8 <__bss_end+0x18942d8>
    2068:	5f746365 	svcpl	0x00746365
    206c:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    2070:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    2074:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2078:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    207c:	5f617369 	svcpl	0x00617369
    2080:	5f746962 	svcpl	0x00746962
    2084:	645f7066 	ldrbvs	r7, [pc], #-102	; 208c <shift+0x208c>
    2088:	41003233 	tstmi	r0, r3, lsr r2
    208c:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    2090:	73690045 	cmnvc	r9, #69	; 0x45
    2094:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2098:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    209c:	41540038 	cmpmi	r4, r8, lsr r0
    20a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20ac:	36373131 			; <UNDEFINED> instruction: 0x36373131
    20b0:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    20b4:	636f7270 	cmnvs	pc, #112, 4
    20b8:	6f737365 	svcvs	0x00737365
    20bc:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    20c0:	61006570 	tstvs	r0, r0, ror r5
    20c4:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    20c8:	00737570 	rsbseq	r7, r3, r0, ror r5
    20cc:	5f6d7261 	svcpl	0x006d7261
    20d0:	00736370 	rsbseq	r6, r3, r0, ror r3
    20d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20dc:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    20e0:	6d726100 	ldfvse	f6, [r2, #-0]
    20e4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20e8:	00743468 	rsbseq	r3, r4, r8, ror #8
    20ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20f4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20f8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20fc:	36376178 			; <UNDEFINED> instruction: 0x36376178
    2100:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2104:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2108:	72610035 	rsbvc	r0, r1, #53	; 0x35
    210c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2110:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    2114:	00667562 	rsbeq	r7, r6, r2, ror #10
    2118:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    211c:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    2120:	73690068 	cmnvc	r9, #104	; 0x68
    2124:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2128:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    212c:	5f6b7269 	svcpl	0x006b7269
    2130:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2134:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2138:	5f656c69 	svcpl	0x00656c69
    213c:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    2140:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2144:	50435f54 	subpl	r5, r3, r4, asr pc
    2148:	6f635f55 	svcvs	0x00635f55
    214c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2150:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    2154:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2158:	50435f54 	subpl	r5, r3, r4, asr pc
    215c:	6f635f55 	svcvs	0x00635f55
    2160:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2164:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    2168:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    216c:	50435f54 	subpl	r5, r3, r4, asr pc
    2170:	6f635f55 	svcvs	0x00635f55
    2174:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2178:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    217c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2180:	615f7469 	cmpvs	pc, r9, ror #8
    2184:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2188:	6100315f 	tstvs	r0, pc, asr r1
    218c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2190:	5f686372 	svcpl	0x00686372
    2194:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    2198:	61736900 	cmnvs	r3, r0, lsl #18
    219c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21a4:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    21a8:	61736900 	cmnvs	r3, r0, lsl #18
    21ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21b4:	345f3876 	ldrbcc	r3, [pc], #-2166	; 21bc <shift+0x21bc>
    21b8:	61736900 	cmnvs	r3, r0, lsl #18
    21bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21c4:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 1956 <shift+0x1956>
    21c8:	52415400 	subpl	r5, r1, #0, 8
    21cc:	5f544547 	svcpl	0x00544547
    21d0:	5f555043 	svcpl	0x00555043
    21d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21d8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    21dc:	41540033 	cmpmi	r4, r3, lsr r0
    21e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21e8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    21ec:	61786574 	cmnvs	r8, r4, ror r5
    21f0:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    21f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21f8:	50435f54 	subpl	r5, r3, r4, asr pc
    21fc:	6f635f55 	svcvs	0x00635f55
    2200:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2204:	00373561 	eorseq	r3, r7, r1, ror #10
    2208:	47524154 			; <UNDEFINED> instruction: 0x47524154
    220c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2210:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20d8 <shift+0x20d8>
    2214:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2218:	41540065 	cmpmi	r4, r5, rrx
    221c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2220:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2224:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2228:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    222c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2230:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2234:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2238:	006d746f 	rsbeq	r7, sp, pc, ror #8
    223c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2240:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2244:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2248:	30316d72 	eorscc	r6, r1, r2, ror sp
    224c:	6a653632 	bvs	194fb1c <__bss_end+0x194600c>
    2250:	41420073 	hvcmi	8195	; 0x2003
    2254:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2258:	5f484352 	svcpl	0x00484352
    225c:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    2260:	5f455341 	svcpl	0x00455341
    2264:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2268:	004b365f 	subeq	r3, fp, pc, asr r6
    226c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2270:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2274:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    2278:	61736900 	cmnvs	r3, r0, lsl #18
    227c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2280:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2284:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2288:	47524154 			; <UNDEFINED> instruction: 0x47524154
    228c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2290:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2294:	31316d72 	teqcc	r1, r2, ror sp
    2298:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    229c:	52410073 	subpl	r0, r1, #115	; 0x73
    22a0:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    22a4:	4d524100 	ldfmie	f4, [r2, #-0]
    22a8:	00544c5f 	subseq	r4, r4, pc, asr ip
    22ac:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    22b0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    22b4:	5a365f48 	bpl	d99fdc <__bss_end+0xd904cc>
    22b8:	52415400 	subpl	r5, r1, #0, 8
    22bc:	5f544547 	svcpl	0x00544547
    22c0:	5f555043 	svcpl	0x00555043
    22c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22c8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22cc:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    22d0:	61786574 	cmnvs	r8, r4, ror r5
    22d4:	41003535 	tstmi	r0, r5, lsr r5
    22d8:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    22dc:	415f5343 	cmpmi	pc, r3, asr #6
    22e0:	53435041 	movtpl	r5, #12353	; 0x3041
    22e4:	5046565f 	subpl	r5, r6, pc, asr r6
    22e8:	52415400 	subpl	r5, r1, #0, 8
    22ec:	5f544547 	svcpl	0x00544547
    22f0:	5f555043 	svcpl	0x00555043
    22f4:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    22f8:	00327478 	eorseq	r7, r2, r8, ror r4
    22fc:	5f617369 	svcpl	0x00617369
    2300:	5f746962 	svcpl	0x00746962
    2304:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    2308:	6d726100 	ldfvse	f6, [r2, #-0]
    230c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2310:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2314:	73690072 	cmnvc	r9, #114	; 0x72
    2318:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    231c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2320:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    2324:	4154006d 	cmpmi	r4, sp, rrx
    2328:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    232c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2330:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    2334:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    2338:	52415400 	subpl	r5, r1, #0, 8
    233c:	5f544547 	svcpl	0x00544547
    2340:	5f555043 	svcpl	0x00555043
    2344:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    2348:	5f6c6c65 	svcpl	0x006c6c65
    234c:	00346a70 	eorseq	r6, r4, r0, ror sl
    2350:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2354:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    2358:	6f705f68 	svcvs	0x00705f68
    235c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2360:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2364:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2368:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    236c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2370:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2374:	61736900 	cmnvs	r3, r0, lsl #18
    2378:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    237c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2380:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2384:	52415400 	subpl	r5, r1, #0, 8
    2388:	5f544547 	svcpl	0x00544547
    238c:	5f555043 	svcpl	0x00555043
    2390:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2394:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2398:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    239c:	61786574 	cmnvs	r8, r4, ror r5
    23a0:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    23a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23a8:	745f7469 	ldrbvc	r7, [pc], #-1129	; 23b0 <shift+0x23b0>
    23ac:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    23b0:	41420032 	cmpmi	r2, r2, lsr r0
    23b4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    23b8:	5f484352 	svcpl	0x00484352
    23bc:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    23c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23c4:	645f7469 	ldrbvs	r7, [pc], #-1129	; 23cc <shift+0x23cc>
    23c8:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    23cc:	6100646f 	tstvs	r0, pc, ror #8
    23d0:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    23d4:	5f363170 	svcpl	0x00363170
    23d8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23dc:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 23e4 <shift+0x23e4>
    23e0:	52410065 	subpl	r0, r1, #101	; 0x65
    23e4:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    23e8:	6d726100 	ldfvse	f6, [r2, #-0]
    23ec:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23f0:	006b3668 	rsbeq	r3, fp, r8, ror #12
    23f4:	5f6d7261 	svcpl	0x006d7261
    23f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    23fc:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    2400:	5f455341 	svcpl	0x00455341
    2404:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2408:	0052375f 	subseq	r3, r2, pc, asr r7
    240c:	6f705f5f 	svcvs	0x00705f5f
    2410:	756f6370 	strbvc	r6, [pc, #-880]!	; 20a8 <shift+0x20a8>
    2414:	745f746e 	ldrbvc	r7, [pc], #-1134	; 241c <shift+0x241c>
    2418:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    241c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2420:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2424:	0065736d 	rsbeq	r7, r5, sp, ror #6
    2428:	47524154 			; <UNDEFINED> instruction: 0x47524154
    242c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2430:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2434:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2438:	33376178 	teqcc	r7, #120, 2
    243c:	52415400 	subpl	r5, r1, #0, 8
    2440:	5f544547 	svcpl	0x00544547
    2444:	5f555043 	svcpl	0x00555043
    2448:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    244c:	76636972 			; <UNDEFINED> instruction: 0x76636972
    2450:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    2454:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2458:	50435f54 	subpl	r5, r3, r4, asr pc
    245c:	6f635f55 	svcvs	0x00635f55
    2460:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2464:	00363761 	eorseq	r3, r6, r1, ror #14
    2468:	5f6d7261 	svcpl	0x006d7261
    246c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2470:	5f6f6e5f 	svcpl	0x006f6e5f
    2474:	616c6f76 	smcvs	50934	; 0xc6f6
    2478:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    247c:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2480:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2484:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2488:	41385f48 	teqmi	r8, r8, asr #30
    248c:	61736900 	cmnvs	r3, r0, lsl #18
    2490:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2494:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2498:	00743576 	rsbseq	r3, r4, r6, ror r5
    249c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    24a0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    24a4:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    24a8:	52415400 	subpl	r5, r1, #0, 8
    24ac:	5f544547 	svcpl	0x00544547
    24b0:	5f555043 	svcpl	0x00555043
    24b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24b8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    24bc:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    24c0:	61786574 	cmnvs	r8, r4, ror r5
    24c4:	41003533 	tstmi	r0, r3, lsr r5
    24c8:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    24cc:	72610056 	rsbvc	r0, r1, #86	; 0x56
    24d0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24d4:	00346863 	eorseq	r6, r4, r3, ror #16
    24d8:	5f6d7261 	svcpl	0x006d7261
    24dc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24e0:	72610036 	rsbvc	r0, r1, #54	; 0x36
    24e4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24e8:	00376863 	eorseq	r6, r7, r3, ror #16
    24ec:	5f6d7261 	svcpl	0x006d7261
    24f0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24f4:	6f6c0038 	svcvs	0x006c0038
    24f8:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    24fc:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    2500:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2504:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2508:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    250c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    2510:	616d0065 	cmnvs	sp, r5, rrx
    2514:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    2518:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    251c:	745f7473 	ldrbvc	r7, [pc], #-1139	; 2524 <shift+0x2524>
    2520:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    2524:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    2528:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    252c:	5f6c6c61 	svcpl	0x006c6c61
    2530:	5f616976 	svcpl	0x00616976
    2534:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    2538:	7369006c 	cmnvc	r9, #108	; 0x6c
    253c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2540:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2544:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2548:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    254c:	615f7469 	cmpvs	pc, r9, ror #8
    2550:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2554:	4154006b 	cmpmi	r4, fp, rrx
    2558:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    255c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2560:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2564:	61786574 	cmnvs	r8, r4, ror r5
    2568:	41540037 	cmpmi	r4, r7, lsr r0
    256c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2570:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2574:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2578:	61786574 	cmnvs	r8, r4, ror r5
    257c:	41540038 	cmpmi	r4, r8, lsr r0
    2580:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2584:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2588:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    258c:	61786574 	cmnvs	r8, r4, ror r5
    2590:	52410039 	subpl	r0, r1, #57	; 0x39
    2594:	43505f4d 	cmpmi	r0, #308	; 0x134
    2598:	50415f53 	subpl	r5, r1, r3, asr pc
    259c:	41005343 	tstmi	r0, r3, asr #6
    25a0:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    25a4:	415f5343 	cmpmi	pc, r3, asr #6
    25a8:	53435054 	movtpl	r5, #12372	; 0x3054
    25ac:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 25b4 <shift+0x25b4>
    25b0:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    25b4:	756f6420 	strbvc	r6, [pc, #-1056]!	; 219c <shift+0x219c>
    25b8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    25bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25c4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25c8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25cc:	33376178 	teqcc	r7, #120, 2
    25d0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25d4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25d8:	41540033 	cmpmi	r4, r3, lsr r0
    25dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25e4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25e8:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    25ec:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    25f0:	72610073 	rsbvc	r0, r1, #115	; 0x73
    25f4:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    25f8:	61736900 	cmnvs	r3, r0, lsl #18
    25fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2600:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    2604:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2608:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    260c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    2610:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    2614:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    2618:	5f657265 	svcpl	0x00657265
    261c:	52415400 	subpl	r5, r1, #0, 8
    2620:	5f544547 	svcpl	0x00544547
    2624:	5f555043 	svcpl	0x00555043
    2628:	316d7261 	cmncc	sp, r1, ror #4
    262c:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    2630:	41540069 	cmpmi	r4, r9, rrx
    2634:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2638:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    263c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2640:	61786574 	cmnvs	r8, r4, ror r5
    2644:	61620035 	cmnvs	r2, r5, lsr r0
    2648:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    264c:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2650:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2654:	00657275 	rsbeq	r7, r5, r5, ror r2
    2658:	5f6d7261 	svcpl	0x006d7261
    265c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2660:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2664:	52415400 	subpl	r5, r1, #0, 8
    2668:	5f544547 	svcpl	0x00544547
    266c:	5f555043 	svcpl	0x00555043
    2670:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2674:	316d7865 	cmncc	sp, r5, ror #16
    2678:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    267c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2680:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2684:	72610079 	rsbvc	r0, r1, #121	; 0x79
    2688:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    268c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    2690:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    2694:	61736900 	cmnvs	r3, r0, lsl #18
    2698:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    269c:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    26a0:	41003233 	tstmi	r0, r3, lsr r2
    26a4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    26a8:	7369004c 	cmnvc	r9, #76	; 0x4c
    26ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26b0:	66765f74 	uhsub16vs	r5, r6, r4
    26b4:	00337670 	eorseq	r7, r3, r0, ror r6
    26b8:	5f617369 	svcpl	0x00617369
    26bc:	5f746962 	svcpl	0x00746962
    26c0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26c4:	41420034 	cmpmi	r2, r4, lsr r0
    26c8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26cc:	5f484352 	svcpl	0x00484352
    26d0:	00325436 	eorseq	r5, r2, r6, lsr r4
    26d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26dc:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    26e0:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    26e4:	4154004e 	cmpmi	r4, lr, asr #32
    26e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    26f4:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    26f8:	52410069 	subpl	r0, r1, #105	; 0x69
    26fc:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    2700:	53414200 	movtpl	r4, #4608	; 0x1200
    2704:	52415f45 	subpl	r5, r1, #276	; 0x114
    2708:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    270c:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    2710:	61745f6d 	cmnvs	r4, sp, ror #30
    2714:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    2718:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    271c:	61006c65 	tstvs	r0, r5, ror #24
    2720:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2728 <shift+0x2728>
    2724:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2728:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    272c:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    2730:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2734:	50435f54 	subpl	r5, r3, r4, asr pc
    2738:	6f635f55 	svcvs	0x00635f55
    273c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2740:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    2744:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2748:	50435f54 	subpl	r5, r3, r4, asr pc
    274c:	6f635f55 	svcvs	0x00635f55
    2750:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2754:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    2758:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    275c:	50435f54 	subpl	r5, r3, r4, asr pc
    2760:	6f635f55 	svcvs	0x00635f55
    2764:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2768:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    276c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2770:	50435f54 	subpl	r5, r3, r4, asr pc
    2774:	6f635f55 	svcvs	0x00635f55
    2778:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    277c:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2780:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2784:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2788:	00656170 	rsbeq	r6, r5, r0, ror r1
    278c:	5f617369 	svcpl	0x00617369
    2790:	5f746962 	svcpl	0x00746962
    2794:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2798:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    279c:	6b36766d 	blvs	da0158 <__bss_end+0xd96648>
    27a0:	7369007a 	cmnvc	r9, #122	; 0x7a
    27a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    27a8:	6f6e5f74 	svcvs	0x006e5f74
    27ac:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    27b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27b4:	615f7469 	cmpvs	pc, r9, ror #8
    27b8:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    27bc:	61736900 	cmnvs	r3, r0, lsl #18
    27c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27c8:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    27cc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27d0:	615f7469 	cmpvs	pc, r9, ror #8
    27d4:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    27d8:	61736900 	cmnvs	r3, r0, lsl #18
    27dc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27e0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27e4:	5f003876 	svcpl	0x00003876
    27e8:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    27ec:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    27f0:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    27f4:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    27f8:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    27fc:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    2800:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    2804:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2808:	615f7469 	cmpvs	pc, r9, ror #8
    280c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    2810:	61006574 	tstvs	r0, r4, ror r5
    2814:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 281c <shift+0x281c>
    2818:	00656e75 	rsbeq	r6, r5, r5, ror lr
    281c:	5f6d7261 	svcpl	0x006d7261
    2820:	5f707063 	svcpl	0x00707063
    2824:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2828:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    282c:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    2830:	705f636e 	subsvc	r6, pc, lr, ror #6
    2834:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    2838:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    283c:	50435f54 	subpl	r5, r3, r4, asr pc
    2840:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2844:	3032396d 	eorscc	r3, r2, sp, ror #18
    2848:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    284c:	655f6261 	ldrbvs	r6, [pc, #-609]	; 25f3 <shift+0x25f3>
    2850:	41540071 	cmpmi	r4, r1, ror r0
    2854:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2858:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    285c:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    2860:	61003632 	tstvs	r0, r2, lsr r6
    2864:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2868:	5f686372 	svcpl	0x00686372
    286c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2870:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2874:	00766964 	rsbseq	r6, r6, r4, ror #18
    2878:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    287c:	5f71655f 	svcpl	0x0071655f
    2880:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2884:	00726574 	rsbseq	r6, r2, r4, ror r5
    2888:	5f6d7261 	svcpl	0x006d7261
    288c:	5f636970 	svcpl	0x00636970
    2890:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2894:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2898:	52415400 	subpl	r5, r1, #0, 8
    289c:	5f544547 	svcpl	0x00544547
    28a0:	5f555043 	svcpl	0x00555043
    28a4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    28a8:	306d7865 	rsbcc	r7, sp, r5, ror #16
    28ac:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    28b0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    28b4:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    28b8:	41540079 	cmpmi	r4, r9, ror r0
    28bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28c4:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    28c8:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    28cc:	7066766f 	rsbvc	r7, r6, pc, ror #12
    28d0:	61736900 	cmnvs	r3, r0, lsl #18
    28d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    28d8:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    28dc:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    28e0:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    28e4:	00647264 	rsbeq	r7, r4, r4, ror #4
    28e8:	5f4d5241 	svcpl	0x004d5241
    28ec:	61004343 	tstvs	r0, r3, asr #6
    28f0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    28f4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    28f8:	6100325f 	tstvs	r0, pc, asr r2
    28fc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2900:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2904:	6100335f 	tstvs	r0, pc, asr r3
    2908:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    290c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2910:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    2914:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2918:	50435f54 	subpl	r5, r3, r4, asr pc
    291c:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    2920:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2924:	4d524100 	ldfmie	f4, [r2, #-0]
    2928:	0053435f 	subseq	r4, r3, pc, asr r3
    292c:	5f6d7261 	svcpl	0x006d7261
    2930:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2934:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2938:	72610074 	rsbvc	r0, r1, #116	; 0x74
    293c:	61625f6d 	cmnvs	r2, sp, ror #30
    2940:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2944:	00686372 	rsbeq	r6, r8, r2, ror r3
    2948:	47524154 			; <UNDEFINED> instruction: 0x47524154
    294c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2950:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2954:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2958:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    295c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2960:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2964:	6d726100 	ldfvse	f6, [r2, #-0]
    2968:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    296c:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2970:	52415400 	subpl	r5, r1, #0, 8
    2974:	5f544547 	svcpl	0x00544547
    2978:	5f555043 	svcpl	0x00555043
    297c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2980:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2984:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2988:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    298c:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2990:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    2994:	52410074 	subpl	r0, r1, #116	; 0x74
    2998:	43505f4d 	cmpmi	r0, #308	; 0x134
    299c:	41415f53 	cmpmi	r1, r3, asr pc
    29a0:	5f534350 	svcpl	0x00534350
    29a4:	41434f4c 	cmpmi	r3, ip, asr #30
    29a8:	4154004c 	cmpmi	r4, ip, asr #32
    29ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29b4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    29b8:	61786574 	cmnvs	r8, r4, ror r5
    29bc:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    29c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    29c4:	50435f54 	subpl	r5, r3, r4, asr pc
    29c8:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    29cc:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    29d0:	006d7261 	rsbeq	r7, sp, r1, ror #4
    29d4:	5f6d7261 	svcpl	0x006d7261
    29d8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29dc:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29e0:	0031626d 	eorseq	r6, r1, sp, ror #4
    29e4:	5f6d7261 	svcpl	0x006d7261
    29e8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29ec:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29f0:	0032626d 	eorseq	r6, r2, sp, ror #4
    29f4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29f8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29fc:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2a00:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2a04:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2a08:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a0c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    2a10:	61736900 	cmnvs	r3, r0, lsl #18
    2a14:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a18:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2a1c:	5f6d7261 	svcpl	0x006d7261
    2a20:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2a24:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    2a28:	6d726100 	ldfvse	f6, [r2, #-0]
    2a2c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2a30:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9e20>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346d20>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9e40>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9170>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9e70>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346d70>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9e90>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346d90>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9eb0>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346db0>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9ed0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346dd0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9ef0>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346df0>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9f10>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346e10>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9f30>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346e30>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9f48>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9f68>
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
 194:	00000194 	muleq	r0, r4, r1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9f98>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000083c0 	andeq	r8, r0, r0, asr #7
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9fc4>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346ec4>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083ec 	andeq	r8, r0, ip, ror #7
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9fe4>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346ee4>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008418 	andeq	r8, r0, r8, lsl r4
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa004>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346f04>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008434 	andeq	r8, r0, r4, lsr r4
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa024>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346f24>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008478 	andeq	r8, r0, r8, ror r4
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa044>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346f44>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084c8 	andeq	r8, r0, r8, asr #9
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa064>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346f64>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008518 	andeq	r8, r0, r8, lsl r5
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa084>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346f84>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008544 	andeq	r8, r0, r4, asr #10
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa0a4>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346fa4>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008594 	muleq	r0, r4, r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa0c4>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346fc4>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa0e4>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346fe4>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008628 	andeq	r8, r0, r8, lsr #12
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa104>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347004>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	0000867c 	andeq	r8, r0, ip, ror r6
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa124>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347024>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086b8 			; <UNDEFINED> instruction: 0x000086b8
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa144>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347044>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000086f4 	strdeq	r8, [r0], -r4
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa164>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347064>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008730 	andeq	r8, r0, r0, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa184>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347084>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	0000876c 	andeq	r8, r0, ip, ror #14
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa1a4>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	0000881c 	andeq	r8, r0, ip, lsl r8
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa1d4>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008990 	muleq	r0, r0, r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa1f4>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3470f4>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a2c 	andeq	r8, r0, ip, lsr #20
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa214>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347114>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008aec 	andeq	r8, r0, ip, ror #21
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa234>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347134>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b98 	muleq	r0, r8, fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa254>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347154>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008bec 	andeq	r8, r0, ip, ror #23
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa274>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347174>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008c54 	andeq	r8, r0, r4, asr ip
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa294>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347194>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008cd4 	ldrdeq	r8, [r0], -r4
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa2b4>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x3471b4>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008d40 	andeq	r8, r0, r0, asr #26
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa2d4>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008e04 	andeq	r8, r0, r4, lsl #28
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa2f4>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x3471f4>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	00009244 	andeq	r9, r0, r4, asr #4
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa318>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009318 	andeq	r9, r0, r8, lsl r3
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa338>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x347238>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	00009354 	andeq	r9, r0, r4, asr r3
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa358>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x347258>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	00009394 	muleq	r0, r4, r3
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa378>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	000093c4 	andeq	r9, r0, r4, asr #7
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa398>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	000096e8 	andeq	r9, r0, r8, ror #13
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa3bc>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x3472bc>
 5c4:	0d0d7c02 	stceq	12, cr7, [sp, #-8]
 5c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 5cc:	0000000c 	andeq	r0, r0, ip
 5d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5d4:	7c010001 	stcvc	0, cr0, [r1], {1}
 5d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5dc:	0000000c 	andeq	r0, r0, ip
 5e0:	000005cc 	andeq	r0, r0, ip, asr #11
 5e4:	000097f8 	strdeq	r9, [r0], -r8
 5e8:	000001ec 	andeq	r0, r0, ip, ror #3
