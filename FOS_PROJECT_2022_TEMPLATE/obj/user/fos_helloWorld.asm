
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);		
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 e0 18 80 00       	push   $0x8018e0
  800046:	e8 6c 02 00 00       	call   8002b7 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 d5 18 80 00       	mov    0x8018d5,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 08 19 80 00       	push   $0x801908
  80005c:	e8 56 02 00 00       	call   8002b7 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 6e 13 00 00       	call   8013e0 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	01 c0                	add    %eax,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800085:	01 c8                	add    %ecx,%eax
  800087:	c1 e0 02             	shl    $0x2,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800093:	01 c8                	add    %ecx,%eax
  800095:	c1 e0 02             	shl    $0x2,%eax
  800098:	01 d0                	add    %edx,%eax
  80009a:	c1 e0 02             	shl    $0x2,%eax
  80009d:	01 d0                	add    %edx,%eax
  80009f:	c1 e0 03             	shl    $0x3,%eax
  8000a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a7:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ac:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b1:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000b7:	84 c0                	test   %al,%al
  8000b9:	74 0f                	je     8000ca <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000bb:	a1 20 20 80 00       	mov    0x802020,%eax
  8000c0:	05 18 da 01 00       	add    $0x1da18,%eax
  8000c5:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ce:	7e 0a                	jle    8000da <libmain+0x73>
		binaryname = argv[0];
  8000d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d3:	8b 00                	mov    (%eax),%eax
  8000d5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	ff 75 0c             	pushl  0xc(%ebp)
  8000e0:	ff 75 08             	pushl  0x8(%ebp)
  8000e3:	e8 50 ff ff ff       	call   800038 <_main>
  8000e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000eb:	e8 fd 10 00 00       	call   8011ed <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	68 34 19 80 00       	push   $0x801934
  8000f8:	e8 8d 01 00 00       	call   80028a <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800100:	a1 20 20 80 00       	mov    0x802020,%eax
  800105:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80010b:	a1 20 20 80 00       	mov    0x802020,%eax
  800110:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800116:	83 ec 04             	sub    $0x4,%esp
  800119:	52                   	push   %edx
  80011a:	50                   	push   %eax
  80011b:	68 5c 19 80 00       	push   $0x80195c
  800120:	e8 65 01 00 00       	call   80028a <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800128:	a1 20 20 80 00       	mov    0x802020,%eax
  80012d:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800133:	a1 20 20 80 00       	mov    0x802020,%eax
  800138:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80013e:	a1 20 20 80 00       	mov    0x802020,%eax
  800143:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800149:	51                   	push   %ecx
  80014a:	52                   	push   %edx
  80014b:	50                   	push   %eax
  80014c:	68 84 19 80 00       	push   $0x801984
  800151:	e8 34 01 00 00       	call   80028a <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800159:	a1 20 20 80 00       	mov    0x802020,%eax
  80015e:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	50                   	push   %eax
  800168:	68 dc 19 80 00       	push   $0x8019dc
  80016d:	e8 18 01 00 00       	call   80028a <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 34 19 80 00       	push   $0x801934
  80017d:	e8 08 01 00 00       	call   80028a <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800185:	e8 7d 10 00 00       	call   801207 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80018a:	e8 19 00 00 00       	call   8001a8 <exit>
}
  80018f:	90                   	nop
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	6a 00                	push   $0x0
  80019d:	e8 0a 12 00 00       	call   8013ac <sys_destroy_env>
  8001a2:	83 c4 10             	add    $0x10,%esp
}
  8001a5:	90                   	nop
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <exit>:

void
exit(void)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ae:	e8 5f 12 00 00       	call   801412 <sys_exit_env>
}
  8001b3:	90                   	nop
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bf:	8b 00                	mov    (%eax),%eax
  8001c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c7:	89 0a                	mov    %ecx,(%edx)
  8001c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cc:	88 d1                	mov    %dl,%cl
  8001ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d8:	8b 00                	mov    (%eax),%eax
  8001da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001df:	75 2c                	jne    80020d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001e1:	a0 24 20 80 00       	mov    0x802024,%al
  8001e6:	0f b6 c0             	movzbl %al,%eax
  8001e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ec:	8b 12                	mov    (%edx),%edx
  8001ee:	89 d1                	mov    %edx,%ecx
  8001f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f3:	83 c2 08             	add    $0x8,%edx
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	50                   	push   %eax
  8001fa:	51                   	push   %ecx
  8001fb:	52                   	push   %edx
  8001fc:	e8 3e 0e 00 00       	call   80103f <sys_cputs>
  800201:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	8b 40 04             	mov    0x4(%eax),%eax
  800213:	8d 50 01             	lea    0x1(%eax),%edx
  800216:	8b 45 0c             	mov    0xc(%ebp),%eax
  800219:	89 50 04             	mov    %edx,0x4(%eax)
}
  80021c:	90                   	nop
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

0080021f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800228:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022f:	00 00 00 
	b.cnt = 0;
  800232:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800239:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800248:	50                   	push   %eax
  800249:	68 b6 01 80 00       	push   $0x8001b6
  80024e:	e8 11 02 00 00       	call   800464 <vprintfmt>
  800253:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800256:	a0 24 20 80 00       	mov    0x802024,%al
  80025b:	0f b6 c0             	movzbl %al,%eax
  80025e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	50                   	push   %eax
  800268:	52                   	push   %edx
  800269:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026f:	83 c0 08             	add    $0x8,%eax
  800272:	50                   	push   %eax
  800273:	e8 c7 0d 00 00       	call   80103f <sys_cputs>
  800278:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80027b:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800282:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <cprintf>:

int cprintf(const char *fmt, ...) {
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800290:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800297:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a6:	50                   	push   %eax
  8002a7:	e8 73 ff ff ff       	call   80021f <vcprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002bd:	e8 2b 0f 00 00       	call   8011ed <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d1:	50                   	push   %eax
  8002d2:	e8 48 ff ff ff       	call   80021f <vcprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002dd:	e8 25 0f 00 00       	call   801207 <sys_enable_interrupt>
	return cnt;
  8002e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 14             	sub    $0x14,%esp
  8002ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800302:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800305:	77 55                	ja     80035c <printnum+0x75>
  800307:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80030a:	72 05                	jb     800311 <printnum+0x2a>
  80030c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80030f:	77 4b                	ja     80035c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800311:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800314:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800317:	8b 45 18             	mov    0x18(%ebp),%eax
  80031a:	ba 00 00 00 00       	mov    $0x0,%edx
  80031f:	52                   	push   %edx
  800320:	50                   	push   %eax
  800321:	ff 75 f4             	pushl  -0xc(%ebp)
  800324:	ff 75 f0             	pushl  -0x10(%ebp)
  800327:	e8 48 13 00 00       	call   801674 <__udivdi3>
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	83 ec 04             	sub    $0x4,%esp
  800332:	ff 75 20             	pushl  0x20(%ebp)
  800335:	53                   	push   %ebx
  800336:	ff 75 18             	pushl  0x18(%ebp)
  800339:	52                   	push   %edx
  80033a:	50                   	push   %eax
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	e8 a1 ff ff ff       	call   8002e7 <printnum>
  800346:	83 c4 20             	add    $0x20,%esp
  800349:	eb 1a                	jmp    800365 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 20             	pushl  0x20(%ebp)
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	ff d0                	call   *%eax
  800359:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80035c:	ff 4d 1c             	decl   0x1c(%ebp)
  80035f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800363:	7f e6                	jg     80034b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800365:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800368:	bb 00 00 00 00       	mov    $0x0,%ebx
  80036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800373:	53                   	push   %ebx
  800374:	51                   	push   %ecx
  800375:	52                   	push   %edx
  800376:	50                   	push   %eax
  800377:	e8 08 14 00 00       	call   801784 <__umoddi3>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	05 14 1c 80 00       	add    $0x801c14,%eax
  800384:	8a 00                	mov    (%eax),%al
  800386:	0f be c0             	movsbl %al,%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	ff d0                	call   *%eax
  800395:	83 c4 10             	add    $0x10,%esp
}
  800398:	90                   	nop
  800399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003a5:	7e 1c                	jle    8003c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	8d 50 08             	lea    0x8(%eax),%edx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	89 10                	mov    %edx,(%eax)
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	83 e8 08             	sub    $0x8,%eax
  8003bc:	8b 50 04             	mov    0x4(%eax),%edx
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	eb 40                	jmp    800403 <getuint+0x65>
	else if (lflag)
  8003c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003c7:	74 1e                	je     8003e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	8d 50 04             	lea    0x4(%eax),%edx
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	89 10                	mov    %edx,(%eax)
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	83 e8 04             	sub    $0x4,%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e5:	eb 1c                	jmp    800403 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	8d 50 04             	lea    0x4(%eax),%edx
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	89 10                	mov    %edx,(%eax)
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	83 e8 04             	sub    $0x4,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800408:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040c:	7e 1c                	jle    80042a <getint+0x25>
		return va_arg(*ap, long long);
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	8d 50 08             	lea    0x8(%eax),%edx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	89 10                	mov    %edx,(%eax)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	83 e8 08             	sub    $0x8,%eax
  800423:	8b 50 04             	mov    0x4(%eax),%edx
  800426:	8b 00                	mov    (%eax),%eax
  800428:	eb 38                	jmp    800462 <getint+0x5d>
	else if (lflag)
  80042a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042e:	74 1a                	je     80044a <getint+0x45>
		return va_arg(*ap, long);
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	8d 50 04             	lea    0x4(%eax),%edx
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	89 10                	mov    %edx,(%eax)
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	83 e8 04             	sub    $0x4,%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	99                   	cltd   
  800448:	eb 18                	jmp    800462 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	8d 50 04             	lea    0x4(%eax),%edx
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	89 10                	mov    %edx,(%eax)
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	83 e8 04             	sub    $0x4,%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	99                   	cltd   
}
  800462:	5d                   	pop    %ebp
  800463:	c3                   	ret    

00800464 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	56                   	push   %esi
  800468:	53                   	push   %ebx
  800469:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046c:	eb 17                	jmp    800485 <vprintfmt+0x21>
			if (ch == '\0')
  80046e:	85 db                	test   %ebx,%ebx
  800470:	0f 84 af 03 00 00    	je     800825 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 0c             	pushl  0xc(%ebp)
  80047c:	53                   	push   %ebx
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	ff d0                	call   *%eax
  800482:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800485:	8b 45 10             	mov    0x10(%ebp),%eax
  800488:	8d 50 01             	lea    0x1(%eax),%edx
  80048b:	89 55 10             	mov    %edx,0x10(%ebp)
  80048e:	8a 00                	mov    (%eax),%al
  800490:	0f b6 d8             	movzbl %al,%ebx
  800493:	83 fb 25             	cmp    $0x25,%ebx
  800496:	75 d6                	jne    80046e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800498:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80049c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c1:	8a 00                	mov    (%eax),%al
  8004c3:	0f b6 d8             	movzbl %al,%ebx
  8004c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004c9:	83 f8 55             	cmp    $0x55,%eax
  8004cc:	0f 87 2b 03 00 00    	ja     8007fd <vprintfmt+0x399>
  8004d2:	8b 04 85 38 1c 80 00 	mov    0x801c38(,%eax,4),%eax
  8004d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004df:	eb d7                	jmp    8004b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004e5:	eb d1                	jmp    8004b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f1:	89 d0                	mov    %edx,%eax
  8004f3:	c1 e0 02             	shl    $0x2,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	01 c0                	add    %eax,%eax
  8004fa:	01 d8                	add    %ebx,%eax
  8004fc:	83 e8 30             	sub    $0x30,%eax
  8004ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	8a 00                	mov    (%eax),%al
  800507:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80050a:	83 fb 2f             	cmp    $0x2f,%ebx
  80050d:	7e 3e                	jle    80054d <vprintfmt+0xe9>
  80050f:	83 fb 39             	cmp    $0x39,%ebx
  800512:	7f 39                	jg     80054d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800514:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800517:	eb d5                	jmp    8004ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	83 c0 04             	add    $0x4,%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	83 e8 04             	sub    $0x4,%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80052d:	eb 1f                	jmp    80054e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80052f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800533:	79 83                	jns    8004b8 <vprintfmt+0x54>
				width = 0;
  800535:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80053c:	e9 77 ff ff ff       	jmp    8004b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800541:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800548:	e9 6b ff ff ff       	jmp    8004b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80054d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80054e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800552:	0f 89 60 ff ff ff    	jns    8004b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800565:	e9 4e ff ff ff       	jmp    8004b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80056a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80056d:	e9 46 ff ff ff       	jmp    8004b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	83 c0 04             	add    $0x4,%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 e8 04             	sub    $0x4,%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	50                   	push   %eax
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	ff d0                	call   *%eax
  80058f:	83 c4 10             	add    $0x10,%esp
			break;
  800592:	e9 89 02 00 00       	jmp    800820 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	83 c0 04             	add    $0x4,%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	83 e8 04             	sub    $0x4,%eax
  8005a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005a8:	85 db                	test   %ebx,%ebx
  8005aa:	79 02                	jns    8005ae <vprintfmt+0x14a>
				err = -err;
  8005ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ae:	83 fb 64             	cmp    $0x64,%ebx
  8005b1:	7f 0b                	jg     8005be <vprintfmt+0x15a>
  8005b3:	8b 34 9d 80 1a 80 00 	mov    0x801a80(,%ebx,4),%esi
  8005ba:	85 f6                	test   %esi,%esi
  8005bc:	75 19                	jne    8005d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005be:	53                   	push   %ebx
  8005bf:	68 25 1c 80 00       	push   $0x801c25
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	ff 75 08             	pushl  0x8(%ebp)
  8005ca:	e8 5e 02 00 00       	call   80082d <printfmt>
  8005cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005d2:	e9 49 02 00 00       	jmp    800820 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005d7:	56                   	push   %esi
  8005d8:	68 2e 1c 80 00       	push   $0x801c2e
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	ff 75 08             	pushl  0x8(%ebp)
  8005e3:	e8 45 02 00 00       	call   80082d <printfmt>
  8005e8:	83 c4 10             	add    $0x10,%esp
			break;
  8005eb:	e9 30 02 00 00       	jmp    800820 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	83 c0 04             	add    $0x4,%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	83 e8 04             	sub    $0x4,%eax
  8005ff:	8b 30                	mov    (%eax),%esi
  800601:	85 f6                	test   %esi,%esi
  800603:	75 05                	jne    80060a <vprintfmt+0x1a6>
				p = "(null)";
  800605:	be 31 1c 80 00       	mov    $0x801c31,%esi
			if (width > 0 && padc != '-')
  80060a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060e:	7e 6d                	jle    80067d <vprintfmt+0x219>
  800610:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800614:	74 67                	je     80067d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	50                   	push   %eax
  80061d:	56                   	push   %esi
  80061e:	e8 0c 03 00 00       	call   80092f <strnlen>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800629:	eb 16                	jmp    800641 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80062b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	ff 75 0c             	pushl  0xc(%ebp)
  800635:	50                   	push   %eax
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	ff d0                	call   *%eax
  80063b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063e:	ff 4d e4             	decl   -0x1c(%ebp)
  800641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800645:	7f e4                	jg     80062b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800647:	eb 34                	jmp    80067d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800649:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80064d:	74 1c                	je     80066b <vprintfmt+0x207>
  80064f:	83 fb 1f             	cmp    $0x1f,%ebx
  800652:	7e 05                	jle    800659 <vprintfmt+0x1f5>
  800654:	83 fb 7e             	cmp    $0x7e,%ebx
  800657:	7e 12                	jle    80066b <vprintfmt+0x207>
					putch('?', putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	6a 3f                	push   $0x3f
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	eb 0f                	jmp    80067a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	53                   	push   %ebx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	ff d0                	call   *%eax
  800677:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067a:	ff 4d e4             	decl   -0x1c(%ebp)
  80067d:	89 f0                	mov    %esi,%eax
  80067f:	8d 70 01             	lea    0x1(%eax),%esi
  800682:	8a 00                	mov    (%eax),%al
  800684:	0f be d8             	movsbl %al,%ebx
  800687:	85 db                	test   %ebx,%ebx
  800689:	74 24                	je     8006af <vprintfmt+0x24b>
  80068b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068f:	78 b8                	js     800649 <vprintfmt+0x1e5>
  800691:	ff 4d e0             	decl   -0x20(%ebp)
  800694:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800698:	79 af                	jns    800649 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80069a:	eb 13                	jmp    8006af <vprintfmt+0x24b>
				putch(' ', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	6a 20                	push   $0x20
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8006af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b3:	7f e7                	jg     80069c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006b5:	e9 66 01 00 00       	jmp    800820 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8006c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	e8 3c fd ff ff       	call   800405 <getint>
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d8:	85 d2                	test   %edx,%edx
  8006da:	79 23                	jns    8006ff <vprintfmt+0x29b>
				putch('-', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	6a 2d                	push   $0x2d
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	ff d0                	call   *%eax
  8006e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f2:	f7 d8                	neg    %eax
  8006f4:	83 d2 00             	adc    $0x0,%edx
  8006f7:	f7 da                	neg    %edx
  8006f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800706:	e9 bc 00 00 00       	jmp    8007c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 e8             	pushl  -0x18(%ebp)
  800711:	8d 45 14             	lea    0x14(%ebp),%eax
  800714:	50                   	push   %eax
  800715:	e8 84 fc ff ff       	call   80039e <getuint>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800720:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800723:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80072a:	e9 98 00 00 00       	jmp    8007c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 58                	push   $0x58
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 0c             	pushl  0xc(%ebp)
  800745:	6a 58                	push   $0x58
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	ff d0                	call   *%eax
  80074c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	6a 58                	push   $0x58
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
			break;
  80075f:	e9 bc 00 00 00       	jmp    800820 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 30                	push   $0x30
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	6a 78                	push   $0x78
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	ff d0                	call   *%eax
  800781:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	83 c0 04             	add    $0x4,%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	83 e8 04             	sub    $0x4,%eax
  800793:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800795:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80079f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007a6:	eb 1f                	jmp    8007c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b1:	50                   	push   %eax
  8007b2:	e8 e7 fb ff ff       	call   80039e <getuint>
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	52                   	push   %edx
  8007d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007dc:	ff 75 0c             	pushl  0xc(%ebp)
  8007df:	ff 75 08             	pushl  0x8(%ebp)
  8007e2:	e8 00 fb ff ff       	call   8002e7 <printnum>
  8007e7:	83 c4 20             	add    $0x20,%esp
			break;
  8007ea:	eb 34                	jmp    800820 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	53                   	push   %ebx
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	ff d0                	call   *%eax
  8007f8:	83 c4 10             	add    $0x10,%esp
			break;
  8007fb:	eb 23                	jmp    800820 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 25                	push   $0x25
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080d:	ff 4d 10             	decl   0x10(%ebp)
  800810:	eb 03                	jmp    800815 <vprintfmt+0x3b1>
  800812:	ff 4d 10             	decl   0x10(%ebp)
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	48                   	dec    %eax
  800819:	8a 00                	mov    (%eax),%al
  80081b:	3c 25                	cmp    $0x25,%al
  80081d:	75 f3                	jne    800812 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80081f:	90                   	nop
		}
	}
  800820:	e9 47 fc ff ff       	jmp    80046c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800825:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800826:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800829:	5b                   	pop    %ebx
  80082a:	5e                   	pop    %esi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800833:	8d 45 10             	lea    0x10(%ebp),%eax
  800836:	83 c0 04             	add    $0x4,%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80083c:	8b 45 10             	mov    0x10(%ebp),%eax
  80083f:	ff 75 f4             	pushl  -0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	ff 75 08             	pushl  0x8(%ebp)
  800849:	e8 16 fc ff ff       	call   800464 <vprintfmt>
  80084e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800851:	90                   	nop
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085a:	8b 40 08             	mov    0x8(%eax),%eax
  80085d:	8d 50 01             	lea    0x1(%eax),%edx
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800866:	8b 45 0c             	mov    0xc(%ebp),%eax
  800869:	8b 10                	mov    (%eax),%edx
  80086b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086e:	8b 40 04             	mov    0x4(%eax),%eax
  800871:	39 c2                	cmp    %eax,%edx
  800873:	73 12                	jae    800887 <sprintputch+0x33>
		*b->buf++ = ch;
  800875:	8b 45 0c             	mov    0xc(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	8d 48 01             	lea    0x1(%eax),%ecx
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800880:	89 0a                	mov    %ecx,(%edx)
  800882:	8b 55 08             	mov    0x8(%ebp),%edx
  800885:	88 10                	mov    %dl,(%eax)
}
  800887:	90                   	nop
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800896:	8b 45 0c             	mov    0xc(%ebp),%eax
  800899:	8d 50 ff             	lea    -0x1(%eax),%edx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	01 d0                	add    %edx,%eax
  8008a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008af:	74 06                	je     8008b7 <vsnprintf+0x2d>
  8008b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b5:	7f 07                	jg     8008be <vsnprintf+0x34>
		return -E_INVAL;
  8008b7:	b8 03 00 00 00       	mov    $0x3,%eax
  8008bc:	eb 20                	jmp    8008de <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008be:	ff 75 14             	pushl  0x14(%ebp)
  8008c1:	ff 75 10             	pushl  0x10(%ebp)
  8008c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c7:	50                   	push   %eax
  8008c8:	68 54 08 80 00       	push   $0x800854
  8008cd:	e8 92 fb ff ff       	call   800464 <vprintfmt>
  8008d2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e9:	83 c0 04             	add    $0x4,%eax
  8008ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	ff 75 08             	pushl  0x8(%ebp)
  8008fc:	e8 89 ff ff ff       	call   80088a <vsnprintf>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800907:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800912:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800919:	eb 06                	jmp    800921 <strlen+0x15>
		n++;
  80091b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80091e:	ff 45 08             	incl   0x8(%ebp)
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8a 00                	mov    (%eax),%al
  800926:	84 c0                	test   %al,%al
  800928:	75 f1                	jne    80091b <strlen+0xf>
		n++;
	return n;
  80092a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800935:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80093c:	eb 09                	jmp    800947 <strnlen+0x18>
		n++;
  80093e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800941:	ff 45 08             	incl   0x8(%ebp)
  800944:	ff 4d 0c             	decl   0xc(%ebp)
  800947:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094b:	74 09                	je     800956 <strnlen+0x27>
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8a 00                	mov    (%eax),%al
  800952:	84 c0                	test   %al,%al
  800954:	75 e8                	jne    80093e <strnlen+0xf>
		n++;
	return n;
  800956:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800967:	90                   	nop
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8d 50 01             	lea    0x1(%eax),%edx
  80096e:	89 55 08             	mov    %edx,0x8(%ebp)
  800971:	8b 55 0c             	mov    0xc(%ebp),%edx
  800974:	8d 4a 01             	lea    0x1(%edx),%ecx
  800977:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80097a:	8a 12                	mov    (%edx),%dl
  80097c:	88 10                	mov    %dl,(%eax)
  80097e:	8a 00                	mov    (%eax),%al
  800980:	84 c0                	test   %al,%al
  800982:	75 e4                	jne    800968 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800984:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800995:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80099c:	eb 1f                	jmp    8009bd <strncpy+0x34>
		*dst++ = *src;
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8d 50 01             	lea    0x1(%eax),%edx
  8009a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	8a 12                	mov    (%edx),%dl
  8009ac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	84 c0                	test   %al,%al
  8009b5:	74 03                	je     8009ba <strncpy+0x31>
			src++;
  8009b7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ba:	ff 45 fc             	incl   -0x4(%ebp)
  8009bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009c3:	72 d9                	jb     80099e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009da:	74 30                	je     800a0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009dc:	eb 16                	jmp    8009f4 <strlcpy+0x2a>
			*dst++ = *src++;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f0:	8a 12                	mov    (%edx),%dl
  8009f2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f4:	ff 4d 10             	decl   0x10(%ebp)
  8009f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fb:	74 09                	je     800a06 <strlcpy+0x3c>
  8009fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	75 d8                	jne    8009de <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a12:	29 c2                	sub    %eax,%edx
  800a14:	89 d0                	mov    %edx,%eax
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a1b:	eb 06                	jmp    800a23 <strcmp+0xb>
		p++, q++;
  800a1d:	ff 45 08             	incl   0x8(%ebp)
  800a20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8a 00                	mov    (%eax),%al
  800a28:	84 c0                	test   %al,%al
  800a2a:	74 0e                	je     800a3a <strcmp+0x22>
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8a 10                	mov    (%eax),%dl
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	38 c2                	cmp    %al,%dl
  800a38:	74 e3                	je     800a1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8a 00                	mov    (%eax),%al
  800a3f:	0f b6 d0             	movzbl %al,%edx
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8a 00                	mov    (%eax),%al
  800a47:	0f b6 c0             	movzbl %al,%eax
  800a4a:	29 c2                	sub    %eax,%edx
  800a4c:	89 d0                	mov    %edx,%eax
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a53:	eb 09                	jmp    800a5e <strncmp+0xe>
		n--, p++, q++;
  800a55:	ff 4d 10             	decl   0x10(%ebp)
  800a58:	ff 45 08             	incl   0x8(%ebp)
  800a5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a62:	74 17                	je     800a7b <strncmp+0x2b>
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	84 c0                	test   %al,%al
  800a6b:	74 0e                	je     800a7b <strncmp+0x2b>
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8a 10                	mov    (%eax),%dl
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	38 c2                	cmp    %al,%dl
  800a79:	74 da                	je     800a55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a7f:	75 07                	jne    800a88 <strncmp+0x38>
		return 0;
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	eb 14                	jmp    800a9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	0f b6 d0             	movzbl %al,%edx
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	0f b6 c0             	movzbl %al,%eax
  800a98:	29 c2                	sub    %eax,%edx
  800a9a:	89 d0                	mov    %edx,%eax
}
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aaa:	eb 12                	jmp    800abe <strchr+0x20>
		if (*s == c)
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab4:	75 05                	jne    800abb <strchr+0x1d>
			return (char *) s;
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	eb 11                	jmp    800acc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800abb:	ff 45 08             	incl   0x8(%ebp)
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	84 c0                	test   %al,%al
  800ac5:	75 e5                	jne    800aac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acc:	c9                   	leave  
  800acd:	c3                   	ret    

00800ace <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ada:	eb 0d                	jmp    800ae9 <strfind+0x1b>
		if (*s == c)
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8a 00                	mov    (%eax),%al
  800ae1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae4:	74 0e                	je     800af4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ae6:	ff 45 08             	incl   0x8(%ebp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8a 00                	mov    (%eax),%al
  800aee:	84 c0                	test   %al,%al
  800af0:	75 ea                	jne    800adc <strfind+0xe>
  800af2:	eb 01                	jmp    800af5 <strfind+0x27>
		if (*s == c)
			break;
  800af4:	90                   	nop
	return (char *) s;
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b06:	8b 45 10             	mov    0x10(%ebp),%eax
  800b09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b0c:	eb 0e                	jmp    800b1c <memset+0x22>
		*p++ = c;
  800b0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b11:	8d 50 01             	lea    0x1(%eax),%edx
  800b14:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b1c:	ff 4d f8             	decl   -0x8(%ebp)
  800b1f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b23:	79 e9                	jns    800b0e <memset+0x14>
		*p++ = c;

	return v;
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b3c:	eb 16                	jmp    800b54 <memcpy+0x2a>
		*d++ = *s++;
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	8d 50 01             	lea    0x1(%eax),%edx
  800b44:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b50:	8a 12                	mov    (%edx),%dl
  800b52:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	75 dd                	jne    800b3e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7e:	73 50                	jae    800bd0 <memmove+0x6a>
  800b80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b83:	8b 45 10             	mov    0x10(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8b:	76 43                	jbe    800bd0 <memmove+0x6a>
		s += n;
  800b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b90:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b93:	8b 45 10             	mov    0x10(%ebp),%eax
  800b96:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b99:	eb 10                	jmp    800bab <memmove+0x45>
			*--d = *--s;
  800b9b:	ff 4d f8             	decl   -0x8(%ebp)
  800b9e:	ff 4d fc             	decl   -0x4(%ebp)
  800ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba4:	8a 10                	mov    (%eax),%dl
  800ba6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb1:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb4:	85 c0                	test   %eax,%eax
  800bb6:	75 e3                	jne    800b9b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb8:	eb 23                	jmp    800bdd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbd:	8d 50 01             	lea    0x1(%eax),%edx
  800bc0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bcc:	8a 12                	mov    (%edx),%dl
  800bce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd6:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd9:	85 c0                	test   %eax,%eax
  800bdb:	75 dd                	jne    800bba <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bf4:	eb 2a                	jmp    800c20 <memcmp+0x3e>
		if (*s1 != *s2)
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf9:	8a 10                	mov    (%eax),%dl
  800bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	38 c2                	cmp    %al,%dl
  800c02:	74 16                	je     800c1a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	0f b6 d0             	movzbl %al,%edx
  800c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f b6 c0             	movzbl %al,%eax
  800c14:	29 c2                	sub    %eax,%edx
  800c16:	89 d0                	mov    %edx,%eax
  800c18:	eb 18                	jmp    800c32 <memcmp+0x50>
		s1++, s2++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
  800c1d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c20:	8b 45 10             	mov    0x10(%ebp),%eax
  800c23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c26:	89 55 10             	mov    %edx,0x10(%ebp)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	75 c9                	jne    800bf6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c40:	01 d0                	add    %edx,%eax
  800c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c45:	eb 15                	jmp    800c5c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	0f b6 d0             	movzbl %al,%edx
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	0f b6 c0             	movzbl %al,%eax
  800c55:	39 c2                	cmp    %eax,%edx
  800c57:	74 0d                	je     800c66 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c59:	ff 45 08             	incl   0x8(%ebp)
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c62:	72 e3                	jb     800c47 <memfind+0x13>
  800c64:	eb 01                	jmp    800c67 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c66:	90                   	nop
	return (void *) s;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c79:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c80:	eb 03                	jmp    800c85 <strtol+0x19>
		s++;
  800c82:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	3c 20                	cmp    $0x20,%al
  800c8c:	74 f4                	je     800c82 <strtol+0x16>
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	3c 09                	cmp    $0x9,%al
  800c95:	74 eb                	je     800c82 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3c 2b                	cmp    $0x2b,%al
  800c9e:	75 05                	jne    800ca5 <strtol+0x39>
		s++;
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	eb 13                	jmp    800cb8 <strtol+0x4c>
	else if (*s == '-')
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	3c 2d                	cmp    $0x2d,%al
  800cac:	75 0a                	jne    800cb8 <strtol+0x4c>
		s++, neg = 1;
  800cae:	ff 45 08             	incl   0x8(%ebp)
  800cb1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbc:	74 06                	je     800cc4 <strtol+0x58>
  800cbe:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cc2:	75 20                	jne    800ce4 <strtol+0x78>
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	3c 30                	cmp    $0x30,%al
  800ccb:	75 17                	jne    800ce4 <strtol+0x78>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	40                   	inc    %eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	3c 78                	cmp    $0x78,%al
  800cd5:	75 0d                	jne    800ce4 <strtol+0x78>
		s += 2, base = 16;
  800cd7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cdb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ce2:	eb 28                	jmp    800d0c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ce4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce8:	75 15                	jne    800cff <strtol+0x93>
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	3c 30                	cmp    $0x30,%al
  800cf1:	75 0c                	jne    800cff <strtol+0x93>
		s++, base = 8;
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cfd:	eb 0d                	jmp    800d0c <strtol+0xa0>
	else if (base == 0)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	75 07                	jne    800d0c <strtol+0xa0>
		base = 10;
  800d05:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	3c 2f                	cmp    $0x2f,%al
  800d13:	7e 19                	jle    800d2e <strtol+0xc2>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	3c 39                	cmp    $0x39,%al
  800d1c:	7f 10                	jg     800d2e <strtol+0xc2>
			dig = *s - '0';
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f be c0             	movsbl %al,%eax
  800d26:	83 e8 30             	sub    $0x30,%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d2c:	eb 42                	jmp    800d70 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3c 60                	cmp    $0x60,%al
  800d35:	7e 19                	jle    800d50 <strtol+0xe4>
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	3c 7a                	cmp    $0x7a,%al
  800d3e:	7f 10                	jg     800d50 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	0f be c0             	movsbl %al,%eax
  800d48:	83 e8 57             	sub    $0x57,%eax
  800d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d4e:	eb 20                	jmp    800d70 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 40                	cmp    $0x40,%al
  800d57:	7e 39                	jle    800d92 <strtol+0x126>
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 5a                	cmp    $0x5a,%al
  800d60:	7f 30                	jg     800d92 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f be c0             	movsbl %al,%eax
  800d6a:	83 e8 37             	sub    $0x37,%eax
  800d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d76:	7d 19                	jge    800d91 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d78:	ff 45 08             	incl   0x8(%ebp)
  800d7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d82:	89 c2                	mov    %eax,%edx
  800d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d87:	01 d0                	add    %edx,%eax
  800d89:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d8c:	e9 7b ff ff ff       	jmp    800d0c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d91:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d96:	74 08                	je     800da0 <strtol+0x134>
		*endptr = (char *) s;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da4:	74 07                	je     800dad <strtol+0x141>
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da9:	f7 d8                	neg    %eax
  800dab:	eb 03                	jmp    800db0 <strtol+0x144>
  800dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <ltostr>:

void
ltostr(long value, char *str)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dca:	79 13                	jns    800ddf <ltostr+0x2d>
	{
		neg = 1;
  800dcc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dd9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ddc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de7:	99                   	cltd   
  800de8:	f7 f9                	idiv   %ecx
  800dea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ded:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df0:	8d 50 01             	lea    0x1(%eax),%edx
  800df3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df6:	89 c2                	mov    %eax,%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	01 d0                	add    %edx,%eax
  800dfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e00:	83 c2 30             	add    $0x30,%edx
  800e03:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e08:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0d:	f7 e9                	imul   %ecx
  800e0f:	c1 fa 02             	sar    $0x2,%edx
  800e12:	89 c8                	mov    %ecx,%eax
  800e14:	c1 f8 1f             	sar    $0x1f,%eax
  800e17:	29 c2                	sub    %eax,%edx
  800e19:	89 d0                	mov    %edx,%eax
  800e1b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e21:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e26:	f7 e9                	imul   %ecx
  800e28:	c1 fa 02             	sar    $0x2,%edx
  800e2b:	89 c8                	mov    %ecx,%eax
  800e2d:	c1 f8 1f             	sar    $0x1f,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
  800e34:	c1 e0 02             	shl    $0x2,%eax
  800e37:	01 d0                	add    %edx,%eax
  800e39:	01 c0                	add    %eax,%eax
  800e3b:	29 c1                	sub    %eax,%ecx
  800e3d:	89 ca                	mov    %ecx,%edx
  800e3f:	85 d2                	test   %edx,%edx
  800e41:	75 9c                	jne    800ddf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4d:	48                   	dec    %eax
  800e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e55:	74 3d                	je     800e94 <ltostr+0xe2>
		start = 1 ;
  800e57:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e5e:	eb 34                	jmp    800e94 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	01 c2                	add    %eax,%edx
  800e75:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	01 c8                	add    %ecx,%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	01 c2                	add    %eax,%edx
  800e89:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e8c:	88 02                	mov    %al,(%edx)
		start++ ;
  800e8e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e91:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e97:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e9a:	7c c4                	jl     800e60 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	01 d0                	add    %edx,%eax
  800ea4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ea7:	90                   	nop
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800eb0:	ff 75 08             	pushl  0x8(%ebp)
  800eb3:	e8 54 fa ff ff       	call   80090c <strlen>
  800eb8:	83 c4 04             	add    $0x4,%esp
  800ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	e8 46 fa ff ff       	call   80090c <strlen>
  800ec6:	83 c4 04             	add    $0x4,%esp
  800ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ed3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eda:	eb 17                	jmp    800ef3 <strcconcat+0x49>
		final[s] = str1[s] ;
  800edc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 c2                	add    %eax,%edx
  800ee4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	01 c8                	add    %ecx,%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ef0:	ff 45 fc             	incl   -0x4(%ebp)
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ef9:	7c e1                	jl     800edc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800efb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f09:	eb 1f                	jmp    800f2a <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f14:	89 c2                	mov    %eax,%edx
  800f16:	8b 45 10             	mov    0x10(%ebp),%eax
  800f19:	01 c2                	add    %eax,%edx
  800f1b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	01 c8                	add    %ecx,%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f27:	ff 45 f8             	incl   -0x8(%ebp)
  800f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f30:	7c d9                	jl     800f0b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	c6 00 00             	movb   $0x0,(%eax)
}
  800f3d:	90                   	nop
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f43:	8b 45 14             	mov    0x14(%ebp),%eax
  800f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4f:	8b 00                	mov    (%eax),%eax
  800f51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f63:	eb 0c                	jmp    800f71 <strsplit+0x31>
			*string++ = 0;
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f6e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	74 18                	je     800f92 <strsplit+0x52>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	0f be c0             	movsbl %al,%eax
  800f82:	50                   	push   %eax
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	e8 13 fb ff ff       	call   800a9e <strchr>
  800f8b:	83 c4 08             	add    $0x8,%esp
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 d3                	jne    800f65 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	84 c0                	test   %al,%al
  800f99:	74 5a                	je     800ff5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9e:	8b 00                	mov    (%eax),%eax
  800fa0:	83 f8 0f             	cmp    $0xf,%eax
  800fa3:	75 07                	jne    800fac <strsplit+0x6c>
		{
			return 0;
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	eb 66                	jmp    801012 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	8b 00                	mov    (%eax),%eax
  800fb1:	8d 48 01             	lea    0x1(%eax),%ecx
  800fb4:	8b 55 14             	mov    0x14(%ebp),%edx
  800fb7:	89 0a                	mov    %ecx,(%edx)
  800fb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 c2                	add    %eax,%edx
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fca:	eb 03                	jmp    800fcf <strsplit+0x8f>
			string++;
  800fcc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	84 c0                	test   %al,%al
  800fd6:	74 8b                	je     800f63 <strsplit+0x23>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	50                   	push   %eax
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	e8 b5 fa ff ff       	call   800a9e <strchr>
  800fe9:	83 c4 08             	add    $0x8,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	74 dc                	je     800fcc <strsplit+0x8c>
			string++;
	}
  800ff0:	e9 6e ff ff ff       	jmp    800f63 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800ff5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	8b 00                	mov    (%eax),%eax
  800ffb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	01 d0                	add    %edx,%eax
  801007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80100d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	57                   	push   %edi
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
  80101a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801026:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801029:	8b 7d 18             	mov    0x18(%ebp),%edi
  80102c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80102f:	cd 30                	int    $0x30
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	5b                   	pop    %ebx
  80103b:	5e                   	pop    %esi
  80103c:	5f                   	pop    %edi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80104b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	6a 00                	push   $0x0
  801054:	6a 00                	push   $0x0
  801056:	52                   	push   %edx
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	50                   	push   %eax
  80105b:	6a 00                	push   $0x0
  80105d:	e8 b2 ff ff ff       	call   801014 <syscall>
  801062:	83 c4 18             	add    $0x18,%esp
}
  801065:	90                   	nop
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <sys_cgetc>:

int
sys_cgetc(void)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80106b:	6a 00                	push   $0x0
  80106d:	6a 00                	push   $0x0
  80106f:	6a 00                	push   $0x0
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	6a 01                	push   $0x1
  801077:	e8 98 ff ff ff       	call   801014 <syscall>
  80107c:	83 c4 18             	add    $0x18,%esp
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	6a 00                	push   $0x0
  801090:	52                   	push   %edx
  801091:	50                   	push   %eax
  801092:	6a 05                	push   $0x5
  801094:	e8 7b ff ff ff       	call   801014 <syscall>
  801099:	83 c4 18             	add    $0x18,%esp
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8010a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
  8010b4:	51                   	push   %ecx
  8010b5:	52                   	push   %edx
  8010b6:	50                   	push   %eax
  8010b7:	6a 06                	push   $0x6
  8010b9:	e8 56 ff ff ff       	call   801014 <syscall>
  8010be:	83 c4 18             	add    $0x18,%esp
}
  8010c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	6a 00                	push   $0x0
  8010d3:	6a 00                	push   $0x0
  8010d5:	6a 00                	push   $0x0
  8010d7:	52                   	push   %edx
  8010d8:	50                   	push   %eax
  8010d9:	6a 07                	push   $0x7
  8010db:	e8 34 ff ff ff       	call   801014 <syscall>
  8010e0:	83 c4 18             	add    $0x18,%esp
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	ff 75 0c             	pushl  0xc(%ebp)
  8010f1:	ff 75 08             	pushl  0x8(%ebp)
  8010f4:	6a 08                	push   $0x8
  8010f6:	e8 19 ff ff ff       	call   801014 <syscall>
  8010fb:	83 c4 18             	add    $0x18,%esp
}
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	6a 00                	push   $0x0
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 09                	push   $0x9
  80110f:	e8 00 ff ff ff       	call   801014 <syscall>
  801114:	83 c4 18             	add    $0x18,%esp
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 0a                	push   $0xa
  801128:	e8 e7 fe ff ff       	call   801014 <syscall>
  80112d:	83 c4 18             	add    $0x18,%esp
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 0b                	push   $0xb
  801141:	e8 ce fe ff ff       	call   801014 <syscall>
  801146:	83 c4 18             	add    $0x18,%esp
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80114e:	6a 00                	push   $0x0
  801150:	6a 00                	push   $0x0
  801152:	6a 00                	push   $0x0
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	ff 75 08             	pushl  0x8(%ebp)
  80115a:	6a 0f                	push   $0xf
  80115c:	e8 b3 fe ff ff       	call   801014 <syscall>
  801161:	83 c4 18             	add    $0x18,%esp
	return;
  801164:	90                   	nop
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	ff 75 0c             	pushl  0xc(%ebp)
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	6a 10                	push   $0x10
  801178:	e8 97 fe ff ff       	call   801014 <syscall>
  80117d:	83 c4 18             	add    $0x18,%esp
	return ;
  801180:	90                   	nop
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	ff 75 10             	pushl  0x10(%ebp)
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	6a 11                	push   $0x11
  801195:	e8 7a fe ff ff       	call   801014 <syscall>
  80119a:	83 c4 18             	add    $0x18,%esp
	return ;
  80119d:	90                   	nop
}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 0c                	push   $0xc
  8011af:	e8 60 fe ff ff       	call   801014 <syscall>
  8011b4:	83 c4 18             	add    $0x18,%esp
}
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	ff 75 08             	pushl  0x8(%ebp)
  8011c7:	6a 0d                	push   $0xd
  8011c9:	e8 46 fe ff ff       	call   801014 <syscall>
  8011ce:	83 c4 18             	add    $0x18,%esp
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 0e                	push   $0xe
  8011e2:	e8 2d fe ff ff       	call   801014 <syscall>
  8011e7:	83 c4 18             	add    $0x18,%esp
}
  8011ea:	90                   	nop
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 13                	push   $0x13
  8011fc:	e8 13 fe ff ff       	call   801014 <syscall>
  801201:	83 c4 18             	add    $0x18,%esp
}
  801204:	90                   	nop
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 00                	push   $0x0
  801210:	6a 00                	push   $0x0
  801212:	6a 00                	push   $0x0
  801214:	6a 14                	push   $0x14
  801216:	e8 f9 fd ff ff       	call   801014 <syscall>
  80121b:	83 c4 18             	add    $0x18,%esp
}
  80121e:	90                   	nop
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <sys_cputc>:


void
sys_cputc(const char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80122d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	50                   	push   %eax
  80123a:	6a 15                	push   $0x15
  80123c:	e8 d3 fd ff ff       	call   801014 <syscall>
  801241:	83 c4 18             	add    $0x18,%esp
}
  801244:	90                   	nop
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 16                	push   $0x16
  801256:	e8 b9 fd ff ff       	call   801014 <syscall>
  80125b:	83 c4 18             	add    $0x18,%esp
}
  80125e:	90                   	nop
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	50                   	push   %eax
  801271:	6a 17                	push   $0x17
  801273:	e8 9c fd ff ff       	call   801014 <syscall>
  801278:	83 c4 18             	add    $0x18,%esp
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801280:	8b 55 0c             	mov    0xc(%ebp),%edx
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	52                   	push   %edx
  80128d:	50                   	push   %eax
  80128e:	6a 1a                	push   $0x1a
  801290:	e8 7f fd ff ff       	call   801014 <syscall>
  801295:	83 c4 18             	add    $0x18,%esp
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80129d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	52                   	push   %edx
  8012aa:	50                   	push   %eax
  8012ab:	6a 18                	push   $0x18
  8012ad:	e8 62 fd ff ff       	call   801014 <syscall>
  8012b2:	83 c4 18             	add    $0x18,%esp
}
  8012b5:	90                   	nop
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	52                   	push   %edx
  8012c8:	50                   	push   %eax
  8012c9:	6a 19                	push   $0x19
  8012cb:	e8 44 fd ff ff       	call   801014 <syscall>
  8012d0:	83 c4 18             	add    $0x18,%esp
}
  8012d3:	90                   	nop
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	6a 00                	push   $0x0
  8012ee:	51                   	push   %ecx
  8012ef:	52                   	push   %edx
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	50                   	push   %eax
  8012f4:	6a 1b                	push   $0x1b
  8012f6:	e8 19 fd ff ff       	call   801014 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	52                   	push   %edx
  801310:	50                   	push   %eax
  801311:	6a 1c                	push   $0x1c
  801313:	e8 fc fc ff ff       	call   801014 <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801320:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	51                   	push   %ecx
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 1d                	push   $0x1d
  801332:	e8 dd fc ff ff       	call   801014 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	52                   	push   %edx
  80134c:	50                   	push   %eax
  80134d:	6a 1e                	push   $0x1e
  80134f:	e8 c0 fc ff ff       	call   801014 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 1f                	push   $0x1f
  801368:	e8 a7 fc ff ff       	call   801014 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	6a 00                	push   $0x0
  80137a:	ff 75 14             	pushl  0x14(%ebp)
  80137d:	ff 75 10             	pushl  0x10(%ebp)
  801380:	ff 75 0c             	pushl  0xc(%ebp)
  801383:	50                   	push   %eax
  801384:	6a 20                	push   $0x20
  801386:	e8 89 fc ff ff       	call   801014 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	50                   	push   %eax
  80139f:	6a 21                	push   $0x21
  8013a1:	e8 6e fc ff ff       	call   801014 <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	50                   	push   %eax
  8013bb:	6a 22                	push   $0x22
  8013bd:	e8 52 fc ff ff       	call   801014 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 02                	push   $0x2
  8013d6:	e8 39 fc ff ff       	call   801014 <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 03                	push   $0x3
  8013ef:	e8 20 fc ff ff       	call   801014 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 04                	push   $0x4
  801408:	e8 07 fc ff ff       	call   801014 <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <sys_exit_env>:


void sys_exit_env(void)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 23                	push   $0x23
  801421:	e8 ee fb ff ff       	call   801014 <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	90                   	nop
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801432:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801435:	8d 50 04             	lea    0x4(%eax),%edx
  801438:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	6a 24                	push   $0x24
  801445:	e8 ca fb ff ff       	call   801014 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
	return result;
  80144d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801453:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801456:	89 01                	mov    %eax,(%ecx)
  801458:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	c9                   	leave  
  80145f:	c2 04 00             	ret    $0x4

00801462 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	ff 75 10             	pushl  0x10(%ebp)
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	6a 12                	push   $0x12
  801474:	e8 9b fb ff ff       	call   801014 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
	return ;
  80147c:	90                   	nop
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_rcr2>:
uint32 sys_rcr2()
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 25                	push   $0x25
  80148e:	e8 81 fb ff ff       	call   801014 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014a4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	50                   	push   %eax
  8014b1:	6a 26                	push   $0x26
  8014b3:	e8 5c fb ff ff       	call   801014 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bb:	90                   	nop
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <rsttst>:
void rsttst()
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 28                	push   $0x28
  8014cd:	e8 42 fb ff ff       	call   801014 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d5:	90                   	nop
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8014e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014eb:	52                   	push   %edx
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 10             	pushl  0x10(%ebp)
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	6a 27                	push   $0x27
  8014f8:	e8 17 fb ff ff       	call   801014 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801500:	90                   	nop
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <chktst>:
void chktst(uint32 n)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	6a 29                	push   $0x29
  801513:	e8 fc fa ff ff       	call   801014 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
	return ;
  80151b:	90                   	nop
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <inctst>:

void inctst()
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 2a                	push   $0x2a
  80152d:	e8 e2 fa ff ff       	call   801014 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
	return ;
  801535:	90                   	nop
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <gettst>:
uint32 gettst()
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 2b                	push   $0x2b
  801547:	e8 c8 fa ff ff       	call   801014 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 2c                	push   $0x2c
  801563:	e8 ac fa ff ff       	call   801014 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
  80156b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80156e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801572:	75 07                	jne    80157b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801574:	b8 01 00 00 00       	mov    $0x1,%eax
  801579:	eb 05                	jmp    801580 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 2c                	push   $0x2c
  801594:	e8 7b fa ff ff       	call   801014 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
  80159c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80159f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015a3:	75 07                	jne    8015ac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8015aa:	eb 05                	jmp    8015b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 2c                	push   $0x2c
  8015c5:	e8 4a fa ff ff       	call   801014 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
  8015cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015d0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015d4:	75 07                	jne    8015dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015db:	eb 05                	jmp    8015e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 2c                	push   $0x2c
  8015f6:	e8 19 fa ff ff       	call   801014 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
  8015fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801601:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801605:	75 07                	jne    80160e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801607:	b8 01 00 00 00       	mov    $0x1,%eax
  80160c:	eb 05                	jmp    801613 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	6a 2d                	push   $0x2d
  801625:	e8 ea f9 ff ff       	call   801014 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
	return ;
  80162d:	90                   	nop
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801634:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801637:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	53                   	push   %ebx
  801643:	51                   	push   %ecx
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	6a 2e                	push   $0x2e
  801648:	e8 c7 f9 ff ff       	call   801014 <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	6a 2f                	push   $0x2f
  801668:	e8 a7 f9 ff ff       	call   801014 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    
  801672:	66 90                	xchg   %ax,%ax

00801674 <__udivdi3>:
  801674:	55                   	push   %ebp
  801675:	57                   	push   %edi
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
  801678:	83 ec 1c             	sub    $0x1c,%esp
  80167b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80167f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801687:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80168b:	89 ca                	mov    %ecx,%edx
  80168d:	89 f8                	mov    %edi,%eax
  80168f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801693:	85 f6                	test   %esi,%esi
  801695:	75 2d                	jne    8016c4 <__udivdi3+0x50>
  801697:	39 cf                	cmp    %ecx,%edi
  801699:	77 65                	ja     801700 <__udivdi3+0x8c>
  80169b:	89 fd                	mov    %edi,%ebp
  80169d:	85 ff                	test   %edi,%edi
  80169f:	75 0b                	jne    8016ac <__udivdi3+0x38>
  8016a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a6:	31 d2                	xor    %edx,%edx
  8016a8:	f7 f7                	div    %edi
  8016aa:	89 c5                	mov    %eax,%ebp
  8016ac:	31 d2                	xor    %edx,%edx
  8016ae:	89 c8                	mov    %ecx,%eax
  8016b0:	f7 f5                	div    %ebp
  8016b2:	89 c1                	mov    %eax,%ecx
  8016b4:	89 d8                	mov    %ebx,%eax
  8016b6:	f7 f5                	div    %ebp
  8016b8:	89 cf                	mov    %ecx,%edi
  8016ba:	89 fa                	mov    %edi,%edx
  8016bc:	83 c4 1c             	add    $0x1c,%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5f                   	pop    %edi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    
  8016c4:	39 ce                	cmp    %ecx,%esi
  8016c6:	77 28                	ja     8016f0 <__udivdi3+0x7c>
  8016c8:	0f bd fe             	bsr    %esi,%edi
  8016cb:	83 f7 1f             	xor    $0x1f,%edi
  8016ce:	75 40                	jne    801710 <__udivdi3+0x9c>
  8016d0:	39 ce                	cmp    %ecx,%esi
  8016d2:	72 0a                	jb     8016de <__udivdi3+0x6a>
  8016d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8016d8:	0f 87 9e 00 00 00    	ja     80177c <__udivdi3+0x108>
  8016de:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e3:	89 fa                	mov    %edi,%edx
  8016e5:	83 c4 1c             	add    $0x1c,%esp
  8016e8:	5b                   	pop    %ebx
  8016e9:	5e                   	pop    %esi
  8016ea:	5f                   	pop    %edi
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    
  8016ed:	8d 76 00             	lea    0x0(%esi),%esi
  8016f0:	31 ff                	xor    %edi,%edi
  8016f2:	31 c0                	xor    %eax,%eax
  8016f4:	89 fa                	mov    %edi,%edx
  8016f6:	83 c4 1c             	add    $0x1c,%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5e                   	pop    %esi
  8016fb:	5f                   	pop    %edi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    
  8016fe:	66 90                	xchg   %ax,%ax
  801700:	89 d8                	mov    %ebx,%eax
  801702:	f7 f7                	div    %edi
  801704:	31 ff                	xor    %edi,%edi
  801706:	89 fa                	mov    %edi,%edx
  801708:	83 c4 1c             	add    $0x1c,%esp
  80170b:	5b                   	pop    %ebx
  80170c:	5e                   	pop    %esi
  80170d:	5f                   	pop    %edi
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    
  801710:	bd 20 00 00 00       	mov    $0x20,%ebp
  801715:	89 eb                	mov    %ebp,%ebx
  801717:	29 fb                	sub    %edi,%ebx
  801719:	89 f9                	mov    %edi,%ecx
  80171b:	d3 e6                	shl    %cl,%esi
  80171d:	89 c5                	mov    %eax,%ebp
  80171f:	88 d9                	mov    %bl,%cl
  801721:	d3 ed                	shr    %cl,%ebp
  801723:	89 e9                	mov    %ebp,%ecx
  801725:	09 f1                	or     %esi,%ecx
  801727:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80172b:	89 f9                	mov    %edi,%ecx
  80172d:	d3 e0                	shl    %cl,%eax
  80172f:	89 c5                	mov    %eax,%ebp
  801731:	89 d6                	mov    %edx,%esi
  801733:	88 d9                	mov    %bl,%cl
  801735:	d3 ee                	shr    %cl,%esi
  801737:	89 f9                	mov    %edi,%ecx
  801739:	d3 e2                	shl    %cl,%edx
  80173b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80173f:	88 d9                	mov    %bl,%cl
  801741:	d3 e8                	shr    %cl,%eax
  801743:	09 c2                	or     %eax,%edx
  801745:	89 d0                	mov    %edx,%eax
  801747:	89 f2                	mov    %esi,%edx
  801749:	f7 74 24 0c          	divl   0xc(%esp)
  80174d:	89 d6                	mov    %edx,%esi
  80174f:	89 c3                	mov    %eax,%ebx
  801751:	f7 e5                	mul    %ebp
  801753:	39 d6                	cmp    %edx,%esi
  801755:	72 19                	jb     801770 <__udivdi3+0xfc>
  801757:	74 0b                	je     801764 <__udivdi3+0xf0>
  801759:	89 d8                	mov    %ebx,%eax
  80175b:	31 ff                	xor    %edi,%edi
  80175d:	e9 58 ff ff ff       	jmp    8016ba <__udivdi3+0x46>
  801762:	66 90                	xchg   %ax,%ax
  801764:	8b 54 24 08          	mov    0x8(%esp),%edx
  801768:	89 f9                	mov    %edi,%ecx
  80176a:	d3 e2                	shl    %cl,%edx
  80176c:	39 c2                	cmp    %eax,%edx
  80176e:	73 e9                	jae    801759 <__udivdi3+0xe5>
  801770:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801773:	31 ff                	xor    %edi,%edi
  801775:	e9 40 ff ff ff       	jmp    8016ba <__udivdi3+0x46>
  80177a:	66 90                	xchg   %ax,%ax
  80177c:	31 c0                	xor    %eax,%eax
  80177e:	e9 37 ff ff ff       	jmp    8016ba <__udivdi3+0x46>
  801783:	90                   	nop

00801784 <__umoddi3>:
  801784:	55                   	push   %ebp
  801785:	57                   	push   %edi
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 1c             	sub    $0x1c,%esp
  80178b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80178f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801793:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801797:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80179b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80179f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017a3:	89 f3                	mov    %esi,%ebx
  8017a5:	89 fa                	mov    %edi,%edx
  8017a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017ab:	89 34 24             	mov    %esi,(%esp)
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	75 1a                	jne    8017cc <__umoddi3+0x48>
  8017b2:	39 f7                	cmp    %esi,%edi
  8017b4:	0f 86 a2 00 00 00    	jbe    80185c <__umoddi3+0xd8>
  8017ba:	89 c8                	mov    %ecx,%eax
  8017bc:	89 f2                	mov    %esi,%edx
  8017be:	f7 f7                	div    %edi
  8017c0:	89 d0                	mov    %edx,%eax
  8017c2:	31 d2                	xor    %edx,%edx
  8017c4:	83 c4 1c             	add    $0x1c,%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5f                   	pop    %edi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
  8017cc:	39 f0                	cmp    %esi,%eax
  8017ce:	0f 87 ac 00 00 00    	ja     801880 <__umoddi3+0xfc>
  8017d4:	0f bd e8             	bsr    %eax,%ebp
  8017d7:	83 f5 1f             	xor    $0x1f,%ebp
  8017da:	0f 84 ac 00 00 00    	je     80188c <__umoddi3+0x108>
  8017e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8017e5:	29 ef                	sub    %ebp,%edi
  8017e7:	89 fe                	mov    %edi,%esi
  8017e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017ed:	89 e9                	mov    %ebp,%ecx
  8017ef:	d3 e0                	shl    %cl,%eax
  8017f1:	89 d7                	mov    %edx,%edi
  8017f3:	89 f1                	mov    %esi,%ecx
  8017f5:	d3 ef                	shr    %cl,%edi
  8017f7:	09 c7                	or     %eax,%edi
  8017f9:	89 e9                	mov    %ebp,%ecx
  8017fb:	d3 e2                	shl    %cl,%edx
  8017fd:	89 14 24             	mov    %edx,(%esp)
  801800:	89 d8                	mov    %ebx,%eax
  801802:	d3 e0                	shl    %cl,%eax
  801804:	89 c2                	mov    %eax,%edx
  801806:	8b 44 24 08          	mov    0x8(%esp),%eax
  80180a:	d3 e0                	shl    %cl,%eax
  80180c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801810:	8b 44 24 08          	mov    0x8(%esp),%eax
  801814:	89 f1                	mov    %esi,%ecx
  801816:	d3 e8                	shr    %cl,%eax
  801818:	09 d0                	or     %edx,%eax
  80181a:	d3 eb                	shr    %cl,%ebx
  80181c:	89 da                	mov    %ebx,%edx
  80181e:	f7 f7                	div    %edi
  801820:	89 d3                	mov    %edx,%ebx
  801822:	f7 24 24             	mull   (%esp)
  801825:	89 c6                	mov    %eax,%esi
  801827:	89 d1                	mov    %edx,%ecx
  801829:	39 d3                	cmp    %edx,%ebx
  80182b:	0f 82 87 00 00 00    	jb     8018b8 <__umoddi3+0x134>
  801831:	0f 84 91 00 00 00    	je     8018c8 <__umoddi3+0x144>
  801837:	8b 54 24 04          	mov    0x4(%esp),%edx
  80183b:	29 f2                	sub    %esi,%edx
  80183d:	19 cb                	sbb    %ecx,%ebx
  80183f:	89 d8                	mov    %ebx,%eax
  801841:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801845:	d3 e0                	shl    %cl,%eax
  801847:	89 e9                	mov    %ebp,%ecx
  801849:	d3 ea                	shr    %cl,%edx
  80184b:	09 d0                	or     %edx,%eax
  80184d:	89 e9                	mov    %ebp,%ecx
  80184f:	d3 eb                	shr    %cl,%ebx
  801851:	89 da                	mov    %ebx,%edx
  801853:	83 c4 1c             	add    $0x1c,%esp
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5f                   	pop    %edi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    
  80185b:	90                   	nop
  80185c:	89 fd                	mov    %edi,%ebp
  80185e:	85 ff                	test   %edi,%edi
  801860:	75 0b                	jne    80186d <__umoddi3+0xe9>
  801862:	b8 01 00 00 00       	mov    $0x1,%eax
  801867:	31 d2                	xor    %edx,%edx
  801869:	f7 f7                	div    %edi
  80186b:	89 c5                	mov    %eax,%ebp
  80186d:	89 f0                	mov    %esi,%eax
  80186f:	31 d2                	xor    %edx,%edx
  801871:	f7 f5                	div    %ebp
  801873:	89 c8                	mov    %ecx,%eax
  801875:	f7 f5                	div    %ebp
  801877:	89 d0                	mov    %edx,%eax
  801879:	e9 44 ff ff ff       	jmp    8017c2 <__umoddi3+0x3e>
  80187e:	66 90                	xchg   %ax,%ax
  801880:	89 c8                	mov    %ecx,%eax
  801882:	89 f2                	mov    %esi,%edx
  801884:	83 c4 1c             	add    $0x1c,%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
  80188c:	3b 04 24             	cmp    (%esp),%eax
  80188f:	72 06                	jb     801897 <__umoddi3+0x113>
  801891:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801895:	77 0f                	ja     8018a6 <__umoddi3+0x122>
  801897:	89 f2                	mov    %esi,%edx
  801899:	29 f9                	sub    %edi,%ecx
  80189b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80189f:	89 14 24             	mov    %edx,(%esp)
  8018a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018aa:	8b 14 24             	mov    (%esp),%edx
  8018ad:	83 c4 1c             	add    $0x1c,%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5f                   	pop    %edi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    
  8018b5:	8d 76 00             	lea    0x0(%esi),%esi
  8018b8:	2b 04 24             	sub    (%esp),%eax
  8018bb:	19 fa                	sbb    %edi,%edx
  8018bd:	89 d1                	mov    %edx,%ecx
  8018bf:	89 c6                	mov    %eax,%esi
  8018c1:	e9 71 ff ff ff       	jmp    801837 <__umoddi3+0xb3>
  8018c6:	66 90                	xchg   %ax,%ax
  8018c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018cc:	72 ea                	jb     8018b8 <__umoddi3+0x134>
  8018ce:	89 d9                	mov    %ebx,%ecx
  8018d0:	e9 62 ff ff ff       	jmp    801837 <__umoddi3+0xb3>
