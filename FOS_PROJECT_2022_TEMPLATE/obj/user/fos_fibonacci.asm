
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
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
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 00 1c 80 00       	push   $0x801c00
  800057:	e8 28 0a 00 00       	call   800a84 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 7a 0e 00 00       	call   800eec <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 1e 1c 80 00       	push   $0x801c1e
  800097:	e8 95 02 00 00       	call   800331 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e7:	e8 74 15 00 00       	call   801660 <sys_getenvindex>
  8000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	01 c0                	add    %eax,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000ff:	01 c8                	add    %ecx,%eax
  800101:	c1 e0 02             	shl    $0x2,%eax
  800104:	01 d0                	add    %edx,%eax
  800106:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80010d:	01 c8                	add    %ecx,%eax
  80010f:	c1 e0 02             	shl    $0x2,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	c1 e0 02             	shl    $0x2,%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	c1 e0 03             	shl    $0x3,%eax
  80011c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800121:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800131:	84 c0                	test   %al,%al
  800133:	74 0f                	je     800144 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800135:	a1 20 30 80 00       	mov    0x803020,%eax
  80013a:	05 18 da 01 00       	add    $0x1da18,%eax
  80013f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800144:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800148:	7e 0a                	jle    800154 <libmain+0x73>
		binaryname = argv[0];
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	e8 d6 fe ff ff       	call   800038 <_main>
  800162:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800165:	e8 03 13 00 00       	call   80146d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 4c 1c 80 00       	push   $0x801c4c
  800172:	e8 8d 01 00 00       	call   800304 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80017a:	a1 20 30 80 00       	mov    0x803020,%eax
  80017f:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	52                   	push   %edx
  800194:	50                   	push   %eax
  800195:	68 74 1c 80 00       	push   $0x801c74
  80019a:	e8 65 01 00 00       	call   800304 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a7:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8001ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b2:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8001b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bd:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8001c3:	51                   	push   %ecx
  8001c4:	52                   	push   %edx
  8001c5:	50                   	push   %eax
  8001c6:	68 9c 1c 80 00       	push   $0x801c9c
  8001cb:	e8 34 01 00 00       	call   800304 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d8:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	50                   	push   %eax
  8001e2:	68 f4 1c 80 00       	push   $0x801cf4
  8001e7:	e8 18 01 00 00       	call   800304 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 4c 1c 80 00       	push   $0x801c4c
  8001f7:	e8 08 01 00 00       	call   800304 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ff:	e8 83 12 00 00       	call   801487 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800204:	e8 19 00 00 00       	call   800222 <exit>
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 00                	push   $0x0
  800217:	e8 10 14 00 00       	call   80162c <sys_destroy_env>
  80021c:	83 c4 10             	add    $0x10,%esp
}
  80021f:	90                   	nop
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <exit>:

void
exit(void)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800228:	e8 65 14 00 00       	call   801692 <sys_exit_env>
}
  80022d:	90                   	nop
  80022e:	c9                   	leave  
  80022f:	c3                   	ret    

00800230 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	8b 00                	mov    (%eax),%eax
  80023b:	8d 48 01             	lea    0x1(%eax),%ecx
  80023e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800241:	89 0a                	mov    %ecx,(%edx)
  800243:	8b 55 08             	mov    0x8(%ebp),%edx
  800246:	88 d1                	mov    %dl,%cl
  800248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	75 2c                	jne    800287 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80025b:	a0 24 30 80 00       	mov    0x803024,%al
  800260:	0f b6 c0             	movzbl %al,%eax
  800263:	8b 55 0c             	mov    0xc(%ebp),%edx
  800266:	8b 12                	mov    (%edx),%edx
  800268:	89 d1                	mov    %edx,%ecx
  80026a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026d:	83 c2 08             	add    $0x8,%edx
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	50                   	push   %eax
  800274:	51                   	push   %ecx
  800275:	52                   	push   %edx
  800276:	e8 44 10 00 00       	call   8012bf <sys_cputs>
  80027b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028a:	8b 40 04             	mov    0x4(%eax),%eax
  80028d:	8d 50 01             	lea    0x1(%eax),%edx
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
  800293:	89 50 04             	mov    %edx,0x4(%eax)
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a9:	00 00 00 
	b.cnt = 0;
  8002ac:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c2:	50                   	push   %eax
  8002c3:	68 30 02 80 00       	push   $0x800230
  8002c8:	e8 11 02 00 00       	call   8004de <vprintfmt>
  8002cd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002d0:	a0 24 30 80 00       	mov    0x803024,%al
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	50                   	push   %eax
  8002e2:	52                   	push   %edx
  8002e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e9:	83 c0 08             	add    $0x8,%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 cd 0f 00 00       	call   8012bf <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <cprintf>:

int cprintf(const char *fmt, ...) {
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80030a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800311:	8d 45 0c             	lea    0xc(%ebp),%eax
  800314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800317:	8b 45 08             	mov    0x8(%ebp),%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 f4             	pushl  -0xc(%ebp)
  800320:	50                   	push   %eax
  800321:	e8 73 ff ff ff       	call   800299 <vcprintf>
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800337:	e8 31 11 00 00       	call   80146d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80033c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	ff 75 f4             	pushl  -0xc(%ebp)
  80034b:	50                   	push   %eax
  80034c:	e8 48 ff ff ff       	call   800299 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800357:	e8 2b 11 00 00       	call   801487 <sys_enable_interrupt>
	return cnt;
  80035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	53                   	push   %ebx
  800365:	83 ec 14             	sub    $0x14,%esp
  800368:	8b 45 10             	mov    0x10(%ebp),%eax
  80036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80036e:	8b 45 14             	mov    0x14(%ebp),%eax
  800371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800374:	8b 45 18             	mov    0x18(%ebp),%eax
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037f:	77 55                	ja     8003d6 <printnum+0x75>
  800381:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800384:	72 05                	jb     80038b <printnum+0x2a>
  800386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800389:	77 4b                	ja     8003d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80038e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800391:	8b 45 18             	mov    0x18(%ebp),%eax
  800394:	ba 00 00 00 00       	mov    $0x0,%edx
  800399:	52                   	push   %edx
  80039a:	50                   	push   %eax
  80039b:	ff 75 f4             	pushl  -0xc(%ebp)
  80039e:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a1:	e8 ee 15 00 00       	call   801994 <__udivdi3>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	83 ec 04             	sub    $0x4,%esp
  8003ac:	ff 75 20             	pushl  0x20(%ebp)
  8003af:	53                   	push   %ebx
  8003b0:	ff 75 18             	pushl  0x18(%ebp)
  8003b3:	52                   	push   %edx
  8003b4:	50                   	push   %eax
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	e8 a1 ff ff ff       	call   800361 <printnum>
  8003c0:	83 c4 20             	add    $0x20,%esp
  8003c3:	eb 1a                	jmp    8003df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 0c             	pushl  0xc(%ebp)
  8003cb:	ff 75 20             	pushl  0x20(%ebp)
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	ff d0                	call   *%eax
  8003d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003dd:	7f e6                	jg     8003c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ed:	53                   	push   %ebx
  8003ee:	51                   	push   %ecx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	e8 ae 16 00 00       	call   801aa4 <__umoddi3>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	05 34 1f 80 00       	add    $0x801f34,%eax
  8003fe:	8a 00                	mov    (%eax),%al
  800400:	0f be c0             	movsbl %al,%eax
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	ff 75 0c             	pushl  0xc(%ebp)
  800409:	50                   	push   %eax
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	ff d0                	call   *%eax
  80040f:	83 c4 10             	add    $0x10,%esp
}
  800412:	90                   	nop
  800413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041f:	7e 1c                	jle    80043d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	8d 50 08             	lea    0x8(%eax),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	89 10                	mov    %edx,(%eax)
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	83 e8 08             	sub    $0x8,%eax
  800436:	8b 50 04             	mov    0x4(%eax),%edx
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	eb 40                	jmp    80047d <getuint+0x65>
	else if (lflag)
  80043d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800441:	74 1e                	je     800461 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 04             	lea    0x4(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 04             	sub    $0x4,%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
  80045f:	eb 1c                	jmp    80047d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	8d 50 04             	lea    0x4(%eax),%edx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 10                	mov    %edx,(%eax)
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	83 e8 04             	sub    $0x4,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800482:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800486:	7e 1c                	jle    8004a4 <getint+0x25>
		return va_arg(*ap, long long);
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	8d 50 08             	lea    0x8(%eax),%edx
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 10                	mov    %edx,(%eax)
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	83 e8 08             	sub    $0x8,%eax
  80049d:	8b 50 04             	mov    0x4(%eax),%edx
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	eb 38                	jmp    8004dc <getint+0x5d>
	else if (lflag)
  8004a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a8:	74 1a                	je     8004c4 <getint+0x45>
		return va_arg(*ap, long);
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	8d 50 04             	lea    0x4(%eax),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	89 10                	mov    %edx,(%eax)
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	83 e8 04             	sub    $0x4,%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	99                   	cltd   
  8004c2:	eb 18                	jmp    8004dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	8d 50 04             	lea    0x4(%eax),%edx
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	89 10                	mov    %edx,(%eax)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	83 e8 04             	sub    $0x4,%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	99                   	cltd   
}
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e6:	eb 17                	jmp    8004ff <vprintfmt+0x21>
			if (ch == '\0')
  8004e8:	85 db                	test   %ebx,%ebx
  8004ea:	0f 84 af 03 00 00    	je     80089f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 0c             	pushl  0xc(%ebp)
  8004f6:	53                   	push   %ebx
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	ff d0                	call   *%eax
  8004fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800502:	8d 50 01             	lea    0x1(%eax),%edx
  800505:	89 55 10             	mov    %edx,0x10(%ebp)
  800508:	8a 00                	mov    (%eax),%al
  80050a:	0f b6 d8             	movzbl %al,%ebx
  80050d:	83 fb 25             	cmp    $0x25,%ebx
  800510:	75 d6                	jne    8004e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800512:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800516:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80051d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800524:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80052b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	8d 50 01             	lea    0x1(%eax),%edx
  800538:	89 55 10             	mov    %edx,0x10(%ebp)
  80053b:	8a 00                	mov    (%eax),%al
  80053d:	0f b6 d8             	movzbl %al,%ebx
  800540:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800543:	83 f8 55             	cmp    $0x55,%eax
  800546:	0f 87 2b 03 00 00    	ja     800877 <vprintfmt+0x399>
  80054c:	8b 04 85 58 1f 80 00 	mov    0x801f58(,%eax,4),%eax
  800553:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800555:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800559:	eb d7                	jmp    800532 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80055f:	eb d1                	jmp    800532 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800561:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800568:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056b:	89 d0                	mov    %edx,%eax
  80056d:	c1 e0 02             	shl    $0x2,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	01 c0                	add    %eax,%eax
  800574:	01 d8                	add    %ebx,%eax
  800576:	83 e8 30             	sub    $0x30,%eax
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80057c:	8b 45 10             	mov    0x10(%ebp),%eax
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800584:	83 fb 2f             	cmp    $0x2f,%ebx
  800587:	7e 3e                	jle    8005c7 <vprintfmt+0xe9>
  800589:	83 fb 39             	cmp    $0x39,%ebx
  80058c:	7f 39                	jg     8005c7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800591:	eb d5                	jmp    800568 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	83 c0 04             	add    $0x4,%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 e8 04             	sub    $0x4,%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a7:	eb 1f                	jmp    8005c8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ad:	79 83                	jns    800532 <vprintfmt+0x54>
				width = 0;
  8005af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b6:	e9 77 ff ff ff       	jmp    800532 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c2:	e9 6b ff ff ff       	jmp    800532 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cc:	0f 89 60 ff ff ff    	jns    800532 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005df:	e9 4e ff ff ff       	jmp    800532 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e7:	e9 46 ff ff ff       	jmp    800532 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	83 c0 04             	add    $0x4,%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	83 e8 04             	sub    $0x4,%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	50                   	push   %eax
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
			break;
  80060c:	e9 89 02 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 c0 04             	add    $0x4,%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 e8 04             	sub    $0x4,%eax
  800620:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800622:	85 db                	test   %ebx,%ebx
  800624:	79 02                	jns    800628 <vprintfmt+0x14a>
				err = -err;
  800626:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800628:	83 fb 64             	cmp    $0x64,%ebx
  80062b:	7f 0b                	jg     800638 <vprintfmt+0x15a>
  80062d:	8b 34 9d a0 1d 80 00 	mov    0x801da0(,%ebx,4),%esi
  800634:	85 f6                	test   %esi,%esi
  800636:	75 19                	jne    800651 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800638:	53                   	push   %ebx
  800639:	68 45 1f 80 00       	push   $0x801f45
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	ff 75 08             	pushl  0x8(%ebp)
  800644:	e8 5e 02 00 00       	call   8008a7 <printfmt>
  800649:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80064c:	e9 49 02 00 00       	jmp    80089a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800651:	56                   	push   %esi
  800652:	68 4e 1f 80 00       	push   $0x801f4e
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 45 02 00 00       	call   8008a7 <printfmt>
  800662:	83 c4 10             	add    $0x10,%esp
			break;
  800665:	e9 30 02 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 c0 04             	add    $0x4,%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 30                	mov    (%eax),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 05                	jne    800684 <vprintfmt+0x1a6>
				p = "(null)";
  80067f:	be 51 1f 80 00       	mov    $0x801f51,%esi
			if (width > 0 && padc != '-')
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	7e 6d                	jle    8006f7 <vprintfmt+0x219>
  80068a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80068e:	74 67                	je     8006f7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	50                   	push   %eax
  800697:	56                   	push   %esi
  800698:	e8 12 05 00 00       	call   800baf <strnlen>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006a3:	eb 16                	jmp    8006bb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bf:	7f e4                	jg     8006a5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c1:	eb 34                	jmp    8006f7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c7:	74 1c                	je     8006e5 <vprintfmt+0x207>
  8006c9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006cc:	7e 05                	jle    8006d3 <vprintfmt+0x1f5>
  8006ce:	83 fb 7e             	cmp    $0x7e,%ebx
  8006d1:	7e 12                	jle    8006e5 <vprintfmt+0x207>
					putch('?', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	6a 3f                	push   $0x3f
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb 0f                	jmp    8006f4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	53                   	push   %ebx
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	8d 70 01             	lea    0x1(%eax),%esi
  8006fc:	8a 00                	mov    (%eax),%al
  8006fe:	0f be d8             	movsbl %al,%ebx
  800701:	85 db                	test   %ebx,%ebx
  800703:	74 24                	je     800729 <vprintfmt+0x24b>
  800705:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800709:	78 b8                	js     8006c3 <vprintfmt+0x1e5>
  80070b:	ff 4d e0             	decl   -0x20(%ebp)
  80070e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800712:	79 af                	jns    8006c3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800714:	eb 13                	jmp    800729 <vprintfmt+0x24b>
				putch(' ', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	6a 20                	push   $0x20
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800726:	ff 4d e4             	decl   -0x1c(%ebp)
  800729:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072d:	7f e7                	jg     800716 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80072f:	e9 66 01 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 e8             	pushl  -0x18(%ebp)
  80073a:	8d 45 14             	lea    0x14(%ebp),%eax
  80073d:	50                   	push   %eax
  80073e:	e8 3c fd ff ff       	call   80047f <getint>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800749:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80074c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800752:	85 d2                	test   %edx,%edx
  800754:	79 23                	jns    800779 <vprintfmt+0x29b>
				putch('-', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	6a 2d                	push   $0x2d
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	f7 d8                	neg    %eax
  80076e:	83 d2 00             	adc    $0x0,%edx
  800771:	f7 da                	neg    %edx
  800773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800776:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800779:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800780:	e9 bc 00 00 00       	jmp    800841 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 e8             	pushl  -0x18(%ebp)
  80078b:	8d 45 14             	lea    0x14(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	e8 84 fc ff ff       	call   800418 <getuint>
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80079d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a4:	e9 98 00 00 00       	jmp    800841 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 58                	push   $0x58
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	6a 58                	push   $0x58
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	6a 58                	push   $0x58
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	ff d0                	call   *%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
			break;
  8007d9:	e9 bc 00 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	6a 30                	push   $0x30
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	6a 78                	push   $0x78
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	ff d0                	call   *%eax
  8007fb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 c0 04             	add    $0x4,%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	83 e8 04             	sub    $0x4,%eax
  80080d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800819:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800820:	eb 1f                	jmp    800841 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 e8             	pushl  -0x18(%ebp)
  800828:	8d 45 14             	lea    0x14(%ebp),%eax
  80082b:	50                   	push   %eax
  80082c:	e8 e7 fb ff ff       	call   800418 <getuint>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800837:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80083a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800841:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800848:	83 ec 04             	sub    $0x4,%esp
  80084b:	52                   	push   %edx
  80084c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80084f:	50                   	push   %eax
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	ff 75 f0             	pushl  -0x10(%ebp)
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 00 fb ff ff       	call   800361 <printnum>
  800861:	83 c4 20             	add    $0x20,%esp
			break;
  800864:	eb 34                	jmp    80089a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	53                   	push   %ebx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			break;
  800875:	eb 23                	jmp    80089a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 25                	push   $0x25
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800887:	ff 4d 10             	decl   0x10(%ebp)
  80088a:	eb 03                	jmp    80088f <vprintfmt+0x3b1>
  80088c:	ff 4d 10             	decl   0x10(%ebp)
  80088f:	8b 45 10             	mov    0x10(%ebp),%eax
  800892:	48                   	dec    %eax
  800893:	8a 00                	mov    (%eax),%al
  800895:	3c 25                	cmp    $0x25,%al
  800897:	75 f3                	jne    80088c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800899:	90                   	nop
		}
	}
  80089a:	e9 47 fc ff ff       	jmp    8004e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80089f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 16 fc ff ff       	call   8004de <vprintfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008cb:	90                   	nop
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 40 08             	mov    0x8(%eax),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 10                	mov    (%eax),%edx
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	8b 40 04             	mov    0x4(%eax),%eax
  8008eb:	39 c2                	cmp    %eax,%edx
  8008ed:	73 12                	jae    800901 <sprintputch+0x33>
		*b->buf++ = ch;
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	89 0a                	mov    %ecx,(%edx)
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	88 10                	mov    %dl,(%eax)
}
  800901:	90                   	nop
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	8d 50 ff             	lea    -0x1(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800925:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800929:	74 06                	je     800931 <vsnprintf+0x2d>
  80092b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092f:	7f 07                	jg     800938 <vsnprintf+0x34>
		return -E_INVAL;
  800931:	b8 03 00 00 00       	mov    $0x3,%eax
  800936:	eb 20                	jmp    800958 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800938:	ff 75 14             	pushl  0x14(%ebp)
  80093b:	ff 75 10             	pushl  0x10(%ebp)
  80093e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 ce 08 80 00       	push   $0x8008ce
  800947:	e8 92 fb ff ff       	call   8004de <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80094f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800952:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800955:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800960:	8d 45 10             	lea    0x10(%ebp),%eax
  800963:	83 c0 04             	add    $0x4,%eax
  800966:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800969:	8b 45 10             	mov    0x10(%ebp),%eax
  80096c:	ff 75 f4             	pushl  -0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 89 ff ff ff       	call   800904 <vsnprintf>
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800981:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80098c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800990:	74 13                	je     8009a5 <readline+0x1f>
		cprintf("%s", prompt);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	68 b0 20 80 00       	push   $0x8020b0
  80099d:	e8 62 f9 ff ff       	call   800304 <cprintf>
  8009a2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	6a 00                	push   $0x0
  8009b1:	e8 d2 0f 00 00       	call   801988 <iscons>
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009bc:	e8 79 0f 00 00       	call   80193a <getchar>
  8009c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009c8:	79 22                	jns    8009ec <readline+0x66>
			if (c != -E_EOF)
  8009ca:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009ce:	0f 84 ad 00 00 00    	je     800a81 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8009da:	68 b3 20 80 00       	push   $0x8020b3
  8009df:	e8 20 f9 ff ff       	call   800304 <cprintf>
  8009e4:	83 c4 10             	add    $0x10,%esp
			return;
  8009e7:	e9 95 00 00 00       	jmp    800a81 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009ec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009f0:	7e 34                	jle    800a26 <readline+0xa0>
  8009f2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009f9:	7f 2b                	jg     800a26 <readline+0xa0>
			if (echoing)
  8009fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009ff:	74 0e                	je     800a0f <readline+0x89>
				cputchar(c);
  800a01:	83 ec 0c             	sub    $0xc,%esp
  800a04:	ff 75 ec             	pushl  -0x14(%ebp)
  800a07:	e8 e6 0e 00 00       	call   8018f2 <cputchar>
  800a0c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a12:	8d 50 01             	lea    0x1(%eax),%edx
  800a15:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a18:	89 c2                	mov    %eax,%edx
  800a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1d:	01 d0                	add    %edx,%eax
  800a1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a22:	88 10                	mov    %dl,(%eax)
  800a24:	eb 56                	jmp    800a7c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a26:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a2a:	75 1f                	jne    800a4b <readline+0xc5>
  800a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a30:	7e 19                	jle    800a4b <readline+0xc5>
			if (echoing)
  800a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a36:	74 0e                	je     800a46 <readline+0xc0>
				cputchar(c);
  800a38:	83 ec 0c             	sub    $0xc,%esp
  800a3b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a3e:	e8 af 0e 00 00       	call   8018f2 <cputchar>
  800a43:	83 c4 10             	add    $0x10,%esp

			i--;
  800a46:	ff 4d f4             	decl   -0xc(%ebp)
  800a49:	eb 31                	jmp    800a7c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a4b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a4f:	74 0a                	je     800a5b <readline+0xd5>
  800a51:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a55:	0f 85 61 ff ff ff    	jne    8009bc <readline+0x36>
			if (echoing)
  800a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a5f:	74 0e                	je     800a6f <readline+0xe9>
				cputchar(c);
  800a61:	83 ec 0c             	sub    $0xc,%esp
  800a64:	ff 75 ec             	pushl  -0x14(%ebp)
  800a67:	e8 86 0e 00 00       	call   8018f2 <cputchar>
  800a6c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a7a:	eb 06                	jmp    800a82 <readline+0xfc>
		}
	}
  800a7c:	e9 3b ff ff ff       	jmp    8009bc <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a81:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a8a:	e8 de 09 00 00       	call   80146d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a93:	74 13                	je     800aa8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	68 b0 20 80 00       	push   $0x8020b0
  800aa0:	e8 5f f8 ff ff       	call   800304 <cprintf>
  800aa5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800aa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800aaf:	83 ec 0c             	sub    $0xc,%esp
  800ab2:	6a 00                	push   $0x0
  800ab4:	e8 cf 0e 00 00       	call   801988 <iscons>
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800abf:	e8 76 0e 00 00       	call   80193a <getchar>
  800ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800acb:	79 23                	jns    800af0 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800acd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ad1:	74 13                	je     800ae6 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad9:	68 b3 20 80 00       	push   $0x8020b3
  800ade:	e8 21 f8 ff ff       	call   800304 <cprintf>
  800ae3:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ae6:	e8 9c 09 00 00       	call   801487 <sys_enable_interrupt>
			return;
  800aeb:	e9 9a 00 00 00       	jmp    800b8a <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800af0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800af4:	7e 34                	jle    800b2a <atomic_readline+0xa6>
  800af6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800afd:	7f 2b                	jg     800b2a <atomic_readline+0xa6>
			if (echoing)
  800aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b03:	74 0e                	je     800b13 <atomic_readline+0x8f>
				cputchar(c);
  800b05:	83 ec 0c             	sub    $0xc,%esp
  800b08:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0b:	e8 e2 0d 00 00       	call   8018f2 <cputchar>
  800b10:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b16:	8d 50 01             	lea    0x1(%eax),%edx
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	01 d0                	add    %edx,%eax
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
  800b28:	eb 5b                	jmp    800b85 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b2a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b2e:	75 1f                	jne    800b4f <atomic_readline+0xcb>
  800b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b34:	7e 19                	jle    800b4f <atomic_readline+0xcb>
			if (echoing)
  800b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3a:	74 0e                	je     800b4a <atomic_readline+0xc6>
				cputchar(c);
  800b3c:	83 ec 0c             	sub    $0xc,%esp
  800b3f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b42:	e8 ab 0d 00 00       	call   8018f2 <cputchar>
  800b47:	83 c4 10             	add    $0x10,%esp
			i--;
  800b4a:	ff 4d f4             	decl   -0xc(%ebp)
  800b4d:	eb 36                	jmp    800b85 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b4f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b53:	74 0a                	je     800b5f <atomic_readline+0xdb>
  800b55:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b59:	0f 85 60 ff ff ff    	jne    800abf <atomic_readline+0x3b>
			if (echoing)
  800b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b63:	74 0e                	je     800b73 <atomic_readline+0xef>
				cputchar(c);
  800b65:	83 ec 0c             	sub    $0xc,%esp
  800b68:	ff 75 ec             	pushl  -0x14(%ebp)
  800b6b:	e8 82 0d 00 00       	call   8018f2 <cputchar>
  800b70:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	01 d0                	add    %edx,%eax
  800b7b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b7e:	e8 04 09 00 00       	call   801487 <sys_enable_interrupt>
			return;
  800b83:	eb 05                	jmp    800b8a <atomic_readline+0x106>
		}
	}
  800b85:	e9 35 ff ff ff       	jmp    800abf <atomic_readline+0x3b>
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b99:	eb 06                	jmp    800ba1 <strlen+0x15>
		n++;
  800b9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9e:	ff 45 08             	incl   0x8(%ebp)
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	84 c0                	test   %al,%al
  800ba8:	75 f1                	jne    800b9b <strlen+0xf>
		n++;
	return n;
  800baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbc:	eb 09                	jmp    800bc7 <strnlen+0x18>
		n++;
  800bbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc1:	ff 45 08             	incl   0x8(%ebp)
  800bc4:	ff 4d 0c             	decl   0xc(%ebp)
  800bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcb:	74 09                	je     800bd6 <strnlen+0x27>
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 e8                	jne    800bbe <strnlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be7:	90                   	nop
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8d 50 01             	lea    0x1(%eax),%edx
  800bee:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bfa:	8a 12                	mov    (%edx),%dl
  800bfc:	88 10                	mov    %dl,(%eax)
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	84 c0                	test   %al,%al
  800c02:	75 e4                	jne    800be8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 1f                	jmp    800c3d <strncpy+0x34>
		*dst++ = *src;
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8d 50 01             	lea    0x1(%eax),%edx
  800c24:	89 55 08             	mov    %edx,0x8(%ebp)
  800c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2a:	8a 12                	mov    (%edx),%dl
  800c2c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	84 c0                	test   %al,%al
  800c35:	74 03                	je     800c3a <strncpy+0x31>
			src++;
  800c37:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3a:	ff 45 fc             	incl   -0x4(%ebp)
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c43:	72 d9                	jb     800c1e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5a:	74 30                	je     800c8c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c5c:	eb 16                	jmp    800c74 <strlcpy+0x2a>
			*dst++ = *src++;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8d 50 01             	lea    0x1(%eax),%edx
  800c64:	89 55 08             	mov    %edx,0x8(%ebp)
  800c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c70:	8a 12                	mov    (%edx),%dl
  800c72:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c74:	ff 4d 10             	decl   0x10(%ebp)
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 09                	je     800c86 <strlcpy+0x3c>
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	84 c0                	test   %al,%al
  800c84:	75 d8                	jne    800c5e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c92:	29 c2                	sub    %eax,%edx
  800c94:	89 d0                	mov    %edx,%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c9b:	eb 06                	jmp    800ca3 <strcmp+0xb>
		p++, q++;
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	74 0e                	je     800cba <strcmp+0x22>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 10                	mov    (%eax),%dl
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	38 c2                	cmp    %al,%dl
  800cb8:	74 e3                	je     800c9d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	0f b6 d0             	movzbl %al,%edx
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 c0             	movzbl %al,%eax
  800cca:	29 c2                	sub    %eax,%edx
  800ccc:	89 d0                	mov    %edx,%eax
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd3:	eb 09                	jmp    800cde <strncmp+0xe>
		n--, p++, q++;
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 17                	je     800cfb <strncmp+0x2b>
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	74 0e                	je     800cfb <strncmp+0x2b>
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 10                	mov    (%eax),%dl
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	38 c2                	cmp    %al,%dl
  800cf9:	74 da                	je     800cd5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	75 07                	jne    800d08 <strncmp+0x38>
		return 0;
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 14                	jmp    800d1c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	0f b6 d0             	movzbl %al,%edx
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	0f b6 c0             	movzbl %al,%eax
  800d18:	29 c2                	sub    %eax,%edx
  800d1a:	89 d0                	mov    %edx,%eax
}
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 04             	sub    $0x4,%esp
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2a:	eb 12                	jmp    800d3e <strchr+0x20>
		if (*s == c)
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d34:	75 05                	jne    800d3b <strchr+0x1d>
			return (char *) s;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	eb 11                	jmp    800d4c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d3b:	ff 45 08             	incl   0x8(%ebp)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	75 e5                	jne    800d2c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5a:	eb 0d                	jmp    800d69 <strfind+0x1b>
		if (*s == c)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d64:	74 0e                	je     800d74 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d66:	ff 45 08             	incl   0x8(%ebp)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	84 c0                	test   %al,%al
  800d70:	75 ea                	jne    800d5c <strfind+0xe>
  800d72:	eb 01                	jmp    800d75 <strfind+0x27>
		if (*s == c)
			break;
  800d74:	90                   	nop
	return (char *) s;
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d8c:	eb 0e                	jmp    800d9c <memset+0x22>
		*p++ = c;
  800d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d9c:	ff 4d f8             	decl   -0x8(%ebp)
  800d9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da3:	79 e9                	jns    800d8e <memset+0x14>
		*p++ = c;

	return v;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dbc:	eb 16                	jmp    800dd4 <memcpy+0x2a>
		*d++ = *s++;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc1:	8d 50 01             	lea    0x1(%eax),%edx
  800dc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dda:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	75 dd                	jne    800dbe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfe:	73 50                	jae    800e50 <memmove+0x6a>
  800e00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 d0                	add    %edx,%eax
  800e08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0b:	76 43                	jbe    800e50 <memmove+0x6a>
		s += n;
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e19:	eb 10                	jmp    800e2b <memmove+0x45>
			*--d = *--s;
  800e1b:	ff 4d f8             	decl   -0x8(%ebp)
  800e1e:	ff 4d fc             	decl   -0x4(%ebp)
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8a 10                	mov    (%eax),%dl
  800e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e29:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e31:	89 55 10             	mov    %edx,0x10(%ebp)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	75 e3                	jne    800e1b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e38:	eb 23                	jmp    800e5d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3d:	8d 50 01             	lea    0x1(%eax),%edx
  800e40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e49:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4c:	8a 12                	mov    (%edx),%dl
  800e4e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e56:	89 55 10             	mov    %edx,0x10(%ebp)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	75 dd                	jne    800e3a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e74:	eb 2a                	jmp    800ea0 <memcmp+0x3e>
		if (*s1 != *s2)
  800e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e79:	8a 10                	mov    (%eax),%dl
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	38 c2                	cmp    %al,%dl
  800e82:	74 16                	je     800e9a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	0f b6 d0             	movzbl %al,%edx
  800e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	0f b6 c0             	movzbl %al,%eax
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	eb 18                	jmp    800eb2 <memcmp+0x50>
		s1++, s2++;
  800e9a:	ff 45 fc             	incl   -0x4(%ebp)
  800e9d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	75 c9                	jne    800e76 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	01 d0                	add    %edx,%eax
  800ec2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec5:	eb 15                	jmp    800edc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	0f b6 d0             	movzbl %al,%edx
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	0f b6 c0             	movzbl %al,%eax
  800ed5:	39 c2                	cmp    %eax,%edx
  800ed7:	74 0d                	je     800ee6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee2:	72 e3                	jb     800ec7 <memfind+0x13>
  800ee4:	eb 01                	jmp    800ee7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee6:	90                   	nop
	return (void *) s;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f00:	eb 03                	jmp    800f05 <strtol+0x19>
		s++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 20                	cmp    $0x20,%al
  800f0c:	74 f4                	je     800f02 <strtol+0x16>
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3c 09                	cmp    $0x9,%al
  800f15:	74 eb                	je     800f02 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3c 2b                	cmp    $0x2b,%al
  800f1e:	75 05                	jne    800f25 <strtol+0x39>
		s++;
  800f20:	ff 45 08             	incl   0x8(%ebp)
  800f23:	eb 13                	jmp    800f38 <strtol+0x4c>
	else if (*s == '-')
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 2d                	cmp    $0x2d,%al
  800f2c:	75 0a                	jne    800f38 <strtol+0x4c>
		s++, neg = 1;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3c:	74 06                	je     800f44 <strtol+0x58>
  800f3e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f42:	75 20                	jne    800f64 <strtol+0x78>
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 30                	cmp    $0x30,%al
  800f4b:	75 17                	jne    800f64 <strtol+0x78>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	40                   	inc    %eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 78                	cmp    $0x78,%al
  800f55:	75 0d                	jne    800f64 <strtol+0x78>
		s += 2, base = 16;
  800f57:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f5b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f62:	eb 28                	jmp    800f8c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	75 15                	jne    800f7f <strtol+0x93>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 30                	cmp    $0x30,%al
  800f71:	75 0c                	jne    800f7f <strtol+0x93>
		s++, base = 8;
  800f73:	ff 45 08             	incl   0x8(%ebp)
  800f76:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f7d:	eb 0d                	jmp    800f8c <strtol+0xa0>
	else if (base == 0)
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 07                	jne    800f8c <strtol+0xa0>
		base = 10;
  800f85:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2f                	cmp    $0x2f,%al
  800f93:	7e 19                	jle    800fae <strtol+0xc2>
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	3c 39                	cmp    $0x39,%al
  800f9c:	7f 10                	jg     800fae <strtol+0xc2>
			dig = *s - '0';
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	0f be c0             	movsbl %al,%eax
  800fa6:	83 e8 30             	sub    $0x30,%eax
  800fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fac:	eb 42                	jmp    800ff0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 60                	cmp    $0x60,%al
  800fb5:	7e 19                	jle    800fd0 <strtol+0xe4>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 7a                	cmp    $0x7a,%al
  800fbe:	7f 10                	jg     800fd0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f be c0             	movsbl %al,%eax
  800fc8:	83 e8 57             	sub    $0x57,%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 20                	jmp    800ff0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3c 40                	cmp    $0x40,%al
  800fd7:	7e 39                	jle    801012 <strtol+0x126>
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3c 5a                	cmp    $0x5a,%al
  800fe0:	7f 30                	jg     801012 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	0f be c0             	movsbl %al,%eax
  800fea:	83 e8 37             	sub    $0x37,%eax
  800fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff6:	7d 19                	jge    801011 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801002:	89 c2                	mov    %eax,%edx
  801004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80100c:	e9 7b ff ff ff       	jmp    800f8c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801011:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801016:	74 08                	je     801020 <strtol+0x134>
		*endptr = (char *) s;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801020:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801024:	74 07                	je     80102d <strtol+0x141>
  801026:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801029:	f7 d8                	neg    %eax
  80102b:	eb 03                	jmp    801030 <strtol+0x144>
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <ltostr>:

void
ltostr(long value, char *str)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104a:	79 13                	jns    80105f <ltostr+0x2d>
	{
		neg = 1;
  80104c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801059:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80105c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801067:	99                   	cltd   
  801068:	f7 f9                	idiv   %ecx
  80106a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	89 c2                	mov    %eax,%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801080:	83 c2 30             	add    $0x30,%edx
  801083:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801085:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801088:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108d:	f7 e9                	imul   %ecx
  80108f:	c1 fa 02             	sar    $0x2,%edx
  801092:	89 c8                	mov    %ecx,%eax
  801094:	c1 f8 1f             	sar    $0x1f,%eax
  801097:	29 c2                	sub    %eax,%edx
  801099:	89 d0                	mov    %edx,%eax
  80109b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80109e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a6:	f7 e9                	imul   %ecx
  8010a8:	c1 fa 02             	sar    $0x2,%edx
  8010ab:	89 c8                	mov    %ecx,%eax
  8010ad:	c1 f8 1f             	sar    $0x1f,%eax
  8010b0:	29 c2                	sub    %eax,%edx
  8010b2:	89 d0                	mov    %edx,%eax
  8010b4:	c1 e0 02             	shl    $0x2,%eax
  8010b7:	01 d0                	add    %edx,%eax
  8010b9:	01 c0                	add    %eax,%eax
  8010bb:	29 c1                	sub    %eax,%ecx
  8010bd:	89 ca                	mov    %ecx,%edx
  8010bf:	85 d2                	test   %edx,%edx
  8010c1:	75 9c                	jne    80105f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	48                   	dec    %eax
  8010ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d5:	74 3d                	je     801114 <ltostr+0xe2>
		start = 1 ;
  8010d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010de:	eb 34                	jmp    801114 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 c2                	add    %eax,%edx
  8010f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	01 c8                	add    %ecx,%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8a 45 eb             	mov    -0x15(%ebp),%al
  80110c:	88 02                	mov    %al,(%edx)
		start++ ;
  80110e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801111:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801117:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111a:	7c c4                	jl     8010e0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80111c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 d0                	add    %edx,%eax
  801124:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801127:	90                   	nop
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801130:	ff 75 08             	pushl  0x8(%ebp)
  801133:	e8 54 fa ff ff       	call   800b8c <strlen>
  801138:	83 c4 04             	add    $0x4,%esp
  80113b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	e8 46 fa ff ff       	call   800b8c <strlen>
  801146:	83 c4 04             	add    $0x4,%esp
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801153:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115a:	eb 17                	jmp    801173 <strcconcat+0x49>
		final[s] = str1[s] ;
  80115c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 c2                	add    %eax,%edx
  801164:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	01 c8                	add    %ecx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801170:	ff 45 fc             	incl   -0x4(%ebp)
  801173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801176:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801179:	7c e1                	jl     80115c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80117b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801182:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801189:	eb 1f                	jmp    8011aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118e:	8d 50 01             	lea    0x1(%eax),%edx
  801191:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801194:	89 c2                	mov    %eax,%edx
  801196:	8b 45 10             	mov    0x10(%ebp),%eax
  801199:	01 c2                	add    %eax,%edx
  80119b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	01 c8                	add    %ecx,%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a7:	ff 45 f8             	incl   -0x8(%ebp)
  8011aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b0:	7c d9                	jl     80118b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8011bd:	90                   	nop
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cf:	8b 00                	mov    (%eax),%eax
  8011d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e3:	eb 0c                	jmp    8011f1 <strsplit+0x31>
			*string++ = 0;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	84 c0                	test   %al,%al
  8011f8:	74 18                	je     801212 <strsplit+0x52>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	0f be c0             	movsbl %al,%eax
  801202:	50                   	push   %eax
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	e8 13 fb ff ff       	call   800d1e <strchr>
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	75 d3                	jne    8011e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 5a                	je     801275 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80121b:	8b 45 14             	mov    0x14(%ebp),%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	83 f8 0f             	cmp    $0xf,%eax
  801223:	75 07                	jne    80122c <strsplit+0x6c>
		{
			return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb 66                	jmp    801292 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 48 01             	lea    0x1(%eax),%ecx
  801234:	8b 55 14             	mov    0x14(%ebp),%edx
  801237:	89 0a                	mov    %ecx,(%edx)
  801239:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801240:	8b 45 10             	mov    0x10(%ebp),%eax
  801243:	01 c2                	add    %eax,%edx
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124a:	eb 03                	jmp    80124f <strsplit+0x8f>
			string++;
  80124c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	84 c0                	test   %al,%al
  801256:	74 8b                	je     8011e3 <strsplit+0x23>
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f be c0             	movsbl %al,%eax
  801260:	50                   	push   %eax
  801261:	ff 75 0c             	pushl  0xc(%ebp)
  801264:	e8 b5 fa ff ff       	call   800d1e <strchr>
  801269:	83 c4 08             	add    $0x8,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	74 dc                	je     80124c <strsplit+0x8c>
			string++;
	}
  801270:	e9 6e ff ff ff       	jmp    8011e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801275:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	8b 00                	mov    (%eax),%eax
  80127b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	57                   	push   %edi
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
  80129a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012af:	cd 30                	int    $0x30
  8012b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	5b                   	pop    %ebx
  8012bb:	5e                   	pop    %esi
  8012bc:	5f                   	pop    %edi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	52                   	push   %edx
  8012d7:	ff 75 0c             	pushl  0xc(%ebp)
  8012da:	50                   	push   %eax
  8012db:	6a 00                	push   $0x0
  8012dd:	e8 b2 ff ff ff       	call   801294 <syscall>
  8012e2:	83 c4 18             	add    $0x18,%esp
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 01                	push   $0x1
  8012f7:	e8 98 ff ff ff       	call   801294 <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	52                   	push   %edx
  801311:	50                   	push   %eax
  801312:	6a 05                	push   $0x5
  801314:	e8 7b ff ff ff       	call   801294 <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	56                   	push   %esi
  801322:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801323:	8b 75 18             	mov    0x18(%ebp),%esi
  801326:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801329:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
  801334:	51                   	push   %ecx
  801335:	52                   	push   %edx
  801336:	50                   	push   %eax
  801337:	6a 06                	push   $0x6
  801339:	e8 56 ff ff ff       	call   801294 <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	52                   	push   %edx
  801358:	50                   	push   %eax
  801359:	6a 07                	push   $0x7
  80135b:	e8 34 ff ff ff       	call   801294 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	ff 75 08             	pushl  0x8(%ebp)
  801374:	6a 08                	push   $0x8
  801376:	e8 19 ff ff ff       	call   801294 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 09                	push   $0x9
  80138f:	e8 00 ff ff ff       	call   801294 <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 0a                	push   $0xa
  8013a8:	e8 e7 fe ff ff       	call   801294 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 0b                	push   $0xb
  8013c1:	e8 ce fe ff ff       	call   801294 <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	ff 75 0c             	pushl  0xc(%ebp)
  8013d7:	ff 75 08             	pushl  0x8(%ebp)
  8013da:	6a 0f                	push   $0xf
  8013dc:	e8 b3 fe ff ff       	call   801294 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
	return;
  8013e4:	90                   	nop
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	ff 75 08             	pushl  0x8(%ebp)
  8013f6:	6a 10                	push   $0x10
  8013f8:	e8 97 fe ff ff       	call   801294 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801400:	90                   	nop
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	ff 75 10             	pushl  0x10(%ebp)
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	ff 75 08             	pushl  0x8(%ebp)
  801413:	6a 11                	push   $0x11
  801415:	e8 7a fe ff ff       	call   801294 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
	return ;
  80141d:	90                   	nop
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 0c                	push   $0xc
  80142f:	e8 60 fe ff ff       	call   801294 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	ff 75 08             	pushl  0x8(%ebp)
  801447:	6a 0d                	push   $0xd
  801449:	e8 46 fe ff ff       	call   801294 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 0e                	push   $0xe
  801462:	e8 2d fe ff ff       	call   801294 <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
}
  80146a:	90                   	nop
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 13                	push   $0x13
  80147c:	e8 13 fe ff ff       	call   801294 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	90                   	nop
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 14                	push   $0x14
  801496:	e8 f9 fd ff ff       	call   801294 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	50                   	push   %eax
  8014ba:	6a 15                	push   $0x15
  8014bc:	e8 d3 fd ff ff       	call   801294 <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	90                   	nop
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 16                	push   $0x16
  8014d6:	e8 b9 fd ff ff       	call   801294 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	90                   	nop
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	ff 75 0c             	pushl  0xc(%ebp)
  8014f0:	50                   	push   %eax
  8014f1:	6a 17                	push   $0x17
  8014f3:	e8 9c fd ff ff       	call   801294 <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801500:	8b 55 0c             	mov    0xc(%ebp),%edx
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	52                   	push   %edx
  80150d:	50                   	push   %eax
  80150e:	6a 1a                	push   $0x1a
  801510:	e8 7f fd ff ff       	call   801294 <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80151d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	52                   	push   %edx
  80152a:	50                   	push   %eax
  80152b:	6a 18                	push   $0x18
  80152d:	e8 62 fd ff ff       	call   801294 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	90                   	nop
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80153b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	6a 19                	push   $0x19
  80154b:	e8 44 fd ff ff       	call   801294 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	90                   	nop
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801562:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801565:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	6a 00                	push   $0x0
  80156e:	51                   	push   %ecx
  80156f:	52                   	push   %edx
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	50                   	push   %eax
  801574:	6a 1b                	push   $0x1b
  801576:	e8 19 fd ff ff       	call   801294 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801583:	8b 55 0c             	mov    0xc(%ebp),%edx
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	52                   	push   %edx
  801590:	50                   	push   %eax
  801591:	6a 1c                	push   $0x1c
  801593:	e8 fc fc ff ff       	call   801294 <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	51                   	push   %ecx
  8015ae:	52                   	push   %edx
  8015af:	50                   	push   %eax
  8015b0:	6a 1d                	push   $0x1d
  8015b2:	e8 dd fc ff ff       	call   801294 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	6a 1e                	push   $0x1e
  8015cf:	e8 c0 fc ff ff       	call   801294 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 1f                	push   $0x1f
  8015e8:	e8 a7 fc ff ff       	call   801294 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	6a 00                	push   $0x0
  8015fa:	ff 75 14             	pushl  0x14(%ebp)
  8015fd:	ff 75 10             	pushl  0x10(%ebp)
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	50                   	push   %eax
  801604:	6a 20                	push   $0x20
  801606:	e8 89 fc ff ff       	call   801294 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	50                   	push   %eax
  80161f:	6a 21                	push   $0x21
  801621:	e8 6e fc ff ff       	call   801294 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	50                   	push   %eax
  80163b:	6a 22                	push   $0x22
  80163d:	e8 52 fc ff ff       	call   801294 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 02                	push   $0x2
  801656:	e8 39 fc ff ff       	call   801294 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 03                	push   $0x3
  80166f:	e8 20 fc ff ff       	call   801294 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 04                	push   $0x4
  801688:	e8 07 fc ff ff       	call   801294 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_exit_env>:


void sys_exit_env(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 23                	push   $0x23
  8016a1:	e8 ee fb ff ff       	call   801294 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b5:	8d 50 04             	lea    0x4(%eax),%edx
  8016b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	52                   	push   %edx
  8016c2:	50                   	push   %eax
  8016c3:	6a 24                	push   $0x24
  8016c5:	e8 ca fb ff ff       	call   801294 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
	return result;
  8016cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d6:	89 01                	mov    %eax,(%ecx)
  8016d8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	c9                   	leave  
  8016df:	c2 04 00             	ret    $0x4

008016e2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	ff 75 10             	pushl  0x10(%ebp)
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	6a 12                	push   $0x12
  8016f4:	e8 9b fb ff ff       	call   801294 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fc:	90                   	nop
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_rcr2>:
uint32 sys_rcr2()
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 25                	push   $0x25
  80170e:	e8 81 fb ff ff       	call   801294 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801724:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	50                   	push   %eax
  801731:	6a 26                	push   $0x26
  801733:	e8 5c fb ff ff       	call   801294 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return ;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <rsttst>:
void rsttst()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 28                	push   $0x28
  80174d:	e8 42 fb ff ff       	call   801294 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
	return ;
  801755:	90                   	nop
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	8b 45 14             	mov    0x14(%ebp),%eax
  801761:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801764:	8b 55 18             	mov    0x18(%ebp),%edx
  801767:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80176b:	52                   	push   %edx
  80176c:	50                   	push   %eax
  80176d:	ff 75 10             	pushl  0x10(%ebp)
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 27                	push   $0x27
  801778:	e8 17 fb ff ff       	call   801294 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
	return ;
  801780:	90                   	nop
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <chktst>:
void chktst(uint32 n)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	6a 29                	push   $0x29
  801793:	e8 fc fa ff ff       	call   801294 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
	return ;
  80179b:	90                   	nop
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <inctst>:

void inctst()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 2a                	push   $0x2a
  8017ad:	e8 e2 fa ff ff       	call   801294 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b5:	90                   	nop
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <gettst>:
uint32 gettst()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 2b                	push   $0x2b
  8017c7:	e8 c8 fa ff ff       	call   801294 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 2c                	push   $0x2c
  8017e3:	e8 ac fa ff ff       	call   801294 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
  8017eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017f2:	75 07                	jne    8017fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f9:	eb 05                	jmp    801800 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 2c                	push   $0x2c
  801814:	e8 7b fa ff ff       	call   801294 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
  80181c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80181f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801823:	75 07                	jne    80182c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801825:	b8 01 00 00 00       	mov    $0x1,%eax
  80182a:	eb 05                	jmp    801831 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 2c                	push   $0x2c
  801845:	e8 4a fa ff ff       	call   801294 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
  80184d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801850:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801854:	75 07                	jne    80185d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801856:	b8 01 00 00 00       	mov    $0x1,%eax
  80185b:	eb 05                	jmp    801862 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 2c                	push   $0x2c
  801876:	e8 19 fa ff ff       	call   801294 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
  80187e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801881:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801885:	75 07                	jne    80188e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801887:	b8 01 00 00 00       	mov    $0x1,%eax
  80188c:	eb 05                	jmp    801893 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	6a 2d                	push   $0x2d
  8018a5:	e8 ea f9 ff ff       	call   801294 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ad:	90                   	nop
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	53                   	push   %ebx
  8018c3:	51                   	push   %ecx
  8018c4:	52                   	push   %edx
  8018c5:	50                   	push   %eax
  8018c6:	6a 2e                	push   $0x2e
  8018c8:	e8 c7 f9 ff ff       	call   801294 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 2f                	push   $0x2f
  8018e8:	e8 a7 f9 ff ff       	call   801294 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018fe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	50                   	push   %eax
  801906:	e8 96 fb ff ff       	call   8014a1 <sys_cputc>
  80190b:	83 c4 10             	add    $0x10,%esp
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801917:	e8 51 fb ff ff       	call   80146d <sys_disable_interrupt>
	char c = ch;
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801922:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801926:	83 ec 0c             	sub    $0xc,%esp
  801929:	50                   	push   %eax
  80192a:	e8 72 fb ff ff       	call   8014a1 <sys_cputc>
  80192f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801932:	e8 50 fb ff ff       	call   801487 <sys_enable_interrupt>
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <getchar>:

int
getchar(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801947:	eb 08                	jmp    801951 <getchar+0x17>
	{
		c = sys_cgetc();
  801949:	e8 9a f9 ff ff       	call   8012e8 <sys_cgetc>
  80194e:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801955:	74 f2                	je     801949 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801957:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <atomic_getchar>:

int
atomic_getchar(void)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801962:	e8 06 fb ff ff       	call   80146d <sys_disable_interrupt>
	int c=0;
  801967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80196e:	eb 08                	jmp    801978 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801970:	e8 73 f9 ff ff       	call   8012e8 <sys_cgetc>
  801975:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197c:	74 f2                	je     801970 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80197e:	e8 04 fb ff ff       	call   801487 <sys_enable_interrupt>
	return c;
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <iscons>:

int iscons(int fdnum)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80198b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801990:	5d                   	pop    %ebp
  801991:	c3                   	ret    
  801992:	66 90                	xchg   %ax,%ax

00801994 <__udivdi3>:
  801994:	55                   	push   %ebp
  801995:	57                   	push   %edi
  801996:	56                   	push   %esi
  801997:	53                   	push   %ebx
  801998:	83 ec 1c             	sub    $0x1c,%esp
  80199b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80199f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ab:	89 ca                	mov    %ecx,%edx
  8019ad:	89 f8                	mov    %edi,%eax
  8019af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019b3:	85 f6                	test   %esi,%esi
  8019b5:	75 2d                	jne    8019e4 <__udivdi3+0x50>
  8019b7:	39 cf                	cmp    %ecx,%edi
  8019b9:	77 65                	ja     801a20 <__udivdi3+0x8c>
  8019bb:	89 fd                	mov    %edi,%ebp
  8019bd:	85 ff                	test   %edi,%edi
  8019bf:	75 0b                	jne    8019cc <__udivdi3+0x38>
  8019c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c6:	31 d2                	xor    %edx,%edx
  8019c8:	f7 f7                	div    %edi
  8019ca:	89 c5                	mov    %eax,%ebp
  8019cc:	31 d2                	xor    %edx,%edx
  8019ce:	89 c8                	mov    %ecx,%eax
  8019d0:	f7 f5                	div    %ebp
  8019d2:	89 c1                	mov    %eax,%ecx
  8019d4:	89 d8                	mov    %ebx,%eax
  8019d6:	f7 f5                	div    %ebp
  8019d8:	89 cf                	mov    %ecx,%edi
  8019da:	89 fa                	mov    %edi,%edx
  8019dc:	83 c4 1c             	add    $0x1c,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    
  8019e4:	39 ce                	cmp    %ecx,%esi
  8019e6:	77 28                	ja     801a10 <__udivdi3+0x7c>
  8019e8:	0f bd fe             	bsr    %esi,%edi
  8019eb:	83 f7 1f             	xor    $0x1f,%edi
  8019ee:	75 40                	jne    801a30 <__udivdi3+0x9c>
  8019f0:	39 ce                	cmp    %ecx,%esi
  8019f2:	72 0a                	jb     8019fe <__udivdi3+0x6a>
  8019f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f8:	0f 87 9e 00 00 00    	ja     801a9c <__udivdi3+0x108>
  8019fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801a03:	89 fa                	mov    %edi,%edx
  801a05:	83 c4 1c             	add    $0x1c,%esp
  801a08:	5b                   	pop    %ebx
  801a09:	5e                   	pop    %esi
  801a0a:	5f                   	pop    %edi
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    
  801a0d:	8d 76 00             	lea    0x0(%esi),%esi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	31 c0                	xor    %eax,%eax
  801a14:	89 fa                	mov    %edi,%edx
  801a16:	83 c4 1c             	add    $0x1c,%esp
  801a19:	5b                   	pop    %ebx
  801a1a:	5e                   	pop    %esi
  801a1b:	5f                   	pop    %edi
  801a1c:	5d                   	pop    %ebp
  801a1d:	c3                   	ret    
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	89 d8                	mov    %ebx,%eax
  801a22:	f7 f7                	div    %edi
  801a24:	31 ff                	xor    %edi,%edi
  801a26:	89 fa                	mov    %edi,%edx
  801a28:	83 c4 1c             	add    $0x1c,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    
  801a30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a35:	89 eb                	mov    %ebp,%ebx
  801a37:	29 fb                	sub    %edi,%ebx
  801a39:	89 f9                	mov    %edi,%ecx
  801a3b:	d3 e6                	shl    %cl,%esi
  801a3d:	89 c5                	mov    %eax,%ebp
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ed                	shr    %cl,%ebp
  801a43:	89 e9                	mov    %ebp,%ecx
  801a45:	09 f1                	or     %esi,%ecx
  801a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a4b:	89 f9                	mov    %edi,%ecx
  801a4d:	d3 e0                	shl    %cl,%eax
  801a4f:	89 c5                	mov    %eax,%ebp
  801a51:	89 d6                	mov    %edx,%esi
  801a53:	88 d9                	mov    %bl,%cl
  801a55:	d3 ee                	shr    %cl,%esi
  801a57:	89 f9                	mov    %edi,%ecx
  801a59:	d3 e2                	shl    %cl,%edx
  801a5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 e8                	shr    %cl,%eax
  801a63:	09 c2                	or     %eax,%edx
  801a65:	89 d0                	mov    %edx,%eax
  801a67:	89 f2                	mov    %esi,%edx
  801a69:	f7 74 24 0c          	divl   0xc(%esp)
  801a6d:	89 d6                	mov    %edx,%esi
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	f7 e5                	mul    %ebp
  801a73:	39 d6                	cmp    %edx,%esi
  801a75:	72 19                	jb     801a90 <__udivdi3+0xfc>
  801a77:	74 0b                	je     801a84 <__udivdi3+0xf0>
  801a79:	89 d8                	mov    %ebx,%eax
  801a7b:	31 ff                	xor    %edi,%edi
  801a7d:	e9 58 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801a82:	66 90                	xchg   %ax,%ax
  801a84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a88:	89 f9                	mov    %edi,%ecx
  801a8a:	d3 e2                	shl    %cl,%edx
  801a8c:	39 c2                	cmp    %eax,%edx
  801a8e:	73 e9                	jae    801a79 <__udivdi3+0xe5>
  801a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a93:	31 ff                	xor    %edi,%edi
  801a95:	e9 40 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	31 c0                	xor    %eax,%eax
  801a9e:	e9 37 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801aa3:	90                   	nop

00801aa4 <__umoddi3>:
  801aa4:	55                   	push   %ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 1c             	sub    $0x1c,%esp
  801aab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ac3:	89 f3                	mov    %esi,%ebx
  801ac5:	89 fa                	mov    %edi,%edx
  801ac7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801acb:	89 34 24             	mov    %esi,(%esp)
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	75 1a                	jne    801aec <__umoddi3+0x48>
  801ad2:	39 f7                	cmp    %esi,%edi
  801ad4:	0f 86 a2 00 00 00    	jbe    801b7c <__umoddi3+0xd8>
  801ada:	89 c8                	mov    %ecx,%eax
  801adc:	89 f2                	mov    %esi,%edx
  801ade:	f7 f7                	div    %edi
  801ae0:	89 d0                	mov    %edx,%eax
  801ae2:	31 d2                	xor    %edx,%edx
  801ae4:	83 c4 1c             	add    $0x1c,%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5f                   	pop    %edi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    
  801aec:	39 f0                	cmp    %esi,%eax
  801aee:	0f 87 ac 00 00 00    	ja     801ba0 <__umoddi3+0xfc>
  801af4:	0f bd e8             	bsr    %eax,%ebp
  801af7:	83 f5 1f             	xor    $0x1f,%ebp
  801afa:	0f 84 ac 00 00 00    	je     801bac <__umoddi3+0x108>
  801b00:	bf 20 00 00 00       	mov    $0x20,%edi
  801b05:	29 ef                	sub    %ebp,%edi
  801b07:	89 fe                	mov    %edi,%esi
  801b09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b0d:	89 e9                	mov    %ebp,%ecx
  801b0f:	d3 e0                	shl    %cl,%eax
  801b11:	89 d7                	mov    %edx,%edi
  801b13:	89 f1                	mov    %esi,%ecx
  801b15:	d3 ef                	shr    %cl,%edi
  801b17:	09 c7                	or     %eax,%edi
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 e2                	shl    %cl,%edx
  801b1d:	89 14 24             	mov    %edx,(%esp)
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	d3 e0                	shl    %cl,%eax
  801b24:	89 c2                	mov    %eax,%edx
  801b26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2a:	d3 e0                	shl    %cl,%eax
  801b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b34:	89 f1                	mov    %esi,%ecx
  801b36:	d3 e8                	shr    %cl,%eax
  801b38:	09 d0                	or     %edx,%eax
  801b3a:	d3 eb                	shr    %cl,%ebx
  801b3c:	89 da                	mov    %ebx,%edx
  801b3e:	f7 f7                	div    %edi
  801b40:	89 d3                	mov    %edx,%ebx
  801b42:	f7 24 24             	mull   (%esp)
  801b45:	89 c6                	mov    %eax,%esi
  801b47:	89 d1                	mov    %edx,%ecx
  801b49:	39 d3                	cmp    %edx,%ebx
  801b4b:	0f 82 87 00 00 00    	jb     801bd8 <__umoddi3+0x134>
  801b51:	0f 84 91 00 00 00    	je     801be8 <__umoddi3+0x144>
  801b57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b5b:	29 f2                	sub    %esi,%edx
  801b5d:	19 cb                	sbb    %ecx,%ebx
  801b5f:	89 d8                	mov    %ebx,%eax
  801b61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b65:	d3 e0                	shl    %cl,%eax
  801b67:	89 e9                	mov    %ebp,%ecx
  801b69:	d3 ea                	shr    %cl,%edx
  801b6b:	09 d0                	or     %edx,%eax
  801b6d:	89 e9                	mov    %ebp,%ecx
  801b6f:	d3 eb                	shr    %cl,%ebx
  801b71:	89 da                	mov    %ebx,%edx
  801b73:	83 c4 1c             	add    $0x1c,%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5f                   	pop    %edi
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    
  801b7b:	90                   	nop
  801b7c:	89 fd                	mov    %edi,%ebp
  801b7e:	85 ff                	test   %edi,%edi
  801b80:	75 0b                	jne    801b8d <__umoddi3+0xe9>
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
  801b87:	31 d2                	xor    %edx,%edx
  801b89:	f7 f7                	div    %edi
  801b8b:	89 c5                	mov    %eax,%ebp
  801b8d:	89 f0                	mov    %esi,%eax
  801b8f:	31 d2                	xor    %edx,%edx
  801b91:	f7 f5                	div    %ebp
  801b93:	89 c8                	mov    %ecx,%eax
  801b95:	f7 f5                	div    %ebp
  801b97:	89 d0                	mov    %edx,%eax
  801b99:	e9 44 ff ff ff       	jmp    801ae2 <__umoddi3+0x3e>
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	89 c8                	mov    %ecx,%eax
  801ba2:	89 f2                	mov    %esi,%edx
  801ba4:	83 c4 1c             	add    $0x1c,%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
  801bac:	3b 04 24             	cmp    (%esp),%eax
  801baf:	72 06                	jb     801bb7 <__umoddi3+0x113>
  801bb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb5:	77 0f                	ja     801bc6 <__umoddi3+0x122>
  801bb7:	89 f2                	mov    %esi,%edx
  801bb9:	29 f9                	sub    %edi,%ecx
  801bbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bbf:	89 14 24             	mov    %edx,(%esp)
  801bc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bca:	8b 14 24             	mov    (%esp),%edx
  801bcd:	83 c4 1c             	add    $0x1c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    
  801bd5:	8d 76 00             	lea    0x0(%esi),%esi
  801bd8:	2b 04 24             	sub    (%esp),%eax
  801bdb:	19 fa                	sbb    %edi,%edx
  801bdd:	89 d1                	mov    %edx,%ecx
  801bdf:	89 c6                	mov    %eax,%esi
  801be1:	e9 71 ff ff ff       	jmp    801b57 <__umoddi3+0xb3>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bec:	72 ea                	jb     801bd8 <__umoddi3+0x134>
  801bee:	89 d9                	mov    %ebx,%ecx
  801bf0:	e9 62 ff ff ff       	jmp    801b57 <__umoddi3+0xb3>
