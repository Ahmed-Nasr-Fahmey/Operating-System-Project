
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 c0 1c 80 00       	push   $0x801cc0
  80005e:	e8 1b 0a 00 00       	call   800a7e <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 6d 0e 00 00       	call   800ee6 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 60 18 00 00       	call   8018ec <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 dc 1c 80 00       	push   $0x801cdc
  80009e:	e8 db 09 00 00       	call   800a7e <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 2d 0e 00 00       	call   800ee6 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 f9 1c 80 00       	push   $0x801cf9
  8000d0:	e8 56 02 00 00       	call   80032b <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 74 15 00 00       	call   80165a <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	01 c0                	add    %eax,%eax
  8000f0:	01 d0                	add    %edx,%eax
  8000f2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000f9:	01 c8                	add    %ecx,%eax
  8000fb:	c1 e0 02             	shl    $0x2,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800107:	01 c8                	add    %ecx,%eax
  800109:	c1 e0 02             	shl    $0x2,%eax
  80010c:	01 d0                	add    %edx,%eax
  80010e:	c1 e0 02             	shl    $0x2,%eax
  800111:	01 d0                	add    %edx,%eax
  800113:	c1 e0 03             	shl    $0x3,%eax
  800116:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800120:	a1 20 30 80 00       	mov    0x803020,%eax
  800125:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80012b:	84 c0                	test   %al,%al
  80012d:	74 0f                	je     80013e <libmain+0x63>
		binaryname = myEnv->prog_name;
  80012f:	a1 20 30 80 00       	mov    0x803020,%eax
  800134:	05 18 da 01 00       	add    $0x1da18,%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800142:	7e 0a                	jle    80014e <libmain+0x73>
		binaryname = argv[0];
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 dc fe ff ff       	call   800038 <_main>
  80015c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80015f:	e8 03 13 00 00       	call   801467 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	68 2c 1d 80 00       	push   $0x801d2c
  80016c:	e8 8d 01 00 00       	call   8002fe <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800174:	a1 20 30 80 00       	mov    0x803020,%eax
  800179:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	52                   	push   %edx
  80018e:	50                   	push   %eax
  80018f:	68 54 1d 80 00       	push   $0x801d54
  800194:	e8 65 01 00 00       	call   8002fe <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80019c:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a1:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8001bd:	51                   	push   %ecx
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 7c 1d 80 00       	push   $0x801d7c
  8001c5:	e8 34 01 00 00       	call   8002fe <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	50                   	push   %eax
  8001dc:	68 d4 1d 80 00       	push   $0x801dd4
  8001e1:	e8 18 01 00 00       	call   8002fe <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 2c 1d 80 00       	push   $0x801d2c
  8001f1:	e8 08 01 00 00       	call   8002fe <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001f9:	e8 83 12 00 00       	call   801481 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001fe:	e8 19 00 00 00       	call   80021c <exit>
}
  800203:	90                   	nop
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	6a 00                	push   $0x0
  800211:	e8 10 14 00 00       	call   801626 <sys_destroy_env>
  800216:	83 c4 10             	add    $0x10,%esp
}
  800219:	90                   	nop
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <exit>:

void
exit(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800222:	e8 65 14 00 00       	call   80168c <sys_exit_env>
}
  800227:	90                   	nop
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800230:	8b 45 0c             	mov    0xc(%ebp),%eax
  800233:	8b 00                	mov    (%eax),%eax
  800235:	8d 48 01             	lea    0x1(%eax),%ecx
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	89 0a                	mov    %ecx,(%edx)
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	88 d1                	mov    %dl,%cl
  800242:	8b 55 0c             	mov    0xc(%ebp),%edx
  800245:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	8b 00                	mov    (%eax),%eax
  80024e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800253:	75 2c                	jne    800281 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800255:	a0 24 30 80 00       	mov    0x803024,%al
  80025a:	0f b6 c0             	movzbl %al,%eax
  80025d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800260:	8b 12                	mov    (%edx),%edx
  800262:	89 d1                	mov    %edx,%ecx
  800264:	8b 55 0c             	mov    0xc(%ebp),%edx
  800267:	83 c2 08             	add    $0x8,%edx
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	50                   	push   %eax
  80026e:	51                   	push   %ecx
  80026f:	52                   	push   %edx
  800270:	e8 44 10 00 00       	call   8012b9 <sys_cputs>
  800275:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800281:	8b 45 0c             	mov    0xc(%ebp),%eax
  800284:	8b 40 04             	mov    0x4(%eax),%eax
  800287:	8d 50 01             	lea    0x1(%eax),%edx
  80028a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a3:	00 00 00 
	b.cnt = 0;
  8002a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002bc:	50                   	push   %eax
  8002bd:	68 2a 02 80 00       	push   $0x80022a
  8002c2:	e8 11 02 00 00       	call   8004d8 <vprintfmt>
  8002c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002ca:	a0 24 30 80 00       	mov    0x803024,%al
  8002cf:	0f b6 c0             	movzbl %al,%eax
  8002d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	50                   	push   %eax
  8002dc:	52                   	push   %edx
  8002dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e3:	83 c0 08             	add    $0x8,%eax
  8002e6:	50                   	push   %eax
  8002e7:	e8 cd 0f 00 00       	call   8012b9 <sys_cputs>
  8002ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ef:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800304:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80030b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	ff 75 f4             	pushl  -0xc(%ebp)
  80031a:	50                   	push   %eax
  80031b:	e8 73 ff ff ff       	call   800293 <vcprintf>
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800331:	e8 31 11 00 00       	call   801467 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800336:	8d 45 0c             	lea    0xc(%ebp),%eax
  800339:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 75 f4             	pushl  -0xc(%ebp)
  800345:	50                   	push   %eax
  800346:	e8 48 ff ff ff       	call   800293 <vcprintf>
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800351:	e8 2b 11 00 00       	call   801481 <sys_enable_interrupt>
	return cnt;
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800359:	c9                   	leave  
  80035a:	c3                   	ret    

0080035b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	53                   	push   %ebx
  80035f:	83 ec 14             	sub    $0x14,%esp
  800362:	8b 45 10             	mov    0x10(%ebp),%eax
  800365:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036e:	8b 45 18             	mov    0x18(%ebp),%eax
  800371:	ba 00 00 00 00       	mov    $0x0,%edx
  800376:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800379:	77 55                	ja     8003d0 <printnum+0x75>
  80037b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037e:	72 05                	jb     800385 <printnum+0x2a>
  800380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800383:	77 4b                	ja     8003d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800385:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800388:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80038b:	8b 45 18             	mov    0x18(%ebp),%eax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
  800393:	52                   	push   %edx
  800394:	50                   	push   %eax
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	ff 75 f0             	pushl  -0x10(%ebp)
  80039b:	e8 a0 16 00 00       	call   801a40 <__udivdi3>
  8003a0:	83 c4 10             	add    $0x10,%esp
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	ff 75 20             	pushl  0x20(%ebp)
  8003a9:	53                   	push   %ebx
  8003aa:	ff 75 18             	pushl  0x18(%ebp)
  8003ad:	52                   	push   %edx
  8003ae:	50                   	push   %eax
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 a1 ff ff ff       	call   80035b <printnum>
  8003ba:	83 c4 20             	add    $0x20,%esp
  8003bd:	eb 1a                	jmp    8003d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	ff 75 0c             	pushl  0xc(%ebp)
  8003c5:	ff 75 20             	pushl  0x20(%ebp)
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	ff d0                	call   *%eax
  8003cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d7:	7f e6                	jg     8003bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e7:	53                   	push   %ebx
  8003e8:	51                   	push   %ecx
  8003e9:	52                   	push   %edx
  8003ea:	50                   	push   %eax
  8003eb:	e8 60 17 00 00       	call   801b50 <__umoddi3>
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	05 14 20 80 00       	add    $0x802014,%eax
  8003f8:	8a 00                	mov    (%eax),%al
  8003fa:	0f be c0             	movsbl %al,%eax
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	50                   	push   %eax
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	ff d0                	call   *%eax
  800409:	83 c4 10             	add    $0x10,%esp
}
  80040c:	90                   	nop
  80040d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800415:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800419:	7e 1c                	jle    800437 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	8d 50 08             	lea    0x8(%eax),%edx
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	89 10                	mov    %edx,(%eax)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 e8 08             	sub    $0x8,%eax
  800430:	8b 50 04             	mov    0x4(%eax),%edx
  800433:	8b 00                	mov    (%eax),%eax
  800435:	eb 40                	jmp    800477 <getuint+0x65>
	else if (lflag)
  800437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043b:	74 1e                	je     80045b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 04             	lea    0x4(%eax),%edx
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	83 e8 04             	sub    $0x4,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	ba 00 00 00 00       	mov    $0x0,%edx
  800459:	eb 1c                	jmp    800477 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	8d 50 04             	lea    0x4(%eax),%edx
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	89 10                	mov    %edx,(%eax)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	83 e8 04             	sub    $0x4,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800480:	7e 1c                	jle    80049e <getint+0x25>
		return va_arg(*ap, long long);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 08             	lea    0x8(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 08             	sub    $0x8,%eax
  800497:	8b 50 04             	mov    0x4(%eax),%edx
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	eb 38                	jmp    8004d6 <getint+0x5d>
	else if (lflag)
  80049e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a2:	74 1a                	je     8004be <getint+0x45>
		return va_arg(*ap, long);
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	89 10                	mov    %edx,(%eax)
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	83 e8 04             	sub    $0x4,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	99                   	cltd   
  8004bc:	eb 18                	jmp    8004d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 04             	lea    0x4(%eax),%edx
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	83 e8 04             	sub    $0x4,%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	99                   	cltd   
}
  8004d6:	5d                   	pop    %ebp
  8004d7:	c3                   	ret    

008004d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	56                   	push   %esi
  8004dc:	53                   	push   %ebx
  8004dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e0:	eb 17                	jmp    8004f9 <vprintfmt+0x21>
			if (ch == '\0')
  8004e2:	85 db                	test   %ebx,%ebx
  8004e4:	0f 84 af 03 00 00    	je     800899 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	ff 75 0c             	pushl  0xc(%ebp)
  8004f0:	53                   	push   %ebx
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	ff d0                	call   *%eax
  8004f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800502:	8a 00                	mov    (%eax),%al
  800504:	0f b6 d8             	movzbl %al,%ebx
  800507:	83 fb 25             	cmp    $0x25,%ebx
  80050a:	75 d6                	jne    8004e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800510:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800517:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800525:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 45 10             	mov    0x10(%ebp),%eax
  80052f:	8d 50 01             	lea    0x1(%eax),%edx
  800532:	89 55 10             	mov    %edx,0x10(%ebp)
  800535:	8a 00                	mov    (%eax),%al
  800537:	0f b6 d8             	movzbl %al,%ebx
  80053a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80053d:	83 f8 55             	cmp    $0x55,%eax
  800540:	0f 87 2b 03 00 00    	ja     800871 <vprintfmt+0x399>
  800546:	8b 04 85 38 20 80 00 	mov    0x802038(,%eax,4),%eax
  80054d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80054f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800553:	eb d7                	jmp    80052c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800555:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800559:	eb d1                	jmp    80052c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800562:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	c1 e0 02             	shl    $0x2,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d8                	add    %ebx,%eax
  800570:	83 e8 30             	sub    $0x30,%eax
  800573:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8a 00                	mov    (%eax),%al
  80057b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80057e:	83 fb 2f             	cmp    $0x2f,%ebx
  800581:	7e 3e                	jle    8005c1 <vprintfmt+0xe9>
  800583:	83 fb 39             	cmp    $0x39,%ebx
  800586:	7f 39                	jg     8005c1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800588:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80058b:	eb d5                	jmp    800562 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 c0 04             	add    $0x4,%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	83 e8 04             	sub    $0x4,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a1:	eb 1f                	jmp    8005c2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a7:	79 83                	jns    80052c <vprintfmt+0x54>
				width = 0;
  8005a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b0:	e9 77 ff ff ff       	jmp    80052c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005bc:	e9 6b ff ff ff       	jmp    80052c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c6:	0f 89 60 ff ff ff    	jns    80052c <vprintfmt+0x54>
				width = precision, precision = -1;
  8005cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d9:	e9 4e ff ff ff       	jmp    80052c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005de:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e1:	e9 46 ff ff ff       	jmp    80052c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 c0 04             	add    $0x4,%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 e8 04             	sub    $0x4,%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	50                   	push   %eax
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	ff d0                	call   *%eax
  800603:	83 c4 10             	add    $0x10,%esp
			break;
  800606:	e9 89 02 00 00       	jmp    800894 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80061c:	85 db                	test   %ebx,%ebx
  80061e:	79 02                	jns    800622 <vprintfmt+0x14a>
				err = -err;
  800620:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800622:	83 fb 64             	cmp    $0x64,%ebx
  800625:	7f 0b                	jg     800632 <vprintfmt+0x15a>
  800627:	8b 34 9d 80 1e 80 00 	mov    0x801e80(,%ebx,4),%esi
  80062e:	85 f6                	test   %esi,%esi
  800630:	75 19                	jne    80064b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800632:	53                   	push   %ebx
  800633:	68 25 20 80 00       	push   $0x802025
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	ff 75 08             	pushl  0x8(%ebp)
  80063e:	e8 5e 02 00 00       	call   8008a1 <printfmt>
  800643:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800646:	e9 49 02 00 00       	jmp    800894 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80064b:	56                   	push   %esi
  80064c:	68 2e 20 80 00       	push   $0x80202e
  800651:	ff 75 0c             	pushl  0xc(%ebp)
  800654:	ff 75 08             	pushl  0x8(%ebp)
  800657:	e8 45 02 00 00       	call   8008a1 <printfmt>
  80065c:	83 c4 10             	add    $0x10,%esp
			break;
  80065f:	e9 30 02 00 00       	jmp    800894 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 30                	mov    (%eax),%esi
  800675:	85 f6                	test   %esi,%esi
  800677:	75 05                	jne    80067e <vprintfmt+0x1a6>
				p = "(null)";
  800679:	be 31 20 80 00       	mov    $0x802031,%esi
			if (width > 0 && padc != '-')
  80067e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800682:	7e 6d                	jle    8006f1 <vprintfmt+0x219>
  800684:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800688:	74 67                	je     8006f1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	50                   	push   %eax
  800691:	56                   	push   %esi
  800692:	e8 12 05 00 00       	call   800ba9 <strnlen>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80069d:	eb 16                	jmp    8006b5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80069f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	50                   	push   %eax
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	ff d0                	call   *%eax
  8006af:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b9:	7f e4                	jg     80069f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bb:	eb 34                	jmp    8006f1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c1:	74 1c                	je     8006df <vprintfmt+0x207>
  8006c3:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c6:	7e 05                	jle    8006cd <vprintfmt+0x1f5>
  8006c8:	83 fb 7e             	cmp    $0x7e,%ebx
  8006cb:	7e 12                	jle    8006df <vprintfmt+0x207>
					putch('?', putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	6a 3f                	push   $0x3f
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	ff d0                	call   *%eax
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	eb 0f                	jmp    8006ee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	53                   	push   %ebx
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	ff d0                	call   *%eax
  8006eb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f1:	89 f0                	mov    %esi,%eax
  8006f3:	8d 70 01             	lea    0x1(%eax),%esi
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f be d8             	movsbl %al,%ebx
  8006fb:	85 db                	test   %ebx,%ebx
  8006fd:	74 24                	je     800723 <vprintfmt+0x24b>
  8006ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800703:	78 b8                	js     8006bd <vprintfmt+0x1e5>
  800705:	ff 4d e0             	decl   -0x20(%ebp)
  800708:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070c:	79 af                	jns    8006bd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070e:	eb 13                	jmp    800723 <vprintfmt+0x24b>
				putch(' ', putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	6a 20                	push   $0x20
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800720:	ff 4d e4             	decl   -0x1c(%ebp)
  800723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800727:	7f e7                	jg     800710 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800729:	e9 66 01 00 00       	jmp    800894 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 e8             	pushl  -0x18(%ebp)
  800734:	8d 45 14             	lea    0x14(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 3c fd ff ff       	call   800479 <getint>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800743:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074c:	85 d2                	test   %edx,%edx
  80074e:	79 23                	jns    800773 <vprintfmt+0x29b>
				putch('-', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	6a 2d                	push   $0x2d
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	ff d0                	call   *%eax
  80075d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800766:	f7 d8                	neg    %eax
  800768:	83 d2 00             	adc    $0x0,%edx
  80076b:	f7 da                	neg    %edx
  80076d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800770:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800773:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077a:	e9 bc 00 00 00       	jmp    80083b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 e8             	pushl  -0x18(%ebp)
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	e8 84 fc ff ff       	call   800412 <getuint>
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800794:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800797:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80079e:	e9 98 00 00 00       	jmp    80083b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	6a 58                	push   $0x58
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	ff d0                	call   *%eax
  8007d0:	83 c4 10             	add    $0x10,%esp
			break;
  8007d3:	e9 bc 00 00 00       	jmp    800894 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	6a 30                	push   $0x30
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	ff d0                	call   *%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 78                	push   $0x78
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800813:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80081a:	eb 1f                	jmp    80083b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 e8             	pushl  -0x18(%ebp)
  800822:	8d 45 14             	lea    0x14(%ebp),%eax
  800825:	50                   	push   %eax
  800826:	e8 e7 fb ff ff       	call   800412 <getuint>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800831:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800834:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80083b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80083f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	52                   	push   %edx
  800846:	ff 75 e4             	pushl  -0x1c(%ebp)
  800849:	50                   	push   %eax
  80084a:	ff 75 f4             	pushl  -0xc(%ebp)
  80084d:	ff 75 f0             	pushl  -0x10(%ebp)
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	ff 75 08             	pushl  0x8(%ebp)
  800856:	e8 00 fb ff ff       	call   80035b <printnum>
  80085b:	83 c4 20             	add    $0x20,%esp
			break;
  80085e:	eb 34                	jmp    800894 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	53                   	push   %ebx
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
			break;
  80086f:	eb 23                	jmp    800894 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	6a 25                	push   $0x25
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800881:	ff 4d 10             	decl   0x10(%ebp)
  800884:	eb 03                	jmp    800889 <vprintfmt+0x3b1>
  800886:	ff 4d 10             	decl   0x10(%ebp)
  800889:	8b 45 10             	mov    0x10(%ebp),%eax
  80088c:	48                   	dec    %eax
  80088d:	8a 00                	mov    (%eax),%al
  80088f:	3c 25                	cmp    $0x25,%al
  800891:	75 f3                	jne    800886 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800893:	90                   	nop
		}
	}
  800894:	e9 47 fc ff ff       	jmp    8004e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800899:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80089a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80089d:	5b                   	pop    %ebx
  80089e:	5e                   	pop    %esi
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008aa:	83 c0 04             	add    $0x4,%eax
  8008ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b6:	50                   	push   %eax
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 16 fc ff ff       	call   8004d8 <vprintfmt>
  8008c2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008c5:	90                   	nop
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8b 40 08             	mov    0x8(%eax),%eax
  8008d1:	8d 50 01             	lea    0x1(%eax),%edx
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	8b 10                	mov    (%eax),%edx
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	8b 40 04             	mov    0x4(%eax),%eax
  8008e5:	39 c2                	cmp    %eax,%edx
  8008e7:	73 12                	jae    8008fb <sprintputch+0x33>
		*b->buf++ = ch;
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f4:	89 0a                	mov    %ecx,(%edx)
  8008f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f9:	88 10                	mov    %dl,(%eax)
}
  8008fb:	90                   	nop
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	01 d0                	add    %edx,%eax
  800915:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800918:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800923:	74 06                	je     80092b <vsnprintf+0x2d>
  800925:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800929:	7f 07                	jg     800932 <vsnprintf+0x34>
		return -E_INVAL;
  80092b:	b8 03 00 00 00       	mov    $0x3,%eax
  800930:	eb 20                	jmp    800952 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800932:	ff 75 14             	pushl  0x14(%ebp)
  800935:	ff 75 10             	pushl  0x10(%ebp)
  800938:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093b:	50                   	push   %eax
  80093c:	68 c8 08 80 00       	push   $0x8008c8
  800941:	e8 92 fb ff ff       	call   8004d8 <vprintfmt>
  800946:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80095a:	8d 45 10             	lea    0x10(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800963:	8b 45 10             	mov    0x10(%ebp),%eax
  800966:	ff 75 f4             	pushl  -0xc(%ebp)
  800969:	50                   	push   %eax
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	ff 75 08             	pushl  0x8(%ebp)
  800970:	e8 89 ff ff ff       	call   8008fe <vsnprintf>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800986:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80098a:	74 13                	je     80099f <readline+0x1f>
		cprintf("%s", prompt);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	68 90 21 80 00       	push   $0x802190
  800997:	e8 62 f9 ff ff       	call   8002fe <cprintf>
  80099c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80099f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009a6:	83 ec 0c             	sub    $0xc,%esp
  8009a9:	6a 00                	push   $0x0
  8009ab:	e8 86 10 00 00       	call   801a36 <iscons>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009b6:	e8 2d 10 00 00       	call   8019e8 <getchar>
  8009bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009c2:	79 22                	jns    8009e6 <readline+0x66>
			if (c != -E_EOF)
  8009c4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009c8:	0f 84 ad 00 00 00    	je     800a7b <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8009d4:	68 93 21 80 00       	push   $0x802193
  8009d9:	e8 20 f9 ff ff       	call   8002fe <cprintf>
  8009de:	83 c4 10             	add    $0x10,%esp
			return;
  8009e1:	e9 95 00 00 00       	jmp    800a7b <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009ea:	7e 34                	jle    800a20 <readline+0xa0>
  8009ec:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009f3:	7f 2b                	jg     800a20 <readline+0xa0>
			if (echoing)
  8009f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009f9:	74 0e                	je     800a09 <readline+0x89>
				cputchar(c);
  8009fb:	83 ec 0c             	sub    $0xc,%esp
  8009fe:	ff 75 ec             	pushl  -0x14(%ebp)
  800a01:	e8 9a 0f 00 00       	call   8019a0 <cputchar>
  800a06:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0c:	8d 50 01             	lea    0x1(%eax),%edx
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a12:	89 c2                	mov    %eax,%edx
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	01 d0                	add    %edx,%eax
  800a19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a1c:	88 10                	mov    %dl,(%eax)
  800a1e:	eb 56                	jmp    800a76 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a20:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a24:	75 1f                	jne    800a45 <readline+0xc5>
  800a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a2a:	7e 19                	jle    800a45 <readline+0xc5>
			if (echoing)
  800a2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a30:	74 0e                	je     800a40 <readline+0xc0>
				cputchar(c);
  800a32:	83 ec 0c             	sub    $0xc,%esp
  800a35:	ff 75 ec             	pushl  -0x14(%ebp)
  800a38:	e8 63 0f 00 00       	call   8019a0 <cputchar>
  800a3d:	83 c4 10             	add    $0x10,%esp

			i--;
  800a40:	ff 4d f4             	decl   -0xc(%ebp)
  800a43:	eb 31                	jmp    800a76 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a45:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a49:	74 0a                	je     800a55 <readline+0xd5>
  800a4b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a4f:	0f 85 61 ff ff ff    	jne    8009b6 <readline+0x36>
			if (echoing)
  800a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a59:	74 0e                	je     800a69 <readline+0xe9>
				cputchar(c);
  800a5b:	83 ec 0c             	sub    $0xc,%esp
  800a5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800a61:	e8 3a 0f 00 00       	call   8019a0 <cputchar>
  800a66:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a74:	eb 06                	jmp    800a7c <readline+0xfc>
		}
	}
  800a76:	e9 3b ff ff ff       	jmp    8009b6 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a7b:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a84:	e8 de 09 00 00       	call   801467 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a8d:	74 13                	je     800aa2 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	68 90 21 80 00       	push   $0x802190
  800a9a:	e8 5f f8 ff ff       	call   8002fe <cprintf>
  800a9f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800aa9:	83 ec 0c             	sub    $0xc,%esp
  800aac:	6a 00                	push   $0x0
  800aae:	e8 83 0f 00 00       	call   801a36 <iscons>
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ab9:	e8 2a 0f 00 00       	call   8019e8 <getchar>
  800abe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ac1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ac5:	79 23                	jns    800aea <atomic_readline+0x6c>
			if (c != -E_EOF)
  800ac7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800acb:	74 13                	je     800ae0 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad3:	68 93 21 80 00       	push   $0x802193
  800ad8:	e8 21 f8 ff ff       	call   8002fe <cprintf>
  800add:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ae0:	e8 9c 09 00 00       	call   801481 <sys_enable_interrupt>
			return;
  800ae5:	e9 9a 00 00 00       	jmp    800b84 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aea:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800aee:	7e 34                	jle    800b24 <atomic_readline+0xa6>
  800af0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800af7:	7f 2b                	jg     800b24 <atomic_readline+0xa6>
			if (echoing)
  800af9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800afd:	74 0e                	je     800b0d <atomic_readline+0x8f>
				cputchar(c);
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	ff 75 ec             	pushl  -0x14(%ebp)
  800b05:	e8 96 0e 00 00       	call   8019a0 <cputchar>
  800b0a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b10:	8d 50 01             	lea    0x1(%eax),%edx
  800b13:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b16:	89 c2                	mov    %eax,%edx
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	01 d0                	add    %edx,%eax
  800b1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
  800b22:	eb 5b                	jmp    800b7f <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b24:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b28:	75 1f                	jne    800b49 <atomic_readline+0xcb>
  800b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b2e:	7e 19                	jle    800b49 <atomic_readline+0xcb>
			if (echoing)
  800b30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b34:	74 0e                	je     800b44 <atomic_readline+0xc6>
				cputchar(c);
  800b36:	83 ec 0c             	sub    $0xc,%esp
  800b39:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3c:	e8 5f 0e 00 00       	call   8019a0 <cputchar>
  800b41:	83 c4 10             	add    $0x10,%esp
			i--;
  800b44:	ff 4d f4             	decl   -0xc(%ebp)
  800b47:	eb 36                	jmp    800b7f <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b49:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b4d:	74 0a                	je     800b59 <atomic_readline+0xdb>
  800b4f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b53:	0f 85 60 ff ff ff    	jne    800ab9 <atomic_readline+0x3b>
			if (echoing)
  800b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b5d:	74 0e                	je     800b6d <atomic_readline+0xef>
				cputchar(c);
  800b5f:	83 ec 0c             	sub    $0xc,%esp
  800b62:	ff 75 ec             	pushl  -0x14(%ebp)
  800b65:	e8 36 0e 00 00       	call   8019a0 <cputchar>
  800b6a:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	01 d0                	add    %edx,%eax
  800b75:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b78:	e8 04 09 00 00       	call   801481 <sys_enable_interrupt>
			return;
  800b7d:	eb 05                	jmp    800b84 <atomic_readline+0x106>
		}
	}
  800b7f:	e9 35 ff ff ff       	jmp    800ab9 <atomic_readline+0x3b>
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b93:	eb 06                	jmp    800b9b <strlen+0x15>
		n++;
  800b95:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b98:	ff 45 08             	incl   0x8(%ebp)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	84 c0                	test   %al,%al
  800ba2:	75 f1                	jne    800b95 <strlen+0xf>
		n++;
	return n;
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800baf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb6:	eb 09                	jmp    800bc1 <strnlen+0x18>
		n++;
  800bb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	ff 4d 0c             	decl   0xc(%ebp)
  800bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc5:	74 09                	je     800bd0 <strnlen+0x27>
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	84 c0                	test   %al,%al
  800bce:	75 e8                	jne    800bb8 <strnlen+0xf>
		n++;
	return n;
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be1:	90                   	nop
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8d 50 01             	lea    0x1(%eax),%edx
  800be8:	89 55 08             	mov    %edx,0x8(%ebp)
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf4:	8a 12                	mov    (%edx),%dl
  800bf6:	88 10                	mov    %dl,(%eax)
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	75 e4                	jne    800be2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c16:	eb 1f                	jmp    800c37 <strncpy+0x34>
		*dst++ = *src;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c24:	8a 12                	mov    (%edx),%dl
  800c26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	8a 00                	mov    (%eax),%al
  800c2d:	84 c0                	test   %al,%al
  800c2f:	74 03                	je     800c34 <strncpy+0x31>
			src++;
  800c31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c34:	ff 45 fc             	incl   -0x4(%ebp)
  800c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c3d:	72 d9                	jb     800c18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c54:	74 30                	je     800c86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c56:	eb 16                	jmp    800c6e <strlcpy+0x2a>
			*dst++ = *src++;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6e:	ff 4d 10             	decl   0x10(%ebp)
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 09                	je     800c80 <strlcpy+0x3c>
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	84 c0                	test   %al,%al
  800c7e:	75 d8                	jne    800c58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8c:	29 c2                	sub    %eax,%edx
  800c8e:	89 d0                	mov    %edx,%eax
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c95:	eb 06                	jmp    800c9d <strcmp+0xb>
		p++, q++;
  800c97:	ff 45 08             	incl   0x8(%ebp)
  800c9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	74 0e                	je     800cb4 <strcmp+0x22>
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 10                	mov    (%eax),%dl
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	38 c2                	cmp    %al,%dl
  800cb2:	74 e3                	je     800c97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f b6 d0             	movzbl %al,%edx
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	0f b6 c0             	movzbl %al,%eax
  800cc4:	29 c2                	sub    %eax,%edx
  800cc6:	89 d0                	mov    %edx,%eax
}
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ccd:	eb 09                	jmp    800cd8 <strncmp+0xe>
		n--, p++, q++;
  800ccf:	ff 4d 10             	decl   0x10(%ebp)
  800cd2:	ff 45 08             	incl   0x8(%ebp)
  800cd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdc:	74 17                	je     800cf5 <strncmp+0x2b>
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	84 c0                	test   %al,%al
  800ce5:	74 0e                	je     800cf5 <strncmp+0x2b>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 da                	je     800ccf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf9:	75 07                	jne    800d02 <strncmp+0x38>
		return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800d00:	eb 14                	jmp    800d16 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f b6 d0             	movzbl %al,%edx
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f b6 c0             	movzbl %al,%eax
  800d12:	29 c2                	sub    %eax,%edx
  800d14:	89 d0                	mov    %edx,%eax
}
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d24:	eb 12                	jmp    800d38 <strchr+0x20>
		if (*s == c)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2e:	75 05                	jne    800d35 <strchr+0x1d>
			return (char *) s;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	eb 11                	jmp    800d46 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	84 c0                	test   %al,%al
  800d3f:	75 e5                	jne    800d26 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 04             	sub    $0x4,%esp
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d54:	eb 0d                	jmp    800d63 <strfind+0x1b>
		if (*s == c)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5e:	74 0e                	je     800d6e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 ea                	jne    800d56 <strfind+0xe>
  800d6c:	eb 01                	jmp    800d6f <strfind+0x27>
		if (*s == c)
			break;
  800d6e:	90                   	nop
	return (char *) s;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d86:	eb 0e                	jmp    800d96 <memset+0x22>
		*p++ = c;
  800d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d94:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d96:	ff 4d f8             	decl   -0x8(%ebp)
  800d99:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d9d:	79 e9                	jns    800d88 <memset+0x14>
		*p++ = c;

	return v;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db6:	eb 16                	jmp    800dce <memcpy+0x2a>
		*d++ = *s++;
  800db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dca:	8a 12                	mov    (%edx),%dl
  800dcc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	75 dd                	jne    800db8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df8:	73 50                	jae    800e4a <memmove+0x6a>
  800dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e05:	76 43                	jbe    800e4a <memmove+0x6a>
		s += n;
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e13:	eb 10                	jmp    800e25 <memmove+0x45>
			*--d = *--s;
  800e15:	ff 4d f8             	decl   -0x8(%ebp)
  800e18:	ff 4d fc             	decl   -0x4(%ebp)
  800e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1e:	8a 10                	mov    (%eax),%dl
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	75 e3                	jne    800e15 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e32:	eb 23                	jmp    800e57 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e37:	8d 50 01             	lea    0x1(%eax),%edx
  800e3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e43:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e46:	8a 12                	mov    (%edx),%dl
  800e48:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e50:	89 55 10             	mov    %edx,0x10(%ebp)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 dd                	jne    800e34 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6e:	eb 2a                	jmp    800e9a <memcmp+0x3e>
		if (*s1 != *s2)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	8a 10                	mov    (%eax),%dl
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	38 c2                	cmp    %al,%dl
  800e7c:	74 16                	je     800e94 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 d0             	movzbl %al,%edx
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	0f b6 c0             	movzbl %al,%eax
  800e8e:	29 c2                	sub    %eax,%edx
  800e90:	89 d0                	mov    %edx,%eax
  800e92:	eb 18                	jmp    800eac <memcmp+0x50>
		s1++, s2++;
  800e94:	ff 45 fc             	incl   -0x4(%ebp)
  800e97:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	75 c9                	jne    800e70 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	01 d0                	add    %edx,%eax
  800ebc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebf:	eb 15                	jmp    800ed6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	0f b6 d0             	movzbl %al,%edx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	0f b6 c0             	movzbl %al,%eax
  800ecf:	39 c2                	cmp    %eax,%edx
  800ed1:	74 0d                	je     800ee0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed3:	ff 45 08             	incl   0x8(%ebp)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800edc:	72 e3                	jb     800ec1 <memfind+0x13>
  800ede:	eb 01                	jmp    800ee1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee0:	90                   	nop
	return (void *) s;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efa:	eb 03                	jmp    800eff <strtol+0x19>
		s++;
  800efc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 20                	cmp    $0x20,%al
  800f06:	74 f4                	je     800efc <strtol+0x16>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 09                	cmp    $0x9,%al
  800f0f:	74 eb                	je     800efc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 2b                	cmp    $0x2b,%al
  800f18:	75 05                	jne    800f1f <strtol+0x39>
		s++;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	eb 13                	jmp    800f32 <strtol+0x4c>
	else if (*s == '-')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 2d                	cmp    $0x2d,%al
  800f26:	75 0a                	jne    800f32 <strtol+0x4c>
		s++, neg = 1;
  800f28:	ff 45 08             	incl   0x8(%ebp)
  800f2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 06                	je     800f3e <strtol+0x58>
  800f38:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f3c:	75 20                	jne    800f5e <strtol+0x78>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 30                	cmp    $0x30,%al
  800f45:	75 17                	jne    800f5e <strtol+0x78>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	40                   	inc    %eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 78                	cmp    $0x78,%al
  800f4f:	75 0d                	jne    800f5e <strtol+0x78>
		s += 2, base = 16;
  800f51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f5c:	eb 28                	jmp    800f86 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	75 15                	jne    800f79 <strtol+0x93>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 30                	cmp    $0x30,%al
  800f6b:	75 0c                	jne    800f79 <strtol+0x93>
		s++, base = 8;
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f77:	eb 0d                	jmp    800f86 <strtol+0xa0>
	else if (base == 0)
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 07                	jne    800f86 <strtol+0xa0>
		base = 10;
  800f7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 2f                	cmp    $0x2f,%al
  800f8d:	7e 19                	jle    800fa8 <strtol+0xc2>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 39                	cmp    $0x39,%al
  800f96:	7f 10                	jg     800fa8 <strtol+0xc2>
			dig = *s - '0';
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f be c0             	movsbl %al,%eax
  800fa0:	83 e8 30             	sub    $0x30,%eax
  800fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa6:	eb 42                	jmp    800fea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 60                	cmp    $0x60,%al
  800faf:	7e 19                	jle    800fca <strtol+0xe4>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 7a                	cmp    $0x7a,%al
  800fb8:	7f 10                	jg     800fca <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	83 e8 57             	sub    $0x57,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc8:	eb 20                	jmp    800fea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 40                	cmp    $0x40,%al
  800fd1:	7e 39                	jle    80100c <strtol+0x126>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 5a                	cmp    $0x5a,%al
  800fda:	7f 30                	jg     80100c <strtol+0x126>
			dig = *s - 'A' + 10;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f be c0             	movsbl %al,%eax
  800fe4:	83 e8 37             	sub    $0x37,%eax
  800fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fed:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff0:	7d 19                	jge    80100b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801001:	01 d0                	add    %edx,%eax
  801003:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801006:	e9 7b ff ff ff       	jmp    800f86 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80100c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801010:	74 08                	je     80101a <strtol+0x134>
		*endptr = (char *) s;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101e:	74 07                	je     801027 <strtol+0x141>
  801020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801023:	f7 d8                	neg    %eax
  801025:	eb 03                	jmp    80102a <strtol+0x144>
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <ltostr>:

void
ltostr(long value, char *str)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801039:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801044:	79 13                	jns    801059 <ltostr+0x2d>
	{
		neg = 1;
  801046:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801053:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801056:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801061:	99                   	cltd   
  801062:	f7 f9                	idiv   %ecx
  801064:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106a:	8d 50 01             	lea    0x1(%eax),%edx
  80106d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801070:	89 c2                	mov    %eax,%edx
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107a:	83 c2 30             	add    $0x30,%edx
  80107d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801082:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801087:	f7 e9                	imul   %ecx
  801089:	c1 fa 02             	sar    $0x2,%edx
  80108c:	89 c8                	mov    %ecx,%eax
  80108e:	c1 f8 1f             	sar    $0x1f,%eax
  801091:	29 c2                	sub    %eax,%edx
  801093:	89 d0                	mov    %edx,%eax
  801095:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a0:	f7 e9                	imul   %ecx
  8010a2:	c1 fa 02             	sar    $0x2,%edx
  8010a5:	89 c8                	mov    %ecx,%eax
  8010a7:	c1 f8 1f             	sar    $0x1f,%eax
  8010aa:	29 c2                	sub    %eax,%edx
  8010ac:	89 d0                	mov    %edx,%eax
  8010ae:	c1 e0 02             	shl    $0x2,%eax
  8010b1:	01 d0                	add    %edx,%eax
  8010b3:	01 c0                	add    %eax,%eax
  8010b5:	29 c1                	sub    %eax,%ecx
  8010b7:	89 ca                	mov    %ecx,%edx
  8010b9:	85 d2                	test   %edx,%edx
  8010bb:	75 9c                	jne    801059 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c7:	48                   	dec    %eax
  8010c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cf:	74 3d                	je     80110e <ltostr+0xe2>
		start = 1 ;
  8010d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d8:	eb 34                	jmp    80110e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	01 c2                	add    %eax,%edx
  8010ef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f5:	01 c8                	add    %ecx,%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 c2                	add    %eax,%edx
  801103:	8a 45 eb             	mov    -0x15(%ebp),%al
  801106:	88 02                	mov    %al,(%edx)
		start++ ;
  801108:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801111:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801114:	7c c4                	jl     8010da <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801116:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 d0                	add    %edx,%eax
  80111e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801121:	90                   	nop
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112a:	ff 75 08             	pushl  0x8(%ebp)
  80112d:	e8 54 fa ff ff       	call   800b86 <strlen>
  801132:	83 c4 04             	add    $0x4,%esp
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801138:	ff 75 0c             	pushl  0xc(%ebp)
  80113b:	e8 46 fa ff ff       	call   800b86 <strlen>
  801140:	83 c4 04             	add    $0x4,%esp
  801143:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801154:	eb 17                	jmp    80116d <strcconcat+0x49>
		final[s] = str1[s] ;
  801156:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 c2                	add    %eax,%edx
  80115e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	01 c8                	add    %ecx,%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116a:	ff 45 fc             	incl   -0x4(%ebp)
  80116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801170:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801173:	7c e1                	jl     801156 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801175:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801183:	eb 1f                	jmp    8011a4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 c8                	add    %ecx,%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a1:	ff 45 f8             	incl   -0x8(%ebp)
  8011a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011aa:	7c d9                	jl     801185 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b7:	90                   	nop
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011dd:	eb 0c                	jmp    8011eb <strsplit+0x31>
			*string++ = 0;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8d 50 01             	lea    0x1(%eax),%edx
  8011e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	84 c0                	test   %al,%al
  8011f2:	74 18                	je     80120c <strsplit+0x52>
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	0f be c0             	movsbl %al,%eax
  8011fc:	50                   	push   %eax
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 13 fb ff ff       	call   800d18 <strchr>
  801205:	83 c4 08             	add    $0x8,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	75 d3                	jne    8011df <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 5a                	je     80126f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801215:	8b 45 14             	mov    0x14(%ebp),%eax
  801218:	8b 00                	mov    (%eax),%eax
  80121a:	83 f8 0f             	cmp    $0xf,%eax
  80121d:	75 07                	jne    801226 <strsplit+0x6c>
		{
			return 0;
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
  801224:	eb 66                	jmp    80128c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801226:	8b 45 14             	mov    0x14(%ebp),%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	8d 48 01             	lea    0x1(%eax),%ecx
  80122e:	8b 55 14             	mov    0x14(%ebp),%edx
  801231:	89 0a                	mov    %ecx,(%edx)
  801233:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123a:	8b 45 10             	mov    0x10(%ebp),%eax
  80123d:	01 c2                	add    %eax,%edx
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801244:	eb 03                	jmp    801249 <strsplit+0x8f>
			string++;
  801246:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	84 c0                	test   %al,%al
  801250:	74 8b                	je     8011dd <strsplit+0x23>
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	0f be c0             	movsbl %al,%eax
  80125a:	50                   	push   %eax
  80125b:	ff 75 0c             	pushl  0xc(%ebp)
  80125e:	e8 b5 fa ff ff       	call   800d18 <strchr>
  801263:	83 c4 08             	add    $0x8,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	74 dc                	je     801246 <strsplit+0x8c>
			string++;
	}
  80126a:	e9 6e ff ff ff       	jmp    8011dd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801270:	8b 45 14             	mov    0x14(%ebp),%eax
  801273:	8b 00                	mov    (%eax),%eax
  801275:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801287:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	57                   	push   %edi
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
  801294:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012a9:	cd 30                	int    $0x30
  8012ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	5b                   	pop    %ebx
  8012b5:	5e                   	pop    %esi
  8012b6:	5f                   	pop    %edi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	52                   	push   %edx
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	50                   	push   %eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	e8 b2 ff ff ff       	call   80128e <syscall>
  8012dc:	83 c4 18             	add    $0x18,%esp
}
  8012df:	90                   	nop
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 01                	push   $0x1
  8012f1:	e8 98 ff ff ff       	call   80128e <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	52                   	push   %edx
  80130b:	50                   	push   %eax
  80130c:	6a 05                	push   $0x5
  80130e:	e8 7b ff ff ff       	call   80128e <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131d:	8b 75 18             	mov    0x18(%ebp),%esi
  801320:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801323:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801326:	8b 55 0c             	mov    0xc(%ebp),%edx
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	51                   	push   %ecx
  80132f:	52                   	push   %edx
  801330:	50                   	push   %eax
  801331:	6a 06                	push   $0x6
  801333:	e8 56 ff ff ff       	call   80128e <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	52                   	push   %edx
  801352:	50                   	push   %eax
  801353:	6a 07                	push   $0x7
  801355:	e8 34 ff ff ff       	call   80128e <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	6a 08                	push   $0x8
  801370:	e8 19 ff ff ff       	call   80128e <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 09                	push   $0x9
  801389:	e8 00 ff ff ff       	call   80128e <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 0a                	push   $0xa
  8013a2:	e8 e7 fe ff ff       	call   80128e <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 0b                	push   $0xb
  8013bb:	e8 ce fe ff ff       	call   80128e <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	ff 75 0c             	pushl  0xc(%ebp)
  8013d1:	ff 75 08             	pushl  0x8(%ebp)
  8013d4:	6a 0f                	push   $0xf
  8013d6:	e8 b3 fe ff ff       	call   80128e <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
	return;
  8013de:	90                   	nop
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	6a 10                	push   $0x10
  8013f2:	e8 97 fe ff ff       	call   80128e <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013fa:	90                   	nop
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	ff 75 10             	pushl  0x10(%ebp)
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	6a 11                	push   $0x11
  80140f:	e8 7a fe ff ff       	call   80128e <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
	return ;
  801417:	90                   	nop
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 0c                	push   $0xc
  801429:	e8 60 fe ff ff       	call   80128e <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	6a 0d                	push   $0xd
  801443:	e8 46 fe ff ff       	call   80128e <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 0e                	push   $0xe
  80145c:	e8 2d fe ff ff       	call   80128e <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 13                	push   $0x13
  801476:	e8 13 fe ff ff       	call   80128e <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
}
  80147e:	90                   	nop
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 14                	push   $0x14
  801490:	e8 f9 fd ff ff       	call   80128e <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_cputc>:


void
sys_cputc(const char c)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	50                   	push   %eax
  8014b4:	6a 15                	push   $0x15
  8014b6:	e8 d3 fd ff ff       	call   80128e <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
}
  8014be:	90                   	nop
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 16                	push   $0x16
  8014d0:	e8 b9 fd ff ff       	call   80128e <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	6a 17                	push   $0x17
  8014ed:	e8 9c fd ff ff       	call   80128e <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 1a                	push   $0x1a
  80150a:	e8 7f fd ff ff       	call   80128e <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	6a 18                	push   $0x18
  801527:	e8 62 fd ff ff       	call   80128e <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	90                   	nop
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801535:	8b 55 0c             	mov    0xc(%ebp),%edx
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 19                	push   $0x19
  801545:	e8 44 fd ff ff       	call   80128e <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	90                   	nop
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80155c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80155f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	6a 00                	push   $0x0
  801568:	51                   	push   %ecx
  801569:	52                   	push   %edx
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	50                   	push   %eax
  80156e:	6a 1b                	push   $0x1b
  801570:	e8 19 fd ff ff       	call   80128e <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	52                   	push   %edx
  80158a:	50                   	push   %eax
  80158b:	6a 1c                	push   $0x1c
  80158d:	e8 fc fc ff ff       	call   80128e <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80159a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	51                   	push   %ecx
  8015a8:	52                   	push   %edx
  8015a9:	50                   	push   %eax
  8015aa:	6a 1d                	push   $0x1d
  8015ac:	e8 dd fc ff ff       	call   80128e <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	52                   	push   %edx
  8015c6:	50                   	push   %eax
  8015c7:	6a 1e                	push   $0x1e
  8015c9:	e8 c0 fc ff ff       	call   80128e <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 1f                	push   $0x1f
  8015e2:	e8 a7 fc ff ff       	call   80128e <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	6a 00                	push   $0x0
  8015f4:	ff 75 14             	pushl  0x14(%ebp)
  8015f7:	ff 75 10             	pushl  0x10(%ebp)
  8015fa:	ff 75 0c             	pushl  0xc(%ebp)
  8015fd:	50                   	push   %eax
  8015fe:	6a 20                	push   $0x20
  801600:	e8 89 fc ff ff       	call   80128e <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	50                   	push   %eax
  801619:	6a 21                	push   $0x21
  80161b:	e8 6e fc ff ff       	call   80128e <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	50                   	push   %eax
  801635:	6a 22                	push   $0x22
  801637:	e8 52 fc ff ff       	call   80128e <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 02                	push   $0x2
  801650:	e8 39 fc ff ff       	call   80128e <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 03                	push   $0x3
  801669:	e8 20 fc ff ff       	call   80128e <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 04                	push   $0x4
  801682:	e8 07 fc ff ff       	call   80128e <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_exit_env>:


void sys_exit_env(void)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 23                	push   $0x23
  80169b:	e8 ee fb ff ff       	call   80128e <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	90                   	nop
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016af:	8d 50 04             	lea    0x4(%eax),%edx
  8016b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 24                	push   $0x24
  8016bf:	e8 ca fb ff ff       	call   80128e <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d0:	89 01                	mov    %eax,(%ecx)
  8016d2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	c9                   	leave  
  8016d9:	c2 04 00             	ret    $0x4

008016dc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 10             	pushl  0x10(%ebp)
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	6a 12                	push   $0x12
  8016ee:	e8 9b fb ff ff       	call   80128e <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f6:	90                   	nop
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 25                	push   $0x25
  801708:	e8 81 fb ff ff       	call   80128e <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80171e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	50                   	push   %eax
  80172b:	6a 26                	push   $0x26
  80172d:	e8 5c fb ff ff       	call   80128e <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
	return ;
  801735:	90                   	nop
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <rsttst>:
void rsttst()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 28                	push   $0x28
  801747:	e8 42 fb ff ff       	call   80128e <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
	return ;
  80174f:	90                   	nop
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	8b 45 14             	mov    0x14(%ebp),%eax
  80175b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80175e:	8b 55 18             	mov    0x18(%ebp),%edx
  801761:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801765:	52                   	push   %edx
  801766:	50                   	push   %eax
  801767:	ff 75 10             	pushl  0x10(%ebp)
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	6a 27                	push   $0x27
  801772:	e8 17 fb ff ff       	call   80128e <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
	return ;
  80177a:	90                   	nop
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <chktst>:
void chktst(uint32 n)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	6a 29                	push   $0x29
  80178d:	e8 fc fa ff ff       	call   80128e <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
	return ;
  801795:	90                   	nop
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <inctst>:

void inctst()
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 2a                	push   $0x2a
  8017a7:	e8 e2 fa ff ff       	call   80128e <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <gettst>:
uint32 gettst()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 2b                	push   $0x2b
  8017c1:	e8 c8 fa ff ff       	call   80128e <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 2c                	push   $0x2c
  8017dd:	e8 ac fa ff ff       	call   80128e <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
  8017e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017e8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017ec:	75 07                	jne    8017f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f3:	eb 05                	jmp    8017fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 2c                	push   $0x2c
  80180e:	e8 7b fa ff ff       	call   80128e <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
  801816:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801819:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80181d:	75 07                	jne    801826 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80181f:	b8 01 00 00 00       	mov    $0x1,%eax
  801824:	eb 05                	jmp    80182b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 2c                	push   $0x2c
  80183f:	e8 4a fa ff ff       	call   80128e <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
  801847:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80184a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80184e:	75 07                	jne    801857 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801850:	b8 01 00 00 00       	mov    $0x1,%eax
  801855:	eb 05                	jmp    80185c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 2c                	push   $0x2c
  801870:	e8 19 fa ff ff       	call   80128e <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
  801878:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80187b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80187f:	75 07                	jne    801888 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801881:	b8 01 00 00 00       	mov    $0x1,%eax
  801886:	eb 05                	jmp    80188d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	6a 2d                	push   $0x2d
  80189f:	e8 ea f9 ff ff       	call   80128e <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a7:	90                   	nop
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	53                   	push   %ebx
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 2e                	push   $0x2e
  8018c2:	e8 c7 f9 ff ff       	call   80128e <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 2f                	push   $0x2f
  8018e2:	e8 a7 f9 ff ff       	call   80128e <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f5:	89 d0                	mov    %edx,%eax
  8018f7:	c1 e0 02             	shl    $0x2,%eax
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801903:	01 d0                	add    %edx,%eax
  801905:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80190c:	01 d0                	add    %edx,%eax
  80190e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801915:	01 d0                	add    %edx,%eax
  801917:	c1 e0 04             	shl    $0x4,%eax
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80191d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801924:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	50                   	push   %eax
  80192b:	e8 76 fd ff ff       	call   8016a6 <sys_get_virtual_time>
  801930:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801933:	eb 41                	jmp    801976 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801935:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	50                   	push   %eax
  80193c:	e8 65 fd ff ff       	call   8016a6 <sys_get_virtual_time>
  801941:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194a:	29 c2                	sub    %eax,%edx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801951:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801957:	89 d1                	mov    %edx,%ecx
  801959:	29 c1                	sub    %eax,%ecx
  80195b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80195e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801961:	39 c2                	cmp    %eax,%edx
  801963:	0f 97 c0             	seta   %al
  801966:	0f b6 c0             	movzbl %al,%eax
  801969:	29 c1                	sub    %eax,%ecx
  80196b:	89 c8                	mov    %ecx,%eax
  80196d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801970:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801973:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801979:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80197c:	72 b7                	jb     801935 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80197e:	90                   	nop
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80198e:	eb 03                	jmp    801993 <busy_wait+0x12>
  801990:	ff 45 fc             	incl   -0x4(%ebp)
  801993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801996:	3b 45 08             	cmp    0x8(%ebp),%eax
  801999:	72 f5                	jb     801990 <busy_wait+0xf>
	return i;
  80199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019ac:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	50                   	push   %eax
  8019b4:	e8 e2 fa ff ff       	call   80149b <sys_cputc>
  8019b9:	83 c4 10             	add    $0x10,%esp
}
  8019bc:	90                   	nop
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019c5:	e8 9d fa ff ff       	call   801467 <sys_disable_interrupt>
	char c = ch;
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019d0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	50                   	push   %eax
  8019d8:	e8 be fa ff ff       	call   80149b <sys_cputc>
  8019dd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019e0:	e8 9c fa ff ff       	call   801481 <sys_enable_interrupt>
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <getchar>:

int
getchar(void)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019f5:	eb 08                	jmp    8019ff <getchar+0x17>
	{
		c = sys_cgetc();
  8019f7:	e8 e6 f8 ff ff       	call   8012e2 <sys_cgetc>
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a03:	74 f2                	je     8019f7 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <atomic_getchar>:

int
atomic_getchar(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a10:	e8 52 fa ff ff       	call   801467 <sys_disable_interrupt>
	int c=0;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a1c:	eb 08                	jmp    801a26 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a1e:	e8 bf f8 ff ff       	call   8012e2 <sys_cgetc>
  801a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2a:	74 f2                	je     801a1e <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a2c:	e8 50 fa ff ff       	call   801481 <sys_enable_interrupt>
	return c;
  801a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <iscons>:

int iscons(int fdnum)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <__udivdi3>:
  801a40:	55                   	push   %ebp
  801a41:	57                   	push   %edi
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	83 ec 1c             	sub    $0x1c,%esp
  801a47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a57:	89 ca                	mov    %ecx,%edx
  801a59:	89 f8                	mov    %edi,%eax
  801a5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a5f:	85 f6                	test   %esi,%esi
  801a61:	75 2d                	jne    801a90 <__udivdi3+0x50>
  801a63:	39 cf                	cmp    %ecx,%edi
  801a65:	77 65                	ja     801acc <__udivdi3+0x8c>
  801a67:	89 fd                	mov    %edi,%ebp
  801a69:	85 ff                	test   %edi,%edi
  801a6b:	75 0b                	jne    801a78 <__udivdi3+0x38>
  801a6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a72:	31 d2                	xor    %edx,%edx
  801a74:	f7 f7                	div    %edi
  801a76:	89 c5                	mov    %eax,%ebp
  801a78:	31 d2                	xor    %edx,%edx
  801a7a:	89 c8                	mov    %ecx,%eax
  801a7c:	f7 f5                	div    %ebp
  801a7e:	89 c1                	mov    %eax,%ecx
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	f7 f5                	div    %ebp
  801a84:	89 cf                	mov    %ecx,%edi
  801a86:	89 fa                	mov    %edi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	77 28                	ja     801abc <__udivdi3+0x7c>
  801a94:	0f bd fe             	bsr    %esi,%edi
  801a97:	83 f7 1f             	xor    $0x1f,%edi
  801a9a:	75 40                	jne    801adc <__udivdi3+0x9c>
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	72 0a                	jb     801aaa <__udivdi3+0x6a>
  801aa0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa4:	0f 87 9e 00 00 00    	ja     801b48 <__udivdi3+0x108>
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	89 fa                	mov    %edi,%edx
  801ab1:	83 c4 1c             	add    $0x1c,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	8d 76 00             	lea    0x0(%esi),%esi
  801abc:	31 ff                	xor    %edi,%edi
  801abe:	31 c0                	xor    %eax,%eax
  801ac0:	89 fa                	mov    %edi,%edx
  801ac2:	83 c4 1c             	add    $0x1c,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5f                   	pop    %edi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	f7 f7                	div    %edi
  801ad0:	31 ff                	xor    %edi,%edi
  801ad2:	89 fa                	mov    %edi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae1:	89 eb                	mov    %ebp,%ebx
  801ae3:	29 fb                	sub    %edi,%ebx
  801ae5:	89 f9                	mov    %edi,%ecx
  801ae7:	d3 e6                	shl    %cl,%esi
  801ae9:	89 c5                	mov    %eax,%ebp
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 ed                	shr    %cl,%ebp
  801aef:	89 e9                	mov    %ebp,%ecx
  801af1:	09 f1                	or     %esi,%ecx
  801af3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e0                	shl    %cl,%eax
  801afb:	89 c5                	mov    %eax,%ebp
  801afd:	89 d6                	mov    %edx,%esi
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 ee                	shr    %cl,%esi
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e2                	shl    %cl,%edx
  801b07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 e8                	shr    %cl,%eax
  801b0f:	09 c2                	or     %eax,%edx
  801b11:	89 d0                	mov    %edx,%eax
  801b13:	89 f2                	mov    %esi,%edx
  801b15:	f7 74 24 0c          	divl   0xc(%esp)
  801b19:	89 d6                	mov    %edx,%esi
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	f7 e5                	mul    %ebp
  801b1f:	39 d6                	cmp    %edx,%esi
  801b21:	72 19                	jb     801b3c <__udivdi3+0xfc>
  801b23:	74 0b                	je     801b30 <__udivdi3+0xf0>
  801b25:	89 d8                	mov    %ebx,%eax
  801b27:	31 ff                	xor    %edi,%edi
  801b29:	e9 58 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b34:	89 f9                	mov    %edi,%ecx
  801b36:	d3 e2                	shl    %cl,%edx
  801b38:	39 c2                	cmp    %eax,%edx
  801b3a:	73 e9                	jae    801b25 <__udivdi3+0xe5>
  801b3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b3f:	31 ff                	xor    %edi,%edi
  801b41:	e9 40 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	31 c0                	xor    %eax,%eax
  801b4a:	e9 37 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b4f:	90                   	nop

00801b50 <__umoddi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b6f:	89 f3                	mov    %esi,%ebx
  801b71:	89 fa                	mov    %edi,%edx
  801b73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b77:	89 34 24             	mov    %esi,(%esp)
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	75 1a                	jne    801b98 <__umoddi3+0x48>
  801b7e:	39 f7                	cmp    %esi,%edi
  801b80:	0f 86 a2 00 00 00    	jbe    801c28 <__umoddi3+0xd8>
  801b86:	89 c8                	mov    %ecx,%eax
  801b88:	89 f2                	mov    %esi,%edx
  801b8a:	f7 f7                	div    %edi
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	31 d2                	xor    %edx,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	39 f0                	cmp    %esi,%eax
  801b9a:	0f 87 ac 00 00 00    	ja     801c4c <__umoddi3+0xfc>
  801ba0:	0f bd e8             	bsr    %eax,%ebp
  801ba3:	83 f5 1f             	xor    $0x1f,%ebp
  801ba6:	0f 84 ac 00 00 00    	je     801c58 <__umoddi3+0x108>
  801bac:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb1:	29 ef                	sub    %ebp,%edi
  801bb3:	89 fe                	mov    %edi,%esi
  801bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e0                	shl    %cl,%eax
  801bbd:	89 d7                	mov    %edx,%edi
  801bbf:	89 f1                	mov    %esi,%ecx
  801bc1:	d3 ef                	shr    %cl,%edi
  801bc3:	09 c7                	or     %eax,%edi
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e2                	shl    %cl,%edx
  801bc9:	89 14 24             	mov    %edx,(%esp)
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	d3 e0                	shl    %cl,%eax
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd6:	d3 e0                	shl    %cl,%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be0:	89 f1                	mov    %esi,%ecx
  801be2:	d3 e8                	shr    %cl,%eax
  801be4:	09 d0                	or     %edx,%eax
  801be6:	d3 eb                	shr    %cl,%ebx
  801be8:	89 da                	mov    %ebx,%edx
  801bea:	f7 f7                	div    %edi
  801bec:	89 d3                	mov    %edx,%ebx
  801bee:	f7 24 24             	mull   (%esp)
  801bf1:	89 c6                	mov    %eax,%esi
  801bf3:	89 d1                	mov    %edx,%ecx
  801bf5:	39 d3                	cmp    %edx,%ebx
  801bf7:	0f 82 87 00 00 00    	jb     801c84 <__umoddi3+0x134>
  801bfd:	0f 84 91 00 00 00    	je     801c94 <__umoddi3+0x144>
  801c03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c07:	29 f2                	sub    %esi,%edx
  801c09:	19 cb                	sbb    %ecx,%ebx
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c11:	d3 e0                	shl    %cl,%eax
  801c13:	89 e9                	mov    %ebp,%ecx
  801c15:	d3 ea                	shr    %cl,%edx
  801c17:	09 d0                	or     %edx,%eax
  801c19:	89 e9                	mov    %ebp,%ecx
  801c1b:	d3 eb                	shr    %cl,%ebx
  801c1d:	89 da                	mov    %ebx,%edx
  801c1f:	83 c4 1c             	add    $0x1c,%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5f                   	pop    %edi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
  801c27:	90                   	nop
  801c28:	89 fd                	mov    %edi,%ebp
  801c2a:	85 ff                	test   %edi,%edi
  801c2c:	75 0b                	jne    801c39 <__umoddi3+0xe9>
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	31 d2                	xor    %edx,%edx
  801c35:	f7 f7                	div    %edi
  801c37:	89 c5                	mov    %eax,%ebp
  801c39:	89 f0                	mov    %esi,%eax
  801c3b:	31 d2                	xor    %edx,%edx
  801c3d:	f7 f5                	div    %ebp
  801c3f:	89 c8                	mov    %ecx,%eax
  801c41:	f7 f5                	div    %ebp
  801c43:	89 d0                	mov    %edx,%eax
  801c45:	e9 44 ff ff ff       	jmp    801b8e <__umoddi3+0x3e>
  801c4a:	66 90                	xchg   %ax,%ax
  801c4c:	89 c8                	mov    %ecx,%eax
  801c4e:	89 f2                	mov    %esi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	3b 04 24             	cmp    (%esp),%eax
  801c5b:	72 06                	jb     801c63 <__umoddi3+0x113>
  801c5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c61:	77 0f                	ja     801c72 <__umoddi3+0x122>
  801c63:	89 f2                	mov    %esi,%edx
  801c65:	29 f9                	sub    %edi,%ecx
  801c67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c6b:	89 14 24             	mov    %edx,(%esp)
  801c6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c76:	8b 14 24             	mov    (%esp),%edx
  801c79:	83 c4 1c             	add    $0x1c,%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5f                   	pop    %edi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
  801c81:	8d 76 00             	lea    0x0(%esi),%esi
  801c84:	2b 04 24             	sub    (%esp),%eax
  801c87:	19 fa                	sbb    %edi,%edx
  801c89:	89 d1                	mov    %edx,%ecx
  801c8b:	89 c6                	mov    %eax,%esi
  801c8d:	e9 71 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c98:	72 ea                	jb     801c84 <__umoddi3+0x134>
  801c9a:	89 d9                	mov    %ebx,%ecx
  801c9c:	e9 62 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
