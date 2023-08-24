
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 20 19 80 00       	push   $0x801920
  80005b:	e8 72 02 00 00       	call   8002d2 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 23 19 80 00       	push   $0x801923
  800092:	e8 3b 02 00 00       	call   8002d2 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000b5:	e8 6e 13 00 00       	call   801428 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	01 c0                	add    %eax,%eax
  8000c4:	01 d0                	add    %edx,%eax
  8000c6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000cd:	01 c8                	add    %ecx,%eax
  8000cf:	c1 e0 02             	shl    $0x2,%eax
  8000d2:	01 d0                	add    %edx,%eax
  8000d4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000db:	01 c8                	add    %ecx,%eax
  8000dd:	c1 e0 02             	shl    $0x2,%eax
  8000e0:	01 d0                	add    %edx,%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	01 d0                	add    %edx,%eax
  8000e7:	c1 e0 03             	shl    $0x3,%eax
  8000ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ef:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f9:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000ff:	84 c0                	test   %al,%al
  800101:	74 0f                	je     800112 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800103:	a1 20 20 80 00       	mov    0x802020,%eax
  800108:	05 18 da 01 00       	add    $0x1da18,%eax
  80010d:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800116:	7e 0a                	jle    800122 <libmain+0x73>
		binaryname = argv[0];
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	8b 00                	mov    (%eax),%eax
  80011d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	ff 75 0c             	pushl  0xc(%ebp)
  800128:	ff 75 08             	pushl  0x8(%ebp)
  80012b:	e8 08 ff ff ff       	call   800038 <_main>
  800130:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800133:	e8 fd 10 00 00       	call   801235 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	68 40 19 80 00       	push   $0x801940
  800140:	e8 8d 01 00 00       	call   8002d2 <cprintf>
  800145:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800148:	a1 20 20 80 00       	mov    0x802020,%eax
  80014d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800153:	a1 20 20 80 00       	mov    0x802020,%eax
  800158:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	68 68 19 80 00       	push   $0x801968
  800168:	e8 65 01 00 00       	call   8002d2 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800170:	a1 20 20 80 00       	mov    0x802020,%eax
  800175:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80017b:	a1 20 20 80 00       	mov    0x802020,%eax
  800180:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800186:	a1 20 20 80 00       	mov    0x802020,%eax
  80018b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800191:	51                   	push   %ecx
  800192:	52                   	push   %edx
  800193:	50                   	push   %eax
  800194:	68 90 19 80 00       	push   $0x801990
  800199:	e8 34 01 00 00       	call   8002d2 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a1:	a1 20 20 80 00       	mov    0x802020,%eax
  8001a6:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	50                   	push   %eax
  8001b0:	68 e8 19 80 00       	push   $0x8019e8
  8001b5:	e8 18 01 00 00       	call   8002d2 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 40 19 80 00       	push   $0x801940
  8001c5:	e8 08 01 00 00       	call   8002d2 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001cd:	e8 7d 10 00 00       	call   80124f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001d2:	e8 19 00 00 00       	call   8001f0 <exit>
}
  8001d7:	90                   	nop
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    

008001da <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	6a 00                	push   $0x0
  8001e5:	e8 0a 12 00 00       	call   8013f4 <sys_destroy_env>
  8001ea:	83 c4 10             	add    $0x10,%esp
}
  8001ed:	90                   	nop
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <exit>:

void
exit(void)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f6:	e8 5f 12 00 00       	call   80145a <sys_exit_env>
}
  8001fb:	90                   	nop
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	8b 00                	mov    (%eax),%eax
  800209:	8d 48 01             	lea    0x1(%eax),%ecx
  80020c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020f:	89 0a                	mov    %ecx,(%edx)
  800211:	8b 55 08             	mov    0x8(%ebp),%edx
  800214:	88 d1                	mov    %dl,%cl
  800216:	8b 55 0c             	mov    0xc(%ebp),%edx
  800219:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80021d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	3d ff 00 00 00       	cmp    $0xff,%eax
  800227:	75 2c                	jne    800255 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800229:	a0 24 20 80 00       	mov    0x802024,%al
  80022e:	0f b6 c0             	movzbl %al,%eax
  800231:	8b 55 0c             	mov    0xc(%ebp),%edx
  800234:	8b 12                	mov    (%edx),%edx
  800236:	89 d1                	mov    %edx,%ecx
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	83 c2 08             	add    $0x8,%edx
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	50                   	push   %eax
  800242:	51                   	push   %ecx
  800243:	52                   	push   %edx
  800244:	e8 3e 0e 00 00       	call   801087 <sys_cputs>
  800249:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
  800258:	8b 40 04             	mov    0x4(%eax),%eax
  80025b:	8d 50 01             	lea    0x1(%eax),%edx
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	89 50 04             	mov    %edx,0x4(%eax)
}
  800264:	90                   	nop
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800270:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800277:	00 00 00 
	b.cnt = 0;
  80027a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800281:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800284:	ff 75 0c             	pushl  0xc(%ebp)
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800290:	50                   	push   %eax
  800291:	68 fe 01 80 00       	push   $0x8001fe
  800296:	e8 11 02 00 00       	call   8004ac <vprintfmt>
  80029b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80029e:	a0 24 20 80 00       	mov    0x802024,%al
  8002a3:	0f b6 c0             	movzbl %al,%eax
  8002a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	50                   	push   %eax
  8002b0:	52                   	push   %edx
  8002b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b7:	83 c0 08             	add    $0x8,%eax
  8002ba:	50                   	push   %eax
  8002bb:	e8 c7 0d 00 00       	call   801087 <sys_cputs>
  8002c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002c3:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002d8:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ee:	50                   	push   %eax
  8002ef:	e8 73 ff ff ff       	call   800267 <vcprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800305:	e8 2b 0f 00 00       	call   801235 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	83 ec 08             	sub    $0x8,%esp
  800316:	ff 75 f4             	pushl  -0xc(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 48 ff ff ff       	call   800267 <vcprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800325:	e8 25 0f 00 00       	call   80124f <sys_enable_interrupt>
	return cnt;
  80032a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	53                   	push   %ebx
  800333:	83 ec 14             	sub    $0x14,%esp
  800336:	8b 45 10             	mov    0x10(%ebp),%eax
  800339:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800342:	8b 45 18             	mov    0x18(%ebp),%eax
  800345:	ba 00 00 00 00       	mov    $0x0,%edx
  80034a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034d:	77 55                	ja     8003a4 <printnum+0x75>
  80034f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800352:	72 05                	jb     800359 <printnum+0x2a>
  800354:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800357:	77 4b                	ja     8003a4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800359:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80035c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035f:	8b 45 18             	mov    0x18(%ebp),%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	52                   	push   %edx
  800368:	50                   	push   %eax
  800369:	ff 75 f4             	pushl  -0xc(%ebp)
  80036c:	ff 75 f0             	pushl  -0x10(%ebp)
  80036f:	e8 48 13 00 00       	call   8016bc <__udivdi3>
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	ff 75 20             	pushl  0x20(%ebp)
  80037d:	53                   	push   %ebx
  80037e:	ff 75 18             	pushl  0x18(%ebp)
  800381:	52                   	push   %edx
  800382:	50                   	push   %eax
  800383:	ff 75 0c             	pushl  0xc(%ebp)
  800386:	ff 75 08             	pushl  0x8(%ebp)
  800389:	e8 a1 ff ff ff       	call   80032f <printnum>
  80038e:	83 c4 20             	add    $0x20,%esp
  800391:	eb 1a                	jmp    8003ad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	ff 75 0c             	pushl  0xc(%ebp)
  800399:	ff 75 20             	pushl  0x20(%ebp)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	ff d0                	call   *%eax
  8003a1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a4:	ff 4d 1c             	decl   0x1c(%ebp)
  8003a7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003ab:	7f e6                	jg     800393 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003bb:	53                   	push   %ebx
  8003bc:	51                   	push   %ecx
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	e8 08 14 00 00       	call   8017cc <__umoddi3>
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	05 14 1c 80 00       	add    $0x801c14,%eax
  8003cc:	8a 00                	mov    (%eax),%al
  8003ce:	0f be c0             	movsbl %al,%eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	ff d0                	call   *%eax
  8003dd:	83 c4 10             	add    $0x10,%esp
}
  8003e0:	90                   	nop
  8003e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ed:	7e 1c                	jle    80040b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 08             	lea    0x8(%eax),%edx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	8b 00                	mov    (%eax),%eax
  800401:	83 e8 08             	sub    $0x8,%eax
  800404:	8b 50 04             	mov    0x4(%eax),%edx
  800407:	8b 00                	mov    (%eax),%eax
  800409:	eb 40                	jmp    80044b <getuint+0x65>
	else if (lflag)
  80040b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040f:	74 1e                	je     80042f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	8d 50 04             	lea    0x4(%eax),%edx
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	89 10                	mov    %edx,(%eax)
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	83 e8 04             	sub    $0x4,%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	ba 00 00 00 00       	mov    $0x0,%edx
  80042d:	eb 1c                	jmp    80044b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	8d 50 04             	lea    0x4(%eax),%edx
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	89 10                	mov    %edx,(%eax)
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	83 e8 04             	sub    $0x4,%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800450:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800454:	7e 1c                	jle    800472 <getint+0x25>
		return va_arg(*ap, long long);
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	8d 50 08             	lea    0x8(%eax),%edx
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	89 10                	mov    %edx,(%eax)
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 e8 08             	sub    $0x8,%eax
  80046b:	8b 50 04             	mov    0x4(%eax),%edx
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	eb 38                	jmp    8004aa <getint+0x5d>
	else if (lflag)
  800472:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800476:	74 1a                	je     800492 <getint+0x45>
		return va_arg(*ap, long);
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	8d 50 04             	lea    0x4(%eax),%edx
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	89 10                	mov    %edx,(%eax)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	83 e8 04             	sub    $0x4,%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	99                   	cltd   
  800490:	eb 18                	jmp    8004aa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	8d 50 04             	lea    0x4(%eax),%edx
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 10                	mov    %edx,(%eax)
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 e8 04             	sub    $0x4,%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	99                   	cltd   
}
  8004aa:	5d                   	pop    %ebp
  8004ab:	c3                   	ret    

008004ac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	56                   	push   %esi
  8004b0:	53                   	push   %ebx
  8004b1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b4:	eb 17                	jmp    8004cd <vprintfmt+0x21>
			if (ch == '\0')
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	0f 84 af 03 00 00    	je     80086d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	53                   	push   %ebx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	ff d0                	call   *%eax
  8004ca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d0:	8d 50 01             	lea    0x1(%eax),%edx
  8004d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d6:	8a 00                	mov    (%eax),%al
  8004d8:	0f b6 d8             	movzbl %al,%ebx
  8004db:	83 fb 25             	cmp    $0x25,%ebx
  8004de:	75 d6                	jne    8004b6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004e0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004eb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 45 10             	mov    0x10(%ebp),%eax
  800503:	8d 50 01             	lea    0x1(%eax),%edx
  800506:	89 55 10             	mov    %edx,0x10(%ebp)
  800509:	8a 00                	mov    (%eax),%al
  80050b:	0f b6 d8             	movzbl %al,%ebx
  80050e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800511:	83 f8 55             	cmp    $0x55,%eax
  800514:	0f 87 2b 03 00 00    	ja     800845 <vprintfmt+0x399>
  80051a:	8b 04 85 38 1c 80 00 	mov    0x801c38(,%eax,4),%eax
  800521:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800523:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800527:	eb d7                	jmp    800500 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800529:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80052d:	eb d1                	jmp    800500 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800536:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800539:	89 d0                	mov    %edx,%eax
  80053b:	c1 e0 02             	shl    $0x2,%eax
  80053e:	01 d0                	add    %edx,%eax
  800540:	01 c0                	add    %eax,%eax
  800542:	01 d8                	add    %ebx,%eax
  800544:	83 e8 30             	sub    $0x30,%eax
  800547:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8a 00                	mov    (%eax),%al
  80054f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800552:	83 fb 2f             	cmp    $0x2f,%ebx
  800555:	7e 3e                	jle    800595 <vprintfmt+0xe9>
  800557:	83 fb 39             	cmp    $0x39,%ebx
  80055a:	7f 39                	jg     800595 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80055f:	eb d5                	jmp    800536 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	83 c0 04             	add    $0x4,%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	83 e8 04             	sub    $0x4,%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800575:	eb 1f                	jmp    800596 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057b:	79 83                	jns    800500 <vprintfmt+0x54>
				width = 0;
  80057d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800584:	e9 77 ff ff ff       	jmp    800500 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800589:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800590:	e9 6b ff ff ff       	jmp    800500 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800595:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800596:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059a:	0f 89 60 ff ff ff    	jns    800500 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005ad:	e9 4e ff ff ff       	jmp    800500 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b5:	e9 46 ff ff ff       	jmp    800500 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	83 c0 04             	add    $0x4,%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	83 e8 04             	sub    $0x4,%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	ff 75 0c             	pushl  0xc(%ebp)
  8005d1:	50                   	push   %eax
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	ff d0                	call   *%eax
  8005d7:	83 c4 10             	add    $0x10,%esp
			break;
  8005da:	e9 89 02 00 00       	jmp    800868 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	83 c0 04             	add    $0x4,%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 e8 04             	sub    $0x4,%eax
  8005ee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005f0:	85 db                	test   %ebx,%ebx
  8005f2:	79 02                	jns    8005f6 <vprintfmt+0x14a>
				err = -err;
  8005f4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005f6:	83 fb 64             	cmp    $0x64,%ebx
  8005f9:	7f 0b                	jg     800606 <vprintfmt+0x15a>
  8005fb:	8b 34 9d 80 1a 80 00 	mov    0x801a80(,%ebx,4),%esi
  800602:	85 f6                	test   %esi,%esi
  800604:	75 19                	jne    80061f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800606:	53                   	push   %ebx
  800607:	68 25 1c 80 00       	push   $0x801c25
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	ff 75 08             	pushl  0x8(%ebp)
  800612:	e8 5e 02 00 00       	call   800875 <printfmt>
  800617:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80061a:	e9 49 02 00 00       	jmp    800868 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061f:	56                   	push   %esi
  800620:	68 2e 1c 80 00       	push   $0x801c2e
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 08             	pushl  0x8(%ebp)
  80062b:	e8 45 02 00 00       	call   800875 <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			break;
  800633:	e9 30 02 00 00       	jmp    800868 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	83 c0 04             	add    $0x4,%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	83 e8 04             	sub    $0x4,%eax
  800647:	8b 30                	mov    (%eax),%esi
  800649:	85 f6                	test   %esi,%esi
  80064b:	75 05                	jne    800652 <vprintfmt+0x1a6>
				p = "(null)";
  80064d:	be 31 1c 80 00       	mov    $0x801c31,%esi
			if (width > 0 && padc != '-')
  800652:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800656:	7e 6d                	jle    8006c5 <vprintfmt+0x219>
  800658:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80065c:	74 67                	je     8006c5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	56                   	push   %esi
  800666:	e8 0c 03 00 00       	call   800977 <strnlen>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800671:	eb 16                	jmp    800689 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800673:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	50                   	push   %eax
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800686:	ff 4d e4             	decl   -0x1c(%ebp)
  800689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068d:	7f e4                	jg     800673 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068f:	eb 34                	jmp    8006c5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800691:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800695:	74 1c                	je     8006b3 <vprintfmt+0x207>
  800697:	83 fb 1f             	cmp    $0x1f,%ebx
  80069a:	7e 05                	jle    8006a1 <vprintfmt+0x1f5>
  80069c:	83 fb 7e             	cmp    $0x7e,%ebx
  80069f:	7e 12                	jle    8006b3 <vprintfmt+0x207>
					putch('?', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	6a 3f                	push   $0x3f
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	ff d0                	call   *%eax
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	eb 0f                	jmp    8006c2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	53                   	push   %ebx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	8d 70 01             	lea    0x1(%eax),%esi
  8006ca:	8a 00                	mov    (%eax),%al
  8006cc:	0f be d8             	movsbl %al,%ebx
  8006cf:	85 db                	test   %ebx,%ebx
  8006d1:	74 24                	je     8006f7 <vprintfmt+0x24b>
  8006d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d7:	78 b8                	js     800691 <vprintfmt+0x1e5>
  8006d9:	ff 4d e0             	decl   -0x20(%ebp)
  8006dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e0:	79 af                	jns    800691 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e2:	eb 13                	jmp    8006f7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	6a 20                	push   $0x20
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fb:	7f e7                	jg     8006e4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006fd:	e9 66 01 00 00       	jmp    800868 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	ff 75 e8             	pushl  -0x18(%ebp)
  800708:	8d 45 14             	lea    0x14(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	e8 3c fd ff ff       	call   80044d <getint>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800717:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80071a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800720:	85 d2                	test   %edx,%edx
  800722:	79 23                	jns    800747 <vprintfmt+0x29b>
				putch('-', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	6a 2d                	push   $0x2d
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	f7 d8                	neg    %eax
  80073c:	83 d2 00             	adc    $0x0,%edx
  80073f:	f7 da                	neg    %edx
  800741:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800744:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800747:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074e:	e9 bc 00 00 00       	jmp    80080f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 e8             	pushl  -0x18(%ebp)
  800759:	8d 45 14             	lea    0x14(%ebp),%eax
  80075c:	50                   	push   %eax
  80075d:	e8 84 fc ff ff       	call   8003e6 <getuint>
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800768:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80076b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800772:	e9 98 00 00 00       	jmp    80080f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	6a 58                	push   $0x58
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 58                	push   $0x58
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 58                	push   $0x58
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			break;
  8007a7:	e9 bc 00 00 00       	jmp    800868 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	6a 30                	push   $0x30
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	6a 78                	push   $0x78
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	83 c0 04             	add    $0x4,%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	83 e8 04             	sub    $0x4,%eax
  8007db:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007e7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ee:	eb 1f                	jmp    80080f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f9:	50                   	push   %eax
  8007fa:	e8 e7 fb ff ff       	call   8003e6 <getuint>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800805:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800808:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800816:	83 ec 04             	sub    $0x4,%esp
  800819:	52                   	push   %edx
  80081a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80081d:	50                   	push   %eax
  80081e:	ff 75 f4             	pushl  -0xc(%ebp)
  800821:	ff 75 f0             	pushl  -0x10(%ebp)
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	ff 75 08             	pushl  0x8(%ebp)
  80082a:	e8 00 fb ff ff       	call   80032f <printnum>
  80082f:	83 c4 20             	add    $0x20,%esp
			break;
  800832:	eb 34                	jmp    800868 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	53                   	push   %ebx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	ff d0                	call   *%eax
  800840:	83 c4 10             	add    $0x10,%esp
			break;
  800843:	eb 23                	jmp    800868 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	6a 25                	push   $0x25
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800855:	ff 4d 10             	decl   0x10(%ebp)
  800858:	eb 03                	jmp    80085d <vprintfmt+0x3b1>
  80085a:	ff 4d 10             	decl   0x10(%ebp)
  80085d:	8b 45 10             	mov    0x10(%ebp),%eax
  800860:	48                   	dec    %eax
  800861:	8a 00                	mov    (%eax),%al
  800863:	3c 25                	cmp    $0x25,%al
  800865:	75 f3                	jne    80085a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800867:	90                   	nop
		}
	}
  800868:	e9 47 fc ff ff       	jmp    8004b4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80086d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80086e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800871:	5b                   	pop    %ebx
  800872:	5e                   	pop    %esi
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80087b:	8d 45 10             	lea    0x10(%ebp),%eax
  80087e:	83 c0 04             	add    $0x4,%eax
  800881:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800884:	8b 45 10             	mov    0x10(%ebp),%eax
  800887:	ff 75 f4             	pushl  -0xc(%ebp)
  80088a:	50                   	push   %eax
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	ff 75 08             	pushl  0x8(%ebp)
  800891:	e8 16 fc ff ff       	call   8004ac <vprintfmt>
  800896:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800899:	90                   	nop
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80089f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a2:	8b 40 08             	mov    0x8(%eax),%eax
  8008a5:	8d 50 01             	lea    0x1(%eax),%edx
  8008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b1:	8b 10                	mov    (%eax),%edx
  8008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b6:	8b 40 04             	mov    0x4(%eax),%eax
  8008b9:	39 c2                	cmp    %eax,%edx
  8008bb:	73 12                	jae    8008cf <sprintputch+0x33>
		*b->buf++ = ch;
  8008bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c8:	89 0a                	mov    %ecx,(%edx)
  8008ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8008cd:	88 10                	mov    %dl,(%eax)
}
  8008cf:	90                   	nop
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	01 d0                	add    %edx,%eax
  8008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f7:	74 06                	je     8008ff <vsnprintf+0x2d>
  8008f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fd:	7f 07                	jg     800906 <vsnprintf+0x34>
		return -E_INVAL;
  8008ff:	b8 03 00 00 00       	mov    $0x3,%eax
  800904:	eb 20                	jmp    800926 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800906:	ff 75 14             	pushl  0x14(%ebp)
  800909:	ff 75 10             	pushl  0x10(%ebp)
  80090c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090f:	50                   	push   %eax
  800910:	68 9c 08 80 00       	push   $0x80089c
  800915:	e8 92 fb ff ff       	call   8004ac <vprintfmt>
  80091a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80091d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800920:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800923:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800926:	c9                   	leave  
  800927:	c3                   	ret    

00800928 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092e:	8d 45 10             	lea    0x10(%ebp),%eax
  800931:	83 c0 04             	add    $0x4,%eax
  800934:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800937:	8b 45 10             	mov    0x10(%ebp),%eax
  80093a:	ff 75 f4             	pushl  -0xc(%ebp)
  80093d:	50                   	push   %eax
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 08             	pushl  0x8(%ebp)
  800944:	e8 89 ff ff ff       	call   8008d2 <vsnprintf>
  800949:	83 c4 10             	add    $0x10,%esp
  80094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80095a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800961:	eb 06                	jmp    800969 <strlen+0x15>
		n++;
  800963:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	ff 45 08             	incl   0x8(%ebp)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8a 00                	mov    (%eax),%al
  80096e:	84 c0                	test   %al,%al
  800970:	75 f1                	jne    800963 <strlen+0xf>
		n++;
	return n;
  800972:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800984:	eb 09                	jmp    80098f <strnlen+0x18>
		n++;
  800986:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800989:	ff 45 08             	incl   0x8(%ebp)
  80098c:	ff 4d 0c             	decl   0xc(%ebp)
  80098f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800993:	74 09                	je     80099e <strnlen+0x27>
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8a 00                	mov    (%eax),%al
  80099a:	84 c0                	test   %al,%al
  80099c:	75 e8                	jne    800986 <strnlen+0xf>
		n++;
	return n;
  80099e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009af:	90                   	nop
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c2:	8a 12                	mov    (%edx),%dl
  8009c4:	88 10                	mov    %dl,(%eax)
  8009c6:	8a 00                	mov    (%eax),%al
  8009c8:	84 c0                	test   %al,%al
  8009ca:	75 e4                	jne    8009b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e4:	eb 1f                	jmp    800a05 <strncpy+0x34>
		*dst++ = *src;
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	8a 12                	mov    (%edx),%dl
  8009f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	8a 00                	mov    (%eax),%al
  8009fb:	84 c0                	test   %al,%al
  8009fd:	74 03                	je     800a02 <strncpy+0x31>
			src++;
  8009ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a02:	ff 45 fc             	incl   -0x4(%ebp)
  800a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a08:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a0b:	72 d9                	jb     8009e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a22:	74 30                	je     800a54 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a24:	eb 16                	jmp    800a3c <strlcpy+0x2a>
			*dst++ = *src++;
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a3c:	ff 4d 10             	decl   0x10(%ebp)
  800a3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a43:	74 09                	je     800a4e <strlcpy+0x3c>
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8a 00                	mov    (%eax),%al
  800a4a:	84 c0                	test   %al,%al
  800a4c:	75 d8                	jne    800a26 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a54:	8b 55 08             	mov    0x8(%ebp),%edx
  800a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a5a:	29 c2                	sub    %eax,%edx
  800a5c:	89 d0                	mov    %edx,%eax
}
  800a5e:	c9                   	leave  
  800a5f:	c3                   	ret    

00800a60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a63:	eb 06                	jmp    800a6b <strcmp+0xb>
		p++, q++;
  800a65:	ff 45 08             	incl   0x8(%ebp)
  800a68:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	84 c0                	test   %al,%al
  800a72:	74 0e                	je     800a82 <strcmp+0x22>
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8a 10                	mov    (%eax),%dl
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	8a 00                	mov    (%eax),%al
  800a7e:	38 c2                	cmp    %al,%dl
  800a80:	74 e3                	je     800a65 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	0f b6 d0             	movzbl %al,%edx
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	0f b6 c0             	movzbl %al,%eax
  800a92:	29 c2                	sub    %eax,%edx
  800a94:	89 d0                	mov    %edx,%eax
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a9b:	eb 09                	jmp    800aa6 <strncmp+0xe>
		n--, p++, q++;
  800a9d:	ff 4d 10             	decl   0x10(%ebp)
  800aa0:	ff 45 08             	incl   0x8(%ebp)
  800aa3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aaa:	74 17                	je     800ac3 <strncmp+0x2b>
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	84 c0                	test   %al,%al
  800ab3:	74 0e                	je     800ac3 <strncmp+0x2b>
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	8a 10                	mov    (%eax),%dl
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	38 c2                	cmp    %al,%dl
  800ac1:	74 da                	je     800a9d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ac3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac7:	75 07                	jne    800ad0 <strncmp+0x38>
		return 0;
  800ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ace:	eb 14                	jmp    800ae4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	0f b6 d0             	movzbl %al,%edx
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	0f b6 c0             	movzbl %al,%eax
  800ae0:	29 c2                	sub    %eax,%edx
  800ae2:	89 d0                	mov    %edx,%eax
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 04             	sub    $0x4,%esp
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800af2:	eb 12                	jmp    800b06 <strchr+0x20>
		if (*s == c)
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800afc:	75 05                	jne    800b03 <strchr+0x1d>
			return (char *) s;
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	eb 11                	jmp    800b14 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b03:	ff 45 08             	incl   0x8(%ebp)
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	84 c0                	test   %al,%al
  800b0d:	75 e5                	jne    800af4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b22:	eb 0d                	jmp    800b31 <strfind+0x1b>
		if (*s == c)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8a 00                	mov    (%eax),%al
  800b29:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b2c:	74 0e                	je     800b3c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2e:	ff 45 08             	incl   0x8(%ebp)
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	75 ea                	jne    800b24 <strfind+0xe>
  800b3a:	eb 01                	jmp    800b3d <strfind+0x27>
		if (*s == c)
			break;
  800b3c:	90                   	nop
	return (char *) s;
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    

00800b42 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b54:	eb 0e                	jmp    800b64 <memset+0x22>
		*p++ = c;
  800b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b59:	8d 50 01             	lea    0x1(%eax),%edx
  800b5c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b62:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b64:	ff 4d f8             	decl   -0x8(%ebp)
  800b67:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b6b:	79 e9                	jns    800b56 <memset+0x14>
		*p++ = c;

	return v;
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b84:	eb 16                	jmp    800b9c <memcpy+0x2a>
		*d++ = *s++;
  800b86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b89:	8d 50 01             	lea    0x1(%eax),%edx
  800b8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b95:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b98:	8a 12                	mov    (%edx),%dl
  800b9a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	75 dd                	jne    800b86 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc6:	73 50                	jae    800c18 <memmove+0x6a>
  800bc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	01 d0                	add    %edx,%eax
  800bd0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd3:	76 43                	jbe    800c18 <memmove+0x6a>
		s += n;
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bde:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800be1:	eb 10                	jmp    800bf3 <memmove+0x45>
			*--d = *--s;
  800be3:	ff 4d f8             	decl   -0x8(%ebp)
  800be6:	ff 4d fc             	decl   -0x4(%ebp)
  800be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bec:	8a 10                	mov    (%eax),%dl
  800bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	75 e3                	jne    800be3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c00:	eb 23                	jmp    800c25 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c11:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c14:	8a 12                	mov    (%edx),%dl
  800c16:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c18:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	75 dd                	jne    800c02 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c3c:	eb 2a                	jmp    800c68 <memcmp+0x3e>
		if (*s1 != *s2)
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c41:	8a 10                	mov    (%eax),%dl
  800c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	38 c2                	cmp    %al,%dl
  800c4a:	74 16                	je     800c62 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	0f b6 d0             	movzbl %al,%edx
  800c54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f b6 c0             	movzbl %al,%eax
  800c5c:	29 c2                	sub    %eax,%edx
  800c5e:	89 d0                	mov    %edx,%eax
  800c60:	eb 18                	jmp    800c7a <memcmp+0x50>
		s1++, s2++;
  800c62:	ff 45 fc             	incl   -0x4(%ebp)
  800c65:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c68:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	75 c9                	jne    800c3e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 d0                	add    %edx,%eax
  800c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c8d:	eb 15                	jmp    800ca4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	0f b6 d0             	movzbl %al,%edx
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	0f b6 c0             	movzbl %al,%eax
  800c9d:	39 c2                	cmp    %eax,%edx
  800c9f:	74 0d                	je     800cae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800caa:	72 e3                	jb     800c8f <memfind+0x13>
  800cac:	eb 01                	jmp    800caf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cae:	90                   	nop
	return (void *) s;
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cc1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc8:	eb 03                	jmp    800ccd <strtol+0x19>
		s++;
  800cca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	3c 20                	cmp    $0x20,%al
  800cd4:	74 f4                	je     800cca <strtol+0x16>
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 09                	cmp    $0x9,%al
  800cdd:	74 eb                	je     800cca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	3c 2b                	cmp    $0x2b,%al
  800ce6:	75 05                	jne    800ced <strtol+0x39>
		s++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	eb 13                	jmp    800d00 <strtol+0x4c>
	else if (*s == '-')
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	3c 2d                	cmp    $0x2d,%al
  800cf4:	75 0a                	jne    800d00 <strtol+0x4c>
		s++, neg = 1;
  800cf6:	ff 45 08             	incl   0x8(%ebp)
  800cf9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	74 06                	je     800d0c <strtol+0x58>
  800d06:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d0a:	75 20                	jne    800d2c <strtol+0x78>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	3c 30                	cmp    $0x30,%al
  800d13:	75 17                	jne    800d2c <strtol+0x78>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	40                   	inc    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 78                	cmp    $0x78,%al
  800d1d:	75 0d                	jne    800d2c <strtol+0x78>
		s += 2, base = 16;
  800d1f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d23:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d2a:	eb 28                	jmp    800d54 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d30:	75 15                	jne    800d47 <strtol+0x93>
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 30                	cmp    $0x30,%al
  800d39:	75 0c                	jne    800d47 <strtol+0x93>
		s++, base = 8;
  800d3b:	ff 45 08             	incl   0x8(%ebp)
  800d3e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d45:	eb 0d                	jmp    800d54 <strtol+0xa0>
	else if (base == 0)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	75 07                	jne    800d54 <strtol+0xa0>
		base = 10;
  800d4d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	3c 2f                	cmp    $0x2f,%al
  800d5b:	7e 19                	jle    800d76 <strtol+0xc2>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	3c 39                	cmp    $0x39,%al
  800d64:	7f 10                	jg     800d76 <strtol+0xc2>
			dig = *s - '0';
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	0f be c0             	movsbl %al,%eax
  800d6e:	83 e8 30             	sub    $0x30,%eax
  800d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d74:	eb 42                	jmp    800db8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 60                	cmp    $0x60,%al
  800d7d:	7e 19                	jle    800d98 <strtol+0xe4>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 7a                	cmp    $0x7a,%al
  800d86:	7f 10                	jg     800d98 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f be c0             	movsbl %al,%eax
  800d90:	83 e8 57             	sub    $0x57,%eax
  800d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d96:	eb 20                	jmp    800db8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	3c 40                	cmp    $0x40,%al
  800d9f:	7e 39                	jle    800dda <strtol+0x126>
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	3c 5a                	cmp    $0x5a,%al
  800da8:	7f 30                	jg     800dda <strtol+0x126>
			dig = *s - 'A' + 10;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	0f be c0             	movsbl %al,%eax
  800db2:	83 e8 37             	sub    $0x37,%eax
  800db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbe:	7d 19                	jge    800dd9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dca:	89 c2                	mov    %eax,%edx
  800dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dd4:	e9 7b ff ff ff       	jmp    800d54 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dd9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dde:	74 08                	je     800de8 <strtol+0x134>
		*endptr = (char *) s;
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800de8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dec:	74 07                	je     800df5 <strtol+0x141>
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	f7 d8                	neg    %eax
  800df3:	eb 03                	jmp    800df8 <strtol+0x144>
  800df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <ltostr>:

void
ltostr(long value, char *str)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e07:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e12:	79 13                	jns    800e27 <ltostr+0x2d>
	{
		neg = 1;
  800e14:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e21:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e24:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e2f:	99                   	cltd   
  800e30:	f7 f9                	idiv   %ecx
  800e32:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e38:	8d 50 01             	lea    0x1(%eax),%edx
  800e3b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3e:	89 c2                	mov    %eax,%edx
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	01 d0                	add    %edx,%eax
  800e45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e48:	83 c2 30             	add    $0x30,%edx
  800e4b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e50:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e55:	f7 e9                	imul   %ecx
  800e57:	c1 fa 02             	sar    $0x2,%edx
  800e5a:	89 c8                	mov    %ecx,%eax
  800e5c:	c1 f8 1f             	sar    $0x1f,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
  800e63:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e69:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e6e:	f7 e9                	imul   %ecx
  800e70:	c1 fa 02             	sar    $0x2,%edx
  800e73:	89 c8                	mov    %ecx,%eax
  800e75:	c1 f8 1f             	sar    $0x1f,%eax
  800e78:	29 c2                	sub    %eax,%edx
  800e7a:	89 d0                	mov    %edx,%eax
  800e7c:	c1 e0 02             	shl    $0x2,%eax
  800e7f:	01 d0                	add    %edx,%eax
  800e81:	01 c0                	add    %eax,%eax
  800e83:	29 c1                	sub    %eax,%ecx
  800e85:	89 ca                	mov    %ecx,%edx
  800e87:	85 d2                	test   %edx,%edx
  800e89:	75 9c                	jne    800e27 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e95:	48                   	dec    %eax
  800e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9d:	74 3d                	je     800edc <ltostr+0xe2>
		start = 1 ;
  800e9f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ea6:	eb 34                	jmp    800edc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	01 c2                	add    %eax,%edx
  800ebd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	01 c8                	add    %ecx,%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	01 c2                	add    %eax,%edx
  800ed1:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ed4:	88 02                	mov    %al,(%edx)
		start++ ;
  800ed6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ed9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ee2:	7c c4                	jl     800ea8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ee4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	01 d0                	add    %edx,%eax
  800eec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eef:	90                   	nop
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	e8 54 fa ff ff       	call   800954 <strlen>
  800f00:	83 c4 04             	add    $0x4,%esp
  800f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	e8 46 fa ff ff       	call   800954 <strlen>
  800f0e:	83 c4 04             	add    $0x4,%esp
  800f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f22:	eb 17                	jmp    800f3b <strcconcat+0x49>
		final[s] = str1[s] ;
  800f24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 c2                	add    %eax,%edx
  800f2c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	01 c8                	add    %ecx,%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f38:	ff 45 fc             	incl   -0x4(%ebp)
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f41:	7c e1                	jl     800f24 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f43:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f51:	eb 1f                	jmp    800f72 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f61:	01 c2                	add    %eax,%edx
  800f63:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	01 c8                	add    %ecx,%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f6f:	ff 45 f8             	incl   -0x8(%ebp)
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f78:	7c d9                	jl     800f53 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	c6 00 00             	movb   $0x0,(%eax)
}
  800f85:	90                   	nop
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f94:	8b 45 14             	mov    0x14(%ebp),%eax
  800f97:	8b 00                	mov    (%eax),%eax
  800f99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	01 d0                	add    %edx,%eax
  800fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fab:	eb 0c                	jmp    800fb9 <strsplit+0x31>
			*string++ = 0;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8d 50 01             	lea    0x1(%eax),%edx
  800fb3:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 18                	je     800fda <strsplit+0x52>
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f be c0             	movsbl %al,%eax
  800fca:	50                   	push   %eax
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	e8 13 fb ff ff       	call   800ae6 <strchr>
  800fd3:	83 c4 08             	add    $0x8,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	75 d3                	jne    800fad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	74 5a                	je     80103d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe6:	8b 00                	mov    (%eax),%eax
  800fe8:	83 f8 0f             	cmp    $0xf,%eax
  800feb:	75 07                	jne    800ff4 <strsplit+0x6c>
		{
			return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff2:	eb 66                	jmp    80105a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff7:	8b 00                	mov    (%eax),%eax
  800ff9:	8d 48 01             	lea    0x1(%eax),%ecx
  800ffc:	8b 55 14             	mov    0x14(%ebp),%edx
  800fff:	89 0a                	mov    %ecx,(%edx)
  801001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801012:	eb 03                	jmp    801017 <strsplit+0x8f>
			string++;
  801014:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	84 c0                	test   %al,%al
  80101e:	74 8b                	je     800fab <strsplit+0x23>
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	e8 b5 fa ff ff       	call   800ae6 <strchr>
  801031:	83 c4 08             	add    $0x8,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	74 dc                	je     801014 <strsplit+0x8c>
			string++;
	}
  801038:	e9 6e ff ff ff       	jmp    800fab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80103d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801055:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	57                   	push   %edi
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
  801062:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80106e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801071:	8b 7d 18             	mov    0x18(%ebp),%edi
  801074:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801077:	cd 30                	int    $0x30
  801079:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 04             	sub    $0x4,%esp
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801093:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	52                   	push   %edx
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	50                   	push   %eax
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 b2 ff ff ff       	call   80105c <syscall>
  8010aa:	83 c4 18             	add    $0x18,%esp
}
  8010ad:	90                   	nop
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 00                	push   $0x0
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 01                	push   $0x1
  8010bf:	e8 98 ff ff ff       	call   80105c <syscall>
  8010c4:	83 c4 18             	add    $0x18,%esp
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 00                	push   $0x0
  8010d8:	52                   	push   %edx
  8010d9:	50                   	push   %eax
  8010da:	6a 05                	push   $0x5
  8010dc:	e8 7b ff ff ff       	call   80105c <syscall>
  8010e1:	83 c4 18             	add    $0x18,%esp
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	56                   	push   %esi
  8010ea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	51                   	push   %ecx
  8010fd:	52                   	push   %edx
  8010fe:	50                   	push   %eax
  8010ff:	6a 06                	push   $0x6
  801101:	e8 56 ff ff ff       	call   80105c <syscall>
  801106:	83 c4 18             	add    $0x18,%esp
}
  801109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801113:	8b 55 0c             	mov    0xc(%ebp),%edx
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	6a 00                	push   $0x0
  80111f:	52                   	push   %edx
  801120:	50                   	push   %eax
  801121:	6a 07                	push   $0x7
  801123:	e8 34 ff ff ff       	call   80105c <syscall>
  801128:	83 c4 18             	add    $0x18,%esp
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801130:	6a 00                	push   $0x0
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	ff 75 08             	pushl  0x8(%ebp)
  80113c:	6a 08                	push   $0x8
  80113e:	e8 19 ff ff ff       	call   80105c <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 09                	push   $0x9
  801157:	e8 00 ff ff ff       	call   80105c <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 0a                	push   $0xa
  801170:	e8 e7 fe ff ff       	call   80105c <syscall>
  801175:	83 c4 18             	add    $0x18,%esp
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 0b                	push   $0xb
  801189:	e8 ce fe ff ff       	call   80105c <syscall>
  80118e:	83 c4 18             	add    $0x18,%esp
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	ff 75 0c             	pushl  0xc(%ebp)
  80119f:	ff 75 08             	pushl  0x8(%ebp)
  8011a2:	6a 0f                	push   $0xf
  8011a4:	e8 b3 fe ff ff       	call   80105c <syscall>
  8011a9:	83 c4 18             	add    $0x18,%esp
	return;
  8011ac:	90                   	nop
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	ff 75 08             	pushl  0x8(%ebp)
  8011be:	6a 10                	push   $0x10
  8011c0:	e8 97 fe ff ff       	call   80105c <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8011c8:	90                   	nop
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	ff 75 10             	pushl  0x10(%ebp)
  8011d5:	ff 75 0c             	pushl  0xc(%ebp)
  8011d8:	ff 75 08             	pushl  0x8(%ebp)
  8011db:	6a 11                	push   $0x11
  8011dd:	e8 7a fe ff ff       	call   80105c <syscall>
  8011e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8011e5:	90                   	nop
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 0c                	push   $0xc
  8011f7:	e8 60 fe ff ff       	call   80105c <syscall>
  8011fc:	83 c4 18             	add    $0x18,%esp
}
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	ff 75 08             	pushl  0x8(%ebp)
  80120f:	6a 0d                	push   $0xd
  801211:	e8 46 fe ff ff       	call   80105c <syscall>
  801216:	83 c4 18             	add    $0x18,%esp
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 0e                	push   $0xe
  80122a:	e8 2d fe ff ff       	call   80105c <syscall>
  80122f:	83 c4 18             	add    $0x18,%esp
}
  801232:	90                   	nop
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 13                	push   $0x13
  801244:	e8 13 fe ff ff       	call   80105c <syscall>
  801249:	83 c4 18             	add    $0x18,%esp
}
  80124c:	90                   	nop
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 14                	push   $0x14
  80125e:	e8 f9 fd ff ff       	call   80105c <syscall>
  801263:	83 c4 18             	add    $0x18,%esp
}
  801266:	90                   	nop
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <sys_cputc>:


void
sys_cputc(const char c)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801275:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	50                   	push   %eax
  801282:	6a 15                	push   $0x15
  801284:	e8 d3 fd ff ff       	call   80105c <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 16                	push   $0x16
  80129e:	e8 b9 fd ff ff       	call   80105c <syscall>
  8012a3:	83 c4 18             	add    $0x18,%esp
}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	ff 75 0c             	pushl  0xc(%ebp)
  8012b8:	50                   	push   %eax
  8012b9:	6a 17                	push   $0x17
  8012bb:	e8 9c fd ff ff       	call   80105c <syscall>
  8012c0:	83 c4 18             	add    $0x18,%esp
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	52                   	push   %edx
  8012d5:	50                   	push   %eax
  8012d6:	6a 1a                	push   $0x1a
  8012d8:	e8 7f fd ff ff       	call   80105c <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	52                   	push   %edx
  8012f2:	50                   	push   %eax
  8012f3:	6a 18                	push   $0x18
  8012f5:	e8 62 fd ff ff       	call   80105c <syscall>
  8012fa:	83 c4 18             	add    $0x18,%esp
}
  8012fd:	90                   	nop
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	52                   	push   %edx
  801310:	50                   	push   %eax
  801311:	6a 19                	push   $0x19
  801313:	e8 44 fd ff ff       	call   80105c <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	90                   	nop
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80132a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80132d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	6a 00                	push   $0x0
  801336:	51                   	push   %ecx
  801337:	52                   	push   %edx
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	50                   	push   %eax
  80133c:	6a 1b                	push   $0x1b
  80133e:	e8 19 fd ff ff       	call   80105c <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	52                   	push   %edx
  801358:	50                   	push   %eax
  801359:	6a 1c                	push   $0x1c
  80135b:	e8 fc fc ff ff       	call   80105c <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	51                   	push   %ecx
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	6a 1d                	push   $0x1d
  80137a:	e8 dd fc ff ff       	call   80105c <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	52                   	push   %edx
  801394:	50                   	push   %eax
  801395:	6a 1e                	push   $0x1e
  801397:	e8 c0 fc ff ff       	call   80105c <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 1f                	push   $0x1f
  8013b0:	e8 a7 fc ff ff       	call   80105c <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	6a 00                	push   $0x0
  8013c2:	ff 75 14             	pushl  0x14(%ebp)
  8013c5:	ff 75 10             	pushl  0x10(%ebp)
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	50                   	push   %eax
  8013cc:	6a 20                	push   $0x20
  8013ce:	e8 89 fc ff ff       	call   80105c <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	50                   	push   %eax
  8013e7:	6a 21                	push   $0x21
  8013e9:	e8 6e fc ff ff       	call   80105c <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	90                   	nop
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	50                   	push   %eax
  801403:	6a 22                	push   $0x22
  801405:	e8 52 fc ff ff       	call   80105c <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 02                	push   $0x2
  80141e:	e8 39 fc ff ff       	call   80105c <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 03                	push   $0x3
  801437:	e8 20 fc ff ff       	call   80105c <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 04                	push   $0x4
  801450:	e8 07 fc ff ff       	call   80105c <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_exit_env>:


void sys_exit_env(void)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 23                	push   $0x23
  801469:	e8 ee fb ff ff       	call   80105c <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80147a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80147d:	8d 50 04             	lea    0x4(%eax),%edx
  801480:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	52                   	push   %edx
  80148a:	50                   	push   %eax
  80148b:	6a 24                	push   $0x24
  80148d:	e8 ca fb ff ff       	call   80105c <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
	return result;
  801495:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801498:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149e:	89 01                	mov    %eax,(%ecx)
  8014a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	c9                   	leave  
  8014a7:	c2 04 00             	ret    $0x4

008014aa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	ff 75 10             	pushl  0x10(%ebp)
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	6a 12                	push   $0x12
  8014bc:	e8 9b fb ff ff       	call   80105c <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c4:	90                   	nop
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 25                	push   $0x25
  8014d6:	e8 81 fb ff ff       	call   80105c <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	50                   	push   %eax
  8014f9:	6a 26                	push   $0x26
  8014fb:	e8 5c fb ff ff       	call   80105c <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
	return ;
  801503:	90                   	nop
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <rsttst>:
void rsttst()
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 28                	push   $0x28
  801515:	e8 42 fb ff ff       	call   80105c <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
	return ;
  80151d:	90                   	nop
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80152c:	8b 55 18             	mov    0x18(%ebp),%edx
  80152f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801533:	52                   	push   %edx
  801534:	50                   	push   %eax
  801535:	ff 75 10             	pushl  0x10(%ebp)
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	ff 75 08             	pushl  0x8(%ebp)
  80153e:	6a 27                	push   $0x27
  801540:	e8 17 fb ff ff       	call   80105c <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
	return ;
  801548:	90                   	nop
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <chktst>:
void chktst(uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	6a 29                	push   $0x29
  80155b:	e8 fc fa ff ff       	call   80105c <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
	return ;
  801563:	90                   	nop
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <inctst>:

void inctst()
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 2a                	push   $0x2a
  801575:	e8 e2 fa ff ff       	call   80105c <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
	return ;
  80157d:	90                   	nop
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <gettst>:
uint32 gettst()
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 2b                	push   $0x2b
  80158f:	e8 c8 fa ff ff       	call   80105c <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 2c                	push   $0x2c
  8015ab:	e8 ac fa ff ff       	call   80105c <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
  8015b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015b6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015ba:	75 07                	jne    8015c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c1:	eb 05                	jmp    8015c8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 2c                	push   $0x2c
  8015dc:	e8 7b fa ff ff       	call   80105c <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
  8015e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015e7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015eb:	75 07                	jne    8015f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f2:	eb 05                	jmp    8015f9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 2c                	push   $0x2c
  80160d:	e8 4a fa ff ff       	call   80105c <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801618:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80161c:	75 07                	jne    801625 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80161e:	b8 01 00 00 00       	mov    $0x1,%eax
  801623:	eb 05                	jmp    80162a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 2c                	push   $0x2c
  80163e:	e8 19 fa ff ff       	call   80105c <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
  801646:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801649:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80164d:	75 07                	jne    801656 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80164f:	b8 01 00 00 00       	mov    $0x1,%eax
  801654:	eb 05                	jmp    80165b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	6a 2d                	push   $0x2d
  80166d:	e8 ea f9 ff ff       	call   80105c <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
	return ;
  801675:	90                   	nop
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80167c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	53                   	push   %ebx
  80168b:	51                   	push   %ecx
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	6a 2e                	push   $0x2e
  801690:	e8 c7 f9 ff ff       	call   80105c <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 2f                	push   $0x2f
  8016b0:	e8 a7 f9 ff ff       	call   80105c <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    
  8016ba:	66 90                	xchg   %ax,%ax

008016bc <__udivdi3>:
  8016bc:	55                   	push   %ebp
  8016bd:	57                   	push   %edi
  8016be:	56                   	push   %esi
  8016bf:	53                   	push   %ebx
  8016c0:	83 ec 1c             	sub    $0x1c,%esp
  8016c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016d3:	89 ca                	mov    %ecx,%edx
  8016d5:	89 f8                	mov    %edi,%eax
  8016d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8016db:	85 f6                	test   %esi,%esi
  8016dd:	75 2d                	jne    80170c <__udivdi3+0x50>
  8016df:	39 cf                	cmp    %ecx,%edi
  8016e1:	77 65                	ja     801748 <__udivdi3+0x8c>
  8016e3:	89 fd                	mov    %edi,%ebp
  8016e5:	85 ff                	test   %edi,%edi
  8016e7:	75 0b                	jne    8016f4 <__udivdi3+0x38>
  8016e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ee:	31 d2                	xor    %edx,%edx
  8016f0:	f7 f7                	div    %edi
  8016f2:	89 c5                	mov    %eax,%ebp
  8016f4:	31 d2                	xor    %edx,%edx
  8016f6:	89 c8                	mov    %ecx,%eax
  8016f8:	f7 f5                	div    %ebp
  8016fa:	89 c1                	mov    %eax,%ecx
  8016fc:	89 d8                	mov    %ebx,%eax
  8016fe:	f7 f5                	div    %ebp
  801700:	89 cf                	mov    %ecx,%edi
  801702:	89 fa                	mov    %edi,%edx
  801704:	83 c4 1c             	add    $0x1c,%esp
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5f                   	pop    %edi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    
  80170c:	39 ce                	cmp    %ecx,%esi
  80170e:	77 28                	ja     801738 <__udivdi3+0x7c>
  801710:	0f bd fe             	bsr    %esi,%edi
  801713:	83 f7 1f             	xor    $0x1f,%edi
  801716:	75 40                	jne    801758 <__udivdi3+0x9c>
  801718:	39 ce                	cmp    %ecx,%esi
  80171a:	72 0a                	jb     801726 <__udivdi3+0x6a>
  80171c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801720:	0f 87 9e 00 00 00    	ja     8017c4 <__udivdi3+0x108>
  801726:	b8 01 00 00 00       	mov    $0x1,%eax
  80172b:	89 fa                	mov    %edi,%edx
  80172d:	83 c4 1c             	add    $0x1c,%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    
  801735:	8d 76 00             	lea    0x0(%esi),%esi
  801738:	31 ff                	xor    %edi,%edi
  80173a:	31 c0                	xor    %eax,%eax
  80173c:	89 fa                	mov    %edi,%edx
  80173e:	83 c4 1c             	add    $0x1c,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    
  801746:	66 90                	xchg   %ax,%ax
  801748:	89 d8                	mov    %ebx,%eax
  80174a:	f7 f7                	div    %edi
  80174c:	31 ff                	xor    %edi,%edi
  80174e:	89 fa                	mov    %edi,%edx
  801750:	83 c4 1c             	add    $0x1c,%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5f                   	pop    %edi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    
  801758:	bd 20 00 00 00       	mov    $0x20,%ebp
  80175d:	89 eb                	mov    %ebp,%ebx
  80175f:	29 fb                	sub    %edi,%ebx
  801761:	89 f9                	mov    %edi,%ecx
  801763:	d3 e6                	shl    %cl,%esi
  801765:	89 c5                	mov    %eax,%ebp
  801767:	88 d9                	mov    %bl,%cl
  801769:	d3 ed                	shr    %cl,%ebp
  80176b:	89 e9                	mov    %ebp,%ecx
  80176d:	09 f1                	or     %esi,%ecx
  80176f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801773:	89 f9                	mov    %edi,%ecx
  801775:	d3 e0                	shl    %cl,%eax
  801777:	89 c5                	mov    %eax,%ebp
  801779:	89 d6                	mov    %edx,%esi
  80177b:	88 d9                	mov    %bl,%cl
  80177d:	d3 ee                	shr    %cl,%esi
  80177f:	89 f9                	mov    %edi,%ecx
  801781:	d3 e2                	shl    %cl,%edx
  801783:	8b 44 24 08          	mov    0x8(%esp),%eax
  801787:	88 d9                	mov    %bl,%cl
  801789:	d3 e8                	shr    %cl,%eax
  80178b:	09 c2                	or     %eax,%edx
  80178d:	89 d0                	mov    %edx,%eax
  80178f:	89 f2                	mov    %esi,%edx
  801791:	f7 74 24 0c          	divl   0xc(%esp)
  801795:	89 d6                	mov    %edx,%esi
  801797:	89 c3                	mov    %eax,%ebx
  801799:	f7 e5                	mul    %ebp
  80179b:	39 d6                	cmp    %edx,%esi
  80179d:	72 19                	jb     8017b8 <__udivdi3+0xfc>
  80179f:	74 0b                	je     8017ac <__udivdi3+0xf0>
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	31 ff                	xor    %edi,%edi
  8017a5:	e9 58 ff ff ff       	jmp    801702 <__udivdi3+0x46>
  8017aa:	66 90                	xchg   %ax,%ax
  8017ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017b0:	89 f9                	mov    %edi,%ecx
  8017b2:	d3 e2                	shl    %cl,%edx
  8017b4:	39 c2                	cmp    %eax,%edx
  8017b6:	73 e9                	jae    8017a1 <__udivdi3+0xe5>
  8017b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017bb:	31 ff                	xor    %edi,%edi
  8017bd:	e9 40 ff ff ff       	jmp    801702 <__udivdi3+0x46>
  8017c2:	66 90                	xchg   %ax,%ax
  8017c4:	31 c0                	xor    %eax,%eax
  8017c6:	e9 37 ff ff ff       	jmp    801702 <__udivdi3+0x46>
  8017cb:	90                   	nop

008017cc <__umoddi3>:
  8017cc:	55                   	push   %ebp
  8017cd:	57                   	push   %edi
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 1c             	sub    $0x1c,%esp
  8017d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8017d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8017db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8017e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017eb:	89 f3                	mov    %esi,%ebx
  8017ed:	89 fa                	mov    %edi,%edx
  8017ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017f3:	89 34 24             	mov    %esi,(%esp)
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	75 1a                	jne    801814 <__umoddi3+0x48>
  8017fa:	39 f7                	cmp    %esi,%edi
  8017fc:	0f 86 a2 00 00 00    	jbe    8018a4 <__umoddi3+0xd8>
  801802:	89 c8                	mov    %ecx,%eax
  801804:	89 f2                	mov    %esi,%edx
  801806:	f7 f7                	div    %edi
  801808:	89 d0                	mov    %edx,%eax
  80180a:	31 d2                	xor    %edx,%edx
  80180c:	83 c4 1c             	add    $0x1c,%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5f                   	pop    %edi
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    
  801814:	39 f0                	cmp    %esi,%eax
  801816:	0f 87 ac 00 00 00    	ja     8018c8 <__umoddi3+0xfc>
  80181c:	0f bd e8             	bsr    %eax,%ebp
  80181f:	83 f5 1f             	xor    $0x1f,%ebp
  801822:	0f 84 ac 00 00 00    	je     8018d4 <__umoddi3+0x108>
  801828:	bf 20 00 00 00       	mov    $0x20,%edi
  80182d:	29 ef                	sub    %ebp,%edi
  80182f:	89 fe                	mov    %edi,%esi
  801831:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801835:	89 e9                	mov    %ebp,%ecx
  801837:	d3 e0                	shl    %cl,%eax
  801839:	89 d7                	mov    %edx,%edi
  80183b:	89 f1                	mov    %esi,%ecx
  80183d:	d3 ef                	shr    %cl,%edi
  80183f:	09 c7                	or     %eax,%edi
  801841:	89 e9                	mov    %ebp,%ecx
  801843:	d3 e2                	shl    %cl,%edx
  801845:	89 14 24             	mov    %edx,(%esp)
  801848:	89 d8                	mov    %ebx,%eax
  80184a:	d3 e0                	shl    %cl,%eax
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801852:	d3 e0                	shl    %cl,%eax
  801854:	89 44 24 04          	mov    %eax,0x4(%esp)
  801858:	8b 44 24 08          	mov    0x8(%esp),%eax
  80185c:	89 f1                	mov    %esi,%ecx
  80185e:	d3 e8                	shr    %cl,%eax
  801860:	09 d0                	or     %edx,%eax
  801862:	d3 eb                	shr    %cl,%ebx
  801864:	89 da                	mov    %ebx,%edx
  801866:	f7 f7                	div    %edi
  801868:	89 d3                	mov    %edx,%ebx
  80186a:	f7 24 24             	mull   (%esp)
  80186d:	89 c6                	mov    %eax,%esi
  80186f:	89 d1                	mov    %edx,%ecx
  801871:	39 d3                	cmp    %edx,%ebx
  801873:	0f 82 87 00 00 00    	jb     801900 <__umoddi3+0x134>
  801879:	0f 84 91 00 00 00    	je     801910 <__umoddi3+0x144>
  80187f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801883:	29 f2                	sub    %esi,%edx
  801885:	19 cb                	sbb    %ecx,%ebx
  801887:	89 d8                	mov    %ebx,%eax
  801889:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80188d:	d3 e0                	shl    %cl,%eax
  80188f:	89 e9                	mov    %ebp,%ecx
  801891:	d3 ea                	shr    %cl,%edx
  801893:	09 d0                	or     %edx,%eax
  801895:	89 e9                	mov    %ebp,%ecx
  801897:	d3 eb                	shr    %cl,%ebx
  801899:	89 da                	mov    %ebx,%edx
  80189b:	83 c4 1c             	add    $0x1c,%esp
  80189e:	5b                   	pop    %ebx
  80189f:	5e                   	pop    %esi
  8018a0:	5f                   	pop    %edi
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    
  8018a3:	90                   	nop
  8018a4:	89 fd                	mov    %edi,%ebp
  8018a6:	85 ff                	test   %edi,%edi
  8018a8:	75 0b                	jne    8018b5 <__umoddi3+0xe9>
  8018aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8018af:	31 d2                	xor    %edx,%edx
  8018b1:	f7 f7                	div    %edi
  8018b3:	89 c5                	mov    %eax,%ebp
  8018b5:	89 f0                	mov    %esi,%eax
  8018b7:	31 d2                	xor    %edx,%edx
  8018b9:	f7 f5                	div    %ebp
  8018bb:	89 c8                	mov    %ecx,%eax
  8018bd:	f7 f5                	div    %ebp
  8018bf:	89 d0                	mov    %edx,%eax
  8018c1:	e9 44 ff ff ff       	jmp    80180a <__umoddi3+0x3e>
  8018c6:	66 90                	xchg   %ax,%ax
  8018c8:	89 c8                	mov    %ecx,%eax
  8018ca:	89 f2                	mov    %esi,%edx
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    
  8018d4:	3b 04 24             	cmp    (%esp),%eax
  8018d7:	72 06                	jb     8018df <__umoddi3+0x113>
  8018d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8018dd:	77 0f                	ja     8018ee <__umoddi3+0x122>
  8018df:	89 f2                	mov    %esi,%edx
  8018e1:	29 f9                	sub    %edi,%ecx
  8018e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8018e7:	89 14 24             	mov    %edx,(%esp)
  8018ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018f2:	8b 14 24             	mov    (%esp),%edx
  8018f5:	83 c4 1c             	add    $0x1c,%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5f                   	pop    %edi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    
  8018fd:	8d 76 00             	lea    0x0(%esi),%esi
  801900:	2b 04 24             	sub    (%esp),%eax
  801903:	19 fa                	sbb    %edi,%edx
  801905:	89 d1                	mov    %edx,%ecx
  801907:	89 c6                	mov    %eax,%esi
  801909:	e9 71 ff ff ff       	jmp    80187f <__umoddi3+0xb3>
  80190e:	66 90                	xchg   %ax,%ax
  801910:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801914:	72 ea                	jb     801900 <__umoddi3+0x134>
  801916:	89 d9                	mov    %ebx,%ecx
  801918:	e9 62 ff ff ff       	jmp    80187f <__umoddi3+0xb3>
