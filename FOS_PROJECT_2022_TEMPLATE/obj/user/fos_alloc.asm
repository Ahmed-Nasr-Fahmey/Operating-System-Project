
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 af 10 00 00       	call   8010ff <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 e0 1c 80 00       	push   $0x801ce0
  800061:	e8 22 03 00 00       	call   800388 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 f3 1c 80 00       	push   $0x801cf3
  8000be:	e8 c5 02 00 00       	call   800388 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 64 10 00 00       	call   801140 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 15 10 00 00       	call   8010ff <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 f3 1c 80 00       	push   $0x801cf3
  800114:	e8 6f 02 00 00       	call   800388 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 0e 10 00 00       	call   801140 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 ab 14 00 00       	call   8015ee <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	01 c0                	add    %eax,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800156:	01 c8                	add    %ecx,%eax
  800158:	c1 e0 02             	shl    $0x2,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800164:	01 c8                	add    %ecx,%eax
  800166:	c1 e0 02             	shl    $0x2,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 02             	shl    $0x2,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	c1 e0 03             	shl    $0x3,%eax
  800173:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800178:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017d:	a1 20 30 80 00       	mov    0x803020,%eax
  800182:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800188:	84 c0                	test   %al,%al
  80018a:	74 0f                	je     80019b <libmain+0x63>
		binaryname = myEnv->prog_name;
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	05 18 da 01 00       	add    $0x1da18,%eax
  800196:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019f:	7e 0a                	jle    8001ab <libmain+0x73>
		binaryname = argv[0];
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	8b 00                	mov    (%eax),%eax
  8001a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 7f fe ff ff       	call   800038 <_main>
  8001b9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bc:	e8 3a 12 00 00       	call   8013fb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 18 1d 80 00       	push   $0x801d18
  8001c9:	e8 8d 01 00 00       	call   80035b <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d6:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	52                   	push   %edx
  8001eb:	50                   	push   %eax
  8001ec:	68 40 1d 80 00       	push   $0x801d40
  8001f1:	e8 65 01 00 00       	call   80035b <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fe:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80021a:	51                   	push   %ecx
  80021b:	52                   	push   %edx
  80021c:	50                   	push   %eax
  80021d:	68 68 1d 80 00       	push   $0x801d68
  800222:	e8 34 01 00 00       	call   80035b <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	50                   	push   %eax
  800239:	68 c0 1d 80 00       	push   $0x801dc0
  80023e:	e8 18 01 00 00       	call   80035b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 18 1d 80 00       	push   $0x801d18
  80024e:	e8 08 01 00 00       	call   80035b <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800256:	e8 ba 11 00 00       	call   801415 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80025b:	e8 19 00 00 00       	call   800279 <exit>
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	6a 00                	push   $0x0
  80026e:	e8 47 13 00 00       	call   8015ba <sys_destroy_env>
  800273:	83 c4 10             	add    $0x10,%esp
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <exit>:

void
exit(void)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027f:	e8 9c 13 00 00       	call   801620 <sys_exit_env>
}
  800284:	90                   	nop
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80028d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	8d 48 01             	lea    0x1(%eax),%ecx
  800295:	8b 55 0c             	mov    0xc(%ebp),%edx
  800298:	89 0a                	mov    %ecx,(%edx)
  80029a:	8b 55 08             	mov    0x8(%ebp),%edx
  80029d:	88 d1                	mov    %dl,%cl
  80029f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b0:	75 2c                	jne    8002de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002b2:	a0 24 30 80 00       	mov    0x803024,%al
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bd:	8b 12                	mov    (%edx),%edx
  8002bf:	89 d1                	mov    %edx,%ecx
  8002c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c4:	83 c2 08             	add    $0x8,%edx
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	50                   	push   %eax
  8002cb:	51                   	push   %ecx
  8002cc:	52                   	push   %edx
  8002cd:	e8 7b 0f 00 00       	call   80124d <sys_cputs>
  8002d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	8b 40 04             	mov    0x4(%eax),%eax
  8002e4:	8d 50 01             	lea    0x1(%eax),%edx
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002ed:	90                   	nop
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	68 87 02 80 00       	push   $0x800287
  80031f:	e8 11 02 00 00       	call   800535 <vprintfmt>
  800324:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800327:	a0 24 30 80 00       	mov    0x803024,%al
  80032c:	0f b6 c0             	movzbl %al,%eax
  80032f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	50                   	push   %eax
  800339:	52                   	push   %edx
  80033a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800340:	83 c0 08             	add    $0x8,%eax
  800343:	50                   	push   %eax
  800344:	e8 04 0f 00 00       	call   80124d <sys_cputs>
  800349:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80034c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800353:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800359:	c9                   	leave  
  80035a:	c3                   	ret    

0080035b <cprintf>:

int cprintf(const char *fmt, ...) {
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800361:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800368:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 f4             	pushl  -0xc(%ebp)
  800377:	50                   	push   %eax
  800378:	e8 73 ff ff ff       	call   8002f0 <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80038e:	e8 68 10 00 00       	call   8013fb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800393:	8d 45 0c             	lea    0xc(%ebp),%eax
  800396:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800399:	8b 45 08             	mov    0x8(%ebp),%eax
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a2:	50                   	push   %eax
  8003a3:	e8 48 ff ff ff       	call   8002f0 <vcprintf>
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ae:	e8 62 10 00 00       	call   801415 <sys_enable_interrupt>
	return cnt;
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    

008003b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	53                   	push   %ebx
  8003bc:	83 ec 14             	sub    $0x14,%esp
  8003bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d6:	77 55                	ja     80042d <printnum+0x75>
  8003d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003db:	72 05                	jb     8003e2 <printnum+0x2a>
  8003dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003e0:	77 4b                	ja     80042d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8003f8:	e8 63 16 00 00       	call   801a60 <__udivdi3>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	ff 75 20             	pushl  0x20(%ebp)
  800406:	53                   	push   %ebx
  800407:	ff 75 18             	pushl  0x18(%ebp)
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	e8 a1 ff ff ff       	call   8003b8 <printnum>
  800417:	83 c4 20             	add    $0x20,%esp
  80041a:	eb 1a                	jmp    800436 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 0c             	pushl  0xc(%ebp)
  800422:	ff 75 20             	pushl  0x20(%ebp)
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	ff d0                	call   *%eax
  80042a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042d:	ff 4d 1c             	decl   0x1c(%ebp)
  800430:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800434:	7f e6                	jg     80041c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800436:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800439:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800444:	53                   	push   %ebx
  800445:	51                   	push   %ecx
  800446:	52                   	push   %edx
  800447:	50                   	push   %eax
  800448:	e8 23 17 00 00       	call   801b70 <__umoddi3>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  800455:	8a 00                	mov    (%eax),%al
  800457:	0f be c0             	movsbl %al,%eax
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	50                   	push   %eax
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	ff d0                	call   *%eax
  800466:	83 c4 10             	add    $0x10,%esp
}
  800469:	90                   	nop
  80046a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800472:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800476:	7e 1c                	jle    800494 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	8d 50 08             	lea    0x8(%eax),%edx
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	89 10                	mov    %edx,(%eax)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	83 e8 08             	sub    $0x8,%eax
  80048d:	8b 50 04             	mov    0x4(%eax),%edx
  800490:	8b 00                	mov    (%eax),%eax
  800492:	eb 40                	jmp    8004d4 <getuint+0x65>
	else if (lflag)
  800494:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800498:	74 1e                	je     8004b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	8d 50 04             	lea    0x4(%eax),%edx
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	89 10                	mov    %edx,(%eax)
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	83 e8 04             	sub    $0x4,%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b6:	eb 1c                	jmp    8004d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	8d 50 04             	lea    0x4(%eax),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	89 10                	mov    %edx,(%eax)
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	83 e8 04             	sub    $0x4,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004dd:	7e 1c                	jle    8004fb <getint+0x25>
		return va_arg(*ap, long long);
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	8d 50 08             	lea    0x8(%eax),%edx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	89 10                	mov    %edx,(%eax)
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	83 e8 08             	sub    $0x8,%eax
  8004f4:	8b 50 04             	mov    0x4(%eax),%edx
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	eb 38                	jmp    800533 <getint+0x5d>
	else if (lflag)
  8004fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ff:	74 1a                	je     80051b <getint+0x45>
		return va_arg(*ap, long);
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	8d 50 04             	lea    0x4(%eax),%edx
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	89 10                	mov    %edx,(%eax)
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	83 e8 04             	sub    $0x4,%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	99                   	cltd   
  800519:	eb 18                	jmp    800533 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 50 04             	lea    0x4(%eax),%edx
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	89 10                	mov    %edx,(%eax)
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	83 e8 04             	sub    $0x4,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	99                   	cltd   
}
  800533:	5d                   	pop    %ebp
  800534:	c3                   	ret    

00800535 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	56                   	push   %esi
  800539:	53                   	push   %ebx
  80053a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053d:	eb 17                	jmp    800556 <vprintfmt+0x21>
			if (ch == '\0')
  80053f:	85 db                	test   %ebx,%ebx
  800541:	0f 84 af 03 00 00    	je     8008f6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 0c             	pushl  0xc(%ebp)
  80054d:	53                   	push   %ebx
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	ff d0                	call   *%eax
  800553:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800556:	8b 45 10             	mov    0x10(%ebp),%eax
  800559:	8d 50 01             	lea    0x1(%eax),%edx
  80055c:	89 55 10             	mov    %edx,0x10(%ebp)
  80055f:	8a 00                	mov    (%eax),%al
  800561:	0f b6 d8             	movzbl %al,%ebx
  800564:	83 fb 25             	cmp    $0x25,%ebx
  800567:	75 d6                	jne    80053f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800569:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80056d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800574:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80057b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800582:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	8d 50 01             	lea    0x1(%eax),%edx
  80058f:	89 55 10             	mov    %edx,0x10(%ebp)
  800592:	8a 00                	mov    (%eax),%al
  800594:	0f b6 d8             	movzbl %al,%ebx
  800597:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80059a:	83 f8 55             	cmp    $0x55,%eax
  80059d:	0f 87 2b 03 00 00    	ja     8008ce <vprintfmt+0x399>
  8005a3:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  8005aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005b0:	eb d7                	jmp    800589 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005b6:	eb d1                	jmp    800589 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c2:	89 d0                	mov    %edx,%eax
  8005c4:	c1 e0 02             	shl    $0x2,%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	01 c0                	add    %eax,%eax
  8005cb:	01 d8                	add    %ebx,%eax
  8005cd:	83 e8 30             	sub    $0x30,%eax
  8005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d6:	8a 00                	mov    (%eax),%al
  8005d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005db:	83 fb 2f             	cmp    $0x2f,%ebx
  8005de:	7e 3e                	jle    80061e <vprintfmt+0xe9>
  8005e0:	83 fb 39             	cmp    $0x39,%ebx
  8005e3:	7f 39                	jg     80061e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005e8:	eb d5                	jmp    8005bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	83 c0 04             	add    $0x4,%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	83 e8 04             	sub    $0x4,%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005fe:	eb 1f                	jmp    80061f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	79 83                	jns    800589 <vprintfmt+0x54>
				width = 0;
  800606:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80060d:	e9 77 ff ff ff       	jmp    800589 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800612:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800619:	e9 6b ff ff ff       	jmp    800589 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80061e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80061f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800623:	0f 89 60 ff ff ff    	jns    800589 <vprintfmt+0x54>
				width = precision, precision = -1;
  800629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80062f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800636:	e9 4e ff ff ff       	jmp    800589 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80063b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80063e:	e9 46 ff ff ff       	jmp    800589 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	83 c0 04             	add    $0x4,%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	83 e8 04             	sub    $0x4,%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
			break;
  800663:	e9 89 02 00 00       	jmp    8008f1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	83 c0 04             	add    $0x4,%eax
  80066e:	89 45 14             	mov    %eax,0x14(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	83 e8 04             	sub    $0x4,%eax
  800677:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800679:	85 db                	test   %ebx,%ebx
  80067b:	79 02                	jns    80067f <vprintfmt+0x14a>
				err = -err;
  80067d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80067f:	83 fb 64             	cmp    $0x64,%ebx
  800682:	7f 0b                	jg     80068f <vprintfmt+0x15a>
  800684:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  80068b:	85 f6                	test   %esi,%esi
  80068d:	75 19                	jne    8006a8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80068f:	53                   	push   %ebx
  800690:	68 05 20 80 00       	push   $0x802005
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 08             	pushl  0x8(%ebp)
  80069b:	e8 5e 02 00 00       	call   8008fe <printfmt>
  8006a0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a3:	e9 49 02 00 00       	jmp    8008f1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006a8:	56                   	push   %esi
  8006a9:	68 0e 20 80 00       	push   $0x80200e
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	ff 75 08             	pushl  0x8(%ebp)
  8006b4:	e8 45 02 00 00       	call   8008fe <printfmt>
  8006b9:	83 c4 10             	add    $0x10,%esp
			break;
  8006bc:	e9 30 02 00 00       	jmp    8008f1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	83 c0 04             	add    $0x4,%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 30                	mov    (%eax),%esi
  8006d2:	85 f6                	test   %esi,%esi
  8006d4:	75 05                	jne    8006db <vprintfmt+0x1a6>
				p = "(null)";
  8006d6:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  8006db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006df:	7e 6d                	jle    80074e <vprintfmt+0x219>
  8006e1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006e5:	74 67                	je     80074e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	50                   	push   %eax
  8006ee:	56                   	push   %esi
  8006ef:	e8 0c 03 00 00       	call   800a00 <strnlen>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006fa:	eb 16                	jmp    800712 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006fc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	50                   	push   %eax
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	ff d0                	call   *%eax
  80070c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070f:	ff 4d e4             	decl   -0x1c(%ebp)
  800712:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800716:	7f e4                	jg     8006fc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800718:	eb 34                	jmp    80074e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80071a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071e:	74 1c                	je     80073c <vprintfmt+0x207>
  800720:	83 fb 1f             	cmp    $0x1f,%ebx
  800723:	7e 05                	jle    80072a <vprintfmt+0x1f5>
  800725:	83 fb 7e             	cmp    $0x7e,%ebx
  800728:	7e 12                	jle    80073c <vprintfmt+0x207>
					putch('?', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	6a 3f                	push   $0x3f
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	eb 0f                	jmp    80074b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	53                   	push   %ebx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	ff d0                	call   *%eax
  800748:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074b:	ff 4d e4             	decl   -0x1c(%ebp)
  80074e:	89 f0                	mov    %esi,%eax
  800750:	8d 70 01             	lea    0x1(%eax),%esi
  800753:	8a 00                	mov    (%eax),%al
  800755:	0f be d8             	movsbl %al,%ebx
  800758:	85 db                	test   %ebx,%ebx
  80075a:	74 24                	je     800780 <vprintfmt+0x24b>
  80075c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800760:	78 b8                	js     80071a <vprintfmt+0x1e5>
  800762:	ff 4d e0             	decl   -0x20(%ebp)
  800765:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800769:	79 af                	jns    80071a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076b:	eb 13                	jmp    800780 <vprintfmt+0x24b>
				putch(' ', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	6a 20                	push   $0x20
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80077d:	ff 4d e4             	decl   -0x1c(%ebp)
  800780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800784:	7f e7                	jg     80076d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800786:	e9 66 01 00 00       	jmp    8008f1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 e8             	pushl  -0x18(%ebp)
  800791:	8d 45 14             	lea    0x14(%ebp),%eax
  800794:	50                   	push   %eax
  800795:	e8 3c fd ff ff       	call   8004d6 <getint>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	79 23                	jns    8007d0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	6a 2d                	push   $0x2d
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c3:	f7 d8                	neg    %eax
  8007c5:	83 d2 00             	adc    $0x0,%edx
  8007c8:	f7 da                	neg    %edx
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d7:	e9 bc 00 00 00       	jmp    800898 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	e8 84 fc ff ff       	call   80046f <getuint>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007fb:	e9 98 00 00 00       	jmp    800898 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	6a 58                	push   $0x58
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	6a 58                	push   $0x58
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			break;
  800830:	e9 bc 00 00 00       	jmp    8008f1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 30                	push   $0x30
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	6a 78                	push   $0x78
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 c0 04             	add    $0x4,%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	83 e8 04             	sub    $0x4,%eax
  800864:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800869:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800870:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800877:	eb 1f                	jmp    800898 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 e8             	pushl  -0x18(%ebp)
  80087f:	8d 45 14             	lea    0x14(%ebp),%eax
  800882:	50                   	push   %eax
  800883:	e8 e7 fb ff ff       	call   80046f <getuint>
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800898:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80089c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089f:	83 ec 04             	sub    $0x4,%esp
  8008a2:	52                   	push   %edx
  8008a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 00 fb ff ff       	call   8003b8 <printnum>
  8008b8:	83 c4 20             	add    $0x20,%esp
			break;
  8008bb:	eb 34                	jmp    8008f1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
			break;
  8008cc:	eb 23                	jmp    8008f1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	6a 25                	push   $0x25
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	ff d0                	call   *%eax
  8008db:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008de:	ff 4d 10             	decl   0x10(%ebp)
  8008e1:	eb 03                	jmp    8008e6 <vprintfmt+0x3b1>
  8008e3:	ff 4d 10             	decl   0x10(%ebp)
  8008e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e9:	48                   	dec    %eax
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	3c 25                	cmp    $0x25,%al
  8008ee:	75 f3                	jne    8008e3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008f0:	90                   	nop
		}
	}
  8008f1:	e9 47 fc ff ff       	jmp    80053d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fa:	5b                   	pop    %ebx
  8008fb:	5e                   	pop    %esi
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800904:	8d 45 10             	lea    0x10(%ebp),%eax
  800907:	83 c0 04             	add    $0x4,%eax
  80090a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090d:	8b 45 10             	mov    0x10(%ebp),%eax
  800910:	ff 75 f4             	pushl  -0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 16 fc ff ff       	call   800535 <vprintfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800922:	90                   	nop
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092b:	8b 40 08             	mov    0x8(%eax),%eax
  80092e:	8d 50 01             	lea    0x1(%eax),%edx
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	8b 10                	mov    (%eax),%edx
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8b 40 04             	mov    0x4(%eax),%eax
  800942:	39 c2                	cmp    %eax,%edx
  800944:	73 12                	jae    800958 <sprintputch+0x33>
		*b->buf++ = ch;
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	8d 48 01             	lea    0x1(%eax),%ecx
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800951:	89 0a                	mov    %ecx,(%edx)
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
  800956:	88 10                	mov    %dl,(%eax)
}
  800958:	90                   	nop
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	01 d0                	add    %edx,%eax
  800972:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800975:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800980:	74 06                	je     800988 <vsnprintf+0x2d>
  800982:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800986:	7f 07                	jg     80098f <vsnprintf+0x34>
		return -E_INVAL;
  800988:	b8 03 00 00 00       	mov    $0x3,%eax
  80098d:	eb 20                	jmp    8009af <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098f:	ff 75 14             	pushl  0x14(%ebp)
  800992:	ff 75 10             	pushl  0x10(%ebp)
  800995:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 25 09 80 00       	push   $0x800925
  80099e:	e8 92 fb ff ff       	call   800535 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	ff 75 08             	pushl  0x8(%ebp)
  8009cd:	e8 89 ff ff ff       	call   80095b <vsnprintf>
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    

008009dd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ea:	eb 06                	jmp    8009f2 <strlen+0x15>
		n++;
  8009ec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ef:	ff 45 08             	incl   0x8(%ebp)
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	8a 00                	mov    (%eax),%al
  8009f7:	84 c0                	test   %al,%al
  8009f9:	75 f1                	jne    8009ec <strlen+0xf>
		n++;
	return n;
  8009fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0d:	eb 09                	jmp    800a18 <strnlen+0x18>
		n++;
  800a0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a12:	ff 45 08             	incl   0x8(%ebp)
  800a15:	ff 4d 0c             	decl   0xc(%ebp)
  800a18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1c:	74 09                	je     800a27 <strnlen+0x27>
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	84 c0                	test   %al,%al
  800a25:	75 e8                	jne    800a0f <strnlen+0xf>
		n++;
	return n;
  800a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a38:	90                   	nop
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8d 50 01             	lea    0x1(%eax),%edx
  800a3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a4b:	8a 12                	mov    (%edx),%dl
  800a4d:	88 10                	mov    %dl,(%eax)
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	84 c0                	test   %al,%al
  800a53:	75 e4                	jne    800a39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a6d:	eb 1f                	jmp    800a8e <strncpy+0x34>
		*dst++ = *src;
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8d 50 01             	lea    0x1(%eax),%edx
  800a75:	89 55 08             	mov    %edx,0x8(%ebp)
  800a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7b:	8a 12                	mov    (%edx),%dl
  800a7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	8a 00                	mov    (%eax),%al
  800a84:	84 c0                	test   %al,%al
  800a86:	74 03                	je     800a8b <strncpy+0x31>
			src++;
  800a88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8b:	ff 45 fc             	incl   -0x4(%ebp)
  800a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a94:	72 d9                	jb     800a6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a99:	c9                   	leave  
  800a9a:	c3                   	ret    

00800a9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aab:	74 30                	je     800add <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aad:	eb 16                	jmp    800ac5 <strlcpy+0x2a>
			*dst++ = *src++;
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8d 50 01             	lea    0x1(%eax),%edx
  800ab5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800abe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac1:	8a 12                	mov    (%edx),%dl
  800ac3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac5:	ff 4d 10             	decl   0x10(%ebp)
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 09                	je     800ad7 <strlcpy+0x3c>
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	84 c0                	test   %al,%al
  800ad5:	75 d8                	jne    800aaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae3:	29 c2                	sub    %eax,%edx
  800ae5:	89 d0                	mov    %edx,%eax
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800aec:	eb 06                	jmp    800af4 <strcmp+0xb>
		p++, q++;
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	84 c0                	test   %al,%al
  800afb:	74 0e                	je     800b0b <strcmp+0x22>
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8a 10                	mov    (%eax),%dl
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	38 c2                	cmp    %al,%dl
  800b09:	74 e3                	je     800aee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8a 00                	mov    (%eax),%al
  800b10:	0f b6 d0             	movzbl %al,%edx
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8a 00                	mov    (%eax),%al
  800b18:	0f b6 c0             	movzbl %al,%eax
  800b1b:	29 c2                	sub    %eax,%edx
  800b1d:	89 d0                	mov    %edx,%eax
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b24:	eb 09                	jmp    800b2f <strncmp+0xe>
		n--, p++, q++;
  800b26:	ff 4d 10             	decl   0x10(%ebp)
  800b29:	ff 45 08             	incl   0x8(%ebp)
  800b2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b33:	74 17                	je     800b4c <strncmp+0x2b>
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8a 00                	mov    (%eax),%al
  800b3a:	84 c0                	test   %al,%al
  800b3c:	74 0e                	je     800b4c <strncmp+0x2b>
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8a 10                	mov    (%eax),%dl
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	38 c2                	cmp    %al,%dl
  800b4a:	74 da                	je     800b26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b50:	75 07                	jne    800b59 <strncmp+0x38>
		return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	eb 14                	jmp    800b6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	0f b6 d0             	movzbl %al,%edx
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f b6 c0             	movzbl %al,%eax
  800b69:	29 c2                	sub    %eax,%edx
  800b6b:	89 d0                	mov    %edx,%eax
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 04             	sub    $0x4,%esp
  800b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b7b:	eb 12                	jmp    800b8f <strchr+0x20>
		if (*s == c)
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8a 00                	mov    (%eax),%al
  800b82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b85:	75 05                	jne    800b8c <strchr+0x1d>
			return (char *) s;
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	eb 11                	jmp    800b9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b8c:	ff 45 08             	incl   0x8(%ebp)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	75 e5                	jne    800b7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    

00800b9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	83 ec 04             	sub    $0x4,%esp
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bab:	eb 0d                	jmp    800bba <strfind+0x1b>
		if (*s == c)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb5:	74 0e                	je     800bc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	84 c0                	test   %al,%al
  800bc1:	75 ea                	jne    800bad <strfind+0xe>
  800bc3:	eb 01                	jmp    800bc6 <strfind+0x27>
		if (*s == c)
			break;
  800bc5:	90                   	nop
	return (char *) s;
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bdd:	eb 0e                	jmp    800bed <memset+0x22>
		*p++ = c;
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	8d 50 01             	lea    0x1(%eax),%edx
  800be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800beb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bed:	ff 4d f8             	decl   -0x8(%ebp)
  800bf0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf4:	79 e9                	jns    800bdf <memset+0x14>
		*p++ = c;

	return v;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c0d:	eb 16                	jmp    800c25 <memcpy+0x2a>
		*d++ = *s++;
  800c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c12:	8d 50 01             	lea    0x1(%eax),%edx
  800c15:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c21:	8a 12                	mov    (%edx),%dl
  800c23:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	75 dd                	jne    800c0f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c4f:	73 50                	jae    800ca1 <memmove+0x6a>
  800c51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	01 d0                	add    %edx,%eax
  800c59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5c:	76 43                	jbe    800ca1 <memmove+0x6a>
		s += n;
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c6a:	eb 10                	jmp    800c7c <memmove+0x45>
			*--d = *--s;
  800c6c:	ff 4d f8             	decl   -0x8(%ebp)
  800c6f:	ff 4d fc             	decl   -0x4(%ebp)
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c75:	8a 10                	mov    (%eax),%dl
  800c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c82:	89 55 10             	mov    %edx,0x10(%ebp)
  800c85:	85 c0                	test   %eax,%eax
  800c87:	75 e3                	jne    800c6c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c89:	eb 23                	jmp    800cae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8e:	8d 50 01             	lea    0x1(%eax),%edx
  800c91:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c9d:	8a 12                	mov    (%edx),%dl
  800c9f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca7:	89 55 10             	mov    %edx,0x10(%ebp)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	75 dd                	jne    800c8b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc5:	eb 2a                	jmp    800cf1 <memcmp+0x3e>
		if (*s1 != *s2)
  800cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 16                	je     800ceb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
  800ce9:	eb 18                	jmp    800d03 <memcmp+0x50>
		s1++, s2++;
  800ceb:	ff 45 fc             	incl   -0x4(%ebp)
  800cee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfa:	85 c0                	test   %eax,%eax
  800cfc:	75 c9                	jne    800cc7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d16:	eb 15                	jmp    800d2d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	39 c2                	cmp    %eax,%edx
  800d28:	74 0d                	je     800d37 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2a:	ff 45 08             	incl   0x8(%ebp)
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d33:	72 e3                	jb     800d18 <memfind+0x13>
  800d35:	eb 01                	jmp    800d38 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d37:	90                   	nop
	return (void *) s;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d51:	eb 03                	jmp    800d56 <strtol+0x19>
		s++;
  800d53:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 20                	cmp    $0x20,%al
  800d5d:	74 f4                	je     800d53 <strtol+0x16>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 09                	cmp    $0x9,%al
  800d66:	74 eb                	je     800d53 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	3c 2b                	cmp    $0x2b,%al
  800d6f:	75 05                	jne    800d76 <strtol+0x39>
		s++;
  800d71:	ff 45 08             	incl   0x8(%ebp)
  800d74:	eb 13                	jmp    800d89 <strtol+0x4c>
	else if (*s == '-')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 2d                	cmp    $0x2d,%al
  800d7d:	75 0a                	jne    800d89 <strtol+0x4c>
		s++, neg = 1;
  800d7f:	ff 45 08             	incl   0x8(%ebp)
  800d82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8d:	74 06                	je     800d95 <strtol+0x58>
  800d8f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d93:	75 20                	jne    800db5 <strtol+0x78>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 30                	cmp    $0x30,%al
  800d9c:	75 17                	jne    800db5 <strtol+0x78>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	40                   	inc    %eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 78                	cmp    $0x78,%al
  800da6:	75 0d                	jne    800db5 <strtol+0x78>
		s += 2, base = 16;
  800da8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db3:	eb 28                	jmp    800ddd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db9:	75 15                	jne    800dd0 <strtol+0x93>
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	3c 30                	cmp    $0x30,%al
  800dc2:	75 0c                	jne    800dd0 <strtol+0x93>
		s++, base = 8;
  800dc4:	ff 45 08             	incl   0x8(%ebp)
  800dc7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dce:	eb 0d                	jmp    800ddd <strtol+0xa0>
	else if (base == 0)
  800dd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd4:	75 07                	jne    800ddd <strtol+0xa0>
		base = 10;
  800dd6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	3c 2f                	cmp    $0x2f,%al
  800de4:	7e 19                	jle    800dff <strtol+0xc2>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	3c 39                	cmp    $0x39,%al
  800ded:	7f 10                	jg     800dff <strtol+0xc2>
			dig = *s - '0';
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f be c0             	movsbl %al,%eax
  800df7:	83 e8 30             	sub    $0x30,%eax
  800dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dfd:	eb 42                	jmp    800e41 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	3c 60                	cmp    $0x60,%al
  800e06:	7e 19                	jle    800e21 <strtol+0xe4>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	3c 7a                	cmp    $0x7a,%al
  800e0f:	7f 10                	jg     800e21 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	0f be c0             	movsbl %al,%eax
  800e19:	83 e8 57             	sub    $0x57,%eax
  800e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1f:	eb 20                	jmp    800e41 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	3c 40                	cmp    $0x40,%al
  800e28:	7e 39                	jle    800e63 <strtol+0x126>
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3c 5a                	cmp    $0x5a,%al
  800e31:	7f 30                	jg     800e63 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f be c0             	movsbl %al,%eax
  800e3b:	83 e8 37             	sub    $0x37,%eax
  800e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e47:	7d 19                	jge    800e62 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e49:	ff 45 08             	incl   0x8(%ebp)
  800e4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e58:	01 d0                	add    %edx,%eax
  800e5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e5d:	e9 7b ff ff ff       	jmp    800ddd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e62:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 08                	je     800e71 <strtol+0x134>
		*endptr = (char *) s;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e75:	74 07                	je     800e7e <strtol+0x141>
  800e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7a:	f7 d8                	neg    %eax
  800e7c:	eb 03                	jmp    800e81 <strtol+0x144>
  800e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <ltostr>:

void
ltostr(long value, char *str)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e90:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9b:	79 13                	jns    800eb0 <ltostr+0x2d>
	{
		neg = 1;
  800e9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eaa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ead:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb8:	99                   	cltd   
  800eb9:	f7 f9                	idiv   %ecx
  800ebb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	89 c2                	mov    %eax,%edx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	01 d0                	add    %edx,%eax
  800ece:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed1:	83 c2 30             	add    $0x30,%edx
  800ed4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ede:	f7 e9                	imul   %ecx
  800ee0:	c1 fa 02             	sar    $0x2,%edx
  800ee3:	89 c8                	mov    %ecx,%eax
  800ee5:	c1 f8 1f             	sar    $0x1f,%eax
  800ee8:	29 c2                	sub    %eax,%edx
  800eea:	89 d0                	mov    %edx,%eax
  800eec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800eef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ef7:	f7 e9                	imul   %ecx
  800ef9:	c1 fa 02             	sar    $0x2,%edx
  800efc:	89 c8                	mov    %ecx,%eax
  800efe:	c1 f8 1f             	sar    $0x1f,%eax
  800f01:	29 c2                	sub    %eax,%edx
  800f03:	89 d0                	mov    %edx,%eax
  800f05:	c1 e0 02             	shl    $0x2,%eax
  800f08:	01 d0                	add    %edx,%eax
  800f0a:	01 c0                	add    %eax,%eax
  800f0c:	29 c1                	sub    %eax,%ecx
  800f0e:	89 ca                	mov    %ecx,%edx
  800f10:	85 d2                	test   %edx,%edx
  800f12:	75 9c                	jne    800eb0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	48                   	dec    %eax
  800f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f26:	74 3d                	je     800f65 <ltostr+0xe2>
		start = 1 ;
  800f28:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f2f:	eb 34                	jmp    800f65 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	01 c2                	add    %eax,%edx
  800f46:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	01 c8                	add    %ecx,%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 c2                	add    %eax,%edx
  800f5a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f5d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f5f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f62:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6b:	7c c4                	jl     800f31 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f6d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	01 d0                	add    %edx,%eax
  800f75:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f78:	90                   	nop
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f81:	ff 75 08             	pushl  0x8(%ebp)
  800f84:	e8 54 fa ff ff       	call   8009dd <strlen>
  800f89:	83 c4 04             	add    $0x4,%esp
  800f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f8f:	ff 75 0c             	pushl  0xc(%ebp)
  800f92:	e8 46 fa ff ff       	call   8009dd <strlen>
  800f97:	83 c4 04             	add    $0x4,%esp
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fab:	eb 17                	jmp    800fc4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	01 c8                	add    %ecx,%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fc1:	ff 45 fc             	incl   -0x4(%ebp)
  800fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fca:	7c e1                	jl     800fad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fcc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fd3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fda:	eb 1f                	jmp    800ffb <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdf:	8d 50 01             	lea    0x1(%eax),%edx
  800fe2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe5:	89 c2                	mov    %eax,%edx
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	01 c2                	add    %eax,%edx
  800fec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ff8:	ff 45 f8             	incl   -0x8(%ebp)
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801001:	7c d9                	jl     800fdc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801003:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	c6 00 00             	movb   $0x0,(%eax)
}
  80100e:	90                   	nop
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801014:	8b 45 14             	mov    0x14(%ebp),%eax
  801017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80101d:	8b 45 14             	mov    0x14(%ebp),%eax
  801020:	8b 00                	mov    (%eax),%eax
  801022:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801034:	eb 0c                	jmp    801042 <strsplit+0x31>
			*string++ = 0;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8d 50 01             	lea    0x1(%eax),%edx
  80103c:	89 55 08             	mov    %edx,0x8(%ebp)
  80103f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	84 c0                	test   %al,%al
  801049:	74 18                	je     801063 <strsplit+0x52>
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be c0             	movsbl %al,%eax
  801053:	50                   	push   %eax
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	e8 13 fb ff ff       	call   800b6f <strchr>
  80105c:	83 c4 08             	add    $0x8,%esp
  80105f:	85 c0                	test   %eax,%eax
  801061:	75 d3                	jne    801036 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 5a                	je     8010c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80106c:	8b 45 14             	mov    0x14(%ebp),%eax
  80106f:	8b 00                	mov    (%eax),%eax
  801071:	83 f8 0f             	cmp    $0xf,%eax
  801074:	75 07                	jne    80107d <strsplit+0x6c>
		{
			return 0;
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	eb 66                	jmp    8010e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80107d:	8b 45 14             	mov    0x14(%ebp),%eax
  801080:	8b 00                	mov    (%eax),%eax
  801082:	8d 48 01             	lea    0x1(%eax),%ecx
  801085:	8b 55 14             	mov    0x14(%ebp),%edx
  801088:	89 0a                	mov    %ecx,(%edx)
  80108a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801091:	8b 45 10             	mov    0x10(%ebp),%eax
  801094:	01 c2                	add    %eax,%edx
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80109b:	eb 03                	jmp    8010a0 <strsplit+0x8f>
			string++;
  80109d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	84 c0                	test   %al,%al
  8010a7:	74 8b                	je     801034 <strsplit+0x23>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	0f be c0             	movsbl %al,%eax
  8010b1:	50                   	push   %eax
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	e8 b5 fa ff ff       	call   800b6f <strchr>
  8010ba:	83 c4 08             	add    $0x8,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	74 dc                	je     80109d <strsplit+0x8c>
			string++;
	}
  8010c1:	e9 6e ff ff ff       	jmp    801034 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ca:	8b 00                	mov    (%eax),%eax
  8010cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	01 d0                	add    %edx,%eax
  8010d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	68 70 21 80 00       	push   $0x802170
  8010f3:	6a 0e                	push   $0xe
  8010f5:	68 aa 21 80 00       	push   $0x8021aa
  8010fa:	e8 81 07 00 00       	call   801880 <_panic>

008010ff <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801105:	a1 04 30 80 00       	mov    0x803004,%eax
  80110a:	85 c0                	test   %eax,%eax
  80110c:	74 0f                	je     80111d <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80110e:	e8 d2 ff ff ff       	call   8010e5 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801113:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80111a:	00 00 00 
	}
	if (size == 0) return NULL ;
  80111d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801121:	75 07                	jne    80112a <malloc+0x2b>
  801123:	b8 00 00 00 00       	mov    $0x0,%eax
  801128:	eb 14                	jmp    80113e <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80112a:	83 ec 04             	sub    $0x4,%esp
  80112d:	68 b8 21 80 00       	push   $0x8021b8
  801132:	6a 2e                	push   $0x2e
  801134:	68 aa 21 80 00       	push   $0x8021aa
  801139:	e8 42 07 00 00       	call   801880 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801146:	83 ec 04             	sub    $0x4,%esp
  801149:	68 e0 21 80 00       	push   $0x8021e0
  80114e:	6a 49                	push   $0x49
  801150:	68 aa 21 80 00       	push   $0x8021aa
  801155:	e8 26 07 00 00       	call   801880 <_panic>

0080115a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	68 04 22 80 00       	push   $0x802204
  80116e:	6a 57                	push   $0x57
  801170:	68 aa 21 80 00       	push   $0x8021aa
  801175:	e8 06 07 00 00       	call   801880 <_panic>

0080117a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801180:	83 ec 04             	sub    $0x4,%esp
  801183:	68 2c 22 80 00       	push   $0x80222c
  801188:	6a 60                	push   $0x60
  80118a:	68 aa 21 80 00       	push   $0x8021aa
  80118f:	e8 ec 06 00 00       	call   801880 <_panic>

00801194 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	68 50 22 80 00       	push   $0x802250
  8011a2:	6a 7c                	push   $0x7c
  8011a4:	68 aa 21 80 00       	push   $0x8021aa
  8011a9:	e8 d2 06 00 00       	call   801880 <_panic>

008011ae <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	68 78 22 80 00       	push   $0x802278
  8011bc:	68 86 00 00 00       	push   $0x86
  8011c1:	68 aa 21 80 00       	push   $0x8021aa
  8011c6:	e8 b5 06 00 00       	call   801880 <_panic>

008011cb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	68 9c 22 80 00       	push   $0x80229c
  8011d9:	68 91 00 00 00       	push   $0x91
  8011de:	68 aa 21 80 00       	push   $0x8021aa
  8011e3:	e8 98 06 00 00       	call   801880 <_panic>

008011e8 <shrink>:

}
void shrink(uint32 newSize)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	68 9c 22 80 00       	push   $0x80229c
  8011f6:	68 96 00 00 00       	push   $0x96
  8011fb:	68 aa 21 80 00       	push   $0x8021aa
  801200:	e8 7b 06 00 00       	call   801880 <_panic>

00801205 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 9c 22 80 00       	push   $0x80229c
  801213:	68 9b 00 00 00       	push   $0x9b
  801218:	68 aa 21 80 00       	push   $0x8021aa
  80121d:	e8 5e 06 00 00       	call   801880 <_panic>

00801222 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801231:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801234:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801237:	8b 7d 18             	mov    0x18(%ebp),%edi
  80123a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80123d:	cd 30                	int    $0x30
  80123f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	5b                   	pop    %ebx
  801249:	5e                   	pop    %esi
  80124a:	5f                   	pop    %edi
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801259:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	52                   	push   %edx
  801265:	ff 75 0c             	pushl  0xc(%ebp)
  801268:	50                   	push   %eax
  801269:	6a 00                	push   $0x0
  80126b:	e8 b2 ff ff ff       	call   801222 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	90                   	nop
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <sys_cgetc>:

int
sys_cgetc(void)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 01                	push   $0x1
  801285:	e8 98 ff ff ff       	call   801222 <syscall>
  80128a:	83 c4 18             	add    $0x18,%esp
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801292:	8b 55 0c             	mov    0xc(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	6a 05                	push   $0x5
  8012a2:	e8 7b ff ff ff       	call   801222 <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	51                   	push   %ecx
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 06                	push   $0x6
  8012c7:	e8 56 ff ff ff       	call   801222 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	52                   	push   %edx
  8012e6:	50                   	push   %eax
  8012e7:	6a 07                	push   $0x7
  8012e9:	e8 34 ff ff ff       	call   801222 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	ff 75 08             	pushl  0x8(%ebp)
  801302:	6a 08                	push   $0x8
  801304:	e8 19 ff ff ff       	call   801222 <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 09                	push   $0x9
  80131d:	e8 00 ff ff ff       	call   801222 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 0a                	push   $0xa
  801336:	e8 e7 fe ff ff       	call   801222 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 0b                	push   $0xb
  80134f:	e8 ce fe ff ff       	call   801222 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	6a 0f                	push   $0xf
  80136a:	e8 b3 fe ff ff       	call   801222 <syscall>
  80136f:	83 c4 18             	add    $0x18,%esp
	return;
  801372:	90                   	nop
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	ff 75 0c             	pushl  0xc(%ebp)
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	6a 10                	push   $0x10
  801386:	e8 97 fe ff ff       	call   801222 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
	return ;
  80138e:	90                   	nop
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	ff 75 10             	pushl  0x10(%ebp)
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	ff 75 08             	pushl  0x8(%ebp)
  8013a1:	6a 11                	push   $0x11
  8013a3:	e8 7a fe ff ff       	call   801222 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ab:	90                   	nop
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 0c                	push   $0xc
  8013bd:	e8 60 fe ff ff       	call   801222 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	ff 75 08             	pushl  0x8(%ebp)
  8013d5:	6a 0d                	push   $0xd
  8013d7:	e8 46 fe ff ff       	call   801222 <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 0e                	push   $0xe
  8013f0:	e8 2d fe ff ff       	call   801222 <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	90                   	nop
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 13                	push   $0x13
  80140a:	e8 13 fe ff ff       	call   801222 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	90                   	nop
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 14                	push   $0x14
  801424:	e8 f9 fd ff ff       	call   801222 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	90                   	nop
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_cputc>:


void
sys_cputc(const char c)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80143b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	50                   	push   %eax
  801448:	6a 15                	push   $0x15
  80144a:	e8 d3 fd ff ff       	call   801222 <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	90                   	nop
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 16                	push   $0x16
  801464:	e8 b9 fd ff ff       	call   801222 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	50                   	push   %eax
  80147f:	6a 17                	push   $0x17
  801481:	e8 9c fd ff ff       	call   801222 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80148e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	52                   	push   %edx
  80149b:	50                   	push   %eax
  80149c:	6a 1a                	push   $0x1a
  80149e:	e8 7f fd ff ff       	call   801222 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	52                   	push   %edx
  8014b8:	50                   	push   %eax
  8014b9:	6a 18                	push   $0x18
  8014bb:	e8 62 fd ff ff       	call   801222 <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	90                   	nop
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	52                   	push   %edx
  8014d6:	50                   	push   %eax
  8014d7:	6a 19                	push   $0x19
  8014d9:	e8 44 fd ff ff       	call   801222 <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	90                   	nop
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	6a 00                	push   $0x0
  8014fc:	51                   	push   %ecx
  8014fd:	52                   	push   %edx
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	50                   	push   %eax
  801502:	6a 1b                	push   $0x1b
  801504:	e8 19 fd ff ff       	call   801222 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 1c                	push   $0x1c
  801521:	e8 fc fc ff ff       	call   801222 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80152e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801531:	8b 55 0c             	mov    0xc(%ebp),%edx
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	51                   	push   %ecx
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	6a 1d                	push   $0x1d
  801540:	e8 dd fc ff ff       	call   801222 <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80154d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	6a 1e                	push   $0x1e
  80155d:	e8 c0 fc ff ff       	call   801222 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 1f                	push   $0x1f
  801576:	e8 a7 fc ff ff       	call   801222 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	6a 00                	push   $0x0
  801588:	ff 75 14             	pushl  0x14(%ebp)
  80158b:	ff 75 10             	pushl  0x10(%ebp)
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	50                   	push   %eax
  801592:	6a 20                	push   $0x20
  801594:	e8 89 fc ff ff       	call   801222 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	50                   	push   %eax
  8015ad:	6a 21                	push   $0x21
  8015af:	e8 6e fc ff ff       	call   801222 <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	90                   	nop
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	50                   	push   %eax
  8015c9:	6a 22                	push   $0x22
  8015cb:	e8 52 fc ff ff       	call   801222 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 02                	push   $0x2
  8015e4:	e8 39 fc ff ff       	call   801222 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 03                	push   $0x3
  8015fd:	e8 20 fc ff ff       	call   801222 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 04                	push   $0x4
  801616:	e8 07 fc ff ff       	call   801222 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_exit_env>:


void sys_exit_env(void)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 23                	push   $0x23
  80162f:	e8 ee fb ff ff       	call   801222 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801640:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801643:	8d 50 04             	lea    0x4(%eax),%edx
  801646:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	52                   	push   %edx
  801650:	50                   	push   %eax
  801651:	6a 24                	push   $0x24
  801653:	e8 ca fb ff ff       	call   801222 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
	return result;
  80165b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80165e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801661:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801664:	89 01                	mov    %eax,(%ecx)
  801666:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	c9                   	leave  
  80166d:	c2 04 00             	ret    $0x4

00801670 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	ff 75 10             	pushl  0x10(%ebp)
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	6a 12                	push   $0x12
  801682:	e8 9b fb ff ff       	call   801222 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
	return ;
  80168a:	90                   	nop
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_rcr2>:
uint32 sys_rcr2()
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 25                	push   $0x25
  80169c:	e8 81 fb ff ff       	call   801222 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	50                   	push   %eax
  8016bf:	6a 26                	push   $0x26
  8016c1:	e8 5c fb ff ff       	call   801222 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c9:	90                   	nop
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <rsttst>:
void rsttst()
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 28                	push   $0x28
  8016db:	e8 42 fb ff ff       	call   801222 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8016f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	ff 75 10             	pushl  0x10(%ebp)
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	6a 27                	push   $0x27
  801706:	e8 17 fb ff ff       	call   801222 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return ;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <chktst>:
void chktst(uint32 n)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	6a 29                	push   $0x29
  801721:	e8 fc fa ff ff       	call   801222 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
	return ;
  801729:	90                   	nop
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <inctst>:

void inctst()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 2a                	push   $0x2a
  80173b:	e8 e2 fa ff ff       	call   801222 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return ;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <gettst>:
uint32 gettst()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 2b                	push   $0x2b
  801755:	e8 c8 fa ff ff       	call   801222 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 2c                	push   $0x2c
  801771:	e8 ac fa ff ff       	call   801222 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
  801779:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80177c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801780:	75 07                	jne    801789 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	eb 05                	jmp    80178e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 2c                	push   $0x2c
  8017a2:	e8 7b fa ff ff       	call   801222 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
  8017aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017b1:	75 07                	jne    8017ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b8:	eb 05                	jmp    8017bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 2c                	push   $0x2c
  8017d3:	e8 4a fa ff ff       	call   801222 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
  8017db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017e2:	75 07                	jne    8017eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e9:	eb 05                	jmp    8017f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 2c                	push   $0x2c
  801804:	e8 19 fa ff ff       	call   801222 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
  80180c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80180f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801813:	75 07                	jne    80181c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801815:	b8 01 00 00 00       	mov    $0x1,%eax
  80181a:	eb 05                	jmp    801821 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	ff 75 08             	pushl  0x8(%ebp)
  801831:	6a 2d                	push   $0x2d
  801833:	e8 ea f9 ff ff       	call   801222 <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
	return ;
  80183b:	90                   	nop
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801842:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801845:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	53                   	push   %ebx
  801851:	51                   	push   %ecx
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 2e                	push   $0x2e
  801856:	e8 c7 f9 ff ff       	call   801222 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801866:	8b 55 0c             	mov    0xc(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	6a 2f                	push   $0x2f
  801876:	e8 a7 f9 ff ff       	call   801222 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801886:	8d 45 10             	lea    0x10(%ebp),%eax
  801889:	83 c0 04             	add    $0x4,%eax
  80188c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80188f:	a1 58 a2 82 00       	mov    0x82a258,%eax
  801894:	85 c0                	test   %eax,%eax
  801896:	74 16                	je     8018ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  801898:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	50                   	push   %eax
  8018a1:	68 ac 22 80 00       	push   $0x8022ac
  8018a6:	e8 b0 ea ff ff       	call   80035b <cprintf>
  8018ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018ae:	a1 00 30 80 00       	mov    0x803000,%eax
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	68 b1 22 80 00       	push   $0x8022b1
  8018bf:	e8 97 ea ff ff       	call   80035b <cprintf>
  8018c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8018c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d0:	50                   	push   %eax
  8018d1:	e8 1a ea ff ff       	call   8002f0 <vcprintf>
  8018d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	6a 00                	push   $0x0
  8018de:	68 cd 22 80 00       	push   $0x8022cd
  8018e3:	e8 08 ea ff ff       	call   8002f0 <vcprintf>
  8018e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018eb:	e8 89 e9 ff ff       	call   800279 <exit>

	// should not return here
	while (1) ;
  8018f0:	eb fe                	jmp    8018f0 <_panic+0x70>

008018f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8018fd:	8b 50 74             	mov    0x74(%eax),%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	39 c2                	cmp    %eax,%edx
  801905:	74 14                	je     80191b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 d0 22 80 00       	push   $0x8022d0
  80190f:	6a 26                	push   $0x26
  801911:	68 1c 23 80 00       	push   $0x80231c
  801916:	e8 65 ff ff ff       	call   801880 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80191b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801922:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801929:	e9 c2 00 00 00       	jmp    8019f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	8b 00                	mov    (%eax),%eax
  80193f:	85 c0                	test   %eax,%eax
  801941:	75 08                	jne    80194b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801943:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801946:	e9 a2 00 00 00       	jmp    8019ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80194b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801952:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801959:	eb 69                	jmp    8019c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80195b:	a1 20 30 80 00       	mov    0x803020,%eax
  801960:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801966:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801969:	89 d0                	mov    %edx,%eax
  80196b:	01 c0                	add    %eax,%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	c1 e0 03             	shl    $0x3,%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 40 04             	mov    0x4(%eax),%al
  801977:	84 c0                	test   %al,%al
  801979:	75 46                	jne    8019c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80197b:	a1 20 30 80 00       	mov    0x803020,%eax
  801980:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801986:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801989:	89 d0                	mov    %edx,%eax
  80198b:	01 c0                	add    %eax,%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c1 e0 03             	shl    $0x3,%eax
  801992:	01 c8                	add    %ecx,%eax
  801994:	8b 00                	mov    (%eax),%eax
  801996:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801999:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80199c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	01 c8                	add    %ecx,%eax
  8019b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019b4:	39 c2                	cmp    %eax,%edx
  8019b6:	75 09                	jne    8019c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8019b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019bf:	eb 12                	jmp    8019d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019c1:	ff 45 e8             	incl   -0x18(%ebp)
  8019c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8019c9:	8b 50 74             	mov    0x74(%eax),%edx
  8019cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019cf:	39 c2                	cmp    %eax,%edx
  8019d1:	77 88                	ja     80195b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019d7:	75 14                	jne    8019ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 28 23 80 00       	push   $0x802328
  8019e1:	6a 3a                	push   $0x3a
  8019e3:	68 1c 23 80 00       	push   $0x80231c
  8019e8:	e8 93 fe ff ff       	call   801880 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019ed:	ff 45 f0             	incl   -0x10(%ebp)
  8019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019f6:	0f 8c 32 ff ff ff    	jl     80192e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a0a:	eb 26                	jmp    801a32 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a0c:	a1 20 30 80 00       	mov    0x803020,%eax
  801a11:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	01 c0                	add    %eax,%eax
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	c1 e0 03             	shl    $0x3,%eax
  801a23:	01 c8                	add    %ecx,%eax
  801a25:	8a 40 04             	mov    0x4(%eax),%al
  801a28:	3c 01                	cmp    $0x1,%al
  801a2a:	75 03                	jne    801a2f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801a2c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a2f:	ff 45 e0             	incl   -0x20(%ebp)
  801a32:	a1 20 30 80 00       	mov    0x803020,%eax
  801a37:	8b 50 74             	mov    0x74(%eax),%edx
  801a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3d:	39 c2                	cmp    %eax,%edx
  801a3f:	77 cb                	ja     801a0c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a44:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a47:	74 14                	je     801a5d <CheckWSWithoutLastIndex+0x16b>
		panic(
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 7c 23 80 00       	push   $0x80237c
  801a51:	6a 44                	push   $0x44
  801a53:	68 1c 23 80 00       	push   $0x80231c
  801a58:	e8 23 fe ff ff       	call   801880 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a5d:	90                   	nop
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <__udivdi3>:
  801a60:	55                   	push   %ebp
  801a61:	57                   	push   %edi
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 1c             	sub    $0x1c,%esp
  801a67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a77:	89 ca                	mov    %ecx,%edx
  801a79:	89 f8                	mov    %edi,%eax
  801a7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a7f:	85 f6                	test   %esi,%esi
  801a81:	75 2d                	jne    801ab0 <__udivdi3+0x50>
  801a83:	39 cf                	cmp    %ecx,%edi
  801a85:	77 65                	ja     801aec <__udivdi3+0x8c>
  801a87:	89 fd                	mov    %edi,%ebp
  801a89:	85 ff                	test   %edi,%edi
  801a8b:	75 0b                	jne    801a98 <__udivdi3+0x38>
  801a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a92:	31 d2                	xor    %edx,%edx
  801a94:	f7 f7                	div    %edi
  801a96:	89 c5                	mov    %eax,%ebp
  801a98:	31 d2                	xor    %edx,%edx
  801a9a:	89 c8                	mov    %ecx,%eax
  801a9c:	f7 f5                	div    %ebp
  801a9e:	89 c1                	mov    %eax,%ecx
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	f7 f5                	div    %ebp
  801aa4:	89 cf                	mov    %ecx,%edi
  801aa6:	89 fa                	mov    %edi,%edx
  801aa8:	83 c4 1c             	add    $0x1c,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
  801ab0:	39 ce                	cmp    %ecx,%esi
  801ab2:	77 28                	ja     801adc <__udivdi3+0x7c>
  801ab4:	0f bd fe             	bsr    %esi,%edi
  801ab7:	83 f7 1f             	xor    $0x1f,%edi
  801aba:	75 40                	jne    801afc <__udivdi3+0x9c>
  801abc:	39 ce                	cmp    %ecx,%esi
  801abe:	72 0a                	jb     801aca <__udivdi3+0x6a>
  801ac0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ac4:	0f 87 9e 00 00 00    	ja     801b68 <__udivdi3+0x108>
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	89 fa                	mov    %edi,%edx
  801ad1:	83 c4 1c             	add    $0x1c,%esp
  801ad4:	5b                   	pop    %ebx
  801ad5:	5e                   	pop    %esi
  801ad6:	5f                   	pop    %edi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
  801ad9:	8d 76 00             	lea    0x0(%esi),%esi
  801adc:	31 ff                	xor    %edi,%edi
  801ade:	31 c0                	xor    %eax,%eax
  801ae0:	89 fa                	mov    %edi,%edx
  801ae2:	83 c4 1c             	add    $0x1c,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	f7 f7                	div    %edi
  801af0:	31 ff                	xor    %edi,%edi
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b01:	89 eb                	mov    %ebp,%ebx
  801b03:	29 fb                	sub    %edi,%ebx
  801b05:	89 f9                	mov    %edi,%ecx
  801b07:	d3 e6                	shl    %cl,%esi
  801b09:	89 c5                	mov    %eax,%ebp
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 ed                	shr    %cl,%ebp
  801b0f:	89 e9                	mov    %ebp,%ecx
  801b11:	09 f1                	or     %esi,%ecx
  801b13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b17:	89 f9                	mov    %edi,%ecx
  801b19:	d3 e0                	shl    %cl,%eax
  801b1b:	89 c5                	mov    %eax,%ebp
  801b1d:	89 d6                	mov    %edx,%esi
  801b1f:	88 d9                	mov    %bl,%cl
  801b21:	d3 ee                	shr    %cl,%esi
  801b23:	89 f9                	mov    %edi,%ecx
  801b25:	d3 e2                	shl    %cl,%edx
  801b27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2b:	88 d9                	mov    %bl,%cl
  801b2d:	d3 e8                	shr    %cl,%eax
  801b2f:	09 c2                	or     %eax,%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	89 f2                	mov    %esi,%edx
  801b35:	f7 74 24 0c          	divl   0xc(%esp)
  801b39:	89 d6                	mov    %edx,%esi
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	f7 e5                	mul    %ebp
  801b3f:	39 d6                	cmp    %edx,%esi
  801b41:	72 19                	jb     801b5c <__udivdi3+0xfc>
  801b43:	74 0b                	je     801b50 <__udivdi3+0xf0>
  801b45:	89 d8                	mov    %ebx,%eax
  801b47:	31 ff                	xor    %edi,%edi
  801b49:	e9 58 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b54:	89 f9                	mov    %edi,%ecx
  801b56:	d3 e2                	shl    %cl,%edx
  801b58:	39 c2                	cmp    %eax,%edx
  801b5a:	73 e9                	jae    801b45 <__udivdi3+0xe5>
  801b5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b5f:	31 ff                	xor    %edi,%edi
  801b61:	e9 40 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b66:	66 90                	xchg   %ax,%ax
  801b68:	31 c0                	xor    %eax,%eax
  801b6a:	e9 37 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b6f:	90                   	nop

00801b70 <__umoddi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b8f:	89 f3                	mov    %esi,%ebx
  801b91:	89 fa                	mov    %edi,%edx
  801b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b97:	89 34 24             	mov    %esi,(%esp)
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	75 1a                	jne    801bb8 <__umoddi3+0x48>
  801b9e:	39 f7                	cmp    %esi,%edi
  801ba0:	0f 86 a2 00 00 00    	jbe    801c48 <__umoddi3+0xd8>
  801ba6:	89 c8                	mov    %ecx,%eax
  801ba8:	89 f2                	mov    %esi,%edx
  801baa:	f7 f7                	div    %edi
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	31 d2                	xor    %edx,%edx
  801bb0:	83 c4 1c             	add    $0x1c,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
  801bb8:	39 f0                	cmp    %esi,%eax
  801bba:	0f 87 ac 00 00 00    	ja     801c6c <__umoddi3+0xfc>
  801bc0:	0f bd e8             	bsr    %eax,%ebp
  801bc3:	83 f5 1f             	xor    $0x1f,%ebp
  801bc6:	0f 84 ac 00 00 00    	je     801c78 <__umoddi3+0x108>
  801bcc:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd1:	29 ef                	sub    %ebp,%edi
  801bd3:	89 fe                	mov    %edi,%esi
  801bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bd9:	89 e9                	mov    %ebp,%ecx
  801bdb:	d3 e0                	shl    %cl,%eax
  801bdd:	89 d7                	mov    %edx,%edi
  801bdf:	89 f1                	mov    %esi,%ecx
  801be1:	d3 ef                	shr    %cl,%edi
  801be3:	09 c7                	or     %eax,%edi
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 e2                	shl    %cl,%edx
  801be9:	89 14 24             	mov    %edx,(%esp)
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	d3 e0                	shl    %cl,%eax
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bf6:	d3 e0                	shl    %cl,%eax
  801bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c00:	89 f1                	mov    %esi,%ecx
  801c02:	d3 e8                	shr    %cl,%eax
  801c04:	09 d0                	or     %edx,%eax
  801c06:	d3 eb                	shr    %cl,%ebx
  801c08:	89 da                	mov    %ebx,%edx
  801c0a:	f7 f7                	div    %edi
  801c0c:	89 d3                	mov    %edx,%ebx
  801c0e:	f7 24 24             	mull   (%esp)
  801c11:	89 c6                	mov    %eax,%esi
  801c13:	89 d1                	mov    %edx,%ecx
  801c15:	39 d3                	cmp    %edx,%ebx
  801c17:	0f 82 87 00 00 00    	jb     801ca4 <__umoddi3+0x134>
  801c1d:	0f 84 91 00 00 00    	je     801cb4 <__umoddi3+0x144>
  801c23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c27:	29 f2                	sub    %esi,%edx
  801c29:	19 cb                	sbb    %ecx,%ebx
  801c2b:	89 d8                	mov    %ebx,%eax
  801c2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c31:	d3 e0                	shl    %cl,%eax
  801c33:	89 e9                	mov    %ebp,%ecx
  801c35:	d3 ea                	shr    %cl,%edx
  801c37:	09 d0                	or     %edx,%eax
  801c39:	89 e9                	mov    %ebp,%ecx
  801c3b:	d3 eb                	shr    %cl,%ebx
  801c3d:	89 da                	mov    %ebx,%edx
  801c3f:	83 c4 1c             	add    $0x1c,%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5e                   	pop    %esi
  801c44:	5f                   	pop    %edi
  801c45:	5d                   	pop    %ebp
  801c46:	c3                   	ret    
  801c47:	90                   	nop
  801c48:	89 fd                	mov    %edi,%ebp
  801c4a:	85 ff                	test   %edi,%edi
  801c4c:	75 0b                	jne    801c59 <__umoddi3+0xe9>
  801c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c53:	31 d2                	xor    %edx,%edx
  801c55:	f7 f7                	div    %edi
  801c57:	89 c5                	mov    %eax,%ebp
  801c59:	89 f0                	mov    %esi,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f5                	div    %ebp
  801c5f:	89 c8                	mov    %ecx,%eax
  801c61:	f7 f5                	div    %ebp
  801c63:	89 d0                	mov    %edx,%eax
  801c65:	e9 44 ff ff ff       	jmp    801bae <__umoddi3+0x3e>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	89 c8                	mov    %ecx,%eax
  801c6e:	89 f2                	mov    %esi,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	3b 04 24             	cmp    (%esp),%eax
  801c7b:	72 06                	jb     801c83 <__umoddi3+0x113>
  801c7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c81:	77 0f                	ja     801c92 <__umoddi3+0x122>
  801c83:	89 f2                	mov    %esi,%edx
  801c85:	29 f9                	sub    %edi,%ecx
  801c87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c8b:	89 14 24             	mov    %edx,(%esp)
  801c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c96:	8b 14 24             	mov    (%esp),%edx
  801c99:	83 c4 1c             	add    $0x1c,%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
  801ca1:	8d 76 00             	lea    0x0(%esi),%esi
  801ca4:	2b 04 24             	sub    (%esp),%eax
  801ca7:	19 fa                	sbb    %edi,%edx
  801ca9:	89 d1                	mov    %edx,%ecx
  801cab:	89 c6                	mov    %eax,%esi
  801cad:	e9 71 ff ff ff       	jmp    801c23 <__umoddi3+0xb3>
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cb8:	72 ea                	jb     801ca4 <__umoddi3+0x134>
  801cba:	89 d9                	mov    %ebx,%ecx
  801cbc:	e9 62 ff ff ff       	jmp    801c23 <__umoddi3+0xb3>
