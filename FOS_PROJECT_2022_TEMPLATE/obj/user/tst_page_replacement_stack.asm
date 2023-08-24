
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	char arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 5a 13 00 00       	call   8013a8 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 f2 13 00 00       	call   801448 <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 80 1b 80 00       	push   $0x801b80
  800088:	e8 a5 04 00 00       	call   800532 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800097:	eb 2c                	jmp    8000c5 <_main+0x8d>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  800099:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8a 00                	mov    (%eax),%al
  8000a6:	3c ff                	cmp    $0xff,%al
  8000a8:	74 14                	je     8000be <_main+0x86>
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	68 b8 1b 80 00       	push   $0x801bb8
  8000b2:	6a 1a                	push   $0x1a
  8000b4:	68 e8 1b 80 00       	push   $0x801be8
  8000b9:	e8 c0 01 00 00       	call   80027e <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000be:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c5:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000cc:	7e cb                	jle    800099 <_main+0x61>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  9) panic("Unexpected extra/less pages have been added to page file");
  8000ce:	e8 75 13 00 00       	call   801448 <sys_pf_calculate_allocated_pages>
  8000d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d6:	83 f8 09             	cmp    $0x9,%eax
  8000d9:	74 14                	je     8000ef <_main+0xb7>
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	68 0c 1c 80 00       	push   $0x801c0c
  8000e3:	6a 1c                	push   $0x1c
  8000e5:	68 e8 1b 80 00       	push   $0x801be8
  8000ea:	e8 8f 01 00 00       	call   80027e <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000ef:	e8 b4 12 00 00       	call   8013a8 <sys_calculate_free_frames>
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	e8 c6 12 00 00       	call   8013c1 <sys_calculate_modified_frames>
  8000fb:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 48 1c 80 00       	push   $0x801c48
  80010d:	6a 1e                	push   $0x1e
  80010f:	68 e8 1b 80 00       	push   $0x801be8
  800114:	e8 65 01 00 00       	call   80027e <_panic>
	}

	cprintf("Congratulations: stack pages created, modified and read successfully!\n\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 ac 1c 80 00       	push   $0x801cac
  800121:	e8 0c 04 00 00       	call   800532 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp


	return;
  800129:	90                   	nop
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800135:	e8 4e 15 00 00       	call   801688 <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	01 d0                	add    %edx,%eax
  800146:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80014d:	01 c8                	add    %ecx,%eax
  80014f:	c1 e0 02             	shl    $0x2,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80015b:	01 c8                	add    %ecx,%eax
  80015d:	c1 e0 02             	shl    $0x2,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	c1 e0 02             	shl    $0x2,%eax
  800165:	01 d0                	add    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80016f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800174:	a1 20 30 80 00       	mov    0x803020,%eax
  800179:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80017f:	84 c0                	test   %al,%al
  800181:	74 0f                	je     800192 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	05 18 da 01 00       	add    $0x1da18,%eax
  80018d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800192:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800196:	7e 0a                	jle    8001a2 <libmain+0x73>
		binaryname = argv[0];
  800198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019b:	8b 00                	mov    (%eax),%eax
  80019d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	e8 88 fe ff ff       	call   800038 <_main>
  8001b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b3:	e8 dd 12 00 00       	call   801495 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 0c 1d 80 00       	push   $0x801d0c
  8001c0:	e8 6d 03 00 00       	call   800532 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cd:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8001d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d8:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	52                   	push   %edx
  8001e2:	50                   	push   %eax
  8001e3:	68 34 1d 80 00       	push   $0x801d34
  8001e8:	e8 45 03 00 00       	call   800532 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f5:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8001fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800200:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800211:	51                   	push   %ecx
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 5c 1d 80 00       	push   $0x801d5c
  800219:	e8 14 03 00 00       	call   800532 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800221:	a1 20 30 80 00       	mov    0x803020,%eax
  800226:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 b4 1d 80 00       	push   $0x801db4
  800235:	e8 f8 02 00 00       	call   800532 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	68 0c 1d 80 00       	push   $0x801d0c
  800245:	e8 e8 02 00 00       	call   800532 <cprintf>
  80024a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024d:	e8 5d 12 00 00       	call   8014af <sys_enable_interrupt>

	// exit gracefully
	exit();
  800252:	e8 19 00 00 00       	call   800270 <exit>
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	6a 00                	push   $0x0
  800265:	e8 ea 13 00 00       	call   801654 <sys_destroy_env>
  80026a:	83 c4 10             	add    $0x10,%esp
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <exit>:

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800276:	e8 3f 14 00 00       	call   8016ba <sys_exit_env>
}
  80027b:	90                   	nop
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800284:	8d 45 10             	lea    0x10(%ebp),%eax
  800287:	83 c0 04             	add    $0x4,%eax
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028d:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800292:	85 c0                	test   %eax,%eax
  800294:	74 16                	je     8002ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800296:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	50                   	push   %eax
  80029f:	68 c8 1d 80 00       	push   $0x801dc8
  8002a4:	e8 89 02 00 00       	call   800532 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ac:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	50                   	push   %eax
  8002b8:	68 cd 1d 80 00       	push   $0x801dcd
  8002bd:	e8 70 02 00 00       	call   800532 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	e8 f3 01 00 00       	call   8004c7 <vcprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	68 e9 1d 80 00       	push   $0x801de9
  8002e1:	e8 e1 01 00 00       	call   8004c7 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e9:	e8 82 ff ff ff       	call   800270 <exit>

	// should not return here
	while (1) ;
  8002ee:	eb fe                	jmp    8002ee <_panic+0x70>

008002f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fb:	8b 50 74             	mov    0x74(%eax),%edx
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	74 14                	je     800319 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 ec 1d 80 00       	push   $0x801dec
  80030d:	6a 26                	push   $0x26
  80030f:	68 38 1e 80 00       	push   $0x801e38
  800314:	e8 65 ff ff ff       	call   80027e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800319:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800320:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800327:	e9 c2 00 00 00       	jmp    8003ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	01 d0                	add    %edx,%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	85 c0                	test   %eax,%eax
  80033f:	75 08                	jne    800349 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800341:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800344:	e9 a2 00 00 00       	jmp    8003eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800349:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800350:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800357:	eb 69                	jmp    8003c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800359:	a1 20 30 80 00       	mov    0x803020,%eax
  80035e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800364:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	01 c0                	add    %eax,%eax
  80036b:	01 d0                	add    %edx,%eax
  80036d:	c1 e0 03             	shl    $0x3,%eax
  800370:	01 c8                	add    %ecx,%eax
  800372:	8a 40 04             	mov    0x4(%eax),%al
  800375:	84 c0                	test   %al,%al
  800377:	75 46                	jne    8003bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800379:	a1 20 30 80 00       	mov    0x803020,%eax
  80037e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800384:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	01 c0                	add    %eax,%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	c1 e0 03             	shl    $0x3,%eax
  800390:	01 c8                	add    %ecx,%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800397:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	75 09                	jne    8003bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bd:	eb 12                	jmp    8003d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bf:	ff 45 e8             	incl   -0x18(%ebp)
  8003c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	77 88                	ja     800359 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d5:	75 14                	jne    8003eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	68 44 1e 80 00       	push   $0x801e44
  8003df:	6a 3a                	push   $0x3a
  8003e1:	68 38 1e 80 00       	push   $0x801e38
  8003e6:	e8 93 fe ff ff       	call   80027e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003eb:	ff 45 f0             	incl   -0x10(%ebp)
  8003ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f4:	0f 8c 32 ff ff ff    	jl     80032c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800401:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800408:	eb 26                	jmp    800430 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040a:	a1 20 30 80 00       	mov    0x803020,%eax
  80040f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800418:	89 d0                	mov    %edx,%eax
  80041a:	01 c0                	add    %eax,%eax
  80041c:	01 d0                	add    %edx,%eax
  80041e:	c1 e0 03             	shl    $0x3,%eax
  800421:	01 c8                	add    %ecx,%eax
  800423:	8a 40 04             	mov    0x4(%eax),%al
  800426:	3c 01                	cmp    $0x1,%al
  800428:	75 03                	jne    80042d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042d:	ff 45 e0             	incl   -0x20(%ebp)
  800430:	a1 20 30 80 00       	mov    0x803020,%eax
  800435:	8b 50 74             	mov    0x74(%eax),%edx
  800438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043b:	39 c2                	cmp    %eax,%edx
  80043d:	77 cb                	ja     80040a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80043f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800442:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800445:	74 14                	je     80045b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 98 1e 80 00       	push   $0x801e98
  80044f:	6a 44                	push   $0x44
  800451:	68 38 1e 80 00       	push   $0x801e38
  800456:	e8 23 fe ff ff       	call   80027e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045b:	90                   	nop
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	8d 48 01             	lea    0x1(%eax),%ecx
  80046c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046f:	89 0a                	mov    %ecx,(%edx)
  800471:	8b 55 08             	mov    0x8(%ebp),%edx
  800474:	88 d1                	mov    %dl,%cl
  800476:	8b 55 0c             	mov    0xc(%ebp),%edx
  800479:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	3d ff 00 00 00       	cmp    $0xff,%eax
  800487:	75 2c                	jne    8004b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800489:	a0 24 30 80 00       	mov    0x803024,%al
  80048e:	0f b6 c0             	movzbl %al,%eax
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	8b 12                	mov    (%edx),%edx
  800496:	89 d1                	mov    %edx,%ecx
  800498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049b:	83 c2 08             	add    $0x8,%edx
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	50                   	push   %eax
  8004a2:	51                   	push   %ecx
  8004a3:	52                   	push   %edx
  8004a4:	e8 3e 0e 00 00       	call   8012e7 <sys_cputs>
  8004a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 40 04             	mov    0x4(%eax),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d7:	00 00 00 
	b.cnt = 0;
  8004da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e4:	ff 75 0c             	pushl  0xc(%ebp)
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f0:	50                   	push   %eax
  8004f1:	68 5e 04 80 00       	push   $0x80045e
  8004f6:	e8 11 02 00 00       	call   80070c <vprintfmt>
  8004fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004fe:	a0 24 30 80 00       	mov    0x803024,%al
  800503:	0f b6 c0             	movzbl %al,%eax
  800506:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	50                   	push   %eax
  800510:	52                   	push   %edx
  800511:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800517:	83 c0 08             	add    $0x8,%eax
  80051a:	50                   	push   %eax
  80051b:	e8 c7 0d 00 00       	call   8012e7 <sys_cputs>
  800520:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800523:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80052a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <cprintf>:

int cprintf(const char *fmt, ...) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800538:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80053f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800542:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	ff 75 f4             	pushl  -0xc(%ebp)
  80054e:	50                   	push   %eax
  80054f:	e8 73 ff ff ff       	call   8004c7 <vcprintf>
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800565:	e8 2b 0f 00 00       	call   801495 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	e8 48 ff ff ff       	call   8004c7 <vcprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800585:	e8 25 0f 00 00       	call   8014af <sys_enable_interrupt>
	return cnt;
  80058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	83 ec 14             	sub    $0x14,%esp
  800596:	8b 45 10             	mov    0x10(%ebp),%eax
  800599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ad:	77 55                	ja     800604 <printnum+0x75>
  8005af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b2:	72 05                	jb     8005b9 <printnum+0x2a>
  8005b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b7:	77 4b                	ja     800604 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	52                   	push   %edx
  8005c8:	50                   	push   %eax
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8005cf:	e8 48 13 00 00       	call   80191c <__udivdi3>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	83 ec 04             	sub    $0x4,%esp
  8005da:	ff 75 20             	pushl  0x20(%ebp)
  8005dd:	53                   	push   %ebx
  8005de:	ff 75 18             	pushl  0x18(%ebp)
  8005e1:	52                   	push   %edx
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 0c             	pushl  0xc(%ebp)
  8005e6:	ff 75 08             	pushl  0x8(%ebp)
  8005e9:	e8 a1 ff ff ff       	call   80058f <printnum>
  8005ee:	83 c4 20             	add    $0x20,%esp
  8005f1:	eb 1a                	jmp    80060d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 20             	pushl  0x20(%ebp)
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	ff d0                	call   *%eax
  800601:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800604:	ff 4d 1c             	decl   0x1c(%ebp)
  800607:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060b:	7f e6                	jg     8005f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800610:	bb 00 00 00 00       	mov    $0x0,%ebx
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061b:	53                   	push   %ebx
  80061c:	51                   	push   %ecx
  80061d:	52                   	push   %edx
  80061e:	50                   	push   %eax
  80061f:	e8 08 14 00 00       	call   801a2c <__umoddi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	05 14 21 80 00       	add    $0x802114,%eax
  80062c:	8a 00                	mov    (%eax),%al
  80062e:	0f be c0             	movsbl %al,%eax
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 0c             	pushl  0xc(%ebp)
  800637:	50                   	push   %eax
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	ff d0                	call   *%eax
  80063d:	83 c4 10             	add    $0x10,%esp
}
  800640:	90                   	nop
  800641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800649:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064d:	7e 1c                	jle    80066b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	8d 50 08             	lea    0x8(%eax),%edx
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	89 10                	mov    %edx,(%eax)
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	83 e8 08             	sub    $0x8,%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	eb 40                	jmp    8006ab <getuint+0x65>
	else if (lflag)
  80066b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066f:	74 1e                	je     80068f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	8d 50 04             	lea    0x4(%eax),%edx
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	89 10                	mov    %edx,(%eax)
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	83 e8 04             	sub    $0x4,%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	eb 1c                	jmp    8006ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	8d 50 04             	lea    0x4(%eax),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	89 10                	mov    %edx,(%eax)
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	83 e8 04             	sub    $0x4,%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ab:	5d                   	pop    %ebp
  8006ac:	c3                   	ret    

008006ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b4:	7e 1c                	jle    8006d2 <getint+0x25>
		return va_arg(*ap, long long);
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	8d 50 08             	lea    0x8(%eax),%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	89 10                	mov    %edx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	83 e8 08             	sub    $0x8,%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	eb 38                	jmp    80070a <getint+0x5d>
	else if (lflag)
  8006d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d6:	74 1a                	je     8006f2 <getint+0x45>
		return va_arg(*ap, long);
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 50 04             	lea    0x4(%eax),%edx
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	89 10                	mov    %edx,(%eax)
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	83 e8 04             	sub    $0x4,%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	99                   	cltd   
  8006f0:	eb 18                	jmp    80070a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 50 04             	lea    0x4(%eax),%edx
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	89 10                	mov    %edx,(%eax)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	83 e8 04             	sub    $0x4,%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	99                   	cltd   
}
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	56                   	push   %esi
  800710:	53                   	push   %ebx
  800711:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800714:	eb 17                	jmp    80072d <vprintfmt+0x21>
			if (ch == '\0')
  800716:	85 db                	test   %ebx,%ebx
  800718:	0f 84 af 03 00 00    	je     800acd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	53                   	push   %ebx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072d:	8b 45 10             	mov    0x10(%ebp),%eax
  800730:	8d 50 01             	lea    0x1(%eax),%edx
  800733:	89 55 10             	mov    %edx,0x10(%ebp)
  800736:	8a 00                	mov    (%eax),%al
  800738:	0f b6 d8             	movzbl %al,%ebx
  80073b:	83 fb 25             	cmp    $0x25,%ebx
  80073e:	75 d6                	jne    800716 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800740:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800744:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800752:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800759:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800760:	8b 45 10             	mov    0x10(%ebp),%eax
  800763:	8d 50 01             	lea    0x1(%eax),%edx
  800766:	89 55 10             	mov    %edx,0x10(%ebp)
  800769:	8a 00                	mov    (%eax),%al
  80076b:	0f b6 d8             	movzbl %al,%ebx
  80076e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800771:	83 f8 55             	cmp    $0x55,%eax
  800774:	0f 87 2b 03 00 00    	ja     800aa5 <vprintfmt+0x399>
  80077a:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  800781:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800783:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800787:	eb d7                	jmp    800760 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800789:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078d:	eb d1                	jmp    800760 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800796:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800799:	89 d0                	mov    %edx,%eax
  80079b:	c1 e0 02             	shl    $0x2,%eax
  80079e:	01 d0                	add    %edx,%eax
  8007a0:	01 c0                	add    %eax,%eax
  8007a2:	01 d8                	add    %ebx,%eax
  8007a4:	83 e8 30             	sub    $0x30,%eax
  8007a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	8a 00                	mov    (%eax),%al
  8007af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b5:	7e 3e                	jle    8007f5 <vprintfmt+0xe9>
  8007b7:	83 fb 39             	cmp    $0x39,%ebx
  8007ba:	7f 39                	jg     8007f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007bf:	eb d5                	jmp    800796 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d5:	eb 1f                	jmp    8007f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007db:	79 83                	jns    800760 <vprintfmt+0x54>
				width = 0;
  8007dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e4:	e9 77 ff ff ff       	jmp    800760 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f0:	e9 6b ff ff ff       	jmp    800760 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fa:	0f 89 60 ff ff ff    	jns    800760 <vprintfmt+0x54>
				width = precision, precision = -1;
  800800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800806:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080d:	e9 4e ff ff ff       	jmp    800760 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800812:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800815:	e9 46 ff ff ff       	jmp    800760 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 c0 04             	add    $0x4,%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	83 e8 04             	sub    $0x4,%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
			break;
  80083a:	e9 89 02 00 00       	jmp    800ac8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 e8 04             	sub    $0x4,%eax
  80084e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800850:	85 db                	test   %ebx,%ebx
  800852:	79 02                	jns    800856 <vprintfmt+0x14a>
				err = -err;
  800854:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800856:	83 fb 64             	cmp    $0x64,%ebx
  800859:	7f 0b                	jg     800866 <vprintfmt+0x15a>
  80085b:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  800862:	85 f6                	test   %esi,%esi
  800864:	75 19                	jne    80087f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800866:	53                   	push   %ebx
  800867:	68 25 21 80 00       	push   $0x802125
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	e8 5e 02 00 00       	call   800ad5 <printfmt>
  800877:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087a:	e9 49 02 00 00       	jmp    800ac8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087f:	56                   	push   %esi
  800880:	68 2e 21 80 00       	push   $0x80212e
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	e8 45 02 00 00       	call   800ad5 <printfmt>
  800890:	83 c4 10             	add    $0x10,%esp
			break;
  800893:	e9 30 02 00 00       	jmp    800ac8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 c0 04             	add    $0x4,%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 e8 04             	sub    $0x4,%eax
  8008a7:	8b 30                	mov    (%eax),%esi
  8008a9:	85 f6                	test   %esi,%esi
  8008ab:	75 05                	jne    8008b2 <vprintfmt+0x1a6>
				p = "(null)";
  8008ad:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  8008b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b6:	7e 6d                	jle    800925 <vprintfmt+0x219>
  8008b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bc:	74 67                	je     800925 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	50                   	push   %eax
  8008c5:	56                   	push   %esi
  8008c6:	e8 0c 03 00 00       	call   800bd7 <strnlen>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d1:	eb 16                	jmp    8008e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	ff d0                	call   *%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7f e4                	jg     8008d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ef:	eb 34                	jmp    800925 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f5:	74 1c                	je     800913 <vprintfmt+0x207>
  8008f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fa:	7e 05                	jle    800901 <vprintfmt+0x1f5>
  8008fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ff:	7e 12                	jle    800913 <vprintfmt+0x207>
					putch('?', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 3f                	push   $0x3f
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	eb 0f                	jmp    800922 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	53                   	push   %ebx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800922:	ff 4d e4             	decl   -0x1c(%ebp)
  800925:	89 f0                	mov    %esi,%eax
  800927:	8d 70 01             	lea    0x1(%eax),%esi
  80092a:	8a 00                	mov    (%eax),%al
  80092c:	0f be d8             	movsbl %al,%ebx
  80092f:	85 db                	test   %ebx,%ebx
  800931:	74 24                	je     800957 <vprintfmt+0x24b>
  800933:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800937:	78 b8                	js     8008f1 <vprintfmt+0x1e5>
  800939:	ff 4d e0             	decl   -0x20(%ebp)
  80093c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800940:	79 af                	jns    8008f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800942:	eb 13                	jmp    800957 <vprintfmt+0x24b>
				putch(' ', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 20                	push   $0x20
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	ff 4d e4             	decl   -0x1c(%ebp)
  800957:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095b:	7f e7                	jg     800944 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095d:	e9 66 01 00 00       	jmp    800ac8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 e8             	pushl  -0x18(%ebp)
  800968:	8d 45 14             	lea    0x14(%ebp),%eax
  80096b:	50                   	push   %eax
  80096c:	e8 3c fd ff ff       	call   8006ad <getint>
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800977:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800980:	85 d2                	test   %edx,%edx
  800982:	79 23                	jns    8009a7 <vprintfmt+0x29b>
				putch('-', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	6a 2d                	push   $0x2d
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099a:	f7 d8                	neg    %eax
  80099c:	83 d2 00             	adc    $0x0,%edx
  80099f:	f7 da                	neg    %edx
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ae:	e9 bc 00 00 00       	jmp    800a6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bc:	50                   	push   %eax
  8009bd:	e8 84 fc ff ff       	call   800646 <getuint>
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d2:	e9 98 00 00 00       	jmp    800a6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 58                	push   $0x58
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 58                	push   $0x58
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	6a 58                	push   $0x58
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	ff d0                	call   *%eax
  800a04:	83 c4 10             	add    $0x10,%esp
			break;
  800a07:	e9 bc 00 00 00       	jmp    800ac8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	6a 30                	push   $0x30
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 78                	push   $0x78
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	83 c0 04             	add    $0x4,%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 e8 04             	sub    $0x4,%eax
  800a3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4e:	eb 1f                	jmp    800a6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 e8             	pushl  -0x18(%ebp)
  800a56:	8d 45 14             	lea    0x14(%ebp),%eax
  800a59:	50                   	push   %eax
  800a5a:	e8 e7 fb ff ff       	call   800646 <getuint>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	52                   	push   %edx
  800a7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7d:	50                   	push   %eax
  800a7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a81:	ff 75 f0             	pushl  -0x10(%ebp)
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	ff 75 08             	pushl  0x8(%ebp)
  800a8a:	e8 00 fb ff ff       	call   80058f <printnum>
  800a8f:	83 c4 20             	add    $0x20,%esp
			break;
  800a92:	eb 34                	jmp    800ac8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			break;
  800aa3:	eb 23                	jmp    800ac8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	6a 25                	push   $0x25
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab5:	ff 4d 10             	decl   0x10(%ebp)
  800ab8:	eb 03                	jmp    800abd <vprintfmt+0x3b1>
  800aba:	ff 4d 10             	decl   0x10(%ebp)
  800abd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac0:	48                   	dec    %eax
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	3c 25                	cmp    $0x25,%al
  800ac5:	75 f3                	jne    800aba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac7:	90                   	nop
		}
	}
  800ac8:	e9 47 fc ff ff       	jmp    800714 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800acd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adb:	8d 45 10             	lea    0x10(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae7:	ff 75 f4             	pushl  -0xc(%ebp)
  800aea:	50                   	push   %eax
  800aeb:	ff 75 0c             	pushl  0xc(%ebp)
  800aee:	ff 75 08             	pushl  0x8(%ebp)
  800af1:	e8 16 fc ff ff       	call   80070c <vprintfmt>
  800af6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af9:	90                   	nop
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	8b 40 08             	mov    0x8(%eax),%eax
  800b05:	8d 50 01             	lea    0x1(%eax),%edx
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 10                	mov    (%eax),%edx
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8b 40 04             	mov    0x4(%eax),%eax
  800b19:	39 c2                	cmp    %eax,%edx
  800b1b:	73 12                	jae    800b2f <sprintputch+0x33>
		*b->buf++ = ch;
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	8d 48 01             	lea    0x1(%eax),%ecx
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b28:	89 0a                	mov    %ecx,(%edx)
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	88 10                	mov    %dl,(%eax)
}
  800b2f:	90                   	nop
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	01 d0                	add    %edx,%eax
  800b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b57:	74 06                	je     800b5f <vsnprintf+0x2d>
  800b59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5d:	7f 07                	jg     800b66 <vsnprintf+0x34>
		return -E_INVAL;
  800b5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b64:	eb 20                	jmp    800b86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b66:	ff 75 14             	pushl  0x14(%ebp)
  800b69:	ff 75 10             	pushl  0x10(%ebp)
  800b6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	68 fc 0a 80 00       	push   $0x800afc
  800b75:	e8 92 fb ff ff       	call   80070c <vprintfmt>
  800b7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9d:	50                   	push   %eax
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 08             	pushl  0x8(%ebp)
  800ba4:	e8 89 ff ff ff       	call   800b32 <vsnprintf>
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 06                	jmp    800bc9 <strlen+0x15>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	84 c0                	test   %al,%al
  800bd0:	75 f1                	jne    800bc3 <strlen+0xf>
		n++;
	return n;
  800bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 09                	jmp    800bef <strnlen+0x18>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	ff 4d 0c             	decl   0xc(%ebp)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 09                	je     800bfe <strnlen+0x27>
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	84 c0                	test   %al,%al
  800bfc:	75 e8                	jne    800be6 <strnlen+0xf>
		n++;
	return n;
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c0f:	90                   	nop
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8d 50 01             	lea    0x1(%eax),%edx
  800c16:	89 55 08             	mov    %edx,0x8(%ebp)
  800c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c22:	8a 12                	mov    (%edx),%dl
  800c24:	88 10                	mov    %dl,(%eax)
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	84 c0                	test   %al,%al
  800c2a:	75 e4                	jne    800c10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c44:	eb 1f                	jmp    800c65 <strncpy+0x34>
		*dst++ = *src;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8d 50 01             	lea    0x1(%eax),%edx
  800c4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c52:	8a 12                	mov    (%edx),%dl
  800c54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	84 c0                	test   %al,%al
  800c5d:	74 03                	je     800c62 <strncpy+0x31>
			src++;
  800c5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c62:	ff 45 fc             	incl   -0x4(%ebp)
  800c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6b:	72 d9                	jb     800c46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c82:	74 30                	je     800cb4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c84:	eb 16                	jmp    800c9c <strlcpy+0x2a>
			*dst++ = *src++;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8d 50 01             	lea    0x1(%eax),%edx
  800c8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c98:	8a 12                	mov    (%edx),%dl
  800c9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9c:	ff 4d 10             	decl   0x10(%ebp)
  800c9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca3:	74 09                	je     800cae <strlcpy+0x3c>
  800ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 d8                	jne    800c86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cba:	29 c2                	sub    %eax,%edx
  800cbc:	89 d0                	mov    %edx,%eax
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc3:	eb 06                	jmp    800ccb <strcmp+0xb>
		p++, q++;
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	74 0e                	je     800ce2 <strcmp+0x22>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 10                	mov    (%eax),%dl
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	38 c2                	cmp    %al,%dl
  800ce0:	74 e3                	je     800cc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 d0             	movzbl %al,%edx
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfb:	eb 09                	jmp    800d06 <strncmp+0xe>
		n--, p++, q++;
  800cfd:	ff 4d 10             	decl   0x10(%ebp)
  800d00:	ff 45 08             	incl   0x8(%ebp)
  800d03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0a:	74 17                	je     800d23 <strncmp+0x2b>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	84 c0                	test   %al,%al
  800d13:	74 0e                	je     800d23 <strncmp+0x2b>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 10                	mov    (%eax),%dl
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	38 c2                	cmp    %al,%dl
  800d21:	74 da                	je     800cfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d27:	75 07                	jne    800d30 <strncmp+0x38>
		return 0;
  800d29:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2e:	eb 14                	jmp    800d44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	0f b6 d0             	movzbl %al,%edx
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 c0             	movzbl %al,%eax
  800d40:	29 c2                	sub    %eax,%edx
  800d42:	89 d0                	mov    %edx,%eax
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 04             	sub    $0x4,%esp
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d52:	eb 12                	jmp    800d66 <strchr+0x20>
		if (*s == c)
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5c:	75 05                	jne    800d63 <strchr+0x1d>
			return (char *) s;
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	eb 11                	jmp    800d74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d63:	ff 45 08             	incl   0x8(%ebp)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	84 c0                	test   %al,%al
  800d6d:	75 e5                	jne    800d54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 04             	sub    $0x4,%esp
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d82:	eb 0d                	jmp    800d91 <strfind+0x1b>
		if (*s == c)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8c:	74 0e                	je     800d9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8e:	ff 45 08             	incl   0x8(%ebp)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 ea                	jne    800d84 <strfind+0xe>
  800d9a:	eb 01                	jmp    800d9d <strfind+0x27>
		if (*s == c)
			break;
  800d9c:	90                   	nop
	return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dae:	8b 45 10             	mov    0x10(%ebp),%eax
  800db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db4:	eb 0e                	jmp    800dc4 <memset+0x22>
		*p++ = c;
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc4:	ff 4d f8             	decl   -0x8(%ebp)
  800dc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcb:	79 e9                	jns    800db6 <memset+0x14>
		*p++ = c;

	return v;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de4:	eb 16                	jmp    800dfc <memcpy+0x2a>
		*d++ = *s++;
  800de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de9:	8d 50 01             	lea    0x1(%eax),%edx
  800dec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800def:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df8:	8a 12                	mov    (%edx),%dl
  800dfa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e02:	89 55 10             	mov    %edx,0x10(%ebp)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	75 dd                	jne    800de6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	73 50                	jae    800e78 <memmove+0x6a>
  800e28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	01 d0                	add    %edx,%eax
  800e30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e33:	76 43                	jbe    800e78 <memmove+0x6a>
		s += n;
  800e35:	8b 45 10             	mov    0x10(%ebp),%eax
  800e38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e41:	eb 10                	jmp    800e53 <memmove+0x45>
			*--d = *--s;
  800e43:	ff 4d f8             	decl   -0x8(%ebp)
  800e46:	ff 4d fc             	decl   -0x4(%ebp)
  800e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4c:	8a 10                	mov    (%eax),%dl
  800e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e53:	8b 45 10             	mov    0x10(%ebp),%eax
  800e56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e59:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	75 e3                	jne    800e43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e60:	eb 23                	jmp    800e85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e65:	8d 50 01             	lea    0x1(%eax),%edx
  800e68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e74:	8a 12                	mov    (%edx),%dl
  800e76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e81:	85 c0                	test   %eax,%eax
  800e83:	75 dd                	jne    800e62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9c:	eb 2a                	jmp    800ec8 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea1:	8a 10                	mov    (%eax),%dl
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	38 c2                	cmp    %al,%dl
  800eaa:	74 16                	je     800ec2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f b6 d0             	movzbl %al,%edx
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	0f b6 c0             	movzbl %al,%eax
  800ebc:	29 c2                	sub    %eax,%edx
  800ebe:	89 d0                	mov    %edx,%eax
  800ec0:	eb 18                	jmp    800eda <memcmp+0x50>
		s1++, s2++;
  800ec2:	ff 45 fc             	incl   -0x4(%ebp)
  800ec5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 c9                	jne    800e9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	01 d0                	add    %edx,%eax
  800eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eed:	eb 15                	jmp    800f04 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d0             	movzbl %al,%edx
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	39 c2                	cmp    %eax,%edx
  800eff:	74 0d                	je     800f0e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f01:	ff 45 08             	incl   0x8(%ebp)
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0a:	72 e3                	jb     800eef <memfind+0x13>
  800f0c:	eb 01                	jmp    800f0f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0e:	90                   	nop
	return (void *) s;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f28:	eb 03                	jmp    800f2d <strtol+0x19>
		s++;
  800f2a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 20                	cmp    $0x20,%al
  800f34:	74 f4                	je     800f2a <strtol+0x16>
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	3c 09                	cmp    $0x9,%al
  800f3d:	74 eb                	je     800f2a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 2b                	cmp    $0x2b,%al
  800f46:	75 05                	jne    800f4d <strtol+0x39>
		s++;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	eb 13                	jmp    800f60 <strtol+0x4c>
	else if (*s == '-')
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	3c 2d                	cmp    $0x2d,%al
  800f54:	75 0a                	jne    800f60 <strtol+0x4c>
		s++, neg = 1;
  800f56:	ff 45 08             	incl   0x8(%ebp)
  800f59:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	74 06                	je     800f6c <strtol+0x58>
  800f66:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6a:	75 20                	jne    800f8c <strtol+0x78>
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 30                	cmp    $0x30,%al
  800f73:	75 17                	jne    800f8c <strtol+0x78>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	40                   	inc    %eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 78                	cmp    $0x78,%al
  800f7d:	75 0d                	jne    800f8c <strtol+0x78>
		s += 2, base = 16;
  800f7f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f83:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8a:	eb 28                	jmp    800fb4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f90:	75 15                	jne    800fa7 <strtol+0x93>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 30                	cmp    $0x30,%al
  800f99:	75 0c                	jne    800fa7 <strtol+0x93>
		s++, base = 8;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa5:	eb 0d                	jmp    800fb4 <strtol+0xa0>
	else if (base == 0)
  800fa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fab:	75 07                	jne    800fb4 <strtol+0xa0>
		base = 10;
  800fad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	3c 2f                	cmp    $0x2f,%al
  800fbb:	7e 19                	jle    800fd6 <strtol+0xc2>
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	3c 39                	cmp    $0x39,%al
  800fc4:	7f 10                	jg     800fd6 <strtol+0xc2>
			dig = *s - '0';
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f be c0             	movsbl %al,%eax
  800fce:	83 e8 30             	sub    $0x30,%eax
  800fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd4:	eb 42                	jmp    801018 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 60                	cmp    $0x60,%al
  800fdd:	7e 19                	jle    800ff8 <strtol+0xe4>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 7a                	cmp    $0x7a,%al
  800fe6:	7f 10                	jg     800ff8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	0f be c0             	movsbl %al,%eax
  800ff0:	83 e8 57             	sub    $0x57,%eax
  800ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff6:	eb 20                	jmp    801018 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 40                	cmp    $0x40,%al
  800fff:	7e 39                	jle    80103a <strtol+0x126>
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	3c 5a                	cmp    $0x5a,%al
  801008:	7f 30                	jg     80103a <strtol+0x126>
			dig = *s - 'A' + 10;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	0f be c0             	movsbl %al,%eax
  801012:	83 e8 37             	sub    $0x37,%eax
  801015:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101e:	7d 19                	jge    801039 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102a:	89 c2                	mov    %eax,%edx
  80102c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102f:	01 d0                	add    %edx,%eax
  801031:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801034:	e9 7b ff ff ff       	jmp    800fb4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801039:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103e:	74 08                	je     801048 <strtol+0x134>
		*endptr = (char *) s;
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801048:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104c:	74 07                	je     801055 <strtol+0x141>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801051:	f7 d8                	neg    %eax
  801053:	eb 03                	jmp    801058 <strtol+0x144>
  801055:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <ltostr>:

void
ltostr(long value, char *str)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801067:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801072:	79 13                	jns    801087 <ltostr+0x2d>
	{
		neg = 1;
  801074:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801081:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801084:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80108f:	99                   	cltd   
  801090:	f7 f9                	idiv   %ecx
  801092:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801098:	8d 50 01             	lea    0x1(%eax),%edx
  80109b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109e:	89 c2                	mov    %eax,%edx
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	01 d0                	add    %edx,%eax
  8010a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a8:	83 c2 30             	add    $0x30,%edx
  8010ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b5:	f7 e9                	imul   %ecx
  8010b7:	c1 fa 02             	sar    $0x2,%edx
  8010ba:	89 c8                	mov    %ecx,%eax
  8010bc:	c1 f8 1f             	sar    $0x1f,%eax
  8010bf:	29 c2                	sub    %eax,%edx
  8010c1:	89 d0                	mov    %edx,%eax
  8010c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ce:	f7 e9                	imul   %ecx
  8010d0:	c1 fa 02             	sar    $0x2,%edx
  8010d3:	89 c8                	mov    %ecx,%eax
  8010d5:	c1 f8 1f             	sar    $0x1f,%eax
  8010d8:	29 c2                	sub    %eax,%edx
  8010da:	89 d0                	mov    %edx,%eax
  8010dc:	c1 e0 02             	shl    $0x2,%eax
  8010df:	01 d0                	add    %edx,%eax
  8010e1:	01 c0                	add    %eax,%eax
  8010e3:	29 c1                	sub    %eax,%ecx
  8010e5:	89 ca                	mov    %ecx,%edx
  8010e7:	85 d2                	test   %edx,%edx
  8010e9:	75 9c                	jne    801087 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	48                   	dec    %eax
  8010f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fd:	74 3d                	je     80113c <ltostr+0xe2>
		start = 1 ;
  8010ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801106:	eb 34                	jmp    80113c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	01 c2                	add    %eax,%edx
  80111d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	01 c8                	add    %ecx,%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801129:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	01 c2                	add    %eax,%edx
  801131:	8a 45 eb             	mov    -0x15(%ebp),%al
  801134:	88 02                	mov    %al,(%edx)
		start++ ;
  801136:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801139:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801142:	7c c4                	jl     801108 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801144:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80114f:	90                   	nop
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 54 fa ff ff       	call   800bb4 <strlen>
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801166:	ff 75 0c             	pushl  0xc(%ebp)
  801169:	e8 46 fa ff ff       	call   800bb4 <strlen>
  80116e:	83 c4 04             	add    $0x4,%esp
  801171:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 17                	jmp    80119b <strcconcat+0x49>
		final[s] = str1[s] ;
  801184:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 c2                	add    %eax,%edx
  80118c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	01 c8                	add    %ecx,%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801198:	ff 45 fc             	incl   -0x4(%ebp)
  80119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a1:	7c e1                	jl     801184 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b1:	eb 1f                	jmp    8011d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bc:	89 c2                	mov    %eax,%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 c2                	add    %eax,%edx
  8011c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	01 c8                	add    %ecx,%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011cf:	ff 45 f8             	incl   -0x8(%ebp)
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d8:	7c d9                	jl     8011b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e5:	90                   	nop
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	8b 00                	mov    (%eax),%eax
  8011f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120b:	eb 0c                	jmp    801219 <strsplit+0x31>
			*string++ = 0;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8d 50 01             	lea    0x1(%eax),%edx
  801213:	89 55 08             	mov    %edx,0x8(%ebp)
  801216:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	84 c0                	test   %al,%al
  801220:	74 18                	je     80123a <strsplit+0x52>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	0f be c0             	movsbl %al,%eax
  80122a:	50                   	push   %eax
  80122b:	ff 75 0c             	pushl  0xc(%ebp)
  80122e:	e8 13 fb ff ff       	call   800d46 <strchr>
  801233:	83 c4 08             	add    $0x8,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	75 d3                	jne    80120d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	84 c0                	test   %al,%al
  801241:	74 5a                	je     80129d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801243:	8b 45 14             	mov    0x14(%ebp),%eax
  801246:	8b 00                	mov    (%eax),%eax
  801248:	83 f8 0f             	cmp    $0xf,%eax
  80124b:	75 07                	jne    801254 <strsplit+0x6c>
		{
			return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	eb 66                	jmp    8012ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801254:	8b 45 14             	mov    0x14(%ebp),%eax
  801257:	8b 00                	mov    (%eax),%eax
  801259:	8d 48 01             	lea    0x1(%eax),%ecx
  80125c:	8b 55 14             	mov    0x14(%ebp),%edx
  80125f:	89 0a                	mov    %ecx,(%edx)
  801261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 c2                	add    %eax,%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801272:	eb 03                	jmp    801277 <strsplit+0x8f>
			string++;
  801274:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	74 8b                	je     80120b <strsplit+0x23>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	0f be c0             	movsbl %al,%eax
  801288:	50                   	push   %eax
  801289:	ff 75 0c             	pushl  0xc(%ebp)
  80128c:	e8 b5 fa ff ff       	call   800d46 <strchr>
  801291:	83 c4 08             	add    $0x8,%esp
  801294:	85 c0                	test   %eax,%eax
  801296:	74 dc                	je     801274 <strsplit+0x8c>
			string++;
	}
  801298:	e9 6e ff ff ff       	jmp    80120b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129e:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012d4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012d7:	cd 30                	int    $0x30
  8012d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	52                   	push   %edx
  8012ff:	ff 75 0c             	pushl  0xc(%ebp)
  801302:	50                   	push   %eax
  801303:	6a 00                	push   $0x0
  801305:	e8 b2 ff ff ff       	call   8012bc <syscall>
  80130a:	83 c4 18             	add    $0x18,%esp
}
  80130d:	90                   	nop
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <sys_cgetc>:

int
sys_cgetc(void)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 01                	push   $0x1
  80131f:	e8 98 ff ff ff       	call   8012bc <syscall>
  801324:	83 c4 18             	add    $0x18,%esp
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	52                   	push   %edx
  801339:	50                   	push   %eax
  80133a:	6a 05                	push   $0x5
  80133c:	e8 7b ff ff ff       	call   8012bc <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80134b:	8b 75 18             	mov    0x18(%ebp),%esi
  80134e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801351:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	51                   	push   %ecx
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	6a 06                	push   $0x6
  801361:	e8 56 ff ff ff       	call   8012bc <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136c:	5b                   	pop    %ebx
  80136d:	5e                   	pop    %esi
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801373:	8b 55 0c             	mov    0xc(%ebp),%edx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	52                   	push   %edx
  801380:	50                   	push   %eax
  801381:	6a 07                	push   $0x7
  801383:	e8 34 ff ff ff       	call   8012bc <syscall>
  801388:	83 c4 18             	add    $0x18,%esp
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	ff 75 08             	pushl  0x8(%ebp)
  80139c:	6a 08                	push   $0x8
  80139e:	e8 19 ff ff ff       	call   8012bc <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 09                	push   $0x9
  8013b7:	e8 00 ff ff ff       	call   8012bc <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 0a                	push   $0xa
  8013d0:	e8 e7 fe ff ff       	call   8012bc <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 0b                	push   $0xb
  8013e9:	e8 ce fe ff ff       	call   8012bc <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	ff 75 0c             	pushl  0xc(%ebp)
  8013ff:	ff 75 08             	pushl  0x8(%ebp)
  801402:	6a 0f                	push   $0xf
  801404:	e8 b3 fe ff ff       	call   8012bc <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
	return;
  80140c:	90                   	nop
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	6a 10                	push   $0x10
  801420:	e8 97 fe ff ff       	call   8012bc <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
	return ;
  801428:	90                   	nop
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	ff 75 10             	pushl  0x10(%ebp)
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	6a 11                	push   $0x11
  80143d:	e8 7a fe ff ff       	call   8012bc <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
	return ;
  801445:	90                   	nop
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 0c                	push   $0xc
  801457:	e8 60 fe ff ff       	call   8012bc <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	6a 0d                	push   $0xd
  801471:	e8 46 fe ff ff       	call   8012bc <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 0e                	push   $0xe
  80148a:	e8 2d fe ff ff       	call   8012bc <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 13                	push   $0x13
  8014a4:	e8 13 fe ff ff       	call   8012bc <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 14                	push   $0x14
  8014be:	e8 f9 fd ff ff       	call   8012bc <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	50                   	push   %eax
  8014e2:	6a 15                	push   $0x15
  8014e4:	e8 d3 fd ff ff       	call   8012bc <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 16                	push   $0x16
  8014fe:	e8 b9 fd ff ff       	call   8012bc <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	6a 17                	push   $0x17
  80151b:	e8 9c fd ff ff       	call   8012bc <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	52                   	push   %edx
  801535:	50                   	push   %eax
  801536:	6a 1a                	push   $0x1a
  801538:	e8 7f fd ff ff       	call   8012bc <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 18                	push   $0x18
  801555:	e8 62 fd ff ff       	call   8012bc <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	90                   	nop
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	6a 19                	push   $0x19
  801573:	e8 44 fd ff ff       	call   8012bc <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	90                   	nop
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	8b 45 10             	mov    0x10(%ebp),%eax
  801587:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80158a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80158d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	6a 00                	push   $0x0
  801596:	51                   	push   %ecx
  801597:	52                   	push   %edx
  801598:	ff 75 0c             	pushl  0xc(%ebp)
  80159b:	50                   	push   %eax
  80159c:	6a 1b                	push   $0x1b
  80159e:	e8 19 fd ff ff       	call   8012bc <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	52                   	push   %edx
  8015b8:	50                   	push   %eax
  8015b9:	6a 1c                	push   $0x1c
  8015bb:	e8 fc fc ff ff       	call   8012bc <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	51                   	push   %ecx
  8015d6:	52                   	push   %edx
  8015d7:	50                   	push   %eax
  8015d8:	6a 1d                	push   $0x1d
  8015da:	e8 dd fc ff ff       	call   8012bc <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	6a 1e                	push   $0x1e
  8015f7:	e8 c0 fc ff ff       	call   8012bc <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 1f                	push   $0x1f
  801610:	e8 a7 fc ff ff       	call   8012bc <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	6a 00                	push   $0x0
  801622:	ff 75 14             	pushl  0x14(%ebp)
  801625:	ff 75 10             	pushl  0x10(%ebp)
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	50                   	push   %eax
  80162c:	6a 20                	push   $0x20
  80162e:	e8 89 fc ff ff       	call   8012bc <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	50                   	push   %eax
  801647:	6a 21                	push   $0x21
  801649:	e8 6e fc ff ff       	call   8012bc <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	90                   	nop
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	50                   	push   %eax
  801663:	6a 22                	push   $0x22
  801665:	e8 52 fc ff ff       	call   8012bc <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 02                	push   $0x2
  80167e:	e8 39 fc ff ff       	call   8012bc <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 03                	push   $0x3
  801697:	e8 20 fc ff ff       	call   8012bc <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 04                	push   $0x4
  8016b0:	e8 07 fc ff ff       	call   8012bc <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_exit_env>:


void sys_exit_env(void)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 23                	push   $0x23
  8016c9:	e8 ee fb ff ff       	call   8012bc <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016dd:	8d 50 04             	lea    0x4(%eax),%edx
  8016e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	6a 24                	push   $0x24
  8016ed:	e8 ca fb ff ff       	call   8012bc <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
	return result;
  8016f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fe:	89 01                	mov    %eax,(%ecx)
  801700:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	c9                   	leave  
  801707:	c2 04 00             	ret    $0x4

0080170a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	ff 75 10             	pushl  0x10(%ebp)
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	6a 12                	push   $0x12
  80171c:	e8 9b fb ff ff       	call   8012bc <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
	return ;
  801724:	90                   	nop
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_rcr2>:
uint32 sys_rcr2()
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 25                	push   $0x25
  801736:	e8 81 fb ff ff       	call   8012bc <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80174c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	50                   	push   %eax
  801759:	6a 26                	push   $0x26
  80175b:	e8 5c fb ff ff       	call   8012bc <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
	return ;
  801763:	90                   	nop
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <rsttst>:
void rsttst()
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 28                	push   $0x28
  801775:	e8 42 fb ff ff       	call   8012bc <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
	return ;
  80177d:	90                   	nop
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	8b 45 14             	mov    0x14(%ebp),%eax
  801789:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80178c:	8b 55 18             	mov    0x18(%ebp),%edx
  80178f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801793:	52                   	push   %edx
  801794:	50                   	push   %eax
  801795:	ff 75 10             	pushl  0x10(%ebp)
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	6a 27                	push   $0x27
  8017a0:	e8 17 fb ff ff       	call   8012bc <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a8:	90                   	nop
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <chktst>:
void chktst(uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	ff 75 08             	pushl  0x8(%ebp)
  8017b9:	6a 29                	push   $0x29
  8017bb:	e8 fc fa ff ff       	call   8012bc <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c3:	90                   	nop
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <inctst>:

void inctst()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 2a                	push   $0x2a
  8017d5:	e8 e2 fa ff ff       	call   8012bc <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <gettst>:
uint32 gettst()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 2b                	push   $0x2b
  8017ef:	e8 c8 fa ff ff       	call   8012bc <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 2c                	push   $0x2c
  80180b:	e8 ac fa ff ff       	call   8012bc <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
  801813:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801816:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80181a:	75 07                	jne    801823 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80181c:	b8 01 00 00 00       	mov    $0x1,%eax
  801821:	eb 05                	jmp    801828 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801823:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 2c                	push   $0x2c
  80183c:	e8 7b fa ff ff       	call   8012bc <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
  801844:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801847:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80184b:	75 07                	jne    801854 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80184d:	b8 01 00 00 00       	mov    $0x1,%eax
  801852:	eb 05                	jmp    801859 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 2c                	push   $0x2c
  80186d:	e8 4a fa ff ff       	call   8012bc <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
  801875:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801878:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80187c:	75 07                	jne    801885 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80187e:	b8 01 00 00 00       	mov    $0x1,%eax
  801883:	eb 05                	jmp    80188a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 2c                	push   $0x2c
  80189e:	e8 19 fa ff ff       	call   8012bc <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
  8018a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018a9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018ad:	75 07                	jne    8018b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018af:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b4:	eb 05                	jmp    8018bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 2d                	push   $0x2d
  8018cd:	e8 ea f9 ff ff       	call   8012bc <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	53                   	push   %ebx
  8018eb:	51                   	push   %ecx
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	6a 2e                	push   $0x2e
  8018f0:	e8 c7 f9 ff ff       	call   8012bc <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 2f                	push   $0x2f
  801910:	e8 a7 f9 ff ff       	call   8012bc <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    
  80191a:	66 90                	xchg   %ax,%ax

0080191c <__udivdi3>:
  80191c:	55                   	push   %ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	83 ec 1c             	sub    $0x1c,%esp
  801923:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801927:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80192b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80192f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801933:	89 ca                	mov    %ecx,%edx
  801935:	89 f8                	mov    %edi,%eax
  801937:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80193b:	85 f6                	test   %esi,%esi
  80193d:	75 2d                	jne    80196c <__udivdi3+0x50>
  80193f:	39 cf                	cmp    %ecx,%edi
  801941:	77 65                	ja     8019a8 <__udivdi3+0x8c>
  801943:	89 fd                	mov    %edi,%ebp
  801945:	85 ff                	test   %edi,%edi
  801947:	75 0b                	jne    801954 <__udivdi3+0x38>
  801949:	b8 01 00 00 00       	mov    $0x1,%eax
  80194e:	31 d2                	xor    %edx,%edx
  801950:	f7 f7                	div    %edi
  801952:	89 c5                	mov    %eax,%ebp
  801954:	31 d2                	xor    %edx,%edx
  801956:	89 c8                	mov    %ecx,%eax
  801958:	f7 f5                	div    %ebp
  80195a:	89 c1                	mov    %eax,%ecx
  80195c:	89 d8                	mov    %ebx,%eax
  80195e:	f7 f5                	div    %ebp
  801960:	89 cf                	mov    %ecx,%edi
  801962:	89 fa                	mov    %edi,%edx
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
  80196c:	39 ce                	cmp    %ecx,%esi
  80196e:	77 28                	ja     801998 <__udivdi3+0x7c>
  801970:	0f bd fe             	bsr    %esi,%edi
  801973:	83 f7 1f             	xor    $0x1f,%edi
  801976:	75 40                	jne    8019b8 <__udivdi3+0x9c>
  801978:	39 ce                	cmp    %ecx,%esi
  80197a:	72 0a                	jb     801986 <__udivdi3+0x6a>
  80197c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801980:	0f 87 9e 00 00 00    	ja     801a24 <__udivdi3+0x108>
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
  80198b:	89 fa                	mov    %edi,%edx
  80198d:	83 c4 1c             	add    $0x1c,%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5f                   	pop    %edi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    
  801995:	8d 76 00             	lea    0x0(%esi),%esi
  801998:	31 ff                	xor    %edi,%edi
  80199a:	31 c0                	xor    %eax,%eax
  80199c:	89 fa                	mov    %edi,%edx
  80199e:	83 c4 1c             	add    $0x1c,%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5f                   	pop    %edi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    
  8019a6:	66 90                	xchg   %ax,%ax
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	f7 f7                	div    %edi
  8019ac:	31 ff                	xor    %edi,%edi
  8019ae:	89 fa                	mov    %edi,%edx
  8019b0:	83 c4 1c             	add    $0x1c,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5f                   	pop    %edi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    
  8019b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019bd:	89 eb                	mov    %ebp,%ebx
  8019bf:	29 fb                	sub    %edi,%ebx
  8019c1:	89 f9                	mov    %edi,%ecx
  8019c3:	d3 e6                	shl    %cl,%esi
  8019c5:	89 c5                	mov    %eax,%ebp
  8019c7:	88 d9                	mov    %bl,%cl
  8019c9:	d3 ed                	shr    %cl,%ebp
  8019cb:	89 e9                	mov    %ebp,%ecx
  8019cd:	09 f1                	or     %esi,%ecx
  8019cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d3:	89 f9                	mov    %edi,%ecx
  8019d5:	d3 e0                	shl    %cl,%eax
  8019d7:	89 c5                	mov    %eax,%ebp
  8019d9:	89 d6                	mov    %edx,%esi
  8019db:	88 d9                	mov    %bl,%cl
  8019dd:	d3 ee                	shr    %cl,%esi
  8019df:	89 f9                	mov    %edi,%ecx
  8019e1:	d3 e2                	shl    %cl,%edx
  8019e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e7:	88 d9                	mov    %bl,%cl
  8019e9:	d3 e8                	shr    %cl,%eax
  8019eb:	09 c2                	or     %eax,%edx
  8019ed:	89 d0                	mov    %edx,%eax
  8019ef:	89 f2                	mov    %esi,%edx
  8019f1:	f7 74 24 0c          	divl   0xc(%esp)
  8019f5:	89 d6                	mov    %edx,%esi
  8019f7:	89 c3                	mov    %eax,%ebx
  8019f9:	f7 e5                	mul    %ebp
  8019fb:	39 d6                	cmp    %edx,%esi
  8019fd:	72 19                	jb     801a18 <__udivdi3+0xfc>
  8019ff:	74 0b                	je     801a0c <__udivdi3+0xf0>
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	31 ff                	xor    %edi,%edi
  801a05:	e9 58 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a10:	89 f9                	mov    %edi,%ecx
  801a12:	d3 e2                	shl    %cl,%edx
  801a14:	39 c2                	cmp    %eax,%edx
  801a16:	73 e9                	jae    801a01 <__udivdi3+0xe5>
  801a18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a1b:	31 ff                	xor    %edi,%edi
  801a1d:	e9 40 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a22:	66 90                	xchg   %ax,%ax
  801a24:	31 c0                	xor    %eax,%eax
  801a26:	e9 37 ff ff ff       	jmp    801962 <__udivdi3+0x46>
  801a2b:	90                   	nop

00801a2c <__umoddi3>:
  801a2c:	55                   	push   %ebp
  801a2d:	57                   	push   %edi
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 1c             	sub    $0x1c,%esp
  801a33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a4b:	89 f3                	mov    %esi,%ebx
  801a4d:	89 fa                	mov    %edi,%edx
  801a4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a53:	89 34 24             	mov    %esi,(%esp)
  801a56:	85 c0                	test   %eax,%eax
  801a58:	75 1a                	jne    801a74 <__umoddi3+0x48>
  801a5a:	39 f7                	cmp    %esi,%edi
  801a5c:	0f 86 a2 00 00 00    	jbe    801b04 <__umoddi3+0xd8>
  801a62:	89 c8                	mov    %ecx,%eax
  801a64:	89 f2                	mov    %esi,%edx
  801a66:	f7 f7                	div    %edi
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	31 d2                	xor    %edx,%edx
  801a6c:	83 c4 1c             	add    $0x1c,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5f                   	pop    %edi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
  801a74:	39 f0                	cmp    %esi,%eax
  801a76:	0f 87 ac 00 00 00    	ja     801b28 <__umoddi3+0xfc>
  801a7c:	0f bd e8             	bsr    %eax,%ebp
  801a7f:	83 f5 1f             	xor    $0x1f,%ebp
  801a82:	0f 84 ac 00 00 00    	je     801b34 <__umoddi3+0x108>
  801a88:	bf 20 00 00 00       	mov    $0x20,%edi
  801a8d:	29 ef                	sub    %ebp,%edi
  801a8f:	89 fe                	mov    %edi,%esi
  801a91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a95:	89 e9                	mov    %ebp,%ecx
  801a97:	d3 e0                	shl    %cl,%eax
  801a99:	89 d7                	mov    %edx,%edi
  801a9b:	89 f1                	mov    %esi,%ecx
  801a9d:	d3 ef                	shr    %cl,%edi
  801a9f:	09 c7                	or     %eax,%edi
  801aa1:	89 e9                	mov    %ebp,%ecx
  801aa3:	d3 e2                	shl    %cl,%edx
  801aa5:	89 14 24             	mov    %edx,(%esp)
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	d3 e0                	shl    %cl,%eax
  801aac:	89 c2                	mov    %eax,%edx
  801aae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab2:	d3 e0                	shl    %cl,%eax
  801ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abc:	89 f1                	mov    %esi,%ecx
  801abe:	d3 e8                	shr    %cl,%eax
  801ac0:	09 d0                	or     %edx,%eax
  801ac2:	d3 eb                	shr    %cl,%ebx
  801ac4:	89 da                	mov    %ebx,%edx
  801ac6:	f7 f7                	div    %edi
  801ac8:	89 d3                	mov    %edx,%ebx
  801aca:	f7 24 24             	mull   (%esp)
  801acd:	89 c6                	mov    %eax,%esi
  801acf:	89 d1                	mov    %edx,%ecx
  801ad1:	39 d3                	cmp    %edx,%ebx
  801ad3:	0f 82 87 00 00 00    	jb     801b60 <__umoddi3+0x134>
  801ad9:	0f 84 91 00 00 00    	je     801b70 <__umoddi3+0x144>
  801adf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ae3:	29 f2                	sub    %esi,%edx
  801ae5:	19 cb                	sbb    %ecx,%ebx
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801aed:	d3 e0                	shl    %cl,%eax
  801aef:	89 e9                	mov    %ebp,%ecx
  801af1:	d3 ea                	shr    %cl,%edx
  801af3:	09 d0                	or     %edx,%eax
  801af5:	89 e9                	mov    %ebp,%ecx
  801af7:	d3 eb                	shr    %cl,%ebx
  801af9:	89 da                	mov    %ebx,%edx
  801afb:	83 c4 1c             	add    $0x1c,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5f                   	pop    %edi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
  801b03:	90                   	nop
  801b04:	89 fd                	mov    %edi,%ebp
  801b06:	85 ff                	test   %edi,%edi
  801b08:	75 0b                	jne    801b15 <__umoddi3+0xe9>
  801b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0f:	31 d2                	xor    %edx,%edx
  801b11:	f7 f7                	div    %edi
  801b13:	89 c5                	mov    %eax,%ebp
  801b15:	89 f0                	mov    %esi,%eax
  801b17:	31 d2                	xor    %edx,%edx
  801b19:	f7 f5                	div    %ebp
  801b1b:	89 c8                	mov    %ecx,%eax
  801b1d:	f7 f5                	div    %ebp
  801b1f:	89 d0                	mov    %edx,%eax
  801b21:	e9 44 ff ff ff       	jmp    801a6a <__umoddi3+0x3e>
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	89 c8                	mov    %ecx,%eax
  801b2a:	89 f2                	mov    %esi,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	3b 04 24             	cmp    (%esp),%eax
  801b37:	72 06                	jb     801b3f <__umoddi3+0x113>
  801b39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b3d:	77 0f                	ja     801b4e <__umoddi3+0x122>
  801b3f:	89 f2                	mov    %esi,%edx
  801b41:	29 f9                	sub    %edi,%ecx
  801b43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b47:	89 14 24             	mov    %edx,(%esp)
  801b4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b52:	8b 14 24             	mov    (%esp),%edx
  801b55:	83 c4 1c             	add    $0x1c,%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5f                   	pop    %edi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    
  801b5d:	8d 76 00             	lea    0x0(%esi),%esi
  801b60:	2b 04 24             	sub    (%esp),%eax
  801b63:	19 fa                	sbb    %edi,%edx
  801b65:	89 d1                	mov    %edx,%ecx
  801b67:	89 c6                	mov    %eax,%esi
  801b69:	e9 71 ff ff ff       	jmp    801adf <__umoddi3+0xb3>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b74:	72 ea                	jb     801b60 <__umoddi3+0x134>
  801b76:	89 d9                	mov    %ebx,%ecx
  801b78:	e9 62 ff ff ff       	jmp    801adf <__umoddi3+0xb3>
