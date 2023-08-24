
obj/user/ef_fos_fibonacci:     file format elf32-i386


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
  800031:	e8 82 00 00 00       	call   8000b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 20;
  800048:	c7 45 f4 14 00 00 00 	movl   $0x14,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 1f 00 00 00       	call   800079 <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 40 19 80 00       	push   $0x801940
  80006e:	e8 95 02 00 00       	call   800308 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	return;
  800076:	90                   	nop
}
  800077:	c9                   	leave  
  800078:	c3                   	ret    

00800079 <fibonacci>:


int fibonacci(int n)
{
  800079:	55                   	push   %ebp
  80007a:	89 e5                	mov    %esp,%ebp
  80007c:	53                   	push   %ebx
  80007d:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  800080:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800084:	7f 07                	jg     80008d <fibonacci+0x14>
		return 1 ;
  800086:	b8 01 00 00 00       	mov    $0x1,%eax
  80008b:	eb 26                	jmp    8000b3 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  80008d:	8b 45 08             	mov    0x8(%ebp),%eax
  800090:	48                   	dec    %eax
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	e8 df ff ff ff       	call   800079 <fibonacci>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	8b 45 08             	mov    0x8(%ebp),%eax
  8000a2:	83 e8 02             	sub    $0x2,%eax
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	e8 cb ff ff ff       	call   800079 <fibonacci>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	01 d8                	add    %ebx,%eax
}
  8000b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000be:	e8 6e 13 00 00       	call   801431 <sys_getenvindex>
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c9:	89 d0                	mov    %edx,%eax
  8000cb:	01 c0                	add    %eax,%eax
  8000cd:	01 d0                	add    %edx,%eax
  8000cf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000d6:	01 c8                	add    %ecx,%eax
  8000d8:	c1 e0 02             	shl    $0x2,%eax
  8000db:	01 d0                	add    %edx,%eax
  8000dd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000e4:	01 c8                	add    %ecx,%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	01 d0                	add    %edx,%eax
  8000eb:	c1 e0 02             	shl    $0x2,%eax
  8000ee:	01 d0                	add    %edx,%eax
  8000f0:	c1 e0 03             	shl    $0x3,%eax
  8000f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f8:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000fd:	a1 20 20 80 00       	mov    0x802020,%eax
  800102:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800108:	84 c0                	test   %al,%al
  80010a:	74 0f                	je     80011b <libmain+0x63>
		binaryname = myEnv->prog_name;
  80010c:	a1 20 20 80 00       	mov    0x802020,%eax
  800111:	05 18 da 01 00       	add    $0x1da18,%eax
  800116:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011f:	7e 0a                	jle    80012b <libmain+0x73>
		binaryname = argv[0];
  800121:	8b 45 0c             	mov    0xc(%ebp),%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80012b:	83 ec 08             	sub    $0x8,%esp
  80012e:	ff 75 0c             	pushl  0xc(%ebp)
  800131:	ff 75 08             	pushl  0x8(%ebp)
  800134:	e8 ff fe ff ff       	call   800038 <_main>
  800139:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80013c:	e8 fd 10 00 00       	call   80123e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 6c 19 80 00       	push   $0x80196c
  800149:	e8 8d 01 00 00       	call   8002db <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800151:	a1 20 20 80 00       	mov    0x802020,%eax
  800156:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80015c:	a1 20 20 80 00       	mov    0x802020,%eax
  800161:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	52                   	push   %edx
  80016b:	50                   	push   %eax
  80016c:	68 94 19 80 00       	push   $0x801994
  800171:	e8 65 01 00 00       	call   8002db <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800179:	a1 20 20 80 00       	mov    0x802020,%eax
  80017e:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800184:	a1 20 20 80 00       	mov    0x802020,%eax
  800189:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80018f:	a1 20 20 80 00       	mov    0x802020,%eax
  800194:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80019a:	51                   	push   %ecx
  80019b:	52                   	push   %edx
  80019c:	50                   	push   %eax
  80019d:	68 bc 19 80 00       	push   $0x8019bc
  8001a2:	e8 34 01 00 00       	call   8002db <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001aa:	a1 20 20 80 00       	mov    0x802020,%eax
  8001af:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	50                   	push   %eax
  8001b9:	68 14 1a 80 00       	push   $0x801a14
  8001be:	e8 18 01 00 00       	call   8002db <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 6c 19 80 00       	push   $0x80196c
  8001ce:	e8 08 01 00 00       	call   8002db <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d6:	e8 7d 10 00 00       	call   801258 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001db:	e8 19 00 00 00       	call   8001f9 <exit>
}
  8001e0:	90                   	nop
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	6a 00                	push   $0x0
  8001ee:	e8 0a 12 00 00       	call   8013fd <sys_destroy_env>
  8001f3:	83 c4 10             	add    $0x10,%esp
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <exit>:

void
exit(void)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ff:	e8 5f 12 00 00       	call   801463 <sys_exit_env>
}
  800204:	90                   	nop
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	8d 48 01             	lea    0x1(%eax),%ecx
  800215:	8b 55 0c             	mov    0xc(%ebp),%edx
  800218:	89 0a                	mov    %ecx,(%edx)
  80021a:	8b 55 08             	mov    0x8(%ebp),%edx
  80021d:	88 d1                	mov    %dl,%cl
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800222:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800230:	75 2c                	jne    80025e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800232:	a0 24 20 80 00       	mov    0x802024,%al
  800237:	0f b6 c0             	movzbl %al,%eax
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	8b 12                	mov    (%edx),%edx
  80023f:	89 d1                	mov    %edx,%ecx
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	83 c2 08             	add    $0x8,%edx
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	51                   	push   %ecx
  80024c:	52                   	push   %edx
  80024d:	e8 3e 0e 00 00       	call   801090 <sys_cputs>
  800252:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
  800258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	8b 40 04             	mov    0x4(%eax),%eax
  800264:	8d 50 01             	lea    0x1(%eax),%edx
  800267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800279:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800280:	00 00 00 
	b.cnt = 0;
  800283:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800299:	50                   	push   %eax
  80029a:	68 07 02 80 00       	push   $0x800207
  80029f:	e8 11 02 00 00       	call   8004b5 <vprintfmt>
  8002a4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a7:	a0 24 20 80 00       	mov    0x802024,%al
  8002ac:	0f b6 c0             	movzbl %al,%eax
  8002af:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	50                   	push   %eax
  8002b9:	52                   	push   %edx
  8002ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c0:	83 c0 08             	add    $0x8,%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 c7 0d 00 00       	call   801090 <sys_cputs>
  8002c9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002cc:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <cprintf>:

int cprintf(const char *fmt, ...) {
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e1:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f7:	50                   	push   %eax
  8002f8:	e8 73 ff ff ff       	call   800270 <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800303:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80030e:	e8 2b 0f 00 00       	call   80123e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
  800316:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	ff 75 f4             	pushl  -0xc(%ebp)
  800322:	50                   	push   %eax
  800323:	e8 48 ff ff ff       	call   800270 <vcprintf>
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80032e:	e8 25 0f 00 00       	call   801258 <sys_enable_interrupt>
	return cnt;
  800333:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 14             	sub    $0x14,%esp
  80033f:	8b 45 10             	mov    0x10(%ebp),%eax
  800342:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034b:	8b 45 18             	mov    0x18(%ebp),%eax
  80034e:	ba 00 00 00 00       	mov    $0x0,%edx
  800353:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800356:	77 55                	ja     8003ad <printnum+0x75>
  800358:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035b:	72 05                	jb     800362 <printnum+0x2a>
  80035d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800360:	77 4b                	ja     8003ad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800362:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800365:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800368:	8b 45 18             	mov    0x18(%ebp),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	52                   	push   %edx
  800371:	50                   	push   %eax
  800372:	ff 75 f4             	pushl  -0xc(%ebp)
  800375:	ff 75 f0             	pushl  -0x10(%ebp)
  800378:	e8 47 13 00 00       	call   8016c4 <__udivdi3>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	ff 75 20             	pushl  0x20(%ebp)
  800386:	53                   	push   %ebx
  800387:	ff 75 18             	pushl  0x18(%ebp)
  80038a:	52                   	push   %edx
  80038b:	50                   	push   %eax
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 08             	pushl  0x8(%ebp)
  800392:	e8 a1 ff ff ff       	call   800338 <printnum>
  800397:	83 c4 20             	add    $0x20,%esp
  80039a:	eb 1a                	jmp    8003b6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	ff 75 0c             	pushl  0xc(%ebp)
  8003a2:	ff 75 20             	pushl  0x20(%ebp)
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	ff d0                	call   *%eax
  8003aa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ad:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003b4:	7f e6                	jg     80039c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c4:	53                   	push   %ebx
  8003c5:	51                   	push   %ecx
  8003c6:	52                   	push   %edx
  8003c7:	50                   	push   %eax
  8003c8:	e8 07 14 00 00       	call   8017d4 <__umoddi3>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	05 54 1c 80 00       	add    $0x801c54,%eax
  8003d5:	8a 00                	mov    (%eax),%al
  8003d7:	0f be c0             	movsbl %al,%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 0c             	pushl  0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	ff d0                	call   *%eax
  8003e6:	83 c4 10             	add    $0x10,%esp
}
  8003e9:	90                   	nop
  8003ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f6:	7e 1c                	jle    800414 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	8d 50 08             	lea    0x8(%eax),%edx
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	89 10                	mov    %edx,(%eax)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	83 e8 08             	sub    $0x8,%eax
  80040d:	8b 50 04             	mov    0x4(%eax),%edx
  800410:	8b 00                	mov    (%eax),%eax
  800412:	eb 40                	jmp    800454 <getuint+0x65>
	else if (lflag)
  800414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800418:	74 1e                	je     800438 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 04             	lea    0x4(%eax),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	83 e8 04             	sub    $0x4,%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	ba 00 00 00 00       	mov    $0x0,%edx
  800436:	eb 1c                	jmp    800454 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	8d 50 04             	lea    0x4(%eax),%edx
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	89 10                	mov    %edx,(%eax)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	83 e8 04             	sub    $0x4,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800459:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045d:	7e 1c                	jle    80047b <getint+0x25>
		return va_arg(*ap, long long);
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 08             	lea    0x8(%eax),%edx
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	83 e8 08             	sub    $0x8,%eax
  800474:	8b 50 04             	mov    0x4(%eax),%edx
  800477:	8b 00                	mov    (%eax),%eax
  800479:	eb 38                	jmp    8004b3 <getint+0x5d>
	else if (lflag)
  80047b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047f:	74 1a                	je     80049b <getint+0x45>
		return va_arg(*ap, long);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	8d 50 04             	lea    0x4(%eax),%edx
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	89 10                	mov    %edx,(%eax)
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	83 e8 04             	sub    $0x4,%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	99                   	cltd   
  800499:	eb 18                	jmp    8004b3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 50 04             	lea    0x4(%eax),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	89 10                	mov    %edx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	83 e8 04             	sub    $0x4,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	99                   	cltd   
}
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	56                   	push   %esi
  8004b9:	53                   	push   %ebx
  8004ba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bd:	eb 17                	jmp    8004d6 <vprintfmt+0x21>
			if (ch == '\0')
  8004bf:	85 db                	test   %ebx,%ebx
  8004c1:	0f 84 af 03 00 00    	je     800876 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 0c             	pushl  0xc(%ebp)
  8004cd:	53                   	push   %ebx
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	ff d0                	call   *%eax
  8004d3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d9:	8d 50 01             	lea    0x1(%eax),%edx
  8004dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004df:	8a 00                	mov    (%eax),%al
  8004e1:	0f b6 d8             	movzbl %al,%ebx
  8004e4:	83 fb 25             	cmp    $0x25,%ebx
  8004e7:	75 d6                	jne    8004bf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004e9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800502:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8b 45 10             	mov    0x10(%ebp),%eax
  80050c:	8d 50 01             	lea    0x1(%eax),%edx
  80050f:	89 55 10             	mov    %edx,0x10(%ebp)
  800512:	8a 00                	mov    (%eax),%al
  800514:	0f b6 d8             	movzbl %al,%ebx
  800517:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80051a:	83 f8 55             	cmp    $0x55,%eax
  80051d:	0f 87 2b 03 00 00    	ja     80084e <vprintfmt+0x399>
  800523:	8b 04 85 78 1c 80 00 	mov    0x801c78(,%eax,4),%eax
  80052a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80052c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800530:	eb d7                	jmp    800509 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800532:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800536:	eb d1                	jmp    800509 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800538:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80053f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800542:	89 d0                	mov    %edx,%eax
  800544:	c1 e0 02             	shl    $0x2,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	01 d8                	add    %ebx,%eax
  80054d:	83 e8 30             	sub    $0x30,%eax
  800550:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8a 00                	mov    (%eax),%al
  800558:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80055b:	83 fb 2f             	cmp    $0x2f,%ebx
  80055e:	7e 3e                	jle    80059e <vprintfmt+0xe9>
  800560:	83 fb 39             	cmp    $0x39,%ebx
  800563:	7f 39                	jg     80059e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800565:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800568:	eb d5                	jmp    80053f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	83 c0 04             	add    $0x4,%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 e8 04             	sub    $0x4,%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80057e:	eb 1f                	jmp    80059f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800580:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800584:	79 83                	jns    800509 <vprintfmt+0x54>
				width = 0;
  800586:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80058d:	e9 77 ff ff ff       	jmp    800509 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800592:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800599:	e9 6b ff ff ff       	jmp    800509 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80059e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80059f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a3:	0f 89 60 ff ff ff    	jns    800509 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b6:	e9 4e ff ff ff       	jmp    800509 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005bb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005be:	e9 46 ff ff ff       	jmp    800509 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 e8 04             	sub    $0x4,%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	50                   	push   %eax
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	ff d0                	call   *%eax
  8005e0:	83 c4 10             	add    $0x10,%esp
			break;
  8005e3:	e9 89 02 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 c0 04             	add    $0x4,%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	79 02                	jns    8005ff <vprintfmt+0x14a>
				err = -err;
  8005fd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ff:	83 fb 64             	cmp    $0x64,%ebx
  800602:	7f 0b                	jg     80060f <vprintfmt+0x15a>
  800604:	8b 34 9d c0 1a 80 00 	mov    0x801ac0(,%ebx,4),%esi
  80060b:	85 f6                	test   %esi,%esi
  80060d:	75 19                	jne    800628 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80060f:	53                   	push   %ebx
  800610:	68 65 1c 80 00       	push   $0x801c65
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	ff 75 08             	pushl  0x8(%ebp)
  80061b:	e8 5e 02 00 00       	call   80087e <printfmt>
  800620:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800623:	e9 49 02 00 00       	jmp    800871 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800628:	56                   	push   %esi
  800629:	68 6e 1c 80 00       	push   $0x801c6e
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 08             	pushl  0x8(%ebp)
  800634:	e8 45 02 00 00       	call   80087e <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
			break;
  80063c:	e9 30 02 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	83 c0 04             	add    $0x4,%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 e8 04             	sub    $0x4,%eax
  800650:	8b 30                	mov    (%eax),%esi
  800652:	85 f6                	test   %esi,%esi
  800654:	75 05                	jne    80065b <vprintfmt+0x1a6>
				p = "(null)";
  800656:	be 71 1c 80 00       	mov    $0x801c71,%esi
			if (width > 0 && padc != '-')
  80065b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065f:	7e 6d                	jle    8006ce <vprintfmt+0x219>
  800661:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800665:	74 67                	je     8006ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	50                   	push   %eax
  80066e:	56                   	push   %esi
  80066f:	e8 0c 03 00 00       	call   800980 <strnlen>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80067a:	eb 16                	jmp    800692 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80067c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	50                   	push   %eax
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80068f:	ff 4d e4             	decl   -0x1c(%ebp)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	7f e4                	jg     80067c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800698:	eb 34                	jmp    8006ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80069a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80069e:	74 1c                	je     8006bc <vprintfmt+0x207>
  8006a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8006a3:	7e 05                	jle    8006aa <vprintfmt+0x1f5>
  8006a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8006a8:	7e 12                	jle    8006bc <vprintfmt+0x207>
					putch('?', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	6a 3f                	push   $0x3f
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	ff d0                	call   *%eax
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	53                   	push   %ebx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	8d 70 01             	lea    0x1(%eax),%esi
  8006d3:	8a 00                	mov    (%eax),%al
  8006d5:	0f be d8             	movsbl %al,%ebx
  8006d8:	85 db                	test   %ebx,%ebx
  8006da:	74 24                	je     800700 <vprintfmt+0x24b>
  8006dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e0:	78 b8                	js     80069a <vprintfmt+0x1e5>
  8006e2:	ff 4d e0             	decl   -0x20(%ebp)
  8006e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e9:	79 af                	jns    80069a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006eb:	eb 13                	jmp    800700 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	6a 20                	push   $0x20
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	ff d0                	call   *%eax
  8006fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800704:	7f e7                	jg     8006ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800706:	e9 66 01 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 e8             	pushl  -0x18(%ebp)
  800711:	8d 45 14             	lea    0x14(%ebp),%eax
  800714:	50                   	push   %eax
  800715:	e8 3c fd ff ff       	call   800456 <getint>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800720:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800729:	85 d2                	test   %edx,%edx
  80072b:	79 23                	jns    800750 <vprintfmt+0x29b>
				putch('-', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	6a 2d                	push   $0x2d
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	ff d0                	call   *%eax
  80073a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800743:	f7 d8                	neg    %eax
  800745:	83 d2 00             	adc    $0x0,%edx
  800748:	f7 da                	neg    %edx
  80074a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800750:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800757:	e9 bc 00 00 00       	jmp    800818 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 e8             	pushl  -0x18(%ebp)
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	50                   	push   %eax
  800766:	e8 84 fc ff ff       	call   8003ef <getuint>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800771:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800774:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077b:	e9 98 00 00 00       	jmp    800818 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	6a 58                	push   $0x58
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	ff d0                	call   *%eax
  80078d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	6a 58                	push   $0x58
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	6a 58                	push   $0x58
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	ff d0                	call   *%eax
  8007ad:	83 c4 10             	add    $0x10,%esp
			break;
  8007b0:	e9 bc 00 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 30                	push   $0x30
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	6a 78                	push   $0x78
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	83 c0 04             	add    $0x4,%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 e8 04             	sub    $0x4,%eax
  8007e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f7:	eb 1f                	jmp    800818 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	e8 e7 fb ff ff       	call   8003ef <getuint>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800811:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800818:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80081c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	52                   	push   %edx
  800823:	ff 75 e4             	pushl  -0x1c(%ebp)
  800826:	50                   	push   %eax
  800827:	ff 75 f4             	pushl  -0xc(%ebp)
  80082a:	ff 75 f0             	pushl  -0x10(%ebp)
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	ff 75 08             	pushl  0x8(%ebp)
  800833:	e8 00 fb ff ff       	call   800338 <printnum>
  800838:	83 c4 20             	add    $0x20,%esp
			break;
  80083b:	eb 34                	jmp    800871 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	eb 23                	jmp    800871 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	6a 25                	push   $0x25
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085e:	ff 4d 10             	decl   0x10(%ebp)
  800861:	eb 03                	jmp    800866 <vprintfmt+0x3b1>
  800863:	ff 4d 10             	decl   0x10(%ebp)
  800866:	8b 45 10             	mov    0x10(%ebp),%eax
  800869:	48                   	dec    %eax
  80086a:	8a 00                	mov    (%eax),%al
  80086c:	3c 25                	cmp    $0x25,%al
  80086e:	75 f3                	jne    800863 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800870:	90                   	nop
		}
	}
  800871:	e9 47 fc ff ff       	jmp    8004bd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800876:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800877:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800884:	8d 45 10             	lea    0x10(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	ff 75 f4             	pushl  -0xc(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	ff 75 08             	pushl  0x8(%ebp)
  80089a:	e8 16 fc ff ff       	call   8004b5 <vprintfmt>
  80089f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a2:	90                   	nop
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ab:	8b 40 08             	mov    0x8(%eax),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ba:	8b 10                	mov    (%eax),%edx
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 40 04             	mov    0x4(%eax),%eax
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	73 12                	jae    8008d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	89 0a                	mov    %ecx,(%edx)
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d6:	88 10                	mov    %dl,(%eax)
}
  8008d8:	90                   	nop
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	01 d0                	add    %edx,%eax
  8008f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800900:	74 06                	je     800908 <vsnprintf+0x2d>
  800902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800906:	7f 07                	jg     80090f <vsnprintf+0x34>
		return -E_INVAL;
  800908:	b8 03 00 00 00       	mov    $0x3,%eax
  80090d:	eb 20                	jmp    80092f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090f:	ff 75 14             	pushl  0x14(%ebp)
  800912:	ff 75 10             	pushl  0x10(%ebp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	68 a5 08 80 00       	push   $0x8008a5
  80091e:	e8 92 fb ff ff       	call   8004b5 <vprintfmt>
  800923:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800929:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800937:	8d 45 10             	lea    0x10(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800940:	8b 45 10             	mov    0x10(%ebp),%eax
  800943:	ff 75 f4             	pushl  -0xc(%ebp)
  800946:	50                   	push   %eax
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	e8 89 ff ff ff       	call   8008db <vsnprintf>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800958:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800963:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80096a:	eb 06                	jmp    800972 <strlen+0x15>
		n++;
  80096c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80096f:	ff 45 08             	incl   0x8(%ebp)
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8a 00                	mov    (%eax),%al
  800977:	84 c0                	test   %al,%al
  800979:	75 f1                	jne    80096c <strlen+0xf>
		n++;
	return n;
  80097b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098d:	eb 09                	jmp    800998 <strnlen+0x18>
		n++;
  80098f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800992:	ff 45 08             	incl   0x8(%ebp)
  800995:	ff 4d 0c             	decl   0xc(%ebp)
  800998:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099c:	74 09                	je     8009a7 <strnlen+0x27>
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8a 00                	mov    (%eax),%al
  8009a3:	84 c0                	test   %al,%al
  8009a5:	75 e8                	jne    80098f <strnlen+0xf>
		n++;
	return n;
  8009a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009b8:	90                   	nop
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8d 50 01             	lea    0x1(%eax),%edx
  8009bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009cb:	8a 12                	mov    (%edx),%dl
  8009cd:	88 10                	mov    %dl,(%eax)
  8009cf:	8a 00                	mov    (%eax),%al
  8009d1:	84 c0                	test   %al,%al
  8009d3:	75 e4                	jne    8009b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ed:	eb 1f                	jmp    800a0e <strncpy+0x34>
		*dst++ = *src;
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fb:	8a 12                	mov    (%edx),%dl
  8009fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	84 c0                	test   %al,%al
  800a06:	74 03                	je     800a0b <strncpy+0x31>
			src++;
  800a08:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0b:	ff 45 fc             	incl   -0x4(%ebp)
  800a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a11:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a14:	72 d9                	jb     8009ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a16:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2b:	74 30                	je     800a5d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a2d:	eb 16                	jmp    800a45 <strlcpy+0x2a>
			*dst++ = *src++;
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8d 50 01             	lea    0x1(%eax),%edx
  800a35:	89 55 08             	mov    %edx,0x8(%ebp)
  800a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a41:	8a 12                	mov    (%edx),%dl
  800a43:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a45:	ff 4d 10             	decl   0x10(%ebp)
  800a48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4c:	74 09                	je     800a57 <strlcpy+0x3c>
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	84 c0                	test   %al,%al
  800a55:	75 d8                	jne    800a2f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a63:	29 c2                	sub    %eax,%edx
  800a65:	89 d0                	mov    %edx,%eax
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a6c:	eb 06                	jmp    800a74 <strcmp+0xb>
		p++, q++;
  800a6e:	ff 45 08             	incl   0x8(%ebp)
  800a71:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	84 c0                	test   %al,%al
  800a7b:	74 0e                	je     800a8b <strcmp+0x22>
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8a 10                	mov    (%eax),%dl
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	38 c2                	cmp    %al,%dl
  800a89:	74 e3                	je     800a6e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	8a 00                	mov    (%eax),%al
  800a90:	0f b6 d0             	movzbl %al,%edx
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	0f b6 c0             	movzbl %al,%eax
  800a9b:	29 c2                	sub    %eax,%edx
  800a9d:	89 d0                	mov    %edx,%eax
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800aa4:	eb 09                	jmp    800aaf <strncmp+0xe>
		n--, p++, q++;
  800aa6:	ff 4d 10             	decl   0x10(%ebp)
  800aa9:	ff 45 08             	incl   0x8(%ebp)
  800aac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab3:	74 17                	je     800acc <strncmp+0x2b>
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	84 c0                	test   %al,%al
  800abc:	74 0e                	je     800acc <strncmp+0x2b>
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8a 10                	mov    (%eax),%dl
  800ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	38 c2                	cmp    %al,%dl
  800aca:	74 da                	je     800aa6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800acc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad0:	75 07                	jne    800ad9 <strncmp+0x38>
		return 0;
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	eb 14                	jmp    800aed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	0f b6 d0             	movzbl %al,%edx
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	0f b6 c0             	movzbl %al,%eax
  800ae9:	29 c2                	sub    %eax,%edx
  800aeb:	89 d0                	mov    %edx,%eax
}
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 04             	sub    $0x4,%esp
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800afb:	eb 12                	jmp    800b0f <strchr+0x20>
		if (*s == c)
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b05:	75 05                	jne    800b0c <strchr+0x1d>
			return (char *) s;
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	eb 11                	jmp    800b1d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b0c:	ff 45 08             	incl   0x8(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8a 00                	mov    (%eax),%al
  800b14:	84 c0                	test   %al,%al
  800b16:	75 e5                	jne    800afd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 04             	sub    $0x4,%esp
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b2b:	eb 0d                	jmp    800b3a <strfind+0x1b>
		if (*s == c)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8a 00                	mov    (%eax),%al
  800b32:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b35:	74 0e                	je     800b45 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b37:	ff 45 08             	incl   0x8(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	84 c0                	test   %al,%al
  800b41:	75 ea                	jne    800b2d <strfind+0xe>
  800b43:	eb 01                	jmp    800b46 <strfind+0x27>
		if (*s == c)
			break;
  800b45:	90                   	nop
	return (char *) s;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b57:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b5d:	eb 0e                	jmp    800b6d <memset+0x22>
		*p++ = c;
  800b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b62:	8d 50 01             	lea    0x1(%eax),%edx
  800b65:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b6d:	ff 4d f8             	decl   -0x8(%ebp)
  800b70:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b74:	79 e9                	jns    800b5f <memset+0x14>
		*p++ = c;

	return v;
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b8d:	eb 16                	jmp    800ba5 <memcpy+0x2a>
		*d++ = *s++;
  800b8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b92:	8d 50 01             	lea    0x1(%eax),%edx
  800b95:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b9e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba1:	8a 12                	mov    (%edx),%dl
  800ba3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bab:	89 55 10             	mov    %edx,0x10(%ebp)
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	75 dd                	jne    800b8f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bcf:	73 50                	jae    800c21 <memmove+0x6a>
  800bd1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	01 d0                	add    %edx,%eax
  800bd9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bdc:	76 43                	jbe    800c21 <memmove+0x6a>
		s += n;
  800bde:	8b 45 10             	mov    0x10(%ebp),%eax
  800be1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bea:	eb 10                	jmp    800bfc <memmove+0x45>
			*--d = *--s;
  800bec:	ff 4d f8             	decl   -0x8(%ebp)
  800bef:	ff 4d fc             	decl   -0x4(%ebp)
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf5:	8a 10                	mov    (%eax),%dl
  800bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c02:	89 55 10             	mov    %edx,0x10(%ebp)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	75 e3                	jne    800bec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c09:	eb 23                	jmp    800c2e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0e:	8d 50 01             	lea    0x1(%eax),%edx
  800c11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c1d:	8a 12                	mov    (%edx),%dl
  800c1f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c21:	8b 45 10             	mov    0x10(%ebp),%eax
  800c24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c27:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	75 dd                	jne    800c0b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c45:	eb 2a                	jmp    800c71 <memcmp+0x3e>
		if (*s1 != *s2)
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4a:	8a 10                	mov    (%eax),%dl
  800c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	38 c2                	cmp    %al,%dl
  800c53:	74 16                	je     800c6b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	0f b6 d0             	movzbl %al,%edx
  800c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	0f b6 c0             	movzbl %al,%eax
  800c65:	29 c2                	sub    %eax,%edx
  800c67:	89 d0                	mov    %edx,%eax
  800c69:	eb 18                	jmp    800c83 <memcmp+0x50>
		s1++, s2++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
  800c6e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c71:	8b 45 10             	mov    0x10(%ebp),%eax
  800c74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c77:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	75 c9                	jne    800c47 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	01 d0                	add    %edx,%eax
  800c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c96:	eb 15                	jmp    800cad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	0f b6 d0             	movzbl %al,%edx
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	0f b6 c0             	movzbl %al,%eax
  800ca6:	39 c2                	cmp    %eax,%edx
  800ca8:	74 0d                	je     800cb7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800caa:	ff 45 08             	incl   0x8(%ebp)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cb3:	72 e3                	jb     800c98 <memfind+0x13>
  800cb5:	eb 01                	jmp    800cb8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cb7:	90                   	nop
	return (void *) s;
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd1:	eb 03                	jmp    800cd6 <strtol+0x19>
		s++;
  800cd3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 20                	cmp    $0x20,%al
  800cdd:	74 f4                	je     800cd3 <strtol+0x16>
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	3c 09                	cmp    $0x9,%al
  800ce6:	74 eb                	je     800cd3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	3c 2b                	cmp    $0x2b,%al
  800cef:	75 05                	jne    800cf6 <strtol+0x39>
		s++;
  800cf1:	ff 45 08             	incl   0x8(%ebp)
  800cf4:	eb 13                	jmp    800d09 <strtol+0x4c>
	else if (*s == '-')
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	3c 2d                	cmp    $0x2d,%al
  800cfd:	75 0a                	jne    800d09 <strtol+0x4c>
		s++, neg = 1;
  800cff:	ff 45 08             	incl   0x8(%ebp)
  800d02:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0d:	74 06                	je     800d15 <strtol+0x58>
  800d0f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d13:	75 20                	jne    800d35 <strtol+0x78>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	3c 30                	cmp    $0x30,%al
  800d1c:	75 17                	jne    800d35 <strtol+0x78>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	40                   	inc    %eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 78                	cmp    $0x78,%al
  800d26:	75 0d                	jne    800d35 <strtol+0x78>
		s += 2, base = 16;
  800d28:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d2c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d33:	eb 28                	jmp    800d5d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 15                	jne    800d50 <strtol+0x93>
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3c 30                	cmp    $0x30,%al
  800d42:	75 0c                	jne    800d50 <strtol+0x93>
		s++, base = 8;
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d4e:	eb 0d                	jmp    800d5d <strtol+0xa0>
	else if (base == 0)
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	75 07                	jne    800d5d <strtol+0xa0>
		base = 10;
  800d56:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	3c 2f                	cmp    $0x2f,%al
  800d64:	7e 19                	jle    800d7f <strtol+0xc2>
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3c 39                	cmp    $0x39,%al
  800d6d:	7f 10                	jg     800d7f <strtol+0xc2>
			dig = *s - '0';
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f be c0             	movsbl %al,%eax
  800d77:	83 e8 30             	sub    $0x30,%eax
  800d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7d:	eb 42                	jmp    800dc1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 60                	cmp    $0x60,%al
  800d86:	7e 19                	jle    800da1 <strtol+0xe4>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 7a                	cmp    $0x7a,%al
  800d8f:	7f 10                	jg     800da1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	0f be c0             	movsbl %al,%eax
  800d99:	83 e8 57             	sub    $0x57,%eax
  800d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d9f:	eb 20                	jmp    800dc1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	3c 40                	cmp    $0x40,%al
  800da8:	7e 39                	jle    800de3 <strtol+0x126>
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	3c 5a                	cmp    $0x5a,%al
  800db1:	7f 30                	jg     800de3 <strtol+0x126>
			dig = *s - 'A' + 10;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f be c0             	movsbl %al,%eax
  800dbb:	83 e8 37             	sub    $0x37,%eax
  800dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc7:	7d 19                	jge    800de2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dc9:	ff 45 08             	incl   0x8(%ebp)
  800dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd3:	89 c2                	mov    %eax,%edx
  800dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ddd:	e9 7b ff ff ff       	jmp    800d5d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800de2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	74 08                	je     800df1 <strtol+0x134>
		*endptr = (char *) s;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800df1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800df5:	74 07                	je     800dfe <strtol+0x141>
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	f7 d8                	neg    %eax
  800dfc:	eb 03                	jmp    800e01 <strtol+0x144>
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <ltostr>:

void
ltostr(long value, char *str)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e1b:	79 13                	jns    800e30 <ltostr+0x2d>
	{
		neg = 1;
  800e1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e2a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e2d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e38:	99                   	cltd   
  800e39:	f7 f9                	idiv   %ecx
  800e3b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e41:	8d 50 01             	lea    0x1(%eax),%edx
  800e44:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e51:	83 c2 30             	add    $0x30,%edx
  800e54:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e59:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e5e:	f7 e9                	imul   %ecx
  800e60:	c1 fa 02             	sar    $0x2,%edx
  800e63:	89 c8                	mov    %ecx,%eax
  800e65:	c1 f8 1f             	sar    $0x1f,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
  800e6c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e72:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e77:	f7 e9                	imul   %ecx
  800e79:	c1 fa 02             	sar    $0x2,%edx
  800e7c:	89 c8                	mov    %ecx,%eax
  800e7e:	c1 f8 1f             	sar    $0x1f,%eax
  800e81:	29 c2                	sub    %eax,%edx
  800e83:	89 d0                	mov    %edx,%eax
  800e85:	c1 e0 02             	shl    $0x2,%eax
  800e88:	01 d0                	add    %edx,%eax
  800e8a:	01 c0                	add    %eax,%eax
  800e8c:	29 c1                	sub    %eax,%ecx
  800e8e:	89 ca                	mov    %ecx,%edx
  800e90:	85 d2                	test   %edx,%edx
  800e92:	75 9c                	jne    800e30 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9e:	48                   	dec    %eax
  800e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ea6:	74 3d                	je     800ee5 <ltostr+0xe2>
		start = 1 ;
  800ea8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800eaf:	eb 34                	jmp    800ee5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	01 d0                	add    %edx,%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	01 c2                	add    %eax,%edx
  800ec6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	01 c8                	add    %ecx,%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ed2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	01 c2                	add    %eax,%edx
  800eda:	8a 45 eb             	mov    -0x15(%ebp),%al
  800edd:	88 02                	mov    %al,(%edx)
		start++ ;
  800edf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ee2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eeb:	7c c4                	jl     800eb1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ef8:	90                   	nop
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f01:	ff 75 08             	pushl  0x8(%ebp)
  800f04:	e8 54 fa ff ff       	call   80095d <strlen>
  800f09:	83 c4 04             	add    $0x4,%esp
  800f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f0f:	ff 75 0c             	pushl  0xc(%ebp)
  800f12:	e8 46 fa ff ff       	call   80095d <strlen>
  800f17:	83 c4 04             	add    $0x4,%esp
  800f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2b:	eb 17                	jmp    800f44 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f30:	8b 45 10             	mov    0x10(%ebp),%eax
  800f33:	01 c2                	add    %eax,%edx
  800f35:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	01 c8                	add    %ecx,%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f41:	ff 45 fc             	incl   -0x4(%ebp)
  800f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f47:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f4a:	7c e1                	jl     800f2d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f4c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 1f                	jmp    800f7b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f65:	89 c2                	mov    %eax,%edx
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	01 c2                	add    %eax,%edx
  800f6c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	01 c8                	add    %ecx,%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f78:	ff 45 f8             	incl   -0x8(%ebp)
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f81:	7c d9                	jl     800f5c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 d0                	add    %edx,%eax
  800f8b:	c6 00 00             	movb   $0x0,(%eax)
}
  800f8e:	90                   	nop
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f94:	8b 45 14             	mov    0x14(%ebp),%eax
  800f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa0:	8b 00                	mov    (%eax),%eax
  800fa2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb4:	eb 0c                	jmp    800fc2 <strsplit+0x31>
			*string++ = 0;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8d 50 01             	lea    0x1(%eax),%edx
  800fbc:	89 55 08             	mov    %edx,0x8(%ebp)
  800fbf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 18                	je     800fe3 <strsplit+0x52>
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f be c0             	movsbl %al,%eax
  800fd3:	50                   	push   %eax
  800fd4:	ff 75 0c             	pushl  0xc(%ebp)
  800fd7:	e8 13 fb ff ff       	call   800aef <strchr>
  800fdc:	83 c4 08             	add    $0x8,%esp
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	75 d3                	jne    800fb6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	84 c0                	test   %al,%al
  800fea:	74 5a                	je     801046 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fec:	8b 45 14             	mov    0x14(%ebp),%eax
  800fef:	8b 00                	mov    (%eax),%eax
  800ff1:	83 f8 0f             	cmp    $0xf,%eax
  800ff4:	75 07                	jne    800ffd <strsplit+0x6c>
		{
			return 0;
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffb:	eb 66                	jmp    801063 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  801000:	8b 00                	mov    (%eax),%eax
  801002:	8d 48 01             	lea    0x1(%eax),%ecx
  801005:	8b 55 14             	mov    0x14(%ebp),%edx
  801008:	89 0a                	mov    %ecx,(%edx)
  80100a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801011:	8b 45 10             	mov    0x10(%ebp),%eax
  801014:	01 c2                	add    %eax,%edx
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80101b:	eb 03                	jmp    801020 <strsplit+0x8f>
			string++;
  80101d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	84 c0                	test   %al,%al
  801027:	74 8b                	je     800fb4 <strsplit+0x23>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	0f be c0             	movsbl %al,%eax
  801031:	50                   	push   %eax
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	e8 b5 fa ff ff       	call   800aef <strchr>
  80103a:	83 c4 08             	add    $0x8,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	74 dc                	je     80101d <strsplit+0x8c>
			string++;
	}
  801041:	e9 6e ff ff ff       	jmp    800fb4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801046:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801047:	8b 45 14             	mov    0x14(%ebp),%eax
  80104a:	8b 00                	mov    (%eax),%eax
  80104c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	01 d0                	add    %edx,%eax
  801058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
  80106b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
  801074:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801077:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80107d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801080:	cd 30                	int    $0x30
  801082:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80109c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	52                   	push   %edx
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	50                   	push   %eax
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 b2 ff ff ff       	call   801065 <syscall>
  8010b3:	83 c4 18             	add    $0x18,%esp
}
  8010b6:	90                   	nop
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010bc:	6a 00                	push   $0x0
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 01                	push   $0x1
  8010c8:	e8 98 ff ff ff       	call   801065 <syscall>
  8010cd:	83 c4 18             	add    $0x18,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	52                   	push   %edx
  8010e2:	50                   	push   %eax
  8010e3:	6a 05                	push   $0x5
  8010e5:	e8 7b ff ff ff       	call   801065 <syscall>
  8010ea:	83 c4 18             	add    $0x18,%esp
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	51                   	push   %ecx
  801106:	52                   	push   %edx
  801107:	50                   	push   %eax
  801108:	6a 06                	push   $0x6
  80110a:	e8 56 ff ff ff       	call   801065 <syscall>
  80110f:	83 c4 18             	add    $0x18,%esp
}
  801112:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80111c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	52                   	push   %edx
  801129:	50                   	push   %eax
  80112a:	6a 07                	push   $0x7
  80112c:	e8 34 ff ff ff       	call   801065 <syscall>
  801131:	83 c4 18             	add    $0x18,%esp
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	ff 75 0c             	pushl  0xc(%ebp)
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	6a 08                	push   $0x8
  801147:	e8 19 ff ff ff       	call   801065 <syscall>
  80114c:	83 c4 18             	add    $0x18,%esp
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 09                	push   $0x9
  801160:	e8 00 ff ff ff       	call   801065 <syscall>
  801165:	83 c4 18             	add    $0x18,%esp
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80116d:	6a 00                	push   $0x0
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 0a                	push   $0xa
  801179:	e8 e7 fe ff ff       	call   801065 <syscall>
  80117e:	83 c4 18             	add    $0x18,%esp
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 0b                	push   $0xb
  801192:	e8 ce fe ff ff       	call   801065 <syscall>
  801197:	83 c4 18             	add    $0x18,%esp
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	6a 0f                	push   $0xf
  8011ad:	e8 b3 fe ff ff       	call   801065 <syscall>
  8011b2:	83 c4 18             	add    $0x18,%esp
	return;
  8011b5:	90                   	nop
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	ff 75 0c             	pushl  0xc(%ebp)
  8011c4:	ff 75 08             	pushl  0x8(%ebp)
  8011c7:	6a 10                	push   $0x10
  8011c9:	e8 97 fe ff ff       	call   801065 <syscall>
  8011ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8011d1:	90                   	nop
}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	ff 75 10             	pushl  0x10(%ebp)
  8011de:	ff 75 0c             	pushl  0xc(%ebp)
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	6a 11                	push   $0x11
  8011e6:	e8 7a fe ff ff       	call   801065 <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8011ee:	90                   	nop
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 00                	push   $0x0
  8011fe:	6a 0c                	push   $0xc
  801200:	e8 60 fe ff ff       	call   801065 <syscall>
  801205:	83 c4 18             	add    $0x18,%esp
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	ff 75 08             	pushl  0x8(%ebp)
  801218:	6a 0d                	push   $0xd
  80121a:	e8 46 fe ff ff       	call   801065 <syscall>
  80121f:	83 c4 18             	add    $0x18,%esp
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 0e                	push   $0xe
  801233:	e8 2d fe ff ff       	call   801065 <syscall>
  801238:	83 c4 18             	add    $0x18,%esp
}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 13                	push   $0x13
  80124d:	e8 13 fe ff ff       	call   801065 <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	90                   	nop
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 14                	push   $0x14
  801267:	e8 f9 fd ff ff       	call   801065 <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	90                   	nop
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <sys_cputc>:


void
sys_cputc(const char c)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80127e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	50                   	push   %eax
  80128b:	6a 15                	push   $0x15
  80128d:	e8 d3 fd ff ff       	call   801065 <syscall>
  801292:	83 c4 18             	add    $0x18,%esp
}
  801295:	90                   	nop
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 16                	push   $0x16
  8012a7:	e8 b9 fd ff ff       	call   801065 <syscall>
  8012ac:	83 c4 18             	add    $0x18,%esp
}
  8012af:	90                   	nop
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	6a 17                	push   $0x17
  8012c4:	e8 9c fd ff ff       	call   801065 <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 1a                	push   $0x1a
  8012e1:	e8 7f fd ff ff       	call   801065 <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	50                   	push   %eax
  8012fc:	6a 18                	push   $0x18
  8012fe:	e8 62 fd ff ff       	call   801065 <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	90                   	nop
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80130c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	52                   	push   %edx
  801319:	50                   	push   %eax
  80131a:	6a 19                	push   $0x19
  80131c:	e8 44 fd ff ff       	call   801065 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801333:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801336:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	51                   	push   %ecx
  801340:	52                   	push   %edx
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	50                   	push   %eax
  801345:	6a 1b                	push   $0x1b
  801347:	e8 19 fd ff ff       	call   801065 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	52                   	push   %edx
  801361:	50                   	push   %eax
  801362:	6a 1c                	push   $0x1c
  801364:	e8 fc fc ff ff       	call   801065 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801371:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	51                   	push   %ecx
  80137f:	52                   	push   %edx
  801380:	50                   	push   %eax
  801381:	6a 1d                	push   $0x1d
  801383:	e8 dd fc ff ff       	call   801065 <syscall>
  801388:	83 c4 18             	add    $0x18,%esp
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	52                   	push   %edx
  80139d:	50                   	push   %eax
  80139e:	6a 1e                	push   $0x1e
  8013a0:	e8 c0 fc ff ff       	call   801065 <syscall>
  8013a5:	83 c4 18             	add    $0x18,%esp
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 1f                	push   $0x1f
  8013b9:	e8 a7 fc ff ff       	call   801065 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	6a 00                	push   $0x0
  8013cb:	ff 75 14             	pushl  0x14(%ebp)
  8013ce:	ff 75 10             	pushl  0x10(%ebp)
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	6a 20                	push   $0x20
  8013d7:	e8 89 fc ff ff       	call   801065 <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	50                   	push   %eax
  8013f0:	6a 21                	push   $0x21
  8013f2:	e8 6e fc ff ff       	call   801065 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	50                   	push   %eax
  80140c:	6a 22                	push   $0x22
  80140e:	e8 52 fc ff ff       	call   801065 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 02                	push   $0x2
  801427:	e8 39 fc ff ff       	call   801065 <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 03                	push   $0x3
  801440:	e8 20 fc ff ff       	call   801065 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 04                	push   $0x4
  801459:	e8 07 fc ff ff       	call   801065 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_exit_env>:


void sys_exit_env(void)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 23                	push   $0x23
  801472:	e8 ee fb ff ff       	call   801065 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	90                   	nop
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801483:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801486:	8d 50 04             	lea    0x4(%eax),%edx
  801489:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	52                   	push   %edx
  801493:	50                   	push   %eax
  801494:	6a 24                	push   $0x24
  801496:	e8 ca fb ff ff       	call   801065 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
	return result;
  80149e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	89 01                	mov    %eax,(%ecx)
  8014a9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	c9                   	leave  
  8014b0:	c2 04 00             	ret    $0x4

008014b3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	ff 75 10             	pushl  0x10(%ebp)
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	ff 75 08             	pushl  0x8(%ebp)
  8014c3:	6a 12                	push   $0x12
  8014c5:	e8 9b fb ff ff       	call   801065 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8014cd:	90                   	nop
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 25                	push   $0x25
  8014df:	e8 81 fb ff ff       	call   801065 <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014f5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	50                   	push   %eax
  801502:	6a 26                	push   $0x26
  801504:	e8 5c fb ff ff       	call   801065 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
	return ;
  80150c:	90                   	nop
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <rsttst>:
void rsttst()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 28                	push   $0x28
  80151e:	e8 42 fb ff ff       	call   801065 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
	return ;
  801526:	90                   	nop
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801535:	8b 55 18             	mov    0x18(%ebp),%edx
  801538:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	ff 75 10             	pushl  0x10(%ebp)
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	6a 27                	push   $0x27
  801549:	e8 17 fb ff ff       	call   801065 <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
	return ;
  801551:	90                   	nop
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <chktst>:
void chktst(uint32 n)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	6a 29                	push   $0x29
  801564:	e8 fc fa ff ff       	call   801065 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
	return ;
  80156c:	90                   	nop
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <inctst>:

void inctst()
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 2a                	push   $0x2a
  80157e:	e8 e2 fa ff ff       	call   801065 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
	return ;
  801586:	90                   	nop
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <gettst>:
uint32 gettst()
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 2b                	push   $0x2b
  801598:	e8 c8 fa ff ff       	call   801065 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 2c                	push   $0x2c
  8015b4:	e8 ac fa ff ff       	call   801065 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
  8015bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015bf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015c3:	75 07                	jne    8015cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ca:	eb 05                	jmp    8015d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 2c                	push   $0x2c
  8015e5:	e8 7b fa ff ff       	call   801065 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
  8015ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015f0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015f4:	75 07                	jne    8015fd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015fb:	eb 05                	jmp    801602 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 2c                	push   $0x2c
  801616:	e8 4a fa ff ff       	call   801065 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
  80161e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801621:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801625:	75 07                	jne    80162e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801627:	b8 01 00 00 00       	mov    $0x1,%eax
  80162c:	eb 05                	jmp    801633 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 2c                	push   $0x2c
  801647:	e8 19 fa ff ff       	call   801065 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
  80164f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801652:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801656:	75 07                	jne    80165f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801658:	b8 01 00 00 00       	mov    $0x1,%eax
  80165d:	eb 05                	jmp    801664 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	e8 ea f9 ff ff       	call   801065 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
	return ;
  80167e:	90                   	nop
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801685:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801688:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	53                   	push   %ebx
  801694:	51                   	push   %ecx
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	6a 2e                	push   $0x2e
  801699:	e8 c7 f9 ff ff       	call   801065 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 2f                	push   $0x2f
  8016b9:	e8 a7 f9 ff ff       	call   801065 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    
  8016c3:	90                   	nop

008016c4 <__udivdi3>:
  8016c4:	55                   	push   %ebp
  8016c5:	57                   	push   %edi
  8016c6:	56                   	push   %esi
  8016c7:	53                   	push   %ebx
  8016c8:	83 ec 1c             	sub    $0x1c,%esp
  8016cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016db:	89 ca                	mov    %ecx,%edx
  8016dd:	89 f8                	mov    %edi,%eax
  8016df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8016e3:	85 f6                	test   %esi,%esi
  8016e5:	75 2d                	jne    801714 <__udivdi3+0x50>
  8016e7:	39 cf                	cmp    %ecx,%edi
  8016e9:	77 65                	ja     801750 <__udivdi3+0x8c>
  8016eb:	89 fd                	mov    %edi,%ebp
  8016ed:	85 ff                	test   %edi,%edi
  8016ef:	75 0b                	jne    8016fc <__udivdi3+0x38>
  8016f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f6:	31 d2                	xor    %edx,%edx
  8016f8:	f7 f7                	div    %edi
  8016fa:	89 c5                	mov    %eax,%ebp
  8016fc:	31 d2                	xor    %edx,%edx
  8016fe:	89 c8                	mov    %ecx,%eax
  801700:	f7 f5                	div    %ebp
  801702:	89 c1                	mov    %eax,%ecx
  801704:	89 d8                	mov    %ebx,%eax
  801706:	f7 f5                	div    %ebp
  801708:	89 cf                	mov    %ecx,%edi
  80170a:	89 fa                	mov    %edi,%edx
  80170c:	83 c4 1c             	add    $0x1c,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    
  801714:	39 ce                	cmp    %ecx,%esi
  801716:	77 28                	ja     801740 <__udivdi3+0x7c>
  801718:	0f bd fe             	bsr    %esi,%edi
  80171b:	83 f7 1f             	xor    $0x1f,%edi
  80171e:	75 40                	jne    801760 <__udivdi3+0x9c>
  801720:	39 ce                	cmp    %ecx,%esi
  801722:	72 0a                	jb     80172e <__udivdi3+0x6a>
  801724:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801728:	0f 87 9e 00 00 00    	ja     8017cc <__udivdi3+0x108>
  80172e:	b8 01 00 00 00       	mov    $0x1,%eax
  801733:	89 fa                	mov    %edi,%edx
  801735:	83 c4 1c             	add    $0x1c,%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
  80173d:	8d 76 00             	lea    0x0(%esi),%esi
  801740:	31 ff                	xor    %edi,%edi
  801742:	31 c0                	xor    %eax,%eax
  801744:	89 fa                	mov    %edi,%edx
  801746:	83 c4 1c             	add    $0x1c,%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5f                   	pop    %edi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    
  80174e:	66 90                	xchg   %ax,%ax
  801750:	89 d8                	mov    %ebx,%eax
  801752:	f7 f7                	div    %edi
  801754:	31 ff                	xor    %edi,%edi
  801756:	89 fa                	mov    %edi,%edx
  801758:	83 c4 1c             	add    $0x1c,%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5f                   	pop    %edi
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    
  801760:	bd 20 00 00 00       	mov    $0x20,%ebp
  801765:	89 eb                	mov    %ebp,%ebx
  801767:	29 fb                	sub    %edi,%ebx
  801769:	89 f9                	mov    %edi,%ecx
  80176b:	d3 e6                	shl    %cl,%esi
  80176d:	89 c5                	mov    %eax,%ebp
  80176f:	88 d9                	mov    %bl,%cl
  801771:	d3 ed                	shr    %cl,%ebp
  801773:	89 e9                	mov    %ebp,%ecx
  801775:	09 f1                	or     %esi,%ecx
  801777:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80177b:	89 f9                	mov    %edi,%ecx
  80177d:	d3 e0                	shl    %cl,%eax
  80177f:	89 c5                	mov    %eax,%ebp
  801781:	89 d6                	mov    %edx,%esi
  801783:	88 d9                	mov    %bl,%cl
  801785:	d3 ee                	shr    %cl,%esi
  801787:	89 f9                	mov    %edi,%ecx
  801789:	d3 e2                	shl    %cl,%edx
  80178b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80178f:	88 d9                	mov    %bl,%cl
  801791:	d3 e8                	shr    %cl,%eax
  801793:	09 c2                	or     %eax,%edx
  801795:	89 d0                	mov    %edx,%eax
  801797:	89 f2                	mov    %esi,%edx
  801799:	f7 74 24 0c          	divl   0xc(%esp)
  80179d:	89 d6                	mov    %edx,%esi
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	f7 e5                	mul    %ebp
  8017a3:	39 d6                	cmp    %edx,%esi
  8017a5:	72 19                	jb     8017c0 <__udivdi3+0xfc>
  8017a7:	74 0b                	je     8017b4 <__udivdi3+0xf0>
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	31 ff                	xor    %edi,%edi
  8017ad:	e9 58 ff ff ff       	jmp    80170a <__udivdi3+0x46>
  8017b2:	66 90                	xchg   %ax,%ax
  8017b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017b8:	89 f9                	mov    %edi,%ecx
  8017ba:	d3 e2                	shl    %cl,%edx
  8017bc:	39 c2                	cmp    %eax,%edx
  8017be:	73 e9                	jae    8017a9 <__udivdi3+0xe5>
  8017c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017c3:	31 ff                	xor    %edi,%edi
  8017c5:	e9 40 ff ff ff       	jmp    80170a <__udivdi3+0x46>
  8017ca:	66 90                	xchg   %ax,%ax
  8017cc:	31 c0                	xor    %eax,%eax
  8017ce:	e9 37 ff ff ff       	jmp    80170a <__udivdi3+0x46>
  8017d3:	90                   	nop

008017d4 <__umoddi3>:
  8017d4:	55                   	push   %ebp
  8017d5:	57                   	push   %edi
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	83 ec 1c             	sub    $0x1c,%esp
  8017db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8017df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8017e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8017eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017f3:	89 f3                	mov    %esi,%ebx
  8017f5:	89 fa                	mov    %edi,%edx
  8017f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017fb:	89 34 24             	mov    %esi,(%esp)
  8017fe:	85 c0                	test   %eax,%eax
  801800:	75 1a                	jne    80181c <__umoddi3+0x48>
  801802:	39 f7                	cmp    %esi,%edi
  801804:	0f 86 a2 00 00 00    	jbe    8018ac <__umoddi3+0xd8>
  80180a:	89 c8                	mov    %ecx,%eax
  80180c:	89 f2                	mov    %esi,%edx
  80180e:	f7 f7                	div    %edi
  801810:	89 d0                	mov    %edx,%eax
  801812:	31 d2                	xor    %edx,%edx
  801814:	83 c4 1c             	add    $0x1c,%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    
  80181c:	39 f0                	cmp    %esi,%eax
  80181e:	0f 87 ac 00 00 00    	ja     8018d0 <__umoddi3+0xfc>
  801824:	0f bd e8             	bsr    %eax,%ebp
  801827:	83 f5 1f             	xor    $0x1f,%ebp
  80182a:	0f 84 ac 00 00 00    	je     8018dc <__umoddi3+0x108>
  801830:	bf 20 00 00 00       	mov    $0x20,%edi
  801835:	29 ef                	sub    %ebp,%edi
  801837:	89 fe                	mov    %edi,%esi
  801839:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80183d:	89 e9                	mov    %ebp,%ecx
  80183f:	d3 e0                	shl    %cl,%eax
  801841:	89 d7                	mov    %edx,%edi
  801843:	89 f1                	mov    %esi,%ecx
  801845:	d3 ef                	shr    %cl,%edi
  801847:	09 c7                	or     %eax,%edi
  801849:	89 e9                	mov    %ebp,%ecx
  80184b:	d3 e2                	shl    %cl,%edx
  80184d:	89 14 24             	mov    %edx,(%esp)
  801850:	89 d8                	mov    %ebx,%eax
  801852:	d3 e0                	shl    %cl,%eax
  801854:	89 c2                	mov    %eax,%edx
  801856:	8b 44 24 08          	mov    0x8(%esp),%eax
  80185a:	d3 e0                	shl    %cl,%eax
  80185c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801860:	8b 44 24 08          	mov    0x8(%esp),%eax
  801864:	89 f1                	mov    %esi,%ecx
  801866:	d3 e8                	shr    %cl,%eax
  801868:	09 d0                	or     %edx,%eax
  80186a:	d3 eb                	shr    %cl,%ebx
  80186c:	89 da                	mov    %ebx,%edx
  80186e:	f7 f7                	div    %edi
  801870:	89 d3                	mov    %edx,%ebx
  801872:	f7 24 24             	mull   (%esp)
  801875:	89 c6                	mov    %eax,%esi
  801877:	89 d1                	mov    %edx,%ecx
  801879:	39 d3                	cmp    %edx,%ebx
  80187b:	0f 82 87 00 00 00    	jb     801908 <__umoddi3+0x134>
  801881:	0f 84 91 00 00 00    	je     801918 <__umoddi3+0x144>
  801887:	8b 54 24 04          	mov    0x4(%esp),%edx
  80188b:	29 f2                	sub    %esi,%edx
  80188d:	19 cb                	sbb    %ecx,%ebx
  80188f:	89 d8                	mov    %ebx,%eax
  801891:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801895:	d3 e0                	shl    %cl,%eax
  801897:	89 e9                	mov    %ebp,%ecx
  801899:	d3 ea                	shr    %cl,%edx
  80189b:	09 d0                	or     %edx,%eax
  80189d:	89 e9                	mov    %ebp,%ecx
  80189f:	d3 eb                	shr    %cl,%ebx
  8018a1:	89 da                	mov    %ebx,%edx
  8018a3:	83 c4 1c             	add    $0x1c,%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5f                   	pop    %edi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    
  8018ab:	90                   	nop
  8018ac:	89 fd                	mov    %edi,%ebp
  8018ae:	85 ff                	test   %edi,%edi
  8018b0:	75 0b                	jne    8018bd <__umoddi3+0xe9>
  8018b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b7:	31 d2                	xor    %edx,%edx
  8018b9:	f7 f7                	div    %edi
  8018bb:	89 c5                	mov    %eax,%ebp
  8018bd:	89 f0                	mov    %esi,%eax
  8018bf:	31 d2                	xor    %edx,%edx
  8018c1:	f7 f5                	div    %ebp
  8018c3:	89 c8                	mov    %ecx,%eax
  8018c5:	f7 f5                	div    %ebp
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	e9 44 ff ff ff       	jmp    801812 <__umoddi3+0x3e>
  8018ce:	66 90                	xchg   %ax,%ax
  8018d0:	89 c8                	mov    %ecx,%eax
  8018d2:	89 f2                	mov    %esi,%edx
  8018d4:	83 c4 1c             	add    $0x1c,%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    
  8018dc:	3b 04 24             	cmp    (%esp),%eax
  8018df:	72 06                	jb     8018e7 <__umoddi3+0x113>
  8018e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8018e5:	77 0f                	ja     8018f6 <__umoddi3+0x122>
  8018e7:	89 f2                	mov    %esi,%edx
  8018e9:	29 f9                	sub    %edi,%ecx
  8018eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8018ef:	89 14 24             	mov    %edx,(%esp)
  8018f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018fa:	8b 14 24             	mov    (%esp),%edx
  8018fd:	83 c4 1c             	add    $0x1c,%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5f                   	pop    %edi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
  801905:	8d 76 00             	lea    0x0(%esi),%esi
  801908:	2b 04 24             	sub    (%esp),%eax
  80190b:	19 fa                	sbb    %edi,%edx
  80190d:	89 d1                	mov    %edx,%ecx
  80190f:	89 c6                	mov    %eax,%esi
  801911:	e9 71 ff ff ff       	jmp    801887 <__umoddi3+0xb3>
  801916:	66 90                	xchg   %ax,%ax
  801918:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80191c:	72 ea                	jb     801908 <__umoddi3+0x134>
  80191e:	89 d9                	mov    %ebx,%ecx
  801920:	e9 62 ff ff ff       	jmp    801887 <__umoddi3+0xb3>
