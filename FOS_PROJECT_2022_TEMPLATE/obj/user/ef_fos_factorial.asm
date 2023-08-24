
obj/user/ef_fos_factorial:     file format elf32-i386


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
  800031:	e8 6c 00 00 00       	call   8000a2 <libmain>
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
	//atomic_readline("Please enter a number:", buff1);
	i1 = 10;
  800048:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)

	int res = factorial(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 1f 00 00 00       	call   800079 <factorial>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 20 19 80 00       	push   $0x801920
  80006e:	e8 7f 02 00 00       	call   8002f2 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	return;
  800076:	90                   	nop
}
  800077:	c9                   	leave  
  800078:	c3                   	ret    

00800079 <factorial>:


int factorial(int n)
{
  800079:	55                   	push   %ebp
  80007a:	89 e5                	mov    %esp,%ebp
  80007c:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  80007f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800083:	7f 07                	jg     80008c <factorial+0x13>
		return 1 ;
  800085:	b8 01 00 00 00       	mov    $0x1,%eax
  80008a:	eb 14                	jmp    8000a0 <factorial+0x27>
	return n * factorial(n-1) ;
  80008c:	8b 45 08             	mov    0x8(%ebp),%eax
  80008f:	48                   	dec    %eax
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	50                   	push   %eax
  800094:	e8 e0 ff ff ff       	call   800079 <factorial>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000a8:	e8 6e 13 00 00       	call   80141b <sys_getenvindex>
  8000ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b3:	89 d0                	mov    %edx,%eax
  8000b5:	01 c0                	add    %eax,%eax
  8000b7:	01 d0                	add    %edx,%eax
  8000b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000c0:	01 c8                	add    %ecx,%eax
  8000c2:	c1 e0 02             	shl    $0x2,%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000ce:	01 c8                	add    %ecx,%eax
  8000d0:	c1 e0 02             	shl    $0x2,%eax
  8000d3:	01 d0                	add    %edx,%eax
  8000d5:	c1 e0 02             	shl    $0x2,%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	c1 e0 03             	shl    $0x3,%eax
  8000dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e2:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e7:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ec:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000f2:	84 c0                	test   %al,%al
  8000f4:	74 0f                	je     800105 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000f6:	a1 20 20 80 00       	mov    0x802020,%eax
  8000fb:	05 18 da 01 00       	add    $0x1da18,%eax
  800100:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800109:	7e 0a                	jle    800115 <libmain+0x73>
		binaryname = argv[0];
  80010b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010e:	8b 00                	mov    (%eax),%eax
  800110:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	ff 75 0c             	pushl  0xc(%ebp)
  80011b:	ff 75 08             	pushl  0x8(%ebp)
  80011e:	e8 15 ff ff ff       	call   800038 <_main>
  800123:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800126:	e8 fd 10 00 00       	call   801228 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	68 4c 19 80 00       	push   $0x80194c
  800133:	e8 8d 01 00 00       	call   8002c5 <cprintf>
  800138:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013b:	a1 20 20 80 00       	mov    0x802020,%eax
  800140:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800146:	a1 20 20 80 00       	mov    0x802020,%eax
  80014b:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	52                   	push   %edx
  800155:	50                   	push   %eax
  800156:	68 74 19 80 00       	push   $0x801974
  80015b:	e8 65 01 00 00       	call   8002c5 <cprintf>
  800160:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800163:	a1 20 20 80 00       	mov    0x802020,%eax
  800168:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80016e:	a1 20 20 80 00       	mov    0x802020,%eax
  800173:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800179:	a1 20 20 80 00       	mov    0x802020,%eax
  80017e:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800184:	51                   	push   %ecx
  800185:	52                   	push   %edx
  800186:	50                   	push   %eax
  800187:	68 9c 19 80 00       	push   $0x80199c
  80018c:	e8 34 01 00 00       	call   8002c5 <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800194:	a1 20 20 80 00       	mov    0x802020,%eax
  800199:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	50                   	push   %eax
  8001a3:	68 f4 19 80 00       	push   $0x8019f4
  8001a8:	e8 18 01 00 00       	call   8002c5 <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 4c 19 80 00       	push   $0x80194c
  8001b8:	e8 08 01 00 00       	call   8002c5 <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c0:	e8 7d 10 00 00       	call   801242 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001c5:	e8 19 00 00 00       	call   8001e3 <exit>
}
  8001ca:	90                   	nop
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	e8 0a 12 00 00       	call   8013e7 <sys_destroy_env>
  8001dd:	83 c4 10             	add    $0x10,%esp
}
  8001e0:	90                   	nop
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <exit>:

void
exit(void)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001e9:	e8 5f 12 00 00       	call   80144d <sys_exit_env>
}
  8001ee:	90                   	nop
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fa:	8b 00                	mov    (%eax),%eax
  8001fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800202:	89 0a                	mov    %ecx,(%edx)
  800204:	8b 55 08             	mov    0x8(%ebp),%edx
  800207:	88 d1                	mov    %dl,%cl
  800209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800210:	8b 45 0c             	mov    0xc(%ebp),%eax
  800213:	8b 00                	mov    (%eax),%eax
  800215:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021a:	75 2c                	jne    800248 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80021c:	a0 24 20 80 00       	mov    0x802024,%al
  800221:	0f b6 c0             	movzbl %al,%eax
  800224:	8b 55 0c             	mov    0xc(%ebp),%edx
  800227:	8b 12                	mov    (%edx),%edx
  800229:	89 d1                	mov    %edx,%ecx
  80022b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022e:	83 c2 08             	add    $0x8,%edx
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	50                   	push   %eax
  800235:	51                   	push   %ecx
  800236:	52                   	push   %edx
  800237:	e8 3e 0e 00 00       	call   80107a <sys_cputs>
  80023c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	8b 40 04             	mov    0x4(%eax),%eax
  80024e:	8d 50 01             	lea    0x1(%eax),%edx
  800251:	8b 45 0c             	mov    0xc(%ebp),%eax
  800254:	89 50 04             	mov    %edx,0x4(%eax)
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800263:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026a:	00 00 00 
	b.cnt = 0;
  80026d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800274:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800277:	ff 75 0c             	pushl  0xc(%ebp)
  80027a:	ff 75 08             	pushl  0x8(%ebp)
  80027d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800283:	50                   	push   %eax
  800284:	68 f1 01 80 00       	push   $0x8001f1
  800289:	e8 11 02 00 00       	call   80049f <vprintfmt>
  80028e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800291:	a0 24 20 80 00       	mov    0x802024,%al
  800296:	0f b6 c0             	movzbl %al,%eax
  800299:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	50                   	push   %eax
  8002a3:	52                   	push   %edx
  8002a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002aa:	83 c0 08             	add    $0x8,%eax
  8002ad:	50                   	push   %eax
  8002ae:	e8 c7 0d 00 00       	call   80107a <sys_cputs>
  8002b3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b6:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002cb:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002d2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e1:	50                   	push   %eax
  8002e2:	e8 73 ff ff ff       	call   80025a <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002f8:	e8 2b 0f 00 00       	call   801228 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800303:	8b 45 08             	mov    0x8(%ebp),%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	ff 75 f4             	pushl  -0xc(%ebp)
  80030c:	50                   	push   %eax
  80030d:	e8 48 ff ff ff       	call   80025a <vcprintf>
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800318:	e8 25 0f 00 00       	call   801242 <sys_enable_interrupt>
	return cnt;
  80031d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	53                   	push   %ebx
  800326:	83 ec 14             	sub    $0x14,%esp
  800329:	8b 45 10             	mov    0x10(%ebp),%eax
  80032c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80032f:	8b 45 14             	mov    0x14(%ebp),%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800335:	8b 45 18             	mov    0x18(%ebp),%eax
  800338:	ba 00 00 00 00       	mov    $0x0,%edx
  80033d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800340:	77 55                	ja     800397 <printnum+0x75>
  800342:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800345:	72 05                	jb     80034c <printnum+0x2a>
  800347:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80034a:	77 4b                	ja     800397 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80034f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800352:	8b 45 18             	mov    0x18(%ebp),%eax
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	52                   	push   %edx
  80035b:	50                   	push   %eax
  80035c:	ff 75 f4             	pushl  -0xc(%ebp)
  80035f:	ff 75 f0             	pushl  -0x10(%ebp)
  800362:	e8 49 13 00 00       	call   8016b0 <__udivdi3>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	ff 75 20             	pushl  0x20(%ebp)
  800370:	53                   	push   %ebx
  800371:	ff 75 18             	pushl  0x18(%ebp)
  800374:	52                   	push   %edx
  800375:	50                   	push   %eax
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a1 ff ff ff       	call   800322 <printnum>
  800381:	83 c4 20             	add    $0x20,%esp
  800384:	eb 1a                	jmp    8003a0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	ff 75 0c             	pushl  0xc(%ebp)
  80038c:	ff 75 20             	pushl  0x20(%ebp)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	ff d0                	call   *%eax
  800394:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800397:	ff 4d 1c             	decl   0x1c(%ebp)
  80039a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80039e:	7f e6                	jg     800386 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ae:	53                   	push   %ebx
  8003af:	51                   	push   %ecx
  8003b0:	52                   	push   %edx
  8003b1:	50                   	push   %eax
  8003b2:	e8 09 14 00 00       	call   8017c0 <__umoddi3>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	05 34 1c 80 00       	add    $0x801c34,%eax
  8003bf:	8a 00                	mov    (%eax),%al
  8003c1:	0f be c0             	movsbl %al,%eax
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ca:	50                   	push   %eax
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	ff d0                	call   *%eax
  8003d0:	83 c4 10             	add    $0x10,%esp
}
  8003d3:	90                   	nop
  8003d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e0:	7e 1c                	jle    8003fe <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	8d 50 08             	lea    0x8(%eax),%edx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	89 10                	mov    %edx,(%eax)
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	83 e8 08             	sub    $0x8,%eax
  8003f7:	8b 50 04             	mov    0x4(%eax),%edx
  8003fa:	8b 00                	mov    (%eax),%eax
  8003fc:	eb 40                	jmp    80043e <getuint+0x65>
	else if (lflag)
  8003fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800402:	74 1e                	je     800422 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	8b 00                	mov    (%eax),%eax
  800409:	8d 50 04             	lea    0x4(%eax),%edx
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	89 10                	mov    %edx,(%eax)
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	83 e8 04             	sub    $0x4,%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	ba 00 00 00 00       	mov    $0x0,%edx
  800420:	eb 1c                	jmp    80043e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	8d 50 04             	lea    0x4(%eax),%edx
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	89 10                	mov    %edx,(%eax)
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	83 e8 04             	sub    $0x4,%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800443:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800447:	7e 1c                	jle    800465 <getint+0x25>
		return va_arg(*ap, long long);
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	8d 50 08             	lea    0x8(%eax),%edx
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	89 10                	mov    %edx,(%eax)
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	83 e8 08             	sub    $0x8,%eax
  80045e:	8b 50 04             	mov    0x4(%eax),%edx
  800461:	8b 00                	mov    (%eax),%eax
  800463:	eb 38                	jmp    80049d <getint+0x5d>
	else if (lflag)
  800465:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800469:	74 1a                	je     800485 <getint+0x45>
		return va_arg(*ap, long);
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	8d 50 04             	lea    0x4(%eax),%edx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	89 10                	mov    %edx,(%eax)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	83 e8 04             	sub    $0x4,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	99                   	cltd   
  800483:	eb 18                	jmp    80049d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	8d 50 04             	lea    0x4(%eax),%edx
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	89 10                	mov    %edx,(%eax)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	83 e8 04             	sub    $0x4,%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	99                   	cltd   
}
  80049d:	5d                   	pop    %ebp
  80049e:	c3                   	ret    

0080049f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	56                   	push   %esi
  8004a3:	53                   	push   %ebx
  8004a4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a7:	eb 17                	jmp    8004c0 <vprintfmt+0x21>
			if (ch == '\0')
  8004a9:	85 db                	test   %ebx,%ebx
  8004ab:	0f 84 af 03 00 00    	je     800860 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	53                   	push   %ebx
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	ff d0                	call   *%eax
  8004bd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c3:	8d 50 01             	lea    0x1(%eax),%edx
  8004c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c9:	8a 00                	mov    (%eax),%al
  8004cb:	0f b6 d8             	movzbl %al,%ebx
  8004ce:	83 fb 25             	cmp    $0x25,%ebx
  8004d1:	75 d6                	jne    8004a9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004d3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004d7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	8d 50 01             	lea    0x1(%eax),%edx
  8004f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004fc:	8a 00                	mov    (%eax),%al
  8004fe:	0f b6 d8             	movzbl %al,%ebx
  800501:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800504:	83 f8 55             	cmp    $0x55,%eax
  800507:	0f 87 2b 03 00 00    	ja     800838 <vprintfmt+0x399>
  80050d:	8b 04 85 58 1c 80 00 	mov    0x801c58(,%eax,4),%eax
  800514:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800516:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80051a:	eb d7                	jmp    8004f3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80051c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800520:	eb d1                	jmp    8004f3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800522:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800529:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052c:	89 d0                	mov    %edx,%eax
  80052e:	c1 e0 02             	shl    $0x2,%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d8                	add    %ebx,%eax
  800537:	83 e8 30             	sub    $0x30,%eax
  80053a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80053d:	8b 45 10             	mov    0x10(%ebp),%eax
  800540:	8a 00                	mov    (%eax),%al
  800542:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800545:	83 fb 2f             	cmp    $0x2f,%ebx
  800548:	7e 3e                	jle    800588 <vprintfmt+0xe9>
  80054a:	83 fb 39             	cmp    $0x39,%ebx
  80054d:	7f 39                	jg     800588 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800552:	eb d5                	jmp    800529 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 c0 04             	add    $0x4,%eax
  80055a:	89 45 14             	mov    %eax,0x14(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 e8 04             	sub    $0x4,%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800568:	eb 1f                	jmp    800589 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80056a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056e:	79 83                	jns    8004f3 <vprintfmt+0x54>
				width = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800577:	e9 77 ff ff ff       	jmp    8004f3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80057c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800583:	e9 6b ff ff ff       	jmp    8004f3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800588:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058d:	0f 89 60 ff ff ff    	jns    8004f3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800599:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005a0:	e9 4e ff ff ff       	jmp    8004f3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005a8:	e9 46 ff ff ff       	jmp    8004f3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	83 c0 04             	add    $0x4,%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	83 e8 04             	sub    $0x4,%eax
  8005bc:	8b 00                	mov    (%eax),%eax
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	ff 75 0c             	pushl  0xc(%ebp)
  8005c4:	50                   	push   %eax
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	ff d0                	call   *%eax
  8005ca:	83 c4 10             	add    $0x10,%esp
			break;
  8005cd:	e9 89 02 00 00       	jmp    80085b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 c0 04             	add    $0x4,%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 e8 04             	sub    $0x4,%eax
  8005e1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005e3:	85 db                	test   %ebx,%ebx
  8005e5:	79 02                	jns    8005e9 <vprintfmt+0x14a>
				err = -err;
  8005e7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e9:	83 fb 64             	cmp    $0x64,%ebx
  8005ec:	7f 0b                	jg     8005f9 <vprintfmt+0x15a>
  8005ee:	8b 34 9d a0 1a 80 00 	mov    0x801aa0(,%ebx,4),%esi
  8005f5:	85 f6                	test   %esi,%esi
  8005f7:	75 19                	jne    800612 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f9:	53                   	push   %ebx
  8005fa:	68 45 1c 80 00       	push   $0x801c45
  8005ff:	ff 75 0c             	pushl  0xc(%ebp)
  800602:	ff 75 08             	pushl  0x8(%ebp)
  800605:	e8 5e 02 00 00       	call   800868 <printfmt>
  80060a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80060d:	e9 49 02 00 00       	jmp    80085b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800612:	56                   	push   %esi
  800613:	68 4e 1c 80 00       	push   $0x801c4e
  800618:	ff 75 0c             	pushl  0xc(%ebp)
  80061b:	ff 75 08             	pushl  0x8(%ebp)
  80061e:	e8 45 02 00 00       	call   800868 <printfmt>
  800623:	83 c4 10             	add    $0x10,%esp
			break;
  800626:	e9 30 02 00 00       	jmp    80085b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 c0 04             	add    $0x4,%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	83 e8 04             	sub    $0x4,%eax
  80063a:	8b 30                	mov    (%eax),%esi
  80063c:	85 f6                	test   %esi,%esi
  80063e:	75 05                	jne    800645 <vprintfmt+0x1a6>
				p = "(null)";
  800640:	be 51 1c 80 00       	mov    $0x801c51,%esi
			if (width > 0 && padc != '-')
  800645:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800649:	7e 6d                	jle    8006b8 <vprintfmt+0x219>
  80064b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80064f:	74 67                	je     8006b8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	50                   	push   %eax
  800658:	56                   	push   %esi
  800659:	e8 0c 03 00 00       	call   80096a <strnlen>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800664:	eb 16                	jmp    80067c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800666:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	50                   	push   %eax
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	ff d0                	call   *%eax
  800676:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800679:	ff 4d e4             	decl   -0x1c(%ebp)
  80067c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800680:	7f e4                	jg     800666 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800682:	eb 34                	jmp    8006b8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800684:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800688:	74 1c                	je     8006a6 <vprintfmt+0x207>
  80068a:	83 fb 1f             	cmp    $0x1f,%ebx
  80068d:	7e 05                	jle    800694 <vprintfmt+0x1f5>
  80068f:	83 fb 7e             	cmp    $0x7e,%ebx
  800692:	7e 12                	jle    8006a6 <vprintfmt+0x207>
					putch('?', putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	6a 3f                	push   $0x3f
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	ff d0                	call   *%eax
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	eb 0f                	jmp    8006b5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ac:	53                   	push   %ebx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	ff d0                	call   *%eax
  8006b2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b8:	89 f0                	mov    %esi,%eax
  8006ba:	8d 70 01             	lea    0x1(%eax),%esi
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f be d8             	movsbl %al,%ebx
  8006c2:	85 db                	test   %ebx,%ebx
  8006c4:	74 24                	je     8006ea <vprintfmt+0x24b>
  8006c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ca:	78 b8                	js     800684 <vprintfmt+0x1e5>
  8006cc:	ff 4d e0             	decl   -0x20(%ebp)
  8006cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d3:	79 af                	jns    800684 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d5:	eb 13                	jmp    8006ea <vprintfmt+0x24b>
				putch(' ', putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	6a 20                	push   $0x20
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	ff d0                	call   *%eax
  8006e4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ee:	7f e7                	jg     8006d7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006f0:	e9 66 01 00 00       	jmp    80085b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	e8 3c fd ff ff       	call   800440 <getint>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80070d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800713:	85 d2                	test   %edx,%edx
  800715:	79 23                	jns    80073a <vprintfmt+0x29b>
				putch('-', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 2d                	push   $0x2d
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	f7 d8                	neg    %eax
  80072f:	83 d2 00             	adc    $0x0,%edx
  800732:	f7 da                	neg    %edx
  800734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800737:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80073a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800741:	e9 bc 00 00 00       	jmp    800802 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 e8             	pushl  -0x18(%ebp)
  80074c:	8d 45 14             	lea    0x14(%ebp),%eax
  80074f:	50                   	push   %eax
  800750:	e8 84 fc ff ff       	call   8003d9 <getuint>
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80075e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800765:	e9 98 00 00 00       	jmp    800802 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	6a 58                	push   $0x58
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	6a 58                	push   $0x58
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	ff d0                	call   *%eax
  800787:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 0c             	pushl  0xc(%ebp)
  800790:	6a 58                	push   $0x58
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	ff d0                	call   *%eax
  800797:	83 c4 10             	add    $0x10,%esp
			break;
  80079a:	e9 bc 00 00 00       	jmp    80085b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	6a 30                	push   $0x30
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	6a 78                	push   $0x78
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	ff d0                	call   *%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	83 c0 04             	add    $0x4,%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	83 e8 04             	sub    $0x4,%eax
  8007ce:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007da:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007e1:	eb 1f                	jmp    800802 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ec:	50                   	push   %eax
  8007ed:	e8 e7 fb ff ff       	call   8003d9 <getuint>
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800802:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800809:	83 ec 04             	sub    $0x4,%esp
  80080c:	52                   	push   %edx
  80080d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800810:	50                   	push   %eax
  800811:	ff 75 f4             	pushl  -0xc(%ebp)
  800814:	ff 75 f0             	pushl  -0x10(%ebp)
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	ff 75 08             	pushl  0x8(%ebp)
  80081d:	e8 00 fb ff ff       	call   800322 <printnum>
  800822:	83 c4 20             	add    $0x20,%esp
			break;
  800825:	eb 34                	jmp    80085b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	53                   	push   %ebx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	ff d0                	call   *%eax
  800833:	83 c4 10             	add    $0x10,%esp
			break;
  800836:	eb 23                	jmp    80085b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	6a 25                	push   $0x25
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	ff d0                	call   *%eax
  800845:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800848:	ff 4d 10             	decl   0x10(%ebp)
  80084b:	eb 03                	jmp    800850 <vprintfmt+0x3b1>
  80084d:	ff 4d 10             	decl   0x10(%ebp)
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	48                   	dec    %eax
  800854:	8a 00                	mov    (%eax),%al
  800856:	3c 25                	cmp    $0x25,%al
  800858:	75 f3                	jne    80084d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80085a:	90                   	nop
		}
	}
  80085b:	e9 47 fc ff ff       	jmp    8004a7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800860:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800864:	5b                   	pop    %ebx
  800865:	5e                   	pop    %esi
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80086e:	8d 45 10             	lea    0x10(%ebp),%eax
  800871:	83 c0 04             	add    $0x4,%eax
  800874:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	ff 75 f4             	pushl  -0xc(%ebp)
  80087d:	50                   	push   %eax
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 16 fc ff ff       	call   80049f <vprintfmt>
  800889:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800892:	8b 45 0c             	mov    0xc(%ebp),%eax
  800895:	8b 40 08             	mov    0x8(%eax),%eax
  800898:	8d 50 01             	lea    0x1(%eax),%edx
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a4:	8b 10                	mov    (%eax),%edx
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	8b 40 04             	mov    0x4(%eax),%eax
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	73 12                	jae    8008c2 <sprintputch+0x33>
		*b->buf++ = ch;
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bb:	89 0a                	mov    %ecx,(%edx)
  8008bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c0:	88 10                	mov    %dl,(%eax)
}
  8008c2:	90                   	nop
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	01 d0                	add    %edx,%eax
  8008dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ea:	74 06                	je     8008f2 <vsnprintf+0x2d>
  8008ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f0:	7f 07                	jg     8008f9 <vsnprintf+0x34>
		return -E_INVAL;
  8008f2:	b8 03 00 00 00       	mov    $0x3,%eax
  8008f7:	eb 20                	jmp    800919 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f9:	ff 75 14             	pushl  0x14(%ebp)
  8008fc:	ff 75 10             	pushl  0x10(%ebp)
  8008ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800902:	50                   	push   %eax
  800903:	68 8f 08 80 00       	push   $0x80088f
  800908:	e8 92 fb ff ff       	call   80049f <vprintfmt>
  80090d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800913:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800916:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800921:	8d 45 10             	lea    0x10(%ebp),%eax
  800924:	83 c0 04             	add    $0x4,%eax
  800927:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80092a:	8b 45 10             	mov    0x10(%ebp),%eax
  80092d:	ff 75 f4             	pushl  -0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	ff 75 08             	pushl  0x8(%ebp)
  800937:	e8 89 ff ff ff       	call   8008c5 <vsnprintf>
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800942:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80094d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800954:	eb 06                	jmp    80095c <strlen+0x15>
		n++;
  800956:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	ff 45 08             	incl   0x8(%ebp)
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8a 00                	mov    (%eax),%al
  800961:	84 c0                	test   %al,%al
  800963:	75 f1                	jne    800956 <strlen+0xf>
		n++;
	return n;
  800965:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800977:	eb 09                	jmp    800982 <strnlen+0x18>
		n++;
  800979:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	ff 45 08             	incl   0x8(%ebp)
  80097f:	ff 4d 0c             	decl   0xc(%ebp)
  800982:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800986:	74 09                	je     800991 <strnlen+0x27>
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8a 00                	mov    (%eax),%al
  80098d:	84 c0                	test   %al,%al
  80098f:	75 e8                	jne    800979 <strnlen+0xf>
		n++;
	return n;
  800991:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    

00800996 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009a2:	90                   	nop
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009b5:	8a 12                	mov    (%edx),%dl
  8009b7:	88 10                	mov    %dl,(%eax)
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	84 c0                	test   %al,%al
  8009bd:	75 e4                	jne    8009a3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 1f                	jmp    8009f8 <strncpy+0x34>
		*dst++ = *src;
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8d 50 01             	lea    0x1(%eax),%edx
  8009df:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	8a 12                	mov    (%edx),%dl
  8009e7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	8a 00                	mov    (%eax),%al
  8009ee:	84 c0                	test   %al,%al
  8009f0:	74 03                	je     8009f5 <strncpy+0x31>
			src++;
  8009f2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f5:	ff 45 fc             	incl   -0x4(%ebp)
  8009f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009fe:	72 d9                	jb     8009d9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a15:	74 30                	je     800a47 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a17:	eb 16                	jmp    800a2f <strlcpy+0x2a>
			*dst++ = *src++;
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8d 50 01             	lea    0x1(%eax),%edx
  800a1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2b:	8a 12                	mov    (%edx),%dl
  800a2d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a2f:	ff 4d 10             	decl   0x10(%ebp)
  800a32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a36:	74 09                	je     800a41 <strlcpy+0x3c>
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8a 00                	mov    (%eax),%al
  800a3d:	84 c0                	test   %al,%al
  800a3f:	75 d8                	jne    800a19 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a47:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a4d:	29 c2                	sub    %eax,%edx
  800a4f:	89 d0                	mov    %edx,%eax
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a56:	eb 06                	jmp    800a5e <strcmp+0xb>
		p++, q++;
  800a58:	ff 45 08             	incl   0x8(%ebp)
  800a5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	84 c0                	test   %al,%al
  800a65:	74 0e                	je     800a75 <strcmp+0x22>
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8a 10                	mov    (%eax),%dl
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	38 c2                	cmp    %al,%dl
  800a73:	74 e3                	je     800a58 <strcmp+0x5>
		p++, q++;
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

00800a8b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a8e:	eb 09                	jmp    800a99 <strncmp+0xe>
		n--, p++, q++;
  800a90:	ff 4d 10             	decl   0x10(%ebp)
  800a93:	ff 45 08             	incl   0x8(%ebp)
  800a96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9d:	74 17                	je     800ab6 <strncmp+0x2b>
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 0e                	je     800ab6 <strncmp+0x2b>
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8a 10                	mov    (%eax),%dl
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	38 c2                	cmp    %al,%dl
  800ab4:	74 da                	je     800a90 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ab6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aba:	75 07                	jne    800ac3 <strncmp+0x38>
		return 0;
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac1:	eb 14                	jmp    800ad7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	0f b6 d0             	movzbl %al,%edx
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	0f b6 c0             	movzbl %al,%eax
  800ad3:	29 c2                	sub    %eax,%edx
  800ad5:	89 d0                	mov    %edx,%eax
}
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae5:	eb 12                	jmp    800af9 <strchr+0x20>
		if (*s == c)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aef:	75 05                	jne    800af6 <strchr+0x1d>
			return (char *) s;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	eb 11                	jmp    800b07 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af6:	ff 45 08             	incl   0x8(%ebp)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	84 c0                	test   %al,%al
  800b00:	75 e5                	jne    800ae7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 04             	sub    $0x4,%esp
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b15:	eb 0d                	jmp    800b24 <strfind+0x1b>
		if (*s == c)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b1f:	74 0e                	je     800b2f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b21:	ff 45 08             	incl   0x8(%ebp)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8a 00                	mov    (%eax),%al
  800b29:	84 c0                	test   %al,%al
  800b2b:	75 ea                	jne    800b17 <strfind+0xe>
  800b2d:	eb 01                	jmp    800b30 <strfind+0x27>
		if (*s == c)
			break;
  800b2f:	90                   	nop
	return (char *) s;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b33:	c9                   	leave  
  800b34:	c3                   	ret    

00800b35 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b41:	8b 45 10             	mov    0x10(%ebp),%eax
  800b44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b47:	eb 0e                	jmp    800b57 <memset+0x22>
		*p++ = c;
  800b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b4c:	8d 50 01             	lea    0x1(%eax),%edx
  800b4f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b55:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b57:	ff 4d f8             	decl   -0x8(%ebp)
  800b5a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b5e:	79 e9                	jns    800b49 <memset+0x14>
		*p++ = c;

	return v;
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b77:	eb 16                	jmp    800b8f <memcpy+0x2a>
		*d++ = *s++;
  800b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b7c:	8d 50 01             	lea    0x1(%eax),%edx
  800b7f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b88:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b8b:	8a 12                	mov    (%edx),%dl
  800b8d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b95:	89 55 10             	mov    %edx,0x10(%ebp)
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	75 dd                	jne    800b79 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb9:	73 50                	jae    800c0b <memmove+0x6a>
  800bbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	01 d0                	add    %edx,%eax
  800bc3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc6:	76 43                	jbe    800c0b <memmove+0x6a>
		s += n;
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bd4:	eb 10                	jmp    800be6 <memmove+0x45>
			*--d = *--s;
  800bd6:	ff 4d f8             	decl   -0x8(%ebp)
  800bd9:	ff 4d fc             	decl   -0x4(%ebp)
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdf:	8a 10                	mov    (%eax),%dl
  800be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800be6:	8b 45 10             	mov    0x10(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	89 55 10             	mov    %edx,0x10(%ebp)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	75 e3                	jne    800bd6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf3:	eb 23                	jmp    800c18 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf8:	8d 50 01             	lea    0x1(%eax),%edx
  800bfb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c01:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c04:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c07:	8a 12                	mov    (%edx),%dl
  800c09:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c11:	89 55 10             	mov    %edx,0x10(%ebp)
  800c14:	85 c0                	test   %eax,%eax
  800c16:	75 dd                	jne    800bf5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c2f:	eb 2a                	jmp    800c5b <memcmp+0x3e>
		if (*s1 != *s2)
  800c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c34:	8a 10                	mov    (%eax),%dl
  800c36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	38 c2                	cmp    %al,%dl
  800c3d:	74 16                	je     800c55 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	0f b6 d0             	movzbl %al,%edx
  800c47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	0f b6 c0             	movzbl %al,%eax
  800c4f:	29 c2                	sub    %eax,%edx
  800c51:	89 d0                	mov    %edx,%eax
  800c53:	eb 18                	jmp    800c6d <memcmp+0x50>
		s1++, s2++;
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c61:	89 55 10             	mov    %edx,0x10(%ebp)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	75 c9                	jne    800c31 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c75:	8b 55 08             	mov    0x8(%ebp),%edx
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c80:	eb 15                	jmp    800c97 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f b6 d0             	movzbl %al,%edx
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	0f b6 c0             	movzbl %al,%eax
  800c90:	39 c2                	cmp    %eax,%edx
  800c92:	74 0d                	je     800ca1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c94:	ff 45 08             	incl   0x8(%ebp)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c9d:	72 e3                	jb     800c82 <memfind+0x13>
  800c9f:	eb 01                	jmp    800ca2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ca1:	90                   	nop
	return (void *) s;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cb4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbb:	eb 03                	jmp    800cc0 <strtol+0x19>
		s++;
  800cbd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	3c 20                	cmp    $0x20,%al
  800cc7:	74 f4                	je     800cbd <strtol+0x16>
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 09                	cmp    $0x9,%al
  800cd0:	74 eb                	je     800cbd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 2b                	cmp    $0x2b,%al
  800cd9:	75 05                	jne    800ce0 <strtol+0x39>
		s++;
  800cdb:	ff 45 08             	incl   0x8(%ebp)
  800cde:	eb 13                	jmp    800cf3 <strtol+0x4c>
	else if (*s == '-')
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	3c 2d                	cmp    $0x2d,%al
  800ce7:	75 0a                	jne    800cf3 <strtol+0x4c>
		s++, neg = 1;
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf7:	74 06                	je     800cff <strtol+0x58>
  800cf9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cfd:	75 20                	jne    800d1f <strtol+0x78>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	3c 30                	cmp    $0x30,%al
  800d06:	75 17                	jne    800d1f <strtol+0x78>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	40                   	inc    %eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 78                	cmp    $0x78,%al
  800d10:	75 0d                	jne    800d1f <strtol+0x78>
		s += 2, base = 16;
  800d12:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d16:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d1d:	eb 28                	jmp    800d47 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	75 15                	jne    800d3a <strtol+0x93>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 30                	cmp    $0x30,%al
  800d2c:	75 0c                	jne    800d3a <strtol+0x93>
		s++, base = 8;
  800d2e:	ff 45 08             	incl   0x8(%ebp)
  800d31:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d38:	eb 0d                	jmp    800d47 <strtol+0xa0>
	else if (base == 0)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	75 07                	jne    800d47 <strtol+0xa0>
		base = 10;
  800d40:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 2f                	cmp    $0x2f,%al
  800d4e:	7e 19                	jle    800d69 <strtol+0xc2>
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 39                	cmp    $0x39,%al
  800d57:	7f 10                	jg     800d69 <strtol+0xc2>
			dig = *s - '0';
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	0f be c0             	movsbl %al,%eax
  800d61:	83 e8 30             	sub    $0x30,%eax
  800d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d67:	eb 42                	jmp    800dab <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 60                	cmp    $0x60,%al
  800d70:	7e 19                	jle    800d8b <strtol+0xe4>
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3c 7a                	cmp    $0x7a,%al
  800d79:	7f 10                	jg     800d8b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	0f be c0             	movsbl %al,%eax
  800d83:	83 e8 57             	sub    $0x57,%eax
  800d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d89:	eb 20                	jmp    800dab <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	3c 40                	cmp    $0x40,%al
  800d92:	7e 39                	jle    800dcd <strtol+0x126>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	3c 5a                	cmp    $0x5a,%al
  800d9b:	7f 30                	jg     800dcd <strtol+0x126>
			dig = *s - 'A' + 10;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	0f be c0             	movsbl %al,%eax
  800da5:	83 e8 37             	sub    $0x37,%eax
  800da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dae:	3b 45 10             	cmp    0x10(%ebp),%eax
  800db1:	7d 19                	jge    800dcc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dbd:	89 c2                	mov    %eax,%edx
  800dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc2:	01 d0                	add    %edx,%eax
  800dc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dc7:	e9 7b ff ff ff       	jmp    800d47 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dcc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	74 08                	je     800ddb <strtol+0x134>
		*endptr = (char *) s;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ddb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ddf:	74 07                	je     800de8 <strtol+0x141>
  800de1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de4:	f7 d8                	neg    %eax
  800de6:	eb 03                	jmp    800deb <strtol+0x144>
  800de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800deb:	c9                   	leave  
  800dec:	c3                   	ret    

00800ded <ltostr>:

void
ltostr(long value, char *str)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800df3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dfa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e05:	79 13                	jns    800e1a <ltostr+0x2d>
	{
		neg = 1;
  800e07:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e14:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e17:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e22:	99                   	cltd   
  800e23:	f7 f9                	idiv   %ecx
  800e25:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e31:	89 c2                	mov    %eax,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e3b:	83 c2 30             	add    $0x30,%edx
  800e3e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e43:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e48:	f7 e9                	imul   %ecx
  800e4a:	c1 fa 02             	sar    $0x2,%edx
  800e4d:	89 c8                	mov    %ecx,%eax
  800e4f:	c1 f8 1f             	sar    $0x1f,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
  800e56:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e61:	f7 e9                	imul   %ecx
  800e63:	c1 fa 02             	sar    $0x2,%edx
  800e66:	89 c8                	mov    %ecx,%eax
  800e68:	c1 f8 1f             	sar    $0x1f,%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	c1 e0 02             	shl    $0x2,%eax
  800e72:	01 d0                	add    %edx,%eax
  800e74:	01 c0                	add    %eax,%eax
  800e76:	29 c1                	sub    %eax,%ecx
  800e78:	89 ca                	mov    %ecx,%edx
  800e7a:	85 d2                	test   %edx,%edx
  800e7c:	75 9c                	jne    800e1a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	48                   	dec    %eax
  800e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e90:	74 3d                	je     800ecf <ltostr+0xe2>
		start = 1 ;
  800e92:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e99:	eb 34                	jmp    800ecf <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	01 d0                	add    %edx,%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	01 c2                	add    %eax,%edx
  800eb0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	01 c8                	add    %ecx,%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ebc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	01 c2                	add    %eax,%edx
  800ec4:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec7:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ecc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed5:	7c c4                	jl     800e9b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	01 d0                	add    %edx,%eax
  800edf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ee2:	90                   	nop
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800eeb:	ff 75 08             	pushl  0x8(%ebp)
  800eee:	e8 54 fa ff ff       	call   800947 <strlen>
  800ef3:	83 c4 04             	add    $0x4,%esp
  800ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	e8 46 fa ff ff       	call   800947 <strlen>
  800f01:	83 c4 04             	add    $0x4,%esp
  800f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 17                	jmp    800f2e <strcconcat+0x49>
		final[s] = str1[s] ;
  800f17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	01 c2                	add    %eax,%edx
  800f1f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	01 c8                	add    %ecx,%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f2b:	ff 45 fc             	incl   -0x4(%ebp)
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f34:	7c e1                	jl     800f17 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f44:	eb 1f                	jmp    800f65 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	8b 45 10             	mov    0x10(%ebp),%eax
  800f54:	01 c2                	add    %eax,%edx
  800f56:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	01 c8                	add    %ecx,%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f62:	ff 45 f8             	incl   -0x8(%ebp)
  800f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6b:	7c d9                	jl     800f46 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	01 d0                	add    %edx,%eax
  800f75:	c6 00 00             	movb   $0x0,(%eax)
}
  800f78:	90                   	nop
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8b 00                	mov    (%eax),%eax
  800f8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 d0                	add    %edx,%eax
  800f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9e:	eb 0c                	jmp    800fac <strsplit+0x31>
			*string++ = 0;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8d 50 01             	lea    0x1(%eax),%edx
  800fa6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 18                	je     800fcd <strsplit+0x52>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be c0             	movsbl %al,%eax
  800fbd:	50                   	push   %eax
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	e8 13 fb ff ff       	call   800ad9 <strchr>
  800fc6:	83 c4 08             	add    $0x8,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 d3                	jne    800fa0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	84 c0                	test   %al,%al
  800fd4:	74 5a                	je     801030 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd9:	8b 00                	mov    (%eax),%eax
  800fdb:	83 f8 0f             	cmp    $0xf,%eax
  800fde:	75 07                	jne    800fe7 <strsplit+0x6c>
		{
			return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb 66                	jmp    80104d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	8b 00                	mov    (%eax),%eax
  800fec:	8d 48 01             	lea    0x1(%eax),%ecx
  800fef:	8b 55 14             	mov    0x14(%ebp),%edx
  800ff2:	89 0a                	mov    %ecx,(%edx)
  800ff4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	01 c2                	add    %eax,%edx
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801005:	eb 03                	jmp    80100a <strsplit+0x8f>
			string++;
  801007:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	84 c0                	test   %al,%al
  801011:	74 8b                	je     800f9e <strsplit+0x23>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f be c0             	movsbl %al,%eax
  80101b:	50                   	push   %eax
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	e8 b5 fa ff ff       	call   800ad9 <strchr>
  801024:	83 c4 08             	add    $0x8,%esp
  801027:	85 c0                	test   %eax,%eax
  801029:	74 dc                	je     801007 <strsplit+0x8c>
			string++;
	}
  80102b:	e9 6e ff ff ff       	jmp    800f9e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801030:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801031:	8b 45 14             	mov    0x14(%ebp),%eax
  801034:	8b 00                	mov    (%eax),%eax
  801036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801048:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
  801055:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801061:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801064:	8b 7d 18             	mov    0x18(%ebp),%edi
  801067:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80106a:	cd 30                	int    $0x30
  80106c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80106f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801072:	83 c4 10             	add    $0x10,%esp
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801086:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	6a 00                	push   $0x0
  80108f:	6a 00                	push   $0x0
  801091:	52                   	push   %edx
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	50                   	push   %eax
  801096:	6a 00                	push   $0x0
  801098:	e8 b2 ff ff ff       	call   80104f <syscall>
  80109d:	83 c4 18             	add    $0x18,%esp
}
  8010a0:	90                   	nop
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010a6:	6a 00                	push   $0x0
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	6a 00                	push   $0x0
  8010ae:	6a 00                	push   $0x0
  8010b0:	6a 01                	push   $0x1
  8010b2:	e8 98 ff ff ff       	call   80104f <syscall>
  8010b7:	83 c4 18             	add    $0x18,%esp
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	6a 00                	push   $0x0
  8010c7:	6a 00                	push   $0x0
  8010c9:	6a 00                	push   $0x0
  8010cb:	52                   	push   %edx
  8010cc:	50                   	push   %eax
  8010cd:	6a 05                	push   $0x5
  8010cf:	e8 7b ff ff ff       	call   80104f <syscall>
  8010d4:	83 c4 18             	add    $0x18,%esp
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	56                   	push   %esi
  8010dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010de:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	51                   	push   %ecx
  8010f0:	52                   	push   %edx
  8010f1:	50                   	push   %eax
  8010f2:	6a 06                	push   $0x6
  8010f4:	e8 56 ff ff ff       	call   80104f <syscall>
  8010f9:	83 c4 18             	add    $0x18,%esp
}
  8010fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801106:	8b 55 0c             	mov    0xc(%ebp),%edx
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	52                   	push   %edx
  801113:	50                   	push   %eax
  801114:	6a 07                	push   $0x7
  801116:	e8 34 ff ff ff       	call   80104f <syscall>
  80111b:	83 c4 18             	add    $0x18,%esp
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	ff 75 0c             	pushl  0xc(%ebp)
  80112c:	ff 75 08             	pushl  0x8(%ebp)
  80112f:	6a 08                	push   $0x8
  801131:	e8 19 ff ff ff       	call   80104f <syscall>
  801136:	83 c4 18             	add    $0x18,%esp
}
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	6a 09                	push   $0x9
  80114a:	e8 00 ff ff ff       	call   80104f <syscall>
  80114f:	83 c4 18             	add    $0x18,%esp
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 0a                	push   $0xa
  801163:	e8 e7 fe ff ff       	call   80104f <syscall>
  801168:	83 c4 18             	add    $0x18,%esp
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 0b                	push   $0xb
  80117c:	e8 ce fe ff ff       	call   80104f <syscall>
  801181:	83 c4 18             	add    $0x18,%esp
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	ff 75 0c             	pushl  0xc(%ebp)
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	6a 0f                	push   $0xf
  801197:	e8 b3 fe ff ff       	call   80104f <syscall>
  80119c:	83 c4 18             	add    $0x18,%esp
	return;
  80119f:	90                   	nop
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	ff 75 08             	pushl  0x8(%ebp)
  8011b1:	6a 10                	push   $0x10
  8011b3:	e8 97 fe ff ff       	call   80104f <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8011bb:	90                   	nop
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	ff 75 10             	pushl  0x10(%ebp)
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	ff 75 08             	pushl  0x8(%ebp)
  8011ce:	6a 11                	push   $0x11
  8011d0:	e8 7a fe ff ff       	call   80104f <syscall>
  8011d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8011d8:	90                   	nop
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 0c                	push   $0xc
  8011ea:	e8 60 fe ff ff       	call   80104f <syscall>
  8011ef:	83 c4 18             	add    $0x18,%esp
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	ff 75 08             	pushl  0x8(%ebp)
  801202:	6a 0d                	push   $0xd
  801204:	e8 46 fe ff ff       	call   80104f <syscall>
  801209:	83 c4 18             	add    $0x18,%esp
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 0e                	push   $0xe
  80121d:	e8 2d fe ff ff       	call   80104f <syscall>
  801222:	83 c4 18             	add    $0x18,%esp
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 13                	push   $0x13
  801237:	e8 13 fe ff ff       	call   80104f <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 14                	push   $0x14
  801251:	e8 f9 fd ff ff       	call   80104f <syscall>
  801256:	83 c4 18             	add    $0x18,%esp
}
  801259:	90                   	nop
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_cputc>:


void
sys_cputc(const char c)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 04             	sub    $0x4,%esp
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801268:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	50                   	push   %eax
  801275:	6a 15                	push   $0x15
  801277:	e8 d3 fd ff ff       	call   80104f <syscall>
  80127c:	83 c4 18             	add    $0x18,%esp
}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 16                	push   $0x16
  801291:	e8 b9 fd ff ff       	call   80104f <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	50                   	push   %eax
  8012ac:	6a 17                	push   $0x17
  8012ae:	e8 9c fd ff ff       	call   80104f <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	52                   	push   %edx
  8012c8:	50                   	push   %eax
  8012c9:	6a 1a                	push   $0x1a
  8012cb:	e8 7f fd ff ff       	call   80104f <syscall>
  8012d0:	83 c4 18             	add    $0x18,%esp
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	52                   	push   %edx
  8012e5:	50                   	push   %eax
  8012e6:	6a 18                	push   $0x18
  8012e8:	e8 62 fd ff ff       	call   80104f <syscall>
  8012ed:	83 c4 18             	add    $0x18,%esp
}
  8012f0:	90                   	nop
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	52                   	push   %edx
  801303:	50                   	push   %eax
  801304:	6a 19                	push   $0x19
  801306:	e8 44 fd ff ff       	call   80104f <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	90                   	nop
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	8b 45 10             	mov    0x10(%ebp),%eax
  80131a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80131d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801320:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	6a 00                	push   $0x0
  801329:	51                   	push   %ecx
  80132a:	52                   	push   %edx
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	50                   	push   %eax
  80132f:	6a 1b                	push   $0x1b
  801331:	e8 19 fd ff ff       	call   80104f <syscall>
  801336:	83 c4 18             	add    $0x18,%esp
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80133e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	52                   	push   %edx
  80134b:	50                   	push   %eax
  80134c:	6a 1c                	push   $0x1c
  80134e:	e8 fc fc ff ff       	call   80104f <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80135b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	51                   	push   %ecx
  801369:	52                   	push   %edx
  80136a:	50                   	push   %eax
  80136b:	6a 1d                	push   $0x1d
  80136d:	e8 dd fc ff ff       	call   80104f <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80137a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	52                   	push   %edx
  801387:	50                   	push   %eax
  801388:	6a 1e                	push   $0x1e
  80138a:	e8 c0 fc ff ff       	call   80104f <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 1f                	push   $0x1f
  8013a3:	e8 a7 fc ff ff       	call   80104f <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	6a 00                	push   $0x0
  8013b5:	ff 75 14             	pushl  0x14(%ebp)
  8013b8:	ff 75 10             	pushl  0x10(%ebp)
  8013bb:	ff 75 0c             	pushl  0xc(%ebp)
  8013be:	50                   	push   %eax
  8013bf:	6a 20                	push   $0x20
  8013c1:	e8 89 fc ff ff       	call   80104f <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	50                   	push   %eax
  8013da:	6a 21                	push   $0x21
  8013dc:	e8 6e fc ff ff       	call   80104f <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	90                   	nop
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	50                   	push   %eax
  8013f6:	6a 22                	push   $0x22
  8013f8:	e8 52 fc ff ff       	call   80104f <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 02                	push   $0x2
  801411:	e8 39 fc ff ff       	call   80104f <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 03                	push   $0x3
  80142a:	e8 20 fc ff ff       	call   80104f <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 04                	push   $0x4
  801443:	e8 07 fc ff ff       	call   80104f <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_exit_env>:


void sys_exit_env(void)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 23                	push   $0x23
  80145c:	e8 ee fb ff ff       	call   80104f <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80146d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801470:	8d 50 04             	lea    0x4(%eax),%edx
  801473:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	52                   	push   %edx
  80147d:	50                   	push   %eax
  80147e:	6a 24                	push   $0x24
  801480:	e8 ca fb ff ff       	call   80104f <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
	return result;
  801488:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801491:	89 01                	mov    %eax,(%ecx)
  801493:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	c9                   	leave  
  80149a:	c2 04 00             	ret    $0x4

0080149d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	ff 75 10             	pushl  0x10(%ebp)
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	6a 12                	push   $0x12
  8014af:	e8 9b fb ff ff       	call   80104f <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b7:	90                   	nop
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_rcr2>:
uint32 sys_rcr2()
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 25                	push   $0x25
  8014c9:	e8 81 fb ff ff       	call   80104f <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014df:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	50                   	push   %eax
  8014ec:	6a 26                	push   $0x26
  8014ee:	e8 5c fb ff ff       	call   80104f <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f6:	90                   	nop
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <rsttst>:
void rsttst()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 28                	push   $0x28
  801508:	e8 42 fb ff ff       	call   80104f <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
	return ;
  801510:	90                   	nop
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80151f:	8b 55 18             	mov    0x18(%ebp),%edx
  801522:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801526:	52                   	push   %edx
  801527:	50                   	push   %eax
  801528:	ff 75 10             	pushl  0x10(%ebp)
  80152b:	ff 75 0c             	pushl  0xc(%ebp)
  80152e:	ff 75 08             	pushl  0x8(%ebp)
  801531:	6a 27                	push   $0x27
  801533:	e8 17 fb ff ff       	call   80104f <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
	return ;
  80153b:	90                   	nop
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <chktst>:
void chktst(uint32 n)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	6a 29                	push   $0x29
  80154e:	e8 fc fa ff ff       	call   80104f <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
	return ;
  801556:	90                   	nop
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <inctst>:

void inctst()
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 2a                	push   $0x2a
  801568:	e8 e2 fa ff ff       	call   80104f <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
	return ;
  801570:	90                   	nop
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <gettst>:
uint32 gettst()
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 2b                	push   $0x2b
  801582:	e8 c8 fa ff ff       	call   80104f <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 2c                	push   $0x2c
  80159e:	e8 ac fa ff ff       	call   80104f <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
  8015a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015a9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015ad:	75 07                	jne    8015b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015af:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b4:	eb 05                	jmp    8015bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 2c                	push   $0x2c
  8015cf:	e8 7b fa ff ff       	call   80104f <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
  8015d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015da:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015de:	75 07                	jne    8015e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e5:	eb 05                	jmp    8015ec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 2c                	push   $0x2c
  801600:	e8 4a fa ff ff       	call   80104f <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
  801608:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80160b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80160f:	75 07                	jne    801618 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801611:	b8 01 00 00 00       	mov    $0x1,%eax
  801616:	eb 05                	jmp    80161d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 2c                	push   $0x2c
  801631:	e8 19 fa ff ff       	call   80104f <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
  801639:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80163c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801640:	75 07                	jne    801649 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801642:	b8 01 00 00 00       	mov    $0x1,%eax
  801647:	eb 05                	jmp    80164e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	6a 2d                	push   $0x2d
  801660:	e8 ea f9 ff ff       	call   80104f <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
	return ;
  801668:	90                   	nop
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80166f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801672:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801675:	8b 55 0c             	mov    0xc(%ebp),%edx
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	6a 00                	push   $0x0
  80167d:	53                   	push   %ebx
  80167e:	51                   	push   %ecx
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 2e                	push   $0x2e
  801683:	e8 c7 f9 ff ff       	call   80104f <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801693:	8b 55 0c             	mov    0xc(%ebp),%edx
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	52                   	push   %edx
  8016a0:	50                   	push   %eax
  8016a1:	6a 2f                	push   $0x2f
  8016a3:	e8 a7 f9 ff ff       	call   80104f <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    
  8016ad:	66 90                	xchg   %ax,%ax
  8016af:	90                   	nop

008016b0 <__udivdi3>:
  8016b0:	55                   	push   %ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 1c             	sub    $0x1c,%esp
  8016b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016c7:	89 ca                	mov    %ecx,%edx
  8016c9:	89 f8                	mov    %edi,%eax
  8016cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8016cf:	85 f6                	test   %esi,%esi
  8016d1:	75 2d                	jne    801700 <__udivdi3+0x50>
  8016d3:	39 cf                	cmp    %ecx,%edi
  8016d5:	77 65                	ja     80173c <__udivdi3+0x8c>
  8016d7:	89 fd                	mov    %edi,%ebp
  8016d9:	85 ff                	test   %edi,%edi
  8016db:	75 0b                	jne    8016e8 <__udivdi3+0x38>
  8016dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e2:	31 d2                	xor    %edx,%edx
  8016e4:	f7 f7                	div    %edi
  8016e6:	89 c5                	mov    %eax,%ebp
  8016e8:	31 d2                	xor    %edx,%edx
  8016ea:	89 c8                	mov    %ecx,%eax
  8016ec:	f7 f5                	div    %ebp
  8016ee:	89 c1                	mov    %eax,%ecx
  8016f0:	89 d8                	mov    %ebx,%eax
  8016f2:	f7 f5                	div    %ebp
  8016f4:	89 cf                	mov    %ecx,%edi
  8016f6:	89 fa                	mov    %edi,%edx
  8016f8:	83 c4 1c             	add    $0x1c,%esp
  8016fb:	5b                   	pop    %ebx
  8016fc:	5e                   	pop    %esi
  8016fd:	5f                   	pop    %edi
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    
  801700:	39 ce                	cmp    %ecx,%esi
  801702:	77 28                	ja     80172c <__udivdi3+0x7c>
  801704:	0f bd fe             	bsr    %esi,%edi
  801707:	83 f7 1f             	xor    $0x1f,%edi
  80170a:	75 40                	jne    80174c <__udivdi3+0x9c>
  80170c:	39 ce                	cmp    %ecx,%esi
  80170e:	72 0a                	jb     80171a <__udivdi3+0x6a>
  801710:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801714:	0f 87 9e 00 00 00    	ja     8017b8 <__udivdi3+0x108>
  80171a:	b8 01 00 00 00       	mov    $0x1,%eax
  80171f:	89 fa                	mov    %edi,%edx
  801721:	83 c4 1c             	add    $0x1c,%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    
  801729:	8d 76 00             	lea    0x0(%esi),%esi
  80172c:	31 ff                	xor    %edi,%edi
  80172e:	31 c0                	xor    %eax,%eax
  801730:	89 fa                	mov    %edi,%edx
  801732:	83 c4 1c             	add    $0x1c,%esp
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5f                   	pop    %edi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    
  80173a:	66 90                	xchg   %ax,%ax
  80173c:	89 d8                	mov    %ebx,%eax
  80173e:	f7 f7                	div    %edi
  801740:	31 ff                	xor    %edi,%edi
  801742:	89 fa                	mov    %edi,%edx
  801744:	83 c4 1c             	add    $0x1c,%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5f                   	pop    %edi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
  80174c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801751:	89 eb                	mov    %ebp,%ebx
  801753:	29 fb                	sub    %edi,%ebx
  801755:	89 f9                	mov    %edi,%ecx
  801757:	d3 e6                	shl    %cl,%esi
  801759:	89 c5                	mov    %eax,%ebp
  80175b:	88 d9                	mov    %bl,%cl
  80175d:	d3 ed                	shr    %cl,%ebp
  80175f:	89 e9                	mov    %ebp,%ecx
  801761:	09 f1                	or     %esi,%ecx
  801763:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801767:	89 f9                	mov    %edi,%ecx
  801769:	d3 e0                	shl    %cl,%eax
  80176b:	89 c5                	mov    %eax,%ebp
  80176d:	89 d6                	mov    %edx,%esi
  80176f:	88 d9                	mov    %bl,%cl
  801771:	d3 ee                	shr    %cl,%esi
  801773:	89 f9                	mov    %edi,%ecx
  801775:	d3 e2                	shl    %cl,%edx
  801777:	8b 44 24 08          	mov    0x8(%esp),%eax
  80177b:	88 d9                	mov    %bl,%cl
  80177d:	d3 e8                	shr    %cl,%eax
  80177f:	09 c2                	or     %eax,%edx
  801781:	89 d0                	mov    %edx,%eax
  801783:	89 f2                	mov    %esi,%edx
  801785:	f7 74 24 0c          	divl   0xc(%esp)
  801789:	89 d6                	mov    %edx,%esi
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	f7 e5                	mul    %ebp
  80178f:	39 d6                	cmp    %edx,%esi
  801791:	72 19                	jb     8017ac <__udivdi3+0xfc>
  801793:	74 0b                	je     8017a0 <__udivdi3+0xf0>
  801795:	89 d8                	mov    %ebx,%eax
  801797:	31 ff                	xor    %edi,%edi
  801799:	e9 58 ff ff ff       	jmp    8016f6 <__udivdi3+0x46>
  80179e:	66 90                	xchg   %ax,%ax
  8017a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017a4:	89 f9                	mov    %edi,%ecx
  8017a6:	d3 e2                	shl    %cl,%edx
  8017a8:	39 c2                	cmp    %eax,%edx
  8017aa:	73 e9                	jae    801795 <__udivdi3+0xe5>
  8017ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017af:	31 ff                	xor    %edi,%edi
  8017b1:	e9 40 ff ff ff       	jmp    8016f6 <__udivdi3+0x46>
  8017b6:	66 90                	xchg   %ax,%ax
  8017b8:	31 c0                	xor    %eax,%eax
  8017ba:	e9 37 ff ff ff       	jmp    8016f6 <__udivdi3+0x46>
  8017bf:	90                   	nop

008017c0 <__umoddi3>:
  8017c0:	55                   	push   %ebp
  8017c1:	57                   	push   %edi
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 1c             	sub    $0x1c,%esp
  8017c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8017cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8017cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8017d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017df:	89 f3                	mov    %esi,%ebx
  8017e1:	89 fa                	mov    %edi,%edx
  8017e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017e7:	89 34 24             	mov    %esi,(%esp)
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	75 1a                	jne    801808 <__umoddi3+0x48>
  8017ee:	39 f7                	cmp    %esi,%edi
  8017f0:	0f 86 a2 00 00 00    	jbe    801898 <__umoddi3+0xd8>
  8017f6:	89 c8                	mov    %ecx,%eax
  8017f8:	89 f2                	mov    %esi,%edx
  8017fa:	f7 f7                	div    %edi
  8017fc:	89 d0                	mov    %edx,%eax
  8017fe:	31 d2                	xor    %edx,%edx
  801800:	83 c4 1c             	add    $0x1c,%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5f                   	pop    %edi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    
  801808:	39 f0                	cmp    %esi,%eax
  80180a:	0f 87 ac 00 00 00    	ja     8018bc <__umoddi3+0xfc>
  801810:	0f bd e8             	bsr    %eax,%ebp
  801813:	83 f5 1f             	xor    $0x1f,%ebp
  801816:	0f 84 ac 00 00 00    	je     8018c8 <__umoddi3+0x108>
  80181c:	bf 20 00 00 00       	mov    $0x20,%edi
  801821:	29 ef                	sub    %ebp,%edi
  801823:	89 fe                	mov    %edi,%esi
  801825:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801829:	89 e9                	mov    %ebp,%ecx
  80182b:	d3 e0                	shl    %cl,%eax
  80182d:	89 d7                	mov    %edx,%edi
  80182f:	89 f1                	mov    %esi,%ecx
  801831:	d3 ef                	shr    %cl,%edi
  801833:	09 c7                	or     %eax,%edi
  801835:	89 e9                	mov    %ebp,%ecx
  801837:	d3 e2                	shl    %cl,%edx
  801839:	89 14 24             	mov    %edx,(%esp)
  80183c:	89 d8                	mov    %ebx,%eax
  80183e:	d3 e0                	shl    %cl,%eax
  801840:	89 c2                	mov    %eax,%edx
  801842:	8b 44 24 08          	mov    0x8(%esp),%eax
  801846:	d3 e0                	shl    %cl,%eax
  801848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801850:	89 f1                	mov    %esi,%ecx
  801852:	d3 e8                	shr    %cl,%eax
  801854:	09 d0                	or     %edx,%eax
  801856:	d3 eb                	shr    %cl,%ebx
  801858:	89 da                	mov    %ebx,%edx
  80185a:	f7 f7                	div    %edi
  80185c:	89 d3                	mov    %edx,%ebx
  80185e:	f7 24 24             	mull   (%esp)
  801861:	89 c6                	mov    %eax,%esi
  801863:	89 d1                	mov    %edx,%ecx
  801865:	39 d3                	cmp    %edx,%ebx
  801867:	0f 82 87 00 00 00    	jb     8018f4 <__umoddi3+0x134>
  80186d:	0f 84 91 00 00 00    	je     801904 <__umoddi3+0x144>
  801873:	8b 54 24 04          	mov    0x4(%esp),%edx
  801877:	29 f2                	sub    %esi,%edx
  801879:	19 cb                	sbb    %ecx,%ebx
  80187b:	89 d8                	mov    %ebx,%eax
  80187d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801881:	d3 e0                	shl    %cl,%eax
  801883:	89 e9                	mov    %ebp,%ecx
  801885:	d3 ea                	shr    %cl,%edx
  801887:	09 d0                	or     %edx,%eax
  801889:	89 e9                	mov    %ebp,%ecx
  80188b:	d3 eb                	shr    %cl,%ebx
  80188d:	89 da                	mov    %ebx,%edx
  80188f:	83 c4 1c             	add    $0x1c,%esp
  801892:	5b                   	pop    %ebx
  801893:	5e                   	pop    %esi
  801894:	5f                   	pop    %edi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    
  801897:	90                   	nop
  801898:	89 fd                	mov    %edi,%ebp
  80189a:	85 ff                	test   %edi,%edi
  80189c:	75 0b                	jne    8018a9 <__umoddi3+0xe9>
  80189e:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a3:	31 d2                	xor    %edx,%edx
  8018a5:	f7 f7                	div    %edi
  8018a7:	89 c5                	mov    %eax,%ebp
  8018a9:	89 f0                	mov    %esi,%eax
  8018ab:	31 d2                	xor    %edx,%edx
  8018ad:	f7 f5                	div    %ebp
  8018af:	89 c8                	mov    %ecx,%eax
  8018b1:	f7 f5                	div    %ebp
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	e9 44 ff ff ff       	jmp    8017fe <__umoddi3+0x3e>
  8018ba:	66 90                	xchg   %ax,%ax
  8018bc:	89 c8                	mov    %ecx,%eax
  8018be:	89 f2                	mov    %esi,%edx
  8018c0:	83 c4 1c             	add    $0x1c,%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
  8018c8:	3b 04 24             	cmp    (%esp),%eax
  8018cb:	72 06                	jb     8018d3 <__umoddi3+0x113>
  8018cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8018d1:	77 0f                	ja     8018e2 <__umoddi3+0x122>
  8018d3:	89 f2                	mov    %esi,%edx
  8018d5:	29 f9                	sub    %edi,%ecx
  8018d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8018db:	89 14 24             	mov    %edx,(%esp)
  8018de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018e6:	8b 14 24             	mov    (%esp),%edx
  8018e9:	83 c4 1c             	add    $0x1c,%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5f                   	pop    %edi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    
  8018f1:	8d 76 00             	lea    0x0(%esi),%esi
  8018f4:	2b 04 24             	sub    (%esp),%eax
  8018f7:	19 fa                	sbb    %edi,%edx
  8018f9:	89 d1                	mov    %edx,%ecx
  8018fb:	89 c6                	mov    %eax,%esi
  8018fd:	e9 71 ff ff ff       	jmp    801873 <__umoddi3+0xb3>
  801902:	66 90                	xchg   %ax,%ax
  801904:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801908:	72 ea                	jb     8018f4 <__umoddi3+0x134>
  80190a:	89 d9                	mov    %ebx,%ecx
  80190c:	e9 62 ff ff ff       	jmp    801873 <__umoddi3+0xb3>
