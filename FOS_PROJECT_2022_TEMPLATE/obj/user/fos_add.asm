
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 60 00 00 00       	call   800096 <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i1=0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 20 19 80 00       	push   $0x801920
  800058:	e8 3e 0c 00 00       	call   800c9b <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 22 19 80 00       	push   $0x801922
  80006f:	e8 27 0c 00 00       	call   800c9b <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 24 19 80 00       	push   $0x801924
  80008b:	e8 56 02 00 00       	call   8002e6 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");
	return;
  800093:	90                   	nop
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80009c:	e8 6e 13 00 00       	call   80140f <sys_getenvindex>
  8000a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a7:	89 d0                	mov    %edx,%eax
  8000a9:	01 c0                	add    %eax,%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000b4:	01 c8                	add    %ecx,%eax
  8000b6:	c1 e0 02             	shl    $0x2,%eax
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000c2:	01 c8                	add    %ecx,%eax
  8000c4:	c1 e0 02             	shl    $0x2,%eax
  8000c7:	01 d0                	add    %edx,%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	01 d0                	add    %edx,%eax
  8000ce:	c1 e0 03             	shl    $0x3,%eax
  8000d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d6:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000db:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e0:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000e6:	84 c0                	test   %al,%al
  8000e8:	74 0f                	je     8000f9 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000ea:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ef:	05 18 da 01 00       	add    $0x1da18,%eax
  8000f4:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000fd:	7e 0a                	jle    800109 <libmain+0x73>
		binaryname = argv[0];
  8000ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800102:	8b 00                	mov    (%eax),%eax
  800104:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	ff 75 0c             	pushl  0xc(%ebp)
  80010f:	ff 75 08             	pushl  0x8(%ebp)
  800112:	e8 21 ff ff ff       	call   800038 <_main>
  800117:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80011a:	e8 fd 10 00 00       	call   80121c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 58 19 80 00       	push   $0x801958
  800127:	e8 8d 01 00 00       	call   8002b9 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80012f:	a1 20 20 80 00       	mov    0x802020,%eax
  800134:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80013a:	a1 20 20 80 00       	mov    0x802020,%eax
  80013f:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	52                   	push   %edx
  800149:	50                   	push   %eax
  80014a:	68 80 19 80 00       	push   $0x801980
  80014f:	e8 65 01 00 00       	call   8002b9 <cprintf>
  800154:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800157:	a1 20 20 80 00       	mov    0x802020,%eax
  80015c:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800162:	a1 20 20 80 00       	mov    0x802020,%eax
  800167:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80016d:	a1 20 20 80 00       	mov    0x802020,%eax
  800172:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800178:	51                   	push   %ecx
  800179:	52                   	push   %edx
  80017a:	50                   	push   %eax
  80017b:	68 a8 19 80 00       	push   $0x8019a8
  800180:	e8 34 01 00 00       	call   8002b9 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800188:	a1 20 20 80 00       	mov    0x802020,%eax
  80018d:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	50                   	push   %eax
  800197:	68 00 1a 80 00       	push   $0x801a00
  80019c:	e8 18 01 00 00       	call   8002b9 <cprintf>
  8001a1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	68 58 19 80 00       	push   $0x801958
  8001ac:	e8 08 01 00 00       	call   8002b9 <cprintf>
  8001b1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001b4:	e8 7d 10 00 00       	call   801236 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001b9:	e8 19 00 00 00       	call   8001d7 <exit>
}
  8001be:	90                   	nop
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	6a 00                	push   $0x0
  8001cc:	e8 0a 12 00 00       	call   8013db <sys_destroy_env>
  8001d1:	83 c4 10             	add    $0x10,%esp
}
  8001d4:	90                   	nop
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <exit>:

void
exit(void)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001dd:	e8 5f 12 00 00       	call   801441 <sys_exit_env>
}
  8001e2:	90                   	nop
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f6:	89 0a                	mov    %ecx,(%edx)
  8001f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fb:	88 d1                	mov    %dl,%cl
  8001fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800200:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	8b 00                	mov    (%eax),%eax
  800209:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020e:	75 2c                	jne    80023c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800210:	a0 24 20 80 00       	mov    0x802024,%al
  800215:	0f b6 c0             	movzbl %al,%eax
  800218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021b:	8b 12                	mov    (%edx),%edx
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800222:	83 c2 08             	add    $0x8,%edx
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	50                   	push   %eax
  800229:	51                   	push   %ecx
  80022a:	52                   	push   %edx
  80022b:	e8 3e 0e 00 00       	call   80106e <sys_cputs>
  800230:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800233:	8b 45 0c             	mov    0xc(%ebp),%eax
  800236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80023c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023f:	8b 40 04             	mov    0x4(%eax),%eax
  800242:	8d 50 01             	lea    0x1(%eax),%edx
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	89 50 04             	mov    %edx,0x4(%eax)
}
  80024b:	90                   	nop
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800257:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025e:	00 00 00 
	b.cnt = 0;
  800261:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800268:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800277:	50                   	push   %eax
  800278:	68 e5 01 80 00       	push   $0x8001e5
  80027d:	e8 11 02 00 00       	call   800493 <vprintfmt>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800285:	a0 24 20 80 00       	mov    0x802024,%al
  80028a:	0f b6 c0             	movzbl %al,%eax
  80028d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	50                   	push   %eax
  800297:	52                   	push   %edx
  800298:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029e:	83 c0 08             	add    $0x8,%eax
  8002a1:	50                   	push   %eax
  8002a2:	e8 c7 0d 00 00       	call   80106e <sys_cputs>
  8002a7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002aa:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002bf:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d5:	50                   	push   %eax
  8002d6:	e8 73 ff ff ff       	call   80024e <vcprintf>
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002ec:	e8 2b 0f 00 00       	call   80121c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800300:	50                   	push   %eax
  800301:	e8 48 ff ff ff       	call   80024e <vcprintf>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80030c:	e8 25 0f 00 00       	call   801236 <sys_enable_interrupt>
	return cnt;
  800311:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	53                   	push   %ebx
  80031a:	83 ec 14             	sub    $0x14,%esp
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800323:	8b 45 14             	mov    0x14(%ebp),%eax
  800326:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800329:	8b 45 18             	mov    0x18(%ebp),%eax
  80032c:	ba 00 00 00 00       	mov    $0x0,%edx
  800331:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800334:	77 55                	ja     80038b <printnum+0x75>
  800336:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800339:	72 05                	jb     800340 <printnum+0x2a>
  80033b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033e:	77 4b                	ja     80038b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800340:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800343:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800346:	8b 45 18             	mov    0x18(%ebp),%eax
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	52                   	push   %edx
  80034f:	50                   	push   %eax
  800350:	ff 75 f4             	pushl  -0xc(%ebp)
  800353:	ff 75 f0             	pushl  -0x10(%ebp)
  800356:	e8 49 13 00 00       	call   8016a4 <__udivdi3>
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	ff 75 20             	pushl  0x20(%ebp)
  800364:	53                   	push   %ebx
  800365:	ff 75 18             	pushl  0x18(%ebp)
  800368:	52                   	push   %edx
  800369:	50                   	push   %eax
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	e8 a1 ff ff ff       	call   800316 <printnum>
  800375:	83 c4 20             	add    $0x20,%esp
  800378:	eb 1a                	jmp    800394 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 0c             	pushl  0xc(%ebp)
  800380:	ff 75 20             	pushl  0x20(%ebp)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	ff d0                	call   *%eax
  800388:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038b:	ff 4d 1c             	decl   0x1c(%ebp)
  80038e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800392:	7f e6                	jg     80037a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800394:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800397:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a2:	53                   	push   %ebx
  8003a3:	51                   	push   %ecx
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	e8 09 14 00 00       	call   8017b4 <__umoddi3>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	05 34 1c 80 00       	add    $0x801c34,%eax
  8003b3:	8a 00                	mov    (%eax),%al
  8003b5:	0f be c0             	movsbl %al,%eax
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	ff 75 0c             	pushl  0xc(%ebp)
  8003be:	50                   	push   %eax
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	ff d0                	call   *%eax
  8003c4:	83 c4 10             	add    $0x10,%esp
}
  8003c7:	90                   	nop
  8003c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d4:	7e 1c                	jle    8003f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	8d 50 08             	lea    0x8(%eax),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 10                	mov    %edx,(%eax)
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	83 e8 08             	sub    $0x8,%eax
  8003eb:	8b 50 04             	mov    0x4(%eax),%edx
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	eb 40                	jmp    800432 <getuint+0x65>
	else if (lflag)
  8003f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f6:	74 1e                	je     800416 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	8d 50 04             	lea    0x4(%eax),%edx
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	89 10                	mov    %edx,(%eax)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	83 e8 04             	sub    $0x4,%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	ba 00 00 00 00       	mov    $0x0,%edx
  800414:	eb 1c                	jmp    800432 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	8d 50 04             	lea    0x4(%eax),%edx
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	89 10                	mov    %edx,(%eax)
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	83 e8 04             	sub    $0x4,%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800432:	5d                   	pop    %ebp
  800433:	c3                   	ret    

00800434 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800437:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80043b:	7e 1c                	jle    800459 <getint+0x25>
		return va_arg(*ap, long long);
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 08             	lea    0x8(%eax),%edx
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	83 e8 08             	sub    $0x8,%eax
  800452:	8b 50 04             	mov    0x4(%eax),%edx
  800455:	8b 00                	mov    (%eax),%eax
  800457:	eb 38                	jmp    800491 <getint+0x5d>
	else if (lflag)
  800459:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80045d:	74 1a                	je     800479 <getint+0x45>
		return va_arg(*ap, long);
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 04             	lea    0x4(%eax),%edx
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	83 e8 04             	sub    $0x4,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	99                   	cltd   
  800477:	eb 18                	jmp    800491 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	8d 50 04             	lea    0x4(%eax),%edx
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	89 10                	mov    %edx,(%eax)
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	83 e8 04             	sub    $0x4,%eax
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	99                   	cltd   
}
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    

00800493 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	56                   	push   %esi
  800497:	53                   	push   %ebx
  800498:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049b:	eb 17                	jmp    8004b4 <vprintfmt+0x21>
			if (ch == '\0')
  80049d:	85 db                	test   %ebx,%ebx
  80049f:	0f 84 af 03 00 00    	je     800854 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	ff 75 0c             	pushl  0xc(%ebp)
  8004ab:	53                   	push   %ebx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	ff d0                	call   *%eax
  8004b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b7:	8d 50 01             	lea    0x1(%eax),%edx
  8004ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8004bd:	8a 00                	mov    (%eax),%al
  8004bf:	0f b6 d8             	movzbl %al,%ebx
  8004c2:	83 fb 25             	cmp    $0x25,%ebx
  8004c5:	75 d6                	jne    80049d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ea:	8d 50 01             	lea    0x1(%eax),%edx
  8004ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f0:	8a 00                	mov    (%eax),%al
  8004f2:	0f b6 d8             	movzbl %al,%ebx
  8004f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f8:	83 f8 55             	cmp    $0x55,%eax
  8004fb:	0f 87 2b 03 00 00    	ja     80082c <vprintfmt+0x399>
  800501:	8b 04 85 58 1c 80 00 	mov    0x801c58(,%eax,4),%eax
  800508:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80050a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80050e:	eb d7                	jmp    8004e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800510:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800514:	eb d1                	jmp    8004e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800516:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80051d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	c1 e0 02             	shl    $0x2,%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	01 c0                	add    %eax,%eax
  800529:	01 d8                	add    %ebx,%eax
  80052b:	83 e8 30             	sub    $0x30,%eax
  80052e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800531:	8b 45 10             	mov    0x10(%ebp),%eax
  800534:	8a 00                	mov    (%eax),%al
  800536:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800539:	83 fb 2f             	cmp    $0x2f,%ebx
  80053c:	7e 3e                	jle    80057c <vprintfmt+0xe9>
  80053e:	83 fb 39             	cmp    $0x39,%ebx
  800541:	7f 39                	jg     80057c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800543:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800546:	eb d5                	jmp    80051d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	83 c0 04             	add    $0x4,%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 e8 04             	sub    $0x4,%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80055c:	eb 1f                	jmp    80057d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80055e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800562:	79 83                	jns    8004e7 <vprintfmt+0x54>
				width = 0;
  800564:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80056b:	e9 77 ff ff ff       	jmp    8004e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800570:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800577:	e9 6b ff ff ff       	jmp    8004e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80057c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80057d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800581:	0f 89 60 ff ff ff    	jns    8004e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800594:	e9 4e ff ff ff       	jmp    8004e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800599:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80059c:	e9 46 ff ff ff       	jmp    8004e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	83 c0 04             	add    $0x4,%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	83 e8 04             	sub    $0x4,%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 0c             	pushl  0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	ff d0                	call   *%eax
  8005be:	83 c4 10             	add    $0x10,%esp
			break;
  8005c1:	e9 89 02 00 00       	jmp    80084f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	83 c0 04             	add    $0x4,%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	83 e8 04             	sub    $0x4,%eax
  8005d5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005d7:	85 db                	test   %ebx,%ebx
  8005d9:	79 02                	jns    8005dd <vprintfmt+0x14a>
				err = -err;
  8005db:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005dd:	83 fb 64             	cmp    $0x64,%ebx
  8005e0:	7f 0b                	jg     8005ed <vprintfmt+0x15a>
  8005e2:	8b 34 9d a0 1a 80 00 	mov    0x801aa0(,%ebx,4),%esi
  8005e9:	85 f6                	test   %esi,%esi
  8005eb:	75 19                	jne    800606 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ed:	53                   	push   %ebx
  8005ee:	68 45 1c 80 00       	push   $0x801c45
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 5e 02 00 00       	call   80085c <printfmt>
  8005fe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800601:	e9 49 02 00 00       	jmp    80084f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800606:	56                   	push   %esi
  800607:	68 4e 1c 80 00       	push   $0x801c4e
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	ff 75 08             	pushl  0x8(%ebp)
  800612:	e8 45 02 00 00       	call   80085c <printfmt>
  800617:	83 c4 10             	add    $0x10,%esp
			break;
  80061a:	e9 30 02 00 00       	jmp    80084f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	83 c0 04             	add    $0x4,%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 e8 04             	sub    $0x4,%eax
  80062e:	8b 30                	mov    (%eax),%esi
  800630:	85 f6                	test   %esi,%esi
  800632:	75 05                	jne    800639 <vprintfmt+0x1a6>
				p = "(null)";
  800634:	be 51 1c 80 00       	mov    $0x801c51,%esi
			if (width > 0 && padc != '-')
  800639:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063d:	7e 6d                	jle    8006ac <vprintfmt+0x219>
  80063f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800643:	74 67                	je     8006ac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	50                   	push   %eax
  80064c:	56                   	push   %esi
  80064d:	e8 0c 03 00 00       	call   80095e <strnlen>
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800658:	eb 16                	jmp    800670 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80065a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	50                   	push   %eax
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	ff d0                	call   *%eax
  80066a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80066d:	ff 4d e4             	decl   -0x1c(%ebp)
  800670:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800674:	7f e4                	jg     80065a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800676:	eb 34                	jmp    8006ac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800678:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067c:	74 1c                	je     80069a <vprintfmt+0x207>
  80067e:	83 fb 1f             	cmp    $0x1f,%ebx
  800681:	7e 05                	jle    800688 <vprintfmt+0x1f5>
  800683:	83 fb 7e             	cmp    $0x7e,%ebx
  800686:	7e 12                	jle    80069a <vprintfmt+0x207>
					putch('?', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	6a 3f                	push   $0x3f
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	ff d0                	call   *%eax
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	eb 0f                	jmp    8006a9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	53                   	push   %ebx
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	ff d0                	call   *%eax
  8006a6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a9:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ac:	89 f0                	mov    %esi,%eax
  8006ae:	8d 70 01             	lea    0x1(%eax),%esi
  8006b1:	8a 00                	mov    (%eax),%al
  8006b3:	0f be d8             	movsbl %al,%ebx
  8006b6:	85 db                	test   %ebx,%ebx
  8006b8:	74 24                	je     8006de <vprintfmt+0x24b>
  8006ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006be:	78 b8                	js     800678 <vprintfmt+0x1e5>
  8006c0:	ff 4d e0             	decl   -0x20(%ebp)
  8006c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c7:	79 af                	jns    800678 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c9:	eb 13                	jmp    8006de <vprintfmt+0x24b>
				putch(' ', putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	6a 20                	push   $0x20
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006db:	ff 4d e4             	decl   -0x1c(%ebp)
  8006de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e2:	7f e7                	jg     8006cb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006e4:	e9 66 01 00 00       	jmp    80084f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	e8 3c fd ff ff       	call   800434 <getint>
  8006f8:	83 c4 10             	add    $0x10,%esp
  8006fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	85 d2                	test   %edx,%edx
  800709:	79 23                	jns    80072e <vprintfmt+0x29b>
				putch('-', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	6a 2d                	push   $0x2d
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80071b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800721:	f7 d8                	neg    %eax
  800723:	83 d2 00             	adc    $0x0,%edx
  800726:	f7 da                	neg    %edx
  800728:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80072e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800735:	e9 bc 00 00 00       	jmp    8007f6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 e8             	pushl  -0x18(%ebp)
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
  800743:	50                   	push   %eax
  800744:	e8 84 fc ff ff       	call   8003cd <getuint>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800752:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800759:	e9 98 00 00 00       	jmp    8007f6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	6a 58                	push   $0x58
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	ff d0                	call   *%eax
  80076b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	6a 58                	push   $0x58
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	ff d0                	call   *%eax
  80077b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 0c             	pushl  0xc(%ebp)
  800784:	6a 58                	push   $0x58
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
			break;
  80078e:	e9 bc 00 00 00       	jmp    80084f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	6a 30                	push   $0x30
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 78                	push   $0x78
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 c0 04             	add    $0x4,%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 e8 04             	sub    $0x4,%eax
  8007c2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007d5:	eb 1f                	jmp    8007f6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 e8             	pushl  -0x18(%ebp)
  8007dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e0:	50                   	push   %eax
  8007e1:	e8 e7 fb ff ff       	call   8003cd <getuint>
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007ef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	ff 75 e4             	pushl  -0x1c(%ebp)
  800804:	50                   	push   %eax
  800805:	ff 75 f4             	pushl  -0xc(%ebp)
  800808:	ff 75 f0             	pushl  -0x10(%ebp)
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	ff 75 08             	pushl  0x8(%ebp)
  800811:	e8 00 fb ff ff       	call   800316 <printnum>
  800816:	83 c4 20             	add    $0x20,%esp
			break;
  800819:	eb 34                	jmp    80084f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	53                   	push   %ebx
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
			break;
  80082a:	eb 23                	jmp    80084f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	6a 25                	push   $0x25
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083c:	ff 4d 10             	decl   0x10(%ebp)
  80083f:	eb 03                	jmp    800844 <vprintfmt+0x3b1>
  800841:	ff 4d 10             	decl   0x10(%ebp)
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	48                   	dec    %eax
  800848:	8a 00                	mov    (%eax),%al
  80084a:	3c 25                	cmp    $0x25,%al
  80084c:	75 f3                	jne    800841 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80084e:	90                   	nop
		}
	}
  80084f:	e9 47 fc ff ff       	jmp    80049b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800854:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800855:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800858:	5b                   	pop    %ebx
  800859:	5e                   	pop    %esi
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800862:	8d 45 10             	lea    0x10(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80086b:	8b 45 10             	mov    0x10(%ebp),%eax
  80086e:	ff 75 f4             	pushl  -0xc(%ebp)
  800871:	50                   	push   %eax
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 16 fc ff ff       	call   800493 <vprintfmt>
  80087d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800880:	90                   	nop
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800886:	8b 45 0c             	mov    0xc(%ebp),%eax
  800889:	8b 40 08             	mov    0x8(%eax),%eax
  80088c:	8d 50 01             	lea    0x1(%eax),%edx
  80088f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800892:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800895:	8b 45 0c             	mov    0xc(%ebp),%eax
  800898:	8b 10                	mov    (%eax),%edx
  80089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089d:	8b 40 04             	mov    0x4(%eax),%eax
  8008a0:	39 c2                	cmp    %eax,%edx
  8008a2:	73 12                	jae    8008b6 <sprintputch+0x33>
		*b->buf++ = ch;
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008af:	89 0a                	mov    %ecx,(%edx)
  8008b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b4:	88 10                	mov    %dl,(%eax)
}
  8008b6:	90                   	nop
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008de:	74 06                	je     8008e6 <vsnprintf+0x2d>
  8008e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e4:	7f 07                	jg     8008ed <vsnprintf+0x34>
		return -E_INVAL;
  8008e6:	b8 03 00 00 00       	mov    $0x3,%eax
  8008eb:	eb 20                	jmp    80090d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ed:	ff 75 14             	pushl  0x14(%ebp)
  8008f0:	ff 75 10             	pushl  0x10(%ebp)
  8008f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	68 83 08 80 00       	push   $0x800883
  8008fc:	e8 92 fb ff ff       	call   800493 <vprintfmt>
  800901:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800907:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800915:	8d 45 10             	lea    0x10(%ebp),%eax
  800918:	83 c0 04             	add    $0x4,%eax
  80091b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	ff 75 f4             	pushl  -0xc(%ebp)
  800924:	50                   	push   %eax
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	ff 75 08             	pushl  0x8(%ebp)
  80092b:	e8 89 ff ff ff       	call   8008b9 <vsnprintf>
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800936:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800948:	eb 06                	jmp    800950 <strlen+0x15>
		n++;
  80094a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80094d:	ff 45 08             	incl   0x8(%ebp)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8a 00                	mov    (%eax),%al
  800955:	84 c0                	test   %al,%al
  800957:	75 f1                	jne    80094a <strlen+0xf>
		n++;
	return n;
  800959:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800964:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80096b:	eb 09                	jmp    800976 <strnlen+0x18>
		n++;
  80096d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800970:	ff 45 08             	incl   0x8(%ebp)
  800973:	ff 4d 0c             	decl   0xc(%ebp)
  800976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097a:	74 09                	je     800985 <strnlen+0x27>
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8a 00                	mov    (%eax),%al
  800981:	84 c0                	test   %al,%al
  800983:	75 e8                	jne    80096d <strnlen+0xf>
		n++;
	return n;
  800985:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800996:	90                   	nop
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8d 50 01             	lea    0x1(%eax),%edx
  80099d:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009a9:	8a 12                	mov    (%edx),%dl
  8009ab:	88 10                	mov    %dl,(%eax)
  8009ad:	8a 00                	mov    (%eax),%al
  8009af:	84 c0                	test   %al,%al
  8009b1:	75 e4                	jne    800997 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009cb:	eb 1f                	jmp    8009ec <strncpy+0x34>
		*dst++ = *src;
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8d 50 01             	lea    0x1(%eax),%edx
  8009d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	8a 12                	mov    (%edx),%dl
  8009db:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	8a 00                	mov    (%eax),%al
  8009e2:	84 c0                	test   %al,%al
  8009e4:	74 03                	je     8009e9 <strncpy+0x31>
			src++;
  8009e6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e9:	ff 45 fc             	incl   -0x4(%ebp)
  8009ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ef:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009f2:	72 d9                	jb     8009cd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a09:	74 30                	je     800a3b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a0b:	eb 16                	jmp    800a23 <strlcpy+0x2a>
			*dst++ = *src++;
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8d 50 01             	lea    0x1(%eax),%edx
  800a13:	89 55 08             	mov    %edx,0x8(%ebp)
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a1c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a1f:	8a 12                	mov    (%edx),%dl
  800a21:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a23:	ff 4d 10             	decl   0x10(%ebp)
  800a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2a:	74 09                	je     800a35 <strlcpy+0x3c>
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	84 c0                	test   %al,%al
  800a33:	75 d8                	jne    800a0d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a41:	29 c2                	sub    %eax,%edx
  800a43:	89 d0                	mov    %edx,%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a4a:	eb 06                	jmp    800a52 <strcmp+0xb>
		p++, q++;
  800a4c:	ff 45 08             	incl   0x8(%ebp)
  800a4f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	84 c0                	test   %al,%al
  800a59:	74 0e                	je     800a69 <strcmp+0x22>
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8a 10                	mov    (%eax),%dl
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	8a 00                	mov    (%eax),%al
  800a65:	38 c2                	cmp    %al,%dl
  800a67:	74 e3                	je     800a4c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	0f b6 d0             	movzbl %al,%edx
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	8a 00                	mov    (%eax),%al
  800a76:	0f b6 c0             	movzbl %al,%eax
  800a79:	29 c2                	sub    %eax,%edx
  800a7b:	89 d0                	mov    %edx,%eax
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a82:	eb 09                	jmp    800a8d <strncmp+0xe>
		n--, p++, q++;
  800a84:	ff 4d 10             	decl   0x10(%ebp)
  800a87:	ff 45 08             	incl   0x8(%ebp)
  800a8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a91:	74 17                	je     800aaa <strncmp+0x2b>
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	84 c0                	test   %al,%al
  800a9a:	74 0e                	je     800aaa <strncmp+0x2b>
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8a 10                	mov    (%eax),%dl
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	8a 00                	mov    (%eax),%al
  800aa6:	38 c2                	cmp    %al,%dl
  800aa8:	74 da                	je     800a84 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aae:	75 07                	jne    800ab7 <strncmp+0x38>
		return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb 14                	jmp    800acb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	0f b6 d0             	movzbl %al,%edx
  800abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	0f b6 c0             	movzbl %al,%eax
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
}
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 04             	sub    $0x4,%esp
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad9:	eb 12                	jmp    800aed <strchr+0x20>
		if (*s == c)
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae3:	75 05                	jne    800aea <strchr+0x1d>
			return (char *) s;
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	eb 11                	jmp    800afb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aea:	ff 45 08             	incl   0x8(%ebp)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8a 00                	mov    (%eax),%al
  800af2:	84 c0                	test   %al,%al
  800af4:	75 e5                	jne    800adb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	83 ec 04             	sub    $0x4,%esp
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b09:	eb 0d                	jmp    800b18 <strfind+0x1b>
		if (*s == c)
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8a 00                	mov    (%eax),%al
  800b10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b13:	74 0e                	je     800b23 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b15:	ff 45 08             	incl   0x8(%ebp)
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8a 00                	mov    (%eax),%al
  800b1d:	84 c0                	test   %al,%al
  800b1f:	75 ea                	jne    800b0b <strfind+0xe>
  800b21:	eb 01                	jmp    800b24 <strfind+0x27>
		if (*s == c)
			break;
  800b23:	90                   	nop
	return (char *) s;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b35:	8b 45 10             	mov    0x10(%ebp),%eax
  800b38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b3b:	eb 0e                	jmp    800b4b <memset+0x22>
		*p++ = c;
  800b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b40:	8d 50 01             	lea    0x1(%eax),%edx
  800b43:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b49:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b4b:	ff 4d f8             	decl   -0x8(%ebp)
  800b4e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b52:	79 e9                	jns    800b3d <memset+0x14>
		*p++ = c;

	return v;
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b6b:	eb 16                	jmp    800b83 <memcpy+0x2a>
		*d++ = *s++;
  800b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b7c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b7f:	8a 12                	mov    (%edx),%dl
  800b81:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b83:	8b 45 10             	mov    0x10(%ebp),%eax
  800b86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b89:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	75 dd                	jne    800b6d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ba7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800baa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bad:	73 50                	jae    800bff <memmove+0x6a>
  800baf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	01 d0                	add    %edx,%eax
  800bb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bba:	76 43                	jbe    800bff <memmove+0x6a>
		s += n;
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc8:	eb 10                	jmp    800bda <memmove+0x45>
			*--d = *--s;
  800bca:	ff 4d f8             	decl   -0x8(%ebp)
  800bcd:	ff 4d fc             	decl   -0x4(%ebp)
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd3:	8a 10                	mov    (%eax),%dl
  800bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bda:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be0:	89 55 10             	mov    %edx,0x10(%ebp)
  800be3:	85 c0                	test   %eax,%eax
  800be5:	75 e3                	jne    800bca <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be7:	eb 23                	jmp    800c0c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bec:	8d 50 01             	lea    0x1(%eax),%edx
  800bef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bfb:	8a 12                	mov    (%edx),%dl
  800bfd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bff:	8b 45 10             	mov    0x10(%ebp),%eax
  800c02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c05:	89 55 10             	mov    %edx,0x10(%ebp)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	75 dd                	jne    800be9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c23:	eb 2a                	jmp    800c4f <memcmp+0x3e>
		if (*s1 != *s2)
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c28:	8a 10                	mov    (%eax),%dl
  800c2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	38 c2                	cmp    %al,%dl
  800c31:	74 16                	je     800c49 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	0f b6 d0             	movzbl %al,%edx
  800c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	0f b6 c0             	movzbl %al,%eax
  800c43:	29 c2                	sub    %eax,%edx
  800c45:	89 d0                	mov    %edx,%eax
  800c47:	eb 18                	jmp    800c61 <memcmp+0x50>
		s1++, s2++;
  800c49:	ff 45 fc             	incl   -0x4(%ebp)
  800c4c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c55:	89 55 10             	mov    %edx,0x10(%ebp)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	75 c9                	jne    800c25 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6f:	01 d0                	add    %edx,%eax
  800c71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c74:	eb 15                	jmp    800c8b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f b6 d0             	movzbl %al,%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	0f b6 c0             	movzbl %al,%eax
  800c84:	39 c2                	cmp    %eax,%edx
  800c86:	74 0d                	je     800c95 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c91:	72 e3                	jb     800c76 <memfind+0x13>
  800c93:	eb 01                	jmp    800c96 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c95:	90                   	nop
	return (void *) s;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800caf:	eb 03                	jmp    800cb4 <strtol+0x19>
		s++;
  800cb1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	3c 20                	cmp    $0x20,%al
  800cbb:	74 f4                	je     800cb1 <strtol+0x16>
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	3c 09                	cmp    $0x9,%al
  800cc4:	74 eb                	je     800cb1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	3c 2b                	cmp    $0x2b,%al
  800ccd:	75 05                	jne    800cd4 <strtol+0x39>
		s++;
  800ccf:	ff 45 08             	incl   0x8(%ebp)
  800cd2:	eb 13                	jmp    800ce7 <strtol+0x4c>
	else if (*s == '-')
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3c 2d                	cmp    $0x2d,%al
  800cdb:	75 0a                	jne    800ce7 <strtol+0x4c>
		s++, neg = 1;
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 06                	je     800cf3 <strtol+0x58>
  800ced:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cf1:	75 20                	jne    800d13 <strtol+0x78>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	3c 30                	cmp    $0x30,%al
  800cfa:	75 17                	jne    800d13 <strtol+0x78>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	40                   	inc    %eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	3c 78                	cmp    $0x78,%al
  800d04:	75 0d                	jne    800d13 <strtol+0x78>
		s += 2, base = 16;
  800d06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d11:	eb 28                	jmp    800d3b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d17:	75 15                	jne    800d2e <strtol+0x93>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	3c 30                	cmp    $0x30,%al
  800d20:	75 0c                	jne    800d2e <strtol+0x93>
		s++, base = 8;
  800d22:	ff 45 08             	incl   0x8(%ebp)
  800d25:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d2c:	eb 0d                	jmp    800d3b <strtol+0xa0>
	else if (base == 0)
  800d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d32:	75 07                	jne    800d3b <strtol+0xa0>
		base = 10;
  800d34:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3c 2f                	cmp    $0x2f,%al
  800d42:	7e 19                	jle    800d5d <strtol+0xc2>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 39                	cmp    $0x39,%al
  800d4b:	7f 10                	jg     800d5d <strtol+0xc2>
			dig = *s - '0';
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 e8 30             	sub    $0x30,%eax
  800d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d5b:	eb 42                	jmp    800d9f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	3c 60                	cmp    $0x60,%al
  800d64:	7e 19                	jle    800d7f <strtol+0xe4>
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3c 7a                	cmp    $0x7a,%al
  800d6d:	7f 10                	jg     800d7f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f be c0             	movsbl %al,%eax
  800d77:	83 e8 57             	sub    $0x57,%eax
  800d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7d:	eb 20                	jmp    800d9f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 40                	cmp    $0x40,%al
  800d86:	7e 39                	jle    800dc1 <strtol+0x126>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 5a                	cmp    $0x5a,%al
  800d8f:	7f 30                	jg     800dc1 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	0f be c0             	movsbl %al,%eax
  800d99:	83 e8 37             	sub    $0x37,%eax
  800d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da5:	7d 19                	jge    800dc0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800da7:	ff 45 08             	incl   0x8(%ebp)
  800daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dad:	0f af 45 10          	imul   0x10(%ebp),%eax
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db6:	01 d0                	add    %edx,%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dbb:	e9 7b ff ff ff       	jmp    800d3b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc5:	74 08                	je     800dcf <strtol+0x134>
		*endptr = (char *) s;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd3:	74 07                	je     800ddc <strtol+0x141>
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	f7 d8                	neg    %eax
  800dda:	eb 03                	jmp    800ddf <strtol+0x144>
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <ltostr>:

void
ltostr(long value, char *str)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800df5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df9:	79 13                	jns    800e0e <ltostr+0x2d>
	{
		neg = 1;
  800dfb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e08:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e0b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e16:	99                   	cltd   
  800e17:	f7 f9                	idiv   %ecx
  800e19:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e25:	89 c2                	mov    %eax,%edx
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	01 d0                	add    %edx,%eax
  800e2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e2f:	83 c2 30             	add    $0x30,%edx
  800e32:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e37:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e3c:	f7 e9                	imul   %ecx
  800e3e:	c1 fa 02             	sar    $0x2,%edx
  800e41:	89 c8                	mov    %ecx,%eax
  800e43:	c1 f8 1f             	sar    $0x1f,%eax
  800e46:	29 c2                	sub    %eax,%edx
  800e48:	89 d0                	mov    %edx,%eax
  800e4a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e50:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e55:	f7 e9                	imul   %ecx
  800e57:	c1 fa 02             	sar    $0x2,%edx
  800e5a:	89 c8                	mov    %ecx,%eax
  800e5c:	c1 f8 1f             	sar    $0x1f,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	c1 e0 02             	shl    $0x2,%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	01 c0                	add    %eax,%eax
  800e6a:	29 c1                	sub    %eax,%ecx
  800e6c:	89 ca                	mov    %ecx,%edx
  800e6e:	85 d2                	test   %edx,%edx
  800e70:	75 9c                	jne    800e0e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	48                   	dec    %eax
  800e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e84:	74 3d                	je     800ec3 <ltostr+0xe2>
		start = 1 ;
  800e86:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e8d:	eb 34                	jmp    800ec3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	01 d0                	add    %edx,%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	01 c2                	add    %eax,%edx
  800ea4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	01 c8                	add    %ecx,%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	01 c2                	add    %eax,%edx
  800eb8:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ebb:	88 02                	mov    %al,(%edx)
		start++ ;
  800ebd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ec9:	7c c4                	jl     800e8f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ecb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	01 d0                	add    %edx,%eax
  800ed3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed6:	90                   	nop
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800edf:	ff 75 08             	pushl  0x8(%ebp)
  800ee2:	e8 54 fa ff ff       	call   80093b <strlen>
  800ee7:	83 c4 04             	add    $0x4,%esp
  800eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	e8 46 fa ff ff       	call   80093b <strlen>
  800ef5:	83 c4 04             	add    $0x4,%esp
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800efb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f09:	eb 17                	jmp    800f22 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	01 c2                	add    %eax,%edx
  800f13:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	01 c8                	add    %ecx,%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f1f:	ff 45 fc             	incl   -0x4(%ebp)
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f28:	7c e1                	jl     800f0b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f38:	eb 1f                	jmp    800f59 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	8d 50 01             	lea    0x1(%eax),%edx
  800f40:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	8b 45 10             	mov    0x10(%ebp),%eax
  800f48:	01 c2                	add    %eax,%edx
  800f4a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	01 c8                	add    %ecx,%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f56:	ff 45 f8             	incl   -0x8(%ebp)
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5f:	7c d9                	jl     800f3a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	01 d0                	add    %edx,%eax
  800f69:	c6 00 00             	movb   $0x0,(%eax)
}
  800f6c:	90                   	nop
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f72:	8b 45 14             	mov    0x14(%ebp),%eax
  800f75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7e:	8b 00                	mov    (%eax),%eax
  800f80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	01 d0                	add    %edx,%eax
  800f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f92:	eb 0c                	jmp    800fa0 <strsplit+0x31>
			*string++ = 0;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8d 50 01             	lea    0x1(%eax),%edx
  800f9a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	84 c0                	test   %al,%al
  800fa7:	74 18                	je     800fc1 <strsplit+0x52>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	0f be c0             	movsbl %al,%eax
  800fb1:	50                   	push   %eax
  800fb2:	ff 75 0c             	pushl  0xc(%ebp)
  800fb5:	e8 13 fb ff ff       	call   800acd <strchr>
  800fba:	83 c4 08             	add    $0x8,%esp
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 d3                	jne    800f94 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	84 c0                	test   %al,%al
  800fc8:	74 5a                	je     801024 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fca:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcd:	8b 00                	mov    (%eax),%eax
  800fcf:	83 f8 0f             	cmp    $0xf,%eax
  800fd2:	75 07                	jne    800fdb <strsplit+0x6c>
		{
			return 0;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd9:	eb 66                	jmp    801041 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fde:	8b 00                	mov    (%eax),%eax
  800fe0:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe3:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe6:	89 0a                	mov    %ecx,(%edx)
  800fe8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	01 c2                	add    %eax,%edx
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff9:	eb 03                	jmp    800ffe <strsplit+0x8f>
			string++;
  800ffb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	74 8b                	je     800f92 <strsplit+0x23>
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	0f be c0             	movsbl %al,%eax
  80100f:	50                   	push   %eax
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	e8 b5 fa ff ff       	call   800acd <strchr>
  801018:	83 c4 08             	add    $0x8,%esp
  80101b:	85 c0                	test   %eax,%eax
  80101d:	74 dc                	je     800ffb <strsplit+0x8c>
			string++;
	}
  80101f:	e9 6e ff ff ff       	jmp    800f92 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801024:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8b 00                	mov    (%eax),%eax
  80102a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801031:	8b 45 10             	mov    0x10(%ebp),%eax
  801034:	01 d0                	add    %edx,%eax
  801036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80103c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801052:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801055:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801058:	8b 7d 18             	mov    0x18(%ebp),%edi
  80105b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80105e:	cd 30                	int    $0x30
  801060:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801063:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80107a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	6a 00                	push   $0x0
  801083:	6a 00                	push   $0x0
  801085:	52                   	push   %edx
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	50                   	push   %eax
  80108a:	6a 00                	push   $0x0
  80108c:	e8 b2 ff ff ff       	call   801043 <syscall>
  801091:	83 c4 18             	add    $0x18,%esp
}
  801094:	90                   	nop
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <sys_cgetc>:

int
sys_cgetc(void)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	6a 00                	push   $0x0
  8010a0:	6a 00                	push   $0x0
  8010a2:	6a 00                	push   $0x0
  8010a4:	6a 01                	push   $0x1
  8010a6:	e8 98 ff ff ff       	call   801043 <syscall>
  8010ab:	83 c4 18             	add    $0x18,%esp
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	52                   	push   %edx
  8010c0:	50                   	push   %eax
  8010c1:	6a 05                	push   $0x5
  8010c3:	e8 7b ff ff ff       	call   801043 <syscall>
  8010c8:	83 c4 18             	add    $0x18,%esp
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	51                   	push   %ecx
  8010e4:	52                   	push   %edx
  8010e5:	50                   	push   %eax
  8010e6:	6a 06                	push   $0x6
  8010e8:	e8 56 ff ff ff       	call   801043 <syscall>
  8010ed:	83 c4 18             	add    $0x18,%esp
}
  8010f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	52                   	push   %edx
  801107:	50                   	push   %eax
  801108:	6a 07                	push   $0x7
  80110a:	e8 34 ff ff ff       	call   801043 <syscall>
  80110f:	83 c4 18             	add    $0x18,%esp
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	ff 75 08             	pushl  0x8(%ebp)
  801123:	6a 08                	push   $0x8
  801125:	e8 19 ff ff ff       	call   801043 <syscall>
  80112a:	83 c4 18             	add    $0x18,%esp
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 09                	push   $0x9
  80113e:	e8 00 ff ff ff       	call   801043 <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 0a                	push   $0xa
  801157:	e8 e7 fe ff ff       	call   801043 <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 0b                	push   $0xb
  801170:	e8 ce fe ff ff       	call   801043 <syscall>
  801175:	83 c4 18             	add    $0x18,%esp
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	ff 75 08             	pushl  0x8(%ebp)
  801189:	6a 0f                	push   $0xf
  80118b:	e8 b3 fe ff ff       	call   801043 <syscall>
  801190:	83 c4 18             	add    $0x18,%esp
	return;
  801193:	90                   	nop
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	ff 75 08             	pushl  0x8(%ebp)
  8011a5:	6a 10                	push   $0x10
  8011a7:	e8 97 fe ff ff       	call   801043 <syscall>
  8011ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8011af:	90                   	nop
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	ff 75 10             	pushl  0x10(%ebp)
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	ff 75 08             	pushl  0x8(%ebp)
  8011c2:	6a 11                	push   $0x11
  8011c4:	e8 7a fe ff ff       	call   801043 <syscall>
  8011c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8011cc:	90                   	nop
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 0c                	push   $0xc
  8011de:	e8 60 fe ff ff       	call   801043 <syscall>
  8011e3:	83 c4 18             	add    $0x18,%esp
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	ff 75 08             	pushl  0x8(%ebp)
  8011f6:	6a 0d                	push   $0xd
  8011f8:	e8 46 fe ff ff       	call   801043 <syscall>
  8011fd:	83 c4 18             	add    $0x18,%esp
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 0e                	push   $0xe
  801211:	e8 2d fe ff ff       	call   801043 <syscall>
  801216:	83 c4 18             	add    $0x18,%esp
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 13                	push   $0x13
  80122b:	e8 13 fe ff ff       	call   801043 <syscall>
  801230:	83 c4 18             	add    $0x18,%esp
}
  801233:	90                   	nop
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 14                	push   $0x14
  801245:	e8 f9 fd ff ff       	call   801043 <syscall>
  80124a:	83 c4 18             	add    $0x18,%esp
}
  80124d:	90                   	nop
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <sys_cputc>:


void
sys_cputc(const char c)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80125c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	50                   	push   %eax
  801269:	6a 15                	push   $0x15
  80126b:	e8 d3 fd ff ff       	call   801043 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	90                   	nop
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 16                	push   $0x16
  801285:	e8 b9 fd ff ff       	call   801043 <syscall>
  80128a:	83 c4 18             	add    $0x18,%esp
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	ff 75 0c             	pushl  0xc(%ebp)
  80129f:	50                   	push   %eax
  8012a0:	6a 17                	push   $0x17
  8012a2:	e8 9c fd ff ff       	call   801043 <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	6a 1a                	push   $0x1a
  8012bf:	e8 7f fd ff ff       	call   801043 <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	52                   	push   %edx
  8012d9:	50                   	push   %eax
  8012da:	6a 18                	push   $0x18
  8012dc:	e8 62 fd ff ff       	call   801043 <syscall>
  8012e1:	83 c4 18             	add    $0x18,%esp
}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	52                   	push   %edx
  8012f7:	50                   	push   %eax
  8012f8:	6a 19                	push   $0x19
  8012fa:	e8 44 fd ff ff       	call   801043 <syscall>
  8012ff:	83 c4 18             	add    $0x18,%esp
}
  801302:	90                   	nop
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801311:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801314:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	6a 00                	push   $0x0
  80131d:	51                   	push   %ecx
  80131e:	52                   	push   %edx
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	50                   	push   %eax
  801323:	6a 1b                	push   $0x1b
  801325:	e8 19 fd ff ff       	call   801043 <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	52                   	push   %edx
  80133f:	50                   	push   %eax
  801340:	6a 1c                	push   $0x1c
  801342:	e8 fc fc ff ff       	call   801043 <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80134f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	51                   	push   %ecx
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	6a 1d                	push   $0x1d
  801361:	e8 dd fc ff ff       	call   801043 <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80136e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	52                   	push   %edx
  80137b:	50                   	push   %eax
  80137c:	6a 1e                	push   $0x1e
  80137e:	e8 c0 fc ff ff       	call   801043 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 1f                	push   $0x1f
  801397:	e8 a7 fc ff ff       	call   801043 <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	6a 00                	push   $0x0
  8013a9:	ff 75 14             	pushl  0x14(%ebp)
  8013ac:	ff 75 10             	pushl  0x10(%ebp)
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	50                   	push   %eax
  8013b3:	6a 20                	push   $0x20
  8013b5:	e8 89 fc ff ff       	call   801043 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	50                   	push   %eax
  8013ce:	6a 21                	push   $0x21
  8013d0:	e8 6e fc ff ff       	call   801043 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	90                   	nop
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	50                   	push   %eax
  8013ea:	6a 22                	push   $0x22
  8013ec:	e8 52 fc ff ff       	call   801043 <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 02                	push   $0x2
  801405:	e8 39 fc ff ff       	call   801043 <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 03                	push   $0x3
  80141e:	e8 20 fc ff ff       	call   801043 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 04                	push   $0x4
  801437:	e8 07 fc ff ff       	call   801043 <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_exit_env>:


void sys_exit_env(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 23                	push   $0x23
  801450:	e8 ee fb ff ff       	call   801043 <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801461:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801464:	8d 50 04             	lea    0x4(%eax),%edx
  801467:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	6a 24                	push   $0x24
  801474:	e8 ca fb ff ff       	call   801043 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
	return result;
  80147c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801482:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801485:	89 01                	mov    %eax,(%ecx)
  801487:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	c9                   	leave  
  80148e:	c2 04 00             	ret    $0x4

00801491 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	ff 75 10             	pushl  0x10(%ebp)
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	ff 75 08             	pushl  0x8(%ebp)
  8014a1:	6a 12                	push   $0x12
  8014a3:	e8 9b fb ff ff       	call   801043 <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ab:	90                   	nop
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 25                	push   $0x25
  8014bd:	e8 81 fb ff ff       	call   801043 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	50                   	push   %eax
  8014e0:	6a 26                	push   $0x26
  8014e2:	e8 5c fb ff ff       	call   801043 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ea:	90                   	nop
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <rsttst>:
void rsttst()
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 28                	push   $0x28
  8014fc:	e8 42 fb ff ff       	call   801043 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
	return ;
  801504:	90                   	nop
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801513:	8b 55 18             	mov    0x18(%ebp),%edx
  801516:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80151a:	52                   	push   %edx
  80151b:	50                   	push   %eax
  80151c:	ff 75 10             	pushl  0x10(%ebp)
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	6a 27                	push   $0x27
  801527:	e8 17 fb ff ff       	call   801043 <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
	return ;
  80152f:	90                   	nop
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <chktst>:
void chktst(uint32 n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	6a 29                	push   $0x29
  801542:	e8 fc fa ff ff       	call   801043 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
	return ;
  80154a:	90                   	nop
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <inctst>:

void inctst()
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 2a                	push   $0x2a
  80155c:	e8 e2 fa ff ff       	call   801043 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
	return ;
  801564:	90                   	nop
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <gettst>:
uint32 gettst()
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 2b                	push   $0x2b
  801576:	e8 c8 fa ff ff       	call   801043 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 2c                	push   $0x2c
  801592:	e8 ac fa ff ff       	call   801043 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
  80159a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80159d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015a1:	75 07                	jne    8015aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a8:	eb 05                	jmp    8015af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 2c                	push   $0x2c
  8015c3:	e8 7b fa ff ff       	call   801043 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
  8015cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015d2:	75 07                	jne    8015db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d9:	eb 05                	jmp    8015e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 2c                	push   $0x2c
  8015f4:	e8 4a fa ff ff       	call   801043 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
  8015fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801603:	75 07                	jne    80160c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801605:	b8 01 00 00 00       	mov    $0x1,%eax
  80160a:	eb 05                	jmp    801611 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 2c                	push   $0x2c
  801625:	e8 19 fa ff ff       	call   801043 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
  80162d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801630:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801634:	75 07                	jne    80163d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801636:	b8 01 00 00 00       	mov    $0x1,%eax
  80163b:	eb 05                	jmp    801642 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 08             	pushl  0x8(%ebp)
  801652:	6a 2d                	push   $0x2d
  801654:	e8 ea f9 ff ff       	call   801043 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
	return ;
  80165c:	90                   	nop
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801663:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801666:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	6a 00                	push   $0x0
  801671:	53                   	push   %ebx
  801672:	51                   	push   %ecx
  801673:	52                   	push   %edx
  801674:	50                   	push   %eax
  801675:	6a 2e                	push   $0x2e
  801677:	e8 c7 f9 ff ff       	call   801043 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	52                   	push   %edx
  801694:	50                   	push   %eax
  801695:	6a 2f                	push   $0x2f
  801697:	e8 a7 f9 ff ff       	call   801043 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    
  8016a1:	66 90                	xchg   %ax,%ax
  8016a3:	90                   	nop

008016a4 <__udivdi3>:
  8016a4:	55                   	push   %ebp
  8016a5:	57                   	push   %edi
  8016a6:	56                   	push   %esi
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 1c             	sub    $0x1c,%esp
  8016ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016bb:	89 ca                	mov    %ecx,%edx
  8016bd:	89 f8                	mov    %edi,%eax
  8016bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8016c3:	85 f6                	test   %esi,%esi
  8016c5:	75 2d                	jne    8016f4 <__udivdi3+0x50>
  8016c7:	39 cf                	cmp    %ecx,%edi
  8016c9:	77 65                	ja     801730 <__udivdi3+0x8c>
  8016cb:	89 fd                	mov    %edi,%ebp
  8016cd:	85 ff                	test   %edi,%edi
  8016cf:	75 0b                	jne    8016dc <__udivdi3+0x38>
  8016d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d6:	31 d2                	xor    %edx,%edx
  8016d8:	f7 f7                	div    %edi
  8016da:	89 c5                	mov    %eax,%ebp
  8016dc:	31 d2                	xor    %edx,%edx
  8016de:	89 c8                	mov    %ecx,%eax
  8016e0:	f7 f5                	div    %ebp
  8016e2:	89 c1                	mov    %eax,%ecx
  8016e4:	89 d8                	mov    %ebx,%eax
  8016e6:	f7 f5                	div    %ebp
  8016e8:	89 cf                	mov    %ecx,%edi
  8016ea:	89 fa                	mov    %edi,%edx
  8016ec:	83 c4 1c             	add    $0x1c,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5f                   	pop    %edi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    
  8016f4:	39 ce                	cmp    %ecx,%esi
  8016f6:	77 28                	ja     801720 <__udivdi3+0x7c>
  8016f8:	0f bd fe             	bsr    %esi,%edi
  8016fb:	83 f7 1f             	xor    $0x1f,%edi
  8016fe:	75 40                	jne    801740 <__udivdi3+0x9c>
  801700:	39 ce                	cmp    %ecx,%esi
  801702:	72 0a                	jb     80170e <__udivdi3+0x6a>
  801704:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801708:	0f 87 9e 00 00 00    	ja     8017ac <__udivdi3+0x108>
  80170e:	b8 01 00 00 00       	mov    $0x1,%eax
  801713:	89 fa                	mov    %edi,%edx
  801715:	83 c4 1c             	add    $0x1c,%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5f                   	pop    %edi
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    
  80171d:	8d 76 00             	lea    0x0(%esi),%esi
  801720:	31 ff                	xor    %edi,%edi
  801722:	31 c0                	xor    %eax,%eax
  801724:	89 fa                	mov    %edi,%edx
  801726:	83 c4 1c             	add    $0x1c,%esp
  801729:	5b                   	pop    %ebx
  80172a:	5e                   	pop    %esi
  80172b:	5f                   	pop    %edi
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    
  80172e:	66 90                	xchg   %ax,%ax
  801730:	89 d8                	mov    %ebx,%eax
  801732:	f7 f7                	div    %edi
  801734:	31 ff                	xor    %edi,%edi
  801736:	89 fa                	mov    %edi,%edx
  801738:	83 c4 1c             	add    $0x1c,%esp
  80173b:	5b                   	pop    %ebx
  80173c:	5e                   	pop    %esi
  80173d:	5f                   	pop    %edi
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    
  801740:	bd 20 00 00 00       	mov    $0x20,%ebp
  801745:	89 eb                	mov    %ebp,%ebx
  801747:	29 fb                	sub    %edi,%ebx
  801749:	89 f9                	mov    %edi,%ecx
  80174b:	d3 e6                	shl    %cl,%esi
  80174d:	89 c5                	mov    %eax,%ebp
  80174f:	88 d9                	mov    %bl,%cl
  801751:	d3 ed                	shr    %cl,%ebp
  801753:	89 e9                	mov    %ebp,%ecx
  801755:	09 f1                	or     %esi,%ecx
  801757:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80175b:	89 f9                	mov    %edi,%ecx
  80175d:	d3 e0                	shl    %cl,%eax
  80175f:	89 c5                	mov    %eax,%ebp
  801761:	89 d6                	mov    %edx,%esi
  801763:	88 d9                	mov    %bl,%cl
  801765:	d3 ee                	shr    %cl,%esi
  801767:	89 f9                	mov    %edi,%ecx
  801769:	d3 e2                	shl    %cl,%edx
  80176b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80176f:	88 d9                	mov    %bl,%cl
  801771:	d3 e8                	shr    %cl,%eax
  801773:	09 c2                	or     %eax,%edx
  801775:	89 d0                	mov    %edx,%eax
  801777:	89 f2                	mov    %esi,%edx
  801779:	f7 74 24 0c          	divl   0xc(%esp)
  80177d:	89 d6                	mov    %edx,%esi
  80177f:	89 c3                	mov    %eax,%ebx
  801781:	f7 e5                	mul    %ebp
  801783:	39 d6                	cmp    %edx,%esi
  801785:	72 19                	jb     8017a0 <__udivdi3+0xfc>
  801787:	74 0b                	je     801794 <__udivdi3+0xf0>
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	31 ff                	xor    %edi,%edi
  80178d:	e9 58 ff ff ff       	jmp    8016ea <__udivdi3+0x46>
  801792:	66 90                	xchg   %ax,%ax
  801794:	8b 54 24 08          	mov    0x8(%esp),%edx
  801798:	89 f9                	mov    %edi,%ecx
  80179a:	d3 e2                	shl    %cl,%edx
  80179c:	39 c2                	cmp    %eax,%edx
  80179e:	73 e9                	jae    801789 <__udivdi3+0xe5>
  8017a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017a3:	31 ff                	xor    %edi,%edi
  8017a5:	e9 40 ff ff ff       	jmp    8016ea <__udivdi3+0x46>
  8017aa:	66 90                	xchg   %ax,%ax
  8017ac:	31 c0                	xor    %eax,%eax
  8017ae:	e9 37 ff ff ff       	jmp    8016ea <__udivdi3+0x46>
  8017b3:	90                   	nop

008017b4 <__umoddi3>:
  8017b4:	55                   	push   %ebp
  8017b5:	57                   	push   %edi
  8017b6:	56                   	push   %esi
  8017b7:	53                   	push   %ebx
  8017b8:	83 ec 1c             	sub    $0x1c,%esp
  8017bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8017bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8017c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8017cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d3:	89 f3                	mov    %esi,%ebx
  8017d5:	89 fa                	mov    %edi,%edx
  8017d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017db:	89 34 24             	mov    %esi,(%esp)
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	75 1a                	jne    8017fc <__umoddi3+0x48>
  8017e2:	39 f7                	cmp    %esi,%edi
  8017e4:	0f 86 a2 00 00 00    	jbe    80188c <__umoddi3+0xd8>
  8017ea:	89 c8                	mov    %ecx,%eax
  8017ec:	89 f2                	mov    %esi,%edx
  8017ee:	f7 f7                	div    %edi
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	31 d2                	xor    %edx,%edx
  8017f4:	83 c4 1c             	add    $0x1c,%esp
  8017f7:	5b                   	pop    %ebx
  8017f8:	5e                   	pop    %esi
  8017f9:	5f                   	pop    %edi
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    
  8017fc:	39 f0                	cmp    %esi,%eax
  8017fe:	0f 87 ac 00 00 00    	ja     8018b0 <__umoddi3+0xfc>
  801804:	0f bd e8             	bsr    %eax,%ebp
  801807:	83 f5 1f             	xor    $0x1f,%ebp
  80180a:	0f 84 ac 00 00 00    	je     8018bc <__umoddi3+0x108>
  801810:	bf 20 00 00 00       	mov    $0x20,%edi
  801815:	29 ef                	sub    %ebp,%edi
  801817:	89 fe                	mov    %edi,%esi
  801819:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80181d:	89 e9                	mov    %ebp,%ecx
  80181f:	d3 e0                	shl    %cl,%eax
  801821:	89 d7                	mov    %edx,%edi
  801823:	89 f1                	mov    %esi,%ecx
  801825:	d3 ef                	shr    %cl,%edi
  801827:	09 c7                	or     %eax,%edi
  801829:	89 e9                	mov    %ebp,%ecx
  80182b:	d3 e2                	shl    %cl,%edx
  80182d:	89 14 24             	mov    %edx,(%esp)
  801830:	89 d8                	mov    %ebx,%eax
  801832:	d3 e0                	shl    %cl,%eax
  801834:	89 c2                	mov    %eax,%edx
  801836:	8b 44 24 08          	mov    0x8(%esp),%eax
  80183a:	d3 e0                	shl    %cl,%eax
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	8b 44 24 08          	mov    0x8(%esp),%eax
  801844:	89 f1                	mov    %esi,%ecx
  801846:	d3 e8                	shr    %cl,%eax
  801848:	09 d0                	or     %edx,%eax
  80184a:	d3 eb                	shr    %cl,%ebx
  80184c:	89 da                	mov    %ebx,%edx
  80184e:	f7 f7                	div    %edi
  801850:	89 d3                	mov    %edx,%ebx
  801852:	f7 24 24             	mull   (%esp)
  801855:	89 c6                	mov    %eax,%esi
  801857:	89 d1                	mov    %edx,%ecx
  801859:	39 d3                	cmp    %edx,%ebx
  80185b:	0f 82 87 00 00 00    	jb     8018e8 <__umoddi3+0x134>
  801861:	0f 84 91 00 00 00    	je     8018f8 <__umoddi3+0x144>
  801867:	8b 54 24 04          	mov    0x4(%esp),%edx
  80186b:	29 f2                	sub    %esi,%edx
  80186d:	19 cb                	sbb    %ecx,%ebx
  80186f:	89 d8                	mov    %ebx,%eax
  801871:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801875:	d3 e0                	shl    %cl,%eax
  801877:	89 e9                	mov    %ebp,%ecx
  801879:	d3 ea                	shr    %cl,%edx
  80187b:	09 d0                	or     %edx,%eax
  80187d:	89 e9                	mov    %ebp,%ecx
  80187f:	d3 eb                	shr    %cl,%ebx
  801881:	89 da                	mov    %ebx,%edx
  801883:	83 c4 1c             	add    $0x1c,%esp
  801886:	5b                   	pop    %ebx
  801887:	5e                   	pop    %esi
  801888:	5f                   	pop    %edi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    
  80188b:	90                   	nop
  80188c:	89 fd                	mov    %edi,%ebp
  80188e:	85 ff                	test   %edi,%edi
  801890:	75 0b                	jne    80189d <__umoddi3+0xe9>
  801892:	b8 01 00 00 00       	mov    $0x1,%eax
  801897:	31 d2                	xor    %edx,%edx
  801899:	f7 f7                	div    %edi
  80189b:	89 c5                	mov    %eax,%ebp
  80189d:	89 f0                	mov    %esi,%eax
  80189f:	31 d2                	xor    %edx,%edx
  8018a1:	f7 f5                	div    %ebp
  8018a3:	89 c8                	mov    %ecx,%eax
  8018a5:	f7 f5                	div    %ebp
  8018a7:	89 d0                	mov    %edx,%eax
  8018a9:	e9 44 ff ff ff       	jmp    8017f2 <__umoddi3+0x3e>
  8018ae:	66 90                	xchg   %ax,%ax
  8018b0:	89 c8                	mov    %ecx,%eax
  8018b2:	89 f2                	mov    %esi,%edx
  8018b4:	83 c4 1c             	add    $0x1c,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    
  8018bc:	3b 04 24             	cmp    (%esp),%eax
  8018bf:	72 06                	jb     8018c7 <__umoddi3+0x113>
  8018c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8018c5:	77 0f                	ja     8018d6 <__umoddi3+0x122>
  8018c7:	89 f2                	mov    %esi,%edx
  8018c9:	29 f9                	sub    %edi,%ecx
  8018cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8018cf:	89 14 24             	mov    %edx,(%esp)
  8018d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018da:	8b 14 24             	mov    (%esp),%edx
  8018dd:	83 c4 1c             	add    $0x1c,%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5f                   	pop    %edi
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    
  8018e5:	8d 76 00             	lea    0x0(%esi),%esi
  8018e8:	2b 04 24             	sub    (%esp),%eax
  8018eb:	19 fa                	sbb    %edi,%edx
  8018ed:	89 d1                	mov    %edx,%ecx
  8018ef:	89 c6                	mov    %eax,%esi
  8018f1:	e9 71 ff ff ff       	jmp    801867 <__umoddi3+0xb3>
  8018f6:	66 90                	xchg   %ax,%ax
  8018f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018fc:	72 ea                	jb     8018e8 <__umoddi3+0x134>
  8018fe:	89 d9                	mov    %ebx,%ecx
  801900:	e9 62 ff ff ff       	jmp    801867 <__umoddi3+0xb3>
