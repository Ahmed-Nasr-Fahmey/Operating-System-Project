
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 e0 18 80 00       	push   $0x8018e0
  800049:	e8 56 02 00 00       	call   8002a4 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 6e 13 00 00       	call   8013cd <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	01 c0                	add    %eax,%eax
  800069:	01 d0                	add    %edx,%eax
  80006b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800072:	01 c8                	add    %ecx,%eax
  800074:	c1 e0 02             	shl    $0x2,%eax
  800077:	01 d0                	add    %edx,%eax
  800079:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800080:	01 c8                	add    %ecx,%eax
  800082:	c1 e0 02             	shl    $0x2,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	c1 e0 02             	shl    $0x2,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	c1 e0 03             	shl    $0x3,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 20 20 80 00       	mov    0x802020,%eax
  80009e:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 0f                	je     8000b7 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000a8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ad:	05 18 da 01 00       	add    $0x1da18,%eax
  8000b2:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bb:	7e 0a                	jle    8000c7 <libmain+0x73>
		binaryname = argv[0];
  8000bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	ff 75 0c             	pushl  0xc(%ebp)
  8000cd:	ff 75 08             	pushl  0x8(%ebp)
  8000d0:	e8 63 ff ff ff       	call   800038 <_main>
  8000d5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d8:	e8 fd 10 00 00       	call   8011da <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 1c 19 80 00       	push   $0x80191c
  8000e5:	e8 8d 01 00 00       	call   800277 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ed:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f2:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8000f8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000fd:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	52                   	push   %edx
  800107:	50                   	push   %eax
  800108:	68 44 19 80 00       	push   $0x801944
  80010d:	e8 65 01 00 00       	call   800277 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800115:	a1 20 20 80 00       	mov    0x802020,%eax
  80011a:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800120:	a1 20 20 80 00       	mov    0x802020,%eax
  800125:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80012b:	a1 20 20 80 00       	mov    0x802020,%eax
  800130:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800136:	51                   	push   %ecx
  800137:	52                   	push   %edx
  800138:	50                   	push   %eax
  800139:	68 6c 19 80 00       	push   $0x80196c
  80013e:	e8 34 01 00 00       	call   800277 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800146:	a1 20 20 80 00       	mov    0x802020,%eax
  80014b:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	68 c4 19 80 00       	push   $0x8019c4
  80015a:	e8 18 01 00 00       	call   800277 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 1c 19 80 00       	push   $0x80191c
  80016a:	e8 08 01 00 00       	call   800277 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800172:	e8 7d 10 00 00       	call   8011f4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800177:	e8 19 00 00 00       	call   800195 <exit>
}
  80017c:	90                   	nop
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 0a 12 00 00       	call   801399 <sys_destroy_env>
  80018f:	83 c4 10             	add    $0x10,%esp
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <exit>:

void
exit(void)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019b:	e8 5f 12 00 00       	call   8013ff <sys_exit_env>
}
  8001a0:	90                   	nop
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ac:	8b 00                	mov    (%eax),%eax
  8001ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8001b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b4:	89 0a                	mov    %ecx,(%edx)
  8001b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b9:	88 d1                	mov    %dl,%cl
  8001bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001be:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cc:	75 2c                	jne    8001fa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001ce:	a0 24 20 80 00       	mov    0x802024,%al
  8001d3:	0f b6 c0             	movzbl %al,%eax
  8001d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d9:	8b 12                	mov    (%edx),%edx
  8001db:	89 d1                	mov    %edx,%ecx
  8001dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e0:	83 c2 08             	add    $0x8,%edx
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	50                   	push   %eax
  8001e7:	51                   	push   %ecx
  8001e8:	52                   	push   %edx
  8001e9:	e8 3e 0e 00 00       	call   80102c <sys_cputs>
  8001ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	8b 40 04             	mov    0x4(%eax),%eax
  800200:	8d 50 01             	lea    0x1(%eax),%edx
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	89 50 04             	mov    %edx,0x4(%eax)
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800215:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021c:	00 00 00 
	b.cnt = 0;
  80021f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800226:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800229:	ff 75 0c             	pushl  0xc(%ebp)
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	68 a3 01 80 00       	push   $0x8001a3
  80023b:	e8 11 02 00 00       	call   800451 <vprintfmt>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800243:	a0 24 20 80 00       	mov    0x802024,%al
  800248:	0f b6 c0             	movzbl %al,%eax
  80024b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	50                   	push   %eax
  800255:	52                   	push   %edx
  800256:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025c:	83 c0 08             	add    $0x8,%eax
  80025f:	50                   	push   %eax
  800260:	e8 c7 0d 00 00       	call   80102c <sys_cputs>
  800265:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800268:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80026f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <cprintf>:

int cprintf(const char *fmt, ...) {
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80027d:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800284:	8d 45 0c             	lea    0xc(%ebp),%eax
  800287:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80028a:	8b 45 08             	mov    0x8(%ebp),%eax
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	ff 75 f4             	pushl  -0xc(%ebp)
  800293:	50                   	push   %eax
  800294:	e8 73 ff ff ff       	call   80020c <vcprintf>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80029f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002aa:	e8 2b 0f 00 00       	call   8011da <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	83 ec 08             	sub    $0x8,%esp
  8002bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002be:	50                   	push   %eax
  8002bf:	e8 48 ff ff ff       	call   80020c <vcprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002ca:	e8 25 0f 00 00       	call   8011f4 <sys_enable_interrupt>
	return cnt;
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 14             	sub    $0x14,%esp
  8002db:	8b 45 10             	mov    0x10(%ebp),%eax
  8002de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f2:	77 55                	ja     800349 <printnum+0x75>
  8002f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f7:	72 05                	jb     8002fe <printnum+0x2a>
  8002f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fc:	77 4b                	ja     800349 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800301:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800304:	8b 45 18             	mov    0x18(%ebp),%eax
  800307:	ba 00 00 00 00       	mov    $0x0,%edx
  80030c:	52                   	push   %edx
  80030d:	50                   	push   %eax
  80030e:	ff 75 f4             	pushl  -0xc(%ebp)
  800311:	ff 75 f0             	pushl  -0x10(%ebp)
  800314:	e8 47 13 00 00       	call   801660 <__udivdi3>
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	ff 75 20             	pushl  0x20(%ebp)
  800322:	53                   	push   %ebx
  800323:	ff 75 18             	pushl  0x18(%ebp)
  800326:	52                   	push   %edx
  800327:	50                   	push   %eax
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 a1 ff ff ff       	call   8002d4 <printnum>
  800333:	83 c4 20             	add    $0x20,%esp
  800336:	eb 1a                	jmp    800352 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 20             	pushl  0x20(%ebp)
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	ff d0                	call   *%eax
  800346:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800349:	ff 4d 1c             	decl   0x1c(%ebp)
  80034c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800350:	7f e6                	jg     800338 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800352:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800355:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800360:	53                   	push   %ebx
  800361:	51                   	push   %ecx
  800362:	52                   	push   %edx
  800363:	50                   	push   %eax
  800364:	e8 07 14 00 00       	call   801770 <__umoddi3>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	05 f4 1b 80 00       	add    $0x801bf4,%eax
  800371:	8a 00                	mov    (%eax),%al
  800373:	0f be c0             	movsbl %al,%eax
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	ff 75 0c             	pushl  0xc(%ebp)
  80037c:	50                   	push   %eax
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	ff d0                	call   *%eax
  800382:	83 c4 10             	add    $0x10,%esp
}
  800385:	90                   	nop
  800386:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800392:	7e 1c                	jle    8003b0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	8d 50 08             	lea    0x8(%eax),%edx
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	89 10                	mov    %edx,(%eax)
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	83 e8 08             	sub    $0x8,%eax
  8003a9:	8b 50 04             	mov    0x4(%eax),%edx
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	eb 40                	jmp    8003f0 <getuint+0x65>
	else if (lflag)
  8003b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b4:	74 1e                	je     8003d4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	8d 50 04             	lea    0x4(%eax),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	89 10                	mov    %edx,(%eax)
  8003c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	83 e8 04             	sub    $0x4,%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	eb 1c                	jmp    8003f0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	8d 50 04             	lea    0x4(%eax),%edx
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	89 10                	mov    %edx,(%eax)
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	83 e8 04             	sub    $0x4,%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f0:	5d                   	pop    %ebp
  8003f1:	c3                   	ret    

008003f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f9:	7e 1c                	jle    800417 <getint+0x25>
		return va_arg(*ap, long long);
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	8d 50 08             	lea    0x8(%eax),%edx
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	89 10                	mov    %edx,(%eax)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 e8 08             	sub    $0x8,%eax
  800410:	8b 50 04             	mov    0x4(%eax),%edx
  800413:	8b 00                	mov    (%eax),%eax
  800415:	eb 38                	jmp    80044f <getint+0x5d>
	else if (lflag)
  800417:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80041b:	74 1a                	je     800437 <getint+0x45>
		return va_arg(*ap, long);
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	8d 50 04             	lea    0x4(%eax),%edx
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	89 10                	mov    %edx,(%eax)
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	83 e8 04             	sub    $0x4,%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	99                   	cltd   
  800435:	eb 18                	jmp    80044f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	8d 50 04             	lea    0x4(%eax),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	89 10                	mov    %edx,(%eax)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	8b 00                	mov    (%eax),%eax
  800449:	83 e8 04             	sub    $0x4,%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	99                   	cltd   
}
  80044f:	5d                   	pop    %ebp
  800450:	c3                   	ret    

00800451 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800459:	eb 17                	jmp    800472 <vprintfmt+0x21>
			if (ch == '\0')
  80045b:	85 db                	test   %ebx,%ebx
  80045d:	0f 84 af 03 00 00    	je     800812 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	ff 75 0c             	pushl  0xc(%ebp)
  800469:	53                   	push   %ebx
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	ff d0                	call   *%eax
  80046f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800472:	8b 45 10             	mov    0x10(%ebp),%eax
  800475:	8d 50 01             	lea    0x1(%eax),%edx
  800478:	89 55 10             	mov    %edx,0x10(%ebp)
  80047b:	8a 00                	mov    (%eax),%al
  80047d:	0f b6 d8             	movzbl %al,%ebx
  800480:	83 fb 25             	cmp    $0x25,%ebx
  800483:	75 d6                	jne    80045b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800485:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800489:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800490:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800497:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80049e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a8:	8d 50 01             	lea    0x1(%eax),%edx
  8004ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ae:	8a 00                	mov    (%eax),%al
  8004b0:	0f b6 d8             	movzbl %al,%ebx
  8004b3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b6:	83 f8 55             	cmp    $0x55,%eax
  8004b9:	0f 87 2b 03 00 00    	ja     8007ea <vprintfmt+0x399>
  8004bf:	8b 04 85 18 1c 80 00 	mov    0x801c18(,%eax,4),%eax
  8004c6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004cc:	eb d7                	jmp    8004a5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004ce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004d2:	eb d1                	jmp    8004a5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004de:	89 d0                	mov    %edx,%eax
  8004e0:	c1 e0 02             	shl    $0x2,%eax
  8004e3:	01 d0                	add    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d8                	add    %ebx,%eax
  8004e9:	83 e8 30             	sub    $0x30,%eax
  8004ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f2:	8a 00                	mov    (%eax),%al
  8004f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8004fa:	7e 3e                	jle    80053a <vprintfmt+0xe9>
  8004fc:	83 fb 39             	cmp    $0x39,%ebx
  8004ff:	7f 39                	jg     80053a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800501:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800504:	eb d5                	jmp    8004db <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	83 e8 04             	sub    $0x4,%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80051a:	eb 1f                	jmp    80053b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800520:	79 83                	jns    8004a5 <vprintfmt+0x54>
				width = 0;
  800522:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800529:	e9 77 ff ff ff       	jmp    8004a5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80052e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800535:	e9 6b ff ff ff       	jmp    8004a5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80053a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80053b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053f:	0f 89 60 ff ff ff    	jns    8004a5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800548:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800552:	e9 4e ff ff ff       	jmp    8004a5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800557:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80055a:	e9 46 ff ff ff       	jmp    8004a5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 e8 04             	sub    $0x4,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	50                   	push   %eax
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	ff d0                	call   *%eax
  80057c:	83 c4 10             	add    $0x10,%esp
			break;
  80057f:	e9 89 02 00 00       	jmp    80080d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	83 c0 04             	add    $0x4,%eax
  80058a:	89 45 14             	mov    %eax,0x14(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 e8 04             	sub    $0x4,%eax
  800593:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800595:	85 db                	test   %ebx,%ebx
  800597:	79 02                	jns    80059b <vprintfmt+0x14a>
				err = -err;
  800599:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80059b:	83 fb 64             	cmp    $0x64,%ebx
  80059e:	7f 0b                	jg     8005ab <vprintfmt+0x15a>
  8005a0:	8b 34 9d 60 1a 80 00 	mov    0x801a60(,%ebx,4),%esi
  8005a7:	85 f6                	test   %esi,%esi
  8005a9:	75 19                	jne    8005c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ab:	53                   	push   %ebx
  8005ac:	68 05 1c 80 00       	push   $0x801c05
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 5e 02 00 00       	call   80081a <printfmt>
  8005bc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005bf:	e9 49 02 00 00       	jmp    80080d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005c4:	56                   	push   %esi
  8005c5:	68 0e 1c 80 00       	push   $0x801c0e
  8005ca:	ff 75 0c             	pushl  0xc(%ebp)
  8005cd:	ff 75 08             	pushl  0x8(%ebp)
  8005d0:	e8 45 02 00 00       	call   80081a <printfmt>
  8005d5:	83 c4 10             	add    $0x10,%esp
			break;
  8005d8:	e9 30 02 00 00       	jmp    80080d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 c0 04             	add    $0x4,%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 e8 04             	sub    $0x4,%eax
  8005ec:	8b 30                	mov    (%eax),%esi
  8005ee:	85 f6                	test   %esi,%esi
  8005f0:	75 05                	jne    8005f7 <vprintfmt+0x1a6>
				p = "(null)";
  8005f2:	be 11 1c 80 00       	mov    $0x801c11,%esi
			if (width > 0 && padc != '-')
  8005f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fb:	7e 6d                	jle    80066a <vprintfmt+0x219>
  8005fd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800601:	74 67                	je     80066a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	50                   	push   %eax
  80060a:	56                   	push   %esi
  80060b:	e8 0c 03 00 00       	call   80091c <strnlen>
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800616:	eb 16                	jmp    80062e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800618:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 0c             	pushl  0xc(%ebp)
  800622:	50                   	push   %eax
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	ff d0                	call   *%eax
  800628:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80062b:	ff 4d e4             	decl   -0x1c(%ebp)
  80062e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800632:	7f e4                	jg     800618 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800634:	eb 34                	jmp    80066a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800636:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063a:	74 1c                	je     800658 <vprintfmt+0x207>
  80063c:	83 fb 1f             	cmp    $0x1f,%ebx
  80063f:	7e 05                	jle    800646 <vprintfmt+0x1f5>
  800641:	83 fb 7e             	cmp    $0x7e,%ebx
  800644:	7e 12                	jle    800658 <vprintfmt+0x207>
					putch('?', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	6a 3f                	push   $0x3f
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	ff d0                	call   *%eax
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	eb 0f                	jmp    800667 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	ff 75 0c             	pushl  0xc(%ebp)
  80065e:	53                   	push   %ebx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	ff d0                	call   *%eax
  800664:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800667:	ff 4d e4             	decl   -0x1c(%ebp)
  80066a:	89 f0                	mov    %esi,%eax
  80066c:	8d 70 01             	lea    0x1(%eax),%esi
  80066f:	8a 00                	mov    (%eax),%al
  800671:	0f be d8             	movsbl %al,%ebx
  800674:	85 db                	test   %ebx,%ebx
  800676:	74 24                	je     80069c <vprintfmt+0x24b>
  800678:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067c:	78 b8                	js     800636 <vprintfmt+0x1e5>
  80067e:	ff 4d e0             	decl   -0x20(%ebp)
  800681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800685:	79 af                	jns    800636 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800687:	eb 13                	jmp    80069c <vprintfmt+0x24b>
				putch(' ', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	6a 20                	push   $0x20
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	ff d0                	call   *%eax
  800696:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800699:	ff 4d e4             	decl   -0x1c(%ebp)
  80069c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a0:	7f e7                	jg     800689 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006a2:	e9 66 01 00 00       	jmp    80080d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b0:	50                   	push   %eax
  8006b1:	e8 3c fd ff ff       	call   8003f2 <getint>
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c5:	85 d2                	test   %edx,%edx
  8006c7:	79 23                	jns    8006ec <vprintfmt+0x29b>
				putch('-', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 2d                	push   $0x2d
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	ff d0                	call   *%eax
  8006d6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006df:	f7 d8                	neg    %eax
  8006e1:	83 d2 00             	adc    $0x0,%edx
  8006e4:	f7 da                	neg    %edx
  8006e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f3:	e9 bc 00 00 00       	jmp    8007b4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	e8 84 fc ff ff       	call   80038b <getuint>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800710:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800717:	e9 98 00 00 00       	jmp    8007b4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	6a 58                	push   $0x58
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	6a 58                	push   $0x58
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	ff d0                	call   *%eax
  800739:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	6a 58                	push   $0x58
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	ff d0                	call   *%eax
  800749:	83 c4 10             	add    $0x10,%esp
			break;
  80074c:	e9 bc 00 00 00       	jmp    80080d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	6a 30                	push   $0x30
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	6a 78                	push   $0x78
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	83 c0 04             	add    $0x4,%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	83 e8 04             	sub    $0x4,%eax
  800780:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80078c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800793:	eb 1f                	jmp    8007b4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 e8             	pushl  -0x18(%ebp)
  80079b:	8d 45 14             	lea    0x14(%ebp),%eax
  80079e:	50                   	push   %eax
  80079f:	e8 e7 fb ff ff       	call   80038b <getuint>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007bb:	83 ec 04             	sub    $0x4,%esp
  8007be:	52                   	push   %edx
  8007bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	ff 75 08             	pushl  0x8(%ebp)
  8007cf:	e8 00 fb ff ff       	call   8002d4 <printnum>
  8007d4:	83 c4 20             	add    $0x20,%esp
			break;
  8007d7:	eb 34                	jmp    80080d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 0c             	pushl  0xc(%ebp)
  8007df:	53                   	push   %ebx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	ff d0                	call   *%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
			break;
  8007e8:	eb 23                	jmp    80080d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 25                	push   $0x25
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fa:	ff 4d 10             	decl   0x10(%ebp)
  8007fd:	eb 03                	jmp    800802 <vprintfmt+0x3b1>
  8007ff:	ff 4d 10             	decl   0x10(%ebp)
  800802:	8b 45 10             	mov    0x10(%ebp),%eax
  800805:	48                   	dec    %eax
  800806:	8a 00                	mov    (%eax),%al
  800808:	3c 25                	cmp    $0x25,%al
  80080a:	75 f3                	jne    8007ff <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80080c:	90                   	nop
		}
	}
  80080d:	e9 47 fc ff ff       	jmp    800459 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800812:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800813:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800816:	5b                   	pop    %ebx
  800817:	5e                   	pop    %esi
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800820:	8d 45 10             	lea    0x10(%ebp),%eax
  800823:	83 c0 04             	add    $0x4,%eax
  800826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	ff 75 f4             	pushl  -0xc(%ebp)
  80082f:	50                   	push   %eax
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	ff 75 08             	pushl  0x8(%ebp)
  800836:	e8 16 fc ff ff       	call   800451 <vprintfmt>
  80083b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80083e:	90                   	nop
  80083f:	c9                   	leave  
  800840:	c3                   	ret    

00800841 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	8b 40 08             	mov    0x8(%eax),%eax
  80084a:	8d 50 01             	lea    0x1(%eax),%edx
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800853:	8b 45 0c             	mov    0xc(%ebp),%eax
  800856:	8b 10                	mov    (%eax),%edx
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	8b 40 04             	mov    0x4(%eax),%eax
  80085e:	39 c2                	cmp    %eax,%edx
  800860:	73 12                	jae    800874 <sprintputch+0x33>
		*b->buf++ = ch;
  800862:	8b 45 0c             	mov    0xc(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	8d 48 01             	lea    0x1(%eax),%ecx
  80086a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086d:	89 0a                	mov    %ecx,(%edx)
  80086f:	8b 55 08             	mov    0x8(%ebp),%edx
  800872:	88 10                	mov    %dl,(%eax)
}
  800874:	90                   	nop
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800883:	8b 45 0c             	mov    0xc(%ebp),%eax
  800886:	8d 50 ff             	lea    -0x1(%eax),%edx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	01 d0                	add    %edx,%eax
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800898:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80089c:	74 06                	je     8008a4 <vsnprintf+0x2d>
  80089e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a2:	7f 07                	jg     8008ab <vsnprintf+0x34>
		return -E_INVAL;
  8008a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a9:	eb 20                	jmp    8008cb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ab:	ff 75 14             	pushl  0x14(%ebp)
  8008ae:	ff 75 10             	pushl  0x10(%ebp)
  8008b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b4:	50                   	push   %eax
  8008b5:	68 41 08 80 00       	push   $0x800841
  8008ba:	e8 92 fb ff ff       	call   800451 <vprintfmt>
  8008bf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	ff 75 08             	pushl  0x8(%ebp)
  8008e9:	e8 89 ff ff ff       	call   800877 <vsnprintf>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800906:	eb 06                	jmp    80090e <strlen+0x15>
		n++;
  800908:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80090b:	ff 45 08             	incl   0x8(%ebp)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8a 00                	mov    (%eax),%al
  800913:	84 c0                	test   %al,%al
  800915:	75 f1                	jne    800908 <strlen+0xf>
		n++;
	return n;
  800917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800929:	eb 09                	jmp    800934 <strnlen+0x18>
		n++;
  80092b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092e:	ff 45 08             	incl   0x8(%ebp)
  800931:	ff 4d 0c             	decl   0xc(%ebp)
  800934:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800938:	74 09                	je     800943 <strnlen+0x27>
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8a 00                	mov    (%eax),%al
  80093f:	84 c0                	test   %al,%al
  800941:	75 e8                	jne    80092b <strnlen+0xf>
		n++;
	return n;
  800943:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    

00800948 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800954:	90                   	nop
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8d 50 01             	lea    0x1(%eax),%edx
  80095b:	89 55 08             	mov    %edx,0x8(%ebp)
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800961:	8d 4a 01             	lea    0x1(%edx),%ecx
  800964:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800967:	8a 12                	mov    (%edx),%dl
  800969:	88 10                	mov    %dl,(%eax)
  80096b:	8a 00                	mov    (%eax),%al
  80096d:	84 c0                	test   %al,%al
  80096f:	75 e4                	jne    800955 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800971:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800982:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800989:	eb 1f                	jmp    8009aa <strncpy+0x34>
		*dst++ = *src;
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8d 50 01             	lea    0x1(%eax),%edx
  800991:	89 55 08             	mov    %edx,0x8(%ebp)
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
  800997:	8a 12                	mov    (%edx),%dl
  800999:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 03                	je     8009a7 <strncpy+0x31>
			src++;
  8009a4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a7:	ff 45 fc             	incl   -0x4(%ebp)
  8009aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ad:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b0:	72 d9                	jb     80098b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c7:	74 30                	je     8009f9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c9:	eb 16                	jmp    8009e1 <strlcpy+0x2a>
			*dst++ = *src++;
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009da:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009dd:	8a 12                	mov    (%edx),%dl
  8009df:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e1:	ff 4d 10             	decl   0x10(%ebp)
  8009e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e8:	74 09                	je     8009f3 <strlcpy+0x3c>
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	84 c0                	test   %al,%al
  8009f1:	75 d8                	jne    8009cb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ff:	29 c2                	sub    %eax,%edx
  800a01:	89 d0                	mov    %edx,%eax
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a08:	eb 06                	jmp    800a10 <strcmp+0xb>
		p++, q++;
  800a0a:	ff 45 08             	incl   0x8(%ebp)
  800a0d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	84 c0                	test   %al,%al
  800a17:	74 0e                	je     800a27 <strcmp+0x22>
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8a 10                	mov    (%eax),%dl
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	38 c2                	cmp    %al,%dl
  800a25:	74 e3                	je     800a0a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f b6 d0             	movzbl %al,%edx
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	8a 00                	mov    (%eax),%al
  800a34:	0f b6 c0             	movzbl %al,%eax
  800a37:	29 c2                	sub    %eax,%edx
  800a39:	89 d0                	mov    %edx,%eax
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a40:	eb 09                	jmp    800a4b <strncmp+0xe>
		n--, p++, q++;
  800a42:	ff 4d 10             	decl   0x10(%ebp)
  800a45:	ff 45 08             	incl   0x8(%ebp)
  800a48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4f:	74 17                	je     800a68 <strncmp+0x2b>
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	84 c0                	test   %al,%al
  800a58:	74 0e                	je     800a68 <strncmp+0x2b>
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8a 10                	mov    (%eax),%dl
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8a 00                	mov    (%eax),%al
  800a64:	38 c2                	cmp    %al,%dl
  800a66:	74 da                	je     800a42 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6c:	75 07                	jne    800a75 <strncmp+0x38>
		return 0;
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	eb 14                	jmp    800a89 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	0f b6 d0             	movzbl %al,%edx
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8a 00                	mov    (%eax),%al
  800a82:	0f b6 c0             	movzbl %al,%eax
  800a85:	29 c2                	sub    %eax,%edx
  800a87:	89 d0                	mov    %edx,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a97:	eb 12                	jmp    800aab <strchr+0x20>
		if (*s == c)
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8a 00                	mov    (%eax),%al
  800a9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aa1:	75 05                	jne    800aa8 <strchr+0x1d>
			return (char *) s;
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	eb 11                	jmp    800ab9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa8:	ff 45 08             	incl   0x8(%ebp)
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	84 c0                	test   %al,%al
  800ab2:	75 e5                	jne    800a99 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 04             	sub    $0x4,%esp
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac7:	eb 0d                	jmp    800ad6 <strfind+0x1b>
		if (*s == c)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad1:	74 0e                	je     800ae1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad3:	ff 45 08             	incl   0x8(%ebp)
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	84 c0                	test   %al,%al
  800add:	75 ea                	jne    800ac9 <strfind+0xe>
  800adf:	eb 01                	jmp    800ae2 <strfind+0x27>
		if (*s == c)
			break;
  800ae1:	90                   	nop
	return (char *) s;
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af3:	8b 45 10             	mov    0x10(%ebp),%eax
  800af6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af9:	eb 0e                	jmp    800b09 <memset+0x22>
		*p++ = c;
  800afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b09:	ff 4d f8             	decl   -0x8(%ebp)
  800b0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b10:	79 e9                	jns    800afb <memset+0x14>
		*p++ = c;

	return v;
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b29:	eb 16                	jmp    800b41 <memcpy+0x2a>
		*d++ = *s++;
  800b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2e:	8d 50 01             	lea    0x1(%eax),%edx
  800b31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3d:	8a 12                	mov    (%edx),%dl
  800b3f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b41:	8b 45 10             	mov    0x10(%ebp),%eax
  800b44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b47:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	75 dd                	jne    800b2b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6b:	73 50                	jae    800bbd <memmove+0x6a>
  800b6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b70:	8b 45 10             	mov    0x10(%ebp),%eax
  800b73:	01 d0                	add    %edx,%eax
  800b75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b78:	76 43                	jbe    800bbd <memmove+0x6a>
		s += n;
  800b7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b86:	eb 10                	jmp    800b98 <memmove+0x45>
			*--d = *--s;
  800b88:	ff 4d f8             	decl   -0x8(%ebp)
  800b8b:	ff 4d fc             	decl   -0x4(%ebp)
  800b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b91:	8a 10                	mov    (%eax),%dl
  800b93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b96:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	75 e3                	jne    800b88 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba5:	eb 23                	jmp    800bca <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb9:	8a 12                	mov    (%edx),%dl
  800bbb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc6:	85 c0                	test   %eax,%eax
  800bc8:	75 dd                	jne    800ba7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be1:	eb 2a                	jmp    800c0d <memcmp+0x3e>
		if (*s1 != *s2)
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be6:	8a 10                	mov    (%eax),%dl
  800be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	38 c2                	cmp    %al,%dl
  800bef:	74 16                	je     800c07 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	0f b6 d0             	movzbl %al,%edx
  800bf9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	0f b6 c0             	movzbl %al,%eax
  800c01:	29 c2                	sub    %eax,%edx
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	eb 18                	jmp    800c1f <memcmp+0x50>
		s1++, s2++;
  800c07:	ff 45 fc             	incl   -0x4(%ebp)
  800c0a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c13:	89 55 10             	mov    %edx,0x10(%ebp)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	75 c9                	jne    800be3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2d:	01 d0                	add    %edx,%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c32:	eb 15                	jmp    800c49 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 d0             	movzbl %al,%edx
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	0f b6 c0             	movzbl %al,%eax
  800c42:	39 c2                	cmp    %eax,%edx
  800c44:	74 0d                	je     800c53 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c46:	ff 45 08             	incl   0x8(%ebp)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c4f:	72 e3                	jb     800c34 <memfind+0x13>
  800c51:	eb 01                	jmp    800c54 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c53:	90                   	nop
	return (void *) s;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c66:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6d:	eb 03                	jmp    800c72 <strtol+0x19>
		s++;
  800c6f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	3c 20                	cmp    $0x20,%al
  800c79:	74 f4                	je     800c6f <strtol+0x16>
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	3c 09                	cmp    $0x9,%al
  800c82:	74 eb                	je     800c6f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	3c 2b                	cmp    $0x2b,%al
  800c8b:	75 05                	jne    800c92 <strtol+0x39>
		s++;
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	eb 13                	jmp    800ca5 <strtol+0x4c>
	else if (*s == '-')
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	3c 2d                	cmp    $0x2d,%al
  800c99:	75 0a                	jne    800ca5 <strtol+0x4c>
		s++, neg = 1;
  800c9b:	ff 45 08             	incl   0x8(%ebp)
  800c9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca9:	74 06                	je     800cb1 <strtol+0x58>
  800cab:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800caf:	75 20                	jne    800cd1 <strtol+0x78>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	3c 30                	cmp    $0x30,%al
  800cb8:	75 17                	jne    800cd1 <strtol+0x78>
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	40                   	inc    %eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	3c 78                	cmp    $0x78,%al
  800cc2:	75 0d                	jne    800cd1 <strtol+0x78>
		s += 2, base = 16;
  800cc4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ccf:	eb 28                	jmp    800cf9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	75 15                	jne    800cec <strtol+0x93>
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	3c 30                	cmp    $0x30,%al
  800cde:	75 0c                	jne    800cec <strtol+0x93>
		s++, base = 8;
  800ce0:	ff 45 08             	incl   0x8(%ebp)
  800ce3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cea:	eb 0d                	jmp    800cf9 <strtol+0xa0>
	else if (base == 0)
  800cec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf0:	75 07                	jne    800cf9 <strtol+0xa0>
		base = 10;
  800cf2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 2f                	cmp    $0x2f,%al
  800d00:	7e 19                	jle    800d1b <strtol+0xc2>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	3c 39                	cmp    $0x39,%al
  800d09:	7f 10                	jg     800d1b <strtol+0xc2>
			dig = *s - '0';
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f be c0             	movsbl %al,%eax
  800d13:	83 e8 30             	sub    $0x30,%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d19:	eb 42                	jmp    800d5d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	3c 60                	cmp    $0x60,%al
  800d22:	7e 19                	jle    800d3d <strtol+0xe4>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	3c 7a                	cmp    $0x7a,%al
  800d2b:	7f 10                	jg     800d3d <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	0f be c0             	movsbl %al,%eax
  800d35:	83 e8 57             	sub    $0x57,%eax
  800d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3b:	eb 20                	jmp    800d5d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	3c 40                	cmp    $0x40,%al
  800d44:	7e 39                	jle    800d7f <strtol+0x126>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	3c 5a                	cmp    $0x5a,%al
  800d4d:	7f 30                	jg     800d7f <strtol+0x126>
			dig = *s - 'A' + 10;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f be c0             	movsbl %al,%eax
  800d57:	83 e8 37             	sub    $0x37,%eax
  800d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d60:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d63:	7d 19                	jge    800d7e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d6f:	89 c2                	mov    %eax,%edx
  800d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d79:	e9 7b ff ff ff       	jmp    800cf9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d7e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 08                	je     800d8d <strtol+0x134>
		*endptr = (char *) s;
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d91:	74 07                	je     800d9a <strtol+0x141>
  800d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d96:	f7 d8                	neg    %eax
  800d98:	eb 03                	jmp    800d9d <strtol+0x144>
  800d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <ltostr>:

void
ltostr(long value, char *str)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db7:	79 13                	jns    800dcc <ltostr+0x2d>
	{
		neg = 1;
  800db9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd4:	99                   	cltd   
  800dd5:	f7 f9                	idiv   %ecx
  800dd7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de3:	89 c2                	mov    %eax,%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
  800dea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ded:	83 c2 30             	add    $0x30,%edx
  800df0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dfa:	f7 e9                	imul   %ecx
  800dfc:	c1 fa 02             	sar    $0x2,%edx
  800dff:	89 c8                	mov    %ecx,%eax
  800e01:	c1 f8 1f             	sar    $0x1f,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
  800e08:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e13:	f7 e9                	imul   %ecx
  800e15:	c1 fa 02             	sar    $0x2,%edx
  800e18:	89 c8                	mov    %ecx,%eax
  800e1a:	c1 f8 1f             	sar    $0x1f,%eax
  800e1d:	29 c2                	sub    %eax,%edx
  800e1f:	89 d0                	mov    %edx,%eax
  800e21:	c1 e0 02             	shl    $0x2,%eax
  800e24:	01 d0                	add    %edx,%eax
  800e26:	01 c0                	add    %eax,%eax
  800e28:	29 c1                	sub    %eax,%ecx
  800e2a:	89 ca                	mov    %ecx,%edx
  800e2c:	85 d2                	test   %edx,%edx
  800e2e:	75 9c                	jne    800dcc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3a:	48                   	dec    %eax
  800e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e42:	74 3d                	je     800e81 <ltostr+0xe2>
		start = 1 ;
  800e44:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e4b:	eb 34                	jmp    800e81 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	01 d0                	add    %edx,%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	01 c2                	add    %eax,%edx
  800e62:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	01 c8                	add    %ecx,%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	01 c2                	add    %eax,%edx
  800e76:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e79:	88 02                	mov    %al,(%edx)
		start++ ;
  800e7b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e7e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e84:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e87:	7c c4                	jl     800e4d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e89:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	01 d0                	add    %edx,%eax
  800e91:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e94:	90                   	nop
  800e95:	c9                   	leave  
  800e96:	c3                   	ret    

00800e97 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e9d:	ff 75 08             	pushl  0x8(%ebp)
  800ea0:	e8 54 fa ff ff       	call   8008f9 <strlen>
  800ea5:	83 c4 04             	add    $0x4,%esp
  800ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	e8 46 fa ff ff       	call   8008f9 <strlen>
  800eb3:	83 c4 04             	add    $0x4,%esp
  800eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ec0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec7:	eb 17                	jmp    800ee0 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ec9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 c2                	add    %eax,%edx
  800ed1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	01 c8                	add    %ecx,%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800edd:	ff 45 fc             	incl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee6:	7c e1                	jl     800ec9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef6:	eb 1f                	jmp    800f17 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	01 c2                	add    %eax,%edx
  800f08:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f14:	ff 45 f8             	incl   -0x8(%ebp)
  800f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f1d:	7c d9                	jl     800ef8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	c6 00 00             	movb   $0x0,(%eax)
}
  800f2a:	90                   	nop
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f30:	8b 45 14             	mov    0x14(%ebp),%eax
  800f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	01 d0                	add    %edx,%eax
  800f4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f50:	eb 0c                	jmp    800f5e <strsplit+0x31>
			*string++ = 0;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	74 18                	je     800f7f <strsplit+0x52>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	0f be c0             	movsbl %al,%eax
  800f6f:	50                   	push   %eax
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	e8 13 fb ff ff       	call   800a8b <strchr>
  800f78:	83 c4 08             	add    $0x8,%esp
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 d3                	jne    800f52 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	84 c0                	test   %al,%al
  800f86:	74 5a                	je     800fe2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f88:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8b:	8b 00                	mov    (%eax),%eax
  800f8d:	83 f8 0f             	cmp    $0xf,%eax
  800f90:	75 07                	jne    800f99 <strsplit+0x6c>
		{
			return 0;
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
  800f97:	eb 66                	jmp    800fff <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f99:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9c:	8b 00                	mov    (%eax),%eax
  800f9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa1:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa4:	89 0a                	mov    %ecx,(%edx)
  800fa6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	01 c2                	add    %eax,%edx
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb7:	eb 03                	jmp    800fbc <strsplit+0x8f>
			string++;
  800fb9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	84 c0                	test   %al,%al
  800fc3:	74 8b                	je     800f50 <strsplit+0x23>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	50                   	push   %eax
  800fce:	ff 75 0c             	pushl  0xc(%ebp)
  800fd1:	e8 b5 fa ff ff       	call   800a8b <strchr>
  800fd6:	83 c4 08             	add    $0x8,%esp
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	74 dc                	je     800fb9 <strsplit+0x8c>
			string++;
	}
  800fdd:	e9 6e ff ff ff       	jmp    800f50 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fe2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe6:	8b 00                	mov    (%eax),%eax
  800fe8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
  800ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ffa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
  801007:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801013:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801016:	8b 7d 18             	mov    0x18(%ebp),%edi
  801019:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80101c:	cd 30                	int    $0x30
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 04             	sub    $0x4,%esp
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801038:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	6a 00                	push   $0x0
  801041:	6a 00                	push   $0x0
  801043:	52                   	push   %edx
  801044:	ff 75 0c             	pushl  0xc(%ebp)
  801047:	50                   	push   %eax
  801048:	6a 00                	push   $0x0
  80104a:	e8 b2 ff ff ff       	call   801001 <syscall>
  80104f:	83 c4 18             	add    $0x18,%esp
}
  801052:	90                   	nop
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <sys_cgetc>:

int
sys_cgetc(void)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801058:	6a 00                	push   $0x0
  80105a:	6a 00                	push   $0x0
  80105c:	6a 00                	push   $0x0
  80105e:	6a 00                	push   $0x0
  801060:	6a 00                	push   $0x0
  801062:	6a 01                	push   $0x1
  801064:	e8 98 ff ff ff       	call   801001 <syscall>
  801069:	83 c4 18             	add    $0x18,%esp
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	6a 00                	push   $0x0
  801079:	6a 00                	push   $0x0
  80107b:	6a 00                	push   $0x0
  80107d:	52                   	push   %edx
  80107e:	50                   	push   %eax
  80107f:	6a 05                	push   $0x5
  801081:	e8 7b ff ff ff       	call   801001 <syscall>
  801086:	83 c4 18             	add    $0x18,%esp
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801090:	8b 75 18             	mov    0x18(%ebp),%esi
  801093:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801096:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
  8010a1:	51                   	push   %ecx
  8010a2:	52                   	push   %edx
  8010a3:	50                   	push   %eax
  8010a4:	6a 06                	push   $0x6
  8010a6:	e8 56 ff ff ff       	call   801001 <syscall>
  8010ab:	83 c4 18             	add    $0x18,%esp
}
  8010ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	52                   	push   %edx
  8010c5:	50                   	push   %eax
  8010c6:	6a 07                	push   $0x7
  8010c8:	e8 34 ff ff ff       	call   801001 <syscall>
  8010cd:	83 c4 18             	add    $0x18,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010d5:	6a 00                	push   $0x0
  8010d7:	6a 00                	push   $0x0
  8010d9:	6a 00                	push   $0x0
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	ff 75 08             	pushl  0x8(%ebp)
  8010e1:	6a 08                	push   $0x8
  8010e3:	e8 19 ff ff ff       	call   801001 <syscall>
  8010e8:	83 c4 18             	add    $0x18,%esp
}
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    

008010ed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010f0:	6a 00                	push   $0x0
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 09                	push   $0x9
  8010fc:	e8 00 ff ff ff       	call   801001 <syscall>
  801101:	83 c4 18             	add    $0x18,%esp
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 00                	push   $0x0
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 0a                	push   $0xa
  801115:	e8 e7 fe ff ff       	call   801001 <syscall>
  80111a:	83 c4 18             	add    $0x18,%esp
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 0b                	push   $0xb
  80112e:	e8 ce fe ff ff       	call   801001 <syscall>
  801133:	83 c4 18             	add    $0x18,%esp
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	ff 75 08             	pushl  0x8(%ebp)
  801147:	6a 0f                	push   $0xf
  801149:	e8 b3 fe ff ff       	call   801001 <syscall>
  80114e:	83 c4 18             	add    $0x18,%esp
	return;
  801151:	90                   	nop
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	ff 75 0c             	pushl  0xc(%ebp)
  801160:	ff 75 08             	pushl  0x8(%ebp)
  801163:	6a 10                	push   $0x10
  801165:	e8 97 fe ff ff       	call   801001 <syscall>
  80116a:	83 c4 18             	add    $0x18,%esp
	return ;
  80116d:	90                   	nop
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	ff 75 10             	pushl  0x10(%ebp)
  80117a:	ff 75 0c             	pushl  0xc(%ebp)
  80117d:	ff 75 08             	pushl  0x8(%ebp)
  801180:	6a 11                	push   $0x11
  801182:	e8 7a fe ff ff       	call   801001 <syscall>
  801187:	83 c4 18             	add    $0x18,%esp
	return ;
  80118a:	90                   	nop
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 0c                	push   $0xc
  80119c:	e8 60 fe ff ff       	call   801001 <syscall>
  8011a1:	83 c4 18             	add    $0x18,%esp
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	ff 75 08             	pushl  0x8(%ebp)
  8011b4:	6a 0d                	push   $0xd
  8011b6:	e8 46 fe ff ff       	call   801001 <syscall>
  8011bb:	83 c4 18             	add    $0x18,%esp
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 0e                	push   $0xe
  8011cf:	e8 2d fe ff ff       	call   801001 <syscall>
  8011d4:	83 c4 18             	add    $0x18,%esp
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 13                	push   $0x13
  8011e9:	e8 13 fe ff ff       	call   801001 <syscall>
  8011ee:	83 c4 18             	add    $0x18,%esp
}
  8011f1:	90                   	nop
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 14                	push   $0x14
  801203:	e8 f9 fd ff ff       	call   801001 <syscall>
  801208:	83 c4 18             	add    $0x18,%esp
}
  80120b:	90                   	nop
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <sys_cputc>:


void
sys_cputc(const char c)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80121a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	50                   	push   %eax
  801227:	6a 15                	push   $0x15
  801229:	e8 d3 fd ff ff       	call   801001 <syscall>
  80122e:	83 c4 18             	add    $0x18,%esp
}
  801231:	90                   	nop
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 16                	push   $0x16
  801243:	e8 b9 fd ff ff       	call   801001 <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	90                   	nop
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	6a 17                	push   $0x17
  801260:	e8 9c fd ff ff       	call   801001 <syscall>
  801265:	83 c4 18             	add    $0x18,%esp
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80126d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	52                   	push   %edx
  80127a:	50                   	push   %eax
  80127b:	6a 1a                	push   $0x1a
  80127d:	e8 7f fd ff ff       	call   801001 <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80128a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	52                   	push   %edx
  801297:	50                   	push   %eax
  801298:	6a 18                	push   $0x18
  80129a:	e8 62 fd ff ff       	call   801001 <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	52                   	push   %edx
  8012b5:	50                   	push   %eax
  8012b6:	6a 19                	push   $0x19
  8012b8:	e8 44 fd ff ff       	call   801001 <syscall>
  8012bd:	83 c4 18             	add    $0x18,%esp
}
  8012c0:	90                   	nop
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	6a 00                	push   $0x0
  8012db:	51                   	push   %ecx
  8012dc:	52                   	push   %edx
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	50                   	push   %eax
  8012e1:	6a 1b                	push   $0x1b
  8012e3:	e8 19 fd ff ff       	call   801001 <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	52                   	push   %edx
  8012fd:	50                   	push   %eax
  8012fe:	6a 1c                	push   $0x1c
  801300:	e8 fc fc ff ff       	call   801001 <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80130d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801310:	8b 55 0c             	mov    0xc(%ebp),%edx
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	51                   	push   %ecx
  80131b:	52                   	push   %edx
  80131c:	50                   	push   %eax
  80131d:	6a 1d                	push   $0x1d
  80131f:	e8 dd fc ff ff       	call   801001 <syscall>
  801324:	83 c4 18             	add    $0x18,%esp
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	52                   	push   %edx
  801339:	50                   	push   %eax
  80133a:	6a 1e                	push   $0x1e
  80133c:	e8 c0 fc ff ff       	call   801001 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 1f                	push   $0x1f
  801355:	e8 a7 fc ff ff       	call   801001 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	6a 00                	push   $0x0
  801367:	ff 75 14             	pushl  0x14(%ebp)
  80136a:	ff 75 10             	pushl  0x10(%ebp)
  80136d:	ff 75 0c             	pushl  0xc(%ebp)
  801370:	50                   	push   %eax
  801371:	6a 20                	push   $0x20
  801373:	e8 89 fc ff ff       	call   801001 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	50                   	push   %eax
  80138c:	6a 21                	push   $0x21
  80138e:	e8 6e fc ff ff       	call   801001 <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	90                   	nop
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	50                   	push   %eax
  8013a8:	6a 22                	push   $0x22
  8013aa:	e8 52 fc ff ff       	call   801001 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 02                	push   $0x2
  8013c3:	e8 39 fc ff ff       	call   801001 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 03                	push   $0x3
  8013dc:	e8 20 fc ff ff       	call   801001 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 04                	push   $0x4
  8013f5:	e8 07 fc ff ff       	call   801001 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_exit_env>:


void sys_exit_env(void)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 23                	push   $0x23
  80140e:	e8 ee fb ff ff       	call   801001 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	90                   	nop
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80141f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801422:	8d 50 04             	lea    0x4(%eax),%edx
  801425:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	6a 24                	push   $0x24
  801432:	e8 ca fb ff ff       	call   801001 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
	return result;
  80143a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801440:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801443:	89 01                	mov    %eax,(%ecx)
  801445:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	c9                   	leave  
  80144c:	c2 04 00             	ret    $0x4

0080144f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	ff 75 10             	pushl  0x10(%ebp)
  801459:	ff 75 0c             	pushl  0xc(%ebp)
  80145c:	ff 75 08             	pushl  0x8(%ebp)
  80145f:	6a 12                	push   $0x12
  801461:	e8 9b fb ff ff       	call   801001 <syscall>
  801466:	83 c4 18             	add    $0x18,%esp
	return ;
  801469:	90                   	nop
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_rcr2>:
uint32 sys_rcr2()
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 25                	push   $0x25
  80147b:	e8 81 fb ff ff       	call   801001 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801491:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	50                   	push   %eax
  80149e:	6a 26                	push   $0x26
  8014a0:	e8 5c fb ff ff       	call   801001 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a8:	90                   	nop
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <rsttst>:
void rsttst()
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 28                	push   $0x28
  8014ba:	e8 42 fb ff ff       	call   801001 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c2:	90                   	nop
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014d1:	8b 55 18             	mov    0x18(%ebp),%edx
  8014d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d8:	52                   	push   %edx
  8014d9:	50                   	push   %eax
  8014da:	ff 75 10             	pushl  0x10(%ebp)
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	6a 27                	push   $0x27
  8014e5:	e8 17 fb ff ff       	call   801001 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ed:	90                   	nop
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <chktst>:
void chktst(uint32 n)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	ff 75 08             	pushl  0x8(%ebp)
  8014fe:	6a 29                	push   $0x29
  801500:	e8 fc fa ff ff       	call   801001 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
	return ;
  801508:	90                   	nop
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <inctst>:

void inctst()
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 2a                	push   $0x2a
  80151a:	e8 e2 fa ff ff       	call   801001 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
	return ;
  801522:	90                   	nop
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <gettst>:
uint32 gettst()
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 2b                	push   $0x2b
  801534:	e8 c8 fa ff ff       	call   801001 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 2c                	push   $0x2c
  801550:	e8 ac fa ff ff       	call   801001 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
  801558:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80155b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80155f:	75 07                	jne    801568 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801561:	b8 01 00 00 00       	mov    $0x1,%eax
  801566:	eb 05                	jmp    80156d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 2c                	push   $0x2c
  801581:	e8 7b fa ff ff       	call   801001 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
  801589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80158c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801590:	75 07                	jne    801599 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801592:	b8 01 00 00 00       	mov    $0x1,%eax
  801597:	eb 05                	jmp    80159e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 2c                	push   $0x2c
  8015b2:	e8 4a fa ff ff       	call   801001 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
  8015ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015bd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015c1:	75 07                	jne    8015ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c8:	eb 05                	jmp    8015cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 2c                	push   $0x2c
  8015e3:	e8 19 fa ff ff       	call   801001 <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
  8015eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015f2:	75 07                	jne    8015fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f9:	eb 05                	jmp    801600 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	6a 2d                	push   $0x2d
  801612:	e8 ea f9 ff ff       	call   801001 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
	return ;
  80161a:	90                   	nop
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801621:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801624:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	6a 00                	push   $0x0
  80162f:	53                   	push   %ebx
  801630:	51                   	push   %ecx
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 2e                	push   $0x2e
  801635:	e8 c7 f9 ff ff       	call   801001 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	52                   	push   %edx
  801652:	50                   	push   %eax
  801653:	6a 2f                	push   $0x2f
  801655:	e8 a7 f9 ff ff       	call   801001 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    
  80165f:	90                   	nop

00801660 <__udivdi3>:
  801660:	55                   	push   %ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 1c             	sub    $0x1c,%esp
  801667:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80166b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80166f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801673:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801677:	89 ca                	mov    %ecx,%edx
  801679:	89 f8                	mov    %edi,%eax
  80167b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80167f:	85 f6                	test   %esi,%esi
  801681:	75 2d                	jne    8016b0 <__udivdi3+0x50>
  801683:	39 cf                	cmp    %ecx,%edi
  801685:	77 65                	ja     8016ec <__udivdi3+0x8c>
  801687:	89 fd                	mov    %edi,%ebp
  801689:	85 ff                	test   %edi,%edi
  80168b:	75 0b                	jne    801698 <__udivdi3+0x38>
  80168d:	b8 01 00 00 00       	mov    $0x1,%eax
  801692:	31 d2                	xor    %edx,%edx
  801694:	f7 f7                	div    %edi
  801696:	89 c5                	mov    %eax,%ebp
  801698:	31 d2                	xor    %edx,%edx
  80169a:	89 c8                	mov    %ecx,%eax
  80169c:	f7 f5                	div    %ebp
  80169e:	89 c1                	mov    %eax,%ecx
  8016a0:	89 d8                	mov    %ebx,%eax
  8016a2:	f7 f5                	div    %ebp
  8016a4:	89 cf                	mov    %ecx,%edi
  8016a6:	89 fa                	mov    %edi,%edx
  8016a8:	83 c4 1c             	add    $0x1c,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    
  8016b0:	39 ce                	cmp    %ecx,%esi
  8016b2:	77 28                	ja     8016dc <__udivdi3+0x7c>
  8016b4:	0f bd fe             	bsr    %esi,%edi
  8016b7:	83 f7 1f             	xor    $0x1f,%edi
  8016ba:	75 40                	jne    8016fc <__udivdi3+0x9c>
  8016bc:	39 ce                	cmp    %ecx,%esi
  8016be:	72 0a                	jb     8016ca <__udivdi3+0x6a>
  8016c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8016c4:	0f 87 9e 00 00 00    	ja     801768 <__udivdi3+0x108>
  8016ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8016cf:	89 fa                	mov    %edi,%edx
  8016d1:	83 c4 1c             	add    $0x1c,%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5f                   	pop    %edi
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    
  8016d9:	8d 76 00             	lea    0x0(%esi),%esi
  8016dc:	31 ff                	xor    %edi,%edi
  8016de:	31 c0                	xor    %eax,%eax
  8016e0:	89 fa                	mov    %edi,%edx
  8016e2:	83 c4 1c             	add    $0x1c,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
  8016ea:	66 90                	xchg   %ax,%ax
  8016ec:	89 d8                	mov    %ebx,%eax
  8016ee:	f7 f7                	div    %edi
  8016f0:	31 ff                	xor    %edi,%edi
  8016f2:	89 fa                	mov    %edi,%edx
  8016f4:	83 c4 1c             	add    $0x1c,%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    
  8016fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801701:	89 eb                	mov    %ebp,%ebx
  801703:	29 fb                	sub    %edi,%ebx
  801705:	89 f9                	mov    %edi,%ecx
  801707:	d3 e6                	shl    %cl,%esi
  801709:	89 c5                	mov    %eax,%ebp
  80170b:	88 d9                	mov    %bl,%cl
  80170d:	d3 ed                	shr    %cl,%ebp
  80170f:	89 e9                	mov    %ebp,%ecx
  801711:	09 f1                	or     %esi,%ecx
  801713:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801717:	89 f9                	mov    %edi,%ecx
  801719:	d3 e0                	shl    %cl,%eax
  80171b:	89 c5                	mov    %eax,%ebp
  80171d:	89 d6                	mov    %edx,%esi
  80171f:	88 d9                	mov    %bl,%cl
  801721:	d3 ee                	shr    %cl,%esi
  801723:	89 f9                	mov    %edi,%ecx
  801725:	d3 e2                	shl    %cl,%edx
  801727:	8b 44 24 08          	mov    0x8(%esp),%eax
  80172b:	88 d9                	mov    %bl,%cl
  80172d:	d3 e8                	shr    %cl,%eax
  80172f:	09 c2                	or     %eax,%edx
  801731:	89 d0                	mov    %edx,%eax
  801733:	89 f2                	mov    %esi,%edx
  801735:	f7 74 24 0c          	divl   0xc(%esp)
  801739:	89 d6                	mov    %edx,%esi
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	f7 e5                	mul    %ebp
  80173f:	39 d6                	cmp    %edx,%esi
  801741:	72 19                	jb     80175c <__udivdi3+0xfc>
  801743:	74 0b                	je     801750 <__udivdi3+0xf0>
  801745:	89 d8                	mov    %ebx,%eax
  801747:	31 ff                	xor    %edi,%edi
  801749:	e9 58 ff ff ff       	jmp    8016a6 <__udivdi3+0x46>
  80174e:	66 90                	xchg   %ax,%ax
  801750:	8b 54 24 08          	mov    0x8(%esp),%edx
  801754:	89 f9                	mov    %edi,%ecx
  801756:	d3 e2                	shl    %cl,%edx
  801758:	39 c2                	cmp    %eax,%edx
  80175a:	73 e9                	jae    801745 <__udivdi3+0xe5>
  80175c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80175f:	31 ff                	xor    %edi,%edi
  801761:	e9 40 ff ff ff       	jmp    8016a6 <__udivdi3+0x46>
  801766:	66 90                	xchg   %ax,%ax
  801768:	31 c0                	xor    %eax,%eax
  80176a:	e9 37 ff ff ff       	jmp    8016a6 <__udivdi3+0x46>
  80176f:	90                   	nop

00801770 <__umoddi3>:
  801770:	55                   	push   %ebp
  801771:	57                   	push   %edi
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
  801774:	83 ec 1c             	sub    $0x1c,%esp
  801777:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80177b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80177f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801783:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801787:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80178b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80178f:	89 f3                	mov    %esi,%ebx
  801791:	89 fa                	mov    %edi,%edx
  801793:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801797:	89 34 24             	mov    %esi,(%esp)
  80179a:	85 c0                	test   %eax,%eax
  80179c:	75 1a                	jne    8017b8 <__umoddi3+0x48>
  80179e:	39 f7                	cmp    %esi,%edi
  8017a0:	0f 86 a2 00 00 00    	jbe    801848 <__umoddi3+0xd8>
  8017a6:	89 c8                	mov    %ecx,%eax
  8017a8:	89 f2                	mov    %esi,%edx
  8017aa:	f7 f7                	div    %edi
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	31 d2                	xor    %edx,%edx
  8017b0:	83 c4 1c             	add    $0x1c,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
  8017b8:	39 f0                	cmp    %esi,%eax
  8017ba:	0f 87 ac 00 00 00    	ja     80186c <__umoddi3+0xfc>
  8017c0:	0f bd e8             	bsr    %eax,%ebp
  8017c3:	83 f5 1f             	xor    $0x1f,%ebp
  8017c6:	0f 84 ac 00 00 00    	je     801878 <__umoddi3+0x108>
  8017cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8017d1:	29 ef                	sub    %ebp,%edi
  8017d3:	89 fe                	mov    %edi,%esi
  8017d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017d9:	89 e9                	mov    %ebp,%ecx
  8017db:	d3 e0                	shl    %cl,%eax
  8017dd:	89 d7                	mov    %edx,%edi
  8017df:	89 f1                	mov    %esi,%ecx
  8017e1:	d3 ef                	shr    %cl,%edi
  8017e3:	09 c7                	or     %eax,%edi
  8017e5:	89 e9                	mov    %ebp,%ecx
  8017e7:	d3 e2                	shl    %cl,%edx
  8017e9:	89 14 24             	mov    %edx,(%esp)
  8017ec:	89 d8                	mov    %ebx,%eax
  8017ee:	d3 e0                	shl    %cl,%eax
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017f6:	d3 e0                	shl    %cl,%eax
  8017f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801800:	89 f1                	mov    %esi,%ecx
  801802:	d3 e8                	shr    %cl,%eax
  801804:	09 d0                	or     %edx,%eax
  801806:	d3 eb                	shr    %cl,%ebx
  801808:	89 da                	mov    %ebx,%edx
  80180a:	f7 f7                	div    %edi
  80180c:	89 d3                	mov    %edx,%ebx
  80180e:	f7 24 24             	mull   (%esp)
  801811:	89 c6                	mov    %eax,%esi
  801813:	89 d1                	mov    %edx,%ecx
  801815:	39 d3                	cmp    %edx,%ebx
  801817:	0f 82 87 00 00 00    	jb     8018a4 <__umoddi3+0x134>
  80181d:	0f 84 91 00 00 00    	je     8018b4 <__umoddi3+0x144>
  801823:	8b 54 24 04          	mov    0x4(%esp),%edx
  801827:	29 f2                	sub    %esi,%edx
  801829:	19 cb                	sbb    %ecx,%ebx
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801831:	d3 e0                	shl    %cl,%eax
  801833:	89 e9                	mov    %ebp,%ecx
  801835:	d3 ea                	shr    %cl,%edx
  801837:	09 d0                	or     %edx,%eax
  801839:	89 e9                	mov    %ebp,%ecx
  80183b:	d3 eb                	shr    %cl,%ebx
  80183d:	89 da                	mov    %ebx,%edx
  80183f:	83 c4 1c             	add    $0x1c,%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5f                   	pop    %edi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    
  801847:	90                   	nop
  801848:	89 fd                	mov    %edi,%ebp
  80184a:	85 ff                	test   %edi,%edi
  80184c:	75 0b                	jne    801859 <__umoddi3+0xe9>
  80184e:	b8 01 00 00 00       	mov    $0x1,%eax
  801853:	31 d2                	xor    %edx,%edx
  801855:	f7 f7                	div    %edi
  801857:	89 c5                	mov    %eax,%ebp
  801859:	89 f0                	mov    %esi,%eax
  80185b:	31 d2                	xor    %edx,%edx
  80185d:	f7 f5                	div    %ebp
  80185f:	89 c8                	mov    %ecx,%eax
  801861:	f7 f5                	div    %ebp
  801863:	89 d0                	mov    %edx,%eax
  801865:	e9 44 ff ff ff       	jmp    8017ae <__umoddi3+0x3e>
  80186a:	66 90                	xchg   %ax,%ax
  80186c:	89 c8                	mov    %ecx,%eax
  80186e:	89 f2                	mov    %esi,%edx
  801870:	83 c4 1c             	add    $0x1c,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
  801878:	3b 04 24             	cmp    (%esp),%eax
  80187b:	72 06                	jb     801883 <__umoddi3+0x113>
  80187d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801881:	77 0f                	ja     801892 <__umoddi3+0x122>
  801883:	89 f2                	mov    %esi,%edx
  801885:	29 f9                	sub    %edi,%ecx
  801887:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80188b:	89 14 24             	mov    %edx,(%esp)
  80188e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801892:	8b 44 24 04          	mov    0x4(%esp),%eax
  801896:	8b 14 24             	mov    (%esp),%edx
  801899:	83 c4 1c             	add    $0x1c,%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5f                   	pop    %edi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    
  8018a1:	8d 76 00             	lea    0x0(%esi),%esi
  8018a4:	2b 04 24             	sub    (%esp),%eax
  8018a7:	19 fa                	sbb    %edi,%edx
  8018a9:	89 d1                	mov    %edx,%ecx
  8018ab:	89 c6                	mov    %eax,%esi
  8018ad:	e9 71 ff ff ff       	jmp    801823 <__umoddi3+0xb3>
  8018b2:	66 90                	xchg   %ax,%ax
  8018b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018b8:	72 ea                	jb     8018a4 <__umoddi3+0x134>
  8018ba:	89 d9                	mov    %ebx,%ecx
  8018bc:	e9 62 ff ff ff       	jmp    801823 <__umoddi3+0xb3>
