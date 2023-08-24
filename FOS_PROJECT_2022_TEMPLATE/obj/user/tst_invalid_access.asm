
obj/user/tst_invalid_access:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 57 00 00 00       	call   80008d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	/// testing illegal memory access
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)0x80000000;
  80004e:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)0x80000000;

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}

		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for new stack pages\n");
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	68 e0 1a 80 00       	push   $0x801ae0
  800081:	6a 1a                	push   $0x1a
  800083:	68 e9 1b 80 00       	push   $0x801be9
  800088:	e8 4f 01 00 00       	call   8001dc <_panic>

0080008d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800093:	e8 4e 15 00 00       	call   8015e6 <sys_getenvindex>
  800098:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80009b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80009e:	89 d0                	mov    %edx,%eax
  8000a0:	01 c0                	add    %eax,%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000ab:	01 c8                	add    %ecx,%eax
  8000ad:	c1 e0 02             	shl    $0x2,%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000b9:	01 c8                	add    %ecx,%eax
  8000bb:	c1 e0 02             	shl    $0x2,%eax
  8000be:	01 d0                	add    %edx,%eax
  8000c0:	c1 e0 02             	shl    $0x2,%eax
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	c1 e0 03             	shl    $0x3,%eax
  8000c8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000cd:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d7:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000dd:	84 c0                	test   %al,%al
  8000df:	74 0f                	je     8000f0 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e6:	05 18 da 01 00       	add    $0x1da18,%eax
  8000eb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f4:	7e 0a                	jle    800100 <libmain+0x73>
		binaryname = argv[0];
  8000f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f9:	8b 00                	mov    (%eax),%eax
  8000fb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	ff 75 0c             	pushl  0xc(%ebp)
  800106:	ff 75 08             	pushl  0x8(%ebp)
  800109:	e8 2a ff ff ff       	call   800038 <_main>
  80010e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800111:	e8 dd 12 00 00       	call   8013f3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	68 1c 1c 80 00       	push   $0x801c1c
  80011e:	e8 6d 03 00 00       	call   800490 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800131:	a1 20 30 80 00       	mov    0x803020,%eax
  800136:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	52                   	push   %edx
  800140:	50                   	push   %eax
  800141:	68 44 1c 80 00       	push   $0x801c44
  800146:	e8 45 03 00 00       	call   800490 <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80014e:	a1 20 30 80 00       	mov    0x803020,%eax
  800153:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800159:	a1 20 30 80 00       	mov    0x803020,%eax
  80015e:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80016f:	51                   	push   %ecx
  800170:	52                   	push   %edx
  800171:	50                   	push   %eax
  800172:	68 6c 1c 80 00       	push   $0x801c6c
  800177:	e8 14 03 00 00       	call   800490 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	50                   	push   %eax
  80018e:	68 c4 1c 80 00       	push   $0x801cc4
  800193:	e8 f8 02 00 00       	call   800490 <cprintf>
  800198:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	68 1c 1c 80 00       	push   $0x801c1c
  8001a3:	e8 e8 02 00 00       	call   800490 <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ab:	e8 5d 12 00 00       	call   80140d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001b0:	e8 19 00 00 00       	call   8001ce <exit>
}
  8001b5:	90                   	nop
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    

008001b8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	6a 00                	push   $0x0
  8001c3:	e8 ea 13 00 00       	call   8015b2 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
}
  8001cb:	90                   	nop
  8001cc:	c9                   	leave  
  8001cd:	c3                   	ret    

008001ce <exit>:

void
exit(void)
{
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001d4:	e8 3f 14 00 00       	call   801618 <sys_exit_env>
}
  8001d9:	90                   	nop
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8001e5:	83 c0 04             	add    $0x4,%eax
  8001e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001eb:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	74 16                	je     80020a <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001f4:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	50                   	push   %eax
  8001fd:	68 d8 1c 80 00       	push   $0x801cd8
  800202:	e8 89 02 00 00       	call   800490 <cprintf>
  800207:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80020a:	a1 00 30 80 00       	mov    0x803000,%eax
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	50                   	push   %eax
  800216:	68 dd 1c 80 00       	push   $0x801cdd
  80021b:	e8 70 02 00 00       	call   800490 <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800223:	8b 45 10             	mov    0x10(%ebp),%eax
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	ff 75 f4             	pushl  -0xc(%ebp)
  80022c:	50                   	push   %eax
  80022d:	e8 f3 01 00 00       	call   800425 <vcprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	6a 00                	push   $0x0
  80023a:	68 f9 1c 80 00       	push   $0x801cf9
  80023f:	e8 e1 01 00 00       	call   800425 <vcprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800247:	e8 82 ff ff ff       	call   8001ce <exit>

	// should not return here
	while (1) ;
  80024c:	eb fe                	jmp    80024c <_panic+0x70>

0080024e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800254:	a1 20 30 80 00       	mov    0x803020,%eax
  800259:	8b 50 74             	mov    0x74(%eax),%edx
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025f:	39 c2                	cmp    %eax,%edx
  800261:	74 14                	je     800277 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	68 fc 1c 80 00       	push   $0x801cfc
  80026b:	6a 26                	push   $0x26
  80026d:	68 48 1d 80 00       	push   $0x801d48
  800272:	e8 65 ff ff ff       	call   8001dc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80027e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800285:	e9 c2 00 00 00       	jmp    80034c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80028a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80028d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	8b 00                	mov    (%eax),%eax
  80029b:	85 c0                	test   %eax,%eax
  80029d:	75 08                	jne    8002a7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80029f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002a2:	e9 a2 00 00 00       	jmp    800349 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8002a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b5:	eb 69                	jmp    800320 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8002c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	01 d0                	add    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 c8                	add    %ecx,%eax
  8002d0:	8a 40 04             	mov    0x4(%eax),%al
  8002d3:	84 c0                	test   %al,%al
  8002d5:	75 46                	jne    80031d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8002e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e5:	89 d0                	mov    %edx,%eax
  8002e7:	01 c0                	add    %eax,%eax
  8002e9:	01 d0                	add    %edx,%eax
  8002eb:	c1 e0 03             	shl    $0x3,%eax
  8002ee:	01 c8                	add    %ecx,%eax
  8002f0:	8b 00                	mov    (%eax),%eax
  8002f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002fd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800302:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	01 c8                	add    %ecx,%eax
  80030e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800310:	39 c2                	cmp    %eax,%edx
  800312:	75 09                	jne    80031d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800314:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80031b:	eb 12                	jmp    80032f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031d:	ff 45 e8             	incl   -0x18(%ebp)
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 50 74             	mov    0x74(%eax),%edx
  800328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032b:	39 c2                	cmp    %eax,%edx
  80032d:	77 88                	ja     8002b7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80032f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800333:	75 14                	jne    800349 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	68 54 1d 80 00       	push   $0x801d54
  80033d:	6a 3a                	push   $0x3a
  80033f:	68 48 1d 80 00       	push   $0x801d48
  800344:	e8 93 fe ff ff       	call   8001dc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800349:	ff 45 f0             	incl   -0x10(%ebp)
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800352:	0f 8c 32 ff ff ff    	jl     80028a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800358:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800366:	eb 26                	jmp    80038e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800368:	a1 20 30 80 00       	mov    0x803020,%eax
  80036d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800373:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800376:	89 d0                	mov    %edx,%eax
  800378:	01 c0                	add    %eax,%eax
  80037a:	01 d0                	add    %edx,%eax
  80037c:	c1 e0 03             	shl    $0x3,%eax
  80037f:	01 c8                	add    %ecx,%eax
  800381:	8a 40 04             	mov    0x4(%eax),%al
  800384:	3c 01                	cmp    $0x1,%al
  800386:	75 03                	jne    80038b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800388:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038b:	ff 45 e0             	incl   -0x20(%ebp)
  80038e:	a1 20 30 80 00       	mov    0x803020,%eax
  800393:	8b 50 74             	mov    0x74(%eax),%edx
  800396:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	77 cb                	ja     800368 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80039d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a3:	74 14                	je     8003b9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	68 a8 1d 80 00       	push   $0x801da8
  8003ad:	6a 44                	push   $0x44
  8003af:	68 48 1d 80 00       	push   $0x801d48
  8003b4:	e8 23 fe ff ff       	call   8001dc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003b9:	90                   	nop
  8003ba:	c9                   	leave  
  8003bb:	c3                   	ret    

008003bc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cd:	89 0a                	mov    %ecx,(%edx)
  8003cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d2:	88 d1                	mov    %dl,%cl
  8003d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e5:	75 2c                	jne    800413 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003e7:	a0 24 30 80 00       	mov    0x803024,%al
  8003ec:	0f b6 c0             	movzbl %al,%eax
  8003ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f2:	8b 12                	mov    (%edx),%edx
  8003f4:	89 d1                	mov    %edx,%ecx
  8003f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f9:	83 c2 08             	add    $0x8,%edx
  8003fc:	83 ec 04             	sub    $0x4,%esp
  8003ff:	50                   	push   %eax
  800400:	51                   	push   %ecx
  800401:	52                   	push   %edx
  800402:	e8 3e 0e 00 00       	call   801245 <sys_cputs>
  800407:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80040a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	8b 40 04             	mov    0x4(%eax),%eax
  800419:	8d 50 01             	lea    0x1(%eax),%edx
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800422:	90                   	nop
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80042e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800435:	00 00 00 
	b.cnt = 0;
  800438:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80044e:	50                   	push   %eax
  80044f:	68 bc 03 80 00       	push   $0x8003bc
  800454:	e8 11 02 00 00       	call   80066a <vprintfmt>
  800459:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80045c:	a0 24 30 80 00       	mov    0x803024,%al
  800461:	0f b6 c0             	movzbl %al,%eax
  800464:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	50                   	push   %eax
  80046e:	52                   	push   %edx
  80046f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800475:	83 c0 08             	add    $0x8,%eax
  800478:	50                   	push   %eax
  800479:	e8 c7 0d 00 00       	call   801245 <sys_cputs>
  80047e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800481:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800488:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <cprintf>:

int cprintf(const char *fmt, ...) {
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800496:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80049d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ac:	50                   	push   %eax
  8004ad:	e8 73 ff ff ff       	call   800425 <vcprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004c3:	e8 2b 0f 00 00       	call   8013f3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	e8 48 ff ff ff       	call   800425 <vcprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004e3:	e8 25 0f 00 00       	call   80140d <sys_enable_interrupt>
	return cnt;
  8004e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 14             	sub    $0x14,%esp
  8004f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800500:	8b 45 18             	mov    0x18(%ebp),%eax
  800503:	ba 00 00 00 00       	mov    $0x0,%edx
  800508:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050b:	77 55                	ja     800562 <printnum+0x75>
  80050d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800510:	72 05                	jb     800517 <printnum+0x2a>
  800512:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800515:	77 4b                	ja     800562 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800517:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80051a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80051d:	8b 45 18             	mov    0x18(%ebp),%eax
  800520:	ba 00 00 00 00       	mov    $0x0,%edx
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	ff 75 f4             	pushl  -0xc(%ebp)
  80052a:	ff 75 f0             	pushl  -0x10(%ebp)
  80052d:	e8 46 13 00 00       	call   801878 <__udivdi3>
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	ff 75 20             	pushl  0x20(%ebp)
  80053b:	53                   	push   %ebx
  80053c:	ff 75 18             	pushl  0x18(%ebp)
  80053f:	52                   	push   %edx
  800540:	50                   	push   %eax
  800541:	ff 75 0c             	pushl  0xc(%ebp)
  800544:	ff 75 08             	pushl  0x8(%ebp)
  800547:	e8 a1 ff ff ff       	call   8004ed <printnum>
  80054c:	83 c4 20             	add    $0x20,%esp
  80054f:	eb 1a                	jmp    80056b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	ff 75 0c             	pushl  0xc(%ebp)
  800557:	ff 75 20             	pushl  0x20(%ebp)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	ff d0                	call   *%eax
  80055f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800562:	ff 4d 1c             	decl   0x1c(%ebp)
  800565:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800569:	7f e6                	jg     800551 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80056b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80056e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800579:	53                   	push   %ebx
  80057a:	51                   	push   %ecx
  80057b:	52                   	push   %edx
  80057c:	50                   	push   %eax
  80057d:	e8 06 14 00 00       	call   801988 <__umoddi3>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	05 14 20 80 00       	add    $0x802014,%eax
  80058a:	8a 00                	mov    (%eax),%al
  80058c:	0f be c0             	movsbl %al,%eax
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	ff 75 0c             	pushl  0xc(%ebp)
  800595:	50                   	push   %eax
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	ff d0                	call   *%eax
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ab:	7e 1c                	jle    8005c9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	8d 50 08             	lea    0x8(%eax),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	89 10                	mov    %edx,(%eax)
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	83 e8 08             	sub    $0x8,%eax
  8005c2:	8b 50 04             	mov    0x4(%eax),%edx
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	eb 40                	jmp    800609 <getuint+0x65>
	else if (lflag)
  8005c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005cd:	74 1e                	je     8005ed <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	8d 50 04             	lea    0x4(%eax),%edx
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	89 10                	mov    %edx,(%eax)
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	83 e8 04             	sub    $0x4,%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005eb:	eb 1c                	jmp    800609 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 50 04             	lea    0x4(%eax),%edx
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	89 10                	mov    %edx,(%eax)
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	83 e8 04             	sub    $0x4,%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800609:	5d                   	pop    %ebp
  80060a:	c3                   	ret    

0080060b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80060b:	55                   	push   %ebp
  80060c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80060e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800612:	7e 1c                	jle    800630 <getint+0x25>
		return va_arg(*ap, long long);
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	8d 50 08             	lea    0x8(%eax),%edx
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 10                	mov    %edx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	83 e8 08             	sub    $0x8,%eax
  800629:	8b 50 04             	mov    0x4(%eax),%edx
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	eb 38                	jmp    800668 <getint+0x5d>
	else if (lflag)
  800630:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800634:	74 1a                	je     800650 <getint+0x45>
		return va_arg(*ap, long);
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	8d 50 04             	lea    0x4(%eax),%edx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 10                	mov    %edx,(%eax)
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	83 e8 04             	sub    $0x4,%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	99                   	cltd   
  80064e:	eb 18                	jmp    800668 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 04             	lea    0x4(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 04             	sub    $0x4,%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	99                   	cltd   
}
  800668:	5d                   	pop    %ebp
  800669:	c3                   	ret    

0080066a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80066a:	55                   	push   %ebp
  80066b:	89 e5                	mov    %esp,%ebp
  80066d:	56                   	push   %esi
  80066e:	53                   	push   %ebx
  80066f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800672:	eb 17                	jmp    80068b <vprintfmt+0x21>
			if (ch == '\0')
  800674:	85 db                	test   %ebx,%ebx
  800676:	0f 84 af 03 00 00    	je     800a2b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	53                   	push   %ebx
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	ff d0                	call   *%eax
  800688:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068b:	8b 45 10             	mov    0x10(%ebp),%eax
  80068e:	8d 50 01             	lea    0x1(%eax),%edx
  800691:	89 55 10             	mov    %edx,0x10(%ebp)
  800694:	8a 00                	mov    (%eax),%al
  800696:	0f b6 d8             	movzbl %al,%ebx
  800699:	83 fb 25             	cmp    $0x25,%ebx
  80069c:	75 d6                	jne    800674 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80069e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006a2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006be:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c1:	8d 50 01             	lea    0x1(%eax),%edx
  8006c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f b6 d8             	movzbl %al,%ebx
  8006cc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006cf:	83 f8 55             	cmp    $0x55,%eax
  8006d2:	0f 87 2b 03 00 00    	ja     800a03 <vprintfmt+0x399>
  8006d8:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  8006df:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006e1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006e5:	eb d7                	jmp    8006be <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006eb:	eb d1                	jmp    8006be <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	c1 e0 02             	shl    $0x2,%eax
  8006fc:	01 d0                	add    %edx,%eax
  8006fe:	01 c0                	add    %eax,%eax
  800700:	01 d8                	add    %ebx,%eax
  800702:	83 e8 30             	sub    $0x30,%eax
  800705:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800708:	8b 45 10             	mov    0x10(%ebp),%eax
  80070b:	8a 00                	mov    (%eax),%al
  80070d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800710:	83 fb 2f             	cmp    $0x2f,%ebx
  800713:	7e 3e                	jle    800753 <vprintfmt+0xe9>
  800715:	83 fb 39             	cmp    $0x39,%ebx
  800718:	7f 39                	jg     800753 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80071d:	eb d5                	jmp    8006f4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	83 c0 04             	add    $0x4,%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800733:	eb 1f                	jmp    800754 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800735:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800739:	79 83                	jns    8006be <vprintfmt+0x54>
				width = 0;
  80073b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800742:	e9 77 ff ff ff       	jmp    8006be <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800747:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80074e:	e9 6b ff ff ff       	jmp    8006be <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800753:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800754:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800758:	0f 89 60 ff ff ff    	jns    8006be <vprintfmt+0x54>
				width = precision, precision = -1;
  80075e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800761:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800764:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80076b:	e9 4e ff ff ff       	jmp    8006be <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800770:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800773:	e9 46 ff ff ff       	jmp    8006be <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 c0 04             	add    $0x4,%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	83 e8 04             	sub    $0x4,%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	50                   	push   %eax
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
			break;
  800798:	e9 89 02 00 00       	jmp    800a26 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	83 c0 04             	add    $0x4,%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	83 e8 04             	sub    $0x4,%eax
  8007ac:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007ae:	85 db                	test   %ebx,%ebx
  8007b0:	79 02                	jns    8007b4 <vprintfmt+0x14a>
				err = -err;
  8007b2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007b4:	83 fb 64             	cmp    $0x64,%ebx
  8007b7:	7f 0b                	jg     8007c4 <vprintfmt+0x15a>
  8007b9:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  8007c0:	85 f6                	test   %esi,%esi
  8007c2:	75 19                	jne    8007dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007c4:	53                   	push   %ebx
  8007c5:	68 25 20 80 00       	push   $0x802025
  8007ca:	ff 75 0c             	pushl  0xc(%ebp)
  8007cd:	ff 75 08             	pushl  0x8(%ebp)
  8007d0:	e8 5e 02 00 00       	call   800a33 <printfmt>
  8007d5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007d8:	e9 49 02 00 00       	jmp    800a26 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007dd:	56                   	push   %esi
  8007de:	68 2e 20 80 00       	push   $0x80202e
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	e8 45 02 00 00       	call   800a33 <printfmt>
  8007ee:	83 c4 10             	add    $0x10,%esp
			break;
  8007f1:	e9 30 02 00 00       	jmp    800a26 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	83 e8 04             	sub    $0x4,%eax
  800805:	8b 30                	mov    (%eax),%esi
  800807:	85 f6                	test   %esi,%esi
  800809:	75 05                	jne    800810 <vprintfmt+0x1a6>
				p = "(null)";
  80080b:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  800810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800814:	7e 6d                	jle    800883 <vprintfmt+0x219>
  800816:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80081a:	74 67                	je     800883 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80081c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	50                   	push   %eax
  800823:	56                   	push   %esi
  800824:	e8 0c 03 00 00       	call   800b35 <strnlen>
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80082f:	eb 16                	jmp    800847 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800831:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	50                   	push   %eax
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800844:	ff 4d e4             	decl   -0x1c(%ebp)
  800847:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084b:	7f e4                	jg     800831 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084d:	eb 34                	jmp    800883 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80084f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800853:	74 1c                	je     800871 <vprintfmt+0x207>
  800855:	83 fb 1f             	cmp    $0x1f,%ebx
  800858:	7e 05                	jle    80085f <vprintfmt+0x1f5>
  80085a:	83 fb 7e             	cmp    $0x7e,%ebx
  80085d:	7e 12                	jle    800871 <vprintfmt+0x207>
					putch('?', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 3f                	push   $0x3f
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	eb 0f                	jmp    800880 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	53                   	push   %ebx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	ff d0                	call   *%eax
  80087d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800880:	ff 4d e4             	decl   -0x1c(%ebp)
  800883:	89 f0                	mov    %esi,%eax
  800885:	8d 70 01             	lea    0x1(%eax),%esi
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f be d8             	movsbl %al,%ebx
  80088d:	85 db                	test   %ebx,%ebx
  80088f:	74 24                	je     8008b5 <vprintfmt+0x24b>
  800891:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800895:	78 b8                	js     80084f <vprintfmt+0x1e5>
  800897:	ff 4d e0             	decl   -0x20(%ebp)
  80089a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80089e:	79 af                	jns    80084f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a0:	eb 13                	jmp    8008b5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	6a 20                	push   $0x20
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b9:	7f e7                	jg     8008a2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008bb:	e9 66 01 00 00       	jmp    800a26 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c9:	50                   	push   %eax
  8008ca:	e8 3c fd ff ff       	call   80060b <getint>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008de:	85 d2                	test   %edx,%edx
  8008e0:	79 23                	jns    800905 <vprintfmt+0x29b>
				putch('-', putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	6a 2d                	push   $0x2d
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	ff d0                	call   *%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f8:	f7 d8                	neg    %eax
  8008fa:	83 d2 00             	adc    $0x0,%edx
  8008fd:	f7 da                	neg    %edx
  8008ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800902:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800905:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80090c:	e9 bc 00 00 00       	jmp    8009cd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 e8             	pushl  -0x18(%ebp)
  800917:	8d 45 14             	lea    0x14(%ebp),%eax
  80091a:	50                   	push   %eax
  80091b:	e8 84 fc ff ff       	call   8005a4 <getuint>
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800926:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800929:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800930:	e9 98 00 00 00       	jmp    8009cd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 58                	push   $0x58
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 58                	push   $0x58
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 58                	push   $0x58
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			break;
  800965:	e9 bc 00 00 00       	jmp    800a26 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	6a 30                	push   $0x30
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
  800977:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 78                	push   $0x78
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 c0 04             	add    $0x4,%eax
  800990:	89 45 14             	mov    %eax,0x14(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 e8 04             	sub    $0x4,%eax
  800999:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009a5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009ac:	eb 1f                	jmp    8009cd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	e8 e7 fb ff ff       	call   8005a4 <getuint>
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009c6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009cd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d4:	83 ec 04             	sub    $0x4,%esp
  8009d7:	52                   	push   %edx
  8009d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009df:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 00 fb ff ff       	call   8004ed <printnum>
  8009ed:	83 c4 20             	add    $0x20,%esp
			break;
  8009f0:	eb 34                	jmp    800a26 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	53                   	push   %ebx
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
			break;
  800a01:	eb 23                	jmp    800a26 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	6a 25                	push   $0x25
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a13:	ff 4d 10             	decl   0x10(%ebp)
  800a16:	eb 03                	jmp    800a1b <vprintfmt+0x3b1>
  800a18:	ff 4d 10             	decl   0x10(%ebp)
  800a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1e:	48                   	dec    %eax
  800a1f:	8a 00                	mov    (%eax),%al
  800a21:	3c 25                	cmp    $0x25,%al
  800a23:	75 f3                	jne    800a18 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a25:	90                   	nop
		}
	}
  800a26:	e9 47 fc ff ff       	jmp    800672 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a2b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a39:	8d 45 10             	lea    0x10(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	ff 75 f4             	pushl  -0xc(%ebp)
  800a48:	50                   	push   %eax
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	ff 75 08             	pushl  0x8(%ebp)
  800a4f:	e8 16 fc ff ff       	call   80066a <vprintfmt>
  800a54:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a57:	90                   	nop
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 40 08             	mov    0x8(%eax),%eax
  800a63:	8d 50 01             	lea    0x1(%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8b 10                	mov    (%eax),%edx
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	8b 40 04             	mov    0x4(%eax),%eax
  800a77:	39 c2                	cmp    %eax,%edx
  800a79:	73 12                	jae    800a8d <sprintputch+0x33>
		*b->buf++ = ch;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	8d 48 01             	lea    0x1(%eax),%ecx
  800a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a86:	89 0a                	mov    %ecx,(%edx)
  800a88:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8b:	88 10                	mov    %dl,(%eax)
}
  800a8d:	90                   	nop
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	01 d0                	add    %edx,%eax
  800aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ab1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ab5:	74 06                	je     800abd <vsnprintf+0x2d>
  800ab7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800abb:	7f 07                	jg     800ac4 <vsnprintf+0x34>
		return -E_INVAL;
  800abd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac2:	eb 20                	jmp    800ae4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac4:	ff 75 14             	pushl  0x14(%ebp)
  800ac7:	ff 75 10             	pushl  0x10(%ebp)
  800aca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800acd:	50                   	push   %eax
  800ace:	68 5a 0a 80 00       	push   $0x800a5a
  800ad3:	e8 92 fb ff ff       	call   80066a <vprintfmt>
  800ad8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ade:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aec:	8d 45 10             	lea    0x10(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	ff 75 f4             	pushl  -0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 89 ff ff ff       	call   800a90 <vsnprintf>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1f:	eb 06                	jmp    800b27 <strlen+0x15>
		n++;
  800b21:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b24:	ff 45 08             	incl   0x8(%ebp)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8a 00                	mov    (%eax),%al
  800b2c:	84 c0                	test   %al,%al
  800b2e:	75 f1                	jne    800b21 <strlen+0xf>
		n++;
	return n;
  800b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b33:	c9                   	leave  
  800b34:	c3                   	ret    

00800b35 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b42:	eb 09                	jmp    800b4d <strnlen+0x18>
		n++;
  800b44:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b47:	ff 45 08             	incl   0x8(%ebp)
  800b4a:	ff 4d 0c             	decl   0xc(%ebp)
  800b4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b51:	74 09                	je     800b5c <strnlen+0x27>
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	84 c0                	test   %al,%al
  800b5a:	75 e8                	jne    800b44 <strnlen+0xf>
		n++;
	return n;
  800b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b6d:	90                   	nop
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b80:	8a 12                	mov    (%edx),%dl
  800b82:	88 10                	mov    %dl,(%eax)
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	84 c0                	test   %al,%al
  800b88:	75 e4                	jne    800b6e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba2:	eb 1f                	jmp    800bc3 <strncpy+0x34>
		*dst++ = *src;
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8d 50 01             	lea    0x1(%eax),%edx
  800baa:	89 55 08             	mov    %edx,0x8(%ebp)
  800bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb0:	8a 12                	mov    (%edx),%dl
  800bb2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	84 c0                	test   %al,%al
  800bbb:	74 03                	je     800bc0 <strncpy+0x31>
			src++;
  800bbd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bc0:	ff 45 fc             	incl   -0x4(%ebp)
  800bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bc9:	72 d9                	jb     800ba4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be0:	74 30                	je     800c12 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800be2:	eb 16                	jmp    800bfa <strlcpy+0x2a>
			*dst++ = *src++;
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 08             	mov    %edx,0x8(%ebp)
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf6:	8a 12                	mov    (%edx),%dl
  800bf8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bfa:	ff 4d 10             	decl   0x10(%ebp)
  800bfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c01:	74 09                	je     800c0c <strlcpy+0x3c>
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	84 c0                	test   %al,%al
  800c0a:	75 d8                	jne    800be4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c18:	29 c2                	sub    %eax,%edx
  800c1a:	89 d0                	mov    %edx,%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c21:	eb 06                	jmp    800c29 <strcmp+0xb>
		p++, q++;
  800c23:	ff 45 08             	incl   0x8(%ebp)
  800c26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	74 0e                	je     800c40 <strcmp+0x22>
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 10                	mov    (%eax),%dl
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	38 c2                	cmp    %al,%dl
  800c3e:	74 e3                	je     800c23 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	0f b6 d0             	movzbl %al,%edx
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 c0             	movzbl %al,%eax
  800c50:	29 c2                	sub    %eax,%edx
  800c52:	89 d0                	mov    %edx,%eax
}
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c59:	eb 09                	jmp    800c64 <strncmp+0xe>
		n--, p++, q++;
  800c5b:	ff 4d 10             	decl   0x10(%ebp)
  800c5e:	ff 45 08             	incl   0x8(%ebp)
  800c61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c68:	74 17                	je     800c81 <strncmp+0x2b>
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	84 c0                	test   %al,%al
  800c71:	74 0e                	je     800c81 <strncmp+0x2b>
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 10                	mov    (%eax),%dl
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	38 c2                	cmp    %al,%dl
  800c7f:	74 da                	je     800c5b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c85:	75 07                	jne    800c8e <strncmp+0x38>
		return 0;
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	eb 14                	jmp    800ca2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	0f b6 d0             	movzbl %al,%edx
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	0f b6 c0             	movzbl %al,%eax
  800c9e:	29 c2                	sub    %eax,%edx
  800ca0:	89 d0                	mov    %edx,%eax
}
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 04             	sub    $0x4,%esp
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb0:	eb 12                	jmp    800cc4 <strchr+0x20>
		if (*s == c)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cba:	75 05                	jne    800cc1 <strchr+0x1d>
			return (char *) s;
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	eb 11                	jmp    800cd2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cc1:	ff 45 08             	incl   0x8(%ebp)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 e5                	jne    800cb2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 04             	sub    $0x4,%esp
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ce0:	eb 0d                	jmp    800cef <strfind+0x1b>
		if (*s == c)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cea:	74 0e                	je     800cfa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cec:	ff 45 08             	incl   0x8(%ebp)
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	75 ea                	jne    800ce2 <strfind+0xe>
  800cf8:	eb 01                	jmp    800cfb <strfind+0x27>
		if (*s == c)
			break;
  800cfa:	90                   	nop
	return (char *) s;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d12:	eb 0e                	jmp    800d22 <memset+0x22>
		*p++ = c;
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	8d 50 01             	lea    0x1(%eax),%edx
  800d1a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d20:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d22:	ff 4d f8             	decl   -0x8(%ebp)
  800d25:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d29:	79 e9                	jns    800d14 <memset+0x14>
		*p++ = c;

	return v;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d42:	eb 16                	jmp    800d5a <memcpy+0x2a>
		*d++ = *s++;
  800d44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d53:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d56:	8a 12                	mov    (%edx),%dl
  800d58:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d60:	89 55 10             	mov    %edx,0x10(%ebp)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 dd                	jne    800d44 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d84:	73 50                	jae    800dd6 <memmove+0x6a>
  800d86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	01 d0                	add    %edx,%eax
  800d8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d91:	76 43                	jbe    800dd6 <memmove+0x6a>
		s += n;
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d9f:	eb 10                	jmp    800db1 <memmove+0x45>
			*--d = *--s;
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	ff 4d fc             	decl   -0x4(%ebp)
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	8a 10                	mov    (%eax),%dl
  800dac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800daf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	75 e3                	jne    800da1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dbe:	eb 23                	jmp    800de3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc3:	8d 50 01             	lea    0x1(%eax),%edx
  800dc6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd2:	8a 12                	mov    (%edx),%dl
  800dd4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	75 dd                	jne    800dc0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dfa:	eb 2a                	jmp    800e26 <memcmp+0x3e>
		if (*s1 != *s2)
  800dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dff:	8a 10                	mov    (%eax),%dl
  800e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	38 c2                	cmp    %al,%dl
  800e08:	74 16                	je     800e20 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	0f b6 d0             	movzbl %al,%edx
  800e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f b6 c0             	movzbl %al,%eax
  800e1a:	29 c2                	sub    %eax,%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	eb 18                	jmp    800e38 <memcmp+0x50>
		s1++, s2++;
  800e20:	ff 45 fc             	incl   -0x4(%ebp)
  800e23:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	75 c9                	jne    800dfc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e4b:	eb 15                	jmp    800e62 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	0f b6 d0             	movzbl %al,%edx
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	0f b6 c0             	movzbl %al,%eax
  800e5b:	39 c2                	cmp    %eax,%edx
  800e5d:	74 0d                	je     800e6c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e68:	72 e3                	jb     800e4d <memfind+0x13>
  800e6a:	eb 01                	jmp    800e6d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e6c:	90                   	nop
	return (void *) s;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e7f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e86:	eb 03                	jmp    800e8b <strtol+0x19>
		s++;
  800e88:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	3c 20                	cmp    $0x20,%al
  800e92:	74 f4                	je     800e88 <strtol+0x16>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 09                	cmp    $0x9,%al
  800e9b:	74 eb                	je     800e88 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 2b                	cmp    $0x2b,%al
  800ea4:	75 05                	jne    800eab <strtol+0x39>
		s++;
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	eb 13                	jmp    800ebe <strtol+0x4c>
	else if (*s == '-')
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	3c 2d                	cmp    $0x2d,%al
  800eb2:	75 0a                	jne    800ebe <strtol+0x4c>
		s++, neg = 1;
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec2:	74 06                	je     800eca <strtol+0x58>
  800ec4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ec8:	75 20                	jne    800eea <strtol+0x78>
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3c 30                	cmp    $0x30,%al
  800ed1:	75 17                	jne    800eea <strtol+0x78>
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	40                   	inc    %eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	3c 78                	cmp    $0x78,%al
  800edb:	75 0d                	jne    800eea <strtol+0x78>
		s += 2, base = 16;
  800edd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ee1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ee8:	eb 28                	jmp    800f12 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	75 15                	jne    800f05 <strtol+0x93>
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 30                	cmp    $0x30,%al
  800ef7:	75 0c                	jne    800f05 <strtol+0x93>
		s++, base = 8;
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f03:	eb 0d                	jmp    800f12 <strtol+0xa0>
	else if (base == 0)
  800f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f09:	75 07                	jne    800f12 <strtol+0xa0>
		base = 10;
  800f0b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 2f                	cmp    $0x2f,%al
  800f19:	7e 19                	jle    800f34 <strtol+0xc2>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 39                	cmp    $0x39,%al
  800f22:	7f 10                	jg     800f34 <strtol+0xc2>
			dig = *s - '0';
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f be c0             	movsbl %al,%eax
  800f2c:	83 e8 30             	sub    $0x30,%eax
  800f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f32:	eb 42                	jmp    800f76 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 60                	cmp    $0x60,%al
  800f3b:	7e 19                	jle    800f56 <strtol+0xe4>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	3c 7a                	cmp    $0x7a,%al
  800f44:	7f 10                	jg     800f56 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be c0             	movsbl %al,%eax
  800f4e:	83 e8 57             	sub    $0x57,%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f54:	eb 20                	jmp    800f76 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 40                	cmp    $0x40,%al
  800f5d:	7e 39                	jle    800f98 <strtol+0x126>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 5a                	cmp    $0x5a,%al
  800f66:	7f 30                	jg     800f98 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f be c0             	movsbl %al,%eax
  800f70:	83 e8 37             	sub    $0x37,%eax
  800f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f7c:	7d 19                	jge    800f97 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f88:	89 c2                	mov    %eax,%edx
  800f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8d:	01 d0                	add    %edx,%eax
  800f8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f92:	e9 7b ff ff ff       	jmp    800f12 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f97:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f9c:	74 08                	je     800fa6 <strtol+0x134>
		*endptr = (char *) s;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800faa:	74 07                	je     800fb3 <strtol+0x141>
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	f7 d8                	neg    %eax
  800fb1:	eb 03                	jmp    800fb6 <strtol+0x144>
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <ltostr>:

void
ltostr(long value, char *str)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fc5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fd0:	79 13                	jns    800fe5 <ltostr+0x2d>
	{
		neg = 1;
  800fd2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fdf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fe2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fed:	99                   	cltd   
  800fee:	f7 f9                	idiv   %ecx
  800ff0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801006:	83 c2 30             	add    $0x30,%edx
  801009:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80100b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801013:	f7 e9                	imul   %ecx
  801015:	c1 fa 02             	sar    $0x2,%edx
  801018:	89 c8                	mov    %ecx,%eax
  80101a:	c1 f8 1f             	sar    $0x1f,%eax
  80101d:	29 c2                	sub    %eax,%edx
  80101f:	89 d0                	mov    %edx,%eax
  801021:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801024:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801027:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80102c:	f7 e9                	imul   %ecx
  80102e:	c1 fa 02             	sar    $0x2,%edx
  801031:	89 c8                	mov    %ecx,%eax
  801033:	c1 f8 1f             	sar    $0x1f,%eax
  801036:	29 c2                	sub    %eax,%edx
  801038:	89 d0                	mov    %edx,%eax
  80103a:	c1 e0 02             	shl    $0x2,%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	01 c0                	add    %eax,%eax
  801041:	29 c1                	sub    %eax,%ecx
  801043:	89 ca                	mov    %ecx,%edx
  801045:	85 d2                	test   %edx,%edx
  801047:	75 9c                	jne    800fe5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801049:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801053:	48                   	dec    %eax
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801057:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105b:	74 3d                	je     80109a <ltostr+0xe2>
		start = 1 ;
  80105d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801064:	eb 34                	jmp    80109a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	01 d0                	add    %edx,%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	01 c2                	add    %eax,%edx
  80107b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	01 c8                	add    %ecx,%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801087:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	01 c2                	add    %eax,%edx
  80108f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801092:	88 02                	mov    %al,(%edx)
		start++ ;
  801094:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801097:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80109a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010a0:	7c c4                	jl     801066 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	01 d0                	add    %edx,%eax
  8010aa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010ad:	90                   	nop
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010b6:	ff 75 08             	pushl  0x8(%ebp)
  8010b9:	e8 54 fa ff ff       	call   800b12 <strlen>
  8010be:	83 c4 04             	add    $0x4,%esp
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	e8 46 fa ff ff       	call   800b12 <strlen>
  8010cc:	83 c4 04             	add    $0x4,%esp
  8010cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e0:	eb 17                	jmp    8010f9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e8:	01 c2                	add    %eax,%edx
  8010ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	01 c8                	add    %ecx,%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010f6:	ff 45 fc             	incl   -0x4(%ebp)
  8010f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ff:	7c e1                	jl     8010e2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801101:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801108:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80110f:	eb 1f                	jmp    801130 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80112d:	ff 45 f8             	incl   -0x8(%ebp)
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801136:	7c d9                	jl     801111 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	c6 00 00             	movb   $0x0,(%eax)
}
  801143:	90                   	nop
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801149:	8b 45 14             	mov    0x14(%ebp),%eax
  80114c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801152:	8b 45 14             	mov    0x14(%ebp),%eax
  801155:	8b 00                	mov    (%eax),%eax
  801157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801169:	eb 0c                	jmp    801177 <strsplit+0x31>
			*string++ = 0;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8d 50 01             	lea    0x1(%eax),%edx
  801171:	89 55 08             	mov    %edx,0x8(%ebp)
  801174:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	84 c0                	test   %al,%al
  80117e:	74 18                	je     801198 <strsplit+0x52>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	50                   	push   %eax
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 13 fb ff ff       	call   800ca4 <strchr>
  801191:	83 c4 08             	add    $0x8,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	75 d3                	jne    80116b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	84 c0                	test   %al,%al
  80119f:	74 5a                	je     8011fb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a4:	8b 00                	mov    (%eax),%eax
  8011a6:	83 f8 0f             	cmp    $0xf,%eax
  8011a9:	75 07                	jne    8011b2 <strsplit+0x6c>
		{
			return 0;
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b0:	eb 66                	jmp    801218 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b5:	8b 00                	mov    (%eax),%eax
  8011b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ba:	8b 55 14             	mov    0x14(%ebp),%edx
  8011bd:	89 0a                	mov    %ecx,(%edx)
  8011bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011d0:	eb 03                	jmp    8011d5 <strsplit+0x8f>
			string++;
  8011d2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	84 c0                	test   %al,%al
  8011dc:	74 8b                	je     801169 <strsplit+0x23>
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	0f be c0             	movsbl %al,%eax
  8011e6:	50                   	push   %eax
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	e8 b5 fa ff ff       	call   800ca4 <strchr>
  8011ef:	83 c4 08             	add    $0x8,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	74 dc                	je     8011d2 <strsplit+0x8c>
			string++;
	}
  8011f6:	e9 6e ff ff ff       	jmp    801169 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011fb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ff:	8b 00                	mov    (%eax),%eax
  801201:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801213:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	57                   	push   %edi
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80122c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80122f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801232:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801235:	cd 30                	int    $0x30
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	5b                   	pop    %ebx
  801241:	5e                   	pop    %esi
  801242:	5f                   	pop    %edi
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    

00801245 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 04             	sub    $0x4,%esp
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801251:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	52                   	push   %edx
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	50                   	push   %eax
  801261:	6a 00                	push   $0x0
  801263:	e8 b2 ff ff ff       	call   80121a <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
}
  80126b:	90                   	nop
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_cgetc>:

int
sys_cgetc(void)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 01                	push   $0x1
  80127d:	e8 98 ff ff ff       	call   80121a <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80128a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	52                   	push   %edx
  801297:	50                   	push   %eax
  801298:	6a 05                	push   $0x5
  80129a:	e8 7b ff ff ff       	call   80121a <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
  8012ba:	51                   	push   %ecx
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	6a 06                	push   $0x6
  8012bf:	e8 56 ff ff ff       	call   80121a <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 07                	push   $0x7
  8012e1:	e8 34 ff ff ff       	call   80121a <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	6a 08                	push   $0x8
  8012fc:	e8 19 ff ff ff       	call   80121a <syscall>
  801301:	83 c4 18             	add    $0x18,%esp
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 09                	push   $0x9
  801315:	e8 00 ff ff ff       	call   80121a <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 0a                	push   $0xa
  80132e:	e8 e7 fe ff ff       	call   80121a <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 0b                	push   $0xb
  801347:	e8 ce fe ff ff       	call   80121a <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	6a 0f                	push   $0xf
  801362:	e8 b3 fe ff ff       	call   80121a <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
	return;
  80136a:	90                   	nop
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	ff 75 0c             	pushl  0xc(%ebp)
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	6a 10                	push   $0x10
  80137e:	e8 97 fe ff ff       	call   80121a <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
	return ;
  801386:	90                   	nop
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	ff 75 10             	pushl  0x10(%ebp)
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	6a 11                	push   $0x11
  80139b:	e8 7a fe ff ff       	call   80121a <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8013a3:	90                   	nop
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 0c                	push   $0xc
  8013b5:	e8 60 fe ff ff       	call   80121a <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	6a 0d                	push   $0xd
  8013cf:	e8 46 fe ff ff       	call   80121a <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 0e                	push   $0xe
  8013e8:	e8 2d fe ff ff       	call   80121a <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 13                	push   $0x13
  801402:	e8 13 fe ff ff       	call   80121a <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	90                   	nop
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 14                	push   $0x14
  80141c:	e8 f9 fd ff ff       	call   80121a <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	90                   	nop
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_cputc>:


void
sys_cputc(const char c)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801433:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	50                   	push   %eax
  801440:	6a 15                	push   $0x15
  801442:	e8 d3 fd ff ff       	call   80121a <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
}
  80144a:	90                   	nop
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 16                	push   $0x16
  80145c:	e8 b9 fd ff ff       	call   80121a <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	50                   	push   %eax
  801477:	6a 17                	push   $0x17
  801479:	e8 9c fd ff ff       	call   80121a <syscall>
  80147e:	83 c4 18             	add    $0x18,%esp
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	52                   	push   %edx
  801493:	50                   	push   %eax
  801494:	6a 1a                	push   $0x1a
  801496:	e8 7f fd ff ff       	call   80121a <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	52                   	push   %edx
  8014b0:	50                   	push   %eax
  8014b1:	6a 18                	push   $0x18
  8014b3:	e8 62 fd ff ff       	call   80121a <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	52                   	push   %edx
  8014ce:	50                   	push   %eax
  8014cf:	6a 19                	push   $0x19
  8014d1:	e8 44 fd ff ff       	call   80121a <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	90                   	nop
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	6a 00                	push   $0x0
  8014f4:	51                   	push   %ecx
  8014f5:	52                   	push   %edx
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	50                   	push   %eax
  8014fa:	6a 1b                	push   $0x1b
  8014fc:	e8 19 fd ff ff       	call   80121a <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 1c                	push   $0x1c
  801519:	e8 fc fc ff ff       	call   80121a <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801526:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	51                   	push   %ecx
  801534:	52                   	push   %edx
  801535:	50                   	push   %eax
  801536:	6a 1d                	push   $0x1d
  801538:	e8 dd fc ff ff       	call   80121a <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 1e                	push   $0x1e
  801555:	e8 c0 fc ff ff       	call   80121a <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 1f                	push   $0x1f
  80156e:	e8 a7 fc ff ff       	call   80121a <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	6a 00                	push   $0x0
  801580:	ff 75 14             	pushl  0x14(%ebp)
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	50                   	push   %eax
  80158a:	6a 20                	push   $0x20
  80158c:	e8 89 fc ff ff       	call   80121a <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	50                   	push   %eax
  8015a5:	6a 21                	push   $0x21
  8015a7:	e8 6e fc ff ff       	call   80121a <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	90                   	nop
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	50                   	push   %eax
  8015c1:	6a 22                	push   $0x22
  8015c3:	e8 52 fc ff ff       	call   80121a <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 02                	push   $0x2
  8015dc:	e8 39 fc ff ff       	call   80121a <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 03                	push   $0x3
  8015f5:	e8 20 fc ff ff       	call   80121a <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 04                	push   $0x4
  80160e:	e8 07 fc ff ff       	call   80121a <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_exit_env>:


void sys_exit_env(void)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 23                	push   $0x23
  801627:	e8 ee fb ff ff       	call   80121a <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801638:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80163b:	8d 50 04             	lea    0x4(%eax),%edx
  80163e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	52                   	push   %edx
  801648:	50                   	push   %eax
  801649:	6a 24                	push   $0x24
  80164b:	e8 ca fb ff ff       	call   80121a <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
	return result;
  801653:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165c:	89 01                	mov    %eax,(%ecx)
  80165e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	c9                   	leave  
  801665:	c2 04 00             	ret    $0x4

00801668 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	ff 75 10             	pushl  0x10(%ebp)
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	6a 12                	push   $0x12
  80167a:	e8 9b fb ff ff       	call   80121a <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
	return ;
  801682:	90                   	nop
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_rcr2>:
uint32 sys_rcr2()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 25                	push   $0x25
  801694:	e8 81 fb ff ff       	call   80121a <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016aa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	50                   	push   %eax
  8016b7:	6a 26                	push   $0x26
  8016b9:	e8 5c fb ff ff       	call   80121a <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c1:	90                   	nop
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <rsttst>:
void rsttst()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 28                	push   $0x28
  8016d3:	e8 42 fb ff ff       	call   80121a <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016db:	90                   	nop
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ea:	8b 55 18             	mov    0x18(%ebp),%edx
  8016ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016f1:	52                   	push   %edx
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 10             	pushl  0x10(%ebp)
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 27                	push   $0x27
  8016fe:	e8 17 fb ff ff       	call   80121a <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
	return ;
  801706:	90                   	nop
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <chktst>:
void chktst(uint32 n)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	6a 29                	push   $0x29
  801719:	e8 fc fa ff ff       	call   80121a <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
	return ;
  801721:	90                   	nop
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <inctst>:

void inctst()
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 2a                	push   $0x2a
  801733:	e8 e2 fa ff ff       	call   80121a <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return ;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <gettst>:
uint32 gettst()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 2b                	push   $0x2b
  80174d:	e8 c8 fa ff ff       	call   80121a <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 2c                	push   $0x2c
  801769:	e8 ac fa ff ff       	call   80121a <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801774:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801778:	75 07                	jne    801781 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80177a:	b8 01 00 00 00       	mov    $0x1,%eax
  80177f:	eb 05                	jmp    801786 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 2c                	push   $0x2c
  80179a:	e8 7b fa ff ff       	call   80121a <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
  8017a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017a5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017a9:	75 07                	jne    8017b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b0:	eb 05                	jmp    8017b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 2c                	push   $0x2c
  8017cb:	e8 4a fa ff ff       	call   80121a <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
  8017d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017d6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017da:	75 07                	jne    8017e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e1:	eb 05                	jmp    8017e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 2c                	push   $0x2c
  8017fc:	e8 19 fa ff ff       	call   80121a <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
  801804:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801807:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80180b:	75 07                	jne    801814 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80180d:	b8 01 00 00 00       	mov    $0x1,%eax
  801812:	eb 05                	jmp    801819 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801814:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	ff 75 08             	pushl  0x8(%ebp)
  801829:	6a 2d                	push   $0x2d
  80182b:	e8 ea f9 ff ff       	call   80121a <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
	return ;
  801833:	90                   	nop
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80183a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	53                   	push   %ebx
  801849:	51                   	push   %ecx
  80184a:	52                   	push   %edx
  80184b:	50                   	push   %eax
  80184c:	6a 2e                	push   $0x2e
  80184e:	e8 c7 f9 ff ff       	call   80121a <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	6a 2f                	push   $0x2f
  80186e:	e8 a7 f9 ff ff       	call   80121a <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <__udivdi3>:
  801878:	55                   	push   %ebp
  801879:	57                   	push   %edi
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
  80187c:	83 ec 1c             	sub    $0x1c,%esp
  80187f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801883:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801887:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80188b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80188f:	89 ca                	mov    %ecx,%edx
  801891:	89 f8                	mov    %edi,%eax
  801893:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801897:	85 f6                	test   %esi,%esi
  801899:	75 2d                	jne    8018c8 <__udivdi3+0x50>
  80189b:	39 cf                	cmp    %ecx,%edi
  80189d:	77 65                	ja     801904 <__udivdi3+0x8c>
  80189f:	89 fd                	mov    %edi,%ebp
  8018a1:	85 ff                	test   %edi,%edi
  8018a3:	75 0b                	jne    8018b0 <__udivdi3+0x38>
  8018a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018aa:	31 d2                	xor    %edx,%edx
  8018ac:	f7 f7                	div    %edi
  8018ae:	89 c5                	mov    %eax,%ebp
  8018b0:	31 d2                	xor    %edx,%edx
  8018b2:	89 c8                	mov    %ecx,%eax
  8018b4:	f7 f5                	div    %ebp
  8018b6:	89 c1                	mov    %eax,%ecx
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	f7 f5                	div    %ebp
  8018bc:	89 cf                	mov    %ecx,%edi
  8018be:	89 fa                	mov    %edi,%edx
  8018c0:	83 c4 1c             	add    $0x1c,%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
  8018c8:	39 ce                	cmp    %ecx,%esi
  8018ca:	77 28                	ja     8018f4 <__udivdi3+0x7c>
  8018cc:	0f bd fe             	bsr    %esi,%edi
  8018cf:	83 f7 1f             	xor    $0x1f,%edi
  8018d2:	75 40                	jne    801914 <__udivdi3+0x9c>
  8018d4:	39 ce                	cmp    %ecx,%esi
  8018d6:	72 0a                	jb     8018e2 <__udivdi3+0x6a>
  8018d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018dc:	0f 87 9e 00 00 00    	ja     801980 <__udivdi3+0x108>
  8018e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e7:	89 fa                	mov    %edi,%edx
  8018e9:	83 c4 1c             	add    $0x1c,%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5f                   	pop    %edi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    
  8018f1:	8d 76 00             	lea    0x0(%esi),%esi
  8018f4:	31 ff                	xor    %edi,%edi
  8018f6:	31 c0                	xor    %eax,%eax
  8018f8:	89 fa                	mov    %edi,%edx
  8018fa:	83 c4 1c             	add    $0x1c,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5f                   	pop    %edi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    
  801902:	66 90                	xchg   %ax,%ax
  801904:	89 d8                	mov    %ebx,%eax
  801906:	f7 f7                	div    %edi
  801908:	31 ff                	xor    %edi,%edi
  80190a:	89 fa                	mov    %edi,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	bd 20 00 00 00       	mov    $0x20,%ebp
  801919:	89 eb                	mov    %ebp,%ebx
  80191b:	29 fb                	sub    %edi,%ebx
  80191d:	89 f9                	mov    %edi,%ecx
  80191f:	d3 e6                	shl    %cl,%esi
  801921:	89 c5                	mov    %eax,%ebp
  801923:	88 d9                	mov    %bl,%cl
  801925:	d3 ed                	shr    %cl,%ebp
  801927:	89 e9                	mov    %ebp,%ecx
  801929:	09 f1                	or     %esi,%ecx
  80192b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80192f:	89 f9                	mov    %edi,%ecx
  801931:	d3 e0                	shl    %cl,%eax
  801933:	89 c5                	mov    %eax,%ebp
  801935:	89 d6                	mov    %edx,%esi
  801937:	88 d9                	mov    %bl,%cl
  801939:	d3 ee                	shr    %cl,%esi
  80193b:	89 f9                	mov    %edi,%ecx
  80193d:	d3 e2                	shl    %cl,%edx
  80193f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801943:	88 d9                	mov    %bl,%cl
  801945:	d3 e8                	shr    %cl,%eax
  801947:	09 c2                	or     %eax,%edx
  801949:	89 d0                	mov    %edx,%eax
  80194b:	89 f2                	mov    %esi,%edx
  80194d:	f7 74 24 0c          	divl   0xc(%esp)
  801951:	89 d6                	mov    %edx,%esi
  801953:	89 c3                	mov    %eax,%ebx
  801955:	f7 e5                	mul    %ebp
  801957:	39 d6                	cmp    %edx,%esi
  801959:	72 19                	jb     801974 <__udivdi3+0xfc>
  80195b:	74 0b                	je     801968 <__udivdi3+0xf0>
  80195d:	89 d8                	mov    %ebx,%eax
  80195f:	31 ff                	xor    %edi,%edi
  801961:	e9 58 ff ff ff       	jmp    8018be <__udivdi3+0x46>
  801966:	66 90                	xchg   %ax,%ax
  801968:	8b 54 24 08          	mov    0x8(%esp),%edx
  80196c:	89 f9                	mov    %edi,%ecx
  80196e:	d3 e2                	shl    %cl,%edx
  801970:	39 c2                	cmp    %eax,%edx
  801972:	73 e9                	jae    80195d <__udivdi3+0xe5>
  801974:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801977:	31 ff                	xor    %edi,%edi
  801979:	e9 40 ff ff ff       	jmp    8018be <__udivdi3+0x46>
  80197e:	66 90                	xchg   %ax,%ax
  801980:	31 c0                	xor    %eax,%eax
  801982:	e9 37 ff ff ff       	jmp    8018be <__udivdi3+0x46>
  801987:	90                   	nop

00801988 <__umoddi3>:
  801988:	55                   	push   %ebp
  801989:	57                   	push   %edi
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	83 ec 1c             	sub    $0x1c,%esp
  80198f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801993:	8b 74 24 34          	mov    0x34(%esp),%esi
  801997:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80199b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80199f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019a7:	89 f3                	mov    %esi,%ebx
  8019a9:	89 fa                	mov    %edi,%edx
  8019ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019af:	89 34 24             	mov    %esi,(%esp)
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	75 1a                	jne    8019d0 <__umoddi3+0x48>
  8019b6:	39 f7                	cmp    %esi,%edi
  8019b8:	0f 86 a2 00 00 00    	jbe    801a60 <__umoddi3+0xd8>
  8019be:	89 c8                	mov    %ecx,%eax
  8019c0:	89 f2                	mov    %esi,%edx
  8019c2:	f7 f7                	div    %edi
  8019c4:	89 d0                	mov    %edx,%eax
  8019c6:	31 d2                	xor    %edx,%edx
  8019c8:	83 c4 1c             	add    $0x1c,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
  8019d0:	39 f0                	cmp    %esi,%eax
  8019d2:	0f 87 ac 00 00 00    	ja     801a84 <__umoddi3+0xfc>
  8019d8:	0f bd e8             	bsr    %eax,%ebp
  8019db:	83 f5 1f             	xor    $0x1f,%ebp
  8019de:	0f 84 ac 00 00 00    	je     801a90 <__umoddi3+0x108>
  8019e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019e9:	29 ef                	sub    %ebp,%edi
  8019eb:	89 fe                	mov    %edi,%esi
  8019ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f1:	89 e9                	mov    %ebp,%ecx
  8019f3:	d3 e0                	shl    %cl,%eax
  8019f5:	89 d7                	mov    %edx,%edi
  8019f7:	89 f1                	mov    %esi,%ecx
  8019f9:	d3 ef                	shr    %cl,%edi
  8019fb:	09 c7                	or     %eax,%edi
  8019fd:	89 e9                	mov    %ebp,%ecx
  8019ff:	d3 e2                	shl    %cl,%edx
  801a01:	89 14 24             	mov    %edx,(%esp)
  801a04:	89 d8                	mov    %ebx,%eax
  801a06:	d3 e0                	shl    %cl,%eax
  801a08:	89 c2                	mov    %eax,%edx
  801a0a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a0e:	d3 e0                	shl    %cl,%eax
  801a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a14:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a18:	89 f1                	mov    %esi,%ecx
  801a1a:	d3 e8                	shr    %cl,%eax
  801a1c:	09 d0                	or     %edx,%eax
  801a1e:	d3 eb                	shr    %cl,%ebx
  801a20:	89 da                	mov    %ebx,%edx
  801a22:	f7 f7                	div    %edi
  801a24:	89 d3                	mov    %edx,%ebx
  801a26:	f7 24 24             	mull   (%esp)
  801a29:	89 c6                	mov    %eax,%esi
  801a2b:	89 d1                	mov    %edx,%ecx
  801a2d:	39 d3                	cmp    %edx,%ebx
  801a2f:	0f 82 87 00 00 00    	jb     801abc <__umoddi3+0x134>
  801a35:	0f 84 91 00 00 00    	je     801acc <__umoddi3+0x144>
  801a3b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a3f:	29 f2                	sub    %esi,%edx
  801a41:	19 cb                	sbb    %ecx,%ebx
  801a43:	89 d8                	mov    %ebx,%eax
  801a45:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a49:	d3 e0                	shl    %cl,%eax
  801a4b:	89 e9                	mov    %ebp,%ecx
  801a4d:	d3 ea                	shr    %cl,%edx
  801a4f:	09 d0                	or     %edx,%eax
  801a51:	89 e9                	mov    %ebp,%ecx
  801a53:	d3 eb                	shr    %cl,%ebx
  801a55:	89 da                	mov    %ebx,%edx
  801a57:	83 c4 1c             	add    $0x1c,%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5f                   	pop    %edi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    
  801a5f:	90                   	nop
  801a60:	89 fd                	mov    %edi,%ebp
  801a62:	85 ff                	test   %edi,%edi
  801a64:	75 0b                	jne    801a71 <__umoddi3+0xe9>
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6b:	31 d2                	xor    %edx,%edx
  801a6d:	f7 f7                	div    %edi
  801a6f:	89 c5                	mov    %eax,%ebp
  801a71:	89 f0                	mov    %esi,%eax
  801a73:	31 d2                	xor    %edx,%edx
  801a75:	f7 f5                	div    %ebp
  801a77:	89 c8                	mov    %ecx,%eax
  801a79:	f7 f5                	div    %ebp
  801a7b:	89 d0                	mov    %edx,%eax
  801a7d:	e9 44 ff ff ff       	jmp    8019c6 <__umoddi3+0x3e>
  801a82:	66 90                	xchg   %ax,%ax
  801a84:	89 c8                	mov    %ecx,%eax
  801a86:	89 f2                	mov    %esi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	3b 04 24             	cmp    (%esp),%eax
  801a93:	72 06                	jb     801a9b <__umoddi3+0x113>
  801a95:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a99:	77 0f                	ja     801aaa <__umoddi3+0x122>
  801a9b:	89 f2                	mov    %esi,%edx
  801a9d:	29 f9                	sub    %edi,%ecx
  801a9f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aa3:	89 14 24             	mov    %edx,(%esp)
  801aa6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aaa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801aae:	8b 14 24             	mov    (%esp),%edx
  801ab1:	83 c4 1c             	add    $0x1c,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	8d 76 00             	lea    0x0(%esi),%esi
  801abc:	2b 04 24             	sub    (%esp),%eax
  801abf:	19 fa                	sbb    %edi,%edx
  801ac1:	89 d1                	mov    %edx,%ecx
  801ac3:	89 c6                	mov    %eax,%esi
  801ac5:	e9 71 ff ff ff       	jmp    801a3b <__umoddi3+0xb3>
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ad0:	72 ea                	jb     801abc <__umoddi3+0x134>
  801ad2:	89 d9                	mov    %ebx,%ecx
  801ad4:	e9 62 ff ff ff       	jmp    801a3b <__umoddi3+0xb3>
