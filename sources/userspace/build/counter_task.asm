
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
    805c:	00009ae0 	andeq	r9, r0, r0, ror #21
    8060:	00009af0 	strdeq	r9, [r0], -r0

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
    81cc:	00009add 	ldrdeq	r9, [r0], -sp
    81d0:	00009add 	ldrdeq	r9, [r0], -sp

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
    8224:	00009add 	ldrdeq	r9, [r0], -sp
    8228:	00009add 	ldrdeq	r9, [r0], -sp

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
    83b0:	00009a68 	andeq	r9, r0, r8, ror #20
    83b4:	00009a74 	andeq	r9, r0, r4, ror sl
    83b8:	00009a80 	andeq	r9, r0, r0, lsl #21
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
    8818:	00009abc 			; <UNDEFINED> instruction: 0x00009abc

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
    898c:	00009acc 	andeq	r9, r0, ip, asr #21

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
    9200:	0a4fb11f 	beq	13f5684 <__bss_end+0x13ebb94>
    9204:	5a0e1bca 	bpl	390134 <__bss_end+0x386644>
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
    9238:	3a83126f 	bcc	fe0cdbfc <__bss_end+0xfe0c410c>
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

00009a0c <_ZL13Lock_Unlocked>:
    9a0c:	00000000 	andeq	r0, r0, r0

00009a10 <_ZL11Lock_Locked>:
    9a10:	00000001 	andeq	r0, r0, r1

00009a14 <_ZL21MaxFSDriverNameLength>:
    9a14:	00000010 	andeq	r0, r0, r0, lsl r0

00009a18 <_ZL17MaxFilenameLength>:
    9a18:	00000010 	andeq	r0, r0, r0, lsl r0

00009a1c <_ZL13MaxPathLength>:
    9a1c:	00000080 	andeq	r0, r0, r0, lsl #1

00009a20 <_ZL18NoFilesystemDriver>:
    9a20:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a24 <_ZL9NotifyAll>:
    9a24:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a28 <_ZL24Max_Process_Opened_Files>:
    9a28:	00000010 	andeq	r0, r0, r0, lsl r0

00009a2c <_ZL10Indefinite>:
    9a2c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a30 <_ZL18Deadline_Unchanged>:
    9a30:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009a34 <_ZL14Invalid_Handle>:
    9a34:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009a38 <_ZN3halL18Default_Clock_RateE>:
    9a38:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00009a3c <_ZN3halL15Peripheral_BaseE>:
    9a3c:	20000000 	andcs	r0, r0, r0

00009a40 <_ZN3halL9GPIO_BaseE>:
    9a40:	20200000 	eorcs	r0, r0, r0

00009a44 <_ZN3halL14GPIO_Pin_CountE>:
    9a44:	00000036 	andeq	r0, r0, r6, lsr r0

00009a48 <_ZN3halL8AUX_BaseE>:
    9a48:	20215000 	eorcs	r5, r1, r0

00009a4c <_ZN3halL25Interrupt_Controller_BaseE>:
    9a4c:	2000b200 	andcs	fp, r0, r0, lsl #4

00009a50 <_ZN3halL10Timer_BaseE>:
    9a50:	2000b400 	andcs	fp, r0, r0, lsl #8

00009a54 <_ZN3halL9TRNG_BaseE>:
    9a54:	20104000 	andscs	r4, r0, r0

00009a58 <_ZN3halL9BSC0_BaseE>:
    9a58:	20205000 	eorcs	r5, r0, r0

00009a5c <_ZN3halL9BSC1_BaseE>:
    9a5c:	20804000 	addcs	r4, r0, r0

00009a60 <_ZN3halL9BSC2_BaseE>:
    9a60:	20805000 	addcs	r5, r0, r0

00009a64 <_ZL11Invalid_Pin>:
    9a64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9a68:	3a564544 	bcc	159af80 <__bss_end+0x1591490>
    9a6c:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    9a70:	00000000 	andeq	r0, r0, r0
    9a74:	3a564544 	bcc	159af8c <__bss_end+0x159149c>
    9a78:	6f697067 	svcvs	0x00697067
    9a7c:	0000342f 	andeq	r3, r0, pc, lsr #8
    9a80:	3a564544 	bcc	159af98 <__bss_end+0x15914a8>
    9a84:	6f697067 	svcvs	0x00697067
    9a88:	0037312f 	eorseq	r3, r7, pc, lsr #2

00009a8c <_ZL13Lock_Unlocked>:
    9a8c:	00000000 	andeq	r0, r0, r0

00009a90 <_ZL11Lock_Locked>:
    9a90:	00000001 	andeq	r0, r0, r1

00009a94 <_ZL21MaxFSDriverNameLength>:
    9a94:	00000010 	andeq	r0, r0, r0, lsl r0

00009a98 <_ZL17MaxFilenameLength>:
    9a98:	00000010 	andeq	r0, r0, r0, lsl r0

00009a9c <_ZL13MaxPathLength>:
    9a9c:	00000080 	andeq	r0, r0, r0, lsl #1

00009aa0 <_ZL18NoFilesystemDriver>:
    9aa0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009aa4 <_ZL9NotifyAll>:
    9aa4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009aa8 <_ZL24Max_Process_Opened_Files>:
    9aa8:	00000010 	andeq	r0, r0, r0, lsl r0

00009aac <_ZL10Indefinite>:
    9aac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ab0 <_ZL18Deadline_Unchanged>:
    9ab0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009ab4 <_ZL14Invalid_Handle>:
    9ab4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009ab8 <_ZL8INFINITY>:
    9ab8:	7f7fffff 	svcvc	0x007fffff

00009abc <_ZL16Pipe_File_Prefix>:
    9abc:	3a535953 	bcc	14e0010 <__bss_end+0x14d6520>
    9ac0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9ac4:	0000002f 	andeq	r0, r0, pc, lsr #32

00009ac8 <_ZL8INFINITY>:
    9ac8:	7f7fffff 	svcvc	0x007fffff

00009acc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9acc:	33323130 	teqcc	r2, #48, 2
    9ad0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9ad4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9ad8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009ae0 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683d3c>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38934>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c548>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7234>
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
  80:	6a2f656d 	bvs	bd963c <__bss_end+0xbcfb4c>
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
  fc:	fb010200 	blx	40906 <__bss_end+0x36e16>
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
 12c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffdcf <__bss_end+0xffff62df>
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
 164:	0a05830b 	beq	160d98 <__bss_end+0x1572a8>
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
 190:	4a030402 	bmi	c11a0 <__bss_end+0xb76b0>
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
 1c4:	4a020402 	bmi	811d4 <__bss_end+0x776e4>
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
 1f8:	6a2f656d 	bvs	bd97b4 <__bss_end+0xbcfcc4>
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
 228:	6b736174 	blvs	1cd8800 <__bss_end+0x1cced10>
 22c:	6f682f00 	svcvs	0x00682f00
 230:	6a2f656d 	bvs	bd97ec <__bss_end+0xbcfcfc>
 234:	73656d61 	cmnvc	r5, #6208	; 0x1840
 238:	2f697261 	svccs	0x00697261
 23c:	2f746967 	svccs	0x00746967
 240:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 244:	6f732f70 	svcvs	0x00732f70
 248:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 24c:	73752f73 	cmnvc	r5, #460	; 0x1cc
 250:	70737265 	rsbsvc	r7, r3, r5, ror #4
 254:	2f656361 	svccs	0x00656361
 258:	6b2f2e2e 	blvs	bcbb18 <__bss_end+0xbc2028>
 25c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 260:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 264:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 268:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 26c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 270:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 274:	2f656d6f 	svccs	0x00656d6f
 278:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 27c:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 280:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 284:	2f736f2f 	svccs	0x00736f2f
 288:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 28c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 290:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff33 <__bss_end+0xffff6443>
 294:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 298:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 29c:	2f2e2e2f 	svccs	0x002e2e2f
 2a0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2a4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2a8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2ac:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 2b0:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 2b4:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 2b8:	61682f30 	cmnvs	r8, r0, lsr pc
 2bc:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 2c0:	2f656d6f 	svccs	0x00656d6f
 2c4:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 2c8:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 2cc:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 2d0:	2f736f2f 	svccs	0x00736f2f
 2d4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2dc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7f <__bss_end+0xffff648f>
 2e0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2e4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2e8:	2f2e2e2f 	svccs	0x002e2e2f
 2ec:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 2f0:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
 2f4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2f8:	2f006564 	svccs	0x00006564
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
 38c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 390:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 394:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 398:	66656474 			; <UNDEFINED> instruction: 0x66656474
 39c:	0300682e 	movweq	r6, #2094	; 0x82e
 3a0:	70730000 	rsbsvc	r0, r3, r0
 3a4:	6f6c6e69 	svcvs	0x006c6e69
 3a8:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3ac:	00000200 	andeq	r0, r0, r0, lsl #4
 3b0:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 3b4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 3b8:	00682e67 	rsbeq	r2, r8, r7, ror #28
 3bc:	66000004 	strvs	r0, [r0], -r4
 3c0:	73656c69 	cmnvc	r5, #26880	; 0x6900
 3c4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 3c8:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 3cc:	70000005 	andvc	r0, r0, r5
 3d0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3d4:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 3d8:	00000200 	andeq	r0, r0, r0, lsl #4
 3dc:	636f7270 	cmnvs	pc, #112, 4
 3e0:	5f737365 	svcpl	0x00737365
 3e4:	616e616d 	cmnvs	lr, sp, ror #2
 3e8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 3ec:	00020068 	andeq	r0, r2, r8, rrx
 3f0:	72657000 	rsbvc	r7, r5, #0
 3f4:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
 3f8:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
 3fc:	0300682e 	movweq	r6, #2094	; 0x82e
 400:	70670000 	rsbvc	r0, r7, r0
 404:	682e6f69 	stmdavs	lr!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}
 408:	00000600 	andeq	r0, r0, r0, lsl #12
 40c:	00010500 	andeq	r0, r1, r0, lsl #10
 410:	822c0205 	eorhi	r0, ip, #1342177280	; 0x50000000
 414:	10030000 	andne	r0, r3, r0
 418:	9f1e0501 	svcls	0x001e0501
 41c:	0f058383 	svceq	0x00058383
 420:	4b070584 	blmi	1c1a38 <__bss_end+0x1b7f48>
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
 488:	0a026706 	beq	9a0a8 <__bss_end+0x905b8>
 48c:	bf010100 	svclt	0x00010100
 490:	03000002 	movweq	r0, #2
 494:	00018c00 	andeq	r8, r1, r0, lsl #24
 498:	fb010200 	blx	40ca2 <__bss_end+0x371b2>
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
 4f4:	6b2f7365 	blvs	bdd290 <__bss_end+0xbd37a0>
 4f8:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 4fc:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 500:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 504:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 508:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 50c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 510:	2f656d6f 	svccs	0x00656d6f
 514:	656d616a 	strbvs	r6, [sp, #-362]!	; 0xfffffe96
 518:	69726173 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sp, lr}^
 51c:	7469672f 	strbtvc	r6, [r9], #-1839	; 0xfffff8d1
 520:	2f736f2f 	svccs	0x00736f2f
 524:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 528:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 52c:	6b2f7365 	blvs	bdd2c8 <__bss_end+0xbd37d8>
 530:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 534:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 538:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 53c:	73662f65 	cmnvc	r6, #404	; 0x194
 540:	6f682f00 	svcvs	0x00682f00
 544:	6a2f656d 	bvs	bd9b00 <__bss_end+0xbd0010>
 548:	73656d61 	cmnvc	r5, #6208	; 0x1840
 54c:	2f697261 	svccs	0x00697261
 550:	2f746967 	svccs	0x00746967
 554:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 558:	6f732f70 	svcvs	0x00732f70
 55c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 560:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 564:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 568:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 56c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 570:	6f682f00 	svcvs	0x00682f00
 574:	6a2f656d 	bvs	bd9b30 <__bss_end+0xbd0040>
 578:	73656d61 	cmnvc	r5, #6208	; 0x1840
 57c:	2f697261 	svccs	0x00697261
 580:	2f746967 	svccs	0x00746967
 584:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
 588:	6f732f70 	svcvs	0x00732f70
 58c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 590:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 594:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 598:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 59c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 5a0:	616f622f 	cmnvs	pc, pc, lsr #4
 5a4:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 5a8:	2f306970 	svccs	0x00306970
 5ac:	006c6168 	rsbeq	r6, ip, r8, ror #2
 5b0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 5b4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 5bc:	00000100 	andeq	r0, r0, r0, lsl #2
 5c0:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 5c4:	00020068 	andeq	r0, r2, r8, rrx
 5c8:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 5cc:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 5d0:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 5d4:	66000002 	strvs	r0, [r0], -r2
 5d8:	73656c69 	cmnvc	r5, #26880	; 0x6900
 5dc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 5e0:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 5e4:	70000003 	andvc	r0, r0, r3
 5e8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 5ec:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 5f0:	00000200 	andeq	r0, r0, r0, lsl #4
 5f4:	636f7270 	cmnvs	pc, #112, 4
 5f8:	5f737365 	svcpl	0x00737365
 5fc:	616e616d 	cmnvs	lr, sp, ror #2
 600:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 604:	00020068 	andeq	r0, r2, r8, rrx
 608:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 60c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 610:	682e676e 	stmdavs	lr!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 614:	00000400 	andeq	r0, r0, r0, lsl #8
 618:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 61c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 620:	00000500 	andeq	r0, r0, r0, lsl #10
 624:	00010500 	andeq	r0, r1, r0, lsl #10
 628:	83c00205 	bichi	r0, r0, #1342177280	; 0x50000000
 62c:	05160000 	ldreq	r0, [r6, #-0]
 630:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
 634:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 638:	852f0105 	strhi	r0, [pc, #-261]!	; 53b <shift+0x53b>
 63c:	05833205 	streq	r3, [r3, #517]	; 0x205
 640:	01054b1a 	tsteq	r5, sl, lsl fp
 644:	1a05852f 	bne	161b08 <__bss_end+0x158018>
 648:	2f01054b 	svccs	0x0001054b
 64c:	a1320585 	teqge	r2, r5, lsl #11
 650:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 654:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
 658:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 65c:	852f0105 	strhi	r0, [pc, #-261]!	; 55f <shift+0x55f>
 660:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 664:	2e054b30 	vmovcs.16	d5[0], r4
 668:	4b1b054b 	blmi	6c1b9c <__bss_end+0x6b80ac>
 66c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff86f <__bss_end+0xffff5d7f>
 670:	01054c0c 	tsteq	r5, ip, lsl #24
 674:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 678:	4b3005bd 	blmi	c01d74 <__bss_end+0xbf8284>
 67c:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 680:	2e054b1b 	vmovcs.32	d5[0], r4
 684:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 688:	852f0105 	strhi	r0, [pc, #-261]!	; 58b <shift+0x58b>
 68c:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
 690:	01054b1b 	tsteq	r5, fp, lsl fp
 694:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 698:	4b3305bd 	blmi	cc1d94 <__bss_end+0xcb82a4>
 69c:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6a0:	30054b1b 	andcc	r4, r5, fp, lsl fp
 6a4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6a8:	852f0105 	strhi	r0, [pc, #-261]!	; 5ab <shift+0x5ab>
 6ac:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
 6b0:	1b054b2f 	blne	153374 <__bss_end+0x149884>
 6b4:	2f2f054b 	svccs	0x002f054b
 6b8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6bc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c0:	2f05bd2e 	svccs	0x0005bd2e
 6c4:	4b3b054b 	blmi	ec1bf8 <__bss_end+0xeb8108>
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
 6f0:	4b1a054b 	blmi	681c24 <__bss_end+0x678134>
 6f4:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6f8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6fc:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 700:	4b31054d 	blmi	c41c3c <__bss_end+0xc3814c>
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
 770:	6a2f656d 	bvs	bd9d2c <__bss_end+0xbd023c>
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
 79c:	6a2f656d 	bvs	bd9d58 <__bss_end+0xbd0268>
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
 7f4:	bb06051a 	bllt	181c64 <__bss_end+0x178174>
 7f8:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
 7fc:	0a056821 	beq	15a888 <__bss_end+0x150d98>
 800:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
 804:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
 808:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 80c:	9f04052f 	svcls	0x0004052f
 810:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 814:	10053505 	andne	r3, r5, r5, lsl #10
 818:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 81c:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 820:	0a052e13 	beq	14c074 <__bss_end+0x142584>
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
 85c:	1b054b02 	blne	15346c <__bss_end+0x14997c>
 860:	02040200 	andeq	r0, r4, #0, 4
 864:	000c052e 	andeq	r0, ip, lr, lsr #10
 868:	4a020402 	bmi	81878 <__bss_end+0x77d88>
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
 8a8:	0a054a10 	beq	1530f0 <__bss_end+0x149600>
 8ac:	bb07054c 	bllt	1c1de4 <__bss_end+0x1b82f4>
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
 94c:	0b054901 	bleq	152d58 <__bss_end+0x149268>
 950:	2f010585 	svccs	0x00010585
 954:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
 958:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 95c:	0b05bc20 	bleq	16f9e4 <__bss_end+0x165ef4>
 960:	4b1f0566 	blmi	7c1f00 <__bss_end+0x7b8410>
 964:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
 968:	11054b08 	tstne	r5, r8, lsl #22
 96c:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
 970:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
 974:	0b056711 	bleq	15a5c0 <__bss_end+0x150ad0>
 978:	2f01054d 	svccs	0x0001054d
 97c:	83060585 	movwhi	r0, #25989	; 0x6585
 980:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 984:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
 988:	4b040566 	blmi	101f28 <__bss_end+0xf8438>
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
 9b4:	4a020402 	bmi	819c4 <__bss_end+0x77ed4>
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
 9e4:	4a020402 	bmi	819f4 <__bss_end+0x77f04>
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
 ad4:	1a059f09 	bne	168700 <__bss_end+0x15ec10>
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
 b44:	1a059f09 	bne	168770 <__bss_end+0x15ec80>
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
 b80:	0b054a19 	bleq	1533ec <__bss_end+0x1498fc>
 b84:	670f0582 	strvs	r0, [pc, -r2, lsl #11]
 b88:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
 b8c:	12054b19 	andne	r4, r5, #25600	; 0x6400
 b90:	4a11054a 	bmi	4420c0 <__bss_end+0x4385d0>
 b94:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 b98:	820b0301 	andhi	r0, fp, #67108864	; 0x4000000
 b9c:	76030905 	strvc	r0, [r3], -r5, lsl #18
 ba0:	4a10052e 	bmi	402060 <__bss_end+0x3f8570>
 ba4:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
 ba8:	15054a09 	strne	r4, [r5, #-2569]	; 0xfffff5f7
 bac:	670d0567 	strvs	r0, [sp, -r7, ror #10]
 bb0:	054a1505 	strbeq	r1, [sl, #-1285]	; 0xfffffafb
 bb4:	0d056710 	stceq	7, cr6, [r5, #-64]	; 0xffffffc0
 bb8:	4b1a054a 	blmi	6820e8 <__bss_end+0x6785f8>
 bbc:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 bc0:	01054a19 	tsteq	r5, r9, lsl sl
 bc4:	152e026a 	strne	r0, [lr, #-618]!	; 0xfffffd96
 bc8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 bcc:	15054b12 	strne	r4, [r5, #-2834]	; 0xfffff4ee
 bd0:	bb200566 	bllt	802170 <__bss_end+0x7f8680>
 bd4:	20082305 	andcs	r2, r8, r5, lsl #6
 bd8:	052e1205 	streq	r1, [lr, #-517]!	; 0xfffffdfb
 bdc:	23058214 	movwcs	r8, #21012	; 0x5214
 be0:	4a16054a 	bmi	582110 <__bss_end+0x578620>
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
 c2c:	4a100566 	bmi	4021cc <__bss_end+0x3f86dc>
 c30:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
 c34:	1005660e 	andne	r6, r5, lr, lsl #12
 c38:	4b0c054a 	blmi	302168 <__bss_end+0x2f8678>
 c3c:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c40:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c44:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c48:	054a1005 	strbeq	r1, [sl, #-5]
 c4c:	0d054b03 	vstreq	d4, [r5, #-12]
 c50:	66050530 			; <UNDEFINED> instruction: 0x66050530
 c54:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 c58:	1005660e 	andne	r6, r5, lr, lsl #12
 c5c:	4b0c054a 	blmi	30218c <__bss_end+0x2f869c>
 c60:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 c64:	0c054a10 			; <UNDEFINED> instruction: 0x0c054a10
 c68:	660e054b 	strvs	r0, [lr], -fp, asr #10
 c6c:	054a1005 	strbeq	r1, [sl, #-5]
 c70:	0e054b0c 	vmlaeq.f64	d4, d5, d12
 c74:	4a100566 	bmi	402214 <__bss_end+0x3f8724>
 c78:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 c7c:	02053006 	andeq	r3, r5, #6
 c80:	670d054b 	strvs	r0, [sp, -fp, asr #10]
 c84:	054c1c05 	strbeq	r1, [ip, #-3077]	; 0xfffff3fb
 c88:	07059f0e 	streq	r9, [r5, -lr, lsl #30]
 c8c:	68180566 	ldmdavs	r8, {r1, r2, r5, r6, r8, sl}
 c90:	05833405 	streq	r3, [r3, #1029]	; 0x405
 c94:	44056633 	strmi	r6, [r5], #-1587	; 0xfffff9cd
 c98:	4a18054a 	bmi	6021c8 <__bss_end+0x5f86d8>
 c9c:	05690605 	strbeq	r0, [r9, #-1541]!	; 0xfffff9fb
 ca0:	0b059f1d 	bleq	16891c <__bss_end+0x15ee2c>
 ca4:	00140584 	andseq	r0, r4, r4, lsl #11
 ca8:	4a030402 	bmi	c1cb8 <__bss_end+0xb81c8>
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
 d10:	0b058505 	bleq	16212c <__bss_end+0x15863c>
 d14:	02040200 	andeq	r0, r4, #0, 4
 d18:	000d0532 	andeq	r0, sp, r2, lsr r5
 d1c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 d20:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
 d24:	05830905 	streq	r0, [r3, #2309]	; 0x905
 d28:	07054a12 	smladeq	r5, r2, sl, r4
 d2c:	4a03054b 	bmi	c2260 <__bss_end+0xb8770>
 d30:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
 d34:	0c05670a 	stceq	7, cr6, [r5], {10}
 d38:	001c054c 	andseq	r0, ip, ip, asr #10
 d3c:	4a010402 	bmi	41d4c <__bss_end+0x3825c>
 d40:	02001d05 	andeq	r1, r0, #320	; 0x140
 d44:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 d48:	05054b09 	streq	r4, [r5, #-2825]	; 0xfffff4f7
 d4c:	0012054a 	andseq	r0, r2, sl, asr #10
 d50:	4b010402 	blmi	41d60 <__bss_end+0x38270>
 d54:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 d58:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
 d5c:	0905300d 	stmdbeq	r5, {r0, r2, r3, ip, sp}
 d60:	4b05054a 	blmi	142290 <__bss_end+0x1387a0>
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
      58:	1e0e0704 	cdpne	7, 0, cr0, cr14, cr4, {0}
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
     128:	00001e0e 	andeq	r1, r0, lr, lsl #28
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408690>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01ba0a00 			; <UNDEFINED> instruction: 0x01ba0a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x366a4>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a368>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03431000 	movteq	r1, #12288	; 0x3000
     25c:	0a010000 	beq	40264 <__bss_end+0x36774>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f699c>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000e1e 	andeq	r0, r0, lr, lsl lr
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000021a 	andeq	r0, r0, sl, lsl r2
     2e4:	0007df04 	andeq	sp, r7, r4, lsl #30
     2e8:	00003200 	andeq	r3, r0, r0, lsl #4
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00019400 	andeq	r9, r1, r0, lsl #8
     2f4:	0001da00 	andeq	sp, r1, r0, lsl #20
     2f8:	0bfa0200 	bleq	ffe80b00 <__bss_end+0xffe77010>
     2fc:	04050000 	streq	r0, [r5], #-0
     300:	00003e11 	andeq	r3, r0, r1, lsl lr
     304:	08030500 	stmdaeq	r3, {r8, sl}
     308:	0300009a 	movweq	r0, #154	; 0x9a
     30c:	1bd80404 	blne	ff601324 <__bss_end+0xff5f7834>
     310:	37040000 	strcc	r0, [r4, -r0]
     314:	03000000 	movweq	r0, #0
     318:	0d4e0801 	stcleq	8, cr0, [lr, #-4]
     31c:	43040000 	movwmi	r0, #16384	; 0x4000
     320:	03000000 	movweq	r0, #0
     324:	0dc20502 	cfstr64eq	mvdx0, [r2, #8]
     328:	04050000 	streq	r0, [r5], #-0
     32c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     330:	08010300 	stmdaeq	r1, {r8, r9}
     334:	00000d45 	andeq	r0, r0, r5, asr #26
     338:	b8070203 	stmdalt	r7, {r0, r1, r9}
     33c:	06000009 	streq	r0, [r0], -r9
     340:	00000e4a 	andeq	r0, r0, sl, asr #28
     344:	7c070903 			; <UNDEFINED> instruction: 0x7c070903
     348:	04000000 	streq	r0, [r0], #-0
     34c:	0000006b 	andeq	r0, r0, fp, rrx
     350:	0e070403 	cdpeq	4, 0, cr0, cr7, cr3, {0}
     354:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
     358:	0000007c 	andeq	r0, r0, ip, ror r0
     35c:	00007c07 	andeq	r7, r0, r7, lsl #24
     360:	070d0800 	streq	r0, [sp, -r0, lsl #16]
     364:	02080000 	andeq	r0, r8, #0
     368:	00b30806 	adcseq	r0, r3, r6, lsl #16
     36c:	72090000 	andvc	r0, r9, #0
     370:	08020030 	stmdaeq	r2, {r4, r5}
     374:	00006b0e 	andeq	r6, r0, lr, lsl #22
     378:	72090000 	andvc	r0, r9, #0
     37c:	09020031 	stmdbeq	r2, {r0, r4, r5}
     380:	00006b0e 	andeq	r6, r0, lr, lsl #22
     384:	0a000400 	beq	138c <shift+0x138c>
     388:	0000056c 	andeq	r0, r0, ip, ror #10
     38c:	00560405 	subseq	r0, r6, r5, lsl #8
     390:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     394:	0000ea0c 	andeq	lr, r0, ip, lsl #20
     398:	07c20b00 	strbeq	r0, [r2, r0, lsl #22]
     39c:	0b000000 	bleq	3a4 <shift+0x3a4>
     3a0:	00001255 	andeq	r1, r0, r5, asr r2
     3a4:	121f0b01 	andsne	r0, pc, #1024	; 0x400
     3a8:	0b020000 	bleq	803b0 <__bss_end+0x768c0>
     3ac:	00000a42 	andeq	r0, r0, r2, asr #20
     3b0:	0cb60b03 	fldmiaxeq	r6!, {d0}	;@ Deprecated
     3b4:	0b040000 	bleq	1003bc <__bss_end+0xf68cc>
     3b8:	0000078b 	andeq	r0, r0, fp, lsl #15
     3bc:	0f0a0005 	svceq	0x000a0005
     3c0:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     3c4:	00005604 	andeq	r5, r0, r4, lsl #12
     3c8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3d0 <shift+0x3d0>
     3cc:	00000127 	andeq	r0, r0, r7, lsr #2
     3d0:	00041b0b 	andeq	r1, r4, fp, lsl #22
     3d4:	a80b0000 	stmdage	fp, {}	; <UNPREDICTABLE>
     3d8:	01000005 	tsteq	r0, r5
     3dc:	000c5e0b 	andeq	r5, ip, fp, lsl #28
     3e0:	c30b0200 	movwgt	r0, #45568	; 0xb200
     3e4:	03000011 	movweq	r0, #17
     3e8:	00125f0b 	andseq	r5, r2, fp, lsl #30
     3ec:	6f0b0400 	svcvs	0x000b0400
     3f0:	0500000b 	streq	r0, [r0, #-11]
     3f4:	0009d80b 	andeq	sp, r9, fp, lsl #16
     3f8:	06000600 	streq	r0, [r0], -r0, lsl #12
     3fc:	00000605 	andeq	r0, r0, r5, lsl #12
     400:	56070304 	strpl	r0, [r7], -r4, lsl #6
     404:	02000000 	andeq	r0, r0, #0
     408:	00000bc7 	andeq	r0, r0, r7, asr #23
     40c:	77140504 	ldrvc	r0, [r4, -r4, lsl #10]
     410:	05000000 	streq	r0, [r0, #-0]
     414:	009a0c03 	addseq	r0, sl, r3, lsl #24
     418:	0c160200 	lfmeq	f0, 4, [r6], {-0}
     41c:	06040000 	streq	r0, [r4], -r0
     420:	00007714 	andeq	r7, r0, r4, lsl r7
     424:	10030500 	andne	r0, r3, r0, lsl #10
     428:	0200009a 	andeq	r0, r0, #154	; 0x9a
     42c:	00000b59 	andeq	r0, r0, r9, asr fp
     430:	771a0706 	ldrvc	r0, [sl, -r6, lsl #14]
     434:	05000000 	streq	r0, [r0, #-0]
     438:	009a1403 	addseq	r1, sl, r3, lsl #8
     43c:	05d70200 	ldrbeq	r0, [r7, #512]	; 0x200
     440:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     444:	0000771a 	andeq	r7, r0, sl, lsl r7
     448:	18030500 	stmdane	r3, {r8, sl}
     44c:	0200009a 	andeq	r0, r0, #154	; 0x9a
     450:	00000d37 	andeq	r0, r0, r7, lsr sp
     454:	771a0b06 	ldrvc	r0, [sl, -r6, lsl #22]
     458:	05000000 	streq	r0, [r0, #-0]
     45c:	009a1c03 	addseq	r1, sl, r3, lsl #24
     460:	09920200 	ldmibeq	r2, {r9}
     464:	0d060000 	stceq	0, cr0, [r6, #-0]
     468:	0000771a 	andeq	r7, r0, sl, lsl r7
     46c:	20030500 	andcs	r0, r3, r0, lsl #10
     470:	0200009a 	andeq	r0, r0, #154	; 0x9a
     474:	00000733 	andeq	r0, r0, r3, lsr r7
     478:	771a0f06 	ldrvc	r0, [sl, -r6, lsl #30]
     47c:	05000000 	streq	r0, [r0, #-0]
     480:	009a2403 	addseq	r2, sl, r3, lsl #8
     484:	0eaa0a00 	vfmaeq.f32	s0, s20, s0
     488:	04050000 	streq	r0, [r5], #-0
     48c:	00000056 	andeq	r0, r0, r6, asr r0
     490:	d60c1b06 	strle	r1, [ip], -r6, lsl #22
     494:	0b000001 	bleq	4a0 <shift+0x4a0>
     498:	00000f16 	andeq	r0, r0, r6, lsl pc
     49c:	120f0b00 	andne	r0, pc, #0, 22
     4a0:	0b010000 	bleq	404a8 <__bss_end+0x369b8>
     4a4:	00000c59 	andeq	r0, r0, r9, asr ip
     4a8:	130c0002 	movwne	r0, #49154	; 0xc002
     4ac:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
     4b0:	00000da7 	andeq	r0, r0, r7, lsr #27
     4b4:	07630690 			; <UNDEFINED> instruction: 0x07630690
     4b8:	00000349 	andeq	r0, r0, r9, asr #6
     4bc:	00116508 	andseq	r6, r1, r8, lsl #10
     4c0:	67062400 	strvs	r2, [r6, -r0, lsl #8]
     4c4:	00026310 	andeq	r6, r2, r0, lsl r3
     4c8:	217e0e00 	cmncs	lr, r0, lsl #28
     4cc:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
     4d0:	00034912 	andeq	r4, r3, r2, lsl r9
     4d4:	600e0000 	andvs	r0, lr, r0
     4d8:	06000005 	streq	r0, [r0], -r5
     4dc:	0359126b 	cmpeq	r9, #-1342177274	; 0xb0000006
     4e0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4e4:	00000f0b 	andeq	r0, r0, fp, lsl #30
     4e8:	6b166d06 	blvs	59b908 <__bss_end+0x591e18>
     4ec:	14000000 	strne	r0, [r0], #-0
     4f0:	0005d00e 	andeq	sp, r5, lr
     4f4:	1c700600 	ldclne	6, cr0, [r0], #-0
     4f8:	00000360 	andeq	r0, r0, r0, ror #6
     4fc:	0d2e0e18 	stceq	14, cr0, [lr, #-96]!	; 0xffffffa0
     500:	72060000 	andvc	r0, r6, #0
     504:	0003601c 	andeq	r6, r3, ip, lsl r0
     508:	3d0e1c00 	stccc	12, cr1, [lr, #-0]
     50c:	06000005 	streq	r0, [r0], -r5
     510:	03601c75 	cmneq	r0, #29952	; 0x7500
     514:	0f200000 	svceq	0x00200000
     518:	000007d4 	ldrdeq	r0, [r0], -r4
     51c:	671c7706 	ldrvs	r7, [ip, -r6, lsl #14]
     520:	60000004 	andvs	r0, r0, r4
     524:	57000003 	strpl	r0, [r0, -r3]
     528:	10000002 	andne	r0, r0, r2
     52c:	00000360 	andeq	r0, r0, r0, ror #6
     530:	00036611 	andeq	r6, r3, r1, lsl r6
     534:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     538:	00000dcc 	andeq	r0, r0, ip, asr #27
     53c:	107b0618 	rsbsne	r0, fp, r8, lsl r6
     540:	00000298 	muleq	r0, r8, r2
     544:	00217e0e 	eoreq	r7, r1, lr, lsl #28
     548:	127e0600 	rsbsne	r0, lr, #0, 12
     54c:	00000349 	andeq	r0, r0, r9, asr #6
     550:	05550e00 	ldrbeq	r0, [r5, #-3584]	; 0xfffff200
     554:	80060000 	andhi	r0, r6, r0
     558:	00036619 	andeq	r6, r3, r9, lsl r6
     55c:	c90e1000 	stmdbgt	lr, {ip}
     560:	06000011 			; <UNDEFINED> instruction: 0x06000011
     564:	03712182 	cmneq	r1, #-2147483616	; 0x80000020
     568:	00140000 	andseq	r0, r4, r0
     56c:	00026304 	andeq	r6, r2, r4, lsl #6
     570:	0b031200 	bleq	c4d78 <__bss_end+0xbb288>
     574:	86060000 	strhi	r0, [r6], -r0
     578:	00037721 	andeq	r7, r3, r1, lsr #14
     57c:	08b81200 	ldmeq	r8!, {r9, ip}
     580:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
     584:	0000771f 	andeq	r7, r0, pc, lsl r7
     588:	0dfe0e00 	ldcleq	14, cr0, [lr]
     58c:	8b060000 	blhi	180594 <__bss_end+0x176aa4>
     590:	0001e817 	andeq	lr, r1, r7, lsl r8
     594:	480e0000 	stmdami	lr, {}	; <UNPREDICTABLE>
     598:	0600000a 	streq	r0, [r0], -sl
     59c:	01e8178e 	mvneq	r1, lr, lsl #15
     5a0:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     5a4:	00000923 	andeq	r0, r0, r3, lsr #18
     5a8:	e8178f06 	ldmda	r7, {r1, r2, r8, r9, sl, fp, pc}
     5ac:	48000001 	stmdami	r0, {r0}
     5b0:	00123f0e 	andseq	r3, r2, lr, lsl #30
     5b4:	17900600 	ldrne	r0, [r0, r0, lsl #12]
     5b8:	000001e8 	andeq	r0, r0, r8, ror #3
     5bc:	0da7136c 	stceq	3, cr1, [r7, #432]!	; 0x1b0
     5c0:	93060000 	movwls	r0, #24576	; 0x6000
     5c4:	00063e09 	andeq	r3, r6, r9, lsl #28
     5c8:	00038200 	andeq	r8, r3, r0, lsl #4
     5cc:	03020100 	movweq	r0, #8448	; 0x2100
     5d0:	03080000 	movweq	r0, #32768	; 0x8000
     5d4:	82100000 	andshi	r0, r0, #0
     5d8:	00000003 	andeq	r0, r0, r3
     5dc:	000af814 	andeq	pc, sl, r4, lsl r8	; <UNPREDICTABLE>
     5e0:	0e960600 	cdpeq	6, 9, cr0, cr6, cr0, {0}
     5e4:	000009fe 	strdeq	r0, [r0], -lr
     5e8:	00031d01 	andeq	r1, r3, r1, lsl #26
     5ec:	00032300 	andeq	r2, r3, r0, lsl #6
     5f0:	03821000 	orreq	r1, r2, #0
     5f4:	15000000 	strne	r0, [r0, #-0]
     5f8:	0000041b 	andeq	r0, r0, fp, lsl r4
     5fc:	8f109906 	svchi	0x00109906
     600:	8800000e 	stmdahi	r0, {r1, r2, r3}
     604:	01000003 	tsteq	r0, r3
     608:	00000338 	andeq	r0, r0, r8, lsr r3
     60c:	00038210 	andeq	r8, r3, r0, lsl r2
     610:	03661100 	cmneq	r6, #0, 2
     614:	b1110000 	tstlt	r1, r0
     618:	00000001 	andeq	r0, r0, r1
     61c:	00431600 	subeq	r1, r3, r0, lsl #12
     620:	03590000 	cmpeq	r9, #0
     624:	7c170000 	ldcvc	0, cr0, [r7], {-0}
     628:	0f000000 	svceq	0x00000000
     62c:	02010300 	andeq	r0, r1, #0, 6
     630:	00000a5f 	andeq	r0, r0, pc, asr sl
     634:	01e80418 	mvneq	r0, r8, lsl r4
     638:	04180000 	ldreq	r0, [r8], #-0
     63c:	0000004a 	andeq	r0, r0, sl, asr #32
     640:	0011d50c 	andseq	sp, r1, ip, lsl #10
     644:	6c041800 	stcvs	8, cr1, [r4], {-0}
     648:	16000003 	strne	r0, [r0], -r3
     64c:	00000298 	muleq	r0, r8, r2
     650:	00000382 	andeq	r0, r0, r2, lsl #7
     654:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     658:	000001db 	ldrdeq	r0, [r0], -fp
     65c:	01d60418 	bicseq	r0, r6, r8, lsl r4
     660:	041a0000 	ldreq	r0, [sl], #-0
     664:	0600000e 	streq	r0, [r0], -lr
     668:	01db149c 			; <UNDEFINED> instruction: 0x01db149c
     66c:	64020000 	strvs	r0, [r2], #-0
     670:	07000008 	streq	r0, [r0, -r8]
     674:	00771404 	rsbseq	r1, r7, r4, lsl #8
     678:	03050000 	movweq	r0, #20480	; 0x5000
     67c:	00009a28 	andeq	r9, r0, r8, lsr #20
     680:	0003a602 	andeq	sl, r3, r2, lsl #12
     684:	14070700 	strne	r0, [r7], #-1792	; 0xfffff900
     688:	00000077 	andeq	r0, r0, r7, ror r0
     68c:	9a2c0305 	bls	b012a8 <__bss_end+0xaf77b8>
     690:	1a020000 	bne	80698 <__bss_end+0x76ba8>
     694:	07000006 	streq	r0, [r0, -r6]
     698:	0077140a 	rsbseq	r1, r7, sl, lsl #8
     69c:	03050000 	movweq	r0, #20480	; 0x5000
     6a0:	00009a30 	andeq	r9, r0, r0, lsr sl
     6a4:	000ac80a 	andeq	ip, sl, sl, lsl #16
     6a8:	56040500 	strpl	r0, [r4], -r0, lsl #10
     6ac:	07000000 	streq	r0, [r0, -r0]
     6b0:	04070c0d 	streq	r0, [r7], #-3085	; 0xfffff3f3
     6b4:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     6b8:	00007765 	andeq	r7, r0, r5, ror #14
     6bc:	000abf0b 	andeq	fp, sl, fp, lsl #30
     6c0:	160b0100 	strne	r0, [fp], -r0, lsl #2
     6c4:	0200000e 	andeq	r0, r0, #14
     6c8:	000a7a0b 	andeq	r7, sl, fp, lsl #20
     6cc:	340b0300 	strcc	r0, [fp], #-768	; 0xfffffd00
     6d0:	0400000a 	streq	r0, [r0], #-10
     6d4:	000c640b 	andeq	r6, ip, fp, lsl #8
     6d8:	08000500 	stmdaeq	r0, {r8, sl}
     6dc:	0000077e 	andeq	r0, r0, lr, ror r7
     6e0:	081b0710 	ldmdaeq	fp, {r4, r8, r9, sl}
     6e4:	00000446 	andeq	r0, r0, r6, asr #8
     6e8:	00726c09 	rsbseq	r6, r2, r9, lsl #24
     6ec:	46131d07 	ldrmi	r1, [r3], -r7, lsl #26
     6f0:	00000004 	andeq	r0, r0, r4
     6f4:	00707309 	rsbseq	r7, r0, r9, lsl #6
     6f8:	46131e07 	ldrmi	r1, [r3], -r7, lsl #28
     6fc:	04000004 	streq	r0, [r0], #-4
     700:	00637009 	rsbeq	r7, r3, r9
     704:	46131f07 	ldrmi	r1, [r3], -r7, lsl #30
     708:	08000004 	stmdaeq	r0, {r2}
     70c:	0007940e 	andeq	r9, r7, lr, lsl #8
     710:	13200700 	nopne	{0}	; <UNPREDICTABLE>
     714:	00000446 	andeq	r0, r0, r6, asr #8
     718:	0403000c 	streq	r0, [r3], #-12
     71c:	001e0907 	andseq	r0, lr, r7, lsl #18
     720:	04460400 	strbeq	r0, [r6], #-1024	; 0xfffffc00
     724:	5a080000 	bpl	20072c <__bss_end+0x1f6c3c>
     728:	70000004 	andvc	r0, r0, r4
     72c:	e2082807 	and	r2, r8, #458752	; 0x70000
     730:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     734:	00001249 	andeq	r1, r0, r9, asr #4
     738:	07122a07 	ldreq	r2, [r2, -r7, lsl #20]
     73c:	00000004 	andeq	r0, r0, r4
     740:	64697009 	strbtvs	r7, [r9], #-9
     744:	122b0700 	eorne	r0, fp, #0, 14
     748:	0000007c 	andeq	r0, r0, ip, ror r0
     74c:	1b5a0e10 	blne	1683f94 <__bss_end+0x167a4a4>
     750:	2c070000 	stccs	0, cr0, [r7], {-0}
     754:	0003d011 	andeq	sp, r3, r1, lsl r0
     758:	d40e1400 	strle	r1, [lr], #-1024	; 0xfffffc00
     75c:	0700000a 	streq	r0, [r0, -sl]
     760:	007c122d 	rsbseq	r1, ip, sp, lsr #4
     764:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     768:	00000ae2 	andeq	r0, r0, r2, ror #21
     76c:	7c122e07 	ldcvc	14, cr2, [r2], {7}
     770:	1c000000 	stcne	0, cr0, [r0], {-0}
     774:	0007260e 	andeq	r2, r7, lr, lsl #12
     778:	0c2f0700 	stceq	7, cr0, [pc], #-0	; 780 <shift+0x780>
     77c:	000004e2 	andeq	r0, r0, r2, ror #9
     780:	0b0f0e20 	bleq	3c4008 <__bss_end+0x3ba518>
     784:	30070000 	andcc	r0, r7, r0
     788:	00005609 	andeq	r5, r0, r9, lsl #12
     78c:	350e6000 	strcc	r6, [lr, #-0]
     790:	0700000f 	streq	r0, [r0, -pc]
     794:	006b0e31 	rsbeq	r0, fp, r1, lsr lr
     798:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     79c:	000004a5 	andeq	r0, r0, r5, lsr #9
     7a0:	6b0e3307 	blvs	38d3c4 <__bss_end+0x3838d4>
     7a4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     7a8:	00049c0e 	andeq	r9, r4, lr, lsl #24
     7ac:	0e340700 	cdpeq	7, 3, cr0, cr4, cr0, {0}
     7b0:	0000006b 	andeq	r0, r0, fp, rrx
     7b4:	8816006c 	ldmdahi	r6, {r2, r3, r5, r6}
     7b8:	f2000003 	vhadd.s8	d0, d0, d3
     7bc:	17000004 	strne	r0, [r0, -r4]
     7c0:	0000007c 	andeq	r0, r0, ip, ror r0
     7c4:	5602000f 	strpl	r0, [r2], -pc
     7c8:	08000011 	stmdaeq	r0, {r0, r4}
     7cc:	0077140a 	rsbseq	r1, r7, sl, lsl #8
     7d0:	03050000 	movweq	r0, #20480	; 0x5000
     7d4:	00009a34 	andeq	r9, r0, r4, lsr sl
     7d8:	000a820a 	andeq	r8, sl, sl, lsl #4
     7dc:	56040500 	strpl	r0, [r4], -r0, lsl #10
     7e0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     7e4:	05230c0d 	streq	r0, [r3, #-3085]!	; 0xfffff3f3
     7e8:	810b0000 	mrshi	r0, (UNDEF: 11)
     7ec:	00000005 	andeq	r0, r0, r5
     7f0:	00039b0b 	andeq	r9, r3, fp, lsl #22
     7f4:	08000100 	stmdaeq	r0, {r8}
     7f8:	00001022 	andeq	r1, r0, r2, lsr #32
     7fc:	081b080c 	ldmdaeq	fp, {r2, r3, fp}
     800:	00000558 	andeq	r0, r0, r8, asr r5
     804:	00042c0e 	andeq	r2, r4, lr, lsl #24
     808:	191d0800 	ldmdbne	sp, {fp}
     80c:	00000558 	andeq	r0, r0, r8, asr r5
     810:	053d0e00 	ldreq	r0, [sp, #-3584]!	; 0xfffff200
     814:	1e080000 	cdpne	0, 0, cr0, cr8, cr0, {0}
     818:	00055819 	andeq	r5, r5, r9, lsl r8
     81c:	a90e0400 	stmdbge	lr, {sl}
     820:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     824:	055e131f 	ldrbeq	r1, [lr, #-799]	; 0xfffffce1
     828:	00080000 	andeq	r0, r8, r0
     82c:	05230418 	streq	r0, [r3, #-1048]!	; 0xfffffbe8
     830:	04180000 	ldreq	r0, [r8], #-0
     834:	00000452 	andeq	r0, r0, r2, asr r4
     838:	00062d0d 	andeq	r2, r6, sp, lsl #26
     83c:	22081400 	andcs	r1, r8, #0, 8
     840:	0007e607 	andeq	lr, r7, r7, lsl #12
     844:	0a700e00 	beq	1c0404c <__bss_end+0x1bfa55c>
     848:	26080000 	strcs	r0, [r8], -r0
     84c:	00006b12 	andeq	r6, r0, r2, lsl fp
     850:	d70e0000 	strle	r0, [lr, -r0]
     854:	08000004 	stmdaeq	r0, {r2}
     858:	05581d29 	ldrbeq	r1, [r8, #-3369]	; 0xfffff2d7
     85c:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     860:	00000e7c 	andeq	r0, r0, ip, ror lr
     864:	581d2c08 	ldmdapl	sp, {r3, sl, fp, sp}
     868:	08000005 	stmdaeq	r0, {r0, r2}
     86c:	0011051c 	andseq	r0, r1, ip, lsl r5
     870:	0e2f0800 	cdpeq	8, 2, cr0, cr15, cr0, {0}
     874:	00000fff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     878:	000005ac 	andeq	r0, r0, ip, lsr #11
     87c:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
     880:	0007eb10 	andeq	lr, r7, r0, lsl fp
     884:	05581100 	ldrbeq	r1, [r8, #-256]	; 0xffffff00
     888:	1d000000 	stcne	0, cr0, [r0, #-0]
     88c:	00000fb8 			; <UNDEFINED> instruction: 0x00000fb8
     890:	310e3108 	tstcc	lr, r8, lsl #2
     894:	59000004 	stmdbpl	r0, {r2}
     898:	cf000003 	svcgt	0x00000003
     89c:	da000005 	ble	8b8 <shift+0x8b8>
     8a0:	10000005 	andne	r0, r0, r5
     8a4:	000007eb 	andeq	r0, r0, fp, ror #15
     8a8:	00055e11 	andeq	r5, r5, r1, lsl lr
     8ac:	64130000 	ldrvs	r0, [r3], #-0
     8b0:	08000010 	stmdaeq	r0, {r4}
     8b4:	0f841d35 	svceq	0x00841d35
     8b8:	05580000 	ldrbeq	r0, [r8, #-0]
     8bc:	f3020000 	vhadd.u8	d0, d2, d0
     8c0:	f9000005 			; <UNDEFINED> instruction: 0xf9000005
     8c4:	10000005 	andne	r0, r0, r5
     8c8:	000007eb 	andeq	r0, r0, fp, ror #15
     8cc:	09cb1300 	stmibeq	fp, {r8, r9, ip}^
     8d0:	37080000 	strcc	r0, [r8, -r0]
     8d4:	000d811d 	andeq	r8, sp, sp, lsl r1
     8d8:	00055800 	andeq	r5, r5, r0, lsl #16
     8dc:	06120200 	ldreq	r0, [r2], -r0, lsl #4
     8e0:	06180000 	ldreq	r0, [r8], -r0
     8e4:	eb100000 	bl	4008ec <__bss_end+0x3f6dfc>
     8e8:	00000007 	andeq	r0, r0, r7
     8ec:	000b3f1e 	andeq	r3, fp, lr, lsl pc
     8f0:	31390800 	teqcc	r9, r0, lsl #16
     8f4:	00000804 	andeq	r0, r0, r4, lsl #16
     8f8:	2d13020c 	lfmcs	f0, 4, [r3, #-48]	; 0xffffffd0
     8fc:	08000006 	stmdaeq	r0, {r1, r2}
     900:	1225093c 	eorne	r0, r5, #60, 18	; 0xf0000
     904:	07eb0000 	strbeq	r0, [fp, r0]!
     908:	3f010000 	svccc	0x00010000
     90c:	45000006 	strmi	r0, [r0, #-6]
     910:	10000006 	andne	r0, r0, r6
     914:	000007eb 	andeq	r0, r0, fp, ror #15
     918:	05bb1300 	ldreq	r1, [fp, #768]!	; 0x300
     91c:	3f080000 	svccc	0x00080000
     920:	0010da12 	andseq	sp, r0, r2, lsl sl
     924:	00006b00 	andeq	r6, r0, r0, lsl #22
     928:	065e0100 	ldrbeq	r0, [lr], -r0, lsl #2
     92c:	06730000 	ldrbteq	r0, [r3], -r0
     930:	eb100000 	bl	400938 <__bss_end+0x3f6e48>
     934:	11000007 	tstne	r0, r7
     938:	0000080d 	andeq	r0, r0, sp, lsl #16
     93c:	00007c11 	andeq	r7, r0, r1, lsl ip
     940:	03591100 	cmpeq	r9, #0, 2
     944:	14000000 	strne	r0, [r0], #-0
     948:	00000fc7 	andeq	r0, r0, r7, asr #31
     94c:	c50e4208 	strgt	r4, [lr, #-520]	; 0xfffffdf8
     950:	0100000c 	tsteq	r0, ip
     954:	00000688 	andeq	r0, r0, r8, lsl #13
     958:	0000068e 	andeq	r0, r0, lr, lsl #13
     95c:	0007eb10 	andeq	lr, r7, r0, lsl fp
     960:	2d130000 	ldccs	0, cr0, [r3, #-0]
     964:	08000009 	stmdaeq	r0, {r0, r3}
     968:	04fc1745 	ldrbteq	r1, [ip], #1861	; 0x745
     96c:	055e0000 	ldrbeq	r0, [lr, #-0]
     970:	a7010000 	strge	r0, [r1, -r0]
     974:	ad000006 	stcge	0, cr0, [r0, #-24]	; 0xffffffe8
     978:	10000006 	andne	r0, r0, r6
     97c:	00000813 	andeq	r0, r0, r3, lsl r8
     980:	05421300 	strbeq	r1, [r2, #-768]	; 0xfffffd00
     984:	48080000 	stmdami	r8, {}	; <UNPREDICTABLE>
     988:	000f4117 	andeq	r4, pc, r7, lsl r1	; <UNPREDICTABLE>
     98c:	00055e00 	andeq	r5, r5, r0, lsl #28
     990:	06c60100 	strbeq	r0, [r6], r0, lsl #2
     994:	06d10000 	ldrbeq	r0, [r1], r0
     998:	13100000 	tstne	r0, #0
     99c:	11000008 	tstne	r0, r8
     9a0:	0000006b 	andeq	r0, r0, fp, rrx
     9a4:	11731400 	cmnne	r3, r0, lsl #8
     9a8:	4b080000 	blmi	2009b0 <__bss_end+0x1f6ec0>
     9ac:	000fd00e 	andeq	sp, pc, lr
     9b0:	06e60100 	strbteq	r0, [r6], r0, lsl #2
     9b4:	06ec0000 	strbteq	r0, [ip], r0
     9b8:	eb100000 	bl	4009c0 <__bss_end+0x3f6ed0>
     9bc:	00000007 	andeq	r0, r0, r7
     9c0:	000fb813 	andeq	fp, pc, r3, lsl r8	; <UNPREDICTABLE>
     9c4:	0e4d0800 	cdpeq	8, 4, cr0, cr13, cr0, {0}
     9c8:	0000079a 	muleq	r0, sl, r7
     9cc:	00000359 	andeq	r0, r0, r9, asr r3
     9d0:	00070501 	andeq	r0, r7, r1, lsl #10
     9d4:	00071000 	andeq	r1, r7, r0
     9d8:	07eb1000 	strbeq	r1, [fp, r0]!
     9dc:	6b110000 	blvs	4409e4 <__bss_end+0x436ef4>
     9e0:	00000000 	andeq	r0, r0, r0
     9e4:	00094113 	andeq	r4, r9, r3, lsl r1
     9e8:	12500800 	subsne	r0, r0, #0, 16
     9ec:	00000ce6 	andeq	r0, r0, r6, ror #25
     9f0:	0000006b 	andeq	r0, r0, fp, rrx
     9f4:	00072901 	andeq	r2, r7, r1, lsl #18
     9f8:	00073400 	andeq	r3, r7, r0, lsl #8
     9fc:	07eb1000 	strbeq	r1, [fp, r0]!
     a00:	88110000 	ldmdahi	r1, {}	; <UNPREDICTABLE>
     a04:	00000003 	andeq	r0, r0, r3
     a08:	000b7613 	andeq	r7, fp, r3, lsl r6
     a0c:	0e530800 	cdpeq	8, 5, cr0, cr3, cr0, {0}
     a10:	0000087d 	andeq	r0, r0, sp, ror r8
     a14:	00000359 	andeq	r0, r0, r9, asr r3
     a18:	00074d01 	andeq	r4, r7, r1, lsl #26
     a1c:	00075800 	andeq	r5, r7, r0, lsl #16
     a20:	07eb1000 	strbeq	r1, [fp, r0]!
     a24:	6b110000 	blvs	440a2c <__bss_end+0x436f3c>
     a28:	00000000 	andeq	r0, r0, r0
     a2c:	0009a514 	andeq	sl, r9, r4, lsl r5
     a30:	0e560800 	cdpeq	8, 5, cr0, cr6, cr0, {0}
     a34:	00001083 	andeq	r1, r0, r3, lsl #1
     a38:	00076d01 	andeq	r6, r7, r1, lsl #26
     a3c:	00078c00 	andeq	r8, r7, r0, lsl #24
     a40:	07eb1000 	strbeq	r1, [fp, r0]!
     a44:	b3110000 	tstlt	r1, #0
     a48:	11000000 	mrsne	r0, (UNDEF: 0)
     a4c:	0000006b 	andeq	r0, r0, fp, rrx
     a50:	00006b11 	andeq	r6, r0, r1, lsl fp
     a54:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a58:	19110000 	ldmdbne	r1, {}	; <UNPREDICTABLE>
     a5c:	00000008 	andeq	r0, r0, r8
     a60:	000f6e14 	andeq	r6, pc, r4, lsl lr	; <UNPREDICTABLE>
     a64:	0e580800 	cdpeq	8, 5, cr0, cr8, cr0, {0}
     a68:	000006c1 	andeq	r0, r0, r1, asr #13
     a6c:	0007a101 	andeq	sl, r7, r1, lsl #2
     a70:	0007c000 	andeq	ip, r7, r0
     a74:	07eb1000 	strbeq	r1, [fp, r0]!
     a78:	ea110000 	b	440a80 <__bss_end+0x436f90>
     a7c:	11000000 	mrsne	r0, (UNDEF: 0)
     a80:	0000006b 	andeq	r0, r0, fp, rrx
     a84:	00006b11 	andeq	r6, r0, r1, lsl fp
     a88:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     a8c:	19110000 	ldmdbne	r1, {}	; <UNPREDICTABLE>
     a90:	00000008 	andeq	r0, r0, r8
     a94:	0005f215 	andeq	pc, r5, r5, lsl r2	; <UNPREDICTABLE>
     a98:	0e5b0800 	cdpeq	8, 5, cr0, cr11, cr0, {0}
     a9c:	00000653 	andeq	r0, r0, r3, asr r6
     aa0:	00000359 	andeq	r0, r0, r9, asr r3
     aa4:	0007d501 	andeq	sp, r7, r1, lsl #10
     aa8:	07eb1000 	strbeq	r1, [fp, r0]!
     aac:	04110000 	ldreq	r0, [r1], #-0
     ab0:	11000005 	tstne	r0, r5
     ab4:	0000081f 	andeq	r0, r0, pc, lsl r8
     ab8:	64040000 	strvs	r0, [r4], #-0
     abc:	18000005 	stmdane	r0, {r0, r2}
     ac0:	00056404 	andeq	r6, r5, r4, lsl #8
     ac4:	05581f00 	ldrbeq	r1, [r8, #-3840]	; 0xfffff100
     ac8:	07fe0000 	ldrbeq	r0, [lr, r0]!
     acc:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     ad0:	eb100000 	bl	400ad8 <__bss_end+0x3f6fe8>
     ad4:	00000007 	andeq	r0, r0, r7
     ad8:	00056420 	andeq	r6, r5, r0, lsr #8
     adc:	0007f100 	andeq	pc, r7, r0, lsl #2
     ae0:	5d041800 	stcpl	8, cr1, [r4, #-0]
     ae4:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     ae8:	0007e604 	andeq	lr, r7, r4, lsl #12
     aec:	8d042100 	stfhis	f2, [r4, #-0]
     af0:	22000000 	andcs	r0, r0, #0
     af4:	0b4d1a04 	bleq	134730c <__bss_end+0x133d81c>
     af8:	5e080000 	cdppl	0, 0, cr0, cr8, cr0, {0}
     afc:	00056419 	andeq	r6, r5, r9, lsl r4
     b00:	61682300 	cmnvs	r8, r0, lsl #6
     b04:	0509006c 	streq	r0, [r9, #-108]	; 0xffffff94
     b08:	0008e70b 	andeq	lr, r8, fp, lsl #14
     b0c:	0c6b2400 	cfstrdeq	mvd2, [fp], #-0
     b10:	07090000 	streq	r0, [r9, -r0]
     b14:	00008319 	andeq	r8, r0, r9, lsl r3
     b18:	e6b28000 	ldrt	r8, [r2], r0
     b1c:	0dee240e 	cfstrdeq	mvd2, [lr, #56]!	; 0x38
     b20:	0a090000 	beq	240b28 <__bss_end+0x237038>
     b24:	00044d1a 	andeq	r4, r4, sl, lsl sp
     b28:	00000000 	andeq	r0, r0, r0
     b2c:	0bd52420 	bleq	ff549bb4 <__bss_end+0xff5400c4>
     b30:	0d090000 	stceq	0, cr0, [r9, #-0]
     b34:	00044d1a 	andeq	r4, r4, sl, lsl sp
     b38:	20000000 	andcs	r0, r0, r0
     b3c:	0db32520 	cfldr32eq	mvfx2, [r3, #128]!	; 0x80
     b40:	10090000 	andne	r0, r9, r0
     b44:	00007715 	andeq	r7, r0, r5, lsl r7
     b48:	e9243600 	stmdb	r4!, {r9, sl, ip, sp}
     b4c:	09000005 	stmdbeq	r0, {r0, r2}
     b50:	044d1a4b 	strbeq	r1, [sp], #-2635	; 0xfffff5b5
     b54:	50000000 	andpl	r0, r0, r0
     b58:	20242021 	eorcs	r2, r4, r1, lsr #32
     b5c:	09000008 	stmdbeq	r0, {r3}
     b60:	044d1a7a 	strbeq	r1, [sp], #-2682	; 0xfffff586
     b64:	b2000000 	andlt	r0, r0, #0
     b68:	71242000 			; <UNDEFINED> instruction: 0x71242000
     b6c:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     b70:	044d1aad 	strbeq	r1, [sp], #-2733	; 0xfffff553
     b74:	b4000000 	strlt	r0, [r0], #-0
     b78:	a9242000 	stmdbge	r4!, {sp}
     b7c:	09000008 	stmdbeq	r0, {r3}
     b80:	044d1abc 	strbeq	r1, [sp], #-2748	; 0xfffff544
     b84:	40000000 	andmi	r0, r0, r0
     b88:	ca242010 	bgt	908bd0 <__bss_end+0x8ff0e0>
     b8c:	09000007 	stmdbeq	r0, {r0, r1, r2}
     b90:	044d1ac7 	strbeq	r1, [sp], #-2759	; 0xfffff539
     b94:	50000000 	andpl	r0, r0, r0
     b98:	5a242020 	bpl	908c20 <__bss_end+0x8ff130>
     b9c:	09000008 	stmdbeq	r0, {r3}
     ba0:	044d1ac8 	strbeq	r1, [sp], #-2760	; 0xfffff538
     ba4:	40000000 	andmi	r0, r0, r0
     ba8:	cd242080 	stcgt	0, cr2, [r4, #-512]!	; 0xfffffe00
     bac:	09000004 	stmdbeq	r0, {r2}
     bb0:	044d1ac9 	strbeq	r1, [sp], #-2761	; 0xfffff537
     bb4:	50000000 	andpl	r0, r0, r0
     bb8:	26002080 	strcs	r2, [r0], -r0, lsl #1
     bbc:	00000839 	andeq	r0, r0, r9, lsr r8
     bc0:	00084926 	andeq	r4, r8, r6, lsr #18
     bc4:	08592600 	ldmdaeq	r9, {r9, sl, sp}^
     bc8:	69260000 	stmdbvs	r6!, {}	; <UNPREDICTABLE>
     bcc:	26000008 	strcs	r0, [r0], -r8
     bd0:	00000876 	andeq	r0, r0, r6, ror r8
     bd4:	00088626 	andeq	r8, r8, r6, lsr #12
     bd8:	08962600 	ldmeq	r6, {r9, sl, sp}
     bdc:	a6260000 	strtge	r0, [r6], -r0
     be0:	26000008 	strcs	r0, [r0], -r8
     be4:	000008b6 			; <UNDEFINED> instruction: 0x000008b6
     be8:	0008c626 	andeq	ip, r8, r6, lsr #12
     bec:	08d62600 	ldmeq	r6, {r9, sl, sp}^
     bf0:	19020000 	stmdbne	r2, {}	; <UNPREDICTABLE>
     bf4:	0a00000b 	beq	c28 <shift+0xc28>
     bf8:	00771408 	rsbseq	r1, r7, r8, lsl #8
     bfc:	03050000 	movweq	r0, #20480	; 0x5000
     c00:	00009a64 	andeq	r9, r0, r4, ror #20
     c04:	000ca70a 	andeq	sl, ip, sl, lsl #14
     c08:	7c040700 	stcvc	7, cr0, [r4], {-0}
     c0c:	0a000000 	beq	c14 <shift+0xc14>
     c10:	09790c0b 	ldmdbeq	r9!, {r0, r1, r3, sl, fp}^
     c14:	b20b0000 	andlt	r0, fp, #0
     c18:	0000000f 	andeq	r0, r0, pc
     c1c:	000c520b 	andeq	r5, ip, fp, lsl #4
     c20:	970b0100 	strls	r0, [fp, -r0, lsl #2]
     c24:	0200000a 	andeq	r0, r0, #10
     c28:	0004260b 	andeq	r2, r4, fp, lsl #12
     c2c:	150b0300 	strne	r0, [fp, #-768]	; 0xfffffd00
     c30:	04000004 	streq	r0, [r0], #-4
     c34:	000a640b 	andeq	r6, sl, fp, lsl #8
     c38:	6a0b0500 	bvs	2c2040 <__bss_end+0x2b8550>
     c3c:	0600000a 	streq	r0, [r0], -sl
     c40:	0004200b 	andeq	r2, r4, fp
     c44:	030b0700 	movweq	r0, #46848	; 0xb700
     c48:	08000012 	stmdaeq	r0, {r1, r4}
     c4c:	03dc0a00 	bicseq	r0, ip, #0, 20
     c50:	04050000 	streq	r0, [r5], #-0
     c54:	00000056 	andeq	r0, r0, r6, asr r0
     c58:	a40c1d0a 	strge	r1, [ip], #-3338	; 0xfffff2f6
     c5c:	0b000009 	bleq	c88 <shift+0xc88>
     c60:	00000917 	andeq	r0, r0, r7, lsl r9
     c64:	07190b00 	ldreq	r0, [r9, -r0, lsl #22]
     c68:	0b010000 	bleq	40c70 <__bss_end+0x37180>
     c6c:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
     c70:	6f4c1b02 	svcvs	0x004c1b02
     c74:	00030077 	andeq	r0, r3, r7, ror r0
     c78:	0011f50d 	andseq	pc, r1, sp, lsl #10
     c7c:	280a1c00 	stmdacs	sl, {sl, fp, ip}
     c80:	000d2507 	andeq	r2, sp, r7, lsl #10
     c84:	05ad0800 	streq	r0, [sp, #2048]!	; 0x800
     c88:	0a100000 	beq	400c90 <__bss_end+0x3f71a0>
     c8c:	09f30a33 	ldmibeq	r3!, {r0, r1, r4, r5, r9, fp}^
     c90:	f00e0000 			; <UNDEFINED> instruction: 0xf00e0000
     c94:	0a000011 	beq	ce0 <shift+0xce0>
     c98:	03880b35 	orreq	r0, r8, #54272	; 0xd400
     c9c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     ca0:	00001189 	andeq	r1, r0, r9, lsl #3
     ca4:	6b0d360a 	blvs	34e4d4 <__bss_end+0x3449e4>
     ca8:	04000000 	streq	r0, [r0], #-0
     cac:	00042c0e 	andeq	r2, r4, lr, lsl #24
     cb0:	13370a00 	teqne	r7, #0, 20
     cb4:	00000d2a 	andeq	r0, r0, sl, lsr #26
     cb8:	053d0e08 	ldreq	r0, [sp, #-3592]!	; 0xfffff1f8
     cbc:	380a0000 	stmdacc	sl, {}	; <UNPREDICTABLE>
     cc0:	000d2a13 	andeq	r2, sp, r3, lsl sl
     cc4:	0e000c00 	cdpeq	12, 0, cr0, cr0, cr0, {0}
     cc8:	000005ca 	andeq	r0, r0, sl, asr #11
     ccc:	36202c0a 	strtcc	r2, [r0], -sl, lsl #24
     cd0:	0000000d 	andeq	r0, r0, sp
     cd4:	0005960e 	andeq	r9, r5, lr, lsl #12
     cd8:	0c2f0a00 			; <UNDEFINED> instruction: 0x0c2f0a00
     cdc:	00000d3b 	andeq	r0, r0, fp, lsr sp
     ce0:	0c220e04 	stceq	14, cr0, [r2], #-16
     ce4:	310a0000 	mrscc	r0, (UNDEF: 10)
     ce8:	000d3b0c 	andeq	r3, sp, ip, lsl #22
     cec:	fc0e0c00 	stc2	12, cr0, [lr], {-0}
     cf0:	0a00000e 	beq	d30 <shift+0xd30>
     cf4:	0d2a123b 	sfmeq	f1, 4, [sl, #-236]!	; 0xffffff14
     cf8:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     cfc:	00000e10 	andeq	r0, r0, r0, lsl lr
     d00:	270e3d0a 	strcs	r3, [lr, -sl, lsl #26]
     d04:	18000001 	stmdane	r0, {r0}
     d08:	000c3a13 	andeq	r3, ip, r3, lsl sl
     d0c:	08410a00 	stmdaeq	r1, {r9, fp}^
     d10:	00000955 	andeq	r0, r0, r5, asr r9
     d14:	00000359 	andeq	r0, r0, r9, asr r3
     d18:	000a4d02 	andeq	r4, sl, r2, lsl #26
     d1c:	000a6200 	andeq	r6, sl, r0, lsl #4
     d20:	0d4b1000 	stcleq	0, cr1, [fp, #-0]
     d24:	6b110000 	blvs	440d2c <__bss_end+0x43723c>
     d28:	11000000 	mrsne	r0, (UNDEF: 0)
     d2c:	00000d51 	andeq	r0, r0, r1, asr sp
     d30:	000d5111 	andeq	r5, sp, r1, lsl r1
     d34:	03130000 	tsteq	r3, #0
     d38:	0a00000c 	beq	d70 <shift+0xd70>
     d3c:	0b980843 	bleq	fe602e50 <__bss_end+0xfe5f9360>
     d40:	03590000 	cmpeq	r9, #0
     d44:	7b020000 	blvc	80d4c <__bss_end+0x7725c>
     d48:	9000000a 	andls	r0, r0, sl
     d4c:	1000000a 	andne	r0, r0, sl
     d50:	00000d4b 	andeq	r0, r0, fp, asr #26
     d54:	00006b11 	andeq	r6, r0, r1, lsl fp
     d58:	0d511100 	ldfeqe	f1, [r1, #-0]
     d5c:	51110000 	tstpl	r1, r0
     d60:	0000000d 	andeq	r0, r0, sp
     d64:	000eba13 	andeq	fp, lr, r3, lsl sl
     d68:	08450a00 	stmdaeq	r5, {r9, fp}^
     d6c:	00001127 	andeq	r1, r0, r7, lsr #2
     d70:	00000359 	andeq	r0, r0, r9, asr r3
     d74:	000aa902 	andeq	sl, sl, r2, lsl #18
     d78:	000abe00 	andeq	fp, sl, r0, lsl #28
     d7c:	0d4b1000 	stcleq	0, cr1, [fp, #-0]
     d80:	6b110000 	blvs	440d88 <__bss_end+0x437298>
     d84:	11000000 	mrsne	r0, (UNDEF: 0)
     d88:	00000d51 	andeq	r0, r0, r1, asr sp
     d8c:	000d5111 	andeq	r5, sp, r1, lsl r1
     d90:	70130000 	andsvc	r0, r3, r0
     d94:	0a000010 	beq	ddc <shift+0xddc>
     d98:	0ecd0847 	cdpeq	8, 12, cr0, cr13, cr7, {2}
     d9c:	03590000 	cmpeq	r9, #0
     da0:	d7020000 	strle	r0, [r2, -r0]
     da4:	ec00000a 	stc	0, cr0, [r0], {10}
     da8:	1000000a 	andne	r0, r0, sl
     dac:	00000d4b 	andeq	r0, r0, fp, asr #26
     db0:	00006b11 	andeq	r6, r0, r1, lsl fp
     db4:	0d511100 	ldfeqe	f1, [r1, #-0]
     db8:	51110000 	tstpl	r1, r0
     dbc:	0000000d 	andeq	r0, r0, sp
     dc0:	00052a13 	andeq	r2, r5, r3, lsl sl
     dc4:	08490a00 	stmdaeq	r9, {r9, fp}^
     dc8:	00001035 	andeq	r1, r0, r5, lsr r0
     dcc:	00000359 	andeq	r0, r0, r9, asr r3
     dd0:	000b0502 	andeq	r0, fp, r2, lsl #10
     dd4:	000b1a00 	andeq	r1, fp, r0, lsl #20
     dd8:	0d4b1000 	stcleq	0, cr1, [fp, #-0]
     ddc:	6b110000 	blvs	440de4 <__bss_end+0x4372f4>
     de0:	11000000 	mrsne	r0, (UNDEF: 0)
     de4:	00000d51 	andeq	r0, r0, r1, asr sp
     de8:	000d5111 	andeq	r5, sp, r1, lsl r1
     dec:	df130000 	svcle	0x00130000
     df0:	0a00000b 	beq	e24 <shift+0xe24>
     df4:	08ca084b 	stmiaeq	sl, {r0, r1, r3, r6, fp}^
     df8:	03590000 	cmpeq	r9, #0
     dfc:	33020000 	movwcc	r0, #8192	; 0x2000
     e00:	4d00000b 	stcmi	0, cr0, [r0, #-44]	; 0xffffffd4
     e04:	1000000b 	andne	r0, r0, fp
     e08:	00000d4b 	andeq	r0, r0, fp, asr #26
     e0c:	00006b11 	andeq	r6, r0, r1, lsl fp
     e10:	09791100 	ldmdbeq	r9!, {r8, ip}^
     e14:	51110000 	tstpl	r1, r0
     e18:	1100000d 	tstne	r0, sp
     e1c:	00000d51 	andeq	r0, r0, r1, asr sp
     e20:	0a1d1300 	beq	745a28 <__bss_end+0x73bf38>
     e24:	4f0a0000 	svcmi	0x000a0000
     e28:	000d530c 	andeq	r5, sp, ip, lsl #6
     e2c:	00006b00 	andeq	r6, r0, r0, lsl #22
     e30:	0b660200 	bleq	1981638 <__bss_end+0x1977b48>
     e34:	0b6c0000 	bleq	1b00e3c <__bss_end+0x1af734c>
     e38:	4b100000 	blmi	400e40 <__bss_end+0x3f7350>
     e3c:	0000000d 	andeq	r0, r0, sp
     e40:	000f2014 	andeq	r2, pc, r4, lsl r0	; <UNPREDICTABLE>
     e44:	08510a00 	ldmdaeq	r1, {r9, fp}^
     e48:	00000696 	muleq	r0, r6, r6
     e4c:	000b8102 	andeq	r8, fp, r2, lsl #2
     e50:	000b8c00 	andeq	r8, fp, r0, lsl #24
     e54:	0d571000 	ldcleq	0, cr1, [r7, #-0]
     e58:	6b110000 	blvs	440e60 <__bss_end+0x437370>
     e5c:	00000000 	andeq	r0, r0, r0
     e60:	0011f513 	andseq	pc, r1, r3, lsl r5	; <UNPREDICTABLE>
     e64:	03540a00 	cmpeq	r4, #0, 20
     e68:	00000dd7 	ldrdeq	r0, [r0], -r7
     e6c:	00000d57 	andeq	r0, r0, r7, asr sp
     e70:	000ba501 	andeq	sl, fp, r1, lsl #10
     e74:	000bb000 	andeq	fp, fp, r0
     e78:	0d571000 	ldcleq	0, cr1, [r7, #-0]
     e7c:	7c110000 	ldcvc	0, cr0, [r1], {-0}
     e80:	00000000 	andeq	r0, r0, r0
     e84:	0004ea14 	andeq	lr, r4, r4, lsl sl
     e88:	08570a00 	ldmdaeq	r7, {r9, fp}^
     e8c:	00000c7e 	andeq	r0, r0, lr, ror ip
     e90:	000bc501 	andeq	ip, fp, r1, lsl #10
     e94:	000bd500 	andeq	sp, fp, r0, lsl #10
     e98:	0d571000 	ldcleq	0, cr1, [r7, #-0]
     e9c:	6b110000 	blvs	440ea4 <__bss_end+0x4373b4>
     ea0:	11000000 	mrsne	r0, (UNDEF: 0)
     ea4:	00000930 	andeq	r0, r0, r0, lsr r9
     ea8:	0e5f1300 	cdpeq	3, 5, cr1, cr15, cr0, {0}
     eac:	590a0000 	stmdbpl	sl, {}	; <UNPREDICTABLE>
     eb0:	00119a12 	andseq	r9, r1, r2, lsl sl
     eb4:	00093000 	andeq	r3, r9, r0
     eb8:	0bee0100 	bleq	ffb812c0 <__bss_end+0xffb777d0>
     ebc:	0bf90000 	bleq	ffe40ec4 <__bss_end+0xffe373d4>
     ec0:	4b100000 	blmi	400ec8 <__bss_end+0x3f73d8>
     ec4:	1100000d 	tstne	r0, sp
     ec8:	0000006b 	andeq	r0, r0, fp, rrx
     ecc:	0c4e1400 	cfstrdeq	mvd1, [lr], {-0}
     ed0:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
     ed4:	000a9d08 	andeq	r9, sl, r8, lsl #26
     ed8:	0c0e0100 	stfeqs	f0, [lr], {-0}
     edc:	0c1e0000 	ldceq	0, cr0, [lr], {-0}
     ee0:	57100000 	ldrpl	r0, [r0, -r0]
     ee4:	1100000d 	tstne	r0, sp
     ee8:	0000006b 	andeq	r0, r0, fp, rrx
     eec:	00035911 	andeq	r5, r3, r1, lsl r9
     ef0:	ae130000 	cdpge	0, 1, cr0, cr3, cr0, {0}
     ef4:	0a00000f 	beq	f38 <shift+0xf38>
     ef8:	04ae085f 	strteq	r0, [lr], #2143	; 0x85f
     efc:	03590000 	cmpeq	r9, #0
     f00:	37010000 	strcc	r0, [r1, -r0]
     f04:	4200000c 	andmi	r0, r0, #12
     f08:	1000000c 	andne	r0, r0, ip
     f0c:	00000d57 	andeq	r0, r0, r7, asr sp
     f10:	00006b11 	andeq	r6, r0, r1, lsl fp
     f14:	53130000 	tstpl	r3, #0
     f18:	0a00000e 	beq	f58 <shift+0xf58>
     f1c:	03f10862 	mvnseq	r0, #6422528	; 0x620000
     f20:	03590000 	cmpeq	r9, #0
     f24:	5b010000 	blpl	40f2c <__bss_end+0x3743c>
     f28:	7000000c 	andvc	r0, r0, ip
     f2c:	1000000c 	andne	r0, r0, ip
     f30:	00000d57 	andeq	r0, r0, r7, asr sp
     f34:	00006b11 	andeq	r6, r0, r1, lsl fp
     f38:	03591100 	cmpeq	r9, #0, 2
     f3c:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     f40:	00000003 	andeq	r0, r0, r3
     f44:	00119113 	andseq	r9, r1, r3, lsl r1
     f48:	08640a00 	stmdaeq	r4!, {r9, fp}^
     f4c:	0000083a 	andeq	r0, r0, sl, lsr r8
     f50:	00000359 	andeq	r0, r0, r9, asr r3
     f54:	000c8901 	andeq	r8, ip, r1, lsl #18
     f58:	000c9e00 	andeq	r9, ip, r0, lsl #28
     f5c:	0d571000 	ldcleq	0, cr1, [r7, #-0]
     f60:	6b110000 	blvs	440f68 <__bss_end+0x437478>
     f64:	11000000 	mrsne	r0, (UNDEF: 0)
     f68:	00000359 	andeq	r0, r0, r9, asr r3
     f6c:	00035911 	andeq	r5, r3, r1, lsl r9
     f70:	25140000 	ldrcs	r0, [r4, #-0]
     f74:	0a00000b 	beq	fa8 <shift+0xfa8>
     f78:	03b10867 			; <UNDEFINED> instruction: 0x03b10867
     f7c:	b3010000 	movwlt	r0, #4096	; 0x1000
     f80:	c300000c 	movwgt	r0, #12
     f84:	1000000c 	andne	r0, r0, ip
     f88:	00000d57 	andeq	r0, r0, r7, asr sp
     f8c:	00006b11 	andeq	r6, r0, r1, lsl fp
     f90:	09791100 	ldmdbeq	r9!, {r8, ip}^
     f94:	14000000 	strne	r0, [r0], #-0
     f98:	00000d19 	andeq	r0, r0, r9, lsl sp
     f9c:	3d08690a 	vstrcc.16	s12, [r8, #-20]	; 0xffffffec	; <UNPREDICTABLE>
     fa0:	01000007 	tsteq	r0, r7
     fa4:	00000cd8 	ldrdeq	r0, [r0], -r8
     fa8:	00000ce8 	andeq	r0, r0, r8, ror #25
     fac:	000d5710 	andeq	r5, sp, r0, lsl r7
     fb0:	006b1100 	rsbeq	r1, fp, r0, lsl #2
     fb4:	79110000 	ldmdbvc	r1, {}	; <UNPREDICTABLE>
     fb8:	00000009 	andeq	r0, r0, r9
     fbc:	00126514 	andseq	r6, r2, r4, lsl r5
     fc0:	086c0a00 	stmdaeq	ip!, {r9, fp}^
     fc4:	000009dd 	ldrdeq	r0, [r0], -sp
     fc8:	000cfd01 	andeq	pc, ip, r1, lsl #26
     fcc:	000d0300 	andeq	r0, sp, r0, lsl #6
     fd0:	0d571000 	ldcleq	0, cr1, [r7, #-0]
     fd4:	27000000 	strcs	r0, [r0, -r0]
     fd8:	00000b89 	andeq	r0, r0, r9, lsl #23
     fdc:	1e086f0a 	cdpne	15, 0, cr6, cr8, cr10, {0}
     fe0:	0100000e 	tsteq	r0, lr
     fe4:	00000d14 	andeq	r0, r0, r4, lsl sp
     fe8:	000d5710 	andeq	r5, sp, r0, lsl r7
     fec:	03881100 	orreq	r1, r8, #0, 2
     ff0:	6b110000 	blvs	440ff8 <__bss_end+0x437508>
     ff4:	00000000 	andeq	r0, r0, r0
     ff8:	09a40400 	stmibeq	r4!, {sl}
     ffc:	04180000 	ldreq	r0, [r8], #-0
    1000:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1004:	00880418 	addeq	r0, r8, r8, lsl r4
    1008:	30040000 	andcc	r0, r4, r0
    100c:	1600000d 	strne	r0, [r0], -sp
    1010:	0000006b 	andeq	r0, r0, fp, rrx
    1014:	00000d4b 	andeq	r0, r0, fp, asr #26
    1018:	00007c17 	andeq	r7, r0, r7, lsl ip
    101c:	18000100 	stmdane	r0, {r8}
    1020:	000d2504 	andeq	r2, sp, r4, lsl #10
    1024:	6b042100 	blvs	10942c <__bss_end+0xff93c>
    1028:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    102c:	0009a404 	andeq	sl, r9, r4, lsl #8
    1030:	0b391a00 	bleq	e47838 <__bss_end+0xe3dd48>
    1034:	730a0000 	movwvc	r0, #40960	; 0xa000
    1038:	0009a416 	andeq	sl, r9, r6, lsl r4
    103c:	121a2800 	andsne	r2, sl, #0, 16
    1040:	10010000 	andne	r0, r1, r0
    1044:	00005605 	andeq	r5, r0, r5, lsl #12
    1048:	00822c00 	addeq	r2, r2, r0, lsl #24
    104c:	00019400 	andeq	r9, r1, r0, lsl #8
    1050:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    1054:	2900000e 	stmdbcs	r0, {r1, r2, r3}
    1058:	000011d0 	ldrdeq	r1, [r0], -r0
    105c:	560e1001 	strpl	r1, [lr], -r1
    1060:	02000000 	andeq	r0, r0, #0
    1064:	d5295c91 	strle	r5, [r9, #-3217]!	; 0xfffff36f
    1068:	01000010 	tsteq	r0, r0, lsl r0
    106c:	0e151b10 	vmoveq.32	r1, d5[0]
    1070:	91020000 	mrsls	r0, (UNDEF: 2)
    1074:	0a522a58 	beq	148b9dc <__bss_end+0x1481eec>
    1078:	12010000 	andne	r0, r1, #0
    107c:	00006b0b 	andeq	r6, r0, fp, lsl #22
    1080:	70910200 	addsvc	r0, r1, r0, lsl #4
    1084:	0011e82a 	andseq	lr, r1, sl, lsr #16
    1088:	0b130100 	bleq	4c1490 <__bss_end+0x4b79a0>
    108c:	0000006b 	andeq	r0, r0, fp, rrx
    1090:	2a6c9102 	bcs	1b254a0 <__bss_end+0x1b1b9b0>
    1094:	00000985 	andeq	r0, r0, r5, lsl #19
    1098:	6b0b1401 	blvs	2c60a4 <__bss_end+0x2bc5b4>
    109c:	02000000 	andeq	r0, r0, #0
    10a0:	da2a6891 	ble	a9b2ec <__bss_end+0xa917fc>
    10a4:	0100000a 	tsteq	r0, sl
    10a8:	007c0f16 	rsbseq	r0, ip, r6, lsl pc
    10ac:	91020000 	mrsls	r0, (UNDEF: 2)
    10b0:	04972a74 	ldreq	r2, [r7], #2676	; 0xa74
    10b4:	17010000 	strne	r0, [r1, -r0]
    10b8:	00035907 	andeq	r5, r3, r7, lsl #18
    10bc:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
    10c0:	0006102a 	andeq	r1, r6, sl, lsr #32
    10c4:	07180100 	ldreq	r0, [r8, -r0, lsl #2]
    10c8:	00000359 	andeq	r0, r0, r9, asr r3
    10cc:	2b669102 	blcs	19a54dc <__bss_end+0x199b9ec>
    10d0:	000082a8 	andeq	r8, r0, r8, lsr #5
    10d4:	00000104 	andeq	r0, r0, r4, lsl #2
    10d8:	706d742c 	rsbvc	r7, sp, ip, lsr #8
    10dc:	081e0100 	ldmdaeq	lr, {r8}
    10e0:	00000043 	andeq	r0, r0, r3, asr #32
    10e4:	00659102 	rsbeq	r9, r5, r2, lsl #2
    10e8:	1b041800 	blne	1070f0 <__bss_end+0xfd600>
    10ec:	1800000e 	stmdane	r0, {r1, r2, r3}
    10f0:	00004304 	andeq	r4, r0, r4, lsl #6
    10f4:	0cf50000 	ldcleq	0, cr0, [r5]
    10f8:	00040000 	andeq	r0, r4, r0
    10fc:	00000480 	andeq	r0, r0, r0, lsl #9
    1100:	15be0104 	ldrne	r0, [lr, #260]!	; 0x104
    1104:	a1040000 	mrsge	r0, (UNDEF: 4)
    1108:	2c000013 	stccs	0, cr0, [r0], {19}
    110c:	c0000014 	andgt	r0, r0, r4, lsl r0
    1110:	5c000083 	stcpl	0, cr0, [r0], {131}	; 0x83
    1114:	8f000004 	svchi	0x00000004
    1118:	02000004 	andeq	r0, r0, #4
    111c:	0d4e0801 	stcleq	8, cr0, [lr, #-4]
    1120:	25030000 	strcs	r0, [r3, #-0]
    1124:	02000000 	andeq	r0, r0, #0
    1128:	0dc20502 	cfstr64eq	mvdx0, [r2, #8]
    112c:	04040000 	streq	r0, [r4], #-0
    1130:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1134:	08010200 	stmdaeq	r1, {r9}
    1138:	00000d45 	andeq	r0, r0, r5, asr #26
    113c:	b8070202 	stmdalt	r7, {r1, r9}
    1140:	05000009 	streq	r0, [r0, #-9]
    1144:	00000e4a 	andeq	r0, r0, sl, asr #28
    1148:	5e070908 	vmlapl.f16	s0, s14, s16	; <UNPREDICTABLE>
    114c:	03000000 	movweq	r0, #0
    1150:	0000004d 	andeq	r0, r0, sp, asr #32
    1154:	0e070402 	cdpeq	4, 0, cr0, cr7, cr2, {0}
    1158:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    115c:	0000070d 	andeq	r0, r0, sp, lsl #14
    1160:	08060208 	stmdaeq	r6, {r3, r9}
    1164:	0000008b 	andeq	r0, r0, fp, lsl #1
    1168:	00307207 	eorseq	r7, r0, r7, lsl #4
    116c:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    1170:	00000000 	andeq	r0, r0, r0
    1174:	00317207 	eorseq	r7, r1, r7, lsl #4
    1178:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    117c:	04000000 	streq	r0, [r0], #-0
    1180:	14ec0800 	strbtne	r0, [ip], #2048	; 0x800
    1184:	04050000 	streq	r0, [r5], #-0
    1188:	00000038 	andeq	r0, r0, r8, lsr r0
    118c:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    1190:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1194:	00004b4f 	andeq	r4, r0, pc, asr #22
    1198:	0012e10a 	andseq	lr, r2, sl, lsl #2
    119c:	08000100 	stmdaeq	r0, {r8}
    11a0:	0000056c 	andeq	r0, r0, ip, ror #10
    11a4:	00380405 	eorseq	r0, r8, r5, lsl #8
    11a8:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    11ac:	0000e00c 	andeq	lr, r0, ip
    11b0:	07c20a00 	strbeq	r0, [r2, r0, lsl #20]
    11b4:	0a000000 	beq	11bc <shift+0x11bc>
    11b8:	00001255 	andeq	r1, r0, r5, asr r2
    11bc:	121f0a01 	andsne	r0, pc, #4096	; 0x1000
    11c0:	0a020000 	beq	811c8 <__bss_end+0x776d8>
    11c4:	00000a42 	andeq	r0, r0, r2, asr #20
    11c8:	0cb60a03 	vldmiaeq	r6!, {s0-s2}
    11cc:	0a040000 	beq	1011d4 <__bss_end+0xf76e4>
    11d0:	0000078b 	andeq	r0, r0, fp, lsl #15
    11d4:	0f080005 	svceq	0x00080005
    11d8:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    11dc:	00003804 	andeq	r3, r0, r4, lsl #16
    11e0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 11e8 <shift+0x11e8>
    11e4:	0000011d 	andeq	r0, r0, sp, lsl r1
    11e8:	00041b0a 	andeq	r1, r4, sl, lsl #22
    11ec:	a80a0000 	stmdage	sl, {}	; <UNPREDICTABLE>
    11f0:	01000005 	tsteq	r0, r5
    11f4:	000c5e0a 	andeq	r5, ip, sl, lsl #28
    11f8:	c30a0200 	movwgt	r0, #41472	; 0xa200
    11fc:	03000011 	movweq	r0, #17
    1200:	00125f0a 	andseq	r5, r2, sl, lsl #30
    1204:	6f0a0400 	svcvs	0x000a0400
    1208:	0500000b 	streq	r0, [r0, #-11]
    120c:	0009d80a 	andeq	sp, r9, sl, lsl #16
    1210:	08000600 	stmdaeq	r0, {r9, sl}
    1214:	00001551 	andeq	r1, r0, r1, asr r5
    1218:	00380405 	eorseq	r0, r8, r5, lsl #8
    121c:	66020000 	strvs	r0, [r2], -r0
    1220:	0001480c 	andeq	r4, r1, ip, lsl #16
    1224:	14910a00 	ldrne	r0, [r1], #2560	; 0xa00
    1228:	0a000000 	beq	1230 <shift+0x1230>
    122c:	0000133e 	andeq	r1, r0, lr, lsr r3
    1230:	14b50a01 	ldrtne	r0, [r5], #2561	; 0xa01
    1234:	0a020000 	beq	8123c <__bss_end+0x7774c>
    1238:	00001363 	andeq	r1, r0, r3, ror #6
    123c:	c70b0003 	strgt	r0, [fp, -r3]
    1240:	0300000b 	movweq	r0, #11
    1244:	00591405 	subseq	r1, r9, r5, lsl #8
    1248:	03050000 	movweq	r0, #20480	; 0x5000
    124c:	00009a8c 	andeq	r9, r0, ip, lsl #21
    1250:	000c160b 	andeq	r1, ip, fp, lsl #12
    1254:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1258:	00000059 	andeq	r0, r0, r9, asr r0
    125c:	9a900305 	bls	fe401e78 <__bss_end+0xfe3f8388>
    1260:	590b0000 	stmdbpl	fp, {}	; <UNPREDICTABLE>
    1264:	0400000b 	streq	r0, [r0], #-11
    1268:	00591a07 	subseq	r1, r9, r7, lsl #20
    126c:	03050000 	movweq	r0, #20480	; 0x5000
    1270:	00009a94 	muleq	r0, r4, sl
    1274:	0005d70b 	andeq	sp, r5, fp, lsl #14
    1278:	1a090400 	bne	242280 <__bss_end+0x238790>
    127c:	00000059 	andeq	r0, r0, r9, asr r0
    1280:	9a980305 	bls	fe601e9c <__bss_end+0xfe5f83ac>
    1284:	370b0000 	strcc	r0, [fp, -r0]
    1288:	0400000d 	streq	r0, [r0], #-13
    128c:	00591a0b 	subseq	r1, r9, fp, lsl #20
    1290:	03050000 	movweq	r0, #20480	; 0x5000
    1294:	00009a9c 	muleq	r0, ip, sl
    1298:	0009920b 	andeq	r9, r9, fp, lsl #4
    129c:	1a0d0400 	bne	3422a4 <__bss_end+0x3387b4>
    12a0:	00000059 	andeq	r0, r0, r9, asr r0
    12a4:	9aa00305 	bls	fe801ec0 <__bss_end+0xfe7f83d0>
    12a8:	330b0000 	movwcc	r0, #45056	; 0xb000
    12ac:	04000007 	streq	r0, [r0], #-7
    12b0:	00591a0f 	subseq	r1, r9, pc, lsl #20
    12b4:	03050000 	movweq	r0, #20480	; 0x5000
    12b8:	00009aa4 	andeq	r9, r0, r4, lsr #21
    12bc:	000eaa08 	andeq	sl, lr, r8, lsl #20
    12c0:	38040500 	stmdacc	r4, {r8, sl}
    12c4:	04000000 	streq	r0, [r0], #-0
    12c8:	01eb0c1b 	mvneq	r0, fp, lsl ip
    12cc:	160a0000 	strne	r0, [sl], -r0
    12d0:	0000000f 	andeq	r0, r0, pc
    12d4:	00120f0a 	andseq	r0, r2, sl, lsl #30
    12d8:	590a0100 	stmdbpl	sl, {r8}
    12dc:	0200000c 	andeq	r0, r0, #12
    12e0:	0d130c00 	ldceq	12, cr0, [r3, #-0]
    12e4:	a70d0000 	strge	r0, [sp, -r0]
    12e8:	9000000d 	andls	r0, r0, sp
    12ec:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    12f0:	06000003 	streq	r0, [r0], -r3
    12f4:	00001165 	andeq	r1, r0, r5, ror #2
    12f8:	10670424 	rsbne	r0, r7, r4, lsr #8
    12fc:	00000278 	andeq	r0, r0, r8, ror r2
    1300:	00217e0e 	eoreq	r7, r1, lr, lsl #28
    1304:	12690400 	rsbne	r0, r9, #0, 8
    1308:	0000035e 	andeq	r0, r0, lr, asr r3
    130c:	05600e00 	strbeq	r0, [r0, #-3584]!	; 0xfffff200
    1310:	6b040000 	blvs	101318 <__bss_end+0xf7828>
    1314:	00036e12 	andeq	r6, r3, r2, lsl lr
    1318:	0b0e1000 	bleq	385320 <__bss_end+0x37b830>
    131c:	0400000f 	streq	r0, [r0], #-15
    1320:	004d166d 	subeq	r1, sp, sp, ror #12
    1324:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1328:	000005d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    132c:	751c7004 	ldrvc	r7, [ip, #-4]
    1330:	18000003 	stmdane	r0, {r0, r1}
    1334:	000d2e0e 	andeq	r2, sp, lr, lsl #28
    1338:	1c720400 	cfldrdne	mvd0, [r2], #-0
    133c:	00000375 	andeq	r0, r0, r5, ror r3
    1340:	053d0e1c 	ldreq	r0, [sp, #-3612]!	; 0xfffff1e4
    1344:	75040000 	strvc	r0, [r4, #-0]
    1348:	0003751c 	andeq	r7, r3, ip, lsl r5
    134c:	d40f2000 	strle	r2, [pc], #-0	; 1354 <shift+0x1354>
    1350:	04000007 	streq	r0, [r0], #-7
    1354:	04671c77 	strbteq	r1, [r7], #-3191	; 0xfffff389
    1358:	03750000 	cmneq	r5, #0
    135c:	026c0000 	rsbeq	r0, ip, #0
    1360:	75100000 	ldrvc	r0, [r0, #-0]
    1364:	11000003 	tstne	r0, r3
    1368:	0000037b 	andeq	r0, r0, fp, ror r3
    136c:	cc060000 	stcgt	0, cr0, [r6], {-0}
    1370:	1800000d 	stmdane	r0, {r0, r2, r3}
    1374:	ad107b04 	vldrge	d7, [r0, #-16]
    1378:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    137c:	0000217e 	andeq	r2, r0, lr, ror r1
    1380:	5e127e04 	cdppl	14, 1, cr7, cr2, cr4, {0}
    1384:	00000003 	andeq	r0, r0, r3
    1388:	0005550e 	andeq	r5, r5, lr, lsl #10
    138c:	19800400 	stmibne	r0, {sl}
    1390:	0000037b 	andeq	r0, r0, fp, ror r3
    1394:	11c90e10 	bicne	r0, r9, r0, lsl lr
    1398:	82040000 	andhi	r0, r4, #0
    139c:	00038621 	andeq	r8, r3, r1, lsr #12
    13a0:	03001400 	movweq	r1, #1024	; 0x400
    13a4:	00000278 	andeq	r0, r0, r8, ror r2
    13a8:	000b0312 	andeq	r0, fp, r2, lsl r3
    13ac:	21860400 	orrcs	r0, r6, r0, lsl #8
    13b0:	0000038c 	andeq	r0, r0, ip, lsl #7
    13b4:	0008b812 	andeq	fp, r8, r2, lsl r8
    13b8:	1f880400 	svcne	0x00880400
    13bc:	00000059 	andeq	r0, r0, r9, asr r0
    13c0:	000dfe0e 	andeq	pc, sp, lr, lsl #28
    13c4:	178b0400 	strne	r0, [fp, r0, lsl #8]
    13c8:	000001fd 	strdeq	r0, [r0], -sp
    13cc:	0a480e00 	beq	1204bd4 <__bss_end+0x11fb0e4>
    13d0:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    13d4:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13d8:	230e2400 	movwcs	r2, #58368	; 0xe400
    13dc:	04000009 	streq	r0, [r0], #-9
    13e0:	01fd178f 	mvnseq	r1, pc, lsl #15
    13e4:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    13e8:	0000123f 	andeq	r1, r0, pc, lsr r2
    13ec:	fd179004 	ldc2	0, cr9, [r7, #-16]
    13f0:	6c000001 	stcvs	0, cr0, [r0], {1}
    13f4:	000da713 	andeq	sl, sp, r3, lsl r7
    13f8:	09930400 	ldmibeq	r3, {sl}
    13fc:	0000063e 	andeq	r0, r0, lr, lsr r6
    1400:	00000397 	muleq	r0, r7, r3
    1404:	00031701 	andeq	r1, r3, r1, lsl #14
    1408:	00031d00 	andeq	r1, r3, r0, lsl #26
    140c:	03971000 	orrseq	r1, r7, #0
    1410:	14000000 	strne	r0, [r0], #-0
    1414:	00000af8 	strdeq	r0, [r0], -r8
    1418:	fe0e9604 	cdp2	6, 0, cr9, cr14, cr4, {0}
    141c:	01000009 	tsteq	r0, r9
    1420:	00000332 	andeq	r0, r0, r2, lsr r3
    1424:	00000338 	andeq	r0, r0, r8, lsr r3
    1428:	00039710 	andeq	r9, r3, r0, lsl r7
    142c:	1b150000 	blne	541434 <__bss_end+0x537944>
    1430:	04000004 	streq	r0, [r0], #-4
    1434:	0e8f1099 	mcreq	0, 4, r1, cr15, cr9, {4}
    1438:	039d0000 	orrseq	r0, sp, #0
    143c:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1440:	10000003 	andne	r0, r0, r3
    1444:	00000397 	muleq	r0, r7, r3
    1448:	00037b11 	andeq	r7, r3, r1, lsl fp
    144c:	01c61100 	biceq	r1, r6, r0, lsl #2
    1450:	00000000 	andeq	r0, r0, r0
    1454:	00002516 	andeq	r2, r0, r6, lsl r5
    1458:	00036e00 	andeq	r6, r3, r0, lsl #28
    145c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1460:	000f0000 	andeq	r0, pc, r0
    1464:	5f020102 	svcpl	0x00020102
    1468:	1800000a 	stmdane	r0, {r1, r3}
    146c:	0001fd04 	andeq	pc, r1, r4, lsl #26
    1470:	2c041800 	stccs	8, cr1, [r4], {-0}
    1474:	0c000000 	stceq	0, cr0, [r0], {-0}
    1478:	000011d5 	ldrdeq	r1, [r0], -r5
    147c:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    1480:	ad160000 	ldcge	0, cr0, [r6, #-0]
    1484:	97000002 	strls	r0, [r0, -r2]
    1488:	19000003 	stmdbne	r0, {r0, r1}
    148c:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    1490:	18000001 	stmdane	r0, {r0}
    1494:	0001eb04 	andeq	lr, r1, r4, lsl #22
    1498:	0e041a00 	vmlaeq.f32	s2, s8, s0
    149c:	9c040000 	stcls	0, cr0, [r4], {-0}
    14a0:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    14a4:	08640b00 	stmdaeq	r4!, {r8, r9, fp}^
    14a8:	04050000 	streq	r0, [r5], #-0
    14ac:	00005914 	andeq	r5, r0, r4, lsl r9
    14b0:	a8030500 	stmdage	r3, {r8, sl}
    14b4:	0b00009a 	bleq	1724 <shift+0x1724>
    14b8:	000003a6 	andeq	r0, r0, r6, lsr #7
    14bc:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    14c0:	05000000 	streq	r0, [r0, #-0]
    14c4:	009aac03 	addseq	sl, sl, r3, lsl #24
    14c8:	061a0b00 	ldreq	r0, [sl], -r0, lsl #22
    14cc:	0a050000 	beq	1414d4 <__bss_end+0x1379e4>
    14d0:	00005914 	andeq	r5, r0, r4, lsl r9
    14d4:	b0030500 	andlt	r0, r3, r0, lsl #10
    14d8:	0800009a 	stmdaeq	r0, {r1, r3, r4, r7}
    14dc:	00000ac8 	andeq	r0, r0, r8, asr #21
    14e0:	00380405 	eorseq	r0, r8, r5, lsl #8
    14e4:	0d050000 	stceq	0, cr0, [r5, #-0]
    14e8:	00041c0c 	andeq	r1, r4, ip, lsl #24
    14ec:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    14f0:	0a000077 	beq	16d4 <shift+0x16d4>
    14f4:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
    14f8:	0e160a01 	vnmlseq.f32	s0, s12, s2
    14fc:	0a020000 	beq	81504 <__bss_end+0x77a14>
    1500:	00000a7a 	andeq	r0, r0, sl, ror sl
    1504:	0a340a03 	beq	d03d18 <__bss_end+0xcfa228>
    1508:	0a040000 	beq	101510 <__bss_end+0xf7a20>
    150c:	00000c64 	andeq	r0, r0, r4, ror #24
    1510:	7e060005 	cdpvc	0, 0, cr0, cr6, cr5, {0}
    1514:	10000007 	andne	r0, r0, r7
    1518:	5b081b05 	blpl	208134 <__bss_end+0x1fe644>
    151c:	07000004 	streq	r0, [r0, -r4]
    1520:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    1524:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    1528:	07000000 	streq	r0, [r0, -r0]
    152c:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    1530:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    1534:	07040000 	streq	r0, [r4, -r0]
    1538:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    153c:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    1540:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1544:	00000794 	muleq	r0, r4, r7
    1548:	5b132005 	blpl	4c9564 <__bss_end+0x4bfa74>
    154c:	0c000004 	stceq	0, cr0, [r0], {4}
    1550:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1554:	00001e09 	andeq	r1, r0, r9, lsl #28
    1558:	00045a06 	andeq	r5, r4, r6, lsl #20
    155c:	28057000 	stmdacs	r5, {ip, sp, lr}
    1560:	0004f208 	andeq	pc, r4, r8, lsl #4
    1564:	12490e00 	subne	r0, r9, #0, 28
    1568:	2a050000 	bcs	141570 <__bss_end+0x137a80>
    156c:	00041c12 	andeq	r1, r4, r2, lsl ip
    1570:	70070000 	andvc	r0, r7, r0
    1574:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    1578:	005e122b 	subseq	r1, lr, fp, lsr #4
    157c:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1580:	00001b5a 	andeq	r1, r0, sl, asr fp
    1584:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    1588:	14000003 	strne	r0, [r0], #-3
    158c:	000ad40e 	andeq	sp, sl, lr, lsl #8
    1590:	122d0500 	eorne	r0, sp, #0, 10
    1594:	0000005e 	andeq	r0, r0, lr, asr r0
    1598:	0ae20e18 	beq	ff884e00 <__bss_end+0xff87b310>
    159c:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    15a0:	00005e12 	andeq	r5, r0, r2, lsl lr
    15a4:	260e1c00 	strcs	r1, [lr], -r0, lsl #24
    15a8:	05000007 	streq	r0, [r0, #-7]
    15ac:	04f20c2f 	ldrbteq	r0, [r2], #3119	; 0xc2f
    15b0:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    15b4:	00000b0f 	andeq	r0, r0, pc, lsl #22
    15b8:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    15bc:	60000000 	andvs	r0, r0, r0
    15c0:	000f350e 	andeq	r3, pc, lr, lsl #10
    15c4:	0e310500 	cfabs32eq	mvfx0, mvfx1
    15c8:	0000004d 	andeq	r0, r0, sp, asr #32
    15cc:	04a50e64 	strteq	r0, [r5], #3684	; 0xe64
    15d0:	33050000 	movwcc	r0, #20480	; 0x5000
    15d4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15d8:	9c0e6800 	stcls	8, cr6, [lr], {-0}
    15dc:	05000004 	streq	r0, [r0, #-4]
    15e0:	004d0e34 	subeq	r0, sp, r4, lsr lr
    15e4:	006c0000 	rsbeq	r0, ip, r0
    15e8:	00039d16 	andeq	r9, r3, r6, lsl sp
    15ec:	00050200 	andeq	r0, r5, r0, lsl #4
    15f0:	005e1700 	subseq	r1, lr, r0, lsl #14
    15f4:	000f0000 	andeq	r0, pc, r0
    15f8:	0011560b 	andseq	r5, r1, fp, lsl #12
    15fc:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    1600:	00000059 	andeq	r0, r0, r9, asr r0
    1604:	9ab40305 	bls	fed02220 <__bss_end+0xfecf8730>
    1608:	82080000 	andhi	r0, r8, #0
    160c:	0500000a 	streq	r0, [r0, #-10]
    1610:	00003804 	andeq	r3, r0, r4, lsl #16
    1614:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1618:	00000533 	andeq	r0, r0, r3, lsr r5
    161c:	0005810a 	andeq	r8, r5, sl, lsl #2
    1620:	9b0a0000 	blls	281628 <__bss_end+0x277b38>
    1624:	01000003 	tsteq	r0, r3
    1628:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    162c:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
    1630:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1634:	00003804 	andeq	r3, r0, r4, lsl #16
    1638:	0c140600 	ldceq	6, cr0, [r4], {-0}
    163c:	00000557 	andeq	r0, r0, r7, asr r5
    1640:	0012760a 	andseq	r7, r2, sl, lsl #12
    1644:	a70a0000 	strge	r0, [sl, -r0]
    1648:	01000014 	tsteq	r0, r4, lsl r0
    164c:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    1650:	22060000 	andcs	r0, r6, #0
    1654:	0c000010 	stceq	0, cr0, [r0], {16}
    1658:	91081b06 	tstls	r8, r6, lsl #22
    165c:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1660:	0000042c 	andeq	r0, r0, ip, lsr #8
    1664:	91191d06 	tstls	r9, r6, lsl #26
    1668:	00000005 	andeq	r0, r0, r5
    166c:	00053d0e 	andeq	r3, r5, lr, lsl #26
    1670:	191e0600 	ldmdbne	lr, {r9, sl}
    1674:	00000591 	muleq	r0, r1, r5
    1678:	0fa90e04 	svceq	0x00a90e04
    167c:	1f060000 	svcne	0x00060000
    1680:	00059713 	andeq	r9, r5, r3, lsl r7
    1684:	18000800 	stmdane	r0, {fp}
    1688:	00055c04 	andeq	r5, r5, r4, lsl #24
    168c:	62041800 	andvs	r1, r4, #0, 16
    1690:	0d000004 	stceq	0, cr0, [r0, #-16]
    1694:	0000062d 	andeq	r0, r0, sp, lsr #12
    1698:	07220614 			; <UNDEFINED> instruction: 0x07220614
    169c:	0000081f 	andeq	r0, r0, pc, lsl r8
    16a0:	000a700e 	andeq	r7, sl, lr
    16a4:	12260600 	eorne	r0, r6, #0, 12
    16a8:	0000004d 	andeq	r0, r0, sp, asr #32
    16ac:	04d70e00 	ldrbeq	r0, [r7], #3584	; 0xe00
    16b0:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    16b4:	0005911d 	andeq	r9, r5, sp, lsl r1
    16b8:	7c0e0400 	cfstrsvc	mvf0, [lr], {-0}
    16bc:	0600000e 	streq	r0, [r0], -lr
    16c0:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    16c4:	1b080000 	blne	2016cc <__bss_end+0x1f7bdc>
    16c8:	00001105 	andeq	r1, r0, r5, lsl #2
    16cc:	ff0e2f06 			; <UNDEFINED> instruction: 0xff0e2f06
    16d0:	e500000f 	str	r0, [r0, #-15]
    16d4:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    16d8:	10000005 	andne	r0, r0, r5
    16dc:	00000824 	andeq	r0, r0, r4, lsr #16
    16e0:	00059111 	andeq	r9, r5, r1, lsl r1
    16e4:	b81c0000 	ldmdalt	ip, {}	; <UNPREDICTABLE>
    16e8:	0600000f 	streq	r0, [r0], -pc
    16ec:	04310e31 	ldrteq	r0, [r1], #-3633	; 0xfffff1cf
    16f0:	036e0000 	cmneq	lr, #0
    16f4:	06080000 	streq	r0, [r8], -r0
    16f8:	06130000 	ldreq	r0, [r3], -r0
    16fc:	24100000 	ldrcs	r0, [r0], #-0
    1700:	11000008 	tstne	r0, r8
    1704:	00000597 	muleq	r0, r7, r5
    1708:	10641300 	rsbne	r1, r4, r0, lsl #6
    170c:	35060000 	strcc	r0, [r6, #-0]
    1710:	000f841d 	andeq	r8, pc, sp, lsl r4	; <UNPREDICTABLE>
    1714:	00059100 	andeq	r9, r5, r0, lsl #2
    1718:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    171c:	06320000 	ldrteq	r0, [r2], -r0
    1720:	24100000 	ldrcs	r0, [r0], #-0
    1724:	00000008 	andeq	r0, r0, r8
    1728:	0009cb13 	andeq	ip, r9, r3, lsl fp
    172c:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1730:	00000d81 	andeq	r0, r0, r1, lsl #27
    1734:	00000591 	muleq	r0, r1, r5
    1738:	00064b02 	andeq	r4, r6, r2, lsl #22
    173c:	00065100 	andeq	r5, r6, r0, lsl #2
    1740:	08241000 	stmdaeq	r4!, {ip}
    1744:	1d000000 	stcne	0, cr0, [r0, #-0]
    1748:	00000b3f 	andeq	r0, r0, pc, lsr fp
    174c:	3d313906 			; <UNDEFINED> instruction: 0x3d313906
    1750:	0c000008 	stceq	0, cr0, [r0], {8}
    1754:	062d1302 	strteq	r1, [sp], -r2, lsl #6
    1758:	3c060000 	stccc	0, cr0, [r6], {-0}
    175c:	00122509 	andseq	r2, r2, r9, lsl #10
    1760:	00082400 	andeq	r2, r8, r0, lsl #8
    1764:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1768:	067e0000 	ldrbteq	r0, [lr], -r0
    176c:	24100000 	ldrcs	r0, [r0], #-0
    1770:	00000008 	andeq	r0, r0, r8
    1774:	0005bb13 	andeq	fp, r5, r3, lsl fp
    1778:	123f0600 	eorsne	r0, pc, #0, 12
    177c:	000010da 	ldrdeq	r1, [r0], -sl
    1780:	0000004d 	andeq	r0, r0, sp, asr #32
    1784:	00069701 	andeq	r9, r6, r1, lsl #14
    1788:	0006ac00 	andeq	sl, r6, r0, lsl #24
    178c:	08241000 	stmdaeq	r4!, {ip}
    1790:	46110000 	ldrmi	r0, [r1], -r0
    1794:	11000008 	tstne	r0, r8
    1798:	0000005e 	andeq	r0, r0, lr, asr r0
    179c:	00036e11 	andeq	r6, r3, r1, lsl lr
    17a0:	c7140000 	ldrgt	r0, [r4, -r0]
    17a4:	0600000f 	streq	r0, [r0], -pc
    17a8:	0cc50e42 	stcleq	14, cr0, [r5], {66}	; 0x42
    17ac:	c1010000 	mrsgt	r0, (UNDEF: 1)
    17b0:	c7000006 	strgt	r0, [r0, -r6]
    17b4:	10000006 	andne	r0, r0, r6
    17b8:	00000824 	andeq	r0, r0, r4, lsr #16
    17bc:	092d1300 	pusheq	{r8, r9, ip}
    17c0:	45060000 	strmi	r0, [r6, #-0]
    17c4:	0004fc17 	andeq	pc, r4, r7, lsl ip	; <UNPREDICTABLE>
    17c8:	00059700 	andeq	r9, r5, r0, lsl #14
    17cc:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    17d0:	06e60000 	strbteq	r0, [r6], r0
    17d4:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    17d8:	00000008 	andeq	r0, r0, r8
    17dc:	00054213 	andeq	r4, r5, r3, lsl r2
    17e0:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    17e4:	00000f41 	andeq	r0, r0, r1, asr #30
    17e8:	00000597 	muleq	r0, r7, r5
    17ec:	0006ff01 	andeq	pc, r6, r1, lsl #30
    17f0:	00070a00 	andeq	r0, r7, r0, lsl #20
    17f4:	084c1000 	stmdaeq	ip, {ip}^
    17f8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    17fc:	00000000 	andeq	r0, r0, r0
    1800:	00117314 	andseq	r7, r1, r4, lsl r3
    1804:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1808:	00000fd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    180c:	00071f01 	andeq	r1, r7, r1, lsl #30
    1810:	00072500 	andeq	r2, r7, r0, lsl #10
    1814:	08241000 	stmdaeq	r4!, {ip}
    1818:	13000000 	movwne	r0, #0
    181c:	00000fb8 			; <UNDEFINED> instruction: 0x00000fb8
    1820:	9a0e4d06 	bls	394c40 <__bss_end+0x38b150>
    1824:	6e000007 	cdpvs	0, 0, cr0, cr0, cr7, {0}
    1828:	01000003 	tsteq	r0, r3
    182c:	0000073e 	andeq	r0, r0, lr, lsr r7
    1830:	00000749 	andeq	r0, r0, r9, asr #14
    1834:	00082410 	andeq	r2, r8, r0, lsl r4
    1838:	004d1100 	subeq	r1, sp, r0, lsl #2
    183c:	13000000 	movwne	r0, #0
    1840:	00000941 	andeq	r0, r0, r1, asr #18
    1844:	e6125006 	ldr	r5, [r2], -r6
    1848:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    184c:	01000000 	mrseq	r0, (UNDEF: 0)
    1850:	00000762 	andeq	r0, r0, r2, ror #14
    1854:	0000076d 	andeq	r0, r0, sp, ror #14
    1858:	00082410 	andeq	r2, r8, r0, lsl r4
    185c:	039d1100 	orrseq	r1, sp, #0, 2
    1860:	13000000 	movwne	r0, #0
    1864:	00000b76 	andeq	r0, r0, r6, ror fp
    1868:	7d0e5306 	stcvc	3, cr5, [lr, #-24]	; 0xffffffe8
    186c:	6e000008 	cdpvs	0, 0, cr0, cr0, cr8, {0}
    1870:	01000003 	tsteq	r0, r3
    1874:	00000786 	andeq	r0, r0, r6, lsl #15
    1878:	00000791 	muleq	r0, r1, r7
    187c:	00082410 	andeq	r2, r8, r0, lsl r4
    1880:	004d1100 	subeq	r1, sp, r0, lsl #2
    1884:	14000000 	strne	r0, [r0], #-0
    1888:	000009a5 	andeq	r0, r0, r5, lsr #19
    188c:	830e5606 	movwhi	r5, #58886	; 0xe606
    1890:	01000010 	tsteq	r0, r0, lsl r0
    1894:	000007a6 	andeq	r0, r0, r6, lsr #15
    1898:	000007c5 	andeq	r0, r0, r5, asr #15
    189c:	00082410 	andeq	r2, r8, r0, lsl r4
    18a0:	00a91100 	adceq	r1, r9, r0, lsl #2
    18a4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18a8:	11000000 	mrsne	r0, (UNDEF: 0)
    18ac:	0000004d 	andeq	r0, r0, sp, asr #32
    18b0:	00004d11 	andeq	r4, r0, r1, lsl sp
    18b4:	08521100 	ldmdaeq	r2, {r8, ip}^
    18b8:	14000000 	strne	r0, [r0], #-0
    18bc:	00000f6e 	andeq	r0, r0, lr, ror #30
    18c0:	c10e5806 	tstgt	lr, r6, lsl #16
    18c4:	01000006 	tsteq	r0, r6
    18c8:	000007da 	ldrdeq	r0, [r0], -sl
    18cc:	000007f9 	strdeq	r0, [r0], -r9
    18d0:	00082410 	andeq	r2, r8, r0, lsl r4
    18d4:	00e01100 	rsceq	r1, r0, r0, lsl #2
    18d8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18dc:	11000000 	mrsne	r0, (UNDEF: 0)
    18e0:	0000004d 	andeq	r0, r0, sp, asr #32
    18e4:	00004d11 	andeq	r4, r0, r1, lsl sp
    18e8:	08521100 	ldmdaeq	r2, {r8, ip}^
    18ec:	15000000 	strne	r0, [r0, #-0]
    18f0:	000005f2 	strdeq	r0, [r0], -r2
    18f4:	530e5b06 	movwpl	r5, #60166	; 0xeb06
    18f8:	6e000006 	cdpvs	0, 0, cr0, cr0, cr6, {0}
    18fc:	01000003 	tsteq	r0, r3
    1900:	0000080e 	andeq	r0, r0, lr, lsl #16
    1904:	00082410 	andeq	r2, r8, r0, lsl r4
    1908:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    190c:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    1910:	00000008 	andeq	r0, r0, r8
    1914:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    1918:	04180000 	ldreq	r0, [r8], #-0
    191c:	0000059d 	muleq	r0, sp, r5
    1920:	0005911e 	andeq	r9, r5, lr, lsl r1
    1924:	00083700 	andeq	r3, r8, r0, lsl #14
    1928:	00083d00 	andeq	r3, r8, r0, lsl #26
    192c:	08241000 	stmdaeq	r4!, {ip}
    1930:	1f000000 	svcne	0x00000000
    1934:	0000059d 	muleq	r0, sp, r5
    1938:	0000082a 	andeq	r0, r0, sl, lsr #16
    193c:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1940:	04180000 	ldreq	r0, [r8], #-0
    1944:	0000081f 	andeq	r0, r0, pc, lsl r8
    1948:	00650420 	rsbeq	r0, r5, r0, lsr #8
    194c:	04210000 	strteq	r0, [r1], #-0
    1950:	000b4d1a 	andeq	r4, fp, sl, lsl sp
    1954:	195e0600 	ldmdbne	lr, {r9, sl}^
    1958:	0000059d 	muleq	r0, sp, r5
    195c:	000bfa0b 	andeq	pc, fp, fp, lsl #20
    1960:	11040700 	tstne	r4, r0, lsl #14
    1964:	0000087f 	andeq	r0, r0, pc, ror r8
    1968:	9ab80305 	bls	fee02584 <__bss_end+0xfedf8a94>
    196c:	04020000 	streq	r0, [r2], #-0
    1970:	001bd804 	andseq	sp, fp, r4, lsl #16
    1974:	08780300 	ldmdaeq	r8!, {r8, r9}^
    1978:	2c160000 	ldccs	0, cr0, [r6], {-0}
    197c:	94000000 	strls	r0, [r0], #-0
    1980:	17000008 	strne	r0, [r0, -r8]
    1984:	0000005e 	andeq	r0, r0, lr, asr r0
    1988:	84030009 	strhi	r0, [r3], #-9
    198c:	22000008 	andcs	r0, r0, #8
    1990:	0000132d 	andeq	r1, r0, sp, lsr #6
    1994:	940ca401 	strls	sl, [ip], #-1025	; 0xfffffbff
    1998:	05000008 	streq	r0, [r0, #-8]
    199c:	009abc03 	addseq	fp, sl, r3, lsl #24
    19a0:	128f2300 	addne	r2, pc, #0, 6
    19a4:	a6010000 	strge	r0, [r1], -r0
    19a8:	0013fc0a 	andseq	pc, r3, sl, lsl #24
    19ac:	00004d00 	andeq	r4, r0, r0, lsl #26
    19b0:	00876c00 	addeq	r6, r7, r0, lsl #24
    19b4:	0000b000 	andeq	fp, r0, r0
    19b8:	099c0100 	ldmibeq	ip, {r8}
    19bc:	24000009 	strcs	r0, [r0], #-9
    19c0:	0000217e 	andeq	r2, r0, lr, ror r1
    19c4:	7b1ba601 	blvc	6eb1d0 <__bss_end+0x6e16e0>
    19c8:	03000003 	movweq	r0, #3
    19cc:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 19d4 <shift+0x19d4>
    19d0:	00001488 	andeq	r1, r0, r8, lsl #9
    19d4:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    19d8:	03000000 	movweq	r0, #0
    19dc:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    19e0:	000013e4 	andeq	r1, r0, r4, ror #7
    19e4:	090aa801 	stmdbeq	sl, {r0, fp, sp, pc}
    19e8:	03000009 	movweq	r0, #9
    19ec:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    19f0:	0000128a 	andeq	r1, r0, sl, lsl #5
    19f4:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    19f8:	02000000 	andeq	r0, r0, #0
    19fc:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1a00:	00000025 	andeq	r0, r0, r5, lsr #32
    1a04:	00000919 	andeq	r0, r0, r9, lsl r9
    1a08:	00005e17 	andeq	r5, r0, r7, lsl lr
    1a0c:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1a10:	00001467 	andeq	r1, r0, r7, ror #8
    1a14:	cc0a9801 	stcgt	8, cr9, [sl], {1}
    1a18:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1a1c:	30000000 	andcc	r0, r0, r0
    1a20:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1a24:	01000000 	mrseq	r0, (UNDEF: 0)
    1a28:	0009569c 	muleq	r9, ip, r6
    1a2c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1a30:	9a010071 	bls	41bfc <__bss_end+0x3810c>
    1a34:	00055720 	andeq	r5, r5, r0, lsr #14
    1a38:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a3c:	0013f122 	andseq	pc, r3, r2, lsr #2
    1a40:	0e9b0100 	fmleqe	f0, f3, f0
    1a44:	0000004d 	andeq	r0, r0, sp, asr #32
    1a48:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1a4c:	00137b27 	andseq	r7, r3, r7, lsr #22
    1a50:	068f0100 	streq	r0, [pc], r0, lsl #2
    1a54:	000012ab 	andeq	r1, r0, fp, lsr #5
    1a58:	000086f4 	strdeq	r8, [r0], -r4
    1a5c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1a60:	098f9c01 	stmibeq	pc, {r0, sl, fp, ip, pc}	; <UNPREDICTABLE>
    1a64:	19240000 	stmdbne	r4!, {}	; <UNPREDICTABLE>
    1a68:	01000013 	tsteq	r0, r3, lsl r0
    1a6c:	004d218f 	subeq	r2, sp, pc, lsl #3
    1a70:	91020000 	mrsls	r0, (UNDEF: 2)
    1a74:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1a78:	91010071 	tstls	r1, r1, ror r0
    1a7c:	00055720 	andeq	r5, r5, r0, lsr #14
    1a80:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a84:	141d2500 	ldrne	r2, [sp], #-1280	; 0xfffffb00
    1a88:	83010000 	movwhi	r0, #4096	; 0x1000
    1a8c:	0013490a 	andseq	r4, r3, sl, lsl #18
    1a90:	00004d00 	andeq	r4, r0, r0, lsl #26
    1a94:	0086b800 	addeq	fp, r6, r0, lsl #16
    1a98:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a9c:	cc9c0100 	ldfgts	f0, [ip], {0}
    1aa0:	26000009 	strcs	r0, [r0], -r9
    1aa4:	00716572 	rsbseq	r6, r1, r2, ror r5
    1aa8:	33208501 			; <UNDEFINED> instruction: 0x33208501
    1aac:	02000005 	andeq	r0, r0, #5
    1ab0:	83227491 			; <UNDEFINED> instruction: 0x83227491
    1ab4:	01000012 	tsteq	r0, r2, lsl r0
    1ab8:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1abc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ac0:	6a250070 	bvs	941c88 <__bss_end+0x938198>
    1ac4:	01000015 	tsteq	r0, r5, lsl r0
    1ac8:	12ef0a77 	rscne	r0, pc, #487424	; 0x77000
    1acc:	004d0000 	subeq	r0, sp, r0
    1ad0:	867c0000 	ldrbthi	r0, [ip], -r0
    1ad4:	003c0000 	eorseq	r0, ip, r0
    1ad8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1adc:	00000a09 	andeq	r0, r0, r9, lsl #20
    1ae0:	71657226 	cmnvc	r5, r6, lsr #4
    1ae4:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1ae8:	00000533 	andeq	r0, r0, r3, lsr r5
    1aec:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1af0:	00001283 	andeq	r1, r0, r3, lsl #5
    1af4:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    1af8:	02000000 	andeq	r0, r0, #0
    1afc:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1b00:	0000135d 	andeq	r1, r0, sp, asr r3
    1b04:	9c066b01 			; <UNDEFINED> instruction: 0x9c066b01
    1b08:	6e000014 	mcrvs	0, 0, r0, cr0, cr4, {0}
    1b0c:	28000003 	stmdacs	r0, {r0, r1}
    1b10:	54000086 	strpl	r0, [r0], #-134	; 0xffffff7a
    1b14:	01000000 	mrseq	r0, (UNDEF: 0)
    1b18:	000a559c 	muleq	sl, ip, r5
    1b1c:	13f12400 	mvnsne	r2, #0, 8
    1b20:	6b010000 	blvs	41b28 <__bss_end+0x38038>
    1b24:	00004d15 	andeq	r4, r0, r5, lsl sp
    1b28:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b2c:	00049c24 	andeq	r9, r4, r4, lsr #24
    1b30:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1b34:	0000004d 	andeq	r0, r0, sp, asr #32
    1b38:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1b3c:	00001562 	andeq	r1, r0, r2, ror #10
    1b40:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    1b44:	02000000 	andeq	r0, r0, #0
    1b48:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b4c:	000012c2 	andeq	r1, r0, r2, asr #5
    1b50:	03125e01 	tsteq	r2, #1, 28
    1b54:	8b000015 	blhi	1bb0 <shift+0x1bb0>
    1b58:	d8000000 	stmdale	r0, {}	; <UNPREDICTABLE>
    1b5c:	50000085 	andpl	r0, r0, r5, lsl #1
    1b60:	01000000 	mrseq	r0, (UNDEF: 0)
    1b64:	000ab09c 	muleq	sl, ip, r0
    1b68:	11f02400 	mvnsne	r2, r0, lsl #8
    1b6c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b70:	00004d20 	andeq	r4, r0, r0, lsr #26
    1b74:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b78:	00142624 	andseq	r2, r4, r4, lsr #12
    1b7c:	2f5e0100 	svccs	0x005e0100
    1b80:	0000004d 	andeq	r0, r0, sp, asr #32
    1b84:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1b88:	0000049c 	muleq	r0, ip, r4
    1b8c:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 1b90 <shift+0x1b90>
    1b90:	02000000 	andeq	r0, r0, #0
    1b94:	62226491 	eorvs	r6, r2, #-1862270976	; 0x91000000
    1b98:	01000015 	tsteq	r0, r5, lsl r0
    1b9c:	008b1660 	addeq	r1, fp, r0, ror #12
    1ba0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba4:	ea250074 	b	941d7c <__bss_end+0x93828c>
    1ba8:	01000013 	tsteq	r0, r3, lsl r0
    1bac:	12c70a52 	sbcne	r0, r7, #335872	; 0x52000
    1bb0:	004d0000 	subeq	r0, sp, r0
    1bb4:	85940000 	ldrhi	r0, [r4]
    1bb8:	00440000 	subeq	r0, r4, r0
    1bbc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bc0:	00000afc 	strdeq	r0, [r0], -ip
    1bc4:	0011f024 	andseq	pc, r1, r4, lsr #32
    1bc8:	1a520100 	bne	1481fd0 <__bss_end+0x14784e0>
    1bcc:	0000004d 	andeq	r0, r0, sp, asr #32
    1bd0:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1bd4:	00001426 	andeq	r1, r0, r6, lsr #8
    1bd8:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1bdc:	02000000 	andeq	r0, r0, #0
    1be0:	32226891 	eorcc	r6, r2, #9502720	; 0x910000
    1be4:	01000015 	tsteq	r0, r5, lsl r0
    1be8:	004d0e54 	subeq	r0, sp, r4, asr lr
    1bec:	91020000 	mrsls	r0, (UNDEF: 2)
    1bf0:	2c250074 	stccs	0, cr0, [r5], #-464	; 0xfffffe30
    1bf4:	01000015 	tsteq	r0, r5, lsl r0
    1bf8:	150e0a45 	strne	r0, [lr, #-2629]	; 0xfffff5bb
    1bfc:	004d0000 	subeq	r0, sp, r0
    1c00:	85440000 	strbhi	r0, [r4, #-0]
    1c04:	00500000 	subseq	r0, r0, r0
    1c08:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c0c:	00000b57 	andeq	r0, r0, r7, asr fp
    1c10:	0011f024 	andseq	pc, r1, r4, lsr #32
    1c14:	19450100 	stmdbne	r5, {r8}^
    1c18:	0000004d 	andeq	r0, r0, sp, asr #32
    1c1c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1c20:	0000138d 	andeq	r1, r0, sp, lsl #7
    1c24:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1c28:	02000001 	andeq	r0, r0, #1
    1c2c:	53246891 			; <UNDEFINED> instruction: 0x53246891
    1c30:	01000014 	tsteq	r0, r4, lsl r0
    1c34:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1c38:	91020000 	mrsls	r0, (UNDEF: 2)
    1c3c:	15622264 	strbne	r2, [r2, #-612]!	; 0xfffffd9c
    1c40:	47010000 	strmi	r0, [r1, -r0]
    1c44:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c4c:	12702700 	rsbsne	r2, r0, #0, 14
    1c50:	3f010000 	svccc	0x00010000
    1c54:	00139706 	andseq	r9, r3, r6, lsl #14
    1c58:	00851800 	addeq	r1, r5, r0, lsl #16
    1c5c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1c60:	819c0100 	orrshi	r0, ip, r0, lsl #2
    1c64:	2400000b 	strcs	r0, [r0], #-11
    1c68:	000011f0 	strdeq	r1, [r0], -r0
    1c6c:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1c70:	02000000 	andeq	r0, r0, #0
    1c74:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c78:	00001482 	andeq	r1, r0, r2, lsl #9
    1c7c:	590a3201 	stmdbpl	sl, {r0, r9, ip, sp}
    1c80:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1c84:	c8000000 	stmdagt	r0, {}	; <UNPREDICTABLE>
    1c88:	50000084 	andpl	r0, r0, r4, lsl #1
    1c8c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c90:	000bdc9c 	muleq	fp, ip, ip
    1c94:	11f02400 	mvnsne	r2, r0, lsl #8
    1c98:	32010000 	andcc	r0, r1, #0
    1c9c:	00004d19 	andeq	r4, r0, r9, lsl sp
    1ca0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ca4:	00153e24 	andseq	r3, r5, r4, lsr #28
    1ca8:	2b320100 	blcs	c820b0 <__bss_end+0xc785c0>
    1cac:	0000037b 	andeq	r0, r0, fp, ror r3
    1cb0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1cb4:	0000148c 	andeq	r1, r0, ip, lsl #9
    1cb8:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1cbc:	02000000 	andeq	r0, r0, #0
    1cc0:	fd226491 	stc2	4, cr6, [r2, #-580]!	; 0xfffffdbc
    1cc4:	01000014 	tsteq	r0, r4, lsl r0
    1cc8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1ccc:	91020000 	mrsls	r0, (UNDEF: 2)
    1cd0:	8c250074 	stchi	0, cr0, [r5], #-464	; 0xfffffe30
    1cd4:	01000015 	tsteq	r0, r5, lsl r0
    1cd8:	15450a25 	strbne	r0, [r5, #-2597]	; 0xfffff5db
    1cdc:	004d0000 	subeq	r0, sp, r0
    1ce0:	84780000 	ldrbthi	r0, [r8], #-0
    1ce4:	00500000 	subseq	r0, r0, r0
    1ce8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cec:	00000c37 	andeq	r0, r0, r7, lsr ip
    1cf0:	0011f024 	andseq	pc, r1, r4, lsr #32
    1cf4:	18250100 	stmdane	r5!, {r8}
    1cf8:	0000004d 	andeq	r0, r0, sp, asr #32
    1cfc:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d00:	0000153e 	andeq	r1, r0, lr, lsr r5
    1d04:	3d2a2501 	cfstr32cc	mvfx2, [sl, #-4]!
    1d08:	0200000c 	andeq	r0, r0, #12
    1d0c:	8c246891 	stchi	8, cr6, [r4], #-580	; 0xfffffdbc
    1d10:	01000014 	tsteq	r0, r4, lsl r0
    1d14:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1d18:	91020000 	mrsls	r0, (UNDEF: 2)
    1d1c:	12942264 	addsne	r2, r4, #100, 4	; 0x40000006
    1d20:	27010000 	strcs	r0, [r1, -r0]
    1d24:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d28:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d2c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1d30:	03000000 	movweq	r0, #0
    1d34:	00000c37 	andeq	r0, r0, r7, lsr ip
    1d38:	0013f725 	andseq	pc, r3, r5, lsr #14
    1d3c:	0a190100 	beq	642144 <__bss_end+0x638654>
    1d40:	000015a2 	andeq	r1, r0, r2, lsr #11
    1d44:	0000004d 	andeq	r0, r0, sp, asr #32
    1d48:	00008434 	andeq	r8, r0, r4, lsr r4
    1d4c:	00000044 	andeq	r0, r0, r4, asr #32
    1d50:	0c8e9c01 	stceq	12, cr9, [lr], {1}
    1d54:	83240000 			; <UNDEFINED> instruction: 0x83240000
    1d58:	01000015 	tsteq	r0, r5, lsl r0
    1d5c:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1d60:	91020000 	mrsls	r0, (UNDEF: 2)
    1d64:	1539246c 	ldrne	r2, [r9, #-1132]!	; 0xfffffb94
    1d68:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1d6c:	0001c635 	andeq	ip, r1, r5, lsr r6
    1d70:	68910200 	ldmvs	r1, {r9}
    1d74:	0011f022 	andseq	pc, r1, r2, lsr #32
    1d78:	0e1b0100 	mufeqe	f0, f3, f0
    1d7c:	0000004d 	andeq	r0, r0, sp, asr #32
    1d80:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1d84:	00130d28 	andseq	r0, r3, r8, lsr #26
    1d88:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1d8c:	0000129a 	muleq	r0, sl, r2
    1d90:	00008418 	andeq	r8, r0, r8, lsl r4
    1d94:	0000001c 	andeq	r0, r0, ip, lsl r0
    1d98:	91279c01 			; <UNDEFINED> instruction: 0x91279c01
    1d9c:	01000015 	tsteq	r0, r5, lsl r0
    1da0:	12d3060e 	sbcsne	r0, r3, #14680064	; 0xe00000
    1da4:	83ec0000 	mvnhi	r0, #0
    1da8:	002c0000 	eoreq	r0, ip, r0
    1dac:	9c010000 	stcls	0, cr0, [r1], {-0}
    1db0:	00000cce 	andeq	r0, r0, lr, asr #25
    1db4:	0012e624 	andseq	lr, r2, r4, lsr #12
    1db8:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1dbc:	00000038 	andeq	r0, r0, r8, lsr r0
    1dc0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1dc4:	00159b29 	andseq	r9, r5, r9, lsr #22
    1dc8:	0a040100 	beq	1021d0 <__bss_end+0xf86e0>
    1dcc:	000013d9 	ldrdeq	r1, [r0], -r9
    1dd0:	0000004d 	andeq	r0, r0, sp, asr #32
    1dd4:	000083c0 	andeq	r8, r0, r0, asr #7
    1dd8:	0000002c 	andeq	r0, r0, ip, lsr #32
    1ddc:	70269c01 	eorvc	r9, r6, r1, lsl #24
    1de0:	01006469 	tsteq	r0, r9, ror #8
    1de4:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1de8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dec:	f9000074 			; <UNDEFINED> instruction: 0xf9000074
    1df0:	04000006 	streq	r0, [r0], #-6
    1df4:	00072b00 	andeq	r2, r7, r0, lsl #22
    1df8:	be010400 	cfcpyslt	mvf0, mvf1
    1dfc:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    1e00:	000016a1 	andeq	r1, r0, r1, lsr #13
    1e04:	0000142c 	andeq	r1, r0, ip, lsr #8
    1e08:	0000881c 	andeq	r8, r0, ip, lsl r8
    1e0c:	00000fdc 	ldrdeq	r0, [r0], -ip
    1e10:	00000752 	andeq	r0, r0, r2, asr r7
    1e14:	000bfa02 	andeq	pc, fp, r2, lsl #20
    1e18:	11040200 	mrsne	r0, R12_usr
    1e1c:	0000003e 	andeq	r0, r0, lr, lsr r0
    1e20:	9ac80305 	bls	ff202a3c <__bss_end+0xff1f8f4c>
    1e24:	04030000 	streq	r0, [r3], #-0
    1e28:	001bd804 	andseq	sp, fp, r4, lsl #16
    1e2c:	00370400 	eorseq	r0, r7, r0, lsl #8
    1e30:	67050000 	strvs	r0, [r5, -r0]
    1e34:	06000000 	streq	r0, [r0], -r0
    1e38:	000017e1 	andeq	r1, r0, r1, ror #15
    1e3c:	7f100501 	svcvc	0x00100501
    1e40:	11000000 	mrsne	r0, (UNDEF: 0)
    1e44:	33323130 	teqcc	r2, #48, 2
    1e48:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1e4c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1e50:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1e54:	01070000 	mrseq	r0, (UNDEF: 7)
    1e58:	00430103 	subeq	r0, r3, r3, lsl #2
    1e5c:	97080000 	strls	r0, [r8, -r0]
    1e60:	7f000000 	svcvc	0x00000000
    1e64:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1e68:	00000084 	andeq	r0, r0, r4, lsl #1
    1e6c:	6f040010 	svcvs	0x00040010
    1e70:	03000000 	movweq	r0, #0
    1e74:	1e0e0704 	cdpne	7, 0, cr0, cr14, cr4, {0}
    1e78:	84040000 	strhi	r0, [r4], #-0
    1e7c:	03000000 	movweq	r0, #0
    1e80:	0d4e0801 	stcleq	8, cr0, [lr, #-4]
    1e84:	90040000 	andls	r0, r4, r0
    1e88:	0a000000 	beq	1e90 <shift+0x1e90>
    1e8c:	00000048 	andeq	r0, r0, r8, asr #32
    1e90:	0017d50b 	andseq	sp, r7, fp, lsl #10
    1e94:	07fc0100 	ldrbeq	r0, [ip, r0, lsl #2]!
    1e98:	0000174c 	andeq	r1, r0, ip, asr #14
    1e9c:	00000037 	andeq	r0, r0, r7, lsr r0
    1ea0:	000096e8 	andeq	r9, r0, r8, ror #13
    1ea4:	00000110 	andeq	r0, r0, r0, lsl r1
    1ea8:	011d9c01 	tsteq	sp, r1, lsl #24
    1eac:	730c0000 	movwvc	r0, #49152	; 0xc000
    1eb0:	18fc0100 	ldmne	ip!, {r8}^
    1eb4:	0000011d 	andeq	r0, r0, sp, lsl r1
    1eb8:	0d649102 	stfeqp	f1, [r4, #-8]!
    1ebc:	007a6572 	rsbseq	r6, sl, r2, ror r5
    1ec0:	3709fe01 	strcc	pc, [r9, -r1, lsl #28]
    1ec4:	02000000 	andeq	r0, r0, #0
    1ec8:	6f0e7491 	svcvs	0x000e7491
    1ecc:	01000018 	tsteq	r0, r8, lsl r0
    1ed0:	003712fe 	ldrshteq	r1, [r7], -lr
    1ed4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ed8:	972c0f70 			; <UNDEFINED> instruction: 0x972c0f70
    1edc:	00a80000 	adceq	r0, r8, r0
    1ee0:	13100000 	tstne	r0, #0
    1ee4:	01000017 	tsteq	r0, r7, lsl r0
    1ee8:	230c0103 	movwcs	r0, #49411	; 0xc103
    1eec:	02000001 	andeq	r0, r0, #1
    1ef0:	440f6c91 	strmi	r6, [pc], #-3217	; 1ef8 <shift+0x1ef8>
    1ef4:	80000097 	mulhi	r0, r7, r0
    1ef8:	11000000 	mrsne	r0, (UNDEF: 0)
    1efc:	08010064 	stmdaeq	r1, {r2, r5, r6}
    1f00:	01230901 			; <UNDEFINED> instruction: 0x01230901
    1f04:	91020000 	mrsls	r0, (UNDEF: 2)
    1f08:	00000068 	andeq	r0, r0, r8, rrx
    1f0c:	00970412 	addseq	r0, r7, r2, lsl r4
    1f10:	04130000 	ldreq	r0, [r3], #-0
    1f14:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1f18:	17ed1400 	strbne	r1, [sp, r0, lsl #8]!
    1f1c:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1f20:	00185706 	andseq	r5, r8, r6, lsl #14
    1f24:	0093c400 	addseq	ip, r3, r0, lsl #8
    1f28:	00032400 	andeq	r2, r3, r0, lsl #8
    1f2c:	299c0100 	ldmibcs	ip, {r8}
    1f30:	0c000002 	stceq	0, cr0, [r0], {2}
    1f34:	c1010078 	tstgt	r1, r8, ror r0
    1f38:	00003711 	andeq	r3, r0, r1, lsl r7
    1f3c:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    1f40:	66620c7f 			; <UNDEFINED> instruction: 0x66620c7f
    1f44:	c1010072 	tstgt	r1, r2, ror r0
    1f48:	0002291a 	andeq	r2, r2, sl, lsl r9
    1f4c:	a0910300 	addsge	r0, r1, r0, lsl #6
    1f50:	1725157f 			; <UNDEFINED> instruction: 0x1725157f
    1f54:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1f58:	00008b32 	andeq	r8, r0, r2, lsr fp
    1f5c:	9c910300 	ldcls	3, cr0, [r1], {0}
    1f60:	18300e7f 	ldmdane	r0!, {r0, r1, r2, r3, r4, r5, r6, r9, sl, fp}
    1f64:	c3010000 	movwgt	r0, #4096	; 0x1000
    1f68:	0000840f 	andeq	r8, r0, pc, lsl #8
    1f6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f70:	0018190e 	andseq	r1, r8, lr, lsl #18
    1f74:	06d90100 	ldrbeq	r0, [r9], r0, lsl #2
    1f78:	00000123 	andeq	r0, r0, r3, lsr #2
    1f7c:	0e709102 	expeqs	f1, f2
    1f80:	0000172e 	andeq	r1, r0, lr, lsr #14
    1f84:	3e11dd01 	cdpcc	13, 1, cr13, cr1, cr1, {0}
    1f88:	02000000 	andeq	r0, r0, #0
    1f8c:	eb0e6491 	bl	39b1d8 <__bss_end+0x3916e8>
    1f90:	01000016 	tsteq	r0, r6, lsl r0
    1f94:	008b18e0 	addeq	r1, fp, r0, ror #17
    1f98:	91020000 	mrsls	r0, (UNDEF: 2)
    1f9c:	16fa0e60 	ldrbtne	r0, [sl], r0, ror #28
    1fa0:	e1010000 	mrs	r0, (UNDEF: 1)
    1fa4:	00008b18 	andeq	r8, r0, r8, lsl fp
    1fa8:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1fac:	0017a00e 	andseq	sl, r7, lr
    1fb0:	07e30100 	strbeq	r0, [r3, r0, lsl #2]!
    1fb4:	0000022f 	andeq	r0, r0, pc, lsr #4
    1fb8:	7fb89103 	svcvc	0x00b89103
    1fbc:	0017340e 	andseq	r3, r7, lr, lsl #8
    1fc0:	06e50100 	strbteq	r0, [r5], r0, lsl #2
    1fc4:	00000123 	andeq	r0, r0, r3, lsr #2
    1fc8:	16589102 	ldrbne	r9, [r8], -r2, lsl #2
    1fcc:	000095d0 	ldrdeq	r9, [r0], -r0
    1fd0:	00000050 	andeq	r0, r0, r0, asr r0
    1fd4:	000001f7 	strdeq	r0, [r0], -r7
    1fd8:	0100690d 	tsteq	r0, sp, lsl #18
    1fdc:	01230be7 	smulwteq	r3, r7, fp
    1fe0:	91020000 	mrsls	r0, (UNDEF: 2)
    1fe4:	2c0f006c 	stccs	0, cr0, [pc], {108}	; 0x6c
    1fe8:	98000096 	stmdals	r0, {r1, r2, r4, r7}
    1fec:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1ff0:	0000171e 	andeq	r1, r0, lr, lsl r7
    1ff4:	3f08ef01 	svccc	0x0008ef01
    1ff8:	03000002 	movweq	r0, #2
    1ffc:	0f7fac91 	svceq	0x007fac91
    2000:	0000965c 	andeq	r9, r0, ip, asr r6
    2004:	00000068 	andeq	r0, r0, r8, rrx
    2008:	0100690d 	tsteq	r0, sp, lsl #18
    200c:	01230cf2 	strdeq	r0, [r3, -r2]!
    2010:	91020000 	mrsls	r0, (UNDEF: 2)
    2014:	00000068 	andeq	r0, r0, r8, rrx
    2018:	00900412 	addseq	r0, r0, r2, lsl r4
    201c:	90080000 	andls	r0, r8, r0
    2020:	3f000000 	svccc	0x00000000
    2024:	09000002 	stmdbeq	r0, {r1}
    2028:	00000084 	andeq	r0, r0, r4, lsl #1
    202c:	9008001f 	andls	r0, r8, pc, lsl r0
    2030:	4f000000 	svcmi	0x00000000
    2034:	09000002 	stmdbeq	r0, {r1}
    2038:	00000084 	andeq	r0, r0, r4, lsl #1
    203c:	ed140008 	ldc	0, cr0, [r4, #-32]	; 0xffffffe0
    2040:	01000017 	tsteq	r0, r7, lsl r0
    2044:	18bc06bb 	ldmne	ip!, {r0, r1, r3, r4, r5, r7, r9, sl}
    2048:	93940000 	orrsls	r0, r4, #0
    204c:	00300000 	eorseq	r0, r0, r0
    2050:	9c010000 	stcls	0, cr0, [r1], {-0}
    2054:	00000286 	andeq	r0, r0, r6, lsl #5
    2058:	0100780c 	tsteq	r0, ip, lsl #16
    205c:	003711bb 	ldrhteq	r1, [r7], -fp
    2060:	91020000 	mrsls	r0, (UNDEF: 2)
    2064:	66620c74 			; <UNDEFINED> instruction: 0x66620c74
    2068:	bb010072 	bllt	42238 <__bss_end+0x38748>
    206c:	0002291a 	andeq	r2, r2, sl, lsl r9
    2070:	70910200 	addsvc	r0, r1, r0, lsl #4
    2074:	16f40b00 	ldrbtne	r0, [r4], r0, lsl #22
    2078:	b5010000 	strlt	r0, [r1, #-0]
    207c:	0017ab06 	andseq	sl, r7, r6, lsl #22
    2080:	0002b200 	andeq	fp, r2, r0, lsl #4
    2084:	00935400 	addseq	r5, r3, r0, lsl #8
    2088:	00004000 	andeq	r4, r0, r0
    208c:	b29c0100 	addslt	r0, ip, #0, 2
    2090:	0c000002 	stceq	0, cr0, [r0], {2}
    2094:	b5010078 	strlt	r0, [r1, #-120]	; 0xffffff88
    2098:	00003712 	andeq	r3, r0, r2, lsl r7
    209c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    20a0:	02010300 	andeq	r0, r1, #0, 6
    20a4:	00000a5f 	andeq	r0, r0, pc, asr sl
    20a8:	0016e50b 	andseq	lr, r6, fp, lsl #10
    20ac:	06b00100 	ldrteq	r0, [r0], r0, lsl #2
    20b0:	00001768 	andeq	r1, r0, r8, ror #14
    20b4:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    20b8:	00009318 	andeq	r9, r0, r8, lsl r3
    20bc:	0000003c 	andeq	r0, r0, ip, lsr r0
    20c0:	02e59c01 	rsceq	r9, r5, #256	; 0x100
    20c4:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    20c8:	12b00100 	adcsne	r0, r0, #0, 2
    20cc:	00000037 	andeq	r0, r0, r7, lsr r0
    20d0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    20d4:	0018a414 	andseq	sl, r8, r4, lsl r4
    20d8:	06a50100 	strteq	r0, [r5], r0, lsl #2
    20dc:	000017f2 	strdeq	r1, [r0], -r2
    20e0:	00009244 	andeq	r9, r0, r4, asr #4
    20e4:	000000d4 	ldrdeq	r0, [r0], -r4
    20e8:	033a9c01 	teqeq	sl, #256	; 0x100
    20ec:	780c0000 	stmdavc	ip, {}	; <UNPREDICTABLE>
    20f0:	2ba50100 	blcs	fe9424f8 <__bss_end+0xfe938a08>
    20f4:	00000084 	andeq	r0, r0, r4, lsl #1
    20f8:	0c6c9102 	stfeqp	f1, [ip], #-8
    20fc:	00726662 	rsbseq	r6, r2, r2, ror #12
    2100:	2934a501 	ldmdbcs	r4!, {r0, r8, sl, sp, pc}
    2104:	02000002 	andeq	r0, r0, #2
    2108:	3e156891 	mrccc	8, 0, r6, cr5, cr1, {4}
    210c:	01000018 	tsteq	r0, r8, lsl r0
    2110:	01233da5 			; <UNDEFINED> instruction: 0x01233da5
    2114:	91020000 	mrsls	r0, (UNDEF: 2)
    2118:	18300e64 	ldmdane	r0!, {r2, r5, r6, r9, sl, fp}
    211c:	a7010000 	strge	r0, [r1, -r0]
    2120:	00012306 	andeq	r2, r1, r6, lsl #6
    2124:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2128:	18631700 	stmdane	r3!, {r8, r9, sl, ip}^
    212c:	83010000 	movwhi	r0, #4096	; 0x1000
    2130:	0017be06 	andseq	fp, r7, r6, lsl #28
    2134:	008e0400 	addeq	r0, lr, r0, lsl #8
    2138:	00044000 	andeq	r4, r4, r0
    213c:	9e9c0100 	fmllse	f0, f4, f0
    2140:	0c000003 	stceq	0, cr0, [r0], {3}
    2144:	83010078 	movwhi	r0, #4216	; 0x1078
    2148:	00003718 	andeq	r3, r0, r8, lsl r7
    214c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2150:	0016eb15 	andseq	lr, r6, r5, lsl fp
    2154:	29830100 	stmibcs	r3, {r8}
    2158:	0000039e 	muleq	r0, lr, r3
    215c:	15689102 	strbne	r9, [r8, #-258]!	; 0xfffffefe
    2160:	000016fa 	strdeq	r1, [r0], -sl
    2164:	9e418301 	cdpls	3, 4, cr8, cr1, cr1, {0}
    2168:	02000003 	andeq	r0, r0, #3
    216c:	43156491 	tstmi	r5, #-1862270976	; 0x91000000
    2170:	01000017 	tsteq	r0, r7, lsl r0
    2174:	03a44f83 			; <UNDEFINED> instruction: 0x03a44f83
    2178:	91020000 	mrsls	r0, (UNDEF: 2)
    217c:	16db0e60 	ldrbne	r0, [fp], r0, ror #28
    2180:	96010000 	strls	r0, [r1], -r0
    2184:	0000370b 	andeq	r3, r0, fp, lsl #14
    2188:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    218c:	84041800 	strhi	r1, [r4], #-2048	; 0xfffff800
    2190:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    2194:	00012304 	andeq	r2, r1, r4, lsl #6
    2198:	18dc1400 	ldmne	ip, {sl, ip}^
    219c:	76010000 	strvc	r0, [r1], -r0
    21a0:	00175c06 	andseq	r5, r7, r6, lsl #24
    21a4:	008d4000 	addeq	r4, sp, r0
    21a8:	0000c400 	andeq	ip, r0, r0, lsl #8
    21ac:	ff9c0100 			; <UNDEFINED> instruction: 0xff9c0100
    21b0:	15000003 	strne	r0, [r0, #-3]
    21b4:	0000179b 	muleq	r0, fp, r7
    21b8:	29137601 	ldmdbcs	r3, {r0, r9, sl, ip, sp, lr}
    21bc:	02000002 	andeq	r0, r0, #2
    21c0:	690d6491 	stmdbvs	sp, {r0, r4, r7, sl, sp, lr}
    21c4:	09780100 	ldmdbeq	r8!, {r8}^
    21c8:	00000123 	andeq	r0, r0, r3, lsr #2
    21cc:	0d749102 	ldfeqp	f1, [r4, #-8]!
    21d0:	006e656c 	rsbeq	r6, lr, ip, ror #10
    21d4:	230c7801 	movwcs	r7, #51201	; 0xc801
    21d8:	02000001 	andeq	r0, r0, #1
    21dc:	7d0e7091 	stcvc	0, cr7, [lr, #-580]	; 0xfffffdbc
    21e0:	01000017 	tsteq	r0, r7, lsl r0
    21e4:	01231178 			; <UNDEFINED> instruction: 0x01231178
    21e8:	91020000 	mrsls	r0, (UNDEF: 2)
    21ec:	7019006c 	andsvc	r0, r9, ip, rrx
    21f0:	0100776f 	tsteq	r0, pc, ror #14
    21f4:	17b5076d 	ldrne	r0, [r5, sp, ror #14]!
    21f8:	00370000 	eorseq	r0, r7, r0
    21fc:	8cd40000 	ldclhi	0, cr0, [r4], {0}
    2200:	006c0000 	rsbeq	r0, ip, r0
    2204:	9c010000 	stcls	0, cr0, [r1], {-0}
    2208:	0000045c 	andeq	r0, r0, ip, asr r4
    220c:	0100780c 	tsteq	r0, ip, lsl #16
    2210:	003e176d 	eorseq	r1, lr, sp, ror #14
    2214:	91020000 	mrsls	r0, (UNDEF: 2)
    2218:	006e0c6c 	rsbeq	r0, lr, ip, ror #24
    221c:	8b2d6d01 	blhi	b5d628 <__bss_end+0xb53b38>
    2220:	02000000 	andeq	r0, r0, #0
    2224:	720d6891 	andvc	r6, sp, #9502720	; 0x910000
    2228:	0b6f0100 	bleq	1bc2630 <__bss_end+0x1bb8b40>
    222c:	00000037 	andeq	r0, r0, r7, lsr r0
    2230:	0f749102 	svceq	0x00749102
    2234:	00008cf0 	strdeq	r8, [r0], -r0
    2238:	00000038 	andeq	r0, r0, r8, lsr r0
    223c:	0100690d 	tsteq	r0, sp, lsl #18
    2240:	00841670 	addeq	r1, r4, r0, ror r6
    2244:	91020000 	mrsls	r0, (UNDEF: 2)
    2248:	17000070 	smlsdxne	r0, r0, r0, r0
    224c:	00001829 	andeq	r1, r0, r9, lsr #16
    2250:	91066401 	tstls	r6, r1, lsl #8
    2254:	54000016 	strpl	r0, [r0], #-22	; 0xffffffea
    2258:	8000008c 	andhi	r0, r0, ip, lsl #1
    225c:	01000000 	mrseq	r0, (UNDEF: 0)
    2260:	0004d99c 	muleq	r4, ip, r9
    2264:	72730c00 	rsbsvc	r0, r3, #0, 24
    2268:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    226c:	0004d919 	andeq	sp, r4, r9, lsl r9
    2270:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2274:	7473640c 	ldrbtvc	r6, [r3], #-1036	; 0xfffffbf4
    2278:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    227c:	000004e0 	andeq	r0, r0, r0, ror #9
    2280:	0c609102 	stfeqp	f1, [r0], #-8
    2284:	006d756e 	rsbeq	r7, sp, lr, ror #10
    2288:	232d6401 			; <UNDEFINED> instruction: 0x232d6401
    228c:	02000001 	andeq	r0, r0, #1
    2290:	120e5c91 	andne	r5, lr, #37120	; 0x9100
    2294:	01000018 	tsteq	r0, r8, lsl r0
    2298:	011d0e66 	tsteq	sp, r6, ror #28
    229c:	91020000 	mrsls	r0, (UNDEF: 2)
    22a0:	17da0e70 			; <UNDEFINED> instruction: 0x17da0e70
    22a4:	67010000 	strvs	r0, [r1, -r0]
    22a8:	00022908 	andeq	r2, r2, r8, lsl #18
    22ac:	6c910200 	lfmvs	f0, 4, [r1], {0}
    22b0:	008c7c0f 	addeq	r7, ip, pc, lsl #24
    22b4:	00004800 	andeq	r4, r0, r0, lsl #16
    22b8:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    22bc:	230b6901 	movwcs	r6, #47361	; 0xb901
    22c0:	02000001 	andeq	r0, r0, #1
    22c4:	00007491 	muleq	r0, r1, r4
    22c8:	04df0412 	ldrbeq	r0, [pc], #1042	; 22d0 <shift+0x22d0>
    22cc:	1b1a0000 	blne	6822d4 <__bss_end+0x6787e4>
    22d0:	18231704 	stmdane	r3!, {r2, r8, r9, sl, ip}
    22d4:	5c010000 	stcpl	0, cr0, [r1], {-0}
    22d8:	00178206 	andseq	r8, r7, r6, lsl #4
    22dc:	008bec00 	addeq	lr, fp, r0, lsl #24
    22e0:	00006800 	andeq	r6, r0, r0, lsl #16
    22e4:	419c0100 	orrsmi	r0, ip, r0, lsl #2
    22e8:	15000005 	strne	r0, [r0, #-5]
    22ec:	000018c7 	andeq	r1, r0, r7, asr #17
    22f0:	e0125c01 	ands	r5, r2, r1, lsl #24
    22f4:	02000004 	andeq	r0, r0, #4
    22f8:	ce156c91 	mrcgt	12, 0, r6, cr5, cr1, {4}
    22fc:	01000018 	tsteq	r0, r8, lsl r0
    2300:	01231e5c 			; <UNDEFINED> instruction: 0x01231e5c
    2304:	91020000 	mrsls	r0, (UNDEF: 2)
    2308:	656d0d68 	strbvs	r0, [sp, #-3432]!	; 0xfffff298
    230c:	5e01006d 	cdppl	0, 0, cr0, cr1, cr13, {3}
    2310:	00022908 	andeq	r2, r2, r8, lsl #18
    2314:	70910200 	addsvc	r0, r1, r0, lsl #4
    2318:	008c080f 	addeq	r0, ip, pc, lsl #16
    231c:	00003c00 	andeq	r3, r0, r0, lsl #24
    2320:	00690d00 	rsbeq	r0, r9, r0, lsl #26
    2324:	230b6001 	movwcs	r6, #45057	; 0xb001
    2328:	02000001 	andeq	r0, r0, #1
    232c:	00007491 	muleq	r0, r1, r4
    2330:	0018d50b 	andseq	sp, r8, fp, lsl #10
    2334:	05520100 	ldrbeq	r0, [r2, #-256]	; 0xffffff00
    2338:	00001874 	andeq	r1, r0, r4, ror r8
    233c:	00000123 	andeq	r0, r0, r3, lsr #2
    2340:	00008b98 	muleq	r0, r8, fp
    2344:	00000054 	andeq	r0, r0, r4, asr r0
    2348:	057a9c01 	ldrbeq	r9, [sl, #-3073]!	; 0xfffff3ff
    234c:	730c0000 	movwvc	r0, #49152	; 0xc000
    2350:	18520100 	ldmdane	r2, {r8}^
    2354:	0000011d 	andeq	r0, r0, sp, lsl r1
    2358:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    235c:	54010069 	strpl	r0, [r1], #-105	; 0xffffff97
    2360:	00012306 	andeq	r2, r1, r6, lsl #6
    2364:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2368:	18360b00 	ldmdane	r6!, {r8, r9, fp}
    236c:	42010000 	andmi	r0, r1, #0
    2370:	00188105 	andseq	r8, r8, r5, lsl #2
    2374:	00012300 	andeq	r2, r1, r0, lsl #6
    2378:	008aec00 	addeq	lr, sl, r0, lsl #24
    237c:	0000ac00 	andeq	sl, r0, r0, lsl #24
    2380:	e09c0100 	adds	r0, ip, r0, lsl #2
    2384:	0c000005 	stceq	0, cr0, [r0], {5}
    2388:	01003173 	tsteq	r0, r3, ror r1
    238c:	011d1942 	tsteq	sp, r2, asr #18
    2390:	91020000 	mrsls	r0, (UNDEF: 2)
    2394:	32730c6c 	rsbscc	r0, r3, #108, 24	; 0x6c00
    2398:	29420100 	stmdbcs	r2, {r8}^
    239c:	0000011d 	andeq	r0, r0, sp, lsl r1
    23a0:	0c689102 	stfeqp	f1, [r8], #-8
    23a4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    23a8:	23314201 	teqcs	r1, #268435456	; 0x10000000
    23ac:	02000001 	andeq	r0, r0, #1
    23b0:	750d6491 	strvc	r6, [sp, #-1169]	; 0xfffffb6f
    23b4:	44010031 	strmi	r0, [r1], #-49	; 0xffffffcf
    23b8:	0005e010 	andeq	lr, r5, r0, lsl r0
    23bc:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    23c0:	0032750d 	eorseq	r7, r2, sp, lsl #10
    23c4:	e0144401 	ands	r4, r4, r1, lsl #8
    23c8:	02000005 	andeq	r0, r0, #5
    23cc:	03007691 	movweq	r7, #1681	; 0x691
    23d0:	0d450801 	stcleq	8, cr0, [r5, #-4]
    23d4:	8e0b0000 	cdphi	0, 0, cr0, cr11, cr0, {0}
    23d8:	01000017 	tsteq	r0, r7, lsl r0
    23dc:	18930736 	ldmne	r3, {r1, r2, r4, r5, r8, r9, sl}
    23e0:	02290000 	eoreq	r0, r9, #0
    23e4:	8a2c0000 	bhi	b023ec <__bss_end+0xaf88fc>
    23e8:	00c00000 	sbceq	r0, r0, r0
    23ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    23f0:	00000640 	andeq	r0, r0, r0, asr #12
    23f4:	00175715 	andseq	r5, r7, r5, lsl r7
    23f8:	15360100 	ldrne	r0, [r6, #-256]!	; 0xffffff00
    23fc:	00000229 	andeq	r0, r0, r9, lsr #4
    2400:	0c6c9102 	stfeqp	f1, [ip], #-8
    2404:	00637273 	rsbeq	r7, r3, r3, ror r2
    2408:	1d273601 	stcne	6, cr3, [r7, #-4]!
    240c:	02000001 	andeq	r0, r0, #1
    2410:	6e0c6891 	mcrvs	8, 0, r6, cr12, cr1, {4}
    2414:	01006d75 	tsteq	r0, r5, ror sp
    2418:	01233036 			; <UNDEFINED> instruction: 0x01233036
    241c:	91020000 	mrsls	r0, (UNDEF: 2)
    2420:	00690d64 	rsbeq	r0, r9, r4, ror #26
    2424:	23063801 	movwcs	r3, #26625	; 0x6801
    2428:	02000001 	andeq	r0, r0, #1
    242c:	0b007491 	bleq	1f678 <__bss_end+0x15b88>
    2430:	0000170e 	andeq	r1, r0, lr, lsl #14
    2434:	45052401 	strmi	r2, [r5, #-1025]	; 0xfffffbff
    2438:	23000018 	movwcs	r0, #24
    243c:	90000001 	andls	r0, r0, r1
    2440:	9c000089 	stcls	0, cr0, [r0], {137}	; 0x89
    2444:	01000000 	mrseq	r0, (UNDEF: 0)
    2448:	00067d9c 	muleq	r6, ip, sp
    244c:	17721500 	ldrbne	r1, [r2, -r0, lsl #10]!
    2450:	24010000 	strcs	r0, [r1], #-0
    2454:	00011d16 	andeq	r1, r1, r6, lsl sp
    2458:	6c910200 	lfmvs	f0, 4, [r1], {0}
    245c:	0018500e 	andseq	r5, r8, lr
    2460:	06260100 	strteq	r0, [r6], -r0, lsl #2
    2464:	00000123 	andeq	r0, r0, r3, lsr #2
    2468:	00749102 	rsbseq	r9, r4, r2, lsl #2
    246c:	0017961c 	andseq	r9, r7, ip, lsl r6
    2470:	06080100 	streq	r0, [r8], -r0, lsl #2
    2474:	00001702 	andeq	r1, r0, r2, lsl #14
    2478:	0000881c 	andeq	r8, r0, ip, lsl r8
    247c:	00000174 	andeq	r0, r0, r4, ror r1
    2480:	72159c01 	andsvc	r9, r5, #256	; 0x100
    2484:	01000017 	tsteq	r0, r7, lsl r0
    2488:	00841808 	addeq	r1, r4, r8, lsl #16
    248c:	91020000 	mrsls	r0, (UNDEF: 2)
    2490:	18501564 	ldmdane	r0, {r2, r5, r6, r8, sl, ip}^
    2494:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2498:	00022925 	andeq	r2, r2, r5, lsr #18
    249c:	60910200 	addsvs	r0, r1, r0, lsl #4
    24a0:	00177815 	andseq	r7, r7, r5, lsl r8
    24a4:	3a080100 	bcc	2028ac <__bss_end+0x1f8dbc>
    24a8:	00000084 	andeq	r0, r0, r4, lsl #1
    24ac:	0d5c9102 	ldfeqp	f1, [ip, #-8]
    24b0:	0a010069 	beq	4265c <__bss_end+0x38b6c>
    24b4:	00012306 	andeq	r2, r1, r6, lsl #6
    24b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    24bc:	0088e80f 	addeq	lr, r8, pc, lsl #16
    24c0:	00009800 	andeq	r9, r0, r0, lsl #16
    24c4:	006a0d00 	rsbeq	r0, sl, r0, lsl #26
    24c8:	230b1c01 	movwcs	r1, #48129	; 0xbc01
    24cc:	02000001 	andeq	r0, r0, #1
    24d0:	100f7091 	mulne	pc, r1, r0	; <UNPREDICTABLE>
    24d4:	60000089 	andvs	r0, r0, r9, lsl #1
    24d8:	0d000000 	stceq	0, cr0, [r0, #-0]
    24dc:	1e010063 	cdpne	0, 0, cr0, cr1, cr3, {3}
    24e0:	00009008 	andeq	r9, r0, r8
    24e4:	6f910200 	svcvs	0x00910200
    24e8:	00000000 	andeq	r0, r0, r0
    24ec:	00000022 	andeq	r0, r0, r2, lsr #32
    24f0:	08d50002 	ldmeq	r5, {r1}^
    24f4:	01040000 	mrseq	r0, (UNDEF: 4)
    24f8:	00000d94 	muleq	r0, r4, sp
    24fc:	000097f8 	strdeq	r9, [r0], -r8
    2500:	00009a04 	andeq	r9, r0, r4, lsl #20
    2504:	000018e3 	andeq	r1, r0, r3, ror #17
    2508:	00001913 	andeq	r1, r0, r3, lsl r9
    250c:	00000063 	andeq	r0, r0, r3, rrx
    2510:	00228001 	eoreq	r8, r2, r1
    2514:	00020000 	andeq	r0, r2, r0
    2518:	000008e9 	andeq	r0, r0, r9, ror #17
    251c:	0e110104 	mufeqs	f0, f1, f4
    2520:	9a040000 	bls	102528 <__bss_end+0xf8a38>
    2524:	9a080000 	bls	20252c <__bss_end+0x1f8a3c>
    2528:	18e30000 	stmiane	r3!, {}^	; <UNPREDICTABLE>
    252c:	19130000 	ldmdbne	r3, {}	; <UNPREDICTABLE>
    2530:	00630000 	rsbeq	r0, r3, r0
    2534:	80010000 	andhi	r0, r1, r0
    2538:	00000932 	andeq	r0, r0, r2, lsr r9
    253c:	08fd0004 	ldmeq	sp!, {r2}^
    2540:	01040000 	mrseq	r0, (UNDEF: 4)
    2544:	00001ce1 	andeq	r1, r0, r1, ror #25
    2548:	001c380c 	andseq	r3, ip, ip, lsl #16
    254c:	00191300 	andseq	r1, r9, r0, lsl #6
    2550:	000e7100 	andeq	r7, lr, r0, lsl #2
    2554:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    2558:	00746e69 	rsbseq	r6, r4, r9, ror #28
    255c:	0e070403 	cdpeq	4, 0, cr0, cr7, cr3, {0}
    2560:	0300001e 	movweq	r0, #30
    2564:	031f0508 	tsteq	pc, #8, 10	; 0x2000000
    2568:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    256c:	0024e004 	eoreq	lr, r4, r4
    2570:	1c930400 	cfldrsne	mvf0, [r3], {0}
    2574:	2a010000 	bcs	4257c <__bss_end+0x38a8c>
    2578:	00002416 	andeq	r2, r0, r6, lsl r4
    257c:	21020400 	tstcs	r2, r0, lsl #8
    2580:	2f010000 	svccs	0x00010000
    2584:	00005115 	andeq	r5, r0, r5, lsl r1
    2588:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    258c:	06000000 	streq	r0, [r0], -r0
    2590:	00000039 	andeq	r0, r0, r9, lsr r0
    2594:	00000066 	andeq	r0, r0, r6, rrx
    2598:	00006607 	andeq	r6, r0, r7, lsl #12
    259c:	04050000 	streq	r0, [r5], #-0
    25a0:	0000006c 	andeq	r0, r0, ip, rrx
    25a4:	28340408 	ldmdacs	r4!, {r3, sl}
    25a8:	36010000 	strcc	r0, [r1], -r0
    25ac:	0000790f 	andeq	r7, r0, pc, lsl #18
    25b0:	7f040500 	svcvc	0x00040500
    25b4:	06000000 	streq	r0, [r0], -r0
    25b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    25bc:	00000093 	muleq	r0, r3, r0
    25c0:	00006607 	andeq	r6, r0, r7, lsl #12
    25c4:	00660700 	rsbeq	r0, r6, r0, lsl #14
    25c8:	03000000 	movweq	r0, #0
    25cc:	0d450801 	stcleq	8, cr0, [r5, #-4]
    25d0:	3a090000 	bcc	2425d8 <__bss_end+0x238ae8>
    25d4:	01000023 	tsteq	r0, r3, lsr #32
    25d8:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    25dc:	62090000 	andvs	r0, r9, #0
    25e0:	01000028 	tsteq	r0, r8, lsr #32
    25e4:	006d10be 	strhteq	r1, [sp], #-14
    25e8:	01030000 	mrseq	r0, (UNDEF: 3)
    25ec:	000d4706 	andeq	r4, sp, r6, lsl #14
    25f0:	20220a00 	eorcs	r0, r2, r0, lsl #20
    25f4:	01070000 	mrseq	r0, (UNDEF: 7)
    25f8:	00000093 	muleq	r0, r3, r0
    25fc:	e6061702 	str	r1, [r6], -r2, lsl #14
    2600:	0b000001 	bleq	260c <shift+0x260c>
    2604:	00001af1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    2608:	1f3f0b00 	svcne	0x003f0b00
    260c:	0b010000 	bleq	42614 <__bss_end+0x38b24>
    2610:	00002405 	andeq	r2, r0, r5, lsl #8
    2614:	27760b02 	ldrbcs	r0, [r6, -r2, lsl #22]!
    2618:	0b030000 	bleq	c2620 <__bss_end+0xb8b30>
    261c:	000023a9 	andeq	r2, r0, r9, lsr #7
    2620:	267f0b04 	ldrbtcs	r0, [pc], -r4, lsl #22
    2624:	0b050000 	bleq	14262c <__bss_end+0x138b3c>
    2628:	000025e3 	andeq	r2, r0, r3, ror #11
    262c:	1b120b06 	blne	48524c <__bss_end+0x47b75c>
    2630:	0b070000 	bleq	1c2638 <__bss_end+0x1b8b48>
    2634:	00002694 	muleq	r0, r4, r6
    2638:	26a20b08 	strtcs	r0, [r2], r8, lsl #22
    263c:	0b090000 	bleq	242644 <__bss_end+0x238b54>
    2640:	00002769 	andeq	r2, r0, r9, ror #14
    2644:	23000b0a 	movwcs	r0, #2826	; 0xb0a
    2648:	0b0b0000 	bleq	2c2650 <__bss_end+0x2b8b60>
    264c:	00001cd4 	ldrdeq	r1, [r0], -r4
    2650:	1db10b0c 			; <UNDEFINED> instruction: 0x1db10b0c
    2654:	0b0d0000 	bleq	34265c <__bss_end+0x338b6c>
    2658:	00002066 	andeq	r2, r0, r6, rrx
    265c:	207c0b0e 	rsbscs	r0, ip, lr, lsl #22
    2660:	0b0f0000 	bleq	3c2668 <__bss_end+0x3b8b78>
    2664:	00001f79 	andeq	r1, r0, r9, ror pc
    2668:	238d0b10 	orrcs	r0, sp, #16, 22	; 0x4000
    266c:	0b110000 	bleq	442674 <__bss_end+0x438b84>
    2670:	00001fe5 	andeq	r1, r0, r5, ror #31
    2674:	29fb0b12 	ldmibcs	fp!, {r1, r4, r8, r9, fp}^
    2678:	0b130000 	bleq	4c2680 <__bss_end+0x4b8b90>
    267c:	00001b7b 	andeq	r1, r0, fp, ror fp
    2680:	20090b14 	andcs	r0, r9, r4, lsl fp
    2684:	0b150000 	bleq	54268c <__bss_end+0x538b9c>
    2688:	00001ab8 			; <UNDEFINED> instruction: 0x00001ab8
    268c:	27990b16 			; <UNDEFINED> instruction: 0x27990b16
    2690:	0b170000 	bleq	5c2698 <__bss_end+0x5b8ba8>
    2694:	000028bb 			; <UNDEFINED> instruction: 0x000028bb
    2698:	202e0b18 	eorcs	r0, lr, r8, lsl fp
    269c:	0b190000 	bleq	6426a4 <__bss_end+0x638bb4>
    26a0:	00002477 	andeq	r2, r0, r7, ror r4
    26a4:	27a70b1a 			; <UNDEFINED> instruction: 0x27a70b1a
    26a8:	0b1b0000 	bleq	6c26b0 <__bss_end+0x6b8bc0>
    26ac:	000019e7 	andeq	r1, r0, r7, ror #19
    26b0:	27b50b1c 			; <UNDEFINED> instruction: 0x27b50b1c
    26b4:	0b1d0000 	bleq	7426bc <__bss_end+0x738bcc>
    26b8:	000027c3 	andeq	r2, r0, r3, asr #15
    26bc:	19950b1e 	ldmibne	r5, {r1, r2, r3, r4, r8, r9, fp}
    26c0:	0b1f0000 	bleq	7c26c8 <__bss_end+0x7b8bd8>
    26c4:	000027ed 	andeq	r2, r0, sp, ror #15
    26c8:	25240b20 	strcs	r0, [r4, #-2848]!	; 0xfffff4e0
    26cc:	0b210000 	bleq	8426d4 <__bss_end+0x838be4>
    26d0:	0000235f 	andeq	r2, r0, pc, asr r3
    26d4:	278c0b22 	strcs	r0, [ip, r2, lsr #22]
    26d8:	0b230000 	bleq	8c26e0 <__bss_end+0x8b8bf0>
    26dc:	00002263 	andeq	r2, r0, r3, ror #4
    26e0:	21650b24 	cmncs	r5, r4, lsr #22
    26e4:	0b250000 	bleq	9426ec <__bss_end+0x938bfc>
    26e8:	00001e7f 	andeq	r1, r0, pc, ror lr
    26ec:	21830b26 	orrcs	r0, r3, r6, lsr #22
    26f0:	0b270000 	bleq	9c26f8 <__bss_end+0x9b8c08>
    26f4:	00001f1b 	andeq	r1, r0, fp, lsl pc
    26f8:	21930b28 	orrscs	r0, r3, r8, lsr #22
    26fc:	0b290000 	bleq	a42704 <__bss_end+0xa38c14>
    2700:	000021a3 	andeq	r2, r0, r3, lsr #3
    2704:	22e60b2a 	rsccs	r0, r6, #43008	; 0xa800
    2708:	0b2b0000 	bleq	ac2710 <__bss_end+0xab8c20>
    270c:	0000210c 	andeq	r2, r0, ip, lsl #2
    2710:	25310b2c 	ldrcs	r0, [r1, #-2860]!	; 0xfffff4d4
    2714:	0b2d0000 	bleq	b4271c <__bss_end+0xb38c2c>
    2718:	00001ec0 	andeq	r1, r0, r0, asr #29
    271c:	9e0a002e 	cdpls	0, 0, cr0, cr10, cr14, {1}
    2720:	07000020 	streq	r0, [r0, -r0, lsr #32]
    2724:	00009301 	andeq	r9, r0, r1, lsl #6
    2728:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    272c:	000003c7 	andeq	r0, r0, r7, asr #7
    2730:	001dd30b 	andseq	sp, sp, fp, lsl #6
    2734:	250b0000 	strcs	r0, [fp, #-0]
    2738:	0100001a 	tsteq	r0, sl, lsl r0
    273c:	0029a90b 	eoreq	sl, r9, fp, lsl #18
    2740:	3c0b0200 	sfmcc	f0, 4, [fp], {-0}
    2744:	03000028 	movweq	r0, #40	; 0x28
    2748:	001df30b 	andseq	pc, sp, fp, lsl #6
    274c:	dd0b0400 	cfstrsle	mvf0, [fp, #-0]
    2750:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2754:	001e9c0b 	andseq	r9, lr, fp, lsl #24
    2758:	e30b0600 	movw	r0, #46592	; 0xb600
    275c:	0700001d 	smladeq	r0, sp, r0, r0
    2760:	0026d00b 	eoreq	sp, r6, fp
    2764:	210b0800 	tstcs	fp, r0, lsl #16
    2768:	09000028 	stmdbeq	r0, {r3, r5}
    276c:	0026070b 	eoreq	r0, r6, fp, lsl #14
    2770:	300b0a00 	andcc	r0, fp, r0, lsl #20
    2774:	0b00001b 	bleq	27e8 <shift+0x27e8>
    2778:	001e3d0b 	andseq	r3, lr, fp, lsl #26
    277c:	a60b0c00 	strge	r0, [fp], -r0, lsl #24
    2780:	0d00001a 	stceq	0, cr0, [r0, #-104]	; 0xffffff98
    2784:	0029de0b 	eoreq	sp, r9, fp, lsl #28
    2788:	d30b0e00 	movwle	r0, #48640	; 0xbe00
    278c:	0f000022 	svceq	0x00000022
    2790:	001fb00b 	andseq	fp, pc, fp
    2794:	100b1000 	andne	r1, fp, r0
    2798:	11000023 	tstne	r0, r3, lsr #32
    279c:	0028fd0b 	eoreq	pc, r8, fp, lsl #26
    27a0:	f30b1200 	vhsub.u8	d1, d11, d0
    27a4:	1300001b 	movwne	r0, #27
    27a8:	001fc30b 	andseq	ip, pc, fp, lsl #6
    27ac:	260b1400 	strcs	r1, [fp], -r0, lsl #8
    27b0:	15000022 	strne	r0, [r0, #-34]	; 0xffffffde
    27b4:	001dbe0b 	andseq	fp, sp, fp, lsl #28
    27b8:	720b1600 	andvc	r1, fp, #0, 12
    27bc:	17000022 	strne	r0, [r0, -r2, lsr #32]
    27c0:	0020880b 	eoreq	r8, r0, fp, lsl #16
    27c4:	fb0b1800 	blx	2c87ce <__bss_end+0x2becde>
    27c8:	1900001a 	stmdbne	r0, {r1, r3, r4}
    27cc:	0028a40b 	eoreq	sl, r8, fp, lsl #8
    27d0:	f20b1a00 	vpmax.s8	d1, d11, d0
    27d4:	1b000021 	blne	2860 <shift+0x2860>
    27d8:	001f9a0b 	andseq	r9, pc, fp, lsl #20
    27dc:	d00b1c00 	andle	r1, fp, r0, lsl #24
    27e0:	1d000019 	stcne	0, cr0, [r0, #-100]	; 0xffffff9c
    27e4:	00213d0b 	eoreq	r3, r1, fp, lsl #26
    27e8:	290b1e00 	stmdbcs	fp, {r9, sl, fp, ip}
    27ec:	1f000021 	svcne	0x00000021
    27f0:	0025c40b 	eoreq	ip, r5, fp, lsl #8
    27f4:	4f0b2000 	svcmi	0x000b2000
    27f8:	21000026 	tstcs	r0, r6, lsr #32
    27fc:	0028830b 	eoreq	r8, r8, fp, lsl #6
    2800:	cd0b2200 	sfmgt	f2, 4, [fp, #-0]
    2804:	2300001e 	movwcs	r0, #30
    2808:	0024270b 	eoreq	r2, r4, fp, lsl #14
    280c:	1c0b2400 	cfstrsne	mvf2, [fp], {-0}
    2810:	25000026 	strcs	r0, [r0, #-38]	; 0xffffffda
    2814:	0025400b 	eoreq	r4, r5, fp
    2818:	540b2600 	strpl	r2, [fp], #-1536	; 0xfffffa00
    281c:	27000025 	strcs	r0, [r0, -r5, lsr #32]
    2820:	0025680b 	eoreq	r6, r5, fp, lsl #16
    2824:	7e0b2800 	cdpvc	8, 0, cr2, cr11, cr0, {0}
    2828:	2900001c 	stmdbcs	r0, {r2, r3, r4}
    282c:	001bde0b 	andseq	sp, fp, fp, lsl #28
    2830:	060b2a00 	streq	r2, [fp], -r0, lsl #20
    2834:	2b00001c 	blcs	28ac <shift+0x28ac>
    2838:	0027190b 	eoreq	r1, r7, fp, lsl #18
    283c:	5b0b2c00 	blpl	2cd844 <__bss_end+0x2c3d54>
    2840:	2d00001c 	stccs	0, cr0, [r0, #-112]	; 0xffffff90
    2844:	00272d0b 	eoreq	r2, r7, fp, lsl #26
    2848:	410b2e00 	tstmi	fp, r0, lsl #28
    284c:	2f000027 	svccs	0x00000027
    2850:	0027550b 	eoreq	r5, r7, fp, lsl #10
    2854:	4f0b3000 	svcmi	0x000b3000
    2858:	3100001e 	tstcc	r0, lr, lsl r0
    285c:	001e290b 	andseq	r2, lr, fp, lsl #18
    2860:	510b3200 	mrspl	r3, R11_fiq
    2864:	33000021 	movwcc	r0, #33	; 0x21
    2868:	0023230b 	eoreq	r2, r3, fp, lsl #6
    286c:	320b3400 	andcc	r3, fp, #0, 8
    2870:	35000029 	strcc	r0, [r0, #-41]	; 0xffffffd7
    2874:	0019780b 	andseq	r7, r9, fp, lsl #16
    2878:	4f0b3600 	svcmi	0x000b3600
    287c:	3700001f 	smladcc	r0, pc, r0, r0	; <UNPREDICTABLE>
    2880:	001f640b 	andseq	r6, pc, fp, lsl #8
    2884:	b30b3800 	movwlt	r3, #47104	; 0xb800
    2888:	39000021 	stmdbcc	r0, {r0, r5}
    288c:	0021dd0b 	eoreq	sp, r1, fp, lsl #26
    2890:	5b0b3a00 	blpl	2d1098 <__bss_end+0x2c75a8>
    2894:	3b000029 	blcc	2940 <shift+0x2940>
    2898:	0024120b 	eoreq	r1, r4, fp, lsl #4
    289c:	f20b3c00 			; <UNDEFINED> instruction: 0xf20b3c00
    28a0:	3d00001e 	stccc	0, cr0, [r0, #-120]	; 0xffffff88
    28a4:	001a370b 	andseq	r3, sl, fp, lsl #14
    28a8:	f50b3e00 			; <UNDEFINED> instruction: 0xf50b3e00
    28ac:	3f000019 	svccc	0x00000019
    28b0:	00236f0b 	eoreq	r6, r3, fp, lsl #30
    28b4:	930b4000 	movwls	r4, #45056	; 0xb000
    28b8:	41000024 	tstmi	r0, r4, lsr #32
    28bc:	0025a60b 	eoreq	sl, r5, fp, lsl #12
    28c0:	c80b4200 	stmdagt	fp, {r9, lr}
    28c4:	43000021 	movwmi	r0, #33	; 0x21
    28c8:	0029940b 	eoreq	r9, r9, fp, lsl #8
    28cc:	3d0b4400 	cfstrscc	mvf4, [fp, #-0]
    28d0:	45000024 	strmi	r0, [r0, #-36]	; 0xffffffdc
    28d4:	001c220b 	andseq	r2, ip, fp, lsl #4
    28d8:	a30b4600 	movwge	r4, #46592	; 0xb600
    28dc:	47000022 	strmi	r0, [r0, -r2, lsr #32]
    28e0:	0020d60b 	eoreq	sp, r0, fp, lsl #12
    28e4:	b40b4800 	strlt	r4, [fp], #-2048	; 0xfffff800
    28e8:	49000019 	stmdbmi	r0, {r0, r3, r4}
    28ec:	001ac80b 	andseq	ip, sl, fp, lsl #16
    28f0:	060b4a00 	streq	r4, [fp], -r0, lsl #20
    28f4:	4b00001f 	blmi	2978 <shift+0x2978>
    28f8:	0022040b 	eoreq	r0, r2, fp, lsl #8
    28fc:	03004c00 	movweq	r4, #3072	; 0xc00
    2900:	09b80702 	ldmibeq	r8!, {r1, r8, r9, sl}
    2904:	e40c0000 	str	r0, [ip], #-0
    2908:	d9000003 	stmdble	r0, {r0, r1}
    290c:	0d000003 	stceq	0, cr0, [r0, #-12]
    2910:	03ce0e00 	biceq	r0, lr, #0, 28
    2914:	04050000 	streq	r0, [r5], #-0
    2918:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    291c:	0003de0e 	andeq	sp, r3, lr, lsl #28
    2920:	08010300 	stmdaeq	r1, {r8, r9}
    2924:	00000d4e 	andeq	r0, r0, lr, asr #26
    2928:	0003e90e 	andeq	lr, r3, lr, lsl #18
    292c:	1b6c0f00 	blne	1b06534 <__bss_end+0x1afca44>
    2930:	4c040000 	stcmi	0, cr0, [r4], {-0}
    2934:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    2938:	8a0f0000 	bhi	3c2940 <__bss_end+0x3b8e50>
    293c:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    2940:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    2944:	0c000003 	stceq	0, cr0, [r0], {3}
    2948:	000003e9 	andeq	r0, r0, r9, ror #7
    294c:	0000041a 	andeq	r0, r0, sl, lsl r4
    2950:	7509000d 	strvc	r0, [r9, #-13]
    2954:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2958:	040f0d2d 	streq	r0, [pc], #-3373	; 2960 <shift+0x2960>
    295c:	fd090000 	stc2	0, cr0, [r9, #-0]
    2960:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2964:	01e61c38 	mvneq	r1, r8, lsr ip
    2968:	630a0000 	movwvs	r0, #40960	; 0xa000
    296c:	0700001e 	smladeq	r0, lr, r0, r0
    2970:	00009301 	andeq	r9, r0, r1, lsl #6
    2974:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    2978:	000004a5 	andeq	r0, r0, r5, lsr #9
    297c:	0019c90b 	andseq	ip, r9, fp, lsl #18
    2980:	750b0000 	strvc	r0, [fp, #-0]
    2984:	01000020 	tsteq	r0, r0, lsr #32
    2988:	00290f0b 	eoreq	r0, r9, fp, lsl #30
    298c:	d20b0200 	andle	r0, fp, #0, 4
    2990:	03000028 	movweq	r0, #40	; 0x28
    2994:	0023cc0b 	eoreq	ip, r3, fp, lsl #24
    2998:	8d0b0400 	cfstrshi	mvf0, [fp, #-0]
    299c:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    29a0:	001baf0b 	andseq	sl, fp, fp, lsl #30
    29a4:	910b0600 	tstls	fp, r0, lsl #12
    29a8:	0700001b 	smladeq	r0, fp, r0, r0
    29ac:	001daa0b 	andseq	sl, sp, fp, lsl #20
    29b0:	880b0800 	stmdahi	fp, {fp}
    29b4:	09000022 	stmdbeq	r0, {r1, r5}
    29b8:	001bb60b 	andseq	fp, fp, fp, lsl #12
    29bc:	8f0b0a00 	svchi	0x000b0a00
    29c0:	0b000022 	bleq	2a50 <shift+0x2a50>
    29c4:	001c1b0b 	andseq	r1, ip, fp, lsl #22
    29c8:	a80b0c00 	stmdage	fp, {sl, fp}
    29cc:	0d00001b 	stceq	0, cr0, [r0, #-108]	; 0xffffff94
    29d0:	0026e40b 	eoreq	lr, r6, fp, lsl #8
    29d4:	b10b0e00 	tstlt	fp, r0, lsl #28
    29d8:	0f000024 	svceq	0x00000024
    29dc:	25dc0400 	ldrbcs	r0, [ip, #1024]	; 0x400
    29e0:	3f050000 	svccc	0x00050000
    29e4:	00043201 	andeq	r3, r4, r1, lsl #4
    29e8:	26700900 	ldrbtcs	r0, [r0], -r0, lsl #18
    29ec:	41050000 	mrsmi	r0, (UNDEF: 5)
    29f0:	0004a50f 	andeq	sl, r4, pc, lsl #10
    29f4:	26f80900 	ldrbtcs	r0, [r8], r0, lsl #18
    29f8:	4a050000 	bmi	142a00 <__bss_end+0x138f10>
    29fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a00:	1b500900 	blne	1404e08 <__bss_end+0x13fb318>
    2a04:	4b050000 	blmi	142a0c <__bss_end+0x138f1c>
    2a08:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a0c:	27d11000 	ldrbcs	r1, [r1, r0]
    2a10:	09090000 	stmdbeq	r9, {}	; <UNPREDICTABLE>
    2a14:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2a18:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    2a1c:	04050000 	streq	r0, [r5], #-0
    2a20:	000004d5 	ldrdeq	r0, [r0], -r5
    2a24:	203f0911 	eorscs	r0, pc, r1, lsl r9	; <UNPREDICTABLE>
    2a28:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    2a2c:	0004f90f 	andeq	pc, r4, pc, lsl #18
    2a30:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    2a34:	12000004 	andne	r0, r0, #4
    2a38:	000025f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    2a3c:	0023b909 	eoreq	fp, r3, r9, lsl #18
    2a40:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    2a44:	00000510 	andeq	r0, r0, r0, lsl r5
    2a48:	04ff0405 	ldrbteq	r0, [pc], #1029	; 2a50 <shift+0x2a50>
    2a4c:	c7130000 	ldrgt	r0, [r3, -r0]
    2a50:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    2a54:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    2a58:	00000541 	andeq	r0, r0, r1, asr #10
    2a5c:	00217e14 	eoreq	r7, r1, r4, lsl lr
    2a60:	01690500 	cmneq	r9, r0, lsl #10
    2a64:	0003de0f 	andeq	sp, r3, pc, lsl #28
    2a68:	ab140000 	blge	502a70 <__bss_end+0x4f8f80>
    2a6c:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2a70:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    2a74:	04000005 	streq	r0, [r0], #-5
    2a78:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    2a7c:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    2a80:	56000000 	strpl	r0, [r0], -r0
    2a84:	15000005 	strne	r0, [r0, #-5]
    2a88:	00000024 	andeq	r0, r0, r4, lsr #32
    2a8c:	410c002d 	tstmi	ip, sp, lsr #32
    2a90:	61000005 	tstvs	r0, r5
    2a94:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    2a98:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    2a9c:	ad0f0000 	stcge	0, cr0, [pc, #-0]	; 2aa4 <shift+0x2aa4>
    2aa0:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2aa4:	6103016b 	tstvs	r3, fp, ror #2
    2aa8:	0f000005 	svceq	0x00000005
    2aac:	000022f3 	strdeq	r2, [r0], -r3
    2ab0:	0c016e05 	stceq	14, cr6, [r1], {5}
    2ab4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ab8:	00263016 	eoreq	r3, r6, r6, lsl r0
    2abc:	93010700 	movwls	r0, #5888	; 0x1700
    2ac0:	05000000 	streq	r0, [r0, #-0]
    2ac4:	2a060181 	bcs	1830d0 <__bss_end+0x1795e0>
    2ac8:	0b000006 	bleq	2ae8 <shift+0x2ae8>
    2acc:	00001a5e 	andeq	r1, r0, lr, asr sl
    2ad0:	1a6a0b00 	bne	1a856d8 <__bss_end+0x1a7bbe8>
    2ad4:	0b020000 	bleq	82adc <__bss_end+0x78fec>
    2ad8:	00001a76 	andeq	r1, r0, r6, ror sl
    2adc:	1e8f0b03 	vdivne.f64	d0, d15, d3
    2ae0:	0b030000 	bleq	c2ae8 <__bss_end+0xb8ff8>
    2ae4:	00001a82 	andeq	r1, r0, r2, lsl #21
    2ae8:	1fd80b04 	svcne	0x00d80b04
    2aec:	0b040000 	bleq	102af4 <__bss_end+0xf9004>
    2af0:	000020be 	strheq	r2, [r0], -lr
    2af4:	20140b05 	andscs	r0, r4, r5, lsl #22
    2af8:	0b050000 	bleq	142b00 <__bss_end+0x139010>
    2afc:	00001b41 	andeq	r1, r0, r1, asr #22
    2b00:	1a8e0b05 	bne	fe38571c <__bss_end+0xfe37bc2c>
    2b04:	0b060000 	bleq	182b0c <__bss_end+0x17901c>
    2b08:	0000223c 	andeq	r2, r0, ip, lsr r2
    2b0c:	1c9d0b06 	vldmiane	sp, {d0-d2}
    2b10:	0b060000 	bleq	182b18 <__bss_end+0x179028>
    2b14:	00002249 	andeq	r2, r0, r9, asr #4
    2b18:	26b00b06 	ldrtcs	r0, [r0], r6, lsl #22
    2b1c:	0b060000 	bleq	182b24 <__bss_end+0x179034>
    2b20:	00002256 	andeq	r2, r0, r6, asr r2
    2b24:	22960b06 	addscs	r0, r6, #6144	; 0x1800
    2b28:	0b060000 	bleq	182b30 <__bss_end+0x179040>
    2b2c:	00001a9a 	muleq	r0, sl, sl
    2b30:	239c0b07 	orrscs	r0, ip, #7168	; 0x1c00
    2b34:	0b070000 	bleq	1c2b3c <__bss_end+0x1b904c>
    2b38:	000023e9 	andeq	r2, r0, r9, ror #7
    2b3c:	26eb0b07 	strbtcs	r0, [fp], r7, lsl #22
    2b40:	0b070000 	bleq	1c2b48 <__bss_end+0x1b9058>
    2b44:	00001c70 	andeq	r1, r0, r0, ror ip
    2b48:	246a0b07 	strbtcs	r0, [sl], #-2823	; 0xfffff4f9
    2b4c:	0b080000 	bleq	202b54 <__bss_end+0x1f9064>
    2b50:	00001a13 	andeq	r1, r0, r3, lsl sl
    2b54:	26be0b08 	ldrtcs	r0, [lr], r8, lsl #22
    2b58:	0b080000 	bleq	202b60 <__bss_end+0x1f9070>
    2b5c:	00002486 	andeq	r2, r0, r6, lsl #9
    2b60:	240f0008 	strcs	r0, [pc], #-8	; 2b68 <shift+0x2b68>
    2b64:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2b68:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    2b6c:	0f000005 	svceq	0x00000005
    2b70:	000024b8 			; <UNDEFINED> instruction: 0x000024b8
    2b74:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    2b78:	0000001d 	andeq	r0, r0, sp, lsl r0
    2b7c:	0020cb0f 	eoreq	ip, r0, pc, lsl #22
    2b80:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    2b84:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2b88:	29f00f00 	ldmibcs	r0!, {r8, r9, sl, fp}^
    2b8c:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    2b90:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2b94:	600f0000 	andvs	r0, pc, r0
    2b98:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2b9c:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    2ba0:	0f000000 	svceq	0x00000000
    2ba4:	000024c2 	andeq	r2, r0, r2, asr #9
    2ba8:	0c01ae05 	stceq	14, cr10, [r1], {5}
    2bac:	0000001d 	andeq	r0, r0, sp, lsl r0
    2bb0:	0023d30f 	eoreq	sp, r3, pc, lsl #6
    2bb4:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    2bb8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2bbc:	23de0f00 	bicscs	r0, lr, #0, 30
    2bc0:	b4050000 	strlt	r0, [r5], #-0
    2bc4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2bc8:	cc0f0000 	stcgt	0, cr0, [pc], {-0}
    2bcc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2bd0:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    2bd4:	0f000000 	svceq	0x00000000
    2bd8:	00002218 	andeq	r2, r0, r8, lsl r2
    2bdc:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    2be0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2be4:	00294f0f 	eoreq	r4, r9, pc, lsl #30
    2be8:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    2bec:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2bf0:	24d60f00 	ldrbcs	r0, [r6], #3840	; 0xf00
    2bf4:	c0050000 	andgt	r0, r5, r0
    2bf8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2bfc:	130f0000 	movwne	r0, #61440	; 0xf000
    2c00:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    2c04:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    2c08:	0f000000 	svceq	0x00000000
    2c0c:	000028d9 	ldrdeq	r2, [r0], -r9
    2c10:	0c01c605 	stceq	6, cr12, [r1], {5}
    2c14:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c18:	0028e50f 	eoreq	lr, r8, pc, lsl #10
    2c1c:	01c90500 	biceq	r0, r9, r0, lsl #10
    2c20:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c24:	28f10f00 	ldmcs	r1!, {r8, r9, sl, fp}^
    2c28:	cc050000 	stcgt	0, cr0, [r5], {-0}
    2c2c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c30:	160f0000 	strne	r0, [pc], -r0
    2c34:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    2c38:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    2c3c:	0f000000 	svceq	0x00000000
    2c40:	00002a06 	andeq	r2, r0, r6, lsl #20
    2c44:	0c01d305 	stceq	3, cr13, [r1], {5}
    2c48:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c4c:	001bbd0f 	andseq	fp, fp, pc, lsl #26
    2c50:	01d60500 	bicseq	r0, r6, r0, lsl #10
    2c54:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c58:	19a40f00 	stmibne	r4!, {r8, r9, sl, fp}
    2c5c:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    2c60:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c64:	af0f0000 	svcge	0x000f0000
    2c68:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2c6c:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    2c70:	0f000000 	svceq	0x00000000
    2c74:	00001b98 	muleq	r0, r8, fp
    2c78:	0c01df05 	stceq	15, cr13, [r1], {5}
    2c7c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2c80:	0024ec0f 	eoreq	lr, r4, pc, lsl #24
    2c84:	01e20500 	mvneq	r0, r0, lsl #10
    2c88:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2c8c:	20f40f00 	rscscs	r0, r4, r0, lsl #30
    2c90:	e5050000 	str	r0, [r5, #-0]
    2c94:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2c98:	4c0f0000 	stcmi	0, cr0, [pc], {-0}
    2c9c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2ca0:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    2ca4:	0f000000 	svceq	0x00000000
    2ca8:	00002806 	andeq	r2, r0, r6, lsl #16
    2cac:	0c01ef05 	stceq	15, cr14, [r1], {5}
    2cb0:	0000001d 	andeq	r0, r0, sp, lsl r0
    2cb4:	0029be0f 	eoreq	fp, r9, pc, lsl #28
    2cb8:	01f20500 	mvnseq	r0, r0, lsl #10
    2cbc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cc0:	29ce0f00 	stmibcs	lr, {r8, r9, sl, fp}^
    2cc4:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    2cc8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2ccc:	b40f0000 	strlt	r0, [pc], #-0	; 2cd4 <shift+0x2cd4>
    2cd0:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2cd4:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    2cd8:	0f000000 	svceq	0x00000000
    2cdc:	0000284d 	andeq	r2, r0, sp, asr #16
    2ce0:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    2ce4:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ce8:	0024520f 	eoreq	r5, r4, pc, lsl #4
    2cec:	01fe0500 	mvnseq	r0, r0, lsl #10
    2cf0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2cf4:	1f280f00 	svcne	0x00280f00
    2cf8:	02050000 	andeq	r0, r5, #0
    2cfc:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2d00:	420f0000 	andmi	r0, pc, #0
    2d04:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    2d08:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    2d0c:	0f000000 	svceq	0x00000000
    2d10:	00001e1b 	andeq	r1, r0, fp, lsl lr
    2d14:	0c020d05 	stceq	13, cr0, [r2], {5}
    2d18:	0000001d 	andeq	r0, r0, sp, lsl r0
    2d1c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2d20:	0007ef00 	andeq	lr, r7, r0, lsl #30
    2d24:	0f000d00 	svceq	0x00000d00
    2d28:	00001ff4 	strdeq	r1, [r0], -r4
    2d2c:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    2d30:	000007e4 	andeq	r0, r0, r4, ror #15
    2d34:	0004e60c 	andeq	lr, r4, ip, lsl #12
    2d38:	00080c00 	andeq	r0, r8, r0, lsl #24
    2d3c:	00241500 	eoreq	r1, r4, r0, lsl #10
    2d40:	000d0000 	andeq	r0, sp, r0
    2d44:	00250f0f 	eoreq	r0, r5, pc, lsl #30
    2d48:	05840500 	streq	r0, [r4, #1280]	; 0x500
    2d4c:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    2d50:	20b61600 	adcscs	r1, r6, r0, lsl #12
    2d54:	01070000 	mrseq	r0, (UNDEF: 7)
    2d58:	00000093 	muleq	r0, r3, r0
    2d5c:	06058b05 	streq	r8, [r5], -r5, lsl #22
    2d60:	00000857 	andeq	r0, r0, r7, asr r8
    2d64:	001e710b 	andseq	r7, lr, fp, lsl #2
    2d68:	c10b0000 	mrsgt	r0, (UNDEF: 11)
    2d6c:	01000022 	tsteq	r0, r2, lsr #32
    2d70:	001a490b 	andseq	r4, sl, fp, lsl #18
    2d74:	800b0200 	andhi	r0, fp, r0, lsl #4
    2d78:	03000029 	movweq	r0, #41	; 0x29
    2d7c:	0025890b 	eoreq	r8, r5, fp, lsl #18
    2d80:	7c0b0400 	cfstrsvc	mvf0, [fp], {-0}
    2d84:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2d88:	001b200b 	andseq	r2, fp, fp
    2d8c:	0f000600 	svceq	0x00000600
    2d90:	00002970 	andeq	r2, r0, r0, ror r9
    2d94:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    2d98:	00000819 	andeq	r0, r0, r9, lsl r8
    2d9c:	0028720f 	eoreq	r7, r8, pc, lsl #4
    2da0:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    2da4:	00002411 	andeq	r2, r0, r1, lsl r4
    2da8:	24fc0f00 	ldrbtcs	r0, [ip], #3840	; 0xf00
    2dac:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    2db0:	001d0c07 	andseq	r0, sp, r7, lsl #24
    2db4:	e5040000 	str	r0, [r4, #-0]
    2db8:	06000027 	streq	r0, [r0], -r7, lsr #32
    2dbc:	0093167b 	addseq	r1, r3, fp, ror r6
    2dc0:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    2dc4:	03000008 	movweq	r0, #8
    2dc8:	0dc20502 	cfstr64eq	mvdx0, [r2, #8]
    2dcc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2dd0:	001e0407 	andseq	r0, lr, r7, lsl #8
    2dd4:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    2dd8:	00001bd8 	ldrdeq	r1, [r0], -r8
    2ddc:	d0030803 	andle	r0, r3, r3, lsl #16
    2de0:	0300001b 	movweq	r0, #27
    2de4:	24e50408 	strbtcs	r0, [r5], #1032	; 0x408
    2de8:	10030000 	andne	r0, r3, r0
    2dec:	00259703 	eoreq	r9, r5, r3, lsl #14
    2df0:	088a0c00 	stmeq	sl, {sl, fp}
    2df4:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    2df8:	24150000 	ldrcs	r0, [r5], #-0
    2dfc:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    2e00:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    2e04:	f60f0000 			; <UNDEFINED> instruction: 0xf60f0000
    2e08:	06000023 	streq	r0, [r0], -r3, lsr #32
    2e0c:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    2e10:	0f000008 	svceq	0x00000008
    2e14:	00001b87 	andeq	r1, r0, r7, lsl #23
    2e18:	16020206 	strne	r0, [r2], -r6, lsl #4
    2e1c:	000008c9 	andeq	r0, r0, r9, asr #17
    2e20:	00281804 	eoreq	r1, r8, r4, lsl #16
    2e24:	102a0700 	eorne	r0, sl, r0, lsl #14
    2e28:	000004f9 	strdeq	r0, [r0], -r9
    2e2c:	0008e80c 	andeq	lr, r8, ip, lsl #16
    2e30:	0008ff00 	andeq	pc, r8, r0, lsl #30
    2e34:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2e38:	00000357 	andeq	r0, r0, r7, asr r3
    2e3c:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    2e40:	09000008 	stmdbeq	r0, {r3}
    2e44:	0000020c 	andeq	r0, r0, ip, lsl #4
    2e48:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    2e4c:	17000008 	strne	r0, [r0, -r8]
    2e50:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2e54:	0a093308 	beq	24fa7c <__bss_end+0x245f8c>
    2e58:	9add0305 	bls	ff743a74 <__bss_end+0xff739f84>
    2e5c:	0b170000 	bleq	5c2e64 <__bss_end+0x5b9374>
    2e60:	08000009 	stmdaeq	r0, {r0, r3}
    2e64:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    2e68:	009add03 	addseq	sp, sl, r3, lsl #26
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377124>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb922c>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb924c>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9264>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z11split_floatfRjS_Ri+0x28c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79da4>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39288>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f71b8>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6604>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9e68>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4e20>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6630>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b66a4>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377220>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9320>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79e5c>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39340>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9358>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79e90>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4ecc>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377310>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f72d8>
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
 1f8:	0b3b0b3a 	bleq	ec2ee8 <__bss_end+0xeb93f8>
 1fc:	13490b39 	movtne	r0, #39737	; 0x9b39
 200:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 204:	24030000 	strcs	r0, [r3], #-0
 208:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 20c:	000e030b 	andeq	r0, lr, fp, lsl #6
 210:	00260400 	eoreq	r0, r6, r0, lsl #8
 214:	00001349 	andeq	r1, r0, r9, asr #6
 218:	0b002405 	bleq	9234 <_Z11split_floatfRjS_Ri+0x430>
 21c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 220:	06000008 	streq	r0, [r0], -r8
 224:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 228:	0b3b0b3a 	bleq	ec2f18 <__bss_end+0xeb9428>
 22c:	13490b39 	movtne	r0, #39737	; 0x9b39
 230:	35070000 	strcc	r0, [r7, #-0]
 234:	00134900 	andseq	r4, r3, r0, lsl #18
 238:	01130800 	tsteq	r3, r0, lsl #16
 23c:	0b0b0e03 	bleq	2c3a50 <__bss_end+0x2b9f60>
 240:	0b3b0b3a 	bleq	ec2f30 <__bss_end+0xeb9440>
 244:	13010b39 	movwne	r0, #6969	; 0x1b39
 248:	0d090000 	stceq	0, cr0, [r9, #-0]
 24c:	3a080300 	bcc	200e54 <__bss_end+0x1f7364>
 250:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 254:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 258:	0a00000b 	beq	28c <shift+0x28c>
 25c:	0e030104 	adfeqs	f0, f3, f4
 260:	0b3e196d 	bleq	f8681c <__bss_end+0xf7cd2c>
 264:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 268:	0b3b0b3a 	bleq	ec2f58 <__bss_end+0xeb9468>
 26c:	13010b39 	movwne	r0, #6969	; 0x1b39
 270:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 274:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 278:	0c00000b 	stceq	0, cr0, [r0], {11}
 27c:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 280:	0000193c 	andeq	r1, r0, ip, lsr r9
 284:	0301020d 	movweq	r0, #4621	; 0x120d
 288:	3a0b0b0e 	bcc	2c2ec8 <__bss_end+0x2b93d8>
 28c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 290:	0013010b 	andseq	r0, r3, fp, lsl #2
 294:	000d0e00 	andeq	r0, sp, r0, lsl #28
 298:	0b3a0e03 	bleq	e83aac <__bss_end+0xe79fbc>
 29c:	0b390b3b 	bleq	e42f90 <__bss_end+0xe394a0>
 2a0:	0b381349 	bleq	e04fcc <__bss_end+0xdfb4dc>
 2a4:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 2a8:	03193f01 	tsteq	r9, #1, 30
 2ac:	3b0b3a0e 	blcc	2ceaec <__bss_end+0x2c4ffc>
 2b0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2b4:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 2b8:	00136419 	andseq	r6, r3, r9, lsl r4
 2bc:	00051000 	andeq	r1, r5, r0
 2c0:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 2c4:	05110000 	ldreq	r0, [r1, #-0]
 2c8:	00134900 	andseq	r4, r3, r0, lsl #18
 2cc:	000d1200 	andeq	r1, sp, r0, lsl #4
 2d0:	0b3a0e03 	bleq	e83ae4 <__bss_end+0xe79ff4>
 2d4:	0b390b3b 	bleq	e42fc8 <__bss_end+0xe394d8>
 2d8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 2dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 2e0:	3f012e13 	svccc	0x00012e13
 2e4:	3a0e0319 	bcc	380f50 <__bss_end+0x377460>
 2e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 2f0:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 2f4:	01136419 	tsteq	r3, r9, lsl r4
 2f8:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 300:	0b3a0e03 	bleq	e83b14 <__bss_end+0xe7a024>
 304:	0b390b3b 	bleq	e42ff8 <__bss_end+0xe39508>
 308:	0b320e6e 	bleq	c83cc8 <__bss_end+0xc7a1d8>
 30c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 310:	00001301 	andeq	r1, r0, r1, lsl #6
 314:	3f012e15 	svccc	0x00012e15
 318:	3a0e0319 	bcc	380f84 <__bss_end+0x377494>
 31c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 320:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 324:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 328:	00136419 	andseq	r6, r3, r9, lsl r4
 32c:	01011600 	tsteq	r1, r0, lsl #12
 330:	13011349 	movwne	r1, #4937	; 0x1349
 334:	21170000 	tstcs	r7, r0
 338:	2f134900 	svccs	0x00134900
 33c:	1800000b 	stmdane	r0, {r0, r1, r3}
 340:	0b0b000f 	bleq	2c0384 <__bss_end+0x2b6894>
 344:	00001349 	andeq	r1, r0, r9, asr #6
 348:	00002119 	andeq	r2, r0, r9, lsl r1
 34c:	00341a00 	eorseq	r1, r4, r0, lsl #20
 350:	0b3a0e03 	bleq	e83b64 <__bss_end+0xe7a074>
 354:	0b390b3b 	bleq	e43048 <__bss_end+0xe39558>
 358:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 35c:	0000193c 	andeq	r1, r0, ip, lsr r9
 360:	0300281b 	movweq	r2, #2075	; 0x81b
 364:	000b1c08 	andeq	r1, fp, r8, lsl #24
 368:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 36c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 370:	0b3b0b3a 	bleq	ec3060 <__bss_end+0xeb9570>
 374:	0e6e0b39 	vmoveq.8	d14[5], r0
 378:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 37c:	00001301 	andeq	r1, r0, r1, lsl #6
 380:	3f012e1d 	svccc	0x00012e1d
 384:	3a0e0319 	bcc	380ff0 <__bss_end+0x377500>
 388:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 38c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 390:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 394:	00130113 	andseq	r0, r3, r3, lsl r1
 398:	000d1e00 	andeq	r1, sp, r0, lsl #28
 39c:	0b3a0e03 	bleq	e83bb0 <__bss_end+0xe7a0c0>
 3a0:	0b390b3b 	bleq	e43094 <__bss_end+0xe395a4>
 3a4:	0b381349 	bleq	e050d0 <__bss_end+0xdfb5e0>
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
 3d4:	3b0b3a08 	blcc	2cebfc <__bss_end+0x2c510c>
 3d8:	010b390b 	tsteq	fp, fp, lsl #18
 3dc:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 3e0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 3e4:	0b3b0b3a 	bleq	ec30d4 <__bss_end+0xeb95e4>
 3e8:	13490b39 	movtne	r0, #39737	; 0x9b39
 3ec:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
 3f0:	0000196c 	andeq	r1, r0, ip, ror #18
 3f4:	03003425 	movweq	r3, #1061	; 0x425
 3f8:	3b0b3a0e 	blcc	2cec38 <__bss_end+0x2c5148>
 3fc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 400:	1c193c13 	ldcne	12, cr3, [r9], {19}
 404:	00196c0b 	andseq	r6, r9, fp, lsl #24
 408:	00342600 	eorseq	r2, r4, r0, lsl #12
 40c:	00001347 	andeq	r1, r0, r7, asr #6
 410:	3f012e27 	svccc	0x00012e27
 414:	3a0e0319 	bcc	381080 <__bss_end+0x377590>
 418:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 41c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 420:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 424:	28000013 	stmdacs	r0, {r0, r1, r4}
 428:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7a150>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe39634>
 434:	01111349 	tsteq	r1, r9, asr #6
 438:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 43c:	01194296 			; <UNDEFINED> instruction: 0x01194296
 440:	29000013 	stmdbcs	r0, {r0, r1, r4}
 444:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 448:	0b3b0b3a 	bleq	ec3138 <__bss_end+0xeb9648>
 44c:	13490b39 	movtne	r0, #39737	; 0x9b39
 450:	00001802 	andeq	r1, r0, r2, lsl #16
 454:	0300342a 	movweq	r3, #1066	; 0x42a
 458:	3b0b3a0e 	blcc	2cec98 <__bss_end+0x2c51a8>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	010b2b00 	tsteq	fp, r0, lsl #22
 468:	06120111 			; <UNDEFINED> instruction: 0x06120111
 46c:	342c0000 	strtcc	r0, [ip], #-0
 470:	3a080300 	bcc	201078 <__bss_end+0x1f7588>
 474:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 478:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 47c:	00000018 	andeq	r0, r0, r8, lsl r0
 480:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 484:	030b130e 	movweq	r1, #45838	; 0xb30e
 488:	110e1b0e 	tstne	lr, lr, lsl #22
 48c:	10061201 	andne	r1, r6, r1, lsl #4
 490:	02000017 	andeq	r0, r0, #23
 494:	0b0b0024 	bleq	2c052c <__bss_end+0x2b6a3c>
 498:	0e030b3e 	vmoveq.16	d3[0], r0
 49c:	26030000 	strcs	r0, [r3], -r0
 4a0:	00134900 	andseq	r4, r3, r0, lsl #18
 4a4:	00240400 	eoreq	r0, r4, r0, lsl #8
 4a8:	0b3e0b0b 	bleq	f830dc <__bss_end+0xf795ec>
 4ac:	00000803 	andeq	r0, r0, r3, lsl #16
 4b0:	03001605 	movweq	r1, #1541	; 0x605
 4b4:	3b0b3a0e 	blcc	2cecf4 <__bss_end+0x2c5204>
 4b8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4bc:	06000013 			; <UNDEFINED> instruction: 0x06000013
 4c0:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 4c4:	0b3a0b0b 	bleq	e830f8 <__bss_end+0xe79608>
 4c8:	0b390b3b 	bleq	e431bc <__bss_end+0xe396cc>
 4cc:	00001301 	andeq	r1, r0, r1, lsl #6
 4d0:	03000d07 	movweq	r0, #3335	; 0xd07
 4d4:	3b0b3a08 	blcc	2cecfc <__bss_end+0x2c520c>
 4d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4dc:	000b3813 	andeq	r3, fp, r3, lsl r8
 4e0:	01040800 	tsteq	r4, r0, lsl #16
 4e4:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 4e8:	0b0b0b3e 	bleq	2c31e8 <__bss_end+0x2b96f8>
 4ec:	0b3a1349 	bleq	e85218 <__bss_end+0xe7b728>
 4f0:	0b390b3b 	bleq	e431e4 <__bss_end+0xe396f4>
 4f4:	00001301 	andeq	r1, r0, r1, lsl #6
 4f8:	03002809 	movweq	r2, #2057	; 0x809
 4fc:	000b1c08 	andeq	r1, fp, r8, lsl #24
 500:	00280a00 	eoreq	r0, r8, r0, lsl #20
 504:	0b1c0e03 	bleq	703d18 <__bss_end+0x6fa228>
 508:	340b0000 	strcc	r0, [fp], #-0
 50c:	3a0e0300 	bcc	381114 <__bss_end+0x377624>
 510:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 514:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 518:	00180219 	andseq	r0, r8, r9, lsl r2
 51c:	00020c00 	andeq	r0, r2, r0, lsl #24
 520:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 524:	020d0000 	andeq	r0, sp, #0
 528:	0b0e0301 	bleq	381134 <__bss_end+0x377644>
 52c:	3b0b3a0b 	blcc	2ced60 <__bss_end+0x2c5270>
 530:	010b390b 	tsteq	fp, fp, lsl #18
 534:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 538:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 53c:	0b3b0b3a 	bleq	ec322c <__bss_end+0xeb973c>
 540:	13490b39 	movtne	r0, #39737	; 0x9b39
 544:	00000b38 	andeq	r0, r0, r8, lsr fp
 548:	3f012e0f 	svccc	0x00012e0f
 54c:	3a0e0319 	bcc	3811b8 <__bss_end+0x3776c8>
 550:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 554:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 558:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 55c:	10000013 	andne	r0, r0, r3, lsl r0
 560:	13490005 	movtne	r0, #36869	; 0x9005
 564:	00001934 	andeq	r1, r0, r4, lsr r9
 568:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 56c:	12000013 	andne	r0, r0, #19
 570:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 574:	0b3b0b3a 	bleq	ec3264 <__bss_end+0xeb9774>
 578:	13490b39 	movtne	r0, #39737	; 0x9b39
 57c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 580:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 584:	03193f01 	tsteq	r9, #1, 30
 588:	3b0b3a0e 	blcc	2cedc8 <__bss_end+0x2c52d8>
 58c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 590:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 594:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 598:	00130113 	andseq	r0, r3, r3, lsl r1
 59c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 5a0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeb97a4>
 5a8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5ac:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5b0:	13011364 	movwne	r1, #4964	; 0x1364
 5b4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 5b8:	03193f01 	tsteq	r9, #1, 30
 5bc:	3b0b3a0e 	blcc	2cedfc <__bss_end+0x2c530c>
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
 5f4:	0b3b0b3a 	bleq	ec32e4 <__bss_end+0xeb97f4>
 5f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5fc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 600:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 604:	03193f01 	tsteq	r9, #1, 30
 608:	3b0b3a0e 	blcc	2cee48 <__bss_end+0x2c5358>
 60c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 610:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 614:	00130113 	andseq	r0, r3, r3, lsl r1
 618:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 61c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 620:	0b3b0b3a 	bleq	ec3310 <__bss_end+0xeb9820>
 624:	0e6e0b39 	vmoveq.8	d14[5], r0
 628:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 62c:	13011364 	movwne	r1, #4964	; 0x1364
 630:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 634:	3a0e0300 	bcc	38123c <__bss_end+0x37774c>
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
 66c:	0b3a0e03 	bleq	e83e80 <__bss_end+0xe7a390>
 670:	0b390b3b 	bleq	e43364 <__bss_end+0xe39874>
 674:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 678:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 67c:	03193f01 	tsteq	r9, #1, 30
 680:	3b0b3a0e 	blcc	2ceec0 <__bss_end+0x2c53d0>
 684:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 688:	1113490e 	tstne	r3, lr, lsl #18
 68c:	40061201 	andmi	r1, r6, r1, lsl #4
 690:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 694:	00001301 	andeq	r1, r0, r1, lsl #6
 698:	03000524 	movweq	r0, #1316	; 0x524
 69c:	3b0b3a0e 	blcc	2ceedc <__bss_end+0x2c53ec>
 6a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6a4:	00180213 	andseq	r0, r8, r3, lsl r2
 6a8:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 6ac:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6b0:	0b3b0b3a 	bleq	ec33a0 <__bss_end+0xeb98b0>
 6b4:	0e6e0b39 	vmoveq.8	d14[5], r0
 6b8:	01111349 	tsteq	r1, r9, asr #6
 6bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 6c0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 6c4:	26000013 			; <UNDEFINED> instruction: 0x26000013
 6c8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 6cc:	0b3b0b3a 	bleq	ec33bc <__bss_end+0xeb98cc>
 6d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6d4:	00001802 	andeq	r1, r0, r2, lsl #16
 6d8:	3f012e27 	svccc	0x00012e27
 6dc:	3a0e0319 	bcc	381348 <__bss_end+0x377858>
 6e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6e4:	110e6e0b 	tstne	lr, fp, lsl #28
 6e8:	40061201 	andmi	r1, r6, r1, lsl #4
 6ec:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6f0:	00001301 	andeq	r1, r0, r1, lsl #6
 6f4:	3f002e28 	svccc	0x00002e28
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x377874>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	110e6e0b 	tstne	lr, fp, lsl #28
 704:	40061201 	andmi	r1, r6, r1, lsl #4
 708:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 70c:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 710:	03193f01 	tsteq	r9, #1, 30
 714:	3b0b3a0e 	blcc	2cef54 <__bss_end+0x2c5464>
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
 740:	3a0e0300 	bcc	381348 <__bss_end+0x377858>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 74c:	00180219 	andseq	r0, r8, r9, lsl r2
 750:	00240300 	eoreq	r0, r4, r0, lsl #6
 754:	0b3e0b0b 	bleq	f83388 <__bss_end+0xf79898>
 758:	00000e03 	andeq	r0, r0, r3, lsl #28
 75c:	49002604 	stmdbmi	r0, {r2, r9, sl, sp}
 760:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 764:	13010139 	movwne	r0, #4409	; 0x1139
 768:	34060000 	strcc	r0, [r6], #-0
 76c:	3a0e0300 	bcc	381374 <__bss_end+0x377884>
 770:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 774:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 778:	000a1c19 	andeq	r1, sl, r9, lsl ip
 77c:	003a0700 	eorseq	r0, sl, r0, lsl #14
 780:	0b3b0b3a 	bleq	ec3470 <__bss_end+0xeb9980>
 784:	13180b39 	tstne	r8, #58368	; 0xe400
 788:	01080000 	mrseq	r0, (UNDEF: 8)
 78c:	01134901 	tsteq	r3, r1, lsl #18
 790:	09000013 	stmdbeq	r0, {r0, r1, r4}
 794:	13490021 	movtne	r0, #36897	; 0x9021
 798:	00000b2f 	andeq	r0, r0, pc, lsr #22
 79c:	4700340a 	strmi	r3, [r0, -sl, lsl #8]
 7a0:	0b000013 	bleq	7f4 <shift+0x7f4>
 7a4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7a8:	0b3a0e03 	bleq	e83fbc <__bss_end+0xe7a4cc>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe399b0>
 7b0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 7b4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7b8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7bc:	00130119 	andseq	r0, r3, r9, lsl r1
 7c0:	00050c00 	andeq	r0, r5, r0, lsl #24
 7c4:	0b3a0803 	bleq	e827d8 <__bss_end+0xe78ce8>
 7c8:	0b390b3b 	bleq	e434bc <__bss_end+0xe399cc>
 7cc:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7d0:	340d0000 	strcc	r0, [sp], #-0
 7d4:	3a080300 	bcc	2013dc <__bss_end+0x1f78ec>
 7d8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7dc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7e0:	0e000018 	mcreq	0, 0, r0, cr0, cr8, {0}
 7e4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7e8:	0b3b0b3a 	bleq	ec34d8 <__bss_end+0xeb99e8>
 7ec:	13490b39 	movtne	r0, #39737	; 0x9b39
 7f0:	00001802 	andeq	r1, r0, r2, lsl #16
 7f4:	11010b0f 	tstne	r1, pc, lsl #22
 7f8:	00061201 	andeq	r1, r6, r1, lsl #4
 7fc:	00341000 	eorseq	r1, r4, r0
 800:	0b3a0e03 	bleq	e84014 <__bss_end+0xe7a524>
 804:	0b39053b 	bleq	e41cf8 <__bss_end+0xe38208>
 808:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 80c:	34110000 	ldrcc	r0, [r1], #-0
 810:	3a080300 	bcc	201418 <__bss_end+0x1f7928>
 814:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 818:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 81c:	12000018 	andne	r0, r0, #24
 820:	0b0b000f 	bleq	2c0864 <__bss_end+0x2b6d74>
 824:	00001349 	andeq	r1, r0, r9, asr #6
 828:	0b002413 	bleq	987c <__udivsi3+0x84>
 82c:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 830:	14000008 	strne	r0, [r0], #-8
 834:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 838:	0b3a0e03 	bleq	e8404c <__bss_end+0xe7a55c>
 83c:	0b390b3b 	bleq	e43530 <__bss_end+0xe39a40>
 840:	01110e6e 	tsteq	r1, lr, ror #28
 844:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 848:	01194296 			; <UNDEFINED> instruction: 0x01194296
 84c:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 850:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 854:	0b3b0b3a 	bleq	ec3544 <__bss_end+0xeb9a54>
 858:	13490b39 	movtne	r0, #39737	; 0x9b39
 85c:	00001802 	andeq	r1, r0, r2, lsl #16
 860:	11010b16 	tstne	r1, r6, lsl fp
 864:	01061201 	tsteq	r6, r1, lsl #4
 868:	17000013 	smladne	r0, r3, r0, r0
 86c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 870:	0b3a0e03 	bleq	e84084 <__bss_end+0xe7a594>
 874:	0b390b3b 	bleq	e43568 <__bss_end+0xe39a78>
 878:	01110e6e 	tsteq	r1, lr, ror #28
 87c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 880:	01194297 			; <UNDEFINED> instruction: 0x01194297
 884:	18000013 	stmdane	r0, {r0, r1, r4}
 888:	0b0b0010 	bleq	2c08d0 <__bss_end+0x2b6de0>
 88c:	00001349 	andeq	r1, r0, r9, asr #6
 890:	3f012e19 	svccc	0x00012e19
 894:	3a080319 	bcc	201500 <__bss_end+0x1f7a10>
 898:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 89c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 8a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 8a4:	97184006 	ldrls	r4, [r8, -r6]
 8a8:	13011942 	movwne	r1, #6466	; 0x1942
 8ac:	261a0000 	ldrcs	r0, [sl], -r0
 8b0:	1b000000 	blne	8b8 <shift+0x8b8>
 8b4:	0b0b000f 	bleq	2c08f8 <__bss_end+0x2b6e08>
 8b8:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 8bc:	03193f01 	tsteq	r9, #1, 30
 8c0:	3b0b3a0e 	blcc	2cf100 <__bss_end+0x2c5610>
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
 900:	0b130e25 	bleq	4c419c <__bss_end+0x4ba6ac>
 904:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 908:	00001710 	andeq	r1, r0, r0, lsl r7
 90c:	0b002402 	bleq	991c <__udivsi3+0x124>
 910:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 914:	03000008 	movweq	r0, #8
 918:	0b0b0024 	bleq	2c09b0 <__bss_end+0x2b6ec0>
 91c:	0e030b3e 	vmoveq.16	d3[0], r0
 920:	16040000 	strne	r0, [r4], -r0
 924:	3a0e0300 	bcc	38152c <__bss_end+0x377a3c>
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
 954:	0b3a0e03 	bleq	e84168 <__bss_end+0xe7a678>
 958:	0b390b3b 	bleq	e4364c <__bss_end+0xe39b5c>
 95c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 960:	0000193c 	andeq	r1, r0, ip, lsr r9
 964:	0301040a 	movweq	r0, #5130	; 0x140a
 968:	0b0b3e0e 	bleq	2d01a8 <__bss_end+0x2c66b8>
 96c:	3a13490b 	bcc	4d2da0 <__bss_end+0x4c92b0>
 970:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 974:	0013010b 	andseq	r0, r3, fp, lsl #2
 978:	00280b00 	eoreq	r0, r8, r0, lsl #22
 97c:	0b1c0e03 	bleq	704190 <__bss_end+0x6fa6a0>
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
 9c8:	0b3a0b0b 	bleq	e835fc <__bss_end+0xe79b0c>
 9cc:	0b39053b 	bleq	e41ec0 <__bss_end+0xe383d0>
 9d0:	00001301 	andeq	r1, r0, r1, lsl #6
 9d4:	03000d14 	movweq	r0, #3348	; 0xd14
 9d8:	3b0b3a0e 	blcc	2cf218 <__bss_end+0x2c5728>
 9dc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 9e0:	000b3813 	andeq	r3, fp, r3, lsl r8
 9e4:	00211500 	eoreq	r1, r1, r0, lsl #10
 9e8:	0b2f1349 	bleq	bc5714 <__bss_end+0xbbbc24>
 9ec:	04160000 	ldreq	r0, [r6], #-0
 9f0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 9f4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 9f8:	3b0b3a13 	blcc	2cf24c <__bss_end+0x2c575c>
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
  84:	10f60002 	rscsne	r0, r6, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083c0 	andeq	r8, r0, r0, asr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1def0002 	stclne	0, cr0, [pc, #8]!	; b4 <shift+0xb4>
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	0000881c 	andeq	r8, r0, ip, lsl r8
  b4:	00000fdc 	ldrdeq	r0, [r0], -ip
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	24ec0002 	strbtcs	r0, [ip], #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	000097f8 	strdeq	r9, [r0], -r8
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	25120002 	ldrcs	r0, [r2, #-2]
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00009a04 	andeq	r9, r0, r4, lsl #20
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	25380002 	ldrcs	r0, [r8, #-2]!
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff645c>
       4:	616a2f65 	cmnvs	sl, r5, ror #30
       8:	6173656d 	cmnvs	r3, sp, ror #10
       c:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
      10:	6f2f7469 	svcvs	0x002f7469
      14:	70732f73 	rsbsvc	r2, r3, r3, ror pc
      18:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf1 <__bss_end+0xffff6201>
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
      50:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf3 <__bss_end+0xffff6203>
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
     128:	2b6b7a36 	blcs	1adea08 <__bss_end+0x1ad4f18>
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
     168:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe41 <__bss_end+0xffff6351>
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
     21c:	2b432055 	blcs	10c8378 <__bss_end+0x10be888>
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
     368:	6a2f656d 	bvs	bd9924 <__bss_end+0xbcfe34>
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
     4ac:	5a5f0065 	bpl	17c0648 <__bss_end+0x17b6b58>
     4b0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     4b4:	4f495047 	svcmi	0x00495047
     4b8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     4bc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     4c0:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4c4:	706e495f 	rsbvc	r4, lr, pc, asr r9
     4c8:	6a457475 	bvs	115d6a4 <__bss_end+0x1153bb4>
     4cc:	43534200 	cmpmi	r3, #0, 4
     4d0:	61425f32 	cmpvs	r2, r2, lsr pc
     4d4:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
     4d8:	636f7250 	cmnvs	pc, #80, 4
     4dc:	5f737365 	svcpl	0x00737365
     4e0:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     4e4:	6165485f 	cmnvs	r5, pc, asr r8
     4e8:	65530064 	ldrbvs	r0, [r3, #-100]	; 0xffffff9c
     4ec:	50475f74 	subpl	r5, r7, r4, ror pc
     4f0:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     4f4:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     4f8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     4fc:	4b4e5a5f 	blmi	1396e80 <__bss_end+0x138d390>
     500:	50433631 	subpl	r3, r3, r1, lsr r6
     504:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     508:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 344 <shift+0x344>
     50c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     510:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     514:	5f746547 	svcpl	0x00746547
     518:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     51c:	5f746e65 	svcpl	0x00746e65
     520:	636f7250 	cmnvs	pc, #80, 4
     524:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     528:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     52c:	50475f74 	subpl	r5, r7, r4, ror pc
     530:	5f534445 	svcpl	0x00534445
     534:	61636f4c 	cmnvs	r3, ip, asr #30
     538:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     53c:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     540:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     544:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     548:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     54c:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     550:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     554:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff85c <__bss_end+0xffff5d6c>
     558:	6f50746e 	svcvs	0x0050746e
     55c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     560:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     564:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     568:	0079726f 	rsbseq	r7, r9, pc, ror #4
     56c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     570:	6f72505f 	svcvs	0x0072505f
     574:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     578:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     57c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     580:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     584:	5f657669 	svcpl	0x00657669
     588:	636f7250 	cmnvs	pc, #80, 4
     58c:	5f737365 	svcpl	0x00737365
     590:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     594:	506d0074 	rsbpl	r0, sp, r4, ror r0
     598:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     59c:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     5a0:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     5a4:	5f736e6f 	svcpl	0x00736e6f
     5a8:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     5ac:	61575400 	cmpvs	r7, r0, lsl #8
     5b0:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     5b4:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     5b8:	4300656c 	movwmi	r6, #1388	; 0x56c
     5bc:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     5c0:	72505f65 	subsvc	r5, r0, #404	; 0x194
     5c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c8:	476d0073 			; <UNDEFINED> instruction: 0x476d0073
     5cc:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     5d0:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     5d4:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     5d8:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     5dc:	616e656c 	cmnvs	lr, ip, ror #10
     5e0:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     5e4:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     5e8:	58554100 	ldmdapl	r5, {r8, lr}^
     5ec:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     5f0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     5f4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     5f8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     5fc:	5f72656c 	svcpl	0x0072656c
     600:	6f666e49 	svcvs	0x00666e49
     604:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     608:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     60c:	00745f6b 	rsbseq	r5, r4, fp, ror #30
     610:	65637361 	strbvs	r7, [r3, #-865]!	; 0xfffffc9f
     614:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
     618:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     61c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     620:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ba <shift+0xba>
     624:	6168636e 	cmnvs	r8, lr, ror #6
     628:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     62c:	72504300 	subsvc	r4, r0, #0, 6
     630:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     634:	614d5f73 	hvcvs	54771	; 0xd5f3
     638:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     63c:	5a5f0072 	bpl	17c080c <__bss_end+0x17b6d1c>
     640:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     644:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     648:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     64c:	34436d65 	strbcc	r6, [r3], #-3429	; 0xfffff29b
     650:	5f007645 	svcpl	0x00007645
     654:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     658:	6f725043 	svcvs	0x00725043
     65c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     660:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     664:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     668:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     66c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     670:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     674:	5f72656c 	svcpl	0x0072656c
     678:	6f666e49 	svcvs	0x00666e49
     67c:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     680:	5f746547 	svcpl	0x00746547
     684:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     688:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     68c:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 694 <shift+0x694>
     690:	50657079 	rsbpl	r7, r5, r9, ror r0
     694:	5a5f0076 	bpl	17c0874 <__bss_end+0x17b6d84>
     698:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     69c:	4f495047 	svcmi	0x00495047
     6a0:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     6a4:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     6a8:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
     6ac:	5f726165 	svcpl	0x00726165
     6b0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     6b4:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     6b8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     6bc:	6a45746e 	bvs	115d87c <__bss_end+0x1153d8c>
     6c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6c4:	50433631 	subpl	r3, r3, r1, lsr r6
     6c8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6cc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 508 <shift+0x508>
     6d0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6d4:	31327265 	teqcc	r2, r5, ror #4
     6d8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     6dc:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     6e0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6e4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6e8:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     6ec:	33324549 	teqcc	r2, #306184192	; 0x12400000
     6f0:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     6f4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6f8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     6fc:	5f6d6574 	svcpl	0x006d6574
     700:	76726553 			; <UNDEFINED> instruction: 0x76726553
     704:	6a656369 	bvs	19594b0 <__bss_end+0x194f9c0>
     708:	31526a6a 	cmpcc	r2, sl, ror #20
     70c:	57535431 	smmlarpl	r3, r1, r4, r5
     710:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     714:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     718:	6c614600 	stclvs	6, cr4, [r1], #-0
     71c:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     720:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     724:	706f0065 	rsbvc	r0, pc, r5, rrx
     728:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     72c:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     730:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     734:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     738:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     73c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     740:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     744:	5f4f4950 	svcpl	0x004f4950
     748:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     74c:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     750:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     754:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     758:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     75c:	445f746e 	ldrbmi	r7, [pc], #-1134	; 764 <shift+0x764>
     760:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     764:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     768:	50474e30 	subpl	r4, r7, r0, lsr lr
     76c:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     770:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     774:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     778:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     77c:	43540065 	cmpmi	r4, #101	; 0x65
     780:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     784:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     788:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     78c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     790:	00656e69 	rsbeq	r6, r5, r9, ror #28
     794:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     798:	5a5f0030 	bpl	17c0860 <__bss_end+0x17b6d70>
     79c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7a0:	636f7250 	cmnvs	pc, #80, 4
     7a4:	5f737365 	svcpl	0x00737365
     7a8:	616e614d 	cmnvs	lr, sp, asr #2
     7ac:	31726567 	cmncc	r2, r7, ror #10
     7b0:	746f4e34 	strbtvc	r4, [pc], #-3636	; 7b8 <shift+0x7b8>
     7b4:	5f796669 	svcpl	0x00796669
     7b8:	636f7250 	cmnvs	pc, #80, 4
     7bc:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     7c0:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     7c4:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7c8:	53420044 	movtpl	r0, #8260	; 0x2044
     7cc:	425f3043 	subsmi	r3, pc, #67	; 0x43
     7d0:	00657361 	rsbeq	r7, r5, r1, ror #6
     7d4:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
     7d8:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
     7dc:	2f00646c 	svccs	0x0000646c
     7e0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     7e4:	6d616a2f 	vstmdbvs	r1!, {s13-s59}
     7e8:	72617365 	rsbvc	r7, r1, #-1811939327	; 0x94000001
     7ec:	69672f69 	stmdbvs	r7!, {r0, r3, r5, r6, r8, r9, sl, fp, sp}^
     7f0:	736f2f74 	cmnvc	pc, #116, 30	; 0x1d0
     7f4:	2f70732f 	svccs	0x0070732f
     7f8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     7fc:	2f736563 	svccs	0x00736563
     800:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     804:	63617073 	cmnvs	r1, #115	; 0x73
     808:	6f632f65 	svcvs	0x00632f65
     80c:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     810:	61745f72 	cmnvs	r4, r2, ror pc
     814:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     818:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     81c:	00707063 	rsbseq	r7, r0, r3, rrx
     820:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     824:	70757272 	rsbsvc	r7, r5, r2, ror r2
     828:	6f435f74 	svcvs	0x00435f74
     82c:	6f72746e 	svcvs	0x0072746e
     830:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     834:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     838:	5a5f0065 	bpl	17c09d4 <__bss_end+0x17b6ee4>
     83c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     840:	4f495047 	svcmi	0x00495047
     844:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     848:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     84c:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     850:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     854:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     858:	53420062 	movtpl	r0, #8290	; 0x2062
     85c:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     860:	00657361 	rsbeq	r7, r5, r1, ror #6
     864:	5f78614d 	svcpl	0x0078614d
     868:	636f7250 	cmnvs	pc, #80, 4
     86c:	5f737365 	svcpl	0x00737365
     870:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     874:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     878:	73656c69 	cmnvc	r5, #26880	; 0x6900
     87c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     880:	50433631 	subpl	r3, r3, r1, lsr r6
     884:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     888:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6c4 <shift+0x6c4>
     88c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     890:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     894:	616d6e55 	cmnvs	sp, r5, asr lr
     898:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     89c:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     8a0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     8a4:	6a45746e 	bvs	115da64 <__bss_end+0x1153f74>
     8a8:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     8ac:	61425f47 	cmpvs	r2, r7, asr #30
     8b0:	48006573 	stmdami	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     8b4:	00686769 	rsbeq	r6, r8, r9, ror #14
     8b8:	5f534667 	svcpl	0x00534667
     8bc:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     8c0:	5f737265 	svcpl	0x00737265
     8c4:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     8c8:	5a5f0074 	bpl	17c0aa0 <__bss_end+0x17b6fb0>
     8cc:	33314b4e 	teqcc	r1, #79872	; 0x13800
     8d0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     8d4:	61485f4f 	cmpvs	r8, pc, asr #30
     8d8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     8dc:	47363272 			; <UNDEFINED> instruction: 0x47363272
     8e0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8e4:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     8e8:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     8ec:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     8f0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     8f4:	6f697461 	svcvs	0x00697461
     8f8:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     8fc:	50474e30 	subpl	r4, r7, r0, lsr lr
     900:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     904:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     908:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     90c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     910:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     914:	52005f31 	andpl	r5, r0, #49, 30	; 0xc4
     918:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     91c:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     920:	6d006567 	cfstr32vs	mvfx6, [r0, #-412]	; 0xfffffe64
     924:	746f6f52 	strbtvc	r6, [pc], #-3922	; 92c <shift+0x92c>
     928:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     92c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     930:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     934:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     938:	6f72505f 	svcvs	0x0072505f
     93c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     940:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     944:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     948:	6f545f65 	svcvs	0x00545f65
     94c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     950:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     954:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     958:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     95c:	4f495047 	svcmi	0x00495047
     960:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     964:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     968:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     96c:	50475f74 	subpl	r5, r7, r4, ror pc
     970:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     974:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     978:	6f697461 	svcvs	0x00697461
     97c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     980:	5f30536a 	svcpl	0x0030536a
     984:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     988:	32686374 	rsbcc	r6, r8, #116, 6	; 0xd0000001
     98c:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     990:	6f4e0065 	svcvs	0x004e0065
     994:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     998:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     99c:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     9a0:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     9a4:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     9a8:	5f656c64 	svcpl	0x00656c64
     9ac:	636f7250 	cmnvs	pc, #80, 4
     9b0:	5f737365 	svcpl	0x00737365
     9b4:	00495753 	subeq	r5, r9, r3, asr r7
     9b8:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     9bc:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     9c0:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     9c4:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     9c8:	5300746e 	movwpl	r7, #1134	; 0x46e
     9cc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9d0:	5f656c75 	svcpl	0x00656c75
     9d4:	00464445 	subeq	r4, r6, r5, asr #8
     9d8:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     9dc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9e0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     9e4:	5f4f4950 	svcpl	0x004f4950
     9e8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     9ec:	3172656c 	cmncc	r2, ip, ror #10
     9f0:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
     9f4:	5f656c64 	svcpl	0x00656c64
     9f8:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     9fc:	5a5f0076 	bpl	17c0bdc <__bss_end+0x17b70ec>
     a00:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     a04:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a08:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a0c:	30316d65 	eorscc	r6, r1, r5, ror #26
     a10:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     a14:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     a18:	7645657a 			; <UNDEFINED> instruction: 0x7645657a
     a1c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     a20:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a24:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     a28:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     a2c:	5f746e65 	svcpl	0x00746e65
     a30:	006e6950 	rsbeq	r6, lr, r0, asr r9
     a34:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a38:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a3c:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     a40:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     a44:	00706565 	rsbseq	r6, r0, r5, ror #10
     a48:	6f6f526d 	svcvs	0x006f526d
     a4c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a50:	69640076 	stmdbvs	r4!, {r1, r2, r4, r5, r6}^
     a54:	616c7073 	smcvs	50947	; 0xc703
     a58:	69665f79 	stmdbvs	r6!, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a5c:	6200656c 	andvs	r6, r0, #108, 10	; 0x1b000000
     a60:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     a64:	5f746c41 	svcpl	0x00746c41
     a68:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     a6c:	00325f74 	eorseq	r5, r2, r4, ror pc
     a70:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     a74:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a78:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     a7c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     a80:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     a84:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     a88:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a8c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     a90:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     a94:	41006570 	tstmi	r0, r0, ror r5
     a98:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 634 <shift+0x634>
     a9c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     aa0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     aa4:	5f4f4950 	svcpl	0x004f4950
     aa8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     aac:	3172656c 	cmncc	r2, ip, ror #10
     ab0:	74655330 	strbtvc	r5, [r5], #-816	; 0xfffffcd0
     ab4:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     ab8:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     abc:	5200626a 	andpl	r6, r0, #-1610612730	; 0xa0000006
     ac0:	616e6e75 	smcvs	59109	; 0xe6e5
     ac4:	00656c62 	rsbeq	r6, r5, r2, ror #24
     ac8:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     acc:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     ad0:	00657461 	rsbeq	r7, r5, r1, ror #8
     ad4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     ad8:	6f635f64 	svcvs	0x00635f64
     adc:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     ae0:	63730072 	cmnvs	r3, #114	; 0x72
     ae4:	5f646568 	svcpl	0x00646568
     ae8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     aec:	705f6369 	subsvc	r6, pc, r9, ror #6
     af0:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     af4:	00797469 	rsbseq	r7, r9, r9, ror #8
     af8:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     afc:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     b00:	6700657a 	smlsdxvs	r0, sl, r5, r6
     b04:	445f5346 	ldrbmi	r5, [pc], #-838	; b0c <shift+0xb0c>
     b08:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     b0c:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     b10:	5f746978 	svcpl	0x00746978
     b14:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     b18:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     b1c:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     b20:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     b24:	616e4500 	cmnvs	lr, r0, lsl #10
     b28:	5f656c62 	svcpl	0x00656c62
     b2c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     b30:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     b34:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     b38:	50477300 	subpl	r7, r7, r0, lsl #6
     b3c:	6d004f49 	stcvs	15, cr4, [r0, #-292]	; 0xfffffedc
     b40:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b44:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b48:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     b4c:	72507300 	subsvc	r7, r0, #0, 6
     b50:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b54:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
     b58:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     b5c:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     b60:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b64:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     b68:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     b6c:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     b70:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     b74:	6e550079 	mrcvs	0, 2, r0, cr5, cr9, {3}
     b78:	5f70616d 	svcpl	0x0070616d
     b7c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b80:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     b84:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     b88:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     b8c:	6f465f74 	svcvs	0x00465f74
     b90:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     b94:	00746e65 	rsbseq	r6, r4, r5, ror #28
     b98:	4b4e5a5f 	blmi	139751c <__bss_end+0x138da2c>
     b9c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     ba0:	5f4f4950 	svcpl	0x004f4950
     ba4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     ba8:	3172656c 	cmncc	r2, ip, ror #10
     bac:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     bb0:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     bb4:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     bb8:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     bbc:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     bc0:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     bc4:	4c005f30 	stcmi	15, cr5, [r0], {48}	; 0x30
     bc8:	5f6b636f 	svcpl	0x006b636f
     bcc:	6f6c6e55 	svcvs	0x006c6e55
     bd0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     bd4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     bd8:	61425f4f 	cmpvs	r2, pc, asr #30
     bdc:	47006573 	smlsdxmi	r0, r3, r5, r6
     be0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     be4:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     be8:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     bec:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     bf0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     bf4:	6f697461 	svcvs	0x00697461
     bf8:	4e49006e 	cdpmi	0, 4, cr0, cr9, cr14, {3}
     bfc:	494e4946 	stmdbmi	lr, {r1, r2, r6, r8, fp, lr}^
     c00:	47005954 	smlsdmi	r0, r4, r9, r5
     c04:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     c08:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     c0c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c10:	6f697461 	svcvs	0x00697461
     c14:	6f4c006e 	svcvs	0x004c006e
     c18:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     c1c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     c20:	506d0064 	rsbpl	r0, sp, r4, rrx
     c24:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     c28:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     c2c:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     c30:	5f736e6f 	svcpl	0x00736e6f
     c34:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c38:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c3c:	50475f74 	subpl	r5, r7, r4, ror pc
     c40:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     c44:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c48:	6f697461 	svcvs	0x00697461
     c4c:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     c50:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffce4 <__bss_end+0xffff61f4>
     c54:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     c58:	61655200 	cmnvs	r5, r0, lsl #4
     c5c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     c60:	00657469 	rsbeq	r7, r5, r9, ror #8
     c64:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     c68:	44006569 	strmi	r6, [r0], #-1385	; 0xfffffa97
     c6c:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
     c70:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     c74:	6b636f6c 	blvs	18dca2c <__bss_end+0x18d2f3c>
     c78:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     c7c:	5a5f0065 	bpl	17c0e18 <__bss_end+0x17b7328>
     c80:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     c84:	4f495047 	svcmi	0x00495047
     c88:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     c8c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     c90:	65533731 	ldrbvs	r3, [r3, #-1841]	; 0xfffff8cf
     c94:	50475f74 	subpl	r5, r7, r4, ror pc
     c98:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     c9c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     ca0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     ca4:	4e34316a 	rsfmisz	f3, f4, #2.0
     ca8:	4f495047 	svcmi	0x00495047
     cac:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     cb0:	6f697463 	svcvs	0x00697463
     cb4:	6547006e 	strbvs	r0, [r7, #-110]	; 0xffffff92
     cb8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     cbc:	5f646568 	svcpl	0x00646568
     cc0:	6f666e49 	svcvs	0x00666e49
     cc4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cc8:	50433631 	subpl	r3, r3, r1, lsr r6
     ccc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cd0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b0c <shift+0xb0c>
     cd4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cd8:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     cdc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ce0:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     ce4:	5a5f0076 	bpl	17c0ec4 <__bss_end+0x17b73d4>
     ce8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     cec:	636f7250 	cmnvs	pc, #80, 4
     cf0:	5f737365 	svcpl	0x00737365
     cf4:	616e614d 	cmnvs	lr, sp, asr #2
     cf8:	31726567 	cmncc	r2, r7, ror #10
     cfc:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     d00:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     d04:	6f545f65 	svcvs	0x00545f65
     d08:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     d0c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     d10:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     d14:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d18:	73694400 	cmnvc	r9, #0, 8
     d1c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d20:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d24:	445f746e 	ldrbmi	r7, [pc], #-1134	; d2c <shift+0xd2c>
     d28:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     d2c:	68630074 	stmdavs	r3!, {r2, r4, r5, r6}^
     d30:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     d34:	4d006e65 	stcmi	14, cr6, [r0, #-404]	; 0xfffffe6c
     d38:	61507861 	cmpvs	r0, r1, ror #16
     d3c:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     d40:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     d44:	736e7500 	cmnvc	lr, #0, 10
     d48:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     d4c:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     d50:	5f007261 	svcpl	0x00007261
     d54:	314b4e5a 	cmpcc	fp, sl, asr lr
     d58:	50474333 	subpl	r4, r7, r3, lsr r3
     d5c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     d60:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     d64:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     d68:	5f746547 	svcpl	0x00746547
     d6c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d70:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     d74:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d78:	505f746e 	subspl	r7, pc, lr, ror #8
     d7c:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     d80:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d84:	50433631 	subpl	r3, r3, r1, lsr r6
     d88:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d8c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; bc8 <shift+0xbc8>
     d90:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d94:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     d98:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d9c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     da0:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     da4:	43007645 	movwmi	r7, #1605	; 0x645
     da8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     dac:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     db0:	47006d65 	strmi	r6, [r0, -r5, ror #26]
     db4:	5f4f4950 	svcpl	0x004f4950
     db8:	5f6e6950 	svcpl	0x006e6950
     dbc:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     dc0:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     dc4:	2074726f 	rsbscs	r7, r4, pc, ror #4
     dc8:	00746e69 	rsbseq	r6, r4, r9, ror #28
     dcc:	5f534654 	svcpl	0x00534654
     dd0:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     dd4:	5f007265 	svcpl	0x00007265
     dd8:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     ddc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     de0:	61485f4f 	cmpvs	r8, pc, asr #30
     de4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     de8:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     dec:	6550006a 	ldrbvs	r0, [r0, #-106]	; 0xffffff96
     df0:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     df4:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     df8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     dfc:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     e00:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     e04:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e08:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e0c:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e10:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     e14:	7552006b 	ldrbvc	r0, [r2, #-107]	; 0xffffff95
     e18:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     e1c:	5a5f0067 	bpl	17c0fc0 <__bss_end+0x17b74d0>
     e20:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     e24:	4f495047 	svcmi	0x00495047
     e28:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     e2c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     e30:	61573431 	cmpvs	r7, r1, lsr r4
     e34:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
     e38:	455f726f 	ldrbmi	r7, [pc, #-623]	; bd1 <shift+0xbd1>
     e3c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e40:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     e44:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e48:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     e4c:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     e50:	5200745f 	andpl	r7, r0, #1593835520	; 0x5f000000
     e54:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     e58:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     e5c:	47006e69 	strmi	r6, [r0, -r9, ror #28]
     e60:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     e64:	5f4f4950 	svcpl	0x004f4950
     e68:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     e6c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e70:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     e74:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     e78:	00657361 	rsbeq	r7, r5, r1, ror #6
     e7c:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     e80:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     e84:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     e88:	6f4e5f6b 	svcvs	0x004e5f6b
     e8c:	5f006564 	svcpl	0x00006564
     e90:	31314e5a 	teqcc	r1, sl, asr lr
     e94:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     e98:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e9c:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     ea0:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     ea4:	634b5045 	movtvs	r5, #45125	; 0xb045
     ea8:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     eac:	5f656c69 	svcpl	0x00656c69
     eb0:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     eb4:	646f4d5f 	strbtvs	r4, [pc], #-3423	; ebc <shift+0xebc>
     eb8:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     ebc:	50475f74 	subpl	r5, r7, r4, ror pc
     ec0:	5f544553 	svcpl	0x00544553
     ec4:	61636f4c 	cmnvs	r3, ip, asr #30
     ec8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ecc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ed0:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     ed4:	4f495047 	svcmi	0x00495047
     ed8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     edc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     ee0:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     ee4:	50475f74 	subpl	r5, r7, r4, ror pc
     ee8:	5f56454c 	svcpl	0x0056454c
     eec:	61636f4c 	cmnvs	r3, ip, asr #30
     ef0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ef4:	6a526a45 	bvs	149b810 <__bss_end+0x1491d20>
     ef8:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     efc:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     f00:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     f04:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     f08:	64007365 	strvs	r7, [r0], #-869	; 0xfffffc9b
     f0c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     f10:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     f14:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     f18:	4f5f6461 	svcmi	0x005f6461
     f1c:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     f20:	61656c43 	cmnvs	r5, r3, asr #24
     f24:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     f28:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     f2c:	455f6465 	ldrbmi	r6, [pc, #-1125]	; acf <shift+0xacf>
     f30:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     f34:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     f38:	745f7065 	ldrbvc	r7, [pc], #-101	; f40 <shift+0xf40>
     f3c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     f40:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f44:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     f48:	636f7250 	cmnvs	pc, #80, 4
     f4c:	5f737365 	svcpl	0x00737365
     f50:	616e614d 	cmnvs	lr, sp, asr #2
     f54:	31726567 	cmncc	r2, r7, ror #10
     f58:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     f5c:	6f72505f 	svcvs	0x0072505f
     f60:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f64:	5f79425f 	svcpl	0x0079425f
     f68:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     f6c:	6148006a 	cmpvs	r8, sl, rrx
     f70:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     f74:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     f78:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     f7c:	5f6d6574 	svcpl	0x006d6574
     f80:	00495753 	subeq	r5, r9, r3, asr r7
     f84:	314e5a5f 	cmpcc	lr, pc, asr sl
     f88:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     f8c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f90:	614d5f73 	hvcvs	54771	; 0xd5f3
     f94:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     f98:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     f9c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     fa0:	5f656c75 	svcpl	0x00656c75
     fa4:	76455252 			; <UNDEFINED> instruction: 0x76455252
     fa8:	73617400 	cmnvc	r1, #0, 8
     fac:	6547006b 	strbvs	r0, [r7, #-107]	; 0xffffff95
     fb0:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     fb4:	00747570 	rsbseq	r7, r4, r0, ror r5
     fb8:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     fbc:	505f7966 	subspl	r7, pc, r6, ror #18
     fc0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fc4:	53007373 	movwpl	r7, #883	; 0x373
     fc8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     fcc:	00656c75 	rsbeq	r6, r5, r5, ror ip
     fd0:	314e5a5f 	cmpcc	lr, pc, asr sl
     fd4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     fd8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fdc:	614d5f73 	hvcvs	54771	; 0xd5f3
     fe0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     fe4:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     fe8:	6b636f6c 	blvs	18dcda0 <__bss_end+0x18d32b0>
     fec:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     ff0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     ff4:	6f72505f 	svcvs	0x0072505f
     ff8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ffc:	5f007645 	svcpl	0x00007645
    1000:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1004:	6f725043 	svcvs	0x00725043
    1008:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    100c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1010:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1014:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
    1018:	5f686374 	svcpl	0x00686374
    101c:	50456f54 	subpl	r6, r5, r4, asr pc
    1020:	50433831 	subpl	r3, r3, r1, lsr r8
    1024:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1028:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
    102c:	5f747369 	svcpl	0x00747369
    1030:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    1034:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1038:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    103c:	4f495047 	svcmi	0x00495047
    1040:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1044:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1048:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    104c:	50475f74 	subpl	r5, r7, r4, ror pc
    1050:	5f534445 	svcpl	0x00534445
    1054:	61636f4c 	cmnvs	r3, ip, asr #30
    1058:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    105c:	6a526a45 	bvs	149b978 <__bss_end+0x1491e88>
    1060:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1064:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1068:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    106c:	0052525f 	subseq	r5, r2, pc, asr r2
    1070:	5f746547 	svcpl	0x00746547
    1074:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
    1078:	6f4c5f56 	svcvs	0x004c5f56
    107c:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    1080:	5f006e6f 	svcpl	0x00006e6f
    1084:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1088:	6f725043 	svcvs	0x00725043
    108c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1090:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1094:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1098:	61483831 	cmpvs	r8, r1, lsr r8
    109c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    10a0:	6f72505f 	svcvs	0x0072505f
    10a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10a8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    10ac:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    10b0:	5f495753 	svcpl	0x00495753
    10b4:	636f7250 	cmnvs	pc, #80, 4
    10b8:	5f737365 	svcpl	0x00737365
    10bc:	76726553 			; <UNDEFINED> instruction: 0x76726553
    10c0:	6a656369 	bvs	1959e6c <__bss_end+0x195037c>
    10c4:	31526a6a 	cmpcc	r2, sl, ror #20
    10c8:	57535431 	smmlarpl	r3, r1, r4, r5
    10cc:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    10d0:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    10d4:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
    10d8:	5a5f0076 	bpl	17c12b8 <__bss_end+0x17b77c8>
    10dc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    10e0:	636f7250 	cmnvs	pc, #80, 4
    10e4:	5f737365 	svcpl	0x00737365
    10e8:	616e614d 	cmnvs	lr, sp, asr #2
    10ec:	31726567 	cmncc	r2, r7, ror #10
    10f0:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
    10f4:	5f657461 	svcpl	0x00657461
    10f8:	636f7250 	cmnvs	pc, #80, 4
    10fc:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    1100:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
    1104:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
    1108:	5f686374 	svcpl	0x00686374
    110c:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
    1110:	5f495753 	svcpl	0x00495753
    1114:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1118:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    111c:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1120:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1124:	5f006563 	svcpl	0x00006563
    1128:	314b4e5a 	cmpcc	fp, sl, asr lr
    112c:	50474333 	subpl	r4, r7, r3, lsr r3
    1130:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1134:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1138:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    113c:	5f746547 	svcpl	0x00746547
    1140:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
    1144:	6f4c5f54 	svcvs	0x004c5f54
    1148:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    114c:	6a456e6f 	bvs	115cb10 <__bss_end+0x1153020>
    1150:	30536a52 	subscc	r6, r3, r2, asr sl
    1154:	6e49005f 	mcrvs	0, 2, r0, cr9, cr15, {2}
    1158:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    115c:	61485f64 	cmpvs	r8, r4, ror #30
    1160:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1164:	53465400 	movtpl	r5, #25600	; 0x6400
    1168:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    116c:	6f4e5f65 	svcvs	0x004e5f65
    1170:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
    1174:	6b636f6c 	blvs	18dcf2c <__bss_end+0x18d343c>
    1178:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    117c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1180:	6f72505f 	svcvs	0x0072505f
    1184:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1188:	6e697000 	cdpvs	0, 6, cr7, cr9, cr0, {0}
    118c:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
    1190:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
    1194:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1198:	5a5f006e 	bpl	17c1358 <__bss_end+0x17b7868>
    119c:	33314b4e 	teqcc	r1, #79872	; 0x13800
    11a0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    11a4:	61485f4f 	cmpvs	r8, pc, asr #30
    11a8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11ac:	47373172 			; <UNDEFINED> instruction: 0x47373172
    11b0:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    11b4:	5f4f4950 	svcpl	0x004f4950
    11b8:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
    11bc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    11c0:	43006a45 	movwmi	r6, #2629	; 0xa45
    11c4:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    11c8:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
    11cc:	00726576 	rsbseq	r6, r2, r6, ror r5
    11d0:	63677261 	cmnvs	r7, #268435462	; 0x10000006
    11d4:	69464900 	stmdbvs	r6, {r8, fp, lr}^
    11d8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    11dc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    11e0:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    11e4:	00726576 	rsbseq	r6, r2, r6, ror r5
    11e8:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    11ec:	5f316863 	svcpl	0x00316863
    11f0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    11f4:	50474300 	subpl	r4, r7, r0, lsl #6
    11f8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11fc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1200:	55007265 	strpl	r7, [r0, #-613]	; 0xfffffd9b
    1204:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1208:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
    120c:	57006465 	strpl	r6, [r0, -r5, ror #8]
    1210:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1214:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    1218:	616d0079 	smcvs	53257	; 0xd009
    121c:	59006e69 	stmdbpl	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
    1220:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1224:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1228:	50433631 	subpl	r3, r3, r1, lsr r6
    122c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1230:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 106c <shift+0x106c>
    1234:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1238:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    123c:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    1240:	746f6f52 	strbtvc	r6, [pc], #-3922	; 1248 <shift+0x1248>
    1244:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
    1248:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
    124c:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1250:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1254:	72655400 	rsbvc	r5, r5, #0, 8
    1258:	616e696d 	cmnvs	lr, sp, ror #18
    125c:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1260:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1264:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    1268:	5f656c64 	svcpl	0x00656c64
    126c:	00515249 	subseq	r5, r1, r9, asr #4
    1270:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1274:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    1278:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    127c:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1280:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
    1284:	61767465 	cmnvs	r6, r5, ror #8
    1288:	636e006c 	cmnvs	lr, #108	; 0x6c
    128c:	70007275 	andvc	r7, r0, r5, ror r2
    1290:	00657069 	rsbeq	r7, r5, r9, rrx
    1294:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    1298:	5a5f006d 	bpl	17c1454 <__bss_end+0x17b7964>
    129c:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    12a0:	5f646568 	svcpl	0x00646568
    12a4:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    12a8:	5f007664 	svcpl	0x00007664
    12ac:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    12b0:	745f7465 	ldrbvc	r7, [pc], #-1125	; 12b8 <shift+0x12b8>
    12b4:	5f6b7361 	svcpl	0x006b7361
    12b8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    12bc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    12c0:	6177006a 	cmnvs	r7, sl, rrx
    12c4:	5f007469 	svcpl	0x00007469
    12c8:	6f6e365a 	svcvs	0x006e365a
    12cc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    12d0:	5f006a6a 	svcpl	0x00006a6a
    12d4:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    12d8:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    12dc:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    12e0:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
    12e4:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
    12e8:	6f637469 	svcvs	0x00637469
    12ec:	5f006564 	svcpl	0x00006564
    12f0:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    12f4:	615f7465 	cmpvs	pc, r5, ror #8
    12f8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    12fc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    1300:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1304:	6f635f73 	svcvs	0x00635f73
    1308:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    130c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    1310:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1314:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1318:	63697400 	cmnvs	r9, #0, 8
    131c:	6f635f6b 	svcvs	0x00635f6b
    1320:	5f746e75 	svcpl	0x00746e75
    1324:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    1328:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    132c:	70695000 	rsbvc	r5, r9, r0
    1330:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1334:	505f656c 	subspl	r6, pc, ip, ror #10
    1338:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    133c:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
    1340:	61505f74 	cmpvs	r0, r4, ror pc
    1344:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
    1348:	315a5f00 	cmpcc	sl, r0, lsl #30
    134c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1350:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1354:	6f635f6b 	svcvs	0x00635f6b
    1358:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    135c:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
    1360:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
    1364:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    1368:	455f656c 	ldrbmi	r6, [pc, #-1388]	; e04 <shift+0xe04>
    136c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1370:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1374:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
    1378:	73006e6f 	movwvc	r6, #3695	; 0xe6f
    137c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1384 <shift+0x1384>
    1380:	5f6b7361 	svcpl	0x006b7361
    1384:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1388:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    138c:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1390:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1394:	5f006e6f 	svcpl	0x00006e6f
    1398:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    139c:	6a65736f 	bvs	195e160 <__bss_end+0x1954670>
    13a0:	6f682f00 	svcvs	0x00682f00
    13a4:	6a2f656d 	bvs	bda960 <__bss_end+0xbd0e70>
    13a8:	73656d61 	cmnvc	r5, #6208	; 0x1840
    13ac:	2f697261 	svccs	0x00697261
    13b0:	2f746967 	svccs	0x00746967
    13b4:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    13b8:	6f732f70 	svcvs	0x00732f70
    13bc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    13c0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    13c4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    13c8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    13cc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    13d0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    13d4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    13d8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    13dc:	70746567 	rsbsvc	r6, r4, r7, ror #10
    13e0:	00766469 	rsbseq	r6, r6, r9, ror #8
    13e4:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    13e8:	6f6e0065 	svcvs	0x006e0065
    13ec:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    13f0:	63697400 	cmnvs	r9, #0, 8
    13f4:	6f00736b 	svcvs	0x0000736b
    13f8:	006e6570 	rsbeq	r6, lr, r0, ror r5
    13fc:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    1400:	50657069 	rsbpl	r7, r5, r9, rrx
    1404:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1408:	6165444e 	cmnvs	r5, lr, asr #8
    140c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1410:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    1414:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    1418:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    141c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1420:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1424:	6f635f6b 	svcvs	0x00635f6b
    1428:	00746e75 	rsbseq	r6, r4, r5, ror lr
    142c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1378 <shift+0x1378>
    1430:	616a2f65 	cmnvs	sl, r5, ror #30
    1434:	6173656d 	cmnvs	r3, sp, ror #10
    1438:	672f6972 			; <UNDEFINED> instruction: 0x672f6972
    143c:	6f2f7469 	svcvs	0x002f7469
    1440:	70732f73 	rsbsvc	r2, r3, r3, ror pc
    1444:	756f732f 	strbvc	r7, [pc, #-815]!	; 111d <shift+0x111d>
    1448:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    144c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1450:	7000646c 	andvc	r6, r0, ip, ror #8
    1454:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    1458:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    145c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1460:	4b506a65 	blmi	141bdfc <__bss_end+0x141230c>
    1464:	67006a63 	strvs	r6, [r0, -r3, ror #20]
    1468:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1470 <shift+0x1470>
    146c:	5f6b7361 	svcpl	0x006b7361
    1470:	6b636974 	blvs	18dba48 <__bss_end+0x18d1f58>
    1474:	6f745f73 	svcvs	0x00745f73
    1478:	6165645f 	cmnvs	r5, pc, asr r4
    147c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1480:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1484:	00657469 	rsbeq	r7, r5, r9, ror #8
    1488:	5f667562 	svcpl	0x00667562
    148c:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
    1490:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1494:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    1498:	00736d61 	rsbseq	r6, r3, r1, ror #26
    149c:	73355a5f 	teqvc	r5, #389120	; 0x5f000
    14a0:	7065656c 	rsbvc	r6, r5, ip, ror #10
    14a4:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    14a8:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    14ac:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    14b0:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
    14b4:	616e4500 	cmnvs	lr, r0, lsl #10
    14b8:	5f656c62 	svcpl	0x00656c62
    14bc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    14c0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    14c4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    14c8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    14cc:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
    14d0:	5f746567 	svcpl	0x00746567
    14d4:	6b736174 	blvs	1cd9aac <__bss_end+0x1ccffbc>
    14d8:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    14dc:	745f736b 	ldrbvc	r7, [pc], #-875	; 14e4 <shift+0x14e4>
    14e0:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    14e4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    14e8:	0076656e 	rsbseq	r6, r6, lr, ror #10
    14ec:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    14f0:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    14f4:	5f746c75 	svcpl	0x00746c75
    14f8:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    14fc:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    1500:	5f006d75 	svcpl	0x00006d75
    1504:	6177345a 	cmnvs	r7, sl, asr r4
    1508:	6a6a7469 	bvs	1a9e6b4 <__bss_end+0x1a94bc4>
    150c:	5a5f006a 	bpl	17c16bc <__bss_end+0x17b7bcc>
    1510:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    1514:	316a6c74 	smccc	42692	; 0xa6c4
    1518:	4f494e36 	svcmi	0x00494e36
    151c:	5f6c7443 	svcpl	0x006c7443
    1520:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1524:	6f697461 	svcvs	0x00697461
    1528:	0076506e 	rsbseq	r5, r6, lr, rrx
    152c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1530:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    1534:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    1538:	646f6d00 	strbtvs	r6, [pc], #-3328	; 1540 <shift+0x1540>
    153c:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1540:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1544:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1548:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    154c:	6a63506a 	bvs	18d56fc <__bss_end+0x18cbc0c>
    1550:	4f494e00 	svcmi	0x00494e00
    1554:	5f6c7443 	svcpl	0x006c7443
    1558:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    155c:	6f697461 	svcvs	0x00697461
    1560:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    1564:	646f6374 	strbtvs	r6, [pc], #-884	; 156c <shift+0x156c>
    1568:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    156c:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1570:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1574:	6f72705f 	svcvs	0x0072705f
    1578:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    157c:	756f635f 	strbvc	r6, [pc, #-863]!	; 1225 <shift+0x1225>
    1580:	6600746e 	strvs	r7, [r0], -lr, ror #8
    1584:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    1588:	00656d61 	rsbeq	r6, r5, r1, ror #26
    158c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1590:	72657400 	rsbvc	r7, r5, #0, 8
    1594:	616e696d 	cmnvs	lr, sp, ror #18
    1598:	67006574 	smlsdxvs	r0, r4, r5, r6
    159c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    15a0:	5a5f0064 	bpl	17c1738 <__bss_end+0x17b7c48>
    15a4:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    15a8:	634b506e 	movtvs	r5, #45166	; 0xb06e
    15ac:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    15b0:	5f656c69 	svcpl	0x00656c69
    15b4:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    15b8:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 15c0 <shift+0x15c0>
    15bc:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    15c0:	2b432055 	blcs	10c971c <__bss_end+0x10bfc2c>
    15c4:	2034312b 	eorscs	r3, r4, fp, lsr #2
    15c8:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    15cc:	30322031 	eorscc	r2, r2, r1, lsr r0
    15d0:	30313931 	eorscc	r3, r1, r1, lsr r9
    15d4:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    15d8:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    15dc:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    15e0:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    15e4:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    15e8:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    15ec:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    15f0:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    15f4:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    15f8:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    15fc:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1600:	205d3939 	subscs	r3, sp, r9, lsr r9
    1604:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1608:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    160c:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1610:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1614:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1618:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    161c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1620:	6f6c666d 	svcvs	0x006c666d
    1624:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1628:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    162c:	20647261 	rsbcs	r7, r4, r1, ror #4
    1630:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1634:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1638:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    163c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1640:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1644:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1648:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    164c:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    1650:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1654:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1658:	613d6863 	teqvs	sp, r3, ror #16
    165c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1660:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    1664:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1668:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    166c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1670:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1674:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1678:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 14e8 <shift+0x14e8>
    167c:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    1680:	6f697470 	svcvs	0x00697470
    1684:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    1688:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 14f8 <shift+0x14f8>
    168c:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1690:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1694:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1698:	4b507970 	blmi	141fc60 <__bss_end+0x1416170>
    169c:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    16a0:	6f682f00 	svcvs	0x00682f00
    16a4:	6a2f656d 	bvs	bdac60 <__bss_end+0xbd1170>
    16a8:	73656d61 	cmnvc	r5, #6208	; 0x1840
    16ac:	2f697261 	svccs	0x00697261
    16b0:	2f746967 	svccs	0x00746967
    16b4:	732f736f 			; <UNDEFINED> instruction: 0x732f736f
    16b8:	6f732f70 	svcvs	0x00732f70
    16bc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    16c0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    16c4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    16c8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    16cc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    16d0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    16d4:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    16d8:	72007070 	andvc	r7, r0, #112	; 0x70
    16dc:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    16e0:	7265646e 	rsbvc	r6, r5, #1845493760	; 0x6e000000
    16e4:	6e736900 	vaddvs.f16	s13, s6, s0	; <UNPREDICTABLE>
    16e8:	69006e61 	stmdbvs	r0, {r0, r5, r6, r9, sl, fp, sp, lr}
    16ec:	6765746e 	strbvs	r7, [r5, -lr, ror #8]!
    16f0:	006c6172 	rsbeq	r6, ip, r2, ror r1
    16f4:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
    16f8:	65640066 	strbvs	r0, [r4, #-102]!	; 0xffffff9a
    16fc:	616d6963 	cmnvs	sp, r3, ror #18
    1700:	5a5f006c 	bpl	17c18b8 <__bss_end+0x17b7dc8>
    1704:	6f746934 	svcvs	0x00746934
    1708:	63506a61 	cmpvs	r0, #397312	; 0x61000
    170c:	7461006a 	strbtvc	r0, [r1], #-106	; 0xffffff96
    1710:	7000696f 	andvc	r6, r0, pc, ror #18
    1714:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1718:	6565735f 	strbvs	r7, [r5, #-863]!	; 0xfffffca1
    171c:	7473006e 	ldrbtvc	r0, [r3], #-110	; 0xffffff92
    1720:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1724:	6365645f 	cmnvs	r5, #1593835520	; 0x5f000000
    1728:	6c616d69 	stclvs	13, cr6, [r1], #-420	; 0xfffffe5c
    172c:	6f700073 	svcvs	0x00700073
    1730:	00726577 	rsbseq	r6, r2, r7, ror r5
    1734:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1738:	695f676e 	ldmdbvs	pc, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^	; <UNPREDICTABLE>
    173c:	6c5f746e 	cfldrdvs	mvd7, [pc], {110}	; 0x6e
    1740:	65006e65 	strvs	r6, [r0, #-3685]	; 0xfffff19b
    1744:	6e6f7078 	mcrvs	0, 3, r7, cr15, cr8, {3}
    1748:	00746e65 	rsbseq	r6, r4, r5, ror #28
    174c:	61345a5f 	teqvs	r4, pc, asr sl
    1750:	50666f74 	rsbpl	r6, r6, r4, ror pc
    1754:	6400634b 	strvs	r6, [r0], #-843	; 0xfffffcb5
    1758:	00747365 	rsbseq	r7, r4, r5, ror #6
    175c:	72365a5f 	eorsvc	r5, r6, #389120	; 0x5f000
    1760:	74737665 	ldrbtvc	r7, [r3], #-1637	; 0xfffff99b
    1764:	00635072 	rsbeq	r5, r3, r2, ror r0
    1768:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    176c:	6e616e73 	mcrvs	14, 3, r6, cr1, cr3, {3}
    1770:	6e690066 	cdpvs	0, 6, cr0, cr9, cr6, {3}
    1774:	00747570 	rsbseq	r7, r4, r0, ror r5
    1778:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    177c:	6d657400 	cfstrdvs	mvd7, [r5, #-0]
    1780:	5a5f0070 	bpl	17c1948 <__bss_end+0x17b7e58>
    1784:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1788:	76506f72 	usub16vc	r6, r0, r2
    178c:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1790:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1794:	74690079 	strbtvc	r0, [r9], #-121	; 0xffffff87
    1798:	7300616f 	movwvc	r6, #367	; 0x16f
    179c:	00317274 	eorseq	r7, r1, r4, ror r2
    17a0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    17a4:	695f676e 	ldmdbvs	pc, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^	; <UNPREDICTABLE>
    17a8:	5f00746e 	svcpl	0x0000746e
    17ac:	7369355a 	cmnvc	r9, #377487360	; 0x16800000
    17b0:	66666e69 	strbtvs	r6, [r6], -r9, ror #28
    17b4:	335a5f00 	cmpcc	sl, #0, 30
    17b8:	66776f70 	uhsub16vs	r6, r7, r0
    17bc:	5a5f006a 	bpl	17c196c <__bss_end+0x17b7e7c>
    17c0:	70733131 	rsbsvc	r3, r3, r1, lsr r1
    17c4:	5f74696c 	svcpl	0x0074696c
    17c8:	616f6c66 	cmnvs	pc, r6, ror #24
    17cc:	6a526674 	bvs	149b1a4 <__bss_end+0x14916b4>
    17d0:	69525f53 	ldmdbvs	r2, {r0, r1, r4, r6, r8, r9, sl, fp, ip, lr}^
    17d4:	6f746100 	svcvs	0x00746100
    17d8:	656d0066 	strbvs	r0, [sp, #-102]!	; 0xffffff9a
    17dc:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    17e0:	61684300 	cmnvs	r8, r0, lsl #6
    17e4:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    17e8:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    17ec:	6f746600 	svcvs	0x00746600
    17f0:	5a5f0061 	bpl	17c197c <__bss_end+0x17b7e8c>
    17f4:	65643332 	strbvs	r3, [r4, #-818]!	; 0xfffffcce
    17f8:	616d6963 	cmnvs	sp, r3, ror #18
    17fc:	6f745f6c 	svcvs	0x00745f6c
    1800:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1804:	5f676e69 	svcpl	0x00676e69
    1808:	616f6c66 	cmnvs	pc, r6, ror #24
    180c:	63506a74 	cmpvs	r0, #116, 20	; 0x74000
    1810:	656d0069 	strbvs	r0, [sp, #-105]!	; 0xffffff97
    1814:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    1818:	65727000 	ldrbvs	r7, [r2, #-0]!
    181c:	69736963 	ldmdbvs	r3!, {r0, r1, r5, r6, r8, fp, sp, lr}^
    1820:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
    1824:	6f72657a 	svcvs	0x0072657a
    1828:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    182c:	00797063 	rsbseq	r7, r9, r3, rrx
    1830:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
    1834:	74730078 	ldrbtvc	r0, [r3], #-120	; 0xffffff88
    1838:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    183c:	69640070 	stmdbvs	r4!, {r4, r5, r6}^
    1840:	73746967 	cmnvc	r4, #1687552	; 0x19c000
    1844:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1848:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    184c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1850:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1854:	5f007475 	svcpl	0x00007475
    1858:	7466345a 	strbtvc	r3, [r6], #-1114	; 0xfffffba6
    185c:	5066616f 	rsbpl	r6, r6, pc, ror #2
    1860:	73006a63 	movwvc	r6, #2659	; 0xa63
    1864:	74696c70 	strbtvc	r6, [r9], #-3184	; 0xfffff390
    1868:	6f6c665f 	svcvs	0x006c665f
    186c:	66007461 	strvs	r7, [r0], -r1, ror #8
    1870:	00746361 	rsbseq	r6, r4, r1, ror #6
    1874:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    1878:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    187c:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1880:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1884:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1888:	50706d63 	rsbspl	r6, r0, r3, ror #26
    188c:	3053634b 	subscc	r6, r3, fp, asr #6
    1890:	5f00695f 	svcpl	0x0000695f
    1894:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1898:	70636e72 	rsbvc	r6, r3, r2, ror lr
    189c:	50635079 	rsbpl	r5, r3, r9, ror r0
    18a0:	0069634b 	rsbeq	r6, r9, fp, asr #6
    18a4:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    18a8:	5f6c616d 	svcpl	0x006c616d
    18ac:	735f6f74 	cmpvc	pc, #116, 30	; 0x1d0
    18b0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    18b4:	6c665f67 	stclvs	15, cr5, [r6], #-412	; 0xfffffe64
    18b8:	0074616f 	rsbseq	r6, r4, pc, ror #2
    18bc:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    18c0:	66616f74 	uqsub16vs	r6, r1, r4
    18c4:	6d006350 	stcvs	3, cr6, [r0, #-320]	; 0xfffffec0
    18c8:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    18cc:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    18d0:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    18d4:	72747300 	rsbsvc	r7, r4, #0, 6
    18d8:	006e656c 	rsbeq	r6, lr, ip, ror #10
    18dc:	73766572 	cmnvc	r6, #478150656	; 0x1c800000
    18e0:	2e007274 	mcrcs	2, 0, r7, cr0, cr4, {3}
    18e4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18e8:	2f2e2e2f 	svccs	0x002e2e2f
    18ec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    18f0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18f4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    18f8:	2f636367 	svccs	0x00636367
    18fc:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1900:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1904:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 1744 <shift+0x1744>
    1908:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    190c:	73636e75 	cmnvc	r3, #1872	; 0x750
    1910:	2f00532e 	svccs	0x0000532e
    1914:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1918:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    191c:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1920:	6f6e2d6d 	svcvs	0x006e2d6d
    1924:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1928:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    192c:	6b396c47 	blvs	e5ca50 <__bss_end+0xe52f60>
    1930:	672f3954 			; <UNDEFINED> instruction: 0x672f3954
    1934:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1938:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    193c:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1940:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1944:	322d392d 	eorcc	r3, sp, #737280	; 0xb4000
    1948:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    194c:	622f3471 	eorvs	r3, pc, #1895825408	; 0x71000000
    1950:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1954:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1958:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    195c:	61652d65 	cmnvs	r5, r5, ror #26
    1960:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1964:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1968:	2f657435 	svccs	0x00657435
    196c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1970:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1974:	00636367 	rsbeq	r6, r3, r7, ror #6
    1978:	47524154 			; <UNDEFINED> instruction: 0x47524154
    197c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1980:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1984:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1988:	37316178 			; <UNDEFINED> instruction: 0x37316178
    198c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1990:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1994:	61736900 	cmnvs	r3, r0, lsl #18
    1998:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    199c:	5f70665f 	svcpl	0x0070665f
    19a0:	006c6264 	rsbeq	r6, ip, r4, ror #4
    19a4:	5f6d7261 	svcpl	0x006d7261
    19a8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    19ac:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    19b0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    19b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19bc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    19c0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    19c4:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    19c8:	4d524100 	ldfmie	f4, [r2, #-0]
    19cc:	0051455f 	subseq	r4, r1, pc, asr r5
    19d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19dc:	31316d72 	teqcc	r1, r2, ror sp
    19e0:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    19e4:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    19e8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19ec:	745f7469 	ldrbvc	r7, [pc], #-1129	; 19f4 <shift+0x19f4>
    19f0:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    19f4:	52415400 	subpl	r5, r1, #0, 8
    19f8:	5f544547 	svcpl	0x00544547
    19fc:	5f555043 	svcpl	0x00555043
    1a00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a04:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a08:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1a0c:	61786574 	cmnvs	r8, r4, ror r5
    1a10:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    1a14:	5f455341 	svcpl	0x00455341
    1a18:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a1c:	5f4d385f 	svcpl	0x004d385f
    1a20:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a24:	52415400 	subpl	r5, r1, #0, 8
    1a28:	5f544547 	svcpl	0x00544547
    1a2c:	5f555043 	svcpl	0x00555043
    1a30:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1a34:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    1a38:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a3c:	50435f54 	subpl	r5, r3, r4, asr pc
    1a40:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    1a44:	31656e65 	cmncc	r5, r5, ror #28
    1a48:	4d524100 	ldfmie	f4, [r2, #-0]
    1a4c:	5343505f 	movtpl	r5, #12383	; 0x305f
    1a50:	5041415f 	subpl	r4, r1, pc, asr r1
    1a54:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    1a58:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    1a5c:	41420054 	qdaddmi	r0, r4, r2
    1a60:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a64:	5f484352 	svcpl	0x00484352
    1a68:	41420030 	cmpmi	r2, r0, lsr r0
    1a6c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a70:	5f484352 	svcpl	0x00484352
    1a74:	41420032 	cmpmi	r2, r2, lsr r0
    1a78:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a7c:	5f484352 	svcpl	0x00484352
    1a80:	41420033 	cmpmi	r2, r3, lsr r0
    1a84:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a88:	5f484352 	svcpl	0x00484352
    1a8c:	41420034 	cmpmi	r2, r4, lsr r0
    1a90:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a94:	5f484352 	svcpl	0x00484352
    1a98:	41420036 	cmpmi	r2, r6, lsr r0
    1a9c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1aa0:	5f484352 	svcpl	0x00484352
    1aa4:	41540037 	cmpmi	r4, r7, lsr r0
    1aa8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1aac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ab0:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1ab4:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1ab8:	5f617369 	svcpl	0x00617369
    1abc:	5f746962 	svcpl	0x00746962
    1ac0:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    1ac4:	00736572 	rsbseq	r6, r3, r2, ror r5
    1ac8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1acc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ad0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ad4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ad8:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1adc:	52415400 	subpl	r5, r1, #0, 8
    1ae0:	5f544547 	svcpl	0x00544547
    1ae4:	5f555043 	svcpl	0x00555043
    1ae8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1aec:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1af0:	61736900 	cmnvs	r3, r0, lsl #18
    1af4:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1af8:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1afc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b00:	50435f54 	subpl	r5, r3, r4, asr pc
    1b04:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b08:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1b0c:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1b10:	73690073 	cmnvc	r9, #115	; 0x73
    1b14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b18:	66765f74 	uhsub16vs	r5, r6, r4
    1b1c:	00327670 	eorseq	r7, r2, r0, ror r6
    1b20:	5f4d5241 	svcpl	0x004d5241
    1b24:	5f534350 	svcpl	0x00534350
    1b28:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    1b2c:	004e574f 	subeq	r5, lr, pc, asr #14
    1b30:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b34:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b38:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b3c:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    1b40:	53414200 	movtpl	r4, #4608	; 0x1200
    1b44:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b48:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 130d <shift+0x130d>
    1b4c:	004a4554 	subeq	r4, sl, r4, asr r5
    1b50:	5f6d7261 	svcpl	0x006d7261
    1b54:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    1b58:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    1b5c:	00657461 	rsbeq	r7, r5, r1, ror #8
    1b60:	5f6d7261 	svcpl	0x006d7261
    1b64:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b68:	00657435 	rsbeq	r7, r5, r5, lsr r4
    1b6c:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1b70:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    1b74:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1b78:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1b7c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b80:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1b84:	5f006365 	svcpl	0x00006365
    1b88:	7a6c635f 	bvc	1b1a90c <__bss_end+0x1b10e1c>
    1b8c:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1b90:	4d524100 	ldfmie	f4, [r2, #-0]
    1b94:	0043565f 	subeq	r5, r3, pc, asr r6
    1b98:	5f6d7261 	svcpl	0x006d7261
    1b9c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1ba0:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1ba4:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1ba8:	5f4d5241 	svcpl	0x004d5241
    1bac:	4100454c 	tstmi	r0, ip, asr #10
    1bb0:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1bb4:	52410053 	subpl	r0, r1, #83	; 0x53
    1bb8:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1bbc:	6d726100 	ldfvse	f6, [r2, #-0]
    1bc0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1bc4:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1bc8:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1bcc:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1bd0:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1bd4:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1bd8:	616f6c66 	cmnvs	pc, r6, ror #24
    1bdc:	41540074 	cmpmi	r4, r4, ror r0
    1be0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1be4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1be8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1bec:	61786574 	cmnvs	r8, r4, ror r5
    1bf0:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    1bf4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bf8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bfc:	61665f55 	cmnvs	r6, r5, asr pc
    1c00:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    1c04:	41540065 	cmpmi	r4, r5, rrx
    1c08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c14:	61786574 	cmnvs	r8, r4, ror r5
    1c18:	41003731 	tstmi	r0, r1, lsr r7
    1c1c:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1c20:	41540054 	cmpmi	r4, r4, asr r0
    1c24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c2c:	6f656e5f 	svcvs	0x00656e5f
    1c30:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
    1c34:	00316e65 	eorseq	r6, r1, r5, ror #28
    1c38:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c3c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c40:	2f2e2e2f 	svccs	0x002e2e2f
    1c44:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c48:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1c4c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1c50:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c54:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1c58:	5400632e 	strpl	r6, [r0], #-814	; 0xfffffcd2
    1c5c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c60:	50435f54 	subpl	r5, r3, r4, asr pc
    1c64:	6f635f55 	svcvs	0x00635f55
    1c68:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c6c:	00663472 	rsbeq	r3, r6, r2, ror r4
    1c70:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c74:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c78:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1c7c:	4154004d 	cmpmi	r4, sp, asr #32
    1c80:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c84:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c88:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c8c:	61786574 	cmnvs	r8, r4, ror r5
    1c90:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1c94:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    1c98:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1ca0 <shift+0x1ca0>
    1c9c:	53414200 	movtpl	r4, #4608	; 0x1200
    1ca0:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ca4:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1ca8:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1cac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cb0:	00737469 	rsbseq	r7, r3, r9, ror #8
    1cb4:	5f6d7261 	svcpl	0x006d7261
    1cb8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1cbc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cc0:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    1cc4:	61007669 	tstvs	r0, r9, ror #12
    1cc8:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1ccc:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1cd4 <shift+0x1cd4>
    1cd0:	00637365 	rsbeq	r7, r3, r5, ror #6
    1cd4:	5f617369 	svcpl	0x00617369
    1cd8:	5f746962 	svcpl	0x00746962
    1cdc:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1ce0:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1ce4:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    1ce8:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1cec:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1cf0:	31393130 	teqcc	r9, r0, lsr r1
    1cf4:	20353230 	eorscs	r3, r5, r0, lsr r2
    1cf8:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1cfc:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1d00:	415b2029 	cmpmi	fp, r9, lsr #32
    1d04:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1d08:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1d0c:	6172622d 	cmnvs	r2, sp, lsr #4
    1d10:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1d14:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1d18:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1d1c:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1d20:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1d24:	616d2d20 	cmnvs	sp, r0, lsr #26
    1d28:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1d2c:	6f6c666d 	svcvs	0x006c666d
    1d30:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1d34:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1d38:	20647261 	rsbcs	r7, r4, r1, ror #4
    1d3c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1d40:	613d6863 	teqvs	sp, r3, ror #16
    1d44:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    1d48:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    1d4c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1d50:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1d54:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1d58:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d5c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d60:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    1d64:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    1d68:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    1d6c:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    1d70:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1d74:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1d78:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    1d7c:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    1d80:	746f7270 	strbtvc	r7, [pc], #-624	; 1d88 <shift+0x1d88>
    1d84:	6f746365 	svcvs	0x00746365
    1d88:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    1d8c:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    1d90:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    1d94:	662d2065 	strtvs	r2, [sp], -r5, rrx
    1d98:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1d9c:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    1da0:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    1da4:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    1da8:	5241006e 	subpl	r0, r1, #110	; 0x6e
    1dac:	49485f4d 	stmdbmi	r8, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1db0:	61736900 	cmnvs	r3, r0, lsl #18
    1db4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1db8:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1dbc:	41540076 	cmpmi	r4, r6, ror r0
    1dc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1dc8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1dcc:	36333131 			; <UNDEFINED> instruction: 0x36333131
    1dd0:	5400736a 	strpl	r7, [r0], #-874	; 0xfffffc96
    1dd4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dd8:	50435f54 	subpl	r5, r3, r4, asr pc
    1ddc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1de0:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1de4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1de8:	50435f54 	subpl	r5, r3, r4, asr pc
    1dec:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1df0:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1df4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1df8:	50435f54 	subpl	r5, r3, r4, asr pc
    1dfc:	61665f55 	cmnvs	r6, r5, asr pc
    1e00:	00363236 	eorseq	r3, r6, r6, lsr r2
    1e04:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1e08:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1e0c:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1e10:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1e14:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1e18:	6100746e 	tstvs	r0, lr, ror #8
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
    2098:	7a6a3637 	bvc	1a8f97c <__bss_end+0x1a85e8c>
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
    2244:	4a365f48 	bmi	d99f6c <__bss_end+0xd9047c>
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
    2334:	6a705f6c 	bvs	1c1a0ec <__bss_end+0x1c105fc>
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
    28c4:	6b726975 	blvs	1c9cea0 <__bss_end+0x1c933b0>
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9e40>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346d40>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9e60>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9190>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9e90>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346d90>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9eb0>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346db0>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9ed0>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346dd0>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9ef0>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346df0>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9f10>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346e10>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9f30>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346e30>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9f50>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346e50>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9f68>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9f88>
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
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9fb8>
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
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9fe4>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346ee4>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083ec 	andeq	r8, r0, ip, ror #7
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa004>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346f04>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008418 	andeq	r8, r0, r8, lsl r4
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa024>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346f24>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008434 	andeq	r8, r0, r4, lsr r4
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa044>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346f44>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008478 	andeq	r8, r0, r8, ror r4
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa064>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346f64>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084c8 	andeq	r8, r0, r8, asr #9
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa084>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346f84>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008518 	andeq	r8, r0, r8, lsl r5
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa0a4>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346fa4>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008544 	andeq	r8, r0, r4, asr #10
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa0c4>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346fc4>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008594 	muleq	r0, r4, r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa0e4>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346fe4>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa104>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347004>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008628 	andeq	r8, r0, r8, lsr #12
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa124>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347024>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	0000867c 	andeq	r8, r0, ip, ror r6
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa144>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347044>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086b8 			; <UNDEFINED> instruction: 0x000086b8
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa164>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347064>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000086f4 	strdeq	r8, [r0], -r4
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa184>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347084>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008730 	andeq	r8, r0, r0, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa1a4>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x3470a4>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	0000876c 	andeq	r8, r0, ip, ror #14
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa1c4>
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
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa1f4>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008990 	muleq	r0, r0, r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa214>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347114>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a2c 	andeq	r8, r0, ip, lsr #20
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa234>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347134>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008aec 	andeq	r8, r0, ip, ror #21
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa254>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347154>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b98 	muleq	r0, r8, fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa274>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347174>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008bec 	andeq	r8, r0, ip, ror #23
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa294>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347194>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008c54 	andeq	r8, r0, r4, asr ip
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa2b4>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x3471b4>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ac:	00008cd4 	ldrdeq	r8, [r0], -r4
 4b0:	0000006c 	andeq	r0, r0, ip, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfa2d4>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x3471d4>
 4bc:	420d0d6e 	andmi	r0, sp, #7040	; 0x1b80
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4cc:	00008d40 	andeq	r8, r0, r0, asr #26
 4d0:	000000c4 	andeq	r0, r0, r4, asr #1
 4d4:	8b080e42 	blhi	203de4 <__bss_end+0x1fa2f4>
 4d8:	42018e02 	andmi	r8, r1, #2, 28
 4dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 4e0:	080d0c5c 	stmdaeq	sp, {r2, r3, r4, r6, sl, fp}
 4e4:	00000020 	andeq	r0, r0, r0, lsr #32
 4e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4ec:	00008e04 	andeq	r8, r0, r4, lsl #28
 4f0:	00000440 	andeq	r0, r0, r0, asr #8
 4f4:	8b040e42 	blhi	103e04 <__bss_end+0xfa314>
 4f8:	0b0d4201 	bleq	350d04 <__bss_end+0x347214>
 4fc:	0d01f203 	sfmeq	f7, 1, [r1, #-12]
 500:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 504:	00000000 	andeq	r0, r0, r0
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 510:	00009244 	andeq	r9, r0, r4, asr #4
 514:	000000d4 	ldrdeq	r0, [r0], -r4
 518:	8b080e42 	blhi	203e28 <__bss_end+0x1fa338>
 51c:	42018e02 	andmi	r8, r1, #2, 28
 520:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 524:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 530:	00009318 	andeq	r9, r0, r8, lsl r3
 534:	0000003c 	andeq	r0, r0, ip, lsr r0
 538:	8b040e42 	blhi	103e48 <__bss_end+0xfa358>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x347258>
 540:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 550:	00009354 	andeq	r9, r0, r4, asr r3
 554:	00000040 	andeq	r0, r0, r0, asr #32
 558:	8b040e42 	blhi	103e68 <__bss_end+0xfa378>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x347278>
 560:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 570:	00009394 	muleq	r0, r4, r3
 574:	00000030 	andeq	r0, r0, r0, lsr r0
 578:	8b080e42 	blhi	203e88 <__bss_end+0x1fa398>
 57c:	42018e02 	andmi	r8, r1, #2, 28
 580:	52040b0c 	andpl	r0, r4, #12, 22	; 0x3000
 584:	00080d0c 	andeq	r0, r8, ip, lsl #26
 588:	00000020 	andeq	r0, r0, r0, lsr #32
 58c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 590:	000093c4 	andeq	r9, r0, r4, asr #7
 594:	00000324 	andeq	r0, r0, r4, lsr #6
 598:	8b080e42 	blhi	203ea8 <__bss_end+0x1fa3b8>
 59c:	42018e02 	andmi	r8, r1, #2, 28
 5a0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 5a4:	0d0c0188 	stfeqs	f0, [ip, #-544]	; 0xfffffde0
 5a8:	00000008 	andeq	r0, r0, r8
 5ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 5b4:	000096e8 	andeq	r9, r0, r8, ror #13
 5b8:	00000110 	andeq	r0, r0, r0, lsl r1
 5bc:	8b040e42 	blhi	103ecc <__bss_end+0xfa3dc>
 5c0:	0b0d4201 	bleq	350dcc <__bss_end+0x3472dc>
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
