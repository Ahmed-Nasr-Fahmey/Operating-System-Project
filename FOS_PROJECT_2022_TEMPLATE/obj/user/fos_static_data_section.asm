
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 c0 18 80 00       	push   $0x8018c0
  800046:	e8 56 02 00 00       	call   8002a1 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 6e 13 00 00       	call   8013ca <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	01 c0                	add    %eax,%eax
  800066:	01 d0                	add    %edx,%eax
  800068:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80006f:	01 c8                	add    %ecx,%eax
  800071:	c1 e0 02             	shl    $0x2,%eax
  800074:	01 d0                	add    %edx,%eax
  800076:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80007d:	01 c8                	add    %ecx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	01 d0                	add    %edx,%eax
  800089:	c1 e0 03             	shl    $0x3,%eax
  80008c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800091:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800096:	a1 20 20 80 00       	mov    0x802020,%eax
  80009b:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0f                	je     8000b4 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8000a5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000aa:	05 18 da 01 00       	add    $0x1da18,%eax
  8000af:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b8:	7e 0a                	jle    8000c4 <libmain+0x73>
		binaryname = argv[0];
  8000ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bd:	8b 00                	mov    (%eax),%eax
  8000bf:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ca:	ff 75 08             	pushl  0x8(%ebp)
  8000cd:	e8 66 ff ff ff       	call   800038 <_main>
  8000d2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d5:	e8 fd 10 00 00       	call   8011d7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 04 19 80 00       	push   $0x801904
  8000e2:	e8 8d 01 00 00       	call   800274 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ea:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ef:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8000f5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000fa:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	52                   	push   %edx
  800104:	50                   	push   %eax
  800105:	68 2c 19 80 00       	push   $0x80192c
  80010a:	e8 65 01 00 00       	call   800274 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800112:	a1 20 20 80 00       	mov    0x802020,%eax
  800117:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80011d:	a1 20 20 80 00       	mov    0x802020,%eax
  800122:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800128:	a1 20 20 80 00       	mov    0x802020,%eax
  80012d:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800133:	51                   	push   %ecx
  800134:	52                   	push   %edx
  800135:	50                   	push   %eax
  800136:	68 54 19 80 00       	push   $0x801954
  80013b:	e8 34 01 00 00       	call   800274 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800143:	a1 20 20 80 00       	mov    0x802020,%eax
  800148:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	50                   	push   %eax
  800152:	68 ac 19 80 00       	push   $0x8019ac
  800157:	e8 18 01 00 00       	call   800274 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	68 04 19 80 00       	push   $0x801904
  800167:	e8 08 01 00 00       	call   800274 <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80016f:	e8 7d 10 00 00       	call   8011f1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800174:	e8 19 00 00 00       	call   800192 <exit>
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	6a 00                	push   $0x0
  800187:	e8 0a 12 00 00       	call   801396 <sys_destroy_env>
  80018c:	83 c4 10             	add    $0x10,%esp
}
  80018f:	90                   	nop
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <exit>:

void
exit(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800198:	e8 5f 12 00 00       	call   8013fc <sys_exit_env>
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a9:	8b 00                	mov    (%eax),%eax
  8001ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	89 0a                	mov    %ecx,(%edx)
  8001b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b6:	88 d1                	mov    %dl,%cl
  8001b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c2:	8b 00                	mov    (%eax),%eax
  8001c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c9:	75 2c                	jne    8001f7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001cb:	a0 24 20 80 00       	mov    0x802024,%al
  8001d0:	0f b6 c0             	movzbl %al,%eax
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	8b 12                	mov    (%edx),%edx
  8001d8:	89 d1                	mov    %edx,%ecx
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	83 c2 08             	add    $0x8,%edx
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	50                   	push   %eax
  8001e4:	51                   	push   %ecx
  8001e5:	52                   	push   %edx
  8001e6:	e8 3e 0e 00 00       	call   801029 <sys_cputs>
  8001eb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fa:	8b 40 04             	mov    0x4(%eax),%eax
  8001fd:	8d 50 01             	lea    0x1(%eax),%edx
  800200:	8b 45 0c             	mov    0xc(%ebp),%eax
  800203:	89 50 04             	mov    %edx,0x4(%eax)
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800212:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800219:	00 00 00 
	b.cnt = 0;
  80021c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800223:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800226:	ff 75 0c             	pushl  0xc(%ebp)
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800232:	50                   	push   %eax
  800233:	68 a0 01 80 00       	push   $0x8001a0
  800238:	e8 11 02 00 00       	call   80044e <vprintfmt>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800240:	a0 24 20 80 00       	mov    0x802024,%al
  800245:	0f b6 c0             	movzbl %al,%eax
  800248:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	50                   	push   %eax
  800252:	52                   	push   %edx
  800253:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800259:	83 c0 08             	add    $0x8,%eax
  80025c:	50                   	push   %eax
  80025d:	e8 c7 0d 00 00       	call   801029 <sys_cputs>
  800262:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800265:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80026c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <cprintf>:

int cprintf(const char *fmt, ...) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80027a:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800281:	8d 45 0c             	lea    0xc(%ebp),%eax
  800284:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	ff 75 f4             	pushl  -0xc(%ebp)
  800290:	50                   	push   %eax
  800291:	e8 73 ff ff ff       	call   800209 <vcprintf>
  800296:	83 c4 10             	add    $0x10,%esp
  800299:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80029c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002a7:	e8 2b 0f 00 00       	call   8011d7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	e8 48 ff ff ff       	call   800209 <vcprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002c7:	e8 25 0f 00 00       	call   8011f1 <sys_enable_interrupt>
	return cnt;
  8002cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	53                   	push   %ebx
  8002d5:	83 ec 14             	sub    $0x14,%esp
  8002d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002de:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ef:	77 55                	ja     800346 <printnum+0x75>
  8002f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f4:	72 05                	jb     8002fb <printnum+0x2a>
  8002f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002f9:	77 4b                	ja     800346 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800301:	8b 45 18             	mov    0x18(%ebp),%eax
  800304:	ba 00 00 00 00       	mov    $0x0,%edx
  800309:	52                   	push   %edx
  80030a:	50                   	push   %eax
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 f0             	pushl  -0x10(%ebp)
  800311:	e8 46 13 00 00       	call   80165c <__udivdi3>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	ff 75 20             	pushl  0x20(%ebp)
  80031f:	53                   	push   %ebx
  800320:	ff 75 18             	pushl  0x18(%ebp)
  800323:	52                   	push   %edx
  800324:	50                   	push   %eax
  800325:	ff 75 0c             	pushl  0xc(%ebp)
  800328:	ff 75 08             	pushl  0x8(%ebp)
  80032b:	e8 a1 ff ff ff       	call   8002d1 <printnum>
  800330:	83 c4 20             	add    $0x20,%esp
  800333:	eb 1a                	jmp    80034f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 20             	pushl  0x20(%ebp)
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	ff d0                	call   *%eax
  800343:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800346:	ff 4d 1c             	decl   0x1c(%ebp)
  800349:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80034d:	7f e6                	jg     800335 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800352:	bb 00 00 00 00       	mov    $0x0,%ebx
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80035d:	53                   	push   %ebx
  80035e:	51                   	push   %ecx
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	e8 06 14 00 00       	call   80176c <__umoddi3>
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	05 d4 1b 80 00       	add    $0x801bd4,%eax
  80036e:	8a 00                	mov    (%eax),%al
  800370:	0f be c0             	movsbl %al,%eax
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	50                   	push   %eax
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	ff d0                	call   *%eax
  80037f:	83 c4 10             	add    $0x10,%esp
}
  800382:	90                   	nop
  800383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80038f:	7e 1c                	jle    8003ad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	8d 50 08             	lea    0x8(%eax),%edx
  800399:	8b 45 08             	mov    0x8(%ebp),%eax
  80039c:	89 10                	mov    %edx,(%eax)
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	83 e8 08             	sub    $0x8,%eax
  8003a6:	8b 50 04             	mov    0x4(%eax),%edx
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	eb 40                	jmp    8003ed <getuint+0x65>
	else if (lflag)
  8003ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b1:	74 1e                	je     8003d1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	8d 50 04             	lea    0x4(%eax),%edx
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	83 e8 04             	sub    $0x4,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cf:	eb 1c                	jmp    8003ed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	8d 50 04             	lea    0x4(%eax),%edx
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	89 10                	mov    %edx,(%eax)
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	83 e8 04             	sub    $0x4,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f6:	7e 1c                	jle    800414 <getint+0x25>
		return va_arg(*ap, long long);
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
  800412:	eb 38                	jmp    80044c <getint+0x5d>
	else if (lflag)
  800414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800418:	74 1a                	je     800434 <getint+0x45>
		return va_arg(*ap, long);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 04             	lea    0x4(%eax),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	83 e8 04             	sub    $0x4,%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	99                   	cltd   
  800432:	eb 18                	jmp    80044c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800434:	8b 45 08             	mov    0x8(%ebp),%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	8d 50 04             	lea    0x4(%eax),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	89 10                	mov    %edx,(%eax)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	83 e8 04             	sub    $0x4,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	99                   	cltd   
}
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	56                   	push   %esi
  800452:	53                   	push   %ebx
  800453:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800456:	eb 17                	jmp    80046f <vprintfmt+0x21>
			if (ch == '\0')
  800458:	85 db                	test   %ebx,%ebx
  80045a:	0f 84 af 03 00 00    	je     80080f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	53                   	push   %ebx
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	ff d0                	call   *%eax
  80046c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046f:	8b 45 10             	mov    0x10(%ebp),%eax
  800472:	8d 50 01             	lea    0x1(%eax),%edx
  800475:	89 55 10             	mov    %edx,0x10(%ebp)
  800478:	8a 00                	mov    (%eax),%al
  80047a:	0f b6 d8             	movzbl %al,%ebx
  80047d:	83 fb 25             	cmp    $0x25,%ebx
  800480:	75 d6                	jne    800458 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800482:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800486:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80048d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800494:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80049b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ab:	8a 00                	mov    (%eax),%al
  8004ad:	0f b6 d8             	movzbl %al,%ebx
  8004b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b3:	83 f8 55             	cmp    $0x55,%eax
  8004b6:	0f 87 2b 03 00 00    	ja     8007e7 <vprintfmt+0x399>
  8004bc:	8b 04 85 f8 1b 80 00 	mov    0x801bf8(,%eax,4),%eax
  8004c3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004c9:	eb d7                	jmp    8004a2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004cb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004cf:	eb d1                	jmp    8004a2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	c1 e0 02             	shl    $0x2,%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	01 c0                	add    %eax,%eax
  8004e4:	01 d8                	add    %ebx,%eax
  8004e6:	83 e8 30             	sub    $0x30,%eax
  8004e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	8a 00                	mov    (%eax),%al
  8004f1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f4:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f7:	7e 3e                	jle    800537 <vprintfmt+0xe9>
  8004f9:	83 fb 39             	cmp    $0x39,%ebx
  8004fc:	7f 39                	jg     800537 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800501:	eb d5                	jmp    8004d8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	83 c0 04             	add    $0x4,%eax
  800509:	89 45 14             	mov    %eax,0x14(%ebp)
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	83 e8 04             	sub    $0x4,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800517:	eb 1f                	jmp    800538 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800519:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051d:	79 83                	jns    8004a2 <vprintfmt+0x54>
				width = 0;
  80051f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800526:	e9 77 ff ff ff       	jmp    8004a2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80052b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800532:	e9 6b ff ff ff       	jmp    8004a2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800537:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053c:	0f 89 60 ff ff ff    	jns    8004a2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800548:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80054f:	e9 4e ff ff ff       	jmp    8004a2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800554:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800557:	e9 46 ff ff ff       	jmp    8004a2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	83 c0 04             	add    $0x4,%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	83 e8 04             	sub    $0x4,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	ff 75 0c             	pushl  0xc(%ebp)
  800573:	50                   	push   %eax
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	ff d0                	call   *%eax
  800579:	83 c4 10             	add    $0x10,%esp
			break;
  80057c:	e9 89 02 00 00       	jmp    80080a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	83 c0 04             	add    $0x4,%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	83 e8 04             	sub    $0x4,%eax
  800590:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800592:	85 db                	test   %ebx,%ebx
  800594:	79 02                	jns    800598 <vprintfmt+0x14a>
				err = -err;
  800596:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800598:	83 fb 64             	cmp    $0x64,%ebx
  80059b:	7f 0b                	jg     8005a8 <vprintfmt+0x15a>
  80059d:	8b 34 9d 40 1a 80 00 	mov    0x801a40(,%ebx,4),%esi
  8005a4:	85 f6                	test   %esi,%esi
  8005a6:	75 19                	jne    8005c1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a8:	53                   	push   %ebx
  8005a9:	68 e5 1b 80 00       	push   $0x801be5
  8005ae:	ff 75 0c             	pushl  0xc(%ebp)
  8005b1:	ff 75 08             	pushl  0x8(%ebp)
  8005b4:	e8 5e 02 00 00       	call   800817 <printfmt>
  8005b9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005bc:	e9 49 02 00 00       	jmp    80080a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005c1:	56                   	push   %esi
  8005c2:	68 ee 1b 80 00       	push   $0x801bee
  8005c7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ca:	ff 75 08             	pushl  0x8(%ebp)
  8005cd:	e8 45 02 00 00       	call   800817 <printfmt>
  8005d2:	83 c4 10             	add    $0x10,%esp
			break;
  8005d5:	e9 30 02 00 00       	jmp    80080a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	83 c0 04             	add    $0x4,%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 e8 04             	sub    $0x4,%eax
  8005e9:	8b 30                	mov    (%eax),%esi
  8005eb:	85 f6                	test   %esi,%esi
  8005ed:	75 05                	jne    8005f4 <vprintfmt+0x1a6>
				p = "(null)";
  8005ef:	be f1 1b 80 00       	mov    $0x801bf1,%esi
			if (width > 0 && padc != '-')
  8005f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f8:	7e 6d                	jle    800667 <vprintfmt+0x219>
  8005fa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005fe:	74 67                	je     800667 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	50                   	push   %eax
  800607:	56                   	push   %esi
  800608:	e8 0c 03 00 00       	call   800919 <strnlen>
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800613:	eb 16                	jmp    80062b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800615:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	ff 75 0c             	pushl  0xc(%ebp)
  80061f:	50                   	push   %eax
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	ff d0                	call   *%eax
  800625:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	ff 4d e4             	decl   -0x1c(%ebp)
  80062b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062f:	7f e4                	jg     800615 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800631:	eb 34                	jmp    800667 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800633:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800637:	74 1c                	je     800655 <vprintfmt+0x207>
  800639:	83 fb 1f             	cmp    $0x1f,%ebx
  80063c:	7e 05                	jle    800643 <vprintfmt+0x1f5>
  80063e:	83 fb 7e             	cmp    $0x7e,%ebx
  800641:	7e 12                	jle    800655 <vprintfmt+0x207>
					putch('?', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	6a 3f                	push   $0x3f
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	ff d0                	call   *%eax
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb 0f                	jmp    800664 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	53                   	push   %ebx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	ff d0                	call   *%eax
  800661:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800664:	ff 4d e4             	decl   -0x1c(%ebp)
  800667:	89 f0                	mov    %esi,%eax
  800669:	8d 70 01             	lea    0x1(%eax),%esi
  80066c:	8a 00                	mov    (%eax),%al
  80066e:	0f be d8             	movsbl %al,%ebx
  800671:	85 db                	test   %ebx,%ebx
  800673:	74 24                	je     800699 <vprintfmt+0x24b>
  800675:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800679:	78 b8                	js     800633 <vprintfmt+0x1e5>
  80067b:	ff 4d e0             	decl   -0x20(%ebp)
  80067e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800682:	79 af                	jns    800633 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800684:	eb 13                	jmp    800699 <vprintfmt+0x24b>
				putch(' ', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	ff 75 0c             	pushl  0xc(%ebp)
  80068c:	6a 20                	push   $0x20
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	ff d0                	call   *%eax
  800693:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800696:	ff 4d e4             	decl   -0x1c(%ebp)
  800699:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069d:	7f e7                	jg     800686 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80069f:	e9 66 01 00 00       	jmp    80080a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8006aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ad:	50                   	push   %eax
  8006ae:	e8 3c fd ff ff       	call   8003ef <getint>
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c2:	85 d2                	test   %edx,%edx
  8006c4:	79 23                	jns    8006e9 <vprintfmt+0x29b>
				putch('-', putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	6a 2d                	push   $0x2d
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006dc:	f7 d8                	neg    %eax
  8006de:	83 d2 00             	adc    $0x0,%edx
  8006e1:	f7 da                	neg    %edx
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f0:	e9 bc 00 00 00       	jmp    8007b1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	e8 84 fc ff ff       	call   800388 <getuint>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80070d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800714:	e9 98 00 00 00       	jmp    8007b1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	6a 58                	push   $0x58
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	6a 58                	push   $0x58
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	ff d0                	call   *%eax
  800736:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 58                	push   $0x58
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
			break;
  800749:	e9 bc 00 00 00       	jmp    80080a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 30                	push   $0x30
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	6a 78                	push   $0x78
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	ff d0                	call   *%eax
  80076b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 c0 04             	add    $0x4,%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80077f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800782:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800789:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800790:	eb 1f                	jmp    8007b1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 e8             	pushl  -0x18(%ebp)
  800798:	8d 45 14             	lea    0x14(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	e8 e7 fb ff ff       	call   800388 <getuint>
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007aa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	52                   	push   %edx
  8007bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007bf:	50                   	push   %eax
  8007c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 00 fb ff ff       	call   8002d1 <printnum>
  8007d1:	83 c4 20             	add    $0x20,%esp
			break;
  8007d4:	eb 34                	jmp    80080a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	53                   	push   %ebx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	ff d0                	call   *%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
			break;
  8007e5:	eb 23                	jmp    80080a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	6a 25                	push   $0x25
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f7:	ff 4d 10             	decl   0x10(%ebp)
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x3b1>
  8007fc:	ff 4d 10             	decl   0x10(%ebp)
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	48                   	dec    %eax
  800803:	8a 00                	mov    (%eax),%al
  800805:	3c 25                	cmp    $0x25,%al
  800807:	75 f3                	jne    8007fc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800809:	90                   	nop
		}
	}
  80080a:	e9 47 fc ff ff       	jmp    800456 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80080f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800810:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80081d:	8d 45 10             	lea    0x10(%ebp),%eax
  800820:	83 c0 04             	add    $0x4,%eax
  800823:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800826:	8b 45 10             	mov    0x10(%ebp),%eax
  800829:	ff 75 f4             	pushl  -0xc(%ebp)
  80082c:	50                   	push   %eax
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	ff 75 08             	pushl  0x8(%ebp)
  800833:	e8 16 fc ff ff       	call   80044e <vprintfmt>
  800838:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80083b:	90                   	nop
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    

0080083e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
  800844:	8b 40 08             	mov    0x8(%eax),%eax
  800847:	8d 50 01             	lea    0x1(%eax),%edx
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800850:	8b 45 0c             	mov    0xc(%ebp),%eax
  800853:	8b 10                	mov    (%eax),%edx
  800855:	8b 45 0c             	mov    0xc(%ebp),%eax
  800858:	8b 40 04             	mov    0x4(%eax),%eax
  80085b:	39 c2                	cmp    %eax,%edx
  80085d:	73 12                	jae    800871 <sprintputch+0x33>
		*b->buf++ = ch;
  80085f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	8d 48 01             	lea    0x1(%eax),%ecx
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	89 0a                	mov    %ecx,(%edx)
  80086c:	8b 55 08             	mov    0x8(%ebp),%edx
  80086f:	88 10                	mov    %dl,(%eax)
}
  800871:	90                   	nop
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800880:	8b 45 0c             	mov    0xc(%ebp),%eax
  800883:	8d 50 ff             	lea    -0x1(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 d0                	add    %edx,%eax
  80088b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800895:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800899:	74 06                	je     8008a1 <vsnprintf+0x2d>
  80089b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089f:	7f 07                	jg     8008a8 <vsnprintf+0x34>
		return -E_INVAL;
  8008a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a6:	eb 20                	jmp    8008c8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a8:	ff 75 14             	pushl  0x14(%ebp)
  8008ab:	ff 75 10             	pushl  0x10(%ebp)
  8008ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b1:	50                   	push   %eax
  8008b2:	68 3e 08 80 00       	push   $0x80083e
  8008b7:	e8 92 fb ff ff       	call   80044e <vprintfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 89 ff ff ff       	call   800874 <vsnprintf>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f4:	c9                   	leave  
  8008f5:	c3                   	ret    

008008f6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800903:	eb 06                	jmp    80090b <strlen+0x15>
		n++;
  800905:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800908:	ff 45 08             	incl   0x8(%ebp)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8a 00                	mov    (%eax),%al
  800910:	84 c0                	test   %al,%al
  800912:	75 f1                	jne    800905 <strlen+0xf>
		n++;
	return n;
  800914:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800917:	c9                   	leave  
  800918:	c3                   	ret    

00800919 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800926:	eb 09                	jmp    800931 <strnlen+0x18>
		n++;
  800928:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092b:	ff 45 08             	incl   0x8(%ebp)
  80092e:	ff 4d 0c             	decl   0xc(%ebp)
  800931:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800935:	74 09                	je     800940 <strnlen+0x27>
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8a 00                	mov    (%eax),%al
  80093c:	84 c0                	test   %al,%al
  80093e:	75 e8                	jne    800928 <strnlen+0xf>
		n++;
	return n;
  800940:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800951:	90                   	nop
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8d 50 01             	lea    0x1(%eax),%edx
  800958:	89 55 08             	mov    %edx,0x8(%ebp)
  80095b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800961:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800964:	8a 12                	mov    (%edx),%dl
  800966:	88 10                	mov    %dl,(%eax)
  800968:	8a 00                	mov    (%eax),%al
  80096a:	84 c0                	test   %al,%al
  80096c:	75 e4                	jne    800952 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80096e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80097f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800986:	eb 1f                	jmp    8009a7 <strncpy+0x34>
		*dst++ = *src;
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8d 50 01             	lea    0x1(%eax),%edx
  80098e:	89 55 08             	mov    %edx,0x8(%ebp)
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	8a 12                	mov    (%edx),%dl
  800996:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	8a 00                	mov    (%eax),%al
  80099d:	84 c0                	test   %al,%al
  80099f:	74 03                	je     8009a4 <strncpy+0x31>
			src++;
  8009a1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a4:	ff 45 fc             	incl   -0x4(%ebp)
  8009a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009ad:	72 d9                	jb     800988 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c4:	74 30                	je     8009f6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c6:	eb 16                	jmp    8009de <strlcpy+0x2a>
			*dst++ = *src++;
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009da:	8a 12                	mov    (%edx),%dl
  8009dc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009de:	ff 4d 10             	decl   0x10(%ebp)
  8009e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e5:	74 09                	je     8009f0 <strlcpy+0x3c>
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	84 c0                	test   %al,%al
  8009ee:	75 d8                	jne    8009c8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fc:	29 c2                	sub    %eax,%edx
  8009fe:	89 d0                	mov    %edx,%eax
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a05:	eb 06                	jmp    800a0d <strcmp+0xb>
		p++, q++;
  800a07:	ff 45 08             	incl   0x8(%ebp)
  800a0a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	84 c0                	test   %al,%al
  800a14:	74 0e                	je     800a24 <strcmp+0x22>
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8a 10                	mov    (%eax),%dl
  800a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	38 c2                	cmp    %al,%dl
  800a22:	74 e3                	je     800a07 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8a 00                	mov    (%eax),%al
  800a29:	0f b6 d0             	movzbl %al,%edx
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	0f b6 c0             	movzbl %al,%eax
  800a34:	29 c2                	sub    %eax,%edx
  800a36:	89 d0                	mov    %edx,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a3d:	eb 09                	jmp    800a48 <strncmp+0xe>
		n--, p++, q++;
  800a3f:	ff 4d 10             	decl   0x10(%ebp)
  800a42:	ff 45 08             	incl   0x8(%ebp)
  800a45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4c:	74 17                	je     800a65 <strncmp+0x2b>
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	84 c0                	test   %al,%al
  800a55:	74 0e                	je     800a65 <strncmp+0x2b>
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8a 10                	mov    (%eax),%dl
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	38 c2                	cmp    %al,%dl
  800a63:	74 da                	je     800a3f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a69:	75 07                	jne    800a72 <strncmp+0x38>
		return 0;
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a70:	eb 14                	jmp    800a86 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	0f b6 d0             	movzbl %al,%edx
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f b6 c0             	movzbl %al,%eax
  800a82:	29 c2                	sub    %eax,%edx
  800a84:	89 d0                	mov    %edx,%eax
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 04             	sub    $0x4,%esp
  800a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a94:	eb 12                	jmp    800aa8 <strchr+0x20>
		if (*s == c)
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8a 00                	mov    (%eax),%al
  800a9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a9e:	75 05                	jne    800aa5 <strchr+0x1d>
			return (char *) s;
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	eb 11                	jmp    800ab6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa5:	ff 45 08             	incl   0x8(%ebp)
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	84 c0                	test   %al,%al
  800aaf:	75 e5                	jne    800a96 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac4:	eb 0d                	jmp    800ad3 <strfind+0x1b>
		if (*s == c)
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ace:	74 0e                	je     800ade <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad0:	ff 45 08             	incl   0x8(%ebp)
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	84 c0                	test   %al,%al
  800ada:	75 ea                	jne    800ac6 <strfind+0xe>
  800adc:	eb 01                	jmp    800adf <strfind+0x27>
		if (*s == c)
			break;
  800ade:	90                   	nop
	return (char *) s;
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af0:	8b 45 10             	mov    0x10(%ebp),%eax
  800af3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af6:	eb 0e                	jmp    800b06 <memset+0x22>
		*p++ = c;
  800af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800afb:	8d 50 01             	lea    0x1(%eax),%edx
  800afe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b04:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b06:	ff 4d f8             	decl   -0x8(%ebp)
  800b09:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b0d:	79 e9                	jns    800af8 <memset+0x14>
		*p++ = c;

	return v;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b26:	eb 16                	jmp    800b3e <memcpy+0x2a>
		*d++ = *s++;
  800b28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2b:	8d 50 01             	lea    0x1(%eax),%edx
  800b2e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b37:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3a:	8a 12                	mov    (%edx),%dl
  800b3c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b44:	89 55 10             	mov    %edx,0x10(%ebp)
  800b47:	85 c0                	test   %eax,%eax
  800b49:	75 dd                	jne    800b28 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b68:	73 50                	jae    800bba <memmove+0x6a>
  800b6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b75:	76 43                	jbe    800bba <memmove+0x6a>
		s += n;
  800b77:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b80:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b83:	eb 10                	jmp    800b95 <memmove+0x45>
			*--d = *--s;
  800b85:	ff 4d f8             	decl   -0x8(%ebp)
  800b88:	ff 4d fc             	decl   -0x4(%ebp)
  800b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8e:	8a 10                	mov    (%eax),%dl
  800b90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b93:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	75 e3                	jne    800b85 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba2:	eb 23                	jmp    800bc7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba7:	8d 50 01             	lea    0x1(%eax),%edx
  800baa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb6:	8a 12                	mov    (%edx),%dl
  800bb8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	75 dd                	jne    800ba4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bde:	eb 2a                	jmp    800c0a <memcmp+0x3e>
		if (*s1 != *s2)
  800be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be3:	8a 10                	mov    (%eax),%dl
  800be5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	38 c2                	cmp    %al,%dl
  800bec:	74 16                	je     800c04 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	0f b6 d0             	movzbl %al,%edx
  800bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	29 c2                	sub    %eax,%edx
  800c00:	89 d0                	mov    %edx,%eax
  800c02:	eb 18                	jmp    800c1c <memcmp+0x50>
		s1++, s2++;
  800c04:	ff 45 fc             	incl   -0x4(%ebp)
  800c07:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c10:	89 55 10             	mov    %edx,0x10(%ebp)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	75 c9                	jne    800be0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2a:	01 d0                	add    %edx,%eax
  800c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c2f:	eb 15                	jmp    800c46 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8a 00                	mov    (%eax),%al
  800c36:	0f b6 d0             	movzbl %al,%edx
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	0f b6 c0             	movzbl %al,%eax
  800c3f:	39 c2                	cmp    %eax,%edx
  800c41:	74 0d                	je     800c50 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c43:	ff 45 08             	incl   0x8(%ebp)
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c4c:	72 e3                	jb     800c31 <memfind+0x13>
  800c4e:	eb 01                	jmp    800c51 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c50:	90                   	nop
	return (void *) s;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6a:	eb 03                	jmp    800c6f <strtol+0x19>
		s++;
  800c6c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	3c 20                	cmp    $0x20,%al
  800c76:	74 f4                	je     800c6c <strtol+0x16>
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	3c 09                	cmp    $0x9,%al
  800c7f:	74 eb                	je     800c6c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	3c 2b                	cmp    $0x2b,%al
  800c88:	75 05                	jne    800c8f <strtol+0x39>
		s++;
  800c8a:	ff 45 08             	incl   0x8(%ebp)
  800c8d:	eb 13                	jmp    800ca2 <strtol+0x4c>
	else if (*s == '-')
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	3c 2d                	cmp    $0x2d,%al
  800c96:	75 0a                	jne    800ca2 <strtol+0x4c>
		s++, neg = 1;
  800c98:	ff 45 08             	incl   0x8(%ebp)
  800c9b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca6:	74 06                	je     800cae <strtol+0x58>
  800ca8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cac:	75 20                	jne    800cce <strtol+0x78>
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	3c 30                	cmp    $0x30,%al
  800cb5:	75 17                	jne    800cce <strtol+0x78>
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	40                   	inc    %eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	3c 78                	cmp    $0x78,%al
  800cbf:	75 0d                	jne    800cce <strtol+0x78>
		s += 2, base = 16;
  800cc1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ccc:	eb 28                	jmp    800cf6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	75 15                	jne    800ce9 <strtol+0x93>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3c 30                	cmp    $0x30,%al
  800cdb:	75 0c                	jne    800ce9 <strtol+0x93>
		s++, base = 8;
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce7:	eb 0d                	jmp    800cf6 <strtol+0xa0>
	else if (base == 0)
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	75 07                	jne    800cf6 <strtol+0xa0>
		base = 10;
  800cef:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	3c 2f                	cmp    $0x2f,%al
  800cfd:	7e 19                	jle    800d18 <strtol+0xc2>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	3c 39                	cmp    $0x39,%al
  800d06:	7f 10                	jg     800d18 <strtol+0xc2>
			dig = *s - '0';
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	0f be c0             	movsbl %al,%eax
  800d10:	83 e8 30             	sub    $0x30,%eax
  800d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d16:	eb 42                	jmp    800d5a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	3c 60                	cmp    $0x60,%al
  800d1f:	7e 19                	jle    800d3a <strtol+0xe4>
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	3c 7a                	cmp    $0x7a,%al
  800d28:	7f 10                	jg     800d3a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f be c0             	movsbl %al,%eax
  800d32:	83 e8 57             	sub    $0x57,%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d38:	eb 20                	jmp    800d5a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 40                	cmp    $0x40,%al
  800d41:	7e 39                	jle    800d7c <strtol+0x126>
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 5a                	cmp    $0x5a,%al
  800d4a:	7f 30                	jg     800d7c <strtol+0x126>
			dig = *s - 'A' + 10;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	0f be c0             	movsbl %al,%eax
  800d54:	83 e8 37             	sub    $0x37,%eax
  800d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d60:	7d 19                	jge    800d7b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d68:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d6c:	89 c2                	mov    %eax,%edx
  800d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d76:	e9 7b ff ff ff       	jmp    800cf6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d7b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d80:	74 08                	je     800d8a <strtol+0x134>
		*endptr = (char *) s;
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d8e:	74 07                	je     800d97 <strtol+0x141>
  800d90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d93:	f7 d8                	neg    %eax
  800d95:	eb 03                	jmp    800d9a <strtol+0x144>
  800d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <ltostr>:

void
ltostr(long value, char *str)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800da9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db4:	79 13                	jns    800dc9 <ltostr+0x2d>
	{
		neg = 1;
  800db6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd1:	99                   	cltd   
  800dd2:	f7 f9                	idiv   %ecx
  800dd4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	01 d0                	add    %edx,%eax
  800de7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dea:	83 c2 30             	add    $0x30,%edx
  800ded:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df7:	f7 e9                	imul   %ecx
  800df9:	c1 fa 02             	sar    $0x2,%edx
  800dfc:	89 c8                	mov    %ecx,%eax
  800dfe:	c1 f8 1f             	sar    $0x1f,%eax
  800e01:	29 c2                	sub    %eax,%edx
  800e03:	89 d0                	mov    %edx,%eax
  800e05:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e10:	f7 e9                	imul   %ecx
  800e12:	c1 fa 02             	sar    $0x2,%edx
  800e15:	89 c8                	mov    %ecx,%eax
  800e17:	c1 f8 1f             	sar    $0x1f,%eax
  800e1a:	29 c2                	sub    %eax,%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	29 c1                	sub    %eax,%ecx
  800e27:	89 ca                	mov    %ecx,%edx
  800e29:	85 d2                	test   %edx,%edx
  800e2b:	75 9c                	jne    800dc9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e37:	48                   	dec    %eax
  800e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e3f:	74 3d                	je     800e7e <ltostr+0xe2>
		start = 1 ;
  800e41:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e48:	eb 34                	jmp    800e7e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	01 d0                	add    %edx,%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	01 c2                	add    %eax,%edx
  800e5f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	01 c8                	add    %ecx,%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	01 c2                	add    %eax,%edx
  800e73:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e76:	88 02                	mov    %al,(%edx)
		start++ ;
  800e78:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e7b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e84:	7c c4                	jl     800e4a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e86:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	01 d0                	add    %edx,%eax
  800e8e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e91:	90                   	nop
  800e92:	c9                   	leave  
  800e93:	c3                   	ret    

00800e94 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 54 fa ff ff       	call   8008f6 <strlen>
  800ea2:	83 c4 04             	add    $0x4,%esp
  800ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	e8 46 fa ff ff       	call   8008f6 <strlen>
  800eb0:	83 c4 04             	add    $0x4,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ebd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec4:	eb 17                	jmp    800edd <strcconcat+0x49>
		final[s] = str1[s] ;
  800ec6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	01 c2                	add    %eax,%edx
  800ece:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	01 c8                	add    %ecx,%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800eda:	ff 45 fc             	incl   -0x4(%ebp)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee3:	7c e1                	jl     800ec6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef3:	eb 1f                	jmp    800f14 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef8:	8d 50 01             	lea    0x1(%eax),%edx
  800efb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	01 c2                	add    %eax,%edx
  800f05:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f11:	ff 45 f8             	incl   -0x8(%ebp)
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f1a:	7c d9                	jl     800ef5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	01 d0                	add    %edx,%eax
  800f24:	c6 00 00             	movb   $0x0,(%eax)
}
  800f27:	90                   	nop
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f36:	8b 45 14             	mov    0x14(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	01 d0                	add    %edx,%eax
  800f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4d:	eb 0c                	jmp    800f5b <strsplit+0x31>
			*string++ = 0;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 08             	mov    %edx,0x8(%ebp)
  800f58:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	84 c0                	test   %al,%al
  800f62:	74 18                	je     800f7c <strsplit+0x52>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f be c0             	movsbl %al,%eax
  800f6c:	50                   	push   %eax
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	e8 13 fb ff ff       	call   800a88 <strchr>
  800f75:	83 c4 08             	add    $0x8,%esp
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 d3                	jne    800f4f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	84 c0                	test   %al,%al
  800f83:	74 5a                	je     800fdf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f85:	8b 45 14             	mov    0x14(%ebp),%eax
  800f88:	8b 00                	mov    (%eax),%eax
  800f8a:	83 f8 0f             	cmp    $0xf,%eax
  800f8d:	75 07                	jne    800f96 <strsplit+0x6c>
		{
			return 0;
  800f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f94:	eb 66                	jmp    800ffc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	8b 00                	mov    (%eax),%eax
  800f9b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f9e:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa1:	89 0a                	mov    %ecx,(%edx)
  800fa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	01 c2                	add    %eax,%edx
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb4:	eb 03                	jmp    800fb9 <strsplit+0x8f>
			string++;
  800fb6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	84 c0                	test   %al,%al
  800fc0:	74 8b                	je     800f4d <strsplit+0x23>
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f be c0             	movsbl %al,%eax
  800fca:	50                   	push   %eax
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	e8 b5 fa ff ff       	call   800a88 <strchr>
  800fd3:	83 c4 08             	add    $0x8,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	74 dc                	je     800fb6 <strsplit+0x8c>
			string++;
	}
  800fda:	e9 6e ff ff ff       	jmp    800f4d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fdf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fe0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe3:	8b 00                	mov    (%eax),%eax
  800fe5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ff7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801010:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801013:	8b 7d 18             	mov    0x18(%ebp),%edi
  801016:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801019:	cd 30                	int    $0x30
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801035:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	6a 00                	push   $0x0
  80103e:	6a 00                	push   $0x0
  801040:	52                   	push   %edx
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	50                   	push   %eax
  801045:	6a 00                	push   $0x0
  801047:	e8 b2 ff ff ff       	call   800ffe <syscall>
  80104c:	83 c4 18             	add    $0x18,%esp
}
  80104f:	90                   	nop
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <sys_cgetc>:

int
sys_cgetc(void)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801055:	6a 00                	push   $0x0
  801057:	6a 00                	push   $0x0
  801059:	6a 00                	push   $0x0
  80105b:	6a 00                	push   $0x0
  80105d:	6a 00                	push   $0x0
  80105f:	6a 01                	push   $0x1
  801061:	e8 98 ff ff ff       	call   800ffe <syscall>
  801066:	83 c4 18             	add    $0x18,%esp
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80106e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	6a 00                	push   $0x0
  801076:	6a 00                	push   $0x0
  801078:	6a 00                	push   $0x0
  80107a:	52                   	push   %edx
  80107b:	50                   	push   %eax
  80107c:	6a 05                	push   $0x5
  80107e:	e8 7b ff ff ff       	call   800ffe <syscall>
  801083:	83 c4 18             	add    $0x18,%esp
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80108d:	8b 75 18             	mov    0x18(%ebp),%esi
  801090:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801093:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801096:	8b 55 0c             	mov    0xc(%ebp),%edx
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	51                   	push   %ecx
  80109f:	52                   	push   %edx
  8010a0:	50                   	push   %eax
  8010a1:	6a 06                	push   $0x6
  8010a3:	e8 56 ff ff ff       	call   800ffe <syscall>
  8010a8:	83 c4 18             	add    $0x18,%esp
}
  8010ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	52                   	push   %edx
  8010c2:	50                   	push   %eax
  8010c3:	6a 07                	push   $0x7
  8010c5:	e8 34 ff ff ff       	call   800ffe <syscall>
  8010ca:	83 c4 18             	add    $0x18,%esp
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 00                	push   $0x0
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	ff 75 08             	pushl  0x8(%ebp)
  8010de:	6a 08                	push   $0x8
  8010e0:	e8 19 ff ff ff       	call   800ffe <syscall>
  8010e5:	83 c4 18             	add    $0x18,%esp
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 00                	push   $0x0
  8010f1:	6a 00                	push   $0x0
  8010f3:	6a 00                	push   $0x0
  8010f5:	6a 00                	push   $0x0
  8010f7:	6a 09                	push   $0x9
  8010f9:	e8 00 ff ff ff       	call   800ffe <syscall>
  8010fe:	83 c4 18             	add    $0x18,%esp
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 0a                	push   $0xa
  801112:	e8 e7 fe ff ff       	call   800ffe <syscall>
  801117:	83 c4 18             	add    $0x18,%esp
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80111f:	6a 00                	push   $0x0
  801121:	6a 00                	push   $0x0
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 0b                	push   $0xb
  80112b:	e8 ce fe ff ff       	call   800ffe <syscall>
  801130:	83 c4 18             	add    $0x18,%esp
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	ff 75 08             	pushl  0x8(%ebp)
  801144:	6a 0f                	push   $0xf
  801146:	e8 b3 fe ff ff       	call   800ffe <syscall>
  80114b:	83 c4 18             	add    $0x18,%esp
	return;
  80114e:	90                   	nop
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	ff 75 08             	pushl  0x8(%ebp)
  801160:	6a 10                	push   $0x10
  801162:	e8 97 fe ff ff       	call   800ffe <syscall>
  801167:	83 c4 18             	add    $0x18,%esp
	return ;
  80116a:	90                   	nop
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	ff 75 10             	pushl  0x10(%ebp)
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	ff 75 08             	pushl  0x8(%ebp)
  80117d:	6a 11                	push   $0x11
  80117f:	e8 7a fe ff ff       	call   800ffe <syscall>
  801184:	83 c4 18             	add    $0x18,%esp
	return ;
  801187:	90                   	nop
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 0c                	push   $0xc
  801199:	e8 60 fe ff ff       	call   800ffe <syscall>
  80119e:	83 c4 18             	add    $0x18,%esp
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	ff 75 08             	pushl  0x8(%ebp)
  8011b1:	6a 0d                	push   $0xd
  8011b3:	e8 46 fe ff ff       	call   800ffe <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 0e                	push   $0xe
  8011cc:	e8 2d fe ff ff       	call   800ffe <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 13                	push   $0x13
  8011e6:	e8 13 fe ff ff       	call   800ffe <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 00                	push   $0x0
  8011fe:	6a 14                	push   $0x14
  801200:	e8 f9 fd ff ff       	call   800ffe <syscall>
  801205:	83 c4 18             	add    $0x18,%esp
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <sys_cputc>:


void
sys_cputc(const char c)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801217:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	50                   	push   %eax
  801224:	6a 15                	push   $0x15
  801226:	e8 d3 fd ff ff       	call   800ffe <syscall>
  80122b:	83 c4 18             	add    $0x18,%esp
}
  80122e:	90                   	nop
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 16                	push   $0x16
  801240:	e8 b9 fd ff ff       	call   800ffe <syscall>
  801245:	83 c4 18             	add    $0x18,%esp
}
  801248:	90                   	nop
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	50                   	push   %eax
  80125b:	6a 17                	push   $0x17
  80125d:	e8 9c fd ff ff       	call   800ffe <syscall>
  801262:	83 c4 18             	add    $0x18,%esp
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80126a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	52                   	push   %edx
  801277:	50                   	push   %eax
  801278:	6a 1a                	push   $0x1a
  80127a:	e8 7f fd ff ff       	call   800ffe <syscall>
  80127f:	83 c4 18             	add    $0x18,%esp
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	52                   	push   %edx
  801294:	50                   	push   %eax
  801295:	6a 18                	push   $0x18
  801297:	e8 62 fd ff ff       	call   800ffe <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	6a 19                	push   $0x19
  8012b5:	e8 44 fd ff ff       	call   800ffe <syscall>
  8012ba:	83 c4 18             	add    $0x18,%esp
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 04             	sub    $0x4,%esp
  8012c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	6a 00                	push   $0x0
  8012d8:	51                   	push   %ecx
  8012d9:	52                   	push   %edx
  8012da:	ff 75 0c             	pushl  0xc(%ebp)
  8012dd:	50                   	push   %eax
  8012de:	6a 1b                	push   $0x1b
  8012e0:	e8 19 fd ff ff       	call   800ffe <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	52                   	push   %edx
  8012fa:	50                   	push   %eax
  8012fb:	6a 1c                	push   $0x1c
  8012fd:	e8 fc fc ff ff       	call   800ffe <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80130a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	51                   	push   %ecx
  801318:	52                   	push   %edx
  801319:	50                   	push   %eax
  80131a:	6a 1d                	push   $0x1d
  80131c:	e8 dd fc ff ff       	call   800ffe <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	52                   	push   %edx
  801336:	50                   	push   %eax
  801337:	6a 1e                	push   $0x1e
  801339:	e8 c0 fc ff ff       	call   800ffe <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 1f                	push   $0x1f
  801352:	e8 a7 fc ff ff       	call   800ffe <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	6a 00                	push   $0x0
  801364:	ff 75 14             	pushl  0x14(%ebp)
  801367:	ff 75 10             	pushl  0x10(%ebp)
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	50                   	push   %eax
  80136e:	6a 20                	push   $0x20
  801370:	e8 89 fc ff ff       	call   800ffe <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	50                   	push   %eax
  801389:	6a 21                	push   $0x21
  80138b:	e8 6e fc ff ff       	call   800ffe <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	90                   	nop
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	50                   	push   %eax
  8013a5:	6a 22                	push   $0x22
  8013a7:	e8 52 fc ff ff       	call   800ffe <syscall>
  8013ac:	83 c4 18             	add    $0x18,%esp
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 02                	push   $0x2
  8013c0:	e8 39 fc ff ff       	call   800ffe <syscall>
  8013c5:	83 c4 18             	add    $0x18,%esp
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 03                	push   $0x3
  8013d9:	e8 20 fc ff ff       	call   800ffe <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 04                	push   $0x4
  8013f2:	e8 07 fc ff ff       	call   800ffe <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_exit_env>:


void sys_exit_env(void)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 23                	push   $0x23
  80140b:	e8 ee fb ff ff       	call   800ffe <syscall>
  801410:	83 c4 18             	add    $0x18,%esp
}
  801413:	90                   	nop
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80141c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80141f:	8d 50 04             	lea    0x4(%eax),%edx
  801422:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	52                   	push   %edx
  80142c:	50                   	push   %eax
  80142d:	6a 24                	push   $0x24
  80142f:	e8 ca fb ff ff       	call   800ffe <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
	return result;
  801437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80143a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	89 01                	mov    %eax,(%ecx)
  801442:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	c9                   	leave  
  801449:	c2 04 00             	ret    $0x4

0080144c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	ff 75 10             	pushl  0x10(%ebp)
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	6a 12                	push   $0x12
  80145e:	e8 9b fb ff ff       	call   800ffe <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
	return ;
  801466:	90                   	nop
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_rcr2>:
uint32 sys_rcr2()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 25                	push   $0x25
  801478:	e8 81 fb ff ff       	call   800ffe <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80148e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	50                   	push   %eax
  80149b:	6a 26                	push   $0x26
  80149d:	e8 5c fb ff ff       	call   800ffe <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a5:	90                   	nop
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <rsttst>:
void rsttst()
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 28                	push   $0x28
  8014b7:	e8 42 fb ff ff       	call   800ffe <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bf:	90                   	nop
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 04             	sub    $0x4,%esp
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014ce:	8b 55 18             	mov    0x18(%ebp),%edx
  8014d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d5:	52                   	push   %edx
  8014d6:	50                   	push   %eax
  8014d7:	ff 75 10             	pushl  0x10(%ebp)
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	6a 27                	push   $0x27
  8014e2:	e8 17 fb ff ff       	call   800ffe <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ea:	90                   	nop
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <chktst>:
void chktst(uint32 n)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	6a 29                	push   $0x29
  8014fd:	e8 fc fa ff ff       	call   800ffe <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
	return ;
  801505:	90                   	nop
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <inctst>:

void inctst()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 2a                	push   $0x2a
  801517:	e8 e2 fa ff ff       	call   800ffe <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
	return ;
  80151f:	90                   	nop
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <gettst>:
uint32 gettst()
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 2b                	push   $0x2b
  801531:	e8 c8 fa ff ff       	call   800ffe <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 2c                	push   $0x2c
  80154d:	e8 ac fa ff ff       	call   800ffe <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
  801555:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801558:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80155c:	75 07                	jne    801565 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80155e:	b8 01 00 00 00       	mov    $0x1,%eax
  801563:	eb 05                	jmp    80156a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 2c                	push   $0x2c
  80157e:	e8 7b fa ff ff       	call   800ffe <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
  801586:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801589:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80158d:	75 07                	jne    801596 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80158f:	b8 01 00 00 00       	mov    $0x1,%eax
  801594:	eb 05                	jmp    80159b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 2c                	push   $0x2c
  8015af:	e8 4a fa ff ff       	call   800ffe <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
  8015b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015ba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015be:	75 07                	jne    8015c7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c5:	eb 05                	jmp    8015cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 2c                	push   $0x2c
  8015e0:	e8 19 fa ff ff       	call   800ffe <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
  8015e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015eb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015ef:	75 07                	jne    8015f8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f6:	eb 05                	jmp    8015fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	ff 75 08             	pushl  0x8(%ebp)
  80160d:	6a 2d                	push   $0x2d
  80160f:	e8 ea f9 ff ff       	call   800ffe <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
	return ;
  801617:	90                   	nop
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80161e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801624:	8b 55 0c             	mov    0xc(%ebp),%edx
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	6a 00                	push   $0x0
  80162c:	53                   	push   %ebx
  80162d:	51                   	push   %ecx
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 2e                	push   $0x2e
  801632:	e8 c7 f9 ff ff       	call   800ffe <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801642:	8b 55 0c             	mov    0xc(%ebp),%edx
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	52                   	push   %edx
  80164f:	50                   	push   %eax
  801650:	6a 2f                	push   $0x2f
  801652:	e8 a7 f9 ff ff       	call   800ffe <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <__udivdi3>:
  80165c:	55                   	push   %ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	83 ec 1c             	sub    $0x1c,%esp
  801663:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801667:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80166b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80166f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801673:	89 ca                	mov    %ecx,%edx
  801675:	89 f8                	mov    %edi,%eax
  801677:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80167b:	85 f6                	test   %esi,%esi
  80167d:	75 2d                	jne    8016ac <__udivdi3+0x50>
  80167f:	39 cf                	cmp    %ecx,%edi
  801681:	77 65                	ja     8016e8 <__udivdi3+0x8c>
  801683:	89 fd                	mov    %edi,%ebp
  801685:	85 ff                	test   %edi,%edi
  801687:	75 0b                	jne    801694 <__udivdi3+0x38>
  801689:	b8 01 00 00 00       	mov    $0x1,%eax
  80168e:	31 d2                	xor    %edx,%edx
  801690:	f7 f7                	div    %edi
  801692:	89 c5                	mov    %eax,%ebp
  801694:	31 d2                	xor    %edx,%edx
  801696:	89 c8                	mov    %ecx,%eax
  801698:	f7 f5                	div    %ebp
  80169a:	89 c1                	mov    %eax,%ecx
  80169c:	89 d8                	mov    %ebx,%eax
  80169e:	f7 f5                	div    %ebp
  8016a0:	89 cf                	mov    %ecx,%edi
  8016a2:	89 fa                	mov    %edi,%edx
  8016a4:	83 c4 1c             	add    $0x1c,%esp
  8016a7:	5b                   	pop    %ebx
  8016a8:	5e                   	pop    %esi
  8016a9:	5f                   	pop    %edi
  8016aa:	5d                   	pop    %ebp
  8016ab:	c3                   	ret    
  8016ac:	39 ce                	cmp    %ecx,%esi
  8016ae:	77 28                	ja     8016d8 <__udivdi3+0x7c>
  8016b0:	0f bd fe             	bsr    %esi,%edi
  8016b3:	83 f7 1f             	xor    $0x1f,%edi
  8016b6:	75 40                	jne    8016f8 <__udivdi3+0x9c>
  8016b8:	39 ce                	cmp    %ecx,%esi
  8016ba:	72 0a                	jb     8016c6 <__udivdi3+0x6a>
  8016bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8016c0:	0f 87 9e 00 00 00    	ja     801764 <__udivdi3+0x108>
  8016c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016cb:	89 fa                	mov    %edi,%edx
  8016cd:	83 c4 1c             	add    $0x1c,%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5e                   	pop    %esi
  8016d2:	5f                   	pop    %edi
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    
  8016d5:	8d 76 00             	lea    0x0(%esi),%esi
  8016d8:	31 ff                	xor    %edi,%edi
  8016da:	31 c0                	xor    %eax,%eax
  8016dc:	89 fa                	mov    %edi,%edx
  8016de:	83 c4 1c             	add    $0x1c,%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5f                   	pop    %edi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    
  8016e6:	66 90                	xchg   %ax,%ax
  8016e8:	89 d8                	mov    %ebx,%eax
  8016ea:	f7 f7                	div    %edi
  8016ec:	31 ff                	xor    %edi,%edi
  8016ee:	89 fa                	mov    %edi,%edx
  8016f0:	83 c4 1c             	add    $0x1c,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5f                   	pop    %edi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    
  8016f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8016fd:	89 eb                	mov    %ebp,%ebx
  8016ff:	29 fb                	sub    %edi,%ebx
  801701:	89 f9                	mov    %edi,%ecx
  801703:	d3 e6                	shl    %cl,%esi
  801705:	89 c5                	mov    %eax,%ebp
  801707:	88 d9                	mov    %bl,%cl
  801709:	d3 ed                	shr    %cl,%ebp
  80170b:	89 e9                	mov    %ebp,%ecx
  80170d:	09 f1                	or     %esi,%ecx
  80170f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801713:	89 f9                	mov    %edi,%ecx
  801715:	d3 e0                	shl    %cl,%eax
  801717:	89 c5                	mov    %eax,%ebp
  801719:	89 d6                	mov    %edx,%esi
  80171b:	88 d9                	mov    %bl,%cl
  80171d:	d3 ee                	shr    %cl,%esi
  80171f:	89 f9                	mov    %edi,%ecx
  801721:	d3 e2                	shl    %cl,%edx
  801723:	8b 44 24 08          	mov    0x8(%esp),%eax
  801727:	88 d9                	mov    %bl,%cl
  801729:	d3 e8                	shr    %cl,%eax
  80172b:	09 c2                	or     %eax,%edx
  80172d:	89 d0                	mov    %edx,%eax
  80172f:	89 f2                	mov    %esi,%edx
  801731:	f7 74 24 0c          	divl   0xc(%esp)
  801735:	89 d6                	mov    %edx,%esi
  801737:	89 c3                	mov    %eax,%ebx
  801739:	f7 e5                	mul    %ebp
  80173b:	39 d6                	cmp    %edx,%esi
  80173d:	72 19                	jb     801758 <__udivdi3+0xfc>
  80173f:	74 0b                	je     80174c <__udivdi3+0xf0>
  801741:	89 d8                	mov    %ebx,%eax
  801743:	31 ff                	xor    %edi,%edi
  801745:	e9 58 ff ff ff       	jmp    8016a2 <__udivdi3+0x46>
  80174a:	66 90                	xchg   %ax,%ax
  80174c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801750:	89 f9                	mov    %edi,%ecx
  801752:	d3 e2                	shl    %cl,%edx
  801754:	39 c2                	cmp    %eax,%edx
  801756:	73 e9                	jae    801741 <__udivdi3+0xe5>
  801758:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80175b:	31 ff                	xor    %edi,%edi
  80175d:	e9 40 ff ff ff       	jmp    8016a2 <__udivdi3+0x46>
  801762:	66 90                	xchg   %ax,%ax
  801764:	31 c0                	xor    %eax,%eax
  801766:	e9 37 ff ff ff       	jmp    8016a2 <__udivdi3+0x46>
  80176b:	90                   	nop

0080176c <__umoddi3>:
  80176c:	55                   	push   %ebp
  80176d:	57                   	push   %edi
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
  801770:	83 ec 1c             	sub    $0x1c,%esp
  801773:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801777:	8b 74 24 34          	mov    0x34(%esp),%esi
  80177b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80177f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801783:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801787:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80178b:	89 f3                	mov    %esi,%ebx
  80178d:	89 fa                	mov    %edi,%edx
  80178f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801793:	89 34 24             	mov    %esi,(%esp)
  801796:	85 c0                	test   %eax,%eax
  801798:	75 1a                	jne    8017b4 <__umoddi3+0x48>
  80179a:	39 f7                	cmp    %esi,%edi
  80179c:	0f 86 a2 00 00 00    	jbe    801844 <__umoddi3+0xd8>
  8017a2:	89 c8                	mov    %ecx,%eax
  8017a4:	89 f2                	mov    %esi,%edx
  8017a6:	f7 f7                	div    %edi
  8017a8:	89 d0                	mov    %edx,%eax
  8017aa:	31 d2                	xor    %edx,%edx
  8017ac:	83 c4 1c             	add    $0x1c,%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
  8017b4:	39 f0                	cmp    %esi,%eax
  8017b6:	0f 87 ac 00 00 00    	ja     801868 <__umoddi3+0xfc>
  8017bc:	0f bd e8             	bsr    %eax,%ebp
  8017bf:	83 f5 1f             	xor    $0x1f,%ebp
  8017c2:	0f 84 ac 00 00 00    	je     801874 <__umoddi3+0x108>
  8017c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8017cd:	29 ef                	sub    %ebp,%edi
  8017cf:	89 fe                	mov    %edi,%esi
  8017d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017d5:	89 e9                	mov    %ebp,%ecx
  8017d7:	d3 e0                	shl    %cl,%eax
  8017d9:	89 d7                	mov    %edx,%edi
  8017db:	89 f1                	mov    %esi,%ecx
  8017dd:	d3 ef                	shr    %cl,%edi
  8017df:	09 c7                	or     %eax,%edi
  8017e1:	89 e9                	mov    %ebp,%ecx
  8017e3:	d3 e2                	shl    %cl,%edx
  8017e5:	89 14 24             	mov    %edx,(%esp)
  8017e8:	89 d8                	mov    %ebx,%eax
  8017ea:	d3 e0                	shl    %cl,%eax
  8017ec:	89 c2                	mov    %eax,%edx
  8017ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017f2:	d3 e0                	shl    %cl,%eax
  8017f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017fc:	89 f1                	mov    %esi,%ecx
  8017fe:	d3 e8                	shr    %cl,%eax
  801800:	09 d0                	or     %edx,%eax
  801802:	d3 eb                	shr    %cl,%ebx
  801804:	89 da                	mov    %ebx,%edx
  801806:	f7 f7                	div    %edi
  801808:	89 d3                	mov    %edx,%ebx
  80180a:	f7 24 24             	mull   (%esp)
  80180d:	89 c6                	mov    %eax,%esi
  80180f:	89 d1                	mov    %edx,%ecx
  801811:	39 d3                	cmp    %edx,%ebx
  801813:	0f 82 87 00 00 00    	jb     8018a0 <__umoddi3+0x134>
  801819:	0f 84 91 00 00 00    	je     8018b0 <__umoddi3+0x144>
  80181f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801823:	29 f2                	sub    %esi,%edx
  801825:	19 cb                	sbb    %ecx,%ebx
  801827:	89 d8                	mov    %ebx,%eax
  801829:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80182d:	d3 e0                	shl    %cl,%eax
  80182f:	89 e9                	mov    %ebp,%ecx
  801831:	d3 ea                	shr    %cl,%edx
  801833:	09 d0                	or     %edx,%eax
  801835:	89 e9                	mov    %ebp,%ecx
  801837:	d3 eb                	shr    %cl,%ebx
  801839:	89 da                	mov    %ebx,%edx
  80183b:	83 c4 1c             	add    $0x1c,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    
  801843:	90                   	nop
  801844:	89 fd                	mov    %edi,%ebp
  801846:	85 ff                	test   %edi,%edi
  801848:	75 0b                	jne    801855 <__umoddi3+0xe9>
  80184a:	b8 01 00 00 00       	mov    $0x1,%eax
  80184f:	31 d2                	xor    %edx,%edx
  801851:	f7 f7                	div    %edi
  801853:	89 c5                	mov    %eax,%ebp
  801855:	89 f0                	mov    %esi,%eax
  801857:	31 d2                	xor    %edx,%edx
  801859:	f7 f5                	div    %ebp
  80185b:	89 c8                	mov    %ecx,%eax
  80185d:	f7 f5                	div    %ebp
  80185f:	89 d0                	mov    %edx,%eax
  801861:	e9 44 ff ff ff       	jmp    8017aa <__umoddi3+0x3e>
  801866:	66 90                	xchg   %ax,%ax
  801868:	89 c8                	mov    %ecx,%eax
  80186a:	89 f2                	mov    %esi,%edx
  80186c:	83 c4 1c             	add    $0x1c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
  801874:	3b 04 24             	cmp    (%esp),%eax
  801877:	72 06                	jb     80187f <__umoddi3+0x113>
  801879:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80187d:	77 0f                	ja     80188e <__umoddi3+0x122>
  80187f:	89 f2                	mov    %esi,%edx
  801881:	29 f9                	sub    %edi,%ecx
  801883:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801887:	89 14 24             	mov    %edx,(%esp)
  80188a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80188e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801892:	8b 14 24             	mov    (%esp),%edx
  801895:	83 c4 1c             	add    $0x1c,%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5f                   	pop    %edi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
  80189d:	8d 76 00             	lea    0x0(%esi),%esi
  8018a0:	2b 04 24             	sub    (%esp),%eax
  8018a3:	19 fa                	sbb    %edi,%edx
  8018a5:	89 d1                	mov    %edx,%ecx
  8018a7:	89 c6                	mov    %eax,%esi
  8018a9:	e9 71 ff ff ff       	jmp    80181f <__umoddi3+0xb3>
  8018ae:	66 90                	xchg   %ax,%ax
  8018b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018b4:	72 ea                	jb     8018a0 <__umoddi3+0x134>
  8018b6:	89 d9                	mov    %ebx,%ecx
  8018b8:	e9 62 ff ff ff       	jmp    80181f <__umoddi3+0xb3>
