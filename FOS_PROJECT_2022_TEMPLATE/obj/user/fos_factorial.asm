
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 1b 80 00       	push   $0x801be0
  800057:	e8 12 0a 00 00       	call   800a6e <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 64 0e 00 00       	call   800ed6 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 f7 1b 80 00       	push   $0x801bf7
  800097:	e8 7f 02 00 00       	call   80031b <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000d1:	e8 74 15 00 00       	call   80164a <sys_getenvindex>
  8000d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000dc:	89 d0                	mov    %edx,%eax
  8000de:	01 c0                	add    %eax,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000e9:	01 c8                	add    %ecx,%eax
  8000eb:	c1 e0 02             	shl    $0x2,%eax
  8000ee:	01 d0                	add    %edx,%eax
  8000f0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000f7:	01 c8                	add    %ecx,%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	01 d0                	add    %edx,%eax
  8000fe:	c1 e0 02             	shl    $0x2,%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c1 e0 03             	shl    $0x3,%eax
  800106:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80011b:	84 c0                	test   %al,%al
  80011d:	74 0f                	je     80012e <libmain+0x63>
		binaryname = myEnv->prog_name;
  80011f:	a1 20 30 80 00       	mov    0x803020,%eax
  800124:	05 18 da 01 00       	add    $0x1da18,%eax
  800129:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800132:	7e 0a                	jle    80013e <libmain+0x73>
		binaryname = argv[0];
  800134:	8b 45 0c             	mov    0xc(%ebp),%eax
  800137:	8b 00                	mov    (%eax),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	e8 ec fe ff ff       	call   800038 <_main>
  80014c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80014f:	e8 03 13 00 00       	call   801457 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 24 1c 80 00       	push   $0x801c24
  80015c:	e8 8d 01 00 00       	call   8002ee <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800164:	a1 20 30 80 00       	mov    0x803020,%eax
  800169:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80016f:	a1 20 30 80 00       	mov    0x803020,%eax
  800174:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80017a:	83 ec 04             	sub    $0x4,%esp
  80017d:	52                   	push   %edx
  80017e:	50                   	push   %eax
  80017f:	68 4c 1c 80 00       	push   $0x801c4c
  800184:	e8 65 01 00 00       	call   8002ee <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800197:	a1 20 30 80 00       	mov    0x803020,%eax
  80019c:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8001a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a7:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8001ad:	51                   	push   %ecx
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	68 74 1c 80 00       	push   $0x801c74
  8001b5:	e8 34 01 00 00       	call   8002ee <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c2:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 cc 1c 80 00       	push   $0x801ccc
  8001d1:	e8 18 01 00 00       	call   8002ee <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	68 24 1c 80 00       	push   $0x801c24
  8001e1:	e8 08 01 00 00       	call   8002ee <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001e9:	e8 83 12 00 00       	call   801471 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001ee:	e8 19 00 00 00       	call   80020c <exit>
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	e8 10 14 00 00       	call   801616 <sys_destroy_env>
  800206:	83 c4 10             	add    $0x10,%esp
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <exit>:

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800212:	e8 65 14 00 00       	call   80167c <sys_exit_env>
}
  800217:	90                   	nop
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800220:	8b 45 0c             	mov    0xc(%ebp),%eax
  800223:	8b 00                	mov    (%eax),%eax
  800225:	8d 48 01             	lea    0x1(%eax),%ecx
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	89 0a                	mov    %ecx,(%edx)
  80022d:	8b 55 08             	mov    0x8(%ebp),%edx
  800230:	88 d1                	mov    %dl,%cl
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	8b 00                	mov    (%eax),%eax
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 2c                	jne    800271 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800245:	a0 24 30 80 00       	mov    0x803024,%al
  80024a:	0f b6 c0             	movzbl %al,%eax
  80024d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800250:	8b 12                	mov    (%edx),%edx
  800252:	89 d1                	mov    %edx,%ecx
  800254:	8b 55 0c             	mov    0xc(%ebp),%edx
  800257:	83 c2 08             	add    $0x8,%edx
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	50                   	push   %eax
  80025e:	51                   	push   %ecx
  80025f:	52                   	push   %edx
  800260:	e8 44 10 00 00       	call   8012a9 <sys_cputs>
  800265:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800271:	8b 45 0c             	mov    0xc(%ebp),%eax
  800274:	8b 40 04             	mov    0x4(%eax),%eax
  800277:	8d 50 01             	lea    0x1(%eax),%edx
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80028c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800293:	00 00 00 
	b.cnt = 0;
  800296:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a0:	ff 75 0c             	pushl  0xc(%ebp)
  8002a3:	ff 75 08             	pushl  0x8(%ebp)
  8002a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ac:	50                   	push   %eax
  8002ad:	68 1a 02 80 00       	push   $0x80021a
  8002b2:	e8 11 02 00 00       	call   8004c8 <vprintfmt>
  8002b7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002ba:	a0 24 30 80 00       	mov    0x803024,%al
  8002bf:	0f b6 c0             	movzbl %al,%eax
  8002c2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	50                   	push   %eax
  8002cc:	52                   	push   %edx
  8002cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d3:	83 c0 08             	add    $0x8,%eax
  8002d6:	50                   	push   %eax
  8002d7:	e8 cd 0f 00 00       	call   8012a9 <sys_cputs>
  8002dc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002df:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <cprintf>:

int cprintf(const char *fmt, ...) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f4:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 75 f4             	pushl  -0xc(%ebp)
  80030a:	50                   	push   %eax
  80030b:	e8 73 ff ff ff       	call   800283 <vcprintf>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800321:	e8 31 11 00 00       	call   801457 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800326:	8d 45 0c             	lea    0xc(%ebp),%eax
  800329:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 f4             	pushl  -0xc(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 48 ff ff ff       	call   800283 <vcprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800341:	e8 2b 11 00 00       	call   801471 <sys_enable_interrupt>
	return cnt;
  800346:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	53                   	push   %ebx
  80034f:	83 ec 14             	sub    $0x14,%esp
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035e:	8b 45 18             	mov    0x18(%ebp),%eax
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800369:	77 55                	ja     8003c0 <printnum+0x75>
  80036b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036e:	72 05                	jb     800375 <printnum+0x2a>
  800370:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800373:	77 4b                	ja     8003c0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800375:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800378:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037b:	8b 45 18             	mov    0x18(%ebp),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	ff 75 f4             	pushl  -0xc(%ebp)
  800388:	ff 75 f0             	pushl  -0x10(%ebp)
  80038b:	e8 ec 15 00 00       	call   80197c <__udivdi3>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	83 ec 04             	sub    $0x4,%esp
  800396:	ff 75 20             	pushl  0x20(%ebp)
  800399:	53                   	push   %ebx
  80039a:	ff 75 18             	pushl  0x18(%ebp)
  80039d:	52                   	push   %edx
  80039e:	50                   	push   %eax
  80039f:	ff 75 0c             	pushl  0xc(%ebp)
  8003a2:	ff 75 08             	pushl  0x8(%ebp)
  8003a5:	e8 a1 ff ff ff       	call   80034b <printnum>
  8003aa:	83 c4 20             	add    $0x20,%esp
  8003ad:	eb 1a                	jmp    8003c9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	ff 75 0c             	pushl  0xc(%ebp)
  8003b5:	ff 75 20             	pushl  0x20(%ebp)
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	ff d0                	call   *%eax
  8003bd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c0:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c7:	7f e6                	jg     8003af <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d7:	53                   	push   %ebx
  8003d8:	51                   	push   %ecx
  8003d9:	52                   	push   %edx
  8003da:	50                   	push   %eax
  8003db:	e8 ac 16 00 00       	call   801a8c <__umoddi3>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	05 f4 1e 80 00       	add    $0x801ef4,%eax
  8003e8:	8a 00                	mov    (%eax),%al
  8003ea:	0f be c0             	movsbl %al,%eax
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	ff 75 0c             	pushl  0xc(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	ff d0                	call   *%eax
  8003f9:	83 c4 10             	add    $0x10,%esp
}
  8003fc:	90                   	nop
  8003fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800405:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800409:	7e 1c                	jle    800427 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 50 08             	lea    0x8(%eax),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	89 10                	mov    %edx,(%eax)
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	83 e8 08             	sub    $0x8,%eax
  800420:	8b 50 04             	mov    0x4(%eax),%edx
  800423:	8b 00                	mov    (%eax),%eax
  800425:	eb 40                	jmp    800467 <getuint+0x65>
	else if (lflag)
  800427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042b:	74 1e                	je     80044b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 04             	lea    0x4(%eax),%edx
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	83 e8 04             	sub    $0x4,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	eb 1c                	jmp    800467 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	8d 50 04             	lea    0x4(%eax),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	89 10                	mov    %edx,(%eax)
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	83 e8 04             	sub    $0x4,%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800470:	7e 1c                	jle    80048e <getint+0x25>
		return va_arg(*ap, long long);
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	8d 50 08             	lea    0x8(%eax),%edx
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 10                	mov    %edx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	83 e8 08             	sub    $0x8,%eax
  800487:	8b 50 04             	mov    0x4(%eax),%edx
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	eb 38                	jmp    8004c6 <getint+0x5d>
	else if (lflag)
  80048e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800492:	74 1a                	je     8004ae <getint+0x45>
		return va_arg(*ap, long);
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	8d 50 04             	lea    0x4(%eax),%edx
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	89 10                	mov    %edx,(%eax)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	83 e8 04             	sub    $0x4,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	99                   	cltd   
  8004ac:	eb 18                	jmp    8004c6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	99                   	cltd   
}
  8004c6:	5d                   	pop    %ebp
  8004c7:	c3                   	ret    

008004c8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d0:	eb 17                	jmp    8004e9 <vprintfmt+0x21>
			if (ch == '\0')
  8004d2:	85 db                	test   %ebx,%ebx
  8004d4:	0f 84 af 03 00 00    	je     800889 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	53                   	push   %ebx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	ff d0                	call   *%eax
  8004e6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	8d 50 01             	lea    0x1(%eax),%edx
  8004ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f2:	8a 00                	mov    (%eax),%al
  8004f4:	0f b6 d8             	movzbl %al,%ebx
  8004f7:	83 fb 25             	cmp    $0x25,%ebx
  8004fa:	75 d6                	jne    8004d2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004fc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800500:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800507:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800515:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	8b 45 10             	mov    0x10(%ebp),%eax
  80051f:	8d 50 01             	lea    0x1(%eax),%edx
  800522:	89 55 10             	mov    %edx,0x10(%ebp)
  800525:	8a 00                	mov    (%eax),%al
  800527:	0f b6 d8             	movzbl %al,%ebx
  80052a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80052d:	83 f8 55             	cmp    $0x55,%eax
  800530:	0f 87 2b 03 00 00    	ja     800861 <vprintfmt+0x399>
  800536:	8b 04 85 18 1f 80 00 	mov    0x801f18(,%eax,4),%eax
  80053d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80053f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800543:	eb d7                	jmp    80051c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800545:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800549:	eb d1                	jmp    80051c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	89 d0                	mov    %edx,%eax
  800557:	c1 e0 02             	shl    $0x2,%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	01 c0                	add    %eax,%eax
  80055e:	01 d8                	add    %ebx,%eax
  800560:	83 e8 30             	sub    $0x30,%eax
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800566:	8b 45 10             	mov    0x10(%ebp),%eax
  800569:	8a 00                	mov    (%eax),%al
  80056b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80056e:	83 fb 2f             	cmp    $0x2f,%ebx
  800571:	7e 3e                	jle    8005b1 <vprintfmt+0xe9>
  800573:	83 fb 39             	cmp    $0x39,%ebx
  800576:	7f 39                	jg     8005b1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800578:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80057b:	eb d5                	jmp    800552 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	83 c0 04             	add    $0x4,%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	83 e8 04             	sub    $0x4,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800591:	eb 1f                	jmp    8005b2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800593:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800597:	79 83                	jns    80051c <vprintfmt+0x54>
				width = 0;
  800599:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a0:	e9 77 ff ff ff       	jmp    80051c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005ac:	e9 6b ff ff ff       	jmp    80051c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b6:	0f 89 60 ff ff ff    	jns    80051c <vprintfmt+0x54>
				width = precision, precision = -1;
  8005bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c9:	e9 4e ff ff ff       	jmp    80051c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d1:	e9 46 ff ff ff       	jmp    80051c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 c0 04             	add    $0x4,%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	83 e8 04             	sub    $0x4,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 0c             	pushl  0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	ff d0                	call   *%eax
  8005f3:	83 c4 10             	add    $0x10,%esp
			break;
  8005f6:	e9 89 02 00 00       	jmp    800884 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	83 c0 04             	add    $0x4,%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	83 e8 04             	sub    $0x4,%eax
  80060a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80060c:	85 db                	test   %ebx,%ebx
  80060e:	79 02                	jns    800612 <vprintfmt+0x14a>
				err = -err;
  800610:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800612:	83 fb 64             	cmp    $0x64,%ebx
  800615:	7f 0b                	jg     800622 <vprintfmt+0x15a>
  800617:	8b 34 9d 60 1d 80 00 	mov    0x801d60(,%ebx,4),%esi
  80061e:	85 f6                	test   %esi,%esi
  800620:	75 19                	jne    80063b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800622:	53                   	push   %ebx
  800623:	68 05 1f 80 00       	push   $0x801f05
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 08             	pushl  0x8(%ebp)
  80062e:	e8 5e 02 00 00       	call   800891 <printfmt>
  800633:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800636:	e9 49 02 00 00       	jmp    800884 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063b:	56                   	push   %esi
  80063c:	68 0e 1f 80 00       	push   $0x801f0e
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	ff 75 08             	pushl  0x8(%ebp)
  800647:	e8 45 02 00 00       	call   800891 <printfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
			break;
  80064f:	e9 30 02 00 00       	jmp    800884 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 c0 04             	add    $0x4,%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 30                	mov    (%eax),%esi
  800665:	85 f6                	test   %esi,%esi
  800667:	75 05                	jne    80066e <vprintfmt+0x1a6>
				p = "(null)";
  800669:	be 11 1f 80 00       	mov    $0x801f11,%esi
			if (width > 0 && padc != '-')
  80066e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800672:	7e 6d                	jle    8006e1 <vprintfmt+0x219>
  800674:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800678:	74 67                	je     8006e1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	56                   	push   %esi
  800682:	e8 12 05 00 00       	call   800b99 <strnlen>
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80068d:	eb 16                	jmp    8006a5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80068f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	50                   	push   %eax
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a9:	7f e4                	jg     80068f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ab:	eb 34                	jmp    8006e1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b1:	74 1c                	je     8006cf <vprintfmt+0x207>
  8006b3:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b6:	7e 05                	jle    8006bd <vprintfmt+0x1f5>
  8006b8:	83 fb 7e             	cmp    $0x7e,%ebx
  8006bb:	7e 12                	jle    8006cf <vprintfmt+0x207>
					putch('?', putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	6a 3f                	push   $0x3f
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	eb 0f                	jmp    8006de <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	53                   	push   %ebx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	ff d0                	call   *%eax
  8006db:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006de:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e1:	89 f0                	mov    %esi,%eax
  8006e3:	8d 70 01             	lea    0x1(%eax),%esi
  8006e6:	8a 00                	mov    (%eax),%al
  8006e8:	0f be d8             	movsbl %al,%ebx
  8006eb:	85 db                	test   %ebx,%ebx
  8006ed:	74 24                	je     800713 <vprintfmt+0x24b>
  8006ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f3:	78 b8                	js     8006ad <vprintfmt+0x1e5>
  8006f5:	ff 4d e0             	decl   -0x20(%ebp)
  8006f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fc:	79 af                	jns    8006ad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fe:	eb 13                	jmp    800713 <vprintfmt+0x24b>
				putch(' ', putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	6a 20                	push   $0x20
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800710:	ff 4d e4             	decl   -0x1c(%ebp)
  800713:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800717:	7f e7                	jg     800700 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800719:	e9 66 01 00 00       	jmp    800884 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 e8             	pushl  -0x18(%ebp)
  800724:	8d 45 14             	lea    0x14(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 3c fd ff ff       	call   800469 <getint>
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800733:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073c:	85 d2                	test   %edx,%edx
  80073e:	79 23                	jns    800763 <vprintfmt+0x29b>
				putch('-', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	6a 2d                	push   $0x2d
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800756:	f7 d8                	neg    %eax
  800758:	83 d2 00             	adc    $0x0,%edx
  80075b:	f7 da                	neg    %edx
  80075d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800760:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800763:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076a:	e9 bc 00 00 00       	jmp    80082b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 e8             	pushl  -0x18(%ebp)
  800775:	8d 45 14             	lea    0x14(%ebp),%eax
  800778:	50                   	push   %eax
  800779:	e8 84 fc ff ff       	call   800402 <getuint>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800784:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800787:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078e:	e9 98 00 00 00       	jmp    80082b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	6a 58                	push   $0x58
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 58                	push   $0x58
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 58                	push   $0x58
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
			break;
  8007c3:	e9 bc 00 00 00       	jmp    800884 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	6a 30                	push   $0x30
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	ff d0                	call   *%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	6a 78                	push   $0x78
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	ff d0                	call   *%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	83 c0 04             	add    $0x4,%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800803:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80080a:	eb 1f                	jmp    80082b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 e8             	pushl  -0x18(%ebp)
  800812:	8d 45 14             	lea    0x14(%ebp),%eax
  800815:	50                   	push   %eax
  800816:	e8 e7 fb ff ff       	call   800402 <getuint>
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800821:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800824:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80082f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	52                   	push   %edx
  800836:	ff 75 e4             	pushl  -0x1c(%ebp)
  800839:	50                   	push   %eax
  80083a:	ff 75 f4             	pushl  -0xc(%ebp)
  80083d:	ff 75 f0             	pushl  -0x10(%ebp)
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	e8 00 fb ff ff       	call   80034b <printnum>
  80084b:	83 c4 20             	add    $0x20,%esp
			break;
  80084e:	eb 34                	jmp    800884 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	53                   	push   %ebx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
			break;
  80085f:	eb 23                	jmp    800884 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	6a 25                	push   $0x25
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800871:	ff 4d 10             	decl   0x10(%ebp)
  800874:	eb 03                	jmp    800879 <vprintfmt+0x3b1>
  800876:	ff 4d 10             	decl   0x10(%ebp)
  800879:	8b 45 10             	mov    0x10(%ebp),%eax
  80087c:	48                   	dec    %eax
  80087d:	8a 00                	mov    (%eax),%al
  80087f:	3c 25                	cmp    $0x25,%al
  800881:	75 f3                	jne    800876 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800883:	90                   	nop
		}
	}
  800884:	e9 47 fc ff ff       	jmp    8004d0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800889:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80088a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800897:	8d 45 10             	lea    0x10(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	ff 75 08             	pushl  0x8(%ebp)
  8008ad:	e8 16 fc ff ff       	call   8004c8 <vprintfmt>
  8008b2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008b5:	90                   	nop
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8b 40 08             	mov    0x8(%eax),%eax
  8008c1:	8d 50 01             	lea    0x1(%eax),%edx
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	8b 10                	mov    (%eax),%edx
  8008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d2:	8b 40 04             	mov    0x4(%eax),%eax
  8008d5:	39 c2                	cmp    %eax,%edx
  8008d7:	73 12                	jae    8008eb <sprintputch+0x33>
		*b->buf++ = ch;
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e4:	89 0a                	mov    %ecx,(%edx)
  8008e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e9:	88 10                	mov    %dl,(%eax)
}
  8008eb:	90                   	nop
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800908:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800913:	74 06                	je     80091b <vsnprintf+0x2d>
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	7f 07                	jg     800922 <vsnprintf+0x34>
		return -E_INVAL;
  80091b:	b8 03 00 00 00       	mov    $0x3,%eax
  800920:	eb 20                	jmp    800942 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800922:	ff 75 14             	pushl  0x14(%ebp)
  800925:	ff 75 10             	pushl  0x10(%ebp)
  800928:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	68 b8 08 80 00       	push   $0x8008b8
  800931:	e8 92 fb ff ff       	call   8004c8 <vprintfmt>
  800936:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094a:	8d 45 10             	lea    0x10(%ebp),%eax
  80094d:	83 c0 04             	add    $0x4,%eax
  800950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	ff 75 f4             	pushl  -0xc(%ebp)
  800959:	50                   	push   %eax
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	ff 75 08             	pushl  0x8(%ebp)
  800960:	e8 89 ff ff ff       	call   8008ee <vsnprintf>
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097a:	74 13                	je     80098f <readline+0x1f>
		cprintf("%s", prompt);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 08             	pushl  0x8(%ebp)
  800982:	68 70 20 80 00       	push   $0x802070
  800987:	e8 62 f9 ff ff       	call   8002ee <cprintf>
  80098c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80098f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800996:	83 ec 0c             	sub    $0xc,%esp
  800999:	6a 00                	push   $0x0
  80099b:	e8 d2 0f 00 00       	call   801972 <iscons>
  8009a0:	83 c4 10             	add    $0x10,%esp
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009a6:	e8 79 0f 00 00       	call   801924 <getchar>
  8009ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b2:	79 22                	jns    8009d6 <readline+0x66>
			if (c != -E_EOF)
  8009b4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009b8:	0f 84 ad 00 00 00    	je     800a6b <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8009c4:	68 73 20 80 00       	push   $0x802073
  8009c9:	e8 20 f9 ff ff       	call   8002ee <cprintf>
  8009ce:	83 c4 10             	add    $0x10,%esp
			return;
  8009d1:	e9 95 00 00 00       	jmp    800a6b <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009d6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009da:	7e 34                	jle    800a10 <readline+0xa0>
  8009dc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009e3:	7f 2b                	jg     800a10 <readline+0xa0>
			if (echoing)
  8009e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009e9:	74 0e                	je     8009f9 <readline+0x89>
				cputchar(c);
  8009eb:	83 ec 0c             	sub    $0xc,%esp
  8009ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8009f1:	e8 e6 0e 00 00       	call   8018dc <cputchar>
  8009f6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	01 d0                	add    %edx,%eax
  800a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a0c:	88 10                	mov    %dl,(%eax)
  800a0e:	eb 56                	jmp    800a66 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a10:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a14:	75 1f                	jne    800a35 <readline+0xc5>
  800a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a1a:	7e 19                	jle    800a35 <readline+0xc5>
			if (echoing)
  800a1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a20:	74 0e                	je     800a30 <readline+0xc0>
				cputchar(c);
  800a22:	83 ec 0c             	sub    $0xc,%esp
  800a25:	ff 75 ec             	pushl  -0x14(%ebp)
  800a28:	e8 af 0e 00 00       	call   8018dc <cputchar>
  800a2d:	83 c4 10             	add    $0x10,%esp

			i--;
  800a30:	ff 4d f4             	decl   -0xc(%ebp)
  800a33:	eb 31                	jmp    800a66 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a35:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a39:	74 0a                	je     800a45 <readline+0xd5>
  800a3b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a3f:	0f 85 61 ff ff ff    	jne    8009a6 <readline+0x36>
			if (echoing)
  800a45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a49:	74 0e                	je     800a59 <readline+0xe9>
				cputchar(c);
  800a4b:	83 ec 0c             	sub    $0xc,%esp
  800a4e:	ff 75 ec             	pushl  -0x14(%ebp)
  800a51:	e8 86 0e 00 00       	call   8018dc <cputchar>
  800a56:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	01 d0                	add    %edx,%eax
  800a61:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a64:	eb 06                	jmp    800a6c <readline+0xfc>
		}
	}
  800a66:	e9 3b ff ff ff       	jmp    8009a6 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a6b:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a74:	e8 de 09 00 00       	call   801457 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7d:	74 13                	je     800a92 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 08             	pushl  0x8(%ebp)
  800a85:	68 70 20 80 00       	push   $0x802070
  800a8a:	e8 5f f8 ff ff       	call   8002ee <cprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a99:	83 ec 0c             	sub    $0xc,%esp
  800a9c:	6a 00                	push   $0x0
  800a9e:	e8 cf 0e 00 00       	call   801972 <iscons>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa9:	e8 76 0e 00 00       	call   801924 <getchar>
  800aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab5:	79 23                	jns    800ada <atomic_readline+0x6c>
			if (c != -E_EOF)
  800ab7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800abb:	74 13                	je     800ad0 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac3:	68 73 20 80 00       	push   $0x802073
  800ac8:	e8 21 f8 ff ff       	call   8002ee <cprintf>
  800acd:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ad0:	e8 9c 09 00 00       	call   801471 <sys_enable_interrupt>
			return;
  800ad5:	e9 9a 00 00 00       	jmp    800b74 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ada:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ade:	7e 34                	jle    800b14 <atomic_readline+0xa6>
  800ae0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ae7:	7f 2b                	jg     800b14 <atomic_readline+0xa6>
			if (echoing)
  800ae9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aed:	74 0e                	je     800afd <atomic_readline+0x8f>
				cputchar(c);
  800aef:	83 ec 0c             	sub    $0xc,%esp
  800af2:	ff 75 ec             	pushl  -0x14(%ebp)
  800af5:	e8 e2 0d 00 00       	call   8018dc <cputchar>
  800afa:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	01 d0                	add    %edx,%eax
  800b0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b10:	88 10                	mov    %dl,(%eax)
  800b12:	eb 5b                	jmp    800b6f <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b14:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b18:	75 1f                	jne    800b39 <atomic_readline+0xcb>
  800b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b1e:	7e 19                	jle    800b39 <atomic_readline+0xcb>
			if (echoing)
  800b20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b24:	74 0e                	je     800b34 <atomic_readline+0xc6>
				cputchar(c);
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2c:	e8 ab 0d 00 00       	call   8018dc <cputchar>
  800b31:	83 c4 10             	add    $0x10,%esp
			i--;
  800b34:	ff 4d f4             	decl   -0xc(%ebp)
  800b37:	eb 36                	jmp    800b6f <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b39:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b3d:	74 0a                	je     800b49 <atomic_readline+0xdb>
  800b3f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b43:	0f 85 60 ff ff ff    	jne    800aa9 <atomic_readline+0x3b>
			if (echoing)
  800b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4d:	74 0e                	je     800b5d <atomic_readline+0xef>
				cputchar(c);
  800b4f:	83 ec 0c             	sub    $0xc,%esp
  800b52:	ff 75 ec             	pushl  -0x14(%ebp)
  800b55:	e8 82 0d 00 00       	call   8018dc <cputchar>
  800b5a:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	01 d0                	add    %edx,%eax
  800b65:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b68:	e8 04 09 00 00       	call   801471 <sys_enable_interrupt>
			return;
  800b6d:	eb 05                	jmp    800b74 <atomic_readline+0x106>
		}
	}
  800b6f:	e9 35 ff ff ff       	jmp    800aa9 <atomic_readline+0x3b>
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b83:	eb 06                	jmp    800b8b <strlen+0x15>
		n++;
  800b85:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b88:	ff 45 08             	incl   0x8(%ebp)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	84 c0                	test   %al,%al
  800b92:	75 f1                	jne    800b85 <strlen+0xf>
		n++;
	return n;
  800b94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba6:	eb 09                	jmp    800bb1 <strnlen+0x18>
		n++;
  800ba8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bab:	ff 45 08             	incl   0x8(%ebp)
  800bae:	ff 4d 0c             	decl   0xc(%ebp)
  800bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb5:	74 09                	je     800bc0 <strnlen+0x27>
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	84 c0                	test   %al,%al
  800bbe:	75 e8                	jne    800ba8 <strnlen+0xf>
		n++;
	return n;
  800bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bd1:	90                   	nop
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8d 50 01             	lea    0x1(%eax),%edx
  800bd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bde:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be4:	8a 12                	mov    (%edx),%dl
  800be6:	88 10                	mov    %dl,(%eax)
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	84 c0                	test   %al,%al
  800bec:	75 e4                	jne    800bd2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c06:	eb 1f                	jmp    800c27 <strncpy+0x34>
		*dst++ = *src;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	8a 12                	mov    (%edx),%dl
  800c16:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	74 03                	je     800c24 <strncpy+0x31>
			src++;
  800c21:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c24:	ff 45 fc             	incl   -0x4(%ebp)
  800c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c2d:	72 d9                	jb     800c08 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c44:	74 30                	je     800c76 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c46:	eb 16                	jmp    800c5e <strlcpy+0x2a>
			*dst++ = *src++;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c5e:	ff 4d 10             	decl   0x10(%ebp)
  800c61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c65:	74 09                	je     800c70 <strlcpy+0x3c>
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	75 d8                	jne    800c48 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7c:	29 c2                	sub    %eax,%edx
  800c7e:	89 d0                	mov    %edx,%eax
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c85:	eb 06                	jmp    800c8d <strcmp+0xb>
		p++, q++;
  800c87:	ff 45 08             	incl   0x8(%ebp)
  800c8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	74 0e                	je     800ca4 <strcmp+0x22>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 10                	mov    (%eax),%dl
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	38 c2                	cmp    %al,%dl
  800ca2:	74 e3                	je     800c87 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d0             	movzbl %al,%edx
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f b6 c0             	movzbl %al,%eax
  800cb4:	29 c2                	sub    %eax,%edx
  800cb6:	89 d0                	mov    %edx,%eax
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cbd:	eb 09                	jmp    800cc8 <strncmp+0xe>
		n--, p++, q++;
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	ff 45 08             	incl   0x8(%ebp)
  800cc5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	74 17                	je     800ce5 <strncmp+0x2b>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	84 c0                	test   %al,%al
  800cd5:	74 0e                	je     800ce5 <strncmp+0x2b>
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 10                	mov    (%eax),%dl
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	38 c2                	cmp    %al,%dl
  800ce3:	74 da                	je     800cbf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ce5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce9:	75 07                	jne    800cf2 <strncmp+0x38>
		return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf0:	eb 14                	jmp    800d06 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	0f b6 d0             	movzbl %al,%edx
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	0f b6 c0             	movzbl %al,%eax
  800d02:	29 c2                	sub    %eax,%edx
  800d04:	89 d0                	mov    %edx,%eax
}
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 04             	sub    $0x4,%esp
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d14:	eb 12                	jmp    800d28 <strchr+0x20>
		if (*s == c)
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d1e:	75 05                	jne    800d25 <strchr+0x1d>
			return (char *) s;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	eb 11                	jmp    800d36 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d25:	ff 45 08             	incl   0x8(%ebp)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	75 e5                	jne    800d16 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 04             	sub    $0x4,%esp
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d44:	eb 0d                	jmp    800d53 <strfind+0x1b>
		if (*s == c)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4e:	74 0e                	je     800d5e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 ea                	jne    800d46 <strfind+0xe>
  800d5c:	eb 01                	jmp    800d5f <strfind+0x27>
		if (*s == c)
			break;
  800d5e:	90                   	nop
	return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d76:	eb 0e                	jmp    800d86 <memset+0x22>
		*p++ = c;
  800d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7b:	8d 50 01             	lea    0x1(%eax),%edx
  800d7e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d84:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d86:	ff 4d f8             	decl   -0x8(%ebp)
  800d89:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d8d:	79 e9                	jns    800d78 <memset+0x14>
		*p++ = c;

	return v;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800da6:	eb 16                	jmp    800dbe <memcpy+0x2a>
		*d++ = *s++;
  800da8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dab:	8d 50 01             	lea    0x1(%eax),%edx
  800dae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dba:	8a 12                	mov    (%edx),%dl
  800dbc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	75 dd                	jne    800da8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de8:	73 50                	jae    800e3a <memmove+0x6a>
  800dea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	01 d0                	add    %edx,%eax
  800df2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df5:	76 43                	jbe    800e3a <memmove+0x6a>
		s += n;
  800df7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e03:	eb 10                	jmp    800e15 <memmove+0x45>
			*--d = *--s;
  800e05:	ff 4d f8             	decl   -0x8(%ebp)
  800e08:	ff 4d fc             	decl   -0x4(%ebp)
  800e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0e:	8a 10                	mov    (%eax),%dl
  800e10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e13:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	75 e3                	jne    800e05 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e22:	eb 23                	jmp    800e47 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e27:	8d 50 01             	lea    0x1(%eax),%edx
  800e2a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e33:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e36:	8a 12                	mov    (%edx),%dl
  800e38:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e40:	89 55 10             	mov    %edx,0x10(%ebp)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	75 dd                	jne    800e24 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e5e:	eb 2a                	jmp    800e8a <memcmp+0x3e>
		if (*s1 != *s2)
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	8a 10                	mov    (%eax),%dl
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	38 c2                	cmp    %al,%dl
  800e6c:	74 16                	je     800e84 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 d0             	movzbl %al,%edx
  800e76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 c0             	movzbl %al,%eax
  800e7e:	29 c2                	sub    %eax,%edx
  800e80:	89 d0                	mov    %edx,%eax
  800e82:	eb 18                	jmp    800e9c <memcmp+0x50>
		s1++, s2++;
  800e84:	ff 45 fc             	incl   -0x4(%ebp)
  800e87:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 c9                	jne    800e60 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	01 d0                	add    %edx,%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eaf:	eb 15                	jmp    800ec6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	0f b6 d0             	movzbl %al,%edx
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	0f b6 c0             	movzbl %al,%eax
  800ebf:	39 c2                	cmp    %eax,%edx
  800ec1:	74 0d                	je     800ed0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ecc:	72 e3                	jb     800eb1 <memfind+0x13>
  800ece:	eb 01                	jmp    800ed1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ed0:	90                   	nop
	return (void *) s;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800edc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eea:	eb 03                	jmp    800eef <strtol+0x19>
		s++;
  800eec:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 20                	cmp    $0x20,%al
  800ef6:	74 f4                	je     800eec <strtol+0x16>
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 09                	cmp    $0x9,%al
  800eff:	74 eb                	je     800eec <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 2b                	cmp    $0x2b,%al
  800f08:	75 05                	jne    800f0f <strtol+0x39>
		s++;
  800f0a:	ff 45 08             	incl   0x8(%ebp)
  800f0d:	eb 13                	jmp    800f22 <strtol+0x4c>
	else if (*s == '-')
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 2d                	cmp    $0x2d,%al
  800f16:	75 0a                	jne    800f22 <strtol+0x4c>
		s++, neg = 1;
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f26:	74 06                	je     800f2e <strtol+0x58>
  800f28:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f2c:	75 20                	jne    800f4e <strtol+0x78>
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 30                	cmp    $0x30,%al
  800f35:	75 17                	jne    800f4e <strtol+0x78>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	40                   	inc    %eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 78                	cmp    $0x78,%al
  800f3f:	75 0d                	jne    800f4e <strtol+0x78>
		s += 2, base = 16;
  800f41:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f45:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f4c:	eb 28                	jmp    800f76 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f52:	75 15                	jne    800f69 <strtol+0x93>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	3c 30                	cmp    $0x30,%al
  800f5b:	75 0c                	jne    800f69 <strtol+0x93>
		s++, base = 8;
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f67:	eb 0d                	jmp    800f76 <strtol+0xa0>
	else if (base == 0)
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 07                	jne    800f76 <strtol+0xa0>
		base = 10;
  800f6f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 2f                	cmp    $0x2f,%al
  800f7d:	7e 19                	jle    800f98 <strtol+0xc2>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 39                	cmp    $0x39,%al
  800f86:	7f 10                	jg     800f98 <strtol+0xc2>
			dig = *s - '0';
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f be c0             	movsbl %al,%eax
  800f90:	83 e8 30             	sub    $0x30,%eax
  800f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f96:	eb 42                	jmp    800fda <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 60                	cmp    $0x60,%al
  800f9f:	7e 19                	jle    800fba <strtol+0xe4>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 7a                	cmp    $0x7a,%al
  800fa8:	7f 10                	jg     800fba <strtol+0xe4>
			dig = *s - 'a' + 10;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be c0             	movsbl %al,%eax
  800fb2:	83 e8 57             	sub    $0x57,%eax
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb8:	eb 20                	jmp    800fda <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	3c 40                	cmp    $0x40,%al
  800fc1:	7e 39                	jle    800ffc <strtol+0x126>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 5a                	cmp    $0x5a,%al
  800fca:	7f 30                	jg     800ffc <strtol+0x126>
			dig = *s - 'A' + 10;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	0f be c0             	movsbl %al,%eax
  800fd4:	83 e8 37             	sub    $0x37,%eax
  800fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe0:	7d 19                	jge    800ffb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fec:	89 c2                	mov    %eax,%edx
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	01 d0                	add    %edx,%eax
  800ff3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff6:	e9 7b ff ff ff       	jmp    800f76 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ffb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ffc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801000:	74 08                	je     80100a <strtol+0x134>
		*endptr = (char *) s;
  801002:	8b 45 0c             	mov    0xc(%ebp),%eax
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80100a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100e:	74 07                	je     801017 <strtol+0x141>
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	f7 d8                	neg    %eax
  801015:	eb 03                	jmp    80101a <strtol+0x144>
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <ltostr>:

void
ltostr(long value, char *str)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801029:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801030:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801034:	79 13                	jns    801049 <ltostr+0x2d>
	{
		neg = 1;
  801036:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801043:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801046:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801051:	99                   	cltd   
  801052:	f7 f9                	idiv   %ecx
  801054:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801060:	89 c2                	mov    %eax,%edx
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80106a:	83 c2 30             	add    $0x30,%edx
  80106d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80106f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801072:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801077:	f7 e9                	imul   %ecx
  801079:	c1 fa 02             	sar    $0x2,%edx
  80107c:	89 c8                	mov    %ecx,%eax
  80107e:	c1 f8 1f             	sar    $0x1f,%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801088:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801090:	f7 e9                	imul   %ecx
  801092:	c1 fa 02             	sar    $0x2,%edx
  801095:	89 c8                	mov    %ecx,%eax
  801097:	c1 f8 1f             	sar    $0x1f,%eax
  80109a:	29 c2                	sub    %eax,%edx
  80109c:	89 d0                	mov    %edx,%eax
  80109e:	c1 e0 02             	shl    $0x2,%eax
  8010a1:	01 d0                	add    %edx,%eax
  8010a3:	01 c0                	add    %eax,%eax
  8010a5:	29 c1                	sub    %eax,%ecx
  8010a7:	89 ca                	mov    %ecx,%edx
  8010a9:	85 d2                	test   %edx,%edx
  8010ab:	75 9c                	jne    801049 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	48                   	dec    %eax
  8010b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010bf:	74 3d                	je     8010fe <ltostr+0xe2>
		start = 1 ;
  8010c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c8:	eb 34                	jmp    8010fe <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	01 c2                	add    %eax,%edx
  8010df:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	01 c8                	add    %ecx,%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c2                	add    %eax,%edx
  8010f3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f6:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010fb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801101:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801104:	7c c4                	jl     8010ca <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801106:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 d0                	add    %edx,%eax
  80110e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801111:	90                   	nop
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80111a:	ff 75 08             	pushl  0x8(%ebp)
  80111d:	e8 54 fa ff ff       	call   800b76 <strlen>
  801122:	83 c4 04             	add    $0x4,%esp
  801125:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	e8 46 fa ff ff       	call   800b76 <strlen>
  801130:	83 c4 04             	add    $0x4,%esp
  801133:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80113d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801144:	eb 17                	jmp    80115d <strcconcat+0x49>
		final[s] = str1[s] ;
  801146:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	01 c2                	add    %eax,%edx
  80114e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	01 c8                	add    %ecx,%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80115a:	ff 45 fc             	incl   -0x4(%ebp)
  80115d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801160:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801163:	7c e1                	jl     801146 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801165:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801173:	eb 1f                	jmp    801194 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801175:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801178:	8d 50 01             	lea    0x1(%eax),%edx
  80117b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117e:	89 c2                	mov    %eax,%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
  801194:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801197:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119a:	7c d9                	jl     801175 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	01 d0                	add    %edx,%eax
  8011a4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a7:	90                   	nop
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b9:	8b 00                	mov    (%eax),%eax
  8011bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011cd:	eb 0c                	jmp    8011db <strsplit+0x31>
			*string++ = 0;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8d 50 01             	lea    0x1(%eax),%edx
  8011d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 18                	je     8011fc <strsplit+0x52>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	0f be c0             	movsbl %al,%eax
  8011ec:	50                   	push   %eax
  8011ed:	ff 75 0c             	pushl  0xc(%ebp)
  8011f0:	e8 13 fb ff ff       	call   800d08 <strchr>
  8011f5:	83 c4 08             	add    $0x8,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	75 d3                	jne    8011cf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	84 c0                	test   %al,%al
  801203:	74 5a                	je     80125f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	83 f8 0f             	cmp    $0xf,%eax
  80120d:	75 07                	jne    801216 <strsplit+0x6c>
		{
			return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
  801214:	eb 66                	jmp    80127c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801216:	8b 45 14             	mov    0x14(%ebp),%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	8d 48 01             	lea    0x1(%eax),%ecx
  80121e:	8b 55 14             	mov    0x14(%ebp),%edx
  801221:	89 0a                	mov    %ecx,(%edx)
  801223:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122a:	8b 45 10             	mov    0x10(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801234:	eb 03                	jmp    801239 <strsplit+0x8f>
			string++;
  801236:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	84 c0                	test   %al,%al
  801240:	74 8b                	je     8011cd <strsplit+0x23>
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	0f be c0             	movsbl %al,%eax
  80124a:	50                   	push   %eax
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	e8 b5 fa ff ff       	call   800d08 <strchr>
  801253:	83 c4 08             	add    $0x8,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	74 dc                	je     801236 <strsplit+0x8c>
			string++;
	}
  80125a:	e9 6e ff ff ff       	jmp    8011cd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801260:	8b 45 14             	mov    0x14(%ebp),%eax
  801263:	8b 00                	mov    (%eax),%eax
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801277:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	57                   	push   %edi
  801282:	56                   	push   %esi
  801283:	53                   	push   %ebx
  801284:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801290:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801293:	8b 7d 18             	mov    0x18(%ebp),%edi
  801296:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801299:	cd 30                	int    $0x30
  80129b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80129e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5f                   	pop    %edi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    

008012a9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	52                   	push   %edx
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	50                   	push   %eax
  8012c5:	6a 00                	push   $0x0
  8012c7:	e8 b2 ff ff ff       	call   80127e <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	90                   	nop
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 01                	push   $0x1
  8012e1:	e8 98 ff ff ff       	call   80127e <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 05                	push   $0x5
  8012fe:	e8 7b ff ff ff       	call   80127e <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80130d:	8b 75 18             	mov    0x18(%ebp),%esi
  801310:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801313:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801316:	8b 55 0c             	mov    0xc(%ebp),%edx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	56                   	push   %esi
  80131d:	53                   	push   %ebx
  80131e:	51                   	push   %ecx
  80131f:	52                   	push   %edx
  801320:	50                   	push   %eax
  801321:	6a 06                	push   $0x6
  801323:	e8 56 ff ff ff       	call   80127e <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5e                   	pop    %esi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	52                   	push   %edx
  801342:	50                   	push   %eax
  801343:	6a 07                	push   $0x7
  801345:	e8 34 ff ff ff       	call   80127e <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	6a 08                	push   $0x8
  801360:	e8 19 ff ff ff       	call   80127e <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 09                	push   $0x9
  801379:	e8 00 ff ff ff       	call   80127e <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 0a                	push   $0xa
  801392:	e8 e7 fe ff ff       	call   80127e <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 0b                	push   $0xb
  8013ab:	e8 ce fe ff ff       	call   80127e <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	6a 0f                	push   $0xf
  8013c6:	e8 b3 fe ff ff       	call   80127e <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
	return;
  8013ce:	90                   	nop
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	6a 10                	push   $0x10
  8013e2:	e8 97 fe ff ff       	call   80127e <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ea:	90                   	nop
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	ff 75 10             	pushl  0x10(%ebp)
  8013f7:	ff 75 0c             	pushl  0xc(%ebp)
  8013fa:	ff 75 08             	pushl  0x8(%ebp)
  8013fd:	6a 11                	push   $0x11
  8013ff:	e8 7a fe ff ff       	call   80127e <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
	return ;
  801407:	90                   	nop
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 0c                	push   $0xc
  801419:	e8 60 fe ff ff       	call   80127e <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	ff 75 08             	pushl  0x8(%ebp)
  801431:	6a 0d                	push   $0xd
  801433:	e8 46 fe ff ff       	call   80127e <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 0e                	push   $0xe
  80144c:	e8 2d fe ff ff       	call   80127e <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 13                	push   $0x13
  801466:	e8 13 fe ff ff       	call   80127e <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 14                	push   $0x14
  801480:	e8 f9 fd ff ff       	call   80127e <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	90                   	nop
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_cputc>:


void
sys_cputc(const char c)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801497:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	50                   	push   %eax
  8014a4:	6a 15                	push   $0x15
  8014a6:	e8 d3 fd ff ff       	call   80127e <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 16                	push   $0x16
  8014c0:	e8 b9 fd ff ff       	call   80127e <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	50                   	push   %eax
  8014db:	6a 17                	push   $0x17
  8014dd:	e8 9c fd ff ff       	call   80127e <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 1a                	push   $0x1a
  8014fa:	e8 7f fd ff ff       	call   80127e <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	6a 18                	push   $0x18
  801517:	e8 62 fd ff ff       	call   80127e <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	90                   	nop
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	52                   	push   %edx
  801532:	50                   	push   %eax
  801533:	6a 19                	push   $0x19
  801535:	e8 44 fd ff ff       	call   80127e <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 04             	sub    $0x4,%esp
  801546:	8b 45 10             	mov    0x10(%ebp),%eax
  801549:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80154c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80154f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	51                   	push   %ecx
  801559:	52                   	push   %edx
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	50                   	push   %eax
  80155e:	6a 1b                	push   $0x1b
  801560:	e8 19 fd ff ff       	call   80127e <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	52                   	push   %edx
  80157a:	50                   	push   %eax
  80157b:	6a 1c                	push   $0x1c
  80157d:	e8 fc fc ff ff       	call   80127e <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80158a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	51                   	push   %ecx
  801598:	52                   	push   %edx
  801599:	50                   	push   %eax
  80159a:	6a 1d                	push   $0x1d
  80159c:	e8 dd fc ff ff       	call   80127e <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	52                   	push   %edx
  8015b6:	50                   	push   %eax
  8015b7:	6a 1e                	push   $0x1e
  8015b9:	e8 c0 fc ff ff       	call   80127e <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 1f                	push   $0x1f
  8015d2:	e8 a7 fc ff ff       	call   80127e <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	ff 75 14             	pushl  0x14(%ebp)
  8015e7:	ff 75 10             	pushl  0x10(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	50                   	push   %eax
  8015ee:	6a 20                	push   $0x20
  8015f0:	e8 89 fc ff ff       	call   80127e <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	50                   	push   %eax
  801609:	6a 21                	push   $0x21
  80160b:	e8 6e fc ff ff       	call   80127e <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	50                   	push   %eax
  801625:	6a 22                	push   $0x22
  801627:	e8 52 fc ff ff       	call   80127e <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 02                	push   $0x2
  801640:	e8 39 fc ff ff       	call   80127e <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 03                	push   $0x3
  801659:	e8 20 fc ff ff       	call   80127e <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 04                	push   $0x4
  801672:	e8 07 fc ff ff       	call   80127e <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_exit_env>:


void sys_exit_env(void)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 23                	push   $0x23
  80168b:	e8 ee fb ff ff       	call   80127e <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	90                   	nop
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80169c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169f:	8d 50 04             	lea    0x4(%eax),%edx
  8016a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	6a 24                	push   $0x24
  8016af:	e8 ca fb ff ff       	call   80127e <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8016b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c0:	89 01                	mov    %eax,(%ecx)
  8016c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	c9                   	leave  
  8016c9:	c2 04 00             	ret    $0x4

008016cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	ff 75 10             	pushl  0x10(%ebp)
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	ff 75 08             	pushl  0x8(%ebp)
  8016dc:	6a 12                	push   $0x12
  8016de:	e8 9b fb ff ff       	call   80127e <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e6:	90                   	nop
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 25                	push   $0x25
  8016f8:	e8 81 fb ff ff       	call   80127e <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80170e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	50                   	push   %eax
  80171b:	6a 26                	push   $0x26
  80171d:	e8 5c fb ff ff       	call   80127e <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
	return ;
  801725:	90                   	nop
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <rsttst>:
void rsttst()
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 28                	push   $0x28
  801737:	e8 42 fb ff ff       	call   80127e <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
	return ;
  80173f:	90                   	nop
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	8b 45 14             	mov    0x14(%ebp),%eax
  80174b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80174e:	8b 55 18             	mov    0x18(%ebp),%edx
  801751:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801755:	52                   	push   %edx
  801756:	50                   	push   %eax
  801757:	ff 75 10             	pushl  0x10(%ebp)
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	ff 75 08             	pushl  0x8(%ebp)
  801760:	6a 27                	push   $0x27
  801762:	e8 17 fb ff ff       	call   80127e <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
	return ;
  80176a:	90                   	nop
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <chktst>:
void chktst(uint32 n)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	6a 29                	push   $0x29
  80177d:	e8 fc fa ff ff       	call   80127e <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return ;
  801785:	90                   	nop
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <inctst>:

void inctst()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 2a                	push   $0x2a
  801797:	e8 e2 fa ff ff       	call   80127e <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
	return ;
  80179f:	90                   	nop
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <gettst>:
uint32 gettst()
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 2b                	push   $0x2b
  8017b1:	e8 c8 fa ff ff       	call   80127e <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 2c                	push   $0x2c
  8017cd:	e8 ac fa ff ff       	call   80127e <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
  8017d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017d8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017dc:	75 07                	jne    8017e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017de:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e3:	eb 05                	jmp    8017ea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 2c                	push   $0x2c
  8017fe:	e8 7b fa ff ff       	call   80127e <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
  801806:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801809:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80180d:	75 07                	jne    801816 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80180f:	b8 01 00 00 00       	mov    $0x1,%eax
  801814:	eb 05                	jmp    80181b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 2c                	push   $0x2c
  80182f:	e8 4a fa ff ff       	call   80127e <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
  801837:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80183a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80183e:	75 07                	jne    801847 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801840:	b8 01 00 00 00       	mov    $0x1,%eax
  801845:	eb 05                	jmp    80184c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 2c                	push   $0x2c
  801860:	e8 19 fa ff ff       	call   80127e <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
  801868:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80186b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80186f:	75 07                	jne    801878 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801871:	b8 01 00 00 00       	mov    $0x1,%eax
  801876:	eb 05                	jmp    80187d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 2d                	push   $0x2d
  80188f:	e8 ea f9 ff ff       	call   80127e <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
	return ;
  801897:	90                   	nop
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80189e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	53                   	push   %ebx
  8018ad:	51                   	push   %ecx
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	6a 2e                	push   $0x2e
  8018b2:	e8 c7 f9 ff ff       	call   80127e <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	6a 2f                	push   $0x2f
  8018d2:	e8 a7 f9 ff ff       	call   80127e <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	50                   	push   %eax
  8018f0:	e8 96 fb ff ff       	call   80148b <sys_cputc>
  8018f5:	83 c4 10             	add    $0x10,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801901:	e8 51 fb ff ff       	call   801457 <sys_disable_interrupt>
	char c = ch;
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80190c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801910:	83 ec 0c             	sub    $0xc,%esp
  801913:	50                   	push   %eax
  801914:	e8 72 fb ff ff       	call   80148b <sys_cputc>
  801919:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80191c:	e8 50 fb ff ff       	call   801471 <sys_enable_interrupt>
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <getchar>:

int
getchar(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80192a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801931:	eb 08                	jmp    80193b <getchar+0x17>
	{
		c = sys_cgetc();
  801933:	e8 9a f9 ff ff       	call   8012d2 <sys_cgetc>
  801938:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80193b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80193f:	74 f2                	je     801933 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <atomic_getchar>:

int
atomic_getchar(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80194c:	e8 06 fb ff ff       	call   801457 <sys_disable_interrupt>
	int c=0;
  801951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801958:	eb 08                	jmp    801962 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80195a:	e8 73 f9 ff ff       	call   8012d2 <sys_cgetc>
  80195f:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801962:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801966:	74 f2                	je     80195a <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801968:	e8 04 fb ff ff       	call   801471 <sys_enable_interrupt>
	return c;
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <iscons>:

int iscons(int fdnum)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801975:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <__udivdi3>:
  80197c:	55                   	push   %ebp
  80197d:	57                   	push   %edi
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
  801980:	83 ec 1c             	sub    $0x1c,%esp
  801983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80198b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801993:	89 ca                	mov    %ecx,%edx
  801995:	89 f8                	mov    %edi,%eax
  801997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80199b:	85 f6                	test   %esi,%esi
  80199d:	75 2d                	jne    8019cc <__udivdi3+0x50>
  80199f:	39 cf                	cmp    %ecx,%edi
  8019a1:	77 65                	ja     801a08 <__udivdi3+0x8c>
  8019a3:	89 fd                	mov    %edi,%ebp
  8019a5:	85 ff                	test   %edi,%edi
  8019a7:	75 0b                	jne    8019b4 <__udivdi3+0x38>
  8019a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ae:	31 d2                	xor    %edx,%edx
  8019b0:	f7 f7                	div    %edi
  8019b2:	89 c5                	mov    %eax,%ebp
  8019b4:	31 d2                	xor    %edx,%edx
  8019b6:	89 c8                	mov    %ecx,%eax
  8019b8:	f7 f5                	div    %ebp
  8019ba:	89 c1                	mov    %eax,%ecx
  8019bc:	89 d8                	mov    %ebx,%eax
  8019be:	f7 f5                	div    %ebp
  8019c0:	89 cf                	mov    %ecx,%edi
  8019c2:	89 fa                	mov    %edi,%edx
  8019c4:	83 c4 1c             	add    $0x1c,%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5f                   	pop    %edi
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    
  8019cc:	39 ce                	cmp    %ecx,%esi
  8019ce:	77 28                	ja     8019f8 <__udivdi3+0x7c>
  8019d0:	0f bd fe             	bsr    %esi,%edi
  8019d3:	83 f7 1f             	xor    $0x1f,%edi
  8019d6:	75 40                	jne    801a18 <__udivdi3+0x9c>
  8019d8:	39 ce                	cmp    %ecx,%esi
  8019da:	72 0a                	jb     8019e6 <__udivdi3+0x6a>
  8019dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019e0:	0f 87 9e 00 00 00    	ja     801a84 <__udivdi3+0x108>
  8019e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019eb:	89 fa                	mov    %edi,%edx
  8019ed:	83 c4 1c             	add    $0x1c,%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5f                   	pop    %edi
  8019f3:	5d                   	pop    %ebp
  8019f4:	c3                   	ret    
  8019f5:	8d 76 00             	lea    0x0(%esi),%esi
  8019f8:	31 ff                	xor    %edi,%edi
  8019fa:	31 c0                	xor    %eax,%eax
  8019fc:	89 fa                	mov    %edi,%edx
  8019fe:	83 c4 1c             	add    $0x1c,%esp
  801a01:	5b                   	pop    %ebx
  801a02:	5e                   	pop    %esi
  801a03:	5f                   	pop    %edi
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	f7 f7                	div    %edi
  801a0c:	31 ff                	xor    %edi,%edi
  801a0e:	89 fa                	mov    %edi,%edx
  801a10:	83 c4 1c             	add    $0x1c,%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5e                   	pop    %esi
  801a15:	5f                   	pop    %edi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    
  801a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a1d:	89 eb                	mov    %ebp,%ebx
  801a1f:	29 fb                	sub    %edi,%ebx
  801a21:	89 f9                	mov    %edi,%ecx
  801a23:	d3 e6                	shl    %cl,%esi
  801a25:	89 c5                	mov    %eax,%ebp
  801a27:	88 d9                	mov    %bl,%cl
  801a29:	d3 ed                	shr    %cl,%ebp
  801a2b:	89 e9                	mov    %ebp,%ecx
  801a2d:	09 f1                	or     %esi,%ecx
  801a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a33:	89 f9                	mov    %edi,%ecx
  801a35:	d3 e0                	shl    %cl,%eax
  801a37:	89 c5                	mov    %eax,%ebp
  801a39:	89 d6                	mov    %edx,%esi
  801a3b:	88 d9                	mov    %bl,%cl
  801a3d:	d3 ee                	shr    %cl,%esi
  801a3f:	89 f9                	mov    %edi,%ecx
  801a41:	d3 e2                	shl    %cl,%edx
  801a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a47:	88 d9                	mov    %bl,%cl
  801a49:	d3 e8                	shr    %cl,%eax
  801a4b:	09 c2                	or     %eax,%edx
  801a4d:	89 d0                	mov    %edx,%eax
  801a4f:	89 f2                	mov    %esi,%edx
  801a51:	f7 74 24 0c          	divl   0xc(%esp)
  801a55:	89 d6                	mov    %edx,%esi
  801a57:	89 c3                	mov    %eax,%ebx
  801a59:	f7 e5                	mul    %ebp
  801a5b:	39 d6                	cmp    %edx,%esi
  801a5d:	72 19                	jb     801a78 <__udivdi3+0xfc>
  801a5f:	74 0b                	je     801a6c <__udivdi3+0xf0>
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	31 ff                	xor    %edi,%edi
  801a65:	e9 58 ff ff ff       	jmp    8019c2 <__udivdi3+0x46>
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a70:	89 f9                	mov    %edi,%ecx
  801a72:	d3 e2                	shl    %cl,%edx
  801a74:	39 c2                	cmp    %eax,%edx
  801a76:	73 e9                	jae    801a61 <__udivdi3+0xe5>
  801a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a7b:	31 ff                	xor    %edi,%edi
  801a7d:	e9 40 ff ff ff       	jmp    8019c2 <__udivdi3+0x46>
  801a82:	66 90                	xchg   %ax,%ax
  801a84:	31 c0                	xor    %eax,%eax
  801a86:	e9 37 ff ff ff       	jmp    8019c2 <__udivdi3+0x46>
  801a8b:	90                   	nop

00801a8c <__umoddi3>:
  801a8c:	55                   	push   %ebp
  801a8d:	57                   	push   %edi
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 1c             	sub    $0x1c,%esp
  801a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aab:	89 f3                	mov    %esi,%ebx
  801aad:	89 fa                	mov    %edi,%edx
  801aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab3:	89 34 24             	mov    %esi,(%esp)
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	75 1a                	jne    801ad4 <__umoddi3+0x48>
  801aba:	39 f7                	cmp    %esi,%edi
  801abc:	0f 86 a2 00 00 00    	jbe    801b64 <__umoddi3+0xd8>
  801ac2:	89 c8                	mov    %ecx,%eax
  801ac4:	89 f2                	mov    %esi,%edx
  801ac6:	f7 f7                	div    %edi
  801ac8:	89 d0                	mov    %edx,%eax
  801aca:	31 d2                	xor    %edx,%edx
  801acc:	83 c4 1c             	add    $0x1c,%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5f                   	pop    %edi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    
  801ad4:	39 f0                	cmp    %esi,%eax
  801ad6:	0f 87 ac 00 00 00    	ja     801b88 <__umoddi3+0xfc>
  801adc:	0f bd e8             	bsr    %eax,%ebp
  801adf:	83 f5 1f             	xor    $0x1f,%ebp
  801ae2:	0f 84 ac 00 00 00    	je     801b94 <__umoddi3+0x108>
  801ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  801aed:	29 ef                	sub    %ebp,%edi
  801aef:	89 fe                	mov    %edi,%esi
  801af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af5:	89 e9                	mov    %ebp,%ecx
  801af7:	d3 e0                	shl    %cl,%eax
  801af9:	89 d7                	mov    %edx,%edi
  801afb:	89 f1                	mov    %esi,%ecx
  801afd:	d3 ef                	shr    %cl,%edi
  801aff:	09 c7                	or     %eax,%edi
  801b01:	89 e9                	mov    %ebp,%ecx
  801b03:	d3 e2                	shl    %cl,%edx
  801b05:	89 14 24             	mov    %edx,(%esp)
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	d3 e0                	shl    %cl,%eax
  801b0c:	89 c2                	mov    %eax,%edx
  801b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b12:	d3 e0                	shl    %cl,%eax
  801b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b1c:	89 f1                	mov    %esi,%ecx
  801b1e:	d3 e8                	shr    %cl,%eax
  801b20:	09 d0                	or     %edx,%eax
  801b22:	d3 eb                	shr    %cl,%ebx
  801b24:	89 da                	mov    %ebx,%edx
  801b26:	f7 f7                	div    %edi
  801b28:	89 d3                	mov    %edx,%ebx
  801b2a:	f7 24 24             	mull   (%esp)
  801b2d:	89 c6                	mov    %eax,%esi
  801b2f:	89 d1                	mov    %edx,%ecx
  801b31:	39 d3                	cmp    %edx,%ebx
  801b33:	0f 82 87 00 00 00    	jb     801bc0 <__umoddi3+0x134>
  801b39:	0f 84 91 00 00 00    	je     801bd0 <__umoddi3+0x144>
  801b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b43:	29 f2                	sub    %esi,%edx
  801b45:	19 cb                	sbb    %ecx,%ebx
  801b47:	89 d8                	mov    %ebx,%eax
  801b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b4d:	d3 e0                	shl    %cl,%eax
  801b4f:	89 e9                	mov    %ebp,%ecx
  801b51:	d3 ea                	shr    %cl,%edx
  801b53:	09 d0                	or     %edx,%eax
  801b55:	89 e9                	mov    %ebp,%ecx
  801b57:	d3 eb                	shr    %cl,%ebx
  801b59:	89 da                	mov    %ebx,%edx
  801b5b:	83 c4 1c             	add    $0x1c,%esp
  801b5e:	5b                   	pop    %ebx
  801b5f:	5e                   	pop    %esi
  801b60:	5f                   	pop    %edi
  801b61:	5d                   	pop    %ebp
  801b62:	c3                   	ret    
  801b63:	90                   	nop
  801b64:	89 fd                	mov    %edi,%ebp
  801b66:	85 ff                	test   %edi,%edi
  801b68:	75 0b                	jne    801b75 <__umoddi3+0xe9>
  801b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6f:	31 d2                	xor    %edx,%edx
  801b71:	f7 f7                	div    %edi
  801b73:	89 c5                	mov    %eax,%ebp
  801b75:	89 f0                	mov    %esi,%eax
  801b77:	31 d2                	xor    %edx,%edx
  801b79:	f7 f5                	div    %ebp
  801b7b:	89 c8                	mov    %ecx,%eax
  801b7d:	f7 f5                	div    %ebp
  801b7f:	89 d0                	mov    %edx,%eax
  801b81:	e9 44 ff ff ff       	jmp    801aca <__umoddi3+0x3e>
  801b86:	66 90                	xchg   %ax,%ax
  801b88:	89 c8                	mov    %ecx,%eax
  801b8a:	89 f2                	mov    %esi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	3b 04 24             	cmp    (%esp),%eax
  801b97:	72 06                	jb     801b9f <__umoddi3+0x113>
  801b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b9d:	77 0f                	ja     801bae <__umoddi3+0x122>
  801b9f:	89 f2                	mov    %esi,%edx
  801ba1:	29 f9                	sub    %edi,%ecx
  801ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ba7:	89 14 24             	mov    %edx,(%esp)
  801baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bb2:	8b 14 24             	mov    (%esp),%edx
  801bb5:	83 c4 1c             	add    $0x1c,%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5f                   	pop    %edi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
  801bbd:	8d 76 00             	lea    0x0(%esi),%esi
  801bc0:	2b 04 24             	sub    (%esp),%eax
  801bc3:	19 fa                	sbb    %edi,%edx
  801bc5:	89 d1                	mov    %edx,%ecx
  801bc7:	89 c6                	mov    %eax,%esi
  801bc9:	e9 71 ff ff ff       	jmp    801b3f <__umoddi3+0xb3>
  801bce:	66 90                	xchg   %ax,%ax
  801bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd4:	72 ea                	jb     801bc0 <__umoddi3+0x134>
  801bd6:	89 d9                	mov    %ebx,%ecx
  801bd8:	e9 62 ff ff ff       	jmp    801b3f <__umoddi3+0xb3>
